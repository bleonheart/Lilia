lia.keybind = lia.keybind or {}
lia.keybind.stored = lia.keybind.stored or {}
local KeybindKeys = {
    ["first"] = KEY_FIRST,
    ["none"] = KEY_NONE,
    ["0"] = KEY_0,
    ["1"] = KEY_1,
    ["2"] = KEY_2,
    ["3"] = KEY_3,
    ["4"] = KEY_4,
    ["5"] = KEY_5,
    ["6"] = KEY_6,
    ["7"] = KEY_7,
    ["8"] = KEY_8,
    ["9"] = KEY_9,
    ["a"] = KEY_A,
    ["b"] = KEY_B,
    ["c"] = KEY_C,
    ["d"] = KEY_D,
    ["e"] = KEY_E,
    ["f"] = KEY_F,
    ["g"] = KEY_G,
    ["h"] = KEY_H,
    ["i"] = KEY_I,
    ["j"] = KEY_J,
    ["k"] = KEY_K,
    ["l"] = KEY_L,
    ["m"] = KEY_M,
    ["n"] = KEY_N,
    ["o"] = KEY_O,
    ["p"] = KEY_P,
    ["q"] = KEY_Q,
    ["r"] = KEY_R,
    ["s"] = KEY_S,
    ["t"] = KEY_T,
    ["u"] = KEY_U,
    ["v"] = KEY_V,
    ["w"] = KEY_W,
    ["x"] = KEY_X,
    ["y"] = KEY_Y,
    ["z"] = KEY_Z,
    ["kp_0"] = KEY_PAD_0,
    ["kp_1"] = KEY_PAD_1,
    ["kp_2"] = KEY_PAD_2,
    ["kp_3"] = KEY_PAD_3,
    ["kp_4"] = KEY_PAD_4,
    ["kp_5"] = KEY_PAD_5,
    ["kp_6"] = KEY_PAD_6,
    ["kp_7"] = KEY_PAD_7,
    ["kp_8"] = KEY_PAD_8,
    ["kp_9"] = KEY_PAD_9,
    ["kp_divide"] = KEY_PAD_DIVIDE,
    ["kp_multiply"] = KEY_PAD_MULTIPLY,
    ["kp_minus"] = KEY_PAD_MINUS,
    ["kp_plus"] = KEY_PAD_PLUS,
    ["kp_enter"] = KEY_PAD_ENTER,
    ["kp_decimal"] = KEY_PAD_DECIMAL,
    ["lbracket"] = KEY_LBRACKET,
    ["rbracket"] = KEY_RBRACKET,
    ["semicolon"] = KEY_SEMICOLON,
    ["apostrophe"] = KEY_APOSTROPHE,
    ["backquote"] = KEY_BACKQUOTE,
    ["comma"] = KEY_COMMA,
    ["period"] = KEY_PERIOD,
    ["slash"] = KEY_SLASH,
    ["backslash"] = KEY_BACKSLASH,
    ["minus"] = KEY_MINUS,
    ["equal"] = KEY_EQUAL,
    ["enter"] = KEY_ENTER,
    ["space"] = KEY_SPACE,
    ["backspace"] = KEY_BACKSPACE,
    ["tab"] = KEY_TAB,
    ["capslock"] = KEY_CAPSLOCK,
    ["numlock"] = KEY_NUMLOCK,
    ["escape"] = KEY_ESCAPE,
    ["scrolllock"] = KEY_SCROLLLOCK,
    ["insert"] = KEY_INSERT,
    ["ins"] = KEY_INSERT,
    ["delete"] = KEY_DELETE,
    ["del"] = KEY_DELETE,
    ["home"] = KEY_HOME,
    ["end"] = KEY_END,
    ["pageup"] = KEY_PAGEUP,
    ["pgup"] = KEY_PAGEUP,
    ["pagedown"] = KEY_PAGEDOWN,
    ["pgdn"] = KEY_PAGEDOWN,
    ["break"] = KEY_BREAK,
    ["lshift"] = KEY_LSHIFT,
    ["rshift"] = KEY_RSHIFT,
    ["lalt"] = KEY_LALT,
    ["ralt"] = KEY_RALT,
    ["lctrl"] = KEY_LCONTROL,
    ["rctrl"] = KEY_RCONTROL,
    ["lwin"] = KEY_LWIN,
    ["rwin"] = KEY_RWIN,
    ["app"] = KEY_APP,
    ["up"] = KEY_UP,
    ["left"] = KEY_LEFT,
    ["down"] = KEY_DOWN,
    ["right"] = KEY_RIGHT,
    ["f1"] = KEY_F1,
    ["f2"] = KEY_F2,
    ["f3"] = KEY_F3,
    ["f4"] = KEY_F4,
    ["f5"] = KEY_F5,
    ["f6"] = KEY_F6,
    ["f7"] = KEY_F7,
    ["f8"] = KEY_F8,
    ["f9"] = KEY_F9,
    ["f10"] = KEY_F10,
    ["f11"] = KEY_F11,
    ["f12"] = KEY_F12,
    ["capslocktoggle"] = KEY_CAPSLOCKTOGGLE,
    ["numlocktoggle"] = KEY_NUMLOCKTOGGLE,
    ["scrolllocktoggle"] = KEY_SCROLLLOCKTOGGLE,
    ["last"] = KEY_LAST
}

local KeybindNamesByCode = {}
for name, code in pairs(KeybindKeys) do
    if isnumber(code) and code ~= KEY_FIRST and code ~= KEY_LAST and KeybindNamesByCode[code] == nil then KeybindNamesByCode[code] = name end
end

local function localizeKeybindLabel(value, ...)
    if not isstring(value) then return value end
    local resolved = value
    if resolved ~= value then return resolved end
    return value
end

lia.keybind.localizeValue = localizeKeybindLabel
function lia.keybind.add(k, d, desc, cb)
    local actionName, key, description, callbacks, category
    if isstring(k) and istable(d) and desc == nil and cb == nil then
        actionName = k
        local config = d
        key = config.keyBind
        description = config.desc
        category = config.category
        callbacks = {
            onPress = config.onPress,
            onRelease = config.onRelease,
            shouldRun = config.shouldRun,
            serverOnly = config.serverOnly
        }
    else
        key = k
        actionName = d
        description = desc
        callbacks = cb
    end

    local c = isstring(key) and KeybindKeys[string.lower(key)] or key
    if not c then return end
    if not istable(callbacks) or not callbacks.onPress then
        lia.error("Keybind Add Invalid Callback Format" .. " '" .. tostring(actionName) .. "'. Must use table with 'onPress' function. (Function: lia.keybind.add)")
        return
    end

    lia.keybind.stored[actionName] = lia.keybind.stored[actionName] or {}
    if not lia.keybind.stored[actionName].value then lia.keybind.stored[actionName].value = c end
    lia.keybind.stored[actionName].default = c
    lia.keybind.stored[actionName].rawDescription = description
    lia.keybind.stored[actionName].description = isstring(description) and localizeKeybindLabel(description) or description
    lia.keybind.stored[actionName].rawCategory = category
    lia.keybind.stored[actionName].category = isstring(category) and localizeKeybindLabel(category) or category
    lia.keybind.stored[actionName].callback = callbacks.onPress
    lia.keybind.stored[actionName].release = callbacks.onRelease
    lia.keybind.stored[actionName].shouldRun = callbacks.shouldRun
    lia.keybind.stored[actionName].serverOnly = callbacks.serverOnly or false
    lia.keybind.stored[c] = actionName
end

function lia.keybind.getDisplayDescription(action)
    local data = lia.keybind.stored[action]
    if not data then return "" end
    local value = data.rawDescription or data.description or ""
    return isstring(value) and localizeKeybindLabel(value) or value
end

local function openMenuTab(tabKey)
    if not IsValid(LocalPlayer()) then return end
    local menu = IsValid(lia.gui.menu) and not lia.gui.menu.closing and lia.gui.menu or vgui.Create("liaMenu")
    if IsValid(menu) then menu:setActiveTab(tabKey) end
end

local standaloneInventoryCookie = "liaStandaloneInventory"
local function getStandaloneInventoryAccent()
    local theme = lia.color and lia.color.theme or {}
    local accent = theme.accent or theme.theme or lia.config and lia.config.get and lia.config.get("Color") or Color(108, 89, 214)
    if not istable(accent) or not accent.r or not accent.g or not accent.b then return Color(108, 89, 214) end
    return Color(accent.r, accent.g, accent.b, accent.a or 255)
end

local function getStandaloneInventoryTextColor(alpha)
    local theme = lia.color and lia.color.theme or {}
    local color = theme.text or Color(235, 241, 247)
    if not istable(color) or not color.r or not color.g or not color.b then color = Color(235, 241, 247) end
    return Color(color.r, color.g, color.b, alpha or color.a or 255)
end

local function getStandaloneInventoryMutedColor(alpha)
    return Color(164, 178, 194, alpha or 255)
end

local function drawStandaloneInventoryPanel(x, y, w, h, radius, color, outline)
    if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
        lia.derma.rect(x, y, w, h):Rad(radius or 0):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius or 0):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
        return
    end

    draw.RoundedBox(radius or 0, x, y, w, h, color)
    if outline then
        surface.SetDrawColor(outline)
        surface.DrawOutlinedRect(x, y, w, h)
    end
end

local function saveStandaloneInventoryGeometry(panel)
    if not IsValid(panel) then return end
    local x, y = panel:GetPos()
    local width = panel:GetWide()
    local height = panel.inventoryExpandedHeight or panel:GetTall()
    cookie.Set(standaloneInventoryCookie .. "X", tostring(math.floor(x)))
    cookie.Set(standaloneInventoryCookie .. "Y", tostring(math.floor(y)))
    cookie.Set(standaloneInventoryCookie .. "W", tostring(math.floor(width)))
    cookie.Set(standaloneInventoryCookie .. "H", tostring(math.floor(height)))
end

local function addStandaloneInventoryHeaderButton(parent, text, tooltip, callback)
    local button = parent:Add("DButton")
    button:Dock(RIGHT)
    button:SetWide(40)
    button:SetText(text)
    button:SetFont("LiliaFont.18")
    button:SetTextColor(getStandaloneInventoryTextColor())
    button:SetTooltip(tooltip)
    button.Paint = function(self, w, h)
        local accent = getStandaloneInventoryAccent()
        local alpha = self:IsHovered() and 120 or 65
        drawStandaloneInventoryPanel(0, 4, w, h - 8, 6, Color(accent.r, accent.g, accent.b, alpha), Color(accent.r, accent.g, accent.b, self:IsHovered() and 190 or 110))
    end

    button.DoClick = callback
    return button
