local PANEL = {}
function PANEL:Init()
    local client = LocalPlayer()
    self.title = self:addLabel("attributes")
    self.leftLabel = self:addLabel("pointsLeft")
    self.leftLabel:SetFont("LiliaFont.32")
    self.leftLabel:SetTextColor(color_white)
    self.title:SetTextColor(color_white)
    self.total = hook.Run("GetMaxStartingAttributePoints", client, lia.config.get("StartingAttributePoints", 30))
    self.attribs = {}
    for k, v in SortedPairsByMemberValue(lia.attribs.list, "name") do
        if v.noStartBonus then continue end
        self.attribs[k] = self:addAttribute(k, v)
    end
end

function PANEL:updatePointsLeft()
    self.leftLabel:SetText(L("pointsLeft"):upper() .. ": " .. self.left)
end

function PANEL:onDisplay()
    local client = LocalPlayer()
    self.total = hook.Run("GetMaxStartingAttributePoints", client, lia.config.get("StartingAttributePoints", 30))
    if not self.attribs then self.attribs = {} end
    for k, v in SortedPairsByMemberValue(lia.attribs.list, "name") do
        if v.noStartBonus then continue end
        if not self.attribs[k] then self.attribs[k] = self:addAttribute(k, v) end
    end

    local attribs = self:getContext("attribs", {})
    local sum = 0
    for _, quantity in pairs(attribs) do
        sum = sum + quantity
    end

    self.left = math.max(self.total - sum, 0)
    self:updatePointsLeft()
    for key, row in pairs(self.attribs) do
        row.points = attribs[key] or 0
        row:updateQuantity()
    end
end

function PANEL:addAttribute(key, attribute)
    local row = self:Add("liaCharacterAttribsRow")
    row:setAttribute(key, attribute)
    row.parent = self
    return row
end

function PANEL:onPointChange(key, delta)
    if not key then return 0 end
    local client = LocalPlayer()
    if not self.total or self.total == 0 then self.total = hook.Run("GetMaxStartingAttributePoints", client, lia.config.get("StartingAttributePoints", 30)) end
    local attribs = self:getContext("attribs", {})
    local sum = 0
    for _, quantity in pairs(attribs) do
        sum = sum + quantity
    end

    self.left = math.max(self.total - sum, 0)
    local startingMax = lia.attribs.list[key].startingMax or nil
    local quantity = attribs[key] or 0
    local newQuantity = quantity + delta
    local newPointsLeft = self.left - delta
    if newPointsLeft < 0 or newPointsLeft > self.total or newQuantity < 0 or (startingMax and startingMax < newQuantity) then return quantity end
    self.left = newPointsLeft
    self:updatePointsLeft()
    attribs[key] = newQuantity
    self:setContext("attribs", attribs)
    if IsValid(self.parentBio) and isfunction(self.parentBio.updateAttributesLabel) then self.parentBio:updateAttributesLabel() end
    return newQuantity
end

vgui.Register("liaCharacterAttribs", PANEL, "liaCharacterCreateStep")
PANEL = {}
function PANEL:Init()
    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 4)
    self:SetTall(28)
    self:SetPaintBackground(false)
    self.points = 0
    self.buttons = self:Add("DPanel")
    self.buttons:Dock(RIGHT)
    self.buttons:SetWide(96)
    self.buttons:SetPaintBackground(false)
    self.buttons:SetMouseInputEnabled(true)
    self.sub = self:addButton("⯇", -1)
    self.sub:Dock(LEFT)
    self.quantity = self.buttons:Add("DLabel")
    self.quantity:SetFont("LiliaFont.32")
    self.quantity:SetTextColor(color_white)
    self.quantity:Dock(FILL)
    self.quantity:SetText("0")
    self.quantity:SetContentAlignment(5)
    self.quantity:SetMouseInputEnabled(false)
    self.add = self:addButton("⯈", 1)
    self.add:Dock(RIGHT)
    self.name = self:Add("DLabel")
    self.name:SetFont("LiliaFont.32")
    self.name:SetContentAlignment(4)
    self.name:SetTextColor(color_white)
    self.name:Dock(FILL)
    self.name:DockMargin(8, 0, 0, 0)
