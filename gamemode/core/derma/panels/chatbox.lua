--[[
    Hooks:

        ChatAddText(string markup, ...)

    Purpose:

        Allows modules to modify or prepend markup to a chat message before the
        original chat arguments are converted into markup and displayed.

        The hook is called whenever text is added to the custom chat box. The
        first argument contains the markup generated so far, while all remaining
        arguments are the original values supplied to the chat message.

        Returning a string replaces the current markup. Returning nil leaves the
        existing markup unchanged.

    Category:

        Chat

    Parameters:

        markup (string)
            The markup string generated for the message so far.

        ... (any)
            The original chat message arguments. These may include strings,
            colors, players, materials, or other values supported by the chat
            renderer.

    Returns:

        string|nil
            The modified markup string, or nil to keep the existing markup.

    Example Usage:

        ```lua
        hook.Add("ChatAddText", "liaExampleChatAddText", function(markup, ...)
            return markup .. "<color=255,200,100>[Chat] </color>"
        end)
        ```

    Realm:

        Client
]]
local PANEL = {}
local function paintChatMarkupText(chatbox, text, font, x, y, color, halign, valign, alpha)
    alpha = alpha or color.a or 255
    surface.SetFont(font)
    if IsValid(chatbox) and not chatbox.active then
        surface.SetTextColor(0, 0, 0, alpha)
        for offsetX = -1, 1 do
            for offsetY = -1, 1 do
                if offsetX ~= 0 or offsetY ~= 0 then
                    surface.SetTextPos(x + offsetX, y + offsetY)
                    surface.DrawText(text)
                end
            end
        end
    end

    surface.SetTextColor(color.r, color.g, color.b, alpha)
    surface.SetTextPos(x, y)
    surface.DrawText(text)
end

local function withAlpha(color, alpha)
    return Color(color.r, color.g, color.b, alpha)
end

local function blendColor(base, tint, fraction, alpha)
    fraction = math.Clamp(fraction or 0, 0, 1)
    local baseAlpha = base.a or 255
    local tintAlpha = tint.a or 255
    return Color(Lerp(fraction, base.r, tint.r), Lerp(fraction, base.g, tint.g), Lerp(fraction, base.b, tint.b), alpha or Lerp(fraction, baseAlpha, tintAlpha))
end

