--[[
    Doors Library Server

    Server-side door management and configuration system for the Lilia framework.
]]
--[[
    Overview:
        The doors library server component provides comprehensive door management functionality including
        preset configuration, database schema verification, and data cleanup operations. It handles
        door data persistence, loading door configurations from presets, and maintaining database
        integrity. The library manages door ownership, access permissions, faction and class restrictions,
        and provides utilities for door data validation and corruption cleanup. It operates primarily
        on the server side and integrates with the database system to persist door configurations
        across server restarts. The library also handles door locking/unlocking mechanics and
        provides hooks for custom door behavior integration.
]]
-- Door data cache using entity as key
lia.doors.stored = lia.doors.stored or {}
-- Helper function to check if a value differs from default
function lia.doors.isDifferentFromDefault(key, value)
    local default = lia.doors.defaults[key]
    if istable(default) then
        if not istable(value) then return false end
        return not table.IsEmpty(value)
    end
    return value ~= default
end

-- Helper function to get door data (with defaults applied)
function lia.doors.getData(door)
    if not IsValid(door) then return table.Copy(lia.doors.defaults) end
    return table.Merge(table.Copy(lia.doors.defaults), lia.doors.stored[door] or {})
end

-- Helper function to set door data (only stores non-default values)
function lia.doors.setData(door, data)
    if not IsValid(door) then return end
    local mapID = door:MapCreationID() or 0
    lia.doors.stored[door] = lia.doors.stored[door] or {}
    
    local hasNonDefaultData = false
    for key, value in pairs(data) do
        local isDifferent = lia.doors.isDifferentFromDefault(key, value)
        if isDifferent then
            hasNonDefaultData = true
            lia.doors.stored[door][key] = value
        else
            lia.doors.stored[door][key] = nil
        end
    end

    -- Clean up empty tables
    if table.IsEmpty(lia.doors.stored[door]) then 
        lia.doors.stored[door] = nil 
    end
    
    -- Only print if there's actual data being stored
    if hasNonDefaultData and lia.doors.stored[door] then
        print("[TEST] setData: Door #" .. mapID .. " stored data keys: " .. table.concat(table.GetKeys(lia.doors.stored[door]), ", "))
    end
    
    -- Sync to clients
    lia.doors.syncUpdateToClients(door)
    hook.Run("DoorDataChanged", door, data)
end

-- Helper function to get only non-default door data for networking
function lia.doors.getSyncData(door)
    if not IsValid(door) then return {} end
    return table.Copy(lia.doors.stored[door] or {})
end

-- Clean up door data when entity is removed
hook.Add("EntityRemoved", "liaDoorDataCleanup", function(entity) if IsValid(entity) and entity:isDoor() then lia.doors.stored[entity] = nil end end)
function MODULE:PostLoadData()
    if lia.config.get("DoorsAlwaysDisabled", false) then
        local count = 0
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local doorData = lia.doors.getData(door)
                if not doorData or table.IsEmpty(doorData) then
                    lia.doors.setData(door, {
                        disabled = true
                    })

                    count = count + 1
                else
                    doorData.disabled = true
                    lia.doors.setData(door, doorData)
                    count = count + 1
                end
            end
        end

        lia.information(L("doorDisableAll"))
    end
end

local function buildCondition(gamemode, map)
    return "gamemode = " .. lia.db.convertDataType(gamemode) .. " AND map = " .. lia.db.convertDataType(map)
end

