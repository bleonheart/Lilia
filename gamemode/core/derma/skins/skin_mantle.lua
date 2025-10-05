local surface = surface
local Color = Color
local function drawMantleBg(panel, w, h)
    -- Create a mantle-like gradient background
    local mantleDark = Color(20, 15, 25, 240) -- Dark purple-ish base
    local mantleMid = Color(35, 25, 45, 220) -- Mid-tone purple
    local mantleLight = Color(50, 35, 65, 200) -- Lighter purple highlight
    -- Draw main background with gradient effect
    surface.SetDrawColor(mantleDark)
    surface.DrawRect(0, 0, w, h)
    -- Add subtle gradient overlay
    surface.SetDrawColor(mantleMid.r, mantleMid.g, mantleMid.b, 100)
    surface.DrawRect(0, 0, w, h * 0.3)
    -- Add highlight at top
    surface.SetDrawColor(mantleLight.r, mantleLight.g, mantleLight.b, 80)
    surface.DrawRect(0, 0, w, h * 0.15)
    -- Draw outline with mantle colors
    surface.SetDrawColor(80, 60, 100, 180)
    surface.DrawOutlinedRect(0, 0, w, h)
    -- Inner shadow effect
    surface.SetDrawColor(10, 8, 15, 150)
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
end

local SKIN = {}
SKIN.fontFrame = "BudgetLabel"
SKIN.fontTab = "liaSmallFont"
SKIN.fontButton = "liaSmallFont"
SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
SKIN.Colours.Window.TitleActive = Color(255, 255, 255)
SKIN.Colours.Window.TitleInactive = Color(255, 255, 255)
SKIN.Colours.Label.Dark = lia.color.theme and lia.color.theme.text or Color(220, 220, 220)
SKIN.Colours.Button.Normal = lia.color.theme and lia.color.theme.text or Color(220, 220, 220)
SKIN.Colours.Button.Hover = Color(255, 255, 255)
SKIN.Colours.Button.Down = Color(200, 200, 200)
SKIN.Colours.Button.Disabled = Color(100, 100, 100, 100)
SKIN.Colours.Tree = table.Copy(derma.SkinList.Default.Colours.Tree)
SKIN.Colours.Tree.Text = Color(255, 255, 255)
SKIN.Colours.Tree.SelectedText = Color(255, 255, 255)
function SKIN:PaintFrame(panel, w, h)
    if not panel.LaidOut then
        for _, btn in ipairs({panel.btnMinimize, panel.btnMaximize, panel.btnClose}) do
            if btn and btn:IsValid() then
                btn:SetText("")
                btn:SetPaintBackground(true)
            end
        end

        panel.LaidOut = true
    end

    -- Use the mantle background drawing function
    drawMantleBg(panel, w, h)
end

function SKIN:DrawGenericBackground(x, y, w, h)
    local mantleBg = Color(25, 20, 35, 240)
    local mantleOutline = Color(60, 45, 75, 180)
    local mantleInner = Color(15, 12, 20, 200)
    surface.SetDrawColor(mantleBg)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(mantleOutline)
    surface.DrawOutlinedRect(x, y, w, h)
    surface.SetDrawColor(mantleInner)
    surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)
end

function SKIN:PaintPanel(panel)
    if not panel.m_bBackground then return end
    if panel.GetPaintBackground and not panel:GetPaintBackground() then return end
    local w, h = panel:GetWide(), panel:GetTall()
    local mantlePanel = Color(20, 15, 25, 150)
    local mantleBorder = Color(45, 35, 55, 180)
    surface.SetDrawColor(mantlePanel)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(mantleBorder)
    surface.DrawOutlinedRect(0, 0, w, h)
end

