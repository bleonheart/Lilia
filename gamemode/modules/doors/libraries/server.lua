function MODULE:PostLoadData()
    if self.DoorsAlwaysDisabled then
        local count = 0
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                door:setNetVar("disabled", true)
                count = count + 1
            end
        end

        lia.information(L("doorDisableAll"))
    end
end

local function buildCondition(gamemode, map)
    return "gamemode = " .. lia.db.convertDataType(gamemode) .. " AND map = " .. lia.db.convertDataType(map)
end

function MODULE:LoadData()
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local mapName = game.GetMap()
    local condition = buildCondition(gamemode, mapName)
    local query = "SELECT * FROM lia_doors WHERE " .. condition
    lia.db.query(query):next(function(res)
        local rows = res.results or {}
        local loadedCount = 0
        for _, row in ipairs(rows) do
            local id = tonumber(row.id)
            if not id then continue end
            local ent = ents.GetMapCreatedEntity(id)
            if not IsValid(ent) then continue end
            if not ent:isDoor() then continue end
            local factions = {}
            if row.factions and row.factions ~= "NULL" and row.factions ~= "" then
                local success, result = pcall(lia.data.deserialize, row.factions)
                if success and istable(result) then
                    local isEmpty = false
                    if table.IsEmpty then
                        isEmpty = table.IsEmpty(result)
                    else
                        isEmpty = next(result) == nil
                    end

                    if not isEmpty then
                        factions = result
                        ent.liaFactions = factions
                        ent:setNetVar("factions", util.TableToJSON(factions))
                        lia.information("Door " .. id .. " factions loaded: " .. util.TableToJSON(factions))
                    else
                        factions = result
                        ent.liaFactions = factions
                        ent:setNetVar("factions", util.TableToJSON(factions))
                        lia.information("Door " .. id .. " factions loaded: empty table")
                    end
                else
                    lia.warning("Failed to deserialize factions for door " .. id .. ": " .. tostring(result))
                end
            end

            local classes = {}
            if row.classes and row.classes ~= "NULL" and row.classes ~= "" then
                lia.information("Door " .. id .. " raw classes data: " .. tostring(row.classes))
                local success, result = pcall(lia.data.deserialize, row.classes)
                lia.information("Door " .. id .. " classes deserialize - success: " .. tostring(success) .. ", result type: " .. type(result) .. ", result: " .. tostring(result))
                if success and istable(result) then
                    local isEmpty = false
                    if table.IsEmpty then
                        isEmpty = table.IsEmpty(result)
                    else
                        isEmpty = next(result) == nil
                    end

                    if not isEmpty then
                        classes = result
                        ent.liaClasses = classes
                        ent:setNetVar("classes", util.TableToJSON(classes))
                        lia.information("Door " .. id .. " classes loaded: " .. util.TableToJSON(classes))
                    else
                        classes = result
                        ent.liaClasses = classes
                        ent:setNetVar("classes", util.TableToJSON(classes))
                        lia.information("Door " .. id .. " classes loaded: empty table")
                    end
                else
                    lia.warning("Failed to deserialize classes for door " .. id .. ": " .. tostring(result))
                end
            end

            if row.name and row.name ~= "NULL" and row.name ~= "" then ent:setNetVar("name", tostring(row.name)) end
            local price = tonumber(row.price)
            if price and price >= 0 then
                ent:setNetVar("price", price)
            else
                ent:setNetVar("price", 0)
            end

            local locked = tonumber(row.locked) == 1
            ent:setNetVar("locked", locked)
            local disabled = tonumber(row.disabled) == 1
            ent:setNetVar("disabled", disabled)
            local hidden = tonumber(row.hidden) == 1
            ent:setNetVar("hidden", hidden)
            local noSell = tonumber(row.ownable) == 0
            ent:setNetVar("noSell", noSell)
            loadedCount = loadedCount + 1
        end

        lia.information("Successfully loaded " .. loadedCount .. " doors from database")
    end):catch(function(err)
        lia.error("Failed to load door data: " .. tostring(err))
        lia.error("This may indicate a database connection issue or missing table")
    end)
end

