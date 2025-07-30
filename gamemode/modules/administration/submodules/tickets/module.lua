if CLIENT then TicketFrames = {} end
MODULE.name = "Tickets"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Introduces a ticket system where players can submit help requests that staff can view, respond to, and resolve in an organized manner."
MODULE.Privileges = {
    {
        Name = "Always See Tickets",
        MinAccess = "superadmin",
        Category = "Staff Permissions",
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
            local admin = t.admin or L("unassignedLabel")
            local ts = os.date("%Y-%m-%d %H:%M:%S", t.timestamp or os.time())
            list:AddLine(ts, t.requester or "", admin, t.message or "")
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
