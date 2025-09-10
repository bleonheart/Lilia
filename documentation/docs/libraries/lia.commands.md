# Commands Library

This page documents the functions for working with command system and command management.

---

## Overview

The commands library (`lia.command`) provides a comprehensive command system for the Lilia framework. It handles command registration, argument parsing, privilege checking, and command execution. The library supports complex argument types, automatic privilege registration, command aliases, and client-server command synchronization.

---

### lia.command.buildSyntaxFromArguments

**Purpose**

Builds a syntax string from command arguments for display purposes.

**Parameters**

* `args` (*table*): Table of argument definitions.

**Returns**

* `syntax` (*string*): Formatted syntax string.

**Realm**

Shared.

**Example Usage**

```lua
-- Build syntax from arguments
local args = {
    {name = "player", type = "player"},
    {name = "amount", type = "number", optional = true},
    {name = "reason", type = "string", optional = true}
}
local syntax = lia.command.buildSyntaxFromArguments(args)
print("Syntax: " .. syntax) -- [player player] [number amount optional] [string reason optional]

-- Use in command registration
local commandArgs = {
    {name = "target", type = "player"},
    {name = "duration", type = "number"},
    {name = "reason", type = "string", optional = true}
}
local syntax = lia.command.buildSyntaxFromArguments(commandArgs)
```

---

### lia.command.add

**Purpose**

Registers a new command with specified properties and behaviors.

**Parameters**

* `command` (*string*): The command name to register.
* `data` (*table*): Command configuration table containing:
  * `arguments` (*table*): Command argument definitions.
  * `desc` (*string*): Description of the command.
  * `privilege` (*string*): Privilege required to use the command.
  * `superAdminOnly` (*boolean*): Whether command requires superadmin.
  * `adminOnly` (*boolean*): Whether command requires admin.
  * `onRun` (*function*): Function to execute when command is run.
  * `alias` (*string|table*): Command alias(es).

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic command
lia.command.add("hello", {
    desc = "Say hello",
    onRun = function(client, arguments)
        client:ChatPrint("Hello, " .. client:Name() .. "!")
    end
})

-- Register a command with arguments
lia.command.add("give", {
    arguments = {
        {name = "player", type = "player"},
        {name = "item", type = "string"},
        {name = "amount", type = "number", optional = true}
    },
    desc = "Give an item to a player",
    onRun = function(client, arguments)
        local target = arguments[1]
        local item = arguments[2]
        local amount = arguments[3] or 1
        
        if target:getChar() then
            for i = 1, amount do
                target:getChar():getInv():add(item)
            end
            client:ChatPrint("Gave " .. amount .. "x " .. item .. " to " .. target:Name())
        end
    end
})

-- Register an admin command
lia.command.add("kick", {
    arguments = {
        {name = "player", type = "player"},
        {name = "reason", type = "string", optional = true}
    },
    desc = "Kick a player from the server",
    adminOnly = true,
    onRun = function(client, arguments)
        local target = arguments[1]
        local reason = arguments[2] or "No reason provided"
        
        target:Kick(reason)
        client:ChatPrint("Kicked " .. target:Name() .. " for: " .. reason)
    end
})

-- Register a superadmin command
lia.command.add("ban", {
    arguments = {
        {name = "player", type = "player"},
        {name = "duration", type = "number"},
        {name = "reason", type = "string", optional = true}
    },
    desc = "Ban a player from the server",
    superAdminOnly = true,
    onRun = function(client, arguments)
        local target = arguments[1]
        local duration = arguments[2]
        local reason = arguments[3] or "No reason provided"
        
        target:banPlayer(reason, duration, client)
        client:ChatPrint("Banned " .. target:Name() .. " for " .. duration .. " minutes")
    end
})

-- Register a command with alias
lia.command.add("teleport", {
    arguments = {
        {name = "player", type = "player"}
    },
    desc = "Teleport to a player",
    adminOnly = true,
    alias = {"tp", "goto"},
    onRun = function(client, arguments)
        local target = arguments[1]
        client:SetPos(target:GetPos())
        client:ChatPrint("Teleported to " .. target:Name())
    end
})

