net.Receive("RequestRemoveWarning", function(_, client)
    if not client:hasPrivilege("Staff Permissions - Can Remove Warns") then return end
    local charID = net.ReadInt(32)
    local rowData = net.ReadTable()
    local warnID = tonumber(rowData.ID)
    local warnIndex = tonumber(rowData.index)
    if not warnID and not warnIndex then
        client:notifyLocalized("invalidWarningIndex")
        return
    end

    local targetClient = lia.char.getBySteamID(charID)
    if not IsValid(targetClient) then
        client:notifyLocalized("playerNotFound")
        return
    end

    local targetChar = targetClient:getChar()
    if not targetChar then
        client:notifyLocalized("characterNotFound")
        return
    end

    local warns = targetClient:getLiliaData("warns") or {}
    if warnID then
        for i, v in ipairs(warns) do
            if v.id == warnID then warnIndex = i break end
        end
    end
    if not warnIndex or warnIndex < 1 or warnIndex > #warns then
        client:notifyLocalized("invalidWarningIndex")
        return
    end

    local warning = warns[warnIndex]
    table.remove(warns, warnIndex)
    targetClient:setLiliaData("warns", warns)
    lia.db.delete("warnings", "_id = " .. (warnID or warning.id))
    targetClient:notifyLocalized("warningRemovedNotify", client:Nick())
    client:notifyLocalized("warningRemoved", warnIndex, targetClient:Nick())
    hook.Run("WarningRemoved", client, targetClient, warning, warnIndex)
end)
