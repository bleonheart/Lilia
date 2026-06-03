local MODULE = MODULE
local function fixupProp(client, ent, mins, maxs)
    local pos = ent:GetPos()
    local down, up = ent:LocalToWorld(mins), ent:LocalToWorld(maxs)
    local trD = util.TraceLine({
        start = pos,
        endpos = down,
        filter = {ent, client}
    })

    local trU = util.TraceLine({
        start = pos,
        endpos = up,
        filter = {ent, client}
    })

    if trD.Hit and trU.Hit then return end
    if trD.Hit then ent:SetPos(pos + trD.HitPos - down) end
    if trU.Hit then ent:SetPos(pos + trU.HitPos - up) end
end

local function tryFixPropPosition(client, ent)
    local m, M = ent:OBBMins(), ent:OBBMaxs()
    fixupProp(client, ent, Vector(m.x, 0, 0), Vector(M.x, 0, 0))
    fixupProp(client, ent, Vector(0, m.y, 0), Vector(0, M.y, 0))
    fixupProp(client, ent, Vector(0, 0, m.z), Vector(0, 0, M.z))
end

function MODULE:PlayerSay(client, text)
    if text and string.sub(text, 1, 1) == "@" then return end
    if client:getLiliaData("liaMuted", false) then
        if (client.liaNextMutedTalkNotice or 0) <= CurTime() then
            client.liaNextMutedTalkNotice = CurTime() + 2
            client:notifyWarningLocalized("mutedTryTalk")
        end
        return ""
    end
end

function MODULE:PlayerSpawn(client)
    if IsValid(client) and client:IsPlayer() then client:ConCommand("spawnmenu_reload") end
    lia.log.add(client, "playerSpawn")
end

function MODULE:PostPlayerLoadout(client)
    local hasAlwaysSpawnAdminStick = client:hasPrivilege("alwaysSpawnAdminStick")
    local isStaffOnDuty = client:isStaffOnDuty()
    local hasUsePositionTool = client:hasPrivilege("usePositionTool")
    local shouldGiveMapConfigurer = hasUsePositionTool or hasAlwaysSpawnAdminStick or isStaffOnDuty
    lia.debug("[Permissions]", "Permission Check for function MODULE:PostPlayerLoadout map configurer", "hasPrivilege(usePositionTool)=", tostring(hasUsePositionTool), "hasPrivilege(alwaysSpawnAdminStick)=", tostring(hasAlwaysSpawnAdminStick), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(shouldGiveMapConfigurer))
    if shouldGiveMapConfigurer then client:Give("lia_mapconfigurer") end
end

local spawnCooldowns = {}
net.Receive("liaSpawnMenuSpawnItem", function(_, client)
    local id = net.ReadString()
    lia.debug("[Permissions]", "Permission Check for net.Receive liaSpawnMenuSpawnItem", "isValidPlayer=", tostring(IsValid(client)), "hasPrivilege(canUseItemSpawner)=", tostring(IsValid(client) and client:hasPrivilege("canUseItemSpawner") or false), "finalResult=", tostring(IsValid(client) and id and client:hasPrivilege("canUseItemSpawner") or false))
    if not IsValid(client) or not id or not client:hasPrivilege("canUseItemSpawner") then return end
    local currentTime = CurTime()
    local lastSpawnTime = spawnCooldowns[client] or 0
    if currentTime - lastSpawnTime < 0.5 then return end
    spawnCooldowns[client] = currentTime
    local startPos, dir = client:EyePos(), client:GetAimVector()
    local tr = util.TraceLine({
        start = startPos,
        endpos = startPos + dir * 4096,
        filter = client
    })

    if not tr.Hit then return end
    lia.item.spawn(id, tr.HitPos, function(item)
        local ent = item:getEntity()
        if not IsValid(ent) then return end
        tryFixPropPosition(client, ent)
        if IsValid(client) then
            ent.SteamID = client:SteamID()
            ent.liaCharID = 0
            ent:SetCreator(client)
        end

        undo.Create(L("item"))
        undo.SetPlayer(client)
        undo.AddEntity(ent)
        local name = lia.item.list[id] and lia.item.list[id].name or id
        undo.SetCustomUndoText(L("spawnUndoText", name))
        undo.Finish(L("spawnUndoName", name))
        lia.log.add(client, "spawnItem", name, "SpawnMenuSpawnItem")
        client:notifySuccessLocalized("logItemSpawned", name)
    end, angle_zero, {})
end)

net.Receive("liaSpawnMenuGiveItem", function(_, client)
    local id, targetID = net.ReadString(), net.ReadString()
    if not IsValid(client) then return end
    if not id then return end
    lia.debug("[Permissions]", "Permission Check for net.Receive liaSpawnMenuGiveItem", "hasPrivilege(canUseItemSpawner)=", tostring(client:hasPrivilege("canUseItemSpawner")), "finalResult=", tostring(client:hasPrivilege("canUseItemSpawner")))
    if not client:hasPrivilege("canUseItemSpawner") then return end
    local targetChar = lia.char.getBySteamID(targetID)
    if not targetChar then return end
    local target = targetChar:getPlayer()
    targetChar:getInv():add(id)
    lia.log.add(client, "chargiveItem", id, target, "SpawnMenuGiveItem")
end)

