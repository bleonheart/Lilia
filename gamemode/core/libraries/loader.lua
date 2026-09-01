lia.reloadInProgress = false
lia.isReloading = false
local FilesToLoad = {
    {
        path = "lilia/gamemode/core/libraries/keybind.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/playerinteract.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/dialog.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/admin.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/workshop.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/fonts.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/option.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/util.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/notice.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/performance.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/character.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/character.lua",
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
        path = "lilia/gamemode/core/libraries/logger.lua",
        realm = "server"
    },
    {
        path = "lilia/gamemode/core/libraries/modularity.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/chatbox.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/commands.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/flags.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/inventory.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/inventory.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/item.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/item.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/core/webcontent/core.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/core/webcontent/netcalls.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/attributes.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/factions.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/classes.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/camera.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/view.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/currency.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/vendor.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/doors.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/time.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/entity.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/player.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/panel.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/darkrp.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/menu.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/bars.lua",
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

function lia.loader.include(path, realm)
    if not path then lia.error(L("missingFilePath")) end
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

function lia.loader.includeGroupedDir(dir, raw, recursive, forceRealm)
    local baseDir = raw and dir or (SCHEMA and SCHEMA.folder and SCHEMA.loading and SCHEMA.folder .. "/schema" or "lilia/gamemode") .. "/" .. dir
    local stack = {baseDir}
    while #stack > 0 do
        local path = table.remove(stack)
        local files, folders = file.Find(path .. "/*.lua", "LUA")
        table.sort(files)
        for _, fileName in ipairs(files) do
            local realm = forceRealm
            if not realm then
                local prefix = fileName:sub(1, 3)
                realm = (prefix == "sh_" or fileName == "shared.lua") and "shared" or (prefix == "sv_" or fileName == "server.lua") and "server" or (prefix == "cl_" or fileName == "client.lua") and "client" or "shared"
            end

            local filePath = path .. "/" .. fileName
            if file.Exists(filePath, "LUA") then lia.loader.include(filePath, realm) end
        end

        if recursive then
            for _, subfolder in ipairs(folders) do
                table.insert(stack, path .. "/" .. subfolder)
            end
        end
    end
end

lia.loader.include("lilia/gamemode/core/libraries/core/languages/core.lua", "shared")
lia.loader.includeDir("lilia/gamemode/core/libraries/thirdparty", true, true)
lia.loader.include("lilia/gamemode/core/libraries/core/net/core.lua", "shared")
lia.loader.include("lilia/gamemode/core/libraries/core/config/core.lua", "shared")
lia.loader.include("lilia/gamemode/core/libraries/core/color/core.lua", "shared")
lia.loader.include("lilia/gamemode/core/libraries/core/derma/core.lua", "client")
lia.loader.includeDir("lilia/gamemode/core/derma", true, true, "client")
lia.loader.include("lilia/gamemode/core/libraries/core/database/core.lua", "server")
lia.loader.include("lilia/gamemode/core/libraries/core/data/core.lua", "shared")
for _, files in ipairs(FilesToLoad) do
    lia.loader.include(files.path, files.realm)
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
        lia.db.connect(function()
            lia.db.loadTables()
            hook.Run("DatabaseConnected")
        end)
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
        lia.reloadInProgress = true
        lia.isReloading = true
    end

    if isReload or not hasInitializedModules then
        lia.module.initialize()
        if not isReload then hasInitializedModules = true end
    end

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
