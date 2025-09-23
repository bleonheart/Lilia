lia.color = lia.color or {}
lia.color.theme = lia.color.theme or {}
lia.color.stored = lia.color.stored or {}
local clamp = math.Clamp
local configGet = lia.config.get
local unpack = unpack
function lia.color.register(name, color)
    lia.color.stored[name:lower()] = color
end

function lia.color.Adjust(color, rOffset, gOffset, bOffset, aOffset)
    return Color(clamp(color.r + rOffset, 0, 255), clamp(color.g + gOffset, 0, 255), clamp(color.b + bOffset, 0, 255), clamp((color.a or 255) + (aOffset or 0), 0, 255))
end

function lia.color.ReturnMainAdjustedColors()
    local base = configGet("Color")
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

lia.color.register("black", {0, 0, 0})
lia.color.register("white", {255, 255, 255})
lia.color.register("gray", {128, 128, 128})
lia.color.register("dark_gray", {64, 64, 64})
lia.color.register("light_gray", {192, 192, 192})
lia.color.register("red", {255, 0, 0})
lia.color.register("dark_red", {139, 0, 0})
lia.color.register("light_red", {255, 99, 71})
lia.color.register("green", {0, 255, 0})
lia.color.register("dark_green", {0, 100, 0})
lia.color.register("light_green", {144, 238, 144})
lia.color.register("blue", {0, 0, 255})
lia.color.register("dark_blue", {0, 0, 139})
lia.color.register("light_blue", {173, 216, 230})
lia.color.register("cyan", {0, 255, 255})
lia.color.register("dark_cyan", {0, 139, 139})
lia.color.register("magenta", {255, 0, 255})
lia.color.register("dark_magenta", {139, 0, 139})
lia.color.register("yellow", {255, 255, 0})
lia.color.register("dark_yellow", {139, 139, 0})
lia.color.register("orange", {255, 165, 0})
lia.color.register("dark_orange", {255, 140, 0})
lia.color.register("purple", {128, 0, 128})
lia.color.register("dark_purple", {75, 0, 130})
lia.color.register("pink", {255, 192, 203})
lia.color.register("dark_pink", {199, 21, 133})
lia.color.register("brown", {165, 42, 42})
lia.color.register("dark_brown", {139, 69, 19})
lia.color.register("maroon", {128, 0, 0})
lia.color.register("dark_maroon", {139, 28, 98})
lia.color.register("navy", {0, 0, 128})
lia.color.register("dark_navy", {0, 0, 139})
lia.color.register("olive", {128, 128, 0})
lia.color.register("dark_olive", {85, 107, 47})
lia.color.register("teal", {0, 128, 128})
lia.color.register("dark_teal", {0, 105, 105})
lia.color.register("peach", {255, 218, 185})
lia.color.register("dark_peach", {255, 218, 185})
lia.color.register("lavender", {230, 230, 250})
lia.color.register("dark_lavender", {148, 0, 211})
lia.color.register("aqua", {0, 255, 255})
lia.color.register("dark_aqua", {0, 206, 209})
lia.color.register("beige", {245, 245, 220})
lia.color.register("dark_beige", {139, 131, 120})
lia.color.register("aquamarine", {127, 255, 212})
lia.color.register("bisque", {255, 228, 196})
lia.color.register("blanched_almond", {255, 235, 205})
lia.color.register("blue_violet", {138, 43, 226})
lia.color.register("burlywood", {222, 184, 135})
lia.color.register("cadet_blue", {95, 158, 160})
lia.color.register("chartreuse", {127, 255, 0})
lia.color.register("chocolate", {210, 105, 30})
lia.color.register("coral", {255, 127, 80})
lia.color.register("cornflower_blue", {100, 149, 237})
lia.color.register("cornsilk", {255, 248, 220})
lia.color.register("crimson", {220, 20, 60})
lia.color.register("dark_goldenrod", {184, 134, 11})
lia.color.register("dark_khaki", {189, 183, 107})
lia.color.register("dark_orchid", {153, 50, 204})
lia.color.register("dark_salmon", {233, 150, 122})
lia.color.register("deep_pink", {255, 20, 147})
lia.color.register("deep_sky_blue", {0, 191, 255})
lia.color.register("dodger_blue", {30, 144, 255})
lia.color.register("fire_brick", {178, 34, 34})
lia.color.register("forest_green", {34, 139, 34})
lia.color.register("gainsboro", {220, 220, 220})
lia.color.register("ghost_white", {248, 248, 255})
lia.color.register("gold", {255, 215, 0})
lia.color.register("goldenrod", {218, 165, 32})
lia.color.register("green_yellow", {173, 255, 47})
lia.color.register("hot_pink", {255, 105, 180})
lia.color.register("indian_red", {205, 92, 92})
lia.color.register("indigo", {75, 0, 130})
lia.color.register("ivory", {255, 255, 240})
lia.color.register("khaki", {240, 230, 140})
lia.color.register("lavender_blush", {255, 240, 245})
lia.color.register("lawn_green", {124, 252, 0})
lia.color.register("lemon_chiffon", {255, 250, 205})
lia.color.register("light_coral", {240, 128, 128})
lia.color.register("light_goldenrod_yellow", {250, 250, 210})
lia.color.register("light_pink", {255, 182, 193})
lia.color.register("light_sea_green", {32, 178, 170})
lia.color.register("light_sky_blue", {135, 206, 250})
lia.color.register("light_slate_gray", {119, 136, 153})
lia.color.register("light_steel_blue", {176, 196, 222})
lia.color.register("lime", {0, 255, 0})
lia.color.register("lime_green", {50, 205, 50})
lia.color.register("linen", {250, 240, 230})
lia.color.register("medium_aquamarine", {102, 205, 170})
lia.color.register("medium_blue", {0, 0, 205})
lia.color.register("medium_orchid", {186, 85, 211})
lia.color.register("medium_purple", {147, 112, 219})
lia.color.register("medium_sea_green", {60, 179, 113})
lia.color.register("medium_slate_blue", {123, 104, 238})
lia.color.register("medium_spring_green", {0, 250, 154})
lia.color.register("medium_turquoise", {72, 209, 204})
lia.color.register("medium_violet_red", {199, 21, 133})
lia.color.register("midnight_blue", {25, 25, 112})
lia.color.register("mint_cream", {245, 255, 250})
lia.color.register("misty_rose", {255, 228, 225})
lia.color.register("moccasin", {255, 228, 181})
lia.color.register("navajo_white", {255, 222, 173})
lia.color.register("old_lace", {253, 245, 230})
lia.color.register("olive_drab", {107, 142, 35})
lia.color.register("orange_red", {255, 69, 0})
lia.color.register("orchid", {218, 112, 214})
lia.color.register("pale_goldenrod", {238, 232, 170})
lia.color.register("pale_green", {152, 251, 152})
lia.color.register("pale_turquoise", {175, 238, 238})
lia.color.register("pale_violet_red", {219, 112, 147})
lia.color.register("papaya_whip", {255, 239, 213})
lia.color.register("peach_puff", {255, 218, 185})
lia.color.register("peru", {205, 133, 63})
lia.color.register("plum", {221, 160, 221})
lia.color.register("powder_blue", {176, 224, 230})
lia.color.register("rosy_brown", {188, 143, 143})
lia.color.register("royal_blue", {65, 105, 225})
lia.color.register("saddle_brown", {139, 69, 19})
lia.color.register("salmon", {250, 128, 114})
lia.color.register("sandy_brown", {244, 164, 96})
lia.color.register("sea_green", {46, 139, 87})
lia.color.register("sea_shell", {255, 245, 238})
lia.color.register("sienna", {160, 82, 45})
lia.color.register("sky_blue", {135, 206, 235})
lia.color.register("slate_blue", {106, 90, 205})
lia.color.register("slate_gray", {112, 128, 144})
lia.color.register("snow", {255, 250, 250})
lia.color.register("spring_green", {0, 255, 127})
lia.color.register("steel_blue", {70, 130, 180})
lia.color.register("tan", {210, 180, 140})
lia.color.register("thistle", {216, 191, 216})
lia.color.register("tomato", {255, 99, 71})
lia.color.register("turquoise", {64, 224, 208})
lia.color.register("violet", {238, 130, 238})
lia.color.register("wheat", {245, 222, 179})
lia.color.register("white_smoke", {245, 245, 245})
lia.color.register("yellow_green", {154, 205, 50})
lia.color.theme.dark = {
    header = Color(40, 40, 40),
    header_text = Color(100, 100, 100),
    background = Color(25, 25, 25),
    background_alpha = Color(25, 25, 25, 210),
    background_panelpopup = Color(20, 20, 20, 150),
    button = Color(54, 54, 54),
    button_shadow = Color(0, 0, 0, 25),
    button_hovered = Color(60, 60, 62),
    category = Color(50, 50, 50),
    category_opened = Color(50, 50, 50, 0),
    theme = Color(106, 108, 197),
    panel = {Color(60, 60, 60), Color(50, 50, 50), Color(80, 80, 80)},
    panel_alpha = {},
    toggle = Color(56, 56, 56),
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(150, 150, 150, 220),
    text = Color(255, 255, 255)
}

