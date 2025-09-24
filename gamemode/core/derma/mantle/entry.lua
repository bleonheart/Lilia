local PANEL = {}
function PANEL:Init()
    self.placeholder = ""
    self.placeholderColor = Color(128, 128, 128)
end

function PANEL:Paint(w, h)
    if self:GetText() == "" and self.placeholder ~= "" then
        draw.SimpleText(self.placeholder, self:GetFont(), 5, h / 2, self.placeholderColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    self.BaseClass:Paint(w, h)
end

function PANEL:SetPlaceholderText(text)
    self.placeholder = text
    self:InvalidateLayout()
end

function PANEL:GetPlaceholderText()
    return self.placeholder
end

function PANEL:SetPlaceholderColor(color)
    self.placeholderColor = color
end

function PANEL:GetPlaceholderColor()
    return self.placeholderColor
end

vgui.Register('MantleEntry', PANEL, 'DTextEntry')