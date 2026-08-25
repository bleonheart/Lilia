if CLIENT then
net.Receive("liaClassUpdate", function()
    local joinedClient = net.ReadEntity()
    if lia.gui.classes and lia.gui.classes:IsVisible() then
        if joinedClient == LocalPlayer() then
            lia.gui.classes:loadClasses()
        else
            for _, v in ipairs(lia.gui.classes.classPanels) do
                local data = v.data
                v:setNumber(#lia.class.getPlayers(data.index))
            end
        end
    end
end)

net.Receive("liaCharList", function()
    local newCharList = {}
    local length = net.ReadUInt(32)
    for i = 1, length do
        newCharList[i] = net.ReadUInt(32)
    end

    local oldCharList = lia.characters
    lia.characters = newCharList
    if oldCharList then
        hook.Run("CharListUpdated", oldCharList, newCharList)
    else
        hook.Run("CharListLoaded", newCharList)
    end

    hook.Run("ResetCharacterPanel")
end)

net.Receive("liaCharInfo", function()
    local data = net.ReadTable()
    local id = net.ReadUInt(32)
    local client = net.BytesLeft() > 0 and net.ReadEntity() or nil
    lia.char.addCharacter(id, lia.char.new(data, id, client == nil and LocalPlayer() or client))
end)

net.Receive("liaCharKick", function()
    local id = net.ReadUInt(32)
    local isCurrentChar = net.ReadBool()
    hook.Run("KickedFromChar", id, isCurrentChar)
end)

net.Receive("liaCharacterData", function()
    local charID = net.ReadUInt(32)
    local character = lia.char.getCharacter(charID)
    if not character then return end
    if not character.dataVars then character.dataVars = {} end
    local keyCount = net.ReadUInt(32)
    for _ = 1, keyCount do
        local key = net.ReadString()
        local value = net.ReadType()
        character.dataVars[key] = value
    end
end)

net.Receive("liaCharSet", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local id = net.ReadType()
    id = id or LocalPlayer():getChar() and LocalPlayer():getChar().id
    lia.char.getCharacter(id, nil, function(character)
        if character then
            local oldValue = character.vars[key]
            character.vars[key] = value
            hook.Run("OnCharVarChanged", character, key, oldValue, value)
        end
    end)
end)

net.Receive("liaCharVar", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local id = net.ReadType()
    id = id or LocalPlayer():getChar() and LocalPlayer():getChar().id
    lia.char.getCharacter(id, nil, function(character)
        if character then
            local oldVar = character:getVar()[key]
            character:getVar()[key] = value
            hook.Run("OnCharNetVarChanged", character, key, oldVar, value)
        end
    end)
end)
end
if SERVER then
net.Receive("liaCharDelete", function(_, client)
    local id = net.ReadUInt(32)
    local steamID = client:SteamID()
    local character = lia.char.loaded[id]
    if character then
        if character.steamID == steamID then
            hook.Run("CharDeleted", client, character)
            character:delete()
            timer.Simple(.5, function() hook.Run("SyncCharList", client) end)
        end
        return
    end

    lia.db.selectOne("*", "characters", "id = " .. id):next(function(result)
        if not result then return end
        if result.steamID ~= steamID then return end
        if not table.HasValue(client.liaCharList or {}, id) then return end
        lia.char.getCharacter(id, client, function(loadedChar)
            if not loadedChar then return end
            hook.Run("CharDeleted", client, loadedChar)
            loadedChar:delete()
            timer.Simple(.5, function() hook.Run("SyncCharList", client) end)
        end)
    end)
end)
net.Receive("liaCharCreate", function(_, client)
    local function response(id, message, ...)
        net.Start("liaCharCreate")
        net.WriteUInt(id or 0, 32)
        net.WriteString(message or "")
        net.Send(client)
    end

    local numValues = net.ReadUInt(32)
    local data = {}
    for _ = 1, numValues do
        data[net.ReadString()] = net.ReadType()
    end

    if not (istable(data) and data.faction == FACTION_STAFF) and hook.Run("CanPlayerCreateChar", client, data) == false then return response(nil, "maxCharactersReached") end
    local originalData = table.Copy(data)
    local newData = {}
    for key in pairs(data) do
        if not lia.char.vars[key] then data[key] = nil end
    end

    for key, charVar in pairs(lia.char.vars) do
        local value = data[key]
        if not isfunction(charVar.onValidate) and charVar.noDisplay then
            data[key] = nil
            continue
        end

        if isfunction(charVar.onValidate) then
            local result = {charVar.onValidate(value, data, client)}
            if result[1] == false then
                result[2] = result[2] or "Validation failed."
                return response(nil, unpack(result, 2))
            end
        end

        if isfunction(charVar.onAdjust) then charVar.onAdjust(client, data, value, newData) end
    end

    hook.Run("AdjustCreationData", client, data, newData, originalData)
    data = table.Merge(data, newData)
    data.steamID = client:SteamID()
    lia.char.create(data, function(id)
        if IsValid(client) then
            lia.char.getCharacter(id, client, function(character)
                if not character then return end
                character:sync(client)
                table.insert(client.liaCharList, id)
                hook.Run("SyncCharList", client)
                hook.Run("OnCharCreated", client, character, originalData)
                local currentChar = client:getChar()
                if currentChar then currentChar:save() end
                local unloadedCount = lia.char.unloadUnusedCharacters(client, id)
                if unloadedCount > 0 then lia.information("Unloaded" .. " " .. unloadedCount .. " " .. "unused characters for" .. " " .. client:Name()) end
                hook.Run("PrePlayerLoadedChar", client, character, currentChar)
                character:setup()
                hook.Run("PlayerLoadedChar", client, character, currentChar)
                hook.Run("PostPlayerLoadedChar", client, character, currentChar)
                response(id)
            end)
        end
    end)
end)
net.Receive("liaCharChoose", function(_, client)
    local function response(message)
        net.Start("liaCharChoose")
        net.WriteString(message or "")
        net.Send(client)
    end

    local id = net.ReadUInt(32)
    local currentChar = client:getChar()
    if currentChar and currentChar:getID() == id then
        response()
        return
    end

    if not lia.char.isLoaded(id) then
        if not table.HasValue(client.liaCharList or {}, id) then
            lia.db.selectOne("faction", "characters", "id = " .. id):next(function(result)
                local isStaffFaction = result and (result.faction == "staff" or tonumber(result.faction) == FACTION_STAFF) or false
                local allowStaffChar = isStaffFaction and client:hasPrivilege("createStaffCharacter")
                lia.debug("[Permissions]", "Permission Check for net.Receive liaCharacterChoose staff fallback", "dbResultExists=", tostring(result ~= nil), "targetFactionIsStaff=", tostring(isStaffFaction), "hasPrivilege(createStaffCharacter)=", tostring(client:hasPrivilege("createStaffCharacter")), "finalResult=", tostring(allowStaffChar))
                if not allowStaffChar then return response(false, "invalidChar") end
                lia.char.loadSingleCharacter(id, client, function(character)
                    if not character then return response(false, "invalidChar") end
                    local status, reason = hook.Run("CanPlayerUseChar", client, character)
                    if status == false then
                        if reason[1] == "@" then reason = reason:sub(2) end
                        return response(reason)
                    end

                    if currentChar then
                        status, reason = hook.Run("CanPlayerSwitchChar", client, currentChar, character)
                        if status == false then
                            if reason[1] == "@" then reason = reason:sub(2) end
                            return response(reason)
                        end

                        currentChar:save()
                    end

                    local unloadedCount = lia.char.unloadUnusedCharacters(client, id)
                    if unloadedCount > 0 then lia.information("Unloaded" .. " " .. unloadedCount .. " " .. "unused characters for" .. " " .. client:Name()) end
                    hook.Run("PrePlayerLoadedChar", client, character, currentChar)
                    character:setup()
                    hook.Run("PlayerLoadedChar", client, character, currentChar)
                    response()
                    hook.Run("PostPlayerLoadedChar", client, character, currentChar)
                end)
            end)
            return
        end

        lia.char.loadSingleCharacter(id, client, function(character)
            if not character then return response(false, "invalidChar") end
            local status, result = hook.Run("CanPlayerUseChar", client, character)
            if status == false then
                if result[1] == "@" then result = result:sub(2) end
                return response(result)
            end

            if currentChar then
                status, result = hook.Run("CanPlayerSwitchChar", client, currentChar, character)
                if status == false then
                    if result[1] == "@" then result = result:sub(2) end
                    return response(result)
                end

                currentChar:save()
            end

            local unloadedCount = lia.char.unloadUnusedCharacters(client, id)
            if unloadedCount > 0 then lia.information("Unloaded" .. " " .. unloadedCount .. " " .. "unused characters for" .. " " .. client:Name()) end
            hook.Run("PrePlayerLoadedChar", client, character, currentChar)
            character:setup()
            hook.Run("PlayerLoadedChar", client, character, currentChar)
            response()
            hook.Run("PostPlayerLoadedChar", client, character, currentChar)
        end)
        return
    end

    local character = lia.char.getCharacter(id, client)
    if not character or character:getPlayer() ~= client then return response(false, "invalidChar") end
    local status, result = hook.Run("CanPlayerUseChar", client, character)
    if status == false then
        if result[1] == "@" then result = result:sub(2) end
        return response(result)
    end

    if currentChar then
        status, result = hook.Run("CanPlayerSwitchChar", client, currentChar, character)
        if status == false then
            if result[1] == "@" then result = result:sub(2) end
            return response(result)
        end

        currentChar:save()
    end

    local unloadedCount = lia.char.unloadUnusedCharacters(client, id)
    if unloadedCount > 0 then lia.information("Unloaded" .. " " .. unloadedCount .. " " .. "unused characters for" .. " " .. client:Name()) end
    hook.Run("PrePlayerLoadedChar", client, character, currentChar)
    character:setup()
    hook.Run("PlayerLoadedChar", client, character, currentChar)
    response()
    hook.Run("PostPlayerLoadedChar", client, character, currentChar)
end)
net.Receive("liaCharRequest", function(_, client)
    local charID = net.ReadUInt(32)
    lia.char.getCharacter(charID, client, function(character) if character then character:sync(client) end end)
end)
end
