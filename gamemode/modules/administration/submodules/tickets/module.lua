if CLIENT then TicketFrames = {} end
MODULE.name = L("moduleTicketsName")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("moduleTicketsDesc")
MODULE.Privileges = {
    {
        Name = L("alwaysSeeTickets"),
        MinAccess = "superadmin",
        Category = L("categoryStaffPermissions"),
    },
}

if CLIENT then
    local ticketPanel
    net.Receive("liaActiveTickets", function()
        local tickets = net.ReadTable() or {}
        if not IsValid(ticketPanel) then return end
        ticketPanel:Clear()
        local list = ticketPanel:Add("DListView")
        list:Dock(FILL)
        list:AddColumn(L("timestamp")):SetFixedWidth(150)
        list:AddColumn(L("requester")):SetFixedWidth(110)
        list:AddColumn(L("claimingAdmin")):SetFixedWidth(110)
        list:AddColumn(L("Ticket Message", "Message"))
        for _, t in pairs(tickets) do
            local admin = L("unassignedLabel")
            if t.admin then
                local adminPly = player.GetBySteamID(t.admin)
                if IsValid(adminPly) then
                    admin = adminPly:Nick()
                else
                    admin = t.admin
                end
            end

            local requester = t.requester or ""
            if requester ~= "" then
                local requesterPly = player.GetBySteamID(requester)
                if IsValid(requesterPly) then requester = requesterPly:Nick() end
            end

            local ts = os.date("%Y-%m-%d %H:%M:%S", t.timestamp or os.time())
            list:AddLine(ts, requester, admin, t.message or "")
        end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not (LocalPlayer():hasPrivilege("Always See Tickets") or LocalPlayer():isStaffOnDuty()) then return end
        table.insert(pages, {
            name = L("tickets", "Tickets"),
            drawFunc = function(panel)
                ticketPanel = panel
                net.Start("liaRequestActiveTickets")
                net.SendToServer()
            end
        })
    end
end
