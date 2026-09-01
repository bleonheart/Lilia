if SERVER then
net.Receive("liaStorageSyncRequest", function(_, client)
    net.Start("liaStorageSync")
    net.WriteTable(lia.inventory.storage)
    net.Send(client)
end)

net.Receive("liaTransferItem", function(_, client)
    local itemID = net.ReadUInt(32)
    local x = net.ReadUInt(32)
    local y = net.ReadUInt(32)
    local invID = net.ReadType()
    local hasRotatedOverride = net.ReadBool()
    local rotated = hasRotatedOverride and net.ReadBool() or nil
    hook.Run("HandleItemTransferRequest", client, itemID, x, y, invID, rotated)
end)

net.Receive("liaInvAct", function(_, client)
    local action = net.ReadString()
    local rawItem = net.ReadType()
    local data = net.ReadType()
    local character = client:getChar()
    if not character then return end
    local entity
    local item
    if isentity(rawItem) then
        if not IsValid(rawItem) then return end
        if rawItem:GetPos():Distance(client:GetPos()) > 96 then return end
        if not rawItem.liaItemID then return end
        entity = rawItem
        item = lia.item.instances[rawItem.liaItemID]
    else
        item = lia.item.instances[rawItem]
    end

    if not item then return end
    local inventory = lia.inventory.instances[item.invID]
    if inventory then
        local ok = inventory:canAccess("item", {
            client = client,
            item = item,
            entity = entity,
            action = action
        })

        if not ok then return end
    end

    item:interact(action, client, entity, data)
end)

net.Receive("liaItemRotate", function(_, client)
    local itemID = net.ReadUInt(32)
    local rotated = net.ReadBool()
    local item = lia.item.instances[itemID]
    if not item then return end
    local inventory = lia.inventory.instances[item.invID]
    if not inventory then return end
    local canAccess = inventory:canAccess("item", {
        client = client,
        item = item,
        action = "rotate"
    })

    if not canAccess then return end
    item:setData("rotated", rotated)
    item.forceRender = true
end)
end

if CLIENT then
net.Receive("liaOpenInvMenu", function()
    local client = LocalPlayer()
    local permission = IsValid(client) and client:hasPrivilege("checkInventories") or false
    if not permission then return end
    local target = net.ReadEntity()
    local index = net.ReadType()
    local targetInv = lia.inventory.instances[index]
    local myInv = client:getChar():getInv()
    local panels = lia.inventory.showDual(myInv, targetInv)
    if panels and panels[1] and panels[2] then panels[2]:SetTitle(string.format("%s's Inventory", target:getChar():getName())) end
end)

net.Receive("liaInvData", function()
    local id = net.ReadUInt(32)
    local key = net.ReadString()
    local value = net.ReadType()
    local item = lia.item.instances[id]
    if item then
        item.data = item.data or {}
        local oldValue = item.data[key]
        item.data[key] = value
        hook.Run("ItemDataChanged", item, key, oldValue, value)
    end
end)

net.Receive("liaInvQuantity", function()
    local id = net.ReadUInt(32)
    local quantity = net.ReadUInt(32)
    local item = lia.item.instances[id]
    if item then
        local oldValue = item:getQuantity()
        item.quantity = quantity
        hook.Run("ItemQuantityChanged", item, oldValue, quantity)
    end
end)

net.Receive("liaStorageSync", function() lia.inventory.storage = net.ReadTable() end)

net.Receive("liaInventoryData", function()
    local id = net.ReadType()
    local key = net.ReadString()
    local value = net.ReadType()
    local instance = lia.inventory.instances[id]
    if not instance then
        lia.error(string.format("Got data %s for non-existent instance %s", key, id))
        return
    end

    local oldValue = instance.data[key]
    instance.data[key] = value
    instance:onDataChanged(key, oldValue, value)
    hook.Run("InventoryDataChanged", instance, key, oldValue, value)
end)

net.Receive("liaInventoryInit", function()
    local id = net.ReadType()
    local typeID = net.ReadString()
    local invData = net.ReadTable()
    local instance = lia.inventory.new(typeID)
    instance.id = id
    instance.data = invData
    instance.items = {}
    local length = net.ReadUInt(32)
    local compressedData = net.ReadData(length)
    local uncompressedData = util.Decompress(compressedData)
    local itemsTable = util.JSONToTable(uncompressedData)
    local function readItem(index)
        local entry = itemsTable[index]
        return entry.i, entry.u, entry.d, entry.q
    end

    for i = 1, #itemsTable do
        local itemID, itemType, itemData, quantity = readItem(i)
        local item = lia.item.new(itemType, itemID)
        item.data = table.Merge(item.data, itemData)
        item.invID = id
        item.quantity = quantity
        instance.items[itemID] = item
        hook.Run("ItemInitialized", item)
    end

    lia.inventory.instances[id] = instance
    hook.Run("InventoryInitialized", instance)
    for _, character in pairs(lia.char.getAll()) do
        for idx, inventory in pairs(character.vars.inv) do
            if inventory:getID() == id then character.vars.inv[idx] = instance end
        end
    end
end)

net.Receive("liaInventoryAdd", function()
    local itemID = net.ReadUInt(32)
    local invID = net.ReadType()
    local item = lia.item.instances[itemID]
    local inventory = lia.inventory.instances[invID]
    if item and inventory then
        inventory.items[itemID] = item
        hook.Run("InventoryItemAdded", inventory, item)
    end
end)

net.Receive("liaInventoryRemove", function()
    local itemID = net.ReadUInt(32)
    local invID = net.ReadType()
    local item = lia.item.instances[itemID]
    local inventory = lia.inventory.instances[invID]
    if item and inventory and inventory.items[itemID] then
        inventory.items[itemID] = nil
        item.invID = 0
        hook.Run("InventoryItemRemoved", inventory, item)
    end
end)

net.Receive("liaInventoryDelete", function()
    local invID = net.ReadType()
    local instance = lia.inventory.instances[invID]
    if instance then hook.Run("InventoryDeleted", instance) end
    if invID then lia.inventory.instances[invID] = nil end
end)

net.Receive("liaItemInstance", function()
    local itemID = net.ReadUInt(32)
    local itemType = net.ReadString()
    local data = net.ReadTable()
    local item = lia.item.new(itemType, itemID)
    local invID = net.ReadType()
    local quantity = net.ReadUInt(32)
    item.data = table.Merge(item.data or {}, data)
    item.invID = invID
    item.quantity = quantity
    lia.item.instances[itemID] = item
    hook.Run("ItemInitialized", item)
end)

net.Receive("liaCharacterInvList", function()
    local charID = net.ReadUInt(32)
    local length = net.ReadUInt(32)
    local inventories = {}
    for i = 1, length do
        inventories[i] = lia.inventory.instances[net.ReadType()]
    end

    lia.char.getCharacter(charID, nil, function(character) if character then character.vars.inv = inventories end end)
end)

net.Receive("liaItemDelete", function()
    local id = net.ReadUInt(32)
    local instance = lia.item.instances[id]
    if instance and instance.invID then
        local inventory = lia.inventory.instances[instance.invID]
        if not inventory or not inventory.items[id] then return end
        inventory.items[id] = nil
        instance.invID = 0
        hook.Run("InventoryItemRemoved", inventory, instance)
    end

    lia.item.instances[id] = nil
    hook.Run("ItemDeleted", instance)
end)
end
