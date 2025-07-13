include("shared.lua")

local vectorMeta = FindMetaTable("Vector")
local toScreen = vectorMeta.ToScreen

function ENT:onDrawEntityInfo(alpha)
    local pos = toScreen(self:LocalToWorld(self:OBBCenter()))
    local x, y = pos.x, pos.y
    local color = lia.config.get("Color")
    color.a = 255
    local text
    if self:isReady() then
        text = L("oilPumpReady", "Oil Ready")
    else
        local timeLeft = math.ceil(self:getNetVar("ready", 0) - CurTime())
        text = L("oilPumpNext", "Ready in %s", timeLeft)
    end
    lia.util.drawText(text, x, y, color, 1, 1, nil, alpha * 0.65)
end
