mysql = mysql or {}
mysql.module = mysql.module or "sqlite"
mysql.queue = mysql.queue or {}
mysql.state = mysql.state or "disconnected"
local QUERY = {}
QUERY.__index = QUERY
local validModules = {
    sqlite = true,
    mysqloo = true
}

if mysql.module == "mysqloo" and mysql.connection and isfunction(mysql.connection.status) then
    local ok, status = pcall(mysql.connection.status, mysql.connection)
    if ok and mysqloo and status == mysqloo.DATABASE_CONNECTED then mysql.state = "connected" end
end

local function logError(message)
    ErrorNoHalt("[mysql] " .. tostring(message) .. "\n")
end

local function safeCall(label, callback, ...)
    if not isfunction(callback) then return end
    local ok, err = pcall(callback, ...)
    if not ok then logError(label .. " callback failed: " .. tostring(err)) end
end

function mysql:QuoteIdentifier(identifier)
    identifier = tostring(identifier or "")
    if identifier == "*" then return "*" end
    local parts = string.Explode(".", identifier, false)
    for i = 1, #parts do
        parts[i] = "`" .. parts[i]:gsub("`", "``") .. "`"
    end
    return table.concat(parts, ".")
end

function mysql:Escape(value)
    local text = tostring(value == nil and "" or value)
    if self.module == "mysqloo" then
        if self.connection then
            local ok, escaped = pcall(self.connection.escape, self.connection, text)
            if ok then return escaped end
            logError("MySQL escaping failed: " .. tostring(escaped))
        end
        return text:gsub("\\", "\\\\"):gsub("\0", "\\0"):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("'", "\\'"):gsub('"', '\\"'):gsub("\26", "\\Z")
    end
    return sql.SQLStr(text, true)
end

function mysql:Value(value)
    if value == nil or value == NULL then return "NULL" end
    if isbool(value) then return value and "1" or "0" end
    if isnumber(value) then return tostring(value) end
    if istable(value) then value = util.TableToJSON(value) end
    return "'" .. self:Escape(value) .. "'"
end

function mysql:SetModule(moduleName)
    moduleName = string.lower(tostring(moduleName or "sqlite"))
    if moduleName == "mysql" then moduleName = "mysqloo" end
    if not validModules[moduleName] then error(string.format("[mysql] Unsupported database module '%s'.", moduleName)) end
    if self.module ~= moduleName and self.connection then self:Disconnect() end
    self.module = moduleName
    return self
end

function mysql:IsConnected()
    if self.module == "sqlite" then return self.state == "connected" end
    if self.module ~= "mysqloo" or self.state ~= "connected" or not self.connection then return false end
    if mysqloo and mysqloo.DATABASE_CONNECTED ~= nil and isfunction(self.connection.status) then
        local ok, status = pcall(self.connection.status, self.connection)
        return ok and status == mysqloo.DATABASE_CONNECTED
    end
    return true
end

function mysql:_flushQueue()
    if not self:IsConnected() then return end
    local queued = self.queue
    self.queue = {}
    for i = 1, #queued do
        local entry = queued[i]
        self:RawQuery(entry[1], entry[2], entry[3], true)
    end
end

function mysql:OnConnected()
    self.state = "connected"
    MsgC(Color(25, 235, 25), string.format("[mysql] Connected using %s.\n", self.module))
    self:_flushQueue()
    safeCall("connection", self.connectCallback)
    self.connectCallback, self.failureCallback = nil, nil
    hook.Run("MySQLConnected", self.module)
end

function mysql:OnConnectionFailed(errorText)
    self.state = "failed"
    logError(string.format("Connection failed using %s: %s", self.module, tostring(errorText)))
    safeCall("connection failure", self.failureCallback, errorText)
    hook.Run("DatabaseConnectionFailed", errorText, self.module)
end

