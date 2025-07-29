﻿local vectorMeta = FindMetaTable("Vector")
local toScreen = vectorMeta.ToScreen
function ENT:computeDescMarkup(description)
    if self.desc ~= description then
        self.desc = description
        self.markup = lia.markup.parse("<font=liaItemDescFont>" .. description .. "</font>", ScrW() * 0.5)
    end
    return self.markup
end

function ENT:onDrawEntityInfo(alpha)
    if IsValid(lia.gui.itemPanel) then return end
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 200 * 200 then return end
    local item = self:getItemTable()
    if not item then return end
    local oldE, oldD = item.entity, item.data
    item.entity, item.data = self, self:getNetVar("data") or oldD
    local pos = toScreen(self:LocalToWorld(self:OBBCenter()))
    local x, y = pos.x, pos.y
    local name = L(item.getName and item:getName() or item.name)
    surface.SetFont("liaHugeText")
    local tw, th = surface.GetTextSize(name)
    draw.SimpleText(name, "liaHugeText", x, y, ColorAlpha(lia.config.get("Color"), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    y = y + th + 80
    local desc = item:getDesc()
    self:computeDescMarkup("<font=liaMediumFont>" .. desc .. "</font>", tw)
    if self.markup then self.markup:draw(x - tw / 2, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, alpha) end
    hook.Run("DrawItemDescription", self, x, y, ColorAlpha(color_white, alpha), alpha)
    item.data, item.entity = oldD, oldE
end

function ENT:DrawTranslucent()
    local itemTable = self:getItemTable()
    if itemTable and itemTable.drawEntity then
        itemTable:drawEntity(self)
    else
        self:DrawModel()
    end
end