function MODULE:LoadData()
    print("[TEST] LoadData: Starting door data load")
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local mapName = lia.data.getEquivalencyMap(game.GetMap())
    print("[TEST] LoadData: gamemode = " .. tostring(gamemode) .. ", map = " .. tostring(mapName))
    local condition = buildCondition(gamemode, mapName)
    local query = "SELECT * FROM lia_doors WHERE " .. condition
    print("[TEST] LoadData: Query = " .. query)
    lia.db.query(query):next(function(res)
        print("[TEST] LoadData: Query returned " .. tostring(#(res.results or {})) .. " rows")
        local rows = res.results or {}
        local loadedCount = 0
        local doorsWithData = {}
        for _, row in ipairs(rows) do
            local id = tonumber(row.id)
            if id then doorsWithData[id] = true end
        end
        print("[TEST] LoadData: Found " .. table.Count(doorsWithData) .. " doors with data")

        for _, row in ipairs(rows) do
            local id = tonumber(row.id)
            print("[TEST] LoadData: Processing row with id = " .. tostring(id))
            if not id then
                print("[TEST] LoadData: Skipping row with invalid ID: " .. tostring(row.id))
                lia.warning(L("skippingDoorRecordWithInvalidID") .. ": " .. tostring(row.id))
                continue
            end

            local ent = ents.GetMapCreatedEntity(id)
            print("[TEST] LoadData: Door #" .. id .. " entity = " .. tostring(ent))
            if not IsValid(ent) then
                print("[TEST] LoadData: Door #" .. id .. " entity not found!")
                lia.warning(L("doorEntityNotFound", id))
                continue
            end

            if not ent:isDoor() then
                print("[TEST] LoadData: Entity #" .. id .. " is not a door (class: " .. tostring(ent:GetClass()) .. ")")
                lia.warning(L("entityIsNotADoorSkipping") .. " " .. id)
                continue
            end
            print("[TEST] LoadData: Door #" .. id .. " is valid, processing data...")

            local factions
            if row.factions and row.factions ~= "NULL" and row.factions ~= "" then
                if tostring(row.factions):match("^[%d%.%-%s]+$") and not tostring(row.factions):match("[{}%[%]]") then
                    lia.warning(L("doorHasCoordinateDataInFactionsColumn") .. " " .. id .. ": " .. tostring(row.factions))
                    lia.warning(L("thisSuggestsDataCorruptionClearingFactionsData"))
                    row.factions = ""
                else
                    local success, result = pcall(lia.data.deserialize, row.factions)
                    if success and istable(result) then
                        local isEmpty
                        if table.IsEmpty then
                            isEmpty = table.IsEmpty(result)
                        else
                            isEmpty = next(result) == nil
                        end

                        if not isEmpty then
                            factions = result
                            ent.liaFactions = factions
                        else
                            factions = result
                            ent.liaFactions = factions
                        end
                    else
                        lia.warning(L("failedToDeserializeFactionsForDoor", id) .. ": " .. tostring(result))
                        lia.warning(L("rawFactionsData") .. " " .. tostring(row.factions))
                    end
                end
            end

            local classes
            if row.classes and row.classes ~= "NULL" and row.classes ~= "" then
                if tostring(row.classes):match("^[%d%.%-%s]+$") and not tostring(row.classes):match("[{}%[%]]") then
                    lia.warning(L("doorCoordinateDataWarning", id, tostring(row.classes)))
                    lia.warning(L("doorDataCorruptionClearing"))
                    row.classes = ""
                else
                    local success, result = pcall(lia.data.deserialize, row.classes)
                    if success and istable(result) then
                        local isEmpty
                        if table.IsEmpty then
                            isEmpty = table.IsEmpty(result)
                        else
                            isEmpty = next(result) == nil
                        end

                        if not isEmpty then
                            classes = result
                            ent.liaClasses = classes
                        else
                            classes = result
                            ent.liaClasses = classes
                        end
                    else
                        lia.warning(L("failedToDeserializeClassesForDoor", id) .. ": " .. tostring(result))
                        lia.warning(L("rawClassesData") .. " " .. tostring(row.classes))
                    end
                end
            end

            local hasData = false
            local doorData = {}
            print("[TEST] LoadData: Door #" .. id .. " raw row data:")
            print("[TEST]   row.name = " .. tostring(row.name))
            print("[TEST]   row.price = " .. tostring(row.price))
            print("[TEST]   row.locked = " .. tostring(row.locked))
            print("[TEST]   row.disabled = " .. tostring(row.disabled))
            print("[TEST]   row.hidden = " .. tostring(row.hidden))
            print("[TEST]   row.ownable = " .. tostring(row.ownable))
            
            if row.name and row.name ~= "NULL" and row.name ~= "" then
                doorData.name = tostring(row.name)
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " has name: " .. doorData.name)
            end

            local price = tonumber(row.price)
            if price and price > 0 then
                doorData.price = price
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " has price: " .. price)
            end

            if tonumber(row.locked) == 1 then
                doorData.locked = true
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " is locked")
            end

            if tonumber(row.disabled) == 1 then
                doorData.disabled = true
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " is disabled")
            end

            if tonumber(row.hidden) == 1 then
                doorData.hidden = true
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " is hidden")
            end

            if tonumber(row.ownable) == 0 then
                doorData.noSell = true
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " cannot be sold")
            end

            if factions and #factions > 0 then
                doorData.factions = factions
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " has " .. #factions .. " factions")
            end

            if classes and #classes > 0 then
                doorData.classes = classes
                hasData = true
                print("[TEST] LoadData: Door #" .. id .. " has " .. #classes .. " classes")
            end

            print("[TEST] LoadData: Door #" .. id .. " hasData = " .. tostring(hasData))
            if hasData then
                print("[TEST] LoadData: Door #" .. id .. " doorData keys before hook: " .. table.concat(table.GetKeys(doorData), ", "))
                doorData = hook.Run("PostDoorDataLoad", ent, doorData) or doorData
                print("[TEST] LoadData: Door #" .. id .. " doorData keys after hook: " .. table.concat(table.GetKeys(doorData), ", "))
                print("[TEST] LoadData: Door #" .. id .. " Calling setData with: " .. util.TableToJSON(doorData))
                lia.doors.setData(ent, doorData)
                loadedCount = loadedCount + 1
                print("[TEST] LoadData: Door #" .. id .. " setData completed, loadedCount = " .. loadedCount)
                print("[Door Load] Loaded door #" .. id .. " - name: " .. (doorData.name or "(none)") .. ", price: " .. (doorData.price or 0))
                
                -- Verify data was stored
                local verifyData = lia.doors.getData(ent)
                print("[TEST] LoadData: Door #" .. id .. " Verification - stored data keys: " .. table.concat(table.GetKeys(verifyData), ", "))
                print("[TEST] LoadData: Door #" .. id .. " Verification - name = " .. tostring(verifyData.name) .. ", price = " .. tostring(verifyData.price))
                
                if ent:isDoor() then
                    if doorData.locked then
                        ent:Fire("lock")
                    else
                        ent:Fire("unlock")
                    end
                end
            else
                print("[TEST] LoadData: Door #" .. id .. " has no data to load")
            end
        end
        print("[TEST] LoadData: Completed loading " .. loadedCount .. " doors")
    end):catch(function(err)
        print("[TEST] LoadData: ERROR - " .. tostring(err))
        lia.error(L("failedToLoadDoorData", tostring(err)))
        lia.error(L("databaseConnectionIssue"))
    end)
