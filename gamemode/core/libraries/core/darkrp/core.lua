lia.darkrp = lia.darkrp or {}
lia.darkrp.api = lia.darkrp.api or {}
lia.darkrp.jobs = lia.darkrp.jobs or {}
lia.darkrp.categories = lia.darkrp.categories or {}
lia.darkrp.jobByCommand = lia.darkrp.jobByCommand or {}
lia.darkrp.includeStack = lia.darkrp.includeStack or {}
lia.darkrp.api.disabledDefaults = lia.darkrp.api.disabledDefaults or {}
local function makeUniqueID(prefix, value)
    local raw = tostring(value or "")
    local uniqueID = raw:lower():gsub("[^%w_]+", "_"):gsub("^_+", ""):gsub("_+$", "")
    if uniqueID == "" then uniqueID = "unnamed" end
    return prefix .. uniqueID
end

local function normalizeModels(models)
    if isstring(models) then return {models} end
    if not istable(models) then return {} end
    local result = {}
    for _, model in pairs(models) do
        if isstring(model) then
            result[#result + 1] = model
        elseif istable(model) then
            local path = model.model or model[1]
            if isstring(path) then result[#result + 1] = path end
        end
    end
    return result
end

local function addFactionModels(faction, models)
    faction.models = faction.models or {}
    local existing = {}
    for _, model in pairs(faction.models) do
        if isstring(model) then existing[model] = true end
    end

    for _, model in ipairs(normalizeModels(models)) do
        if not existing[model] then
            faction.models[#faction.models + 1] = model
            existing[model] = true
        end
    end

    lia.faction.cacheModels(faction.models)
end

local function ensureFaction(categoryName, data)
    categoryName = categoryName or "Other"
    data = data or {}
    local stored = lia.darkrp.categories[categoryName]
    local uniqueID = stored and stored.uniqueID or makeUniqueID("darkrp_", categoryName)
    local existing = lia.faction.teams[uniqueID]
    local models = existing and table.Copy(existing.models or {}) or {}
    local isDefault = existing and existing.isDefault
    if isDefault == nil then isDefault = true end
    local index, faction = lia.faction.register(uniqueID, {
        index = existing and existing.index or nil,
        name = categoryName,
        desc = data.description or data.desc or existing and existing.desc or categoryName,
        color = data.color or existing and existing.color or Color(150, 150, 150),
        models = models,
        isDefault = isDefault
    })

    lia.darkrp.categories[categoryName] = {
        name = categoryName,
        uniqueID = uniqueID,
        index = index,
        faction = faction,
        data = data
    }
    return index, faction
end

local function canUseJob(client, data)
    if not IsValid(client) then return false end
    local admin = tonumber(data.admin) or 0
    if admin == 1 and not client:IsAdmin() then return false end
    if admin >= 2 and not client:IsSuperAdmin() then return false end
    local character = client:getChar()
    local requiredClass = data.NeedToChangeFrom
    if requiredClass ~= nil and character then
        local currentClass = character:getClass()
        if istable(requiredClass) then
            if not table.HasValue(requiredClass, currentClass) then return false end
        elseif currentClass ~= requiredClass then
            return false
        end
    end

    if isfunction(data.customCheck) then
        local success, result = pcall(data.customCheck, client)
        if not success or result == false then return false end
    end
    return true
end

if SERVER then
    function lia.darkrp.isEmpty(position, entitiesToIgnore)
        entitiesToIgnore = entitiesToIgnore or {}
        local contents = util.PointContents(position)
        local isClear = contents ~= CONTENTS_SOLID and contents ~= CONTENTS_MOVEABLE and contents ~= CONTENTS_LADDER and contents ~= CONTENTS_PLAYERCLIP and contents ~= CONTENTS_MONSTERCLIP
        if not isClear then return false end
        for _, entity in ipairs(ents.FindInSphere(position, 35)) do
            if (entity:IsNPC() or entity:IsPlayer() or entity:isProp() or entity.NotEmptyPos) and not table.HasValue(entitiesToIgnore, entity) then return false end
        end
        return true
    end

    function lia.darkrp.findEmptyPos(startPos, entitiesToIgnore, maxDistance, searchStep, checkArea)
        if lia.darkrp.isEmpty(startPos, entitiesToIgnore) and lia.darkrp.isEmpty(startPos + checkArea, entitiesToIgnore) then return startPos end
        for distance = searchStep, maxDistance, searchStep do
            for direction = -1, 1, 2 do
                local offset = distance * direction
                local x = startPos + Vector(offset, 0, 0)
                if lia.darkrp.isEmpty(x, entitiesToIgnore) and lia.darkrp.isEmpty(x + checkArea, entitiesToIgnore) then return x end
                local y = startPos + Vector(0, offset, 0)
                if lia.darkrp.isEmpty(y, entitiesToIgnore) and lia.darkrp.isEmpty(y + checkArea, entitiesToIgnore) then return y end
                local z = startPos + Vector(0, 0, offset)
                if lia.darkrp.isEmpty(z, entitiesToIgnore) and lia.darkrp.isEmpty(z + checkArea, entitiesToIgnore) then return z end
            end
        end
        return startPos
    end

    function lia.darkrp.notify(client, notifyType, duration, message)
        if IsValid(client) then client:notifyInfo(message) end
    end
else
    lia.darkrp.textWrap = lia.util.wrapText
end

function lia.darkrp.formatMoney(amount)
    return lia.currency.get(amount)
end

function lia.darkrp.createEntity(name, data)
    data = data or {}
    local cmd = data.cmd or makeUniqueID("", name)
    local ITEM = lia.item.register(cmd, "base_entities", nil, nil, true)
    ITEM.name = name
    ITEM.model = data.model or ""
    ITEM.desc = data.desc or data.description or ""
    ITEM.category = data.category or "Entities"
    ITEM.entityid = data.ent or ""
    ITEM.price = data.price or 0
    ITEM.darkRP = data
    lia.information(string.format("Generated DarkRP entity as item %s", name))
    return ITEM
end

function lia.darkrp.createCategory(data)
    if not istable(data) or not isstring(data.name) then return end
    if data.categorises and data.categorises ~= "jobs" then return end
    local index, faction = ensureFaction(data.name, data)
    for _, job in pairs(lia.darkrp.jobs) do
        if job.category == data.name then
            job.faction = index
            local class = lia.class.list[job.team]
            if class then class.faction = index end
            addFactionModels(faction, job.model)
        end
    end
    return index
end

function lia.darkrp.createJob(name, data, model, description, weapons, command, max, salary, admin, vote, hasLicense, needToChangeFrom, customCheck)
    if not istable(data) or IsColor(data) then
        data = {
            color = data,
            model = model,
            description = description,
            weapons = weapons,
            command = command,
            max = max,
            salary = salary,
            admin = admin,
            vote = vote,
            hasLicense = hasLicense,
            NeedToChangeFrom = needToChangeFrom,
            customCheck = customCheck
        }
    end

    local categoryName = data.category or "Other"
    local factionIndex, faction = ensureFaction(categoryName, {
        color = data.color
    })

    addFactionModels(faction, data.model)
    local commandName = data.command or makeUniqueID("", name)
    local uniqueID = makeUniqueID("darkrp_job_", commandName)
    local class = lia.class.register(uniqueID, {
        name = name,
        desc = data.description or data.desc or "",
        faction = factionIndex,
        limit = math.max(tonumber(data.max) or 0, 0),
        isDefault = true,
        salary = tonumber(data.salary) or 0,
        weapons = table.Copy(data.weapons or {}),
        models = normalizeModels(data.model),
        darkRP = data,
        OnCanBe = function(_, client) return canUseJob(client, data) end
    })

    if not class then return end
    local job = table.Copy(data)
    job.name = name
    job.description = data.description or data.desc or ""
    job.command = commandName
    job.max = tonumber(data.max) or 0
    job.team = class.index
    job.faction = factionIndex
    job.category = categoryName
    job.model = data.model
    job.weapons = table.Copy(data.weapons or {})
    job.class = class
    lia.darkrp.jobs[class.index] = job
    lia.darkrp.jobByCommand[commandName:lower()] = class.index
    return class.index
end

function lia.darkrp.syncJobs()
    for index, class in pairs(lia.class.list or {}) do
        if not lia.darkrp.jobs[index] then
            local faction = lia.faction.indices[class.faction]
            lia.darkrp.jobs[index] = {
                name = class.name,
                description = class.desc,
                command = class.uniqueID,
                max = class.limit or 0,
                team = index,
                faction = class.faction,
                category = faction and faction.name or "Other",
                model = class.models or {},
                weapons = table.Copy(class.weapons or {}),
                class = class
            }

            lia.darkrp.jobByCommand[class.uniqueID:lower()] = index
        end
    end
end

function lia.darkrp.api.getJobByCommand(command)
    lia.darkrp.syncJobs()
    local index = lia.darkrp.jobByCommand[tostring(command):lower()]
    if not index then return nil, nil end
    return lia.darkrp.jobs[index], index
end

function lia.darkrp.api.getCategories()
    lia.darkrp.syncJobs()
    local result = {
        jobs = {},
        entities = {},
        shipments = {},
        weapons = {},
        vehicles = {},
        ammo = {}
    }

    local factionCategories = {}
    for _, faction in pairs(lia.faction.teams or {}) do
        local category = {
            name = faction.name,
            color = faction.color,
            members = {}
        }

        result.jobs[#result.jobs + 1] = category
        factionCategories[faction.index] = category
    end

    for _, job in pairs(lia.darkrp.jobs) do
        local category = factionCategories[job.faction]
        if category then category.members[#category.members + 1] = job end
    end
    return result
end

function lia.darkrp.api.removeChatCommand()
end

function lia.darkrp.api.defineChatCommand(cmd, callback)
    cmd = string.lower(cmd)
    lia.command.add(cmd, {
        onRun = function(client, args)
            local success, result = pcall(callback, client, unpack(args))
            if not success then return end
            if isstring(result) and result ~= "" then client:notifyError(result) end
            return result
        end
    })
end

function lia.darkrp.api.definePrivilegedChatCommand(cmd, privilege, callback)
    cmd = string.lower(cmd)
    lia.command.add(cmd, {
        privilege = privilege,
        onRun = function(client, args)
            local success, result = pcall(callback, client, unpack(args))
            if not success then return end
            if isstring(result) and result ~= "" then client:notifyError(result) end
            return result
        end
    })
end

lia.darkrp.api.createCategory = lia.darkrp.createCategory
lia.darkrp.api.createJob = lia.darkrp.createJob
lia.darkrp.api.createEntity = lia.darkrp.createEntity
lia.darkrp.api.formatMoney = lia.darkrp.formatMoney
lia.darkrp.api.isEmpty = lia.darkrp.isEmpty
lia.darkrp.api.findEmptyPos = lia.darkrp.findEmptyPos
lia.darkrp.api.notify = lia.darkrp.notify
lia.darkrp.api.textWrap = lia.darkrp.textWrap
local DarkRPVariables = {
    DarkRPNonOwnable = function(entity) entity:setNetVar("noSell", true) end,
    DarkRPTitle = function(entity, value) entity:setNetVar("name", value) end,
    DarkRPCanLockpick = function(entity, value) entity.noPick = tobool(value) end
}

hook.Add("EntityKeyValue", "liaDarkRPEntityKeyValue", function(entity, key, value)
    if not entity:isDoor() then return end
    local callback = DarkRPVariables[key]
    if callback then callback(entity, value) end
end)

hook.Add("InitializedModules", "liaDarkRPSyncJobs", function() lia.darkrp.syncJobs() end)
local PLAYER = FindMetaTable("Player")
if PLAYER and not PLAYER.getJobTable then
    function PLAYER:getJobTable()
        local character = self:getChar()
        if not character then return nil end
        lia.darkrp.syncJobs()
        return lia.darkrp.jobs[character:getClass()]
    end
end

local function normalizePath(path)
    path = tostring(path):gsub("\\", "/")
    local parts = {}
    for part in path:gmatch("[^/]+") do
        if part == ".." then
            parts[#parts] = nil
        elseif part ~= "." and part ~= "" then
            parts[#parts + 1] = part
        end
    end
    return table.concat(parts, "/")
end

local function resolvePath(path)
    path = normalizePath(path)
    local current = lia.darkrp.includeStack[#lia.darkrp.includeStack]
    if current then
        local directory = current:match("^(.*)/[^/]+$")
        if directory then
            local relative = normalizePath(directory .. "/" .. path)
            if file.Exists(relative, "LUA") then return relative end
        end
    end
    return path
end

function lia.darkrp.getEnvironment()
    if lia.darkrp.environment then
        rawset(lia.darkrp.environment, "DarkRP", lia.darkrp.api)
        rawset(lia.darkrp.environment, "RPExtraTeams", lia.darkrp.jobs)
        rawset(lia.darkrp.environment, "AddExtraTeam", lia.darkrp.api.createJob)
        return lia.darkrp.environment
    end

    local environment = {}
    setmetatable(environment, {
        __index = _G
    })

    rawset(environment, "_G", environment)
    rawset(environment, "DarkRP", lia.darkrp.api)
    rawset(environment, "RPExtraTeams", lia.darkrp.jobs)
    rawset(environment, "AddExtraTeam", lia.darkrp.api.createJob)
    rawset(environment, "include", function(path) return lia.darkrp.include(path) end)
    lia.darkrp.environment = environment
    return environment
end

function lia.darkrp.include(path)
    local resolved = resolvePath(path)
    local compiled = CompileFile(resolved, false)
    if not isfunction(compiled) then error(string.format("Unable to compile DarkRP compatibility file '%s'", resolved), 2) end
    setfenv(compiled, lia.darkrp.getEnvironment())
    lia.darkrp.includeStack[#lia.darkrp.includeStack + 1] = resolved
    local results = {xpcall(compiled, debug.traceback)}
    lia.darkrp.includeStack[#lia.darkrp.includeStack] = nil
    if not results[1] then error(results[2], 2) end
    table.remove(results, 1)
    return unpack(results)
end

function lia.darkrp.load(path, realm)
    realm = realm or "shared"
    if SERVER and realm ~= "server" then AddCSLuaFile(path) end
    if SERVER and realm == "client" then return end
    if CLIENT and realm == "server" then return end
    return lia.darkrp.include(path)
end