lia.color.theme.light = {
    header = Color(240, 240, 240),
    header_text = Color(150, 150, 150),
    background = Color(255, 255, 255),
    background_alpha = Color(255, 255, 255, 170),
    background_panelpopup = Color(245, 245, 245, 150),
    button = Color(235, 235, 235),
    button_shadow = Color(0, 0, 0, 15),
    button_hovered = Color(196, 199, 218),
    category = Color(240, 240, 245),
    category_opened = Color(240, 240, 245, 0),
    theme = Color(106, 108, 197),
    panel = {Color(250, 250, 255), Color(240, 240, 245), Color(230, 230, 235)},
    panel_alpha = {},
    toggle = Color(220, 220, 230),
    focus_panel = Color(245, 245, 255),
    hover = Color(235, 240, 255),
    window_shadow = Color(0, 0, 0, 50),
    gray = Color(130, 130, 130, 220),
    text = Color(20, 20, 20)
}


lia.color.theme.blue = {
    header = Color(36, 48, 66),
    header_text = Color(109, 129, 159),
    background = Color(24, 28, 38),
    background_alpha = Color(24, 28, 38, 210),
    background_panelpopup = Color(20, 24, 32, 150),
    button = Color(38, 54, 82),
    button_shadow = Color(18, 22, 32, 35),
    button_hovered = Color(47, 69, 110),
    category = Color(34, 48, 72),
    category_opened = Color(34, 48, 72, 0),
    theme = Color(80, 160, 220),
    panel = {Color(34, 48, 72), Color(38, 54, 82), Color(70, 120, 180)},
    panel_alpha = {},
    toggle = Color(34, 44, 66),
    focus_panel = Color(48, 72, 90),
    hover = Color(80, 160, 220, 90),
    window_shadow = Color(18, 22, 32, 100),
    gray = Color(150, 170, 190, 200),
    text = Color(210, 220, 235)
}

