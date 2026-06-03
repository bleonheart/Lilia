net.Receive("liaAdminSetCharProperty", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaAdminSetCharProperty", "hasPrivilege(listCharacters)=", tostring(client:hasPrivilege("listCharacters")), "finalResult=", tostring(client:hasPrivilege("listCharacters")))
    if not client:hasPrivilege("listCharacters") then return end
    local charID = net.ReadInt(32)
    local property = net.ReadString()
    local value = net.ReadType()
    local charIDsafe = tonumber(charID)
    if not charIDsafe then
        client:notifyErrorLocalized("invalidCharID")
        return
    end

    lia.db.query("SELECT name, money, model FROM lia_characters WHERE id = " .. charIDsafe, function(data)
        if not data or #data == 0 then
            client:notifyErrorLocalized("characterNotFound")
            return
        end

        local charData = data[1]
        if property == "money" then
            local moneyValue = tonumber(value) or 0
            if lia.char.setCharDatabase(charID, "money", moneyValue) then
                local target = lia.char.getCharacter(charID)
                if IsValid(target) then
                    client:notifySuccessLocalized("setMoney", target:Name(), lia.currency.get(moneyValue))
                else
                    client:notifySuccessLocalized("offlineCharMoneySet", charID, lia.currency.get(moneyValue))
                end

                lia.log.add(client, "adminSetCharMoney", charID, moneyValue)
            else
                client:notifyErrorLocalized("failedToUpdateChar")
            end
        elseif property == "name" then
            local nameValue = tostring(value)
            if lia.char.setCharDatabase(charID, "name", nameValue) then
                local target = lia.char.getCharacter(charID)
                if IsValid(target) then
                    client:notifySuccessLocalized("changeName", client:Name(), charData.name, nameValue)
                else
                    client:notifySuccessLocalized("offlineCharNameSet", charID, nameValue)
                end

                lia.log.add(client, "adminSetCharName", charID, nameValue)
            else
                client:notifyErrorLocalized("failedToUpdateChar")
            end
        elseif property == "model" then
            local modelValue = tostring(value)
            if lia.char.setCharDatabase(charID, "model", modelValue) then
                local target = lia.char.getCharacter(charID)
                if IsValid(target) then
                    client:notifySuccessLocalized("changeModelAdmin", client:Name(), target:Name(), modelValue)
                else
                    client:notifySuccessLocalized("offlineCharModelSet", charID, modelValue)
                end

                lia.log.add(client, "adminSetCharModel", charID, modelValue)
            else
                client:notifyErrorLocalized("failedToUpdateChar")
            end
        else
            client:notifyErrorLocalized("invalidArg")
            return
        end
    end)
end)