function mysql:Connect(host, username, password, database, port, socket, flags, callback, failureCallback)
    self.intentionalDisconnect = false
    if self:IsConnected() then
        safeCall("connection", callback)
        return true
    end

    if self.state == "connecting" then
        if callback then
            local previous = self.connectCallback
            self.connectCallback = function(...)
                safeCall("connection", previous, ...)
                safeCall("connection", callback, ...)
            end
        end
        return true
    end

    self.connectCallback, self.failureCallback = callback, failureCallback
    self.connectionOptions = {host, username, password, database, port, socket, flags}
    self.state = "connecting"
    if self.module == "sqlite" then
        timer.Simple(0, function() self:OnConnected() end)
        return true
    end

    local loaded, moduleResult = pcall(require, "mysqloo")
    if not loaded and not mysqloo then
        self:OnConnectionFailed("mysqloo is not installed: " .. tostring(moduleResult))
        return false
    end

    if not mysqloo or not isfunction(mysqloo.connect) then
        self:OnConnectionFailed("mysqloo did not expose a connect function")
        return false
    end

    port = tonumber(port) or 3306
    local ok, connection
    if isstring(socket) and socket ~= "" then
        ok, connection = pcall(mysqloo.connect, host or "127.0.0.1", username or "", password or "", database or "", port, socket, flags or 0)
    else
        ok, connection = pcall(mysqloo.connect, host or "127.0.0.1", username or "", password or "", database or "", port)
    end

    if not ok or not connection then
        self:OnConnectionFailed(connection or "mysqloo.connect returned no connection")
        return false
    end

    self.connection = connection
    connection.onConnected = function(db)
        local charsetOK, charsetError = db:setCharacterSet("utf8mb4")
        if charsetOK == false then logError("Could not set utf8mb4: " .. tostring(charsetError)) end
        self:OnConnected()
    end

    connection.onConnectionFailed = function(_, errorText) self:OnConnectionFailed(errorText) end
    connection.onDisconnected = function(_, errorText)
        self.state = "disconnected"
        logError("MySQL connection lost: " .. tostring(errorText or "unknown reason"))
        hook.Run("DatabaseDisconnected", errorText)
        if not self.intentionalDisconnect then
            timer.Create("mysql.Reconnect", 5, 1, function()
                if self.module ~= "mysqloo" or self:IsConnected() then return end
                local options = self.connectionOptions or {}
                self.connection = nil
                self:Connect(unpack(options))
            end)
        end
    end

    connection:connect()
    timer.Create("mysql.KeepAlive", 300, 0, function()
        if self.module ~= "mysqloo" or not self.connection then return end
        if not self:IsConnected() then
            timer.Remove("mysql.KeepAlive")
            local options = self.connectionOptions or {}
            self.connection, self.state = nil, "disconnected"
            self:Connect(unpack(options))
            return
        end

        local pingOK, pingError = pcall(self.connection.ping, self.connection)
        if not pingOK then logError("MySQL keepalive failed: " .. tostring(pingError)) end
    end)
    return true
end

function mysql:Disconnect()
    self.intentionalDisconnect = true
    timer.Remove("mysql.KeepAlive")
    timer.Remove("mysql.Reconnect")
    if self.module == "mysqloo" and self.connection then pcall(self.connection.disconnect, self.connection, true) end
    self.connection, self.state = nil, "disconnected"
end

