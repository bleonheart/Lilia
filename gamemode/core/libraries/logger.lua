lia.log = lia.log or {}
lia.log.types = lia.log.types or {}
if SERVER then
    function lia.log.addType(logType, func, category)
        lia.log.types[logType] = {
            func = func,
            category = category,
        }
    end

    function lia.log.getString(client, logType, ...)
        local logData = lia.log.types[logType]
        if not logData then return end
        if isfunction(logData.func) then
            local success, result = pcall(logData.func, client, ...)
            if success then return result, logData.category end
        end
    end

    function lia.log.add(client, logType, ...)
        local logString, category = lia.log.getString(client, logType, ...)
        if not isstring(category) then category = "Uncategorized" end
        if not isstring(logString) then return end
        hook.Run("OnServerLog", client, logType, logString, category)
        lia.printLog(category, logString)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local charID
        local steamID
        if IsValid(client) then
            local char = client:getChar()
            charID = char and char:getID() or nil
            steamID = client:SteamID()
        end

        lia.db.insertTable({
            _timestamp = timestamp,
            _gamemode = engine.ActiveGamemode(),
            _category = category,
            _message = logString,
            _charID = charID,
            _steamID = steamID
        }, nil, "logs")
    end
end
