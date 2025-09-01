local PANEL = {}
function PANEL:Init()
    self.title = self:addLabel(L("selectModel"))
    self.models = self:Add("DIconLayout")
    self.models:Dock(FILL)
    self.models:SetSpaceX(4)
    self.models:SetSpaceY(4)
    self.models:SetPaintBackground(false)
end

function PANEL:onDisplay()
    self.models:Clear()
    local faction = lia.faction.indices[self:getContext("faction")]
    if not faction then return end

    -- Allow filtering of available models
    hook.Run("FilterCharacterModels", LocalPlayer(), faction)

    -- Separate models by gender
    local maleModels = {}
    local femaleModels = {}

    for idx, data in SortedPairs(faction.models) do
        local modelPath = istable(data) and data[1] or data
        local gender = lia.identifications.GetModelGender(modelPath)

        if gender == "male" then
            table.insert(maleModels, {idx = idx, data = data})
        else
            table.insert(femaleModels, {idx = idx, data = data})
        end
    end

    local paintOver = function(icon, w, h) self:paintIcon(icon, w, h) end

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

        -- Create scroll panel for this section
        local scrollPanel = self:Add("DScrollPanel")
        scrollPanel:Dock(TOP)
        scrollPanel:DockMargin(0, 4, 0, 8)
        scrollPanel:SetTall(140)

        local modelsLayout = scrollPanel:Add("DIconLayout")
        modelsLayout:Dock(FILL)
        modelsLayout:SetSpaceX(4)
        modelsLayout:SetSpaceY(4)

        for _, modelInfo in ipairs(models) do
            local icon = modelsLayout:Add("SpawnIcon")
            icon:SetSize(64, 128)
            icon.index = modelInfo.idx
            icon.PaintOver = paintOver
            icon.DoClick = function() self:onModelSelected(icon) end

            local data = modelInfo.data
            local model, skin, bodyGroups = data, 0, ""
            if istable(data) then
                skin = data[2] or 0
                for i = 0, 8 do
                    bodyGroups = bodyGroups .. tostring((data[3] or {})[i] or 0)
                end

                model = data[1]
            end

            icon:SetModel(model, skin, bodyGroups)
            icon.model, icon.skin, icon.bodyGroups = model, skin, bodyGroups
            if self:getContext("model") == modelInfo.idx then self:onModelSelected(icon, true) end
        end
    end

    -- Create sections for male and female models
    createModelSection(maleModels, "Male Models")
    createModelSection(femaleModels, "Female Models")

    self:InvalidateLayout(true)
end

function PANEL:paintIcon(icon, w, h)
    if self:getContext("model") ~= icon.index then return end
    local col = lia.config.get("Color", color_white)
    surface.SetDrawColor(col.r, col.g, col.b, 200)
    for i = 1, 3 do
        local o = i * 2
        surface.DrawOutlinedRect(i, i, w - o, h - o)
    end
end

function PANEL:onModelSelected(icon, noSound)
    self:setContext("model", icon.index or 1)
    if not noSound then lia.gui.character:clickSound() end
    self:updateModelPanel()
end

function PANEL:shouldSkip()
    local faction = lia.faction.indices[self:getContext("faction")]
    return faction and #faction.models == 1 or false
end

function PANEL:onSkip()
    self:setContext("model", 1)
end

vgui.Register("liaCharacterModel", PANEL, "liaCharacterCreateStep")
