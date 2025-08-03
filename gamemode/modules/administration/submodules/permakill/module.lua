MODULE.name = L("xxdd")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("xdd")
if SERVER then
    lia.command.add("charkill", {
        superAdminOnly = true,
        privilege = "Manage Characters",
        onRun = function(client)
            net.Start("OpenPKMenu")
            net.WriteBool(false)
            net.Send(client)
        end
    })

    lia.command.add("viewpermakills", {
        superAdminOnly = true,
        privilege = "Manage Characters",
        onRun = function(client)
            lia.db.query("SELECT * FROM lia_permakills", function(data)
                net.Start("OpenPKViewer")
                net.WriteTable(data or {})
                net.Send(client)
            end)
        end
    })

    net.Receive("SubmitPKCase", function(_, client)
        local data = net.ReadTable()
        local isCharBan = net.ReadBool()
        lia.db.insertTable({
            player = data.player,
            reason = data.reason,
            steamID = data.steamID,
            submitterName = client:Name(),
            submitterSteamID = client:SteamID(),
            timestamp = os.time(),
            evidence = data.evidence
        }, nil, "permakills")

        for _, ply in player.Iterator() do
            if ply:SteamID() == data.steamID and ply:getChar() then
                if isCharBan then
                    ply:getChar():setBanned(-1)
                    ply:getChar():save()
                    ply:getChar():kick()
                else
                    ply:getChar():ban()
                end

                break
            end
        end
    end)

    function MODULE:CanPlayerUseChar(client, character)
        if character:isBanned() then
            net.Start("PK_Notice")
            net.WriteString(character:getName())
            net.Send(client)
            return false, L("bannedCharacter")
        end
    end
