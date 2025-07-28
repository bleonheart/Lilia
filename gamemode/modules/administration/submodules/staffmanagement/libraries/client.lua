local MODULE = MODULE
net.Receive("StaffActions", function()
    local data = net.ReadTable()
    if IsValid(MODULE.actionList) then
        MODULE.actionList:Clear()
        for _, row in ipairs(data) do
            MODULE.actionList:AddLine(row.admin or "N/A", row.adminSteamID or "", row.action or "", row.count or 0)
        end
    end
end)

net.Receive("PlayerWarnings", function()
    local warnings = net.ReadTable()
    if IsValid(MODULE.warnList) then
        MODULE.warnList:Clear()
        for _, w in ipairs(warnings) do
            MODULE.warnList:AddLine(w.warned or "", w.warnedSteamID or "", w.admin or "", w.adminSteamID or "", w.warning or "", w.timestamp or "")
        end
    end
end)

net.Receive("TicketClaims", function()
    local claims = net.ReadTable()
    if IsValid(MODULE.ticketList) then
        MODULE.ticketList:Clear()
        for _, c in ipairs(claims) do
            MODULE.ticketList:AddLine(os.date("%Y-%m-%d %H:%M:%S", c.timestamp or 0), c.requester or "", c.requesterSteamID or "", c.admin or "", c.adminSteamID or "", c.message or "")
        end
    end
end)