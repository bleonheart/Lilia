local PANEL = {}
local function themeColor(key, fallback)
    local theme = lia.color and lia.color.theme or {}
    local value = theme[key]
    if IsColor(value) then return value end
    if istable(value) and IsColor(value[1]) then return value[1] end
    return fallback
end

local function alphaColor(color, alpha)
    return Color(color.r, color.g, color.b, alpha)
end

function PANEL:Init()
    self:Dock(FILL)
    self:DockPadding(0, 4, 0, 0)
    self.factionLabel = self:makeLabel("faction")
    self.factionCombo = self:makeFactionComboBox()
    self.nameLabel = self:makeLabel("name")
    self.nameEntry = self:makeTextEntry("name", false)
    if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false then
        self.descLabel = self:makeLabel("desc")
        self.descEntry = self:makeTextEntry("desc", true)
    end

    self:addAttributes()
end

function PANEL:makeLabel(key)
    local label = self:Add("DLabel")
    label:Dock(TOP)
    label:DockMargin(2, 0, 2, 5)
    label:SetTall(22)
    label:SetFont("LiliaFont.18")
    label:SetText(key)
    label:SetTextColor(themeColor("text", color_white))
    label:SetContentAlignment(4)
    return label
end

function PANEL:makeTextEntry(key, multiline)
    local entry = self:Add("liaEntry")
    entry:Dock(TOP)
    entry:DockMargin(0, 0, 0, 16)
    entry:SetTall(multiline and 104 or 42)
    entry:SetFont("LiliaFont.18")
    entry:SetMultiline(multiline)
    entry.OnEnter = function() self:setContext(key, string.Trim(entry:GetValue() or "")) end
    entry.OnLoseFocus = function() self:setContext(key, string.Trim(entry:GetValue() or "")) end
    entry.OnTextChanged = function() self:setContext(key, string.Trim(entry:GetValue() or "")) end
    local saved = self:getContext(key)
    if saved then entry:SetValue(saved) end
    return entry
end

function PANEL:getFactionChoiceID(factionIndex)
    for id, fac in pairs(lia.faction.teams or {}) do
        if fac.index == factionIndex then return id end
    end
end

function PANEL:makeFactionComboBox()
    local combo = self:Add("liaComboBox")
    combo:Dock(TOP)
    combo:PostInit()
    combo:DockMargin(0, 0, 0, 16)
    combo:SetTall(42)
    combo.OnSelect = function(_, _, _, factionID)
        if self._suppressFactionSelect then return end
        local fac = factionID and lia.faction.teams[factionID] or nil
        if fac then self:onFactionSelected(fac) end
    end

    local firstFactionID
    for id, fac in SortedPairsByMemberValue(lia.faction.teams, "name") do
        if lia.faction.hasWhitelist(fac.index) then
            if fac.uniqueID == "staff" then continue end
            local desc = fac.desc or "No Description"
            combo:AddChoice(fac.name, id, desc ~= "" and desc or nil)
            firstFactionID = firstFactionID or id
        end
    end

    combo:FinishAddingOptions()
    local savedFaction = self:getContext("faction")
    local savedFactionID = savedFaction and self:getFactionChoiceID(savedFaction) or nil
    if savedFactionID then
        self._suppressFactionSelect = true
        combo:ChooseOptionData(savedFactionID)
        self._suppressFactionSelect = false
    elseif firstFactionID then
        self._suppressFactionSelect = true
        combo:ChooseOptionData(firstFactionID)
        self._suppressFactionSelect = false
        local fac = lia.faction.teams[firstFactionID]
        if fac then self:onFactionSelected(fac) end
    end
    return combo
end

