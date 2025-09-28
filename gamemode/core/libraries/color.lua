lia.color = lia.color or {}
lia.color.stored = lia.color.stored or {}
lia.color.themes = lia.color.themes or {}
function lia.color.register(name, color)
    lia.color.stored[name:lower()] = color
end

function lia.color.Adjust(color, rOffset, gOffset, bOffset, aOffset)
    return Color(math.Clamp(color.r + rOffset, 0, 255), math.Clamp(color.g + gOffset, 0, 255), math.Clamp(color.b + bOffset, 0, 255), math.Clamp((color.a or 255) + (aOffset or 0), 0, 255))
end

function lia.color.registerTheme(name, themeData)
    local id = name:lower()
    lia.color.themes[id] = themeData
end

function lia.color.getCurrentTheme()
    return lia.config.get("Theme", "Dark"):lower()
end

function lia.color.getCurrentThemeName()
    return lia.config.get("Theme", "Dark")
end

function lia.color.applyTheme(themeName, useTransition)
    themeName = themeName or lia.color.getCurrentTheme()
    local themeData = lia.color.themes[themeName]
    if themeData then
        if useTransition and CLIENT then
            -- Use smooth transition
            lia.color.startThemeTransition(themeName)
        else
            -- Immediate theme change
            -- Store the current theme data for easy access
            lia.color.theme = table.Copy(themeData)
        end
    end
end

function lia.color.isTransitionActive()
    return lia.color.transition.active
end

-- Test function to manually trigger theme transitions (for development)
function lia.color.testThemeTransition(themeName)
    if CLIENT then
        lia.color.applyTheme(themeName, true)
        print("Started theme transition to: " .. themeName)
    end
end

function lia.color.getAllThemes()
    local themes = {}
    for id, name in pairs(lia.color.themes) do
        themes[#themes + 1] = name
    end

    table.sort(themes)
    return themes
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
    transition.to = table.Copy(targetTheme)
    transition.active = true
    transition.progress = 0
    if not hook.GetTable().LiliaThemeTransition then
        hook.Add('Think', 'LiliaThemeTransition', function()
            if not transition.active then return end
            local dt = FrameTime()
            transition.progress = math.min(transition.progress + (transition.speed * dt), 1)
            local to = transition.to
            if not to then
                transition.active = false
                hook.Remove('Think', 'LiliaThemeTransition')
                return
            end

            -- Update lia.color.stored with interpolated values
            for k, v in pairs(to) do
                if lia.color.isColor(v) then
                    local current = lia.color.stored[k]
                    if current then
                        lia.color.stored[k] = lia.color.lerp(transition.colorBlend, current, v)
                    else
                        lia.color.stored[k] = v
                    end
                elseif type(v) == 'table' and #v > 0 then
                    if not lia.color.stored[k] then lia.color.stored[k] = {} end
                    for i = 1, #v do
                        local vi = v[i]
                        if lia.color.isColor(vi) then
                            local currentVal = lia.color.stored[k] and lia.color.stored[k][i]
                            if currentVal then
                                lia.color.stored[k][i] = lia.color.lerp(transition.colorBlend, currentVal, vi)
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

            if transition.progress >= 0.999 then
                -- Complete the transition by copying final values
                for k, v in pairs(to) do
                    lia.color.stored[k] = v
                end

                transition.active = false
                hook.Remove('Think', 'LiliaThemeTransition')
            end
        end)
    end
end

function lia.color.isColor(v)
    return type(v) == 'table' and type(v.r) == 'number'
end

function lia.color.ReturnMainAdjustedColors()
    local base = lia.config.get("Color")
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
    return Color(Lerp(ft, col1.r, col2.r), Lerp(ft, col1.g, col2.g), Lerp(ft, col1.b, col2.b), Lerp(ft, col1.a, col2.a))
end

local oldColor = Color
function Color(r, g, b, a)
    if isstring(r) then
        local c = lia.color.stored[r:lower()]
        if c then return oldColor(unpack(c), g or 255) end
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
    panel = {Color(210, 235, 250), Color(190, 220, 240), Color(100, 170, 230)},
    panel_alpha = {ColorAlpha(Color(210, 235, 250), 120), ColorAlpha(Color(190, 220, 240), 120), ColorAlpha(Color(100, 170, 230), 120)},
    focus_panel = Color(205, 230, 245),
    hover = Color(100, 170, 230, 80),
    window_shadow = Color(60, 100, 140, 80),
    gray = Color(114, 139, 165, 200),
    text = Color(20, 35, 50)
})

-- Initialize theme property
lia.color.theme = nil
lia.color.applyTheme()