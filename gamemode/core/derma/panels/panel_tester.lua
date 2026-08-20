local testerFrame
local activePanels = {}
local entries = {}
local selectedEntry
local previewRoot
local previewTitle
local previewMeta
local previewStatus
local listCanvas
local searchEntry
local openButton
local previewButton
local familyButtons = {}
local countLabel
local themePanel
local themeScroller
local themeButtons = {}
local themeButtonSignature = ""
local activeFamily = "Lilia"
local selectedTheme
local originalTheme
local collapsedCategories = {
    Lilia = {},
    GMOD = {}
}

local function traceback(errorMessage)
    return debug.traceback(tostring(errorMessage), 2)
end

local function runProtected(callback)
    return xpcall(callback, traceback)
end

local function addActivePanel(panel)
    if IsValid(panel) then activePanels[#activePanels + 1] = panel end
    return panel
end

local function closeActivePanels()
    for _, panel in ipairs(activePanels) do
        if IsValid(panel) then panel:Remove() end
    end

    activePanels = {}
end

local function controlExists(className)
    if not className then return false end
    return vgui.GetControlTable(className) ~= nil
end

local function setStatus(text, success)
    if not IsValid(previewStatus) then return end
    previewStatus:SetText(text or "")
    previewStatus:SetTextColor(success and Color(95, 210, 135) or Color(235, 120, 120))
    previewStatus:SizeToContentsY()
end

local function invoke(panel, methodName, ...)
    local method = panel and panel[methodName]
    if not isfunction(method) then return nil end
    return method(panel, ...)
end

local function createLabel(parent, text, font)
    local label = parent:Add("DLabel")
    label:SetFont(font or "DermaDefault")
    label:SetText(text or "")
    label:SetTextColor(color_white)
    label:SetWrap(true)
    label:SetAutoStretchVertical(true)
    return label
end

local function createSampleButton(parent, text)
    local button = parent:Add("DButton")
    button:SetText(text)
    button:SetTall(34)
    return button
end

local function findFirstAttribute()
    if not lia or not lia.attribs or not istable(lia.attribs.list) then return nil end
    local key = next(lia.attribs.list)
    if key == nil then return nil end
    return key, lia.attribs.list[key]
end

local function findFirstItemType()
    if not lia or not lia.item or not istable(lia.item.list) then return nil end
    return next(lia.item.list)
end

local function findLocalInventory()
    local client = LocalPlayer()
    if not IsValid(client) or not isfunction(client.getChar) then return nil end
    local character = client:getChar()
    if not character or not isfunction(character.getInv) then return nil end
    return character:getInv()
end

local setups = {}
setups.liaCharacterAttribsRow = function(panel, host)
    local key, attribute = findFirstAttribute()
    if not key then error("No attributes are registered in lia.attribs.list") end
    panel.parent = host
    panel.points = 3
    host.onPointChange = function(_, _, delta)
        panel.points = math.Clamp((panel.points or 0) + delta, 0, 10)
        return panel.points
    end

    panel:setAttribute(key, attribute)
    panel:updateQuantity()
end

setups.BodygrouperMenu = function(panel)
    local client = LocalPlayer()
    if not IsValid(client) then error("LocalPlayer is not valid") end
    panel:SetTarget(client)
end

setups.liaButton = function(panel) panel:SetText("Test Button") end
setups.liaChatBox = function(panel)
    panel:setActive(true)
    panel:addText(Color(95, 210, 135), "Panel Tester", color_white, ": Chatbox preview message")
    panel:addText(Color(130, 180, 255), "Use the entry below to test input behavior.")
end

setups.liaCheckbox = function(panel)
    panel:SetTxt("Enabled")
    panel:SetDescription("Interactive checkbox preview")
    panel:SetChecked(true)
end

setups.liaActionCircle = function(panel)
    panel:Start("Testing", 8, {
        holdTime = 1
    })
end

setups.liaComboBox = function(panel)
    panel:SetPlaceholder("Select an option")
    panel:AddChoice("First option", 1, "First tooltip")
    panel:AddChoice("Second option", 2, "Second tooltip")
    panel:AddSpacer("Section")
    panel:AddChoice("Third option", 3, "Third tooltip")
    panel:ChooseOptionID(1)
end

setups.liaDialogMenu = function(panel)
    panel:SetDialogTitle("Panel Tester")
    panel:SetDialogText("This is a safe local dialog preview. Choose an option to test the response layout.")
    panel:ResetConversationHistory("This is a safe local dialog preview.")
    panel:AddDialogOptions({
        ["Tell me more"] = {
            Response = "This response was generated locally by the panel tester."
        },
        ["Show another response"] = {
            Response = "The dialog menu supports multiple options and conversation history."
        },
        ["Close"] = {
            closeDialog = true
        }
    }, nil, true)
end

setups.liaDListView = function(panel)
    panel:SetWindowTitle("Panel Tester List")
    panel:SetPlaceholderText("Search rows")
    panel:SetColumns({"Name", "Type", "Status"})
    panel:setData({{"Alpha", "Example", "Ready"}, {"Bravo", "Example", "Ready"}, {"Charlie", "Example", "Disabled"}, {"Delta", "Example", "Ready"}})
end

setups.liaDoorMenu = function(panel)
    panel.access:AddRow("Example Player", "Owner")
    panel.access:AddRow("Second Player", "Tenant")
    panel.access:AddRow("Third Player", "Guest")
    panel.access:CommitBatch()
end

setups.liaProgressBar = function(panel)
    panel:SetText("Loading panel preview")
    panel:SetFraction(0.68)
end

setups.liaEntry = function(panel)
    panel:SetTitle("Example Entry")
    panel:SetPlaceholderText("Type here")
    panel:SetValue("Editable preview value")
end

setups.CircularAvatar = function(panel) panel:SetPlayer(LocalPlayer(), 128) end
setups.liaCharInfo = function(panel) if isfunction(panel.setup) then panel:setup() end end
setups.liaFrame = function(panel)
    panel:SetTitle("Lilia Frame Preview")
    local content = panel:Add("DPanel")
    content:Dock(FILL)
    content:DockMargin(12, 42, 12, 12)
    content:DockPadding(12, 12, 12, 12)
    local label = createLabel(content, "This frame was opened by the panel tester.", "DermaDefaultBold")
    label:Dock(TOP)
    local button = createSampleButton(content, "Interactive Button")
    button:Dock(TOP)
    button:DockMargin(0, 12, 0, 0)
end

setups.liaInventory = function(panel)
    local inventory = findLocalInventory()
    if not inventory then error("The local character does not have an accessible inventory") end
    panel:setInventory(inventory)
end

setups.liaHeaderPanel = function(panel) panel:SetLineWidth(2) end
setups.liaItemIcon = function(panel)
    local uniqueID = findFirstItemType()
    if not uniqueID then error("No item types are registered in lia.item.list") end
    panel:setItemType(uniqueID)
end

setups.liaModelPanel = function(panel) panel:SetModel(LocalPlayer():GetModel()) end
setups.liaNotice = function(panel)
    panel:SetText("Panel tester notification")
    panel:SetType("success")
    panel.targetY = 80
end

setups.liaNoticePanel = function(panel)
    panel.text:SetText("Timed Notice Preview")
    panel:CalcWidth(80)
    panel.start = CurTime()
    panel.endTime = CurTime() + 8
end

setups.liaRadialPanel = function(panel)
    panel:SetCenterText("Panel Tester", "Choose an option")
    panel:AddOption("Accept", function() end, "icon16/accept.png", "Accept the sample action")
    panel:AddOption("Information", function() end, "icon16/information.png", "Show information")
    panel:AddOption("Inventory", function() end, "icon16/box.png", "Open inventory")
    panel:AddOption("Trade", function() end, "icon16/money.png", "Open trade options")
    panel:AddOption("Settings", function() end, "icon16/cog.png", "Open settings")
    panel:AddOption("Radio", function() end, "icon16/sound.png", "Open radio options")
    panel:AddOption("Help", function() end, "icon16/help.png", "Show help")
    local moreOptions = panel:CreateSubMenu("More Options", "Choose an additional sample action")
    moreOptions:AddOption("Map", function() end, "icon16/map.png", "Open the map")
    moreOptions:AddOption("Friends", function() end, "icon16/group.png", "Open the friends list")
    moreOptions:AddOption("Messages", function() end, "icon16/email.png", "Open messages")
    moreOptions:AddOption("Achievements", function() end, "icon16/medal_gold_1.png", "View achievements")
    panel:AddSubMenuOption("More Options", moreOptions, "icon16/application_view_tile.png", "Open more sample options")
end

setups.liaScrollPanel = function(panel)
    for index = 1, 20 do
        local row = panel:Add("DPanel")
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, 6)
        row:SetTall(34)
        row.Paint = function(_, w, h)
            surface.SetDrawColor(35, 40, 46, 230)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText("Scrollable row " .. index, "DermaDefault", 10, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

setups.liaSheet = function(panel)
    panel:SetPlaceholderText("Filter settings")
    panel:AddTextRow({
        title = "General Setting",
        desc = "A searchable text row used to test the sheet layout.",
        right = "Enabled"
    })

    panel:AddTextRow({
        title = "Compact Setting",
        desc = "A smaller row variant.",
        right = "42",
        compact = true
    })

    panel:AddSubsheetRow({
        title = "Nested Settings",
        build = function(sheet)
            sheet:AddTextRow({
                title = "Nested Row",
                desc = "Subsheet content"
            })
        end
    })

    panel:Refresh()
end

setups.liaSlideBox = function(panel)
    panel:SetText("Volume")
    panel:SetRange(0, 100, 0)
    panel:SetValue(65)
end

setups.liaSlider = function(panel)
    panel:SetRange(0, 100, 0)
    panel:SetValue(65)
end

setups.liaSpawnIcon = function(panel) panel:SetModel(LocalPlayer():GetModel()) end
setups.liaTabButton = function(panel)
    panel:SetText("Example Tab")
    panel:SetIcon("icon16/application_view_tile.png")
    panel:SetActive(true)
end

setups.liaTable = function(panel)
    panel:AddColumn("Name", 180)
    panel:AddColumn("Role", 160)
    panel:AddColumn("Status", 120, TEXT_ALIGN_RIGHT)
    panel:AddRow("Alpha", "Developer", "Online")
    panel:AddRow("Bravo", "Administrator", "Away")
    panel:AddRow("Charlie", "Moderator", "Offline")
    panel:CommitBatch()
end

setups.liaTabs = function(panel)
    for index, name in ipairs({"Overview", "Configuration", "Permissions"}) do
        local content = vgui.Create("DPanel")
        content:DockPadding(20, 20, 20, 20)
        content.Paint = function(_, w, h)
            surface.SetDrawColor(24, 28, 34, 230)
            surface.DrawRect(0, 0, w, h)
        end

        local label = createLabel(content, name .. " tab content", "DermaDefaultBold")
        label:Dock(TOP)
        panel:AddTab(name, content, index == 1 and "icon16/house.png" or "icon16/cog.png")
    end
end

setups.liaVoicePanel = function(panel)
    panel:Setup(LocalPlayer())
    panel.voiceLevel = 0.7
end

setups.DProperties = function(panel)
    if isfunction(panel.CreateRow) then
        local row = panel:CreateRow("Panel Tester", "Example Value")
        if IsValid(row) and isfunction(row.Setup) then
            row:Setup("Generic", {
                value = "Editable"
            })
        end
    end
end

setups.DPanel = function(panel)
    panel.Paint = function(_, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(38, 44, 52, 245))
        draw.SimpleText("Default DPanel", "DermaLarge", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

setups.DButton = function(panel) panel:SetText("Default Derma Button") end
setups.DLabel = function(panel)
    panel:SetFont("DermaLarge")
    panel:SetText("Default Derma label")
    panel:SetTextColor(color_white)
    panel:SetContentAlignment(5)
    panel:SetWrap(true)
end

setups.DLabelURL = function(panel)
    panel:SetText("Open the Garry's Mod Wiki")
    panel:SetURL("https://wiki.facepunch.com/gmod/")
    panel:SetContentAlignment(5)
end

setups.DTextEntry = function(panel)
    panel:SetPlaceholderText("Type into the default DTextEntry")
    panel:SetText("Editable preview value")
end

setups.DCheckBox = function(panel) panel:SetValue(1) end
setups.DCheckBoxLabel = function(panel)
    panel:SetText("Default checkbox label")
    panel:SetValue(1)
    panel:SizeToContents()
end

setups.DComboBox = function(panel)
    panel:SetValue("First option")
    panel:AddChoice("First option", 1)
    panel:AddChoice("Second option", 2)
    panel:AddChoice("Third option", 3)
    panel:ChooseOptionID(1)
end

setups.DNumberWang = function(panel)
    panel:SetMinMax(0, 100)
    panel:SetDecimals(0)
    panel:SetValue(42)
end

setups.DNumSlider = function(panel)
    panel:SetText("Default number slider")
    panel:SetMinMax(0, 100)
    panel:SetDecimals(0)
    panel:SetValue(65)
end

setups.DSlider = function(panel)
    panel:SetLockY(0.5)
    panel:SetSlideX(0.65)
end

setups.DProgress = function(panel) panel:SetFraction(0.68) end
setups.DBinder = function(panel) panel:SetValue(KEY_F) end
setups.DImage = function(panel)
    panel:SetImage("icon16/application.png")
    panel:SetKeepAspect(true)
end

setups.DImageButton = function(panel)
    panel:SetImage("icon16/application_view_tile.png")
    panel:SetStretchToFit(false)
end

setups.SpawnIcon = function(panel) panel:SetModel(LocalPlayer():GetModel()) end
setups.AvatarImage = function(panel) panel:SetPlayer(LocalPlayer(), 128) end
setups.DModelPanel = function(panel) panel:SetModel(LocalPlayer():GetModel()) end
setups.DAdjustableModelPanel = function(panel) panel:SetModel(LocalPlayer():GetModel()) end
setups.DColorButton = function(panel) panel:SetColor(Color(65, 145, 235, 220)) end
setups.DColorCube = function(panel) panel:SetColor(Color(65, 145, 235)) end
setups.DColorMixer = function(panel)
    panel:SetPalette(true)
    panel:SetAlphaBar(true)
    panel:SetWangs(true)
    panel:SetColor(Color(65, 145, 235, 220))
end

setups.DColorPalette = function(panel) panel:SetButtonSize(24) end
setups.DRGBPicker = function(panel) invoke(panel, "SetRGB", Color(65, 145, 235)) end
setups.DAlphaBar = function(panel) invoke(panel, "SetValue", 0.75) end
setups.DFrame = function(panel)
    panel:SetTitle("Default Garry's Mod DFrame")
    local content = panel:Add("DPanel")
    content:Dock(FILL)
    content:DockMargin(8, 8, 8, 8)
    local label = content:Add("DLabel")
    label:Dock(TOP)
    label:SetTall(40)
    label:SetText("This is the default Derma frame.")
    label:SetContentAlignment(5)
    local button = content:Add("DButton")
    button:Dock(TOP)
    button:SetTall(34)
    button:SetText("Default DButton")
end

setups.DScrollPanel = function(panel)
    for index = 1, 20 do
        local button = panel:Add("DButton")
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetTall(34)
        button:SetText("Scrollable button " .. index)
    end
end

setups.DHorizontalScroller = function(panel)
    panel:SetOverlap(-8)
    for index = 1, 10 do
        local button = vgui.Create("DButton")
        button:SetSize(120, 48)
        button:SetText("Item " .. index)
        panel:AddPanel(button)
    end
end

setups.DIconLayout = function(panel)
    panel:SetSpaceX(8)
    panel:SetSpaceY(8)
    for index = 1, 18 do
        local button = panel:Add("DButton")
        button:SetSize(96, 72)
        button:SetText("Icon " .. index)
    end
end

setups.DListLayout = function(panel)
    for index = 1, 12 do
        local button = panel:Add("DButton")
        button:SetTall(34)
        button:SetText("List item " .. index)
    end
end

setups.DTileLayout = function(panel)
    panel:SetSpaceX(8)
    panel:SetSpaceY(8)
    for index = 1, 15 do
        local button = panel:Add("DButton")
        button:SetSize(110, 60)
        button:SetText("Tile " .. index)
    end
end

setups.DGrid = function(panel)
    panel:SetCols(4)
    panel:SetColWide(120)
    panel:SetRowHeight(52)
    for index = 1, 16 do
        local button = vgui.Create("DButton")
        button:SetSize(112, 44)
        button:SetText("Grid " .. index)
        panel:AddItem(button)
    end
end

setups.DPanelList = function(panel)
    panel:EnableVerticalScrollbar(true)
    panel:SetSpacing(6)
    panel:SetPadding(6)
    for index = 1, 15 do
        local button = vgui.Create("DButton")
        button:SetTall(34)
        button:SetText("Legacy item " .. index)
        panel:AddItem(button)
    end
end

setups.DForm = function(panel)
    panel:SetName("Default DForm")
    panel:Help("A sample form built with default Derma controls.")
    local checkbox = vgui.Create("DCheckBoxLabel")
    checkbox:SetText("Enabled")
    checkbox:SetValue(1)
    checkbox:SizeToContents()
    panel:AddItem(checkbox)
    local entry = vgui.Create("DTextEntry")
    entry:SetPlaceholderText("Form text entry")
    panel:AddItem(entry)
    local button = vgui.Create("DButton")
    button:SetText("Form action")
    panel:AddItem(button)
end

setups.DCollapsibleCategory = function(panel)
    panel:SetLabel("Default Collapsible Category")
    local content = vgui.Create("DPanel")
    content:SetTall(160)
    content:DockPadding(8, 8, 8, 8)
    for index = 1, 3 do
        local button = content:Add("DButton")
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 6)
        button:SetTall(34)
        button:SetText("Category action " .. index)
    end

    panel:SetContents(content)
    panel:SetExpanded(true)
end

setups.DCategoryList = function(panel)
    for index = 1, 4 do
        local category = panel:Add("Category " .. index)
        if IsValid(category) then
            local content = vgui.Create("DPanel")
            content:SetTall(100)
            content:DockPadding(6, 6, 6, 6)
            local button = content:Add("DButton")
            button:Dock(TOP)
            button:SetTall(34)
            button:SetText("Action " .. index)
            category:SetContents(content)
            category:SetExpanded(index == 1)
        end
    end
end

setups.DPropertySheet = function(panel)
    for index, name in ipairs({"Overview", "Settings", "Advanced"}) do
        local content = vgui.Create("DPanel")
        content:DockPadding(12, 12, 12, 12)
        local label = content:Add("DLabel")
        label:Dock(TOP)
        label:SetTall(36)
        label:SetText(name .. " page")
        label:SetContentAlignment(5)
        panel:AddSheet(name, content, index == 1 and "icon16/house.png" or "icon16/cog.png")
    end
end

setups.DColumnSheet = function(panel)
    for index, name in ipairs({"Overview", "Settings", "Advanced"}) do
        local content = vgui.Create("DPanel")
        content:DockPadding(12, 12, 12, 12)
        local label = content:Add("DLabel")
        label:Dock(TOP)
        label:SetTall(36)
        label:SetText(name .. " page")
        label:SetContentAlignment(5)
        panel:AddSheet(name, content, index == 1 and "icon16/house.png" or "icon16/cog.png")
    end
end

setups.DListView = function(panel)
    panel:AddColumn("Name")
    panel:AddColumn("Type")
    panel:AddColumn("Status")
    panel:AddLine("Alpha", "Example", "Ready")
    panel:AddLine("Bravo", "Example", "Ready")
    panel:AddLine("Charlie", "Example", "Disabled")
    panel:AddLine("Delta", "Example", "Ready")
end

setups.DTree = function(panel)
    local root = panel:AddNode("Panel Tester", "icon16/folder.png")
    root:AddNode("Controls", "icon16/application.png")
    local containers = root:AddNode("Containers", "icon16/folder_page.png")
    containers:AddNode("Scroll Panels", "icon16/application_view_list.png")
    containers:AddNode("Layouts", "icon16/application_tile_horizontal.png")
    root:SetExpanded(true)
    containers:SetExpanded(true)
end

setups.DMenu = function(panel)
    panel:AddOption("Primary action", function() end, "icon16/accept.png")
    panel:AddOption("Secondary action", function() end, "icon16/information.png")
    panel:AddSpacer()
    local submenu = panel:AddSubMenu("Submenu", nil, "icon16/folder.png")
    if IsValid(submenu) then submenu:AddOption("Nested action", function() end) end
    local x, y = gui.MousePos()
    panel:Open(x, y)
end

setups.DMenuBar = function(panel)
    local fileMenu = panel:AddMenu("File")
    fileMenu:AddOption("New", function() end, "icon16/page_add.png")
    fileMenu:AddOption("Open", function() end, "icon16/folder_page.png")
    fileMenu:AddSpacer()
    fileMenu:AddOption("Close", function() end, "icon16/cancel.png")
    local editMenu = panel:AddMenu("Edit")
    editMenu:AddOption("Preferences", function() end, "icon16/cog.png")
end

setups.DHTML = function(panel) panel:SetHTML([[<html><body style="margin:0;background:#20252c;color:#f1f4f7;font-family:Arial;display:flex;align-items:center;justify-content:center;height:100%;"><div style="text-align:center;"><h1>Default DHTML</h1><p>Local panel tester content</p><button onclick="document.body.style.background='#313b46'">Test JavaScript</button></div></body></html>]]) end
setups.DHTMLControls = function(panel, host)
    local html = vgui.Create("DHTML", host)
    html:SetSize(1, 1)
    html:SetVisible(false)
    html:SetHTML([[<html><body><h1>Panel Tester</h1></body></html>]])
    panel:SetHTML(html)
    panel._panelTesterHTML = html
end

setups.DFileBrowser = function(panel)
    invoke(panel, "SetPath", "GAME")
    invoke(panel, "SetBaseFolder", "materials")
    invoke(panel, "SetOpen", true)
end

setups.DNotify = function(panel)
    panel:SetLife(8)
    for index = 1, 3 do
        local item = vgui.Create("DPanel")
        item:SetSize(280, 52)
        item.Paint = function(_, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(42, 48, 58, 245))
            draw.SimpleText("Notification " .. index, "DermaDefaultBold", 12, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        panel:AddItem(item)
    end
end

setups.DPanelSelect = function(panel)
    for index = 1, 8 do
        local button = vgui.Create("DButton")
        button:SetSize(120, 70)
        button:SetText("Choice " .. index)
        panel:AddPanel(button, {
            index = index
        })
    end
end

setups.RichText = function(panel)
    panel:InsertColorChange(95, 210, 135, 255)
    panel:AppendText("Panel Tester\n")
    panel:InsertColorChange(235, 240, 245, 255)
    panel:AppendText("This is the default RichText control.\n")
    panel:InsertColorChange(130, 180, 255, 255)
    panel:AppendText("Selection, scrolling, and colored text are available.")
end

local function registerEntry(className, source, category, mode, description, width, height, warning, setupName)
    local family = (category == "GMOD" or source == "Garry's Mod VGUI") and "GMOD" or "Lilia"
    entries[#entries + 1] = {
        class = className,
        source = source,
        category = category,
        family = family,
        mode = mode,
        description = description,
        width = width,
        height = height,
        warning = warning,
        setup = setups[setupName or className]
    }
end

registerEntry("DPanel", "Garry's Mod VGUI", "GMOD", "embedded", "Default blank Derma panel with a sample paint function.", 520, 260)
registerEntry("DButton", "Garry's Mod VGUI", "GMOD", "embedded", "Default Derma push button.", 300, 48)
registerEntry("DLabel", "Garry's Mod VGUI", "GMOD", "embedded", "Default Derma text label.", 460, 90)
registerEntry("DLabelURL", "Garry's Mod VGUI", "GMOD", "embedded", "Clickable default URL label.", 460, 48, "Clicking it opens the configured wiki URL.")
registerEntry("DTextEntry", "Garry's Mod VGUI", "GMOD", "embedded", "Default editable text entry.", 520, 42)
registerEntry("DCheckBox", "Garry's Mod VGUI", "GMOD", "embedded", "Default checkbox control.", 48, 48)
registerEntry("DCheckBoxLabel", "Garry's Mod VGUI", "GMOD", "embedded", "Default checkbox with a text label.", 320, 42)
registerEntry("DComboBox", "Garry's Mod VGUI", "GMOD", "embedded", "Default dropdown choice control.", 360, 42)
registerEntry("DNumberWang", "Garry's Mod VGUI", "GMOD", "embedded", "Default numeric entry control.", 180, 42)
registerEntry("DNumSlider", "Garry's Mod VGUI", "GMOD", "embedded", "Default labeled numeric slider.", 560, 52)
registerEntry("DSlider", "Garry's Mod VGUI", "GMOD", "embedded", "Default two-dimensional slider control.", 560, 44)
registerEntry("DProgress", "Garry's Mod VGUI", "GMOD", "embedded", "Default progress bar.", 560, 34)
registerEntry("DBinder", "Garry's Mod VGUI", "GMOD", "embedded", "Default keyboard binding control.", 240, 42)
registerEntry("DImage", "Garry's Mod VGUI", "GMOD", "embedded", "Default material image panel.", 180, 180)
registerEntry("DImageButton", "Garry's Mod VGUI", "GMOD", "embedded", "Clickable default image button.", 180, 180)
registerEntry("SpawnIcon", "Garry's Mod VGUI", "GMOD", "embedded", "Default spawn-menu model icon.", 180, 180)
registerEntry("AvatarImage", "Garry's Mod VGUI", "GMOD", "embedded", "Default Steam avatar panel for the local player.", 160, 160)
registerEntry("DModelPanel", "Garry's Mod VGUI", "GMOD", "embedded", "Default model preview panel using the local player model.", 360, 420)
registerEntry("DAdjustableModelPanel", "Garry's Mod VGUI", "GMOD", "embedded", "Adjustable default model preview panel.", 420, 460)
registerEntry("DColorButton", "Garry's Mod VGUI", "GMOD", "embedded", "Default clickable color swatch.", 96, 96)
registerEntry("DColorCube", "Garry's Mod VGUI", "GMOD", "embedded", "Default saturation and brightness color cube.", 320, 320)
registerEntry("DColorMixer", "Garry's Mod VGUI", "GMOD", "embedded", "Complete default color mixer.", 460, 380)
registerEntry("DColorPalette", "Garry's Mod VGUI", "GMOD", "embedded", "Default reusable color palette.", 420, 260)
registerEntry("DRGBPicker", "Garry's Mod VGUI", "GMOD", "embedded", "Default hue picker.", 48, 300)
registerEntry("DAlphaBar", "Garry's Mod VGUI", "GMOD", "embedded", "Default alpha picker.", 48, 300)
registerEntry("DFrame", "Garry's Mod VGUI", "GMOD", "window", "Default movable Derma frame.", 720, 500)
registerEntry("DScrollPanel", "Garry's Mod VGUI", "GMOD", "embedded", "Default vertically scrolling panel.", 620, 430)
registerEntry("DHorizontalScroller", "Garry's Mod VGUI", "GMOD", "embedded", "Default horizontal panel scroller.", 720, 90)
registerEntry("DIconLayout", "Garry's Mod VGUI", "GMOD", "embedded", "Default wrapping icon layout.", 720, 460)
registerEntry("DListLayout", "Garry's Mod VGUI", "GMOD", "embedded", "Default vertical list layout.", 620, 430)
registerEntry("DTileLayout", "Garry's Mod VGUI", "GMOD", "embedded", "Default tile layout.", 720, 460)
registerEntry("DGrid", "Garry's Mod VGUI", "GMOD", "embedded", "Default fixed-column grid layout.", 560, 420)
registerEntry("DPanelList", "Garry's Mod VGUI", "GMOD", "embedded", "Legacy default scrolling panel list.", 620, 430, "DPanelList is retained for compatibility; DScrollPanel and layouts are preferred.")
registerEntry("DForm", "Garry's Mod VGUI", "GMOD", "embedded", "Default collapsible form container.", 620, 420)
registerEntry("DCollapsibleCategory", "Garry's Mod VGUI", "GMOD", "embedded", "Default collapsible category.", 620, 240)
registerEntry("DCategoryList", "Garry's Mod VGUI", "GMOD", "embedded", "Default scrolling category list.", 620, 500)
registerEntry("DPropertySheet", "Garry's Mod VGUI", "GMOD", "embedded", "Default tabbed property sheet.", 760, 500)
registerEntry("DColumnSheet", "Garry's Mod VGUI", "GMOD", "embedded", "Default vertical column sheet.", 760, 500)
registerEntry("DListView", "Garry's Mod VGUI", "GMOD", "embedded", "Default sortable list view.", 760, 440)
registerEntry("DTree", "Garry's Mod VGUI", "GMOD", "embedded", "Default expandable tree view.", 620, 460)
registerEntry("RichText", "Garry's Mod VGUI", "GMOD", "embedded", "Default rich text display control.", 620, 360)
registerEntry("DMenu", "Garry's Mod VGUI", "GMOD", "overlay", "Default Derma context menu.", 0, 0)
registerEntry("DMenuBar", "Garry's Mod VGUI", "GMOD", "embedded", "Default menu bar with File and Edit menus.", 720, 34)
registerEntry("DHTML", "Garry's Mod VGUI", "GMOD", "embedded", "Default Chromium-backed HTML panel using local content.", 760, 520)
registerEntry("DHTMLControls", "Garry's Mod VGUI", "GMOD", "embedded", "Default navigation controls for a DHTML panel.", 760, 42, "The tester creates a hidden companion DHTML panel for the controls.")
registerEntry("DFileBrowser", "Garry's Mod VGUI", "GMOD", "embedded", "Default game file browser rooted at materials.", 760, 520, "Browsing is local and read-only in this tester.")
registerEntry("DNotify", "Garry's Mod VGUI", "GMOD", "embedded", "Default animated notification container.", 340, 240)
registerEntry("DPanelSelect", "Garry's Mod VGUI", "GMOD", "embedded", "Default selectable panel collection.", 620, 360)
registerEntry("liaCharacterAttribs", "attribs.lua", "Character", "embedded", "Character creation attribute allocation step.", 720, 500, "Requires liaCharacterCreateStep and registered attributes.")
registerEntry("liaCharacterAttribsRow", "attribs.lua", "Character", "embedded", "Single character attribute allocation row.", 620, 48)
registerEntry("BodygrouperMenu", "bodygrouper.lua", "Menus", "window", "Live bodygroup and skin editor using the local player model.", 440, 720, "Submitting can send a bodygroup update to the server.")
registerEntry("liaButton", "buttons.lua", "Controls", "embedded", "Primary themed Lilia button.", 280, 48)
registerEntry("liaChatBox", "chatbox.lua", "Menus", "window", "Live custom chatbox preview with sample messages.", 760, 520, "Opening this temporarily replaces lia.gui.chat.")
registerEntry("liaCheckbox", "checkbox.lua", "Controls", "embedded", "Themed toggle switch.", 180, 42)
registerEntry("liaActionCircle", "circle.lua", "Overlays", "overlay", "Timed circular action indicator.", 0, 0)
registerEntry("liaComboBox", "combobox.lua", "Controls", "embedded", "Custom combobox with choices, tooltips, and separators.", 360, 42)
registerEntry("liaDialogMenu", "dialog.lua", "Menus", "window", "Local NPC-style dialog preview with conversation history.", 720, 540, "Opening this temporarily replaces lia.dialog.vgui.")
registerEntry("liaDListView", "dlistview.lua", "Menus", "window", "Searchable and sortable list window.", 960, 720)
registerEntry("liaDoorMenu", "door.lua", "Menus", "window", "Door access table preview using sample rows.", 700, 600, "The tester does not attach this preview to a real door.")
registerEntry("liaProgressBar", "dprogressbar.lua", "Controls", "embedded", "Progress bar with text and configurable fraction.", 560, 54)
registerEntry("DTooltip", "dproperties.lua", "GMOD", "embedded", "Overridden Derma tooltip control.", 420, 100, "This is normally created automatically by Derma.")
registerEntry("DProperties", "dproperties.lua", "GMOD", "embedded", "Overridden Derma properties panel.", 620, 420)
registerEntry("liaEntry", "entry.lua", "Controls", "embedded", "Custom text entry with label and placeholder support.", 560, 72)
registerEntry("ContentContainer", "extended_spawnmenu.lua", "GMOD", "integration", "Extended spawnmenu content container integration.", 0, 0, "This file registers spawnmenu hooks rather than a standalone Lilia menu.")
registerEntry("CircularAvatar", "f1menu.lua / panels.lua", "Controls", "embedded", "Circular local-player avatar.", 150, 150)
registerEntry("liaCharInfo", "f1menu.lua", "Character", "embedded", "Character information page used by the F1 menu.", 900, 650, "Requires an active Lilia character and configured character fields.")
registerEntry("liaMenu", "f1menu.lua", "Menus", "window", "Complete Lilia F1 menu.", 0, 0, "Uses live character, configuration, administration, and networking state.")
registerEntry("liaClasses", "f1menu.lua", "Character", "window", "Class selection page.", 1000, 700, "Requires configured factions, classes, and an active character.")
registerEntry("liaFrame", "frame.lua", "Windows", "window", "Base themed Lilia frame with sample content.", 720, 500)
registerEntry("liaInventory", "frame.lua", "Menus", "window", "Live local-character inventory window.", 900, 700, "Requires an active character inventory.")
registerEntry("liaHeaderPanel", "headerpanel.lua", "Controls", "embedded", "Header divider line.", 560, 44)
registerEntry("liaItemIcon", "item.lua", "Items", "embedded", "Lilia item icon using the first registered item type.", 160, 160, "Requires at least one registered item type.")
registerEntry("liaModelPanel", "modelpanel.lua", "Controls", "embedded", "Model panel displaying the local player model.", 360, 420)
registerEntry("liaNotice", "notice.lua", "Overlays", "overlay", "Animated success notification.", 0, 0)
registerEntry("liaNoticePanel", "notice.lua", "Controls", "embedded", "Timed notice panel with progress fill.", 520, 70)
registerEntry("liaQuick", "panels.lua", "Menus", "window", "Quick options menu populated from live registered options.", 520, 700, "Uses live option hooks and can alter client options.")
registerEntry("liaRadialPanel", "radialpanel.lua", "Overlays", "overlay", "Full-screen radial menu with sample options.", 0, 0)
registerEntry("liaScoreboard", "scoreboard.lua", "Menus", "window", "Live Lilia scoreboard.", 0, 0, "Uses current players, factions, character data, and scoreboard hooks.")
registerEntry("liaScrollPanel", "scrollpanel.lua", "Controls", "embedded", "Styled scroll panel with sample rows.", 620, 430)
registerEntry("liaSheet", "sheet.lua", "Controls", "embedded", "Searchable settings sheet with nested sample rows.", 720, 520)
registerEntry("liaSlideBox", "slidebox.lua", "Controls", "embedded", "Labeled large slider.", 620, 70)
registerEntry("liaSlider", "slider.lua", "Controls", "embedded", "Compact slider.", 620, 34)
registerEntry("liaSpawnIcon", "spawnicon.lua", "Controls", "embedded", "Spawn icon model preview.", 180, 180)
registerEntry("liaTabButton", "tab_button.lua", "Controls", "embedded", "Single active tab button.", 260, 48)
registerEntry("liaTable", "table.lua", "Controls", "embedded", "Sortable table with sample rows.", 760, 420)
registerEntry("liaTabs", "tabs.lua", "Controls", "embedded", "Tabbed content container with three sample pages.", 760, 480)
registerEntry("liaVoicePanel", "voice.lua", "Overlays", "embedded", "Voice indicator using the local player.", 360, 70)
registerEntry("Weapon Selector", "weaponselector.lua", "Integrations", "integration", "HUD weapon selector integration.", 0, 0, "Equip multiple weapons and use the normal next/previous weapon binds to test it.")
local function getSortedEntries()
    local sorted = {}
    for _, entry in ipairs(entries) do
        sorted[#sorted + 1] = entry
    end

    table.sort(sorted, function(first, second)
        if first.family ~= second.family then return first.family < second.family end
        if first.category ~= second.category then return first.category:lower() < second.category:lower() end
        return first.class:lower() < second.class:lower()
    end)
    return sorted
end

local function getThemeNames()
    local names = {}
    if not lia or not lia.color or not istable(lia.color.themes) then return names end
    for name in pairs(lia.color.themes) do
        names[#names + 1] = tostring(name)
    end

    table.sort(names, function(a, b) return a:lower() < b:lower() end)
    return names
end

local function getThemeAccent(themeName)
    local theme = lia and lia.color and lia.color.themes and lia.color.themes[themeName]
    if not istable(theme) then return Color(90, 145, 220) end
    return theme.accent or theme.header or theme.theme or Color(90, 145, 220)
end

local function restoreTheme()
    if not originalTheme or not lia or not lia.color then return end
    lia.color.theme = table.Copy(originalTheme)
    hook.Run("OnThemeChanged")
    lia.color.theme = table.Copy(originalTheme)
end

local function applyTheme(themeName)
    if not lia or not lia.color or not istable(lia.color.themes) then return false end
    local theme = lia.color.themes[themeName]
    if not istable(theme) then return false end
    lia.color.theme = table.Copy(theme)
    selectedTheme = themeName
    hook.Run("OnThemeChanged", themeName)
    lia.color.theme = table.Copy(theme)
    return true
end

local function clearPreview()
    if IsValid(previewRoot) then previewRoot:Clear() end
end

local function formatEntryMeta(entry)
    local availability
    if entry.mode == "integration" then
        availability = "Integration"
    elseif controlExists(entry.class) then
        availability = "Registered"
    else
        availability = "Missing"
    end
    return string.format("%s  |  %s  |  %s", entry.source, entry.mode, availability)
end

local function showPreviewMessage(entry, bodyText)
    clearPreview()
    if not IsValid(previewRoot) then return end
    local card = previewRoot:Add("DPanel")
    card:SetSize(math.min(math.max(previewRoot:GetWide() - 48, 280), 720), 190)
    card:Center()
    card.Paint = function(_, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(28, 32, 38, 245))
        surface.SetDrawColor(75, 90, 105, 180)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    local title = createLabel(card, entry and entry.class or "Panel Tester", "DermaLarge")
    title:Dock(TOP)
    title:DockMargin(18, 18, 18, 0)
    local body = createLabel(card, bodyText or "", "DermaDefault")
    body:Dock(FILL)
    body:DockMargin(18, 10, 18, 14)
end

local function setupPanel(entry, panel, host)
    if entry.setup then entry.setup(panel, host) end
end

local function createEmbeddedPreview(entry)
    clearPreview()
    if not controlExists(entry.class) then
        showPreviewMessage(entry, "This control is not registered. Load its panel file before previewing it.")
        setStatus("Missing registration: " .. entry.class, false)
        return
    end

    local ok, result = runProtected(function()
        local host = previewRoot:Add("DPanel")
        host:SetSize(math.max(100, math.min(entry.width or 620, previewRoot:GetWide() - 32)), math.max(40, math.min(entry.height or 420, previewRoot:GetTall() - 32)))
        host:Center()
        host.Paint = function(_, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(18, 21, 26, 245))
            surface.SetDrawColor(70, 80, 92, 150)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        local panel = vgui.Create(entry.class, host)
        if not IsValid(panel) then error("vgui.Create returned an invalid panel") end
        panel:SetPos(12, 12)
        panel:SetSize(math.max(1, host:GetWide() - 24), math.max(1, host:GetTall() - 24))
        setupPanel(entry, panel, host)
        panel:InvalidateLayout(true)
        return panel
    end)

    if ok then
        setStatus("Preview ready.", true)
    else
        showPreviewMessage(entry, "Preview failed. The traceback was printed to the console.\n\n" .. tostring(result))
        ErrorNoHalt("[Lilia Panel Tester] " .. tostring(result) .. "\n")
        setStatus("Preview failed. Check console.", false)
    end
end

local function createWrapper(entry)
    local wrapper = vgui.Create("DFrame")
    local width = math.max(280, (entry.width or 720) + 20)
    local height = math.max(120, (entry.height or 520) + 58)
    wrapper:SetSize(math.min(width, ScrW() - 80), math.min(height, ScrH() - 80))
    wrapper:Center()
    wrapper:SetTitle(entry.family .. " Panel: " .. entry.class)
    wrapper:MakePopup()
    wrapper:SetDeleteOnClose(true)
    addActivePanel(wrapper)
    return wrapper
end

local function launchEntry(entry)
    if entry.mode == "integration" then
        showPreviewMessage(entry, entry.warning or "This entry is integration-driven and has no standalone VGUI panel.")
        setStatus("Use this entry through its normal game integration.", false)
        return
    end

    if not controlExists(entry.class) then
        setStatus("Missing registration: " .. entry.class, false)
        return
    end

    local ok, result = runProtected(function()
        if entry.mode == "embedded" then
            local wrapper = createWrapper(entry)
            local panel = vgui.Create(entry.class, wrapper)
            if not IsValid(panel) then error("vgui.Create returned an invalid panel") end
            panel:Dock(FILL)
            panel:DockMargin(10, 10, 10, 10)
            setupPanel(entry, panel, wrapper)
            panel:InvalidateLayout(true)
            return wrapper
        end

        local panel = vgui.Create(entry.class)
        if not IsValid(panel) then error("vgui.Create returned an invalid panel") end
        addActivePanel(panel)
        if entry.width and entry.width > 0 and entry.height and entry.height > 0 then
            panel:SetSize(math.min(entry.width, ScrW() - 40), math.min(entry.height, ScrH() - 40))
            panel:Center()
        end

        setupPanel(entry, panel, panel:GetParent())
        if isfunction(panel.MakePopup) then panel:MakePopup() end
        panel:InvalidateLayout(true)
        return panel
    end)

    if ok then
        setStatus("Opened " .. entry.class .. ".", true)
    else
        ErrorNoHalt("[Lilia Panel Tester] " .. tostring(result) .. "\n")
        setStatus("Launch failed. Check console.", false)
    end
end

local function refreshThemeButtons()
    if not IsValid(themeScroller) then return end
    local themeNames = getThemeNames()
    local signature = table.concat(themeNames, "\31")
    if signature ~= themeButtonSignature then
        for _, button in ipairs(themeButtons) do
            if IsValid(button) then button:Remove() end
        end

        themeButtons = {}
        themeButtonSignature = signature
        for _, themeName in ipairs(themeNames) do
            local name = themeName
            local button = vgui.Create("DButton")
            button:SetSize(132, 34)
            button:SetText("")
            button.Paint = function(s, w, h)
                local accent = getThemeAccent(name)
                local active = selectedTheme == name
                local hovered = s:IsHovered()
                local background = active and Color(accent.r, accent.g, accent.b, 45) or hovered and Color(43, 49, 58, 245) or Color(30, 34, 40, 235)
                draw.RoundedBox(6, 0, 0, w, h, background)
                surface.SetDrawColor(accent.r, accent.g, accent.b, active and 230 or 150)
                surface.DrawOutlinedRect(0, 0, w, h, active and 2 or 1)
                draw.RoundedBox(4, 9, 7, 20, 20, accent)
                draw.SimpleText(name, "DermaDefault", 38, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            button.DoClick = function()
                if not applyTheme(name) then return end
                for _, themeButton in ipairs(themeButtons) do
                    if IsValid(themeButton) then themeButton:InvalidateLayout(true) end
                end

                if selectedEntry and selectedEntry.family == "Lilia" then
                    if selectedEntry.mode == "embedded" then
                        createEmbeddedPreview(selectedEntry)
                    else
                        setStatus("Theme applied to Lilia panels for this tester session.", true)
                    end
                end
            end

            themeScroller:AddPanel(button)
            themeButtons[#themeButtons + 1] = button
        end
    end

    for _, button in ipairs(themeButtons) do
        if IsValid(button) then button:InvalidateLayout(true) end
    end
end

local function updateThemeVisibility()
    local visible = activeFamily == "Lilia" and #getThemeNames() > 0
    if IsValid(themePanel) then
        themePanel:SetVisible(visible)
        themePanel:SetTall(visible and 72 or 0)
        themePanel:DockMargin(0, visible and 10 or 0, 0, 0)
    end

    if visible then refreshThemeButtons() end
end

local function updateSelection(entry)
    selectedEntry = entry
    if not entry then
        if IsValid(previewTitle) then
            previewTitle:SetText("No matching panels")
            previewTitle:SizeToContentsY()
        end

        if IsValid(previewMeta) then
            previewMeta:SetText("")
            previewMeta:SizeToContentsY()
        end

        if IsValid(openButton) then openButton:SetEnabled(false) end
        if IsValid(previewButton) then previewButton:SetEnabled(false) end
        showPreviewMessage(nil, "Try a different search or expand another category.")
        return
    end

    previewTitle:SetText(entry.class)
    previewTitle:SizeToContentsY()
    local details = formatEntryMeta(entry) .. "\n" .. entry.description
    if entry.warning then details = details .. "\nWarning: " .. entry.warning end
    previewMeta:SetText(details)
    previewMeta:SizeToContentsY()
    openButton:SetEnabled(entry.mode ~= "integration" and controlExists(entry.class))
    previewButton:SetEnabled(entry.mode == "embedded" and controlExists(entry.class))
    if entry.mode == "embedded" then
        createEmbeddedPreview(entry)
    else
        local message = entry.description
        if entry.mode == "integration" then
            message = message .. "\n\nUse this through its normal game integration."
        else
            message = message .. "\n\nUse Open Live to instantiate this panel."
        end

        if entry.warning then message = message .. "\n\n" .. entry.warning end
        showPreviewMessage(entry, message)
        if entry.mode == "integration" then
            setStatus("Integration entry selected.", false)
        elseif controlExists(entry.class) then
            setStatus("Ready to open live.", true)
        else
            setStatus("Missing registration: " .. entry.class, false)
        end
    end
end

local function createListButton(parent, entry)
    local button = parent:Add("DButton")
    button:Dock(TOP)
    button:DockMargin(0, 0, 0, 4)
    button:SetTall(40)
    button:SetText("")
    button.Paint = function(s, w, h)
        local selected = selectedEntry == entry
        local hovered = s:IsHovered()
        local background = selected and Color(55, 88, 115, 245) or hovered and Color(43, 49, 58, 245) or Color(31, 35, 42, 235)
        draw.RoundedBox(5, 0, 0, w, h, background)
        local statusColor
        if entry.mode == "integration" then
            statusColor = Color(225, 175, 75)
        elseif controlExists(entry.class) then
            statusColor = Color(95, 210, 135)
        else
            statusColor = Color(225, 90, 90)
        end

        draw.RoundedBox(3, 10, h * 0.5 - 3, 6, 6, statusColor)
        draw.SimpleText(entry.class, "DermaDefault", 24, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    button.DoClick = function() updateSelection(entry) end
    button.DoDoubleClick = function()
        updateSelection(entry)
        launchEntry(entry)
    end
    return button
end

local function getFamilyCategories()
    local categories = {}
    local seen = {}
    for _, entry in ipairs(entries) do
        if entry.family == activeFamily and not seen[entry.category] then
            seen[entry.category] = true
            categories[#categories + 1] = entry.category
        end
    end

    table.sort(categories, function(a, b) return a:lower() < b:lower() end)
    return categories
end

local function setAllCategoriesCollapsed(collapsed)
    collapsedCategories[activeFamily] = collapsedCategories[activeFamily] or {}
    for _, category in ipairs(getFamilyCategories()) do
        collapsedCategories[activeFamily][category] = collapsed
    end
end

local function entryMatchesSearch(entry, term)
    if entry.family ~= activeFamily then return false end
    if term == "" then return true end
    local searchable = string.lower(entry.class .. " " .. entry.source .. " " .. entry.category .. " " .. entry.description)
    return string.find(searchable, term, 1, true) ~= nil
end

local rebuildList
local function createCategoryHeader(parent, category, count, searching)
    local button = parent:Add("DButton")
    button:Dock(TOP)
    button:DockMargin(0, 8, 0, 4)
    button:SetTall(32)
    button:SetText("")
    button.Paint = function(s, w, h)
        local collapsed = not searching and collapsedCategories[activeFamily] and collapsedCategories[activeFamily][category] == true
        local hovered = s:IsHovered()
        draw.RoundedBox(5, 0, 0, w, h, hovered and Color(43, 49, 58, 245) or Color(27, 31, 37, 245))
        surface.SetDrawColor(62, 72, 84, 150)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        draw.SimpleText(collapsed and ">" or "v", "DermaDefaultBold", 12, h * 0.5, Color(175, 190, 205), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(category, "DermaDefaultBold", 28, h * 0.5, Color(205, 214, 224), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(count), "DermaDefault", w - 10, h * 0.5, Color(140, 154, 170), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    button.DoClick = function()
        if searching then return end
        collapsedCategories[activeFamily] = collapsedCategories[activeFamily] or {}
        collapsedCategories[activeFamily][category] = not collapsedCategories[activeFamily][category]
        rebuildList()
    end
    return button
end

rebuildList = function()
    if not IsValid(listCanvas) then return end
    listCanvas:Clear()
    local term = IsValid(searchEntry) and string.Trim(string.lower(searchEntry:GetValue() or "")) or ""
    local searching = term ~= ""
    local grouped = {}
    local categoryOrder = {}
    local firstVisible
    local selectedMatches = false
    local totalVisible = 0
    for _, entry in ipairs(getSortedEntries()) do
        if entryMatchesSearch(entry, term) then
            if not grouped[entry.category] then
                grouped[entry.category] = {}
                categoryOrder[#categoryOrder + 1] = entry.category
            end

            grouped[entry.category][#grouped[entry.category] + 1] = entry
            totalVisible = totalVisible + 1
            firstVisible = firstVisible or entry
            if selectedEntry == entry then selectedMatches = true end
        end
    end

    for _, category in ipairs(categoryOrder) do
        local categoryEntries = grouped[category]
        createCategoryHeader(listCanvas, category, #categoryEntries, searching)
        local collapsed = not searching and collapsedCategories[activeFamily] and collapsedCategories[activeFamily][category] == true
        if not collapsed then
            for _, entry in ipairs(categoryEntries) do
                createListButton(listCanvas, entry)
            end
        end
    end

    if IsValid(countLabel) then
        countLabel:SetText(string.format("%d %s in %d %s", totalVisible, totalVisible == 1 and "panel" or "panels", #categoryOrder, #categoryOrder == 1 and "category" or "categories"))
        countLabel:SizeToContentsY()
    end

    if not selectedMatches then updateSelection(firstVisible) end
end

local function setFamily(family)
    if activeFamily == family then return end
    activeFamily = family
    selectedEntry = nil
    for _, button in pairs(familyButtons) do
        if IsValid(button) then button:InvalidateLayout(true) end
    end

    updateThemeVisibility()
    rebuildList()
end

local function createFamilyButton(parent, family, label)
    local button = parent:Add("DButton")
    button:Dock(LEFT)
    button:SetWide(150)
    button:DockMargin(0, 0, 8, 0)
    button:SetText("")
    button.Paint = function(s, w, h)
        local active = activeFamily == family
        local hovered = s:IsHovered()
        local background = active and Color(55, 88, 115, 245) or hovered and Color(39, 45, 54, 245) or Color(27, 31, 37, 235)
        draw.RoundedBox(6, 0, 0, w, h, background)
        if active then
            surface.SetDrawColor(100, 165, 230, 230)
            surface.DrawRect(0, h - 2, w, 2)
        end

        draw.SimpleText(label, "DermaDefaultBold", w * 0.5, h * 0.5, active and color_white or Color(175, 187, 201), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    button.DoClick = function() setFamily(family) end
    familyButtons[family] = button
    return button
end

local function buildTester()
    if IsValid(testerFrame) then testerFrame:Remove() end
    if lia and lia.color and istable(lia.color.theme) then originalTheme = table.Copy(lia.color.theme) end
    if lia and lia.color and isfunction(lia.color.getCurrentTheme) then selectedTheme = lia.color.getCurrentTheme() end
    activeFamily = "Lilia"
    selectedEntry = nil
    familyButtons = {}
    themeButtons = {}
    themeButtonSignature = ""
    collapsedCategories = {
        Lilia = {},
        GMOD = {}
    }

    testerFrame = vgui.Create("DFrame")
    testerFrame:SetSize(math.min(1420, ScrW() - 60), math.min(900, ScrH() - 60))
    testerFrame:Center()
    testerFrame:SetTitle("Panel Tester")
    testerFrame:SetDeleteOnClose(false)
    testerFrame:MakePopup()
    testerFrame.OnClose = function()
        closeActivePanels()
        restoreTheme()
        testerFrame:SetVisible(false)
    end

    testerFrame.OnRemove = function()
        closeActivePanels()
        restoreTheme()
    end

    local root = testerFrame:Add("DPanel")
    root:Dock(FILL)
    root:DockMargin(8, 8, 8, 8)
    root.Paint = function(_, w, h)
        surface.SetDrawColor(19, 22, 27, 255)
        surface.DrawRect(0, 0, w, h)
    end

    local familyBar = root:Add("DPanel")
    familyBar:Dock(TOP)
    familyBar:SetTall(48)
    familyBar:DockPadding(10, 7, 10, 7)
    familyBar.Paint = function(_, w, h)
        surface.SetDrawColor(24, 28, 34, 255)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(62, 72, 84, 150)
        surface.DrawRect(0, h - 1, w, 1)
    end

    createFamilyButton(familyBar, "Lilia", "Lilia Panels")
    createFamilyButton(familyBar, "GMOD", "Garry's Mod")
    local body = root:Add("DPanel")
    body:Dock(FILL)
    body.Paint = nil
    local sidebar = body:Add("DPanel")
    sidebar:Dock(LEFT)
    sidebar:SetWide(300)
    sidebar:DockPadding(10, 10, 10, 10)
    sidebar.Paint = function(_, w, h)
        surface.SetDrawColor(24, 28, 34, 255)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(62, 72, 84, 160)
        surface.DrawRect(w - 1, 0, 1, h)
    end

    searchEntry = sidebar:Add("DTextEntry")
    searchEntry:Dock(TOP)
    searchEntry:SetTall(34)
    searchEntry:SetPlaceholderText("Search panels")
    searchEntry.OnChange = rebuildList
    countLabel = createLabel(sidebar, "", "DermaDefault")
    countLabel:Dock(TOP)
    countLabel:DockMargin(4, 8, 4, 5)
    countLabel:SetTextColor(Color(150, 160, 172))
    local categoryActions = sidebar:Add("DPanel")
    categoryActions:Dock(TOP)
    categoryActions:SetTall(28)
    categoryActions:DockMargin(0, 0, 0, 4)
    categoryActions.Paint = nil
    local expandAll = categoryActions:Add("DButton")
    expandAll:Dock(LEFT)
    expandAll:SetWide(92)
    expandAll:SetText("Expand all")
    expandAll.DoClick = function()
        setAllCategoriesCollapsed(false)
        rebuildList()
    end

    local collapseAll = categoryActions:Add("DButton")
    collapseAll:Dock(LEFT)
    collapseAll:DockMargin(6, 0, 0, 0)
    collapseAll:SetWide(92)
    collapseAll:SetText("Collapse all")
    collapseAll.DoClick = function()
        setAllCategoriesCollapsed(true)
        rebuildList()
    end

    local list = sidebar:Add("DScrollPanel")
    list:Dock(FILL)
    listCanvas = list:GetCanvas()
    listCanvas:DockPadding(0, 0, 4, 0)
    local content = body:Add("DPanel")
    content:Dock(FILL)
    content:DockPadding(16, 14, 16, 16)
    content.Paint = nil
    previewTitle = createLabel(content, "Select a panel", "DermaLarge")
    previewTitle:Dock(TOP)
    previewTitle:SetTextColor(Color(235, 240, 245))
    previewMeta = createLabel(content, "", "DermaDefault")
    previewMeta:Dock(TOP)
    previewMeta:DockMargin(0, 5, 0, 9)
    previewMeta:SetTextColor(Color(170, 180, 192))
    local actions = content:Add("DPanel")
    actions:Dock(TOP)
    actions:SetTall(36)
    actions.Paint = nil
    previewButton = createSampleButton(actions, "Preview")
    previewButton:Dock(LEFT)
    previewButton:SetWide(100)
    previewButton.DoClick = function() if selectedEntry then createEmbeddedPreview(selectedEntry) end end
    openButton = createSampleButton(actions, "Open Live")
    openButton:Dock(LEFT)
    openButton:DockMargin(7, 0, 0, 0)
    openButton:SetWide(100)
    openButton.DoClick = function() if selectedEntry then launchEntry(selectedEntry) end end
    local closeButton = createSampleButton(actions, "Close Spawned")
    closeButton:Dock(LEFT)
    closeButton:DockMargin(7, 0, 0, 0)
    closeButton:SetWide(118)
    closeButton.DoClick = function()
        closeActivePanels()
        setStatus("Closed tester-spawned panels.", true)
    end

    local refreshButton = createSampleButton(actions, "Refresh")
    refreshButton:Dock(RIGHT)
    refreshButton:SetWide(92)
    refreshButton.DoClick = function()
        rebuildList()
        if selectedEntry then updateSelection(selectedEntry) end
    end

    themePanel = content:Add("DPanel")
    themePanel:Dock(TOP)
    themePanel:DockMargin(0, 10, 0, 0)
    themePanel:SetTall(72)
    themePanel.Paint = function(_, w, h)
        draw.RoundedBox(7, 0, 0, w, h, Color(24, 28, 34, 235))
        surface.SetDrawColor(62, 72, 84, 120)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    local themeLabel = createLabel(themePanel, "Lilia Theme Preview", "DermaDefaultBold")
    themeLabel:SetPos(10, 7)
    themeLabel:SetSize(180, 18)
    themeLabel:SetTextColor(Color(205, 214, 224))
    local resetTheme = themePanel:Add("DButton")
    resetTheme:SetText("Reset")
    resetTheme:SetSize(64, 24)
    resetTheme:SetPos(196, 4)
    resetTheme.DoClick = function()
        restoreTheme()
        if lia and lia.color and isfunction(lia.color.getCurrentTheme) then selectedTheme = lia.color.getCurrentTheme() end
        refreshThemeButtons()
        if selectedEntry and selectedEntry.family == "Lilia" and selectedEntry.mode == "embedded" then createEmbeddedPreview(selectedEntry) end
    end

    themeScroller = themePanel:Add("DHorizontalScroller")
    themeScroller:SetPos(10, 30)
    themeScroller:SetTall(36)
    themeScroller:SetOverlap(-4)
    themePanel.PerformLayout = function(_, w) themeScroller:SetWide(math.max(w - 20, 1)) end
    previewStatus = createLabel(content, "", "DermaDefaultBold")
    previewStatus:Dock(TOP)
    previewStatus:DockMargin(0, 8, 0, 8)
    previewRoot = content:Add("DPanel")
    previewRoot:Dock(FILL)
    previewRoot.Paint = function(_, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(14, 17, 21, 255))
        surface.SetDrawColor(52, 61, 72, 160)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    updateThemeVisibility()
    rebuildList()
end

concommand.Add("lia_panel_tester", buildTester, nil, "Open the split Lilia and Garry's Mod VGUI panel tester with collapsible categories")
hook.Add("OnGamemodeLoaded", "liaPanelTesterV4Ready", function()
    if IsValid(testerFrame) then
        updateThemeVisibility()
        rebuildList()
    end
end)