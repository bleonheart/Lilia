local PANEL = {}
local math_abs = math.abs
local math_cos = math.cos
local math_sin = math.sin
local math_atan2 = math.atan2
local math_sqrt = math.sqrt
local math_min = math.min
local math_max = math.max
local math_floor = math.floor
local math_ceil = math.ceil
local math_rad = math.rad
local math_pi = math.pi
local twoPi = math_pi * 2
local halfPi = math_pi * 0.5
function PANEL:Init(options)
    options = options or {}
    self.options = {}
    self.menuStack = {}
    self.currentMenu = nil
    self.optionAnimations = {}
    self.scale = math.Clamp(math_min(ScrW() / 1920, ScrH() / 1080), 0.72, 1.35)
    self.baseRadius = options.radius or 320
    self.baseInnerRadius = options.inner_radius or 92
    self.radius = self.baseRadius * self.scale
    self.innerRadius = self.baseInnerRadius * self.scale
    self.paddingScale = ScrW() <= 1280 and 1.15 or 1
    self.sectorGap = math_rad(options.sector_gap or 0.03)
    self.hoverExpansion = (options.hover_expansion or 3) * self.scale
    self.railOffset = 0
    self.backgroundDarkness = options.background_darkness or 92
    self.selectedOption = nil
    self.hoverOption = nil
    self.centerText = "Menu"
    self.centerDesc = "Select Option"
    self.font = "LiliaFont.24"
    self.descFont = "LiliaFont.16"
    self.titleFont = "LiliaFont.28"
    self.blurStart = SysTime()
    self.fadeInTime = options.fade_in_time or 0.22
    self.currentAlpha = 0
    self.scaleAnim = 0
    self.disable_background = options.disable_background or false
    self.background_blur = options.background_blur ~= false
    self.hover_sound = options.hover_sound or "ratio_button.wav"
    self.scale_animation = options.scale_animation ~= false
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
    self:SetDrawOnTop(true)
    self:SetMouseInputEnabled(true)
    self._mouseWasDown = false
    self.Think = function()
        if self.closeKey and not input.IsKeyDown(self.closeKey) then
            self:Remove()
            return
        end

        local progress = math.Clamp((SysTime() - self.blurStart) / self.fadeInTime, 0, 1)
        self.currentAlpha = 255 * progress
        if self.scale_animation then
            local eased = 1 - (1 - progress) ^ 3
            self.scaleAnim = 0.88 + eased * 0.12
        else
            self.scaleAnim = 1
        end

        local mouseX, mouseY = self:CursorPos()
        local hovered = self:GetOptionIndexAtPosition(mouseX, mouseY)
        if self.hoverOption ~= hovered and hovered and self.hover_sound then surface.PlaySound(self.hover_sound) end
        self.hoverOption = hovered
        local animationSpeed = math.Clamp(FrameTime() * 14, 0, 1)
        local currentOptions = self:GetCurrentOptions()
        for i = 1, #currentOptions do
            local target = hovered == i and 1 or 0
            self.optionAnimations[i] = Lerp(animationSpeed, self.optionAnimations[i] or 0, target)
        end

        local mouseDown = input.IsMouseDown(MOUSE_LEFT)
        if mouseDown and not self._mouseWasDown then
            local centerX, centerY = ScrW() / 2, ScrH() / 2
            local radius, innerRadius = self:GetCurrentRadii()
            local dist = math_sqrt((mouseX - centerX) ^ 2 + (mouseY - centerY) ^ 2)
            if hovered then
                self:SelectOption(hovered)
                lia.websound.playButtonSound()
            elseif dist <= innerRadius then
                if #self.menuStack > 0 then
                    self:GoBack()
                    lia.websound.playButtonSound()
                else
                    self:Remove()
                end
            elseif dist >= radius + self.hoverExpansion then
                self:Remove()
            end
        end

        self._mouseWasDown = mouseDown
    end
end

function PANEL:GetAdaptiveRadiusMultiplier(optionCount)
    if optionCount <= 1 then return 0.92 end
    if optionCount == 2 then return 1 end
    if optionCount == 3 then return 1.02 end
    if optionCount == 4 then return 1.04 end
    return 1.06
