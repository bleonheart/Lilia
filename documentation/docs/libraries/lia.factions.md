# Factions Library

This page documents the functions for working with factions and team management.

---

## Overview

The factions library (`lia.faction`) provides a comprehensive system for managing factions and teams in the Lilia framework. It handles faction registration, team setup, model management, player grouping, and provides utilities for faction-based operations. The library supports both individual factions and faction groups for better organization.

---

### lia.faction.register

**Purpose**

Registers a new faction with specified properties and team index.

**Parameters**

* `uniqueID` (*string*): The unique identifier for the faction.
* `data` (*table*): The faction data table containing properties.

**Returns**

* `index` (*number*): The team index assigned to the faction.
* `faction` (*table*): The faction data table.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a new faction
local index, faction = lia.faction.register("police", {
    name = "Police Officer",
    desc = "Law enforcement officer",
    color = Color(0, 100, 255),
    models = {"models/player/police.mdl"},
    weapons = {"weapon_pistol", "weapon_stunstick"},
    isDefault = false
})

print("Police faction registered with index: " .. index)
```

### lia.faction.cacheModels

**Purpose**

Precaches faction models for better performance.

**Parameters**

* `models` (*table*): Array of model paths or model data tables.

**Realm**

Shared.

**Example Usage**

```lua
-- Cache faction models
local models = {
    "models/player/police.mdl",
    "models/player/swat.mdl"
}

lia.faction.cacheModels(models)
```

### lia.faction.loadFromDir

**Purpose**

Loads faction definitions from a directory containing faction files.

**Parameters**

* `directory` (*string*): The directory path containing faction files.

**Realm**

Shared.

**Example Usage**

```lua
-- Load factions from directory
lia.faction.loadFromDir("gamemodes/lilia/factions")

-- Load from custom directory
lia.faction.loadFromDir("lilia/factions/custom")
```

### lia.faction.get

**Purpose**

Retrieves a faction by its identifier (index or uniqueID).

**Parameters**

* `identifier` (*number|string*): The faction index or uniqueID.

**Returns**

* `faction` (*table*): The faction data table or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get faction by index
local faction = lia.faction.get(1)
if faction then
    print("Faction found: " .. faction.name)
end

-- Get faction by uniqueID
local police = lia.faction.get("police")
if police then
    print("Police faction: " .. police.name)
end
```

### lia.faction.getIndex

**Purpose**

Gets the team index for a faction by its uniqueID.

**Parameters**

* `uniqueID` (*string*): The faction uniqueID.

**Returns**

* `index` (*number*): The team index or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get faction index
local index = lia.faction.getIndex("police")
if index then
    print("Police faction index: " .. index)
end
```

### lia.faction.getClasses

**Purpose**

Gets all classes that belong to a specific faction.

**Parameters**

* `faction` (*number|string*): The faction index or uniqueID.

**Returns**

* `classes` (*table*): Array of class data tables.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all police classes
local classes = lia.faction.getClasses("police")
print("Police faction has " .. #classes .. " classes")

for _, class in ipairs(classes) do
    print("  - " .. class.name)
end
```

### lia.faction.getPlayers

**Purpose**

Gets all players currently in a specific faction.

**Parameters**

* `faction` (*number|string*): The faction index or uniqueID.

**Returns**

* `players` (*table*): Array of player entities.

**Realm**

Server.

**Example Usage**

```lua
-- Get all police players
local policePlayers = lia.faction.getPlayers("police")
print("Police players online: " .. #policePlayers)

for _, ply in ipairs(policePlayers) do
    print("  - " .. ply:Nick())
end
```

### lia.faction.getPlayerCount

**Purpose**

Gets the count of players currently in a specific faction.

**Parameters**

* `faction` (*number|string*): The faction index or uniqueID.

**Returns**

* `count` (*number*): The number of players in the faction.

**Realm**

Server.

**Example Usage**

```lua
-- Get police player count
local count = lia.faction.getPlayerCount("police")
print("Police players online: " .. count)

-- Check if faction is full
if count >= 5 then
    print("Police faction is full!")
end
```

### lia.faction.isFactionCategory

**Purpose**

Checks if a faction belongs to a specific category group.

**Parameters**

* `faction` (*number|string*): The faction to check.
* `categoryFactions` (*table*): Array of faction identifiers in the category.

**Returns**

* `isInCategory` (*boolean*): True if the faction is in the category.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if faction is in law enforcement category
local lawEnforcement = {"police", "swat", "fbi"}
local isLawEnforcement = lia.faction.isFactionCategory("police", lawEnforcement)

