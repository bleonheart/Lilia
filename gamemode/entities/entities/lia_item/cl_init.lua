function ENT:computeDescMarkup(description)
    if self.desc ~= description then
        self.desc = description
        self.markup = lia.markup.parse("<font=LiliaFont.16>" .. description .. "</font>", ScrW() * 0.5)
    end
    return self.markup
end

function ENT:onDrawEntityInfo(alpha)
    if IsValid(lia.gui.itemPanel) then return end
    local item = self:getItemTable()
    if not item then return end
    local oldE, oldD = item.entity, item.data
    item.entity, item.data = self, self:getNetVar("data") or oldD
    local infoTable = {
        {
            text = item.getName and item:getName() or item.name,
            yOffset = 0
        }
    }

    hook.Run("DrawItemEntityInfo", self, item, infoTable, alpha)
    for i, info in ipairs(infoTable) do
        local text = isfunction(info.text) and info.text(self) or info.text
        lia.util.drawEntText(self, text, info.posY or (i - 1) * 50, alpha)
    end

    item.data, item.entity = oldD, oldE
end

function ENT:DrawTranslucent()
    local itemTable = self:getItemTable()
    if itemTable and itemTable.drawEntity then
        itemTable:drawEntity(self)
    else
        local paintMat = itemTable and hook.Run("PaintItem", itemTable)
        if isstring(paintMat) and paintMat ~= "" then self:SetMaterial(paintMat) end
        self:DrawModel()
    end
end
