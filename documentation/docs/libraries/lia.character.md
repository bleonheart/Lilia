# Character Library

This page documents the functions for working with character management, data, and operations.

---

## Overview

The character library (`lia.char`) provides a comprehensive system for managing characters in the Lilia framework. It handles character creation, loading, saving, data management, and various character operations. The library supports character variables, inventory management, attribute handling, and database operations with full client-server synchronization.

---

### lia.char.getCharacter

**Purpose**

Retrieves a character by ID, loading it if necessary.

**Parameters**

* `charID` (*number*): The ID of the character to retrieve.
* `client` (*Player*): The client requesting the character (server only).
* `callback` (*function*): Optional callback function to execute when character is loaded.

**Returns**

* `character` (*table|nil*): The character object if found or loaded, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get character by ID
local char = lia.char.getCharacter(123)
if char then
    print("Character name: " .. char:getName())
end

-- Get character with callback
lia.char.getCharacter(456, client, function(char)
    if char then
        print("Character loaded: " .. char:getName())
    else
        print("Failed to load character")
    end
end)

-- Get character on server
if SERVER then
    local char = lia.char.getCharacter(789, client)
    if char then
        char:setMoney(1000)
    end
end

-- Get character on client
if CLIENT then
    lia.char.getCharacter(101, nil, function(char)
        if char then
            print("Character data received")
        end
    end)
end
```

---

### lia.char.isLoaded

**Purpose**

Checks if a character is currently loaded in memory.

**Parameters**

* `charID` (*number*): The ID of the character to check.

**Returns**

* `isLoaded` (*boolean*): True if the character is loaded, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if character is loaded
if lia.char.isLoaded(123) then
    print("Character 123 is loaded")
end

-- Check before performing operations
local charID = 456
if lia.char.isLoaded(charID) then
    local char = lia.char.loaded[charID]
    char:setMoney(char:getMoney() + 100)
end

-- Validate character before use
if lia.char.isLoaded(789) then
    local char = lia.char.getCharacter(789)
    if char and char:getPlayer() then
        char:getPlayer():ChatPrint("Character is active")
    end
end
```

---

### lia.char.getAll

**Purpose**

Gets all currently loaded characters.

**Parameters**

*None*

**Returns**

* `characters` (*table*): Table of loaded characters.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all loaded characters
local characters = lia.char.getAll()
print("Loaded characters: " .. table.Count(characters))

-- Iterate through all characters
for client, char in pairs(lia.char.getAll()) do
    if IsValid(client) then
        print(client:Name() .. " has character: " .. char:getName())
    end
end

-- Count characters by faction
local factionCount = {}
for client, char in pairs(lia.char.getAll()) do
    local faction = char:getFaction()
    factionCount[faction] = (factionCount[faction] or 0) + 1
end

-- Get characters with specific attribute
local richCharacters = {}
for client, char in pairs(lia.char.getAll()) do
    if char:getMoney() > 10000 then
        table.insert(richCharacters, char)
    end
end
```

---

### lia.char.addCharacter

**Purpose**

Adds a character to the loaded characters table and processes pending requests.

**Parameters**

* `id` (*number*): The ID of the character to add.
* `character` (*table*): The character object to add.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Add character to loaded list
lia.char.addCharacter(123, character)

-- Add character with validation
if character and character.id then
    lia.char.addCharacter(character.id, character)
    print("Character " .. character.id .. " added to loaded list")
end

-- Add character and notify
local charID = 456
local char = lia.char.new(data, charID, client)
lia.char.addCharacter(charID, char)
print("Character " .. charID .. " is now available")
```

---

### lia.char.removeCharacter

**Purpose**

Removes a character from the loaded characters table.

**Parameters**

* `id` (*number*): The ID of the character to remove.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Remove character from loaded list
lia.char.removeCharacter(123)

-- Remove character with validation
if lia.char.isLoaded(456) then
    lia.char.removeCharacter(456)
    print("Character 456 removed from loaded list")
end

