# Vendor Library

This page documents the functions for working with vendor NPCs and trading systems.

---

## Overview

The vendor library (`lia.vendor`) provides a comprehensive system for creating and managing vendor NPCs that can buy and sell items. It supports preset configurations, stock management, faction/class restrictions, and dynamic pricing. The library handles both server-side vendor logic and client-side UI interactions.

---

### lia.vendor.addRarities

**Purpose**

Adds a new item rarity with an associated color for visual distinction.

**Parameters**

* `name` (*string*): The name of the rarity (e.g., "Common", "Rare", "Legendary").
* `color` (*Color*): The color associated with this rarity.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Add basic rarities
lia.vendor.addRarities("Common", Color(200, 200, 200))
lia.vendor.addRarities("Uncommon", Color(100, 200, 100))
lia.vendor.addRarities("Rare", Color(100, 100, 255))
lia.vendor.addRarities("Epic", Color(200, 100, 255))
lia.vendor.addRarities("Legendary", Color(255, 200, 100))

-- Use in item definitions
local itemData = {
    name = "Legendary Sword",
    rarity = "Legendary",
    price = 5000
}
```

---

### lia.vendor.addPreset

**Purpose**

Creates a vendor preset configuration that can be applied to multiple vendors.

**Parameters**

* `name` (*string*): The name of the preset.
* `items` (*table*): A table of items with their configurations.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Create a weapon shop preset
lia.vendor.addPreset("Weapon Shop", {
    ["weapon_pistol"] = {
        price = 500,
        stock = 10,
        mode = 1 -- Sell mode
    },
    ["weapon_smg"] = {
        price = 1500,
        stock = 5,
        mode = 1
    },
    ["ammo_pistol"] = {
        price = 50,
        stock = 100,
        mode = 1
    }
})

-- Create a general store preset
lia.vendor.addPreset("General Store", {
    ["health_kit"] = {
        price = 100,
        stock = 20,
        mode = 1
    },
    ["food_apple"] = {
        price = 25,
        stock = 50,
        mode = 1
    },
    ["tool_repair"] = {
        price = 200,
        stock = 10,
        mode = 1
    }
})

-- Apply preset to vendor
local vendor = ents.Create("lia_vendor")
vendor:setPreset("Weapon Shop")
```

---

### lia.vendor.getPreset

**Purpose**

Retrieves a vendor preset configuration by name.

**Parameters**

* `name` (*string*): The name of the preset to retrieve.

**Returns**

* `preset` (*table*): The preset configuration table, or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a preset
local weaponShopPreset = lia.vendor.getPreset("Weapon Shop")
if weaponShopPreset then
    print("Weapon shop has " .. table.Count(weaponShopPreset) .. " items")
end

-- Check if preset exists
if lia.vendor.getPreset("NonExistent") then
    print("Preset exists")
else
    print("Preset not found")
end

-- Use preset data
local preset = lia.vendor.getPreset("General Store")
for itemType, itemData in pairs(preset) do
    print(itemType .. " costs " .. itemData.price)
end
```

---

### lia.vendor.loadPresets (Server)

**Purpose**

Loads all vendor presets from the database.

**Parameters**

* `nil`

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
-- Load presets on server start
hook.Add("Initialize", "LoadVendorPresets", function()
    lia.vendor.loadPresets()
end)

-- Reload presets after changes
lia.vendor.loadPresets()
print("Vendor presets reloaded")
```

---

### lia.vendor.savePresetToDatabase (Server)

**Purpose**

Saves a vendor preset configuration to the database.

**Parameters**

* `name` (*string*): The name of the preset.
* `data` (*table*): The preset data to save.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
-- Save a custom preset
local customPreset = {
    ["item1"] = {price = 100, stock = 10},
    ["item2"] = {price = 200, stock = 5}
}

lia.vendor.savePresetToDatabase("Custom Shop", customPreset)
print("Custom preset saved to database")

-- Auto-save when creating presets
local function createAndSavePreset(name, items)
    lia.vendor.addPreset(name, items)
    -- Preset is automatically saved by addPreset
