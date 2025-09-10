# Classes Library

This page documents the functions for working with character classes and job management.

---

## Overview

The classes library (`lia.class`) provides a system for managing character classes (jobs) within the Lilia framework. It handles class registration, loading from files, validation, and provides functions for checking class availability, retrieving class information, and managing player class assignments. Classes are associated with factions and can have limits, whitelists, and custom validation logic.

---

### lia.class.register

**Purpose**

Registers a new character class with the system.

**Parameters**

* `uniqueID` (*string*): The unique identifier for the class.
* `data` (*table*): A table containing class configuration with fields:
  * `name` (*string*, *optional*): The display name of the class.
  * `desc` (*string*, *optional*): The description of the class.
  * `faction` (*number*): The faction index this class belongs to.
  * `limit` (*number*, *optional*): The maximum number of players allowed in this class (0 = unlimited).
  * `OnCanBe` (*function*, *optional*): Function to determine if a player can join this class.
  * `isDefault` (*boolean*, *optional*): Whether this is a default class for the faction.
  * `isWhitelisted` (*boolean*, *optional*): Whether this class requires whitelist access.

**Returns**

* `class` (*table*): The registered class object.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic citizen class
lia.class.register("citizen", {
    name = "Citizen",
    desc = "A regular citizen",
    faction = FACTION_CITIZEN,
    limit = 0,
    isDefault = true
})

-- Register a limited police class
lia.class.register("police_officer", {
    name = "Police Officer",
    desc = "A law enforcement officer",
    faction = FACTION_POLICE,
    limit = 5,
    isWhitelisted = true,
    OnCanBe = function(client)
        return client:hasPrivilege("joinPolice")
    end
})

-- Register a custom class with validation
lia.class.register("medic", {
    name = "Medic",
    desc = "A medical professional",
    faction = FACTION_MEDICAL,
    limit = 3,
    OnCanBe = function(client)
        local char = client:getChar()
        if not char then return false end
        return char:getAttrib("medical", 0) >= 50
    end
})
```

---

### lia.class.loadFromDir

**Purpose**

Loads class definitions from Lua files in a specified directory.

**Parameters**

* `directory` (*string*): The path to the directory containing class definition files.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Load classes from the default classes directory
lia.class.loadFromDir("gamemode/classes")

-- Load classes from a custom directory
lia.class.loadFromDir("gamemode/custom_classes")

-- Load classes from a module's classes folder
lia.class.loadFromDir("gamemode/modules/my_module/classes")
```

---

### lia.class.canBe

**Purpose**

Checks if a player can join a specific class.

**Parameters**

* `client` (*Player*): The player to check.
* `class` (*number*): The class index to check.

**Returns**

* `canJoin` (*boolean*): True if the player can join the class, false otherwise.
* `reason` (*string*): The reason why the player cannot join (if applicable).

**Realm**

Shared.

**Example Usage**

```lua
-- Check if a player can join a class
local canJoin, reason = lia.class.canBe(client, 1)
if canJoin then
    print("Player can join class 1")
else
    print("Cannot join class 1: " .. reason)
end

-- Use in class selection UI
local function updateClassButtons()
    for i, class in ipairs(lia.class.list) do
        local canJoin, reason = lia.class.canBe(LocalPlayer(), i)
        if canJoin then
            classButton:SetEnabled(true)
        else
            classButton:SetEnabled(false)
            classButton:SetTooltip(reason)
        end
    end
end
```

---

### lia.class.get

**Purpose**

Retrieves a class object by its identifier.

**Parameters**

* `identifier` (*number|string*): The class index or unique ID.

**Returns**

* `class` (*table*): The class object if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get class by index
local class = lia.class.get(1)
if class then
    print("Class name: " .. class.name)
end

-- Get class by unique ID
local class = lia.class.get("police_officer")
if class then
    print("Police officer class found")
end

-- Use in character creation
local function getClassInfo(classID)
    local class = lia.class.get(classID)
    if class then
        return {
            name = class.name,
            desc = class.desc,
            limit = class.limit
        }
    end
    return nil
