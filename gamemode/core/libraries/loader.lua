lia.reloadInProgress = false
lia.isReloading = false
local FilesToLoad = {
    {
        path = "lilia/gamemode/core/libraries/versioning.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/keybind",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/playerinteract",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/dialog",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/admin",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/workshop",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/fonts",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/option",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/util",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/notice",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/performance.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/character",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/hooks/shared.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/hooks/client.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/hooks/server.lua",
        realm = "server"
    },
    {
        path = "lilia/gamemode/core/libraries/core/logger",
        realm = "server"
    },
    {
        path = "lilia/gamemode/core/libraries/core/modularity",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/chatbox",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/commands",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/flags",
        package = true,
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/inventory",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/item",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/webimage",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/core/websound",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/core/attributes",
        package = true,
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/factions",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/classes",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/camera",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/core/currency",
        package = true,
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/vendor",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/doors",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/time",
        package = true,
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/sit",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/entity",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/player",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/darkrp",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/menu",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/core/bars",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/netcalls/client.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/netcalls/server.lua",
        realm = "server"
    },
}

local ConditionalFiles = {
    {
        path = "lilia/gamemode/core/libraries/compatibility/vcmod/core.lua",
        global = "VCMod",
        name = "VCMod",
        realm = "shared",
        callback = function() return "Uses Lilia character money." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/vjbase/core.lua",
        global = "VJ",
        name = "VJ",
        realm = "server",
        callback = function() return "Secures VJ spawners and NPCs." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/advdupe/core.lua",
        global = "AdvDupe",
        name = "AdvDupe",
        realm = "server",
        callback = function() return "Secures duplicated entities." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/advdupe2/core.lua",
        global = "AdvDupe2",
        name = "AdvDupe2",
        realm = "server",
        callback = function() return "Secures AdvDupe2 pastes." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/mediaplayer/core.lua",
        global = "MediaPlayer",
        name = "Media Player",
        realm = "shared",
        callback = function() return "Secures media history queries." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/pac/core.lua",
        global = "pac",
        name = "PAC3",
        realm = "shared",
        callback = function() return "Integrates PAC items and permissions." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/prone/core.lua",
        global = "prone",
        name = "Prone",
        realm = "server",
        callback = function() return "Resets prone state safely." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/cami/core.lua",
        global = "CAMI",
        name = "CAMI",
        realm = "shared",
        callback = function() return "Syncs CAMI permissions and groups." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/ulx/core.lua",
        global = "ulx",
        name = "ULX",
        realm = "shared",
        callback = function() return "Syncs ULX permissions and commands." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/serverguard/core.lua",
        global = "serverguard",
        name = "ServerGuard",
        realm = "shared",
        callback = function() return "Syncs ServerGuard administration." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/sam/core.lua",
        global = "sam",
        name = "SAM | Admin Mod",
        realm = "shared",
        callback = function() return "Syncs SAM administration and playtime." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/sadmin/core.lua",
        condition = function() return sadmin ~= nil or concommand.GetTable().sa ~= nil end,
        name = "sAdmin",
        realm = "server",
        callback = function() return "Routes administration through sAdmin." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/simfphys/core.lua",
        global = "simfphys",
        name = "Simfphys Vehicles",
        realm = "shared",
        callback = function() return "Integrates Simfphys vehicle rules." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/sitanywhere/core.lua",
        global = "SitAnywhere",
        name = "Sit Anywhere",
        realm = "shared",
        callback = function() return "Disables conflicting Sit Anywhere features." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/permaprops/core.lua",
        global = "PermaProps",
        name = "PermaProps",
        realm = "server",
        callback = function() return "Protects Lilia entities from PermaProps." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/arccw/core.lua",
        global = "ArcCWInstalled",
        name = "ArcCW",
        realm = "shared",
        callback = function() return "Integrates ArcCW attachments and inventory." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/wiremod/core.lua",
        global = "WireLib",
        name = "Wiremod",
        realm = "server",
        callback = function() return "Secures Expression 2 uploads." end
    },
    {
        path = "lilia/gamemode/core/libraries/compatibility/vmanip/core.lua",
        global = "VManip",
        name = "VManip",
        realm = "shared",
        callback = function() return "Adds VManip pickup animations." end
    },
}

function lia.loader.include(path, realm)
    if not path then lia.error("Missing file path") end
    path = path:gsub("\\", "/")
    local resolved = realm
    if not resolved then
        local filename = path:match("([^/\\]+)%.lua$")
        if filename then
            local prefix = filename:sub(1, 3)
            if prefix == "sv_" or filename == "server" then
                resolved = "server"
            elseif prefix == "cl_" or filename == "client" then
                resolved = "client"
            elseif prefix == "sh_" or filename == "shared" then
                resolved = "shared"
            end
        end

        resolved = resolved or "shared"
    end

    if resolved == "server" then
        if SERVER then include(path) end
    elseif resolved == "client" then
        if SERVER then
            AddCSLuaFile(path)
        else
            include(path)
        end
    else
        if SERVER then AddCSLuaFile(path) end
        include(path)
    end
