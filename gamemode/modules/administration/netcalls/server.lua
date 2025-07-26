net.Receive("cfgSet", function(_, client)
    local key = net.ReadString()
    local name = net.ReadString()
    local value = net.ReadType()
    if type(lia.config.stored[key].default) == type(value) and hook.Run("CanPlayerModifyConfig", client, key) ~= false then
        local oldValue = lia.config.stored[key].value
        lia.config.set(key, value)
        hook.Run("ConfigChanged", key, value, oldValue, client)
        if istable(value) then
            local value2 = "["
            local count = table.Count(value)
            local i = 1
            for _, v in SortedPairs(value) do
                value2 = value2 .. v .. (i == count and "]" or ", ")
                i = i + 1
            end

            value = value2
        end

        client:notifyLocalized("cfgSet", client:Name(), name, tostring(value))
        lia.log.add(client, "configChange", name, tostring(oldValue), tostring(value))
    end
end)

local DB_CHUNK = 60000
local function sendTableData(client, name, data)
    local payload = {
        tbl = name,
        data = data or {}
    }

    local json = util.TableToJSON(payload)
    local comp = util.Compress(json)
    local len = #comp
    local id = util.CRC(tostring(SysTime()) .. len)
    local parts = math.ceil(len / DB_CHUNK)
    for i = 1, parts do
        local chunk = string.sub(comp, (i - 1) * DB_CHUNK + 1, math.min(i * DB_CHUNK, len))
        net.Start("liaDBTableDataChunk")
        net.WriteString(id)
        net.WriteUInt(i, 16)
        net.WriteUInt(parts, 16)
        net.WriteUInt(#chunk, 16)
        net.WriteData(chunk, #chunk)
        net.Send(client)
    end

    net.Start("liaDBTableDataDone")
    net.WriteString(id)
    net.Send(client)
end

net.Receive("liaRequestTableData", function(_, client)
    if not client:hasPrivilege("View DB Tables") then return end
    local tbl = net.ReadString()
    if not tbl or tbl == "" then return end
    lia.db.query("SELECT * FROM " .. lia.db.escapeIdentifier(tbl), function(res) sendTableData(client, tbl, res or {}) end)
end)

net.Receive("lia_managesitrooms_action", function(_, client)
    if not client:hasPrivilege("Manage SitRooms") then return end
    local action = net.ReadUInt(2)
    local name = net.ReadString()
    local data = lia.data.get("sitrooms", {})
    local rooms = data.rooms or data
    if action == 1 then
        local targetPos = rooms[name]
        if targetPos then
            client:SetNW2Vector("previousSitroomPos", client:GetPos())
            client:SetPos(targetPos)
            client:notifyLocalized("sitroomTeleport", name)
            lia.log.add(client, "sendToSitRoom", client:Name(), name)
        end
    elseif action == 2 then
        local newName = net.ReadString()
        if newName ~= "" then
            if not rooms[newName] and rooms[name] then
                rooms[newName] = rooms[name]
                rooms[name] = nil
                lia.data.set("sitrooms", {map = game.GetMap(), rooms = rooms})

                client:notifyLocalized("sitroomRenamed")
                lia.log.add(client, "sitRoomRenamed", string.format("Map: %s | Old: %s | New: %s", game.GetMap(), name, newName), L("logRenamedSitroom"))
            end
        end
    elseif action == 3 then
        if rooms[name] then
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", {map = game.GetMap(), rooms = rooms})

            client:notifyLocalized("sitroomRepositioned")
            lia.log.add(client, "sitRoomRepositioned", string.format("Map: %s | Name: %s | New Position: %s", game.GetMap(), name, tostring(client:GetPos())), L("logRepositionedSitroom"))
        end
    end
end)
