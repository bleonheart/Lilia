# lia.factions

## Overview
The `lia.factions` library provides comprehensive faction management for Lilia, including faction registration, player management, model handling, and group organization. Factions represent different teams or groups that players can belong to.

## Functions

### lia.faction.register
**Purpose**: Registers a new faction with the specified unique ID and data.

**Parameters**:
- `uniqueID` (string): Unique identifier for the faction
- `data` (table): Faction data table containing name, description, color, models, etc.

**Returns**: 
- `index` (number): Faction team index
- `faction` (table): Faction data table

**Realm**: Shared

**Example Usage**:
```lua
-- Register a police faction
local policeIndex, policeFaction = lia.faction.register("police", {
    name = "Police Department",
    desc = "Law enforcement officers",
    color = Color(0, 100, 255),
    models = {
        "models/player/police.mdl",
        "models/player/police_female.mdl"
    },
    weapons = {"weapon_physgun", "gmod_tool"},
    isDefault = false
})

-- Register a citizen faction
local citizenIndex, citizenFaction = lia.faction.register("citizen", {
    name = "Citizen",
    desc = "Regular citizens",
    color = Color(150, 150, 150),
    models = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/female_01.mdl"
    },
    isDefault = true
})
```

### lia.faction.cacheModels
**Purpose**: Precaches faction models for better performance.

**Parameters**:
- `models` (table): Array of model paths to precache

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Cache models for a faction
lia.faction.cacheModels({
    "models/player/police.mdl",
    "models/player/police_female.mdl",
    "models/player/group01/male_01.mdl"
})
```

### lia.faction.loadFromDir
**Purpose**: Loads faction definitions from a directory containing faction files.

**Parameters**:
- `directory` (string): Directory path containing faction files

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Load factions from a directory
lia.faction.loadFromDir("gamemode/factions")

-- Load custom factions
lia.faction.loadFromDir("addons/myaddon/factions")
```

### lia.faction.get
**Purpose**: Retrieves a faction by its identifier (index or unique ID).

**Parameters**:
- `identifier` (number|string): Faction index or unique ID

**Returns**: Faction data table or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get faction by index
local faction = lia.faction.get(1)
if faction then
    print("Faction name:", faction.name)
end

-- Get faction by unique ID
local policeFaction = lia.faction.get("police")
if policeFaction then
    print("Police faction color:", policeFaction.color)
end
```

### lia.faction.getIndex
**Purpose**: Gets the team index for a faction by its unique ID.

**Parameters**:
- `uniqueID` (string): Faction unique ID

**Returns**: Team index or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get police faction index
local policeIndex = lia.faction.getIndex("police")
if policeIndex then
    print("Police faction index:", policeIndex)
end
```

### lia.faction.getClasses
**Purpose**: Gets all classes that belong to a specific faction.

**Parameters**:
- `faction` (table): Faction data table

**Returns**: Array of class tables

**Realm**: Shared

**Example Usage**:
```lua
-- Get all police classes
local policeFaction = lia.faction.get("police")
if policeFaction then
    local policeClasses = lia.faction.getClasses(policeFaction)
    print("Police classes:", #policeClasses)
    
    for _, class in ipairs(policeClasses) do
        print("- " .. class.name)
    end
end
```

### lia.faction.getPlayers
**Purpose**: Gets all players currently in a specific faction.

**Parameters**:
- `faction` (table): Faction data table

**Returns**: Array of player entities

**Realm**: Server

**Example Usage**:
```lua
-- Get all police players
local policeFaction = lia.faction.get("police")
if policeFaction then
    local policePlayers = lia.faction.getPlayers(policeFaction)
    print("Police players online:", #policePlayers)
    
    for _, player in ipairs(policePlayers) do
        print("- " .. player:Name())
    end
end
```

### lia.faction.getPlayerCount
**Purpose**: Gets the number of players currently in a specific faction.

**Parameters**:
- `faction` (table): Faction data table

**Returns**: Number of players

**Realm**: Server

**Example Usage**:
```lua
-- Count police players
local policeFaction = lia.faction.get("police")
if policeFaction then
    local policeCount = lia.faction.getPlayerCount(policeFaction)
    print("Police officers online:", policeCount)
end
```

### lia.faction.isFactionCategory
**Purpose**: Checks if a faction belongs to a specific category.

**Parameters**:
- `faction` (table): Faction data table
- `categoryFactions` (table): Array of faction IDs to check against

**Returns**: Boolean indicating if faction is in category

**Realm**: Shared