net.Receive("liaManagesitroomsAction", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaManagesitroomsAction", "hasPrivilege(manageSitRooms)=", tostring(client:hasPrivilege("manageSitRooms")), "finalResult=", tostring(client:hasPrivilege("manageSitRooms")))
    if not client:hasPrivilege("manageSitRooms") then return end
    local action = net.ReadUInt(2)
    local name = net.ReadString()
    local rooms = lia.data.get("sitrooms", {})
    if action == 1 then
        local targetPos = rooms[name]
        if targetPos then
            client.previousSitroomPos = client:GetPos()
            client:SetPos(targetPos)
            client:notifySuccessLocalized("sitroomTeleport", name)
            lia.log.add(client, "sendToSitRoom", client:Name(), name)
            local message = L("staffLogTeleportedToSitRoom", client:Name(), client:SteamID64(), name)
            StaffAddTextShadowed(Color(123, 104, 238), "SIT", Color(255, 255, 255), message)
        end
    elseif action == 2 then
        local newName = net.ReadString()
        if newName ~= "" and not rooms[newName] and rooms[name] then
            rooms[newName] = rooms[name]
            rooms[name] = nil
            lia.data.set("sitrooms", rooms)
            client:notifySuccessLocalized("sitroomRenamed")
            lia.log.add(client, "sitRoomRenamed", L("sitroomRenamedDetail", name, newName), L("logRenamedSitroom"))
        end
    elseif action == 3 then
        if rooms[name] then
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", rooms)
            client:notifySuccessLocalized("sitroomRepositioned")
            lia.log.add(client, "sitRoomRepositioned", L("sitroomRepositionedDetail", name, tostring(client:GetPos())), L("logRepositionedSitroom"))
        end
    end
end)

