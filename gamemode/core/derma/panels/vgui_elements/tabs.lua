local PANEL = {}
function PANEL:Init()
    self.tabs = {}
    self.active_id = 1
    self.tab_height = 38
    self.animation_speed = 8
    self.tab_style = 'modern' -- modern or classic
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

function PANEL:AddSheet(label, panel, material)
    local newId = #self.tabs + 1
    self:AddTab(label, panel, material)
    return {
        Button = self.panel_tabs:GetChildren()[newId],
        Panel = panel
    }
end

local color_btn_hovered = Color(255, 255, 255, 10)
function PANEL:Rebuild()
    self.panel_tabs:Clear()
    for id, tab in ipairs(self.tabs) do
        local btnTab = vgui.Create('Button', self.panel_tabs)
        if self.tab_style == 'modern' then
            surface.SetFont('Fated.18')
            local textW = surface.GetTextSize(tab.name)
            local iconW = tab.icon and 16 or 0
            local iconTextGap = tab.icon and 8 or 0
            local padding = 16
            local minWidth = 80 -- Minimum tab width
            local btnWidth = math.max(minWidth, padding + iconW + iconTextGap + textW + padding)
            btnTab:Dock(LEFT)
            btnTab:DockMargin(0, 0, 6, 0)
            btnTab:SetTall(34)
            btnTab:SetWide(btnWidth)
        else
            -- Calculate width for classic style based on text
            surface.SetFont('Fated.18')
            local textW = surface.GetTextSize(tab.name)
            local iconW = tab.icon and 16 or 0
            local iconTextGap = tab.icon and 8 or 0
            local padding = 16
            local minWidth = 120 -- Minimum tab width for classic style
            local btnWidth = math.max(minWidth, padding + iconW + iconTextGap + textW + padding)
            btnTab:Dock(TOP)
            btnTab:DockMargin(0, 0, 0, 6)
            btnTab:SetTall(34)
            btnTab:SetWide(btnWidth)
        end

        btnTab:SetText('')
        btnTab.DoClick = function()
            self.tabs[self.active_id].pan:SetVisible(false)
            tab.pan:SetVisible(true)
            self.active_id = id
            surface.PlaySound('button_click.wav')
        end

        btnTab.DoRightClick = function()
            local dm = lia.derma.derma_menu()
            for k, v in pairs(self.tabs) do
                dm:AddOption(v.name, function()
                    self.tabs[self.active_id].pan:SetVisible(false)
                    v.pan:SetVisible(true)
                    self.active_id = k
                end, v.icon)
            end
        end

        btnTab.Paint = function(s, w, h)
            local isActive = self.active_id == id
            local colorText = isActive and lia.color.theme.theme or lia.color.theme.text
            local colorIcon = isActive and lia.color.theme.theme or color_white
            if self.tab_style == 'modern' then
                if s:IsHovered() then lia.derma.rect(0, 0, w, h):Rad(16):Color(color_btn_hovered):Shape(lia.derma.SHAPE_IOS + (isActive and ((lia.derma.NO_BL or 0) + (lia.derma.NO_BR or 0)) or 0)):Draw() end
                if isActive then lia.derma.rect(0, h - self.indicator_height, w, self.indicator_height):Color(lia.color.theme.theme):Draw() end
                local padding = 16
                local iconW = tab.icon and 16 or 0
                local iconTextGap = tab.icon and 8 or 0
                local textX = padding + (iconW > 0 and (iconW + iconTextGap) or 0)
                if tab.icon then lia.derma.drawMaterial(0, padding, (h - 16) * 0.5, 16, 16, colorIcon, tab.icon) end
                draw.SimpleText(tab.name, 'Fated.18', textX, h * 0.5, colorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                if s:IsHovered() then lia.derma.rect(0, 0, w, h):Rad(24):Color(color_btn_hovered):Shape(lia.derma.SHAPE_IOS):Draw() end
                draw.SimpleText(tab.name, 'Fated.18', 34, h * 0.5 - 1, colorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if tab.icon then
                    lia.derma.drawMaterial(0, 9, 9, 16, 16, colorIcon, tab.icon)
                else
                    lia.derma.rect(9, 9, 16, 16):Rad(24):Color(colorIcon):Shape(lia.derma.SHAPE_IOS):Draw()
                end
            end
        end
    end
end

function PANEL:PerformLayout()
    if self.tab_style == 'modern' then
        self.panel_tabs:Dock(TOP)
        self.panel_tabs:DockMargin(0, 0, 0, 4)
        self.panel_tabs:SetTall(self.tab_height)
    else
        self.panel_tabs:Dock(LEFT)
        self.panel_tabs:DockMargin(0, 0, 4, 0)
        -- Calculate the maximum width needed for all tabs
        local maxWidth = 0
        for _, tab in ipairs(self.tabs) do
            surface.SetFont('Fated.18')
            local textW = surface.GetTextSize(tab.name)
            local iconW = tab.icon and 16 or 0
            local iconTextGap = tab.icon and 8 or 0
            local padding = 16
            local minWidth = 120
            local btnWidth = math.max(minWidth, padding + iconW + iconTextGap + textW + padding)
            maxWidth = math.max(maxWidth, btnWidth)
        end
        self.panel_tabs:SetWide(math.max(190, maxWidth))
    end

    self.content:Dock(FILL)
end

function PANEL:SetActiveTab(tab)
    if type(tab) == 'number' then
        if not self.tabs[tab] then return end
        if self.tabs[self.active_id] and IsValid(self.tabs[self.active_id].pan) then self.tabs[self.active_id].pan:SetVisible(false) end
        if IsValid(self.tabs[tab].pan) then self.tabs[tab].pan:SetVisible(true) end
        self.active_id = tab
        local button = self.panel_tabs:GetChild(tab)
        if IsValid(button) then self.m_pActiveTab = button end
    else
        for id, data in ipairs(self.tabs) do
            if data.pan == tab or self.panel_tabs:GetChild(id) == tab then
                self:SetActiveTab(id)
                break
            end
        end
    end
end

function PANEL:GetActiveTab()
    return self.panel_tabs:GetChild(self.active_id)
end

function PANEL:CloseTab(tab)
    local id
    if type(tab) == 'number' then
        id = tab
    else
        for k, data in ipairs(self.tabs) do
            if data.pan == tab or self.panel_tabs:GetChild(k) == tab then
                id = k
                break
            end
        end
    end

    if not id or not self.tabs[id] then return end
    local panel = self.tabs[id].pan
    if IsValid(panel) then panel:Remove() end
    table.remove(self.tabs, id)
    self.active_id = math.Clamp(self.active_id, 1, #self.tabs)
    self:Rebuild()
end

function PANEL:SetFadeTime()
end

function PANEL:SetShowIcons()
end

vgui.Register('liaTabs', PANEL, 'Panel')