local function paintButtonBase(panel, w, h)
    if not panel.m_bBackground then return end
    if panel.GetPaintBackground and not panel:GetPaintBackground() then return end
    local mantleButton = Color(35, 25, 40, 180)
    local mantleButtonHover = Color(50, 35, 55, 220)
    local mantleButtonDown = Color(25, 20, 30, 240)
    local alpha = 150
    if panel:GetDisabled() then
        alpha = 50
    elseif panel.Depressed then
        alpha = 240
        surface.SetDrawColor(mantleButtonDown)
    elseif panel.Hovered then
        alpha = 220
        surface.SetDrawColor(mantleButtonHover)
    else
        surface.SetDrawColor(mantleButton)
    end

    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(80, 60, 90, alpha)
    surface.DrawRect(2, 2, w - 4, h - 4)
end

function SKIN:PaintWindowMinimizeButton(panel, w, h)
    paintButtonBase(panel, w, h)
    surface.SetDrawColor(255, 255, 255, 255)
    local t = 1
    local iconW = w * 0.4
    local x = (w - iconW) * 0.5
    local y = (h - t) * 0.5
    surface.DrawRect(x, y, iconW, t)
end

function SKIN:PaintWindowMaximizeButton(panel, w, h)
    paintButtonBase(panel, w, h)
    surface.SetDrawColor(255, 255, 255, 255)
    local iconW = w * 0.4
    local x = (w - iconW) * 0.5
    local y = (h - iconW) * 0.5
    surface.DrawOutlinedRect(x, y, iconW, iconW)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
    paintButtonBase(panel, w, h)
    surface.SetDrawColor(255, 255, 255, 255)
    local iconW = w * 0.4
    local x1 = (w - iconW) * 0.5
    local y1 = (h - iconW) * 0.5
    local x2 = x1 + iconW
    local y2 = y1 + iconW
    surface.DrawLine(x1, y1, x2, y2)
    surface.DrawLine(x2, y1, x1, y2)
end

function SKIN:PaintButton(panel)
    paintButtonBase(panel, panel:GetWide(), panel:GetTall())
end

function SKIN:PaintComboBox(panel, w, h)
    paintButtonBase(panel, w, h)
end

function SKIN:PaintTextEntry(panel, w, h)
    if panel.m_bBackground then
        local mantleTextEntry = Color(15, 10, 20, 200)
        local mantleTextEntryHover = Color(25, 20, 35, 220)
        local mantleTextEntryDown = Color(20, 15, 25, 240)
        local alpha = 200
        if panel:GetDisabled() then
            alpha = 100
        elseif panel.Depressed then
            alpha = 240
            surface.SetDrawColor(mantleTextEntryDown)
        elseif panel.Hovered then
            alpha = 220
            surface.SetDrawColor(mantleTextEntryHover)
        else
            surface.SetDrawColor(mantleTextEntry)
        end

        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(60, 45, 75, alpha)
        surface.DrawRect(2, 2, w - 4, h - 4)
    end

    if panel.GetPlaceholderText and panel.GetPlaceholderColor and panel:GetPlaceholderText() and panel:GetPlaceholderText():Trim() ~= "" and panel:GetPlaceholderColor() and (not panel:GetText() or panel:GetText() == "") then
        local old = panel:GetText()
        local str = panel:GetPlaceholderText()
        if str:StartWith("#") then str = str:sub(2) end
        str = language.GetPhrase(str)
        panel:SetText(str)
        panel:DrawTextEntryText(panel:GetPlaceholderColor(), panel:GetHighlightColor(), panel:GetCursorColor())
        panel:SetText(old)
        return
    end

    panel:DrawTextEntryText(Color(255, 255, 255), panel:GetHighlightColor(), panel:GetCursorColor())
end

