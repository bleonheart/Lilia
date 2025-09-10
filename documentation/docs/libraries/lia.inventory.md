# lia.inventory

## Overview
The `lia.inventory` library provides comprehensive inventory management for Lilia, including inventory types, storage systems, item management, and database integration. It supports different inventory types and provides a flexible system for managing player and entity inventories.

## Functions

### lia.inventory.newType
**Purpose**: Registers a new inventory type with the specified structure.

**Parameters**:
- `typeID` (string): Unique identifier for the inventory type
- `invTypeStruct` (table): Inventory type structure containing required methods and properties

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Register a new inventory type
lia.inventory.newType("player", {
    className = "PlayerInventory",
    typeID = "player",
    add = function(self, item) 
        -- Add item logic
        return true
    end,
    remove = function(self, item)
        -- Remove item logic
        return true
    end,
    sync = function(self, client)
        -- Sync inventory to client
    end
})

-- Register a storage inventory type
lia.inventory.newType("storage", {
    className = "StorageInventory",
    typeID = "storage",
    add = function(self, item)
        -- Storage add logic
        return true
    end,
    remove = function(self, item)
        -- Storage remove logic
        return true
    end,
    sync = function(self, client)
        -- Storage sync logic
    end
})
```

### lia.inventory.new
**Purpose**: Creates a new inventory instance of the specified type.

**Parameters**:
- `typeID` (string): Inventory type identifier

**Returns**: New inventory instance

**Realm**: Shared

**Example Usage**:
```lua
-- Create a new player inventory
local playerInv = lia.inventory.new("player")

-- Create a new storage inventory
local storageInv = lia.inventory.new("storage")

