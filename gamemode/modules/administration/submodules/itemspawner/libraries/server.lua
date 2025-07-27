local function fixupProp(client, ent, mins, maxs)
    local pos = ent:GetPos()
    local down, up = ent:LocalToWorld(mins), ent:LocalToWorld(maxs)
    local trD = util.TraceLine({
        start = pos,
        endpos = down,
        filter = {ent, client}
    })

    local trU = util.TraceLine({
        start = pos,
        endpos = up,
        filter = {ent, client}
    })

    if trD.Hit and trU.Hit then return end
    if trD.Hit then ent:SetPos(pos + trD.HitPos - down) end
    if trU.Hit then ent:SetPos(pos + trU.HitPos - up) end
end

local function tryFixPropPosition(client, ent)
    local m, M = ent:OBBMins(), ent:OBBMaxs()
    fixupProp(client, ent, Vector(m.x, 0, 0), Vector(M.x, 0, 0))
    fixupProp(client, ent, Vector(0, m.y, 0), Vector(0, M.y, 0))
    fixupProp(client, ent, Vector(0, 0, m.z), Vector(0, 0, M.z))
end


