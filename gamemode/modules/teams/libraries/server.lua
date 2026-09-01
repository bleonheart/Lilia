local MODULE = MODULE
local updateNPCRelations
local flushFactionPlaytime
local ensureFactionTracking
function MODULE:OnPlayerJoinClass(client, class, oldClass)
    local info = lia.class.list[class]
    local info2 = lia.class.list[oldClass]
    if info then
        if info.OnSet then info:OnSet(client) end
        if oldClass ~= class and info.OnTransferred then info:OnTransferred(client, oldClass) end
    else
        lia.error(string.format("Invalid class '%s' provided for client.", tostring(class)))
    end

    if info2 and info2.OnLeave then info2:OnLeave(client) end
    net.Start("liaClassUpdate")
    net.WriteEntity(client)
    net.Broadcast()
    updateNPCRelations(client)
end

function MODULE:OnTransferred(client)
    local char = client:getChar()
    if char then
        local currentClass = char:getClass()
        if currentClass then
            local classData = lia.class.list[currentClass]
            if not classData or classData.faction ~= client:Team() then char:kickClass() end
        end
    end
end

function MODULE:CanPlayerJoinClass(client, class)
    if lia.class.hasWhitelist(class) and not client:getChar():getClasswhitelists()[class] then return false end
    return true
end

function MODULE:OnCharCreated(_, character)
    local faction = lia.faction.get(character:getFaction())
    if not faction then return end
    local items = faction.items or {}
    for _, item in pairs(items) do
        character:getInv():add(item, 1)
    end

    local defaultClass = lia.faction.getDefaultClass(character:getFaction())
    if defaultClass then
        character:setClass(defaultClass.index)
    else
        character:setClass(0)
    end

    ensureFactionTracking(character, character:getPlayer(), "created")
end

function MODULE:PlayerLoadedChar(client, character)
    ensureFactionTracking(character, client, "loaded")
    if character:getData("factionKickWarn") then
        client:notifyWarning("You were kicked from your faction!")
        hook.Run("OnTransferred", client)
        local faction = lia.faction.indices[client:Team()]
        if faction and faction.OnTransferred then faction:OnTransferred(client) end
        character:setData("factionKickWarn", nil)
    end

    local class = lia.class.list[character:getClass()]
    if character then
        if class and client:Team() == class.faction then
            local oldClass = character:getClass()
            timer.Simple(.3, function()
                if IsValid(client) then
                    character:setClass(class.index)
                    hook.Run("OnPlayerJoinClass", client, class.index, oldClass)
                end
            end)
        end

        if not class or class.faction ~= client:Team() then
            local defClass = lia.faction.getDefaultClass(client:Team())
            if defClass then
                character:setClass(defClass.index)
            else
                character:setClass(0)
            end
        end
    end
end

function MODULE:CharPreSave(character)
    flushFactionPlaytime(character)
end

local function getNormalizedNPCClass(entity)
    if not IsValid(entity) or not entity:IsNPC() then return nil end
    local class = entity:GetClass()
    if class == "npc_turret_floor" then
        if not entity.liaNPCRelationsInitialized then
            timer.Simple(0, function() if IsValid(entity) then hook.Run("OnEntityCreated", entity) end end)
            entity.liaNPCRelationsInitialized = true
            return nil
        elseif bit.band(entity:GetSpawnFlags(), 512) ~= 0 then
            class = "npc_turret_floor_resistance"
        end
    elseif class == "npc_rollermine" then
        if not entity.liaNPCRelationsInitialized then
            timer.Simple(0, function() if IsValid(entity) then hook.Run("OnEntityCreated", entity) end end)
            entity.liaNPCRelationsInitialized = true
            return nil
        elseif bit.band(entity:GetSpawnFlags(), 262144) ~= 0 then
            class = "npc_rollermine_hacked"
        end
    elseif class == "npc_citizen" then
        local keys = entity:GetKeyValues()
        if not entity.liaNPCRelationsInitialized then
            timer.Simple(0, function() if IsValid(entity) then hook.Run("OnEntityCreated", entity) end end)
            entity.liaNPCRelationsInitialized = true
            return nil
        elseif keys.squadname and keys.squadname == "overwatch" then
            class = "npc_citizen_rebel_enemy"
        end
    end
    return class
end

local function debugNPCRelations(message, ...)
    lia.debug("[NPC Relations]", message, ...)
end

