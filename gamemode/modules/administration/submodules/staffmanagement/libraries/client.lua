local panelRef
lia.net.readBigTable("liaStaffSummary", function(data)
    if not IsValid(panelRef) or not data then return end
    panelRef:Clear()
    local search = panelRef:Add("DTextEntry")
    search:Dock(TOP)
    search:SetPlaceholderText(L("search"))
    search:SetTextColor(Color(255, 255, 255))
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
    addSizedColumn(L("usergroup"))
    addSizedColumn("Warning Count")
    addSizedColumn("Ticket Count")
    addSizedColumn("Kick Count")
    addSizedColumn("Kill Count")
    addSizedColumn("Respawn Count")
    addSizedColumn("Blind Count")
    addSizedColumn("Mute Count")
    addSizedColumn("Jail Count")
    addSizedColumn("Strip Count")

    local function populate(filter)
        list:Clear()
        filter = string.lower(filter or "")
        for _, info in ipairs(data) do
            local entries = {
                info.player or "",
                info.steamID or "",
                info.usergroup or "",
                info.warnings or 0,
                info.tickets or 0,
                info.kicks or 0,
                info.kills or 0,
                info.respawns or 0,
                info.blinds or 0,
                info.mutes or 0,
                info.jails or 0,
                info.strips or 0
            }
            local match = false
            if filter == "" then
                match = true
            else
                for _, value in ipairs(entries) do
                    if tostring(value):lower():find(filter, 1, true) then
                        match = true
                        break
                    end
                end
            end
            if match then list:AddLine(unpack(entries)) end
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
