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

net.Receive("liaRequestTableData", function(_, client)
    if not client:hasPrivilege("viewDBTables") then return end
    local tbl = net.ReadString()
    if not tbl or tbl == "" then return end
    lia.db.select("*", tbl:gsub("lia_", "")):next(function(res)
        net.Start("liaDBTableData")
        net.WriteString(tbl)
        net.WriteTable(res or {})
        net.Send(client)
    end)
end)

net.Receive("lia_managesitrooms_action", function(_, client)
    if not client:hasPrivilege("manageSitRooms") then return end
    local action = net.ReadUInt(2)
    local name = net.ReadString()
    local rooms = lia.data.get("sitrooms", {})
    if action == 1 then
        local targetPos = rooms[name]
        if targetPos then
            client:setNetVar("previousSitroomPos", client:GetPos())
            client:SetPos(targetPos)
            client:notifyLocalized("sitroomTeleport", name)
            lia.log.add(client, "sendToSitRoom", client:Name(), name)
        end
    elseif action == 2 then
        local newName = net.ReadString()
        if newName ~= "" and not rooms[newName] and rooms[name] then
            rooms[newName] = rooms[name]
            rooms[name] = nil
            lia.data.set("sitrooms", rooms)
            client:notifyLocalized("sitroomRenamed")
            lia.log.add(client, "sitRoomRenamed", L("sitroomRenamedDetail", name, newName), L("logRenamedSitroom"))
        end
    elseif action == 3 then
        if rooms[name] then
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", rooms)
            client:notifyLocalized("sitroomRepositioned")
            lia.log.add(client, "sitRoomRepositioned", L("sitroomRepositionedDetail", name, tostring(client:GetPos())), L("logRepositionedSitroom"))
        end
    end
end)

net.Receive("liaRequestAllPKs", function(_, client)
    if not client:hasPrivilege("manageCharacters") then return end
    lia.db.select("*", "permakills"):next(function(data)
        net.Start("liaAllPKs")
        net.WriteTable(data or {})
        net.Send(client)
    end)
end)

net.Receive("liaRequestPKsCount", function(_, client)
    if not client:hasPrivilege("manageCharacters") then return end
    lia.db.count("permakills"):next(function(count)
        net.Start("liaPKsCount")
        net.WriteInt(count or 0, 32)
        net.Send(client)
    end)
end)

net.Receive("liaRequestFactionRoster", function(_, client)
    if not IsValid(client) or not client:hasPrivilege("canManageFactions") then return end
    local data = {}
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local charCondition = "schema = " .. lia.db.convertDataType(gamemode)
    lia.db.select("name, id, steamID, playtime, lastJoinTime, class, faction", "characters", charCondition):next(function(result)
        if not result or #result == 0 then
            lia.net.writeBigTable(client, "liaFactionRosterData", data)
            return
        end

        local processedCount = 0
        local totalCharacters = #result
        for _, v in ipairs(result) do
            local charID = tonumber(v.id)
            local isOnline = lia.char.isLoaded(charID)
            local lastOnlineText
            local playTime = tonumber(v.playtime) or 0
            if isOnline then
                lastOnlineText = L("onlineNow")
                local char = lia.char.getCharacter(charID)
                if char then
                    local loginTime = char:getLoginTime() or os.time()
                    playTime = char:getPlayTime() + os.time() - loginTime
                end
            else
                local playerCondition = "steamID = " .. lia.db.convertDataType(v.steamID)
                lia.db.selectOne("lastOnline", "players", playerCondition):next(function(playerData)
                    local last = tonumber(playerData and playerData.lastOnline)
                    if not isnumber(last) then last = os.time(lia.time.toNumber(v.lastJoinTime)) end
                    local lastDiff = os.time() - last
                    local timeSince = lia.time.TimeSince(last)
                    local timeStripped = timeSince:match("^(.-)%sago$") or timeSince
                    lastOnlineText = L("agoFormat", timeStripped, lia.time.formatDHM(lastDiff))
                    processCharacter(v, charID, isOnline, lastOnlineText, playTime, data)
                    processedCount = processedCount + 1
                    if processedCount >= totalCharacters then lia.net.writeBigTable(client, "liaFactionRosterData", data) end
                end)
            end

            if isOnline then
                processCharacter(v, charID, isOnline, lastOnlineText, playTime, data)
                processedCount = processedCount + 1
                if processedCount >= totalCharacters then lia.net.writeBigTable(client, "liaFactionRosterData", data) end
            end
        end
    end)

    function processCharacter(v, charID, isOnline, lastOnlineText, playTime, data)
        local classID = tonumber(v.class) or 0
        local classData = lia.class.list[classID]
        local faction = lia.faction.teams[v.faction]
        if faction and faction.index ~= FACTION_STAFF then
            data[faction.name] = data[faction.name] or {}
            table.insert(data[faction.name], {
                name = v.name,
                id = charID,
                steamID = v.steamID,
                class = classData and classData.name or L("none"),
                classID = classID,
                playTime = lia.time.formatDHM(playTime),
                lastOnline = lastOnlineText
            })
        end
    end
end)

