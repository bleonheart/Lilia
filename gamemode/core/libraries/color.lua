lia.color = lia.color or {}
lia.color.stored = lia.color.stored or {}
lia.color.themes = lia.color.themes or {}
if CLIENT then
    function lia.color.register(name, color)
        lia.color.stored[name:lower()] = color
    end

    function lia.color.Adjust(color, rOffset, gOffset, bOffset, aOffset)
        return Color(math.Clamp(color.r + rOffset, 0, 255), math.Clamp(color.g + gOffset, 0, 255), math.Clamp(color.b + bOffset, 0, 255), math.Clamp((color.a or 255) + (aOffset or 0), 0, 255))
    end

    function lia.color.darken(color, factor)
        factor = factor or 0.1
        local darkenFactor = 1 - math.Clamp(factor, 0, 1)
        return Color(math.floor(color.r * darkenFactor), math.floor(color.g * darkenFactor), math.floor(color.b * darkenFactor), color.a or 255)
    end

    function lia.color.getCurrentTheme()
        local forceTheme = lia.config.get("forceTheme", true)
        if not forceTheme then
            local optionTheme = lia.option.get("theme", nil)
            if optionTheme then return optionTheme:lower() end
        end
        return lia.config.get("Theme", "Teal"):lower()
    end

    function lia.color.getCurrentThemeName()
        local forceTheme = lia.config.get("forceTheme", true)
        if not forceTheme then
            local optionTheme = lia.option.get("theme", nil)
            if optionTheme then return optionTheme end
        end
        return lia.config.get("Theme", "Teal")
    end

    function lia.color.getMainColor()
        local currentTheme = lia.color.getCurrentTheme()
        local themeData = lia.color.themes[currentTheme]
        if themeData and themeData.maincolor then return themeData.maincolor end
        local defaultTheme = lia.color.themes["teal"]
        return defaultTheme and defaultTheme.maincolor or Color(80, 180, 180)
    end

    function lia.color.applyTheme(themeName, useTransition)
        themeName = themeName or lia.color.getCurrentTheme()
        local themeData = lia.color.themes[themeName]
        if themeData then
            if useTransition and CLIENT then
                lia.color.startThemeTransition(themeName)
            else
                lia.color.theme = table.Copy(themeData)
            end
        end
    end

    function lia.color.isTransitionActive()
        return lia.color.transition and lia.color.transition.active or false
    end

    function lia.color.testThemeTransition(themeName)
        lia.color.applyTheme(themeName, true)
        print(L("startedThemeTransition", themeName))
    end

    lia.color.transition = {
        active = false,
        to = nil,
        progress = 0,
        speed = 3,
        colorBlend = 8
    }

    function lia.color.startThemeTransition(name)
        local targetTheme = lia.color.themes[name:lower()]
        if not targetTheme then return end
        lia.color.transition.to = table.Copy(targetTheme)
        lia.color.transition.active = true
        lia.color.transition.progress = 0
        if not hook.GetTable().LiliaThemeTransition then
            hook.Add('Think', 'LiliaThemeTransition', function()
                if not lia.color.transition.active then return end
                local dt = FrameTime()
                lia.color.transition.progress = math.min(lia.color.transition.progress + (lia.color.transition.speed * dt), 1)
                local to = lia.color.transition.to
                if not to then
                    lia.color.transition.active = false
                    hook.Remove('Think', 'LiliaThemeTransition')
                    return
                end

                for k, v in pairs(to) do
                    if lia.color.isColor(v) then
                        local current = lia.color.stored[k]
                        if current and lia.color.isColor(current) then
                            lia.color.stored[k] = lia.color.lerp(lia.color.transition.colorBlend, current, v)
                        else
                            lia.color.stored[k] = v
                        end
                    elseif type(v) == 'table' and #v > 0 then
                        if not lia.color.stored[k] then lia.color.stored[k] = {} end
                        for i = 1, #v do
                            local vi = v[i]
                            if lia.color.isColor(vi) then
                                local currentVal = lia.color.stored[k] and lia.color.stored[k][i]
                                if currentVal and lia.color.isColor(currentVal) then
                                    lia.color.stored[k][i] = lia.color.lerp(lia.color.transition.colorBlend, currentVal, vi)
                                else
                                    lia.color.stored[k][i] = vi
                                end
                            else
                                lia.color.stored[k][i] = vi
                            end
                        end
                    else
                        lia.color.stored[k] = v
                    end
                end

                if lia.color.transition.progress >= 0.999 then
                    for k, v in pairs(to) do
                        lia.color.stored[k] = v
                    end

                    lia.color.transition.active = false
                    hook.Remove('Think', 'LiliaThemeTransition')
                end
            end)
        end
    end

    function lia.color.isColor(v)
        return type(v) == 'table' and type(v.r) == 'number' and type(v.g) == 'number' and type(v.b) == 'number' and type(v.a) == 'number'
    end

    function lia.color.ReturnMainAdjustedColors()
        local base = lia.color.getMainColor()
        return {
            background = lia.color.Adjust(base, -20, -10, -50, 0),
            sidebar = lia.color.Adjust(base, -30, -15, -60, -55),
            accent = base,
            text = Color(245, 245, 220, 255),
            hover = lia.color.Adjust(base, -40, -25, -70, -35),
            border = Color(255, 255, 255, 255),
            highlight = Color(255, 255, 255, 30)
        }
    end

    function lia.color.lerp(frac, col1, col2)
        local ft = FrameTime() * frac
        local r1 = col1 and col1.r or 255
        local g1 = col1 and col1.g or 255
        local b1 = col1 and col1.b or 255
        local a1 = col1 and col1.a or 255
        local r2 = col2 and col2.r or 255
        local g2 = col2 and col2.g or 255
        local b2 = col2 and col2.b or 255
        local a2 = col2 and col2.a or 255
        return Color(Lerp(ft, r1, r2), Lerp(ft, g1, g2), Lerp(ft, b1, b2), Lerp(ft, a1, a2))
    end

    local oldColor = Color
    function Color(r, g, b, a)
        if isstring(r) then
            local c = lia.color.stored[r:lower()]
            if c and type(c) == 'table' and c.r and c.g and c.b and c.a then return oldColor(c.r, c.g, c.b, c.a) end
            return oldColor(255, 255, 255, 255)
        end
        return oldColor(r, g, b, a)
    end

    lia.color.register("black", {0, 0, 0})
    lia.color.register("white", {255, 255, 255})
    lia.color.register("gray", {128, 128, 128})
    lia.color.register("dark_gray", {64, 64, 64})
    lia.color.register("light_gray", {192, 192, 192})
    lia.color.register("red", {255, 0, 0})
    lia.color.register("dark_red", {139, 0, 0})
    lia.color.register("green", {0, 255, 0})
    lia.color.register("dark_green", {0, 100, 0})
    lia.color.register("blue", {0, 0, 255})
    lia.color.register("dark_blue", {0, 0, 139})
    lia.color.register("yellow", {255, 255, 0})
    lia.color.register("orange", {255, 165, 0})
    lia.color.register("purple", {128, 0, 128})
    lia.color.register("pink", {255, 192, 203})
    lia.color.register("brown", {165, 42, 42})
    lia.color.register("maroon", {128, 0, 0})
    lia.color.register("navy", {0, 0, 128})
    lia.color.register("olive", {128, 128, 0})
    lia.color.register("teal", {0, 128, 128})
    lia.color.register("cyan", {0, 255, 255})
    lia.color.register("magenta", {255, 0, 255})
    hook.Add("InitializedConfig", "ApplyTheme", function() lia.color.applyTheme() end)
    hook.Add("InitializedOptions", "ApplyThemeFromOption", function()
        local forceTheme = lia.config.get("forceTheme", true)
        if not forceTheme then
            local optionTheme = lia.option.get("theme", nil)
            if optionTheme then
                lia.color.applyTheme(optionTheme, false)
                return
            end
        end

        lia.color.applyTheme()
    end)
