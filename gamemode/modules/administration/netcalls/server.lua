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

net.Receive("liaRequestDBTables", function(_, client)
    if not client:hasPrivilege("View DB Tables") then return end
    lia.db.getTables():next(function(tables)
        net.Start("liaDBTables")
        net.WriteTable(tables or {})
        net.Send(client)
    end)
end)

net.Receive("liaRequestCharList", function(_, client)
    if not client:hasPrivilege("List Characters") then return end
    local identifier = net.ReadString()
    local target
    if identifier and identifier ~= "" then
        target = lia.util.findPlayer(client, identifier)
        if not IsValid(target) then return end
    else
        target = client
    end

    local steam64 = target:SteamID64()
    lia.db.query("SELECT * FROM lia_characters WHERE _steamID = " .. lia.db.convertDataType(steam64), function(data)
        if not data or #data == 0 then
            client:notifyLocalized("noCharactersFound")
            return
        end

        local sendData = {}
        for _, row in ipairs(data) do
            local stored = lia.char.loaded[row._id]
            local info = stored and stored:getData() or lia.char.getCharData(row._id) or {}
            local isBanned = stored and stored:getBanned() or row._banned
            local allVars = {}
            for varName, varInfo in pairs(lia.char.vars) do
                local value
                if stored then
                    if varName == "data" then
                        value = stored:getData()
                    elseif varName == "var" then
                        value = stored:getVar()
                    else
                        local getter = stored["get" .. varName:sub(1, 1):upper() .. varName:sub(2)]
                        if isfunction(getter) then
                            value = getter(stored)
                        else
                            value = stored.vars and stored.vars[varName]
                        end
                    end
                else
                    if varName == "data" then
                        value = info
                    elseif varInfo.field and row[varInfo.field] ~= nil then
                        local raw = row[varInfo.field]
                        if isnumber(varInfo.default) then
                            value = tonumber(raw) or varInfo.default
                        elseif isbool(varInfo.default) then
                            value = tobool(raw)
                        elseif istable(varInfo.default) then
                            value = util.JSONToTable(raw or "{}")
                        else
                            value = raw
                        end
                    else
                        value = varInfo.default
                    end
                end

                allVars[varName] = value
            end

            local lastUsedText = stored and L("onlineNow") or row._lastJoinTime
            local entry = {
                ID = row._id,
                Name = row._name,
                Desc = row._desc,
                Faction = row._faction,
                Banned = isBanned and "Yes" or "No",
                BanningAdminName = info.charBanInfo and info.charBanInfo.name or "",
                BanningAdminSteamID = info.charBanInfo and info.charBanInfo.steamID or "",
                BanningAdminRank = info.charBanInfo and info.charBanInfo.rank or "",
                Money = row._money,
                LastUsed = lastUsedText,
                allVars = allVars
            }

            entry.extraDetails = {}
            hook.Run("CharListExtraDetails", client, entry, stored)
            table.insert(sendData, entry)
        end

        net.Start("DisplayCharList")
        net.WriteTable(sendData)
        net.WriteString(steam64)
        net.Send(client)
    end)
end)

net.Receive("lia_managesitrooms_action", function(_, client)
    if not client:hasPrivilege("Manage SitRooms") then return end
    local action = net.ReadUInt(2)
    local name = net.ReadString()
    local mapName = game.GetMap()
    local folder = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local baseCondition = "_folder = " .. lia.db.convertDataType(folder) .. " AND _map = " .. lia.db.convertDataType(mapName)
    if action == 1 then
        local condition = baseCondition .. " AND _name = " .. lia.db.convertDataType(name)
        lia.db.selectOne({"_pos"}, "sitrooms", condition):next(function(row)
            local targetPos = row and lia.data.decodeVector(row._pos)
            if targetPos then
                client:SetNW2Vector("previousSitroomPos", client:GetPos())
                client:SetPos(targetPos)
                client:notifyLocalized("sitroomTeleport", name)
                lia.log.add(client, "sendToSitRoom", client:Name(), name)
            end
        end)
    elseif action == 2 then
        local newName = net.ReadString()
        if newName ~= "" then
            local newCondition = baseCondition .. " AND _name = " .. lia.db.convertDataType(newName)
            lia.db.exists("sitrooms", newCondition):next(function(exists)
                if exists then return end
                local condition = baseCondition .. " AND _name = " .. lia.db.convertDataType(name)
                lia.db.updateTable({
                    _name = newName
                }, nil, "sitrooms", condition)

                client:notifyLocalized("sitroomRenamed")
                lia.log.add(client, "sitRoomRenamed", string.format("Map: %s | Old: %s | New: %s", mapName, name, newName), L("logRenamedSitroom"))
            end)
        end
    elseif action == 3 then
        local condition = baseCondition .. " AND _name = " .. lia.db.convertDataType(name)
        lia.db.updateTable({
            _pos = lia.data.serialize(client:GetPos())
        }, nil, "sitrooms", condition)

        client:notifyLocalized("sitroomRepositioned")
        lia.log.add(client, "sitRoomRepositioned", string.format("Map: %s | Name: %s | New Position: %s", mapName, name, tostring(client:GetPos())), L("logRepositionedSitroom"))
    end
end)