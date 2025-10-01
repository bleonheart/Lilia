local PANEL = {}
function PANEL:Init()
    self.choices = {}
    self.selected = nil
    self.opened = false
    self:SetTall(26)
    self:SetText('')
    self.font = 'Fated.18'
    self.hoverAnim = 0
    self.OnSelect = function() end
    self.btn = vgui.Create('DButton', self)
    self.btn:Dock(FILL)
    self.btn:SetText('')
    self.btn:SetCursor('hand')
    self.btn.Paint = function(_, w, h)
        if self.btn:IsHovered() then
            self.hoverAnim = math.Clamp(self.hoverAnim + FrameTime() * 4, 0, 1)
        else
            self.hoverAnim = math.Clamp(self.hoverAnim - FrameTime() * 8, 0, 1)
        end

        lia.derma.rect(0, 0, w, h):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.derma.SHAPE_IOS):Shadow(5, 20):Draw()
        lia.derma.rect(0, 0, w, h):Rad(16):Color(lia.color.theme.focus_panel):Shape(lia.derma.SHAPE_IOS):Draw()
        if self.hoverAnim > 0 then lia.derma.rect(0, 0, w, h):Rad(16):Color(Color(lia.color.theme.button_hovered.r, lia.color.theme.button_hovered.g, lia.color.theme.button_hovered.b, self.hoverAnim * 255)):Shape(lia.derma.SHAPE_IOS):Draw() end
        draw.SimpleText(self.selected or self.placeholder or L("choose"), self.font, 12, h * 0.5, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        local arrowSize = 6
        local arrowX = w - 16
        local arrowY = h / 2
        local arrowColor = ColorAlpha(lia.color.theme.text, 180 + self.hoverAnim * 75)
        surface.SetDrawColor(arrowColor)
        draw.NoTexture()
        if not self.opened then
            surface.DrawPoly({
                {
                    x = arrowX - arrowSize,
                    y = arrowY - arrowSize / 2
                },
                {
                    x = arrowX + arrowSize,
                    y = arrowY - arrowSize / 2
                },
                {
                    x = arrowX,
                    y = arrowY + arrowSize / 2
                }
            })
        end
    end

    self.btn.DoClick = function()
        if self.opened then
            self:CloseMenu()
        else
            self:OpenMenu()
            surface.PlaySound('button_click.wav')
        end
    end
end

function PANEL:AddChoice(text, data)
    table.insert(self.choices, {
        text = text,
        data = data
    })
end

function PANEL:SetValue(val)
    self.selected = val
end

function PANEL:ChooseOption(text, index)
    self.selected = text
    if self.convar then RunConsoleCommand(self.convar, tostring(text)) end
    if self.OnSelect then self.OnSelect(index or 0, text, self.choices[index] and self.choices[index].data) end
end

function PANEL:ChooseOptionID(index)
    local choice = self.choices[index]
    if not choice then return end
    self:ChooseOption(choice.text, index)
end

function PANEL:ChooseOptionData(data)
    for i, choice in ipairs(self.choices) do
        if choice.data == data then
            self:ChooseOption(choice.text, i)
            return
        end
    end
end

function PANEL:GetValue()
    return self.selected
end

function PANEL:SetPlaceholder(text)
    self.placeholder = text
end

function PANEL:Clear()
    self.choices = {}
    self.selected = nil
    if IsValid(self.menu) then self.menu:Remove() end
end

function PANEL:OpenMenu()
    if IsValid(self.menu) then self.menu:Remove() end
    local menuPadding = 6
    local itemHeight = 26
    local menuHeight = (#self.choices * (itemHeight + 2)) + (menuPadding * 2) + 2
    self.menu = vgui.Create('DPanel')
    self.menu:SetSize(self:GetWide(), menuHeight)
    local x, y = self:LocalToScreen(0, self:GetTall())
    if y + menuHeight > ScrH() - 10 then y = y - menuHeight - self:GetTall() end
    self.menu:SetPos(x, y)
    self.menu:SetDrawOnTop(true)
    self.menu:MakePopup()
    self.menu:SetKeyboardInputEnabled(false)
    self.menu:DockPadding(menuPadding, menuPadding, menuPadding, menuPadding)
    self.menu.Paint = function(_, w, h)
        lia.derma.rect(0, 0, w, h):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.derma.SHAPE_IOS):Shadow(10, 16):Draw()
        lia.derma.rect(0, 0, w, h):Rad(16):Color(lia.color.theme.background_panelpopup):Shape(lia.derma.SHAPE_IOS):Draw()
    end

    surface.SetFont(self.font)
    for i, choice in ipairs(self.choices) do
        local option = vgui.Create('DButton', self.menu)
        option:SetText('')
        option:Dock(TOP)
        option:DockMargin(2, 2, 2, 0)
        option:SetTall(itemHeight)
        option:SetCursor('hand')
        option.Paint = function(s, w, h)
            if s:IsHovered() then lia.derma.rect(0, 0, w, h):Rad(16):Color(lia.color.theme.hover):Shape(lia.derma.SHAPE_IOS):Draw() end
            draw.SimpleText(choice.text, 'Fated.18', 14, h * 0.5, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if self.selected == choice.text then lia.derma.rect(4, h * 0.5 - 1, w - 8, 2):Color(lia.color.theme.theme):Draw() end
        end

        option.DoClick = function()
            self.selected = choice.text
            if self.convar then RunConsoleCommand(self.convar, tostring(choice.data or choice.text)) end
            self:CloseMenu()
            if self.OnSelect then self.OnSelect(i, choice.text, choice.data) end
            surface.PlaySound('button_click.wav')
        end
    end

    self.opened = true
    local oldMouseDown = false
    self.menu.Think = function()
        if not self.menu:IsVisible() then return end
        local mouseDown = input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)
        if mouseDown and not oldMouseDown then
            local mx, my = gui.MousePos()
            local menuX, menuY = self.menu:LocalToScreen(0, 0)
            if not (mx >= menuX and mx <= menuX + self.menu:GetWide() and my >= menuY and my <= menuY + self.menu:GetTall()) then self:CloseMenu() end
        end

        oldMouseDown = mouseDown
    end

    self.menu.OnRemove = function() self.opened = false end
end

function PANEL:CloseMenu()
    if IsValid(self.menu) then self.menu:Remove() end
    self.opened = false
end

function PANEL:OnRemove()
    self:CloseMenu()
end

function PANEL:GetOptionData(index)
    return self.choices[index] and self.choices[index].data or nil
end

function PANEL:SetConVar(cvar)
    self.convar = cvar
end

function PANEL:GetSelectedID()
    if not self.selected then return nil end
    for i, choice in ipairs(self.choices) do
        if choice.text == self.selected then return i end
    end
end

function PANEL:GetSelectedData()
    local id = self:GetSelectedID()
    return id and self:GetOptionData(id) or nil
end

function PANEL:GetSelectedText()
    return self.selected
end

function PANEL:IsMenuOpen()
    return self.opened
end

vgui.Register('liaComboBox', PANEL, 'Panel')