end

function MODULE:SaveData()
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = lia.data.getEquivalencyMap(game.GetMap())
    local rows = {}
    local doorCount = 0
    for _, door in ents.Iterator() do
        if door:isDoor() then
            local mapID = door:MapCreationID()
            if not mapID or mapID <= 0 then continue end
            local doorData = lia.doors.getData(door)
            if not doorData or table.IsEmpty(doorData) then continue end
            doorData = hook.Run("PreDoorDataSave", door, doorData) or doorData
            local factionsTable = doorData.factions or {}
            local classesTable = doorData.classes or {}
            if not istable(factionsTable) then
                lia.warning(L("doorInvalidFactionsType", mapID, type(factionsTable)))
                factionsTable = {}
            end

            if not istable(classesTable) then
                lia.warning(L("doorInvalidClassesType", mapID, type(classesTable)))
                classesTable = {}
            end

            local factionsSerialized = lia.data.serialize(factionsTable)
            local classesSerialized = lia.data.serialize(classesTable)
            if factionsSerialized and factionsSerialized:match("^[%d%.%-%s]+$") and not factionsSerialized:match("[{}%[%]]") then
                lia.warning(L("doorFactionsCoordinateReset", mapID))
                factionsTable = {}
                factionsSerialized = lia.data.serialize(factionsTable)
            end

            if classesSerialized and classesSerialized:match("^[%d%.%-%s]+$") and not classesSerialized:match("[{}%[%]]") then
                lia.warning(L("doorClassesCoordinateReset", mapID))
                classesTable = {}
                classesSerialized = lia.data.serialize(classesTable)
            end

            local name = doorData.name or ""
            if name and name ~= "" then
                name = tostring(name):sub(1, 255)
            else
                name = ""
            end

            local price = tonumber(doorData.price) or 0
            if price < 0 then price = 0 end
            if price > 999999999 then price = 999999999 end
            rows[#rows + 1] = {
                gamemode = gamemode,
                map = map,
                id = mapID,
                factions = factionsSerialized,
                classes = classesSerialized,
                disabled = doorData.disabled and 1 or 0,
                hidden = doorData.hidden and 1 or 0,
                ownable = doorData.noSell and 0 or 1,
                name = name,
                price = price,
                locked = doorData.locked and 1 or 0
            }

            doorCount = doorCount + 1
        end
    end

    if #rows > 0 then
        lia.db.bulkUpsert("doors", rows):next(function() end):catch(function(err)
            lia.error(L("failedToSaveDoorData", tostring(err)))
            lia.error(L("schemaProblem"))
        end)
    end
end