end

local function getStandaloneItemCondition(item)
    if not item or not item.getData then return end
    local value = item:getData("condition")
    if value == nil then value = item:getData("durability") end
    if value == nil then value = item:getData("health") end
    value = tonumber(value)
    if not value then return end
    if value <= 1 then value = value * 100 end
    return math.Clamp(math.Round(value), 0, 100)
end

local function getStandaloneItemWeight(item)
    if not item then return end
    local value
    if isfunction(item.getWeight) then value = item:getWeight() end
    if value == nil and item.getData then value = item:getData("weight") end
    if value == nil then value = item.weight end
    value = tonumber(value)
    return value
end

local function getStandaloneItemQuantity(item)
    if not item then return end
    local value
    if item.getData then value = item:getData("quantity") end
    if value == nil then value = item.quantity end
    value = tonumber(value)
    if not value or value <= 1 then return end
    return math.floor(value)
end

local function getStandaloneItemModel(item)
    if not item then return end
    local model
    if isfunction(item.getModel) then model = item:getModel() end
    model = model or item.model
    if isstring(model) and model ~= "" then return model end
end

local function buildStandaloneInventoryActionInvoker(owner, actionKey, action, item, subOption, optionKey)
    return function()
        if not item or not action then return end
        item.player = LocalPlayer()
        local send = true
        if action.onClick then send = action.onClick(item, subOption and subOption.data) end
        local sound = action.sound
        if sound then
            if istable(sound) then
                LocalPlayer():EmitSound(unpack(sound))
            elseif isstring(sound) then
                surface.PlaySound(sound)
            end
        end

        if send ~= false then
            net.Start("liaInvAct")
            net.WriteString(actionKey)
            net.WriteType(item:getID())
            net.WriteType(optionKey or subOption and subOption.data)
            net.SendToServer()
        end

        item.player = nil
        if IsValid(owner) then timer.Simple(0, function() if IsValid(owner) and owner.refreshLiveInventory then owner:refreshLiveInventory() end end) end
    end
end

