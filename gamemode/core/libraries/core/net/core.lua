lia.net = lia.net or {}
lia.net.sendq = lia.net.sendq or {}
lia.net.cache = lia.net.cache or {}
lia.net.locals = lia.net.locals or {}
lia.net.globals = lia.net.globals or {}
lia.net.buffers = lia.net.buffers or {}
lia.net.registry = lia.net.registry or {}
local chunkTime = 0.05
local CACHE_TTL = 30
local MAX_CACHE_SIZE = 1000

local function getChunkInterval()
    return (lia.reloadInProgress and chunkTime * 2) or chunkTime
end

local function generateCacheKey(name, args)
    local key = name .. "|"
    for i, arg in ipairs(args) do
        key = key .. tostring(arg) .. (i < #args and "|" or "")
    end
    return util.CRC(key)
end

local function cleanupCache()
    local currentTime = CurTime()
    local expired = {}
    for key, entry in pairs(lia.net.cache) do
        if currentTime - entry.timestamp > CACHE_TTL then table.insert(expired, key) end
    end

    for _, key in ipairs(expired) do
        lia.net.cache[key] = nil
    end

    local cacheSize = table.Count(lia.net.cache)
    if cacheSize > MAX_CACHE_SIZE then
        local sorted = {}
        for key, entry in pairs(lia.net.cache) do
            table.insert(sorted, {
                key = key,
                timestamp = entry.timestamp
            })
        end

        table.sort(sorted, function(a, b) return a.timestamp < b.timestamp end)
        local toRemove = cacheSize - MAX_CACHE_SIZE
        for i = 1, math.min(toRemove, #sorted) do
            lia.net.cache[sorted[i].key] = nil
        end
    end
end

function lia.net.isCacheHit(name, args)
    local key = generateCacheKey(name, args)
    local entry = lia.net.cache[key]
    return entry and CurTime() - entry.timestamp <= CACHE_TTL
end

function lia.net.addToCache(name, args)
    local key = generateCacheKey(name, args)
    lia.net.cache[key] = {
        timestamp = CurTime()
    }

    cleanupCache()
end

function lia.net.readBigTable(netStr, callback)
    lia.net.buffers[netStr] = lia.net.buffers[netStr] or {}
    net.Receive(netStr, function(_, ply)
        local sid = net.ReadUInt(32)
        local total = net.ReadUInt(16)
        local idx = net.ReadUInt(16)
        local clen = net.ReadUInt(16)
        local chunk = net.ReadData(clen)
        if not lia.net.buffers[netStr] then lia.net.buffers[netStr] = {} end
        local buffers = lia.net.buffers[netStr]
        local state = buffers[sid]
        if not state then
            state = {
                total = total,
                count = 0,
                parts = {}
            }

            buffers[sid] = state
        end

        if not state.parts[idx] then
            state.parts[idx] = chunk
            state.count = state.count + 1
        end

        if CLIENT then
            net.Start("liaBigTableAck")
            net.WriteUInt(sid, 32)
            net.WriteUInt(idx, 16)
            net.SendToServer()
        end

        if state.count == state.total then
            buffers[sid] = nil
            local full = table.concat(state.parts, "", 1, total)
            local decomp = util.Decompress(full)
            local tbl = decomp and util.JSONToTable(decomp) or nil
            if SERVER then
                if callback then callback(ply, tbl) end
            else
                if callback then callback(tbl) end
            end
        end
    end)
end

if SERVER then
    local function sendChunk(ply, s, sid, idx)
        if not IsValid(ply) then
            if lia.net.sendq[ply] then lia.net.sendq[ply][sid] = nil end
            return
        end

        local part = s.chunks[idx]
        if not part then
            if lia.net.sendq[ply] then lia.net.sendq[ply][sid] = nil end
            return
        end

        s.idx = idx
        net.Start(s.netStr)
        net.WriteUInt(sid, 32)
        net.WriteUInt(s.total, 16)
        net.WriteUInt(idx, 16)
        net.WriteUInt(#part, 16)
        net.WriteData(part, #part)
        net.Send(ply)
        if idx == s.total and lia.net.sendq[ply] then lia.net.sendq[ply][sid] = nil end
    end

    local function beginStream(ply, netStr, chunks, sid)
        lia.net.sendq[ply] = lia.net.sendq[ply] or {}
        local s = {
            netStr = netStr,
            chunks = chunks,
            total = #chunks,
            idx = 0
        }

        lia.net.sendq[ply][sid] = s
        timer.Simple(getChunkInterval(), function()
            if not IsValid(ply) then return end
            local q = lia.net.sendq[ply]
            if not q then return end
            local ss = q[sid]
            if not ss then return end
            sendChunk(ply, ss, sid, 1)
        end)
    end

    function lia.net.writeBigTable(targets, netStr, tbl, chunkSize)
        if not istable(tbl) then return end
        local json = util.TableToJSON(tbl)
        if not json then return end
        local data = util.Compress(json)
        if not data or #data == 0 then return end
        local isReload = lia.reloadInProgress or false
        local size = isReload and math.max(128, math.min(1024, chunkSize or 512)) or math.max(256, math.min(4096, chunkSize or 2048))
        local chunks = {}
        local pos = 1
        while pos <= #data do
            local part = string.sub(data, pos, pos + size - 1)
            chunks[#chunks + 1] = part
            pos = pos + size
        end

        local sid = (tonumber(util.CRC(tostring(SysTime()) .. json)) or 0) % 4294967296
        local delay = 0
        local function schedule(ply)
            if not IsValid(ply) then return end
            timer.Simple(delay, function() if IsValid(ply) then beginStream(ply, netStr, chunks, sid) end end)
            delay = delay + getChunkInterval()
        end

        if istable(targets) then
            local validTargets = 0
            for i = #targets, 1, -1 do
                if IsValid(targets[i]) then
                    schedule(targets[i])
                    validTargets = validTargets + 1
                end
            end

            if validTargets == 0 then
                for _, ply in ipairs(player.GetHumans()) do
                    schedule(ply)
                end
            end
        elseif IsValid(targets) then
            schedule(targets)
        else
            for _, ply in ipairs(player.GetHumans()) do
                schedule(ply)
            end
        end
    end

    function lia.net.checkBadType(name, object)
        if isfunction(object) then
            lia.error(string.format("Net var '%s' contains a bad object type!", name))
            return true
        elseif istable(object) then
            for k, v in pairs(object) do
                if lia.net.checkBadType(name, k) or lia.net.checkBadType(name, v) then return true end
            end
        end
    end

    function lia.net.setNetVar(key, value, receiver)
        if lia.net.checkBadType(key, value) then return end
        local oldValue = lia.net.getNetVar(key)
        if oldValue == value then return end
        lia.net.globals[key] = value
        if not lia.shuttingDown then
            net.Start("liaGlobalVar")
            net.WriteString(key)
            net.WriteType(value)
            if receiver then
                net.Send(receiver)
            else
                net.Broadcast()
            end
        end

        hook.Run("NetVarChanged", nil, key, oldValue, value)
    end

    hook.Add("EntityRemoved", "liaNetworkingCleanup", function(entity) entity:clearNetVars() end)
    hook.Add("PlayerInitialSpawn", "liaNetworkingSync", function(client) client:syncVars() end)
end

function lia.net.getNetVar(key, default)
    local value = lia.net.globals[key]
    return value ~= nil and value or default
end


if SERVER then
    lia.net.trace = lia.net.trace or {}
    local trace = lia.net.trace
    trace.sessions = trace.sessions or {}
    trace.nextSessionID = trace.nextSessionID or 0
    trace.joinSessions = trace.joinSessions or setmetatable({}, {
        __mode = "k"
    })

    trace.originals = trace.originals or {
        Start = net.Start,
        Send = net.Send,
        Broadcast = net.Broadcast,
        SendOmit = net.SendOmit,
        SendPVS = net.SendPVS,
        SendPAS = net.SendPAS
    }

    local originals = trace.originals
    local enabled = CreateConVar("lia_nettrace_enabled", "1", FCVAR_ARCHIVE, "Enables automatic Lilia outgoing net traffic diagnostics.")

    local function formatBytes(bytes)
        bytes = tonumber(bytes) or 0
        if bytes >= 1048576 then return string.format("%.2f MiB", bytes / 1048576) end
        if bytes >= 1024 then return string.format("%.2f KiB", bytes / 1024) end
        return string.format("%d B", bytes)
    end

    local function getCallsite()
        for level = 3, 16 do
            local info = debug.getinfo(level, "Sl")
            if not info then break end
            if info.what ~= "C" then
                local source = tostring(info.short_src or info.source or "unknown"):gsub("^@", ""):gsub("\\", "/")
                if not source:find("core/libraries/core/net/core.lua", 1, true) and not source:find("lua/includes/extensions/net.lua", 1, true) then return source, tonumber(info.currentline) or 0 end
            end
        end

        return "unknown", 0
    end

    local function getPlayerKey(client)
        return tostring(client:UserID())
    end

    local function ensurePlayer(session, client)
        local key = getPlayerKey(client)
        local data = session.players[key]
        if data then
            data.name = client:Nick()
            data.steamID = client:SteamID()
            return data
        end

        data = {
            name = client:Nick(),
            steamID = client:SteamID(),
            totalBytes = 0,
            totalMessages = 0,
            maxBytes = 0,
            largeMessages = 0,
            names = {},
            buckets100 = {},
            buckets1000 = {}
        }

        session.players[key] = data
        return data
    end

    local function updateBucket(buckets, key, bytes)
        local bucket = buckets[key]
        if not bucket then
            bucket = {
                bytes = 0,
                messages = 0
            }

            buckets[key] = bucket
        end

        bucket.bytes = bucket.bytes + bytes
        bucket.messages = bucket.messages + 1
    end

    local function recordClient(client, name, bytes, source, line)
        if not IsValid(client) or not client:IsPlayer() then return end
        local now = SysTime()
        for _, session in pairs(trace.sessions) do
            if now <= session.endsAt and (not session.target or session.target == client) then
                local data = ensurePlayer(session, client)
                data.totalBytes = data.totalBytes + bytes
                data.totalMessages = data.totalMessages + 1
                data.maxBytes = math.max(data.maxBytes, bytes)
                if bytes >= 49152 then data.largeMessages = data.largeMessages + 1 end
                local entry = data.names[name]
                if not entry then
                    entry = {
                        count = 0,
                        bytes = 0,
                        maxBytes = 0,
                        sites = {}
                    }

                    data.names[name] = entry
                end

                entry.count = entry.count + 1
                entry.bytes = entry.bytes + bytes
                entry.maxBytes = math.max(entry.maxBytes, bytes)
                local site = tostring(source or "unknown") .. ":" .. tostring(line or 0)
                local siteData = entry.sites[site]
                if not siteData then
                    siteData = {
                        count = 0,
                        bytes = 0
                    }

                    entry.sites[site] = siteData
                end

                siteData.count = siteData.count + 1
                siteData.bytes = siteData.bytes + bytes
                local elapsed = math.max(0, now - session.startedAt)
                updateBucket(data.buckets100, math.floor(elapsed * 10), bytes)
                updateBucket(data.buckets1000, math.floor(elapsed), bytes)
            end
        end
    end

    local function collectTargets(targets)
        local result = {}
        local seen = {}
        local function add(client)
            if not IsValid(client) or not client:IsPlayer() or seen[client] then return end
            seen[client] = true
            result[#result + 1] = client
        end

        if IsValid(targets) and targets:IsPlayer() then
            add(targets)
        elseif istable(targets) then
            for _, client in pairs(targets) do
                add(client)
            end
        elseif targets ~= nil then
            local ok, players = pcall(function() return targets:GetPlayers() end)
            if ok and istable(players) then
                for _, client in ipairs(players) do
                    add(client)
                end
            end
        end

        return result
    end

    local function getPVSPlayers(pos, pas)
        if not RecipientFilter then return {} end
        local filter = RecipientFilter()
        local ok = pcall(function()
            if pas then
                filter:AddPAS(pos)
            else
                filter:AddPVS(pos)
            end
        end)

        if not ok then return {} end
        local players = filter:GetPlayers()
        return istable(players) and players or {}
    end

    local function finishCurrent(recipients)
        if not next(trace.sessions) then
            trace.currentName = nil
            trace.currentSource = nil
            trace.currentLine = nil
            return
        end

        local ok, bytes = pcall(net.BytesWritten)
        bytes = ok and tonumber(bytes) or 0
        local name = trace.currentName or "unknown"
        local source = trace.currentSource or "unknown"
        local line = trace.currentLine or 0
        trace.currentName = nil
        trace.currentSource = nil
        trace.currentLine = nil
        local seen = {}
        for _, client in ipairs(recipients or {}) do
            if IsValid(client) and client:IsPlayer() and not seen[client] then
                seen[client] = true
                recordClient(client, name, bytes, source, line)
            end
        end
    end

    local function getPeak(buckets)
        local peakBytes = 0
        local peakMessages = 0
        for _, bucket in pairs(buckets) do
            if bucket.bytes > peakBytes then
                peakBytes = bucket.bytes
                peakMessages = bucket.messages
            end
        end

        return peakBytes, peakMessages
    end

    local function getTopSite(entry)
        local bestSite = "unknown:0"
        local bestBytes = -1
        for site, data in pairs(entry.sites) do
            if data.bytes > bestBytes then
                bestSite = site
                bestBytes = data.bytes
            end
        end

        return bestSite
    end

    local function reportSession(session)
        local duration = math.max(0, math.min(SysTime(), session.endsAt) - session.startedAt)
        local players = {}
        for _, data in pairs(session.players) do
            players[#players + 1] = data
        end

        table.sort(players, function(a, b)
            if a.totalBytes == b.totalBytes then return a.totalMessages > b.totalMessages end
            return a.totalBytes > b.totalBytes
        end)

        print("")
        print("================================================================")
        print(string.format("[Lilia Net Trace] %s | %.2fs", session.label, duration))
        if #players == 0 then
            print("[Lilia Net Trace] No outgoing net messages were captured.")
        end

        for _, data in ipairs(players) do
            local peak100Bytes, peak100Messages = getPeak(data.buckets100)
            local peak1000Bytes, peak1000Messages = getPeak(data.buckets1000)
            local average = data.totalMessages > 0 and data.totalBytes / data.totalMessages or 0
            print("----------------------------------------------------------------")
            print(string.format("[Lilia Net Trace] Player: %s [%s]", data.name, data.steamID))
            print(string.format("[Lilia Net Trace] Total: %d messages | %s | avg %s | max %s | >=48KiB %d", data.totalMessages, formatBytes(data.totalBytes), formatBytes(average), formatBytes(data.maxBytes), data.largeMessages))
            print(string.format("[Lilia Net Trace] Peak 100ms: %s / %d messages | Peak 1s: %s / %d messages", formatBytes(peak100Bytes), peak100Messages, formatBytes(peak1000Bytes), peak1000Messages))
            local entries = {}
            for name, entry in pairs(data.names) do
                entries[#entries + 1] = {
                    name = name,
                    count = entry.count,
                    bytes = entry.bytes,
                    maxBytes = entry.maxBytes,
                    site = getTopSite(entry)
                }
            end

            table.sort(entries, function(a, b)
                if a.bytes == b.bytes then return a.count > b.count end
                return a.bytes > b.bytes
            end)

            for i = 1, math.min(#entries, 30) do
                local entry = entries[i]
                local entryAverage = entry.count > 0 and entry.bytes / entry.count or 0
                print(string.format("[Lilia Net Trace] #%d %s | %d msgs | %s | avg %s | max %s | %s", i, entry.name, entry.count, formatBytes(entry.bytes), formatBytes(entryAverage), formatBytes(entry.maxBytes), entry.site))
            end

            if #entries > 30 then print(string.format("[Lilia Net Trace] %d additional message names omitted.", #entries - 30)) end
        end

        print("================================================================")
        print("")
    end

    local function endSession(id, shouldReport)
        local session = trace.sessions[id]
        if not session then return end
        timer.Remove("liaNetTraceSession" .. id)
        if shouldReport then reportSession(session) end
        trace.sessions[id] = nil
    end

    function trace.start(label, target, duration)
        if not enabled:GetBool() then return end
        duration = math.Clamp(tonumber(duration) or 10, 1, 120)
        trace.nextSessionID = trace.nextSessionID + 1
        local id = trace.nextSessionID
        local session = {
            id = id,
            label = tostring(label or "manual"),
            target = IsValid(target) and target:IsPlayer() and target or nil,
            startedAt = SysTime(),
            endsAt = SysTime() + duration,
            players = {}
        }

        trace.sessions[id] = session
        if session.target then
            ensurePlayer(session, session.target)
        else
            for _, client in player.Iterator() do
                if IsValid(client) and client:IsPlayer() then ensurePlayer(session, client) end
            end
        end

        timer.Create("liaNetTraceSession" .. id, duration, 1, function() endSession(id, true) end)
        print(string.format("[Lilia Net Trace] Started '%s' for %.1fs%s.", session.label, duration, session.target and " on " .. session.target:Nick() or ""))
        return id
    end

    function trace.report()
        local sessions = {}
        for _, session in pairs(trace.sessions) do
            sessions[#sessions + 1] = session
        end

        table.sort(sessions, function(a, b) return a.id < b.id end)
        if #sessions == 0 then
            print("[Lilia Net Trace] No active sessions.")
            return
        end

        for _, session in ipairs(sessions) do
            reportSession(session)
        end
    end

    function trace.stop()
        local ids = {}
        for id in pairs(trace.sessions) do
            ids[#ids + 1] = id
        end

        table.sort(ids)
        for _, id in ipairs(ids) do
            endSession(id, true)
        end
    end

    function trace.reset()
        local ids = {}
        for id in pairs(trace.sessions) do
            ids[#ids + 1] = id
        end

        for _, id in ipairs(ids) do
            timer.Remove("liaNetTraceSession" .. id)
            trace.sessions[id] = nil
        end

        print("[Lilia Net Trace] Active sessions cleared.")
    end

    net.Start = function(name, unreliable)
        local result = originals.Start(name, unreliable)
        if next(trace.sessions) then
            trace.currentName = tostring(name or "unknown")
            trace.currentSource, trace.currentLine = getCallsite()
        else
            trace.currentName = nil
            trace.currentSource = nil
            trace.currentLine = nil
        end

        return result
    end

    net.Send = function(targets)
        finishCurrent(collectTargets(targets))
        return originals.Send(targets)
    end

    net.Broadcast = function()
        finishCurrent(player.GetHumans())
        return originals.Broadcast()
    end

    if originals.SendOmit then
        net.SendOmit = function(omit)
            local omitted = {}
            for _, client in ipairs(collectTargets(omit)) do
                omitted[client] = true
            end

            local recipients = {}
            for _, client in ipairs(player.GetHumans()) do
                if not omitted[client] then recipients[#recipients + 1] = client end
            end

            finishCurrent(recipients)
            return originals.SendOmit(omit)
        end
    end

    if originals.SendPVS then
        net.SendPVS = function(pos)
            finishCurrent(getPVSPlayers(pos, false))
            return originals.SendPVS(pos)
        end
    end

    if originals.SendPAS then
        net.SendPAS = function(pos)
            finishCurrent(getPVSPlayers(pos, true))
            return originals.SendPAS(pos)
        end
    end

    local function startJoinTrace(client)
        if not enabled:GetBool() or not IsValid(client) or trace.joinSessions[client] then return end
        local id = trace.start("join:" .. client:Nick(), client, 20)
        if not id then return end
        trace.joinSessions[client] = id
        timer.Simple(20.1, function()
            if trace.joinSessions[client] == id then trace.joinSessions[client] = nil end
        end)
    end

    hook.Add("PlayerAuthed", "liaNetTracePlayerAuthed", startJoinTrace)
    hook.Add("PlayerInitialSpawn", "liaNetTracePlayerInitialSpawn", startJoinTrace)
    hook.Add("PlayerLoadedChar", "liaNetTraceCharacterLoad", function(client)
        if enabled:GetBool() and IsValid(client) then trace.start("character:" .. client:Nick(), client, 10) end
    end)

    hook.Add("OnReloaded", "liaNetTraceReload", function()
        if enabled:GetBool() then trace.start("reload", nil, 8) end
    end)

    concommand.Add("lia_nettrace_start", function(client, _, args)
        if IsValid(client) then return end
        local duration = tonumber(args[1]) or 10
        local target
        local targetID = args[2]
        if targetID and targetID ~= "" then
            for _, ply in player.Iterator() do
                if tostring(ply:UserID()) == targetID or ply:SteamID() == targetID or ply:SteamID64() == targetID then
                    target = ply
                    break
                end
            end

            if not target then
                print("[Lilia Net Trace] Target player not found.")
                return
            end
        end

        trace.start("manual", target, duration)
    end)

    concommand.Add("lia_nettrace_report", function(client)
        if IsValid(client) then return end
        trace.report()
    end)

    concommand.Add("lia_nettrace_stop", function(client)
        if IsValid(client) then return end
        trace.stop()
    end)

    concommand.Add("lia_nettrace_reset", function(client)
        if IsValid(client) then return end
        trace.reset()
    end)

    print("[Lilia Net Trace] Outgoing net diagnostics enabled. Automatic sessions: reload 8s, join 20s, character load 10s.")
end
