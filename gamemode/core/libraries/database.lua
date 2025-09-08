lia.db = lia.db or {}
lia.db.queryQueue = {}
lia.db.prepared = lia.db.prepared or {}
lia.db.cache = lia.db.cache or {
    enabled = true,
    ttl = 5,
    store = {},
    index = {}
}

local function cacheNow()
    return (CurTime and CurTime()) or os.time()
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
                if not err or not isstring(err) then return end
                if string.find(err, "duplicate column name:") or string.find(err, "UNIQUE constraint failed: lia_config") then return end
                local dbLabel = L("database") or "Database"
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. dbLabel .. "]", Color(255, 255, 255), " * " .. (query or "Unknown query") .. "\n")
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. dbLabel .. "]", Color(255, 255, 255), " " .. err .. "\n")
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

local sqliteQuery = promisifyIfNoCallback(function(query, callback, throw)
    local data = sql.Query(query)
    local err = sql.LastError()
    if data == false then throw(err) end
    if callback then
        local lastID = nil
        if string.find(string.upper(query), "INSERT") then lastID = tonumber(sql.QueryValue("SELECT last_insert_rowid()")) end
        callback(data, lastID)
    end
end)

function sqliteEscape(value)
    return sql.SQLStr(value, true)
end

lia.db.escape = sqliteEscape
lia.db.query = function(...) lia.db.queryQueue[#lia.db.queryQueue + 1] = {...} end
function lia.db.connect(connectCallback, reconnect)
    if reconnect or not lia.db.connected then
        lia.db.connected = true
        if lia.db.cacheClear then lia.db.cacheClear() end
        if isfunction(connectCallback) then connectCallback() end
        for i = 1, #lia.db.queryQueue do
            lia.db.query(unpack(lia.db.queryQueue[i]))
        end

        lia.db.queryQueue = {}
    end

    lia.db.query = function(query, queryCallback, onError)
        query = lia.db.normalizeSQLIdentifiers(query)
        return sqliteQuery(query, queryCallback, onError)
    end
end

function lia.db.wipeTables(callback)
    local wipedTables = {}
    local function realCallback()
        if lia.db.cacheClear then lia.db.cacheClear() end
        local dbLabel = L("database") or "Database"
        local dataWipedMsg = L("dataWiped") or "Data wiped"
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[" .. dbLabel .. "]", Color(255, 255, 255), dataWipedMsg .. "\n")
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
        lia.db.migrateDatabaseSchemas():next(function()
            lia.db.tablesLoaded = true
            hook.Run("LiliaTablesLoaded")
            hook.Run("OnDatabaseLoaded")
        end):catch(function(err)
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Schema migration failed, but continuing with database load: " .. tostring(err) .. "\n")
            lia.db.tablesLoaded = true
            hook.Run("LiliaTablesLoaded")
            hook.Run("OnDatabaseLoaded")
        end)
    end

    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Creating database tables using advanced schema tools...\n")
    lia.db.createTable("players", nil, {
        {
            name = "steamID",
            type = "string"
        },
        {
            name = "steamName",
            type = "string"
        },
        {
            name = "firstJoin",
            type = "datetime"
        },
        {
            name = "lastJoin",
            type = "datetime"
        },
        {
            name = "userGroup",
            type = "string"
        },
        {
            name = "data",
            type = "text"
        },
        {
            name = "lastIP",
            type = "string"
        },
        {
            name = "lastOnline",
            type = "integer"
        },
        {
            name = "totalOnlineTime",
            type = "float"
        }
    }):next(function()
        return lia.db.createTable("chardata", {"charID", "key"}, {
            {
                name = "charID",
                type = "integer",
                not_null = true
            },
            {
                name = "key",
                type = "string",
                not_null = true
            },
            {
                name = "value",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("characters", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "steamID",
                type = "string"
            },
            {
                name = "schema",
                type = "string"
            },
            {
                name = "createTime",
                type = "datetime"
            },
            {
                name = "lastJoinTime",
                type = "datetime"
            }
        })
    end):next(function(result)
        return lia.db.createTable("inventories", "invID", {
            {
                name = "invID",
                type = "integer",
                auto_increment = true
            },
            {
                name = "charID",
                type = "integer"
            },
            {
                name = "invType",
                type = "string"
            }
        })
    end):next(function(result)
        return lia.db.createTable("items", "itemID", {
            {
                name = "itemID",
                type = "integer",
                auto_increment = true
            },
            {
                name = "invID",
                type = "integer"
            },
            {
                name = "uniqueID",
                type = "string"
            },
            {
                name = "data",
                type = "text"
            },
            {
                name = "quantity",
                type = "integer"
            },
            {
                name = "x",
                type = "integer"
            },
            {
                name = "y",
                type = "integer"
            }
        })
    end):next(function(result)
        return lia.db.createTable("invdata", {"invID", "key"}, {
            {
                name = "invID",
                type = "integer",
                not_null = true
            },
            {
                name = "key",
                type = "text",
                not_null = true
            },
            {
                name = "value",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("config", {"schema", "key"}, {
            {
                name = "schema",
                type = "text",
                not_null = true
            },
            {
                name = "key",
                type = "text",
                not_null = true
            },
            {
                name = "value",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("logs", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "timestamp",
                type = "datetime"
            },
            {
                name = "gamemode",
                type = "string"
            },
            {
                name = "category",
                type = "string"
            },
            {
                name = "message",
                type = "text"
            },
            {
                name = "charID",
                type = "integer"
            },
            {
                name = "steamID",
                type = "string"
            }
        })
    end):next(function(result)
        return lia.db.createTable("ticketclaims", nil, {
            {
                name = "timestamp",
                type = "datetime"
            },
            {
                name = "requester",
                type = "text"
            },
            {
                name = "requesterSteamID",
                type = "text"
            },
            {
                name = "admin",
                type = "text"
            },
            {
                name = "adminSteamID",
                type = "text"
            },
            {
                name = "message",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("warnings", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "charID",
                type = "integer"
            },
            {
                name = "warned",
                type = "text"
            },
            {
                name = "warnedSteamID",
                type = "text"
            },
            {
                name = "timestamp",
                type = "datetime"
            },
            {
                name = "message",
                type = "text"
            },
            {
                name = "warner",
                type = "text"
            },
            {
                name = "warnerSteamID",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("permakills", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "player",
                type = "string",
                not_null = true
            },
            {
                name = "reason",
                type = "string"
            },
            {
                name = "steamID",
                type = "string"
            },
            {
                name = "charID",
                type = "integer"
            },
            {
                name = "submitterName",
                type = "string"
            },
            {
                name = "submitterSteamID",
                type = "string"
            },
            {
                name = "timestamp",
                type = "integer"
            },
            {
                name = "evidence",
                type = "string"
            }
        })
    end):next(function(result)
        return lia.db.createTable("bans", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "player",
                type = "string",
                not_null = true
            },
            {
                name = "playerSteamID",
                type = "string"
            },
            {
                name = "reason",
                type = "string"
            },
            {
                name = "bannerName",
                type = "string"
            },
            {
                name = "bannerSteamID",
                type = "string"
            },
            {
                name = "timestamp",
                type = "integer"
            },
            {
                name = "evidence",
                type = "string"
            }
        })
    end):next(function(result)
        return lia.db.createTable("staffactions", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "player",
                type = "string",
                not_null = true
            },
            {
                name = "playerSteamID",
                type = "string"
            },
            {
                name = "steamID",
                type = "string"
            },
            {
                name = "action",
                type = "string"
            },
            {
                name = "staffName",
                type = "string"
            },
            {
                name = "staffSteamID",
                type = "string"
            },
            {
                name = "timestamp",
                type = "integer"
            }
        })
    end):next(function(result)
        return lia.db.createTable("doors", {"gamemode", "map", "id"}, {
            {
                name = "gamemode",
                type = "text",
                not_null = true
            },
            {
                name = "map",
                type = "text",
                not_null = true
            },
            {
                name = "id",
                type = "integer",
                not_null = true
            },
            {
                name = "factions",
                type = "text"
            },
            {
                name = "classes",
                type = "text"
            },
            {
                name = "disabled",
                type = "integer"
            },
            {
                name = "hidden",
                type = "integer"
            },
            {
                name = "ownable",
                type = "integer"
            },
            {
                name = "name",
                type = "text"
            },
            {
                name = "price",
                type = "integer"
            },
            {
                name = "locked",
                type = "integer"
            },
            {
                name = "children",
                type = "text"
            },
            {
                name = "door_group",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("persistence", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "gamemode",
                type = "text"
            },
            {
                name = "map",
                type = "text"
            },
            {
                name = "class",
                type = "text"
            },
            {
                name = "pos",
                type = "text"
            },
            {
                name = "angles",
                type = "text"
            },
            {
                name = "model",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("saveditems", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "schema",
                type = "text"
            },
            {
                name = "map",
                type = "text"
            },
            {
                name = "itemID",
                type = "integer"
            },
            {
                name = "pos",
                type = "text"
            },
            {
                name = "angles",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("admin", "usergroup", {
            {
                name = "usergroup",
                type = "text",
                not_null = true
            },
            {
                name = "privileges",
                type = "text"
            },
            {
                name = "inheritance",
                type = "text"
            },
            {
                name = "types",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("data", {"gamemode", "map"}, {
            {
                name = "gamemode",
                type = "text",
                not_null = true
            },
            {
                name = "map",
                type = "text",
                not_null = true
            },
            {
                name = "data",
                type = "text"
            }
        })
    end):next(function(result)
        return lia.db.createTable("vendor_presets", "id", {
            {
                name = "id",
                type = "integer",
                auto_increment = true
            },
            {
                name = "name",
                type = "text",
                not_null = true
            },
            {
                name = "data",
                type = "text"
            }
        })
    end):next(function() done() end):catch(function() done() end)

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
        lia.db.invalidateTable("lia_" .. (dbTable or "characters"))
    end

    lia.db.query(query, cb)
end

function lia.db.updateTable(value, callback, dbTable, condition)
    local query = "UPDATE " .. "lia_" .. (dbTable or "characters") .. " SET " .. genUpdateList(value) .. (condition and " WHERE " .. condition or "")
    local function cb(...)
        if callback then callback(...) end
        lia.db.invalidateTable("lia_" .. (dbTable or "characters"))
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

lia.db.expectedSchemas = {
    players = {
        steamID = {
            type = "string"
        },
        steamName = {
            type = "string"
        },
        firstJoin = {
            type = "datetime"
        },
        lastJoin = {
            type = "datetime"
        },
        userGroup = {
            type = "string"
        },
        data = {
            type = "text"
        },
        lastIP = {
            type = "string"
        },
        lastOnline = {
            type = "integer"
        },
        totalOnlineTime = {
            type = "float"
        }
    },
    chardata = {
        charID = {
            type = "integer",
            not_null = true
        },
        key = {
            type = "string",
            not_null = true
        },
        value = {
            type = "text"
        }
    },
    characters = {
        id = {
            type = "integer",
            auto_increment = true
        },
        steamID = {
            type = "string"
        },
        schema = {
            type = "string"
        },
        createTime = {
            type = "datetime"
        },
        lastJoinTime = {
            type = "datetime"
        }
    },
    inventories = {
        invID = {
            type = "integer",
            auto_increment = true
        },
        charID = {
            type = "integer"
        },
        invType = {
            type = "string"
        }
    },
    items = {
        itemID = {
            type = "integer",
            auto_increment = true
        },
        invID = {
            type = "integer"
        },
        uniqueID = {
            type = "string"
        },
        data = {
            type = "text"
        },
        quantity = {
            type = "integer"
        },
        x = {
            type = "integer"
        },
        y = {
            type = "integer"
        }
    },
    invdata = {
        invID = {
            type = "integer",
            not_null = true
        },
        key = {
            type = "text",
            not_null = true
        },
        value = {
            type = "text"
        }
    },
    config = {
        schema = {
            type = "text",
            not_null = true
        },
        key = {
            type = "text",
            not_null = true
        },
        value = {
            type = "text"
        }
    },
    logs = {
        id = {
            type = "integer",
            auto_increment = true
        },
        timestamp = {
            type = "datetime"
        },
        gamemode = {
            type = "string"
        },
        category = {
            type = "string"
        },
        message = {
            type = "text"
        },
        charID = {
            type = "integer"
        },
        steamID = {
            type = "string"
        }
    },
    ticketclaims = {
        timestamp = {
            type = "datetime"
        },
        requester = {
            type = "text"
        },
        requesterSteamID = {
            type = "text"
        },
        admin = {
            type = "text"
        },
        adminSteamID = {
            type = "text"
        },
        message = {
            type = "text"
        }
    },
    warnings = {
        id = {
            type = "integer",
            auto_increment = true
        },
        charID = {
            type = "integer"
        },
        warned = {
            type = "text"
        },
        warnedSteamID = {
            type = "text"
        },
        timestamp = {
            type = "datetime"
        },
        message = {
            type = "text"
        },
        warner = {
            type = "text"
        },
        warnerSteamID = {
            type = "text"
        }
    },
    permakills = {
        id = {
            type = "integer",
            auto_increment = true
        },
        player = {
            type = "string",
            not_null = true
        },
        reason = {
            type = "string"
        },
        steamID = {
            type = "string"
        },
        charID = {
            type = "integer"
        },
        submitterName = {
            type = "string"
        },
        submitterSteamID = {
            type = "string"
        },
        timestamp = {
            type = "integer"
        },
        evidence = {
            type = "string"
        }
    },
    bans = {
        id = {
            type = "integer",
            auto_increment = true
        },
        player = {
            type = "string",
            not_null = true
        },
        playerSteamID = {
            type = "string"
        },
        reason = {
            type = "string"
        },
        bannerName = {
            type = "string"
        },
        bannerSteamID = {
            type = "string"
        },
        timestamp = {
            type = "integer"
        },
        evidence = {
            type = "string"
        }
    },
    staffactions = {
        id = {
            type = "integer",
            auto_increment = true
        },
        player = {
            type = "string",
            not_null = true
        },
        playerSteamID = {
            type = "string"
        },
        steamID = {
            type = "string"
        },
        action = {
            type = "string"
        },
        staffName = {
            type = "string"
        },
        staffSteamID = {
            type = "string"
        },
        timestamp = {
            type = "integer"
        }
    },
    doors = {
        gamemode = {
            type = "text",
            not_null = true
        },
        map = {
            type = "text",
            not_null = true
        },
        id = {
            type = "integer",
            not_null = true
        },
        factions = {
            type = "text"
        },
        classes = {
            type = "text"
        },
        disabled = {
            type = "integer"
        },
        hidden = {
            type = "integer"
        },
        ownable = {
            type = "integer"
        },
        name = {
            type = "text"
        },
        price = {
            type = "integer"
        },
        locked = {
            type = "integer"
        },
        children = {
            type = "text"
        },
        door_group = {
            type = "text"
        }
    },
    persistence = {
        id = {
            type = "integer",
            auto_increment = true
        },
        gamemode = {
            type = "text"
        },
        map = {
            type = "text"
        },
        class = {
            type = "text"
        },
        pos = {
            type = "text"
        },
        angles = {
            type = "text"
        },
        model = {
            type = "text"
        }
    },
    saveditems = {
        id = {
            type = "integer",
            auto_increment = true
        },
        schema = {
            type = "text"
        },
        map = {
            type = "text"
        },
        itemID = {
            type = "integer"
        },
        pos = {
            type = "text"
        },
        angles = {
            type = "text"
        }
    },
    admin = {
        usergroup = {
            type = "text",
            not_null = true
        },
        privileges = {
            type = "text"
        },
        inheritance = {
            type = "text"
        },
        types = {
            type = "text"
        }
    },
    data = {
        gamemode = {
            type = "text",
            not_null = true
        },
        map = {
            type = "text",
            not_null = true
        },
        data = {
            type = "text"
        }
    },
    vendor_presets = {
        id = {
            type = "integer",
            auto_increment = true
        },
        name = {
            type = "text",
            not_null = true
        },
        data = {
            type = "text"
        }
    }
}

function lia.db.addExpectedSchema(tableName, schema)
    if not lia.db.expectedSchemas then lia.db.expectedSchemas = {} end
    lia.db.expectedSchemas[tableName] = schema
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added custom schema for table: " .. tableName .. "\n")
end

function lia.db.migrateDatabaseSchemas()
    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Checking database schema for missing columns...\n")
    local migrationPromises = {}
    for tableName, expectedColumns in pairs(lia.db.expectedSchemas) do
        local fullTableName = "lia_" .. tableName
        local promise = lia.db.tableExists(fullTableName):next(function(tableExists)
            if not tableExists then
                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Table '" .. fullTableName .. "' does not exist, skipping migration\n")
                return
            end
            return lia.db.query("PRAGMA table_info(" .. fullTableName .. ")"):next(function(columns)
                if not columns then
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get column info for '" .. fullTableName .. "'\n")
                    return
                end

                local existingColumns = {}
                for _, col in ipairs(columns) do
                    existingColumns[col.name] = {
                        type = string.lower(col.type),
                        notnull = col.notnull == 1,
                        pk = col.pk == 1
                    }
                end

                local missingColumns = {}
                for colName, colDef in pairs(expectedColumns) do
                    if not existingColumns[colName] then
                        table.insert(missingColumns, {
                            name = colName,
                            def = colDef
                        })
                    end
                end

                if #missingColumns > 0 then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Found " .. #missingColumns .. " missing column(s) in '" .. fullTableName .. "', adding them...\n")
                    local columnPromises = {}
                    for _, colInfo in ipairs(missingColumns) do
                        local colPromise = lia.db.createColumn(tableName, colInfo.name, colInfo.def.type, {
                            not_null = colInfo.def.not_null,
                            auto_increment = colInfo.def.auto_increment,
                            default = colInfo.def.default
                        }):next(function()
                            if result and result.success then
                                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Added column '" .. colInfo.name .. "' to '" .. fullTableName .. "'\n")
                            else
                                MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "⚠ Column '" .. colInfo.name .. "' may already exist in '" .. fullTableName .. "'\n")
                            end
                        end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "✗ Failed to add column '" .. colInfo.name .. "' to '" .. fullTableName .. "': " .. tostring(err) .. "\n") end)

                        table.insert(columnPromises, colPromise)
                    end
                    return deferred.all(columnPromises)
                else
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "✓ Table '" .. fullTableName .. "' schema is up to date\n")
                end
            end)
        end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to check table '" .. fullTableName .. "': " .. tostring(err) .. "\n") end)

        table.insert(migrationPromises, promise)
    end
    return deferred.all(migrationPromises):next(function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Database schema migration completed\n") end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database schema migration failed: " .. tostring(err) .. "\n") end)
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
                    local schemaType = "string"
                    if v.fieldType == "integer" then
                        schemaType = "integer"
                    elseif v.fieldType == "float" then
                        schemaType = "float"
                    elseif v.fieldType == "boolean" then
                        schemaType = "boolean"
                    elseif v.fieldType == "datetime" then
                        schemaType = "datetime"
                    elseif v.fieldType == "text" then
                        schemaType = "text"
                    end

                    lia.db.createColumn("characters", v.field, schemaType, {
                        default = v.default,
                        not_null = false
                    }):next(function() end):catch(ignore)
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
        lia.db.invalidateTable(tbl)
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

    lia.db.query("INSERT OR REPLACE INTO " .. tbl .. " (" .. table.concat(keys, ",") .. ") VALUES " .. table.concat(vals, ","), function()
        lia.db.invalidateTable(tbl)
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

        lia.db.invalidateTable(tbl)
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

        lia.db.invalidateTable("lia_" .. (dbTable or "characters"))
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
        d:resolve({
            results = results,
            lastID = lastID
        })

        lia.db.invalidateTable(dbTable)
    end)
    return d
end

function lia.db.createTable(dbName, primaryKey, schema)
    local d = deferred.new()
    if not dbName or type(dbName) ~= "string" then
        d:reject("Invalid table name: must be a non-empty string")
        return d
    end

    if not schema or type(schema) ~= "table" then
        d:reject("Invalid schema: must be a table of column definitions")
        return d
    end

    if #schema == 0 then
        d:reject("Invalid schema: table must have at least one column")
        return d
    end

    local tableName = "lia_" .. dbName
    local columns = {}
    local indexes = {}
    local foreignKeys = {}
    local typeMap = {
        string = "VARCHAR(255)",
        text = "TEXT",
        integer = "INTEGER",
        int = "INTEGER",
        float = "REAL",
        double = "REAL",
        boolean = "TINYINT(1)",
        bool = "TINYINT(1)",
        datetime = "DATETIME",
        date = "DATE",
        time = "TIME",
        blob = "BLOB"
    }

    for _, column in ipairs(schema) do
        if not column.name or type(column.name) ~= "string" then
            d:reject("Invalid column definition: missing or invalid column name")
            return d
        end

        if not column.type or type(column.type) ~= "string" then
            d:reject("Invalid column definition: missing or invalid column type for '" .. column.name .. "'")
            return d
        end

        local sqlType = typeMap[column.type:lower()]
        if not sqlType then
            d:reject("Unsupported column type '" .. column.type .. "' for column '" .. column.name .. "'")
            return d
        end

        local colDef = lia.db.escapeIdentifier(column.name) .. " " .. sqlType
        if column.unique then colDef = colDef .. " UNIQUE" end
        if column.not_null or column.required then colDef = colDef .. " NOT NULL" end
        if column.default ~= nil then
            if column.type:lower() == "string" or column.type:lower() == "text" then
                colDef = colDef .. " DEFAULT '" .. sqliteEscape(tostring(column.default)) .. "'"
            elseif column.type:lower() == "boolean" or column.type:lower() == "bool" then
                colDef = colDef .. " DEFAULT " .. (column.default and "1" or "0")
            elseif column.type:lower() == "integer" or column.type:lower() == "int" then
                local num = tonumber(column.default)
                if num then colDef = colDef .. " DEFAULT " .. math.floor(num) end
            elseif column.type:lower() == "float" or column.type:lower() == "double" then
                local num = tonumber(column.default)
                if num then colDef = colDef .. " DEFAULT " .. num end
            else
                colDef = colDef .. " DEFAULT " .. tostring(column.default)
            end
        end

        if column.auto_increment and (column.type:lower() == "integer" or column.type:lower() == "int") then
            if type(primaryKey) == "string" and primaryKey == column.name then
                colDef = colDef .. " PRIMARY KEY AUTOINCREMENT"
            elseif type(primaryKey) == "table" and table.HasValue(primaryKey, column.name) then
                colDef = colDef .. " AUTOINCREMENT"
            else
                colDef = colDef .. " AUTOINCREMENT"
            end
        end

        table.insert(columns, colDef)
        if column.index then
            table.insert(indexes, {
                name = column.name,
                unique = column.unique_index or false
            })
        end

        if column.references then
            table.insert(foreignKeys, {
                column = column.name,
                references = column.references
            })
        end
    end

    if primaryKey then
        if type(primaryKey) == "string" then
            local pkColumnDefined = false
            for _, col in ipairs(columns) do
                if col:find("`" .. primaryKey .. "`") and col:find("PRIMARY KEY") then
                    pkColumnDefined = true
                    break
                end
            end

            if not pkColumnDefined then table.insert(columns, "PRIMARY KEY (" .. lia.db.escapeIdentifier(primaryKey) .. ")") end
        elseif type(primaryKey) == "table" then
            local allPkColumnsDefined = true
            for _, pkCol in ipairs(primaryKey) do
                local found = false
                for _, col in ipairs(columns) do
                    if col:find("`" .. pkCol .. "`") and col:find("PRIMARY KEY") then
                        found = true
                        break
                    end
                end

                if not found then
                    allPkColumnsDefined = false
                    break
                end
            end

            if not allPkColumnsDefined then
                local pkColumns = {}
                for _, col in ipairs(primaryKey) do
                    table.insert(pkColumns, lia.db.escapeIdentifier(col))
                end

                table.insert(columns, "PRIMARY KEY (" .. table.concat(pkColumns, ", ") .. ")")
            end
        end
    end

    for _, fk in ipairs(foreignKeys) do
        local refTable, refColumn = fk.references:match("(.+)%.(.+)")
        if refTable and refColumn then table.insert(columns, "FOREIGN KEY (" .. lia.db.escapeIdentifier(fk.column) .. ") REFERENCES " .. lia.db.escapeIdentifier(refTable) .. "(" .. lia.db.escapeIdentifier(refColumn) .. ")") end
    end

    local createQuery = "CREATE TABLE IF NOT EXISTS " .. tableName .. " (" .. table.concat(columns, ", ") .. ")"
    lia.db.query(createQuery, function()
        local indexPromises = {}
        for _, indexInfo in ipairs(indexes) do
            local indexName = tableName .. "_" .. indexInfo.name .. "_idx"
            local indexType = indexInfo.unique and "UNIQUE INDEX" or "INDEX"
            local indexQuery = "CREATE " .. indexType .. " IF NOT EXISTS " .. indexName .. " ON " .. tableName .. "(" .. lia.db.escapeIdentifier(indexInfo.name) .. ")"
            local indexPromise = deferred.new()
            table.insert(indexPromises, indexPromise)
            lia.db.query(indexQuery, function() indexPromise:resolve() end, function(err) indexPromise:reject("Failed to create index on " .. indexInfo.name .. ": " .. err) end)
        end

        if #indexPromises > 0 then
            deferred.all(indexPromises):next(function()
                if lia.db.cacheClear then lia.db.cacheClear() end
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Created table '" .. tableName .. "'\n")
                d:resolve({
                    success = true,
                    table = tableName,
                    columns = #columns,
                    indexes = #indexes,
                    foreignKeys = #foreignKeys
                })
            end):catch(function(err)
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Table '" .. tableName .. "' created but index creation failed: " .. err .. "\n")
                d:reject("Table created but index creation failed: " .. err)
            end)
        else
            if lia.db.cacheClear then lia.db.cacheClear() end
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Created table '" .. tableName .. "'\n")
            d:resolve({
                success = true,
                table = tableName,
                columns = #columns,
                indexes = 0,
                foreignKeys = #foreignKeys
            })
        end
    end, function(err)
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to create table '" .. tableName .. "': " .. err .. "\n")
        d:reject("Failed to create table '" .. tableName .. "': " .. err)
    end)
    return d
end

function lia.db.createColumn(tableName, columnName, columnType, options)
    local d = deferred.new()
    if not tableName or type(tableName) ~= "string" then
        d:reject("Invalid table name: must be a non-empty string")
        return d
    end

    if not columnName or type(columnName) ~= "string" then
        d:reject("Invalid column name: must be a non-empty string")
        return d
    end

    if not columnType or type(columnType) ~= "string" then
        d:reject("Invalid column type: must be a non-empty string")
        return d
    end

    options = options or {}
    local fullTableName = "lia_" .. tableName
    lia.db.tableExists(fullTableName):next(function(tableExists)
        if not tableExists then
            d:reject("Table '" .. fullTableName .. "' does not exist")
            return
        end

        lia.db.fieldExists(fullTableName, columnName):next(function(exists)
            if exists then
                d:resolve({
                    success = false,
                    message = "Column '" .. columnName .. "' already exists in table '" .. fullTableName .. "'"
                })
                return
            end

            local typeMap = {
                string = "VARCHAR(255)",
                text = "TEXT",
                integer = "INTEGER",
                int = "INTEGER",
                float = "REAL",
                double = "REAL",
                boolean = "TINYINT(1)",
                bool = "TINYINT(1)",
                datetime = "DATETIME",
                date = "DATE",
                time = "TIME",
                blob = "BLOB"
            }

            local sqlType = typeMap[columnType:lower()]
            if not sqlType then
                d:reject("Unsupported column type '" .. columnType .. "'")
                return
            end

            local colDef = lia.db.escapeIdentifier(columnName) .. " " .. sqlType
            if options.unique then colDef = colDef .. " UNIQUE" end
            if options.not_null or options.required then colDef = colDef .. " NOT NULL" end
            if options.default ~= nil then
                if columnType:lower() == "string" or columnType:lower() == "text" then
                    colDef = colDef .. " DEFAULT '" .. sqliteEscape(tostring(options.default)) .. "'"
                elseif columnType:lower() == "boolean" or columnType:lower() == "bool" then
                    colDef = colDef .. " DEFAULT " .. (options.default and "1" or "0")
                elseif columnType:lower() == "integer" or columnType:lower() == "int" then
                    local num = tonumber(options.default)
                    if num then colDef = colDef .. " DEFAULT " .. math.floor(num) end
                elseif columnType:lower() == "float" or columnType:lower() == "double" then
                    local num = tonumber(options.default)
                    if num then colDef = colDef .. " DEFAULT " .. num end
                else
                    colDef = colDef .. " DEFAULT " .. tostring(options.default)
                end
            end

            if options.auto_increment and (columnType:lower() == "integer" or columnType:lower() == "int") then colDef = colDef .. " AUTOINCREMENT" end
            local alterQuery = "ALTER TABLE " .. fullTableName .. " ADD COLUMN " .. colDef
            lia.db.query(alterQuery, function()
                if options.index then
                    local indexName = fullTableName .. "_" .. columnName .. "_idx"
                    local indexType = options.unique_index and "UNIQUE INDEX" or "INDEX"
                    local indexQuery = "CREATE " .. indexType .. " IF NOT EXISTS " .. indexName .. " ON " .. fullTableName .. "(" .. lia.db.escapeIdentifier(columnName) .. ")"
                    lia.db.query(indexQuery, function()
                        if lia.db.cacheClear then lia.db.cacheClear() end
                        d:resolve({
                            success = true,
                            table = fullTableName,
                            column = columnName,
                            type = columnType,
                            indexed = true
                        })
                    end, function(err)
                        if lia.db.cacheClear then lia.db.cacheClear() end
                        d:resolve({
                            success = true,
                            table = fullTableName,
                            column = columnName,
                            type = columnType,
                            indexed = false,
                            index_error = err
                        })
                    end)
                else
                    if lia.db.cacheClear then lia.db.cacheClear() end
                    d:resolve({
                        success = true,
                        table = fullTableName,
                        column = columnName,
                        type = columnType,
                        indexed = false
                    })
                end
            end, function(err)
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to add column '" .. columnName .. "' to table '" .. fullTableName .. "': " .. err .. "\n")
                d:reject("Failed to add column '" .. columnName .. "' to table '" .. fullTableName .. "': " .. err)
            end)
        end):catch(function(err) d:reject("Failed to check if column exists: " .. err) end)
    end):catch(function(err) d:reject("Failed to check if table exists: " .. err) end)
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

        lia.db.query("PRAGMA table_info(" .. fullTableName .. ")", function(columns)
            local _ = columns and #columns or 0
            lia.db.query("DROP TABLE " .. fullTableName, function()
                if lia.db.cacheClear then lia.db.cacheClear() end
                d:resolve(true)
            end, function(err)
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to remove table '" .. fullTableName .. "': " .. err .. "\n")
                d:reject(err)
            end)
        end, function(err) d:reject(err) end)
    end):catch(function(err)
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to check if table '" .. fullTableName .. "' exists: " .. err .. "\n")
        d:reject(err)
    end)
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
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get table info for '" .. fullTableName .. "' when removing column '" .. columnName .. "'\n")
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
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Cannot remove column '" .. columnName .. "' from table '" .. fullTableName .. "': it is the last remaining column\n")
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
                end):catch(function(err)
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to remove column '" .. columnName .. "' from table '" .. fullTableName .. "': " .. err .. "\n")
                    d:reject(err)
                end)
            end, function(err)
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to get table info for '" .. fullTableName .. "' when removing column '" .. columnName .. "': " .. err .. "\n")
                d:reject(err)
            end)
        end):catch(function(err)
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to check if column '" .. columnName .. "' exists in table '" .. fullTableName .. "': " .. err .. "\n")
            d:reject(err)
        end)
    end):catch(function(err)
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to check if table '" .. fullTableName .. "' exists when removing column '" .. columnName .. "': " .. err .. "\n")
        d:reject(err)
    end)
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

concommand.Add("lia_load_snapshot", function(ply, _, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
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
    local function sendFeedback(msg)
        print("[DB Load] " .. msg)
    end

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
        sendFeedback("No snapshot file found for table '" .. tableName .. "'", Color(255, 0, 0))
        return
    end

    sendFeedback("Loading snapshot from: " .. filename, Color(0, 255, 0))
    local content = file.Read(filename, "DATA")
    if not content then
        sendFeedback("Failed to read snapshot file: " .. filename, Color(255, 0, 0))
        return
    end

    local rows = {}
    local lineCount = 0
    for line in content:gmatch("[^\r\n]+") do
        lineCount = lineCount + 1
        if not line:match("^%s*%-%-") and line:trim() ~= "" then
            local insertPattern = "INSERT INTO lia_(%w+)%s*%((.+)%)%s*;"
            local stmtTable, valuesStr = line:match(insertPattern)
            if stmtTable and valuesStr then
                local row = {}
                for pair in valuesStr:gmatch("([^,]+)") do
                    pair = pair:trim()
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
        sendFeedback("No valid INSERT statements found in snapshot file", Color(255, 0, 0))
        return
    end

    sendFeedback("Found " .. #rows .. " rows to insert into lia_" .. tableName, Color(255, 255, 255))
    if SERVER and IsValid(ply) then
        ply:ChatPrint("WARNING: This will replace existing data in the table!")
        ply:ChatPrint("Use 'lia_clear_table " .. tableName .. "' first if you want to clear existing data")
    end

    lia.db.bulkInsert(tableName, rows):next(function() sendFeedback("✓ Successfully loaded " .. #rows .. " rows into lia_" .. tableName, Color(0, 255, 0)) end):catch(function(err) sendFeedback("✗ Failed to load snapshot: " .. err, Color(255, 0, 0)) end)
end)

concommand.Add("lia_clear_table", function(ply, _, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    if #args < 1 then
        if SERVER and IsValid(ply) then
            ply:ChatPrint("Usage: lia_clear_table <table_name>")
            ply:ChatPrint("Example: lia_clear_table characters")
        end

        if CLIENT then
            print("Usage: lia_clear_table <table_name>")
            print("Example: lia_clear_table characters")
        end
        return
    end

    local tableName = args[1]
    local function sendFeedback(msg, color)
        if SERVER then
            print("[DB Clear] " .. msg)
            if IsValid(ply) then ply:ChatPrint(msg) end
        elseif CLIENT then
            print("[DB Clear] " .. msg)
            if color then
                chat.AddText(color, "[DB Clear] " .. msg)
            else
                chat.AddText(Color(255, 255, 255), "[DB Clear] " .. msg)
            end
        end
    end

    sendFeedback("Clearing all data from table: lia_" .. tableName, Color(255, 255, 0))
    if SERVER and IsValid(ply) then
        ply:ChatPrint("WARNING: This will DELETE ALL DATA from lia_" .. tableName .. "!")
        ply:ChatPrint("This action cannot be undone!")
    end

    lia.db.delete(tableName):next(function() sendFeedback("✓ Successfully cleared all data from lia_" .. tableName, Color(0, 255, 0)) end):catch(function(err) sendFeedback("✗ Failed to clear table: " .. err, Color(255, 0, 0)) end)
end)

concommand.Add("lia_list_snapshots", function(ply, _, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local tableFilter = args[1]
    local function sendFeedback(msg)
        print("[DB Snapshots] " .. msg)
    end

    sendFeedback("Listing available snapshot files...", Color(0, 255, 0))
    local pattern = tableFilter and ("*_" .. tableFilter .. "_*.txt") or "*.txt"
    local files = file.Find("lilia/database/" .. pattern, "DATA")
    if #files == 0 then
        sendFeedback("No snapshot files found" .. (tableFilter and " for table '" .. tableFilter .. "'" or ""), Color(255, 255, 0))
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

    sendFeedback("Found " .. #files .. " snapshot files:", Color(255, 255, 255))
    for tableName, fileList in pairs(tableGroups) do
        sendFeedback("Table: " .. tableName .. " (" .. #fileList .. " snapshots)", Color(0, 255, 0))
        table.sort(fileList, function(a, b) return a > b end)
        for _, filename in ipairs(fileList) do
            local timestamp = filename:match("_(%d+_%d+)%.txt$")
            sendFeedback("  - " .. filename .. " (timestamp: " .. (timestamp or "unknown") .. ")", Color(255, 255, 255))
        end
    end

    sendFeedback("Use 'lia_load_snapshot <table> [timestamp]' to load a specific snapshot", Color(255, 255, 255))
end)

concommand.Add("lia_snapshot", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local function sendFeedback(msg)
        print("[DB Snapshot] " .. msg)
    end

    sendFeedback("Starting database snapshot of all lia_* tables...", Color(0, 255, 0))
    lia.db.getTables():next(function(tables)
        if #tables == 0 then
            sendFeedback("No lia_* tables found!", Color(255, 255, 0))
            return
        end

        sendFeedback("Found " .. #tables .. " tables: " .. table.concat(tables, ", "), Color(255, 255, 255))
        local completed = 0
        local total = #tables
        local timestamp = os.date("%Y%m%d_%H%M%S")
        for _, tableName in ipairs(tables) do
            lia.db.select("*", tableName:gsub("lia_", "")):next(function(result)
                if result and result.results then
                    local shortName = tableName:gsub("lia_", "")
                    local filename = "lilia/database/" .. shortName .. "_" .. timestamp .. ".txt"
                    local content = "Database snapshot for table: " .. tableName .. "\n"
                    content = content .. "Generated on: " .. os.date() .. "\n"
                    content = content .. "Total records: " .. #result.results .. "\n\n"
                    for _, row in ipairs(result.results) do
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

                    file.Write(filename, content)
                    sendFeedback("✓ Saved " .. #result.results .. " records from " .. tableName .. " to " .. filename, Color(0, 255, 0))
                else
                    sendFeedback("✗ Failed to query table: " .. tableName, Color(255, 0, 0))
                end

                completed = completed + 1
                if completed >= total then sendFeedback("Database snapshot completed! Files saved to data/lilia/database/", Color(0, 255, 0)) end
            end):catch(function(err)
                sendFeedback("✗ Error processing table " .. tableName .. ": " .. err, Color(255, 0, 0))
                completed = completed + 1
                if completed >= total then sendFeedback("Database snapshot completed with errors! Files saved to data/lilia/database/", Color(255, 255, 0)) end
            end)
        end
    end):catch(function(err) sendFeedback("✗ Failed to get table list: " .. err, Color(255, 0, 0)) end)
end)

concommand.Add("lia_snapshot_table", function(ply, _, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    if #args == 0 then
        print("Usage: lia_snapshot_table <table_name> [table_name2] [table_name3] ...")
        return
    end

    local function sendFeedback(msg)
        print("[DB Snapshot] " .. msg)
    end

    local tablesToSnapshot = {}
    for _, tableName in ipairs(args) do
        if tableName:StartWith("lia_") then
            table.insert(tablesToSnapshot, tableName:gsub("lia_", ""))
        else
            table.insert(tablesToSnapshot, tableName)
        end
    end

    sendFeedback("Starting database snapshot for tables: " .. table.concat(tablesToSnapshot, ", "), Color(0, 255, 0))
    local completed = 0
    local total = #tablesToSnapshot
    local timestamp = os.date("%Y%m%d_%H%M%S")
    for _, tableName in ipairs(tablesToSnapshot) do
        lia.db.select("*", tableName):next(function(result)
            if result and result.results then
                local fullTableName = "lia_" .. tableName
                local filename = "lilia/database/" .. tableName .. "_" .. timestamp .. ".txt"
                local content = "Database snapshot for table: " .. fullTableName .. "\n"
                content = content .. "Generated on: " .. os.date() .. "\n"
                content = content .. "Total records: " .. #result.results .. "\n\n"
                for _, row in ipairs(result.results) do
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

                file.Write(filename, content)
                sendFeedback("✓ Saved " .. #result.results .. " records from " .. fullTableName .. " to " .. filename, Color(0, 255, 0))
            else
                sendFeedback("✗ Failed to query table: lia_" .. tableName, Color(255, 0, 0))
            end

            completed = completed + 1
            if completed >= total then sendFeedback("Database snapshot completed! Files saved to data/lilia/database/", Color(0, 255, 0)) end
        end):catch(function(err)
            sendFeedback("✗ Error processing table lia_" .. tableName .. ": " .. err, Color(255, 0, 0))
            completed = completed + 1
            if completed >= total then sendFeedback("Database snapshot completed with errors! Files saved to data/lilia/database/", Color(255, 255, 0)) end
        end)
    end
end)

concommand.Add("lia_test_database", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        if SERVER and IsValid(ply) then ply:ChatPrint("This command requires super admin privileges.") end
        return
    end

    local testResults = {
        total = 0,
        passed = 0,
        failed = 0,
        details = {}
    }

    local function addTest(name, success, errorMsg)
        testResults.total = testResults.total + 1
        if success then
            testResults.passed = testResults.passed + 1
            testResults.details[#testResults.details + 1] = {
                name = name,
                status = "PASS"
            }
        else
            testResults.failed = testResults.failed + 1
            testResults.details[#testResults.details + 1] = {
                name = name,
                status = "FAIL",
                error = errorMsg
            }
        end
    end

    local databaseInfo = {
        tables = {},
        totalRows = 0,
        cacheStats = {},
        performance = {},
        structure = {}
    }

    local function gatherDatabaseInfo()
        lia.db.query("SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'lia_%' ORDER BY name", function(tables)
            if tables then
                for _, tableRow in ipairs(tables) do
                    local tableName = tableRow.name or tableRow[1]
                    local tableInfo = {
                        name = tableName,
                        columns = {},
                        rowCount = 0,
                        size = 0
                    }

                    lia.db.query("PRAGMA table_info(" .. tableName .. ")", function(columns) if columns then tableInfo.columns = columns end end)
                    lia.db.query("SELECT COUNT(*) as count FROM " .. tableName, function(countResult)
                        if countResult and countResult[1] then
                            tableInfo.rowCount = countResult[1].count or 0
                            databaseInfo.totalRows = databaseInfo.totalRows + tableInfo.rowCount
                        end
                    end)

                    table.insert(databaseInfo.tables, tableInfo)
                end
            end
        end)

        lia.db.query("SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size()", function(sizeResult) if sizeResult and sizeResult[1] then databaseInfo.size = sizeResult[1].size or 0 end end)
        databaseInfo.cacheStats.enabled = lia.db.cache.enabled
        databaseInfo.cacheStats.ttl = lia.db.cache.ttl
        databaseInfo.cacheStats.entries = 0
        for _ in pairs(lia.db.cache.store) do
            databaseInfo.cacheStats.entries = databaseInfo.cacheStats.entries + 1
        end

        lia.db.query("SELECT sqlite_version() as version", function(versionResult) if versionResult and versionResult[1] then databaseInfo.version = versionResult[1].version end end)
        lia.db.query("PRAGMA foreign_keys", function(fkResult) if fkResult and fkResult[1] then databaseInfo.foreignKeysEnabled = fkResult[1].foreign_keys == 1 end end)
        lia.db.query("SELECT name, tbl_name FROM sqlite_master WHERE type='index' AND name NOT LIKE 'sqlite_%'", function(indexes) if indexes then databaseInfo.indexes = indexes end end)
        lia.db.query("SELECT name, tbl_name FROM sqlite_master WHERE type='trigger'", function(triggers) if triggers then databaseInfo.triggers = triggers end end)
        lia.db.query("PRAGMA integrity_check", function(integrityResult) if integrityResult and integrityResult[1] then databaseInfo.integrityCheck = integrityResult[1].integrity_check end end)
    end

    local function printComprehensiveReport()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "=========================================\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "          DATABASE COMPREHENSIVE REPORT          \n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "=========================================\n\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "DATABASE OVERVIEW:\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  SQLite Version: ", Color(0, 255, 0), databaseInfo.version or "Unknown", "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Database Size: ", Color(0, 255, 0), string.format("%.2f MB", (databaseInfo.size or 0) / 1024 / 1024), "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Total Tables: ", Color(0, 255, 0), #databaseInfo.tables, "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Total Rows: ", Color(0, 255, 0), databaseInfo.totalRows, "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Foreign Keys: ", Color(0, 255, 0), databaseInfo.foreignKeysEnabled and "Enabled" or "Disabled", "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Database Integrity: ", Color(0, 255, 0), databaseInfo.integrityCheck == "ok" and "✓ OK" or "✗ " .. (databaseInfo.integrityCheck or "Unknown"), "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Indexes: ", Color(0, 255, 0), databaseInfo.indexes and #databaseInfo.indexes or 0, "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Triggers: ", Color(0, 255, 0), databaseInfo.triggers and #databaseInfo.triggers or 0, "\n\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "CACHE STATISTICS:\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Cache Enabled: ", Color(0, 255, 0), databaseInfo.cacheStats.enabled and "Yes" or "No", "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Cache TTL: ", Color(0, 255, 0), databaseInfo.cacheStats.ttl, " seconds\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  Cached Entries: ", Color(0, 255, 0), databaseInfo.cacheStats.entries, "\n\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "TABLE DETAILS:\n")
        for _, tableInfo in ipairs(databaseInfo.tables) do
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 0), "  Table: ", tableInfo.name, "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "    Columns: ", Color(0, 255, 0), #tableInfo.columns, "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "    Rows: ", Color(0, 255, 0), tableInfo.rowCount, "\n")
            if #tableInfo.columns > 0 then
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "    Column Structure:\n")
                for _, col in ipairs(tableInfo.columns) do
                    local constraints = {}
                    if col.notnull == 1 then table.insert(constraints, "NOT NULL") end
                    if col.pk == 1 then table.insert(constraints, "PRIMARY KEY") end
                    if col.dflt_value then table.insert(constraints, "DEFAULT: " .. col.dflt_value) end
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "      - ", col.name, " (", col.type, ")")
                    if #constraints > 0 then MsgC(Color(255, 255, 0), " [", table.concat(constraints, ", "), "]") end
                    MsgC(Color(255, 255, 255), "\n")
                end
            end

            MsgC(Color(255, 255, 255), "\n")
        end

        if databaseInfo.indexes and #databaseInfo.indexes > 0 then
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "INDEXES:\n")
            for _, indexInfo in ipairs(databaseInfo.indexes) do
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  ", indexInfo.name, " (on ", indexInfo.tbl_name, ")\n")
            end

            MsgC(Color(255, 255, 255), "\n")
        end

        if databaseInfo.triggers and #databaseInfo.triggers > 0 then
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "TRIGGERS:\n")
            for _, triggerInfo in ipairs(databaseInfo.triggers) do
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  ", triggerInfo.name, " (on ", triggerInfo.tbl_name, ")\n")
            end

            MsgC(Color(255, 255, 255), "\n")
        end

        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "TEST RESULTS SUMMARY:\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Total Tests: ", Color(0, 255, 0), testResults.total, "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Passed: ", Color(0, 255, 0), testResults.passed, "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Failed: ", Color(255, 0, 0), testResults.failed, "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Success Rate: ", Color(0, 255, 0), string.format("%.1f%%", (testResults.passed / testResults.total) * 100), "\n\n")
        if testResults.failed > 0 then
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 0), "FAILED TESTS:\n")
            for _, test in ipairs(testResults.details) do
                if test.status == "FAIL" then MsgC(Color(255, 0, 0), "  ✗ ", test.name, ": ", test.error or "Unknown error", "\n") end
            end

            MsgC(Color(255, 255, 255), "\n")
        end

        MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "PASSED TESTS:\n")
        for _, test in ipairs(testResults.details) do
            if test.status == "PASS" then MsgC(Color(0, 255, 0), "  ✓ ", test.name, "\n") end
        end

        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "\n=========================================\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "         DATABASE REPORT COMPLETE         \n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "=========================================\n")
    end

    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Starting comprehensive database tests (silent mode)...\n")
    gatherDatabaseInfo()
    lia.db.getTables():next(function(tables)
        local hasTables = #tables > 0
        addTest("Database connection and table enumeration", hasTables, hasTables and nil or "No tables found")
        if hasTables then
            local testTable = tables[1]:gsub("lia_", "")
            lia.db.select("*", testTable):next(function(result) addTest("Basic SELECT query on " .. testTable, result ~= nil, result == nil and "Query failed" or nil) end):catch(function(err) addTest("Basic SELECT query on " .. testTable, false, err) end)
            lia.db.count(testTable):next(function(count) addTest("COUNT query on " .. testTable, type(count) == "number", "Invalid count result: " .. tostring(count)) end):catch(function(err) addTest("COUNT query on " .. testTable, false, err) end)
            lia.db.selectWithCondition("*", testTable, {
                ["1"] = 1
            }):next(function() addTest("SELECT with conditions on " .. testTable, result ~= nil, result == nil and "Query failed" or nil) end):catch(function(err) addTest("SELECT with conditions on " .. testTable, false, err) end)

            lia.db.selectOne("*", testTable):next(function(result) addTest("SELECT one record on " .. testTable, result ~= nil, result == nil and "Query failed" or nil) end):catch(function(err) addTest("SELECT one record on " .. testTable, false, err) end)
        end
    end):catch(function(err) addTest("Database connection and table enumeration", false, err) end)

    lia.db.cacheSet("test_table", "test_key", {
        test = "data"
    })

    local cached = lia.db.cacheGet("test_key")
    addTest("Cache set/get operations", cached and cached.test == "data", "Cache operation failed")
    lia.db.cacheClear()
    local cachedAfterClear = lia.db.cacheGet("test_key")
    addTest("Cache clear operation", cachedAfterClear == nil, "Cache clear failed")
    local converted = lia.db.convertDataType("test")
    addTest("Data type conversion", converted == "'test'", "Conversion failed: " .. tostring(converted))
    local escaped = lia.db.escapeIdentifier("test_column")
    addTest("Identifier escaping", escaped == "`test_column`", "Escaping failed: " .. tostring(escaped))
    lia.db.tableExists("lia_characters"):next(function(exists) addTest("Table existence check", type(exists) == "boolean", "Invalid result type: " .. type(exists)) end):catch(function(err) addTest("Table existence check", false, err) end)
    lia.db.fieldExists("lia_characters", "id"):next(function(exists) addTest("Field existence check", type(exists) == "boolean", "Invalid result type: " .. type(exists)) end):catch(function(err) addTest("Field existence check", false, err) end)
    local testData = {
        {
            test_id = 1,
            test_name = "test_record_1"
        },
        {
            test_id = 2,
            test_name = "test_record_2"
        }
    }

    lia.db.createTable("test_bulk", "test_id", {
        {
            name = "test_id",
            type = "integer"
        },
        {
            name = "test_name",
            type = "string"
        }
    }):next(function()
        addTest("Table creation", result.success, result.success and nil or "Table creation failed")
        lia.db.bulkInsert("test_bulk", testData):next(function()
            addTest("Bulk insert operation", true)
            lia.db.bulkUpsert("test_bulk", {
                {
                    test_id = 1,
                    test_name = "updated_record_1"
                },
                {
                    test_id = 3,
                    test_name = "test_record_3"
                }
            }):next(function()
                addTest("Bulk upsert operation", true)
                lia.db.removeTable("test_bulk"):next(function() addTest("Table removal", true) end):catch(function(err) addTest("Table removal", false, err) end)
            end):catch(function(err)
                addTest("Bulk upsert operation", false, err)
                lia.db.removeTable("test_bulk")
            end)
        end):catch(function(err)
            addTest("Bulk insert operation", false, err)
            lia.db.removeTable("test_bulk")
        end)
    end):catch(function(err) addTest("Table creation", false, err) end)

    lia.db.transaction({"SELECT 1 as test_value", "SELECT 2 as test_value2"}):next(function() addTest("Transaction execution", true) end):catch(function(err) addTest("Transaction execution", false, err) end)
    lia.db.insertOrIgnore({
        test_field = "test_value"
    }, "nonexistent"):next(function() addTest("Insert or ignore operation", true) end):catch(function(err) addTest("Insert or ignore operation", false, err) end)

    lia.db.upsert({
        test_field = "test_value"
    }, "nonexistent"):next(function() addTest("Upsert operation", true) end):catch(function(err) addTest("Upsert operation", false, err) end)

    lia.db.delete("nonexistent"):next(function() addTest("Delete operation", true) end):catch(function(err) addTest("Delete operation", false, err) end)
    lia.db.setCacheTTL(1)
    lia.db.cacheSet("test_table", "ttl_test", {
        test = "ttl_data"
    })

    local immediate = lia.db.cacheGet("ttl_test")
    addTest("Cache TTL immediate access", immediate ~= nil, "TTL cache failed immediately")
    lia.db.setCacheEnabled(false)
    lia.db.cacheSet("test_table", "disabled_test", {
        test = "disabled"
    })

    local disabled = lia.db.cacheGet("disabled_test")
    addTest("Cache disabled state", disabled == nil, "Cache should be disabled")
    lia.db.setCacheEnabled(true)
    lia.db.addDatabaseFields()
    lia.db.GetCharacterTable(function(columns) addTest("Character table field enumeration", type(columns) == "table", "Invalid result type: " .. type(columns)) end)
    timer.Simple(3, function() printComprehensiveReport() end)
end)

concommand.Add("lia_db_performance", function(ply, _, args)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        if SERVER and IsValid(ply) then ply:ChatPrint("This command requires super admin privileges.") end
        return
    end

    local tableName = args[1] or "characters"
    local iterations = tonumber(args[2]) or 10
    local queryType = args[3] or "select"
    if tableName:StartWith("lia_") then tableName = tableName:gsub("lia_", "") end
    if iterations < 1 or iterations > 100 then
        local msg = "Invalid iterations count. Must be between 1 and 100."
        if SERVER and IsValid(ply) then
            ply:ChatPrint(msg)
        else
            print("[DB Performance] " .. msg)
        end
        return
    end

    local function sendFeedback(msg)
        print("[DB Performance] " .. msg)
        if SERVER and IsValid(ply) then ply:ChatPrint(msg) end
    end

    sendFeedback("Starting database performance comparison...", Color(0, 255, 0))
    sendFeedback("Table: " .. tableName .. " | Iterations: " .. iterations .. " | Query Type: " .. queryType, Color(255, 255, 255))
    local originalCacheEnabled = lia.db.cache.enabled
    local originalCacheTTL = lia.db.cache.ttl
    lia.db.cacheClear()
    local results = {
        cached = {
            times = {},
            total = 0,
            avg = 0
        },
        uncached = {
            times = {},
            total = 0,
            avg = 0
        }
    }

    local function runBenchmark(cacheEnabled, callback)
        lia.db.setCacheEnabled(cacheEnabled)
        lia.db.setCacheTTL(cacheEnabled and 300 or 0)
        local completed = 0
        for _ = 1, iterations do
            local queryStart = SysTime()
            local queryPromise
            if queryType == "count" then
                queryPromise = lia.db.count(tableName)
            elseif queryType == "selectone" then
                queryPromise = lia.db.selectOne("*", tableName)
            else
                queryPromise = lia.db.select("*", tableName, nil, 10)
            end

            queryPromise:next(function()
                local queryTime = SysTime() - queryStart
                local key = cacheEnabled and "cached" or "uncached"
                table.insert(results[key].times, queryTime * 1000)
                results[key].total = results[key].total + (queryTime * 1000)
                completed = completed + 1
                if completed >= iterations then
                    results[key].avg = results[key].total / iterations
                    callback()
                end
            end):catch(function(err)
                sendFeedback("Error in " .. (cacheEnabled and "cached" or "uncached") .. " query: " .. err, Color(255, 0, 0))
                completed = completed + 1
                if completed >= iterations then
                    results[key].avg = results[key].total / completed
                    callback()
                end
            end)
        end
    end

    runBenchmark(false, function()
        sendFeedback("✓ Uncached benchmark completed", Color(0, 255, 0))
        timer.Simple(0.5, function()
            runBenchmark(true, function()
                sendFeedback("✓ Cached benchmark completed", Color(0, 255, 0))
                lia.db.setCacheEnabled(originalCacheEnabled)
                lia.db.setCacheTTL(originalCacheTTL)
                local cachedAvg = results.cached.avg
                local uncachedAvg = results.uncached.avg
                local improvement = uncachedAvg > 0 and ((uncachedAvg - cachedAvg) / uncachedAvg) * 100 or 0
                local speedup = uncachedAvg > 0 and (uncachedAvg / cachedAvg) or 0
                local cachedMin = math.min(unpack(results.cached.times))
                local cachedMax = math.max(unpack(results.cached.times))
                local uncachedMin = math.min(unpack(results.uncached.times))
                local uncachedMax = math.max(unpack(results.uncached.times))
                sendFeedback("=========================================", Color(83, 143, 239))
                sendFeedback("       DATABASE PERFORMANCE RESULTS       ", Color(83, 143, 239))
                sendFeedback("=========================================", Color(83, 143, 239))
                sendFeedback("", Color(255, 255, 255))
                sendFeedback("Test Configuration:", Color(255, 255, 255))
                sendFeedback("  Table: lia_" .. tableName, Color(255, 255, 255))
                sendFeedback("  Query Type: " .. queryType, Color(255, 255, 255))
                sendFeedback("  Iterations: " .. iterations, Color(255, 255, 255))
                sendFeedback("", Color(255, 255, 255))
                sendFeedback("Performance Results (milliseconds):", Color(0, 255, 0))
                sendFeedback(string.format("  Uncached: %.2f avg (%.2f min - %.2f max)", uncachedAvg, uncachedMin, uncachedMax), Color(255, 255, 255))
                sendFeedback(string.format("  Cached:   %.2f avg (%.2f min - %.2f max)", cachedAvg, cachedMin, cachedMax), Color(255, 255, 255))
                sendFeedback("", Color(255, 255, 255))
                sendFeedback("Performance Analysis:", Color(0, 255, 0))
                if improvement > 0 then
                    sendFeedback(string.format("  ✓ Cache improves performance by %.1f%%", improvement), Color(0, 255, 0))
                    sendFeedback(string.format("  ✓ Cache provides %.1fx speedup", speedup), Color(0, 255, 0))
                elseif improvement < -10 then
                    sendFeedback(string.format("  ⚠ Cache is %.1f%% slower (possible overhead)", math.abs(improvement)), Color(255, 255, 0))
                else
                    sendFeedback("  ~ Cache performance is similar to uncached", Color(255, 255, 255))
                end

                sendFeedback("", Color(255, 255, 255))
                sendFeedback("Cache Status:", Color(255, 255, 255))
                sendFeedback("  Cache Enabled: " .. (originalCacheEnabled and "Yes" or "No"), Color(255, 255, 255))
                sendFeedback("  Cache TTL: " .. originalCacheTTL .. " seconds", Color(255, 255, 255))
                sendFeedback("  Cache Entries: " .. (function()
                    local count = 0
                    for _ in pairs(lia.db.cache.store) do
                        count = count + 1
                    end
                    return count
                end)(), Color(255, 255, 255))

                sendFeedback("", Color(255, 255, 255))
                sendFeedback("=========================================", Color(83, 143, 239))
                sendFeedback("         PERFORMANCE TEST COMPLETE         ", Color(83, 143, 239))
                sendFeedback("=========================================", Color(83, 143, 239))
                if improvement > 50 then
                    sendFeedback("💡 Recommendation: Cache is highly effective for this query!", Color(0, 255, 0))
                elseif improvement < 0 then
                    sendFeedback("💡 Recommendation: Consider if caching is necessary for this query.", Color(255, 255, 0))
                end
            end)
        end)
    end)
end)

concommand.Add("lia_migrate_schema", function(ply)
    if SERVER and IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("This command requires super admin privileges.")
        return
    end

    local function sendFeedback(msg)
        print("[DB Migration] " .. msg)
        if SERVER and IsValid(ply) then ply:ChatPrint(msg) end
    end

    sendFeedback("Starting database schema migration...", Color(0, 255, 0))
    sendFeedback("This will check all tables for missing columns and add them automatically.", Color(255, 255, 255))
    lia.db.migrateDatabaseSchemas():next(function() sendFeedback("✓ Database schema migration completed successfully!", Color(0, 255, 0)) end):catch(function(err) sendFeedback("✗ Database schema migration failed: " .. tostring(err), Color(255, 0, 0)) end)
end)