# Configuration Library

This page documents the functions for working with configuration management and settings.

---

## Overview

The configuration library (`lia.config`) provides a comprehensive system for managing server and client configuration settings in the Lilia framework. It handles configuration registration, loading, saving, networking, and provides a GUI interface for configuration management. The library supports various data types including booleans, numbers, colors, tables, and generic values with validation and callbacks.

---

### lia.config.add

**Purpose**

Registers a new configuration option with specified properties and validation.

**Parameters**

* `key` (*string*): The unique configuration key.
* `name` (*string*): The display name for the configuration.
* `value` (*any*): The default value for the configuration.
* `callback` (*function*): Optional callback function when the value changes.
* `data` (*table*): Configuration data table with properties and validation.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Add a basic configuration option
lia.config.add("MaxPlayers", "Maximum Players", 32, nil, {
    desc = "Maximum number of players allowed on the server",
    category = "Server Settings",
    type = "Int",
    min = 1,
    max = 128
})

-- Add a configuration with callback
lia.config.add("WalkSpeed", "Walk Speed", 130, function(oldValue, newValue)
    for _, ply in player.Iterator() do
        ply:SetWalkSpeed(newValue)
    end
end, {
    desc = "Default walking speed for players",
    category = "Character Settings",
    type = "Int",
    min = 50,
    max = 300
})

-- Add a color configuration
lia.config.add("ThemeColor", "Theme Color", Color(100, 150, 200), nil, {
    desc = "Main theme color for the interface",
    category = "Visual Settings",
    type = "Color"
})

-- Add a boolean configuration
lia.config.add("EnableChat", "Enable Chat", true, function(oldValue, newValue)
    if newValue then
        print("Chat enabled")
    else
        print("Chat disabled")
    end
end, {
    desc = "Enable or disable chat system",
    category = "Chat Settings",
    type = "Boolean"
})

-- Add a table configuration with options
lia.config.add("Language", "Server Language", "English", nil, {
    desc = "Server language setting",
    category = "General Settings",
    type = "Table",
    options = {"English", "Spanish", "French", "German"}
})
```

---

### lia.config.getOptions

**Purpose**

Gets the available options for a configuration that has a table type.

**Parameters**

* `key` (*string*): The configuration key to get options for.

**Returns**

* `options` (*table*): Table of available options for the configuration.

**Realm**

Shared.

**Example Usage**

```lua
-- Get options for a configuration
local options = lia.config.getOptions("Language")
for _, option in ipairs(options) do
    print("Available option: " .. option)
end

-- Use options in a dropdown
local function createLanguageDropdown()
    local options = lia.config.getOptions("Language")
    local dropdown = vgui.Create("DComboBox")
    
    for _, option in ipairs(options) do
        dropdown:AddChoice(option)
    end
    
    return dropdown
end

-- Check if configuration has options
local function hasConfigurationOptions(key)
    local options = lia.config.getOptions(key)
    return #options > 0
end

-- Get options with validation
local function getValidatedOptions(key)
    local options = lia.config.getOptions(key)
    if not options or #options == 0 then
        print("No options available for configuration: " .. key)
        return {}
    end
    return options
end
```

---

### lia.config.setDefault

**Purpose**

Sets the default value for a configuration option.

**Parameters**

* `key` (*string*): The configuration key.
* `value` (*any*): The new default value.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Set default value for a configuration
lia.config.setDefault("MaxPlayers", 64)

-- Set default value in module initialization
hook.Add("Initialize", "SetModuleDefaults", function()
    lia.config.setDefault("ModuleEnabled", true)
    lia.config.setDefault("ModuleValue", 100)
end)

-- Set default value with validation
local function setDefaultSafely(key, value)
    local config = lia.config.stored[key]
    if config then
        lia.config.setDefault(key, value)
        print("Default value set for " .. key)
    else
        print("Configuration not found: " .. key)
    end
end

-- Reset configuration to default
local function resetToDefault(key)
    local config = lia.config.stored[key]
    if config then
        lia.config.setDefault(key, config.default)
    end
end
```