lia.color.theme.red = {
    header = Color(54, 36, 36),
    header_text = Color(159, 109, 109),
    background = Color(32, 24, 24),
    background_alpha = Color(32, 24, 24, 210),
    background_panelpopup = Color(28, 20, 20, 150),
    button = Color(66, 38, 38),
    button_shadow = Color(32, 18, 18, 35),
    button_hovered = Color(97, 50, 50),
    category = Color(62, 34, 34),
    category_opened = Color(62, 34, 34, 0),
    theme = Color(180, 80, 80),
    panel = {Color(62, 34, 34), Color(66, 38, 38), Color(140, 70, 70)},
    panel_alpha = {},
    toggle = Color(60, 34, 34),
    focus_panel = Color(72, 48, 48),
    hover = Color(180, 80, 80, 90),
    window_shadow = Color(32, 18, 18, 100),
    gray = Color(180, 150, 150, 200),
    text = Color(235, 210, 210)
}


lia.color.theme.green = {
    header = Color(36, 54, 40),
    header_text = Color(109, 159, 109),
    background = Color(24, 32, 26),
    background_alpha = Color(24, 32, 26, 210),
    background_panelpopup = Color(20, 28, 22, 150),
    button = Color(38, 66, 48),
    button_shadow = Color(18, 32, 22, 35),
    button_hovered = Color(48, 88, 62),
    category = Color(34, 62, 44),
    category_opened = Color(34, 62, 44, 0),
    theme = Color(80, 180, 120),
    panel = {Color(34, 62, 44), Color(38, 66, 48), Color(70, 140, 90)},
    panel_alpha = {},
    toggle = Color(34, 60, 44),
    focus_panel = Color(48, 72, 58),
    hover = Color(80, 180, 120, 90),
    window_shadow = Color(18, 32, 22, 100),
    gray = Color(150, 180, 150, 200),
    text = Color(210, 235, 210)
}


