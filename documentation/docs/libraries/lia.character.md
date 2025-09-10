# Character Library

This page documents the functions for working with character data and management.

---

## Overview

The character library (`lia.char`) provides a comprehensive system for managing character data, loading, creation, and interaction with character-specific variables. It handles character persistence, validation, networking, and provides functions for retrieving character information, managing character variables, and performing character-related operations. The library is central to the Lilia framework's character system.

---

### lia.char.getCharacter

**Purpose**

Retrieves a character object by its ID, loading it if necessary.

**Parameters**

* `charID` (*number*): The unique identifier of the character.
* `client` (*Player*, *optional*): The client requesting the character (server-side only).
* `callback` (*function*, *optional*): A function to call when the character is loaded.

**Returns**

* `character` (*table*): The character object if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a character by ID
local character = lia.char.getCharacter(123)
if character then
    print("Character name: " .. character:getName())
end

-- Get character with callback (client-side)
lia.char.getCharacter(123, nil, function(char)
    if char then
        print("Character loaded: " .. char:getName())
    else
        print("Character not found")
    end
end)

-- Server-side character retrieval
if SERVER then
    local player = player.GetHumans()[1]
    lia.char.getCharacter(123, player, function(char)
        if char then
            print("Character loaded for " .. player:Name())
        end
    end)
end
```

---

### lia.char.isLoaded

**Purpose**

Checks if a character is currently loaded in memory.

**Parameters**

* `charID` (*number*): The unique identifier of the character.

**Returns**

* `isLoaded` (*boolean*): True if the character is loaded, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if a character is loaded
if lia.char.isLoaded(123) then
    print("Character 123 is loaded")
else
    print("Character 123 is not loaded")
end

-- Use in conditional logic
local charID = 456
if lia.char.isLoaded(charID) then
    local char = lia.char.getCharacter(charID)
    char:setMoney(1000)
end
```

---

### lia.char.getAll

**Purpose**

Retrieves all currently loaded characters.

**Parameters**

* `nil`

**Returns**

* `characters` (*table*): A table of all loaded characters.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all loaded characters
local allChars = lia.char.getAll()
print("Total loaded characters: " .. table.Count(allChars))

-- Iterate through all characters
for client, character in pairs(lia.char.getAll()) do
    if IsValid(client) then
        print(client:Name() .. " has character: " .. character:getName())
    end
end

-- Count characters by faction
local factionCount = {}
for _, character in pairs(lia.char.getAll()) do
    local faction = character:getFaction()
    factionCount[faction] = (factionCount[faction] or 0) + 1
end
```

---

### lia.char.addCharacter

**Purpose**

Adds a character to the loaded characters list.

**Parameters**

* `id` (*number*): The unique identifier of the character.
* `character` (*table*): The character object to add.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Add a character to the loaded list
local character = lia.char.new(characterData, 123)
lia.char.addCharacter(123, character)

-- Add character and handle pending requests
lia.char.addCharacter(456, newCharacter)
print("Character 456 added to loaded list")
```

---

### lia.char.removeCharacter

**Purpose**

Removes a character from the loaded characters list.

**Parameters**

* `id` (*number*): The unique identifier of the character to remove.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Remove a character from the loaded list
lia.char.removeCharacter(123)
print("Character 123 removed from loaded list")

-- Remove character after cleanup
local charID = 456
if lia.char.isLoaded(charID) then
    lia.char.removeCharacter(charID)
end
```

---

### lia.char.new

**Purpose**

Creates a new character object with the specified data.

**Parameters**

* `data` (*table*): The character data to initialize with.
* `id` (*number*, *optional*): The unique identifier for the character.
* `client` (*Player*, *optional*): The client associated with the character.
* `steamID` (*string*, *optional*): The SteamID of the character owner.

**Returns**

* `character` (*table*): The newly created character object.

**Realm**

Shared.

**Example Usage**

```lua
-- Create a new character
local charData = {
    name = "John Doe",
    desc = "A test character",
    model = "models/player/group01/male_01.mdl",
    faction = "Citizen"
}
local character = lia.char.new(charData, 123)

