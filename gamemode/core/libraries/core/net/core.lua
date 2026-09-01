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

    hook.Add("EntityRemoved", "liaNetworkingCleanup", function(entity) entity:clearNetVars() end)
    hook.Add("PlayerInitialSpawn", "liaNetworkingSync", function(client) client:syncVars() end)
end

if SERVER then
    net.Receive("liaBigTableAck", function(_, ply)
        if not IsValid(ply) then return end
        local sid = net.ReadUInt(32)
        local last = net.ReadUInt(16)
        local q = lia.net.sendq[ply]
        if not q then return end
        local s = q[sid]
        if not s or last ~= s.idx then return end
        if s.idx >= s.total then
            q[sid] = nil
            return
        end

        timer.Simple(getChunkInterval(), function()
            if not IsValid(ply) then return end
            local qq = lia.net.sendq[ply]
            local ss = qq and qq[sid]
            if ss then sendChunk(ply, ss, sid, ss.idx + 1) end
        end)
    end)
end

function lia.net.getNetVar(key, default)
    local value = lia.net.globals[key]
    return value ~= nil and value or default
end

