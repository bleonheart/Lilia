local PANEL = {}
function PANEL:Init()
    self.choices = {}
    self.selected = nil
    self.opened = false
    self:SetTall(26)
    self:SetText('')
    self.font = 'Fated.18'
    self.hoverAnim = 0
    self.OnSelect = function(_, _, _) end
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

        lia.rndx.Rect(0, 0, w, h):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.rndx.SHAPE_IOS):Shadow(5, 20):Draw()
        lia.rndx.Draw(16, 0, 0, w, h, lia.color.theme.focus_panel, lia.rndx.SHAPE_IOS)
        if self.hoverAnim > 0 then lia.rndx.Rect(0, 0, w, h):Rad(16):Color(Color(lia.color.theme.button_hovered.r, lia.color.theme.button_hovered.g, lia.color.theme.button_hovered.b, self.hoverAnim * 255)):Shape(lia.rndx.SHAPE_IOS):Draw() end
        draw.SimpleText(self.selected or self.placeholder or 'Выберите...', self.font, 12, h * 0.5, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
            surface.PlaySound('mantle/btn_click.ogg')
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

function PANEL:GetValue()
    return self.selected
end

function PANEL:SetPlaceholder(text)
    self.placeholder = text
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
    self.menu.Paint = function(s, w, h)
        lia.rndx.Rect(0, 0, w, h):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.rndx.SHAPE_IOS):Shadow(10, 16):Draw()
        lia.rndx.Rect(0, 0, w, h):Rad(16):Color(lia.color.theme.background_panelpopup):Shape(lia.rndx.SHAPE_IOS):Draw()
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
            if s:IsHovered() then lia.rndx.Draw(16, 0, 0, w, h, lia.color.theme.hover, lia.rndx.SHAPE_IOS) end
            draw.SimpleText(choice.text, 'Fated.18', 14, h * 0.5, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if self.selected == choice.text then lia.rndx.Draw(0, 4, h * 0.5 - 1, 4, 2, lia.color.theme.theme) end
        end

        option.DoClick = function()
            self.selected = choice.text
            self:CloseMenu()
            if self.OnSelect then self.OnSelect(i, choice.text, choice.data) end
            surface.PlaySound('mantle/btn_click.ogg')
        end
    end

    self.opened = true
    local oldMouseDown = false
    self.menu.Think = function()
        if not self.menu:IsVisible() then return end
        local mouseDown = input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)
        if mouseDown and not oldMouseDown then
            local mx, my = gui.MousePos()
            local x, y = self.menu:LocalToScreen(0, 0)
            if not (mx >= x and mx <= x + self.menu:GetWide() and my >= y and my <= y + self.menu:GetTall()) then self:CloseMenu() end
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

vgui.Register('liaComboBox', PANEL, 'Panel')