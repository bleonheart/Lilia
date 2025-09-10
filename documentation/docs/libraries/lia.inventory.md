# Inventory Library

This page documents the functions for working with inventory management and storage systems.

---

## Overview

The inventory library (`lia.inventory`) provides a comprehensive system for managing inventories in the Lilia framework. It handles inventory types, instances, storage registration, and provides utilities for managing character inventories, storage containers, and vehicle trunks. The library supports both server-side inventory management and client-side UI integration.

---

### lia.inventory.newType

**Purpose**

Registers a new inventory type with specified structure and methods.

**Parameters**

* `typeID` (*string*): The unique identifier for the inventory type.
* `invTypeStruct` (*table*): The inventory type structure containing methods and properties.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a new inventory type
lia.inventory.newType("player", {
    className = "PlayerInventory",
    config = {
        w = 10,
        h = 5
    },
    add = function(self, item)
        -- Add item logic
        return true
    end,
    remove = function(self, item)
        -- Remove item logic
        return true
    end,
    sync = function(self)
        -- Sync inventory logic
    end
})
```

### lia.inventory.new

**Purpose**

Creates a new inventory instance of the specified type.

**Parameters**

* `typeID` (*string*): The inventory type identifier.

**Returns**

* `inventory` (*table*): The new inventory instance.

**Realm**

Shared.

**Example Usage**

```lua
-- Create a new player inventory
local inventory = lia.inventory.new("player")
print("Created inventory with ID: " .. inventory.id)

-- Create a storage inventory
local storage = lia.inventory.new("storage")
```

### lia.inventory.loadByID

**Purpose**

Loads an inventory instance by its ID from storage.

**Parameters**

* `id` (*number*): The inventory ID to load.
* `noCache` (*boolean*, optional): Whether to bypass cache and force reload.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the inventory instance.

**Realm**

Server.

**Example Usage**

```lua
-- Load inventory by ID
lia.inventory.loadByID(123):next(function(inventory)
    print("Loaded inventory: " .. inventory.id)
    print("Inventory type: " .. inventory.typeID)
end):catch(function(err)
    print("Failed to load inventory: " .. err)
end)

