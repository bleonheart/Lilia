﻿lia.module = lia.module or {}
lia.module.list = lia.module.list or {}
local ModuleFolders = {"config", "dependencies", "libs", "hooks", "libraries", "commands", "netcalls", "meta", "derma", "pim"}
local ModuleFiles = {"pim.lua", "client.lua", "server.lua", "config.lua", "commands.lua"}
local function loadPermissions(Privileges)
    if not Privileges or not istable(Privileges) then return end
    for _, privilegeData in ipairs(Privileges) do
        local privilegeName = privilegeData.Name
        if not CAMI.GetPrivilege(privilegeName) then
            CAMI.RegisterPrivilege({
                Name = privilegeName,
                MinAccess = privilegeData.MinAccess or "admin"
            })
        end
    end
end

local function loadDependencies(dependencies)
    if not istable(dependencies) then return end
    for _, dep in ipairs(dependencies) do
        local realm = dep.Realm
        if dep.File then
            lia.include(MODULE.folder .. "/" .. dep.File, realm)
        elseif dep.Folder then
            lia.includeDir(MODULE.folder .. "/" .. dep.Folder, true, true, realm)
        end
    end
end

local function loadExtras(path)
    lia.lang.loadFromDir(path .. "/languages")
    lia.faction.loadFromDir(path .. "/factions")
    lia.class.loadFromDir(path .. "/classes")
    lia.attribs.loadFromDir(path .. "/attributes")
    for _, fileName in ipairs(ModuleFiles) do
        local filePath = path .. "/" .. fileName
        if file.Exists(filePath, "LUA") then lia.include(filePath) end
    end

    for _, folder in ipairs(ModuleFolders) do
        local subPath = path .. "/" .. folder
        if file.Exists(subPath, "LUA") then lia.includeDir(subPath, true, true) end
    end

    lia.includeEntities(path .. "/entities")
    if MODULE.uniqueID ~= "schema" then lia.item.loadFromDir(path .. "/items") end
    hook.Run("DoModuleIncludes", path, MODULE)
end

local function loadSubmodules(path)
    local files, folders = file.Find(path .. "/submodules/*", "LUA")
    if #files > 0 or #folders > 0 then lia.module.loadFromDir(path .. "/submodules", "module") end
end

local function collectModuleIDs(directory)
    local ids = {}
    if not directory then return ids end
    local _, folders = file.Find(directory .. "/*", "LUA")
    for _, folderName in ipairs(folders) do
        ids[folderName] = true
    end
    return ids
end

function lia.module.load(uniqueID, path, isSingleFile, variable, skipSubmodules)
    variable = variable or "MODULE"
    local lowerVar = variable:lower()
    local coreFile = path .. "/" .. lowerVar .. ".lua"
    local prev = _G[variable]
    local existing = lia.module.list[uniqueID]
    MODULE = {
        folder = path,
        module = existing or prev,
        uniqueID = uniqueID,
        name = L("unknown"),
        desc = L("noDesc"),
        author = L("anonymous"),
        enabled = true,
        IsValid = function() return true end
    }

    if uniqueID == "schema" then
        if SCHEMA then MODULE = SCHEMA end
        variable = "SCHEMA"
        MODULE.folder = engine.ActiveGamemode()
    end

    _G[variable] = MODULE
    MODULE.loading = true
    MODULE.path = path
    if isSingleFile then
        lia.include(path, "shared")
    else
        if not file.Exists(coreFile, "LUA") then
            lia.bootstrap("Module Skipped", L("moduleSkipMissing", uniqueID, lowerVar))
            _G[variable] = prev
            return
        end

        lia.include(coreFile, "shared")
    end

    local enabled, disableReason
    if isfunction(MODULE.enabled) then
        enabled, disableReason = MODULE.enabled()
    else
        enabled = MODULE.enabled
    end

    if uniqueID ~= "schema" and not enabled then
        if disableReason then
            lia.bootstrap("Module Disabled", disableReason)
        else
            lia.bootstrap("Module Disabled", L("moduleDisabled", MODULE.name))
        end

        _G[variable] = prev
        return
    end

    loadPermissions(MODULE.CAMIPrivileges)
    if not isSingleFile then
        loadDependencies(MODULE.Dependencies)
        loadExtras(path)
    end

    MODULE.loading = false
    local idKey = uniqueID == "schema" and MODULE.name or uniqueID
    function MODULE:setData(v, g, m)
        lia.data.set(idKey, v, g, m)
    end

    function MODULE:getData(d, g, m, r)
        return lia.data.get(idKey, d, g, m, r) or {}
    end

    for k, f in pairs(MODULE) do
        if isfunction(f) then hook.Add(k, MODULE, f) end
    end

    if uniqueID == "schema" then
        function MODULE:IsValid()
            return true
        end
    else
        lia.module.list[uniqueID] = MODULE
        if not skipSubmodules then loadSubmodules(path) end
        if MODULE.ModuleLoaded then MODULE:ModuleLoaded() end
        if MODULE.Public then
            lia.module.versionChecks = lia.module.versionChecks or {}
            table.insert(lia.module.versionChecks, {
                uniqueID = MODULE.uniqueID,
                name = MODULE.name,
                localVersion = MODULE.version,
            })
        end

        if MODULE.Private then
            lia.module.privateVersionChecks = lia.module.privateVersionChecks or {}
            table.insert(lia.module.privateVersionChecks, {
                uniqueID = MODULE.uniqueID,
                name = MODULE.name,
                localVersion = MODULE.version,
            })
        end

        if string.StartsWith(path, engine.ActiveGamemode() .. "/modules") then lia.bootstrap("Module", L("moduleFinishedLoading", MODULE.name)) end
        _G[variable] = prev
    end
end

function lia.module.initialize()
    local schemaPath = engine.ActiveGamemode()
    lia.module.load("schema", schemaPath .. "/schema", false, "schema")
    hook.Run("InitializedSchema")
    local preloadPath = schemaPath .. "/preload"
    local preloadIDs = collectModuleIDs(preloadPath)
    lia.module.loadFromDir(preloadPath, "module")
    local gamemodeIDs = collectModuleIDs(schemaPath .. "/modules")
    for id in pairs(collectModuleIDs(schemaPath .. "/overrides")) do
        gamemodeIDs[id] = true
    end

    for id in pairs(collectModuleIDs("lilia/modules")) do
        if not preloadIDs[id] and gamemodeIDs[id] then lia.bootstrap("Module", L("modulePreloadSuggestion", id)) end
    end

    lia.module.loadFromDir("lilia/modules", "module", preloadIDs)
    lia.module.loadFromDir(schemaPath .. "/modules", "module")
    lia.module.loadFromDir(schemaPath .. "/overrides", "module")
    hook.Run("InitializedModules")
    lia.item.loadFromDir(schemaPath .. "/schema/items")
    for id, mod in pairs(lia.module.list) do
        if id ~= "schema" then
            local ok = isfunction(mod.enabled) and mod.enabled() or mod.enabled
            if not ok then lia.module.list[id] = nil end
        end
    end
end

function lia.module.loadFromDir(directory, group, skip)
    local locationVar = group == "schema" and "SCHEMA" or "MODULE"
    local _, folders = file.Find(directory .. "/*", "LUA")
    for _, folderName in ipairs(folders) do
        if not skip or not skip[folderName] then lia.module.load(folderName, directory .. "/" .. folderName, false, locationVar) end
    end
end

function lia.module.get(identifier)
    return lia.module.list[identifier]
end