end

function lia.loader.includeDir(dir, raw, deep, realm)
    local root = raw and dir or (SCHEMA and SCHEMA.folder and SCHEMA.loading and SCHEMA.folder .. "/schema" or "lilia/gamemode") .. "/" .. dir
    local function loadDir(folder)
        for _, fileName in ipairs(file.Find(folder .. "/*.lua", "LUA")) do
            lia.loader.include(folder .. "/" .. fileName, realm)
        end

        if deep then
            for _, subFolder in ipairs(select(2, file.Find(folder .. "/*", "LUA"))) do
                loadDir(folder .. "/" .. subFolder)
            end
        end
    end

    loadDir(root)
end

local libraryLoadOrder = {}
function lia.loader.includeCoreLibrary(entry)
    if not entry.package and entry.path:sub(-4) == ".lua" then
        libraryLoadOrder[#libraryLoadOrder + 1] = {
            category = "Base",
            path = entry.path,
            realm = entry.realm or "shared"
        }

        lia.loader.include(entry.path, entry.realm)
        return
    end

    local basePath = entry.path
    if not file.Exists(basePath .. "/core.lua", "LUA") then
        local nestedBasePath = basePath:gsub("/libraries/", "/libraries/core/", 1)
        if file.Exists(nestedBasePath .. "/core.lua", "LUA") then basePath = nestedBasePath end
    end

    for _, component in ipairs({"core.lua", "netcalls.lua", "commands.lua", "meta.lua"}) do
        local path = basePath .. "/" .. component
        if file.Exists(path, "LUA") then
            libraryLoadOrder[#libraryLoadOrder + 1] = {
                category = "Base",
                path = path,
                realm = entry.realm or "shared"
            }

            lia.loader.include(path, entry.realm)
        end
    end
end

lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/languages",
    package = true,
    realm = "shared"
})

lia.loader.includeDir("lilia/gamemode/core/libraries/thirdparty", true, true)
lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/net",
    package = true,
    realm = "shared"
})

lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/config",
    package = true,
    realm = "shared"
})

lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/color",
    package = true,
    realm = "shared"
})

lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/derma",
    package = true,
    realm = "client"
})

lia.loader.includeDir("lilia/gamemode/core/derma", true, true, "client")
lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/database",
    package = true,
    realm = "server"
})

lia.loader.includeCoreLibrary({
    path = "lilia/gamemode/core/libraries/core/data",
    package = true,
    realm = "shared"
})

for _, files in ipairs(FilesToLoad) do
    lia.loader.includeCoreLibrary(files)
end

function lia.loader.includeEntities(path)
    local function IncludeFiles(path2)
        if file.Exists(path2 .. "init.lua", "LUA") then lia.loader.include(path2 .. "init.lua", "server") end
        if file.Exists(path2 .. "shared.lua", "LUA") then lia.loader.include(path2 .. "shared.lua", "shared") end
        if file.Exists(path2 .. "cl_init.lua", "LUA") then lia.loader.include(path2 .. "cl_init.lua", "client") end
    end

    local function stripRealmPrefix(name)
        local prefix = name:sub(1, 3)
        return (prefix == "sh_" or prefix == "sv_" or prefix == "cl_") and name:sub(4) or name
    end

    local function HandleEntityInclusion(folder, variable, register, default, clientOnly, create, complete)
        local files, folders = file.Find(path .. "/" .. folder .. "/*", "LUA")
        default = default or {}
        for _, v in ipairs(folders) do
            local path2 = path .. "/" .. folder .. "/" .. v .. "/"
            local hasInit = file.Exists(path2 .. "init.lua", "LUA")
            local hasShared = file.Exists(path2 .. "shared.lua", "LUA")
            local hasClientInit = file.Exists(path2 .. "cl_init.lua", "LUA")
            if v ~= "gmod_tool" and not hasInit and not hasShared and not hasClientInit then
                local childFiles, childFolders = file.Find(path2 .. "*", "LUA")
                if #childFiles == 0 and #childFolders == 0 then continue end
                lia.error("Warning: No init.lua, shared.lua, or cl_init.lua found in entity folder: " .. path2 .. ". This may make the entity not load properly.")
                continue
            end

            v = stripRealmPrefix(v)
            _G[variable] = table.Copy(default)
            if not isfunction(create) then
                _G[variable].ClassName = v
            else
                create(v)
            end

            IncludeFiles(path2)
            if clientOnly then
                if CLIENT then register(_G[variable], v) end
            else
                register(_G[variable], v)
            end

            if isfunction(complete) then complete(_G[variable]) end
            _G[variable] = nil
        end

        for _, v in ipairs(files) do
            local niceName = stripRealmPrefix(string.StripExtension(v))
            _G[variable] = table.Copy(default)
            if not isfunction(create) then
                _G[variable].ClassName = niceName
            else
                create(niceName)
            end

            lia.loader.include(path .. "/" .. folder .. "/" .. v, clientOnly and "client" or "shared")
            if clientOnly then
                if CLIENT then register(_G[variable], niceName) end
            else
                register(_G[variable], niceName)
            end

            if isfunction(complete) then complete(_G[variable]) end
            _G[variable] = nil
        end
    end

    HandleEntityInclusion("entities", "ENT", scripted_ents.Register, {
        Type = "anim",
        Base = "base_gmodentity",
        Spawnable = true
    }, false)

    HandleEntityInclusion("weapons", "SWEP", weapons.Register, {
        Primary = {},
        Secondary = {},
        Base = "weapon_base"
    })

    HandleEntityInclusion("effects", "EFFECT", effects and effects.Register, nil, true)
