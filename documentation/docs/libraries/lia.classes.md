# Classes Library

This page documents the functions for working with character classes and class management.

---

## Overview

The classes library (`lia.class`) provides a comprehensive system for managing character classes in the Lilia framework. It handles class registration, loading from files, validation, and player class management. The library supports class limits, whitelisting, faction requirements, and custom class behaviors through hooks and callbacks.

---

### lia.class.register

**Purpose**

Registers a new character class with specified properties and behaviors.

**Parameters**

* `uniqueID` (*string*): The unique identifier for the class.
* `data` (*table*): Class configuration table containing:
  * `name` (*string*): Display name of the class.
  * `desc` (*string*): Description of the class.
  * `faction` (*number*): Faction/team ID this class belongs to.
  * `limit` (*number*): Maximum number of players allowed in this class.
  * `OnCanBe` (*function*): Function to determine if player can join this class.
  * `isDefault` (*boolean*): Whether this is a default class for the faction.
  * `isWhitelisted` (*boolean*): Whether this class requires whitelist.
  * `Color` (*Color*): Color associated with this class.

**Returns**

* `class` (*table*): The registered class object.

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic class
lia.class.register("citizen", {
    name = "Citizen",
    desc = "A regular citizen",
    faction = 1,
    limit = 0,
    isDefault = true
})

-- Register a limited class
lia.class.register("police_officer", {
    name = "Police Officer",
    desc = "A law enforcement officer",
    faction = 2,
    limit = 5,
    Color = Color(0, 0, 255)
})

-- Register a whitelisted class
lia.class.register("admin", {
    name = "Administrator",
    desc = "Server administrator",
    faction = 3,
    limit = 3,
    isWhitelisted = true,
    Color = Color(255, 0, 0),
    OnCanBe = function(client)
        return client:hasPrivilege("adminClass")
    end
})

-- Register a custom class with validation
lia.class.register("medic", {
    name = "Medic",
    desc = "Medical professional",
    faction = 1,
    limit = 2,
    Color = Color(255, 255, 255),
    OnCanBe = function(client)
        local char = client:getChar()
        return char and char:getMoney() > 1000
    end
})

-- Register a VIP class
lia.class.register("vip", {
    name = "VIP Member",
    desc = "Premium player class",
    faction = 1,
    limit = 10,
    Color = Color(255, 215, 0),
    isWhitelisted = true
})
```

---

### lia.class.loadFromDir

**Purpose**

Loads class definitions from a directory containing class files.

**Parameters**

* `directory` (*string*): The directory path to load classes from.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Load classes from a specific directory
lia.class.loadFromDir("gamemode/classes")

-- Load classes from schema directory
lia.class.loadFromDir("schema/classes")

-- Load classes from addon directory
lia.class.loadFromDir("addons/myaddon/lua/classes")

-- Load classes with error handling
local success, err = pcall(function()
    lia.class.loadFromDir("gamemode/classes")
end)

if not success then
    print("Failed to load classes: " .. tostring(err))
end
```

---

### lia.class.canBe

**Purpose**

Checks if a client can join a specific class.

**Parameters**

* `client` (*Player*): The client to check.
* `class` (*number*): The class index to check.

**Returns**

* `canJoin` (*boolean*): True if client can join the class.
* `reason` (*string*): Reason why client cannot join (if applicable).

**Realm**

Shared.

**Example Usage**

```lua
-- Check if client can join a class
local canJoin, reason = lia.class.canBe(client, 1)
if canJoin then
    print("Client can join class 1")
else
    print("Cannot join: " .. reason)
end

-- Check with validation
local classIndex = 2
local canJoin, reason = lia.class.canBe(client, classIndex)
if canJoin then
    client:ChatPrint("You can join this class!")
else
    client:ChatPrint("Cannot join: " .. reason)
end

-- Check multiple classes
for i = 1, #lia.class.list do
    local canJoin, reason = lia.class.canBe(client, i)
    if canJoin then
        print("Client can join class " .. i)
    end
end

-- Check in command
lia.command.add("joinclass", {
    arguments = {
        {name = "class", type = "string"}
    },
    onRun = function(client, arguments)
        local classIndex = lia.class.retrieveClass(arguments[1])
        if classIndex then
            local canJoin, reason = lia.class.canBe(client, classIndex)
            if canJoin then
                -- Allow class change
            else
                client:ChatPrint("Cannot join: " .. reason)
            end
        end
    end
})
```

