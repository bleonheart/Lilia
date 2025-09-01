ITEM.name = "entitiesName"
ITEM.model = ""
ITEM.desc = "entitiesDesc"
ITEM.category = "entities"
ITEM.entityid = ""
-- Function to restore essential entity data
local function restoreEntityData(entity, data)
    if not IsValid(entity) or not data then return end
    -- Basic visual properties
    if data.material and data.material ~= "" then entity:SetMaterial(data.material) end
    if data.color then entity:SetColor(data.color) end
    if data.skin then entity:SetSkin(data.skin) end
    -- Bodygroups
    if data.bodygroups and istable(data.bodygroups) then
        for i, bodygroup in pairs(data.bodygroups) do
            if isnumber(i) and i >= 0 then entity:SetBodygroup(i, bodygroup) end
        end
    end

    if data.angles then entity:SetAngles(data.angles) end
    -- Health properties
    if data.health and data.health > 0 then entity:SetHealth(data.health) end
    if data.maxHealth and data.maxHealth > 0 then entity:SetMaxHealth(data.maxHealth) end
    if data.netvars and istable(data.netvars) then
        for key, value in pairs(data.netvars) do
            entity:setNetVar(key, value)
        end
    end
end

ITEM.functions.Place = {
    name = "placeDownEntity",
    onRun = function(item)
        local client = item.player
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local entity = ents.Create(item.entityid)
        entity:SetPos(data.endpos)
        entity:Spawn()
        local entityData
        if SERVER then entityData = item:getEntity():getNetVar("entityData", {}) end
        -- Restore all saved data
        if entityData and table.Count(entityData) > 0 then
            restoreEntityData(entity, entityData)
        else
            -- Fallback to basic restoration from item data
            local itemData = item:getData()
            if itemData.angles then entity:SetAngles(itemData.angles) end
            if itemData.material and itemData.material ~= "" then entity:SetMaterial(itemData.material) end
            if itemData.color then entity:SetColor(itemData.color) end
            if itemData.skin then entity:SetSkin(itemData.skin) end
            if itemData.bodygroups and istable(itemData.bodygroups) then
                for i, bodygroup in pairs(itemData.bodygroups) do
                    if isnumber(i) and i >= 0 then entity:SetBodygroup(i, bodygroup) end
                end
            end

            -- Set health if it was saved
            if itemData.health and itemData.health > 0 then
                entity:SetHealth(itemData.health)
                if itemData.maxHealth and itemData.maxHealth > 0 then entity:SetMaxHealth(itemData.maxHealth) end
            end

            local physObj = entity:GetPhysicsObject()
            if IsValid(physObj) then
                physObj:EnableMotion(true)
                physObj:Wake()
            end
        end

        -- Remove the item from inventory after successful placement
        item:remove()
        return true
    end,
    onCanRun = function(item) return not IsValid(item.entity) end
}