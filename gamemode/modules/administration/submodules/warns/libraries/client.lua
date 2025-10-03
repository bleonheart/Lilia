local panelRef
local warningsTabAdded = false
net.Receive("liaAllWarnings", function()
    local warnings = net.ReadTable() or {}
    if not IsValid(panelRef) then return end
    panelRef:Clear()
    panelRef:DockPadding(6, 6, 6, 6)
    panelRef.Paint = function() end
    panelRef.sheet = panelRef:Add("liaTabs")
    panelRef.sheet:Dock(FILL)

    local function createList(parent, rows)
        local container = parent:Add("Panel")
        container:Dock(FILL)
        container:DockMargin(0, 20, 0, 0)
        container.Paint = function() end

        local search = container:Add("liaEntry")
        search:Dock(TOP)
        search:DockMargin(0, 0, 0, 15)
        search:SetPlaceholderText(L("search"))
        search:SetTextColor(Color(255, 255, 255))

        local list = container:Add("liaTable")
        list:Dock(FILL)

        local columns = {
            {name = L("timestamp"), field = "timestamp"},
            {name = L("warned"), field = "warnedDisplay"},
            {name = L("admin"), field = "adminDisplay"},
            {name = L("warningMessage"), field = "message"}
        }

        for _, col in ipairs(columns) do
            list:AddColumn(col.name)
        end

        local function populate(filter)
            list:Clear()
            filter = string.lower(filter or "")
            for _, warn in ipairs(rows) do
                local warnedDisplay = string.format("%s (%s)", warn.warned or "", warn.warnedSteamID or "")
                local adminDisplay = string.format("%s (%s)", warn.warner or "", warn.warnerSteamID or "")

                local values = {
                    warn.timestamp or "",
                    warnedDisplay,
                    adminDisplay,
                    warn.message or ""
                }

                local match = false
                if filter == "" then
                    match = true
                else
                    for _, value in ipairs(values) do
                        if tostring(value):lower():find(filter, 1, true) then
                            match = true
                            break
                        end
                    end
                end

                if match then
                    local line = list:AddLine(unpack(values))
                end
            end
        end

        search.OnChange = function() populate(search:GetValue()) end
        populate("")

        function list:OnRowRightClick(_, line)
            if not IsValid(line) then return end
            local menu = DermaMenu()
            menu:AddOption(L("copyRow"), function()
                local rowString = ""
                for i, column in ipairs(self.Columns or {}) do
                    local header = column.Header and column.Header:GetText() or L("columnWithNumber", i)
                    local value = line:GetColumnText(i) or ""
                    rowString = rowString .. header .. " " .. value .. " | "
                end

                SetClipboardText(string.sub(rowString, 1, -4))
            end):SetIcon("icon16/page_copy.png")

            menu:Open()
        end

        local allPanel = parent
        createList(allPanel, warnings)
    end

    local allPanel = panelRef.sheet:Add("Panel")
    allPanel:Dock(FILL)
    allPanel.Paint = function() end
    createList(allPanel, warnings)
    panelRef.sheet:AddSheet(L("allWarnings"), allPanel)
end)

net.Receive("liaWarningsCount", function()
    local count = net.ReadInt(32)
    if count > 0 and not warningsTabAdded then
        warningsTabAdded = true
        hook.Add("PopulateAdminTabs", "liaWarningsTab", function(pages)
            if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("viewPlayerWarnings") then return end
            table.insert(pages, {
                name = "warnings",
                icon = "icon16/error.png",
                drawFunc = function(panel)
                    panelRef = panel
                    net.Start("liaRequestAllWarnings")
                    net.SendToServer()
                end
            })
        end)
    end
end)

function MODULE:PopulateAdminTabs()
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("viewPlayerWarnings") then return end
    net.Start("liaRequestWarningsCount")
    net.SendToServer()
end
