# lia.fonts

## Overview
The `lia.fonts` library provides comprehensive font management for Lilia, including font registration, caching, and dynamic font creation. It handles font scaling, customization, and provides many pre-defined fonts for different UI elements.

## Functions

### lia.font.register
**Purpose**: Registers a new font with the specified name and data.

**Parameters**:
- `fontName` (string): Name of the font to register
- `fontData` (table): Font data table containing properties like font, size, weight, etc.

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Register a custom font
lia.font.register("MyCustomFont", {
    font = "Arial",
    size = 24,
    weight = 500,
    extended = true,
    antialias = true
})

-- Register a scaled font
lia.font.register("ScaledFont", {
    font = "Helvetica",
    size = ScreenScaleH(20),
    weight = 1000,
    extended = true
})

-- Register a font with specific properties
lia.font.register("BoldFont", {
    font = "Roboto",
    size = 18,
    weight = 800,
    shadow = true,
    outline = true,
    outlineSize = 2
})
```

### lia.font.getAvailableFonts
**Purpose**: Gets a list of all available registered fonts.

**Parameters**: None

**Returns**: Array of font names

**Realm**: Client

**Example Usage**:
```lua
-- Get all available fonts
local fonts = lia.font.getAvailableFonts()
print("Available fonts:")
for _, fontName in ipairs(fonts) do
    print("- " .. fontName)
end

-- Use in a dropdown menu
local fontOptions = lia.font.getAvailableFonts()
local dropdown = vgui.Create("DComboBox")
for _, fontName in ipairs(fontOptions) do
    dropdown:AddChoice(fontName)
end
```

### lia.font.refresh
**Purpose**: Refreshes all registered fonts, typically called when screen size changes or fonts need to be reloaded.

**Parameters**: None

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Refresh all fonts
lia.font.refresh()

-- Hook for screen size changes
hook.Add("OnScreenSizeChanged", "RefreshFonts", function()
    lia.font.refresh()
end)

-- Manual refresh when needed
lia.font.refresh()
hook.Run("PostLoadFonts", lia.config.get("Font"), lia.config.get("GenericFont"))
```