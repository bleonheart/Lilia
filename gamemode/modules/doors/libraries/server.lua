local Variables = {
    ["disabled"] = true,
    ["name"] = true,
    ["price"] = true,
    ["noSell"] = true,
    ["factions"] = true,
    ["classes"] = true,
    ["hidden"] = true,
    ["locked"] = true
}

function MODULE:copyParentDoor(child)
    local parent = child.liaParent
    if IsValid(parent) then
        for var in pairs(Variables) do
            local parentValue = parent:getNetVar(var)
            if child:getNetVar(var) ~= parentValue then child:setNetVar(var, parentValue) end
        end
    end
end

function MODULE:PostLoadData()
    if self.DoorsAlwaysDisabled then
        local count = 0
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                door:setNetVar("disabled", true)
                self:callOnDoorChildren(door, function(child) child:setNetVar("disabled", true) end)
                count = count + 1
            end
        end

        lia.information(L("doorDisableAll"))
    end
end

local DOOR_TABLE = "doors"

local function buildCondition(folder, map)
    return "_folder = " .. lia.db.convertDataType(folder) .. " AND _map = " .. lia.db.convertDataType(map)
end


function MODULE:LoadData()
    local folder = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = game.GetMap()
    local condition = buildCondition(folder, map)
    lia.db.waitForTablesToLoad():next(function()
        return lia.db.select("*", DOOR_TABLE, condition)
    end):next(function(res)
        for _, row in ipairs(res.results or {}) do
            local ent = ents.GetMapCreatedEntity(tonumber(row._id))
            if IsValid(ent) and ent:isDoor() then
                local factions = lia.data.deserialize(row._factions) or {}
                if istable(factions) and next(factions) then
                    ent.liaFactions = factions
                    ent:setNetVar("factions", util.TableToJSON(factions))
                end

                local classes = lia.data.deserialize(row._classes) or {}
                if istable(classes) and next(classes) then
                    ent.liaClasses = classes
                    ent:setNetVar("classes", util.TableToJSON(classes))
                end

                local children = lia.data.deserialize(row._children) or {}
                if istable(children) and next(children) then
                    ent.liaChildren = children
                    for childID in pairs(children) do
                        local child = ents.GetMapCreatedEntity(childID)
                        if IsValid(child) then child.liaParent = ent end
                    end
                end

                local name = row._name
                if name then ent:setNetVar("name", name) end
                local price = tonumber(row._price)
                if price then ent:setNetVar("price", price) end
                if tonumber(row._locked) == 1 then ent:setNetVar("locked", true) end
                if tonumber(row._disabled) == 1 then ent:setNetVar("disabled", true) end
                if tonumber(row._hidden) == 1 then ent:setNetVar("hidden", true) end
                if tonumber(row._ownable) == 0 then ent:setNetVar("noSell", true) end
            end
        end
    end)
end

function MODULE:SaveData()
    local folder = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = game.GetMap()
    local condition = buildCondition(folder, map)

    lia.db.waitForTablesToLoad():next(function()
        return lia.db.delete(DOOR_TABLE, condition)
    end):next(function()
        local rows = {}
        for _, door in ipairs(ents.GetAll()) do
            if door:isDoor() then
                rows[#rows + 1] = {
                    _folder = folder,
                    _map = map,
                    _id = door:MapCreationID(),
                    _factions = lia.data.serialize(door.liaFactions or {}),
                    _classes = lia.data.serialize(door.liaClasses or {}),
                    _disabled = door:getNetVar("disabled") and 1 or 0,
                    _hidden = door:getNetVar("hidden") and 1 or 0,
                    _ownable = door:getNetVar("noSell") and 0 or 1,
                    _name = door:getNetVar("name"),
                    _price = door:getNetVar("price"),
                    _locked = door:getNetVar("locked") and 1 or 0,
                    _children = lia.data.serialize(door.liaChildren or {})
                }
            end
        end

        local count = #rows
        if count > 0 then
            return lia.db.bulkInsert(DOOR_TABLE, rows):next(function()
                lia.information(L("doorSaveData", count))
            end)
        else
            lia.information(L("doorSaveData", 0))
        end
    end)
end

function MODULE:callOnDoorChildren(entity, callback)
    local parent
    if entity.liaChildren then
        parent = entity
    elseif entity.liaParent then
        parent = entity.liaParent
    end

    if IsValid(parent) then
        callback(parent)
        for k, _ in pairs(parent.liaChildren) do
            local child = ents.GetMapCreatedEntity(k)
            if IsValid(child) then callback(child) end
        end
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
                if IsValid(door.liaParent) then door = door.liaParent end
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
    elseif (door:GetCreator() == client or client:IsSuperAdmin() or client:isStaffOnDuty()) and (door:IsVehicle() or door:isSimfphysCar()) then
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
    lia.log.add(client, "toggleLock", door, state and "locked" or "unlocked")
end