net.Receive("liaFeaturePositionsRequest", function(_, client)
    local hasAlwaysSpawnAdminStick = client:hasPrivilege("alwaysSpawnAdminStick")
    local isStaffOnDuty = client:isStaffOnDuty()
    local permission = hasAlwaysSpawnAdminStick or isStaffOnDuty
    lia.debug("[Permissions]", "Permission Check for net.Receive liaFeaturePositionsRequest", "hasPrivilege(alwaysSpawnAdminStick)=", tostring(hasAlwaysSpawnAdminStick), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(permission))
    if not permission then return end
    local typeId = net.ReadString()
    local callback = lia.util.positionCallbacks and lia.util.positionCallbacks[typeId]
    if callback and callback.serverOnly and callback.onSelect then
        callback.onSelect(client, function(positions, count)
            net.Start("liaFeaturePositions")
            net.WriteString(typeId)
            net.WriteUInt(count or #positions, 16)
            for j = 1, #positions do
                net.WriteVector(positions[j].pos)
                net.WriteString(positions[j].label or "")
            end

            net.Send(client)
        end)
    else
        net.Start("liaFeaturePositions")
        net.WriteString(typeId)
        net.WriteUInt(0, 16)
        net.Send(client)
    end
end)

net.Receive("liaSetFeaturePosition", function(_, client)
    local hasAlwaysSpawnAdminStick = client:hasPrivilege("alwaysSpawnAdminStick")
    local isStaffOnDuty = client:isStaffOnDuty()
    local permission = hasAlwaysSpawnAdminStick or isStaffOnDuty
    lia.debug("[Permissions]", "Permission Check for net.Receive liaSetFeaturePosition", "hasPrivilege(alwaysSpawnAdminStick)=", tostring(hasAlwaysSpawnAdminStick), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(permission))
    if not permission then return end
    local typeId = net.ReadString()
    local pos = net.ReadVector()
    local callback = lia.util.positionCallbacks and lia.util.positionCallbacks[typeId]
    if callback and callback.serverOnly and callback.onRun then
        callback.onRun(pos, client, typeId)
        timer.Simple(1, function()
            if not IsValid(client) then return end
            local innerCallback = lia.util.positionCallbacks and lia.util.positionCallbacks[typeId]
            if innerCallback and innerCallback.onSelect then
                innerCallback.onSelect(client, function(positions, count)
                    net.Start("liaFeaturePositions")
                    net.WriteString(typeId)
                    net.WriteUInt(count or #positions, 16)
                    for j = 1, #positions do
                        net.WriteVector(positions[j].pos)
                        net.WriteString(positions[j].label or "")
                    end

                    net.Send(client)
                end)
            end
        end)
    end
end)

net.Receive("liaRemoveFeaturePosition", function(_, client)
    local hasAlwaysSpawnAdminStick = client:hasPrivilege("alwaysSpawnAdminStick")
    local isStaffOnDuty = client:isStaffOnDuty()
    local permission = hasAlwaysSpawnAdminStick or isStaffOnDuty
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRemoveFeaturePosition", "hasPrivilege(alwaysSpawnAdminStick)=", tostring(hasAlwaysSpawnAdminStick), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(permission))
    if not permission then return end
    local typeId = net.ReadString()
    local pos = net.ReadVector()
    local callback = lia.util.positionCallbacks and lia.util.positionCallbacks[typeId]
    if callback and callback.serverOnly and callback.onRemove then
        callback.onRemove(pos, client, typeId)
        timer.Simple(1, function()
            if not IsValid(client) then return end
            local innerCallback = lia.util.positionCallbacks and lia.util.positionCallbacks[typeId]
            if innerCallback and innerCallback.onSelect then
                innerCallback.onSelect(client, function(positions, count)
                    net.Start("liaFeaturePositions")
                    net.WriteString(typeId)
                    net.WriteUInt(count or #positions, 16)
                    for j = 1, #positions do
                        net.WriteVector(positions[j].pos)
                        net.WriteString(positions[j].label or "")
                    end

                    net.Send(client)
                end)
            end
        end)
    end
end)

net.Receive("liaRequestAllPks", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestAllPks", "hasPrivilege(manageCharacters)=", tostring(client:hasPrivilege("manageCharacters")), "finalResult=", tostring(client:hasPrivilege("manageCharacters")))
    if not client:hasPrivilege("manageCharacters") then return end
    lia.db.query("SELECT * FROM lia_permakills", function(data)
        net.Start("liaAllPks")
        net.WriteTable(data or {})
        net.Send(client)
    end)
end)

net.Receive("liaRequestPksCount", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestPksCount", "hasPrivilege(manageCharacters)=", tostring(client:hasPrivilege("manageCharacters")), "finalResult=", tostring(client:hasPrivilege("manageCharacters")))
    if not client:hasPrivilege("manageCharacters") then return end
    lia.db.count("permakills"):next(function(count)
        net.Start("liaPksCount")
        net.WriteInt(count or 0, 32)
        net.Send(client)
    end)
end)

function MODULE:PlayerShouldPermaKill(client)
    local character = client:getChar()
    if not character then return false end
    return character:getData("permakilled", false)
end

net.Receive("liaRequestFullCharList", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestFullCharList", "isValidPlayer=", tostring(IsValid(client)), "hasPrivilege(listCharacters)=", tostring(IsValid(client) and client:hasPrivilege("listCharacters") or false), "finalResult=", tostring(IsValid(client) and client:hasPrivilege("listCharacters") or false))
    if not IsValid(client) or not client:hasPrivilege("listCharacters") then return end
    lia.db.query([[SELECT c.id, c.name, c.`desc`, c.faction, c.steamID, c.lastJoinTime, c.banned, c.playtime, c.money, d.value AS charBanInfo
FROM lia_characters AS c
LEFT JOIN lia_chardata AS d ON d.charID = c.id AND d.key = 'charBanInfo']], function(data)
        local payload = {
            all = {},
            players = {}
        }

        for _, row in ipairs(data or {}) do
            local stored = lia.char.getCharacter(row.id)
            local bannedVal = tonumber(row.banned) or 0
            local isBanned = bannedVal ~= 0 and (bannedVal == -1 or bannedVal > os.time())
            local steamID = tostring(row.steamID)
            local playTime = tonumber(row.playtime) or 0
            if stored then
                local loginTime = stored:getLoginTime() or os.time()
                playTime = stored:getPlayTime() + os.time() - loginTime
            end

            local entry = {
                ID = row.id,
                Name = row.name,
                Desc = row.desc,
                Faction = row.faction,
                SteamID = steamID,
                LastUsed = stored and L("onlineNow") or row.lastJoinTime,
                Banned = isBanned,
                PlayTime = playTime,
                Money = tonumber(row.money) or 0
            }

            if isBanned then
                local banInfo = {}
                if row.charBanInfo and row.charBanInfo ~= "" then
                    local ok, decoded = pcall(pon.decode, row.charBanInfo)
                    if ok then
                        banInfo = decoded and decoded[1] or {}
                    else
                        banInfo = util.JSONToTable(row.charBanInfo) or {}
                    end
                end

                entry.BanningAdminName = banInfo.name or ""
                entry.BanningAdminSteamID = banInfo.steamID or ""
                entry.BanningAdminRank = banInfo.rank or ""
            end

            hook.Run("CharListEntry", entry, row)
            payload.all[#payload.all + 1] = entry
            payload.players[steamID] = payload.players[steamID] or {}
            table.insert(payload.players[steamID], entry)
        end

        lia.net.writeBigTable(client, "liaFullCharList", payload)
    end)
end)

net.Receive("liaRequestAllFlags", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestAllFlags", "hasPrivilege(manageFlags)=", tostring(client:hasPrivilege("manageFlags")), "finalResult=", tostring(client:hasPrivilege("manageFlags")))
    if not client:hasPrivilege("manageFlags") then return end
    lia.db.fieldExists("lia_characters", "charflags"):next(function(exists)
        if not exists then lia.db.query("ALTER TABLE lia_characters ADD COLUMN charflags VARCHAR(255) DEFAULT ''") end
        lia.db.query([[SELECT c.id, c.name, c.steamID, COALESCE(c.charflags, '') AS flags
FROM lia_characters AS c]], function(charData)
            lia.db.query([[SELECT d.charID, d.value AS flags
FROM lia_chardata AS d
WHERE d.key = 'flags']], function(chardata)
                local chardataFlags = {}
                for _, row in ipairs(chardata or {}) do
                    if row.value and row.value ~= "" then
                        local ok, decoded = pcall(pon.decode, row.value)
                        if ok and decoded then chardataFlags[row.charID] = decoded[1] or "" end
                    end
                end

                local processedData = {}
                for _, row in ipairs(charData or {}) do
                    local char = lia.char.loaded[row.id]
                    local flags = row.flags or ""
                    if flags == "" and chardataFlags[row.id] then flags = chardataFlags[row.id] end
                    if char then
                        local memoryFlags = char:getFlags() or ""
                        if memoryFlags ~= "" then flags = memoryFlags end
                    end

                    processedData[#processedData + 1] = {
                        name = row.name or "",
                        steamID = row.steamID or "",
                        flags = flags,
                    }
                end

                lia.net.writeBigTable(client, "liaAllFlags", processedData)
            end)
        end)
    end)
end)

net.Receive("liaModifyFlags", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaModifyFlags", "hasPrivilege(manageFlags)=", tostring(client:hasPrivilege("manageFlags")), "finalResult=", tostring(client:hasPrivilege("manageFlags")))
    if not client:hasPrivilege("manageFlags") then return end
    local steamID = net.ReadString()
    local flags = net.ReadString()
    flags = string.gsub(flags or "", "%s", "")
    local target = lia.util.findPlayerBySteamID(steamID)
    if IsValid(target) then
        local char = target:getChar()
        if not char then return end
        char:setFlags(flags)
        client:notifySuccessLocalized("flagSet", client:Name(), target:Name(), flags)
        return
    end

    lia.db.query("SELECT id, name FROM lia_characters WHERE steamID = " .. lia.db.convertDataType(steamID) .. " LIMIT 1", function(data)
        if not data or not data[1] then
            client:notifyLocalized("playerNotFound")
            return
        end

        local charID = data[1].id
        local charName = data[1].name
        lia.char.setCharDatabase(charID, "flags", flags)
        client:notifySuccessLocalized("flagSet", client:Name(), charName, flags)
    end)
end)

local function buildSummary()
    local d = deferred.new()
    local summary = {}
    local function ensureEntry(id, name)
        summary[id] = summary[id] or {
            player = name or "",
            steamID = id,
            usergroup = "",
            warnings = 0,
            tickets = 0,
            kicks = 0,
            kills = 0,
            respawns = 0,
            blinds = 0,
            mutes = 0,
            jails = 0,
            strips = 0
        }

        if name and name ~= "" then summary[id].player = name end
        return summary[id]
    end

    lia.db.query([[SELECT warner AS name, warnerSteamID AS steamID, COUNT(*) AS count FROM lia_warnings GROUP BY warnerSteamID]], function(warnRows)
        for _, row in ipairs(warnRows or {}) do
            local steamID = row.steamID or row.warnerSteamID
            if steamID and steamID ~= "" then
                local entry = ensureEntry(steamID, row.name)
                entry.warnings = tonumber(row.count) or 0
            end
        end

        lia.db.query([[SELECT admin AS name, adminSteamID AS steamID, COUNT(*) AS count FROM lia_ticketclaims GROUP BY adminSteamID]], function(ticketRows)
            for _, row in ipairs(ticketRows or {}) do
                local steamID = row.steamID or row.adminSteamID
                if steamID and steamID ~= "" then
                    local entry = ensureEntry(steamID, row.name)
                    entry.tickets = tonumber(row.count) or 0
                end
            end

            lia.db.query([[SELECT staffName AS name, staffSteamID AS steamID, action, COUNT(*) AS count FROM lia_staffactions GROUP BY staffSteamID, action]], function(actionRows)
                for _, row in ipairs(actionRows or {}) do
                    local steamID = row.steamID or row.staffSteamID
                    if steamID and steamID ~= "" then
                        local entry = ensureEntry(steamID, row.name)
                        local count = tonumber(row.count) or 0
                        if row.action == "plykick" then
                            entry.kicks = count
                        elseif row.action == "plykill" then
                            entry.kills = count
                        elseif row.action == "plyrespawn" then
                            entry.respawns = count
                        elseif row.action == "plyblind" then
                            entry.blinds = count
                        elseif row.action == "plymute" then
                            entry.mutes = count
                        elseif row.action == "plyjail" then
                            entry.jails = count
                        elseif row.action == "plystrip" then
                            entry.strips = count
                        end
                    end
                end

                lia.db.query([[SELECT steamName AS name, steamID, userGroup FROM lia_players]], function(playerRows)
                    for _, row in ipairs(playerRows or {}) do
                        local steamID = row.steamID
                        if steamID and steamID ~= "" then
                            local entry = ensureEntry(steamID, row.name)
                            entry.usergroup = row.userGroup or ""
                        end
                    end

                    local list = {}
                    for _, info in pairs(summary) do
                        info.warnings = info.warnings or 0
                        info.tickets = info.tickets or 0
                        info.kicks = info.kicks or 0
                        info.kills = info.kills or 0
                        info.respawns = info.respawns or 0
                        info.blinds = info.blinds or 0
                        info.mutes = info.mutes or 0
                        info.jails = info.jails or 0
                        info.strips = info.strips or 0
                        info.usergroup = info.usergroup or ""
                        list[#list + 1] = info
                    end

                    d:resolve(list)
                end)
            end)
        end)
    end)
    return d
end

net.Receive("liaRequestStaffSummary", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestStaffSummary", "hasPrivilege(viewStaffManagement)=", tostring(client:hasPrivilege("viewStaffManagement")), "finalResult=", tostring(client:hasPrivilege("viewStaffManagement")))
    if not client:hasPrivilege("viewStaffManagement") then return end
    buildSummary():next(function(data) lia.net.writeBigTable(client, "liaStaffSummary", data) end)
end)

net.Receive("liaRequestPlayers", function(_, client)
    if not client:hasPrivilege("canAccessPlayerList") then return end
    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local query = [[
SELECT steamName, steamID, userGroup, firstJoin, lastOnline, totalOnlineTime,
    (SELECT COUNT(*) FROM lia_characters WHERE steamID = lia_players.steamID AND schema = %s) AS characterCount,
    (SELECT COUNT(*) FROM lia_warnings WHERE warnedSteamID = lia_players.steamID) AS warnings,
    (SELECT COUNT(*) FROM lia_ticketclaims WHERE requesterSteamID = lia_players.steamID) AS ticketsRequested,
    (SELECT COUNT(*) FROM lia_ticketclaims WHERE adminSteamID = lia_players.steamID) AS ticketsClaimed
FROM lia_players
]]
    query = string.format(query, lia.db.convertDataType(gamemode))
    lia.db.query(query, function(data)
        data = data or {}
        for _, row in ipairs(data) do
            local ply = player.GetBySteamID(tostring(row.steamID))
            if IsValid(ply) then row.totalOnlineTime = ply:getPlayTime() end
        end

        lia.net.writeBigTable(client, "liaAllPlayers", data)
    end)
end)

net.Receive("liaRequestMapEntities", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestMapEntities", "hasPrivilege(manageCharacters)=", tostring(client:hasPrivilege("manageCharacters")), "finalResult=", tostring(client:hasPrivilege("manageCharacters")))
    if not client:hasPrivilege("manageCharacters") then return end
    local entities = {}
    for _, entity in ents.Iterator() do
        if IsValid(entity) and (entity:CreatedByMap() or entity:isDoor() or entity:isProp()) then
            entities[#entities + 1] = {
                class = entity:GetClass(),
                model = entity:GetModel(),
                name = entity:GetName() or entity.PrintName or "",
                position = tostring(entity:GetPos()),
                angles = tostring(entity:GetAngles()),
                mapCreated = entity:CreatedByMap(),
                isDoor = entity:isDoor(),
                isProp = entity:isProp(),
                health = entity:Health(),
                maxHealth = entity:GetMaxHealth(),
                material = entity:GetMaterial(),
                skin = entity:GetSkin(),
                color = entity:GetColor()
            }
        end
    end

    lia.net.writeBigTable(client, "liaMapEntities", entities)
end)

net.Receive("liaRequestOnlineStaffData", function(_, client)
    local d = deferred.new()
    local staffData = {}
    for _, ply in player.Iterator() do
        if IsValid(ply) and ply:isStaff() then
            local char = ply:getChar()
            local charID = char and char:getID() or 0
            local steamID = ply:SteamID()
            local usergroup = ply:GetUserGroup()
            local isStaffOnDuty = ply:isStaffOnDuty()
            local characterName = char and char:getName() or "N/A"
            staffData[#staffData + 1] = {
                steamID = steamID,
                charID = charID,
                name = ply:Nick(),
                usergroup = usergroup,
                isStaffOnDuty = isStaffOnDuty,
                characterName = characterName,
                tickets = 0,
                warnings = 0
            }
        end
    end

    if #staffData == 0 then
        net.Start("liaOnlineStaffData")
        net.WriteTable({})
        net.Send(client)
        return
    end

    local completedQueries = 0
    local totalQueries = #staffData * 2
    for i, staffInfo in ipairs(staffData) do
        local charID = staffInfo.charID
        local steamID = staffInfo.steamID
        if charID and charID > 0 then
            lia.db.count("warnings", "charID = " .. lia.db.convertDataType(charID)):next(function(count)
                staffData[i].warnings = count or 0
                completedQueries = completedQueries + 1
                if completedQueries >= totalQueries then d:resolve(staffData) end
            end)
        else
            completedQueries = completedQueries + 1
        end

        if steamID and steamID ~= "" then
            lia.db.count("ticketclaims", "requesterSteamID = " .. lia.db.convertDataType(steamID)):next(function(count)
                staffData[i].tickets = count or 0
                completedQueries = completedQueries + 1
                if completedQueries >= totalQueries then d:resolve(staffData) end
            end)
        else
            completedQueries = completedQueries + 1
        end
    end

    d:next(function(data)
        net.Start("liaOnlineStaffData")
        net.WriteTable(data)
        net.Send(client)
    end)
end)

local GM = GM or GAMEMODE
local restrictedProperties = {
    persist = true,
    drive = true,
    bonemanipulate = true
}

function GM:PlayerSpawnProp(client, model)
    local list = lia.data.get("prop_blacklist", {})
    local modelBlacklisted = table.HasValue(list, model)
    local canSpawnBlacklistedProps = client:hasPrivilege("canSpawnBlacklistedProps")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnProp blacklisted prop", "modelBlacklisted=", tostring(modelBlacklisted), "hasPrivilege(canSpawnBlacklistedProps)=", tostring(canSpawnBlacklistedProps), "finalResult=", tostring(not modelBlacklisted or canSpawnBlacklistedProps))
    if modelBlacklisted and not canSpawnBlacklistedProps then
        lia.log.add(client, "spawnDenied", L("prop"), model)
        client:notifyErrorLocalized("blacklistedProp")
        return false
    end

    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnProps") or client:hasFlags("e")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnProp", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnProps)=", tostring(client:hasPrivilege("canSpawnProps")), "hasFlags(e)=", tostring(client:hasFlags("e")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("prop"), model)
        client:notifyErrorLocalized("noSpawnPropsPerm", model)
    end
    return canSpawn
end

local propertyPrivilegeEquivalents = {
    bodygroups = "property_bodygroups",
    bonemanipulate = "property_bonemanipulate",
    collision = "property_collision",
    drive = "property_drive",
    editentity = "canEditSimfphysCars",
    gravity = "property_gravity",
    ignite = "property_ignite",
    extinguish = "property_extinguish",
    keepupright = "property_keepupright",
    motioncontrol_ragdoll = "property_motioncontrol_ragdoll",
    npc_bigger = "property_npc_bigger",
    npc_smaller = "property_npc_smaller",
    persist = "property_persist",
    remover = "property_remove",
    skin = "property_skin",
    statue = "property_statue",
    unstatue = "property_unstatue",
    color = "property_color",
    material = "property_material"
}

function GM:CanProperty(client, property, entity)
    local privilegeName = propertyPrivilegeEquivalents[property] or "property_" .. property
    if restrictedProperties[property] then
        lia.log.add(client, "permissionDenied", L("useProperty", property))
        client:notifyErrorLocalized("disabledFeature")
        return false
    end

    if IsValid(entity) and entity:IsWorld() then
        local canPropertyWorldEntities = client:hasPrivilege("canPropertyWorldEntities")
        lia.debug("[Permissions]", "Permission Check for hook GM:CanProperty world entity", "property=", tostring(property), "hasPrivilege(canPropertyWorldEntities)=", tostring(canPropertyWorldEntities), "finalResult=", tostring(canPropertyWorldEntities))
        if canPropertyWorldEntities then return true end
        lia.log.add(client, "permissionDenied", L("modifyWorldProperty", property))
        client:notifyErrorLocalized("noModifyWorldEntities")
        return false
    end

    if IsValid(entity) and entity:GetCreator() == client and (property == "remove" or property == "collision") then return true end
    local hasPropertyPrivilege = client:hasPrivilege(privilegeName)
    local isStaffOnDuty = client:isStaffOnDuty()
    local permission = hasPropertyPrivilege or isStaffOnDuty
    lia.debug("[Permissions]", "Permission Check for hook GM:CanProperty", "property=", tostring(property), "privilegeName=", tostring(privilegeName), "hasPrivilege(dynamicPropertyPrivilege)=", tostring(hasPropertyPrivilege), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(permission))
    if permission then return true end
    lia.log.add(client, "permissionDenied", L("modifyProperty", property))
    client:notifyErrorLocalized("noModifyProperty")
    return false
end

function GM:DrawPhysgunBeam(client)
    if client:GetMoveType() == MOVETYPE_NOCLIP then return false end
end

function GM:PlayerSpawnVehicle(client, model)
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnVehicle noCarSpawnDelay", "hasPrivilege(noCarSpawnDelay)=", tostring(client:hasPrivilege("noCarSpawnDelay")), "finalResult=", tostring(client:hasPrivilege("noCarSpawnDelay")))
    if not client:hasPrivilege("noCarSpawnDelay") then client.NextVehicleSpawn = SysTime() + lia.config.get("PlayerSpawnVehicleDelay", 30) end
    local list = lia.data.get("carBlacklist", {})
    local isBlacklistedModel = model and table.HasValue(list, model) or false
    local canSpawnBlacklistedCars = client:hasPrivilege("canSpawnBlacklistedCars")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnVehicle blacklisted car", "modelBlacklisted=", tostring(isBlacklistedModel), "hasPrivilege(canSpawnBlacklistedCars)=", tostring(canSpawnBlacklistedCars), "finalResult=", tostring(not isBlacklistedModel or canSpawnBlacklistedCars))
    if model and isBlacklistedModel and not canSpawnBlacklistedCars then
        lia.log.add(client, "spawnDenied", L("vehicle"), model)
        client:notifyErrorLocalized("blacklistedVehicle")
        return false
    end

    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnCars") or client:hasFlags("C")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnVehicle", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnCars)=", tostring(client:hasPrivilege("canSpawnCars")), "hasFlags(C)=", tostring(client:hasFlags("C")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("vehicle"), model)
        client:notifyErrorLocalized("noSpawnVehicles", model)
    end
    return canSpawn
end

function GM:PlayerSpawnEffect(client)
    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnEffects") or client:hasFlags("L")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnEffect", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnEffects)=", tostring(client:hasPrivilege("canSpawnEffects")), "hasFlags(L)=", tostring(client:hasFlags("L")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("effect"))
        client:notifyErrorLocalized("noSpawnEffects")
    end
    return canSpawn
end

function GM:PlayerSpawnNPC(client)
    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnNPCs") or client:hasFlags("n")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnNPC", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnNPCs)=", tostring(client:hasPrivilege("canSpawnNPCs")), "hasFlags(n)=", tostring(client:hasFlags("n")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("npc"))
        client:notifyErrorLocalized("noSpawnNPCs")
    end
    return canSpawn
end

function GM:PlayerSpawnRagdoll(client)
    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnRagdolls") or client:hasFlags("r")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnRagdoll", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnRagdolls)=", tostring(client:hasPrivilege("canSpawnRagdolls")), "hasFlags(r)=", tostring(client:hasFlags("r")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("ragdoll"))
        client:notifyErrorLocalized("noSpawnRagdolls")
    end
    return canSpawn
