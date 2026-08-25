local PANEL = {}
local function drawPanel(x, y, w, h, radius, background, outline)
    lia.derma.rect(x, y, w, h):Rad(radius):Color(background):Shape(lia.derma.SHAPE_IOS):Draw()
    if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
end

function PANEL:Init()
    self._text = "Button"
    self._hover = 0
    self._secondary = false
    self._customColor = nil
    self._customHoverColor = nil
    self._customTextColor = nil
    self.bool_hover = true
    self.font = "LiliaFont.18"
    self.radius = 6
    self.icon = nil
    self.icon_size = 16
    self.text_align = TEXT_ALIGN_CENTER
    self.text_padding = 14
    self.Selected = false
    self.ShowLine = false
    self.bool_gradient = false
    self.enable_ripple = false
    self.BaseClass.SetText(self, "")
end

function PANEL:SetHover(enabled)
    self.bool_hover = tobool(enabled)
end

function PANEL:SetFont(font)
    self.font = tostring(font or "LiliaFont.18")
end

function PANEL:SetRadius(radius)
    self.radius = tonumber(radius) or 6
end

function PANEL:SetSecondary(secondary)
    self._secondary = tobool(secondary)
end

function PANEL:GetSecondary()
    return self._secondary or false
end

function PANEL:SetIcon(icon, iconSize)
    if not icon or icon == "" then
        self.icon = nil
    elseif type(icon) == "IMaterial" then
        self.icon = icon
    else
        local material = Material(icon)
        self.icon = material and material:IsValid() and material or nil
    end

    self.icon_size = tonumber(iconSize) or 16
end

function PANEL:SetTxt(text)
    self._text = tostring(text or "")
end

function PANEL:SetTextAlign(align)
    self.text_align = align or TEXT_ALIGN_CENTER
end

function PANEL:SetTextPadding(padding)
    self.text_padding = math.max(tonumber(padding) or 0, 0)
end

function PANEL:SetText(text)
    self:SetTxt(text)
    self.BaseClass.SetText(self, "")
end

function PANEL:GetText()
    return self._text or ""
end

function PANEL:SetColor(color)
    self._customColor = IsColor(color) and color or nil
end

function PANEL:SetColorHover(color)
    self._customHoverColor = IsColor(color) and color or nil
end

function PANEL:SetTextColor(color)
    self._customTextColor = IsColor(color) and color or nil
end

function PANEL:GetTextColor()
    return self._customTextColor or lia.color.theme.text
end

function PANEL:PaintButton(baseColor, hoverColor)
    self:SetColor(baseColor)
    if IsColor(hoverColor) then
        self:SetColorHover(hoverColor)
    elseif IsColor(baseColor) then
        self:SetColorHover(Color(math.min(baseColor.r + 30, 255), math.min(baseColor.g + 30, 255), math.min(baseColor.b + 30, 255), baseColor.a or 255))
    else
        self:SetColorHover(nil)
    end
end

function PANEL:SetGradient(enabled)
    self.bool_gradient = tobool(enabled)
end

function PANEL:SetRipple(enabled)
    self.enable_ripple = tobool(enabled)
end

function PANEL:SetSelected(state)
    self.Selected = tobool(state)
end

function PANEL:IsSelected()
    return self.Selected or false
end

function PANEL:SetShowLine(show)
    self.ShowLine = tobool(show)
end

function PANEL:GetShowLine()
    return self.ShowLine or false
end

function PANEL:OnMousePressed(mouseCode)
    self.BaseClass.OnMousePressed(self, mouseCode)
    if self.enable_ripple and mouseCode == MOUSE_LEFT then
        self.click_alpha = 1
        self.click_x, self.click_y = self:CursorPos()
    end
end

function PANEL:DoClick()
    if lia and lia.websound and isfunction(lia.websound.playButtonSound) then lia.websound.playButtonSound() end
    self.BaseClass.DoClick(self)
end

function PANEL:Think()
    local target = self.bool_hover and self:IsHovered() and self:IsEnabled() and 1 or 0
    self._hover = Lerp(FrameTime() * 12, self._hover or 0, target)
end

function PANEL:Paint(w, h)
    local hover = self._hover or 0
    local accent = self._secondary and (lia.color.theme.negative or lia.color.theme.accent or lia.color.theme.maincolor) or lia.color.theme.accent or lia.color.theme.maincolor
    local background
    local outline
    if self._customColor then
        local hoverColor = self._customHoverColor or self._customColor
        background = Color(math.Round(Lerp(hover, self._customColor.r, hoverColor.r)), math.Round(Lerp(hover, self._customColor.g, hoverColor.g)), math.Round(Lerp(hover, self._customColor.b, hoverColor.b)), math.Round(Lerp(hover, self._customColor.a or 255, hoverColor.a or 255)))
        outline = Color(accent.r, accent.g, accent.b, 75 + hover * 100)
    else
        background = Color(accent.r, accent.g, accent.b, self._secondary and 18 + hover * 16 or 25 + hover * 26)
        outline = Color(accent.r, accent.g, accent.b, 75 + hover * 100)
    end

    if not self:IsEnabled() then
        background = lia.color.theme.background
        outline = lia.color.theme.text
    end

    drawPanel(0, 0, w, h, self.radius or 6, background, outline)
    if self.Selected and self.ShowLine then
        surface.SetDrawColor(accent.r, accent.g, accent.b, 240)
        surface.DrawRect(0, 7, 3, math.max(h - 14, 1))
    end

    local textColor = self:IsEnabled() and (self._customTextColor or lia.color.theme.text) or lia.color.theme.text
    local iconSize = self.icon_size or 16
    local text = self._text or ""
    if text ~= "" then
        local align = self.text_align or TEXT_ALIGN_CENTER
        local padding = self.text_padding or 14
        local textX
        local iconX
        if align == TEXT_ALIGN_LEFT then
            iconX = padding
            textX = padding + (self.icon and iconSize + 8 or 0)
        elseif align == TEXT_ALIGN_RIGHT then
            iconX = w - padding - iconSize
            textX = w - padding - (self.icon and iconSize + 8 or 0)
        else
            textX = w * 0.5 + (self.icon and iconSize * 0.5 + 2 or 0)
            if self.icon then
                surface.SetFont(self.font or "LiliaFont.18")
                local textWidth = surface.GetTextSize(text)
                iconX = (w - textWidth - iconSize) * 0.5 - 2
            end
        end

        draw.SimpleText(text, self.font or "LiliaFont.18", textX, h * 0.5, textColor, align, TEXT_ALIGN_CENTER)
        if self.icon then
            local posY = (h - iconSize) * 0.5
            surface.SetMaterial(self.icon)
            surface.SetDrawColor(self:IsEnabled() and textColor or lia.color.theme.text)
            surface.DrawTexturedRect(iconX or padding, posY, iconSize, iconSize)
        end
    elseif self.icon then
        local posX = (w - iconSize) * 0.5
        local posY = (h - iconSize) * 0.5
        surface.SetMaterial(self.icon)
        surface.SetDrawColor(self:IsEnabled() and textColor or lia.color.theme.text)
        surface.DrawTexturedRect(posX, posY, iconSize, iconSize)
    end
end

vgui.Register("liaButton", PANEL, "Button")