-- Remove character and cleanup
local charID = 789
if lia.char.loaded[charID] then
    local char = lia.char.loaded[charID]
    char:save()
    lia.char.removeCharacter(charID)
end
```

---

### lia.char.new

**Purpose**

Creates a new character object with the specified data.

**Parameters**

* `data` (*table*): Character data table.
* `id` (*number*): Character ID (optional).
* `client` (*Player*): Client associated with the character (optional).
* `steamID` (*string*): SteamID for the character (optional).

**Returns**

* `character` (*table*): The new character object.

**Realm**

Shared.

**Example Usage**

```lua
-- Create new character
local charData = {
    name = "John Doe",
    desc = "A test character",
    model = "models/player/kleiner.mdl",
    faction = "Citizen"
}
local char = lia.char.new(charData, 123, client)

-- Create character with SteamID
local char = lia.char.new(charData, 456, nil, "STEAM_0:1:123456")

-- Create character with all parameters
local char = lia.char.new({
    name = "Jane Smith",
    desc = "A skilled character",
    model = "models/player/alyx.mdl",
    faction = "Citizen",
    money = 1000
}, 789, client, client:SteamID())

-- Create character with validation
if data and data.name then
    local char = lia.char.new(data, charID, client)
    if char then
        print("Character created: " .. char:getName())
    end
end
```

---

### lia.char.hookVar

**Purpose**

Adds a hook function for a specific character variable.

**Parameters**

* `varName` (*string*): The name of the variable to hook.
* `hookName` (*string*): The name of the hook.
* `func` (*function*): The hook function to execute.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Hook a character variable
lia.char.hookVar("money", "OnMoneyChanged", function(char, oldValue, newValue)
    print("Money changed from " .. oldValue .. " to " .. newValue)
end)

-- Hook multiple variables
lia.char.hookVar("name", "OnNameChanged", function(char, oldName, newName)
    print("Name changed from " .. oldName .. " to " .. newName)
end)

lia.char.hookVar("faction", "OnFactionChanged", function(char, oldFaction, newFaction)
    print("Faction changed from " .. oldFaction .. " to " .. newFaction)
end)

-- Hook with validation
lia.char.hookVar("health", "OnHealthChanged", function(char, oldHealth, newHealth)
    if newHealth <= 0 then
        print("Character died!")
    end
end)
```

---

### lia.char.registerVar

**Purpose**

Registers a new character variable with specified properties and behaviors.

**Parameters**

* `key` (*string*): The variable key/name.
* `data` (*table*): Variable configuration table containing:
  * `field` (*string*): Database field name.
  * `fieldType` (*string*): Database field type.
  * `default` (*any*): Default value for the variable.
  * `index` (*number*): Display index for the variable.
  * `onSet` (*function*): Function called when variable is set.
  * `onGet` (*function*): Function called when variable is retrieved.
  * `onValidate` (*function*): Function to validate variable value.
  * `onAdjust` (*function*): Function to adjust variable value.
  * `isLocal` (*boolean*): Whether variable is local to client.
  * `noNetworking` (*boolean*): Whether to skip networking.
  * `noDisplay` (*boolean*): Whether to hide from display.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic variable
lia.char.registerVar("level", {
    field = "level",
    fieldType = "integer",
    default = 1,
    index = 5
})

-- Register a complex variable with hooks
lia.char.registerVar("reputation", {
    field = "reputation",
    fieldType = "integer",
    default = 0,
    index = 6,
    onSet = function(character, value)
        local oldValue = character:getReputation()
        character.vars.reputation = value
        net.Start("charSet")
        net.WriteString("reputation")
        net.WriteType(value)
        net.WriteType(character:getID())
        net.Broadcast()
        hook.Run("OnCharVarChanged", character, "reputation", oldValue, value)
    end,
    onGet = function(character, default)
        return character.vars.reputation or default or 0
    end
})

-- Register a local variable
lia.char.registerVar("tempData", {
    default = {},
    isLocal = true,
    noDisplay = true
})

