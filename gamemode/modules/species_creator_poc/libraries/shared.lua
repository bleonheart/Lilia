local MODULE = MODULE
local function normalize(value)
    return tostring(value or ""):lower():gsub("[^%w]", "")
end

local function appendModel(models, value, key, sex)
    local model = isstring(value) and value or istable(value) and value.model or nil
    if not isstring(model) or string.Trim(model) == "" then return end
    models[#models + 1] = {
        key = istable(value) and value.key or key,
        model = string.Trim(model):gsub("\\", "/"),
        name = istable(value) and value.name or nil,
        sex = istable(value) and value.sex or sex,
        skin = 0,
        bodygroups = {},
        previewOnly = true
    }
end

function MODULE:GetSpeciesModels(faction, client)
    if not faction then return {} end
    local class = lia.faction.getCharacterCreationClass and lia.faction.getCharacterCreationClass(faction, nil) or nil
    local choices = faction.models or {}
    if lia.faction.getCharacterCreationModelChoices then
        local resolved = lia.faction.getCharacterCreationModelChoices(faction, class)
        if istable(resolved) then choices = resolved end
    end

    local models = {}
    for key, value in pairs(choices or {}) do
        local parsed = lia.faction.getModelData and lia.faction.getModelData(key, value) or nil
        if parsed and isstring(parsed.model) and parsed.model ~= "" then
            models[#models + 1] = {
                key = key,
                model = parsed.model,
                name = istable(value) and value.name or nil,
                sex = istable(value) and value.sex or nil,
                skin = 0,
                bodygroups = {},
                raw = value
            }
        end
    end

    table.sort(models, function(a, b)
        if isnumber(a.key) and isnumber(b.key) then return a.key < b.key end
        return tostring(a.key) < tostring(b.key)
    end)
    return models
end

function MODULE:GetPreviewModels(profile)
    local models = {}
    if istable(profile.models) then
        local orderedSexes = {"male", "female", "na", "any"}
        local added = {}
        for _, sex in ipairs(orderedSexes) do
            local entries = profile.models[sex]
            if istable(entries) then
                for index, value in ipairs(entries) do
                    appendModel(models, value, tostring(sex) .. ":" .. tostring(index), sex)
                end

                added[sex] = true
            end
        end

        for sex, entries in pairs(profile.models) do
            if not added[sex] and istable(entries) then
                for index, value in ipairs(entries) do
                    appendModel(models, value, tostring(sex) .. ":" .. tostring(index), tostring(sex))
                end
            end
        end
    end

    if #models == 0 then
        for index, value in ipairs(profile.previewModels or {}) do
            appendModel(models, value, index, istable(value) and value.sex or "any")
        end
    end
    return models
end

