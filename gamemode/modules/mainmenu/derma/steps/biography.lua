local PANEL = {}
PANEL.creationOrder = 20
PANEL.creationName = "Identity"
PANEL.creationWorldPreview = true

local function addHeading(parent, title, subtitle)
    local heading = parent:Add("DPanel")
    heading:Dock(TOP)
    heading:SetTall(78)
    heading:SetPaintBackground(false)
    heading.title = heading:Add("DLabel")
    heading.title:Dock(TOP)
    heading.title:SetTall(38)
    heading.title:SetFont("LiliaFont.30")
    heading.title:SetText(title)
    heading.title:SetTextColor(lia.color.theme.text or color_white)
    heading.subtitle = heading:Add("DLabel")
    heading.subtitle:Dock(TOP)
    heading.subtitle:SetTall(34)
    heading.subtitle:SetFont("LiliaFont.16")
    heading.subtitle:SetText(subtitle)
    heading.subtitle:SetTextColor(Color(190, 198, 208))
    heading.subtitle:SetWrap(true)
end

local function addEntry(parent, title, multiline)
    local wrap = parent:Add("DPanel")
    wrap:Dock(TOP)
    wrap:DockMargin(0, 0, 0, 14)
    wrap:DockPadding(14, 10, 14, 12)
    wrap:SetTall(multiline and 136 or 88)
    wrap.Paint = function(_, w, h)
        lia.derma.rect(0, 0, w, h):Rad(8):Color(Color(20, 25, 32, 238)):Shape(lia.derma.SHAPE_IOS):Draw()
        surface.SetDrawColor(ColorAlpha(lia.color.theme.theme, 70))
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local label = wrap:Add("DLabel")
    label:Dock(TOP)
    label:SetTall(22)
    label:SetFont("LiliaFont.15")
    label:SetText(title:upper())
    label:SetTextColor(Color(185, 195, 205))
    local entry = wrap:Add("liaEntry")
    entry:Dock(FILL)
    entry:DockMargin(0, 5, 0, 0)
    entry:SetFont("LiliaFont.18")
    if multiline and entry.SetMultiline then entry:SetMultiline(true) end
    return entry
end

function PANEL:Init()
    self:Dock(FILL)
    addHeading(self, "IDENTITY", "Define the character's visible identity. Schema character-variable validation still runs when the character is submitted.")
    self.entries = {}
    if hook.Run("ShouldShowCharVarInCreation", "name") ~= false then self.entries.name = addEntry(self, "Name", false) end
    if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false then self.entries.desc = addEntry(self, "Description", true) end
    for key, entry in pairs(self.entries) do
        local function sync(pnl, value) self:setContext(key, string.Trim(tostring(value ~= nil and value or pnl:GetValue() or ""))) end
        entry.OnChange = function(pnl) sync(pnl) end
        entry.OnValueChange = function(pnl, value) sync(pnl, value) end
        entry.OnLoseFocus = function(pnl) sync(pnl) end
        entry.OnEnter = function(pnl) sync(pnl) end
    end
end

function PANEL:applyFactionDefaults()
    local context = self:getContext()
    local faction = context.faction
    if not faction or self.defaultFaction == faction then return end
    self.defaultFaction = faction
    local defaultName, forceName = hook.Run("GetDefaultCharName", LocalPlayer(), faction, context)
    local defaultDesc, forceDesc = hook.Run("GetDefaultCharDesc", LocalPlayer(), faction, context)
    if IsValid(self.entries.name) and isstring(defaultName) and (forceName == true or string.Trim(self.entries.name:GetValue()) == "") then
        self.entries.name:SetValue(defaultName)
        self:setContext("name", defaultName)
    end

    if IsValid(self.entries.desc) and isstring(defaultDesc) and (forceDesc == true or string.Trim(self.entries.desc:GetValue()) == "") then
        self.entries.desc:SetValue(defaultDesc)
        self:setContext("desc", defaultDesc)
    end
end

function PANEL:onDisplay()
    for key, entry in pairs(self.entries) do
        if IsValid(entry) then entry:SetValue(tostring(self:getContext(key, ""))) end
    end

    self:applyFactionDefaults()
end

function PANEL:updateContext()
    for key, entry in pairs(self.entries) do
        if IsValid(entry) then self:setContext(key, string.Trim(entry:GetValue() or "")) end
    end

    if hook.Run("ShouldShowCharVarInCreation", "desc") == false then
        local variable = lia.char.vars.desc
        if variable and variable.default ~= nil then self:setContext("desc", variable.default) end
    end
end

function PANEL:validate()
    self:updateContext()
    for key, entry in pairs(self.entries) do
        if IsValid(entry) then
            local ok, reason, detail = self:validateCharVar(key)
            if ok == false then return false, reason or detail or ("Invalid " .. key .. ".") end
        end
    end

    return true
end

vgui.Register("liaCharacterBiography", PANEL, "liaCharacterCreateStep")