---

### lia.config.forceSet

**Purpose**

Forces a configuration value without triggering callbacks or saving.

**Parameters**

* `key` (*string*): The configuration key.
* `value` (*any*): The new value to set.
* `noSave` (*boolean*): Optional parameter to skip saving.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Force set a configuration value
lia.config.forceSet("MaxPlayers", 64)

-- Force set without saving
lia.config.forceSet("TemporaryValue", 100, true)

-- Force set in bulk
local function forceSetMultiple(configs)
    for key, value in pairs(configs) do
        lia.config.forceSet(key, value, true)
    end
    lia.config.save() -- Save all at once
end

-- Force set with validation
local function forceSetValidated(key, value)
    local config = lia.config.stored[key]
    if config and config.data then
        if config.data.min and value < config.data.min then
            value = config.data.min
        elseif config.data.max and value > config.data.max then
            value = config.data.max
        end
    end
    
    lia.config.forceSet(key, value)
end
```

---

### lia.config.set

**Purpose**

Sets a configuration value and triggers callbacks and networking.

**Parameters**

* `key` (*string*): The configuration key.
* `value` (*any*): The new value to set.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Set a configuration value
lia.config.set("MaxPlayers", 64)

-- Set configuration in a command
lia.command.add("setmaxplayers", {
    desc = "Set maximum players",
    arguments = {
        {name = "amount", type = "number"}
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local amount = tonumber(arguments[1])
        if amount and amount > 0 and amount <= 128 then
            lia.config.set("MaxPlayers", amount)
            client:ChatPrint("Maximum players set to " .. amount)
        else
            client:ChatPrint("Invalid amount. Must be between 1 and 128.")
        end
    end
})

-- Set configuration with validation
local function setConfigSafely(key, value)
    local config = lia.config.stored[key]
    if not config then
        print("Configuration not found: " .. key)
        return false
    end
    
    -- Validate value based on type
    if config.data and config.data.type == "Int" then
        value = math.floor(tonumber(value) or 0)
        if config.data.min and value < config.data.min then
            value = config.data.min
        elseif config.data.max and value > config.data.max then
            value = config.data.max
        end
    end
    
    lia.config.set(key, value)
    return true
end

-- Set multiple configurations
local function setMultipleConfigs(configs)
    for key, value in pairs(configs) do
        lia.config.set(key, value)
    end
end
```

---

### lia.config.get

**Purpose**

Gets the current value of a configuration option.

**Parameters**

* `key` (*string*): The configuration key to get.
* `default` (*any*): Optional default value if configuration not found.

**Returns**

* `value` (*any*): The current configuration value.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a configuration value
local maxPlayers = lia.config.get("MaxPlayers")
print("Maximum players: " .. maxPlayers)

-- Get configuration with default
local walkSpeed = lia.config.get("WalkSpeed", 130)

-- Get configuration in a function
local function getServerSettings()
    return {
        maxPlayers = lia.config.get("MaxPlayers"),
        walkSpeed = lia.config.get("WalkSpeed"),
        runSpeed = lia.config.get("RunSpeed"),
        enableChat = lia.config.get("EnableChat")
    }
end

-- Get configuration with validation
local function getConfigSafely(key, default)
    local value = lia.config.get(key, default)
    if value == nil then
        print("Configuration not found: " .. key)
        return default
    end
    return value
end

-- Get all configuration values
local function getAllConfigs()
    local configs = {}
    for key, _ in pairs(lia.config.stored) do
        configs[key] = lia.config.get(key)
    end
    return configs
end
```

---

### lia.config.load

**Purpose**

Loads configuration values from the database.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Load configurations on server start
hook.Add("Initialize", "LoadConfigurations", function()
    lia.config.load()
end)

-- Load configurations with callback
lia.config.load()
hook.Add("InitializedConfig", "ConfigLoaded", function()
    print("All configurations loaded successfully")
end)

-- Load configurations in module
local function loadModuleConfigs()
    lia.config.load()
    print("Module configurations loaded")
end

-- Load configurations with error handling
local function loadConfigsSafely()
    local success, err = pcall(lia.config.load)
    if not success then
        print("Error loading configurations: " .. tostring(err))
    end
end
```

