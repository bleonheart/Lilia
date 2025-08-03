-- luacheck: globals MODULE lia IsValid surface net LocalPlayer FILL L

local MODULE = MODULE

local panelRef

lia.net.readBigTable("liaAllFlags", function(data)
    if not IsValid(panelRef) then return end

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

    addSizedColumn(L("name"))
    addSizedColumn(L("steamID"))
    addSizedColumn(L("flags"))

    local function populate(filter)
        list:Clear()
        filter = string.lower(filter or "")
        for _, entry in ipairs(data or {}) do
            local name = entry.name or ""
            local steamID = entry.steamID or ""
            local flags = entry.flags or ""
            if filter == "" or name:lower():find(filter, 1, true) or steamID:lower():find(filter, 1, true) or flags:lower():find(filter, 1, true) then
                list:AddLine(name, steamID, flags)
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
                local header = column.Header and column.Header:GetText() or ("Column " .. i)
                local value = line:GetColumnText(i) or ""
                rowString = rowString .. header .. " " .. value .. " | "
            end
            SetClipboardText(string.sub(rowString, 1, -4))
        end):SetIcon("icon16/page_copy.png")
        menu:AddOption(L("modifyFlags"), function()
            local steamID = line:GetColumnText(2) or ""
            local currentFlags = line:GetColumnText(3) or ""
            Derma_StringRequest(L("modifyFlags"), L("modifyFlagsDesc"), currentFlags, function(text)
                text = string.gsub(text or "", "%s", "")
                net.Start("liaModifyFlags")
                net.WriteString(steamID)
                net.WriteString(text)
                net.SendToServer()
                line:SetColumnText(3, text)
            end)
        end):SetIcon("icon16/flag_orange.png")
        menu:Open()
    end
end)

function MODULE:PopulateAdminTabs(pages) -- luacheck: ignore self
    local privilege = L("canAccessFlagManagement")
    if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege(privilege) then return end

    table.insert(pages, {
        name = L("flagsManagement"),
        drawFunc = function(panel)
            panelRef = panel
            net.Start("liaRequestAllFlags")
            net.SendToServer()
        end
    })
end

