MODULE.name = "Species Creator POC"
MODULE.author = "Samael"
MODULE.desc = "A cinematic world-space species, origin, and multi-stage character creation interface."
MODULE.NetworkStrings = {"liaSpeciesCreatorOpen"}
MODULE.SpeciesVariable = "species"
MODULE.OriginVariable = "origin"
MODULE.SexVariable = "sex"
MODULE.HeightVariable = "height"
MODULE.EyeColorVariable = "eyeColor"
MODULE.HairColorVariable = "hairColor"
MODULE.BirthDateVariable = "birthDate"
MODULE.GenerationVariable = "generation"
MODULE.PronounsVariable = "pronouns"
MODULE.TraitsVariable = "traits"
MODULE.AttributesVariable = "attributes"
MODULE.LanguagesVariable = "languages"
MODULE.StartingKitVariable = "startingKit"
MODULE.OutfitVariable = "startingOutfit"
MODULE.CreationFaction = nil
MODULE.TraitPointBudget = 4
MODULE.AttributeMinimum = 1
MODULE.AttributeMaximum = 5
MODULE.AttributeGroups = {
    {
        id = "physical",
        name = "Physical",
        pointsLabel = "Group 1",
        budget = 7,
        attributes = {
            {
                id = "strength",
                name = "Strength"
            },
            {
                id = "dexterity",
                name = "Dexterity"
            },
            {
                id = "stamina",
                name = "Stamina"
            }
        }
    },
    {
        id = "social",
        name = "Social",
        pointsLabel = "Group 2",
        budget = 5,
        attributes = {
            {
                id = "charisma",
                name = "Charisma"
            },
            {
                id = "manipulation",
                name = "Manipulation"
            },
            {
                id = "appearance",
                name = "Appearance"
            },
            {
                id = "composure",
                name = "Composure"
            }
        }
    },
    {
        id = "mental",
        name = "Mental",
        pointsLabel = "Group 3",
        budget = 3,
        attributes = {
            {
                id = "perception",
                name = "Perception"
            },
            {
                id = "intelligence",
                name = "Intelligence"
            },
            {
                id = "wits",
                name = "Wits"
            },
            {
                id = "resolve",
                name = "Resolve"
            }
        }
    }
}

MODULE.SpeciesOrder = {"human", "vortigaunts", "transhumans"}
MODULE.Pronouns = {"He/Him", "She/Her", "They/Them", "It/Its"}
MODULE.EyeColors = {"Brown", "Blue", "Green", "Hazel", "Gray", "Amber", "Red"}
MODULE.HairColors = {"Black", "Brown", "Blonde", "Auburn", "Red", "Gray", "White", "None"}
MODULE.LanguageTokenBudget = 1
MODULE.DefaultInnateLanguages = {"english"}
MODULE.Languages = {
    {
        id = "english",
        name = "English",
        description = "The common language used across most surviving human settlements."
    },
    {
        id = "flux_shifting",
        name = "Flux Shifting",
        description = "A tonal Vortigaunt language carried through voice, gesture, and communal resonance."
    },
    {
        id = "arabic",
        name = "Arabic",
        description = "A widely spoken language with numerous regional dialects."
    },
    {
        id = "cantonese",
        name = "Cantonese",
        description = "A southern Chinese language preserved by displaced communities."
    },
    {
        id = "french",
        name = "French",
        description = "A Romance language maintained through family and community use."
    },
    {
        id = "german",
        name = "German",
        description = "A Germanic language retained among European survivors."
    },
    {
        id = "japanese",
        name = "Japanese",
        description = "A language preserved through isolated families and cultural groups."
    },
    {
        id = "mandarin",
        name = "Mandarin",
        description = "A major Chinese language spoken by many displaced populations."
    },
    {
        id = "polish",
        name = "Polish",
        description = "A West Slavic language common among Central European survivors."
    },
    {
        id = "romanian",
        name = "Romanian",
        description = "An Eastern Romance language spoken throughout scattered enclaves."
    },
    {
        id = "russian",
        name = "Russian",
        description = "A widespread East Slavic language used across many refugee networks."
    },
    {
        id = "sign_language",
        name = "Sign Language",
        description = "A visual language useful when speech is impossible or unsafe."
    },
    {
        id = "spanish",
        name = "Spanish",
        description = "A widely spoken Romance language maintained across many communities."
    },
    {
        id = "turkish",
        name = "Turkish",
        description = "A Turkic language retained by displaced families and settlements."
    },
    {
        id = "ukrainian",
        name = "Ukrainian",
        description = "An East Slavic language preserved among refugee communities."
    }
}