end

function PANEL:setAttribute(key, attribute)
    self.key = key
    local startingMax = lia.attribs.list[key].startingMax or nil
    self.name:SetText(attribute.name)
    self:SetTooltip((attribute.desc or L("noDesc")) .. (startingMax and " " .. L("max", startingMax) or ""))
end

function PANEL:delta(delta)
    local client = LocalPlayer()
    if not IsValid(self.parent) then return end
    if not self.key then return end
    local oldPoints = self.points
    self.points = self.parent:onPointChange(self.key, delta)
    self:updateQuantity()
    if oldPoints ~= self.points and IsValid(client) then client:EmitSound("buttons/button15.wav", 30, 250) end
end

function PANEL:addButton(symbol, delta)
    local button = self.buttons:Add("DButton")
    button:SetFont("LiliaFont.24")
    button:SetSize(28, 28)
    button:SetText(symbol)
    button:SetTextColor(color_white)
    button:SetMouseInputEnabled(true)
    button:SetZPos(100)
    local parent = self
    button.Paint = function(btn, w, h)
        local theme = lia.color and lia.color.theme or {}
        local accentColor = theme.accent or theme.theme or theme.maincolor or color_white
        local bgColor = theme.focus_panel or theme.background or Color(25, 28, 35)
        if istable(bgColor) then bgColor = bgColor[1] end
        if not IsColor(bgColor) then bgColor = Color(25, 28, 35) end
        local base = Color(bgColor.r, bgColor.g, bgColor.b, 210)
        if btn:IsDown() then
            base = Color(accentColor.r, accentColor.g, accentColor.b, 95)
        elseif btn:IsHovered() then
            base = Color(accentColor.r, accentColor.g, accentColor.b, 58)
        end

        lia.derma.rect(0, 0, w, h):Rad(6):Color(base):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(0, 0, w, h):Rad(6):Color(Color(accentColor.r, accentColor.g, accentColor.b, btn:IsHovered() and 150 or 70)):Outline(1):Draw()
        draw.SimpleText(symbol, "LiliaFont.18", w / 2, h / 2, theme.text or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    button.DoClick = nil
    button.OnMousePressed = function(btn, mousecode)
        if mousecode ~= MOUSE_LEFT then return end
        btn:MouseCapture(true)
        parent.autoDelta = delta
        parent.nextAuto = CurTime() + 0.4
        parent:delta(delta)
    end

    button.OnMouseReleased = function(btn, mousecode)
        if mousecode ~= MOUSE_LEFT then return end
        btn:MouseCapture(false)
        parent.autoDelta = nil
    end

    button.OnCursorExited = function(btn)
        if not input.IsMouseDown(MOUSE_LEFT) then
            btn:MouseCapture(false)
            parent.autoDelta = nil
        end
    end
    return button
end

function PANEL:Think()
    local curTime = CurTime()
    if self.autoDelta and not input.IsMouseDown(MOUSE_LEFT) then self.autoDelta = nil end
    if self.autoDelta and (self.nextAuto or 0) < curTime then
        self.nextAuto = CurTime() + 0.4
        self:delta(self.autoDelta)
    end
end

function PANEL:updateQuantity()
    self.quantity:SetText(self.points)
end

function PANEL:Paint(w, h)
    local theme = lia.color and lia.color.theme or {}
    local accentColor = theme.accent or theme.theme or theme.maincolor or color_white
    local bgColor = theme.focus_panel or theme.background or Color(25, 28, 35)
    if istable(bgColor) then bgColor = bgColor[1] end
    if not IsColor(bgColor) then bgColor = Color(25, 28, 35) end
    lia.derma.rect(0, 0, w, h):Rad(6):Color(Color(bgColor.r, bgColor.g, bgColor.b, 220)):Shape(lia.derma.SHAPE_IOS):Draw()
    lia.derma.rect(0, 0, w, h):Rad(6):Color(Color(accentColor.r, accentColor.g, accentColor.b, self:IsHovered() and 120 or 40)):Outline(1):Draw()
end

vgui.Register("liaCharacterAttribsRow", PANEL, "DPanel")
