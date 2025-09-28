lia.lang = lia.lang or {}
lia.lang.names = lia.lang.names or {}
lia.lang.stored = lia.lang.stored or {}
function lia.lang.loadFromDir(directory)
    for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
        local niceName
        if v:sub(1, 3) == "sh_" then
            niceName = v:sub(4, -5):lower()
        else
            niceName = v:sub(1, -5):lower()
        end

        lia.loader.include(directory .. "/" .. v, "shared")
        if LANGUAGE then
            if NAME then
                lia.lang.names[niceName] = NAME
                NAME = nil
            end

            local formatted = {}
            for k, val in pairs(LANGUAGE) do
                formatted[tostring(k)] = tostring(val)
            end

            lia.lang.stored[niceName] = table.Merge(lia.lang.stored[niceName] or {}, formatted)
            LANGUAGE = nil
        end
    end
end

function lia.lang.AddTable(name, tbl)
    local lowerName = tostring(name):lower()
    lia.lang.stored[lowerName] = lia.lang.stored[lowerName] or {}
    for k, v in pairs(tbl) do
        lia.lang.stored[lowerName][tostring(k)] = tostring(v)
    end
end

function lia.lang.getLanguages()
    local languages = {}
    for key, _ in pairs(lia.lang.stored) do
        local displayName = key:sub(1, 1):upper() .. key:sub(2)
        table.insert(languages, displayName)
    end

    table.sort(languages)
    return languages
end

function lia.lang.getLocalizedString(str, ...)
    if not isstring(str) then
        return str
    end

    local args = {...}
    local currentLanguage = lia.config.get("Language", "English"):lower()
    local languageTable = lia.lang.stored[currentLanguage]

    -- If no language table exists for current language, fall back to English
    if not languageTable then
        currentLanguage = "english"
        languageTable = lia.lang.stored[currentLanguage]
    end

    -- If still no language table, return original string
    if not languageTable then
        return str
    end

    local lookupKey = str
    local useAtSymbol = false

    -- Check if string starts with "@" - if so, strip it and look up without @
    if str:sub(1, 1) == "@" then
        lookupKey = str:sub(2)
        useAtSymbol = true
    end

    -- Try to find the localized string
    local localizedString = languageTable[lookupKey]

    -- If not found and we used @ symbol, try the original key with @ in current language
    if not localizedString and useAtSymbol then
        localizedString = languageTable[str]
    end

    -- If still not found, return the original string
    if not localizedString then
        return str
    end

    -- Handle argument substitution
    if #args > 0 then
        -- Check for format specifiers in the localized string
        local formatCount = select(2, localizedString:gsub("%%", "")) -- Count % characters

        -- If we have arguments but no format specifiers, or mismatched count, warn about it
        if formatCount == 0 and #args > 0 then
            print(string.format("[Lilia] Warning: getLocalizedString called with arguments but no format specifiers for key '%s' in language '%s'", lookupKey, currentLanguage))
            return localizedString
        elseif formatCount > 0 and #args == 0 then
            print(string.format("[Lilia] Warning: getLocalizedString expects %d arguments for key '%s' in language '%s' but none provided", formatCount, lookupKey, currentLanguage))
            return localizedString
        elseif formatCount != #args then
            print(string.format("[Lilia] Warning: getLocalizedString argument count mismatch for key '%s' in language '%s': expected %d, got %d", lookupKey, currentLanguage, formatCount, #args))
            return localizedString
        end

        -- Perform the format substitution
        local success, formattedString = pcall(string.format, localizedString, unpack(args))
        if success then
            return formattedString
        else
            print(string.format("[Lilia] Warning: Format error for key '%s' in language '%s': %s", lookupKey, currentLanguage, formattedString))
            return localizedString
        end
    end

    return localizedString
end

lia.lang.loadFromDir("lilia/gamemode/languages")
hook.Run("OnLocalizationLoaded")

-- Alias for convenience
L = L