local function getFaction(value)
    if value == nil then return nil end
    return lia.faction.indices[tonumber(value)] or lia.faction.get(value)
end

local function getDefaultClasses(faction)
    local classes = {}
    if not faction then return classes end
    for _, class in pairs(lia.class.list or {}) do
        if class.faction == faction.index and class.isDefault then classes[#classes + 1] = class end
    end

    table.sort(classes, function(a, b) return tostring(a.name) < tostring(b.name) end)
    return classes
end

local function getValidClass(value, factionValue)
    local class = lia.class.list and lia.class.list[tonumber(value)] or nil
    local faction = getFaction(factionValue)
    if not class or not faction or class.faction ~= faction.index or not class.isDefault then return nil end
    return class
end

local function installCreationValidation()
    local variable = lia.char and lia.char.vars and lia.char.vars.class
    if not variable or variable.liaCreationValidation then return end
    local previous = variable.onValidate
    variable.onValidate = function(value, data, client)
        if isfunction(previous) then
            local result = {previous(value, data, client)}
            if result[1] == false then return unpack(result) end
        end

        if data and data.faction == FACTION_STAFF and IsValid(client) and client:hasPrivilege("createStaffCharacter") then return true end
        local classes = getDefaultClasses(getFaction(data and data.faction))
        if #classes == 0 and (value == nil or tonumber(value) == 0) then return true end
        if #classes == 1 and (value == nil or tonumber(value) == 0) then return true end
        if not getValidClass(value, data and data.faction) then return false, "invalid", "class" end
        return true
    end

    variable.liaCreationValidation = true
end

installCreationValidation()
hook.Add("PostGamemodeLoaded", "liaInstallCharacterCreationClassValidation", installCreationValidation)

hook.Add("OverrideFactionModelCustomization", "liaCharacterCreationClassModelCustomization", function(_, faction, context, skinAllowed, bodygroupsAllowed)
    if not faction or not istable(context) then return end
    local class = getValidClass(context.class, faction.index)
    if class then
        if class.skinAllowed ~= nil then skinAllowed = class.skinAllowed == true end
        if class.bodygroupsAllowed ~= nil then bodygroupsAllowed = class.bodygroupsAllowed == true end
        if istable(class.allowedSkins) then skinAllowed = true end
        if istable(class.allowedBodygroups) then bodygroupsAllowed = true end
    end

    if istable(faction.allowedSkins) then skinAllowed = true end
    if istable(faction.allowedBodygroups) then bodygroupsAllowed = true end
    local creationClass = lia.faction.getCharacterCreationClass(faction, context.class)
    local raw = lia.faction.getCharacterCreationModelInfo(faction, creationClass, context.model)
    local parsed = raw and lia.faction.getModelData(context.model or 1, raw) or nil
    if parsed then
        if istable(parsed.allowedSkins) then skinAllowed = true end
        if istable(parsed.allowedBodygroups) then bodygroupsAllowed = true end
    end

    return skinAllowed, bodygroupsAllowed
end)

if SERVER then
    hook.Add("OnCharCreated", "liaApplyCharacterCreationClass", function(client, character, originalData)
        local selected = getValidClass(originalData and originalData.class, originalData and originalData.faction)
        if not selected or not character then return end
        timer.Simple(0.4, function()
            if not character or not character.setClass or character:getClass() == selected.index then return end
            local oldClass = character:getClass()
            character:setClass(selected.index)
            if IsValid(client) then hook.Run("OnPlayerJoinClass", client, selected.index, oldClass) end
            if IsValid(client) and character.sync then character:sync(client) end
            if character.save then character:save() end
        end)
    end)
    return
end

local function resetAppearance(context, faction, class)
    local models = lia.faction.getCharacterCreationModelChoices(faction, class)
    context.model = models and models[1] ~= nil and 1 or next(models or {})
    context.skin = nil
    context.bodygroups = nil
    context.groups = nil
end

local PANEL = {}
PANEL.creationOrder = 15
PANEL.creationName = "Class"
PANEL.creationWorldPreview = true

function PANEL:Init()
    self:Dock(FILL)
    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:SetTall(38)
    self.title:SetFont("LiliaFont.30")
    self.title:SetText("CLASS")
    self.title:SetTextColor(lia.color.theme.text or color_white)
    self.subtitle = self:Add("DLabel")
    self.subtitle:Dock(TOP)
    self.subtitle:DockMargin(0, 0, 0, 12)
    self.subtitle:SetTall(38)
    self.subtitle:SetFont("LiliaFont.16")
    self.subtitle:SetText("Choose one of this faction's default starting classes.")
    self.subtitle:SetTextColor(Color(190, 198, 208))
    self.cards = self:Add("liaScrollPanel")
    self.cards:Dock(FILL)
end

function PANEL:getClasses()
    return getDefaultClasses(getFaction(self:getContext("faction")))
end

function PANEL:shouldSkip()
    return #self:getClasses() <= 1
end

function PANEL:onSkip()
    local classes = self:getClasses()
    if #classes == 1 then
        self:setContext("class", classes[1].index)
        local faction = getFaction(self:getContext("faction"))
        if faction then resetAppearance(self:getContext(), faction, classes[1]) end
    else
        self:setContext("class", nil)
    end
end

function PANEL:onDisplay()
    self.cards:Clear()
    local faction = getFaction(self:getContext("faction"))
    for _, class in ipairs(self:getClasses()) do
        local logoPath = class.logo or faction and faction.logo
        local logo = logoPath
        if isstring(logo) then logo = Material(logo, "smooth") end
        local card = self.cards:Add("DButton")
        card:Dock(TOP)
        card:DockMargin(0, 0, 8, 10)
        card:SetTall(92)
        card:SetText("")
        card.hover = 0
        card.Think = function(button) button.hover = Lerp(FrameTime() * 12, button.hover, button:IsHovered() and 1 or 0) end
        card.Paint = function(button, w, h)
            local selected = tonumber(self:getContext("class")) == class.index
            local accent = class.color or faction.color or lia.color.theme.theme
            lia.derma.rect(0, 0, w, h):Rad(8):Color(Color(accent.r, accent.g, accent.b, selected and 32 or 12 + button.hover * 14)):Shape(lia.derma.SHAPE_IOS):Draw()
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

            draw.SimpleText(class.name or class.uniqueID or "Class", "LiliaFont.22", x, 17, lia.color.theme.text or color_white)
            draw.SimpleText(string.sub(tostring(class.desc or "Default class."):gsub("\n", " "), 1, 110), "LiliaFont.15", x, 51, Color(190, 198, 208))
        end

        card.DoClick = function()
            self:setContext("class", class.index)
            resetAppearance(self:getContext(), faction, class)
            self:updateModelPanel()
            if IsValid(lia.gui.character) then lia.gui.character:clickSound() end
        end
    end
end

function PANEL:validate()
    if #self:getClasses() <= 1 then return true end
    if not getValidClass(self:getContext("class"), self:getContext("faction")) then return false, "Choose a default class." end
    return true
end

hook.Add("ConfigureCharacterCreationSteps", "liaCharacterCreationClassStep", function(creator)
    if not vgui.GetControlTable("liaCharacterClass") then vgui.Register("liaCharacterClass", PANEL, "liaCharacterCreateStep") end
    creator:addStep(vgui.Create("liaCharacterClass"))
end)
