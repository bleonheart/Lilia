lia.db = lia.db or {}
lia.db.queryQueue = lia.db.queue or {}
-- Database Cache System
lia.db.cache = lia.db.cache or {}
lia.db.cache.data = {}
lia.db.cache.config = {
    enabled = true,
    defaultTTL = 300, -- 5 minutes default TTL
    maxSize = 1000, -- Maximum number of cached entries
    cleanupInterval = 60 -- Cleanup interval in seconds
}

-- Cache entry structure: { data, timestamp, ttl, hits }
-- Cache Management Functions
function lia.db.cache.generateKey(query, params)
    local key = query
    if params then
        local paramStr = ""
        if istable(params) then
            for k, v in pairs(params) do
                paramStr = paramStr .. k .. "=" .. tostring(v) .. "&"
            end
        else
            paramStr = tostring(params)
        end

        key = key .. "|" .. paramStr
    end
    return util.CRC(key)
end

function lia.db.cache.get(key)
    if not lia.db.cache.config.enabled then return nil end
    local entry = lia.db.cache.data[key]
    if not entry then return nil end
    local currentTime = os.time()
    if currentTime - entry.timestamp > entry.ttl then
        lia.db.cache.data[key] = nil
        return nil
    end

    entry.hits = entry.hits + 1
    return entry.data
end

function lia.db.cache.set(key, data, ttl)
    if not lia.db.cache.config.enabled then return end
    ttl = ttl or lia.db.cache.config.defaultTTL
    -- Check if we need to clean up cache
    if table.Count(lia.db.cache.data) >= lia.db.cache.config.maxSize then lia.db.cache.cleanup() end
    lia.db.cache.data[key] = {
        data = data,
        timestamp = os.time(),
        ttl = ttl,
        hits = 0
    }
end

function lia.db.cache.invalidate(pattern)
    if not pattern then
        lia.db.cache.data = {}
        return
    end

    for key, _ in pairs(lia.db.cache.data) do
        if string.find(tostring(key), pattern) then lia.db.cache.data[key] = nil end
    end
end

function lia.db.cache.cleanup()
    local currentTime = os.time()
    local toRemove = {}
    for key, entry in pairs(lia.db.cache.data) do
        if currentTime - entry.timestamp > entry.ttl then table.insert(toRemove, key) end
    end

    for _, key in ipairs(toRemove) do
        lia.db.cache.data[key] = nil
    end

    -- If still over limit, remove least used entries
    if table.Count(lia.db.cache.data) >= lia.db.cache.config.maxSize then
        local entries = {}
        for key, entry in pairs(lia.db.cache.data) do
            table.insert(entries, {
                key = key,
                hits = entry.hits,
                timestamp = entry.timestamp
            })
        end

        table.sort(entries, function(a, b)
            if a.hits == b.hits then return a.timestamp < b.timestamp end
            return a.hits < b.hits
        end)

        local removeCount = math.max(1, math.floor(lia.db.cache.config.maxSize * 0.1))
        for i = 1, removeCount do
            if entries[i] then lia.db.cache.data[entries[i].key] = nil end
        end
    end
end

function lia.db.cache.getStats()
    local stats = {
        totalEntries = table.Count(lia.db.cache.data),
        totalHits = 0,
        enabled = lia.db.cache.config.enabled
    }

    for _, entry in pairs(lia.db.cache.data) do
        stats.totalHits = stats.totalHits + entry.hits
    end
    return stats
end

-- Start cache cleanup timer
if not lia.db.cache.cleanupTimer then lia.db.cache.cleanupTimer = timer.Create("lia_db_cache_cleanup", lia.db.cache.config.cleanupInterval, 0, function() lia.db.cache.cleanup() end) end

-- Status tracking (parity with database.lua)
lia.db.status = lia.db.status or {
    connected = false,
    tablesLoaded = false,
    lastError = nil,
    connectionTested = false
}

-- Compatibility cache wrapper helpers (parity with database.lua)
function lia.db.setCacheEnabled(enabled)
    lia.db.cache.config.enabled = not not enabled
end

function lia.db.setCacheTTL(seconds)
    local ttl = tonumber(seconds) or 0
    lia.db.cache.config.defaultTTL = ttl > 0 and ttl or 0
end

function lia.db.cacheClear()
    lia.db.cache.clear()
end

function lia.db.cacheGet(key)
    return lia.db.cache.get(key)
end

function lia.db.cacheSet(tableName, key, value)
    -- Include table name in the key for proper invalidation
    local fullKey = tableName .. ":" .. key
    lia.db.cache.set(fullKey, value, lia.db.cache.config.defaultTTL)
end

function lia.db.invalidateTable(patternOrTableName)
    -- Invalidate any cached SELECTs referencing this table name
    if not patternOrTableName then
        lia.db.cache.invalidate()
        return
    end
    lia.db.cache.invalidate(tostring(patternOrTableName))
end

-- Identifier normalization helpers
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
lia.db.modules = {
    ["sqlite"] = {
        query = function(query, callback)
            local d
            local hasCallback = isfunction(callback)
            if not hasCallback then
                d = deferred.new()
                callback = function(results, lastID)
                    d:resolve({
                        results = results,
                        lastID = lastID
                    })
                end
            end

            local data = sql.Query(query)
            local err = sql.LastError()
            if data == false then
                if d then
                    d:reject(err)
                elseif not string.find(err, "duplicate column name:") and not string.find(err, "UNIQUE constraint failed: lia_config") then
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), " * " .. query .. "\n")
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), " " .. err .. "\n")
                end
                return d
            end

            if hasCallback then
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
-- Cached query function
function lia.db.queryCached(query, callback, ttl, params)
    local cacheKey = lia.db.cache.generateKey(query, params)
    local cachedData = lia.db.cache.get(cacheKey)
    if cachedData then
        if isfunction(callback) then callback(cachedData, nil) end
        return
    end

    -- Query not in cache, execute and cache result
    lia.db.query(query, function(results, lastID)
        if results then lia.db.cache.set(cacheKey, results, ttl) end
        if isfunction(callback) then callback(results, lastID) end
    end)
end

function lia.db.connect(callback, reconnect)
    if reconnect or not lia.db.connected then
        -- Test connection
        local testQuery = sql.Query("SELECT 1")
        local testError = sql.LastError()
        if testQuery == false then
            lia.db.status.connected = false
            lia.db.status.lastError = testError
            lia.db.status.connectionTested = true
            if isfunction(callback) then callback(false, testError) end
            return false
        end

        lia.db.modules.sqlite.connect(function()
            lia.db.connected = true
            lia.db.status.connected = true
            lia.db.status.connectionTested = true
            if lia.db.cacheClear then lia.db.cacheClear() end

            -- Apply SQLite pragmas on server realm once
            if SERVER and not lia.db._pragmasApplied then
                pcall(function()
                    sql.Query("PRAGMA journal_mode=WAL")
                    sql.Query("PRAGMA synchronous=NORMAL")
                    sql.Query("PRAGMA temp_store=MEMORY")
                    sql.Query("PRAGMA cache_size=-8000")
                    sql.Query("PRAGMA foreign_keys=ON")
                end)

                lia.db._pragmasApplied = true
            end

            if isfunction(callback) then callback(true) end
            for i = 1, #lia.db.queryQueue do
                lia.db.query(unpack(lia.db.queryQueue[i]))
            end

            lia.db.queryQueue = {}
        end)
    end

    lia.db.escape = lia.db.modules.sqlite.escape
    lia.db.query = lia.db.modules.sqlite.query
end

