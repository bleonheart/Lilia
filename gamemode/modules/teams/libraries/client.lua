function MODULE:LoadCharInformation()
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local character = client:getChar()
    if not character then return end
    hook.Run("AddTextField", L("generalInfo"), "faction", L("faction"), function() return team.GetName(client:Team()) end)
    local classID = character:getClass()
    local classData = lia.class.list[classID]
    if classID and classData and classData.name then hook.Run("AddTextField", L("generalInfo"), "class", L("class"), function() return classData.name end) end
end

function MODULE:DrawCharInfo(client, _, info)
    if not lia.config.get("ClassDisplay", true) then return end
    local charClass = client:getClassData()
    if charClass then
        local classColor = charClass.color or Color(255, 255, 255)
        local className = L(charClass.name) or L("undefinedClass")
        info[#info + 1] = {className, classColor}
    end
end

function MODULE:CreateMenuButtons(tabs)
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local character = client:getChar()
    if not character then return end
    local isLeader = client:IsSuperAdmin() or character:getData("factionOwner") or character:getData("factionAdmin") or character:hasFlags("V")
    if not isLeader then return end
    tabs[L("roster")] = function(panel)
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