if CLIENT then
    local function styleStandaloneInventoryButton(button, primary, danger)
        button:SetFont("LiliaFont.18")
        button:SetTextColor(getStandaloneInventoryTextColor())
        button:SetCursor("hand")
        button.Paint = function(self, w, h)
            local accent = getStandaloneInventoryAccent()
            local hovered = self:IsHovered()
            local disabled = not self:IsEnabled()
            local fill
            local outline
            if disabled then
                fill = Color(255, 255, 255, 6)
                outline = Color(accent.r, accent.g, accent.b, 24)
            elseif primary then
                fill = hovered and Color(accent.r, accent.g, accent.b, 230) or Color(accent.r, accent.g, accent.b, 205)
                outline = Color(accent.r, accent.g, accent.b, 255)
            elseif danger then
                fill = hovered and Color(120, 36, 44, 205) or Color(12, 18, 27, 235)
                outline = hovered and Color(214, 96, 110, 200) or Color(accent.r, accent.g, accent.b, 80)
            else
                fill = hovered and Color(255, 255, 255, 12) or Color(8, 14, 24, 235)
                outline = hovered and Color(accent.r, accent.g, accent.b, 145) or Color(accent.r, accent.g, accent.b, 80)
            end

            drawStandaloneInventoryPanel(0, 0, w, h, 6, fill, outline)
            self:SetTextColor(primary and self:IsEnabled() and Color(16, 20, 28) or getStandaloneInventoryTextColor(disabled and 110 or 255))
        end
    end

    local function styleStandaloneInventorySearch(entry)
        entry:SetFont("LiliaFont.18")
        entry:SetTextColor(getStandaloneInventoryTextColor())
        entry:SetCursorColor(getStandaloneInventoryAccent())
        entry:SetHighlightColor(Color(getStandaloneInventoryAccent().r, getStandaloneInventoryAccent().g, getStandaloneInventoryAccent().b, 105))
        if entry.SetTextInset then entry:SetTextInset(50, 0) end
        entry.Paint = function(self, w, h)
            local accent = getStandaloneInventoryAccent()
            local focused = self:HasFocus()
            local hovered = self:IsHovered()
            local outline = focused and Color(accent.r, accent.g, accent.b, 180) or Color(accent.r, accent.g, accent.b, hovered and 110 or 70)
            local fill = focused and Color(accent.r, accent.g, accent.b, 14) or hovered and Color(255, 255, 255, 8) or Color(8, 14, 24, 225)
            drawStandaloneInventoryPanel(0, 0, w, h, 6, fill, outline)
            surface.SetDrawColor(160, 176, 191, 235)
            surface.DrawCircle(22, math.floor(h * 0.5) - 2, 7, 160, 176, 191, 235)
            surface.DrawLine(27, math.floor(h * 0.5) + 4, 33, math.floor(h * 0.5) + 10)
            if self:GetValue() == "" and not focused then draw.SimpleText("Search inventory...", "LiliaFont.18", 48, h * 0.5, getStandaloneInventoryMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            self:DrawTextEntryText(getStandaloneInventoryTextColor(), accent, getStandaloneInventoryTextColor())
        end
    end

    local PANEL = {}
    function PANEL:Init()
        self.selectedIcon = nil
        self.inventory = nil
        self.gridW = 0
        self.gridH = 0
        self.inventoryPadding = 18
        self.detailWidth = 320
        self.slotSize = 64
        self.grid = self:Add("liaGridInventoryPanel")
        self.grid.standaloneOwner = self
        self.grid.PaintOver = function(panel, w, h)
            local accent = getStandaloneInventoryAccent()
            if panel.standaloneOwner and panel.standaloneOwner.selectedIcon and IsValid(panel.standaloneOwner.selectedIcon) then
                local icon = panel.standaloneOwner.selectedIcon
                if icon:GetParent() == panel then
                    local x, y = icon:GetPos()
                    local iconW, iconH = icon:GetSize()
                    surface.SetDrawColor(accent.r, accent.g, accent.b, 170)
                    surface.DrawOutlinedRect(x - 1, y - 1, iconW + 2, iconH + 2, 2)
                end
            end
        end

        self.searchEntry = self:Add("DTextEntry")
        self.searchEntry:SetUpdateOnType(true)
        styleStandaloneInventorySearch(self.searchEntry)
        self.searchEntry.OnValueChange = function(_, value) if IsValid(self.grid) and self.grid.setSearchQuery then self.grid:setSearchQuery(value) end end
        self.categoryButton = self:Add("DButton")
        self.categoryButton:SetText("All items  ▾")
        styleStandaloneInventoryButton(self.categoryButton, false, false)
        self.categoryButton.DoClick = function() self:openCategoryMenu() end
        self.gridViewport = self:Add("EditablePanel")
        self.gridViewport.Paint = function(_, w, h)
            local accent = getStandaloneInventoryAccent()
            drawStandaloneInventoryPanel(0, 0, w, h, 8, Color(5, 11, 18, 240), Color(accent.r, accent.g, accent.b, 80))
        end

        self.grid:SetParent(self.gridViewport)
        self.detailPanel = self:Add("EditablePanel")
        self.detailPanel.Paint = function(_, w, h)
            local accent = getStandaloneInventoryAccent()
            drawStandaloneInventoryPanel(0, 0, w, h, 8, Color(7, 12, 20, 245), Color(accent.r, accent.g, accent.b, 80))
        end

        self.previewPanel = self.detailPanel:Add("EditablePanel")
        self.previewPanel.Paint = function(_, w, h)
            local accent = getStandaloneInventoryAccent()
            drawStandaloneInventoryPanel(0, 0, w, h, 7, Color(9, 14, 23, 235), Color(accent.r, accent.g, accent.b, 60))
        end

        self.previewIcon = self.previewPanel:Add("SpawnIcon")
        self.previewIcon:SetVisible(false)
        self.itemName = self.detailPanel:Add("DLabel")
        self.itemName:SetFont("LiliaFont.22")
        self.itemName:SetTextColor(getStandaloneInventoryTextColor())
        self.itemName:SetText("")
        self.itemName:SetContentAlignment(7)
        self.itemCategory = self.detailPanel:Add("DLabel")
        self.itemCategory:SetFont("LiliaFont.18")
        self.itemCategory:SetTextColor(Color(getStandaloneInventoryAccent().r, getStandaloneInventoryAccent().g, getStandaloneInventoryAccent().b, 255))
        self.itemCategory:SetText("")
        self.itemCategory:SetContentAlignment(7)
        self.itemDescription = self.detailPanel:Add("DLabel")
        self.itemDescription:SetFont("LiliaFont.16")
        self.itemDescription:SetTextColor(getStandaloneInventoryMutedColor())
        self.itemDescription:SetWrap(true)
        self.itemDescription:SetAutoStretchVertical(true)
        self.itemDescription:SetText("")
        self.statsPanel = self.detailPanel:Add("EditablePanel")
        self.statsPanel.Paint = function() end
        self.statLabels = {}
        for index = 1, 4 do
            local row = self.statsPanel:Add("DLabel")
            row:SetFont("LiliaFont.16")
            row:SetTextColor(getStandaloneInventoryTextColor())
            row:SetContentAlignment(4)
            row:SetText("")
            self.statLabels[index] = row
        end

        self.primaryAction = self.detailPanel:Add("DButton")
        self.primaryAction:SetText("Equip")
        styleStandaloneInventoryButton(self.primaryAction, true, false)
        self.primaryAction:SetEnabled(false)
        self.dropAction = self.detailPanel:Add("DButton")
        self.dropAction:SetText("Drop")
        styleStandaloneInventoryButton(self.dropAction, false, true)
        self.dropAction:SetEnabled(false)
        self.moreAction = self.detailPanel:Add("DButton")
        self.moreAction:SetText("Actions ▾")
        styleStandaloneInventoryButton(self.moreAction, false, false)
        self.moreAction:SetEnabled(false)
        self.footerPanel = self:Add("EditablePanel")
        self.footerPanel.Paint = function(_, w, h)
            local accent = getStandaloneInventoryAccent()
            drawStandaloneInventoryPanel(0, 0, w, h, 8, Color(7, 12, 20, 245), Color(accent.r, accent.g, accent.b, 80))
        end

        self.progressBar = self.footerPanel:Add("DPanel")
        self.progressBar.Paint = function(_, w, h)
            local accent = getStandaloneInventoryAccent()
            drawStandaloneInventoryPanel(0, 0, w, h, 3, Color(255, 255, 255, 10), nil)
            local frac = self:getSlotUsageFraction()
            drawStandaloneInventoryPanel(0, 0, math.max(math.floor(w * frac), 0), h, 3, Color(accent.r, accent.g, accent.b, 215), nil)
        end

        self.statusTitle = self.footerPanel:Add("DLabel")
        self.statusTitle:SetFont("LiliaFont.18")
        self.statusTitle:SetTextColor(getStandaloneInventoryTextColor())
        self.statusTitle:SetContentAlignment(4)
        self.statusValue = self.footerPanel:Add("DLabel")
        self.statusValue:SetFont("LiliaFont.18")
        self.statusValue:SetTextColor(Color(getStandaloneInventoryAccent().r, getStandaloneInventoryAccent().g, getStandaloneInventoryAccent().b, 255))
        self.statusValue:SetContentAlignment(6)
        self.emptyGridText = self.gridViewport:Add("DLabel")
        self.emptyGridText:SetFont("LiliaFont.18")
        self.emptyGridText:SetTextColor(getStandaloneInventoryMutedColor())
        self.emptyGridText:SetText("No items found")
        self.emptyGridText:SetVisible(false)
        self.emptyGridText:SetContentAlignment(5)
    end

    function PANEL:setInventory(inventory)
        self.inventory = inventory
        if not inventory then return end
        self.gridW, self.gridH = inventory:getSize()
        if self.grid.setGridSize then self.grid:setGridSize(self.gridW, self.gridH, self.slotSize) end
        if self.grid.setInventory then self.grid:setInventory(inventory) end
        if self.grid.setFilterCategory then self.grid:setFilterCategory(nil) end
        if self.grid.setSearchQuery then self.grid:setSearchQuery("") end
        self.searchEntry:SetValue("")
        self.categoryButton:SetText("All items  ▾")
        self.selectedIcon = nil
        self:updateSelectedItem()
        self:InvalidateLayout(true)
    end

    function PANEL:getUsedSlots()
        if not self.inventory then return 0 end
        local used = 0
        for _, item in pairs(self.inventory:getItems(true)) do
            local width = isfunction(item.getWidth) and item:getWidth() or item.width or 1
            local height = isfunction(item.getHeight) and item:getHeight() or item.height or 1
            used = used + width * height
        end
        return used
    end

    function PANEL:getTotalSlots()
        return math.max((self.gridW or 0) * (self.gridH or 0), 0)
    end

    function PANEL:getSlotUsageFraction()
        local total = self:getTotalSlots()
        if total <= 0 then return 0 end
        return math.Clamp(self:getUsedSlots() / total, 0, 1)
    end

    function PANEL:getSlotStatsText()
        return string.format("%d / %d slots used", self:getUsedSlots(), self:getTotalSlots())
    end

    function PANEL:getLoadStateText()
        local fraction = self:getSlotUsageFraction()
        if fraction >= 0.9 then return "Heavily Loaded" end
        if fraction >= 0.65 then return "Moderately Loaded" end
        if fraction >= 0.35 then return "Lightly Loaded" end
        if fraction > 0 then return "Lightly Loaded" end
        return "Empty"
    end

    function PANEL:getCategories()
        local categories = {}
        local seen = {}
        if not self.inventory then return categories end
        for _, item in pairs(self.inventory:getItems(true)) do
            local category = tostring(item.category or item.getData and item:getData("category") or "")
            if category ~= "" and not seen[category] then
                seen[category] = true
                categories[#categories + 1] = category
            end
        end

        table.sort(categories, function(a, b) return tostring(a):lower() < tostring(b):lower() end)
        return categories
    end

    function PANEL:openCategoryMenu()
        local menu = DermaMenu()
        menu:AddOption("All items", function()
            self.categoryButton:SetText("All items  ▾")
            if IsValid(self.grid) and self.grid.setFilterCategory then self.grid:setFilterCategory(nil) end
            self:refreshEmptyState()
        end)

        for _, category in ipairs(self:getCategories()) do
            menu:AddOption(category, function()
                self.categoryButton:SetText(category .. "  ▾")
                if IsValid(self.grid) and self.grid.setFilterCategory then self.grid:setFilterCategory(category) end
                self:refreshEmptyState()
            end)
        end

        menu:Open()
    end

    function PANEL:setSelectedIcon(icon)
        if self.selectedIcon == icon then
            self:updateSelectedItem()
            return
        end

        if IsValid(self.selectedIcon) and self.selectedIcon.setSelected then self.selectedIcon:setSelected(false) end
        self.selectedIcon = IsValid(icon) and icon or nil
        if IsValid(self.selectedIcon) and self.selectedIcon.setSelected then self.selectedIcon:setSelected(true) end
        self:updateSelectedItem()
        if IsValid(self.grid) then self.grid:InvalidateLayout() end
    end

    function PANEL:getSelectedItem()
        return IsValid(self.selectedIcon) and self.selectedIcon.itemTable or nil
    end

    function PANEL:getAvailableItemActions(item)
        local actions = {}
        if not item then return actions end
        item.player = LocalPlayer()
        for actionKey, action in SortedPairs(item.functions or {}) do
            local canRun = hook.Run("CanRunItemAction", item, actionKey) ~= false
            if canRun and isfunction(action.onCanRun) then canRun = action.onCanRun(item) end
            if canRun then
                actions[#actions + 1] = {
                    key = actionKey,
                    action = action
                }
            end
        end

        item.player = nil
        return actions
    end

    function PANEL:openMultiActionMenu(actionKey, action, item)
        item.player = LocalPlayer()
        local options = action.multiOptions
        if isfunction(options) then options = options(item, LocalPlayer()) end
        if not istable(options) then
            item.player = nil
            return
        end

        local menu = lia.derma and lia.derma.dermaMenu and lia.derma.dermaMenu() or DermaMenu()
        for optionKey, option in pairs(options) do
            if isfunction(option) then
                local subOption = {
                    name = optionKey,
                    onRun = option,
                    data = optionKey
                }

                menu:AddOption(optionKey, buildStandaloneInventoryActionInvoker(self, actionKey, action, item, subOption, optionKey), "icon16/brick.png")
            elseif istable(option) then
                local canRun = not isfunction(option[2]) or option[2](item, LocalPlayer())
                if canRun then
                    local subOption = {
                        name = option.name or optionKey,
                        onRun = option[1] or option.onRun,
                        icon = option.icon,
                        data = optionKey
                    }

                    menu:AddOption(subOption.name, buildStandaloneInventoryActionInvoker(self, actionKey, action, item, subOption, optionKey), subOption.icon or "icon16/brick.png")
                end
            end
        end

        menu:Open()
        item.player = nil
    end

    function PANEL:openItemActionMenu(item)
        if not item then return end
        local actions = self:getAvailableItemActions(item)
        if #actions == 0 then return end
        local menu = lia.derma and lia.derma.dermaMenu and lia.derma.dermaMenu() or DermaMenu()
        for _, actionInfo in ipairs(actions) do
            local actionKey = actionInfo.key
            local action = actionInfo.action
            local label = action.name or actionKey
            local isMulti = action.isMulti or action.multiOptions and (istable(action.multiOptions) or isfunction(action.multiOptions))
            local callback = isMulti and function() self:openMultiActionMenu(actionKey, action, item) end or buildStandaloneInventoryActionInvoker(self, actionKey, action, item)
            menu:AddOption(label, callback, action.icon or "icon16/brick.png")
        end

        menu:Open()
    end

    function PANEL:refreshActionButtons()
        local item = self:getSelectedItem()
        if not item then
            self.primaryAction:SetText("Equip")
            self.primaryAction:SetEnabled(false)
            self.primaryAction.DoClick = nil
            self.dropAction:SetText("Drop")
            self.dropAction:SetEnabled(false)
            self.dropAction.DoClick = nil
            self.moreAction:SetText("Actions ▾")
            self.moreAction:SetEnabled(false)
            self.moreAction.DoClick = nil
            return
        end

        local actions = self:getAvailableItemActions(item)
        local primary
        local drop
        for _, actionInfo in ipairs(actions) do
            if string.lower(tostring(actionInfo.key)) == "drop" then
                drop = actionInfo
            elseif not primary then
                primary = actionInfo
            end
        end

        if not primary then primary = drop end
        if primary then
            local action = primary.action
            local label = action.name or primary.key
            local isMulti = action.isMulti or action.multiOptions and (istable(action.multiOptions) or isfunction(action.multiOptions))
            self.primaryAction:SetText(label)
            self.primaryAction:SetEnabled(true)
            self.primaryAction.DoClick = isMulti and function() self:openMultiActionMenu(primary.key, action, item) end or buildStandaloneInventoryActionInvoker(self, primary.key, action, item)
        else
            self.primaryAction:SetText("Equip")
            self.primaryAction:SetEnabled(false)
            self.primaryAction.DoClick = nil
        end

        if drop then
            local action = drop.action
            self.dropAction:SetText(action.name or drop.key)
            self.dropAction:SetEnabled(true)
            self.dropAction.DoClick = buildStandaloneInventoryActionInvoker(self, drop.key, action, item)
        else
            self.dropAction:SetText("Drop")
            self.dropAction:SetEnabled(false)
            self.dropAction.DoClick = nil
        end

        self.moreAction:SetText("Actions ▾")
        self.moreAction:SetEnabled(#actions > 0)
        self.moreAction.DoClick = #actions > 0 and function() self:openItemActionMenu(item) end or nil
    end

    function PANEL:updateSelectedItem()
        local item = self:getSelectedItem()
        if not item then
            self.previewIcon:SetVisible(false)
            self.itemName:SetText("No item selected")
            self.itemCategory:SetText("Select an item")
            self.itemDescription:SetText("Choose an inventory item to view its details and actions.")
            for _, label in ipairs(self.statLabels) do
                label:SetText("")
            end

            self:refreshActionButtons()
            self:InvalidateLayout(true)
            return
        end

        local model = getStandaloneItemModel(item)
        if model then
            self.previewIcon:SetModel(model)
            self.previewIcon:SetVisible(true)
        else
            self.previewIcon:SetVisible(false)
        end

        local name = isfunction(item.getName) and item:getName() or tostring(item.name or "Item")
        local category = tostring(item.category or "Item")
        local description = isfunction(item.getDesc) and item:getDesc() or item.desc or ""
        description = tostring(description or "")
        if string.Trim(description) == "" then description = "No description available." end
        self.itemName:SetText(name)
        self.itemCategory:SetText(category)
        self.itemDescription:SetText(description)
        local stats = {}
        local condition = getStandaloneItemCondition(item)
        if condition then stats[#stats + 1] = string.format("Condition: %d%%", condition) end
        local weight = getStandaloneItemWeight(item)
        if weight then stats[#stats + 1] = string.format("Weight: %.2f", weight) end
        local quantity = getStandaloneItemQuantity(item)
        if quantity then stats[#stats + 1] = string.format("Quantity: %d", quantity) end
        local itemWidth = isfunction(item.getWidth) and item:getWidth() or item.width
        local itemHeight = isfunction(item.getHeight) and item:getHeight() or item.height
        if itemWidth and itemHeight then stats[#stats + 1] = string.format("Size: %sx%s", itemWidth, itemHeight) end
        for index, label in ipairs(self.statLabels) do
            label:SetText(stats[index] or "")
            label:SizeToContentsY()
        end

        self:refreshActionButtons()
        self:InvalidateLayout(true)
    end

    function PANEL:refreshEmptyState()
        if not IsValid(self.grid) then return end
        local hasVisible = false
        for _, child in ipairs(self.grid:GetChildren()) do
            if child ~= self.emptyGridText and child:IsVisible() then
                hasVisible = true
                break
            end
        end

        self.emptyGridText:SetVisible(not hasVisible)
    end

    function PANEL:refreshLiveInventory()
        if not self.inventory then return end
        local canonical = self.inventory
        if self.inventory.getID and lia.inventory and lia.inventory.instances then canonical = lia.inventory.instances[self.inventory:getID()] or self.inventory end
        self.inventory = canonical
        self.gridW, self.gridH = canonical:getSize()
        if IsValid(self.grid) then
            if self.grid.inventory ~= canonical and self.grid.setInventory then
                self.grid:setInventory(canonical)
            elseif self.grid.populateItems then
                self.grid:populateItems()
            end
        end

        self.statusTitle:SetText(self:getSlotStatsText())
        self.statusValue:SetText(self:getLoadStateText())
        self:updateSelectedItem()
        self:refreshEmptyState()
        self:InvalidateLayout(true)
    end

    function PANEL:PerformLayout(w, h)
        local pad = self.inventoryPadding
        local topTitleH = 32
        local topStatsH = 24
        local controlH = 52
        local controlY = pad + topTitleH + topStatsH + 18
        local footerH = 78
        local gridY = controlY + controlH + 18
        local detailW = math.Clamp(math.floor(w * 0.27), 280, 360)
        local gridAreaW = math.max(w - detailW - pad, 280)
        local footerY = h - footerH
        self.searchEntry:SetPos(pad, controlY)
        self.searchEntry:SetSize(math.max(gridAreaW - 190, 140), controlH)
        self.categoryButton:SetPos(pad + self.searchEntry:GetWide() + 12, controlY)
        self.categoryButton:SetSize(math.max(gridAreaW - self.searchEntry:GetWide() - 12, 150), controlH)
        local bodyH = math.max(footerY - gridY - 12, 220)
        self.gridViewport:SetPos(pad, gridY)
        self.gridViewport:SetSize(gridAreaW, bodyH)
        self.detailPanel:SetPos(pad + gridAreaW + pad, gridY)
        self.detailPanel:SetSize(detailW - pad, bodyH)
        self.footerPanel:SetPos(pad, footerY)
        self.footerPanel:SetSize(w - pad * 2, footerH)
        self.statusTitle:SetPos(18, 14)
        self.statusTitle:SetSize(self.footerPanel:GetWide() * 0.45, 22)
        self.progressBar:SetPos(18, 44)
        self.progressBar:SetSize(math.max(self.footerPanel:GetWide() * 0.58, 120), 10)
        self.statusValue:SetPos(self.footerPanel:GetWide() - 220, 12)
        self.statusValue:SetSize(200, 24)
        local detailInnerW = self.detailPanel:GetWide() - 24
        self.previewPanel:SetPos(12, 12)
        self.previewPanel:SetSize(detailInnerW, 190)
        self.previewIcon:SetPos(18, 18)
        self.previewIcon:SetSize(self.previewPanel:GetWide() - 36, self.previewPanel:GetTall() - 36)
        self.itemName:SetPos(12, 212)
        self.itemName:SetSize(detailInnerW, 26)
        self.itemCategory:SetPos(12, 242)
        self.itemCategory:SetSize(detailInnerW, 22)
        self.itemDescription:SetPos(12, 274)
        self.itemDescription:SetWide(detailInnerW)
        self.itemDescription:SizeToContentsY()
        local statsY = self.itemDescription:GetY() + self.itemDescription:GetTall() + 14
        self.statsPanel:SetPos(12, statsY)
        self.statsPanel:SetSize(detailInnerW, 112)
        local currentY = 0
        for _, label in ipairs(self.statLabels) do
            label:SetPos(0, currentY)
            label:SetSize(detailInnerW, 20)
            currentY = currentY + 24
        end

        local actionY = self.detailPanel:GetTall() - 108
        local buttonH = 42
        local buttonGap = 10
        local actionW = math.floor((detailInnerW - buttonGap) * 0.5)
        self.primaryAction:SetPos(12, actionY)
        self.primaryAction:SetSize(actionW, buttonH)
        self.dropAction:SetPos(12 + actionW + buttonGap, actionY)
        self.dropAction:SetSize(detailInnerW - actionW - buttonGap, buttonH)
        self.moreAction:SetPos(12, actionY + buttonH + 10)
        self.moreAction:SetSize(detailInnerW, buttonH)
        local gridContentW = math.max(self.gridViewport:GetWide() - 32, 64)
        local gridContentH = math.max(self.gridViewport:GetTall() - 32, 64)
        if self.gridW > 0 and self.gridH > 0 and IsValid(self.grid) and self.grid.setGridSize then
            local gap = self.grid.gap or 6
            local availableSlotW = (gridContentW - gap * math.max(self.gridW - 1, 0)) / self.gridW
            local availableSlotH = (gridContentH - gap * math.max(self.gridH - 1, 0)) / self.gridH
            self.slotSize = math.max(42, math.floor(math.min(availableSlotW, availableSlotH)))
            self.grid:setGridSize(self.gridW, self.gridH, self.slotSize)
            local pixelW
            local pixelH
            if self.grid.getGridPixelSize then
                pixelW, pixelH = self.grid:getGridPixelSize()
            else
                pixelW, pixelH = self.slotSize * self.gridW, self.slotSize * self.gridH
            end

            self.grid:SetSize(pixelW, pixelH)
            self.grid:SetPos(math.max(math.floor((self.gridViewport:GetWide() - pixelW) * 0.5), 16), math.max(math.floor((self.gridViewport:GetTall() - pixelH) * 0.5), 16))
        end

        self.emptyGridText:SetPos(0, 0)
        self.emptyGridText:SetSize(self.gridViewport:GetWide(), self.gridViewport:GetTall())
        self.statusTitle:SetText(self:getSlotStatsText())
        self.statusValue:SetText(self:getLoadStateText())
    end

    function PANEL:Paint(w, h)
        local accent = getStandaloneInventoryAccent()
        draw.SimpleText("Inventory", "LiliaFont.30", self.inventoryPadding, self.inventoryPadding, getStandaloneInventoryTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(self:getSlotStatsText(), "LiliaFont.18", self.inventoryPadding, self.inventoryPadding + 40, getStandaloneInventoryMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 55)
        surface.DrawRect(self.inventoryPadding, self.inventoryPadding + 74, w - self.inventoryPadding * 2, 1)
    end

    vgui.Register("liaStandaloneInventoryMenu", PANEL, "EditablePanel")
    hook.Add("InventoryItemIconCreated", "liaStandaloneInventoryItemHook", function(icon, item, panel)
        local owner = IsValid(panel) and panel.standaloneOwner
        if not IsValid(owner) or icon.liaStandaloneBound then return end
        icon.liaStandaloneBound = true
        local oldOnMousePressed = icon.OnMousePressed
        function icon:OnMousePressed(keyCode)
            if IsValid(owner) then owner:setSelectedIcon(self) end
            if oldOnMousePressed then return oldOnMousePressed(self, keyCode) end
        end
    end)

    local function queueStandaloneInventoryRefresh()
        timer.Create("liaStandaloneInventoryLiveRefresh", 0, 1, function()
            local frame = lia.gui and lia.gui.standaloneInventory
            if not IsValid(frame) then return end
            local content = frame.inventoryContent
            if IsValid(content) and content.refreshLiveInventory then content:refreshLiveInventory() end
        end)
    end

    hook.Add("InventoryInitialized", "liaStandaloneInventoryLiveInitialized", function(inventory)
        local frame = lia.gui and lia.gui.standaloneInventory
        if not IsValid(frame) or not inventory or not inventory.getID then return end
        local content = frame.inventoryContent
        if not IsValid(content) or not content.inventory or not content.inventory.getID then return end
        if inventory:getID() ~= content.inventory:getID() then return end
        queueStandaloneInventoryRefresh()
    end)

    hook.Add("InventoryItemAdded", "liaStandaloneInventoryLiveAdded", queueStandaloneInventoryRefresh)
    hook.Add("InventoryItemRemoved", "liaStandaloneInventoryLiveRemoved", queueStandaloneInventoryRefresh)
    hook.Add("ItemDataChanged", "liaStandaloneInventoryLiveData", queueStandaloneInventoryRefresh)
    hook.Add("ItemQuantityChanged", "liaStandaloneInventoryLiveQuantity", queueStandaloneInventoryRefresh)
end

local function createStandaloneGridInventory(inventory)
    local maxWidth = math.max(ScrW() - 40, 640)
    local maxHeight = math.max(ScrH() - 40, 420)
    local minWidth = math.min(960, maxWidth)
    local minHeight = math.min(620, maxHeight)
    local defaultWidth = math.min(1180, maxWidth)
    local defaultHeight = math.min(760, maxHeight)
    local width = math.Clamp(cookie.GetNumber(standaloneInventoryCookie .. "W", defaultWidth), minWidth, maxWidth)
    local height = math.Clamp(cookie.GetNumber(standaloneInventoryCookie .. "H", defaultHeight), minHeight, maxHeight)
    local defaultX = math.floor((ScrW() - width) * 0.5)
    local defaultY = math.floor((ScrH() - height) * 0.5)
    local x = math.Clamp(cookie.GetNumber(standaloneInventoryCookie .. "X", defaultX), 0, math.max(ScrW() - width, 0))
    local y = math.Clamp(cookie.GetNumber(standaloneInventoryCookie .. "Y", defaultY), 0, math.max(ScrH() - height, 0))
    local frame = vgui.Create("DFrame")
    if not IsValid(frame) then return end
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDeleteOnClose(true)
    frame:SetDraggable(false)
    frame:SetSizable(true)
    frame:SetScreenLock(true)
    frame:SetMinWidth(minWidth)
    frame:SetMinHeight(minHeight)
    frame:SetSize(width, height)
    frame:SetPos(x, y)
    frame.inventoryExpandedHeight = height
    frame.inventoryPinned = false
    if IsValid(frame.lblTitle) then frame.lblTitle:SetVisible(false) end
    if IsValid(frame.btnMinim) then frame.btnMinim:SetVisible(false) end
    if IsValid(frame.btnMaxim) then frame.btnMaxim:SetVisible(false) end
    frame.Paint = function(_, w, h)
        local accent = getStandaloneInventoryAccent()
        drawStandaloneInventoryPanel(0, 0, w, h, 8, Color(4, 10, 18, 248), Color(accent.r, accent.g, accent.b, 88))
    end

    local content = frame:Add(vgui.GetControlTable("liaStandaloneInventoryMenu") and "liaStandaloneInventoryMenu" or "liaGridInventoryMenu")
    content:Dock(FILL)
    content:DockMargin(16, 48, 16, 16)
    if content.setInventory then content:setInventory(inventory) end
    frame.inventoryContent = content
    local chrome = frame:Add("DPanel")
    chrome:SetMouseInputEnabled(true)
    chrome:SetZPos(32767)
    chrome.Paint = function(_, w, h)
        local accent = getStandaloneInventoryAccent()
        surface.SetDrawColor(accent.r, accent.g, accent.b, 48)
        surface.DrawRect(0, h - 1, w, 1)
    end

    chrome.OnMousePressed = function(_, keyCode)
        if keyCode ~= MOUSE_LEFT or frame.inventoryPinned then return end
        local mouseX, mouseY = gui.MousePos()
        local frameX, frameY = frame:GetPos()
        frame.inventoryDragging = true
        frame.inventoryDragOffsetX = mouseX - frameX
        frame.inventoryDragOffsetY = mouseY - frameY
        chrome:MouseCapture(true)
    end

    chrome.OnMouseReleased = function(_, keyCode)
        if keyCode ~= MOUSE_LEFT then return end
        frame.inventoryDragging = false
        chrome:MouseCapture(false)
    end

    chrome.Think = function()
        if not frame.inventoryDragging or frame.inventoryPinned then return end
        local mouseX, mouseY = gui.MousePos()
        local nextX = mouseX - (frame.inventoryDragOffsetX or 0)
        local nextY = mouseY - (frame.inventoryDragOffsetY or 0)
        nextX = math.Clamp(nextX, 0, math.max(ScrW() - frame:GetWide(), 0))
        nextY = math.Clamp(nextY, 0, math.max(ScrH() - 44, 0))
        frame:SetPos(nextX, nextY)
    end

    addStandaloneInventoryHeaderButton(chrome, "×", "Close", function() if IsValid(frame) then frame:Close() end end)
    local minimizeButton
    minimizeButton = addStandaloneInventoryHeaderButton(chrome, "—", "Minimize", function()
        if not IsValid(frame) then return end
        frame.inventoryMinimized = not frame.inventoryMinimized
        if frame.inventoryMinimized then
            frame.inventoryExpandedHeight = math.max(frame:GetTall(), minHeight)
            content:SetVisible(false)
            frame:SetSizable(false)
            frame:SetTall(52)
            minimizeButton:SetText("+")
        else
            content:SetVisible(true)
            frame:SetSizable(true)
            frame:SetTall(math.Clamp(frame.inventoryExpandedHeight or defaultHeight, minHeight, maxHeight))
            minimizeButton:SetText("—")
        end
    end)

    local pinButton
    pinButton = addStandaloneInventoryHeaderButton(chrome, "P", "Pin position", function()
        if not IsValid(frame) then return end
        frame.inventoryPinned = not frame.inventoryPinned
        frame.inventoryDragging = false
        chrome:MouseCapture(false)
        pinButton:SetText(frame.inventoryPinned and "•" or "P")
    end)

    local previousPerformLayout = frame.PerformLayout
    frame.PerformLayout = function(self, w, h)
        if previousPerformLayout then previousPerformLayout(self, w, h) end
        if IsValid(chrome) then
            chrome:SetPos(16, 10)
            chrome:SetSize(math.max(w - 32, 1), 34)
        end
    end

    local previousThink = frame.Think
    frame.Think = function(self)
        if previousThink then previousThink(self) end
        local escapeDown = input.IsKeyDown(KEY_ESCAPE)
        if escapeDown and not self.inventoryEscapeDown then
            self:Close()
            return
        end

        self.inventoryEscapeDown = escapeDown
    end

    local previousOnRemove = frame.OnRemove
    frame.OnRemove = function(self)
        saveStandaloneInventoryGeometry(self)
        if lia.gui and lia.gui.standaloneInventory == self then lia.gui.standaloneInventory = nil end
        if previousOnRemove then previousOnRemove(self) end
    end

    lia.gui = lia.gui or {}
    lia.gui.standaloneInventory = frame
    frame:MakePopup()
    frame:InvalidateLayout(true)
    return frame
end

local function createStandaloneListInventory(inventory)
    local panel = vgui.Create("liaListInventory")
    if not IsValid(panel) then return end
    panel:setInventory(inventory)
    panel:Center()
    panel:MakePopup()
    lia.gui = lia.gui or {}
    lia.gui.standaloneInventory = panel
    local previousOnRemove = panel.OnRemove
    panel.OnRemove = function(self)
        if lia.gui and lia.gui.standaloneInventory == self then lia.gui.standaloneInventory = nil end
        if previousOnRemove then previousOnRemove(self) end
    end
    return panel
end

local function toggleStandaloneInventory()
    if not CLIENT then return end
    lia.gui = lia.gui or {}
    local existing = lia.gui.standaloneInventory
    if IsValid(existing) then
        if existing.Close then
            existing:Close()
        else
            existing:Remove()
        end
        return
    end

    local client = LocalPlayer()
    if not IsValid(client) then return end
    local character = client:getChar()
    if not character then return end
    local inventory = character:getInv()
    if not inventory then return end
    if vgui.GetControlTable("liaGridInventoryMenu") then
        createStandaloneGridInventory(inventory)
    elseif vgui.GetControlTable("liaListInventory") then
        createStandaloneListInventory(inventory)
    end
end

lia.keybind.toggleStandaloneInventory = toggleStandaloneInventory
lia.keybind.add("openInventory", {
    keyBind = KEY_NONE,
    desc = "Opens your inventory menu",
    onPress = function() openMenuTab("inv") end
})

lia.keybind.add("quickInventory", {
    keyBind = KEY_I,
    desc = "Open the standalone quick inventory.",
    category = "inventory",
    shouldRun = function(client) return IsValid(client) and client:getChar() ~= nil end,
    onPress = toggleStandaloneInventory
})

if CLIENT then
    hook.Add("InitializedKeybinds", "liaQuickInventoryKeybindMigration", function()
        local menuBind = lia.keybind.stored.openInventory
        local quickBind = lia.keybind.stored.quickInventory
        if not menuBind or not quickBind then return end
        if menuBind.value ~= KEY_I or quickBind.value ~= KEY_I then return end
        if lia.keybind.stored[KEY_I] == "openInventory" then lia.keybind.stored[KEY_I] = nil end
        menuBind.value = KEY_NONE
        lia.keybind.stored[KEY_I] = "quickInventory"
        lia.keybind.save()
    end)
end

lia.keybind.add("adminMode", {
    keyBind = KEY_NONE,
    desc = "Toggles admin mode to switch between staff and regular character",
    serverOnly = true,
    shouldRun = function(client) return client:isStaff() end,
    onPress = function(client)
        if not IsValid(client) then return end
        local steamID = client:SteamID()
        client:ChatPrint("Admin Mode Toggled")
        if client:isStaffOnDuty() then
            local oldCharID = client.oldCharID or 0
            if oldCharID > 0 then
                local returnPos = client.ReturnPosition
                net.Start("liaAdminModeSwapCharacter")
                net.WriteInt(oldCharID, 32)
                net.Send(client)
                client.oldCharID = nil
                if returnPos then
                    local hookName = "liaAdminModeReturnPos_" .. client:SteamID64()
                    hook.Add("PostPlayerLoadedChar", hookName, function(ply, character)
                        if ply == client and IsValid(client) and client.ReturnPosition then
                            timer.Simple(0.2, function()
                                if IsValid(client) and client.ReturnPosition then
                                    client:SetPos(client.ReturnPosition)
                                    client.ReturnPosition = nil
                                end
                            end)

                            hook.Remove("PostPlayerLoadedChar", hookName)
                        end
                    end)

                    timer.Simple(5, function() if IsValid(client) then hook.Remove("PostPlayerLoadedChar", hookName) end end)
                end

                lia.log.add(client, "adminMode", oldCharID, "Switched back to their IC character")
            else
                client:notifyError("No previous character to swap to.")
            end
        else
            local currentChar = client:getChar()
            if currentChar and currentChar:getFaction() ~= FACTION_STAFF then client.ReturnPosition = client:GetPos() end
            lia.db.query("SELECT * FROM `lia_characters` WHERE `steamID` = " .. lia.db.convertDataType(steamID), function(data)
                for _, row in ipairs(data) do
                    local id = tonumber(row.id)
                    if row.faction == "staff" or tonumber(row.faction) == FACTION_STAFF then
                        client.oldCharID = client:getChar():getID()
                        net.Start("liaAdminModeSwapCharacter")
                        net.WriteInt(id, 32)
                        net.Send(client)
                        lia.log.add(client, "adminMode", id, "Switched to their staff character")
                        return
                    end
                end

                local canCreateStaffCharacter = client:hasPrivilege("createStaffCharacter")
                if canCreateStaffCharacter then
                    local staffCharData = {
                        steamID = steamID,
                        name = client:steamName(),
                        desc = "",
                        faction = FACTION_STAFF,
                        model = lia.faction.indices["staff"] and lia.faction.indices["staff"].models[1] or "models/Humans/Group02/male_07.mdl"
                    }

                    lia.char.create(staffCharData, function(charID)
                        if IsValid(client) and charID then
                            client.oldCharID = client:getChar():getID()
                            net.Start("liaAdminModeSwapCharacter")
                            net.WriteInt(charID, 32)
                            net.Send(client)
                            lia.log.add(client, "adminMode", charID, "Switched to their staff character")
                            client:notifySuccess("A staff character has been automatically created for you.")
                        end
                    end)
                else
                    client:notifyError("No staff character found. Create one in the staff faction.")
                end
            end)
        end
    end
})

lia.keybind.add("quickTakeItem", {
    keyBind = KEY_NONE,
    desc = "Quickly takes an item from the world when looking at it",
    serverOnly = true,
    onPress = function(client)
        if not client:getChar() then return end
        local entity = client:getTracedEntity()
        if IsValid(entity) and entity:isItem() then
            if entity:GetPos():Distance(client:GetPos()) > 96 then return end
            local item = entity:getItemTable()
            if item and item.functions and item.functions.take then item:interact("take", client, entity) end
        end
    end
})

lia.keybind.add("interactionMenu", {
    keyBind = KEY_TAB,
    desc = "Opens the interaction menu for nearby players and entities",
    category = "Core",
    onPress = function()
        net.Start("liaRequestInteractOptions")
        net.WriteString("interaction")
        net.SendToServer()
    end,
})

lia.keybind.add("personalActions", {
    keyBind = KEY_G,
    desc = "Opens the personal actions menu",
    category = "Core",
    onPress = function()
        net.Start("liaRequestInteractOptions")
        net.WriteString("action")
        net.SendToServer()
    end,
})

lia.keybind.add("freelook", {
    keyBind = KEY_ALT,
    desc = "Hold Freelook",
    category = "Camera",
    onPress = function() lia.camera.setManualFreelook(true) end,
    onRelease = function() lia.camera.setManualFreelook(false) end
})

lia.keybind.add("convertEntity", {
    keyBind = KEY_NONE,
    desc = "Converts a world entity into an item",
    onPress = function(client)
        if not IsValid(client) or not client:getChar() then return end
        local trace = client:GetEyeTrace()
        local targetEntity = trace.Entity
        if not IsValid(targetEntity) or targetEntity == client then return end
        if trace.HitPos:Distance(client:GetPos()) > 200 then
            client:notifyError("Entity is too far away.")
            return
        end

        if targetEntity:IsPlayer() or targetEntity:isItem() or targetEntity:GetClass() == "lia_money" then
            client:notifyError("Cannot convert this entity.")
            return
        end

        local hasItemDefinition = false
        local itemUniqueID = ""
        local targetEntityID = targetEntity:GetClass()
        for uniqueID, entityData in pairs(lia.item.itemEntities or {}) do
            if entityData[1] == targetEntityID then
                hasItemDefinition = true
                itemUniqueID = uniqueID
                break
            end
        end

        if not hasItemDefinition then
            client:notifyError("This entity type cannot be converted to an item.")
            return
        end

        if hook.Run("CanTakeEntity", client, targetEntity, itemUniqueID) == false then return end
        local character = client:getChar()
        local inventory = character:getInv()
        if not inventory:canAdd(itemUniqueID) then
            client:notifyError("No space available for the item.")
            return
        end

        inventory:add(itemUniqueID):next(function(item)
            client:notify(string.format("Successfully converted entity to item: %s", item:getName()))
            SafeRemoveEntity(targetEntity)
        end)
    end,
    shouldRun = function(client) return client:getChar() ~= nil end,
    serverOnly = true
})

if CLIENT then
    local GMODDefaultBindNames = {"+forward", "+back", "+moveleft", "+moveright", "+use", "+jump", "+duck", "+walk", "+speed", "+reload", "impulse 100", "+showscores", "messagemode", "messagemode2", "+menu_context", "+menu", "slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot7", "slot8", "slot9", "slot0", "undo", "+zoom",}
    function lia.keybind.buildReservedKeys()
        local reserved = {}
        for _, bindName in ipairs(GMODDefaultBindNames) do
            local keyName = input.LookupBinding(bindName)
            if isstring(keyName) and keyName ~= "" then
                local code = KeybindKeys[string.lower(keyName)]
                if isnumber(code) and code ~= KEY_NONE then reserved[code] = true end
            end
        end

        hook.Run("AddReservedKeybinds", reserved)
        lia.keybind.reservedKeys = reserved
    end

    hook.Add("PlayerButtonDown", "liaKeybindPress", function(p, b)
        local action = lia.keybind.stored[b]
        if not IsFirstTimePredicted() then return end
        if action and lia.keybind.stored[action] and lia.keybind.stored[action].callback then
            local data = lia.keybind.stored[action]
            if not data.shouldRun or data.shouldRun(p) then
                if data.serverOnly then
                    net.Start("liaKeybindServer")
                    net.WriteString(action)
                    net.WriteEntity(p)
                    net.SendToServer()
                else
                    data.callback(p)
                end
            end
        end
    end)

    hook.Add("PlayerButtonUp", "liaKeybindRelease", function(p, b)
        local action = lia.keybind.stored[b]
        if not IsFirstTimePredicted() then return end
        if action and lia.keybind.stored[action] and lia.keybind.stored[action].release then
            local data = lia.keybind.stored[action]
            if not data.shouldRun or data.shouldRun(p) then
                if data.serverOnly then
                    net.Start("liaKeybindServer")
                    net.WriteString(action .. "_release")
                    net.WriteEntity(p)
                    net.SendToServer()
                else
                    data.release(p)
                end
            end
        end
    end)

    function lia.keybind.get(a, df)
        local act = lia.keybind.stored[a]
        if act then return act.value or act.default or df end
        return df
    end

    function lia.keybind.save()
        local path = "lilia/keybinds.json"
        local d = {}
        for k, v in pairs(lia.keybind.stored) do
            if istable(v) and v.value then d[k] = v.value end
        end

        local j = util.TableToJSON(d)
        if j then
            local ok = file.Write(path, j)
            MsgC(Color(255, 200, 0), "[Keybind Save] " .. path .. " | " .. tostring(ok) .. " | " .. j .. "\n")
        end
    end

    function lia.keybind.load()
        local path = "lilia/keybinds.json"
        local d = file.Read(path, "DATA")
        if d then
            local s = util.JSONToTable(d)
            if s then
                for k, v in pairs(s) do
                    if lia.keybind.stored[k] then
                        if isstring(v) then
                            local keyCode = KeybindKeys[string.lower(v)]
                            lia.keybind.stored[k].value = keyCode or KEY_NONE
                        else
                            lia.keybind.stored[k].value = v
                        end
                    end
                end
            end
        else
            for _, v in pairs(lia.keybind.stored) do
                if istable(v) and v.default then v.value = v.default end
            end

            local out = {}
            for k, v in pairs(lia.keybind.stored) do
                if istable(v) and v.value then out[k] = v.value end
            end

            local json = util.TableToJSON(out)
            if json then file.Write(path, json) end
        end

        for k in pairs(lia.keybind.stored) do
            if isnumber(k) then lia.keybind.stored[k] = nil end
        end

        for action, data in pairs(lia.keybind.stored) do
            if istable(data) and data.value then lia.keybind.stored[data.value] = action end
        end

        lia.keybind.buildReservedKeys()
        hook.Run("InitializedKeybinds")
    end

    hook.Add("PopulateConfigurationButtons", "PopulateKeybinds", function(pages)
        local uiColors = {
            bg = Color(5, 18, 23, 220),
            bgSoft = Color(7, 20, 25, 237),
            row = Color(10, 25, 30, 232),
            rowHover = Color(16, 34, 40, 235),
            selected = Color(13, 30, 35, 225),
            border = Color(45, 190, 170, 78),
            text = Color(242, 247, 247),
            muted = Color(155, 178, 179),
            dim = Color(100, 120, 122),
            accent = Color(45, 190, 170),
            accentSoft = Color(45, 190, 170, 28)
        }

        local preferredCategories = {"Core", "Inventory", "Interaction", "Communication", "Admin", "UI / Menus", "Misc"}
        local categoryIcons = {}
        local function getAccent(alpha)
            local theme = lia.color and lia.color.theme or {}
            local color = theme.accent or theme.theme or lia.config and lia.config.get and lia.config.get("Color") or uiColors.accent
            if istable(color) and color.r and color.g and color.b then return Color(color.r, color.g, color.b, alpha or color.a or 255) end
            return Color(uiColors.accent.r, uiColors.accent.g, uiColors.accent.b, alpha or uiColors.accent.a or 255)
        end

        local function getTextColor(alpha)
            local theme = lia.color and lia.color.theme or {}
            local color = theme.text or uiColors.text
            if istable(color) and color.r and color.g and color.b then return Color(color.r, color.g, color.b, alpha or color.a or 255) end
            return Color(uiColors.text.r, uiColors.text.g, uiColors.text.b, alpha or uiColors.text.a or 255)
        end

        local function rounded(x, y, w, h, r, color)
            if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
                lia.derma.rect(x, y, w, h):Rad(r or 0):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
                return
            end

            draw.RoundedBox(r or 0, x, y, w, h, color)
        end

        local function outline(x, y, w, h, color)
            if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
                lia.derma.rect(x, y, w, h):Rad(6):Color(color):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
                return
            end

            surface.SetDrawColor(color)
            surface.DrawOutlinedRect(x, y, w, h)
        end

        local function styleScroll(scroll)
            local bar = scroll:GetVBar()
            if not IsValid(bar) then return end
            bar:SetWide(6)
            bar.Paint = function(_, w, h) rounded(2, 0, w - 2, h, 4, Color(255, 255, 255, 4)) end
            bar.btnGrip.Paint = function(_, w, h) rounded(1, 0, w - 1, h, 4, Color(getAccent().r, getAccent().g, getAccent().b, 185)) end
            bar.btnUp.Paint = function() end
            bar.btnDown.Paint = function() end
        end

        local function SetStyledTooltip(panel, text)
            if not text or text == "" then return end
            panel:SetTooltip(text)
            local oldSetTooltip = panel.SetTooltip
            function panel:SetTooltip(tooltipText)
                oldSetTooltip(self, tooltipText)
                timer.Simple(0, function()
                    if not IsValid(self) then return end
                    local tooltip = vgui.GetTooltipPanel()
                    if IsValid(tooltip) and not tooltip.LiliaStyled then
                        tooltip.LiliaStyled = true
                        tooltip:SetTextColor(uiColors.text)
                        function tooltip:Paint(w, h)
                            rounded(0, 0, w, h, 8, uiColors.bg)
                            outline(0, 0, w, h, Color(getAccent().r, getAccent().g, getAccent().b, 135))
                        end
                    end
                end)
            end
        end

        local function getDisplayKeyName(keycode, fallbackName)
            if not isnumber(keycode) or keycode == KEY_NONE then return "NONE" end
            local keyName = input.GetKeyName(keycode)
            if isstring(keyName) and keyName ~= "" then return string.upper(tostring(keyName)) end
            local resolvedFallback = fallbackName or KeybindNamesByCode[keycode]
            if isstring(resolvedFallback) and resolvedFallback ~= "" then return string.upper(tostring(resolvedFallback)) end
            return tostring(keycode)
        end

        local function getKeyChoiceSortKey(displayName, keycode)
            local normalizedCode = isnumber(keycode) and keycode or KEY_NONE
            return string.format("%s:%s:%08d", normalizedCode == KEY_NONE and "0" or "1", tostring(displayName or ""):lower(), normalizedCode + 32768)
        end

        local function getRawCategory(data)
            return data.rawCategory or data.category or "Misc"
        end

        local function getVisualCategory(action, data)
            local raw = tostring(getRawCategory(data) or "Misc")
            local localized = tostring(localizeKeybindLabel(raw) or raw)
            local lowerAction = tostring(action or ""):lower()
            local lowerCategory = localized:lower()
            if lowerCategory:find("inventory", 1, true) then return "Inventory" end
            if lowerCategory:find("interact", 1, true) then return "Interaction" end
            if lowerCategory:find("commun", 1, true) or lowerCategory:find("chat", 1, true) then return "Communication" end
            if lowerCategory:find("admin", 1, true) or lowerCategory:find("staff", 1, true) then return "Admin" end
            if lowerCategory:find("menu", 1, true) or lowerCategory:find("ui", 1, true) then return "UI / Menus" end
            if lowerCategory:find("misc", 1, true) then return "Misc" end
            if lowerAction:find("inventory", 1, true) or lowerAction:find("item", 1, true) then return "Inventory" end
            if lowerAction:find("convert", 1, true) or lowerAction:find("interact", 1, true) or lowerAction:find("take", 1, true) then return "Interaction" end
            if lowerAction:find("admin", 1, true) or lowerAction:find("staff", 1, true) then return "Admin" end
            if lowerAction:find("menu", 1, true) or lowerAction:find("action", 1, true) then return "Core" end
            return localized ~= "" and localized or "Misc"
        end

        local function sortCategories(categories)
            local sorted = {}
            local exists = {}
            for _, category in ipairs(preferredCategories) do
                if categories[category] then
                    sorted[#sorted + 1] = category
                    exists[category] = true
                end
            end

            local remaining = {}
            for category in pairs(categories) do
                if not exists[category] then remaining[#remaining + 1] = category end
            end

            table.sort(remaining, function(a, b) return tostring(a):lower() < tostring(b):lower() end)
            for _, category in ipairs(remaining) do
                sorted[#sorted + 1] = category
            end
            return sorted
        end

        local function makeButton(parent, text, width, primary)
            local button = parent:Add("DButton")
            button:SetText("")
            button:SetWide(width or 140)
            button:SetCursor("hand")
            button.Paint = function(s, w, h)
                local accent = getAccent(primary and 205 or 105)
                local fill = primary and Color(accent.r, accent.g, accent.b, s:IsHovered() and 230 or 205) or s:IsHovered() and uiColors.rowHover or uiColors.bgSoft
                rounded(0, 0, w, h, 6, fill)
                outline(0, 0, w, h, Color(accent.r, accent.g, accent.b, s:IsHovered() and 185 or 105))
                draw.SimpleText(text, "LiliaFont.18", w * 0.5, h * 0.5, getTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            return button
        end

        local function makeSection(parent, text, icon, count)
            local header = parent:Add("DPanel")
            header:Dock(TOP)
            header:SetTall(32)
            header:DockMargin(0, 8, 0, 0)
            header.Paint = function(_, w, h)
                local accent = getAccent()
                draw.SimpleText(string.upper(tostring(text or "")), "LiliaFont.18", 10, h * 0.52, Color(accent.r, accent.g, accent.b, 245), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(tostring(count or 0) .. " keybinds", "LiliaFont.16", w - 10, h * 0.52, uiColors.muted, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                surface.SetDrawColor(accent.r, accent.g, accent.b, 165)
                surface.DrawRect(0, h - 2, w, 1)
            end
            return header
        end

        local function buildTakenLookup()
            local taken = {}
            local total = 0
            for action, data in pairs(lia.keybind.stored) do
                if istable(data) then
                    total = total + 1
                    if isnumber(data.value) and data.value ~= KEY_NONE then taken[data.value] = action end
                end
            end
            return taken, total
        end

        local function countModified()
            local count = 0
            for _, data in pairs(lia.keybind.stored) do
                if istable(data) and data.default ~= nil and data.value ~= data.default then count = count + 1 end
            end
            return count
        end

        local function addKeybindField(scroll, action, data, allowEdit, taken, refreshFunc)
            local description = tostring(lia.keybind.getDisplayDescription(action) or "")
            local displayName = tostring(action or action)
            local row = scroll:Add("DPanel")
            row:Dock(TOP)
            row:SetTall(52)
            row:DockMargin(0, 0, 0, 2)
            SetStyledTooltip(row, description)
            row.Paint = function(s, w, h)
                rounded(0, 0, w, h, 6, s:IsHovered() and uiColors.rowHover or uiColors.row)
                outline(0, 0, w, h, Color(getAccent().r, getAccent().g, getAccent().b, 78))
            end

            local labels = row:Add("DPanel")
            labels:Dock(FILL)
            labels:DockMargin(14, 5, 18, 5)
            labels.Paint = function() end
            local title = labels:Add("DLabel")
            title:Dock(TOP)
            title:SetTall(21)
            title:SetText(displayName)
            title:SetFont("LiliaFont.18")
            title:SetTextColor(getTextColor())
            title:SetContentAlignment(4)
            SetStyledTooltip(title, description)
            local desc = labels:Add("DLabel")
            desc:Dock(FILL)
            desc:SetText(description ~= "" and description or "Press a key to perform this action.")
            desc:SetFont("LiliaFont.16")
            desc:SetTextColor(uiColors.muted)
            desc:SetContentAlignment(4)
            desc:SetWrap(false)
            SetStyledTooltip(desc, description)
            local currentKey = lia.keybind.get(action, KEY_NONE)
            if allowEdit then
                local resetButton = row:Add("DButton")
                resetButton:Dock(RIGHT)
                resetButton:SetWide(34)
                resetButton:DockMargin(8, 8, 10, 8)
                resetButton:SetText("")
                resetButton:SetCursor("hand")
                resetButton.Paint = function(s, w, h)
                    rounded(0, 0, w, h, 5, s:IsHovered() and uiColors.rowHover or uiColors.bgSoft)
                    outline(0, 0, w, h, Color(getAccent().r, getAccent().g, getAccent().b, s:IsHovered() and 150 or 85))
                    draw.SimpleText("R", "LiliaFont.18", w * 0.5, h * 0.5, getTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                resetButton.DoClick = function()
                    if isnumber(currentKey) and currentKey ~= KEY_NONE and lia.keybind.stored[currentKey] == action then lia.keybind.stored[currentKey] = nil end
                    data.value = data.default or KEY_NONE
                    local newKey = data.value
                    if isnumber(newKey) and newKey ~= KEY_NONE then lia.keybind.stored[newKey] = action end
                    lia.keybind.save()
                    if refreshFunc then refreshFunc() end
                end

                SetStyledTooltip(resetButton, "Reset this keybind to its default key.")
                local combo = row:Add("liaComboBox")
                combo:Dock(RIGHT)
                combo:SetWide(160)
                combo:DockMargin(0, 9, 0, 9)
                combo:SetFont("LiliaFont.18")
                SetStyledTooltip(combo, description)
                local currentKeyName = getDisplayKeyName(currentKey)
                combo:SetValue(currentKeyName)
                local choices = {}
                local seenCodes = {}
                for name, code in pairs(KeybindKeys) do
                    if code ~= KEY_FIRST and code ~= KEY_LAST and not seenCodes[code] and (not taken[code] or taken[code] == action or code == KEY_NONE) then
                        seenCodes[code] = true
                        local displayKey = getDisplayKeyName(code, name)
                        choices[#choices + 1] = {
                            txt = tostring(displayKey),
                            keycode = code,
                            sortKey = getKeyChoiceSortKey(displayKey, code)
                        }
                    end
                end

                table.sort(choices, function(a, b) return a.sortKey < b.sortKey end)
                local hasNone = false
                for _, choice in ipairs(choices) do
                    if choice.keycode == KEY_NONE then
                        hasNone = true
                        break
                    end
                end

                if not hasNone then
                    table.insert(choices, 1, {
                        txt = "NONE",
                        keycode = KEY_NONE,
                        sortKey = "0:none"
                    })
                end

                for _, choice in ipairs(choices) do
                    combo:AddChoice(choice.txt, choice.keycode)
                end

                combo.OnSelect = function(_, _, _, keyCode)
                    local newKey = isstring(keyCode) and KeybindKeys[string.lower(keyCode)] or keyCode
                    newKey = newKey or KEY_NONE
                    if newKey ~= KEY_NONE and taken[newKey] and taken[newKey] ~= action then
                        combo:SetValue(currentKeyName)
                        return
                    end

                    if isnumber(currentKey) and currentKey ~= KEY_NONE and lia.keybind.stored[currentKey] == action then lia.keybind.stored[currentKey] = nil end
                    data.value = newKey
                    if isnumber(newKey) and newKey ~= KEY_NONE then lia.keybind.stored[newKey] = action end
                    lia.keybind.save()
                    if refreshFunc then refreshFunc() end
                    local client = LocalPlayer()
                    if IsValid(client) then client:notifySuccess(string.format("Keybind '%s' changed to %s", localizeKeybindLabel(action), getDisplayKeyName(newKey))) end
                end
            else
                local valueLabel = row:Add("DLabel")
                valueLabel:Dock(RIGHT)
                valueLabel:SetWide(160)
                valueLabel:DockMargin(0, 0, 12, 0)
                valueLabel:SetText(getDisplayKeyName(currentKey))
                valueLabel:SetFont("LiliaFont.18")
                valueLabel:SetTextColor(getTextColor())
                valueLabel:SetContentAlignment(6)
            end
        end

        local function collectItems()
            local categories = {}
            local total = 0
            for action, data in pairs(lia.keybind.stored) do
                if istable(data) then
                    local category = getVisualCategory(action, data)
                    categories[category] = categories[category] or {}
                    categories[category][#categories[category] + 1] = {
                        key = action,
                        name = tostring(action or action),
                        desc = tostring(lia.keybind.getDisplayDescription(action) or ""),
                        data = data
                    }

                    total = total + 1
                end
            end

            for _, items in pairs(categories) do
                table.sort(items, function(a, b) return tostring(a.name or ""):lower() < tostring(b.name or ""):lower() end)
            end
            return categories, total
        end

        local function itemMatches(item, category, filter)
            if not filter or filter == "" then return true end
            local needle = filter:lower()
            return tostring(item.name or ""):lower():find(needle, 1, true) or tostring(item.desc or ""):lower():find(needle, 1, true) or tostring(item.key or ""):lower():find(needle, 1, true) or tostring(category or ""):lower():find(needle, 1, true)
        end

        pages[#pages + 1] = {
            name = "keybinds",
            shouldShow = function() return true end,
            drawFunc = function(parent)
                parent:Clear()
                parent:DockPadding(0, 0, 0, 0)
                local allowEdit = lia.config.get("AllowKeybindEditing", true)
                local categories, total = collectItems()
                local sortedCategories = sortCategories(categories)
                local selectedCategory = categories.Core and "Core" or sortedCategories[1]
                local filterText = ""
                local root = parent:Add("DPanel")
                root:Dock(FILL)
                root.Paint = function(_, w, h)
                    rounded(0, 0, w, h, 8, uiColors.bg)
                    outline(0, 0, w, h, Color(getAccent().r, getAccent().g, getAccent().b, 55))
                end

                local header = root:Add("DPanel")
                header:Dock(TOP)
                header:SetTall(72)
                header:DockMargin(14, 12, 14, 0)
                header.Paint = function() end
                local title = header:Add("DLabel")
                title:Dock(TOP)
                title:SetTall(32)
                title:SetText("Keybinds")
                title:SetFont("LiliaFont.22")
                title:SetTextColor(getTextColor())
                title:SetContentAlignment(4)
                local subtitle = header:Add("DLabel")
                subtitle:Dock(TOP)
                subtitle:SetTall(24)
                subtitle:SetText("Configure your action keybinds and reset them to defaults when needed.")
                subtitle:SetFont("LiliaFont.18")
                subtitle:SetTextColor(uiColors.muted)
                subtitle:SetContentAlignment(4)
                local toolbar = root:Add("DPanel")
                toolbar:Dock(TOP)
                toolbar:SetTall(42)
                toolbar:DockMargin(14, 0, 14, 10)
                toolbar.Paint = function() end
                local status = toolbar:Add("DPanel")
                status:Dock(RIGHT)
                status:SetWide(138)
                status:DockMargin(10, 3, 0, 3)
                status.Paint = function(_, w, h)
                    local accent = getAccent()
                    rounded(0, 0, w, h, 5, uiColors.bgSoft)
                    outline(0, 0, w, h, Color(accent.r, accent.g, accent.b, 80))
                    draw.SimpleText("Instant Save", "LiliaFont.18", w * 0.5, h * 0.5, getTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local categoryCombo = toolbar:Add("liaComboBox")
                categoryCombo:Dock(RIGHT)
                categoryCombo:SetWide(190)
                categoryCombo:DockMargin(0, 3, 0, 3)
                categoryCombo:SetFont("LiliaFont.18")
                categoryCombo:AddChoice("All Categories", "__all")
                for _, category in ipairs(sortedCategories) do
                    categoryCombo:AddChoice(category, category)
                end

                categoryCombo:SetValue(selectedCategory or "All Categories")
                local searchEntry = toolbar:Add("liaEntry")
                searchEntry:Dock(FILL)
                searchEntry:DockMargin(0, 3, 10, 3)
                searchEntry:SetPlaceholderText("Search keybinds..." or "Search keybinds...")
                searchEntry:SetFont("LiliaFont.18")
                local body = root:Add("DPanel")
                body:Dock(FILL)
                body:DockMargin(14, 0, 14, 0)
                body.Paint = function() end
                local rail = body:Add("DPanel")
                rail:Dock(LEFT)
                rail:SetWide(255)
                rail:DockMargin(0, 0, 12, 0)
                rail.Paint = function(_, w, h)
                    rounded(0, 0, w, h, 6, uiColors.bgSoft)
                    outline(0, 0, w, h, Color(getAccent().r, getAccent().g, getAccent().b, 78))
                end

                local railScroll = rail:Add("liaScrollPanel")
                railScroll:Dock(FILL)
                railScroll:DockMargin(8, 8, 8, 8)
                styleScroll(railScroll)
                local scroll = body:Add("liaScrollPanel")
                scroll:Dock(FILL)
                scroll:GetCanvas():DockPadding(0, 0, 0, 0)
                styleScroll(scroll)
                local footer = root:Add("DPanel")
                footer:Dock(BOTTOM)
                footer:SetTall(54)
                footer:DockMargin(14, 8, 14, 14)
                footer.Paint = function(_, w, h)
                    surface.SetDrawColor(Color(getAccent().r, getAccent().g, getAccent().b, 78))
                    surface.DrawRect(0, 0, w, 1)
                end

                local footerStatus = footer:Add("DLabel")
                footerStatus:Dock(LEFT)
                footerStatus:SetWide(520)
                footerStatus:SetFont("LiliaFont.18")
                footerStatus:SetTextColor(uiColors.muted)
                footerStatus:SetContentAlignment(4)
                local resetButton = makeButton(footer, "Reset All Keybinds", 180, false)
                resetButton:Dock(RIGHT)
                resetButton:DockMargin(8, 9, 0, 8)
                local function refreshFooter()
                    if not IsValid(footerStatus) then return end
                    footerStatus:SetText(total .. " keybinds    |    " .. countModified() .. " modified    |    Changes save automatically to data/lilia/keybinds.json")
                end

                local populate
                local rebuildRail
                rebuildRail = function()
                    railScroll:Clear()
                    local function addRailButton(label, value)
                        local button = railScroll:Add("DButton")
                        button:Dock(TOP)
                        button:SetTall(48)
                        button:DockMargin(0, 0, 0, 6)
                        button:SetText("")
                        button:SetCursor("hand")
                        button.Paint = function(s, w, h)
                            local active = selectedCategory == value or (not selectedCategory and value == nil)
                            local accent = getAccent()
                            rounded(0, 0, w, h, 5, active and uiColors.selected or s:IsHovered() and uiColors.rowHover or uiColors.bgSoft)
                            outline(0, 0, w, h, active and Color(accent.r, accent.g, accent.b, 170) or Color(getAccent().r, getAccent().g, getAccent().b, 78))
                            if active then
                                surface.SetDrawColor(accent.r, accent.g, accent.b, 235)
                                surface.DrawRect(0, 0, 3, h)
                            end

                            local count = value and categories[value] and #categories[value] or total
                            draw.SimpleText(label, "LiliaFont.18", 16, h * 0.38, active and getTextColor() or uiColors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            draw.SimpleText(count .. " keybinds", "LiliaFont.16", 16, h * 0.68, uiColors.muted, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end

                        button.DoClick = function()
                            selectedCategory = value
                            if IsValid(categoryCombo) then categoryCombo:SetValue(value or "All Categories") end
                            rebuildRail()
                            populate(filterText)
                        end
                    end

                    addRailButton("All Keybinds", nil)
                    for _, category in ipairs(sortedCategories) do
                        addRailButton(category, category)
                    end
                end

                populate = function(filter)
                    if not IsValid(scroll) then return end
                    local taken = buildTakenLookup()
                    filterText = filter or ""
                    scroll:Clear()
                    local hasAny = false
                    local categoriesToDraw = selectedCategory and {selectedCategory} or sortedCategories
                    for _, category in ipairs(categoriesToDraw) do
                        local items = categories[category]
                        local visible = {}
                        if items then
                            for _, item in ipairs(items) do
                                if itemMatches(item, category, filterText) then visible[#visible + 1] = item end
                            end
                        end

                        if #visible > 0 then
                            hasAny = true
                            makeSection(scroll, category, categoryIcons[category], #visible)
                            for _, item in ipairs(visible) do
                                addKeybindField(scroll, item.key, item.data, allowEdit, taken, function() populate(filterText) end)
                            end
                        end
                    end

                    if not hasAny then
                        local empty = scroll:Add("DPanel")
                        empty:Dock(TOP)
                        empty:SetTall(90)
                        empty.Paint = function(_, w, h)
                            rounded(0, 0, w, h, 6, uiColors.bgSoft)
                            outline(0, 0, w, h, Color(getAccent().r, getAccent().g, getAccent().b, 78))
                            draw.SimpleText("No keybinds match your search.", "LiliaFont.18", w * 0.5, h * 0.5, uiColors.muted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end
                    end

                    refreshFooter()
                end

                resetButton.DoClick = function()
                    for action, data in pairs(lia.keybind.stored) do
                        if istable(data) then
                            local oldValue = data.value
                            if isnumber(oldValue) and oldValue ~= KEY_NONE and lia.keybind.stored[oldValue] == action then lia.keybind.stored[oldValue] = nil end
                            data.value = data.default or KEY_NONE
                        end
                    end

                    for action, data in pairs(lia.keybind.stored) do
                        if istable(data) and isnumber(data.value) and data.value ~= KEY_NONE then lia.keybind.stored[data.value] = action end
                    end

                    lia.keybind.save()
                    populate(filterText)
                end

                searchEntry:SetUpdateOnType(true)
                searchEntry.OnTextChanged = function(_, text) populate(text) end
                categoryCombo.OnSelect = function(_, _, _, value)
                    selectedCategory = value == "__all" and nil or value
                    rebuildRail()
                    populate(filterText)
                end

                rebuildRail()
                populate(nil)
                refreshFooter()
            end
        }
    end)
end

hook.Add("PreLiliaLoaded", "liaMenuTabKeybinds", function()
    local tabs = {}
    hook.Run("CreateMenuButtons", tabs)
    for tabKey, tabData in pairs(tabs) do
        local selectedTabKey = tabKey
        local action = "openMenuTab_" .. tostring(tabKey)
        local tabName = istable(tabData) and tabData.name or tabKey
        local description = string.format("Opens the %s tab", localizeKeybindLabel(tabName))
        lia.keybind.add(action, {
            keyBind = KEY_NONE,
            desc = description,
            category = "menu",
            onPress = function() openMenuTab(selectedTabKey) end
        })
    end
end)
