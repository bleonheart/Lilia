# lia.item

## Overview
The `lia.item` library provides comprehensive item management for Lilia, including item registration, instantiation, database operations, and item entity handling. It supports different item types, weapon generation, and provides a flexible system for managing items in inventories and the world.

## Functions

### lia.item.get
**Purpose**: Gets an item definition by its identifier.

**Parameters**:
- `identifier` (string): Item unique ID

**Returns**: Item definition table or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get item definition
local itemDef = lia.item.get("weapon_pistol")
if itemDef then
    print("Item name:", itemDef.name)
    print("Item description:", itemDef.desc)
    print("Item category:", itemDef.category)
end

-- Get base item
local baseItem = lia.item.get("base_weapons")
if baseItem then
    print("Base item found")
end
```

### lia.item.getItemByID
**Purpose**: Gets an item instance by its ID with location information.

**Parameters**:
- `itemID` (number): Item instance ID

**Returns**: Table containing item instance and location

**Realm**: Shared

**Example Usage**:
```lua
-- Get item by ID
local result = lia.item.getItemByID(123)
if result then
    print("Item found:", result.item:getName())
    print("Location:", result.location) -- "inventory", "world", or "unknown"
else
    print("Item not found")
end
```

### lia.item.getInstancedItemByID
**Purpose**: Gets an item instance by its ID.

**Parameters**:
- `itemID` (number): Item instance ID

**Returns**: Item instance or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get item instance
local item = lia.item.getInstancedItemByID(123)
if item then
    print("Item name:", item:getName())
    print("Item quantity:", item.quantity)
    print("Item data:", item.data)
end
```

### lia.item.getItemDataByID
**Purpose**: Gets item data by its ID.

**Parameters**:
- `itemID` (number): Item instance ID

**Returns**: Item data table or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get item data
local data = lia.item.getItemDataByID(123)
if data then
    print("Item data:")
    for key, value in pairs(data) do
        print("- " .. key .. ":", value)
    end
end
```

### lia.item.load
**Purpose**: Loads an item definition from a file path.

**Parameters**:
- `path` (string): File path to load
- `baseID` (string): Base item ID (optional)
- `isBaseItem` (boolean): Whether this is a base item

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Load item from file
lia.item.load("items/weapons/pistol.lua")

-- Load base item
lia.item.load("items/base/weapons.lua", nil, true)

-- Load item with base
lia.item.load("items/weapons/rifle.lua", "base_weapons")
```

### lia.item.isItem
**Purpose**: Checks if an object is a valid item.

**Parameters**:
- `object` (any): Object to check

**Returns**: Boolean indicating if object is an item

**Realm**: Shared

**Example Usage**:
```lua
-- Check if object is item
local item = lia.item.new("weapon_pistol", 123)
if lia.item.isItem(item) then
    print("This is a valid item")
else
    print("This is not an item")
end

-- Check entity
local entity = player:GetActiveWeapon()
if lia.item.isItem(entity) then
    print("Entity is an item")
end
```

### lia.item.getInv
**Purpose**: Gets an inventory by its ID.

**Parameters**:
- `invID` (number): Inventory ID