lia.color.theme.orange = {
    header = Color(70, 35, 10),
    header_text = Color(250, 230, 210),
    background = Color(255, 250, 240),
    background_alpha = Color(255, 250, 240, 220),
    background_panelpopup = Color(255, 245, 235, 160),
    button = Color(184, 122, 64),
    button_shadow = Color(20, 10, 0, 30),
    button_hovered = Color(197, 129, 65),
    category = Color(255, 245, 235),
    category_opened = Color(255, 245, 235, 0),
    theme = Color(245, 130, 50),
    panel = {Color(255, 250, 240), Color(250, 220, 180), Color(235, 150, 90)},
    panel_alpha = {},
    toggle = Color(143, 121, 104),
    focus_panel = Color(255, 240, 225),
    hover = Color(255, 165, 80, 90),
    window_shadow = Color(20, 8, 0, 100),
    gray = Color(180, 161, 150, 200),
    text = Color(45, 20, 10)
}


lia.color.theme.purple = {
    header = Color(40, 36, 56),
    header_text = Color(150, 140, 180),
    background = Color(25, 22, 30),
    background_alpha = Color(25, 22, 30, 210),
    background_panelpopup = Color(28, 24, 40, 150),
    button = Color(58, 52, 76),
    button_shadow = Color(8, 6, 20, 30),
    button_hovered = Color(74, 64, 105),
    category = Color(46, 40, 60),
    category_opened = Color(46, 40, 60, 0),
    theme = Color(138, 114, 219),
    panel = {Color(56, 48, 76), Color(44, 36, 64), Color(120, 90, 200)},
    panel_alpha = {},
    toggle = Color(43, 39, 53),
    focus_panel = Color(48, 42, 62),
    hover = Color(138, 114, 219, 90),
    window_shadow = Color(8, 6, 20, 100),
    gray = Color(140, 128, 148, 220),
    text = Color(245, 240, 255)
}


lia.color.theme.coffee = {
    header = Color(67, 48, 36),
    header_text = Color(210, 190, 170),
    background = Color(45, 32, 25),
    background_alpha = Color(45, 32, 25, 215),
    background_panelpopup = Color(38, 28, 22, 150),
    button = Color(84, 60, 45),
    button_shadow = Color(20, 10, 5, 40),
    button_hovered = Color(100, 75, 55),
    category = Color(72, 54, 42),
    category_opened = Color(72, 54, 42, 0),
    theme = Color(150, 110, 75),
    panel = {Color(68, 50, 40), Color(90, 65, 50), Color(150, 110, 75)},
    panel_alpha = {},
    toggle = Color(53, 40, 31),
    focus_panel = Color(70, 55, 40),
    hover = Color(150, 110, 75, 90),
    window_shadow = Color(15, 10, 5, 100),
    gray = Color(180, 150, 130, 200),
    text = Color(235, 225, 210)
}


lia.color.theme.ice = {
    header = Color(190, 225, 250),
    header_text = Color(68, 104, 139),
    background = Color(235, 245, 255),
    background_alpha = Color(235, 245, 255, 200),
    background_panelpopup = Color(220, 235, 245, 150),
    button = Color(145, 185, 225),
    button_shadow = Color(80, 110, 140, 40),
    button_hovered = Color(170, 210, 255),
    category = Color(200, 225, 245),
    category_opened = Color(200, 225, 245, 0),
    theme = Color(100, 170, 230),
    panel = {Color(146, 186, 211), Color(107, 157, 190), Color(74, 132, 184)},
    panel_alpha = {},
    toggle = Color(168, 194, 219),
    focus_panel = Color(205, 230, 245),
    hover = Color(100, 170, 230, 80),
    window_shadow = Color(60, 100, 140, 100),
    gray = Color(92, 112, 133, 200),
    text = Color(20, 35, 50)
}


lia.color.theme.wine = {
    header = Color(59, 42, 53),
    header_text = Color(246, 242, 246),
    background = Color(31, 23, 22),
    background_alpha = Color(31, 23, 22, 210),
    background_panelpopup = Color(36, 28, 28, 150),
    button = Color(79, 50, 60),
    button_shadow = Color(10, 6, 18, 30),
    button_hovered = Color(90, 52, 65),
    category = Color(79, 50, 60),
    category_opened = Color(79, 50, 60, 0),
    theme = Color(148, 61, 91),
    panel = {Color(79, 50, 60), Color(63, 44, 48), Color(160, 85, 143)},
    panel_alpha = {},
    toggle = Color(63, 40, 47),
    focus_panel = Color(70, 48, 58),
    hover = Color(192, 122, 217, 90),
    window_shadow = Color(10, 6, 20, 100),
    gray = Color(170, 150, 160, 200),
    text = Color(246, 242, 246)
}


