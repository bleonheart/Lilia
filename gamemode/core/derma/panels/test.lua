if SERVER then return end
local menu
local liliaMenu
local activeTest
local selectedSkin = "Default"
local skinFunctions = {{"PaintPanel", "General"}, {"PaintShadow", "General"}, {"PaintFrame", "General"}, {"PaintButton", "General"}, {"PaintTree", "General"}, {"PaintCheckBox", "General"}, {"PaintRadioButton", "General"}, {"PaintExpandButton", "General"}, {"PaintTextEntry", "General"}, {"PaintMenu", "Menus"}, {"PaintMenuSpacer", "Menus"}, {"PaintMenuOption", "Menus"}, {"PaintMenuRightArrow", "Menus"}, {"PaintMenuBar", "Menus"}, {"PaintPropertySheet", "Property Sheets"}, {"PaintTab", "Property Sheets"}, {"PaintActiveTab", "Property Sheets"}, {"PaintWindowCloseButton", "Window Controls"}, {"PaintWindowMinimizeButton", "Window Controls"}, {"PaintWindowMaximizeButton", "Window Controls"}, {"PaintVScrollBar", "Scrollbars"}, {"PaintHScrollBar", "Scrollbars"}, {"PaintScrollBarGrip", "Scrollbars"}, {"PaintButtonDown", "Scrollbars"}, {"PaintButtonUp", "Scrollbars"}, {"PaintButtonLeft", "Scrollbars"}, {"PaintButtonRight", "Scrollbars"}, {"PaintComboDownArrow", "Combo Boxes"}, {"PaintComboBox", "Combo Boxes"}, {"PaintListBox", "Combo Boxes"}, {"PaintNumberUp", "Number Controls"}, {"PaintNumberDown", "Number Controls"}, {"PaintTreeNode", "Trees"}, {"PaintTreeNodeButton", "Trees"}, {"PaintSelection", "Trees"}, {"PaintSliderKnob", "Sliders"}, {"PaintNumSlider", "Sliders"}, {"PaintProgress", "Categories"}, {"PaintCollapsibleCategory", "Categories"}, {"PaintCategoryList", "Categories"}, {"PaintCategoryButton", "Categories"}, {"PaintListViewLine", "List Views"}, {"PaintListView", "List Views"}, {"PaintTooltip", "Tooltips"}}
local liliaSpecificPanels = {
    BodygrouperMenu = true,
    liaAttribBar = true,
    liaBlurredDFrame = true,
    liaButton = true,
    liaCategory = true,
    liaCharacterAttribs = true,
    liaCharacterAttribsRow = true,
    liaCharInfo = true,
    liaCharacter = true,
    liaChatBox = true,
    liaCharacterBiography = true,
    liaCharacterCreateStep = true,
    liaCharacterCreation = true,
    liaCharacterModel = true,
    liaCheckbox = true,
    liaClasses = true,
    liaComboBox = true,
    liaDermaMenu = true,
    liaDialogMenu = true,
    liaDListView = true,
    liaDoorMenu = true,
    liaEntry = true,
    liaFrame = true,
    liaHeaderPanel = true,
    liaHorizontalScroll = true,
    liaHorizontalScrollBar = true,
    liaInventory = true,
    liaItemIcon = true,
    liaItemList = true,
    liaItemSelector = true,
    liaLockCircle = true,
    liaMenu = true,
    liaModelPanel = true,
    liaMarkupPanel = true,
    liaNotice = true,
    liaNoticePanel = true,
    liaPaintedNotification = true,
    liaPrivilegeRow = true,
    liaProgressBar = true,
    liaQuick = true,
    liaRadialPanel = true,
    liaScoreboard = true,
    liaScrollPanel = true,
    liaSemiTransparentDFrame = true,
    liaSemiTransparentDPanel = true,
    liaSheet = true,
    liaSimpleCheckbox = true,
    liaSlideBox = true,
    liaSlider = true,
    liaSpawnIcon = true,
    liaTabButton = true,
    liaTable = true,
    liaTabs = true,
    liaUserGroupButton = true,
    liaUserGroupList = true,
    liaVoicePanel = true
}
local function Call(panel, methodName, ...)
    local method = panel[methodName]
    if isfunction(method) then return method(panel, ...) end
