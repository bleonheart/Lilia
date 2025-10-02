local MODULE = MODULE
MODULE.CharacterInformation = {}
function MODULE:LoadCharInformation()
    hook.Run("AddSection", L("generalInfo"), Color(0, 0, 0), 1, 1)
    hook.Run("AddTextField", L("generalInfo"), "name", L("name"), function()
        local client = LocalPlayer()
        local char = client:getChar()
        return char and char:getName() or L("unknown")
    end)

    hook.Run("AddTextField", L("generalInfo"), "desc", L("description"), function()
        local client = LocalPlayer()
        local char = client:getChar()
        return char and char:getDesc() or ""
    end)

    hook.Run("AddTextField", L("generalInfo"), "money", L("money"), function()
        local client = LocalPlayer()
        return client and lia.currency.get(client:getChar():getMoney()) or lia.currency.get(0)
    end)
end

function MODULE:AddSection(sectionName, color, priority, location)
    hook.Run("F1OnAddSection", sectionName, color, priority, location)
    local localizedSectionName = isstring(sectionName) and L(sectionName) or sectionName
    if not self.CharacterInformation[localizedSectionName] then
        self.CharacterInformation[localizedSectionName] = {
            fields = {},
            color = color or Color(255, 255, 255),
            priority = priority or 999,
            location = location or 1
        }
    else
        local info = self.CharacterInformation[localizedSectionName]
        info.color = color or info.color
        info.priority = priority or info.priority
        info.location = location or info.location
    end
end

function MODULE:AddTextField(sectionName, fieldName, labelText, valueFunc)
    hook.Run("F1OnAddTextField", sectionName, fieldName, labelText, valueFunc)
    local localizedSectionName = isstring(sectionName) and L(sectionName) or sectionName
    local localizedLabel = isstring(labelText) and L(labelText) or labelText
    local section = self.CharacterInformation[localizedSectionName]
    if section then
        for _, field in ipairs(section.fields) do
            if field.name == fieldName then return end
        end

        table.insert(section.fields, {
            type = "text",
            name = fieldName,
            label = localizedLabel,
            value = valueFunc or function() return "" end
        })
    end
end

