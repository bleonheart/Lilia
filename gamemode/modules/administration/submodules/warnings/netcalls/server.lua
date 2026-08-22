local MODULE = MODULE
net.Receive("liaRequestRemoveWarning", function(_, client)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaRequestRemoveWarning", "hasPrivilege(canRemoveWarns)=", tostring(client:hasPrivilege("canRemoveWarns")), "finalResult=", tostring(client:hasPrivilege("canRemoveWarns")))
    if not client:hasPrivilege("canRemoveWarns") then return end
    local charID = net.ReadInt(32)
    local rowData = net.ReadTable()
    local warnIndex = tonumber(rowData.ID or rowData.index)
    if not warnIndex then
        client:notifyErrorLocalized("invalidWarningIndex")
        return
    end

    lia.char.getCharacter(charID, client, function(targetChar)
        if not targetChar then
            client:notifyErrorLocalized("characterNotFound")
            return
        end

        local targetClient = targetChar:getPlayer()
        if not IsValid(targetClient) then
            client:notifyErrorLocalized("playerNotFound")
            return
        end

        MODULE:RemoveWarning(charID, warnIndex):next(function(warn)
            if not warn then
                client:notifyErrorLocalized("invalidWarningIndex")
                return
            end

            targetClient:notifyInfoLocalized("warningRemovedNotify", client:Nick())
            client:notifySuccessLocalized("warningRemoved", warnIndex, targetClient:Nick())
            hook.Run("WarningRemoved", client, targetClient, {
                reason = warn.message,
                admin = warn.warner,
                adminSteamID = warn.warnerSteamID,
                targetSteamID = targetClient:SteamID()
            }, warnIndex)
        end)
    end)
end)
