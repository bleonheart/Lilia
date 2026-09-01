local playerMeta = FindMetaTable("Player")

function playerMeta:getItemWeapon()
    local character = self:getChar()
    local inv = character:getInv()
    local items = inv:getItems()
    local weapon = self:GetActiveWeapon()
    if not IsValid(weapon) then return nil end
    for _, v in pairs(items) do
        if v.class then
            if v.class == weapon:GetClass() and v:getData("equip", false) then return weapon, v end
            return nil
        end
    end
end

function playerMeta:isFamilySharedAccount()
    return util.SteamIDFrom64(self:OwnerSteamID64()) ~= self:SteamID()
end

function playerMeta:getItemDropPos()
    local data = {
        start = self:GetShootPos(),
        endpos = self:GetShootPos() + self:GetAimVector() * 86,
        filter = self
    }
    local trace = util.TraceLine(data)
    data.start = trace.HitPos
    data.endpos = data.start + trace.HitNormal * 46
    data.filter = {}
    return util.TraceLine(data).HitPos
end

function playerMeta:getItems()
    local character = self:getChar()
    if character then
        local inv = character:getInv()
        if inv then return inv:getItems() end
    end
end
