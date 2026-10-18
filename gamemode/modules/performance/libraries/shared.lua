local MODULE = MODULE
PERFOPUS = PERFOPUS or {}
local GM = GM or GAMEMODE
MODULE.perfopusMetrics = MODULE.perfopusMetrics or {}
MODULE.perfopusTimedHooks = MODULE.perfopusTimedHooks or {}
MODULE.perfopusTimedEntityMethods = MODULE.perfopusTimedEntityMethods or setmetatable({}, {__mode = "k"})
MODULE.perfopusOriginals = MODULE.perfopusOriginals or {}
MODULE.perfopusStarted = MODULE.perfopusStarted or false
MODULE.perfopusRefreshRate = MODULE.perfopusRefreshRate or 2
MODULE.perfopusFrozen = MODULE.perfopusFrozen or false

local function pack(...)
    return {n = select("#", ...), ...}
end

local function normalizeSource(source)
    return tostring(source or "unknown"):gsub("\\", "/")
end

function MODULE:IsOwnSource(source)
    return normalizeSource(source):lower():find("/modules/performance/", 1, true) ~= nil
end

function MODULE:GetSource(func)
    if not isfunction(func) then return "unknown" end
    local info = debug.getinfo(func, "S")
    return info and normalizeSource(info.short_src) or "unknown"
end

function MODULE:CanViewMetrics(client)
    return IsValid(client) and isfunction(client.hasPrivilege) and client:hasPrivilege("viewPerformanceMetrics") or false
end

function MODULE:TakeMeasurement(elapsed, name, source)
    if not isnumber(elapsed) or elapsed < 0 then return end
    source = normalizeSource(source)
    if self:IsOwnSource(source) then return end
    local sourceMetrics = self.perfopusMetrics[source]
    if not sourceMetrics then
        sourceMetrics = {}
        self.perfopusMetrics[source] = sourceMetrics
    end

    sourceMetrics[name] = (sourceMetrics[name] or 0) + elapsed
end

function MODULE:MakeToolTipString(funcs, limit)
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

function MODULE:GetReadableMetrics()
    local realm = SERVER and 1 or 0
    local readable = {}
    for source, funcs in pairs(self.perfopusMetrics) do
        local copiedFuncs = {}
        local total = 0
        for name, elapsed in pairs(funcs) do
            copiedFuncs[name] = elapsed
            total = total + elapsed
        end

        readable[source] = {funcs = copiedFuncs, realm = realm, time = total}
    end
    return readable
end

function MODULE:TimeThisHook(hookType, hookID)
    if hookID == nil then return end
    if isstring(hookID) and hookID:sub(1, 8) == "PERFOPUS" then return end
    local hookTable = hook.GetTable()[hookType]
    if not hookTable then return end
    local hookFunc = hookTable[hookID]
    if not isfunction(hookFunc) then return end
    local source = self:GetSource(hookFunc)
    if self:IsOwnSource(source) then return end
    self.perfopusTimedHooks[hookType] = self.perfopusTimedHooks[hookType] or {}
    local previous = self.perfopusTimedHooks[hookType][hookID]
    if previous and hookFunc == previous.wrapper then return end
    local original = hookFunc
    local wrapper = function(...)
        local started = SysTime()
        local results = pack(original(...))
        self:TakeMeasurement(SysTime() - started, "HOOK: " .. tostring(hookType) .. " - " .. tostring(hookID), source)
        return unpack(results, 1, results.n)
    end

    self.perfopusTimedHooks[hookType][hookID] = {original = original, wrapper = wrapper}
    local add = self.perfopusOriginals.hookAdd or hook.Add
    add(hookType, hookID, wrapper)
end

function MODULE:ListenForNewHooks()
    if self.perfopusHookListenerInstalled then return end
    self.perfopusOriginals.hookAdd = self.perfopusOriginals.hookAdd or hook.Add
    local original = self.perfopusOriginals.hookAdd
    hook.Add = function(hookType, hookID, func)
        local result = original(hookType, hookID, func)
        if self.perfopusStarted and isfunction(func) then self:TimeThisHook(hookType, hookID) end
        return result
    end

    self.perfopusHookListenerInstalled = true
end

function MODULE:TimeThisEntMethod(ent, methodName)
    if not IsValid(ent) or methodName == nil then return end
    local method = ent[methodName]
    if not isfunction(method) then return end
    local info = debug.getinfo(method, "S")
    if not info or info.what == "C" then return end
    local source = normalizeSource(info.short_src)
    if self:IsOwnSource(source) then return end
    local entityMethods = self.perfopusTimedEntityMethods[ent]
    if not entityMethods then
        entityMethods = {}
        self.perfopusTimedEntityMethods[ent] = entityMethods
    end

    local previous = entityMethods[methodName]
    if previous and method == previous.wrapper then return end
    local original = method
    local wrapper = function(...)
        local started = SysTime()
        local results = pack(original(...))
        self:TakeMeasurement(SysTime() - started, "METHOD: " .. tostring(methodName), source)
        return unpack(results, 1, results.n)
    end

    entityMethods[methodName] = {original = original, wrapper = wrapper}
    local entTable = ent:GetTable()
    if entTable then entTable[methodName] = wrapper end