function MODULE:AddBarField(sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
    hook.Run("F1OnAddBarField", sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
    local localizedSectionName = isstring(sectionName) and L(sectionName) or sectionName
    local localizedLabel = isstring(labelText) and L(labelText) or labelText
    local section = self.CharacterInformation[localizedSectionName]
    if section then
        for _, field in ipairs(section.fields) do
            if field.name == fieldName then return end
        end

        table.insert(section.fields, {
            type = "bar",
            name = fieldName,
            label = localizedLabel,
            min = minFunc or function() return 0 end,
            max = maxFunc or function() return 100 end,
            value = valueFunc or function() return 0 end
        })
    end
end

function MODULE:PlayerBindPress(client, bind, pressed)
    if bind:lower():find("gm_showhelp") and pressed then
        if IsValid(lia.gui.menu) then
            lia.gui.menu:remove()
        elseif client:getChar() then
            vgui.Create("liaMenu")
        end
        return true
    end
end

function MODULE:CreateMenuButtons(tabs)
    tabs["you"] = function(statusPanel)
        statusPanel.info = vgui.Create("liaCharInfo", statusPanel)
        statusPanel.info:Dock(FILL)
        statusPanel.info:setup()
        statusPanel.info:SetAlpha(0)
        statusPanel.info:AlphaTo(255, 0.5)
    end

    tabs["information"] = function(infoTabPanel)
        local sheet = infoTabPanel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        local pages = {}
        hook.Run("CreateInformationButtons", pages)
        if not pages then return end
        table.sort(pages, function(a, b)
            local an = tostring(a.name):lower()
            local bn = tostring(b.name):lower()
            return an < bn
        end)

        for _, page in ipairs(pages) do
            local panel = vgui.Create("DPanel")
            panel:Dock(FILL)
            panel.Paint = function() end
            panel:DockPadding(10, 10, 10, 10)
            page.drawFunc(panel)
            local sheetData = sheet:AddSheet(L(page.name), panel)
            if page.onSelect then
                sheetData.Tab.liaPagePanel = panel
                sheetData.Tab.liaOnSelect = page.onSelect
            end
        end

        function sheet:OnActiveTabChanged(_, newTab)
            if IsValid(newTab) and newTab.liaOnSelect then newTab.liaOnSelect(newTab.liaPagePanel) end
        end
    end

    tabs["settings"] = function(settingsPanel)
        local sheet = settingsPanel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        local pages = {}
        hook.Run("PopulateConfigurationButtons", pages)
        if not pages then return end
        table.sort(pages, function(a, b)
            local an = tostring(a.name):lower()
            local bn = tostring(b.name):lower()
            return an < bn
        end)

        for _, page in ipairs(pages) do
            local panel = sheet:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = function() end
            page.drawFunc(panel)
            sheet:AddSheet(L(page.name), panel)
        end
    end

    local adminPages = {}
    hook.Run("PopulateAdminTabs", adminPages)
    if not table.IsEmpty(adminPages) then
        tabs["admin"] = function(adminPanel)
            local sheet = adminPanel:Add("DPropertySheet")
            sheet:Dock(FILL)
            sheet:DockMargin(10, 10, 10, 10)
            local pages = {}
            hook.Run("PopulateAdminTabs", pages)
            if table.IsEmpty(pages) then return end
            table.sort(pages, function(a, b)
                local an = tostring(a.name):lower()
                local bn = tostring(b.name):lower()
                return an < bn
            end)

            for _, page in ipairs(pages) do
                local panel = sheet:Add("DPanel")
                panel:Dock(FILL)
                panel.Paint = function() end
                local sheetData = sheet:AddSheet(L(page.name), panel, page.icon)
                if page.drawFunc then
                    sheetData.Tab.liaPagePanel = panel
                    sheetData.Tab.liaOnSelect = page.drawFunc
                end
            end

            function sheet:OnActiveTabChanged(_, newTab)
                if IsValid(newTab) and newTab.liaOnSelect then newTab.liaOnSelect(newTab.liaPagePanel) end
            end

            local initial = sheet:GetActiveTab()
            if IsValid(initial) and initial.liaOnSelect then initial.liaOnSelect(initial.liaPagePanel) end
        end
    end

    local hasPrivilege = LocalPlayer():hasPrivilege("accessEditConfigurationMenu")
    local forceTheme = lia.config.get("forceTheme", true)
    if (hasPrivilege and forceTheme) or (not forceTheme) then
        tabs["themes"] = function(themesPanel)
            local sheet = themesPanel:Add("DPropertySheet")
            sheet:Dock(FILL)
            sheet:DockMargin(10, 10, 10, 10)
            local function getLocalizedThemeName(themeID)
                -- Convert lowercase theme ID to proper case for localization key
                local properCaseName = themeID:gsub("(%a)([%w]*)", function(first, rest) return first:upper() .. rest:lower() end)
                local localizationKey = "theme" .. properCaseName:gsub(" ", ""):gsub("-", "")
                return L(localizationKey) or themeID
            end

            local function prettify(name)
                name = name:gsub("_", " ")
                return name:gsub("(%a)([%w]*)", function(first, rest) return first:upper() .. rest:lower() end)
            end

            local themeIDs = lia.color.getAllThemes()
            table.sort(themeIDs, function(a, b) return getLocalizedThemeName(a) < getLocalizedThemeName(b) end)
            local currentTheme = lia.color.getCurrentTheme()
            local statusUpdaters = {}
            local activeTab
            for _, themeID in ipairs(themeIDs) do
                local themeData = lia.color.themes[themeID]
                if istable(themeData) then
                    local displayName = getLocalizedThemeName(themeID)
                    local page = vgui.Create("DPanel")
                    page:SetPaintBackground(false)
                    page:DockPadding(12, 12, 12, 12)
                    local header = page:Add("DPanel")
                    header:Dock(TOP)
                    header:SetTall(60)
                    header:SetPaintBackground(false)
                    local applyButton = header:Add("liaSmallButton")
                    applyButton:Dock(TOP)
                    applyButton:DockMargin(0, 5, 0, 0)
                    applyButton:SetWide(200)
                    applyButton:SetTall(35)
                    applyButton:CenterHorizontal()
                    applyButton:SetText(L("apply"))
                    local scroll = page:Add("DScrollPanel")
                    scroll:Dock(FILL)
                    local entries = {}
                    for key, value in pairs(themeData) do
                        if lia.color.isColor(value) then
                            entries[#entries + 1] = {
                                name = key,
                                colors = {value}
                            }
                        elseif istable(value) then
                            local colors = {}
                            for _, subValue in ipairs(value) do
                                if lia.color.isColor(subValue) then colors[#colors + 1] = subValue end
                            end

                            if #colors > 0 then
                                entries[#entries + 1] = {
                                    name = key,
                                    colors = colors
                                }
                            end
                        end
                    end

                    table.sort(entries, function(a, b) return a.name < b.name end)
                    for _, entry in ipairs(entries) do
                        local row = scroll:Add("DPanel")
                        row:Dock(TOP)
                        row:DockMargin(0, 0, 0, 8)
                        row:SetTall(80)
                        row.Paint = function(_, w, h)
                            draw.RoundedBox(8, 0, 0, w, h, Color(24, 24, 24, 220))
                            draw.SimpleText(prettify(entry.name), "liaSmallFont", 12, 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                            local swatchSize = h - 34
                            local gap = 10
                            local totalWidth = (#entry.colors * (swatchSize + gap)) - gap
                            local startX = w - totalWidth - 12
                            local swatchY = (h - swatchSize) * 0.5
                            for idx, col in ipairs(entry.colors) do
                                local x = startX + (idx - 1) * (swatchSize + gap)
                                draw.RoundedBox(6, x, swatchY, swatchSize, swatchSize, col)
                                surface.SetDrawColor(255, 255, 255, 60)
                                surface.DrawOutlinedRect(x, swatchY, swatchSize, swatchSize)
                            end
                        end
                    end

                    local sheetInfo = sheet:AddSheet(displayName, page)
                    local function updateStatus()
                        local isActive = currentTheme == themeID
                        if IsValid(applyButton) then
                            applyButton:SetEnabled(not isActive)
                            applyButton:SetText(isActive and L("currentlySelected") or L("apply"))
                        end
                    end

                    table.insert(statusUpdaters, updateStatus)
                    updateStatus()
                    applyButton.DoClick = function()
                        if currentTheme == themeID then return end
                        surface.PlaySound("buttons/button14.wav")
                        if forceTheme then
                            -- When forceTheme is ON, update server config
                            net.Start("liaConfigUpdate")
                            net.WriteString("Theme")
                            net.WriteType(themeID)
                            net.SendToServer()
                        else
                            -- When forceTheme is OFF, update personal option
                            lia.option.set("theme", themeID)
                            lia.color.applyTheme(themeID, true)
                        end
                    end

                    if themeID == currentTheme and not activeTab and sheetInfo and sheetInfo.Tab then activeTab = sheetInfo.Tab end
                end
            end

            if activeTab then sheet:SetActiveTab(activeTab) end
        end
    end
end

function MODULE:CanDisplayCharInfo(name)
    local client = LocalPlayer()
    if not client then return true end
    local character = client:getChar()
    if not character then return true end
    if not lia.class or not lia.class.list then return true end
    local class = lia.class.list[character:getClass()]
    if name == "class" and not class then return false end
    return true
end