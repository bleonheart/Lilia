--[[
    Database Library

    Comprehensive database management system with SQLite support for the Lilia framework.
]]
--[[
    Overview:
        The database library provides comprehensive database management functionality for the Lilia framework. It handles all database operations including connection management, table creation and modification, data insertion, updates, queries, and schema management. The library supports SQLite as the primary database engine with extensible module support for other database systems. It includes advanced features such as prepared statements, transactions, bulk operations, data type conversion, and database snapshots for backup and restore operations. The library ensures data persistence across server restarts and provides robust error handling with deferred promise-based operations for asynchronous database queries. It manages core gamemode tables for players, characters, inventories, items, configuration, logs, and administrative data while supporting dynamic schema modifications.
]]
lia.db = lia.db or {}
lia.db.queryQueue = lia.db.queue or {}
lia.db.prepared = lia.db.prepared or {}
lia.db.modules = {
    ["sqlite"] = {
        query = function(query, callback)
    4    local d
    4    if not isfunction(callback) then
        4    d = deferred.new()
        4    callback = function(results, lastID)
            4    d:resolve({
                4    results = results,
                4    lastID = lastID
            4    })
        4    end
    4    end

    4    local data = sql.Query(query)
    4    local err = sql.LastError()
    4    if data == false then
        4    if d then
            4    d:reject(err)
        4    else
            4    if string.find(err, "duplicate column name:") or string.find(err, "UNIQUE constraint failed: lia_config") then return end
            4    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), " * " .. query .. "\n")
            4    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), " " .. err .. "\n")
        4    end
    4    end

    4    if callback then
        4    local lastID = tonumber(sql.QueryValue("SELECT last_insert_rowid()"))
        4    callback(data, lastID)
    4    end
    4    return d
        end,
        escape = function(value) return sql.SQLStr(value, true) end,
        connect = function(callback)
    4    lia.db.query = lia.db.modules.sqlite.query
    4    if callback then callback() end
        end
    }
}