**Example Usage**:
```lua
-- Check if faction is law enforcement
local lawEnforcementFactions = {"police", "fbi", "swat"}
local isLawEnforcement = lia.faction.isFactionCategory(policeFaction, lawEnforcementFactions)

if isLawEnforcement then
    print("This is a law enforcement faction")
end
```

### lia.faction.jobGenerate
**Purpose**: Generates a faction job with the specified parameters.

**Parameters**:
- `index` (number): Team index
- `name` (string): Faction name
- `color` (Color): Faction color
- `default` (boolean): Whether this is a default faction
- `models` (table): Array of model paths

**Returns**: Faction data table

**Realm**: Shared

**Example Usage**:
```lua
-- Generate a custom faction job
local customFaction = lia.faction.jobGenerate(10, "Custom Faction", Color(255, 0, 0), false, {
    "models/player/group01/male_01.mdl"
})

print("Generated faction:", customFaction.name)
```

### lia.faction.formatModelData
**Purpose**: Formats model data for factions, processing body groups and model variations.

**Parameters**: None

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Format all faction model data
lia.faction.formatModelData()

-- This is typically called after loading all factions
lia.faction.loadFromDir("gamemode/factions")
lia.faction.formatModelData()
```

### lia.faction.getCategories
**Purpose**: Gets all model categories for a specific faction.

**Parameters**:
- `teamName` (string): Faction unique ID

**Returns**: Array of category names

**Realm**: Shared

**Example Usage**:
```lua
-- Get model categories for police faction
local categories = lia.faction.getCategories("police")
print("Police model categories:")
for _, category in ipairs(categories) do
    print("- " .. category)
end
```

### lia.faction.getModelsFromCategory
**Purpose**: Gets all models from a specific category for a faction.

**Parameters**:
- `teamName` (string): Faction unique ID
- `category` (string): Category name

**Returns**: Table of models in the category

**Realm**: Shared

**Example Usage**:
```lua
-- Get male models for police faction
local maleModels = lia.faction.getModelsFromCategory("police", "male")
print("Police male models:")
for index, model in pairs(maleModels) do
    print("- " .. tostring(model))
end
```

### lia.faction.getDefaultClass
**Purpose**: Gets the default class for a specific faction.

**Parameters**:
- `id` (table): Faction data table

**Returns**: Default class table or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get default class for police faction
local policeFaction = lia.faction.get("police")
if policeFaction then
    local defaultClass = lia.faction.getDefaultClass(policeFaction)
    if defaultClass then
        print("Default police class:", defaultClass.name)
    end
end
```

### lia.faction.registerGroup
**Purpose**: Registers a group of factions for easier management.

**Parameters**:
- `groupName` (string): Name of the group
- `factionIDs` (table): Array of faction IDs to include in the group

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Register law enforcement group
lia.faction.registerGroup("law_enforcement", {
    "police",
    "fbi", 
    "swat",
    "detective"
})

-- Register civilian group
lia.faction.registerGroup("civilians", {
    "citizen",
    "business_owner",
    "unemployed"
})
```

### lia.faction.getGroup
**Purpose**: Gets the group name that a faction belongs to.

**Parameters**:
- `factionID` (string|number): Faction unique ID or index

**Returns**: Group name or nil

**Realm**: Shared

**Example Usage**:
```lua
-- Get group for police faction
local group = lia.faction.getGroup("police")
if group then
    print("Police belongs to group:", group)
end

-- Get group by faction index
local group = lia.faction.getGroup(1)
if group then
    print("Faction 1 belongs to group:", group)
end
```

### lia.faction.getFactionsInGroup
**Purpose**: Gets all factions that belong to a specific group.

**Parameters**:
- `groupName` (string): Group name

**Returns**: Array of faction unique IDs

**Realm**: Shared

**Example Usage**:
```lua
-- Get all law enforcement factions
local lawEnforcementFactions = lia.faction.getFactionsInGroup("law_enforcement")
print("Law enforcement factions:")
for _, factionID in ipairs(lawEnforcementFactions) do
    print("- " .. factionID)
end
```

### lia.faction.hasWhitelist
**Purpose**: Checks if a faction has whitelist requirements.

**Parameters**:
- `faction` (table): Faction data table

**Returns**: Boolean indicating if faction has whitelist

**Realm**: Client/Server

**Example Usage**:
```lua
-- Check if police faction has whitelist
local policeFaction = lia.faction.get("police")
if policeFaction then
    local hasWhitelist = lia.faction.hasWhitelist(policeFaction)
    if hasWhitelist then
        print("Police faction requires whitelist")
    else
        print("Police faction is open to all players")
    end
end
```