function MODULE:SaveData()
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = game.GetMap()
    local condition = buildCondition(gamemode, map)
    local rows = {}
    local doorCount = 0
    lia.information("Starting door data save process...")
    for _, door in ents.Iterator() do
        if door:isDoor() then
            local mapID = door:MapCreationID()
            if not mapID or mapID <= 0 then
                lia.warning("Door has invalid MapCreationID, skipping: " .. tostring(door))
                continue
            end

            -- Get factions and classes from netvars (which are JSON strings) or fall back to liaFactions/liaClasses
            local factions = door:getNetVar("factions")
            local classes = door:getNetVar("classes")
            -- Convert JSON strings to tables for serialization
            local factionsTable = {}
            local classesTable = {}
            if factions and factions ~= "[]" then
                local success, result = pcall(util.JSONToTable, factions)
                if success and istable(result) then
                    factionsTable = result
                else
                    lia.warning("Failed to parse factions JSON for door " .. mapID .. ", using empty table")
                end
            elseif door.liaFactions then
                factionsTable = door.liaFactions
            end

            if classes and classes ~= "[]" then
                local success, result = pcall(util.JSONToTable, classes)
                if success and istable(result) then
                    classesTable = result
                else
                    lia.warning("Failed to parse classes JSON for door " .. mapID .. ", using empty table")
                end
            elseif door.liaClasses then
                classesTable = door.liaClasses
            end

            -- Validate and sanitize data before saving
            local name = door:getNetVar("name")
            if name and name ~= "" then
                name = tostring(name):sub(1, 255) -- Limit name length
            else
                name = ""
            end

            local price = tonumber(door:getNetVar("price")) or 0
            if price < 0 then price = 0 end
            if price > 999999999 then -- Reasonable upper limit
                price = 999999999
            end

            rows[#rows + 1] = {
                gamemode = gamemode,
                map = map,
                id = mapID,
                factions = lia.data.serialize(factionsTable),
                classes = lia.data.serialize(classesTable),
                disabled = door:getNetVar("disabled") and 1 or 0,
                hidden = door:getNetVar("hidden") and 1 or 0,
                ownable = door:getNetVar("noSell") and 0 or 1,
                name = name,
                price = price,
                locked = door:getNetVar("locked") and 1 or 0
            }

            doorCount = doorCount + 1
        end
    end

    lia.information("Prepared " .. doorCount .. " doors for saving")
    -- Use upsert instead of delete + insert to prevent data loss
    if #rows > 0 then
        lia.information("Executing database upsert for " .. #rows .. " door records...")
        lia.db.bulkUpsert("doors", rows):next(function() lia.information("Door data saved successfully (" .. doorCount .. " doors)") end):catch(function(err)
            lia.error("Failed to save door data: " .. tostring(err))
            lia.error("This may indicate a database connection issue or schema problem")
        end)
    else
        lia.information("No doors to save")
    end
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
    if door:getNetVar("disabled", false) then return false end
end

function MODULE:CanPlayerAccessDoor(client, door)
    local factions = door:getNetVar("factions")
    if factions and factions ~= "[]" then
        local facs = util.JSONToTable(factions)
        if facs then
            local playerFaction = client:getChar():getFaction()
            local factionData = lia.faction.indices[playerFaction]
            local unique = factionData and factionData.uniqueID
            for _, id in ipairs(facs) do
                if id == unique or lia.faction.getIndex(id) == playerFaction then return true end
            end
        end
    end

    local classes = door:getNetVar("classes")
    local charClass = client:getChar():getClass()
    local charClassData = lia.class.list[charClass]
    if classes and classes ~= "[]" and charClassData then
        local classTable = util.JSONToTable(classes)
        if classTable then
            local unique = charClassData.uniqueID
            for _, id in ipairs(classTable) do
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
end

function MODULE:PostPlayerLoadout(client)
    client:Give("lia_keys")
end

function MODULE:ShowTeam(client)
    local entity = client:getTracedEntity()
    if IsValid(entity) and entity:isDoor() then
        local factions = entity:getNetVar("factions")
        local classes = entity:getNetVar("classes")
        if (not factions or factions == "[]") and (not classes or classes == "[]") then
            if entity:checkDoorAccess(client, DOOR_TENANT) then
                local door = entity
                net.Start("doorMenu")
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
                client:notifyLocalized("notNow")
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
    if lia.config.get("DisableCheaterActions", true) and client:getNetVar("cheater", false) then
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
    if lia.config.get("DisableCheaterActions", true) and client:getNetVar("cheater", false) then
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
    if lia.config.get("DisableCheaterActions", true) and IsValid(client) and client:getNetVar("cheater", false) then
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