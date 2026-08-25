local function isColorLike(value)
    return istable(value) and isnumber(value.r) and isnumber(value.g) and isnumber(value.b)
end

local function withAlpha(color, alpha)
    return Color(color.r, color.g, color.b, alpha)
end

local function getThemeColor(value, fallback)
    if isColorLike(value) then return value end
    return fallback
end

local function getEntryPalette()
    local theme = lia.color and lia.color.theme or {}
    local accent = getThemeColor(theme.accent or theme.theme or theme.header, Color(60, 140, 140))
    local text = getThemeColor(theme.text, Color(225, 236, 236))
    local muted = getThemeColor(theme.text_entry or theme.gray, Color(155, 181, 182))
    local panel = nil
    if isColorLike(theme.backgroundPanelPopup) then
        panel = theme.backgroundPanelPopup
    elseif isColorLike(theme.background_panelpopup) then
        panel = theme.background_panelpopup
    elseif istable(theme.panel) and isColorLike(theme.panel[1]) then
        panel = theme.panel[1]
    elseif isColorLike(theme.background) then
        panel = theme.background
    end

    panel = panel and Color(panel.r, panel.g, panel.b, 235) or Color(5, 18, 23, 235)
    return {
        accent = accent,
        text = text,
        muted = muted,
        panel = panel,
        outline = withAlpha(accent, 92),
        outlineFocus = withAlpha(accent, 210),
        placeholder = Color(muted.r, muted.g, muted.b, 150),
        icon = Color(muted.r, muted.g, muted.b, 210),
        title = getThemeColor(theme.text, Color(210, 230, 230))
    }
end

local PANEL = {}
function PANEL:Init()
    self.title = nil
    self.placeholder = "Enter Text"
    self.font = "LiliaFont.18"
    self.textColor = nil
    self.placeholderColor = nil
    self.cursorColor = nil
    self.highlightColor = nil
    self.action = function() end
    self.leftIcon = nil
    self.leftIconSize = 16
    self.radius = 5
    self.centerText = false
    self:SetTall(40)
    self.textEntry = self:Add("DTextEntry")
    self.textEntry:Dock(FILL)
    self.textEntry:SetText("")
    self.textEntry:SetFont(self.font)
    self.textEntry:SetPaintBackground(false)
    self.textEntry:SetDrawBorder(false)
    if self.textEntry.SetPaintBorderEnabled then self.textEntry:SetPaintBorderEnabled(false) end
    self.textEntry.OnEnter = function() self.action(self:GetValue()) end
    self.textEntry.OnLoseFocus = function() self.action(self:GetValue()) end
    self.textEntry.OnValueChange = function(_, value) if self.OnValueChange then self:OnValueChange(value) end end
    self.textEntry.OnTextChanged = function()
        local value = self:GetValue() or ""
        if self.OnTextChanged then self:OnTextChanged(value) end
    end

    self.textEntry.Paint = function(s, w, h) self:PaintTextEntry(s, w, h) end
    self:ApplyTheme()
    self:UpdateTextMargin()
end

function PANEL:ApplyTheme()
    local palette = getEntryPalette()
    self.textColor = self.textColor or palette.text
    self.placeholderColor = self.placeholderColor or palette.placeholder
    self.cursorColor = self.cursorColor or palette.accent
    self.highlightColor = self.highlightColor or withAlpha(palette.accent, 60)
    self.textEntry:SetTextColor(self.textColor)
    self.textEntry:SetCursorColor(self.cursorColor)
    if self.textEntry.SetHighlightColor then self.textEntry:SetHighlightColor(self.highlightColor) end
end

function PANEL:UpdateTextMargin()
    if not IsValid(self.textEntry) then return end
    local left = self.leftIcon and 42 or 12
    self.textEntry:DockMargin(left, 0, 12, 0)
end