end

local function ApplySkin(panel, skinName)
    if not IsValid(panel) then return end
    panel:SetSkin(skinName)
    panel:InvalidateLayout(true)
    for _, child in ipairs(panel:GetChildren()) do
        ApplySkin(child, skinName)
    end
end

local function RemoveActiveTest()
    if IsValid(activeTest) then activeTest:Remove() end
    activeTest = nil
end

local function BuildSkinSelector(parent, x, y)
    local skinLabel = vgui.Create("DLabel", parent)
    skinLabel:SetPos(x, y - 22)
    skinLabel:SetSize(180, 20)
    skinLabel:SetText("Test Skin")
    local skinSelector = vgui.Create("DComboBox", parent)
    skinSelector:SetPos(x, y)
    skinSelector:SetSize(250, 30)
    local skins = {}
    for skinName in pairs(derma.GetSkinTable()) do
        skins[#skins + 1] = skinName
    end

    table.sort(skins)
    local hasSelectedSkin = false
    for _, skinName in ipairs(skins) do
        skinSelector:AddChoice(skinName)
        if skinName == selectedSkin then hasSelectedSkin = true end
    end

    if not hasSelectedSkin then selectedSkin = skins[1] or "Default" end
    skinSelector:SetValue(selectedSkin)
    skinSelector.OnSelect = function(_, _, value) selectedSkin = value end
    return skinSelector
end

local presets = {
    DPanel = function(panel)
        panel:SetSize(420, 240)
        panel:SetPaintBackground(true)
    end,
    DFrame = function(panel)
        panel:SetSize(520, 340)
        panel:SetTitle("DFrame Skin Test")
        panel:SetSizable(true)
        panel:ShowCloseButton(true)
    end,
    DButton = function(panel)
        panel:SetSize(260, 48)
        panel:SetText("DButton Skin Test")
    end,
    DLabel = function(panel)
        panel:SetSize(420, 40)
        panel:SetText("DLabel Skin Test")
        panel:SetContentAlignment(5)
    end,
    DCheckBox = function(panel)
        panel:SetSize(30, 30)
        panel:SetValue(1)
    end,
    DCheckBoxLabel = function(panel)
        panel:SetSize(320, 32)
        panel:SetText("DCheckBoxLabel Skin Test")
        panel:SetValue(1)
    end,
    DTextEntry = function(panel)
        panel:SetSize(380, 34)
        panel:SetText("DTextEntry sample text")
        Call(panel, "SetPlaceholderText", "Placeholder text")
    end,
    DComboBox = function(panel)
        panel:SetSize(340, 34)
        panel:AddChoice("Option One")
        panel:AddChoice("Option Two")
        panel:AddChoice("Option Three")
        panel:SetValue("Option One")
    end,
    DTree = function(panel)
        panel:SetSize(420, 320)
        local root = panel:AddNode("Root Node")
        local first = root:AddNode("First Child")
        local second = root:AddNode("Second Child")
        first:AddNode("Nested Child")
        second:AddNode("Another Child")
        root:SetExpanded(true)
        first:SetExpanded(true)
    end,
    DListView = function(panel)
        panel:SetSize(540, 300)
        panel:AddColumn("Name")
        panel:AddColumn("Type")
        panel:AddColumn("Value")
        panel:AddLine("First Row", "Example", "100")
        panel:AddLine("Second Row", "Example", "200")
        panel:AddLine("Third Row", "Example", "300")
        panel:AddLine("Fourth Row", "Example", "400")
    end,
    DProgress = function(panel)
        panel:SetSize(440, 32)
        panel:SetFraction(0.65)
    end,
    DNumSlider = function(panel)
        panel:SetSize(520, 50)
        panel:SetText("DNumSlider")
        panel:SetMinMax(0, 100)
        panel:SetDecimals(0)
        panel:SetValue(65)
    end,
    DNumberWang = function(panel)
        panel:SetSize(220, 34)
        Call(panel, "SetMinMax", 0, 100)
        panel:SetValue(42)
    end,
    DPropertySheet = function(panel)
        panel:SetSize(540, 330)
        local first = vgui.Create("DPanel")
        first:SetPaintBackground(true)
        local second = vgui.Create("DPanel")
        second:SetPaintBackground(true)
        local third = vgui.Create("DPanel")
        third:SetPaintBackground(true)
        panel:AddSheet("First Tab", first)
        panel:AddSheet("Second Tab", second)
        panel:AddSheet("Third Tab", third)
    end,
    DCollapsibleCategory = function(panel)
        panel:SetSize(460, 260)
        panel:SetLabel("Collapsible Category")
        panel:SetExpanded(true)
        local contents = vgui.Create("DPanel")
        contents:SetTall(190)
        contents:SetPaintBackground(true)
        panel:SetContents(contents)
    end,
    DCategoryList = function(panel)
        panel:SetSize(460, 330)
        local first = panel:Add("First Category")
        local second = panel:Add("Second Category")
        local third = panel:Add("Third Category")
        first:SetExpanded(true)
        second:SetExpanded(false)
        third:SetExpanded(false)
    end,
    DScrollPanel = function(panel)
        panel:SetSize(440, 320)
        local contents = vgui.Create("DPanel")
        contents:SetTall(800)
        contents:SetPaintBackground(true)
        panel:AddItem(contents)
    end,
    DVScrollBar = function(panel)
        panel:SetSize(32, 340)
        panel:SetUp(80, 600)
        panel:SetScroll(180)
    end,
    DHScrollBar = function(panel)
        panel:SetSize(480, 32)
        panel:SetUp(80, 600)
        panel:SetScroll(180)
    end,
    DScrollBarGrip = function(panel) panel:SetSize(32, 200) end,
    DMenu = function(panel)
        panel:SetMinimumWidth(280)
        panel:AddOption("First Option")
        panel:AddOption("Second Option")
        panel:AddSpacer()
        panel:AddOption("Third Option")
        panel:AddOption("Fourth Option")
    end,
    DMenuOption = function(panel)
        panel:SetSize(280, 30)
        panel:SetText("DMenuOption Skin Test")
    end,
    DMenuSpacer = function(panel) panel:SetSize(280, 10) end,
    DMenuBar = function(panel)
        panel:SetSize(520, 30)
        local fileMenu = panel:AddMenu("File")
        fileMenu:AddOption("Open")
        fileMenu:AddOption("Save")
        fileMenu:AddSpacer()
        fileMenu:AddOption("Exit")
        local editMenu = panel:AddMenu("Edit")
        editMenu:AddOption("Copy")
        editMenu:AddOption("Paste")
        local viewMenu = panel:AddMenu("View")
        viewMenu:AddOption("Refresh")
    end,
    DSlider = function(panel)
        panel:SetSize(460, 48)
        panel:SetSlideX(0.35)
        panel:SetSlideY(0.5)
    end,
    DExpandButton = function(panel)
        panel:SetSize(36, 36)
        panel:SetExpanded(false)
    end,
    DListBox = function(panel)
        panel:SetSize(440, 300)
        for i = 1, 6 do
            local item = vgui.Create("DLabel")
            item:SetTall(28)
            item:SetText("List Item " .. i)
            item:SetContentAlignment(4)
            panel:AddItem(item)
        end
    end,
    DTooltip = function(panel)
        panel:SetSize(300, 44)
        Call(panel, "SetText", "DTooltip Skin Test")
    end,
    DColorMixer = function(panel)
        panel:SetSize(420, 300)
        panel:SetPalette(true)
        panel:SetAlphaBar(true)
        panel:SetWangs(true)
        panel:SetColor(Color(80, 150, 255))
    end,
    DImage = function(panel)
        panel:SetSize(128, 128)
        panel:SetImage("icon16/palette.png")
    end,
    DForm = function(panel)
        panel:SetSize(440, 300)
        panel:SetName("DForm Skin Test")
    end
}

local function ConfigureGenericPanel(panel, className)
    panel:SetSize(420, 220)
    Call(panel, "SetText", className .. " Skin Test")
    Call(panel, "SetTitle", className .. " Skin Test")
    Call(panel, "SetLabel", className .. " Skin Test")
end

local function CreateTestHost(className, skinName)
    local host = vgui.Create("EditablePanel")
    host:SetSize(680, 480)
    host:Center()
    host:MakePopup()
    host.Paint = function(_, w, h)
        surface.SetDrawColor(24, 24, 24, 250)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(75, 75, 75, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.SimpleText(className .. "  |  " .. skinName, "DermaDefaultBold", 18, 18, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local closeButton = vgui.Create("DButton", host)
    closeButton:SetSize(34, 26)
    closeButton:SetPos(host:GetWide() - 46, 10)
    closeButton:SetText("")
    closeButton.Paint = function(self, w, h)
        local alpha = self:IsHovered() and 220 or 160
        surface.SetDrawColor(170, 45, 45, alpha)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("×", "DermaDefaultBold", w * 0.5, h * 0.5 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    closeButton.DoClick = function() host:Remove() end
    return host
end

local function OpenPanelTest(className, skinName)
    RemoveActiveTest()
    if className == "DFrame" then
        local success, panel = pcall(vgui.Create, className)
        if not success or not IsValid(panel) then
            notification.AddLegacy("Failed to create " .. className, NOTIFY_ERROR, 4)
            return
        end

        activeTest = panel
        local preset = presets[className]
        if preset then
            pcall(preset, panel)
        else
            ConfigureGenericPanel(panel, className)
        end

        ApplySkin(panel, skinName)
        panel:Center()
        panel:MakePopup()
        return
    end

    if className == "DMenu" then
        local success, panel = pcall(vgui.Create, className)
        if not success or not IsValid(panel) then
            notification.AddLegacy("Failed to create " .. className, NOTIFY_ERROR, 4)
            return
        end

        activeTest = panel
        local preset = presets[className]
        if preset then pcall(preset, panel) end
        ApplySkin(panel, skinName)
        panel:SetPos(math.floor(ScrW() * 0.5 - panel:GetWide() * 0.5), math.floor(ScrH() * 0.5))
        panel:Open()
        return
    end

    local host = CreateTestHost(className, skinName)
    local success, panel = pcall(vgui.Create, className, host)
    if not success or not IsValid(panel) then
        host:Remove()
        notification.AddLegacy("Failed to create " .. className, NOTIFY_ERROR, 4)
        return
    end

    activeTest = host
    local preset = presets[className]
    if preset then
        local presetSuccess = pcall(preset, panel)
        if not presetSuccess then ConfigureGenericPanel(panel, className) end
    else
        ConfigureGenericPanel(panel, className)
    end

    ApplySkin(panel, skinName)
    panel:SetPos(math.floor((host:GetWide() - panel:GetWide()) * 0.5), math.floor(58 + (host:GetTall() - 58 - panel:GetTall()) * 0.5))
    panel:InvalidateLayout(true)
end

local function IsLiliaSpecificPanel(className)
    return liliaSpecificPanels[className] == true
end

local function GetLiliaPanelEntries()
    local controls = {}
    for className in pairs(liliaSpecificPanels) do
        local panelTable = vgui.GetControlTable(className)
        if panelTable then
            controls[#controls + 1] = {
                className = className,
                description = panelTable.Description or "",
                baseClass = panelTable.Base or panelTable.BaseClass or ""
            }
        end
    end

    table.sort(controls, function(a, b) return a.className < b.className end)
    return controls
end

local function OpenMenu()
    if IsValid(liliaMenu) then liliaMenu:Remove() end
    if IsValid(menu) then menu:Remove() end
    local frame = vgui.Create("DFrame")
    frame:SetSize(960, 640)
    frame:Center()
    frame:SetTitle("Derma SKIN Tester")
    frame:SetSizable(true)
    frame:SetMinWidth(760)
    frame:SetMinHeight(500)
    frame:MakePopup()
    menu = frame
    local toolbar = vgui.Create("DPanel", frame)
    toolbar:Dock(TOP)
    toolbar:SetTall(72)
    BuildSkinSelector(toolbar, 12, 30)
    local searchLabel = vgui.Create("DLabel", toolbar)
    searchLabel:SetPos(278, 8)
    searchLabel:SetSize(180, 20)
    searchLabel:SetText("Search Panels")
    local searchEntry = vgui.Create("DTextEntry", toolbar)
    searchEntry:SetPos(278, 30)
    searchEntry:SetSize(360, 30)
    searchEntry:SetPlaceholderText("DButton, DFrame, DListView...")
    local closeTestButton = vgui.Create("DButton", toolbar)
    closeTestButton:SetSize(150, 30)
    closeTestButton:SetPos(650, 30)
    closeTestButton:SetText("Close Active Test")
    closeTestButton.DoClick = function() RemoveActiveTest() end
    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)
    local panelsPage = vgui.Create("DPanel", sheet)
    panelsPage:DockPadding(8, 8, 8, 8)
    local footer = vgui.Create("DPanel", panelsPage)
    footer:Dock(BOTTOM)
    footer:SetTall(52)
    local selectedLabel = vgui.Create("DLabel", footer)
    selectedLabel:Dock(FILL)
    selectedLabel:DockMargin(8, 0, 8, 0)
    selectedLabel:SetText("Select a panel")
    selectedLabel:SetContentAlignment(4)
    local openButton = vgui.Create("DButton", footer)
    openButton:Dock(RIGHT)
    openButton:SetWide(180)
    openButton:SetText("Open Isolated Test")
    local controlList = vgui.Create("DListView", panelsPage)
    controlList:Dock(FILL)
    controlList:SetMultiSelect(false)
    controlList:AddColumn("Panel")
    controlList:AddColumn("Description")
    controlList:AddColumn("Base Class")
    local selectedClass
    local function RefreshControls()
        controlList:Clear()
        selectedClass = nil
        local query = string.lower(string.Trim(searchEntry:GetValue()))
        local controls = {}
        for className, information in pairs(derma.GetControlList()) do
            local description = information.Description or ""
            local baseClass = information.BaseClass or ""
            local searchable = string.lower(className .. " " .. description .. " " .. baseClass)
            if query == "" or string.find(searchable, query, 1, true) then
                controls[#controls + 1] = {
                    className = className,
                    description = description,
                    baseClass = baseClass
                }
            end
        end

        table.sort(controls, function(a, b) return a.className < b.className end)
        for _, information in ipairs(controls) do
            local line = controlList:AddLine(information.className, information.description, information.baseClass)
            line.ClassName = information.className
            line.Description = information.description
            line.BaseClassName = information.baseClass
        end

        selectedLabel:SetText("Showing " .. #controls .. " registered Derma controls")
    end

    controlList.OnRowSelected = function(_, _, line)
        selectedClass = line.ClassName
        local text = selectedClass
        if line.BaseClassName ~= "" then text = text .. "  |  Base: " .. line.BaseClassName end
        if line.Description ~= "" then text = text .. "  |  " .. line.Description end
        selectedLabel:SetText(text)
    end

    controlList.DoDoubleClick = function(_, _, line)
        if not IsValid(line) then return end
        selectedClass = line.ClassName
        OpenPanelTest(selectedClass, selectedSkin)
    end

    openButton.DoClick = function()
        if not selectedClass then
            notification.AddLegacy("Select a panel first", NOTIFY_HINT, 3)
            return
        end

        OpenPanelTest(selectedClass, selectedSkin)
    end

    searchEntry.OnChange = function() RefreshControls() end
    local functionsPage = vgui.Create("DPanel", sheet)
    functionsPage:DockPadding(8, 8, 8, 8)
    local functionCount = vgui.Create("DLabel", functionsPage)
    functionCount:Dock(TOP)
    functionCount:SetTall(30)
    functionCount:SetText("Default SKIN paint functions: " .. #skinFunctions)
    local functionList = vgui.Create("DListView", functionsPage)
    functionList:Dock(FILL)
    functionList:SetMultiSelect(false)
    functionList:AddColumn("SKIN Function")
    functionList:AddColumn("Category")
    for _, information in ipairs(skinFunctions) do
        functionList:AddLine("SKIN:" .. information[1], information[2])
    end

    sheet:AddSheet("Panels", panelsPage)
    sheet:AddSheet("SKIN Functions (" .. #skinFunctions .. ")", functionsPage)
    RefreshControls()
end

local function OpenLiliaMenu()
    if IsValid(menu) then menu:Remove() end
    if IsValid(liliaMenu) then liliaMenu:Remove() end
    local frame = vgui.Create("DFrame")
    frame:SetSize(940, 620)
    frame:Center()
    frame:SetTitle("Lilia Panel Tester")
    frame:SetSizable(true)
    frame:SetMinWidth(760)
    frame:SetMinHeight(500)
    frame:MakePopup()
    liliaMenu = frame
    local toolbar = vgui.Create("DPanel", frame)
    toolbar:Dock(TOP)
    toolbar:SetTall(72)
    BuildSkinSelector(toolbar, 12, 30)
    local searchLabel = vgui.Create("DLabel", toolbar)
    searchLabel:SetPos(278, 8)
    searchLabel:SetSize(220, 20)
    searchLabel:SetText("Search Lilia Panels")
    local searchEntry = vgui.Create("DTextEntry", toolbar)
    searchEntry:SetPos(278, 30)
    searchEntry:SetSize(340, 30)
    searchEntry:SetPlaceholderText("liaButton, liaFrame, liaTable...")
    local closeTestButton = vgui.Create("DButton", toolbar)
    closeTestButton:SetSize(150, 30)
    closeTestButton:SetPos(630, 30)
    closeTestButton:SetText("Close Active Test")
    closeTestButton.DoClick = function() RemoveActiveTest() end
    local refreshButton = vgui.Create("DButton", toolbar)
    refreshButton:SetSize(130, 30)
    refreshButton:SetPos(790, 30)
    refreshButton:SetText("Refresh List")
    local body = vgui.Create("DPanel", frame)
    body:Dock(FILL)
    body:DockPadding(8, 8, 8, 8)
    local footer = vgui.Create("DPanel", body)
    footer:Dock(BOTTOM)
    footer:SetTall(52)
    local selectedLabel = vgui.Create("DLabel", footer)
    selectedLabel:Dock(FILL)
    selectedLabel:DockMargin(8, 0, 8, 0)
    selectedLabel:SetText("Select a Lilia panel")
    selectedLabel:SetContentAlignment(4)
    local openButton = vgui.Create("DButton", footer)
    openButton:Dock(RIGHT)
    openButton:SetWide(200)
    openButton:SetText("Open Lilia Panel Test")
    local controlList = vgui.Create("DListView", body)
    controlList:Dock(FILL)
    controlList:SetMultiSelect(false)
    controlList:AddColumn("Lilia Panel")
    controlList:AddColumn("Description")
    controlList:AddColumn("Base Class")
    local selectedClass
    local function RefreshLiliaControls()
        controlList:Clear()
        selectedClass = nil
        local query = string.lower(string.Trim(searchEntry:GetValue()))
        local controls = {}
        for _, information in ipairs(GetLiliaPanelEntries()) do
            local searchable = string.lower(information.className .. " " .. information.description .. " " .. information.baseClass)
            if query == "" or string.find(searchable, query, 1, true) then
                controls[#controls + 1] = information
            end
        end

        for _, information in ipairs(controls) do
            local line = controlList:AddLine(information.className, information.description, information.baseClass)
            line.ClassName = information.className
            line.Description = information.description
            line.BaseClassName = information.baseClass
        end

        selectedLabel:SetText("Showing " .. #controls .. " registered Lilia panels")
    end

    controlList.OnRowSelected = function(_, _, line)
        selectedClass = line.ClassName
        local text = selectedClass
        if line.BaseClassName ~= "" then text = text .. "  |  Base: " .. line.BaseClassName end
        if line.Description ~= "" then text = text .. "  |  " .. line.Description end
        selectedLabel:SetText(text)
    end

    controlList.DoDoubleClick = function(_, _, line)
        if not IsValid(line) then return end
        selectedClass = line.ClassName
        OpenPanelTest(selectedClass, selectedSkin)
    end

    openButton.DoClick = function()
        if not selectedClass then
            notification.AddLegacy("Select a Lilia panel first", NOTIFY_HINT, 3)
            return
        end

        OpenPanelTest(selectedClass, selectedSkin)
    end

    searchEntry.OnChange = function() RefreshLiliaControls() end
    refreshButton.DoClick = function() RefreshLiliaControls() end
    RefreshLiliaControls()
end

concommand.Add("skin_test", OpenMenu)
concommand.Add("skin_test_menu", OpenMenu)
concommand.Add("skin_test_lilia", OpenLiliaMenu)
concommand.Add("skin_test_lilia_panels", OpenLiliaMenu)
concommand.Add("skin_test_close", function() RemoveActiveTest() end)