-- Use the inventory
if playerInv then
    print("Created inventory with", #playerInv.items, "items")
end
```

### lia.inventory.loadByID
**Purpose**: Loads an inventory from the database by its ID.

**Parameters**:
- `id` (number): Inventory ID
- `noCache` (boolean): Whether to bypass cache

**Returns**: Promise that resolves to inventory instance

**Realm**: Server

**Example Usage**:
```lua
-- Load inventory by ID
lia.inventory.loadByID(123):next(function(inventory)
    if inventory then
        print("Loaded inventory:", inventory.id)
        print("Items:", #inventory.items)
    else
        print("Inventory not found")
    end
end):catch(function(err)
    print("Failed to load inventory:", err)
end)

-- Load without cache
lia.inventory.loadByID(123, true):next(function(inventory)
    print("Fresh inventory loaded")
end)
```

### lia.inventory.loadFromDefaultStorage
**Purpose**: Loads an inventory from the default storage system.

**Parameters**:
- `id` (number): Inventory ID
- `noCache` (boolean): Whether to bypass cache

**Returns**: Promise that resolves to inventory instance

**Realm**: Server

**Example Usage**:
```lua
-- Load from default storage
lia.inventory.loadFromDefaultStorage(456):next(function(inventory)
    if inventory then
        print("Loaded from default storage")
        inventory:onLoaded()
    end
end)
```

### lia.inventory.instance
**Purpose**: Creates a new inventory instance with initial data.

**Parameters**:
- `typeID` (string): Inventory type identifier
- `initialData` (table): Initial data for the inventory

**Returns**: Promise that resolves to inventory instance

**Realm**: Server

**Example Usage**:
```lua
-- Create new inventory instance
lia.inventory.instance("player", {
    char = 123,
    maxWeight = 100
}):next(function(inventory)
    print("Created inventory with ID:", inventory.id)
    inventory:onInstanced()
end)
```

### lia.inventory.loadAllFromCharID
**Purpose**: Loads all inventories for a specific character.

**Parameters**:
- `charID` (number): Character ID

**Returns**: Promise that resolves to array of inventory instances

**Realm**: Server

**Example Usage**:
```lua
-- Load all inventories for character
lia.inventory.loadAllFromCharID(123):next(function(inventories)
    print("Loaded", #inventories, "inventories for character")
    for _, inv in ipairs(inventories) do
        print("- Inventory", inv.id, "Type:", inv.typeID)
    end
end)
```

### lia.inventory.deleteByID
**Purpose**: Deletes an inventory and all its data from the database.

**Parameters**:
- `id` (number): Inventory ID

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Delete inventory by ID
lia.inventory.deleteByID(123)
print("Inventory deleted")

-- Delete with cleanup
local inventory = lia.inventory.instances[123]
if inventory then
    inventory:destroy()
end
lia.inventory.deleteByID(123)
```

### lia.inventory.cleanUpForCharacter
**Purpose**: Cleans up all inventories for a character.

**Parameters**:
- `character` (table): Character object

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Clean up character inventories
local character = player:getChar()
if character then
    lia.inventory.cleanUpForCharacter(character)
    print("Cleaned up inventories for character")
end
```

### lia.inventory.registerStorage
**Purpose**: Registers a storage entity with inventory data.

**Parameters**:
- `model` (string): Entity model path
- `data` (table): Storage configuration data

**Returns**: Storage data table

**Realm**: Server

**Example Usage**:
```lua
-- Register a storage entity
lia.inventory.registerStorage("models/props_c17/cashregister01a.mdl", {
    name = "Cash Register",
    invType = "storage",
    invData = {
        w = 5,
        h = 3
    }
})

-- Register a safe
lia.inventory.registerStorage("models/props_c17/suitcase_passenger_physics.mdl", {
    name = "Safe",
    invType = "storage",
    invData = {
        w = 4,
        h = 4
    }
})
```

### lia.inventory.getStorage
**Purpose**: Gets storage data for a specific model.

**Parameters**:
- `model` (string): Entity model path

**Returns**: Storage data table or nil

**Realm**: Server

**Example Usage**:
```lua
-- Get storage data for model
local storageData = lia.inventory.getStorage("models/props_c17/cashregister01a.mdl")
if storageData then
    print("Storage name:", storageData.name)
    print("Inventory type:", storageData.invType)
    print("Size:", storageData.invData.w, "x", storageData.invData.h)
end
```

### lia.inventory.registerTrunk
**Purpose**: Registers a vehicle trunk with inventory data.

**Parameters**:
- `vehicleClass` (string): Vehicle class name
- `data` (table): Trunk configuration data

**Returns**: Trunk data table

**Realm**: Server

**Example Usage**:
```lua
-- Register car trunk
lia.inventory.registerTrunk("prop_vehicle_jeep", {
    name = "Car Trunk",
    invType = "vehicle",
    invData = {
        w = 6,
        h = 4
    }
})

-- Register truck trunk
lia.inventory.registerTrunk("prop_vehicle_airboat", {
    name = "Truck Bed",
    invType = "vehicle",
    invData = {
        w = 8,
        h = 6
    }
})
```

### lia.inventory.getTrunk
**Purpose**: Gets trunk data for a specific vehicle class.

**Parameters**:
- `vehicleClass` (string): Vehicle class name

**Returns**: Trunk data table or nil

**Realm**: Server

**Example Usage**:
```lua
-- Get trunk data for vehicle
local trunkData = lia.inventory.getTrunk("prop_vehicle_jeep")
if trunkData then
    print("Trunk name:", trunkData.name)
    print("Trunk size:", trunkData.invData.w, "x", trunkData.invData.h)
end
```

### lia.inventory.getAllTrunks
**Purpose**: Gets all registered vehicle trunks.

**Parameters**: None

**Returns**: Table of all trunk data

**Realm**: Server

**Example Usage**:
```lua
-- Get all trunks
local trunks = lia.inventory.getAllTrunks()
print("Registered trunks:")
for vehicleClass, data in pairs(trunks) do
    print("- " .. vehicleClass .. ": " .. data.name)
end
```

### lia.inventory.getAllStorage
**Purpose**: Gets all registered storage entities.

**Parameters**:
- `includeTrunks` (boolean): Whether to include vehicle trunks

**Returns**: Table of all storage data

**Realm**: Server

**Example Usage**:
```lua
-- Get all storage (including trunks)
local allStorage = lia.inventory.getAllStorage()
print("All storage entities:")
for model, data in pairs(allStorage) do
    print("- " .. model .. ": " .. data.name)
end

-- Get only non-trunk storage
local storageOnly = lia.inventory.getAllStorage(false)
print("Storage entities only:")
for model, data in pairs(storageOnly) do
    print("- " .. model .. ": " .. data.name)
end
```

### lia.inventory.show
**Purpose**: Shows an inventory panel to the client.

**Parameters**:
- `inventory` (table): Inventory instance
- `parent` (Panel): Parent panel (optional)

**Returns**: Inventory panel

**Realm**: Client

**Example Usage**:
```lua
-- Show inventory panel
local inventory = player:getChar():getInv()
if inventory then
    local panel = lia.inventory.show(inventory)
    if panel then
        print("Inventory panel shown")
    end
end

-- Show inventory with parent
local parentPanel = vgui.Create("DPanel")
local inventoryPanel = lia.inventory.show(inventory, parentPanel)
```