function PANEL:Paint(w, h)
    local palette = getEntryPalette()
    local focused = IsValid(self.textEntry) and (self.textEntry:HasFocus() or self.textEntry:IsEditing())
    local hovered = self:IsHovered() or IsValid(self.textEntry) and self.textEntry:IsHovered()
    self._focusFrac = Lerp(FrameTime() * 12, self._focusFrac or 0, focused and 1 or 0)
    self._hoverFrac = Lerp(FrameTime() * 12, self._hoverFrac or 0, hovered and 1 or 0)
    local outlineAlpha = Lerp(math.max(self._focusFrac, self._hoverFrac * 0.5), palette.outline.a, palette.outlineFocus.a)
    local outline = Color(palette.accent.r, palette.accent.g, palette.accent.b, outlineAlpha)
    lia.derma.rect(0, 0, w, h):Rad(self.radius):Color(palette.panel):Shape(lia.derma.SHAPE_IOS):Draw()
    lia.derma.rect(0, 0, w, h):Rad(self.radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
    if self.leftIcon and not self.leftIcon:IsError() then
        surface.SetMaterial(self.leftIcon)
        surface.SetDrawColor(palette.icon)
        surface.DrawTexturedRect(14, math.floor((h - self.leftIconSize) * 0.5), self.leftIconSize, self.leftIconSize)
    end
end

function PANEL:PaintTextEntry(entry, w, h)
    local palette = getEntryPalette()
    local value = entry:GetText() or ""
    local font = self.font or "LiliaFont.18"
    local textColor = self.textColor or palette.text
    local placeholderColor = self.placeholderColor or palette.placeholder
    local highlightColor = self.highlightColor or withAlpha(palette.accent, 60)
    local cursorColor = self.cursorColor or palette.accent
    local focused = entry:HasFocus() or entry:IsEditing()
    if self.centerText then
        surface.SetFont(font)
        if value == "" then
            if not focused then draw.SimpleText(self.placeholder or "", font, w * 0.5, h * 0.5, placeholderColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        else
            draw.SimpleText(value, font, w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        return
    end

    if value == "" and not focused then draw.SimpleText(self.placeholder or "", font, 0, h * 0.5, placeholderColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
    entry:DrawTextEntryText(textColor, highlightColor, cursorColor)
end

function PANEL:SetTitle(title)
    if title == nil or tostring(title) == "" then
        self.title = nil
        if IsValid(self.titlePanel) then self.titlePanel:Remove() end
        return
    end

    self.title = tostring(title)
    self:SetTall(62)
    if IsValid(self.titlePanel) then self.titlePanel:Remove() end
    self.titlePanel = self:Add("DPanel")
    self.titlePanel:Dock(TOP)
    self.titlePanel:DockMargin(0, 0, 0, 6)
    self.titlePanel:SetTall(16)
    self.titlePanel.Paint = function(_, w, h) draw.SimpleText(self.title or "", "LiliaFont.16", 0, h * 0.5, getEntryPalette().title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
end

function PANEL:SetPlaceholder(placeholder)
    self.placeholder = placeholder
end

function PANEL:SetPlaceholderText(placeholder)
    self.placeholder = placeholder
end

function PANEL:SetPlaceholderColor(color)
    self.placeholderColor = color
end

function PANEL:SetValue(value)
    self.textEntry:SetText(value or "")
end

function PANEL:SetText(value)
    self:SetValue(value)
end

function PANEL:GetValue()
    return self.textEntry:GetText()
end

function PANEL:SelectAll()
    if self.textEntry.SelectAllText then self.textEntry:SelectAllText(true) end
end

function PANEL:SetFont(font)
    self.font = font
    self.textEntry:SetFont(font)
    self:InvalidateLayout(true)
end

function PANEL:PerformLayout()
    if not IsValid(self.textEntry) then return end
    self.textEntry:SetTextInset(0, 0)
end

function PANEL:SetNumeric(numeric)
    if self.textEntry.SetNumeric then self.textEntry:SetNumeric(numeric) end
end

function PANEL:AllowInput(callback)
    if isfunction(callback) then
        self.textEntry.AllowInput = function(_, char) return callback(self, char) end
    else
        self.textEntry.AllowInput = nil
    end
end

function PANEL:SetTextColor(color)
    self.textColor = color
    if IsValid(self.textEntry) then self.textEntry:SetTextColor(color) end
end

function PANEL:GetTextColor()
    return self.textColor
end

function PANEL:SetCursorColor(color)
    self.cursorColor = color
    if IsValid(self.textEntry) and self.textEntry.SetCursorColor then self.textEntry:SetCursorColor(color) end
end

function PANEL:GetCursorColor()
    return self.cursorColor
end

function PANEL:SetHighlightColor(color)
    self.highlightColor = color
    if IsValid(self.textEntry) and self.textEntry.SetHighlightColor then self.textEntry:SetHighlightColor(color) end
end

function PANEL:GetHighlightColor()
    return self.highlightColor
end

function PANEL:GetPlaceholderText()
    return self.placeholder
end

function PANEL:GetPlaceholderColor()
    return self.placeholderColor
end

function PANEL:SetDisabled(disabled)
    if self.textEntry.SetDisabled then self.textEntry:SetDisabled(disabled) end
end

function PANEL:GetDisabled()
    if self.textEntry.GetDisabled then return self.textEntry:GetDisabled() end
end

function PANEL:SetDrawBorder(drawBorder)
    if self.textEntry.SetDrawBorder then self.textEntry:SetDrawBorder(drawBorder) end
end

function PANEL:GetDrawBorder()
    if self.textEntry.GetDrawBorder then return self.textEntry:GetDrawBorder() end
end

function PANEL:SetEditable(editable)
    if self.textEntry.SetEditable then self.textEntry:SetEditable(editable) end
end

function PANEL:SetEnterAllowed(allowed)
    if self.textEntry.SetEnterAllowed then self.textEntry:SetEnterAllowed(allowed) end
end

function PANEL:GetEnterAllowed()
    if self.textEntry.GetEnterAllowed then return self.textEntry:GetEnterAllowed() end
end

function PANEL:SetHistoryEnabled(enabled)
    if self.textEntry.SetHistoryEnabled then self.textEntry:SetHistoryEnabled(enabled) end
end

function PANEL:GetHistoryEnabled()
    if self.textEntry.GetHistoryEnabled then return self.textEntry:GetHistoryEnabled() end
end

function PANEL:SetTabbingDisabled(disabled)
    if self.textEntry.SetTabbingDisabled then self.textEntry:SetTabbingDisabled(disabled) end
end

function PANEL:GetTabbingDisabled()
    if self.textEntry.GetTabbingDisabled then return self.textEntry:GetTabbingDisabled() end
end

function PANEL:SetUpdateOnType(update)
    if self.textEntry.SetUpdateOnType then self.textEntry:SetUpdateOnType(update) end
end

function PANEL:GetUpdateOnType()
    if self.textEntry.GetUpdateOnType then return self.textEntry:GetUpdateOnType() end
end

function PANEL:SetMultiline(multiline)
    if self.textEntry.SetMultiline then self.textEntry:SetMultiline(multiline) end
end

function PANEL:SetContentAlignment(align)
    if align == TEXT_ALIGN_CENTER or align == 5 then
        self.centerText = true
    else
        self.centerText = false
    end
end

function PANEL:IsEditing()
    if self.textEntry.IsEditing then return self.textEntry:IsEditing() end
    return false
end

function PANEL:OnChange()
    if self.textEntry.OnChange then self.textEntry:OnChange() end
end

function PANEL:OnGetFocus()
    if self.textEntry.OnGetFocus then self.textEntry:OnGetFocus() end
end

function PANEL:OnKeyCode(code)
    if self.textEntry.OnKeyCode then self.textEntry:OnKeyCode(code) end
end

function PANEL:AddHistory(value)
    if self.textEntry.AddHistory then self.textEntry:AddHistory(value) end
end

function PANEL:CheckNumeric()
    if self.textEntry.CheckNumeric then return self.textEntry:CheckNumeric() end
end

function PANEL:OpenAutoComplete()
    if self.textEntry.OpenAutoComplete then self.textEntry:OpenAutoComplete() end
end

function PANEL:UpdateConvarValue()
    if self.textEntry.UpdateConvarValue then self.textEntry:UpdateConvarValue() end
end

function PANEL:UpdateFromHistory()
    if self.textEntry.UpdateFromHistory then self.textEntry:UpdateFromHistory() end
end

function PANEL:UpdateFromMenu()
    if self.textEntry.UpdateFromMenu then self.textEntry:UpdateFromMenu() end
end

function PANEL:SetLeftIcon(icon, size)
    if type(icon) == "IMaterial" then
        self.leftIcon = icon
    elseif isstring(icon) and icon ~= "" then
        self.leftIcon = Material(icon, "smooth")
    else
        self.leftIcon = nil
    end

    if isnumber(size) and size > 0 then self.leftIconSize = size end
    self:UpdateTextMargin()
end

function PANEL:SetIcon(icon, size)
    self:SetLeftIcon(icon, size)
end

vgui.Register("liaEntry", PANEL, "EditablePanel")