-- Register a variable with validation
lia.char.registerVar("age", {
    field = "age",
    fieldType = "integer",
    default = 18,
    onValidate = function(value, data, client)
        if not isnumber(value) or value < 18 or value > 100 then
            return false, "invalidAge"
        end
        return true
    end
})
```

---

### lia.char.getCharData

**Purpose**

Retrieves character data from the database by character ID.

**Parameters**

* `charID` (*number*): The character ID to retrieve data for.
* `key` (*string*): Optional specific key to retrieve.

**Returns**

* `data` (*table|any*): Character data table or specific value if key provided.

**Realm**

Server.

**Example Usage**

```lua
-- Get all character data
lia.char.getCharData(123):next(function(data)
    if data then
        print("Character data loaded")
        for key, value in pairs(data) do
            print(key .. ": " .. tostring(value))
        end
    end
end)

-- Get specific character data
lia.char.getCharData(456, "customData"):next(function(value)
    if value then
        print("Custom data: " .. tostring(value))
    end
end)

-- Get character data with error handling
lia.char.getCharData(789):next(function(data)
    if data then
        print("Data loaded successfully")
    else
        print("No data found")
    end
end):catch(function(err)
    print("Error loading data: " .. tostring(err))
end)
```

---

### lia.char.getCharDataRaw

**Purpose**

Retrieves raw character data from the database without processing.

**Parameters**

* `charID` (*number*): The character ID to retrieve data for.
* `key` (*string*): Optional specific key to retrieve.

**Returns**

* `data` (*table|any*): Raw character data or specific value if key provided.

**Realm**

Server.

**Example Usage**

```lua
-- Get raw character data
lia.char.getCharDataRaw(123):next(function(data)
    if data then
        print("Raw data loaded")
    end
end)

-- Get specific raw data
lia.char.getCharDataRaw(456, "rawField"):next(function(value)
    if value then
        print("Raw value: " .. tostring(value))
    end
end)

-- Get all raw data for processing
lia.char.getCharDataRaw(789):next(function(data)
    for key, value in pairs(data) do
        print("Raw " .. key .. ": " .. tostring(value))
    end
end)
```

---

### lia.char.getOwnerByID

**Purpose**

Gets the client who owns a character by character ID.

**Parameters**

* `ID` (*number*): The character ID to search for.

**Returns**

* `client` (*Player|nil*): The client who owns the character, nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Get character owner
local owner = lia.char.getOwnerByID(123)
if IsValid(owner) then
    print("Character owner: " .. owner:Name())
end

-- Get owner and perform action
local charID = 456
local owner = lia.char.getOwnerByID(charID)
if IsValid(owner) then
    owner:ChatPrint("Your character data has been updated")
end

-- Check if character is online
local charID = 789
local owner = lia.char.getOwnerByID(charID)
if owner then
    print("Character " .. charID .. " is online")
else
    print("Character " .. charID .. " is offline")
end
```

---

### lia.char.getBySteamID

**Purpose**

Gets a character by SteamID from online players.

**Parameters**

* `steamID` (*string*): The SteamID to search for.

**Returns**

* `character` (*table|nil*): The character if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get character by SteamID
local char = lia.char.getBySteamID("STEAM_0:1:123456")
if char then
    print("Character found: " .. char:getName())
end

-- Get character with validation
local steamID = "STEAM_0:1:789012"
local char = lia.char.getBySteamID(steamID)
if char and char:getPlayer() then
    print("Player " .. char:getPlayer():Name() .. " has character " .. char:getName())
end

-- Check if player has character
local steamID = client:SteamID()
local char = lia.char.getBySteamID(steamID)
if char then
    print("Player has active character")
else
    print("Player has no active character")
end
```

---

### lia.char.GetTeamColor

**Purpose**

Gets the team color for a client based on their character's class.

**Parameters**

* `client` (*Player*): The client to get team color for.

**Returns**

* `color` (*Color*): The team color for the client.

**Realm**

Shared.

**Example Usage**

```lua
-- Get team color for client
local color = lia.char.GetTeamColor(client)
print("Team color: " .. tostring(color))