end

function GM:PlayerSpawnSENT(client, class)
    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnSENTs") or client:hasFlags("E")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnSENT", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnSENTs)=", tostring(client:hasPrivilege("canSpawnSENTs")), "hasFlags(E)=", tostring(client:hasFlags("E")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("sent"), tostring(class))
        client:notifyErrorLocalized("noSpawnSents", tostring(class))
    end
    return canSpawn
end

function GM:PlayerSpawnSWEP(client, weapon)
    local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("canSpawnSWEPs") or client:hasFlags("z")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerSpawnSWEP", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnSWEPs)=", tostring(client:hasPrivilege("canSpawnSWEPs")), "hasFlags(z)=", tostring(client:hasFlags("z")), "finalResult=", tostring(canSpawn))
    if not canSpawn then
        lia.log.add(client, "spawnDenied", L("swep"), tostring(weapon))
        client:notifyErrorLocalized("noSpawnSweps", tostring(weapon))
    end
    return canSpawn
end

function GM:PlayerGiveSWEP(client)
    local canGive = client:isStaffOnDuty() or client:hasPrivilege("canSpawnSWEPs") or client:hasFlags("W")
    lia.debug("[Permissions]", "Permission Check for hook GM:PlayerGiveSWEP", "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasPrivilege(canSpawnSWEPs)=", tostring(client:hasPrivilege("canSpawnSWEPs")), "hasFlags(W)=", tostring(client:hasFlags("W")), "finalResult=", tostring(canGive))
    if not canGive then
        lia.log.add(client, "permissionDenied", L("giveSwep"))
        client:notifyErrorLocalized("noGiveSweps")
    end
    return canGive