-- Create character with client association
local character = lia.char.new(charData, 123, client)

-- Create character with SteamID
local character = lia.char.new(charData, 123, nil, "STEAM_0:1:123456")
```

---

### lia.char.hookVar

**Purpose**

Adds a hook function for a specific character variable.

**Parameters**

* `varName` (*string*): The name of the variable to hook.
* `hookName` (*string*): The name of the hook.
* `func` (*function*): The function to call when the variable changes.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Hook a character variable
lia.char.hookVar("money", "OnMoneyChange", function(character, oldValue, newValue)
    print("Money changed from " .. oldValue .. " to " .. newValue)
end)

-- Hook multiple variables
lia.char.hookVar("health", "OnHealthChange", function(char, old, new)
    if new < old then
        print("Character took damage!")
    end
end)
```

---

### lia.char.registerVar

**Purpose**

Registers a new character variable with the system.

**Parameters**

* `key` (*string*): The unique key for the variable.
* `data` (*table*): A table containing variable configuration with fields:
  * `field` (*string*, *optional*): The database field name.
  * `fieldType` (*string*, *optional*): The database field type.
  * `default` (*any*): The default value for the variable.
  * `onSet` (*function*, *optional*): Function to call when setting the variable.
  * `onGet` (*function*, *optional*): Function to call when getting the variable.
  * `onValidate` (*function*, *optional*): Function to validate the variable value.
  * `onAdjust` (*function*, *optional*): Function to adjust the variable value.
  * `isLocal` (*boolean*, *optional*): Whether the variable is local to the character.
  * `noNetworking` (*boolean*, *optional*): Whether to skip networking for this variable.
  * `noDisplay` (*boolean*, *optional*): Whether to hide this variable from display.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Register a simple character variable
lia.char.registerVar("level", {
    field = "level",
    fieldType = "integer",
    default = 1,
    onSet = function(character, value)
        character.vars.level = value
        print("Level set to: " .. value)
    end
})

-- Register a complex variable with validation
lia.char.registerVar("reputation", {
    field = "reputation",
    fieldType = "integer",
    default = 0,
    onValidate = function(value, data, client)
        if value < 0 or value > 1000 then
            return false, "Reputation must be between 0 and 1000"
        end
        return true
    end,
    onSet = function(character, value)
        character.vars.reputation = value
        hook.Run("OnReputationChanged", character, value)
    end
})

-- Register a local variable (not networked)
lia.char.registerVar("localData", {
    default = {},
    isLocal = true,
    noDisplay = true
})
```

---

### lia.char.getCharData

**Purpose**

Retrieves character data from the database by character ID.

**Parameters**

* `charID` (*number*): The unique identifier of the character.
* `key` (*string*, *optional*): The specific data key to retrieve. If nil, returns all data.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the character data.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Get all character data
    lia.char.getCharData(123):next(function(data)
        print("Character data loaded")
        for key, value in pairs(data) do
            print(key .. ": " .. tostring(value))
        end
    end)

    -- Get specific character data
    lia.char.getCharData(123, "customField"):next(function(value)
        if value then
            print("Custom field value: " .. tostring(value))
        end
    end)
end
```

---

### lia.char.getCharDataRaw

**Purpose**

Retrieves raw character data from the database without processing.

**Parameters**

* `charID` (*number*): The unique identifier of the character.
* `key` (*string*, *optional*): The specific data key to retrieve. If nil, returns all data.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the raw character data.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Get raw character data
    lia.char.getCharDataRaw(123):next(function(data)
        print("Raw character data retrieved")
    end)

    -- Get specific raw data
    lia.char.getCharDataRaw(123, "rawField"):next(function(value)
        if value then
            print("Raw field value: " .. tostring(value))
        end
    end)
