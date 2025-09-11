# Character Library

This page documents the functions for managing character data, loading, and manipulation within the Lilia framework.

---

## Overview

The character library (`lia.char`) provides a comprehensive system for managing player characters in the Lilia framework. It handles character creation, loading, data management, and provides hooks for character variable changes. The library supports both server-side and client-side operations with proper networking.

---

### lia.char.getCharacter

**Purpose**

Retrieves a character object by its ID, loading it from the database if not already cached.

**Parameters**

* `charID` (*number*): The unique identifier of the character to retrieve.
* `client` (*Player*, optional): The player requesting the character (server-side only).
* `callback` (*function*, optional): Function called with the character object when loaded.

**Returns**

* `character` (*Character|nil*): The character object if loaded, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a character synchronously (if already loaded)
local character = lia.char.getCharacter(123)

-- Get a character with callback (loads from database if needed)
lia.char.getCharacter(123, client, function(character)
    if character then
        print("Character loaded:", character:getName())
    end
end)

-- Client-side usage
lia.char.getCharacter(123, nil, function(character)
    if character then
        -- Update UI with character data
        updateCharacterPanel(character)
    end
end)
```

---

### lia.char.isLoaded

**Purpose**

Checks if a character is currently loaded in memory.

**Parameters**

* `charID` (*number*): The character ID to check.

**Returns**

* `isLoaded` (*boolean*): True if the character is loaded, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
if lia.char.isLoaded(123) then
    print("Character 123 is already loaded")
else
    print("Character 123 needs to be loaded")
end
```

---

### lia.char.getAll

**Purpose**

Returns a table of all currently loaded characters.

**Parameters**

None.

**Returns**

* `characters` (*table*): Table of character objects keyed by character ID.

**Realm**

Shared.

**Example Usage**

```lua
local allCharacters = lia.char.getAll()
print("Total loaded characters:", table.Count(allCharacters))

-- Iterate through all loaded characters
for charID, character in pairs(allCharacters) do
    print(charID, character:getName())
end
```

---

### lia.char.new

**Purpose**

Creates a new character object with the provided data.

**Parameters**

* `data` (*table*): Character data including variables and properties.
* `id` (*number*): The character ID.
* `client` (*Player*): The player who owns this character.
* `steamID` (*string*): The Steam ID of the character owner.

**Returns**

* `character` (*Character*): The newly created character object.

**Realm**

Shared.

**Example Usage**

```lua
local characterData = {
    name = "John Doe",
    desc = "A mysterious stranger",
    model = "models/player.mdl",
    faction = 1,
    money = 1000
}

local newCharacter = lia.char.new(characterData, 456, client, "STEAM_0:1:12345678")
print("Created character:", newCharacter:getName())
```

---

### lia.char.hookVar

**Purpose**

Registers a hook function to be called when a specific character variable changes.

**Parameters**

* `varName` (*string*): The name of the character variable to hook.
* `hookName` (*string*): A unique identifier for this hook.
* `func` (*function*): The function to call when the variable changes.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

Shared.

**Example Usage**

```lua
-- Hook for when character's money changes
lia.char.hookVar("money", "MoneyChangedNotification", function(character, oldValue, newValue)
    local difference = newValue - oldValue
    if difference > 0 then
        character:getPlayer():ChatPrint("You gained $" .. difference)
    elseif difference < 0 then
        character:getPlayer():ChatPrint("You lost $" .. math.abs(difference))
    end
end)

-- Hook for faction changes
lia.char.hookVar("faction", "FactionChangeHandler", function(character, oldFaction, newFaction)
    local oldFactionData = lia.faction.indices[oldFaction]
    local newFactionData = lia.faction.indices[newFaction]

    if oldFactionData and newFactionData then
        character:getPlayer():ChatPrint("Faction changed from " .. oldFactionData.name .. " to " .. newFactionData.name)
    end
end)
```

---

### lia.char.registerVar

**Purpose**

Registers a new character variable type with default properties and behaviors.

**Parameters**

* `key` (*string*): The unique key for the character variable.
* `data` (*table*): Configuration data for the variable including default value, validation, etc.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a custom character variable for reputation
lia.char.registerVar("reputation", {
    default = 0,
    isLocal = false, -- Sync with database
    onSet = function(character, value)
        -- Validate reputation is between -100 and 100
        value = math.Clamp(value, -100, 100)
        character.vars.reputation = value

        -- Award achievements based on reputation
        if value >= 50 then
            character:getPlayer():ChatPrint("You are well-respected!")
        elseif value <= -50 then
            character:getPlayer():ChatPrint("Your reputation is tarnished!")
        end

        return value
    end
})

