function ENT:Draw()
    self:DrawModel()
end

ENT.DrawInfo = {
    {
        text = function(ent) return "Ammo Box" end,
        posY = 0
    },
    {
        text = function(ent) return "Refills your active weapon" end,
        posY = 40
    }
}
