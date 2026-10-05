if SERVER then return end

local function hasStartingAttributes()
    for _, attribute in pairs(lia.attribs.list or {}) do
        if not attribute.noStartBonus then return true end
    end
    return false
end

local function styleRow(row)
    row:SetTall(54)
    row:DockMargin(0, 0, 0, 8)
    row.Paint = function(panel, w, h)
        local accent = lia.color.theme.theme
        lia.derma.rect(0, 0, w, h):Rad(8):Color(Color(20, 25, 32, 238)):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(0, 0, w, h):Rad(8):Color(Color(accent.r, accent.g, accent.b, panel:IsHovered() and 115 or 48)):Outline(1):Draw()
    end

    if IsValid(row.name) then
        row.name:SetFont("LiliaFont.20")
        row.name:SetTextColor(lia.color.theme.text or color_white)
        row.name:DockMargin(14, 0, 0, 0)
    end

    if IsValid(row.quantity) then
        row.quantity:SetFont("LiliaFont.22")
        row.quantity:SetTextColor(lia.color.theme.text or color_white)
    end
end

local PANEL = {}
PANEL.creationOrder = 40
PANEL.creationName = "Attributes"

function PANEL:Init()
    self.title:SetFont("LiliaFont.30")
    self.title:SetText("ATTRIBUTES")
    self.title:SetTall(40)
    self.leftLabel:SetFont("LiliaFont.20")
    self.leftLabel:SetTextColor(lia.color.theme.theme)
    self.leftLabel:SetTall(38)
    for _, row in pairs(self.attribs or {}) do
        if IsValid(row) then styleRow(row) end
    end
end

function PANEL:addAttribute(key, attribute)
    local row = self.BaseClass.addAttribute(self, key, attribute)
    if IsValid(row) then styleRow(row) end
    return row
end

function PANEL:shouldSkip()
    return not hasStartingAttributes()
end

function PANEL:validate()
    local ok, reason, detail = self:validateCharVar("attribs")
    if ok == false then return false, reason or detail or "Invalid attribute allocation." end
    return true
end

hook.Add("ConfigureCharacterCreationSteps", "liaCharacterCreationAttributesStep", function(creator)
    if not vgui.GetControlTable("liaCharacterAttributesPage") then vgui.Register("liaCharacterAttributesPage", PANEL, "liaCharacterAttribs") end
    creator:addStep(vgui.Create("liaCharacterAttributesPage"))
end)