end
```

---

### lia.class.getPlayers

**Purpose**

Retrieves all players currently in a specific class.

**Parameters**

* `class` (*number*): The class index to get players for.

**Returns**

* `players` (*table*): A table of player entities in the class.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all players in class 1
local players = lia.class.getPlayers(1)
print("Players in class 1: " .. #players)

-- Get all police officers
local policeClass = lia.class.get("police_officer")
if policeClass then
    local police = lia.class.getPlayers(policeClass.index)
    print("Police officers online: " .. #police)
    for _, officer in ipairs(police) do
        print("- " .. officer:Name())
    end
end

-- Use in admin commands
hook.Add("PlayerSay", "ListClassPlayers", function(ply, text)
    if text:sub(1, 8) == "!listclass" then
        local classID = tonumber(text:sub(10))
        if classID then
            local players = lia.class.getPlayers(classID)
            ply:ChatPrint("Players in class " .. classID .. ": " .. #players)
        end
    end
end)
```

---

### lia.class.getPlayerCount

**Purpose**

Counts the number of players currently in a specific class.

**Parameters**

* `class` (*number*): The class index to count players for.

**Returns**

* `count` (*number*): The number of players in the class.

**Realm**

Shared.

**Example Usage**

```lua
-- Count players in class 1
local count = lia.class.getPlayerCount(1)
print("Players in class 1: " .. count)

-- Check if class is full
local class = lia.class.get("police_officer")
if class then
    local currentCount = lia.class.getPlayerCount(class.index)
    if currentCount >= class.limit then
        print("Police class is full!")
    end
end

-- Use in class selection
local function updateClassInfo()
    for i, class in ipairs(lia.class.list) do
        local count = lia.class.getPlayerCount(i)
        local limit = class.limit > 0 and class.limit or "∞"
        print(class.name .. ": " .. count .. "/" .. limit)
    end
end
```

---

### lia.class.retrieveClass

**Purpose**

Finds a class by its unique ID or name using string matching.

**Parameters**

* `class` (*string*): The class unique ID or name to search for.

**Returns**

* `classIndex` (*number*): The class index if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Find class by unique ID
local classIndex = lia.class.retrieveClass("police_officer")
if classIndex then
    print("Found police officer class at index: " .. classIndex)
end

-- Find class by name
local classIndex = lia.class.retrieveClass("Police Officer")
if classIndex then
    print("Found Police Officer class at index: " .. classIndex)
end

-- Use in command parsing
local function parseClassCommand(text)
    local classIndex = lia.class.retrieveClass(text)
    if classIndex then
        local class = lia.class.get(classIndex)
        print("Found class: " .. class.name)
    else
        print("Class not found: " .. text)
    end
end
```

---

### lia.class.hasWhitelist

**Purpose**

Checks if a class requires whitelist access.

**Parameters**

* `class` (*number*): The class index to check.

**Returns**

* `hasWhitelist` (*boolean*): True if the class requires whitelist access, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if class requires whitelist
local classIndex = 1
if lia.class.hasWhitelist(classIndex) then
    print("Class " .. classIndex .. " requires whitelist access")
else
    print("Class " .. classIndex .. " is open to all")
end

-- Use in class validation
local function canJoinClass(client, classIndex)
    if lia.class.hasWhitelist(classIndex) then
        return client:hasPrivilege("joinWhitelistedClass")
    end
    return true
end
```

---

### lia.class.retrieveJoinable

**Purpose**

Retrieves all classes that a player can join.

**Parameters**

* `client` (*Player*, *optional*): The player to check. If nil, uses LocalPlayer() on client.

**Returns**

* `classes` (*table*): A table of class objects that the player can join.

**Realm**

Shared.

**Example Usage**

```lua
-- Get joinable classes for a player
local joinableClasses = lia.class.retrieveJoinable(client)
print("Player can join " .. #joinableClasses .. " classes")

-- Display joinable classes
for _, class in ipairs(joinableClasses) do
    print("- " .. class.name .. ": " .. class.desc)
end

-- Use in class selection UI
local function populateClassList()
    local joinableClasses = lia.class.retrieveJoinable(LocalPlayer())
    for _, class in ipairs(joinableClasses) do
        local button = vgui.Create("DButton")
        button:SetText(class.name)
        button:SetTooltip(class.desc)
        -- Add to UI
    end
end
```