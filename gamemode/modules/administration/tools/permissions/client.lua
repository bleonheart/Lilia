local ESP_DrawnEntities = {
    lia_bodygrouper = true,
    lia_vendor = true,
}

function MODULE:PrePlayerDraw(client)
    if not IsValid(client) then return end
    if client:isNoClipping() then return true end
end

function MODULE:HUDPaint()
    local client = LocalPlayer()
    if not client:getChar() or not client:IsValid() or not client:IsPlayer() then return end
    if not client:isNoClipping() then return end
    if not (client:hasPrivilege("No Clip ESP Outside Staff Character") or client:isStaffOnDuty()) then return end
    local marginx, marginy = ScrW() * 0.1, ScrH() * 0.1
    local maxDistanceSq = 4096
    for _, ent in ents.Iterator() do
        if not IsValid(ent) or ent == client then continue end
        local entityType, label, nameLabel
        if ent:IsPlayer() then
            entityType = "Players"
            if ent:getNetVar("cheater") then
                label = "CHEATER"
                nameLabel = ent:Name():gsub("#", "\226\128\139#")
            else
                label = ent:Name():gsub("#", "\226\128\139#")
            end
        elseif ent.isItem and ent:isItem() and lia.option.get("espItems") then
            entityType = "Items"
            local itemTable = ent.getItemTable and ent:getItemTable()
            label = L("itemESPLabel", itemTable and itemTable.name or L("unknown"))
        elseif ent.isProp and ent:isProp() and lia.option.get("espProps") then
            entityType = "Props"
            label = L("propModelESPLabel", ent:GetModel() or L("unknown"))
        elseif ESP_DrawnEntities[ent:GetClass()] and lia.option.get("espEntities") then
            entityType = "Entities"
            label = L("entityClassESPLabel", ent:GetClass() or L("unknown"))
        end

        if not entityType then continue end
        local vPos, clientPos = ent:GetPos(), client:GetPos()
        if not vPos or not clientPos then continue end
        local scrPos = vPos:ToScreen()
        if not scrPos.visible then continue end
        local distanceSq = clientPos:DistToSqr(vPos)
        local factor = 1 - math.Clamp(distanceSq / maxDistanceSq, 0, 1)
        local size = math.max(20, 48 * factor)
        local alpha = math.Clamp(255 * factor, 120, 255)
        local cheater = ent:getNetVar("cheater", false)
        local colorToUse = ColorAlpha(lia.config.get("esp" .. entityType .. "Color") or Color(255, 255, 255), alpha)
        if cheater then colorToUse = ColorAlpha(Color(255, 0, 0), alpha) end
        local x, y = math.Clamp(scrPos.x, marginx, ScrW() - marginx), math.Clamp(scrPos.y, marginy, ScrH() - marginy)
        surface.SetDrawColor(colorToUse.r, colorToUse.g, colorToUse.b, colorToUse.a)
        surface.DrawRect(x - size / 2, y - size / 2, size, size)
        surface.SetFont("liaMediumFont")
        local _, lineH = surface.GetTextSize("W")
        if nameLabel then
            draw.SimpleTextOutlined(label, "liaMediumFont", x, y - size - lineH / 2, ColorAlpha(colorToUse, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
            draw.SimpleTextOutlined(nameLabel, "liaMediumFont", x, y - size + lineH / 2, ColorAlpha(colorToUse, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
        else
            draw.SimpleTextOutlined(label, "liaMediumFont", x, y - size, ColorAlpha(colorToUse, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
        end
    end
end

local function populateCharTable(panel, columns, rows)
    if not IsValid(panel) then return nil end
    panel:Clear()
    local listView = vgui.Create("DListView", panel)
    listView:Dock(FILL)
    local totalFixedWidth, dynamicColumns = 0, 0
    for _, colInfo in ipairs(columns) do
        if colInfo.width then
            totalFixedWidth = totalFixedWidth + colInfo.width
        else
            dynamicColumns = dynamicColumns + 1
        end
    end

    local availableWidth = panel:GetWide() - totalFixedWidth
    local dynamicWidth = dynamicColumns > 0 and math.max(availableWidth / dynamicColumns, 50) or 0
    for _, colInfo in ipairs(columns) do
        local columnName = colInfo.name or L("na")
        local column = listView:AddColumn(columnName)
        local columnWidth = colInfo.width or dynamicWidth
        surface.SetFont(column.Header:GetFont() or "DermaDefault")
        local textWidth = select(1, surface.GetTextSize(columnName)) + 20
        local finalWidth = math.max(columnWidth, textWidth)
        column:SetWide(finalWidth)
        column:SetMinWidth(textWidth)
    end

    for _, row in ipairs(rows) do
        local lineData = {}
        for _, colInfo in ipairs(columns) do
            local fieldName = colInfo.field or colInfo.name
            table.insert(lineData, row[fieldName] or L("na"))
        end
        local line = listView:AddLine(unpack(lineData))
        line.rowData = row
    end

    return listView
end

net.Receive("DisplayCharList", function()
    local sendData = net.ReadTable()
    local targetSteamIDsafe = net.ReadString()
    local extraColumns, extraOrder = {}, {}
    for _, v in pairs(sendData or {}) do
        if istable(v.extraDetails) then
            for k in pairs(v.extraDetails) do
                if not extraColumns[k] then
                    extraColumns[k] = true
                    table.insert(extraOrder, k)
                end
            end
        end
    end

    local columns = {
        {
            name = "ID",
            field = "ID"
        },
        {
            name = "SteamID",
            field = "SteamID"
        },
        {
            name = "Name",
            field = "Name"
        },
        {
            name = "Desc",
            field = "Desc"
        },
        {
            name = "Faction",
            field = "Faction"
        },
        {
            name = "Banned",
            field = "Banned"
        },
        {
            name = "BanningAdminName",
            field = "BanningAdminName"
        },
        {
            name = "BanningAdminSteamID",
            field = "BanningAdminSteamID"
        },
        {
            name = "BanningAdminRank",
            field = "BanningAdminRank"
        },
        {
            name = "CharMoney",
            field = "Money"
        },
        {
            name = "LastUsed",
            field = "LastUsed"
        },
        {
            name = "LastOnline",
            field = "LastOnline"
        }
    }

    for _, name in ipairs(extraOrder) do
        table.insert(columns, {
            name = name,
            field = name
        })
    end

    if lia.gui.charList and lia.gui.charList.panels and IsValid(lia.gui.charList.panels[targetSteamIDsafe]) then
        local listView = populateCharTable(lia.gui.charList.panels[targetSteamIDsafe], columns, sendData)
        if IsValid(listView) then
            for _, line in ipairs(listView:GetLines()) do
                local dataIndex = line:GetID()
                local rowData = sendData[dataIndex]
                if rowData and rowData.Banned == "Yes" then
                    line.DoPaint = line.Paint
                    line.Paint = function(pnl, w, h)
                        surface.SetDrawColor(200, 100, 100)
                        surface.DrawRect(0, 0, w, h)
                        pnl:DoPaint(w, h)
                    end
                end

                line.CharID = rowData and rowData.ID
                if rowData and rowData.extraDetails then
                    local colIndex = 13
                    for _, name in ipairs(extraOrder) do
                        line:SetColumnText(colIndex, tostring(rowData.extraDetails[name] or ""))
                        colIndex = colIndex + 1
                    end
                end
            end

            listView.OnRowRightClick = function(_, _, ln)
                if not IsValid(ln) then return end
                local menu = DermaMenu()
                if ln.rowData then
                    menu:AddOption(L("copyRow"), function()
                        local rowString = ""
                        for key, value in pairs(ln.rowData) do
                            rowString = rowString .. tostring(key) .. ": " .. tostring(value) .. " | "
                        end
                        rowString = rowString:sub(1, -4)
                        SetClipboardText(rowString)
                    end):SetIcon("icon16/page_copy.png")
                end
                if ln.CharID then
                    local online = ln.rowData and (ln.rowData.LastUsed == L("onlineNow") or ln.rowData.LastOnline == L("onlineNow"))
                    if online then
                        if LocalPlayer():hasPrivilege("Manage Characters") then
                            menu:AddOption(L("banCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charban ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/cancel.png")
                            menu:AddOption(L("unbanCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charunban ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/accept.png")
                        end
                    else
                        if LocalPlayer():hasPrivilege("Commands - Unban Offline") then
                            menu:AddOption(L("banCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charbanoffline ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/cancel.png")
                        end
                        if LocalPlayer():hasPrivilege("Commands - Ban Offline") then
                            menu:AddOption(L("unbanCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/accept.png")
                        end
                    end
                end
                menu:Open()
            end
        end
    else
        local _, listView = lia.util.CreateTableUI("Charlist for SteamID64: " .. targetSteamIDsafe, columns, sendData)
        if IsValid(listView) then
            for _, line in ipairs(listView:GetLines()) do
                local dataIndex = line:GetID()
                local rowData = sendData[dataIndex]
                if rowData and rowData.Banned == "Yes" then
                    line.DoPaint = line.Paint
                    line.Paint = function(pnl, w, h)
                        surface.SetDrawColor(200, 100, 100)
                        surface.DrawRect(0, 0, w, h)
                        pnl:DoPaint(w, h)
                    end
                end

                line.CharID = rowData and rowData.ID
                if rowData and rowData.extraDetails then
                    local colIndex = 13
                    for _, name in ipairs(extraOrder) do
                        line:SetColumnText(colIndex, tostring(rowData.extraDetails[name] or ""))
                        colIndex = colIndex + 1
                    end
                end
            end

            listView.OnRowRightClick = function(_, _, ln)
                if not IsValid(ln) then return end
                local menu = DermaMenu()
                if ln.rowData then
                    menu:AddOption(L("copyRow"), function()
                        local rowString = ""
                        for key, value in pairs(ln.rowData) do
                            rowString = rowString .. tostring(key) .. ": " .. tostring(value) .. " | "
                        end
                        rowString = rowString:sub(1, -4)
                        SetClipboardText(rowString)
                    end):SetIcon("icon16/page_copy.png")
                end
                if ln.CharID then
                    local online = ln.rowData and (ln.rowData.LastUsed == L("onlineNow") or ln.rowData.LastOnline == L("onlineNow"))
                    if online then
                        if LocalPlayer():hasPrivilege("Manage Characters") then
                            menu:AddOption(L("banCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charban ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/cancel.png")
                            menu:AddOption(L("unbanCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charunban ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/accept.png")
                        end
                    else
                        if LocalPlayer():hasPrivilege("Commands - Unban Offline") then
                            menu:AddOption(L("banCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charbanoffline ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/cancel.png")
                        end
                        if LocalPlayer():hasPrivilege("Commands - Ban Offline") then
                            menu:AddOption(L("unbanCharacter"), function()
                                LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. ln.CharID .. [["]])
                            end):SetIcon("icon16/accept.png")
                        end
                    end
                end
                menu:Open()
            end
        end
    end
end)

hook.Add("liaAdminRegisterTab", "AdminTabCharList", function(tabs)
    local function canShow()
        local ply = LocalPlayer()
        return IsValid(ply) and ply:hasPrivilege("Access Character List Tab") and ply:hasPrivilege("List Characters")
    end

    tabs[L("characterList")] = {
        icon = "icon16/user_gray.png",
        onShouldShow = canShow,
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:DockPadding(10, 10, 10, 10)
            lia.gui.charList = pnl
            local psheet = vgui.Create("DPropertySheet", pnl)
            psheet:Dock(FILL)
            lia.gui.charList.sheet = psheet
            lia.gui.charList.panels = {}

            for _, ply in ipairs(player.GetAll()) do
                local sub = vgui.Create("DPanel", psheet)
                sub:Dock(FILL)
                sub.Paint = function() end
                psheet:AddSheet(ply:SteamName(), sub, "icon16/user.png")
                lia.gui.charList.panels[ply:SteamID64()] = sub
                net.Start("liaRequestCharList")
                net.WriteString(ply:SteamID64())
                net.SendToServer()
            end

            local allPanel = vgui.Create("DPanel", psheet)
            allPanel:Dock(FILL)
            allPanel.Paint = function() end
            psheet:AddSheet("Database", allPanel, "icon16/database.png")
            lia.gui.charList.panels["all"] = allPanel
            net.Start("liaRequestAllCharList")
            net.SendToServer()

            return pnl
        end
    }
end)
