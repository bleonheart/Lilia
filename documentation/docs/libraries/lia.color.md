# Color Library

This page documents the functions for working with color management and manipulation.

---

## Overview

The color library (`lia.color`) provides a comprehensive system for managing colors within the Lilia framework. It includes functions for registering custom colors, adjusting color values, and generating theme-based color schemes. The library also extends the global `Color` function to support named colors and provides a wide range of predefined color definitions.

---

### lia.color.register

**Purpose**

Registers a custom color with a name for easy access.

**Parameters**

* `name` (*string*): The name to register the color under.
* `color` (*table*): A table containing RGB values `{r, g, b}` or `{r, g, b, a}`.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Register a custom color
lia.color.register("my_red", {255, 100, 100})
lia.color.register("my_blue", {100, 100, 255, 200}) -- With alpha

-- Use the registered color
local myColor = Color("my_red")
print("My red color: " .. tostring(myColor))

-- Register theme colors
lia.color.register("theme_primary", {37, 116, 108})
lia.color.register("theme_secondary", {200, 200, 200})
lia.color.register("theme_accent", {255, 165, 0})
```

---

### lia.color.Adjust

**Purpose**

Adjusts a color by adding or subtracting RGB values with clamping.

**Parameters**

* `color` (*Color*): The base color to adjust.
* `rOffset` (*number*): The red channel offset.
* `gOffset` (*number*): The green channel offset.
* `bOffset` (*number*): The blue channel offset.
* `aOffset` (*number*, *optional*): The alpha channel offset.

**Returns**

* `adjustedColor` (*Color*): The adjusted color with values clamped between 0-255.

**Realm**

Shared.

**Example Usage**

```lua
-- Adjust a color to make it darker
local baseColor = Color(100, 150, 200)
local darkerColor = lia.color.Adjust(baseColor, -20, -20, -20)
print("Darker color: " .. tostring(darkerColor))

-- Adjust a color to make it lighter
local lighterColor = lia.color.Adjust(baseColor, 30, 30, 30)
print("Lighter color: " .. tostring(lighterColor))

-- Adjust specific channels
local adjustedColor = lia.color.Adjust(baseColor, 50, -30, 0, 10)
print("Adjusted color: " .. tostring(adjustedColor))

-- Create color variations
local primaryColor = Color(255, 100, 100)
local hoverColor = lia.color.Adjust(primaryColor, 20, 20, 20)
local pressedColor = lia.color.Adjust(primaryColor, -20, -20, -20)
```

---

### lia.color.ReturnMainAdjustedColors

**Purpose**

Returns a table of theme colors adjusted from the main configuration color.

**Parameters**

* `nil`

**Returns**

* `colors` (*table*): A table containing theme colors with keys:
  * `background` (*Color*): Background color.
  * `sidebar` (*Color*): Sidebar color.
  * `accent` (*Color*): Accent color (same as main color).
  * `text` (*Color*): Text color.
  * `hover` (*Color*): Hover color.
  * `border` (*Color*): Border color.
  * `highlight` (*Color*): Highlight color.

**Realm**

Shared.

**Example Usage**

```lua
-- Get theme colors
local themeColors = lia.color.ReturnMainAdjustedColors()

-- Use theme colors in UI
local function drawThemedPanel(x, y, w, h)
    local colors = lia.color.ReturnMainAdjustedColors()
    
    -- Draw background
    surface.SetDrawColor(colors.background)
    surface.DrawRect(x, y, w, h)
    
    -- Draw border
    surface.SetDrawColor(colors.border)
    surface.DrawOutlinedRect(x, y, w, h)
    
    -- Draw text
    draw.SimpleText("Themed Panel", "DermaDefault", x + 10, y + 10, colors.text)
end

-- Use in custom UI elements
local function createThemedButton(text, x, y, w, h)
    local colors = lia.color.ReturnMainAdjustedColors()
    local button = vgui.Create("DButton")
    button:SetPos(x, y)
    button:SetSize(w, h)
    button:SetText(text)
    
    button.Paint = function(self, w, h)
        local color = self:IsHovered() and colors.hover or colors.accent
        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, w, h)
    end
    
    return button
end
```

---

### Pre-defined Colors

The color library includes a comprehensive set of predefined colors that can be accessed using the `Color` function with a string name:

**Basic Colors:**
- `black`, `white`, `gray`, `dark_gray`, `light_gray`
- `red`, `dark_red`, `light_red`
- `green`, `dark_green`, `light_green`
- `blue`, `dark_blue`, `light_blue`
- `cyan`, `dark_cyan`
- `magenta`, `dark_magenta`
- `yellow`, `dark_yellow`
- `orange`, `dark_orange`
- `purple`, `dark_purple`
- `pink`, `dark_pink`
- `brown`, `dark_brown`
- `maroon`, `dark_maroon`
- `navy`, `dark_navy`
- `olive`, `dark_olive`
- `teal`, `dark_teal`

**Extended Colors:**
- `peach`, `lavender`, `aqua`, `beige`, `aquamarine`
- `bisque`, `blanched_almond`, `blue_violet`, `burlywood`
- `cadet_blue`, `chartreuse`, `chocolate`, `coral`
- `cornflower_blue`, `cornsilk`, `crimson`, `dark_goldenrod`
- `dark_khaki`, `dark_orchid`, `dark_salmon`, `deep_pink`
- `deep_sky_blue`, `dodger_blue`, `fire_brick`, `forest_green`
- `gainsboro`, `ghost_white`, `gold`, `goldenrod`
- `green_yellow`, `hot_pink`, `indian_red`, `indigo`
- `ivory`, `khaki`, `lavender_blush`, `lawn_green`
- `lemon_chiffon`, `light_coral`, `light_goldenrod_yellow`
- `light_pink`, `light_sea_green`, `light_sky_blue`
- `light_slate_gray`, `light_steel_blue`, `lime`, `lime_green`
- `linen`, `medium_aquamarine`, `medium_blue`, `medium_orchid`
- `medium_purple`, `medium_sea_green`, `medium_slate_blue`
- `medium_spring_green`, `medium_turquoise`, `medium_violet_red`
- `midnight_blue`, `mint_cream`, `misty_rose`, `moccasin`
- `navajo_white`, `old_lace`, `olive_drab`, `orange_red`
- `orchid`, `pale_goldenrod`, `pale_green`, `pale_turquoise`
- `pale_violet_red`, `papaya_whip`, `peach_puff`, `peru`
- `plum`, `powder_blue`, `rosy_brown`, `royal_blue`
- `saddle_brown`, `salmon`, `sandy_brown`, `sea_green`
- `sea_shell`, `sienna`, `sky_blue`, `slate_blue`
- `slate_gray`, `snow`, `spring_green`, `steel_blue`
- `tan`, `thistle`, `tomato`, `turquoise`
- `violet`, `wheat`, `white_smoke`, `yellow_green`

**Example Usage:**

```lua
-- Use predefined colors
local redColor = Color("red")
local darkBlueColor = Color("dark_blue")
local customColor = Color("coral", 200) -- With custom alpha

-- Use in drawing
surface.SetDrawColor(Color("forest_green"))
surface.DrawRect(10, 10, 100, 100)

-- Use in text
draw.SimpleText("Hello World", "DermaDefault", 10, 10, Color("gold"))

-- Use in UI elements
local button = vgui.Create("DButton")
button:SetTextColor(Color("white"))
button:SetText("Click Me")
```