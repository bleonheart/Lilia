--[[
    Folder: Libraries
    File: config.md
]]
--[[
    Configuration

    Comprehensive user-configurable settings management system for the Lilia framework.
]]
--[[
    Overview:
        The configuration library provides comprehensive functionality for managing user-configurable settings in the Lilia framework. It handles the creation, storage, retrieval, and persistence of various types of options including boolean toggles, numeric sliders, color pickers, text inputs, and dropdown selections. The library operates on both client and server sides, with automatic persistence to JSON files and optional networking capabilities for server-side options. It includes a complete user interface system for displaying and modifying options through the configuration menu, with support for categories, visibility conditions, and real-time updates. The library ensures that all user preferences are maintained across sessions and provides hooks for modules to react to option changes.
]]
lia.config = lia.config or {}
lia.config.stored = lia.config.stored or {}
lia.config._lastSyncedValues = lia.config._lastSyncedValues or {}
lia.config._initialized = lia.config._initialized or false
lia.config._trace = false
--[[
    Purpose:
        Register a callback to be executed when the configuration system is initialized.

    When Called:
        During module initialization to ensure config is ready before accessing values.

    Parameters:
        callback (function)
            Function to execute when config is initialized.

    Realm:
        Shared

    Example Usage:
        ```lua
        lia.config.onInitialized(function()
            print("Config is ready!")
        end)
        ```
]]
function lia.config.onInitialized(callback)
    if not isfunction(callback) then return end
    if lia.config._initialized == true then
        callback()
        return
    end

    hook.Add("InitializedConfig", tostring(callback), function() callback() end)
end

local function cfgNormalizeValue(v)
    if IsColor(v) then
        return {
            r = v.r,
            g = v.g,
            b = v.b,
            a = v.a
        }
    end
    return v
end

local function cfgCoerceValue(key, value)
    local config = lia.config and lia.config.stored and lia.config.stored[key]
    if not config then return value end
    local configType = (config.data and config.data.type) or config.type
    if configType == "Generic" or isstring(config.default) then
        if value == nil then return "" end
        if isvector(value) or isangle(value) then return "" end
        if not isstring(value) then return tostring(value) end
    end

    if configType == "Color" and istable(value) then return Color(value.r, value.g, value.b, value.a) end
    return value
end

local function cfgValuesEqual(a, b)
    a = cfgNormalizeValue(a)
    b = cfgNormalizeValue(b)
    if istable(a) and istable(b) then return util.TableToJSON(a) == util.TableToJSON(b) end
    return a == b
end

--[[
    Purpose:
        Register a config entry with defaults, UI metadata, and optional callback.

    When Called:
        During schema/module initialization to expose server-stored configuration.

    Parameters:
        key (string)
            Unique identifier for the config entry.
        name (string)
            Display text or localization key for UI.
        value (any)
            Default value; type inferred when data.type is omitted.
        callback (function|nil)
            Invoked server-side as callback(oldValue, newValue) after set().
        data (table)
            Fields such as type, desc, category, options/optionsFunc, noNetworking, etc.
    Realm:
        Shared

    Example Usage:
        ```lua
        lia.config.add("MaxThirdPersonDistance", "maxThirdPersonDistance", 100, function(old, new)
            lia.option.set("thirdPersonDistance", math.min(lia.option.get("thirdPersonDistance", new), new))
        end, {category = "Lilia", type = "Int", min = 10, max = 200})
        ```
]]
function lia.config.add(key, name, value, callback, data)
    assert(isstring(key), string.format("Expected config key to be string, got %s", type(key)))
    assert(istable(data), string.format("Expected config data to be a table, got %s", type(data)))
    local t = type(value)
    local configType = t == "boolean" and "Boolean" or t == "number" and "Number" or t == "table" and (value.r and value.g and value.b and "Color" or "Table") or "Generic"
    local validTypes = {
        Boolean = true,
        Int = true,
        Float = true,
        Number = true,
        Color = true,
        Table = true,
        Generic = true
    }

    if not data.type or not validTypes[data.type] then data.type = configType end
    local oldConfig = lia.config.stored[key]
    local savedValue = oldConfig and oldConfig.value or value
    if istable(data.options) then
        for k, v in pairs(data.options) do
            if isstring(v) then data.options[k] = L(v) end
        end
    elseif isfunction(data.options) then
        data.optionsFunc = data.options
        data.options = nil
    end

    data.desc = isstring(data.desc) and L(data.desc) or data.desc
    data.category = isstring(data.category) and L(data.category) or data.category
    lia.config.stored[key] = {
        name = isstring(name) and L(name) or name or key,
        data = data,
        value = savedValue,
        default = value,
        desc = data.desc,
        category = data.category or "Character",
        noNetworking = data.noNetworking or false,
        callback = callback
    }
end

--[[
    Purpose:
        Resolve a config entry's selectable options, static list or generated.

    When Called:
        Before rendering dropdown-type configs or validating submitted values.

    Parameters:
        key (string)
            Config key to resolve options for.

    Returns:
        table
            Options array or key/value table; empty when unavailable.

    Realm:
        Shared

    Example Usage:
        ```lua
        local opts = lia.config.getOptions("Theme")
        ```
]]
function lia.config.getOptions(key)
    local config = lia.config.stored[key]
    if not config then return {} end
    if config.data.optionsFunc then
        local success, result = pcall(config.data.optionsFunc)
        if success and istable(result) then
            for k, v in pairs(result) do
                if isstring(v) then result[k] = L(v) end
            end
            return result
        else
            return {}
        end
    elseif istable(config.data.options) then
        return config.data.options
    end
    return {}
end

--[[
    Purpose:
        Override the default value for an already registered config entry.

    When Called:
        During migrations, schema overrides, or backward-compatibility fixes.

    Parameters:
        key (string)
            Config key to override.
        value (any)
            New default value.
    Realm:
        Shared

    Example Usage:
        ```lua
        lia.config.setDefault("StartingMoney", 300)
        ```
]]
function lia.config.setDefault(key, value)
    local config = lia.config.stored[key]
    if config then config.default = value end
end

