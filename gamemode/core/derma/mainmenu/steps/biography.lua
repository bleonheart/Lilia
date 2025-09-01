local PANEL = {}
local HIGHLIGHT = Color(255, 255, 255, 50)
function PANEL:Init()
    self:SetSize(400, 600)
    local function makeLabel(key)
        local lbl = self:Add("DLabel")
        lbl:SetFont("liaMediumFont")
        lbl:SetText(L(key):upper())
        lbl:SizeToContents()
        lbl:Dock(TOP)
        lbl:DockMargin(0, 0, 0, 4)
        return lbl
    end

    self.nameLabel = makeLabel("name")
    self.nameEntry = self:makeTextEntry("name")
    self.nameEntry:SetTall(32)
    self.descLabel = makeLabel("desc")
    self.descEntry = self:makeTextEntry("desc")
    self.descEntry:SetTall(32)
    makeLabel("model")
    local faction = lia.faction.indices[self:getContext("faction")]
    if not faction then return end

    -- Allow filtering of available models
    hook.Run("FilterCharacterModels", LocalPlayer(), faction)

    -- Separate models by gender
    local maleModels = {}
    local femaleModels = {}

    for idx, data in SortedPairs(faction.models) do
        local modelPath = isstring(data) and data or data[1]
        local gender = lia.identifications.GetModelGender(modelPath)

        if gender == "male" then
            table.insert(maleModels, {idx = idx, data = data})
        else
            table.insert(femaleModels, {idx = idx, data = data})
        end
    end

    local function paintOver(icon, w, h)
        if self:getContext("model") == icon.index then
            local col = lia.config.get("Color", color_white)
            surface.SetDrawColor(col.r, col.g, col.b, 200)
            for i = 1, 3 do
                surface.DrawOutlinedRect(i, i, w - i * 2, h - i * 2)
            end
        end
    end

    local function createModelSection(models, title)
        if #models == 0 then return end

        -- Add section header
        local header = self:Add("DLabel")
        header:SetFont("liaMediumFont")
        header:SetText(title:upper())
        header:SetTextColor(color_white)
        header:SizeToContents()
        header:Dock(TOP)
        header:DockMargin(0, 8, 0, 4)

        -- Create model layout for this section
        local modelsLayout = self:Add("DIconLayout")
        modelsLayout:Dock(TOP)
        modelsLayout:DockMargin(0, 4, 0, 8)
        modelsLayout:SetSpaceX(5)
        modelsLayout:SetSpaceY(5)

        local iconW, iconH = 64, 128
        local spacing = 5
        local count = #models
        modelsLayout:SetWide(count * (iconW + spacing) - spacing)
        modelsLayout:SetTall(iconH)

        for _, modelInfo in ipairs(models) do
            local icon = modelsLayout:Add("SpawnIcon")
            icon:SetSize(iconW, iconH)
            icon:InvalidateLayout(true)
            icon.index = modelInfo.idx
            icon.PaintOver = paintOver
            icon.DoClick = function()
                self:setContext("model", modelInfo.idx)
                lia.gui.character:clickSound()
                self:updateModelPanel()
            end

            local data = modelInfo.data
            if isstring(data) then
                icon:SetModel(data)
                icon.model, icon.skin, icon.bodyGroups = data, 0, ""
            else
                local m, skin, bg = data[1], data[2] or 0, data[3] or {}
                local groups = {}
                for i = 0, 8 do
                    groups[i + 1] = tostring(bg[i] or 0)
                end

                icon:SetModel(m, skin, table.concat(groups))
                icon.model, icon.skin, icon.bodyGroups = m, skin, table.concat(groups)
            end

            if self:getContext("model") == modelInfo.idx or self.selectedModelIndex == modelInfo.idx then
                icon:DoClick()
                self.selectedModelIndex = nil -- Clear after use
            end
        end
    end

    -- Create sections for male and female models
    createModelSection(maleModels, "Male Models")
    createModelSection(femaleModels, "Female Models")
end

function PANEL:makeTextEntry(key)
    local entry = self:Add("DTextEntry")
    entry:Dock(TOP)
    entry:SetFont("liaMediumFont")
    entry:SetTall(32)
    entry:DockMargin(0, 4, 0, 8)
    entry:SetUpdateOnType(true)
    entry.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
        entry:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
    end

    entry.OnValueChange = function(_, val) self:setContext(key, string.Trim(val)) end
    local saved = self:getContext(key)
    if saved then entry:SetValue(saved) end

    -- Disable description entry if there's a description override
    if key == "desc" then
        local faction = lia.faction.indices[self:getContext("faction")]
        if faction then
            local desc, override = hook.Run("GetDefaultCharDesc", LocalPlayer(), faction, {faction = self:getContext("faction")})
            if isstring(desc) and override then
                entry:SetDisabled(true)
                entry:SetValue(desc)
                entry:SetCursorColor(Color(255, 255, 255, 0)) -- Hide cursor
            end
        end
    end

    return entry
end

function PANEL:shouldSkip()
    local faction = lia.faction.indices[self:getContext("faction")]
    return faction and #faction.models == 1 or false
end

function PANEL:onSkip()
    self:setContext("model", 1)
end

function PANEL:validate()
    for _, info in ipairs({{self.nameEntry, "name"}, {self.descEntry, "desc"}}) do
        local val = string.Trim(info[1]:GetValue() or "")
        if val == "" then
            -- Skip description validation if there's an override for description
            if info[2] == "desc" then
                local faction = lia.faction.indices[self:getContext("faction")]
                if faction then
                    local desc, override = hook.Run("GetDefaultCharDesc", LocalPlayer(), faction, {faction = self:getContext("faction")})
                    if not (isstring(desc) and override) then
                        return false, L("requiredFieldError", info[2])
                    end
                else
                    return false, L("requiredFieldError", info[2])
                end
            else
                return false, L("requiredFieldError", info[2])
            end
        end
    end
    return true
end

function PANEL:onDisplay()
    local n, d, m = self.nameEntry:GetValue(), self.descEntry:GetValue(), self:getContext("model")
    self:Clear()
    self:Init()
    self.nameEntry:SetValue(n)
    self.descEntry:SetValue(d)
    self:setContext("model", m)

    -- Store the selected model index for later restoration
    self.selectedModelIndex = m

    local faction = lia.faction.indices[self:getContext("faction")]
    if faction then
        local desc, override = hook.Run("GetDefaultCharDesc", LocalPlayer(), faction, {faction = self:getContext("faction")})
        if isstring(desc) and override then
            self.descEntry:SetDisabled(true)
            self.descEntry:SetValue(desc)
            self.descEntry:SetCursorColor(Color(255, 255, 255, 0))
        end
    end
end

vgui.Register("liaCharacterBiography", PANEL, "liaCharacterCreateStep")