function MODULE:GetOrderedSpeciesProfiles()
    local profiles = {}
    local added = {}
    for _, profileID in ipairs(self.SpeciesOrder or {}) do
        local profile = self.SpeciesProfiles and self.SpeciesProfiles[profileID]
        if istable(profile) then
            profiles[#profiles + 1] = {
                id = profileID,
                data = profile
            }

            added[profileID] = true
        end
    end

    local remaining = {}
    for profileID, profile in pairs(self.SpeciesProfiles or {}) do
        if isstring(profileID) and istable(profile) and not added[profileID] then remaining[#remaining + 1] = profileID end
    end

    table.sort(remaining)
    for _, profileID in ipairs(remaining) do
        profiles[#profiles + 1] = {
            id = profileID,
            data = self.SpeciesProfiles[profileID]
        }
    end
    return profiles
end

function MODULE:GetFactionByIdentifier(identifier)
    if identifier == nil then return nil end
    local factions = lia.faction and lia.faction.teams or {}
    if isnumber(identifier) then return factions[identifier] end
    local token = normalize(identifier)
    for _, faction in pairs(factions) do
        if normalize(faction.uniqueID) == token or normalize(faction.name) == token then return faction end
    end
end

function MODULE:GetCreationFaction(client, species)
    local hooked = hook.Run("SpeciesCreatorGetCreationFaction", client, species)
    if istable(hooked) then return hooked end
    local profile = species and (species.profile or species) or nil
    local configured = profile and profile.creationFaction or self.CreationFaction
    local faction = self:GetFactionByIdentifier(configured)
    if faction then return faction end
    for _, candidate in pairs(lia.faction and lia.faction.teams or {}) do
        if candidate.isDefault then return candidate end
    end
end

function MODULE:GetSpeciesOrigins(species)
    if not species then return {} end
    local profile = species.profile or species
    local origins = profile and profile.origins or nil
    if not istable(origins) and species.id and self.SpeciesProfiles and self.SpeciesProfiles[species.id] then origins = self.SpeciesProfiles[species.id].origins end
    return istable(origins) and origins or {}
end

function MODULE:GetSpeciesSexes(species)
    if not species then return {} end
    local profile = species.profile or species
    local sexes = profile and profile.sexes or nil
    if not istable(sexes) or #sexes == 0 then
        return {
            {
                id = "na",
                name = "Not Applicable"
            }
        }
    end
    return sexes
end

function MODULE:GetAttributeGroups(species, origin)
    local groups = hook.Run("SpeciesCreatorGetAttributeGroups", species, origin)
    if istable(groups) then return groups end
    if origin and istable(origin.attributeGroups) then return origin.attributeGroups end
    local profile = species and (species.profile or species) or nil
    if profile and istable(profile.attributeGroups) then return profile.attributeGroups end
    return istable(self.AttributeGroups) and self.AttributeGroups or {}
end

function MODULE:GetSpeciesTraits(species, origin)
    local traits = hook.Run("SpeciesCreatorGetTraits", species, origin)
    if istable(traits) then return traits end
    local profile = species and (species.profile or species) or nil
    if profile and istable(profile.traits) then return profile.traits end
    return istable(self.Traits) and self.Traits or {}
end

function MODULE:GetLanguages(species, origin)
    local languages = hook.Run("SpeciesCreatorGetLanguages", species, origin)
    if istable(languages) then return languages end
    if origin and istable(origin.languages) then return origin.languages end
    local profile = species and (species.profile or species) or nil
    if profile and istable(profile.languages) then return profile.languages end
    return istable(self.Languages) and self.Languages or {}
end

function MODULE:GetInnateLanguages(species, origin)
    local hooked = hook.Run("SpeciesCreatorGetInnateLanguages", species, origin)
    if istable(hooked) then return hooked end
    local innate = {}
    local added = {}
    local function append(values)
        for _, value in ipairs(values or {}) do
            local id = istable(value) and value.id or value
            id = string.Trim(tostring(id or "")):lower()
            if id ~= "" and not added[id] then
                added[id] = true
                innate[#innate + 1] = id
            end
        end
    end

    append(self.DefaultInnateLanguages)
    local profile = species and (species.profile or species) or nil
    if profile then append(profile.innateLanguages) end
    if origin then append(origin.innateLanguages) end
    return innate
end

function MODULE:GetLanguageTokenBudget(species, origin, selectedTraits)
    local hooked = hook.Run("SpeciesCreatorGetLanguageTokenBudget", species, origin, selectedTraits)
    if isnumber(hooked) then return math.max(math.floor(hooked), 0) end
    local profile = species and (species.profile or species) or nil
    local budget = tonumber(self.LanguageTokenBudget) or 0
    if profile and profile.languageTokens ~= nil then budget = tonumber(profile.languageTokens) or budget end
    if origin and origin.languageTokens ~= nil then budget = tonumber(origin.languageTokens) or budget end
    local selected = {}
    for key, value in pairs(selectedTraits or {}) do
        if isnumber(key) then
            local id = istable(value) and value.id or value
            if id then selected[tostring(id)] = true end
        elseif value then
            selected[tostring(key)] = true
        end
    end

    for _, trait in ipairs(self:GetSpeciesTraits(species, origin)) do
        if selected[tostring(trait.id)] then budget = budget + (tonumber(trait.languageTokens) or 0) end
    end
    return math.max(math.floor(budget), 0)
end

function MODULE:GetStartingKit(species, origin)
    local kit = hook.Run("SpeciesCreatorGetStartingKit", species, origin)
    if istable(kit) then return kit end
    if origin and istable(origin.kit) then return origin.kit end
    local profile = species and (species.profile or species) or nil
    if profile and istable(profile.startingKit) then return profile.startingKit end
    return istable(self.DefaultStartingKits) and self.DefaultStartingKits[species and species.id or ""] or nil
end

function MODULE:GetStartingOutfits(species, origin)
    local outfits = hook.Run("SpeciesCreatorGetStartingOutfits", species, origin)
    if istable(outfits) then return outfits end
    if origin and istable(origin.outfits) then return origin.outfits end
    local profile = species and (species.profile or species) or nil
    return profile and istable(profile.outfits) and profile.outfits or {}
end

function MODULE:GetAvailableSpecies(client)
    local species = {}
    for _, profileEntry in ipairs(self:GetOrderedSpeciesProfiles()) do
        local profileID = profileEntry.id
        local profile = table.Copy(profileEntry.data)
        profile.id = profileID
        local entry = {
            id = profileID,
            profile = profile
        }

        local creationFaction = self:GetCreationFaction(client, entry)
        local creationModels = creationFaction and self:GetSpeciesModels(creationFaction, client) or {}
        local previewModels = self:GetPreviewModels(profile)
        local displayModels = #previewModels > 0 and previewModels or creationModels
        species[#species + 1] = {
            id = profileID,
            profile = profile,
            faction = creationFaction,
            creationFaction = creationFaction,
            models = displayModels,
            creationModels = creationModels,
            available = #displayModels > 0,
            unavailableReason = #displayModels == 0 and "This species has no configured models." or nil
        }
    end
    return species
end

lia.command.add("speciescreator", {
    desc = "Opens the cinematic species character creator.",
    onRun = function(client)
        if not SERVER or not IsValid(client) then return end
        local nextUse = client.liaNextSpeciesCreator or 0
        if nextUse > CurTime() then return end
        client.liaNextSpeciesCreator = CurTime() + 1
        net.Start("liaSpeciesCreatorOpen")
        net.Send(client)
    end
})