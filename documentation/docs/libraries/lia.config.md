# Config Library

This page documents the functions for working with configuration system and settings management.

---

## Overview

The config library (`lia.config`) provides a comprehensive configuration management system for the Lilia framework. It handles configuration registration, loading, saving, and synchronization between client and server. The library supports various data types including booleans, numbers, colors, tables, and generic strings with validation, callbacks, and networking capabilities.

---

### lia.config.add

**Purpose**

Registers a new configuration option with specified properties and validation.

**Parameters**

* `key` (*string*): The unique key for the configuration option.
* `name` (*string*): The display name for the configuration.
* `value` (*any*): The default value for the configuration.
* `callback` (*function*): Optional callback function to execute when value changes.
* `data` (*table*): Configuration data table containing:
  * `type` (*string*): Data type (Boolean, Int, Float, Color, Table, Generic).
  * `desc` (*string*): Description of the configuration.
  * `category` (*string*): Category for organizing configurations.
  * `min` (*number*): Minimum value for numeric types.
  * `max` (*number*): Maximum value for numeric types.
  * `options` (*table*): Available options for Table type.
  * `noNetworking` (*boolean*): Whether to skip network synchronization.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Add a basic boolean configuration
lia.config.add("EnableFeature", "Enable Feature", true, nil, {
    desc = "Enable or disable a feature",
    category = "General",
    type = "Boolean"
})

-- Add a numeric configuration with validation
lia.config.add("MaxPlayers", "Maximum Players", 32, nil, {
    desc = "Maximum number of players allowed",
    category = "Server",
    type = "Int",
    min = 1,
    max = 64
})

-- Add a float configuration
lia.config.add("WalkSpeed", "Walk Speed", 130.0, function(oldValue, newValue)
    for _, ply in pairs(player.GetAll()) do
        ply:SetWalkSpeed(newValue)
    end
end, {
    desc = "Player walk speed",
    category = "Character",
    type = "Float",
    min = 50,
    max = 300
})

-- Add a color configuration
lia.config.add("ThemeColor", "Theme Color", Color(37, 116, 108), nil, {
    desc = "Main theme color for the UI",
    category = "Visuals",
    type = "Color"
})

-- Add a table configuration with options
lia.config.add("Language", "Language", "English", nil, {
    desc = "Server language",
    category = "General",
    type = "Table",
    options = {"English", "Spanish", "French", "German"}
})

-- Add a generic string configuration
lia.config.add("ServerName", "Server Name", "My Server", nil, {
    desc = "Name of the server",
    category = "Server",
    type = "Generic"
})

-- Add configuration with callback
lia.config.add("VoiceEnabled", "Voice Chat", true, function(oldValue, newValue)
    hook.Run("VoiceToggled", newValue)
end, {
    desc = "Enable or disable voice chat",
    category = "General",
    type = "Boolean"
})
```

---

### lia.config.getOptions

**Purpose**

Gets the available options for a configuration with dynamic option generation.

**Parameters**

* `key` (*string*): The configuration key to get options for.

**Returns**

* `options` (*table*): Table of available options.

**Realm**

Shared.

**Example Usage**

```lua
-- Get options for a configuration
local options = lia.config.getOptions("Language")
print("Available languages: " .. table.concat(options, ", "))

-- Get options with validation
local options = lia.config.getOptions("DermaSkin")
if #options > 0 then
    print("Available skins: " .. table.concat(options, ", "))
else
    print("No options available")
end

-- Use in UI creation
local function createLanguageSelector()
    local options = lia.config.getOptions("Language")
    local combo = vgui.Create("DComboBox")
    
    for _, option in ipairs(options) do
        combo:AddChoice(option)
    end
    
    return combo
end

-- Get options for dynamic configuration
local function getDynamicOptions()
    local options = lia.config.getOptions("DynamicConfig")
    return options or {}
end
```

---

### lia.config.setDefault

**Purpose**

Sets the default value for a configuration option.

**Parameters**

* `key` (*string*): The configuration key to set default for.
* `value` (*any*): The new default value.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Set default value for a configuration
lia.config.setDefault("MaxPlayers", 64)

-- Set default with validation
if lia.config.stored["WalkSpeed"] then
    lia.config.setDefault("WalkSpeed", 150)
end

-- Set default for multiple configurations
local defaults = {
    MaxPlayers = 32,
    WalkSpeed = 130,
    RunSpeed = 275
}

for key, value in pairs(defaults) do
    lia.config.setDefault(key, value)
end
```

---

### lia.config.forceSet

**Purpose**

Forces a configuration value without triggering callbacks or saving.

**Parameters**

* `key` (*string*): The configuration key to set.
* `value` (*any*): The value to set.
* `noSave` (*boolean*): Whether to skip saving to database.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Force set a configuration value
lia.config.forceSet("MaxPlayers", 64)

-- Force set without saving
lia.config.forceSet("TemporaryValue", "temp", true)

-- Force set with validation
if lia.config.stored["WalkSpeed"] then
    lia.config.forceSet("WalkSpeed", 150)
end

-- Force set multiple values
local values = {
    MaxPlayers = 32,
    WalkSpeed = 130,
    RunSpeed = 275
}

for key, value in pairs(values) do
    lia.config.forceSet(key, value)
