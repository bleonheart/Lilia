# Item Library

This page documents the functions for working with items and item management.

---

## Overview

The item library (`lia.item`) provides a comprehensive system for managing items within the Lilia framework. It handles item registration, instantiation, inventory management, and provides utilities for working with item data, functions, and properties. The library supports both base items and custom items with extensive customization options.

---

### lia.item.get

**Purpose**

Retrieves an item definition by its unique identifier.

**Parameters**

* `identifier` (*string*): The unique identifier of the item to retrieve.

**Returns**

* `item` (*table*): The item definition table or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a base item
local baseItem = lia.item.get("base_weapon")
if baseItem then
    print("Base weapon found: " .. baseItem.name)
end

-- Get a custom item
local customItem = lia.item.get("health_kit")
if customItem then
    print("Custom item: " .. customItem.name)
end

-- Check if an item exists
local exists = lia.item.get("nonexistent_item") ~= nil
print("Item exists: " .. tostring(exists))
```

---

### lia.item.getItemByID

**Purpose**

Retrieves an item instance by its unique ID number.

**Parameters**

* `itemID` (*number*): The unique ID number of the item instance.

**Returns**

* `result` (*table*): A table containing the item instance and its location, or nil if not found.
  * `item` (*table*): The item instance.
  * `location` (*string*): The location of the item ("inventory", "world", or "unknown").

**Realm**

Shared.

**Example Usage**

```lua
-- Get an item instance by ID
local result = lia.item.getItemByID(123)
if result then
    print("Item found: " .. result.item.name)
    print("Location: " .. result.location)
else
    print("Item not found")
end

-- Check if item exists
local exists = lia.item.getItemByID(456) ~= nil
print("Item exists: " .. tostring(exists))
```

---

### lia.item.getInstancedItemByID

**Purpose**

Retrieves an item instance directly by its unique ID number.

**Parameters**

* `itemID` (*number*): The unique ID number of the item instance.

**Returns**

* `item` (*table*): The item instance or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get an item instance
local item = lia.item.getInstancedItemByID(123)
if item then
    print("Item: " .. item.name)
    print("ID: " .. item.id)
else
    print("Item not found")
end

-- Use in item manipulation
local item = lia.item.getInstancedItemByID(456)
if item then
    item:setData("custom_field", "value")
end
```

---

### lia.item.getItemDataByID

**Purpose**

Retrieves the data table of an item instance by its unique ID number.

**Parameters**

* `itemID` (*number*): The unique ID number of the item instance.

**Returns**

* `data` (*table*): The item data table or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get item data
local data = lia.item.getItemDataByID(123)
if data then
    print("Item data:")
    for key, value in pairs(data) do
        print("  " .. key .. ": " .. tostring(value))
    end
else
    print("Item not found")
end

-- Access specific data fields
local data = lia.item.getItemDataByID(456)
if data and data.custom_field then
    print("Custom field value: " .. data.custom_field)
end
```

---

### lia.item.load

**Purpose**

Loads an item definition from a file path.

**Parameters**

* `path` (*string*): The file path to load the item from.
* `baseID` (*string*, *optional*): The base item ID to inherit from.
* `isBaseItem` (*boolean*, *optional*): Whether this is a base item.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Load a base item
lia.item.load("gamemode/items/base/sh_weapon.lua", nil, true)

-- Load a custom item
lia.item.load("gamemode/items/health_kit.lua")

-- Load an item that inherits from a base
lia.item.load("gamemode/items/custom_weapon.lua", "base_weapon")
```

---

### lia.item.isItem

**Purpose**

Checks if an object is a valid item instance.

**Parameters**

* `object` (*any*): The object to check.

**Returns**

* `isItem` (*boolean*): True if the object is a valid item, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if an object is an item
local testObject = {name = "Test Item"}
local isItem = lia.item.isItem(testObject)
print("Is item: " .. tostring(isItem))

-- Check item instance
local item = lia.item.new("health_kit", 123)
local isValidItem = lia.item.isItem(item)
print("Is valid item: " .. tostring(isValidItem))
```

---

### lia.item.getInv

**Purpose**

Retrieves an inventory instance by its ID.

**Parameters**

* `invID` (*number*): The inventory ID to retrieve.

**Returns**

* `inventory` (*table*): The inventory instance or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get an inventory
local inventory = lia.item.getInv(123)
if inventory then
    print("Inventory found with " .. inventory:getItemCount() .. " items")
else
    print("Inventory not found")
end

-- Use in item operations
local inventory = lia.item.getInv(456)
if inventory then
    local items = inventory:getItems()
    for _, item in pairs(items) do
        print("Item: " .. item.name)
    end
end
```

---

### lia.item.register

**Purpose**

Registers an item definition with the system.

**Parameters**

* `uniqueID` (*string*): The unique identifier for the item.
* `baseID` (*string*, *optional*): The base item ID to inherit from.
* `isBaseItem` (*boolean*, *optional*): Whether this is a base item.
* `path` (*string*, *optional*): The file path of the item definition.
* `luaGenerated` (*boolean*, *optional*): Whether this item was generated by Lua.

**Returns**

