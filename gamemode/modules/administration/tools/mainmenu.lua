if SERVER then
    function MODULE:syncCharList(client)
        if not client.liaCharList then return end
        net.Start("liaCharList")
        net.WriteUInt(#client.liaCharList, 32)
        for i = 1, #client.liaCharList do
            net.WriteUInt(client.liaCharList[i], 32)
        end

        net.Send(client)
    end

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

    function MODULE:PlayerLoadedChar(client, character)
        local charID = character:getID()
        lia.db.query("SELECT key, value FROM lia_chardata WHERE charID = " .. charID, function(data)
            if data then
                if not character.dataVars then character.dataVars = {} end
                for _, row in ipairs(data) do
                    local decodedValue = pon.decode(row.value)
                    character.dataVars[row.key] = decodedValue[1]
                    character:setData(row.key, decodedValue[1])
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
else
    function MODULE:PlayerButtonDown(_, button)
        if button == KEY_ESCAPE and IsValid(lia.gui.menu) and LocalPlayer():getChar() then
            lia.gui.menu:Remove()
            return true
        end
    end

    function MODULE:ResetCharacterPanel()
        if IsValid(lia.gui.character) then lia.gui.character:Remove() end
        vgui.Create("liaCharacter")
    end

    function MODULE:chooseCharacter(id)
        assert(isnumber(id), "id must be a number")
        local d = deferred.new()
        net.Receive("liaCharChoose", function()
            local message = net.ReadString()
            if message == "" then
                d:resolve()
                hook.Run("CharLoaded", lia.char.loaded[id])
            else
                d:reject(message)
            end
        end)

        net.Start("liaCharChoose")
        net.WriteUInt(id, 32)
        net.SendToServer()
        return d
    end

    function MODULE:createCharacter(data)
        local client = LocalPlayer()
        assert(istable(data), "data must be a table")
        local d = deferred.new()
        local payload = {}
        for key, charVar in pairs(lia.char.vars) do
            if charVar.noDisplay then continue end
            local value = data[key]
            if isfunction(charVar.onValidate) then
                local results = {charVar.onValidate(value, data, client)}
                if results[1] == false then return d:reject(L(unpack(results, 2))) end
            end

            payload[key] = value
        end

        net.Receive("liaCharCreate", function()
            local id = net.ReadUInt(32)
            local reason = net.ReadString()
            if id > 0 then
                d:resolve(id)
            else
                d:reject(reason)
            end
        end)

        net.Start("liaCharCreate")
        net.WriteUInt(table.Count(payload), 32)
        for key, value in pairs(payload) do
            net.WriteString(key)
            net.WriteType(value)
        end

        net.SendToServer()
        return d
    end

    function MODULE:deleteCharacter(id)
        assert(isnumber(id), "id must be a number")
        net.Start("liaCharDelete")
        net.WriteUInt(id, 32)
        net.SendToServer()
    end

    function MODULE:LiliaLoaded()
        vgui.Create("liaCharacter")
    end

    function MODULE:KickedFromChar(_, isCurrentChar)
        if isCurrentChar then vgui.Create("liaCharacter") end
    end

    function MODULE:CreateMenuButtons(tabs)
        tabs[L("characters")] = function()
            local client = LocalPlayer()
            if client:IsInThirdPerson() then
                lia.option.set("thirdPersonEnabled", false)
                hook.Run("thirdPersonToggled", false)
            end

            if IsValid(lia.gui.menu) then lia.gui.menu:Remove() end
            vgui.Create("liaCharacter")
        end
    end
end