MODULE.Traits = {
    {
        id = "resilient",
        name = "Resilient",
        description = "Recovers quickly from hardship and physical strain.",
        cost = 2
    },
    {
        id = "observant",
        name = "Observant",
        description = "Notices details, changes, and suspicious behavior more readily.",
        cost = 1
    },
    {
        id = "field_medic",
        name = "Field Medic",
        description = "Possesses practical knowledge of emergency treatment and stabilization.",
        cost = 2
    },
    {
        id = "resourceful",
        name = "Resourceful",
        description = "Makes effective use of limited equipment and improvised solutions.",
        cost = 1
    },
    {
        id = "linguist",
        name = "Linguist",
        description = "A practiced polyglot. Gain two additional language tokens during character creation.",
        cost = 2,
        languageTokens = 2
    },
    {
        id = "frail",
        name = "Frail",
        description = "Physical exertion and injury take a greater toll.",
        cost = -2
    },
    {
        id = "conspicuous",
        name = "Conspicuous",
        description = "Has difficulty blending into crowds or avoiding attention.",
        cost = -1
    },
    {
        id = "dependent",
        name = "Dependent",
        description = "Functions poorly without support, routine, or familiar equipment.",
        cost = -2
    }
}

MODULE.DefaultStartingKits = {
    human = {
        pick = 2,
        items = {
            {
                id = "ration",
                name = "Ration Pack",
                description = "A sealed ration suitable for one meal."
            },
            {
                id = "bandage",
                name = "Bandage",
                description = "A basic dressing for minor wounds."
            },
            {
                id = "flashlight",
                name = "Flashlight",
                description = "A compact utility light with a worn battery."
            },
            {
                id = "water",
                name = "Water Bottle",
                description = "A refillable bottle of clean water."
            }
        }
    },
    vortigaunts = {
        pick = 2,
        items = {
            {
                id = "healing_vial",
                name = "Healing Vial",
                description = "A small vessel prepared for restorative use."
            },
            {
                id = "binding_wrap",
                name = "Binding Wrap",
                description = "Cloth suitable for binding wounds or equipment."
            },
            {
                id = "crafted_token",
                name = "Crafted Token",
                description = "A personal object tied to memory and kin."
            },
            {
                id = "foraged_food",
                name = "Foraged Food",
                description = "A small collection of edible outlands produce."
            }
        }
    },
    transhumans = {
        pick = 2,
        items = {
            {
                id = "field_dressing",
                name = "Field Dressing",
                description = "A standardized emergency medical dressing."
            },
            {
                id = "nutrient_pack",
                name = "Nutrient Pack",
                description = "A compact meal designed for operational use."
            },
            {
                id = "utility_cell",
                name = "Utility Cell",
                description = "A spare power cell for approved equipment."
            },
            {
                id = "signal_marker",
                name = "Signal Marker",
                description = "A compact marker used for identification and coordination."
            }
        }
    }
}

