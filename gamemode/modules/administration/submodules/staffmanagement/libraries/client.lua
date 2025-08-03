local panelRef
lia.net.readBigTable("liaStaffSummary", function(data)
    if not IsValid(panelRef) or not data then return end
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
    addSizedColumn("Player")
    addSizedColumn("Player Steam ID")
    addSizedColumn("Warning Count")
    addSizedColumn("Ticket Count")
    addSizedColumn("Kick Count")
    addSizedColumn("Kill Count")
    addSizedColumn("Respawn Count")
    addSizedColumn("Blind Count")
    addSizedColumn("Mute Count")
    addSizedColumn("Jail Count")
    addSizedColumn("Strip Count")
    for _, info in ipairs(data) do
        list:AddLine(
            info.player or "",
            info.steamID or "",
            info.warnings or 0,
            info.tickets or 0,
            info.kicks or 0,
            info.kills or 0,
            info.respawns or 0,
            info.blinds or 0,
            info.mutes or 0,
            info.jails or 0,
            info.strips or 0
        )
    end
end)
function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("View Staff Management") then return end
    table.insert(pages, {
        name = "Staff Management",
        drawFunc = function(panel)
            panelRef = panel
            net.Start("liaRequestStaffSummary")
            net.SendToServer()
        end
    })
end
