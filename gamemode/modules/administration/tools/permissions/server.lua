local GM = GM or GAMEMODE
local resetCalled = 0
local restrictedProperties = {
    persist = true,
    drive = true,
    bonemanipulate = true
}

function GM:PlayerSpawnProp(client, model)
    local list = lia.data.get("prop_blacklist") or {}
    local lowerModel = string.lower(model)
    for _, black in ipairs(list) do
        if string.lower(black) == lowerModel then
            if not client:hasPrivilege("Spawn Permissions - Can Spawn Blacklisted Props") then
                lia.log.add(client, "spawnDenied", "prop", model)
                client:notifyLocalized("blacklistedProp")
                return false
            end

            break
        end
    end

    local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn Props") or client:getChar():hasFlags("e")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "prop", model)
        client:notifyLocalized("noSpawnPropsPerm")
    end
    return canSpawn
end

function GM:CanProperty(client, property, entity)
    if restrictedProperties[property] then
        lia.log.add(client, "permissionDenied", "use property " .. property)
        client:notifyLocalized("disabledFeature")
        return false
    end

    if entity:IsWorld() and IsValid(entity) then
        if client:hasPrivilege("Can Property World Entities") then return true end
        lia.log.add(client, "permissionDenied", "modify world property " .. property)
        client:notifyLocalized("noModifyWorldEntities")
        return false
    end

    if entity:GetCreator() == client and (property == "remover" or property == "collision") then return true end
    if client:IsSuperAdmin() or client:hasPrivilege("Access Property " .. property:gsub("^%l", string.upper)) and client:isStaffOnDuty() then return true end
    lia.log.add(client, "permissionDenied", "modify property " .. property)
    client:notifyLocalized("noModifyProperty")
    return false
end

function GM:DrawPhysgunBeam(client)
    if client:isNoClipping() then return false end
end

function GM:PhysgunPickup(client, entity)
    if (client:hasPrivilege("Physgun Pickup") or client:isStaffOnDuty()) and entity.NoPhysgun then
        if not client:hasPrivilege("Physgun Pickup on Restricted Entities") then
            lia.log.add(client, "permissionDenied", "physgun restricted entity")
            client:notifyLocalized("noPickupRestricted")
            return false
        end
        return true
    end

    if client:IsSuperAdmin() then return true end
    if entity:GetCreator() == client and (entity:isProp() or entity:isItem()) then return true end
    if client:hasPrivilege("Physgun Pickup") then
        if entity:IsVehicle() then
            if not client:hasPrivilege("Physgun Pickup on Vehicles") then
                lia.log.add(client, "permissionDenied", "physgun vehicle")
                client:notifyLocalized("noPickupVehicles")
                return false
            end
            return true
        elseif entity:IsPlayer() then
            if entity:hasPrivilege("Can't be Grabbed with PhysGun") or not client:hasPrivilege("Can Grab Players") then
                lia.log.add(client, "permissionDenied", "physgun player")
                client:notifyLocalized("noPickupPlayer")
                return false
            end
            return true
        elseif entity:IsWorld() or entity:CreatedByMap() then
            if not client:hasPrivilege("Can Grab World Props") then
                lia.log.add(client, "permissionDenied", "physgun world prop")
                client:notifyLocalized("noPickupWorld")
                return false
            end
            return true
        end
        return true
    end

    lia.log.add(client, "permissionDenied", "physgun entity")
    client:notifyLocalized("noPickupEntity")
    return false
end

function GM:PlayerSpawnVehicle(client, model)
    if not client:hasPrivilege("Spawn Permissions - No Car Spawn Delay") then client.NextVehicleSpawn = SysTime() + lia.config.get("PlayerSpawnVehicleDelay", 30) end
    local list = lia.data.get("carBlacklist")
    if model and table.HasValue(list, model) and not client:hasPrivilege("Spawn Permissions - Can Spawn Blacklisted Cars") then
        lia.log.add(client, "spawnDenied", "vehicle", model)
        client:notifyLocalized("blacklistedVehicle")
        return false
    end

    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn Cars") or client:getChar():hasFlags("C")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "vehicle", model)
        client:notifyLocalized("noSpawnVehicles")
    end
    return canSpawn