**Returns**: Inventory instance or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get inventory by ID
local inventory = lia.item.getInv(123)
if inventory then
    print("Inventory found with", #inventory.items, "items")
else
    print("Inventory not found")
end
```

### lia.item.register
**Purpose**: Registers a new item definition.

**Parameters**:
- `uniqueID` (string): Unique item identifier
- `baseID` (string): Base item ID (optional)
- `isBaseItem` (boolean): Whether this is a base item
- `path` (string): File path (optional)
- `luaGenerated` (boolean): Whether this is Lua generated

**Returns**: Item definition table

**Realm**: Shared

**Example Usage**:
```lua
-- Register custom item
local itemDef = lia.item.register("custom_sword", "base_weapons", false, "items/weapons/sword.lua")

-- Register base item
local baseDef = lia.item.register("base_tools", nil, true, "items/base/tools.lua")

-- Register Lua generated item
local generatedItem = lia.item.register("auto_weapon", "base_weapons", false, nil, true)
```

### lia.item.loadFromDir
**Purpose**: Loads all items from a directory.

**Parameters**:
- `directory` (string): Directory path

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Load items from directory
lia.item.loadFromDir("gamemode/items")

-- Load custom items
lia.item.loadFromDir("addons/myaddon/items")
```

### lia.item.new
**Purpose**: Creates a new item instance.

**Parameters**:
- `uniqueID` (string): Item unique ID
- `id` (number): Item instance ID

**Returns**: Item instance

**Realm**: Shared

**Example Usage**:
```lua
-- Create new item instance
local item = lia.item.new("weapon_pistol", 123)
if item then
    print("Created item:", item:getName())
    print("Item ID:", item.id)
    print("Item data:", item.data)
end
```

### lia.item.registerInv
**Purpose**: Registers an inventory type with specified dimensions.

**Parameters**:
- `invType` (string): Inventory type name
- `w` (number): Width
- `h` (number): Height

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Register player inventory
lia.item.registerInv("player", 10, 6)

-- Register storage inventory
lia.item.registerInv("storage", 8, 8)

-- Register vehicle trunk
lia.item.registerInv("trunk", 6, 4)
```

### lia.item.newInv
**Purpose**: Creates a new inventory instance for an owner.

**Parameters**:
- `owner` (number): Owner character ID
- `invType` (string): Inventory type
- `callback` (function): Callback function

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Create new inventory for character
lia.item.newInv(123, "player", function(inventory)
    if inventory then
        print("Created inventory for character", inventory.data.char)
        inventory:sync(player)
    end
end)

-- Create storage inventory
lia.item.newInv(0, "storage", function(inventory)
    print("Created storage inventory")
end)
```

### lia.item.createInv
**Purpose**: Creates a new inventory instance with specified dimensions.

**Parameters**:
- `w` (number): Width
- `h` (number): Height
- `id` (number): Inventory ID

**Returns**: Inventory instance

**Realm**: Shared

**Example Usage**:
```lua
-- Create inventory with dimensions
local inventory = lia.item.createInv(10, 6, 123)
if inventory then
    print("Created inventory with ID:", inventory.id)
    print("Dimensions:", inventory.data.w, "x", inventory.data.h)
end
```

### lia.item.addWeaponOverride
**Purpose**: Adds a weapon override for automatic weapon generation.

**Parameters**:
- `className` (string): Weapon class name
- `data` (table): Override data

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Override weapon properties
lia.item.addWeaponOverride("weapon_pistol", {
    name = "Custom Pistol",
    desc = "A modified pistol",
    category = "Custom Weapons",
    model = "models/weapons/w_pistol.mdl",
    width = 2,
    height = 1
})

-- Override weapon category
lia.item.addWeaponOverride("weapon_ar2", {
    category = "Assault Rifles",
    weaponCategory = "primary"
})
```

### lia.item.addWeaponToBlacklist
**Purpose**: Adds a weapon to the blacklist for automatic generation.

**Parameters**:
- `className` (string): Weapon class name

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Blacklist specific weapons
lia.item.addWeaponToBlacklist("weapon_fists")
lia.item.addWeaponToBlacklist("gmod_tool")
lia.item.addWeaponToBlacklist("weapon_medkit")

-- Blacklist base weapons
lia.item.addWeaponToBlacklist("weapon_base")
```

### lia.item.generateWeapons
**Purpose**: Automatically generates item definitions for all weapons.

**Parameters**: None

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Generate weapon items
lia.item.generateWeapons()
print("Generated weapon items")

-- Check generated weapons
for uniqueID, itemDef in pairs(lia.item.list) do
    if itemDef.base == "base_weapons" then
        print("Generated weapon:", uniqueID)
    end
end
```

### lia.item.generateAmmo
**Purpose**: Automatically generates item definitions for ammunition.

**Parameters**: None

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Generate ammo items
lia.item.generateAmmo()
print("Generated ammo items")

-- Check generated ammo
for uniqueID, itemDef in pairs(lia.item.list) do
    if itemDef.base == "base_entities" and itemDef.category == "Ammunition" then
        print("Generated ammo:", uniqueID)
    end
end
```

### lia.item.setItemDataByID
**Purpose**: Sets item data for a specific item ID.

**Parameters**:
- `itemID` (number): Item instance ID
- `key` (string): Data key
- `value` (any): Data value
- `receivers` (table): Receivers for network update (optional)
- `noSave` (boolean): Whether to skip saving (optional)
- `noCheckEntity` (boolean): Whether to skip entity check (optional)

**Returns**: Boolean indicating success

**Realm**: Server

**Example Usage**:
```lua
-- Set item data
local success, error = lia.item.setItemDataByID(123, "customData", "value")
if success then
    print("Item data set successfully")
else
    print("Failed to set item data:", error)
end

-- Set item data with network update
lia.item.setItemDataByID(123, "health", 100, {player})

-- Set item data without saving
lia.item.setItemDataByID(123, "tempData", "temporary", nil, true)
```

### lia.item.instance
**Purpose**: Creates a new item instance in the database.

**Parameters**:
- `index` (number|string): Inventory ID or unique ID
- `uniqueID` (string): Item unique ID
- `itemData` (table): Item data
- `x` (number): X position in inventory
- `y` (number): Y position in inventory
- `callback` (function): Callback function

**Returns**: Promise that resolves to item instance

**Realm**: Server

**Example Usage**:
```lua
-- Create item instance in inventory
lia.item.instance(123, "weapon_pistol", {}, 1, 1, function(item)
    if item then
        print("Created item:", item:getName())
        print("Item ID:", item.id)
    end
end)

-- Create item with data
lia.item.instance(123, "custom_item", {
    customData = "value",
    health = 100
}, 2, 3, function(item)
    print("Item created with custom data")
end)
```

### lia.item.deleteByID
**Purpose**: Deletes an item by its ID.

**Parameters**:
- `id` (number): Item instance ID

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Delete item by ID
lia.item.deleteByID(123)
print("Item deleted")

-- Delete item instance if exists
local item = lia.item.instances[123]
if item then
    item:delete()
end
```

### lia.item.loadItemByID
**Purpose**: Loads item instances from the database by ID.

**Parameters**:
- `itemIndex` (number|table): Item ID or array of IDs

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Load single item
lia.item.loadItemByID(123)

-- Load multiple items
lia.item.loadItemByID({123, 124, 125})

-- Load items after server start
hook.Add("Initialize", "LoadItems", function()
    lia.item.loadItemByID({1, 2, 3, 4, 5})
end)
```

### lia.item.spawn
**Purpose**: Spawns an item in the world.

**Parameters**:
- `uniqueID` (string): Item unique ID
- `position` (Vector): Spawn position
- `callback` (function): Callback function
- `angles` (Angle): Spawn angles (optional)
- `data` (table): Item data (optional)

**Returns**: Promise that resolves to item instance

**Realm**: Server

**Example Usage**:
```lua
-- Spawn item in world
lia.item.spawn("weapon_pistol", Vector(0, 0, 0), function(item)
    if item then
        print("Spawned item:", item:getName())
        print("Position:", item:getEntity():GetPos())
    end
end)

-- Spawn item with angles and data
lia.item.spawn("custom_item", Vector(100, 100, 100), function(item)
    print("Item spawned")
end, Angle(0, 90, 0), {
    customData = "value"
})
```

### lia.item.restoreInv
**Purpose**: Restores an inventory with specified dimensions.

**Parameters**:
- `invID` (number): Inventory ID
- `w` (number): Width
- `h` (number): Height
- `callback` (function): Callback function

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Restore inventory with dimensions
lia.item.restoreInv(123, 10, 6, function(inventory)
    if inventory then
        print("Restored inventory with dimensions:", inventory.data.w, "x", inventory.data.h)
    end
end)
```