end

function GM:OnPhysgunReload(_, client)
    local canReload = client:hasPrivilege("canPhysgunReload")
    lia.debug("[Permissions]", "Permission Check for hook GM:OnPhysgunReload", "hasPrivilege(canPhysgunReload)=", tostring(canReload), "finalResult=", tostring(canReload))
    if not canReload then
        lia.log.add(client, "permissionDenied", L("physgunReload"))
        client:notifyErrorLocalized("noPhysgunReload")
    end
    return canReload
end

function GM:PlayerSpawnedNPC(client, entity)
    entity:SetCreator(client)
end

function GM:PlayerSpawnedEffect(client, _, entity)
    entity:SetCreator(client)
end

function GM:PlayerSpawnedProp(client, _, entity)
    entity:SetCreator(client)
end

function GM:PlayerSpawnedRagdoll(client, _, entity)
    entity:SetCreator(client)
end

function GM:PlayerSpawnedSENT(client, entity)
    entity:SetCreator(client)
end

function GM:PlayerSpawnedSWEP(client, entity)
    entity:SetCreator(client)
end

function GM:PlayerSpawnedVehicle(client, entity)
    entity:SetCreator(client)
end

function GM:CanPlayerUseChar(client)
    local isLocked = GetGlobalBool("characterSwapLock", false)
    local canBypass = client:hasPrivilege("canBypassCharacterLock")
    lia.debug("[Permissions]", "Permission Check for hook GM:CanPlayerUseChar", "characterSwapLock=", tostring(isLocked), "hasPrivilege(canBypassCharacterLock)=", tostring(canBypass), "finalResult=", tostring(not isLocked or canBypass))
    if isLocked and not canBypass then return false, L("serverEventCharLock") end
