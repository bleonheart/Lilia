hook.Add("liaAdminRegisterTab", "AdminTabWarningsDB", function(tabs)
    local function canView()
        local ply = LocalPlayer()
        return IsValid(ply) and ply:hasPrivilege("Access Warnings Tab") and ply:hasPrivilege("View DB Tables")
    end

    tabs["Warnings"] = {
        icon = "icon16/error.png",
        onShouldShow = canView,
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:DockPadding(10, 10, 10, 10)
            lia.gui.warnings = pnl
            net.Start("liaRequestTableData")
            net.WriteString("lia_staffactions")
            net.SendToServer()
            return pnl
        end
    }
end)
