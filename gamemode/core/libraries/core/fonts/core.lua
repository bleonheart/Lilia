lia.font = lia.font or {}
lia.font.stored = lia.font.stored or {}
function lia.font.loadFonts()
    if not CLIENT then return end
    local loadedCount = 0
    local failedCount = 0
    for fontName, fontData in pairs(lia.font.stored) do
        if istable(fontData) then
            local success = pcall(function()
                surface.CreateFont(fontName, fontData)
                loadedCount = loadedCount + 1
            end)

            if not success then failedCount = failedCount + 1 end
        end
    end
end

function lia.font.register(fontName, fontData)
    if not (isstring(fontName) and istable(fontData)) then return lia.error("[Font] Invalid font name or data provided.") end
    if #fontName > 63 then return end
    if fontData.font and #fontData.font > 63 then return end
    lia.font.stored[fontName] = SERVER and {
        font = true
    } or fontData

    if CLIENT then surface.CreateFont(fontName, fontData) end
end

local function isConfigDerivedFontName(fontName)
    return isstring(fontName) and (fontName:StartWith("lia") or fontName:StartWith("LiliaFont") or fontName:StartWith("LiliaHUDFont"))
end

function lia.font.getAvailableFonts()
    local list = {}
    local seen = {}
    for name, fontData in pairs(lia.font.stored) do
        if istable(fontData) and not isConfigDerivedFontName(name) then
            local fontFace = fontData.font
            if isstring(fontFace) and fontFace ~= "" and not seen[fontFace] then
                seen[fontFace] = true
                list[#list + 1] = fontFace
            end
        end
    end

    table.sort(list)
    return list
end

function lia.font.getBoldFontName(fontName)
    if string.find(fontName, "Montserrat") then
        return fontName:gsub(" Medium", " Bold"):gsub("Montserrat$", "Montserrat Bold")
    else
        return fontName:gsub(" Medium", " Bold")
    end
end

function lia.font.registerFonts(fontName)
    local mainFont = fontName or lia.config.get("Font", "Montserrat")
    local hudFont = lia.config.get("HUDFont", "Montserrat")
    lia.font.register("Montserrat Regular", {
        font = "Montserrat",
        size = 16,
        extended = true,
        antialias = true
    })

    lia.font.register("Montserrat Medium", {
        font = "Montserrat Medium",
        size = 16,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Montserrat Bold", {
        font = "Montserrat Bold",
        size = 16,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Roboto Black", {
        font = "Roboto Black",
        size = 16,
        extended = true,
        antialias = true,
        weight = 900
    })

    lia.font.register("Roboto Black Italic", {
        font = "Roboto Black Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 900,
        italic = true
    })

    lia.font.register("Roboto Bold", {
        font = "Roboto Bold",
        size = 16,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Roboto Bold Condensed", {
        font = "Roboto Bold Condensed",
        size = 16,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Roboto Bold Condensed Italic", {
        font = "Roboto Bold Condensed Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 700,
        italic = true
    })

    lia.font.register("Roboto Condensed", {
        font = "Roboto Condensed",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400
    })

    lia.font.register("Roboto Condensed Italic", {
        font = "Roboto Condensed Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400,
        italic = true
    })

    lia.font.register("Roboto Italic", {
        font = "Roboto Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400,
        italic = true
    })

    lia.font.register("Roboto Light", {
        font = "Roboto Light",
        size = 16,
        extended = true,
        antialias = true,
        weight = 300
    })

    lia.font.register("Roboto Light Italic", {
        font = "Roboto Light Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 300,
        italic = true
    })

    lia.font.register("Roboto Medium", {
        font = "Roboto Medium",
        size = 16,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Roboto Medium Italic", {
        font = "Roboto Medium Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 500,
        italic = true
    })

    lia.font.register("Roboto Regular", {
        font = "Roboto",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400
    })

    lia.font.register("Roboto Thin", {
        font = "Roboto Thin",
        size = 16,
        extended = true,
        antialias = true,
        weight = 100
    })

    lia.font.register("Roboto Thin Italic", {
        font = "Roboto Thin Italic",
        size = 16,
        extended = true,
        antialias = true,
        weight = 100,
        italic = true
    })

    lia.font.register("Coolvetica", {
        font = "coolvetica",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400
    })

    lia.font.register("Akbar", {
        font = "akbar",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400
    })

    lia.font.register("CS Dingbats", {
        font = "cs",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400
    })

    lia.font.register("CSD Dingbats", {
        font = "csd",
        size = 16,
        extended = true,
        antialias = true,
        weight = 400
    })

    for size = 1, 100 do
        lia.font.register("LiliaFont." .. size, {
            font = mainFont,
            size = size,
            extended = true,
            antialias = true,
            weight = 500
        })

        lia.font.register("LiliaFont." .. size .. "b", {
            font = lia.font.getBoldFontName(mainFont),
            size = size,
            extended = true,
            antialias = true,
            weight = 700
        })

        lia.font.register("LiliaFont." .. size .. "i", {
            font = mainFont,
            size = size,
            extended = true,
            antialias = true,
            weight = 500,
            italic = true
        })

        lia.font.register("LiliaHUDFont." .. size, {
            font = hudFont,
            size = size,
            extended = true,
            antialias = true,
            weight = 500
        })

        lia.font.register("LiliaHUDFont." .. size .. "b", {
            font = lia.font.getBoldFontName(hudFont),
            size = size,
            extended = true,
            antialias = true,
            weight = 700
        })

        lia.font.register("LiliaHUDFont." .. size .. "i", {
            font = hudFont,
            size = size,
            extended = true,
            antialias = true,
            weight = 500,
            italic = true
        })
    end

    hook.Run("PostLoadFonts", mainFont, mainFont)
end

if CLIENT then
    local oldSurfaceSetFont = surface.SetFont
    local function getManagedFontData(fontName)
        if not isstring(fontName) or #fontName > 63 then return end
        local mainFont = lia.config.get("Font", "Montserrat") or "Montserrat"
        local hudFont = lia.config.get("HUDFont", "Montserrat") or "Montserrat"
        local baseName
        local size = 16
        local suffix = ""
        if fontName == "LiliaFont" then
            baseName = "LiliaFont"
        elseif fontName == "LiliaHUDFont" then
            baseName = "LiliaHUDFont"
        else
            local sizeString
            baseName, sizeString, suffix = fontName:match("^(LiliaFont)%.(%d+)([bis]*)$")
            if not baseName then baseName, sizeString, suffix = fontName:match("^(LiliaHUDFont)%.(%d+)([bis]*)$") end
            if not baseName then return end
            size = tonumber(sizeString)
            if not size or size < 1 then return end
        end

        local fontFace = baseName == "LiliaFont" and mainFont or hudFont
        local bold = suffix:find("b", 1, true) ~= nil
        local italic = suffix:find("i", 1, true) ~= nil
        local shadow = suffix:find("s", 1, true) ~= nil
        if bold then fontFace = lia.font.getBoldFontName(fontFace) end
        return {
            font = fontFace,
            size = size,
            extended = true,
            antialias = true,
            weight = bold and 700 or 500,
            italic = italic,
            shadow = shadow
        }
    end

    function surface.SetFont(fontName)
        if isstring(fontName) and not lia.font.stored[fontName] then
            local fontData = getManagedFontData(fontName)
            if fontData then lia.font.register(fontName, fontData) end
        end
        return oldSurfaceSetFont(fontName)
    end

    hook.Add("InitializedConfig", "liaFontsOnConfigLoad", function()
        local function initializeFonts()
            local fontName = lia.config.get("Font", "Montserrat")
            lia.font.registerFonts(fontName)
            timer.Simple(0.2, function()
                lia.font.loadFonts()
                hook.Run("RefreshFonts")
            end)
        end

        if not lia.config.stored or not lia.config.stored.Font then
            timer.Simple(0.1, initializeFonts)
        else
            initializeFonts()
        end
    end)
end

lia.config.add("Font", "Font", "Montserrat", function()
    if not CLIENT then return end
    hook.Run("RefreshFonts")
end, {
    desc = "Font Description",
    category = "Core",
    type = "Table",
    options = function()
        if lia.font and isfunction(lia.font.getAvailableFonts) then return lia.font.getAvailableFonts() end
        return {"Montserrat"}
    end
})

hook.Add("OnConfigUpdated", "liaFontsOnConfigUpdate", function(key, oldValue, newValue)
    if not CLIENT or oldValue == newValue or key ~= "Font" then return end
    lia.font.registerFonts(newValue or "Montserrat")
    timer.Simple(0.1, function()
        lia.font.loadFonts()
        hook.Run("RefreshFonts")
    end)
end)

hook.Add("OnConfigUpdated", "liaHUDFontsOnConfigUpdate", function(key, oldValue, newValue)
    if not CLIENT or oldValue == newValue or key ~= "HUDFont" then return end
    lia.font.registerFonts(lia.config.get("Font", "Montserrat"))
    timer.Simple(0.1, function()
        lia.font.loadFonts()
        hook.Run("RefreshFonts")
    end)
end)
