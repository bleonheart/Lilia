# Fonts Library

This page documents the functions for working with font management and registration.

---

## Overview

The fonts library (`lia.font`) provides a comprehensive system for font management in the Lilia framework. It handles font registration, storage, and provides utilities for managing custom fonts. The library automatically registers numerous pre-defined fonts for various UI elements and provides configuration options for customizing the font experience.

---

### lia.font.register

**Purpose**

Registers a new font with specified properties.

**Parameters**

* `fontName` (*string*): The name identifier for the font.
* `fontData` (*table*): The font data table containing properties like size, weight, etc.

**Realm**

Client.

**Example Usage**

```lua
-- Register a custom font
lia.font.register("MyCustomFont", {
    font = "Arial",
    size = 24,
    weight = 500,
    extended = true,
    antialias = true
})

-- Register a font with multiple properties
lia.font.register("TitleFont", {
    font = "Helvetica",
    size = 36,
    weight = 1000,
    extended = true,
    antialias = true,
    shadow = true,
    italic = true
})
```

### lia.font.getAvailableFonts

**Purpose**

Gets a list of all available registered fonts.

**Returns**

* `fontList` (*table*): Sorted array of font names.

**Realm**

Client.

**Example Usage**

```lua
-- Get all available fonts
local fonts = lia.font.getAvailableFonts()
print("Available fonts:")

for _, fontName in ipairs(fonts) do
    print("  - " .. fontName)
end

-- Check if a specific font exists
local hasCustomFont = table.HasValue(lia.font.getAvailableFonts(), "MyCustomFont")
if hasCustomFont then
    print("Custom font is available")
end
```

### lia.font.refresh

**Purpose**

Refreshes all registered fonts, useful when screen resolution changes.

**Realm**

Client.

**Example Usage**

```lua
-- Refresh all fonts
lia.font.refresh()
print("All fonts have been refreshed")

-- This is automatically called when screen size changes
-- or when the RefreshFonts hook is triggered
```

### lia.font.stored

**Purpose**

A table containing all stored font data for persistence and refresh operations.

**Returns**

* `storedFonts` (*table*): Table with font names as keys and font data as values.

**Realm**

Client.

**Example Usage**

```lua
-- Access stored font data
for fontName, fontData in pairs(lia.font.stored) do
    print("Font: " .. fontName)
    print("  Size: " .. (fontData.size or "default"))
    print("  Weight: " .. (fontData.weight or "default"))
end

-- Get specific font data
local customFontData = lia.font.stored["MyCustomFont"]
if customFontData then
    print("Custom font size: " .. customFontData.size)
end
```

## Pre-defined Fonts

The Lilia framework automatically registers numerous fonts for different UI elements:

### Addon Information Fonts
- **AddonInfo_Header**: Large header font for addon information
- **AddonInfo_Text**: Standard text font for addon information
- **AddonInfo_Small**: Small text font for addon information

### Configuration Fonts
- **ConfigFont**: Standard configuration font
- **MediumConfigFont**: Medium-sized configuration font
- **SmallConfigFont**: Small configuration font
- **ConfigFontBold**: Bold configuration font
- **ConfigFontLarge**: Large configuration font
- **DescriptionFontLarge**: Large description font

### Vendor Fonts
- **VendorButtonFont**: Font for vendor buttons
- **VendorMediumFont**: Medium vendor font
- **VendorSmallFont**: Small vendor font
- **VendorTinyFont**: Tiny vendor font
- **VendorLightFont**: Light vendor font
- **VendorItemNameFont**: Font for item names in vendors
- **VendorItemDescFont**: Font for item descriptions in vendors
- **VendorItemStatsFont**: Font for item stats in vendors
- **VendorItemPriceFont**: Font for item prices in vendors
- **VendorActionButtonFont**: Font for vendor action buttons

### Character Fonts
- **liaCharLargeFont**: Large character font
- **liaCharMediumFont**: Medium character font
- **liaCharSmallFont**: Small character font
- **liaCharSubTitleFont**: Character subtitle font
- **liaCharTitleFont**: Character title font
- **liaCharDescFont**: Character description font
- **liaCharButtonFont**: Character button font
- **liaCharSmallButtonFont**: Small character button font

### UI Fonts
- **liaTitleFont**: Main title font
- **liaSubTitleFont**: Subtitle font
- **liaBigTitle**: Big title font
- **liaBigText**: Big text font
- **liaHugeText**: Huge text font
- **liaBigBtn**: Big button font
- **liaMenuButtonFont**: Menu button font
- **liaMenuButtonLightFont**: Light menu button font
- **liaToolTipText**: Tooltip text font

### Dynamic Fonts
- **liaDynFontSmall**: Small dynamic font
- **liaDynFontMedium**: Medium dynamic font
- **liaDynFontBig**: Big dynamic font

### Generic Fonts
- **liaCleanTitleFont**: Clean title font
- **liaHugeFont**: Huge font
- **liaBigFont**: Big font
- **liaMediumFont**: Medium font
- **liaSmallFont**: Small font
- **liaMiniFont**: Mini font
- **liaMediumLightFont**: Medium light font
- **liaGenericFont**: Generic font
- **liaGenericLightFont**: Generic light font

### Chat Fonts
- **liaChatFont**: Standard chat font
- **liaChatFontItalics**: Italic chat font
- **liaChatFontBold**: Bold chat font

### Item Fonts
- **liaItemDescFont**: Item description font
- **liaSmallBoldFont**: Small bold font
- **liaItemBoldFont**: Item bold font

### Other Fonts
- **liaNoticeFont**: Notice font
- **lia3D2DFont**: 3D2D font
- **CursiveFont**: Cursive font
- **ticketsystem**: Ticket system font

### Poppins Fonts
- **PoppinsSmall**: Small Poppins font
- **PoppinsMedium**: Medium Poppins font
- **PoppinsBig**: Big Poppins font

## Configuration

The fonts library integrates with the configuration system to provide customizable font options:

### Font Configuration
- **Font**: Main font used throughout the interface
- **GenericFont**: Generic font used for various UI elements

### Font Properties

Common font properties that can be used when registering fonts:

- **font** (*string*): The font family name
- **size** (*number*): Font size in pixels
- **weight** (*number*): Font weight (100-1000)
- **extended** (*boolean*): Enable extended character support
- **antialias** (*boolean*): Enable font antialiasing
- **shadow** (*boolean*): Enable text shadow
- **italic** (*boolean*): Enable italic text
- **additive** (*boolean*): Enable additive blending
- **blur** (*number*): Text blur amount
- **scanlines** (*number*): Scanline effect amount

## Example Usage

```lua
-- Register a custom UI font
lia.font.register("CustomUIFont", {
    font = "Roboto",
    size = 18,
    weight = 400,
    extended = true,
    antialias = true
})

-- Register a title font with special effects
lia.font.register("SpecialTitleFont", {
    font = "Impact",
    size = 48,
    weight = 900,
    extended = true,
    antialias = true,
    shadow = true,
    blur = 2
})

-- Register a font that scales with screen size
lia.font.register("ResponsiveFont", {
    font = "Arial",
    size = ScreenScaleH(16) * math.min(ScrW() / 1920, ScrH() / 1080),
    weight = 500,
    extended = true
})

-- Use the font in drawing
surface.SetFont("CustomUIFont")
surface.SetTextColor(255, 255, 255)
surface.DrawText("Hello World!")
```

## Automatic Refresh

The fonts library automatically refreshes fonts when:

- Screen resolution changes
- The `RefreshFonts` hook is triggered
- Font configuration options are changed

This ensures that all fonts remain properly scaled and functional across different screen sizes and configurations.
