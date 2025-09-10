# Color Library

This page documents the functions for working with colors and color management.

---

## Overview

The color library (`lia.color`) provides a comprehensive color management system for the Lilia framework. It handles color registration, color adjustments, predefined color palettes, and integration with the global Color function. The library includes a vast collection of predefined colors and utilities for color manipulation and theme generation.

---

### lia.color.register

**Purpose**

Registers a new color with a name for easy access and string-based color creation.

**Parameters**

* `name` (*string*): The name to register the color under.
* `color` (*table*): Color data table containing RGB values {r, g, b} or {r, g, b, a}.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic color
lia.color.register("myRed", {255, 0, 0})

-- Register a color with alpha
lia.color.register("myTransparent", {255, 0, 0, 128})

-- Register a custom color
lia.color.register("brandBlue", {52, 152, 219})

-- Register multiple colors
local colors = {
    primary = {41, 128, 185},
    secondary = {52, 73, 94},
    accent = {230, 126, 34},
    success = {39, 174, 96},
    warning = {241, 196, 15},
    danger = {231, 76, 60}
}

for name, color in pairs(colors) do
    lia.color.register(name, color)
end

-- Register colors for UI themes
lia.color.register("themeDark", {44, 62, 80})
lia.color.register("themeLight", {236, 240, 241})
lia.color.register("themeAccent", {52, 152, 219})
```

---

### lia.color.Adjust

**Purpose**

Adjusts a color by adding or subtracting RGB values with clamping.

**Parameters**

* `color` (*Color*): The base color to adjust.
* `rOffset` (*number*): Red channel offset.
* `gOffset` (*number*): Green channel offset.
* `bOffset` (*number*): Blue channel offset.
* `aOffset` (*number*): Alpha channel offset (optional).

**Returns**

* `adjustedColor` (*Color*): The adjusted color with clamped values.

**Realm**

Shared.

**Example Usage**

```lua
-- Adjust a color to be darker
local baseColor = Color(100, 150, 200)
local darkerColor = lia.color.Adjust(baseColor, -20, -20, -20)
print("Darker color: " .. tostring(darkerColor))

-- Adjust a color to be lighter
local lighterColor = lia.color.Adjust(baseColor, 50, 50, 50)
print("Lighter color: " .. tostring(lighterColor))

-- Adjust with alpha
local transparentColor = lia.color.Adjust(baseColor, 0, 0, 0, -100)
print("Transparent color: " .. tostring(transparentColor))

-- Create color variations
local baseColor = Color(255, 100, 100)
local variations = {
    darker = lia.color.Adjust(baseColor, -50, -50, -50),
    lighter = lia.color.Adjust(baseColor, 50, 50, 50),
    moreRed = lia.color.Adjust(baseColor, 50, -25, -25),
    moreBlue = lia.color.Adjust(baseColor, -25, -25, 50)
}

-- Adjust color for hover effects
local normalColor = Color(100, 100, 100)
local hoverColor = lia.color.Adjust(normalColor, 20, 20, 20)
local pressedColor = lia.color.Adjust(normalColor, -20, -20, -20)
```

---

### lia.color.ReturnMainAdjustedColors

**Purpose**

Returns a table of main UI colors adjusted from the base configuration color.

**Parameters**

*None*

**Returns**

* `colors` (*table*): Table containing adjusted color values:
  * `background` (*Color*): Background color.
  * `sidebar` (*Color*): Sidebar color.
  * `accent` (*Color*): Accent color.
  * `text` (*Color*): Text color.
  * `hover` (*Color*): Hover color.
  * `border` (*Color*): Border color.
  * `highlight` (*Color*): Highlight color.

**Realm**

Shared.

**Example Usage**

```lua
-- Get main adjusted colors
local colors = lia.color.ReturnMainAdjustedColors()

-- Use colors in UI
local function drawUI()
    local colors = lia.color.ReturnMainAdjustedColors()
    
    -- Draw background
    draw.RoundedBox(8, 10, 10, 200, 150, colors.background)
    
    -- Draw sidebar
    draw.RoundedBox(8, 10, 10, 50, 150, colors.sidebar)
    
    -- Draw text
    draw.SimpleText("UI Text", "DermaDefault", 60, 20, colors.text)
    
    -- Draw accent
    draw.RoundedBox(4, 60, 40, 100, 20, colors.accent)
    
    -- Draw border
    draw.RoundedBox(8, 10, 10, 200, 150, Color(0, 0, 0, 0))
    draw.RoundedBox(8, 10, 10, 200, 150, colors.border)
end

-- Use in hook
hook.Add("HUDPaint", "DrawCustomUI", function()
    local colors = lia.color.ReturnMainAdjustedColors()
    
    -- Draw custom UI elements
    draw.RoundedBox(4, 10, 10, 100, 30, colors.background)
    draw.SimpleText("Custom UI", "DermaDefault", 15, 20, colors.text)
end)

-- Create theme-based UI
local function createThemedPanel(parent)
    local colors = lia.color.ReturnMainAdjustedColors()
    
    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, colors.background)
        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 0))
        draw.RoundedBox(4, 0, 0, w, h, colors.border)
    end
    
    return panel
end
```