end
```

---

### lia.config.set

**Purpose**

Sets a configuration value with proper validation, callbacks, and networking.

**Parameters**

* `key` (*string*): The configuration key to set.
* `value` (*any*): The value to set.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Set a configuration value
lia.config.set("MaxPlayers", 32)

-- Set with validation
if isnumber(value) and value > 0 then
    lia.config.set("WalkSpeed", value)
end

-- Set multiple configurations
local configs = {
    MaxPlayers = 32,
    WalkSpeed = 130,
    RunSpeed = 275,
    VoiceEnabled = true
}

for key, value in pairs(configs) do
    lia.config.set(key, value)
end

-- Set in command
lia.command.add("setconfig", {
    arguments = {
        {name = "key", type = "string"},
        {name = "value", type = "string"}
    },
    onRun = function(client, arguments)
        local key = arguments[1]
        local value = arguments[2]
        
        if lia.config.stored[key] then
            lia.config.set(key, value)
            client:ChatPrint("Configuration updated: " .. key)
        else
            client:ChatPrint("Configuration not found: " .. key)
        end
    end
})
```

---

### lia.config.get

**Purpose**

Gets the current value of a configuration option.

**Parameters**

* `key` (*string*): The configuration key to get.
* `default` (*any*): Default value to return if configuration not found.

**Returns**

* `value` (*any*): The configuration value or default.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a configuration value
local maxPlayers = lia.config.get("MaxPlayers")
print("Max players: " .. maxPlayers)

-- Get with default value
local walkSpeed = lia.config.get("WalkSpeed", 130)
print("Walk speed: " .. walkSpeed)

-- Get boolean configuration
local voiceEnabled = lia.config.get("VoiceEnabled", false)
if voiceEnabled then
    print("Voice chat is enabled")
end

-- Get color configuration
local themeColor = lia.config.get("ThemeColor", Color(255, 255, 255))
print("Theme color: " .. tostring(themeColor))

-- Get configuration in hook
hook.Add("PlayerSpawn", "ApplyConfig", function(ply)
    local walkSpeed = lia.config.get("WalkSpeed", 130)
    local runSpeed = lia.config.get("RunSpeed", 275)
    
    ply:SetWalkSpeed(walkSpeed)
    ply:SetRunSpeed(runSpeed)
end)

-- Get multiple configurations
local function getServerSettings()
    return {
        maxPlayers = lia.config.get("MaxPlayers", 32),
        walkSpeed = lia.config.get("WalkSpeed", 130),
        runSpeed = lia.config.get("RunSpeed", 275),
        voiceEnabled = lia.config.get("VoiceEnabled", true)
    }
end
```

---

### lia.config.load

**Purpose**

Loads configuration values from the database.

**Parameters**

*None*

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Load configurations on server start
lia.config.load()

-- Load with callback
lia.config.load()
hook.Add("InitializedConfig", "MyMod", function()
    print("Configurations loaded successfully")
end)

-- Load in gamemode initialization
hook.Add("Initialize", "LoadConfig", function()
    lia.config.load()
end)
```

---

### lia.config.getChangedValues

**Purpose**

Gets all configuration values that differ from their defaults.

**Parameters**

*None*

**Returns**

* `changedValues` (*table*): Table of changed configuration values.

**Realm**

Server.

**Example Usage**

```lua
-- Get changed values
local changed = lia.config.getChangedValues()
print("Changed configurations: " .. table.Count(changed))

-- Get changed values for saving
local changed = lia.config.getChangedValues()
if table.Count(changed) > 0 then
    print("Saving " .. table.Count(changed) .. " changed configurations")
end

-- Use in admin command
lia.command.add("configstatus", {
    onRun = function(client)
        local changed = lia.config.getChangedValues()
        client:ChatPrint("Changed configurations: " .. table.Count(changed))
        
        for key, value in pairs(changed) do
            client:ChatPrint(key .. " = " .. tostring(value))
        end
    end
})
```

---

### lia.config.send

**Purpose**

Sends configuration values to clients.

**Parameters**

* `client` (*Player*): Optional specific client to send to (nil = all clients).

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Send to all clients
lia.config.send()

-- Send to specific client
lia.config.send(client)

-- Send after configuration change
lia.config.set("MaxPlayers", 32)
lia.config.send()

-- Send in hook
hook.Add("PlayerInitialSpawn", "SendConfig", function(ply)
    lia.config.send(ply)
end)

-- Send with validation
if IsValid(client) then
    lia.config.send(client)
end
```

---

### lia.config.save

**Purpose**

Saves configuration values to the database.

**Parameters**

*None*

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Save configurations
lia.config.save()

-- Save after changes
lia.config.set("MaxPlayers", 32)
lia.config.save()

-- Save in hook
hook.Add("ShutDown", "SaveConfig", function()
    lia.config.save()
end)

-- Save with validation
local changed = lia.config.getChangedValues()
if table.Count(changed) > 0 then
    lia.config.save()
    print("Configurations saved")
end
```

---

### lia.config.reset

**Purpose**

Resets all configuration values to their defaults.

**Parameters**

*None*

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Reset all configurations
lia.config.reset()

-- Reset in command
lia.command.add("resetconfig", {
    onRun = function(client)
        lia.config.reset()
        client:ChatPrint("All configurations reset to defaults")
    end
})

-- Reset with confirmation
lia.command.add("resetconfigconfirm", {
    onRun = function(client)
        Derma_Query("Reset all configurations to defaults?", "Confirm Reset", "Yes", function()
            lia.config.reset()
            client:ChatPrint("Configurations reset")
        end, "No")
    end
})
```
```