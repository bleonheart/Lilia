if CLIENT then TicketFrames = {} end
MODULE.name = L("moduleTicketsName")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("moduleTicketsDesc")
MODULE.Privileges = {
    {
        Name = L("alwaysSeeTickets"),
        MinAccess = "superadmin",
        Category = L("categoryTickets"),
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
        local function addSizedColumn(text)
            local col = list:AddColumn(text)
            surface.SetFont(col.Header:GetFont())
            local w = surface.GetTextSize(col.Header:GetText())
            col:SetMinWidth(w + 16)
            col:SetWidth(w + 16)
            return col
        end

        addSizedColumn(L("timestamp"))
        addSizedColumn(L("requester"))
        addSizedColumn(L("claimingAdmin"))
        addSizedColumn(L("Ticket Message", "Message"))
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
        function list:OnRowRightClick(_, line)
            if not IsValid(line) then return end
            local menu = DermaMenu()
            menu:AddOption(L("copyRow"), function()
                local rowString = ""
                for i, column in ipairs(self.Columns or {}) do
                    local header = column.Header and column.Header:GetText() or ("Column " .. i)
                    local value = line:GetColumnText(i) or ""
                    rowString = rowString .. header .. " " .. value .. " | "
                end
                SetClipboardText(string.sub(rowString, 1, -4))
            end):SetIcon("icon16/page_copy.png")
            menu:Open()
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
