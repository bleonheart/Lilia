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
    if not client:IsValid() or not client:IsPlayer() or not client:getChar() then return end
    if not client:isNoClipping() then return end
    if not (client:hasPrivilege("No Clip ESP Outside Staff Character") or client:isStaffOnDuty()) then return end
    if not lia.option.get("espEnabled", false) then return end
    local sx, sy = ScrW(), ScrH()
    local marginx, marginy = sx * 0.1, sy * 0.1
    local maxDistanceSq = 4096
    for _, ent in pairs(ents.GetAll()) do
        if not IsValid(ent) or ent == client then continue end
        local typ, label, sublabel, baseColor
        if ent:IsPlayer() then
            typ = "Players"
            sublabel = ent:Name():gsub("#", "\226\128\139#")
            if ent:getNetVar("cheater", false) then
                label = string.upper(L("cheater"))
                baseColor = Color(255, 0, 0)
            else
                label = sublabel
                baseColor = lia.config.get("espPlayersColor") or Color(255, 255, 255)
            end
        elseif ent.isItem and ent:isItem() and lia.option.get("espItems", false) then
            typ = "Items"
            label = L("item") .. ": " .. (ent.getItemTable and ent:getItemTable().name or L("unknown"))
            baseColor = lia.config.get("espItemsColor") or Color(255, 255, 255)
        elseif ent.isProp and ent:isProp() and lia.option.get("espProps", false) then
            typ = "Props"
            label = L("prop") .. " " .. L("model") .. ": " .. (ent:GetModel() or L("unknown"))
            baseColor = lia.config.get("espPropsColor") or Color(255, 255, 255)
        elseif ESP_DrawnEntities[ent:GetClass()] and lia.option.get("espEntities", false) then
            typ = "Entities"
            label = L("entity") .. " " .. L("class") .. ": " .. (ent:GetClass() or L("unknown"))
            baseColor = lia.config.get("espEntitiesColor") or Color(255, 255, 255)
        end

        if not typ then continue end
        local pos = ent:GetPos()
        if not pos then continue end
        local distSq = client:GetPos():DistToSqr(pos)
        if distSq > maxDistanceSq then continue end
        local screenPos = pos:ToScreen()
        if not screenPos.visible then continue end
        local factor = 1 - math.Clamp(distSq / maxDistanceSq, 0, 1)
        local boxSize = math.max(20, 48 * factor)
        local alpha = math.Clamp(255 * factor, 120, 255)
        local color = Color(baseColor.r, baseColor.g, baseColor.b, alpha)
        local x = math.Clamp(screenPos.x, marginx, sx - marginx)
        local y = math.Clamp(screenPos.y, marginy, sy - marginy)
        surface.SetDrawColor(color.r, color.g, color.b, color.a)
        surface.DrawRect(x - boxSize / 2, y - boxSize / 2, boxSize, boxSize)
        surface.SetFont("liaMediumFont")
        local _, textHeight = surface.GetTextSize("W")
        draw.SimpleTextOutlined(label, "liaMediumFont", x, y - boxSize - textHeight / 2, Color(color.r, color.g, color.b, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
        if sublabel then draw.SimpleTextOutlined(sublabel, "liaMediumFont", x, y - boxSize + textHeight / 2, Color(color.r, color.g, color.b, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200)) end
        if typ == "Players" then
            local barOffset = 8 * factor
            local barWidth = math.max(70, 200 * factor)
            local barHeight = math.max(10, 30 * factor)
            local yPos = y + boxSize / 2 + 10
            surface.SetDrawColor(0, 0, 0, alpha)
            surface.DrawRect(x - barWidth / 2, yPos, barWidth, barHeight)
            local hpFrac = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
            surface.SetDrawColor(183, 8, 0, alpha)
            surface.DrawRect(x - (barWidth - barOffset) / 2, yPos + barOffset / 2, (barWidth - barOffset) * hpFrac, barHeight - barOffset)
            draw.SimpleTextOutlined(ent:Health(), "liaSmallFont", x, yPos + barHeight / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha))
            if ent:Armor() > 0 then
                yPos = yPos + barHeight + 5
                surface.SetDrawColor(0, 0, 0, alpha)
                surface.DrawRect(x - barWidth / 2, yPos, barWidth, barHeight)
                local armorFrac = math.Clamp(ent:Armor() / 100, 0, 1)
                surface.SetDrawColor(0, 0, 255, alpha)
                surface.DrawRect(x - (barWidth - barOffset) / 2, yPos + barOffset / 2, (barWidth - barOffset) * armorFrac, barHeight - barOffset)
                draw.SimpleTextOutlined(ent:Armor(), "liaSmallFont", x, yPos + barHeight / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha))
            end

            local wep = ent:GetActiveWeapon()
            if IsValid(wep) then
                local ammo, reserve = wep:Clip1(), ent:GetAmmoCount(wep:GetPrimaryAmmoType())
                local wepName = wep:GetPrintName()
                if ammo >= 0 and reserve >= 0 then wepName = wepName .. " [" .. ammo .. "/" .. reserve .. "]" end
                draw.SimpleTextOutlined(wepName, "liaSmallFont", x, yPos + barHeight + 5, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, alpha))
            end
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
            name = L("name"),
            field = "Name"
        },
        {
            name = L("description"),
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
                local colIndex = 10
                for _, name in ipairs(extraOrder) do
                    line:SetColumnText(colIndex, tostring(rowData.extraDetails[name] or ""))
                    colIndex = colIndex + 1
                end
            end
        end

        listView.OnRowRightClick = function(_, _, ln)
            if not (ln and ln.CharID) then return end
            if not (LocalPlayer():hasPrivilege("Manage Characters") or LocalPlayer():hasPrivilege("Ban Offline") or LocalPlayer():hasPrivilege("Unban Offline")) then return end
            local dMenu = DermaMenu()
            if LocalPlayer():hasPrivilege("Manage Characters") then
                local opt1 = dMenu:AddOption(L("banCharacter"), function()
                    LocalPlayer():ConCommand([[say "/charban ]] .. ln.CharID .. [["]])
                end)
                opt1:SetIcon("icon16/cancel.png")
                local opt2 = dMenu:AddOption(L("unbanCharacter"), function()
                    LocalPlayer():ConCommand([[say "/charunban ]] .. ln.CharID .. [["]])
                end)
                opt2:SetIcon("icon16/accept.png")
            end

            if LocalPlayer():hasPrivilege("Ban Offline") then
                local opt3 = dMenu:AddOption(L("banCharacterOffline"), function()
                    LocalPlayer():ConCommand([[say "/charbanoffline ]] .. ln.CharID .. [["]])
                end)
                opt3:SetIcon("icon16/cancel.png")
            end

            if LocalPlayer():hasPrivilege("Unban Offline") then
                local opt4 = dMenu:AddOption(L("unbanCharacterOffline"), function()
                    LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. ln.CharID .. [["]])
                end)
                opt4:SetIcon("icon16/accept.png")
            end

            dMenu:Open()
        end
    end
end)