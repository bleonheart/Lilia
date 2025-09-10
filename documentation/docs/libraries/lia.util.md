# Utility Library

This page documents the utility functions for player management, entity searching, and string manipulation.

---

## Overview

The utility library (`lia.util`) provides a collection of helpful functions for common tasks within the Lilia framework. It includes functions for finding players, managing entities, string matching, and various utility operations that are frequently used throughout the gamemode.

---

### lia.util.FindPlayersInBox

**Purpose**

Finds all players within a specified bounding box.

**Parameters**

* `mins` (*Vector*): The minimum corner of the bounding box.
* `maxs` (*Vector*): The maximum corner of the bounding box.

**Returns**

* `players` (*table*): Array of player entities within the box.

**Realm**

Shared.

**Example Usage**

```lua
-- Find players in a specific area
local mins = Vector(-100, -100, 0)
local maxs = Vector(100, 100, 100)
local playersInArea = lia.util.FindPlayersInBox(mins, maxs)

print("Found " .. #playersInArea .. " players in the area")
for _, ply in ipairs(playersInArea) do
    print("- " .. ply:Name())
end

-- Use in area-based commands
local function countPlayersInZone(zoneMins, zoneMaxs)
    return #lia.util.FindPlayersInBox(zoneMins, zoneMaxs)
end
```

---

### lia.util.getBySteamID

**Purpose**

Finds a player by their SteamID.

**Parameters**

* `steamID` (*string*): The SteamID to search for (supports both SteamID and SteamID64 formats).

**Returns**

* `player` (*Player*): The player entity if found and has a character, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Find player by SteamID
local player = lia.util.getBySteamID("STEAM_0:1:123456")
if player then
    print("Found player: " .. player:Name())
end

-- Find player by SteamID64
local player = lia.util.getBySteamID("76561198000000000")
if player then
    print("Found player by SteamID64: " .. player:Name())
end
```

---

### lia.util.FindPlayersInSphere

**Purpose**

Finds all players within a specified radius of a point.

**Parameters**

* `origin` (*Vector*): The center point of the sphere.
* `radius` (*number*): The radius of the sphere.

**Returns**

* `players` (*table*): Array of player entities within the sphere.

**Realm**

Shared.

**Example Usage**

```lua
-- Find players within 500 units
local center = Vector(0, 0, 0)
local nearbyPlayers = lia.util.FindPlayersInSphere(center, 500)

