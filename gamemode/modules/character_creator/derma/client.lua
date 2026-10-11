local MODULE = MODULE
local fallbackAccent = Color(76, 164, 224)
local fallbackText = Color(230, 239, 239)
local fallbackBackground = Color(7, 14, 23)
local fallbackNegative = Color(205, 74, 74)
local attributeOrder = {"agility", "end", "strength"}
local supportedPayloadKeys = {
    faction = true,
    name = true,
    desc = true,
    model = true,
    skin = true,
    bodygroups = true,
    attribs = true,
    class = true
}

local function copyValue(value)
    if istable(value) then return table.Copy(value) end
    return value
end

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
    return lia.color and lia.color.theme or {}
end

local function getThemeAccent(alpha)
    local theme = getActiveThemePalette()
    local source = theme.maincolor or theme.accent or theme.theme
    if not IsColor(source) and lia.color and isfunction(lia.color.getMainColor) then source = lia.color.getMainColor() end
    return getThemeColor(source, fallbackAccent, alpha)
end

local function getThemeTextColor(alpha)
    local theme = getActiveThemePalette()
    return getThemeColor(theme.text or theme.foreground, fallbackText, alpha)
end

local function getThemeBackgroundColor(alpha)
    local theme = getActiveThemePalette()
    return getThemeColor(theme.background or theme.panel or theme.window, fallbackBackground, alpha)
end

local function getThemeSurface(strength, alpha)
    return mixThemeColors(getThemeBackgroundColor(255), getThemeTextColor(255), strength or 0.04, alpha)
end

local function getThemeMutedColor(alpha)
    return mixThemeColors(getThemeTextColor(255), getThemeBackgroundColor(255), 0.38, alpha or 190)
end

local function getThemeDisabledColor(alpha)
    return mixThemeColors(getThemeTextColor(255), getThemeBackgroundColor(255), 0.64, alpha or 120)
end

local function getThemeNegativeColor(alpha)
    local theme = getActiveThemePalette()
    local source = theme.negative
    if not IsColor(source) and lia.color and isfunction(lia.color.calculateNegativeColor) then source = lia.color.calculateNegativeColor(getThemeAccent()) end
    return getThemeColor(source, fallbackNegative, alpha)
end

local function drawPanel(x, y, w, h, radius, background, outline)
    if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
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

local function bindThemedLabel(label, getter)
    if not IsValid(label) then return end
    label.Think = function(self) if isfunction(getter) then self:SetTextColor(getter()) end end
end

