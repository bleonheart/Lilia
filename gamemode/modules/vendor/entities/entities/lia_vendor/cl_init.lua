function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
    if not self.hasSetupVars then self:setupVars() end
    local curTime = CurTime()
    local currentAnim = lia.vendor.getVendorProperty(self, "animation")
    if (self.lastAnimationCheck or "") ~= currentAnim and currentAnim ~= "" then
        self.lastAnimationCheck = currentAnim
        if self:isReadyForAnim() then self:setAnim() end
    end

    if (self.nextAnimCheck or 0) < curTime then
        if self:isReadyForAnim() then self:setAnim() end
        self.nextAnimCheck = curTime + 5
    end

    self:SetNextClientThink(curTime + 0.5)
    return true
end

ENT.DrawInfo = {
    {
        text = function(ent)
            local name = lia.vendor.getVendorProperty(ent, "name")
            if not lia.vendor.stored[ent] or not lia.vendor.stored[ent]["name"] then
                net.Start("liaVendorRequestData")
                net.WriteEntity(ent)
                net.SendToServer()
            end
            return name
        end,
        posY = 0
    }
}