end

function PANEL:GetCurrentRadii()
    local optionCount = #self:GetCurrentOptions()
    return self.radius * self:GetAdaptiveRadiusMultiplier(optionCount), self.innerRadius
end

function PANEL:GetSectorGeometry(index, optionCount)
    if optionCount <= 0 then return 0, 0, 0 end
    local sectorSize = twoPi / optionCount
    local midAngle = -halfPi + (index - 1) * sectorSize
    return midAngle - sectorSize * 0.5, midAngle, midAngle + sectorSize * 0.5
end

function PANEL:GetVisualSectorGeometry(index, optionCount)
    local startAngle, midAngle, endAngle = self:GetSectorGeometry(index, optionCount)
    if optionCount <= 1 then return startAngle, midAngle, endAngle end
    local gap = math_min(self.sectorGap, (endAngle - startAngle) * 0.08)
    return startAngle + gap, midAngle, endAngle - gap
end

function PANEL:GetOptionIndexAtPosition(mouseX, mouseY)
    local centerX, centerY = ScrW() / 2, ScrH() / 2
    local radius, innerRadius = self:GetCurrentRadii()
    local dist = math_sqrt((mouseX - centerX) ^ 2 + (mouseY - centerY) ^ 2)
    if dist <= innerRadius or dist >= radius + self.hoverExpansion then return nil end
    local optionCount = #self:GetCurrentOptions()
    if optionCount <= 0 then return nil end
    local sectorSize = twoPi / optionCount
    local firstStart = -halfPi - sectorSize * 0.5
    local angle = math_atan2(mouseY - centerY, mouseX - centerX)
    local normalized = (angle - firstStart) % twoPi
    local index = math_floor(normalized / sectorSize) + 1
    if index < 1 or index > optionCount then return nil end
    return index
end

function PANEL:OnMousePressed()
    local mouseX, mouseY = self:CursorPos()
    local centerX, centerY = ScrW() / 2, ScrH() / 2
    local radius = self:GetCurrentRadii()
    local dist = math_sqrt((mouseX - centerX) ^ 2 + (mouseY - centerY) ^ 2)
    if dist <= radius + self.hoverExpansion then return self:MouseCapture(true) end
    self:Remove()
    return true
end

function PANEL:OnMouseReleased()
    self:MouseCapture(false)
end

