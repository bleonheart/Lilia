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
        local function addSizedColumn(text)
            local col = list:AddColumn(text)
            surface.SetFont(col.Header:GetFont())
            local w = surface.GetTextSize(col.Header:GetText())
            col:SetMinWidth(w + 16)
            col:SetWidth(w + 16)
            return col
        end

        addSizedColumn(L("timestamp"))
        addSizedColumn(L("Warned", "Warned"))
        addSizedColumn(L("Warner", "Warner"))
        addSizedColumn(L("reason"))
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