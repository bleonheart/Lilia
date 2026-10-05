lia.db = lia.db or {}
lia.db.queryQueue = lia.db.queue or {}
lia.db.prepared = lia.db.prepared or {}
local function devLog(...)
    if not lia.DevMode then return end
    local parts = {...}
    for i = 1, #parts do
        parts[i] = tostring(parts[i])
    end

    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 200, 0), "[DevMode] ", Color(255, 255, 255), table.concat(parts, " "), "\n")
end

lia.db.trace = {
    stats = {},
    totalWrites = 0,
    totalTime = 0,
    startedAt = SysTime(),
    lastConsolePrint = 0
}

local dbTrace = lia.db.trace
local traceWriteOperations = {
    INSERT = true,
    UPDATE = true,
    DELETE = true,
    REPLACE = true,
    CREATE = true,
    DROP = true,
    ALTER = true,
    VACUUM = true,
    BEGIN = true,
    COMMIT = true,
    END = true,
    ROLLBACK = true,
    REINDEX = true
}

local function traceNormalizeSource(source)
    source = tostring(source or "unknown")
    source = source:gsub("^@", "")
    return source:gsub("\\", "/")
end

local function traceNormalizeQuery(query)
    query = tostring(query or "")
    query = query:gsub("%s+", " ")
    return string.Trim(query)
end

local function traceGetOperation(query)
    local upper = string.upper(query)
    local operation = upper:match("^%s*([A-Z]+)")
    if operation ~= "WITH" then return operation end
    for _, candidate in ipairs({"INSERT", "UPDATE", "DELETE", "REPLACE"}) do
        if upper:find(candidate, 1, true) then return candidate end
    end
    return operation
end

local function traceGetTable(query, operation)
    local upper = string.upper(query)
    local tableName
    if operation == "INSERT" then
        tableName = upper:match("^%s*INSERT%s+OR%s+REPLACE%s+INTO%s+[`%[]?([%w_]+)")
        tableName = tableName or upper:match("^%s*INSERT%s+OR%s+IGNORE%s+INTO%s+[`%[]?([%w_]+)")
        tableName = tableName or upper:match("^%s*INSERT%s+INTO%s+[`%[]?([%w_]+)")
    elseif operation == "REPLACE" then
        tableName = upper:match("^%s*REPLACE%s+INTO%s+[`%[]?([%w_]+)")
    elseif operation == "UPDATE" then
        tableName = upper:match("^%s*UPDATE%s+[`%[]?([%w_]+)")
    elseif operation == "DELETE" then
        tableName = upper:match("^%s*DELETE%s+FROM%s+[`%[]?([%w_]+)")
    elseif operation == "CREATE" then
        tableName = upper:match("^%s*CREATE%s+TABLE%s+IF%s+NOT%s+EXISTS%s+[`%[]?([%w_]+)")
        tableName = tableName or upper:match("^%s*CREATE%s+TABLE%s+[`%[]?([%w_]+)")
    elseif operation == "DROP" then
        tableName = upper:match("^%s*DROP%s+TABLE%s+IF%s+EXISTS%s+[`%[]?([%w_]+)")
        tableName = tableName or upper:match("^%s*DROP%s+TABLE%s+[`%[]?([%w_]+)")
    elseif operation == "ALTER" then
        tableName = upper:match("^%s*ALTER%s+TABLE%s+[`%[]?([%w_]+)")
    end
    return tableName or "TRANSACTION"
end

local function traceGetCallers()
    local callers = {}
    for level = 3, 40 do
        local info = debug.getinfo(level, "Sln")
        if not info then break end
        if info.what ~= "C" then
            local source = traceNormalizeSource(info.short_src or info.source)
            if not source:find("core/libraries/core/database/core.lua", 1, true) then
                callers[#callers + 1] = {
                    source = source,
                    line = tonumber(info.currentline) or 0,
                    name = info.name or "unknown"
                }

                if #callers >= 6 then break end
            end
        end
    end

    if #callers == 0 then
        callers[1] = {
            source = "unknown",
            line = 0,
            name = "unknown"
        }
    end
    return callers
end

