local MODULE = MODULE

function MODULE:GetWarnings(steamID)
    local condition = "warnedSteamID = " .. lia.db.convertDataType(steamID)
    return lia.db.select({"id", "timestamp", "warning", "admin", "adminSteamID", "warned", "warnedSteamID"}, "warnings", condition)
        :next(function(res) return res.results or {} end)
end

function MODULE:AddWarning(target, timestamp, reason, admin)
    lia.db.insertTable({
        timestamp = timestamp,
        warned = target:Nick(),
        warnedSteamID = target:SteamID64(),
        warning = reason,
        admin = admin:Nick(),
        adminSteamID = admin:SteamID64()
    }, nil, "warnings")
end

function MODULE:RemoveWarning(steamID, index)
    local d = deferred.new()
    self:GetWarnings(steamID):next(function(rows)
        if index < 1 or index > #rows then return d:resolve(nil) end
        local row = rows[index]
        lia.db.delete("warnings", "id = " .. lia.db.convertDataType(row.id))
            :next(function() d:resolve(row) end)
    end)
    return d
end

net.Receive("RequestRemoveWarning", function(_, client)
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

    MODULE:RemoveWarning(targetClient:SteamID64(), warnIndex):next(function(warn)
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
