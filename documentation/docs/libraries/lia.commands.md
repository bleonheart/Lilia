# Commands Library

This page documents the functions for working with console commands and command management.

---

## Overview

The commands library (`lia.command`) provides a comprehensive system for managing in-game console commands within the Lilia framework. It handles command registration, argument parsing, access control, and execution. The library supports various argument types, privilege-based access control, and provides a user-friendly interface for command management.

---

### lia.command.buildSyntaxFromArguments

**Purpose**

Builds a syntax string from command arguments for display purposes.

**Parameters**

* `args` (*table*): A table of argument definitions.

**Returns**

* `syntax` (*string*): The formatted syntax string.

**Realm**

Shared.

**Example Usage**

```lua
-- Build syntax from arguments
local args = {
    {name = "player", type = "player"},
    {name = "reason", type = "string", optional = true}
}
local syntax = lia.command.buildSyntaxFromArguments(args)
print("Syntax: " .. syntax) -- "[player player] [string reason optional]"

-- Use in command registration
local commandArgs = {
    {name = "target", type = "player"},
    {name = "amount", type = "number"},
    {name = "reason", type = "string", optional = true}
}
local syntax = lia.command.buildSyntaxFromArguments(commandArgs)
```

---

### lia.command.add

**Purpose**

Registers a new console command with the system.

**Parameters**

* `command` (*string*): The command name.
* `data` (*table*): A table containing command configuration with fields:
  * `arguments` (*table*, *optional*): Command arguments.
  * `desc` (*string*, *optional*): Command description.
  * `privilege` (*string*, *optional*): Required privilege for the command.
  * `onRun` (*function*): Function to execute when the command is run.
  * `alias` (*string|table*, *optional*): Command aliases.
  * `adminOnly` (*boolean*, *optional*): Whether the command requires admin access.
  * `superAdminOnly` (*boolean*, *optional*): Whether the command requires superadmin access.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic command
lia.command.add("hello", {
    desc = "Says hello to the player",
    onRun = function(client, arguments)
        client:ChatPrint("Hello, " .. client:Name() .. "!")
    end
})

-- Register a command with arguments
lia.command.add("give_money", {
    arguments = {
        {name = "target", type = "player"},
        {name = "amount", type = "number"}
    },
    desc = "Gives money to a player",
    privilege = "giveMoney",
    onRun = function(client, arguments)
        local target = arguments[1]
        local amount = arguments[2]
        if IsValid(target) and isnumber(amount) then
            target:addMoney(amount)
            client:ChatPrint("Gave " .. amount .. " money to " .. target:Name())
        end
    end
})

-- Register an admin-only command
lia.command.add("kick_player", {
    arguments = {
        {name = "target", type = "player"},
        {name = "reason", type = "string", optional = true}
    },
    desc = "Kicks a player from the server",
    adminOnly = true,
    onRun = function(client, arguments)
        local target = arguments[1]
        local reason = arguments[2] or "No reason provided"
        if IsValid(target) then
            target:Kick(reason)
            client:ChatPrint("Kicked " .. target:Name() .. " for: " .. reason)
        end
    end
})

-- Register a command with aliases
lia.command.add("teleport", {
    arguments = {
        {name = "target", type = "player"},
        {name = "destination", type = "player"}
    },
    desc = "Teleports a player to another player",
    alias = {"tp", "goto"},
    privilege = "teleport",
    onRun = function(client, arguments)
        local target = arguments[1]
        local destination = arguments[2]
        if IsValid(target) and IsValid(destination) then
            target:SetPos(destination:GetPos())
            client:ChatPrint("Teleported " .. target:Name() .. " to " .. destination:Name())
        end
    end
})
```

---

### lia.command.hasAccess

**Purpose**

Checks if a player has access to a specific command.

**Parameters**

* `client` (*Player*): The player to check access for.
* `command` (*string*): The command name to check.
* `data` (*table*, *optional*): The command data table. If nil, retrieves from command list.

**Returns**

* `hasAccess` (*boolean*): True if the player has access, false otherwise.
* `privilegeName` (*string*): The name of the required privilege.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if a player has access to a command
local hasAccess, privilege = lia.command.hasAccess(client, "give_money")
if hasAccess then
    print("Player can use give_money command")
else
    print("Player needs privilege: " .. privilege)
end

-- Use in command validation
local function canUseCommand(client, command)
    local hasAccess, privilege = lia.command.hasAccess(client, command)
    if not hasAccess then
        client:ChatPrint("You need the privilege: " .. privilege)
        return false
    end
    return true
end

-- Check access before showing command in UI
local function updateCommandList()
    for cmdName, cmdData in pairs(lia.command.list) do
        local hasAccess = lia.command.hasAccess(LocalPlayer(), cmdName, cmdData)
        if hasAccess then
            -- Show command in UI
        end
    end
end
```