function PANEL:addAttributes()
    if IsValid(self.attribsPanel) then return end
    if not self._attemptedAttribLoad and lia.attribs and isfunction(lia.attribs.loadFromDir) then
        self._attemptedAttribLoad = true
        local base = SCHEMA and SCHEMA.folder or engine.ActiveGamemode():gsub("\\", "/")
        lia.attribs.loadFromDir(base .. "/schema/attributes")
    end

    local hasAttributes = false
    if lia.attribs and lia.attribs.list then
        for _, attrib in pairs(lia.attribs.list) do
            if not attrib.noStartBonus then
                hasAttributes = true
                break
            end
        end
    end

    if not hasAttributes then
        if not self._attribRetry then
            self._attribRetry = true
            timer.Simple(0.25, function()
                if not IsValid(self) then return end
                self._attribRetry = nil
                self:addAttributes()
                if IsValid(self.attribsPanel) then
                    self.attribsPanel:onDisplay()
                    self:updateAttributesLabel()
                end
            end)
        end
        return
    end

    self.attrHeader = self:Add("DPanel")
    self.attrHeader:Dock(TOP)
    self.attrHeader:DockMargin(0, 2, 0, 7)
    self.attrHeader:SetTall(24)
    self.attrHeader:SetPaintBackground(false)
    self.attrLabelText = self.attrHeader:Add("DLabel")
    self.attrLabelText:Dock(LEFT)
    self.attrLabelText:SetFont("LiliaFont.18")
    self.attrLabelText:SetTextColor(themeColor("text", color_white))
    self.attrLabelText:SetContentAlignment(4)
    self.pointsLabel = self.attrHeader:Add("DLabel")
    self.pointsLabel:Dock(RIGHT)
    self.pointsLabel:SetFont("LiliaFont.16")
    self.pointsLabel:SetTextColor(themeColor("accent", themeColor("theme", color_white)))
    self.pointsLabel:SetContentAlignment(6)
    self.attribsPanel = self:Add("liaCharacterAttribs")
    self.attribsPanel:Dock(TOP)
    self.attribsPanel:DockMargin(0, 0, 0, 8)
    local rows = 0
    for _, attrib in pairs(lia.attribs.list or {}) do
        if not attrib.noStartBonus then rows = rows + 1 end
    end

    self.attribsPanel:SetTall(math.max(120, rows * 46))
    self.attribsPanel:SetVisible(true)
    self.attribsPanel.parentBio = self
    if isfunction(self.attribsPanel.onDisplay) then self.attribsPanel:onDisplay() end
    if IsValid(self.attribsPanel.title) then self.attribsPanel.title:SetVisible(false) end
    if IsValid(self.attribsPanel.leftLabel) then self.attribsPanel.leftLabel:SetVisible(false) end
    self:styleAttribsPanel()
    self:updateAttributesLabel()
end

function PANEL:styleAttribsPanel()
    if not IsValid(self.attribsPanel) then return end
    local canvas = self.attribsPanel.GetCanvas and self.attribsPanel:GetCanvas()
    if IsValid(canvas) then canvas:DockPadding(0, 0, 0, 0) end
    if self.attribsPanel.SetPaintBackground then self.attribsPanel:SetPaintBackground(false) end
    self.attribsPanel.Paint = function() end
    if not istable(self.attribsPanel.attribs) then return end
    for _, row in pairs(self.attribsPanel.attribs) do
        if not IsValid(row) then continue end
        row:SetTall(42)
        row:DockMargin(0, 0, 0, 4)
        row.Paint = function(s, w, h)
            local background = themeColor("focus_panel", themeColor("background", Color(25, 28, 35)))
            local accent = themeColor("accent", themeColor("theme", color_white))
            local hover = s:IsHovered() and 1 or 0
            s._hoverFrac = Lerp(FrameTime() * 10, s._hoverFrac or 0, hover)
            lia.derma.rect(0, 0, w, h):Rad(6):Color(alphaColor(background, 220)):Shape(lia.derma.SHAPE_IOS):Draw()
            lia.derma.rect(0, 0, w, h):Rad(6):Color(alphaColor(accent, 38 + math.floor(s._hoverFrac * 72))):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
        end

        if IsValid(row.name) then
            row.name:SetFont("LiliaFont.18")
            row.name:SetTextColor(themeColor("text", color_white))
            row.name:DockMargin(12, 0, 0, 0)
        end

        if IsValid(row.quantity) then
            row.quantity:SetFont("LiliaFont.18")
            row.quantity:SetTextColor(themeColor("text", color_white))
        end

        if IsValid(row.buttons) then
            row.buttons:SetWide(112)
            row.buttons:SetPaintBackground(false)
        end

        for _, button in ipairs({row.sub, row.add}) do
            if not IsValid(button) then continue end
            button:SetSize(30, 30)
            button:SetFont("LiliaFont.18")
        end
    end
end

function PANEL:shouldSkip()
    return false
end

