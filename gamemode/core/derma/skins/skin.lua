local surface = surface
local draw = draw
local Color = Color
local Lerp = Lerp
local FrameTime = FrameTime
local math = math
local language = language
local table = table
local IsColor = IsColor
local SKIN = {}
local function isCustomCombo(panel)
    while IsValid(panel) do
        if panel._liliaCustomCombo then return true end
        panel = panel:GetParent()
    end
    return false
end

local function drawPanel(x, y, w, h, radius, background, outline)
    w = math.max(w, 1)
    h = math.max(h, 1)
    if lia and lia.derma and isfunction(lia.derma.rect) and lia.derma.SHAPE_IOS then
        lia.derma.rect(x, y, w, h):Rad(radius):Color(background):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
        return
    end

    if outline then
        draw.RoundedBox(radius, x, y, w, h, outline)
        draw.RoundedBox(math.max(radius - 1, 0), x + 1, y + 1, math.max(w - 2, 1), math.max(h - 2, 1), background)
        return
    end

    draw.RoundedBox(radius, x, y, w, h, background)
end

local function isDisabled(panel)
    if panel.GetDisabled and panel:GetDisabled() then return true end
    return panel.IsEnabled and not panel:IsEnabled() or false
end

local function getHover(panel, speed)
    local target = panel:IsHovered() and not isDisabled(panel) and 1 or 0
    panel._liliaSkinHover = Lerp(FrameTime() * (speed or 12), panel._liliaSkinHover or 0, target)
    return panel._liliaSkinHover
end

local function setTextColor(panel, color)
    if panel.SetTextColor then panel:SetTextColor(color) end
end

local function paintAccentButton(panel, w, h, radius)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel)
    local disabled = isDisabled(panel)
    local depressed = panel.Depressed
    local background
    local outline
    if disabled then
        background = lia.color.theme.background
        outline = lia.color.theme.text
    elseif depressed then
        background = Color(accent.r, accent.g, accent.b, 68)
        outline = Color(accent.r, accent.g, accent.b, 215)
    else
        background = Color(accent.r, accent.g, accent.b, 25 + hover * 26)
        outline = Color(accent.r, accent.g, accent.b, 75 + hover * 100)
    end

    drawPanel(0, 0, w, h, radius or 6, background, outline)
    setTextColor(panel, disabled and lia.color.theme.text or lia.color.theme.text)
end

local function paintNavigationButton(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel)
    local disabled = isDisabled(panel)
    drawPanel(0, 0, w, h, 4, disabled and lia.color.theme.background or Color(accent.r, accent.g, accent.b, 15 + hover * 22), disabled and lia.color.theme.text or Color(accent.r, accent.g, accent.b, 45 + hover * 75))
    setTextColor(panel, disabled and lia.color.theme.text or lia.color.theme.text)
end