-- Helper function to save a single door to the database
function lia.doors.saveDoorToDatabase(door)
    print("[TEST] saveDoorToDatabase CALLED")
    if not IsValid(door) or not door:isDoor() then
        print("[TEST] saveDoorToDatabase: Invalid door entity")
        lia.warning("saveDoorToDatabase: Invalid door entity")
        return
    end

    local mapID = door:MapCreationID()
    print("[TEST] saveDoorToDatabase: mapID = " .. tostring(mapID))
    if not mapID or mapID <= 0 then
        print("[TEST] saveDoorToDatabase: Invalid door map ID: " .. tostring(mapID))
        lia.warning("saveDoorToDatabase: Invalid door map ID: " .. tostring(mapID))
        return
    end

    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = lia.data.getEquivalencyMap(game.GetMap())
    print("[TEST] saveDoorToDatabase: gamemode = " .. tostring(gamemode) .. ", map = " .. tostring(map))
    
    local doorData = lia.doors.getData(door)
    print("[TEST] saveDoorToDatabase: doorData keys = " .. table.concat(table.GetKeys(doorData or {}), ", "))
    if not doorData then
        print("[TEST] saveDoorToDatabase: No door data for door #" .. mapID)
        lia.warning("saveDoorToDatabase: No door data for door #" .. mapID)
        return
    end

    -- Check if we have any non-default data to save
    local hasData = false
    local nonDefaultKeys = {}
    for key, value in pairs(doorData) do
        if lia.doors.isDifferentFromDefault(key, value) then
            hasData = true
            table.insert(nonDefaultKeys, key .. "=" .. tostring(value))
        end
    end
    print("[TEST] saveDoorToDatabase: hasData = " .. tostring(hasData) .. ", non-default: " .. table.concat(nonDefaultKeys, ", "))

    if not hasData then
        print("[TEST] saveDoorToDatabase: Door #" .. mapID .. " has no non-default data to save")
        lia.warning("saveDoorToDatabase: Door #" .. mapID .. " has no non-default data to save")
        return
    end

    doorData = hook.Run("PreDoorDataSave", door, doorData) or doorData
    local factionsTable = doorData.factions or {}
    local classesTable = doorData.classes or {}
    if not istable(factionsTable) then
        lia.warning(L("doorInvalidFactionsType", mapID, type(factionsTable)))
        factionsTable = {}
    end

    if not istable(classesTable) then
        lia.warning(L("doorInvalidClassesType", mapID, type(classesTable)))
        classesTable = {}
    end

    local factionsSerialized = lia.data.serialize(factionsTable)
    local classesSerialized = lia.data.serialize(classesTable)
    if factionsSerialized and factionsSerialized:match("^[%d%.%-%s]+$") and not factionsSerialized:match("[{}%[%]]") then
        lia.warning(L("doorFactionsCoordinateReset", mapID))
        factionsTable = {}
        factionsSerialized = lia.data.serialize(factionsTable)
    end

    if classesSerialized and classesSerialized:match("^[%d%.%-%s]+$") and not classesSerialized:match("[{}%[%]]") then
        lia.warning(L("doorClassesCoordinateReset", mapID))
        classesTable = {}
        classesSerialized = lia.data.serialize(classesTable)
    end

    local name = doorData.name or ""
    if name and name ~= "" then
        name = tostring(name):sub(1, 255)
    else
        name = ""
    end

    local price = tonumber(doorData.price) or 0
    if price < 0 then price = 0 end
    if price > 999999999 then price = 999999999 end
    local row = {
        gamemode = gamemode,
        map = map,
        id = mapID,
        factions = factionsSerialized,
        classes = classesSerialized,
        disabled = doorData.disabled and 1 or 0,
        hidden = doorData.hidden and 1 or 0,
        ownable = doorData.noSell and 0 or 1,
        name = name,
        price = price,
        locked = doorData.locked and 1 or 0
    }

    print("[TEST] saveDoorToDatabase: About to save row:")
    print("[TEST]   gamemode = " .. tostring(row.gamemode))
    print("[TEST]   map = " .. tostring(row.map))
    print("[TEST]   id = " .. tostring(row.id))
    print("[TEST]   name = " .. tostring(row.name))
    print("[TEST]   price = " .. tostring(row.price))
    print("[TEST]   locked = " .. tostring(row.locked))
    print("[TEST]   disabled = " .. tostring(row.disabled))
    print("[TEST]   hidden = " .. tostring(row.hidden))
    print("[TEST]   ownable = " .. tostring(row.ownable))
    print("[TEST]   factions = " .. tostring(row.factions))
    print("[TEST]   classes = " .. tostring(row.classes))
    
    print("[Door Save] Attempting to save door #" .. mapID .. " to database...")
    print("[Door Save] Data: name=" .. tostring(name) .. ", price=" .. tostring(price) .. ", locked=" .. tostring(doorData.locked))
    lia.db.bulkUpsert("doors", {row}):next(function()
        print("[TEST] saveDoorToDatabase: Database save SUCCESS for door #" .. mapID)
        lia.information("Door #" .. mapID .. " saved to database successfully")
        print("[Door Save] SUCCESS: Door #" .. mapID .. " saved to database")
        
        -- Sync to all connected clients after successful save
        if IsValid(door) then
            print("[TEST] saveDoorToDatabase: Syncing door #" .. mapID .. " to all clients")
            lia.doors.syncUpdateToClients(door)
            print("[Door Save] Synced door #" .. mapID .. " to all connected clients")
        else
            print("[TEST] saveDoorToDatabase: Door #" .. mapID .. " is no longer valid, cannot sync")
        end
    end):catch(function(err)
        print("[TEST] saveDoorToDatabase: Database save ERROR for door #" .. mapID .. ": " .. tostring(err))
        lia.error(L("failedToSaveDoorData", tostring(err)))
        lia.error(L("schemaProblem"))
        print("[Door Save] ERROR: Failed to save door #" .. mapID .. ": " .. tostring(err))
    end)
end

