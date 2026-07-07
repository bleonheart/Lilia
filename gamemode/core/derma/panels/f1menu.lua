--[[
    Hooks:
        F1MenuOpened(Panel self)

    Purpose:
        Runs after the F1 menu panel is created and registered as the active menu interface.

    Category:
        UI

    Parameters:
        self (Panel)
            The newly created F1 menu panel.

    Example Usage:
        ```lua
        hook.Add("F1MenuOpened", "liaExampleF1MenuOpened", function(self)
            self:SetAlpha(255)
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        F1MenuClosed()

    Purpose:
        Runs when the active F1 menu panel is being removed and its UI state is shutting down.

    Category:
        UI

    Parameters:
        None

    Example Usage:
        ```lua
        hook.Add("F1MenuClosed", "liaExampleF1MenuClosed", function()
            print("F1 menu closed")
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        LoadCharInformation()

    Purpose:
        Runs while the F1 character information panel is being initialized so modules can register sections and fields before the UI is generated.

    Category:
        UI

    Parameters:
        None

    Example Usage:
        ```lua
        hook.Add("LoadCharInformation", "liaExampleLoadCharInformation", function()
            hook.Run("AddSection", "Example", Color(255, 255, 255), 10, 1)
            hook.Run("AddTextField", "Example", "exampleField", "Example Field", function()
                return "Example Value"
            end)
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        AddSection(string sectionName, Color|nil color, number|nil priority, number|nil location)

    Purpose:
        Registers or updates a character information section in the F1 menu before fields are inserted into it.

    Category:
        UI

    Parameters:
        sectionName (string)
            The section identifier or localized display name used as the section key.

        color (Color|nil)
            The color stored with the section data.

        priority (number|nil)
            The sort priority used when the F1 menu orders sections.

        location (number|nil)
            The stored location value for the section entry.

    Example Usage:
        ```lua
        hook.Add("AddSection", "liaExampleAddSection", function(sectionName, color, priority, location)
            if sectionName == "Example" then
                print(sectionName, priority, location)
            end
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        AddTextField(string sectionName, string fieldName, string labelText, function valueFunc)

    Purpose:
        Adds a text field definition to an existing F1 character information section when that field name has not already been registered.

    Category:
        UI

    Parameters:
        sectionName (string)
            The section identifier or localized display name that should receive the field.

        fieldName (string)
            The unique field key stored on the section definition.

        labelText (string)
            The label shown beside the text entry.

        valueFunc (function)
            A callback that returns the current string value for the field.

    Example Usage:
        ```lua
        hook.Add("AddTextField", "liaExampleAddTextField", function(sectionName, fieldName, labelText, valueFunc)
            if sectionName == L("generalInfo") and fieldName == "name" then
                print(labelText, valueFunc())
            end
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        AddBarField(string sectionName, string fieldName, string labelText, function|number|nil minFunc, function|number|nil maxFunc, function|number|nil valueFunc)

    Purpose:
        Adds a progress-bar field definition to an existing F1 character information section when that field name has not already been registered.

    Category:
        UI

    Parameters:
        sectionName (string)
            The section identifier or localized display name that should receive the bar field.

        fieldName (string)
            The unique field key stored on the section definition.

        labelText (string)
            The label shown beside the progress bar.

        minFunc (function|number|nil)
            A callback or numeric value that supplies the bar minimum.

        maxFunc (function|number|nil)
            A callback or numeric value that supplies the bar maximum.

        valueFunc (function|number|nil)
            A callback or numeric value that supplies the current bar value.

    Example Usage:
        ```lua
        hook.Add("AddBarField", "liaExampleAddBarField", function(sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
            if sectionName == L("attributesModuleName") and fieldName == "stm" then
                print(labelText, minFunc(), maxFunc(), valueFunc())
            end
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        CreateInformationButtons(table pages)

    Purpose:
        Allows modules to register information-tab pages for the F1 menu before they are filtered, sorted, and rendered.

    Category:
        UI

    Parameters:
        pages (table)
            The mutable array of page definitions consumed by the information tab builder.

    Example Usage:
        ```lua
        hook.Add("CreateInformationButtons", "liaExampleCreateInformationButtons", function(pages)
            pages[#pages + 1] = {
                name = "exampleInfo",
                drawFunc = function(parent)
                    parent:Clear()
                end
            }
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        PopulateConfigurationButtons(table pages)

    Purpose:
        Allows modules to register settings pages for the F1 configuration tab before the menu filters, sorts, and renders them.

    Category:
        UI

    Parameters:
        pages (table)
            The mutable array of configuration page definitions that the settings tab consumes.

    Example Usage:
        ```lua
        hook.Add("PopulateConfigurationButtons", "liaExamplePopulateConfigurationButtons", function(pages)
            pages[#pages + 1] = {
                name = "Example Settings",
                drawFunc = function(parent)
                    parent:Clear()
                end
            }
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        CanDisplayCharInfo(string name)

    Purpose:
        Allows the F1 character information panel to veto specific character information fields before they are shown.

    Category:
        UI

    Parameters:
        name (string)
            The field identifier being considered for display.

    Example Usage:
        ```lua
        hook.Add("CanDisplayCharInfo", "liaExampleCanDisplayCharInfo", function(name)
            if name == "class" then return false end
        end)
        ```

    Returns:
        boolean|nil
            Return false to hide the named field. Return nil or true to leave the field available.

    Realm:
        Client
]]
local PANEL = {}
local function localizeMenuLabel(value, ...)
    if not isstring(value) then return value end
    local resolved = lia.lang.resolveToken(value, ...)
    if resolved ~= value then return resolved end
    return L(value, ...)
end

local function normalizeCharInfoSectionName(value)
    if not isstring(value) then return "" end
    return value:lower():gsub("[^%w]", "")
end

local function resolveCharInfoSectionName(sectionName)
    if not IsValid(lia.gui.info) then return sectionName end
    local localizedSectionName = isstring(sectionName) and L(sectionName) or sectionName
    if lia.gui.info.CharacterInformation[localizedSectionName] then return localizedSectionName end
    local candidates = {}
    if isstring(localizedSectionName) then candidates[#candidates + 1] = normalizeCharInfoSectionName(localizedSectionName) end
    if isstring(sectionName) and sectionName ~= localizedSectionName then candidates[#candidates + 1] = normalizeCharInfoSectionName(sectionName) end
    for existingName in pairs(lia.gui.info.CharacterInformation) do
        if isstring(existingName) then
            local normalizedExisting = normalizeCharInfoSectionName(existingName)
            for _, candidate in ipairs(candidates) do
                if candidate ~= "" and candidate == normalizedExisting then return existingName end
            end
        end
    end

    for existingName in pairs(lia.gui.info.CharacterInformation) do
        if isstring(existingName) then
            local normalizedExisting = normalizeCharInfoSectionName(existingName)
            for _, candidate in ipairs(candidates) do
                if candidate ~= "" and normalizedExisting ~= "" and (candidate:find(normalizedExisting, 1, true) or normalizedExisting:find(candidate, 1, true)) then return existingName end
            end
        end
    end
    return localizedSectionName
end

local function getThemeColors()
    local theme = lia.color.theme or {}
    local accent = theme.accent or theme.theme or lia.config.get("Color") or Color(45, 190, 170)
    local text = theme.text or Color(225, 238, 238)
    return accent, text
end

local function drawPanel(x, y, w, h, radius, color, outline)
    lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
    if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
end

local function drawIcon(material, x, y, size, color)
    if not material or material:IsError() then return end
    surface.SetMaterial(material)
    surface.SetDrawColor(color or color_white)
    surface.DrawTexturedRect(x, y, size, size)
end

local function resolveIconMaterial(icon, fallback)
    if not icon then return fallback end
    if type(icon) == "IMaterial" then return icon end
    if isstring(icon) and icon ~= "" then return Material(icon, "smooth") end
    return fallback
end

local function getFieldValue(panel, name)
    for _, data in pairs(panel.CharacterInformation or {}) do
        local fields = isfunction(data.fields) and data.fields() or data.fields
        for _, field in ipairs(fields or {}) do
            if field.name == name then
                local value = isfunction(field.value) and field.value() or field.value
                return value ~= nil and tostring(value) or ""
            end
        end
    end
    return ""
end

local fieldIcons = {
    name = Material("icon16/user.png", "smooth"),
    desc = Material("icon16/page_white_text.png", "smooth"),
    description = Material("icon16/page_white_text.png", "smooth"),
    money = Material("icon16/money.png", "smooth"),
    playtime = Material("icon16/time.png", "smooth"),
    loyaltytier = Material("icon16/star.png", "smooth"),
    faction = Material("icon16/building.png", "smooth"),
    class = Material("icon16/briefcase.png", "smooth")
}

local sidebarIcons = {
    ["@admin"] = Material("icon16/shield.png", "smooth"),
    ["@characters"] = Material("icon16/user.png", "smooth"),
    ["@classes"] = Material("icon16/group.png", "smooth"),
    ["@information"] = Material("icon16/information.png", "smooth"),
    ["@inventory"] = Material("icon16/box.png", "smooth"),
    ["@logisticslogs"] = Material("icon16/page_white_text.png", "smooth"),
    ["@logisticsstorage"] = Material("icon16/database.png", "smooth"),
    ["@settings"] = Material("icon16/cog.png", "smooth"),
    ["@themes"] = Material("icon16/color_wheel.png", "smooth"),
    ["@you"] = Material("icon16/user.png", "smooth")
}

local function drawcirclepoly(w, h)
    local poly = {}
    local x, y = w / 2, h / 2
    local radius = math.min(w, h) / 2
    for angle = 1, 360 do
        local rad = math.rad(angle)
        poly[#poly + 1] = {
            x = x + math.cos(rad) * radius,
            y = y + math.sin(rad) * radius
        }
    end
    return poly
end

local CIRCULAR_AVATAR = {}
function CIRCULAR_AVATAR:Init()
    self.base = vgui.Create("AvatarImage", self)
    self.base:Dock(FILL)
    self.base:SetPaintedManually(true)
end

function CIRCULAR_AVATAR:GetBase()
    return self.base
end

function CIRCULAR_AVATAR:PushMask(mask)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
    mask()
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
end

function CIRCULAR_AVATAR:PopMask()
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function CIRCULAR_AVATAR:OnSizeChanged(w, h)
    self.poly = drawcirclepoly(w, h)
end

function CIRCULAR_AVATAR:Paint(w, h)
    self.poly = self.poly or drawcirclepoly(w, h)
    self:PushMask(function()
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawPoly(self.poly)
    end)

    self.base:PaintManual()
    self:PopMask()
end

function CIRCULAR_AVATAR:SetPlayer(pl, size)
    self.base:SetPlayer(pl, size)
end

vgui.Register("CircularAvatar", CIRCULAR_AVATAR, "Panel")
PANEL = {}
function PANEL:Init()
    if IsValid(lia.gui.info) then lia.gui.info:Remove() end
    lia.gui.info = self
    self:Dock(FILL)
    self.Paint = function() end
    self.CharacterInformation = {}
    self.cards = {}
    hook.Run("LoadCharInformation")
    hook.Add("OnThemeChanged", self, self.OnThemeChanged)
    self.header = self:Add("DPanel")
    self.header:Dock(TOP)
    self.header:SetTall(224)
    self.header:DockMargin(0, 0, 0, 16)
    self.header.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 10, Color(8, 21, 26, 238), Color(accent.r, accent.g, accent.b, 72))
        surface.SetDrawColor(255, 255, 255, 5)
        surface.DrawRect(18, h - 1, w - 36, 1)
    end

    self.avatarWrap = self.header:Add("DPanel")
    self.avatarWrap:SetSize(166, 166)
    self.avatarWrap:SetPos(28, 29)
    self.avatarWrap.Paint = function() end

    self.avatar = self.avatarWrap:Add("CircularAvatar")
    self.avatar:SetSize(166, 166)
    self.avatar:SetPos(0, 0)
    self.avatar:SetPlayer(LocalPlayer(), 184)
    self.identity = self.header:Add("DPanel")
    self.identity:SetPos(222, 43)
    self.identity:SetSize(560, 145)
    self.identity.Paint = function() end
    self.characterName = self.identity:Add("DLabel")
    self.characterName:SetFont("LiliaFont.30")
    self.characterName:SetTextColor(Color(242, 247, 247))
    self.characterName:SetPos(0, 6)
    self.characterName:SetSize(550, 40)
    self.characterSubtitle = self.identity:Add("DLabel")
    self.characterSubtitle:SetFont("LiliaFont.20")
    self.characterSubtitle:SetPos(0, 50)
    self.characterSubtitle:SetSize(550, 28)
    self.chips = self.identity:Add("DPanel")
    self.chips:SetPos(0, 92)
    self.chips:SetSize(550, 38)
    self.chips.Paint = function() end
    self.stats = self.header:Add("DPanel")
    self.stats:Dock(RIGHT)
    self.stats:SetWide(526)
    self.stats:DockMargin(0, 29, 28, 29)
    self.stats.Paint = function() end
    self.moneyCard = self:CreateStatCard(self.stats, L("money"), Material("icon16/money.png", "smooth"), function() return getFieldValue(self, "money") end)
    self.moneyCard:Dock(LEFT)
    self.moneyCard:SetWide(252)
    self.moneyCard:DockMargin(0, 0, 16, 0)
    self.playCard = self:CreateStatCard(self.stats, L("playtime"), Material("icon16/time.png", "smooth"), function() return getFieldValue(self, "playTime") end)
    self.playCard:Dock(FILL)
    self.scroll = self:Add("liaScrollPanel")
    self.scroll:Dock(FILL)
    self.scroll.Paint = function() end
    local canvas = self.scroll:GetCanvas()
    canvas:DockPadding(0, 0, 0, 12)
    canvas.Paint = function() end
    self.content = canvas
    local function tryGenerate()
        if not IsValid(self) then return end
        local char = LocalPlayer():getChar()
        if char and not table.IsEmpty(self.CharacterInformation or {}) then
            self:Refresh()
        else
            timer.Simple(0.1, tryGenerate)
        end
    end

    timer.Simple(0.1, tryGenerate)
    timer.Create("liaCharInfo_UpdateValues", 1, 0, function()
        if IsValid(self) then
            self:setup()
        else
            timer.Remove("liaCharInfo_UpdateValues")
        end
    end)
end

function PANEL:CreateStatCard(parent, title, icon, valueFunc)
    local card = parent:Add("DPanel")
    card.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 9, Color(9, 24, 29, 238), Color(accent.r, accent.g, accent.b, 80))
        drawIcon(icon, 22, 20, 40, accent)
        draw.SimpleText(string.upper(title), "LiliaFont.17", 76, 28, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(valueFunc() or "", "LiliaFont.25", 22, h - 60, Color(242, 247, 247), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    return card
end

function PANEL:BuildIdentity()
    local client = LocalPlayer()
    local char = client:getChar()
    if not char then return end
    local accent = getThemeColors()
    self.characterName:SetText(char:getName() or L("unknown"))
    self.characterSubtitle:SetText(team.GetName(client:Team()) or L("unknown"))
    self.characterSubtitle:SetTextColor(accent)
    self.chips:Clear()
    local className = L("none")
    local classIndex = char:getClass()
    local classData = classIndex and lia.class.list[classIndex]
    if classData and classData.name then className = L(classData.name) end
    local loyalty = getFieldValue(self, "loyaltyTier")
    if loyalty == "" then loyalty = L("noTier") end
    local values = {{loyalty, Material("icon16/star.png", "smooth")}, {team.GetName(client:Team()) or L("none"), Material("icon16/building.png", "smooth")}, {className, Material("icon16/briefcase.png", "smooth")}}
    for _, data in ipairs(values) do
        local chip = self.chips:Add("DPanel")
        chip:Dock(LEFT)
        chip:SetWide(154)
        chip:DockMargin(0, 0, 10, 0)
        chip.Paint = function(_, w, h)
            drawPanel(0, 0, w, h, 6, Color(13, 30, 35, 225), Color(accent.r, accent.g, accent.b, 58))
            drawIcon(data[2], 14, 11, 16, Color(185, 205, 205))
            draw.SimpleText(data[1], "LiliaFont.17", 40, h * 0.5, Color(210, 224, 224), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:CreateTextEntryWithBackgroundAndLabel(parent, name, labelText, marginBot, valueFunc)
    local entry = parent:Add("DPanel")
    entry:Dock(FILL)
    entry.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 8, Color(10, 25, 30, 232), Color(accent.r, accent.g, accent.b, 45))
        local icon = fieldIcons[normalizeCharInfoSectionName(name)]
        drawIcon(icon, 22, math.floor(h * 0.5) - 22, 44, accent)
    end

    local lbl = entry:Add("DLabel")
    lbl:SetFont("LiliaFont.17")
    lbl:SetText(labelText or "")
    lbl:SetTextColor(Color(165, 187, 188))
    lbl:SetPos(84, 13)
    lbl:SetSize(260, 22)
    local txt = entry:Add("DTextEntry")
    txt:SetPos(84, 39)
    txt:SetTall(30)
    txt:SetFont("LiliaFont.18")
    txt:SetTextColor(Color(230, 239, 239))
    txt:SetCursorColor(getThemeColors())
    txt:SetDrawBackground(false)
    txt:SetPaintBackground(false)
    txt:SetPaintBorderEnabled(false)
    local isDesc = (name or ""):lower() == "desc"
    txt:SetEditable(isDesc)
    if isfunction(valueFunc) then
        local value = valueFunc()
        if value ~= nil then txt:SetValue(tostring(value)) end
    end

    entry.PerformLayout = function(s) txt:SetWide(math.max(s:GetWide() - 100, 80)) end
    local function submitDescription()
        if not isDesc then return end
        local value = txt:GetValue()
        if not isstring(value) then return end
        if txt.lastValue == value then return end
        local trimmedValue = string.Trim(value)
        local valueWithoutSpaces = string.gsub(trimmedValue, "%s", "")
        local minLength = lia.config.get("MinDescLen", 16)
        if #valueWithoutSpaces < minLength then
            local now = CurTime()
            txt.lastErrorTime = txt.lastErrorTime or 0
            if now - txt.lastErrorTime > 1 then
                LocalPlayer():notifyErrorLocalized("descMinLen", minLength)
                txt.lastErrorTime = now
            end
            return
        end

        txt.lastValue = value
        lia.command.send("chardesc", value)
    end

    txt.OnEnter = submitDescription
    txt.OnLoseFocus = submitDescription
    self[name] = txt
    self.cards[#self.cards + 1] = entry
end

function PANEL:CreateFillableBarWithBackgroundAndLabel(parent, name, labelText, minFunc, maxFunc, margin, valueFunc)
    local entry = parent:Add("DPanel")
    entry:Dock(FILL)
    entry.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 8, Color(10, 25, 30, 232), Color(accent.r, accent.g, accent.b, 45))
        draw.SimpleText(labelText or "", "LiliaFont.17", 16, 14, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local bar = entry:Add("liaProgressBar")
    bar:SetPos(16, 48)
    bar:SetTall(22)
    entry.PerformLayout = function(s) bar:SetWide(math.max(s:GetWide() - 32, 80)) end
    bar:SetBarColor(getThemeColors())
    bar.Think = function(barSelf)
        local mn = isfunction(minFunc) and minFunc() or tonumber(minFunc) or 0
        local mx = isfunction(maxFunc) and maxFunc() or tonumber(maxFunc) or 1
        local val = isfunction(valueFunc) and valueFunc() or tonumber(valueFunc) or 0
        barSelf:SetFraction(mx > mn and math.Clamp((val - mn) / (mx - mn), 0, 1) or 0)
        barSelf:SetText(L("barProgress", math.Round(val), math.Round(mx)))
    end

    parent[name] = bar
    self.cards[#self.cards + 1] = entry
    return bar
end

function PANEL:GenerateSections()
    self.cards = {}
    if table.IsEmpty(self.CharacterInformation) then return end
    local sections = {}
    for name, data in pairs(self.CharacterInformation) do
        sections[#sections + 1] = {
            name = name,
            data = data
        }
    end

    table.sort(sections, function(a, b) return a.data.priority < b.data.priority end)
    for _, section in ipairs(sections) do
        local fields = isfunction(section.data.fields) and section.data.fields() or section.data.fields
        local fieldCount = #(fields or {})
        local frame = self.content:Add("DPanel")
        frame:Dock(TOP)
        frame:DockMargin(0, 0, 0, 14)
        frame:DockPadding(14, 54, 14, 14)
        frame.Paint = function(_, w, h)
            local accent = getThemeColors()
            drawPanel(0, 0, w, h, 10, Color(8, 21, 26, 235), Color(accent.r, accent.g, accent.b, 62))
            drawIcon(Material("icon16/information.png", "smooth"), 17, 17, 16, accent)
            draw.SimpleText(string.upper(L(section.name)), "LiliaFont.18", 43, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        local grid = frame:Add("DPanel")
        grid:Dock(FILL)
        grid.cards = {}
        grid.Paint = function() end
        for _, field in ipairs(fields or {}) do
            local holder = grid:Add("DPanel")
            holder.Paint = function() end
            grid.cards[#grid.cards + 1] = holder
            if field.type == "text" then
                self:CreateTextEntryWithBackgroundAndLabel(holder, field.name, L(field.label or ""), 0, field.value)
            elseif field.type == "bar" then
                self:CreateFillableBarWithBackgroundAndLabel(holder, field.name, L(field.label or ""), field.min, field.max, 0, field.value)
            end
        end

        grid.PerformLayout = function(s, w)
            local gap = 12
            local columns = w >= 640 and 2 or 1
            local cardW = columns == 2 and math.floor((w - gap) * 0.5) or w
            for i, card in ipairs(s.cards) do
                local index = i - 1
                local column = index % columns
                local row = math.floor(index / columns)
                card:SetPos(column * (cardW + gap), row * 100)
                card:SetSize(cardW, 88)
            end
        end

        frame.PerformLayout = function(s, w)
            local innerW = math.max(w - 28, 1)
            local columns = innerW >= 640 and 2 or 1
            local rows = math.max(math.ceil(fieldCount / columns), 1)
            s:SetTall(72 + rows * 100)
        end
    end
end

function PANEL:OnRemove()
    hook.Remove("OnThemeChanged", self)
end

function PANEL:OnThemeChanged()
    if IsValid(self) then self:Refresh() end
end

function PANEL:Refresh()
    self:ApplyCurrentTheme()
    self.content:Clear()
    self:BuildIdentity()
    self:GenerateSections()
    self:setup()
end

function PANEL:ApplyCurrentTheme()
    local currentTheme = lia.color.getCurrentTheme()
    if currentTheme and lia.color.themes[currentTheme] then lia.color.theme = table.Copy(lia.color.themes[currentTheme]) end
end

function PANEL:setup()
    if table.IsEmpty(self.CharacterInformation) then return end
    self:BuildIdentity()
    for _, data in pairs(self.CharacterInformation) do
        local fields = isfunction(data.fields) and data.fields() or data.fields
        for _, field in ipairs(fields or {}) do
            local ctrl = self[field.name]
            if ctrl and field.type == "text" and field.name:lower() ~= "desc" then
                local value = isfunction(field.value) and field.value() or field.value
                ctrl:SetValue(value ~= nil and tostring(value) or "")
            end
        end
    end
end

vgui.Register("liaCharInfo", PANEL, "EditablePanel")
PANEL = {}
function PANEL:Init()
    lia.gui.menu = self
    hook.Run("F1MenuOpened", self)
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.25, 0)
    self:SetPopupStayAtBack(true)
    self.noAnchor = CurTime() + 0.4
    self.anchorMode = true
    self.invKey = lia.keybind.get(L("openInventory"), KEY_I)
    hook.Add("OnThemeChanged", self, self.OnThemeChanged)
    self.topBar = self:Add("DPanel")
    self.topBar:Dock(TOP)
    self.topBar:SetTall(78)
    local schemaIconMat = SCHEMA and SCHEMA.icon and Material(SCHEMA.icon, "smooth") or Material("lilia.png", "smooth")
    local schemaName = SCHEMA and SCHEMA.name or "Mojave Reborn"
    self.topBar.Paint = function(_, w, h)
        local accent = getThemeColors()
        surface.SetDrawColor(4, 13, 17, 250)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(255, 255, 255, 4)
        surface.DrawRect(0, 0, w, 1)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 190)
        surface.DrawRect(0, h - 2, w, 2)
        surface.SetMaterial(schemaIconMat)
        surface.SetDrawColor(255, 255, 255, 245)
        surface.DrawTexturedRect(26, 13, 46, 46)
        draw.SimpleText(L(schemaName), "LiliaFont.25", 84, h * 0.5, Color(244, 248, 248), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.headerUtility = self.topBar:Add("DPanel")
    self.headerUtility:SetSize(668, 58)
    self.headerUtility:SetZPos(50)
    self.headerUtility.Paint = function(_, w, h)
        local accent = getThemeColors()
        surface.SetDrawColor(accent.r, accent.g, accent.b, 230)
        surface.DrawRect(8, 25, 8, 8)
        surface.SetDrawColor(255, 255, 255, 24)
        surface.DrawRect(108, 11, 1, h - 22)
        surface.DrawRect(232, 11, 1, h - 22)
        surface.DrawRect(296, 11, 1, h - 22)
        surface.DrawRect(360, 11, 1, h - 22)
        surface.DrawRect(424, 11, 1, h - 22)
        surface.DrawRect(488, 11, 1, h - 22)
        surface.DrawRect(552, 11, 1, h - 22)
        surface.DrawRect(616, 11, 1, h - 22)
    end

    self.onlineLabel = self.headerUtility:Add("DLabel")
    self.onlineLabel:SetFont("LiliaFont.17")
    self.onlineLabel:SetTextColor(Color(220, 232, 232))
    self.onlineLabel:SetContentAlignment(4)
    self.onlineLabel:SetPos(22, 0)
    self.onlineLabel:SetSize(78, 58)
    self.timeIcon = self.headerUtility:Add("DPanel")
    self.timeIcon:SetPos(118, 0)
    self.timeIcon:SetSize(28, 58)
    self.timeIcon.Paint = function(_, w, h) drawIcon(Material("icon16/time.png", "smooth"), 4, math.floor(h * 0.5) - 10, 20, Color(170, 195, 195)) end
    self.timeLabel = self.headerUtility:Add("DLabel")
    self.timeLabel:SetFont("LiliaFont.17")
    self.timeLabel:SetTextColor(Color(220, 232, 232))
    self.timeLabel:SetContentAlignment(4)
    self.timeLabel:SetPos(148, 0)
    self.timeLabel:SetSize(78, 58)
    self.charactersButton = self.headerUtility:Add("DButton")
    self.charactersButton:SetSize(58, 58)
    self.charactersButton:SetPos(238, 0)
    self.charactersButton:SetText("")
    self.charactersButton:SetTooltip(localizeMenuLabel("characters"))
    self.charactersButton.Paint = function(s, w, h)
        local accent = getThemeColors()
        if s:IsHovered() then drawPanel(6, 6, w - 12, h - 12, 7, Color(accent.r, accent.g, accent.b, 24), Color(accent.r, accent.g, accent.b, 70)) end
        drawIcon(Material("icon16/user.png", "smooth"), 17, 17, 24, s:IsHovered() and accent or Color(185, 203, 203))
    end

    self.charactersButton.DoClick = function() if self.tabList and self.tabList["characters"] then self:setActiveTab("characters") end end
    self.adminButton = self.headerUtility:Add("DButton")
    self.adminButton:SetSize(58, 58)
    self.adminButton:SetPos(302, 0)
    self.adminButton:SetText("")
    self.adminButton:SetTooltip(localizeMenuLabel("@admin"))
    self.adminButton.Paint = function(s, w, h)
        local accent = getThemeColors()
        if s:IsHovered() then drawPanel(6, 6, w - 12, h - 12, 7, Color(accent.r, accent.g, accent.b, 24), Color(accent.r, accent.g, accent.b, 70)) end
        drawIcon(Material("icon16/shield.png", "smooth"), 17, 17, 24, s:IsHovered() and accent or Color(185, 203, 203))
    end

    self.adminButton.DoClick = function() if self.tabList and self.tabList["@admin"] then self:setActiveTab("@admin") end end
    self.infoButton = self.headerUtility:Add("DButton")
    self.infoButton:SetSize(58, 58)
    self.infoButton:SetPos(366, 0)
    self.infoButton:SetText("")
    self.infoButton:SetTooltip(localizeMenuLabel("@information"))
    self.infoButton.Paint = function(s, w, h)
        local accent = getThemeColors()
        if s:IsHovered() then drawPanel(6, 6, w - 12, h - 12, 7, Color(accent.r, accent.g, accent.b, 24), Color(accent.r, accent.g, accent.b, 70)) end
        drawIcon(Material("icon16/information.png", "smooth"), 17, 17, 24, s:IsHovered() and accent or Color(185, 203, 203))
    end

    self.infoButton.DoClick = function() if self.tabList and self.tabList["@information"] then self:setActiveTab("@information") end end
    self.settingsButton = self.headerUtility:Add("DButton")
    self.settingsButton:SetSize(58, 58)
    self.settingsButton:SetPos(430, 0)
    self.settingsButton:SetText("")
    self.settingsButton:SetTooltip(localizeMenuLabel("@settings"))
    self.settingsButton.Paint = function(s, w, h)
        local accent = getThemeColors()
        if s:IsHovered() then drawPanel(6, 6, w - 12, h - 12, 7, Color(accent.r, accent.g, accent.b, 24), Color(accent.r, accent.g, accent.b, 70)) end
        drawIcon(Material("icon16/cog.png", "smooth"), 17, 17, 24, s:IsHovered() and accent or Color(185, 203, 203))
    end

    self.settingsButton.DoClick = function() if self.tabList and self.tabList["@settings"] then self:setActiveTab("@settings") end end
    self.themesButton = self.headerUtility:Add("DButton")
    self.themesButton:SetSize(58, 58)
    self.themesButton:SetPos(494, 0)
    self.themesButton:SetText("")
    self.themesButton:SetTooltip(localizeMenuLabel("@themes"))
    self.themesButton.Paint = function(s, w, h)
        local accent = getThemeColors()
        if s:IsHovered() then drawPanel(6, 6, w - 12, h - 12, 7, Color(accent.r, accent.g, accent.b, 24), Color(accent.r, accent.g, accent.b, 70)) end
        drawIcon(Material("icon16/color_wheel.png", "smooth"), 17, 17, 24, s:IsHovered() and accent or Color(185, 203, 203))
    end

    self.themesButton.DoClick = function() if self.tabList and self.tabList["@themes"] then self:setActiveTab("@themes") end end
    self.headerUtility.Think = function()
        if IsValid(self.onlineLabel) then self.onlineLabel:SetText(#player.GetAll() .. " " .. L("online")) end
        if IsValid(self.timeLabel) then self.timeLabel:SetText(L("serverTime") .. "  " .. os.date("%I:%M %p")) end
    end

    self.tabs = self.topBar:Add("liaTabs")
    self.tabs:SetSize(1, 1)
    self.tabs:SetPos(-8, -8)
    self.tabs:SetVisible(false)
    self.tabs:SetMouseInputEnabled(false)
    self.tabs:SetKeyboardInputEnabled(false)
    self.topBar.PerformLayout = function(_, w) self.headerUtility:SetPos(w - self.headerUtility:GetWide() - 18, 10) end
    self.body = self:Add("DPanel")
    self.body:Dock(FILL)
    self.body:DockMargin(0, 18, 0, 22)
    self.body.Paint = function() end
    self.sidebar = self.body:Add("DPanel")
    self.sidebar:Dock(LEFT)
    self.sidebar:SetWide(math.Clamp(ScrW() * 0.15, 242, 272))
    self.sidebar:DockMargin(26, 0, 16, 0)
    self.sidebar:DockPadding(12, 14, 12, 14)
    self.sidebar.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 10, Color(7, 20, 25, 237), Color(accent.r, accent.g, accent.b, 78))
    end

    self.panelWrapper = self.body:Add("EditablePanel")
    self.panelWrapper:Dock(FILL)
    self.panelWrapper:DockMargin(0, 0, 26, 0)
    self.panelWrapper:DockPadding(18, 18, 18, 18)
    self.panelWrapper.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 10, Color(6, 18, 23, 226), Color(accent.r, accent.g, accent.b, 72))
    end

    self.panel = self.panelWrapper:Add("EditablePanel")
    self.panel:Dock(FILL)
    self.panel.Paint = function() end
    local btnDefs = {}
    hook.Run("CreateMenuButtons", btnDefs)
    for key, value in pairs(btnDefs) do
        if isfunction(value) then
            btnDefs[key] = {
                name = key,
                func = value
            }
        end
    end

    local tabKeys = {}
    for key in pairs(btnDefs) do
        tabKeys[#tabKeys + 1] = key
    end

    table.sort(tabKeys, function(a, b) return tostring(localizeMenuLabel(btnDefs[a].name)):lower() < tostring(localizeMenuLabel(btnDefs[b].name)):lower() end)
    self.tabList = {}
    self._tabIndex = {}
    self.sidebarButtons = {}
    local tabIndex = 0
    for _, key in ipairs(tabKeys) do
        local tabDef = btnDefs[key]
        if tabDef.shouldShow and not tabDef.shouldShow() then continue end
        tabDef.name = tabDef.name or key
        local callback = tabDef.func
        if isstring(callback) then
            local body = callback
            callback = function(parent)
                local html = parent:Add("DHTML")
                html:Dock(FILL)
                if body:sub(1, 4) == "http" then
                    html:OpenURL(body)
                else
                    html:SetHTML(body)
                end
            end
        end

        tabIndex = tabIndex + 1
        self._tabIndex[key] = tabIndex
        self.tabList[key] = self:addTab(key, tabDef.name, callback)
        if key ~= "@settings" and key ~= "@information" and key ~= "@admin" and key ~= "@themes" and key ~= "characters" then self:AddSidebarButton(key, tabDef.name, tabDef.icon) end
    end

    self:MakePopup()
    local defaultTab = lia.config.get("DefaultMenuTab", "@you")
    if not self.tabList[defaultTab] then defaultTab = self.tabList["@you"] and "@you" or tabKeys[1] end
    if defaultTab then self:setActiveTab(defaultTab) end
    timer.Simple(0.1, function() if IsValid(self) then self:UpdateTabColors() end end)
end

function PANEL:AddSidebarButton(key, name, icon)
    local button = self.sidebar:Add("DButton")
    button:Dock(TOP)
    button:SetTall(52)
    button:DockMargin(0, 0, 0, 7)
    button:SetText("")
    button._key = key
    local localizedName = tostring(localizeMenuLabel(name))
    button._label = string.upper(localizedName)
    button._icon = resolveIconMaterial(icon, sidebarIcons[key] or Material("icon16/bullet_white.png", "smooth"))
    button:SetTooltip(localizedName)
    button.Paint = function(s, w, h)
        local accent = getThemeColors()
        local active = self.activeTabKey == s._key
        local hovered = s:IsHovered()
        local bg = active and Color(accent.r, accent.g, accent.b, 28) or hovered and Color(255, 255, 255, 7) or Color(0, 0, 0, 0)
        drawPanel(0, 0, w, h, 7, bg, active and Color(accent.r, accent.g, accent.b, 120) or nil)
        if active then
            surface.SetDrawColor(accent.r, accent.g, accent.b, 240)
            surface.DrawRect(0, 7, 3, h - 14)
        end

        drawIcon(s._icon, 16, 14, 24, active and Color(245, 249, 249) or Color(165, 186, 186))
        draw.SimpleText(s._label, "LiliaFont.17", 54, h * 0.5, active and Color(245, 249, 249) or Color(191, 207, 207), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    button.DoClick = function()
        lia.websound.playButtonSound()
        self:setActiveTab(key)
    end

    self.sidebarButtons[#self.sidebarButtons + 1] = button
end

function PANEL:SwitchTabContent(name, callback)
    if IsValid(lia.gui.info) then lia.gui.info:Remove() end
    if not callback or not IsValid(self.panelWrapper) then return end
    local wrapper = self.panelWrapper
    local oldPanel = self.panel
    wrapper:InvalidateLayout(true)
    if wrapper.PerformLayout then wrapper:PerformLayout() end
    local w, h = math.max(wrapper:GetWide() - 36, 1), math.max(wrapper:GetTall() - 36, 1)
    local oldKey = self.activeTabKey
    local oldIndex = oldKey and self._tabIndex[oldKey]
    local newIndex = self._tabIndex[name]
    local dir = oldIndex and newIndex and newIndex < oldIndex and -1 or 1
    local newPanel = wrapper:Add("EditablePanel")
    newPanel:SetSize(w, h)
    newPanel:SetPos(18 + dir * w, 18)
    newPanel:SetAlpha(0)
    newPanel.Paint = function() end
    self.panel = newPanel
    self.activeTabKey = name
    self:UpdateTabColors()
    self:ApplyCurrentTheme()
    callback(newPanel)
    newPanel:InvalidateLayout(true)
    local duration = 0.28
    if IsValid(oldPanel) then
        oldPanel:Dock(NODOCK)
        oldPanel:MoveTo(18 - dir * w, 18, duration, 0, 0.2, function() if IsValid(oldPanel) then oldPanel:Remove() end end)
        oldPanel:AlphaTo(0, duration, 0)
    end

    newPanel:MoveTo(18, 18, duration, 0, 0.2, function() if IsValid(newPanel) then newPanel:Dock(FILL) end end)
    newPanel:AlphaTo(255, duration, 0)
end

function PANEL:addTab(key, name, callback)
    local contentPanel = vgui.Create("EditablePanel")
    contentPanel:Dock(FILL)
    contentPanel.Paint = function() end
    self.tabs:AddTab(localizeMenuLabel(name), contentPanel, nil, function() self:SwitchTabContent(key, callback) end)
    local tabData = {
        name = name,
        panel = contentPanel,
        callback = callback
    }

    self.tabList = self.tabList or {}
    self.tabList[key] = tabData
    return tabData
end

function PANEL:setActiveTab(key)
    local tabData = self.tabList[key]
    if tabData and IsValid(tabData.panel) then
        for i, tabInfo in ipairs(self.tabs.tabs) do
            if tabInfo.pan == tabData.panel then
                self.tabs:SetActiveTab(i)
                return
            end
        end
    end
end

function PANEL:remove()
    CloseDermaMenus()
    if not self.closing then
        self:AlphaTo(0, 0.25, 0, function() self:Remove() end)
        self.closing = true
    end
end

function PANEL:OnRemove()
    hook.Run("F1MenuClosed")
    hook.Remove("OnThemeChanged", self)
end

function PANEL:OnThemeChanged()
    if IsValid(self) then self:UpdateTabColors() end
end

function PANEL:ApplyCurrentTheme()
    local currentTheme = lia.color.getCurrentTheme()
    if currentTheme and lia.color.themes[currentTheme] then lia.color.theme = table.Copy(lia.color.themes[currentTheme]) end
end

function PANEL:UpdateTabColors()
    for _, button in ipairs(self.sidebarButtons or {}) do
        if IsValid(button) then button:InvalidateLayout(true) end
    end
end

function PANEL:OnKeyCodePressed(key)
    self.noAnchor = CurTime() + 0.5
    if key == KEY_F1 or key == self.invKey then self:remove() end
end

function PANEL:Update()
    if self:IsVisible() and not self.closing then self:InvalidateLayout(true) end
end

function PANEL:Think()
    if gui.IsGameUIVisible() or gui.IsConsoleVisible() then
        self:remove()
        return
    end

    if input.IsKeyDown(KEY_F1) and CurTime() > self.noAnchor and self.anchorMode then
        self.anchorMode = false
        lia.websound.playButtonSound("buttons/lightswitch2.wav")
    end

    if not self.anchorMode and not input.IsKeyDown(KEY_F1) and not IsValid(self.info) then self:remove() end
end

function PANEL:Paint()
    lia.util.drawBlackBlur(self, 1, 5, 255, 225)
    surface.SetDrawColor(0, 8, 10, 110)
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("liaMenu", PANEL, "EditablePanel")
PANEL = {}
function PANEL:Init()
    lia.gui.classes = self
    local w, h = self:GetParent():GetSize()
    self:SetSize(w, h)
    self.selectedClassModels = self.selectedClassModels or {}
    local frame = self:Add("liaFrame")
    frame:Dock(FILL)
    frame:DockMargin(10, 10, 10, 10)
    frame:DockPadding(10, 10, 10, 10)
    frame:SetTitle("")
    frame:LiteMode()
    frame:DisableCloseBtn()
    self.frame = frame
    self.sidebar = frame:Add("liaScrollPanel")
    self.sidebar:Dock(LEFT)
    self.sidebar:SetWide(240)
    self.sidebar:DockMargin(0, 0, 10, 0)
    self.sidebar.Paint = function() end
    local sidebarCanvas = self.sidebar:GetCanvas()
    if IsValid(sidebarCanvas) then
        sidebarCanvas:DockPadding(4, 4, 4, 4)
        sidebarCanvas.Paint = function() end
    end

    self.mainContent = frame:Add("liaScrollPanel")
    self.mainContent:Dock(FILL)
    self.mainContent:DockMargin(0, 0, 0, 0)
    self.mainContent.Paint = function() end
    local mainCanvas = self.mainContent:GetCanvas()
    if IsValid(mainCanvas) then
        mainCanvas:DockPadding(6, 6, 6, 6)
        mainCanvas.Paint = function() end
    end

    self.tabList = {}
    self:loadClasses()
end

function PANEL:loadClasses()
    local client = LocalPlayer()
    local list = {}
    for _, cl in pairs(lia.class.list) do
        if cl.faction == client:Team() then list[#list + 1] = cl end
    end

    table.sort(list, function(a, b) return L(a.name or "") < L(b.name or "") end)
    self.sidebar:Clear()
    self.tabList = {}
    local firstBtn = nil
    for _, cl in ipairs(list) do
        local canBe = lia.class.canBe(LocalPlayer(), cl.index)
        local btn = self.sidebar:Add("liaTabButton")
        btn:Dock(TOP)
        btn:DockMargin(4, 4, 4, 4)
        btn:SetTall(34)
        btn:SetText(cl.name and L(cl.name) or L("unnamed"))
        btn:SetActive(false)
        if cl.desc and cl.desc ~= L("noDesc") then btn:SetTooltip(L(cl.desc)) end
        btn:SetDoClick(function()
            for _, b in ipairs(self.tabList) do
                if IsValid(b) then b:SetActive(b == btn) end
            end

            self:populateClassDetails(cl, canBe)
        end)

        self.tabList[#self.tabList + 1] = btn
        if not firstBtn then firstBtn = btn end
    end

    if IsValid(firstBtn) then timer.Simple(0, function() if IsValid(firstBtn) then firstBtn:DoClick() end end) end
end

function PANEL:populateClassDetails(cl, canBe)
    local canvas = self.mainContent:GetCanvas()
    if IsValid(canvas) then
        canvas:Clear()
    else
        self.mainContent:Clear()
    end

    local parent = IsValid(canvas) and canvas or self.mainContent
    local container = parent:Add("DPanel")
    container:Dock(TOP)
    container:DockMargin(0, 0, 0, 0)
    container:DockPadding(10, 10, 10, 10)
    container:SetTall(math.max(self.mainContent:GetTall(), 200))
    container.Paint = function(_, w, h)
        local bgColor = Color(25, 28, 35, 250)
        lia.derma.rect(0, 0, w, h):Rad(12):Color(bgColor):Shape(lia.derma.SHAPE_IOS):Draw()
    end

    container.Think = function(s)
        if not IsValid(self) or not IsValid(self.mainContent) then return end
        local targetTall = math.max(self.mainContent:GetTall(), 200)
        if s:GetTall() ~= targetTall then s:SetTall(targetTall) end
    end

    local header = container:Add("DPanel")
    header:Dock(TOP)
    header:DockMargin(0, 0, 0, 10)
    header:SetTall(56)
    header.Paint = function() end
    local title = header:Add("DLabel")
    title:Dock(FILL)
    title:SetFont("LiliaFont.25")
    title:SetText(cl.name and L(cl.name) or L("unnamed"))
    title:SetTextColor(lia.color.returnMainAdjustedColors and lia.color.returnMainAdjustedColors().text or color_white)
    title:SetContentAlignment(4)
    local body = container:Add("DPanel")
    body:Dock(FILL)
    body.Paint = function() end
    local right = body:Add("liaScrollPanel")
    right:Dock(RIGHT)
    right:SetWide(320)
    right:DockMargin(10, 0, 0, 0)
    right.Paint = function() end
    local rightCanvas = right:GetCanvas()
    if IsValid(rightCanvas) then
        rightCanvas:DockPadding(0, 0, 0, 0)
        rightCanvas.Paint = function() end
    end

    right.Think = function(s)
        local cnv = s:GetCanvas()
        if not IsValid(cnv) then return end
        local vbarW = (IsValid(s.VBar) and s.VBar:GetWide()) or 0
        local targetW = math.max(s:GetWide() - vbarW - 2, 1)
        if cnv:GetWide() ~= targetW then cnv:SetWide(targetW) end
        local totalH = 0
        for _, child in ipairs(cnv:GetChildren()) do
            if IsValid(child) then
                totalH = totalH + child:GetTall()
                if child.GetDockMargin then
                    local _, top, _, bottom = child:GetDockMargin()
                    if top then totalH = totalH + top end
                    if bottom then totalH = totalH + bottom end
                end
            end
        end

        local minH = math.max(s:GetTall(), 1)
        local targetH = math.max(totalH, minH)
        if cnv:GetTall() ~= targetH then cnv:SetTall(targetH) end
    end

    local rightParent = IsValid(rightCanvas) and rightCanvas or right
    if cl.logo then
        local logoWrap = rightParent:Add("DPanel")
        logoWrap:Dock(TOP)
        logoWrap:DockMargin(0, 0, 0, 10)
        logoWrap:SetTall(140)
        logoWrap.Paint = function() end
        local img = logoWrap:Add("DImage")
        img:SetSize(128, 128)
        img:SetImage(cl.logo)
        img:SetKeepAspect(true)
        logoWrap.PerformLayout = function(s, w, h) if IsValid(img) then img:SetPos(math.floor((w - img:GetWide()) * 0.5), math.floor((h - img:GetTall()) * 0.5)) end end
    end

    local left = body:Add("liaScrollPanel")
    left:Dock(FILL)
    left.Paint = function() end
    local leftCanvas = left:GetCanvas()
    if IsValid(leftCanvas) then
        leftCanvas:DockPadding(0, 0, 0, 0)
        leftCanvas.Paint = function() end
    end

    self:createModelPanel(rightParent, cl)
    self:addJoinButton(rightParent, cl, canBe)
    self:addClassDetails(left, cl)
    container.PerformLayout = function(s)
        s:SizeToChildren(false, true)
        s:SetTall(math.max(s:GetTall(), body:GetTall() + header:GetTall() + 30))
    end
end

function PANEL:createModelPanel(parent, cl)
    local container = parent:Add("DPanel")
    container:Dock(TOP)
    container:DockMargin(0, 0, 0, 10)
    container:SetTall(420)
    container.Paint = function() end
    local panel = container:Add("liaModelPanel")
    panel:Dock(FILL)
    panel:SetFOV(35)
    local basePaint = panel.Paint
    panel.Paint = function(s, modelW, modelH)
        local bgColor = Color(35, 38, 45, 180)
        lia.derma.rect(0, 0, modelW, modelH):Rad(10):Color(bgColor):Shape(lia.derma.SHAPE_IOS):Draw()
        if basePaint then basePaint(s, modelW, modelH) end
    end

    local function getModels(mdl)
        local models = {}
        if isstring(mdl) and mdl ~= "" then
            models[#models + 1] = mdl
        elseif istable(mdl) then
            local function gather(tbl)
                for _, v in pairs(tbl) do
                    if isstring(v) then
                        models[#models + 1] = v
                    elseif istable(v) then
                        gather(v)
                    end
                end
            end

            gather(mdl)
        end
        return models
    end

    local availableModels = getModels(cl.model or cl.models)
    if #availableModels == 0 then availableModels = {LocalPlayer():GetModel()} end
    panel.currentModelIndex = 1
    panel.availableModels = availableModels
    panel.classData = cl
    local function updateModel()
        local model = panel.availableModels[panel.currentModelIndex]
        if util and util.IsValidModel and not util.IsValidModel(model) then model = LocalPlayer():GetModel() end
        panel:SetModel(model)
        panel:fitFOV()
        self.selectedClassModels = self.selectedClassModels or {}
        self.selectedClassModels[cl.index] = model
        local function applyEntitySettings()
            local ent = panel.Entity
            if not IsValid(ent) then return end
            ent:SetSkin(panel.classData.skin or 0)
            lia.util.applyBodygroups(ent, panel.classData.bodyGroups or panel.classData.bodygroups)
            for i, mat in ipairs(panel.classData.subMaterials or {}) do
                ent:SetSubMaterial(i - 1, mat)
            end
        end

        applyEntitySettings()
        timer.Simple(0, function() if IsValid(panel) then applyEntitySettings() end end)
        timer.Simple(0.1, function() if IsValid(panel) then applyEntitySettings() end end)
    end

    updateModel()
    panel.rotationAngle = 45
    if #availableModels > 1 then
        local arrowSize, arrowSpace = 32, 8
        local function newArrow(sign, xOffset)
            local btn = container:Add("liaBigButton")
            btn:SetSize(arrowSize, arrowSize)
            btn:SetPos(xOffset, (container:GetTall() - arrowSize) * 0.5)
            btn:SetFont("LiliaFont.24")
            btn:SetShowLine(false)
            btn:SetText(sign)
            btn.DoClick = function()
                if #panel.availableModels <= 1 then return end
                panel.currentModelIndex = panel.currentModelIndex + (sign == "<" and -1 or 1)
                if panel.currentModelIndex < 1 then panel.currentModelIndex = #panel.availableModels end
                if panel.currentModelIndex > #panel.availableModels then panel.currentModelIndex = 1 end
                lia.websound.playButtonSound("buttons/button14.wav")
                updateModel()
            end
            return btn
        end

        panel.leftArrow = newArrow("<", arrowSpace)
        panel.rightArrow = newArrow(">", container:GetWide() - arrowSize - arrowSpace)
        container.PerformLayout = function(s)
            if IsValid(panel.leftArrow) then panel.leftArrow:SetPos(arrowSpace, (s:GetTall() - arrowSize) * 0.5) end
            if IsValid(panel.rightArrow) then panel.rightArrow:SetPos(s:GetWide() - arrowSize - arrowSpace, (s:GetTall() - arrowSize) * 0.5) end
        end
    end

    panel.LayoutEntity = function(_, ent)
        if not IsValid(ent) then return end
        if input.IsKeyDown(KEY_A) then
            panel.rotationAngle = panel.rotationAngle - 0.5
        elseif input.IsKeyDown(KEY_D) then
            panel.rotationAngle = panel.rotationAngle + 0.5
        end

        ent:SetAngles(Angle(0, panel.rotationAngle, 0))
    end
    return panel.availableModels[panel.currentModelIndex]
end

function PANEL:addClassDetails(parent, cl)
    local client = LocalPlayer()
    local maxH, maxA, maxJ = client:GetMaxHealth(), client:GetMaxArmor(), client:GetJumpPower()
    local run, walk = lia.config.get("RunSpeed"), lia.config.get("WalkSpeed")
    local function add(text)
        local row = parent:Add("DPanel")
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, 8)
        row:DockPadding(10, 8, 10, 8)
        row.Paint = function(_, w, h)
            local rowBg = Color(35, 38, 45, 180)
            lia.derma.rect(0, 0, w, h):Rad(10):Color(rowBg):Shape(lia.derma.SHAPE_IOS):Draw()
        end

        local lbl = row:Add("DLabel")
        lbl:Dock(FILL)
        lbl:SetFont("LiliaFont.18")
        lbl:SetText(text)
        local textColor = lia.color.returnMainAdjustedColors and lia.color.returnMainAdjustedColors().text or color_white
        lbl:SetTextColor(textColor)
        lbl:SetWrap(true)
        lbl:SetAutoStretchVertical(true)
        row.PerformLayout = function(s)
            if not IsValid(lbl) then return end
            lbl:SetWide(s:GetWide() - 20)
            lbl:SizeToContentsY()
            s:SetTall(lbl:GetTall() + 16)
        end
    end

    add(L("name") .. ": " .. (cl.name and L(cl.name) or L("unnamed")))
    add(L("desc") .. ": " .. (cl.desc and L(cl.desc) or L("noDesc")))
    local facName = team.GetName(cl.faction)
    add(L("faction") .. ": " .. (facName and L(facName) or L("none")))
    add(L("isDefault") .. ": " .. (cl.isDefault and L("yes") or L("no")))
    add(L("baseHealth") .. ": " .. tostring(cl.health or maxH))
    add(L("baseArmor") .. ": " .. tostring(cl.armor or maxA))
    local function getWeaponClassList(weps)
        if isstring(weps) then return {weps} end
        if not istable(weps) then return {} end
        local out = {}
        if #weps > 0 then
            for _, v in ipairs(weps) do
                if isstring(v) then
                    out[#out + 1] = v
                elseif istable(v) then
                    local cn = v.class or v.weapon or v.name
                    if isstring(cn) then out[#out + 1] = cn end
                end
            end
        else
            for _, v in pairs(weps) do
                if isstring(v) then
                    out[#out + 1] = v
                elseif istable(v) then
                    local cn = v.class or v.weapon or v.name
                    if isstring(cn) then out[#out + 1] = cn end
                end
            end
        end
        return out
    end

    local wepClasses = getWeaponClassList(cl.weapons)
    local weaponNames = {}
    for _, className in ipairs(wepClasses) do
        local stored = weapons.GetStored and weapons.GetStored(className) or nil
        local printName = stored and (stored.PrintName or stored.Name) or nil
        weaponNames[#weaponNames + 1] = printName and tostring(printName) ~= "" and tostring(printName) or tostring(className)
    end

    add(L("weapons") .. ": " .. (#weaponNames > 0 and table.concat(weaponNames, ", ") or L("none")))
    add(L("modelScale") .. ": " .. tostring(cl.scale or 1))
    local rs = cl.runSpeed and math.Round(run * cl.runSpeed) or run
    add(L("runSpeed") .. ": " .. tostring(rs))
    local ws = cl.walkSpeed and math.Round(walk * cl.walkSpeed) or walk
    add(L("walkSpeed") .. ": " .. tostring(ws))
    local jp = cl.jumpPower and math.Round(maxJ * cl.jumpPower) or maxJ
    add(L("jumpPower") .. ": " .. tostring(jp))
    local bloodMap = {
        [-1] = L("bloodNo"),
        [0] = L("bloodRed"),
        [1] = L("bloodYellow"),
        [2] = L("bloodGreenRed"),
        [3] = L("bloodSparks"),
        [4] = L("bloodAntlion"),
        [5] = L("bloodZombie"),
        [6] = L("bloodAntlionBright")
    }

    add(L("bloodColor") .. ": " .. (bloodMap[cl.bloodcolor] or L("bloodRed")))
end

function PANEL:addJoinButton(parent, cl, canBe)
    local classModels = cl.model or cl.models
    local hasModelChoices = istable(classModels)
    local isCurrent = LocalPlayer():getChar() and LocalPlayer():getChar():getClass() == cl.index
    local isNonDefault = cl.isDefault == false
    local btn = parent:Add("liaMediumButton")
    if isCurrent and hasModelChoices then
        btn:SetText(L("changeModel"))
    elseif isCurrent then
        btn:SetText(L("alreadyInClass"))
    elseif not canBe and isNonDefault then
        btn:SetText(L("classRequirementsNotMet"))
    else
        btn:SetText(L("joinClass"))
    end

    btn:SetTall(45)
    btn:Dock(TOP)
    btn:DockMargin(0, 0, 0, 0)
    local textColor = lia.color.returnMainAdjustedColors and lia.color.returnMainAdjustedColors().text or color_white
    local accentColor = lia.color.returnMainAdjustedColors and lia.color.returnMainAdjustedColors().accent or Color(100, 150, 255)
    btn:SetTextColor(textColor)
    btn:SetFont("LiliaFont.25")
    btn:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    btn:SetContentAlignment(5)
    btn.Paint = function(panel, w, h)
        local baseColor = Color(45, 45, 45, 200)
        local hoverColor = Color(55, 55, 55, 220)
        if panel:IsHovered() and not panel:GetDisabled() then baseColor = hoverColor end
        if panel:GetDisabled() then baseColor = Color(35, 35, 35, 150) end
        lia.derma.rect(0, 0, w, h):Rad(6):Color(baseColor):Shape(lia.derma.SHAPE_IOS):Shadow(panel:IsHovered() and not panel:GetDisabled() and 3 or 2, panel:IsHovered() and not panel:GetDisabled() and 8 or 4):Draw()
        if canBe and not isCurrent then
            lia.derma.rect(0, 0, w, h):Rad(6):Color(accentColor):Shape(lia.derma.SHAPE_IOS):Draw()
            lia.derma.rect(2, 2, w - 4, h - 4):Rad(4):Color(baseColor):Shape(lia.derma.SHAPE_IOS):Draw()
        end
    end

    btn:SetDisabled((not canBe and not isCurrent) or (isCurrent and not hasModelChoices))
    btn.DoClick = function()
        lia.websound.playButtonSound()
        if isCurrent then
            if hasModelChoices then lia.command.send("beclass", cl.index, self.selectedClassModels and self.selectedClassModels[cl.index] or nil) end
            return
        end

        if not canBe then return end
        if hasModelChoices then
            lia.command.send("beclass", cl.index, self.selectedClassModels and self.selectedClassModels[cl.index] or nil)
        else
            lia.command.send("beclass", cl.index)
        end

        timer.Simple(0.1, function()
            if IsValid(self) then
                self:loadClasses()
                self.mainContent:Clear()
            end
        end)
    end
end

vgui.Register("liaClasses", PANEL, "EditablePanel")
hook.Add("LoadCharInformation", "liaF1MenuGeneralInfo", function()
    hook.Run("AddSection", L("generalInfo"), Color(0, 0, 0), 1, 1)
    hook.Run("AddTextField", L("generalInfo"), "name", L("name"), function()
        local client = LocalPlayer()
        local char = client:getChar()
        return char and char:getName() or L("unknown")
    end)

    hook.Run("AddTextField", L("generalInfo"), "desc", L("desc"), function()
        local client = LocalPlayer()
        local char = client:getChar()
        return char and char:getDesc() or ""
    end)

    hook.Run("AddTextField", L("generalInfo"), "money", L("money"), function()
        local client = LocalPlayer()
        return client and lia.currency.get(client:getChar():getMoney()) or lia.currency.get(0)
    end)

    hook.Run("AddTextField", L("generalInfo"), "playTime", L("playtime"), function()
        local client = LocalPlayer()
        return client and lia.time.formatDHM(client:getPlayTime()) or L("loading")
    end)
end)

hook.Add("AddSection", "liaF1MenuAddSection", function(sectionName, color, priority, location)
    if IsValid(lia.gui.info) then
        local localizedSectionName = resolveCharInfoSectionName(sectionName)
        if not lia.gui.info.CharacterInformation[localizedSectionName] then
            lia.gui.info.CharacterInformation[localizedSectionName] = {
                fields = {},
                color = color or Color(255, 255, 255),
                priority = priority or 999,
                location = location or 1
            }
        else
            local info = lia.gui.info.CharacterInformation[localizedSectionName]
            info.color = color or info.color
            info.priority = priority or info.priority
            info.location = location or info.location
        end
    end
end)

hook.Add("AddTextField", "liaF1MenuAddTextField", function(sectionName, fieldName, labelText, valueFunc)
    if IsValid(lia.gui.info) then
        local localizedSectionName = resolveCharInfoSectionName(sectionName)
        local localizedLabel = isstring(labelText) and L(labelText) or labelText
        local section = lia.gui.info.CharacterInformation[localizedSectionName]
        if section then
            for _, field in ipairs(section.fields) do
                if field.name == fieldName then return end
            end

            table.insert(section.fields, {
                type = "text",
                name = fieldName,
                label = localizedLabel,
                value = valueFunc or function() return "" end
            })
        end
    end
end)

hook.Add("AddTextField", "liaF1MenuAddTextField", function(sectionName, fieldName, labelText, valueFunc)
    if IsValid(lia.gui.info) then
        local localizedSectionName = resolveCharInfoSectionName(sectionName)
        local localizedLabel = isstring(labelText) and L(labelText) or labelText
        local section = lia.gui.info.CharacterInformation[localizedSectionName]
        if section then
            for _, field in ipairs(section.fields) do
                if field.name == fieldName then return end
            end

            table.insert(section.fields, {
                type = "text",
                name = fieldName,
                label = localizedLabel,
                value = valueFunc or function() return "" end
            })
        end
    end
end)

hook.Add("AddBarField", "liaF1MenuAddBarField", function(sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
    if IsValid(lia.gui.info) then
        local localizedSectionName = resolveCharInfoSectionName(sectionName)
        local localizedLabel = isstring(labelText) and L(labelText) or labelText
        local section = lia.gui.info.CharacterInformation[localizedSectionName]
        if section then
            for _, field in ipairs(section.fields) do
                if field.name == fieldName then return end
            end

            table.insert(section.fields, {
                type = "bar",
                name = fieldName,
                label = localizedLabel,
                min = minFunc or function() return 0 end,
                max = maxFunc or function() return 100 end,
                value = valueFunc or function() return 0 end
            })
        end
    end
end)

hook.Add("PlayerBindPress", "liaF1MenuPlayerBindPress", function(client, bind, pressed)
    if bind:lower():find("gm_showhelp") and pressed then
        if IsValid(lia.gui.menu) then
            lia.gui.menu:remove()
        elseif client:getChar() then
            vgui.Create("liaMenu")
        end
        return true
    end
end)

hook.Add("CreateMenuButtons", "liaF1MenuCreateMenuButtons", function(tabs)
    tabs["@you"] = {
        name = "@you",
        icon = "icon16/user.png",
        func = function(statusPanel)
            statusPanel.info = vgui.Create("liaCharInfo", statusPanel)
            statusPanel.info:Dock(FILL)
            statusPanel.info:setup()
            statusPanel.info:SetAlpha(0)
            statusPanel.info:AlphaTo(255, 0.5)
        end
    }

    tabs["@information"] = {
        name = "@information",
        icon = "icon16/information.png",
        func = function(infoTabPanel)
            local frame = infoTabPanel:Add("liaFrame")
            frame:Dock(FILL)
            frame:DockPadding(10, 10, 10, 10)
            frame:SetTitle("")
            frame:DisableCloseBtn()
            local pages = {}
            hook.Run("CreateInformationButtons", pages)
            if not pages then return end
            for i = #pages, 1, -1 do
                if pages[i].shouldShow and not pages[i].shouldShow() then table.remove(pages, i) end
            end

            table.sort(pages, function(a, b)
                local an = tostring(localizeMenuLabel(a.name)):lower()
                local bn = tostring(localizeMenuLabel(b.name)):lower()
                return an < bn
            end)

            local tabContainer = vgui.Create("DPanel", frame)
            tabContainer:Dock(TOP)
            tabContainer:SetTall(40)
            tabContainer.Paint = function() end
            local contentArea = vgui.Create("DPanel", frame)
            contentArea:Dock(FILL)
            contentArea.Paint = function() end
            local activeTab = 1
            local tabButtons = {}
            local tabPanels = {}
            local baseTabWidths = {}
            local baseMargin = 8
            for i, page in ipairs(pages) do
                surface.SetFont("LiliaFont.18")
                local textWidth = surface.GetTextSize(localizeMenuLabel(page.name))
                local iconWidth = 0
                local padding = 20
                local minWidth = 80
                local btnWidth = math.max(minWidth, padding + iconWidth + textWidth + padding)
                baseTabWidths[i] = btnWidth
            end

            for i, page in ipairs(pages) do
                local tabButton = vgui.Create("liaTabButton", tabContainer)
                tabButton:Dock(LEFT)
                tabButton:DockMargin(i == 1 and 0 or baseMargin, 0, 0, 0)
                tabButton:SetTall(36)
                tabButton:SetText(localizeMenuLabel(page.name))
                tabButton:SetActive(i == 1)
                tabButton:SetWide(baseTabWidths[i] or 80)
                tabButton:SetDoClick(function()
                    if activeTab == i then return end
                    lia.websound.playButtonSound()
                    if tabPanels[activeTab] then tabPanels[activeTab]:SetVisible(false) end
                    activeTab = i
                    tabPanels[i]:SetVisible(true)
                    for j, btn in ipairs(tabButtons) do
                        if IsValid(btn) then btn:SetActive(j == i) end
                    end

                    if page.drawFunc then page.drawFunc(tabPanels[i]) end
                end)

                tabButtons[i] = tabButton
                local contentPanel = vgui.Create("DPanel", contentArea)
                contentPanel:Dock(TOP)
                contentPanel:SetVisible(i == 1)
                contentPanel.Paint = function() end
                contentPanel.PerformLayout = function(s) if IsValid(frame) and IsValid(tabContainer) then s:SetTall(frame:GetTall() - tabContainer:GetTall() - 20) end end
                tabPanels[i] = contentPanel
            end

            local function AdjustTabWidths()
                if not IsValid(tabContainer) then return end
                local totalTabsWidth = 0
                for _, width in pairs(baseTabWidths) do
                    totalTabsWidth = totalTabsWidth + width
                end

                local availableWidth = tabContainer:GetWide()
                local totalMargins = baseMargin * (#pages - 1)
                local extraSpace = availableWidth - totalTabsWidth - totalMargins
                if extraSpace > 0 then
                    local extraPerTab = math.floor(extraSpace / #pages)
                    local adjustedWidths = {}
                    for tabId, baseWidth in pairs(baseTabWidths) do
                        adjustedWidths[tabId] = baseWidth + extraPerTab
                    end

                    local remainder = extraSpace % #pages
                    if remainder > 0 then
                        for remainderId = 1, math.min(remainder, #pages) do
                            adjustedWidths[remainderId] = adjustedWidths[remainderId] + 1
                        end
                    end

                    for childId, child in ipairs(tabContainer:GetChildren()) do
                        if adjustedWidths[childId] and IsValid(child) then child:SetWide(adjustedWidths[childId]) end
                    end
                end
            end

            local originalPerformLayout = tabContainer.PerformLayout
            tabContainer.PerformLayout = function(s, w, h)
                if originalPerformLayout then originalPerformLayout(s, w, h) end
                timer.Simple(0, function() if IsValid(s) then AdjustTabWidths() end end)
            end

            if pages[1] and pages[1].drawFunc and IsValid(tabPanels[1]) then pages[1].drawFunc(tabPanels[1]) end
        end
    }

    tabs["@settings"] = {
        name = "@settings",
        icon = "icon16/cog.png",
        func = function(settingsPanel)
            local frame = settingsPanel:Add("liaFrame")
            frame:Dock(FILL)
            frame:DockMargin(10, 10, 10, 10)
            frame:SetTitle(L("settings"))
            frame:LiteMode()
            frame:DisableCloseBtn()
            local pages = {}
            hook.Run("PopulateConfigurationButtons", pages)
            if not pages then return end
            for i = #pages, 1, -1 do
                if pages[i].shouldShow and not pages[i].shouldShow() then table.remove(pages, i) end
            end

            table.sort(pages, function(a, b)
                local an = tostring(localizeMenuLabel(a.name)):lower()
                local bn = tostring(localizeMenuLabel(b.name)):lower()
                return an < bn
            end)

            local tabContainer = vgui.Create("DPanel", frame)
            tabContainer:Dock(TOP)
            tabContainer:SetTall(40)
            tabContainer.Paint = function() end
            local contentArea = vgui.Create("liaScrollPanel", frame)
            contentArea:Dock(FILL)
            local activeTab = 1
            local tabButtons = {}
            local tabPanels = {}
            local baseTabWidths = {}
            local baseMargin = 8
            for i, page in ipairs(pages) do
                surface.SetFont("LiliaFont.18")
                local textWidth = surface.GetTextSize(localizeMenuLabel(page.name))
                local iconWidth = 0
                local padding = 20
                local minWidth = 80
                local btnWidth = math.max(minWidth, padding + iconWidth + textWidth + padding)
                baseTabWidths[i] = btnWidth
            end

            for i, page in ipairs(pages) do
                local tabButton = vgui.Create("liaTabButton", tabContainer)
                tabButton:Dock(LEFT)
                tabButton:DockMargin(i == 1 and 0 or baseMargin, 0, 0, 0)
                tabButton:SetTall(36)
                tabButton:SetText(localizeMenuLabel(page.name))
                tabButton:SetActive(i == 1)
                tabButton:SetWide(baseTabWidths[i] or 80)
                tabButton:SetDoClick(function()
                    if activeTab == i then return end
                    lia.websound.playButtonSound()
                    if tabPanels[activeTab] then tabPanels[activeTab]:SetVisible(false) end
                    activeTab = i
                    tabPanels[i]:SetVisible(true)
                    for j, btn in ipairs(tabButtons) do
                        if IsValid(btn) then btn:SetActive(j == i) end
                    end

                    if page.drawFunc then page.drawFunc(tabPanels[i]) end
                end)

                tabButtons[i] = tabButton
                local contentPanel = vgui.Create("DPanel", contentArea)
                contentPanel:Dock(TOP)
                contentPanel:SetVisible(i == 1)
                contentPanel.Paint = function() end
                contentPanel.PerformLayout = function(s) if IsValid(frame) and IsValid(tabContainer) then s:SetTall(frame:GetTall() - tabContainer:GetTall() - 20) end end
                tabPanels[i] = contentPanel
            end

            local function AdjustTabWidths()
                if not IsValid(tabContainer) then return end
                local totalTabsWidth = 0
                for _, width in pairs(baseTabWidths) do
                    totalTabsWidth = totalTabsWidth + width
                end

                local availableWidth = tabContainer:GetWide()
                local totalMargins = baseMargin * (#pages - 1)
                local extraSpace = availableWidth - totalTabsWidth - totalMargins
                if extraSpace > 0 then
                    local extraPerTab = math.floor(extraSpace / #pages)
                    local adjustedWidths = {}
                    for tabId, baseWidth in pairs(baseTabWidths) do
                        adjustedWidths[tabId] = baseWidth + extraPerTab
                    end

                    local remainder = extraSpace % #pages
                    if remainder > 0 then
                        for remainderId = 1, math.min(remainder, #pages) do
                            adjustedWidths[remainderId] = adjustedWidths[remainderId] + 1
                        end
                    end

                    for childId, child in ipairs(tabContainer:GetChildren()) do
                        if adjustedWidths[childId] and IsValid(child) then child:SetWide(adjustedWidths[childId]) end
                    end
                end
            end

            local originalPerformLayout = tabContainer.PerformLayout
            tabContainer.PerformLayout = function(s, w, h)
                if originalPerformLayout then originalPerformLayout(s, w, h) end
                timer.Simple(0, function() if IsValid(s) then AdjustTabWidths() end end)
            end

            if pages[1] and pages[1].drawFunc and IsValid(tabPanels[1]) then pages[1].drawFunc(tabPanels[1]) end
        end
    }

    local adminPages = {}
    hook.Run("PopulateAdminTabs", adminPages)
    if not table.IsEmpty(adminPages) then
        tabs["@admin"] = {
            name = "@admin",
            icon = "icon16/shield.png",
            func = function(adminPanel)
                local frame = adminPanel:Add("liaFrame")
                frame:Dock(FILL)
                frame:DockMargin(10, 10, 10, 10)
                frame:SetTitle(L("admin"))
                frame:LiteMode()
                frame:DisableCloseBtn()
                local pages = {}
                hook.Run("PopulateAdminTabs", pages)
                if table.IsEmpty(pages) then return end
                for i = #pages, 1, -1 do
                    if pages[i].shouldShow and not pages[i].shouldShow() then table.remove(pages, i) end
                end

                table.sort(pages, function(a, b)
                    local an = tostring(localizeMenuLabel(a.name)):lower()
                    local bn = tostring(localizeMenuLabel(b.name)):lower()
                    return an < bn
                end)

                table.insert(pages, 1, {
                    name = "onlineStaff",
                    icon = "icon16/user.png",
                    drawFunc = function(panel)
                        panel.originalStaffData = {}
                        panel.filteredStaffData = {}
                        local function filterStaffData(searchText)
                            searchText = tostring(searchText or "")
                            if searchText == "" then
                                panel.filteredStaffData = panel.originalStaffData
                            else
                                panel.filteredStaffData = {}
                                local searchLower = searchText:lower()
                                for _, staffInfo in ipairs(panel.originalStaffData) do
                                    local nameMatch = staffInfo.name and staffInfo.name:lower():find(searchLower, 1, true)
                                    local usergroupMatch = staffInfo.usergroup and staffInfo.usergroup:lower():find(searchLower, 1, true)
                                    local characterMatch = staffInfo.characterName and staffInfo.characterName:lower():find(searchLower, 1, true)
                                    if nameMatch or usergroupMatch or characterMatch then panel.filteredStaffData[#panel.filteredStaffData + 1] = staffInfo end
                                end
                            end
                            return panel.filteredStaffData
                        end

                        local function createStaffTable(staffData)
                            panel:Clear()
                            local searchEntry = panel:Add("liaEntry")
                            searchEntry:Dock(TOP)
                            searchEntry:DockMargin(0, 20, 0, 15)
                            searchEntry:SetTall(30)
                            searchEntry:SetFont("LiliaFont.17")
                            searchEntry:SetPlaceholderText(L("searchStaff"))
                            searchEntry:SetTextColor(Color(200, 200, 200))
                            searchEntry.OnTextChanged = function(_, value)
                                local filteredData = filterStaffData(value or "")
                                updateStaffTable(filteredData)
                            end

                            local staffTable = panel:Add("liaTable")
                            staffTable:Dock(FILL)
                            panel.staffTable = staffTable
                            staffTable:AddColumn(L("name"), nil, TEXT_ALIGN_LEFT, true)
                            staffTable:AddColumn(L("usergroup"), nil, TEXT_ALIGN_LEFT, true)
                            staffTable:AddColumn(L("staffOnDuty", ""), 100, TEXT_ALIGN_CENTER, true)
                            function updateStaffTable(dataToShow)
                                staffTable:Clear()
                                local staffFound = false
                                if dataToShow then
                                    for _, staffInfo in ipairs(dataToShow) do
                                        staffFound = true
                                        staffTable:AddLine(staffInfo.name .. " (" .. staffInfo.characterName .. ")", staffInfo.usergroup, staffInfo.isStaffOnDuty and L("yes") or L("no"))
                                    end
                                end

                                if not staffFound then staffTable:AddLine(L("noStaffCurrentlyOnline"), "", "") end
                                staffTable:ForceCommit()
                            end

                            panel.updateStaffTable = updateStaffTable
                            updateStaffTable(staffData)
                        end

                        panel.PerformLayout = function(s)
                            if IsValid(s.staffTable) and s.staffTable.CalculateColumnWidths and s.staffTable.RebuildRows then
                                s.staffTable:CalculateColumnWidths()
                                s.staffTable:RebuildRows()
                            end
                        end

                        panel.resizeTimer = nil
                        panel.OnSizeChanged = function(s)
                            if IsValid(s.staffTable) and s.staffTable.CalculateColumnWidths and s.staffTable.RebuildRows then
                                if s.resizeTimer then timer.Remove(s.resizeTimer) end
                                s.resizeTimer = "liaStaffTableResize_" .. CurTime()
                                timer.Create(s.resizeTimer, 0.1, 1, function()
                                    if IsValid(s) and IsValid(s.staffTable) then
                                        s.staffTable:CalculateColumnWidths()
                                        s.staffTable:RebuildRows()
                                    end
                                end)
                            end
                        end

                        local function onStaffDataReceived(staffData)
                            if IsValid(panel) then
                                panel.originalStaffData = staffData or {}
                                panel.filteredStaffData = panel.originalStaffData
                                if panel.updateStaffTable then
                                    panel.updateStaffTable(panel.filteredStaffData)
                                else
                                    createStaffTable(panel.filteredStaffData)
                                end
                            end
                        end

                        hook.Add("OnlineStaffDataReceived", "liaF1MenuStaffData", onStaffDataReceived)
                        net.Start("liaRequestOnlineStaffData")
                        net.SendToServer()
                        panel.refreshTimer = timer.Create("liaAdminStaffTableRefresh", 30, 0, function()
                            if IsValid(panel) then
                                net.Start("liaRequestOnlineStaffData")
                                net.SendToServer()
                            else
                                timer.Remove("liaAdminStaffTableRefresh")
                            end
                        end)

                        panel.OnRemove = function()
                            hook.Remove("OnlineStaffDataReceived", "liaF1MenuStaffData")
                            if timer.Exists("liaAdminStaffTableRefresh") then timer.Remove("liaAdminStaffTableRefresh") end
                            if panel.resizeTimer and timer.Exists(panel.resizeTimer) then timer.Remove(panel.resizeTimer) end
                            panel.staffTable = nil
                        end
                    end
                })

                local tabContainer = vgui.Create("DPanel", frame)
                tabContainer:Dock(TOP)
                tabContainer:SetTall(40)
                tabContainer.Paint = function() end
                local contentArea = vgui.Create("liaScrollPanel", frame)
                contentArea:Dock(FILL)
                local activeTab = 1
                local tabButtons = {}
                local tabPanels = {}
                local baseTabWidths = {}
                local baseMargin = 8
                for i, page in ipairs(pages) do
                    surface.SetFont("LiliaFont.18")
                    local textWidth = surface.GetTextSize(localizeMenuLabel(page.name))
                    local iconWidth = 0
                    local padding = 20
                    local minWidth = 80
                    local btnWidth = math.max(minWidth, padding + iconWidth + textWidth + padding)
                    baseTabWidths[i] = btnWidth
                end

                for i, page in ipairs(pages) do
                    local tabButton = vgui.Create("liaTabButton", tabContainer)
                    tabButton:Dock(LEFT)
                    tabButton:DockMargin(i == 1 and 0 or baseMargin, 0, 0, 0)
                    tabButton:SetTall(36)
                    tabButton:SetText(localizeMenuLabel(page.name))
                    tabButton:SetActive(i == 1)
                    tabButton:SetWide(baseTabWidths[i] or 80)
                    tabButton:SetDoClick(function()
                        if activeTab == i then return end
                        lia.websound.playButtonSound()
                        if tabPanels[activeTab] then tabPanels[activeTab]:SetVisible(false) end
                        activeTab = i
                        tabPanels[i]:SetVisible(true)
                        for j, btn in ipairs(tabButtons) do
                            if IsValid(btn) then btn:SetActive(j == i) end
                        end

                        if page.drawFunc then page.drawFunc(tabPanels[i]) end
                    end)

                    tabButtons[i] = tabButton
                    local contentPanel = vgui.Create("DPanel", contentArea)
                    contentPanel:Dock(TOP)
                    contentPanel:SetVisible(i == 1)
                    contentPanel.Paint = function() end
                    contentPanel.PerformLayout = function(s) if IsValid(frame) and IsValid(tabContainer) then s:SetTall(frame:GetTall() - tabContainer:GetTall() - 20) end end
                    tabPanels[i] = contentPanel
                end

                local function AdjustTabWidths()
                    if not IsValid(tabContainer) then return end
                    local totalTabsWidth = 0
                    for _, width in pairs(baseTabWidths) do
                        totalTabsWidth = totalTabsWidth + width
                    end

                    local availableWidth = tabContainer:GetWide()
                    local totalMargins = baseMargin * (#pages - 1)
                    local extraSpace = availableWidth - totalTabsWidth - totalMargins
                    if extraSpace > 0 and #pages > 1 then
                        local extraPerTab = math.floor(extraSpace / #pages)
                        local adjustedWidths = {}
                        for tabId, baseWidth in pairs(baseTabWidths) do
                            adjustedWidths[tabId] = baseWidth + extraPerTab
                        end

                        local remainder = extraSpace % #pages
                        if remainder > 0 then
                            for remainderId = 1, math.min(remainder, #pages) do
                                adjustedWidths[remainderId] = adjustedWidths[remainderId] + 1
                            end
                        end

                        for childId, child in ipairs(tabContainer:GetChildren()) do
                            if adjustedWidths[childId] and IsValid(child) then child:SetWide(adjustedWidths[childId]) end
                        end
                    end
                end

                local originalPerformLayout = tabContainer.PerformLayout
                tabContainer.PerformLayout = function(s, w, h)
                    if originalPerformLayout then originalPerformLayout(s, w, h) end
                    timer.Simple(0, function() if IsValid(s) then AdjustTabWidths() end end)
                end

                if pages[1] and pages[1].drawFunc and IsValid(tabPanels[1]) then timer.Simple(0.01, function() if IsValid(tabPanels[1]) then pages[1].drawFunc(tabPanels[1]) end end) end
            end
        }
    end

    local hasThemesPrivilege = IsValid(LocalPlayer()) and LocalPlayer():hasPrivilege("accessEditConfigurationMenu") or false
    if hasThemesPrivilege then
        tabs["@themes"] = {
            name = "@themes",
            icon = "icon16/color_wheel.png",
            func = function(themesPanel)
                local frame = themesPanel:Add("liaFrame")
                frame:Dock(FILL)
                frame:DockMargin(10, 10, 10, 10)
                frame:SetTitle(L("themes"))
                frame:LiteMode()
                frame:DisableCloseBtn()
                local sheet = frame:Add("liaTabs")
                sheet:Dock(FILL)
                local function getLocalizedThemeName(themeID)
                    local properCaseName = themeID:gsub("(%a)([%w]*)", function(first, rest) return first:upper() .. rest:lower() end)
                    local localizationKey = "theme" .. properCaseName:gsub(" ", ""):gsub("-", "")
                    return L(localizationKey) or themeID
                end

                local function prettify(name)
                    name = name:gsub("_", " ")
                    return name:gsub("(%a)([%w]*)", function(first, rest) return first:upper() .. rest:lower() end)
                end

                local themeIDs = lia.color.getAllThemes()
                table.sort(themeIDs, function(a, b) return getLocalizedThemeName(a) < getLocalizedThemeName(b) end)
                local currentTheme = lia.color.getCurrentTheme()
                local statusUpdaters = {}
                local activeTabIndex
                for i, themeID in ipairs(themeIDs) do
                    local themeData = lia.color.themes[themeID]
                    if istable(themeData) then
                        local displayName = getLocalizedThemeName(themeID)
                        local page = vgui.Create("DPanel")
                        page:SetPaintBackground(false)
                        page:DockPadding(12, 12, 12, 12)
                        local header = page:Add("DPanel")
                        header:Dock(TOP)
                        header:SetTall(60)
                        header:SetPaintBackground(false)
                        local applyButton = header:Add("liaButton")
                        applyButton:Dock(TOP)
                        applyButton:DockMargin(0, 5, 0, 0)
                        applyButton:SetWide(200)
                        applyButton:SetTall(35)
                        applyButton:CenterHorizontal()
                        applyButton:SetText(L("apply"))
                        local scroll = page:Add("liaScrollPanel")
                        scroll:Dock(FILL)
                        local entries = {}
                        for key, value in pairs(themeData) do
                            if lia.color.isColor(value) then
                                entries[#entries + 1] = {
                                    name = key,
                                    colors = {value}
                                }
                            elseif istable(value) then
                                local colors = {}
                                for _, subValue in ipairs(value) do
                                    if lia.color.isColor(subValue) then colors[#colors + 1] = subValue end
                                end

                                if #colors > 0 then
                                    entries[#entries + 1] = {
                                        name = key,
                                        colors = colors
                                    }
                                end
                            end
                        end

                        table.sort(entries, function(a, b) return a.name < b.name end)
                        for _, entry in ipairs(entries) do
                            local row = scroll:Add("DPanel")
                            row:Dock(TOP)
                            row:DockMargin(0, 0, 0, 8)
                            row:SetTall(80)
                            row.Paint = function(_, w, h)
                                draw.RoundedBox(8, 0, 0, w, h, Color(24, 24, 24, 220))
                                draw.SimpleText(prettify(entry.name), "LiliaFont.17", 12, 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                                local swatchSize = h - 34
                                local gap = 10
                                local totalWidth = (#entry.colors * (swatchSize + gap)) - gap
                                local startX = w - totalWidth - 12
                                local swatchY = (h - swatchSize) * 0.5
                                for idx, col in ipairs(entry.colors) do
                                    local x = startX + (idx - 1) * (swatchSize + gap)
                                    draw.RoundedBox(6, x - 2, swatchY - 2, swatchSize + 4, swatchSize + 4, Color(200, 200, 200, 255))
                                    draw.RoundedBox(6, x, swatchY, swatchSize, swatchSize, col)
                                    surface.SetDrawColor(255, 255, 255, 255)
                                    surface.DrawOutlinedRect(x, swatchY, swatchSize, swatchSize)
                                    surface.DrawOutlinedRect(x + 1, swatchY + 1, swatchSize - 2, swatchSize - 2)
                                end
                            end
                        end

                        sheet:AddTab(displayName, page)
                        local function updateStatus()
                            local isActive = currentTheme == themeID
                            if IsValid(applyButton) then
                                applyButton:SetEnabled(not isActive)
                                applyButton:SetText(isActive and L("currentlySelected") or L("apply"))
                            end
                        end

                        table.insert(statusUpdaters, updateStatus)
                        updateStatus()
                        applyButton.DoClick = function()
                            if currentTheme == themeID then return end
                            lia.websound.playButtonSound()
                            net.Start("liaCfgSet")
                            net.WriteString("Theme")
                            net.WriteString(L("theme"))
                            net.WriteType(themeID)
                            net.SendToServer()
                        end

                        if themeID == currentTheme and not activeTabIndex then activeTabIndex = i end
                    end
                end

                if activeTabIndex then sheet:SetActiveTab(activeTabIndex) end
            end
        }
    end
end)

hook.Add("CanDisplayCharInfo", "liaF1MenuCanDisplayCharInfo", function(name)
    local client = LocalPlayer()
    if not client then return true end
    local character = client:getChar()
    if not character then return true end
    if not lia.class or not lia.class.list then return true end
    local class = lia.class.list[character:getClass()]
    if name == "class" and not class then return false end
    return true
end)
