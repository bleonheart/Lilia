MODULE.name = "Character Creator"
MODULE.author = "Samael"
MODULE.desc = "Extensible cinematic character creation for this schema."
MODULE.creationTabs = MODULE.creationTabs or {}
MODULE.creationContext = MODULE.creationContext or {}
function MODULE:RefreshCreationTabs()
    local tabs = {}
    hook.Run("RegisterCharacterCreationTabs", tabs, self)
    self.creationTabs = {}
    for id, data in pairs(tabs) do
        if not isstring(id) or id == "" then continue end
        if not istable(data) or not isstring(data.name) or not isfunction(data.onCreate) then continue end
        data.id = id
        data.order = tonumber(data.order) or 100
        self.creationTabs[id] = data
    end
    return self.creationTabs
end

function MODULE:GetCreationTabs()
    local tabs = {}
    for _, tab in pairs(self.creationTabs) do
        tabs[#tabs + 1] = tab
    end

    table.sort(tabs, function(a, b)
        if a.order == b.order then return a.id < b.id end
        return a.order < b.order
    end)
    return tabs
end

function MODULE:GetCreationContext()
    return self.creationContext
end

function MODULE:SetCreationContext(key, value)
    self.creationContext[key] = value
end

local function getCreationFactionIndex(value)
    local index = tonumber(value)
    if index and lia.faction and lia.faction.indices and lia.faction.indices[index] then return index end
    if lia.faction and isfunction(lia.faction.get) then
        local faction = lia.faction.get(value)
        if faction then return faction.index end
    end
end

local function getValidDefaultCreationClass(value, factionValue)
    local index = tonumber(value)
    if not index or index <= 0 or not lia.class or not lia.class.list then return nil end
    local class = lia.class.list[index]
    local factionIndex = getCreationFactionIndex(factionValue)
    if not class or not factionIndex or class.faction ~= factionIndex or not class.isDefault then return nil end
    return class
end

local function installCreationClassValidation()
    local classVar = lia.char and lia.char.vars and lia.char.vars.class
    if not classVar or classVar.schemaCreatorClassValidation then return end
    local previousValidate = classVar.onValidate
    classVar.onValidate = function(value, data, client)
        if isfunction(previousValidate) then
            local result = {previousValidate(value, data, client)}
            if result[1] == false then return unpack(result) end
        end

        if value == nil or tonumber(value) == 0 then return true end
        if not getValidDefaultCreationClass(value, data and data.faction) then return false, "invalid", "class" end
        return true
    end

    classVar.schemaCreatorClassValidation = true
end

installCreationClassValidation()
hook.Add("PostGamemodeLoaded", "SchemaCharacterCreatorInstallClassValidation", installCreationClassValidation)
hook.Add("OverrideFactionModelCustomization", "SchemaCharacterCreatorClassModelCustomization", function(_, faction, context, skinAllowed, bodygroupsAllowed)
    if not faction or not istable(context) then return end
    local classIndex = tonumber(context.class)
    local class = classIndex and lia.class and lia.class.list and lia.class.list[classIndex] or nil
    if class and class.faction == faction.index then
        if class.skinAllowed ~= nil then skinAllowed = class.skinAllowed == true end
        if class.bodygroupsAllowed ~= nil then bodygroupsAllowed = class.bodygroupsAllowed == true end
        if istable(class.allowedSkins) then skinAllowed = true end
        if istable(class.allowedBodygroups) then bodygroupsAllowed = true end
    end

    if istable(faction.allowedSkins) then skinAllowed = true end
    if istable(faction.allowedBodygroups) then bodygroupsAllowed = true end
    local creationClass = lia.faction and lia.faction.getCharacterCreationClass and lia.faction.getCharacterCreationClass(faction, context.class) or nil
    local modelData = lia.faction and lia.faction.getCharacterCreationModelInfo and lia.faction.getCharacterCreationModelInfo(faction, creationClass, context.model) or nil
    local parsed = modelData and lia.faction and lia.faction.getModelData and lia.faction.getModelData(context.model or 1, modelData) or nil
    if parsed then
        if istable(parsed.allowedSkins) then skinAllowed = true end
        if istable(parsed.allowedBodygroups) then bodygroupsAllowed = true end
    end
    return skinAllowed, bodygroupsAllowed
end)

if SERVER then
    hook.Add("OnCharCreated", "SchemaCharacterCreatorApplyCreationClass", function(client, character, originalData)
        local class = getValidDefaultCreationClass(originalData and originalData.class, originalData and originalData.faction)
        if not class or not character then return end
        timer.Simple(0.4, function()
            if not character or not character.getClass or not character.setClass then return end
            local oldClass = character:getClass()
            if oldClass == class.index then return end
            character:setClass(class.index)
            if IsValid(client) then
                hook.Run("OnPlayerJoinClass", client, class.index, oldClass)
                if character.sync then character:sync(client) end
            end

            if character.save then character:save() end
        end)
    end)
end