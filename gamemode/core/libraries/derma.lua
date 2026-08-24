--[[
    Hooks:
        InteractionMenuOpened(Panel panel)

    Purpose:
        Runs after an interaction or action menu panel is created when hook emission is enabled.

    Category:
        Derma

    Parameters:
        panel (Panel)
            The menu or tooltip panel that was opened.

    Example Usage:
        ```lua
        hook.Add("InteractionMenuOpened", "liaExampleInteractionMenuOpened", function(panel)
            if not IsValid(panel) then return end
            panel:SetTooltip("InteractionMenuOpened handled by MyModule")
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        InteractionMenuClosed()

    Purpose:
        Runs when an interaction or action menu panel is removed when hook emission is enabled.

    Category:
        Derma

    Example Usage:
        ```lua
        hook.Add("InteractionMenuClosed", "liaExampleInteractionMenuClosed", function()
            print("[MyModule] handled InteractionMenuClosed")
        end)
        ```

    Realm:
        Client
]]
--[[
    Folder: Developer - Libraries
    File: lia.derma.md
]]
--[[
    Derma

    Clientside Derma helpers for Lilia menu creation, request dialogs, rounded drawing, blur, shadows, text rendering, and UI animation.
]]
--[[
    Overview:
        The derma library centralizes reusable clientside interface helpers under `lia.derma`. It provides menu builders, request windows, player selectors, table displays, rounded primitive rendering, blur and shadow drawing, text helpers, entity label rendering, and small animation/math utilities used by Lilia panels.
]]
lia.derma = lia.derma or {}
local color_disconnect = Color(210, 65, 65)
local color_bot = Color(70, 150, 220)
local color_online = Color(120, 180, 70)
local color_close = Color(210, 65, 65)
local color_accept = Color(44, 124, 62)
local color_target = Color(255, 255, 255, 200)
--[[
    Purpose:
        Opens a color picker window with saturation/value and hue controls, then passes the chosen color to a callback or passes false when cancelled.

    Parameters:
        func (function)
            Callback called with the selected Color, or false when the picker is cancelled.
        colorStandard (Color|nil)
            Optional initial color. Defaults to white.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.requestColorPicker(function(color)
            if color then panel:SetColor(color) end
        end, Color(255, 255, 255))
        ```

    Realm:
        Client
]]
function lia.derma.requestColorPicker(func, colorStandard)
    if IsValid(lia.gui.menuColorPicker) then lia.gui.menuColorPicker:Remove() end
    local selected_color = colorStandard or Color(255, 255, 255)
    local hue = 0
    local saturation = 1
    local value = 1
    if colorStandard then
        local r, g, b = colorStandard.r / 255, colorStandard.g / 255, colorStandard.b / 255
        local h, s, v = ColorToHSV(Color(r * 255, g * 255, b * 255))
        hue = h
        saturation = s
        value = v
    end

    lia.gui.menuColorPicker = vgui.Create("liaFrame")
    lia.gui.menuColorPicker:SetSize(300, 378)
    lia.gui.menuColorPicker:Center()
    lia.gui.menuColorPicker:MakePopup()
    lia.gui.menuColorPicker:SetTitle("")
    lia.gui.menuColorPicker:SetCenterTitle(L("colorPicker"))
    local container = vgui.Create("Panel", lia.gui.menuColorPicker)
    container:Dock(FILL)
    container:DockMargin(10, 10, 10, 10)
    container.Paint = nil
    local preview = vgui.Create("Panel", container)
    preview:Dock(TOP)
    preview:SetTall(40)
    preview:DockMargin(0, 0, 0, 10)
    preview.Paint = function(_, w, h)
        lia.derma.rect(2, 2, w - 4, h - 4):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.derma.SHAPE_IOS):Shadow(5, 20):Draw()
        lia.derma.rect(2, 2, w - 4, h - 4):Rad(16):Color(selected_color):Shape(lia.derma.SHAPE_IOS):Draw()
    end

    local colorField = vgui.Create("Panel", container)
    colorField:Dock(TOP)
    colorField:SetTall(200)
    colorField:DockMargin(0, 0, 0, 10)
    local colorCursor = {
        x = 0,
        y = 0
    }

    local isDraggingColor = false
    colorField.OnMousePressed = function(self, keyCode)
        if keyCode == MOUSE_LEFT then
            isDraggingColor = true
            self:OnCursorMoved(self:CursorPos())
            lia.websound.playButtonSound()
        end
    end

    colorField.OnMouseReleased = function(_, keyCode) if keyCode == MOUSE_LEFT then isDraggingColor = false end end
    colorField.OnCursorMoved = function(self, x, y)
        if isDraggingColor then
            local w, h = self:GetSize()
            x = math.Clamp(x, 0, w)
            y = math.Clamp(y, 0, h)
            colorCursor.x = x
            colorCursor.y = y
            saturation = x / w
            value = 1 - (y / h)
            selected_color = HSVToColor(hue, saturation, value)
        end
    end

    colorField.Paint = function(_, w, h)
        local segments = 80
        local segmentSize = w / segments
        lia.derma.rect(0, 0, w, h):Color(lia.color.theme.window_shadow):Shape(lia.derma.SHAPE_IOS):Shadow(5, 20):Draw()
        for x = 0, segments do
            for y = 0, segments do
                local s = x / segments
                local v = 1 - (y / segments)
                local segX = x * segmentSize
                local segY = y * segmentSize
                surface.SetDrawColor(HSVToColor(hue, s, v))
                surface.DrawRect(segX, segY, segmentSize + 1, segmentSize + 1)
            end
        end

        lia.derma.circle(colorCursor.x, colorCursor.y, 12):Outline(2):Color(color_target):Draw()
    end

    local hueSlider = vgui.Create("Panel", container)
    hueSlider:Dock(TOP)
    hueSlider:SetTall(20)
    hueSlider:DockMargin(0, 0, 0, 10)
    local huePos = 0
    local isDraggingHue = false
    hueSlider.OnMousePressed = function(self, keyCode)
        if keyCode == MOUSE_LEFT then
            isDraggingHue = true
            self:OnCursorMoved(self:CursorPos())
            lia.websound.playButtonSound()
        end
    end

    hueSlider.OnMouseReleased = function(_, keyCode) if keyCode == MOUSE_LEFT then isDraggingHue = false end end
    hueSlider.OnCursorMoved = function(self, x)
        if isDraggingHue then
            local w = self:GetWide()
            x = math.Clamp(x, 0, w)
            huePos = x
            hue = (x / w) * 360
            selected_color = HSVToColor(hue, saturation, value)
        end
    end

    hueSlider.Paint = function(_, w, h)
        local segments = 100
        local segmentWidth = w / segments
        lia.derma.rect(0, 0, w, h):Color(lia.color.theme.window_shadow):Shape(lia.derma.SHAPE_IOS):Shadow(5, 20):Draw()
        for i = 0, segments - 1 do
            local hueVal = (i / segments) * 360
            local x = i * segmentWidth
            surface.SetDrawColor(HSVToColor(hueVal, 1, 1))
            surface.DrawRect(x, 1, segmentWidth + 1, h - 2)
        end

        lia.derma.rect(huePos - 2, 0, 4, h):Color(color_target):Draw()
    end

    local rgbContainer = vgui.Create("Panel", container)
    rgbContainer:Dock(TOP)
    rgbContainer:SetTall(60)
    rgbContainer:DockMargin(0, 0, 0, 10)
    rgbContainer.Paint = nil
    local btnContainer = vgui.Create("Panel", container)
    btnContainer:Dock(BOTTOM)
    btnContainer:SetTall(30)
    btnContainer.Paint = nil
    local btnClose = vgui.Create("liaButton", btnContainer)
    btnClose:Dock(LEFT)
    btnClose:SetWide(90)
    btnClose:SetTxt(L("cancel"))
    btnClose:SetColorHover(color_close)
    btnClose.DoClick = function()
        btnClose.BaseClass.DoClick(btnClose)
        if func then func(false) end
        lia.gui.menuColorPicker:Remove()
    end

    local btnSelect = vgui.Create("liaButton", btnContainer)
    btnSelect:Dock(RIGHT)
    btnSelect:SetWide(90)
    btnSelect:SetTxt(L("select"))
    btnSelect:SetColorHover(color_accept)
    btnSelect.DoClick = function()
        btnSelect.BaseClass.DoClick(btnSelect)
        func(selected_color)
        lia.gui.menuColorPicker:Remove()
    end

    timer.Simple(0, function()
        if IsValid(colorField) and IsValid(hueSlider) then
            colorCursor.x = saturation * colorField:GetWide()
            colorCursor.y = (1 - value) * colorField:GetTall()
            huePos = (hue / 360) * hueSlider:GetWide()
        end
    end)

    timer.Simple(0.1, function() lia.gui.menuColorPicker:SetAlpha(255) end)
end

--[[
    Purpose:
        Creates a `liaRadialPanel`, initializes it with the supplied options, removes any existing tracked radial menu, and stores it in `lia.gui.menu_radial`.

    Parameters:
        options (table)
            Options passed to the radial panel initializer.

    Returns:
        Panel
            The created `liaRadialPanel`.

    Example Usage:
        ```lua
        local radial = vgui.Create("liaRadialPanel")
        ```

    Realm:
        Client
]]
function lia.derma.radialMenu(options)
    lia.gui = lia.gui or {}
    if IsValid(lia.gui.menu_radial) then lia.gui.menu_radial:Remove() end
    local m = vgui.Create("liaRadialPanel")
    lia.gui.menu_radial = m
    return m
end