else
    net.Receive("OpenPKViewer", function()
        local cases = net.ReadTable()
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 400)
        frame:SetTitle("View PK Cases")
        frame:Center()
        frame:MakePopup()
        local searchBox = vgui.Create("DTextEntry", frame)
        searchBox:SetSize(280, 25)
        searchBox:SetPos(10, 30)
        searchBox:SetPlaceholderText("Search by player name...")
        local caseList = vgui.Create("DListView", frame)
        caseList:SetSize(280, 300)
        caseList:SetPos(10, 60)
        caseList:AddColumn("Player")
        local function updateCaseList(filter)
            caseList:Clear()
            for _, c in ipairs(cases) do
                if string.match(c.player:lower(), filter:lower()) then caseList:AddLine(c.player) end
            end
        end

        updateCaseList("")
        searchBox.OnChange = function() updateCaseList(searchBox:GetText()) end
        caseList.OnRowSelected = function(_, _, line)
            local sel = line:GetColumnText(1)
            local detail
            for _, c in ipairs(cases) do
                if c.player == sel then
                    detail = c
                    break
                end
            end

            if detail then
                local df = vgui.Create("DFrame")
                df:SetSize(400, 400)
                df:SetTitle("PK Case Details")
                df:Center()
                df:MakePopup()
                local y = 30
                local function makeButton(txt, yOff, clip)
                    local btn = vgui.Create("DButton", df)
                    btn:SetPos(10, yOff)
                    btn:SetSize(380, 20)
                    btn:SetText(txt)
                    btn:SetCursor("hand")
                    btn:SetTextColor(Color(255, 255, 255))
                    btn.DoClick = function() SetClipboardText(clip) end
                    return btn
                end

                makeButton("Player: " .. detail.player, y, detail.player)
                y = y + 25
                makeButton("SteamID: " .. detail.steamID, y, detail.steamID)
                y = y + 25
                makeButton("Reason: " .. detail.reason, y, detail.reason)
                y = y + 25
                makeButton("Evidence: " .. detail.evidence, y, detail.evidence)
                y = y + 25
                makeButton("Submitter: " .. detail.submitterName, y, detail.submitterName)
                y = y + 25
                makeButton("Submitter SteamID: " .. detail.submitterSteamID, y, detail.submitterSteamID)
                y = y + 25
                makeButton("Timestamp: " .. os.date("%c", detail.timestamp), y, os.date("%c", detail.timestamp))
            end
        end
    end)

    net.Receive("OpenPKMenu", function(_)
        local isCharBan = net.ReadBool()
        local frame = vgui.Create("DFrame")
        frame:SetSize(600, 400)
        frame:SetTitle("PK Active Menu")
        frame:Center()
        frame:MakePopup()
        local elementWidth, elementHeight = 550, 25
        local function setTransparentStyle(element)
            element:SetTextColor(Color(255, 255, 255))
            element.Paint = function(self, w, h)
                surface.SetDrawColor(0, 0, 0, 0)
                surface.DrawRect(0, 0, w, h)
                if self:GetText() == "" then
                    draw.SimpleText(self:GetPlaceholderText(), "Default", 5, h / 2, Color(255, 255, 255, 128), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    self:DrawTextEntryText(self:GetTextColor(), Color(255, 255, 255), Color(255, 255, 255))
                end
            end
        end

        local allPlayers = {}
        for _, ply in ipairs(player.GetAll()) do
            allPlayers[#allPlayers + 1] = {
                name = ply:Nick(),
                steamid = ply:SteamID()
            }
        end

        local playerDropdown = vgui.Create("DComboBox", frame)
        playerDropdown:SetPos(20, 50)
        playerDropdown:SetSize(elementWidth, elementHeight)
        playerDropdown:SetValue("Select Player")
        for _, data in ipairs(allPlayers) do
            playerDropdown:AddChoice(data.name, data.steamid)
        end

        local reasonBox = vgui.Create("DTextEntry", frame)
        reasonBox:SetPos(20, 100)
        reasonBox:SetSize(elementWidth, 50)
        reasonBox:SetPlaceholderText("Enter the reason...")
        setTransparentStyle(reasonBox)
        local evidenceBox = vgui.Create("DTextEntry", frame)
        evidenceBox:SetPos(20, 160)
        evidenceBox:SetSize(elementWidth, 50)
        evidenceBox:SetPlaceholderText("Paste evidence links or text...")
        setTransparentStyle(evidenceBox)
        local submitButton = vgui.Create("DButton", frame)
        submitButton:SetPos(20, 250)
        submitButton:SetSize(elementWidth, 50)
        submitButton:SetText("Submit PK Case")
        submitButton.Paint = function(self, w, h)
            surface.SetDrawColor(50, 50, 50, 200)
            surface.DrawRect(0, 0, w, h)
            self:SetTextColor(Color(255, 255, 255))
        end

        submitButton.DoClick = function()
            local selectedName, steamID = playerDropdown:GetSelected()
            local reason = reasonBox:GetText()
            local evidence = evidenceBox:GetText()
            if not (selectedName and steamID and reason ~= "" and evidence ~= "") then
                LocalPlayer():ChatPrint("All fields are required.")
                return
            end

            net.Start("SubmitPKCase")
            net.WriteTable({
                player = selectedName,
                steamID = steamID,
                reason = reason,
                evidence = evidence
            })

            net.WriteBool(isCharBan)
            net.SendToServer()
            frame:Close()
        end
    end)

    net.Receive("PK_Screen", function(_)
        local name = net.ReadString()
        local function playPKMusic()
            if pkmusic then
                pkmusic:Stop()
                pkmusic = nil
            end

            timer.Remove("nutMusicFader")
            local src = nut.config.get("pkMusic", ""):lower()
            if src:find("%S") then
                local function cb(music, err, fault)
                    if music then
                        music:SetVolume(0.5)
                        pkmusic = music
                        pkmusic:Play()
                    else
                        MsgC(Color(255, 50, 50), err .. " ")
                        MsgC(color_white, fault .. "\n")
                    end
                end

                if src:find("http") then
                    sound.PlayURL(src, "noplay", cb)
                else
                    sound.PlayFile("sound/" .. src, "noplay", cb)
                end
            end
        end

        hook.Add("HUDPaint", "PK", function()
            surface.SetDrawColor(0, 0, 0, 255)
            LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 2)
            draw.DrawText(name, "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25, Color(255, 255, 255, math.Approach(255, 0, 100)), TEXT_ALIGN_CENTER)
        end)

        playPKMusic()
        timer.Simple(15, function() hook.Remove("HUDPaint", "PK") end)
    end)

    net.Receive("PK_Notice", function(_)
        local characterName = net.ReadString()
        Derma_Query("Your character: " .. characterName .. ", has been permanently killed. An administrator has approved this PK.\nIf you believe this PK is unfair, see the options below.\nPKs are a regular part of RP; you can always make a new character. Have fun!", "Permanent Kill", "I aknowledge.", function() end)
    end)
end
