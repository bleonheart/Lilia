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

    local top = panel:Add("Panel")
    top:Dock(TOP)
    top:SetTall(28)
    top:DockMargin(0, 0, 0, 5)

    local add = top:Add("liaSmallButton")
    add:Dock(LEFT)
    add:SetText(L("addGroup"))
    add:SetWide(100)
    add.DoClick = function()
        Derma_StringRequest(L("addGroup"), L("groupName"), "", function(name)
            if name == "" then return end
            net.Start("liaGroupsAdd")
            net.WriteString(name)
            net.SendToServer()
        end)
    end

    local remove = top:Add("liaSmallButton")
    remove:Dock(LEFT)
    remove:DockMargin(5, 0, 0, 0)
    remove:SetText(L("removeGroup"))
    remove:SetWide(100)

    local list = panel:Add("DListView")
    list:Dock(FILL)
    list:AddColumn(L("name"))
    for name in pairs(groups) do
        list:AddLine(name)
    end

    remove.DoClick = function()
        local line = list:GetSelectedLine() and list:GetLine(list:GetSelectedLine())
        if not line then return end
        net.Start("liaGroupsRemove")
        net.WriteString(line:GetColumnText(1))
        net.SendToServer()
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