function mysql:Queue(statement, callback, errorCallback)
    self.queue[#self.queue + 1] = {statement, callback, errorCallback}
    return true
end

function mysql:RawQuery(statement, callback, errorCallback, skipQueue)
    if not isstring(statement) or string.Trim(statement) == "" then
        local message = "Refused to execute an empty query"
        logError(message)
        safeCall("query error", errorCallback, message, statement)
        return false
    end

    if not skipQueue and not self:IsConnected() then return self:Queue(statement, callback, errorCallback) end
    if self.module == "sqlite" then
        local started = SysTime()
        local result = sql.Query(statement)
        if result == false then
            local message = tostring(sql.LastError())
            logError(string.format("SQLite query failed:\nQuery: %s\nError: %s", statement, message))
            safeCall("query error", errorCallback, message, statement)
            return false
        end

        local affectedRows = tonumber(sql.QueryValue("SELECT changes()")) or 0
        local lastID
        if string.match(string.upper(string.Trim(statement)), "^INSERT") then lastID = affectedRows > 0 and tonumber(sql.QueryValue("SELECT last_insert_rowid()")) or 0 end
        local elapsed = SysTime() - started
        if elapsed >= 0.25 then MsgC(Color(255, 200, 0), string.format("[mysql] Slow SQLite query (%.3fs): %s\n", elapsed, statement)) end
        safeCall("SQLite query", callback, result or {}, lastID, affectedRows)
        return true
    end

    if self.module ~= "mysqloo" or not self.connection then
        local message = "No active Mysqloo connection"
        logError(message .. "\nQuery: " .. statement)
        safeCall("query error", errorCallback, message, statement)
        return false
    end

    local object = self.connection:query(statement)
    object:setOption(mysqloo.OPTION_NAMED_FIELDS)
    object.onSuccess = function(queryObject, rows) safeCall("MySQL query", callback, rows or {}, tonumber(queryObject:lastInsert()), tonumber(queryObject:affectedRows())) end
    object.onError = function(_, errorText)
        logError(string.format("MySQL query failed:\nQuery: %s\nError: %s", statement, tostring(errorText)))
        safeCall("query error", errorCallback, errorText, statement)
    end

    object:start()
    return object
end

function mysql:Transaction(statements, callback, errorCallback)
    if not istable(statements) then
        safeCall("transaction error", errorCallback, "queries must be a table")
        return false
    end

    local beginSQL = self.module == "sqlite" and "BEGIN TRANSACTION" or "START TRANSACTION"
    self:RawQuery(beginSQL, function()
        local index = 1
        local function rollback(message)
            self:RawQuery("ROLLBACK", function() safeCall("transaction error", errorCallback, message) end, function() safeCall("transaction error", errorCallback, message) end)
        end

        local function runNext()
            if index > #statements then
                self:RawQuery("COMMIT", function() safeCall("transaction", callback) end, rollback)
                return
            end

            local statement = statements[index]
            index = index + 1
            self:RawQuery(statement, runNext, rollback)
        end

        runNext()
    end, function(message) safeCall("transaction error", errorCallback, message) end)
    return true
end

function QUERY:New(tableName, queryType)
    return setmetatable({
        tableName = tableName,
        queryType = queryType,
        selectList = {},
        insertList = {},
        updateList = {},
        createList = {},
        whereList = {},
        orderByList = {}
    }, QUERY)
end

function QUERY:ForTable(name)
    self.tableName = name
    return self
end

function QUERY:Callback(callback)
    self.callback = callback
    return self
end

function QUERY:ErrorCallback(callback)
    self.errorCallback = callback
    return self
end

function QUERY:Select(field)
    self.selectList[#self.selectList + 1] = mysql:QuoteIdentifier(field)
    return self
end

function QUERY:Insert(key, value)
    self.insertList[#self.insertList + 1] = {mysql:QuoteIdentifier(key), mysql:Value(value)}
    return self
end

function QUERY:Update(key, value)
    self.updateList[#self.updateList + 1] = {mysql:QuoteIdentifier(key), mysql:Value(value)}
    return self
end

function QUERY:Create(key, definition)
    self.createList[#self.createList + 1] = {mysql:QuoteIdentifier(key), definition}
    return self
end

function QUERY:Add(key, definition)
    self.add = {mysql:QuoteIdentifier(key), definition}
    return self
end

function QUERY:Drop(key)
    self.drop = mysql:QuoteIdentifier(key)
    return self
end

function QUERY:PrimaryKey(key)
    local keys = istable(key) and key or string.Explode(",", tostring(key), false)
    for i = 1, #keys do
        keys[i] = mysql:QuoteIdentifier(string.Trim(keys[i]))
    end

    self.primaryKey = table.concat(keys, ", ")
    return self
end

function QUERY:Limit(value)
    self.limit = math.max(0, tonumber(value) or 0)
    return self
end

function QUERY:Offset(value)
    self.offset = math.max(0, tonumber(value) or 0)
    return self
end

function QUERY:WhereRaw(expression)
    self.whereList[#self.whereList + 1] = tostring(expression)
    return self
end

function QUERY:_where(key, operator, value)
    local identifier = mysql:QuoteIdentifier(key)
    if value == nil or value == NULL then
        self.whereList[#self.whereList + 1] = identifier .. (operator == "!=" and " IS NOT NULL" or " IS NULL")
    else
        self.whereList[#self.whereList + 1] = identifier .. " " .. operator .. " " .. mysql:Value(value)
    end
    return self
end

function QUERY:Where(key, value)
    return self:_where(key, "=", value)
end

function QUERY:WhereEqual(key, value)
    return self:_where(key, "=", value)
end

function QUERY:WhereNotEqual(key, value)
    return self:_where(key, "!=", value)
end

function QUERY:WhereGT(key, value)
    return self:_where(key, ">", value)
end

function QUERY:WhereLT(key, value)
    return self:_where(key, "<", value)
end

function QUERY:WhereGTE(key, value)
    return self:_where(key, ">=", value)
end

function QUERY:WhereLTE(key, value)
    return self:_where(key, "<=", value)
end

function QUERY:WhereLike(key, value, format)
    return self:_where(key, "LIKE", string.format(format or "%%%s%%", value))
end

function QUERY:WhereNotLike(key, value, format)
    return self:_where(key, "NOT LIKE", string.format(format or "%%%s%%", value))
end

function QUERY:WhereIn(key, values)
    values = istable(values) and values or {values}
    local escaped = {}
    for i = 1, #values do
        escaped[i] = mysql:Value(values[i])
    end

    self.whereList[#self.whereList + 1] = mysql:QuoteIdentifier(key) .. " IN (" .. table.concat(escaped, ", ") .. ")"
    return self
end

function QUERY:OrderByDesc(key)
    self.orderByList[#self.orderByList + 1] = mysql:QuoteIdentifier(key) .. " DESC"
    return self
end

function QUERY:OrderByAsc(key)
    self.orderByList[#self.orderByList + 1] = mysql:QuoteIdentifier(key) .. " ASC"
    return self
end

local function sqliteType(definition, primaryInline)
    local value = definition:gsub("INT%(%d+%)", "INTEGER"):gsub("TINYINT%(%d+%)", "INTEGER"):gsub("SMALLINT%(%d+%)", "INTEGER"):gsub("LONGTEXT", "TEXT"):gsub("UNSIGNED%s*", "")
    if value:find("AUTO_INCREMENT", 1, true) then
        value, primaryInline = "INTEGER PRIMARY KEY AUTOINCREMENT", true
    else
        value = value:gsub("AUTO_INCREMENT", "")
    end
    return string.Trim(value), primaryInline
end

function QUERY:Build()
    local tableName = mysql:QuoteIdentifier(self.tableName)
    local where = #self.whereList > 0 and (" WHERE " .. table.concat(self.whereList, " AND ")) or ""
    if self.queryType == "select" then
        local statement = "SELECT " .. (#self.selectList > 0 and table.concat(self.selectList, ", ") or "*") .. " FROM " .. tableName .. where
        if #self.orderByList > 0 then statement = statement .. " ORDER BY " .. table.concat(self.orderByList, ", ") end
        if self.limit then statement = statement .. " LIMIT " .. self.limit end
        if self.offset then statement = statement .. " OFFSET " .. self.offset end
        return statement
    elseif self.queryType == "insert" or self.queryType == "insert_ignore" then
        local keys, values = {}, {}
        for i = 1, #self.insertList do
            keys[i], values[i] = self.insertList[i][1], self.insertList[i][2]
        end

        local verb = self.queryType == "insert_ignore" and (mysql.module == "sqlite" and "INSERT OR IGNORE" or "INSERT IGNORE") or "INSERT"
        return string.format("%s INTO %s (%s) VALUES (%s)", verb, tableName, table.concat(keys, ", "), table.concat(values, ", "))
    elseif self.queryType == "update" then
        local values = {}
        for i = 1, #self.updateList do
            values[i] = self.updateList[i][1] .. " = " .. self.updateList[i][2]
        end
        return "UPDATE " .. tableName .. " SET " .. table.concat(values, ", ") .. where
    elseif self.queryType == "delete" then
        local statement = "DELETE FROM " .. tableName .. where
        if self.limit then statement = statement .. " LIMIT " .. self.limit end
        return statement
    elseif self.queryType == "drop" then
        return "DROP TABLE IF EXISTS " .. tableName
    elseif self.queryType == "truncate" then
        return mysql.module == "sqlite" and ("DELETE FROM " .. tableName) or ("TRUNCATE TABLE " .. tableName)
    elseif self.queryType == "create" then
        local definitions, primaryInline = {}, false
        for i = 1, #self.createList do
            local definition = self.createList[i][2]
            if mysql.module == "sqlite" then definition, primaryInline = sqliteType(definition, primaryInline) end
            definitions[#definitions + 1] = self.createList[i][1] .. " " .. definition
        end

        if self.primaryKey and not primaryInline then definitions[#definitions + 1] = "PRIMARY KEY (" .. self.primaryKey .. ")" end
        local suffix = mysql.module == "mysqloo" and " ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" or ""
        return "CREATE TABLE IF NOT EXISTS " .. tableName .. " (" .. table.concat(definitions, ", ") .. ")" .. suffix
    elseif self.queryType == "alter" then
        if self.add then
            local definition = self.add[2]
            if mysql.module == "sqlite" then definition = sqliteType(definition) end
            return "ALTER TABLE " .. tableName .. " ADD COLUMN " .. self.add[1] .. " " .. definition
        elseif self.drop then
            if mysql.module == "sqlite" then return nil, "SQLite column removal is not supported by this compatibility API" end
            return "ALTER TABLE " .. tableName .. " DROP COLUMN " .. self.drop
        end
    end
    return nil, "Unable to build " .. tostring(self.queryType) .. " query"
end

function QUERY:Execute(queue)
    local statement, buildError = self:Build()
    if not statement then
        logError(buildError)
        safeCall("query error", self.errorCallback, buildError)
        return false
    end

    if queue then return mysql:Queue(statement, self.callback, self.errorCallback) end
    return mysql:RawQuery(statement, self.callback, self.errorCallback)
end

function mysql:Select(name)
    return QUERY:New(name, "select")
end

function mysql:Insert(name)
    return QUERY:New(name, "insert")
end

function mysql:InsertIgnore(name)
    return QUERY:New(name, "insert_ignore")
end

function mysql:Update(name)
    return QUERY:New(name, "update")
end

function mysql:Delete(name)
    return QUERY:New(name, "delete")
end

function mysql:Create(name)
    return QUERY:New(name, "create")
end

function mysql:Alter(name)
    return QUERY:New(name, "alter")
end

function mysql:Drop(name)
    return QUERY:New(name, "drop")
end

function mysql:Truncate(name)
    return QUERY:New(name, "truncate")
end
return mysql