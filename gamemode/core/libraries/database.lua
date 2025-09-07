lia.db = lia.db or {}
lia.db.queryQueue = lia.db.queue or {}
lia.db.prepared = lia.db.prepared or {}
lia.db.cache = lia.db.cache or {
    enabled = true,
    ttl = 5,
    store = {},
    index = {}
}

local function ThrowQueryFault(query, fault)
    if string.find(fault, "duplicate column name:") or string.find(fault, "UNIQUE constraint failed: lia_config") then return end
    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), " * " .. query .. "\n")
    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), " " .. fault .. "\n")
end

local function cacheNow()
    return CurTime() or os.time()
end

function lia.db.setCacheEnabled(enabled)
    lia.db.cache.enabled = not not enabled
end

function lia.db.setCacheTTL(seconds)
    local ttl = tonumber(seconds) or 0
    lia.db.cache.ttl = ttl > 0 and ttl or 0
end

function lia.db.cacheClear()
    lia.db.cache.store = {}
    lia.db.cache.index = {}
end

local function stripTicks(name)
    if not isstring(name) then return name end
    return name:gsub("`", "")
end

function lia.db.cacheGet(key)
    if not lia.db.cache.enabled then return nil end
    local entry = lia.db.cache.store[key]
    if not entry then return nil end
    if entry.expireAt and entry.expireAt <= cacheNow() then
        lia.db.cache.store[key] = nil
        return nil
    end
    return entry.value
end

function lia.db.cacheSet(tableName, key, value)
    if not lia.db.cache.enabled then return end
    if not key then return end
    local expires = lia.db.cache.ttl > 0 and (cacheNow() + lia.db.cache.ttl) or nil
    lia.db.cache.store[key] = {
        value = value,
        expireAt = expires
    }

    local tn = stripTicks(tableName)
    lia.db.cache.index[tn] = lia.db.cache.index[tn] or {}
    lia.db.cache.index[tn][key] = true
end

function lia.db.invalidateTable(tableName)
    local tn = stripTicks(tableName)
    local keys = lia.db.cache.index[tn]
    if not keys then return end
    for key in pairs(keys) do
        lia.db.cache.store[key] = nil
    end

    lia.db.cache.index[tn] = nil
end

function lia.db.normalizeIdentifier(name)
    if name == nil then return name end
    local str = tostring(name)
    return str:gsub("^_+", "")
end

function lia.db.normalizeSQLIdentifiers(sql)
    if not isstring(sql) then return sql end
    local fixed = sql:gsub("`_([%w_]+)`", function(rest) return "`" .. rest:gsub("^_+", "") .. "`" end)
    return fixed
end

local function promisifyIfNoCallback(queryHandler)
    return function(query, callback)
        local d
        local function throw(err)
            if d then
                d:reject(err)
            else
                ThrowQueryFault(query, err)
            end
        end

        if not isfunction(callback) then
            d = deferred.new()
            callback = function(results, lastID)
                d:resolve({
                    results = results,
                    lastID = lastID
                })
            end
        end

        queryHandler(query, callback, throw)
        return d
    end
end

-- Direct SQLITE functions (replacing modules.sqlite)
local sqliteQuery = promisifyIfNoCallback(function(query, callback, throw)
    local data = sql.Query(query)
    local err = sql.LastError()
    if data == false then throw(err) end
    if callback then
        local lastID = tonumber(sql.QueryValue("SELECT last_insert_rowid()"))
        callback(data, lastID)
    end
end)

-- Define sqliteEscape globally for direct access
function sqliteEscape(value)
    return sql.SQLStr(value, true)
end

