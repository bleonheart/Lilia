hook.Add("liaAdminRegisterTab", "AdminTabWarningsDB", function(parent, tabs)
    local ply = LocalPlayer()
    if not (IsValid(ply) and ply:hasPrivilege("View DB Tables")) then return end
    tabs["Warnings"] = {
        icon = "icon16/error.png",
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:DockPadding(10, 10, 10, 10)
            net.Start("liaRequestTableData")
            net.WriteString("lia_warnings")
            net.SendToServer()
            return pnl
        end
    }
end)