function PANEL:updateAttributesLabel()
    local total = hook.Run("GetMaxStartingAttributePoints", LocalPlayer(), lia.config.get("StartingAttributePoints", 30)) or 0
    local attribs = self:getContext("attribs", {})
    local sum = 0
    for _, quantity in pairs(attribs) do
        sum = sum + quantity
    end

    local left = math.max(total - sum, 0)
    if IsValid(self.attrLabelText) then
        self.attrLabelText:SetText("Attributes")
        self.attrLabelText:SizeToContents()
    end

    if IsValid(self.pointsLabel) then
        self.pointsLabel:SetText(left .. " " .. ("Points Left"):lower())
        self.pointsLabel:SizeToContents()
    end
end

function PANEL:validate()
    for _, info in ipairs({{self.nameEntry, "name"}, {self.descEntry, "desc"}}) do
        if IsValid(info[1]) then
            local value = string.Trim(info[1]:GetValue() or "")
            if value == "" then return false, string.format("The field '%s' is required and cannot be empty.", info[2]) end
        end
    end

    if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false and IsValid(self.descEntry) then
        local desc = string.Trim(self.descEntry:GetValue() or "")
        local descWithoutSpaces = string.gsub(desc, "%s", "")
        local minLength = lia.config.get("MinDescLen", 16)
        if #descWithoutSpaces < minLength then return false, string.format("Description must be at least %s characters long.", minLength) end
    end

    if not IsValid(self.factionCombo) or not self.factionCombo:GetSelectedData() then return false, string.format("The field '%s' is required and cannot be empty.", "faction") end
    return true
end

function PANEL:onFactionSelected(fac)
    self:setContext("faction", fac.index)
    self:setContext("model", 1)
    self:updateModelPanel()
    self:updateNameAndDescForFaction(fac.index)
    if IsValid(lia.gui.character) then lia.gui.character:clickSound() end
end

function PANEL:updateNameAndDescForFaction(factionIndex)
    local client = LocalPlayer()
    local context = self:getContext()
    local defaultName, nameOverride = hook.Run("GetDefaultCharName", client, factionIndex, context)
    local defaultDesc, descOverride = hook.Run("GetDefaultCharDesc", client, factionIndex, context)
    if isstring(defaultName) and IsValid(self.nameEntry) and nameOverride ~= false then
        local currentName = string.Trim(self.nameEntry:GetValue() or "")
        if currentName == "" or nameOverride then
            timer.Simple(0.01, function()
                if not IsValid(self) or not IsValid(self.nameEntry) then return end
                self.nameEntry:SetValue(defaultName)
                self:setContext("name", defaultName)
            end)
        end
    end

    if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false and isstring(defaultDesc) and IsValid(self.descEntry) and descOverride ~= false then
        local currentDesc = string.Trim(self.descEntry:GetValue() or "")
        if currentDesc == "" or descOverride then
            timer.Simple(0.01, function()
                if not IsValid(self) or not IsValid(self.descEntry) then return end
                self.descEntry:SetValue(defaultDesc)
                self:setContext("desc", defaultDesc)
            end)
        end
    end
end

function PANEL:updateContext()
    if IsValid(self.nameEntry) then self:setContext("name", string.Trim(self.nameEntry:GetValue() or "")) end
    if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false then
        if IsValid(self.descEntry) then self:setContext("desc", string.Trim(self.descEntry:GetValue() or "")) end
    else
        local varData = lia.char.vars["desc"]
        if varData and varData.default then self:setContext("desc", varData.default) end
    end

    if IsValid(self.factionCombo) then
        local factionID = self.factionCombo:GetSelectedData()
        local faction = factionID and lia.faction.teams[factionID] or nil
        if faction then self:setContext("faction", faction.index) end
    end
end

function PANEL:onDisplay()
    local factionIndex = self:getContext("faction")
    local factionID = factionIndex and self:getFactionChoiceID(factionIndex) or nil
    if factionID and IsValid(self.factionCombo) then
        self._suppressFactionSelect = true
        self.factionCombo:ChooseOptionData(factionID)
        self._suppressFactionSelect = false
    end

    if IsValid(self.nameEntry) then self.nameEntry:SetValue(self:getContext("name", self.nameEntry:GetValue() or "")) end
    if IsValid(self.descEntry) then self.descEntry:SetValue(self:getContext("desc", self.descEntry:GetValue() or "")) end
    if IsValid(self.attribsPanel) then
        self.attribsPanel:onDisplay()
        self:styleAttribsPanel()
    end

    self:updateAttributesLabel()
end

vgui.Register("liaCharacterBiography", PANEL, "liaCharacterCreateStep")