-- Keep lia.db.escape for backward compatibility
lia.db.escape = sqliteEscape
lia.db.query = function(...) lia.db.queryQueue[#lia.db.queryQueue + 1] = {...} end
function lia.db.connect(callback, reconnect)
    -- Direct SQLITE connection (replacing modules system)
    if reconnect or not lia.db.connected then
        lia.db.connected = true
        if lia.db.cacheClear then lia.db.cacheClear() end
        if isfunction(callback) then callback() end
        for i = 1, #lia.db.queryQueue do
            lia.db.query(unpack(lia.db.queryQueue[i]))
        end

        lia.db.queryQueue = {}
    end

    -- Set up direct SQLite query function
    lia.db.query = function(query, callback, onError)
        query = lia.db.normalizeSQLIdentifiers(query)
        return sqliteQuery(query, callback, onError)
    end
end

function lia.db.wipeTables(callback)
    local wipedTables = {}
    local function realCallback()
        if lia.db.cacheClear then lia.db.cacheClear() end
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), L("dataWiped") .. "\n")
        if #wipedTables > 0 then MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Wiped tables: " .. table.concat(wipedTables, ", ") .. "\n") end
        if isfunction(callback) then callback() end
    end

    lia.db.query("SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'lia_%';", function(data)
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
        lia.db.tablesLoaded = true
        hook.Run("LiliaTablesLoaded")
        hook.Run("OnDatabaseLoaded")
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
CREATE TABLE IF NOT EXISTS lia_config (
    schema text,
    key text,
    value text,
    PRIMARY KEY (schema, key)
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
    warnerSteamID text
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
    children text,
    PRIMARY KEY (gamemode, map, id)
);
CREATE TABLE IF NOT EXISTS lia_persistence (
    id integer primary key autoincrement,
    gamemode text,
    map text,
    class text,
    pos text,
    angles text,
    model text
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
CREATE TABLE IF NOT EXISTS lia_data (
    gamemode text,
    map text,
    data text,
    PRIMARY KEY (gamemode, map)
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
        hook.Add("LiliaTablesLoaded", tostring(TABLE_WAIT_ID), function() d:resolve() end)
    end

    TABLE_WAIT_ID = TABLE_WAIT_ID + 1
    return d
end

local function genInsertValues(value, dbTable)
    local query = "lia_" .. (dbTable or "characters") .. " ("
    local keys = {}
    local values = {}
    for k, v in pairs(value) do
        keys[#keys + 1] = lia.db.escapeIdentifier(k)
        values[#keys] = lia.db.convertDataType(v)
    end
    return query .. table.concat(keys, ", ") .. ") VALUES (" .. table.concat(values, ", ") .. ")"
end

local function genUpdateList(value)
    local changes = {}
    for k, v in pairs(value) do
        changes[#changes + 1] = lia.db.escapeIdentifier(k) .. " = " .. lia.db.convertDataType(v)
    end
    return table.concat(changes, ", ")
end

function lia.db.convertDataType(value, noEscape)
    if value == nil then
        return "NULL"
    elseif isstring(value) then
        if noEscape then
            return value
        else
            return "'" .. sqliteEscape(value) .. "'"
        end
    elseif istable(value) then
        if noEscape then
            return util.TableToJSON(value)
        else
            return "'" .. sqliteEscape(util.TableToJSON(value)) .. "'"
        end
    elseif isbool(value) then
        return value and 1 or 0
    elseif value == NULL then
        return "NULL"
    end
    return value
end

function lia.db.insertTable(value, callback, dbTable)
    local query = "INSERT INTO " .. genInsertValues(value, dbTable)
    local function cb(...)
        if callback then callback(...) end
        if lia.db.invalidateTable then lia.db.invalidateTable("lia_" .. (dbTable or "characters")) end
    end

    lia.db.query(query, cb)
end

function lia.db.updateTable(value, callback, dbTable, condition)
    local query = "UPDATE " .. "lia_" .. (dbTable or "characters") .. " SET " .. genUpdateList(value) .. (condition and " WHERE " .. condition or "")
    local function cb(...)
        if callback then callback(...) end
        if lia.db.invalidateTable then lia.db.invalidateTable("lia_" .. (dbTable or "characters")) end
    end

    lia.db.query(query, cb)
end

function lia.db.select(fields, dbTable, condition, limit)
    local d = deferred.new()
    local from = istable(fields) and table.concat(fields, ", ") or tostring(fields)
    local tableName = "lia_" .. (dbTable or "characters")
    local query = "SELECT " .. from .. " FROM " .. tableName
    if condition then query = query .. " WHERE " .. tostring(condition) end
    if limit then query = query .. " LIMIT " .. tostring(limit) end
    local cacheKey = "select:" .. query
    local cached = lia.db.cacheGet(cacheKey)
    if cached ~= nil then
        d:resolve(cached)
        return d
    end

    lia.db.query(query, function(results, lastID)
        local payload = {
            results = results,
            lastID = lastID
        }

        lia.db.cacheSet(tableName, cacheKey, payload)
        d:resolve(payload)
    end)
    return d
end

function lia.db.selectWithCondition(fields, dbTable, conditions, limit, orderBy)
    local d = deferred.new()
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
    local cacheKey = "select:" .. query
    local cached = lia.db.cacheGet(cacheKey)
    if cached ~= nil then
        d:resolve(cached)
        return d
    end

    lia.db.query(query, function(results, lastID)
        local payload = {
            results = results,
            lastID = lastID
        }

        lia.db.cacheSet(tableName, cacheKey, payload)
        d:resolve(payload)
    end)
    return d
end

function lia.db.count(dbTable, condition)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local q = "SELECT COUNT(*) AS cnt FROM " .. tbl .. (condition and " WHERE " .. condition or "")
    local cacheKey = "count:" .. q
    local cached = lia.db.cacheGet(cacheKey)
    if cached ~= nil then
        c:resolve(cached)
        return c
    end

    lia.db.query(q, function(results)
        if istable(results) then
            local num = tonumber(results[1].cnt)
            lia.db.cacheSet(tbl, cacheKey, num)
            c:resolve(num)
        else
            c:resolve(0)
        end
    end)
    return c
end

function lia.db.addDatabaseFields()
    local typeMap = {
        string = function(d) return ("%s VARCHAR(%d)"):format(lia.db.escapeIdentifier(d.field), d.length or 255) end,
        integer = function(d) return ("%s INT"):format(lia.db.escapeIdentifier(d.field)) end,
        float = function(d) return ("%s FLOAT"):format(lia.db.escapeIdentifier(d.field)) end,
        boolean = function(d) return ("%s TINYINT(1)"):format(lia.db.escapeIdentifier(d.field)) end,
        datetime = function(d) return ("%s DATETIME"):format(lia.db.escapeIdentifier(d.field)) end,
        text = function(d) return ("%s TEXT"):format(lia.db.escapeIdentifier(d.field)) end
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
end

function lia.db.exists(dbTable, condition)
    return lia.db.count(dbTable, condition):next(function(n) return n > 0 end)
end

function lia.db.selectOne(fields, dbTable, condition)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local f = istable(fields) and table.concat(fields, ", ") or fields
    local q = "SELECT " .. f .. " FROM " .. tbl
    if condition then q = q .. " WHERE " .. condition end
    q = q .. " LIMIT 1"
    local cacheKey = "selectOne:" .. q
    local cached = lia.db.cacheGet(cacheKey)
    if cached ~= nil then
        c:resolve(cached)
        return c
    end

    lia.db.query(q, function(results)
        if istable(results) then
            local row = results[1]
            lia.db.cacheSet(tbl, cacheKey, row)
            c:resolve(row)
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
    lia.db.query(q, function()
        if lia.db.invalidateTable then lia.db.invalidateTable(tbl) end
        c:resolve()
    end, function(err) c:reject(err) end)
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

    local q = lia.db.query("INSERT OR REPLACE INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ","), function()
        if lia.db.invalidateTable then lia.db.invalidateTable(tbl) end
        c:resolve()
    end, function(err) c:reject(err) end)
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
    lia.db.query(cmd .. " INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES (" .. table.concat(vals, ",") .. ")", function(results, lastID)
        c:resolve({
            results = results,
            lastID = lastID
        })

        if lia.db.invalidateTable then lia.db.invalidateTable(tbl) end
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
    field = lia.db.normalizeIdentifier(field)
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
                lia.db.query("COMMIT", function()
                    if lia.db.cacheClear then lia.db.cacheClear() end
                    c:resolve()
                end)
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
    return "`" .. tostring(lia.db.normalizeIdentifier(id)):gsub("`", "``") .. "`"
end

function lia.db.upsert(value, dbTable)
    local d = deferred.new()
    lia.db.query("INSERT OR REPLACE INTO " .. genInsertValues(value, dbTable), function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })

        if lia.db.invalidateTable then lia.db.invalidateTable("lia_" .. (dbTable or "characters")) end
    end)
    return d
end

function lia.db.delete(dbTable, condition)
    local query
    dbTable = "lia_" .. (dbTable or "character")
    if condition then
        query = "DELETE FROM " .. dbTable .. " WHERE " .. condition
    else
        query = "DELETE * FROM " .. dbTable
    end

    local d = deferred.new()
    lia.db.query(condition and "DELETE FROM " .. dbTable .. " WHERE " .. condition or "DELETE * FROM " .. dbTable, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })

        if lia.db.invalidateTable then lia.db.invalidateTable(dbTable) end
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
                colDef = colDef .. " DEFAULT '" .. sqliteEscape(tostring(column.default)) .. "'"
            elseif column.type == "boolean" then
                colDef = colDef .. " DEFAULT " .. (column.default and "1" or "0")
            else
                colDef = colDef .. " DEFAULT " .. tostring(column.default)
            end
        end

        table.insert(columns, colDef)
    end

    if primaryKey then table.insert(columns, "PRIMARY KEY (" .. lia.db.escapeIdentifier(primaryKey) .. ")") end
    lia.db.query("CREATE TABLE IF NOT EXISTS " .. tableName .. " (" .. table.concat(columns, ", ") .. ")", function()
        if lia.db.cacheClear then lia.db.cacheClear() end
        d:resolve(true)
    end, function(err) d:reject(err) end)
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
                colDef = colDef .. " DEFAULT '" .. sqliteEscape(tostring(defaultValue)) .. "'"
            elseif columnType == "boolean" then
                colDef = colDef .. " DEFAULT " .. (defaultValue and "1" or "0")
            else
                colDef = colDef .. " DEFAULT " .. tostring(defaultValue)
            end
        end

        lia.db.query("ALTER TABLE " .. fullTableName .. " ADD COLUMN " .. colDef, function()
            if lia.db.cacheClear then lia.db.cacheClear() end
            d:resolve(true)
        end, function(err) d:reject(err) end)
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

        lia.db.query("DROP TABLE " .. fullTableName, function()
            if lia.db.cacheClear then lia.db.cacheClear() end
            d:resolve(true)
        end, function(err) d:reject(err) end)
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
                    d:reject("Cannot remove the last column from table")
                    return
                end

                local tempTableName = fullTableName .. "_temp_" .. os.time()
                local createTempQuery = "CREATE TABLE " .. tempTableName .. " (" .. table.concat(newColumns, ", ") .. ")"
                local insertQuery = "INSERT INTO " .. tempTableName .. " SELECT " .. table.concat(newColumns, ", ") .. " FROM " .. fullTableName
                local dropOldQuery = "DROP TABLE " .. fullTableName
                local renameQuery = "ALTER TABLE " .. tempTableName .. " RENAME TO " .. fullTableName
                lia.db.transaction({createTempQuery, insertQuery, dropOldQuery, renameQuery}):next(function()
                    if lia.db.cacheClear then lia.db.cacheClear() end
                    d:resolve(true)
                end):catch(function(err) d:reject(err) end)
            end, function(err) d:reject(err) end)
        end):catch(function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

function lia.db.GetCharacterTable(callback)
    lia.db.query("PRAGMA table_info(lia_characters)", function(results)
        if not results or #results == 0 then return callback({}) end
        local columns = {}
        for _, row in ipairs(results) do
            table.insert(columns, row.name)
        end

        callback(columns)
    end)
end

function GM:RegisterPreparedStatements()
    lia.bootstrap(L("database"), L("preparedStatementsAdded"))
end

function GM:SetupDatabase()
    -- SQLite setup - no additional configuration needed
end

function GM:DatabaseConnected()
    lia.bootstrap(L("database"), L("databaseConnected", "SQLite"))
end

concommand.Add("dbcachestatus", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    if not lia.db.cache then
        if SERVER then
            print("[Lilia] Database cache not initialized")
        elseif CLIENT then
            chat.AddText(Color(255, 0, 0), "[Database] Cache not initialized")
        end
        return
    end

    local cache = lia.db.cache
    local entries = 0
    local expired = 0
    local now = cacheNow()
    for key, entry in pairs(cache.store or {}) do
        entries = entries + 1
        if entry.expireAt and entry.expireAt <= now then expired = expired + 1 end
    end

    local tables = {}
    for tableName in pairs(cache.index or {}) do
        tables[#tables + 1] = tableName
    end

    local output = "=== Database Cache Status ===\n"
    output = output .. string.format("Enabled: %s\n", cache.enabled and "Yes" or "No")
    output = output .. string.format("TTL: %d seconds\n", cache.ttl or 0)
    output = output .. string.format("Total Cache Entries: %d\n", entries)
    output = output .. string.format("Expired Entries: %d\n", expired)
    output = output .. string.format("Active Tables: %d (%s)", #tables, table.concat(tables, ", "))
    if #tables > 0 then
        output = output .. "\n\nTable Details:"
        for _, tableName in ipairs(tables) do
            local count = 0
            for _ in pairs(cache.index[tableName]) do
                count = count + 1
            end

            output = output .. string.format("\n  %s: %d cached queries", tableName, count)
        end
    end

    if SERVER then
        print(output)
        if IsValid(ply) then ply:ChatPrint(output) end
    elseif CLIENT then
        print(output)
        chat.AddText(Color(0, 255, 0), output)
    end
end)

concommand.Add("dbcacheenable", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local enabled = args[1]
    if enabled == nil then
        enabled = not lia.db.cache.enabled
    else
        enabled = string.lower(enabled) == "true" or enabled == "1"
    end

    lia.db.setCacheEnabled(enabled)
    local msg = "Database cache " .. (enabled and "enabled" or "disabled")
    if SERVER then
        print("[Lilia] " .. msg)
        if IsValid(ply) then ply:ChatPrint(msg) end
    elseif CLIENT then
        print(msg)
        chat.AddText(Color(0, 255, 0), msg)
    end
end)

concommand.Add("dbcachesetttl", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local ttl = math.max(0, tonumber(args[1]) or 5)
    lia.db.setCacheTTL(ttl)
    local msg = "Database cache TTL set to " .. ttl .. " seconds"
    if SERVER then
        print("[Lilia] " .. msg)
        if IsValid(ply) then ply:ChatPrint(msg) end
    elseif CLIENT then
        print(msg)
        chat.AddText(Color(0, 255, 0), msg)
    end
end)

concommand.Add("dbcacheclear", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    lia.db.cacheClear()
    local msg = "Database cache cleared"
    if SERVER then
        print("[Lilia] " .. msg)
        if IsValid(ply) then ply:ChatPrint(msg) end
    elseif CLIENT then
        print(msg)
        chat.AddText(Color(0, 255, 0), msg)
    end
end)

concommand.Add("dbtestselect", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTable = args[1] or "lia_characters"
    local iterations = math.min(tonumber(args[2]) or 5, 20)
    local msg = "Testing SELECT operations on table: " .. testTable
    if SERVER then
        print("[Lilia] " .. msg)
        if IsValid(ply) then ply:ChatPrint(msg) end
    elseif CLIENT then
        print(msg)
        chat.AddText(Color(0, 255, 0), msg)
    end

    local function runTest(iteration)
        if iteration > iterations then
            local finalMsg = "SELECT test completed"
            if SERVER then
                print("[Lilia] " .. finalMsg)
                if IsValid(ply) then ply:ChatPrint(finalMsg) end
            elseif CLIENT then
                print(finalMsg)
                chat.AddText(Color(0, 255, 0), finalMsg)
            end
            return
        end

        lia.db.select({"id", "name"}, testTable, nil, 10):next(function(result)
            if result and result.results then
                local resultMsg = string.format("SELECT returned %d rows", #result.results)
                if SERVER then
                    print(string.format("[Test %d] %s", iteration, resultMsg))
                    if IsValid(ply) then ply:ChatPrint(string.format("[Test %d] %s", iteration, resultMsg)) end
                elseif CLIENT then
                    print(string.format("[Test %d] %s", iteration, resultMsg))
                    chat.AddText(Color(0, 255, 0), string.format("[Test %d] %s", iteration, resultMsg))
                end
            else
                local resultMsg = "SELECT failed or returned no data"
                if SERVER then
                    print(string.format("[Test %d] %s", iteration, resultMsg))
                    if IsValid(ply) then ply:ChatPrint(string.format("[Test %d] %s", iteration, resultMsg)) end
                elseif CLIENT then
                    print(string.format("[Test %d] %s", iteration, resultMsg))
                    chat.AddText(Color(255, 255, 0), string.format("[Test %d] %s", iteration, resultMsg))
                end
            end

            timer.Simple(0.1, function() runTest(iteration + 1) end)
        end):catch(function(err)
            local errorMsg = string.format("SELECT error: %s", err)
            if SERVER then
                print(string.format("[Test %d] %s", iteration, errorMsg))
                if IsValid(ply) then ply:ChatPrint(string.format("[Test %d] %s", iteration, errorMsg)) end
            elseif CLIENT then
                print(string.format("[Test %d] %s", iteration, errorMsg))
                chat.AddText(Color(255, 0, 0), string.format("[Test %d] %s", iteration, errorMsg))
            end

            timer.Simple(0.1, function() runTest(iteration + 1) end)
        end)
    end

    runTest(1)
end)

concommand.Add("dbtestcount", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTable = args[1] or "lia_characters"
    local iterations = math.min(tonumber(args[2]) or 5, 20)
    local msg = "Testing COUNT operations on table: " .. testTable
    if SERVER then
        print("[Lilia] " .. msg)
        if IsValid(ply) then ply:ChatPrint(msg) end
    elseif CLIENT then
        print(msg)
        chat.AddText(Color(0, 255, 0), msg)
    end

    local function runTest(iteration)
        if iteration > iterations then
            local finalMsg = "COUNT test completed"
            if SERVER then
                print("[Lilia] " .. finalMsg)
                if IsValid(ply) then ply:ChatPrint(finalMsg) end
            elseif CLIENT then
                print(finalMsg)
                chat.AddText(Color(0, 255, 0), finalMsg)
            end
            return
        end

        lia.db.count(testTable):next(function(count)
            local resultMsg = string.format("COUNT returned: %d", count or 0)
            if SERVER then
                print(string.format("[Test %d] %s", iteration, resultMsg))
                if IsValid(ply) then ply:ChatPrint(string.format("[Test %d] %s", iteration, resultMsg)) end
            elseif CLIENT then
                print(string.format("[Test %d] %s", iteration, resultMsg))
                chat.AddText(Color(0, 255, 0), string.format("[Test %d] %s", iteration, resultMsg))
            end

            timer.Simple(0.1, function() runTest(iteration + 1) end)
        end):catch(function(err)
            local errorMsg = string.format("COUNT error: %s", err)
            if SERVER then
                print(string.format("[Test %d] %s", iteration, errorMsg))
                if IsValid(ply) then ply:ChatPrint(string.format("[Test %d] %s", iteration, errorMsg)) end
            elseif CLIENT then
                print(string.format("[Test %d] %s", iteration, errorMsg))
                chat.AddText(Color(255, 0, 0), string.format("[Test %d] %s", iteration, errorMsg))
            end

            timer.Simple(0.1, function() runTest(iteration + 1) end)
        end)
    end

    runTest(1)
end)

concommand.Add("dbtestinsert", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTable = args[1] or "lia_test_table"
    local function performInsert()
        local testData = {
            id = math.random(10000, 99999),
            test_data = "Test entry from " .. (ply and ply:Nick() or "Console"),
            created_at = os.date("%Y-%m-%d %H:%M:%S")
        }

        lia.db.insertTable(testData, function()
            local msg = "Test data inserted into " .. testTable
            if SERVER then
                print("[Lilia] " .. msg)
                print("Inserted: " .. util.TableToJSON(testData, true))
                if IsValid(ply) then
                    ply:ChatPrint(msg)
                    ply:ChatPrint("Inserted: " .. util.TableToJSON(testData, true))
                end
            elseif CLIENT then
                print(msg)
                print("Inserted: " .. util.TableToJSON(testData, true))
                chat.AddText(Color(0, 255, 0), msg)
                chat.AddText(Color(255, 255, 255), "Inserted: " .. util.TableToJSON(testData, true))
            end
        end, testTable)
    end

    lia.db.tableExists(testTable):next(function(exists)
        if not exists then
            local createMsg = "Creating test table: " .. testTable
            if SERVER then
                print("[Lilia] " .. createMsg)
                if IsValid(ply) then ply:ChatPrint(createMsg) end
            elseif CLIENT then
                print(createMsg)
                chat.AddText(Color(0, 255, 0), createMsg)
            end

            lia.db.createTable(testTable, "id", {
                {
                    name = "id",
                    type = "integer",
                    not_null = true
                },
                {
                    name = "test_data",
                    type = "string"
                },
                {
                    name = "created_at",
                    type = "datetime"
                }
            }):next(function()
                local createdMsg = "Test table created"
                if SERVER then
                    print("[Lilia] " .. createdMsg)
                    if IsValid(ply) then ply:ChatPrint(createdMsg) end
                elseif CLIENT then
                    print(createdMsg)
                    chat.AddText(Color(0, 255, 0), createdMsg)
                end

                performInsert()
            end):catch(function(err)
                local errorMsg = "Failed to create test table: " .. err
                if SERVER then
                    print("[Lilia] " .. errorMsg)
                    if IsValid(ply) then ply:ChatPrint(errorMsg) end
                elseif CLIENT then
                    print(errorMsg)
                    chat.AddText(Color(255, 0, 0), errorMsg)
                end
            end)
        else
            performInsert()
        end
    end)
end)

concommand.Add("dbtestupdate", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTable = args[1] or "lia_test_table"
    local updateData = {
        test_data = "Updated by " .. (ply and ply:Nick() or "Console") .. " at " .. os.date("%H:%M:%S")
    }

    lia.db.updateTable(updateData, function()
        local msg = "Test data updated in " .. testTable
        if SERVER then
            print("[Lilia] " .. msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
        elseif CLIENT then
            print(msg)
            chat.AddText(Color(0, 255, 0), msg)
        end
    end, testTable, "id > 0 LIMIT 1")
end)

concommand.Add("dbtestdelete", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTable = args[1] or "lia_test_table"
    lia.db.delete(testTable, "id > 0 LIMIT 1"):next(function()
        local msg = "Test data deleted from " .. testTable
        if SERVER then
            print("[Lilia] " .. msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
        elseif CLIENT then
            print(msg)
            chat.AddText(Color(0, 255, 0), msg)
        end
    end):catch(function(err)
        local errorMsg = "Delete failed: " .. err
        if SERVER then
            print("[Lilia] " .. errorMsg)
            if IsValid(ply) then ply:ChatPrint(errorMsg) end
        elseif CLIENT then
            print(errorMsg)
            chat.AddText(Color(255, 0, 0), errorMsg)
        end
    end)
end)

concommand.Add("dbtestbulk", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local operation = args[1] or "insert"
    local count = math.min(tonumber(args[2]) or 5, 20)
    local testTable = "lia_test_table"
    if operation == "insert" then
        local bulkData = {}
        for i = 1, count do
            bulkData[i] = {
                id = math.random(10000, 99999),
                test_data = "Bulk test entry " .. i,
                created_at = os.date("%Y-%m-%d %H:%M:%S")
            }
        end

        lia.db.bulkInsert(testTable, bulkData):next(function()
            local msg = count .. " bulk entries inserted"
            if SERVER then
                print("[Lilia] " .. msg)
                if IsValid(ply) then ply:ChatPrint(msg) end
            elseif CLIENT then
                print(msg)
                chat.AddText(Color(0, 255, 0), msg)
            end
        end):catch(function(err)
            local errorMsg = "Bulk insert failed: " .. err
            if SERVER then
                print("[Lilia] " .. errorMsg)
                if IsValid(ply) then ply:ChatPrint(errorMsg) end
            elseif CLIENT then
                print(errorMsg)
                chat.AddText(Color(255, 0, 0), errorMsg)
            end
        end)
    elseif operation == "update" then
        local msg = "Bulk update operations not fully implemented in test"
        if SERVER then
            print("[Lilia] " .. msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
        elseif CLIENT then
            print(msg)
            chat.AddText(Color(255, 255, 0), msg)
        end
    else
        local msg = "Available operations: insert, update"
        if SERVER then
            print("[Lilia] " .. msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
        elseif CLIENT then
            print(msg)
            chat.AddText(Color(255, 255, 0), msg)
        end
    end
end)

concommand.Add("dbtestnormalization", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTable = "lia_test_normalization"
    lia.db.createTable(testTable, "id", {
        {
            name = "_test_col1",
            type = "string"
        },
        {
            name = "_test_col2",
            type = "integer"
        },
        {
            name = "normal_col",
            type = "string"
        }
    }):next(function()
        local createdMsg = "Test table with underscore columns created"
        if SERVER then
            print("[Lilia] " .. createdMsg)
            if IsValid(ply) then ply:ChatPrint(createdMsg) end
        elseif CLIENT then
            print(createdMsg)
            chat.AddText(Color(0, 255, 0), createdMsg)
        end

        local testData = {
            _test_col1 = "Value 1",
            _test_col2 = 42,
            normal_col = "Normal value"
        }

        lia.db.insertTable(testData, function()
            local insertedMsg = "Data inserted with normalized column names"
            if SERVER then
                print("[Lilia] " .. insertedMsg)
                if IsValid(ply) then ply:ChatPrint(insertedMsg) end
            elseif CLIENT then
                print(insertedMsg)
                chat.AddText(Color(0, 255, 0), insertedMsg)
            end

            lia.db.select({"_test_col1", "_test_col2", "normal_col"}, testTable):next(function(result)
                if result and result.results and #result.results > 0 then
                    local selectMsg = "Retrieved data:"
                    if SERVER then
                        print("[Lilia] " .. selectMsg)
                        if IsValid(ply) then ply:ChatPrint(selectMsg) end
                    elseif CLIENT then
                        print(selectMsg)
                        chat.AddText(Color(0, 255, 0), selectMsg)
                    end

                    for k, v in pairs(result.results[1]) do
                        local dataMsg = "  " .. k .. " = " .. tostring(v)
                        if SERVER then
                            print(dataMsg)
                            if IsValid(ply) then ply:ChatPrint(dataMsg) end
                        elseif CLIENT then
                            print(dataMsg)
                            chat.AddText(Color(255, 255, 255), dataMsg)
                        end
                    end
                else
                    local noDataMsg = "No data retrieved"
                    if SERVER then
                        print("[Lilia] " .. noDataMsg)
                        if IsValid(ply) then ply:ChatPrint(noDataMsg) end
                    elseif CLIENT then
                        print(noDataMsg)
                        chat.AddText(Color(255, 255, 0), noDataMsg)
                    end
                end
            end):catch(function(err)
                local errorMsg = "Select error: " .. err
                if SERVER then
                    print("[Lilia] " .. errorMsg)
                    if IsValid(ply) then ply:ChatPrint(errorMsg) end
                elseif CLIENT then
                    print(errorMsg)
                    chat.AddText(Color(255, 0, 0), errorMsg)
                end
            end)
        end, testTable)
    end):catch(function(err)
        local errorMsg = "Failed to create test table: " .. err
        if SERVER then
            print("[Lilia] " .. errorMsg)
            if IsValid(ply) then ply:ChatPrint(errorMsg) end
        elseif CLIENT then
            print(errorMsg)
            chat.AddText(Color(255, 0, 0), errorMsg)
        end
    end)
end)

concommand.Add("dbtestperformance", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local iterations = math.min(tonumber(args[1]) or 10, 50)
    local testTable = "lia_characters"
    local msg = "Testing database performance (" .. iterations .. " iterations)"
    if SERVER then
        print("[Lilia] " .. msg)
        if IsValid(ply) then ply:ChatPrint(msg) end
    elseif CLIENT then
        print(msg)
        chat.AddText(Color(0, 255, 0), msg)
    end

    lia.db.setCacheEnabled(false)
    local uncachedMsg = "Testing WITHOUT cache..."
    if SERVER then
        print("[Lilia] " .. uncachedMsg)
        if IsValid(ply) then ply:ChatPrint(uncachedMsg) end
    elseif CLIENT then
        print(uncachedMsg)
        chat.AddText(Color(0, 255, 0), uncachedMsg)
    end

    local startTime = SysTime()
    local completed = 0
    local function runCachedTest()
        if completed >= iterations then
            local cachedTime = SysTime() - startTime
            local resultMsg = string.format("Cached time: %.4f seconds", cachedTime)
            if SERVER then
                print("[Lilia] " .. resultMsg)
                if IsValid(ply) then ply:ChatPrint(resultMsg) end
            elseif CLIENT then
                print(resultMsg)
                chat.AddText(Color(0, 255, 0), resultMsg)
            end

            local finalMsg = "Performance test completed"
            if SERVER then
                print("[Lilia] " .. finalMsg)
                if IsValid(ply) then ply:ChatPrint(finalMsg) end
            elseif CLIENT then
                print(finalMsg)
                chat.AddText(Color(0, 255, 0), finalMsg)
            end
            return
        end

        lia.db.count(testTable):next(function()
            completed = completed + 1
            timer.Simple(0.01, runCachedTest)
        end):catch(function(err)
            local errorMsg = "Error in cached test: " .. err
            if SERVER then
                print("[Lilia] " .. errorMsg)
                if IsValid(ply) then ply:ChatPrint(errorMsg) end
            elseif CLIENT then
                print(errorMsg)
                chat.AddText(Color(255, 0, 0), errorMsg)
            end

            completed = completed + 1
            timer.Simple(0.01, runCachedTest)
        end)
    end

    local function runUncachedTest()
        if completed >= iterations then
            local uncachedTime = SysTime() - startTime
            local resultMsg = string.format("Uncached time: %.4f seconds", uncachedTime)
            if SERVER then
                print("[Lilia] " .. resultMsg)
                if IsValid(ply) then ply:ChatPrint(resultMsg) end
            elseif CLIENT then
                print(resultMsg)
                chat.AddText(Color(0, 255, 0), resultMsg)
            end

            lia.db.setCacheEnabled(true)
            lia.db.cacheClear()
            local cachedMsg = "Testing WITH cache..."
            if SERVER then
                print("[Lilia] " .. cachedMsg)
                if IsValid(ply) then ply:ChatPrint(cachedMsg) end
            elseif CLIENT then
                print(cachedMsg)
                chat.AddText(Color(0, 255, 0), cachedMsg)
            end

            startTime = SysTime()
            completed = 0
            runCachedTest()
            return
        end

        lia.db.count(testTable):next(function()
            completed = completed + 1
            timer.Simple(0.01, runUncachedTest)
        end):catch(function(err)
            local errorMsg = "Error in uncached test: " .. err
            if SERVER then
                print("[Lilia] " .. errorMsg)
                if IsValid(ply) then ply:ChatPrint(errorMsg) end
            elseif CLIENT then
                print(errorMsg)
                chat.AddText(Color(255, 0, 0), errorMsg)
            end

            completed = completed + 1
            timer.Simple(0.01, runUncachedTest)
        end)
    end

    runUncachedTest()
end)

concommand.Add("dbtestcleanup", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testTables = {"lia_test_table", "lia_test_normalization"}
    local cleaned = 0
    local total = #testTables
    for _, tableName in ipairs(testTables) do
        lia.db.tableExists(tableName):next(function(exists)
            if exists then
                lia.db.removeTable(tableName):next(function()
                    cleaned = cleaned + 1
                    local cleanedMsg = "Cleaned up table: " .. tableName
                    if SERVER then
                        print("[Lilia] " .. cleanedMsg)
                        if IsValid(ply) then ply:ChatPrint(cleanedMsg) end
                    elseif CLIENT then
                        print(cleanedMsg)
                        chat.AddText(Color(0, 255, 0), cleanedMsg)
                    end

                    if cleaned >= total then
                        local finalMsg = "Cleanup completed"
                        if SERVER then
                            print("[Lilia] " .. finalMsg)
                            if IsValid(ply) then ply:ChatPrint(finalMsg) end
                        elseif CLIENT then
                            print(finalMsg)
                            chat.AddText(Color(0, 255, 0), finalMsg)
                        end
                    end
                end):catch(function(err)
                    local errorMsg = "Failed to remove " .. tableName .. ": " .. err
                    if SERVER then
                        print("[Lilia] " .. errorMsg)
                        if IsValid(ply) then ply:ChatPrint(errorMsg) end
                    elseif CLIENT then
                        print(errorMsg)
                        chat.AddText(Color(255, 0, 0), errorMsg)
                    end

                    cleaned = cleaned + 1
                    if cleaned >= total then
                        local finalMsg = "Cleanup completed with errors"
                        if SERVER then
                            print("[Lilia] " .. finalMsg)
                            if IsValid(ply) then ply:ChatPrint(finalMsg) end
                        elseif CLIENT then
                            print(finalMsg)
                            chat.AddText(Color(255, 255, 0), finalMsg)
                        end
                    end
                end)
            else
                cleaned = cleaned + 1
                if cleaned >= total then
                    local finalMsg = "Cleanup completed"
                    if SERVER then
                        print("[Lilia] " .. finalMsg)
                        if IsValid(ply) then ply:ChatPrint(finalMsg) end
                    elseif CLIENT then
                        print(finalMsg)
                        chat.AddText(Color(0, 255, 0), finalMsg)
                    end
                end
            end
        end)
    end
end)

concommand.Add("dbinfo", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local output = "=== Database Information ===\n"
    output = output .. "Database Type: SQLITE (Direct)\n"
    output = output .. string.format("Connected: %s\n", lia.db.connected and "Yes" or "No")
    output = output .. string.format("Tables Loaded: %s\n", lia.db.tablesLoaded and "Yes" or "No")
    output = output .. string.format("Cache Enabled: %s\n", lia.db.cache.enabled and "Yes" or "No")
    output = output .. string.format("Cache TTL: %d seconds", lia.db.cache.ttl or 0)
    if lia.db.config then
        output = output .. "\n\nConfiguration:"
        for k, v in pairs(lia.db.config) do
            if k ~= "password" then
                output = output .. string.format("\n  %s = %s", k, tostring(v))
            else
                output = output .. "\n  password = [HIDDEN]"
            end
        end
    end

    if SERVER then
        print(output)
        if IsValid(ply) then ply:ChatPrint(output) end
    elseif CLIENT then
        print(output)
        chat.AddText(Color(0, 255, 0), output)
    end
end)

concommand.Add("db_testall", function(ply, cmd, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local testIterations = math.min(tonumber(args[1]) or 3, 10)
    local startTime = CurTime()
    local successfulTests = 0
    local failedTests = 0
    local function sendFeedback(msg, color)
        if SERVER then
            print("[DB-Test] " .. msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
        elseif CLIENT then
            print("[DB-Test] " .. msg)
            chat.AddText(color or Color(255, 255, 255), "[DB-Test] " .. msg)
        end
    end

    local startMsg = "=== STARTING COMPREHENSIVE DATABASE TEST SUITE ==="
    sendFeedback(startMsg, Color(0, 255, 0))
    sendFeedback("Running " .. testIterations .. " iterations of each test...", Color(0, 255, 255))
    sendFeedback("Total estimated time: ~" .. math.ceil(16 * 5 * testIterations / 60) .. " minutes", Color(255, 255, 0))
    if SERVER and IsValid(ply) then ply:notifyLocalized("Database test suite started. Check console for progress.") end
    local testSequence = {
        {
            cmd = "dbinfo",
            desc = "Initial database status check",
            category = "Setup"
        },
        {
            cmd = "dbcachestatus",
            desc = "Initial cache status",
            category = "Cache"
        },
        {
            cmd = "dbcacheenable true",
            desc = "Enable caching",
            category = "Cache"
        },
        {
            cmd = "dbcachesetttl 10",
            desc = "Set TTL to 10 seconds",
            category = "Cache"
        },
        {
            cmd = "dbtestinsert",
            desc = "Test INSERT operations",
            category = "CRUD"
        },
        {
            cmd = "dbtestselect lia_test_table " .. testIterations,
            desc = "Test SELECT operations",
            category = "CRUD"
        },
        {
            cmd = "dbtestcount lia_test_table " .. testIterations,
            desc = "Test COUNT operations",
            category = "CRUD"
        },
        {
            cmd = "dbtestupdate",
            desc = "Test UPDATE operations",
            category = "CRUD"
        },
        {
            cmd = "dbtestdelete",
            desc = "Test DELETE operations",
            category = "CRUD"
        },
        {
            cmd = "dbtestbulk insert " .. testIterations,
            desc = "Test bulk INSERT",
            category = "Bulk"
        },
        {
            cmd = "dbtestbulk update " .. testIterations,
            desc = "Test bulk UPDATE",
            category = "Bulk"
        },
        {
            cmd = "dbtestnormalization",
            desc = "Test column name normalization",
            category = "Advanced"
        },
        {
            cmd = "dbtestperformance " .. testIterations,
            desc = "Test performance comparison",
            category = "Performance"
        },
        {
            cmd = "dbcachestatus",
            desc = "Cache status after tests",
            category = "Status"
        },
        {
            cmd = "dbtestcleanup",
            desc = "Clean up test tables",
            category = "Cleanup"
        },
        {
            cmd = "dbcacheclear",
            desc = "Clear cache",
            category = "Cleanup"
        },
        {
            cmd = "dbcachestatus",
            desc = "Final cache status",
            category = "Status"
        }
    }

    local currentStep = 0
    local totalSteps = #testSequence
    local currentCategory = ""
    local function runNextTest()
        currentStep = currentStep + 1
        if currentStep > totalSteps then
            local totalTime = math.Round(CurTime() - startTime, 1)
            local finalMsg = "=== DATABASE TEST SUITE COMPLETED ==="
            sendFeedback(finalMsg, Color(0, 255, 0))
            sendFeedback("Time taken: " .. totalTime .. " seconds", Color(0, 255, 255))
            sendFeedback("Tests completed: " .. successfulTests .. " successful, " .. failedTests .. " failed", Color(255, 255, 0))
            if SERVER and IsValid(ply) then ply:notifyLocalized("All database tests completed successfully!") end
            return
        end

        local test = testSequence[currentStep]
        if test.category ~= currentCategory then
            currentCategory = test.category
            sendFeedback("[" .. currentCategory .. " Tests]", Color(255, 165, 0))
        end

        local progressPercent = math.floor((currentStep - 1) / totalSteps * 100)
        local progressMsg = string.format("[%d/%d] (%d%%) %s", currentStep, totalSteps, progressPercent, test.desc)
        sendFeedback(progressMsg, Color(0, 255, 0))
        sendFeedback("→ " .. test.cmd, Color(255, 255, 255))
        local success = RunConsoleCommand(test.cmd)
        if success then
            successfulTests = successfulTests + 1
            sendFeedback("✓ Test completed successfully", Color(0, 255, 0))
        else
            failedTests = failedTests + 1
            sendFeedback("✗ WARNING: Test may have failed!", Color(255, 255, 0))
        end

        local remainingSteps = totalSteps - currentStep
        local estimatedTimeLeft = remainingSteps * 5
        if estimatedTimeLeft > 0 then
            local timeStr = estimatedTimeLeft >= 60 and string.format("%.1f minutes", estimatedTimeLeft / 60) or string.format("%d seconds", estimatedTimeLeft)
            sendFeedback("⏱️ Estimated time remaining: " .. timeStr, Color(255, 255, 255))
        end

        if currentStep < totalSteps then
            for i = 5, 1, -1 do
                timer.Simple(5 - i, function() if (SERVER and IsValid(ply)) or CLIENT then sendFeedback("Next test in " .. i .. " seconds...", Color(255, 255, 255)) end end)
            end

            timer.Simple(5, function() if (SERVER and IsValid(ply)) or CLIENT then runNextTest() end end)
        else
            timer.Simple(0.1, function() if (SERVER and IsValid(ply)) or CLIENT then runNextTest() end end)
        end
    end

    sendFeedback("🚀 Beginning test execution...", Color(0, 255, 255))
    timer.Simple(0.1, function() if (SERVER and IsValid(ply)) or CLIENT then runNextTest() end end)
end)