-- Register a command with custom privilege
lia.command.add("economy", {
    arguments = {
        {name = "action", type = "string"},
        {name = "player", type = "player"},
        {name = "amount", type = "number"}
    },
    desc = "Manage economy",
    privilege = "economyManage",
    onRun = function(client, arguments)
        local action = arguments[1]
        local target = arguments[2]
        local amount = arguments[3]
        
        if action == "give" then
            target:getChar():setMoney(target:getChar():getMoney() + amount)
            client:ChatPrint("Gave $" .. amount .. " to " .. target:Name())
        elseif action == "take" then
            target:getChar():setMoney(target:getChar():getMoney() - amount)
            client:ChatPrint("Took $" .. amount .. " from " .. target:Name())
        end
    end
})
```

---

### lia.command.hasAccess

**Purpose**

Checks if a client has access to use a specific command.

**Parameters**

* `client` (*Player*): The client to check access for.
* `command` (*string*): The command name to check.
* `data` (*table*): Optional command data table.

**Returns**

* `hasAccess` (*boolean*): True if client has access, false otherwise.
* `privilegeName` (*string*): Name of the required privilege.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if client has access to a command
local hasAccess, privilege = lia.command.hasAccess(client, "kick")
if hasAccess then
    print("Client can use kick command")
else
    print("Client needs privilege: " .. privilege)
end

-- Check access in command
lia.command.add("testaccess", {
    onRun = function(client, arguments)
        local hasAccess, privilege = lia.command.hasAccess(client, "kick")
        if hasAccess then
            client:ChatPrint("You have access to kick command")
        else
            client:ChatPrint("You need privilege: " .. privilege)
        end
    end
})

-- Check access for multiple commands
local commands = {"kick", "ban", "teleport"}
for _, cmd in ipairs(commands) do
    local hasAccess, privilege = lia.command.hasAccess(client, cmd)
    if hasAccess then
        print("Client can use: " .. cmd)
    else
        print("Client needs " .. privilege .. " for: " .. cmd)
    end
end

-- Use in UI to show available commands
local function getAvailableCommands(client)
    local available = {}
    for cmdName, cmdData in pairs(lia.command.list) do
        local hasAccess = lia.command.hasAccess(client, cmdName, cmdData)
        if hasAccess then
            table.insert(available, cmdName)
        end
    end
    return available
end
```

---

### lia.command.extractArgs

**Purpose**

Extracts arguments from a command string, handling quoted strings properly.

**Parameters**

* `text` (*string*): The command text to extract arguments from.

**Returns**

* `arguments` (*table*): Table of extracted arguments.

**Realm**

Shared.

**Example Usage**

```lua
-- Extract arguments from command text
local args = lia.command.extractArgs('give "John Doe" "health potion" 5')
print("Arguments: " .. table.concat(args, ", ")) -- John Doe, health potion, 5

-- Extract arguments with quotes
local args = lia.command.extractArgs('say "Hello world!" "How are you?"')
print("Arguments: " .. table.concat(args, ", ")) -- Hello world!, How are you?

-- Extract arguments with mixed quotes
local args = lia.command.extractArgs('command arg1 "quoted arg" arg3')
print("Arguments: " .. table.concat(args, ", ")) -- arg1, quoted arg, arg3

-- Use in command parsing
local function parseCommand(text)
    local args = lia.command.extractArgs(text)
    local command = args[1]
    table.remove(args, 1) -- Remove command name
    return command, args
end

-- Extract arguments with validation
local args = lia.command.extractArgs(commandText)
if #args > 0 then
    print("Command: " .. args[1])
    print("Arguments: " .. table.concat(args, ", ", 2))
else
    print("No arguments found")
end
```

---

### lia.command.run

**Purpose**

Executes a command for a client with proper privilege checking and result handling.

**Parameters**

* `client` (*Player*): The client executing the command.
* `command` (*string*): The command name to execute.
* `arguments` (*table*): The arguments for the command.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Run a command
lia.command.run(client, "hello", {})

-- Run a command with arguments
lia.command.run(client, "give", {target, "health_potion", 5})

-- Run command with validation
if lia.command.list[command] then
    lia.command.run(client, command, arguments)
else
    client:ChatPrint("Command not found: " .. command)
end

