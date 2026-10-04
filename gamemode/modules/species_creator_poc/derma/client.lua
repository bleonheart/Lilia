local module = MODULE
local fallbackAccent = Color(45, 190, 170)
local fallbackText = Color(230, 239, 239)
local fallbackBackground = Color(5, 18, 23)
local fallbackNegative = Color(205, 74, 74)
local tabDefinitions = {
    {
        name = "MODEL & SEX",
        short = "Model"
    },
    {
        name = "APPEARANCE",
        short = "Appearance"
    },
    {
        name = "INFORMATION",
        short = "Information"
    },
    {
        name = "ATTRIBUTES",
        short = "Attributes"
    },
    {
        name = "TRAITS",
        short = "Traits"
    },
    {
        name = "LANGUAGES",
        short = "Languages"
    },
    {
        name = "STARTING KIT",
        short = "Starting Kit"
    },
    {
        name = "SUMMARY & FINISH",
        short = "Summary"
    }
}

local months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
local function getThemeColor(source, fallback, alpha)
    fallback = IsColor(fallback) and fallback or fallbackText
    source = IsColor(source) and source or fallback
    return Color(source.r, source.g, source.b, alpha or source.a or fallback.a or 255)
end

local function mixThemeColors(from, to, fraction, alpha)
    from = IsColor(from) and from or fallbackBackground
    to = IsColor(to) and to or fallbackText
    fraction = math.Clamp(tonumber(fraction) or 0, 0, 1)
    return Color(math.Round(Lerp(fraction, from.r, to.r)), math.Round(Lerp(fraction, from.g, to.g)), math.Round(Lerp(fraction, from.b, to.b)), alpha or math.Round(Lerp(fraction, from.a or 255, to.a or 255)))
end

local function getActiveThemePalette()
    local gui = lia and lia.gui
    local creator = gui and gui.speciesCreator
    if IsValid(creator) and isfunction(creator.GetPreviewThemeData) then
        local previewTheme = creator:GetPreviewThemeData()
        if istable(previewTheme) then return previewTheme end
    end
    return lia.color and lia.color.theme or {}
end

local function bindThemedLabel(label, colorFunc)
    if not IsValid(label) then return end
    label.Think = function(s) if isfunction(colorFunc) then s:SetTextColor(colorFunc()) end end
end

local function formatThemeLabel(themeID)
    local label = string.Trim(tostring(themeID or "")):gsub("_", " "):gsub("%s+", " ")
    if label == "" then return "Unknown Theme" end
    return label:gsub("(%a)([%w_']*)", function(first, rest) return string.upper(first) .. string.lower(rest or "") end)
end

