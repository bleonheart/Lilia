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

    lia.font.register("AddonInfo_Header", {
        font = "Helvetica",
        size = ScreenScaleH(24),
        weight = 1000
    })

    lia.font.register("AddonInfo_Text", {
        font = "Helvetica",
        size = ScreenScaleH(9),
        weight = 1000
    })

    lia.font.register("AddonInfo_Small", {
        font = "Helvetica",
        size = ScreenScaleH(8),
        weight = 1000
    })

    lia.font.register("ConfigFont", {
        font = lia.config.get("Font"),
        size = 26,
        weight = 500,
        extended = true,
        antialias = true
    })

    lia.font.register("CursiveFont", {
        font = "Segoe Script",
        size = 35,
        weight = 800,
        antialias = true,
    })

    lia.font.register("MediumConfigFont", {
        font = lia.config.get("Font"),
        size = 30,
        weight = 1000,
        extended = true,
        antialias = true
    })

    lia.font.register("SmallConfigFont", {
        font = lia.config.get("Font"),
        size = math.max(ScreenScale(8), 20),
        weight = 500,
        extended = true,
        antialias = true
    })

    lia.font.register("ConfigFontBold", {
        font = lia.config.get("Font"),
        size = 26,
        weight = 1000,
        extended = true,
        antialias = true
    })

    lia.font.register("ConfigFontLarge", {
        font = lia.config.get("Font"),
        size = 36,
        weight = 700,
        extended = true,
        antialias = true
    })

    lia.font.register("DescriptionFontLarge", {
        font = lia.config.get("Font"),
        size = 24,
        weight = 500,
        extended = true,
        antialias = true
    })

    lia.font.register("ticketsystem", {
        font = lia.config.get("Font"),
        size = 15,
        weight = 400
    })

    lia.font.register("VendorButtonFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = 40
    })

    lia.font.register("VendorMediumFont", {
        font = lia.config.get("Font"),
        weight = 500,
        size = 22
    })

    lia.font.register("VendorSmallFont", {
        font = lia.config.get("Font"),
        weight = 500,
        size = 22
    })

    lia.font.register("VendorTinyFont", {
        font = lia.config.get("Font"),
        weight = 500,
        size = 15
    })

    lia.font.register("VendorLightFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = 22
    })

    lia.font.register("VendorItemNameFont", {
        font = lia.config.get("Font"),
        size = 24,
        weight = 700
    })

    lia.font.register("VendorItemDescFont", {
        font = lia.config.get("Font"),
        size = 18,
        weight = 500
    })

    lia.font.register("VendorItemStatsFont", {
        font = lia.config.get("Font"),
        size = 16,
        weight = 500
    })

    lia.font.register("VendorItemPriceFont", {
        font = lia.config.get("Font"),
        size = 20,
        weight = 600
    })

    lia.font.register("VendorActionButtonFont", {
        font = lia.config.get("Font"),
        size = 18,
        weight = 600
    })

    lia.font.register("liaCharLargeFont", {
        font = lia.config.get("GenericFont"),
        size = 36 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 700,
        antialias = true
    })

    lia.font.register("liaCharMediumFont", {
        font = lia.config.get("GenericFont"),
        size = 28 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 600,
        antialias = true
    })

    lia.font.register("liaCharSmallFont", {
        font = lia.config.get("GenericFont"),
        size = 20 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500,
        antialias = true
    })

    lia.font.register("liaCharSubTitleFont", {
        font = lia.config.get("GenericFont"),
        size = 16 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500,
        antialias = true
    })

    lia.font.register("lia3D2DFont", {
        font = lia.config.get("Font"),
        size = 2048,
        extended = true,
        weight = 1000
    })

    lia.font.register("liaTitleFont", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(30) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaSubTitleFont", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(18) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500
    })

    lia.font.register("liaSubTitleFont", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(18) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500
    })

    lia.font.register("liaBigTitle", {
        font = lia.config.get("Font"),
        size = 30,
        weight = 800
    })

    lia.font.register("liaBigText", {
        font = lia.config.get("Font"),
        size = 26,
        weight = 600
    })

    lia.font.register("liaHugeText", {
        font = lia.config.get("Font"),
        size = 48,
        weight = 600
    })

    lia.font.register("liaBigBtn", {
        font = lia.config.get("Font"),
        size = 28,
        weight = 900
    })

    lia.font.register("liaMenuButtonFont", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(14),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaMenuButtonLightFont", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(14) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 200
    })

    lia.font.register("liaToolTipText", {
        font = lia.config.get("Font"),
        size = 20,
        extended = true,
        weight = 500
    })

    lia.font.register("liaDynFontSmall", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(22) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaDynFontMedium", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(28) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaDynFontBig", {
        font = lia.config.get("Font"),
        size = ScreenScaleH(48) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaCleanTitleFont", {
        font = lia.config.get("GenericFont"),
        size = 200 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaHugeFont", {
        font = lia.config.get("GenericFont"),
        size = 72 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaLargeFont", {
        font = lia.config.get("GenericFont"),
        size = 48 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaBigFont", {
        font = lia.config.get("GenericFont"),
        size = 36 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaMediumFont", {
        font = lia.config.get("GenericFont"),
        size = 25 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaSmallFont", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(6), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500
    })

    lia.font.register("liaMiniFont", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(5), 14) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 400
    })

    lia.font.register("liaMediumLightFont", {
        font = lia.config.get("GenericFont"),
        size = 25 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 200
    })

    lia.font.register("liaGenericFont", {
        font = lia.config.get("GenericFont"),
        size = 20 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 1000
    })

    lia.font.register("liaGenericLightFont", {
        font = lia.config.get("GenericFont"),
        size = 20 * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 500
    })

    lia.font.register("liaChatFont", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(7), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 200
    })

    lia.font.register("liaChatFontItalics", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(7), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 200,
        italic = true
    })

    lia.font.register("liaChatFontBold", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(7), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 800
    })

    lia.font.register("liaItemDescFont", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(6), 17) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        shadow = true,
        weight = 500
    })

    lia.font.register("liaSmallBoldFont", {
        font = lia.config.get("GenericFont"),
        size = math.max(ScreenScaleH(8), 20) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 800
    })

    lia.font.register("liaItemBoldFont", {
        font = lia.config.get("GenericFont"),
        shadow = true,
        size = math.max(ScreenScaleH(8), 20) * math.min(ScrW() / 1920, ScrH() / 1080),
        extended = true,
        weight = 800
    })

    lia.font.register("liaNoticeFont", {
        font = lia.config.get("GenericFont"),
        size = 22,
        weight = 500,
        extended = true,
        antialias = true
    })

    local cs = ScrH() / 1080
    lia.font.register("liaCharTitleFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = math.floor(70 * cs + 10),
        additive = true
    })

    lia.font.register("liaCharDescFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = math.floor(24 * cs + 10),
        additive = true
    })

    lia.font.register("liaCharSubTitleFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = math.floor(12 * cs + 10),
        additive = true
    })

    lia.font.register("liaCharButtonFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = math.floor(24 * cs + 10),
        additive = true
    })

    lia.font.register("liaCharSmallButtonFont", {
        font = lia.config.get("Font"),
        weight = 200,
        size = math.floor(22 * cs + 10),
        additive = true
    })

    lia.font.register("PoppinsSmall", {
        font = "Poppins",
        extended = true,
        size = 16
    })

    lia.font.register("PoppinsMedium", {
        font = "Poppins",
        extended = true,
        size = 32
    })

    lia.font.register("PoppinsBig", {
        font = "Poppins",
        extended = true,
        size = 64
    })

    lia.font.register("MontserratMedium", {
        font = "Montserrat Medium",
        extended = true,
        size = 16,
        weight = 500
    })

    lia.font.register("MontserratBold", {
        font = "Montserrat Bold",
        extended = true,
        size = 16,
        weight = 700
    })

    lia.font.register("Fated.12", {
        font = "Montserrat Medium",
        extended = true,
        size = 12,
        weight = 500
    })

    lia.font.register("Fated.14", {
        font = "Montserrat Medium",
        extended = true,
        size = 14,
        weight = 500
    })

    lia.font.register("Fated.16", {
        font = "Montserrat Medium",
        extended = true,
        size = 16,
        weight = 500
    })

    lia.font.register("Fated.18", {
        font = "Montserrat Medium",
        extended = true,
        size = 18,
        weight = 500
    })

    lia.font.register("Fated.20", {
        font = "Montserrat Medium",
        extended = true,
        size = 20,
        weight = 500
    })

    lia.font.register("Fated.22", {
        font = "Montserrat Medium",
        extended = true,
        size = 22,
        weight = 500
    })

    lia.font.register("Fated.24", {
        font = "Montserrat Medium",
        extended = true,
        size = 24,
        weight = 500
    })

    lia.font.register("Fated.26", {
        font = "Montserrat Medium",
        extended = true,
        size = 26,
        weight = 500
    })

    lia.font.register("Fated.28", {
        font = "Montserrat Medium",
        extended = true,
        size = 28,
        weight = 500
    })

    lia.font.register("Fated.30", {
        font = "Montserrat Medium",
        extended = true,
        size = 30,
        weight = 500
    })

    lia.font.register("Fated.32", {
        font = "Montserrat Medium",
        extended = true,
        size = 32,
        weight = 500
    })

    lia.font.register("Fated.36", {
        font = "Montserrat Medium",
        extended = true,
        size = 36,
        weight = 500
    })

    lia.font.register("Fated.40", {
        font = "Montserrat Medium",
        extended = true,
        size = 40,
        weight = 500
    })

    lia.font.register("Fated.48", {
        font = "Montserrat Medium",
        extended = true,
        size = 48,
        weight = 500
    })

    lia.font.register("Fated.72", {
        font = "Montserrat Medium",
        extended = true,
        size = 72,
        weight = 500
    })

    lia.font.register("Fated.12b", {
        font = "Montserrat Bold",
        extended = true,
        size = 12,
        weight = 700
    })

    lia.font.register("Fated.14b", {
        font = "Montserrat Bold",
        extended = true,
        size = 14,
        weight = 700
    })

    lia.font.register("Fated.16b", {
        font = "Montserrat Bold",
        extended = true,
        size = 16,
        weight = 700
    })

    lia.font.register("Fated.18b", {
        font = "Montserrat Bold",
        extended = true,
        size = 18,
        weight = 700
    })

    lia.font.register("Fated.20b", {
        font = "Montserrat Bold",
        extended = true,
        size = 20,
        weight = 700
    })

    lia.font.register("Fated.22b", {
        font = "Montserrat Bold",
        extended = true,
        size = 22,
        weight = 700
    })

    lia.font.register("Fated.24b", {
        font = "Montserrat Bold",
        extended = true,
        size = 24,
        weight = 700
    })

    lia.font.register("Fated.26b", {
        font = "Montserrat Bold",
        extended = true,
        size = 26,
        weight = 700
    })

    lia.font.register("Fated.28b", {
        font = "Montserrat Bold",
        extended = true,
        size = 28,
        weight = 700
    })

    lia.font.register("Fated.30b", {
        font = "Montserrat Bold",
        extended = true,
        size = 30,
        weight = 700
    })

    lia.font.register("Fated.32b", {
        font = "Montserrat Bold",
        extended = true,
        size = 32,
        weight = 700
    })

    lia.font.register("Fated.36b", {
        font = "Montserrat Bold",
        extended = true,
        size = 36,
        weight = 700
    })

    lia.font.register("Fated.40b", {
        font = "Montserrat Bold",
        extended = true,
        size = 40,
        weight = 700
    })

    lia.font.register("Fated.48b", {
        font = "Montserrat Bold",
        extended = true,
        size = 48,
        weight = 700
    })

    lia.font.register("Fated.72b", {
        font = "Montserrat Bold",
        extended = true,
        size = 72,
        weight = 700
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

        hook.Run("PostLoadFonts", lia.config.get("Font"), lia.config.get("GenericFont"))
    end

    hook.Add("OnScreenSizeChanged", "liaFontsRefreshFonts", lia.font.refresh)
    hook.Add("RefreshFonts", "liaFontsRefresh", lia.font.refresh)
end

lia.config.add("Font", "font", "PoppinsMedium", function()
    if not CLIENT then return end
    hook.Run("RefreshFonts")
end, {
    desc = "fontDesc",
    category = "categoryFonts",
    type = "Table",
    options = CLIENT and lia.font.getAvailableFonts() or {"PoppinsMedium"}
})

lia.config.add("GenericFont", "genericFont", "PoppinsMedium", function()
    if not CLIENT then return end
    hook.Run("RefreshFonts")
end, {
    desc = "genericFontDesc",
    category = "categoryFonts",
    type = "Table",
    options = CLIENT and lia.font.getAvailableFonts() or {"PoppinsMedium"}
})

hook.Run("PostLoadFonts", lia.config.get("Font"), lia.config.get("GenericFont"))