lia.db.escape = lia.db.escape or lia.db.modules.sqlite.escape
lia.db.query = lia.db.query or function(...) lia.db.queryQueue[#lia.db.queryQueue + 1] = {...} end
--[[
    Purpose:
        Establishes a connection to the database using the configured database module

    When Called:
        During server startup, module initialization, or when reconnecting to database

    Parameters:
        - callback (function, optional): Function to call after successful connection
        - reconnect (boolean, optional): Force reconnection even if already connected

    Returns:
        None

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Connect to database with callback
        lia.db.connect(function()
        print("Database connected successfully!")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Connect with error handling and reconnection
        lia.db.connect(function()
        lia.log.add("Database connection established")
        lia.db.loadTables()
        end, true)
        ```

        High Complexity:
        ```lua
        -- High: Connect with conditional logic and module validation
        if lia.db.module and lia.db.modules[lia.db.module] then
    4    lia.db.connect(function()
    4    lia.bootstrap("Database", "Connected to " .. lia.db.module)
    4    hook.Run("OnDatabaseConnected")
        end, not lia.db.connected)
        else
    4    lia.error("Invalid database module: " .. tostring(lia.db.module))
        end
        ```
]]
function lia.db.connect(callback, reconnect)
    local dbModule = lia.db.modules[lia.db.module]
    if dbModule then
        if (reconnect or not lia.db.connected) and not lia.db.object then
    4    dbModule.connect(function()
        4    lia.db.connected = true
        4    if isfunction(callback) then callback() end
        4    for i = 1, #lia.db.queryQueue do
            4    lia.db.query(unpack(lia.db.queryQueue[i]))
        4    end

        4    lia.db.queryQueue = {}
    4    end)
        end

        lia.db.escape = dbModule.escape
        lia.db.query = dbModule.query
    else
        lia.error(L("invalidStorageModule", lia.db.module or "Unavailable"))
    end
end

--[[
    Purpose:
        Removes all Lilia database tables and their data from the database

    When Called:
        During database reset operations, development testing, or administrative cleanup

    Parameters:
        - callback (function, optional): Function to call after all tables are wiped

    Returns:
        None

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Wipe all tables with confirmation
        lia.db.wipeTables(function()
        print("All database tables have been wiped!")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Wipe tables with logging and backup
        lia.log.add("Starting database wipe operation")
        lia.db.wipeTables(function()
        lia.log.add("Database wipe completed successfully")
        hook.Run("OnDatabaseWiped")
        end)
        ```

        High Complexity:
        ```lua
        -- High: Wipe tables with confirmation and error handling
        local function confirmWipe()
    4    lia.db.wipeTables(function()
    4    lia.bootstrap("Database", "All tables wiped successfully")
    4    lia.db.loadTables() -- Reload empty tables
    4    hook.Run("OnDatabaseReset")
        end)
        end

        if lia.config.get("allowDatabaseWipe", false) then
    4    confirmWipe()
    4    else
        4    lia.error("Database wipe not allowed by configuration")
    4    end
        ```
]]
function lia.db.wipeTables(callback)
    local wipedTables = {}
    local function realCallback()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. L("database") .. "]", Color(255, 255, 255), L("dataWiped") .. "\n")
        if #wipedTables > 0 then MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), L("wipedTables", table.concat(wipedTables, ", ")) .. "\n") end
        if isfunction(callback) then callback() end
    end

    lia.db.query([[SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'lia_%';]], function(data)
        data = data or {}
        local remaining = #data
        if remaining == 0 then
    4    realCallback()
    4    return
        end

        for _, row in ipairs(data) do
    4    local tableName = row.name or row[1]
    4    table.insert(wipedTables, tableName)
    4    lia.db.query("DROP TABLE IF EXISTS " .. tableName .. ";", function()
        4    remaining = remaining - 1
        4    if remaining <= 0 then realCallback() end
    4    end)
        end
    end)
end

--[[
    Purpose:
        Creates all core Lilia database tables if they don't exist and initializes the database schema

    When Called:
        During server startup after database connection, or when initializing a new database

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Load tables after connection
        lia.db.connect(function()
        lia.db.loadTables()
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Load tables with hook integration
        lia.db.connect(function()
        lia.db.loadTables()
        lia.log.add("Database tables loaded successfully")
        end)
        ```

        High Complexity:
        ```lua
        -- High: Load tables with conditional logic and error handling
        local function initializeDatabase()
    4    lia.db.connect(function()
    4    lia.db.loadTables()
    4    hook.Run("OnDatabaseInitialized")
    4    lia.bootstrap("Database", "Schema loaded and ready")
        end, true)
        end

        if lia.db.module and lia.db.modules[lia.db.module] then
    4    initializeDatabase()
    4    else
        4    lia.error("Cannot initialize database: invalid module")
    4    end
        ```
]]
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
CREATE TABLE IF NOT EXISTS lia_data (
    gamemode text,
    map text,
    data text,
    PRIMARY KEY (gamemode, map)
);
]], done)
    hook.Run("OnLoadTables")
end

--[[
    Purpose:
        Returns a deferred promise that resolves when database tables have finished loading

    When Called:
        Before performing database operations that require tables to be loaded

    Parameters:
        None

    Returns:
        Deferred promise object

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Wait for tables to load before proceeding
        lia.db.waitForTablesToLoad():next(function()
        print("Tables are ready!")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Wait for tables with error handling
        lia.db.waitForTablesToLoad():next(function()
        lia.log.add("Database tables loaded, proceeding with initialization")
        hook.Run("OnTablesReady")
        end):catch(function(err)
        lia.error("Failed to load database tables: " .. tostring(err))
        end)
        ```

        High Complexity:
        ```lua
        -- High: Wait for tables with timeout and fallback
        local function initializeAfterTables()
    4    lia.db.waitForTablesToLoad():next(function()
    4    lia.char.loadCharacters()
    4    lia.inventory.loadInventories()
    4    lia.bootstrap("Database", "All systems initialized")
        end):catch(function(err)
        lia.error("Critical database initialization failure: " .. tostring(err))
        lia.db.connect(function()
        lia.db.loadTables()
        initializeAfterTables()
        end, true)
        end)
        end

        initializeAfterTables()
        ```
]]
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

local function buildWhereClause(conditions)
    if not conditions then return "" end
    if isstring(conditions) then return " WHERE " .. tostring(conditions) end
    if istable(conditions) and next(conditions) then
        local whereParts = {}
        for field, value in pairs(conditions) do
    4    if value ~= nil then
        4    local operator = "="
        4    local conditionValue = value
        4    if istable(value) and value.operator and value.value ~= nil then
            4    operator = value.operator
            4    conditionValue = value.value
        4    end

        4    local escapedField = lia.db.escapeIdentifier(field)
        4    local convertedValue = lia.db.convertDataType(conditionValue)
        4    table.insert(whereParts, escapedField .. " " .. operator .. " " .. convertedValue)
    4    end
        end

        if #whereParts > 0 then return " WHERE " .. table.concat(whereParts, " AND ") end
    end
    return ""
end

--[[
    Purpose:
        Converts Lua values to SQL-compatible format with proper escaping and type handling

    When Called:
        Internally by database functions when preparing data for SQL queries

    Parameters:
        - value (any): The value to convert to SQL format
        - noEscape (boolean, optional): Skip escaping for raw SQL values

    Returns:
        String representation of the value in SQL format

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Convert basic data types
        local sqlString = lia.db.convertDataType("Hello World")
        local sqlNumber = lia.db.convertDataType(42)
        local sqlBool = lia.db.convertDataType(true)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Convert complex data with escaping
        local playerData = {
        name = "John Doe",
        level = 25,
        isActive = true,
        inventory = {weapon = "pistol", ammo = 100}
        }

        local sqlData = {}
        for key, value in pairs(playerData) do
    4    sqlData[key] = lia.db.convertDataType(value)
        end
        ```

        High Complexity:
        ```lua
        -- High: Convert with conditional logic and error handling
        local function safeConvert(value, fieldName)
    4    if value == nil then
        4    return "NULL"
        4    elseif type(value) == "table" then
            4    local success, json = pcall(util.TableToJSON, value)
            4    if success then
                4    return "'" .. lia.db.escape(json) .. "'"
                4    else
                    4    lia.log.add("Failed to convert table for field: " .. fieldName)
                    4    return "NULL"
                4    end
                4    else
                    4    return lia.db.convertDataType(value)
                4    end
            4    end
        ```
]]
function lia.db.convertDataType(value, noEscape)
    if value == nil then
        return "NULL"
    elseif isstring(value) then
        if noEscape then
    4    return value
        else
    4    return "'" .. lia.db.escape(value) .. "'"
        end
    elseif istable(value) then
        if noEscape then
    4    return util.TableToJSON(value)
        else
    4    return "'" .. lia.db.escape(util.TableToJSON(value)) .. "'"
        end
    elseif isbool(value) then
        return value and 1 or 0
    elseif value == NULL then
        return "NULL"
    end
    return value
end

--[[
    Purpose:
        Inserts a new record into a specified database table

    When Called:
        When creating new database records for players, characters, items, etc.

    Parameters:
        - value (table): Key-value pairs representing the data to insert
        - callback (function, optional): Function to call after successful insertion
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'characters')

    Returns:
        Deferred promise object with results and lastID

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Insert a new character
        lia.db.insertTable({
        steamID = "STEAM_0:1:12345678",
        name = "John Doe",
        model = "models/player/kleiner.mdl"
        }, function(results, lastID)
        print("Character created with ID:", lastID)
        end, "characters")
        ```

        Medium Complexity:
        ```lua
        -- Medium: Insert with error handling and validation
        local characterData = {
        steamID = player:SteamID(),
        name = player:Name(),
        model = player:GetModel(),
        faction = "citizen",
        money = "0"
        }

        lia.db.insertTable(characterData, function(results, lastID)
        if lastID then
    4    lia.log.add("Character created for " .. player:Name())
    4    hook.Run("OnCharacterCreated", player, lastID)
        end
        end, "characters")
        ```

        High Complexity:
        ```lua
        -- High: Insert with validation, error handling, and rollback
        local function createCharacterWithValidation(playerData)
    4    local validation = lia.char.validateData(playerData)
    4    if not validation.valid then
        4    return deferred.new():reject("Validation failed: " .. validation.error)
    4    end

    4    return lia.db.insertTable(playerData, function(results, lastID)
    4    if lastID then
        4    lia.char.cache[lastID] = playerData
        4    hook.Run("OnCharacterCreated", lastID, playerData)
    4    end
        end, "characters")
        end
        ```
]]
function lia.db.insertTable(value, callback, dbTable)
    local d = deferred.new()
    local query = "INSERT INTO " .. genInsertValues(value, dbTable)
    lia.db.query(query, function(results, lastID)
        if callback then callback(results, lastID) end
        d:resolve({
    4    results = results,
    4    lastID = lastID
        })
    end, function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Updates existing records in a specified database table based on conditions

    When Called:
        When modifying existing database records for players, characters, items, etc.

    Parameters:
        - value (table): Key-value pairs representing the data to update
        - callback (function, optional): Function to call after successful update
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'characters')
        - condition (table/string, optional): WHERE clause conditions for the update

    Returns:
        Deferred promise object with results and lastID

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Update character money
        lia.db.updateTable({
        money = "1000"
        }, function(results, lastID)
        print("Character updated successfully!")
        end, "characters", {id = 1})
        ```

        Medium Complexity:
        ```lua
        -- Medium: Update with complex conditions and logging
        local updateData = {
        lastJoinTime = os.date("%Y-%m-%d %H:%M:%S"),
        money = tostring(character:getMoney())
        }

        lia.db.updateTable(updateData, function(results, lastID)
        if results then
    4    lia.log.add("Character " .. character:getName() .. " updated")
    4    hook.Run("OnCharacterUpdated", character)
        end
        end, "characters", {id = character:getID()})
        ```

        High Complexity:
        ```lua
        -- High: Update with validation, transaction, and rollback
        local function updateCharacterWithValidation(charID, updateData)
    4    return lia.db.transaction({
    4    "BEGIN TRANSACTION",
    4    "UPDATE lia_characters SET " ..
    4    table.concat(lia.util.map(updateData, function(k, v)
    4    return k .. " = " .. lia.db.convertDataType(v)
        end), ", ") ..
        " WHERE id = " .. charID,
        "COMMIT"
        }):next(function()
        lia.char.cache[charID] = lia.util.merge(lia.char.cache[charID] or {}, updateData)
        hook.Run("OnCharacterUpdated", charID, updateData)
        end):catch(function(err)
        lia.error("Failed to update character " .. charID .. ": " .. tostring(err))
        end)
        end
        ```
]]
function lia.db.updateTable(value, callback, dbTable, condition)
    local d = deferred.new()
    local query = "UPDATE " .. "lia_" .. (dbTable or "characters") .. " SET " .. genUpdateList(value) .. buildWhereClause(condition)
    lia.db.query(query, function(results, lastID)
        if callback then callback(results, lastID) end
        d:resolve({
    4    results = results,
    4    lastID = lastID
        })
    end, function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Performs a SELECT query on a specified database table with optional conditions and limits

    When Called:
        When retrieving data from database tables for players, characters, items, etc.

    Parameters:
        - fields (string/table): Field names to select (string or table of strings)
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'characters')
        - condition (table/string, optional): WHERE clause conditions for the query
        - limit (number, optional): Maximum number of records to return

    Returns:
        Deferred promise object with results array

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Select all characters
        lia.db.select("*", "characters"):next(function(results)
        print("Found " .. #results .. " characters")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Select with conditions and specific fields
        lia.db.select({"name", "money", "faction"}, "characters", {
        steamID = "STEAM_0:1:12345678"
        }, 10):next(function(results)
        for _, char in ipairs(results) do
    4    print(char.name .. " has $" .. char.money)
        end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Select with complex conditions, pagination, and error handling
        local function getCharactersByFaction(faction, page, pageSize)
    4    local offset = (page - 1) * pageSize
    4    return lia.db.select("*", "characters", {
    4    faction = faction,
    4    lastJoinTime = {operator = ">", value = os.date("%Y-%m-%d", os.time() - 86400)}
    4    }, pageSize):next(function(results)
    4    local characters = {}
    4    for _, char in ipairs(results) do
        4    table.insert(characters, lia.char.new(char))
    4    end
    4    return characters
        end):catch(function(err)
        lia.error("Failed to load characters: " .. tostring(err))
        return {}
        end)
        end
        ```
]]
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
    4    results = results,
    4    lastID = lastID
        })
    end)
    return d
end