SKIN.fontFrame = "BudgetLabel"
SKIN.fontTab = "LiliaFont.17"
SKIN.fontButton = "LiliaFont.17"
SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
SKIN.Colours.Window.TitleActive = lia.color.theme.text
SKIN.Colours.Window.TitleInactive = lia.color.theme.text
SKIN.Colours.Label.Dark = lia.color.theme.text
SKIN.Colours.Button.Normal = lia.color.theme.text
SKIN.Colours.Button.Hover = lia.color.theme.text
SKIN.Colours.Button.Down = lia.color.theme.accent or lia.color.theme.maincolor
SKIN.Colours.Button.Disabled = lia.color.theme.text
SKIN.Colours.Tree = table.Copy(derma.SkinList.Default.Colours.Tree)
SKIN.Colours.Tree.Text = lia.color.theme.text
SKIN.Colours.Tree.SelectedText = lia.color.theme.text
SKIN.Colours.Tree.Lines = lia.color.theme.text
function SKIN:PaintFrame(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    drawPanel(0, 0, w, h, 10, lia.color.theme.background, Color(accent.r, accent.g, accent.b, 92))
    surface.SetDrawColor(accent.r, accent.g, accent.b, 190)
    surface.DrawRect(0, 0, w, 2)
    surface.DrawRect(0, h - 2, w, 2)
    surface.SetDrawColor(accent.r, accent.g, accent.b, 38)
    surface.DrawRect(10, 31, math.max(w - 20, 1), 1)
end

function SKIN:PaintTooltip(_, w, h)
    drawPanel(0, 0, w, h, 6, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:DrawGenericBackground(x, y, w, h)
    drawPanel(x, y, w, h, 7, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintPanel(panel)
    if not panel.m_bBackground or panel.GetPaintBackground and not panel:GetPaintBackground() then return end
    local w, h = panel:GetWide(), panel:GetTall()
    drawPanel(0, 0, w, h, 7, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintButton(panel, w, h)
    if not panel.m_bBackground or panel.GetPaintBackground and not panel:GetPaintBackground() then return end
    paintAccentButton(panel, w or panel:GetWide(), h or panel:GetTall(), 6)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
    if not panel._liliaSkinWindowButton then
        panel:SetText("")
        panel._liliaSkinWindowButton = true
    end

    local hover = getHover(panel)
    local negative = lia.color.theme.negative or lia.color.theme.accent or lia.color.theme.maincolor
    local background = hover > 0.01 and Color(negative.r, negative.g, negative.b, 18 + hover * 20) or lia.color.theme.background
    drawPanel(0, 0, w, h, 5, background, Color(negative.r, negative.g, negative.b, 70 + hover * 80))
    draw.SimpleText("×", "LiliaFont.22", w * 0.5, h * 0.5 - 1, lia.color.theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SKIN:PaintWindowMinimizeButton(panel, w, h)
    if not panel._liliaSkinWindowButton then
        panel:SetText("")
        panel._liliaSkinWindowButton = true
    end

    paintNavigationButton(panel, w, h)
    local color = lia.color.theme.text
    surface.SetDrawColor(color)
    surface.DrawRect(math.floor(w * 0.28), math.floor(h * 0.62), math.max(math.floor(w * 0.44), 1), 1)
end

function SKIN:PaintWindowMaximizeButton(panel, w, h)
    if not panel._liliaSkinWindowButton then
        panel:SetText("")
        panel._liliaSkinWindowButton = true
    end

    paintNavigationButton(panel, w, h)
    local color = lia.color.theme.text
    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(math.floor(w * 0.3), math.floor(h * 0.3), math.max(math.floor(w * 0.4), 1), math.max(math.floor(h * 0.4), 1), 1)
end

function SKIN:PaintComboBox(panel, w, h)
    if isCustomCombo(panel) then return end
    if panel:GetFont() == "Default" or panel:GetFont() == "" then panel:SetFont("LiliaFont.18") end
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel)
    local disabled = isDisabled(panel)
    drawPanel(0, 0, w, h, 5, disabled and lia.color.theme.background or lia.color.theme.background, disabled and lia.color.theme.text or Color(accent.r, accent.g, accent.b, 48 + hover * 62))
    setTextColor(panel, lia.color.theme.text)
end

function SKIN:PaintComboDownArrow(panel)
    if isCustomCombo(panel) then return end
end

function SKIN:PaintTextEntry(panel, w, h)
    if isCustomCombo(panel) then return end
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel)
    local focused = panel:HasFocus()
    local disabled = isDisabled(panel)
    if panel.m_bBackground then
        local outlineAlpha = disabled and 35 or focused and 160 or 48 + hover * 62
        drawPanel(0, 0, w, h, 6, disabled and lia.color.theme.background or lia.color.theme.background, disabled and lia.color.theme.text or Color(accent.r, accent.g, accent.b, outlineAlpha))
    end

    if panel.SetCursorColor then panel:SetCursorColor(lia.color.theme.accent) end
    if panel.SetHighlightColor then panel:SetHighlightColor(lia.color.theme.accent) end
    if panel.GetPlaceholderText and panel.GetPlaceholderColor and panel:GetPlaceholderText() and panel:GetPlaceholderText():Trim() ~= "" and (not panel:GetText() or panel:GetText() == "") then
        local oldText = panel:GetText()
        local text = panel:GetPlaceholderText()
        if text:StartWith("#") then text = text:sub(2) end
        text = language.GetPhrase(text)
        panel:SetText(text)
        panel:DrawTextEntryText(lia.color.theme.text, panel:GetHighlightColor(), panel:GetCursorColor())
        panel:SetText(oldText)
        return
    end

    panel:DrawTextEntryText(lia.color.theme.text, panel:GetHighlightColor(), panel:GetCursorColor())
end

function SKIN:PaintListView(_, w, h)
    drawPanel(0, 0, w, h, 7, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintListViewLine(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hovered = panel:IsHovered()
    local selected = panel:IsLineSelected()
    if selected or hovered then drawPanel(1, 1, math.max(w - 2, 1), math.max(h - 2, 1), 4, Color(accent.r, accent.g, accent.b, selected and 30 or 16), Color(accent.r, accent.g, accent.b, selected and 135 or 70)) end
    if selected then
        surface.SetDrawColor(accent.r, accent.g, accent.b, 220)
        surface.DrawRect(1, 4, 3, math.max(h - 8, 1))
    end

    if panel.Columns then
        for _, column in ipairs(panel.Columns) do
            if IsValid(column) and column.SetTextColor then column:SetTextColor(selected and lia.color.theme.accent or lia.color.theme.text) end
        end
    end
end

function SKIN:PaintScrollBarGrip(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel)
    draw.RoundedBox(3, 2, 2, math.max(w - 4, 1), math.max(h - 4, 1), Color(accent.r, accent.g, accent.b, 150 + hover * 55))
end

function SKIN:PaintVScrollBar(_, w, h)
    draw.RoundedBox(3, 1, 0, math.max(w - 2, 1), h, lia.color.theme.background)
end

function SKIN:PaintButtonUp(panel, w, h)
    paintNavigationButton(panel, w, h)
end

function SKIN:PaintButtonDown(panel, w, h)
    paintNavigationButton(panel, w, h)
end

function SKIN:PaintMenu(_, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    drawPanel(0, 0, w, h, 5, lia.color.theme.background, Color(accent.r, accent.g, accent.b, 48))
end

function SKIN:PaintPopupMenu(_, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    drawPanel(0, 0, w, h, 5, lia.color.theme.background, Color(accent.r, accent.g, accent.b, 48))
end

function SKIN:PaintMenuOption(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hovered = panel.Hovered or panel.Highlight
    local checked = panel:GetChecked()
    local background = checked and Color(accent.r, accent.g, accent.b, 30) or hovered and Color(accent.r, accent.g, accent.b, 18) or lia.color.theme.background
    drawPanel(1, 0, math.max(w - 2, 1), h, 4, background, Color(accent.r, accent.g, accent.b, checked and 135 or hovered and 82 or 32))
    if checked then
        surface.SetDrawColor(accent.r, accent.g, accent.b, 220)
        surface.DrawRect(1, 4, 3, math.max(h - 8, 1))
    end

    setTextColor(panel, checked and lia.color.theme.accent or lia.color.theme.text)
end

local function drawCategoryBackground(w, h, alpha)
    drawPanel(0, 0, w, h, 7, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintCollapsibleCategory(panel, w, h)
    drawCategoryBackground(w, h)
    if panel.HeaderPainted then return end
    panel.Header.Paint = function(header, headerW, headerH)
        local accent = lia.color.theme.accent or lia.color.theme.maincolor
        local hover = getHover(header)
        local expanded = panel:GetExpanded()
        drawPanel(0, 0, headerW, headerH, 6, expanded and Color(accent.r, accent.g, accent.b, 28) or lia.color.theme.background, Color(accent.r, accent.g, accent.b, expanded and 130 or 45 + hover * 60))
    end

    panel.HeaderPainted = true
end

function SKIN:PaintCategoryList(_, w, h)
    drawCategoryBackground(w, h)
end

function SKIN:PaintCategoryButton(panel, w, h)
    paintAccentButton(panel, w, h, 5)
end

function SKIN:PaintContentPanel(_, w, h)
    drawCategoryBackground(w, h, 218)
end

function SKIN:PaintContentIcon(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel, 10)
    drawPanel(0, 0, w, h, 6, lia.color.theme.background, Color(accent.r, accent.g, accent.b, 40 + hover * 70))
    if hover > 0.01 then
        surface.SetDrawColor(accent.r, accent.g, accent.b, hover * 16)
        surface.DrawRect(4, 4, math.max(w - 8, 1), math.max(h - 8, 1))
    end
end

function SKIN:PaintSpawnIcon(panel, w, h)
    self:PaintContentIcon(panel, w, h)
end

function SKIN:PaintTree(_, w, h)
    drawPanel(0, 0, w, h, 7, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintTreeNode(panel, _, h)
    if not panel.m_bDrawLines then return end
    local lines = lia.color.theme.text
    surface.SetDrawColor(lines)
    if panel.m_bLastChild then
        surface.DrawRect(9, 0, 1, 7)
        surface.DrawRect(9, 7, 9, 1)
        return
    end

    surface.DrawRect(9, 0, 1, h)
    surface.DrawRect(9, 7, 9, 1)
end

function SKIN:PaintTreeNodeButton(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    if panel.m_bSelected then
        drawPanel(34, 0, math.max(w - 34, 1), h, 4, Color(accent.r, accent.g, accent.b, 30), Color(accent.r, accent.g, accent.b, 135))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 220)
        surface.DrawRect(34, 3, 3, math.max(h - 6, 1))
        panel:SetTextColor(lia.color.theme.accent)
    elseif panel.Hovered then
        drawPanel(34, 0, math.max(w - 34, 1), h, 4, Color(accent.r, accent.g, accent.b, 16), Color(accent.r, accent.g, accent.b, 65))
        panel:SetTextColor(lia.color.theme.text)
    else
        panel:SetTextColor(lia.color.theme.text)
    end
end

function SKIN:PaintShadow(_, w, h)
    draw.RoundedBox(10, 2, 3, math.max(w - 4, 1), math.max(h - 5, 1), Color(0, 0, 0, 55))
end

function SKIN:PaintMenuSpacer(_, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    surface.SetDrawColor(accent.r, accent.g, accent.b, 38)
    surface.DrawRect(8, math.floor(h * 0.5), math.max(w - 16, 1), 1)
end

function SKIN:PaintPropertySheet(_, w, h)
    drawPanel(0, 0, w, h, 7, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintTab(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    local hover = getHover(panel)
    drawPanel(0, 0, w, h, 6, lia.color.theme.background, Color(accent.r, accent.g, accent.b, 45 + hover * 75))
    setTextColor(panel, lia.color.theme.text)
end

function SKIN:PaintActiveTab(panel, w, h)
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    drawPanel(0, 0, w, h, 6, Color(accent.r, accent.g, accent.b, 30), Color(accent.r, accent.g, accent.b, 190))
    surface.SetDrawColor(accent.r, accent.g, accent.b, 225)
    surface.DrawRect(5, h - 3, math.max(w - 10, 1), 3)
    setTextColor(panel, lia.color.theme.text)
end

function SKIN:PaintButtonLeft(panel, w, h)
    paintNavigationButton(panel, w, h)
end

function SKIN:PaintButtonRight(panel, w, h)
    paintNavigationButton(panel, w, h)
end

function SKIN:PaintListBox(_, w, h)
    drawPanel(0, 0, w, h, 6, lia.color.theme.background, lia.color.theme.accent)
end

function SKIN:PaintNumberUp(panel, w, h)
    paintNavigationButton(panel, w, h)
end

function SKIN:PaintNumberDown(panel, w, h)
    paintNavigationButton(panel, w, h)
end

function SKIN:PaintSelection(panel, w, h)
    if isCustomCombo(panel) then return end
    local accent = lia.color.theme.accent or lia.color.theme.maincolor
    drawPanel(0, 0, w, h, 4, Color(accent.r, accent.g, accent.b, 38), Color(accent.r, accent.g, accent.b, 105))
end

function SKIN:PaintMenuBar(_, w, h)
    drawPanel(0, 0, w, h, 5, lia.color.theme.background, lia.color.theme.accent)
end

derma.DefineSkin(L("liliaSkin"), L("liliaSkinDesc"), SKIN)
derma.RefreshSkins()