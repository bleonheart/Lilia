lia.font = lia.font or {}
lia.font.stored = lia.font.stored or {}
function lia.font.register(fontName, fontData)
    if not (isstring(fontName) and istable(fontData)) then return lia.error(L("invalidFont")) end
    lia.font.stored[fontName] = SERVER and {
        font = true
    } or fontData

    if CLIENT then surface.CreateFont(fontName, fontData) end
end

function lia.font.getAvailableFonts()
    local list = {}
    for name in pairs(lia.font.stored) do
        list[#list + 1] = name
    end

    table.sort(list)
    return list
end

function lia.font.registerFonts(fontName)
    local mainFont = fontName or lia.config.get("Font", "Montserrat Medium")
    lia.font.register("liaCharSubTitleFont", {
        font = mainFont,
        size = 16,
        extended = true,
        weight = 500,
        antialias = true
    })

    lia.font.register("liaHugeFont", {
        font = mainFont,
        size = 72,
        extended = true,
        weight = 1000
    })

    lia.font.register("liaBigFont", {
        font = mainFont,
        size = 36,
        extended = true,
        weight = 1000
    })

    lia.font.register("liaMediumFont", {
        font = mainFont,
        size = 25,
        extended = true,
        weight = 1000
    })

    lia.font.register("liaSmallFont", {
        font = mainFont,
        size = 17,
        extended = true,
        weight = 500
    })

    lia.font.register("liaMiniFont", {
        font = mainFont,
        size = 14,
        extended = true,
        weight = 400
    })

    lia.font.register("liaMediumLightFont", {
        font = mainFont,
        size = 25,
        extended = true,
        weight = 200
    })

    lia.font.register("liaGenericFont", {
        font = mainFont,
        size = 20,
        extended = true,
        weight = 1000
    })

    lia.font.register("liaChatFont", {
        font = mainFont,
        size = 17,
        extended = true,
        weight = 200
    })

    lia.font.register("liaChatFontItalics", {
        font = mainFont,
        size = 17,
        extended = true,
        weight = 200,
        italic = true
    })

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

    lia.font.register("liaItemDescFont", {
        font = mainFont,
        size = 17,
        extended = true,
        shadow = true,
        weight = 500
    })

    lia.font.register("liaItemBoldFont", {
        font = mainFont,
        shadow = true,
        size = 20,
        extended = true,
        weight = 800
    })

    lia.font.register("liaCharSubTitleFont", {
        font = mainFont,
        weight = 200,
        size = 22,
        additive = true
    })

    lia.font.register("liaCharButtonFont", {
        font = mainFont,
        weight = 200,
        size = 34,
        additive = true
    })

    local fatedSizes = {12, 14, 15, 16, 18, 20, 24, 28, 30, 36, 40, 48}
    for _, size in ipairs(fatedSizes) do
        lia.font.register("LiliaFont." .. size, {
            font = mainFont,
            size = size,
            extended = true,
            antialias = true,
            weight = 500
        })

        lia.font.register("LiliaFont." .. size .. "b", {
            font = mainFont:gsub(" Medium", " Bold"):gsub("Montserrat$", "Montserrat Bold"),
            size = size,
            extended = true,
            antialias = true,
            weight = 700
        })
    end

    hook.Run("PostLoadFonts", mainFont, mainFont)
end

if CLIENT then
    local oldSurfaceSetFont = surface.SetFont
    function surface.SetFont(font)
        if isstring(font) and not lia.font.stored[font] then
            local fontData = {
                font = font,
                size = 16,
                extended = true,
                antialias = true,
                weight = 500
            }

            local baseFont, sizeStr = font:match("^([^%.]+)%.(%d+)$")
            if baseFont and sizeStr then
                fontData.font = baseFont
                fontData.size = tonumber(sizeStr) or 16
            end

            local boldMatch = font:match("^(.-)(%d+)b$")
            if boldMatch then
                fontData.font = boldMatch
                fontData.weight = 700
            end

            lia.font.register(font, fontData)
        end
        return oldSurfaceSetFont(font)
    end
end

lia.config.add("Font", "font", "Montserrat Medium", function()
    if not CLIENT then return end
    hook.Run("RefreshFonts")
end, {
    desc = "fontDesc",
    category = "categoryFonts",
    type = "Table",
    options = lia.font.getAvailableFonts()
})

hook.Add("InitializedConfig", "liaFontsOnConfigLoad", function() lia.font.registerFonts(lia.config.get("Font", "Montserrat Medium")) end)