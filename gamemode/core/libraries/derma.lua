lia.derma = lia.derma or {}
local color_disconnect = Color(210, 65, 65)
local color_bot = Color(70, 150, 220)
local color_online = Color(120, 180, 70)
local color_close = Color(210, 65, 65)
local color_accept = Color(44, 124, 62)
local color_outline = Color(30, 30, 30)
local color_target = Color(255, 255, 255, 200)
function lia.derma.derma_menu()
    if IsValid(lia.derma.menu_derma_menu) then lia.derma.menu_derma_menu:CloseMenu() end
    local mouseX, mouseY = input.GetCursorPos()
    local m = vgui.Create('MantleDermaMenu')
    m:SetPos(mouseX, mouseY)
    ClampMenuPosition(m)
    lia.derma.menu_derma_menu = m
    return m
end

function lia.derma.color_picker(func, color_standart)
    if IsValid(lia.derma.menu_color_picker) then lia.derma.menu_color_picker:Remove() end
    local selected_color = color_standart or Color(255, 255, 255)
    local hue = 0
    local saturation = 1
    local value = 1
    if color_standart then
        local r, g, b = color_standart.r / 255, color_standart.g / 255, color_standart.b / 255
        local h, s, v = ColorToHSV(Color(r * 255, g * 255, b * 255))
        hue = h
        saturation = s
        value = v
    end

    lia.derma.menu_color_picker = vgui.Create('MantleFrame')
    lia.derma.menu_color_picker:SetSize(300, 378)
    lia.derma.menu_color_picker:Center()
    lia.derma.menu_color_picker:MakePopup()
    lia.derma.menu_color_picker:SetTitle('')
    lia.derma.menu_color_picker:SetCenterTitle('Выбор цвета')
    local container = vgui.Create('Panel', lia.derma.menu_color_picker)
    container:Dock(FILL)
    container:DockMargin(10, 10, 10, 10)
    container.Paint = nil
    local preview = vgui.Create('Panel', container)
    preview:Dock(TOP)
    preview:SetTall(40)
    preview:DockMargin(0, 0, 0, 10)
    preview.Paint = function(self, w, h)
        lia.rndx.Rect(2, 2, w - 4, h - 4):Rad(16):Color(lia.color.theme.window_shadow):Shape(lia.rndx.SHAPE_IOS):Shadow(5, 20):Draw()
        lia.rndx.Draw(16, 2, 2, w - 4, h - 4, selected_color, lia.rndx.SHAPE_IOS)
    end

    local colorField = vgui.Create('Panel', container)
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
            surface.PlaySound('mantle/btn_click.ogg')
        end
    end

    colorField.OnMouseReleased = function(self, keyCode) if keyCode == MOUSE_LEFT then isDraggingColor = false end end
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

    colorField.Paint = function(self, w, h)
        local segments = 80
        local segmentSize = w / segments
        lia.rndx.Rect(0, 0, w, h):Color(lia.color.theme.window_shadow):Shape(lia.rndx.SHAPE_IOS):Shadow(5, 20):Draw()
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

        lia.rndx.Circle(colorCursor.x, colorCursor.y, 12):Outline(2):Color(color_target):Draw()
    end

    local hueSlider = vgui.Create('Panel', container)
    hueSlider:Dock(TOP)
    hueSlider:SetTall(20)
    hueSlider:DockMargin(0, 0, 0, 10)
    local huePos = 0
    local isDraggingHue = false
    hueSlider.OnMousePressed = function(self, keyCode)
        if keyCode == MOUSE_LEFT then
            isDraggingHue = true
            self:OnCursorMoved(self:CursorPos())
            surface.PlaySound('mantle/btn_click.ogg')
        end
    end

    hueSlider.OnMouseReleased = function(self, keyCode) if keyCode == MOUSE_LEFT then isDraggingHue = false end end
    hueSlider.OnCursorMoved = function(self, x, y)
        if isDraggingHue then
            local w = self:GetWide()
            x = math.Clamp(x, 0, w)
            huePos = x
            hue = (x / w) * 360
            selected_color = HSVToColor(hue, saturation, value)
        end
    end

    hueSlider.Paint = function(self, w, h)
        local segments = 100
        local segmentWidth = w / segments
        lia.rndx.Rect(0, 0, w, h):Color(lia.color.theme.window_shadow):Shape(lia.rndx.SHAPE_IOS):Shadow(5, 20):Draw()
        for i = 0, segments - 1 do
            local hueVal = (i / segments) * 360
            local x = i * segmentWidth
            surface.SetDrawColor(HSVToColor(hueVal, 1, 1))
            surface.DrawRect(x, 1, segmentWidth + 1, h - 2)
        end

        lia.rndx.Rect(huePos - 2, 0, 4, h):Color(color_target):Draw()
    end

    local rgbContainer = vgui.Create('Panel', container)
    rgbContainer:Dock(TOP)
    rgbContainer:SetTall(60)
    rgbContainer:DockMargin(0, 0, 0, 10)
    rgbContainer.Paint = nil
    local btnContainer = vgui.Create('Panel', container)
    btnContainer:Dock(BOTTOM)
    btnContainer:SetTall(30)
    btnContainer.Paint = nil
    local btnClose = vgui.Create('MantleBtn', btnContainer)
    btnClose:Dock(LEFT)
    btnClose:SetWide(90)
    btnClose:SetTxt('Отмена')
    btnClose:SetColorHover(color_close)
    btnClose.DoClick = function()
        lia.derma.menu_color_picker:Remove()
        surface.PlaySound('mantle/btn_click.ogg')
    end

    local btnSelect = vgui.Create('MantleBtn', btnContainer)
    btnSelect:Dock(RIGHT)
    btnSelect:SetWide(90)
    btnSelect:SetTxt('Выбрать')
    btnSelect:SetColorHover(color_accept)
    btnSelect.DoClick = function()
        surface.PlaySound('mantle/btn_click.ogg')
        func(selected_color)
        lia.derma.menu_color_picker:Remove()
    end

    timer.Simple(0, function()
        if IsValid(colorField) and IsValid(hueSlider) then
            colorCursor.x = saturation * colorField:GetWide()
            colorCursor.y = (1 - value) * colorField:GetTall()
            huePos = (hue / 360) * hueSlider:GetWide()
        end
    end)

    timer.Simple(0.1, function() lia.derma.menu_color_picker:SetAlpha(255) end)