-- Register a temporary variable (not saved to database)
lia.char.registerVar("tempBuff", {
    default = {},
    isLocal = true, -- Client-side only, not networked
    noNetworking = true
})
```

---

### lia.char.getCharData

**Purpose**

Retrieves character data from the database for a specific character and key.

**Parameters**

* `charID` (*number*): The character ID.
* `key` (*string*): The data key to retrieve.

**Returns**

* `value` (*any*): The stored value, or the default value if not found.

**Realm**

Server.

**Example Usage**

```lua
-- Get character's stored inventory data
lia.char.getCharData(123, "customInventory", function(value)
    if value then
        print("Character's custom inventory:", value)
    else
        print("No custom inventory data found")
    end
end)

-- Get achievement progress
lia.char.getCharData(123, "achievements", function(achievements)
    achievements = achievements or {}
    print("Completed achievements:", table.Count(achievements))
end)
```

---

### lia.char.setCharDatabase

**Purpose**

Stores character data in the database for a specific character and field.

**Parameters**

* `charID` (*number*): The character ID.
* `field` (*string*): The field name to store.
* `value` (*any*): The value to store.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

Server.

**Example Usage**

```lua
-- Store achievement progress
local achievements = {"first_kill", "level_up", "explore_city"}
lia.char.setCharDatabase(123, "achievements", achievements)

-- Store custom statistics
lia.char.setCharDatabase(123, "playtime_today", 3600) -- 1 hour in seconds

-- Store complex data structures
local inventoryData = {
    weapons = {"weapon_pistol", "weapon_shotgun"},
    ammo = {pistol = 120, shotgun = 24}
}
lia.char.setCharDatabase(123, "backup_inventory", inventoryData)
```

---

### lia.char.create

**Purpose**

Creates a new character in the database with the provided data.

**Parameters**

* `data` (*table*): Character creation data including name, description, model, etc.
* `callback` (*function*): Function called with the new character ID upon successful creation.

**Returns**

* `nil` (*nil*): This function does not return a value directly.

**Realm**

Server.

**Example Usage**

```lua
local characterData = {
    name = "Alex Johnson",
    desc = "A skilled hacker with a mysterious past.",
    model = "models/player/group01/male_01.mdl",
    faction = 2, -- Citizen faction
    class = 1,   -- Default class
    money = 500
}

lia.char.create(characterData, function(charID)
    if charID then
        print("Character created with ID:", charID)

        -- Load the newly created character
        lia.char.getCharacter(charID, client, function(character)
            if character then
                -- Set as active character
                client:setChar(character)
                client:ChatPrint("Welcome to the city, " .. character:getName() .. "!")
            end
        end)
    else
        client:ChatPrint("Failed to create character. Please try again.")
    end
end)
```

---

### lia.char.delete

**Purpose**

Permanently deletes a character from the database and unloads it from memory.

**Parameters**

* `id` (*number*): The character ID to delete.
* `client` (*Player*): The player who owns the character (for permission checking).

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

Server.

**Example Usage**

```lua
-- Delete a character with confirmation
local charID = 123
lia.char.delete(charID, client)

-- With user feedback
hook.Add("OnCharDelete", "CharacterDeleteFeedback", function(client, charID)
    client:ChatPrint("Character #" .. charID .. " has been deleted.")
end)
```

---

### lia.char.GetTeamColor

**Purpose**

Returns the team color for a player's current character based on their faction.

**Parameters**

* `client` (*Player*): The player to get the team color for.

**Returns**

* `color` (*Color*): The faction's team color, or white if no faction is set.

**Realm**

Shared.

**Example Usage**

```lua
-- Get team color for display
local color = lia.char.GetTeamColor(client)
draw.SimpleText(client:Name(), "Default", x, y, color)

-- Use in HUD elements
hook.Add("HUDDrawTargetID", "CustomTargetID", function()
    local trace = LocalPlayer():GetEyeTrace()
    local target = trace.Entity

    if IsValid(target) and target:IsPlayer() then
        local color = lia.char.GetTeamColor(target)
        draw.SimpleText(target:Name(), "TargetID", ScrW()/2, ScrH()/2 + 20, color, TEXT_ALIGN_CENTER)
    end
end)
```

---