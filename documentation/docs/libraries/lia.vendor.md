# lia.vendor

## Overview
The `lia.vendor` library provides vendor management functionality for Lilia, including vendor editing, presets, rarities, and database operations. It allows for the creation and management of NPC vendors that can buy and sell items.

## Functions

### lia.vendor.addRarities
**Purpose**: Adds a new rarity level for vendor items.

**Parameters**:
- `name` (string): Rarity name
- `color` (Color): Rarity color

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Add common rarity
lia.vendor.addRarities("Common", Color(200, 200, 200))

-- Add rare rarity
lia.vendor.addRarities("Rare", Color(0, 100, 255))

-- Add legendary rarity
lia.vendor.addRarities("Legendary", Color(255, 215, 0))

-- Add epic rarity
lia.vendor.addRarities("Epic", Color(128, 0, 128))
```

### lia.vendor.addPreset
**Purpose**: Adds a vendor preset with predefined items and settings.

**Parameters**:
- `name` (string): Preset name
- `items` (table): Table of items with their configurations

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Add weapon vendor preset
lia.vendor.addPreset("Weapon Vendor", {
    ["weapon_pistol"] = {
        price = 500,
        stock = 10,
        mode = 1 -- Buy mode
    },
    ["weapon_shotgun"] = {
        price = 1200,
        stock = 5,
        mode = 1
    }
})

-- Add medical vendor preset
lia.vendor.addPreset("Medical Vendor", {
    ["item_bandage"] = {
        price = 50,
        stock = 20,
        mode = 1
    },
    ["item_medkit"] = {
        price = 200,
        stock = 5,
        mode = 1
    }
})

-- Add general store preset
lia.vendor.addPreset("General Store", {
    ["item_food"] = {
        price = 25,
        stock = 50,
        mode = 1
    },
    ["item_water"] = {
        price = 15,
        stock = 30,
        mode = 1
    }
})
```

### lia.vendor.getPreset
**Purpose**: Gets a vendor preset by name.

**Parameters**:
- `name` (string): Preset name

**Returns**: Preset data table or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get weapon vendor preset
local weaponPreset = lia.vendor.getPreset("Weapon Vendor")
if weaponPreset then
    print("Found weapon vendor preset with", table.Count(weaponPreset), "items")
    for itemType, itemData in pairs(weaponPreset) do
        print("- " .. itemType .. ": $" .. itemData.price)
    end
end

-- Get medical vendor preset
local medicalPreset = lia.vendor.getPreset("Medical Vendor")
if medicalPreset then
    print("Medical vendor preset loaded")
end
```

### lia.vendor.loadPresets
**Purpose**: Loads vendor presets from the database (Server only).

**Parameters**: None

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Load presets from database
lia.vendor.loadPresets()

-- This is typically called automatically when tables are loaded
hook.Add("LiliaTablesLoaded", "LoadVendorPresets", function()
    lia.vendor.loadPresets()
end)
```

### lia.vendor.savePresetToDatabase
**Purpose**: Saves a vendor preset to the database (Server only).

**Parameters**:
- `name` (string): Preset name
- `data` (table): Preset data

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Save preset to database
local presetData = {
    ["weapon_pistol"] = {
        price = 500,
        stock = 10,
        mode = 1
    }
}
lia.vendor.savePresetToDatabase("Custom Preset", presetData)

-- Save preset after creation
lia.vendor.addPreset("My Preset", {
    ["item_gun"] = {price = 1000, stock = 5, mode = 1}
})
```