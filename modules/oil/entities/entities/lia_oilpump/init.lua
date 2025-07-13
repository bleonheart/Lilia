AddCSLuaFile()
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
    self:setNetVar("ready", CurTime())
end

function ENT:Use(client)
    if not self:isReady() or self.pumping then return end
    local char = client:getChar()
    if not char then return end
    self.pumping = true
    local actionTime = lia.config.get("OilPumpActionTime", 5)
    client:setAction(L("oilPumping", "Pumping oil"), actionTime, function()
        if not IsValid(self) or not IsValid(client) then return end
        local amount = lia.config.get("OilPumpYield", 1)
        for _ = 1, amount do
            char:getInv():add("low_quality_oil")
        end
        self:setNetVar("ready", CurTime() + lia.config.get("OilPumpCooldown", 60))
        self.pumping = false
    end)
    client:doStaredAction(self, function() end, actionTime, function()
        self.pumping = false
        if IsValid(client) then client:setAction() end
    end)
end