local function getChatPalette()
    local theme = lia.color and lia.color.theme or {}
    local accent = theme.accent or theme.header or theme.theme or Color(64, 170, 255)
    local text = theme.text or Color(230, 238, 236)
    local backgroundBase = theme.background or Color(2, 13, 18)
    local surfaceBase = theme.surface or Color(5, 21, 27)
    local headerBase = theme.headerBackground or Color(2, 14, 18)
    local glassBase = theme.chatGlassBase or blendColor(surfaceBase, accent, 0.16, 132)
    local glassLayer = theme.chatGlassLayer or blendColor(surfaceBase, accent, 0.26, 88)
    local background = theme.chatBackground or blendColor(backgroundBase, accent, 0.1, 148)
    local surface = theme.chatSurface or blendColor(surfaceBase, accent, 0.18, 102)
    local header = theme.chatHeader or blendColor(headerBase, accent, 0.24, 94)
    local raised = theme.chatRaised or blendColor(surfaceBase, accent, 0.28, 118)
    local button = theme.chatButton or blendColor(surfaceBase, accent, 0.3, 34)
    local buttonHover = theme.chatButtonHover or blendColor(surfaceBase, accent, 0.36, 58)
    local buttonPressed = theme.chatButtonPressed or blendColor(surfaceBase, accent, 0.42, 86)
    local input = theme.chatInput or blendColor(surfaceBase, accent, 0.24, 76)
    local inputFocused = theme.chatInputFocused or blendColor(surfaceBase, accent, 0.32, 96)
    return {
        accent = accent,
        text = text,
        mutedText = theme.textDim or blendColor(text, background, 0.5, 150),
        placeholder = theme.textPlaceholder or blendColor(text, background, 0.62, 105),
        background = background,
        surface = surface,
        header = header,
        raised = raised,
        glassBase = glassBase,
        glassLayer = glassLayer,
        glassHighlight = theme.chatGlassHighlight or Color(255, 255, 255, 14),
        glassHighlightStrong = theme.chatGlassHighlightStrong or Color(255, 255, 255, 28),
        glassEdge = theme.chatGlassEdge or withAlpha(accent, 165),
        glassEdgeSoft = theme.chatGlassEdgeSoft or withAlpha(accent, 95),
        border = theme.chatBorder or withAlpha(accent, 122),
        borderSoft = theme.chatBorderSoft or withAlpha(accent, 78),
        separator = theme.chatSeparator or withAlpha(accent, 88),
        separatorStrong = theme.chatSeparatorStrong or withAlpha(accent, 145),
        input = input,
        inputFocused = inputFocused,
        inputBorder = theme.chatInputBorder or withAlpha(accent, 90),
        inputBorderFocused = theme.chatInputBorderFocused or withAlpha(accent, 170),
        inputSelection = theme.chatInputSelection or withAlpha(accent, 90),
        inputCaret = theme.chatInputCaret or withAlpha(accent, 255),
        button = button,
        buttonHover = buttonHover,
        buttonPressed = buttonPressed,
        buttonBorder = theme.chatButtonBorder or withAlpha(accent, 105),
        buttonBorderHover = theme.chatButtonBorderHover or withAlpha(accent, 165),
        buttonBorderPressed = theme.chatButtonBorderPressed or withAlpha(accent, 215),
        scrollbarTrack = theme.chatScrollbarTrack or blendColor(backgroundBase, accent, 0.2, 26),
        scrollbarGrip = theme.chatScrollbarGrip or withAlpha(accent, 132),
        scrollbarGripHover = theme.chatScrollbarGripHover or withAlpha(accent, 182),
        scrollbarGripPressed = theme.chatScrollbarGripPressed or withAlpha(accent, 220),
        close = theme.chatClose or withAlpha(accent, 210),
        closeHover = theme.chatCloseHover or Color(235, 110, 95)
    }
end

local function drawGlassFrame(w, h, palette)
    lia.derma.rect(0, 0, w, h):Rad(9):Color(palette.background):Shape(lia.derma.SHAPE_IOS):Draw()
    lia.derma.rect(1, 1, w - 2, h - 2):Rad(8):Color(palette.surface):Shape(lia.derma.SHAPE_IOS):Draw()
    lia.derma.rect(2, 2, w - 4, math.max(math.floor(h * 0.34), 44)):Radii(7, 7, 0, 0):Color(palette.glassHighlight):Draw()
    lia.derma.rect(0, 0, w, h):Rad(9):Color(palette.border):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
    lia.derma.rect(1, 1, w - 2, h - 2):Rad(8):Color(palette.borderSoft):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
    surface.SetDrawColor(palette.glassHighlightStrong)
    surface.DrawRect(12, 1, w - 24, 1)
end

local function removeCommandList(panel)
    if IsValid(panel.commandList) then
        panel.commandList:Remove()
        panel.commandList = nil
        panel.commandScroll = nil
        panel.commandListCreateTime = nil
    end

    panel.commandIndex = 0
end

local function removeEntryControls(panel)
    if IsValid(panel.sendButton) then
        panel.sendButton:Remove()
        panel.sendButton = nil
    end

    if IsValid(panel.entry) then
        panel.entry:Remove()
        panel.entry = nil
    end

    if IsValid(panel.text) then
        panel.text:KillFocus()
        panel.text = nil
    end
end

local function deactivateChat(panel)
    panel.active = false
    if IsValid(panel.cls) then panel.cls:SetVisible(false) end
    if IsValid(panel.top_panel) then panel.top_panel:SetVisible(false) end
    panel:setScrollbarVisible(false)
    panel:SetDraggable(false)
    panel:SetMouseInputEnabled(false)
    panel:SetKeyboardInputEnabled(false)
    gui.EnableScreenClicker(false)
    removeCommandList(panel)
    removeEntryControls(panel)
end

