lia.db = lia.db or {}
lia.db.prepared = lia.db.prepared or {}
lia.db.schemaLoading = lia.db.schemaLoading or false
lia.db.schemaCallbacks = lia.db.schemaCallbacks or {}
local function resolved(value)
    local promise = deferred.new()
    promise:resolve(value)
    return promise
end

local function tableName(name)
    name = tostring(name or "characters")
    return string.StartWith(name, "lia_") and name or "lia_" .. name
end

local function runSeries(tasks, callback, errorCallback)
    local index = 1
    local function nextTask()
        if index > #tasks then
            if isfunction(callback) then callback() end
            return
        end

        local task = tasks[index]
        index = index + 1
        task(nextTask, function(message) if isfunction(errorCallback) then errorCallback(message) end end)
    end

    nextTask()
end

-- mysql is the sole executor. This facade deliberately preserves Lilia's promises.
function lia.db.query(statement, callback, errorCallback)
    local promise = deferred.new()
    mysql:RawQuery(statement, function(results, lastID, affectedRows)
        results = results or {}
        if isfunction(callback) then callback(results, lastID, affectedRows) end
        promise:resolve({
            results = results,
            lastID = lastID,
            affectedRows = affectedRows
        })
    end, function(message, failedStatement)
        if isfunction(errorCallback) then errorCallback(message, failedStatement) end
        promise:reject(message)
    end)
    return promise
end

function lia.db.escape(value)
    return mysql:Escape(value)
end

function lia.db.escapeIdentifier(identifier)
    return mysql:QuoteIdentifier(identifier)
end

function lia.db.connect(callback, reconnect, failureCallback)
    if reconnect and mysql:IsConnected() then mysql:Disconnect() end
    if mysql:IsConnected() then
        lia.db.connected = true
        if isfunction(callback) then callback() end
        return true
    end

    local config = lia.db.config or {}
    local adapter = config.adapter or config.module or lia.db.adapter or lia.db.module or "sqlite"
    mysql:SetModule(adapter)
    lia.db.adapter, lia.db.module = mysql.module, mysql.module
    return mysql:Connect(config.hostname or lia.db.hostname, config.username or lia.db.username, config.password or lia.db.password, config.database or lia.db.database, config.port or lia.db.port, config.socket, config.flags, function()
        lia.db.connected = true
        if isfunction(callback) then callback() end
    end, function(message)
        lia.db.connected = false
        if isfunction(failureCallback) then failureCallback(message) end
    end)
end

function lia.db.convertDataType(value, noEscape)
    if noEscape then
        if istable(value) then return util.TableToJSON(value) end
        return tostring(value)
    end
    return mysql:Value(value)
end

