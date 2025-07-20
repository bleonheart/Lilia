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

function MODULE:LoadData()
    local data = self:getData()
    if not data or not data.doors then return end
    for id, doorData in pairs(data.doors) do
        local ent = ents.GetMapCreatedEntity(id)
        if IsValid(ent) and ent:isDoor() then
            for k, v in pairs(doorData) do
                if k == "children" then
                    ent.liaChildren = v
                    for childID in pairs(v) do
                        local child = ents.GetMapCreatedEntity(childID)
                        if IsValid(child) then child.liaParent = ent end
                    end
                elseif k == "classes" then
                    ent.liaClasses = v
                    ent:setNetVar("classes", util.TableToJSON(v))
                else
                    ent:setNetVar(k, v)
                end
            end
        end
    end
end

function MODULE:SaveData()
    local data = {
        doors = {}
    }

    local doors = {}
    for _, ent in ents.Iterator() do
        if ent:isDoor() then doors[ent:MapCreationID()] = ent end
    end

    for id, door in pairs(doors) do
        local doorData = {}
        for var in pairs(Variables) do
            local value = door:getNetVar(var)
            if value ~= nil then doorData[var] = value end
        end

        if door.liaChildren then doorData.children = door.liaChildren end
        if door.liaClasses then doorData.classes = door.liaClasses end
        if not table.IsEmpty(doorData) then data.doors[id] = doorData end
    end

    PrintTable(data, 1)
    self:setData(data)
    lia.information(L("doorSaveData", table.Count(data.doors)))
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
    if factions ~= nil then
        local facs = util.JSONToTable(factions)
        if facs ~= nil and facs ~= "[]" and facs[client:Team()] then return true end
    end

    local classes = door:getNetVar("classes")
    local charClass = client:getChar():getClass()
    local charClassData = lia.class.list[charClass]
    if classes and classes ~= "[]" and charClassData then
        local classTable = util.JSONToTable(classes)
        if classTable then
            for id, _ in pairs(classTable) do
                local classData = lia.class.list[id]
                if classData then
                    if classData.team then
                        if classData.team == charClassData.team then return true end
                    elseif id == charClass then
                        return true
                    end
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