local function tracePrepare(query)
    local normalized = traceNormalizeQuery(query)
    local operation = traceGetOperation(normalized)
    if not traceWriteOperations[operation] then return end
    local callers = traceGetCallers()
    local keyParts = {operation, traceGetTable(normalized, operation)}
    for i = 1, math.min(#callers, 4) do
        keyParts[#keyParts + 1] = callers[i].source .. ":" .. callers[i].line
    end
    return {
        key = table.concat(keyParts, "|"),
        operation = operation,
        tableName = traceGetTable(normalized, operation),
        query = normalized,
        callers = callers
    }
end

local tracePrintReport
local function traceRecord(context, duration)
    if not context then return end
    local entry = dbTrace.stats[context.key]
    if not entry then
        entry = {
            operation = context.operation,
            tableName = context.tableName,
            query = context.query,
            callers = context.callers,
            count = 0,
            totalTime = 0,
            maxTime = 0
        }

        dbTrace.stats[context.key] = entry
    end

    entry.count = entry.count + 1
    entry.totalTime = entry.totalTime + duration
    entry.maxTime = math.max(entry.maxTime, duration)
    entry.query = context.query
    dbTrace.totalWrites = dbTrace.totalWrites + 1
    dbTrace.totalTime = dbTrace.totalTime + duration
    local now = SysTime()
    local shouldPrintProgress = dbTrace.totalWrites == 1 or dbTrace.totalWrites % 1000 == 0 or now - dbTrace.lastConsolePrint >= 2
    if shouldPrintProgress then
        dbTrace.lastConsolePrint = now
        print(string.format("[Lilia DB Trace] LIVE | writes=%d | blocked=%.3fs | last=%s %s | %.2fms", dbTrace.totalWrites, dbTrace.totalTime, context.operation, context.tableName, duration * 1000))
    end

    if dbTrace.totalWrites % 5000 == 0 and tracePrintReport then tracePrintReport() end
end

local function traceReset()
    dbTrace.stats = {}
    dbTrace.totalWrites = 0
    dbTrace.totalTime = 0
    dbTrace.startedAt = SysTime()
    dbTrace.lastConsolePrint = 0
end

tracePrintReport = function()
    local results = {}
    local tables = {}
    for _, entry in pairs(dbTrace.stats) do
        results[#results + 1] = entry
        local tableEntry = tables[entry.tableName]
        if not tableEntry then
            tableEntry = {
                tableName = entry.tableName,
                count = 0,
                totalTime = 0,
                operations = {}
            }

            tables[entry.tableName] = tableEntry
        end

        tableEntry.count = tableEntry.count + entry.count
        tableEntry.totalTime = tableEntry.totalTime + entry.totalTime
        tableEntry.operations[entry.operation] = (tableEntry.operations[entry.operation] or 0) + entry.count
    end

    local tableResults = {}
    for _, entry in pairs(tables) do
        tableResults[#tableResults + 1] = entry
    end

    table.sort(tableResults, function(a, b)
        if a.totalTime == b.totalTime then return a.count > b.count end
        return a.totalTime > b.totalTime
    end)

    table.sort(results, function(a, b)
        if a.totalTime == b.totalTime then return a.count > b.count end
        return a.totalTime > b.totalTime
    end)

    print("")
    print("================================================================")
    print("[Lilia DB Trace] SQLite write report")
    print(string.format("[Lilia DB Trace] Writes: %d | blocked: %.3fs | elapsed: %.1fs", dbTrace.totalWrites, dbTrace.totalTime, SysTime() - dbTrace.startedAt))
    print("================================================================")
    print("[Lilia DB Trace] Tables")
    for i = 1, math.min(#tableResults, 20) do
        local entry = tableResults[i]
        local operations = {}
        for operation, count in pairs(entry.operations) do
            operations[#operations + 1] = operation .. "=" .. count
        end

        table.sort(operations)
        print(string.format("[Lilia DB Trace] #%d | %s | %d writes | %.3fs | %s", i, entry.tableName, entry.count, entry.totalTime, table.concat(operations, ", ")))
    end

    print("----------------------------------------------------------------")
    print("[Lilia DB Trace] Call sites")
    for i = 1, math.min(#results, 30) do
        local entry = results[i]
        local average = entry.count > 0 and entry.totalTime / entry.count or 0
        print(string.format("[Lilia DB Trace] #%d | %s %s | %d writes | total %.3fs | avg %.2fms | max %.2fms", i, entry.operation, entry.tableName, entry.count, entry.totalTime, average * 1000, entry.maxTime * 1000))
        for callerIndex = 1, math.min(#entry.callers, 6) do
            local caller = entry.callers[callerIndex]
            print(string.format("[Lilia DB Trace]   %d. %s:%d (%s)", callerIndex, caller.source, caller.line, caller.name))
        end

        print("[Lilia DB Trace]   Last: " .. string.sub(entry.query, 1, 600))
    end

    print("================================================================")
    print("")
end

concommand.Add("lia_svdb_trace_report", function(client)
    if IsValid(client) then return end
    tracePrintReport()
end)

concommand.Add("lia_svdb_trace_reset", function(client)
    if IsValid(client) then return end
    traceReset()
    print("[Lilia DB Trace] Statistics reset.")
end)

local traceLastReportedWrites = -1
timer.Remove("LiliaDBTraceAutoReport")
timer.Create("LiliaDBTraceAutoReport", 10, 0, function()
    if dbTrace.totalWrites == traceLastReportedWrites then return end
    traceLastReportedWrites = dbTrace.totalWrites
    tracePrintReport()
end)

timer.Simple(1, function()
    traceLastReportedWrites = dbTrace.totalWrites
    tracePrintReport()
end)

print("[Lilia DB Trace] Integrated SQLite write tracing enabled. Live progress prints during synchronous startup writes, full reports every 5000 writes, and automatic reports every 10 seconds.")
lia.db.modules = {
    ["sqlite"] = {
        query = function(query, callback)
            local d
            if not isfunction(callback) then
                d = deferred.new()
                callback = function(results, lastID)
                    d:resolve({
                        results = results,
                        lastID = lastID
                    })
                end
            end

            local traceContext = tracePrepare(query)
            local started = SysTime()
            local data = sql.Query(query)
            local duration = SysTime() - started
            traceRecord(traceContext, duration)
            local err = sql.LastError()
            if lia.DevMode and duration >= 0.25 then devLog(string.format("SQLite query took %.3fs:", duration), query) end
            if data == false then
                if lia.DevMode then
                    devLog("SQLite query failed:", query)
                    devLog("SQLite error:", tostring(err))
                end

                if string.find(err, "duplicate column name:") or string.find(err, "UNIQUE constraint failed: lia_config") then
                    if d then
                        d:resolve({
                            results = {},
                            lastID = 0
                        })
                    end
                    return d
                end

                if d then
                    d:reject(err)
                else
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. "Database" .. "]", Color(255, 255, 255), " * " .. query .. "\n")
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. "Database" .. "]", Color(255, 255, 255), " " .. err .. "\n")
                end
            end

            if callback then
                local lastID = tonumber(sql.QueryValue("SELECT last_insert_rowid()"))
                callback(data, lastID)
            end
            return d
        end,
        escape = function(value) return sql.SQLStr(value, true) end,
        connect = function(callback)
            lia.db.query = lia.db.modules.sqlite.query
            if callback then callback() end
        end
    }
}

lia.db.escape = lia.db.escape or lia.db.modules.sqlite.escape
lia.db.query = lia.db.query or function(...) lia.db.queryQueue[#lia.db.queryQueue + 1] = {...} end
function lia.db.connect(callback, reconnect)
    local dbModule = lia.db.modules[lia.db.module]
    if dbModule then
        if (reconnect or not lia.db.connected) and not lia.db.object then
            dbModule.connect(function()
                lia.db.connected = true
                if isfunction(callback) then callback() end
                for i = 1, #lia.db.queryQueue do
                    lia.db.query(unpack(lia.db.queryQueue[i]))
                end

                lia.db.queryQueue = {}
            end)
        end

        lia.db.escape = dbModule.escape
        lia.db.query = dbModule.query
    else
        lia.error(string.format("'%s' is not a valid data storage method!", lia.db.module or "Unavailable"))
    end
end

function lia.db.wipeTables(callback)
    local wipedTables = {}
    local function realCallback()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. "Database" .. "]", Color(255, 255, 255), "ALL LILIA DATA HAS BEEN WIPED" .. "\n")
        if #wipedTables > 0 then MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Wiped tables: %s", table.concat(wipedTables, ", ")) .. "\n") end
        if isfunction(callback) then callback() end
    end

    lia.db.query([[SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'lia_%';]], function(data)
        data = data or {}
        local remaining = #data
        if remaining == 0 then
            realCallback()
            return
        end

        for _, row in ipairs(data) do
            local tableName = row.name or row[1]
            table.insert(wipedTables, tableName)
            lia.db.query("DROP TABLE IF EXISTS " .. tableName .. ";", function()
                remaining = remaining - 1
                if remaining <= 0 then realCallback() end
            end)
        end
    end)
end

function lia.db.loadTables()
    local function done()
        lia.db.addDatabaseFields()
        lia.db.ensureIndexes()
        lia.db.tablesLoaded = true
        hook.Run("OnDatabaseLoaded")
        timer.Simple(0, function() lia.config.load() end)
        timer.Simple(0.1, function()
            lia.config.send()
            lia.playerinteract.sync()
            lia.item.loadWeaponOverrides()
            lia.item.loadWeaponRuntimeOverrides()
        end)
    end

    lia.db.query([[
CREATE TABLE IF NOT EXISTS lia_players (
    steamID varchar,
    steamName varchar,
    firstJoin datetime,
    lastJoin datetime,
    userGroup varchar,
    data varchar,
    lastIP varchar,
    lastOnline integer,
    totalOnlineTime float
);
CREATE TABLE IF NOT EXISTS lia_chardata (
    charID integer not null,
    key varchar(255) not null,
    value text(1024),
    PRIMARY KEY (charID, key)
);
CREATE TABLE IF NOT EXISTS lia_characters (
    id integer primary key autoincrement,
    steamID varchar,
    name varchar,
    desc varchar,
    model varchar,
    attribs varchar,
    schema varchar,
    createTime datetime,
    lastJoinTime datetime,
    money varchar,
    faction varchar,
    recognition text not null default '',
    fakenames text not null default ''
);
CREATE TABLE IF NOT EXISTS lia_inventories (
    invID integer primary key autoincrement,
    charID integer,
    invType varchar
);
CREATE TABLE IF NOT EXISTS lia_items (
    itemID integer primary key autoincrement,
    invID integer,
    uniqueID varchar,
    data varchar,
    quantity integer,
    x integer,
    y integer
);
CREATE TABLE IF NOT EXISTS lia_invdata (
    invID integer,
    key text,
    value text,
    FOREIGN KEY(invID) REFERENCES lia_inventories(invID),
    PRIMARY KEY (invID, key)
);
CREATE TABLE IF NOT EXISTS lia_logs (
    id integer primary key autoincrement,
    timestamp datetime,
    gamemode varchar,
    category varchar,
    message text,
    charID integer,
    steamID varchar
);
CREATE TABLE IF NOT EXISTS lia_ticketclaims (
    timestamp datetime,
    requester text,
    requesterSteamID text,
    admin text,
    adminSteamID text,
    message text
);
CREATE TABLE IF NOT EXISTS lia_warnings (
    id integer primary key autoincrement,
    charID integer,
    warned text,
    warnedSteamID text,
    timestamp datetime,
    message text,
    warner text,
    warnerSteamID text,
    severity text default 'Medium'
);
CREATE TABLE IF NOT EXISTS lia_permakills (
    id integer primary key autoincrement,
    player varchar(255) NOT NULL,
    reason varchar(255),
    steamID varchar(255),
    charID integer,
    submitterName varchar(255),
    submitterSteamID varchar(255),
    timestamp integer,
    evidence varchar(255)
);
CREATE TABLE IF NOT EXISTS lia_bans (
    id integer primary key autoincrement,
    player varchar(255) NOT NULL,
    playerSteamID varchar(255),
    reason varchar(255),
    bannerName varchar(255),
    bannerSteamID varchar(255),
    timestamp integer,
    evidence varchar(255)
);
CREATE TABLE IF NOT EXISTS lia_staffactions (
    id integer primary key autoincrement,
    player varchar(255) NOT NULL,
    playerSteamID varchar(255),
    steamID varchar(255),
    action varchar(255),
    staffName varchar(255),
    staffSteamID varchar(255),
    timestamp integer
);
CREATE TABLE IF NOT EXISTS lia_doors (
    gamemode text,
    map text,
    id integer,
    factions text,
    classes text,
    disabled integer,
    hidden integer,
    ownable integer,
    name text,
    price integer,
    locked integer,
    PRIMARY KEY (gamemode, map, id)
);
CREATE TABLE IF NOT EXISTS lia_persistence (
    id integer primary key autoincrement,
    gamemode text,
    map text,
    class text,
    pos text,
    angles text,
    model text,
    data text
);
CREATE TABLE IF NOT EXISTS lia_saveditems (
    id integer primary key autoincrement,
    schema text,
    map text,
    itemID integer,
    pos text,
    angles text
);
CREATE TABLE IF NOT EXISTS lia_admin (
    usergroup text PRIMARY KEY,
    privileges text,
    inheritance text,
    types text
);
]], done)
    hook.Run("OnLoadTables")
end

function lia.db.waitForTablesToLoad()
    TABLE_WAIT_ID = TABLE_WAIT_ID or 0
    local d = deferred.new()
    if lia.db.tablesLoaded then
        d:resolve()
    else
        hook.Add("OnDatabaseLoaded", tostring(TABLE_WAIT_ID), function() d:resolve() end)
    end

    TABLE_WAIT_ID = TABLE_WAIT_ID + 1
    return d
end

local function genInsertValues(value, dbTable)
    local query = "lia_" .. (dbTable or "characters") .. " ("
    local keys = {}
    local values = {}
    for k, v in pairs(value) do
        keys[#keys + 1] = k
        values[#keys] = lia.db.convertDataType(v)
    end
    return query .. table.concat(keys, ", ") .. ") VALUES (" .. table.concat(values, ", ") .. ")"
end

local function genUpdateList(value)
    local changes = {}
    for k, v in pairs(value) do
        changes[#changes + 1] = k .. " = " .. lia.db.convertDataType(v)
    end
    return table.concat(changes, ", ")
end

local function buildWhereClause(conditions)
    if not conditions then return "" end
    if isstring(conditions) then return " WHERE " .. tostring(conditions) end
    if istable(conditions) and next(conditions) then
        local whereParts = {}
        for field, value in pairs(conditions) do
            if value ~= nil then
                local operator = "="
                local conditionValue = value
                if istable(value) and value.operator and value.value ~= nil then
                    operator = value.operator
                    conditionValue = value.value
                end

                local escapedField = lia.db.escapeIdentifier(field)
                local convertedValue = lia.db.convertDataType(conditionValue)
                table.insert(whereParts, escapedField .. " " .. operator .. " " .. convertedValue)
            end
        end

        if #whereParts > 0 then return " WHERE " .. table.concat(whereParts, " AND ") end
    end
    return ""
end

function lia.db.convertDataType(value, noEscape)
    if value == nil then
        return "NULL"
    elseif isstring(value) then
        if noEscape then
            return value
        else
            return "'" .. lia.db.escape(value) .. "'"
        end
    elseif istable(value) then
        if noEscape then
            return util.TableToJSON(value)
        else
            return "'" .. lia.db.escape(util.TableToJSON(value)) .. "'"
        end
    elseif isbool(value) then
        return value and 1 or 0
    elseif value == NULL then
        return "NULL"
    end
    return value
end

function lia.db.insertTable(value, callback, dbTable)
    local d = deferred.new()
    local query = "INSERT INTO " .. genInsertValues(value, dbTable)
    lia.db.query(query, function(results, lastID)
        if callback then callback(results, lastID) end
        d:resolve({
            results = results,
            lastID = lastID
        })
    end, function(err) d:reject(err) end)
    return d
end

function lia.db.updateTable(value, callback, dbTable, condition)
    local d = deferred.new()
    local query = "UPDATE " .. "lia_" .. (dbTable or "characters") .. " SET " .. genUpdateList(value) .. buildWhereClause(condition)
    lia.db.query(query, function(results, lastID)
        if callback then callback(results, lastID) end
        d:resolve({
            results = results,
            lastID = lastID
        })
    end, function(err) d:reject(err) end)
    return d
end

function lia.db.select(fields, dbTable, condition, limit)
    local d = deferred.new()
    if fields == nil then
        lia.error("lia.db.select called with nil fields parameter - using default '*'")
        fields = "*"
    end

    local from = istable(fields) and table.concat(fields, ", ") or tostring(fields)
    local tableName = "lia_" .. (dbTable or "characters")
    local query = "SELECT " .. from .. " FROM " .. tableName
    query = query .. buildWhereClause(condition)
    if limit then query = query .. " LIMIT " .. tostring(limit) end
    lia.db.query(query, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.selectWithCondition(fields, dbTable, conditions, limit, orderBy)
    local d = deferred.new()
    if fields == nil then
        lia.error("lia.db.selectWithCondition called with nil fields parameter - using default '*'")
        fields = "*"
    end

    local from = istable(fields) and table.concat(fields, ", ") or tostring(fields)
    local tableName = "lia_" .. (dbTable or "characters")
    local query = "SELECT " .. from .. " FROM " .. tableName
    if conditions and istable(conditions) and next(conditions) then
        local whereParts = {}
        for field, value in pairs(conditions) do
            if value ~= nil then
                local operator = "="
                local conditionValue = value
                if istable(value) and value.operator and value.value ~= nil then
                    operator = value.operator
                    conditionValue = value.value
                end

                local escapedField = lia.db.escapeIdentifier(field)
                local convertedValue = lia.db.convertDataType(conditionValue)
                table.insert(whereParts, escapedField .. " " .. operator .. " " .. convertedValue)
            end
        end

        if #whereParts > 0 then query = query .. " WHERE " .. table.concat(whereParts, " AND ") end
    elseif isstring(conditions) then
        query = query .. " WHERE " .. tostring(conditions)
    end

    if orderBy then query = query .. " ORDER BY " .. tostring(orderBy) end
    if limit then query = query .. " LIMIT " .. tostring(limit) end
    lia.db.query(query, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.count(dbTable, condition)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local q = "SELECT COUNT(*) AS cnt FROM " .. tbl .. buildWhereClause(condition)
    lia.db.query(q, function(results)
        if istable(results) then
            c:resolve(tonumber(results[1].cnt))
        else
            c:resolve(0)
        end
    end)
    return c
end

function lia.db.addDatabaseFields()
    local typeMap = {
        string = function(d) return ("%s VARCHAR(%d)"):format(d.field, d.length or 255) end,
        integer = function(d) return ("%s INT"):format(d.field) end,
        float = function(d) return ("%s FLOAT"):format(d.field) end,
        boolean = function(d) return ("%s TINYINT(1)"):format(d.field) end,
        datetime = function(d) return ("%s DATETIME"):format(d.field) end,
        text = function(d) return ("%s TEXT"):format(d.field) end
    }

    local ignore = function() end
    if not istable(lia.char.vars) then return end
    for _, v in pairs(lia.char.vars) do
        if v.field and typeMap[v.fieldType] then
            lia.db.fieldExists("lia_characters", v.field):next(function(exists)
                if not exists then
                    local colDef = typeMap[v.fieldType](v)
                    if v.default ~= nil then colDef = colDef .. " DEFAULT '" .. tostring(v.default) .. "'" end
                    lia.db.query("ALTER TABLE lia_characters ADD COLUMN " .. colDef):catch(ignore)
                end
            end)
        end
    end

    lia.db.fieldExists("lia_warnings", "severity"):next(function(exists) if not exists then lia.db.query("ALTER TABLE lia_warnings ADD COLUMN severity TEXT DEFAULT 'Medium'") end end)
end

function lia.db.ensureIndexes()
    local queries = {"CREATE INDEX IF NOT EXISTS idx_lia_players_steamID ON lia_players(steamID)", "CREATE INDEX IF NOT EXISTS idx_lia_characters_steamID_schema ON lia_characters(steamID, schema)", "CREATE INDEX IF NOT EXISTS idx_lia_inventories_charID ON lia_inventories(charID)", "CREATE INDEX IF NOT EXISTS idx_lia_items_invID ON lia_items(invID)"}
    for _, query in ipairs(queries) do
        lia.db.query(query)
    end
end

function lia.db.exists(dbTable, condition)
    return lia.db.count(dbTable, condition):next(function(n) return n > 0 end)
end

function lia.db.selectOne(fields, dbTable, condition)
    local c = deferred.new()
    if fields == nil then
        lia.error("lia.db.selectOne called with nil fields parameter - using default '*'")
        fields = "*"
    end

    local tbl = "`lia_" .. dbTable .. "`"
    local f = istable(fields) and table.concat(fields, ", ") or tostring(fields)
    local q = "SELECT " .. f .. " FROM " .. tbl
    q = q .. buildWhereClause(condition)
    q = q .. " LIMIT 1"
    lia.db.query(q, function(results)
        if istable(results) then
            c:resolve(results[1])
        else
            c:resolve(nil)
        end
    end)
    return c
end

function lia.db.bulkInsert(dbTable, rows)
    if #rows == 0 then return deferred.new():resolve() end
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local keys = {}
    for k in pairs(rows[1]) do
        keys[#keys + 1] = lia.db.escapeIdentifier(k)
    end

    local vals = {}
    for _, row in ipairs(rows) do
        local items = {}
        for _, k in ipairs(keys) do
            local key = k:sub(2, -2)
            items[#items + 1] = lia.db.convertDataType(row[key])
        end

        vals[#vals + 1] = "(" .. table.concat(items, ",") .. ")"
    end

    local q = "INSERT INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ",")
    lia.db.query(q, function() c:resolve() end, function(err) c:reject(err) end)
    return c
end

function lia.db.bulkUpsert(dbTable, rows)
    if #rows == 0 then return deferred.new():resolve() end
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local keys = {}
    for k in pairs(rows[1]) do
        keys[#keys + 1] = lia.db.escapeIdentifier(k)
    end

    local vals = {}
    for _, row in ipairs(rows) do
        local items = {}
        for _, k in ipairs(keys) do
            local key = k:sub(2, -2)
            items[#items + 1] = lia.db.convertDataType(row[key])
        end

        vals[#vals + 1] = "(" .. table.concat(items, ",") .. ")"
    end

    local q = "INSERT OR REPLACE INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ",")
    lia.db.query(q, function() c:resolve() end, function(err) c:reject(err) end)
    return c
end

function lia.db.insertOrIgnore(value, dbTable)
    local c = deferred.new()
    local tbl = "`lia_" .. (dbTable or "characters") .. "`"
    local keys, vals = {}, {}
    for k, v in pairs(value) do
        keys[#keys + 1] = lia.db.escapeIdentifier(k)
        vals[#vals + 1] = lia.db.convertDataType(v)
    end

    local cmd = "INSERT OR IGNORE"
    local q = cmd .. " INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES (" .. table.concat(vals, ",") .. ")"
    lia.db.query(q, function(results, lastID)
        c:resolve({
            results = results,
            lastID = lastID
        })
    end, function(err) c:reject(err) end)
    return c
end

function lia.db.tableExists(tbl)
    local d = deferred.new()
    local qt = "'" .. tbl:gsub("'", "''") .. "'"
    lia.db.query("SELECT name FROM sqlite_master WHERE type='table' AND name=" .. qt, function(res) d:resolve(res and #res > 0) end, function(err) d:reject(err) end)
    return d
end

function lia.db.fieldExists(tbl, field)
    local d = deferred.new()
    lia.db.query("PRAGMA table_info(" .. tbl .. ")", function(res)
        for _, r in ipairs(res) do
            if r.name == field then return d:resolve(true) end
        end

        d:resolve(false)
    end, function(err) d:reject(err) end)
    return d
end

function lia.db.getTables()
    local d = deferred.new()
    lia.db.query("SELECT name FROM sqlite_master WHERE type='table'", function(res)
        local tables = {}
        for _, row in ipairs(res or {}) do
            if row.name and row.name:StartWith("lia_") then tables[#tables + 1] = row.name end
        end

        d:resolve(tables)
    end, function(err) d:reject(err) end)
    return d
end

function lia.db.transaction(queries)
    local c = deferred.new()
    lia.db.query("BEGIN TRANSACTION", function()
        local i = 1
        local function nextQuery()
            if i > #queries then
                lia.db.query("COMMIT", function() c:resolve() end)
            else
                lia.db.query(queries[i], function()
                    i = i + 1
                    nextQuery()
                end, function(err) lia.db.query("ROLLBACK", function() c:reject(err) end) end)
            end
        end

        nextQuery()
    end, function(err) c:reject(err) end)
    return c
end

function lia.db.escapeIdentifier(id)
    return "`" .. tostring(id):gsub("`", "``") .. "`"
end

function lia.db.upsert(value, dbTable)
    local query = "INSERT OR REPLACE INTO " .. genInsertValues(value, dbTable)
    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.delete(dbTable, condition)
    dbTable = "lia_" .. (dbTable or "character")
    local query = "DELETE FROM " .. dbTable .. buildWhereClause(condition)
    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.createTable(dbName, primaryKey, schema)
    local d = deferred.new()
    local tableName = "lia_" .. dbName
    local columns = {}
    for _, column in ipairs(schema) do
        local colDef = lia.db.escapeIdentifier(column.name)
        colDef = colDef .. " " .. column.type:upper()
        if column.not_null then colDef = colDef .. " NOT NULL" end
        if column.default ~= nil then
            if column.type == "string" or column.type == "text" then
                colDef = colDef .. " DEFAULT '" .. lia.db.escape(tostring(column.default)) .. "'"
            elseif column.type == "boolean" then
                colDef = colDef .. " DEFAULT " .. (column.default and "1" or "0")
            else
                colDef = colDef .. " DEFAULT " .. tostring(column.default)
            end
        end

        table.insert(columns, colDef)
    end

    if primaryKey then table.insert(columns, "PRIMARY KEY (" .. lia.db.escapeIdentifier(primaryKey) .. ")") end
    local query = "CREATE TABLE IF NOT EXISTS " .. tableName .. " (" .. table.concat(columns, ", ") .. ")"
    lia.db.query(query, function() d:resolve(true) end, function(err) d:reject(err) end)
    return d
end

function lia.db.createColumn(tableName, columnName, columnType, defaultValue)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.fieldExists(fullTableName, columnName):next(function(exists)
        if exists then
            d:resolve(false)
            return
        end

        local colDef = lia.db.escapeIdentifier(columnName)
        colDef = colDef .. " " .. columnType:upper()
        if defaultValue ~= nil then
            if columnType == "string" or columnType == "text" then
                colDef = colDef .. " DEFAULT '" .. lia.db.escape(tostring(defaultValue)) .. "'"
            elseif columnType == "boolean" then
                colDef = colDef .. " DEFAULT " .. (defaultValue and "1" or "0")
            else
                colDef = colDef .. " DEFAULT " .. tostring(defaultValue)
            end
        end

        local query = "ALTER TABLE " .. fullTableName .. " ADD COLUMN " .. colDef
        lia.db.query(query, function() d:resolve(true) end, function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

function lia.db.removeTable(tableName)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(exists)
        if not exists then
            d:resolve(false)
            return
        end

        local query = "DROP TABLE " .. fullTableName
        lia.db.query(query, function() d:resolve(true) end, function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

function lia.db.removeColumn(tableName, columnName)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(tableExists)
        if not tableExists then
            d:resolve(false)
            return
        end

        lia.db.fieldExists(fullTableName, columnName):next(function(columnExists)
            if not columnExists then
                d:resolve(false)
                return
            end

            lia.db.query("PRAGMA table_info(" .. fullTableName .. ")", function(columns)
                if not columns then
                    d:reject("Failed to get table info")
                    return
                end

                local newColumns = {}
                for _, col in ipairs(columns) do
                    if col.name ~= columnName then
                        local colDef = col.name .. " " .. col.type
                        if col.notnull == 1 then colDef = colDef .. " NOT NULL" end
                        if col.dflt_value then colDef = colDef .. " DEFAULT " .. col.dflt_value end
                        if col.pk == 1 then colDef = colDef .. " PRIMARY KEY" end
                        table.insert(newColumns, colDef)
                    end
                end

                if #newColumns == 0 then
                    d:reject("Cannot Remove Last Column From Table")
                    return
                end

                local tempTableName = fullTableName .. "_temp_" .. os.time()
                local createTempQuery = "CREATE TABLE " .. tempTableName .. " (" .. table.concat(newColumns, ", ") .. ")"
                local insertQuery = "INSERT INTO " .. tempTableName .. " SELECT " .. table.concat(newColumns, ", ") .. " FROM " .. fullTableName
                local dropOldQuery = "DROP TABLE " .. fullTableName
                local renameQuery = "ALTER TABLE " .. tempTableName .. " RENAME TO " .. fullTableName
                lia.db.transaction({createTempQuery, insertQuery, dropOldQuery, renameQuery}):next(function() d:resolve(true) end):catch(function(err) d:reject(err) end)
            end, function(err) d:reject(err) end)
        end):catch(function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

function lia.db.getCharacterTable(callback)
    local query = "PRAGMA table_info(lia_characters)"
    lia.db.query(query, function(results)
        if not results or #results == 0 then return callback({}) end
        local columns = {}
        for _, row in ipairs(results) do
            table.insert(columns, row.name)
        end

        callback(columns)
    end)
end

function lia.db.createSnapshot(tableName)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(exists)
        if not exists then
            d:reject("Table " .. fullTableName .. " does not exist")
            return
        end

        lia.db.query("SELECT * FROM " .. fullTableName, function(results)
            if not results then
                d:reject("Failed to query table " .. fullTableName)
                return
            end

            local snapshot = {
                table = tableName,
                timestamp = os.time(),
                data = results
            }

            local jsonData = util.TableToJSON(snapshot, true)
            local fileName = "snapshot_" .. tableName .. "_" .. os.time() .. ".json"
            local filePath = "lilia/snapshots/" .. fileName
            file.CreateDir("lilia/snapshots")
            file.Write(filePath, jsonData)
            d:resolve({
                file = fileName,
                path = filePath,
                records = #results
            })
        end, function(err) d:reject("Database Error" .. " " .. tostring(err)) end)
    end, function(err) d:reject("Table check error:" .. " " .. tostring(err)) end)
    return d
end

function lia.db.loadSnapshot(fileName)
    local d = deferred.new()
    local filePath = "lilia/snapshots/" .. fileName
    if not file.Exists(filePath, "DATA") then
        d:reject("Snapshot file" .. " " .. fileName .. " " .. "not found")
        return d
    end

    local jsonData = file.Read(filePath, "DATA")
    if not jsonData then
        d:reject("Failed to read snapshot file")
        return d
    end

    local success, snapshot = pcall(util.JSONToTable, jsonData)
    if not success then
        d:reject(string.format("Failed to parse JSON data: %s", tostring(snapshot)))
        return d
    end

    if not snapshot.table or not snapshot.data then
        d:reject("Invalid snapshot format")
        return d
    end

    local fullTableName = "lia_" .. snapshot.table
    lia.db.tableExists(fullTableName):next(function(exists)
        if not exists then
            d:reject("Target table " .. fullTableName .. " does not exist")
            return
        end

        lia.db.query("DELETE FROM " .. fullTableName, function()
            if #snapshot.data == 0 then
                d:resolve({
                    table = snapshot.table,
                    records = 0
                })
                return
            end

            local batchSize = 100
            local batches = {}
            for i = 1, #snapshot.data, batchSize do
                local batch = {}
                for j = i, math.min(i + batchSize - 1, #snapshot.data) do
                    table.insert(batch, snapshot.data[j])
                end

                table.insert(batches, batch)
            end

            local currentBatch = 1
            local function insertNextBatch()
                if currentBatch > #batches then
                    d:resolve({
                        table = snapshot.table,
                        records = #snapshot.data,
                        timestamp = snapshot.timestamp
                    })
                    return
                end

                lia.db.bulkInsert(snapshot.table, batches[currentBatch]):next(function()
                    currentBatch = currentBatch + 1
                    insertNextBatch()
                end, function(err) d:reject("Failed to insert batch (" .. currentBatch .. "): " .. tostring(err)) end)
            end

            insertNextBatch()
        end, function(err) d:reject("Failed To Clear Table" .. " " .. tostring(err)) end)
    end, function(err) d:reject("Table check error:" .. " " .. tostring(err)) end)
    return d
end

function GM:SetupDatabase()
    local databasePath = engine.ActiveGamemode() .. "/schema/database.lua"
    local databaseOverrideExists = file.Exists(databasePath, "LUA")
    if databaseOverrideExists then
        local databaseConfig = include(databasePath)
        if databaseConfig then
            lia.db.config = databaseConfig
            for k, v in pairs(databaseConfig) do
                lia.db[k] = v
            end
        end
    end

    if not lia.db.config then
        for k, v in pairs({
            module = "sqlite",
            hostname = "127.0.0.1",
            username = "",
            password = "",
            database = "",
            port = 3306,
        }) do
            lia.db[k] = v
        end
    end
end

function GM:DatabaseConnected()
    lia.bootstrap("Database", string.format("Lilia has connected to the database. We are using %s!", lia.db.module))
end