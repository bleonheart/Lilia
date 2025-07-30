net.Receive("ViewClaims", function(_, client)
    local sid = net.ReadString()
    MODULE:GetAllCaseClaims():next(function(caseclaims)
        net.Start("ViewClaims")
        net.WriteTable(caseclaims)
        net.WriteString(sid)
        net.Send(client)
    end)
end)

net.Receive("TicketSystemClaim", function(_, client)
    local requester = net.ReadEntity()
    if client == requester then
        client:notifyLocalized("ticketActionSelf")
        return
    end

    if (client:hasPrivilege("Always See Tickets") or client:isStaffOnDuty()) and not requester.CaseClaimed then
        for _, v in player.Iterator() do
            if v:hasPrivilege("Always See Tickets") or v:isStaffOnDuty() then
                net.Start("TicketSystemClaim")
                net.WriteEntity(client)
                net.WriteEntity(requester)
                net.Send(v)
            end
        end

        hook.Run("TicketSystemClaim", client, requester)
        requester.CaseClaimed = client
        local t = MODULE.ActiveTickets[requester:SteamID64()]
        if t then t.admin = client:SteamID() end
    end
end)

net.Receive("TicketSystemClose", function(_, client)
    local requester = net.ReadEntity()
    if client == requester then
        client:notifyLocalized("ticketActionSelf")
        return
    end

    if not requester or not IsValid(requester) or requester.CaseClaimed ~= client then return end
    if timer.Exists("ticketsystem-" .. requester:SteamID64()) then timer.Remove("ticketsystem-" .. requester:SteamID64()) end
    for _, v in player.Iterator() do
        if v:hasPrivilege("Always See Tickets") or v:isStaffOnDuty() then
            net.Start("TicketSystemClose")
            net.WriteEntity(requester)
            net.Send(v)
        end
    end

    hook.Run("TicketSystemClose", client, requester)
    requester.CaseClaimed = nil
    MODULE.ActiveTickets[requester:SteamID64()] = nil
end)

net.Receive("liaRequestActiveTickets", function(_, client)
    if not (client:hasPrivilege("Always See Tickets") or client:isStaffOnDuty()) then return end
    net.Start("liaActiveTickets")
    net.WriteTable(MODULE.ActiveTickets or {})
    net.Send(client)
end)