end

function GM:PlayerNoClip(ply, enabled)
    if not (ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")) then
        lia.log.add(ply, "permissionDenied", "noclip")
        ply:notifyLocalized("noNoclip")
        return false
    end

    ply:DrawShadow(not enabled)
    ply:SetNoTarget(enabled)
    ply:AddFlags(FL_NOTARGET)
    hook.Run("OnPlayerObserve", ply, enabled)
    lia.log.add(ply, "observeToggle", enabled and "enabled" or "disabled")
    return true
end

function GM:PlayerSpawnEffect(client)
    local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn Effects") or client:getChar():hasFlags("L")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "effect")
        client:notifyLocalized("noSpawnEffects")
    end
    return canSpawn
end

function GM:PlayerSpawnNPC(client)
    local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn NPCs") or client:getChar():hasFlags("n")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "npc")
        client:notifyLocalized("noSpawnNPCs")
    end
    return canSpawn
end

function GM:PlayerSpawnRagdoll(client)
    local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn Ragdolls") or client:getChar():hasFlags("r")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "ragdoll")
        client:notifyLocalized("noSpawnRagdolls")
    end
    return canSpawn
end

function GM:PlayerSpawnSENT(client, class)
    local list = lia.data.get("entityBlacklist", {})
    if class and table.HasValue(list, class) and not client:hasPrivilege("Spawn Permissions - Can Spawn Blacklisted Entities") then
        lia.log.add(client, "spawnDenied", "sent", class)
        client:notifyLocalized("blacklistedEntity")
        return false
    end

    local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn SENTs") or client:getChar():hasFlags("E")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "sent")
        client:notifyLocalized("noSpawnSents")
    end
    return canSpawn
end

function GM:PlayerSpawnSWEP(client, swep)
    local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn SWEPs") or client:getChar():hasFlags("z")
    if not canSpawn then
        lia.log.add(client, "spawnDenied", "swep", tostring(swep))
        client:notifyLocalized("noSpawnSweps")
    end

    if canSpawn then lia.log.add(client, "swep_spawning", swep) end
    return canSpawn
end

function GM:PlayerGiveSWEP(client, swep)
    local canGive = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Spawn Permissions - Can Spawn SWEPs") or client:getChar():hasFlags("W")
    if not canGive then
        lia.log.add(client, "permissionDenied", "give swep")
        client:notifyLocalized("noGiveSweps")
    end

    if canGive then lia.log.add(client, "swep_spawning", swep) end
    return canGive
end

function GM:OnPhysgunReload(_, client)
    local canReload = client:hasPrivilege("Can Physgun Reload")
    if not canReload then
        lia.log.add(client, "permissionDenied", "physgun reload")
        client:notifyLocalized("noPhysgunReload")
    end
    return canReload
end

local DisallowedTools = {
    rope = true,
    light = true,
    lamp = true,
    dynamite = true,
    physprop = true,
    faceposer = true,
    stacker = true
}

function GM:CanTool(client, _, tool)
    local function CheckDuplicationScale(ply, entities)
        entities = entities or {}
        for _, v in pairs(entities) do
            if v.ModelScale and v.ModelScale > 10 then
                ply:notifyLocalized("duplicationSizeLimit")
                lia.log.add(ply, "dupeCrashAttempt")
                return false
            end

            v.ModelScale = 1
        end
        return true
    end

    if DisallowedTools[tool] and not client:IsSuperAdmin() then
        lia.log.add(client, "toolDenied", tool)
        client:notifyLocalized("toolNotAllowed", tool)
        return false
    end

    local privilege = "Access Tool " .. tool:gsub("^%l", string.upper)
    local isSuperAdmin = client:IsSuperAdmin()
    local isStaffOrFlagged = client:isStaffOnDuty() or client:getChar():hasFlags("t")
    local hasPriv = client:hasPrivilege(privilege)
    if not isSuperAdmin and not (isStaffOrFlagged and hasPriv) then
        local reasons = {}
        if not isSuperAdmin then table.insert(reasons, "SuperAdmin") end
        if not isStaffOrFlagged then table.insert(reasons, "On-duty staff or flag 't'") end
        if not hasPriv then table.insert(reasons, "Privilege '" .. privilege .. "'") end
        lia.log.add(client, "toolDenied", tool)
        client:notifyLocalized("toolNoPermission", tool, table.concat(reasons, ", "))
        return false
    end

    local entity = client:getTracedEntity()
    if IsValid(entity) then
        local entClass = entity:GetClass()
        if tool == "remover" then
            if entity.NoRemover then
                if not client:hasPrivilege("Can Remove Blocked Entities") then
                    lia.log.add(client, "permissionDenied", "remove blocked entity")
                    client:notifyLocalized("noRemoveBlockedEntities")
                    return false
                end
                return true
            elseif entity:IsWorld() then
                if not client:hasPrivilege("Can Remove World Entities") then
                    lia.log.add(client, "permissionDenied", "remove world entity")
                    client:notifyLocalized("noRemoveWorldEntities")
                    return false
                end
                return true
            end
            return true
        end

        if (tool == "permaall" or tool == "blacklistandremove") and hook.Run("CanPersistEntity", entity) ~= false and (string.StartWith(entClass, "lia_") or entity:isLiliaPersistent() or entity:CreatedByMap()) then
            lia.log.add(client, "toolDenied", tool)
            client:notifyLocalized("toolCantUseEntity", tool)
            return false
        end

        if (tool == "duplicator" or tool == "blacklistandremove") and entity.NoDuplicate then
            lia.log.add(client, "toolDenied", tool)
            client:notifyLocalized("cannotDuplicateEntity", tool)
            return false
        end

        if tool == "weld" and entClass == "sent_ball" then
            lia.log.add(client, "toolDenied", tool)
            client:notifyLocalized("cannotWeldBall")
            return false
        end
    end

    if tool == "duplicator" and client.CurrentDupe and not CheckDuplicationScale(client, client.CurrentDupe.Entities) then return false end
    lia.log.add(client, "toolgunUse", tool)
    return true
end

function GM:PlayerSpawnedNPC(client, entity)
    entity:SetCreator(client)
    lia.log.add(client, "spawned_npc", entity:GetClass(), entity:GetModel())
end

function GM:PlayerSpawnedEffect(client, _, entity)
    entity:SetCreator(client)
    lia.log.add(client, "spawned_effect", entity:GetModel())
end

function GM:PlayerSpawnedProp(client, _, entity)
    entity:SetCreator(client)
    lia.log.add(client, "spawned_prop", entity:GetModel())
end

function GM:PlayerSpawnedRagdoll(client, _, entity)
    entity:SetCreator(client)
    lia.log.add(client, "spawned_ragdoll", entity:GetModel())
end

function GM:PlayerSpawnedSENT(client, entity)
    entity:SetCreator(client)
    lia.log.add(client, "spawned_sent", entity:GetClass(), entity:GetModel())
end

function GM:PlayerSpawnedSWEP(client, entity)
    entity:SetCreator(client)
    lia.log.add(client, "swep_spawning", entity:GetClass())
end

function GM:PlayerSpawnedVehicle(client, entity)
    entity:SetCreator(client)
    lia.log.add(client, "spawned_vehicle", entity:GetClass(), entity:GetModel())
end

function GM:CanPlayerUseChar(client)
    if GetGlobalBool("characterSwapLock", false) and not client:hasPrivilege("Can Bypass Character Lock") then return false, L("serverEventCharLock") end
end