local function getClientNPCRelations(client)
    local character = client:getChar()
    if not character then
        debugNPCRelations("Skipped relation lookup", "player=", tostring(IsValid(client) and client:Name() or "unknown"), "reason=", "no character")
        return nil
    end

    local mergedRelations = {}
    local hasRelations = false
    local faction = lia.faction.indices[character:getFaction()]
    if faction and faction.NPCRelations then
        table.Merge(mergedRelations, faction.NPCRelations)
        hasRelations = true
    end

    local class = lia.class.list[character:getClass()]
    if class and class.faction == character:getFaction() and class.NPCRelations then
        table.Merge(mergedRelations, class.NPCRelations)
        hasRelations = true
    end

    local overriddenRelations = hook.Run("GetNPCRelations", client, hasRelations and mergedRelations or nil)
    if overriddenRelations ~= nil then
        debugNPCRelations("Resolved relations override", "player=", tostring(client:Name()), "faction=", tostring(faction and faction.uniqueID or "nil"), "class=", tostring(character:getClass()), "relationCount=", tostring(istable(overriddenRelations) and table.Count(overriddenRelations) or 0), "source=", "hook")
        return overriddenRelations
    end

    debugNPCRelations("Resolved relations", "player=", tostring(client:Name()), "faction=", tostring(faction and faction.uniqueID or "nil"), "class=", tostring(character:getClass()), "relationCount=", tostring(hasRelations and table.Count(mergedRelations) or 0), "source=", hasRelations and "faction/class merge" or "default hostile")
    return hasRelations and mergedRelations or nil
end

local function applyNPCRelation(entity, client)
    if not IsValid(entity) or not entity:IsNPC() or not IsValid(client) then return end
    local rawClass = entity:GetClass()
    local npcClass = getNormalizedNPCClass(entity)
    if not npcClass then
        debugNPCRelations("Deferred NPC relation application", "entity=", tostring(entity), "rawClass=", tostring(rawClass), "player=", tostring(client:Name()))
        return
    end

    local relations = getClientNPCRelations(client)
    if istable(relations) and relations[npcClass] then
        entity:AddEntityRelationship(client, relations[npcClass], 0)
        debugNPCRelations("Applied specific relation", "entity=", tostring(entity), "rawClass=", tostring(rawClass), "normalizedClass=", tostring(npcClass), "player=", tostring(client:Name()), "disposition=", tostring(relations[npcClass]))
    elseif relations == nil then
        entity:AddEntityRelationship(client, D_HT, 0)
        debugNPCRelations("Applied default hostile relation", "entity=", tostring(entity), "rawClass=", tostring(rawClass), "normalizedClass=", tostring(npcClass), "player=", tostring(client:Name()), "disposition=", tostring(D_HT))
    else
        debugNPCRelations("No matching relation entry", "entity=", tostring(entity), "rawClass=", tostring(rawClass), "normalizedClass=", tostring(npcClass), "player=", tostring(client:Name()))
    end
end

updateNPCRelations = function(client)
    if not IsValid(client) or not client:getChar() then return end
    debugNPCRelations("Refreshing NPC relations", "player=", tostring(client:Name()))
    for _, entity in ents.Iterator() do
        applyNPCRelation(entity, client)
    end
end

local function applyAttributes(client, attr)
    if not attr then return end
    local offset = Vector(0, 0, 64)
    local offsetDuck = Vector(0, 0, 28)
    client:SetViewOffset(offset)
    client:SetViewOffsetDucked(offsetDuck)
    client:SetModelScale(1)
    updateNPCRelations(client)
    if attr.scale and attr.scale ~= 1 then
        client:SetViewOffset(offset * attr.scale)
        client:SetViewOffsetDucked(offsetDuck * attr.scale)
        client:SetModelScale(attr.scale)
    end

    local configRunSpeed = lia.config.get("RunSpeed")
    local configWalkSpeed = lia.config.get("WalkSpeed")
    if attr.runSpeed then
        client:SetRunSpeed(math.Round(configRunSpeed * attr.runSpeed))
    else
        client:SetRunSpeed(configRunSpeed)
    end

    if attr.walkSpeed then
        client:SetWalkSpeed(math.Round(configWalkSpeed * attr.walkSpeed))
    else
        client:SetWalkSpeed(configWalkSpeed)
    end

    if attr.jumpPower then client:SetJumpPower(math.Round(client:GetJumpPower() * attr.jumpPower)) end
    client:SetBloodColor(attr.bloodcolor or BLOOD_COLOR_RED)
    if attr.health then
        client:SetMaxHealth(attr.health)
        client:SetHealth(attr.health)
    end

    if attr.armor then client:SetArmor(attr.armor) end
    if attr.OnSpawn then attr:OnSpawn(client) end
    if attr.weapons then
        if istable(attr.weapons) then
            for _, weapon in ipairs(attr.weapons) do
                client:Give(weapon, true)
            end
        else
            client:Give(attr.weapons, true)
        end
    end