end

function MODULE:TimeThisEntity(ent)
    if not IsValid(ent) then return end
    local entTable = ent:GetTable()
    if not entTable then return end
    for methodName, value in pairs(entTable) do
        if isfunction(value) then self:TimeThisEntMethod(ent, methodName) end
    end
end

function MODULE:ListenForNewEntityMethods()
    if self.perfopusEntityListenerInstalled then return end
    local entityMeta = FindMetaTable("Entity")
    if not entityMeta or not isfunction(entityMeta.__newindex) then return end
    self.perfopusOriginals.entityNewIndex = self.perfopusOriginals.entityNewIndex or entityMeta.__newindex
    local original = self.perfopusOriginals.entityNewIndex
    entityMeta.__newindex = function(ent, key, value)
        local result = original(ent, key, value)
        if self.perfopusStarted and isfunction(value) then
            timer.Simple(0, function() if IsValid(ent) then self:TimeThisEntMethod(ent, key) end end)
        end
        return result
    end

    self.perfopusEntityListenerInstalled = true
end

function MODULE:ListenForTimersToTime()
    if self.perfopusTimerListenerInstalled then return end
    self.perfopusOriginals.timerCreate = self.perfopusOriginals.timerCreate or timer.Create
    local original = self.perfopusOriginals.timerCreate
    timer.Create = function(identifier, delay, repetitions, func)
        if not self.perfopusStarted or not isfunction(func) then return original(identifier, delay, repetitions, func) end
        local source = self:GetSource(func)
        if self:IsOwnSource(source) then return original(identifier, delay, repetitions, func) end
        local wrapped = function(...)
            local started = SysTime()
            local results = pack(func(...))
            self:TakeMeasurement(SysTime() - started, "TIMER: " .. tostring(identifier), source)
            return unpack(results, 1, results.n)
        end
        return original(identifier, delay, repetitions, wrapped)
    end

    self.perfopusTimerListenerInstalled = true
end

function MODULE:StartProfiling()
    if self.perfopusStarted then return false end
    self.perfopusMetrics = {}
    for hookName, entries in pairs(hook.GetTable()) do
        for hookID in pairs(entries) do
            self:TimeThisHook(hookName, hookID)
        end
    end

    self:ListenForNewHooks()
    for _, ent in ipairs(ents.GetAll()) do
        self:TimeThisEntity(ent)
    end

    self:ListenForNewEntityMethods()
    self:ListenForTimersToTime()
    self.perfopusStarted = true
    return true
end

function MODULE:OnEntityCreated(ent)
    if not self.perfopusStarted then return end
    timer.Simple(0, function() if IsValid(ent) then self:TimeThisEntity(ent) end end)
end

function GM:MouthMoveAnimation(ply)
    if lia.config.get("MouthMoveAnimation", true) then
        local flexes = {ply:GetFlexIDByName("jaw_drop"), ply:GetFlexIDByName("left_part"), ply:GetFlexIDByName("right_part"), ply:GetFlexIDByName("left_mouth_drop"), ply:GetFlexIDByName("right_mouth_drop")}
        local weight = ply:IsSpeaking() and math.Clamp(ply:VoiceVolume() * 2, 0, 2) or 0
        for k, v in ipairs(flexes) do
            ply:SetFlexWeight(v, weight)
        end
    end
    return nil
end

function GM:GrabEarAnimation(ply, plyTable)
    if lia.config.get("GrabEarAnimation", true) then
        if not plyTable then plyTable = ply:GetTable() end
        plyTable.ChatGestureWeight = plyTable.ChatGestureWeight or 0
        if ply:IsPlayingTaunt() then return end
        if ply:IsTyping() then
            plyTable.ChatGestureWeight = math.Approach(plyTable.ChatGestureWeight, 1, FrameTime() * 5.0)
        else
            plyTable.ChatGestureWeight = math.Approach(plyTable.ChatGestureWeight, 0, FrameTime() * 5.0)
        end

        if plyTable.ChatGestureWeight > 0 then
            ply:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true)
            ply:AnimSetGestureWeight(GESTURE_SLOT_VCD, plyTable.ChatGestureWeight)
        end
    end
    return nil
end

function GM:PreGamemodeLoaded()
    widgets.PlayerTick = function() end
    hook.Remove("PlayerTick", "TickWidgets")
    hook.Remove("PostDrawEffects", "RenderWidgets")
end

function GM:FindUseEntity(client, ent)
    return ent
end