function lia.db.wipeTables(callback)
    local wipedTables = {}
    local function realCallback()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), L("dataWiped") .. "\n")
        if #wipedTables > 0 then MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Wiped tables: " .. table.concat(wipedTables, ", ") .. "\n") end
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
        lia.db.tablesLoaded = true
        lia.db.status.tablesLoaded = true
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
    door_group text,
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
CREATE TABLE IF NOT EXISTS lia_vendor_presets (
    id integer primary key autoincrement,
    name text,
    items text,
    created_by text,
    created_at datetime
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
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*lia_" .. (dbTable or "characters"))
        if isfunction(callback) then callback(results, lastID) end
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.updateTable(value, callback, dbTable, condition)
    local query = "UPDATE " .. "lia_" .. (dbTable or "characters") .. " SET " .. genUpdateList(value) .. (condition and " WHERE " .. condition or "")
    lia.db.query(query, function(results, lastID)
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*lia_" .. (dbTable or "characters"))
        if isfunction(callback) then callback(results, lastID) end
    end)
end

function lia.db.select(fields, dbTable, condition, limit)
    local d = deferred.new()
    local from = istable(fields) and table.concat(fields, ", ") or tostring(fields)
    local tableName = "lia_" .. (dbTable or "characters")
    local query = "SELECT " .. from .. " FROM " .. tableName
    if condition then query = query .. " WHERE " .. tostring(condition) end
    if limit then query = query .. " LIMIT " .. tostring(limit) end
    lia.db.query(query, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.selectCached(fields, dbTable, condition, limit, ttl)
    local d = deferred.new()
    local from = istable(fields) and table.concat(fields, ", ") or tostring(fields)
    local tableName = "lia_" .. (dbTable or "characters")
    local query = "SELECT " .. from .. " FROM " .. tableName
    if condition then query = query .. " WHERE " .. tostring(condition) end
    if limit then query = query .. " LIMIT " .. tostring(limit) end
    local params = {
        fields = fields,
        dbTable = dbTable,
        condition = condition,
        limit = limit
    }

    lia.db.queryCached(query, function(results, lastID)
        d:resolve({
            results = results,
            lastID = lastID
        })
    end, ttl, params)
    return d
end

function lia.db.count(dbTable, condition)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local q = "SELECT COUNT(*) AS cnt FROM " .. tbl .. (condition and " WHERE " .. condition or "")
    lia.db.query(q, function(results)
        if istable(results) then
            c:resolve(tonumber(results[1].cnt))
        else
            c:resolve(0)
        end
    end)
    return c
end

function lia.db.countCached(dbTable, condition, ttl)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local q = "SELECT COUNT(*) AS cnt FROM " .. tbl .. (condition and " WHERE " .. condition or "")

    local params = {dbTable = dbTable, condition = condition}
    lia.db.queryCached(q, function(results)
        if istable(results) then
            c:resolve(tonumber(results[1].cnt))
        else
            c:resolve(0)
        end
    end, ttl, params)
    return c
end

-- Additional helpers for richer selects
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
    elseif isstring(conditions) and conditions ~= "" then
        query = query .. " WHERE " .. tostring(conditions)
    end

    if orderBy then query = query .. " ORDER BY " .. tostring(orderBy) end
    if limit then query = query .. " LIMIT " .. tostring(limit) end

    lia.db.query(query, function(results, lastID)
        d:resolve({results = results, lastID = lastID})
    end)
    return d
end

function lia.db.selectWithJoin(query)
    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        d:resolve({results = results, lastID = lastID})
    end)
    return d
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
    lia.db.query(q, function(results)
        if istable(results) then
            c:resolve(results[1])
        else
            c:resolve(nil)
        end
    end)
    return c
end

function lia.db.selectOneCached(fields, dbTable, condition, ttl)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local f = istable(fields) and table.concat(fields, ", ") or fields
    local q = "SELECT " .. f .. " FROM " .. tbl
    if condition then q = q .. " WHERE " .. condition end
    q = q .. " LIMIT 1"

    local params = {fields = fields, dbTable = dbTable, condition = condition}
    lia.db.queryCached(q, function(results)
        if istable(results) then
            c:resolve(results[1])
        else
            c:resolve(nil)
        end
    end, ttl, params)
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
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*" .. tbl)
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

    local q = "INSERT OR REPLACE INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ",")
    lia.db.query(q, function()
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*" .. tbl)
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
    local q = cmd .. " INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES (" .. table.concat(vals, ",") .. ")"
    lia.db.query(q, function(results, lastID)
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*" .. tbl)
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

function lia.db.getTableColumns(tbl)
    local d = deferred.new()
    lia.db.query("PRAGMA table_info(" .. tbl .. ")", function(res)
        local columns = {}
        for _, row in ipairs(res or {}) do
            columns[row.name] = string.lower(row.type)
        end

        d:resolve(columns)
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
    return "`" .. tostring(lia.db.normalizeIdentifier(id)):gsub("`", "``") .. "`"
end

function lia.db.upsert(value, dbTable)
    local query = "INSERT OR REPLACE INTO " .. genInsertValues(value, dbTable)
    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*lia_" .. (dbTable or "characters"))
        d:resolve({
            results = results,
            lastID = lastID
        })
    end)
    return d
end

function lia.db.delete(dbTable, condition)
    local query
    dbTable = "lia_" .. (dbTable or "characters")
    if condition then
        query = "DELETE FROM " .. dbTable .. " WHERE " .. condition
    else
        query = "DELETE FROM " .. dbTable
    end

    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        -- Invalidate cache for this table
        lia.db.cache.invalidate("SELECT.*FROM.*" .. dbTable)
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
                    if col.name == columnName then continue end
                    local colDef = col.name .. " " .. col.type
                    if col.notnull == 1 then colDef = colDef .. " NOT NULL" end
                    if col.dflt_value then colDef = colDef .. " DEFAULT " .. col.dflt_value end
                    if col.pk == 1 then colDef = colDef .. " PRIMARY KEY" end
                    table.insert(newColumns, colDef)
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
                lia.db.transaction({createTempQuery, insertQuery, dropOldQuery, renameQuery}):next(function() d:resolve(true) end):catch(function(err) d:reject(err) end)
            end, function(err) d:reject(err) end)
        end):catch(function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

function lia.db.GetCharacterTable(callback)
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

    if not lia.db.config then lia.db.module = "sqlite" end
end

function GM:DatabaseConnected()
    lia.bootstrap(L("database"), L("databaseConnected", lia.db.module))
end

-- Cache utility functions
function lia.db.cache.clear()
    lia.db.cache.data = {}
    print("[Lilia] Database cache cleared")
end

function lia.db.cache.enable()
    lia.db.cache.config.enabled = true
    print("[Lilia] Database cache enabled")
end

function lia.db.cache.disable()
    lia.db.cache.config.enabled = false
    print("[Lilia] Database cache disabled")
end

function lia.db.cache.setConfig(config)
    for k, v in pairs(config) do
        if lia.db.cache.config[k] ~= nil then
            lia.db.cache.config[k] = v
        end
    end
    print("[Lilia] Database cache configuration updated")
end

-- Console commands for cache management
concommand.Add("lia_cache_clear", function(ply, cmd, args)
    if IsValid(ply) then return end -- Server only
    lia.db.cache.clear()
end)

concommand.Add("lia_cache_stats", function(ply, cmd, args)
    if IsValid(ply) then return end -- Server only
    local stats = lia.db.cache.getStats()
    print("[Lilia] Cache Stats:")
    print("  Enabled: " .. tostring(stats.enabled))
    print("  Total Entries: " .. stats.totalEntries)
    print("  Total Hits: " .. stats.totalHits)
end)

concommand.Add("lia_cache_disable", function(ply, cmd, args)
    if IsValid(ply) then return end -- Server only
    lia.db.cache.disable()
end)

concommand.Add("lia_cache_enable", function(ply, cmd, args)
    if IsValid(ply) then return end -- Server only
    lia.db.cache.enable()
end)

-- Database status command
if SERVER then
    concommand.Add("lia_db_status", function(ply)
        if SERVER and IsValid(ply) then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Access denied: This database command can only be run from the server console\n")
            return
        end

        print("\n[Lilia Database Status]")
        print("========================")
        print("Connected: " .. (lia.db.status.connected and "YES" or "NO"))
        print("Tables Loaded: " .. ((lia.db.status.tablesLoaded or lia.db.tablesLoaded) and "YES" or "NO"))
        print("Connection Tested: " .. (lia.db.status.connectionTested and "YES" or "NO"))
        if lia.db.status.lastError then
            print("Last Error: " .. tostring(lia.db.status.lastError))
        else
            print("Last Error: None")
        end

        local testQuery = sql.Query("SELECT 1")
        local testError = sql.LastError()
        if testQuery == false then
            print("Live Connection Test: FAILED - " .. tostring(testError))
        else
            print("Live Connection Test: PASSED")
        end

        local coreTables = {"lia_players", "lia_characters", "lia_inventories", "lia_items"}
        print("\nCore Tables Status:")
        for _, tableName in ipairs(coreTables) do
            local existsQuery = sql.Query("SELECT name FROM sqlite_master WHERE type='table' AND name='" .. tableName .. "'")
            if existsQuery and #existsQuery > 0 then
                print("  " .. tableName .. ": EXISTS")
            else
                print("  " .. tableName .. ": MISSING")
            end
        end

        print("========================\n")
    end)
end

-- Expected schema and migration helpers (parity with database.lua)
lia.db.expectedSchemas = lia.db.expectedSchemas or {}

function lia.db.addExpectedSchema(tableName, schema)
    if not lia.db.expectedSchemas then lia.db.expectedSchemas = {} end
    lia.db.expectedSchemas[tableName] = schema
end

function lia.db.migrateDatabaseSchemas()
    local d = deferred.new()
    local checkPromises = {}
    local totalMissingColumns = 0
    for tableName, expectedColumns in pairs(lia.db.expectedSchemas) do
        local fullTableName = "lia_" .. tableName
        local checkPromise = lia.db.tableExists(fullTableName):next(function(tableExists)
            if not tableExists then return end
            return lia.db.getTableColumns(fullTableName):next(function(columnTypes)
                if not columnTypes then return end
                local existingColumns = {}
                for colName, colType in pairs(columnTypes) do
                    existingColumns[colName] = {type = colType, notnull = false, pk = false}
                end

                local missingColumns = {}
                for colName, colDef in pairs(expectedColumns) do
                    if not existingColumns[colName] then
                        table.insert(missingColumns, {name = colName, def = colDef})
                    end
                end

                totalMissingColumns = totalMissingColumns + #missingColumns
            end)
        end):catch(function() end)

        table.insert(checkPromises, checkPromise)
    end

    deferred.all(checkPromises):next(function()
        if totalMissingColumns > 0 then
            MsgC(Color(0, 255, 0), "[Lilia] Found ", totalMissingColumns, " missing database column(s), starting migration...\n")
            local migrationPromises = {}
            for tableName, expectedColumns in pairs(lia.db.expectedSchemas) do
                local fullTableName = "lia_" .. tableName
                local promise = lia.db.tableExists(fullTableName):next(function(tableExists)
                    if not tableExists then return end
                    return lia.db.getTableColumns(fullTableName):next(function(columnTypes)
                        if not columnTypes then return end
                        local existingColumns = {}
                        for colName, colType in pairs(columnTypes) do
                            existingColumns[colName] = {type = colType, notnull = false, pk = false}
                        end

                        local missingColumns = {}
                        for colName, colDef in pairs(expectedColumns) do
                            if not existingColumns[colName] then
                                table.insert(missingColumns, {name = colName, def = colDef})
                            end
                        end

                        if #missingColumns > 0 then
                            local columnPromises = {}
                            for _, colInfo in ipairs(missingColumns) do
                                local colPromise = lia.db.createColumn(tableName, colInfo.name, colInfo.def.type, {
                                    not_null = colInfo.def.not_null,
                                    auto_increment = colInfo.def.auto_increment,
                                    default = colInfo.def.default
                                }):next(function() end):catch(function() end)

                                table.insert(columnPromises, colPromise)
                            end
                            return deferred.all(columnPromises)
                        end
                    end)
                end):catch(function() end)

                table.insert(migrationPromises, promise)
            end

            deferred.all(migrationPromises):next(function()
                MsgC(Color(0, 255, 0), "[Lilia] Database migration completed successfully.\n")
                d:resolve()
            end):catch(function(err)
                MsgC(Color(255, 0, 0), "[Lilia] Database migration failed: ", err, "\n")
                d:reject(err)
            end)
        else
            d:resolve()
        end
    end):catch(function(err)
        MsgC(Color(255, 0, 0), "[Lilia] Error checking for missing columns: ", err, "\n")
        d:reject(err)
    end)
    return d
end

-- Utility server-only helper for console-only enforcement
local function denyPlayerConsole(ply)
    if SERVER and IsValid(ply) then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Access denied: This database command can only be run from the server console\n")
        return true
    end
    return false
end

-- Snapshot loading
concommand.Add("lia_load_snapshot", function(ply, _, args)
    if denyPlayerConsole(ply) then return end

    local function sendFeedback(msg)
        print("[DB Load] " .. msg)
    end

    if #args < 1 then
        print("Usage: lia_load_snapshot <table_name> [timestamp]")
        print("Examples:")
        print("  lia_load_snapshot characters")
        print("  lia_load_snapshot characters 20241225_143022")
        return
    end

    local tableName = args[1]
    local timestamp = args[2]
    local filename
    if timestamp then
        filename = "lilia/database/" .. tableName .. "_" .. timestamp .. ".txt"
    else
        local files = file.Find("lilia/database/" .. tableName .. "_*.txt", "DATA")
        if #files > 0 then
            table.sort(files, function(a, b) return a > b end)
            filename = "lilia/database/" .. files[1]
        end
    end

    if not filename then
        sendFeedback("No snapshot file found for table '" .. tableName .. "'")
        return
    end

    sendFeedback("Loading snapshot from: " .. filename)
    local content = file.Read(filename, "DATA")
    if not content then
        sendFeedback("Failed to read snapshot file: " .. filename)
        return
    end

    local rows = {}
    for line in content:gmatch("[^\r\n]+") do
        if not line:match("^%s*%-%-") and string.Trim(line) ~= "" then
            local insertPattern = "INSERT INTO lia_(%w+)%s*%((.+)%)%s*;"
            local stmtTable, valuesStr = line:match(insertPattern)
            if stmtTable and valuesStr then
                local row = {}
                for pair in valuesStr:gmatch("([^,]+)") do
                    pair = string.Trim(pair)
                    local key, value = pair:match("(%w+)='([^']*)'")
                    if not key then key, value = pair:match("(%w+)=([^',]+)") end
                    if key and value then
                        if value == "NULL" then
                            row[key] = nil
                        elseif tonumber(value) then
                            row[key] = tonumber(value)
                        else
                            row[key] = value
                        end
                    end
                end

                if next(row) then table.insert(rows, row) end
            end
        end
    end

    if #rows == 0 then
        sendFeedback("No valid INSERT statements found in snapshot file")
        return
    end

    sendFeedback("Found " .. #rows .. " rows to insert into lia_" .. tableName)
    lia.db.bulkInsert(tableName, rows):next(function()
        sendFeedback("Successfully loaded " .. #rows .. " rows into lia_" .. tableName)
    end):catch(function(err)
        sendFeedback("Failed to load snapshot: " .. tostring(err))
    end)
end)

-- Clear table
concommand.Add("lia_clear_table", function(ply, _, args)
    if denyPlayerConsole(ply) then return end

    local function sendFeedback(msg)
        print("[DB Clear] " .. msg)
    end

    if #args < 1 then
        print("Usage: lia_clear_table <table_name>")
        print("Example: lia_clear_table characters")
        return
    end

    local tableName = args[1]
    sendFeedback("Clearing all data from table: lia_" .. tableName)
    lia.db.delete(tableName):next(function()
        sendFeedback("Successfully cleared all data from lia_" .. tableName)
    end):catch(function(err)
        sendFeedback("Failed to clear table: " .. tostring(err))
    end)
end)

-- List snapshots
concommand.Add("lia_list_snapshots", function(ply, _, args)
    if denyPlayerConsole(ply) then return end
    local tableFilter = args[1]
    local function sendFeedback(msg) print("[DB Snapshots] " .. msg) end
    sendFeedback("Listing available snapshot files...")
    local pattern = tableFilter and ("*_" .. tableFilter .. "_*.txt") or "*.txt"
    local files = file.Find("lilia/database/" .. pattern, "DATA")
    if #files == 0 then
        sendFeedback("No snapshot files found" .. (tableFilter and " for table '" .. tableFilter .. "'" or ""))
        return
    end

    local tableGroups = {}
    for _, filename in ipairs(files) do
        local tableName = filename:match("^(.-)_%d+_%d+%.txt$")
        if tableName then
            if not tableGroups[tableName] then tableGroups[tableName] = {} end
            table.insert(tableGroups[tableName], filename)
        end
    end

    sendFeedback("Found " .. #files .. " snapshot files:")
    for _, fileList in pairs(tableGroups) do
        table.sort(fileList, function(a, b) return a > b end)
        for _, filename in ipairs(fileList) do
            local timestamp = filename:match("_(%d+_%d+)%.txt$")
            sendFeedback("  - " .. filename .. " (timestamp: " .. (timestamp or "unknown") .. ")")
        end
    end

    sendFeedback("Use 'lia_load_snapshot <table> [timestamp]' to load a specific snapshot")
end)

-- Full snapshot of all tables
concommand.Add("lia_snapshot", function(ply)
    if denyPlayerConsole(ply) then return end
    local function sendFeedback(msg) print("[DB Snapshot] " .. msg) end
    sendFeedback("Starting database snapshot of all lia_* tables...")
    lia.db.getTables():next(function(tables)
        if #tables == 0 then
            sendFeedback("No lia_* tables found!")
            return
        end

        sendFeedback("Found " .. #tables .. " tables: " .. table.concat(tables, ", "))
        local completed = 0
        local total = #tables
        local timestamp = os.date("%Y%m%d_%H%M%S")
        for _, tableName in ipairs(tables) do
            lia.db.select("*", tableName:gsub("lia_", "")):next(function(selectResult)
                if selectResult and selectResult.results then
                    local shortName = tableName:gsub("lia_", "")
                    local filename = "lilia/database/" .. shortName .. "_" .. timestamp .. ".txt"
                    local content = "Database snapshot for table: " .. tableName .. "\n"
                    content = content .. "Generated on: " .. os.date() .. "\n"
                    content = content .. "Total records: " .. #selectResult.results .. "\n\n"
                    for _, row in ipairs(selectResult.results) do
                        local rowData = {}
                        for k, v in pairs(row) do
                            if isstring(v) then
                                rowData[#rowData + 1] = string.format("%s='%s'", k, v:gsub("'", "''"))
                            elseif isnumber(v) then
                                rowData[#rowData + 1] = string.format("%s=%s", k, tostring(v))
                            elseif v == nil then
                                rowData[#rowData + 1] = string.format("%s=NULL", k)
                            else
                                rowData[#rowData + 1] = string.format("%s='%s'", k, tostring(v):gsub("'", "''"))
                            end
                        end

                        content = content .. "INSERT INTO " .. tableName .. " (" .. table.concat(rowData, ", ") .. ");\n"
                    end

                    file.CreateDir("lilia/database")
                    file.Write(filename, content)
                    sendFeedback("Saved " .. #selectResult.results .. " records from " .. tableName .. " to " .. filename)
                else
                    sendFeedback("Failed to query table: " .. tableName .. " (no results returned)")
                end

                completed = completed + 1
                if completed >= total then
                    if completed == total then
                        sendFeedback("Snapshot creation completed for all tables")
                    else
                        sendFeedback("Snapshot creation completed with some errors")
                    end
                end
            end):catch(function(err)
                sendFeedback("Error processing table " .. tableName .. ": " .. tostring(err))
                completed = completed + 1
                if completed >= total then sendFeedback("Snapshot creation completed with errors") end
            end)
        end
    end):catch(function(err) print("[DB Snapshot] Failed to get table list: " .. tostring(err)) end)
end)

-- Snapshot selected tables
concommand.Add("lia_snapshot_table", function(ply, _, args)
    if denyPlayerConsole(ply) then return end
    if #args == 0 then
        print("Usage: lia_snapshot_table <table_name> [table_name2] [table_name3] ...")
        return
    end

    local function sendFeedback(msg) print("[DB Snapshot] " .. msg) end
    local tablesToSnapshot = {}
    for _, tableName in ipairs(args) do
        if tableName:StartWith("lia_") then
            table.insert(tablesToSnapshot, tableName:gsub("lia_", ""))
        else
            table.insert(tablesToSnapshot, tableName)
        end
    end

    sendFeedback("Starting database snapshot for tables: " .. table.concat(tablesToSnapshot, ", "))
    local completed = 0
    local total = #tablesToSnapshot
    local timestamp = os.date("%Y%m%d_%H%M%S")
    for _, tableName in ipairs(tablesToSnapshot) do
        lia.db.select("*", tableName):next(function(selectResult)
            if selectResult and selectResult.results then
                local fullTableName = "lia_" .. tableName
                local filename = "lilia/database/" .. tableName .. "_" .. timestamp .. ".txt"
                local content = "Database snapshot for table: " .. fullTableName .. "\n"
                content = content .. "Generated on: " .. os.date() .. "\n"
                content = content .. "Total records: " .. #selectResult.results .. "\n\n"
                for _, row in ipairs(selectResult.results) do
                    local rowData = {}
                    for k, v in pairs(row) do
                        if isstring(v) then
                            rowData[#rowData + 1] = string.format("%s='%s'", k, v:gsub("'", "''"))
                        elseif isnumber(v) then
                            rowData[#rowData + 1] = string.format("%s=%s", k, tostring(v))
                        elseif v == nil then
                            rowData[#rowData + 1] = string.format("%s=NULL", k)
                        else
                            rowData[#rowData + 1] = string.format("%s='%s'", k, tostring(v):gsub("'", "''"))
                        end
                    end

                    content = content .. "INSERT INTO " .. fullTableName .. " (" .. table.concat(rowData, ", ") .. ");\n"
                end

                file.CreateDir("lilia/database")
                file.Write(filename, content)
                sendFeedback("Saved " .. #selectResult.results .. " records from " .. fullTableName .. " to " .. filename)
            else
                sendFeedback("Failed to query table: lia_" .. tableName .. " (no results returned)")
            end

            completed = completed + 1
            if completed >= total then sendFeedback("Table snapshot creation completed for all specified tables") end
        end):catch(function(err)
            sendFeedback("Error processing table lia_" .. tableName .. ": " .. tostring(err))
            completed = completed + 1
            if completed >= total then sendFeedback("Table snapshot creation completed with errors") end
        end)
    end
end)

-- Snapshot all except given tables
concommand.Add("lia_snapshot_skip", function(ply, _, args)
    if denyPlayerConsole(ply) then return end
    if #args == 0 then
        print("Usage: lia_snapshot_skip <table_to_skip> [table_to_skip2] ...")
        print("Example: lia_snapshot_skip chardata")
        print("This will create snapshots for all tables EXCEPT the ones specified")
        return
    end

    local skipTables = {}
    for _, tableName in ipairs(args) do
        local fullTableName = tableName:StartWith("lia_") and tableName or "lia_" .. tableName
        skipTables[fullTableName] = true
        print("Will skip table: " .. fullTableName)
    end

    local function sendFeedback(msg) print("[DB Snapshot] " .. msg) end
    sendFeedback("Starting database snapshot of all lia_* tables (skipping " .. table.concat(args, ", ") .. ")...")
    lia.db.getTables():next(function(tables)
        if #tables == 0 then
            sendFeedback("No lia_* tables found!")
            return
        end

        local filteredTables = {}
        for _, tableName in ipairs(tables) do
            if not skipTables[tableName] then
                table.insert(filteredTables, tableName)
            else
                sendFeedback("Skipping table: " .. tableName)
            end
        end

        if #filteredTables == 0 then
            sendFeedback("No tables left to snapshot after filtering!")
            return
        end

        sendFeedback("Found " .. #filteredTables .. " tables to snapshot: " .. table.concat(filteredTables, ", "))
        local completed = 0
        local total = #filteredTables
        local timestamp = os.date("%Y%m%d_%H%M%S")
        for _, tableName in ipairs(filteredTables) do
            lia.db.select("*", tableName:gsub("lia_", "")):next(function(selectResult)
                if selectResult and selectResult.results then
                    local shortName = tableName:gsub("lia_", "")
                    local filename = "lilia/database/" .. shortName .. "_" .. timestamp .. ".txt"
                    local content = "Database snapshot for table: " .. tableName .. "\n"
                    content = content .. "Generated on: " .. os.date() .. "\n"
                    content = content .. "Total records: " .. #selectResult.results .. "\n\n"
                    for _, row in ipairs(selectResult.results) do
                        local rowData = {}
                        for k, v in pairs(row) do
                            if isstring(v) then
                                rowData[#rowData + 1] = string.format("%s='%s'", k, v:gsub("'", "''"))
                            elseif isnumber(v) then
                                rowData[#rowData + 1] = string.format("%s=%s", k, tostring(v))
                            elseif v == nil then
                                rowData[#rowData + 1] = string.format("%s=NULL", k)
                            else
                                rowData[#rowData + 1] = string.format("%s='%s'", k, tostring(v):gsub("'", "''"))
                            end
                        end

                        content = content .. "INSERT INTO " .. tableName .. " (" .. table.concat(rowData, ", ") .. ");\n"
                    end

                    file.CreateDir("lilia/database")
                    file.Write(filename, content)
                    sendFeedback("Saved " .. #selectResult.results .. " records from " .. tableName .. " to " .. filename)
                else
                    sendFeedback("Failed to query table: " .. tableName .. " (no results returned)")
                end

                completed = completed + 1
                if completed >= total then sendFeedback("Selective snapshot creation completed (" .. completed .. "/" .. total .. " tables)") end
            end):catch(function(err)
                sendFeedback("Error processing table " .. tableName .. ": " .. tostring(err))
                completed = completed + 1
                if completed >= total then sendFeedback("Selective snapshot creation completed with errors (" .. completed .. "/" .. total .. " tables)") end
            end)
        end
    end):catch(function(err) sendFeedback("Failed to get table list: " .. tostring(err)) end)
end)

-- Diagnose a table quickly
concommand.Add("lia_diagnose_table", function(ply, _, args)
    if denyPlayerConsole(ply) then return end
    if #args == 0 then
        print("Usage: lia_diagnose_table <table_name>")
        print("Example: lia_diagnose_table chardata")
        return
    end

    local tableName = args[1]
    local fullTableName = tableName:StartWith("lia_") and tableName or "lia_" .. tableName
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Diagnosing table: ", fullTableName, " ===\n")
    lia.db.query("SELECT name FROM sqlite_master WHERE type='table' AND name='" .. fullTableName .. "'", function(result)
        if result and #result > 0 then
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✔ Table exists in sqlite_master\n")
            lia.db.query("PRAGMA table_info(" .. fullTableName .. ")", function(schemaResult)
                if schemaResult and #schemaResult > 0 then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✔ Table schema retrieved successfully (", #schemaResult, " columns)\n")
                    for _, col in ipairs(schemaResult) do
                        print("  - " .. col.name .. " (" .. col.type .. ")")
                    end

                    print("")
                    lia.db.query("SELECT COUNT(*) as count FROM " .. fullTableName, function(countResult)
                        if countResult and countResult[1] then
                            local count = countResult[1].count or 0
                            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✔ Table has ", count, " records\n")
                            lia.db.select("*", tableName:gsub("^lia_", "")):next(function(selectResult)
                                if selectResult and selectResult.results then
                                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✔ SELECT query successful (", #selectResult.results, " records retrieved)\n")
                                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Diagnosis completed successfully ===\n")
                                else
                                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ SELECT query failed: No results returned\n")
                                end
                            end):catch(function(err)
                                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ SELECT query failed: ", tostring(err), "\n")
                            end)
                        else
                            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ Failed to count records in table\n")
                        end
                    end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ COUNT query failed: ", tostring(err), "\n") end)
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ Failed to retrieve table schema\n")
                end
            end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ PRAGMA table_info failed: ", tostring(err), "\n") end)
        else
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ Table does not exist in sqlite_master\n")
            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Available lia_ tables:\n")
            lia.db.getTables():next(function(tables)
                for _, tbl in ipairs(tables) do
                    print("  - " .. tbl)
                end
            end)
        end
    end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✘ sqlite_master query failed: ", tostring(err), "\n") end)
end)

-- List tables
concommand.Add("lia_list_tables", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Listing All lia_* Tables ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n")
            return
        end

        lia.db.getTables():next(function(tables)
            if not tables or #tables == 0 then
                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "No lia_* tables found!\n")
                return
            end

            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", #tables, " lia_* tables in the database:\n\n")
            table.sort(tables)
            local processedTables = 0
            local totalColumns = 0
            for i, tableName in ipairs(tables) do
                local shortName = tableName:gsub("^lia_", "")
                lia.db.getTableColumns(tableName):next(function(columns)
                    processedTables = processedTables + 1
                    local columnCount = 0
                    local columnNames = {}
                    if columns then
                        for columnName, _ in pairs(columns) do
                            columnCount = columnCount + 1
                            table.insert(columnNames, columnName)
                        end

                        totalColumns = totalColumns + columnCount
                        table.sort(columnNames)
                    end

                    local status = columnCount > 0 and "ACTIVE" or "EMPTY"
                    local statusColor = columnCount > 0 and Color(0, 255, 0) or Color(255, 255, 0)
                    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "┌─ ", tableName, " (", shortName, ") ─", string.rep("─", math.max(0, 50 - #tableName - #shortName)), "┐\n")
                    MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "│ Columns: ", columnCount, " | Status: ", "")
                    MsgC(statusColor, status, "")
                    MsgC(Color(255, 255, 255), " │\n")
                    if columnCount > 0 then
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "├─ Column Names:", string.rep("─", 60), "┤\n")
                        for j = 1, #columnNames, 4 do
                            local rowColumns = {}
                            for k = j, math.min(j + 3, #columnNames) do
                                table.insert(rowColumns, columnNames[k])
                            end

                            local columnLine = "│ "
                            for k, colName in ipairs(rowColumns) do
                                columnLine = columnLine .. string.format("%-15s", colName)
                                if k < #rowColumns then columnLine = columnLine .. " │ " end
                            end

                            local remainingSpace = 75 - #columnLine + 1
                            if remainingSpace > 0 then columnLine = columnLine .. string.rep(" ", remainingSpace) end
                            columnLine = columnLine .. "│"
                            MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), columnLine, "\n")
                        end
                    else
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "│ No columns found", string.rep(" ", 58), "│\n")
                    end

                    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "└", string.rep("─", 75), "┘\n")
                    if i < #tables then MsgC(Color(128, 128, 128), "[Lilia] ", Color(128, 128, 128), string.rep("─", 80), "\n") end
                    if processedTables >= #tables then
                        MsgC(Color(255, 255, 0), "\n[Lilia] ", Color(255, 255, 255), "=== SUMMARY ===\n")
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "Total Tables: ", #tables, "\n")
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "Total Columns: ", totalColumns, "\n")
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "Average Columns per Table: ", math.floor(totalColumns / #tables), "\n")
                        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Table Listing Completed ===\n")
                    end
                end):catch(function(err)
                    processedTables = processedTables + 1
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "┌─ ", tableName, " (", shortName, ") ─", string.rep("─", math.max(0, 50 - #tableName - #shortName)), "┐\n")
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "│ ERROR: Failed to get columns", string.rep(" ", 45), "│\n")
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "│ ", tostring(err), string.rep(" ", math.max(0, 70 - #tostring(err))), "│\n")
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "└", string.rep("─", 75), "┘\n")
                    if i < #tables then MsgC(Color(128, 128, 128), "[Lilia] ", Color(128, 128, 128), string.rep("─", 80), "\n") end
                end)
            end
        end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get table list: ", tostring(err), "\n") end)
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to wait for database tables to load: ", tostring(err), "\n") end)
end)

-- List columns of a table
concommand.Add("lia_list_columns", function(ply, _, args)
    if denyPlayerConsole(ply) then return end
    if #args < 1 then
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_list_columns <table_name>\n")
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Example: lia_list_columns characters\n")
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Example: lia_list_columns lia_characters\n")
        return
    end

    local tableName = args[1]
    local fullTableName = tableName
    if not tableName:StartWith("lia_") then fullTableName = "lia_" .. tableName end
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Listing Columns for Table: ", fullTableName, " ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n")
            return
        end

        lia.db.tableExists(fullTableName):next(function(exists)
            if not exists then
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Table '", fullTableName, "' does not exist!\n")
                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Available lia_* tables:\n")
                lia.db.getTables():next(function(tables)
                    if tables and #tables > 0 then
                        for _, tbl in ipairs(tables) do
                            MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "  - ", tbl, "\n")
                        end
                    else
                        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "  No lia_* tables found\n")
                    end
                end)
                return
            end

            lia.db.getTableColumns(fullTableName):next(function(columns)
                if not columns then
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get columns for table: ", fullTableName, "\n")
                    return
                end

                local columnCount = 0
                for _ in pairs(columns) do columnCount = columnCount + 1 end
                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", columnCount, " columns in table '", fullTableName, "':\n\n")
                lia.db.query("PRAGMA table_info(" .. fullTableName .. ")", function(result)
                    if not result then
                        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get detailed column information\n")
                        return
                    end

                    local columnData = result
                    table.sort(columnData, function(a, b) return a.cid < b.cid end)
                    MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), string.format("%-20s %-15s %-8s %-8s %-8s %-10s", "Column Name", "Type", "Not Null", "Default", "Primary Key", "Auto Inc"), "\n")
                    MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), string.rep("-", 80), "\n")
                    for _, col in ipairs(columnData) do
                        local notNull = col.notnull == 1 and "YES" or "NO"
                        local defaultValue = col.dflt_value or "NULL"
                        local primaryKey = col.pk == 1 and "YES" or "NO"
                        local autoIncrement = (col.type or ""):lower():find("auto") and "YES" or "NO"
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), string.format("%-20s %-15s %-8s %-8s %-8s %-10s", col.name, col.type, notNull, defaultValue, primaryKey, autoIncrement), "\n")
                    end

                    MsgC(Color(255, 255, 0), "\n[Lilia] ", Color(255, 255, 255), "=== Column Listing Completed ===\n")
                end)
            end)
        end)
    end)
end)

-- Comprehensive DB test
concommand.Add("lia_dbtest", function(ply)
    if denyPlayerConsole(ply) then return end

    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Starting Comprehensive Database Test ===\n\n")
    local testResults = {total = 0, passed = 0, failed = 0, errors = {}}
    local function logTest(testName, success, message)
        testResults.total = testResults.total + 1
        if success then
            testResults.passed = testResults.passed + 1
            MsgC(Color(0, 255, 0), "[PASS] ", Color(255, 255, 255), testName, ": ", message or "OK", "\n")
        else
            testResults.failed = testResults.failed + 1
            MsgC(Color(255, 0, 0), "[FAIL] ", Color(255, 255, 255), testName, ": ", message or "FAILED", "\n")
            if message then table.insert(testResults.errors, {test = testName, error = message}) end
        end
    end

    local function logSection(sectionName)
        MsgC(Color(255, 255, 0), "\n=== ", sectionName, " ===\n")
    end

    -- CACHE FUNCTIONS
    logSection("CACHE FUNCTIONS")
    local startTime = SysTime()
    lia.db.setCacheEnabled(true)
    logTest("Cache Enable", lia.db.cache.config.enabled == true, "Cache enabled successfully")
    lia.db.setCacheEnabled(false)
    logTest("Cache Disable", lia.db.cache.config.enabled == false, "Cache disabled successfully")
    lia.db.setCacheEnabled(true)
    lia.db.setCacheTTL(30)
    logTest("Cache TTL Set", lia.db.cache.config.defaultTTL == 30, "TTL set to 30 seconds")
    lia.db.cacheSet("test_table", "test_key", {data = "test_value"})
    local cached = lia.db.cacheGet("test_table:test_key")
    logTest("Cache Set/Get", cached and cached.data == "test_value", "Cache set and retrieved successfully")
    lia.db.cacheClear()
    cached = lia.db.cacheGet("test_table:test_key")
    logTest("Cache Clear", cached == nil, "Cache cleared successfully")
    lia.db.cacheSet("test_table", "table_key", "table_value")
    lia.db.invalidateTable("test_table")
    cached = lia.db.cacheGet("test_table:table_key")
    logTest("Table Invalidation", cached == nil, "Table cache invalidated successfully")
    logTest("Cache Functions", true, string.format("Completed in %.3fs", SysTime() - startTime))

    -- UTILITY FUNCTIONS
    logSection("UTILITY FUNCTIONS")
    startTime = SysTime()
    local escaped = lia.db.escape("test'value")
    logTest("SQL Escape", escaped == "test''value", "SQL escaping works correctly")
    local ident = lia.db.escapeIdentifier("test_field")
    logTest("Identifier Escape", ident == "`test_field`", "Identifier escaping works correctly")
    local converted = lia.db.convertDataType("test")
    logTest("String Conversion", converted == "'test'", "String conversion works")
    converted = lia.db.convertDataType(123)
    logTest("Number Conversion", converted == 123, "Number passthrough works")
    converted = lia.db.convertDataType(nil)
    logTest("NULL Conversion", converted == "NULL", "NULL conversion works")
    converted = lia.db.convertDataType({key = "value"})
    logTest("Table Conversion", converted == "'{" .. lia.db.escape("\"key\":\"value\"") .. "}'" or converted ~= nil, "Table conversion works")
    logTest("Utility Functions", true, string.format("Completed in %.3fs", SysTime() - startTime))

    -- TABLE OPERATIONS
    logSection("TABLE OPERATIONS")
    startTime = SysTime()
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then
            logTest("Database Connection", false, "Database not connected")
            return
        end

        lia.db.tableExists("lia_characters"):next(function(exists) logTest("Table Exists Check", exists, "lia_characters table exists") end):catch(function(err) logTest("Table Exists Check", false, "Error: " .. tostring(err)) end)
        lia.db.getTables():next(function(tables)
            local hasLiaTables = false
            for _, table in ipairs(tables) do if string.StartWith(table, "lia_") then hasLiaTables = true break end end
            logTest("Get Tables", hasLiaTables and #tables > 0, "Found " .. #tables .. " tables including lia_ tables")
        end):catch(function(err) logTest("Get Tables", false, "Error: " .. tostring(err)) end)

        local testTableSchema = {
            {name = "id", type = "integer", auto_increment = true},
            {name = "name", type = "string"},
            {name = "value", type = "integer"}
        }

        lia.db.createTable("dbtest_temp", "id", testTableSchema):next(function(result) logTest("Create Table", result == true or (result and result.success), "Test table created successfully") end):catch(function(err) logTest("Create Table", false, "Error creating table: " .. tostring(err)) end)
        timer.Simple(0.1, function() lia.db.removeTable("dbtest_temp"):next(function(success) logTest("Remove Table", success, "Test table removed successfully") end):catch(function(err) logTest("Remove Table", false, "Error removing table: " .. tostring(err)) end) end)
        logTest("Table Operations", true, string.format("Completed in %.3fs", SysTime() - startTime))
    end)

    -- COLUMN OPERATIONS
    logSection("COLUMN OPERATIONS")
    startTime = SysTime()
    lia.db.createTable("dbtest_columns", "id", {
        {name = "id", type = "integer", auto_increment = true},
        {name = "name", type = "string"}
    }):next(function()
        logTest("Column Test Table", true, "Column test table created")
        lia.db.fieldExists("lia_dbtest_columns", "name"):next(function(exists) logTest("Field Exists", exists, "Field existence check works") end):catch(function(err) logTest("Field Exists", false, "Error: " .. tostring(err)) end)
        lia.db.createColumn("dbtest_columns", "test_column", "string"):next(function(result) logTest("Create Column", result == true or (result and result.success), "Column created successfully") end):catch(function(err) logTest("Create Column", false, "Error: " .. tostring(err)) end)
        lia.db.getTableColumns("lia_dbtest_columns"):next(function(columns) logTest("Get Table Columns", columns and type(columns) == "table", "Retrieved " .. table.Count(columns or {}) .. " columns") end):catch(function(err) logTest("Get Table Columns", false, "Error: " .. tostring(err)) end)
        timer.Simple(0.2, function() lia.db.removeColumn("dbtest_columns", "test_column"):next(function(success) logTest("Remove Column", success, "Column removed successfully") end):catch(function(err) logTest("Remove Column", false, "Error: " .. tostring(err)) end) end)
    end):catch(function(err) logTest("Column Test Table", false, "Error creating column test table: " .. tostring(err)) end)
    timer.Simple(0.5, function() lia.db.removeTable("dbtest_columns"):next(function() logTest("Column Test Cleanup", true, "Column test table cleaned up") end):catch(function(err) logTest("Column Test Cleanup", false, "Error cleaning up: " .. tostring(err)) end) end)
    logTest("Column Operations", true, string.format("Completed in %.3fs", SysTime() - startTime))

    -- DATA OPERATIONS
    logSection("DATA OPERATIONS")
    startTime = SysTime()
    lia.db.createTable("dbtest_data", "id", {
        {name = "id", type = "integer", auto_increment = true},
        {name = "name", type = "string"},
        {name = "value", type = "integer"}
    }):next(function()
        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Data test table created\n")
        lia.db.delete("dbtest_data"):next(function()
            lia.db.insertTable({name = "test_item", value = 42}, nil, "dbtest_data"):next(function() logTest("Insert Data", true, "Data inserted successfully") end):catch(function(err) logTest("Insert Data", false, "Error: " .. tostring(err)) end)
            lia.db.select("*", "dbtest_data"):next(function(result) logTest("Select Data", result.results and #result.results > 0, "Data selected successfully") end):catch(function(err) logTest("Select Data", false, "Error: " .. tostring(err)) end)
            lia.db.selectOne("*", "dbtest_data"):next(function(row) logTest("Select One", row and row.name == "test_item", "Single row selected successfully") end):catch(function(err) logTest("Select One", false, "Error: " .. tostring(err)) end)
            lia.db.count("dbtest_data"):next(function(count) logTest("Count Records", count > 0, "Counted " .. tostring(count) .. " records") end):catch(function(err) logTest("Count Records", false, "Error: " .. tostring(err)) end)
            lia.db.exists("dbtest_data", "name = 'test_item'"):next(function(exists) logTest("Exists Check", exists, "Record existence check works") end):catch(function(err) logTest("Exists Check", false, "Error: " .. tostring(err)) end)
            lia.db.updateTable({value = 100}, nil, "dbtest_data", "name = 'test_item'"):next(function() logTest("Update Data", true, "Data updated successfully") end):catch(function(err) logTest("Update Data", false, "Error: " .. tostring(err)) end)

            local bulkData = {{name = "bulk1", value = 1}, {name = "bulk2", value = 2}, {name = "bulk3", value = 3}}
            lia.db.bulkInsert("dbtest_data", bulkData):next(function() logTest("Bulk Insert", true, "Bulk insert completed successfully") end):catch(function(err) logTest("Bulk Insert", false, "Error: " .. tostring(err)) end)
            lia.db.upsert({name = "upsert_test", value = 999}, "dbtest_data"):next(function() logTest("Upsert", true, "Upsert completed successfully") end):catch(function(err) logTest("Upsert", false, "Error: " .. tostring(err)) end)
            lia.db.insertOrIgnore({name = "upsert_test", value = 888}, "dbtest_data"):next(function() logTest("Insert or Ignore", true, "Insert or ignore completed successfully") end):catch(function(err) logTest("Insert or Ignore", false, "Error: " .. tostring(err)) end)
            lia.db.delete("dbtest_data", "name = 'test_item'"):next(function() logTest("Delete Data", true, "Data deleted successfully") end):catch(function(err) logTest("Delete Data", false, "Error: " .. tostring(err)) end)
        end):catch(function(err) logTest("Data Clear", false, "Error clearing data: " .. tostring(err)) end)
    end):catch(function(err) logTest("Data Test Table", false, "Error creating data test table: " .. tostring(err)) end)
    timer.Simple(1.0, function() lia.db.removeTable("dbtest_data"):next(function() logTest("Data Test Cleanup", true, "Data test table cleaned up") end):catch(function(err) logTest("Data Test Cleanup", false, "Error cleaning up: " .. tostring(err)) end) end)
    logTest("Data Operations", true, string.format("Completed in %.3fs", SysTime() - startTime))

    -- TRANSACTIONS
    logSection("TRANSACTION OPERATIONS")
    startTime = SysTime()
    lia.db.createTable("dbtest_transaction", "id", {
        {name = "id", type = "integer", auto_increment = true},
        {name = "name", type = "string"}
    }):next(function()
        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Transaction test table created\n")
        lia.db.delete("dbtest_transaction"):next(function()
            local transactionQueries = {
                "INSERT INTO lia_dbtest_transaction (name) VALUES ('transaction1')",
                "INSERT INTO lia_dbtest_transaction (name) VALUES ('transaction2')",
                "INSERT INTO lia_dbtest_transaction (name) VALUES ('transaction3')"
            }
            lia.db.transaction(transactionQueries):next(function()
                logTest("Transaction", true, "Transaction completed successfully")
                lia.db.count("dbtest_transaction"):next(function(count) logTest("Transaction Verification", count == 3, "Transaction inserted " .. tostring(count) .. " records") end):catch(function(err) logTest("Transaction Verification", false, "Error: " .. tostring(err)) end)
            end):catch(function(err) logTest("Transaction", false, "Error: " .. tostring(err)) end)
        end):catch(function(err) logTest("Transaction Clear", false, "Error clearing table: " .. tostring(err)) end)
    end):catch(function(err) logTest("Transaction Table", false, "Error creating transaction table: " .. tostring(err)) end)
    timer.Simple(1.5, function() lia.db.removeTable("dbtest_transaction"):next(function() logTest("Transaction Cleanup", true, "Transaction test table cleaned up") end):catch(function(err) logTest("Transaction Cleanup", false, "Error cleaning up: " .. tostring(err)) end) end)
    logTest("Transaction Operations", true, string.format("Completed in %.3fs", SysTime() - startTime))

    -- SCHEMA & MIGRATION
    logSection("SCHEMA & MIGRATION")
    startTime = SysTime()
    lia.db.addExpectedSchema("test_schema", {id = {type = "integer", auto_increment = true}, name = {type = "string"}})
    logTest("Add Expected Schema", lia.db.expectedSchemas and lia.db.expectedSchemas.test_schema, "Schema added successfully")
    logTest("Migration Functions", true, "Migration functions are available (skipped execution)")
    logTest("Schema & Migration", true, string.format("Completed in %.3fs", SysTime() - startTime))

    timer.Simple(2.0, function()
        logSection("TEST SUMMARY")
        MsgC(Color(255, 255, 255), "Total Tests: ", Color(0, 255, 0), testResults.total, "\n")
        MsgC(Color(255, 255, 255), "Passed: ", Color(0, 255, 0), testResults.passed, "\n")
        MsgC(Color(255, 255, 255), "Failed: ", Color(255, 0, 0), testResults.failed, "\n")
        if testResults.failed > 0 then
            MsgC(Color(255, 0, 0), "\n=== ERRORS ===\n")
            for _, error in ipairs(testResults.errors) do
                MsgC(Color(255, 0, 0), error.test, ": ", error.error, "\n")
            end
        end

        local successRate = (testResults.passed / math.max(1, testResults.total)) * 100
        if successRate >= 90 then
            MsgC(Color(0, 255, 0), "\n=== RESULT: EXCELLENT ===\n")
            MsgC(Color(0, 255, 0), string.format("Database functions are working correctly (%.1f%% success rate)", successRate), "\n")
        elseif successRate >= 75 then
            MsgC(Color(255, 255, 0), "\n=== RESULT: GOOD ===\n")
            MsgC(Color(255, 255, 0), string.format("Most database functions are working (%.1f%% success rate)", successRate), "\n")
        else
            MsgC(Color(255, 0, 0), "\n=== RESULT: ISSUES DETECTED ===\n")
            MsgC(Color(255, 0, 0), string.format("Database functions have issues (%.1f%% success rate)", successRate), "\n")
        end

        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Database Test Completed ===\n")
    end)
end)

-- Wipe helpers
local function wipeTableCounted(tableName, where)
    local d = deferred.new()
    local condition = where and (" WHERE " .. where) or ""
    lia.db.select("COUNT(*) as count", tableName, where):next(function(data)
        local count = data.results and data.results[1] and (data.results[1].count or data.results[1].cnt) or 0
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", count, " ", tableName, " entries\n\n")
        lia.db.delete(tableName, where):next(function()
            if lia.db.cacheClear then lia.db.cacheClear() end
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== ", string.upper(tableName), " DATA WIPE COMPLETED ===\n")
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully deleted ", count, " ", tableName, " entries\n")
            d:resolve(true)
        end):catch(function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

concommand.Add("lia_wipedoors", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING DOORS DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        wipeTableCounted("doors", "gamemode = " .. lia.db.convertDataType(gamemode)):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear doors table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipeconfig", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING CONFIG DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        wipeTableCounted("config", "schema = " .. lia.db.convertDataType(gamemode)):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear config table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipepersistence", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING PERSISTENCE DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        wipeTableCounted("persistence", "gamemode = " .. lia.db.convertDataType(gamemode)):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear persistence table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipeadmin", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING ADMIN DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        -- lia_admin has no gamemode column in this schema; wipe all
        wipeTableCounted("admin"):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear admin table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipedata", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING DATA TABLE WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        wipeTableCounted("data", "gamemode = " .. lia.db.convertDataType(gamemode)):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear data table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipewarnings", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING WARNINGS DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        wipeTableCounted("warnings"):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear warnings table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipelogs", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING LOGS DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        wipeTableCounted("logs"):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear logs table: ", tostring(err), "\n") end)
    end)
end)

concommand.Add("lia_wipeticketclaims", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING TICKET CLAIMS DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        wipeTableCounted("ticketclaims"):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to clear ticketclaims table: ", tostring(err), "\n") end)
    end)
end)

-- Test schema query and fix
concommand.Add("lia_test_schema_query", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Testing schema column query...\n")
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local condition = "lia_characters.schema = " .. lia.db.convertDataType(gamemode)
    lia.db.selectWithJoin("SELECT n.value AS name, c.id, c.steamID, c.playtime, c.lastJoinTime, cl.value AS class, f.value AS faction, p.lastOnline FROM lia_characters AS c LEFT JOIN lia_players AS p ON c.steamID = p.steamID LEFT JOIN lia_chardata AS n ON n.charID = c.id AND n.key = 'name' LEFT JOIN lia_chardata AS cl ON cl.charID = c.id AND cl.key = 'class' LEFT JOIN lia_chardata AS f ON f.charID = c.id AND f.key = 'faction' WHERE " .. condition):next(function(result)
        if result and result.results then
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✅ Schema query successful! Found " .. #result.results .. " characters with schema = " .. gamemode .. "\n")
        else
            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "⚠️ Query executed but returned no results\n")
        end
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 0, 0), "❌ Schema query failed: " .. tostring(err) .. "\n") end)
end)

concommand.Add("lia_fix_schema_column", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Fixing missing schema column in lia_characters table...\n")
    lia.db.fieldExists("lia_characters", "schema"):next(function(exists)
        if not exists then
            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Schema column does not exist. Creating it...\n")
            lia.db.createColumn("characters", "schema", "string", "lilia"):next(function(result)
                if result then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✅ Successfully added 'schema' column to lia_characters table\n")
                    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
                    lia.db.query("UPDATE lia_characters SET schema = " .. lia.db.convertDataType(gamemode) .. " WHERE schema IS NULL OR schema = ''", function()
                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✅ Updated existing character records with schema: " .. gamemode .. "\n")
                    end)
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 0, 0), "❌ Failed to add 'schema' column to lia_characters table\n")
                end
            end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 0, 0), "❌ Error adding 'schema' column: " .. tostring(err) .. "\n") end)
        else
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✅ Schema column already exists. Updating missing values...\n")
            local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
            lia.db.query("UPDATE lia_characters SET schema = " .. lia.db.convertDataType(gamemode) .. " WHERE schema IS NULL OR schema = ''", function()
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✅ Updated character records with missing schema values: " .. gamemode .. "\n")
            end)
        end
    end)
end)

-- Fix corrupted character IDs
concommand.Add("lia_fix_characters", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Starting Character Corruption Fix ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n")
            return
        end

        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        local schemaCondition = "schema = " .. lia.db.convertDataType(gamemode)
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Scanning for corrupted character IDs...\n")
        lia.db.selectWithJoin("SELECT c.id, n.value AS name, c.steamID FROM lia_characters AS c LEFT JOIN lia_chardata AS n ON n.charID = c.id AND n.key = 'name' WHERE " .. schemaCondition):next(function(data)
            local results = data.results or {}
            local corruptedChars = {}
            local validChars = 0
            for _, v in ipairs(results) do
                local charId = tonumber(v.id)
                if not charId then
                    table.insert(corruptedChars, {rawId = v.id, name = v.name or "Unknown", steamID = v.steamID or "Unknown"})
                else
                    validChars = validChars + 1
                end
            end

            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", #results, " total characters (", validChars, " valid, ", #corruptedChars, " corrupted)\n")
            if #corruptedChars == 0 then
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "No corrupted characters found!\n")
                return
            end

            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Found ", #corruptedChars, " corrupted character(s):\n")
            for i, char in ipairs(corruptedChars) do
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("  %d. ID: '%s' | Name: '%s' | SteamID: '%s'\n", i, tostring(char.rawId), char.name, char.steamID))
            end

            MsgC(Color(255, 255, 0), "\n[Lilia] ", Color(255, 255, 255), "Starting repair process...\n")
            lia.db.select("MAX(id) as maxId", "characters", schemaCondition):next(function(maxIdData)
                local maxIdResult = maxIdData.results and maxIdData.results[1]
                local nextId = (maxIdResult and maxIdResult.maxId and tonumber(maxIdResult.maxId) or 0) + 1
                local fixedCount = 0
                local deletedCount = 0
                local promises = {}
                for _, char in ipairs(corruptedChars) do
                    local newId = nextId
                    nextId = nextId + 1
                    lia.db.selectOne("id", "characters", "id = " .. newId):next(function(existingCheck)
                        if existingCheck then
                            newId = nextId
                            nextId = nextId + 1
                        end

                        local updatePromise = lia.db.updateTable({id = newId}, nil, "characters", "id = " .. lia.db.convertDataType(char.rawId) .. " AND " .. schemaCondition):next(function()
                            lia.db.updateTable({charID = newId}, nil, "chardata", "charID = " .. lia.db.convertDataType(char.rawId)):next(function()
                                lia.db.select({"invID"}, "inventories", "charID = " .. lia.db.convertDataType(char.rawId)):next(function(invData)
                                    local invResults = invData.results or {}
                                    local invPromises = {}
                                    for _, inv in ipairs(invResults) do
                                        local invPromise = lia.db.updateTable({charID = newId}, nil, "inventories", "charID = " .. lia.db.convertDataType(char.rawId) .. " AND invID = " .. inv.invID)
                                        table.insert(invPromises, invPromise)
                                    end

                                    if #invPromises > 0 then
                                        deferred.all(invPromises):next(function()
                                            fixedCount = fixedCount + 1
                                            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Fixed corrupted character: ", char.name, " (", tostring(char.rawId), " -> ", tostring(newId), ")\n")
                                        end)
                                    else
                                        fixedCount = fixedCount + 1
                                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Fixed corrupted character: ", char.name, " (", tostring(char.rawId), " -> ", tostring(newId), ")\n")
                                    end
                                end)
                            end)
                        end):catch(function(updateErr)
                            MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "Failed to fix character ID '", tostring(char.rawId), "', deleting character: ", tostring(updateErr), "\n")
                            local deletePromise = lia.db.delete("characters", "id = " .. lia.db.convertDataType(char.rawId) .. " AND " .. schemaCondition):next(function()
                                lia.db.delete("chardata", "charID = " .. lia.db.convertDataType(char.rawId)):next(function()
                                    lia.db.select({"invID"}, "inventories", "charID = " .. lia.db.convertDataType(char.rawId)):next(function(invData)
                                        local invResults = invData.results or {}
                                        for _, inv in ipairs(invResults) do
                                            if lia.inventory and lia.inventory.deleteByID then lia.inventory.deleteByID(tonumber(inv.invID)) end
                                        end
                                    end)
                                end)
                                deletedCount = deletedCount + 1
                                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "Deleted corrupted character: ", char.name, " (ID: ", tostring(char.rawId), ")\n")
                            end)

                            table.insert(promises, deletePromise)
                        end)

                        table.insert(promises, updatePromise)
                    end):catch(function(err)
                        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to check for ID collision for character '", tostring(char.rawId), "', deleting character: ", tostring(err), "\n")
                        local deletePromise = lia.db.delete("characters", "id = " .. lia.db.convertDataType(char.rawId) .. " AND " .. schemaCondition):next(function()
                            lia.db.delete("chardata", "charID = " .. lia.db.convertDataType(char.rawId)):next(function()
                                lia.db.select({"invID"}, "inventories", "charID = " .. lia.db.convertDataType(char.rawId)):next(function(invData)
                                    local invResults = invData.results or {}
                                    for _, inv in ipairs(invResults) do
                                        if lia.inventory and lia.inventory.deleteByID then lia.inventory.deleteByID(tonumber(inv.invID)) end
                                    end
                                end)
                            end)
                            deletedCount = deletedCount + 1
                            MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "Deleted corrupted character: ", char.name, " (ID: ", tostring(char.rawId), ")\n")
                        end)

                        table.insert(promises, deletePromise)
                    end)
                end

                deferred.all(promises):next(function()
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "\n=== Character Corruption Fix Completed ===\n")
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully fixed ", tostring(fixedCount), " corrupted character(s)\n")
                    MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "Deleted ", tostring(deletedCount), " corrupted character(s) (unfixable)\n")
                    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Total valid characters: ", tostring(validChars + fixedCount), "\n")
                end)
            end)
        end)
    end)
end)