end

function MODULE:CanCharBeTransfered(character, faction)
    if faction.oneCharOnly then
        for _, otherCharacter in next, lia.char.getAll() do
            if otherCharacter.steamID == character.steamID and faction.index == otherCharacter:getFaction() then return false, "This player already has another character in this faction!" end
        end
    end
end

function MODULE:OnEntityCreated(entity)
    if not IsValid(entity) or not entity:IsNPC() then return end
    for _, client in player.Iterator() do
        applyNPCRelation(entity, client)
    end
end

function MODULE:PlayerSpawn(client)
    updateNPCRelations(client)
end

function MODULE:OnCharVarChanged(character, key, oldValue, newValue)
    if key ~= "faction" or oldValue == nil or oldValue == 0 then return end
    local client = character:getPlayer()
    if IsValid(client) then updateNPCRelations(client) end
end

function MODULE:OnPlayerSwitchClass(client)
    updateNPCRelations(client)
end

function MODULE:PostPlayerLoadout(client)
    local character = client:getChar()
    if not character then return end
    local faction = lia.faction.indices[character:getFaction()]
    local class = lia.class.list[character:getClass()]
    if class and class.faction ~= client:Team() then class = nil end
    timer.Simple(0.2, function()
        if IsValid(client) then
            local mergedAttr = {}
            if faction then
                for k, v in pairs(faction) do
                    mergedAttr[k] = v
                end
            end

            if class then
                for k, v in pairs(class) do
                    mergedAttr[k] = v
                end

                if class.model then
                    local appliedClassModel
                    if isstring(class.model) then
                        client:SetModel(class.model)
                        appliedClassModel = true
                    elseif istable(class.model) then
                        local selected = character:getData("classModel")
                        if isstring(selected) and selected ~= "" and (not util or not util.IsValidModel or util.IsValidModel(selected)) then
                            client:SetModel(selected)
                            appliedClassModel = true
                        end
                    end

                    if appliedClassModel then
                        lia.util.applyBodygroups(client, character:getBodygroups())
                        client:SetSkin(character:getSkin())
                    end
                end
            end

            applyAttributes(client, mergedAttr)
        end
    end)
end

function MODULE:CanPlayerUseChar(client, character)
    local faction = lia.faction.indices[character:getFaction()]
    if faction and hook.Run("CheckFactionLimitReached", faction, character, client) then return false, "This faction is full. Try again later." end
end

function MODULE:CanPlayerSwitchChar(client, currentCharacter, newCharacter)
    local faction = lia.faction.indices[newCharacter:getFaction()]
    if faction and self:CheckFactionLimitReached(faction, newCharacter, client) then return false, "This faction is full. Try again later." end
end

local TRACKED_FACTION_KEYS = {
    factionJoinDates = true,
    factionPlaytime = true,
    factionTransferHistory = true,
    factionNotes = true
}

local function getFactionUniqueID(factionValue)
    if istable(factionValue) then factionValue = factionValue.uniqueID or factionValue.index end
    if isstring(factionValue) then
        local faction = lia.faction.get(factionValue)
        return faction and faction.uniqueID or factionValue
    elseif isnumber(factionValue) then
        local faction = lia.faction.indices[factionValue] or lia.faction.get(factionValue)
        return faction and faction.uniqueID or nil
    end
end

local function sanitizeFactionHistory(history)
    if not istable(history) then return {} end
    local sanitized = {}
    for _, entry in ipairs(history) do
        if istable(entry) then
            sanitized[#sanitized + 1] = {
                at = tonumber(entry.at) or os.time(),
                from = entry.from,
                to = entry.to,
                byName = entry.byName,
                bySteamID = entry.bySteamID,
                reason = entry.reason
            }
        end
    end
    return sanitized
end