local function getThemePreviewColors(themeData)
    local colors = {}
    for _, value in pairs(themeData or {}) do
        if IsColor(value) then
            colors[#colors + 1] = value
        elseif istable(value) then
            for _, nested in ipairs(value) do
                if IsColor(nested) then
                    colors[#colors + 1] = nested
                    if #colors >= 4 then break end
                end
            end
        end

        if #colors >= 4 then break end
    end
    return colors
end

local function getThemeAccent(alpha)
    local colorLibrary = lia.color or {}
    local theme = getActiveThemePalette()
    local source = theme.maincolor or theme.accent
    if not IsColor(source) and isfunction(colorLibrary.getMainColor) then source = colorLibrary.getMainColor() end
    return getThemeColor(source, fallbackAccent, alpha)
end

local function getThemeTextColor(fallback, alpha)
    local theme = getActiveThemePalette()
    return getThemeColor(theme.text or theme.foreground, fallback or fallbackText, alpha)
end

local function getThemeBackgroundColor(fallback, alpha)
    local theme = getActiveThemePalette()
    return getThemeColor(theme.background or theme.panel or theme.window, fallback or fallbackBackground, alpha)
end

local function getThemeSurface(strength, alpha)
    return mixThemeColors(getThemeBackgroundColor(fallbackBackground, 255), getThemeTextColor(fallbackText, 255), strength or 0.04, alpha)
end

local function getThemeMutedColor(alpha)
    return mixThemeColors(getThemeTextColor(fallbackText, 255), getThemeBackgroundColor(fallbackBackground, 255), 0.38, alpha or 190)
end

local function getThemeDisabledColor(alpha)
    return mixThemeColors(getThemeTextColor(fallbackText, 255), getThemeBackgroundColor(fallbackBackground, 255), 0.64, alpha or 120)
end

local function getThemeNegativeColor(alpha)
    local colorLibrary = lia.color or {}
    local theme = getActiveThemePalette()
    local source = theme.negative
    if not IsColor(source) and isfunction(colorLibrary.calculateNegativeColor) then source = colorLibrary.calculateNegativeColor(getThemeAccent()) end
    return getThemeColor(source, fallbackNegative, alpha)
end

local function drawPanel(x, y, w, h, radius, background, outline)
    if lia.derma and lia.derma.rect then
        lia.derma.rect(x, y, w, h):Rad(radius):Color(background):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
        return
    end

    draw.RoundedBox(radius, x, y, w, h, background)
    if outline then
        surface.SetDrawColor(outline)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end
end

local function copyValue(value)
    if istable(value) then return table.Copy(value) end
    return value
end

local function normalizeModelPath(path)
    return string.Trim(tostring(path or "")):gsub("\\", "/")
end

local function formatHeight(value)
    local totalInches = math.max(math.floor(tonumber(value) or 0), 0)
    return string.format("%d'%d\"", math.floor(totalInches / 12), totalInches % 12)
end

local function notifyError(message)
    local client = LocalPlayer()
    if IsValid(client) and isfunction(client.notifyError) then
        client:notifyError(tostring(message or "Unknown error"))
    else
        chat.AddText(getThemeNegativeColor(), tostring(message or "Unknown error"))
    end
end

local function notifyInfo(message)
    local client = LocalPlayer()
    if IsValid(client) and isfunction(client.notifyInfo) then
        client:notifyInfo(tostring(message or ""))
    else
        chat.AddText(getThemeAccent(), tostring(message or ""))
    end
end

local function makeButton(parent, text, secondary)
    local button = parent:Add("DButton")
    button:SetText("")
    button._text = text
    button._hover = 0
    button.Think = function(s)
        local target = s:IsHovered() and s:IsEnabled() and 1 or 0
        s._hover = Lerp(FrameTime() * 12, s._hover or 0, target)
    end

    button.Paint = function(s, w, h)
        local accent = secondary and getThemeNegativeColor() or getThemeAccent()
        local hover = s._hover or 0
        local background = Color(accent.r, accent.g, accent.b, secondary and 18 + hover * 16 or 25 + hover * 26)
        local outline = Color(accent.r, accent.g, accent.b, 75 + hover * 100)
        if not s:IsEnabled() then
            background = getThemeSurface(0.025, 205)
            outline = getThemeMutedColor(45)
        end

        drawPanel(0, 0, w, h, 6, background, outline)
        draw.SimpleText(s._text, "LiliaFont.18", w * 0.5, h * 0.5, s:IsEnabled() and getThemeTextColor(fallbackText) or getThemeDisabledColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    return button
end

local function makeEntry(parent, title, multiline)
    local wrap = parent:Add("DPanel")
    wrap:SetMouseInputEnabled(true)
    wrap:SetKeyboardInputEnabled(true)
    wrap.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
        draw.SimpleText(title, "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local entry = wrap:Add("DTextEntry")
    entry:SetMouseInputEnabled(true)
    entry:SetKeyboardInputEnabled(true)
    entry:SetFont("LiliaFont.18")
    entry:SetTextColor(getThemeTextColor(fallbackText))
    entry:SetCursorColor(getThemeAccent())
    entry:SetHighlightColor(getThemeAccent(100))
    entry:SetDrawBackground(false)
    entry:SetPaintBackground(false)
    entry:SetPaintBorderEnabled(false)
    entry:SetMultiline(multiline)
    entry.Think = function(s)
        s:SetTextColor(getThemeTextColor(fallbackText))
        s:SetCursorColor(getThemeAccent())
        s:SetHighlightColor(getThemeAccent(100))
    end

    wrap.PerformLayout = function(_, w, h)
        entry:SetPos(13, 34)
        entry:SetSize(w - 26, h - 46)
    end
    return wrap, entry
end

local function makeSlider(parent, title, suffix)
    local wrap = parent:Add("DPanel")
    wrap:SetMouseInputEnabled(true)
    wrap:SetKeyboardInputEnabled(true)
    wrap.minimum = 0
    wrap.maximum = 1
    wrap.value = 0
    wrap.suffix = suffix or ""
    wrap.Paint = function(s, w, h)
        local accent = getThemeAccent()
        local formatter = isfunction(s.formatter) and s.formatter or function(value) return tostring(math.Round(tonumber(value) or 0)) .. s.suffix end
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
        draw.SimpleText(title, "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(formatter(s.value), "LiliaFont.18", w - 13, 9, getThemeTextColor(fallbackText), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText(formatter(s.minimum), "LiliaFont.15", 13, h - 9, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(formatter(s.maximum), "LiliaFont.15", w - 13, h - 9, getThemeMutedColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    end

    local slider = wrap:Add("liaSlider")
    slider:SetMouseInputEnabled(true)
    slider:SetKeyboardInputEnabled(true)
    slider:SetRange(0, 1, 0)
    wrap.PerformLayout = function(_, w)
        slider:SetPos(0, 38)
        slider:SetSize(w, 20)
    end
    return wrap, slider
end

local comboMenuOptionHeight = 36
local comboMenuEdgePadding = 8
local comboMenuMaxHeight = 380
local activeComboMenu
local function getComboMenuChoices(combo)
    local choices = {}
    for index, label in ipairs(combo.Choices or {}) do
        choices[#choices + 1] = {
            index = index,
            label = tostring(label or "")
        }
    end

    if combo:GetSortItems() then table.sort(choices, function(a, b) return string.lower(a.label) < string.lower(b.label) end) end
    return choices
end

local function themeComboScrollBar(scrollPanel)
    if not IsValid(scrollPanel) or not isfunction(scrollPanel.GetVBar) then return end
    local vbar = scrollPanel:GetVBar()
    if not IsValid(vbar) then return end
    vbar:SetWide(10)
    vbar:SetHideButtons(true)
    vbar.Paint = function(_, w, h)
        surface.SetDrawColor(getThemeSurface(0.02, 210))
        surface.DrawRect(0, 0, w, h)
    end

    if IsValid(vbar.btnGrip) then
        vbar.btnGrip.Paint = function(_, w, h)
            local accent = getThemeAccent()
            draw.RoundedBox(3, 2, 2, math.max(w - 4, 1), math.max(h - 4, 1), Color(accent.r, accent.g, accent.b, 155))
        end
    end
end

local function scrollComboMenu(menu, delta)
    if not IsValid(menu) or not IsValid(menu.scrollPanel) then return false end
    local vbar = menu.scrollPanel:GetVBar()
    if not IsValid(vbar) or not vbar.Enabled then return false end
    vbar:SetScroll(vbar:GetScroll() - (tonumber(delta) or 0) * comboMenuOptionHeight * 3)
    return true
end

local function bindComboMenuWheel(panel, menu)
    if not IsValid(panel) then return end
    panel.OnMouseWheeled = function(_, delta) return scrollComboMenu(menu, delta) end
end

local function styleComboOption(combo, menu, option, optionIndex, optionLabel)
    option:SetText("")
    option:SetTall(comboMenuOptionHeight)
    option.Paint = function(s, w, h)
        local accent = getThemeAccent()
        local selected = combo:GetSelectedID() == optionIndex or tostring(combo:GetValue()) == optionLabel
        local hovered = s:IsHovered()
        local background = selected and Color(accent.r, accent.g, accent.b, 30) or hovered and Color(accent.r, accent.g, accent.b, 18) or getThemeSurface(0.045, 246)
        drawPanel(1, 0, math.max(w - 2, 1), h, 4, background, Color(accent.r, accent.g, accent.b, selected and 135 or hovered and 82 or 32))
        if selected then
            surface.SetDrawColor(accent.r, accent.g, accent.b, 220)
            surface.DrawRect(1, 4, 3, math.max(h - 8, 1))
        end

        draw.SimpleText(optionLabel, "LiliaFont.18", 12, h * 0.5, selected and getThemeAccent() or getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        return true
    end

    option.DoClick = function()
        if not IsValid(combo) then return end
        local overlay = menu:GetParent()
        timer.Simple(0, function()
            if IsValid(combo) then combo:ChooseOption(optionLabel, optionIndex) end
            if IsValid(overlay) then overlay:Remove() end
        end)
    end

    bindComboMenuWheel(option, menu)
end

local function openComboMenu(combo)
    if not IsValid(combo) or #(combo.Choices or {}) == 0 then return end
    combo:CloseMenu()
    if IsValid(activeComboMenu) then activeComboMenu:Remove() end
    local choices = getComboMenuChoices(combo)
    local totalHeight = #choices * comboMenuOptionHeight
    local comboX, comboTop = combo:LocalToScreen(0, 0)
    local _, comboBottom = combo:LocalToScreen(0, combo:GetTall())
    local belowSpace = math.max(ScrH() - comboBottom - comboMenuEdgePadding, 0)
    local aboveSpace = math.max(comboTop - comboMenuEdgePadding, 0)
    local openBelow = totalHeight <= belowSpace or belowSpace >= aboveSpace
    local availableHeight = openBelow and belowSpace or aboveSpace
    local menuHeight = math.max(math.min(totalHeight, comboMenuMaxHeight, availableHeight), math.min(comboMenuOptionHeight, math.max(ScrH() - comboMenuEdgePadding * 2, 1)))
    local menuY = openBelow and comboBottom or comboTop - menuHeight
    local overlay = vgui.Create("DPanel", vgui.GetWorldPanel())
    if not IsValid(overlay) then return end
    combo.Menu = overlay
    activeComboMenu = overlay
    overlay:SetPos(0, 0)
    overlay:SetSize(ScrW(), ScrH())
    overlay:SetMouseInputEnabled(true)
    overlay:SetKeyboardInputEnabled(false)
    overlay:SetDrawOnTop(true)
    overlay:SetZPos(32767)
    overlay.Paint = function() end
    overlay.OnMousePressed = function(s, mouseCode)
        if mouseCode ~= MOUSE_LEFT and mouseCode ~= MOUSE_RIGHT then return end
        s.closeOnRelease = true
        s:MouseCapture(true)
    end

    overlay.OnMouseReleased = function(s, mouseCode)
        if not s.closeOnRelease or mouseCode ~= MOUSE_LEFT and mouseCode ~= MOUSE_RIGHT then return end
        s.closeOnRelease = false
        s:MouseCapture(false)
        timer.Simple(0, function() if IsValid(s) then s:Remove() end end)
    end

    overlay.OnRemove = function()
        if IsValid(combo) and combo.Menu == overlay then combo.Menu = nil end
        if activeComboMenu == overlay then activeComboMenu = nil end
    end

    local menu = overlay:Add("DPanel")
    menu:SetPos(math.Clamp(comboX, comboMenuEdgePadding, math.max(ScrW() - combo:GetWide() - comboMenuEdgePadding, comboMenuEdgePadding)), menuY)
    menu:SetSize(combo:GetWide(), menuHeight)
    menu:SetMouseInputEnabled(true)
    menu:SetKeyboardInputEnabled(false)
    menu:SetZPos(1)
    menu.Paint = function(_, w, h) drawPanel(0, 0, w, h, 5, getThemeSurface(0.035, 252), getThemeAccent(72)) end
    menu.scrollPanel = menu:Add("DScrollPanel")
    menu.scrollPanel:Dock(FILL)
    menu.scrollPanel:SetMouseInputEnabled(true)
    menu.scrollPanel:SetKeyboardInputEnabled(false)
    menu.scrollPanel.Paint = function() end
    themeComboScrollBar(menu.scrollPanel)
    bindComboMenuWheel(menu, menu)
    bindComboMenuWheel(menu.scrollPanel, menu)
    bindComboMenuWheel(menu.scrollPanel:GetCanvas(), menu)
    local canvas = menu.scrollPanel:GetCanvas()
    canvas.PerformLayout = function(s, w)
        local y = 0
        for _, option in ipairs(s:GetChildren()) do
            option:SetPos(0, y)
            option:SetSize(w, comboMenuOptionHeight)
            y = y + comboMenuOptionHeight
        end

        s:SetTall(y)
    end

    for _, choice in ipairs(choices) do
        local option = canvas:Add("DButton")
        styleComboOption(combo, menu, option, choice.index, choice.label)
    end

    canvas:SetTall(totalHeight)
    canvas:InvalidateLayout(true)
    overlay:MakePopup()
    overlay:SetKeyboardInputEnabled(false)
    overlay:SetZPos(32767)
    overlay:MoveToFront()
    timer.Simple(0, function()
        if not IsValid(combo) or not IsValid(overlay) or combo.Menu ~= overlay then return end
        menu.scrollPanel:InvalidateLayout(true)
        themeComboScrollBar(menu.scrollPanel)
        bindComboMenuWheel(menu.scrollPanel:GetCanvas(), menu)
        overlay:SetZPos(32767)
        overlay:MoveToFront()
    end)
end

local function makeCombo(parent, title)
    local wrap = parent:Add("DPanel")
    wrap:SetMouseInputEnabled(true)
    wrap:SetKeyboardInputEnabled(true)
    wrap.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
        draw.SimpleText(title, "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local combo = wrap:Add("DComboBox")
    combo:SetMouseInputEnabled(true)
    combo:SetKeyboardInputEnabled(true)
    combo:SetFont("LiliaFont.18")
    combo:SetTextColor(getThemeTextColor(fallbackText))
    combo:SetSortItems(false)
    combo.Think = function(s) s:SetTextColor(getThemeTextColor(fallbackText)) end
    combo.OpenMenu = function(s) openComboMenu(s) end
    combo.CloseMenu = function(s)
        if IsValid(s.Menu) then s.Menu:Remove() end
        s.Menu = nil
    end

    combo.Paint = function(s, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 5, getThemeSurface(0.025, 220), Color(accent.r, accent.g, accent.b, s:IsHovered() and 110 or 48))
    end

    wrap.PerformLayout = function(_, w, h)
        combo:SetPos(11, 33)
        combo:SetSize(w - 22, h - 43)
    end
    return wrap, combo
end

local function drawHumanIcon(x, y, size, color)
    local half = size * 0.5
    local points = {
        {
            x = x + half,
            y = y
        },
        {
            x = x + size,
            y = y + size * 0.26
        },
        {
            x = x + size,
            y = y + size * 0.74
        },
        {
            x = x + half,
            y = y + size
        },
        {
            x = x,
            y = y + size * 0.74
        },
        {
            x = x,
            y = y + size * 0.26
        }
    }

    draw.NoTexture()
    surface.SetDrawColor(color)
    surface.DrawPoly(points)
    surface.SetDrawColor(getThemeTextColor(fallbackText, 225))
    surface.DrawLine(x + size * 0.2, y + size * 0.34, x + size * 0.8, y + size * 0.66)
    surface.DrawLine(x + size * 0.8, y + size * 0.34, x + size * 0.2, y + size * 0.66)
end

local function drawVortIcon(x, y, size, color)
    draw.NoTexture()
    for index = 0, 2 do
        local top = y + index * size * 0.22
        local points = {
            {
                x = x + size * 0.5,
                y = top
            },
            {
                x = x + size * 0.84,
                y = top + size * 0.28
            },
            {
                x = x + size * 0.62,
                y = top + size * 0.28
            },
            {
                x = x + size * 0.5,
                y = top + size * 0.16
            },
            {
                x = x + size * 0.38,
                y = top + size * 0.28
            },
            {
                x = x + size * 0.16,
                y = top + size * 0.28
            }
        }

        surface.SetDrawColor(color)
        surface.DrawPoly(points)
    end
end

local function drawTranshumanIcon(x, y, size, color)
    draw.NoTexture()
    for index = 0, 2 do
        local offset = index * size * 0.23
        local points = {
            {
                x = x + offset,
                y = y + size
            },
            {
                x = x + size * 0.38 + offset,
                y = y + size * 0.18
            },
            {
                x = x + size * 0.76 + offset,
                y = y + size
            }
        }

        surface.SetDrawColor(color)
        surface.DrawPoly(points)
    end
end

local function drawSpeciesIcon(speciesID, x, y, size, color)
    if speciesID == "vortigaunts" then
        drawVortIcon(x, y, size, color)
    elseif speciesID == "transhumans" then
        drawTranshumanIcon(x, y, size, color)
    else
        drawHumanIcon(x, y, size, color)
    end
end

local function getWrappedTextLines(text, font, maxWidth)
    surface.SetFont(font)
    maxWidth = math.max(tonumber(maxWidth) or 1, 1)
    local source = tostring(text or ""):gsub("\r", "")
    local lines = {}
    for _, paragraph in ipairs(string.Explode("\n", source, false)) do
        local words = string.Explode(" ", paragraph, false)
        local tokens = {}
        for _, word in ipairs(words) do
            local remaining = word
            while remaining ~= "" and surface.GetTextSize(remaining) > maxWidth do
                local length = 1
                for index = 1, #remaining do
                    if surface.GetTextSize(string.sub(remaining, 1, index)) > maxWidth then break end
                    length = index
                end

                tokens[#tokens + 1] = string.sub(remaining, 1, length)
                remaining = string.sub(remaining, length + 1)
            end

            if remaining ~= "" then tokens[#tokens + 1] = remaining end
        end

        local line = ""
        for _, word in ipairs(tokens) do
            local candidate = line == "" and word or line .. " " .. word
            if surface.GetTextSize(candidate) > maxWidth and line ~= "" then
                lines[#lines + 1] = line
                line = word
            else
                line = candidate
            end
        end

        if line ~= "" then
            lines[#lines + 1] = line
        elseif paragraph == "" then
            lines[#lines + 1] = ""
        end
    end
    return lines
end

local function drawWrappedText(text, font, x, y, maxWidth, lineHeight, color, maxLines, align)
    local lines = getWrappedTextLines(text, font, maxWidth)
    local count = math.min(#lines, maxLines or #lines)
    for index = 1, count do
        local value = lines[index]
        if index == count and #lines > count then value = value .. "…" end
        draw.SimpleText(value, font, x, y + (index - 1) * lineHeight, color, align or TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    return count, #lines
end

local function fitText(text, font, maxWidth)
    text = tostring(text or "")
    surface.SetFont(font)
    if surface.GetTextSize(text) <= maxWidth then return text end
    local suffix = "…"
    local low = 0
    local high = #text
    while low < high do
        local middle = math.ceil((low + high) * 0.5)
        if surface.GetTextSize(string.sub(text, 1, middle) .. suffix) <= maxWidth then
            low = middle
        else
            high = middle - 1
        end
    end
    return string.sub(text, 1, low) .. suffix
end

local function tableCount(values)
    local count = 0
    for _, selected in pairs(values or {}) do
        if selected then count = count + 1 end
    end
    return count
end

local function getAttributeID(attribute)
    local id = string.Trim(tostring(attribute and (attribute.id or attribute.name) or "")):lower():gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
    return id ~= "" and id or nil
end

local PANEL = {}
function PANEL:Init()
    lia.gui.speciesCreator = self
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2, 0)
    self.cursorWasVisible = vgui.CursorVisible()
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self.inputWindow = vgui.Create("DFrame")
    self.inputWindow:SetPos(0, 0)
    self.inputWindow:SetSize(ScrW(), ScrH())
    self.inputWindow:SetTitle("")
    self.inputWindow:ShowCloseButton(false)
    self.inputWindow:SetDraggable(false)
    self.inputWindow:SetSizable(false)
    self.inputWindow:SetDeleteOnClose(false)
    self.inputWindow:SetPaintShadow(false)
    self.inputWindow:SetMouseInputEnabled(true)
    self.inputWindow:SetKeyboardInputEnabled(true)
    self.inputWindow:SetCursor("arrow")
    self.inputWindow.Paint = function() end
    self.inputWindow:MakePopup()
    self.inputWindow:SetZPos(32767)
    self.inputWindow:MoveToFront()
    self.inputWindow:RequestFocus()
    self.inputWindow.OnKeyCodePressed = function(_, key) if IsValid(self) then self:OnKeyCodePressed(key) end end
    self.species = module:GetAvailableSpecies(LocalPlayer())
    self.selectedSpeciesIndex = 0
    self.selectedOriginIndex = 0
    self.selectedModelIndex = 1
    self.selectedSexID = nil
    self.selectedEyeColor = nil
    self.selectedHairColor = nil
    self.selectedSkin = 0
    self.selectedBodygroups = {}
    self.selectedPronouns = nil
    self.selectedTraits = {}
    self.selectedAttributes = {}
    self.selectedLanguages = {}
    self.languageSelectionOrder = {}
    self.selectedKitItems = {}
    self.selectedOutfitID = nil
    self.selectedHeight = 69
    self.currentCreationTab = 1
    self.visitedTabs = {}
    self.creating = false
    self.inCreation = false
    self.previewThemeID = lia.color and isfunction(lia.color.getCurrentTheme) and lia.color.getCurrentTheme() or "teal"
    self.hookID = "liaSpeciesCreator" .. tostring(self):gsub("[^%w]", "")
    self.speciesButtons = {}
    self.originButtons = {}
    self.themeButtons = {}
    self.availableThemes = istable(lia.color and lia.color.getAllThemes and lia.color.getAllThemes()) and lia.color.getAllThemes() or {"teal"}
    self.selectedThemeID = string.lower(tostring(lia.color and lia.color.getCurrentThemeName and lia.color.getCurrentThemeName() or "teal"))
    if not istable(lia.color and lia.color.themes) or not lia.color.themes[self.selectedThemeID] then self.selectedThemeID = self.availableThemes[1] or "teal" end
    self.paper = self.inputWindow:Add("DPanel")
    self.paper:SetMouseInputEnabled(true)
    self.paper:SetKeyboardInputEnabled(true)
    self.paper:SetZPos(1)
    self.paper.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 10, getThemeSurface(0.025, 238), Color(accent.r, accent.g, accent.b, 92))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 190)
        surface.DrawRect(0, 0, w, 2)
        surface.DrawRect(0, h - 2, w, 2)
    end

    self.closeButton = self.paper:Add("DButton")
    self.closeButton:SetText("")
    self.closeButton.Paint = function(s, w, h)
        local background = s:IsHovered() and getThemeNegativeColor(38) or getThemeSurface(0.05, 235)
        drawPanel(0, 0, w, h, 5, background, getThemeNegativeColor(s:IsHovered() and 150 or 70))
        draw.SimpleText("×", "LiliaFont.22", w * 0.5, h * 0.5 - 1, getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.closeButton.DoClick = function() self:Remove() end
    self.closeButton:SetZPos(1000)
    self.selectionPage = self.paper:Add("DPanel")
    self.selectionPage:SetZPos(10)
    self.selectionPage:SetMouseInputEnabled(true)
    self.selectionPage:SetKeyboardInputEnabled(true)
    self.selectionPage.Paint = function() end
    self.creationPage = self.paper:Add("DPanel")
    self.creationPage:SetZPos(20)
    self.creationPage:SetVisible(false)
    self.creationPage:SetMouseInputEnabled(false)
    self.creationPage:SetKeyboardInputEnabled(false)
    self.creationPage.Paint = function() end
    self:BuildSelectionPage()
    self:BuildCreationPage()
    self:SetupInputFallback()
    self:SetupWorldScene()
    timer.Simple(0, function()
        if not IsValid(self) then return end
        if #self.species > 0 then
            self:SelectSpecies(1)
        else
            self.speciesNameLabel:SetText("No Species")
            self.speciesDescriptionLabel:SetText("No species profiles are configured.")
            self.continueButton:SetEnabled(false)
        end

        self:InvalidateLayout(true)
    end)
end

function PANEL:GetPreviewThemeData()
    local themes = lia.color and lia.color.themes or {}
    local selected = string.lower(tostring(self.selectedThemeID or ""))
    return themes[selected] or lia.color and lia.color.theme or {}
end

function PANEL:SetPreviewTheme(themeID)
    local normalized = string.lower(string.Trim(tostring(themeID or "")))
    local themes = lia.color and lia.color.themes or {}
    if normalized == "" or not istable(themes[normalized]) or self.selectedThemeID == normalized then return end
    self.selectedThemeID = normalized
    if IsValid(self.themeScroll) then self.themeScroll:InvalidateLayout(true) end
    if IsValid(self.selectionThemeScroll) then self.selectionThemeScroll:InvalidateLayout(true) end
    if IsValid(self.paper) then self.paper:InvalidateLayout(true) end
    if IsValid(self.creationPage) then self.creationPage:InvalidateLayout(true) end
    if IsValid(self.selectionPage) then self.selectionPage:InvalidateLayout(true) end
end

function PANEL:BuildThemeButtons(scrollPanel, storageKey, compact)
    if not IsValid(scrollPanel) then return end
    self[storageKey] = {}
    for _, themeID in ipairs(self.availableThemes or {}) do
        local button = scrollPanel:Add("DButton")
        button:SetText("")
        button.themeID = themeID
        button._hover = 0
        button.Think = function(s)
            local target = s:IsHovered() and 1 or 0
            s._hover = Lerp(FrameTime() * 12, s._hover or 0, target)
        end

        button.Paint = function(s, w, h)
            local active = string.lower(tostring(self.selectedThemeID or "")) == s.themeID
            local themeData = lia.color and lia.color.themes and lia.color.themes[s.themeID] or nil
            local accent = getThemeColor(themeData and (themeData.maincolor or themeData.accent), fallbackAccent)
            local background = active and Color(accent.r, accent.g, accent.b, 34) or getThemeSurface(compact and 0.04 or 0.05, 235)
            local outline = Color(accent.r, accent.g, accent.b, active and 180 or 52 + (s._hover or 0) * 78)
            drawPanel(0, 0, w, h, 6, background, outline)
            draw.RoundedBox(4, 10, 11, 18, 18, accent)
            draw.SimpleText(formatThemeLabel(s.themeID), compact and "LiliaFont.16" or "LiliaFont.17", 38, 11, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            if compact then
                local previewColors = getThemePreviewColors(themeData or {})
                local startX = w - 14 - math.max(#previewColors, 1) * 16
                for colorIndex, col in ipairs(previewColors) do
                    draw.RoundedBox(4, startX + (colorIndex - 1) * 16, h * 0.5 - 6, 12, 12, col)
                end
            else
                draw.SimpleText(active and "SELECTED" or string.upper(s.themeID), "LiliaFont.14", 38, 30, active and accent or getThemeMutedColor(175), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end

        button.DoClick = function(s) self:SetPreviewTheme(s.themeID) end
        self[storageKey][#self[storageKey] + 1] = button
    end
end

function PANEL:BuildThemeSidebar()
    self.themeSidebar = self.creationPage:Add("DPanel")
    self.themeSidebar:SetMouseInputEnabled(true)
    self.themeSidebar:SetKeyboardInputEnabled(true)
    self.themeSidebar.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 222), Color(accent.r, accent.g, accent.b, 55))
        draw.SimpleText("THEMES", "LiliaFont.20", 14, 12, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Preview the creator in a different palette.", "LiliaFont.15", 14, 38, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 70)
        surface.DrawRect(14, 62, math.max(w - 28, 1), 1)
    end

    self.themeScroll = self.themeSidebar:Add("DScrollPanel")
    self.themeScroll:SetMouseInputEnabled(true)
    self.themeScroll:SetKeyboardInputEnabled(true)
    self.themeScroll.Paint = function() end
    themeComboScrollBar(self.themeScroll)
    self:BuildThemeButtons(self.themeScroll, "themeButtons", false)
end

function PANEL:BuildSelectionThemeSidebar()
    self.selectionThemeSidebar = self.selectionPage:Add("DPanel")
    self.selectionThemeSidebar:SetMouseInputEnabled(true)
    self.selectionThemeSidebar:SetKeyboardInputEnabled(true)
    self.selectionThemeSidebar.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 222), Color(accent.r, accent.g, accent.b, 55))
        draw.SimpleText("THEMES", "LiliaFont.22", 14, 12, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Pick a theme before you continue.", "LiliaFont.15", 14, 40, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 70)
        surface.DrawRect(14, 64, math.max(w - 28, 1), 1)
    end

    self.selectionThemeScroll = self.selectionThemeSidebar:Add("DScrollPanel")
    self.selectionThemeScroll:SetMouseInputEnabled(true)
    self.selectionThemeScroll:SetKeyboardInputEnabled(true)
    self.selectionThemeScroll.Paint = function() end
    themeComboScrollBar(self.selectionThemeScroll)
    self:BuildThemeButtons(self.selectionThemeScroll, "selectionThemeButtons", true)
end

function PANEL:BuildSelectionPage()
    self:BuildSelectionThemeSidebar()
    self.selectionTitle = self.selectionPage:Add("DPanel")
    self.selectionTitle.Paint = function(_, w, h)
        local accent = getThemeAccent()
        draw.SimpleText("SELECT SPECIES", "LiliaFont.30", 0, 0, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 165)
        surface.DrawRect(0, h - 1, w, 1)
    end

    self.speciesCards = self.selectionPage:Add("DPanel")
    self.speciesCards.Paint = function() end
    self.speciesInfo = self.selectionPage:Add("DPanel")
    self.speciesInfo.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 82))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 230)
        surface.DrawRect(0, 0, 4, h)
    end

    self.speciesNameLabel = self.speciesInfo:Add("DLabel")
    self.speciesNameLabel:SetFont("LiliaFont.30")
    self.speciesNameLabel:SetTextColor(getThemeTextColor(fallbackText))
    self.speciesNameLabel:SetContentAlignment(4)
    bindThemedLabel(self.speciesNameLabel, function() return getThemeTextColor(fallbackText) end)
    self.speciesDescriptionLabel = self.speciesInfo:Add("DLabel")
    self.speciesDescriptionLabel:SetFont("LiliaFont.18")
    self.speciesDescriptionLabel:SetTextColor(getThemeMutedColor())
    self.speciesDescriptionLabel:SetWrap(true)
    self.speciesDescriptionLabel:SetContentAlignment(4)
    bindThemedLabel(self.speciesDescriptionLabel, function() return getThemeMutedColor() end)
    self.originPanel = self.selectionPage:Add("DPanel")
    self.originPanel.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 220), Color(accent.r, accent.g, accent.b, 62))
        draw.SimpleText("SELECT ORIGIN", "LiliaFont.22", 16, 12, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 75)
        surface.DrawRect(16, 40, w - 32, 1)
    end

    self.originList = self.originPanel:Add("DHorizontalScroller")
    self.originList:SetOverlap(-2)
    self.originList.Paint = function() end
    self.originList.btnLeft.Paint = function(s, w, h)
        drawPanel(0, 0, w, h, 4, getThemeSurface(0.025, 230), getThemeMutedColor(s:IsHovered() and 120 or 45))
        draw.SimpleText("‹", "LiliaFont.30", w * 0.5, h * 0.5 - 2, getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.originList.btnRight.Paint = function(s, w, h)
        drawPanel(0, 0, w, h, 4, getThemeSurface(0.025, 230), getThemeMutedColor(s:IsHovered() and 120 or 45))
        draw.SimpleText("›", "LiliaFont.30", w * 0.5, h * 0.5 - 2, getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.originDetails = self.originPanel:Add("DPanel")
    self.originDetails.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 6, getThemeSurface(0.015, 246), Color(accent.r, accent.g, accent.b, 65))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 215)
        surface.DrawRect(0, 0, 3, h)
    end

    self.originNameLabel = self.originDetails:Add("DLabel")
    self.originNameLabel:SetFont("LiliaFont.22")
    self.originNameLabel:SetTextColor(getThemeTextColor(fallbackText))
    self.originNameLabel:SetWrap(true)
    self.originNameLabel:SetContentAlignment(4)
    bindThemedLabel(self.originNameLabel, function() return getThemeTextColor(fallbackText) end)
    self.originDescriptionLabel = self.originDetails:Add("DLabel")
    self.originDescriptionLabel:SetFont("LiliaFont.16")
    self.originDescriptionLabel:SetTextColor(getThemeMutedColor())
    self.originDescriptionLabel:SetWrap(true)
    self.originDescriptionLabel:SetContentAlignment(4)
    bindThemedLabel(self.originDescriptionLabel, function() return getThemeMutedColor() end)
    self.continueButton = makeButton(self.selectionPage, "CONTINUE")
    self.continueButton.DoClick = function() self:OpenCreation() end
    self:BuildSpeciesCards()
end

function PANEL:BuildCreationPage()
    self.creationHeader = self.creationPage:Add("DPanel")
    self.creationHeader.Paint = function(_, w, h)
        local accent = getThemeAccent()
        draw.SimpleText("CUSTOMIZE", "LiliaFont.30", 0, 0, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText((self.currentSpeciesName or "Species") .. "  /  " .. (self.currentOriginName or "Origin"), "LiliaFont.16", 0, 34, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 165)
        surface.DrawRect(0, h - 1, w, 1)
    end

    self:BuildThemeSidebar()
    self.tabNavigation = self.creationPage:Add("DPanel")
    self.tabNavigation:SetMouseInputEnabled(true)
    self.tabNavigation:SetKeyboardInputEnabled(true)
    self.tabNavigation.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 222), Color(accent.r, accent.g, accent.b, 55))
    end

    self.tabButtons = {}
    for index, definition in ipairs(tabDefinitions) do
        local tabIndex = index
        local button = self.tabNavigation:Add("DButton")
        button:SetText("")
        button._hover = 0
        button.Think = function(s)
            local target = s:IsHovered() and 1 or 0
            s._hover = Lerp(FrameTime() * 12, s._hover or 0, target)
        end

        button.Paint = function(s, w, h)
            local active = self.currentCreationTab == tabIndex
            local complete = self:IsTabComplete(tabIndex)
            local accent = getThemeAccent()
            local hover = s._hover or 0
            drawPanel(0, 0, w, h, 6, active and Color(accent.r, accent.g, accent.b, 30) or getThemeSurface(0.05, 225), Color(accent.r, accent.g, accent.b, active and 190 or 45 + hover * 75))
            if active then
                surface.SetDrawColor(accent.r, accent.g, accent.b, 230)
                surface.DrawRect(0, 0, 4, h)
            end

            draw.SimpleText(string.format("%02d", tabIndex), "LiliaFont.16", 14, 12, active and accent or getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(definition.name, "LiliaFont.18", 14, 34, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            if active then
                if complete then
                    local badgeWidth = 58
                    drawPanel(w - badgeWidth - 10, 9, badgeWidth, 22, 4, Color(accent.r, accent.g, accent.b, 30), Color(accent.r, accent.g, accent.b, 110))
                    draw.SimpleText("ACTIVE", "LiliaFont.15", w - badgeWidth * 0.5 - 10, 20, accent, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    local notReadyColor = getThemeNegativeColor()
                    local badgeWidth = 78
                    drawPanel(w - badgeWidth - 10, 9, badgeWidth, 22, 4, Color(notReadyColor.r, notReadyColor.g, notReadyColor.b, 20), Color(notReadyColor.r, notReadyColor.g, notReadyColor.b, 68))
                    draw.SimpleText("NOT READY", "LiliaFont.15", w - badgeWidth * 0.5 - 10, 20, notReadyColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            elseif complete then
                local readyColor = getThemeAccent()
                local badgeWidth = 54
                drawPanel(w - badgeWidth - 10, 9, badgeWidth, 22, 4, Color(readyColor.r, readyColor.g, readyColor.b, 25), Color(readyColor.r, readyColor.g, readyColor.b, 70))
                draw.SimpleText("READY", "LiliaFont.15", w - badgeWidth * 0.5 - 10, 20, readyColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        button:SetZPos(20)
        button.DoClick = function() self:RequestCreationTab(tabIndex) end
        self.tabButtons[index] = button
    end

    self.stage = self.creationPage:Add("DPanel")
    self.stage:SetMouseInputEnabled(true)
    self.stage:SetKeyboardInputEnabled(true)
    self.stage.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 230), Color(accent.r, accent.g, accent.b, 55))
    end

    self.tabPages = {}
    for index = 1, #tabDefinitions do
        local page = self.stage:Add("DPanel")
        local active = index == 1
        page:SetVisible(active)
        page:SetMouseInputEnabled(active)
        page:SetKeyboardInputEnabled(active)
        page.Paint = function() end
        self.tabPages[index] = page
    end

    self:BuildModelTab(self.tabPages[1])
    self:BuildAppearanceTab(self.tabPages[2])
    self:BuildInformationTab(self.tabPages[3])
    self:BuildAttributesTab(self.tabPages[4])
    self:BuildTraitsTab(self.tabPages[5])
    self:BuildLanguagesTab(self.tabPages[6])
    self:BuildKitTab(self.tabPages[7])
    self:BuildSummaryTab(self.tabPages[8])
    self.creationBackButton = makeButton(self.creationPage, "BACK", true)
    self.creationBackButton:SetZPos(50)
    self.creationBackButton.DoClick = function()
        if self.currentCreationTab > 1 then
            self:SetCreationTab(self.currentCreationTab - 1)
        else
            self:CloseCreation()
        end
    end

    self.creationNextButton = makeButton(self.creationPage, "NEXT")
    self.creationNextButton:SetZPos(50)
    self.creationNextButton.DoClick = function()
        if self.currentCreationTab < #tabDefinitions then
            self:RequestCreationTab(self.currentCreationTab + 1)
        else
            self:CreateCharacter()
        end
    end
end

function PANEL:BuildModelTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("MODEL & SEX")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Select the character's sex and presentation model.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    page.sexPanel = page:Add("DPanel")
    page.sexPanel:SetMouseInputEnabled(true)
    page.sexPanel:SetKeyboardInputEnabled(true)
    page.sexPanel.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 52))
        draw.SimpleText("SEX", "LiliaFont.16", 14, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    page.sexButtons = {}
    page.modelScroller = page:Add("DScrollPanel")
    page.modelScroller:SetMouseInputEnabled(true)
    page.modelScroller:SetKeyboardInputEnabled(true)
    page.modelScroller.Paint = function() end
    themeComboScrollBar(page.modelScroller)
end

function PANEL:BuildAppearanceTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("APPEARANCE")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Configure the selected model's height, skin, bodygroups, eye color, and hair color.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    page.appearanceScroll = page:Add("DScrollPanel")
    page.appearanceScroll:SetMouseInputEnabled(true)
    page.appearanceScroll:SetKeyboardInputEnabled(true)
    page.appearanceScroll.Paint = function() end
    themeComboScrollBar(page.appearanceScroll)
    page.appearanceCanvas = page.appearanceScroll:GetCanvas()
    self.skinWrap, self.skinCombo = makeCombo(page.appearanceCanvas, "SKIN")
    self.heightWrap, self.heightSlider = makeSlider(page.appearanceCanvas, "HEIGHT")
    self.heightWrap.formatter = formatHeight
    self.heightEntry = self.heightSlider
    self.heightSlider.OnValueChanged = function(_, value)
        if self.updatingHeightSlider then return end
        self:SetCharacterHeight(value)
    end

    page.colorsSection = page.appearanceCanvas:Add("DPanel")
    page.colorsSection:SetMouseInputEnabled(true)
    page.colorsSection:SetKeyboardInputEnabled(true)
    page.colorsSection.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
        draw.SimpleText("APPEARANCE", "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.eyeColorWrap, self.eyeColorCombo = makeCombo(page.colorsSection, "EYE COLOR")
    self.hairColorWrap, self.hairColorCombo = makeCombo(page.colorsSection, "HAIR COLOR")
    self.skinCombo.OnSelect = function(_, _, _, data)
        if self.populatingAppearance then return end
        local skin = tonumber(data)
        if skin == nil then return end
        self.selectedSkin = math.max(math.floor(skin), 0)
        self:ApplySelectedAppearance()
    end

    self.eyeColorCombo.OnSelect = function(_, _, value, data)
        if self.populatingAppearance then return end
        self.selectedEyeColor = tostring(data or value or "Unknown")
        self:ApplyModelDescriptionDefault(false)
    end

    self.hairColorCombo.OnSelect = function(_, _, value, data)
        if self.populatingAppearance then return end
        self.selectedHairColor = tostring(data or value or "Unknown")
        self:ApplyModelDescriptionDefault(false)
    end

    page.bodygroupsSection = page.appearanceCanvas:Add("DPanel")
    page.bodygroupsSection:SetMouseInputEnabled(true)
    page.bodygroupsSection:SetKeyboardInputEnabled(true)
    page.bodygroupsSection.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
        draw.SimpleText("BODYGROUPS", "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        if #(page.bodygroupControls or {}) == 0 then draw.SimpleText("No configurable bodygroups are available for the selected model.", "LiliaFont.16", 13, 36, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end
    end

    page.bodygroupControls = {}
    page.bodygroupCombos = {}
end

function PANEL:PopulateAppearanceControls()
    local page = self.tabPages and self.tabPages[2]
    if not IsValid(page) or not IsValid(self.skinCombo) or not IsValid(self.eyeColorCombo) or not IsValid(self.hairColorCombo) then return end
    self.populatingAppearance = true
    local eyeOptions = self:GetAppearanceOptions("eye")
    local hairOptions = self:GetAppearanceOptions("hair")
    if #eyeOptions == 0 then eyeOptions = {"Unknown"} end
    if #hairOptions == 0 then hairOptions = {"Unknown"} end
    local function normalizeSelection(options, selected)
        selected = string.Trim(tostring(selected or ""))
        for _, option in ipairs(options) do
            if string.lower(option) == string.lower(selected) then return option end
        end
        return options[1]
    end

    self.selectedEyeColor = normalizeSelection(eyeOptions, self.selectedEyeColor)
    self.selectedHairColor = normalizeSelection(hairOptions, self.selectedHairColor)
    self.eyeColorCombo:Clear()
    for _, option in ipairs(eyeOptions) do
        self.eyeColorCombo:AddChoice(option, option)
    end

    self.eyeColorCombo:SetValue(self.selectedEyeColor)
    self.hairColorCombo:Clear()
    for _, option in ipairs(hairOptions) do
        self.hairColorCombo:AddChoice(option, option)
    end

    self.hairColorCombo:SetValue(self.selectedHairColor)
    for _, control in ipairs(page.bodygroupControls or {}) do
        if IsValid(control) then control:Remove() end
    end

    page.bodygroupControls = {}
    page.bodygroupCombos = {}
    local model = self:GetSelectedModel()
    local queryEntity
    if model then
        local modelPath = normalizeModelPath(model.model)
        if modelPath ~= "" then
            queryEntity = ClientsideModel(modelPath, RENDERGROUP_OPAQUE)
            if IsValid(queryEntity) then queryEntity:SetNoDraw(true) end
        end
    end

    local skinCount = IsValid(queryEntity) and math.max(queryEntity:SkinCount(), 1) or 1
    self.selectedSkin = math.Clamp(math.floor(tonumber(self.selectedSkin) or 0), 0, skinCount - 1)
    self.skinCombo:Clear()
    for skinIndex = 0, skinCount - 1 do
        self.skinCombo:AddChoice("Skin " .. tostring(skinIndex), skinIndex)
    end

    self.skinCombo:SetValue("Skin " .. tostring(self.selectedSkin))
    if IsValid(queryEntity) then
        for _, group in ipairs(queryEntity:GetBodyGroups() or {}) do
            local groupID = tonumber(group.id)
            local count = math.max(math.floor(tonumber(group.num) or 0), 0)
            if groupID and count > 1 then
                local title = string.upper(tostring(group.name or "Bodygroup " .. tostring(groupID)))
                local wrap, combo = makeCombo(page.bodygroupsSection, title)
                local selected = math.Clamp(math.floor(tonumber(self.selectedBodygroups[groupID]) or 0), 0, count - 1)
                self.selectedBodygroups[groupID] = selected
                local selectedLabel = tostring(selected)
                for option = 0, count - 1 do
                    local optionLabel = group.submodels and group.submodels[option + 1] or nil
                    optionLabel = string.Trim(tostring(optionLabel or ""))
                    if optionLabel == "" then optionLabel = tostring(option) end
                    combo:AddChoice(optionLabel, option)
                    if option == selected then selectedLabel = optionLabel end
                end

                combo:SetValue(selectedLabel)
                combo.OnSelect = function(_, _, _, data)
                    if self.populatingAppearance then return end
                    self.selectedBodygroups[groupID] = math.Clamp(math.floor(tonumber(data) or 0), 0, count - 1)
                    self:ApplySelectedAppearance()
                end

                page.bodygroupControls[#page.bodygroupControls + 1] = wrap
                page.bodygroupCombos[#page.bodygroupCombos + 1] = combo
            end
        end

        queryEntity:Remove()
    end

    self.populatingAppearance = false
    page:InvalidateLayout(true)
    self:LayoutAppearanceTab(page)
end

function PANEL:BuildInformationTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("INFORMATION")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Complete all identity and biography fields.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    self.nameWrap, self.nameEntry = makeEntry(page, "CHARACTER NAME", false)
    self.nameEntry:SetPlaceholderText("Enter a character name")
    self.pronounsWrap, self.pronounsCombo = makeCombo(page, "PRONOUNS")
    self.birthMonthWrap, self.birthMonthCombo = makeCombo(page, "BIRTH MONTH")
    self.birthYearWrap, self.birthYearCombo = makeCombo(page, "BIRTH YEAR")
    self.generationWrap, self.generationCombo = makeCombo(page, "GENERATION")
    self.descWrap, self.descEntry = makeEntry(page, "DESCRIPTION", true)
    self.descEntry:SetPlaceholderText("Write a character description")
end

function PANEL:BuildAttributesTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("ATTRIBUTES")
    page.title.Think = function(s) s:SetTextColor(getThemeTextColor(fallbackText)) end
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor(170))
    page.subtitle:SetText("Distribute every point across the three attribute groups.")
    page.subtitle.Think = function(s) s:SetTextColor(getThemeMutedColor(170)) end
    self.attributeSummaryPanel = page:Add("DPanel")
    self.attributeSummaryPanel.Paint = function(_, w, h)
        local accent = getThemeAccent()
        local textColor = getThemeTextColor(fallbackText)
        local mutedColor = getThemeMutedColor(170)
        local negativeColor = getThemeNegativeColor()
        local groups = self.attributeGroups or module:GetAttributeGroups(self:GetSelectedSpecies(), self:GetSelectedOrigin())
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.05, 246), getThemeAccent(72))
        local columnWidth = w / math.max(#groups, 1)
        for index, group in ipairs(groups) do
            local remaining = self:GetAttributeGroupPointsRemaining(group)
            local x = columnWidth * (index - 0.5)
            local label = string.upper(tostring(group.pointsLabel or group.name or "Group " .. index))
            draw.SimpleText(label, "LiliaFont.15", x, 10, mutedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(tostring(remaining) .. " PTS LEFT", "LiliaFont.18", x, h - 11, remaining == 0 and accent or remaining > 0 and textColor or negativeColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            if index < #groups then
                surface.SetDrawColor(accent.r, accent.g, accent.b, 38)
                surface.DrawRect(math.floor(columnWidth * index), 10, 1, h - 20)
            end
        end
    end

    self.attributeHeaderPanel = self.attributeSummaryPanel
    self.attributePanel = page:Add("DPanel")
    self.attributePanel.Paint = function() end
    self.attributeGroupPanels = {}
    self.attributeRows = {}
    self.attributeButtons = {}
    self:BuildAttributeControls()
end

function PANEL:BuildTraitsTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("TRAITS")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Claim positive and negative traits within the available budget.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    self.traitPointsPanel = page:Add("DPanel")
    self.traitPointsPanel.Paint = function(_, w, h)
        local remaining = self:GetTraitPointsRemaining()
        local accent = remaining >= 0 and getThemeAccent() or getThemeNegativeColor()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 100))
        draw.SimpleText("TRAIT POINTS", "LiliaFont.15", 16, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(tostring(remaining), "LiliaFont.30", w - 16, h * 0.5, remaining >= 0 and getThemeTextColor(fallbackText) or getThemeNegativeColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 210)
        surface.DrawRect(0, 0, 4, h)
    end

    local function buildSection(topTitle, bottomTitle, tone)
        local panel = page:Add("DPanel")
        panel.Paint = function(_, w, h)
            drawPanel(0, 0, w, h, 8, getThemeSurface(0.04, 246), Color(tone.r, tone.g, tone.b, 92))
            draw.SimpleText(topTitle, "LiliaFont.22", w * 0.5, 10, getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(bottomTitle, "LiliaFont.18", w * 0.5, 36, getThemeMutedColor(185), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            surface.SetDrawColor(tone.r, tone.g, tone.b, 80)
            surface.DrawRect(10, 62, math.max(w - 20, 1), 1)
        end

        local scroll = panel:Add("DScrollPanel")
        scroll:SetMouseInputEnabled(true)
        scroll:SetKeyboardInputEnabled(true)
        scroll.Paint = function() end
        local bar = scroll:GetVBar()
        bar:SetWide(4)
        bar.Paint = function() end
        bar.btnUp.Paint = function() end
        bar.btnDown.Paint = function() end
        bar.btnGrip.Paint = function(_, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(tone.r, tone.g, tone.b, 150)) end
        panel.PerformLayout = function(_, w, h)
            scroll:SetPos(10, 72)
            scroll:SetSize(math.max(w - 20, 1), math.max(h - 82, 1))
        end
        return panel, scroll
    end

    local positiveTone = getThemeAccent()
    local negativeTone = getThemeNegativeColor()
    self.traitPositivePanel, self.traitPositiveScroll = buildSection("POSITIVE", "AVAILABLE", positiveTone)
    self.traitNegativePanel, self.traitNegativeScroll = buildSection("NEGATIVE", "AVAILABLE", negativeTone)
    self.traitClaimedPositivePanel, self.traitClaimedPositiveScroll = buildSection("POSITIVE", "CLAIMED", positiveTone)
    self.traitClaimedNegativePanel, self.traitClaimedNegativeScroll = buildSection("NEGATIVE", "CLAIMED", negativeTone)
    self.traitScroll = self.traitPositiveScroll
    self.traitScrolls = {self.traitPositiveScroll, self.traitNegativeScroll, self.traitClaimedPositiveScroll, self.traitClaimedNegativeScroll}
    self.traitButtons = {}
end

function PANEL:BuildLanguagesTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("LANGUAGES")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Innate languages cost nothing. Spend every available token on additional languages.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    self.languageStatusPanel = page:Add("DPanel")
    self.languageStatusPanel.Paint = function(_, w, h)
        local accent = getThemeAccent()
        local innateNames = self:GetInnateLanguageNames()
        local budget = self:GetLanguageTokenBudget()
        local remaining = self:GetLanguageTokensRemaining()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 72))
        draw.SimpleText("INNATE", "LiliaFont.15", 16, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        drawWrappedText(#innateNames > 0 and table.concat(innateNames, ", ") or "None", "LiliaFont.18", 16, 32, math.max(w * 0.62 - 28, 1), 18, getThemeTextColor(fallbackText), 2, TEXT_ALIGN_LEFT)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 38)
        surface.DrawRect(math.floor(w * 0.66), 10, 1, h - 20)
        draw.SimpleText("LANGUAGE TOKENS", "LiliaFont.15", w - 16, 10, getThemeMutedColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText(string.format("%d / %d LEFT", remaining, budget), "LiliaFont.22", w - 16, h - 14, remaining == 0 and accent or remaining > 0 and getThemeTextColor(fallbackText) or getThemeNegativeColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    end

    self.languageScroll = page:Add("DScrollPanel")
    self.languageScroll:SetMouseInputEnabled(true)
    self.languageScroll:SetKeyboardInputEnabled(true)
    self.languageScroll.Paint = function() end
    local bar = self.languageScroll:GetVBar()
    bar:SetWide(5)
    bar.Paint = function() end
    bar.btnUp.Paint = function() end
    bar.btnDown.Paint = function() end
    bar.btnGrip.Paint = function(_, w, h)
        local accent = getThemeAccent()
        draw.RoundedBox(2, 0, 0, w, h, Color(accent.r, accent.g, accent.b, 150))
    end

    self.languageButtons = {}
end

function PANEL:BuildKitTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("STARTING KIT")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Choose the required items and an outfit when available.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    self.kitStatusPanel = page:Add("DPanel")
    self.kitStatusPanel.Paint = function(_, w, h)
        local accent = getThemeAccent()
        local kit = self:GetCurrentKit()
        local required = kit and tonumber(kit.pick) or 0
        local selected = tableCount(self.selectedKitItems)
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 60))
        draw.SimpleText("ITEM SELECTION", "LiliaFont.16", 14, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(string.format("%d / %d", selected, required), "LiliaFont.22", w - 14, h * 0.5, selected == required and accent or getThemeTextColor(fallbackText), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    self.kitScroll = page:Add("DScrollPanel")
    self.kitScroll:SetMouseInputEnabled(true)
    self.kitScroll:SetKeyboardInputEnabled(true)
    self.kitScroll.Paint = function() end
    self.kitButtons = {}
    self.outfitPanel = page:Add("DPanel")
    self.outfitPanel:SetMouseInputEnabled(true)
    self.outfitPanel:SetKeyboardInputEnabled(true)
    self.outfitPanel.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 52))
        draw.SimpleText("STARTING OUTFIT", "LiliaFont.16", 14, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.outfitCombo = self.outfitPanel:Add("DComboBox")
    self.outfitCombo:SetMouseInputEnabled(true)
    self.outfitCombo:SetKeyboardInputEnabled(true)
    self.outfitCombo:SetFont("LiliaFont.18")
    self.outfitCombo:SetTextColor(getThemeTextColor(fallbackText))
    self.outfitCombo:SetSortItems(false)
    self.outfitCombo.Think = function(s) s:SetTextColor(getThemeTextColor(fallbackText)) end
    self.outfitCombo.OpenMenu = function(s) openComboMenu(s) end
    self.outfitCombo.CloseMenu = function(s)
        if IsValid(s.Menu) then s.Menu:Remove() end
        s.Menu = nil
    end

    self.outfitCombo.Paint = function(s, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 5, getThemeSurface(0.025, 220), Color(accent.r, accent.g, accent.b, s:IsHovered() and 110 or 48))
    end

    self.outfitCombo.OnSelect = function(_, _, _, data) self.selectedOutfitID = data end
end

function PANEL:BuildSummaryTab(page)
    page.title = page:Add("DLabel")
    page.title:SetFont("LiliaFont.30")
    page.title:SetTextColor(getThemeTextColor(fallbackText))
    page.title:SetText("SUMMARY & FINISH")
    bindThemedLabel(page.title, function() return getThemeTextColor(fallbackText) end)
    page.subtitle = page:Add("DLabel")
    page.subtitle:SetFont("LiliaFont.16")
    page.subtitle:SetTextColor(getThemeMutedColor())
    page.subtitle:SetText("Review every selection before creating the character.")
    bindThemedLabel(page.subtitle, function() return getThemeMutedColor() end)
    self.summaryScroll = page:Add("DScrollPanel")
    self.summaryScroll:SetMouseInputEnabled(true)
    self.summaryScroll:SetKeyboardInputEnabled(true)
    self.summaryScroll.Paint = function() end
    local canvas = self.summaryScroll:GetCanvas()
    self.summaryCanvas = canvas:Add("DPanel")
    self.summaryCanvas:SetMouseInputEnabled(false)
    self.summaryCanvas.Paint = function(_, w, h) self:PaintSummary(w, h) end
end

function PANEL:GetSummaryDescriptionHeight(width)
    local description = self.summaryData and self.summaryData.description or ""
    if description == "" then description = "No description provided." end
    local lineHeight = 16
    local lines = getWrappedTextLines(description, "LiliaFont.16", math.max((tonumber(width) or 0) - 28, 1))
    return 48 + math.min(math.max(#lines, 1), 3) * lineHeight + 10
end

function PANEL:GetSummaryAttributesHeight()
    local maximumRows = 1
    local groups = self.summaryData and self.summaryData.attributes or {}
    for _, group in ipairs(groups) do
        maximumRows = math.max(maximumRows, #(group.attributes or {}))
    end
    return 104 + maximumRows * 20
end

function PANEL:GetSummaryTopHeight()
    return 154
end

function PANEL:GetSummaryCanvasHeight(viewportHeight, canvasWidth)
    local gap = (tonumber(canvasWidth) or 0) >= 600 and 10 or 8
    local contentHeight = self:GetSummaryTopHeight() + self:GetSummaryDescriptionHeight(canvasWidth) + self:GetSummaryAttributesHeight() + 86 + 44 + gap * 4
    return math.max(math.floor(tonumber(viewportHeight) or 0), contentHeight)
end

function PANEL:DrawSummaryCard(x, y, w, h, title)
    local accent = getThemeAccent()
    local textColor = getThemeTextColor(fallbackText)
    drawPanel(x, y, w, h, 6, getThemeSurface(0.015, 246), getThemeAccent(74))
    draw.SimpleText(title, "LiliaFont.18", x + 14, y + 10, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    surface.SetDrawColor(accent.r, accent.g, accent.b, 138)
    surface.DrawRect(x + 14, y + 38, math.max(w - 28, 1), 1)
end

function PANEL:DrawSummaryRows(rows, x, y, w, rowHeight)
    local textColor = getThemeTextColor(fallbackText)
    local mutedColor = getThemeMutedColor(170)
    local valueX = x + math.floor(w * 0.43)
    local valueWidth = math.max(x + w - valueX - 14, 1)
    for index, row in ipairs(rows or {}) do
        local rowY = y + (index - 1) * rowHeight
        draw.SimpleText(fitText(row.label, "LiliaFont.15", math.max(valueX - x - 20, 1)), "LiliaFont.15", x + 14, rowY, mutedColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(fitText(row.value, "LiliaFont.16", valueWidth), "LiliaFont.16", valueX, rowY, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

function PANEL:DrawSummaryTags(items, x, y, w, h, kind)
    local accent = getThemeAccent()
    local textColor = getThemeTextColor(fallbackText)
    local mutedColor = getThemeMutedColor(170)
    local cursorX = x + 14
    local cursorY = y + 48
    local right = x + w - 14
    local bottom = y + h - 10
    local count = #items
    if count == 0 then
        draw.SimpleText(kind == "kit" and "No items selected" or "None selected", "LiliaFont.15", cursorX, cursorY + 2, mutedColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        return
    end

    for index, item in ipairs(items) do
        local name = istable(item) and tostring(item.name or item.id or "") or tostring(item)
        surface.SetFont("LiliaFont.15")
        local textWidth = surface.GetTextSize(name)
        local chipWidth = math.Clamp(textWidth + 20, 56, math.max(w - 28, 56))
        if cursorX + chipWidth > right then
            cursorX = x + 14
            cursorY = cursorY + 28
        end

        if cursorY + 24 > bottom then
            local remaining = count - index + 1
            draw.SimpleText("+" .. tostring(remaining), "LiliaFont.15", cursorX, cursorY, mutedColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            break
        end

        drawPanel(cursorX, cursorY, chipWidth, 24, 4, Color(accent.r, accent.g, accent.b, 28), Color(accent.r, accent.g, accent.b, 84))
        draw.SimpleText(fitText(name, "LiliaFont.15", chipWidth - 16), "LiliaFont.15", cursorX + 10, cursorY + 4, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        cursorX = cursorX + chipWidth + 7
    end
end

function PANEL:PaintSummary(w, h)
    local data = self.summaryData or {}
    local accent = getThemeAccent()
    local textColor = getThemeTextColor(fallbackText)
    local mutedColor = getThemeMutedColor(170)
    local gap = w >= 600 and 10 or 8
    local topHeight = self:GetSummaryTopHeight()
    local descriptionHeight = self:GetSummaryDescriptionHeight(w)
    local attributesHeight = self:GetSummaryAttributesHeight()
    local tagsHeight = 86
    local outfitHeight = 44
    local identityWidth = math.floor((w - gap) * 0.6)
    local appearanceX = identityWidth + gap
    local appearanceWidth = w - appearanceX
    self:DrawSummaryCard(0, 0, identityWidth, topHeight, "IDENTITY")
    self:DrawSummaryRows(data.identity or {}, 0, 49, identityWidth, 19)
    self:DrawSummaryCard(appearanceX, 0, appearanceWidth, topHeight, "APPEARANCE")
    self:DrawSummaryRows(data.appearance or {}, appearanceX, 49, appearanceWidth, 21)
    local descriptionY = topHeight + gap
    self:DrawSummaryCard(0, descriptionY, w, descriptionHeight, "DESCRIPTION")
    drawWrappedText(data.description ~= "" and data.description or "No description provided.", "LiliaFont.16", 14, descriptionY + 47, w - 28, 16, textColor, 3)
    local attributesY = descriptionY + descriptionHeight + gap
    self:DrawSummaryCard(0, attributesY, w, attributesHeight, "ATTRIBUTES")
    local groups = data.attributes or {}
    local groupCount = math.max(#groups, 1)
    local innerGap = 8
    local innerX = 12
    local innerY = attributesY + 48
    local innerWidth = math.max(w - 24, 1)
    local groupWidth = (innerWidth - innerGap * math.max(groupCount - 1, 0)) / groupCount
    local groupHeight = math.max(attributesHeight - 60, 1)
    for groupIndex, group in ipairs(groups) do
        local groupX = innerX + (groupIndex - 1) * (groupWidth + innerGap)
        local nextX = groupIndex == groupCount and w - 12 or innerX + groupIndex * (groupWidth + innerGap) - innerGap
        local actualWidth = math.max(nextX - groupX, 1)
        drawPanel(groupX, innerY, actualWidth, groupHeight, 5, getThemeSurface(0.05, 218), getThemeAccent(46))
        draw.SimpleText(string.upper(tostring(group.name or group.id or "GROUP")), "LiliaFont.16", groupX + actualWidth * 0.5, innerY + 9, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 76)
        surface.DrawRect(groupX + 10, innerY + 32, math.max(actualWidth - 20, 1), 1)
        local rowHeight = 20
        for attributeIndex, attribute in ipairs(group.attributes or {}) do
            local rowY = innerY + 38 + (attributeIndex - 1) * rowHeight
            local maximum = math.Clamp(math.floor(tonumber(attribute.maximum) or 5), 1, 5)
            local value = math.Clamp(math.floor(tonumber(attribute.value) or 1), 0, maximum)
            local dotSize = w >= 700 and 13 or 11
            local dotGap = 3
            local dotsWidth = maximum * dotSize + math.max(maximum - 1, 0) * dotGap
            local dotsX = groupX + actualWidth - dotsWidth - 10
            local dotY = rowY + math.floor((rowHeight - dotSize) * 0.5)
            local labelWidth = math.max(dotsX - groupX - 20, 1)
            local outlineColor = getThemeMutedColor(138)
            draw.SimpleText(fitText(attribute.name or attribute.id or "Attribute", "LiliaFont.15", labelWidth), "LiliaFont.15", groupX + 10, rowY + 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            for dotIndex = 1, maximum do
                local dotX = dotsX + (dotIndex - 1) * (dotSize + dotGap)
                local selected = dotIndex <= value
                if selected then draw.RoundedBox(2, dotX + 1, dotY + 1, dotSize - 2, dotSize - 2, Color(accent.r, accent.g, accent.b, 205)) end
                surface.SetDrawColor(selected and Color(accent.r, accent.g, accent.b, 238) or outlineColor)
                surface.DrawOutlinedRect(dotX, dotY, dotSize, dotSize, 1)
            end
        end
    end

    local tagsY = attributesY + attributesHeight + gap
    local tagWidth = math.floor((w - gap * 2) / 3)
    local languageX = tagWidth + gap
    local kitX = languageX + tagWidth + gap
    self:DrawSummaryCard(0, tagsY, tagWidth, tagsHeight, "TRAITS")
    self:DrawSummaryTags(data.traits or {}, 0, tagsY, tagWidth, tagsHeight, "traits")
    self:DrawSummaryCard(languageX, tagsY, tagWidth, tagsHeight, "LANGUAGES")
    self:DrawSummaryTags(data.languages or {}, languageX, tagsY, tagWidth, tagsHeight, "languages")
    self:DrawSummaryCard(kitX, tagsY, w - kitX, tagsHeight, "STARTING KIT")
    self:DrawSummaryTags(data.kit or {}, kitX, tagsY, w - kitX, tagsHeight, "kit")
    local outfitY = tagsY + tagsHeight + gap
    drawPanel(0, outfitY, w, outfitHeight, 6, getThemeSurface(0.015, 246), getThemeAccent(74))
    draw.SimpleText("OUTFIT", "LiliaFont.18", 14, outfitY + 12, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(fitText(data.outfit or "Not required", "LiliaFont.16", math.max(w - 110, 1)), "LiliaFont.16", 92, outfitY + 13, mutedColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

function PANEL:GetSelectedSpecies()
    return self.species[self.selectedSpeciesIndex]
end

function PANEL:GetSelectedOrigin()
    local species = self:GetSelectedSpecies()
    local origins = module:GetSpeciesOrigins(species)
    return origins[self.selectedOriginIndex]
end

function PANEL:GetSelectedModel()
    local models = self:GetFilteredModels()
    return models[self.selectedModelIndex]
end

function PANEL:GetSelectedModelName()
    local model = self:GetSelectedModel()
    if not model then return "No model selected" end
    if isstring(model.name) and model.name ~= "" then return model.name end
    local path = normalizeModelPath(model.model)
    local name = path:match("([^/]+)%.mdl$") or path
    return string.upper(name:gsub("_", " "))
end

function PANEL:GetAppearanceOptions(kind)
    local species = self:GetSelectedSpecies()
    local profile = species and species.profile or {}
    local configured = kind == "eye" and profile.eyeColors or profile.hairColors
    local fallback = kind == "eye" and module.EyeColors or module.HairColors
    local options = {}
    local seen = {}
    for _, value in ipairs(istable(configured) and configured or fallback or {}) do
        local label = string.Trim(tostring(value or ""))
        local normalized = string.lower(label)
        if label ~= "" and not seen[normalized] then
            seen[normalized] = true
            options[#options + 1] = label
        end
    end
    return options
end

function PANEL:GetModelEyeColor()
    local value = string.Trim(tostring(self.selectedEyeColor or ""))
    if value ~= "" then return value end
    local options = self:GetAppearanceOptions("eye")
    return options[1] or "Unknown"
end

function PANEL:GetModelHairColor()
    local value = string.Trim(tostring(self.selectedHairColor or ""))
    if value ~= "" then return value end
    local options = self:GetAppearanceOptions("hair")
    return options[1] or "Unknown"
end

function PANEL:GetModelSkin()
    return tostring(math.max(math.floor(tonumber(self.selectedSkin) or 0), 0))
end

function PANEL:GetModelBodygroupSummary()
    local entries = {}
    for key, value in pairs(self.selectedBodygroups or {}) do
        local index = tonumber(key)
        local selected = math.max(math.floor(tonumber(value) or 0), 0)
        if index and selected > 0 then
            entries[#entries + 1] = {
                index = index,
                value = selected
            }
        end
    end

    table.sort(entries, function(a, b) return a.index < b.index end)
    if #entries == 0 then return "Default" end
    local values = {}
    for _, entry in ipairs(entries) do
        values[#values + 1] = tostring(entry.index) .. ":" .. tostring(entry.value)
    end
    return table.concat(values, ", ")
end

function PANEL:GetModelHeight()
    local species = self:GetSelectedSpecies()
    return math.floor(tonumber(self.selectedHeight) or tonumber(species and species.profile.defaultHeight) or 69)
end

function PANEL:GetCharacterTypeLabel()
    local species = self:GetSelectedSpecies()
    local profile = species and species.profile or {}
    local label = string.Trim(tostring(profile.characterName or profile.name or species and species.id or "Character"))
    if label:sub(-1):lower() == "s" then label = label:sub(1, -2) end
    local sexes = module:GetSpeciesSexes(species)
    for _, sex in ipairs(sexes) do
        if sex.id == self.selectedSexID and sex.id ~= "na" and sex.id ~= "any" then
            label = label .. " " .. tostring(sex.name or sex.id)
            break
        end
    end
    return label ~= "" and label or "Character"
end

function PANEL:GetModelDescription()
    local eyeColor = string.lower(self:GetModelEyeColor())
    local hairColor = string.lower(self:GetModelHairColor())
    local hairText = hairColor == "none" and "no hair" or hairColor .. " hair"
    return string.format("A %s with %s eyes and %s standing %s tall.", self:GetCharacterTypeLabel(), eyeColor, hairText, formatHeight(self:GetModelHeight()))
end

function PANEL:ApplyModelDescriptionDefault(force)
    if not IsValid(self.descEntry) then return end
    local description = self:GetModelDescription()
    local current = string.Trim(self.descEntry:GetValue() or "")
    if force or current == "" or current == self.autoModelDescription then
        self.descEntry:SetValue(description)
        self.autoModelDescription = description
    end
end

function PANEL:ResetAppearanceSelection(resetColors)
    local species = self:GetSelectedSpecies()
    local profile = species and species.profile or {}
    if resetColors then
        local eyeOptions = self:GetAppearanceOptions("eye")
        local hairOptions = self:GetAppearanceOptions("hair")
        local eyeDefault = string.Trim(tostring(profile.defaultEyeColor or ""))
        local hairDefault = string.Trim(tostring(profile.defaultHairColor or ""))
        self.selectedEyeColor = eyeOptions[1] or "Unknown"
        self.selectedHairColor = hairOptions[1] or "Unknown"
        for _, option in ipairs(eyeOptions) do
            if string.lower(option) == string.lower(eyeDefault) then
                self.selectedEyeColor = option
                break
            end
        end

        for _, option in ipairs(hairOptions) do
            if string.lower(option) == string.lower(hairDefault) then
                self.selectedHairColor = option
                break
            end
        end
    end

    self.selectedSkin = 0
    self.selectedBodygroups = {}
    if IsValid(self.appearanceWindow) then self.appearanceWindow:Remove() end
end

function PANEL:OpenAppearanceMenu(mode)
    mode = mode == "skin" and "skin" or mode == "bodygroups" and "bodygroups" or "appearance"
    if IsValid(self.appearanceWindow) then
        if self.appearanceWindowMode == mode then
            self.appearanceWindow:MoveToFront()
            return
        end

        self.appearanceWindow:Remove()
    end

    local model = self:GetSelectedModel()
    if not model then return end
    local labels = {
        appearance = {
            title = "APPEARANCE",
            subtitle = "Select the character's eye color and hair color."
        },
        skin = {
            title = "SKIN",
            subtitle = "Select the model skin used by the character."
        },
        bodygroups = {
            title = "BODYGROUPS",
            subtitle = "Configure the model's available bodygroups."
        }
    }

    local labelData = labels[mode] or labels.appearance
    local frame = vgui.Create("DFrame", self.inputWindow)
    self.appearanceWindow = frame
    self.appearanceWindowMode = mode
    local targetHeight = mode == "appearance" and 230 or mode == "skin" and 360 or 620
    frame:SetSize(math.min(650, ScrW() - 80), math.min(targetHeight, ScrH() - 80))
    frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:SetSizable(false)
    frame:SetDeleteOnClose(true)
    frame:SetPaintShadow(false)
    frame:SetZPos(32767)
    frame.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 9, getThemeSurface(0.025, 252), Color(accent.r, accent.g, accent.b, 125))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 190)
        surface.DrawRect(0, 0, w, 2)
        draw.SimpleText(labelData.title, "LiliaFont.30", 18, 14, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(labelData.subtitle, "LiliaFont.16", 18, 47, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    frame.OnRemove = function()
        if self.appearanceWindow == frame then
            self.appearanceWindow = nil
            self.appearanceWindowMode = nil
        end

        if IsValid(self.inputWindow) then
            self.inputWindow:MakePopup()
            self.inputWindow:MoveToFront()
            self.inputWindow:RequestFocus()
        end
    end

    frame.OnKeyCodePressed = function(_, key) if key == KEY_ESCAPE then frame:Close() end end
    local closeButton = frame:Add("DButton")
    closeButton:SetText("")
    closeButton.Paint = function(s, w, h)
        drawPanel(0, 0, w, h, 5, s:IsHovered() and getThemeNegativeColor(38) or getThemeSurface(0.05, 235), getThemeNegativeColor(s:IsHovered() and 150 or 70))
        draw.SimpleText("×", "LiliaFont.22", w * 0.5, h * 0.5 - 1, getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    closeButton.DoClick = function() frame:Close() end
    local scroll = frame:Add("DScrollPanel")
    scroll.Paint = function() end
    themeComboScrollBar(scroll)
    local canvas = scroll:GetCanvas()
    local eyeWrap
    local hairWrap
    local skinPanel
    local skinHeight = 0
    local bodygroupPanels = {}
    local bodygroupsEmpty = false
    if mode == "appearance" then
        local eyeCombo
        eyeWrap, eyeCombo = makeCombo(canvas, "EYE COLOR")
        local eyeOptions = self:GetAppearanceOptions("eye")
        for _, value in ipairs(eyeOptions) do
            eyeCombo:AddChoice(value)
        end

        for index, value in ipairs(eyeOptions) do
            if value == self:GetModelEyeColor() then
                eyeCombo:ChooseOption(value, index)
                break
            end
        end

        eyeCombo.OnSelect = function(_, _, value)
            self.selectedEyeColor = tostring(value)
            self:ApplyModelDescriptionDefault(false)
        end

        local hairCombo
        hairWrap, hairCombo = makeCombo(canvas, "HAIR COLOR")
        local hairOptions = self:GetAppearanceOptions("hair")
        for _, value in ipairs(hairOptions) do
            hairCombo:AddChoice(value)
        end

        for index, value in ipairs(hairOptions) do
            if value == self:GetModelHairColor() then
                hairCombo:ChooseOption(value, index)
                break
            end
        end

        hairCombo.OnSelect = function(_, _, value)
            self.selectedHairColor = tostring(value)
            self:ApplyModelDescriptionDefault(false)
        end
    else
        local queryEntity = self.worldEntity
        local temporaryEntity = false
        if not IsValid(queryEntity) then
            queryEntity = ClientsideModel(normalizeModelPath(model.model), RENDERGROUP_OPAQUE)
            temporaryEntity = IsValid(queryEntity)
            if temporaryEntity then queryEntity:SetNoDraw(true) end
        end

        if mode == "skin" then
            local skinCount = IsValid(queryEntity) and math.max(queryEntity:SkinCount(), 1) or 1
            self.selectedSkin = math.Clamp(math.floor(tonumber(self.selectedSkin) or 0), 0, skinCount - 1)
            skinPanel = canvas:Add("DPanel")
            local skinColumns = 5
            local skinRows = math.max(math.ceil(skinCount / skinColumns), 1)
            skinHeight = 48 + skinRows * 40
            skinPanel.Paint = function(_, w, h)
                local accent = getThemeAccent()
                drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
                draw.SimpleText("AVAILABLE SKINS", "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end

            local skinButtons = {}
            for skinIndex = 0, skinCount - 1 do
                local index = skinIndex
                local button = skinPanel:Add("DButton")
                button:SetText("")
                button.Paint = function(s, w, h)
                    local accent = getThemeAccent()
                    local active = self.selectedSkin == index
                    drawPanel(0, 0, w, h, 5, active and Color(accent.r, accent.g, accent.b, 32) or getThemeSurface(0.025, 220), Color(accent.r, accent.g, accent.b, active and 190 or s:IsHovered() and 105 or 45))
                    draw.SimpleText(tostring(index), "LiliaFont.18", w * 0.5, h * 0.5, active and getThemeAccent() or getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                button.DoClick = function()
                    self.selectedSkin = index
                    self:ApplySelectedAppearance()
                end

                skinButtons[#skinButtons + 1] = button
            end

            skinPanel.PerformLayout = function(_, w)
                local gap = 8
                local buttonWidth = math.floor((w - 24 - gap * (skinColumns - 1)) / skinColumns)
                for index, button in ipairs(skinButtons) do
                    local column = (index - 1) % skinColumns
                    local row = math.floor((index - 1) / skinColumns)
                    button:SetPos(12 + column * (buttonWidth + gap), 38 + row * 40)
                    button:SetSize(buttonWidth, 32)
                end
            end
        else
            local bodygroupData = {}
            if IsValid(queryEntity) then
                for _, group in ipairs(queryEntity:GetBodyGroups() or {}) do
                    local count = math.max(math.floor(tonumber(group.num) or 0), 0)
                    if count > 1 then
                        local submodels = {}
                        for index, value in ipairs(group.submodels or {}) do
                            submodels[index] = tostring(value or "")
                        end

                        bodygroupData[#bodygroupData + 1] = {
                            id = tonumber(group.id) or 0,
                            name = tostring(group.name or "Bodygroup " .. tostring(group.id or 0)),
                            count = count,
                            submodels = submodels
                        }
                    end
                end
            end

            if #bodygroupData == 0 then
                bodygroupsEmpty = true
                local empty = canvas:Add("DPanel")
                empty.Paint = function(_, w, h)
                    local accent = getThemeAccent()
                    drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 50))
                    draw.SimpleText("BODYGROUPS", "LiliaFont.16", 13, 10, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("No configurable bodygroups.", "LiliaFont.16", 13, 34, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end

                bodygroupPanels[#bodygroupPanels + 1] = empty
            else
                for _, group in ipairs(bodygroupData) do
                    local groupData = group
                    local panel, combo = makeCombo(canvas, string.upper(groupData.name))
                    self.selectedBodygroups[groupData.id] = math.Clamp(math.floor(tonumber(self.selectedBodygroups[groupData.id]) or 0), 0, groupData.count - 1)
                    for option = 0, groupData.count - 1 do
                        local optionLabel = groupData.submodels[option + 1]
                        if not optionLabel or optionLabel == "" then optionLabel = tostring(option) end
                        combo:AddChoice(optionLabel, option)
                    end

                    combo:ChooseOptionID(self.selectedBodygroups[groupData.id] + 1)
                    combo.OnSelect = function(_, _, _, data)
                        self.selectedBodygroups[groupData.id] = math.Clamp(math.floor(tonumber(data) or 0), 0, groupData.count - 1)
                        self:ApplySelectedAppearance()
                    end

                    bodygroupPanels[#bodygroupPanels + 1] = panel
                end
            end
        end

        if temporaryEntity then queryEntity:Remove() end
    end

    canvas.PerformLayout = function(_, w)
        if mode == "appearance" then
            local gap = 10
            local half = math.floor((w - gap) * 0.5)
            eyeWrap:SetPos(0, 0)
            eyeWrap:SetSize(half, 78)
            hairWrap:SetPos(half + gap, 0)
            hairWrap:SetSize(w - half - gap, 78)
            canvas:SetTall(78)
        elseif mode == "skin" then
            skinPanel:SetPos(0, 0)
            skinPanel:SetSize(w, skinHeight)
            canvas:SetTall(skinHeight)
        else
            local gap = 10
            local y = 0
            for _, panel in ipairs(bodygroupPanels) do
                panel:SetPos(0, y)
                panel:SetSize(w, bodygroupsEmpty and 64 or 78)
                y = y + panel:GetTall() + gap
            end

            canvas:SetTall(math.max(y - gap, 1))
        end
    end

    frame.PerformLayout = function(_, w, h)
        closeButton:SetPos(w - 44, 12)
        closeButton:SetSize(30, 30)
        scroll:SetPos(18, 78)
        scroll:SetSize(w - 36, h - 96)
        canvas:InvalidateLayout(true)
    end

    frame:MakePopup()
    frame:MoveToFront()
    frame:RequestFocus()
    frame:InvalidateLayout(true)
end

function PANEL:GetModelSex(model)
    local configured = tostring(model and model.sex or ""):lower()
    if configured ~= "" then return configured end
    local path = normalizeModelPath(model and model.model):lower()
    if path:find("female", 1, true) then return "female" end
    if path:find("male", 1, true) then return "male" end
    return "any"
end

function PANEL:GetDefaultPronounsForSelection()
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    local originDefault = origin and origin.defaultPronouns or nil
    if isstring(originDefault) and originDefault ~= "" then return originDefault end
    local profileDefault = species and species.profile and species.profile.defaultPronouns or nil
    if isstring(profileDefault) and profileDefault ~= "" then return profileDefault end
    if tostring(origin and origin.id or ""):lower() == "zombie" then return "It/Its" end
    if tostring(species and species.id or ""):lower() == "transhumans" then return "They/Them" end
    local modelSex = self:GetModelSex(self:GetSelectedModel())
    if modelSex == "male" then return "He/Him" end
    if modelSex == "female" then return "She/Her" end
    if self.selectedSexID == "male" then return "He/Him" end
    if self.selectedSexID == "female" then return "She/Her" end
end

function PANEL:ApplyDefaultPronounsForSelection()
    local pronouns = self:GetDefaultPronounsForSelection()
    if not pronouns then return end
    self.selectedPronouns = pronouns
    if IsValid(self.pronounsCombo) then self.pronounsCombo:SetValue(pronouns) end
end

function PANEL:GetFilteredModels()
    local species = self:GetSelectedSpecies()
    if not species then return {} end
    local filtered = {}
    for _, model in ipairs(species.models or {}) do
        local modelSex = self:GetModelSex(model)
        if not self.selectedSexID or self.selectedSexID == "na" or modelSex == "any" or modelSex == self.selectedSexID then filtered[#filtered + 1] = model end
    end

    if #filtered == 0 then return species.models or {} end
    return filtered
end

function PANEL:GetSelectedCreationModel()
    local species = self:GetSelectedSpecies()
    local preview = self:GetSelectedModel()
    if not species then return nil end
    for _, model in ipairs(species.creationModels or {}) do
        if preview and normalizeModelPath(model.model) == normalizeModelPath(preview.model) then return model end
    end

    for _, model in ipairs(species.creationModels or {}) do
        local modelSex = tostring(model.sex or "any"):lower()
        if not self.selectedSexID or modelSex == "any" or modelSex == self.selectedSexID then return model end
    end
    return preview
end

function PANEL:GetPreviewEntity()
    return self.worldEntity
end

function PANEL:GetCurrentKit()
    return module:GetStartingKit(self:GetSelectedSpecies(), self:GetSelectedOrigin()) or {
        pick = 0,
        items = {}
    }
end

function PANEL:GetCurrentOutfits()
    return module:GetStartingOutfits(self:GetSelectedSpecies(), self:GetSelectedOrigin()) or {}
end

function PANEL:BuildSpeciesCards()
    self.speciesButtons = {}
    for index, species in ipairs(self.species) do
        local speciesIndex = index
        local button = self.speciesCards:Add("DButton")
        button:SetText("")
        button._hover = 0
        button.Think = function(s)
            local target = s:IsHovered() and 1 or 0
            s._hover = Lerp(FrameTime() * 10, s._hover or 0, target)
        end

        button.Paint = function(s, w, h)
            local active = self.selectedSpeciesIndex == speciesIndex
            local accent = getThemeAccent()
            local hover = s._hover or 0
            local lift = math.floor(hover * 7)
            local top = 8 - lift
            local bodyX = 5
            local bodyW = w - 10
            local bodyH = h - 14
            local pointDepth = math.Clamp(math.floor(bodyH * 0.18), 18, 28)
            local points = {
                {
                    x = bodyX,
                    y = top
                },
                {
                    x = bodyX + bodyW,
                    y = top
                },
                {
                    x = bodyX + bodyW,
                    y = top + bodyH - pointDepth
                },
                {
                    x = bodyX + bodyW * 0.5,
                    y = top + bodyH
                },
                {
                    x = bodyX,
                    y = top + bodyH - pointDepth
                }
            }

            draw.NoTexture()
            surface.SetDrawColor(active and Color(accent.r, accent.g, accent.b, 35) or getThemeSurface(0.05, 242))
            surface.DrawPoly(points)
            surface.SetDrawColor(active and Color(accent.r, accent.g, accent.b, 245) or Color(accent.r, accent.g, accent.b, 65 + hover * 75))
            for pointIndex = 1, #points do
                local current = points[pointIndex]
                local nextPoint = points[pointIndex % #points + 1]
                surface.DrawLine(current.x, current.y, nextPoint.x, nextPoint.y)
            end

            if active then
                surface.SetDrawColor(accent.r, accent.g, accent.b, 235)
                surface.DrawRect(bodyX + 7, top + 6, bodyW - 14, 3)
            end

            draw.SimpleText(string.upper(species.profile.name or "Species"), "LiliaFont.18", w * 0.5, top + 18, active and getThemeTextColor(fallbackText) or getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            drawSpeciesIcon(species.id, w * 0.5 - 25, top + 54, 50, Color(accent.r, accent.g, accent.b))
            if active then draw.SimpleText("SELECTED", "LiliaFont.15", w * 0.5, top + bodyH - pointDepth - 12, accent, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        end

        button.DoClick = function() self:SelectSpecies(speciesIndex) end
        self.speciesButtons[index] = button
    end
end

function PANEL:BuildOriginCards()
    for _, panel in ipairs(self.originList.Panels or {}) do
        if IsValid(panel) then panel:Remove() end
    end

    self.originList.Panels = {}
    self.originButtons = {}
    local species = self:GetSelectedSpecies()
    for index, origin in ipairs(module:GetSpeciesOrigins(species)) do
        local originIndex = index
        local button = vgui.Create("DButton")
        button:SetSize(150, 120)
        button:SetText("")
        button._hover = 0
        button.Think = function(s)
            local target = s:IsHovered() and 1 or 0
            s._hover = Lerp(FrameTime() * 10, s._hover or 0, target)
        end

        button.Paint = function(s, w, h)
            local active = self.selectedOriginIndex == originIndex
            local accent = getThemeAccent()
            local hover = s._hover or 0
            local lift = math.floor(hover * 5)
            local top = 6 - lift
            local pointDepth = 18
            local points = {
                {
                    x = 4,
                    y = top
                },
                {
                    x = w - 4,
                    y = top
                },
                {
                    x = w - 4,
                    y = h - pointDepth
                },
                {
                    x = w * 0.5,
                    y = h - 2
                },
                {
                    x = 4,
                    y = h - pointDepth
                }
            }

            draw.NoTexture()
            surface.SetDrawColor(active and Color(accent.r, accent.g, accent.b, 35) or getThemeSurface(0.05, 242))
            surface.DrawPoly(points)
            surface.SetDrawColor(active and Color(accent.r, accent.g, accent.b, 245) or Color(accent.r, accent.g, accent.b, 55 + hover * 70))
            for pointIndex = 1, #points do
                local current = points[pointIndex]
                local nextPoint = points[pointIndex % #points + 1]
                surface.DrawLine(current.x, current.y, nextPoint.x, nextPoint.y)
            end

            drawSpeciesIcon(species.id, w * 0.5 - 11, top + 12, 22, accent)
            drawWrappedText(origin.name or "Origin", "LiliaFont.16", w * 0.5, top + 40, w - 18, 17, active and getThemeTextColor(fallbackText) or getThemeTextColor(fallbackText), 3, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function() self:SelectOrigin(originIndex) end
        self.originList:AddPanel(button)
        self.originButtons[index] = button
    end
end

function PANEL:SelectSpecies(index)
    local species = self.species[index]
    if not species then return end
    self.selectedSpeciesIndex = index
    self.selectedOriginIndex = 0
    self.selectedModelIndex = 1
    self.selectedPronouns = nil
    self.selectedTraits = {}
    self.selectedAttributes = {}
    self.selectedLanguages = {}
    self.languageSelectionOrder = {}
    self.selectedKitItems = {}
    self.selectedOutfitID = nil
    self.currentSpeciesName = species.profile.name or "Species"
    self.currentOriginName = nil
    self.speciesNameLabel:SetText(self.currentSpeciesName)
    self.speciesDescriptionLabel:SetText(species.profile.description or "")
    self.originNameLabel:SetText("Select an origin")
    self.originDescriptionLabel:SetText("Choose an origin before continuing to character customization.")
    local sexes = module:GetSpeciesSexes(species)
    self.selectedSexID = sexes[1] and sexes[1].id or "na"
    self.selectedHeight = tonumber(species.profile.defaultHeight) or 69
    self:ResetAppearanceSelection(true)
    self:ConfigureHeightSlider(true)
    self:BuildOriginCards()
    self:RefreshWorldModel(true, true)
    self.continueButton:SetEnabled(false)
end

function PANEL:SelectOrigin(index)
    local origin = module:GetSpeciesOrigins(self:GetSelectedSpecies())[index]
    if not origin then return end
    self.selectedOriginIndex = index
    self.currentOriginName = origin.name or "Origin"
    self.originNameLabel:SetText(self.currentOriginName)
    self.originDescriptionLabel:SetText(origin.description or "")
    self.selectedPronouns = nil
    self.selectedTraits = {}
    self.selectedAttributes = {}
    self.selectedLanguages = {}
    self.languageSelectionOrder = {}
    self.selectedKitItems = {}
    self.selectedOutfitID = nil
    self:BuildAttributeControls()
    local species = self:GetSelectedSpecies()
    self.continueButton:SetEnabled(species ~= nil and #self:GetFilteredModels() > 0)
end

function PANEL:BuildSexButtons()
    local page = self.tabPages[1]
    for _, button in ipairs(page.sexButtons or {}) do
        if IsValid(button) then button:Remove() end
    end

    page.sexButtons = {}
    local sexes = module:GetSpeciesSexes(self:GetSelectedSpecies())
    for index, sex in ipairs(sexes) do
        local sexData = sex
        local button = page.sexPanel:Add("DButton")
        button:SetText("")
        button.Paint = function(s, w, h)
            local active = self.selectedSexID == sexData.id
            local accent = getThemeAccent()
            drawPanel(0, 0, w, h, 5, active and Color(accent.r, accent.g, accent.b, 32) or getThemeSurface(0.025, 210), Color(accent.r, accent.g, accent.b, active and 190 or s:IsHovered() and 105 or 45))
            draw.SimpleText(string.upper(sexData.name or sexData.id), "LiliaFont.18", w * 0.5, h * 0.5, active and getThemeTextColor(fallbackText) or getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        button:SetZPos(20)
        button.DoClick = function()
            self.selectedSexID = sexData.id
            self.selectedModelIndex = 1
            self:ResetAppearanceSelection(false)
            self:BuildModelCards()
            self:ConfigureHeightSlider(false)
            self:ApplyDefaultPronounsForSelection()
            self:ApplyModelDescriptionDefault(false)
            self:RefreshWorldModel(true, false)
            self:PopulateAppearanceControls()
        end

        page.sexButtons[index] = button
    end
end

function PANEL:ConfigureModelCardPreview(modelPanel, model)
    modelPanel:SetModel(normalizeModelPath(model.model))
    modelPanel:SetAnimated(false)
    modelPanel:SetFOV(22)
    modelPanel:SetMouseInputEnabled(false)
    modelPanel:SetKeyboardInputEnabled(false)
    modelPanel.LayoutEntity = function() end
    modelPanel.Think = function(s)
        local entity = s.Entity
        if s.cameraConfigured or not IsValid(entity) then return end
        self:ApplyModelAppearance(entity, false)
        entity:SetAngles(Angle(0, 15, 0))
        entity:SetupBones()
        local mins, maxs = entity:GetRenderBounds()
        local height = math.max(maxs.z - mins.z, 48)
        local head
        local attachmentIndex = entity:LookupAttachment("eyes")
        if attachmentIndex and attachmentIndex > 0 then
            local attachment = entity:GetAttachment(attachmentIndex)
            if attachment and attachment.Pos then head = attachment.Pos end
        end

        if not head then
            local boneNames = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Head", "Bip01 Head", "Head"}
            for _, boneName in ipairs(boneNames) do
                local boneIndex = entity:LookupBone(boneName)
                if boneIndex then
                    local position = entity:GetBonePosition(boneIndex)
                    if position then
                        head = position
                        break
                    end
                end
            end
        end

        head = head or Vector((mins.x + maxs.x) * 0.5, (mins.y + maxs.y) * 0.5, mins.z + height * 0.82)
        local distance = math.Clamp(height * 0.52, 34, 42)
        local lookAt = head - Vector(0, 0, height * 0.035)
        s:SetLookAt(lookAt)
        s:SetCamPos(head + Vector(distance, distance * 0.2, height * 0.03))
        s.cameraConfigured = true
    end
end

function PANEL:LayoutModelCards(page)
    if not IsValid(page) or not IsValid(page.modelScroller) then return end
    local canvas = page.modelScroller:GetCanvas()
    if not IsValid(canvas) then return end
    local vbar = page.modelScroller:GetVBar()
    local width = math.max(page.modelScroller:GetWide() - (IsValid(vbar) and vbar:GetWide() or 0) - 2, 1)
    local columns = width >= 780 and 3 or width >= 510 and 2 or 1
    local gap = 10
    local cardHeight = 160
    local cardWidth = math.floor((width - gap * (columns - 1)) / columns)
    for index, button in ipairs(page.modelButtons or {}) do
        local column = (index - 1) % columns
        local row = math.floor((index - 1) / columns)
        button:SetPos(column * (cardWidth + gap), row * (cardHeight + gap))
        button:SetSize(cardWidth, cardHeight)
        if IsValid(button.modelPreview) then
            button.modelPreview:SetPos(8, 8)
            button.modelPreview:SetSize(cardWidth - 16, cardHeight - 44)
        end
    end

    local rows = math.ceil(#(page.modelButtons or {}) / columns)
    canvas:SetTall(math.max(rows * cardHeight + math.max(rows - 1, 0) * gap, 1))
end

function PANEL:BuildModelCards()
    local page = self.tabPages[1]
    local canvas = page.modelScroller:GetCanvas()
    for _, child in ipairs(canvas:GetChildren()) do
        if IsValid(child) then child:Remove() end
    end

    page.modelButtons = {}
    local models = self:GetFilteredModels()
    self.selectedModelIndex = math.Clamp(self.selectedModelIndex, 1, math.max(#models, 1))
    for index, model in ipairs(models) do
        local modelIndex = index
        local button = vgui.Create("DButton", canvas)
        button:SetText("")
        button:SetZPos(20)
        button.Paint = function(s, w, h)
            local active = self.selectedModelIndex == modelIndex
            local accent = getThemeAccent()
            drawPanel(0, 0, w, h, 7, active and Color(accent.r, accent.g, accent.b, 30) or getThemeSurface(0.05, 235), Color(accent.r, accent.g, accent.b, active and 205 or s:IsHovered() and 115 or 45))
            surface.SetDrawColor(getThemeSurface(0.015, 220))
            surface.DrawRect(8, h - 36, w - 16, 28)
            if active then
                surface.SetDrawColor(accent.r, accent.g, accent.b, 225)
                surface.DrawRect(7, 6, w - 14, 3)
                draw.SimpleText("✓", "LiliaFont.18", w - 12, 10, accent, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            draw.SimpleText(fitText(model.name or self:GetModelDisplayName(model), "LiliaFont.18", w - 28), "LiliaFont.18", w * 0.5, h - 22, active and getThemeAccent() or getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function()
            self.selectedModelIndex = modelIndex
            self:ResetAppearanceSelection(false)
            self:ApplyDefaultPronounsForSelection()
            self:ApplyModelDescriptionDefault(false)
            self:RefreshWorldModel(true, false)
            self:PopulateAppearanceControls()
        end

        button.modelPreview = button:Add("DModelPanel")
        self:ConfigureModelCardPreview(button.modelPreview, model)
        page.modelButtons[index] = button
    end

    self:LayoutModelCards(page)
    timer.Simple(0, function() if IsValid(self) and IsValid(page) then self:LayoutModelCards(page) end end)
end

function PANEL:GetModelDisplayName(model)
    local path = normalizeModelPath(model and model.model)
    local name = path:match("([^/]+)%.mdl$") or path
    return string.upper(name:gsub("_", " "))
end

function PANEL:PopulateInformationChoices()
    local availablePronouns = self:GetSelectedSpecies().profile.pronouns or module.Pronouns or {}
    self.pronounsCombo:Clear()
    for _, pronouns in ipairs(availablePronouns) do
        self.pronounsCombo:AddChoice(pronouns, pronouns)
    end

    if not self.selectedPronouns then self.selectedPronouns = self:GetDefaultPronounsForSelection() or availablePronouns[1] end
    if self.selectedPronouns then self.pronounsCombo:SetValue(self.selectedPronouns) end
    self.pronounsCombo.OnSelect = function(_, _, _, data) self.selectedPronouns = data end
    self.birthMonthCombo:Clear()
    for _, month in ipairs(months) do
        self.birthMonthCombo:AddChoice(month, month)
    end

    self.selectedBirthMonth = self.selectedBirthMonth or months[1]
    self.birthMonthCombo:SetValue(self.selectedBirthMonth)
    self.birthMonthCombo.OnSelect = function(_, _, _, data) self.selectedBirthMonth = data end
    self.birthYearCombo:Clear()
    local currentYear = tonumber(os.date("%Y")) or 2026
    for year = currentYear - 14, currentYear - 110, -1 do
        self.birthYearCombo:AddChoice(tostring(year), year)
    end

    self.selectedBirthYear = self.selectedBirthYear or currentYear - 25
    self.birthYearCombo:SetValue(tostring(self.selectedBirthYear))
    self.birthYearCombo.OnSelect = function(_, _, _, data) self.selectedBirthYear = tonumber(data) end
    self.generationCombo:Clear()
    local generations = self:GetSelectedSpecies().profile.generations or {"Unknown Generation"}
    for _, generation in ipairs(generations) do
        self.generationCombo:AddChoice(generation, generation)
    end

    self.selectedGeneration = generations[1]
    self.generationCombo:SetValue(self.selectedGeneration)
    self.generationCombo.OnSelect = function(_, _, _, data) self.selectedGeneration = data end
    local generationMode = self:GetSelectedSpecies().profile.birthMode == "generation"
    self.generationWrap:SetVisible(generationMode)
    self.birthMonthWrap:SetVisible(not generationMode)
    self.birthYearWrap:SetVisible(not generationMode)
end

function PANEL:GetAttributeGroups()
    return module:GetAttributeGroups(self:GetSelectedSpecies(), self:GetSelectedOrigin())
end

function PANEL:EnsureAttributeValues()
    local values = {}
    for _, group in ipairs(self:GetAttributeGroups()) do
        for _, attribute in ipairs(group.attributes or {}) do
            local attributeID = getAttributeID(attribute)
            if attributeID then
                local minimum = tonumber(attribute.minimum) or tonumber(group.minimum) or tonumber(module.AttributeMinimum) or 1
                local maximum = tonumber(attribute.maximum) or tonumber(group.maximum) or tonumber(module.AttributeMaximum) or 5
                if maximum < minimum then maximum = minimum end
                local defaultValue = tonumber(attribute.default) or minimum
                values[attributeID] = math.Clamp(math.floor(tonumber(self.selectedAttributes and self.selectedAttributes[attributeID]) or defaultValue), minimum, maximum)
            end
        end
    end

    self.selectedAttributes = values
end

function PANEL:ResetAttributeValues()
    self.selectedAttributes = {}
    self:EnsureAttributeValues()
end

function PANEL:GetAttributeGroupPointsRemaining(group)
    if not group then return 0 end
    local remaining = tonumber(group.budget) or 0
    for _, attribute in ipairs(group.attributes or {}) do
        local attributeID = getAttributeID(attribute)
        if attributeID then
            local minimum = tonumber(attribute.minimum) or tonumber(group.minimum) or tonumber(module.AttributeMinimum) or 1
            local value = tonumber(self.selectedAttributes and self.selectedAttributes[attributeID]) or tonumber(attribute.default) or minimum
            remaining = remaining - math.max(math.floor(value) - minimum, 0)
        end
    end
    return remaining
end

function PANEL:SetAttributeValue(groupIndex, attributeID, requestedValue)
    local group = self.attributeGroups and self.attributeGroups[groupIndex] or self:GetAttributeGroups()[groupIndex]
    if not group then return end
    local attribute
    for _, candidate in ipairs(group.attributes or {}) do
        if getAttributeID(candidate) == attributeID then
            attribute = candidate
            break
        end
    end

    if not attribute then return end
    local minimum = tonumber(attribute.minimum) or tonumber(group.minimum) or tonumber(module.AttributeMinimum) or 1
    local maximum = tonumber(attribute.maximum) or tonumber(group.maximum) or tonumber(module.AttributeMaximum) or 5
    if maximum < minimum then maximum = minimum end
    local current = math.Clamp(math.floor(tonumber(self.selectedAttributes[attributeID]) or tonumber(attribute.default) or minimum), minimum, maximum)
    local requested = math.Clamp(math.floor(tonumber(requestedValue) or current), minimum, maximum)
    local target = requested
    if requested == current and current > minimum then
        target = current - 1
    elseif requested > current then
        local remaining = math.max(math.floor(tonumber(self:GetAttributeGroupPointsRemaining(group)) or 0), 0)
        target = math.min(requested, current + remaining)
    end

    if target == current then return end
    self.selectedAttributes[attributeID] = target
    if IsValid(self.attributeSummaryPanel) then self.attributeSummaryPanel:InvalidateLayout(true) end
    if IsValid(self.attributePanel) then self.attributePanel:InvalidateLayout(true) end
end

function PANEL:BuildAttributeControls()
    if not IsValid(self.attributePanel) then return end
    for _, panel in ipairs(self.attributeGroupPanels or {}) do
        if IsValid(panel) then panel:Remove() end
    end

    self.attributeGroups = self:GetAttributeGroups()
    self:EnsureAttributeValues()
    self.attributeGroupPanels = {}
    self.attributeRows = {}
    self.attributeButtons = {}
    for groupIndex, group in ipairs(self.attributeGroups) do
        local groupSlot = groupIndex
        local groupData = group
        local groupPanel = self.attributePanel:Add("DPanel")
        groupPanel.Paint = function(_, w, h)
            local accent = getThemeAccent()
            drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 246), getThemeAccent(92))
            draw.SimpleText(string.upper(tostring(groupData.name or groupData.id or "GROUP")), "LiliaFont.18", w * 0.5, 12, getThemeTextColor(fallbackText), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            surface.SetDrawColor(accent.r, accent.g, accent.b, 80)
            surface.DrawRect(12, 43, math.max(w - 24, 1), 1)
        end

        self.attributeGroupPanels[groupSlot] = groupPanel
        self.attributeRows[groupSlot] = {}
        for attributeIndex, attribute in ipairs(groupData.attributes or {}) do
            local attributeSlot = attributeIndex
            local attributeData = attribute
            local attributeKey = getAttributeID(attributeData)
            if attributeKey then
                local row = groupPanel:Add("DPanel")
                row._groupIndex = groupSlot
                row._attributeIndex = attributeSlot
                row._attribute = attributeData
                row._buttons = {}
                row._dotStart = 0
                row.Paint = function(s, w, h)
                    local accent = getThemeAccent()
                    local label = tostring(attributeData.name or attributeKey)
                    draw.SimpleText(label, "LiliaFont.15", 2, h * 0.5, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    surface.SetFont("LiliaFont.15")
                    local textWidth = surface.GetTextSize(label)
                    local lineStart = math.min(2 + textWidth + 8, math.max((s._dotStart or w) - 14, 2))
                    local lineEnd = math.max((s._dotStart or w) - 8, lineStart)
                    if lineEnd > lineStart then
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 72)
                        surface.DrawRect(lineStart, math.floor(h * 0.5), lineEnd - lineStart, 1)
                    end
                end

                local minimum = tonumber(attributeData.minimum) or tonumber(groupData.minimum) or tonumber(module.AttributeMinimum) or 1
                local maximum = tonumber(attributeData.maximum) or tonumber(groupData.maximum) or tonumber(module.AttributeMaximum) or 5
                if maximum < minimum then maximum = minimum end
                for value = minimum, maximum do
                    local dotValue = value
                    local button = row:Add("DButton")
                    button:SetText("")
                    button:SetCursor("hand")
                    button._hover = 0
                    button.Think = function(s)
                        local target = s:IsHovered() and 1 or 0
                        s._hover = Lerp(FrameTime() * 18, s._hover or 0, target)
                    end

                    button.OnCursorEntered = function(s) s._hover = math.max(s._hover or 0, 0.2) end
                    button.Paint = function(s, w, h)
                        local current = tonumber(self.selectedAttributes[attributeKey]) or minimum
                        local active = current >= dotValue
                        local hover = math.Clamp(s._hover or 0, 0, 1)
                        local accent = getThemeAccent()
                        local themeText = getThemeMutedColor(180)
                        local size = math.min(w, h)
                        local innerSize = math.max(size - 2, 1)
                        local fillAlpha = active and math.floor(172 + hover * 72) or math.floor(hover * 82)
                        if fillAlpha > 0 then
                            surface.SetDrawColor(accent.r, accent.g, accent.b, fillAlpha)
                            surface.DrawRect(1, 1, innerSize, innerSize)
                        end

                        local outline = active and themeText or hover > 0.01 and accent or themeText
                        local outlineAlpha = active and math.floor(205 + hover * 50) or math.floor(135 + hover * 120)
                        surface.SetDrawColor(outline.r, outline.g, outline.b, outlineAlpha)
                        surface.DrawOutlinedRect(0, 0, size, size, 1)
                        if hover > 0.01 and size > 4 then
                            surface.SetDrawColor(themeText.r, themeText.g, themeText.b, math.floor(55 + hover * 165))
                            surface.DrawOutlinedRect(2, 2, size - 4, size - 4, 1)
                        end
                    end

                    button.DoClick = function() self:SetAttributeValue(groupSlot, attributeKey, dotValue) end
                    row._buttons[#row._buttons + 1] = button
                    self.attributeButtons[#self.attributeButtons + 1] = button
                end

                self.attributeRows[groupSlot][#self.attributeRows[groupSlot] + 1] = row
            end
        end
    end

    self.attributePanel.PerformLayout = function(_, w, h)
        local groups = self.attributeGroupPanels or {}
        local columnGap = 10
        local groupCount = math.max(#groups, 1)
        local availableWidth = math.max(w - columnGap * math.max(groupCount - 1, 0), 1)
        local columnWidth = availableWidth / groupCount
        for groupIndex, groupPanel in ipairs(groups) do
            local x = math.floor((groupIndex - 1) * (columnWidth + columnGap))
            local nextX = groupIndex == #groups and w or math.floor(groupIndex * (columnWidth + columnGap) - columnGap)
            groupPanel:SetPos(x, 0)
            groupPanel:SetSize(math.max(nextX - x, 1), h)
            local rows = self.attributeRows[groupIndex] or {}
            local headerHeight = 47
            local rowGap = 0
            local rowHeight = math.Clamp(math.floor((h - headerHeight - rowGap * math.max(#rows - 1, 0) - 12) / math.max(#rows, 1)), 38, 44)
            local contentY = headerHeight
            for rowIndex, row in ipairs(rows) do
                row:SetPos(14, contentY + (rowIndex - 1) * (rowHeight + rowGap))
                row:SetSize(math.max(groupPanel:GetWide() - 28, 1), rowHeight)
                local buttonCount = math.max(#row._buttons, 1)
                local dotSize = math.Clamp(math.floor(rowHeight * 0.42), 15, 18)
                local dotGap = 3
                local dotStride = dotSize + dotGap
                local dotWidth = dotSize + math.max(buttonCount - 1, 0) * dotStride
                local dotStart = math.max(row:GetWide() - dotWidth - 12, 12)
                local dotY = math.floor((rowHeight - dotSize) * 0.5)
                row._dotStart = dotStart
                for buttonIndex, button in ipairs(row._buttons) do
                    button:SetPos(dotStart + (buttonIndex - 1) * dotStride, dotY)
                    button:SetSize(dotSize, dotSize)
                    button:MoveToFront()
                end
            end
        end
    end

    self.attributePanel:InvalidateLayout(true)
    if IsValid(self.attributeSummaryPanel) then self.attributeSummaryPanel:InvalidateLayout(true) end
end

function PANEL:BuildTraitCards()
    local scrollGroups = {
        positive = self.traitPositiveScroll,
        negative = self.traitNegativeScroll,
        claimedPositive = self.traitClaimedPositiveScroll,
        claimedNegative = self.traitClaimedNegativeScroll
    }

    for _, scroll in pairs(scrollGroups) do
        if not IsValid(scroll) then return end
        for _, child in ipairs(scroll:GetCanvas():GetChildren()) do
            child:Remove()
        end
    end

    local groupedButtons = {
        positive = {},
        negative = {},
        claimedPositive = {},
        claimedNegative = {}
    }

    self.traitButtons = {}
    for _, trait in ipairs(module:GetSpeciesTraits(self:GetSelectedSpecies(), self:GetSelectedOrigin())) do
        local traitData = trait
        local cost = tonumber(traitData.cost) or 0
        local active = self.selectedTraits[traitData.id] == true
        local group = active and (cost >= 0 and "claimedPositive" or "claimedNegative") or cost >= 0 and "positive" or "negative"
        local button = scrollGroups[group]:GetCanvas():Add("DButton")
        local tone = cost >= 0 and getThemeAccent() or getThemeNegativeColor()
        button:SetText("")
        button:SetCursor("hand")
        button.Paint = function(s, w, h)
            local hovered = s:IsHovered()
            local background = hovered and getThemeSurface(0.12, 255) or getThemeSurface(0.08, 255)
            local outline = Color(tone.r, tone.g, tone.b, hovered and 180 or active and 145 or 85)
            local costText = cost > 0 and "-" .. tostring(cost) or cost < 0 and "+" .. tostring(math.abs(cost)) or "0"
            surface.SetFont("LiliaFont.18")
            local costWidth = surface.GetTextSize(costText)
            drawPanel(0, 0, w, h, 9, background, outline)
            draw.RoundedBox(2, 0, 10, 4, math.max(h - 20, 1), tone)
            drawPanel(w - costWidth - 22, 9, costWidth + 12, 25, 12, Color(tone.r, tone.g, tone.b, 38), Color(tone.r, tone.g, tone.b, 90))
            drawWrappedText(traitData.name or traitData.id, "LiliaFont.18", 12, 10, math.max(w - costWidth - 43, 20), 18, getThemeTextColor(fallbackText), 1, TEXT_ALIGN_LEFT)
            draw.SimpleText(costText, "LiliaFont.18", w - 16, 21, tone, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            drawWrappedText(traitData.description or "", "LiliaFont.16", 12, 40, math.max(w - 24, 20), 16, getThemeMutedColor(185), 2, TEXT_ALIGN_LEFT)
        end

        button.DoClick = function()
            if self.selectedTraits[traitData.id] then
                self.selectedTraits[traitData.id] = nil
            else
                if cost > self:GetTraitPointsRemaining() then
                    notifyError("Not enough trait points.")
                    return
                end

                self.selectedTraits[traitData.id] = true
            end

            self:NormalizeLanguageSelection()
            self:BuildTraitCards()
            if IsValid(self.languageScroll) then self:BuildLanguageCards() end
            if IsValid(self.traitPointsPanel) then self.traitPointsPanel:InvalidateLayout(true) end
            if IsValid(self.languageStatusPanel) then self.languageStatusPanel:InvalidateLayout(true) end
        end

        groupedButtons[group][#groupedButtons[group] + 1] = button
        self.traitButtons[#self.traitButtons + 1] = button
    end

    local emptyMessages = {
        positive = "No positive traits available.",
        negative = "No negative traits available.",
        claimedPositive = "No positive traits claimed.",
        claimedNegative = "No negative traits claimed."
    }

    for group, scroll in pairs(scrollGroups) do
        local canvas = scroll:GetCanvas()
        local buttons = groupedButtons[group]
        if #buttons == 0 then
            local empty = canvas:Add("DLabel")
            empty:SetFont("LiliaFont.16")
            empty:SetTextColor(getThemeMutedColor(185))
            empty:SetText(emptyMessages[group])
            empty:SetWrap(true)
            empty:SetContentAlignment(5)
            canvas.PerformLayout = function(_, w)
                empty:SetPos(8, 10)
                empty:SetSize(math.max(w - 16, 1), 50)
                canvas:SetTall(70)
            end
        else
            canvas.PerformLayout = function(_, w)
                local gap = 8
                local y = 0
                for _, button in ipairs(buttons) do
                    button:SetPos(0, y)
                    button:SetSize(w, 80)
                    y = y + 80 + gap
                end

                canvas:SetTall(math.max(y - gap, 0))
            end
        end

        canvas:InvalidateLayout(true)
    end
end

function PANEL:GetTraitPointsRemaining()
    local remaining = tonumber(module.TraitPointBudget) or 0
    local traits = module:GetSpeciesTraits(self:GetSelectedSpecies(), self:GetSelectedOrigin())
    for _, trait in ipairs(traits) do
        if self.selectedTraits[trait.id] then remaining = remaining - (tonumber(trait.cost) or 0) end
    end
    return remaining
end

function PANEL:GetLanguageDefinitions()
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    if isfunction(module.GetLanguages) then
        local languages = module:GetLanguages(species, origin)
        if istable(languages) then return languages end
    end

    local hooked = hook.Run("SpeciesCreatorGetLanguages", species, origin)
    if istable(hooked) then return hooked end
    if origin and istable(origin.languages) then return origin.languages end
    local profile = species and (species.profile or species) or nil
    if profile and istable(profile.languages) then return profile.languages end
    return istable(module.Languages) and module.Languages or {}
end

function PANEL:GetInnateLanguageMap()
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    local values
    if isfunction(module.GetInnateLanguages) then values = module:GetInnateLanguages(species, origin) end
    if not istable(values) then values = hook.Run("SpeciesCreatorGetInnateLanguages", species, origin) end
    if not istable(values) then
        values = {}
        local added = {}
        local function append(entries)
            for _, entry in ipairs(entries or {}) do
                local id = istable(entry) and entry.id or entry
                id = string.Trim(tostring(id or "")):lower()
                if id ~= "" and not added[id] then
                    added[id] = true
                    values[#values + 1] = id
                end
            end
        end

        append(istable(module.DefaultInnateLanguages) and module.DefaultInnateLanguages or {"english"})
        local profile = species and (species.profile or species) or nil
        if profile then append(profile.innateLanguages) end
        if origin then append(origin.innateLanguages) end
    end

    local innate = {}
    for _, id in ipairs(values) do
        innate[tostring(id)] = true
    end
    return innate
end

function PANEL:GetInnateLanguageNames()
    local innate = self:GetInnateLanguageMap()
    local names = {}
    for _, language in ipairs(self:GetLanguageDefinitions()) do
        if innate[tostring(language.id)] then names[#names + 1] = language.name or language.id end
    end
    return names
end

function PANEL:GetLanguageTokenBudget()
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    if isfunction(module.GetLanguageTokenBudget) then
        local budget = module:GetLanguageTokenBudget(species, origin, self.selectedTraits)
        if isnumber(budget) then return math.max(math.floor(budget), 0) end
    end

    local hooked = hook.Run("SpeciesCreatorGetLanguageTokenBudget", species, origin, self.selectedTraits)
    if isnumber(hooked) then return math.max(math.floor(hooked), 0) end
    local profile = species and (species.profile or species) or nil
    local budget = tonumber(module.LanguageTokenBudget) or 1
    if profile and profile.languageTokens ~= nil then budget = tonumber(profile.languageTokens) or budget end
    if origin and origin.languageTokens ~= nil then budget = tonumber(origin.languageTokens) or budget end
    for _, trait in ipairs(self:GetSelectedTraits()) do
        budget = budget + (tonumber(trait.languageTokens) or 0)
    end
    return math.max(math.floor(budget), 0)
end

function PANEL:GetLanguageTokensRemaining()
    return self:GetLanguageTokenBudget() - tableCount(self.selectedLanguages)
end

function PANEL:NormalizeLanguageSelection()
    local available = {}
    local innate = self:GetInnateLanguageMap()
    for _, language in ipairs(self:GetLanguageDefinitions()) do
        available[tostring(language.id)] = true
    end

    local normalized = {}
    local order = {}
    for _, id in ipairs(self.languageSelectionOrder or {}) do
        id = tostring(id)
        if self.selectedLanguages[id] and available[id] and not innate[id] and not normalized[id] then
            normalized[id] = true
            order[#order + 1] = id
        end
    end

    for id, selected in pairs(self.selectedLanguages or {}) do
        id = tostring(id)
        if selected and available[id] and not innate[id] and not normalized[id] then
            normalized[id] = true
            order[#order + 1] = id
        end
    end

    local budget = self:GetLanguageTokenBudget()
    while #order > budget do
        local id = table.remove(order)
        normalized[id] = nil
    end

    self.selectedLanguages = normalized
    self.languageSelectionOrder = order
end

function PANEL:GetSelectedLanguages()
    self:NormalizeLanguageSelection()
    local innate = self:GetInnateLanguageMap()
    local selected = {}
    for _, language in ipairs(self:GetLanguageDefinitions()) do
        local id = tostring(language.id)
        if innate[id] or self.selectedLanguages[id] then
            selected[#selected + 1] = {
                id = id,
                name = language.name or id,
                innate = innate[id] == true
            }
        end
    end
    return selected
end

function PANEL:BuildLanguageCards()
    if not IsValid(self.languageScroll) then return end
    self:NormalizeLanguageSelection()
    local canvas = self.languageScroll:GetCanvas()
    for _, child in ipairs(canvas:GetChildren()) do
        child:Remove()
    end

    self.languageButtons = {}
    local innate = self:GetInnateLanguageMap()
    for _, language in ipairs(self:GetLanguageDefinitions()) do
        local languageData = language
        local id = tostring(languageData.id)
        local button = canvas:Add("DButton")
        button:SetText("")
        button:SetCursor(innate[id] and "arrow" or "hand")
        button.Paint = function(s, w, h)
            local accent = getThemeAccent()
            local isInnate = innate[id] == true
            local selected = self.selectedLanguages[id] == true
            local active = isInnate or selected
            local outlineAlpha = active and 190 or s:IsHovered() and 110 or 48
            local background = active and Color(accent.r, accent.g, accent.b, isInnate and 20 or 30) or getThemeSurface(0.05, 240)
            drawPanel(0, 0, w, h, 7, background, Color(accent.r, accent.g, accent.b, outlineAlpha))
            if active then
                surface.SetDrawColor(accent.r, accent.g, accent.b, 220)
                surface.DrawRect(0, 0, 4, h)
            end

            draw.SimpleText(languageData.name or id, "LiliaFont.20", 14, 12, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            drawWrappedText(languageData.description or "", "LiliaFont.16", 14, 40, math.max(w - 28, 1), 17, getThemeMutedColor(), 2, TEXT_ALIGN_LEFT)
            local status = isInnate and "INNATE" or selected and "SELECTED" or "1 TOKEN"
            draw.SimpleText(status, "LiliaFont.15", w - 14, h - 12, active and accent or getThemeMutedColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end

        button.DoClick = function()
            if innate[id] then return end
            if self.selectedLanguages[id] then
                self.selectedLanguages[id] = nil
                for index = #self.languageSelectionOrder, 1, -1 do
                    if self.languageSelectionOrder[index] == id then table.remove(self.languageSelectionOrder, index) end
                end
            else
                if self:GetLanguageTokensRemaining() <= 0 then
                    notifyError("No language tokens remain.")
                    return
                end

                self.selectedLanguages[id] = true
                self.languageSelectionOrder[#self.languageSelectionOrder + 1] = id
            end

            self:BuildLanguageCards()
            if IsValid(self.languageStatusPanel) then self.languageStatusPanel:InvalidateLayout(true) end
        end

        self.languageButtons[#self.languageButtons + 1] = button
    end

    canvas.PerformLayout = function(_, w)
        local gap = 8
        local columns = w >= 520 and 2 or 1
        local cardWidth = math.floor((w - gap * (columns - 1)) / columns)
        local cardHeight = 94
        for index, button in ipairs(self.languageButtons) do
            local column = (index - 1) % columns
            local row = math.floor((index - 1) / columns)
            button:SetPos(column * (cardWidth + gap), row * (cardHeight + gap))
            button:SetSize(cardWidth, cardHeight)
        end

        local rows = math.ceil(#self.languageButtons / columns)
        canvas:SetTall(math.max(rows * cardHeight + math.max(rows - 1, 0) * gap, 0))
    end

    canvas:InvalidateLayout(true)
end

function PANEL:BuildKitCards()
    if not IsValid(self.kitScroll) then return end
    local canvas = self.kitScroll:GetCanvas()
    for _, child in ipairs(canvas:GetChildren()) do
        child:Remove()
    end

    self.kitButtons = {}
    local kit = self:GetCurrentKit()
    for index, item in ipairs(kit.items or {}) do
        local itemData = item
        local button = canvas:Add("DButton")
        button:SetText("")
        button.Paint = function(s, w, h)
            local active = self.selectedKitItems[itemData.id] == true
            local accent = getThemeAccent()
            drawPanel(0, 0, w, h, 7, active and Color(accent.r, accent.g, accent.b, 30) or getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, active and 190 or s:IsHovered() and 105 or 45))
            draw.SimpleText(itemData.name or itemData.id, "LiliaFont.22", 15, 12, getThemeTextColor(fallbackText), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            drawWrappedText(itemData.description or "", "LiliaFont.16", 15, 44, w - 30, 18, getThemeMutedColor(), 2, TEXT_ALIGN_LEFT)
            draw.SimpleText(active and "SELECTED" or "AVAILABLE", "LiliaFont.15", w - 15, h - 13, active and accent or getThemeMutedColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end

        button.DoClick = function()
            if self.selectedKitItems[itemData.id] then
                self.selectedKitItems[itemData.id] = nil
            else
                local required = tonumber(kit.pick) or 0
                if tableCount(self.selectedKitItems) >= required then
                    notifyError("Remove a selected item before choosing another.")
                    return
                end

                self.selectedKitItems[itemData.id] = true
            end

            self.kitStatusPanel:InvalidateLayout(true)
        end

        self.kitButtons[index] = button
    end

    canvas.PerformLayout = function(_, w)
        local gap = 8
        local y = 0
        for _, button in ipairs(self.kitButtons) do
            button:SetPos(0, y)
            button:SetSize(w, 82)
            y = y + 82 + gap
        end

        canvas:SetTall(math.max(y - gap, 0))
    end

    canvas:InvalidateLayout(true)
    self.outfitCombo:Clear()
    local outfits = self:GetCurrentOutfits()
    if #outfits == 0 then
        self.outfitCombo:SetValue("No modular outfit selection required")
        self.outfitCombo:SetEnabled(false)
        self.selectedOutfitID = nil
    else
        self.outfitCombo:SetEnabled(true)
        for _, outfit in ipairs(outfits) do
            local id = istable(outfit) and outfit.id or outfit
            local name = istable(outfit) and outfit.name or tostring(outfit)
            self.outfitCombo:AddChoice(name, id)
        end

        if not self.selectedOutfitID then
            local first = outfits[1]
            self.selectedOutfitID = istable(first) and first.id or first
        end

        for _, outfit in ipairs(outfits) do
            local id = istable(outfit) and outfit.id or outfit
            if id == self.selectedOutfitID then
                self.outfitCombo:SetValue(istable(outfit) and outfit.name or tostring(outfit))
                break
            end
        end
    end
end

function PANEL:GetSelectedAttributes()
    local selected = {}
    for _, group in ipairs(self:GetAttributeGroups()) do
        local groupID = getAttributeID(group)
        if groupID then
            selected[groupID] = {}
            for _, attribute in ipairs(group.attributes or {}) do
                local attributeID = getAttributeID(attribute)
                if attributeID then
                    local minimum = tonumber(attribute.minimum) or tonumber(group.minimum) or tonumber(module.AttributeMinimum) or 1
                    selected[groupID][attributeID] = tonumber(self.selectedAttributes[attributeID]) or tonumber(attribute.default) or minimum
                end
            end
        end
    end
    return selected
end

function PANEL:GetSelectedTraits()
    local selected = {}
    for _, trait in ipairs(module:GetSpeciesTraits(self:GetSelectedSpecies(), self:GetSelectedOrigin())) do
        if self.selectedTraits[trait.id] then selected[#selected + 1] = trait end
    end
    return selected
end

function PANEL:GetSelectedKitItems()
    local selected = {}
    for _, item in ipairs(self:GetCurrentKit().items or {}) do
        if self.selectedKitItems[item.id] then selected[#selected + 1] = item end
    end
    return selected
end

function PANEL:ConfigureHeightSlider(reset)
    local species = self:GetSelectedSpecies()
    if not species or not IsValid(self.heightSlider) then return end
    local minimum = math.floor(tonumber(species.profile.minHeight) or 55)
    local maximum = math.max(math.floor(tonumber(species.profile.maxHeight) or 84), minimum + 1)
    local default = math.Clamp(math.floor(tonumber(species.profile.defaultHeight) or minimum), minimum, maximum)
    local value = reset and default or math.Clamp(math.floor(tonumber(self.selectedHeight) or default), minimum, maximum)
    self.updatingHeightSlider = true
    self.heightWrap.minimum = minimum
    self.heightWrap.maximum = maximum
    self.heightWrap.value = value
    self.heightSlider:SetRange(minimum, maximum, 0)
    self.heightSlider:SetValue(value)
    self.updatingHeightSlider = false
    self.selectedHeight = value
end

function PANEL:SetCharacterHeight(value)
    local species = self:GetSelectedSpecies()
    if not species then return end
    local minimum = math.floor(tonumber(species.profile.minHeight) or 55)
    local maximum = math.max(math.floor(tonumber(species.profile.maxHeight) or 84), minimum + 1)
    local height = math.Clamp(math.floor(tonumber(value) or minimum), minimum, maximum)
    self.selectedHeight = height
    if IsValid(self.heightWrap) then
        self.heightWrap.value = height
        self.heightWrap:InvalidateLayout()
    end

    if IsValid(self.heightSlider) and not self.updatingHeightSlider and self.heightSlider:GetValue() ~= height then
        self.updatingHeightSlider = true
        self.heightSlider:SetValue(height)
        self.updatingHeightSlider = false
    end

    self:ApplyWorldModelScale(true)
    self:ApplyModelDescriptionDefault(false)
end

function PANEL:GetWorldModelScale()
    local species = self:GetSelectedSpecies()
    local entity = self.worldEntity
    if not species or not IsValid(entity) then return 1 end
    local mins, maxs = entity:GetModelRenderBounds()
    local nativeHeight = mins and maxs and math.max(maxs.z - mins.z, 1) or 0
    if nativeHeight <= 1 then
        local defaultHeight = tonumber(species.profile.defaultHeight) or self.selectedHeight or 69
        return math.Clamp((self.selectedHeight or defaultHeight) / defaultHeight, 0.65, 1.5)
    end

    local targetHeight = math.max(tonumber(self.selectedHeight) or tonumber(species.profile.defaultHeight) or 69, 1)
    return math.Clamp(targetHeight / nativeHeight, 0.65, 1.5)
end

function PANEL:GetScaledWorldModelBounds()
    local entity = self.worldEntity
    if not IsValid(entity) then return nil end
    local mins, maxs = entity:GetModelRenderBounds()
    if not mins or not maxs then mins, maxs = entity:GetRenderBounds() end
    local scale = self:GetWorldModelScale()
    return mins * scale, maxs * scale
end

function PANEL:UpdateCameraForHeight()
    if not IsValid(self.worldEntity) then return end
    local mode = "selection"
    if self.inCreation then
        if self.currentCreationTab == #tabDefinitions then
            mode = "summary"
        elseif self.currentCreationTab == 2 then
            mode = "appearance"
        else
            mode = "creation"
        end
    end

    if self.cameraCurrentOrigin then
        self:TransitionCamera(mode, 0.12)
    else
        self:RefreshCameraTarget(mode)
    end
end

function PANEL:ApplyWorldModelScale(updateCamera)
    local entity = self.worldEntity
    if not IsValid(entity) then return end
    local scale = self:GetWorldModelScale()
    local mins, maxs = entity:GetModelRenderBounds()
    entity:SetModelScale(scale, 0)
    if mins and maxs then entity:SetRenderBounds(mins * scale, maxs * scale) end
    entity:InvalidateBoneCache()
    entity:SetupBones()
    self:AlignWorldModelToGround()
    if updateCamera then self:UpdateCameraForHeight() end
    timer.Simple(0, function()
        if not IsValid(self) or not IsValid(entity) or entity ~= self.worldEntity then return end
        entity:InvalidateBoneCache()
        entity:SetupBones()
        self:AlignWorldModelToGround()
        if updateCamera then self:UpdateCameraForHeight() end
    end)
end

function PANEL:ApplyBiographyDefaults()
    local species = self:GetSelectedSpecies()
    local faction = species and (species.creationFaction or species.faction) or nil
    if not species or not faction then return end
    local model = self:GetSelectedCreationModel()
    local context = {
        faction = faction.index,
        model = model and model.key or 1,
        species = species.id
    }

    local defaultName, forceName = hook.Run("GetDefaultCharName", LocalPlayer(), faction.index, context)
    local defaultDesc, forceDesc = hook.Run("GetDefaultCharDesc", LocalPlayer(), faction.index, context)
    if isstring(defaultName) and forceName ~= false and (forceName or string.Trim(self.nameEntry:GetValue() or "") == "") then self.nameEntry:SetValue(defaultName) end
    if isstring(defaultDesc) and forceDesc ~= false and (forceDesc or string.Trim(self.descEntry:GetValue() or "") == "") then self.descEntry:SetValue(defaultDesc) end
end

function PANEL:EnableCreationInput()
    if not IsValid(self.inputWindow) then return end
    self.inputWindow:SetMouseInputEnabled(true)
    self.inputWindow:SetKeyboardInputEnabled(true)
    self.paper:SetMouseInputEnabled(true)
    self.creationPage:SetMouseInputEnabled(true)
    self.creationPage:SetKeyboardInputEnabled(true)
    self.tabNavigation:SetMouseInputEnabled(true)
    self.stage:SetMouseInputEnabled(true)
    self.stage:SetKeyboardInputEnabled(true)
    if IsValid(self.closeButton) then self.closeButton:SetMouseInputEnabled(true) end
    if IsValid(self.creationBackButton) then self.creationBackButton:SetMouseInputEnabled(true) end
    if IsValid(self.creationNextButton) then self.creationNextButton:SetMouseInputEnabled(true) end
    for _, button in ipairs(self.tabButtons or {}) do
        if IsValid(button) then button:SetMouseInputEnabled(true) end
    end

    for index, page in ipairs(self.tabPages or {}) do
        local active = index == self.currentCreationTab
        page:SetMouseInputEnabled(active)
        page:SetKeyboardInputEnabled(active)
    end

    local page = self.tabPages and self.tabPages[self.currentCreationTab]
    if not IsValid(page) then return end
    if self.currentCreationTab == 1 then
        page.sexPanel:SetMouseInputEnabled(true)
        page.modelScroller:SetMouseInputEnabled(true)
        for _, button in ipairs(page.sexButtons or {}) do
            if IsValid(button) then button:SetMouseInputEnabled(true) end
        end

        for _, button in ipairs(page.modelButtons or {}) do
            if IsValid(button) then button:SetMouseInputEnabled(true) end
        end
    elseif self.currentCreationTab == 2 then
        local controls = {self.skinCombo, self.heightSlider, self.eyeColorCombo, self.hairColorCombo}
        for _, control in ipairs(controls) do
            if IsValid(control) then
                control:SetMouseInputEnabled(true)
                control:SetKeyboardInputEnabled(true)
            end
        end

        for _, combo in ipairs(page.bodygroupCombos or {}) do
            if IsValid(combo) then
                combo:SetMouseInputEnabled(true)
                combo:SetKeyboardInputEnabled(true)
            end
        end
    elseif self.currentCreationTab == 3 then
        local entries = {self.nameEntry, self.descEntry, self.pronounsCombo, self.birthMonthCombo, self.birthYearCombo, self.generationCombo}
        for _, control in ipairs(entries) do
            if IsValid(control) then
                control:SetMouseInputEnabled(true)
                control:SetKeyboardInputEnabled(true)
            end
        end
    elseif self.currentCreationTab == 4 then
        for _, button in ipairs(self.attributeButtons or {}) do
            if IsValid(button) then button:SetMouseInputEnabled(true) end
        end
    elseif self.currentCreationTab == 5 then
        for _, scroll in ipairs(self.traitScrolls or {}) do
            if IsValid(scroll) then
                scroll:SetMouseInputEnabled(true)
                scroll:SetKeyboardInputEnabled(true)
            end
        end

        for _, button in ipairs(self.traitButtons or {}) do
            if IsValid(button) then button:SetMouseInputEnabled(true) end
        end
    elseif self.currentCreationTab == 6 then
        self.languageScroll:SetMouseInputEnabled(true)
        self.languageScroll:SetKeyboardInputEnabled(true)
        for _, button in ipairs(self.languageButtons or {}) do
            if IsValid(button) then button:SetMouseInputEnabled(true) end
        end
    elseif self.currentCreationTab == 7 then
        self.kitScroll:SetMouseInputEnabled(true)
        for _, button in ipairs(self.kitButtons or {}) do
            if IsValid(button) then button:SetMouseInputEnabled(true) end
        end

        self.outfitCombo:SetMouseInputEnabled(true)
        self.outfitCombo:SetKeyboardInputEnabled(true)
    elseif self.currentCreationTab == 8 then
        self.summaryScroll:SetMouseInputEnabled(true)
    end
end

function PANEL:OpenCreation()
    local species = self:GetSelectedSpecies()
    if not species then
        notifyError("Select a species before continuing.")
        return
    end

    if not self:GetSelectedOrigin() then
        notifyError("Select an origin before continuing.")
        return
    end

    if #self:GetFilteredModels() == 0 then
        notifyError("This species has no configured models.")
        return
    end

    self.inCreation = true
    self.inputWindow:SetMouseInputEnabled(true)
    self.inputWindow:SetKeyboardInputEnabled(true)
    self.paper:SetMouseInputEnabled(true)
    self.paper:SetKeyboardInputEnabled(true)
    self.selectionPage:SetVisible(false)
    self.selectionPage:SetMouseInputEnabled(false)
    self.selectionPage:SetKeyboardInputEnabled(false)
    self.creationPage:SetVisible(true)
    self.creationPage:SetZPos(20)
    self.creationPage:SetMouseInputEnabled(true)
    self.creationPage:SetKeyboardInputEnabled(true)
    self.stage:SetMouseInputEnabled(true)
    self.stage:SetKeyboardInputEnabled(true)
    self.creationPage:MoveToFront()
    self.tabNavigation:MoveToFront()
    self.stage:MoveToFront()
    self.creationBackButton:MoveToFront()
    self.creationNextButton:MoveToFront()
    self.closeButton:MoveToFront()
    self.paper:MoveToFront()
    self.inputWindow:MakePopup()
    self.inputWindow:SetZPos(32767)
    self.inputWindow:MoveToFront()
    self.inputWindow:RequestFocus()
    self.currentCreationTab = 1
    self.visitedTabs = {
        [1] = true
    }

    self:BuildSexButtons()
    self:BuildModelCards()
    self:PopulateAppearanceControls()
    self:PopulateInformationChoices()
    self:ConfigureHeightSlider(false)
    self:BuildAttributeControls()
    self:BuildTraitCards()
    self:BuildLanguageCards()
    self:BuildKitCards()
    self:ApplyBiographyDefaults()
    self:ApplyModelDescriptionDefault(false)
    self:SetCreationTab(1)
    self:EnableCreationInput()
    self:TransitionCamera("creation", 0.85)
    self:InvalidateLayout(true)
end

function PANEL:CloseCreation()
    if self.creating then return end
    if IsValid(self.appearanceWindow) then self.appearanceWindow:Remove() end
    self.inCreation = false
    self.creationPage:SetVisible(false)
    self.creationPage:SetMouseInputEnabled(false)
    self.creationPage:SetKeyboardInputEnabled(false)
    self.selectionPage:SetVisible(true)
    self.selectionPage:SetMouseInputEnabled(true)
    self.selectionPage:SetKeyboardInputEnabled(true)
    self.selectionPage:MoveToFront()
    self.closeButton:MoveToFront()
    self.paper:MoveToFront()
    self.inputWindow:MakePopup()
    self.inputWindow:SetZPos(32767)
    self.inputWindow:MoveToFront()
    self.inputWindow:RequestFocus()
    self:TransitionCamera("selection", 0.75)
    self:InvalidateLayout(true)
end

function PANEL:IsTabComplete(index)
    if index ~= 1 and not self.visitedTabs[index] then return false end
    local valid = self:ValidateTab(index, true)
    return valid == true
end

function PANEL:ValidateTab(index, silent)
    if index == 1 then
        if not self.selectedSexID then return false, "Select a sex." end
        if not self:GetSelectedModel() then return false, "Select a model." end
        return true
    end

    if index == 2 then
        local species = self:GetSelectedSpecies()
        local minimumHeight = tonumber(species.profile.minHeight) or 55
        local maximumHeight = tonumber(species.profile.maxHeight) or 84
        local height = IsValid(self.heightSlider) and tonumber(self.heightSlider:GetValue()) or tonumber(self.selectedHeight)
        if not height or height < minimumHeight or height > maximumHeight then return false, string.format("Height must be between %s and %s.", formatHeight(minimumHeight), formatHeight(maximumHeight)) end
        return true
    end

    if index == 3 then
        local name = string.Trim(self.nameEntry:GetValue() or "")
        local description = string.Trim(self.descEntry:GetValue() or "")
        if name == "" then return false, "Enter a character name." end
        local species = self:GetSelectedSpecies()
        if not self.selectedPronouns then return false, "Select pronouns." end
        if species.profile.birthMode == "generation" then
            if not self.selectedGeneration then return false, "Select a generation." end
        elseif not self.selectedBirthMonth or not self.selectedBirthYear then
            return false, "Select a birth month and year."
        end

        local minimumDescription = lia.config.get("MinDescLen", 16)
        if #description:gsub("%s", "") < minimumDescription then return false, "descMinLen" end
        return true
    end

    if index == 4 then
        for _, group in ipairs(self:GetAttributeGroups()) do
            local remaining = self:GetAttributeGroupPointsRemaining(group)
            if remaining > 0 then return false, "Spend all " .. string.lower(tostring(group.name or "attribute")) .. " points." end
            if remaining < 0 then return false, "Your " .. string.lower(tostring(group.name or "attribute")) .. " attributes exceed the available points." end
        end
        return true
    end

    if index == 5 then
        if self:GetTraitPointsRemaining() < 0 then return false, "Your selected traits exceed the available trait points." end
        return true
    end

    if index == 6 then
        self:NormalizeLanguageSelection()
        local remaining = self:GetLanguageTokensRemaining()
        if remaining > 0 then return false, string.format("Spend all %d remaining language token%s.", remaining, remaining == 1 and "" or "s") end
        if remaining < 0 then return false, "Too many additional languages are selected." end
        return true
    end

    if index == 7 then
        local kit = self:GetCurrentKit()
        local required = tonumber(kit.pick) or 0
        if tableCount(self.selectedKitItems) ~= required then return false, string.format("Select exactly %d starting kit item%s.", required, required == 1 and "" or "s") end
        if #self:GetCurrentOutfits() > 0 and not self.selectedOutfitID then return false, "Select a starting outfit." end
        return true
    end

    if index == 8 then
        for tabIndex = 1, 7 do
            if not self.visitedTabs[tabIndex] then return false, "Complete " .. tabDefinitions[tabIndex].short .. " before finishing." end
            local valid, message = self:ValidateTab(tabIndex, true)
            if not valid then return false, message end
        end
        return true
    end
    return true
end

function PANEL:RequestCreationTab(index)
    if index > self.currentCreationTab then
        for tabIndex = 1, index - 1 do
            if not self.visitedTabs[tabIndex] then
                notifyError("Complete " .. tabDefinitions[tabIndex].short .. " before continuing.")
                return
            end

            local valid, message = self:ValidateTab(tabIndex)
            if not valid then
                notifyError(message)
                return
            end
        end
    end

    self:SetCreationTab(index)
end

function PANEL:SetCreationTab(index)
    index = math.Clamp(index, 1, #tabDefinitions)
    if index ~= 2 and IsValid(self.appearanceWindow) then self.appearanceWindow:Remove() end
    self.currentCreationTab = index
    self.visitedTabs[index] = true
    self.stage:SetMouseInputEnabled(true)
    self.stage:SetKeyboardInputEnabled(true)
    for pageIndex, page in ipairs(self.tabPages) do
        local active = pageIndex == index
        page:SetVisible(active)
        page:SetMouseInputEnabled(active)
        page:SetKeyboardInputEnabled(active)
        if active then page:MoveToFront() end
    end

    if index == 2 then self:PopulateAppearanceControls() end
    if index == #tabDefinitions then self:UpdateSummary() end
    self.creationNextButton._text = index == #tabDefinitions and "CREATE CHARACTER" or "NEXT"
    local cameraMode = index == #tabDefinitions and "summary" or index == 2 and "appearance" or "creation"
    self:TransitionCamera(cameraMode, 0.35)
    for _, button in ipairs(self.tabButtons) do
        button:InvalidateLayout(true)
    end

    self.creationPage:MoveToFront()
    self.tabNavigation:MoveToFront()
    self.stage:MoveToFront()
    self.creationBackButton:MoveToFront()
    self.creationNextButton:MoveToFront()
    self.closeButton:MoveToFront()
    self.inputWindow:RequestFocus()
    self:EnableCreationInput()
end

function PANEL:UpdateSummary()
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    if not species or not origin then return end
    local traits = self:GetSelectedTraits()
    local kitItems = self:GetSelectedKitItems()
    local languages = self:GetSelectedLanguages()
    local birth = species.profile.birthMode == "generation" and (self.selectedGeneration or "Not selected") or string.format("%s %s", self.selectedBirthMonth or "", tostring(self.selectedBirthYear or ""))
    local outfitName = "Not required"
    for _, outfit in ipairs(self:GetCurrentOutfits()) do
        local id = istable(outfit) and outfit.id or outfit
        if id == self.selectedOutfitID then outfitName = istable(outfit) and outfit.name or tostring(outfit) end
    end

    local attributeGroups = {}
    for _, group in ipairs(self:GetAttributeGroups()) do
        local attributes = {}
        for _, attribute in ipairs(group.attributes or {}) do
            local attributeID = getAttributeID(attribute)
            if attributeID then
                attributes[#attributes + 1] = {
                    id = attributeID,
                    name = attribute.name or attributeID,
                    value = self.selectedAttributes[attributeID] or tonumber(attribute.default) or tonumber(attribute.minimum) or tonumber(group.minimum) or tonumber(module.AttributeMinimum) or 1,
                    maximum = tonumber(attribute.maximum) or tonumber(group.maximum) or tonumber(module.AttributeMaximum) or 5
                }
            end
        end

        attributeGroups[#attributeGroups + 1] = {
            id = group.id,
            name = group.name or group.id or "Group",
            attributes = attributes
        }
    end

    local traitData = {}
    for _, trait in ipairs(traits) do
        traitData[#traitData + 1] = {
            id = trait.id,
            name = trait.name or trait.id,
            cost = tonumber(trait.cost) or 0
        }
    end

    local languageData = {}
    for _, language in ipairs(languages) do
        languageData[#languageData + 1] = {
            id = language.id,
            name = language.name or language.id,
            innate = language.innate == true
        }
    end

    local kitData = {}
    for _, item in ipairs(kitItems) do
        kitData[#kitData + 1] = item.name or item.id
    end

    self.summaryData = {
        identity = {
            {
                label = "Species",
                value = species.profile.name or species.id
            },
            {
                label = "Origin",
                value = origin.name or origin.id
            },
            {
                label = "Name",
                value = string.Trim(self.nameEntry:GetValue() or "")
            },
            {
                label = "Birth",
                value = birth
            },
            {
                label = "Pronouns",
                value = tostring(self.selectedPronouns or "Not selected")
            }
        },
        appearance = {
            {
                label = "Model",
                value = self:GetSelectedModelName()
            },
            {
                label = "Sex",
                value = tostring(self.selectedSexID or "N/A")
            },
            {
                label = "Eyes",
                value = self:GetModelEyeColor()
            },
            {
                label = "Hair",
                value = self:GetModelHairColor()
            },
            {
                label = "Height",
                value = formatHeight(self.selectedHeight)
            }
        },
        description = string.Trim(self.descEntry:GetValue() or ""),
        attributes = attributeGroups,
        traits = traitData,
        languages = languageData,
        kit = kitData,
        outfit = outfitName
    }

    if IsValid(self.summaryCanvas) then self.summaryCanvas:InvalidateLayout(true) end
    local summaryPage = self.tabPages and self.tabPages[#tabDefinitions]
    if IsValid(summaryPage) then self:LayoutSummaryTab(summaryPage) end
end

function PANEL:PlaySpeciesSelectionSound(species)
    if self.activeSelectionSound then
        self.activeSelectionSound:Stop()
        self.activeSelectionSound = nil
    end

    local configured = species and species.profile and species.profile.selectionSounds or nil
    if isstring(configured) then configured = {configured} end
    if not istable(configured) or #configured == 0 then return end
    local soundPath = configured[math.random(1, #configured)]
    if not isstring(soundPath) or soundPath == "" then return end
    local source = IsValid(self.worldEntity) and self.worldEntity or LocalPlayer()
    if not IsValid(source) then
        surface.PlaySound(soundPath)
        return
    end

    local patch = CreateSound(source, soundPath)
    if patch then
        self.activeSelectionSound = patch
        patch:PlayEx(0.9, 100)
    else
        surface.PlaySound(soundPath)
    end
end

function PANEL:FindSequence(entity, sequences)
    if not IsValid(entity) then return nil end
    for _, sequenceName in ipairs(sequences or {}) do
        local sequence = entity:LookupSequence(sequenceName)
        if sequence and sequence >= 0 then return sequence end
    end
end

function PANEL:PlayRevealAnimation()
    local entity = self.worldEntity
    local species = self:GetSelectedSpecies()
    if not IsValid(entity) or not species then return end
    local sequence = self:FindSequence(entity, species.profile.revealSequences)
    if not sequence then
        self:PlayIdleAnimation()
        return
    end

    entity:ResetSequence(sequence)
    entity:SetCycle(0)
    entity:SetPlaybackRate(1)
    self.revealEnd = CurTime() + math.max(entity:SequenceDuration(sequence), 0.8)
end

function PANEL:PlayIdleAnimation()
    local entity = self.worldEntity
    local species = self:GetSelectedSpecies()
    if not IsValid(entity) or not species then return end
    local sequence = self:FindSequence(entity, species.profile.idleSequences)
    if not sequence then sequence = entity:SelectWeightedSequence(ACT_IDLE) end
    if sequence and sequence >= 0 then
        entity:ResetSequence(sequence)
        entity:SetCycle(0)
        entity:SetPlaybackRate(1)
    end
end

function PANEL:ApplyModelAppearance(entity, useSelected)
    if not IsValid(entity) then return end
    local maximumSkin = math.max(entity:SkinCount() - 1, 0)
    local skin = useSelected and math.Clamp(math.floor(tonumber(self.selectedSkin) or 0), 0, maximumSkin) or 0
    entity:SetSkin(skin)
    for _, group in ipairs(entity:GetBodyGroups() or {}) do
        local index = tonumber(group.id)
        if index then entity:SetBodygroup(index, 0) end
    end

    if not useSelected then return end
    for key, value in pairs(self.selectedBodygroups or {}) do
        local index = tonumber(key)
        if index then
            local count = math.max(entity:GetBodygroupCount(index), 1)
            entity:SetBodygroup(index, math.Clamp(math.floor(tonumber(value) or 0), 0, count - 1))
        end
    end
end

function PANEL:ApplySelectedAppearance()
    self:ApplyModelAppearance(self.worldEntity, true)
    local page = self.tabPages and self.tabPages[1]
    local button = page and page.modelButtons and page.modelButtons[self.selectedModelIndex]
    if IsValid(button) and IsValid(button.modelPreview) and IsValid(button.modelPreview.Entity) then self:ApplyModelAppearance(button.modelPreview.Entity, true) end
end

function PANEL:DrawWorldPreviewEntity(entity)
    if not IsValid(entity) then return end
    self.worldEntityDrawnFrame = FrameNumber()
    cam.IgnoreZ(false)
    render.SuppressEngineLighting(true)
    render.SetLightingOrigin(entity:GetPos())
    render.ResetModelLighting(0.85, 0.85, 0.85)
    for index = 0, 6 do
        render.SetModelLighting(index, 1, 1, 1)
    end

    entity:DrawModel()
    render.SuppressEngineLighting(false)
    render.ResetModelLighting(1, 1, 1)
end

function PANEL:RefreshWorldModel(reveal, playSelectionSound)
    local modelData = self:GetSelectedModel()
    if not modelData then return end
    local modelPath = normalizeModelPath(modelData.model)
    if modelPath == "" then
        notifyError("The selected species has no preview model configured.")
        return
    end

    local hadEntity = IsValid(self.worldEntity)
    if hadEntity then self.worldEntity:Remove() end
    util.PrecacheModel(modelPath)
    self.worldEntity = ClientsideModel(modelPath, RENDERGROUP_OPAQUE)
    if not IsValid(self.worldEntity) then
        notifyError("Unable to create preview model: " .. modelPath)
        return
    end

    self.worldEntity:SetNoDraw(false)
    self.worldEntity:DrawShadow(false)
    self.worldEntity:SetRenderMode(RENDERMODE_NORMAL)
    self.worldEntity:SetColor(color_white)
    self.worldEntity.liaSpeciesCreatorPreview = true
    self.worldEntity.RenderOverride = function(entity)
        if not IsValid(self) then return end
        self:DrawWorldPreviewEntity(entity)
    end

    self:ApplyModelAppearance(self.worldEntity, true)
    self:ApplyWorldModelScale(false)
    self:AlignWorldModelToGround()
    if not hadEntity then
        self:TransitionCamera("selection", 0)
    else
        self:RefreshCameraTarget(self.inCreation and "creation" or "selection")
    end

    if reveal then
        self:PlayRevealAnimation()
    else
        self:PlayIdleAnimation()
    end

    if playSelectionSound then self:PlaySpeciesSelectionSound(self:GetSelectedSpecies()) end
end

function PANEL:AlignWorldModelToGround()
    if not IsValid(self.worldEntity) then return end
    self.worldEntity:SetAngles(self.worldModelAngle or angle_zero)
    local mins = self:GetScaledWorldModelBounds()
    if not mins then return end
    local base = self.worldGround or LocalPlayer():GetPos()
    self.worldEntity:SetPos(base - Vector(0, 0, mins.z))
    self.worldEntity:InvalidateBoneCache()
    self.worldEntity:SetupBones()
end

function PANEL:FindWorldGround(client, forward)
    local desired = client:GetPos() + forward * 150
    local forwardTrace = util.TraceHull({
        start = client:EyePos(),
        endpos = desired + Vector(0, 0, 52),
        mins = Vector(-18, -18, -18),
        maxs = Vector(18, 18, 18),
        filter = client,
        mask = MASK_SOLID_BRUSHONLY
    })

    if forwardTrace.Hit then desired = forwardTrace.HitPos - forward * 42 end
    local groundTrace = util.TraceLine({
        start = desired + Vector(0, 0, 128),
        endpos = desired - Vector(0, 0, 512),
        filter = client,
        mask = MASK_SOLID_BRUSHONLY
    })
    return groundTrace.Hit and groundTrace.HitPos or desired
end

function PANEL:HideWorldEntities()
    self.hiddenEntities = self.hiddenEntities or {}
    local world = game.GetWorld()
    for _, entity in ipairs(ents.GetAll()) do
        if IsValid(entity) and entity ~= world and entity ~= self.worldEntity then
            if self.hiddenEntities[entity] == nil then self.hiddenEntities[entity] = entity:GetNoDraw() end
            entity:SetNoDraw(true)
        end
    end
end

function PANEL:RestoreWorldEntities()
    for entity, noDraw in pairs(self.hiddenEntities or {}) do
        if IsValid(entity) then entity:SetNoDraw(noDraw == true) end
    end

    self.hiddenEntities = nil
end

function PANEL:IsControlVisible(control)
    if not IsValid(control) then return false end
    local panel = control
    while IsValid(panel) do
        if not panel:IsVisible() then return false end
        if panel == self.inputWindow then break end
        panel = panel:GetParent()
    end
    return true
end

function PANEL:IsPointInsideControl(control, screenX, screenY)
    if not self:IsControlVisible(control) or not control:IsEnabled() then return false end
    local x, y = control:LocalToScreen(0, 0)
    return screenX >= x and screenY >= y and screenX < x + control:GetWide() and screenY < y + control:GetTall()
end

function PANEL:GetCreationInputControls()
    local controls = {}
    local function add(control, kind)
        if IsValid(control) then
            controls[#controls + 1] = {
                panel = control,
                kind = kind
            }
        end
    end

    add(self.closeButton, "button")
    add(self.creationBackButton, "button")
    add(self.creationNextButton, "button")
    for _, button in ipairs(self.tabButtons or {}) do
        add(button, "button")
    end

    local page = self.tabPages and self.tabPages[self.currentCreationTab]
    if not IsValid(page) then return controls end
    if self.currentCreationTab == 1 then
        for _, button in ipairs(page.sexButtons or {}) do
            add(button, "button")
        end

        for _, button in ipairs(page.modelButtons or {}) do
            add(button, "button")
        end
    elseif self.currentCreationTab == 2 then
        add(self.skinCombo, "combo")
        add(self.heightSlider, "slider")
        add(self.eyeColorCombo, "combo")
        add(self.hairColorCombo, "combo")
        for _, combo in ipairs(page.bodygroupCombos or {}) do
            add(combo, "combo")
        end
    elseif self.currentCreationTab == 3 then
        add(self.nameEntry, "entry")
        add(self.descEntry, "entry")
        add(self.pronounsCombo, "combo")
        add(self.birthMonthCombo, "combo")
        add(self.birthYearCombo, "combo")
        add(self.generationCombo, "combo")
    elseif self.currentCreationTab == 4 then
        for _, button in ipairs(self.attributeButtons or {}) do
            add(button, "button")
        end
    elseif self.currentCreationTab == 5 then
        for _, button in ipairs(self.traitButtons or {}) do
            add(button, "button")
        end
    elseif self.currentCreationTab == 6 then
        for _, button in ipairs(self.languageButtons or {}) do
            add(button, "button")
        end
    elseif self.currentCreationTab == 7 then
        for _, button in ipairs(self.kitButtons or {}) do
            add(button, "button")
        end

        add(self.outfitCombo, "combo")
    end
    return controls
end

function PANEL:DispatchFallbackClick(pressedPanel, mouseCode)
    if not self.inCreation or mouseCode ~= MOUSE_LEFT then return end
    if IsValid(activeComboMenu) then return end
    local screenX, screenY = gui.MousePos()
    if screenX < 0 or screenY < 0 then return end
    local controls = self:GetCreationInputControls()
    for index = #controls, 1, -1 do
        local data = controls[index]
        local control = data.panel
        if self:IsPointInsideControl(control, screenX, screenY) then
            if pressedPanel == control or IsValid(pressedPanel) and control:IsOurChild(pressedPanel) then return end
            if data.kind == "entry" then
                control:RequestFocus()
                control:SetCaretPos(#control:GetValue())
            elseif data.kind == "combo" then
                control:RequestFocus()
                if isfunction(control.DoClick) then control:DoClick() end
            elseif data.kind == "slider" and isfunction(control.UpdateSliderByCursorPos) then
                local localX = control:ScreenToLocal(screenX, screenY)
                control:UpdateSliderByCursorPos(localX)
            elseif isfunction(control.DoClick) then
                control:DoClick()
            end
            return
        end
    end
end

function PANEL:SetupInputFallback()
    hook.Add("VGUIMousePressed", self.hookID .. "Input", function(panel, mouseCode) if IsValid(self) then self:DispatchFallbackClick(panel, mouseCode) end end)
end

function PANEL:SetupWorldScene()
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local flatAngle = Angle(0, client:EyeAngles().y, 0)
    self.worldForward = flatAngle:Forward()
    self.worldRight = flatAngle:Right()
    self.worldGround = self:FindWorldGround(client, self.worldForward)
    self.worldModelAngle = Angle(0, flatAngle.y + 180, 0)
    self.hiddenEntities = {}
    self:HideWorldEntities()
    hook.Add("CalcView", self.hookID, function()
        if not IsValid(self) or not self.cameraToOrigin or not self.cameraToLook then return end
        local duration = math.max(self.cameraDuration or 0, 0.001)
        local fraction = math.Clamp((CurTime() - (self.cameraStartTime or CurTime())) / duration, 0, 1)
        fraction = fraction * fraction * (3 - 2 * fraction)
        local origin = LerpVector(fraction, self.cameraFromOrigin or self.cameraToOrigin, self.cameraToOrigin)
        local look = LerpVector(fraction, self.cameraFromLook or self.cameraToLook, self.cameraToLook)
        local fov = Lerp(fraction, self.cameraFromFOV or self.cameraToFOV, self.cameraToFOV)
        self.cameraCurrentOrigin = origin
        self.cameraCurrentLook = look
        self.cameraCurrentFOV = fov
        return {
            origin = origin,
            angles = (look - origin):Angle(),
            fov = fov,
            znear = 1,
            zfar = 4096,
            drawviewer = false
        }
    end)

    hook.Add("ShouldDrawLocalPlayer", self.hookID, function() if IsValid(self) then return false end end)
    hook.Add("PrePlayerDraw", self.hookID, function() if IsValid(self) then return true end end)
    hook.Add("HUDShouldDraw", self.hookID, function(name)
        if not IsValid(self) then return end
        if name == "CHudChat" then return true end
        return false
    end)

    hook.Add("PreDrawViewModel", self.hookID, function() if IsValid(self) then return true end end)
    hook.Add("PreDrawPlayerHands", self.hookID, function() if IsValid(self) then return true end end)
    hook.Add("PreDrawEffects", self.hookID, function() if IsValid(self) then return true end end)
    hook.Add("PostDrawOpaqueRenderables", self.hookID, function(drawingDepth, drawingSkybox)
        if drawingDepth or drawingSkybox or not IsValid(self) or not IsValid(self.worldEntity) then return end
        if self.worldEntityDrawnFrame == FrameNumber() then return end
        self:DrawWorldPreviewEntity(self.worldEntity)
    end)
end

function PANEL:GetPreviewHeadPosition()
    local entity = self.worldEntity
    if not IsValid(entity) then return nil end
    entity:SetupBones()
    local attachmentIndex = entity:LookupAttachment("eyes")
    if attachmentIndex and attachmentIndex > 0 then
        local attachment = entity:GetAttachment(attachmentIndex)
        if attachment and attachment.Pos then return attachment.Pos end
    end

    local boneNames = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Head", "Bip01 Head", "Head"}
    for _, boneName in ipairs(boneNames) do
        local boneIndex = entity:LookupBone(boneName)
        if boneIndex then
            local position = entity:GetBonePosition(boneIndex)
            if position then return position end
        end
    end

    local mins, maxs = self:GetScaledWorldModelBounds()
    if not mins or not maxs then return entity:GetPos() + Vector(0, 0, 64) end
    local height = math.max(maxs.z - mins.z, 48)
    return entity:GetPos() + Vector(0, 0, mins.z + height * 0.82)
end

function PANEL:GetCameraPreset(mode)
    local entity = self.worldEntity
    if not IsValid(entity) then return nil end
    entity:SetupBones()
    local mins, maxs = self:GetScaledWorldModelBounds()
    if not mins or not maxs then return nil end
    local height = math.max(maxs.z - mins.z, 48)
    local base = entity:GetPos()
    if mode == "appearance" then
        local center = base + Vector(0, 0, mins.z + height * 0.52)
        local horizontalOffset = height * 0.18
        local look = center + self.worldRight * (height * 0.48 + horizontalOffset)
        local origin = center - self.worldForward * math.max(height * 1.72, 132) + self.worldRight * (8 + horizontalOffset) + Vector(0, 0, height * 0.13)
        return origin, look, 48
    elseif mode == "creation" then
        local head = self:GetPreviewHeadPosition() or base + Vector(0, 0, mins.z + height * 0.82)
        local distance = math.Clamp(height * 0.58, 38, 54)
        local look = head + self.worldRight * height * 0.11 - Vector(0, 0, height * 0.012)
        local origin = head - self.worldForward * distance - self.worldRight * height * 0.025 + Vector(0, 0, height * 0.008)
        return origin, look, 28
    elseif mode == "summary" then
        local head = self:GetPreviewHeadPosition() or base + Vector(0, 0, mins.z + height * 0.82)
        local horizontalOffset = height * 0.12
        local look = head + self.worldRight * (height * 0.14 + horizontalOffset) - Vector(0, 0, height * 0.14)
        local origin = look - self.worldForward * math.Clamp(height * 0.92, 68, 90) - self.worldRight * height * 0.015 + Vector(0, 0, height * 0.04)
        return origin, look, 32
    end

    local center = base + Vector(0, 0, mins.z + height * 0.52)
    local look = center + self.worldRight * height * 0.48
    local origin = center - self.worldForward * math.max(height * 1.72, 132) + self.worldRight * 8 + Vector(0, 0, height * 0.13)
    return origin, look, 48
end

function PANEL:RefreshCameraTarget(mode)
    local origin, look, fov = self:GetCameraPreset(mode)
    if not origin then return end
    self.cameraFromOrigin = origin
    self.cameraFromLook = look
    self.cameraFromFOV = fov
    self.cameraToOrigin = origin
    self.cameraToLook = look
    self.cameraToFOV = fov
    self.cameraCurrentOrigin = origin
    self.cameraCurrentLook = look
    self.cameraCurrentFOV = fov
    self.cameraStartTime = CurTime()
    self.cameraDuration = 0
end

function PANEL:TransitionCamera(mode, duration)
    local origin, look, fov = self:GetCameraPreset(mode)
    if not origin then return end
    self.cameraFromOrigin = self.cameraCurrentOrigin or origin
    self.cameraFromLook = self.cameraCurrentLook or look
    self.cameraFromFOV = self.cameraCurrentFOV or fov
    self.cameraToOrigin = origin
    self.cameraToLook = look
    self.cameraToFOV = fov
    self.cameraStartTime = CurTime()
    self.cameraDuration = duration or 0.8
    if self.cameraDuration <= 0 then
        self.cameraCurrentOrigin = origin
        self.cameraCurrentLook = look
        self.cameraCurrentFOV = fov
    end
end

function PANEL:UpdateHeadTracking()
    local entity = self.worldEntity
    if not IsValid(entity) then return end
    local yaw = 0
    local pitch = 0
    if self.inCreation then
        local mouseX, mouseY = gui.MousePos()
        if mouseX >= 0 and mouseY >= 0 then
            yaw = math.Clamp((mouseX / ScrW() - 0.35) * 70, -35, 35)
            pitch = math.Clamp((0.48 - mouseY / ScrH()) * 55, -20, 20)
        end
    end

    entity:SetPoseParameter("head_yaw", yaw)
    entity:SetPoseParameter("head_pitch", pitch)
    entity:SetPoseParameter("aim_yaw", yaw * 0.35)
    entity:SetPoseParameter("aim_pitch", pitch * 0.35)
    entity:InvalidateBoneCache()
end

function PANEL:BuildCreationData()
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    local selectedModel = self:GetSelectedModel()
    local traits = {}
    local languages = {}
    local kitItems = {}
    for _, trait in ipairs(self:GetSelectedTraits()) do
        traits[#traits + 1] = trait.id
    end

    for _, language in ipairs(self:GetSelectedLanguages()) do
        languages[#languages + 1] = language.id
    end

    for _, item in ipairs(self:GetSelectedKitItems()) do
        kitItems[#kitItems + 1] = item.id
    end

    local data = {
        species = species and species.id or nil,
        origin = origin and origin.id or nil,
        sex = self.selectedSexID,
        height = self.selectedHeight,
        eyeColor = self:GetModelEyeColor(),
        hairColor = self:GetModelHairColor(),
        skin = math.max(math.floor(tonumber(self.selectedSkin) or 0), 0),
        bodygroups = copyValue(self.selectedBodygroups) or {},
        pronouns = self.selectedPronouns,
        attributes = self:GetSelectedAttributes(),
        traits = traits,
        languages = languages,
        startingKit = kitItems,
        startingOutfit = self.selectedOutfitID,
        model = selectedModel and selectedModel.model or nil
    }

    if species and species.profile.birthMode == "generation" then
        data.generation = self.selectedGeneration
    else
        data.birthDate = {
            month = self.selectedBirthMonth,
            year = self.selectedBirthYear
        }
    end
    return data
end

function PANEL:BuildPayload()
    local valid, message = self:ValidateTab(#tabDefinitions)
    if not valid then return nil, message end
    local species = self:GetSelectedSpecies()
    local origin = self:GetSelectedOrigin()
    local model = self:GetSelectedCreationModel()
    if not species or not origin or not model then return nil, "Character creation data is incomplete." end
    local faction = species.creationFaction or species.faction or module:GetCreationFaction(LocalPlayer(), species)
    if not faction then return nil, "No character creation faction is configured in the schema." end
    local payload = {}
    for key, variable in pairs(lia.char.vars or {}) do
        payload[key] = copyValue(variable.default)
    end

    payload.name = string.Trim(self.nameEntry:GetValue() or "")
    payload.desc = string.Trim(self.descEntry:GetValue() or "")
    payload.faction = faction.index
    payload.model = model.previewOnly and model.model or model.key
    payload.skin = math.max(math.floor(tonumber(self.selectedSkin) or 0), 0)
    payload.bodygroups = copyValue(self.selectedBodygroups) or {}
    local data = self:BuildCreationData()
    local variableMap = {
        [module.SpeciesVariable or "species"] = data.species,
        [module.OriginVariable or "origin"] = data.origin,
        [module.SexVariable or "sex"] = data.sex,
        [module.HeightVariable or "height"] = data.height,
        [module.EyeColorVariable or "eyeColor"] = data.eyeColor,
        [module.HairColorVariable or "hairColor"] = data.hairColor,
        [module.PronounsVariable or "pronouns"] = data.pronouns,
        [module.AttributesVariable or "attributes"] = data.attributes,
        [module.TraitsVariable or "traits"] = data.traits,
        [module.LanguagesVariable or "languages"] = data.languages,
        [module.StartingKitVariable or "startingKit"] = data.startingKit,
        [module.OutfitVariable or "startingOutfit"] = data.startingOutfit
    }

    if data.birthDate then variableMap[module.BirthDateVariable or "birthDate"] = data.birthDate end
    if data.generation then variableMap[module.GenerationVariable or "generation"] = data.generation end
    for variable, value in pairs(variableMap) do
        if lia.char.vars and lia.char.vars[variable] then payload[variable] = copyValue(value) end
    end

    hook.Run("SpeciesCreatorBuildPayload", payload, species, origin, data)
    return payload, nil, data
end

function PANEL:SetCreating(state)
    self.creating = state
    self.closeButton:SetEnabled(not state)
    self.creationBackButton:SetEnabled(not state)
    self.creationNextButton:SetEnabled(not state)
    for _, button in ipairs(self.tabButtons) do
        button:SetEnabled(not state)
    end
end

function PANEL:CreateCharacter()
    if self.creating then return end
    local payload, errorMessage, creationData = self:BuildPayload()
    if not payload then
        notifyError(errorMessage)
        return
    end

    local maxCharacters = hook.Run("GetMaxPlayerChar", LocalPlayer()) or lia.config.get("MaxCharacters", 5)
    if lia.characters and #lia.characters >= maxCharacters then
        notifyError("maxCharactersReached")
        return
    end

    local mainMenu = lia.module.get("mainmenu")
    if not mainMenu or not isfunction(mainMenu.CreateCharacter) then
        notifyError("The main menu character API is unavailable.")
        return
    end

    self:SetCreating(true)
    mainMenu:CreateCharacter(payload):next(function(characterID)
        hook.Run("SpeciesCreatorCharacterCreated", characterID, creationData, self:GetSelectedSpecies(), self:GetSelectedOrigin())
        if not IsValid(self) then return end
        local client = LocalPlayer()
        if IsValid(client) and not client:getChar() and isfunction(mainMenu.ChooseCharacter) then
            mainMenu:ChooseCharacter(characterID):next(function()
                if IsValid(self) then self:Remove() end
                hook.Run("ResetCharacterPanel")
            end):catch(function(err)
                if IsValid(self) then self:SetCreating(false) end
                notifyError(err)
            end)
        else
            notifyInfo("Character created successfully.")
            self:Remove()
        end
    end):catch(function(err)
        if IsValid(self) then self:SetCreating(false) end
        notifyError(err)
    end)
end

function PANEL:LayoutSelection(w, h)
    local sidebarGap = 14
    local themeWidth = math.Clamp(math.floor(w * 0.2), 190, 240)
    local contentX = themeWidth + sidebarGap
    local contentW = w - contentX
    self.selectionThemeSidebar:SetPos(0, 0)
    self.selectionThemeSidebar:SetSize(themeWidth, h - 58)
    self.selectionThemeScroll:SetPos(10, 74)
    self.selectionThemeScroll:SetSize(themeWidth - 20, self.selectionThemeSidebar:GetTall() - 84)
    for index, button in ipairs(self.selectionThemeButtons or {}) do
        button:SetPos(0, (index - 1) * 46)
        button:SetSize(self.selectionThemeScroll:GetWide() - 10, 40)
    end

    local selectionThemeCanvas = self.selectionThemeScroll:GetCanvas()
    if IsValid(selectionThemeCanvas) then selectionThemeCanvas:SetTall(math.max(#(self.selectionThemeButtons or {}) * 46 - 6, 1)) end
    self.selectionTitle:SetPos(contentX, 0)
    self.selectionTitle:SetSize(contentW, 42)
    self.speciesCards:SetPos(contentX, 58)
    self.speciesCards:SetSize(contentW, 166)
    local count = math.max(#self.speciesButtons, 1)
    local gap = 10
    local cardWidth = math.floor((contentW - gap * (count - 1)) / count)
    for index, button in ipairs(self.speciesButtons) do
        button:SetPos((index - 1) * (cardWidth + gap), 0)
        button:SetSize(cardWidth, self.speciesCards:GetTall())
    end

    self.speciesInfo:SetPos(contentX, 238)
    self.speciesInfo:SetSize(contentW, 112)
    self.speciesNameLabel:SetPos(18, 8)
    self.speciesNameLabel:SetSize(contentW - 36, 36)
    self.speciesDescriptionLabel:SetPos(18, 48)
    self.speciesDescriptionLabel:SetSize(contentW - 36, 54)
    self.originPanel:SetPos(contentX, 364)
    self.originPanel:SetSize(contentW, h - 422)
    self.originList:SetPos(14, 48)
    self.originList:SetSize(contentW - 28, math.Clamp(math.floor((h - 422) * 0.56), 120, 154))
    self.originDetails:SetPos(14, self.originList:GetY() + self.originList:GetTall() + 10)
    self.originDetails:SetSize(contentW - 28, math.max(self.originPanel:GetTall() - self.originList:GetY() - self.originList:GetTall() - 24, 66))
    local nameWidth = math.Clamp(math.floor(self.originDetails:GetWide() * 0.33), 150, 230)
    self.originNameLabel:SetPos(16, 10)
    self.originNameLabel:SetSize(nameWidth, self.originDetails:GetTall() - 20)
    self.originDescriptionLabel:SetPos(nameWidth + 28, 10)
    self.originDescriptionLabel:SetSize(self.originDetails:GetWide() - nameWidth - 44, self.originDetails:GetTall() - 20)
    self.continueButton:SetSize(180, 44)
    self.continueButton:SetPos(w - 180, h - 44)
end

function PANEL:LayoutCreation(w, h)
    self.creationHeader:SetPos(0, 0)
    self.creationHeader:SetSize(w, 58)
    local sidebarGap = 14
    local themeWidth = math.Clamp(math.floor(w * 0.19), 180, 230)
    local navWidth = math.Clamp(math.floor(w * 0.18), 180, 230)
    self.themeSidebar:SetPos(0, 74)
    self.themeSidebar:SetSize(themeWidth, h - 136)
    self.themeScroll:SetPos(10, 72)
    self.themeScroll:SetSize(themeWidth - 20, self.themeSidebar:GetTall() - 82)
    for index, button in ipairs(self.themeButtons or {}) do
        button:SetPos(0, (index - 1) * 56)
        button:SetSize(self.themeScroll:GetWide() - 10, 48)
    end

    local themeCanvas = self.themeScroll:GetCanvas()
    if IsValid(themeCanvas) then themeCanvas:SetTall(math.max(#(self.themeButtons or {}) * 56 - 8, 1)) end
    self.tabNavigation:SetPos(themeWidth + sidebarGap, 74)
    self.tabNavigation:SetSize(navWidth, h - 136)
    local gap = 10
    local tabHeight = math.floor((self.tabNavigation:GetTall() - 24 - gap * (#self.tabButtons - 1)) / #self.tabButtons)
    for index, button in ipairs(self.tabButtons) do
        button:SetPos(12, 12 + (index - 1) * (tabHeight + gap))
        button:SetSize(navWidth - 24, tabHeight)
    end

    self.stage:SetPos(themeWidth + navWidth + sidebarGap * 2, 74)
    self.stage:SetSize(w - themeWidth - navWidth - sidebarGap * 2, h - 136)
    for _, page in ipairs(self.tabPages) do
        page:SetPos(16, 14)
        page:SetSize(self.stage:GetWide() - 32, self.stage:GetTall() - 28)
    end

    self.creationBackButton:SetPos(0, h - 46)
    self.creationBackButton:SetSize(120, 46)
    self.creationNextButton:SetPos(w - 210, h - 46)
    self.creationNextButton:SetSize(210, 46)
    self:LayoutModelTab(self.tabPages[1])
    self:LayoutAppearanceTab(self.tabPages[2])
    self:LayoutInformationTab(self.tabPages[3])
    self:LayoutAttributesTab(self.tabPages[4])
    self:LayoutTraitsTab(self.tabPages[5])
    self:LayoutLanguagesTab(self.tabPages[6])
    self:LayoutKitTab(self.tabPages[7])
    self:LayoutSummaryTab(self.tabPages[8])
end

function PANEL:LayoutModelTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    page.sexPanel:SetPos(0, 76)
    page.sexPanel:SetSize(w, 92)
    local sexes = page.sexButtons or {}
    local gap = 8
    local width = math.floor((w - 28 - gap * math.max(#sexes - 1, 0)) / math.max(#sexes, 1))
    for index, button in ipairs(sexes) do
        button:SetPos(14 + (index - 1) * (width + gap), 38)
        button:SetSize(width, 42)
    end

    page.modelScroller:SetPos(0, 182)
    page.modelScroller:SetSize(w, math.max(h - 182, 170))
    self:LayoutModelCards(page)
end

function PANEL:LayoutAppearanceTab(page)
    if not IsValid(page) or not IsValid(page.appearanceScroll) then return end
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    page.appearanceScroll:SetPos(0, 76)
    page.appearanceScroll:SetSize(w, math.max(h - 76, 1))
    local canvas = page.appearanceCanvas or page.appearanceScroll:GetCanvas()
    if not IsValid(canvas) then return end
    local vbar = page.appearanceScroll:GetVBar()
    local contentWidth = math.max(w - (IsValid(vbar) and vbar:GetWide() or 0) - 2, 1)
    local gap = 10
    local fieldHeight = 82
    local fieldWidth = math.floor((contentWidth - gap) * 0.5)
    self.skinWrap:SetPos(0, 0)
    self.skinWrap:SetSize(fieldWidth, fieldHeight)
    self.heightWrap:SetPos(fieldWidth + gap, 0)
    self.heightWrap:SetSize(contentWidth - fieldWidth - gap, fieldHeight)
    local colorsY = fieldHeight + 12
    local colorsHeight = 128
    page.colorsSection:SetPos(0, colorsY)
    page.colorsSection:SetSize(contentWidth, colorsHeight)
    local colorWidth = math.floor((contentWidth - 34) * 0.5)
    self.eyeColorWrap:SetPos(12, 38)
    self.eyeColorWrap:SetSize(colorWidth, 78)
    self.hairColorWrap:SetPos(22 + colorWidth, 38)
    self.hairColorWrap:SetSize(contentWidth - colorWidth - 34, 78)
    local sectionY = colorsY + colorsHeight + 12
    local controls = page.bodygroupControls or {}
    local columns = contentWidth >= 700 and 2 or 1
    local controlGap = 10
    local controlHeight = 78
    local innerWidth = contentWidth - 24
    local controlWidth = math.floor((innerWidth - controlGap * (columns - 1)) / columns)
    local rows = math.ceil(#controls / columns)
    local sectionHeight = #controls == 0 and 72 or 48 + rows * controlHeight + math.max(rows - 1, 0) * controlGap + 12
    page.bodygroupsSection:SetPos(0, sectionY)
    page.bodygroupsSection:SetSize(contentWidth, sectionHeight)
    for index, control in ipairs(controls) do
        local column = (index - 1) % columns
        local row = math.floor((index - 1) / columns)
        control:SetPos(12 + column * (controlWidth + controlGap), 38 + row * (controlHeight + controlGap))
        control:SetSize(controlWidth, controlHeight)
    end

    canvas:SetTall(sectionY + sectionHeight)
end

function PANEL:LayoutInformationTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    local half = math.floor((w - 10) * 0.5)
    self.nameWrap:SetPos(0, 76)
    self.nameWrap:SetSize(w, 82)
    self.pronounsWrap:SetPos(0, 168)
    self.pronounsWrap:SetSize(half, 82)
    local generationMode = self:GetSelectedSpecies() and self:GetSelectedSpecies().profile.birthMode == "generation"
    if generationMode then
        self.generationWrap:SetPos(half + 10, 168)
        self.generationWrap:SetSize(w - half - 10, 82)
    else
        local quarter = math.floor((w - half - 20) * 0.5)
        self.birthMonthWrap:SetPos(half + 10, 168)
        self.birthMonthWrap:SetSize(quarter, 82)
        self.birthYearWrap:SetPos(half + 20 + quarter, 168)
        self.birthYearWrap:SetSize(w - half - 20 - quarter, 82)
    end

    self.descWrap:SetPos(0, 260)
    self.descWrap:SetSize(w, math.max(h - 260, 120))
end

function PANEL:LayoutAttributesTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    self.attributeSummaryPanel:SetPos(0, 76)
    self.attributeSummaryPanel:SetSize(w, 66)
    self.attributePanel:SetPos(0, 154)
    self.attributePanel:SetSize(w, math.Clamp(h - 154, 210, 280))
    self.attributePanel:InvalidateLayout(true)
end

function PANEL:LayoutTraitsTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    local gap = 10
    local pointsHeight = 58
    local contentY = 76 + pointsHeight + 12
    local contentHeight = math.max(h - contentY, 1)
    local pointsWidth = math.Clamp(math.floor(w * 0.42), 220, w)
    local availableWidth = math.max(math.floor((w - gap * 2) * 0.31), 1)
    local claimedWidth = math.max(w - availableWidth * 2 - gap * 2, 1)
    local claimedHeight = math.max(math.floor((contentHeight - gap) * 0.5), 1)
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    self.traitPointsPanel:SetPos(math.floor((w - pointsWidth) * 0.5), 76)
    self.traitPointsPanel:SetSize(pointsWidth, pointsHeight)
    self.traitPositivePanel:SetPos(0, contentY)
    self.traitPositivePanel:SetSize(availableWidth, contentHeight)
    self.traitNegativePanel:SetPos(availableWidth + gap, contentY)
    self.traitNegativePanel:SetSize(availableWidth, contentHeight)
    self.traitClaimedPositivePanel:SetPos(availableWidth * 2 + gap * 2, contentY)
    self.traitClaimedPositivePanel:SetSize(claimedWidth, claimedHeight)
    self.traitClaimedNegativePanel:SetPos(availableWidth * 2 + gap * 2, contentY + claimedHeight + gap)
    self.traitClaimedNegativePanel:SetSize(claimedWidth, math.max(contentHeight - claimedHeight - gap, 1))
end

function PANEL:LayoutLanguagesTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    self.languageStatusPanel:SetPos(0, 76)
    self.languageStatusPanel:SetSize(w, 78)
    self.languageScroll:SetPos(0, 166)
    self.languageScroll:SetSize(w, math.max(h - 166, 120))
end

function PANEL:LayoutKitTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    self.kitStatusPanel:SetPos(0, 76)
    self.kitStatusPanel:SetSize(w, 66)
    self.kitScroll:SetPos(0, 154)
    self.kitScroll:SetSize(w, math.max(h - 252, 150))
    self.outfitPanel:SetPos(0, h - 86)
    self.outfitPanel:SetSize(w, 86)
    self.outfitCombo:SetPos(12, 34)
    self.outfitCombo:SetSize(w - 24, 40)
end

function PANEL:LayoutSummaryTab(page)
    local w = page:GetWide()
    local h = page:GetTall()
    page.title:SetPos(0, 0)
    page.title:SetSize(w, 36)
    page.subtitle:SetPos(0, 38)
    page.subtitle:SetSize(w, 24)
    self.summaryScroll:SetPos(0, 76)
    self.summaryScroll:SetSize(w, math.max(h - 76, 1))
    local canvas = self.summaryScroll:GetCanvas()
    local viewportHeight = self.summaryScroll:GetTall()
    local viewportWidth = self.summaryScroll:GetWide()
    local canvasWidth = math.max(viewportWidth, 1)
    local canvasHeight = self:GetSummaryCanvasHeight(viewportHeight, canvasWidth)
    if canvasHeight > viewportHeight then
        canvasWidth = math.max(viewportWidth - 12, 1)
        canvasHeight = self:GetSummaryCanvasHeight(viewportHeight, canvasWidth)
    end

    canvas:SetSize(canvasWidth, canvasHeight)
    self.summaryCanvas:SetPos(0, 0)
    self.summaryCanvas:SetSize(canvasWidth, canvasHeight)
    self.summaryScroll:InvalidateLayout(true)
end

function PANEL:PerformLayout()
    if IsValid(self.inputWindow) then
        self.inputWindow:SetPos(0, 0)
        self.inputWindow:SetSize(ScrW(), ScrH())
    end

    local widthFraction = self.inCreation and 0.6 or 0.44
    local maximumPaperWidth = math.max(ScrW() - 48, 620)
    local configuredMaximum = self.inCreation and 1280 or 900
    local paperMaximum = math.min(configuredMaximum, maximumPaperWidth)
    local configuredMinimum = self.inCreation and 880 or 620
    local paperMinimum = math.min(configuredMinimum, paperMaximum)
    local paperWidth = math.Clamp(math.floor(ScrW() * widthFraction), paperMinimum, paperMaximum)
    local paperHeight = math.Clamp(math.floor(ScrH() * 0.9), 680, ScrH() - 30)
    local marginRight = math.Clamp(math.floor(ScrW() * 0.03), 24, 64)
    self.paper:SetPos(ScrW() - paperWidth - marginRight, math.floor((ScrH() - paperHeight) * 0.5))
    self.paper:SetSize(paperWidth, paperHeight)
    self.closeButton:SetPos(paperWidth - 44, 10)
    self.closeButton:SetSize(32, 32)
    self.selectionPage:SetPos(22, 14)
    self.selectionPage:SetSize(paperWidth - 44, paperHeight - 28)
    self.creationPage:SetPos(22, 14)
    self.creationPage:SetSize(paperWidth - 44, paperHeight - 28)
    self:LayoutSelection(self.selectionPage:GetWide(), self.selectionPage:GetTall())
    self:LayoutCreation(self.creationPage:GetWide(), self.creationPage:GetTall())
end

function PANEL:Think()
    if IsValid(self.inputWindow) then
        self.inputWindow:SetMouseInputEnabled(true)
        self.inputWindow:SetKeyboardInputEnabled(true)
    end

    self.paper:SetMouseInputEnabled(true)
    if self.inCreation then
        self.creationPage:SetMouseInputEnabled(true)
        self.creationPage:SetKeyboardInputEnabled(true)
        self.stage:SetMouseInputEnabled(true)
        self.stage:SetKeyboardInputEnabled(true)
        local activePage = self.tabPages and self.tabPages[self.currentCreationTab]
        if IsValid(activePage) then
            activePage:SetMouseInputEnabled(true)
            activePage:SetKeyboardInputEnabled(true)
        end
    else
        self.selectionPage:SetMouseInputEnabled(true)
    end

    if self.inCreation and CurTime() >= (self.nextInputRefresh or 0) then
        self.nextInputRefresh = CurTime() + 0.25
        self:EnableCreationInput()
    end

    if CurTime() >= (self.nextEntityHide or 0) then
        self.nextEntityHide = CurTime() + 0.15
        self:HideWorldEntities()
    end

    if IsValid(self.worldEntity) then
        self.worldEntity:SetNoDraw(false)
        self.worldEntity:FrameAdvance(FrameTime())
        self:UpdateHeadTracking()
        if self.revealEnd and CurTime() >= self.revealEnd then
            self.revealEnd = nil
            self:PlayIdleAnimation()
        end
    end
end

function PANEL:OnKeyCodePressed(key)
    if key ~= KEY_ESCAPE or self.creating then return end
    if self.inCreation then
        self:CloseCreation()
    else
        self:Remove()
    end
end

function PANEL:OnRemove()
    if self.activeSelectionSound then
        self.activeSelectionSound:Stop()
        self.activeSelectionSound = nil
    end

    hook.Remove("VGUIMousePressed", self.hookID .. "Input")
    hook.Remove("CalcView", self.hookID)
    hook.Remove("ShouldDrawLocalPlayer", self.hookID)
    hook.Remove("PrePlayerDraw", self.hookID)
    hook.Remove("PreDrawViewModel", self.hookID)
    hook.Remove("PreDrawPlayerHands", self.hookID)
    hook.Remove("PreDrawEffects", self.hookID)
    hook.Remove("HUDShouldDraw", self.hookID)
    hook.Remove("PostDrawOpaqueRenderables", self.hookID)
    self:RestoreWorldEntities()
    if IsValid(self.worldEntity) then self.worldEntity:Remove() end
    if IsValid(self.inputWindow) then self.inputWindow:Remove() end
    if lia.gui.speciesCreator == self then lia.gui.speciesCreator = nil end
end

function PANEL:Paint(w, h)
    local appearanceActive = self.inCreation and self.currentCreationTab == 2
    if not appearanceActive and lia.util and lia.util.drawBlackBlur then lia.util.drawBlackBlur(self, 1, 4, 255, 120) end
    surface.SetDrawColor(getThemeBackgroundColor(fallbackBackground, 58))
    surface.DrawRect(0, 0, w, h)
    local accent = getThemeAccent()
    surface.SetDrawColor(accent.r, accent.g, accent.b, 135)
    surface.DrawRect(0, 0, w, 2)
    surface.DrawRect(0, h - 2, w, 2)
end

vgui.Register("liaSpeciesCreator", PANEL, "EditablePanel")