-- Use team color in drawing
hook.Add("HUDPaint", "DrawPlayerInfo", function()
    local client = LocalPlayer()
    local color = lia.char.GetTeamColor(client)
    draw.SimpleText(client:Name(), "DermaDefault", 10, 10, color)
end)

-- Get team color for multiple players
for _, ply in pairs(player.GetAll()) do
    local color = lia.char.GetTeamColor(ply)
    print(ply:Name() .. " team color: " .. tostring(color))
end
```

---

### lia.char.create

**Purpose**

Creates a new character in the database.

**Parameters**

* `data` (*table*): Character data table.
* `callback` (*function*): Callback function to execute when character is created.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Create a new character
local charData = {
    name = "John Doe",
    desc = "A new character",
    model = "models/player/kleiner.mdl",
    faction = "Citizen",
    money = 1000,
    steamID = client:SteamID()
}

lia.char.create(charData, function(charID)
    print("Character created with ID: " .. charID)
    client:ChatPrint("Character created successfully!")
end)

-- Create character with validation
local charData = {
    name = "Jane Smith",
    desc = "A skilled character",
    model = "models/player/alyx.mdl",
    faction = "Citizen",
    money = lia.config.get("DefaultMoney", 1000),
    steamID = client:SteamID()
}

lia.char.create(charData, function(charID)
    if charID then
        print("Character " .. charID .. " created for " .. client:Name())
    else
        print("Failed to create character")
    end
end)
```

---

### lia.char.restore

**Purpose**

Restores characters for a client from the database.

**Parameters**