local function buildWhereClause(conditions)
    if conditions == nil then return "" end
    if isstring(conditions) then return string.Trim(conditions) == "" and "" or " WHERE " .. conditions end
    if not istable(conditions) then error("database conditions must be a string or table") end
    local fields = {}
    for field in pairs(conditions) do
        fields[#fields + 1] = field
    end

    table.sort(fields, function(a, b) return tostring(a) < tostring(b) end)
    local parts = {}
    for _, field in ipairs(fields) do
        local value = conditions[field]
        local operator = "="
        if istable(value) and value.operator then operator, value = string.upper(value.operator), value.value end
        local identifier = mysql:QuoteIdentifier(field)
        if value == nil or value == NULL then
            local isNot = operator == "!=" or operator == "IS NOT"
            parts[#parts + 1] = identifier .. (isNot and " IS NOT NULL" or " IS NULL")
        elseif (operator == "IN" or operator == "NOT IN") and istable(value) then
            local values = {}
            for i = 1, #value do
                values[i] = mysql:Value(value[i])
            end

            parts[#parts + 1] = identifier .. " " .. operator .. " (" .. table.concat(values, ", ") .. ")"
        else
            parts[#parts + 1] = identifier .. " " .. operator .. " " .. mysql:Value(value)
        end
    end
    return #parts > 0 and " WHERE " .. table.concat(parts, " AND ") or ""
end

local function sortedKeys(row)
    local keys = {}
    for key in pairs(row) do
        keys[#keys + 1] = key
    end

    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    return keys
end

local function insertSQL(value, dbTable, mode)
    local keys, names, values = sortedKeys(value), {}, {}
    for i = 1, #keys do
        names[i] = mysql:QuoteIdentifier(keys[i])
        values[i] = mysql:Value(value[keys[i]])
    end

    local verb = "INSERT"
    if mode == "ignore" then verb = mysql.module == "sqlite" and "INSERT OR IGNORE" or "INSERT IGNORE" end
    if mode == "replace" and mysql.module == "sqlite" then verb = "INSERT OR REPLACE" end
    local statement = string.format("%s INTO %s (%s) VALUES (%s)", verb, mysql:QuoteIdentifier(tableName(dbTable)), table.concat(names, ", "), table.concat(values, ", "))
    if mode == "replace" and mysql.module == "mysqloo" then
        local updates = {}
        for i = 1, #names do
            updates[i] = names[i] .. " = VALUES(" .. names[i] .. ")"
        end

        statement = statement .. " ON DUPLICATE KEY UPDATE " .. table.concat(updates, ", ")
    end
    return statement
end

function lia.db.insertTable(value, callback, dbTable)
    local promise = deferred.new()
    local query = mysql:Insert(tableName(dbTable))
    for _, key in ipairs(sortedKeys(value)) do
        query:Insert(key, value[key])
    end

    query:Callback(function(results, lastID, affectedRows)
        if isfunction(callback) then callback(results, lastID, affectedRows) end
        promise:resolve({
            results = results,
            lastID = lastID,
            affectedRows = affectedRows
        })
    end)

    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

function lia.db.insertOrIgnore(value, dbTable)
    local promise = deferred.new()
    local query = mysql:InsertIgnore(tableName(dbTable))
    for _, key in ipairs(sortedKeys(value)) do
        query:Insert(key, value[key])
    end

    query:Callback(function(results, lastID, affectedRows)
        promise:resolve({
            results = results,
            lastID = lastID,
            affectedRows = affectedRows
        })
    end)

    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

function lia.db.updateTable(value, callback, dbTable, condition)
    local promise = deferred.new()
    local query = mysql:Update(tableName(dbTable))
    for _, key in ipairs(sortedKeys(value)) do
        query:Update(key, value[key])
    end

    local where = buildWhereClause(condition)
    if where ~= "" then query:WhereRaw(where:sub(8)) end
    query:Callback(function(results, lastID, affectedRows)
        if isfunction(callback) then callback(results, lastID, affectedRows) end
        promise:resolve({
            results = results,
            lastID = lastID,
            affectedRows = affectedRows
        })
    end)

    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

function lia.db.select(fields, dbTable, condition, limit)
    if fields == nil then fields = "*" end
    local fieldValues = istable(fields) and fields or {fields}
    local selected = {}
    for i = 1, #fieldValues do
        local field = tostring(fieldValues[i])
        if field == "*" or not field:match("^[%w_]+$") then
            selected[i] = field
        else
            selected[i] = mysql:QuoteIdentifier(field)
        end
    end

    local fieldList = table.concat(selected, ", ")
    local statement = "SELECT " .. fieldList .. " FROM " .. mysql:QuoteIdentifier(tableName(dbTable)) .. buildWhereClause(condition)
    if limit then statement = statement .. " LIMIT " .. math.max(0, tonumber(limit) or 0) end
    return lia.db.query(statement)
end

function lia.db.selectWithCondition(fields, dbTable, conditions, limit, orderBy)
    if fields == nil then fields = "*" end
    local fieldValues = istable(fields) and fields or {fields}
    local selected = {}
    for i = 1, #fieldValues do
        local field = tostring(fieldValues[i])
        if field == "*" or not field:match("^[%w_]+$") then
            selected[i] = field
        else
            selected[i] = mysql:QuoteIdentifier(field)
        end
    end

    local fieldList = table.concat(selected, ", ")
    local statement = "SELECT " .. fieldList .. " FROM " .. mysql:QuoteIdentifier(tableName(dbTable)) .. buildWhereClause(conditions)
    if orderBy then statement = statement .. " ORDER BY " .. tostring(orderBy) end
    if limit then statement = statement .. " LIMIT " .. math.max(0, tonumber(limit) or 0) end
    return lia.db.query(statement)
end

function lia.db.selectOne(fields, dbTable, condition)
    return lia.db.select(fields, dbTable, condition, 1):next(function(result) return result.results[1] end)
end

function lia.db.count(dbTable, condition)
    return lia.db.select("COUNT(*) AS cnt", dbTable, condition):next(function(result) return tonumber(result.results[1] and result.results[1].cnt) or 0 end)
end

function lia.db.exists(dbTable, condition)
    return lia.db.count(dbTable, condition):next(function(count) return count > 0 end)
end

function lia.db.delete(dbTable, condition)
    local promise = deferred.new()
    local query = mysql:Delete(tableName(dbTable))
    local where = buildWhereClause(condition)
    if where ~= "" then query:WhereRaw(where:sub(8)) end
    query:Callback(function(results, lastID, affectedRows)
        promise:resolve({
            results = results,
            lastID = lastID,
            affectedRows = affectedRows
        })
    end)

    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

function lia.db.upsert(value, dbTable)
    return lia.db.query(insertSQL(value, dbTable, "replace"))
end

function lia.db.bulkInsert(dbTable, rows)
    if not istable(rows) or #rows == 0 then
        return resolved({
            results = {},
            lastID = nil
        })
    end

    local keys, names = sortedKeys(rows[1]), {}
    for i = 1, #keys do
        names[i] = mysql:QuoteIdentifier(keys[i])
    end

    local groups = {}
    for rowIndex, row in ipairs(rows) do
        local values = {}
        for i = 1, #keys do
            values[i] = mysql:Value(row[keys[i]])
        end

        groups[rowIndex] = "(" .. table.concat(values, ", ") .. ")"
    end
    return lia.db.query(string.format("INSERT INTO %s (%s) VALUES %s", mysql:QuoteIdentifier(tableName(dbTable)), table.concat(names, ", "), table.concat(groups, ", ")))
end

function lia.db.bulkUpsert(dbTable, rows)
    if not istable(rows) or #rows == 0 then
        return resolved({
            results = {},
            lastID = nil
        })
    end

    local keys, names = sortedKeys(rows[1]), {}
    for i = 1, #keys do
        names[i] = mysql:QuoteIdentifier(keys[i])
    end

    local groups = {}
    for rowIndex, row in ipairs(rows) do
        local values = {}
        for i = 1, #keys do
            values[i] = mysql:Value(row[keys[i]])
        end

        groups[rowIndex] = "(" .. table.concat(values, ", ") .. ")"
    end

    local verb = mysql.module == "sqlite" and "INSERT OR REPLACE" or "INSERT"
    local statement = string.format("%s INTO %s (%s) VALUES %s", verb, mysql:QuoteIdentifier(tableName(dbTable)), table.concat(names, ", "), table.concat(groups, ", "))
    if mysql.module == "mysqloo" then
        local updates = {}
        for i = 1, #names do
            updates[i] = names[i] .. " = VALUES(" .. names[i] .. ")"
        end

        statement = statement .. " ON DUPLICATE KEY UPDATE " .. table.concat(updates, ", ")
    end
    return lia.db.query(statement)
end

function lia.db.tableExists(name)
    local statement
    if mysql.module == "sqlite" then
        statement = "SELECT name FROM sqlite_master WHERE type = 'table' AND name = " .. mysql:Value(name)
    else
        statement = "SELECT TABLE_NAME AS name FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = " .. mysql:Value(name)
    end
    return lia.db.query(statement):next(function(result) return #result.results > 0 end)
end

function lia.db.getTables()
    local statement
    if mysql.module == "sqlite" then
        statement = "SELECT name FROM sqlite_master WHERE type = 'table' AND name LIKE 'lia_%'"
    else
        statement = "SELECT TABLE_NAME AS name FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'lia\\_%'"
    end
    return lia.db.query(statement):next(function(result)
        local names = {}
        for _, row in ipairs(result.results) do
            names[#names + 1] = row.name or row.TABLE_NAME
        end

        table.sort(names)
        return names
    end)
end

function lia.db.getColumns(name)
    local statement
    if mysql.module == "sqlite" then
        statement = "PRAGMA table_info(" .. mysql:QuoteIdentifier(name) .. ")"
    else
        statement = "SELECT COLUMN_NAME AS name, DATA_TYPE AS type FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = " .. mysql:Value(name) .. " ORDER BY ORDINAL_POSITION"
    end
    return lia.db.query(statement):next(function(result) return result.results end)
end

function lia.db.fieldExists(name, field)
    return lia.db.getColumns(name):next(function(columns)
        for _, column in ipairs(columns) do
            if column.name == field then return true end
        end
        return false
    end)
end

function lia.db.indexExists(name, indexName)
    local statement
    if mysql.module == "sqlite" then
        statement = "PRAGMA index_list(" .. mysql:QuoteIdentifier(name) .. ")"
    else
        statement = "SELECT INDEX_NAME AS name FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = " .. mysql:Value(name) .. " AND INDEX_NAME = " .. mysql:Value(indexName)
    end
    return lia.db.query(statement):next(function(result)
        for _, row in ipairs(result.results) do
            if row.name == indexName then return true end
        end
        return false
    end)
end

function lia.db.transaction(statements)
    local promise = deferred.new()
    mysql:Transaction(statements, function() promise:resolve(true) end, function(message) promise:reject(message) end)
    return promise
end

local typeAliases = {
    string = "VARCHAR(255)",
    text = "LONGTEXT",
    integer = "INT",
    int = "INT",
    float = "FLOAT",
    boolean = "TINYINT(1)",
    datetime = "DATETIME"
}

local function normalizeType(value)
    return typeAliases[string.lower(tostring(value))] or string.upper(tostring(value))
end

function lia.db.createTable(dbName, primaryKey, schema)
    local promise = deferred.new()
    local query = mysql:Create(tableName(dbName))
    for _, column in ipairs(schema) do
        local definition = normalizeType(column.type)
        if column.not_null then definition = definition .. " NOT NULL" end
        if column.default ~= nil and not (mysql.module == "mysqloo" and (definition:find("TEXT", 1, true) or definition:find("BLOB", 1, true))) then definition = definition .. " DEFAULT " .. mysql:Value(column.default) end
        query:Create(column.name, definition)
    end

    if primaryKey then query:PrimaryKey(primaryKey) end
    query:Callback(function() promise:resolve(true) end)
    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

function lia.db.createColumn(dbName, columnName, columnType, defaultValue)
    local promise = deferred.new()
    local name = tableName(dbName)
    lia.db.fieldExists(name, columnName):next(function(exists)
        if exists then
            promise:resolve(false)
            return
        end

        local definition = normalizeType(columnType)
        if defaultValue ~= nil and not (mysql.module == "mysqloo" and (definition:find("TEXT", 1, true) or definition:find("BLOB", 1, true))) then definition = definition .. " DEFAULT " .. mysql:Value(defaultValue) end
        local query = mysql:Alter(name)
        query:Add(columnName, definition)
        query:Callback(function() promise:resolve(true) end)
        query:ErrorCallback(function(message) promise:reject(message) end)
        query:Execute()
    end):catch(function(message) promise:reject(message) end)
    return promise
end

function lia.db.removeTable(dbName)
    local promise = deferred.new()
    local query = mysql:Drop(tableName(dbName))
    query:Callback(function() promise:resolve(true) end)
    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

function lia.db.removeColumn(dbName, columnName)
    local promise = deferred.new()
    local query = mysql:Alter(tableName(dbName))
    query:Drop(columnName)
    query:Callback(function() promise:resolve(true) end)
    query:ErrorCallback(function(message) promise:reject(message) end)
    query:Execute()
    return promise
end

local schema = {
    lia_players = {
        pk = nil,
        columns = {
            steamID = "VARCHAR(32)",
            steamName = "VARCHAR(255)",
            firstJoin = "DATETIME",
            lastJoin = "DATETIME",
            userGroup = "VARCHAR(64)",
            data = "LONGTEXT",
            lastIP = "VARCHAR(45)",
            lastOnline = "INT",
            totalOnlineTime = "FLOAT"
        }
    },
    lia_chardata = {
        pk = {"charID", "key"},
        columns = {
            charID = "INT NOT NULL",
            key = "VARCHAR(255) NOT NULL",
            value = "LONGTEXT"
        }
    },
    lia_characters = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            steamID = "VARCHAR(32)",
            name = "VARCHAR(255)",
            desc = "LONGTEXT",
            model = "LONGTEXT",
            attribs = "LONGTEXT",
            schema = "VARCHAR(255)",
            createTime = "DATETIME",
            lastJoinTime = "DATETIME",
            money = "VARCHAR(255)",
            faction = "VARCHAR(255)",
            recognition = "LONGTEXT",
            fakenames = "LONGTEXT"
        }
    },
    lia_inventories = {
        pk = "invID",
        columns = {
            invID = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            charID = "INT",
            invType = "VARCHAR(255)"
        }
    },
    lia_items = {
        pk = "itemID",
        columns = {
            itemID = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            invID = "INT",
            uniqueID = "VARCHAR(255)",
            data = "LONGTEXT",
            quantity = "INT",
            x = "INT",
            y = "INT"
        }
    },
    lia_invdata = {
        pk = {"invID", "key"},
        columns = {
            invID = "INT NOT NULL",
            key = "VARCHAR(255) NOT NULL",
            value = "LONGTEXT"
        }
    },
    lia_logs = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            timestamp = "DATETIME",
            gamemode = "VARCHAR(255)",
            category = "VARCHAR(255)",
            message = "LONGTEXT",
            charID = "INT",
            steamID = "VARCHAR(32)"
        }
    },
    lia_ticketclaims = {
        columns = {
            timestamp = "DATETIME",
            requester = "LONGTEXT",
            requesterSteamID = "VARCHAR(32)",
            admin = "LONGTEXT",
            adminSteamID = "VARCHAR(32)",
            message = "LONGTEXT"
        }
    },
    lia_warnings = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            charID = "INT",
            warned = "LONGTEXT",
            warnedSteamID = "VARCHAR(32)",
            timestamp = "DATETIME",
            message = "LONGTEXT",
            warner = "LONGTEXT",
            warnerSteamID = "VARCHAR(32)",
            severity = "VARCHAR(32) DEFAULT 'Medium'"
        }
    },
    lia_permakills = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            player = "VARCHAR(255) NOT NULL",
            reason = "VARCHAR(255)",
            steamID = "VARCHAR(32)",
            charID = "INT",
            submitterName = "VARCHAR(255)",
            submitterSteamID = "VARCHAR(32)",
            timestamp = "INT",
            evidence = "VARCHAR(255)"
        }
    },
    lia_bans = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            player = "VARCHAR(255) NOT NULL",
            playerSteamID = "VARCHAR(32)",
            reason = "VARCHAR(255)",
            bannerName = "VARCHAR(255)",
            bannerSteamID = "VARCHAR(32)",
            timestamp = "INT",
            evidence = "VARCHAR(255)"
        }
    },
    lia_staffactions = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            player = "VARCHAR(255) NOT NULL",
            playerSteamID = "VARCHAR(32)",
            steamID = "VARCHAR(32)",
            action = "VARCHAR(255)",
            staffName = "VARCHAR(255)",
            staffSteamID = "VARCHAR(32)",
            timestamp = "INT"
        }
    },
    lia_doors = {
        pk = {"gamemode", "map", "id"},
        columns = {
            gamemode = "VARCHAR(255) NOT NULL",
            map = "VARCHAR(255) NOT NULL",
            id = "INT NOT NULL",
            factions = "LONGTEXT",
            classes = "LONGTEXT",
            disabled = "INT",
            hidden = "INT",
            ownable = "INT",
            name = "LONGTEXT",
            price = "INT",
            locked = "INT",
            ownerSteamID = "LONGTEXT"
        }
    },
    lia_persistence = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            gamemode = "VARCHAR(255)",
            map = "VARCHAR(255)",
            class = "VARCHAR(255)",
            pos = "LONGTEXT",
            angles = "LONGTEXT",
            model = "LONGTEXT",
            data = "LONGTEXT"
        }
    },
    lia_saveditems = {
        pk = "id",
        columns = {
            id = "INT UNSIGNED NOT NULL AUTO_INCREMENT",
            schema = "VARCHAR(255)",
            map = "VARCHAR(255)",
            itemID = "INT",
            pos = "LONGTEXT",
            angles = "LONGTEXT"
        }
    },
    lia_admin = {
        pk = "usergroup",
        columns = {
            usergroup = "VARCHAR(64) NOT NULL",
            privileges = "LONGTEXT",
            inheritance = "LONGTEXT",
            types = "LONGTEXT"
        }
    }
}