lia.color.theme.violet = {
    header = Color(49, 50, 68),
    header_text = Color(238, 244, 255),
    background = Color(22, 24, 35),
    background_alpha = Color(22, 24, 35, 210),
    background_panelpopup = Color(36, 40, 56, 150),
    button = Color(58, 64, 84),
    button_shadow = Color(8, 6, 18, 30),
    button_hovered = Color(64, 74, 104),
    category = Color(58, 64, 84),
    category_opened = Color(58, 64, 84, 0),
    theme = Color(159, 180, 255),
    panel = {Color(58, 64, 84), Color(48, 52, 72), Color(109, 136, 255)},
    panel_alpha = {},
    toggle = Color(46, 51, 66),
    focus_panel = Color(56, 62, 86),
    hover = Color(159, 180, 255, 90),
    window_shadow = Color(8, 6, 20, 100),
    gray = Color(147, 147, 184, 200),
    text = Color(238, 244, 255)
}


lia.color.theme.moss = {
    header = Color(42, 50, 36),
    header_text = Color(232, 244, 235),
    background = Color(14, 16, 12),
    background_alpha = Color(14, 16, 12, 210),
    background_panelpopup = Color(24, 28, 22, 150),
    button = Color(64, 82, 60),
    button_shadow = Color(6, 8, 6, 30),
    button_hovered = Color(74, 99, 68),
    category = Color(46, 64, 44),
    category_opened = Color(46, 64, 44, 0),
    theme = Color(110, 160, 90),
    panel = {Color(40, 56, 40), Color(66, 86, 66), Color(110, 160, 90)},
    panel_alpha = {},
    toggle = Color(35, 44, 34),
    focus_panel = Color(46, 58, 44),
    hover = Color(110, 160, 90, 90),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(148, 165, 140, 220),
    text = Color(232, 244, 235)
}


lia.color.theme.coral = {
    header = Color(52, 32, 36),
    header_text = Color(255, 243, 242),
    background = Color(18, 14, 16),
    background_alpha = Color(18, 14, 16, 210),
    background_panelpopup = Color(30, 22, 24, 150),
    button = Color(116, 66, 61),
    button_shadow = Color(8, 4, 6, 30),
    button_hovered = Color(134, 73, 68),
    category = Color(74, 40, 42),
    category_opened = Color(74, 40, 42, 0),
    theme = Color(255, 120, 90),
    panel = {Color(66, 38, 40), Color(120, 60, 56), Color(240, 120, 90)},
    panel_alpha = {},
    toggle = Color(58, 39, 37),
    focus_panel = Color(72, 42, 44),
    hover = Color(255, 120, 90, 90),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(167, 136, 136, 220),
    text = Color(255, 243, 242)
}

lia.color.theme.dark_mono = table.Copy(lia.color.theme.dark)
lia.color.theme.dark_mono.theme = Color(121, 121, 121)
for themeName, theme in pairs(lia.color.theme) do
    if theme.panel then theme.panel_alpha = {ColorAlpha(theme.panel[1], 150), ColorAlpha(theme.panel[2], 150), ColorAlpha(theme.panel[3], 150)} end
end


lia.color.transition = {
    active = false,
    colors = nil
}



function lia.color.getCurrentTheme()
    local themeName = lia.option.get("colorTheme", "dark")
    return lia.color.theme[themeName] or lia.color.theme.dark
end

function lia.color.transitionTo(newTheme)
    if not lia.color.theme[newTheme] then
        print('lia.color.transitionTo: theme "' .. newTheme .. '" not found!')
        return
    end

    
    lia.color.current = table.Copy(lia.color.theme[newTheme])
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


hook.Add("LiliaLoaded", "InitializeColorTheme", function()
    
    local themeName = lia.option.get("colorTheme", "dark")
    if not lia.color.theme[themeName] then
        lia.option.set("colorTheme", "dark")
    end
end)