local MODULE = MODULE
local function buildSummary()
    local d = deferred.new()
    local summary = {}
    local function ensureEntry(id, name)
        summary[id] = summary[id] or {
            player = name or "",
            steamID = id,
            warnings = 0,
            tickets = 0,
            kicks = 0,
            kills = 0,
            respawns = 0,
            blinds = 0,
            mutes = 0,
            jails = 0,
            strips = 0
        }
        if name and name ~= "" then summary[id].player = name end
        return summary[id]
    end
    lia.db.query([[SELECT warner AS name, warnerSteamID AS steamID, COUNT(*) AS count FROM lia_warnings GROUP BY warnerSteamID]], function(warnRows)
        for _, row in ipairs(warnRows or {}) do
            local steamID = row.steamID or row.warnerSteamID
            if steamID and steamID ~= "" then
                local entry = ensureEntry(steamID, row.name)
                entry.warnings = tonumber(row.count) or 0
            end
        end
        lia.db.query([[SELECT admin AS name, adminSteamID AS steamID, COUNT(*) AS count FROM lia_ticketclaims GROUP BY adminSteamID]], function(ticketRows)
            for _, row in ipairs(ticketRows or {}) do
                local steamID = row.steamID or row.adminSteamID
                if steamID and steamID ~= "" then
                    local entry = ensureEntry(steamID, row.name)
                    entry.tickets = tonumber(row.count) or 0
                end
            end
            lia.db.query([[SELECT staffName AS name, staffSteamID AS steamID, action, COUNT(*) AS count FROM lia_staffactions GROUP BY staffSteamID, action]], function(actionRows)
                for _, row in ipairs(actionRows or {}) do
                    local steamID = row.steamID or row.staffSteamID
                    if steamID and steamID ~= "" then
                        local entry = ensureEntry(steamID, row.name)
                        local count = tonumber(row.count) or 0
                        if row.action == "plykick" then entry.kicks = count
                        elseif row.action == "plykill" then entry.kills = count
                        elseif row.action == "plyrespawn" then entry.respawns = count
                        elseif row.action == "plyblind" then entry.blinds = count
                        elseif row.action == "plymute" then entry.mutes = count
                        elseif row.action == "plyjail" then entry.jails = count
                        elseif row.action == "plystrip" then entry.strips = count
                        end
                    end
                end
                local list = {}
                for _, info in pairs(summary) do list[#list + 1] = info end
                d:resolve(list)
            end)
        end)
    end)
    return d
end
net.Receive("liaRequestStaffSummary", function(_, client)
    if not client:hasPrivilege("View Staff Management") then return end
    buildSummary():next(function(data)
        lia.net.writeBigTable(client, "liaStaffSummary", data)
    end)
end)