--[[
    Purpose:
        Force-set a config value and fire update hooks without networking.

    When Called:
        Runtime adjustments (admin tools/commands) or hot reload scenarios.

    Parameters:
        key (string)
            Config key to change.
        value (any)
            Value to assign.
        noSave (boolean|nil)
            When true, skip persisting to disk.
    Realm:
        Shared

    Example Usage:
        ```lua
        lia.config.forceSet("MaxCharacters", 10, false)
        ```
]]
function lia.config.forceSet(key, value, noSave)
    local config = lia.config.stored[key]
    if config then
        local oldValue = config.value
        config.value = value
        hook.Run("OnConfigUpdated", key, oldValue, value)
    end

    if not noSave then lia.config.save() end
end

--[[
    Purpose:
        Set a config value, fire update hooks, run server callbacks, network to clients, and persist.

    When Called:
        Through admin tools/commands or internal code updating configuration.

    Parameters:
        key (string)
            Config key to change.
        value (any)
            Value to assign and broadcast.
    Realm:
        Shared

    Example Usage:
        ```lua
        lia.config.set("RunSpeed", 420)
        ```
]]
function lia.config.set(key, value)
    local config = lia.config.stored[key]
    if config then
        value = cfgCoerceValue(key, value)
        local oldValue = config.value
        config.value = value
        hook.Run("OnConfigUpdated", key, oldValue, value)
        if SERVER then
            if not config.noNetworking then
                net.Start("liaCfgSet")
                net.WriteString(key)
                net.WriteString(config.name or key)
                net.WriteType(value)
                net.Broadcast()
            end

            if config.callback then config.callback(oldValue, value) end
            lia.config.save()
        end

        if CLIENT and oldValue ~= value then LocalPlayer():notifySuccess("Config '" .. (config.name or key) .. "' updated successfully") end
    end
end

--[[
    Purpose:
        Retrieve a config value with fallback to its stored default or a provided default.

    When Called:
        Anywhere configuration influences gameplay or UI logic.

    Parameters:
        key (string)
            Config key to read.
        default (any)
            Optional fallback when no stored value or default exists.

    Returns:
        any
            Stored value, default value, or supplied fallback.

    Realm:
        Shared

    Example Usage:
        ```lua
        local walkSpeed = lia.config.get("WalkSpeed", 200)
        ```
]]
function lia.config.get(key, default)
    local config = lia.config.stored[key]
    if config then
        if config.value ~= nil then
            if istable(config.value) and config.value.r and config.value.g and config.value.b then config.value = Color(config.value.r, config.value.g, config.value.b, config.value.a or 255) end
            return config.value
        elseif config.default ~= nil then
            return config.default
        end
    end

    if key == "Color" and CLIENT then return lia.color.getMainColor() end
    return default
end

--[[
    Purpose:
        Load config values from JSON files (server) or request them from the server (client).

    When Called:
        On initialization to hydrate lia.config.stored from JSON file storage.

    Parameters:
        None

    Realm:
        Shared

    Example Usage:
        ```lua
        hook.Add("Initialize", "LoadLiliaConfig", lia.config.load)
        ```
]]
function lia.config.load()
    if SERVER then
        local configData = lia.data.get("config", {})
        local existing = {}
        for cfgKey, cfgValue in pairs(configData) do
            lia.config.stored[cfgKey] = lia.config.stored[cfgKey] or {}
            cfgValue = cfgCoerceValue(cfgKey, cfgValue)
            if cfgValue == nil or cfgValue == "" then
                lia.config.stored[cfgKey].value = lia.config.stored[cfgKey].default
            else
                lia.config.stored[cfgKey].value = cfgValue
                existing[cfgKey] = true
            end
        end

        local defaultedCount = 0
        for k, v in pairs(lia.config.stored) do
            if not existing[k] then
                lia.config.stored[k].value = v.default
                defaultedCount = defaultedCount + 1
            end
        end

        for key, config in pairs(lia.config.stored) do
            if config.value ~= nil then
                if istable(config.value) then
                    lia.config._lastSyncedValues[key] = util.TableToJSON(config.value) and util.JSONToTable(util.TableToJSON(config.value)) or config.value
                else
                    lia.config._lastSyncedValues[key] = config.value
                end
            end
        end

        lia.config._initialized = true
        hook.Run("InitializedConfig")
    else
        net.Start("liaCfgList")
        net.SendToServer()
    end
end

if CLIENT then
    lia.config._uiBindings = lia.config._uiBindings or {}
    function lia.config._bindUI(key, panel, updater)
        if not isstring(key) or key == "" then return end
        if not IsValid(panel) or not isfunction(updater) then return end
        lia.config._uiBindings[key] = lia.config._uiBindings[key] or {}
        lia.config._uiBindings[key][panel] = updater
    end

    function lia.config._refreshBoundUI(key, value)
        local bindings = lia.config._uiBindings and lia.config._uiBindings[key]
        if not bindings then return end
        for pnl, updater in pairs(bindings) do
            if IsValid(pnl) then
                local ok = pcall(updater, value)
                if not ok then bindings[pnl] = nil end
            else
                bindings[pnl] = nil
            end
        end
    end

    net.Receive("liaCfgList", function()
        local data = net.ReadTable() or {}
        for k, v in pairs(data) do
            local stored = lia.config.stored[k]
            if stored then
                stored.value = cfgCoerceValue(k, v)
            else
                lia.config.stored[k] = lia.config.stored[k] or {}
                lia.config.stored[k].value = cfgCoerceValue(k, v)
            end
        end

        lia.config._initialized = true
        hook.Run("InitializedConfig")
    end)

    net.Receive("liaCfgSet", function()
        local key = net.ReadString()
        local _ = net.ReadString()
        local value = net.ReadType()
        local stored = lia.config.stored[key]
        local oldValue = stored and stored.value
        lia.config.stored[key] = lia.config.stored[key] or {}
        lia.config.stored[key].value = cfgCoerceValue(key, value)
        hook.Run("OnConfigUpdated", key, oldValue, lia.config.stored[key].value)
    end)

    hook.Add("OnConfigUpdated", "liaConfigRefreshUIBindings", function(key, _, value) lia.config._refreshBoundUI(key, value) end)
end