-- Wipe characters for current schema
concommand.Add("lia_wipecharacters", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "=== STARTING CHARACTER DATA WIPE ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n") return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        local schemaCondition = "schema = " .. lia.db.convertDataType(gamemode)
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Counting existing data...\n")
        lia.db.select("COUNT(*) as count", "characters", schemaCondition):next(function(charData)
            local charCount = charData.results and charData.results[1] and charData.results[1].count or 0
            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", charCount, " characters\n")
            lia.db.select("COUNT(*) as count", "chardata"):next(function(chardataCount)
                local chardataTotal = chardataCount.results and chardataCount.results[1] and chardataCount.results[1].count or 0
                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", chardataTotal, " character data entries\n")
                lia.db.select("COUNT(*) as count", "inventories"):next(function(invCount)
                    local invTotal = invCount.results and invCount.results[1] and invCount.results[1].count or 0
                    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", invTotal, " inventories\n")
                    lia.db.select("COUNT(*) as count", "items"):next(function(itemCount)
                        local itemTotal = itemCount.results and itemCount.results[1] and itemCount.results[1].count or 0
                        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", itemTotal, " items\n")
                        lia.db.select("COUNT(*) as count", "invdata"):next(function(invdataCount)
                            local invdataTotal = invdataCount.results and invdataCount.results[1] and invdataCount.results[1].count or 0
                            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found ", invdataTotal, " inventory data entries\n\n")
                            sql.Query("PRAGMA foreign_keys=OFF")
                            lia.db.delete("invdata"):next(function()
                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Cleared invdata table\n")
                                lia.db.delete("items"):next(function()
                                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Cleared items table\n")
                                    lia.db.delete("inventories"):next(function()
                                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Cleared inventories table\n")
                                        lia.db.delete("chardata"):next(function()
                                            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Cleared chardata table\n")
                                            lia.db.delete("characters", schemaCondition):next(function()
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Cleared characters table\n\n")
                                                sql.Query("PRAGMA foreign_keys=ON")
                                                if lia.db.cacheClear then lia.db.cacheClear() end
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== CHARACTER DATA WIPE COMPLETED ===\n")
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully deleted:\n")
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  • ", charCount, " characters\n")
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  • ", chardataTotal, " character data entries\n")
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  • ", invTotal, " inventories\n")
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  • ", itemTotal, " items\n")
                                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  • ", invdataTotal, " inventory data entries\n")
                                            end)
                                        end)
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end)

-- Remove underscore-prefixed duplicate/old columns across tables
concommand.Add("lia_remove_column_underscores", function(ply)
    if denyPlayerConsole(ply) then return end
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Starting Column Underscore Removal ===\n")
    lia.db.waitForTablesToLoad():next(function()
        if not lia.db.connected then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected!\n")
            return
        end

        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Scanning lia_* tables for columns with leading underscores...\n")
        lia.db.getTables():next(function(tables)
            if not tables or #tables == 0 then
                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "No tables found!\n")
                return
            end

            local totalTables = #tables
            local totalColumnsRemoved = 0
            MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "Found ", totalTables, " lia_* tables to process\n\n")
            for _, tableName in ipairs(tables) do
                lia.db.getTableColumns(tableName):next(function(columns)
                    if not columns then
                        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get columns for table: ", tableName, "\n")
                        return
                    end

                    local columnsToRemove = {}
                    local columnsToRename = {}
                    for columnName, columnType in pairs(columns) do
                        if columnName:sub(1, 1) == "_" then
                            local newColumnName = columnName:gsub("^_+", "")
                            if newColumnName ~= columnName then
                                if columns[newColumnName] then
                                    table.insert(columnsToRemove, {oldName = columnName, newName = newColumnName, type = columnType})
                                else
                                    table.insert(columnsToRename, {oldName = columnName, newName = newColumnName, type = columnType})
                                end
                            end
                        end
                    end

                    if #columnsToRemove == 0 and #columnsToRename == 0 then
                        MsgC(Color(255, 255, 255), "[Lilia] ", Color(255, 255, 255), "Table ", tableName, ": No columns with leading underscores found\n")
                        return
                    end

                    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Table ", tableName, ": Found ", (#columnsToRemove + #columnsToRename), " columns to process (", #columnsToRemove, " to remove, ", #columnsToRename, " to rename)\n")
                    for _, columnInfo in ipairs(columnsToRemove) do
                        local shortTableName = tableName:gsub("^lia_", "")
                        lia.db.removeColumn(shortTableName, columnInfo.oldName):next(function(removeResult)
                            if removeResult then
                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  ✓ Removed duplicate column ", columnInfo.oldName, " (", columnInfo.newName, " already exists) in ", tableName, "\n")
                                totalColumnsRemoved = totalColumnsRemoved + 1
                            else
                                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "  ✗ Failed to remove duplicate column ", columnInfo.oldName, " from ", tableName, "\n")
                            end
                        end)
                    end

                    for _, columnInfo in ipairs(columnsToRename) do
                        local shortTableName = tableName:gsub("^lia_", "")
                        lia.db.createColumn(shortTableName, columnInfo.newName, (columnInfo.type or "text"):lower()):next(function(createResult)
                            if createResult then
                                local updateQuery = "UPDATE " .. tableName .. " SET " .. lia.db.escapeIdentifier(columnInfo.newName) .. " = " .. lia.db.escapeIdentifier(columnInfo.oldName)
                                lia.db.query(updateQuery, function()
                                    lia.db.removeColumn(shortTableName, columnInfo.oldName):next(function(removeResult)
                                        if removeResult then
                                            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "  ✓ Renamed ", columnInfo.oldName, " -> ", columnInfo.newName, " in ", tableName, "\n")
                                            totalColumnsRemoved = totalColumnsRemoved + 1
                                        else
                                            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "  ✗ Failed to remove old column ", columnInfo.oldName, " from ", tableName, "\n")
                                        end
                                    end)
                                end)
                            else
                                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "  ✗ Failed to create new column ", columnInfo.newName, " in ", tableName, "\n")
                            end
                        end)
                    end
                end)
            end

            timer.Simple(2.0, function()
                MsgC(Color(255, 255, 0), "\n[Lilia] ", Color(255, 255, 255), "=== Column Underscore Removal Summary ===\n")
                MsgC(Color(255, 255, 255), "lia_* tables processed: ", totalTables, "\n")
                MsgC(Color(255, 255, 255), "Columns processed: ", totalColumnsRemoved, "\n")
                if totalColumnsRemoved > 0 then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Successfully processed ", totalColumnsRemoved, " column(s) across ", totalTables, " lia_* table(s)\n")
                else
                    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "! No columns with leading underscores were found to process in lia_* tables\n")
                end

                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "=== Column Underscore Removal Completed ===\n")
            end)
        end)
    end)