* `client` (*Player*): The client to restore characters for.
* `callback` (*function*): Callback function to execute when characters are restored.
* `id` (*number*): Optional specific character ID to restore.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Restore all characters for client
lia.char.restore(client, function(characters)
    print("Restored " .. #characters .. " characters for " .. client:Name())
    for _, charID in ipairs(characters) do
        print("Character ID: " .. charID)
    end
end)

-- Restore specific character
lia.char.restore(client, function(characters)
    if #characters > 0 then
        print("Character restored: " .. characters[1])
    end
end, 123)

-- Restore with error handling
lia.char.restore(client, function(characters)
    if characters and #characters > 0 then
        print("Characters restored successfully")
    else
        print("No characters found")
    end
end)
```

---

### lia.char.cleanUpForPlayer

**Purpose**

Cleans up all characters for a player when they disconnect.

**Parameters**

* `client` (*Player*): The client to clean up characters for.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Clean up on player disconnect
hook.Add("PlayerDisconnected", "CleanupCharacters", function(client)
    lia.char.cleanUpForPlayer(client)
    print("Cleaned up characters for " .. client:Name())
end)

-- Manual cleanup
lia.char.cleanUpForPlayer(client)

-- Cleanup with validation
if IsValid(client) then
    lia.char.cleanUpForPlayer(client)
end
```

---

### lia.char.delete

**Purpose**

Deletes a character from the database and unloads it.

**Parameters**

* `id` (*number*): The character ID to delete.
* `client` (*Player*): The client who owns the character.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Delete a character
lia.char.delete(123, client)

-- Delete character with validation
if lia.char.isLoaded(456) then
    lia.char.delete(456, client)
    print("Character 456 deleted")
end

-- Delete character and notify
local charID = 789
lia.char.delete(charID, client)
client:ChatPrint("Character deleted successfully")

-- Delete character with confirmation
if client:getChar() and client:getChar():getID() == charID then
    lia.char.delete(charID, client)
    client:Kick("Character deleted")
end
```

---

### lia.char.getCharBanned

**Purpose**

Checks if a character is banned.

**Parameters**

* `charID` (*number*): The character ID to check.

**Returns**

* `banned` (*number*): Ban status (0 = not banned, >0 = banned).

**Realm**

Server.

**Example Usage**

```lua
-- Check if character is banned
lia.char.getCharBanned(123):next(function(banned)
    if banned > 0 then
        print("Character is banned")
    else
        print("Character is not banned")
    end
end)

-- Check ban status before allowing login
local charID = 456
lia.char.getCharBanned(charID):next(function(banned)
    if banned > 0 then
        client:ChatPrint("This character is banned")
    else
        -- Allow character selection
    end
end)

-- Get ban status for admin
lia.char.getCharBanned(789):next(function(banned)
    if banned > 0 then
        print("Character " .. charID .. " is banned until " .. os.date("%c", banned))
    end
end)
```

---

### lia.char.setCharDatabase

**Purpose**

Sets character data in the database.

**Parameters**

* `charID` (*number*): The character ID to update.
* `field` (*string*): The field to update.
* `value` (*any*): The value to set.

**Returns**

* `success` (*boolean*): True if successful, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
-- Set character money
lia.char.setCharDatabase(123, "money", 5000)

-- Set character name
lia.char.setCharDatabase(456, "name", "New Name")

-- Set custom data
lia.char.setCharDatabase(789, "customField", "customValue")

-- Set data with validation
if lia.char.isLoaded(charID) then
    local success = lia.char.setCharDatabase(charID, "level", 10)
    if success then
        print("Character level updated")
    end
end

-- Set multiple fields
local updates = {
    {field = "money", value = 1000},
    {field = "level", value = 5},
    {field = "experience", value = 250}
}

for _, update in ipairs(updates) do
    lia.char.setCharDatabase(charID, update.field, update.value)
end
```

---

### lia.char.unloadCharacter

**Purpose**

Unloads a character from memory and saves it.

**Parameters**

* `charID` (*number*): The character ID to unload.

**Returns**

* `success` (*boolean*): True if successful, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
-- Unload a character
local success = lia.char.unloadCharacter(123)
if success then
    print("Character 123 unloaded")
end

-- Unload character with validation
if lia.char.isLoaded(456) then
    lia.char.unloadCharacter(456)
    print("Character unloaded and saved")
end

-- Unload character before deletion
local charID = 789
if lia.char.unloadCharacter(charID) then
    lia.char.delete(charID, client)
end
```

---

### lia.char.unloadUnusedCharacters

**Purpose**

Unloads unused characters for a client, keeping only the active one.

**Parameters**

* `client` (*Player*): The client to unload characters for.
* `activeCharID` (*number*): The ID of the character to keep loaded.

**Returns**

* `unloadedCount` (*number*): Number of characters unloaded.

**Realm**

Server.

**Example Usage**

```lua
-- Unload unused characters
local unloaded = lia.char.unloadUnusedCharacters(client, activeCharID)
print("Unloaded " .. unloaded .. " characters")

-- Unload with validation
if IsValid(client) and activeCharID then
    local count = lia.char.unloadUnusedCharacters(client, activeCharID)
    print("Cleaned up " .. count .. " unused characters")
end

-- Unload after character selection
local charID = client:getChar():getID()
local unloaded = lia.char.unloadUnusedCharacters(client, charID)
print("Kept character " .. charID .. " loaded, unloaded " .. unloaded .. " others")
```

---

### lia.char.loadSingleCharacter

**Purpose**

Loads a single character from the database.

**Parameters**

* `charID` (*number*): The character ID to load.
* `client` (*Player*): The client requesting the character.
* `callback` (*function*): Callback function to execute when character is loaded.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Load a single character
lia.char.loadSingleCharacter(123, client, function(char)
    if char then
        print("Character loaded: " .. char:getName())
    else
        print("Failed to load character")
    end
end)

-- Load character with validation
if lia.char.isLoaded(charID) then
    print("Character already loaded")
else
    lia.char.loadSingleCharacter(charID, client, function(char)
        if char then
            print("Character " .. charID .. " loaded successfully")
        end
    end)
end

-- Load character for offline player
lia.char.loadSingleCharacter(456, nil, function(char)
    if char then
        print("Character loaded for offline player")
    end
end)
```