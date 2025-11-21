local PANEL = {}
function PANEL:Init()
    self.StartTime = CurTime()
    self.EndTime = self.StartTime + 5
    self.Text = L("actionInProgress")
    self.BarColor = lia.config.get("Color")
    self.Fraction = 0
    self.GradientMat = lia.util.getMaterial("vgui/gradient-d")
    self.Font = "LiliaFont.17"
end

function PANEL:GetFraction()
    return self.Fraction or 0
end

function PANEL:SetFraction(fraction)
    self.Fraction = fraction or 0
end

function PANEL:SetProgress(startTime, endTime)
    self.StartTime = startTime or CurTime()
    self.EndTime = endTime or self.StartTime + 5
end

function PANEL:SetText(text)
    self.Text = text or ""
end

function PANEL:SetBarColor(color)
    self.BarColor = color or self.BarColor
end

function PANEL:Paint(w, h)
    local frac = math.Clamp(self.Fraction, 0, 1)
    local fillWidth = (w - 16) * frac
    lia.derma.rect(0, 0, w, h):Rad(12):Color(lia.color.theme.panel and lia.color.theme.panel[1] or Color(35, 35, 35, 150)):Draw()
    lia.derma.rect(0, 0, w, h):Rad(12):Color(lia.color.theme.window_shadow or Color(0, 0, 0, 30)):Shadow(2, 8):Draw()
    lia.derma.rect(8, h - 20, w - 16, 12):Rad(6):Color(lia.color.theme.panel and lia.color.theme.panel[2] or Color(20, 20, 20, 120)):Draw()
    if fillWidth > 0 then
        lia.derma.rect(8, h - 20, fillWidth, 12):Rad(6):Color(self.BarColor):Draw()
        if self.GradientMat then lia.derma.rect(8, h - 20, fillWidth, 12):Rad(6):Material(self.GradientMat):Color(Color(255, 255, 255, 25)):Draw() end
    end

    local cx, cy = w * 0.5, h - 14
    draw.SimpleText(self.Text, self.Font, cx + 1, cy + 1, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.Text, self.Font, cx, cy, lia.color.theme.text or Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("liaDProgressBar", PANEL, "DPanel")