end
```

## Vendor Editor Functions

The vendor library provides an extensive editor system for modifying vendor properties in real-time:

### Server-side Editor Functions
- **name**: Changes the vendor's display name
- **mode**: Sets trading mode for items (buy/sell/both)
- **price**: Sets the price for buying/selling items
- **stockDisable**: Disables stock limits for an item
- **stockMax**: Sets maximum stock for an item
- **stock**: Sets current stock for an item
- **welcome**: Sets the welcome message
- **faction**: Allows/restricts factions from trading
- **class**: Allows/restricts classes from trading
- **model**: Changes the vendor's model
- **skin**: Changes the vendor's skin
- **bodygroup**: Modifies bodygroups
- **preset**: Applies a preset configuration
- **animation**: Sets the vendor's animation

### Client-side Editor Functions
Corresponding client-side functions that send network requests to modify vendors.

## Usage Examples

### Creating a Basic Vendor
```lua
-- Create a vendor entity
local vendor = ents.Create("lia_vendor")
vendor:SetPos(Vector(0, 0, 0))
vendor:SetAngles(Angle(0, 0, 0))
vendor:Spawn()

-- Configure the vendor
vendor:setName("General Store")
vendor:setWelcomeMessage("Welcome to my store!")

-- Add items manually
vendor:setItemPrice("health_kit", 100)
vendor:setTradeMode("health_kit", 1) -- Sell mode
vendor:setMaxStock("health_kit", 20)
```

### Using Presets
```lua
-- Define a preset
lia.vendor.addPreset("Magic Shop", {
    ["spell_fireball"] = {
        price = 500,
        stock = 10,
        mode = 1
    },
    ["spell_heal"] = {
        price = 300,
        stock = 15,
        mode = 1
    },
    ["mana_potion"] = {
        price = 50,
        stock = 50,
        mode = 1
    }
})

-- Apply to vendor
local vendor = ents.Create("lia_vendor")
vendor:setPreset("Magic Shop")
```

### Faction Restrictions
```lua
local vendor = ents.Create("lia_vendor")

-- Only allow citizens and merchants
vendor:setFactionAllowed(FACTION_CITIZEN, true)
vendor:setFactionAllowed(FACTION_MERCHANT, true)

-- Restrict police
vendor:setFactionAllowed(FACTION_POLICE, false)
```

### Dynamic Pricing
```lua
-- Implement dynamic pricing based on stock
local function updatePrices(vendor)
    for itemType, _ in pairs(vendor:getItems()) do
        local stock = vendor:getStock(itemType)
        local maxStock = vendor:getMaxStock(itemType)

        if stock and maxStock then
            local priceMultiplier = 1 + ((maxStock - stock) / maxStock) * 0.5
            local basePrice = vendor:getItemPrice(itemType)
            vendor:setItemPrice(itemType, math.ceil(basePrice * priceMultiplier))
        end
    end
end

-- Call periodically
timer.Create("UpdateVendorPrices", 300, 0, function()
    for _, vendor in ipairs(ents.FindByClass("lia_vendor")) do
        updatePrices(vendor)
    end
end)
```

### Stock Management
```lua
-- Auto-restock vendors
local function restockVendors()
    for _, vendor in ipairs(ents.FindByClass("lia_vendor")) do
        for itemType, _ in pairs(vendor:getItems()) do
            local maxStock = vendor:getMaxStock(itemType)
            if maxStock then
                vendor:setStock(itemType, maxStock)
            end
        end
    end
end

-- Restock daily
timer.Create("DailyRestock", 86400, 0, function()
    restockVendors()
    print("Vendors restocked")
end)
```

## Best Practices

1. **Use Presets**: Create presets for commonly used vendor configurations to maintain consistency.

2. **Manage Stock**: Implement appropriate stock limits and restocking systems for realistic gameplay.

3. **Faction Restrictions**: Use faction and class restrictions to create role-specific vendors.

4. **Price Balancing**: Consider supply and demand when setting prices, and implement dynamic pricing where appropriate.

5. **Welcome Messages**: Provide clear welcome messages to guide players on what the vendor offers.

6. **Testing**: Thoroughly test vendor configurations to ensure items are properly priced and stocked.

7. **Performance**: For servers with many vendors, consider caching frequently accessed vendor data.