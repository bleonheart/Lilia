local GM = GM or GAMEMODE
local logTypeMap = {
    ooc = "chatOOC",
    looc = "chatLOOC"
}

function GM:ShowHelp()
    return false
end

function GM:PlayerDeath(client, inflictor, attacker)
    local character = client:getChar()
    if not character then return end
    local inventory = character:getInv()
    if inventory then
        for _, item in pairs(inventory:getItems()) do
            if item.isWeapon and item:getData("equip") then item:setData("ammo", nil) end
        end
    end

    local pkWorld = lia.config.get("PKWorld", false)
    local playerKill = IsValid(attacker) and attacker:IsPlayer() and attacker ~= client
    local selfKill = attacker == client
    local worldKill = not IsValid(attacker) or attacker:GetClass() == "worldspawn"
    if (playerKill or pkWorld and selfKill or pkWorld and worldKill) and hook.Run("PlayerShouldPermaKill", client, inflictor, attacker) then
        net.Start("PKMessage")
        net.Send(client)
        character:ban()
    end

    net.Start("removeF1")
    net.Send(client)
    lia.log.add(client, "playerDeath", attacker:IsPlayer() and attacker:Name() or attacker:GetClass())
end

function GM:OnPickupMoney(client, moneyEntity)
    if moneyEntity and IsValid(moneyEntity) then
        local amount = moneyEntity:getAmount()
        client:notifyLocalized("moneyTaken", lia.currency.get(amount))
        lia.log.add(client, "moneyPickedUp", amount)
    end
end

function GM:PlayerAuthed(client, steamid)
    if client:IsBot() then return end
    local steamID64 = util.SteamIDTo64(steamid)
    local ownerSteamID64 = client:OwnerSteamID64()
    local steamName = client:SteamName()
    local playerSteam64 = client:SteamID64()
    local steam64 = steamID64
    lia.db.query(Format("SELECT userGroup FROM lia_admins WHERE steamID = %s", steam64), function(adminData)
        local forcedGroup = istable(adminData) and adminData[1] and adminData[1].userGroup
        if forcedGroup and lia.admin.groups[forcedGroup] then
            lia.admin.setPlayerGroup(client, forcedGroup)
            return
        end

        if CAMI and CAMI.GetUsergroup and CAMI.GetUsergroup(client:GetUserGroup()) and client:GetUserGroup() ~= "user" then
            lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(client:GetUserGroup()), steam64))
            return
        end

        lia.db.query(Format("SELECT userGroup FROM lia_players WHERE steamID = %s", steam64), function(data)
            local group = istable(data) and data[1] and data[1].userGroup
            if not group or group == "" then
                group = "user"
                lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(group), steam64))
            end

            client:SetUserGroup(group)
        end)
    end)
end

function GM:CheckPassword(steamID64, _, serverPassword, clientPassword, playerName)
    local banRecord = lia.admin.isBanned(steamID64)
    local banExpired = lia.admin.hasBanExpired(steamID64)
    if banRecord then
        if not banExpired then return false, L("banMessage", banRecord.duration / 60, banRecord.reason) end
        lia.admin.removeBan(steamID64)
    end

    if serverPassword ~= "" and serverPassword ~= clientPassword then
        lia.log.add(nil, "failedPassword", steamID64, playerName, serverPassword, clientPassword)
        lia.information(L("passwordMismatchInfo", playerName, steamID64, serverPassword, clientPassword))
        return false, L("passwordMismatchInfo", playerName, steamID64, serverPassword, clientPassword)
    end
end

function GM:PlayerSay(client, message)
    local chatType, parsedMessage, anonymous = lia.chat.parse(client, message, true)
    local hasIPAddress = string.match(message, "%d+%.%d+%.%d+%.%d+(:%d*)?")
    message = parsedMessage
    if hasIPAddress then
        for _, ply in player.Iterator() do
            if ply:isStaffOnDuty() or ply:hasPrivilege("View IP Chat Attempts") then ply:ChatPrint(L("ipAttemptStaff", client:Name(), hasIPAddress)) end
        end

        lia.log.add(client, "ipAttempt", hasIPAddress)
        return ""
    end

    if client:getNetVar("liaGagged") then return "" end
    if chatType == "ic" and lia.command.parse(client, message) then return "" end
    if utf8.len(message) > lia.config.get("MaxChatLength") then
        client:notifyLocalized("tooLongMessage")
        return ""
    end

    local logType = logTypeMap[chatType] or "chat"
    lia.chat.send(client, chatType, message, anonymous)
    if logType == "chat" then
        lia.log.add(client, logType, chatType and chatType:upper() or "??", message)
    else
        lia.log.add(client, logType, message)
    end

    hook.Run("PostPlayerSay", client, message, chatType, anonymous)
    return ""