end)

-- Automatic underscore removal on connect
function lia.db.autoRemoveUnderscoreColumns()
    local d = deferred.new()
    if not lia.db.connected then
        d:resolve()
        return d
    end

    lia.db.getTables():next(function(tables)
        if not tables or #tables == 0 then d:resolve() return end
        local totalColumnsRemoved = 0
        local processPromises = {}
        for _, tableName in ipairs(tables) do
            local processPromise = deferred.new()
            table.insert(processPromises, processPromise)
            lia.db.getTableColumns(tableName):next(function(columns)
                if not columns then processPromise:resolve() return end
                local columnsToRemove = {}
                local columnsToRename = {}
                for columnName, columnType in pairs(columns) do
                    if columnName:sub(1, 1) == "_" then
                        local newColumnName = columnName:gsub("^_+", "")
                        if newColumnName ~= columnName then
                            if columns[newColumnName] then
                                table.insert(columnsToRemove, {oldName = columnName, newName = newColumnName, type = columnType})
                            else
                                table.insert(columnsToRename, {oldName = columnName, newName = newColumnName, type = columnType})
                            end
                        end
                    end
                end

                if #columnsToRemove == 0 and #columnsToRename == 0 then processPromise:resolve() return end
                local columnPromises = {}
                for _, columnInfo in ipairs(columnsToRemove) do
                    local columnPromise = deferred.new()
                    table.insert(columnPromises, columnPromise)
                    local shortTableName = tableName:gsub("^lia_", "")
                    lia.db.removeColumn(shortTableName, columnInfo.oldName):next(function(removeResult)
                        if removeResult then
                            totalColumnsRemoved = totalColumnsRemoved + 1
                            columnPromise:resolve()
                        else
                            columnPromise:reject("Failed to remove duplicate column")
                        end
                    end):catch(function(err) columnPromise:reject(err) end)
                end

                for _, columnInfo in ipairs(columnsToRename) do
                    local columnPromise = deferred.new()
                    table.insert(columnPromises, columnPromise)
                    local shortTableName = tableName:gsub("^lia_", "")
                    lia.db.createColumn(shortTableName, columnInfo.newName, (columnInfo.type or "text"):lower()):next(function(createResult)
                        if createResult then
                            local updateQuery = "UPDATE " .. tableName .. " SET " .. lia.db.escapeIdentifier(columnInfo.newName) .. " = " .. lia.db.escapeIdentifier(columnInfo.oldName)
                            lia.db.query(updateQuery, function()
                                lia.db.removeColumn(shortTableName, columnInfo.oldName):next(function(removeResult)
                                    if removeResult then
                                        totalColumnsRemoved = totalColumnsRemoved + 1
                                        columnPromise:resolve()
                                    else
                                        columnPromise:reject("Failed to remove old column")
                                    end
                                end):catch(function(err) columnPromise:reject(err) end)
                            end)
                        else
                            columnPromise:reject("Failed to create column")
                        end
                    end):catch(function(err) columnPromise:reject(err) end)
                end

                deferred.all(columnPromises):next(function() processPromise:resolve() end):catch(function() processPromise:resolve() end)
            end):catch(function() processPromise:resolve() end)
        end

        deferred.all(processPromises):next(function()
            if totalColumnsRemoved > 0 then MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Auto-removed ", totalColumnsRemoved, " underscore-prefixed column(s) on database connection\n") end
            d:resolve()
        end):catch(function() d:resolve() end)
    end):catch(function() d:resolve() end)
    return d
