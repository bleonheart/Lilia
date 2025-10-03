lia.font = lia.font or {}
lia.font.stored = lia.font.stored or {}
if CLIENT then
    function lia.font.register(fontName, fontData)
        if not (isstring(fontName) and istable(fontData)) then return lia.error(L("invalidFont")) end
        surface.CreateFont(fontName, fontData)
    end

    local oldCreateFont = surface.CreateFont
    surface.CreateFont = function(name, data)
        if isstring(name) and istable(data) then lia.font.stored[name] = data end
        oldCreateFont(name, data)
    end

    lia.font.register("ConfigFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 26,
        weight = 500,
        extended = true,
        antialias = true
    })

    lia.font.register("ConfigFontLarge", {
        font = lia.config.get("Font", "Montserrat"),
        size = 36,
        weight = 700,
        extended = true,
        antialias = true
    })

    lia.font.register("DescriptionFontLarge", {
        font = lia.config.get("Font", "Montserrat"),
        size = 24,
        weight = 500,
        extended = true,
        antialias = true
    })

    lia.font.register("ticketsystem", {
        font = lia.config.get("Font", "Montserrat"),
        size = 15,
        weight = 400
    })

    lia.font.register("VendorItemNameFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 24,
        weight = 700
    })

    lia.font.register("VendorItemDescFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 18,
        weight = 500
    })

    lia.font.register("liaCharSubTitleFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 16 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500,
        antialias = true
    })

    lia.font.register("liaBigTitle", {
        font = lia.config.get("Font", "Montserrat"),
        size = 30,
        weight = 800
    })

    lia.font.register("liaHugeText", {
        font = lia.config.get("Font", "Montserrat"),
        size = 48,
        weight = 600
    })

    lia.font.register("liaBigBtn", {
        font = lia.config.get("Font", "Montserrat"),
        size = 28,
        weight = 900
    })

    lia.font.register("liaToolTipText", {
        font = lia.config.get("Font", "Montserrat"),
        size = 20,
        extended = true,
        weight = 500
    })

    lia.font.register("liaHugeFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 72 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaBigFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 36 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaMediumFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 25 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaSmallFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = math.max(ScreenScaleH(6), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500
    })

    lia.font.register("liaMiniFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = math.max(ScreenScaleH(5), 14) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 400
    })

    lia.font.register("liaMediumLightFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 25 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 200
    })

    lia.font.register("liaGenericFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = 20 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaChatFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = math.max(ScreenScaleH(7), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 200
    })

    lia.font.register("liaChatFontItalics", {
        font = lia.config.get("Font", "Montserrat"),
        size = math.max(ScreenScaleH(7), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
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

    lia.font.register("marlett", {
        font = "Marlett",
        size = 14,
        extended = true,
        antialias = true
    })

    lia.font.register("Fated.12", {
        font = "Montserrat Medium",
        size = 12,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.12b", {
        font = "Montserrat Bold",
        size = 12,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.14", {
        font = "Montserrat Medium",
        size = 14,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.14b", {
        font = "Montserrat Bold",
        size = 14,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.16", {
        font = "Montserrat Medium",
        size = 16,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.16b", {
        font = "Montserrat Bold",
        size = 16,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.18", {
        font = "Montserrat Medium",
        size = 18,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.18b", {
        font = "Montserrat Bold",
        size = 18,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.20", {
        font = "Montserrat Medium",
        size = 20,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.20b", {
        font = "Montserrat Bold",
        size = 20,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.24", {
        font = "Montserrat Medium",
        size = 24,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.24b", {
        font = "Montserrat Bold",
        size = 24,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.28", {
        font = "Montserrat Medium",
        size = 28,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.28b", {
        font = "Montserrat Bold",
        size = 28,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.36", {
        font = "Montserrat Medium",
        size = 36,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.36b", {
        font = "Montserrat Bold",
        size = 36,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("Fated.40", {
        font = "Montserrat Medium",
        size = 40,
        extended = true,
        antialias = true,
        weight = 500
    })

    lia.font.register("Fated.40b", {
        font = "Montserrat Bold",
        size = 40,
        extended = true,
        antialias = true,
        weight = 700
    })

    lia.font.register("liaItemDescFont", {
        font = lia.config.get("Font", "Montserrat"),
        size = math.max(ScreenScaleH(6), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        shadow = true,
        weight = 500
    })

    lia.font.register("liaItemBoldFont", {
        font = lia.config.get("Font", "Montserrat"),
        shadow = true,
        size = math.max(ScreenScaleH(8), 20) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 800
    })

    lia.font.register("liaCharSubTitleFont", {
        font = lia.config.get("Font", "Montserrat"),
        weight = 200,
        size = math.floor(12 * ScrH() / 1080 + 10),
        additive = true
    })

    lia.font.register("liaCharButtonFont", {
        font = lia.config.get("Font", "Montserrat"),
        weight = 200,
        size = math.floor(24 * ScrH() / 1080 + 10),
        additive = true
    })

    function lia.font.getAvailableFonts()
        local list = {}
        for name in pairs(lia.font.stored) do
            list[#list + 1] = name
        end

        table.sort(list)
        return list
    end

    function lia.font.refresh()
        local storedFonts = lia.font.stored
        lia.font.stored = {}
        for name, data in pairs(storedFonts) do
            surface.CreateFont(name, data)
        end

        hook.Run("PostLoadFonts", lia.config.get("Font", "Montserrat"), lia.config.get("Font", "Montserrat"))
    end

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

    hook.Add("OnScreenSizeChanged", "liaFontsRefreshFonts", lia.font.refresh)
    hook.Add("RefreshFonts", "liaFontsRefresh", lia.font.refresh)
end

lia.config.add("Font", "font", "Montserrat Medium", function()
    if not CLIENT then return end
    hook.Run("RefreshFonts")
end, {
    desc = "fontDesc",
    category = "categoryFonts",
    type = "Table",
    options = CLIENT and lia.font.getAvailableFonts() or {"Montserrat Medium"}
})

hook.Run("PostLoadFonts", lia.config.get("Font", "Montserrat"), lia.config.get("Font", "Montserrat"))