print("Found " .. #nearbyPlayers .. " players nearby")

-- Use in radius-based effects
local function applyAreaEffect(position, radius, effectFunction)
    local players = lia.util.FindPlayersInSphere(position, radius)
    for _, ply in ipairs(players) do
        effectFunction(ply)
    end
end
```

---

### lia.util.findPlayer

**Purpose**

Finds a player using various identifier formats (name, SteamID, SteamID64, special characters).

**Parameters**

* `client` (*Player*): The player performing the search (for notifications).
* `identifier` (*string*): The identifier to search for.

**Returns**

* `player` (*Player*): The found player entity, or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Find player by name
local player = lia.util.findPlayer(client, "John Doe")
if player then
    print("Found player: " .. player:Name())
end

-- Find player by SteamID
local player = lia.util.findPlayer(client, "STEAM_0:1:123456")

-- Special identifiers
local player = lia.util.findPlayer(client, "^") -- Self
local player = lia.util.findPlayer(client, "@") -- Looking at player

-- Use in commands
lia.command.add("goto", {
    arguments = {{name = "target", type = "player"}},
    onRun = function(client, arguments)
        local target = arguments[1]
        if IsValid(target) then
            client:SetPos(target:GetPos())
        end
    end
})
```

---

### lia.util.findPlayerItems

**Purpose**

Finds all item entities created by a specific player.

**Parameters**

* `client` (*Player*): The player whose items to find.

**Returns**

* `items` (*table*): Array of item entities created by the player.

**Realm**

Shared.

**Example Usage**

```lua
-- Find all items created by a player
local playerItems = lia.util.findPlayerItems(client)
print("Player has " .. #playerItems .. " items spawned")

-- Clean up player items
local function cleanupPlayerItems(player)
    local items = lia.util.findPlayerItems(player)
    for _, item in ipairs(items) do
        if IsValid(item) then
            item:Remove()
        end
    end
end
```

---

### lia.util.findPlayerItemsByClass

**Purpose**

Finds all item entities of a specific class created by a player.

**Parameters**

* `client` (*Player*): The player whose items to find.
* `class` (*string*): The item class to search for.

**Returns**

* `items` (*table*): Array of item entities matching the class.

**Realm**

Shared.

**Example Usage**

```lua
-- Find specific item type
local healthKits = lia.util.findPlayerItemsByClass(client, "health_kit")
print("Player has " .. #healthKits .. " health kits")

-- Count items by type
local function countPlayerItemsByType(player, itemType)
    return #lia.util.findPlayerItemsByClass(player, itemType)
end
```

---

### lia.util.findPlayerEntities

**Purpose**

Finds all entities created by or associated with a specific player.

**Parameters**

* `client` (*Player*): The player whose entities to find.
* `class` (*string*, *optional*): Optional entity class filter.

**Returns**

* `entities` (*table*): Array of entities associated with the player.

**Realm**

Shared.

**Example Usage**

```lua
-- Find all entities created by player
local playerEntities = lia.util.findPlayerEntities(client)
print("Player has " .. #playerEntities .. " entities")

-- Find entities of specific class
local playerProps = lia.util.findPlayerEntities(client, "prop_physics")
print("Player has " .. #playerProps .. " props")

-- Clean up player entities
local function cleanupPlayerEntities(player, entityClass)
    local entities = lia.util.findPlayerEntities(player, entityClass)
    for _, ent in ipairs(entities) do
        if IsValid(ent) then
            ent:Remove()
        end
    end
end
```

---

### lia.util.stringMatches

**Purpose**

Checks if two strings match using various comparison methods.

**Parameters**

* `a` (*string*): First string to compare.
* `b` (*string*): Second string to compare.

**Returns**

* `matches` (*boolean*): True if strings match in any way.

**Realm**

Shared.

**Example Usage**

```lua
-- Check string matches
local match1 = lia.util.stringMatches("John", "john") -- true (case insensitive)
local match2 = lia.util.stringMatches("John Doe", "John") -- true (contains)
local match3 = lia.util.stringMatches("John", "Jane") -- false

-- Use in player search
local function findPlayerByFlexibleName(searchName)
    for _, ply in ipairs(player.GetAll()) do
        if lia.util.stringMatches(ply:Name(), searchName) then
            return ply
        end
    end
    return nil
end
```

---

### lia.util.getAdmins

**Purpose**

Gets all players with admin privileges.

**Parameters**

* None

**Returns**

* `admins` (*table*): Array of admin player entities.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all admins
local admins = lia.util.getAdmins()
print("There are " .. #admins .. " admins online")

-- Check if player is admin
local function isPlayerAdmin(player)
    local admins = lia.util.getAdmins()
    for _, admin in ipairs(admins) do
        if admin == player then
            return true
        end
    end
    return false
end
```

---

### lia.util.findPlayerBySteamID64

**Purpose**

Finds a player by their SteamID64.

**Parameters**

* `SteamID64` (*string*): The SteamID64 to search for.

**Returns**

* `player` (*Player*): The player entity if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Find player by SteamID64
local player = lia.util.findPlayerBySteamID64("76561198000000000")
if player then
    print("Found player: " .. player:Name())
end
```

---

### lia.util.findPlayerBySteamID

**Purpose**

Finds a player by their SteamID.

**Parameters**

* `SteamID` (*string*): The SteamID to search for.

**Returns**

* `player` (*Player*): The player entity if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Find player by SteamID
local player = lia.util.findPlayerBySteamID("STEAM_0:1:123456")
if player then
    print("Found player: " .. player:Name())
end
```

---

### lia.util.canFit

**Purpose**

Checks if an entity can fit at a specific position without colliding.

**Parameters**

* `pos` (*Vector*): The position to check.
* `mins` (*Vector*): The minimum bounds of the entity.
* `maxs` (*Vector*): The maximum bounds of the entity.
* `filter` (*table*, *optional*): Entities to ignore in collision check.

**Returns**

* `canFit` (*boolean*): True if the entity can fit, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if player can fit at position
local playerMins, playerMaxs = client:GetCollisionBounds()
local canFit = lia.util.canFit(position, playerMins, playerMaxs)

if canFit then
    client:SetPos(position)
else
    client:ChatPrint("Cannot teleport there - area is blocked!")
end

-- Check with filter (ignore self)
local canFit = lia.util.canFit(position, mins, maxs, {client})
```

---

### lia.util.playerInRadius

**Purpose**

Checks if any players are within a specified radius of a position.

**Parameters**

* `pos` (*Vector*): The center position to check.
* `dist` (*number*): The radius to check.

**Returns**

* `players` (*table*): Array of players within the radius.

**Realm**

Shared.

**Example Usage**

```lua
-- Check for players in radius
local nearbyPlayers = lia.util.playerInRadius(Vector(0, 0, 0), 500)
if #nearbyPlayers > 0 then
    print("Found " .. #nearbyPlayers .. " players nearby")
end

-- Use in area triggers
local function triggerAreaEffect(center, radius)
    local players = lia.util.playerInRadius(center, radius)
    for _, ply in ipairs(players) do
        -- Apply effect to player
        ply:addHealth(10)
    end
end
```

---

### lia.util.formatStringNamed

**Purpose**

Formats a string with named placeholders.

**Parameters**

* `format` (*string*): The format string with named placeholders.
* `...` (*any*): Values to substitute for placeholders.

**Returns**

* `formatted` (*string*): The formatted string.

**Realm**

Shared.

**Example Usage**

```lua
-- Format string with named placeholders
local result = lia.util.formatStringNamed("Hello {name}, you have {count} items!", {
    name = "John",
    count = 5
})
print(result) -- "Hello John, you have 5 items!"

-- Use in notifications
local function notifyPlayer(player, itemName, amount)
    local message = lia.util.formatStringNamed("You received {amount} {item}!", {
        amount = amount,
        item = itemName
    })
    player:ChatPrint(message)
end
```

---

### lia.util.getMaterial

**Purpose**

Gets or creates a material with specified parameters.

**Parameters**

* `materialPath` (*string*): The material path or identifier.
* `materialParameters` (*table*, *optional*): Material creation parameters.

**Returns**

* `material` (*Material*): The material object.

**Realm**

Shared.

**Example Usage**

```lua
-- Get existing material
local material = lia.util.getMaterial("icon16/user.png")

-- Create material with parameters
local material = lia.util.getMaterial("custom_material", {
    ["$basetexture"] = "path/to/texture",
    ["$translucent"] = 1
})

-- Use in UI
local icon = vgui.Create("DImage")
icon:SetMaterial(lia.util.getMaterial("icon16/star.png"))
```

---

### lia.util.findFaction

**Purpose**

Finds a faction by name or partial name match.

**Parameters**

* `client` (*Player*): The player performing the search.
* `name` (*string*): The faction name to search for.

**Returns**

* `faction` (*table*): The faction data if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Find faction by name
local faction = lia.util.findFaction(client, "Police")
if faction then
    print("Found faction: " .. faction.name)
end

-- Use in faction commands
lia.command.add("joinfaction", {
    arguments = {{name = "faction", type = "string"}},
    onRun = function(client, arguments)
        local faction = lia.util.findFaction(client, arguments[1])
        if faction then
            -- Join faction logic
            client:notifyLocalized("joinedFaction", faction.name)
        else
            client:notifyLocalized("factionNotFound")
        end
    end
})
```

## Additional Utility Functions

The util library also includes many other helper functions for:

- **Entity Management**: Functions for working with entities, positions, and collisions
- **Player Utilities**: Functions for player lookup, validation, and management
- **String Processing**: Functions for string manipulation and comparison
- **Positioning**: Functions for position validation and entity placement
- **Material Handling**: Functions for material creation and management
- **Faction Operations**: Functions for faction searching and management

## Best Practices

1. **Use Appropriate Functions**: Choose the most efficient function for your use case (e.g., `FindPlayersInSphere` vs `FindPlayersInBox`).

2. **Validate Input**: Always check if required parameters are valid before using utility functions.

3. **Handle Edge Cases**: Consider what happens when functions return nil or empty tables.

4. **Performance Considerations**: For frequently called functions, cache results when possible.

5. **Error Handling**: Use proper error handling for functions that might fail.

6. **Documentation**: Document the purpose and usage of utility functions you create.