---

### lia.command.extractArgs

**Purpose**

Extracts arguments from a command string, handling quoted strings properly.

**Parameters**

* `text` (*string*): The command text to extract arguments from.

**Returns**

* `arguments` (*table*): A table of extracted arguments.

**Realm**

Shared.

**Example Usage**

```lua
-- Extract arguments from command text
local args = lia.command.extractArgs('give_money "John Doe" 1000')
print("Arguments: " .. table.concat(args, ", ")) -- "give_money", "John Doe", "1000"

-- Handle quoted strings
local args = lia.command.extractArgs('say "Hello world" with spaces')
print("Arguments: " .. table.concat(args, ", ")) -- "say", "Hello world", "with", "spaces"

-- Use in custom command parsing
local function parseCustomCommand(text)
    local args = lia.command.extractArgs(text)
    local command = args[1]
    table.remove(args, 1) -- Remove command name
    return command, args
end
```

---

### lia.command.run

**Purpose**

Executes a command for a specific client.

**Parameters**

* `client` (*Player*): The client to run the command for.
* `command` (*string*): The command name to run.
* `arguments` (*table*, *optional*): The command arguments.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Run a command for a player
    lia.command.run(client, "hello")

    -- Run a command with arguments
    lia.command.run(client, "give_money", {target, 1000})

    -- Use in admin panel
    local function executeCommand(command, args)
        local target = args[1]
        if IsValid(target) then
            lia.command.run(target, command, args)
        end
    end
end
```

---

### lia.command.parse

**Purpose**

Parses and executes a command from text input.

**Parameters**

* `client` (*Player*): The client who sent the command.
* `text` (*string*): The command text to parse.
* `realCommand` (*string*, *optional*): The actual command name if known.
* `arguments` (*table*, *optional*): Pre-parsed arguments.

**Returns**

* `success` (*boolean*): True if a command was parsed and executed, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Parse and execute a command
    local success = lia.command.parse(client, "/give_money John 1000")
    if success then
        print("Command executed successfully")
    end

    -- Use in PlayerSay hook
    hook.Add("PlayerSay", "CommandHandler", function(ply, text)
        if text:sub(1, 1) == "/" then
            local success = lia.command.parse(ply, text)
            if success then
                return "" -- Suppress the message
            end
        end
    end)

    -- Parse with pre-parsed arguments
    local args = {"John", "1000"}
    lia.command.parse(client, "/give_money", "give_money", args)
end
```

---

### lia.command.openArgumentPrompt

**Purpose**

Opens a GUI prompt for entering command arguments.

**Parameters**

* `cmdKey` (*string*): The command key to prompt for.
* `missing` (*table*, *optional*): Missing argument names.
* `prefix` (*table*, *optional*): Pre-filled argument values.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
if CLIENT then
    -- Open argument prompt for a command
    lia.command.openArgumentPrompt("give_money")

    -- Open prompt with missing arguments
    lia.command.openArgumentPrompt("kick_player", {"target", "reason"})

    -- Open prompt with pre-filled values
    local prefix = {"John"}
    lia.command.openArgumentPrompt("give_money", {"amount"}, prefix)
end
```

---

### lia.command.send

**Purpose**

Sends a command to the server for execution.

**Parameters**

* `command` (*string*): The command name to send.
* `...` (*any*): Command arguments.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
if CLIENT then
    -- Send a simple command
    lia.command.send("hello")

    -- Send a command with arguments
    lia.command.send("give_money", target, 1000)

    -- Send a command with multiple arguments
    lia.command.send("kick_player", target, "Rule violation")

    -- Use in custom UI
    local function executeCommand()
        local target = targetComboBox:GetSelected()
        local amount = tonumber(amountEntry:GetValue())
        if target and amount then
            lia.command.send("give_money", target, amount)
        end
    end
end
```