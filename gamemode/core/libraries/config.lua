lia.config = lia.config or {}
lia.config.stored = lia.config.stored or {}
function lia.config.add(key, name, value, callback, data)
    assert(isstring(key), "Expected config key to be string, got " .. type(key))
    assert(istable(data), "Expected config data to be a table, got " .. type(data))
    local t = type(value)
    local configType = t == "boolean" and "Boolean" or t == "number" and (math.floor(value) == value and "Int" or "Float") or t == "table" and value.r and value.g and value.b and "Color" or "Generic"
    data.type = data.type or configType
    local oldConfig = lia.config.stored[key]
    local savedValue = oldConfig and oldConfig.value or value
    local category = data.category
    local desc = data.desc
    lia.config.stored[key] = {
        name = name or key,
        data = data,
        value = savedValue,
        default = value,
        desc = desc,
        category = category or L("character"),
        noNetworking = data.noNetworking or false,
        callback = callback
    }
end

function lia.config.setDefault(key, value)
    local config = lia.config.stored[key]
    if config then config.default = value end
end

function lia.config.forceSet(key, value, noSave)
    local config = lia.config.stored[key]
    if config then config.value = value end
    if not noSave then lia.config.save() end
end

function lia.config.set(key, value)
    local config = lia.config.stored[key]
    if config then
        local oldValue = config.value
        config.value = value
        if SERVER then
            if not config.noNetworking then
                net.Start("cfgSet")
                net.WriteString(key)
                net.WriteType(value)
                net.Broadcast()
            end

            if config.callback then config.callback(oldValue, value) end
            lia.config.save()
        end
    end
end

function lia.config.get(key, default)
    local config = lia.config.stored[key]
    if config then
        if config.value ~= nil then
            if istable(config.value) and config.value.r and config.value.g and config.value.b then config.value = Color(config.value.r, config.value.g, config.value.b) end
            return config.value
        elseif config.default ~= nil then
            return config.default
        end
    end
    return default
end

