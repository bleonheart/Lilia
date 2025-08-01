local characterPanel
net.Receive("classUpdate", function()
    local joinedClient = net.ReadEntity()
    if lia.gui.classes and lia.gui.classes:IsVisible() then
        if joinedClient == LocalPlayer() then
            lia.gui.classes:loadClasses()
        else
            for _, v in ipairs(lia.gui.classes.classPanels) do
                local data = v.data
                v:setNumber(#lia.class.getPlayers(data.index))
            end
        end
    end
end)

net.Receive("CharacterInfo", function()
    local factionID = net.ReadString()
    local characterData = net.ReadTable()
    local character = LocalPlayer():getChar()
    local isLeader = LocalPlayer():hasPrivilege("Manage Faction Members") or (character and character:hasFlags("V"))
    if not isLeader then return end

    if IsValid(lia.gui.rosterSheet) then
        local sheet = lia.gui.rosterSheet
        sheet:Clear()
        local rows = {}
        local originals = {}
        for _, data in ipairs(characterData) do
            if data.faction == factionID then
                rows[#rows + 1] = {data.name, data.class or "None", data.lastOnline, data.hoursPlayed}
                originals[#originals + 1] = data
            end
        end

        local row = sheet:AddListViewRow({
            columns = {L("name"), L("class"), L("lastOnline"), L("hoursPlayed")},
            data = rows,
            getLineText = function(line)
                local s = ""
                for i = 1, 4 do
                    local v = line:GetValue(i)
                    if v then s = s .. " " .. tostring(v) end
                end
                return s
            end
        })

        if row and row.panel then
            row.panel:Dock(FILL)
        end

        if row and row.widget then
            for i, line in ipairs(row.widget:GetLines() or {}) do
                line.rowData = originals[i]
            end

            row.widget.OnRowRightClick = function(_, _, line)
                if not IsValid(line) or not line.rowData then return end
                local rowData = line.rowData
                local menu = DermaMenu()
                if rowData.steamID ~= LocalPlayer():SteamID() then
                    menu:AddOption(L("kick"), function()
                        Derma_Query(L("kickConfirm"), L("confirm"), L("yes"), function()
                            net.Start("KickCharacter")
                            net.WriteInt(tonumber(rowData.id), 32)
                            net.SendToServer()
                        end, L("no"))
                    end)
                end

                menu:AddOption(L("viewCharacterList"), function() LocalPlayer():ConCommand("say /charlist " .. rowData.steamID) end)
                menu:AddOption(L("copyRow"), function()
                    local rowString = ""
                    for key, value in pairs(rowData) do
                        value = tostring(value or L("na"))
                        rowString = rowString .. key:gsub("^%l", string.upper) .. ": " .. value .. " | "
                    end

                    rowString = rowString:sub(1, -4)
                    SetClipboardText(rowString)
                end)

                menu:Open()
            end
        end

        sheet:Refresh()
        return
    end

    if IsValid(characterPanel) then characterPanel:Remove() end
    local rows = {}
    for _, data in ipairs(characterData) do
        if data.faction == factionID then table.insert(rows, data) end
    end

    local columns = {
        {name = L("name"), field = "name"},
        {name = L("class"), field = "class"},
        {name = L("lastOnline"), field = "lastOnline"},
        {name = L("hoursPlayed"), field = "hoursPlayed"}
    }

    local frame, list = lia.util.CreateTableUI(L("characterInformation"), columns, rows, {
        {name = L("kick"), net = "KickCharacter"}
    })
    characterPanel = frame

    if IsValid(list) then
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.rowData then return end
            local rowData = line.rowData
            local menu = DermaMenu()
            if rowData.steamID ~= LocalPlayer():SteamID() then
                menu:AddOption(L("kick"), function()
                    Derma_Query(L("kickConfirm"), L("confirm"), L("yes"), function()
                        net.Start("KickCharacter")
                        net.WriteInt(tonumber(rowData.id), 32)
                        net.SendToServer()
                        if IsValid(frame) then frame:Remove() end
                    end, L("no"))
                end)
            end

            menu:AddOption(L("viewCharacterList"), function() LocalPlayer():ConCommand("say /charlist " .. rowData.steamID) end)
            menu:AddOption(L("copyRow"), function()
                local rowString = ""
                for key, value in pairs(rowData) do
                    value = tostring(value or L("na"))
                    rowString = rowString .. key:gsub("^%l", string.upper) .. ": " .. value .. " | "
                end

                rowString = rowString:sub(1, -4)
                SetClipboardText(rowString)
            end)

            menu:Open()
        end
    end
end)
