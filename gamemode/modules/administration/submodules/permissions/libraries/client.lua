﻿local ESP_DrawnEntities = {
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

