local animDuration = 0.3
local function PaintButton(self, w, h)
    -- Get color from config with fallback
    local colorTable = lia.config.get("Color")
    local r = (colorTable and colorTable.r) or 255
    local g = (colorTable and colorTable.g) or 255
    local b = (colorTable and colorTable.b) or 255
    local cornerRadius = 8

    if self.Base then
        -- Draw shadow/background
        lia.derma.rect(0, 0, w, h):Rad(cornerRadius):Color(Color(0, 0, 0, 150)):Shape(lia.derma.SHAPE_IOS):Draw()
        -- Draw main background
        lia.derma.rect(0, 0, w, h):Rad(cornerRadius):Color(Color(0, 0, 0, 100)):Shape(lia.derma.SHAPE_IOS):Draw()
    end

    -- Draw text
    draw.SimpleText(self:GetText(), self:GetFont(), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Draw hover/selected effects
    if self:IsHovered() or self:IsSelected() then
        self.startTime = self.startTime or CurTime()
        local elapsed = CurTime() - self.startTime
        local anim = math.min(w, elapsed / animDuration * w) / 2

        -- Draw hover overlay with subtle shadow effect
        lia.derma.rect(0, 0, w, h):Rad(cornerRadius):Color(Color(0, 0, 0, 30)):Shape(lia.derma.SHAPE_IOS):Shadow(2, 8):Draw()
        lia.derma.rect(0, 0, w, h):Rad(cornerRadius):Color(Color(r, g, b, 40)):Shape(lia.derma.SHAPE_IOS):Draw()

        -- Draw animated underline that grows from center
        if anim > 0 then
            local lineWidth = math.min(w - cornerRadius * 2, anim * 2)
            local lineX = (w - lineWidth) / 2
            lia.derma.rect(lineX, h - 3, lineWidth, 2):Rad(1):Color(Color(r, g, b)):Draw()
        end
    else
        self.startTime = nil
    end
    return true
end

local function RegisterButton(name, defaultFont, useBase)
    local PANEL = {}
    PANEL.DefaultFont = defaultFont or name:match("lia(%w+)Button") .. "Font"
    PANEL.Base = useBase
    function PANEL:Init()
        self:SetFont(self.DefaultFont)
        self.Selected = false
    end

    function PANEL:SetFont(font)
        self.ButtonFont = font
    end

    function PANEL:GetFont()
        return self.ButtonFont
    end

    function PANEL:SetSelected(state)
        self.Selected = state
    end

    function PANEL:IsSelected()
        return self.Selected
    end

    function PANEL:Paint(w, h)
        return PaintButton(self, w, h)
    end

    vgui.Register(name, PANEL, "DButton")
end

RegisterButton("liaHugeButton", "liaHugeFont", true)
RegisterButton("liaBigButton", "liaBigFont", true)
RegisterButton("liaMediumButton", "liaMediumFont", true)
RegisterButton("liaSmallButton", "liaSmallFont", true)
RegisterButton("liaMiniButton", "liaMiniFont", true)
RegisterButton("liaNoBGButton", "liaBigFont", false)