---

### lia.class.get

**Purpose**

Retrieves a class by its identifier (index or uniqueID).

**Parameters**

* `identifier` (*number|string*): The class index or uniqueID to retrieve.

**Returns**

* `class` (*table|nil*): The class object if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Get class by index
local class = lia.class.get(1)
if class then
    print("Class name: " .. class.name)
end

-- Get class by uniqueID
local class = lia.class.get("police_officer")
if class then
    print("Class limit: " .. class.limit)
end

-- Get class with validation
local classIndex = 2
local class = lia.class.get(classIndex)
if class then
    print("Class " .. classIndex .. " is " .. class.name)
else
    print("Class " .. classIndex .. " not found")
end

-- Get class in hook
hook.Add("PlayerSpawn", "SetClassColor", function(ply)
    local char = ply:getChar()
    if char then
        local class = lia.class.get(char:getClass())
        if class and class.Color then
            ply:SetPlayerColor(Vector(class.Color.r/255, class.Color.g/255, class.Color.b/255))
        end
    end
end)
```

---

### lia.class.getPlayers

**Purpose**

Gets all players currently in a specific class.

**Parameters**

* `class` (*number*): The class index to get players for.

**Returns**

* `players` (*table*): Table of players in the class.

**Realm**

Shared.

**Example Usage**

```lua
-- Get players in a class
local players = lia.class.getPlayers(1)
print("Players in class 1: " .. #players)

-- Get players with names
local players = lia.class.getPlayers(2)
for _, ply in ipairs(players) do
    print("Player: " .. ply:Name())
end

-- Count players in each class
for i = 1, #lia.class.list do
    local players = lia.class.getPlayers(i)
    local class = lia.class.get(i)
    if class then
        print(class.name .. ": " .. #players .. " players")
    end
end

-- Get players for admin command
lia.command.add("listclass", {
    arguments = {
        {name = "class", type = "string"}
    },
    onRun = function(client, arguments)
        local classIndex = lia.class.retrieveClass(arguments[1])
        if classIndex then
            local players = lia.class.getPlayers(classIndex)
            local class = lia.class.get(classIndex)
            client:ChatPrint("Players in " .. class.name .. ": " .. #players)
            for _, ply in ipairs(players) do
                client:ChatPrint("- " .. ply:Name())
            end
        end
    end
})
```

---

### lia.class.getPlayerCount

**Purpose**

Gets the number of players currently in a specific class.

**Parameters**

* `class` (*number*): The class index to count players for.

**Returns**

* `count` (*number*): Number of players in the class.

**Realm**

Shared.

**Example Usage**

```lua
-- Get player count for a class
local count = lia.class.getPlayerCount(1)
print("Players in class 1: " .. count)

-- Check if class is full
local classIndex = 2
local count = lia.class.getPlayerCount(classIndex)
local class = lia.class.get(classIndex)
if class and class.limit > 0 and count >= class.limit then
    print("Class is full!")
end

-- Count players in all classes
for i = 1, #lia.class.list do
    local count = lia.class.getPlayerCount(i)
    local class = lia.class.get(i)
    if class then
        print(class.name .. ": " .. count .. "/" .. (class.limit > 0 and class.limit or "∞"))
    end
end

-- Use in class validation
local function canJoinClass(client, classIndex)
    local class = lia.class.get(classIndex)
    if not class then return false end
    
    if class.limit > 0 then
        local count = lia.class.getPlayerCount(classIndex)
        if count >= class.limit then
            return false, "Class is full"
        end
    end
    
    return true
end
```

---

### lia.class.retrieveClass

**Purpose**

Finds a class by its uniqueID or name using string matching.

**Parameters**

* `class` (*string*): The class uniqueID or name to search for.

**Returns**

* `classIndex` (*number|nil*): The class index if found, nil otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Find class by uniqueID
local classIndex = lia.class.retrieveClass("police_officer")
if classIndex then
    print("Found class at index: " .. classIndex)
end

-- Find class by name
local classIndex = lia.class.retrieveClass("Police Officer")
if classIndex then
    print("Found class at index: " .. classIndex)
end

-- Use in command
lia.command.add("setclass", {
    arguments = {
        {name = "player", type = "player"},
        {name = "class", type = "string"}
    },
    onRun = function(client, arguments)
        local target = arguments[1]
        local className = arguments[2]
        local classIndex = lia.class.retrieveClass(className)
        
        if classIndex then
            local canJoin, reason = lia.class.canBe(target, classIndex)
            if canJoin then
                -- Set class
                target:getChar():setClass(classIndex)
                client:ChatPrint("Set " .. target:Name() .. " to " .. className)
            else
                client:ChatPrint("Cannot set class: " .. reason)
            end
        else
            client:ChatPrint("Class not found: " .. className)
        end
    end
})

-- Find class with partial matching
local searchTerm = "police"
local classIndex = lia.class.retrieveClass(searchTerm)
if classIndex then
    local class = lia.class.get(classIndex)
    print("Found class: " .. class.name)
end
```

---

### lia.class.hasWhitelist

**Purpose**

Checks if a class requires whitelist to join.

**Parameters**

* `class` (*number*): The class index to check.

**Returns**

* `isWhitelisted` (*boolean*): True if class requires whitelist, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if class is whitelisted
local isWhitelisted = lia.class.hasWhitelist(1)
if isWhitelisted then
    print("Class 1 requires whitelist")
end

-- Check multiple classes
for i = 1, #lia.class.list do
    local isWhitelisted = lia.class.hasWhitelist(i)
    local class = lia.class.get(i)
    if class then
        print(class.name .. " whitelisted: " .. tostring(isWhitelisted))
    end
end

-- Use in class selection UI
local function canShowClass(client, classIndex)
    local class = lia.class.get(classIndex)
    if not class then return false end
    
    if class.isDefault then return true end
    
    local isWhitelisted = lia.class.hasWhitelist(classIndex)
    if isWhitelisted then
        return client:hasWhitelist(classIndex)
    end
    
    return true
end

-- Check in command
lia.command.add("checkwhitelist", {
    arguments = {
        {name = "class", type = "string"}
    },
    onRun = function(client, arguments)
        local classIndex = lia.class.retrieveClass(arguments[1])
        if classIndex then
            local isWhitelisted = lia.class.hasWhitelist(classIndex)
            local class = lia.class.get(classIndex)
            client:ChatPrint(class.name .. " whitelisted: " .. tostring(isWhitelisted))
        end
    end
})
```

---

### lia.class.retrieveJoinable

**Purpose**

Gets all classes that a client can currently join.

**Parameters**

* `client` (*Player*): The client to get joinable classes for (optional, defaults to LocalPlayer).

**Returns**

* `classes` (*table*): Table of joinable class objects.

**Realm**

Shared.

**Example Usage**

```lua
-- Get joinable classes for client
local classes = lia.class.retrieveJoinable(client)
print("Joinable classes: " .. #classes)

-- Get joinable classes with names
local classes = lia.class.retrieveJoinable(client)
for _, class in ipairs(classes) do
    print("Can join: " .. class.name)
end

-- Use in class selection UI
local function buildClassList(client)
    local classes = lia.class.retrieveJoinable(client)
    local classList = {}
    
    for _, class in ipairs(classes) do
        table.insert(classList, {
            name = class.name,
            desc = class.desc,
            index = class.index
        })
    end
    
    return classList
end

-- Get joinable classes for current player
if CLIENT then
    local classes = lia.class.retrieveJoinable()
    print("You can join " .. #classes .. " classes")
end

-- Use in command
lia.command.add("listjoinable", {
    onRun = function(client)
        local classes = lia.class.retrieveJoinable(client)
        client:ChatPrint("Joinable classes: " .. #classes)
        for _, class in ipairs(classes) do
            client:ChatPrint("- " .. class.name)
        end
    end
})
```
```