function PANEL:Paint(w, h)
    local centerX, centerY = ScrW() / 2, ScrH() / 2
    local alpha = self.currentAlpha / 255
    local isLight = lia.color.getCurrentTheme() == "light"
    local textColor = isLight and Color(28, 31, 31) or color_white
    local inactiveTextColor = isLight and Color(45, 49, 49) or Color(225, 232, 232)
    local selectedColor = Color(92, 214, 138)
    local ringColor = isLight and Color(232, 237, 237) or Color(11, 17, 18)
    local centerColor = isLight and Color(245, 248, 248) or Color(12, 21, 21)
    local radius, innerRadius = self:GetCurrentRadii()
    local currentRadius = radius * self.scaleAnim
    local currentInnerRadius = innerRadius * self.scaleAnim
    local currentOptions = self:GetCurrentOptions()
    local optionCount = #currentOptions
    if not self.disable_background then
        if self.background_blur and Derma_DrawBackgroundBlur then Derma_DrawBackgroundBlur(self, self.blurStart) end
        lia.derma.rect(0, 0, w, h):Color(Color(0, 0, 0, self.backgroundDarkness * alpha)):Shape(lia.derma.SHAPE_RECT):Draw()
    end

    BShadows.BeginShadow()
    lia.derma.circle(centerX, centerY, currentRadius * 2):Color(ColorAlpha(ringColor, 248 * alpha)):Draw()
    BShadows.EndShadow(2, 4, 9, 185 * alpha, 0, 0)
    if optionCount > 0 then
        for i, option in ipairs(currentOptions) do
            local startAngle, _, endAngle = self:GetVisualSectorGeometry(i, optionCount)
            local hoverAmount = self.optionAnimations[i] or 0
            local isSelected = option.selected == true or (not self.currentMenu and self.selectedOption == i)
            local outerRadius = currentRadius - 2 * self.scale * self.scaleAnim
            local innerSectorRadius = currentInnerRadius + 2 * self.scale * self.scaleAnim
            if isSelected then self:DrawSector(centerX, centerY, innerSectorRadius, outerRadius, startAngle, endAngle, ColorAlpha(selectedColor, 22 * alpha)) end
            if hoverAmount > 0.001 then self:DrawSector(centerX, centerY, innerSectorRadius, outerRadius, startAngle, endAngle, ColorAlpha(lia.color.theme.theme, 48 * hoverAmount * alpha)) end
        end

        local separatorColor = isLight and Color(38, 44, 44, 54 * alpha) or Color(112, 128, 128, 62 * alpha)
        for i = 1, optionCount do
            local startAngle = self:GetSectorGeometry(i, optionCount)
            self:DrawRadialLine(centerX, centerY, currentInnerRadius + 2 * self.scale, currentRadius - 2 * self.scale, startAngle, separatorColor, 1)
        end

        self:DrawCircleOutline(centerX, centerY, currentRadius, ColorAlpha(lia.color.theme.theme, (isLight and 96 or 82) * alpha), 1)
        for i, option in ipairs(currentOptions) do
            local startAngle, _, endAngle = self:GetVisualSectorGeometry(i, optionCount)
            local hoverAmount = self.optionAnimations[i] or 0
            local isSelected = option.selected == true or (not self.currentMenu and self.selectedOption == i)
            if isSelected then self:DrawArcOutline(centerX, centerY, currentRadius, startAngle, endAngle, ColorAlpha(selectedColor, 190 * alpha), 2) end
            if hoverAmount > 0.001 then self:DrawArcOutline(centerX, centerY, currentRadius, startAngle, endAngle, ColorAlpha(lia.color.theme.theme, 255 * hoverAmount * alpha), 2) end
        end
    end

    BShadows.BeginShadow()
    lia.derma.circle(centerX, centerY, currentInnerRadius * 2):Color(ColorAlpha(centerColor, 250 * alpha)):Draw()
    BShadows.EndShadow(1, 2, 4, (isLight and 105 or 165) * alpha, 0, 0)
    if optionCount > 0 then
        local ringWidth = currentRadius - currentInnerRadius
        local labelRadius = currentInnerRadius + ringWidth * 0.62
        local contentScale = self.scale * self.scaleAnim
        for i, option in ipairs(currentOptions) do
            local _, midAngle = self:GetVisualSectorGeometry(i, optionCount)
            local hoverAmount = self.optionAnimations[i] or 0
            local isHovered = self.hoverOption == i
            local isSelected = option.selected == true or (not self.currentMenu and self.selectedOption == i)
            local animatedLabelRadius = labelRadius + self.hoverExpansion * hoverAmount
            local textX = centerX + animatedLabelRadius * math_cos(midAngle)
            local textY = centerY + animatedLabelRadius * math_sin(midAngle)
            local optionAlpha = (185 + 70 * hoverAmount) * alpha
            local optionTextColor = isHovered and ColorAlpha(color_white, 255 * alpha) or ColorAlpha(inactiveTextColor, optionAlpha)
            local showDesc = option.desc and option.desc ~= "" and optionCount <= 4
            local titleY = textY
            if option.icon and option.icon ~= false then
                option._iconMaterial = option._iconMaterial or Material(option.icon, "smooth")
                local iconBaseSize = optionCount >= 7 and 32 or optionCount >= 5 and 38 or 46
                local iconSize = iconBaseSize * contentScale * (1 + 0.1 * hoverAmount)
                local iconCenterY = textY - (showDesc and 34 or 25) * contentScale
                local iconColor = isHovered and ColorAlpha(lia.color.theme.theme, 255 * alpha) or ColorAlpha(color_white, optionAlpha)
                lia.derma.drawMaterial(0, textX - iconSize * 0.5, iconCenterY - iconSize * 0.5, iconSize, iconSize, iconColor, option._iconMaterial)
                titleY = textY + (showDesc and 12 or 15) * contentScale
            elseif showDesc then
                titleY = textY - 10 * contentScale
            end

            draw.SimpleText(option.text, self.font, textX, titleY, optionTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if showDesc then
                local descLines, descHeight = lia.util.wrapText(option.desc, math_min(175 * self.scale, ringWidth * 1.35), self.descFont, 2)
                local descY = titleY + 23 * contentScale
                for lineIndex = 1, math_min(#descLines, 2) do
                    draw.SimpleText(descLines[lineIndex], self.descFont, textX, descY, ColorAlpha(inactiveTextColor, (120 + 90 * hoverAmount) * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    descY = descY + descHeight
                end
            end

            local markerY = titleY + (showDesc and 49 or 27) * contentScale
            local markerWidth = (isHovered and 30 or 18) * contentScale
            local markerAlpha = isHovered and 225 * hoverAmount or 48
            local markerColor = isSelected and selectedColor or lia.color.theme.theme
            surface.SetDrawColor(ColorAlpha(markerColor, markerAlpha * alpha))
            surface.DrawLine(textX - markerWidth * 0.5, markerY, textX + markerWidth * 0.5, markerY)
            if isSelected then self:DrawSelectionCheck(textX, markerY + 13 * contentScale, 6 * self.scaleAnim, ColorAlpha(selectedColor, 235 * alpha)) end
        end
    end

    local mouseX, mouseY = self:CursorPos()
    local dist = math_sqrt((mouseX - centerX) ^ 2 + (mouseY - centerY) ^ 2)
    local isCenterHovered = dist <= currentInnerRadius
    local centerTitle = self.centerText
    local centerDesc = self.centerDesc
    local centerIcon
    local actionText
    if self.hoverOption and currentOptions[self.hoverOption] then
        local option = currentOptions[self.hoverOption]
        centerTitle = option.text or centerTitle
        centerDesc = option.desc or centerDesc
        if option.icon and option.icon ~= false then
            option._iconMaterial = option._iconMaterial or Material(option.icon, "smooth")
            centerIcon = option._iconMaterial
        end

        actionText = "LMB  SELECT"
    elseif #self.menuStack > 0 and isCenterHovered then
        centerTitle = "RETURN"
        centerDesc = "Return to previous menu"
        actionText = "LMB  RETURN"
    elseif isCenterHovered then
        actionText = "LMB  CLOSE"
    end

    self:DrawCenterContent(centerX, centerY, currentInnerRadius, centerTitle, centerDesc, textColor, alpha, centerIcon, actionText)
    if optionCount > 0 then
        local innerOutlineColor = self.hoverOption and ColorAlpha(lia.color.theme.theme, 175 * alpha) or ColorAlpha(lia.color.theme.theme, 78 * alpha)
        self:DrawCircleOutline(centerX, centerY, currentInnerRadius, innerOutlineColor, 1)
    end
end

function PANEL:DrawCenterContent(centerX, centerY, radius, title, desc, textColor, alpha, iconMaterial, actionText)
    local contentScale = self.scale * self.scaleAnim
    local maxWidth = radius * 1.58
    local titleLines, titleHeight = lia.util.wrapText(title or "", maxWidth, self.titleFont)
    local descLines, descHeight = lia.util.wrapText(desc or "", maxWidth * 0.95, self.descFont)
    local separatorGap = 10 * contentScale
    local iconSize = iconMaterial and math_min(32 * contentScale, radius * 0.32) or 0
    local iconGap = iconMaterial and 7 * contentScale or 0
    local descBlockHeight = #descLines > 0 and separatorGap + #descLines * descHeight or 0
    local contentHeight = iconSize + iconGap + #titleLines * titleHeight + descBlockHeight
    local actionReserve = actionText and actionText ~= "" and 24 * contentScale or 0
    local contentCenterY = centerY - actionReserve * 0.18
    local y = contentCenterY - contentHeight * 0.5
    if iconMaterial then
        lia.derma.drawMaterial(0, centerX - iconSize * 0.5, y, iconSize, iconSize, ColorAlpha(lia.color.theme.theme, 245 * alpha), iconMaterial)
        y = y + iconSize + iconGap
    end

    for _, line in ipairs(titleLines) do
        draw.SimpleText(line, self.titleFont, centerX, y + titleHeight * 0.5, ColorAlpha(textColor, self.currentAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        y = y + titleHeight
    end

    if #descLines > 0 then
        y = y + separatorGap * 0.35
        local separatorWidth = math_min(radius * 0.34, 34 * contentScale)
        surface.SetDrawColor(ColorAlpha(lia.color.theme.theme, 150 * alpha))
        surface.DrawLine(centerX - separatorWidth * 0.5, y, centerX + separatorWidth * 0.5, y)
        y = y + separatorGap * 0.65
        for _, line in ipairs(descLines) do
            draw.SimpleText(line, self.descFont, centerX, y + descHeight * 0.5, ColorAlpha(textColor, 172 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            y = y + descHeight
        end
    end

    if actionText and actionText ~= "" then
        local actionY = centerY + radius - 23 * contentScale
        local separatorWidth = math_min(radius * 0.33, 32 * contentScale)
        surface.SetDrawColor(ColorAlpha(lia.color.theme.theme, 72 * alpha))
        surface.DrawLine(centerX - separatorWidth * 0.5, actionY - 11 * contentScale, centerX + separatorWidth * 0.5, actionY - 11 * contentScale)
        draw.SimpleText(actionText, self.descFont, centerX, actionY, ColorAlpha(lia.color.theme.theme, 205 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:DrawSector(cx, cy, innerRadius, outerRadius, startAngle, endAngle, color)
    local span = endAngle - startAngle
    local segments = math_max(4, math_ceil(math_abs(span) / twoPi * 80))
    draw.NoTexture()
    surface.SetDrawColor(color)
    for i = 0, segments - 1 do
        local firstAngle = startAngle + span * (i / segments)
        local secondAngle = startAngle + span * ((i + 1) / segments)
        surface.DrawPoly({
            {
                x = cx + innerRadius * math_cos(firstAngle),
                y = cy + innerRadius * math_sin(firstAngle)
            },
            {
                x = cx + outerRadius * math_cos(firstAngle),
                y = cy + outerRadius * math_sin(firstAngle)
            },
            {
                x = cx + outerRadius * math_cos(secondAngle),
                y = cy + outerRadius * math_sin(secondAngle)
            },
            {
                x = cx + innerRadius * math_cos(secondAngle),
                y = cy + innerRadius * math_sin(secondAngle)
            }
        })
    end
end

function PANEL:DrawRadialLine(cx, cy, innerRadius, outerRadius, angle, color, thickness)
    thickness = thickness or 1
    surface.SetDrawColor(color)
    for i = 0, thickness - 1 do
        local offset = i - (thickness - 1) * 0.5
        local perpendicularX = -math_sin(angle) * offset
        local perpendicularY = math_cos(angle) * offset
        surface.DrawLine(cx + innerRadius * math_cos(angle) + perpendicularX, cy + innerRadius * math_sin(angle) + perpendicularY, cx + outerRadius * math_cos(angle) + perpendicularX, cy + outerRadius * math_sin(angle) + perpendicularY)
    end
end

function PANEL:DrawArcOutline(cx, cy, radius, startAngle, endAngle, color, thickness)
    local span = endAngle - startAngle
    local segments = math_max(8, math_ceil(math_abs(span) / twoPi * 112))
    surface.SetDrawColor(color)
    for layer = 0, (thickness or 1) - 1 do
        local arcRadius = radius - layer
        local lastX = cx + arcRadius * math_cos(startAngle)
        local lastY = cy + arcRadius * math_sin(startAngle)
        for i = 1, segments do
            local angle = startAngle + span * (i / segments)
            local x = cx + arcRadius * math_cos(angle)
            local y = cy + arcRadius * math_sin(angle)
            surface.DrawLine(lastX, lastY, x, y)
            lastX = x
            lastY = y
        end
    end
end

function PANEL:DrawSelectionCheck(cx, cy, radius, color)
    self:DrawCircleOutline(cx, cy, radius, color, 1)
    surface.SetDrawColor(color)
    surface.DrawLine(cx - radius * 0.45, cy, cx - radius * 0.08, cy + radius * 0.35)
    surface.DrawLine(cx - radius * 0.08, cy + radius * 0.35, cx + radius * 0.5, cy - radius * 0.4)
end

function PANEL:DrawCircleOutline(cx, cy, radius, color, thickness)
    local segments = 72
    thickness = thickness or 1
    surface.SetDrawColor(color)
    for layer = 0, thickness - 1 do
        local currentRadius = radius - layer
        local lastX = cx + currentRadius
        local lastY = cy
        for i = 1, segments do
            local angle = twoPi * (i / segments)
            local x = cx + currentRadius * math_cos(angle)
            local y = cy + currentRadius * math_sin(angle)
            surface.DrawLine(lastX, lastY, x, y)
            lastX = x
            lastY = y
        end
    end
end

function PANEL:AddOption(text, func, icon, desc, submenu, selected)
    table.insert(self.options, {
        text = text,
        func = func,
        icon = icon,
        desc = desc,
        submenu = submenu,
        selected = selected == true
    })
    return #self.options
end

function PANEL:SelectOption(index)
    local options = self:GetCurrentOptions()
    local option = options[index]
    if not option then return end
    if option.keepOpen then
        if option.func then option.func() end
    elseif option.submenu then
        table.insert(self.menuStack, self.currentMenu or false)
        self.currentMenu = option.submenu
        self:ResetHoverState()
        self:UpdateCenterText()
    elseif option.func then
        option.func()
        self:Remove()
    end
end

function PANEL:SetCloseKey(key)
    self.closeKey = key
end

function PANEL:SetSelectedOption(index)
    self.selectedOption = index
end

function PANEL:SetOptionSelected(index, selected)
    local options = self:GetCurrentOptions()
    if options[index] then options[index].selected = selected ~= false end
end

function PANEL:SetCenterText(title, desc)
    self.centerText = title or "Menu"
    self.centerDesc = desc or "Select Option"
end

function PANEL:IsMouseOver()
    local mouseX, mouseY = self:CursorPos()
    local centerX, centerY = ScrW() / 2, ScrH() / 2
    local radius = self:GetCurrentRadii()
    return math_sqrt((mouseX - centerX) ^ 2 + (mouseY - centerY) ^ 2) <= radius + self.railOffset + self.hoverExpansion
end

function PANEL:OnCursorMoved()
    if not self:IsMouseOver() then self.hoverOption = nil end
end

function PANEL:OnRemove()
    if lia.gui and lia.gui.menu_radial == self then lia.gui.menu_radial = nil end
end

function PANEL:GetCurrentOptions()
    if self.currentMenu then return self.currentMenu.options or {} end
    return self.options
end

function PANEL:ResetHoverState()
    self.hoverOption = nil
    self.optionAnimations = {}
end

function PANEL:GoBack()
    if #self.menuStack > 0 then
        self.currentMenu = table.remove(self.menuStack)
        self:ResetHoverState()
        self:UpdateCenterText()
    end
end

function PANEL:UpdateCenterText()
    if self.currentMenu then
        self.centerText = self.currentMenu.title or "Menu"
        self.centerDesc = self.currentMenu.desc or "Select Option"
    else
        self.centerText = "Menu"
        self.centerDesc = "Select Option"
    end
end

function PANEL:CreateSubMenu(title, desc)
    local submenu = {
        title = title,
        desc = desc,
        options = {}
    }

    function submenu:AddOption(text, func, icon, optionDesc, selected)
        table.insert(self.options, {
            text = text,
            func = func,
            icon = icon,
            desc = optionDesc,
            selected = selected == true
        })
        return #self.options
    end
    return submenu
end

function PANEL:AddSubMenuOption(text, submenu, icon, desc, selected)
    return self:AddOption(text, nil, icon, desc, submenu, selected)
end

vgui.Register("liaRadialPanel", PANEL, "DPanel")