if SERVER then
    --[[
    Purpose:
        Get all configuration values that have been changed from their defaults.

    When Called:
        During config synchronization to determine what needs to be sent to clients.

    Parameters:
        includeDefaults (boolean)
            When true, includes all values even if they match defaults.

    Returns:
        table
            Key/value pairs of changed configuration entries.

    Realm:
        Server

    Example Usage:
        ```lua
        local changes = lia.config.getChangedValues()
        ```
]]
    function lia.config.getChangedValues(includeDefaults)
        local data = {}
        for k, v in pairs(lia.config.stored) do
            local isDifferent
            if includeDefaults or lia.config._lastSyncedValues[k] == nil then
                isDifferent = not cfgValuesEqual(v.default, v.value)
            else
                local lastSynced = lia.config._lastSyncedValues[k]
                isDifferent = not cfgValuesEqual(lastSynced, v.value)
            end

            if isDifferent then data[k] = cfgNormalizeValue(v.value) end
        end
        return data
    end

    --[[
    Purpose:
        Check if any configuration values have been changed from their defaults.

    When Called:
        Before sending config updates to avoid unnecessary network traffic.

    Returns:
        boolean
            True if there are changes, false otherwise.

    Realm:
        Server

    Example Usage:
        ```lua
        if lia.config.hasChanges() then
            lia.config.send()
        end
        ```
]]
    function lia.config.hasChanges()
        local changed = lia.config.getChangedValues()
        return table.Count(changed) > 0
    end

    --[[
    Purpose:
        Send configuration data to a specific client or all clients.

    When Called:
        During initial connection or when config values change.

    Parameters:
        client (Player|nil)
            Specific client to send to, or nil for all clients.

    Realm:
        Server

    Example Usage:
        ```lua
        lia.config.send() -- Send to all clients
        lia.config.send(client) -- Send to specific client
        ```
]]
    function lia.config.send(client)
        local data
        if client then
            data = lia.data.get("config", {})
        else
            data = lia.config.getChangedValues()
            if table.Count(data) == 0 then return end
        end

        local targets
        if IsValid(client) then
            targets = {client}
        else
            targets = player.GetHumans()
        end

        if not istable(targets) or #targets == 0 then return end
        for key, value in pairs(data) do
            if istable(value) then
                lia.config._lastSyncedValues[key] = util.TableToJSON(value) and util.JSONToTable(util.TableToJSON(value)) or value
            else
                lia.config._lastSyncedValues[key] = value
            end
        end

        net.Start("liaCfgList")
        net.WriteTable(data)
        net.Send(targets)
    end

    --[[
    Purpose:
        Persist configuration values to JSON file storage.

    When Called:
        After configuration changes to ensure values are saved between server restarts.

    Realm:
        Server

    Example Usage:
        ```lua
        lia.config.save()
        ```
]]
    function lia.config.save()
        local configData = {}
        for k, v in pairs(lia.config.stored) do
            if v.value ~= nil and not cfgValuesEqual(v.value, v.default) then configData[k] = cfgNormalizeValue(v.value) end
        end

        lia.data.set("config", configData, true, true)
    end

    --[[
    Purpose:
        Reset all configuration values to their defaults.

    When Called:
        During administrative operations or troubleshooting.

    Realm:
        Server

    Example Usage:
        ```lua
        lia.config.reset()
        ```
]]
    function lia.config.reset()
        for _, cfg in pairs(lia.config.stored) do
            local oldValue = cfg.value
            cfg.value = cfg.default
            if cfg.callback then cfg.callback(oldValue, cfg.default) end
        end

        lia.config.save()
        lia.config.send()
    end

    net.Receive("liaCfgList", function(_, client)
        if not IsValid(client) then return end
        lia.config.send(client)
    end)

    net.Receive("liaCfgSet", function(_, client)
        if not IsValid(client) then return end
        local key = net.ReadString()
        local name = net.ReadString()
        local value = net.ReadType()
        local config = lia.config.stored[key]
        if not config then return end
        value = cfgCoerceValue(key, value)
        if type(config.default) == type(value) and hook.Run("CanPlayerModifyConfig", client, key) ~= false then
            local oldValue = config.value
            lia.config.set(key, value)
            hook.Run("ConfigChanged", key, value, oldValue, client)
            client:notifySuccess(string.format("%s has set \\", client:Name(), name or config.name or key, tostring(value)))
        end
    end)
end

lia.config.add("MainCharacterCooldownDays", "mainCharacterCooldownDays", 0, nil, {
    category = "Core",
    type = "Int",
    min = 0,
    max = 365,
    desc = "How many days until you can change your main character again. Set to 0 to allow changes at any time."
})

lia.config.add("MoneyModel", "moneyModel", "models/props/cs_assault/Dollar.mdl", nil, {
    desc = "Defines the model used for representing money in the game.",
    category = "Core",
    type = "Generic"
})

lia.config.add("MaxMoneyEntities", "maxMoneyEntities", 3, nil, {
    desc = "Maximum number of money entities that can be dropped at once.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 50
})

lia.config.add("CurrencySymbol", "currencySymbol", "", function(newVal) lia.currency.symbol = newVal end, {
    desc = "Specifies the currency symbol used in the game.",
    category = "Core",
    type = "Generic"
})

lia.config.add("CurrencySingularName", "currencySingularName", "currencySingular", function(newVal) lia.currency.singular = L(newVal) end, {
    desc = "Singular name of the in-game currency.",
    category = "Core",
    type = "Generic"
})

lia.config.add("CurrencyPluralName", "currencyPluralName", "currencyPlural", function(newVal) lia.currency.plural = L(newVal) end, {
    desc = "Plural name of the in-game currency.",
    category = "Core",
    type = "Generic"
})

lia.config.add("WalkSpeed", "walkSpeed", 200, function(_, newValue)
    for _, client in player.Iterator() do
        client:SetWalkSpeed(newValue)
    end
end, {
    desc = "Controls how fast characters walk.",
    category = "Core",
    type = "Number",
    min = 50,
    max = 300
})

lia.config.add("DeathSoundEnabled", "enableDeathSound", true, nil, {
    desc = "Enable or disable death sounds globally.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("LimbDamage", "limbDamageMultiplier", 0.5, nil, {
    desc = "Sets the damage multiplier for limb hits.",
    category = "Core",
    type = "Number",
    min = 0.1,
    max = 1
})

lia.config.add("DamageScale", "globalDamageScale", 1, nil, {
    desc = "Scales all damage dealt by this multiplier.",
    category = "Core",
    type = "Number",
    min = 0.1,
    max = 5
})

lia.config.add("HeadShotDamage", "headshotDamageMultiplier", 2, nil, {
    desc = "Sets the damage multiplier for headshots.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 10
})

