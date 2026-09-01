local MODULE = MODULE
net.Receive("liaKickCharacterToBase", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaKickCharacterToBase", "hasPrivilege(canManageFactions)=", tostring(client:hasPrivilege("canManageFactions")), "finalResult=", tostring(client:hasPrivilege("canManageFactions")))
    if not client:hasPrivilege("canManageFactions") then return end
    local characterID = net.ReadUInt(32)
    local defaultFaction
    for _, fac in pairs(lia.faction.teams) do
        if fac.isDefault and fac.uniqueID ~= "staff" then
            defaultFaction = fac
            break
        end
    end

    if not defaultFaction then
        for _, fac in pairs(lia.faction.teams) do
            if fac.uniqueID ~= "staff" then
                defaultFaction = fac
                break
            end
        end
    end

    if not defaultFaction then
        local _, fac = next(lia.faction.teams)
        defaultFaction = fac
    end

    if not defaultFaction then
        client:notifyError("The specified faction is not valid.")
        return
    end

    local isOnline = false
    for _, target in player.Iterator() do
        local targetChar = target:getChar()
        if targetChar and targetChar:getID() == characterID then
            isOnline = true
            local oldFaction = targetChar:getFaction()
            local oldFactionData = lia.faction.indices[oldFaction]
            if oldFactionData and oldFactionData.isDefault then
                client:notifyError("Character is already in the base faction.")
                return
            end

            if hook.Run("CanCharBeTransfered", targetChar, defaultFaction, oldFaction) == false then return end
            target:notifyWarning("You were kicked from your faction!")
            hook.Run("TrackFactionTransfer", targetChar, oldFaction, defaultFaction, client, "kickToBase")
            targetChar.vars.faction = defaultFaction.uniqueID
            targetChar:setFaction(defaultFaction.index)
            hook.Run("OnTransferred", target)
            if defaultFaction.OnTransferred then defaultFaction:OnTransferred(target, oldFaction) end
            hook.Run("PlayerLoadout", target)
            targetChar:save()
            client:notifySuccess(string.format("%s has been transferred to %s.", target:Name(), defaultFaction.name))
            lia.log.add(client, "kickToBaseFaction", target:Name(), oldFactionData and oldFactionData.name or tostring(oldFaction), defaultFaction.name)
        end
    end

    if not isOnline then
        lia.db.query("SELECT faction FROM lia_characters WHERE id = " .. characterID):next(function(data)
            local rows = data.results or {}
            if not rows[1] then
                client:notifyError("Character not found.")
                return
            end

            local currentFaction = rows[1].faction
            local currentFactionData = lia.faction.get(currentFaction)
            if currentFactionData and currentFactionData.isDefault then
                client:notifyError("Character is already in the base faction.")
                return
            end

            MODULE:TrackOfflineFactionTransfer(characterID, currentFaction, defaultFaction, client, "kickToBase")
            lia.db.updateTable({
                faction = defaultFaction.uniqueID
            }, nil, "characters", "id = " .. characterID)

            client:notifySuccess(string.format("%s has been transferred to %s.", "Character", defaultFaction.name))
            lia.log.add(client, "kickToBaseFaction", "Character", currentFactionData and currentFactionData.name or tostring(currentFaction), defaultFaction.name)
        end)
    end
end)

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

