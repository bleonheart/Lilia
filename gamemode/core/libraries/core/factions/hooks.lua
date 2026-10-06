if SERVER then return end

local function getAvailableFactions()
    local factions = {}
    for _, faction in pairs(lia.faction.teams or {}) do
        if faction.uniqueID ~= "staff" and lia.faction.hasWhitelist(faction.index) then factions[#factions + 1] = faction end
    end

    table.sort(factions, function(a, b) return tostring(a.name) < tostring(b.name) end)
    return factions
end

local function resetAppearance(context, faction)
    context.class = nil
    local class = lia.faction.getCharacterCreationClass(faction)
    local models = lia.faction.getCharacterCreationModelChoices(faction, class)
    context.model = models and models[1] ~= nil and 1 or next(models or {})
    context.skin = nil
    context.bodygroups = nil
    context.groups = nil
end

local function addHeading(parent)
    local title = parent:Add("DLabel")
    title:Dock(TOP)
    title:SetTall(38)
    title:SetFont("LiliaFont.30")
    title:SetText("FACTION")
    title:SetTextColor(lia.color.theme.text or color_white)
    local subtitle = parent:Add("DLabel")
    subtitle:Dock(TOP)
    subtitle:DockMargin(0, 0, 0, 12)
    subtitle:SetTall(38)
    subtitle:SetFont("LiliaFont.16")
    subtitle:SetText("Choose where this character belongs. Whitelists and staff restrictions use the normal Lilia checks.")
    subtitle:SetTextColor(Color(190, 198, 208))
    subtitle:SetWrap(true)
end

local PANEL = {}
PANEL.creationOrder = 10
PANEL.creationName = "Faction"
PANEL.creationWorldPreview = true

function PANEL:Init()
    self:Dock(FILL)
    addHeading(self)
    self.cards = self:Add("liaScrollPanel")
    self.cards:Dock(FILL)
end

function PANEL:buildCards()
    self.cards:Clear()
    for _, faction in ipairs(getAvailableFactions()) do
        local logo = faction.logo
        if isstring(logo) then logo = Material(logo, "smooth") end
        local card = self.cards:Add("DButton")
        card:Dock(TOP)
        card:DockMargin(0, 0, 8, 10)
        card:SetTall(92)
        card:SetText("")
        card.faction = faction
        card.hover = 0
        card.Think = function(button) button.hover = Lerp(FrameTime() * 12, button.hover, button:IsHovered() and 1 or 0) end
        card.Paint = function(button, w, h)
            local selected = self:getContext("faction") == faction.index
            local accent = faction.color or lia.color.theme.theme
            local alpha = selected and 32 or 12 + button.hover * 14
            lia.derma.rect(0, 0, w, h):Rad(8):Color(Color(accent.r, accent.g, accent.b, alpha)):Shape(lia.derma.SHAPE_IOS):Draw()
            surface.SetDrawColor(accent.r, accent.g, accent.b, selected and 220 or 55 + button.hover * 75)
            surface.DrawOutlinedRect(0, 0, w, h)
            if selected then surface.DrawRect(0, 0, 4, h) end
            local x = 18
            if logo then
                surface.SetMaterial(logo)
                surface.SetDrawColor(255, 255, 255, 225)
                surface.DrawTexturedRect(16, 16, 58, 58)
                x = 90
            end

            draw.SimpleText(faction.name or "Faction", "LiliaFont.22", x, 17, lia.color.theme.text or color_white)
            draw.SimpleText(string.sub(tostring(faction.desc or "No description."):gsub("\n", " "), 1, 110), "LiliaFont.15", x, 51, Color(190, 198, 208))
        end

        card.DoClick = function()
            if self:getContext("faction") == faction.index then return end
            self:setContext("faction", faction.index)
            resetAppearance(self:getContext(), faction)
            self:updateModelPanel()
            if IsValid(lia.gui.character) then lia.gui.character:clickSound() end
        end
    end
end

function PANEL:onDisplay()
    self:buildCards()
end

function PANEL:validate()
    local faction = lia.faction.indices[self:getContext("faction")]
    if not faction then return false, "Choose an available faction." end
    local ok, reason, detail = self:validateCharVar("faction")
    if ok == false then return false, reason or detail or "You cannot use this faction." end
    return true
end

hook.Add("ConfigureCharacterCreationSteps", "liaCharacterCreationFactionStep", function(creator)
    if not vgui.GetControlTable("liaCharacterFaction") then vgui.Register("liaCharacterFaction", PANEL, "liaCharacterCreateStep") end
    creator:addStep(vgui.Create("liaCharacterFaction"))
end)