--[[
    Purpose:
        Opens a player selector window that lists current players with avatar, group, ping, and bot status, then calls a callback with the chosen player.

    Parameters:
        doClick (function)
            Callback called with the selected Player.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.requestPlayerSelector(function(client)
            print(client:Name())
        end)
        ```

    Realm:
        Client
]]
function lia.derma.requestPlayerSelector(doClick)
    if IsValid(lia.gui.menuPlayerSelector) then lia.gui.menuPlayerSelector:Remove() end
    lia.gui.menuPlayerSelector = vgui.Create("liaFrame")
    lia.gui.menuPlayerSelector:SetSize(340, 398)
    lia.gui.menuPlayerSelector:Center()
    lia.gui.menuPlayerSelector:MakePopup()
    lia.gui.menuPlayerSelector:SetTitle("")
    lia.gui.menuPlayerSelector:SetCenterTitle(L("playerSelector"))
    lia.gui.menuPlayerSelector:ShowAnimation()
    local contentPanel = vgui.Create("Panel", lia.gui.menuPlayerSelector)
    contentPanel:Dock(FILL)
    contentPanel:DockMargin(8, 0, 8, 8)
    lia.gui.menuPlayerSelector.sp = vgui.Create("liaScrollPanel", contentPanel)
    lia.gui.menuPlayerSelector.sp:Dock(FILL)
    local CARD_HEIGHT = 44
    local AVATAR_SIZE = 32
    local AVATAR_X = 14
    local function CreatePlayerCard(pl)
        local card = vgui.Create("DButton", lia.gui.menuPlayerSelector.sp)
        card:Dock(TOP)
        card:DockMargin(0, 5, 0, 0)
        card:SetTall(CARD_HEIGHT)
        card:SetText("")
        card.hover_status = 0
        card.OnCursorEntered = function(self) self:SetCursor("hand") end
        card.OnCursorExited = function(self) self:SetCursor("arrow") end
        card.Think = function(self)
            if self:IsHovered() then
                self.hover_status = math.Clamp(self.hover_status + 4 * FrameTime(), 0, 1)
            else
                self.hover_status = math.Clamp(self.hover_status - 8 * FrameTime(), 0, 1)
            end
        end

        card.DoClick = function()
            if IsValid(pl) then
                card.BaseClass.DoClick(card)
                doClick(pl)
            end

            lia.gui.menuPlayerSelector:Remove()
        end

        card.Paint = function(self, w, h)
            lia.derma.rect(0, 0, w, h):Rad(10):Color(lia.color.theme.panel[1]):Shape(lia.derma.SHAPE_IOS):Draw()
            if self.hover_status > 0 then lia.derma.rect(0, 0, w, h):Rad(10):Color(Color(0, 0, 0, 40 * self.hover_status)):Shape(lia.derma.SHAPE_IOS):Draw() end
            local infoX = AVATAR_X + AVATAR_SIZE + 10
            if not IsValid(pl) then
                draw.SimpleText(L("disconnected"), "LiliaFont.18", infoX, h * 0.5, color_disconnect, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                return
            end

            draw.SimpleText(pl:Name(), "LiliaFont.18", infoX, 6, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            local group = pl:GetUserGroup() or "user"
            group = string.upper(string.sub(group, 1, 1)) .. string.sub(group, 2)
            draw.SimpleText(group, "LiliaFont.14", infoX, h - 6, lia.color.theme.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(pl:Ping() .. " " .. L("ping"), "LiliaFont.16", w - 20, h - 6, lia.color.theme.gray, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            if pl:IsBot() then
                statusColor = color_bot
            else
                statusColor = color_online
            end

            lia.derma.circle(w - 24, 14, 24):Color(statusColor):Draw()
        end

        local avatarImg = vgui.Create("AvatarImage", card)
        avatarImg:SetSize(AVATAR_SIZE, AVATAR_SIZE)
        avatarImg:SetPos(AVATAR_X, (CARD_HEIGHT - AVATAR_SIZE) * 0.5)
        avatarImg:SetPlayer(pl, 64)
        avatarImg:SetMouseInputEnabled(false)
        avatarImg:SetKeyboardInputEnabled(false)
        avatarImg.PaintOver = function() end
        avatarImg:SetPos(AVATAR_X, (card:GetTall() - AVATAR_SIZE) * 0.5)
        return card
    end

    for _, pl in player.Iterator() do
        CreatePlayerCard(pl)
    end

    lia.gui.menuPlayerSelector.btn_close = vgui.Create("liaButton", lia.gui.menuPlayerSelector)
    lia.gui.menuPlayerSelector.btn_close:Dock(BOTTOM)
    lia.gui.menuPlayerSelector.btn_close:DockMargin(16, 8, 16, 12)
    lia.gui.menuPlayerSelector.btn_close:SetTall(36)
    lia.gui.menuPlayerSelector.btn_close:SetTxt(L("close"))
    lia.gui.menuPlayerSelector.btn_close:SetColorHover(color_disconnect)
    lia.gui.menuPlayerSelector.btn_close.DoClick = function() lia.gui.menuPlayerSelector:Remove() end
end

-- RNDX is loaded by the third-party library before this file.
-- This section only adapts that library to Lilia's existing derma API.
local RNDX = lia.rndx
if not RNDX then error("Lilia RNDX library failed to load") end
lia.derma.draw = RNDX.Draw
lia.derma.drawOutlined = RNDX.DrawOutlined
lia.derma.drawTexture = RNDX.DrawTexture
lia.derma.drawMaterial = RNDX.DrawMaterial
lia.derma.drawCircle = RNDX.DrawCircle
lia.derma.drawCircleOutlined = RNDX.DrawCircleOutlined
lia.derma.drawCircleTexture = RNDX.DrawCircleTexture
lia.derma.drawCircleMaterial = RNDX.DrawCircleMaterial
lia.derma.drawBlur = RNDX.DrawBlur
lia.derma.drawShadowsEx = RNDX.DrawShadowsEx
lia.derma.drawShadows = RNDX.DrawShadows
lia.derma.drawShadowsOutlined = RNDX.DrawShadowsOutlined
lia.derma.NO_TL = RNDX.NO_TL
lia.derma.NO_TR = RNDX.NO_TR
lia.derma.NO_BL = RNDX.NO_BL
lia.derma.NO_BR = RNDX.NO_BR
lia.derma.SHAPE_CIRCLE = RNDX.SHAPE_CIRCLE
lia.derma.SHAPE_FIGMA = RNDX.SHAPE_FIGMA
lia.derma.SHAPE_IOS = RNDX.SHAPE_IOS
lia.derma.SHAPE_RECT = 0
lia.derma.BLUR = RNDX.BLUR
lia.derma.MANUAL_COLOR = RNDX.MANUAL_COLOR
function lia.derma.setFlag(flags, flag, bool)
    return RNDX.SetFlag(flags or 0, flag, bool)
end

function lia.derma.setDefaultShape(shape)
    RNDX.SetDefaultShape(shape or RNDX.SHAPE_FIGMA)
end

--[[
    Purpose:
        Draws text once as a shadow offset and once as foreground text, with vertical alignment adjustment.

    Parameters:
        text (string)
            Text to draw.
        font (string)
            Font name.
        x (number)
            Text X coordinate.
        y (number)
            Text Y coordinate.
        colortext (Color)
            Foreground text color.
        colorshadow (Color)
            Shadow text color.
        dist (number)
            Shadow offset distance.
        xalign (number)
            Horizontal alignment.
        yalign (number)
            Vertical alignment.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.shadowText("Title", "LiliaFont.20", x, y, color_white, Color(0, 0, 0, 200), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        ```

    Realm:
        Client
]]
function lia.derma.shadowText(text, font, x, y, colortext, colorshadow, dist, xalign, yalign)
    surface.SetFont(font)
    local _, h = surface.GetTextSize(text)
    if yalign == TEXT_ALIGN_CENTER then
        y = y - h / 2
    elseif yalign == TEXT_ALIGN_BOTTOM then
        y = y - h
    end

    draw.DrawText(text, font, x + dist, y + dist, colorshadow, xalign)
    draw.DrawText(text, font, x, y, colortext, xalign)
end

--[[
    Purpose:
        Draws text with an outline by drawing offset copies before the foreground text.

    Parameters:
        text (string)
            Text to draw.
        font (string)
            Font name.
        x (number)
            Text X coordinate.
        y (number)
            Text Y coordinate.
        colour (Color)
            Foreground text color.
        xalign (number)
            Horizontal alignment.
        outlinewidth (number)
            Outline width.
        outlinecolour (Color)
            Outline color.

    Returns:
        number|nil
            The width returned by `draw.DrawText`, when provided by Garry's Mod.

    Example Usage:
        ```lua
        lia.derma.drawTextOutlined("Name", "LiliaFont.18", x, y, color_white, TEXT_ALIGN_CENTER, 2, color_black)
        ```

    Realm:
        Client
]]
function lia.derma.drawTextOutlined(text, font, x, y, colour, xalign, outlinewidth, outlinecolour)
    local steps = (outlinewidth * 2) / 3
    if steps < 1 then steps = 1 end
    for ox = -outlinewidth, outlinewidth, steps do
        for oy = -outlinewidth, outlinewidth, steps do
            draw.DrawText(text, font, x + ox, y + oy, outlinecolour, xalign)
        end
    end
    return draw.DrawText(text, font, x, y, colour, xalign)
end

--[[
    Purpose:
        Draws a speech-bubble or tooltip polygon with a centered text label.

    Parameters:
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Tip width.
        h (number)
            Tip height.
        text (string)
            Text to draw inside the tip.
        font (string)
            Font name.
        textCol (Color)
            Text color.
        outlineCol (Color)
            Polygon fill or outline color.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawTip(x, y, 120, 42, L("use"), "LiliaFont.16", color_white, Color(0, 0, 0, 220))
        ```

    Realm:
        Client
]]
function lia.derma.drawTip(x, y, w, h, text, font, textCol, outlineCol)
    draw.NoTexture()
    local rectH = 0.85
    local triW = 0.1
    local verts = {
        {
            x = x,
            y = y
        },
        {
            x = x + w,
            y = y
        },
        {
            x = x + w,
            y = y + h * rectH
        },
        {
            x = x + w / 2 + w * triW,
            y = y + h * rectH
        },
        {
            x = x + w / 2,
            y = y + h
        },
        {
            x = x + w / 2 - w * triW,
            y = y + h * rectH
        },
        {
            x = x,
            y = y + h * rectH
        }
    }

    surface.SetDrawColor(outlineCol)
    surface.DrawPoly(verts)
    draw.SimpleText(text, font, x + w / 2, y + h / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

--[[
    Purpose:
        Draws text with Garry's Mod text shadow helper and default Lilia font/color fallbacks.

    Parameters:
        text (string)
            Text to draw.
        x (number)
            Text X coordinate.
        y (number)
            Text Y coordinate.
        color (Color|nil)
            Text color. Defaults to white.
        alignX (number|nil)
            Horizontal alignment. Defaults to 0.
        alignY (number|nil)
            Vertical alignment. Defaults to 0.
        font (string|nil)
            Font name. Defaults to `LiliaFont.16`.
        alpha (number|nil)
            Shadow alpha. Defaults to a fraction of the text color alpha.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawText("Hello", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, "LiliaFont.16")
        ```

    Realm:
        Client
]]
function lia.derma.drawText(text, x, y, color, alignX, alignY, font, alpha)
    color = color or Color(255, 255, 255)
    return draw.TextShadow({
        text = text,
        font = font or "LiliaFont.16",
        pos = {x, y},
        color = color,
        xalign = alignX or 0,
        yalign = alignY or 0
    }, 1, alpha or color.a * 0.575)
end

