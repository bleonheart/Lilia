# Fonts Library

This page documents the functions for working with custom fonts and text rendering.

---

## Overview

The fonts library (`lia.font`) provides a comprehensive system for managing custom fonts, font registration, and text rendering in the Lilia framework, enabling rich typography and visual customization throughout the user interface. This library handles advanced font management with support for multiple font formats, automatic font loading from various sources including local files and web resources, and intelligent caching systems to optimize memory usage and loading performance. The system features sophisticated font registration mechanisms with support for font families, weight variations, style options, and fallback font chains to ensure consistent text rendering across different client configurations. It includes comprehensive text rendering functionality with support for advanced typography features including kerning, ligatures, text effects, and multi-language character support. The library provides integration with the framework's UI system, offering scalable font rendering that adapts to different screen resolutions and accessibility needs. Additional features include font validation and error handling, automatic font fallback systems, and performance monitoring tools for text rendering operations, making it essential for creating polished and professional user interfaces that enhance the overall player experience.

---

### lia.font.register

**Purpose**

Registers a new font with the font system.

**Parameters**

* `fontName` (*string*): The name of the font.
* `fontData` (*table*): The font data table containing font, size, weight, etc.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Register a basic font
lia.font.register("MyFont", {
    font = "Arial",
    size = 16,
    weight = 500
})

-- Register a font with more options
lia.font.register("CustomFont", {
    font = "Roboto",
    size = 24,
    weight = 700,
    antialias = true,
    outline = true,
    shadow = true
})

-- Register a font with custom properties
lia.font.register("TitleFont", {
    font = "Impact",
    size = 32,
    weight = 900,
    antialias = true,
    outline = true,
    outlineSize = 2,
    shadow = true,
    shadowOffset = 2
})

-- Use in a function
local function createFont(name, font, size, weight)
    lia.font.register(name, {
        font = font,
        size = size,
        weight = weight or 500
    })
    print("Font registered: " .. name)
end
```

---

### lia.font.getAvailableFonts

**Purpose**

Gets a list of all available fonts.

**Parameters**

*None*

**Returns**

* `fonts` (*table*): Table of available font names.

**Realm**

Client.

**Example Usage**

```lua
-- Get available fonts
local function getAvailableFonts()
    return lia.font.getAvailableFonts()
end

-- Use in a function
local function showAvailableFonts()
    local fonts = lia.font.getAvailableFonts()
    print("Available fonts:")
    for _, font in ipairs(fonts) do
        print("- " .. font)
    end
end

-- Use in a function
local function getFontCount()
    local fonts = lia.font.getAvailableFonts()
    return #fonts
end

-- Use in a function
local function checkFontExists(fontName)
    local fonts = lia.font.getAvailableFonts()
    for _, font in ipairs(fonts) do
        if font == fontName then
            return true
        end
    end
    return false
end
```

---

### lia.font.refresh

**Purpose**

Refreshes the font system and reloads all fonts.

**Parameters**

*None*

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Refresh font system
local function refreshFonts()
    lia.font.refresh()
    print("Font system refreshed")
end

-- Use in a function
local function reloadFonts()
    lia.font.refresh()
    print("All fonts reloaded")
end

-- Use in a function
local function resetFontSystem()
    lia.font.refresh()
    print("Font system reset")
end

-- Use in a command
lia.command.add("refreshfonts", {
    onRun = function(client, arguments)
        lia.font.refresh()
        client:notify("Font system refreshed")
    end
})
```








---

### lia.font.getWidth

**Purpose**

Gets the width of text in a font.

**Parameters**

* `text` (*string*): The text to measure.
* `fontName` (*string*): The name of the font.

**Returns**

* `width` (*number*): The text width.

**Realm**

Client.

**Example Usage**

```lua
-- Get text width
local function getTextWidth(text, fontName)
    return lia.font.getWidth(text, fontName)
end

-- Use in a function
local function centerTextHorizontally(text, fontName, x, width)
    local textWidth = lia.font.getWidth(text, fontName)
    local centerX = x + (width - textWidth) / 2
    return centerX
end

-- Use in a function
local function wrapText(text, fontName, maxWidth)
    local words = string.Explode(" ", text)
    local lines = {}
    local currentLine = ""
    
    for _, word in ipairs(words) do
        local testLine = currentLine .. (currentLine == "" and "" or " ") .. word
        local width = lia.font.getWidth(testLine, fontName)
        
        if width > maxWidth then
            table.insert(lines, currentLine)
            currentLine = word
        else
            currentLine = testLine
        end
    end
    
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end
    
    return lines
end

-- Use in a function
local function truncateText(text, fontName, maxWidth)
    local width = lia.font.getWidth(text, fontName)
    if width <= maxWidth then
        return text
    end
    
    local truncated = text
    while lia.font.getWidth(truncated .. "...", fontName) > maxWidth and #truncated > 0 do
        truncated = string.sub(truncated, 1, -2)
    end
    
    return truncated .. "..."
end
```

---

### lia.font.draw

**Purpose**

Draws text using a specific font.

**Parameters**

* `text` (*string*): The text to draw.
* `fontName` (*string*): The name of the font.
* `x` (*number*): The x position.
* `y` (*number*): The y position.
* `color` (*Color*): The text color.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw text with font
local function drawText(text, fontName, x, y, color)
    lia.font.draw(text, fontName, x, y, color)
end

-- Use in a function
local function drawCenteredText(text, fontName, x, y, color)
    local width = lia.font.getWidth(text, fontName)
    local height = lia.font.getHeight(fontName)
    lia.font.draw(text, fontName, x - width / 2, y - height / 2, color)
end

-- Use in a function
local function drawOutlinedText(text, fontName, x, y, color, outlineColor)
    lia.font.draw(text, fontName, x, y, color)
    lia.font.draw(text, fontName, x + 1, y, outlineColor)
    lia.font.draw(text, fontName, x - 1, y, outlineColor)
    lia.font.draw(text, fontName, x, y + 1, outlineColor)
    lia.font.draw(text, fontName, x, y - 1, outlineColor)
end

-- Use in a function
local function drawShadowedText(text, fontName, x, y, color, shadowColor)
    lia.font.draw(text, fontName, x + 2, y + 2, shadowColor)
    lia.font.draw(text, fontName, x, y, color)
end
```