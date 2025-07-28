lia.net = lia.net or {}
lia.net.globals = lia.net.globals or {}
local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")
if SERVER then
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

    playerMeta.getLocalVar = entityMeta.getNetVar
end

function lia.net.WriteBigTable(receiver, tbl)
    local raw = pon.encode(tbl)
    local data = util.Compress(raw)
    local len = #data
    local id = util.CRC(tostring(SysTime()) .. len)
    local parts = math.ceil(len / 60000)
    for i = 1, parts do
        local chunk = string.sub(data, (i - 1) * 60000 + 1, math.min(i * 60000, len))
        net.Start("liaBigTableChunk")
        net.WriteString(id)
        net.WriteUInt(i, 16)
        net.WriteUInt(parts, 16)
        net.WriteUInt(#chunk, 16)
        net.WriteData(chunk, #chunk)
        if SERVER then
            if IsEntity(receiver) then
                net.Send(receiver)
            else
                net.Broadcast()
            end
        else
            net.SendToServer()
        end
    end

    net.Start("liaBigTableDone")
    net.WriteString(id)
    if SERVER then
        if IsEntity(receiver) then
            net.Send(receiver)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end
    return id
end

function lia.net.ReadBigTable(id)
    local parts = lia.net.bigTables[id]
    if not parts then return end
    lia.net.bigTables[id] = nil
    local data = table.concat(parts)
    local raw = util.Decompress(data)
    local tbl = pon.decode(raw)
    return tbl, raw and #raw or 0
end