if isLawEnforcement then
    print("Police is a law enforcement faction")
end
```

### lia.faction.jobGenerate

**Purpose**

Generates a faction dynamically with specified properties.

**Parameters**

* `index` (*number*): The team index for the faction.
* `name` (*string*): The faction name.
* `color` (*Color*): The faction color.
* `default` (*boolean*): Whether this is a default faction.
* `models` (*table*, optional): Array of model paths.

**Returns**

* `faction` (*table*): The generated faction data table.

**Realm**

Shared.

**Example Usage**

```lua
-- Generate a custom faction
local faction = lia.faction.jobGenerate(10, "Custom Job", Color(255, 0, 0), false, {
    "models/player/group01/male_01.mdl"
})

print("Generated faction: " .. faction.name)
```

### lia.faction.formatModelData

**Purpose**

Formats and processes faction model data, including bodygroup information.

**Realm**

Shared.

**Example Usage**

```lua
-- Format all faction model data
lia.faction.formatModelData()
print("All faction model data has been formatted")
```

### lia.faction.getCategories

**Purpose**

Gets all model categories for a specific faction.

**Parameters**

* `teamName` (*string*): The faction uniqueID.

**Returns**

* `categories` (*table*): Array of category names.

**Realm**

Shared.

**Example Usage**

```lua
-- Get model categories for police faction
local categories = lia.faction.getCategories("police")
print("Police faction categories:")

for _, category in ipairs(categories) do
    print("  - " .. category)
end
```

### lia.faction.getModelsFromCategory

**Purpose**

Gets all models from a specific category within a faction.

**Parameters**

* `teamName` (*string*): The faction uniqueID.
* `category` (*string*): The category name.

**Returns**

* `models` (*table*): Table of models in the category.

**Realm**

Shared.

**Example Usage**

```lua
-- Get male models from police faction
local maleModels = lia.faction.getModelsFromCategory("police", "male")
print("Police male models:")

for index, model in pairs(maleModels) do
    print("  - " .. tostring(model))
end
```

### lia.faction.getDefaultClass

**Purpose**

Gets the default class for a specific faction.

**Parameters**

* `id` (*number|string*): The faction index or uniqueID.

**Returns**

* `defaultClass` (*table*): The default class data table or nil.

**Realm**

Shared.

**Example Usage**

```lua
-- Get default police class
local defaultClass = lia.faction.getDefaultClass("police")
if defaultClass then
    print("Default police class: " .. defaultClass.name)
end
```

### lia.faction.registerGroup

**Purpose**

Registers a group of factions for easier management.

**Parameters**

* `groupName` (*string*): The name of the group.
* `factionIDs` (*table*): Array of faction identifiers to include in the group.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a law enforcement group
lia.faction.registerGroup("law_enforcement", {
    "police",
    "swat",
    "fbi"
})

-- Register group with mixed identifiers
lia.faction.registerGroup("civilians", {
    "citizen",
    "unemployed",
    "homeless"
})
```

### lia.faction.getGroup

**Purpose**

Gets the group name that a faction belongs to.

**Parameters**

* `factionID` (*number|string*): The faction index or uniqueID.

**Returns**

* `groupName` (*string*): The group name or nil if not in a group.

**Realm**

Shared.

**Example Usage**

```lua
-- Get faction group
local group = lia.faction.getGroup("police")
if group then
    print("Police belongs to group: " .. group)
end
```

### lia.faction.getFactionsInGroup

**Purpose**

Gets all factions that belong to a specific group.

**Parameters**

* `groupName` (*string*): The group name.

**Returns**

* `factions` (*table*): Array of faction uniqueIDs in the group.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all law enforcement factions
local lawEnforcement = lia.faction.getFactionsInGroup("law_enforcement")
print("Law enforcement factions:")

for _, factionID in ipairs(lawEnforcement) do
    print("  - " .. factionID)
end
```

### lia.faction.hasWhitelist

**Purpose**

Checks if a faction requires whitelist access.

**Parameters**

* `faction` (*number|string*): The faction index or uniqueID.

**Returns**

* `hasWhitelist` (*boolean*): True if the faction requires whitelist.

**Realm**

Client/Server.

**Example Usage**

```lua
-- Check if police faction requires whitelist
local requiresWhitelist = lia.faction.hasWhitelist("police")
if requiresWhitelist then
    print("Police faction requires whitelist access")
end

-- Check for staff faction
local staffWhitelist = lia.faction.hasWhitelist(FACTION_STAFF)
if staffWhitelist then
    print("Staff faction requires whitelist")
end
```