end

hook.Add("PhysgunPickup", "Lilia.PhysgunPickup", function(client, entity)
    if client:InVehicle() then
        client:notifyErrorLocalized("cmdVehicle")
        return false
    end

    local hasPhysgunPickup = client:hasPrivilege("physgunPickup")
    local isStaffOnDuty = client:isStaffOnDuty()
    lia.debug("[Permissions]", "Permission Check for hook PhysgunPickup restricted entity gate", "hasPrivilege(physgunPickup)=", tostring(hasPhysgunPickup), "isStaffOnDuty=", tostring(isStaffOnDuty), "entityNoPhysgun=", tostring(entity.NoPhysgun == true), "finalResult=", tostring((hasPhysgunPickup or isStaffOnDuty) and entity.NoPhysgun ~= nil))
    if (hasPhysgunPickup or isStaffOnDuty) and entity.NoPhysgun then
        local hasRestrictedEntitiesPrivilege = client:hasPrivilege("physgunPickupRestrictedEntities")
        lia.debug("[Permissions]", "Permission Check for hook PhysgunPickup restricted entity override", "hasPrivilege(physgunPickupRestrictedEntities)=", tostring(hasRestrictedEntitiesPrivilege), "finalResult=", tostring(hasRestrictedEntitiesPrivilege))
        if not hasRestrictedEntitiesPrivilege then
            lia.log.add(client, "permissionDenied", L("physgunRestrictedEntity"))
            client:notifyErrorLocalized("noPickupRestricted")
            return false
        end
        return true
    end

    if entity:GetCreator() == client and (entity:isProp() or entity:isItem()) then return true end
    lia.debug("[Permissions]", "Permission Check for hook PhysgunPickup base gate", "hasPrivilege(physgunPickup)=", tostring(hasPhysgunPickup), "finalResult=", tostring(hasPhysgunPickup))
    if hasPhysgunPickup then
        if entity:IsVehicle() then
            local hasVehiclePrivilege = client:hasPrivilege("physgunPickupVehicles")
            lia.debug("[Permissions]", "Permission Check for hook PhysgunPickup vehicle", "hasPrivilege(physgunPickupVehicles)=", tostring(hasVehiclePrivilege), "finalResult=", tostring(hasVehiclePrivilege))
            if not hasVehiclePrivilege then
                lia.log.add(client, "permissionDenied", L("physgunVehicle"))
                client:notifyErrorLocalized("noPickupVehicles")
                return false
            end
            return true
        elseif entity:IsPlayer() then
            local targetProtected = entity:hasPrivilege("cantBeGrabbedPhysgun")
            local canGrabPlayers = client:hasPrivilege("canGrabPlayers")
            lia.debug("[Permissions]", "Permission Check for hook PhysgunPickup player", "targetHasPrivilege(cantBeGrabbedPhysgun)=", tostring(targetProtected), "hasPrivilege(canGrabPlayers)=", tostring(canGrabPlayers), "finalResult=", tostring(not targetProtected and canGrabPlayers))
            if targetProtected or not canGrabPlayers then
                lia.log.add(client, "permissionDenied", L("physgunPlayer"))
                client:notifyErrorLocalized("noPickupPlayer")
                return false
            end
            return true
        elseif entity:IsWorld() or entity:CreatedByMap() then
            local canGrabWorldProps = client:hasPrivilege("canGrabWorldProps")
            lia.debug("[Permissions]", "Permission Check for hook PhysgunPickup world", "hasPrivilege(canGrabWorldProps)=", tostring(canGrabWorldProps), "finalResult=", tostring(canGrabWorldProps))
            if not canGrabWorldProps then
                lia.log.add(client, "permissionDenied", L("physgunWorldProp"))
                client:notifyErrorLocalized("noPickupWorld")
                return false
            end
            return true
        end
        return true
    end

    lia.log.add(client, "permissionDenied", L("physgunEntity"))
    client:notifyErrorLocalized("noPickupEntity")
    return false
end)