end

local allowedHoldableClasses = {
    ["prop_physics"] = true,
    ["prop_physics_override"] = true,
    ["prop_physics_multiplayer"] = true,
    ["prop_ragdoll"] = true
}

function GM:CanPlayerHoldObject(_, entity)
    return allowedHoldableClasses[entity:GetClass()] or entity.Holdable
end

function GM:EntityTakeDamage(entity, dmgInfo)
    if not entity:IsPlayer() then return end
    if entity:isStaffOnDuty() and lia.config.get("StaffHasGodMode", true) then return true end
    if entity:isNoClipping() then return true end
    if IsValid(entity.liaPlayer) then
        if dmgInfo:IsDamageType(DMG_CRUSH) then
            if (entity.liaFallGrace or 0) < CurTime() then
                if dmgInfo:GetDamage() <= 10 then dmgInfo:SetDamage(0) end
                entity.liaFallGrace = CurTime() + 0.5
            else
                return
            end
        end

        entity.liaPlayer:TakeDamageInfo(dmgInfo)
    end
end

function GM:KeyPress(client, key)
    if key == IN_JUMP then
        local traceStart = client:GetShootPos() + Vector(0, 0, 15)
        local traceEndHi = traceStart + client:GetAimVector() * 30
        local traceEndLo = traceStart + client:GetAimVector() * 30
        local trHi = util.TraceLine({
            start = traceStart,
            endpos = traceEndHi,
            filter = client
        })

        local trLo = util.TraceLine({
            start = client:GetShootPos(),
            endpos = traceEndLo,
            filter = client
        })

        if trLo.Hit and not trHi.Hit then
            local dist = math.abs(trHi.HitPos.z - client:GetPos().z)
            client:SetVelocity(Vector(0, 0, 50 + dist * 3))
        end
    end
end

function GM:InitializedSchema()
    local persistString = GetConVar("sbox_persist"):GetString()
    if persistString == "" or string.StartsWith(persistString, "lia_") then
        local newValue = "lia_" .. SCHEMA.folder
        game.ConsoleCommand("sbox_persist " .. newValue .. "\n")
    end
end

function GM:GetGameDescription()
    return istable(SCHEMA) and tostring(SCHEMA.name) or "A Lilia Gamemode"
end

function GM:PostPlayerLoadout(client)
    local character = client:getChar()
    if not character then return end
    client:Give("lia_hands")
    client:SetupHands()
    for k, v in pairs(character:getBodygroups()) do
        local index = tonumber(k)
        local value = tonumber(v) or 0
        if index then client:SetBodygroup(index, value) end
    end

    client:SetSkin(character:getSkin())
    client:setNetVar("VoiceType", "Talking")
end

function GM:ShouldSpawnClientRagdoll(client)
    if client:IsBot() then
        client:Spawn()
        return false
    end
end

function GM:DoPlayerDeath(client, attacker)
    client:AddDeaths(1)
    local isPK = hook.Run("PlayerShouldPermaKill", client, nil, attacker)
    local rag
    if hook.Run("ShouldSpawnClientRagdoll", client) ~= false then
        rag = client:createRagdoll(false, true)
        if isPK then
            rag.liaIsPK = true
            hook.Run("OnCreatePKRagdoll", client, rag)
        end
    end

    if IsValid(attacker) and attacker:IsPlayer() then
        if client == attacker then
            attacker:AddFrags(-1)
        else
            attacker:AddFrags(1)
        end
    end

    client:stopAction()
    client:SetDSP(31, false)
end

function GM:PlayerSpawn(client)
    client:SetNoDraw(false)
    client:UnLock()
    client:SetNotSolid(false)
    client:stopAction()
    client:SetDSP(1, false)
    client:removeRagdoll()
    hook.Run("PlayerLoadout", client)
