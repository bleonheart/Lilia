MODULE.name = "Configuration Menu"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Adds a warning system complete with logs and a management menu so staff can issue, track, and remove player warnings."
MODULE.Privileges = {
    {
        Name = "Can Remove Warns",
        MinAccess = "superadmin",
        Category = "Warning",
    },
}

if CLIENT then
    local panelRef
    net.Receive("liaAllWarnings", function()
        local warnings = net.ReadTable() or {}
        if not IsValid(panelRef) then return end
        panelRef:Clear()
        local list = panelRef:Add("DListView")
        list:Dock(FILL)
        list:AddColumn(L("timestamp")):SetFixedWidth(150)
        list:AddColumn(L("warned", "Warned")):SetFixedWidth(110)
        list:AddColumn(L("warner", "Warner")):SetFixedWidth(110)
        list:AddColumn(L("reason"))
        for _, warn in ipairs(warnings) do
            list:AddLine(warn.timestamp or "", warn.steamID or "", warn.admin or "", warn.reason or "")
        end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("View Player Warnings") then return end
        table.insert(pages, {
            name = L("warnings"),
            drawFunc = function(panel)
                panelRef = panel
                net.Start("liaRequestAllWarnings")
                net.SendToServer()
            end
        })
    end
end