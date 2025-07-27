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
        if idx > #catList then return MODULE:SendLogs(client, logsByCategory) end
        local cat = catList[idx]
        MODULE:ReadLogEntries(cat):next(function(entries)
            logsByCategory[cat] = entries
            fetch(idx + 1)
        end)
    end

    fetch(1)
end)