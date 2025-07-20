local ugPanel

local function openGroupsPanel(parent)
    ugPanel = parent
    parent:Clear()
    parent:DockPadding(10, 10, 10, 10)
    parent.Paint = function(pnl, w, h)
        lia.util.drawBlur(pnl)
        surface.SetDrawColor(45, 45, 45, 200)
        surface.DrawRect(0, 0, w, h)
    end

    net.Start("liaGroupsRequest")
    net.SendToServer()
end
local function buildGroupsUI(panel, groups)
    panel:Clear()
    local list = panel:Add("DListView")
    list:Dock(FILL)
    list:AddColumn(L("name"))
    for name in pairs(groups) do
        list:AddLine(name)
    end
end

net.Receive("liaGroupsData", function()
    local groups = net.ReadTable()
    lia.admin.groups = groups
    if IsValid(ugPanel) then buildGroupsUI(ugPanel, groups) end
end)

net.Receive("lilia_updateAdminGroups", function()
    lia.admin.groups = net.ReadTable()
    if IsValid(ugPanel) then buildGroupsUI(ugPanel, lia.admin.groups) end
end)

function MODULE:CreateMenuButtons(tabs)
    if IsValid(LocalPlayer()) and LocalPlayer():hasPrivilege("Staff Permissions - Manage UserGroups") then
        tabs[L("userGroups")] = function(panel)
            openGroupsPanel(panel)
        end
    end
end