-- Force reload from storage
lia.inventory.loadByID(123, true):next(function(inventory)
    print("Force reloaded inventory")
end)
```

### lia.inventory.loadFromDefaultStorage

**Purpose**

Loads an inventory from the default storage system.

**Parameters**

* `id` (*number*): The inventory ID to load.
* `noCache` (*boolean*, optional): Whether to bypass cache.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the inventory instance.

**Realm**

Server.

**Example Usage**

```lua
-- Load from default storage
lia.inventory.loadFromDefaultStorage(456):next(function(inventory)
    print("Loaded from default storage")
end)
```

### lia.inventory.instance

**Purpose**

Creates a new inventory instance and initializes it in storage.

**Parameters**

* `typeID` (*string*): The inventory type identifier.
* `initialData` (*table*, optional): Initial data for the inventory.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the inventory instance.

**Realm**

Server.

**Example Usage**

```lua
-- Create and initialize a new inventory
lia.inventory.instance("player", {
    char = 123,
    w = 10,
    h = 5
}):next(function(inventory)
    print("Created and initialized inventory: " .. inventory.id)
end)
```

### lia.inventory.loadAllFromCharID

**Purpose**

Loads all inventories associated with a character ID.

**Parameters**

* `charID` (*number*): The character ID to load inventories for.

**Returns**

* `promise` (*Deferred*): A promise that resolves with an array of inventory instances.

**Realm**

Server.

**Example Usage**

```lua
-- Load all inventories for a character
lia.inventory.loadAllFromCharID(123):next(function(inventories)
    print("Loaded " .. #inventories .. " inventories for character")
    
    for _, inventory in ipairs(inventories) do
        print("  - Inventory " .. inventory.id .. " (" .. inventory.typeID .. ")")
    end
end)
```

### lia.inventory.deleteByID

**Purpose**

Deletes an inventory and all its associated data from storage.

**Parameters**

* `id` (*number*): The inventory ID to delete.

**Realm**

Server.

**Example Usage**

```lua
-- Delete an inventory
lia.inventory.deleteByID(123)
print("Inventory deleted")

-- Delete with error handling
local success = pcall(function()
    lia.inventory.deleteByID(456)
end)

if success then
    print("Inventory deleted successfully")
else
    print("Failed to delete inventory")
end
```

### lia.inventory.cleanUpForCharacter

**Purpose**

Cleans up all inventories associated with a character.

**Parameters**

* `character` (*table*): The character object to clean up inventories for.

**Realm**

Server.

**Example Usage**

```lua
-- Clean up character inventories
lia.inventory.cleanUpForCharacter(character)
print("Character inventories cleaned up")
```

### lia.inventory.registerStorage

**Purpose**

Registers a storage container with specified model and data.

**Parameters**

* `model` (*string*): The model path for the storage container.
* `data` (*table*): The storage data containing name, inventory type, and inventory data.

**Returns**

* `storageData` (*table*): The registered storage data.

**Realm**

Server.

**Example Usage**

```lua
-- Register a storage container
lia.inventory.registerStorage("models/props_c17/lockers001a.mdl", {
    name = "Locker",
    invType = "storage",
    invData = {
        w = 8,
        h = 6
    }
})

-- Register a chest storage
lia.inventory.registerStorage("models/props_junk/wood_crate001a.mdl", {
    name = "Wooden Chest",
    invType = "storage",
    invData = {
        w = 12,
        h = 8
    }
})
```

### lia.inventory.getStorage

**Purpose**

Gets storage data for a specific model.

**Parameters**

* `model` (*string*): The model path to get storage data for.

**Returns**

* `storageData` (*table*): The storage data or nil if not found.

**Realm**

Server.

**Example Usage**

```lua
-- Get storage data for a model
local storageData = lia.inventory.getStorage("models/props_c17/lockers001a.mdl")
if storageData then
    print("Storage name: " .. storageData.name)
    print("Inventory type: " .. storageData.invType)
else
    print("No storage data found for model")
end
```

### lia.inventory.registerTrunk

**Purpose**

Registers a vehicle trunk with specified class and data.

**Parameters**

* `vehicleClass` (*string*): The vehicle class name.
* `data` (*table*): The trunk data containing name, inventory type, and inventory data.

**Returns**

* `trunkData` (*table*): The registered trunk data.

**Realm**

Server.

**Example Usage**

```lua
-- Register a car trunk
lia.inventory.registerTrunk("prop_vehicle_jeep", {
    name = "Car Trunk",
    invType = "trunk",
    invData = {
        w = 6,
        h = 4
    }
})

-- Register a truck trunk
lia.inventory.registerTrunk("prop_vehicle_airboat", {
    name = "Truck Bed",
    invType = "trunk",
    invData = {
        w = 10,
        h = 6
    }
})
```

### lia.inventory.getTrunk

**Purpose**

Gets trunk data for a specific vehicle class.

**Parameters**

* `vehicleClass` (*string*): The vehicle class to get trunk data for.

**Returns**

* `trunkData` (*table*): The trunk data or nil if not found.

**Realm**

Server.

**Example Usage**

```lua
-- Get trunk data for a vehicle
local trunkData = lia.inventory.getTrunk("prop_vehicle_jeep")
if trunkData then
    print("Trunk name: " .. trunkData.name)
    print("Trunk size: " .. trunkData.invData.w .. "x" .. trunkData.invData.h)
else
    print("No trunk data found for vehicle class")
end
```

### lia.inventory.getAllTrunks

**Purpose**

Gets all registered trunk data.

**Returns**

* `trunks` (*table*): Table of all trunk data with vehicle classes as keys.

**Realm**

Server.

**Example Usage**

```lua
-- Get all trunks
local trunks = lia.inventory.getAllTrunks()
print("Registered trunks:")

for vehicleClass, trunkData in pairs(trunks) do
    print("  - " .. vehicleClass .. ": " .. trunkData.name)
end
```

### lia.inventory.getAllStorage

**Purpose**

Gets all registered storage data, optionally excluding trunks.

**Parameters**

* `includeTrunks` (*boolean*, optional): Whether to include trunks (default: true).

**Returns**

* `storageData` (*table*): Table of all storage data.

**Realm**

Server.

**Example Usage**

```lua
-- Get all storage (including trunks)
local allStorage = lia.inventory.getAllStorage()
print("All storage containers: " .. table.Count(allStorage))

-- Get only non-trunk storage
local storageOnly = lia.inventory.getAllStorage(false)
print("Storage containers only: " .. table.Count(storageOnly))
```

### lia.inventory.show

**Purpose**

Shows an inventory panel to the client.

**Parameters**

* `inventory` (*table*): The inventory instance to show.
* `parent` (*Panel*, optional): The parent panel for the inventory UI.

**Returns**

* `panel` (*Panel*): The created inventory panel.

**Realm**

Client.

**Example Usage**

```lua
-- Show inventory panel
local panel = lia.inventory.show(inventory)
print("Inventory panel shown")

-- Show inventory with parent panel
local panel = lia.inventory.show(inventory, parentPanel)
```

## Inventory Types

The inventory system supports different types of inventories:

### Player Inventory
- **Type ID**: "player"
- **Purpose**: Character's personal inventory
- **Default Size**: 10x5 (configurable)

### Storage Inventory
- **Type ID**: "storage"
- **Purpose**: Storage containers and lockers
- **Default Size**: 8x6 (configurable)

### Trunk Inventory
- **Type ID**: "trunk"
- **Purpose**: Vehicle trunks and storage
- **Default Size**: 6x4 (configurable)

## Storage Registration

Storage containers are registered by model path and can be used by entities:

```lua
-- Register a locker storage
lia.inventory.registerStorage("models/props_c17/lockers001a.mdl", {
    name = "Locker",
    invType = "storage",
    invData = {
        w = 8,
        h = 6
    }
})

-- Register a chest storage
lia.inventory.registerStorage("models/props_junk/wood_crate001a.mdl", {
    name = "Wooden Chest",
    invType = "storage",
    invData = {
        w = 12,
        h = 8
    }
})
```

## Trunk Registration

Vehicle trunks are registered by vehicle class:

```lua
-- Register car trunk
lia.inventory.registerTrunk("prop_vehicle_jeep", {
    name = "Car Trunk",
    invType = "trunk",
    invData = {
        w = 6,
        h = 4
    }
})

-- Register truck trunk
lia.inventory.registerTrunk("prop_vehicle_airboat", {
    name = "Truck Bed",
    invType = "trunk",
    invData = {
        w = 10,
        h = 6
    }
})
```

## Example Usage

```lua
-- Create a new inventory type
lia.inventory.newType("custom", {
    className = "CustomInventory",
    config = {
        w = 15,
        h = 10
    },
    add = function(self, item)
        -- Custom add logic
        return true
    end,
    remove = function(self, item)
        -- Custom remove logic
        return true
    end,
    sync = function(self)
        -- Custom sync logic
    end
})

-- Create and initialize inventory
lia.inventory.instance("custom", {
    char = 123,
    w = 15,
    h = 10
}):next(function(inventory)
    print("Custom inventory created: " .. inventory.id)
end)

-- Load character inventories
lia.inventory.loadAllFromCharID(123):next(function(inventories)
    print("Loaded " .. #inventories .. " inventories")
end)
```
