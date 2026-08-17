local PANEL = {}
local optionHeight = 36
local edgePadding = 8
local maxMenuHeight = 380
local activeComboMenu
local transparent = Color(0, 0, 0, 0)
local function hideNativeControls(combo)
    if IsValid(combo.DropButton) then
        combo.DropButton:SetVisible(false)
        combo.DropButton:SetAlpha(0)
        combo.DropButton:SetMouseInputEnabled(false)
        combo.DropButton:SetKeyboardInputEnabled(false)
        combo.DropButton:SetSize(0, 0)
        combo.DropButton:SetPos(-1000, -1000)
        combo.DropButton.Paint = function() end
        combo.DropButton.PaintOver = function() end
    end

    if IsValid(combo.TextEntry) then
        combo.TextEntry:SetVisible(false)
        combo.TextEntry:SetAlpha(0)
        combo.TextEntry:SetMouseInputEnabled(false)
        combo.TextEntry:SetKeyboardInputEnabled(false)
        combo.TextEntry:SetPaintBackground(false)
        combo.TextEntry:SetTextColor(transparent)
        combo.TextEntry:SetSize(0, 0)
        combo.TextEntry:SetPos(-1000, -1000)
        combo.TextEntry.Paint = function() end
        combo.TextEntry.PaintOver = function() end
    end
end

local function drawPanel(x, y, w, h, radius, background, outline)
    if lia and lia.derma and lia.derma.rect then
        lia.derma.rect(x, y, w, h):Rad(radius):Color(background):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
        return
    end

    draw.RoundedBox(radius, x, y, w, h, background)
    if outline then
        surface.SetDrawColor(outline)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end
end

local function getMenuChoices(combo)
    local choices = {}
    for index, label in ipairs(combo.Choices or {}) do
        choices[#choices + 1] = {
            index = index,
            label = tostring(label or "")
        }
    end

    if combo:GetSortItems() then table.sort(choices, function(a, b) return string.lower(a.label) < string.lower(b.label) end) end
    return choices
end

local function themeScrollBar(scrollPanel)
    if not IsValid(scrollPanel) or not isfunction(scrollPanel.GetVBar) then return end
    local vbar = scrollPanel:GetVBar()
    if not IsValid(vbar) then return end
    vbar:SetWide(10)
    vbar:SetHideButtons(true)
    vbar.Paint = function(_, w, h)
        surface.SetDrawColor(lia.color.theme.background)
        surface.DrawRect(0, 0, w, h)
    end

    if IsValid(vbar.btnGrip) then
        vbar.btnGrip.Paint = function(_, w, h)
            local accent = lia.color.theme.accent or lia.color.theme.maincolor
            draw.RoundedBox(3, 2, 2, math.max(w - 4, 1), math.max(h - 4, 1), Color(accent.r, accent.g, accent.b, 155))
        end
    end
end

local function scrollMenu(menu, delta)
    if not IsValid(menu) or not IsValid(menu.scrollPanel) then return false end
    local vbar = menu.scrollPanel:GetVBar()
    if not IsValid(vbar) or not vbar.Enabled then return false end
    local optionHeight = menu.optionHeight or 1
    vbar:SetScroll(vbar:GetScroll() - (tonumber(delta) or 0) * optionHeight * 3)
    return true
end

local function bindMenuWheel(panel, menu)
    if not IsValid(panel) then return end
    panel.OnMouseWheeled = function(_, delta) return scrollMenu(menu, delta) end
end

