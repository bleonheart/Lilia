local running = false

local function assertEqual(actual, expected, message)
    if actual ~= expected then error((message or "Unexpected value") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2) end
end

local function assertTrue(value, message)
    if not value then error(message or "Assertion failed", 2) end
end

local function resultRows(result)
    return istable(result) and istable(result.results) and result.results or {}
end

local function hasColumn(columns, name)
    for _, column in ipairs(columns or {}) do
        if column.name == name then return true end
    end
    return false
end

local function hasTable(tables, name)
    for _, entry in ipairs(tables or {}) do
        if entry == name then return true end
    end
    return false
end

concommand.Add("lia_db_test", function(client)
    if IsValid(client) then
        client:PrintMessage(HUD_PRINTCONSOLE, "[Lilia DB Test] This command must be run from the dedicated server console.\n")
        return
    end

    if running then
        print("[Lilia DB Test] A test is already running.")
        return
    end

    if not lia or not lia.db or not lia.db.connected or not lia.db.tablesLoaded then
        print("[Lilia DB Test] The database is not connected or its tables are not loaded.")
        return
    end

    running = true
    local tableName = "dbtest_" .. os.time() .. "_" .. math.random(100000, 999999)
    local fullTableName = "lia_" .. tableName
    local escapedTable = lia.db.escapeIdentifier(fullTableName)
    local legacyTableName = tableName .. "_legacy"
    local legacyFullTableName = "lia_" .. legacyTableName
    local legacyEscapedTable = lia.db.escapeIdentifier(legacyFullTableName)
    local owned = false
    local legacyOwned = false
    local snapshotFile
    local snapshotPath
    local snapshotRecords
    local primaryID
    local reservedID
    local passed = 0
    local failed = 0
    local skipped = 0
    local failures = {}
    local finished = false
    local tests = {}
    local original = "Lilia's UTF-8 café 日本語 🚀"
    local updated = "Lilia's test ' OR 1=1 -- \\ end"

    local function log(message)
        print("[Lilia DB Test] " .. message)
    end

    local function add(name, run, critical)
        tests[#tests + 1] = {
            name = name,
            run = run,
            critical = critical
        }
    end

    local function checkPromise(factory, verify, pass, fail)
        local ok, promise = pcall(factory)
        if not ok then
            fail(promise)
            return
        end

        if not istable(promise) or not isfunction(promise.next) then
            fail("Database function did not return a promise")
            return
        end

        promise:next(function(result)
            local verified, err = pcall(verify or function() end, result)
            if verified then
                pass()
            else
                fail(err)
            end
        end, fail)
    end

    local function addPromise(name, factory, verify, critical)
        add(name, function(pass, fail)
            checkPromise(factory, verify, pass, fail)
        end, critical)
    end

    local function addExpectedRejection(name, factory)
        add(name, function(pass, fail)
            local ok, promise = pcall(factory)
            if not ok then
                fail("Function threw instead of rejecting: " .. tostring(promise))
                return
            end

            if not istable(promise) or not isfunction(promise.next) then
                fail("Database function did not return a promise")
                return
            end

            promise:next(function()
                fail("Expected a rejected promise")
            end, function(err)
                if err == nil or tostring(err) == "" then
                    fail("Rejection did not provide an error")
                else
                    pass()
                end
            end)
        end)
    end

    local function cleanup()
        if finished then return end
        finished = true
        if snapshotPath and file.Exists(snapshotPath, "DATA") then file.Delete(snapshotPath) end

        local function summary(message)
            running = false
            if message then log(message) end
            log(string.format("RESULT: %d passed, %d failed, %d skipped (%d checks), backend=%s", passed, failed, skipped, #tests, tostring(lia.db.module)))
            for _, failure in ipairs(failures) do
                log("FAIL: " .. failure)
            end
        end

        local remaining = {}
        if legacyOwned then remaining[#remaining + 1] = {name = legacyTableName, full = legacyFullTableName} end
        if owned then remaining[#remaining + 1] = {name = tableName, full = fullTableName} end
        if #remaining == 0 then
            summary()
            return
        end

        local done = false
        local timerName = "lia_db_test_cleanup_" .. tableName
        local position = 0
        local function finishCleanup(message)
            if done then return end
            done = true
            timer.Remove(timerName)
            summary(message)
        end

        local function cleanupError(message)
            failed = failed + 1
            failures[#failures + 1] = "Cleanup: " .. message
        end

        local function removeNext()
            if done then return end
            position = position + 1
            local entry = remaining[position]
            if not entry then
                finishCleanup("Temporary tables cleaned up.")
                return
            end

            timer.Create(timerName, 45, 1, function()
                cleanupError("Timed out removing " .. entry.full .. "; inspect this table manually")
                finishCleanup("Cleanup incomplete.")
            end)

            local ok, err = pcall(function()
                lia.db.removeTable(entry.name):next(function()
                    timer.Remove(timerName)
                    removeNext()
                end, function(reason)
                    timer.Remove(timerName)
                    cleanupError("Failed removing " .. entry.full .. ": " .. tostring(reason))
                    removeNext()
                end)
            end)
            if not ok then
                timer.Remove(timerName)
                cleanupError("Error removing " .. entry.full .. ": " .. tostring(err))
                removeNext()
            end
        end

        removeNext()
    end

    add("Connection via callback", function(pass, fail)
        lia.db.query("SELECT 1 AS result", function(rows)
            local ok, err = pcall(function()
                assertTrue(istable(rows) and istable(rows[1]), "Connection query did not return a row")
                assertEqual(tonumber(rows[1].result), 1)
            end)
            if ok then pass() else fail(err) end
        end, fail)
    end)

    addPromise("Connection via promise", function()
        return lia.db.query("SELECT 2 AS result")
    end, function(result)
        local rows = resultRows(result)
        assertEqual(tonumber(rows[1] and rows[1].result), 2)
    end)

    add("Value conversion and SQL identifiers", function(pass, fail)
        local ok, err = pcall(function()
            assertEqual(lia.db.escapeIdentifier("desc"), "`desc`")
            assertEqual(lia.db.escapeIdentifier("table.desc"), "`table`.`desc`")
            assertEqual(lia.db.escapeIdentifier("*"), "*")
            assertEqual(lia.db.escapeIdentifier("some`name"), "`some``name`")
            assertEqual(lia.db.convertDataType(nil), "NULL")
            assertEqual(lia.db.convertDataType(true), "1")
            assertEqual(lia.db.convertDataType(false), "0")
            assertEqual(lia.db.convertDataType(42), "42")
            assertTrue(not pcall(lia.db.escapeIdentifier, "bad..identifier"), "Invalid identifier was accepted")
            assertTrue(not pcall(lia.db.escapeIdentifier, ".bad"), "Invalid leading dot was accepted")
            assertTrue(not pcall(lia.db.convertDataType, 0 / 0), "NaN was accepted")
            assertTrue(isstring(lia.db.convertDataType({valid = true})), "JSON encoding failed")
        end)
        if ok then pass() else fail(err) end
    end)

    add("Direct value escaping", function(pass, fail)
        local ok, err = pcall(function()
            local value = lia.db.escape("O'Reilly")
            assertTrue(isstring(value) and value ~= "O'Reilly", "Quote was not escaped")
        end)
        if ok then pass() else fail(err) end
    end)

    add("MariaDB escaping regression", function(pass, fail, skip)
        if lia.db.module ~= "mysqloo" then
            skip("MariaDB-specific escaping")
            return
        end

        local ok, err = pcall(function()
            assertEqual(lia.db.escape("admin"), "admin", "Normal group name was corrupted")
            assertEqual(lia.db.convertDataType("admin"), "'admin'", "Normal SQL string was corrupted")
            local escapedNul = lia.db.escape("a" .. string.char(0) .. "b")
            assertTrue(not escapedNul:find("%z"), "NUL was not escaped")
            assertTrue(escapedNul:find("\\0", 1, true), "Escaped NUL sequence was not preserved")
        end)
        if ok then pass() else fail(err) end
    end)

    addPromise("Admin usergroup name integrity", function()
        return lia.db.select("usergroup", "admin")
    end, function(result)
        for _, row in ipairs(resultRows(result)) do
            assertTrue(isstring(row.usergroup) and not row.usergroup:find("%z"), "Corrupted admin usergroup is still stored")
        end
    end)

    addPromise("Existing character table metadata", function()
        return lia.db.tableExists("lia_characters")
    end, function(exists)
        assertTrue(exists, "Existing character table not found")
    end)

    addPromise("Existing character name column metadata", function()
        return lia.db.fieldExists("lia_characters", "name")
    end, function(exists)
        assertTrue(exists, "Existing character name column not found")
    end)

    addPromise("Existing character desc column metadata", function()
        return lia.db.fieldExists("lia_characters", "desc")
    end, function(exists)
        assertTrue(exists, "Existing reserved-word desc column not found")
    end)

    add("getCharacterTable callback", function(pass, fail)
        lia.db.getCharacterTable(function(columns)
            if istable(columns) then
                pass()
            else
                fail("getCharacterTable did not return a column list")
            end
        end)
    end)

    addPromise("Empty bulkInsert is a no-op", function()
        return lia.db.bulkInsert(tableName, {})
    end)

    addPromise("Empty bulkUpsert is a no-op", function()
        return lia.db.bulkUpsert(tableName, {})
    end)

    addPromise("Temporary table collision check", function()
        return lia.db.tableExists(fullTableName)
    end, function(exists)
        assertTrue(not exists, "Generated test table already exists; refusing to overwrite it")
    end, true)

    addPromise("Create table", function()
        owned = true
        return lia.db.createTable(tableName, "id", {
            {name = "id", type = "integer", auto_increment = true},
            {name = "payload", type = "string", length = 255},
            {name = "score", type = "integer", default = 0},
            {name = "note", type = "text"},
            {name = "flag", type = "boolean", default = false},
            {name = "desc", type = "string", length = 128}
        })
    end, function(result)
        assertTrue(result == true, "createTable did not confirm creation")
    end, true)

    addPromise("Create table idempotency", function()
        return lia.db.createTable(tableName, "id", {
            {name = "id", type = "integer", auto_increment = true},
            {name = "payload", type = "string", length = 255}
        })
    end)

    addPromise("tableExists positive", function()
        return lia.db.tableExists(fullTableName)
    end, function(exists)
        assertTrue(exists, "Test table not found")
    end)

    addPromise("tableExists negative", function()
        return lia.db.tableExists(fullTableName .. "_missing")
    end, function(exists)
        assertTrue(not exists, "Nonexistent table was reported present")
    end)

    addPromise("getTables lists test table", function()
        return lia.db.getTables()
    end, function(tables)
        assertTrue(hasTable(tables, fullTableName), "Test table missing from getTables")
    end)

    addPromise("fieldExists positive", function()
        return lia.db.fieldExists(fullTableName, "desc")
    end, function(exists)
        assertTrue(exists, "Reserved-word column missing")
    end)

    addPromise("fieldExists negative", function()
        return lia.db.fieldExists(fullTableName, "missing_column")
    end, function(exists)
        assertTrue(not exists, "Nonexistent column reported present")
    end)

    addPromise("getTableColumnInfo", function()
        return lia.db.getTableColumnInfo(fullTableName)
    end, function(columns)
        assertTrue(hasColumn(columns, "id"), "Missing id column")
        assertTrue(hasColumn(columns, "payload"), "Missing payload column")
        assertTrue(hasColumn(columns, "desc"), "Missing reserved-word column")
    end)

    add("Legacy PRAGMA table_info compatibility", function(pass, fail)
        lia.db.query("PRAGMA table_info(" .. lia.db.escapeIdentifier(fullTableName) .. ")", function(columns)
            local ok, err = pcall(function()
                assertTrue(hasColumn(columns, "payload"), "PRAGMA compatibility did not return column names")
            end)
            if ok then pass() else fail(err) end
        end, fail)
    end)

    addPromise("createColumn", function()
        return lia.db.createColumn(tableName, "extra", "integer", 7)
    end, function(created)
        assertTrue(created, "createColumn did not add a column")
    end)

    addPromise("createColumn idempotency", function()
        return lia.db.createColumn(tableName, "extra", "integer", 7)
    end, function(created)
        assertEqual(created, false)
    end)

    add("Concurrent createColumn requests", function(pass, fail)
        local ok, first = pcall(lia.db.createColumn, tableName, "concurrent_col", "integer", 3)
        if not ok then
            fail(first)
            return
        end

        local secondOk, second = pcall(lia.db.createColumn, tableName, "concurrent_col", "integer", 3)
        if not secondOk then
            fail(second)
            return
        end

        if lia.db.module == "mysqloo" and first ~= second then
            fail("Concurrent operations were not coalesced")
            return
        end

        local received = 0
        local results = {}
        local function onResult(index, value)
            results[index] = value
            received = received + 1
            if received ~= 2 then return end
            if results[1] ~= true then
                fail("First createColumn request did not create the column")
            elseif lia.db.module == "mysqloo" and results[2] ~= true then
                fail("Coalesced createColumn request returned a different result")
            elseif lia.db.module ~= "mysqloo" and results[2] ~= true and results[2] ~= false then
                fail("Second createColumn request returned an unexpected result")
            else
                pass()
            end
        end

        first:next(function(value) onResult(1, value) end, fail)
        second:next(function(value) onResult(2, value) end, fail)
    end)

    addPromise("Concurrent createColumn metadata", function()
        return lia.db.fieldExists(fullTableName, "concurrent_col")
    end, function(exists)
        assertTrue(exists, "Concurrent column was not added")
    end)

    addPromise("New column metadata", function()
        return lia.db.getTableColumnInfo(fullTableName)
    end, function(columns)
        assertTrue(hasColumn(columns, "extra"), "Added column missing from schema")
    end)

    addPromise("removeColumn on missing column", function()
        return lia.db.removeColumn(tableName, "missing_column")
    end, function(removed)
        assertEqual(removed, false)
    end)

    addPromise("insertTable with Unicode and quoted identifier", function()
        return lia.db.insertTable({payload = original, score = 5, note = "initial", flag = true, desc = "reserved name"}, nil, tableName)
    end, function(result)
        primaryID = tonumber(result and result.lastID)
        assertTrue(primaryID and primaryID > 0, "Missing auto-increment ID")
    end)

    addPromise("selectOne round-trip", function()
        return lia.db.selectOne({"id", "payload", "desc", "score"}, tableName, {id = primaryID})
    end, function(row)
        assertTrue(istable(row), "No inserted row")
        assertEqual(row.payload, original)
        assertEqual(row.desc, "reserved name")
        assertEqual(tonumber(row.score), 5)
    end)

    addPromise("select array of fields", function()
        return lia.db.select({"id", "payload"}, tableName, {id = primaryID}, 1)
    end, function(result)
        local rows = resultRows(result)
        assertEqual(#rows, 1)
        assertEqual(rows[1].payload, original)
    end)

    addPromise("count filtered", function()
        return lia.db.count(tableName, {id = primaryID})
    end, function(count)
        assertEqual(count, 1)
    end)

    addPromise("exists positive", function()
        return lia.db.exists(tableName, {id = primaryID})
    end, function(exists)
        assertTrue(exists)
    end)

    addPromise("selectOne missing row", function()
        return lia.db.selectOne("*", tableName, {id = -1})
    end, function(row)
        assertEqual(row, nil)
    end)

    addPromise("updateTable and table serialization", function()
        return lia.db.updateTable({payload = updated, note = {enabled = true, label = "O'Reilly"}, desc = "updated desc"}, nil, tableName, {id = primaryID})
    end)

    addPromise("Verify update and decoded JSON", function()
        return lia.db.selectOne("*", tableName, {id = primaryID})
    end, function(row)
        assertEqual(row.payload, updated)
        assertEqual(row.desc, "updated desc")
        local note = util.JSONToTable(row.note or "")
        assertTrue(istable(note), "Stored table was not valid JSON")
        assertEqual(note.enabled, true)
        assertEqual(note.label, "O'Reilly")
    end)

    addPromise("bulkInsert", function()
        return lia.db.bulkInsert(tableName, {
            {payload = "bulk-a", score = 10, note = "filled", flag = false, desc = "a"},
            {payload = "bulk-b", score = 20, note = "filled", flag = false, desc = "b"},
            {payload = "bulk-c", score = 30, note = "filled", flag = false, desc = "c"}
        })
    end)

    addPromise("Verify bulk insert", function()
        return lia.db.count(tableName)
    end, function(count)
        assertEqual(count, 4)
    end)

    addPromise("Injection-like value treated as literal", function()
        return lia.db.count(tableName, {payload = updated})
    end, function(count)
        assertEqual(count, 1, "SQL condition did not safely match literal quotes")
    end)

    addPromise("gt condition", function()
        return lia.db.count(tableName, {score = lia.db.gt(10)})
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("gte condition", function()
        return lia.db.count(tableName, {score = lia.db.gte(20)})
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("lt condition", function()
        return lia.db.count(tableName, {score = lia.db.lt(20)})
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("lte condition", function()
        return lia.db.count(tableName, {score = lia.db.lte(10)})
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("neq condition", function()
        return lia.db.count(tableName, {score = lia.db.neq(5)})
    end, function(count)
        assertEqual(count, 3)
    end)

    addPromise("eq condition", function()
        return lia.db.count(tableName, {score = lia.db.eq(5)})
    end, function(count)
        assertEqual(count, 1)
    end)

    addPromise("like condition", function()
        return lia.db.count(tableName, {payload = lia.db.like("bulk%")})
    end, function(count)
        assertEqual(count, 3)
    end)

    addPromise("notLike condition", function()
        return lia.db.count(tableName, {payload = lia.db.notLike("bulk%")})
    end, function(count)
        assertEqual(count, 1)
    end)

    addPromise("inList condition", function()
        return lia.db.count(tableName, {score = lia.db.inList({10, 30})})
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("notInList condition", function()
        return lia.db.count(tableName, {score = lia.db.notInList({10, 30})})
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("Empty IN condition", function()
        return lia.db.count(tableName, {score = lia.db.inList({})})
    end, function(count)
        assertEqual(count, 0)
    end)

    addPromise("Empty NOT IN condition", function()
        return lia.db.count(tableName, {score = lia.db.notInList({})})
    end, function(count)
        assertEqual(count, 4)
    end)

    addPromise("Insert nullable row", function()
        return lia.db.insertTable({payload = "nullable", score = 99}, nil, tableName)
    end)

    addPromise("isNull condition", function()
        return lia.db.count(tableName, {note = lia.db.isNull()})
    end, function(count)
        assertEqual(count, 1)
    end)

    addPromise("isNotNull condition", function()
        return lia.db.count(tableName, {note = lia.db.isNotNull()})
    end, function(count)
        assertEqual(count, 4)
    end)

    addPromise("andGroup with numeric comparisons", function()
        return lia.db.count(tableName, lia.db.andGroup({score = lia.db.gte(10)}, {score = lia.db.lte(20)}))
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("orGroup and nested conditions", function()
        return lia.db.count(tableName, lia.db.andGroup({score = lia.db.gte(10)}, lia.db.orGroup({score = 10}, {score = 30})))
    end, function(count)
        assertEqual(count, 2)
    end)

    addPromise("selectWithCondition ASC and offset", function()
        return lia.db.selectWithCondition({"score", "payload"}, tableName, {}, 2, lia.db.orderAsc("score"), {offset = 1})
    end, function(result)
        local rows = resultRows(result)
        assertEqual(#rows, 2)
        assertEqual(tonumber(rows[1].score), 10)
        assertEqual(tonumber(rows[2].score), 20)
    end)

    addPromise("select DESC with options", function()
        return lia.db.select("score", tableName, {}, 2, {order = lia.db.orderDesc("score"), offset = 1})
    end, function(result)
        local rows = resultRows(result)
        assertEqual(#rows, 2)
        assertEqual(tonumber(rows[1].score), 30)
        assertEqual(tonumber(rows[2].score), 20)
    end)

    addPromise("selectOne with ordering", function()
        return lia.db.selectOne("score", tableName, nil, {order = lia.db.orderDesc("score")})
    end, function(row)
        assertEqual(tonumber(row and row.score), 99)
    end)

    addPromise("Offset-only select", function()
        return lia.db.selectWithCondition("score", tableName, {score = lia.db.gte(10)}, nil, lia.db.orderAsc("score"), {offset = 1})
    end, function(result)
        assertTrue(#resultRows(result) >= 1, "Offset-only selection should return rows")
    end)

    addPromise("insertOrIgnore on primary key conflict", function()
        return lia.db.insertOrIgnore({id = primaryID, payload = "should-not-write"}, tableName)
    end)

    addPromise("Verify insertOrIgnore did not replace", function()
        return lia.db.selectOne("payload", tableName, {id = primaryID})
    end, function(row)
        assertEqual(row and row.payload, updated)
    end)

    addPromise("upsert updates existing primary key", function()
        return lia.db.upsert({id = primaryID, payload = "upsert-single", score = 5}, tableName)
    end)

    addPromise("Verify upsert", function()
        return lia.db.selectOne("payload", tableName, {id = primaryID})
    end, function(row)
        assertEqual(row and row.payload, "upsert-single")
    end)

    addPromise("bulkUpsert inserts and updates", function()
        return lia.db.bulkUpsert(tableName, {
            {id = primaryID, payload = "upsert-bulk", score = 5},
            {id = primaryID + 5000, payload = "upsert-new", score = 40}
        })
    end)

    addPromise("Verify bulkUpsert", function()
        return lia.db.select("id, payload", tableName, {id = lia.db.inList({primaryID, primaryID + 5000})})
    end, function(result)
        local found = {}
        for _, row in ipairs(resultRows(result)) do
            found[tonumber(row.id)] = row.payload
        end
        assertEqual(found[primaryID], "upsert-bulk")
        assertEqual(found[primaryID + 5000], "upsert-new")
    end)

    addPromise("Committed transaction", function()
        local value = lia.db.convertDataType("tx-committed")
        return lia.db.transaction({"INSERT INTO " .. escapedTable .. " (`payload`, `score`) VALUES (" .. value .. ", 12)"})
    end)

    addPromise("Verify committed transaction", function()
        return lia.db.count(tableName, {payload = "tx-committed"})
    end, function(count)
        assertEqual(count, 1)
    end)

    addExpectedRejection("Transaction rollback rejects invalid SQL", function()
        return lia.db.transaction({
            "INSERT INTO " .. escapedTable .. " (`payload`, `score`) VALUES (" .. lia.db.convertDataType("tx-rolled-back") .. ", 14)",
            "INSERT INTO " .. escapedTable .. " (`missing_column`) VALUES (1)"
        })
    end)

    addPromise("Verify failed transaction rolled back", function()
        return lia.db.count(tableName, {payload = "tx-rolled-back"})
    end, function(count)
        assertEqual(count, 0)
    end)

    add("Query failure callback", function(pass, fail)
        lia.db.query("SELECT `missing_column` FROM " .. escapedTable .. " LIMIT 1", function()
            fail("Invalid SELECT unexpectedly succeeded")
        end, function(err)
            if err == nil or tostring(err) == "" then
                fail("Query error callback received no error")
            else
                pass()
            end
        end)
    end)

    addPromise("delete matching record", function()
        return lia.db.delete(tableName, {payload = "tx-committed"})
    end)

    addPromise("Verify delete", function()
        return lia.db.exists(tableName, {payload = "tx-committed"})
    end, function(exists)
        assertEqual(exists, false)
    end)

    addPromise("createSnapshot", function()
        return lia.db.createSnapshot(tableName)
    end, function(result)
        assertTrue(istable(result), "No snapshot information")
        assertTrue(isstring(result.file) and isstring(result.path), "Missing snapshot file path")
        snapshotFile = result.file
        snapshotPath = result.path
        snapshotRecords = tonumber(result.records)
        assertTrue(file.Exists(snapshotPath, "DATA"), "Snapshot file was not written")
        assertTrue(snapshotRecords and snapshotRecords > 0, "Snapshot captured no rows")
    end)

    addPromise("truncate", function()
        return lia.db.truncate(tableName)
    end)

    addPromise("Verify truncate", function()
        return lia.db.count(tableName)
    end, function(count)
        assertEqual(count, 0)
    end)

    add("loadSnapshot", function(pass, fail, skip)
        if not snapshotFile then
            skip("No snapshot was created")
            return
        end
        checkPromise(function()
            return lia.db.loadSnapshot(snapshotFile)
        end, function(result)
            assertEqual(tonumber(result and result.records), snapshotRecords)
        end, pass, fail)
    end)

    add("Verify snapshot row count", function(pass, fail, skip)
        if not snapshotFile then
            skip("No snapshot was created")
            return
        end
        checkPromise(function()
            return lia.db.count(tableName)
        end, function(count)
            assertEqual(count, snapshotRecords)
        end, pass, fail)
    end)

    addPromise("Legacy SQL table name collision check", function()
        return lia.db.tableExists(legacyFullTableName)
    end, function(exists)
        assertTrue(not exists, "Legacy test table already exists")
    end, true)

    add("Legacy SQLite CREATE TABLE syntax", function(pass, fail)
        legacyOwned = true
        lia.db.query("CREATE TABLE IF NOT EXISTS " .. legacyEscapedTable .. " (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `payload` VARCHAR(255))", function()
            pass()
        end, fail)
    end)

    addPromise("Legacy SQL insert and auto-increment", function()
        return lia.db.query("INSERT INTO " .. legacyEscapedTable .. " (`payload`) VALUES (" .. lia.db.convertDataType("legacy") .. ")")
    end, function(result)
        assertTrue(tonumber(result and result.lastID) and tonumber(result.lastID) > 0, "Legacy SQL insert did not return an ID")
    end)

    add("Legacy PRAGMA table introspection", function(pass, fail)
        lia.db.query("PRAGMA table_info(" .. legacyEscapedTable .. ")", function(columns)
            local ok, err = pcall(function()
                assertTrue(hasColumn(columns, "id"), "Legacy table id is missing")
                assertTrue(hasColumn(columns, "payload"), "Legacy table payload is missing")
            end)
            if ok then pass() else fail(err) end
        end, fail)
    end)

    addPromise("Remove legacy SQL test table", function()
        return lia.db.removeTable(legacyTableName)
    end, function(removed)
        assertTrue(removed, "Legacy SQL table was not removed")
        legacyOwned = false
    end)

    addPromise("Verify legacy SQL table removed", function()
        return lia.db.tableExists(legacyFullTableName)
    end, function(exists)
        assertEqual(exists, false)
    end)

    add("Verify snapshot payloads", function(pass, fail, skip)
        if not snapshotFile then
            skip("No snapshot was created")
            return
        end
        checkPromise(function()
            return lia.db.selectOne({"payload", "score"}, tableName, {id = primaryID})
        end, function(row)
            assertTrue(istable(row), "Snapshot did not restore the original primary key")
            assertEqual(row.payload, "upsert-bulk")
            assertEqual(tonumber(row.score), 5)
        end, pass, fail)
    end)

    add("Verify snapshot nullable and non-null data", function(pass, fail, skip)
        if not snapshotFile then
            skip("No snapshot was created")
            return
        end
        checkPromise(function()
            return lia.db.selectOne({"note", "payload"}, tableName, {payload = "bulk-a"})
        end, function(row)
            assertTrue(istable(row), "Bulk-inserted record not restored")
            assertEqual(row.note, "filled", "Snapshot lost non-null note data")
        end, pass, fail)
    end)

    addPromise("removeColumn", function()
        return lia.db.removeColumn(tableName, "extra")
    end, function(removed)
        assertTrue(removed, "Existing column was not removed")
    end)

    addPromise("Verify removeColumn", function()
        return lia.db.fieldExists(fullTableName, "extra")
    end, function(exists)
        assertEqual(exists, false)
    end)

    addPromise("removeColumn idempotency", function()
        return lia.db.removeColumn(tableName, "extra")
    end, function(removed)
        assertEqual(removed, false)
    end)

    addPromise("delete all rows from isolated table", function()
        return lia.db.delete(tableName, {})
    end)

    addPromise("Verify delete all", function()
        return lia.db.count(tableName)
    end, function(count)
        assertEqual(count, 0)
    end)

    addPromise("Character data key column metadata", function()
        return lia.db.fieldExists("lia_chardata", "key")
    end, function(exists)
        assertTrue(exists, "Character data key column is missing")
    end)

    add("Character data SELECT with reserved identifiers", function(pass, fail)
        lia.db.query("SELECT `key`, `value` FROM `lia_chardata` WHERE `charID` = -1 LIMIT 1", function(rows)
            if istable(rows) then pass() else fail("SELECT did not return a row list") end
        end, fail)
    end)

    addPromise("Inventory data key column metadata", function()
        return lia.db.fieldExists("lia_invdata", "key")
    end, function(exists)
        assertTrue(exists, "Inventory data key column is missing")
    end)

    add("Inventory data SELECT with reserved identifiers", function(pass, fail)
        lia.db.query("SELECT `key`, `value` FROM `lia_invdata` WHERE `invID` = -1 LIMIT 1", function(rows)
            if istable(rows) then pass() else fail("Inventory SELECT did not return a row list") end
        end, fail)
    end)

    addPromise("Create reserved key column", function()
        return lia.db.createColumn(tableName, "key", "string")
    end, function(created)
        assertTrue(created, "Failed to add reserved key column")
    end)

    addPromise("Create reserved value column", function()
        return lia.db.createColumn(tableName, "value", "text")
    end, function(created)
        assertTrue(created, "Failed to add reserved value column")
    end)

    addPromise("Insert character-style key value fields", function()
        return lia.db.insertTable({key = "rgn", value = "O'Reilly", payload = "reserved-row"}, nil, tableName)
    end, function(result)
        reservedID = tonumber(result and result.lastID)
        assertTrue(reservedID and reservedID > 0, "Reserved field insert returned no row id")
    end)

    add("Raw SELECT character-style reserved fields", function(pass, fail)
        lia.db.query("SELECT `key`, `value` FROM " .. escapedTable .. " WHERE `id` = " .. reservedID .. " AND `key` = 'rgn'", function(rows)
            local ok, err = pcall(function()
                assertTrue(istable(rows) and istable(rows[1]), "Missing reserved field row")
                assertEqual(rows[1].key, "rgn")
                assertEqual(rows[1].value, "O'Reilly")
            end)
            if ok then pass() else fail(err) end
        end, fail)
    end)

    add("Qualified key identifier in JOIN-style queries", function(pass, fail)
        lia.db.query("SELECT d.`key`, d.`value` FROM " .. escapedTable .. " AS d WHERE d.`id` = " .. reservedID, function(rows)
            local ok, err = pcall(function()
                assertTrue(istable(rows) and istable(rows[1]), "Missing qualified reserved field")
                assertEqual(rows[1].key, "rgn")
            end)
            if ok then pass() else fail(err) end
        end, fail)
    end)

    add("Raw UPDATE with reserved key and value columns", function(pass, fail)
        lia.db.query("UPDATE " .. escapedTable .. " SET `value` = 'updated-inventory' WHERE `key` = 'rgn' AND `id` = " .. reservedID, function()
            pass()
        end, fail)
    end)

    addPromise("Verify reserved-field UPDATE", function()
        return lia.db.selectOne({"key", "value"}, tableName, {id = reservedID})
    end, function(row)
        assertTrue(istable(row), "Updated reserved-field row not found")
        assertEqual(row.key, "rgn")
        assertEqual(row.value, "updated-inventory")
    end)

    addPromise("Delete reserved key via structured condition", function()
        return lia.db.delete(tableName, {id = reservedID, key = "rgn"})
    end)

    addPromise("Verify reserved key deletion", function()
        return lia.db.count(tableName, {key = "rgn"})
    end, function(count)
        assertEqual(count, 0, "Reserved key row remains after delete")
    end)

    addPromise("Reserved key fixture cleanup verification", function()
        return lia.db.count(tableName)
    end, function(count)
        assertEqual(count, 0, "Reserved key fixture was not cleaned up")
    end)

    addPromise("removeTable", function()
        return lia.db.removeTable(tableName)
    end, function(removed)
        assertTrue(removed, "Temporary table was not removed")
        owned = false
    end)

    addPromise("Verify removeTable", function()
        return lia.db.tableExists(fullTableName)
    end, function(exists)
        assertEqual(exists, false)
    end)

    addPromise("removeTable idempotency", function()
        return lia.db.removeTable(tableName)
    end, function(removed)
        assertEqual(removed, false)
    end)

    addPromise("getTables after cleanup", function()
        return lia.db.getTables()
    end, function(tables)
        assertEqual(hasTable(tables, fullTableName), false)
    end)

    local index = 0
    local function nextStep()
        if finished then return end
        index = index + 1
        local step = tests[index]
        if not step then
            cleanup()
            return
        end

        local settled = false
        local watch = "lia_db_test_step_" .. tableName
        local started = SysTime()
        local function settle(status, message)
            if settled or finished then return end
            settled = true
            timer.Remove(watch)
            local elapsed = math.floor((SysTime() - started) * 1000)
            if status == "pass" then
                passed = passed + 1
                log(string.format("PASS %d/%d: %s (%d ms)", index, #tests, step.name, elapsed))
            elseif status == "skip" then
                skipped = skipped + 1
                log(string.format("SKIP %d/%d: %s (%s)", index, #tests, step.name, tostring(message)))
            else
                failed = failed + 1
                failures[#failures + 1] = step.name .. ": " .. tostring(message)
                log(string.format("FAIL %d/%d: %s (%s)", index, #tests, step.name, tostring(message)))
            end

            if status == "timeout" or status == "fail" and step.critical then
                cleanup()
                return
            end
            timer.Simple(0, nextStep)
        end

        timer.Create(watch, 45, 1, function()
            settle("timeout", "Query timed out after 45 seconds")
        end)

        local ok, err = xpcall(function()
            step.run(function() settle("pass") end, function(reason) settle("fail", reason) end, function(reason) settle("skip", reason) end)
        end, debug.traceback)
        if not ok then settle("fail", err) end
    end

    log("Starting " .. #tests .. " checks on " .. tostring(lia.db.module) .. " using temporary table " .. fullTableName)
    nextStep()
end)
