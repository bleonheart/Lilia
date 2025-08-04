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
                if ply:getChar() then
                    choices[#choices + 1] = {ply:Nick(), {name = ply:Nick(), steamID = ply:SteamID(), charID = ply:getChar():getID()}}
                end
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
                    charID = selection.charID,
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

    net.Receive("liaRequestAllPKs", function(_, client)
        if not client:hasPrivilege("Manage Characters") then return end
        lia.db.query("SELECT * FROM lia_permakills", function(data)
            net.Start("liaAllPKs")
            net.WriteTable(data or {})
            net.Send(client)
        end)
    end)
else
    local panelRef
    net.Receive("liaAllPKs", function()
        local cases = net.ReadTable() or {}
        if not IsValid(panelRef) then return end
        panelRef:Clear()
        local search = panelRef:Add("DTextEntry")
        search:Dock(TOP)
        search:SetPlaceholderText(L("search"))
        search:SetTextColor(Color(255, 255, 255))
        local list = panelRef:Add("DListView")
        list:Dock(FILL)
        local function addSizedColumn(text)
            local col = list:AddColumn(text)
            surface.SetFont(col.Header:GetFont())
            local w = surface.GetTextSize(col.Header:GetText())
            col:SetMinWidth(w + 16)
            col:SetWidth(w + 16)
            return col
        end

        addSizedColumn(L("timestamp"))
        addSizedColumn(L("character"))
        addSizedColumn(L("submitter"))
        addSizedColumn(L("evidence"))

        local function populate(filter)
            list:Clear()
            filter = string.lower(filter or "")
            for _, c in ipairs(cases) do
                local charInfo = string.format("%s (%s, %s)", c.player or L("na"), c.steamID or L("na"), c.charID or L("na"))
                local submitInfo = string.format("%s (%s)", c.submitterName or L("na"), c.submitterSteamID or L("na"))
                local timestamp = os.date("%Y-%m-%d %H:%M:%S", tonumber(c.timestamp) or 0)
                local lineData = {timestamp, charInfo, submitInfo, c.evidence or ""}
                local searchStr = table.concat(lineData, " ") .. " " .. (c.reason or "")
                if filter == "" or searchStr:lower():find(filter, 1, true) then
                    local line = list:AddLine(unpack(lineData))
                    line.steamID = c.steamID or ""
                    line.reason = c.reason or ""
                    line.evidence = c.evidence or ""
                    line.submitter = c.submitterName or ""
                    line.submitterSteamID = c.submitterSteamID or ""
                    line.charID = c.charID
                end
            end
        end

        search.OnChange = function() populate(search:GetValue()) end
        populate("")

        function list:OnRowRightClick(_, line)
            if not IsValid(line) then return end
            local menu = DermaMenu()
            menu:AddOption(L("copySubmitter"), function()
                SetClipboardText(string.format("%s (%s)", line.submitter, line.submitterSteamID))
            end):SetIcon("icon16/page_copy.png")
            menu:AddOption(L("copyReason"), function() SetClipboardText(line.reason) end):SetIcon("icon16/page_copy.png")
            menu:AddOption(L("copyEvidence"), function() SetClipboardText(line.evidence) end):SetIcon("icon16/page_copy.png")
            menu:AddOption(L("copySteamID"), function() SetClipboardText(line.steamID) end):SetIcon("icon16/page_copy.png")
            if line.evidence and line.evidence:match("^https?://") then
                menu:AddOption(L("viewEvidence"), function() gui.OpenURL(line.evidence) end):SetIcon("icon16/world.png")
            end
            menu:AddOption(L("banCharacter"), function()
                LocalPlayer():ConCommand([[say "/charban ]] .. line.charID .. [["]])
            end):SetIcon("icon16/cancel.png")
            menu:AddOption(L("unbanCharacter"), function()
                LocalPlayer():ConCommand([[say "/charunban ]] .. line.charID .. [["]])
            end):SetIcon("icon16/accept.png")
            menu:AddOption(L("banCharacterOffline"), function()
                LocalPlayer():ConCommand([[say "/charbanoffline ]] .. line.charID .. [["]])
            end):SetIcon("icon16/cancel.png")
            menu:AddOption(L("unbanCharacterOffline"), function()
                LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. line.charID .. [["]])
            end):SetIcon("icon16/accept.png")
            menu:Open()
        end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("Manage Characters") then return end
        table.insert(pages, {
            name = L("pkManager"),
            drawFunc = function(panel)
                panelRef = panel
                net.Start("liaRequestAllPKs")
                net.SendToServer()
            end
        })
    end

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
