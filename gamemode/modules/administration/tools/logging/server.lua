local MODULE = MODULE
function MODULE:SendLogsInChunks(client, categorizedLogs)
    local json = util.TableToJSON(categorizedLogs)
    local data = util.Compress(json)
    local chunks = {}
    for i = 1, #data, 32768 do
        chunks[#chunks + 1] = string.sub(data, i, i + 32768 - 1)
    end

    for i, chunk in ipairs(chunks) do
        net.Start("send_logs")
        net.WriteUInt(i, 16)
        net.WriteUInt(#chunks, 16)
        net.WriteUInt(#chunk, 16)
        net.WriteData(chunk, #chunk)
        net.Send(client)
    end
end

function MODULE:ReadLogEntries(category)
    local d = deferred.new()
    local maxDays = lia.config.get("LogRetentionDays", 7)
    local maxLines = lia.config.get("MaxLogLines", 1000)
    local cutoff = os.time() - maxDays * 86400
    local cutoffStr = os.date("%Y-%m-%d %H:%M:%S", cutoff)
    local condition = table.concat({"gamemode = " .. lia.db.convertDataType(engine.ActiveGamemode()), "category = " .. lia.db.convertDataType(category), "timestamp >= " .. lia.db.convertDataType(cutoffStr)}, " AND ") .. " ORDER BY id DESC LIMIT " .. maxLines
    lia.db.select({"timestamp", "message", "steamID"}, "logs", condition):next(function(res)
        local rows = res.results or {}
        local logs = {}
        for _, row in ipairs(rows) do
            logs[#logs + 1] = {
                timestamp = row.timestamp,
                message = row.message,
                steamID = row.steamID
            }
        end

        d:resolve(logs)
    end)
    return d
end

net.Receive("send_logs_request", function(_, client)
    if not MODULE:CanPlayerSeeLog(client) then return end
    local categories = {}
    for _, logType in pairs(lia.log.types) do
        categories[logType.category or "Uncategorized"] = true
    end

    local catList = {}
    for cat in pairs(categories) do
        if hook.Run("CanPlayerSeeLogCategory", client, cat) ~= false then catList[#catList + 1] = cat end
    end

    local logsByCategory = {}
    local function fetch(idx)
        if idx > #catList then return MODULE:SendLogsInChunks(client, logsByCategory) end
        local cat = catList[idx]
        MODULE:ReadLogEntries(cat):next(function(entries)
            logsByCategory[cat] = entries
            fetch(idx + 1)
        end)
    end

    fetch(1)
end)

function MODULE:CanPlayerSeeLog(client)
    return lia.config.get("AdminConsoleNetworkLogs", true) and client:hasPrivilege("Can See Logs")
end

function MODULE:PlayerConnect(name, ip)
    lia.log.add(nil, "playerConnect", name, ip)
end