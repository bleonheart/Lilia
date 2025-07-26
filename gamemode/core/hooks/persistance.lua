local function makeKey(ent)
    local class
    local pos
    if IsEntity(ent) then
        class = ent.class or ent:GetClass()
        pos = ent.pos or ent:GetPos()
    else
        class = ent.class
        if ent.pos then
            pos = lia.data.decode(ent.pos)
        elseif ent.GetPos then
            pos = ent:GetPos()
        end
    end

    if not (class and pos) then return "" end
    local tol = 1
    return string.format("%s_%.0f_%.0f_%.0f", class, pos.x / tol, pos.y / tol, pos.z / tol)
end

function GM:SaveData()
    local seen = {}
    local data = {}
    for _, ent in ents.Iterator() do
        if ent:isLiliaPersistent() then
            local key = makeKey(ent)
            if key ~= "" and not seen[key] then
                seen[key] = true
                local entPos = ent:GetPos()
                local entAng = ent:GetAngles()
                local entData = {
                    pos = entPos,
                    class = ent:GetClass(),
                    model = ent:GetModel(),
                    angles = entAng
                }

                local skin = ent:GetSkin()
                if skin and skin > 0 then entData.skin = skin end
                local bodygroups
                local bgCount = ent:GetNumBodyGroups() or 0
                for i = 0, bgCount - 1 do
                    local value = ent:GetBodygroup(i)
                    if value > 0 then
                        bodygroups = bodygroups or {}
                        bodygroups[i] = value
                    end
                end

                if bodygroups then entData.bodygroups = bodygroups end
                local extra = hook.Run("GetEntitySaveData", ent)
                if extra ~= nil then entData.data = extra end
                data[#data + 1] = entData
                hook.Run("OnEntityPersisted", ent, entData)
            end
        end
    end

    lia.data.savePersistence(data)
    lia.information(L("dataSaved"))
end

local function IsEntityNearby(pos, class)
    for _, ent in ipairs(ents.FindByClass(class)) do
        if ent:GetPos():DistToSqr(pos) <= 2500 then return true end
    end
    return false
end

function GM:LoadData()
    lia.data.loadPersistenceData(function(entities)
        for _, ent in ipairs(entities) do
            local cls = ent.class
            if not isstring(cls) or cls == "" then
                lia.error("Invalid entity class.")
                continue
            end

            local decodedPos = lia.data.decode(ent.pos)
            local decodedAng = lia.data.decode(ent.angles)
            if not decodedPos then
                lia.error("Invalid position for " .. cls .. ".")
                continue
            end

            if IsEntityNearby(decodedPos, cls) then
                lia.error(L("entityCreationAborted", cls, decodedPos.x, decodedPos.y, decodedPos.z))
                continue
            end

            local createdEnt = ents.Create(cls)
            if not IsValid(createdEnt) then
                lia.error("Failed to create entity " .. cls .. ".")
                continue
            end

            createdEnt:SetPos(decodedPos)
            if decodedAng then createdEnt:SetAngles(decodedAng) end
            if ent.model then createdEnt:SetModel(ent.model) end
            createdEnt:Spawn()
            if ent.skin then createdEnt:SetSkin(tonumber(ent.skin) or 0) end
            if istable(ent.bodygroups) then
                for idx, val in pairs(ent.bodygroups) do
                    createdEnt:SetBodygroup(tonumber(idx) or 0, tonumber(val) or 0)
                end
            end

            createdEnt:Activate()
            hook.Run("OnEntityLoaded", createdEnt, ent.data)
        end
    end)

    local folder = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local map = game.GetMap()
    local condition = "schema = " .. lia.db.convertDataType(folder) .. " AND map = " .. lia.db.convertDataType(map)
    lia.db.select({"itemID", "pos", "angles"}, "saveditems", condition):next(function(res)
        local items = res.results or {}
        if #items > 0 then
            local idRange, positions, angles = {}, {}, {}
            for _, row in ipairs(items) do
                local id = tonumber(row.itemID)
                idRange[#idRange + 1] = id
                positions[id] = lia.data.decodeVector(row.pos)
                angles[id] = lia.data.decodeAngle(row.angles)
            end

            if #idRange > 0 then
                local range = "(" .. table.concat(idRange, ", ") .. ")"
                if hook.Run("ShouldDeleteSavedItems") == true then
                    lia.db.query("DELETE FROM lia_items WHERE itemID IN " .. range)
                    lia.information(L("serverDeletedItems"))
                else
                    lia.db.query("SELECT itemID, uniqueID, data FROM lia_items WHERE itemID IN " .. range, function(data)
                        if not data then return end
                        local loadedItems = {}
                        for _, row in ipairs(data) do
                            local itemID = tonumber(row.itemID)
                            local itemData = util.JSONToTable(row.data or "[]")
                            local uniqueID = row.uniqueID
                            local itemTable = lia.item.list[uniqueID]
                            local position = positions[itemID]
                            local ang = angles[itemID]
                            if itemTable and itemID and position then
                                local itemCreated = lia.item.new(uniqueID, itemID)
                                itemCreated.data = itemData or {}
                                itemCreated:spawn(position, ang).liaItemID = itemID
                                itemCreated:onRestored()
                                itemCreated.invID = 0
                                loadedItems[#loadedItems + 1] = itemCreated
                            end
                        end

                        hook.Run("OnSavedItemLoaded", loadedItems)
                    end)
                end
            end
        end
    end)
end

function GM:OnEntityCreated(ent)
    if not IsValid(ent) or not ent:isLiliaPersistent() then return end
    timer.Simple(0, function()
        if not IsValid(ent) then return end
        local saved = lia.data.getPersistence()
        local seen = {}
        for _, data in ipairs(saved) do
            seen[makeKey(data)] = true
        end

        local key = makeKey(ent)
        if seen[key] then return end
        local entData = {
            pos = ent:GetPos(),
            class = ent:GetClass(),
            model = ent:GetModel(),
            angles = ent:GetAngles()
        }

        local extra = hook.Run("GetEntitySaveData", ent)
        if extra ~= nil then entData.data = extra end
        saved[#saved + 1] = entData
        lia.data.savePersistence(saved)
        hook.Run("OnEntityPersisted", ent, entData)
    end)
end

function GM:UpdateEntityPersistence(ent)
    if not IsValid(ent) or not ent:isLiliaPersistent() then return end
    local saved = lia.data.getPersistence()
    local key = makeKey(ent)
    for _, data in ipairs(saved) do
        if makeKey(data) == key then
            data.pos = ent:GetPos()
            data.class = ent:GetClass()
            data.model = ent:GetModel()
            data.angles = ent:GetAngles()
            local extra = hook.Run("GetEntitySaveData", ent)
            if extra ~= nil then
                data.data = extra
            else
                data.data = nil
            end

            lia.data.savePersistence(saved)
            hook.Run("OnEntityPersistUpdated", ent, data)
            return
        end
    end
end

function GM:EntityRemoved(ent)
    if not IsValid(ent) or not ent:isLiliaPersistent() then return end
    local saved = lia.data.getPersistence()
    local key = makeKey(ent)
    for i, data in ipairs(saved) do
        if makeKey(data) == key then
            table.remove(saved, i)
            lia.data.savePersistence(saved)
            break
        end
    end
end

function GM:PreCleanupMap()
    lia.shuttingDown = true
    hook.Run("SaveData")
    lia.config.save()
    hook.Run("PersistenceSave")
end

function GM:PostCleanupMap()
    lia.shuttingDown = false
    hook.Run("LoadData")
    hook.Run("PostLoadData")
end

function GM:ShutDown()
    if hook.Run("ShouldDataBeSaved") == false then return end
    lia.shuttingDown = true
    hook.Run("SaveData")
    lia.config.save()
    for _, v in player.Iterator() do
        v:saveLiliaData()
        if v:getChar() then v:getChar():save() end
    end
end