end

function GM:PlayerDisconnected(client)
    client:saveLiliaData()
    local character = client:getChar()
    if character then
        hook.Run("OnCharDisconnect", client, character)
        character:save()
    end

    client:removeRagdoll()
    lia.char.cleanUpForPlayer(client)
    for _, entity in ents.Iterator() do
        if entity:GetCreator() == client and not string.StartsWith(entity:GetClass(), "lia_") then SafeRemoveEntity(entity) end
    end

    lia.log.add(client, "playerDisconnected")
end

function GM:InitializedConfig()
    timer.Simple(0.2, function() lia.config.send() end)
end

function GM:PlayerInitialSpawn(client)
    if client:IsBot() then
        hook.Run("SetupBotPlayer", client)
        return
    end

    lia.config.send(client)
    client.liaJoinTime = RealTime()
    client:loadLiliaData(function(data)
        net.Start("updateAdminGroups")
        net.WriteTable(lia.admin.groups)
        net.Send(client)
        if not IsValid(client) then return end
        local address = client:IPAddress()
        client:setLiliaData("lastIP", address)
        lia.db.updateTable({
            lastIP = address
        }, nil, "players", "steamID = " .. client:SteamID64())

        net.Start("liaDataSync")
        net.WriteTable(data)
        net.WriteType(client.firstJoin)
        net.WriteType(client.lastJoin)
        net.Send(client)
        for _, v in pairs(lia.item.instances) do
            if v.entity and v.invID == 0 then v:sync(client) end
        end

        hook.Run("PlayerLiliaDataLoaded", client)
    end)

    hook.Run("PostPlayerInitialSpawn", client)
    lia.log.add(client, "playerInitialSpawn")
end

function GM:PlayerLoadout(client)
    local character = client:getChar()
    if client.liaSkipLoadout then
        client.liaSkipLoadout = nil
        return
    end

    if not character then
        client:SetNoDraw(true)
        client:Lock()
        client:SetNotSolid(true)
        return
    end

    client:SetWeaponColor(Vector(0.30, 0.80, 0.10))
    client:StripWeapons()
    client:setLocalVar("blur", nil)
    client:SetModel(character:getModel())
    client:SetWalkSpeed(lia.config.get("WalkSpeed"))
    client:SetRunSpeed(lia.config.get("RunSpeed"))
    client:SetJumpPower(160)
    hook.Run("FactionOnLoadout", client)
    hook.Run("ClassOnLoadout", client)
    lia.flag.onSpawn(client)
    hook.Run("PostPlayerLoadout", client)
    hook.Run("FactionPostLoadout", client)
    hook.Run("ClassPostLoadout", client)
    client:SelectWeapon("lia_hands")
end

function GM:CreateDefaultInventory(character)
    local invType = hook.Run("GetDefaultInventoryType", character) or "GridInv"
    local charID = character:getID()
    return lia.inventory.instance(invType, {
        char = charID
    })
end

function GM:SetupBotPlayer(client)
    local botID = os.time()
    local index = math.random(1, table.Count(lia.faction.indices))
    local faction = lia.faction.indices[index]
    local invType = hook.Run("GetDefaultInventoryType") or "GridInv"
    if not invType then return end
    local inventory = lia.inventory.new(invType)
    local character = lia.char.new({
        name = client:Name(),
        faction = faction and faction.uniqueID or "unknown",
        desc = L("botDesc", botID),
        model = "models/player/phoenix.mdl",
    }, botID, client, client:SteamID64())

    local defaultClass = lia.faction.getDefaultClass(faction.index)
    if defaultClass then character:joinClass(defaultClass.index) end
    character.isBot = true
    character.vars.inv = {}
    inventory.id = "bot" .. character:getID()
    character.vars.inv[1] = inventory
    lia.inventory.instances[inventory.id] = inventory
    lia.char.loaded[botID] = character
    character:setup()
    client:Spawn()
end

function GM:PlayerHurt(client, attacker, health, damage)
    lia.log.add(client, "playerHurt", attacker:IsPlayer() and attacker:Name() or attacker:GetClass(), damage, health)