-- Run command in hook
hook.Add("PlayerSay", "CommandHandler", function(ply, text)
    if text:sub(1, 1) == "/" then
        local command = text:sub(2):match("^([%w_]+)")
        local args = lia.command.extractArgs(text:sub(#command + 3))
        lia.command.run(ply, command, args)
        return false
    end
end)

-- Run command with error handling
local success, err = pcall(function()
    lia.command.run(client, command, arguments)
end)

if not success then
    print("Command error: " .. tostring(err))
end
```

---

### lia.command.parse

**Purpose**

Parses and executes a command from text input with argument validation.

**Parameters**

* `client` (*Player*): The client executing the command.
* `text` (*string*): The command text to parse.
* `realCommand` (*string*): Optional real command name.
* `arguments` (*table*): Optional pre-parsed arguments.

**Returns**

* `isCommand` (*boolean*): True if text was a command, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
-- Parse command from text
local isCommand = lia.command.parse(client, "/hello")
if isCommand then
    print("Command executed")
end

-- Parse command with arguments
local isCommand = lia.command.parse(client, "/give player item 5")
if isCommand then
    print("Give command executed")
end

-- Parse in PlayerSay hook
hook.Add("PlayerSay", "CommandParser", function(ply, text)
    local isCommand = lia.command.parse(ply, text)
    if isCommand then
        return false -- Prevent default chat
    end
end)

-- Parse with real command
lia.command.parse(client, "hello world", "greet", {"world"})

-- Parse with validation
if text:sub(1, 1) == "/" then
    local isCommand = lia.command.parse(client, text)
    if not isCommand then
        client:ChatPrint("Command not found or invalid arguments")
    end
end
```

---

### lia.command.openArgumentPrompt

**Purpose**

Opens a GUI prompt for entering command arguments when required arguments are missing.

**Parameters**

* `cmdKey` (*string*): The command key to prompt for.
* `missing` (*table*): Table of missing argument names.
* `prefix` (*table*): Table of already provided arguments.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Open argument prompt for missing arguments
lia.command.openArgumentPrompt("give", {"player", "item"}, {})

-- Open prompt with prefix arguments
lia.command.openArgumentPrompt("teleport", {"player"}, {"target"})

-- Open prompt in command
lia.command.add("complex", {
    arguments = {
        {name = "player", type = "player"},
        {name = "item", type = "string"},
        {name = "amount", type = "number"},
        {name = "reason", type = "string", optional = true}
    },
    onRun = function(client, arguments)
        -- Command implementation
    end
})

-- Open prompt with validation
if #missing > 0 then
    lia.command.openArgumentPrompt(command, missing, prefix)
end
```

---

### lia.command.send

**Purpose**

Sends a command to the server from the client.

**Parameters**

* `command` (*string*): The command name to send.
* `...` (*any*): Command arguments to send.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Send a simple command
lia.command.send("hello")

-- Send a command with arguments
lia.command.send("give", target, "health_potion", 5)

-- Send command with validation
if IsValid(target) then
    lia.command.send("teleport", target)
end

-- Send command in hook
hook.Add("OnEntityCreated", "AutoCommand", function(ent)
    if ent:GetClass() == "prop_physics" then
        lia.command.send("log", "Prop created: " .. ent:GetModel())
    end
end)

-- Send command with error handling
local success, err = pcall(function()
    lia.command.send("complex", arg1, arg2, arg3)
end)

if not success then
    print("Command send error: " .. tostring(err))
end
```

---

### lia.command.findPlayer

**Purpose**

Finds a player by name or partial name match.

**Parameters**

* `client` (*Player*): The client requesting the player search.
* `name` (*string*): The name or partial name to search for.

**Returns**

* `player` (*Player|nil*): The found player or nil if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Find player by name
local target = lia.command.findPlayer(client, "John")
if IsValid(target) then
    print("Found player: " .. target:Name())
end

-- Find player with validation
local target = lia.command.findPlayer(client, name)
if not IsValid(target) then
    client:ChatPrint("Player not found: " .. name)
    return
end

-- Use in command
lia.command.add("info", {
    arguments = {
        {name = "player", type = "string"}
    },
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            client:ChatPrint("Player: " .. target:Name())
            client:ChatPrint("SteamID: " .. target:SteamID())
        else
            client:ChatPrint("Player not found")
        end
    end
})

-- Find player with partial matching
local target = lia.command.findPlayer(client, "Jo")
if IsValid(target) then
    print("Found: " .. target:Name())
end
```