local drawBoxOverlaps = {}
local drawBoxFrame = 0
local function splitBoxTextLines(text)
    local sourceLines = istable(text) and text or {text}
    local textLines = {}
    for _, value in ipairs(sourceLines) do
        local normalized = tostring(value or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
        local startIndex = 1
        while true do
            local breakStart, breakEnd = normalized:find("\n", startIndex, true)
            if not breakStart then
                textLines[#textLines + 1] = normalized:sub(startIndex)
                break
            end

            textLines[#textLines + 1] = normalized:sub(startIndex, breakStart - 1)
            startIndex = breakEnd + 1
            if startIndex > #normalized then
                textLines[#textLines + 1] = ""
                break
            end
        end
    end

    if #textLines == 0 then textLines[1] = "" end
    return textLines
end

--[[
    Purpose:
        Draws a styled text box with optional auto-sizing, blur, shadow, border, accent border, alignment, and per-frame overlap avoidance.

    Parameters:
        text (string|table)
            Text, or a table of text lines, to render inside the box.
        x (number)
            Anchor X coordinate.
        y (number)
            Anchor Y coordinate.
        options (table|nil)
            Optional styling and layout settings such as font, colors, padding, alignment, blur, shadow, size, and border values.

    Returns:
        number, number
            The final box width and height.

    Example Usage:
        ```lua
        local boxW, boxH = lia.derma.drawBoxWithText(nil, x, y, {
            rows = {
                {
                    label = "Line one",
                    value = "Example value"
                },
                {
                    text = "Line two"
                }
            },
            textAlignX = TEXT_ALIGN_CENTER
        })
        ```

    Realm:
        Client
]]
function lia.derma.drawBoxWithText(text, x, y, options)
    options = options or {}
    local function trim(value)
        return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
    end

    local function fitTextToWidth(value, maxRowWidth, font, suffix)
        local resolved = trim(value)
        suffix = suffix or "..."
        surface.SetFont(font)
        if surface.GetTextSize(resolved) <= maxRowWidth then return resolved end
        local candidate = resolved .. suffix
        while resolved ~= "" and surface.GetTextSize(candidate) > maxRowWidth do
            resolved = trim(resolved:sub(1, -2))
            candidate = resolved .. suffix
        end
        return candidate ~= "" and candidate or suffix
    end

    local function resolveText(value)
        if value == nil then return "" end
        if isstring(value) and L then
            local ok, localized = pcall(L, value)
            if ok and localized and localized ~= "" then return tostring(localized) end
        end
        return tostring(value)
    end

    local function resolveAccent()
        local theme = lia.color and lia.color.theme or {}
        return options.accentColor or theme.accent or theme.theme or lia.config and lia.config.get and lia.config.get("Color") or Color(164, 106, 54)
    end

    local function drawBlurAt(px, py, pw, ph, blurData)
        if not blurData or blurData.enabled == false then return end
        local amount = blurData.amount or 3
        local passes = blurData.passes or 3
        local alpha = blurData.alpha or 0.9
        if lia.util and lia.util.drawBlurAt then
            lia.util.drawBlurAt(px, py, pw, ph, amount, passes, alpha)
        elseif lia.derma.drawBlurAt then
            lia.derma.drawBlurAt(px, py, pw, ph, amount, passes, alpha)
        end
    end

    local function parseDebugText(raw)
        if not isstring(raw) then return end
        if not raw:find("SteamID", 1, true) and not raw:find("FrameTime", 1, true) then return end
        local values = {}
        local loose = {}
        local normalized = raw:gsub("\r\n", "\n"):gsub("\r", "\n")
        for line in normalized:gmatch("[^\n]+") do
            for part in line:gmatch("[^|]+") do
                local item = trim(part)
                if item ~= "" then
                    local key, value = item:match("^([^:]+):%s*(.+)$")
                    if key and value then
                        values[key:lower():gsub("[^%w]", "")] = trim(value)
                    else
                        loose[#loose + 1] = item
                    end
                end
            end
        end

        local dateText, timeText
        for _, item in ipairs(loose) do
            if not dateText and item:match("^%d%d/%d%d/%d%d%d%d$") then dateText = item end
            if not timeText and item:match("^%d%d:%d%d:%d%d$") then timeText = item end
        end

        local function getValue(...)
            for _, key in ipairs({...}) do
                local value = values[key]
                if value and value ~= "" then return value end
            end
        end

        local sections = {}
        local sessionRows = {}
        local steamID64 = getValue("steamid64")
        local steamID = getValue("steamid")
        if steamID64 then
            sessionRows[#sessionRows + 1] = {
                label = "SteamID64",
                value = steamID64
            }
        end

        if steamID then
            sessionRows[#sessionRows + 1] = {
                label = "SteamID",
                value = steamID
            }
        end

        if dateText or timeText then
            sessionRows[#sessionRows + 1] = {
                label = "Date / Time",
                value = trim((dateText or "") .. " " .. (timeText or ""))
            }
        end

        if #sessionRows > 0 then
            sections[#sections + 1] = {
                rows = sessionRows
            }
        end

        local positionRows = {}
        local pos = getValue("pos")
        local ang = getValue("ang")
        local tracePos = getValue("tracepos")
        local traceDist = getValue("tracedist")
        if pos then
            positionRows[#positionRows + 1] = {
                label = "Pos",
                value = pos
            }
        end

        if ang then
            positionRows[#positionRows + 1] = {
                label = "Ang",
                value = ang
            }
        end

        if tracePos then
            positionRows[#positionRows + 1] = {
                label = "Trace Pos",
                value = tracePos
            }
        end

        if traceDist then
            positionRows[#positionRows + 1] = {
                label = "Trace Dist",
                value = traceDist
            }
        end

        if #positionRows > 0 then
            sections[#sections + 1] = {
                title = "Position",
                rows = positionRows
            }
        end

        local performanceRows = {}
        local health = getValue("health")
        local ping = getValue("ping")
        local fps = getValue("fps")
        local frameTime = getValue("frametime")
        if health then
            performanceRows[#performanceRows + 1] = {
                label = "Health",
                value = health
            }
        end

        if ping then
            performanceRows[#performanceRows + 1] = {
                label = "Ping",
                value = ping
            }
        end

        if fps then
            performanceRows[#performanceRows + 1] = {
                label = "FPS",
                value = fps
            }
        end

        if frameTime then
            performanceRows[#performanceRows + 1] = {
                label = "Frame Time",
                value = frameTime
            }
        end

        if #performanceRows > 0 then
            sections[#sections + 1] = {
                title = "Performance",
                rows = performanceRows
            }
        end

        if #sections == 0 then return end
        return {
            title = "Debug Session",
            sections = sections
        }
    end

    local debugLayout
    local structured = istable(options.sections) or istable(options.rows) or options.title ~= nil
    if not structured and options.autoFormatDebug ~= false then
        debugLayout = parseDebugText(text)
        structured = debugLayout ~= nil
    end

    if not structured then
        local font = options.font or "LiliaFont.16"
        local textColor = options.textColor or Color(255, 255, 255)
        local backgroundColor = options.backgroundColor or Color(25, 28, 35, 250)
        local borderColor = options.borderColor or lia.color.theme.theme
        local borderRadius = options.borderRadius or 12
        local borderThickness = options.borderThickness or 0
        local padding = options.padding or 20
        local blur = options.blur or {
            enabled = true,
            amount = 3,
            passes = 3,
            alpha = 0.9
        }

        local textAlignX = options.textAlignX or TEXT_ALIGN_CENTER
        local textAlignY = options.textAlignY or TEXT_ALIGN_CENTER
        local autoSize = options.autoSize ~= false
        local lineSpacing = options.lineSpacing or 4
        local overlapMargin = options.overlapMargin or 8
        local textLines = splitBoxTextLines(text)
        surface.SetFont(font)
        local _, defaultLineHeight = surface.GetTextSize("W")
        local maxWidth, totalHeight = 0, 0
        local lineHeights = {}
        for i, line in ipairs(textLines) do
            local measureText = line ~= "" and line or " "
            local textWidth, textHeight = surface.GetTextSize(measureText)
            if line == "" then textWidth = 0 end
            lineHeights[i] = math.max(textHeight, defaultLineHeight)
            maxWidth = math.max(maxWidth, textWidth)
            if i == 1 then
                totalHeight = lineHeights[i]
            else
                totalHeight = totalHeight + lineHeights[i] + lineSpacing
            end
        end

        local boxWidth, boxHeight
        if autoSize then
            boxWidth = maxWidth + padding
            boxHeight = totalHeight + padding
        else
            boxWidth = options.width or maxWidth + padding
            boxHeight = options.height or totalHeight + padding
        end

        local boxX = x
        if textAlignX == TEXT_ALIGN_RIGHT then
            boxX = x - boxWidth
        elseif textAlignX == TEXT_ALIGN_CENTER then
            boxX = x - boxWidth / 2
        end

        local boxY = y
        if textAlignY == TEXT_ALIGN_BOTTOM then
            boxY = y - boxHeight
        elseif textAlignY == TEXT_ALIGN_CENTER then
            boxY = y - boxHeight / 2
        end

        if drawBoxFrame ~= FrameNumber() then
            drawBoxOverlaps = {}
            drawBoxFrame = FrameNumber()
        end

        local screenW, screenH = ScrW(), ScrH()
        local function intersects(cx, cy)
            for _, rect in ipairs(drawBoxOverlaps) do
                if cx < rect.x + rect.w + overlapMargin and cx + boxWidth + overlapMargin > rect.x and cy < rect.y + rect.h + overlapMargin and cy + boxHeight + overlapMargin > rect.y then return rect end
            end
        end

        boxX = math.Clamp(boxX, 0, screenW - boxWidth)
        boxY = math.Clamp(boxY, 0, screenH - boxHeight)
        local overlap = intersects(boxX, boxY)
        local attempts = 0
        while overlap and attempts < 8 do
            local down = overlap.y + overlap.h + overlapMargin
            local up = overlap.y - boxHeight - overlapMargin
            local nextY = down + boxHeight <= screenH and down or math.max(0, up)
            boxY = math.Clamp(nextY, 0, screenH - boxHeight)
            overlap = intersects(boxX, boxY)
            attempts = attempts + 1
        end

        local shadow = options.shadow or {
            enabled = true,
            color = Color(0, 0, 0, 180),
            offsetX = 15,
            offsetY = 20
        }

        boxWidth = math.max(boxWidth, 1)
        boxHeight = math.max(boxHeight, 1)
        if shadow.enabled then lia.derma.rect(boxX, boxY, boxWidth, boxHeight):Rad(borderRadius):Color(shadow.color or Color(0, 0, 0, 180)):Shadow(shadow.offsetX or 15, shadow.offsetY or 20):Shape(lia.derma.SHAPE_IOS):Draw() end
        drawBlurAt(boxX, boxY, boxWidth, boxHeight, blur)
        lia.derma.rect(boxX, boxY, boxWidth, boxHeight):Color(backgroundColor):Rad(borderRadius):Shape(lia.derma.SHAPE_IOS):Draw()
        if borderThickness > 0 then lia.derma.rect(boxX, boxY, boxWidth, boxHeight):Color(borderColor):Rad(borderRadius):Shape(lia.derma.SHAPE_IOS):Outline(borderThickness):Draw() end
        local accentBorder = options.accentBorder or {
            enabled = false
        }

        if accentBorder.enabled then
            local accent = accentBorder.color or lia.color.theme.theme or color_white
            surface.SetDrawColor(accent.r, accent.g, accent.b, accent.a or 255)
            surface.DrawRect(boxX, boxY, boxWidth, accentBorder.height or 2)
        end

        local startY = boxY + padding / 2
        if textAlignY == TEXT_ALIGN_CENTER then
            startY = boxY + (boxHeight - totalHeight) / 2
        elseif textAlignY == TEXT_ALIGN_BOTTOM then
            startY = boxY + boxHeight - padding / 2 - totalHeight
        end

        local currentY = startY
        for i, line in ipairs(textLines) do
            local textX
            if textAlignX == TEXT_ALIGN_CENTER then
                textX = boxX + boxWidth / 2
            elseif textAlignX == TEXT_ALIGN_LEFT then
                textX = boxX + padding / 2
            else
                textX = boxX + boxWidth - padding / 2
            end

            if line ~= "" then lia.derma.drawText(line, textX, currentY, textColor, textAlignX, TEXT_ALIGN_TOP, font) end
            if i < #textLines then currentY = currentY + lineHeights[i] + lineSpacing end
        end

        drawBoxOverlaps[#drawBoxOverlaps + 1] = {
            x = boxX,
            y = boxY,
            w = boxWidth,
            h = boxHeight
        }
        return boxWidth, boxHeight
    end

    local accent = resolveAccent()
    local theme = lia.color and lia.color.theme or {}
    local textColor = options.textColor or theme.text or Color(235, 240, 242)
    local mutedTextColor = options.mutedTextColor or theme.gray or Color(160, 178, 180)
    local titleFont = options.titleFont or "LiliaFont.17"
    local sectionFont = options.sectionFont or "LiliaFont.15"
    local rowFont = options.font or "LiliaFont.15"
    local valueFont = options.valueFont or rowFont
    local backgroundColor = options.backgroundColor or Color(3, 18, 22, 232)
    local borderColor = options.borderColor or Color(accent.r, accent.g, accent.b, 110)
    local borderRadius = options.borderRadius or 8
    local borderThickness = options.borderThickness or 1
    local padding = options.padding or 16
    local rowHeight = options.rowHeight or 24
    local sectionGap = options.sectionGap or 12
    local columnGap = options.columnGap or 28
    local minWidth = options.minWidth or 280
    local maxWidth = options.maxWidth or 520
    local overlapMargin = options.overlapMargin or 8
    local textAlignX = options.textAlignX or TEXT_ALIGN_LEFT
    local textAlignY = options.textAlignY or TEXT_ALIGN_TOP
    local truncateTextRows = options.truncateTextRows == true
    local textRowSuffix = options.textRowSuffix or "..."
    local textRowRightPadding = options.textRowRightPadding or 6
    local titleInset = options.titleInset or 14
    local maxTextRowWidth = math.max(1, (options.width or maxWidth) - padding - textRowRightPadding)
    local titleText = resolveText(options.title or debugLayout and debugLayout.title)
    local sourceSections = {}
    if debugLayout then
        sourceSections = debugLayout.sections
    elseif istable(options.sections) then
        for _, section in ipairs(options.sections) do
            if istable(section) then
                sourceSections[#sourceSections + 1] = {
                    title = section.title or section.name,
                    rows = section.rows or section.items or {}
                }
            end
        end
    elseif istable(options.rows) then
        local current = {
            title = options.sectionTitle,
            rows = {}
        }

        for _, row in ipairs(options.rows) do
            if istable(row) and (row.section or row.category) then
                if current.title or #current.rows > 0 then sourceSections[#sourceSections + 1] = current end
                current = {
                    title = row.section or row.category,
                    rows = {}
                }
            else
                current.rows[#current.rows + 1] = row
            end
        end

        if current.title or #current.rows > 0 then sourceSections[#sourceSections + 1] = current end
    else
        sourceSections[#sourceSections + 1] = {
            rows = splitBoxTextLines(text)
        }
    end

    surface.SetFont(titleFont)
    local titleWidth, titleHeight = 0, 0
    if titleText ~= "" then titleWidth, titleHeight = surface.GetTextSize(string.upper(titleText)) end
    local measuredWidth = titleWidth + padding * 2 + 24
    local totalHeight = padding
    if titleText ~= "" then totalHeight = totalHeight + math.max(titleHeight, 18) + 14 end
    local preparedSections = {}
    for _, section in ipairs(sourceSections) do
        local preparedRows = {}
        local sectionTitle = resolveText(section.title)
        local sectionHeight = 0
        if sectionTitle ~= "" then
            surface.SetFont(sectionFont)
            local sectionWidth, sectionTextHeight = surface.GetTextSize(string.upper(sectionTitle))
            measuredWidth = math.max(measuredWidth, sectionWidth + padding * 2 + 120)
            sectionHeight = sectionHeight + math.max(sectionTextHeight, 16) + 10
        end

        for _, row in ipairs(section.rows or {}) do
            local prepared = {}
            if istable(row) then
                if row.divider then
                    prepared.type = "divider"
                    sectionHeight = sectionHeight + 10
                    preparedRows[#preparedRows + 1] = prepared
                else
                    prepared.label = resolveText(row.label or row.name or row.key or row[1])
                    prepared.value = resolveText(row.value or row[2])
                    prepared.text = resolveText(row.text)
                    if prepared.text == "" and prepared.label ~= "" and prepared.value == "" and not row.value and not row[2] then
                        prepared.text = prepared.label
                        prepared.label = ""
                    end

                    if truncateTextRows and prepared.text ~= "" and prepared.label == "" and prepared.value == "" then prepared.text = fitTextToWidth(prepared.text, maxTextRowWidth, rowFont, textRowSuffix) end
                    surface.SetFont(rowFont)
                    local labelWidth = prepared.label ~= "" and surface.GetTextSize(prepared.label) or 0
                    local textWidth = prepared.text ~= "" and surface.GetTextSize(prepared.text) or 0
                    surface.SetFont(valueFont)
                    local valueWidth = prepared.value ~= "" and surface.GetTextSize(prepared.value) or 0
                    measuredWidth = math.max(measuredWidth, labelWidth + valueWidth + padding * 2 + columnGap, textWidth + padding * 2)
                    sectionHeight = sectionHeight + rowHeight
                    preparedRows[#preparedRows + 1] = prepared
                end
            else
                prepared.text = resolveText(row)
                if truncateTextRows and prepared.text ~= "" then prepared.text = fitTextToWidth(prepared.text, maxTextRowWidth, rowFont, textRowSuffix) end
                surface.SetFont(rowFont)
                local textWidth = surface.GetTextSize(prepared.text)
                measuredWidth = math.max(measuredWidth, textWidth + padding * 2)
                sectionHeight = sectionHeight + rowHeight
                preparedRows[#preparedRows + 1] = prepared
            end
        end

        preparedSections[#preparedSections + 1] = {
            title = sectionTitle,
            rows = preparedRows,
            height = sectionHeight
        }

        totalHeight = totalHeight + sectionHeight + sectionGap
    end

    if #preparedSections > 0 then totalHeight = totalHeight - sectionGap end
    totalHeight = totalHeight + padding
    local defaultWidth = debugLayout and 430 or 360
    local boxWidth = options.width or math.Clamp(math.max(defaultWidth, measuredWidth), minWidth, maxWidth)
    if options.autoSize == false and options.width then boxWidth = options.width end
    local boxHeight = options.height or totalHeight
    local boxX = x or 0
    if textAlignX == TEXT_ALIGN_RIGHT then
        boxX = boxX - boxWidth
    elseif textAlignX == TEXT_ALIGN_CENTER then
        boxX = boxX - boxWidth * 0.5
    end

    local boxY = y or 0
    if textAlignY == TEXT_ALIGN_BOTTOM then
        boxY = boxY - boxHeight
    elseif textAlignY == TEXT_ALIGN_CENTER then
        boxY = boxY - boxHeight * 0.5
    end

    if drawBoxFrame ~= FrameNumber() then
        drawBoxOverlaps = {}
        drawBoxFrame = FrameNumber()
    end

    local screenW, screenH = ScrW(), ScrH()
    local function intersects(cx, cy)
        for _, rect in ipairs(drawBoxOverlaps) do
            if cx < rect.x + rect.w + overlapMargin and cx + boxWidth + overlapMargin > rect.x and cy < rect.y + rect.h + overlapMargin and cy + boxHeight + overlapMargin > rect.y then return rect end
        end
    end

    boxX = math.Clamp(boxX, 0, math.max(0, screenW - boxWidth))
    boxY = math.Clamp(boxY, 0, math.max(0, screenH - boxHeight))
    local overlap = intersects(boxX, boxY)
    local attempts = 0
    while overlap and attempts < 8 do
        local down = overlap.y + overlap.h + overlapMargin
        local up = overlap.y - boxHeight - overlapMargin
        local nextY = down + boxHeight <= screenH and down or math.max(0, up)
        boxY = math.Clamp(nextY, 0, math.max(0, screenH - boxHeight))
        overlap = intersects(boxX, boxY)
        attempts = attempts + 1
    end

    local shadow = options.shadow or {
        enabled = true,
        color = Color(0, 0, 0, 125),
        offsetX = 8,
        offsetY = 14
    }

    local blur = options.blur or {
        enabled = true,
        amount = 2,
        passes = 2,
        alpha = 0.65
    }

    if shadow.enabled then lia.derma.rect(boxX, boxY, boxWidth, boxHeight):Rad(borderRadius):Color(shadow.color or Color(0, 0, 0, 125)):Shadow(shadow.offsetX or 8, shadow.offsetY or 14):Shape(lia.derma.SHAPE_IOS):Draw() end
    drawBlurAt(boxX, boxY, boxWidth, boxHeight, blur)
    lia.derma.rect(boxX, boxY, boxWidth, boxHeight):Rad(borderRadius):Color(backgroundColor):Shape(lia.derma.SHAPE_IOS):Draw()
    if borderThickness > 0 then lia.derma.rect(boxX, boxY, boxWidth, boxHeight):Rad(borderRadius):Color(borderColor):Shape(lia.derma.SHAPE_IOS):Outline(borderThickness):Draw() end
    surface.SetDrawColor(accent.r, accent.g, accent.b, options.accentAlpha or 210)
    surface.DrawRect(boxX, boxY + 1, 3, math.min(22, boxHeight - 2))
    local currentY = boxY + padding
    if titleText ~= "" then
        draw.SimpleText(string.upper(titleText), titleFont, boxX + padding + titleInset, currentY, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(255, 255, 255, 18)
        surface.SetFont(titleFont)
        local headerWidth = surface.GetTextSize(string.upper(titleText))
        surface.DrawRect(boxX + padding + titleInset + headerWidth + 4, currentY + 9, math.max(0, boxWidth - padding * 2 - titleInset - headerWidth - 4), 1)
        currentY = currentY + math.max(titleHeight, 18) + 14
    end

    for sectionIndex, section in ipairs(preparedSections) do
        if section.title ~= "" then
            draw.SimpleText(string.upper(section.title), sectionFont, boxX + padding, currentY, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetFont(sectionFont)
            local sectionWidth = surface.GetTextSize(string.upper(section.title))
            surface.SetDrawColor(accent.r, accent.g, accent.b, 35)
            surface.DrawRect(boxX + padding + sectionWidth + 14, currentY + 8, math.max(0, boxWidth - padding * 2 - sectionWidth - 14), 1)
            currentY = currentY + 26
        end

        for _, row in ipairs(section.rows) do
            if row.type == "divider" then
                surface.SetDrawColor(255, 255, 255, 14)
                surface.DrawRect(boxX + padding, currentY + 5, boxWidth - padding * 2, 1)
                currentY = currentY + 10
            elseif row.text ~= "" then
                draw.SimpleText(row.text, rowFont, boxX + padding, currentY + math.floor(rowHeight * 0.5), textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                currentY = currentY + rowHeight
            else
                draw.SimpleText(row.label, rowFont, boxX + padding, currentY + math.floor(rowHeight * 0.5), mutedTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(row.value, valueFont, boxX + boxWidth - padding, currentY + math.floor(rowHeight * 0.5), textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                currentY = currentY + rowHeight
            end
        end

        if sectionIndex < #preparedSections then currentY = currentY + sectionGap end
    end

    drawBoxOverlaps[#drawBoxOverlaps + 1] = {
        x = boxX,
        y = boxY,
        w = boxWidth,
        h = boxHeight
    }
    return boxWidth, boxHeight
end

--[[
    Purpose:
        Draws a material or material path at the given rectangle using `surface.DrawTexturedRect`.

    Parameters:
        material (IMaterial|string)
            Material instance or material path resolved through `lia.util.getMaterial`.
        color (Color|nil)
            Draw color. Defaults to white.
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Texture width.
        h (number)
            Texture height.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawSurfaceTexture("vgui/white", color_white, x, y, w, h)
        ```

    Realm:
        Client
]]
function lia.derma.drawSurfaceTexture(material, color, x, y, w, h)
    surface.SetDrawColor(color or Color(255, 255, 255))
    if isstring(material) then
        surface.SetMaterial(lia.util.getMaterial(material))
    else
        surface.SetMaterial(material)
    end

    surface.DrawTexturedRect(x, y, w, h)
end

--[[
    Purpose:
        Calls a named function on a panel skin, or on the default Derma skin when the panel is invalid.

    Parameters:
        name (string)
            Skin function name.
        panel (Panel|nil)
            Panel whose skin should be used.
        a, b, c, d, e, f, g (any)
            Optional arguments forwarded to the skin function.

    Returns:
        any
            Whatever the skin function returns, or nil when no matching skin function exists.

    Example Usage:
        ```lua
        lia.derma.skinFunc("PaintFrame", panel, w, h)
        ```

    Realm:
        Client
]]
function lia.derma.skinFunc(name, panel, a, b, c, d, e, f, g)
    local skin = ispanel(panel) and IsValid(panel) and panel:GetSkin() or derma.GetDefaultSkin()
    if not skin then return end
    local func = skin[name]
    if not func then return end
    return func(skin, panel, a, b, c, d, e, f, g)
end

--[[
    Purpose:
        Moves a value toward a target using exponential smoothing.

    Parameters:
        current (number)
            Current value.
        target (number)
            Target value.
        speed (number)
            Smoothing speed.
        dt (number)
            Delta time.

    Returns:
        number
            The interpolated value.

    Example Usage:
        ```lua
        value = lia.derma.approachExp(value, 1, 12, FrameTime())
        ```

    Realm:
        Client
]]
function lia.derma.approachExp(current, target, speed, dt)
    local t = 1 - math.exp(-speed * dt)
    return current + (target - current) * t
end

--[[
    Purpose:
        Applies cubic ease-out interpolation to a normalized value.

    Parameters:
        t (number)
            Normalized value from 0 to 1.

    Returns:
        number
            The eased value.

    Example Usage:
        ```lua
        local eased = lia.derma.easeOutCubic(t)
        ```

    Realm:
        Client
]]
function lia.derma.easeOutCubic(t)
    return 1 - (1 - t) * (1 - t) * (1 - t)
end

--[[
    Purpose:
        Applies cubic ease-in-out interpolation to a normalized value.

    Parameters:
        t (number)
            Normalized value from 0 to 1.

    Returns:
        number
            The eased value.

    Example Usage:
        ```lua
        local eased = lia.derma.easeInOutCubic(t)
        ```

    Realm:
        Client
]]
function lia.derma.easeInOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    else
        return 1 - math.pow(-2 * t + 2, 3) / 2
    end
end

--[[
    Purpose:
        Animates a valid panel from a scaled, transparent state to its target size, position, and full opacity, then optionally calls a callback.

    Parameters:
        panel (Panel)
            Panel to animate.
        targetWidth (number)
            Final panel width.
        targetHeight (number)
            Final panel height.
        duration (number|nil)
            Size and position animation duration. Defaults to 0.18.
        alphaDuration (number|nil)
            Alpha animation duration. Defaults to `duration`.
        callback (function|nil)
            Optional callback called with the panel when the animation finishes.
        scaleFactor (number|nil)
            Initial scale factor. Defaults to 0.8.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.animateAppearance(panel, 300, 200, 0.2, 0.2, function(donePanel) end, 0.85)
        ```

    Realm:
        Client
]]
function lia.derma.animateAppearance(panel, targetWidth, targetHeight, duration, alphaDuration, callback, scaleFactor)
    scaleFactor = scaleFactor or 0.8
    if not IsValid(panel) then return end
    duration = (duration and duration > 0) and duration or 0.18
    alphaDuration = (alphaDuration and alphaDuration > 0) and alphaDuration or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or durationtion or duration
    local targetX, targetY = panel:GetPos()
    local initialW = targetWidth * (scaleFactor and scaleFactor or scaleFactor)
    local initialH = targetHeight * (scaleFactor and scaleFactor or scaleFactor)
    local initialX = targetX + (targetWidth - initialW) / 2
    local initialY = targetY + (targetHeight - initialH) / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2 / 2
    panel:SetSize(initialW, initialH)
    panel:SetPos(initialX, initialY)
    panel:SetAlpha(0)
    local curW, curH = initialW, initialH
    local curX, curY = initialX, initialY
    local curA = 0
    local eps = 0.5
    local alpha_eps = 1
    local speedSize = 3 / math.max(0.0001, duration)
    local speedAlpha = 3 / math.max(0.0001, alphaDuration)
    panel.Think = function()
        if not IsValid(panel) then return end
        local dt = FrameTime()
        curW = lia.derma.approachExp(curW, targetWidth, speedSize, dt)
        curH = lia.derma.approachExp(curH, targetHeight, speedSize, dt)
        curX = lia.derma.approachExp(curX, targetX, speedSize, dt)
        curY = lia.derma.approachExp(curY, targetY, speedSize, dt)
        curA = lia.derma.approachExp(curA, 255, speedAlpha, dt)
        panel:SetSize(curW, curH)
        panel:SetPos(curX, curY)
        panel:SetAlpha(math.floor(curA + 0.5))
        local doneSize = math.abs(curW - targetWidth) <= eps and math.abs(curH - targetHeight) <= eps <= eps
        local donePos = math.abs(curX - targetX) <= eps and math.abs(curY - targetY) <= eps
        local doneAlpha = math.abs(curA - 255) <= alpha_eps
        if doneSize and donePos and doneAlpha then
            panel:SetSize(targetWidth, targetHeight)
            panel:SetPos(targetX, targetY)
            panel:SetAlpha(255)
            panel.Think = nil
            if callback then callback(panel) end
        end
    end
end

--[[
    Purpose:
        Moves a panel so it stays inside the visible screen area with a small margin.

    Parameters:
        panel (Panel)
            Panel to clamp.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.clampMenuPosition(menu)
        ```

    Realm:
        Client
]]
function lia.derma.clampMenuPosition(panel)
    if not IsValid(panel) then return end
    local x, y = panel:GetPos()
    local w, h = panel:GetSize()
    local sw, sh = ScrW(), ScrH()
    if x < 5 then
        x = 5
    elseif x + w > sw - 5 then
        x = sw - 5 - w
    end

    if y < 5 then
        y = 5
    elseif y + h > sh - 5 then
        y = sh - 5 - h
    end

    panel:SetPos(x, y)
end

--[[
    Purpose:
        Draws one of the built-in VGUI gradient materials with rounded-corner support.

    Parameters:
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Gradient width.
        h (number)
            Gradient height.
        direction (number)
            Gradient material index: up, down, left, or right.
        colorShadow (Color)
            Gradient tint color.
        radius (number|nil)
            Corner radius. Defaults to 0.
        flags (number|nil)
            Optional rounded draw flags.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawGradient(x, y, w, h, 1, Color(0, 0, 0, 120), 8)
        ```

    Realm:
        Client
]]
function lia.derma.drawGradient(x, y, w, h, direction, colorShadow, radius, flags)
    local listGradients = {Material("vgui/gradient_up"), Material("vgui/gradient_down"), Material("vgui/gradient-l"), Material("vgui/gradient-r")}
    radius = radius and radius or 0
    lia.derma.drawMaterial(radius, x, y, w, h, colorShadow, listGradients[direction], flags)
end

--[[
    Purpose:
        Splits text into lines that fit within a target width for the selected font.

    Parameters:
        text (string)
            Text to wrap.
        width (number)
            Maximum line width.
        font (string|nil)
            Font name. Defaults to `LiliaFont.16`.

    Returns:
        table, number
            A table of wrapped lines and the measured maximum width.

    Example Usage:
        ```lua
        local lines, maxW = lia.derma.wrapText(description, 240, "LiliaFont.16")
        ```

    Realm:
        Client
]]
function lia.derma.wrapText(text, width, font)
    font = font or "LiliaFont.16"
    surface.SetFont(font)
    local exploded = string.Explode("%s", text, true)
    local line = ""
    local lines = {}
    local w = surface.GetTextSize(text)
    local maxW = 0
    if w <= width then
        text, _ = text:gsub("%s", " ")
        return {text}, w
    end

    for i = 1, #exploded do
        local word = exploded[i]
        line = line .. " " .. word
        w = surface.GetTextSize(line)
        if w > width then
            lines[#lines + 1] = line
            line = ""
            if w > maxW then maxW = w end
        end
    end

    if line ~= "" then lines[#lines + 1] = line end
    return lines, maxW
end

--[[
    Purpose:
        Draws a screen-space blur behind a panel by using the panel's local-to-screen origin.

    Parameters:
        panel (Panel)
            Panel whose area receives the blur.
        amount (number|nil)
            Blur amount. Defaults to 5.
        passes (number|nil)
            Initial blur pass value. Defaults to 0.2.
        alpha (number|nil)
            Blur draw alpha. Defaults to 255.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        function PANEL:Paint(w, h)
            lia.derma.drawBlur(self, 5, 0.2, 255)
        end
        ```

    Realm:
        Client
]]
function lia.derma.drawBlur(panel, amount, passes, alpha)
    amount = amount or 5
    alpha = alpha or 255
    surface.SetMaterial(lia.util.getMaterial("pp/blurscreen"))
    surface.SetDrawColor(255, 255, 255, alpha)
    local x, y = panel:LocalToScreen(0, 0)
    for i = -(passes or 0.2), 1, 0.2 do
        lia.util.getMaterial("pp/blurscreen"):SetFloat("$blur", i * amount)
        lia.util.getMaterial("pp/blurscreen"):Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

--[[
    Purpose:
        Draws a screen-space blur behind a panel and overlays a dark translucent rectangle over the panel bounds.

    Parameters:
        panel (Panel)
            Panel whose area receives blur and darkening.
        amount (number|nil)
            Blur amount. Defaults to 6.
        passes (number|nil)
            Number of blur passes. Defaults to 5.
        alpha (number|nil)
            Blur draw alpha. Defaults to 255.
        darkAlpha (number|nil)
            Black overlay alpha. Defaults to 220.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        function PANEL:Paint(w, h)
            lia.derma.drawBlackBlur(self, 6, 5, 255, 180)
        end
        ```

    Realm:
        Client
]]
function lia.derma.drawBlackBlur(panel, amount, passes, alpha, darkAlpha)
    if not IsValid(panel) then return end
    amount = amount or 6
    passes = math.max(1, passes or 5)
    alpha = alpha or 255
    darkAlpha = darkAlpha or 220
    local mat = lia.util.getMaterial("pp/blurscreen")
    local x, y = panel:LocalToScreen(0, 0)
    x = math.floor(x)
    y = math.floor(y)
    local sw, sh = ScrW(), ScrH()
    local expand = 4
    render.UpdateScreenEffectTexture()
    surface.SetMaterial(mat)
    surface.SetDrawColor(255, 255, 255, alpha)
    for i = 1, passes do
        mat:SetFloat("$blur", i / passes * amount)
        mat:Recompute()
        surface.DrawTexturedRectUV(-x - expand, -y - expand, sw + expand * 2, sh + expand * 2, 0, 0, 1, 1)
    end

    surface.SetDrawColor(0, 0, 0, darkAlpha)
    surface.DrawRect(x, y, panel:GetWide(), panel:GetTall())
end

--[[
    Purpose:
        Draws a screen-space blur inside an explicit rectangle.

    Parameters:
        x (number)
            Left screen coordinate.
        y (number)
            Top screen coordinate.
        w (number)
            Blur width.
        h (number)
            Blur height.
        amount (number|nil)
            Blur amount. Defaults to 5.
        passes (number|nil)
            Initial blur pass value. Defaults to 0.2.
        alpha (number|nil)
            Blur draw alpha. Defaults to 255.

    Returns:
        nil
            This function does not return a value.

    Example Usage:
        ```lua
        lia.derma.drawBlurAt(x, y, w, h, 5, 0.2, 255)
        ```

    Realm:
        Client
]]
function lia.derma.drawBlurAt(x, y, w, h, amount, passes, alpha)
    amount = amount or 5
    alpha = alpha or 255
    surface.SetMaterial(lia.util.getMaterial("pp/blurscreen"))
    surface.SetDrawColor(255, 255, 255, alpha)
    local x2, y2 = x / ScrW(), y / ScrH()
    local w2, h2 = (x + w) / ScrW(), (y + h) / ScrH()
    for i = -(passes or 0.2), 1, 0.2 do
        lia.util.getMaterial("pp/blurscreen"):SetFloat("$blur", i * amount)
        lia.util.getMaterial("pp/blurscreen"):Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRectUV(x, y, w, h, x2, y2, w2, h2)
    end
end

--[[
    Purpose:
        Opens a modal argument-entry window, creates controls from the requested argument types, validates input, and submits typed values through a callback.

    Parameters:
        title (string|nil)
            Window title. Defaults to the localized enter-arguments text.
        argTypes (table)
            Argument definitions. Supports ordered entries or keyed definitions using types such as string, table, boolean, number, int, and player.
        onSubmit (function|nil)
            Callback called with the result table, or false when cancelled.
        defaults (table|nil)
            Default values keyed by argument name.

    Returns:
        Panel
            The created request frame.

    Example Usage:
        ```lua
        lia.derma.requestArguments(L("settings"), {name = "string", amount = "number"}, function(values) end)
        ```

    Realm:
        Client
]]
function lia.derma.requestArguments(title, argTypes, onSubmit, defaults)
    defaults = defaults or {}
    local count = table.Count(argTypes)
    local frameW, frameH = 600, math.min(450 + count * 135, ScrH() * 0.5)
    local frame = vgui.Create("liaFrame")
    frame:SetSize(frameW, frameH)
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame:SetCenterTitle(title or L("enterArguments"))
    frame:SetZPos(1000)
    local scroll = vgui.Create("liaScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 40, 10, 10)
    surface.SetFont("LiliaFont.17")
    local controls, watchers = {}, {}
    local validate
    local ordered = {}
    local grouped = {
        strings = {},
        dropdowns = {},
        bools = {},
        rest = {}
    }

    local isOrdered = istable(argTypes) and #argTypes > 0 and istable(argTypes[1])
    if isOrdered then
        for _, argInfo in ipairs(argTypes) do
            local name, typeInfo = argInfo[1], argInfo[2]
            local fieldType, dataTbl, defaultVal = typeInfo, nil, nil
            if istable(typeInfo) then
                fieldType, dataTbl = typeInfo[1], typeInfo[2]
                if typeInfo[3] ~= nil then defaultVal = typeInfo[3] end
            end

            fieldType = string.lower(tostring(fieldType))
            if defaultVal == nil and defaults[name] ~= nil then defaultVal = defaults[name] end
            local info = {
                name = name,
                fieldType = fieldType,
                dataTbl = dataTbl,
                defaultVal = defaultVal
            }

            table.insert(ordered, info)
        end
    else
        for name, typeInfo in pairs(argTypes) do
            local fieldType, dataTbl, defaultVal = typeInfo, nil, nil
            if istable(typeInfo) then
                fieldType, dataTbl = typeInfo[1], typeInfo[2]
                if typeInfo[3] ~= nil then defaultVal = typeInfo[3] end
            end

            fieldType = string.lower(tostring(fieldType))
            if defaultVal == nil and defaults[name] ~= nil then defaultVal = defaults[name] end
            local info = {
                name = name,
                fieldType = fieldType,
                dataTbl = dataTbl,
                defaultVal = defaultVal
            }

            if fieldType == "string" then
                table.insert(grouped.strings, info)
            elseif fieldType == "table" then
                table.insert(grouped.dropdowns, info)
            elseif fieldType == "boolean" then
                table.insert(grouped.bools, info)
            else
                table.insert(grouped.rest, info)
            end
        end

        for _, group in ipairs({grouped.strings, grouped.dropdowns, grouped.bools, grouped.rest}) do
            for _, v in ipairs(group) do
                table.insert(ordered, v)
            end
        end
    end

    for _, info in ipairs(ordered) do
        local name, fieldType, dataTbl, defaultVal = info.name, info.fieldType, info.dataTbl, info.defaultVal
        if not name or name == "" then continue end
        local panel = vgui.Create("DPanel", scroll)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 15)
        panel:SetTall(120)
        panel.Paint = nil
        local label = vgui.Create("DLabel", panel)
        label:SetFont("LiliaFont.20")
        label:SetText(name)
        label:SizeToContents()
        local textW = select(1, surface.GetTextSize(name))
        local ctrl
        local isBool = fieldType == "boolean"
        if isBool then
            ctrl = vgui.Create("liaCheckbox", panel)
            if defaultVal ~= nil then ctrl:SetChecked(tobool(defaultVal)) end
        elseif fieldType == "table" then
            ctrl = vgui.Create("liaComboBox", panel)
            local defaultChoiceIndex
            if istable(dataTbl) then
                for idx, v in ipairs(dataTbl) do
                    if istable(v) then
                        ctrl:AddChoice(v[1], v[2])
                        if defaultVal ~= nil and (v[2] == defaultVal or v[1] == defaultVal) then defaultChoiceIndex = idx end
                    else
                        ctrl:AddChoice(tostring(v))
                        if defaultVal ~= nil and v == defaultVal then defaultChoiceIndex = idx end
                    end
                end
            end

            if defaultChoiceIndex then ctrl:ChooseOptionID(defaultChoiceIndex) end
            ctrl:FinishAddingOptions()
            ctrl:PostInit()
        elseif fieldType == "int" or fieldType == "number" then
            ctrl = vgui.Create("liaEntry", panel)
            ctrl:SetFont("LiliaFont.17")
            ctrl:SetTitle("")
            if ctrl.SetNumeric then ctrl:SetNumeric(true) end
            if defaultVal ~= nil then ctrl:SetValue(tostring(defaultVal)) end
        elseif fieldType == "player" then
            ctrl = vgui.Create("liaComboBox", panel)
            ctrl:SetFont("LiliaFont.17")
            ctrl:SetPlaceholder(L("select"))
            ctrl:AddChoice(L("select"), "")
            for _, pl in player.Iterator() do
                if IsValid(pl) then ctrl:AddChoice(pl:Name(), pl:SteamID()) end
            end

            ctrl:FinishAddingOptions()
            ctrl:PostInit()
            if defaultVal ~= nil then
                for i = 1, ctrl:GetOptionCount() do
                    local choiceText, choiceData = ctrl:GetOptionText(i), ctrl:GetOptionData(i)
                    if choiceData == defaultVal or choiceText == defaultVal then
                        ctrl:ChooseOptionID(i)
                        break
                    end
                end
            end
        else
            ctrl = vgui.Create("liaEntry", panel)
            ctrl:SetFont("LiliaFont.17")
            ctrl:SetTitle("")
            if defaultVal ~= nil then ctrl:SetValue(tostring(defaultVal)) end
        end

        panel.PerformLayout = function(_, w, h)
            local ctrlH, ctrlW
            if isBool then
                ctrlH, ctrlW = 22, 60
            else
                ctrlH, ctrlW = 60, w * 0.85
            end

            local ctrlX = (w - ctrlW) / 2
            ctrl:SetPos(ctrlX, (h - ctrlH) / 2 + 6)
            ctrl:SetSize(ctrlW, ctrlH)
            label:SetPos((w - textW) / 2, (h - ctrlH) / 2 - 25)
        end

        controls[name] = {
            ctrl = ctrl,
            type = fieldType
        }

        watchers[#watchers + 1] = function()
            local function trigger()
                validate()
            end

            ctrl.OnValueChange, ctrl.OnTextChanged, ctrl.OnChange, ctrl.OnSelect = trigger, trigger, trigger, trigger
        end
    end

    local btnPanel = vgui.Create("DPanel", frame)
    btnPanel:Dock(BOTTOM)
    btnPanel:SetTall(90)
    btnPanel:DockPadding(15, 15, 15, 15)
    btnPanel.Paint = nil
    local submit = vgui.Create("liaButton", btnPanel)
    submit:Dock(LEFT)
    submit:DockMargin(0, 0, 15, 0)
    submit:SetWide(270)
    submit:SetTxt(L("submit"))
    submit:SetEnabled(false)
    local cancel = vgui.Create("liaButton", btnPanel)
    cancel:Dock(RIGHT)
    cancel:SetWide(270)
    cancel:SetTxt(L("cancel"))
    cancel.DoClick = function()
        if isfunction(onSubmit) then onSubmit(false) end
        frame:Remove()
    end

    validate = function()
        for _, data in pairs(controls) do
            local ctl, ftype, ok = data.ctrl, data.type, true
            if ftype == "boolean" then
                ok = true
            elseif ctl.GetSelected then
                local txt = select(1, ctl:GetSelected())
                ok = txt and txt ~= "" and txt ~= L("select") and txt ~= L("choose")
            elseif ctl.GetValue then
                local val = ctl:GetValue()
                if ftype == "int" or ftype == "number" then
                    ok = val ~= nil and val ~= "" and tonumber(val) ~= nil
                else
                    ok = val ~= nil and val ~= "" and val ~= "nil"
                end
            end

            if not ok then
                submit:SetEnabled(false)
                return
            end
        end

        submit:SetEnabled(true)
    end

    for _, fn in ipairs(watchers) do
        fn()
    end

    validate()
    submit.DoClick = function()
        local result = {}
        for k, data in pairs(controls) do
            local ctl, ftype = data.ctrl, data.type
            if ftype == "boolean" then
                result[k] = ctl:GetChecked()
            elseif ctl.GetSelected then
                local txt, val = ctl:GetSelected()
                result[k] = val or txt
            else
                local val = ctl:GetValue()
                result[k] = (ftype == "int" or ftype == "number") and tonumber(val) or val
            end
        end

        if isfunction(onSubmit) then onSubmit(true, result) end
        frame:Remove()
    end

    frame.OnClose = function() if isfunction(onSubmit) then onSubmit(false) end end
end

--[[
    Purpose:
        Creates a framed list-view table with columns, row data, optional right-click row actions, copy-row support, and optional net submission for row actions.

    Parameters:
        title (string)
            Frame title.
        columns (table)
            Column definitions. Entries may be strings or tables with `name`, `field`, and optional `width`.
        data (table)
            Rows to display.
        options (table|nil)
            Optional right-click actions for rows.
        charID (number|nil)
            Character ID sent with row action net messages.

    Returns:
        Panel, Panel
            The created frame and `DListView` panel.

    Example Usage:
        ```lua
        local frame, list = lia.derma.createTableUI(L("players"), columns, rows, actions, charID)
        ```

    Realm:
        Client
]]
function lia.derma.createTableUI(title, columns, data, options, charID)
    if IsValid(lia.gui.menuTableUI) then lia.gui.menuTableUI:Remove() end
    local frameWidth, frameHeight = ScrW() * 0.8, ScrH() * 0.8
    local frame = vgui.Create("liaDListView")
    lia.gui.menuTableUI = frame
    frame:SetWindowTitle(title and L(title) or L("tableListTitle"))
    frame:SetSize(frameWidth, frameHeight)
    frame:Center()
    frame:MakePopup()
    if IsValid(frame.topBar) then frame.topBar:Remove() end
    if IsValid(frame.statusBar) then frame.statusBar:Remove() end
    local listView = frame.listView
    listView:Dock(FILL)
    listView:Clear()
    if listView.ClearColumns then listView:ClearColumns() end
    for _, colInfo in ipairs(columns or {}) do
        local localizedName = colInfo.name and L(colInfo.name) or L("na")
        local col = listView:AddColumn(localizedName)
        surface.SetFont(col.Header:GetFont())
        local textW = surface.GetTextSize(localizedName)
        local minWidth = textW + 16
        col:SetMinWidth(minWidth)
        col:SetWidth(colInfo.width or minWidth)
    end

    for _, row in ipairs(data) do
        local lineData = {}
        for _, colInfo in ipairs(columns) do
            table.insert(lineData, row[colInfo.field] or L("na"))
        end

        local line = listView:AddLine(unpack(lineData))
        line.rowData = row
    end

    listView.OnRowRightClick = function(_, _, line)
        if not IsValid(line) or not line.rowData then return end
        local rowData = line.rowData
        local menu = DermaMenu()
        menu:AddOption(L("copyRow"), function()
            local rowString = ""
            for key, value in pairs(rowData) do
                value = tostring(value or L("na"))
                rowString = rowString .. key:gsub("^%l", string.upper) .. " " .. value .. " | "
            end

            rowString = rowString:sub(1, -4)
            SetClipboardText(rowString)
        end)

        for _, option in ipairs(istable(options) and options or {}) do
            menu:AddOption(option.name and L(option.name) or option.name, function()
                if not option.net then return end
                if option.ExtraFields then
                    local inputPanel = vgui.Create("liaFrame")
                    inputPanel:SetTitle(L("optionsTitle", option.name))
                    inputPanel:SetSize(300, 300 + #table.GetKeys(option.ExtraFields) * 35)
                    inputPanel:Center()
                    inputPanel:MakePopup()
                    local form = vgui.Create("DForm", inputPanel)
                    form:Dock(FILL)
                    form:SetLabel("")
                    form.Paint = function() end
                    local inputs = {}
                    for fName, fType in pairs(option.ExtraFields) do
                        local label = vgui.Create("DLabel", form)
                        label:SetText(fName)
                        label:Dock(TOP)
                        label:DockMargin(5, 10, 5, 0)
                        form:AddItem(label)
                        if isstring(fType) and fType == "text" then
                            local entry = vgui.Create("DTextEntry", form)
                            entry:Dock(TOP)
                            entry:DockMargin(5, 5, 5, 0)
                            entry:SetPlaceholderText(L("typeFieldPrompt", fName))
                            form:AddItem(entry)
                            inputs[fName] = {
                                panel = entry,
                                ftype = "text"
                            }
                        elseif isstring(fType) and fType == "combo" then
                            local combo = vgui.Create("liaComboBox", form)
                            combo:Dock(TOP)
                            combo:DockMargin(5, 5, 5, 0)
                            combo:PostInit()
                            combo:SetValue(L("selectPrompt", fName))
                            form:AddItem(combo)
                            inputs[fName] = {
                                panel = combo,
                                ftype = "combo"
                            }
                        elseif istable(fType) then
                            local combo = vgui.Create("liaComboBox", form)
                            combo:Dock(TOP)
                            combo:DockMargin(5, 5, 5, 0)
                            combo:PostInit()
                            combo:SetValue(L("selectPrompt", fName))
                            for _, choice in ipairs(fType) do
                                combo:AddChoice(choice)
                            end

                            combo:FinishAddingOptions()
                            form:AddItem(combo)
                            inputs[fName] = {
                                panel = combo,
                                ftype = "combo"
                            }
                        end
                    end

                    local submitButton = vgui.Create("DButton", form)
                    submitButton:SetText(L("submit"))
                    submitButton:Dock(TOP)
                    submitButton:DockMargin(5, 10, 5, 0)
                    form:AddItem(submitButton)
                    submitButton.DoClick = function()
                        local values = {}
                        for fName, info in pairs(inputs) do
                            if not IsValid(info.panel) then continue end
                            if info.ftype == "text" then
                                values[fName] = info.panel:GetValue() or ""
                            elseif info.ftype == "combo" then
                                values[fName] = info.panel:GetSelected() or ""
                            end
                        end

                        net.Start(option.net)
                        net.WriteInt(charID, 32)
                        net.WriteTable(rowData)
                        for _, fVal in pairs(values) do
                            if isnumber(fVal) then
                                net.WriteInt(fVal, 32)
                            else
                                net.WriteString(fVal)
                            end
                        end

                        net.SendToServer()
                        inputPanel:Close()
                        frame:Remove()
                    end
                else
                    net.Start(option.net)
                    net.WriteInt(charID, 32)
                    net.WriteTable(rowData)
                    net.SendToServer()
                    frame:Remove()
                end
            end)
        end

        menu:Open()
    end

    frame.OnRemove = function() if lia.gui.menuTableUI == frame then lia.gui.menuTableUI = nil end end
    return frame, listView
end

local function resolveRequestText(text, fallback)
    if text == nil then return fallback end
    if istable(text) then
        local token = text[1]
        if isstring(token) and token:sub(1, 1) == "@" then
            return lia.lang.resolveToken(token, unpack(text, 2))
        elseif token ~= nil then
            return token
        end
        return fallback
    end

    if isstring(text) and text:sub(1, 1) == "@" then return L(text:sub(2)) end
    return text
end

local function resolveRequestOptionText(option)
    if istable(option) then
        local localized = table.Copy(option)
        if localized.text ~= nil then localized.text = resolveRequestText(localized.text, localized.text) end
        if localized[1] ~= nil then localized[1] = resolveRequestText(localized[1], localized[1]) end
        return localized
    end
    return resolveRequestText(option, option)
end

--[[
    Purpose:
        Opens a dropdown selection dialog and calls a callback with the selected text and data when submitted.

    Parameters:
        title (string|table|nil)
            Window title. Supports request-text localization helpers.
        options (table)
            Options to add to the dropdown. Table entries may be `{text, data}` pairs.
        callback (function|nil)
            Callback called with selected text and selected data, or false when cancelled.
        defaultValue (any|table|nil)
            Optional default selection text or `{text, data}` pair.

    Returns:
        Panel
            The created request frame.

    Example Usage:
        ```lua
        lia.derma.requestDropdown(L("select"), {{"One", 1}, {"Two", 2}}, function(text, data) end)
        ```

    Realm:
        Client
]]
function lia.derma.requestDropdown(title, options, callback, defaultValue)
    if IsValid(lia.gui.menuRequestDropdown) then lia.gui.menuRequestDropdown:Remove() end
    local frameHeight = 200
    local frame = vgui.Create("liaFrame")
    frame:SetSize(340, frameHeight)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(resolveRequestText(title, L("selectOption")))
    frame:ShowAnimation()
    frame:SetZPos(1000)
    local dropdown = vgui.Create("liaComboBox", frame)
    dropdown:Dock(TOP)
    dropdown:DockMargin(24, 28, 24, 16)
    dropdown:SetTall(36)
    dropdown:SetMouseInputEnabled(true)
    dropdown:SetKeyboardInputEnabled(true)
    if istable(options) then
        for _, option in ipairs(options) do
            local displayOption = resolveRequestOptionText(option)
            if istable(displayOption) then
                dropdown:AddChoice(displayOption[1], displayOption[2])
            else
                dropdown:AddChoice(tostring(displayOption))
            end
        end
    end

    if defaultValue then
        if istable(defaultValue) then
            dropdown:ChooseOptionData(defaultValue[2])
        else
            dropdown:ChooseOption(tostring(defaultValue))
        end
    end

    dropdown:PostInit()
    if #options > 0 then
        local firstOption = resolveRequestOptionText(options[1])
        if istable(firstOption) then
            dropdown:ChooseOption(firstOption[1])
            dropdown.selectedText = firstOption[1]
            dropdown.selectedData = firstOption[2]
        else
            dropdown:ChooseOption(tostring(firstOption))
            dropdown.selectedText = tostring(firstOption)
        end
    end

    dropdown.OnSelect = function(_, _, value, data)
        dropdown.selectedText = value
        dropdown.selectedData = data
        dropdown.selected = value
    end

    local buttonPanel = vgui.Create("Panel", frame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:DockMargin(24, 16, 24, 24)
    buttonPanel:SetTall(44)
    local submitBtn = vgui.Create("liaButton", buttonPanel)
    submitBtn:Dock(RIGHT)
    submitBtn:SetWide(100)
    submitBtn:SetTxt(L("select"))
    submitBtn.DoClick = function()
        local selectedText = dropdown.selectedText or dropdown:GetValue()
        local selectedData = dropdown.selectedData or dropdown:GetSelectedData()
        if not selectedText and #options > 0 then
            local firstOption = resolveRequestOptionText(options[1])
            if istable(firstOption) then
                selectedText = firstOption[1]
                selectedData = firstOption[2]
            else
                selectedText = tostring(firstOption)
            end
        end

        if callback then
            if selectedData ~= nil then
                callback(selectedText, selectedData)
            else
                callback(selectedText)
            end
        end

        frame:Remove()
    end

    local cancelBtn = vgui.Create("liaButton", buttonPanel)
    cancelBtn:Dock(LEFT)
    cancelBtn:SetWide(100)
    cancelBtn:SetTxt(L("cancel"))
    cancelBtn.DoClick = function()
        if callback then callback(false) end
        frame:Remove()
    end

    lia.gui.menuRequestDropdown = frame
    return frame
end

--[[
    Purpose:
        Opens a text-entry dialog and calls a callback with the submitted string, or false when cancelled.

    Parameters:
        title (string|table|nil)
            Window title. Supports request-text localization helpers.
        description (string|table|nil)
            Description shown above the entry.
        callback (function|nil)
            Callback called with the entered string or false.
        defaultValue (string|nil)
            Initial entry value.
        maxLength (number|nil)
            Optional maximum entry length.

    Returns:
        Panel
            The created request frame.

    Example Usage:
        ```lua
        lia.derma.requestString(L("name"), L("enterName"), function(value) end, "", 32)
        ```

    Realm:
        Client
]]
function lia.derma.requestString(title, description, callback, defaultValue, maxLength)
    if IsValid(lia.gui.menuRequestString) then lia.gui.menuRequestString:Remove() end
    local vendorPanel = lia.gui.vendor
    local vendorEditor = lia.gui.vendorEditor
    if IsValid(vendorPanel) then vendorPanel:SetVisible(false) end
    if IsValid(vendorEditor) then vendorEditor:SetVisible(false) end
    local frame = vgui.Create("liaFrame")
    frame:SetSize(600, 300)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(resolveRequestText(title, L("enterText")))
    frame:ShowAnimation()
    frame.OnRemove = function()
        if IsValid(vendorPanel) then vendorPanel:SetVisible(true) end
        if IsValid(vendorEditor) then vendorEditor:SetVisible(true) end
    end

    local descriptionLabel = vgui.Create("DLabel", frame)
    descriptionLabel:Dock(TOP)
    descriptionLabel:DockMargin(20, 40, 20, 10)
    descriptionLabel:SetText(resolveRequestText(description, L("enterValue")))
    descriptionLabel:SetFont("LiliaFont.17")
    descriptionLabel:SetTextColor(lia.color.theme.text or color_white)
    descriptionLabel:SetContentAlignment(5)
    descriptionLabel:SizeToContents()
    local textEntry = vgui.Create("liaEntry", frame)
    textEntry:Dock(TOP)
    textEntry:DockMargin(20, 0, 20, 20)
    textEntry:SetTall(30)
    textEntry:SetTitle("")
    if defaultValue then textEntry:SetValue(tostring(defaultValue)) end
    if maxLength then textEntry:SetMaxLength(maxLength) end
    local buttonPanel = vgui.Create("Panel", frame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:DockMargin(20, 10, 20, 20)
    buttonPanel:SetTall(40)
    local submitBtn = vgui.Create("liaButton", buttonPanel)
    submitBtn:Dock(RIGHT)
    submitBtn:SetWide(120)
    submitBtn:SetTxt(L("submit"))
    submitBtn.DoClick = function()
        local value = textEntry:GetValue()
        if callback then callback(value) end
        frame:Remove()
    end

    local cancelBtn = vgui.Create("liaButton", buttonPanel)
    cancelBtn:Dock(LEFT)
    cancelBtn:SetWide(120)
    cancelBtn:SetTxt(L("cancel"))
    cancelBtn.DoClick = function()
        if callback then callback(false) end
        frame:Remove()
    end

    lia.gui.menuRequestString = frame
    return frame
end

--[[
    Purpose:
        Opens an options-selection dialog that renders checkboxes and combo boxes from the supplied option definitions.

    Parameters:
        title (string|table|nil)
            Window title. Supports request-text localization helpers.
        subTitle (string|table|nil)
            Optional subtitle or description.
        options (table)
            Option definitions rendered as selectable controls.
        callback (function|nil)
            Callback called with selected options when submitted.
        onCancel (function|nil)
            Callback called when cancelled.

    Returns:
        Panel
            The created request frame.

    Example Usage:
        ```lua
        lia.derma.requestOptions(L("options"), L("chooseOptions"), options, function(selected) end)
        ```

    Realm:
        Client
]]
function lia.derma.requestOptions(title, subTitle, options, callback, onCancel)
    if IsValid(lia.gui.menuRequestOptions) then lia.gui.menuRequestOptions:Remove() end
    local count = #options
    local frameW, frameH = 600, math.min(350 + count * 100, ScrH() * 0.5)
    local frame = vgui.Create("liaFrame")
    frame:SetSize(frameW, frameH)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(resolveRequestText(title, L("selectPrompt", L("options"))))
    if subTitle then
        local subTitleLabel = vgui.Create("DLabel", frame)
        subTitleLabel:SetText(resolveRequestText(subTitle, subTitle))
        subTitleLabel:SetFont("LiliaFont.18")
        subTitleLabel:SizeToContents()
        subTitleLabel:SetPos(10, 35)
        subTitleLabel:SetColor(Color(200, 200, 200))
    end

    frame:ShowAnimation()
    frame:SetZPos(1000)
    local scrollPanel = vgui.Create("liaScrollPanel", frame)
    scrollPanel:Dock(FILL)
    scrollPanel:DockMargin(10, 40, 10, 10)
    local controls = {}
    if istable(options) then
        for _, option in ipairs(options) do
            local optionName, optionData
            if istable(option) then
                optionName = option[1] or tostring(option[2])
                optionData = option[2]
            else
                optionName = tostring(option)
                optionData = option
            end

            optionName = resolveRequestText(optionName, optionName)
            local panel = vgui.Create("DPanel", scrollPanel)
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 0, 10)
            panel:SetTall(90)
            panel.Paint = nil
            local label = vgui.Create("DLabel", panel)
            label:SetFont("LiliaFont.20")
            label:SetText(optionName)
            label:SizeToContents()
            local textW = select(1, surface.GetTextSize(optionName))
            local ctrl
            if istable(optionData) then
                ctrl = vgui.Create("liaComboBox", panel)
                local defaultChoiceIndex
                for idx, v in ipairs(optionData) do
                    if istable(v) then
                        local displayValue = resolveRequestOptionText(v)
                        ctrl:AddChoice(displayValue[1], displayValue[2])
                        if defaults[optionName] ~= nil and (displayValue[2] == defaults[optionName] or displayValue[1] == defaults[optionName]) then defaultChoiceIndex = idx end
                    else
                        local displayValue = resolveRequestText(v, v)
                        ctrl:AddChoice(tostring(displayValue))
                        if defaults[optionName] ~= nil and displayValue == defaults[optionName] then defaultChoiceIndex = idx end
                    end
                end

                if defaultChoiceIndex then ctrl:ChooseOptionID(defaultChoiceIndex) end
                ctrl:FinishAddingOptions()
                ctrl:PostInit()
            else
                ctrl = vgui.Create("liaCheckbox", panel)
                ctrl:SetChecked(defaults and table.HasValue(defaults, optionData))
            end

            panel.PerformLayout = function(_, w, h)
                local ctrlH, ctrlW
                if ctrl:GetName() == "liaCheckbox" then
                    ctrlH, ctrlW = 22, 60
                else
                    ctrlH, ctrlW = 60, w * 0.85
                end

                local ctrlX = (w - ctrlW) / 2
                ctrl:SetPos(ctrlX, (h - ctrlH) / 2 + 6)
                ctrl:SetSize(ctrlW, ctrlH)
                label:SetPos((w - textW) / 2, (h - ctrlH) / 2 - 18)
            end

            controls[optionName] = {
                ctrl = ctrl,
                data = optionData
            }
        end
    end

    local buttonPanel = vgui.Create("Panel", frame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:DockMargin(15, 15, 15, 15)
    buttonPanel:SetTall(90)
    buttonPanel.Paint = nil
    local submitBtn = vgui.Create("liaButton", buttonPanel)
    submitBtn:Dock(LEFT)
    submitBtn:DockMargin(0, 0, 15, 0)
    submitBtn:SetWide(270)
    submitBtn:SetTxt(L("submit"))
    submitBtn.DoClick = function()
        local selectedOptions = {}
        for optionName, controlInfo in pairs(controls) do
            local ctrl = controlInfo.ctrl
            if ctrl:GetName() == "liaCheckbox" then
                if ctrl:GetChecked() then table.insert(selectedOptions, controlInfo.data) end
            elseif ctrl:GetName() == "liaComboBox" then
                local selectedText, selectedData = ctrl:GetSelected()
                if selectedData then
                    selectedOptions[optionName] = selectedData
                else
                    selectedOptions[optionName] = selectedText
                end
            end
        end

        if callback then callback(selectedOptions) end
        frame:Remove()
    end

    local cancelBtn = vgui.Create("liaButton", buttonPanel)
    cancelBtn:Dock(RIGHT)
    cancelBtn:SetWide(270)
    cancelBtn:SetTxt(L("cancel"))
    cancelBtn.DoClick = function()
        if onCancel then onCancel() end
        frame:Remove()
    end

    lia.gui.menuRequestOptions = frame
    return frame
end

--[[
    Purpose:
        Opens a yes/no confirmation dialog and calls a callback with true or false.

    Parameters:
        title (string|table|nil)
            Window title. Defaults to the localized question text.
        question (string|table|nil)
            Question text. Defaults to the localized confirmation text.
        callback (function|nil)
            Callback called with true for yes or false for no.
        yesText (string|table|nil)
            Custom yes button text.
        noText (string|table|nil)
            Custom no button text.

    Returns:
        Panel
            The created request frame.

    Example Usage:
        ```lua
        lia.derma.requestBinaryQuestion(L("confirm"), L("areYouSure"), function(answer) end)
        ```

    Realm:
        Client
]]
function lia.derma.requestBinaryQuestion(title, question, callback, yesText, noText)
    if IsValid(lia.gui.menuRequestBinary) then lia.gui.menuRequestBinary:Remove() end
    local frame = vgui.Create("liaFrame")
    frame:SetSize(450, 220)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(resolveRequestText(title, L("question")))
    frame:ShowAnimation()
    frame:SetZPos(1000)
    local questionLabel = vgui.Create("DLabel", frame)
    questionLabel:Dock(TOP)
    questionLabel:DockMargin(20, 40, 20, 20)
    questionLabel:SetText(resolveRequestText(question, L("areYouSure")))
    questionLabel:SetFont("LiliaFont.18")
    questionLabel:SetTextColor(lia.color.theme.text or color_white)
    questionLabel:SetContentAlignment(5)
    questionLabel:SetWrap(true)
    questionLabel:SetAutoStretchVertical(true)
    local buttonPanel = vgui.Create("Panel", frame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:DockMargin(20, 10, 20, 20)
    buttonPanel:SetTall(40)
    local yesBtn = vgui.Create("liaButton", buttonPanel)
    yesBtn:Dock(RIGHT)
    yesBtn:DockMargin(10, 0, 0, 0)
    yesBtn:SetWide(140)
    yesBtn:SetTxt(resolveRequestText(yesText, L("yes")))
    yesBtn.DoClick = function()
        if callback then callback(true) end
        frame:Remove()
    end

    local noBtn = vgui.Create("liaButton", buttonPanel)
    noBtn:Dock(LEFT)
    noBtn:DockMargin(0, 0, 10, 0)
    noBtn:SetWide(140)
    noBtn:SetTxt(resolveRequestText(noText, L("no")))
    noBtn.DoClick = function()
        if callback then callback(false) end
        frame:Remove()
    end

    lia.gui.menuRequestBinary = frame
    return frame
end

--[[
    Purpose:
        Opens a dialog containing a custom list of buttons and optional description text.

    Parameters:
        title (string|table|nil)
            Window title. Defaults to select-option text.
        buttons (table)
            Button definitions as strings or tables with text/callback/icon values.
        callback (function|nil)
            Fallback callback called with the selected index and text, or false when closed.
        description (string|table|nil)
            Optional description shown above the buttons.

    Returns:
        Panel, table
            The created request frame and an array of created button panels.

    Example Usage:
        ```lua
        lia.derma.requestButtons(L("choose"), {"A", "B"}, function(index, text) end, L("pickOne"))
        ```

    Realm:
        Client
]]
function lia.derma.requestButtons(title, buttons, callback, description)
    if IsValid(lia.gui.menuRequestButtons) then lia.gui.menuRequestButtons:Remove() end
    local buttonCount = #buttons
    local frameHeight = 260 + (buttonCount * 45)
    local frame = vgui.Create("liaFrame")
    frame:SetSize(350, frameHeight)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(resolveRequestText(title, L("selectOption")))
    frame:ShowAnimation()
    frame:SetZPos(1000)
    local descriptionLabel = vgui.Create("DLabel", frame)
    descriptionLabel:Dock(TOP)
    descriptionLabel:DockMargin(20, 40, 20, 20)
    descriptionLabel:SetText(resolveRequestText(description, ""))
    descriptionLabel:SetFont("LiliaFont.17")
    descriptionLabel:SetTextColor(lia.color.theme.text or color_white)
    descriptionLabel:SetContentAlignment(5)
    descriptionLabel:SizeToContents()
    local buttonContainer = vgui.Create("Panel", frame)
    buttonContainer:Dock(FILL)
    buttonContainer:DockMargin(20, 0, 20, 60)
    local buttonPanels = {}
    for i, buttonInfo in ipairs(buttons) do
        local buttonText = ""
        local buttonCallback = nil
        local buttonIcon = nil
        if istable(buttonInfo) then
            buttonText = buttonInfo.text or buttonInfo[1] or tostring(buttonInfo)
            buttonCallback = buttonInfo.callback or buttonInfo[2]
            buttonIcon = buttonInfo.icon or buttonInfo[3]
        else
            buttonText = tostring(buttonInfo)
        end

        buttonText = resolveRequestText(buttonText, buttonText)
        local buttonPanel = vgui.Create("Panel", buttonContainer)
        buttonPanel:Dock(TOP)
        buttonPanel:DockMargin(0, 5, 0, 5)
        buttonPanel:SetTall(40)
        local button = vgui.Create("liaButton", buttonPanel)
        button:Dock(FILL)
        button:DockMargin(0, 0, 0, 0)
        button:SetTxt(buttonText)
        if buttonIcon then button:SetIcon(buttonIcon) end
        button.DoClick = function()
            if buttonCallback then
                local result = buttonCallback()
                if result ~= false then frame:Remove() end
            else
                if callback then
                    local result = callback(i, buttonText)
                    if result ~= false then frame:Remove() end
                else
                    frame:Remove()
                end
            end
        end

        buttonPanels[i] = button
    end

    local closeBtn = vgui.Create("liaButton", frame)
    closeBtn:Dock(BOTTOM)
    closeBtn:DockMargin(20, 10, 20, 20)
    closeBtn:SetTall(40)
    closeBtn:SetTxt(L("close"))
    closeBtn.DoClick = function()
        if callback then callback(false) end
        frame:Remove()
    end

    lia.gui.menuRequestButtons = frame
    return frame, buttonPanels
end

--[[
    Purpose:
        Opens a compact question popup with custom buttons and per-button callbacks.

    Parameters:
        question (string|table|nil)
            Question text. Defaults to the localized confirmation text.
        buttons (table)
            Button definitions as strings or `{text, callback}` pairs.

    Returns:
        Panel
            The created request frame.

    Example Usage:
        ```lua
        lia.derma.requestPopupQuestion("Continue", {{"Yes", function() end}, "No"})
        ```

    Realm:
        Client
]]
function lia.derma.requestPopupQuestion(question, buttons)
    if IsValid(lia.gui.menuRequestPopup) then lia.gui.menuRequestPopup:Remove() end
    local buttonCount = #buttons
    local frameHeight = 180 + (buttonCount * 45)
    local frame = vgui.Create("liaFrame")
    frame:SetSize(400, frameHeight)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("")
    frame:SetCenterTitle(L("question"))
    frame:ShowAnimation()
    frame:SetZPos(1000)
    local questionLabel = vgui.Create("DLabel", frame)
    questionLabel:Dock(TOP)
    questionLabel:DockMargin(20, 40, 20, 20)
    questionLabel:SetText(resolveRequestText(question, L("areYouSure")))
    questionLabel:SetFont("LiliaFont.14")
    questionLabel:SetTextColor(lia.color.theme.text or color_white)
    questionLabel:SetContentAlignment(5)
    questionLabel:SizeToContents()
    local buttonContainer = vgui.Create("Panel", frame)
    buttonContainer:Dock(FILL)
    buttonContainer:DockMargin(20, 0, 20, 20)
    for _, buttonInfo in ipairs(buttons) do
        local buttonText
        local buttonCallback = nil
        if istable(buttonInfo) then
            buttonText = buttonInfo[1] or tostring(buttonInfo)
            buttonCallback = buttonInfo[2]
        else
            buttonText = tostring(buttonInfo)
        end

        buttonText = resolveRequestText(buttonText, buttonText)
        local buttonPanel = vgui.Create("Panel", buttonContainer)
        buttonPanel:Dock(TOP)
        buttonPanel:DockMargin(0, 5, 0, 5)
        buttonPanel:SetTall(40)
        local button = vgui.Create("liaButton", buttonPanel)
        button:Dock(FILL)
        button:SetTxt(buttonText)
        button.DoClick = function()
            if buttonCallback and isfunction(buttonCallback) then buttonCallback() end
            frame:Remove()
        end
    end

    lia.gui.menuRequestPopup = frame
    return frame
end