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
        warnedSteamID = target:SteamID(),
        warning = reason,
        admin = admin:Nick(),
        adminSteamID = admin:SteamID()
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

