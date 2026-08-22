net.Receive("liaStorageExit", function(_, client)
    local storage = client.liaStorageEntity
    if IsValid(storage) then storage.receivers[client] = nil end
    client.liaStorageEntity = nil
end)

net.Receive("liaStorageUnlock", function(_, client)
    local password = net.ReadString()
    local storageFunc = function()
        if not IsValid(client.liaStorageEntity) then return end
        if client:GetPos():Distance(client.liaStorageEntity:GetPos()) > 128 then return end
        return client.liaStorageEntity
    end

    local passwordDelay = 1
    local storage = storageFunc()
    if not storage then return end
    if client.lastPasswordAttempt and CurTime() < client.lastPasswordAttempt + passwordDelay then
        client:notifyWarningLocalized("passwordTooQuick")
    else
        if storage.password == password then
            lia.log.add(client, "storageUnlock", storage:GetClass())
            storage:openInv(client)
        else
            lia.log.add(client, "storageUnlockFailed", storage:GetClass(), password)
            client:notifyErrorLocalized("wrongPassword")
            client.liaStorageEntity = nil
        end

        client.lastPasswordAttempt = CurTime()
    end
end)

net.Receive("liaStorageSetPassword", function(_, client)
    local action = net.ReadString()
    local storageFunc = function()
        if not IsValid(client.liaStorageEntity) then return end
        if client:GetPos():Distance(client.liaStorageEntity:GetPos()) > 128 then return end
        return client.liaStorageEntity
    end

    local storage = storageFunc()
    if not storage or not storage.receivers[client] then return end
    if action == "remove" then
        if not storage.password then
            client:notifyErrorLocalized("storageNotLocked")
            return
        end

        storage.password = nil
        storage:setNetVar("locked", false)
        client:notifySuccessLocalized("storageUnlocked")
        lia.log.add(client, "storagePasswordRemoved", storage:GetClass())
    elseif action == "set" then
        local newPassword = net.ReadString()
        if not newPassword or newPassword == "" then
            client:notifyErrorLocalized("invalidPassword")
            return
        end

        storage.password = newPassword
        storage:setNetVar("locked", true)
        client:notifySuccessLocalized("storageLocked")
        lia.log.add(client, "storagePasswordSet", storage:GetClass())
    elseif action == "change" then
        if not storage.password then
            client:notifyErrorLocalized("storageNotLocked")
            return
        end

        local oldPassword = net.ReadString()
        local newPassword = net.ReadString()
        if storage.password ~= oldPassword then
            client:notifyErrorLocalized("wrongPassword")
            return
        end

        if not newPassword or newPassword == "" then
            client:notifyErrorLocalized("invalidPassword")
            return
        end

        storage.password = newPassword
        storage:setNetVar("locked", true)
        client:notifySuccessLocalized("storagePasswordChanged")
        lia.log.add(client, "storagePasswordChanged", storage:GetClass())
    end

    hook.Run("UpdateEntityPersistence", storage)
end)
