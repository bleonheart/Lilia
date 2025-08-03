local MODULE = MODULE
local rosterPanel
local function OpenRoster(panel, data)
    panel:Clear()
    local sheet = panel:Add("DPropertySheet")
    sheet:Dock(FILL)
    sheet:DockMargin(10, 10, 10, 10)
    for factionName, members in pairs(data) do
        local page = sheet:Add("DPanel")
        page:Dock(FILL)
        page:DockPadding(10, 10, 10, 10)
        local list = page:Add("DListView")
        list:Dock(FILL)
        list:SetMultiSelect(false)
        list:AddColumn(L("name", "Name"))
        for _, member in ipairs(members) do
            list:AddLine(member)
        end
        sheet:AddSheet(factionName, page)
    end
end

lia.net.readBigTable("liaFactionRosterData", function(data)
    if IsValid(rosterPanel) then
        OpenRoster(rosterPanel, data or {})
    end
end)

function MODULE:PopulateAdminTabs(pages)
    if IsValid(LocalPlayer()) and LocalPlayer():hasPrivilege("Can Manage Factions") then
        table.insert(pages, {
            name = L("factionManagement", "Factions"),
            drawFunc = function(panel)
                rosterPanel = panel
                net.Start("liaRequestFactionRoster")
                net.SendToServer()
            end
        })
    end
end