MODULE.SpeciesProfiles = {
    ["human"] = {
        name = "Humans",
        description = "Resourceful survivors defined by adaptability, community, and determination.",
        accent = Color(166, 78, 78),
        eyeColors = {"Brown", "Blue", "Green", "Hazel", "Gray", "Amber"},
        hairColors = {"Black", "Brown", "Blonde", "Auburn", "Red", "Gray", "White", "None"},
        defaultEyeColor = "Brown",
        defaultHairColor = "Black",
        sexes = {
            {
                id = "male",
                name = "Male"
            },
            {
                id = "female",
                name = "Female"
            }
        },
        models = {
            male = {
                {
                    model = "models/humans/pandafishizens/male_01.mdl",
                    name = "Human Man 01"
                },
                {
                    model = "models/humans/pandafishizens/male_02.mdl",
                    name = "Human Man 02"
                },
                {
                    model = "models/humans/pandafishizens/male_03.mdl",
                    name = "Human Man 03"
                },
                {
                    model = "models/humans/pandafishizens/male_04.mdl",
                    name = "Human Man 04"
                },
                {
                    model = "models/humans/pandafishizens/male_05.mdl",
                    name = "Human Man 05"
                },
                {
                    model = "models/humans/pandafishizens/male_06.mdl",
                    name = "Human Man 06"
                },
                {
                    model = "models/humans/pandafishizens/male_07.mdl",
                    name = "Human Man 07"
                },
                {
                    model = "models/humans/pandafishizens/male_08.mdl",
                    name = "Human Man 08"
                },
                {
                    model = "models/humans/pandafishizens/male_09.mdl",
                    name = "Human Man 09"
                },
                {
                    model = "models/humans/pandafishizens/male_10.mdl",
                    name = "Human Man 10"
                },
                {
                    model = "models/humans/pandafishizens/male_11.mdl",
                    name = "Human Man 11"
                },
                {
                    model = "models/humans/pandafishizens/male_12.mdl",
                    name = "Human Man 12"
                },
                {
                    model = "models/humans/pandafishizens/male_15.mdl",
                    name = "Human Man 15"
                },
                {
                    model = "models/humans/pandafishizens/male_16.mdl",
                    name = "Human Man 16"
                }
            },
            female = {
                {
                    model = "models/humans/pandafishizens/female_01.mdl",
                    name = "Human Woman 01"
                },
                {
                    model = "models/humans/pandafishizens/female_02.mdl",
                    name = "Human Woman 02"
                },
                {
                    model = "models/humans/pandafishizens/female_03.mdl",
                    name = "Human Woman 03"
                },
                {
                    model = "models/humans/pandafishizens/female_04.mdl",
                    name = "Human Woman 04"
                },
                {
                    model = "models/humans/pandafishizens/female_06.mdl",
                    name = "Human Woman 06"
                },
                {
                    model = "models/humans/pandafishizens/female_07.mdl",
                    name = "Human Woman 07"
                },
                {
                    model = "models/humans/pandafishizens/female_11.mdl",
                    name = "Human Woman 11"
                },
                {
                    model = "models/humans/pandafishizens/female_17.mdl",
                    name = "Human Woman 17"
                },
                {
                    model = "models/humans/pandafishizens/female_18.mdl",
                    name = "Human Woman 18"
                },
                {
                    model = "models/humans/pandafishizens/female_19.mdl",
                    name = "Human Woman 19"
                },
                {
                    model = "models/humans/pandafishizens/female_24.mdl",
                    name = "Human Woman 24"
                },
                {
                    model = "models/humans/pandafishizens/female_25.mdl",
                    name = "Human Woman 25"
                }
            }
        },
        languageTokens = 1,
        defaultHeight = 69,
        minHeight = 59,
        maxHeight = 81,
        birthMode = "date",
        selectionSounds = {"vo/npc/male01/hi01.wav", "vo/npc/female01/hi01.wav"},
        revealSequences = {"menu_gman", "pose_standing_02", "idle_all_01"},
        idleSequences = {"idle_all_01", "idle_subtle", "idle"},
        origins = {
            {
                id = "layman",
                name = "Layman",
                description = "An ordinary civilian shaped by ration lines, labor assignments, and daily survival under occupation."
            },
            {
                id = "once_loyalist",
                name = "Once Loyalist",
                description = "A former supporter of the regime whose status, conviction, or protection has since faded."
            },
            {
                id = "ex_stalker",
                name = "Ex-Stalker",
                description = "A survivor of invasive conversion who escaped or was recovered with fragments of identity intact."
            },
            {
                id = "ex_civil_protection",
                name = "Ex-Civil Protection* (limited)",
                description = "A former Civil Protection officer carrying training, compromises, and enemies from prior service."
            },
            {
                id = "zombie",
                name = "Zombie (Premium)",
                description = "A deteriorating human host driven by infection while retaining enough identity for roleplay.",
                defaultPronouns = "It/Its"
            }
        }
    },
    ["vortigaunts"] = {
        name = "Vortigaunts",
        description = "A resilient species bound by shared purpose, ancient knowledge, and unusual energy.",
        accent = Color(70, 128, 174),
        eyeColors = {"Red", "Orange", "Yellow", "Blue"},
        hairColors = {"None"},
        defaultEyeColor = "Red",
        defaultHairColor = "None",
        sexes = {
            {
                id = "na",
                name = "Not Applicable"
            }
        },
        models = {
            na = {
                {
                    model = "models/vortigaunt.mdl",
                    name = "Vortigaunt"
                }
            }
        },
        languageTokens = 0,
        innateLanguages = {"flux_shifting"},
        defaultHeight = 75,
        minHeight = 67,
        maxHeight = 87,
        birthMode = "generation",
        generations = {"First Generation", "Second Generation", "Third Generation", "Fourth Generation", "Unknown Generation"},
        selectionSounds = {"vo/npc/vortigaunt/vortigese02.wav", "vo/npc/vortigaunt/vortigese03.wav"},
        revealSequences = {"zapattack1", "idle01", "idle"},
        idleSequences = {"idle01", "idle"},
        origins = {
            {
                id = "unattuned_kin",
                name = "Unattuned Kin",
                description = "A free vortigaunt not yet attuned to a community, enclave, or guiding collective."
            },
            {
                id = "attuned_kin",
                name = "Attuned Kin (Application)",
                description = "A vortigaunt spiritually attuned to kin and purpose through shared ritual and experience."
            },
            {
                id = "unattuned_enclave_kin",
                name = "Unattuned Enclave Kin",
                description = "An enclave-affiliated vortigaunt who has not completed attunement."
            },
            {
                id = "attuned_enclave_kin",
                name = "Attuned Enclave Kin (Application)",
                description = "An enclave kin fully attuned to its communal bond, customs, and responsibilities."
            },
            {
                id = "zombi_gaunt",
                name = "Zombi-gaunt (Premium) (Application)",
                description = "An infected or necrotic vortigaunt whose connection to the Vortessence has been violently distorted."
            }
        }
    },
    ["transhumans"] = {
        name = "Transhumans",
        description = "Engineered operatives shaped by discipline, augmentation, and uncompromising order.",
        accent = Color(207, 178, 69),
        eyeColors = {"Blue", "Brown", "Gray", "Green"},
        hairColors = {"None", "Black", "Brown", "Blonde", "Gray"},
        defaultEyeColor = "Blue",
        defaultHairColor = "None",
        defaultPronouns = "They/Them",
        sexes = {
            {
                id = "male",
                name = "Male"
            },
            {
                id = "female",
                name = "Female"
            }
        },
        models = {
            male = {
                {
                    model = "models/combine_soldier.mdl",
                    name = "Overwatch Soldier"
                },
                {
                    model = "models/combine_soldier_prisonguard.mdl",
                    name = "Prison Guard"
                },
                {
                    model = "models/combine_super_soldier.mdl",
                    name = "Elite Soldier"
                }
            },
            female = {
                {
                    model = "models/combine_soldier.mdl",
                    name = "Overwatch Soldier"
                },
                {
                    model = "models/combine_soldier_prisonguard.mdl",
                    name = "Prison Guard"
                },
                {
                    model = "models/combine_super_soldier.mdl",
                    name = "Elite Soldier"
                }
            }
        },
        languageTokens = 1,
        defaultHeight = 73,
        minHeight = 65,
        maxHeight = 85,
        birthMode = "date",
        selectionSounds = {"npc/combine_soldier/vo/affirmative.wav", "npc/combine_soldier/vo/readyweapons.wav"},
        revealSequences = {"menu_combine", "idleangry", "idle"},
        idleSequences = {"idleangry", "idle"},
        origins = {
            {
                id = "societal_conformist",
                name = "Societal Conformist",
                description = "A product of institutional obedience who embraced structure, duty, and approved social order."
            },
            {
                id = "outlands_roamer",
                name = "Outlands Roamer",
                description = "A hardened wanderer recruited or remade after surviving beyond controlled city limits."
            },
            {
                id = "convergent_spiritualist",
                name = "Convergent Spiritualist",
                description = "A transhuman whose former faith was redirected into disciplined service and collective purpose."
            },
            {
                id = "the_lost",
                name = "The Lost (Premium)",
                description = "An operative with fractured memory and identity, sustained by procedure more than personhood."
            }
        }
    }
}