end
```

---

### lia.char.getOwnerByID

**Purpose**

Retrieves the client who owns a character by the character's ID.

**Parameters**

* `ID` (*number*): The unique identifier of the character.

**Returns**

* `client` (*Player*): The client who owns the character, or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get the owner of a character
local owner = lia.char.getOwnerByID(123)
if IsValid(owner) then
    print("Character 123 is owned by: " .. owner:Name())
else
    print("Character 123 has no owner")
end

-- Use in admin commands
local charID = 456
local owner = lia.char.getOwnerByID(charID)
if IsValid(owner) then
    owner:ChatPrint("Your character has been modified by an admin.")
end
```

---

### lia.char.getBySteamID

**Purpose**

Retrieves a character by the SteamID of its owner.

**Parameters**

* `steamID` (*string*): The SteamID of the character owner.

**Returns**

* `character` (*table*): The character object if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get character by SteamID
local character = lia.char.getBySteamID("STEAM_0:1:123456")
if character then
    print("Found character: " .. character:getName())
else
    print("No character found for that SteamID")
end

-- Use in player lookup
local steamID = "STEAM_0:1:123456"
local character = lia.char.getBySteamID(steamID)
if character then
    local owner = character:getPlayer()
    if IsValid(owner) then
        print("Player " .. owner:Name() .. " has character " .. character:getName())
    end
end
```

---

### lia.char.GetTeamColor

**Purpose**

Retrieves the team color for a client based on their character's class.

**Parameters**

* `client` (*Player*): The client to get the team color for.

**Returns**

* `color` (*Color*): The team color for the client.

**Realm**

Shared.

**Example Usage**

```lua
-- Get team color for a client
local color = lia.char.GetTeamColor(client)
print("Team color: R=" .. color.r .. " G=" .. color.g .. " B=" .. color.b)

-- Use in HUD drawing
hook.Add("HUDPaint", "DrawPlayerInfo", function()
    local client = LocalPlayer()
    local color = lia.char.GetTeamColor(client)
    draw.SimpleText("Player: " .. client:Name(), "DermaDefault", 10, 10, color)
end)
```

---

### lia.char.create

**Purpose**

Creates a new character in the database.

**Parameters**

* `data` (*table*): The character data to create with.
* `callback` (*function*, *optional*): A function to call when the character is created.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Create a new character
    local charData = {
        name = "John Doe",
        desc = "A new character",
        model = "models/player/group01/male_01.mdl",
        faction = "Citizen",
        steamID = "STEAM_0:1:123456"
    }
    
    lia.char.create(charData, function(charID)
        print("Character created with ID: " .. charID)
    end)

    -- Create character with custom data
    local customData = {
        name = "Test Character",
        desc = "A test character",
        model = "models/player/group01/female_01.mdl",
        faction = "Citizen",
        steamID = "STEAM_0:1:123456",
        data = {
            customField = "customValue",
            level = 5
        }
    }
    
    lia.char.create(customData, function(charID)
        print("Custom character created: " .. charID)
    end)
end
```

---

### lia.char.restore

**Purpose**

Restores characters for a client from the database.

**Parameters**