local DisallowedTools = {
    rope = true,
    light = true,
    lamp = true,
    dynamite = true,
    physprop = true,
    faceposer = true,
    stacker = true
}

hook.Add("CanTool", "Lilia.CanTool", function(client, trace, tool)
    if client:InVehicle() then
        client:notifyErrorLocalized("cmdVehicle")
        return false
    end

    local function CheckDuplicationScale(ply, entities)
        entities = entities or {}
        for _, v in pairs(entities) do
            if v.ModelScale and v.ModelScale > 10 then
                ply:notifyErrorLocalized("duplicationSizeLimit")
                lia.log.add(ply, "dupeCrashAttempt")
                return false
            end

            v.ModelScale = 1
        end
        return true
    end

    local hasUseDisallowedTools = client:hasPrivilege("useDisallowedTools")
    lia.debug("[Permissions]", "Permission Check for hook CanTool disallowed tools", "tool=", tostring(tool), "toolIsDisallowed=", tostring(DisallowedTools[tool] == true), "hasPrivilege(useDisallowedTools)=", tostring(hasUseDisallowedTools), "finalResult=", tostring(not DisallowedTools[tool] or hasUseDisallowedTools))
    if DisallowedTools[tool] and not hasUseDisallowedTools then
        lia.log.add(client, "toolDenied", tool)
        client:notifyErrorLocalized("toolNotAllowed", tool)
        return false
    end

    local formattedTool = tool:gsub("^%l", string.upper)
    local isStaffOrFlagged = client:isStaffOnDuty() or client:hasFlags("t")
    local hasPriv = client:hasPrivilege("tool_" .. tool)
    lia.debug("[Permissions]", "Permission Check for hook CanTool tool privilege", "tool=", tostring(tool), "isStaffOnDuty=", tostring(client:isStaffOnDuty()), "hasFlags(t)=", tostring(client:hasFlags("t")), "hasPrivilege(tool_" .. tool .. ")=", tostring(hasPriv), "finalResult=", tostring(isStaffOrFlagged and hasPriv))
    if not (isStaffOrFlagged and hasPriv) then
        local reasons = {}
        if not isStaffOrFlagged then table.insert(reasons, L("onDutyStaffOrFlagT")) end
        if not hasPriv then table.insert(reasons, L("privilege") .. " '" .. L("accessToolPrivilege", formattedTool) .. "'") end
        lia.log.add(client, "toolDenied", tool)
        client:notifyErrorLocalized("toolNoPermission", tool, table.concat(reasons, ", "))
        return false
    end

    local entity = trace.Entity
    if IsValid(entity) then
        local entClass = entity:GetClass()
        if tool == "remover" then
            if entity.NoRemover then
                local canRemoveBlockedEntities = client:hasPrivilege("canRemoveBlockedEntities")
                lia.debug("[Permissions]", "Permission Check for hook CanTool remover blocked entity", "hasPrivilege(canRemoveBlockedEntities)=", tostring(canRemoveBlockedEntities), "finalResult=", tostring(canRemoveBlockedEntities))
                if not canRemoveBlockedEntities then
                    lia.log.add(client, "permissionDenied", L("removeBlockedEntity"))
                    client:notifyErrorLocalized("noRemoveBlockedEntities")
                    return false
                end
                return true
            elseif entity:IsWorld() then
                local canRemoveWorldEntities = client:hasPrivilege("canRemoveWorldEntities")
                lia.debug("[Permissions]", "Permission Check for hook CanTool remover world entity", "hasPrivilege(canRemoveWorldEntities)=", tostring(canRemoveWorldEntities), "finalResult=", tostring(canRemoveWorldEntities))
                if not canRemoveWorldEntities then
                    lia.log.add(client, "permissionDenied", L("removeWorldEntity"))
                    client:notifyErrorLocalized("noRemoveWorldEntities")
                    return false
                end
                return true
            end
            return true
        end

        if (tool == "permaall" or tool == "blacklistandremove") and hook.Run("CanPersistEntity", entity) ~= false and (string.StartWith(entClass, "lia_") or entity.IsPersistent or entity:CreatedByMap()) then
            lia.log.add(client, "toolDenied", tool)
            client:notifyErrorLocalized("toolCantUseEntity", tool)
            return false
        end

        if (tool == "duplicator" or tool == "blacklistandremove") and entity.NoDuplicate then
            lia.log.add(client, "toolDenied", tool)
            client:notifyErrorLocalized("cannotDuplicateEntity", tool)
            return false
        end

        if tool == "weld" and entClass == "sent_ball" then
            lia.log.add(client, "toolDenied", tool)
            client:notifyErrorLocalized("cannotWeldBall")
            return false
        end
    end

    if tool == "duplicator" and client.CurrentDupe and not CheckDuplicationScale(client, client.CurrentDupe.Entities) then return false end
    return true
end)