lia.config.add("RunSpeed", "runSpeed", 400, function(_, newValue)
    for _, client in player.Iterator() do
        client:SetRunSpeed(newValue)
    end
end, {
    desc = "Controls how fast characters run.",
    category = "Core",
    type = "Number",
    min = 100,
    max = 500
})

lia.config.add("WalkRatio", "walkRatio", 0.5, nil, {
    desc = "Defines the walk speed ratio when holding the Alt key.",
    category = "Core",
    type = "Number",
    min = 0.2,
    max = 1.0,
    decimals = 2
})

lia.config.add("MaxCharacters", "maxCharacters", 5, nil, {
    desc = "Sets the maximum number of characters a player can have.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 20
})

lia.config.add("AllowPMs", "allowPMs", true, nil, {
    desc = "Determines whether private messages are allowed.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("MinDescLen", "minDescriptionLength", 16, nil, {
    desc = "Minimum length required for a character's description.",
    category = "Core",
    type = "Number",
    min = 10,
    max = 500
})

lia.config.add("DefaultMoney", "defaultMoney", 0, nil, {
    desc = "Specifies the default amount of money a player starts with.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 10000
})

lia.config.add("DataSaveInterval", "dataSaveInterval", 600, nil, {
    desc = "Time interval between data saves.",
    category = "Core",
    type = "Number",
    min = 60,
    max = 3600
})

lia.config.add("CharacterDataSaveInterval", "characterDataSaveInterval", 60, nil, {
    desc = "Time interval between character data saves.",
    category = "Core",
    type = "Number",
    min = 60,
    max = 3600
})

lia.config.add("SpawnTime", "respawnTime", 5, nil, {
    desc = "Time to respawn after death.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 60
})

lia.config.add("TimeToEnterVehicle", "timeToEnterVehicle", 1, nil, {
    desc = "Defines the time to enter vehicle.",
    category = "Core",
    type = "Number",
    min = 0.1,
    max = 30
})

lia.config.add("CarEntryDelayEnabled", "carEntryDelayEnabled", true, nil, {
    desc = "Whether entering a vehicle requires a delay.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("MaxChatLength", "maxChatLength", 256, nil, {
    desc = "Sets the maximum length of chat messages.",
    category = "Core",
    type = "Number",
    min = 50,
    max = 1024
})

lia.config.add("DoorsAlwaysDisabled", "doorsAlwaysDisabled", false, nil, {
    desc = "When enabled, all doors will be disabled by default when the server loads.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("AdminConsoleNetworkLogs", "adminConsoleNetworkLogs", true, nil, {
    desc = "Specifies if the logging system should replicate to super admins' consoles.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("CharMenuBGInputDisabled", "charMenuBGInputDisabled", true, nil, {
    desc = "Whether background input is disabled during character menu use",
    category = "Core",
    type = "Boolean"
})

