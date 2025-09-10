# lia.playerinteract

## Overview
The `lia.playerinteract` library provides player interaction and action management for Lilia. It handles context menus, player actions, and interaction systems.

## Functions

### lia.playerinteract.isWithinRange
**Purpose**: Checks if a player is within interaction range of an entity (Shared).

**Parameters**:
- `client` (Player): Player to check
- `entity` (Entity): Entity to check distance to
- `customRange` (number): Custom range to check (optional, default: 250)

**Returns**: Boolean indicating if within range

**Realm**: Shared

**Example Usage**:
```lua
-- Check if player is within range
local player = LocalPlayer()
local entity = player:getTracedEntity()
if lia.playerinteract.isWithinRange(player, entity) then
    print("Player is within interaction range")
end

-- Check with custom range
if lia.playerinteract.isWithinRange(player, entity, 500) then
    print("Player is within 500 units")
end

-- Use in interaction system
local function canInteract(player, entity)
    return lia.playerinteract.isWithinRange(player, entity, 200)
end
```

### lia.playerinteract.getInteractions
**Purpose**: Gets available interactions for a player with the traced entity (Client only).

**Parameters**:
- `client` (Player): Player to get interactions for (optional, defaults to LocalPlayer)

**Returns**: Table of available interactions

**Realm**: Client

**Example Usage**:
```lua
-- Get interactions for current player
local interactions = lia.playerinteract.getInteractions()
for name, interaction in pairs(interactions) do
    print("Available interaction:", name)
end

-- Get interactions for specific player
local interactions = lia.playerinteract.getInteractions(player)
if table.Count(interactions) > 0 then
    print("Player has", table.Count(interactions), "interactions available")
end
```

### lia.playerinteract.getActions
**Purpose**: Gets available actions for a player (Client only).

**Parameters**:
- `client` (Player): Player to get actions for (optional, defaults to LocalPlayer)

**Returns**: Table of available actions

**Realm**: Client

**Example Usage**:
```lua
-- Get actions for current player
local actions = lia.playerinteract.getActions()
for name, action in pairs(actions) do
    print("Available action:", name)
end

-- Check if player has specific action
local actions = lia.playerinteract.getActions()
if actions["changeToWhisper"] then
    print("Player can whisper")
end
```

### lia.playerinteract.getCategorizedOptions
**Purpose**: Organizes options into categories (Client only).

**Parameters**:
- `options` (table): Table of options to categorize

**Returns**: Table of categorized options

**Realm**: Client

**Example Usage**:
```lua
-- Categorize interactions
local interactions = lia.playerinteract.getInteractions()
local categorized = lia.playerinteract.getCategorizedOptions(interactions)

for category, options in pairs(categorized) do
    print("Category:", category)
    for name, option in pairs(options) do
        print("  -", name)
    end
end
```

### lia.playerinteract.addInteraction
**Purpose**: Adds a new interaction option (Server only).

**Parameters**:
- `name` (string): Name of the interaction
- `data` (table): Interaction data table

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Add a simple interaction
lia.playerinteract.addInteraction("examine", {
    category = "General",
    target = "any",
    onRun = function(client, target)
        client:notify("You examine " .. target:GetClass())
    end
})

-- Add interaction with conditions
lia.playerinteract.addInteraction("heal", {
    category = "Medical",
    target = "player",
    shouldShow = function(client, target)
        return target:Health() < target:GetMaxHealth()
    end,
    onRun = function(client, target)
        target:SetHealth(target:GetMaxHealth())
        client:notify("You healed " .. target:Name())
    end
})

-- Add interaction with action text
lia.playerinteract.addInteraction("repair", {
    category = "Repair",
    target = "entity",
    timeToComplete = 5,
    actionText = "Repairing...",
    onRun = function(client, target)
        target:SetHealth(target:GetMaxHealth())
        client:notify("Repaired successfully")
    end
})
```

### lia.playerinteract.addAction
**Purpose**: Adds a new action option (Server only).

**Parameters**:
- `name` (string): Name of the action
- `data` (table): Action data table

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Add a simple action
lia.playerinteract.addAction("sit", {
    category = "General",
    onRun = function(client)
        client:SetAnimation(ACT_SIT)
        client:notify("You sit down")
    end
})

-- Add action with conditions
lia.playerinteract.addAction("meditate", {
    category = "Mental",
    shouldShow = function(client)
        return client:getChar() and client:getChar():getAttrib("int", 0) > 10
    end,
    onRun = function(client)
        client:setAction("Meditating...", 10, function()
            client:notify("You feel more focused")
        end)
    end
})
```

### lia.playerinteract.syncToClients
**Purpose**: Syncs interaction data to clients (Server only).

**Parameters**:
- `client` (Player): Client to sync to (optional, syncs to all if nil)

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Sync to specific client
lia.playerinteract.syncToClients(player)

-- Sync to all clients
lia.playerinteract.syncToClients()

-- Sync after adding new interactions
lia.playerinteract.addInteraction("newInteraction", {...})
lia.playerinteract.syncToClients()
```
