local function formatDHM(seconds)
    seconds = math.max(seconds or 0, 0)
    local days = math.floor(seconds / 86400)
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)
    return L("daysHoursMinutes", days, hours, minutes)
end

net.Receive("RequestRoster", function(_, client)
    print("RequestRoster from", client, client:Nick())
    local character = client:getChar()
    if not character then
        print("No character for", client:Nick())
        return
    end

    local isLeader = client:hasPrivilege("Manage Faction Members") or character:hasFlags("V")
    if not isLeader then
        print("No permission for", client:Nick())
        return
    end

    local factionIndex = character:getFaction()
    if not factionIndex then
        print("No faction for", client:Nick())
        return
    end

    local faction = lia.faction.indices[factionIndex]
    if not faction then
        print("Invalid faction index", factionIndex)
        return
    end

    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local query = "SELECT lia_characters.name, lia_characters.faction, lia_characters.id, lia_characters.steamID, lia_characters.lastJoinTime, lia_players.totalOnlineTime, lia_players.lastOnline, lia_characters._class FROM lia_characters LEFT JOIN lia_players ON lia_characters.steamID = lia_players.steamID WHERE lia_characters.schema = '" .. lia.db.escape(gamemode) .. "' AND lia_characters.faction = " .. lia.db.convertDataType(faction.uniqueID)
    print("Executing roster query for faction", faction.uniqueID)
    lia.db.query(query, function(data)
        print("Query returned", data and #data or 0, "rows")
        local characters = {}
        if data then
            for _, v in ipairs(data) do
                print("Row:", v.id, v.name)
                local charID = tonumber(v.id)
                local isOnline = lia.char.loaded[charID] ~= nil
                local lastOnlineText
                if isOnline then
                    lastOnlineText = L("onlineNow")
                    print("Character", charID, "online now")
                else
                    local last = tonumber(v.lastOnline)
                    if not isnumber(last) then last = os.time(lia.time.toNumber(v.lastJoinTime)) end
                    local diff = os.time() - last
                    local since = lia.time.TimeSince(last)
                    local stripped = since:match("^(.-)%sago$") or since
                    lastOnlineText = string.format(L("agoFormat"), stripped, formatDHM(diff))
                end

                local classID = tonumber(v._class) or 0
                local classData = lia.class.list[classID]
                table.insert(characters, {
                    id = charID,
                    name = v.name,
                    faction = v.faction,
                    steamID = v.steamID,
                    class = classData and classData.name or L("none"),
                    lastOnline = lastOnlineText,
                    hoursPlayed = formatDHM(tonumber(v.totalOnlineTime) or 0)
                })
            end
        end

        print("Built characters table with", #characters, "entries")
        net.Start("CharacterInfo")
        net.WriteTable(characters)
        net.Send(client)
        print("Sent CharacterInfo to", client, client:Nick())
    end)
end)