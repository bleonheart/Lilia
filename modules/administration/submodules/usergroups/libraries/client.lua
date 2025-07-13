local receivedPanel
local groupsData = {}

net.Receive("liaSendUsergroups", function()
    groupsData = net.ReadTable() or {}
    if IsValid(receivedPanel) then
        OpenAdminGroupsUI(receivedPanel, groupsData)
    end
end)

net.Receive("lilia_updateAdminGroups", function()
    groupsData = net.ReadTable() or {}
    if IsValid(receivedPanel) then
        OpenAdminGroupsUI(receivedPanel, groupsData)
    end
end)

function OpenAdminGroupsUI(panel, groups)
    panel:Clear()
    local sidebar = panel:Add("DScrollPanel")
    sidebar:Dock(RIGHT)
    sidebar:SetWide(200)
    sidebar:DockMargin(0, 20, 20, 20)
    local content = panel:Add("DPanel")
    content:Dock(FILL)
    content:DockMargin(10, 10, 10, 10)
    content.Paint = function() end

    local pages = {}
    pages[#pages + 1] = {
        name = L("createGroup"),
        drawFunc = function(p)
            local entry = p:Add("DTextEntry")
            entry:Dock(TOP)
            entry:SetTall(30)
            entry:SetPlaceholderText(L("createGroup"))
            entry:DockMargin(0, 0, 0, 10)
            local btn = p:Add("liaMediumButton")
            btn:Dock(TOP)
            btn:SetText(L("create"))
            btn:SetTall(40)
            btn.DoClick = function()
                local name = entry:GetValue():Trim()
                if name == "" then return end
                net.Start("liaCreateUsergroup")
                net.WriteString(name)
                net.SendToServer()
                entry:SetText("")
            end
        end
    }

    pages[#pages + 1] = {
        name = L("manageGroups"),
        drawFunc = function(p)
            local scroll = p:Add("DScrollPanel")
            scroll:Dock(FILL)
            for groupName in pairs(groups) do
                local row = scroll:Add("DPanel")
                row:Dock(TOP)
                row:DockMargin(0, 0, 0, 5)
                row:SetTall(30)
                row.Paint = function(_, w, h)
                    surface.SetDrawColor(30, 30, 30, 200)
                    surface.DrawRect(0, 0, w, h)
                    draw.SimpleText(groupName, "liaMediumFont", 10, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
                local remove = row:Add("liaSmallButton")
                remove:Dock(RIGHT)
                remove:SetText(L("remove") or "Remove")
                remove:SetWide(80)
                remove.DoClick = function()
                    net.Start("liaRemoveUsergroup")
                    net.WriteString(groupName)
                    net.SendToServer()
                end
            end
        end
    }

    local current
    for _, page in ipairs(pages) do
        local btn = sidebar:Add("liaMediumButton")
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 10)
        btn:SetTall(40)
        btn:SetText(page.name)
        btn.DoClick = function()
            if IsValid(current) then current:SetSelected(false) end
            btn:SetSelected(true)
            current = btn
            content:Clear()
            page.drawFunc(content)
        end
    end

    pages[1].drawFunc(content)
end

function MODULE:CreateMenuButtons(tabs)
    if IsValid(LocalPlayer()) and LocalPlayer():IsAdmin() then
        tabs[L("adminMenuTitle")] = function(panel)
            receivedPanel = panel
            net.Start("liaRequestUsergroups")
            net.SendToServer()
        end
    end
end
