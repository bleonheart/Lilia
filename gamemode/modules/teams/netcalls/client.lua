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

lia.gui = lia.gui or {}

local function OpenRosterUI(panel, columns, rows)
    panel:Clear()
    panel:DockPadding(10, 10, 10, 10)
    local listView = panel:Add("DListView")
    listView:Dock(FILL)
    local totalFixedWidth, dynamicColumns = 0, 0
    for _, col in ipairs(columns) do
        if col.width then
            totalFixedWidth = totalFixedWidth + col.width
        else
            dynamicColumns = dynamicColumns + 1
        end
    end

    local availableWidth = panel:GetWide() - totalFixedWidth
    local dynamicWidth = dynamicColumns > 0 and math.max(availableWidth / dynamicColumns, 50) or 0

    for _, col in ipairs(columns) do
        local name = col.name or L("na")
        local width = col.width or dynamicWidth
        listView:AddColumn(name):SetFixedWidth(width)
    end

    for _, row in ipairs(rows) do
        local lineData = {}
        for _, col in ipairs(columns) do
            table.insert(lineData, row[col.field] or L("na"))
        end
        local line = listView:AddLine(unpack(lineData))
        line.rowData = row
    end

    listView.OnRowRightClick = function(_, _, line)
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
        menu:AddOption("View Character List", function()
            LocalPlayer():ConCommand("say /charlist " .. rowData.steamID)
        end)
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

net.Receive("CharacterInfo", function()
    local factionID = net.ReadString()
    local characterData = net.ReadTable()
    local character = LocalPlayer():getChar()
    local isLeader = LocalPlayer():IsSuperAdmin() or character:getData("factionOwner") or character:getData("factionAdmin") or character:hasFlags("V")
    if not isLeader then return end
    local rows = {}
    for _, data in ipairs(characterData) do
        if data.faction == factionID and data.id ~= character:getID() then table.insert(rows, data) end
    end

    local columns = {
        {
            name = "ID",
            field = "id"
        },
        {
            name = "Name",
            field = "name"
        },
        {
            name = "Last Online",
            field = "lastOnline"
        },
        {
            name = "Hours Played",
            field = "hoursPlayed"
        }
    }

    if IsValid(lia.gui.roster) then
        OpenRosterUI(lia.gui.roster, columns, rows)
    else
        local frame, list = lia.util.CreateTableUI("Character Information", columns, rows, {
            {
                name = "Kick",
                net = "KickCharacter"
            }
        })

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
    end
end)
