function ENT:Draw()
    self:DrawModel()
end

ENT.DrawInfo = {
    {text = function(ent) return L("liaAmmoBoxName") end, posY = 0},
    {text = function(ent) return L("liaAmmoBoxDesc") end, posY = 40}
}
