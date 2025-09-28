function ENT:onDrawEntityInfo(alpha)
    local text = lia.currency.get(self:getAmount())
    lia.util.drawEntText(self, text, 0)
end
