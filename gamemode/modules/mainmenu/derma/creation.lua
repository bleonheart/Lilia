local PANEL = {}
function PANEL:configureSteps()
    self:addStep(vgui.Create("liaCharacterBiography"))
    self:addStep(vgui.Create("liaCharacterModel"))
    hook.Run("ConfigureCharacterCreationSteps", self)
    self:addStep(vgui.Create("liaCharacterSummary"))
    local ordered = {}
    local prioritized = {}
    for _, step in ipairs(self.steps) do
        if step._creationPriority then
            prioritized[#prioritized + 1] = step
        else
            ordered[#ordered + 1] = step
        end
    end

    table.sort(ordered, function(a, b)
        local aOrder = tonumber(a.creationOrder) or 35
        local bOrder = tonumber(b.creationOrder) or 35
        if aOrder == bOrder then return (a._creationSequence or 0) < (b._creationSequence or 0) end
        return aOrder < bOrder
    end)

    table.sort(prioritized, function(a, b) return (a._creationSequence or 0) < (b._creationSequence or 0) end)
    for _, step in ipairs(prioritized) do
        local priority = math.Clamp(math.floor(step._creationPriority), 1, #ordered + 1)
        table.insert(ordered, priority, step)
    end

    self.steps = ordered
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
    local finalGroups = istable(self.context.bodygroups) and self.context.bodygroups or istable(self.context.groups) and self.context.groups or istable(groups) and groups
    if finalGroups then lia.util.applyBodygroups(entity, finalGroups) end
    hook.Run("ModifyCharacterModel", entity, self.context)
end

function PANEL:canCreateCharacter()
    local valid = {}
    for _, team in pairs(lia.faction.teams) do
        if team.uniqueID ~= "staff" and lia.faction.hasWhitelist(team.index) then valid[#valid + 1] = team.index end
    end

    if #valid == 0 then return false, "You are unable to join any factions" end
    self.validFactions = valid
    local maxChars = hook.Run("GetMaxPlayerChar", LocalPlayer()) or lia.config.get("MaxCharacters", 5)
    if lia.characters and #lia.characters >= maxChars then return false, "You have reached the maximum number of characters" end
    local ok, reason = hook.Run("ShouldMenuButtonShow", "create")
    if ok == false then return false, reason end
    return true
end

function PANEL:onFinish()
    if self.creating then return end
    for _, step in ipairs(self.steps) do
        if IsValid(step) and step.updateContext then step:updateContext() end
    end

    self.content:SetVisible(false)
    self.buttons:SetVisible(false)
    self:showMessage("creating")
    self.creating = true
    local function finish()
        timer.Remove("liaFailedToCreate")
        if not IsValid(self) then return end
        self.creating = false
        self.content:SetVisible(true)
        self.buttons:SetVisible(true)
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
        fail("Unknown error")
    end)
end

function PANEL:showError(msg, ...)
    if IsValid(self.error) then self.error:Remove() end
    if not msg or msg == "" then return end
    assert(IsValid(self.content), "No step is available")
    local err = self.content:Add("DLabel")
    err:SetFont("LiliaFont.18")
    err:SetText(lia.lang.resolve(msg, ...))
    err:SetTextColor(color_white)
    err:Dock(TOP)
    err:SetTall(32)
    err:DockMargin(0, 0, 0, 8)
    err:SetContentAlignment(5)
    err.Paint = function(box, w, h)
        local bgColor = Color(25, 28, 35, 250)
        local lineColor = Color(220, 70, 70)
        lia.derma.rect(0, 0, w, h):Rad(12):Color(bgColor):Shape(lia.derma.SHAPE_IOS):Draw()
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
        return
    end

    if IsValid(self.message) then
        self.message:SetText(lia.lang.resolve(msg, ...):upper())
        return
    end

    local lbl = self:Add("DLabel")
    lbl:SetFont("LiliaFont.16")
    lbl:SetTextColor(lia.gui.character.color)
    lbl:Dock(FILL)
    lbl:SetContentAlignment(5)
    lbl:SetText(lia.lang.resolve(msg, ...):upper())
    self.message = lbl
end

function PANEL:addStep(step, priority)
    assert(IsValid(step), "Invalid panel for step")
    assert(step.isCharCreateStep, "Panel must inherit liaCharacterCreateStep")
    self._creationSequence = (self._creationSequence or 0) + 1
    step._creationSequence = self._creationSequence
    step._creationPriority = isnumber(priority) and priority or nil
    self.steps[#self.steps + 1] = step
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
        local camera = {
            liaCharacterFaction = {90, 30},
            liaCharacterClass = {84, 34},
            liaCharacterBiography = {74, 42},
            liaCharacterModel = {64, 50},
            liaCharacterAttributesPage = {78, 40},
            liaCharacterSummary = {86, 34}
        }
        local view = istable(newStep.creationCamera) and newStep.creationCamera or camera[newStep:GetName()]
        local shouldShowModel = newStep.creationWorldPreview == true or view ~= nil
        view = view or {76, 40}
        if IsValid(self.model) then self.model:SetVisible(shouldShowModel and not (IsValid(lia.gui.character) and lia.gui.character.inWorldPreview)) end
        if IsValid(lia.gui.character) then
            lia.gui.character.creationCameraDistance = view[1]
            lia.gui.character.creationCameraSide = view[2]
            lia.gui.character.inCharacterCreationModelStep = shouldShowModel
            if shouldShowModel then
                if IsValid(self.content) then
                    self.content:Dock(RIGHT)
                    self.content:SetWide(math.Clamp(ScrW() * 0.46, 520, 860))
                    self.content:DockMargin(0, 68, 42, 88)
                end

                lia.gui.character.noBlur = true
                if IsValid(self.model) then
                    self.model:SetVisible(false)
                    self.model:SetWide(0)
                end

                if IsValid(self.buttons) then
                    self.buttons:SetParent(self)
                    self.buttons:SetTall(48)
                    self.buttons:MoveToFront()
                    self.buttons:Dock(NODOCK)
                    self.buttons._liaFullWidthBottom = true
                    if self.buttons._liaOldThink == nil then self.buttons._liaOldThink = self.buttons.Think end
                    self.buttons.Think = function(pnl)
                        if isfunction(pnl._liaOldThink) then pnl._liaOldThink(pnl) end
                        if not pnl._liaFullWidthBottom then return end
                        local h = pnl:GetTall()
                        pnl:SetSize(self:GetWide(), h)
                        pnl:SetPos(0, self:GetTall() - h)
                        pnl:MoveToFront()
                    end
                end

                lia.gui.character:setInWorldPreviewEnabled(true)
                lia.gui.character:updateCreationModelEntity(self.context)
            else
                if lia.gui.character.inWorldPreview then lia.gui.character:setInWorldPreviewEnabled(false) end
                lia.gui.character.noBlur = false
                if IsValid(self.content) then
                    local margin = ScrW() > 1280 and ScrW() * 0.15 or ScrW() > 720 and ScrW() * 0.075 or 0
                    self.content:Dock(FILL)
                    self.content:DockMargin(margin, 64, margin, 96)
                    self.content:SetWide(0)
                end

                if IsValid(self.buttons) then
                    self.buttons:SetParent(self)
                    self.buttons._liaFullWidthBottom = nil
                    if self.buttons._liaOldThink ~= nil then
                        self.buttons.Think = self.buttons._liaOldThink
                        self.buttons._liaOldThink = nil
                    else
                        self.buttons.Think = nil
                    end

                    self.buttons:Dock(BOTTOM)
                    self.buttons:DockMargin(0, 0, 0, 0)
                    self.buttons:SetTall(48)
                    self.buttons:MoveToFront()
                end
            end
        end
    end

    self:updateProgress()
    if IsValid(self:getPreviousStep()) then
        self.prev:AlphaTo(255, 0.5)
    else
        self.prev:AlphaTo(0, 0.5)
    end

    local function sizeButton(btn, txt)
        btn:SetText(txt)
        surface.SetFont(btn:GetFont())
        local w = select(1, surface.GetTextSize(txt))
        btn:SetWide(w + 40)
    end

    if tostring(key):upper() ~= self.next:GetText() then self.next:AlphaTo(0, 0.5) end
    local function show()
        if not IsValid(newStep) then return end
        local parent = self.content
        if not IsValid(parent) then return end
        parent:InvalidateLayout(true)
        parent:PerformLayout()
        local pw, ph = parent:GetWide(), parent:GetTall()
        if pw <= 0 then pw = ScrW() end
        if ph <= 0 then ph = ScrH() end
        local dir = self._transitionDir or 1
        newStep:Stop()
        newStep:Dock(NODOCK)
        newStep:SetSize(pw, ph)
        newStep:SetPos(dir * pw, 0)
        newStep:SetAlpha(255)
        newStep:SetVisible(true)
        newStep:onDisplay()
        newStep:InvalidateChildren(true)
        if tostring(key):upper() ~= self.next:GetText() then
            self.next:SetAlpha(0)
            sizeButton(self.next, tostring(key):upper())
        end

        self.next:AlphaTo(255, 0.5)
        local duration = 0.35
        newStep:MoveTo(0, 0, duration, 0, 0.2, function()
            if not IsValid(newStep) then return end
            newStep:Dock(FILL)
            parent:InvalidateLayout(true)
        end)
    end

    if IsValid(oldStep) then
        local parent = self.content
        local pw = IsValid(parent) and parent:GetWide() or ScrW()
        if pw <= 0 then pw = ScrW() end
        local dir = self._transitionDir or 1
        oldStep:Stop()
        oldStep:Dock(NODOCK)
        oldStep:SetSize(pw, IsValid(parent) and parent:GetTall() or ScrH())
        oldStep:SetPos(0, 0)
        oldStep:SetAlpha(255)
        oldStep:MoveTo(-dir * pw, 0, 0.35, 0, 0.2, function()
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

function PANEL:updateProgress()
    if not IsValid(self.progress) then return end
    self.progress:Clear()
    local visible = {}
    for index, step in ipairs(self.steps or {}) do
        if IsValid(step) and not step:shouldSkip() then visible[#visible + 1] = {index, step} end
    end

    local available = self.progress:GetWide()
    if available <= 0 then available = math.max(ScrW() * 0.49 - 42, 1) end
    local itemWidth = math.Clamp(math.floor((available - math.max(#visible - 1, 0) * 8) / math.max(#visible, 1)), 60, 112)
    for visibleIndex, data in ipairs(visible) do
        local index, step = data[1], data[2]
        local item = self.progress:Add("DPanel")
        item:Dock(LEFT)
        item:DockMargin(0, 0, 8, 0)
        item:SetWide(itemWidth)
        item.Paint = function(_, w, h)
            local active = index == self.curStep
            local complete = index < self.curStep
            local accent = lia.color.theme.theme
            lia.derma.rect(0, h - 3, w, 3):Rad(2):Color(active and accent or complete and ColorAlpha(accent, 125) or Color(255, 255, 255, 24)):Draw()
        end

        local label = item:Add("DLabel")
        label:Dock(FILL)
        label:SetFont("LiliaFont.14")
        label:SetText(string.format("%02d  %s", visibleIndex, tostring(step.creationName or step:GetName():gsub("^liaCharacter", "")):upper()))
        label:SetTextColor(index == self.curStep and (lia.color.theme.text or color_white) or Color(155, 165, 175))
        label:SetContentAlignment(5)
    end
end

function PANEL:Init()
    self:Dock(FILL)
    local ok, reason = self:canCreateCharacter()
    if not ok then return self:showMessage(reason) end
    lia.gui.charCreate = self
    self.progress = self:Add("DPanel")
    self.progress:Dock(TOP)
    self.progress:DockMargin(math.floor(ScrW() * 0.51), 24, 42, 0)
    self.progress:SetTall(44)
    self.progress:SetPaintBackground(false)
    self.content = self:Add("DPanel")
    self.content:Dock(RIGHT)
    self.content:SetWide(math.Clamp(ScrW() * 0.46, 520, 860))
    self.content:DockMargin(0, 18, 42, 22)
    self.content:DockPadding(18, 18, 18, 18)
    self.content.Paint = function(_, w, h)
        lia.derma.rect(0, 0, w, h):Rad(10):Color(Color(12, 16, 22, 224)):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(0, 0, w, h):Rad(10):Color(ColorAlpha(lia.color.theme.theme, 46)):Outline(1):Draw()
    end
    self.model = self.content:Add("liaModelPanel")
    if not IsValid(self.model) then return self:showError("Failed to create model panel") end
    self.model:SetWide(0)
    self.model:Dock(LEFT)
    self.model:SetModel("models/error.mdl")
    self.model:fitFOV()
    self.model:SetVisible(false)
    self.buttons = self:Add("DPanel")
    self.buttons:Dock(BOTTOM)
    self.buttons:SetTall(64)
    self.buttons.Paint = function(_, w, h)
        surface.SetDrawColor(8, 11, 16, 235)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(ColorAlpha(lia.color.theme.theme, 45))
        surface.DrawRect(0, 0, w, 1)
    end
    local function sizeButton(btn, text)
        btn:SetText(text)
        local font = btn:GetFont()
        surface.SetFont(font)
        local textW, _ = surface.GetTextSize(text)
        local padding = 20
        btn:SetWide(textW + padding * 2)
    end

    self.prev = self.buttons:Add("liaMediumButton")
    sizeButton(self.prev, ("Back"):upper())
    self.prev:Dock(LEFT)
    self.prev.DoClick = function() self:previousStep() end
    self.prev:SetAlpha(0)
    self.next = self.buttons:Add("liaMediumButton")
    sizeButton(self.next, ("Next"):upper())
    self.next:Dock(RIGHT)
    self.next.DoClick = function() self:nextStep() end
    self.steps = {}
    self.curStep = 0
    self.context = {}
    self:configureSteps()
    if #self.steps == 0 then return self:showError("noCharacterSteps") end
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
