local function formatDHM(seconds)
    seconds = math.max(seconds or 0, 0)
    local days = math.floor(seconds / 86400)
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)
    return string.format("%dd %dh %dm", days, hours, minutes)
end

net.Receive("RequestRoster", function(_, client)
    print("[RequestRoster] Received request from", client:Nick(), client:SteamID())
    local character = client:getChar()
    if not character then
        print("[RequestRoster] No character found for", client:Nick())
        return
    end

    local isLeader = client:IsSuperAdmin() or character:hasFlags("V")
    if not isLeader then
        print("[RequestRoster] Permission denied for", client:Nick())
        return
    end

    local factionIndex = character:getFaction()
    if not factionIndex then
        print("[RequestRoster] Character has no faction:", character:getID())
        return
    end

    local faction = lia.faction.indices[factionIndex]
    if not faction then
        print("[RequestRoster] Invalid faction index:", factionIndex)
        return
    end

    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local schemaEscaped = lia.db.escape(gamemode)
    local fields = "lia_characters.name, lia_characters.faction, lia_characters.id, lia_characters.steamID, lia_characters.lastJoinTime, lia_players.totalOnlineTime, lia_players.lastOnline, lia_characters._class"
    local condition = "lia_characters.schema = '" .. schemaEscaped .. "' AND lia_characters.faction = " .. lia.db.convertDataType(faction.uniqueID)
    local query = "SELECT " .. fields .. " FROM lia_characters LEFT JOIN lia_players ON lia_characters.steamID = lia_players.steamID WHERE " .. condition
    print("[RequestRoster] Running DB query:", query)
    lia.db.query(query, function(data)
        if not data then
            print("[RequestRoster] Query returned no data for faction", faction.uniqueID)
        else
            print("[RequestRoster] Query returned", #data, "rows for faction", faction.uniqueID)
        end

        local characters = {}
        for _, v in ipairs(data or {}) do
            local charID = tonumber(v.id)
            local isOnline = lia.char.loaded[charID] ~= nil
            local lastOnlineText
            if isOnline then
                lastOnlineText = L("onlineNow")
            else
                local last = tonumber(v.lastOnline)
                if not isnumber(last) then last = os.time(lia.time.toNumber(v.lastJoinTime)) end
                local lastDiff = os.time() - last
                local timeSince = lia.time.TimeSince(last)
                local timeStripped = timeSince:match("^(.-)%sago$") or timeSince
                lastOnlineText = string.format("%s (%s) ago", timeStripped, formatDHM(lastDiff))
            end

            local classID = tonumber(v._class) or 0
            local classData = lia.class.list[classID]
            table.insert(characters, {
                id = charID,
                name = v.name,
                faction = v.faction,
                steamID = v.steamID,
                class = classData and classData.name or "None",
                lastOnline = lastOnlineText,
                hoursPlayed = formatDHM(tonumber(v.totalOnlineTime) or 0)
            })
        end

        print("[RequestRoster] Prepared", #characters, "character entries for", client:Nick())
        net.Start("CharacterInfo")
        net.WriteString(faction.uniqueID)
        net.WriteTable(characters)
        net.Send(client)
        print("[RequestRoster] Sent CharacterInfo to", client:Nick())
    end)
end)