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
    if not lia.option.get("espEnabled", false) then return end
    local marginx, marginy = ScrW() * 0.1, ScrH() * 0.1
    local maxDistanceSq = 4096
    for _, ent in ents.Iterator() do
        if not IsValid(ent) or ent == client then continue end
        local entityType, label, nameLabel
        if ent:IsPlayer() then
            entityType = "Players"
            if ent:getNetVar("cheater") then
                label = string.upper(L("cheater"))
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
        elseif ent:isDoor() and lia.option.get("espUnconfiguredDoors") then
            local hasVar = ent:getNetVar("name") ~= nil or ent:getNetVar("title") ~= nil or ent:getNetVar("price") ~= nil or ent:getNetVar("noSell") ~= nil or ent:getNetVar("factions") ~= nil or ent:getNetVar("classes") ~= nil or ent:getNetVar("disabled") ~= nil or ent:getNetVar("hidden") ~= nil or ent:getNetVar("locked") ~= nil
            if not hasVar then
                entityType = "UnconfiguredDoors"
                label = L("unconfiguredDoorESPLabel")
            end
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
            name = L("id"),
            field = "ID"
        },
        {
            name = L("name"),
            field = "Name"
        },
        {
            name = L("desc"),
            field = "Desc"
        },
        {
            name = L("faction"),
            field = "Faction"
        },
        {
            name = L("banned"),
            field = "Banned"
        },
        {
            name = L("banningAdminName"),
            field = "BanningAdminName"
        },
        {
            name = L("banningAdminSteamID"),
            field = "BanningAdminSteamID"
        },
        {
            name = L("banningAdminRank"),
            field = "BanningAdminRank"
        },
        {
            name = L("charMoney"),
            field = "Money"
        },
        {
            name = L("lastUsed"),
            field = "LastUsed"
        }
    }

    for _, name in ipairs(extraOrder) do
        table.insert(columns, {
            name = name,
            field = name
        })
    end

    local _, listView = lia.util.CreateTableUI(L("charlistTitle", targetSteamIDsafe), columns, sendData)
    if IsValid(listView) then
        for _, line in ipairs(listView:GetLines()) do
            local dataIndex = line:GetID()
            local rowData = sendData[dataIndex]
            if rowData and rowData.Banned == L("yes") then
                line.DoPaint = line.Paint
                line.Paint = function(pnl, w, h)
                    surface.SetDrawColor(200, 100, 100)
                    surface.DrawRect(0, 0, w, h)
                    pnl:DoPaint(w, h)
                end
            end

            line.CharID = rowData and rowData.ID
            if rowData and rowData.extraDetails then
                local colIndex = 11
                for _, name in ipairs(extraOrder) do
                    line:SetColumnText(colIndex, tostring(rowData.extraDetails[name] or ""))
                    colIndex = colIndex + 1
                end
            end
        end

        listView.OnRowRightClick = function(_, _, ln)
            if ln and ln.CharID and (LocalPlayer():hasPrivilege("Unban Offline") or LocalPlayer():hasPrivilege("Ban Offline")) then
                local dMenu = DermaMenu()
                if LocalPlayer():hasPrivilege("Unban Offline") then
                    local opt1 = dMenu:AddOption(L("banCharacter"), function() LocalPlayer():ConCommand([[say "/charbanoffline ]] .. ln.CharID .. [["]]) end)
                    opt1:SetIcon("icon16/cancel.png")
                end

                if LocalPlayer():hasPrivilege("Ban Offline") then
                    local opt2 = dMenu:AddOption(L("unbanCharacter"), function() LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. ln.CharID .. [["]]) end)
                    opt2:SetIcon("icon16/accept.png")
                end

                dMenu:Open()
            end
        end
    end
end)