local function buildFactionMembersPayload(client, factionUniqueID, callback)
    local faction = lia.faction.get(factionUniqueID)
    if not faction then
        if callback then
            callback({
                faction = factionUniqueID,
                members = {}
            })
        end
        return
    end

    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local query = string.format([[
        SELECT c.id, c.name, c.lastJoinTime, c.steamID, c.class, c.playtime
        FROM lia_characters AS c
        WHERE c.faction = %s AND c.schema = %s
        ORDER BY c.lastJoinTime DESC
    ]], lia.db.convertDataType(faction.uniqueID), lia.db.convertDataType(gamemode))
    lia.db.query(query, function(data)
        local rows = data or {}
        local ids = {}
        for _, row in ipairs(rows) do
            local charID = tonumber(row.id)
            if charID then ids[#ids + 1] = charID end
        end

        local function finish()
            local members = {}
            for _, row in ipairs(rows) do
                local charID = tonumber(row.id) or row.id
                local lastOnlineText
                local owner = lia.char.getOwnerByID(charID)
                if not IsValid(owner) and row.steamID then
                    local ply = player.GetBySteamID(tostring(row.steamID))
                    local ownerChar = IsValid(ply) and ply:getChar() or nil
                    if ownerChar and ownerChar:getID() == tonumber(charID) then owner = ply end
                end

                local ownerChar = IsValid(owner) and owner:getChar() or nil
                if ownerChar and ownerChar:getID() == tonumber(charID) then
                    lastOnlineText = "Online now"
                else
                    lastOnlineText = row.lastJoinTime or "Unknown"
                end

                local classIndex = tonumber(row.class) or 0
                local classData = lia.class.list[classIndex]
                members[#members + 1] = {
                    name = row.name or "Unknown",
                    lastOnline = lastOnlineText,
                    lastActive = row.lastJoinTime or "Unknown",
                    charID = charID,
                    steamID = row.steamID,
                    class = classIndex,
                    className = classData and classData.name or nil,
                    playtime = tonumber(row.playtime) or 0
                }
            end

            if callback then
                callback({
                    faction = faction.uniqueID,
                    members = members
                })
            end
        end

        finish()
    end)
end

local function sendFactionMembers(client, factionUniqueID)
    buildFactionMembersPayload(client, factionUniqueID, function(payload) lia.net.writeBigTable(client, "liaFactionMembers", payload) end)
end

local function buildFactionMemberDetailsPayload(client, factionUniqueID, charID, callback)
    local faction = lia.faction.get(factionUniqueID)
    charID = tonumber(charID)
    if not faction or not charID then
        if callback then
            callback({
                faction = factionUniqueID,
                charID = charID
            })
        end
        return
    end

    local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
    local query = string.format([[
        SELECT c.id, c.name, c.lastJoinTime, c.steamID, c.class, c.playtime
        FROM lia_characters AS c
        WHERE c.id = %s AND c.faction = %s AND c.schema = %s
        LIMIT 1
    ]], charID, lia.db.convertDataType(faction.uniqueID), lia.db.convertDataType(gamemode))
    lia.db.query(query, function(data)
        local row = data and data[1]
        if not row then
            if callback then
                callback({
                    faction = faction.uniqueID,
                    charID = charID
                })
            end
            return
        end

        local trackedKeys = {}
        for key in pairs(TRACKED_FACTION_KEYS) do
            trackedKeys[#trackedKeys + 1] = "'" .. lia.db.escape(key) .. "'"
        end

        lia.db.query(string.format("SELECT `charID`, `key`, `value` FROM `lia_chardata` WHERE `charID` = %d AND `key` IN (%s)", charID, table.concat(trackedKeys, ",")), function(extraRows)
            local charData = {}
            for _, extraRow in ipairs(extraRows or {}) do
                charData[extraRow.key] = decodeTrackedFactionRow(extraRow.value)
            end

            local owner = lia.char.getOwnerByID(charID)
            if not IsValid(owner) and row.steamID then
                local ply = player.GetBySteamID(tostring(row.steamID))
                local ownerChar = IsValid(ply) and ply:getChar() or nil
                if ownerChar and ownerChar:getID() == charID then owner = ply end
            end

            local ownerChar = IsValid(owner) and owner:getChar() or nil
            if ownerChar and ownerChar.getData then
                for key in pairs(TRACKED_FACTION_KEYS) do
                    charData[key] = ownerChar:getData(key, charData[key])
                end
            end

            local now = os.time()
            local classIndex = tonumber(row.class) or 0
            local classData = lia.class.list[classIndex]
            local joinDates = istable(charData.factionJoinDates) and charData.factionJoinDates or {}
            local joinDate = tonumber(joinDates[faction.uniqueID]) or nil
            local factionPlaytime = istable(charData.factionPlaytime) and charData.factionPlaytime or {}
            local playtimeInFaction = tonumber(factionPlaytime[faction.uniqueID]) or 0
            local lastOnlineText = row.lastJoinTime or "Unknown"
            if ownerChar and ownerChar:getID() == charID then
                lastOnlineText = "Online now"
                if ownerChar:getFaction() == faction.index and tonumber(ownerChar.liaFactionSessionStart or 0) > 0 then playtimeInFaction = playtimeInFaction + math.max(0, now - tonumber(ownerChar.liaFactionSessionStart)) end
            end

            local notesByFaction = istable(charData.factionNotes) and charData.factionNotes or {}
            local noteData = notesByFaction[faction.uniqueID]
            local member = {
                name = row.name or "Unknown",
                lastOnline = lastOnlineText,
                lastActive = row.lastJoinTime or "Unknown",
                charID = charID,
                steamID = row.steamID,
                class = classIndex,
                className = classData and classData.name or nil,
                playtime = tonumber(row.playtime) or 0,
                joinDate = joinDate,
                timeInFaction = joinDate and math.max(0, now - joinDate) or 0,
                playtimeInFaction = playtimeInFaction,
                transferHistory = sanitizeFactionHistory(charData.factionTransferHistory),
                factionNote = istable(noteData) and tostring(noteData.text or "") or isstring(noteData) and noteData or "",
                factionNoteMeta = istable(noteData) and {
                    updatedAt = tonumber(noteData.updatedAt) or nil,
                    updatedBy = noteData.updatedBy,
                    updatedBySteamID = noteData.updatedBySteamID
                } or nil
            }

            if callback then
                callback({
                    faction = faction.uniqueID,
                    charID = charID,
                    member = member
                })
            end
        end)
    end)
end

local function sendFactionMemberDetails(client, factionUniqueID, charID)
    buildFactionMemberDetailsPayload(client, factionUniqueID, charID, function(payload) lia.net.writeBigTable(client, "liaFactionMemberDetails", payload) end)
end

net.Receive("liaRequestFactionMembers", function(_, client)
    local factionUniqueID = net.ReadString()
    if not factionUniqueID or factionUniqueID == "" then return end
    local access = hook.Run("CanAccessFactionRoster", client, factionUniqueID)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestFactionMembers", "hasFactionRosterAccess=", tostring(access))
    if access == false then return end
    sendFactionMembers(client, factionUniqueID)
end)

net.Receive("liaRequestFactionMemberDetails", function(_, client)
    local factionUniqueID = net.ReadString()
    local charID = net.ReadUInt(32)
    if not factionUniqueID or factionUniqueID == "" or not charID or charID == 0 then return end
    if hook.Run("CanAccessFactionRoster", client, factionUniqueID) == false then return end
    sendFactionMemberDetails(client, factionUniqueID, charID)
end)

net.Receive("liaSaveFactionNote", function(_, client)
    local charID = tonumber(net.ReadUInt(32))
    local factionUniqueID = net.ReadString()
    local noteText = string.Trim(net.ReadString() or "")
    if not charID or not factionUniqueID or factionUniqueID == "" then return end
    if hook.Run("CanEditFactionNotes", client, factionUniqueID) == false then return end
    if #noteText > 4096 then noteText = noteText:sub(1, 4096) end
    local faction = lia.faction.get(factionUniqueID)
    if not faction then return end
    local loadedCharacter = lia.char.loaded[charID]
    local function saveNote()
        local noteData = noteText ~= "" and {
            text = noteText,
            updatedAt = os.time(),
            updatedBy = client:Name(),
            updatedBySteamID = client:SteamID()
        } or nil

        if loadedCharacter then
            local notesByFaction = loadedCharacter:getData("factionNotes", {})
            if not istable(notesByFaction) then notesByFaction = {} end
            notesByFaction[factionUniqueID] = noteData
            if noteData == nil and table.IsEmpty(notesByFaction) then
                loadedCharacter:setData("factionNotes", nil)
            else
                loadedCharacter:setData("factionNotes", notesByFaction)
            end
        else
            lia.char.getCharData(charID, "factionNotes"):next(function(notesByFaction)
                if not istable(notesByFaction) then notesByFaction = {} end
                notesByFaction[factionUniqueID] = noteData
                if noteData == nil and table.IsEmpty(notesByFaction) then
                    lia.char.setCharDatabase(charID, "factionNotes", nil)
                else
                    lia.char.setCharDatabase(charID, "factionNotes", notesByFaction)
                end

                sendFactionMemberDetails(client, factionUniqueID, charID)
            end):catch(function(message) lia.error("Failed to load faction notes: " .. tostring(message)) end)
            return
        end

        sendFactionMemberDetails(client, factionUniqueID, charID)
    end

    if loadedCharacter then
        if loadedCharacter:getFaction() ~= faction.index then return end
        saveNote()
        return
    end

    lia.db.query("SELECT faction FROM lia_characters WHERE id = " .. charID, function(data)
        if not data or not data[1] or data[1].faction ~= faction.uniqueID then return end
        saveNote()
    end)
end)
