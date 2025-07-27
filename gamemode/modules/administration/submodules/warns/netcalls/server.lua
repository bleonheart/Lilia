local MODULE = MODULE
net.Receive("RequestPlayerWarnings", function(_, client)
    local MODULE = lia.module.get("warns")
    if not client:hasPrivilege("View Player Warnings") then return end
    local steamID = net.ReadString()
    MODULE:GetWarnings(steamID):next(function(rows)
        net.Start("PlayerWarnings")
        net.WriteTable(rows)
        net.Send(client)
    end)
end)

net.Receive("RequestRemoveWarning", function(_, client)
    local MODULE = lia.module.get("warns")
    if not client:hasPrivilege("Can Remove Warns") then return end
    local charID = net.ReadInt(32)
    local rowData = net.ReadTable()
    local warnIndex = tonumber(rowData.ID or rowData.index)
    if not warnIndex then
        client:notifyLocalized("invalidWarningIndex")
        return
    end

    local targetChar = lia.char.loaded[charID]
    if not targetChar then
        client:notifyLocalized("characterNotFound")
        return
    end

    local targetClient = targetChar:getPlayer()
    if not IsValid(targetClient) then
        client:notifyLocalized("playerNotFound")
        return
    end

    MODULE:RemoveWarning(targetClient:SteamID(), warnIndex):next(function(warn)
        if not warn then
            client:notifyLocalized("invalidWarningIndex")
            return
        end

        targetClient:notifyLocalized("warningRemovedNotify", client:Nick())
        client:notifyLocalized("warningRemoved", warnIndex, targetClient:Nick())
        hook.Run("WarningRemoved", client, targetClient, {
            reason = warn.warning,
            admin = warn.admin
        }, warnIndex)
    end)
end)