end

if SERVER then
    local function SetupDatabase()
        hook.Run("SetupDatabase")
        lia.db.connect(function() lia.db.loadTables(function() hook.Run("DatabaseConnected") end) end, false, function(message) lia.error("Database startup stopped: " .. tostring(message)) end)
    end

    local function SetupPersistence()
        cvars.AddChangeCallback("sbox_persist", function(_, old, new)
            timer.Create("sbox_persist_change_timer", 1, 1, function()
                hook.Run("PersistenceSave", old)
                game.CleanUpMap(false, nil, function() end)
                if new ~= "" then hook.Run("PersistenceLoad", new) end
            end)
        end, "sbox_persist_load")
    end

    local function BootstrapLilia()
        timer.Simple(0, SetupDatabase)
        SetupPersistence()
    end

    BootstrapLilia()
else
    local oldLocalPlayer = LocalPlayer
    function LocalPlayer()
        lia.localClient = IsValid(lia.localClient) and lia.localClient or oldLocalPlayer()
        return lia.localClient
    end

    timer.Remove("HintSystem_OpeningMenu")
    timer.Remove("HintSystem_Annoy1")
    timer.Remove("HintSystem_Annoy2")
end

local hasInitializedModules = false
function lia.loader.initializeGamemode(isReload)
    if isReload then
        if lia.reloadInProgress then return end
        timer.Remove("liaReloadConfigSync")
        timer.Remove("liaReloadAdminSync")
        timer.Remove("liaReloadPlayerInteractSync")
        timer.Remove("liaReloadComplete")
        lia.net.buffers = {}
        lia.net.sendq = {}
        lia.net.cache = {}
        lia.reloadInProgress = true
        lia.isReloading = true
    end

    if isReload or not hasInitializedModules then
        lia.module.initialize()
        if not isReload then hasInitializedModules = true end
    end

    lia.faction.formatModelData()
    if SERVER and isReload then
        lia.config.load()
        local adminHasChanges = lia.admin.hasChanges()
        local playerInteractHasChanges = lia.playerinteract.hasChanges()
        timer.Create("liaReloadConfigSync", 0.5, 1, function()
            for _, client in player.Iterator() do
                if IsValid(client) then lia.config.send(client) end
            end
        end)

        timer.Create("liaReloadAdminSync", 2.0, 1, function() if adminHasChanges then lia.admin.sync() end end)
        timer.Create("liaReloadPlayerInteractSync", 3.5, 1, function() if playerInteractHasChanges then lia.playerinteract.sync() end end)
        timer.Create("liaReloadComplete", 5.0, 1, function()
            lia.reloadInProgress = false
            timer.Simple(1.0, function() collectgarbage("collect") end)
        end)
    end

    if isReload then
        lia.bootstrap("HotReload", "Gamemode hotreloaded successfully!")
        lia.isReloading = false
    end
end

local function CreateCharacterSaveTimer()
    local saveInterval = lia.config.get("CharacterDataSaveInterval")
    local saveTimer = function()
        for _, client in player.Iterator() do
            if IsValid(client) and client:getChar() then client:getChar():save() end
        end
    end

    if timer.Exists("liaSaveCharGlobal") then
        timer.Adjust("liaSaveCharGlobal", saveInterval, 0, saveTimer)
    else
        timer.Create("liaSaveCharGlobal", saveInterval, 0, saveTimer)
    end
end

function GM:Initialize()
    if engine.ActiveGamemode() == "lilia" then lia.error("No schema loaded. Please place the schema in your gamemodes folder, then set it as your gamemode.") end
    lia.loader.initializeGamemode(false)
    if SERVER then CreateCharacterSaveTimer() end
end

function GM:OnReloaded()
    lia.loader.initializeGamemode(true)
    if CLIENT then
        hook.Run("PreLiliaLoaded")
        lia.option.load()
        lia.keybind.load()
        hook.Run("LiliaLoaded")
    end

    if SERVER then CreateCharacterSaveTimer() end
end

if game.IsDedicated() then concommand.Remove("gm_save") end