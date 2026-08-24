function ENT:Draw()
    self:DrawModel()
end

ENT.DrawInfo = {
    {
        text = function(ent)
            local amount = ent:getAmount()
            if amount <= 0 then return end
            return lia.currency.get(amount)
        end,
        posY = 0
    }
}