--[[
    Purpose:
        Verifies the database schema for the doors table matches expected structure

    When Called:
        During server initialization or when checking database integrity

    Parameters:
        None

    Returns:
        nil

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Verify schema on server start
    lia.doors.verifyDatabaseSchema()
    ```

    Medium Complexity:
    ```lua
    -- Medium: Verify schema with custom handling
    hook.Add("InitPostEntity", "VerifyDoorSchema", function()
    timer.Simple(5, function()
    lia.doors.verifyDatabaseSchema()
    end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Custom schema verification with migration
    function customSchemaCheck()
        lia.doors.verifyDatabaseSchema()

        -- Check for missing columns and add them
        local missingColumns = {
        }

        for column, type in pairs(missingColumns) do
            lia.db.query("ALTER TABLE lia_doors ADD COLUMN " .. column .. " " .. type)
        end
    end
    ```
]]
function lia.doors.verifyDatabaseSchema()
    if lia.db.module == "sqlite" then
        lia.db.query("PRAGMA table_info(lia_doors)"):next(function(res)
            if not res or not res.results then
                lia.error(L("failedToGetTableInfo"))
                return
            end

            local columns = {}
            for _, row in ipairs(res.results) do
                columns[row.name] = row.type
            end

            local expectedColumns = {
                gamemode = "text",
                map = "text",
                id = "integer",
                factions = "text",
                classes = "text",
                disabled = "integer",
                hidden = "integer",
                ownable = "integer",
                name = "text",
                price = "integer",
                locked = "integer"
            }

            for colName, expectedType in pairs(expectedColumns) do
                if not columns[colName] then
                    lia.error(L("missingExpectedColumn") .. " " .. colName)
                elseif columns[colName]:lower() ~= expectedType:lower() then
                    lia.warning(L("column") .. " " .. colName .. " " .. L("hasType") .. " " .. columns[colName] .. ", " .. L("expected") .. " " .. expectedType)
                end
            end
        end):catch(function(err) lia.error(L("failedToVerifyDatabaseSchema") .. " " .. tostring(err)) end)
    else
        lia.db.query("DESCRIBE lia_doors"):next(function(res)
            if not res or not res.results then
                lia.error(L("failedToGetTableInfo"))
                return
            end

            local columns = {}
            for _, row in ipairs(res.results) do
                columns[row.Field] = row.Type
            end

            lia.information(L("liaDoorsTableColumns") .. ": " .. table.concat(table.GetKeys(columns), ", "))
            local expectedColumns = {
                gamemode = "text",
                map = "text",
                id = "int",
                factions = "text",
                classes = "text",
                disabled = "tinyint",
                hidden = "tinyint",
                ownable = "tinyint",
                name = "text",
                price = "int",
                locked = "tinyint"
            }

            for colName, expectedType in pairs(expectedColumns) do
                if not columns[colName] then
                    lia.error(L("missingExpectedColumn") .. " " .. colName)
                elseif not columns[colName]:lower():match(expectedType:lower()) then
                    lia.warning(L("column") .. " " .. colName .. " " .. L("hasType") .. " " .. columns[colName] .. ", " .. L("expected") .. " " .. expectedType)
                end
            end
        end):catch(function(err) lia.error(L("failedToVerifyDatabaseSchema") .. " " .. tostring(err)) end)
    end
end

--[[
    Purpose:
        Cleans up corrupted door data in the database by removing invalid faction/class data

    When Called:
        During server initialization or when data corruption is detected

    Parameters:
        None

    Returns:
        nil

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Run cleanup on server start
    lia.doors.cleanupCorruptedData()
    ```

    Medium Complexity:
    ```lua
    -- Medium: Schedule cleanup with delay
    hook.Add("InitPostEntity", "CleanupDoorData", function()
    timer.Simple(2, function()
    lia.doors.cleanupCorruptedData()
    end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Custom cleanup with logging and validation
    function advancedDoorCleanup()
        lia.information("Starting door data cleanup...")

        lia.doors.cleanupCorruptedData()

        -- Additional validation
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        local map = lia.data.getEquivalencyMap(game.GetMap())
        local condition = "gamemode = " .. lia.db.convertDataType(gamemode) .. " AND map = " .. lia.db.convertDataType(map)

        lia.db.query("SELECT COUNT(*) as count FROM lia_doors WHERE " .. condition):next(function(res)
        local count = res.results[1].count
        lia.information("Door cleanup completed. Total doors in database: " .. count)
    end)
    end
    ```
]]
function lia.doors.cleanupCorruptedData()
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = lia.data.getEquivalencyMap(game.GetMap())
    local condition = buildCondition(gamemode, map)
    local query = "SELECT id, factions, classes FROM lia_doors WHERE " .. condition
    lia.db.query(query):next(function(res)
        local rows = res.results or {}
        local corruptedCount = 0
        for _, row in ipairs(rows) do
            local id = tonumber(row.id)
            if not id then continue end
            local needsUpdate = false
            local newFactions = row.factions
            local newClasses = row.classes
            if row.factions and row.factions ~= "NULL" and row.factions ~= "" and tostring(row.factions):match("^[%d%.%-%s]+$") and not tostring(row.factions):match("[{}%[%]]") then
                lia.warning(L("corruptedFactionsData", id, tostring(row.factions)))
                newFactions = ""
                needsUpdate = true
                corruptedCount = corruptedCount + 1
            end

            if row.classes and row.classes ~= "NULL" and row.classes ~= "" and tostring(row.classes):match("^[%d%.%-%s]+$") and not tostring(row.classes):match("[{}%[%]]") then
                lia.warning(L("corruptedClassesData", id, tostring(row.classes)))
                newClasses = ""
                needsUpdate = true
                corruptedCount = corruptedCount + 1
            end

            if needsUpdate then
                local updateQuery = "UPDATE lia_doors SET factions = " .. lia.db.convertDataType(newFactions) .. ", classes = " .. lia.db.convertDataType(newClasses) .. " WHERE " .. condition .. " AND id = " .. id
                lia.db.query(updateQuery):next(function() lia.information(L("fixedCorruptedDoorData", id)) end):catch(function(err) lia.error(L("failedToFixCorruptedDoorData", id, tostring(err))) end)
            end
        end

        if corruptedCount > 0 then lia.information(L("foundAndFixedCorruptedDoors", corruptedCount)) end
    end):catch(function(err) lia.error(L("failedToCheckCorruptedDoorData", tostring(err))) end)
end

function MODULE:InitPostEntity()
    local doors = ents.FindByClass("prop_door_rotating")
    for _, v in ipairs(doors) do
        local parent = v:GetOwner()
        if IsValid(parent) then
            v.liaPartner = parent
            parent.liaPartner = v
        else
            for _, v2 in ipairs(doors) do
                if v2:GetOwner() == v then
                    v2.liaPartner = v
                    v.liaPartner = v2
                    break
                end
            end
        end
    end

    timer.Simple(1, function() lia.doors.cleanupCorruptedData() end)
    timer.Simple(3, function() lia.doors.verifyDatabaseSchema() end)
end

function MODULE:PlayerUse(client, door)
    if door:IsVehicle() and door:isLocked() then return false end
    if door:isDoor() then
        local result = hook.Run("CanPlayerUseDoor", client, door)
        if result == false then
            return false
        else
            result = hook.Run("PlayerUseDoor", client, door)
            if result ~= nil then return result end
        end
    end
end

function MODULE:CanPlayerUseDoor(_, door)
    local doorData = lia.doors.getData(door)
    if doorData.disabled then return false end
end

function MODULE:CanPlayerAccessDoor(client, door)
    local doorData = lia.doors.getData(door)
    local factions = doorData.factions
    if factions and #factions > 0 then
        local playerFaction = client:getChar():getFaction()
        local factionData = lia.faction.indices[playerFaction]
        local unique = factionData and factionData.uniqueID
        for _, id in ipairs(factions) do
            if id == unique or lia.faction.getIndex(id) == playerFaction then return true end
        end
    end

    local classes = doorData.classes
    local charClass = client:getChar():getClass()
    local charClassData = lia.class.list[charClass]
    if classes and #classes > 0 and charClassData then
        local unique = charClassData.uniqueID
        for _, id in ipairs(classes) do
            local classIndex = lia.class.retrieveClass(id)
            local classData = lia.class.list[classIndex]
            if id == unique or classIndex == charClass then
                return true
            elseif classData and classData.team and classData.team == charClassData.team then
                return true
            end
        end
        return false
    end
end

-- Send door data to client during initial spawn
function lia.doors.syncToClient(client, door)
    if not IsValid(client) or not IsValid(door) then return end
    local mapID = door:MapCreationID() or 0
    local syncData = lia.doors.getSyncData(door)
    if table.IsEmpty(syncData) then -- Don't send if no non-default data
        return
    end

    -- Only print if there's actual data to sync
    print("[TEST] syncToClient: Door #" .. mapID .. " sending to client " .. client:Name() .. " - data keys: " .. table.concat(table.GetKeys(syncData), ", "))
    print("[TEST] syncToClient: Door #" .. mapID .. " data: " .. util.TableToJSON(syncData))
    print("[Door Sync] Syncing door #" .. mapID .. " to client " .. client:Name() .. " - data keys: " .. table.concat(table.GetKeys(syncData), ", "))
    
    net.Start("liaDoorData")
    net.WriteEntity(door)
    net.WriteTable(syncData)
    net.Send(client)
    print("[TEST] syncToClient: Door #" .. mapID .. " data sent to client " .. client:Name())
end

-- Send door data update to all clients
function lia.doors.syncUpdateToClients(door)
    if not IsValid(door) then return end
    local syncData = lia.doors.getSyncData(door)
    net.Start("liaDoorDataUpdate")
    net.WriteEntity(door)
    net.WriteTable(syncData)
    net.Broadcast()
end

function MODULE:PostPlayerLoadout(client)
    client:Give("lia_keys")
end

function MODULE:ShowTeam(client)
    local entity = client:getTracedEntity()
    if IsValid(entity) and entity:isDoor() then
        local doorData = lia.doors.getData(entity)
        local factions = doorData.factions
        local classes = doorData.classes
        if (not factions or #factions == 0) and (not classes or #classes == 0) then
            if entity:checkDoorAccess(client, DOOR_TENANT) then
                local door = entity
                net.Start("liaDoorMenu")
                net.WriteEntity(door)
                local access = door.liaAccess or {}
                net.WriteUInt(table.Count(access), 8)
                for ply, perm in pairs(access) do
                    net.WriteEntity(ply)
                    net.WriteUInt(perm or 0, 2)
                end

                net.WriteEntity(entity)
                net.Send(client)
            elseif not IsValid(entity:GetDTEntity(0)) then
                lia.command.run(client, "doorbuy")
            else
                client:notifyErrorLocalized("notNow")
            end
            return true
        end
    end
end

function MODULE:PlayerDisconnected(client)
    for _, v in ents.Iterator() do
        if v ~= client and v.isDoor and v:isDoor() and v:GetDTEntity(0) == client then v:removeDoorAccessData() end
    end
end

function MODULE:KeyLock(client, door, time)
    if not IsValid(door) or not IsValid(client) then return end
    if lia.config.get("DisableCheaterActions", true) and client.isCheater then
        lia.log.add(client, "cheaterAction", L("cheaterActionLockDoor"))
        return
    end

    if hook.Run("CanPlayerLock", client, door) == false then return end
    local distance = client:GetPos():Distance(door:GetPos())
    local isProperEntity = door:isDoor() or door:IsVehicle() or door:isSimfphysCar()
    if isProperEntity and not door:isLocked() and distance <= 256 and (door:checkDoorAccess(client) or door:GetCreator() == client or client:isStaffOnDuty()) then
        client:setAction(L("locking"), time, function() end)
        client:doStaredAction(door, function() self:ToggleLock(client, door, true) end, time, function() client:stopAction() end)
        lia.log.add(client, "lockDoor", door)
    end
end

function MODULE:KeyUnlock(client, door, time)
    if not IsValid(door) or not IsValid(client) then return end
    if lia.config.get("DisableCheaterActions", true) and client.isCheater then
        lia.log.add(client, "cheaterAction", L("cheaterActionUnlockDoor"))
        return
    end

    if hook.Run("CanPlayerUnlock", client, door) == false then return end
    local distance = client:GetPos():Distance(door:GetPos())
    local isProperEntity = door:isDoor() or door:IsVehicle() or door:isSimfphysCar()
    if isProperEntity and door:isLocked() and distance <= 256 and (door:checkDoorAccess(client) or door:GetCreator() == client or client:isStaffOnDuty()) then
        client:setAction(L("unlocking"), time, function() end)
        client:doStaredAction(door, function() self:ToggleLock(client, door, false) end, time, function() client:stopAction() end)
        lia.log.add(client, "unlockDoor", door)
    end
end

function MODULE:ToggleLock(client, door, state)
    if not IsValid(door) then return end
    if lia.config.get("DisableCheaterActions", true) and IsValid(client) and client.isCheater then
        lia.log.add(client, "cheaterAction", state and L("cheaterActionLockDoor") or L("cheaterActionUnlockDoor"))
        return
    end

    if door:isDoor() then
        local partner = door:getDoorPartner()
        if state then
            if IsValid(partner) then partner:Fire("lock") end
            door:Fire("lock")
            client:EmitSound("doors/door_latch3.wav")
        else
            if IsValid(partner) then partner:Fire("unlock") end
            door:Fire("unlock")
            client:EmitSound("doors/door_latch1.wav")
        end

        door:setLocked(state)
    elseif (door:GetCreator() == client or client:hasPrivilege("manageDoors") or client:isStaffOnDuty()) and (door:IsVehicle() or door:isSimfphysCar()) then
        if state then
            door:Fire("lock")
            client:EmitSound("doors/door_latch3.wav")
        else
            door:Fire("unlock")
            client:EmitSound("doors/door_latch1.wav")
        end

        door:setLocked(state)
    end

    hook.Run("DoorLockToggled", client, door, state)
    lia.log.add(client, "toggleLock", door, state and L("locked") or L("unlocked"))
end


-- Console command to generate random door information for testing
concommand.Add("lia_test_door_info", function(client, _, args)
    if IsValid(client) and not client:IsSuperAdmin() then
        client:ChatPrint("This command is only available to super admins.")
        return
    end

    -- Get the door the player is looking at
    local door = IsValid(client) and client:getTracedEntity() or nil
    if not IsValid(door) or not door:isDoor() then
        if IsValid(client) then
            client:ChatPrint("You must be looking at a door!")
        else
            print("You must be looking at a door! (Console commands require a valid client)")
        end
        return
    end

    local doorData = lia.doors.getData(door)
    local mapID = door:MapCreationID() or 0
    local owner = door:GetDTEntity(0)
    local partner = door:getDoorPartner()
    -- Generate random test information
    local randomName = "Test Door " .. math.random(1000, 9999)
    local randomPrice = math.random(0, 50000)
    local randomTitle = "Random Title " .. math.random(1, 100)
    local randomLocked = math.random(1, 2) == 1
    local randomDisabled = math.random(1, 10) == 1
    local randomHidden = math.random(1, 20) == 1
    local randomNoSell = math.random(1, 5) == 1
    -- Generate random faction/class data if available
    local randomFactions = {}
    local randomClasses = {}
    if lia.faction and lia.faction.indices then
        local factionCount = math.random(0, 3)
        local factionKeys = {}
        for k, _ in pairs(lia.faction.indices) do
            table.insert(factionKeys, k)
        end

        if #factionKeys > 0 then
            for j = 1, math.min(factionCount, #factionKeys) do
                local randomFaction = factionKeys[math.random(1, #factionKeys)]
                if not table.HasValue(randomFactions, randomFaction) then table.insert(randomFactions, randomFaction) end
            end
        end
    end

    if lia.class and lia.class.list then
        local classCount = math.random(0, 3)
        local classKeys = {}
        for k, _ in pairs(lia.class.list) do
            if istable(lia.class.list[k]) and lia.class.list[k].uniqueID then table.insert(classKeys, lia.class.list[k].uniqueID) end
        end

        if #classKeys > 0 then
            for j = 1, math.min(classCount, #classKeys) do
                local randomClass = classKeys[math.random(1, #classKeys)]
                if not table.HasValue(randomClasses, randomClass) then table.insert(randomClasses, randomClass) end
            end
        end
    end

    -- Apply random data to the door (this will sync to clients automatically)
    -- Note: Database only stores 'name', not 'title'. Title is derived from name on client.
    local newDoorData = {
        name = randomName,  -- This is what gets saved to database
        price = randomPrice,
        locked = randomLocked,
        disabled = randomDisabled,
        hidden = randomHidden,
        noSell = randomNoSell
    }
    
    -- Title is stored separately in memory but not in database
    -- The client will use name as title if title is empty

    if #randomFactions > 0 then newDoorData.factions = randomFactions end
    if #randomClasses > 0 then newDoorData.classes = randomClasses end
    
    print("[TEST] Test Command: About to setData with: " .. util.TableToJSON(newDoorData))
    -- Apply the data to the door (this will sync to clients automatically)
    lia.doors.setData(door, newDoorData)
    print("[TEST] Test Command: setData completed")
    
    -- Verify data was stored
    local verifyData = lia.doors.getData(door)
    print("[TEST] Test Command: After setData, getData returns keys: " .. table.concat(table.GetKeys(verifyData), ", "))
    local verifySync = lia.doors.getSyncData(door)
    print("[TEST] Test Command: After setData, getSyncData returns keys: " .. table.concat(table.GetKeys(verifySync), ", "))
    -- Update lock state if needed
    if door:isDoor() then
        if randomLocked and not door:isLocked() then
            door:Fire("lock")
            door:setLocked(true)
        elseif not randomLocked and door:isLocked() then
            door:Fire("unlock")
            door:setLocked(false)
        end
    end

    -- Save to database immediately (setData already completed)
    print("[Test Command] Saving door #" .. mapID .. " to database...")
    lia.doors.saveDoorToDatabase(door)

    -- Refresh door data after applying changes
    doorData = lia.doors.getData(door)
    print("=" .. string.rep("=", 78))
    print("DOOR INFORMATION TEST - Door you are looking at")
    print("=" .. string.rep("=", 78))
    print("\n--- Door Information ---")
    print("Map ID: " .. mapID)
    print("Entity: " .. tostring(door))
    print("Class: " .. (door:GetClass() or "unknown"))
    print("Position: " .. tostring(door:GetPos()))
    print("Has Partner: " .. (IsValid(partner) and "Yes" or "No"))
    if IsValid(partner) then
        print("Partner Entity: " .. tostring(partner))
        print("Partner Map ID: " .. (partner:MapCreationID() or 0))
    end

    print("\nCurrent Data (after applying random data):")
    print("  Name: " .. (doorData.name ~= "" and doorData.name or "(empty)"))
    print("  Title: " .. (doorData.title ~= "" and doorData.title or "(empty)"))
    print("  Price: " .. (doorData.price or 0))
    print("  Locked: " .. tostring(doorData.locked or false))
    print("  Disabled: " .. tostring(doorData.disabled or false))
    print("  Hidden: " .. tostring(doorData.hidden or false))
    print("  No Sell: " .. tostring(doorData.noSell or false))
    print("  Owner: " .. (IsValid(owner) and owner:Name() or "None"))
    if IsValid(owner) then print("  Owner SteamID: " .. (owner:SteamID() or "Unknown")) end
    print("  Factions: " .. (doorData.factions and #doorData.factions > 0 and table.concat(doorData.factions, ", ") or "None"))
    print("  Classes: " .. (doorData.classes and #doorData.classes > 0 and table.concat(doorData.classes, ", ") or "None"))
    print("\nRandom Generated Data (APPLIED to door):")
    print("  Random Name: " .. randomName)
    print("  Random Price: " .. lia.currency.get(randomPrice))
    print("  Random Title: " .. randomTitle)
    print("  Random Locked: " .. tostring(randomLocked))
    print("  Random Disabled: " .. tostring(randomDisabled))
    print("  Random Hidden: " .. tostring(randomHidden))
    print("  Random No Sell: " .. tostring(randomNoSell))
    print("  Random Factions: " .. (#randomFactions > 0 and table.concat(randomFactions, ", ") or "None"))
    print("  Random Classes: " .. (#randomClasses > 0 and table.concat(randomClasses, ", ") or "None"))
    print("\nAccess Levels:")
    print("  DOOR_NONE: " .. DOOR_NONE)
    print("  DOOR_GUEST: " .. DOOR_GUEST)
    print("  DOOR_TENANT: " .. DOOR_TENANT)
    print("  DOOR_OWNER: " .. DOOR_OWNER)
    -- Check access for the player if valid
    if IsValid(client) then
        print("\nYour Access Level:")
        local accessLevel = DOOR_NONE
        if door.liaAccess and door.liaAccess[client] then accessLevel = door.liaAccess[client] end
        print("  Access Level: " .. accessLevel .. " (" .. (lia.doors.AccessLabels[accessLevel] or "Unknown") .. ")")
        print("  Can Use (Guest): " .. tostring(door:checkDoorAccess(client, DOOR_GUEST)))
        print("  Can Use (Tenant): " .. tostring(door:checkDoorAccess(client, DOOR_TENANT)))
        print("  Can Use (Owner): " .. tostring(door:checkDoorAccess(client, DOOR_OWNER)))
        if IsValid(owner) then print("  Is Owner: " .. tostring(owner == client)) end
    end

    print("\n" .. string.rep("=", 80))
    print("Test completed!")
    print("Door data has been saved to the database.")
    print(string.rep("=", 80))
    -- Send success feedback to the player
    if IsValid(client) then client:notifySuccess("Random door data applied and saved to database! Check the door info box. (Door: " .. randomName .. ")") end
end)