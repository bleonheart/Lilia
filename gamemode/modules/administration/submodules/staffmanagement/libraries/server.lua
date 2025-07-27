local MODULE = MODULE

local function queryStaffActions(callback)
    lia.db.query([[SELECT admin, adminSteamID, action, COUNT(*) AS count FROM lia_staffactions GROUP BY adminSteamID, action]], callback)
end

net.Receive("RequestStaffActions", function(_, client)
    if not client:hasPrivilege("View Staff Actions") then return end
    queryStaffActions(function(data)
        net.Start("StaffActions")
        net.WriteTable(data or {})
        net.Send(client)
    end)
end)

net.Receive("RequestPlayerWarnings", function(_, client)
    if not client:hasPrivilege("View Player Warnings") then return end
    local steamID = net.ReadString()
    MODULE:GetWarnings(steamID):next(function(rows)
        net.Start("PlayerWarnings")
        net.WriteTable(rows)
        net.Send(client)
    end)
end)

net.Receive("RequestTicketClaims", function(_, client)
    if not client:hasPrivilege("View Claims") then return end
    lia.db.select({"timestamp", "requester", "requesterSteamID", "admin", "adminSteamID", "message"}, "ticketclaims")
        :next(function(res)
            net.Start("TicketClaims")
            net.WriteTable(res.results or {})
            net.Send(client)
        end)
end)
