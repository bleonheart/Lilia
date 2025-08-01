lia.net = lia.net or {}
lia.net.globals = lia.net.globals or {}
if SERVER then
    function lia.net.writeBigTable(target, netStr, tbl, chunkSize, chunkDelay)
        if not istable(tbl) then return end
        local json = util.TableToJSON(tbl)
        if not json then return end
        local data = util.Compress(json)
        if not data then return end
        local size = chunkSize or 8192
        local delay = chunkDelay or 0.05
        local total = math.ceil(#data / size)
        if total < 1 then total = 1 end
        local sid = tonumber(util.CRC(tostring(SysTime()) .. tostring(tbl) .. tostring(math.random())), 10) or 0
        local idx = 0
        local pos = 1

        local function sendNext()
            if not IsValid(target) then return end
            idx = idx + 1
            local chunk = string.sub(data, pos, pos + size - 1)
            net.Start(netStr)
            net.WriteUInt(sid, 32)
            net.WriteUInt(total, 16)
            net.WriteUInt(idx, 16)
            net.WriteUInt(#chunk, 16)
            net.WriteData(chunk, #chunk)
            net.Send(target)

            pos = pos + size
            if pos <= #data then
                timer.Simple(delay, sendNext)
            end
        end

        sendNext()
    end

    function checkBadType(name, object)
        if isfunction(object) then
            lia.error(L("badNetVarType", name))
            return true
        elseif istable(object) then
            for k, v in pairs(object) do
                if checkBadType(name, k) or checkBadType(name, v) then return true end
            end
        end
    end

    function setNetVar(key, value, receiver)
        if checkBadType(key, value) then return end
        local oldValue = getNetVar(key)
        if oldValue == value then return end
        lia.net.globals[key] = value
        net.Start("gVar")
        net.WriteString(key)
        net.WriteType(value)
        if receiver then
            net.Send(receiver)
        else
            net.Broadcast()
        end

        hook.Run("NetVarChanged", nil, key, oldValue, value)
    end

    function getNetVar(key, default)
        local value = lia.net.globals[key]
        return value ~= nil and value or default
    end

    hook.Add("EntityRemoved", "liaNetworkingCleanup", function(entity) entity:clearNetVars() end)
    hook.Add("PlayerInitialSpawn", "liaNetworkingSync", function(client) client:syncVars() end)
    hook.Add("CharDeleted", "liaNetworkingCharDeleted", function(client, character)
        lia.char.names[character:getID()] = nil
        net.Start("liaCharFetchNames")
        net.WriteTable(lia.char.names)
        net.Send(client)
    end)

    hook.Add("OnCharCreated", "liaNetworkingCharCreated", function(client, character, data)
        lia.char.names[character:getID()] = data.name
        net.Start("liaCharFetchNames")
        net.WriteTable(lia.char.names)
        net.Send(client)
    end)
else
    function lia.net.readBigTable(netStr, callback)
        lia.net._buffers = lia.net._buffers or {}
        net.Receive(netStr, function(len, ply)
            local sid = net.ReadUInt(32)
            local total = net.ReadUInt(16)
            local idx = net.ReadUInt(16)
            local clen = net.ReadUInt(16)
            local chunk = net.ReadData(clen)
            lia.net._buffers[netStr] = lia.net._buffers[netStr] or {}
            local byId = lia.net._buffers[netStr]
            local state = byId[sid]
            if not state then
                state = {
                    total = total,
                    count = 0,
                    parts = {}
                }

                byId[sid] = state
            end

            if not state.parts[idx] then
                state.parts[idx] = chunk
                state.count = state.count + 1
            end

            if state.count == state.total then
                byId[sid] = nil
                local full = table.concat(state.parts)
                local decomp = util.Decompress(full)
                local out = decomp and util.JSONToTable(decomp) or nil
                if SERVER then
                    if callback then callback(ply, out) end
                else
                    if callback then callback(out) end
                end
            end
        end)
    end

    function getNetVar(key, default)
        local value = lia.net.globals[key]
        return value ~= nil and value or default
    end

    FindMetaTable("Player").getLocalVar = FindMetaTable("Entity").getNetVar
end