local function formatDHM(seconds)
    seconds = math.max(seconds or 0, 0)
    local days = math.floor(seconds / 86400)
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)
    return L("daysHoursMinutes", days, hours, minutes)
end

local function SendRoster(client)
    if not IsValid(client) or not client:hasPrivilege("Can Manage Factions") then return end
    local data = {}
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local fields = table.concat({
        "lia_characters.name",
        "lia_characters.id",
        "lia_characters.steamID",
        "lia_characters.playtime",
        "lia_characters.lastJoinTime",
        "lia_characters._class",
        "lia_characters.faction",
        "lia_players.lastOnline"
    }, ",")
    local condition = "lia_characters.schema = '" .. lia.db.escape(gamemode) .. "'"
    local query = "SELECT " .. fields .. " FROM lia_characters LEFT JOIN lia_players ON lia_characters.steamID = lia_players.steamID WHERE " .. condition
    lia.db.query(query, function(result)
        if result then
            for _, v in ipairs(result) do
                local charID = tonumber(v.id)
                local isOnline = lia.char.loaded[charID] ~= nil
                local lastOnlineText
                if isOnline then
                    lastOnlineText = L("onlineNow")
                else
                    local last = tonumber(v.lastOnline)
                    if not isnumber(last) then
                        last = os.time(lia.time.toNumber(v.lastJoinTime))
                    end
                    local lastDiff = os.time() - last
                    local timeSince = lia.time.TimeSince(last)
                    local timeStripped = timeSince:match("^(.-)%sago$") or timeSince
                    lastOnlineText = L("agoFormat", timeStripped, formatDHM(lastDiff))
                end

                local classID = tonumber(v._class) or 0
                local classData = lia.class.list[classID]
                local playTime = tonumber(v.playtime) or 0
                if isOnline then
                    local char = lia.char.loaded[charID]
                    if char then
                        local loginTime = char:getLoginTime() or os.time()
                        playTime = char:getPlayTime() + os.time() - loginTime
                    end
                end

                local faction = lia.faction.teams[v.faction]
                if faction then
                    data[faction.name] = data[faction.name] or {}
                    table.insert(data[faction.name], {
                        name = v.name,
                        id = charID,
                        steamID = v.steamID,
                        class = classData and classData.name or L("none"),
                        playTime = formatDHM(playTime),
                        lastOnline = lastOnlineText
                    })
                end
            end
        end

        lia.net.writeBigTable(client, "liaFactionRosterData", data)
    end)
end

net.Receive("liaRequestFactionRoster", function(_, client)
    SendRoster(client)
end)

