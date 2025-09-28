local PANEL = {}
function PANEL:Init()
    self.text = ''
    self.description = ''
    self.convar = ''
    self.value = false
    self.hoverAnim = 0
    self.circleAnim = 0
    self:SetText('')
    self:SetCursor('hand')
    self:SetTall(32)
    self.toggle = vgui.Create('DButton', self)
    self.toggle:Dock(RIGHT)
    self.toggle:SetWide(48)
    self.toggle:DockMargin(0, 0, 8, 0)
    self.toggle:SetText('')
    self.toggle:SetCursor('hand')
    self.toggle.Paint = function(_, w, h)
        if self.toggle:IsHovered() then
            self.hoverAnim = math.Clamp(self.hoverAnim + FrameTime() * 6, 0, 1)
        else
            self.hoverAnim = math.Clamp(self.hoverAnim - FrameTime() * 10, 0, 1)
        end

        self.circleAnim = Lerp(FrameTime() * 12, self.circleAnim, self.value and 1 or 0)
        local trackH = 20
        local trackY = (h - trackH) / 2
        lia.rndx.Rect(0, trackY, w, trackH):Rad(16):Color(lia.color.theme.button):Shape(lia.rndx.SHAPE_IOS):Draw()
        if self.hoverAnim > 0 then lia.rndx.Rect(0, trackY, w, trackH):Rad(16):Color(Color(lia.color.theme.button_hovered.r, lia.color.theme.button_hovered.g, lia.color.theme.button_hovered.b, self.hoverAnim * 80)):Shape(lia.rndx.SHAPE_IOS):Draw() end
        local circleSize = 16
        local pad = trackY + (trackH - circleSize) / 2
        local x0 = pad
        local x1 = w - circleSize - pad
        local circleX = Lerp(self.circleAnim, x0, x1)
        local circleCol = self.value and lia.color.theme.theme or lia.color.theme.gray
        lia.rndx.Circle(circleX + circleSize / 2, h / 2, circleSize):Color(circleCol):Draw()
    end

    self.toggle.DoClick = function()
        if self.convar ~= '' then LocalPlayer():ConCommand(self.convar .. ' ' .. (self.value and 0 or 1)) end
        self.value = not self.value
        self:OnChange(self.value)
        surface.PlaySound('mantle/btn_click.ogg')
    end
end

function PANEL:SetTxt(text)
    self.text = text
end

function PANEL:SetValue(val)
    self.value = val
end

function PANEL:GetBool()
    return self.value
end

function PANEL:SetConvar(convar)
    self.value = GetConVar(convar):GetBool()
    self.convar = convar
end

function PANEL:SetDescription(desc)
    self.description = desc
    self:SetTooltip(desc)
    self:SetTooltipDelay(1.5)
end

function PANEL:OnChange(new_value)
    -- Clear
end

function PANEL:Paint(w, h)
    lia.rndx.Rect(0, 0, w, h):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.rndx.SHAPE_IOS):Shadow(5, 20):Draw()
    lia.rndx.Rect(0, 0, w, h):Rad(16):Color(lia.color.theme.focus_panel):Shape(lia.rndx.SHAPE_IOS):Draw()
    draw.SimpleText(self.text, 'Fated.18', 12, h * 0.5, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    if self.description ~= '' and self:GetTall() > 32 then draw.SimpleText(self.description, 'Fated.16', 12, h - 6, lia.color.theme.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM) end
end

function PANEL:DoClick()
    if self.description == '' then return end
    if self:GetTall() == 32 then
        self:SetTall(48)
    else
        self:SetTall(32)
    end
end

function PANEL:PerformLayout(w, h)
    self.toggle:SetWide(48)
    self.toggle:DockMargin(0, 0, 8, 0)
end

vgui.Register('liaNewCheckBox', PANEL, 'Panel')