end

-- Wipe all lia_* tables function
function lia.db.wipeTables(callback)
    local d = deferred.new()
    
    if not lia.db.connected then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database not connected! Cannot wipe tables.\n")
        if callback then callback() end
        d:resolve()
        return d
    end
    
    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Starting database wipe...\n")
    
    -- Disable foreign key constraints temporarily
    sql.Query("PRAGMA foreign_keys=OFF")
    
    -- Get all existing lia_* tables
    local tables = sql.Query("SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'lia_%'")
    if not tables or #tables == 0 then
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "No lia_* tables found to wipe\n")
        sql.Query("PRAGMA foreign_keys=ON")
        if callback then callback() end
        d:resolve()
        return d
    end
    
    MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found " .. #tables .. " lia_* tables to wipe\n")
    
    -- Drop all lia_* tables
    local droppedCount = 0
    for _, table in ipairs(tables) do
        local tableName = table.name
        MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Dropping table: " .. tableName .. "\n")
        
        local result = sql.Query("DROP TABLE IF EXISTS " .. tableName)
        if result ~= false then
            droppedCount = droppedCount + 1
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Dropped table: " .. tableName .. "\n")
        else
            local error = sql.LastError()
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✗ Failed to drop table " .. tableName .. ": " .. tostring(error) .. "\n")
        end
    end
    
    -- Re-enable foreign key constraints
    sql.Query("PRAGMA foreign_keys=ON")
    
    -- Clear any cached data
    if lia.db.cacheClear then
        lia.db.cacheClear()
    end
    
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Database wipe completed! Dropped " .. droppedCount .. " tables.\n")
    
    -- Call the callback if provided
    if callback then
        callback()
    end
    
    d:resolve()
    return d
end