* `client` (*Player*): The client to restore characters for.
* `callback` (*function*, *optional*): A function to call when characters are restored.
* `id` (*number*, *optional*): Specific character ID to restore. If nil, restores all characters.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Restore all characters for a client
    lia.char.restore(client, function(characters)
        print("Restored " .. #characters .. " characters for " .. client:Name())
    end)

    -- Restore specific character
    lia.char.restore(client, function(characters)
        if #characters > 0 then
            print("Character " .. characters[1] .. " restored")
        end
    end, 123)

    -- Use in player spawn
    hook.Add("PlayerInitialSpawn", "RestoreCharacters", function(ply)
        lia.char.restore(ply, function(chars)
            print("Characters restored for " .. ply:Name())
        end)
    end)
end
```

---

### lia.char.cleanUpForPlayer

**Purpose**

Cleans up all loaded characters for a specific player.

**Parameters**

* `client` (*Player*): The client to clean up characters for.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Clean up characters for a player
    lia.char.cleanUpForPlayer(client)
    print("Characters cleaned up for " .. client:Name())

    -- Use in player disconnect
    hook.Add("PlayerDisconnected", "CleanupCharacters", function(ply)
        lia.char.cleanUpForPlayer(ply)
    end)
end
```

---

### lia.char.delete

**Purpose**

Deletes a character from the database and unloads it from memory.

**Parameters**

* `id` (*number*): The unique identifier of the character to delete.
* `client` (*Player*, *optional*): The client requesting the deletion.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Delete a character
    lia.char.delete(123)
    print("Character 123 deleted")

    -- Delete character for specific client
    lia.char.delete(456, client)
    print("Character 456 deleted for " .. client:Name())

    -- Use in admin command
    hook.Add("PlayerSay", "DeleteCharCommand", function(ply, text)
        if string.sub(text, 1, 6) == "!delchar" then
            local charID = tonumber(string.sub(text, 8))
            if charID then
                lia.char.delete(charID, ply)
            end
        end
    end)
end
```

---

### lia.char.getCharBanned

**Purpose**

Checks if a character is banned.

**Parameters**

* `charID` (*number*): The unique identifier of the character.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the ban status (0 = not banned, >0 = banned).

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Check if character is banned
    lia.char.getCharBanned(123):next(function(banned)
        if banned > 0 then
            print("Character 123 is banned")
        else
            print("Character 123 is not banned")
        end
    end)

    -- Use in character validation
    lia.char.getCharBanned(charID):next(function(banned)
        if banned > 0 then
            client:ChatPrint("Your character is banned!")
            return false
        end
    end)
end
```

---

### lia.char.setCharDatabase

**Purpose**

Sets character data in the database.

**Parameters**

* `charID` (*number*): The unique identifier of the character.
* `field` (*string*): The field name to set.
* `value` (*any*): The value to set.

**Returns**

* `success` (*boolean*): True if the operation was successful, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Set character data
    lia.char.setCharDatabase(123, "money", 1000)
    print("Character 123 money set to 1000")

    -- Set custom character data
    lia.char.setCharDatabase(123, "customField", "customValue")
    print("Custom field set for character 123")

    -- Set multiple fields
    local charID = 456
    lia.char.setCharDatabase(charID, "level", 5)
    lia.char.setCharDatabase(charID, "experience", 1000)
    print("Character " .. charID .. " updated")
end
```

---

### lia.char.unloadCharacter

**Purpose**

Unloads a character from memory and saves it to the database.

**Parameters**

* `charID` (*number*): The unique identifier of the character to unload.

**Returns**

* `success` (*boolean*): True if the character was unloaded, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Unload a character
    local success = lia.char.unloadCharacter(123)
    if success then
        print("Character 123 unloaded")
    else
        print("Failed to unload character 123")
    end

    -- Unload character before deletion
    if lia.char.unloadCharacter(456) then
        lia.char.delete(456)
    end
end
```

---

### lia.char.unloadUnusedCharacters

**Purpose**

Unloads all unused characters for a client except the active one.

**Parameters**

* `client` (*Player*): The client to unload unused characters for.
* `activeCharID` (*number*): The ID of the active character to keep loaded.

**Returns**

* `unloadedCount` (*number*): The number of characters that were unloaded.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Unload unused characters
    local unloaded = lia.char.unloadUnusedCharacters(client, 123)
    print("Unloaded " .. unloaded .. " unused characters")

    -- Use in character selection
    hook.Add("OnCharacterSelected", "UnloadUnused", function(ply, char)
        local unloaded = lia.char.unloadUnusedCharacters(ply, char:getID())
        print("Unloaded " .. unloaded .. " unused characters for " .. ply:Name())
    end)
end
```

---

### lia.char.loadSingleCharacter

**Purpose**

Loads a single character from the database.

**Parameters**

* `charID` (*number*): The unique identifier of the character to load.
* `client` (*Player*, *optional*): The client requesting the character.
* `callback` (*function*, *optional*): A function to call when the character is loaded.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Load a single character
    lia.char.loadSingleCharacter(123, client, function(character)
        if character then
            print("Character 123 loaded for " .. client:Name())
        else
            print("Failed to load character 123")
        end
    end)

    -- Load character without callback
    lia.char.loadSingleCharacter(456, client)
    print("Character 456 loading initiated")
end
```