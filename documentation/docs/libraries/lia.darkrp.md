# DarkRP Compatibility Library

This page documents the functions for DarkRP compatibility and migration utilities.

---

## Overview

The DarkRP compatibility library (`lia.darkrp`) provides compatibility functions and utilities for migrating from or working alongside DarkRP in the Lilia framework. It includes position checking, entity creation, text formatting, and notification functions that mirror DarkRP's API.

---

### lia.darkrp.isEmpty

**Purpose**

Checks if a position is empty of entities and has valid contents for spawning.

**Parameters**

* `position` (*Vector*): The position to check.
* `entitiesToIgnore` (*table*, *optional*): Array of entities to ignore during the check.

**Returns**

* `isEmpty` (*boolean*): True if the position is empty and suitable for spawning, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Check if a position is empty
    local spawnPos = Vector(100, 200, 0)
    if lia.darkrp.isEmpty(spawnPos) then
        print("Position is clear for spawning")
    else
        print("Position is blocked")
    end

    -- Check with entities to ignore
    local ignoreEnts = {player1, player2}
    if lia.darkrp.isEmpty(spawnPos, ignoreEnts) then
        -- Spawn entity ignoring specific players
    end
end
```

---

### lia.darkrp.findEmptyPos

**Purpose**

Finds an empty position near a starting point by searching in expanding circles.

**Parameters**

* `startPos` (*Vector*): The starting position to search from.
* `entitiesToIgnore` (*table*, *optional*): Array of entities to ignore during checks.
* `maxDistance` (*number*, *optional*): Maximum search distance (default: 600).
* `searchStep` (*number*, *optional*): Distance between search points (default: 35).
* `checkArea` (*Vector*, *optional*): Area to check around each position (default: Vector(16, 16, 64)).

**Returns**

* `position` (*Vector*): The found empty position, or the original position if none found.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Find empty position near a player
    local playerPos = player:GetPos()
    local emptyPos = lia.darkrp.findEmptyPos(playerPos)

    -- Spawn entity at empty position
    ents.Create("prop_physics"):SetPos(emptyPos)

    -- Find position with custom parameters
    local customPos = lia.darkrp.findEmptyPos(
        playerPos,
        {}, -- no entities to ignore
        300, -- max 300 units
        20, -- 20 unit steps
        Vector(32, 32, 32) -- larger check area
    )
end
```

---

### lia.darkrp.notify

**Purpose**

Sends a notification to a client using Lilia's notification system.

**Parameters**

* `client` (*Player*): The client to notify.
* `_` (*any*): Unused parameter (for DarkRP compatibility).
* `_` (*any*): Unused parameter (for DarkRP compatibility).
* `message` (*string*): The notification message.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Send notification to player
    local player = player.GetHumans()[1]
    if IsValid(player) then
        lia.darkrp.notify(player, nil, nil, "You have received a reward!")
    end

    -- Use in DarkRP-style code
    hook.Add("PlayerSpawn", "WelcomeMessage", function(ply)
        lia.darkrp.notify(ply, nil, nil, "Welcome to the server!")
    end)
end
```

---

### lia.darkrp.textWrap

**Purpose**

Wraps text to fit within a specified width, adding line breaks as needed.

**Parameters**

* `text` (*string*): The text to wrap.
* `fontName` (*string*): The font to use for size calculations.
* `maxLineWidth` (*number*): The maximum width per line in pixels.

**Returns**

* `wrappedText` (*string*): The text with line breaks inserted.

**Realm**

Client.

**Example Usage**

```lua
if CLIENT then
    -- Wrap text for display
    local longText = "This is a very long piece of text that needs to be wrapped to fit properly in the UI."
    local wrapped = lia.darkrp.textWrap(longText, "DermaDefault", 200)

    -- Draw wrapped text
    surface.SetFont("DermaDefault")
    for i, line in ipairs(string.Explode("\n", wrapped)) do
        surface.SetTextPos(10, 10 + (i-1) * 15)
        surface.DrawText(line)
    end
end
```

---

### lia.darkrp.formatMoney

**Purpose**

Formats a currency amount using DarkRP-style formatting.

**Parameters**

* `amount` (*number*): The amount to format.

**Returns**

* `formattedAmount` (*string*): The formatted currency string.

**Realm**

Shared.

**Example Usage**

```lua
-- Format currency amounts
local amount1 = lia.darkrp.formatMoney(1000) -- "$1,000"
local amount2 = lia.darkrp.formatMoney(5000000) -- "$5,000,000"

-- Display in UI
draw.SimpleText("Money: " .. lia.darkrp.formatMoney(playerMoney), "DermaDefault", 10, 10)
```

---

### lia.darkrp.createEntity

**Purpose**

Creates a DarkRP-style entity with the specified data.

**Parameters**

* `name` (*string*): The entity name/identifier.
* `data` (*table*): The entity data and configuration.

**Returns**

* `entityData` (*table*): The created entity data table.

**Realm**

Shared.

**Example Usage**

```lua
-- Create a custom entity
local myEntity = lia.darkrp.createEntity("custom_item", {
    model = "models/props_c17/chair01a.mdl",
    price = 100,
    category = "Furniture"
})

-- Create entity with spawn function
local weaponEntity = lia.darkrp.createEntity("weapon_pistol", {
    model = "models/weapons/w_pistol.mdl",
    price = 500,
    category = "Weapons",
    spawn = function(ply)
        ply:Give("weapon_pistol")
    end
})
```

---

### lia.darkrp.createCategory

**Purpose**

Creates a DarkRP-style category for organizing entities.

**Parameters**

* None.

**Returns**

* `category` (*table*): The created category table.

**Realm**

Shared.

**Example Usage**

```lua
-- Create a category
local weaponCategory = lia.darkrp.createCategory()
weaponCategory.name = "Weapons"
weaponCategory.color = Color(255, 100, 100)
weaponCategory.icon = "icon16/gun.png"

-- Create category with items
local foodCategory = lia.darkrp.createCategory()
foodCategory.name = "Food"
foodCategory.items = {"burger", "hotdog", "pizza"}
```