local function styleOption(combo, menu, option, optionIndex, optionLabel, optionHeight)
    option:SetText("")
    option:SetTall(optionHeight)
    option:SetCursor("hand")
    local tooltip = combo._choiceTooltips and combo._choiceTooltips[optionIndex]
    if tooltip and tooltip ~= "" then option:SetTooltip(tooltip) end
    option.Paint = function(s, w, h)
        local accent = lia.color.theme.accent or lia.color.theme.maincolor
        local selected = combo:GetSelectedID() == optionIndex or tostring(combo:GetValue()) == optionLabel
        local hovered = s:IsHovered()
        local background = selected and Color(accent.r, accent.g, accent.b, 30) or hovered and Color(accent.r, accent.g, accent.b, 18) or lia.color.theme.background
        local outline = Color(accent.r, accent.g, accent.b, selected and 135 or hovered and 82 or 32)
        drawPanel(1, 0, math.max(w - 2, 1), h, 4, background, outline)
        local icon = combo.ChoiceIcons and combo.ChoiceIcons[optionIndex]
        local textX = 12
        if icon then
            local material = Material(icon)
            if material and material:IsValid() then
                local size = 16
                surface.SetMaterial(material)
                surface.SetDrawColor(selected and accent or lia.color.theme.text)
                surface.DrawTexturedRect(12, math.floor((h - size) * 0.5), size, size)
                textX = 34
            end
        end

        draw.SimpleText(optionLabel, "LiliaFont.18", textX, h * 0.5, selected and accent or lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if combo.Spacers and combo.Spacers[optionIndex] then
            surface.SetDrawColor(accent)
            surface.DrawRect(8, h - 1, math.max(w - 16, 1), 1)
        end
        return true
    end

    option.DoClick = function()
        if not IsValid(combo) then return end
        local overlay = menu:GetParent()
        timer.Simple(0, function()
            if IsValid(combo) then
                combo:ChooseOption(optionLabel, optionIndex)
                if lia and lia.websound and isfunction(lia.websound.playButtonSound) then lia.websound.playButtonSound() end
            end

            if IsValid(overlay) then overlay:Remove() end
        end)
    end

    bindMenuWheel(option, menu)
end

local function openComboMenu(combo)
    if not IsValid(combo) or #(combo.Choices or {}) == 0 then return end
    combo:CloseMenu()
    if IsValid(activeComboMenu) then activeComboMenu:Remove() end
    local choices = getMenuChoices(combo)
    local optionHeight = math.max(combo:GetTall(), 1)
    local totalHeight = #choices * optionHeight
    local comboX, comboTop = combo:LocalToScreen(0, 0)
    local _, comboBottom = combo:LocalToScreen(0, combo:GetTall())
    local belowSpace = math.max(ScrH() - comboBottom - edgePadding, 0)
    local aboveSpace = math.max(comboTop - edgePadding, 0)
    local openBelow = totalHeight <= belowSpace or belowSpace >= aboveSpace
    local availableHeight = openBelow and belowSpace or aboveSpace
    local menuHeight = math.max(math.min(totalHeight, maxMenuHeight, availableHeight), math.min(optionHeight, math.max(ScrH() - edgePadding * 2, 1)))
    local menuY = openBelow and comboBottom or comboTop - menuHeight
    local overlay = vgui.Create("DPanel", vgui.GetWorldPanel())
    if not IsValid(overlay) then return end
    combo.Menu = overlay
    activeComboMenu = overlay
    overlay:SetPos(0, 0)
    overlay:SetSize(ScrW(), ScrH())
    overlay:SetMouseInputEnabled(true)
    overlay:SetKeyboardInputEnabled(false)
    overlay:SetDrawOnTop(true)
    overlay:SetZPos(32767)
    overlay.Paint = function() end
    overlay.OnMousePressed = function(s, mouseCode)
        if mouseCode ~= MOUSE_LEFT and mouseCode ~= MOUSE_RIGHT then return end
        s.closeOnRelease = true
        s:MouseCapture(true)
    end

    overlay.OnMouseReleased = function(s, mouseCode)
        if not s.closeOnRelease then return end
        if mouseCode ~= MOUSE_LEFT and mouseCode ~= MOUSE_RIGHT then return end
        s.closeOnRelease = false
        s:MouseCapture(false)
        timer.Simple(0, function() if IsValid(s) then s:Remove() end end)
    end

    overlay.OnRemove = function()
        if IsValid(combo) and combo.Menu == overlay then combo.Menu = nil end
        if activeComboMenu == overlay then activeComboMenu = nil end
    end

    local menu = overlay:Add("DPanel")
    menu:SetPos(math.Clamp(comboX, edgePadding, math.max(ScrW() - combo:GetWide() - edgePadding, edgePadding)), menuY)
    menu:SetSize(combo:GetWide(), menuHeight)
    menu.optionHeight = optionHeight
    menu:SetMouseInputEnabled(true)
    menu:SetKeyboardInputEnabled(false)
    menu:SetZPos(1)
    menu.Paint = function(_, w, h) drawPanel(0, 0, w, h, 5, lia.color.theme.background, lia.color.theme.accent or lia.color.theme.maincolor) end
    menu.scrollPanel = menu:Add("DScrollPanel")
    menu.scrollPanel:Dock(FILL)
    menu.scrollPanel:SetMouseInputEnabled(true)
    menu.scrollPanel:SetKeyboardInputEnabled(false)
    menu.scrollPanel.Paint = function() end
    themeScrollBar(menu.scrollPanel)
    bindMenuWheel(menu, menu)
    bindMenuWheel(menu.scrollPanel, menu)
    bindMenuWheel(menu.scrollPanel:GetCanvas(), menu)
    local canvas = menu.scrollPanel:GetCanvas()
    canvas.PerformLayout = function(s, w)
        local y = 0
        for _, option in ipairs(s:GetChildren()) do
            option:SetPos(0, y)
            option:SetSize(w, optionHeight)
            y = y + optionHeight
        end

        s:SetTall(y)
    end

    for _, choice in ipairs(choices) do
        local option = canvas:Add("DButton")
        styleOption(combo, menu, option, choice.index, choice.label, optionHeight)
    end

    canvas:SetTall(totalHeight)
    canvas:InvalidateLayout(true)
    overlay:MakePopup()
    overlay:SetKeyboardInputEnabled(false)
    overlay:SetZPos(32767)
    overlay:MoveToFront()
    combo:OnMenuOpened(overlay)
    timer.Simple(0, function()
        if not IsValid(combo) then return end
        if not IsValid(overlay) then return end
        if combo.Menu ~= overlay then return end
        menu.scrollPanel:InvalidateLayout(true)
        themeScrollBar(menu.scrollPanel)
        bindMenuWheel(menu.scrollPanel:GetCanvas(), menu)
        overlay:SetZPos(32767)
        overlay:MoveToFront()
    end)
end

function PANEL:Init()
    self.BaseClass.Init(self)
    self._liliaCustomCombo = true
    self._choiceTooltips = {}
    self._displayText = ""
    self._placeholder = ""
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(false)
    self:SetFont("LiliaFont.18")
    self:SetTall(optionHeight)
    self:SetTextColor(transparent)
    self:SetSortItems(false)
    hideNativeControls(self)
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)
    hideNativeControls(self)