function SKIN:PaintListView(_, w, h)
    local mantleListView = Color(15, 10, 20, 180)
    surface.SetDrawColor(mantleListView)
    surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintListViewLine(panel, w, h)
    local mantleLineNormal = Color(0, 0, 0, 0)
    local mantleLineHover = Color(60, 45, 75, 150)
    local bgColor = panel:IsHovered() or panel:IsLineSelected() and mantleLineHover or mantleLineNormal
    surface.SetDrawColor(bgColor)
    surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintScrollBarGrip(_, w, h)
    local mantleGrip = Color(80, 60, 90, 255)
    surface.SetDrawColor(mantleGrip)
    surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintButtonUp(panel, w, h)
    if w <= 0 then return end
    local mantleButtonUp = Color(60, 45, 75, 255)
    surface.SetDrawColor(mantleButtonUp)
    surface.DrawRect(0, 0, w, h)
    surface.SetTextColor(255, 255, 255, 255)
    surface.SetFont("Marlett")
    surface.SetTextPos(1, 1)
    -- Use Unicode up arrow instead of Marlett "5"
    surface.DrawText("▲")
end

function SKIN:PaintButtonDown(panel, w, h)
    if w <= 0 then return end
    local mantleButtonDown = Color(60, 45, 75, 255)
    surface.SetDrawColor(mantleButtonDown)
    surface.DrawRect(0, 0, w, h)
    surface.SetTextColor(255, 255, 255, 255)
    surface.SetFont("Marlett")
    surface.SetTextPos(1, 0)
    -- Use Unicode down arrow instead of Marlett "6"
    surface.DrawText("▼")
end

function SKIN:PaintVScrollBar(_, w, h)
    local mantleScrollbar = Color(25, 20, 35, 200)
    surface.SetDrawColor(mantleScrollbar)
    surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintMenu(_, w, h)
    local mantleMenu = Color(25, 20, 35, 255)
    local mantleMenuAlt = Color(35, 30, 45, 255)
    local odd = true
    for i = 0, h, 22 do
        if odd then
            surface.SetDrawColor(mantleMenu)
            surface.DrawRect(0, i, w, 22)
        else
            surface.SetDrawColor(mantleMenuAlt)
            surface.DrawRect(0, i, w, 22)
        end

        odd = not odd
    end
end

function SKIN:PaintMenuOption(panel, w, h)
    if not panel.LaidOut then
        panel.LaidOut = true
        panel:SetTextColor(lia.color.theme.text or Color(220, 220, 220, 255))
    end

    if panel.m_bBackground and (panel.Hovered or panel.Highlight) then
        local mantleMenuHover = Color(60, 45, 75, 255)
        surface.SetDrawColor(mantleMenuHover)
        surface.DrawRect(0, 0, w, h)
    end

    local skin = derma.GetDefaultSkin()
    skin.MenuOptionOdd = not skin.MenuOptionOdd
    if panel:GetChecked() then skin.tex.Menu_Check(5, h / 2 - 7, 15, 15) end
end

-- Apply mantle styling to all the various panel types for consistency
local function drawMantlePanel(w, h)
    local mantlePanel = Color(20, 15, 25, 240)
    local mantleBorder = Color(45, 35, 55, 180)
    surface.SetDrawColor(mantlePanel)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(mantleBorder)
    surface.DrawOutlinedRect(0, 0, w, h)
    surface.SetDrawColor(15, 12, 20, 150)
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
end

function SKIN:PaintTreeNodeButton(panel, w, h)
    drawMantlePanel(w, h)
    panel:SetTextColor(self.Colours.Tree.Text)
end

function SKIN:PaintTooltip(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintPopupMenu(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintCollapsibleCategory(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintCategoryList(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintCategoryButton(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintContentPanel(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintContentIcon(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintSpawnIcon(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintTree(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintShadow(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintMenuSpacer(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintPropertySheet(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintTab(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintActiveTab(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintButtonLeft(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintButtonRight(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintListBox(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintNumberUp(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintNumberDown(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintSelection(panel, w, h)
    drawMantlePanel(w, h)
end

function SKIN:PaintMenuBar(panel, w, h)
    drawMantlePanel(w, h)
end

derma.DefineSkin(L("liliaMantleSkin"), L("liliaMantleSkinDesc"), SKIN)