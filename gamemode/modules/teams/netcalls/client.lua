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
    local isLeader = LocalPlayer():IsSuperAdmin() or (character and character:hasFlags("V"))
    if not isLeader then return end

    if IsValid(lia.gui.rosterSheet) then
        local sheet = lia.gui.rosterSheet
        sheet:Clear()
        local rows = {}
        local originals = {}
        for _, data in ipairs(characterData) do
            if data.faction == factionID then
                rows[#rows + 1] = {data.id, data.name, data.lastOnline, data.hoursPlayed}
                originals[#originals + 1] = data
            end
        end

        local row = sheet:AddListViewRow({
            columns = {"ID", "Name", "Last Online", "Hours Played"},
            data = rows,
            height = 300,
            getLineText = function(line)
                local s = ""
                for i = 1, 4 do
                    local v = line:GetValue(i)
                    if v then s = s .. " " .. tostring(v) end
                end
                return s
            end
        })

        if row and row.widget then
            for i, line in ipairs(row.widget:GetLines() or {}) do
                line.rowData = originals[i]
            end

            row.widget.OnRowRightClick = function(_, _, line)
                if not IsValid(line) or not line.rowData then return end
                local rowData = line.rowData
                local menu = DermaMenu()
                menu:AddOption("Kick", function()
                    Derma_Query("Are you sure you want to kick this player?", "Confirm", "Yes", function()
                        net.Start("KickCharacter")
                        net.WriteInt(tonumber(rowData.id), 32)
                        net.SendToServer()
                    end, "No")
                end)

                menu:AddOption("View Character List", function() LocalPlayer():ConCommand("say /charlist " .. rowData.steamID) end)
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
        {name = "ID", field = "id"},
        {name = "Name", field = "name"},
        {name = "Last Online", field = "lastOnline"},
        {name = "Hours Played", field = "hoursPlayed"}
    }

    local frame, list = lia.util.CreateTableUI("Character Information", columns, rows, {
        {name = "Kick", net = "KickCharacter"}
    })
    characterPanel = frame

    if IsValid(list) then
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.rowData then return end
            local rowData = line.rowData
            local menu = DermaMenu()
            menu:AddOption("Kick", function()
                Derma_Query("Are you sure you want to kick this player?", "Confirm", "Yes", function()
                    net.Start("KickCharacter")
                    net.WriteInt(tonumber(rowData.id), 32)
                    net.SendToServer()
                    if IsValid(frame) then frame:Remove() end
                end, "No")
            end)

            menu:AddOption("View Character List", function() LocalPlayer():ConCommand("say /charlist " .. rowData.steamID) end)
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
