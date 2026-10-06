if SERVER then return end

local function hasStartingAttributes()
    for _, attribute in pairs(lia.attribs.list or {}) do
        if not attribute.noStartBonus then return true end
    end
    return false
end

local function getStartingMax(key, attribute)
    local maximum = hook.Run("GetAttributeStartingMax", LocalPlayer(), key)
    if maximum == nil and attribute then maximum = attribute.startingMax end
    return tonumber(maximum)
end

local function styleRow(row, key, attribute)
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

    local maximum = getStartingMax(key, attribute)
    local description = tostring(attribute and attribute.desc or "No Description")
    row:SetTooltip(description .. (maximum and " Max: " .. maximum or ""))
end

local PANEL = {}
PANEL.creationOrder = 40
PANEL.creationName = "Attributes"
PANEL.creationWorldPreview = true

function PANEL:Init()
    self.title:SetFont("LiliaFont.30")
    self.title:SetText("ATTRIBUTES")
    self.title:SetTall(40)
    self.leftLabel:SetFont("LiliaFont.20")
    self.leftLabel:SetTextColor(lia.color.theme.theme)
    self.leftLabel:SetTall(38)
    for key, row in pairs(self.attribs or {}) do
        if IsValid(row) then styleRow(row, key, lia.attribs.list[key]) end
    end
end

function PANEL:addAttribute(key, attribute)
    local row = self.BaseClass.addAttribute(self, key, attribute)
    if IsValid(row) then styleRow(row, key, attribute) end
    return row
end

function PANEL:onPointChange(key, delta)
    local attribute = lia.attribs.list and lia.attribs.list[key]
    if not attribute then return 0 end
    local client = LocalPlayer()
    self.total = hook.Run("GetMaxStartingAttributePoints", client, lia.config.get("StartingAttributePoints", 30)) or 0
    local attribs = self:getContext("attribs", {})
    local spent = 0
    for _, quantity in pairs(attribs) do
        spent = spent + (tonumber(quantity) or 0)
    end

    local quantity = tonumber(attribs[key]) or 0
    local nextQuantity = quantity + delta
    local nextSpent = spent + delta
    local maximum = getStartingMax(key, attribute)
    if nextQuantity < 0 or nextSpent < 0 or nextSpent > self.total or maximum and nextQuantity > maximum then return quantity end
    attribs[key] = nextQuantity
    self:setContext("attribs", attribs)
    self.left = math.max(self.total - nextSpent, 0)
    self:updatePointsLeft()
    return nextQuantity
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
