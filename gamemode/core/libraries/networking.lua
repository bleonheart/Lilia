lia.net = lia.net or {}
lia.net.globals = lia.net.globals or {}
function lia.net.readBigTable(netStr, callback)
    lia.net._buffers = lia.net._buffers or {}
    lia.net._buffers[netStr] = lia.net._buffers[netStr] or {}
    net.Receive(netStr, function(_, ply)
        local sid = net.ReadUInt(32)
        local total = net.ReadUInt(16)
        local idx = net.ReadUInt(16)
        local clen = net.ReadUInt(16)
        local chunk = net.ReadData(clen)
        local buffers = lia.net._buffers[netStr]
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
    function lia.net.writeBigTable(targets, netStr, tbl, chunkSize, chunkDelay)
        if not istable(tbl) then return end
        local json = util.TableToJSON(tbl)
        if not json then return end
        local data = util.Compress(json)
        if not data or #data == 0 then return end
        local size = chunkSize or 8192
        local delay = chunkDelay or 0
        local total = math.ceil(#data / size)
        local sid = util.CRC(tostring(SysTime()) .. json) % 4294967295
        local idx, pos = 0, 1
        local function sendNext()
            if targets then
                if istable(targets) then
                    for i = #targets, 1, -1 do
                        if not IsValid(targets[i]) then table.remove(targets, i) end
                    end

                    if #targets == 0 then return end
                elseif not IsValid(targets) then
                    return
                end
            end

            idx = idx + 1
            local chunk = string.sub(data, pos, pos + size - 1)
            net.Start(netStr)
            net.WriteUInt(sid, 32)
            net.WriteUInt(total, 16)
            net.WriteUInt(idx, 16)
            net.WriteUInt(#chunk, 16)
            net.WriteData(chunk, #chunk)
            if not targets then
                net.Broadcast()
            else
                net.Send(targets)
            end

            pos = pos + size
            if pos <= #data then timer.Simple(delay, sendNext) end
        end

        sendNext()
    end

    function checkBadType(name, object)
        if isfunction(object) then
            lia.error("Net var '" .. name .. "' contains a bad object type!")
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
    function getNetVar(key, default)
        local value = lia.net.globals[key]
        return value ~= nil and value or default
    end

    FindMetaTable("Player").getLocalVar = FindMetaTable("Entity").getNetVar
end