net.Receive("liaRequestFullCharList", function(_, client)
    if not IsValid(client) or not client:hasPrivilege("listCharacters") then return end
    lia.db.select("id, name, `desc`, faction, steamID, lastJoinTime, banned, playtime, money", "characters"):next(function(data)
        local payload = {
            all = {},
            players = {}
        }

        if not data or #data == 0 then
            lia.net.writeBigTable(client, "liaFullCharList", payload)
            return
        end

        local processedCount = 0
        local totalCharacters = #data
        for _, row in ipairs(data) do
            local stored = lia.char.getCharacter(row.id)
            local bannedVal = tonumber(row.banned) or 0
            local isBanned = bannedVal ~= 0 and (bannedVal == -1 or bannedVal > os.time())
            local steamID = tostring(row.steamID)
            local playTime = tonumber(row.playtime) or 0
            if stored then
                local loginTime = stored:getLoginTime() or os.time()
                playTime = stored:getPlayTime() + os.time() - loginTime
            end

            local entry = {
                ID = row.id,
                Name = row.name,
                Desc = row.desc,
                Faction = row.faction,
                SteamID = steamID,
                LastUsed = stored and L("onlineNow") or row.lastJoinTime,
                Banned = isBanned,
                PlayTime = playTime,
                Money = tonumber(row.money) or 0
            }

            if isBanned then
                local banCondition = "charID = " .. lia.db.convertDataType(row.id) .. " AND `key` = " .. lia.db.convertDataType("charBanInfo")
                lia.db.selectOne("value", "chardata", banCondition):next(function(banData)
                    local banInfo = {}
                    if banData and banData.value and banData.value ~= "" then
                        local ok, decoded = pcall(pon.decode, banData.value)
                        if ok then
                            banInfo = decoded and decoded[1] or {}
                        else
                            banInfo = util.JSONToTable(banData.value) or {}
                        end
                    end

                    entry.BanningAdminName = banInfo.name or ""
                    entry.BanningAdminSteamID = banInfo.steamID or ""
                    entry.BanningAdminRank = banInfo.rank or ""
                    hook.Run("CharListEntry", entry, row)
                    payload.all[#payload.all + 1] = entry
                    payload.players[steamID] = payload.players[steamID] or {}
                    table.insert(payload.players[steamID], entry)
                    processedCount = processedCount + 1
                    if processedCount >= totalCharacters then lia.net.writeBigTable(client, "liaFullCharList", payload) end
                end)
            else
                hook.Run("CharListEntry", entry, row)
                payload.all[#payload.all + 1] = entry
                payload.players[steamID] = payload.players[steamID] or {}
                table.insert(payload.players[steamID], entry)
                processedCount = processedCount + 1
                if processedCount >= totalCharacters then lia.net.writeBigTable(client, "liaFullCharList", payload) end
            end
        end
    end)
end)

net.Receive("liaRequestAllFlags", function(_, client)
    if not client:hasPrivilege("canAccessFlagManagement") then return end
    local data = {}
    for _, ply in player.Iterator() do
        local char = ply:getChar()
        data[#data + 1] = {
            name = ply:Name(),
            steamID = ply:SteamID(),
            flags = char and char:getFlags() or "",
            playerFlags = ply:getFlags("player"),
        }
    end

    lia.net.writeBigTable(client, "liaAllFlags", data)
end)

net.Receive("liaModifyFlags", function(_, client)
    if not client:hasPrivilege("canAccessFlagManagement") then return end
    local steamID = net.ReadString()
    local flags = net.ReadString()
    local isPlayer = net.ReadBool()
    local target = lia.util.findPlayerBySteamID(steamID)
    if not IsValid(target) then return end
    flags = string.gsub(flags or "", "%s", "")
    if isPlayer then
        target:setFlags(flags, "player")
        client:notifyLocalized("playerFlagSet", client:Name(), target:Name(), flags)
    else
        local char = target:getChar()
        if not char then return end
        char:setFlags(flags)
        client:notifyLocalized("flagSet", client:Name(), target:Name(), flags)
    end
end)

net.Receive("liaRequestDatabaseView", function(_, client)
    if not IsValid(client) or not client:hasPrivilege("viewDBTables") then return end
    lia.db.getTables():next(function(tables)
        tables = tables or {}
        local data = {}
        local remaining = #tables
        if remaining == 0 then
            lia.net.writeBigTable(client, "liaDatabaseViewData", data)
            return
        end

        for _, tbl in ipairs(tables) do
            lia.db.select("*", tbl:gsub("lia_", "")):next(function(res)
                data[tbl] = res or {}
                remaining = remaining - 1
                if remaining == 0 then lia.net.writeBigTable(client, "liaDatabaseViewData", data) end
            end)
        end
    end)
end)

local function buildSummary()
    local d = deferred.new()
    local summary = {}
    local function ensureEntry(id, name)
        summary[id] = summary[id] or {
            player = name or "",
            steamID = id,
            usergroup = "",
            warnings = 0,
            tickets = 0,
            kicks = 0,
            kills = 0,
            respawns = 0,
            blinds = 0,
            mutes = 0,
            jails = 0,
            strips = 0
        }

        if name and name ~= "" then summary[id].player = name end
        return summary[id]
    end

    lia.db.select("steamName AS name, steamID, userGroup", "players"):next(function(playerRows)
        if not playerRows or #playerRows == 0 then
            d:resolve({})
            return
        end

        local processedCount = 0
        local totalPlayers = #playerRows
        for _, row in ipairs(playerRows) do
            local steamID = row.steamID
            if steamID and steamID ~= "" then
                local entry = ensureEntry(steamID, row.name)
                entry.usergroup = row.userGroup or ""
                local warnCondition = "warnerSteamID = " .. lia.db.convertDataType(steamID)
                lia.db.count("warnings", warnCondition):next(function(warnCount)
                    entry.warnings = warnCount or 0
                    local ticketCondition = "adminSteamID = " .. lia.db.convertDataType(steamID)
                    lia.db.count("ticketclaims", ticketCondition):next(function(ticketCount)
                        entry.tickets = ticketCount or 0
                        local actionCondition = "staffSteamID = " .. lia.db.convertDataType(steamID)
                        lia.db.select("action", "staffactions", actionCondition):next(function(actionRows)
                            for _, actionRow in ipairs(actionRows or {}) do
                                local action = actionRow.action
                                if action == "plykick" then
                                    entry.kicks = (entry.kicks or 0) + 1
                                elseif action == "plykill" then
                                    entry.kills = (entry.kills or 0) + 1
                                elseif action == "plyrespawn" then
                                    entry.respawns = (entry.respawns or 0) + 1
                                elseif action == "plyblind" then
                                    entry.blinds = (entry.blinds or 0) + 1
                                elseif action == "plymute" then
                                    entry.mutes = (entry.mutes or 0) + 1
                                elseif action == "plyjail" then
                                    entry.jails = (entry.jails or 0) + 1
                                elseif action == "plystrip" then
                                    entry.strips = (entry.strips or 0) + 1
                                end
                            end

                            processedCount = processedCount + 1
                            if processedCount >= totalPlayers then
                                local list = {}
                                for _, info in pairs(summary) do
                                    info.warnings = info.warnings or 0
                                    info.tickets = info.tickets or 0
                                    info.kicks = info.kicks or 0
                                    info.kills = info.kills or 0
                                    info.respawns = info.respawns or 0
                                    info.blinds = info.blinds or 0
                                    info.mutes = info.mutes or 0
                                    info.jails = info.jails or 0
                                    info.strips = info.strips or 0
                                    info.usergroup = info.usergroup or ""
                                    list[#list + 1] = info
                                end

                                d:resolve(list)
                            end
                        end)
                    end)
                end)
            else
                processedCount = processedCount + 1
                if processedCount >= totalPlayers then
                    local list = {}
                    for _, info in pairs(summary) do
                        info.warnings = info.warnings or 0
                        info.tickets = info.tickets or 0
                        info.kicks = info.kicks or 0
                        info.kills = info.kills or 0
                        info.respawns = info.respawns or 0
                        info.blinds = info.blinds or 0
                        info.mutes = info.mutes or 0
                        info.jails = info.jails or 0
                        info.strips = info.strips or 0
                        info.usergroup = info.usergroup or ""
                        list[#list + 1] = info
                    end

                    d:resolve(list)
                end
            end
        end
    end)
    return d
end

net.Receive("liaRequestStaffSummary", function(_, client)
    if not client:hasPrivilege("viewStaffManagement") then return end
    buildSummary():next(function(data) lia.net.writeBigTable(client, "liaStaffSummary", data) end)
end)

net.Receive("liaRequestPlayers", function(_, client)
    if not client:hasPrivilege("canAccessPlayerList") then return end
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    lia.db.select("steamName, steamID, userGroup, firstJoin, lastOnline, totalOnlineTime", "players"):next(function(data)
        data = data or {}
        local processedCount = 0
        local totalPlayers = #data
        if totalPlayers == 0 then
            lia.net.writeBigTable(client, "liaAllPlayers", data)
            return
        end

        for i, row in ipairs(data) do
            local charCondition = "steamID = " .. lia.db.convertDataType(row.steamID) .. " AND schema = " .. lia.db.convertDataType(gamemode)
            lia.db.count("characters", charCondition):next(function(charCount)
                row.characterCount = charCount
                local warnCondition = "warnedSteamID = " .. lia.db.convertDataType(row.steamID)
                lia.db.count("warnings", warnCondition):next(function(warnCount)
                    row.warnings = warnCount
                    local ticketReqCondition = "requesterSteamID = " .. lia.db.convertDataType(row.steamID)
                    lia.db.count("ticketclaims", ticketReqCondition):next(function(ticketReqCount)
                        row.ticketsRequested = ticketReqCount
                        local ticketClaimCondition = "adminSteamID = " .. lia.db.convertDataType(row.steamID)
                        lia.db.count("ticketclaims", ticketClaimCondition):next(function(ticketClaimCount)
                            row.ticketsClaimed = ticketClaimCount
                            local ply = player.GetBySteamID(tostring(row.steamID))
                            if IsValid(ply) then row.totalOnlineTime = ply:getPlayTime() end
                            processedCount = processedCount + 1
                            if processedCount >= totalPlayers then lia.net.writeBigTable(client, "liaAllPlayers", data) end
                        end)
                    end)
                end)
            end)
        end
    end)
end)

net.Receive("liaRequestPlayerCharacters", function(_, client)
    if not (client:hasPrivilege("canAccessPlayerList") or client:hasPrivilege("canManageFactions")) then return end
    local steamID = net.ReadString()
    if not steamID or steamID == "" then return end
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local condition = "steamID = " .. lia.db.convertDataType(steamID) .. " AND schema = '" .. lia.db.escape(gamemode) .. "'"
    lia.db.select("name", "characters", condition):next(function(data)
        local chars = {}
        if data then
            for _, v in ipairs(data) do
                chars[#chars + 1] = v.name
            end
        end

        lia.net.writeBigTable(client, "liaPlayerCharacters", {
            steamID = steamID,
            characters = chars
        })
    end)
end)