if not isfunction(MODULE.GetLanguages) then
    function MODULE:GetLanguages(species, origin)
        local languages = hook.Run("SpeciesCreatorGetLanguages", species, origin)
        if istable(languages) then return languages end
        if origin and istable(origin.languages) then return origin.languages end
        local profile = species and (species.profile or species) or nil
        if profile and istable(profile.languages) then return profile.languages end
        return istable(self.Languages) and self.Languages or {}
    end
end

if not isfunction(MODULE.GetInnateLanguages) then
    function MODULE:GetInnateLanguages(species, origin)
        local languages = hook.Run("SpeciesCreatorGetInnateLanguages", species, origin)
        if istable(languages) then return languages end
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

        append(istable(self.DefaultInnateLanguages) and self.DefaultInnateLanguages or {"english"})
        local profile = species and (species.profile or species) or nil
        if profile then append(profile.innateLanguages) end
        if origin then append(origin.innateLanguages) end
        return innate
    end
end

if not isfunction(MODULE.GetLanguageTokenBudget) then
    function MODULE:GetLanguageTokenBudget(species, origin, selectedTraits)
        local hooked = hook.Run("SpeciesCreatorGetLanguageTokenBudget", species, origin, selectedTraits)
        if isnumber(hooked) then return math.max(math.floor(hooked), 0) end
        local profile = species and (species.profile or species) or nil
        local budget = tonumber(self.LanguageTokenBudget) or 1
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

        local traits = profile and istable(profile.traits) and profile.traits or self.Traits or {}
        for _, trait in ipairs(traits) do
            if selected[tostring(trait.id)] then budget = budget + (tonumber(trait.languageTokens) or 0) end
        end
        return math.max(math.floor(budget), 0)
    end
end
