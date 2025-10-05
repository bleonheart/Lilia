local PANEL = {}
function PANEL:Init()
    self._activeShadowTimer = 0
    self._activeShadowMinTime = 0.03 -- L("minDuration")
    self._activeShadowLerp = 0
    self.hover_status = 0
    self.bool_hover = true
    self.font = "Fated.18"
    self.radius = 16
    self.icon = ""
    self.icon_size = 16
    self.text = L("button")
    self.col = lia.color.theme.button
    self.col_hov = lia.color.theme.button_hovered
    self.bool_gradient = true
    self.click_alpha = 0
    self.click_x = 0
    self.click_y = 0
    self.ripple_speed = 4
    self.enable_ripple = false
    self.ripple_color = Color(255, 255, 255, 30)
    self.BaseClass.SetText(self, "")
end

function PANEL:SetHover(is_hover)
    self.bool_hover = is_hover
end

function PANEL:SetFont(font)
    self.font = font
end

function PANEL:SetRadius(rad)
    self.radius = rad
end

function PANEL:SetIcon(icon, icon_size)
    self.icon = type(icon) == 'IMaterial' and icon or Material(icon)
    self.icon_size = icon_size or 16
end

function PANEL:SetTxt(text)
    self.text = text or ""
end

function PANEL:SetText(text)
    self:SetTxt(text)
    self.BaseClass.SetText(self, "")
end

function PANEL:GetText()
    return self.text
end

function PANEL:SetColor(col)
    self.col = col
end

function PANEL:SetColorHover(col)
    self.col_hov = col
end

function PANEL:SetGradient(is_grad)
    self.bool_gradient = is_grad
end

function PANEL:SetRipple(enable)
    self.enable_ripple = enable
end

function PANEL:OnMousePressed(mousecode)
    self.BaseClass.OnMousePressed(self, mousecode)
    if self.enable_ripple and mousecode == MOUSE_LEFT then
        self.click_alpha = 1
        self.click_x, self.click_y = self:CursorPos()
    end
end

local math_clamp = math.Clamp
local btnFlags = lia.derma.SHAPE_IOS
function PANEL:Paint(w, h)
    if self:IsHovered() then
        self.hover_status = math_clamp(self.hover_status + 4 * FrameTime(), 0, 1)
    else
        self.hover_status = math_clamp(self.hover_status - 8 * FrameTime(), 0, 1)
    end

    local isActive = (self:IsDown() or self.Depressed) and self.hover_status > 0.8
    if isActive then self._activeShadowTimer = SysTime() + self._activeShadowMinTime end
    local showActiveShadow = isActive or (self._activeShadowTimer > SysTime())
    local activeTarget = showActiveShadow and 10 or 0
    local activeSpeed = (activeTarget > 0) and 7 or 3 -- L("fadeSpeed")
    self._activeShadowLerp = Lerp(FrameTime() * activeSpeed, self._activeShadowLerp, activeTarget)
    if self._activeShadowLerp > 0 then
        local col = Color(self.col_hov.r, self.col_hov.g, self.col_hov.b, math.Clamp(self.col_hov.a * 1.5, 0, 255))
        lia.derma.rect(0, 0, w, h):Rad(self.radius):Color(col):Shape(btnFlags):Shadow(self._activeShadowLerp * 1.5, 24):Draw()
    end

    lia.derma.rect(0, 0, w, h):Rad(self.radius):Color(self.col):Shape(btnFlags):Draw()
    if self.bool_gradient then lia.util.drawGradient(0, 0, w, h, 1, lia.color.theme.button_shadow, self.radius, btnFlags) end
    if self.bool_hover then lia.derma.rect(0, 0, w, h):Rad(self.radius):Color(Color(self.col_hov.r, self.col_hov.g, self.col_hov.b, self.hover_status * 255)):Shape(btnFlags):Draw() end
    if self.click_alpha > 0 then
        self.click_alpha = math_clamp(self.click_alpha - FrameTime() * self.ripple_speed, 0, 1)
        local ripple_size = (1 - self.click_alpha) * math.max(w, h) * 2
        local ripple_color = Color(self.ripple_color.r, self.ripple_color.g, self.ripple_color.b, self.ripple_color.a * self.click_alpha)
        lia.derma.rect(self.click_x - ripple_size * 0.5, self.click_y - ripple_size * 0.5, ripple_size, ripple_size):Rad(100):Color(ripple_color):Shape(btnFlags):Draw()
    end

    -- Ensure icon_size is never nil
    local iconSize = self.icon_size or 16
    if self.text ~= "" then
        draw.SimpleText(self.text, self.font, w * 0.5 + (self.icon ~= "" and iconSize * 0.5 + 2 or 0), h * 0.5, lia.color.theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if self.icon ~= "" then
            surface.SetFont(self.font)
            local posX = (w - surface.GetTextSize(self.text) - iconSize) * 0.5 - 2
            local posY = (h - iconSize) * 0.5
            lia.derma.rect(posX, posY, iconSize, iconSize):Material(self.icon):Color(color_white):Shape(btnFlags):Draw()
        end
    elseif self.icon ~= "" then
        local posX = (w - iconSize) * 0.5
        local posY = (h - iconSize) * 0.5
        lia.derma.rect(posX, posY, iconSize, iconSize):Material(self.icon):Color(color_white):Shape(btnFlags):Draw()
    end
end

vgui.Register("liaButton", PANEL, "Button")
