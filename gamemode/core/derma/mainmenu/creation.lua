--[[
    Hooks:
        ConfigureCharacterCreationSteps(Panel self)

    Purpose:
        Allows modules to insert additional creation-step panels into the default character creation flow before the summary step is appended.

    Category:
        Main Menu

    Parameters:
        self (Panel)
            The active `liaCharacterCreation` panel that owns the step list.

    Example Usage:
        ```lua
        hook.Add("ConfigureCharacterCreationSteps", "liaExampleConfigureCharacterCreationSteps", function(self)
            self:addStep(vgui.Create("liaCharacterSummary"), 1)
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        ShouldMenuButtonShow(string buttonID)

    Purpose:
        Allows code to block the default character creation button before the menu enters the creation flow.

    Category:
        Main Menu

    Parameters:
        buttonID (string)
            The menu action identifier being checked. This flow currently passes `"create"`.

    Example Usage:
        ```lua
        hook.Add("ShouldMenuButtonShow", "liaExampleShouldMenuButtonShow", function(buttonID)
            if buttonID == "create" then return false, "Creation disabled" end
        end)
        ```

    Returns:
        boolean|string|nil
            Return false to block the button. A second return value may provide the reason shown by the caller.

    Realm:
        Client
]]
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

local PANEL = {}
function PANEL:configureSteps()
    self:addStep(vgui.Create("liaCharacterBiography"))
    self:addStep(vgui.Create("liaCharacterModel"))
    hook.Run("ConfigureCharacterCreationSteps", self)
    local keys = table.GetKeys(self.steps)
    table.sort(keys)
    local ordered = {}
    for i, k in ipairs(keys) do
        ordered[i] = self.steps[k]
    end

    self.steps = ordered
    self:addStep(vgui.Create("liaCharacterSummary"))
end

function PANEL:updateModel()
    if not istable(self.context) then return end
    if IsValid(lia.gui.character) and lia.gui.character.inWorldPreview then
        lia.gui.character:updateCreationModelEntity(self.context)
        return
    end

    if not IsValid(self.model) then return end
    local faction = lia.faction.indices[self.context.faction]
    if not faction then return end
    local class = lia.faction.getCharacterCreationClass(faction, self.context.class)
    local info = lia.faction.getCharacterCreationModelInfo(faction, class, self.context.model)
    if not info then return end
    local parsed = lia.faction.getModelData(self.context.model, info)
    local mdl, skin, groups = info, 0, {}
    if parsed then mdl, skin, groups = parsed.model, parsed.skin, parsed.bodygroups end
    self.model:SetModel(mdl)
    self.model:fitFOV()
    local entity = self.model:GetEntity()
    if not IsValid(entity) then return end
    entity:SetupBones()
    entity:SetSkin(lia.faction.normalizeSkinValue(self.context.skin, skin))
    local finalGroups = istable(self.context.groups) and self.context.groups or istable(groups) and groups
    if finalGroups then lia.util.applyBodygroups(entity, finalGroups) end
    hook.Run("ModifyCharacterModel", entity, self.context)
end

function PANEL:canCreateCharacter()
    local valid = {}
    for _, team in pairs(lia.faction.teams) do
        if lia.faction.hasWhitelist(team.index) then valid[#valid + 1] = team.index end
    end

    if #valid == 0 then return false, L("unableToJoinFactions") end
    self.validFactions = valid
    local maxChars = hook.Run("GetMaxPlayerChar", LocalPlayer()) or lia.config.get("MaxCharacters", 5)
    if lia.characters and #lia.characters >= maxChars then return false, L("maxCharactersReached") end
    local ok, reason = hook.Run("ShouldMenuButtonShow", "create")
    if ok == false then return false, reason end
    return true
end

function PANEL:onFinish()
    if self.creating then return end
    for _, step in ipairs(self.steps) do
        if IsValid(step) and step.updateContext then step:updateContext() end
    end

    if IsValid(self.shell) then self.shell:SetVisible(false) end
    self:showMessage("creating")
    self.creating = true
    local function finish()
        timer.Remove("liaFailedToCreate")
        if not IsValid(self) then return end
        self.creating = false
        if IsValid(self.shell) then self.shell:SetVisible(true) end
        self:showMessage()
    end

    local function fail(err)
        finish()
        self:showError(err)
    end

    lia.module.get("mainmenu"):CreateCharacter(self.context):next(function(charID)
        finish()
        lia.module.get("mainmenu"):ChooseCharacter(charID):next(function() hook.Run("ResetCharacterPanel") end):catch(function(err) if err and err ~= "" then LocalPlayer():notifyErrorLocalized(err) end end)
    end, fail)

    timer.Create("liaFailedToCreate", 60, 1, function()
        if not IsValid(self) or not self.creating then return end
        fail(L("unknownError"))
    end)
end

function PANEL:showError(msg, ...)
    if IsValid(self.error) then self.error:Remove() end
    if not msg or msg == "" then return end
    assert(IsValid(self.content), L("noStepAvailable"))
    local err = self.content:Add("DLabel")
    err:SetFont("LiliaFont.18")
    err:SetText(L(msg, ...))
    err:SetTextColor(themeColor("text", color_white))
    err:Dock(TOP)
    err:SetTall(32)
    err:DockMargin(0, 0, 0, 8)
    err:SetContentAlignment(5)
    err.Paint = function(_, w, h)
        local bgColor = themeColor("focus_panel", themeColor("background", Color(25, 28, 35)))
        local lineColor = themeColor("negative", Color(220, 70, 70))
        lia.derma.rect(0, 0, w, h):Rad(6):Color(alphaColor(bgColor, 245)):Shape(lia.derma.SHAPE_IOS):Draw()
        surface.SetDrawColor(lineColor)
        surface.DrawRect(0, 0, w, 2)
    end

    err:SetAlpha(0)
    err:AlphaTo(255, 0.5)
    lia.gui.character:warningSound()
    self.error = err
end

function PANEL:showMessage(msg, ...)
    if not msg or msg == "" then
        if IsValid(self.message) then self.message:Remove() end
        self.message = nil
        return
    end

    local text = L(msg, ...):upper()
    if IsValid(self.message) then
        self.message:SetText(text)
        return
    end

    local lbl = self:Add("DLabel")
    lbl:SetFont("LiliaFont.16")
    lbl:SetTextColor(themeColor("text", color_white))
    lbl:Dock(FILL)
    lbl:SetContentAlignment(5)
    lbl:SetText(text)
    self.message = lbl
end

function PANEL:addStep(step, priority)
    assert(IsValid(step), L("invalidPanelForStep"))
    assert(step.isCharCreateStep, L("panelMustInherit"))
    if isnumber(priority) then
        table.insert(self.steps, priority, step)
    else
        self.steps[#self.steps + 1] = step
    end

    step:SetParent(self.content)
end

function PANEL:nextStep()
    local prevIdx = self.curStep
    local cur = self.steps[prevIdx]
    if IsValid(cur) then
        local ok, err = cur:validate()
        if ok == false then return self:showError(err) end
    end

    self:showError()
    self._transitionDir = 1
    self.curStep = prevIdx + 1
    local nxt = self.steps[self.curStep]
    while IsValid(nxt) and nxt:shouldSkip() do
        self.curStep = self.curStep + 1
        nxt:onSkip()
        nxt = self.steps[self.curStep]
    end

    if not IsValid(nxt) then
        self.curStep = prevIdx
        return self:onFinish()
    end

    self:onStepChanged(cur, nxt)
end

function PANEL:previousStep()
    local idx = self.curStep - 1
    local prev = self.steps[idx]
    while IsValid(prev) and prev:shouldSkip() do
        prev:onSkip()
        idx = idx - 1
        prev = self.steps[idx]
    end

    if not IsValid(prev) then return end
    self._transitionDir = -1
    self.curStep = idx
    self:onStepChanged(self.steps[idx + 1], prev)
end

function PANEL:getPreviousStep()
    local idx = self.curStep - 1
    while IsValid(self.steps[idx]) do
        if not self.steps[idx]:shouldSkip() then return self.steps[idx] end
        idx = idx - 1
    end
end

function PANEL:onStepChanged(oldStep, newStep)
    local finish = self.curStep == #self.steps
    local key = finish and "finish" or "next"
    if IsValid(newStep) then
        local shouldShowModel = newStep:GetName() == "liaCharacterModel"
        self.layoutMode = shouldShowModel and "preview" or "form"
        if IsValid(self.model) then self.model:SetVisible(false) end
        if IsValid(lia.gui.character) then
            lia.gui.character.inCharacterCreationModelStep = shouldShowModel
            lia.gui.character.noBlur = not shouldShowModel
            if shouldShowModel then
                lia.gui.character:setInWorldPreviewEnabled(true)
                lia.gui.character:updateCreationModelEntity(self.context)
            elseif lia.gui.character.inWorldPreview then
                lia.gui.character:setInWorldPreviewEnabled(false)
            end
        end

        self:InvalidateLayout(true)
        self:PerformLayout(self:GetWide(), self:GetTall())
    end

    if IsValid(self:getPreviousStep()) then
        self.prev:AlphaTo(255, 0.2)
        self.prev:SetMouseInputEnabled(true)
    else
        self.prev:AlphaTo(0, 0.2)
        self.prev:SetMouseInputEnabled(false)
    end

    local function sizeButton(btn, text)
        btn:SetText(text)
        surface.SetFont(btn:GetFont())
        local textW = surface.GetTextSize(text)
        btn:SetWide(math.max(112, textW + 40))
    end

    local nextText = L(key):upper()
    if nextText ~= self.next:GetText() then
        self.next:SetAlpha(0)
        sizeButton(self.next, nextText)
    end

    local function show()
        if not IsValid(newStep) or not IsValid(self.content) then return end
        local parent = self.content
        parent:InvalidateLayout(true)
        parent:PerformLayout()
        local pw, ph = parent:GetWide(), parent:GetTall()
        if pw <= 0 then pw = math.max(self:GetWide() - 64, 1) end
        if ph <= 0 then ph = math.max(self:GetTall() - 160, 1) end
        local dir = self._transitionDir or 1
        newStep:Stop()
        newStep:Dock(NODOCK)
        newStep:SetSize(pw, ph)
        newStep:SetPos(dir * pw, 0)
        newStep:SetAlpha(255)
        newStep:SetVisible(true)
        newStep:onDisplay()
        newStep:InvalidateChildren(true)
        self.next:AlphaTo(255, 0.2)
        newStep:MoveTo(0, 0, 0.2, 0, 0.2, function()
            if not IsValid(newStep) then return end
            newStep:Dock(FILL)
            parent:InvalidateLayout(true)
        end)
    end

    if IsValid(oldStep) then
        local parent = self.content
        local pw = IsValid(parent) and parent:GetWide() or self:GetWide()
        local ph = IsValid(parent) and parent:GetTall() or self:GetTall()
        local dir = self._transitionDir or 1
        oldStep:Stop()
        oldStep:Dock(NODOCK)
        oldStep:SetSize(math.max(pw, 1), math.max(ph, 1))
        oldStep:SetPos(0, 0)
        oldStep:SetAlpha(255)
        oldStep:MoveTo(-dir * math.max(pw, 1), 0, 0.2, 0, 0.2, function()
            if not IsValid(oldStep) then return end
            self:showError()
            oldStep:SetVisible(false)
            oldStep:onHide()
        end)

        show()
    else
        show()
    end
end

function PANEL:PerformLayout(w, h)
    if not IsValid(self.shell) then return end
    w = w or self:GetWide()
    h = h or self:GetTall()
    local margin = math.max(12, math.floor(h * 0.02))
    local left = margin
    local menu = IsValid(lia.gui.character) and lia.gui.character.menuPanel or nil
    if IsValid(menu) then
        local selfX = select(1, self:LocalToScreen(0, 0))
        local menuX = select(1, menu:LocalToScreen(0, 0))
        left = math.max(left, menuX + menu:GetWide() - selfX + margin)
    end

    local availableW = math.max(w - left - margin, 1)
    local maxWidth = self.layoutMode == "preview" and 820 or 1080
    local widthScale = self.layoutMode == "preview" and 0.72 or 0.9
    local minWidth = self.layoutMode == "preview" and 520 or 680
    local shellW = math.min(math.max(math.floor(availableW * widthScale), math.min(minWidth, availableW)), maxWidth, availableW)
    local shellH = math.max(h - margin * 2, 1)
    local shellX = left + math.floor((availableW - shellW) * 0.5)
    self.shell:SetPos(shellX, margin)
    self.shell:SetSize(shellW, shellH)
end

function PANEL:Init()
    self:Dock(FILL)
    local ok, reason = self:canCreateCharacter()
    if not ok then return self:showMessage(reason) end
    lia.gui.charCreate = self
    self.layoutMode = "form"
    self.steps = {}
    self.curStep = 0
    self.context = {}
    self.shell = self:Add("DPanel")
    self.shell:SetPaintBackground(false)
    self.shell.Paint = function(_, w, h)
        local background = themeColor("background", Color(18, 20, 24))
        local accent = themeColor("accent", themeColor("theme", Color(100, 150, 200)))
        lia.derma.rect(0, 0, w, h):Rad(10):Color(alphaColor(background, 238)):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(0, 0, w, h):Rad(10):Color(alphaColor(accent, 92)):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
    end

    self.header = self.shell:Add("DPanel")
    self.header:Dock(TOP)
    self.header:SetTall(84)
    self.header:SetPaintBackground(false)
    self.header.Paint = function(_, w, h)
        local accent = themeColor("accent", themeColor("theme", Color(100, 150, 200)))
        local text = themeColor("text", color_white)
        local count = math.max(#self.steps, 1)
        local step = math.Clamp(self.curStep, 1, count)
        draw.SimpleText(L("createCharacter"):upper(), "LiliaFont.25", 24, 22, text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(step .. " / " .. count, "LiliaFont.18", w - 24, 22, alphaColor(text, 180), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        local barX, barY, barW = 24, h - 20, math.max(w - 48, 1)
        surface.SetDrawColor(alphaColor(text, 28))
        surface.DrawRect(barX, barY, barW, 2)
        surface.SetDrawColor(accent)
        surface.DrawRect(barX, barY, math.max(math.floor(barW * step / count), 2), 2)
        if count > 1 then
            for i = 1, count do
                local x = barX + math.floor((i - 1) * barW / (count - 1))
                local active = i <= step
                local marker = active and accent or alphaColor(text, 65)
                lia.derma.rect(x - 5, barY - 4, 10, 10):Rad(5):Color(marker):Shape(lia.derma.SHAPE_IOS):Draw()
            end
        end
    end

    self.buttons = self.shell:Add("DPanel")
    self.buttons:Dock(BOTTOM)
    self.buttons:DockMargin(24, 0, 24, 16)
    self.buttons:SetTall(48)
    self.buttons:SetPaintBackground(false)
    self.content = self.shell:Add("DPanel")
    self.content:Dock(FILL)
    self.content:DockMargin(24, 0, 24, 12)
    self.content:SetPaintBackground(false)
    self.model = self.content:Add("liaModelPanel")
    if not IsValid(self.model) then return self:showError(L("failedToCreateModelPanel")) end
    self.model:SetWide(0)
    self.model:Dock(LEFT)
    self.model:SetModel("models/error.mdl")
    self.model:fitFOV()
    self.model:SetVisible(false)
    local function configureButton(btn, text, primary)
        btn:SetFont("LiliaFont.18")
        btn:SetText(text)
        btn:SetTall(44)
        surface.SetFont(btn:GetFont())
        local textW = surface.GetTextSize(text)
        btn:SetWide(math.max(112, textW + 40))
        btn:SetRadius(6)
        if primary then
            local accent = themeColor("accent", themeColor("theme", Color(100, 150, 200)))
            btn:PaintButton(alphaColor(accent, 52), alphaColor(accent, 92))
        else
            local focus = themeColor("focus_panel", themeColor("background", Color(30, 33, 40)))
            local hover = themeColor("button_hovered", themeColor("hover", focus))
            btn:PaintButton(alphaColor(focus, 220), alphaColor(hover, 235))
        end
    end

    self.prev = self.buttons:Add("liaButton")
    configureButton(self.prev, L("back"):upper(), false)
    self.prev:Dock(LEFT)
    self.prev.DoClick = function() self:previousStep() end
    self.prev:SetAlpha(0)
    self.prev:SetMouseInputEnabled(false)
    self.next = self.buttons:Add("liaButton")
    configureButton(self.next, L("next"):upper(), true)
    self.next:Dock(RIGHT)
    self.next.DoClick = function() self:nextStep() end
    self:configureSteps()
    if #self.steps == 0 then return self:showError("noCharacterSteps") end
    self:InvalidateLayout(true)
    self:nextStep()
    timer.Simple(0.5, function() if IsValid(self) and IsValid(self.model) then hook.Run("ModifyCharacterModel", self.model:GetEntity()) end end)
end

function PANEL:OnRemove()
    if IsValid(lia.gui.character) and lia.gui.character.inWorldPreview then lia.gui.character:setInWorldPreviewEnabled(false) end
    if IsValid(lia.gui.character) then
        lia.gui.character.inCharacterCreationModelStep = false
        lia.gui.character.noBlur = false
    end
end

vgui.Register("liaCharacterCreation", PANEL, "EditablePanel")