end

function GM:InitializedModules()
    if self.UpdateCheckDone then return end
    timer.Simple(0, function()
        if lia.module.versionChecks then checkPublicModules() end
        if lia.module.privateVersionChecks then checkPrivateModules() end
        checkFrameworkVersion()
    end)

    timer.Simple(5, lia.db.addDatabaseFields)
    self.UpdateCheckDone = true
end

function GM:LiliaTablesLoaded()
    lia.db.addDatabaseFields()
    lia.data.loadTables()
    lia.data.loadPersistence()
    lia.admin.load()
    lia.config.load()
    hook.Run("LoadData")
    hook.Run("PostLoadData")
    lia.faction.formatModelData()
    timer.Simple(2, function() lia.entityDataLoaded = true end)
end

function GM:PlayerShouldTakeDamage(client)
    return client:getChar() ~= nil
end

function GM:CanDrive()
    return false
end

function GM:PlayerDeathThink()
    return false
end

function GM:PlayerSpray()
    return true
end

function GM:PlayerDeathSound()
    return true
end

function GM:CanPlayerSuicide()
    return false
end

function GM:AllowPlayerPickup()
    return false
end

local networkStrings = {"actBar", "AdminModeSwapCharacter", "AnimationStatus", "ArgumentsRequest", "attrib", "BinaryQuestionRequest", "blindFade", "blindTarget", "ButtonRequest", "cfgList", "cfgSet", "charInfo", "charKick", "charSet", "charVar", "CheckHack", "CheckSeed", "classUpdate", "cmd", "cMsg", "CreateTableUI", "DisplayCharList", "doorMenu", "doorPerm", "gVar", "invAct", "invData", "invQuantity", "KickCharacter", "lia_managesitrooms_action", "liaCharacterData", "liaCharacterInvList", "liaCharChoose", "liaCharCreate", "liaCharDelete", "liaCharFetchNames", "liaCharList", "liaCmdArgPrompt", "liaData", "liaDataSync", "liaDBTableDataChunk", "liaDBTableDataDone", "liaDBTables", "liaGroupsAdd", "liaGroupsDefaults", "liaGroupsNotice", "liaGroupsRemove", "liaGroupsRename", "liaGroupsRequest", "liaInventoryAdd", "liaInventoryData", "liaInventoryDelete", "liaInventoryInit", "liaInventoryRemove", "liaItemDelete", "liaItemInspect", "liaItemInstance", "liaNotify", "liaNotifyL", "liaPACPartAdd", "liaPACPartRemove", "liaPACPartReset", "liaPACSync", "liaPlayersRequest", "liaRequestCharList", "liaRequestDBTables", "liaRequestPlayerGroup", "liaRequestTableData", "liaStorageExit", "liaStorageOpen", "liaStorageTransfer", "liaStorageUnlock", "liaTeleportToEntity", "liaTransferItem", "managesitrooms", "msg", "nDel", "NetStreamDS", "nLcl", "nVar", "OpenInvMenu", "OptionsRequest", "PKMessage", "playerLoadedChar", "postPlayerLoadedChar", "prePlayerLoadedChar", "RegenChat", "removeF1", "request_respawn", "RequestDropdown", "rgnDone", "RosterData", "RosterRequest", "send_logs", "send_logs_request", "seqSet", "ServerChatAddText", "setWaypoint", "setWaypointWithLogo", "SpawnMenuGiveItem", "SpawnMenuSpawnItem", "StringRequest", "TicketSystem", "TicketSystemClaim", "TicketSystemClose", "TransferMoneyFromP2P", "trunkInitStorage", "updateAdminGroups", "VendorAllowClass", "VendorAllowFaction", "VendorEdit", "VendorExit", "VendorMaxStock", "VendorMode", "VendorMoney", "VendorOpen", "VendorPrice", "VendorStock", "VendorSync", "VendorTrade", "VerifyCheats", "VerifyCheatsResponse", "ViewClaims", "WorkshopDownloader_Info", "WorkshopDownloader_Request", "WorkshopDownloader_Start", "liaStaffRequest", "liaStaffDataChunk", "liaStaffDataDone"}
for _, netString in ipairs(networkStrings) do
    util.AddNetworkString(netString)
end