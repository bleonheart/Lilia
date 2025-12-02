local RULES = {
    AccessIfStorageReceiver = function(inventory, _, context)
        local client = context.client
        if not IsValid(client) then return end
        local storage = context.storage or client.liaStorageEntity
        if not IsValid(storage) then return end
        if storage:getInv() ~= inventory then return end
        local distance = storage:GetPos():Distance(client:GetPos())
        if distance > 128 then return false end
        if storage.receivers[client] then return true end
    end,
    AccessIfCarStorageReceiver = function(_, _, context)
        local client = context.client
        if not IsValid(client) then return end
        local storage = context.storage or client.liaStorageEntity
        if not IsValid(storage) then return end
        local distance = storage:GetPos():Distance(client:GetPos())
        if distance > 128 then return false end
        if storage.receivers[client] then return true end
    end
}

function MODULE:PlayerSpawnedProp(client, model, entity)
    local data = lia.inventory.getStorage(model:lower())
    if not data then return end
    if hook.Run("CanPlayerSpawnStorage", client, entity, data) == false then return end
    local storage = ents.Create("lia_storage")
    storage:SetPos(entity:GetPos())
    storage:SetAngles(entity:GetAngles())
    storage:Spawn()
    storage:SetModel(model)
    storage:SetSolid(SOLID_VPHYSICS)
    storage:PhysicsInit(SOLID_VPHYSICS)
    lia.inventory.instance(data.invType, data.invData):next(function(inventory)
        if IsValid(storage) then
            inventory.isStorage = true
            storage:setInventory(inventory)
            self:SaveData()
            if isfunction(data.OnSpawn) then data.OnSpawn(storage) end
        end
    end, function(err)
        lia.error(L("unableCreateStorageEntity", client:Name(), err))
        if IsValid(storage) then SafeRemoveEntity(storage) end
    end)

    SafeRemoveEntity(entity)
end

function MODULE:CanPlayerSpawnStorage(client, _, info)
    if not client then return true end
    if not client:hasPrivilege("canSpawnStorage") then return false end
    if not info.invType or not lia.inventory.types[info.invType] then return false end
end

function MODULE:StorageItemRemoved()
    self:SaveData()
end

function MODULE:InventoryItemAdded(inventory)
    if inventory.isStorage then self:SaveData() end
end

local PROHIBITED_ACTIONS = {
    [L("equip")] = true,
    [L("unequip")] = true,
    [L("use")] = true,
    [L("drop")] = true,
}

function MODULE:CanPlayerInteractItem(_, action, itemObject)
    local inventory = lia.inventory.instances[itemObject.invID]
    if inventory and inventory.isStorage and PROHIBITED_ACTIONS[action] then return false, "forbiddenActionStorage" end
end

function MODULE:StorageCanTransferItem(client, storage, item)
    if not IsValid(client) or not item then return end
    local clientInv = client:getChar() and client:getChar():getInv()
    if not clientInv then return end
    if item.invID == clientInv:getID() then
        if item:getData("equip", false) then
            if IsValid(client) then client:notifyErrorLocalized("cannotTransferEquippedItem") end
            return false
        end
    end
end

function MODULE:CanItemBeTransfered(item, oldInventory, newInventory, client)
    if not IsValid(client) or not item or not oldInventory or not newInventory then return true end
    
    -- Check if item is equipped
    local isEquipped = item:getData("equip", false)
    if not isEquipped then return true end
    
    -- Check if destination is storage
    local isStorageInv = newInventory.isStorage == true
    local newInvID = newInventory:getID()
    
    -- If isStorage flag not set, check if inventory belongs to storage entity
    if not isStorageInv then
        for _, ent in ipairs(ents.FindByClass("lia_storage")) do
            if IsValid(ent) then
                local storageInvID = ent:getNetVar("id")
                if storageInvID and storageInvID == newInvID then
                    isStorageInv = true
                    break
                end
            end
        end
    end
    
    -- Check vehicle trunks
    if not isStorageInv then
        for _, ent in ipairs(ents.GetAll()) do
            if IsValid(ent) and ent:getNetVar("hasStorage", false) then
                local trunkInvID = ent:getNetVar("inv")
                if trunkInvID and trunkInvID == newInvID then
                    isStorageInv = true
                    break
                end
            end
        end
    end
    
    -- Block transfer if item is equipped and destination is storage
    if isEquipped and isStorageInv then
        local clientInv = client:getChar() and client:getChar():getInv()
        if clientInv and oldInventory:getID() == clientInv:getID() then
            if IsValid(client) then
                client:notifyErrorLocalized("cannotTransferEquippedItem")
            end
            return false, "cannotTransferEquippedItem"
        end
    end
    
    return true
end

function MODULE:EntityRemoved(entity)
    if self:IsSuitableForTrunk(entity) == false then return end
    local storageInv = lia.inventory.instances[entity:getNetVar("inv")]
    if storageInv then storageInv:delete() end
    entity.liaStorageInitPromise = nil
    entity.receivers = nil
end

function MODULE:OnEntityCreated(entity)
    if self:IsSuitableForTrunk(entity) == false then return end
    self:InitializeStorage(entity)
end

function MODULE:StorageInventorySet(_, inventory, isCar)
    inventory:addAccessRule(isCar and RULES.AccessIfCarStorageReceiver or RULES.AccessIfStorageReceiver)
    
    -- Add rule to prevent equipped items from being transferred to storage
    inventory:addAccessRule(function(inv, action, context)
        if action ~= "transfer" then return end
        if not context or not context.item or not context.from then return end
        
        local item = context.item
        local fromInv = context.from
        local client = context.client
        
        -- Check if item is equipped
        if not item:getData("equip", false) then return end
        
        -- Check if source is player's inventory
        if not IsValid(client) or not client:getChar() then return end
        local clientInv = client:getChar():getInv()
        if not clientInv or fromInv:getID() ~= clientInv:getID() then return end
        
        -- Block the transfer
        if IsValid(client) then
            client:notifyErrorLocalized("cannotTransferEquippedItem")
        end
        return false, "cannotTransferEquippedItem"
    end, 1) -- High priority
end

function MODULE:GetEntitySaveData(ent)
    if ent:GetClass() ~= "lia_storage" then return end
    local inventory = ent:getInv()
    local canSave = hook.Run("CanSaveData", ent, inventory)
    if canSave == false then return end
    return {
        id = ent:getNetVar("id"),
        password = ent.password
    }
end

function MODULE:OnEntityLoaded(ent, data)
    if ent:GetClass() ~= "lia_storage" or not data then return end
    if data.password then
        ent.password = data.password
        ent:setNetVar("locked", true)
    end

    local invID = data.id
    if invID then
        lia.inventory.loadByID(invID):next(function(inventory)
            if inventory and IsValid(ent) then
                inventory.isStorage = true
                ent:setInventory(inventory)
                hook.Run("StorageRestored", ent, inventory)
            elseif IsValid(ent) then
                SafeRemoveEntityDelayed(ent, 1)
            end
        end)
    end
end

function MODULE:SaveData()
    for _, ent in ipairs(ents.FindByClass("lia_storage")) do
        hook.Run("UpdateEntityPersistence", ent)
    end
end

lia.inventory.registerStorage("models/props_junk/wood_crate001a.mdl", {
    name = L("storageContainer"),
    invType = "GridInv",
    invData = {
        w = 6,
        h = 4
    }
})

lia.inventory.registerTrunk("vehicle", {
    name = L("vehicleTrunk"),
    invType = "GridInv",
    invData = {
        w = lia.config.get("trunkInvW", 10),
        h = lia.config.get("trunkInvH", 2)
    }
})
return RULES