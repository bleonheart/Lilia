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
            MODULE.warnList:AddLine(w.warned or "", w.admin or "", w.warning or "", w.timestamp or "")
        end
    end
end)

net.Receive("TicketClaims", function()
    local claims = net.ReadTable()
    if IsValid(MODULE.ticketList) then
        MODULE.ticketList:Clear()
        for _, c in ipairs(claims) do
            MODULE.ticketList:AddLine(os.date("%Y-%m-%d %H:%M:%S", c.timestamp or 0), c.requester or "", c.admin or "", c.message or "")
        end
    end
end)

hook.Add("liaAdminRegisterTab", "liaStaffManagementTab", function(parent, tabs)
    local ply = LocalPlayer()
    if not ply:hasPrivilege("View Staff Actions") then return end
    tabs[L("staffManagement")] = {
        icon = "icon16/chart_bar.png",
        build = function(sheet)
            local panel = vgui.Create("DPanel", sheet)
            panel:Dock(FILL)
            panel:DockPadding(10,10,10,10)
            local list = vgui.Create("DListView", panel)
            list:Dock(FILL)
            list:AddColumn(L("adminName"))
            list:AddColumn(L("steamID"))
            list:AddColumn(L("staffAction"))
            list:AddColumn(L("count"))
            MODULE.actionList = list
            list.OnRowRightClick = function(_, _, line)
                if not IsValid(line) then return end
                local m = DermaMenu()
                m:AddOption(L("copyRow"), function()
                    local s = ""
                    for i = 1, line:Columns() do
                        s = s .. line:GetColumnText(i) .. " | "
                    end
                    SetClipboardText(s:sub(1, -4))
                end):SetIcon("icon16/page_copy.png")
                m:Open()
            end
            net.Start("RequestStaffActions")
            net.SendToServer()
            return panel
        end
    }

    tabs[L("warnings")] = {
        icon = "icon16/error.png",
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:Dock(FILL)
            pnl:DockPadding(10,10,10,10)
            local list = vgui.Create("DListView", pnl)
            list:Dock(FILL)
            list:AddColumn(L("player"))
            list:AddColumn(L("admin"))
            list:AddColumn(L("reason"))
            list:AddColumn(L("timestamp"))
            MODULE.warnList = list
            list.OnRowRightClick = function(_, _, line)
                if not IsValid(line) then return end
                local m = DermaMenu()
                m:AddOption(L("copyRow"), function()
                    local s = ""
                    for i = 1, line:Columns() do
                        s = s .. line:GetColumnText(i) .. " | "
                    end
                    SetClipboardText(s:sub(1, -4))
                end):SetIcon("icon16/page_copy.png")
                m:Open()
            end
            net.Start("RequestPlayerWarnings")
            net.WriteString(LocalPlayer():SteamID64())
            net.SendToServer()
            return pnl
        end
    }

    tabs[L("ticketsTab")] = {
        icon = "icon16/briefcase.png",
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:Dock(FILL)
            pnl:DockPadding(10,10,10,10)
            local list = vgui.Create("DListView", pnl)
            list:Dock(FILL)
            list:AddColumn(L("timestamp"))
            list:AddColumn(L("requester"))
            list:AddColumn(L("admin"))
            list:AddColumn(L("message"))
            MODULE.ticketList = list
            list.OnRowRightClick = function(_, _, line)
                if not IsValid(line) then return end
                local m = DermaMenu()
                m:AddOption(L("copyRow"), function()
                    local s = ""
                    for i = 1, line:Columns() do
                        s = s .. line:GetColumnText(i) .. " | "
                    end
                    SetClipboardText(s:sub(1, -4))
                end):SetIcon("icon16/page_copy.png")
                m:Open()
            end
            net.Start("RequestTicketClaims")
            net.SendToServer()
            return pnl
        end
    }
end)
