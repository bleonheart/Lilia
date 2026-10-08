GM.Name = "Lilia"
GM.version = 7.612
GM.Author = "Samael"
GM.Website = "https://discord.gg/esCRH5ckbQ"
include("core/libraries/core/loader.lua")
local hints = {"Annoy1", "Annoy2", "OpeningMenu", "OpeningContext", "ContextClick", "PhysgunFreeze", "PhysgunUnfreeze", "PhysgunUse", "VehicleView", "ColorRoom", "EditingSpawnlists", "EditingSpawnlistsSave"}
for _, hint in ipairs(hints) do
    hook.Run("SuppressHint", hint)
end

local running = false
concommand.Add("lia_db_test", function(client)
    if IsValid(client) then
        client:PrintMessage(HUD_PRINTCONSOLE, "[Lilia DB Test] Run this command from the server console.\n")
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
    local tableName = "dbtest_" .. os.time() .. "_" .. math.random(10000, 99999)
    local original = "Lilia's database test"
    local updated = "Updated database test"
    local insertedID
    local finished = false
    local function log(message)
        print("[Lilia DB Test] " .. message)
    end

    local function complete(success, message)
        if finished then return end
        finished = true
        lia.db.removeTable(tableName):next(function()
            running = false
            log((success and "SUCCESS: " or "FAILED: ") .. message)
            log("Temporary table cleaned up.")
        end, function(err)
            running = false
            log((success and "TESTS PASSED: " or "FAILED: ") .. message)
            log("Cleanup failed for lia_" .. tableName .. ": " .. tostring(err))
        end)
    end

    local steps = {
        {
            name = "Connection",
            run = function(nextStep, fail)
                lia.db.query("SELECT 1 AS result", function(rows)
                    if not istable(rows) or not istable(rows[1]) or tonumber(rows[1].result) ~= 1 then
                        fail("SELECT 1 returned an unexpected result")
                        return
                    end

                    nextStep()
                end, fail)
            end
        },
        {
            name = "Create table",
            run = function(nextStep, fail)
                lia.db.createTable(tableName, "id", {
                    {
                        name = "id",
                        type = "integer",
                        auto_increment = true
                    },
                    {
                        name = "payload",
                        type = "string",
                        length = 255
                    }
                }):next(nextStep, fail)
            end
        },
        {
            name = "Insert",
            run = function(nextStep, fail)
                lia.db.insertTable({
                    payload = original
                }, nil, tableName):next(function(result)
                    insertedID = tonumber(result and result.lastID)
                    if not insertedID or insertedID < 1 then
                        fail("The insert did not return a valid ID")
                        return
                    end

                    nextStep()
                end, fail)
            end
        },
        {
            name = "Select",
            run = function(nextStep, fail)
                lia.db.selectOne("*", tableName, {
                    id = insertedID
                }):next(function(row)
                    if not row or row.payload ~= original then
                        fail("The inserted value was not read correctly")
                        return
                    end

                    nextStep()
                end, fail)
            end
        },
        {
            name = "Update",
            run = function(nextStep, fail)
                lia.db.updateTable({
                    payload = updated
                }, nil, tableName, {
                    id = insertedID
                }):next(nextStep, fail)
            end
        },
        {
            name = "Verify update",
            run = function(nextStep, fail)
                lia.db.selectOne("*", tableName, {
                    id = insertedID
                }):next(function(row)
                    if not row or row.payload ~= updated then
                        fail("The updated value was not read correctly")
                        return
                    end

                    nextStep()
                end, fail)
            end
        },
        {
            name = "Count",
            run = function(nextStep, fail)
                lia.db.count(tableName, {
                    id = insertedID
                }):next(function(count)
                    if count ~= 1 then
                        fail("Expected one record, received " .. tostring(count))
                        return
                    end

                    nextStep()
                end, fail)
            end
        },
        {
            name = "Delete",
            run = function(nextStep, fail)
                lia.db.delete(tableName, {
                    id = insertedID
                }):next(nextStep, fail)
            end
        },
        {
            name = "Verify deletion",
            run = function(nextStep, fail)
                lia.db.exists(tableName, {
                    id = insertedID
                }):next(function(exists)
                    if exists then
                        fail("The deleted record still exists")
                        return
                    end

                    nextStep()
                end, fail)
            end
        },
        {
            name = "Transaction",
            run = function(nextStep, fail)
                local statement = "INSERT INTO " .. lia.db.escapeIdentifier("lia_" .. tableName) .. " (`payload`) VALUES (" .. lia.db.convertDataType("transaction-test") .. ")"
                lia.db.transaction({statement}):next(nextStep, fail)
            end
        },
        {
            name = "Verify transaction",
            run = function(nextStep, fail)
                lia.db.count(tableName, {
                    payload = "transaction-test"
                }):next(function(count)
                    if count ~= 1 then
                        fail("The transaction did not commit its insert")
                        return
                    end

                    nextStep()
                end, fail)
            end
        }
    }

    local index = 0
    local function nextStep()
        if finished then return end
        index = index + 1
        local step = steps[index]
        if not step then
            complete(true, "All database checks passed using " .. tostring(lia.db.module))
            return
        end

        log("Testing " .. step.name .. "...")
        step.run(function()
            if finished then return end
            log("PASS: " .. step.name)
            nextStep()
        end, function(err) complete(false, step.name .. ": " .. tostring(err)) end)
    end

    log("Connected backend: " .. tostring(lia.db.module))
    nextStep()
end)