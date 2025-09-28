local PANEL = {}

function PANEL:Init()
    self.tabs = {}
    self.active_id = 1
    self.tab_height = 38
    self.animation_speed = 8
    self.tab_style = 'modern' -- modern или classic
    self.indicator_height = 2

    self.panel_tabs = vgui.Create('Panel', self)
    self.panel_tabs.Paint = nil

    self.content = vgui.Create('Panel', self)
    self.content.Paint = nil
end

function PANEL:SetTabStyle(style)
    self.tab_style = style
    self:Rebuild()
end

function PANEL:SetTabHeight(height)
    self.tab_height = height
    self:Rebuild()
end

function PANEL:SetIndicatorHeight(height)
    self.indicator_height = height
    self:Rebuild()
end

function PANEL:AddTab(name, pan, icon)
    local newId = #self.tabs + 1

    self.tabs[newId] = {
        name = name,
        pan = pan,
        icon = icon
    }

    self.tabs[newId].pan:SetParent(self.content)
    self.tabs[newId].pan:Dock(FILL)
    self.tabs[newId].pan:SetVisible(newId == 1 and true or false)

    self:Rebuild()
end

local color_btn_hovered = Color(255, 255, 255, 10)

function PANEL:Rebuild()
    self.panel_tabs:Clear()

    for id, tab in ipairs(self.tabs) do
        local btnTab = vgui.Create('Button', self.panel_tabs)
        if self.tab_style == 'modern' then
            surface.SetFont('Fated.18')
            local textW = select(1, surface.GetTextSize(tab.name))
            local iconW = tab.icon and 16 or 0
            local iconTextGap = tab.icon and 8 or 0
            local padding = 16
            local btnWidth = padding + iconW + iconTextGap + textW + padding
            btnTab:Dock(LEFT)
            btnTab:DockMargin(0, 0, 6, 0)
            btnTab:SetTall(34)
            btnTab:SetWide(btnWidth)
        else
            btnTab:Dock(TOP)
            btnTab:DockMargin(0, 0, 0, 6)
            btnTab:SetTall(34)
        end

        btnTab:SetText('')
        btnTab.DoClick = function()
            self.tabs[self.active_id].pan:SetVisible(false)
            tab.pan:SetVisible(true)
            self.active_id = id

            surface.PlaySound('mantle/btn_click.ogg')
        end
        btnTab.DoRightClick = function()
            local dm = lia.derma.derma_menu()
            for k, tab in pairs(self.tabs) do
                dm:AddOption(tab.name, function()
                    self.tabs[self.active_id].pan:SetVisible(false)
                    tab.pan:SetVisible(true)
                    self.active_id = k
                end, tab.icon)
            end
        end

        btnTab.Paint = function(s, w, h)
            local isActive = self.active_id == id
            local colorText = isActive and lia.color.theme.theme or lia.color.theme.text
            local colorIcon = isActive and lia.color.theme.theme or color_white

            if self.tab_style == 'modern' then
                -- Современный стиль с индикатором внизу
                if s:IsHovered() then
                    lia.rndx.Draw(16, 0, 0, w, h, color_btn_hovered, lia.rndx.SHAPE_IOS + (isActive and lia.rndx.NO_BL + lia.rndx.NO_BR or 0))
                end

                if isActive then
                    lia.rndx.Draw(0, 0, h - self.indicator_height, w, self.indicator_height, lia.color.theme.theme)
                end

                local padding = 16
                local iconW = tab.icon and 16 or 0
                local iconTextGap = tab.icon and 8 or 0
                local textX = padding + (iconW > 0 and (iconW + iconTextGap) or 0)

                if tab.icon then
                    lia.rndx.DrawMaterial(0, padding, (h - 16) * 0.5, 16, 16, colorIcon, tab.icon)
                end

                draw.SimpleText(tab.name, 'Fated.18', textX, h * 0.5, colorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                if s:IsHovered() then
                    lia.rndx.Draw(24, 0, 0, w, h, color_btn_hovered, lia.rndx.SHAPE_IOS)
                end

                draw.SimpleText(tab.name, 'Fated.18', 34, h * 0.5 - 1, colorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                if tab.icon then
                    lia.rndx.DrawMaterial(0, 9, 9, 16, 16, colorIcon, tab.icon)
                else
                    lia.rndx.Draw(24, 9, 9, 16, 16, colorIcon, lia.rndx.SHAPE_IOS)
                end
            end
        end
    end
end

function PANEL:PerformLayout(w, h)
    if self.tab_style == 'modern' then
        self.panel_tabs:Dock(TOP)
        self.panel_tabs:DockMargin(0, 0, 0, 4)
        self.panel_tabs:SetTall(self.tab_height)
    else
        self.panel_tabs:Dock(LEFT)
        self.panel_tabs:DockMargin(0, 0, 4, 0)
        self.panel_tabs:SetWide(190)
    end

    self.content:Dock(FILL)
end

vgui.Register('liaTabs', PANEL, 'Panel')