end

function lia.derma.player_selector(do_click, func_check)
    if IsValid(lia.derma.menu_player_selector) then lia.derma.menu_player_selector:Remove() end
    lia.derma.menu_player_selector = vgui.Create('MantleFrame')
    lia.derma.menu_player_selector:SetSize(340, 398)
    lia.derma.menu_player_selector:Center()
    lia.derma.menu_player_selector:MakePopup()
    lia.derma.menu_player_selector:SetTitle('')
    lia.derma.menu_player_selector:SetCenterTitle('Выбор игрока')
    lia.derma.menu_player_selector:ShowAnimation()
    local contentPanel = vgui.Create('Panel', lia.derma.menu_player_selector)
    contentPanel:Dock(FILL)
    contentPanel:DockMargin(8, 0, 8, 8)
    lia.derma.menu_player_selector.sp = vgui.Create('MantleScrollPanel', contentPanel)
    lia.derma.menu_player_selector.sp:Dock(FILL)
    local CARD_HEIGHT = 44
    local AVATAR_SIZE = 32
    local AVATAR_X = 14
    local function CreatePlayerCard(pl)
        local card = vgui.Create('DButton', lia.derma.menu_player_selector.sp)
        card:Dock(TOP)
        card:DockMargin(0, 5, 0, 0)
        card:SetTall(CARD_HEIGHT)
        card:SetText('')
        card.hover_status = 0
        card.OnCursorEntered = function(self) self:SetCursor('hand') end
        card.OnCursorExited = function(self) self:SetCursor('arrow') end
        card.Think = function(self)
            if self:IsHovered() then
                self.hover_status = math.Clamp(self.hover_status + 4 * FrameTime(), 0, 1)
            else
                self.hover_status = math.Clamp(self.hover_status - 8 * FrameTime(), 0, 1)
            end
        end

        card.DoClick = function()
            if IsValid(pl) then
                surface.PlaySound('mantle/btn_click.ogg')
                do_click(pl)
            end

            lia.derma.menu_player_selector:Remove()
        end

        card.Paint = function(self, w, h)
            lia.rndx.Rect(0, 0, w, h):Rad(10):Color(lia.color.theme.panel[1]):Shape(lia.rndx.SHAPE_IOS):Draw()
            if self.hover_status > 0 then lia.rndx.Rect(0, 0, w, h):Rad(10):Color(Color(0, 0, 0, 40 * self.hover_status)):Shape(lia.rndx.SHAPE_IOS):Draw() end
            local infoX = AVATAR_X + AVATAR_SIZE + 10
            if not IsValid(pl) then
                draw.SimpleText('Вышел', 'Fated.18', infoX, h * 0.5, color_disconnect, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                return
            end

            draw.SimpleText(pl:Name(), 'Fated.18', infoX, 6, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            local group = pl:GetUserGroup() or 'user'
            group = string.upper(string.sub(group, 1, 1)) .. string.sub(group, 2)
            draw.SimpleText(group, 'Fated.14', infoX, h - 6, lia.color.theme.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(pl:Ping() .. ' мс', 'Fated.16', w - 20, h - 6, lia.color.theme.gray, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            local statusColor = color_disconnect
            if pl:IsBot() then
                statusColor = color_bot
            else
                statusColor = color_online
            end

            lia.rndx.DrawCircle(w - 24, 14, 12, statusColor)
        end

        local avatarImg = vgui.Create('AvatarImage', card)
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

    lia.derma.menu_player_selector.btn_close = vgui.Create('MantleBtn', lia.derma.menu_player_selector)
    lia.derma.menu_player_selector.btn_close:Dock(BOTTOM)
    lia.derma.menu_player_selector.btn_close:DockMargin(16, 8, 16, 12)
    lia.derma.menu_player_selector.btn_close:SetTall(36)
    lia.derma.menu_player_selector.btn_close:SetTxt('Закрыть')
    lia.derma.menu_player_selector.btn_close:SetColorHover(color_disconnect)
    lia.derma.menu_player_selector.btn_close.DoClick = function() lia.derma.menu_player_selector:Remove() end
end

local color_accept = Color(35, 103, 51)
function lia.derma.text_box(title, desc, func)
    lia.derma.menu_text_box = vgui.Create('MantleFrame')
    lia.derma.menu_text_box:SetSize(300, 132)
    lia.derma.menu_text_box:Center()
    lia.derma.menu_text_box:MakePopup()
    lia.derma.menu_text_box:SetTitle(title)
    lia.derma.menu_text_box:ShowAnimation()
    lia.derma.menu_text_box:DockPadding(12, 30, 12, 12)
    local entry = vgui.Create('MantleEntry', lia.derma.menu_text_box)
    entry:Dock(TOP)
    entry:SetTitle(desc)
    local function apply_func()
        func(entry:GetValue())
        lia.derma.menu_text_box:Remove()
    end

    entry.OnEnter = function() apply_func() end
    local btn_accept = vgui.Create('MantleBtn', lia.derma.menu_text_box)
    btn_accept:Dock(BOTTOM)
    btn_accept:SetTall(30)
    btn_accept:SetTxt('Применить')
    btn_accept:SetColorHover(color_accept)
    btn_accept.DoClick = function()
        surface.PlaySound('mantle/btn_click.ogg')
        apply_func()
    end
end