local MODULE = MODULE
function MODULE:GetWarnings(charID)
    local d = deferred.new()
    d:resolve({})
    return d
end

function MODULE:AddWarning(charID, steamID, timestamp, reason, admin, targetName)
    lia.db.insertTable({
        _timestamp = timestamp,
        _target = targetName or steamID,
        _targetID = steamID,
        _action = "warn",
        _admin = tostring(admin),
        _adminID = tostring(admin):match("%((%d+)%)") or tostring(admin)
    }, nil, "staffactions")
end

function MODULE:RemoveWarning(charID, index)
    local d = deferred.new()
    d:resolve(nil)
    return d
end

net.Receive("RequestRemoveWarning", function(_, client)
    if not client:hasPrivilege("Staff Permissions - Can Remove Warns") then return end
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

    MODULE:RemoveWarning(charID, warnIndex):next(function(warn)
        if not warn then
            client:notifyLocalized("invalidWarningIndex")
            return
        end

        targetClient:notifyLocalized("warningRemovedNotify", client:Nick())
        client:notifyLocalized("warningRemoved", warnIndex, targetClient:Nick())
        hook.Run("WarningRemoved", client, targetClient, {
            reason = warn._reason,
            admin = warn._admin
        }, warnIndex)
    end)
end)
