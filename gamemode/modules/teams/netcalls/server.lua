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
        client:notifyErrorLocalized("invalidFaction")
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
                client:notifyErrorLocalized("alreadyInBaseFaction")
                return
            end

            if hook.Run("CanCharBeTransfered", targetChar, defaultFaction, oldFaction) == false then return end
            target:notifyWarningLocalized("kickedFromFaction")
            hook.Run("TrackFactionTransfer", targetChar, oldFaction, defaultFaction, client, "kickToBase")
            targetChar.vars.faction = defaultFaction.uniqueID
            targetChar:setFaction(defaultFaction.index)
            hook.Run("OnTransferred", target)
            if defaultFaction.OnTransferred then defaultFaction:OnTransferred(target, oldFaction) end
            hook.Run("PlayerLoadout", target)
            targetChar:save()
            client:notifySuccessLocalized("transferSuccess", target:Name(), defaultFaction.name)
            lia.log.add(client, "kickToBaseFaction", target:Name(), oldFactionData and oldFactionData.name or tostring(oldFaction), defaultFaction.name)
        end
    end

    if not isOnline then
        lia.db.query("SELECT faction FROM lia_characters WHERE id = " .. characterID):next(function(data)
            if not data or not data[1] then
                client:notifyErrorLocalized("characterNotFound")
                return
            end

            local currentFaction = data[1].faction
            local currentFactionData = lia.faction.get(currentFaction)
            if currentFactionData and currentFactionData.isDefault then
                client:notifyErrorLocalized("alreadyInBaseFaction")
                return
            end

            MODULE:TrackOfflineFactionTransfer(characterID, currentFaction, defaultFaction, client, "kickToBase")
            lia.db.updateTable({
                faction = defaultFaction.uniqueID
            }, nil, "characters", "id = " .. characterID)

            client:notifySuccessLocalized("transferSuccess", L("character"), defaultFaction.name)
            lia.log.add(client, "kickToBaseFaction", L("character"), currentFactionData and currentFactionData.name or tostring(currentFaction), defaultFaction.name)
        end)
    end
end)