---

### lia.config.getChangedValues

**Purpose**

Gets all configuration values that differ from their defaults (server-side only).

**Returns**

* `changedValues` (*table*): Table of changed configuration values.

**Realm**

Server.

**Example Usage**

```lua
-- Get changed configuration values
local changed = lia.config.getChangedValues()
print("Changed configurations: " .. table.Count(changed))

-- Check if specific configuration changed
local function hasConfigChanged(key)
    local changed = lia.config.getChangedValues()
    return changed[key] ~= nil
end

-- Get changed configurations for backup
local function backupChangedConfigs()
    local changed = lia.config.getChangedValues()
    local backup = {}
    
    for key, value in pairs(changed) do
        backup[key] = {
            value = value,
            timestamp = os.time()
        }
    end
    
    return backup
end

-- Display changed configurations
local function displayChangedConfigs()
    local changed = lia.config.getChangedValues()
    for key, value in pairs(changed) do
        print(key .. " = " .. tostring(value))
    end
end
```

---

### lia.config.send

**Purpose**

Sends configuration values to clients (server-side only).

**Parameters**

* `client` (*Player*): Optional specific client to send to.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Send configurations to all clients
lia.config.send()

-- Send configurations to specific client
lia.config.send(client)

-- Send configurations to newly connected player
hook.Add("PlayerInitialSpawn", "SendConfigs", function(ply)
    lia.config.send(ply)
end)

-- Send configurations to admin players
local function sendConfigsToAdmins()
    for _, ply in player.Iterator() do
        if ply:IsAdmin() then
            lia.config.send(ply)
        end
    end
end

-- Send configurations with delay
local function sendConfigsDelayed(client, delay)
    timer.Simple(delay, function()
        if IsValid(client) then
            lia.config.send(client)
        end
    end)
end
```

---

### lia.config.save

**Purpose**

Saves configuration values to the database (server-side only).

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Save configurations
lia.config.save()

-- Save configurations after changes
local function setAndSave(key, value)
    lia.config.set(key, value)
    lia.config.save()
end

-- Save configurations with error handling
local function saveConfigsSafely()
    local success, err = pcall(lia.config.save)
    if not success then
        print("Error saving configurations: " .. tostring(err))
    else
        print("Configurations saved successfully")
    end
end

-- Auto-save configurations
timer.Create("AutoSaveConfigs", 300, 0, function()
    lia.config.save()
end)

-- Save configurations on server shutdown
hook.Add("ShutDown", "SaveConfigsOnShutdown", function()
    lia.config.save()
end)
```

---

### lia.config.reset

**Purpose**

Resets all configurations to their default values (server-side only).

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Reset all configurations
lia.config.reset()

-- Reset configurations in a command
lia.command.add("resetconfigs", {
    desc = "Reset all configurations to defaults",
    adminOnly = true,
    onRun = function(client)
        lia.config.reset()
        client:ChatPrint("All configurations reset to defaults")
    end
})

-- Reset specific configuration category
local function resetConfigCategory(category)
    for key, config in pairs(lia.config.stored) do
        if config.category == category then
            config.value = config.default
            if config.callback then
                config.callback(config.value, config.default)
            end
        end
    end
    lia.config.save()
    lia.config.send()
end

-- Reset configurations with confirmation
local function resetConfigsWithConfirmation(client)
    client:ChatPrint("Are you sure you want to reset all configurations? Type 'yes' to confirm.")
    
    hook.Add("PlayerSay", "ConfigResetConfirmation", function(ply, text)
        if ply == client and text:lower() == "yes" then
            lia.config.reset()
            ply:ChatPrint("Configurations reset to defaults")
            hook.Remove("PlayerSay", "ConfigResetConfirmation")
        end
    end)
end
```