* `item` (*table*): The registered item definition.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a simple item
lia.item.register("health_kit", nil, false, "gamemode/items/health_kit.lua")

-- Register a base item
lia.item.register("base_weapon", nil, true, "gamemode/items/base/sh_weapon.lua")

-- Register an item that inherits from a base
lia.item.register("custom_sword", "base_weapon", false, "gamemode/items/custom_sword.lua")
```

---

### lia.item.loadFromDir

**Purpose**

Loads all item definitions from a directory structure.

**Parameters**

* `directory` (*string*): The directory path containing item files.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Load items from the default directory
lia.item.loadFromDir("gamemode/items")

-- Load items from a custom directory
lia.item.loadFromDir("lilia/items/custom")

-- Load items during initialization
hook.Add("Initialize", "LoadCustomItems", function()
    lia.item.loadFromDir("gamemode/custom_items")
end)
```

---

### lia.item.new

**Purpose**

Creates a new item instance with the specified unique ID and database ID.

**Parameters**

* `uniqueID` (*string*): The unique identifier of the item definition.
* `id` (*number*): The database ID for the item instance.

**Returns**

* `item` (*table*): The newly created item instance.

**Realm**

Shared.

**Example Usage**

```lua
-- Create a new item instance
local item = lia.item.new("health_kit", 123)
if item then
    print("Created item: " .. item.name .. " with ID: " .. item.id)
end

-- Create item with custom data
local item = lia.item.new("weapon_pistol", 456)
if item then
    item:setData("ammo", 30)
    item:setData("condition", 100)
end
```

---

### lia.item.registerInv

**Purpose**

Registers a new inventory type with specified dimensions.

**Parameters**

* `invType` (*string*): The unique identifier for the inventory type.
* `w` (*number*): The width of the inventory in grid units.
* `h` (*number*): The height of the inventory in grid units.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Register a small inventory type
lia.item.registerInv("small_backpack", 4, 4)

-- Register a large inventory type
lia.item.registerInv("large_backpack", 8, 6)

-- Register a custom container type
lia.item.registerInv("weapon_case", 2, 6)
```

---

### lia.item.newInv

**Purpose**

Creates a new inventory instance of the specified type.

**Parameters**

* `owner` (*number*): The character ID that owns this inventory.
* `invType` (*string*): The inventory type to create.
* `callback` (*function*, *optional*): Callback function called when the inventory is created.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Create a new inventory for a character
lia.item.newInv(123, "backpack", function(inventory)
    print("Created inventory with ID: " .. inventory.id)
    inventory:add(lia.item.new("health_kit", 456))
end)

-- Create inventory without callback
lia.item.newInv(789, "large_backpack")
```

---

### lia.item.createInv

**Purpose**

Creates a basic inventory instance with custom dimensions.

**Parameters**

* `w` (*number*): The width of the inventory.
* `h` (*number*): The height of the inventory.
* `id` (*number*, *optional*): The ID to assign to the inventory.

**Returns**

* `inventory` (*table*): The created inventory instance.

**Realm**

Shared.

**Example Usage**

```lua
-- Create a custom-sized inventory
local inventory = lia.item.createInv(6, 4, 123)
print("Created inventory " .. inventory.id .. " with size " .. inventory:getWidth() .. "x" .. inventory:getHeight())

-- Create inventory and add items
local inventory = lia.item.createInv(8, 6)
inventory:add(lia.item.new("weapon_pistol", 456))
```

---

### lia.item.addWeaponOverride

**Purpose**

Adds a weapon override configuration for automatic item generation.

**Parameters**

* `className` (*string*): The weapon class name to override.
* `data` (*table*): The override data configuration.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Add weapon override
lia.item.addWeaponOverride("weapon_pistol", {
    name = "Custom Pistol",
    desc = "A custom pistol with special properties",
    width = 2,
    height = 1,
    category = "Custom Weapons"
})
```

---

### lia.item.addWeaponToBlacklist

**Purpose**

Adds a weapon class to the blacklist to prevent automatic item generation.

**Parameters**

* `className` (*string*): The weapon class name to blacklist.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Blacklist a weapon
lia.item.addWeaponToBlacklist("weapon_physgun")

-- Blacklist multiple weapons
local weaponsToBlacklist = {"weapon_fists", "gmod_camera", "weapon_medkit"}
for _, weapon in ipairs(weaponsToBlacklist) do
    lia.item.addWeaponToBlacklist(weapon)
end
```

---

### lia.item.generateWeapons

**Purpose**

Automatically generates item definitions for all registered weapons.

**Parameters**

* `nil`

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Generate weapon items
lia.item.generateWeapons()
print("Weapon items generated")

-- Generate weapons after adding overrides
lia.item.addWeaponOverride("weapon_pistol", {name = "Custom Pistol"})
lia.item.generateWeapons()
```

---

### lia.item.generateAmmo

**Purpose**

Automatically generates item definitions for all registered ammo types.

**Parameters**

* `nil`

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Generate ammo items
lia.item.generateAmmo()
print("Ammo items generated")

-- Generate ammo after initialization
hook.Add("InitializedItems", "GenerateAmmo", function()
    lia.item.generateAmmo()
end)
```