function lia.config.load()
    if SERVER then
        local schema = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        lia.db.select({"key", "value"}, "config", "schema = " .. lia.db.convertDataType(schema)):next(function(res)
            local rows = res.results or {}
            local existing = {}
            for _, row in ipairs(rows) do
                local decoded = util.JSONToTable(row.value)
                lia.config.stored[row.key] = lia.config.stored[row.key] or {}
                local value = decoded and decoded[1]
                if value == nil or value == "" then
                    lia.config.stored[row.key].value = lia.config.stored[row.key].default
                else
                    lia.config.stored[row.key].value = value
                    existing[row.key] = true
                end
            end

            local inserts = {}
            for k, v in pairs(lia.config.stored) do
                if not existing[k] then
                    lia.config.stored[k].value = v.default
                    inserts[#inserts + 1] = {
                        schema = schema,
                        key = k,
                        value = {v.default}
                    }
                end
            end

            local finalize = function() hook.Run("InitializedConfig") end
            if #inserts > 0 then
                local ops = {}
                for _, row in ipairs(inserts) do
                    ops[#ops + 1] = lia.db.upsert(row, "config")
                end

                deferred.all(ops):next(finalize, finalize)
            else
                finalize()
            end
        end)
    else
        net.Start("cfgList")
        net.SendToServer()
    end
end

if SERVER then
    function lia.config.getChangedValues()
        local data = {}
        for k, v in pairs(lia.config.stored) do
            if v.default ~= v.value then data[k] = v.value end
        end
        return data
    end

    function lia.config.send(client)
        net.Start("cfgList")
        net.WriteTable(lia.config.getChangedValues())
        if client then
            net.Send(client)
        else
            net.Broadcast()
        end
    end

    function lia.config.save()
        local changed = lia.config.getChangedValues()
        local rows = {}
        for k, v in pairs(changed) do
            rows[#rows + 1] = {
                key = k,
                value = {v}
            }
        end

        local schema = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        local queries = {"DELETE FROM lia_config WHERE schema = " .. lia.db.convertDataType(schema)}
        for _, row in ipairs(rows) do
            queries[#queries + 1] = "INSERT INTO lia_config (schema,key,value) VALUES (" .. lia.db.convertDataType(schema) .. ", " .. lia.db.convertDataType(row.key) .. ", " .. lia.db.convertDataType(row.value) .. ")"
        end

        lia.db.transaction(queries)
    end
end

lia.config.add("MoneyModel", "Money Model", "models/props_lab/box01a.mdl", nil, {
    desc = "Defines the model used for representing money in the game.",
    category = "Money",
    type = "Generic"
})

lia.config.add("MoneyLimit", "Money Limit", 0, nil, {
    desc = "Sets the limit of money a player can have [0 for infinite].",
    category = "Money",
    type = "Int",
    min = 0,
    max = 1000000
})

lia.config.add("CurrencySymbol", "Currency Symbol", "", function(newVal) lia.currency.symbol = newVal end, {
    desc = "Specifies the currency symbol used in the game.",
    category = "Money",
    type = "Generic"
})

lia.config.add("PKWorld", "PK World Deaths Count", false, nil, {
    desc = "When marked for Perma Kill, does world deaths count as perma killing?",
    category = "Character",
    type = "Boolean"
})

lia.config.add("CurrencySingularName", "Currency Singular Name", "Dollar", function(newVal) lia.currency.singular = newVal end, {
    desc = "Singular name of the in-game currency.",
    category = "Money",
    type = "Generic"
})

lia.config.add("CurrencyPluralName", "Currency Plural Name", "Dollars", function(newVal) lia.currency.plural = newVal end, {
    desc = "Plural name of the in-game currency.",
    category = "Money",
    type = "Generic"
})

lia.config.add("WalkSpeed", "Walk Speed", 130, function(_, newValue)
    for _, client in player.Iterator() do
        client:SetWalkSpeed(newValue)
    end
end, {
    desc = "Controls how fast characters walk.",
    category = "Character",
    type = "Int",
    min = 50,
    max = 300
})

lia.config.add("RunSpeed", "Run Speed", 275, function(_, newValue)
    for _, client in player.Iterator() do
        client:SetRunSpeed(newValue)
    end
end, {
    desc = "Controls how fast characters run.",
    category = "Character",
    type = "Int",
    min = 100,
    max = 500
})

lia.config.add("WalkRatio", "Walk Ratio", 0.5, nil, {
    desc = "Defines the walk speed ratio when holding the Alt key.",
    category = "Character",
    type = "Float",
    min = 0.1,
    max = 1.0,
    decimals = 2
})

lia.config.add("AllowExistNames", "Allow Duplicate Names", true, nil, {
    desc = "Determines whether duplicate character names are allowed.",
    category = "Character",
    type = "Boolean"
})

lia.config.add("MaxCharacters", "Max Characters", 5, nil, {
    desc = "Sets the maximum number of characters a player can have.",
    category = "Character",
    type = "Int",
    min = 1,
    max = 10
})

lia.config.add("AllowPMs", "Allow Private Messages", true, nil, {
    desc = "Determines whether private messages are allowed.",
    category = "Chat",
    type = "Boolean"
})

lia.config.add("MinDescLen", "Minimum Description Length", 16, nil, {
    desc = "Minimum length required for a character's description.",
    category = "Character",
    type = "Int",
    min = 10,
    max = 500
})

lia.config.add("SaveInterval", "Save Interval", 300, nil, {
    desc = "Interval for character saves in seconds.",
    category = "Character",
    type = "Int",
    min = 60,
    max = 3600
})

lia.config.add("DefMoney", "Default Money", 0, nil, {
    desc = "Specifies the default amount of money a player starts with.",
    category = "Character",
    type = "Int",
    min = 0,
    max = 10000
})

lia.config.add("DataSaveInterval", "Data Save Interval", 600, nil, {
    desc = "Time interval between data saves.",
    category = "Data",
    type = "Int",
    min = 60,
    max = 3600
})

lia.config.add("CharacterDataSaveInterval", "Character Data Save Interval", 300, nil, {
    desc = "Time interval between character data saves.",
    category = "Data",
    type = "Int",
    min = 60,
    max = 3600
})

lia.config.add("SpawnTime", "Respawn Time", 5, nil, {
    desc = "Time to respawn after death.",
    category = "Death",
    type = "Float",
    min = 1,
    max = 60
})

lia.config.add("TimeToEnterVehicle", "Vehicle Entry Time", 1, nil, {
    desc = "Time [in seconds] required to enter a vehicle.",
    category = "Quality of Life",
    type = "Float",
    min = 0.5,
    max = 10
})

lia.config.add("CarEntryDelayEnabled", "Car Entry Delay Enabled", true, nil, {
    desc = "Determines if the car entry delay is applicable.",
    category = "Timers",
    type = "Boolean"
})

lia.config.add("MaxChatLength", "Max Chat Length", 256, nil, {
    desc = "Sets the maximum length of chat messages.",
    category = "Visuals",
    type = "Int",
    min = 50,
    max = 1024
})

lia.config.add("SchemaYear", "Schema Year", 2025, nil, {
    desc = "Year of the gamemode's schema.",
    category = "General",
    type = "Int",
    min = 0,
    max = 999999
})

lia.config.add("AmericanDates", "American Dates", true, nil, {
    desc = "Determines whether to use the American date format.",
    category = "General",
    type = "Boolean"
})

lia.config.add("AmericanTimeStamp", "American Timestamp", true, nil, {
    desc = "Determines whether to use the American timestamp format.",
    category = "General",
    type = "Boolean"
})

lia.config.add("AdminConsoleNetworkLogs", "Admin Console Network Logs", true, nil, {
    desc = "Specifies if the logging system should replicate to super admins' consoles.",
    category = "Staff",
    type = "Boolean"
})

lia.config.add("Color", "Theme Color", {
    r = 37,
    g = 116,
    b = 108
}, nil, {
    desc = "Sets the theme color used throughout the gamemode.",
    category = "Visuals",
    type = "Color"
})

lia.config.add("CharMenuBGInputDisabled", "Character Menu BG Input Disabled", true, nil, {
    desc = "Whether background input is disabled durinag character menu use",
    category = "Main Menu",
    type = "Boolean"
})

lia.config.add("AllowKeybindEditing", "Allow Keybind Editing", true, nil, {
    desc = "Whether keybind editing is allowed",
    category = "General",
    type = "Boolean"
})

lia.config.add("CrosshairEnabled", "Enable Crosshair", false, nil, {
    desc = "Enables the crosshair",
    category = "Visuals",
    type = "Boolean"
})

lia.config.add("BarsDisabled", "Disable Bars", false, nil, {
    desc = "Disables bars",
    category = "Visuals",
    type = "Boolean"
})

lia.config.add("AutoWeaponItemGeneration", "Auto Weapon-to-Item Generation", true, nil, {
    desc = "Enables automatic conversion of dropped weapons into inventory items",
    category = "General",
    type = "Boolean"
})

lia.config.add("AmmoDrawEnabled", "Enable Ammo Display", true, nil, {
    desc = "Enables ammo display",
    category = "Visuals",
    type = "Boolean"
})

lia.config.add("IsVoiceEnabled", "Voice Chat Enabled", true, function(_, newValue) hook.Run("VoiceToggled", newValue) end, {
    desc = "Whether or not voice chat is enabled",
    category = "General",
    type = "Boolean"
})

lia.config.add("SalaryInterval", "Salary Interval", 300, function()
    for _, client in player.Iterator() do
        hook.Run("CreateSalaryTimer", client)
    end
end, {
    desc = "Interval in seconds between salary payouts.",
    category = "Salary",
    type = "Float",
    min = 60,
    max = 3600
})

lia.config.add("SalaryThreshold", "Salary Threshold", 0, nil, {
    desc = "Money threshold above which salaries will not be given.",
    category = "Salary",
    type = "Int",
    min = 0,
    max = 100000
})

lia.config.add("ThirdPersonEnabled", "Enable Third-Person View", true, nil, {
    desc = "Allows players to toggle third-person view on or off.",
    category = "Third Person",
    type = "Boolean"
})

lia.config.add("MaxThirdPersonDistance", "Maximum Third-Person Distance", 100, nil, {
    desc = "The maximum allowable camera distance in third-person view.",
    category = "Third Person",
    type = "Int"
})

lia.config.add("WallPeek", "Wall Peek", true, nil, {
    desc = "Limits third‑person wall peeking by hiding players outside view or obstructed.",
    category = "Rendering",
    type = "Boolean"
})

lia.config.add("MaxThirdPersonHorizontal", "Maximum Third-Person Horizontal Offset", 30, nil, {
    desc = "The maximum allowable horizontal offset for third-person view.",
    category = "Third Person",
    type = "Int"
})

lia.config.add("MaxThirdPersonHeight", "Maximum Third-Person Height Offset", 30, nil, {
    desc = "The maximum allowable vertical offset for third-person view.",
    category = "Third Person",
    type = "Int"
})

lia.config.add("MaxViewDistance", "Maximum View Distance", 32768, nil, {
    desc = "The maximum distance (in units) at which players are visible." .. " This default covers an entire Source map (~32k units).",
    category = "Quality of Life",
    type = "Int",
    min = 1000,
    max = 32768,
})

lia.config.add("AutoDownloadWorkshop", "Auto Download Workshop Content", true, nil, {
    desc = "Automatically download both collection and module-defined WorkshopContent.",
    category = "Workshop",
    type = "Boolean"
})

local function getDermaSkins()
    local skins = {}
    for name in pairs(derma.GetSkinTable()) do
        table.insert(skins, name)
    end

    table.sort(skins)
    return skins
end

lia.config.add("DermaSkin", "Derma UI Skin", "Lilia Skin", function(_, newSkin) hook.Run("DermaSkinChanged", newSkin) end, {
    desc = "Select the Derma UI skin to use",
    category = "Visuals",
    type = "Table",
    options = CLIENT and getDermaSkins() or {"Lilia Skin"}
})

lia.config.add("PermaClass", "Permanent Classes", true, nil, {
    desc = "Whether or not classes are saved in characters",
    category = "Character",
    type = "Boolean"
})

lia.config.add("ClassDisplay", "Display Classes on Characters", true, nil, {
    desc = "Whether or not classes are displayed on characters",
    category = "Character",
    type = "Boolean"
})

lia.config.add("LoseItemsonDeathNPC", "Lose Items on NPC Death", false, nil, {
    desc = "Determine if items marked for loss are lost on death by NPCs",
    category = "Death",
    type = "Boolean"
})

lia.config.add("LoseItemsonDeathHuman", "Lose Items on Human Death", false, nil, {
    desc = "Determine if items marked for loss are lost on death by Humans",
    category = "Death",
    type = "Boolean"
})

lia.config.add("LoseItemsonDeathWorld", "Lose Items on World Death", false, nil, {
    desc = "Determine if items marked for loss are lost on death by World",
    category = "Death",
    type = "Boolean"
})

lia.config.add("DeathPopupEnabled", "Enable Death Popup", true, nil, {
    desc = "Enable or disable the death information popup",
    category = "Death",
    type = "Boolean"
})

lia.config.add("StaffHasGodMode", "Staff God Mode", true, nil, {
    desc = "Whether or not Staff On Duty has God Mode",
    category = "Staff",
    type = "Boolean"
})

lia.config.add("sbWidth", "Scoreboard Width", 0.35, nil, {
    desc = "Scoreboard Width",
    category = "Scoreboard",
    type = "Float",
    min = 0.1,
    max = 1.0
})

lia.config.add("sbHeight", "Scoreboard Height", 0.65, nil, {
    desc = "Scoreboard Height",
    category = "Scoreboard",
    type = "Float",
    min = 0.1,
    max = 1.0
})

lia.config.add("ClassHeaders", "Class Headers", true, nil, {
    desc = "Should class headers exist?",
    category = "Scoreboard",
    type = "Boolean"
})

lia.config.add("UseSolidBackground", "Use Solid Background in Scoreboard", false, nil, {
    desc = "Use a solid background for the scoreboard",
    category = "Scoreboard",
    type = "Boolean"
})

lia.config.add("ClassLogo", "Should Class Logo Appear in the Player Bar", false, nil, {
    desc = "Toggle display of class logo next to player entries",
    category = "Scoreboard",
    type = "Boolean"
})

lia.config.add("ScoreboardBackgroundColor", "Scoreboard Background Color", {
    r = 255,
    g = 100,
    b = 100,
    a = 255
}, nil, {
    desc = "Sets the background color of the scoreboard. This only applies if 'UseSolidBackground' is enabled.",
    category = "Scoreboard",
    type = "Color"
})

lia.config.add("RecognitionEnabled", "Character Recognition Enabled", true, nil, {
    desc = "Whether or not character recognition is enabled?",
    category = "Recognition",
    type = "Boolean"
})

lia.config.add("FakeNamesEnabled", "Fake Names Enabled", false, nil, {
    desc = "Are fake names enabled?",
    category = "Recognition",
    type = "Boolean"
})

lia.config.add("SwitchCooldownOnAllEntities", "Apply cooldown on all entities", false, nil, {
    desc = "If true, character switch cooldowns gets applied by all types of damage.",
    category = "Character",
    type = "Boolean"
})

lia.config.add("OnDamageCharacterSwitchCooldownTimer", "Switch cooldown after damage", 15, nil, {
    desc = "Cooldown duration (in seconds) after taking damage to switch characters.",
    category = "Character",
    type = "Float",
    min = 0,
    max = 120
})

lia.config.add("CharacterSwitchCooldownTimer", "Character switch cooldown timer", 5, nil, {
    desc = "Cooldown duration (in seconds) for switching characters.",
    category = "Character",
    type = "Float",
    min = 0,
    max = 120
})

lia.config.add("ExplosionRagdoll", "Explosion Ragdoll on Hit", false, nil, {
    desc = "Determines whether being hit by an explosion results in ragdolling",
    category = "Quality of Life",
    type = "Boolean"
})

lia.config.add("CarRagdoll", "Car Ragdoll on Hit", false, nil, {
    desc = "Determines whether being hit by a car results in ragdolling",
    category = "Quality of Life",
    type = "Boolean"
})

lia.config.add("NPCsDropWeapons", "NPCs Drop Weapons on Death", false, nil, {
    desc = "Controls whether NPCs drop weapons upon death",
    category = "Quality of Life",
    type = "Boolean"
})

lia.config.add("TimeUntilDroppedSWEPRemoved", "Time Until Dropped SWEP Removed", 15, nil, {
    desc = "Specifies the duration (in seconds) until a dropped SWEP is removed",
    category = "Protection",
    type = "Float",
    min = 0,
    max = 300
})

lia.config.add("AltsDisabled", "Disable Alts", false, nil, {
    desc = "Whether or not alting is permitted",
    category = "Protection",
    type = "Boolean"
})

lia.config.add("ActsActive", "Enable Acts", false, nil, {
    desc = "Determines whether acts are active",
    category = "Protection",
    type = "Boolean"
})

lia.config.add("PassableOnFreeze", "Passable on Freeze", false, nil, {
    desc = "Makes it so that props frozen can be passed through when frozen",
    category = "Protection",
    type = "Boolean"
})

lia.config.add("PlayerSpawnVehicleDelay", "Player Spawn Vehicle Delay", 30, nil, {
    desc = "Delay for spawning a vehicle after the previous one",
    category = "Protection",
    type = "Float",
    min = 0,
    max = 300
})

lia.config.add("ToolInterval", "Tool Gun Usage Cooldown", 0, nil, {
    desc = "Tool Gun Usage Cooldown",
    category = "Protection",
    type = "Float",
    min = 0,
    max = 60
})

lia.config.add("DisableLuaRun", "Disable Lua Run Hooks", false, nil, {
    desc = "Whether or not Lilia should prevent lua_run hooks on maps",
    category = "Protection",
    type = "Boolean"
})

lia.config.add("EquipDelay", "Equip Delay", 0, nil, {
    desc = "Time delay between equipping items.",
    category = "Items",
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("UnequipDelay", "Unequip Delay", 0, nil, {
    desc = "Time delay between unequipping items.",
    category = "Items",
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("DropDelay", "Drop Delay", 0, nil, {
    desc = "Time delay between dropping items.",
    category = "Items",
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("TakeDelay", "Take Delay", 0, nil, {
    desc = "Time delay between taking items.",
    category = "Items",
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("ItemGiveSpeed", "Item Give Speed", 6, nil, {
    desc = "How fast transferring items between players via giveForward is.",
    category = "Items",
    type = "Int",
    min = 1,
    max = 60
})

lia.config.add("ItemGiveEnabled", "Is Item Giving Enabled", true, nil, {
    desc = "Determines if item giving via giveForward is enabled.",
    category = "Items",
    type = "Boolean"
})

lia.config.add("DisableCheaterActions", "Disable Cheater Actions", true, nil, {
    desc = "Prevents flagged cheaters from interacting with the game.",
    category = "Protection",
    type = "Boolean"
})

lia.config.add("MusicVolume", "Music Volume", 0.25, nil, {
    desc = "The volume level for the main menu music",
    category = "Main Menu",
    type = "Float",
    min = 0.0,
    max = 1.0
})

lia.config.add("Music", "Main Menu Music", "", nil, {
    desc = "The file path or URL for the main menu background music",
    category = "Main Menu",
    type = "Generic"
})

lia.config.add("BackgroundURL", "Main Menu Background URL", "", nil, {
    desc = "The URL or file path for the main menu background image",
    category = "Main Menu",
    type = "Generic"
})

lia.config.add("CenterLogo", "Center Logo", "", nil, {
    desc = "The file path or URL for the logo displayed at the center of the screen",
    category = "Main Menu",
    type = "Generic"
})

lia.config.add("DiscordURL", "The Discord of the Server", "https://discord.gg/esCRH5ckbQ", nil, {
    desc = "The URL for the Discord server",
    category = "Main Menu",
    type = "Generic"
})

lia.config.add("Workshop", "The Steam Workshop of the Server", "https://steamcommunity.com/sharedfiles/filedetails/?id=3527535922", nil, {
    desc = "The URL for the Steam Workshop page",
    category = "Main Menu",
    type = "Generic"
})

lia.config.add("CharMenuBGInputDisabled", "Character Menu BG Input Disabled", true, nil, {
    desc = "Whether background input is disabled during character menu use",
    category = "Main Menu",
    type = "Boolean"
})

lia.config.add("vendorDefaultMoney", "Default Vendor Money", 500, nil, {
    desc = "Sets the default amount of money a vendor starts with",
    category = "Vendors",
    type = "Int",
    min = 0,
    max = 100000
})

lia.config.add("invW", "Inventory Width", 6, function(_, newW)
    if not SERVER then return end
    for _, client in pairs(player.GetAll()) do
        if not IsValid(client) then continue end
        local inv = client:getChar():getInv()
        local dw, dh = hook.Run("GetDefaultInventorySize", client)
        dw = dw or newW
        dh = dh or lia.config.get("invH")
        local w, h = inv:getSize()
        if w ~= dw or h ~= dh then
            inv:setSize(dw, dh)
            inv:sync(client)
        end
    end

    local json = util.TableToJSON({newW})
    lia.db.query("UPDATE lia_invdata SET value = '" .. lia.db.escape(json) .. "' WHERE key = 'w' AND invID IN (SELECT invID FROM lia_inventories WHERE charID IS NOT NULL)")
end, {
    desc = "Defines the width of the default inventory.",
    category = "Character",
    type = "Int",
    min = 1,
    max = 10
})

lia.config.add("invH", "Inventory Height", 4, function(_, newH)
    if not SERVER then return end
    for _, client in pairs(player.GetAll()) do
        if not IsValid(client) then continue end
        local inv = client:getChar():getInv()
        local dw, dh = hook.Run("GetDefaultInventorySize", client)
        dw = dw or lia.config.get("invW")
        dh = dh or newH
        local w, h = inv:getSize()
        if w ~= dw or h ~= dh then
            inv:setSize(dw, dh)
            inv:sync(client)
        end
    end

    local json = util.TableToJSON({newH})
    lia.db.query("UPDATE lia_invdata SET value = '" .. lia.db.escape(json) .. "' WHERE key = 'h' AND invID IN (SELECT invID FROM lia_inventories WHERE charID IS NOT NULL)")
end, {
    desc = "Defines the height of the default inventory.",
    category = "Character",
    type = "Int",
    min = 1,
    max = 10
})

lia.config.add("DoorLockTime", "Door Lock Time", 0.5, nil, {
    desc = "Time it takes to lock a door",
    category = "Doors",
    type = "Float",
    min = 0.1,
    max = 10.0
})

lia.config.add("DoorSellRatio", "Door Sell Ratio", 0.5, nil, {
    desc = "Percentage you can sell a door for",
    category = "Doors",
    type = "Float",
    min = 0.0,
    max = 1.0
})

lia.config.add("CustomChatSound", "Custom Chat Sound", "", nil, {
    desc = "Change Chat Sound on Message Send",
    category = "Chat",
    type = "Generic"
})

lia.config.add("ChatColor", "Chat Color", {
    r = 255,
    g = 239,
    b = 150,
    a = 255
}, nil, {
    desc = "Chat Color",
    category = "Chat",
    type = "Color"
})

lia.config.add("ChatRange", "Chat Range", 280, nil, {
    desc = "Range of Chat can be heard",
    category = "Chat",
    type = "Int",
    min = 0,
    max = 10000
})

lia.config.add("OOCLimit", "OOC Character Limit", 150, nil, {
    desc = "Limit of characters on OOC",
    category = "Chat",
    type = "Int",
    min = 10,
    max = 1000
})

lia.config.add("ChatListenColor", "Chat Listen Color", {
    r = 168,
    g = 240,
    b = 170,
    a = 255
}, nil, {
    desc = "Color of chat when directly working at someone",
    category = "Chat",
    type = "Color"
})

lia.config.add("OOCDelay", "OOC Delay", 10, nil, {
    desc = "Set OOC Text Delay",
    category = "Chat",
    type = "Float",
    min = 0,
    max = 60
})

lia.config.add("LOOCDelay", "LOOC Delay", 6, nil, {
    desc = "Set LOOC Text Delay",
    category = "Chat",
    type = "Float",
    min = 0,
    max = 60
})

lia.config.add("LOOCDelayAdmin", "LOOC Delay for Admins", false, nil, {
    desc = "Should Admins have LOOC Delay",
    category = "Chat",
    type = "Boolean"
})

lia.config.add("ChatSizeDiff", "Enable Different Chat Size", false, nil, {
    desc = "Enable Different Chat Size Diff",
    category = "Chat",
    type = "Boolean"
})

lia.config.add("StaminaBlur", "Stamina Blur Enabled", true, nil, {
    desc = "Is Stamina Blur Enabled?",
    category = "Attributes",
    type = "Boolean"
})

lia.config.add("StaminaSlowdown", "Stamina Slowdown Enabled", true, nil, {
    desc = "Is Stamina Slowdown Enabled?",
    category = "Attributes",
    type = "Boolean"
})

lia.config.add("DefaultStamina", "Default Stamina Value", 100, nil, {
    desc = "Sets Default Stamina Value",
    category = "Attributes",
    type = "Int",
    min = 0,
    max = 1000
})

lia.config.add("MaxAttributePoints", "Max Attribute Points", 30, nil, {
    desc = "Maximum number of points that can be allocated across an attribute.",
    category = "Attributes",
    isGlobal = true,
    type = "Int",
    min = 1,
    max = 100
})

lia.config.add("JumpStaminaCost", "Jump Stamina Cost", 10, nil, {
    desc = "Stamina cost deducted when the player jumps",
    category = "Attributes",
    type = "Int",
    min = 0,
    max = 1000
})

lia.config.add("MaxStartingAttributes", "Max Starting Attributes", 30, nil, {
    desc = "Maximum value of each attribute at character creation.",
    category = "Attributes",
    isGlobal = true,
    type = "Int",
    min = 1,
    max = 100
})

lia.config.add("StartingAttributePoints", "Starting Attribute Points", 30, nil, {
    desc = "Total number of points available for starting attribute allocation.",
    category = "Attributes",
    isGlobal = true,
    type = "Int",
    min = 1,
    max = 100
})

lia.config.add("PunchStamina", "Punch Stamina", 10, nil, {
    desc = "Stamina usage for punches.",
    category = "Attributes",
    isGlobal = true,
    type = "Int",
    min = 0,
    max = 100
})

lia.config.add("MaxHoldWeight", "Maximum Hold Weight", 100, nil, {
    desc = "The maximum weight that a player can carry in their hands.",
    category = "General",
    type = "Int",
    min = 1,
    max = 500
})

lia.config.add("ThrowForce", "Throw Force", 100, nil, {
    desc = "How hard a player can throw the item that they're holding.",
    category = "General",
    type = "Int",
    min = 1,
    max = 500
})

lia.config.add("AllowPush", "Allow Push", true, nil, {
    desc = "Whether or not pushing with hands is allowed",
    category = "General",
    type = "Boolean"
})

lia.config.add("SpawnMenuLimit", "Limit Spawn Menu Access", false, nil, {
    desc = "Determines if the spawn menu is limited to PET flag holders or staff",
    category = "Staff",
    type = "Boolean"
})

lia.config.add("LogRetentionDays", "Log Retention Period", 7, nil, {
    desc = "Determines how many days of logs should be read",
    category = "Logging",
    type = "Int",
    min = 3,
    max = 30
})

lia.config.add("MaxLogLines", "Maximum Log Lines", 1000, nil, {
    desc = "Determines the maximum number of log lines to retrieve",
    category = "Logging",
    type = "Int",
    min = 500,
    max = 1000000
})

hook.Add("liaAdminRegisterTab", "liaConfigTab", function(tabs)
    local ConfigFormatting = {
        Int = function(key, name, config, parent)
            local container = vgui.Create("DPanel", parent)
            container:SetTall(220)
            container:Dock(TOP)
            container:DockMargin(0, 60, 0, 10)
            container.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) end
            local panel = container:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = nil
            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:SetTall(45)
            label:SetText(name)
            label:SetFont("ConfigFontLarge")
            label:SetContentAlignment(5)
            label:SetTextColor(Color(255, 255, 255))
            label:DockMargin(0, 20, 0, 0)
            local description = panel:Add("DLabel")
            description:Dock(TOP)
            description:SetTall(35)
            description:SetText(config.desc or "")
            description:SetFont("DescriptionFontLarge")
            description:SetContentAlignment(5)
            description:SetTextColor(Color(200, 200, 200))
            description:DockMargin(0, 10, 0, 0)
            local slider = panel:Add("DNumSlider")
            slider:Dock(FILL)
            slider:DockMargin(10, 0, 10, 0)
            slider:SetMin(lia.config.get(key .. "_min", config.data and config.data.min or 0))
            slider:SetMax(lia.config.get(key .. "_max", config.data and config.data.max or 1))
            slider:SetDecimals(0)
            slider:SetValue(lia.config.get(key, config.value))
            slider:SetText("")
            slider.PerformLayout = function()
                slider.Label:SetWide(0)
                slider.TextArea:SetWide(50)
            end

            slider.OnValueChanged = function(_, v)
                local t = "ConfigChange_" .. key .. "_" .. os.time()
                timer.Create(t, 0.5, 1, function()
                    net.Start("cfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(math.floor(v))
                    net.SendToServer()
                end)
            end
            return container
        end,
        Float = function(key, name, config, parent)
            local container = vgui.Create("DPanel", parent)
            container:SetTall(220)
            container:Dock(TOP)
            container:DockMargin(0, 60, 0, 10)
            container.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) end
            local panel = container:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = nil
            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:SetTall(45)
            label:SetText(name)
            label:SetFont("ConfigFontLarge")
            label:SetContentAlignment(5)
            label:SetTextColor(Color(255, 255, 255))
            label:DockMargin(0, 20, 0, 0)
            local description = panel:Add("DLabel")
            description:Dock(TOP)
            description:SetTall(35)
            description:SetText(config.desc or "")
            description:SetFont("DescriptionFontLarge")
            description:SetContentAlignment(5)
            description:SetTextColor(Color(200, 200, 200))
            description:DockMargin(0, 10, 0, 0)
            local slider = panel:Add("DNumSlider")
            slider:Dock(FILL)
            slider:DockMargin(10, 0, 10, 0)
            slider:SetMin(lia.config.get(key .. "_min", config.data and config.data.min or 0))
            slider:SetMax(lia.config.get(key .. "_max", config.data and config.data.max or 1))
            slider:SetDecimals(2)
            slider:SetValue(lia.config.get(key, config.value))
            slider:SetText("")
            slider.PerformLayout = function()
                slider.Label:SetWide(0)
                slider.TextArea:SetWide(50)
            end

            slider.OnValueChanged = function(_, v)
                local t = "ConfigChange_" .. key .. "_" .. os.time()
                timer.Create(t, 0.5, 1, function()
                    net.Start("cfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(tonumber(v))
                    net.SendToServer()
                end)
            end
            return container
        end,
        Generic = function(key, name, config, parent)
            local container = vgui.Create("DPanel", parent)
            container:SetTall(220)
            container:Dock(TOP)
            container:DockMargin(0, 60, 0, 10)
            container.Paint = function() end
            local panel = container:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = nil
            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:SetTall(45)
            label:SetText(name)
            label:SetFont("ConfigFontLarge")
            label:SetContentAlignment(5)
            label:SetTextColor(Color(255, 255, 255))
            label:DockMargin(0, 20, 0, 0)
            local description = panel:Add("DLabel")
            description:Dock(TOP)
            description:SetTall(35)
            description:SetText(config.desc or "")
            description:SetFont("DescriptionFontLarge")
            description:SetContentAlignment(5)
            description:SetTextColor(Color(200, 200, 200))
            description:DockMargin(0, 10, 0, 0)
            local entry = panel:Add("DTextEntry")
            entry:Dock(TOP)
            entry:SetTall(60)
            entry:DockMargin(300, 10, 300, 0)
            entry:SetText(tostring(lia.config.get(key, config.value)))
            entry:SetFont("ConfigFontLarge")
            entry:SetTextColor(Color(255, 255, 255))
            entry.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
            end

            entry.OnEnter = function()
                local t = "ConfigChange_" .. key .. "_" .. os.time()
                timer.Create(t, 0.5, 1, function()
                    net.Start("cfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(entry:GetText())
                    net.SendToServer()
                end)
            end
            return container
        end,
        Boolean = function(key, name, config, parent)
            local container = vgui.Create("DPanel", parent)
            container:SetTall(220)
            container:Dock(TOP)
            container:DockMargin(0, 60, 0, 10)
            container.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) end
            local panel = container:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = nil
            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:SetTall(45)
            label:SetText(name)
            label:SetFont("ConfigFontLarge")
            label:SetContentAlignment(5)
            label:SetTextColor(Color(255, 255, 255))
            label:DockMargin(0, 20, 0, 0)
            local description = panel:Add("DLabel")
            description:Dock(TOP)
            description:SetTall(35)
            description:SetText(config.desc or "")
            description:SetFont("DescriptionFontLarge")
            description:SetContentAlignment(5)
            description:SetTextColor(Color(200, 200, 200))
            description:DockMargin(0, 10, 0, 0)
            local button = panel:Add("DButton")
            button:Dock(TOP)
            button:SetTall(120)
            button:DockMargin(90, 10, 90, 10)
            button:SetText("")
            button.Paint = function(_, w, h)
                local v = lia.config.get(key, config.value)
                local ic = v and "checkbox.png" or "unchecked.png"
                lia.util.drawTexture(ic, color_white, w / 2 - 48, h / 2 - 64, 96, 96)
            end

            button.DoClick = function()
                local t = "ConfigChange_" .. key .. "_" .. os.time()
                timer.Create(t, 0.5, 1, function()
                    net.Start("cfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(not lia.config.get(key, config.value))
                    net.SendToServer()
                end)
            end
            return container
        end,
        Color = function(key, name, config, parent)
            local container = vgui.Create("DPanel", parent)
            container:SetTall(220)
            container:Dock(TOP)
            container:DockMargin(0, 60, 0, 10)
            container.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) end
            local panel = container:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = nil
            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:SetTall(45)
            label:SetText(name)
            label:SetFont("ConfigFontLarge")
            label:SetContentAlignment(5)
            label:SetTextColor(Color(255, 255, 255))
            label:DockMargin(0, 20, 0, 0)
            local description = panel:Add("DLabel")
            description:Dock(TOP)
            description:SetTall(35)
            description:SetText(config.desc or "")
            description:SetFont("DescriptionFontLarge")
            description:SetContentAlignment(5)
            description:SetTextColor(Color(200, 200, 200))
            description:DockMargin(0, 10, 0, 0)
            local button = panel:Add("DButton")
            button:Dock(FILL)
            button:DockMargin(10, 0, 10, 0)
            button:SetText("")
            button.Paint = function(_, w, h)
                local c = lia.config.get(key, config.value)
                surface.SetDrawColor(c)
                surface.DrawRect(10, h / 2 - 15, w - 20, 30)
                draw.RoundedBox(2, 10, h / 2 - 15, w - 20, 30, Color(255, 255, 255, 50))
            end

            button.DoClick = function()
                if IsValid(button.picker) then button.picker:Remove() end
                local f = vgui.Create("DFrame")
                f:SetSize(300, 400)
                f:Center()
                f:MakePopup()
                local m = f:Add("DColorMixer")
                m:Dock(FILL)
                m:SetPalette(true)
                m:SetAlphaBar(true)
                m:SetWangs(true)
                m:SetColor(lia.config.get(key, config.value))
                local apply = f:Add("DButton")
                apply:Dock(BOTTOM)
                apply:SetTall(40)
                apply:SetText(L("apply"))
                apply:SetFont("ConfigFontLarge")
                apply.Paint = function(_, w, h)
                    surface.SetDrawColor(Color(0, 150, 0))
                    surface.DrawRect(0, 0, w, h)
                    if apply:IsHovered() then
                        surface.SetDrawColor(Color(0, 180, 0))
                        surface.DrawRect(0, 0, w, h)
                    end

                    surface.SetDrawColor(Color(255, 255, 255))
                    surface.DrawOutlinedRect(0, 0, w, h)
                end

                apply.DoClick = function()
                    local color = m:GetColor()
                    local t = "ConfigChange_" .. key .. "_" .. os.time()
                    timer.Create(t, 0.5, 1, function()
                        net.Start("cfgSet")
                        net.WriteString(key)
                        net.WriteString(name)
                        net.WriteType(color)
                        net.SendToServer()
                    end)

                    f:Remove()
                end

                button.picker = f
            end
            return container
        end,
        Table = function(key, name, config, parent)
            local container = vgui.Create("DPanel", parent)
            container:SetTall(220)
            container:Dock(TOP)
            container:DockMargin(0, 60, 0, 10)
            container.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) end
            local panel = container:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = nil
            local label = panel:Add("DLabel")
            label:Dock(TOP)
            label:SetTall(45)
            label:SetText(name)
            label:SetFont("ConfigFontLarge")
            label:SetContentAlignment(5)
            label:SetTextColor(Color(255, 255, 255))
            label:DockMargin(0, 20, 0, 0)
            local description = panel:Add("DLabel")
            description:Dock(TOP)
            description:SetTall(35)
            description:SetText(config.desc or "")
            description:SetFont("DescriptionFontLarge")
            description:SetContentAlignment(5)
            description:SetTextColor(Color(200, 200, 200))
            description:DockMargin(0, 10, 0, 0)
            local combo = panel:Add("DComboBox")
            combo:Dock(TOP)
            combo:SetTall(60)
            combo:DockMargin(300, 10, 300, 0)
            combo:SetValue(tostring(lia.config.get(key, config.value)))
            combo:SetFont("ConfigFontLarge")
            combo.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
            end

            for _, o in ipairs(config.data and config.data.options or {}) do
                combo:AddChoice(o)
            end

            combo.OnSelect = function(_, _, v)
                local t = "ConfigChange_" .. key .. "_" .. os.time()
                timer.Create(t, 0.5, 1, function()
                    net.Start("cfgSet")
                    net.WriteString(key)
                    net.WriteString(name)
                    net.WriteType(v)
                    net.SendToServer()
                end)
            end
            return container
        end
    }

    local function buildConfiguration(parent)
        parent:Clear()
        local search = vgui.Create("DTextEntry", parent)
        search:Dock(TOP)
        search:SetTall(30)
        search:DockMargin(5, 5, 5, 5)
        search:SetPlaceholderText(L("searchConfigs"))
        local scroll = vgui.Create("DScrollPanel", parent)
        scroll:Dock(FILL)
        local function populate(filter)
            scroll:Clear()
            local categories = {}
            local keys = {}
            for k in pairs(lia.config.stored) do
                keys[#keys + 1] = k
            end

            table.sort(keys, function(a, b) return lia.config.stored[a].name < lia.config.stored[b].name end)
            for _, k in ipairs(keys) do
                local opt = lia.config.stored[k]
                local n = opt.name or ""
                local d = opt.desc or ""
                local ln, ld = n:lower(), d:lower()
                if filter == "" or ln:find(filter, 1, true) or ld:find(filter, 1, true) then
                    local cat = opt.category or "Miscellaneous"
                    categories[cat] = categories[cat] or {}
                    categories[cat][#categories[cat] + 1] = {
                        key = k,
                        name = n,
                        config = opt,
                        elemType = opt.data and opt.data.type or "Generic"
                    }
                end
            end

            local categoryNames = {}
            for name in pairs(categories) do
                categoryNames[#categoryNames + 1] = name
            end

            table.sort(categoryNames)
            for _, categoryName in ipairs(categoryNames) do
                local items = categories[categoryName]
                local cat = vgui.Create("DCollapsibleCategory", scroll)
                cat:Dock(TOP)
                cat:SetLabel(categoryName)
                cat:SetExpanded(true)
                cat:DockMargin(0, 0, 0, 10)
                cat.Header:SetContentAlignment(5)
                cat.Header:SetTall(30)
                cat.Header:SetFont("liaMediumFont")
                cat.Header:SetTextColor(Color(255, 255, 255))
                cat.Paint = function() end
                cat.Header.Paint = function(_, w, h)
                    surface.SetDrawColor(0, 0, 0, 255)
                    surface.DrawOutlinedRect(0, 0, w, h, 2)
                    surface.SetDrawColor(0, 0, 0, 150)
                    surface.DrawRect(1, 1, w - 2, h - 2)
                end

                cat.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 60)) end
                local body = vgui.Create("DPanel", cat)
                body:SetTall(#items * 240)
                body.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 50)) end
                cat:SetContents(body)
                for _, it in ipairs(items) do
                    local el = ConfigFormatting[it.elemType](it.key, it.name, it.config, body)
                    el:Dock(TOP)
                    el:DockMargin(10, 10, 10, 0)
                    el.Paint = function(_, w, h)
                        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
                        surface.SetDrawColor(255, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h)
                    end
                end
            end
        end

        search.OnTextChanged = function() populate(search:GetValue():lower()) end
        populate("")
    end

    if hook.Run("CanPlayerModifyConfig", LocalPlayer()) ~= false and LocalPlayer():hasPrivilege("Admin Tab - Config") then
        tabs["Config"] = {
            icon = "icon16/wrench.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                buildConfiguration(pnl)
                return pnl
            end
        }
    end
end)