local function schemaTasks()
    local tasks, names = {}, {}
    for name in pairs(schema) do
        names[#names + 1] = name
    end

    table.sort(names)
    for _, name in ipairs(names) do
        local definition = schema[name]
        tasks[#tasks + 1] = function(done, failed)
            local query = mysql:Create(name)
            for _, column in ipairs(sortedKeys(definition.columns)) do
                query:Create(column, definition.columns[column])
            end

            if definition.pk then query:PrimaryKey(definition.pk) end
            query:Callback(done)
            query:ErrorCallback(failed)
            query:Execute()
        end
    end
    return tasks
end

local function migrationTasks()
    local tasks, names = {}, {}
    for name in pairs(schema) do
        names[#names + 1] = name
    end

    table.sort(names)
    for _, name in ipairs(names) do
        local definition = schema[name]
        for _, column in ipairs(sortedKeys(definition.columns)) do
            tasks[#tasks + 1] = function(done, failed)
                lia.db.fieldExists(name, column):next(function(exists)
                    if exists then
                        done()
                        return
                    end

                    local columnDefinition = definition.columns[column]
                    -- Adding a key/identity constraint to populated tables is destructive.
                    -- Add the missing storage column as nullable and leave existing keys intact.
                    columnDefinition = columnDefinition:gsub("%s+AUTO_INCREMENT", ""):gsub("%s+NOT NULL", ""):gsub("%s+UNSIGNED", "")
                    local query = mysql:Alter(name)
                    query:Add(column, columnDefinition)
                    query:Callback(done)
                    query:ErrorCallback(failed)
                    query:Execute()
                end):catch(failed)
            end
        end
    end
    return tasks
end

function lia.db.addDatabaseFields(callback)
    local fields = {}
    if istable(lia.char.vars) then
        for _, data in pairs(lia.char.vars) do
            if data.field and typeAliases[data.fieldType] then
                local definition = typeAliases[data.fieldType]
                if data.default ~= nil and not (mysql.module == "mysqloo" and (data.fieldType == "text" or istable(data.default))) then definition = definition .. " DEFAULT " .. mysql:Value(data.default) end
                fields[data.field] = definition
            end
        end
    end

    local tasks = {}
    for _, field in ipairs(sortedKeys(fields)) do
        tasks[#tasks + 1] = function(done, failed)
            lia.db.fieldExists("lia_characters", field):next(function(exists)
                if exists then
                    done()
                    return
                end

                local query = mysql:Alter("lia_characters")
                query:Add(field, fields[field])
                query:Callback(done)
                query:ErrorCallback(failed)
                query:Execute()
            end):catch(failed)
        end
    end

    runSeries(tasks, callback, function(message)
        lia.error("Dynamic database migration failed: " .. tostring(message))
        if isfunction(callback) then callback() end
    end)
end

function lia.db.ensureIndexes(callback)
    local indexes = {{"lia_players", "idx_lia_players_steamID", {"steamID"}}, {"lia_characters", "idx_lia_characters_steamID_schema", {"steamID", "schema"}}, {"lia_inventories", "idx_lia_inventories_charID", {"charID"}}, {"lia_items", "idx_lia_items_invID", {"invID"}}}
    local tasks = {}
    for _, index in ipairs(indexes) do
        tasks[#tasks + 1] = function(done, failed)
            lia.db.indexExists(index[1], index[2]):next(function(exists)
                if exists then
                    done()
                    return
                end

                local columns = {}
                for i = 1, #index[3] do
                    columns[i] = mysql:QuoteIdentifier(index[3][i])
                end

                lia.db.query("CREATE INDEX " .. mysql:QuoteIdentifier(index[2]) .. " ON " .. mysql:QuoteIdentifier(index[1]) .. " (" .. table.concat(columns, ", ") .. ")", done, failed)
            end):catch(failed)
        end
    end

    runSeries(tasks, callback, function(message)
        lia.error("Database index migration failed: " .. tostring(message))
        if isfunction(callback) then callback() end
    end)
end

function lia.db.loadTables(callback)
    if lia.db.tablesLoaded then
        if isfunction(callback) then callback() end
        return
    end

    if lia.db.schemaLoading then
        if isfunction(callback) then lia.db.schemaCallbacks[#lia.db.schemaCallbacks + 1] = callback end
        return
    end

    lia.db.schemaLoading = true
    if isfunction(callback) then lia.db.schemaCallbacks[#lia.db.schemaCallbacks + 1] = callback end
    runSeries(schemaTasks(), function()
        runSeries(migrationTasks(), function()
            hook.Run("OnLoadTables")
            lia.db.addDatabaseFields(function()
                lia.db.ensureIndexes(function()
                    lia.db.schemaLoading, lia.db.tablesLoaded = false, true
                    local callbacks = lia.db.schemaCallbacks
                    lia.db.schemaCallbacks = {}
                    for _, queuedCallback in ipairs(callbacks) do
                        queuedCallback()
                    end

                    hook.Run("OnDatabaseLoaded")
                    timer.Simple(0, function() lia.config.load() end)
                    timer.Simple(0.1, function()
                        lia.config.send()
                        lia.playerinteract.sync()
                        lia.item.loadWeaponOverrides()
                        lia.item.loadWeaponRuntimeOverrides()
                    end)
                end)
            end)
        end, function(message)
            lia.db.schemaLoading = false
            lia.error("Database schema migration failed: " .. tostring(message))
            hook.Run("DatabaseSchemaFailed", message)
        end)
    end, function(message)
        lia.db.schemaLoading = false
        lia.error("Database schema initialization failed: " .. tostring(message))
        hook.Run("DatabaseSchemaFailed", message)
    end)
end

function lia.db.waitForTablesToLoad()
    if lia.db.tablesLoaded then return resolved(true) end
    local promise = deferred.new()
    local identifier = "liaDatabaseWait" .. tostring(promise)
    hook.Add("OnDatabaseLoaded", identifier, function()
        hook.Remove("OnDatabaseLoaded", identifier)
        promise:resolve(true)
    end)
    return promise
end

function lia.db.getCharacterTable(callback)
    lia.db.getColumns("lia_characters"):next(function(rows)
        local columns = {}
        for _, row in ipairs(rows) do
            columns[#columns + 1] = row.name
        end

        callback(columns)
    end):catch(function(message)
        lia.error("Failed to inspect character table: " .. tostring(message))
        callback({})
    end)
end

function lia.db.createSnapshot(dbName)
    local promise, fullName = deferred.new(), tableName(dbName)
    lia.db.tableExists(fullName):next(function(exists)
        if not exists then
            promise:reject("Table " .. fullName .. " does not exist")
            return
        end

        lia.db.query("SELECT * FROM " .. mysql:QuoteIdentifier(fullName)):next(function(result)
            local snapshot = {
                table = tostring(dbName):gsub("^lia_", ""),
                timestamp = os.time(),
                data = result.results
            }

            local fileName = "snapshot_" .. snapshot.table .. "_" .. snapshot.timestamp .. ".json"
            local path = "lilia/snapshots/" .. fileName
            file.CreateDir("lilia/snapshots")
            file.Write(path, util.TableToJSON(snapshot, true))
            promise:resolve({
                file = fileName,
                path = path,
                records = #snapshot.data
            })
        end):catch(function(message) promise:reject(message) end)
    end):catch(function(message) promise:reject(message) end)
    return promise
end

function lia.db.loadSnapshot(fileName)
    local promise, path = deferred.new(), "lilia/snapshots/" .. tostring(fileName)
    if not file.Exists(path, "DATA") then
        promise:reject("Snapshot file not found")
        return promise
    end

    local snapshot = util.JSONToTable(file.Read(path, "DATA") or "")
    if not snapshot or not snapshot.table or not istable(snapshot.data) then
        promise:reject("Invalid snapshot format")
        return promise
    end

    local fullName = tableName(snapshot.table)
    lia.db.tableExists(fullName):next(function(exists)
        if not exists then
            promise:reject("Target table " .. fullName .. " does not exist")
            return
        end

        local statements = {mysql:Truncate(fullName):Build()}
        for _, row in ipairs(snapshot.data) do
            statements[#statements + 1] = insertSQL(row, snapshot.table)
        end

        lia.db.transaction(statements):next(function()
            promise:resolve({
                table = snapshot.table,
                records = #snapshot.data,
                timestamp = snapshot.timestamp
            })
        end):catch(function(message) promise:reject(message) end)
    end):catch(function(message) promise:reject(message) end)
    return promise
end

function lia.db.wipeTables(callback)
    lia.db.getTables():next(function(names)
        local tasks = {}
        for _, name in ipairs(names) do
            tasks[#tasks + 1] = function(done, failed)
                local query = mysql:Drop(name)
                query:Callback(done)
                query:ErrorCallback(failed)
                query:Execute()
            end
        end

        runSeries(tasks, function()
            lia.db.tablesLoaded = false
            MsgC(Color(255, 255, 0), "[Lilia] Wiped tables: " .. table.concat(names, ", ") .. "\n")
            if isfunction(callback) then callback() end
        end, function(message) lia.error("Database wipe failed: " .. tostring(message)) end)
    end):catch(function(message) lia.error("Could not list tables for wipe: " .. tostring(message)) end)
end

function lia.db.wipeCharacters()
    return lia.db.transaction({"DELETE FROM `lia_chardata`", "DELETE FROM `lia_items`", "DELETE FROM `lia_invdata`", "DELETE FROM `lia_inventories`", "DELETE FROM `lia_characters`"})
end

function lia.db.wipeLogs()
    return lia.db.query("DELETE FROM `lia_logs`")
end

function lia.db.wipeBans()
    return lia.db.query("DELETE FROM `lia_bans`")
end

function lia.db.fixCharacters()
    return lia.db.addDatabaseFields()
end

function GM:SetupDatabase()
    local defaults = {
        adapter = "sqlite",
        hostname = "127.0.0.1",
        username = "",
        password = "",
        database = "",
        port = 3306
    }

    local databasePath = engine.ActiveGamemode() .. "/schema/database.lua"
    local config = file.Exists(databasePath, "LUA") and include(databasePath) or {}
    config = istable(config) and config or {}
    if config.module and not config.adapter then config.adapter = config.module end
    for key, value in pairs(defaults) do
        if config[key] == nil then config[key] = value end
    end

    lia.db.config = config
    for key, value in pairs(config) do
        lia.db[key] = value
    end

    lia.db.module = config.adapter
end

function GM:DatabaseConnected()
    lia.bootstrap("Database", string.format("Lilia is ready using %s.", lia.db.module))
end
