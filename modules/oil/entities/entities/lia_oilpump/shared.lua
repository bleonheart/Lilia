ENT.Type = "anim"
ENT.PrintName = "Oil Pump"
ENT.Category = "Lilia"
ENT.Spawnable = true
ENT.DrawEntityInfo = true

function ENT:isReady()
    return CurTime() >= self:getNetVar("ready", 0)
end
