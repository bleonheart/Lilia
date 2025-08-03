local MODULE = MODULE
function MODULE:GetWarnings(warnedSteamID)
    local condition = "warnedSteamID = " .. lia.db.convertDataType(warnedSteamID)
    return lia.db.select({"id", "timestamp", "message", "warner", "warnerSteamID", "warnedSteamID"}, "warnings", condition):next(function(res) return res.results or {} end)
end

function MODULE:AddWarning(warned, warnedSteamID, timestamp, message, warner, warnerSteamID)
    lia.db.insertTable({
        warned = warned,
        warnedSteamID = warnedSteamID,
        timestamp = timestamp,
        message = message,
        warner = warner,
        warnerSteamID = warnerSteamID
    }, nil, "warnings")
end

function MODULE:RemoveWarning(warnedSteamID, index)
    local d = deferred.new()
    self:GetWarnings(warnedSteamID):next(function(rows)
        if index < 1 or index > #rows then return d:resolve(nil) end
        local row = rows[index]
        lia.db.delete("warnings", "id = " .. lia.db.convertDataType(row.id)):next(function() d:resolve(row) end)
    end)
    return d
end

net.Receive("RequestRemoveWarning", function(_, client)
    if not client:hasPrivilege("Can Remove Warns") then return end
    net.ReadInt(32) -- legacy charID, unused
    local rowData = net.ReadTable()
    local warnIndex = tonumber(rowData.ID or rowData.index)
    if not warnIndex then
        client:notifyLocalized("invalidWarningIndex")
        return
    end

    local warnedSteamID = rowData.warnedSteamID
    if not warnedSteamID then
        client:notifyLocalized("playerNotFound")
        return
    end

    local targetClient = player.GetBySteamID64 and player.GetBySteamID64(warnedSteamID)
    if not IsValid(targetClient) then
        for _, v in ipairs(player.GetAll()) do
            if v:SteamID64() == warnedSteamID then
                targetClient = v
                break
            end
        end
    end
    if not IsValid(targetClient) then
        client:notifyLocalized("playerNotFound")
        return
    end

    MODULE:RemoveWarning(warnedSteamID, warnIndex):next(function(warn)
        if not warn then
            client:notifyLocalized("invalidWarningIndex")
            return
        end

        targetClient:notifyLocalized("warningRemovedNotify", client:Nick())
        client:notifyLocalized("warningRemoved", warnIndex, targetClient:Nick())
        hook.Run("WarningRemoved", client, targetClient, {
            reason = warn.message,
            admin = warn.warner
        }, warnIndex)
    end)
end)

net.Receive("liaRequestAllWarnings", function(_, client)
    if not client:hasPrivilege("View Player Warnings") then return end
    lia.db.select({"timestamp", "warned", "warnedSteamID", "warner", "warnerSteamID", "message"}, "warnings"):next(function(res)
        net.Start("liaAllWarnings")
        net.WriteTable(res.results or {})
        net.Send(client)
    end)
end)
