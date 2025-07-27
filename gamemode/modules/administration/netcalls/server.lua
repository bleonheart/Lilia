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

net.Receive("liaDBTablesRequest", function(_, client)
    if not client:hasPrivilege("View DB Tables") then return end
    lia.db.getTables():next(function(tables)
        net.Start("liaDBTables")
        net.WriteTable(tables or {})
        net.Send(client)
    end)
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

net.Receive("RequestStaffActions", function(_, client)
    local MODULE = lia.module.get("administration")
    if not client:hasPrivilege("View Staff Actions") then return end
    local function queryStaffActions(callback)
        lia.db.query([[
            SELECT tc.admin, tc.adminSteamID, lp.userGroup, 'Tickets Claimed' AS action, COUNT(*) AS actionCount
            FROM lia_ticketclaims AS tc
            LEFT JOIN lia_players AS lp ON lp.steamID = tc.adminSteamID
            GROUP BY tc.adminSteamID
            UNION ALL
            SELECT w.admin, w.adminSteamID, lp.userGroup, 'Warnings Issued' AS action, COUNT(*) AS actionCount
            FROM lia_warnings AS w
            LEFT JOIN lia_players AS lp ON lp.steamID = w.adminSteamID
            GROUP BY w.adminSteamID
            UNION ALL
            SELECT sa.admin, sa.adminSteamID, lp.userGroup, 'Bans Given' AS action, COUNT(*) AS actionCount
            FROM lia_staffactions AS sa
            LEFT JOIN lia_players AS lp ON lp.steamID = sa.adminSteamID
            WHERE sa.action = 'plyban'
            GROUP BY sa.adminSteamID
        ]], callback)
    end

    queryStaffActions(function(data)
        net.Start("StaffActions")
        net.WriteTable(data or {})
        net.Send(client)
    end)
end)

local function buildDefaultTable(g)
    local t = {}
    if not (CAMI and CAMI.GetPrivileges and CAMI.UsergroupInherits) then return t end
    for _, v in pairs(CAMI.GetPrivileges() or {}) do
        if CAMI.UsergroupInherits(g, v.MinAccess or "user") then t[v.Name] = true end
    end
    return t
end

local function ensureCAMIGroup(n, inh)
    if not (CAMI and CAMI.GetUsergroups and CAMI.RegisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if not g[n] then
        CAMI.RegisterUsergroup({
            Name = n,
            Inherits = n == "developer" and "superadmin" or inh or "user"
        })
    end
end

local function dropCAMIGroup(n)
    if not (CAMI and CAMI.GetUsergroups and CAMI.UnregisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if g[n] then CAMI.UnregisterUsergroup(n) end
end

local function getPrivList()
    local cats = {}
    for n, v in pairs(lia.administration.privileges) do
        local cat = v.Category or "Unassigned"
        cats[cat] = cats[cat] or {}
        table.insert(cats[cat], n)
    end

    for _, list in pairs(cats) do
        table.sort(list)
    end
    return cats
end

local function payloadGroups()
    return {
        cami = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups() or {},
        perms = lia.administration.groups or {},
        privCategories = getPrivList()
    }
end

local function getBanList()
    local t = {}
    local query = "SELECT steamID FROM lia_players WHERE banStart > 0"
    if lia.db.module == "mysqloo" and mysqloo and lia.db.getObject then
        local db = lia.db.getObject()
        if not db then return t end
        local q = db:query(query)
        q:start()
        q:wait()
        if not q:error() then
            for _, row in ipairs(q:getData() or {}) do
                t[row.steamID] = true
            end
        end
    else
        local data = lia.db.querySync(query)
        if istable(data) then
            for _, row in ipairs(data) do
                t[row.steamID] = true
            end
        end
    end
    return t
end

local function payloadPlayers()
    local bans = getBanList()
    local plys = {}
    for _, v in player.Iterator() do
        if v:IsBot() then continue end
        plys[#plys + 1] = {
            name = v:Nick(),
            id = v:SteamID(),
            id64 = v:SteamID64(),
            group = v:GetUserGroup(),
            lastJoin = os.time(lia.time.toNumber(v.lastJoin)),
            banned = bans[v:SteamID()] or false
        }

        bans[v:SteamID()] = nil
    end

    for id in pairs(bans) do
        plys[#plys + 1] = {
            name = "",
            id = id,
            id64 = util.SteamIDTo64(id),
            group = "",
            lastJoin = 0,
            banned = true
        }
    end
    return {
        players = plys
    }
end

local function buildCharEntry(client, row)
    local stored = lia.char.loaded[row.id]
    local info = stored and stored:getData() or lia.char.getCharData(row.id) or {}
    local isBanned = stored and stored:getBanned() or row.banned
    local allVars = {}
    for varName, varInfo in pairs(lia.char.vars) do
        if varInfo.noDisplay or varInfo.noNetworking then
            continue
        end

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

        if not checkBadType(varName, value) then
            allVars[varName] = value
        end
    end

    local lastUsedText
    if stored then
        lastUsedText = L("onlineNow")
    else
        lastUsedText = row.lastJoinTime
    end

    local bannedState = false
    if isBanned then
        local num = tonumber(isBanned)
        if num then
            bannedState = num == 1 or num > os.time()
        else
            bannedState = tobool(isBanned)
        end
    end

    local entry = {
        ID = row.id,
        Name = row.name,
        Desc = row.desc,
        Faction = row.faction,
        SteamID = row.steamID,
        Banned = bannedState and "Yes" or "No",
        BanningAdminName = info.charBanInfo and info.charBanInfo.name or "",
        BanningAdminSteamID = info.charBanInfo and info.charBanInfo.steamID or "",
        BanningAdminRank = info.charBanInfo and info.charBanInfo.rank or "",
        Money = row.money,
        LastUsed = lastUsedText,
        allVars = allVars
    }

    entry.extraDetails = {}
    hook.Run("CharListExtraDetails", client, entry, stored)
    return entry
end

local function collectOnlineCharacters(client, callback)
    local rows = {}
    for _, ply in player.Iterator() do
        local char = ply:getChar()
        if char then
            rows[#rows + 1] = {
                id = char:getID(),
                name = char:getName(),
                desc = char:getDesc(),
                faction = char:getFaction(),
                money = char:getMoney(),
                banned = char:getBanned(),
                lastJoinTime = os.time(lia.time.toNumber(ply.lastJoin)),
                steamID = ply:SteamID64()
            }
        end
    end

    local sendData = {}
    for _, row in ipairs(rows) do
        sendData[#sendData + 1] = buildCharEntry(client, row)
    end

    callback(sendData)
end

local function queryAllCharacters(client, callback)
    lia.db.query("SELECT * FROM lia_characters", function(data)
        local sendData = {}
        for _, row in ipairs(data or {}) do
            sendData[#sendData + 1] = buildCharEntry(client, row)
        end

        callback(sendData)
    end)
end

local function applyToCAMI(g, _)
    if not (CAMI and CAMI.GetUsergroups and CAMI.RegisterUsergroup) then return end
    ensureCAMIGroup(g, CAMI.GetUsergroups()[g] and CAMI.GetUsergroups()[g].Inherits or "user")
end

net.Receive("liaGroupsRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local function syncPrivileges()
        local payload = {}
        for group, perms in pairs(lia.administration.groups) do
            payload[group] = table.Copy(perms)
        end

        lia.administration.syncAdminGroups(payload)
    end

    syncPrivileges()
    local id = lia.net.WriteBigTable(p, payloadGroups())
    net.Start("liaGroupsDataDone")
    net.WriteString(id)
    net.Send(p)
end)

net.Receive("liaPlayersRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local id = lia.net.WriteBigTable(p, payloadPlayers())
    net.Start("liaPlayersDataDone")
    net.WriteString(id)
    net.Send(p)
end)

net.Receive("liaCharBrowserRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local mode = net.ReadString()
    if mode == "all" then
        queryAllCharacters(p, function(data)
            local id = lia.net.WriteBigTable(p, {
                mode = "all",
                list = data
            })

            net.Start("liaCharBrowserDone")
            net.WriteString(id)
            net.Send(p)
        end)
    else
        collectOnlineCharacters(p, function(data)
            local id = lia.net.WriteBigTable(p, {
                mode = "online",
                list = data
            })

            net.Start("liaCharBrowserDone")
            net.WriteString(id)
            net.Send(p)
        end)
    end
end)

net.Receive("liaDBTablesRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    lia.db.getTables():next(function(tables)
        net.Start("liaDBTables")
        net.WriteTable(tables or {})
        net.Send(p)
    end)
end)

net.Receive("liaGroupsAdd", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local n = net.ReadString()
    if n == "" then return end
    lia.administration.createGroup(n)
    lia.administration.groups[n] = buildDefaultTable(n)
    ensureCAMIGroup(n, "user")
    lia.administration.save(true)
    applyToCAMI(n, lia.administration.groups[n])
    local id = lia.net.WriteBigTable(nil, payloadGroups())
    net.Start("liaGroupsDataDone")
    net.WriteString(id)
    net.Broadcast()
    p:notify("Group '" .. n .. "' created.")
end)

net.Receive("liaGroupsRemove", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local n = net.ReadString()
    if n == "" or lia.administration.lia.administration.DefaultGroups[n] then return end
    lia.administration.removeGroup(n)
    lia.administration.groups[n] = nil
    dropCAMIGroup(n)
    lia.administration.save(true)
    local id = lia.net.WriteBigTable(nil, payloadGroups())
    net.Start("liaGroupsDataDone")
    net.WriteString(id)
    net.Broadcast()
    p:notify("Group '" .. n .. "' removed.")
end)

net.Receive("liaGroupsRename", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local old = net.ReadString()
    local new = net.ReadString()
    if old == "" or new == "" or lia.administration.lia.administration.DefaultGroups[old] or lia.administration.lia.administration.DefaultGroups[new] then return end
    if lia.administration.groups[new] or not lia.administration.groups[old] then return end
    lia.administration.groups[new] = lia.administration.groups[old]
    lia.administration.groups[old] = nil
    dropCAMIGroup(old)
    ensureCAMIGroup(new, "user")
    lia.administration.save(true)
    applyToCAMI(new, lia.administration.groups[new])
    for _, ply in player.Iterator() do
        if ply:GetUserGroup() == old then lia.administration.setPlayerGroup(ply, new) end
    end

    local id = lia.net.WriteBigTable(nil, payloadGroups())
    net.Start("liaGroupsDataDone")
    net.WriteString(id)
    net.Broadcast()
    p:notify("Group '" .. old .. "' renamed to '" .. new .. "'.")
end)

net.Receive("liaGroupsApply", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local g = net.ReadString()
    local t = net.ReadTable()
    if g == "" or lia.administration.lia.administration.DefaultGroups[g] then return end
    lia.administration.groups[g] = {}
    for k, v in pairs(t) do
        if v then lia.administration.groups[g][k] = true end
    end

    lia.administration.save(true)
    applyToCAMI(g, lia.administration.groups[g])
    local id = lia.net.WriteBigTable(nil, payloadGroups())
    net.Start("liaGroupsDataDone")
    net.WriteString(id)
    net.Broadcast()
    p:notify("Permissions saved for '" .. g .. "'.")
end)

net.Receive("liaGroupsDefaults", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local g = net.ReadString()
    if g == "" or lia.administration.lia.administration.DefaultGroups[g] then return end
    lia.administration.groups[g] = buildDefaultTable(g)
    lia.administration.save(true)
    applyToCAMI(g, lia.administration.groups[g])
    local id = lia.net.WriteBigTable(nil, payloadGroups())
    net.Start("liaGroupsDataDone")
    net.WriteString(id)
    net.Broadcast()
    p:notify("Defaults restored for '" .. g .. "'.")
end)

net.Receive("request_respawn", function(_, client)
    if not IsValid(client) or not client:getChar() then return end
    local respawnTime = lia.config.get("SpawnTime", 5)
    local spawnTimeOverride = hook.Run("OverrideSpawnTime", client, respawnTime)
    if spawnTimeOverride then respawnTime = spawnTimeOverride end
    local lastDeathTime = client:getNetVar("lastDeathTime", os.time())
    if os.time() - lastDeathTime < respawnTime then return end
    if not client:Alive() and not client:getNetVar("IsDeadRestricted", false) then client:Spawn() end
end)

net.Receive("ChangeAttribute", function(_, client)
    if not client:hasPrivilege("Commands - Manage Attributes") then return end
    local charID = net.ReadInt(32)
    net.ReadTable()
    local attribKey = net.ReadString()
    local amountStr = net.ReadString()
    local mode = net.ReadString()
    if not attribKey or not lia.attribs.list[attribKey] then
        for k, v in pairs(lia.attribs.list) do
            if lia.util.stringMatches(L(v.name), attribKey) or lia.util.stringMatches(k, attribKey) then
                attribKey = k
                break
            end
        end
    end

    if not attribKey or not lia.attribs.list[attribKey] then
        client:notifyLocalized("invalidAttributeKey")
        return
    end

    local attribValue = tonumber(amountStr)
    if not attribValue then
        client:notifyLocalized("invalidAmount")
        return
    end

    local targetClient = lia.char.getBySteamID(charID)
    if not IsValid(targetClient) then
        client:notifyLocalized("characterNotFound")
        return
    end

    local targetChar = targetClient:getChar()
    if not targetChar then
        client:notifyLocalized("characterNotFound")
        return
    end

    if mode == "Set" then
        if attribValue < 0 then
            client:notifyLocalized("attribNonNegative")
            return
        end

        targetChar:setAttrib(attribKey, attribValue)
        client:notifyLocalized("attribSet", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
        targetChar:getPlayer():notifyLocalized("yourAttributeSet", lia.attribs.list[attribKey].name, attribValue, client:Nick())
    elseif mode == "Add" then
        if attribValue <= 0 then
            client:notifyLocalized("attribPositive")
            return
        end

        local current = targetChar:getAttrib(attribKey, 0) or 0
        local newValue = current + attribValue
        if not isnumber(newValue) or newValue < 0 then
            client:notifyLocalized("attribCalculationError")
            return
        end

        targetChar:updateAttrib(attribKey, newValue)
        client:notifyLocalized("attribUpdate", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
        targetChar:getPlayer():notifyLocalized("yourAttributeIncreased", lia.attribs.list[attribKey].name, attribValue, client:Nick())
    else
        client:notifyLocalized("invalidMode")
    end
end)