--[[
    Purpose:
        Performs a SELECT query with advanced condition handling and optional ordering

    When Called:
        When retrieving data with complex WHERE clauses and ORDER BY requirements

    Parameters:
        - fields (string/table): Field names to select (string or table of strings)
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'characters')
        - conditions (table/string, optional): WHERE clause conditions with operator support
        - limit (number, optional): Maximum number of records to return
        - orderBy (string, optional): ORDER BY clause for sorting results

    Returns:
        Deferred promise object with results array

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Select with basic condition
        lia.db.selectWithCondition("*", "characters", {
        faction = "citizen"
        }):next(function(results)
        print("Found " .. #results .. " citizens")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Select with operators and ordering
        lia.db.selectWithCondition({"name", "money"}, "characters", {
        money = {operator = ">", value = "1000"},
        faction = "citizen"
        }, 5, "money DESC"):next(function(results)
        for _, char in ipairs(results) do
    4    print(char.name .. " has $" .. char.money)
        end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Select with complex conditions, pagination, and error handling
        local function searchCharacters(searchTerm, faction, minMoney, maxResults)
    4    local conditions = {}
    4    if searchTerm then
        4    conditions.name = {operator = "LIKE", value = "%" .. searchTerm .. "%"}
    4    end
    4    if faction then
        4    conditions.faction = faction
    4    end
    4    if minMoney then
        4    conditions.money = {operator = ">=", value = tostring(minMoney)}
    4    end

    4    return lia.db.selectWithCondition("*", "characters", conditions,
    4    maxResults, "lastJoinTime DESC"):next(function(results)
    4    local characters = {}
    4    for _, char in ipairs(results) do
        4    table.insert(characters, lia.char.new(char))
    4    end
    4    return characters
        end):catch(function(err)
        lia.error("Character search failed: " .. tostring(err))
        return {}
        end)
        end
        ```
]]
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
    4    if value ~= nil then
        4    local operator = "="
        4    local conditionValue = value
        4    if istable(value) and value.operator and value.value ~= nil then
            4    operator = value.operator
            4    conditionValue = value.value
        4    end

        4    local escapedField = lia.db.escapeIdentifier(field)
        4    local convertedValue = lia.db.convertDataType(conditionValue)
        4    table.insert(whereParts, escapedField .. " " .. operator .. " " .. convertedValue)
    4    end
        end

        if #whereParts > 0 then query = query .. " WHERE " .. table.concat(whereParts, " AND ") end
    elseif isstring(conditions) then
        query = query .. " WHERE " .. tostring(conditions)
    end

    if orderBy then query = query .. " ORDER BY " .. tostring(orderBy) end
    if limit then query = query .. " LIMIT " .. tostring(limit) end
    lia.db.query(query, function(results, lastID)
        d:resolve({
    4    results = results,
    4    lastID = lastID
        })
    end)
    return d
end

--[[
    Purpose:
        Counts the number of records in a database table matching specified conditions

    When Called:
        When checking record counts for statistics, validation, or pagination

    Parameters:
        - dbTable (string): Table name without 'lia_' prefix
        - condition (table/string, optional): WHERE clause conditions for counting

    Returns:
        Deferred promise object resolving to the count number

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Count all characters
        lia.db.count("characters"):next(function(count)
        print("Total characters: " .. count)
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Count with conditions
        lia.db.count("characters", {
        faction = "citizen",
        money = {operator = ">", value = "1000"}
        }):next(function(count)
        print("Rich citizens: " .. count)
        end)
        ```

        High Complexity:
        ```lua
        -- High: Count with validation and error handling
        local function getPlayerStats(steamID)
    4    return lia.db.count("characters", {steamID = steamID}):next(function(charCount)
    4    return lia.db.count("players", {steamID = steamID}):next(function(playerCount)
    4    return {
    4    characters = charCount,
    4    playerRecords = playerCount,
    4    isNewPlayer = playerCount == 0
    4    }
        end)
        end):catch(function(err)
        lia.error("Failed to get player stats: " .. tostring(err))
        return {characters = 0, playerRecords = 0, isNewPlayer = true}
        end)
        end
        ```
]]
function lia.db.count(dbTable, condition)
    local c = deferred.new()
    local tbl = "`lia_" .. dbTable .. "`"
    local q = "SELECT COUNT(*) AS cnt FROM " .. tbl .. buildWhereClause(condition)
    lia.db.query(q, function(results)
        if istable(results) then
    4    c:resolve(tonumber(results[1].cnt))
        else
    4    c:resolve(0)
        end
    end)
    return c
end

--[[
    Purpose:
        Dynamically adds new columns to the lia_characters table based on character variables

    When Called:
        During database initialization to ensure character table has all required fields

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Add fields after table creation
        lia.db.loadTables() -- This automatically calls addDatabaseFields()
        ```

        Medium Complexity:
        ```lua
        -- Medium: Add fields with logging
        lia.db.addDatabaseFields()
        lia.log.add("Database fields updated for character variables")
        ```

        High Complexity:
        ```lua
        -- High: Add fields with validation and error handling
        local function ensureCharacterFields()
    4    if not istable(lia.char.vars) then
        4    lia.log.add("Character variables not defined, skipping field addition")
        4    return
    4    end

    4    lia.db.addDatabaseFields()
    4    lia.log.add("Character database fields synchronized")
    4    hook.Run("OnCharacterFieldsUpdated")
        end

        ensureCharacterFields()
        ```
]]
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
    4    lia.db.fieldExists("lia_characters", v.field):next(function(exists)
        4    if not exists then
            4    local colDef = typeMap[v.fieldType](v)
            4    if v.default ~= nil then colDef = colDef .. " DEFAULT '" .. tostring(v.default) .. "'" end
            4    lia.db.query("ALTER TABLE lia_characters ADD COLUMN " .. colDef):catch(ignore)
        4    end
    4    end)
        end
    end
end

--[[
    Purpose:
        Checks if any records exist in a database table matching specified conditions

    When Called:
        When validating data existence before operations or for conditional logic

    Parameters:
        - dbTable (string): Table name without 'lia_' prefix
        - condition (table/string, optional): WHERE clause conditions for checking existence

    Returns:
        Deferred promise object resolving to boolean (true if records exist)

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Check if player exists
        lia.db.exists("players", {steamID = "STEAM_0:1:12345678"}):next(function(exists)
        if exists then
    4    print("Player found in database")
    4    else
        4    print("New player")
    4    end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Check with complex conditions
        lia.db.exists("characters", {
        steamID = player:SteamID(),
        faction = "citizen",
        money = {operator = ">", value = "1000"}
        }):next(function(exists)
        if exists then
    4    lia.log.add("Player has wealthy citizen character")
        end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Check with validation and error handling
        local function validatePlayerData(steamID)
    4    return lia.db.exists("players", {steamID = steamID}):next(function(playerExists)
    4    if not playerExists then
        4    return lia.db.insertTable({
        4    steamID = steamID,
        4    steamName = "Unknown",
        4    firstJoin = os.date("%Y-%m-%d %H:%M:%S"),
        4    userGroup = "user"
        4    }, nil, "players")
    4    end
    4    return playerExists
        end):catch(function(err)
        lia.error("Failed to validate player data: " .. tostring(err))
        return false
        end)
        end
        ```
]]
function lia.db.exists(dbTable, condition)
    return lia.db.count(dbTable, condition):next(function(n) return n > 0 end)
end

--[[
    Purpose:
        Retrieves a single record from a database table matching specified conditions

    When Called:
        When fetching unique records like player data, character info, or single items

    Parameters:
        - fields (string/table): Field names to select (string or table of strings)
        - dbTable (string): Table name without 'lia_' prefix
        - condition (table/string, optional): WHERE clause conditions for the query

    Returns:
        Deferred promise object resolving to the first matching record or nil

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Get character by ID
        lia.db.selectOne("*", "characters", {id = 1}):next(function(char)
        if char then
    4    print("Character name: " .. char.name)
        end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Get player data with specific fields
        lia.db.selectOne({"steamName", "userGroup", "lastJoin"}, "players", {
        steamID = player:SteamID()
        }):next(function(playerData)
        if playerData then
    4    player:SetUserGroup(playerData.userGroup)
    4    lia.log.add("Loaded player: " .. playerData.steamName)
        end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Get with validation and error handling
        local function loadCharacter(charID)
    4    return lia.db.selectOne("*", "characters", {id = charID}):next(function(charData)
    4    if not charData then
        4    return deferred.new():reject("Character not found")
    4    end

    4    local character = lia.char.new(charData)
    4    lia.char.cache[charID] = character
    4    hook.Run("OnCharacterLoaded", character)
    4    return character
        end):catch(function(err)
        lia.error("Failed to load character " .. charID .. ": " .. tostring(err))
        return nil
        end)
        end
        ```
]]
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
    4    c:resolve(results[1])
        else
    4    c:resolve(nil)
        end
    end)
    return c
end

--[[
    Purpose:
        Inserts multiple records into a database table in a single operation for better performance

    When Called:
        When inserting large amounts of data like inventory items, logs, or batch operations

    Parameters:
        - dbTable (string): Table name without 'lia_' prefix
        - rows (table): Array of tables containing the data to insert

    Returns:
        Deferred promise object resolving when all records are inserted

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Insert multiple items
        local items = {
        {uniqueID = "pistol", quantity = 1, x = 1, y = 1},
        {uniqueID = "ammo", quantity = 50, x = 2, y = 1}
        }
        lia.db.bulkInsert("items", items):next(function()
        print("Items inserted successfully")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Insert with validation and error handling
        local function insertInventoryItems(invID, items)
    4    local rows = {}
    4    for _, item in ipairs(items) do
        4    table.insert(rows, {
        4    invID = invID,
        4    uniqueID = item.uniqueID,
        4    data = util.TableToJSON(item.data or {}),
        4    quantity = item.quantity or 1,
        4    x = item.x or 1,
        4    y = item.y or 1
        4    })
    4    end

    4    return lia.db.bulkInsert("items", rows):next(function()
    4    lia.log.add("Inserted " .. #rows .. " items into inventory " .. invID)
        end):catch(function(err)
        lia.error("Failed to insert items: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Insert with batching, validation, and progress tracking
        local function bulkInsertWithBatching(dbTable, data, batchSize)
    4    batchSize = batchSize or 100
    4    local batches = {}

    4    for i = 1, #data, batchSize do
        4    local batch = {}
        4    for j = i, math.min(i + batchSize - 1, #data) do
            4    table.insert(batch, data[j])
        4    end
        4    table.insert(batches, batch)
    4    end

    4    local currentBatch = 1
    4    local function insertNextBatch()
        4    if currentBatch > #batches then
            4    return deferred.new():resolve()
        4    end

        4    return lia.db.bulkInsert(dbTable, batches[currentBatch]):next(function()
        4    lia.log.add("Batch " .. currentBatch .. "/" .. #batches .. " completed")
        4    currentBatch = currentBatch + 1
        4    return insertNextBatch()
    4    end)
        end

        return insertNextBatch()
        end
        ```
]]
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
    4    local key = k:sub(2, -2)
    4    items[#items + 1] = lia.db.convertDataType(row[key])
        end

        vals[#vals + 1] = "(" .. table.concat(items, ",") .. ")"
    end

    local q = "INSERT INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ",")
    lia.db.query(q, function() c:resolve() end, function(err) c:reject(err) end)
    return c
end

--[[
    Purpose:
        Performs bulk INSERT OR REPLACE operations for updating existing records or inserting new ones

    When Called:
        When synchronizing data that may already exist, like configuration updates or data imports

    Parameters:
        - dbTable (string): Table name without 'lia_' prefix
        - rows (table): Array of tables containing the data to upsert

    Returns:
        Deferred promise object resolving when all records are upserted

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Upsert configuration data
        local configs = {
        {schema = "default", key = "maxPlayers", value = "32"},
        {schema = "default", key = "serverName", value = "My Server"}
        }
        lia.db.bulkUpsert("config", configs):next(function()
        print("Configuration updated")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Upsert with validation and error handling
        local function syncPlayerData(players)
    4    local rows = {}
    4    for _, player in ipairs(players) do
        4    table.insert(rows, {
        4    steamID = player:SteamID(),
        4    steamName = player:Name(),
        4    lastJoin = os.date("%Y-%m-%d %H:%M:%S"),
        4    lastIP = player:IPAddress(),
        4    userGroup = player:GetUserGroup()
        4    })
    4    end

    4    return lia.db.bulkUpsert("players", rows):next(function()
    4    lia.log.add("Synchronized " .. #rows .. " player records")
        end):catch(function(err)
        lia.error("Failed to sync player data: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Upsert with conflict resolution and progress tracking
        local function bulkSyncWithConflictResolution(dbTable, data, conflictFields)
    4    local batches = {}
    4    local batchSize = 50

    4    for i = 1, #data, batchSize do
        4    local batch = {}
        4    for j = i, math.min(i + batchSize - 1, #data) do
            4    local record = data[j]
            4    -- Add conflict resolution metadata
            4    record._syncTimestamp = os.time()
            4    record._conflictFields = conflictFields
            4    table.insert(batch, record)
        4    end
        4    table.insert(batches, batch)
    4    end

    4    local completed = 0
    4    local function processNextBatch()
        4    if completed >= #batches then
            4    return deferred.new():resolve()
        4    end

        4    return lia.db.bulkUpsert(dbTable, batches[completed + 1]):next(function()
        4    completed = completed + 1
        4    lia.log.add("Batch " .. completed .. "/" .. #batches .. " synced")
        4    return processNextBatch()
    4    end)
        end

        return processNextBatch()
        end
        ```
]]
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
    4    local key = k:sub(2, -2)
    4    items[#items + 1] = lia.db.convertDataType(row[key])
        end

        vals[#vals + 1] = "(" .. table.concat(items, ",") .. ")"
    end

    local q = "INSERT OR REPLACE INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ",")
    lia.db.query(q, function() c:resolve() end, function(err) c:reject(err) end)
    return c
end

--[[
    Purpose:
        Inserts a record into a database table, ignoring the operation if it would cause a constraint violation

    When Called:
        When inserting data that may already exist, like unique configurations or duplicate-safe operations

    Parameters:
        - value (table): Key-value pairs representing the data to insert
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'characters')

    Returns:
        Deferred promise object with results and lastID

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Insert configuration without duplicates
        lia.db.insertOrIgnore({
        schema = "default",
        key = "serverName",
        value = "My Server"
        }, "config"):next(function(results, lastID)
        print("Configuration inserted or ignored")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Insert with validation and logging
        local function ensureDefaultConfig(configs)
    4    for _, config in ipairs(configs) do
        4    lia.db.insertOrIgnore({
        4    schema = config.schema,
        4    key = config.key,
        4    value = config.value
        4    }, "config"):next(function(results, lastID)
        4    if lastID then
            4    lia.log.add("Added new config: " .. config.key)
        4    end
    4    end)
        end
        end
        ```

        High Complexity:
        ```lua
        -- High: Insert with conflict detection and fallback
        local function safeInsertWithFallback(data, dbTable, fallbackData)
    4    return lia.db.insertOrIgnore(data, dbTable):next(function(results, lastID)
    4    if lastID then
        4    -- Successfully inserted new record
        4    return {success = true, id = lastID, action = "inserted"}
        4    else
            4    -- Record already exists, try fallback operation
            4    return lia.db.updateTable(fallbackData, nil, dbTable, {
            4    [data.primaryKey or "id"] = data.id
            4    }):next(function()
            4    return {success = true, action = "updated"}
        4    end)
    4    end
        end):catch(function(err)
        lia.error("Insert or ignore failed: " .. tostring(err))
        return {success = false, error = err}
        end)
        end
        ```
]]
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
    4    results = results,
    4    lastID = lastID
        })
    end, function(err) c:reject(err) end)
    return c
end

--[[
    Purpose:
        Checks if a database table exists in the current database

    When Called:
        When validating table existence before operations or during schema validation

    Parameters:
        - tbl (string): Table name to check for existence

    Returns:
        Deferred promise object resolving to boolean (true if table exists)

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Check if table exists
        lia.db.tableExists("lia_characters"):next(function(exists)
        if exists then
    4    print("Characters table exists")
    4    else
        4    print("Characters table missing")
    4    end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Check with conditional logic
        lia.db.tableExists("lia_custom_table"):next(function(exists)
        if not exists then
    4    lia.log.add("Custom table missing, creating...")
    4    lia.db.createTable("custom_table", "id", {
    4    {name = "id", type = "INTEGER", not_null = true},
    4    {name = "data", type = "TEXT"}
    4    })
        end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Check with validation and error handling
        local function validateDatabaseSchema()
    4    local requiredTables = {"characters", "players", "items", "inventories"}
    4    local missingTables = {}

    4    local function checkNextTable(index)
        4    if index > #requiredTables then
            4    if #missingTables > 0 then
                4    lia.error("Missing tables: " .. table.concat(missingTables, ", "))
                4    return lia.db.loadTables()
                4    else
                    4    lia.log.add("All required tables exist")
                    4    return deferred.new():resolve()
                4    end
            4    end

            4    local tableName = "lia_" .. requiredTables[index]
            4    return lia.db.tableExists(tableName):next(function(exists)
            4    if not exists then
                4    table.insert(missingTables, tableName)
            4    end
            4    return checkNextTable(index + 1)
        4    end)
    4    end

    4    return checkNextTable(1)
        end
        ```
]]
function lia.db.tableExists(tbl)
    local d = deferred.new()
    local qt = "'" .. tbl:gsub("'", "''") .. "'"
    lia.db.query("SELECT name FROM sqlite_master WHERE type='table' AND name=" .. qt, function(res) d:resolve(res and #res > 0) end, function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Checks if a specific field/column exists in a database table

    When Called:
        When validating column existence before operations or during schema migrations

    Parameters:
        - tbl (string): Table name to check
        - field (string): Field/column name to check for existence

    Returns:
        Deferred promise object resolving to boolean (true if field exists)

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Check if field exists
        lia.db.fieldExists("lia_characters", "money"):next(function(exists)
        if exists then
    4    print("Money field exists")
    4    else
        4    print("Money field missing")
    4    end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Check with conditional field creation
        lia.db.fieldExists("lia_characters", "newField"):next(function(exists)
        if not exists then
    4    lia.log.add("Adding new field to characters table")
    4    lia.db.createColumn("characters", "newField", "VARCHAR(255)", "default_value")
        end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Check with validation and error handling
        local function validateCharacterFields()
    4    local requiredFields = {"name", "steamID", "money", "faction", "model"}
    4    local missingFields = {}

    4    local function checkNextField(index)
        4    if index > #requiredFields then
            4    if #missingFields > 0 then
                4    lia.error("Missing character fields: " .. table.concat(missingFields, ", "))
                4    return lia.db.addDatabaseFields()
                4    else
                    4    lia.log.add("All required character fields exist")
                    4    return deferred.new():resolve()
                4    end
            4    end

            4    return lia.db.fieldExists("lia_characters", requiredFields[index]):next(function(exists)
            4    if not exists then
                4    table.insert(missingFields, requiredFields[index])
            4    end
            4    return checkNextField(index + 1)
        4    end)
    4    end

    4    return checkNextField(1)
        end
        ```
]]
function lia.db.fieldExists(tbl, field)
    local d = deferred.new()
    lia.db.query("PRAGMA table_info(" .. tbl .. ")", function(res)
        for _, r in ipairs(res) do
    4    if r.name == field then return d:resolve(true) end
        end

        d:resolve(false)
    end, function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Retrieves a list of all Lilia database tables in the current database

    When Called:
        When auditing database structure, generating reports, or managing tables

    Parameters:
        None

    Returns:
        Deferred promise object resolving to array of table names

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Get all Lilia tables
        lia.db.getTables():next(function(tables)
        print("Found " .. #tables .. " Lilia tables")
        for _, tableName in ipairs(tables) do
    4    print("- " .. tableName)
        end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Get tables with analysis
        lia.db.getTables():next(function(tables)
        local coreTables = {"lia_characters", "lia_players", "lia_items"}
        local missingTables = {}

        for _, coreTable in ipairs(coreTables) do
    4    if not table.HasValue(tables, coreTable) then
        4    table.insert(missingTables, coreTable)
    4    end
        end

        if #missingTables > 0 then
    4    lia.log.add("Missing core tables: " .. table.concat(missingTables, ", "))
    4    else
        4    lia.log.add("All core tables present")
    4    end
        end)
        ```

        High Complexity:
        ```lua
        -- High: Get tables with validation and management
        local function auditDatabaseStructure()
    4    return lia.db.getTables():next(function(tables)
    4    local tableStats = {}
    4    local function analyzeNextTable(index)
        4    if index > #tables then
            4    lia.log.add("Database audit complete:")
            4    for tableName, stats in pairs(tableStats) do
                4    lia.log.add(tableName .. ": " .. stats.count .. " records")
            4    end
            4    return tableStats
        4    end

        4    local tableName = tables[index]
        4    return lia.db.count(tableName:sub(5)):next(function(count)
        4    tableStats[tableName] = {count = count}
        4    return analyzeNextTable(index + 1)
    4    end)
        end

        return analyzeNextTable(1)
        end):catch(function(err)
        lia.error("Database audit failed: " .. tostring(err))
        return {}
        end)
        end
        ```
]]
function lia.db.getTables()
    local d = deferred.new()
    lia.db.query("SELECT name FROM sqlite_master WHERE type='table'", function(res)
        local tables = {}
        for _, row in ipairs(res or {}) do
    4    if row.name and row.name:StartWith("lia_") then tables[#tables + 1] = row.name end
        end

        d:resolve(tables)
    end, function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Executes multiple database queries as a single atomic transaction with rollback on failure

    When Called:
        When performing complex operations that must succeed or fail together

    Parameters:
        - queries (table): Array of SQL query strings to execute in sequence

    Returns:
        Deferred promise object resolving when all queries succeed or rejecting on failure

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Transfer money between characters
        lia.db.transaction({
        "UPDATE lia_characters SET money = money - 100 WHERE id = 1",
        "UPDATE lia_characters SET money = money + 100 WHERE id = 2"
        }):next(function()
        print("Money transfer completed")
        end):catch(function(err)
        print("Transfer failed: " .. tostring(err))
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Create character with inventory
        local function createCharacterWithInventory(charData)
    4    local queries = {
    4    "INSERT INTO lia_characters (steamID, name, faction) VALUES ('" ..
    4    charData.steamID .. "', '" .. charData.name .. "', '" .. charData.faction .. "')",
    4    "INSERT INTO lia_inventories (charID, invType) VALUES (last_insert_rowid(), 'pocket')"
    4    }

    4    return lia.db.transaction(queries):next(function()
    4    lia.log.add("Character and inventory created successfully")
    4    hook.Run("OnCharacterCreated", charData)
        end):catch(function(err)
        lia.error("Failed to create character: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Complex transaction with validation and rollback
        local function transferItemsWithValidation(fromChar, toChar, items)
    4    local queries = {}
    4    local validationQueries = {}

    4    -- Build validation queries
    4    for _, item in ipairs(items) do
        4    table.insert(validationQueries,
        4    "SELECT COUNT(*) FROM lia_items WHERE invID = " .. fromChar.invID ..
        4    " AND uniqueID = '" .. item.uniqueID .. "' AND quantity >= " .. item.quantity)
    4    end

    4    -- Build transfer queries
    4    for _, item in ipairs(items) do
        4    table.insert(queries,
        4    "UPDATE lia_items SET quantity = quantity - " .. item.quantity ..
        4    " WHERE invID = " .. fromChar.invID .. " AND uniqueID = '" .. item.uniqueID .. "'")
        4    table.insert(queries,
        4    "INSERT OR REPLACE INTO lia_items (invID, uniqueID, quantity) VALUES (" ..
        4    toChar.invID .. ", '" .. item.uniqueID .. "', " .. item.quantity .. ")")
    4    end

    4    return lia.db.transaction(queries):next(function()
    4    lia.log.add("Items transferred successfully")
    4    hook.Run("OnItemsTransferred", fromChar, toChar, items)
        end):catch(function(err)
        lia.error("Item transfer failed: " .. tostring(err))
        hook.Run("OnTransferFailed", fromChar, toChar, items, err)
        end)
        end
        ```
]]
function lia.db.transaction(queries)
    local c = deferred.new()
    lia.db.query("BEGIN TRANSACTION", function()
        local i = 1
        local function nextQuery()
    4    if i > #queries then
        4    lia.db.query("COMMIT", function() c:resolve() end)
    4    else
        4    lia.db.query(queries[i], function()
            4    i = i + 1
            4    nextQuery()
        4    end, function(err) lia.db.query("ROLLBACK", function() c:reject(err) end) end)
    4    end
        end

        nextQuery()
    end, function(err) c:reject(err) end)
    return c
end

--[[
    Purpose:
        Escapes database identifiers (table names, column names) to prevent SQL injection

    When Called:
        Internally by database functions when building SQL queries with dynamic identifiers

    Parameters:
        - id (string): Identifier to escape (table name, column name, etc.)

    Returns:
        Escaped identifier string wrapped in backticks

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Escape a column name
        local escapedColumn = lia.db.escapeIdentifier("user_name")

        -- Returns: `user_name`
        ```

        Medium Complexity:
        ```lua
        -- Medium: Escape multiple identifiers
        local function buildSelectQuery(tableName, columns)
    4    local escapedTable = lia.db.escapeIdentifier(tableName)
    4    local escapedColumns = {}

    4    for _, column in ipairs(columns) do
        4    table.insert(escapedColumns, lia.db.escapeIdentifier(column))
    4    end

    4    return "SELECT " .. table.concat(escapedColumns, ", ") .. " FROM " .. escapedTable
        end
        ```

        High Complexity:
        ```lua
        -- High: Escape with validation and error handling
        local function safeEscapeIdentifiers(identifiers)
    4    local escaped = {}
    4    for _, id in ipairs(identifiers) do
        4    if type(id) == "string" and id:match("^[a-zA-Z_][a-zA-Z0-9_]*$") then
            4    table.insert(escaped, lia.db.escapeIdentifier(id))
            4    else
                4    lia.log.add("Invalid identifier: " .. tostring(id))
                4    return nil
            4    end
        4    end
        4    return escaped
    4    end
        ```
]]
function lia.db.escapeIdentifier(id)
    return "`" .. tostring(id):gsub("`", "``") .. "`"
end

--[[
    Purpose:
        Inserts a new record or updates an existing one based on primary key conflicts

    When Called:
        When synchronizing data that may already exist, like configuration updates or data imports

    Parameters:
        - value (table): Key-value pairs representing the data to upsert
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'characters')

    Returns:
        Deferred promise object with results and lastID

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Upsert configuration
        lia.db.upsert({
        schema = "default",
        key = "serverName",
        value = "My Server"
        }, "config"):next(function(results, lastID)
        print("Configuration upserted")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Upsert with validation and logging
        local function syncPlayerData(player)
    4    local playerData = {
    4    steamID = player:SteamID(),
    4    steamName = player:Name(),
    4    lastJoin = os.date("%Y-%m-%d %H:%M:%S"),
    4    userGroup = player:GetUserGroup()
    4    }

    4    return lia.db.upsert(playerData, "players"):next(function(results, lastID)
    4    lia.log.add("Player data synchronized: " .. player:Name())
    4    hook.Run("OnPlayerDataSynced", player, lastID)
        end):catch(function(err)
        lia.error("Failed to sync player data: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Upsert with conflict resolution and validation
        local function upsertWithValidation(data, dbTable, validationRules)
    4    local validation = validateData(data, validationRules)
    4    if not validation.valid then
        4    return deferred.new():reject("Validation failed: " .. validation.error)
    4    end

    4    return lia.db.upsert(data, dbTable):next(function(results, lastID)
    4    local action = lastID and "inserted" or "updated"
    4    lia.log.add("Record " .. action .. " in " .. dbTable)

    4    -- Update cache if applicable
    4    if lia.char.cache and dbTable == "characters" then
        4    lia.char.cache[data.id or lastID] = data
    4    end

    4    hook.Run("OnRecordUpserted", dbTable, data, action)
    4    return {success = true, action = action, id = lastID}
        end):catch(function(err)
        lia.error("Upsert failed: " .. tostring(err))
        return {success = false, error = err}
        end)
        end
        ```
]]
function lia.db.upsert(value, dbTable)
    local query = "INSERT OR REPLACE INTO " .. genInsertValues(value, dbTable)
    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        d:resolve({
    4    results = results,
    4    lastID = lastID
        })
    end)
    return d
end

--[[
    Purpose:
        Deletes records from a database table based on specified conditions

    When Called:
        When removing data like deleted characters, expired items, or cleanup operations

    Parameters:
        - dbTable (string, optional): Table name without 'lia_' prefix (defaults to 'character')
        - condition (table/string, optional): WHERE clause conditions for the deletion

    Returns:
        Deferred promise object with results and lastID

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Delete character by ID
        lia.db.delete("characters", {id = 1}):next(function(results, lastID)
        print("Character deleted")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Delete with validation and logging
        local function deleteCharacter(charID)
    4    return lia.db.delete("characters", {id = charID}):next(function(results, lastID)
    4    lia.log.add("Character " .. charID .. " deleted")
    4    hook.Run("OnCharacterDeleted", charID)

    4    -- Clean up related data
    4    lia.db.delete("items", {invID = charID})
    4    lia.db.delete("inventories", {charID = charID})
        end):catch(function(err)
        lia.error("Failed to delete character: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Delete with cascade and transaction safety
        local function deleteCharacterWithCascade(charID)
    4    return lia.db.transaction({
    4    "DELETE FROM lia_items WHERE invID IN (SELECT invID FROM lia_inventories WHERE charID = " .. charID .. ")",
    4    "DELETE FROM lia_inventories WHERE charID = " .. charID,
    4    "DELETE FROM lia_chardata WHERE charID = " .. charID,
    4    "DELETE FROM lia_characters WHERE id = " .. charID
    4    }):next(function()
    4    lia.log.add("Character " .. charID .. " and all related data deleted")

    4    -- Update cache
    4    if lia.char.cache then
        4    lia.char.cache[charID] = nil
    4    end

    4    hook.Run("OnCharacterDeleted", charID)
    4    return {success = true, charID = charID}
        end):catch(function(err)
        lia.error("Failed to delete character with cascade: " .. tostring(err))
        return {success = false, error = err}
        end)
        end
        ```
]]
function lia.db.delete(dbTable, condition)
    dbTable = "lia_" .. (dbTable or "character")
    local query = "DELETE FROM " .. dbTable .. buildWhereClause(condition)
    local d = deferred.new()
    lia.db.query(query, function(results, lastID)
        d:resolve({
    4    results = results,
    4    lastID = lastID
        })
    end)
    return d
end

--[[
    Purpose:
        Creates a new database table with specified schema and primary key

    When Called:
        When setting up custom tables for modules or extending the database schema

    Parameters:
        - dbName (string): Table name without 'lia_' prefix
        - primaryKey (string, optional): Primary key column name
        - schema (table): Array of column definitions with name, type, not_null, and default properties

    Returns:
        Deferred promise object resolving to true on success

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Create a basic table
        lia.db.createTable("custom_data", "id", {
        {name = "id", type = "INTEGER", not_null = true},
        {name = "data", type = "TEXT"}
        }):next(function(success)
        print("Table created successfully")
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Create table with validation
        local function createPlayerStatsTable()
    4    local schema = {
    4    {name = "id", type = "INTEGER", not_null = true},
    4    {name = "steamID", type = "VARCHAR(255)", not_null = true},
    4    {name = "kills", type = "INTEGER", default = 0},
    4    {name = "deaths", type = "INTEGER", default = 0},
    4    {name = "score", type = "INTEGER", default = 0},
    4    {name = "lastUpdated", type = "DATETIME", default = "CURRENT_TIMESTAMP"}
    4    }

    4    return lia.db.createTable("player_stats", "id", schema):next(function(success)
    4    if success then
        4    lia.log.add("Player stats table created")
        4    hook.Run("OnPlayerStatsTableCreated")
    4    end
        end):catch(function(err)
        lia.error("Failed to create player stats table: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Create table with validation and error handling
        local function createModuleTable(moduleName, tableConfig)
    4    local function validateSchema(schema)
        4    for _, column in ipairs(schema) do
            4    if not column.name or not column.type then
                4    return false, "Invalid column definition"
            4    end
        4    end
        4    return true
    4    end

    4    local valid, error = validateSchema(tableConfig.schema)
    4    if not valid then
        4    return deferred.new():reject("Schema validation failed: " .. error)
    4    end

    4    return lia.db.tableExists("lia_" .. moduleName .. "_" .. tableConfig.name):next(function(exists)
    4    if exists then
        4    lia.log.add("Table already exists: " .. moduleName .. "_" .. tableConfig.name)
        4    return true
    4    end

    4    return lia.db.createTable(moduleName .. "_" .. tableConfig.name,
    4    tableConfig.primaryKey, tableConfig.schema):next(function(success)
    4    if success then
        4    lia.log.add("Module table created: " .. moduleName .. "_" .. tableConfig.name)
        4    hook.Run("OnModuleTableCreated", moduleName, tableConfig.name)
    4    end
    4    return success
        end)
        end)
        end
        ```
]]
function lia.db.createTable(dbName, primaryKey, schema)
    local d = deferred.new()
    local tableName = "lia_" .. dbName
    local columns = {}
    for _, column in ipairs(schema) do
        local colDef = lia.db.escapeIdentifier(column.name)
        colDef = colDef .. " " .. column.type:upper()
        if column.not_null then colDef = colDef .. " NOT NULL" end
        if column.default ~= nil then
    4    if column.type == "string" or column.type == "text" then
        4    colDef = colDef .. " DEFAULT '" .. lia.db.escape(tostring(column.default)) .. "'"
    4    elseif column.type == "boolean" then
        4    colDef = colDef .. " DEFAULT " .. (column.default and "1" or "0")
    4    else
        4    colDef = colDef .. " DEFAULT " .. tostring(column.default)
    4    end
        end

        table.insert(columns, colDef)
    end

    if primaryKey then table.insert(columns, "PRIMARY KEY (" .. lia.db.escapeIdentifier(primaryKey) .. ")") end
    local query = "CREATE TABLE IF NOT EXISTS " .. tableName .. " (" .. table.concat(columns, ", ") .. ")"
    lia.db.query(query, function() d:resolve(true) end, function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Adds a new column to an existing database table

    When Called:
        When extending table schemas, adding new fields, or during database migrations

    Parameters:
        - tableName (string): Table name without 'lia_' prefix
        - columnName (string): Name of the new column to add
        - columnType (string): SQL data type for the column
        - defaultValue (any, optional): Default value for the column

    Returns:
        Deferred promise object resolving to true on success, false if column already exists

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Add a new column
        lia.db.createColumn("characters", "level", "INTEGER", 1):next(function(success)
        if success then
    4    print("Level column added")
    4    else
        4    print("Column already exists")
    4    end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Add column with validation
        local function addPlayerStatsColumn()
    4    return lia.db.createColumn("players", "totalPlayTime", "FLOAT", 0):next(function(success)
    4    if success then
        4    lia.log.add("Added totalPlayTime column to players table")
        4    hook.Run("OnColumnAdded", "players", "totalPlayTime")
        4    else
            4    lia.log.add("totalPlayTime column already exists")
        4    end
    4    end):catch(function(err)
    4    lia.error("Failed to add column: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Add column with validation and error handling
        local function migrateCharacterTable()
    4    local newColumns = {
    4    {name = "level", type = "INTEGER", default = 1},
    4    {name = "experience", type = "INTEGER", default = 0},
    4    {name = "lastLevelUp", type = "DATETIME", default = "CURRENT_TIMESTAMP"}
    4    }

    4    local function addNextColumn(index)
        4    if index > #newColumns then
            4    lia.log.add("Character table migration completed")
            4    return deferred.new():resolve()
        4    end

        4    local column = newColumns[index]
        4    return lia.db.createColumn("characters", column.name, column.type, column.default):next(function(success)
        4    if success then
            4    lia.log.add("Added column: " .. column.name)
        4    end
        4    return addNextColumn(index + 1)
    4    end):catch(function(err)
    4    lia.error("Failed to add column " .. column.name .. ": " .. tostring(err))
    4    return addNextColumn(index + 1)
        end)
        end

        return addNextColumn(1)
        end
        ```
]]
function lia.db.createColumn(tableName, columnName, columnType, defaultValue)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.fieldExists(fullTableName, columnName):next(function(exists)
        if exists then
    4    d:resolve(false)
    4    return
        end

        local colDef = lia.db.escapeIdentifier(columnName)
        colDef = colDef .. " " .. columnType:upper()
        if defaultValue ~= nil then
    4    if columnType == "string" or columnType == "text" then
        4    colDef = colDef .. " DEFAULT '" .. lia.db.escape(tostring(defaultValue)) .. "'"
    4    elseif columnType == "boolean" then
        4    colDef = colDef .. " DEFAULT " .. (defaultValue and "1" or "0")
    4    else
        4    colDef = colDef .. " DEFAULT " .. tostring(defaultValue)
    4    end
        end

        local query = "ALTER TABLE " .. fullTableName .. " ADD COLUMN " .. colDef
        lia.db.query(query, function() d:resolve(true) end, function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Removes a database table and all its data from the database

    When Called:
        When cleaning up unused tables, removing modules, or during database maintenance

    Parameters:
        - tableName (string): Table name without 'lia_' prefix

    Returns:
        Deferred promise object resolving to true on success, false if table doesn't exist

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Remove a table
        lia.db.removeTable("old_data"):next(function(success)
        if success then
    4    print("Table removed")
    4    else
        4    print("Table doesn't exist")
    4    end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Remove table with validation
        local function cleanupOldModule(moduleName)
    4    return lia.db.removeTable(moduleName .. "_data"):next(function(success)
    4    if success then
        4    lia.log.add("Removed table for module: " .. moduleName)
        4    hook.Run("OnModuleTableRemoved", moduleName)
        4    else
            4    lia.log.add("Table for module " .. moduleName .. " doesn't exist")
        4    end
    4    end):catch(function(err)
    4    lia.error("Failed to remove table: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Remove table with backup and validation
        local function removeTableWithBackup(tableName)
    4    return lia.db.tableExists("lia_" .. tableName):next(function(exists)
    4    if not exists then
        4    lia.log.add("Table " .. tableName .. " doesn't exist")
        4    return false
    4    end

    4    -- Create backup before removal
    4    return lia.db.createSnapshot(tableName):next(function(snapshot)
    4    lia.log.add("Created backup: " .. snapshot.file)

    4    return lia.db.removeTable(tableName):next(function(success)
    4    if success then
        4    lia.log.add("Table " .. tableName .. " removed successfully")
        4    hook.Run("OnTableRemoved", tableName, snapshot)
    4    end
    4    return success
        end)
        end):catch(function(err)
        lia.error("Failed to backup table " .. tableName .. ": " .. tostring(err))
        return false
        end)
        end)
        end
        ```
]]
function lia.db.removeTable(tableName)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(exists)
        if not exists then
    4    d:resolve(false)
    4    return
        end

        local query = "DROP TABLE " .. fullTableName
        lia.db.query(query, function() d:resolve(true) end, function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Removes a column from an existing database table using table recreation

    When Called:
        When removing unused columns, cleaning up schemas, or during database migrations

    Parameters:
        - tableName (string): Table name without 'lia_' prefix
        - columnName (string): Name of the column to remove

    Returns:
        Deferred promise object resolving to true on success, false if column doesn't exist

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Remove a column
        lia.db.removeColumn("characters", "old_field"):next(function(success)
        if success then
    4    print("Column removed")
    4    else
        4    print("Column doesn't exist")
    4    end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Remove column with validation
        local function cleanupOldColumn(tableName, columnName)
    4    return lia.db.removeColumn(tableName, columnName):next(function(success)
    4    if success then
        4    lia.log.add("Removed column " .. columnName .. " from " .. tableName)
        4    hook.Run("OnColumnRemoved", tableName, columnName)
        4    else
            4    lia.log.add("Column " .. columnName .. " doesn't exist in " .. tableName)
        4    end
    4    end):catch(function(err)
    4    lia.error("Failed to remove column: " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Remove column with backup and validation
        local function removeColumnWithBackup(tableName, columnName)
    4    return lia.db.tableExists("lia_" .. tableName):next(function(tableExists)
    4    if not tableExists then
        4    lia.error("Table " .. tableName .. " doesn't exist")
        4    return false
    4    end

    4    return lia.db.fieldExists("lia_" .. tableName, columnName):next(function(columnExists)
    4    if not columnExists then
        4    lia.log.add("Column " .. columnName .. " doesn't exist")
        4    return false
    4    end

    4    -- Create backup before removal
    4    return lia.db.createSnapshot(tableName):next(function(snapshot)
    4    lia.log.add("Created backup before column removal: " .. snapshot.file)

    4    return lia.db.removeColumn(tableName, columnName):next(function(success)
    4    if success then
        4    lia.log.add("Column " .. columnName .. " removed from " .. tableName)
        4    hook.Run("OnColumnRemoved", tableName, columnName, snapshot)
    4    end
    4    return success
        end)
        end):catch(function(err)
        lia.error("Failed to backup table before column removal: " .. tostring(err))
        return false
        end)
        end)
        end)
        end
        ```
]]
function lia.db.removeColumn(tableName, columnName)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(tableExists)
        if not tableExists then
    4    d:resolve(false)
    4    return
        end

        lia.db.fieldExists(fullTableName, columnName):next(function(columnExists)
    4    if not columnExists then
        4    d:resolve(false)
        4    return
    4    end

    4    lia.db.query("PRAGMA table_info(" .. fullTableName .. ")", function(columns)
        4    if not columns then
            4    d:reject(L("failedToGetTableInfo"))
            4    return
        4    end

        4    local newColumns = {}
        4    for _, col in ipairs(columns) do
            4    if col.name ~= columnName then
                4    local colDef = col.name .. " " .. col.type
                4    if col.notnull == 1 then colDef = colDef .. " NOT NULL" end
                4    if col.dflt_value then colDef = colDef .. " DEFAULT " .. col.dflt_value end
                4    if col.pk == 1 then colDef = colDef .. " PRIMARY KEY" end
                4    table.insert(newColumns, colDef)
            4    end
        4    end

        4    if #newColumns == 0 then
            4    d:reject(L("cannotRemoveLastColumnFromTable"))
            4    return
        4    end

        4    local tempTableName = fullTableName .. "_temp_" .. os.time()
        4    local createTempQuery = "CREATE TABLE " .. tempTableName .. " (" .. table.concat(newColumns, ", ") .. ")"
        4    local insertQuery = "INSERT INTO " .. tempTableName .. " SELECT " .. table.concat(newColumns, ", ") .. " FROM " .. fullTableName
        4    local dropOldQuery = "DROP TABLE " .. fullTableName
        4    local renameQuery = "ALTER TABLE " .. tempTableName .. " RENAME TO " .. fullTableName
        4    lia.db.transaction({createTempQuery, insertQuery, dropOldQuery, renameQuery}):next(function() d:resolve(true) end):catch(function(err) d:reject(err) end)
    4    end, function(err) d:reject(err) end)
        end):catch(function(err) d:reject(err) end)
    end):catch(function(err) d:reject(err) end)
    return d
end

--[[
    Purpose:
        Retrieves the column information for the lia_characters table

    When Called:
        When analyzing character table structure, generating reports, or during schema validation

    Parameters:
        - callback (function): Function to call with the column information array

    Returns:
        None

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Get character table columns
        lia.db.getCharacterTable(function(columns)
        print("Character table has " .. #columns .. " columns")
        for _, column in ipairs(columns) do
    4    print("- " .. column)
        end
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Get columns with analysis
        local function analyzeCharacterTable()
    4    lia.db.getCharacterTable(function(columns)
    4    local requiredColumns = {"id", "steamID", "name", "model", "faction", "money"}
    4    local missingColumns = {}

    4    for _, required in ipairs(requiredColumns) do
        4    if not table.HasValue(columns, required) then
            4    table.insert(missingColumns, required)
        4    end
    4    end

    4    if #missingColumns > 0 then
        4    lia.log.add("Missing character columns: " .. table.concat(missingColumns, ", "))
        4    else
            4    lia.log.add("All required character columns present")
        4    end
    4    end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Get columns with validation and error handling
        local function validateCharacterSchema()
    4    return lia.db.waitForTablesToLoad():next(function()
    4    lia.db.getCharacterTable(function(columns)
    4    if not columns or #columns == 0 then
        4    lia.error("Failed to get character table columns")
        4    return
    4    end

    4    local schemaValidation = {
    4    required = {"id", "steamID", "name", "model", "faction", "money"},
    4    optional = {"desc", "attribs", "schema", "createTime", "lastJoinTime", "recognition", "fakenames"}
    4    }

    4    local validationResults = {
    4    valid = true,
    4    missing = {},
    4    extra = {}
    4    }

    4    -- Check for missing required columns
    4    for _, required in ipairs(schemaValidation.required) do
        4    if not table.HasValue(columns, required) then
            4    table.insert(validationResults.missing, required)
            4    validationResults.valid = false
        4    end
    4    end

    4    -- Check for extra columns
    4    for _, column in ipairs(columns) do
        4    if not table.HasValue(schemaValidation.required, column) and
        4    not table.HasValue(schemaValidation.optional, column) then
        4    table.insert(validationResults.extra, column)
    4    end
        end

        if validationResults.valid then
    4    lia.log.add("Character table schema validation passed")
    4    else
        4    lia.log.add("Character table schema issues found")
        4    if #validationResults.missing > 0 then
            4    lia.log.add("Missing columns: " .. table.concat(validationResults.missing, ", "))
        4    end
        4    if #validationResults.extra > 0 then
            4    lia.log.add("Extra columns: " .. table.concat(validationResults.extra, ", "))
        4    end
    4    end

    4    hook.Run("OnCharacterSchemaValidated", validationResults)
        end)
        end):catch(function(err)
        lia.error("Character schema validation failed: " .. tostring(err))
        end)
        end
        ```
]]
function lia.db.getCharacterTable(callback)
    local query = "PRAGMA table_info(lia_characters)"
    lia.db.query(query, function(results)
        if not results or #results == 0 then return callback({}) end
        local columns = {}
        for _, row in ipairs(results) do
    4    table.insert(columns, row.name)
        end

        callback(columns)
    end)
end

--[[
    Purpose:
        Creates a backup snapshot of a database table and saves it to a JSON file

    When Called:
        When backing up data before major operations, creating restore points, or archiving data

    Parameters:
        - tableName (string): Table name without 'lia_' prefix

    Returns:
        Deferred promise object resolving to snapshot information (file, path, records)

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Create a snapshot
        lia.db.createSnapshot("characters"):next(function(snapshot)
        print("Snapshot created: " .. snapshot.file)
        print("Records backed up: " .. snapshot.records)
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Create snapshot with validation
        local function backupTable(tableName)
    4    return lia.db.createSnapshot(tableName):next(function(snapshot)
    4    lia.log.add("Backup created: " .. snapshot.file .. " (" .. snapshot.records .. " records)")
    4    hook.Run("OnTableBackedUp", tableName, snapshot)
    4    return snapshot
        end):catch(function(err)
        lia.error("Failed to backup table " .. tableName .. ": " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Create snapshot with validation and error handling
        local function createBackupWithValidation(tableName)
    4    return lia.db.tableExists("lia_" .. tableName):next(function(exists)
    4    if not exists then
        4    return deferred.new():reject("Table " .. tableName .. " doesn't exist")
    4    end

    4    return lia.db.createSnapshot(tableName):next(function(snapshot)
    4    -- Validate snapshot data
    4    if snapshot.records == 0 then
        4    lia.log.add("Snapshot created but table is empty")
    4    end

    4    -- Create backup metadata
    4    local metadata = {
    4    table = tableName,
    4    timestamp = snapshot.timestamp,
    4    records = snapshot.records,
    4    file = snapshot.file,
    4    path = snapshot.path,
    4    server = GetHostName(),
    4    version = lia.version or "unknown"
    4    }

    4    -- Save metadata
    4    local metadataFile = "lilia/snapshots/" .. snapshot.file .. ".meta"
    4    file.Write(metadataFile, util.TableToJSON(metadata, true))

    4    lia.log.add("Backup completed: " .. snapshot.file .. " (" .. snapshot.records .. " records)")
    4    hook.Run("OnBackupCreated", metadata)
    4    return metadata
        end):catch(function(err)
        lia.error("Backup failed for " .. tableName .. ": " .. tostring(err))
        return {success = false, error = err}
        end)
        end)
        end
        ```
]]
function lia.db.createSnapshot(tableName)
    local d = deferred.new()
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(exists)
        if not exists then
    4    d:reject("Table " .. fullTableName .. " does not exist")
    4    return
        end

        lia.db.query("SELECT * FROM " .. fullTableName, function(results)
    4    if not results then
        4    d:reject("Failed to query table " .. fullTableName)
        4    return
    4    end

    4    local snapshot = {
        4    table = tableName,
        4    timestamp = os.time(),
        4    data = results
    4    }

    4    local jsonData = util.TableToJSON(snapshot, true)
    4    local fileName = "snapshot_" .. tableName .. "_" .. os.time() .. ".json"
    4    local filePath = "lilia/snapshots/" .. fileName
    4    file.CreateDir("lilia/snapshots")
    4    file.Write(filePath, jsonData)
    4    d:resolve({
        4    file = fileName,
        4    path = filePath,
        4    records = #results
    4    })
        end, function(err) d:reject(L("databaseError") .. " " .. tostring(err)) end)
    end, function(err) d:reject(L("tableCheckError") .. " " .. tostring(err)) end)
    return d
end

--[[
    Purpose:
        Restores a database table from a previously created snapshot file

    When Called:
        When restoring data from backups, recovering from errors, or migrating data

    Parameters:
        - fileName (string): Name of the snapshot file to load

    Returns:
        Deferred promise object resolving to restore information (table, records, timestamp)

    Realm:
        Server

    Example Usage:
        Low Complexity:
        ```lua
        -- Simple: Load a snapshot
        lia.db.loadSnapshot("snapshot_characters_1234567890.json"):next(function(result)
        print("Restored " .. result.records .. " records to " .. result.table)
        end)
        ```

        Medium Complexity:
        ```lua
        -- Medium: Load snapshot with validation
        local function restoreTable(fileName)
    4    return lia.db.loadSnapshot(fileName):next(function(result)
    4    lia.log.add("Restored " .. result.records .. " records to " .. result.table)
    4    hook.Run("OnTableRestored", result.table, result.records)
    4    return result
        end):catch(function(err)
        lia.error("Failed to restore from " .. fileName .. ": " .. tostring(err))
        end)
        end
        ```

        High Complexity:
        ```lua
        -- High: Load snapshot with validation and error handling
        local function restoreWithValidation(fileName)
    4    return lia.db.loadSnapshot(fileName):next(function(result)
    4    -- Validate restore results
    4    if result.records == 0 then
        4    lia.log.add("Restore completed but no records were loaded")
    4    end

    4    -- Verify table exists and has data
    4    return lia.db.count(result.table):next(function(count)
    4    if count ~= result.records then
        4    lia.log.add("Record count mismatch: expected " .. result.records .. ", got " .. count)
    4    end

    4    -- Create restore log entry
    4    local restoreLog = {
    4    fileName = fileName,
    4    table = result.table,
    4    records = result.records,
    4    timestamp = result.timestamp,
    4    restoredAt = os.time(),
    4    success = true
    4    }

    4    lia.log.add("Restore completed successfully: " .. fileName)
    4    hook.Run("OnRestoreCompleted", restoreLog)
    4    return restoreLog
        end)
        end):catch(function(err)
        lia.error("Restore failed: " .. tostring(err))

        -- Log failed restore attempt
        local failedLog = {
        fileName = fileName,
        error = tostring(err),
        failedAt = os.time(),
        success = false
        }

        hook.Run("OnRestoreFailed", failedLog)
        return failedLog
        end)
        end
        ```
]]
function lia.db.loadSnapshot(fileName)
    local d = deferred.new()
    local filePath = "lilia/snapshots/" .. fileName
    if not file.Exists(filePath, "DATA") then
        d:reject(L("snapshotFileNotFound") .. " " .. fileName .. " " .. L("notFound"))
        return d
    end

    local jsonData = file.Read(filePath, "DATA")
    if not jsonData then
        d:reject("Failed to read snapshot file")
        return d
    end

    local success, snapshot = pcall(util.JSONToTable, jsonData)
    if not success then
        d:reject(L("failedParseJSONData", tostring(snapshot)))
        return d
    end

    if not snapshot.table or not snapshot.data then
        d:reject("Invalid snapshot format")
        return d
    end

    local fullTableName = "lia_" .. snapshot.table
    lia.db.tableExists(fullTableName):next(function(exists)
        if not exists then
    4    d:reject("Target table " .. fullTableName .. " does not exist")
    4    return
        end

        lia.db.query("DELETE FROM " .. fullTableName, function()
    4    if #snapshot.data == 0 then
        4    d:resolve({
            4    table = snapshot.table,
            4    records = 0
        4    })
        4    return
    4    end

    4    local batchSize = 100
    4    local batches = {}
    4    for i = 1, #snapshot.data, batchSize do
        4    local batch = {}
        4    for j = i, math.min(i + batchSize - 1, #snapshot.data) do
            4    table.insert(batch, snapshot.data[j])
        4    end

        4    table.insert(batches, batch)
    4    end

    4    local currentBatch = 1
    4    local function insertNextBatch()
        4    if currentBatch > #batches then
            4    d:resolve({
                4    table = snapshot.table,
                4    records = #snapshot.data,
                4    timestamp = snapshot.timestamp
            4    })
            4    return
        4    end

        4    lia.db.bulkInsert(snapshot.table, batches[currentBatch]):next(function()
            4    currentBatch = currentBatch + 1
            4    insertNextBatch()
        4    end, function(err) d:reject("Failed to insert batch " .. currentBatch .. ": " .. tostring(err)) end)
    4    end

    4    insertNextBatch()
        end, function(err) d:reject(L("failedToClearTable") .. " " .. tostring(err)) end)
    end, function(err) d:reject(L("tableCheckError") .. " " .. tostring(err)) end)
    return d
end

function GM:RegisterPreparedStatements()
    lia.bootstrap(L("database"), L("preparedStatementsAdded"))
end

function GM:SetupDatabase()
    local databasePath = engine.ActiveGamemode() .. "/schema/database.lua"
    local databaseOverrideExists = file.Exists(databasePath, "LUA")
    if databaseOverrideExists then
        local databaseConfig = include(databasePath)
        if databaseConfig then
    4    lia.db.config = databaseConfig
    4    for k, v in pairs(databaseConfig) do
        4    lia.db[k] = v
    4    end
        end
    end

    if not lia.db.config then
        for k, v in pairs({
    4    module = "sqlite",
    4    hostname = "127.0.0.1",
    4    username = "",
    4    password = "",
    4    database = "",
    4    port = 3306,
        }) do
    4    lia.db[k] = v
        end
    end
end

function GM:DatabaseConnected()
    lia.bootstrap(L("database"), L("databaseConnected", lia.db.module))
end