function PANEL:Init()
    local border = 32
    local screenW, screenH = ScrW(), ScrH()
    local width, height = screenW * 0.4, screenH * 0.375
    lia.gui.chat = self
    self:SetSize(width, height)
    self:SetPos(border, screenH - height - border)
    self.active = false
    self.commandIndex = 0
    self.commands = lia.command.list
    self.arguments = {}
    self:SetAlphaBackground(false)
    self:SetTitle("")
    self:SetCenterTitle("")
    self:ShowCloseButton(true)
    self:SetDraggable(true)
    self:SetSizable(false)
    self:SetVisible(true)
    local chatIcon = Material("icon16/comments.png")
    self.Paint = function(s, w, h)
        if not s.active then return end
        local palette = getChatPalette()
        if lia.util and lia.util.drawBlackBlur then lia.util.drawBlackBlur(s, 1, 3, 255, 80) end
        drawGlassFrame(w, h, palette)
        lia.derma.rect(1, 1, w - 2, 40):Radii(8, 8, 0, 0):Color(palette.header):Draw()
        lia.derma.rect(2, 2, w - 4, 18):Radii(7, 7, 0, 0):Color(palette.glassHighlightStrong):Draw()
        surface.SetDrawColor(palette.separator)
        surface.DrawRect(12, 40, w - 24, 1)
        surface.SetDrawColor(palette.separatorStrong)
        surface.DrawRect(12, 41, math.min(w * 0.15, 74), 1)
        if not chatIcon:IsError() then
            surface.SetMaterial(chatIcon)
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, 235)
            surface.DrawTexturedRect(14, 12, 16, 16)
        end

        draw.SimpleText("Chat", "LiliaFont.18", 38, 20, palette.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if IsValid(self.btnClose) then
        self.btnClose:SetText("")
        self.btnClose:SetSize(28, 28)
        self.btnClose.Paint = function(button, w, h)
            local palette = getChatPalette()
            local color = button:IsHovered() and palette.closeHover or palette.close
            surface.SetDrawColor(color)
            surface.DrawLine(9, 9, w - 9, h - 9)
            surface.DrawLine(w - 9, 9, 9, h - 9)
        end
    end

    self.HitTest = function(s, x, y)
        if not s.active then return false end
        return s.BaseClass.HitTest(s, x, y)
    end

    local originalThink = self.Think
    self.Think = function(s)
        if originalThink then originalThink(s) end
        if IsValid(s.cls) then s.cls:SetVisible(s.active) end
        if IsValid(s.top_panel) then s.top_panel:SetVisible(s.active) end
        s:SetDraggable(s.active)
        s:SetMouseInputEnabled(s.active)
        s:SetKeyboardInputEnabled(s.active)
        if IsValid(s.sendButton) and IsValid(s.entry) then
            s.sendButton:SetSize(42, s.entry:GetTall())
            s.sendButton:SetPos(s:GetWide() - 54, s.entry:GetY())
        end
    end

    self.scroll = self:Add("liaScrollPanel")
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(12, 46, 12, 6)
    self.scroll:GetVBar():SetWide(8)
    self.scrollbarShouldBeVisible = false
    self:setScrollbarVisible(false)
    self.scroll:SetVisible(true)
    local vbar = self.scroll:GetVBar()
    if IsValid(vbar) then
        vbar:SetHideButtons(true)
        vbar.Paint = function(_, w, h)
            if not self.scrollbarShouldBeVisible then return end
            local palette = getChatPalette()
            lia.derma.rect(0, 0, w, h):Rad(4):Color(palette.scrollbarTrack):Shape(lia.derma.SHAPE_IOS):Draw()
            surface.SetDrawColor(palette.glassHighlight)
            surface.DrawRect(1, 1, math.max(w - 2, 1), 1)
        end

        vbar.btnGrip.Paint = function(button, w, h)
            if not self.scrollbarShouldBeVisible then return end
            local palette = getChatPalette()
            local color = button.Depressed and palette.scrollbarGripPressed or button:IsHovered() and palette.scrollbarGripHover or palette.scrollbarGrip
            lia.derma.rect(1, 0, w - 2, h):Rad(4):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
        end
    end

    self.lastY = 0
    self.list = {}
    chat.GetChatBoxPos = function() return self:LocalToScreen(0, 0) end
    chat.GetChatBoxSize = function() return self:GetSize() end
    hook.Add("OnThemeChanged", self, function() if IsValid(self) then self:OnThemeChanged() end end)
end

function PANEL:setScrollbarVisible(visible)
    if IsValid(self.scroll) and IsValid(self.scroll:GetVBar()) then
        local vbar = self.scroll:GetVBar()
        self.scrollbarShouldBeVisible = visible
        vbar:SetVisible(true)
        vbar:SetWide(visible and 8 or 0)
    end
end

function PANEL:updateCommandListLayout()
    if not IsValid(self.commandList) then return end
    local listHeight = math.min(math.max(self:GetTall() * 0.55, 176), 240)
    local listWidth = self:GetWide() - 16
    local chatX, chatY = self:LocalToScreen(0, 0)
    local listX = chatX + 4
    local listY = math.max(8, chatY - listHeight - 6)
    self.commandList:SetSize(listWidth, listHeight)
    self.commandList:SetPos(listX, listY)
end

function PANEL:setActive(state)
    self.active = state
    lia.chat.wasActive = state
    if IsValid(self.cls) then self.cls:SetVisible(state) end
    if IsValid(self.top_panel) then self.top_panel:SetVisible(state) end
    self:setScrollbarVisible(state)
    self:SetDraggable(state)
    self:SetMouseInputEnabled(state)
    self:SetKeyboardInputEnabled(state)
    if not state then self:setScrollbarVisible(false) end
    if state then
        local currentTime = CurTime()
        for _, msgPanel in ipairs(self.list or {}) do
            if IsValid(msgPanel) then
                msgPanel:SetAlpha(255)
                msgPanel.start = currentTime + 8
                msgPanel.finish = msgPanel.start + 12
            end
        end

        self.entry = self:Add("liaEntry")
        self.entry:Dock(BOTTOM)
        self.entry:DockMargin(12, 0, 62, 10)
        self.entry:SetTall(38)
        self.entry:SetFont("LiliaFont.17")
        self.entry:SetPlaceholderText("Enter text...")
        self.entry.OnRemove = function() hook.Run("FinishChat") end
        local textEntry = self.entry.textEntry
        textEntry.PaintOver = function(s, w, h)
            local palette = getChatPalette()
            local focused = s:IsEditing() or s:HasFocus()
            local fillColor = focused and palette.inputFocused or palette.input
            local borderColor = focused and palette.inputBorderFocused or palette.inputBorder
            lia.derma.rect(0, 0, w, h):Rad(6):Color(fillColor):Shape(lia.derma.SHAPE_IOS):Draw()
            lia.derma.rect(1, 1, w - 2, math.max(math.floor(h * 0.45), 10)):Rad(5):Color(palette.glassHighlight):Shape(lia.derma.SHAPE_IOS):Draw()
            lia.derma.rect(0, 0, w, h):Rad(6):Color(borderColor):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
            if focused then lia.derma.rect(1, 1, w - 2, h - 2):Rad(5):Color(withAlpha(palette.accent, 18)):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
            if s:GetText() == "" then draw.SimpleText("Enter text...", "LiliaFont.17", 12, h * 0.5, palette.placeholder, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            s:DrawTextEntryText(palette.text, palette.inputSelection, palette.inputCaret)
        end

        self.sendButton = self:Add("DButton")
        self.sendButton:SetText("")
        self.sendButton:SetSize(42, 38)
        self.sendButton.Paint = function(button, w, h)
            local palette = getChatPalette()
            local fillColor = button.Depressed and palette.buttonPressed or button:IsHovered() and palette.buttonHover or palette.button
            local borderColor = button.Depressed and palette.buttonBorderPressed or button:IsHovered() and palette.buttonBorderHover or palette.buttonBorder
            local centerX = math.floor(w * 0.5)
            local centerY = math.floor(h * 0.5)
            lia.derma.rect(0, 0, w, h):Rad(6):Color(fillColor):Shape(lia.derma.SHAPE_IOS):Draw()
            lia.derma.rect(1, 1, w - 2, math.max(math.floor(h * 0.45), 10)):Rad(5):Color(palette.glassHighlight):Shape(lia.derma.SHAPE_IOS):Draw()
            lia.derma.rect(0, 0, w, h):Rad(6):Color(borderColor):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, 235)
            surface.DrawLine(centerX - 7, centerY - 8, centerX + 6, centerY)
            surface.DrawLine(centerX + 6, centerY, centerX - 7, centerY + 8)
            surface.DrawLine(centerX - 7, centerY - 8, centerX - 3, centerY)
            surface.DrawLine(centerX - 3, centerY, centerX - 7, centerY + 8)
        end

        self.sendButton.DoClick = function() if IsValid(self.text) and self.text.OnEnter then self.text:OnEnter() end end
        lia.chat.history = lia.chat.history or {}
        self.text = self.entry.textEntry
        self.text.History = lia.chat.history
        self.text:SetHistoryEnabled(true)
        self.text:SetAllowNonAsciiCharacters(true)
        self.text.OnEnter = function(entry)
            local input = entry:GetText()
            local isCommand = input:sub(1, 1) == "/"
            if input:find("%S") then
                if not (lia.chat.lastLine or ""):find(input, 1, true) then
                    lia.chat.history[#lia.chat.history + 1] = input
                    lia.chat.lastLine = input
                end

                net.Start("liaMessageData")
                net.WriteString(input)
                net.SendToServer()
            end

            if isCommand then
                timer.Simple(0.1, function()
                    if not IsValid(self) then return end
                    deactivateChat(self)
                end)
            else
                deactivateChat(self)
            end
        end

        self.text.OnTextChanged = function(entry)
            local input = entry:GetText()
            hook.Run("ChatTextChanged", input)
            if input:sub(1, 1) == "/" then
                removeCommandList(self)
                self.commandList = vgui.Create("DPanel")
                self:updateCommandListLayout()
                self.commandList:MakePopup()
                self.commandList:SetKeyboardInputEnabled(false)
                self.commandListCreateTime = CurTime()
                self.commandList.Paint = function(s, w, h)
                    local palette = getChatPalette()
                    if lia.util and lia.util.drawBlackBlur then lia.util.drawBlackBlur(s, 1, 3, 255, 70) end
                    drawGlassFrame(w, h, palette)
                    lia.derma.rect(1, 1, w - 2, 42):Radii(7, 7, 0, 0):Color(palette.header):Draw()
                    lia.derma.rect(2, 2, w - 4, 16):Radii(6, 6, 0, 0):Color(palette.glassHighlightStrong):Draw()
                    draw.SimpleText("COMMANDS", "LiliaFont.18", 18, 22, withAlpha(palette.accent, 235), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    surface.SetDrawColor(palette.separator)
                    surface.DrawRect(14, 42, w - 28, 1)
                    surface.SetDrawColor(palette.separatorStrong)
                    surface.DrawRect(18, 43, 74, 1)
                end

                self.commandScroll = self.commandList:Add("liaScrollPanel")
                self.commandScroll:Dock(FILL)
                self.commandScroll:DockMargin(12, 50, 12, 12)
                self.commandScroll:GetVBar():SetWide(8)
                local commandVBar = self.commandScroll:GetVBar()
                if IsValid(commandVBar) then
                    commandVBar:SetHideButtons(true)
                    commandVBar.Paint = function(_, w, h)
                        local palette = getChatPalette()
                        lia.derma.rect(0, 0, w, h):Rad(4):Color(palette.scrollbarTrack):Shape(lia.derma.SHAPE_IOS):Draw()
                        surface.SetDrawColor(palette.glassHighlight)
                        surface.DrawRect(1, 1, math.max(w - 2, 1), 1)
                    end

                    commandVBar.btnGrip.Paint = function(button, w, h)
                        local palette = getChatPalette()
                        local color = button.Depressed and palette.scrollbarGripPressed or button:IsHovered() and palette.scrollbarGripHover or palette.scrollbarGrip
                        lia.derma.rect(1, 0, w - 2, h):Rad(4):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
                    end
                end

                local commandCount = 0
                local function addCommandRow(commandLabel, descriptionText, onClick)
                    commandCount = commandCount + 1
                    local btn = self.commandScroll:Add("DButton")
                    btn:SetText("")
                    btn.commandLabel = commandLabel
                    btn.descriptionText = descriptionText
                    btn.isSelected = false
                    btn:Dock(TOP)
                    btn:DockMargin(0, 0, 0, 2)
                    btn:SetTall(30)
                    btn.DoClick = onClick
                    btn.Paint = function(s, w, h)
                        local palette = getChatPalette()
                        local selected = s.isSelected
                        local hovered = s:IsHovered()
                        if selected or hovered then
                            local fillColor = selected and withAlpha(palette.accent, 38) or withAlpha(palette.accent, 18)
                            local borderColor = selected and withAlpha(palette.accent, 138) or withAlpha(palette.accent, 72)
                            lia.derma.rect(0, 0, w, h):Rad(4):Color(fillColor):Shape(lia.derma.SHAPE_IOS):Draw()
                            lia.derma.rect(1, 1, w - 2, math.max(math.floor(h * 0.45), 8)):Rad(3):Color(palette.glassHighlight):Shape(lia.derma.SHAPE_IOS):Draw()
                            lia.derma.rect(0, 0, w, h):Rad(4):Color(borderColor):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
                        end

                        local commandColumn = math.max(82, math.min(126, w * 0.24))
                        surface.SetDrawColor(withAlpha(palette.accent, 34))
                        surface.DrawRect(0, h - 1, w, 1)
                        surface.SetDrawColor(withAlpha(palette.accent, 92))
                        surface.DrawRect(commandColumn, 7, 1, h - 14)
                        draw.SimpleText(s.commandLabel, "LiliaFont.17", 10, h * 0.5, withAlpha(palette.accent, selected and 255 or 225), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(s.descriptionText, "LiliaFont.17", commandColumn + 14, h * 0.5, selected and color_white or palette.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    return btn
                end

                local function closeCommandList()
                    removeCommandList(self)
                end

                for cmdName, cmdInfo in SortedPairs(self.commands) do
                    if not cmdName:lower():StartWith(input:sub(2):lower()) then continue end
                    local descriptionText = cmdInfo.desc ~= "" and cmdInfo.desc or L("noDesc")
                    addCommandRow("/" .. cmdName, descriptionText, function()
                        local syntax = cmdInfo.syntax or ""
                        self.text:SetText("/" .. cmdName .. " " .. syntax)
                        self.text:RequestFocus()
                        closeCommandList()
                    end)
                end

                for _, chatInfo in SortedPairs(lia.chat.classes) do
                    if not chatInfo.prefix then continue end
                    for _, prefix in ipairs(chatInfo.prefix) do
                        if prefix:sub(1, 1) == "/" then
                            local cmd = prefix:gsub("^/", ""):lower()
                            if cmd ~= "" and not self.commands[cmd] and cmd:StartWith(input:sub(2):lower()) then
                                local descriptionText = chatInfo.desc ~= "" and chatInfo.desc or L("noDesc")
                                addCommandRow(prefix, descriptionText, function()
                                    local syntax = chatInfo.syntax or ""
                                    self.text:SetText(prefix .. " " .. syntax)
                                    self.text:RequestFocus()
                                    closeCommandList()
                                end)
                            end
                        end
                    end
                end

                if commandCount == 0 then addCommandRow("/", "No matching commands.", function() if IsValid(self.text) then self.text:RequestFocus() end end) end
                self.arguments = lia.command.extractArgs(input:sub(2))
            else
                removeCommandList(self)
            end
        end

        self:MakePopup()
        self:SetKeyboardInputEnabled(true)
        self.text:RequestFocus()
        self.text.OnKeyCodeTyped = function(entry, key)
            if key == KEY_ESCAPE then
                deactivateChat(self)
                return true
            end

            if entry:GetText():sub(1, 1) == "/" and key == KEY_TAB and IsValid(self.commandList) then
                local canvas = IsValid(self.commandScroll) and self.commandScroll:GetCanvas() or nil
                if not IsValid(canvas) then return true end
                local canvasChildren = canvas:GetChildren()
                if #canvasChildren == 0 then return true end
                for _, child in ipairs(canvasChildren) do
                    if IsValid(child) then child.isSelected = false end
                end

                self.commandIndex = (self.commandIndex or 0) + 1
                if self.commandIndex > #canvasChildren then self.commandIndex = 1 end
                local selected = canvasChildren[self.commandIndex]
                if not IsValid(selected) then return true end
                selected.isSelected = true
                local selName = (selected.commandLabel or selected:GetText()):match("^/([^%s]+)")
                if selName then
                    self.text:SetText("/" .. selName)
                    self.text:SetCaretPos(#self.text:GetText())
                end

                if IsValid(self.commandScroll) then self.commandScroll:ScrollToChild(selected) end
                self.text:RequestFocus()
                return true
            end
            return DTextEntry.OnKeyCodeTyped(entry, key)
        end

        self.text.OnLoseFocus = function(entry)
            if IsValid(self.commandList) then
                local currentText = entry:GetText()
                local timeSinceCreation = self.commandListCreateTime and (CurTime() - self.commandListCreateTime) or 0
                local isTypingCommand = currentText:sub(1, 1) == "/"
                if not isTypingCommand and timeSinceCreation > 0.5 then removeCommandList(self) end
            end

            entry:RequestFocus()
        end

        hook.Run("StartChat")
        if IsValid(self.scroll) and #self.list > 0 then
            local lastPanel = self.list[#self.list]
            if IsValid(lastPanel) then self.scroll:ScrollToChild(lastPanel) end
        end
    end
end

local function appendMarkupItem(markup, item)
    if type(item) == "IMaterial" then return markup .. "<img=" .. item:GetName() .. ",16x16>" end
    if item and istable(item) and item.GetName and item.Width and item.Height then return markup .. "<img=" .. item:GetName() .. "," .. item:Width() .. "x" .. item:Height() .. ">" end
    if IsColor(item) then return markup .. "<color=" .. item.r .. "," .. item.g .. "," .. item.b .. ">" end
    if IsValid(item) and item:IsPlayer() then
        local clr = team.GetColor(item:Team())
        return markup .. "<color=" .. clr.r .. "," .. clr.g .. "," .. clr.b .. ">" .. item:Name():gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("#", "\226\128\139#")
    end

    local str = tostring(item):gsub("<", "&lt;"):gsub(">", "&gt;")
    return markup .. str:gsub("%b**", function(val)
        local inner = val:sub(2, -2)
        if inner:find("%S") then return "<font=LiliaFont.20i>" .. inner .. "</font>" end
    end)
end

function PANEL:addText(...)
    lia.chat = lia.chat or {}
    lia.chat.persistedMessages = lia.chat.persistedMessages or {}
    local shouldPersist = not self.skipPersist
    local argList = {...}
    local markup = "<font=LiliaFont.20>"
    markup = hook.Run("ChatAddText", markup, unpack(argList)) or markup
    for _, item in ipairs(argList) do
        markup = appendMarkupItem(markup, item)
    end

    markup = markup .. "</font>"
    local panel = self.scroll:Add("liaMarkupPanel")
    panel:SetWide(self:GetWide() - 16)
    panel:setMarkup(markup, function(...) paintChatMarkupText(self, ...) end)
    panel.originalArgs = argList
    panel.markupArgs = {
        markup = markup,
        arguments = argList,
        themeState = {
            chatColor = lia.color.theme.chat,
            chatListenColor = lia.color.theme.chatListen
        }
    }

    panel.start = CurTime() + 8
    panel.finish = panel.start + 12
    panel.Think = function(p)
        if self.active then
            p:SetAlpha(255)
        else
            local fraction = math.TimeFraction(p.start, p.finish, CurTime())
            local alpha = 255 - fraction * 255
            p:SetAlpha(math.max(alpha, 0))
        end
    end

    self.list[#self.list + 1] = panel
    panel:SetPos(0, self.lastY)
    self.lastY = self.lastY + panel:GetTall() + 2
    timer.Simple(0.01, function() if IsValid(self.scroll) and IsValid(panel) then self.scroll:ScrollToChild(panel) end end)
    if shouldPersist then
        local history = lia.chat.persistedMessages
        history[#history + 1] = {
            arguments = argList
        }

        local maxEntries = 200
        if #history > maxEntries then
            local overflow = #history - maxEntries
            for i = 1, overflow do
                table.remove(history, 1)
            end
        end
    end

    if not self.active then
        self:SetVisible(true)
        if IsValid(self.scroll) then self.scroll:SetVisible(true) end
        self:SetAlpha(255)
        timer.Simple(0.1, function() if IsValid(self) and not self.active then self:SetAlpha(200) end end)
    end
    return panel:IsVisible()
end

function PANEL:Think()
    if gui.IsGameUIVisible() and self.active then deactivateChat(self) end
    if not self.active then self:setScrollbarVisible(false) end
    if self.active and IsValid(self.commandList) then self:updateCommandListLayout() end
    if self.active and IsValid(self.text) and IsValid(self.commandList) then
        local textHasFocus = self.text:HasFocus()
        local currentText = self.text:GetText()
        local timeSinceCreation = self.commandListCreateTime and CurTime() - self.commandListCreateTime or 0
        local isTypingCommand = currentText:sub(1, 1) == "/"
        if not textHasFocus and not isTypingCommand and timeSinceCreation > 0.1 then removeCommandList(self) end
    end
end

function PANEL:OnThemeChanged()
    if not IsValid(self) then return end
    if IsValid(self.commandList) then
        local canvas = IsValid(self.commandScroll) and self.commandScroll:GetCanvas() or nil
        if IsValid(canvas) then
            for _, child in ipairs(canvas:GetChildren()) do
                if IsValid(child) and child.SetTextColor then child:SetTextColor(lia.color.theme.text or Color(255, 255, 255)) end
            end
        end

        self.commandList:InvalidateLayout()
    end

    for _, panel in ipairs(self.list or {}) do
        if IsValid(panel) and panel.markupArgs then self:rebuildPanelMarkup(panel) end
    end
end

function PANEL:rebuildPanelMarkup(panel)
    if not panel.markupArgs or not panel.markupArgs.themeState then return end
    local currentChatColor = lia.color.theme.chat
    local currentChatListenColor = lia.color.theme.chatListen
    local markup = "<font=LiliaFont.20>"
    markup = hook.Run("ChatAddText", markup, unpack(panel.markupArgs.arguments)) or markup
    for _, item in ipairs(panel.markupArgs.arguments) do
        if type(item) == "IMaterial" then
            markup = markup .. "<img=" .. item:GetName() .. ",16x16>"
        elseif item and istable(item) and item.GetName and item.Width and item.Height then
            markup = markup .. "<img=" .. item:GetName() .. "," .. item:Width() .. "x" .. item:Height() .. ">"
        elseif IsColor(item) then
            local color = item
            if panel.markupArgs.themeState.chatColor and color.r == panel.markupArgs.themeState.chatColor.r and color.g == panel.markupArgs.themeState.chatColor.g and color.b == panel.markupArgs.themeState.chatColor.b then
                color = currentChatColor
            elseif panel.markupArgs.themeState.chatListenColor and color.r == panel.markupArgs.themeState.chatListenColor.r and color.g == panel.markupArgs.themeState.chatListenColor.g and color.b == panel.markupArgs.themeState.chatListenColor.b then
                color = currentChatListenColor
            end

            markup = markup .. "<color=" .. color.r .. "," .. color.g .. "," .. color.b .. ">"
        elseif IsValid(item) and item:IsPlayer() then
            local clr = team.GetColor(item:Team())
            markup = markup .. "<color=" .. clr.r .. "," .. clr.g .. "," .. clr.b .. ">" .. item:Name():gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("#", "\226\128\139#")
        else
            local str = tostring(item):gsub("<", "&lt;"):gsub(">", "&gt;")
            markup = markup .. str:gsub("%b**", function(val)
                local inner = val:sub(2, -2)
                if inner:find("%S") then return "<font=LiliaFont.20i>" .. inner .. "</font>" end
            end)
        end
    end

    markup = markup .. "</font>"
    panel:setMarkup(markup, function(...) paintChatMarkupText(self, ...) end)
    panel.markupArgs.markup = markup
    panel.markupArgs.themeState = {
        chatColor = currentChatColor,
        chatListenColor = currentChatListenColor
    }
end

function PANEL:OnRemove()
    removeCommandList(self)
    self:SetDraggable(false)
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    gui.EnableScreenClicker(false)
    hook.Remove("OnThemeChanged", self)
end

vgui.Register("liaChatBox", PANEL, "liaFrame")