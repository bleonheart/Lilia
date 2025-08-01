MODULE.name = L("moduleWarnsName")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("moduleWarnsDesc")
MODULE.Privileges = {
    {
        Name = L("canRemoveWarns"),
        MinAccess = "superadmin",
        Category = L("categoryWarning"),
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
        list:AddColumn(L("Warned", "Warned")):SetFixedWidth(110)
        list:AddColumn(L("Warner", "Warner")):SetFixedWidth(110)
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