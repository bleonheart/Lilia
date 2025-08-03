-- luacheck: globals MODULE lia IsValid surface net LocalPlayer FILL L

local MODULE = MODULE

local panelRef

lia.net.readBigTable("liaAllFlags", function(data)
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

    addSizedColumn(L("name"))
    addSizedColumn(L("steamID"))
    addSizedColumn(L("flags"))

    for _, entry in ipairs(data or {}) do
        list:AddLine(entry.name or "", entry.steamID or "", entry.flags or "")
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

