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
        local search = page:Add("DTextEntry")
        search:Dock(TOP)
        search:SetPlaceholderText(L("search"))
        search:SetTextColor(Color(255, 255, 255))
        local list = page:Add("DListView")
        list:Dock(FILL)
        list:SetMultiSelect(false)
        list:AddColumn(L("name", "Name"))
        local function populate(filter)
            list:Clear()
            filter = string.lower(filter or "")
            for _, member in ipairs(members) do
                if filter == "" or string.lower(member.name):find(filter, 1, true) then
                    local line = list:AddLine(member.name)
                    line.rowData = member
                end
            end
        end
        search.OnChange = function() populate(search:GetValue()) end
        populate("")
        function list:OnRowRightClick(_, line)
            if not IsValid(line) or not line.rowData then return end
            local menu = DermaMenu()
            menu:AddOption(L("kick"), function()
                Derma_Query(L("kickConfirm"), L("confirm"), L("yes"), function()
                    net.Start("KickCharacter")
                    net.WriteInt(line.rowData.id, 32)
                    net.SendToServer()
                end, L("no"))
            end):SetIcon("icon16/user_delete.png")
            menu:AddOption(L("copyRow"), function()
                local rowString = ""
                for i, column in ipairs(self.Columns or {}) do
                    local header = column.Header and column.Header:GetText() or ("Column " .. i)
                    local value = line:GetColumnText(i) or ""
                    rowString = rowString .. header .. " " .. value .. " | "
                end
                SetClipboardText(string.sub(rowString, 1, -4))
            end):SetIcon("icon16/page_copy.png")
            menu:Open()
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

