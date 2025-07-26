hook.Add("liaAdminRegisterTab", "AdminTabStaffActions", function(tabs)
    local function canView()
        local ply = LocalPlayer()
        return IsValid(ply) and ply:hasPrivilege("Access Staff Actions Tab") and ply:hasPrivilege("View DB Tables")
    end

    tabs["Staff Actions"] = {
        icon = "icon16/book_open.png",
        onShouldShow = canView,
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:DockPadding(10, 10, 10, 10)
            local ps = vgui.Create("DPropertySheet", pnl)
            ps:Dock(FILL)
            lia.gui.staffActions = {
                sheet = ps,
                panels = {}
            }

            net.Start("liaRequestTableData")
            net.WriteString("lia_staffactions")
            net.SendToServer()
            return pnl
        end
    }
end)
