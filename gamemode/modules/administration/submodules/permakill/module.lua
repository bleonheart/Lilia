MODULE.name = L("xxdd")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("xdd")
if SERVER then
    lia.command.add("charkill", {
        superAdminOnly = true,
        privilege = "Manage Characters",
        onRun = function(client)
            local choices = {}
            for _, ply in player.Iterator() do
                choices[#choices + 1] = {ply:Nick(), {name = ply:Nick(), steamID = ply:SteamID()}}
            end

            local playerKey = L("player", client)
            local reasonKey = L("reason", client)
            local evidenceKey = L("evidence", client)
            client:requestArguments(L("pkActiveMenu", client), {
                [playerKey] = {"table", choices},
                [reasonKey] = "string",
                [evidenceKey] = "string"
            }, function(data)
                local selection = data[playerKey]
                local reason = data[reasonKey]
                local evidence = data[evidenceKey]
                if not (isstring(evidence) and evidence:match("^https?://")) then
                    client:notify("Evidence must be a valid URL.")
                    return
                end

                lia.db.insertTable({
                    player = selection.name,
                    reason = reason,
                    steamID = selection.steamID,
                    submitterName = client:Name(),
                    submitterSteamID = client:SteamID(),
                    timestamp = os.time(),
                    evidence = evidence
                }, nil, "permakills")

                for _, ply in player.Iterator() do
                    if ply:SteamID() == selection.steamID and ply:getChar() then
                        ply:getChar():ban()
                        break
                    end
                end
            end)
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

else
    net.Receive("OpenPKViewer", function()
        local cases = net.ReadTable()
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 400)
        frame:SetTitle(L("viewPKCases"))
        frame:Center()
        frame:MakePopup()
        local searchBox = vgui.Create("DTextEntry", frame)
        searchBox:SetSize(280, 25)
        searchBox:SetPos(10, 30)
        searchBox:SetPlaceholderText(L("searchByPlayerName"))
        local caseList = vgui.Create("DListView", frame)
        caseList:SetSize(280, 300)
        caseList:SetPos(10, 60)
        caseList:AddColumn(L("player"))
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
                df:SetTitle(L("pkCaseDetails"))
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

                makeButton(L("player") .. ": " .. detail.player, y, detail.player)
                y = y + 25
                makeButton(L("steamID") .. ": " .. detail.steamID, y, detail.steamID)
                y = y + 25
                makeButton(L("reason") .. ": " .. detail.reason, y, detail.reason)
                y = y + 25
                makeButton(L("evidence") .. ": " .. detail.evidence, y, detail.evidence)
                y = y + 25
                makeButton(L("submitter") .. ": " .. detail.submitterName, y, detail.submitterName)
                y = y + 25
                makeButton(L("submitterSteamID") .. ": " .. detail.submitterSteamID, y, detail.submitterSteamID)
                y = y + 25
                makeButton(L("timestamp") .. ": " .. os.date("%c", detail.timestamp), y, os.date("%c", detail.timestamp))
            end
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
end
