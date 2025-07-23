function MODULE:PlayerLiliaDataLoaded(client)
    lia.char.restore(client, function(charList)
        if not IsValid(client) then return end
        MsgN(L("loadedCharacters", table.concat(charList, ", "), client:Name()))
        for _, v in ipairs(charList) do
            local char = lia.char.loaded[v]
            if char then
                char:sync(client)
                local data = char:getData()
                if not table.IsEmpty(data) then
                    local keys = table.GetKeys(data)
                    net.Start("liaCharacterData")
                    net.WriteUInt(char:getID(), 32)
                    net.WriteUInt(#keys, 32)
                    for _, key in ipairs(keys) do
                        net.WriteString(key)
                        net.WriteType(data[key])
                    end
                    net.Send(client)
                end
            end
        end

        for _, v in player.Iterator() do
            if v:getChar() then v:getChar():sync(client) end
        end

        client.liaCharList = charList
        self:syncCharList(client)
        client.liaLoaded = true
    end)
end

function MODULE:CanPlayerUseChar(_, character)
    local banned = character:getData("banned")
    if banned and isnumber(banned) and banned > os.time() then return false, L("bannedCharacter") end
    return true
end

function MODULE:CanPlayerSwitchChar(client, character, newCharacter)
    local banned = character:getData("banned")
    if character:getID() == newCharacter:getID() then return false, L("alreadyUsingCharacter") end
    if banned and isnumber(banned) and banned > os.time() then return false, L("bannedCharacter") end
    if not client:Alive() then return false, L("youAreDead") end
    if client:hasRagdoll() then return false, L("youAreRagdolled") end
    if client:hasValidVehicle() then return false, L("cannotSwitchInVehicle") end
    return true
end

function MODULE:PlayerLoadedChar(client, character)
    local charID = character:getID()
    lia.db.query("SELECT _key, _value FROM lia_chardata WHERE _charID = " .. charID, function(data)
        if data then
            if not character.dataVars then character.dataVars = {} end
            for _, row in ipairs(data) do
                local decodedValue = pon.decode(row._value)
                character.dataVars[row._key] = decodedValue[1]
                character:setData(row._key, decodedValue[1])
            end

            local characterData = character:getData()
            local keysToNetwork = table.GetKeys(characterData)
            net.Start("liaCharacterData")
            net.WriteUInt(charID, 32)
            net.WriteUInt(#keysToNetwork, 32)
            for _, key in ipairs(keysToNetwork) do
                local value = characterData[key]
                net.WriteString(key)
                net.WriteType(value)
            end

            net.Send(client)
        else
            print("No data found for character ID:", charID)
        end
    end)

    client:Spawn()
end