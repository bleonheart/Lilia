PERFOPUS = PERFOPUS or {}
PERFOPUS.Metrics = PERFOPUS.Metrics or {}
PERFOPUS.TimedHooks = PERFOPUS.TimedHooks or {}
PERFOPUS.TimedEntityMethods = PERFOPUS.TimedEntityMethods or setmetatable({}, {__mode = "k"})
PERFOPUS.Originals = PERFOPUS.Originals or {}
PERFOPUS.Started = PERFOPUS.Started or false

PERFOPUS.REFRESH_RATE = GetConVar("sh_perfopus_refresh_rate") or CreateConVar("sh_perfopus_refresh_rate", "2", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
PERFOPUS.FREEZE = GetConVar("sh_perfopus_freeze") or CreateConVar("sh_perfopus_freeze", "0", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

local function pack(...)
    return {n = select("#", ...), ...}
end

local function normalizeSource(source)
    return tostring(source or "unknown"):gsub("\\", "/")
end

function PERFOPUS.IsOwnSource(source)
    local normalized = normalizeSource(source):lower()
    return normalized:find("/modules/perfopus/", 1, true) ~= nil or normalized:find("/perfopus/libraries/", 1, true) ~= nil
end

function PERFOPUS.GetSource(func)
    if not isfunction(func) then return "unknown" end
    local info = debug.getinfo(func, "S")
    return info and normalizeSource(info.short_src) or "unknown"
end

function PERFOPUS.CanViewMetrics(client)
    if not IsValid(client) then return false end
    if isfunction(client.hasPrivilege) then return client:hasPrivilege("viewPerformanceMetrics") end
    return client:IsSuperAdmin()
end

function PERFOPUS.TakeMeasurement(elapsed, name, source)
    if not isnumber(elapsed) or elapsed < 0 then return end
    source = normalizeSource(source)
    if PERFOPUS.IsOwnSource(source) then return end
    local sourceMetrics = PERFOPUS.Metrics[source]
    if not sourceMetrics then
        sourceMetrics = {}
        PERFOPUS.Metrics[source] = sourceMetrics
    end
    sourceMetrics[name] = (sourceMetrics[name] or 0) + elapsed
end

function PERFOPUS.MakeToolTipString(funcs, limit)
    local metrics = {}
    for name, elapsed in pairs(funcs or {}) do
        if elapsed > 0 then metrics[#metrics + 1] = {name = name, time = elapsed} end
    end
    table.sort(metrics, function(a, b) return a.time > b.time end)
    local lines = {}
    local maxLines = math.max(1, tonumber(limit) or #metrics)
    for i = 1, math.min(#metrics, maxLines) do
        local data = metrics[i]
        lines[#lines + 1] = string.format("%s ~ %.4fms", data.name, data.time * 1000)
    end
    return table.concat(lines, "\n")
end

function PERFOPUS.GetReadableMetrics()
    local realm = SERVER and 1 or 0
    local readable = {}
    for source, funcs in pairs(PERFOPUS.Metrics) do
        local copiedFuncs = {}
        local total = 0
        for name, elapsed in pairs(funcs) do
            copiedFuncs[name] = elapsed
            total = total + elapsed
        end
        readable[source] = {
            funcs = copiedFuncs,
            realm = realm,
            time = total
        }
    end
    return readable
end

function PERFOPUS.TimeThisHook(hookType, hookID, listener)
    if hookID == nil then return end
    if isstring(hookID) and hookID:sub(1, 8) == "PERFOPUS" then return end
    local hookTable = hook.GetTable()[hookType]
    if not hookTable then return end
    local hookFunc = hookTable[hookID]
    if not isfunction(hookFunc) then return end
    local source = PERFOPUS.GetSource(hookFunc)
    if PERFOPUS.IsOwnSource(source) then return end
    PERFOPUS.TimedHooks[hookType] = PERFOPUS.TimedHooks[hookType] or {}
    local previous = PERFOPUS.TimedHooks[hookType][hookID]
    if previous and hookFunc == previous.wrapper then return end
    local original = hookFunc
    local wrapper = function(...)
        local started = SysTime()
        local results = pack(original(...))
        listener(SysTime() - started, "HOOK: " .. tostring(hookType) .. " - " .. tostring(hookID), source)
        return unpack(results, 1, results.n)
    end
    PERFOPUS.TimedHooks[hookType][hookID] = {
        original = original,
        wrapper = wrapper
    }
    local add = PERFOPUS.Originals.hookAdd or hook.Add
    add(hookType, hookID, wrapper)
end

function PERFOPUS.ListenForNewHooks()
    if PERFOPUS.HookListenerInstalled then return end
    PERFOPUS.Originals.hookAdd = PERFOPUS.Originals.hookAdd or hook.Add
    local original = PERFOPUS.Originals.hookAdd
    hook.Add = function(hookType, hookID, func)
        local result = original(hookType, hookID, func)
        if PERFOPUS.Started and isfunction(func) then PERFOPUS.TimeThisHook(hookType, hookID, PERFOPUS.TakeMeasurement) end
        return result
    end
    PERFOPUS.HookListenerInstalled = true
end

function PERFOPUS.TimeThisEntMethod(ent, methodName, listener)
    if not IsValid(ent) or methodName == nil then return end
    local method = ent[methodName]
    if not isfunction(method) then return end
    local info = debug.getinfo(method, "S")
    if not info or info.what == "C" then return end
    local source = normalizeSource(info.short_src)
    if PERFOPUS.IsOwnSource(source) then return end
    local entityMethods = PERFOPUS.TimedEntityMethods[ent]
    if not entityMethods then
        entityMethods = {}
        PERFOPUS.TimedEntityMethods[ent] = entityMethods
    end
    local previous = entityMethods[methodName]
    if previous and method == previous.wrapper then return end
    local original = method
    local wrapper = function(...)
        local started = SysTime()
        local results = pack(original(...))
        listener(SysTime() - started, "METHOD: " .. tostring(methodName), source)
        return unpack(results, 1, results.n)
    end
    entityMethods[methodName] = {
        original = original,
        wrapper = wrapper
    }
    local entTable = ent:GetTable()
    if entTable then entTable[methodName] = wrapper end
end

function PERFOPUS.TimeThisEntity(ent, listener)
    if not IsValid(ent) then return end
    local entTable = ent:GetTable()
    if not entTable then return end
    for methodName, value in pairs(entTable) do
        if isfunction(value) then PERFOPUS.TimeThisEntMethod(ent, methodName, listener) end
    end
end

function PERFOPUS.ListenForNewEntityMethods()
    if PERFOPUS.EntityListenerInstalled then return end
    local entityMeta = FindMetaTable("Entity")
    if not entityMeta or not isfunction(entityMeta.__newindex) then return end
    PERFOPUS.Originals.entityNewIndex = PERFOPUS.Originals.entityNewIndex or entityMeta.__newindex
    local original = PERFOPUS.Originals.entityNewIndex
    entityMeta.__newindex = function(ent, key, value)
        local result = original(ent, key, value)
        if PERFOPUS.Started and isfunction(value) then
            timer.Simple(0, function()
                if IsValid(ent) then PERFOPUS.TimeThisEntMethod(ent, key, PERFOPUS.TakeMeasurement) end
            end)
        end
        return result
    end
    PERFOPUS.EntityListenerInstalled = true
end

function PERFOPUS.ListenForTimersToTime(listener)
    if PERFOPUS.TimerListenerInstalled then return end
    PERFOPUS.Originals.timerCreate = PERFOPUS.Originals.timerCreate or timer.Create
    local original = PERFOPUS.Originals.timerCreate
    timer.Create = function(identifier, delay, repetitions, func)
        if not PERFOPUS.Started or not isfunction(func) then return original(identifier, delay, repetitions, func) end
        local source = PERFOPUS.GetSource(func)
        if PERFOPUS.IsOwnSource(source) then return original(identifier, delay, repetitions, func) end
        local wrapped = function(...)
            local started = SysTime()
            local results = pack(func(...))
            listener(SysTime() - started, "TIMER: " .. tostring(identifier), source)
            return unpack(results, 1, results.n)
        end
        return original(identifier, delay, repetitions, wrapped)
    end
    PERFOPUS.TimerListenerInstalled = true
end

function PERFOPUS.StartProfiling()
    if PERFOPUS.Started then return false end
    PERFOPUS.Metrics = {}
    for hookName, entries in pairs(hook.GetTable()) do
        for hookID in pairs(entries) do
            PERFOPUS.TimeThisHook(hookName, hookID, PERFOPUS.TakeMeasurement)
        end
    end
    PERFOPUS.ListenForNewHooks()
    for _, ent in ipairs(ents.GetAll()) do
        PERFOPUS.TimeThisEntity(ent, PERFOPUS.TakeMeasurement)
    end
    PERFOPUS.ListenForNewEntityMethods()
    PERFOPUS.ListenForTimersToTime(PERFOPUS.TakeMeasurement)
    PERFOPUS.Started = true
    return true
end

hook.Add("OnEntityCreated", "PERFOPUSProfileEntities", function(ent)
    if not PERFOPUS.Started then return end
    timer.Simple(0, function()
        if IsValid(ent) then PERFOPUS.TimeThisEntity(ent, PERFOPUS.TakeMeasurement) end
    end)
end)
