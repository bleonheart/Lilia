local PANEL = {}
local HIGHLIGHT = Color(255, 255, 255, 50)
function PANEL:Init()
    self:SetSize(400, 600)
    local function makeLabel(key)
        local lbl = self:Add("DLabel")
        lbl:SetFont("liaMediumFont")
        lbl:SetText(L(key):upper())
        lbl:SizeToContents()
        lbl:Dock(TOP)
        lbl:DockMargin(0, 0, 0, 4)
        return lbl
    end

    self.nameLabel = makeLabel("name")
    self.nameEntry = self:makeTextEntry("name")
    self.nameEntry:SetTall(32)
    self.descLabel = makeLabel("desc")
    self.descEntry = self:makeTextEntry("desc")
    self.descEntry:SetTall(32)

    -- Add attributes if they exist
    self:addAttributes()
end

function PANEL:makeTextEntry(key)
    local entry = self:Add("DTextEntry")
    entry:Dock(TOP)
    entry:SetFont("liaMediumFont")
    entry:SetTall(32)
    entry:DockMargin(0, 4, 0, 8)
    entry:SetUpdateOnType(true)
    entry.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
        entry:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
    end

    entry.OnValueChange = function(_, val) self:setContext(key, string.Trim(val)) end
    local saved = self:getContext(key)
    if saved then entry:SetValue(saved) end
    return entry
end

function PANEL:addAttributes()
    -- Determine if there are any visible attributes
    local visible = {}
    for k, v in pairs(lia.attribs.list or {}) do
        if not v.noStartBonus then visible[#visible + 1] = { id = k, data = v } end
    end
    if #visible == 0 then return end

    table.SortByMember(visible, "id", true)

    -- Header labels
    local header = self:Add("DPanel")
    header:Dock(TOP)
    header:DockMargin(0, 8, 0, 16)
    header:SetTall(24)
    header:SetPaintBackground(false)
    local title = header:Add("DLabel")
    title:SetFont("liaMediumFont")
    title:SetText(L("attributes"):upper())
    title:Dock(LEFT)
    title:SizeToContents()
    self.pointsLeftLabel = header:Add("DLabel")
    self.pointsLeftLabel:SetFont("LiliaFont.18")
    self.pointsLeftLabel:Dock(RIGHT)
    self.pointsLeftLabel:SetTextColor(color_white)
    self.pointsLeftLabel:SetContentAlignment(6)

    -- Container for rows (wrapped in scroll panel)
    self.attribsScrollPanel = self:Add("liaScrollPanel")
    self.attribsScrollPanel:Dock(TOP)
    self.attribsScrollPanel:DockMargin(0, 0, 0, 8)
    -- Some canvas implementations may not support SetPaintBackground; avoid calling it

    -- Set minimum and maximum height for the scroll panel
    local minHeight = 100
    local maxHeight = 300
    self.attribsScrollPanel:SetTall(math.min(math.max(#visible * 36, minHeight), maxHeight))

    self.attribsContainer = self.attribsScrollPanel:Add("DPanel")
    self.attribsContainer:Dock(TOP)
    self.attribsContainer:DockMargin(0, 0, 0, 0)
    self.attribsContainer:SetPaintBackground(false)

    -- Prepare totals/state
    self.attribRows = {}
    self.totalAttribPoints = hook.Run("GetMaxStartingAttributePoints", LocalPlayer(), self:getContext()) or lia.config.get("MaxAttributePoints")

    local rowHeight = 36
    for _, entry in ipairs(visible) do
        local row = self.attribsContainer:Add("liaCharacterAttribsRow")
        row:Dock(TOP)
        row:SetTall(rowHeight)
        row:setAttribute(entry.id, entry.data)
        row.parent = self -- so row:delta() calls our onPointChange
        self.attribRows[entry.id] = row
    end
    self:updateAttributesUI()
end

function PANEL:updateAttributesUI()
    if not self.attribRows then return end
    local t = self:getContext("attribs", {})
    local sum = 0
    for _, q in pairs(t) do sum = sum + q end
    self.pointsLeft = math.max((self.totalAttribPoints or 0) - sum, 0)
    if IsValid(self.pointsLeftLabel) then self.pointsLeftLabel:SetText(L("pointsLeft"):upper() .. ": " .. tostring(self.pointsLeft)) end
    for k, row in pairs(self.attribRows) do
        row.points = t[k] or 0
        if row.updateQuantity then row:updateQuantity() end
    end
end

function PANEL:onPointChange(attributeKey, delta)
    if not attributeKey then return 0 end
    local t = self:getContext("attribs", {})
    local current = t[attributeKey] or 0
    local newValue = current + delta
    local startingMax = hook.Run("GetAttributeStartingMax", LocalPlayer(), attributeKey) or lia.config.get("MaxStartingAttributes")
    if self.pointsLeft == nil then self:updateAttributesUI() end
    local newLeft = (self.pointsLeft or 0) - delta
    if newLeft < 0 or newLeft > (self.totalAttribPoints or 0) then return current end
    if newValue < 0 or newValue > (startingMax or newValue) then return current end
    self.pointsLeft = newLeft
    if IsValid(self.pointsLeftLabel) then self.pointsLeftLabel:SetText(L("pointsLeft"):upper() .. ": " .. tostring(self.pointsLeft)) end
    t[attributeKey] = newValue
    self:setContext("attribs", t)
    return newValue
end

function PANEL:shouldSkip()
    return false
end


function PANEL:validate()
    for _, info in ipairs({{self.nameEntry, "name"}, {self.descEntry, "desc"}}) do
        local val = string.Trim(info[1]:GetValue() or "")
        if val == "" then return false, L("requiredFieldError", info[2]) end
    end
    return true
end

function PANEL:onDisplay()
    local n, d = self.nameEntry:GetValue(), self.descEntry:GetValue()
    self:Clear()
    self:Init()
    self.nameEntry:SetValue(n)
    self.descEntry:SetValue(d)

    -- Restore attributes if they exist
    if IsValid(self.attribsPanel) then
        self.attribsPanel:onDisplay()
    end
end

vgui.Register("liaCharacterBiography", PANEL, "liaCharacterCreateStep")