local function makeButton(parent, text, secondary)
    local button = parent:Add("DButton")
    button:SetText("")
    button._text = text
    button._hover = 0
    button.Think = function(self) self._hover = Lerp(FrameTime() * 12, self._hover or 0, self:IsHovered() and self:IsEnabled() and 1 or 0) end
    button.Paint = function(self, w, h)
        local accent = secondary and getThemeNegativeColor() or getThemeAccent()
        local hover = self._hover or 0
        local background = Color(accent.r, accent.g, accent.b, secondary and 16 + hover * 15 or 22 + hover * 26)
        local outline = Color(accent.r, accent.g, accent.b, 70 + hover * 105)
        if not self:IsEnabled() then
            background = getThemeSurface(0.025, 205)
            outline = getThemeMutedColor(45)
        end

        drawPanel(0, 0, w, h, 6, background, outline)
        draw.SimpleText(self._text, "LiliaFont.18", w * 0.5, h * 0.5, self:IsEnabled() and getThemeTextColor() or getThemeDisabledColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
    entry:SetFont(multiline and "LiliaFont.16" or "LiliaFont.18")
    entry:SetTextColor(getThemeTextColor())
    entry:SetCursorColor(getThemeAccent())
    entry:SetHighlightColor(getThemeAccent(100))
    entry:SetDrawBackground(false)
    entry:SetPaintBackground(false)
    entry:SetPaintBorderEnabled(false)
    entry:SetMultiline(multiline == true)
    entry.Think = function(self)
        self:SetTextColor(getThemeTextColor())
        self:SetCursorColor(getThemeAccent())
        self:SetHighlightColor(getThemeAccent(100))
    end

    wrap.PerformLayout = function(_, w, h)
        local entryY = multiline and 32 or 33
        local bottomPadding = multiline and 10 or 11
        entry:SetPos(13, entryY)
        entry:SetSize(w - 26, h - entryY - bottomPadding)
    end
    return wrap, entry
end

local function styleScrollBar(scroll)
    if not IsValid(scroll) or not IsValid(scroll.VBar) then return end
    local bar = scroll.VBar
    bar:SetWide(8)
    bar.Paint = function() end
    bar.btnUp.Paint = function() end
    bar.btnDown.Paint = function() end
    bar.btnGrip.Paint = function(self, w, h) draw.RoundedBox(4, 1, 0, w - 2, h, self:IsHovered() and getThemeAccent(125) or getThemeMutedColor(80)) end
end

local function getCreationDropdownText(combo)
    local value = combo.selected
    if not isstring(value) or value == "" then if isfunction(combo.GetValue) then value = combo:GetValue() end end
    if not isstring(value) or value == "" then if isfunction(combo.GetSelectedText) then value = combo:GetSelectedText() end end
    if not isstring(value) or value == "" then if isfunction(combo.GetText) then value = combo:GetText() end end
    if not isstring(value) or value == "" then value = combo.placeholder or "" end
    return tostring(value)
end

local function paintCreationDropdownField(combo, w, h)
    local accent = getThemeAccent()
    local isOpen = combo.opened or IsValid(combo.Menu) and combo.Menu:IsVisible() or IsValid(combo.menu) and combo.menu:IsVisible()
    local highlighted = combo:IsHovered() or IsValid(combo.btn) and combo.btn:IsHovered() or isOpen
    drawPanel(0, 0, w, h, 6, getThemeSurface(highlighted and 0.065 or 0.05, 242), Color(accent.r, accent.g, accent.b, highlighted and 130 or 55))
    draw.SimpleText(getCreationDropdownText(combo), "LiliaFont.16", 12, h * 0.5, combo:IsEnabled() and getThemeTextColor() or getThemeDisabledColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    local x = w - 18
    local y = math.floor(h * 0.5)
    surface.SetDrawColor(isOpen and accent or getThemeMutedColor())
    if isOpen then
        surface.DrawLine(x - 4, y + 2, x, y - 2)
        surface.DrawLine(x, y - 2, x + 4, y + 2)
    else
        surface.DrawLine(x - 4, y - 2, x, y + 2)
        surface.DrawLine(x, y + 2, x + 4, y - 2)
    end
end

local function collectCreationDropdownOptions(parent, output)
    if not IsValid(parent) then return end
    for _, child in ipairs(parent:GetChildren()) do
        local className = isfunction(child.GetClassName) and string.lower(child:GetClassName() or "") or ""
        if className == "dbutton" or className:find("menuoption", 1, true) then
            output[#output + 1] = child
        elseif child ~= parent.VBar and not className:find("scrollbar", 1, true) then
            collectCreationDropdownOptions(child, output)
        end
    end
end

local function styleCreationDropdownScroll(menu)
    local bar = menu.VBar or isfunction(menu.GetVBar) and menu:GetVBar()
    if not IsValid(bar) then return end
    bar:SetWide(7)
    bar.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, getThemeSurface(0.02, 230)) end
    if IsValid(bar.btnUp) then bar.btnUp.Paint = function() end end
    if IsValid(bar.btnDown) then bar.btnDown.Paint = function() end end
    if IsValid(bar.btnGrip) then bar.btnGrip.Paint = function(self, w, h) draw.RoundedBox(2, 2, 0, math.max(w - 4, 1), h, getThemeAccent(self:IsHovered() and 225 or 175)) end end
end

local function styleCreationDropdownMenu(menu, combo)
    if not IsValid(menu) or not IsValid(combo) then return end
    local isLiliaCombo = IsValid(combo.btn) and istable(combo.choices)
    menu.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 5, getThemeSurface(0.025, 253), Color(accent.r, accent.g, accent.b, 93))
    end

    if isfunction(menu.SetMinimumWidth) then menu:SetMinimumWidth(combo:GetWide()) end
    if isfunction(menu.SetMaxHeight) then menu:SetMaxHeight(312) end
    local canvas = isfunction(menu.GetCanvas) and menu:GetCanvas() or menu
    local options = {}
    collectCreationDropdownOptions(canvas, options)
    local choiceIndex = 0
    for _, option in ipairs(options) do
        local label
        if isLiliaCombo then
            repeat
                choiceIndex = choiceIndex + 1
            until not combo.choices[choiceIndex] or not combo.choices[choiceIndex].spacer

            local choice = combo.choices[choiceIndex]
            label = choice and choice.text or ""
            option:DockMargin(6, 2, 6, 0)
        else
            label = isfunction(option.GetText) and option:GetText() or ""
        end

        label = tostring(label or "")
        option:SetTall(25)
        if isfunction(option.SetFont) then option:SetFont("LiliaFont.16") end
        option.Paint = function(self, w, h)
            local accent = getThemeAccent()
            local selected = label == getCreationDropdownText(combo)
            local hovered = self:IsHovered()
            local background = selected and Color(accent.r, accent.g, accent.b, 34) or hovered and Color(accent.r, accent.g, accent.b, 27) or getThemeSurface(0.018, 248)
            local outline = selected and Color(accent.r, accent.g, accent.b, 105) or hovered and Color(accent.r, accent.g, accent.b, 78) or getThemeMutedColor(25)
            drawPanel(0, 0, w, h, 3, background, outline)
            draw.SimpleText(label, "LiliaFont.16", 12, h * 0.5, self:IsEnabled() and getThemeTextColor() or getThemeDisabledColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    styleCreationDropdownScroll(menu)
    if isLiliaCombo then
        local contentHeight = 12
        for _, choice in ipairs(combo.choices) do
            contentHeight = contentHeight + (choice.spacer and 10 or 27)
        end

        local x, y = combo:LocalToScreen(0, combo:GetTall())
        local spaceBelow = math.max(ScrH() - y - 10, 0)
        local spaceAbove = math.max(y - combo:GetTall() - 10, 0)
        local height = math.min(contentHeight, 312, math.max(spaceBelow, spaceAbove))
        if height > 0 then
            menu:SetSize(combo:GetWide(), height)
            menu:SetPos(x, spaceBelow < height and spaceAbove > spaceBelow and y - height - combo:GetTall() or y)
        end
    end

    if isfunction(menu.InvalidateLayout) then menu:InvalidateLayout(true) end
end

local function styleCreationComboBox(combo)
    if not IsValid(combo) or combo.schemaCreatorDropdownStyled then return end
    if not isfunction(combo.AddChoice) or not isfunction(combo.OpenMenu) then return end
    combo.schemaCreatorDropdownStyled = true
    if isfunction(combo.SetTextColor) then combo:SetTextColor(getThemeTextColor()) end
    if IsValid(combo.btn) and istable(combo.choices) then combo.btn.Paint = function(_, w, h) paintCreationDropdownField(combo, w, h) end end
    local originalOnMenuOpened = combo.OnMenuOpened
    combo.OnMenuOpened = function(self, ...)
        if isfunction(originalOnMenuOpened) then originalOnMenuOpened(self, ...) end
        local menu = self.menu or self.Menu
        if not IsValid(menu) then
            local candidate = select(1, ...)
            if IsValid(candidate) then menu = candidate end
        end

        if IsValid(menu) then styleCreationDropdownMenu(menu, self) end
    end

    local originalOpenMenu = combo.OpenMenu
    combo.OpenMenu = function(self, ...)
        local results = {originalOpenMenu(self, ...)}
        local menu = self.menu or self.Menu
        if IsValid(menu) then styleCreationDropdownMenu(menu, self) end
        return unpack(results)
    end
end

local function styleCreationComboBoxes(root)
    if not IsValid(root) then return end
    styleCreationComboBox(root)
    for _, child in ipairs(root:GetChildren()) do
        styleCreationComboBoxes(child)
    end
end

MODULE.StyleCreationComboBox = styleCreationComboBox
local idleSequences = {"idle_all_01", "idle_all_02", "idle_subtle", "idle_unarmed", "idle01", "idle"}
local function getIdleSequence(entity)
    if not IsValid(entity) then return nil end
    for _, name in ipairs(idleSequences) do
        local sequence = entity:LookupSequence(name)
        if sequence and sequence >= 0 then return sequence end
    end

    local sequence = entity:SelectWeightedSequence(ACT_IDLE)
    if sequence and sequence >= 0 then return sequence end
end

local function applyIdleSequence(entity)
    if not IsValid(entity) then return end
    local sequence = getIdleSequence(entity)
    if not sequence then return end
    entity:ResetSequence(sequence)
    entity:SetCycle(0)
    entity:SetPlaybackRate(1)
    if entity.SetIK then entity:SetIK(true) end
    for _, parameter in ipairs({"move_x", "move_y", "move_yaw", "body_yaw", "body_pitch"}) do
        entity:SetPoseParameter(parameter, 0)
    end

    entity:InvalidateBoneCache()
    entity:SetupBones()
end

local function getFactionByIndex(index)
    if not index then return nil end
    return lia.faction.indices and lia.faction.indices[index] or lia.faction.get and lia.faction.get(index) or nil
end

local function getAvailableFactions()
    local output = {}
    for _, faction in pairs(lia.faction.teams or {}) do
        if faction.index == FACTION_STAFF or faction.uniqueID == "staff" then continue end
        if lia.faction.hasWhitelist and not lia.faction.hasWhitelist(faction.index) then continue end
        output[#output + 1] = faction
    end

    table.sort(output, function(a, b) return tostring(a.name or "") < tostring(b.name or "") end)
    return output
end

local function getDefaultCreationClasses(faction)
    local output = {}
    if not faction or not lia.class or not lia.class.list then return output end
    for _, class in pairs(lia.class.list) do
        if class and class.faction == faction.index and class.isDefault then output[#output + 1] = class end
    end

    table.sort(output, function(a, b)
        local aName = tostring(a.name or a.uniqueID or a.index or "")
        local bName = tostring(b.name or b.uniqueID or b.index or "")
        if aName == bName then return (tonumber(a.index) or 0) < (tonumber(b.index) or 0) end
        return aName < bName
    end)
    return output
end

local function isDefaultCreationClass(faction, classIndex)
    classIndex = tonumber(classIndex)
    if not faction or not classIndex then return false end
    for _, class in ipairs(getDefaultCreationClasses(faction)) do
        if tonumber(class.index) == classIndex then return true, class end
    end
    return false
end

local function resetCreationClassForFaction(context, faction)
    local classes = getDefaultCreationClasses(faction)
    if #classes == 1 then
        context.class = classes[1].index
    else
        context.class = nil
    end
    return classes
end

local function getCreationClass(faction, context)
    if not faction then return nil end
    return lia.faction.getCharacterCreationClass(faction, context.class)
end

local function normalizeCreationModelChoices(source)
    if istable(source) then return source end
    if isstring(source) and source ~= "" then
        return {
            [1] = source
        }
    end
    return {}
end

local function getCreationModelChoices(faction, context)
    if not faction then return {}, false end
    local class = getCreationClass(faction, context)
    if class then
        if class.model ~= nil then return normalizeCreationModelChoices(class.model), true end
        if class.models ~= nil then return normalizeCreationModelChoices(class.models), false end
    end

    if faction.model ~= nil then return normalizeCreationModelChoices(faction.model), true end
    if faction.models ~= nil then return normalizeCreationModelChoices(faction.models), false end
    local choices, _, forced = lia.faction.getCharacterCreationModelChoices(faction, class)
    return normalizeCreationModelChoices(choices), forced == true
end

local function getFilteredModels(faction, context)
    if not faction then return {}, false end
    local choices, forced = getCreationModelChoices(faction, context)
    local output = {}
    local seen = {}
    local function addModel(key, raw, respectFilter)
        local parsed = lia.faction.getModelData(key, raw)
        if not parsed or not isstring(parsed.model) or parsed.model == "" then return end
        if seen[tostring(key) .. "|" .. parsed.model] then return end
        if respectFilter and lia.faction.isModelUsable and not lia.faction.isModelUsable(parsed.model) then return end
        if respectFilter and hook.Run("FilterCharModels", LocalPlayer(), faction, raw, key) == false then return end
        seen[tostring(key) .. "|" .. parsed.model] = true
        output[#output + 1] = {
            key = key,
            raw = raw,
            parsed = parsed
        }
    end

    for key, raw in pairs(choices) do
        addModel(key, raw, true)
    end

    if #output == 0 then
        local fallbackChoices = normalizeCreationModelChoices(faction.models ~= nil and faction.models or faction.model)
        if table.Count(fallbackChoices) == 0 then fallbackChoices = choices end
        for key, raw in pairs(fallbackChoices) do
            addModel(key, raw, false)
        end
    end

    table.sort(output, function(a, b)
        if isnumber(a.key) and isnumber(b.key) then return a.key < b.key end
        return tostring(a.key) < tostring(b.key)
    end)
    return output, forced
end

local function resolveBodygroups(modelPath, bodygroups)
    if istable(bodygroups) then return table.Copy(bodygroups) end
    local output = {}
    if not isstring(bodygroups) or bodygroups == "" then return output end
    local entity = ClientsideModel(modelPath, RENDERGROUP_OTHER)
    if IsValid(entity) then
        if lia.util and isfunction(lia.util.resolveBodygroups) then
            local resolved = lia.util.resolveBodygroups(entity, bodygroups)
            if istable(resolved) then output = resolved end
        else
            local index = 0
            for digit in bodygroups:gmatch("%d") do
                output[index] = tonumber(digit) or 0
                index = index + 1
            end
        end

        entity:Remove()
    end
    return output
end

local function getSelectedModelData(context)
    local faction = getFactionByIndex(context.faction)
    if not faction then return nil, nil, nil end
    local choices = getCreationModelChoices(faction, context)
    local selectedKey = context.model
    local raw = selectedKey ~= nil and choices[selectedKey] or nil
    if raw == nil then
        for key, choice in pairs(choices) do
            selectedKey = key
            raw = choice
            break
        end
    end

    if raw == nil then return faction, nil, nil end
    local parsed = lia.faction.getModelData(selectedKey, raw)
    return faction, raw, parsed
end

local function setDefaultAppearance(context, modelKey, parsed)
    context.model = modelKey
    context.skin = math.max(tonumber(parsed and parsed.skin) or 0, 0)
    context.bodygroups = parsed and resolveBodygroups(parsed.model, parsed.bodygroups) or {}
end

local function applyDefaultsForFaction(context, faction)
    local models = getFilteredModels(faction, context)
    local first = models[1]
    if first then
        setDefaultAppearance(context, first.key, first.parsed)
    else
        context.model = nil
        context.skin = 0
        context.bodygroups = {}
    end
end

local function applyIdentityDefaults(context)
    local client = LocalPlayer()
    local defaultName, nameOverride = hook.Run("GetDefaultCharName", client, context.faction, context)
    if isstring(defaultName) and nameOverride ~= false then
        local current = string.Trim(tostring(context.name or ""))
        if current == "" or nameOverride == true then context.name = defaultName end
    end

    if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false and lia.char.vars.desc then
        local current = string.Trim(tostring(context.desc or ""))
        if current == "" then context.desc = copyValue(lia.char.vars.desc.default) end
    end

    if hook.Run("ShouldShowCharVarInCreation", "name") == false and lia.char.vars.name then context.name = copyValue(lia.char.vars.name.default) end
    if hook.Run("ShouldShowCharVarInCreation", "desc") == false and lia.char.vars.desc then context.desc = copyValue(lia.char.vars.desc.default) end
end

local function visibleTabs(creator)
    local output = {}
    local client = LocalPlayer()
    for _, tab in ipairs(MODULE:GetCreationTabs()) do
        local allowed = not tab.shouldShow or tab.shouldShow(client, creator.context, creator) ~= false
        if allowed and hook.Run("CanShowCharacterCreationTab", tab.id, client, creator.context, creator) ~= false then output[#output + 1] = tab end
    end
    return output
end

local function getDataLogo(data)
    if not data then return nil end
    local source = data.logo or data.icon or data.image
    if type(source) == "IMaterial" then return source end
    if isstring(source) and source ~= "" then
        local material = Material(source, "smooth")
        if material and not material:IsError() then return material end
    end
    return nil
end

local function getFactionLogo(faction)
    return getDataLogo(faction)
end

local function getClassLogo(class, faction)
    return getDataLogo(class) or getFactionLogo(faction)
end

local function humanizeWords(value)
    value = string.Trim(tostring(value or ""))
    if value == "" then return "" end
    local output = {}
    for word in value:gmatch("[^%s]+") do
        local upperWord = string.upper(word)
        if #word <= 3 and word == upperWord then
            output[#output + 1] = upperWord
        else
            output[#output + 1] = string.upper(word:sub(1, 1)) .. string.lower(word:sub(2))
        end
    end
    return table.concat(output, " ")
end

local function getModelBaseName(modelPath)
    local clean = tostring(modelPath or ""):gsub("\\", "/")
    local base = clean:match("([^/]+)$") or clean
    return base
end

local function getModelDisplayTitle(modelData)
    if not modelData then return "Unknown Model" end
    local parsed = modelData.parsed or {}
    local raw = modelData.raw
    local candidates = {parsed.name, parsed.displayName, parsed.title, parsed.label, istable(raw) and raw.name or nil, istable(raw) and raw.displayName or nil, istable(raw) and raw.title or nil, istable(raw) and raw.label or nil, getModelBaseName(parsed.model)}
    for _, candidate in ipairs(candidates) do
        if isstring(candidate) and string.Trim(candidate) ~= "" then
            local textValue = candidate
            if textValue:find("/") or textValue:find("\\") then textValue = getModelBaseName(textValue) end
            textValue = textValue:gsub("%.mdl$", "")
            textValue = textValue:gsub("[_%-]+", " ")
            textValue = textValue:gsub("%s+", " ")
            return humanizeWords(textValue)
        end
    end
    return "Unknown Model"
end

local function getModelDisplaySubtitle(modelData)
    if not modelData or not modelData.parsed then return "" end
    return getModelBaseName(modelData.parsed.model or "")
end

local function getModelCategory(modelData)
    if not modelData then return "Other" end
    local parsed = modelData.parsed or {}
    local raw = modelData.raw
    local direct = parsed.category or parsed.group or parsed.family or parsed.type or istable(raw) and (raw.category or raw.group or raw.family or raw.type) or nil
    if isstring(direct) and string.Trim(direct) ~= "" then return humanizeWords(direct:gsub("[_%-]+", " ")) end
    local title = string.lower(getModelDisplayTitle(modelData))
    local subtitle = string.lower(getModelDisplaySubtitle(modelData))
    local combined = title .. " " .. subtitle
    local rules = {{"combine", "Combine"}, {"metropolice", "Combine"}, {"overwatch", "Combine"}, {"civil protection", "Combine"}, {"medic", "Utility"}, {"scanner", "Utility"}, {"turret", "Utility"}, {"barney", "Citizens"}, {"rebel", "Citizens"}, {"refugee", "Citizens"}, {"citizen", "Citizens"}, {"worker", "Citizens"}, {"prison", "Security"}, {"guard", "Security"}}
    for _, rule in ipairs(rules) do
        if combined:find(rule[1], 1, true) then return rule[2] end
    end

    local firstWord = getModelDisplayTitle(modelData):match("^([^%s]+)")
    if isstring(firstWord) and firstWord ~= "" then return humanizeWords(firstWord) end
    return "Other"
end

local function matchesModelSearch(modelData, query)
    query = string.Trim(string.lower(tostring(query or "")))
    if query == "" then return true end
    local searchHaystack = string.lower(table.concat({tostring(getModelDisplayTitle(modelData) or ""), tostring(getModelDisplaySubtitle(modelData) or ""), tostring(modelData and modelData.parsed and modelData.parsed.model or ""), tostring(getModelCategory(modelData) or "")}, " "))
    return searchHaystack:find(query, 1, true) ~= nil
end

local function getCreatorPaperMetrics()
    local screenWidth = ScrW()
    local screenHeight = ScrH()
    local maximumPaperWidth = math.max(screenWidth - 48, 620)
    local paperMaximum = math.min(1280, maximumPaperWidth)
    local paperMinimum = math.min(880, paperMaximum)
    local paperWidth = math.Clamp(math.floor(screenWidth * 0.6), paperMinimum, paperMaximum)
    local paperHeight = math.Clamp(math.floor(screenHeight * 0.9), math.min(680, screenHeight - 30), screenHeight - 30)
    local marginRight = math.Clamp(math.floor(screenWidth * 0.03), 24, 64)
    return screenWidth - paperWidth - marginRight, math.floor((screenHeight - paperHeight) * 0.5), paperWidth, paperHeight
end

local PANEL = {}
function PANEL:Init()
    if IsValid(lia.gui.schemaCharacterCreator) and lia.gui.schemaCharacterCreator ~= self then lia.gui.schemaCharacterCreator:Remove() end
    lia.gui.schemaCharacterCreator = self
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2, 0)
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self.context = {
        attribs = {},
        skin = 0,
        bodygroups = {}
    }

    MODULE.creationContext = self.context
    self.creating = false
    self.finished = false
    self.currentIndex = 0
    self.completedTabs = {}
    self.hookID = "liaSchemaCharacterCreator" .. tostring(self):gsub("[^%w]", "")
    local factions = getAvailableFactions()
    if factions[1] then
        self.context.faction = factions[1].index
        resetCreationClassForFaction(self.context, factions[1])
        applyDefaultsForFaction(self.context, factions[1])
        applyIdentityDefaults(self.context)
    end

    MODULE:RefreshCreationTabs()
    self.tabs = visibleTabs(self)
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
    self.inputWindow.Paint = function() end
    self.inputWindow:MakePopup()
    self.inputWindow:SetZPos(32767)
    self.inputWindow:MoveToFront()
    self.inputWindow:RequestFocus()
    self.inputWindow.OnKeyCodePressed = function(_, key) if IsValid(self) then self:OnKeyCodePressed(key) end end
    self.paper = self.inputWindow:Add("DPanel")
    self.paper:SetMouseInputEnabled(true)
    self.paper:SetKeyboardInputEnabled(true)
    self.paper.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 10, getThemeSurface(0.025, 238), Color(accent.r, accent.g, accent.b, 92))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 190)
        surface.DrawRect(0, 0, w, 2)
        surface.DrawRect(0, h - 2, w, 2)
    end

    self.page = self.paper:Add("DPanel")
    self.page:SetPaintBackground(false)
    self.page:SetMouseInputEnabled(true)
    self.page:SetKeyboardInputEnabled(true)
    self:BuildInterface()
    self:SetupWorldScene()
    if factions[1] then self:RefreshWorldModel(false) end
    self:ShowTab(1, true)
end

function PANEL:SetCreationContext(key, value)
    self.context[key] = value
    MODULE.creationContext = self.context
end

function PANEL:GetCreationContext(key)
    if key ~= nil then return self.context[key] end
    return self.context
end

function PANEL:BuildInterface()
    self.header = self.page:Add("DPanel")
    self.header.Paint = function(_, w, h)
        local accent = getThemeAccent()
        local faction = getFactionByIndex(self.context.faction)
        local active = self.tabs[self.currentIndex]
        draw.SimpleText("CUSTOMIZE", "LiliaFont.30", 0, 0, getThemeTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText((faction and faction.name or "Character") .. "  /  " .. (active and active.name or "Creation"), "LiliaFont.16", 0, 34, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 165)
        surface.DrawRect(0, h - 1, w, 1)
    end

    self.tabNavigation = self.page:Add("DPanel")
    self.tabNavigation:SetMouseInputEnabled(true)
    self.tabNavigation.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 222), Color(accent.r, accent.g, accent.b, 55))
    end

    self.stage = self.page:Add("DPanel")
    self.stage:SetMouseInputEnabled(true)
    self.stage:SetKeyboardInputEnabled(true)
    self.stage.Paint = function(_, w, h)
        local accent = getThemeAccent()
        drawPanel(0, 0, w, h, 8, getThemeSurface(0.025, 230), Color(accent.r, accent.g, accent.b, 55))
    end

    self.errorPanel = self.page:Add("DPanel")
    self.errorPanel:SetVisible(false)
    self.errorPanel.Paint = function(_, w, h)
        local negative = getThemeNegativeColor()
        drawPanel(0, 0, w, h, 6, Color(negative.r, negative.g, negative.b, 18), Color(negative.r, negative.g, negative.b, 90))
    end

    self.errorLabel = self.errorPanel:Add("DLabel")
    self.errorLabel:SetFont("LiliaFont.16")
    self.errorLabel:SetTextColor(getThemeNegativeColor())
    self.errorLabel:SetContentAlignment(5)
    self.errorLabel:SetWrap(true)
    bindThemedLabel(self.errorLabel, function() return getThemeNegativeColor() end)
    self.backButton = makeButton(self.page, "BACK", true)
    self.backButton:SetZPos(50)
    self.backButton.DoClick = function() self:Previous() end
    self.mainMenuButton = makeButton(self.page, "MAIN MENU", true)
    self.mainMenuButton:SetZPos(50)
    self.mainMenuButton.DoClick = function() if not self.creating then self:ReturnToMainMenu() end end
    self.nextButton = makeButton(self.page, "NEXT")
    self.nextButton:SetZPos(50)
    self.nextButton.DoClick = function() self:Next() end
    self:BuildTabNavigation()
end

function PANEL:RefreshVisibleTabs(preferredTabID)
    local current = self.tabs and self.tabs[self.currentIndex] or nil
    local targetID = preferredTabID or current and current.id or nil
    MODULE:RefreshCreationTabs()
    self.tabs = visibleTabs(self)
    local targetIndex = 1
    if targetID then
        for index, tab in ipairs(self.tabs) do
            if tab.id == targetID then
                targetIndex = index
                break
            end
        end
    end

    self.currentIndex = math.Clamp(targetIndex, 1, math.max(#self.tabs, 1))
    if IsValid(self.tabNavigation) then self:BuildTabNavigation() end
    return self.currentIndex
end

function PANEL:BuildTabNavigation()
    self.tabNavigation:Clear()
    self.tabButtons = {}
    for index, tab in ipairs(self.tabs) do
        local tabIndex = index
        local button = self.tabNavigation:Add("DButton")
        button:SetText("")
        button._hover = 0
        button.Think = function(self) self._hover = Lerp(FrameTime() * 12, self._hover or 0, self:IsHovered() and 1 or 0) end
        button.Paint = function(button, w, h)
            local active = self.currentIndex == tabIndex
            local complete = self:IsTabComplete(tab)
            local accent = getThemeAccent()
            local hover = button._hover or 0
            drawPanel(0, 0, w, h, 6, active and Color(accent.r, accent.g, accent.b, 30) or getThemeSurface(0.05, 225), Color(accent.r, accent.g, accent.b, active and 190 or 45 + hover * 75))
            if active then
                surface.SetDrawColor(accent.r, accent.g, accent.b, 230)
                surface.DrawRect(0, 0, 4, h)
            end

            draw.SimpleText(string.format("%02d", tabIndex), "LiliaFont.16", 14, 12, active and accent or getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(string.upper(tab.name), "LiliaFont.18", 14, 34, getThemeTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            local badgeText
            local badgeColor
            if active then
                badgeText = complete and "ACTIVE" or "NOT READY"
                badgeColor = complete and accent or getThemeNegativeColor()
            elseif complete then
                badgeText = "READY"
                badgeColor = accent
            end

            if badgeText then
                local badgeWidth = badgeText == "NOT READY" and 78 or badgeText == "ACTIVE" and 58 or 54
                drawPanel(w - badgeWidth - 10, 9, badgeWidth, 22, 4, Color(badgeColor.r, badgeColor.g, badgeColor.b, 24), Color(badgeColor.r, badgeColor.g, badgeColor.b, 82))
                draw.SimpleText(badgeText, "LiliaFont.15", w - badgeWidth * 0.5 - 10, 20, badgeColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        button.DoClick = function() self:RequestTab(tabIndex) end
        self.tabButtons[#self.tabButtons + 1] = button
    end

    self:InvalidateLayout(true)
end

function PANEL:IsTabComplete(tab)
    if not tab then return false end
    if self.completedTabs[tab.id] then return true end
    if tab.id == "review" then
        for _, candidate in ipairs(self.tabs) do
            if candidate.id ~= "review" and not self.completedTabs[candidate.id] then return false end
        end
        return true
    end
    return false
end

function PANEL:ShowError(message)
    message = string.Trim(tostring(message or ""))
    self.errorLabel:SetText(message)
    self.errorPanel:SetVisible(message ~= "")
    self:InvalidateLayout(true)
end

function PANEL:ValidateTab(tab)
    if not tab then return false, "This creation step is unavailable." end
    if self.tabs[self.currentIndex] == tab and IsValid(self.activeTabPanel) and isfunction(self.activeTabPanel.SyncContext) then self.activeTabPanel:SyncContext() end
    if tab.onValidate then
        local ok, reason = tab.onValidate(self.context, self)
        if ok == false then return false, reason end
    end

    local hookOK, hookReason = hook.Run("ValidateCharacterCreationTab", tab.id, self.context, self)
    if hookOK == false then return false, hookReason end
    return true
end

function PANEL:RefreshActiveTabValidation()
    local tab = self.tabs[self.currentIndex]
    if not tab then return end
    local complete = self:ValidateTab(tab)
    self.completedTabs[tab.id] = complete == true or nil
    if complete == true and IsValid(self.errorPanel) and self.errorPanel:IsVisible() then self:ShowError("") end
end

function PANEL:RequestTab(index)
    index = math.Clamp(index, 1, #self.tabs)
    if index > self.currentIndex then
        local current = self.tabs[self.currentIndex]
        local ok, reason = self:ValidateTab(current)
        if not ok then
            self.completedTabs[current.id] = nil
            self:BuildTabNavigation()
            self:ShowError(reason or "Please complete this section.")
            return
        end

        self.completedTabs[current.id] = true
    end

    self:ShowTab(index)
end

function PANEL:GetCameraModeForTab(tab)
    if not tab then return "appearance" end
    return "appearance"
end

function PANEL:ShowTab(index, immediate)
    if #self.tabs == 0 then return end
    index = math.Clamp(index, 1, #self.tabs)
    local oldTab = self.tabs[self.currentIndex]
    if oldTab and IsValid(self.activeTabPanel) and oldTab.onLeave then oldTab.onLeave(self.activeTabPanel, self.context, self) end
    if IsValid(self.activeTabPanel) then
        self.activeTabPanel:Stop()
        self.activeTabPanel:Remove()
    end

    self.currentIndex = index
    local tab = self.tabs[index]
    self.activeTabPanel = tab.onCreate(self.stage, self.context, self)
    if not IsValid(self.activeTabPanel) then self.activeTabPanel = self.stage:Add("DPanel") end
    self.activeTabPanel:SetPos(18, 18)
    self.activeTabPanel:SetAlpha(immediate and 255 or 0)
    if not immediate then self.activeTabPanel:AlphaTo(255, 0.16, 0) end
    hook.Run("CharacterCreationTabCreated", tab.id, self.activeTabPanel, self.context, self)
    if tab.onEnter then tab.onEnter(self.activeTabPanel, self.context, self) end
    hook.Run("CharacterCreationTabChanged", oldTab and oldTab.id or nil, tab.id, self.context, self)
    styleCreationComboBoxes(self.activeTabPanel)
    local complete = self:ValidateTab(tab)
    self.completedTabs[tab.id] = complete == true or nil
    self.backButton:SetVisible(index > 1)
    self.backButton._text = "BACK"
    self.mainMenuButton:SetVisible(true)
    self.nextButton._text = index == #self.tabs and "CREATE CHARACTER" or "NEXT"
    self.nextButton:SetEnabled(not self.creating)
    self:ShowError("")
    self:BuildTabNavigation()
    self:TransitionCamera(self:GetCameraModeForTab(tab), immediate and 0 or 0.65)
    self:InvalidateLayout(true)
end

function PANEL:Previous()
    if self.creating or self.currentIndex <= 1 then return end
    self:ShowTab(self.currentIndex - 1)
end

function PANEL:Next()
    if self.creating then return end
    if self.createdCharacterID then
        self:LoadCreatedCharacter()
        return
    end

    local tab = self.tabs[self.currentIndex]
    local ok, reason = self:ValidateTab(tab)
    if not ok then
        self.completedTabs[tab.id] = nil
        self:BuildTabNavigation()
        self:ShowError(reason or "Please complete this section.")
        return
    end

    self.completedTabs[tab.id] = true
    if self.currentIndex < #self.tabs then
        self:ShowTab(self.currentIndex + 1)
        return
    end

    for index, candidate in ipairs(self.tabs) do
        local valid, message = self:ValidateTab(candidate)
        if not valid then
            self.completedTabs[candidate.id] = nil
            self:ShowTab(index)
            self:ShowError(message or "Please complete this section.")
            return
        end

        self.completedTabs[candidate.id] = true
    end

    self:CreateCharacter()
end

function PANEL:BuildSummary()
    local summary = {}
    for _, tab in ipairs(self.tabs) do
        local startIndex = #summary + 1
        if tab.onBuildSummary then tab.onBuildSummary(self.context, summary, self) end
        for index = startIndex, #summary do
            local item = summary[index]
            if istable(item) then
                item.header = item.header or tab.reviewHeader or tab.name
                item.section = item.section or tab.id
            end
        end
    end

    hook.Run("BuildCharacterCreationSummary", self.context, summary, self)
    return summary
end

function PANEL:BuildPayload()
    local payload = {}
    for key in pairs(supportedPayloadKeys) do
        if lia.char.vars[key] and self.context[key] ~= nil then payload[key] = copyValue(self.context[key]) end
    end

    for _, tab in ipairs(self.tabs) do
        if tab.onBuildPayload then tab.onBuildPayload(payload, self.context, self) end
    end

    hook.Run("BuildCharacterCreationPayload", payload, self.context, self)
    for key in pairs(payload) do
        if not lia.char.vars[key] then payload[key] = nil end
    end

    if isstring(payload.name) then payload.name = string.Trim(payload.name) end
    if isstring(payload.desc) then payload.desc = string.Trim(payload.desc) end
    if payload.skin ~= nil then payload.skin = math.max(math.floor(tonumber(payload.skin) or 0), 0) end
    if istable(payload.bodygroups) then
        local bodygroups = {}
        for key, value in pairs(payload.bodygroups) do
            local group = tonumber(key)
            local selected = tonumber(value)
            if group and selected then bodygroups[group] = math.max(math.floor(selected), 0) end
        end

        payload.bodygroups = bodygroups
    end

    if istable(payload.attribs) then
        local attribs = {}
        for _, key in ipairs(attributeOrder) do
            attribs[key] = math.max(math.floor(tonumber(payload.attribs[key]) or 0), 0)
        end

        payload.attribs = attribs
    end
    return payload
end

function PANEL:LoadCreatedCharacter()
    if self.creating or not self.createdCharacterID then return end
    self.creating = true
    self.nextButton:SetEnabled(false)
    self.backButton:SetEnabled(false)
    self:ShowError("")
    lia.module.get("mainmenu"):ChooseCharacter(self.createdCharacterID):next(function()
        if not IsValid(self) then return end
        self.finished = true
        if IsValid(self.sourceMenu) then self.sourceMenu:Remove() end
        self:Remove()
    end):catch(function(err)
        if not IsValid(self) then return end
        self.creating = false
        self.nextButton:SetEnabled(true)
        self.nextButton._text = "LOAD CHARACTER"
        self:ShowError(err or "Character created, but it could not be loaded. Try loading it again.")
    end)
end

function PANEL:CreateCharacter()
    if self.creating then return end
    if self.createdCharacterID then
        self:LoadCreatedCharacter()
        return
    end

    self.creating = true
    self.nextButton:SetEnabled(false)
    self.backButton:SetEnabled(false)
    self:ShowError("")
    local payload = self:BuildPayload()
    local mainmenu = lia.module.get("mainmenu")
    mainmenu:CreateCharacter(payload):next(function(characterID)
        if not IsValid(self) then return end
        self.createdCharacterID = characterID
        hook.Run("CharacterCreationFinished", characterID, self.context, self)
        self.creating = false
        self:LoadCreatedCharacter()
    end):catch(function(err)
        if not IsValid(self) then return end
        self.creating = false
        self.nextButton:SetEnabled(true)
        self.backButton:SetEnabled(true)
        self:ShowError(err or "The server rejected this character.")
    end)
end

function PANEL:SetSourceMenu(menu)
    self.sourceMenu = menu
end

function PANEL:ReturnToMainMenu()
    if self.creating then return end
    self.returningToMenu = true
    if IsValid(self.sourceMenu) then
        self.sourceMenu:Remove()
        self.sourceMenu = nil
    end

    self:Remove()
    timer.Simple(0, function()
        local client = LocalPlayer()
        if not IsValid(client) or client:getChar() then return end
        local mainmenu = lia.module.get("mainmenu")
        if mainmenu and isfunction(mainmenu.OpenCharacterMenu) then mainmenu:OpenCharacterMenu() end
    end)
end

function PANEL:GetWorldModelBounds()
    if not IsValid(self.worldEntity) then return nil end
    local mins, maxs = self.worldEntity:GetRenderBounds()
    return mins, maxs
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

function PANEL:ApplyWorldAppearance()
    local entity = self.worldEntity
    if not IsValid(entity) then return end
    local skin = math.Clamp(math.floor(tonumber(self.context.skin) or 0), 0, math.max(entity:SkinCount() - 1, 0))
    entity:SetSkin(skin)
    for _, group in ipairs(entity:GetBodyGroups() or {}) do
        entity:SetBodygroup(group.id, 0)
    end

    for key, value in pairs(self.context.bodygroups or {}) do
        local id = tonumber(key)
        if id then entity:SetBodygroup(id, math.Clamp(math.floor(tonumber(value) or 0), 0, math.max(entity:GetBodygroupCount(id) - 1, 0))) end
    end
end

function PANEL:AlignWorldModelToGround()
    if not IsValid(self.worldEntity) then return end
    self.worldEntity:SetAngles(self.worldModelAngle or angle_zero)
    local mins = self:GetWorldModelBounds()
    if not mins then return end
    local base = self.worldGround or LocalPlayer():GetPos()
    self.worldEntity:SetPos(base - Vector(0, 0, mins.z))
    self.worldEntity:InvalidateBoneCache()
    self.worldEntity:SetupBones()
end

function PANEL:PlayIdleAnimation()
    applyIdleSequence(self.worldEntity)
end

function PANEL:RefreshWorldModel(transition)
    local _, _, parsed = getSelectedModelData(self.context)
    if not parsed or not isstring(parsed.model) or parsed.model == "" then return end
    local hadEntity = IsValid(self.worldEntity)
    if hadEntity then self.worldEntity:Remove() end
    util.PrecacheModel(parsed.model)
    self.worldEntity = ClientsideModel(parsed.model, RENDERGROUP_OPAQUE)
    if not IsValid(self.worldEntity) then return end
    self.worldEntity:SetNoDraw(false)
    self.worldEntity:DrawShadow(false)
    self.worldEntity:SetRenderMode(RENDERMODE_NORMAL)
    self.worldEntity:SetColor(color_white)
    self.worldEntity.liaSchemaCharacterCreatorPreview = true
    self.worldEntity.RenderOverride = function(entity) if IsValid(self) then self:DrawWorldPreviewEntity(entity) end end
    self:ApplyWorldAppearance()
    self:PlayIdleAnimation()
    self:AlignWorldModelToGround()
    local mode = self:GetCameraModeForTab(self.tabs[self.currentIndex])
    if transition and hadEntity then
        self:TransitionCamera(mode, 0.45)
    else
        self:RefreshCameraTarget(mode)
    end
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

    for _, boneName in ipairs({"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Head", "Bip01 Head", "Head"}) do
        local boneIndex = entity:LookupBone(boneName)
        if boneIndex then
            local position = entity:GetBonePosition(boneIndex)
            if position then return position end
        end
    end

    local mins, maxs = self:GetWorldModelBounds()
    if not mins or not maxs then return entity:GetPos() + Vector(0, 0, 64) end
    local height = math.max(maxs.z - mins.z, 48)
    return entity:GetPos() + Vector(0, 0, mins.z + height * 0.82)
end

function PANEL:GetPreviewTargetX()
    local paperX = getCreatorPaperMetrics()
    return math.max(paperX, 1) * 0.5
end

function PANEL:GetCenteredLookOffset(originRight, distance, fov)
    local screenWidth = math.max(ScrW(), 1)
    local screenHeight = math.max(ScrH(), 1)
    local targetFraction = math.Clamp(self:GetPreviewTargetX() / screenWidth, 0.01, 0.49)
    local normalizedX = targetFraction * 2 - 1
    local aspectScale = screenWidth / screenHeight / (4 / 3)
    local horizontalTan = math.tan(math.rad(fov * 0.5)) * aspectScale
    local screenAngle = math.atan(normalizedX * horizontalTan)
    local entityBearing = math.atan(-originRight / math.max(distance, 0.001))
    local cameraBearing = entityBearing - screenAngle
    return originRight + distance * math.tan(cameraBearing)
end

function PANEL:GetCameraPreset(mode)
    local entity = self.worldEntity
    if not IsValid(entity) then return nil end
    local mins, maxs = self:GetWorldModelBounds()
    if not mins or not maxs then return nil end
    local height = math.max(maxs.z - mins.z, 48)
    local base = entity:GetPos()
    if mode == "creation" then
        local fov = 28
        local head = self:GetPreviewHeadPosition() or base + Vector(0, 0, mins.z + height * 0.82)
        local distance = math.Clamp(height * 0.58, 38, 54)
        local originRight = -height * 0.025
        local lookRight = self:GetCenteredLookOffset(originRight, distance, fov)
        local look = head + self.worldRight * lookRight - Vector(0, 0, height * 0.012)
        local origin = head - self.worldForward * distance + self.worldRight * originRight + Vector(0, 0, height * 0.008)
        return origin, look, fov
    end

    if mode == "summary" then
        local fov = 32
        local head = self:GetPreviewHeadPosition() or base + Vector(0, 0, mins.z + height * 0.82)
        local distance = math.Clamp(height * 0.92, 68, 90)
        local originRight = height * 0.245
        local lookRight = self:GetCenteredLookOffset(originRight, distance, fov)
        local anchor = head - Vector(0, 0, height * 0.14)
        local look = anchor + self.worldRight * lookRight
        local origin = anchor - self.worldForward * distance + self.worldRight * originRight + Vector(0, 0, height * 0.04)
        return origin, look, fov
    end

    local fov = 46
    local width = math.max(maxs.x - mins.x, maxs.y - mins.y, 24)
    local center = base + Vector(0, 0, mins.z + height * 0.5)
    local horizontalOffset = height * 0.14
    local distance = math.max(height * 1.9, width * 2.15, 146)
    local originRight = 6 + horizontalOffset
    local lookRight = self:GetCenteredLookOffset(originRight, distance, fov)
    local look = center + self.worldRight * lookRight
    local origin = center - self.worldForward * distance + self.worldRight * originRight + Vector(0, 0, height * 0.1)
    return origin, look, fov
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
    self.cameraDuration = duration or 0.65
    if self.cameraDuration <= 0 then
        self.cameraCurrentOrigin = origin
        self.cameraCurrentLook = look
        self.cameraCurrentFOV = fov
    end
end

function PANEL:UpdateHeadTracking()
    local entity = self.worldEntity
    if not IsValid(entity) then return end
    local mouseX, mouseY = gui.MousePos()
    local yaw = 0
    local pitch = 0
    if mouseX >= 0 and mouseY >= 0 then
        yaw = math.Clamp((mouseX / ScrW() - 0.35) * 70, -35, 35)
        pitch = math.Clamp((0.48 - mouseY / ScrH()) * 55, -20, 20)
    end

    entity:SetPoseParameter("head_yaw", yaw)
    entity:SetPoseParameter("head_pitch", pitch)
    entity:SetPoseParameter("aim_yaw", yaw * 0.35)
    entity:SetPoseParameter("aim_pitch", pitch * 0.35)
    entity:InvalidateBoneCache()
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

function PANEL:PerformLayout()
    if IsValid(self.inputWindow) then
        self.inputWindow:SetPos(0, 0)
        self.inputWindow:SetSize(ScrW(), ScrH())
    end

    if not IsValid(self.paper) then return end
    local paperX, paperY, paperWidth, paperHeight = getCreatorPaperMetrics()
    self.paper:SetPos(paperX, paperY)
    self.paper:SetSize(paperWidth, paperHeight)
    self.page:SetPos(22, 14)
    self.page:SetSize(paperWidth - 44, paperHeight - 28)
    local w, h = self.page:GetSize()
    self.header:SetPos(0, 0)
    self.header:SetSize(w, 62)
    local top = 76
    local bottomHeight = self.errorPanel:IsVisible() and 92 or 54
    local bodyHeight = math.max(h - top - bottomHeight, 1)
    local navWidth = math.Clamp(math.floor(w * 0.2), 170, 220)
    local gap = 14
    self.tabNavigation:SetPos(0, top)
    self.tabNavigation:SetSize(navWidth, bodyHeight)
    local tabGap = 8
    local tabHeight = math.Clamp(math.floor((bodyHeight - 20 - (#self.tabButtons - 1) * tabGap) / math.max(#self.tabButtons, 1)), 70, 86)
    local tabY = 10
    for _, button in ipairs(self.tabButtons or {}) do
        button:SetPos(10, tabY)
        button:SetSize(navWidth - 20, tabHeight)
        tabY = tabY + tabHeight + tabGap
    end

    local stageX = navWidth + gap
    self.stage:SetPos(stageX, top)
    self.stage:SetSize(math.max(w - stageX, 1), bodyHeight)
    if IsValid(self.activeTabPanel) then
        self.activeTabPanel:SetPos(18, 18)
        self.activeTabPanel:SetSize(math.max(self.stage:GetWide() - 36, 1), math.max(self.stage:GetTall() - 36, 1))
        self.activeTabPanel:InvalidateLayout(true)
    end

    local buttonY = h - 40
    if self.errorPanel:IsVisible() then
        self.errorPanel:SetPos(stageX, h - 82)
        self.errorPanel:SetSize(math.max(w - stageX, 1), 32)
        self.errorLabel:SetPos(10, 0)
        self.errorLabel:SetSize(self.errorPanel:GetWide() - 20, 32)
        buttonY = h - 40
    end

    local buttonWidth = math.Clamp(math.floor((w - gap) * 0.22), 130, 200)
    self.backButton:SetPos(0, buttonY)
    self.backButton:SetSize(buttonWidth, 40)
    local mainMenuX = self.currentIndex > 1 and (w - buttonWidth) * 0.5 or 0
    self.mainMenuButton:SetPos(mainMenuX, buttonY)
    self.mainMenuButton:SetSize(buttonWidth, 40)
    self.nextButton:SetPos(w - buttonWidth, buttonY)
    self.nextButton:SetSize(buttonWidth, 40)
end

function PANEL:Think()
    if CurTime() >= (self.nextDropdownStyleCheck or 0) then
        self.nextDropdownStyleCheck = CurTime() + 0.75
        styleCreationComboBoxes(self.activeTabPanel)
    end

    if IsValid(self.inputWindow) then
        self.inputWindow:SetMouseInputEnabled(true)
        self.inputWindow:SetKeyboardInputEnabled(true)
    end

    if CurTime() >= (self.nextEntityHide or 0) then
        self.nextEntityHide = CurTime() + 0.15
        self:HideWorldEntities()
    end

    if IsValid(self.worldEntity) then
        self.worldEntity:SetNoDraw(false)
        self.worldEntity:FrameAdvance(FrameTime())
        self:UpdateHeadTracking()
    end
end

function PANEL:OnKeyCodePressed(key)
    if key == KEY_ESCAPE and not self.creating then self:ReturnToMainMenu() end
end

function PANEL:OnRemove()
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
    if lia.gui.schemaCharacterCreator == self then lia.gui.schemaCharacterCreator = nil end
    if MODULE.creationContext == self.context then MODULE.creationContext = {} end
    if not self.finished and not self.returningToMenu then
        timer.Simple(0, function()
            local client = LocalPlayer()
            if not IsValid(client) or client:getChar() then return end
            local mainmenu = lia.module.get("mainmenu")
            if mainmenu and isfunction(mainmenu.ResetCharacterPanel) then mainmenu:ResetCharacterPanel() end
        end)
    end
end

function PANEL:Paint(w, h)
    local activeTab = self.tabs and self.tabs[self.currentIndex]
    if (not activeTab or activeTab.id ~= "appearance") and lia.util and isfunction(lia.util.drawBlackBlur) then lia.util.drawBlackBlur(self, 1, 4, 255, 90) end
    surface.SetDrawColor(getThemeBackgroundColor(42))
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("liaSchemaCharacterCreator", PANEL, "EditablePanel")
local function addPageHeading(panel, title, subtitle)
    panel.title = panel:Add("DLabel")
    panel.title:SetFont("LiliaFont.30")
    panel.title:SetText(title)
    panel.title:SetTextColor(getThemeTextColor())
    bindThemedLabel(panel.title, function() return getThemeTextColor() end)
    panel.subtitle = panel:Add("DLabel")
    panel.subtitle:SetFont("LiliaFont.16")
    panel.subtitle:SetText(subtitle)
    panel.subtitle:SetTextColor(getThemeMutedColor())
    panel.subtitle:SetWrap(true)
    bindThemedLabel(panel.subtitle, function() return getThemeMutedColor() end)
end

local function paintSection(_, w, h)
    local accent = getThemeAccent()
    drawPanel(0, 0, w, h, 7, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 52))
end

hook.Add("OpenCharacterMenuOverride", "SchemaCharacterCreatorMenuIntegration", function()
    local menu = vgui.Create("liaCharacter")
    menu.createCharacterCreation = function(self)
        if IsValid(lia.gui.schemaCharacterCreator) then lia.gui.schemaCharacterCreator:Remove() end
        self:SetVisible(false)
        local creator = vgui.Create("liaSchemaCharacterCreator")
        creator:SetSourceMenu(self)
        return creator
    end
    return menu
end)

hook.Add("RegisterCharacterCreationTabs", "liaSchemaCharacterCreatorBuiltins", function(tabs)
    tabs["faction"] = {
        name = "Faction",
        order = 10,
        onCreate = function(parent, context, creator)
            local panel = vgui.Create("DPanel", parent)
            panel:SetPaintBackground(false)
            addPageHeading(panel, "FACTION", "Select the faction this character belongs to. Your choice updates the available models and world preview.")
            panel.scroll = panel:Add("DScrollPanel")
            panel.scroll.Paint = function() end
            styleScrollBar(panel.scroll)
            panel.cards = {}
            for _, faction in ipairs(getAvailableFactions()) do
                local card = panel.scroll:Add("DButton")
                card:SetText("")
                card._hover = 0
                card.faction = faction
                card.Think = function(self) self._hover = Lerp(FrameTime() * 12, self._hover or 0, self:IsHovered() and 1 or 0) end
                card.Paint = function(button, w, h)
                    local selected = context.faction == faction.index
                    local accent = IsColor(faction.color) and faction.color or getThemeAccent()
                    drawPanel(0, 0, w, h, 7, selected and Color(accent.r, accent.g, accent.b, 28) or getThemeSurface(0.05, 238), Color(accent.r, accent.g, accent.b, selected and 190 or 48 + (button._hover or 0) * 82))
                    if selected then
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 235)
                        surface.DrawRect(0, 0, 4, h)
                    end

                    local logo = getFactionLogo(faction)
                    local textX = 16
                    if logo then
                        surface.SetMaterial(logo)
                        surface.SetDrawColor(255, 255, 255, 220)
                        surface.DrawTexturedRect(16, 16, 52, 52)
                        textX = 82
                    end

                    draw.SimpleText(faction.name or "Faction", "LiliaFont.22", textX, 16, getThemeTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    local desc = tostring(faction.desc or "No description available.")
                    draw.SimpleText(string.sub(desc:gsub("\n", " "), 1, 84), "LiliaFont.15", textX, 46, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end

                card.DoClick = function()
                    if context.faction == faction.index then return end
                    context.faction = faction.index
                    context.attribs = context.attribs or {}
                    resetCreationClassForFaction(context, faction)
                    applyDefaultsForFaction(context, faction)
                    applyIdentityDefaults(context)
                    creator.completedTabs.faction = nil
                    creator.completedTabs.class = nil
                    creator.completedTabs.identity = nil
                    creator.completedTabs.appearance = nil
                    local factionTabIndex = creator:RefreshVisibleTabs("faction")
                    creator:RefreshWorldModel(true)
                    creator:ShowTab(factionTabIndex, true)
                end

                panel.cards[#panel.cards + 1] = card
            end

            panel.PerformLayout = function(self, w, h)
                self.title:SetPos(0, 0)
                self.title:SetSize(w, 36)
                self.subtitle:SetPos(0, 40)
                self.subtitle:SetSize(w, 42)
                self.scroll:SetPos(0, 92)
                self.scroll:SetSize(w, math.max(h - 92, 1))
                local canvas = self.scroll:GetCanvas()
                local cardW = math.max(self.scroll:GetWide() - 12, 1)
                local y = 0
                for _, card in ipairs(self.cards) do
                    card:SetPos(0, y)
                    card:SetSize(cardW, 86)
                    y = y + 96
                end

                canvas:SetTall(y)
            end
            return panel
        end,
        onValidate = function(context)
            if not context.faction or not getFactionByIndex(context.faction) then return false, "Choose an available faction." end
            return true
        end,
        onBuildSummary = function(context, summary)
            local faction = getFactionByIndex(context.faction)
            if faction then
                summary[#summary + 1] = {
                    title = "Faction",
                    value = faction.name
                }
            end
        end
    }

    tabs["class"] = {
        name = "Class",
        order = 15,
        shouldShow = function(_, context)
            local faction = getFactionByIndex(context.faction)
            return #getDefaultCreationClasses(faction) > 1
        end,
        onCreate = function(parent, context, creator)
            local panel = vgui.Create("DPanel", parent)
            panel:SetPaintBackground(false)
            addPageHeading(panel, "CLASS", "This faction has multiple default classes. Choose which class this character should start as.")
            panel.scroll = panel:Add("DScrollPanel")
            panel.scroll.Paint = function() end
            styleScrollBar(panel.scroll)
            panel.cards = {}
            local faction = getFactionByIndex(context.faction)
            for _, class in ipairs(getDefaultCreationClasses(faction)) do
                local card = panel.scroll:Add("DButton")
                card:SetText("")
                card._hover = 0
                card.class = class
                card.Think = function(self) self._hover = Lerp(FrameTime() * 12, self._hover or 0, self:IsHovered() and 1 or 0) end
                card.Paint = function(button, w, h)
                    local selected = tonumber(context.class) == tonumber(class.index)
                    local accent = IsColor(class.color) and class.color or faction and IsColor(faction.color) and faction.color or getThemeAccent()
                    drawPanel(0, 0, w, h, 7, selected and Color(accent.r, accent.g, accent.b, 28) or getThemeSurface(0.05, 238), Color(accent.r, accent.g, accent.b, selected and 190 or 48 + (button._hover or 0) * 82))
                    if selected then
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 235)
                        surface.DrawRect(0, 0, 4, h)
                    end

                    local logo = getClassLogo(class, faction)
                    local textX = 16
                    if logo then
                        surface.SetMaterial(logo)
                        surface.SetDrawColor(255, 255, 255, 220)
                        surface.DrawTexturedRect(16, 16, 52, 52)
                        textX = 82
                    end

                    draw.SimpleText(tostring(class.name or class.uniqueID or "Class"), "LiliaFont.22", textX, 16, getThemeTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    local desc = tostring(class.desc or "Default class for this faction.")
                    draw.SimpleText(string.sub(desc:gsub("\n", " "), 1, 100), "LiliaFont.15", textX, 46, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end

                card.DoClick = function()
                    if tonumber(context.class) == tonumber(class.index) then return end
                    context.class = class.index
                    applyDefaultsForFaction(context, faction)
                    applyIdentityDefaults(context)
                    creator.completedTabs.class = nil
                    creator.completedTabs.identity = nil
                    creator.completedTabs.appearance = nil
                    creator:RefreshWorldModel(true)
                    creator:RefreshActiveTabValidation()
                end

                panel.cards[#panel.cards + 1] = card
            end

            panel.PerformLayout = function(self, w, h)
                self.title:SetPos(0, 0)
                self.title:SetSize(w, 36)
                self.subtitle:SetPos(0, 40)
                self.subtitle:SetSize(w, 42)
                self.scroll:SetPos(0, 92)
                self.scroll:SetSize(w, math.max(h - 92, 1))
                local canvas = self.scroll:GetCanvas()
                local cardW = math.max(self.scroll:GetWide() - 12, 1)
                local y = 0
                for _, card in ipairs(self.cards) do
                    card:SetPos(0, y)
                    card:SetSize(cardW, 86)
                    y = y + 96
                end

                canvas:SetTall(y)
            end
            return panel
        end,
        onValidate = function(context)
            local faction = getFactionByIndex(context.faction)
            local classes = getDefaultCreationClasses(faction)
            if #classes <= 1 then return true end
            if not isDefaultCreationClass(faction, context.class) then return false, "Choose a default class." end
            return true
        end,
        onBuildSummary = function(context, summary)
            local faction = getFactionByIndex(context.faction)
            local _, class = isDefaultCreationClass(faction, context.class)
            if class then
                summary[#summary + 1] = {
                    title = "Class",
                    value = tostring(class.name or class.uniqueID or class.index)
                }
            end
        end
    }

    tabs["attributes"] = {
        name = "Attributes",
        order = 40,
        onCreate = function(parent, context, creator)
            context.attribs = context.attribs or {}
            local panel = vgui.Create("DPanel", parent)
            panel:SetPaintBackground(false)
            addPageHeading(panel, "ATTRIBUTES", "Allocate the normal Lilia starting-point budget between Agility, Endurance, and Strength.")
            panel.budget = hook.Run("GetMaxStartingAttributePoints", LocalPlayer(), lia.config.get("StartingAttributePoints", 30)) or lia.config.get("StartingAttributePoints", 30)
            panel.remaining = panel:Add("DPanel")
            panel.remaining.Paint = function(_, w, h)
                local accent = getThemeAccent()
                drawPanel(0, 0, w, h, 7, Color(accent.r, accent.g, accent.b, 20), Color(accent.r, accent.g, accent.b, 80))
                local spent = 0
                for _, value in pairs(context.attribs or {}) do
                    spent = spent + (tonumber(value) or 0)
                end

                draw.SimpleText("POINTS REMAINING", "LiliaFont.16", 14, 9, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(tostring(math.max(panel.budget - spent, 0)), "LiliaFont.30", w - 14, h * 0.5, accent, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end

            panel.rows = {}
            local function spentPoints()
                local spent = 0
                for _, value in pairs(context.attribs or {}) do
                    spent = spent + (tonumber(value) or 0)
                end
                return spent
            end

            for _, key in ipairs(attributeOrder) do
                local attribute = lia.attribs and lia.attribs.list and lia.attribs.list[key]
                if not attribute or attribute.noStartBonus then continue end
                context.attribs[key] = tonumber(context.attribs[key]) or 0
                local row = panel:Add("DPanel")
                row.Paint = paintSection
                row.name = row:Add("DLabel")
                row.name:SetFont("LiliaFont.20")
                row.name:SetText(attribute.name or key)
                row.name:SetTextColor(getThemeTextColor())
                bindThemedLabel(row.name, function() return getThemeTextColor() end)
                row.desc = row:Add("DLabel")
                row.desc:SetFont("LiliaFont.14")
                row.desc:SetText(attribute.desc or "")
                row.desc:SetTextColor(getThemeMutedColor())
                row.desc:SetWrap(true)
                bindThemedLabel(row.desc, function() return getThemeMutedColor() end)
                row.minus = makeButton(row, "−", true)
                row.value = row:Add("DLabel")
                row.value:SetFont("LiliaFont.24")
                row.value:SetTextColor(getThemeTextColor())
                row.value:SetContentAlignment(5)
                bindThemedLabel(row.value, function() return getThemeTextColor() end)
                row.plus = makeButton(row, "+")
                local function update()
                    row.value:SetText(tostring(context.attribs[key] or 0))
                    panel.remaining:InvalidateLayout(true)
                    if IsValid(creator) then creator:RefreshActiveTabValidation() end
                end

                local function getAdjustmentStep()
                    if input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT) then return 10 end
                    if input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL) then return 5 end
                    return 1
                end

                row.minus.DoClick = function()
                    local current = tonumber(context.attribs[key]) or 0
                    context.attribs[key] = math.max(current - getAdjustmentStep(), 0)
                    update()
                end

                row.plus.DoClick = function()
                    local current = tonumber(context.attribs[key]) or 0
                    local maximum = tonumber(attribute.startingMax)
                    local remaining = math.max(panel.budget - spentPoints(), 0)
                    if remaining <= 0 or maximum and current >= maximum then return end
                    local target = current + math.min(getAdjustmentStep(), remaining)
                    if maximum then target = math.min(target, maximum) end
                    context.attribs[key] = target
                    update()
                end

                update()
                panel.rows[#panel.rows + 1] = row
            end

            panel.PerformLayout = function(self, w, h)
                self.title:SetPos(0, 0)
                self.title:SetSize(w, 36)
                self.subtitle:SetPos(0, 40)
                self.subtitle:SetSize(w, 42)
                self.remaining:SetPos(0, 96)
                self.remaining:SetSize(w, 62)
                local y = 172
                for _, row in ipairs(self.rows) do
                    row:SetPos(0, y)
                    row:SetSize(w, 92)
                    row.name:SetPos(14, 12)
                    row.name:SetSize(math.max(w - 190, 1), 24)
                    row.desc:SetPos(14, 39)
                    row.desc:SetSize(math.max(w - 190, 1), 40)
                    row.plus:SetPos(w - 48, 24)
                    row.plus:SetSize(36, 44)
                    row.value:SetPos(w - 96, 24)
                    row.value:SetSize(44, 44)
                    row.minus:SetPos(w - 136, 24)
                    row.minus:SetSize(36, 44)
                    y = y + 102
                end
            end
            return panel
        end,
        onValidate = function(context)
            local budget = hook.Run("GetMaxStartingAttributePoints", LocalPlayer(), lia.config.get("StartingAttributePoints", 30)) or lia.config.get("StartingAttributePoints", 30)
            local spent = 0
            for _, key in ipairs(attributeOrder) do
                local attribute = lia.attribs and lia.attribs.list and lia.attribs.list[key]
                if not attribute or attribute.noStartBonus then return false, "A required schema attribute is unavailable: " .. key end
                local value = tonumber(context.attribs and context.attribs[key]) or 0
                if value < 0 or value ~= math.floor(value) then return false, "Attribute allocations must be whole non-negative values." end
                if attribute.startingMax and value > attribute.startingMax then return false, (attribute.name or key) .. " exceeds its starting maximum." end
                spent = spent + value
            end

            if spent ~= budget then return false, "Allocate all " .. budget .. " available attribute points." end
            return true
        end,
        onBuildSummary = function(context, summary)
            for _, key in ipairs(attributeOrder) do
                local attribute = lia.attribs and lia.attribs.list and lia.attribs.list[key]
                summary[#summary + 1] = {
                    title = attribute and attribute.name or key,
                    value = tostring(context.attribs and context.attribs[key] or 0),
                    section = "attributes"
                }
            end
        end
    }

    tabs["identity"] = {
        name = "Identity",
        order = 20,
        onCreate = function(parent, context, creator)
            applyIdentityDefaults(context)
            local panel = vgui.Create("DPanel", parent)
            panel:SetPaintBackground(false)
            addPageHeading(panel, "IDENTITY", "Define the character's required identity fields. Server-side character validation still applies.")
            panel.controls = {}
            panel.contextEntries = {}
            panel.SyncContext = function(self)
                for key, entry in pairs(self.contextEntries) do
                    if IsValid(entry) then context[key] = entry:GetValue() end
                end
            end

            panel.SetContextEntryValue = function(self, key, value)
                value = tostring(value or "")
                context[key] = value
                local entry = self.contextEntries[key]
                if IsValid(entry) and entry:GetValue() ~= value then entry:SetValue(value) end
            end

            local function bindEntry(entry, key, editable)
                panel.contextEntries[key] = entry
                entry:SetEditable(editable ~= false)
                if editable == false then return end
                local function sync(self, value)
                    context[key] = tostring(value ~= nil and value or self:GetValue() or "")
                    if IsValid(creator) and creator.activeTabPanel == panel then creator:RefreshActiveTabValidation() end
                end

                entry.OnChange = function(self) sync(self) end
                entry.OnValueChange = function(self, value) sync(self, value) end
                entry.OnLoseFocus = function(self) sync(self) end
                entry.OnEnter = function(self) sync(self) end
            end

            if hook.Run("ShouldShowCharVarInCreation", "name") ~= false then
                local wrap, entry = makeEntry(panel, "NAME", false)
                wrap:SetTall(86)
                entry:SetValue(tostring(context.name or ""))
                bindEntry(entry, "name", hook.Run("CanEditCharVarInCreation", "name", context, creator) ~= false)
                panel.controls[#panel.controls + 1] = wrap
            end

            if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false then
                local wrap, entry = makeEntry(panel, "DESCRIPTION", true)
                wrap:SetTall(120)
                entry:SetValue(tostring(context.desc or ""))
                bindEntry(entry, "desc", hook.Run("CanEditCharVarInCreation", "desc", context, creator) ~= false)
                panel.controls[#panel.controls + 1] = wrap
            end

            panel.PerformLayout = function(self, w, h)
                self.title:SetPos(0, 0)
                self.title:SetSize(w, 36)
                self.subtitle:SetPos(0, 40)
                self.subtitle:SetSize(w, 42)
                local y = 98
                for _, control in ipairs(self.controls) do
                    control:SetPos(0, y)
                    control:SetSize(w, control:GetTall())
                    y = y + control:GetTall() + 14
                end
            end
            return panel
        end,
        onLeave = function(panel) if IsValid(panel) and isfunction(panel.SyncContext) then panel:SyncContext() end end,
        onValidate = function(context)
            local defaultName, nameOverride = hook.Run("GetDefaultCharName", LocalPlayer(), context.faction, context)
            local nameIsForced = isstring(defaultName) and nameOverride == true
            if hook.Run("ShouldShowCharVarInCreation", "name") ~= false and not nameIsForced and string.Trim(tostring(context.name or "")) == "" then return false, "A character name is required." end
            if hook.Run("ShouldShowCharVarInCreation", "desc") ~= false then
                local description = string.Trim(tostring(context.desc or ""))
                if description == "" then return false, "A character description is required." end
                local minimum = lia.config.get("MinDescLen", 16)
                if #description:gsub("%s", "") < minimum then return false, "Description must contain at least " .. minimum .. " non-space characters." end
            end
            return true
        end,
        onBuildSummary = function(context, summary)
            summary[#summary + 1] = {
                title = "Name",
                value = tostring(context.name or ""),
                order = -100,
                layout = "wide"
            }

            summary[#summary + 1] = {
                title = "Description",
                value = tostring(context.desc or ""),
                order = 100000,
                layout = "wide"
            }

        end
    }

    tabs["appearance"] = {
        name = "Appearance",
        order = 30,
        onCreate = function(parent, context, creator)
            local panel = vgui.Create("DPanel", parent)
            panel:SetPaintBackground(false)
            addPageHeading(panel, "APPEARANCE", "Choose a valid model. Skin and bodygroup options appear below when the selected model allows them.")
            panel.searchWrap = panel:Add("DPanel")
            panel.searchWrap.Paint = function(_, w, h)
                local accent = getThemeAccent()
                drawPanel(0, 0, w, h, 7, getThemeSurface(0.04, 235), Color(accent.r, accent.g, accent.b, 52))
                draw.SimpleText("⌕", "LiliaFont.18", 14, h * 0.5, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            panel.searchEntry = panel.searchWrap:Add("DTextEntry")
            panel.searchEntry:SetFont("LiliaFont.16")
            panel.searchEntry:SetTextColor(getThemeTextColor())
            panel.searchEntry:SetCursorColor(getThemeAccent())
            panel.searchEntry:SetHighlightColor(getThemeAccent(100))
            panel.searchEntry:SetDrawBackground(false)
            panel.searchEntry:SetPaintBackground(false)
            panel.searchEntry:SetPaintBorderEnabled(false)
            panel.searchEntry:SetUpdateOnType(true)
            panel.searchEntry.Paint = function(self, w, h)
                self:DrawTextEntryText(getThemeTextColor(), getThemeAccent(), getThemeTextColor())
                if string.Trim(self:GetValue() or "") == "" and not self:HasFocus() then draw.SimpleText("Search models...", "LiliaFont.16", 0, h * 0.5, getThemeMutedColor(150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            end

            panel.filterCombo = panel:Add("liaComboBox")
            panel.filterCombo:SetFont("LiliaFont.16")
            panel.filterCombo:PostInit()
            panel.filterCombo:AddChoice("All Models", "all")
            panel.filterCombo:AddChoice("Male", "male")
            panel.filterCombo:AddChoice("Female", "female")
            panel.filterCombo:FinishAddingOptions()
            panel.filterCombo:ChooseOptionData("all")
            panel.filterCombo.OnSelect = function(_, _, _, value)
                panel.selectedGender = value or "all"
                if isfunction(panel.ApplyModelFilters) then panel:ApplyModelFilters() end
            end

            panel.modelWrap = panel:Add("DPanel")
            panel.modelWrap.Paint = function(_, w, h)
                local accent = getThemeAccent()
                drawPanel(0, 0, w, h, 7, getThemeSurface(0.035, 224), Color(accent.r, accent.g, accent.b, 48))
            end

            panel.modelScroll = panel.modelWrap:Add("liaScrollPanel")
            panel.modelScroll.Paint = function() end
            styleScrollBar(panel.modelScroll)
            panel.modelEmpty = panel.modelWrap:Add("DLabel")
            panel.modelEmpty:SetFont("LiliaFont.18")
            panel.modelEmpty:SetText("No models match the current filters.")
            panel.modelEmpty:SetTextColor(getThemeMutedColor())
            panel.modelEmpty:SetContentAlignment(5)
            bindThemedLabel(panel.modelEmpty, function() return getThemeMutedColor() end)
            panel.modelEmpty:SetVisible(false)
            panel.customWrap = panel:Add("DPanel")
            panel.customWrap:SetVisible(false)
            panel.customWrap.Paint = function(_, w, h)
                local accent = getThemeAccent()
                drawPanel(0, 0, w, h, 7, getThemeSurface(0.035, 228), Color(accent.r, accent.g, accent.b, 48))
            end

            panel.customHeader = panel.customWrap:Add("liaHeaderPanel")
            panel.customHeader:SetLineWidth(1)
            panel.customHeader.Think = function(self) self:SetLineColor(getThemeAccent(150)) end
            panel.customTitle = panel.customHeader:Add("DLabel")
            panel.customTitle:SetFont("LiliaFont.18")
            panel.customTitle:SetText("SKIN & BODYGROUPS")
            panel.customTitle:SetTextColor(getThemeTextColor())
            bindThemedLabel(panel.customTitle, function() return getThemeTextColor() end)
            panel.customTitle:SetContentAlignment(4)
            panel.customSubtitle = panel.customWrap:Add("DLabel")
            panel.customSubtitle:SetFont("LiliaFont.14")
            panel.customSubtitle:SetText("Available options for the selected model.")
            panel.customSubtitle:SetTextColor(getThemeMutedColor())
            bindThemedLabel(panel.customSubtitle, function() return getThemeMutedColor() end)
            panel.customScroll = panel.customWrap:Add("liaScrollPanel")
            panel.customScroll.Paint = function() end
            styleScrollBar(panel.customScroll)
            panel.modelCards = {}
            panel.visibleModelCards = {}
            panel.customControls = {}
            panel.selectedGender = "all"
            local faction = getFactionByIndex(context.faction)
            local models = getFilteredModels(faction, context)
            if #models > 0 then
                local hasSelection = false
                for _, modelData in ipairs(models) do
                    if modelData.key == context.model then
                        hasSelection = true
                        break
                    end
                end

                if not hasSelection then setDefaultAppearance(context, models[1].key, models[1].parsed) end
            end

            for _, modelData in ipairs(models) do
                local card = panel.modelScroll:Add("DButton")
                card:SetText("")
                card.index = modelData.key
                card.modelData = modelData
                card.displaySubtitle = getModelDisplaySubtitle(modelData)
                local gender = string.lower(tostring(hook.Run("GetModelGender", modelData.parsed.model) or "male"))
                card.gender = gender == "female" and "female" or "male"
                card._hover = 0
                card.Think = function(self)
                    local hovering = self:IsHovered() or IsValid(self.icon) and self.icon:IsHovered()
                    self._hover = Lerp(FrameTime() * 12, self._hover or 0, hovering and 1 or 0)
                end

                card.Paint = function(self, w, h)
                    local accent = getThemeAccent()
                    local selected = context.model == self.index
                    local hover = self._hover or 0
                    local background = selected and Color(accent.r, accent.g, accent.b, 24) or getThemeSurface(0.045 + hover * 0.02, 224)
                    local outline = Color(accent.r, accent.g, accent.b, selected and 190 or 36 + hover * 72)
                    drawPanel(0, 0, w, h, 7, background, outline)
                    if selected then
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 225)
                        surface.DrawRect(0, 0, 2, h)
                    end
                end

                local icon = card:Add("SpawnIcon")
                card.icon = icon
                icon.index = modelData.key
                icon.modelData = modelData
                local resolvedGroups = resolveBodygroups(modelData.parsed.model, modelData.parsed.bodygroups)
                local bodyGroups = ""
                for i = 0, 8 do
                    bodyGroups = bodyGroups .. tostring(resolvedGroups[i] or 0)
                end

                local skin = tonumber(modelData.parsed.skin) or 0
                icon:SetModel(modelData.parsed.model, skin, bodyGroups)
                icon:SetTooltip(modelData.parsed.model)
                icon.model = modelData.parsed.model
                icon.skin = skin
                icon.bodyGroups = bodyGroups
                icon.PaintOver = function() end
                card.modelLabel = card:Add("DLabel")
                card.modelLabel:SetFont("LiliaFont.14")
                card.modelLabel:SetText(card.displaySubtitle)
                card.modelLabel:SetTextColor(getThemeMutedColor())
                card.modelLabel:SetContentAlignment(7)
                card.modelLabel:SetMouseInputEnabled(false)
                bindThemedLabel(card.modelLabel, function() return getThemeMutedColor() end)
                card.DoClick = function()
                    setDefaultAppearance(context, modelData.key, modelData.parsed)
                    creator.completedTabs.appearance = nil
                    creator:RefreshWorldModel(true)
                    creator:ShowTab(creator.currentIndex, true)
                end

                icon.DoClick = card.DoClick
                hook.Run("OnCharacterCreationModelIconSet", icon, modelData.parsed.model, skin, bodyGroups)
                panel.modelCards[#panel.modelCards + 1] = card
            end

            function panel:ApplyModelFilters()
                self.visibleModelCards = {}
                local query = string.Trim(self.searchEntry:GetValue() or "")
                local selectedGender = self.selectedGender or "all"
                for _, card in ipairs(self.modelCards) do
                    local matchesGender = selectedGender == "all" or card.gender == selectedGender
                    local matchesSearch = matchesModelSearch(card.modelData, query)
                    local visible = matchesGender and matchesSearch
                    card:SetVisible(visible)
                    if visible then self.visibleModelCards[#self.visibleModelCards + 1] = card end
                end

                if #self.modelCards == 0 then
                    self.modelEmpty:SetText("No valid models are available for this faction/class.")
                else
                    self.modelEmpty:SetText("No models match the current filters.")
                end

                self.modelEmpty:SetVisible(#self.visibleModelCards == 0)
                self:InvalidateLayout(true)
            end

            panel.searchEntry.OnValueChange = function() if isfunction(panel.ApplyModelFilters) then panel:ApplyModelFilters() end end
            local function addSkinSlideBox(maximum, selected, isAllowed, onSelect)
                if maximum <= 0 then return end
                local control = panel.customScroll:Add("liaSlideBox")
                control.controlType = "slidebox"
                control:SetText("Skin")
                control:SetRange(0, maximum, 0)
                local updating = false
                local function nearestAllowed(value)
                    value = math.Clamp(math.Round(tonumber(value) or 0), 0, maximum)
                    if isAllowed(value) then return value end
                    for distance = 1, maximum do
                        local lower = value - distance
                        if lower >= 0 and isAllowed(lower) then return lower end
                        local upper = value + distance
                        if upper <= maximum and isAllowed(upper) then return upper end
                    end
                    return 0
                end

                local initial = nearestAllowed(selected)
                control:SetValue(initial)
                control.OnValueChanged = function(self, value)
                    if updating then return end
                    local valid = nearestAllowed(value)
                    if valid ~= math.Round(value) then
                        updating = true
                        self:SetValue(valid)
                        updating = false
                    end

                    onSelect(valid)
                end

                panel.customControls[#panel.customControls + 1] = control
            end

            local function addBodygroupSlider(title, values, selected, onSelect)
                if #values <= 1 then return end
                local control = panel.customScroll:Add("DPanel")
                control:SetPaintBackground(false)
                control.controlType = "slider"
                control.header = control:Add("liaHeaderPanel")
                control.header:SetLineWidth(1)
                control.header.Think = function(self) self:SetLineColor(getThemeAccent(90)) end
                control.label = control.header:Add("DLabel")
                control.label:SetFont("LiliaFont.15")
                control.label:SetText(string.upper(title))
                control.label:SetTextColor(getThemeMutedColor())
                control.label:SetContentAlignment(4)
                bindThemedLabel(control.label, function() return getThemeMutedColor() end)
                control.valueLabel = control.header:Add("DLabel")
                control.valueLabel:SetFont("LiliaFont.15")
                control.valueLabel:SetTextColor(getThemeTextColor())
                control.valueLabel:SetContentAlignment(6)
                bindThemedLabel(control.valueLabel, function() return getThemeTextColor() end)
                control.slider = control:Add("liaSlider")
                control.slider:SetRange(0, #values - 1, 0)
                local selectedIndex = 1
                local selectedValue = tonumber(selected) or values[1]
                for index, value in ipairs(values) do
                    if tonumber(value) == selectedValue then
                        selectedIndex = index
                        break
                    end
                end

                control.slider:SetValue(selectedIndex - 1)
                control.valueLabel:SetText(tostring(values[selectedIndex]))
                control.slider.OnValueChanged = function(_, sliderValue)
                    local index = math.Clamp(math.Round(sliderValue) + 1, 1, #values)
                    local value = values[index]
                    control.valueLabel:SetText(tostring(value))
                    onSelect(value)
                end

                panel.customControls[#panel.customControls + 1] = control
            end

            local selectedFaction, raw, parsed = getSelectedModelData(context)
            local tempEntity
            if parsed and isstring(parsed.model) then tempEntity = ClientsideModel(parsed.model, RENDERGROUP_OTHER) end
            if IsValid(tempEntity) then
                tempEntity:SetNoDraw(true)
                local skinAllowed, bodygroupsAllowed = lia.faction.getModelCustomizationAllowed(LocalPlayer(), selectedFaction, context)
                if skinAllowed and tempEntity:SkinCount() > 1 then
                    addSkinSlideBox(tempEntity:SkinCount() - 1, tonumber(context.skin) or 0, function(value) return lia.faction.isSkinAllowedForFaction(selectedFaction, value, raw, context.model) end, function(value)
                        context.skin = value
                        creator:ApplyWorldAppearance()
                    end)
                end

                if bodygroupsAllowed then
                    for _, group in ipairs(tempEntity:GetBodyGroups() or {}) do
                        if group.num <= 1 then continue end
                        local groupID = group.id
                        local groupName = group.name
                        local values = {}
                        for value = 0, group.num - 1 do
                            if lia.faction.isBodygroupValueAllowed(selectedFaction, parsed.model, groupID, value, groupName, raw, context.model) then values[#values + 1] = value end
                        end

                        addBodygroupSlider(groupName or ("Bodygroup " .. groupID), values, tonumber(context.bodygroups[groupID]) or 0, function(value)
                            value = tonumber(value) or 0
                            if lia.faction.isBodygroupValueAllowed(selectedFaction, parsed.model, groupID, value, groupName, raw, context.model) then
                                context.bodygroups[groupID] = value
                                creator:ApplyWorldAppearance()
                            end
                        end)
                    end
                end

                tempEntity:Remove()
            end

            panel.PerformLayout = function(self, w, h)
                self.title:SetPos(0, 0)
                self.title:SetSize(w, 36)
                self.subtitle:SetPos(0, 40)
                self.subtitle:SetSize(w, 42)
                local controlsY = 92
                local searchHeight = 34
                local filterWidth = math.Clamp(math.floor(w * 0.26), 170, 220)
                local gap = 12
                self.searchWrap:SetPos(0, controlsY)
                self.searchWrap:SetSize(w - filterWidth - gap, searchHeight)
                self.searchEntry:SetPos(36, 2)
                self.searchEntry:SetSize(self.searchWrap:GetWide() - 48, searchHeight - 4)
                self.filterCombo:SetPos(w - filterWidth, controlsY)
                self.filterCombo:SetSize(filterWidth, searchHeight)
                local modelAreaY = controlsY + searchHeight + 14
                local contentBottom = h
                local hasCustomization = #self.customControls > 0
                self.customWrap:SetVisible(hasCustomization)
                local customHeight = 0
                if hasCustomization then
                    local customGap = 10
                    local controlWidth = 210
                    local innerWidth = math.max(math.floor(w * 0.5), 1)
                    local innerX = math.floor((w - innerWidth) * 0.5)
                    local available = math.max(innerWidth - 28, 1)
                    local columns = math.Clamp(math.floor((available + customGap) / (controlWidth + customGap)), 1, 4)
                    local rows = math.max(math.ceil(#self.customControls / columns), 1)
                    local visibleRows = math.min(rows, 2)
                    customHeight = 64 + visibleRows * 72 + 12
                    customHeight = math.Clamp(customHeight, 142, 220)
                    self.customWrap:SetPos(0, h - customHeight)
                    self.customWrap:SetSize(w, customHeight)
                    self.customHeader:SetPos(innerX + 12, 8)
                    self.customHeader:SetSize(innerWidth - 24, 28)
                    self.customTitle:SetPos(2, 0)
                    self.customTitle:SetSize(innerWidth - 28, 22)
                    self.customSubtitle:SetPos(innerX + 14, 38)
                    self.customSubtitle:SetSize(innerWidth - 28, 20)
                    self.customScroll:SetPos(innerX + 10, 62)
                    self.customScroll:SetSize(innerWidth - 20, customHeight - 72)
                    local canvas = self.customScroll:GetCanvas()
                    local scrollAvailable = math.max(self.customScroll:GetWide() - 12, 1)
                    columns = math.Clamp(math.floor((scrollAvailable + customGap) / (controlWidth + customGap)), 1, 4)
                    local cellWidth = math.floor((scrollAvailable - (columns - 1) * customGap) / columns)
                    local controlHeight = 62
                    local lastRow = -1
                    for index, control in ipairs(self.customControls) do
                        local column = (index - 1) % columns
                        local row = math.floor((index - 1) / columns)
                        lastRow = row
                        control:SetPos(column * (cellWidth + customGap), row * (controlHeight + customGap))
                        control:SetSize(cellWidth, controlHeight)
                        if control.controlType == "slidebox" then continue end
                        control.header:SetPos(0, 0)
                        control.header:SetSize(cellWidth, 24)
                        control.label:SetPos(4, 0)
                        control.label:SetSize(math.max(cellWidth - 54, 1), 20)
                        control.valueLabel:SetPos(math.max(cellWidth - 48, 0), 0)
                        control.valueLabel:SetSize(44, 20)
                        control.slider:SetPos(0, 32)
                        control.slider:SetSize(cellWidth, 20)
                    end

                    local canvasHeight = lastRow >= 0 and (lastRow + 1) * (controlHeight + customGap) - customGap or 1
                    canvas:SetTall(math.max(canvasHeight, 1))
                    contentBottom = h - customHeight - 12
                end

                self.modelWrap:SetPos(0, modelAreaY)
                self.modelWrap:SetSize(w, math.max(contentBottom - modelAreaY, 1))
                self.modelScroll:SetPos(10, 10)
                self.modelScroll:SetSize(w - 20, math.max(self.modelWrap:GetTall() - 20, 1))
                self.modelEmpty:SetPos(20, 0)
                self.modelEmpty:SetSize(w - 40, self.modelWrap:GetTall())
                local canvas = self.modelScroll:GetCanvas()
                local visibleCards = self.visibleModelCards or {}
                local available = math.max(self.modelScroll:GetWide() - 8, 1)
                local cardGap = 10
                local targetWidth = 122
                local maxColumns = math.min(math.max(#visibleCards, 1), 6)
                local columns = math.Clamp(math.floor((available + cardGap) / (targetWidth + cardGap)), 1, math.max(maxColumns, 1))
                local cardW = math.floor((available - (columns - 1) * cardGap) / columns)
                cardW = math.Clamp(cardW, 114, 150)
                local iconH = cardW - 4
                local cardH = iconH + 28
                local lastRow = -1
                for index, card in ipairs(visibleCards) do
                    local column = (index - 1) % columns
                    local row = math.floor((index - 1) / columns)
                    lastRow = row
                    card:SetPos(column * (cardW + cardGap), row * (cardH + cardGap))
                    card:SetSize(cardW, cardH)
                    card.icon:SetPos(6, 6)
                    card.icon:SetSize(cardW - 12, iconH - 8)
                    card.modelLabel:SetPos(9, iconH)
                    card.modelLabel:SetSize(cardW - 18, 20)
                end

                local modelCanvasHeight = lastRow >= 0 and (lastRow + 1) * (cardH + cardGap) - cardGap or 1
                canvas:SetTall(math.max(modelCanvasHeight, 1))
            end

            panel:ApplyModelFilters()
            creator:RefreshWorldModel(false)
            return panel
        end,
        onEnter = function(_, _, creator) creator:TransitionCamera("appearance", 0.55) end,
        onValidate = function(context)
            local faction = getFactionByIndex(context.faction)
            if not faction then return false, "Choose a faction first." end
            local models = getFilteredModels(faction, context)
            for _, modelData in ipairs(models) do
                if modelData.key == context.model then return true end
            end
            return false, "Choose a valid appearance model."
        end,
        onBuildSummary = function(context, summary)
            local _, _, parsed = getSelectedModelData(context)
            if parsed then
                summary[#summary + 1] = {
                    title = "Model",
                    value = parsed.model
                }

                summary[#summary + 1] = {
                    title = "Skin",
                    value = tostring(context.skin or 0)
                }

                local groupCount = table.Count(context.bodygroups or {})
                summary[#summary + 1] = {
                    title = "Bodygroups",
                    value = groupCount > 0 and tostring(groupCount) .. " configured" or "Default"
                }
            end
        end
    }

    tabs["review"] = {
        name = "Review",
        order = 50,
        onCreate = function(parent, _, creator)
            local panel = vgui.Create("DPanel", parent)
            panel:SetPaintBackground(false)
            addPageHeading(panel, "SUMMARY & FINISH", "Review your character and edit any section before creating it.")
            panel.summary = creator:BuildSummary()
            panel.cards = {}
            panel.layoutItems = {}
            panel.sections = {}
            local tabsByID = {}
            local tabsByTitle = {}
            local tabIndexes = {}
            for index, tab in ipairs(creator.tabs) do
                if tab.id == "review" then continue end
                tabsByID[tab.id] = tab
                tabIndexes[tab.id] = index
                tabsByTitle[string.lower(tostring(tab.reviewHeader or tab.name))] = tab
                tabsByTitle[string.lower(tostring(tab.name))] = tab
            end

            local sectionsByID = {}
            for index, item in ipairs(panel.summary) do
                if not istable(item) or item.hidden == true then continue end
                local header = string.Trim(tostring(item.header or ""))
                local sourceID = isstring(item.section) and item.section ~= "" and item.section or nil
                local matchedTab = sourceID and tabsByID[sourceID] or tabsByTitle[string.lower(header)]
                local sectionID = sourceID or matchedTab and matchedTab.id or header ~= "" and string.lower(header) or "additional"
                local section = sectionsByID[sectionID]
                if not section then
                    local title = header ~= "" and header or matchedTab and (matchedTab.reviewHeader or matchedTab.name) or sourceID and sourceID ~= "additional" and sourceID or "Additional Details"
                    section = {
                        id = sectionID,
                        title = tostring(title),
                        tabID = matchedTab and matchedTab.id or nil,
                        order = tonumber(item.sectionOrder) or matchedTab and matchedTab.order or 1000 + index,
                        index = index,
                        entries = {}
                    }

                    sectionsByID[sectionID] = section
                    panel.sections[#panel.sections + 1] = section
                end

                if not section.tabID and isstring(item.editTab) and tabsByID[item.editTab] then section.tabID = item.editTab end
                section.entries[#section.entries + 1] = {
                    item = item,
                    index = index
                }
            end

            table.sort(panel.sections, function(a, b)
                if a.order == b.order then return a.index < b.index end
                return a.order < b.order
            end)

            panel.scroll = panel:Add("DScrollPanel")
            panel.scroll.Paint = function() end
            styleScrollBar(panel.scroll)
            local function makeDefaultCard(item)
                local card = panel.scroll:Add("DPanel")
                card.isDefaultReviewCard = true
                card.Paint = function(_, w, h)
                    local accent = getThemeAccent()
                    drawPanel(0, 0, w, h, 6, getThemeSurface(0.05, 240), Color(accent.r, accent.g, accent.b, 46))
                    surface.SetDrawColor(accent.r, accent.g, accent.b, 125)
                    surface.DrawRect(0, 0, 2, h)
                end

                card.title = card:Add("DLabel")
                card.title:SetFont("LiliaFont.15")
                card.title:SetText(string.upper(tostring(item.title or "DETAIL")))
                card.title:SetTextColor(getThemeMutedColor())
                bindThemedLabel(card.title, function() return getThemeMutedColor() end)
                card.value = card:Add("DLabel")
                card.value:SetFont("LiliaFont.18")
                card.value:SetText(tostring(item.value == nil and "" or item.value))
                card.value:SetTextColor(getThemeTextColor())
                card.value:SetWrap(true)
                bindThemedLabel(card.value, function() return getThemeTextColor() end)
                card.PerformLayout = function(self, w, h)
                    self.title:SetPos(13, 8)
                    self.title:SetSize(math.max(w - 26, 1), 18)
                    self.value:SetPos(13, 29)
                    self.value:SetSize(math.max(w - 26, 1), math.max(h - 36, 1))
                end
                return card
            end

            local totalItems = 0
            for _, section in ipairs(panel.sections) do
                table.sort(section.entries, function(a, b)
                    local aOrder = tonumber(a.item.order) or a.index
                    local bOrder = tonumber(b.item.order) or b.index
                    if aOrder == bOrder then return a.index < b.index end
                    return aOrder < bOrder
                end)

                local visibleEntries = {}
                for _, entry in ipairs(section.entries) do
                    local item = entry.item
                    local card = hook.Run("CreateCharacterCreationReviewItem", panel.scroll, item, panel, creator.context, creator)
                    if card == false then continue end
                    if not IsValid(card) then card = makeDefaultCard(item) end
                    card.reviewItem = item
                    entry.panel = card
                    visibleEntries[#visibleEntries + 1] = entry
                    panel.cards[#panel.cards + 1] = card
                    totalItems = totalItems + 1
                    hook.Run("CharacterCreationReviewItemCreated", card, item, panel, creator.context, creator)
                end

                section.entries = visibleEntries
            end

            local visibleSections = {}
            for _, section in ipairs(panel.sections) do
                if #section.entries == 0 then continue end
                local header = panel.scroll:Add("DPanel")
                header.section = section
                header.Paint = function(self, w, h)
                    local accent = getThemeAccent()
                    draw.SimpleText(string.upper(self.section.title), "LiliaFont.16", 2, 5, getThemeTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    surface.SetDrawColor(accent.r, accent.g, accent.b, 110)
                    surface.DrawRect(0, h - 1, w, 1)
                end

                local tabID = section.tabID
                if tabID and tabIndexes[tabID] then
                    header.edit = header:Add("DButton")
                    header.edit:SetText("")
                    header.edit.Paint = function(self, w, h)
                        local accent = getThemeAccent()
                        draw.SimpleText("EDIT", "LiliaFont.15", w - 8, h * 0.5, self:IsHovered() and getThemeTextColor() or accent, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    end

                    header.edit.DoClick = function() creator:RequestTab(tabIndexes[tabID]) end
                    header.PerformLayout = function(self, w)
                        self.edit:SetPos(w - 64, 0)
                        self.edit:SetSize(64, 29)
                    end
                end

                section.headerPanel = header
                visibleSections[#visibleSections + 1] = section
                panel.layoutItems[#panel.layoutItems + 1] = {
                    panel = header,
                    height = 34
                }

                for _, entry in ipairs(section.entries) do
                    panel.layoutItems[#panel.layoutItems + 1] = {
                        panel = entry.panel
                    }
                end
            end

            panel.sections = visibleSections
            panel.overview = panel:Add("DPanel")
            panel.overview.Paint = function(_, w, h)
                local accent = getThemeAccent()
                drawPanel(0, 0, w, h, 7, Color(accent.r, accent.g, accent.b, 15), Color(accent.r, accent.g, accent.b, 75))
                surface.SetDrawColor(accent.r, accent.g, accent.b, 220)
                surface.DrawRect(0, 0, 3, h)
                draw.SimpleText("CHARACTER SUMMARY", "LiliaFont.18", 15, 9, getThemeTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(string.format("%d sections  /  %d details", #panel.sections, totalItems), "LiliaFont.16", 15, 34, getThemeMutedColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end

            local function getTextMetrics(text, font, width)
                surface.SetFont(font)
                local _, lineHeight = surface.GetTextSize("Ag")
                local lines = 0
                for rawLine in (tostring(text) .. "\n"):gmatch("(.-)\n") do
                    local lineWidth = 0
                    for word in rawLine:gmatch("%S+") do
                        local wordWidth = surface.GetTextSize(word)
                        local spaceWidth = lineWidth > 0 and surface.GetTextSize(" ") or 0
                        if lineWidth > 0 and lineWidth + spaceWidth + wordWidth > width then
                            lines = lines + 1
                            lineWidth = 0
                        end

                        if wordWidth > width then
                            local segments = math.ceil(wordWidth / math.max(width, 1))
                            lines = lines + segments - 1
                            lineWidth = wordWidth - (segments - 1) * width
                        else
                            lineWidth = lineWidth + (lineWidth > 0 and spaceWidth or 0) + wordWidth
                        end
                    end

                    lines = lines + 1
                end
                return lines * math.max(lineHeight, 18)
            end

            local function wantsWide(entry, rowWidth)
                local item = entry.item
                local layout = item.layout or entry.panel.reviewLayout
                if tonumber(item.span) == 2 or layout == "wide" or layout == "full" then return true end
                if tonumber(item.span) == 1 or layout == "compact" then return false end
                if not entry.panel.isDefaultReviewCard then return true end
                local halfWidth = (rowWidth - 9) * 0.5 - 28
                local value = tostring(item.value == nil and "" or item.value)
                if value:find("\n", 1, true) then return true end
                surface.SetFont("LiliaFont.18")
                local valueWidth = surface.GetTextSize(value)
                surface.SetFont("LiliaFont.15")
                local titleWidth = surface.GetTextSize(string.upper(tostring(item.title or "DETAIL")))
                return valueWidth > halfWidth or titleWidth > halfWidth
            end

            local function getEntryHeight(entry, width)
                local item = entry.item
                local explicit = tonumber(item.height) or tonumber(entry.panel.reviewHeight)
                if explicit then return math.max(explicit, 1) end
                if not entry.panel.isDefaultReviewCard then return math.max(entry.panel:GetTall(), 76) end
                local contentHeight = getTextMetrics(item.value == nil and "" or item.value, "LiliaFont.18", math.max(width - 28, 1))
                return math.max(66, 39 + contentHeight)
            end

            panel.PerformLayout = function(self, w, h)
                self.title:SetPos(0, 0)
                self.title:SetSize(w, 36)
                self.subtitle:SetPos(0, 40)
                self.subtitle:SetSize(w, 42)
                self.overview:SetPos(0, 90)
                self.overview:SetSize(w, 60)
                self.scroll:SetPos(0, 162)
                self.scroll:SetSize(w, math.max(h - 162, 1))
                local rowWidth = math.max(self.scroll:GetWide() - 12, 1)
                local columnGap = 9
                local cardGap = 9
                local halfWidth = math.max((rowWidth - columnGap) * 0.5, 1)
                local y = 0
                for _, section in ipairs(self.sections) do
                    section.headerPanel:SetPos(0, y)
                    section.headerPanel:SetSize(rowWidth, 34)
                    y = y + 43
                    local waiting = false
                    local rowHeight = 0
                    for index, entry in ipairs(section.entries) do
                        local card = entry.panel
                        local wide = rowWidth < 460 or wantsWide(entry, rowWidth)
                        if not wide and not waiting then
                            local nextEntry = section.entries[index + 1]
                            if not nextEntry or wantsWide(nextEntry, rowWidth) then wide = true end
                        end

                        if wide then
                            if waiting then
                                y = y + rowHeight + cardGap
                                waiting = false
                                rowHeight = 0
                            end

                            local height = getEntryHeight(entry, rowWidth)
                            card:SetPos(0, y)
                            card:SetSize(rowWidth, height)
                            y = y + height + cardGap
                        else
                            local height = getEntryHeight(entry, halfWidth)
                            if waiting then
                                card:SetPos(halfWidth + columnGap, y)
                                card:SetSize(halfWidth, height)
                                y = y + math.max(rowHeight, height) + cardGap
                                waiting = false
                                rowHeight = 0
                            else
                                card:SetPos(0, y)
                                card:SetSize(halfWidth, height)
                                waiting = true
                                rowHeight = height
                            end
                        end
                    end

                    if waiting then y = y + rowHeight + cardGap end
                    y = y + 16
                end

                self.scroll:GetCanvas():SetTall(math.max(y, self.scroll:GetTall()))
                hook.Run("CharacterCreationReviewLayout", self, self.cards, self.summary, creator.context, creator)
            end

            hook.Run("CharacterCreationReviewCreated", panel, panel.summary, creator.context, creator)
            return panel
        end,
        onEnter = function(_, _, creator) creator:TransitionCamera("appearance", 0.55) end,
        onValidate = function() return true end
    }
end)