hook.Add("GravGunPickupAllowed", "Lilia.GravGunPickupAllowed", function(client)
    if client:InVehicle() then
        client:notifyErrorLocalized("cmdVehicle")
        return false
    end
end)

hook.Add("PlayerNoClip", "Lilia.PlayerNoClip", function(ply, enabled)
    local isStaffOnDuty = ply:isStaffOnDuty()
    local hasNoClipOutsideStaff = ply:hasPrivilege("noClipOutsideStaff")
    local permission = isStaffOnDuty or hasNoClipOutsideStaff
    lia.debug("[Permissions]", "Permission Check for hook PlayerNoClip", "isStaffOnDuty=", tostring(isStaffOnDuty), "hasPrivilege(noClipOutsideStaff)=", tostring(hasNoClipOutsideStaff), "finalResult=", tostring(permission))
    if not permission then
        lia.log.add(ply, "permissionDenied", L("noclip"))
        ply:notifyErrorLocalized("noNoclip")
        return false
    end

    ply:SetNoDraw(enabled)
    ply:SetNotSolid(enabled)
    ply:DrawWorldModel(not enabled)
    ply:DrawShadow(enabled)
    ply:SetNoTarget(enabled)
    if enabled then
        ply:GodEnable()
        ply:AddFlags(FL_NOTARGET)
    else
        ply:GodDisable()
        ply:RemoveFlags(FL_NOTARGET)
    end

    hook.Run("OnPlayerObserve", ply, enabled)
    return true
end)