end

function PANEL:Think()
    self.BaseClass.Think(self)
    self:SetTextColor(transparent)
    hideNativeControls(self)
end

function PANEL:OnRemove()
    self:CloseMenu()
    if isfunction(self.BaseClass.OnRemove) then self.BaseClass.OnRemove(self) end
end

function PANEL:Paint(w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local selectedId = self:GetSelectedID()
    local open = self:IsMenuOpen()
    local text = tostring(self:GetSelectedText() or self._displayText or "")
    local textX = 12
    drawPanel(0, 0, w, h, 5, Color(accent.r, accent.g, accent.b, 30), Color(accent.r, accent.g, accent.b, open and 160 or 135))
    if selectedId and self.ChoiceIcons and self.ChoiceIcons[selectedId] then
        local icon = self.ChoiceIcons[selectedId]
        local material = Material(icon)
        if material and material:IsValid() then
            local size = 16
            surface.SetMaterial(material)
            surface.SetDrawColor(accent)
            surface.DrawTexturedRect(12, math.floor((h - size) * 0.5), size, size)
            textX = 34
        end
    end

    if text ~= "" then draw.SimpleText(text, self:GetFont() or "LiliaFont.18", textX, h * 0.5, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
    return true
end

function PANEL:OpenMenu()
    openComboMenu(self)
end

function PANEL:CloseMenu()
    if IsValid(self.Menu) then self.Menu:Remove() end
    self.Menu = nil
end

function PANEL:SetValue(value)
    self._displayText = tostring(value or "")
    local result = self.BaseClass.SetValue(self, value)
    self:SetTextColor(transparent)
    hideNativeControls(self)
    return result
end

function PANEL:ChooseOption(value, index)
    self._displayText = tostring(value or "")
    self.BaseClass.ChooseOption(self, value, index)
    self:SetTextColor(transparent)
    hideNativeControls(self)
end

function PANEL:ChooseOptionID(index)
    local value = self.Choices and self.Choices[index] or nil
    self._displayText = tostring(value or "")
    self.BaseClass.ChooseOptionID(self, index)
    self:SetTextColor(transparent)
    hideNativeControls(self)
end

function PANEL:AddChoice(value, data, selectOrTooltip, iconOrSelect, icon)
    local select = false
    local tooltip
    local choiceIcon
    if isbool(selectOrTooltip) then
        select = selectOrTooltip
        choiceIcon = isstring(iconOrSelect) and iconOrSelect or nil
    else
        tooltip = isstring(selectOrTooltip) and selectOrTooltip or nil
        select = isbool(iconOrSelect) and iconOrSelect or false
        choiceIcon = isstring(icon) and icon or nil
    end

    local index = self.BaseClass.AddChoice(self, value, data, false, choiceIcon)
    self._choiceTooltips[index] = tooltip
    if select then self:ChooseOption(value, index) end
    return index
end

function PANEL:AddSpacer()
    self.BaseClass.AddSpacer(self)
end

function PANEL:SetPlaceholder(text)
    self._placeholder = tostring(text or "")
    if self:GetSelectedID() == nil and self:GetValue() == "" then self:SetValue(self._placeholder) end
end

function PANEL:GetPlaceholder()
    return self._placeholder or ""
end

function PANEL:ChooseOptionData(data)
    for index = 1, #(self.Choices or {}) do
        if self.Data[index] == data then
            self:ChooseOptionID(index)
            return
        end
    end
end

function PANEL:GetSelectedData()
    local id = self:GetSelectedID()
    return id and self:GetOptionData(id) or nil
end

function PANEL:GetSelectedText()
    return self:GetSelected()
end

function PANEL:RefreshDropdown()
    if self:IsMenuOpen() then
        self:CloseMenu()
        self:OpenMenu()
    end
end

function PANEL:AutoSize()
    self:SetTall(optionHeight)
end

function PANEL:FinishAddingOptions()
    self:RefreshDropdown()
end

function PANEL:RecalculateSize()
    self:AutoSize()
end

function PANEL:PostInit()
end

vgui.Register("liaComboBox", PANEL, "DComboBox")