local function trimFactionHistory(history, maxEntries)
    maxEntries = maxEntries or 24
    while #history > maxEntries do
        table.remove(history, #history)
    end
    return history
end

local function decodeTrackedFactionRow(value)
    if not value or value == "" then return nil end
    local ok, decoded = pcall(pon.decode, value)
    if not ok or not istable(decoded) then return nil end
    return decoded[1]
end

local function hasFactionRosterAccess(client, factionUniqueID)
    if not IsValid(client) then return false end
    if client:hasPrivilege("listCharacters") or client:hasPrivilege("canManageFactions") then return true end
    local character = client:getChar()
    if not character or not character:hasFlags("F") then return false end
    return getFactionUniqueID(character:getFaction()) == getFactionUniqueID(factionUniqueID)
end

function MODULE:CanAccessFactionRoster(client, factionUniqueID)
    return hasFactionRosterAccess(client, factionUniqueID)
end

function MODULE:CanEditFactionNotes(client, factionUniqueID)
    return hasFactionRosterAccess(client, factionUniqueID)
end

flushFactionPlaytime = function(character, now)
    if not character then return 0 end
    now = tonumber(now) or os.time()
    local factionUniqueID = getFactionUniqueID(character:getFaction())
    local sessionStart = tonumber(character.liaFactionSessionStart or 0)
    if not factionUniqueID or sessionStart <= 0 or now <= sessionStart then
        character.liaFactionSessionStart = now
        return 0
    end

    local playtimeByFaction = character:getData("factionPlaytime", {})
    if not istable(playtimeByFaction) then playtimeByFaction = {} end
    local elapsed = now - sessionStart
    playtimeByFaction[factionUniqueID] = (tonumber(playtimeByFaction[factionUniqueID]) or 0) + elapsed
    character:setData("factionPlaytime", playtimeByFaction, true)
    character.liaFactionSessionStart = now
    return elapsed
end

ensureFactionTracking = function(character, actor, reason)
    if not character then return end
    local factionUniqueID = getFactionUniqueID(character:getFaction())
    if not factionUniqueID then return end
    local now = os.time()
    local joinDates = character:getData("factionJoinDates", {})
    if not istable(joinDates) then joinDates = {} end
    if not tonumber(joinDates[factionUniqueID]) then
        joinDates[factionUniqueID] = now
        character:setData("factionJoinDates", joinDates, true)
        local history = sanitizeFactionHistory(character:getData("factionTransferHistory", {}))
        table.insert(history, 1, {
            at = now,
            from = nil,
            to = factionUniqueID,
            byName = IsValid(actor) and actor:Name() or nil,
            bySteamID = IsValid(actor) and actor:SteamID() or nil,
            reason = reason or "created"
        })

        trimFactionHistory(history)
        character:setData("factionTransferHistory", history, true)
    end

    character.liaFactionSessionStart = now
end

function MODULE:TrackFactionTransfer(character, oldFactionValue, newFactionValue, actor, reason)
    if not character then return end
    local oldFactionUniqueID = getFactionUniqueID(oldFactionValue)
    local newFactionUniqueID = getFactionUniqueID(newFactionValue)
    if oldFactionUniqueID == newFactionUniqueID and newFactionUniqueID then
        ensureFactionTracking(character, actor, reason)
        return
    end

    local now = os.time()
    if oldFactionUniqueID then flushFactionPlaytime(character, now) end
    local joinDates = character:getData("factionJoinDates", {})
    if not istable(joinDates) then joinDates = {} end
    if newFactionUniqueID then joinDates[newFactionUniqueID] = now end
    character:setData("factionJoinDates", joinDates, true)
    local history = sanitizeFactionHistory(character:getData("factionTransferHistory", {}))
    table.insert(history, 1, {
        at = now,
        from = oldFactionUniqueID,
        to = newFactionUniqueID,
        byName = IsValid(actor) and actor:Name() or nil,
        bySteamID = IsValid(actor) and actor:SteamID() or nil,
        reason = reason or "transferred"
    })

    trimFactionHistory(history)
    character:setData("factionTransferHistory", history, true)
    character.liaFactionSessionStart = now
end

function MODULE:TrackOfflineFactionTransfer(charID, oldFactionValue, newFactionValue, actor, reason)
    charID = tonumber(charID)
    if not charID then return end
    lia.char.getCharData(charID):next(function(data)
        local joinDates = istable(data.factionJoinDates) and data.factionJoinDates or {}
        local newFactionUniqueID = getFactionUniqueID(newFactionValue)
        if newFactionUniqueID then joinDates[newFactionUniqueID] = os.time() end
        lia.char.setCharDatabase(charID, "factionJoinDates", joinDates)
        local history = sanitizeFactionHistory(data.factionTransferHistory)
        table.insert(history, 1, {
            at = os.time(),
            from = getFactionUniqueID(oldFactionValue),
            to = newFactionUniqueID,
            byName = IsValid(actor) and actor:Name() or nil,
            bySteamID = IsValid(actor) and actor:SteamID() or nil,
            reason = reason or "transferred"
        })

        trimFactionHistory(history)
        lia.char.setCharDatabase(charID, "factionTransferHistory", history)
    end):catch(function(message) lia.error("Failed to track offline faction transfer: " .. tostring(message)) end)
end

local function canInviteToFaction(client, target)
    local clientChar = client:getChar()
    local targetChar = target:getChar()
    if not clientChar or not targetChar then return false end
    if clientChar:getFaction() == targetChar:getFaction() then return false end
    if clientChar:hasFlags("Z") then return true end
    local classData = lia.class.list[clientChar:getClass()]
    if classData and classData.canInviteToFaction then return true end
    return hook.Run("CanInviteToFaction", client, target) == true
end

local function canInviteToClass(client, target)
    local clientChar = client:getChar()
    local targetChar = target:getChar()
    if not clientChar or not targetChar then return false end
    if clientChar:getFaction() ~= targetChar:getFaction() then return false end
    if clientChar:hasFlags("X") then return true end
    local classData = lia.class.list[clientChar:getClass()]
    if classData and classData.canInviteToClass then return true end
    return hook.Run("CanInviteToClass", client, target) == true
end

lia.playerinteract.addInteraction("inviteToFaction", {
    serverOnly = true,
    category = "Faction Management",
    shouldShow = canInviteToFaction,
    onRun = function(client, target)
        if not SERVER or not canInviteToFaction(client, target) then return end
        local clientChar = client:getChar()
        local targetChar = target:getChar()
        if not clientChar or not targetChar then return end
        local faction
        for _, factionData in pairs(lia.faction.teams) do
            if factionData.index == client:Team() then
                faction = factionData
                break
            end
        end

        if not faction then
            client:notifyError("The specified faction is not valid.")
            return
        end

        if faction.uniqueID == "staff" then
            client:notifyError("You cannot invite players to the staff faction through the interaction menu. Staff characters must be created through the menu system.")
            return
        end

        target:requestBinaryQuestion("Join Faction", "Do you want to join this faction?", "Yes", "No", function(choice)
            if not IsValid(client) or not IsValid(target) then return end
            if choice ~= 0 then
                client:notifyInfo("Invite declined.")
                return
            end

            clientChar = client:getChar()
            targetChar = target:getChar()
            if not clientChar or not targetChar then return end
            if not canInviteToFaction(client, target) then return end
            if hook.Run("CanCharBeTransfered", targetChar, faction, targetChar:getFaction()) == false then return end
            local oldFaction = targetChar:getFaction()
            hook.Run("TrackFactionTransfer", targetChar, oldFaction, faction, client, "inviteToFaction")
            targetChar.vars.faction = faction.uniqueID
            targetChar:setFaction(faction.index)
            hook.Run("OnTransferred", target)
            if faction.OnTransferred then faction:OnTransferred(target, oldFaction) end
            hook.Run("PlayerLoadout", target)
            client:notifySuccess(string.format("%s has been transferred to %s.", target:Name(), faction.name))
            if client ~= target then target:notifyInfo(string.format("You have been transferred to %s by %s.", faction.name, client:Name())) end
            targetChar:takeFlags("Z")
        end)
    end
})

lia.playerinteract.addInteraction("inviteToClass", {
    serverOnly = true,
    category = "Faction Management",
    shouldShow = canInviteToClass,
    onRun = function(client, target)
        if not SERVER or not canInviteToClass(client, target) then return end
        local clientChar = client:getChar()
        local targetChar = target:getChar()
        if not clientChar or not targetChar then return end
        local class = lia.class.list[clientChar:getClass()]
        if not class then
            client:notifyError("The specified class is not valid.")
            return
        end

        target:requestBinaryQuestion("Join Class", "Do you want to join this class?", "Yes", "No", function(choice)
            if not IsValid(client) or not IsValid(target) then return end
            if choice ~= 0 then
                client:notifyInfo("Invite declined.")
                return
            end

            clientChar = client:getChar()
            targetChar = target:getChar()
            if not clientChar or not targetChar then return end
            if not canInviteToClass(client, target) then return end
            class = lia.class.list[clientChar:getClass()]
            if not class then return end
            if hook.Run("CanCharBeTransfered", targetChar, class, targetChar:getClass()) == false then return end
            local oldClass = targetChar:getClass()
            targetChar:setClass(class.index)
            hook.Run("OnPlayerJoinClass", target, class.index, oldClass)
            client:notifySuccess(string.format("%s has been transferred to %s.", target:Name(), class.name))
            if client ~= target then target:notifyInfo(string.format("You have been transferred to %s by %s.", class.name, client:Name())) end
        end)
    end
})