end

function lia.color.registerTheme(name, themeData)
    local id = name:lower()
    lia.color.themes[id] = themeData
end

function lia.color.getAllThemes()
    local themes = {}
    for id, _ in pairs(lia.color.themes) do
        themes[#themes + 1] = id
    end

    table.sort(themes)
    return themes
end

lia.color.registerTheme("Dark", {
    header = Color(51, 51, 51),
    header_text = Color(109, 109, 109),
    background = Color(34, 34, 34),
    background_alpha = Color(34, 34, 34, 210),
    background_panelpopup = Color(29, 29, 29),
    button = Color(56, 56, 56),
    button_shadow = Color(0, 0, 0, 30),
    button_hovered = Color(52, 70, 109),
    category = Color(54, 54, 56),
    category_opened = Color(54, 54, 56, 0),
    theme = Color(106, 108, 197),
    maincolor = Color(106, 108, 197),
    panel = {Color(71, 71, 75), Color(60, 60, 64), Color(193, 193, 193)},
    panel_alpha = {ColorAlpha(Color(71, 71, 75), 150), ColorAlpha(Color(60, 60, 64), 150), ColorAlpha(Color(193, 193, 193), 150)},
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    window_shadow = Color(0, 0, 0, 150),
    gray = Color(190, 190, 190, 220),
    text = Color(255, 255, 255)
})

lia.color.registerTheme("Dark Mono", {
    header = Color(51, 51, 51),
    header_text = Color(109, 109, 109),
    background = Color(34, 34, 34),
    background_alpha = Color(34, 34, 34, 210),
    background_panelpopup = Color(29, 29, 29),
    button = Color(56, 56, 56),
    button_shadow = Color(0, 0, 0, 30),
    button_hovered = Color(52, 70, 109),
    category = Color(54, 54, 56),
    category_opened = Color(54, 54, 56, 0),
    theme = Color(121, 121, 121),
    maincolor = Color(121, 121, 121),
    panel = {Color(71, 71, 75), Color(60, 60, 64), Color(193, 193, 193)},
    panel_alpha = {ColorAlpha(Color(71, 71, 75), 150), ColorAlpha(Color(60, 60, 64), 150), ColorAlpha(Color(193, 193, 193), 150)},
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    window_shadow = Color(0, 0, 0, 150),
    gray = Color(190, 190, 190, 220),
    text = Color(255, 255, 255)
})

lia.color.registerTheme("Graphite", {
    header = Color(40, 40, 40),
    header_text = Color(100, 100, 100),
    background = Color(25, 25, 25),
    background_alpha = Color(25, 25, 25, 210),
    background_panelpopup = Color(20, 20, 20),
    button = Color(45, 45, 45),
    button_shadow = Color(0, 0, 0, 25),
    button_hovered = Color(60, 60, 60),
    category = Color(50, 50, 50),
    category_opened = Color(50, 50, 50, 0),
    theme = Color(130, 130, 130),
    maincolor = Color(130, 130, 130),
    panel = {Color(60, 60, 60), Color(50, 50, 50), Color(80, 80, 80)},
    panel_alpha = {ColorAlpha(Color(60, 60, 60), 130), ColorAlpha(Color(50, 50, 50), 130), ColorAlpha(Color(80, 80, 80), 130)},
    focus_panel = Color(55, 55, 55),
    hover = Color(70, 70, 70),
    window_shadow = Color(0, 0, 0, 120),
    gray = Color(150, 150, 150, 220),
    text = Color(220, 220, 220)
})

lia.color.registerTheme("Light", {
    header = Color(240, 240, 240),
    header_text = Color(150, 150, 150),
    background = Color(255, 255, 255),
    background_alpha = Color(255, 255, 255, 170),
    background_panelpopup = Color(245, 245, 245),
    button = Color(235, 235, 235),
    button_shadow = Color(0, 0, 0, 15),
    button_hovered = Color(215, 220, 255),
    category = Color(240, 240, 245),
    category_opened = Color(240, 240, 245, 0),
    theme = Color(106, 108, 197),
    maincolor = Color(106, 108, 197),
    panel = {Color(250, 250, 255), Color(240, 240, 245), Color(230, 230, 235)},
    panel_alpha = {ColorAlpha(Color(250, 250, 255), 120), ColorAlpha(Color(240, 240, 245), 120), ColorAlpha(Color(230, 230, 235), 120)},
    focus_panel = Color(245, 245, 255),
    hover = Color(235, 240, 255),
    window_shadow = Color(0, 0, 0, 50),
    gray = Color(130, 130, 130, 220),
    text = Color(20, 20, 20)
})

lia.color.registerTheme("Blue", {
    header = Color(36, 48, 66),
    header_text = Color(109, 129, 159),
    background = Color(24, 28, 38),
    background_alpha = Color(24, 28, 38, 210),
    background_panelpopup = Color(20, 24, 32),
    button = Color(38, 54, 82),
    button_shadow = Color(18, 22, 32, 35),
    button_hovered = Color(70, 120, 180),
    category = Color(34, 48, 72),
    category_opened = Color(34, 48, 72, 0),
    theme = Color(80, 160, 220),
    maincolor = Color(80, 160, 220),
    panel = {Color(34, 48, 72), Color(38, 54, 82), Color(70, 120, 180)},
    panel_alpha = {ColorAlpha(Color(34, 48, 72), 110), ColorAlpha(Color(38, 54, 82), 110), ColorAlpha(Color(70, 120, 180), 110)},
    focus_panel = Color(48, 72, 90),
    hover = Color(80, 160, 220, 90),
    window_shadow = Color(18, 22, 32, 90),
    gray = Color(150, 170, 190, 200),
    text = Color(210, 220, 235)
})

lia.color.registerTheme("Red", {
    header = Color(54, 36, 36),
    header_text = Color(159, 109, 109),
    background = Color(32, 24, 24),
    background_alpha = Color(32, 24, 24, 210),
    background_panelpopup = Color(28, 20, 20),
    button = Color(66, 38, 38),
    button_shadow = Color(32, 18, 18, 35),
    button_hovered = Color(140, 70, 70),
    category = Color(62, 34, 34),
    category_opened = Color(62, 34, 34, 0),
    theme = Color(180, 80, 80),
    maincolor = Color(180, 80, 80),
    panel = {Color(62, 34, 34), Color(66, 38, 38), Color(140, 70, 70)},
    panel_alpha = {ColorAlpha(Color(62, 34, 34), 110), ColorAlpha(Color(66, 38, 38), 110), ColorAlpha(Color(140, 70, 70), 110)},
    focus_panel = Color(72, 48, 48),
    hover = Color(180, 80, 80, 90),
    window_shadow = Color(32, 18, 18, 90),
    gray = Color(180, 150, 150, 200),
    text = Color(235, 210, 210)
})

lia.color.registerTheme("Green", {
    header = Color(36, 54, 40),
    header_text = Color(109, 159, 109),
    background = Color(24, 32, 26),
    background_alpha = Color(24, 32, 26, 210),
    background_panelpopup = Color(20, 28, 22),
    button = Color(38, 66, 48),
    button_shadow = Color(18, 32, 22, 35),
    button_hovered = Color(70, 140, 90),
    category = Color(34, 62, 44),
    category_opened = Color(34, 62, 44, 0),
    theme = Color(80, 180, 120),
    maincolor = Color(80, 180, 120),
    panel = {Color(34, 62, 44), Color(38, 66, 48), Color(70, 140, 90)},
    panel_alpha = {ColorAlpha(Color(34, 62, 44), 110), ColorAlpha(Color(38, 66, 48), 110), ColorAlpha(Color(70, 140, 90), 110)},
    focus_panel = Color(48, 72, 58),
    hover = Color(80, 180, 120, 90),
    window_shadow = Color(18, 32, 22, 90),
    gray = Color(150, 180, 150, 200),
    text = Color(210, 235, 210)
})

lia.color.registerTheme("Orange", {
    header = Color(255, 200, 100),
    header_text = Color(200, 120, 30),
    background = Color(255, 245, 220),
    background_alpha = Color(255, 245, 220, 210),
    background_panelpopup = Color(255, 230, 180),
    button = Color(255, 210, 140),
    button_shadow = Color(255, 200, 100, 30),
    button_hovered = Color(255, 170, 60),
    category = Color(255, 230, 180),
    category_opened = Color(255, 230, 180, 0),
    theme = Color(255, 170, 60),
    maincolor = Color(255, 170, 60),
    panel = {Color(255, 230, 180), Color(255, 210, 140), Color(255, 170, 60)},
    panel_alpha = {ColorAlpha(Color(255, 230, 180), 110), ColorAlpha(Color(255, 210, 140), 110), ColorAlpha(Color(255, 170, 60), 110)},
    focus_panel = Color(255, 210, 140),
    hover = Color(255, 200, 100, 90),
    window_shadow = Color(255, 200, 100, 90),
    gray = Color(180, 150, 120, 200),
    text = Color(120, 70, 0)
})

lia.color.registerTheme("Purple", {
    header = Color(120, 81, 169),
    header_text = Color(180, 140, 220),
    background = Color(60, 40, 90),
    background_alpha = Color(60, 40, 90, 210),
    background_panelpopup = Color(80, 60, 120),
    button = Color(140, 100, 200),
    button_shadow = Color(120, 81, 169, 30),
    button_hovered = Color(180, 140, 220),
    category = Color(100, 70, 150),
    category_opened = Color(100, 70, 150, 0),
    theme = Color(180, 140, 220),
    maincolor = Color(180, 140, 220),
    panel = {Color(100, 70, 150), Color(140, 100, 200), Color(180, 140, 220)},
    panel_alpha = {ColorAlpha(Color(100, 70, 150), 110), ColorAlpha(Color(140, 100, 200), 110), ColorAlpha(Color(180, 140, 220), 110)},
    focus_panel = Color(140, 100, 200),
    hover = Color(180, 140, 220, 90),
    window_shadow = Color(120, 81, 169, 90),
    gray = Color(180, 170, 200, 200),
    text = Color(230, 220, 255)
})

lia.color.registerTheme("Coffee", {
    header = Color(67, 48, 36),
    header_text = Color(210, 190, 170),
    background = Color(45, 32, 25),
    background_alpha = Color(45, 32, 25, 215),
    background_panelpopup = Color(38, 28, 22),
    button = Color(84, 60, 45),
    button_shadow = Color(20, 10, 5, 40),
    button_hovered = Color(100, 75, 55),
    category = Color(72, 54, 42),
    category_opened = Color(72, 54, 42, 0),
    theme = Color(150, 110, 75),
    maincolor = Color(150, 110, 75),
    panel = {Color(68, 50, 40), Color(90, 65, 50), Color(150, 110, 75)},
    panel_alpha = {ColorAlpha(Color(68, 50, 40), 110), ColorAlpha(Color(90, 65, 50), 110), ColorAlpha(Color(150, 110, 75), 110)},
    focus_panel = Color(70, 55, 40),
    hover = Color(150, 110, 75, 90),
    window_shadow = Color(15, 10, 5, 100),
    gray = Color(180, 150, 130, 200),
    text = Color(235, 225, 210)
})

lia.color.registerTheme("Ice", {
    header = Color(190, 225, 250),
    header_text = Color(68, 104, 139),
    background = Color(235, 245, 255),
    background_alpha = Color(235, 245, 255, 200),
    background_panelpopup = Color(220, 235, 245),
    button = Color(145, 185, 225),
    button_shadow = Color(80, 110, 140, 40),
    button_hovered = Color(170, 210, 255),
    category = Color(200, 225, 245),
    category_opened = Color(200, 225, 245, 0),
    theme = Color(100, 170, 230),
    maincolor = Color(100, 170, 230),
    panel = {Color(210, 235, 250), Color(190, 220, 240), Color(100, 170, 230)},
    panel_alpha = {ColorAlpha(Color(210, 235, 250), 120), ColorAlpha(Color(190, 220, 240), 120), ColorAlpha(Color(100, 170, 230), 120)},
    focus_panel = Color(205, 230, 245),
    hover = Color(100, 170, 230, 80),
    window_shadow = Color(60, 100, 140, 80),
    gray = Color(114, 139, 165, 200),
    text = Color(20, 35, 50)
})

lia.color.registerTheme("Teal", {
    header = Color(36, 54, 54),
    header_text = Color(109, 159, 159),
    background = Color(24, 32, 32),
    background_alpha = Color(24, 32, 32, 210),
    background_panelpopup = Color(20, 28, 28),
    button = Color(38, 66, 66),
    button_shadow = Color(18, 32, 32, 35),
    button_hovered = Color(70, 140, 140),
    category = Color(34, 62, 62),
    category_opened = Color(34, 62, 62, 0),
    theme = Color(80, 180, 180),
    maincolor = Color(80, 180, 180),
    panel = {Color(34, 62, 62), Color(38, 66, 66), Color(70, 140, 140)},
    panel_alpha = {ColorAlpha(Color(34, 62, 62), 110), ColorAlpha(Color(38, 66, 66), 110), ColorAlpha(Color(70, 140, 140), 110)},
    focus_panel = Color(48, 72, 72),
    hover = Color(80, 180, 180, 90),
    window_shadow = Color(18, 32, 32, 90),
    gray = Color(150, 180, 180, 200),
    text = Color(210, 235, 235)
})

lia.color.registerTheme("Cyberpunk", {
    header = Color(15, 15, 25),
    header_text = Color(255, 20, 147),
    background = Color(5, 5, 15),
    background_alpha = Color(5, 5, 15, 220),
    background_panelpopup = Color(10, 10, 20),
    button = Color(25, 25, 35),
    button_shadow = Color(255, 20, 147, 40),
    button_hovered = Color(255, 0, 255),
    category = Color(20, 20, 30),
    category_opened = Color(20, 20, 30, 0),
    theme = Color(255, 20, 147),
    maincolor = Color(255, 20, 147),
    panel = {Color(20, 20, 30), Color(25, 25, 35), Color(255, 20, 147)},
    panel_alpha = {ColorAlpha(Color(20, 20, 30), 120), ColorAlpha(Color(25, 25, 35), 120), ColorAlpha(Color(255, 20, 147), 120)},
    focus_panel = Color(30, 30, 40),
    hover = Color(255, 20, 147, 100),
    window_shadow = Color(0, 0, 0, 180),
    gray = Color(150, 150, 200, 220),
    text = Color(255, 255, 255)
})

lia.color.registerTheme("Sakura", {
    header = Color(255, 240, 245),
    header_text = Color(255, 182, 193),
    background = Color(255, 248, 250),
    background_alpha = Color(255, 248, 250, 200),
    background_panelpopup = Color(255, 235, 240),
    button = Color(255, 225, 235),
    button_shadow = Color(255, 182, 193, 30),
    button_hovered = Color(255, 160, 180),
    category = Color(255, 245, 248),
    category_opened = Color(255, 245, 248, 0),
    theme = Color(255, 182, 193),
    maincolor = Color(255, 182, 193),
    panel = {Color(255, 245, 248), Color(255, 225, 235), Color(255, 182, 193)},
    panel_alpha = {ColorAlpha(Color(255, 245, 248), 120), ColorAlpha(Color(255, 225, 235), 120), ColorAlpha(Color(255, 182, 193), 120)},
    focus_panel = Color(255, 235, 240),
    hover = Color(255, 182, 193, 90),
    window_shadow = Color(255, 182, 193, 50),
    gray = Color(220, 200, 210, 200),
    text = Color(80, 50, 60)
})

lia.color.registerTheme("Ocean", {
    header = Color(0, 51, 102),
    header_text = Color(51, 153, 255),
    background = Color(0, 25, 51),
    background_alpha = Color(0, 25, 51, 210),
    background_panelpopup = Color(0, 38, 76),
    button = Color(0, 76, 153),
    button_shadow = Color(0, 51, 102, 40),
    button_hovered = Color(0, 153, 255),
    category = Color(0, 64, 128),
    category_opened = Color(0, 64, 128, 0),
    theme = Color(0, 153, 255),
    maincolor = Color(0, 153, 255),
    panel = {Color(0, 64, 128), Color(0, 76, 153), Color(0, 153, 255)},
    panel_alpha = {ColorAlpha(Color(0, 64, 128), 110), ColorAlpha(Color(0, 76, 153), 110), ColorAlpha(Color(0, 153, 255), 110)},
    focus_panel = Color(0, 89, 179),
    hover = Color(0, 153, 255, 90),
    window_shadow = Color(0, 51, 102, 90),
    gray = Color(100, 150, 200, 200),
    text = Color(200, 230, 255)
})

lia.color.registerTheme("Forest", {
    header = Color(34, 139, 34),
    header_text = Color(144, 238, 144),
    background = Color(0, 50, 0),
    background_alpha = Color(0, 50, 0, 210),
    background_panelpopup = Color(0, 40, 0),
    button = Color(34, 139, 34),
    button_shadow = Color(0, 100, 0, 40),
    button_hovered = Color(50, 205, 50),
    category = Color(0, 128, 0),
    category_opened = Color(0, 128, 0, 0),
    theme = Color(50, 205, 50),
    maincolor = Color(50, 205, 50),
    panel = {Color(0, 128, 0), Color(34, 139, 34), Color(50, 205, 50)},
    panel_alpha = {ColorAlpha(Color(0, 128, 0), 110), ColorAlpha(Color(34, 139, 34), 110), ColorAlpha(Color(50, 205, 50), 110)},
    focus_panel = Color(0, 100, 0),
    hover = Color(50, 205, 50, 90),
    window_shadow = Color(0, 50, 0, 90),
    gray = Color(150, 200, 150, 200),
    text = Color(200, 255, 200)
})

lia.color.registerTheme("Sunset", {
    header = Color(255, 140, 0),
    header_text = Color(255, 215, 0),
    background = Color(139, 69, 19),
    background_alpha = Color(139, 69, 19, 210),
    background_panelpopup = Color(160, 82, 45),
    button = Color(255, 140, 0),
    button_shadow = Color(255, 69, 0, 40),
    button_hovered = Color(255, 215, 0),
    category = Color(205, 133, 63),
    category_opened = Color(205, 133, 63, 0),
    theme = Color(255, 165, 0),
    maincolor = Color(255, 165, 0),
    panel = {Color(205, 133, 63), Color(255, 140, 0), Color(255, 215, 0)},
    panel_alpha = {ColorAlpha(Color(205, 133, 63), 110), ColorAlpha(Color(255, 140, 0), 110), ColorAlpha(Color(255, 215, 0), 110)},
    focus_panel = Color(255, 99, 71),
    hover = Color(255, 215, 0, 90),
    window_shadow = Color(139, 69, 19, 90),
    gray = Color(255, 218, 185, 200),
    text = Color(255, 255, 255)
})

lia.color.registerTheme("Galaxy", {
    header = Color(25, 25, 112),
    header_text = Color(138, 43, 226),
    background = Color(0, 0, 0),
    background_alpha = Color(0, 0, 0, 230),
    background_panelpopup = Color(15, 15, 35),
    button = Color(25, 25, 112),
    button_shadow = Color(75, 0, 130, 50),
    button_hovered = Color(138, 43, 226),
    category = Color(30, 30, 80),
    category_opened = Color(30, 30, 80, 0),
    theme = Color(138, 43, 226),
    maincolor = Color(138, 43, 226),
    panel = {Color(30, 30, 80), Color(25, 25, 112), Color(138, 43, 226)},
    panel_alpha = {ColorAlpha(Color(30, 30, 80), 120), ColorAlpha(Color(25, 25, 112), 120), ColorAlpha(Color(138, 43, 226), 120)},
    focus_panel = Color(40, 40, 120),
    hover = Color(138, 43, 226, 100),
    window_shadow = Color(0, 0, 0, 200),
    gray = Color(150, 150, 200, 220),
    text = Color(255, 255, 255)
})

lia.color.registerTheme("Vintage", {
    header = Color(139, 115, 85),
    header_text = Color(210, 180, 140),
    background = Color(245, 245, 220),
    background_alpha = Color(245, 245, 220, 190),
    background_panelpopup = Color(222, 184, 135),
    button = Color(160, 130, 98),
    button_shadow = Color(139, 115, 85, 30),
    button_hovered = Color(210, 180, 140),
    category = Color(205, 170, 125),
    category_opened = Color(205, 170, 125, 0),
    theme = Color(210, 180, 140),
    maincolor = Color(210, 180, 140),
    panel = {Color(205, 170, 125), Color(160, 130, 98), Color(210, 180, 140)},
    panel_alpha = {ColorAlpha(Color(205, 170, 125), 100), ColorAlpha(Color(160, 130, 98), 100), ColorAlpha(Color(210, 180, 140), 100)},
    focus_panel = Color(188, 143, 143),
    hover = Color(210, 180, 140, 80),
    window_shadow = Color(139, 115, 85, 60),
    gray = Color(169, 169, 169, 180),
    text = Color(47, 79, 79)
})

lia.color.registerTheme("Neon", {
    header = Color(0, 0, 0),
    header_text = Color(255, 255, 0),
    background = Color(0, 0, 0),
    background_alpha = Color(0, 0, 0, 240),
    background_panelpopup = Color(10, 10, 10),
    button = Color(0, 0, 0),
    button_shadow = Color(255, 255, 0, 60),
    button_hovered = Color(255, 0, 255),
    category = Color(20, 20, 20),
    category_opened = Color(20, 20, 20, 0),
    theme = Color(0, 255, 255),
    maincolor = Color(0, 255, 255),
    panel = {Color(20, 20, 20), Color(0, 0, 0), Color(255, 0, 255)},
    panel_alpha = {ColorAlpha(Color(20, 20, 20), 140), ColorAlpha(Color(0, 0, 0), 140), ColorAlpha(Color(255, 0, 255), 140)},
    focus_panel = Color(30, 30, 30),
    hover = Color(0, 255, 255, 120),
    window_shadow = Color(0, 0, 0, 220),
    gray = Color(128, 128, 128, 240),
    text = Color(255, 255, 255)
})

lia.color.registerTheme("Minimal", {
    header = Color(240, 240, 240),
    header_text = Color(120, 120, 120),
    background = Color(255, 255, 255),
    background_alpha = Color(255, 255, 255, 180),
    background_panelpopup = Color(248, 248, 248),
    button = Color(245, 245, 245),
    button_shadow = Color(220, 220, 220, 20),
    button_hovered = Color(230, 230, 230),
    category = Color(250, 250, 250),
    category_opened = Color(250, 250, 250, 0),
    theme = Color(160, 160, 160),
    maincolor = Color(160, 160, 160),
    panel = {Color(250, 250, 250), Color(245, 245, 245), Color(230, 230, 230)},
    panel_alpha = {ColorAlpha(Color(250, 250, 250), 100), ColorAlpha(Color(245, 245, 245), 100), ColorAlpha(Color(230, 230, 230), 100)},
    focus_panel = Color(245, 245, 245),
    hover = Color(235, 235, 235),
    window_shadow = Color(200, 200, 200, 40),
    gray = Color(180, 180, 180, 200),
    text = Color(60, 60, 60)
})

lia.color.registerTheme("Aurora", {
    header = Color(0, 100, 100),
    header_text = Color(0, 255, 255),
    background = Color(0, 50, 50),
    background_alpha = Color(0, 50, 50, 210),
    background_panelpopup = Color(0, 75, 75),
    button = Color(0, 128, 128),
    button_shadow = Color(0, 100, 100, 40),
    button_hovered = Color(0, 255, 255),
    category = Color(0, 90, 90),
    category_opened = Color(0, 90, 90, 0),
    theme = Color(0, 255, 127),
    maincolor = Color(0, 255, 127),
    panel = {Color(0, 90, 90), Color(0, 128, 128), Color(0, 255, 127)},
    panel_alpha = {ColorAlpha(Color(0, 90, 90), 110), ColorAlpha(Color(0, 128, 128), 110), ColorAlpha(Color(0, 255, 127), 110)},
    focus_panel = Color(0, 120, 120),
    hover = Color(0, 255, 127, 90),
    window_shadow = Color(0, 50, 50, 90),
    gray = Color(100, 200, 200, 200),
    text = Color(200, 255, 255)
})

lia.color.registerTheme("Desert", {
    header = Color(255, 218, 185),
    header_text = Color(139, 69, 19),
    background = Color(245, 222, 179),
    background_alpha = Color(245, 222, 179, 200),
    background_panelpopup = Color(250, 240, 230),
    button = Color(255, 235, 205),
    button_shadow = Color(255, 218, 185, 30),
    button_hovered = Color(255, 228, 196),
    category = Color(255, 239, 213),
    category_opened = Color(255, 239, 213, 0),
    theme = Color(255, 228, 196),
    maincolor = Color(255, 228, 196),
    panel = {Color(255, 239, 213), Color(255, 235, 205), Color(255, 228, 196)},
    panel_alpha = {ColorAlpha(Color(255, 239, 213), 120), ColorAlpha(Color(255, 235, 205), 120), ColorAlpha(Color(255, 228, 196), 120)},
    focus_panel = Color(255, 231, 186),
    hover = Color(255, 218, 185, 80),
    window_shadow = Color(139, 69, 19, 60),
    gray = Color(210, 180, 140, 200),
    text = Color(139, 69, 19)
})

lia.color.registerTheme("Storm", {
    header = Color(47, 79, 79),
    header_text = Color(119, 136, 153),
    background = Color(25, 25, 25),
    background_alpha = Color(25, 25, 25, 220),
    background_panelpopup = Color(35, 35, 35),
    button = Color(54, 54, 54),
    button_shadow = Color(47, 79, 79, 40),
    button_hovered = Color(119, 136, 153),
    category = Color(40, 40, 40),
    category_opened = Color(40, 40, 40, 0),
    theme = Color(119, 136, 153),
    maincolor = Color(119, 136, 153),
    panel = {Color(40, 40, 40), Color(54, 54, 54), Color(119, 136, 153)},
    panel_alpha = {ColorAlpha(Color(40, 40, 40), 120), ColorAlpha(Color(54, 54, 54), 120), ColorAlpha(Color(119, 136, 153), 120)},
    focus_panel = Color(60, 60, 60),
    hover = Color(119, 136, 153, 100),
    window_shadow = Color(25, 25, 25, 150),
    gray = Color(150, 150, 150, 220),
    text = Color(220, 220, 220)
})

lia.color.registerTheme("Emerald", {
    header = Color(0, 100, 0),
    header_text = Color(144, 238, 144),
    background = Color(0, 50, 0),
    background_alpha = Color(0, 50, 0, 210),
    background_panelpopup = Color(0, 75, 0),
    button = Color(0, 128, 0),
    button_shadow = Color(0, 100, 0, 40),
    button_hovered = Color(50, 205, 50),
    category = Color(0, 90, 0),
    category_opened = Color(0, 90, 0, 0),
    theme = Color(0, 201, 87),
    maincolor = Color(0, 201, 87),
    panel = {Color(0, 90, 0), Color(0, 128, 0), Color(50, 205, 50)},
    panel_alpha = {ColorAlpha(Color(0, 90, 0), 110), ColorAlpha(Color(0, 128, 0), 110), ColorAlpha(Color(50, 205, 50), 110)},
    focus_panel = Color(0, 120, 0),
    hover = Color(0, 201, 87, 90),
    window_shadow = Color(0, 50, 0, 90),
    gray = Color(100, 180, 100, 200),
    text = Color(200, 255, 200)
})

lia.color.registerTheme("Ruby", {
    header = Color(139, 0, 0),
    header_text = Color(220, 20, 60),
    background = Color(50, 0, 0),
    background_alpha = Color(50, 0, 0, 210),
    background_panelpopup = Color(75, 0, 0),
    button = Color(178, 34, 34),
    button_shadow = Color(139, 0, 0, 40),
    button_hovered = Color(220, 20, 60),
    category = Color(128, 0, 0),
    category_opened = Color(128, 0, 0, 0),
    theme = Color(220, 20, 60),
    maincolor = Color(220, 20, 60),
    panel = {Color(128, 0, 0), Color(178, 34, 34), Color(220, 20, 60)},
    panel_alpha = {ColorAlpha(Color(128, 0, 0), 110), ColorAlpha(Color(178, 34, 34), 110), ColorAlpha(Color(220, 20, 60), 110)},
    focus_panel = Color(150, 0, 0),
    hover = Color(220, 20, 60, 90),
    window_shadow = Color(50, 0, 0, 90),
    gray = Color(200, 150, 150, 200),
    text = Color(255, 240, 245)
})

lia.color.registerTheme("Sapphire", {
    header = Color(15, 82, 186),
    header_text = Color(135, 206, 250),
    background = Color(0, 35, 102),
    background_alpha = Color(0, 35, 102, 210),
    background_panelpopup = Color(0, 50, 150),
    button = Color(30, 144, 255),
    button_shadow = Color(15, 82, 186, 40),
    button_hovered = Color(135, 206, 250),
    category = Color(25, 112, 219),
    category_opened = Color(25, 112, 219, 0),
    theme = Color(0, 191, 255),
    maincolor = Color(0, 191, 255),
    panel = {Color(25, 112, 219), Color(30, 144, 255), Color(135, 206, 250)},
    panel_alpha = {ColorAlpha(Color(25, 112, 219), 110), ColorAlpha(Color(30, 144, 255), 110), ColorAlpha(Color(135, 206, 250), 110)},
    focus_panel = Color(40, 150, 255),
    hover = Color(0, 191, 255, 90),
    window_shadow = Color(0, 35, 102, 90),
    gray = Color(150, 180, 220, 200),
    text = Color(240, 248, 255)
})

lia.color.registerTheme("Gold", {
    header = Color(255, 215, 0),
    header_text = Color(184, 134, 11),
    background = Color(255, 240, 200),
    background_alpha = Color(255, 240, 200, 200),
    background_panelpopup = Color(255, 248, 220),
    button = Color(255, 235, 59),
    button_shadow = Color(255, 215, 0, 30),
    button_hovered = Color(255, 223, 0),
    category = Color(255, 239, 153),
    category_opened = Color(255, 239, 153, 0),
    theme = Color(255, 223, 0),
    maincolor = Color(255, 223, 0),
    panel = {Color(255, 239, 153), Color(255, 235, 59), Color(255, 223, 0)},
    panel_alpha = {ColorAlpha(Color(255, 239, 153), 120), ColorAlpha(Color(255, 235, 59), 120), ColorAlpha(Color(255, 223, 0), 120)},
    focus_panel = Color(255, 228, 0),
    hover = Color(255, 215, 0, 80),
    window_shadow = Color(255, 140, 0, 60),
    gray = Color(218, 165, 32, 200),
    text = Color(139, 69, 19)
})

lia.color.registerTheme("Mint", {
    header = Color(152, 255, 152),
    header_text = Color(0, 100, 0),
    background = Color(240, 255, 240),
    background_alpha = Color(240, 255, 240, 190),
    background_panelpopup = Color(245, 255, 245),
    button = Color(224, 255, 224),
    button_shadow = Color(152, 255, 152, 30),
    button_hovered = Color(189, 252, 201),
    category = Color(240, 255, 250),
    category_opened = Color(240, 255, 250, 0),
    theme = Color(50, 205, 50),
    maincolor = Color(50, 205, 50),
    panel = {Color(240, 255, 250), Color(224, 255, 224), Color(189, 252, 201)},
    panel_alpha = {ColorAlpha(Color(240, 255, 250), 120), ColorAlpha(Color(224, 255, 224), 120), ColorAlpha(Color(189, 252, 201), 120)},
    focus_panel = Color(232, 255, 232),
    hover = Color(152, 255, 152, 80),
    window_shadow = Color(0, 128, 0, 50),
    gray = Color(128, 128, 128, 180),
    text = Color(0, 50, 0)
})

lia.color.registerTheme("Lavender", {
    header = Color(230, 230, 250),
    header_text = Color(138, 43, 226),
    background = Color(248, 248, 255),
    background_alpha = Color(248, 248, 255, 190),
    background_panelpopup = Color(245, 245, 255),
    button = Color(230, 230, 250),
    button_shadow = Color(230, 230, 250, 30),
    button_hovered = Color(221, 160, 221),
    category = Color(240, 240, 255),
    category_opened = Color(240, 240, 255, 0),
    theme = Color(186, 85, 211),
    maincolor = Color(186, 85, 211),
    panel = {Color(240, 240, 255), Color(230, 230, 250), Color(221, 160, 221)},
    panel_alpha = {ColorAlpha(Color(240, 240, 255), 120), ColorAlpha(Color(230, 230, 250), 120), ColorAlpha(Color(221, 160, 221), 120)},
    focus_panel = Color(235, 235, 255),
    hover = Color(230, 230, 250, 80),
    window_shadow = Color(138, 43, 226, 50),
    gray = Color(169, 169, 169, 180),
    text = Color(72, 61, 139)
})

lia.option.add("theme", "theme", "themeDesc", "Teal", function(oldValue, newValue) if CLIENT then lia.color.applyTheme(newValue, true) end end, {
    category = "categoryVisuals",
    type = "Table",
    options = function() return lia.color.getAllThemes() end
})

lia.config.add("forceTheme", "forceTheme", true, nil, {
    desc = "forceThemeDesc",
    category = "categoryVisuals",
    type = "Boolean"
})

lia.config.add("Theme", "theme", "Teal", function(_, newValue) if CLIENT then lia.color.applyTheme(newValue, true) end end, {
    desc = "themeDesc",
    category = "categoryVisuals",
    type = "Table",
    options = lia.color.getAllThemes()
})