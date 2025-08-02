if SERVER then
    util.AddNetworkString("OpenPKViewer")
    util.AddNetworkString("SubmitPKCase")

    lia.command.add("charkill", {
        superAdminOnly = true,
        privilege = "Manage Characters",
        onRun = function(client)
            netstream.Start(client, "OpenPKMenu", false)
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
        }, nil, "lia_permakills")

        for _, ply in player.Iterator() do
            if ply:SteamID() == data.steamID and ply:getChar() then
                if isCharBan then
                    ply:getChar():setData("banned", true)
                    ply:getChar():kick()
                else
                    ply:getChar():ban()
                end

                break
            end
        end
    end)
else
    net.Receive("OpenPKViewer", function()
        local cases = net.ReadTable()
        OpenPKViewer(cases)
    end)

    netstream.Hook("OpenPKMenu", function(isCharBan)
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

        local playerSearch = vgui.Create("DTextEntry", frame)
        playerSearch:SetPos(20, 50)
        playerSearch:SetSize(elementWidth, elementHeight)
        playerSearch:SetPlaceholderText("Search for player...")

        local allPlayers = {}
        for _, ply in ipairs(player.GetAll()) do
            allPlayers[#allPlayers + 1] = {
                name = ply:Nick(),
                steamid = ply:SteamID()
            }
        end

        local playerDropdown = vgui.Create("DComboBox", frame)
        playerDropdown:SetPos(20, 80)
        playerDropdown:SetSize(elementWidth, elementHeight)
        playerDropdown:SetValue("Select Player")

        local function updatePlayerList(filter)
            playerDropdown:Clear()
            for _, data in ipairs(allPlayers) do
                if filter == "" or string.find(string.lower(data.name), string.lower(filter)) then
                    playerDropdown:AddChoice(data.name, data.steamid)
                end
            end
        end

        updatePlayerList("")
        playerSearch.OnChange = function(self)
            updatePlayerList(self:GetValue())
        end

        local reasonBox = vgui.Create("DTextEntry", frame)
        reasonBox:SetPos(20, 130)
        reasonBox:SetSize(elementWidth, 50)
        reasonBox:SetPlaceholderText("Enter the reason...")
        setTransparentStyle(reasonBox)

        local evidenceBox = vgui.Create("DTextEntry", frame)
        evidenceBox:SetPos(20, 180)
        evidenceBox:SetSize(elementWidth, 50)
        evidenceBox:SetPlaceholderText("Paste evidence links or text...")
        setTransparentStyle(evidenceBox)

        local submitButton = vgui.Create("DButton", frame)
        submitButton:SetPos(20, 300)
        submitButton:SetSize(elementWidth, 50)
        submitButton:SetText("Submit PK Case")
        submitButton.Paint = function(self, w, h)
            surface.SetDrawColor(50, 50, 50, 200)
            surface.DrawRect(0, 0, w, h)
            self:SetTextColor(Color(255, 255, 255))
        end

        submitButton.DoClick = function()
            local selectedPlayer, steamID = playerDropdown:GetSelected()
            local reason = reasonBox:GetText()
            local evidence = evidenceBox:GetText()

            if not (selectedPlayer and reason ~= "" and evidence ~= "") then
                LocalPlayer():ChatPrint("All fields are required.")
                return
            end

            net.Start("SubmitPKCase")
            net.WriteTable({
                player = selectedPlayer,
                steamID = steamID,
                reason = reason,
                evidence = evidence
            })

            net.WriteBool(isCharBan)
            net.SendToServer()
            frame:Close()
        end
    end)

    function OpenPKViewer(cases)
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
                if string.match(c.player:lower(), filter:lower()) then
                    caseList:AddLine(c.player)
                end
            end
        end

        updateCaseList("")
        searchBox.OnChange = function()
            updateCaseList(searchBox:GetText())
        end

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
                    btn.DoClick = function()
                        SetClipboardText(clip)
                    end
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
    end

    net.Receive("PK_Screen", function(len)
        local name = net.ReadString()
        local dob = net.ReadString()
        local age = net.ReadInt(32)
        local occupation = net.ReadString()
        local placeOfBirth = net.ReadString()
        local playersMoney = net.ReadInt(32)
        local moneyStatus = "Unknown"
        if playersMoney >= 250000 then
            moneyStatus = "Wealthy"
        elseif playersMoney > 50000 then
            moneyStatus = "Rich"
        elseif playersMoney > 10000 then
            moneyStatus = "Poor"
        elseif playersMoney > 5000 then
            moneyStatus = "Destitute"
        else
            moneyStatus = "Penniless"
        end

        local function PlayPKMusic()
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
            draw.DrawText(dob .. " - 1939", "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25 + 75, Color(255, 255, 255, math.Approach(255, 0, 100)), TEXT_ALIGN_CENTER)
            draw.DrawText("Aged: " .. age, "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25 + 150, Color(255, 255, 255, math.Approach(255, 0, 100)), TEXT_ALIGN_CENTER)
            draw.DrawText("They were a " .. moneyStatus .. " " .. occupation .. " from " .. placeOfBirth, "nutTitleFont", ScrW() * 0.5, ScrH() * 0.25 + 225, Color(255, 255, 255, math.Approach(255, 0, 100)), TEXT_ALIGN_CENTER)
        end)

        PlayPKMusic()
        timer.Simple(15, function()
            hook.Remove("HUDPaint", "PK")
        end)
    end)

    net.Receive("PK_Notice", function(len)
        local characterName = net.ReadString()
        Derma_Query("Your character: " .. characterName .. ", has been permanently killed. An administrator has approved this PK.\nIf you believe this PK is unfair, see the options below.\nPKs are a regular part of RP; you can always make a new character. Have fun!", "Permanent Kill", "I accept this PK.", function() end, "I don't accept this PK.", function()
            Derma_Query("Contact our Support Team if needed.", "Contact Staff", "Contact Staff VIA Discord", function() gui.OpenURL("https://discord.gg/AeBGuZ6agC") end, "Nevermind, Close", function() end)
        end)
    end)
end