lia.config.add("AllowKeybindEditing", "allowKeybindEditing", true, nil, {
    desc = "Allow players to edit their keybinds in the settings menu.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("CrosshairEnabled", "enableCrosshair", false, nil, {
    desc = "Enables the crosshair.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("AutoWeaponItemGeneration", "autoWeaponItemGeneration", true, nil, {
    desc = "Enables automatic conversion of dropped weapons into inventory items.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("AutoAmmoItemGeneration", "autoAmmoItemGeneration", true, nil, {
    desc = "Enables automatic conversion of ammo entities into inventory items.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("ItemsCanBeDestroyed", "itemsCanBeDestroyed", true, nil, {
    desc = "Enables whether or not items can be destroyed.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("AmmoDrawEnabled", "enableAmmoDisplay", true, nil, {
    desc = "Enables ammo display.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("IsVoiceEnabled", "voiceChatEnabled", true, function(_, newValue) hook.Run("VoiceToggled", newValue) end, {
    desc = "Whether or not voice chat is enabled.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("SalaryInterval", "salaryInterval", 300, function()
    if not SERVER then return end
    timer.Simple(0.1, function() hook.Run("CreateSalaryTimers") end)
end, {
    desc = "Interval in seconds between salary payouts.",
    category = "Core",
    type = "Number",
    min = 5,
    max = 36000
})

lia.config.add("ThirdPersonEnabled", "thirdPersonEnabled", true, nil, {
    desc = "Allows players to toggle third-person view on or off.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("MaxThirdPersonDistance", "maxThirdPersonDistance", 100, nil, {
    desc = "The maximum allowable camera distance in third-person view.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 100
})

lia.config.add("MaxThirdPersonHorizontal", "maxThirdPersonHorizontal", 30, nil, {
    desc = "The maximum allowable horizontal offset for third-person view.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 30
})

lia.config.add("MaxThirdPersonHeight", "maxThirdPersonHeight", 30, nil, {
    desc = "The maximum allowable vertical offset for third-person view.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 30
})

local function getDermaSkins()
    local skins = {}
    for name in pairs(derma.GetSkinTable()) do
        table.insert(skins, name)
    end

    table.sort(skins)
    return skins
end

lia.config.add("DermaSkin", "dermaSkin", "Lilia Skin", function(_, newSkin) hook.Run("DermaSkinChanged", newSkin) end, {
    desc = "Select the Derma UI skin to use.",
    category = "Core",
    type = "Table",
    options = CLIENT and getDermaSkins() or {"liliaSkin"}
})

lia.config.add("Language", "language", "English", nil, {
    desc = "Determines the language setting for the game.",
    category = "Core",
    type = "Table",
    options = lia.lang.getLanguages()
})

lia.config.add("SpawnMenuLimit", "spawnMenuLimit", false, nil, {
    desc = "Determines if the spawn menu is limited to PET flag holders or staff",
    category = "Core",
    type = "Boolean"
})

lia.config.add("LogRetentionDays", "logRetentionPeriod", 7, nil, {
    desc = "Determines how many days of logs should be read.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 30,
})

lia.config.add("StaminaSlowdown", "staminaSlowdownEnabled", true, nil, {
    desc = "Is Stamina Slowdown Enabled?",
    category = "Core",
    type = "Boolean",
})

lia.config.add("DefaultStamina", "defaultStaminaValue", 100, nil, {
    desc = "Sets default stamina value.",
    category = "Core",
    type = "Number",
    min = 10,
    max = 1000
})

lia.config.add("MaxAttributePoints", "maxAttributePoints", 30, nil, {
    desc = "Maximum number of points that can be allocated across an attribute.",
    category = "Core",
    isGlobal = true,
    type = "Number",
    min = 1,
    max = 100
})

lia.config.add("JumpStaminaCost", "jumpStaminaCost", 10, nil, {
    desc = "Stamina cost deducted when the player jumps.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 1000
})

lia.config.add("MaxStartingAttributes", "maxStartingAttributes", 30, nil, {
    desc = "Maximum value of each attribute at character creation.",
    category = "Core",
    isGlobal = true,
    type = "Number",
    min = 1,
    max = 100
})

lia.config.add("StartingAttributePoints", "startingAttributePoints", 30, nil, {
    desc = "Total number of points available for starting attribute allocation.",
    category = "Core",
    isGlobal = true,
    type = "Number",
    min = 1,
    max = 100
})

lia.config.add("PunchStamina", "punchStamina", 10, nil, {
    desc = "punchStaminaDesc",
    category = "Core",
    isGlobal = true,
    type = "Number",
    min = 1,
    max = 100
})

lia.config.add("PunchLethality", "punchLethality", true, nil, {
    desc = "Whether punches can kill players or just knock them out.",
    category = "Core",
    isGlobal = true,
    type = "Boolean"
})

lia.config.add("StaminaDrain", "staminaDrain", 1, nil, {
    desc = "The rate at which stamina drains.",
    category = "Core",
    type = "Number",
    min = 0.1,
    max = 10,
    decimals = 2
})

lia.config.add("StaminaRegeneration", "staminaRegeneration", 1.75, nil, {
    desc = "The rate at which stamina regenerates.",
    category = "Core",
    type = "Number",
    min = 0.1,
    max = 50,
    decimals = 2
})

lia.config.add("StaminaCrouchRegeneration", "staminaCrouchRegeneration", 2, nil, {
    desc = "The rate at which stamina regenerates while crouching.",
    category = "Core",
    type = "Number",
    min = 0.1,
    max = 50,
    decimals = 2
})

lia.config.add("logsPerPage", "logsPerPage", 50, nil, {
    desc = "Number of log entries to display per page in the administration logs interface",
    category = "Core",
    type = "Number",
    min = 10,
    max = 1000
})

lia.config.add("PunchRagdollTime", "punchRagdollTime", 25, nil, {
    desc = "Duration in seconds that players are ragdolled when punched while lethality is disabled.",
    category = "Core",
    isGlobal = true,
    type = "Number",
    min = 1,
    max = 120
})

lia.config.add("MaxHoldWeight", "maximumHoldWeight", 100, nil, {
    desc = "The maximum weight that a player can carry in their hands.",
    category = "Core",
    type = "Number",
    min = 10,
    max = 500
})

lia.config.add("ThrowForce", "throwForce", 100, nil, {
    desc = "How hard a player can throw the item that they're holding.",
    category = "Core",
    type = "Number",
    min = 10,
    max = 500
})

lia.config.add("PunchPlaytime", "punchPlaytimeProtection", 7200, nil, {
    desc = "Minimum playtime in seconds required to punch.",
    category = "Core",
    isGlobal = true,
    type = "Number",
    min = 0,
    max = 86400
})

lia.config.add("CustomChatSound", "customChatSound", "", nil, {
    desc = "Change chat sound on message send.",
    category = "Core",
    type = "Generic",
})

lia.config.add("TalkRange", "talkRange", 280, nil, {
    desc = "Base range for all talk-based chat modes (whisper, normal, yell).",
    category = "Core",
    type = "Number",
    min = 50,
    max = 10000
})

lia.config.add("WhisperRange", "whisperRange", 70, nil, {
    desc = "Range at which whisper chat can be heard.",
    category = "Core",
    type = "Number",
    min = 10,
    max = 500
})

lia.config.add("YellRange", "yellRange", 840, nil, {
    desc = "Range at which yell chat can be heard.",
    category = "Core",
    type = "Number",
    min = 100,
    max = 2000
})

lia.config.add("OOCLimit", "oocCharacterLimit", 150, nil, {
    desc = "Limit of characters in OOC.",
    category = "Core",
    type = "Number",
    min = 25,
    max = 1000
})

lia.config.add("OOCDelay", "oocDelayTitle", 10, nil, {
    desc = "Set OOC text delay.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 60
})

lia.config.add("LOOCDelay", "loocDelayTitle", 6, nil, {
    desc = "Set LOOC text delay.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 60
})

lia.config.add("LOOCDelayAdmin", "loocDelayAdmin", false, nil, {
    desc = "Should admins have LOOC delay.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("OOCBlocked", "oocBlocked", false, nil, {
    desc = "oocBlockedDesc",
    category = "Core",
    type = "Boolean",
})

lia.config.add("ChatSizeDiff", "enableDifferentChatSize", false, nil, {
    desc = "Enable different chat size.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("MusicVolume", "mainMenuMusicVolume", 0.25, nil, {
    desc = "The volume level for the main menu music",
    category = "Core",
    type = "Number",
    min = 0.01,
    max = 1.0
})

lia.config.add("Music", "mainMenuMusic", "", nil, {
    desc = "The file path or URL for the main menu background music",
    category = "Core",
    type = "Generic"
})

lia.config.add("BackgroundURL", "mainMenuBackgroundURL", "", nil, {
    desc = "The URL or file path for the main menu background image",
    category = "Core",
    type = "Generic"
})

lia.config.add("ServerLogo", "mainMenuCenterLogo", "", nil, {
    desc = "The file path or URL for the server logo displayed on the main menu and scoreboard",
    category = "Core",
    type = "Generic"
})

lia.config.add("ScoreboardLogoEnabled", "scoreboardLogoEnabled", true, nil, {
    desc = "Enable or disable the server logo display on the scoreboard",
    category = "Core",
    type = "Boolean"
})

lia.config.add("MainMenuLogoEnabled", "mainMenuLogoEnabled", true, nil, {
    desc = "Enable or disable the server logo display on the main menu",
    category = "Core",
    type = "Boolean"
})

lia.config.add("DiscordURL", "mainMenuDiscordURL", "", nil, {
    desc = "Discord server URL for the main menu",
    category = "Core",
    type = "Generic"
})

lia.config.add("Workshop", "mainMenuWorkshopURL", "", nil, {
    desc = "Workshop collection URL for the main menu",
    category = "Core",
    type = "Generic"
})

lia.config.add("CharMenuBGInputDisabled", "mainMenuCharBGInputDisabled", true, nil, {
    desc = "Whether background input is disabled during character menu use",
    category = "Core",
    type = "Boolean"
})

lia.config.add("SwitchCooldownOnAllEntities", "switchCooldownOnAllEntities", false, nil, {
    desc = "If true, character switch cooldowns gets applied by all types of damage.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("OnDamageCharacterSwitchCooldownTimer", "onDamageCharacterSwitchCooldownTimer", 15, nil, {
    desc = "Cooldown duration (in seconds) after taking damage to switch characters.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 120
})

lia.config.add("CharacterSwitchCooldownTimer", "characterSwitchCooldownTimer", 5, nil, {
    desc = "Cooldown duration (in seconds) for switching characters.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 120
})

lia.config.add("ExplosionRagdoll", "explosionRagdoll", false, nil, {
    desc = "Determines whether being hit by an explosion results in ragdolling",
    category = "Core",
    type = "Boolean",
})

lia.config.add("CarRagdoll", "carRagdoll", false, nil, {
    desc = "Determines whether being hit by a car results in ragdolling",
    category = "Core",
    type = "Boolean",
})

lia.config.add("NPCsDropWeapons", "npcsDropWeapons", false, nil, {
    desc = "Controls whether NPCs drop weapons upon death",
    category = "Core",
    type = "Boolean",
})

lia.config.add("TimeUntilDroppedSWEPRemoved", "timeUntilDroppedSWEPRemoved", 15, nil, {
    desc = "Specifies the duration (in seconds) until a dropped SWEP is removed",
    category = "Core",
    type = "Number",
    min = 1,
    max = 300
})

lia.config.add("AltsDisabled", "altsDisabled", false, nil, {
    desc = "Whether or not alting is permitted",
    category = "Core",
    type = "Boolean",
})

lia.config.add("ActsActive", "actsActive", false, nil, {
    desc = "Determines whether acts are active",
    category = "Core",
    type = "Boolean",
})

lia.config.add("PropProtection", "propProtection", true, nil, {
    desc = "Enables prop crash prevention behaviors (physgun pickup/drop collision safety and freeze pass-through).",
    category = "Core",
    type = "Boolean",
})

lia.config.add("PassableOnFreeze", "passableOnFreeze", false, nil, {
    desc = "Makes it so that props frozen can be passed through when frozen",
    category = "Core",
    type = "Boolean",
})

lia.config.add("PlayerSpawnVehicleDelay", "playerSpawnVehicleDelay", 30, nil, {
    desc = "Delay for spawning a vehicle after the previous one",
    category = "Core",
    type = "Number",
    min = 0,
    max = 300
})

lia.config.add("ToolInterval", "toolInterval", 0, nil, {
    desc = "Tool Gun Usage Cooldown",
    category = "Core",
    type = "Number",
    min = 0,
    max = 60
})

lia.config.add("MouthMoveAnimation", "mouthMoveAnimation", true, function(_, newValue)
    if newValue then
        hook.Add("MouthMoveAnimation", "Optimization", function() return nil end)
    else
        hook.Remove("MouthMoveAnimation", "Optimization")
    end
end, {
    desc = "mouthMoveAnimationDesc",
    category = "Performance",
    type = "Boolean"
})

lia.config.add("GrabEarAnimation", "grabEarAnimation", false, function(_, newValue)
    if newValue then
        hook.Add("GrabEarAnimation", "Optimization", function() return nil end)
    else
        hook.Remove("GrabEarAnimation", "Optimization")
    end
end, {
    desc = "grabEarAnimationDesc",
    category = "Performance",
    type = "Boolean"
})

lia.config.add("VoiceIcons", "voiceIcons", false, function(_, newValue) if SERVER then RunConsoleCommand("mp_show_voice_icons", newValue and 1 or 0) end end, {
    desc = "voiceIconsDesc",
    category = "Performance",
    type = "Boolean"
})

lia.config.add("DisableLuaRun", "disableLuaRun", false, nil, {
    desc = "Whether or not Lilia should prevent lua_run hooks on maps",
    category = "Core",
    type = "Boolean",
})

lia.config.add("EquipDelay", "equipDelay", 0, nil, {
    desc = "Time delay between equipping items.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 30
})

lia.config.add("UnequipDelay", "unequipDelay", 0, nil, {
    desc = "Time delay between unequipping items.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 30
})

lia.config.add("DropDelay", "dropDelay", 0, nil, {
    desc = "Time delay between dropping items.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 30
})

lia.config.add("DeleteDroppedItemsOnLeave", "deleteDroppedItemsOnLeave", false, nil, {
    desc = "When enabled, all items dropped by a player will be deleted when they disconnect.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("DeleteEntitiesOnLeave", "deleteEntitiesOnLeave", true, nil, {
    desc = "When enabled, all entities created by a player (except lia_ entities) will be deleted when they disconnect.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("TakeDelay", "takeDelay", 0, nil, {
    desc = "Time delay between taking items.",
    category = "Core",
    type = "Number",
    min = 0,
    max = 30
})

lia.config.add("ItemGiveSpeed", "itemGiveSpeed", 6, nil, {
    desc = "How fast transferring items between players via giveForward is.",
    category = "Core",
    type = "Number",
    min = 1,
    max = 60
})

lia.config.add("ItemGiveEnabled", "itemGiveEnabled", true, nil, {
    desc = "Determines if item giving via giveForward is enabled.",
    category = "Core",
    type = "Boolean",
})

lia.config.add("LoseItemsonDeathNPC", "loseItemsOnNPCDeath", false, nil, {
    desc = "Determine if items marked for loss are lost on death by NPCs.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("LoseItemsonDeathHuman", "loseItemsOnHumanDeath", false, nil, {
    desc = "Determine if items marked for loss are lost on death by humans.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("LoseItemsonDeathWorld", "loseItemsOnWorldDeath", false, nil, {
    desc = "Determine if items marked for loss are lost on death by the world.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("DeathPopupEnabled", "enableDeathPopup", true, nil, {
    desc = "Enable or disable the death information popup.",
    category = "Core",
    type = "Boolean"
})

lia.config.add("ClassDisplay", "displayClassesOnCharacters", true, nil, {
    desc = "Whether or not classes are displayed on characters.",
    category = "Core",
    type = "Boolean",
})

local function refreshScoreboard()
    if CLIENT and IsValid(lia.gui.score) and lia.gui.score.ApplyConfig then lia.gui.score:ApplyConfig() end
end

lia.config.add("sbWidth", "sbWidth", 0.65, refreshScoreboard, {
    desc = "Scoreboard width proportion",
    category = "Core",
    type = "Number",
    min = 0.2,
    max = 1.0
})

lia.config.add("sbHeight", "sbHeight", 0.65, refreshScoreboard, {
    desc = "Scoreboard height proportion",
    category = "Core",
    type = "Number",
    min = 0.2,
    max = 1.0
})

lia.config.add("sbDock", "sbDock", "center", refreshScoreboard, {
    desc = "Determines where the scoreboard appears on screen",
    category = "Core",
    type = "Table",
    options = {"left", "center", "right"}
})

lia.config.add("ClassHeaders", "classHeaders", true, nil, {
    desc = "Should class headers exist?",
    category = "Core",
    type = "Boolean"
})

lia.config.add("UseSolidBackground", "useSolidBackground", false, nil, {
    desc = "Use a solid background for the scoreboard",
    category = "Core",
    type = "Boolean"
})

lia.config.add("ClassLogo", "classLogo", false, nil, {
    desc = "Toggle display of class logo next to player entries",
    category = "Core",
    type = "Boolean"
})

lia.config.add("ScoreboardBackgroundColor", "scoreboardBackgroundColor", {
    r = 255,
    g = 100,
    b = 100,
    a = 255
}, nil, {
    desc = "Sets the background color of the scoreboard. This only applies if 'UseSolidBackground' is enabled.",
    category = "Core",
    type = "Color"
})

lia.config.add("RecognitionEnabled", "recognitionEnabled", true, nil, {
    desc = "Whether or not character recognition is enabled?",
    category = "Core",
    type = "Boolean"
})

lia.config.add("FakeNamesEnabled", "fakeNamesEnabled", false, nil, {
    desc = "Are fake names enabled?",
    category = "Core",
    type = "Boolean"
})

lia.config.add("vendorDefaultMoney", "vendorDefaultMoney", 500, nil, {
    desc = "Default amount of money vendors start with",
    category = "Core",
    type = "Number",
    min = 100,
    max = 10000
})

local function getMenuTabNames()
    local defs = {}
    hook.Run("CreateMenuButtons", defs)
    local tabs = {}
    for k in pairs(defs) do
        tabs[#tabs + 1] = k
    end
    return tabs
end

lia.config.add("DefaultMenuTab", "defaultMenuTab", "you", nil, {
    desc = "Specifies which tab is opened by default when the menu is shown.",
    category = "Core",
    type = "Table",
    options = function()
        local tabs = {}
        local tabNames = CLIENT and getMenuTabNames() or {"you"}
        for _, tabName in ipairs(tabNames) do
            tabs[L(tabName) or tabName] = tabName
        end
        return tabs
    end
})

lia.config.add("DoorLockTime", "doorLockTime", 0.5, nil, {
    desc = "Time delay for door lock/unlock actions",
    category = "Core",
    type = "Number",
    min = 0.05,
    max = 30.0
})

lia.config.add("DoorSellRatio", "doorSellRatio", 0.5, nil, {
    desc = "Percentage you can sell a door for",
    category = "Core",
    min = 0.1,
    max = 1.0
})

lia.config.add("MainMenuUseLastPos", "mainMenuUseLastPos", true, nil, {
    desc = "Enable or disable using the character's last position for main menu camera positioning",
    category = "Core",
    type = "Boolean"
})

hook.Add("PopulateConfigurationButtons", "liaConfigPopulate", function(pages)
    local function SetStyledTooltip(panel, text)
        if not text or text == "" then return end
        panel:SetTooltip(text)
        local oldSetTooltip = panel.SetTooltip
        function panel:SetTooltip(tooltipText)
            oldSetTooltip(self, tooltipText)
            timer.Simple(0, function()
                if not IsValid(self) then return end
                local tooltip = vgui.GetTooltipPanel()
                if IsValid(tooltip) and not tooltip.LiliaStyled then
                    tooltip.LiliaStyled = true
                    function tooltip:Paint(w, h)
                        local bgColor = Color(25, 28, 35, 250)
                        lia.derma.rect(0, 0, w, h):Rad(8):Color(bgColor):Shape(lia.derma.SHAPE_IOS):Draw()
                    end
                end
            end)
        end
    end

    local function AddHeader(scroll, text)
        local header = scroll:Add("DPanel")
        header:Dock(TOP)
        header:SetTall(35)
        header:DockMargin(0, 5, 0, 5)
        header.Paint = function(me, w, h)
            local accent = lia.color.theme.accent or lia.config.get("Color") or Color(0, 150, 255)
            surface.SetDrawColor(accent)
            surface.DrawRect(0, h - 2, w, 2)
        end

        local label = header:Add("DLabel")
        label:Dock(LEFT)
        label:SetText(L(text))
        label:SetFont("LiliaFont.22")
        label:SetTextColor(lia.color.theme.text or color_white)
        label:SizeToContents()
        label:DockMargin(5, 0, 0, 0)
    end

    local function AddField(scroll, key, name, config)
        local p = scroll:Add("DPanel")
        p:Dock(TOP)
        p:SetTall(45)
        p:DockMargin(0, 0, 0, 5)
        p.Paint = function(s, w, h) lia.derma.rect(0, 0, w, h):Rad(6):Color(Color(35, 38, 45, 180)):Shape(lia.derma.SHAPE_IOS):Draw() end
        local description = (config.data and config.data.desc) or config.desc or ""
        SetStyledTooltip(p, description)
        local l = p:Add("DLabel")
        l:Dock(LEFT)
        l:DockMargin(15, 0, 0, 0)
        l:SetWidth(250)
        l:SetText(name)
        l:SetFont("LiliaFont.18")
        l:SetTextColor(lia.color.theme.text or color_white)
        l:SetContentAlignment(4)
        SetStyledTooltip(l, description)
        local configType = config.data and config.data.type or config.type or "Generic"
        if configType == "Boolean" then
            local checkbox = p:Add("liaCheckbox")
            checkbox:Dock(RIGHT)
            checkbox:DockMargin(0, 10, 15, 10)
            checkbox:SetWidth(25)
            checkbox:SetChecked(lia.config.get(key, config.value))
            SetStyledTooltip(checkbox, description)
            checkbox.OnChange = function(s, val)
                net.Start("liaCfgSet")
                net.WriteString(key)
                net.WriteString(name)
                net.WriteType(val)
                net.SendToServer()
            end

            if CLIENT then lia.config._bindUI(key, checkbox, function(v) checkbox:SetChecked(tobool(v)) end) end
        elseif configType == "Number" or configType == "Int" or configType == "Float" or configType == "Generic" then
            local entry = p:Add("liaEntry")
            entry:Dock(RIGHT)
            entry:SetWidth(200)
            entry:DockMargin(0, 8, 15, 8)
            entry:SetValue(tostring(lia.config.get(key, config.value)))
            entry:SetFont("LiliaFont.18")
            SetStyledTooltip(entry, description)
            entry.textEntry.OnEnter = function(s)
                local value = entry:GetValue()
                local numValue = tonumber(value)
                if (configType == "Number" or configType == "Int" or configType == "Float") and numValue ~= nil then
                    net.Start("liaCfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(numValue)
                    net.SendToServer()
                elseif configType == "Generic" then
                    net.Start("liaCfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(value)
                    net.SendToServer()
                else
                    entry:SetValue(tostring(lia.config.get(key, config.value)))
                end
            end

            if CLIENT then lia.config._bindUI(key, entry, function(v) entry:SetValue(tostring(v)) end) end
        elseif configType == "Color" then
            local button = p:Add("liaButton")
            button:Dock(RIGHT)
            button:SetWidth(200)
            button:DockMargin(0, 8, 15, 8)
            button:SetText("")
            SetStyledTooltip(button, description)
            button.Paint = function(s, w, h)
                local c = lia.config.get(key, config.value)
                if istable(c) and c.r and c.g and c.b then
                    c = Color(c.r, c.g, c.b, c.a)
                elseif not IsColor(c) then
                    c = color_white
                end

                lia.derma.rect(0, 0, w, h):Rad(6):Color(c):Shape(lia.derma.SHAPE_IOS):Draw()
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
            end

            button.DoClick = function()
                local c = lia.config.get(key, config.value)
                if not IsColor(c) and istable(c) then c = Color(c.r, c.g, c.b, c.a) end
                lia.derma.requestColorPicker(function(color)
                    net.Start("liaCfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(color)
                    net.SendToServer()
                end, c)
            end
        elseif configType == "Table" then
            local combo = p:Add("liaComboBox")
            combo:Dock(RIGHT)
            combo:SetWidth(200)
            combo:DockMargin(0, 8, 15, 8)
            combo:SetValue(tostring(lia.config.get(key, config.value)))
            combo:SetFont("LiliaFont.18")
            SetStyledTooltip(combo, description)
            local options = lia.config.getOptions(key)
            for _, text in pairs(options) do
                combo:AddChoice(text, text)
            end

            combo.OnSelect = function(_, _, v)
                net.Start("liaCfgSet")
                net.WriteString(key)
                net.WriteString(name)
                net.WriteType(v)
                net.SendToServer()
            end

            if CLIENT then lia.config._bindUI(key, combo, function(v) combo:SetValue(tostring(v)) end) end
        end
    end

    if hook.Run("CanPlayerModifyConfig", LocalPlayer()) ~= false then
        net.Start("liaCfgList")
        net.SendToServer()
        local uniqueTabConfigs = {}
        local regularConfigs = {}
        for k, v in pairs(lia.config.stored) do
            if istable(v) and v.data ~= nil and v.default ~= nil and v.name ~= nil then
                if v.data.uniqueTab then
                    uniqueTabConfigs[k] = v
                else
                    regularConfigs[k] = v
                end
            end
        end

        local categoryPages = {}
        for key, config in pairs(uniqueTabConfigs) do
            local category = config.category or "Core"
            if not categoryPages[category] then
                categoryPages[category] = {
                    configs = {},
                    name = L(category)
                }
            end

            table.insert(categoryPages[category].configs, {
                key = key,
                config = config
            })
        end

        for category, pageData in pairs(categoryPages) do
            pages[#pages + 1] = {
                name = pageData.name,
                drawFunc = function(parent)
                    parent:Clear()
                    parent:DockPadding(10, 10, 10, 10)
                    local scroll = parent:Add("liaScrollPanel")
                    scroll:Dock(FILL)
                    scroll:GetCanvas():DockPadding(0, 0, 0, 0)
                    for _, configInfo in ipairs(pageData.configs) do
                        AddField(scroll, configInfo.key, configInfo.config.name, configInfo.config)
                    end
                end
            }
        end

        pages[#pages + 1] = {
            name = "categoryConfiguration",
            drawFunc = function(parent)
                parent:Clear()
                local searchEntry = parent:Add("liaEntry")
                searchEntry:Dock(TOP)
                searchEntry:SetTall(35)
                searchEntry:DockMargin(10, 10, 10, 10)
                searchEntry:SetPlaceholderText("Search configs..." or "Search configurations...")
                searchEntry:SetFont("LiliaFont.18")
                local scroll = parent:Add("liaScrollPanel")
                scroll:Dock(FILL)
                scroll:GetCanvas():DockPadding(10, 10, 10, 10)
                local function populate(filter)
                    scroll:Clear()
                    filter = filter and filter:len() > 0 and filter:lower() or nil
                    local categories = {}
                    for k, v in pairs(regularConfigs) do
                        local cat = v.category or "Core"
                        categories[cat] = categories[cat] or {}
                        table.insert(categories[cat], {
                            key = k,
                            name = tostring(v.name or k),
                            config = v
                        })
                    end

                    local sortedCategories = {}
                    for cat, items in pairs(categories) do
                        table.insert(sortedCategories, cat)
                    end

                    table.sort(sortedCategories)
                    for _, cat in ipairs(sortedCategories) do
                        local items = categories[cat]
                        table.sort(items, function(a, b) return (a.name or "") < (b.name or "") end)
                        local visibleItems = {}
                        for _, item in ipairs(items) do
                            if not filter or item.name:lower():find(filter, 1, true) or cat:lower():find(filter, 1, true) then table.insert(visibleItems, item) end
                        end

                        if #visibleItems > 0 then
                            AddHeader(scroll, cat)
                            for _, item in ipairs(visibleItems) do
                                AddField(scroll, item.key, item.name, item.config)
                            end
                        end
                    end
                end

                searchEntry:SetUpdateOnType(true)
                searchEntry.OnTextChanged = function(me, text) populate(text) end
                populate(nil)
            end
        }
    end
end)
