# Derma Library

This page documents the functions for creating and managing Derma UI elements in the Lilia framework.

---

## Overview

The derma library (`lia.derma`) provides a comprehensive collection of pre-built UI components and utilities for creating consistent, theme-aware user interfaces in the Lilia framework. This library offers a wide range of specialized UI elements including buttons, panels, frames, input controls, and selection dialogs that automatically integrate with the framework's theming system. The components are designed to provide a cohesive visual experience across all interface elements while maintaining flexibility for customization. The library includes advanced UI creation tools with automatic theme integration, responsive design capabilities, and built-in animation support that enables developers to create polished, professional-looking interfaces with minimal effort. Additionally, the system features robust input validation, accessibility support, and performance optimization to ensure smooth user interactions across different screen sizes and input methods.

---

### attribBar

**Purpose**

Creates an attribute bar component for displaying character attributes with a progress indicator.

**Parameters**

* `parent` (*Panel*): The parent panel to add the attribute bar to.
* `text` (*string*, optional): The text label to display on the bar.
* `maxValue` (*number*, optional): The maximum value for the progress bar.

**Returns**

* `bar` (*liaAttribBar*): The created attribute bar panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic attribute bar
local healthBar = lia.derma.attribBar(parentPanel, "Health", 100)

-- Create an attribute bar with custom max value
local manaBar = lia.derma.attribBar(parentPanel, "Mana", 200)
manaBar:setValue(150)

-- Use in character creation
local strengthBar = lia.derma.attribBar(charPanel, "Strength", 10)
strengthBar:setValue(8)

-- Dynamic attribute display
local function updateAttributeBar(bar, attributeName, currentValue, maxValue)
    bar:setText(attributeName .. ": " .. currentValue .. "/" .. maxValue)
    bar:setValue(currentValue)
    bar:setMax(maxValue)
end

-- Create multiple attribute bars
local attributes = {"Strength", "Dexterity", "Intelligence", "Wisdom"}
for _, attr in ipairs(attributes) do
    local bar = lia.derma.attribBar(parentPanel, attr, 20)
    updateAttributeBar(bar, attr, math.random(10, 18), 20)
end
```

---

### button

**Purpose**

Creates a customizable button with icon support, hover effects, and theme integration.

**Parameters**

* `parent` (*Panel*): The parent panel to add the button to.
* `icon` (*string*, optional): The material path for the button icon.
* `iconSize` (*number*, optional): The size of the icon (default: 16).
* `color` (*Color*, optional): The base color of the button.
* `radius` (*number*, optional): The corner radius of the button (default: 6).
* `noGradient` (*boolean*, optional): Whether to disable gradient effects.
* `hoverColor` (*Color*, optional): The hover color of the button.
* `noHover` (*boolean*, optional): Whether to disable hover effects.

**Returns**

* `button` (*liaButton*): The created button panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic button
local basicButton = lia.derma.button(parentPanel, "icon16/accept.png", 16, Color(100, 150, 255))

-- Create a button without gradient
local flatButton = lia.derma.button(parentPanel, nil, nil, nil, nil, true)

-- Create a custom colored button
local redButton = lia.derma.button(parentPanel, "icon16/cross.png", 16, Color(200, 100, 100))

-- Create a button with custom hover color
local greenButton = lia.derma.button(parentPanel, "icon16/tick.png", 16, Color(100, 200, 100), 8, false, Color(150, 255, 150))

-- Create a button without hover effects
local noHoverButton = lia.derma.button(parentPanel, nil, nil, nil, nil, nil, nil, true)

-- Use in a menu system
local menuButton = lia.derma.button(mainMenu, "icon16/folder.png", 16)
menuButton:SetText("Open Menu")
menuButton.DoClick = function()
    openSubMenu()
end

-- Create icon-only buttons
local playButton = lia.derma.button(toolbar, "icon16/control_play.png", 16)
local pauseButton = lia.derma.button(toolbar, "icon16/control_pause.png", 16)
local stopButton = lia.derma.button(toolbar, "icon16/control_stop.png", 16)
```

---

### category

**Purpose**

Creates a collapsible category panel for organizing UI elements.

**Parameters**

* `parent` (*Panel*): The parent panel to add the category to.
* `title` (*string*, optional): The title text for the category.
* `expanded` (*boolean*, optional): Whether the category should start expanded.

**Returns**

* `category` (*liaCategory*): The created category panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic category
local settingsCategory = lia.derma.category(parentPanel, "Settings")

-- Create an expanded category
local advancedCategory = lia.derma.category(parentPanel, "Advanced Options", true)

-- Create a collapsed category
local basicCategory = lia.derma.category(parentPanel, "Basic Settings", false)

-- Use categories to organize controls
local function createOptionsPanel()
    local generalCat = lia.derma.category(parentPanel, "General", true)

    local nameEntry = lia.derma.descEntry(generalCat, "Display Name", "Enter your name")
    local themeSelector = lia.derma.slideBox(generalCat, "Theme", 1, 3)

    local privacyCat = lia.derma.category(parentPanel, "Privacy", false)
    local showOnlineCheckbox = lia.derma.checkbox(privacyCat, "Show Online Status")
end

-- Dynamic category management
local categories = {}
local function addCategory(title, content)
    local cat = lia.derma.category(parentPanel, title)
    if content then
        content:SetParent(cat)
    end
    table.insert(categories, cat)
    return cat
end

-- Toggle category expansion
local toggleButton = lia.derma.button(parentPanel)
toggleButton.DoClick = function()
    for _, cat in ipairs(categories) do
        cat:Toggle()
    end
end
```

---

### circle

**Purpose**

Creates a circle drawing object that can be customized with colors, textures, materials, and effects before being rendered.

**Parameters**

* `x` (*number*): The x coordinate of the circle center.
* `y` (*number*): The y coordinate of the circle center.
* `radius` (*number*): The radius of the circle.

**Returns**

* `circle` (*liaCircle*): The circle drawing object with chainable methods for customization.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic circle
lia.derma.circle(ScrW() / 2, ScrH() / 2, 50):Color(Color(255, 100, 100)):Draw()

-- Create a circle with outline
lia.derma.circle(100, 100, 30)
    :Color(Color(100, 200, 100))
    :Outline(2)
    :Draw()

-- Create a textured circle
lia.derma.circle(ScrW() / 2, ScrH() / 2, 40)
    :Texture("vgui/white")
    :Color(Color(150, 150, 255))
    :Draw()

-- Create a circle with blur effect
lia.derma.circle(200, 200, 25)
    :Color(Color(255, 255, 100))
    :Blur(2.0)
    :Draw()

-- Create a shadowed circle
lia.derma.circle(ScrW() / 2, ScrH() / 2, 35)
    :Color(Color(100, 100, 255))
    :Shadow(20, 15)
    :Draw()

-- Create a circle with custom angles (arc)
lia.derma.circle(300, 300, 40)
    :Color(Color(255, 150, 100))
    :StartAngle(45)
    :EndAngle(270)
    :Draw()
```

**Available Chainable Methods**

* `:Color(color)` - Sets the circle color
* `:Texture(texture)` - Sets a texture for the circle
* `:Material(material)` - Sets a material for the circle
* `:Outline(thickness)` - Adds an outline with specified thickness
* `:Blur(intensity)` - Applies blur effect
* `:Shadow(spread, intensity)` - Adds shadow effect
* `:Rotation(angle)` - Rotates the circle
* `:StartAngle(angle)` - Sets the start angle for arc drawing
* `:EndAngle(angle)` - Sets the end angle for arc drawing
* `:Clip(panel)` - Clips drawing to specified panel
* `:Flags(flags)` - Applies drawing flags
* `:Draw()` - Renders the circle

---

### color_picker

**Purpose**

Creates a comprehensive color picker dialog that allows users to select colors using hue, saturation, and value controls with a live preview.

**Parameters**

* `callback` (*function*): The function to call when a color is selected. Receives the selected Color object as parameter.
* `defaultColor` (*Color*, optional): The initial color to display in the picker.

**Returns**

* `frame` (*liaFrame*): The color picker frame dialog.

**Realm**

Client.

**Example Usage**

```lua
-- Basic color picker
lia.derma.color_picker(function(color)
    print("Selected color:", color.r, color.g, color.b)
    myPanel:SetBackgroundColor(color)
end)

-- Color picker with default color
local defaultColor = Color(255, 100, 100)
lia.derma.color_picker(function(color)
    print("New color selected:", color)
    updateThemeAccent(color)
end, defaultColor)

-- Use in theme customization
lia.derma.color_picker(function(color)
    local customTheme = table.Copy(lia.color.getTheme())
    customTheme.accent = color
    lia.color.registerTheme("custom", customTheme)
    lia.color.setTheme("custom")
    print("Theme updated with new accent color")
end)

-- Color picker for item customization
lia.derma.color_picker(function(color)
    currentItem.customColor = color
    itemPreviewPanel:SetColor(color)
    print("Item color updated")
end, currentItem.customColor)

-- Multiple color pickers for different UI elements
local colorButtons = {}
local function createColorPalette()
    local colors = {"Primary", "Secondary", "Accent", "Background"}

    for _, colorName in ipairs(colors) do
        local button = lia.derma.button(parentPanel, nil, nil, Color(100, 100, 100))
        button:SetText(colorName)
        button.DoClick = function()
            lia.derma.color_picker(function(color)
                button:SetColor(color)
                updateColorScheme(colorName:lower(), color)
                print("Updated " .. colorName .. " color")
            end)
        end
        table.insert(colorButtons, button)
    end
end

-- Color picker with validation
lia.derma.color_picker(function(color)
    if color.r > 200 and color.g < 50 and color.b < 50 then
        print("Bright red color selected - applying warning theme")
        applyWarningTheme()
    else
        applyNormalColor(color)
    end
end)
```

---

### derma_menu

**Purpose**

Creates a context menu at the current mouse position with automatic positioning and menu management.

**Parameters**

*None*

**Returns**

* `menu` (*liaDermaMenu*): The created context menu panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic context menu
local menu = lia.derma.derma_menu()
menu:AddOption("Copy", function()
    print("Copy option selected")
end)
menu:AddOption("Paste", function()
    print("Paste option selected")
end)
menu:AddOption("Cut", function()
    print("Cut option selected")
end)

-- Context menu with submenus
local menu = lia.derma.derma_menu()
local editSubmenu = menu:AddSubMenu("Edit")

editSubmenu:AddOption("Undo", function()
    print("Undo selected")
end)
editSubmenu:AddOption("Redo", function()
    print("Redo selected")
end)

menu:AddOption("Delete", function()
    print("Delete selected")
end)

-- Context menu for player interactions
local menu = lia.derma.derma_menu()
local targetPlayer = LocalPlayer()

menu:AddOption("Send Message", function()
    lia.derma.textBox("Send Message", "Enter your message", function(text)
        targetPlayer:ChatPrint(text)
    end)
end)

menu:AddOption("Trade Items", function()
    openTradeWindow(targetPlayer)
end)

menu:AddOption("View Profile", function()
    showPlayerProfile(targetPlayer)
end)

-- Context menu with icons
local menu = lia.derma.derma_menu()
menu:AddOption("Save", function()
    saveDocument()
end):SetIcon("icon16/disk.png")

menu:AddOption("Load", function()
    loadDocument()
end):SetIcon("icon16/folder.png")

menu:AddOption("Settings", function()
    openSettings()
end):SetIcon("icon16/cog.png")

-- Dynamic context menu based on object type
local function createContextMenuForObject(object)
    local menu = lia.derma.derma_menu()

    if object.type == "container" then
        menu:AddOption("Open", function() object:Open() end)
        menu:AddOption("Lock", function() object:Lock() end)
    elseif object.type == "npc" then
        menu:AddOption("Talk", function() object:Talk() end)
        menu:AddOption("Trade", function() object:Trade() end)
    elseif object.type == "item" then
        menu:AddOption("Use", function() object:Use() end)
        menu:AddOption("Drop", function() object:Drop() end)
    end

    return menu
end

-- Context menu with separators
local menu = lia.derma.derma_menu()
menu:AddOption("New", function() print("New") end)
menu:AddOption("Open", function() print("Open") end)
menu:AddSpacer()
menu:AddOption("Save", function() print("Save") end)
menu:AddOption("Save As", function() print("Save As") end)
menu:AddSpacer()
menu:AddOption("Exit", function() print("Exit") end)
```

---

### draw

**Purpose**

Draws a rounded rectangle with the specified radius for all corners, providing a simple way to create rounded rectangular shapes.

**Parameters**

* `radius` (*number*): The corner radius for all four corners.
* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color of the rectangle.
* `flags` (*number*, optional): Drawing flags to modify the appearance.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic rounded rectangle
lia.derma.draw(10, 100, 100, 200, 100, Color(100, 150, 255))

-- Draw a circle using high radius
lia.derma.draw(50, 200, 200, 100, 100, Color(255, 100, 100))

-- Draw with blur effect
lia.derma.draw(8, 50, 50, 150, 80, Color(100, 255, 100), lia.derma.BLUR)

-- Draw with shadow
lia.derma.draw(12, 300, 50, 120, 120, Color(255, 200, 100))
lia.derma.drawShadows(12, 300, 50, 120, 120, Color(0, 0, 0, 100), 20, 15)

-- Draw multiple rounded rectangles
local function drawButton(x, y, w, h, text, color)
    lia.derma.draw(8, x, y, w, h, color)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawButton(100, 200, 120, 40, "Click Me", Color(100, 150, 255))
drawButton(250, 200, 120, 40, "Cancel", Color(200, 100, 100))

-- Draw progress bar background
lia.derma.draw(6, 50, 300, 300, 20, Color(50, 50, 50))

-- Draw progress bar fill
local progress = 0.7 -- 70%
lia.derma.draw(6, 50, 300, 300 * progress, 20, Color(100, 200, 100))

-- Draw with different shapes
lia.derma.draw(15, 100, 100, 100, 100, Color(150, 100, 255), lia.derma.SHAPE_CIRCLE)
lia.derma.draw(15, 220, 100, 100, 100, Color(255, 150, 100), lia.derma.SHAPE_FIGMA)
lia.derma.draw(15, 340, 100, 100, 100, Color(100, 255, 150), lia.derma.SHAPE_IOS)
```

---

### drawBlur

**Purpose**

Draws a blurred rectangle with customizable corner radii, shape, and outline thickness for creating soft, blurred UI elements.

**Parameters**

* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `flags` (*number*, optional): Drawing flags to modify the appearance (shape, corners, etc.).
* `tl` (*number*, optional): Top-left corner radius.
* `tr` (*number*, optional): Top-right corner radius.
* `bl` (*number*, optional): Bottom-left corner radius.
* `br` (*number*, optional): Bottom-right corner radius.
* `thickness` (*number*, optional): Outline thickness if using outline flags.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic blurred rectangle
lia.derma.drawBlur(100, 100, 200, 100, nil, 10, 10, 10, 10)

-- Draw blurred rectangle with different corner radii
lia.derma.drawBlur(50, 200, 150, 80, nil, 5, 15, 20, 10)

-- Draw blurred circle
lia.derma.drawBlur(200, 50, 100, 100, lia.derma.SHAPE_CIRCLE, 50, 50, 50, 50)

-- Draw blurred rectangle with outline
lia.derma.drawBlur(300, 100, 120, 80, nil, 8, 8, 8, 8, 2)

-- Create a glowing effect with blur
local function drawGlowingButton(x, y, w, h, color, glowColor)
    -- Draw glow first (larger, blurred)
    lia.derma.drawBlur(x - 10, y - 10, w + 20, h + 20, nil, 15, 15, 15, 15)
    surface.SetDrawColor(glowColor)

    -- Draw main button
    lia.derma.draw(x, y, w, h, color)
end

drawGlowingButton(100, 300, 150, 40, Color(100, 150, 255), Color(100, 150, 255, 100))

-- Create soft shadow effect
lia.derma.drawBlur(50, 50, 100, 100, nil, 10, 10, 10, 10)
lia.derma.drawBlur(55, 55, 90, 90, nil, 8, 8, 8, 8)

-- Draw multiple blurred elements
local positions = {{100, 150}, {220, 150}, {340, 150}, {100, 270}, {220, 270}, {340, 270}}
for i, pos in ipairs(positions) do
    local color = HSVToColor(i * 60, 0.8, 1)
    lia.derma.drawBlur(pos[1], pos[2], 80, 80, lia.derma.SHAPE_CIRCLE, 40, 40, 40, 40)
    surface.SetDrawColor(color)
end

-- Create blurred background for text
lia.derma.drawBlur(200, 200, 300, 60, nil, 15, 15, 15, 15)
draw.SimpleText("Blurred Background Text", "liaLargeFont", 350, 230, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
```

---

### drawCircle

**Purpose**

Draws a circle with the specified center position, radius, and color using the optimized circular drawing system.

**Parameters**

* `x` (*number*): The x coordinate of the circle center.
* `y` (*number*): The y coordinate of the circle center.
* `radius` (*number*): The radius of the circle.
* `col` (*Color*): The color of the circle.
* `flags` (*number*, optional): Drawing flags to modify the appearance (blur, outline, etc.).

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic circle
lia.derma.drawCircle(ScrW() / 2, ScrH() / 2, 50, Color(255, 100, 100))

-- Draw multiple circles of different sizes and colors
local function drawColorfulCircles()
    local colors = {Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255), Color(255, 255, 0)}
    for i = 1, 4 do
        local radius = 20 + i * 15
        lia.derma.drawCircle(100 + i * 80, 100, radius, colors[i])
    end
end

drawColorfulCircles()

-- Draw outlined circles
lia.derma.drawCircle(200, 200, 40, Color(100, 200, 100))
lia.derma.drawCircleOutlined(200, 200, 45, Color(50, 150, 50), 3)

-- Draw blurred circles
lia.derma.drawCircle(300, 150, 30, Color(255, 150, 100), lia.derma.BLUR)

-- Draw circle with texture
lia.derma.drawCircleTexture(400, 150, 35, Color(255, 255, 255), "vgui/white")

-- Create animated circles
local time = RealTime()
local pulseRadius = 25 + math.sin(time * 3) * 10
lia.derma.drawCircle(500, 150, pulseRadius, Color(150, 100, 255))

-- Draw circle grid pattern
for x = 1, 5 do
    for y = 1, 3 do
        local circleX = 50 + x * 60
        local circleY = 250 + y * 60
        local color = HSVToColor((x + y) * 30, 0.8, 1)
        lia.derma.drawCircle(circleX, circleY, 20, color)
    end
end

-- Draw target circles (concentric)
local centerX, centerY = 300, 350
for i = 1, 5 do
    local radius = i * 15
    local alpha = 255 - i * 40
    lia.derma.drawCircle(centerX, centerY, radius, Color(255, 100, 100, alpha))
end

-- Interactive circle that follows mouse
local mouseX, mouseY = input.GetCursorPos()
lia.derma.drawCircle(mouseX, mouseY, 20, Color(100, 255, 100))
```

---

### drawCircleMaterial

**Purpose**

Draws a circle using a material for texture mapping, allowing for complex visual effects and detailed circle rendering.

**Parameters**

* `x` (*number*): The x coordinate of the circle center.
* `y` (*number*): The y coordinate of the circle center.
* `radius` (*number*): The radius of the circle.
* `col` (*Color*): The color tint to apply to the material.
* `mat` (*IMaterial*): The material to use for drawing the circle.
* `flags` (*number*, optional): Drawing flags to modify the appearance (blur, outline, etc.).

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw circle with a material
local circleMat = Material("vgui/circle")
lia.derma.drawCircleMaterial(ScrW() / 2, ScrH() / 2, 50, Color(255, 255, 255), circleMat)

-- Draw circle with tinted material
local gradientMat = Material("gui/gradient")
lia.derma.drawCircleMaterial(200, 200, 40, Color(255, 100, 100), gradientMat)

-- Draw circle with animated material
local noiseMat = Material("effects/noise")
local time = RealTime()
lia.derma.drawCircleMaterial(300, 150, 30, Color(100, 150, 255, math.sin(time) * 128 + 128), noiseMat)

-- Draw circles with different materials
local materials = {
    Material("vgui/white"),
    Material("gui/center_gradient"),
    Material("effects/bubble"),
    Material("particle/particle_glow_05")
}

for i, mat in ipairs(materials) do
    local x = 100 + i * 80
    local color = HSVToColor(i * 60, 1, 1)
    lia.derma.drawCircleMaterial(x, 100, 25, color, mat)
end

-- Create textured buttons with materials
local function drawMaterialButton(x, y, radius, text, material, color)
    lia.derma.drawCircleMaterial(x, y, radius, color, material)
    draw.SimpleText(text, "liaMediumFont", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawMaterialButton(200, 250, 30, "Save", Material("icon16/disk.png"), Color(100, 200, 100))
drawMaterialButton(280, 250, 30, "Load", Material("icon16/folder.png"), Color(200, 150, 100))
drawMaterialButton(360, 250, 30, "Delete", Material("icon16/cross.png"), Color(200, 100, 100))

-- Draw circle with material and blur effect
local sparkleMat = Material("effects/sparkle")
lia.derma.drawCircleMaterial(400, 200, 35, Color(255, 255, 150), sparkleMat, lia.derma.BLUR)

-- Interactive material circle that changes color on hover
local hoverX, hoverY = 300, 350
local isHovering = math.Distance(input.GetCursorPos(), hoverX, hoverY) < 40
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.drawCircleMaterial(hoverX, hoverY, 40, hoverColor, Material("gui/gradient"))
```

---

### drawCircleOutlined

**Purpose**

Draws an outlined circle with the specified center position, radius, color, and outline thickness using the optimized circular drawing system.

**Parameters**

* `x` (*number*): The x coordinate of the circle center.
* `y` (*number*): The y coordinate of the circle center.
* `radius` (*number*): The radius of the circle.
* `col` (*Color*): The color of the circle outline.
* `thickness` (*number*): The thickness of the outline.
* `flags` (*number*, optional): Drawing flags to modify the appearance (blur, etc.).

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic outlined circle
lia.derma.drawCircleOutlined(ScrW() / 2, ScrH() / 2, 50, Color(255, 100, 100), 2)

-- Draw multiple outlined circles with different thicknesses
for i = 1, 5 do
    local radius = 20 + i * 10
    local thickness = i
    local color = HSVToColor(i * 60, 1, 1)
    lia.derma.drawCircleOutlined(100 + i * 60, 100, radius, color, thickness)
end

-- Draw outlined circles with blur effect
lia.derma.drawCircleOutlined(300, 150, 40, Color(100, 200, 255), 3, lia.derma.BLUR)

-- Create target-like outlined circles (concentric)
local centerX, centerY = 400, 200
for i = 1, 6 do
    local radius = i * 15
    local thickness = 2
    local alpha = 255 - i * 30
    lia.derma.drawCircleOutlined(centerX, centerY, radius, Color(255, 150, 100, alpha), thickness)
end

-- Draw outlined circle buttons
local function drawOutlinedButton(x, y, radius, text, color, thickness)
    lia.derma.drawCircleOutlined(x, y, radius, color, thickness)
    draw.SimpleText(text, "liaMediumFont", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawOutlinedButton(200, 300, 25, "OK", Color(100, 200, 100), 2)
drawOutlinedButton(280, 300, 25, "Cancel", Color(200, 100, 100), 2)

-- Draw outlined circles with different line styles
lia.derma.drawCircleOutlined(100, 250, 30, Color(255, 255, 100), 1)
lia.derma.drawCircleOutlined(160, 250, 30, Color(255, 150, 255), 3)
lia.derma.drawCircleOutlined(220, 250, 30, Color(150, 255, 255), 5)

-- Interactive outlined circle that changes on hover
local hoverX, hoverY = 350, 300
local distance = math.Distance(input.GetCursorPos(), hoverX, hoverY)
local isHovering = distance < 35
local hoverThickness = isHovering and 4 or 2
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.drawCircleOutlined(hoverX, hoverY, 35, hoverColor, hoverThickness)

-- Draw outlined circle progress indicator
local progress = 0.75 -- 75%
local circleX, circleY = 450, 300
local radius = 30

-- Draw background circle (full outline)
lia.derma.drawCircleOutlined(circleX, circleY, radius, Color(100, 100, 100), 3)

-- Draw progress arc (partial outline)
-- Note: This would require custom implementation for arc drawing
```

---

### drawCircleTexture

**Purpose**

Draws a circle using a texture for detailed visual effects and pattern mapping, allowing for complex circle rendering with texture support.

**Parameters**

* `x` (*number*): The x coordinate of the circle center.
* `y` (*number*): The y coordinate of the circle center.
* `radius` (*number*): The radius of the circle.
* `col` (*Color*): The color tint to apply to the texture.
* `texture` (*string*): The texture path to use for drawing the circle.
* `flags` (*number*, optional): Drawing flags to modify the appearance (blur, outline, etc.).

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw circle with a texture
lia.derma.drawCircleTexture(ScrW() / 2, ScrH() / 2, 50, Color(255, 255, 255), "vgui/white")

-- Draw circle with tinted texture
lia.derma.drawCircleTexture(200, 200, 40, Color(255, 100, 100), "gui/gradient")

-- Draw circles with different textures
local textures = {
    "vgui/white",
    "gui/center_gradient",
    "effects/bubble",
    "particle/particle_glow_05"
}

for i, texture in ipairs(textures) do
    local x = 100 + i * 80
    local color = HSVToColor(i * 60, 1, 1)
    lia.derma.drawCircleTexture(x, 100, 25, color, texture)
end

-- Create textured circle buttons
local function drawTextureButton(x, y, radius, text, texture, color)
    lia.derma.drawCircleTexture(x, y, radius, color, texture)
    draw.SimpleText(text, "liaMediumFont", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawTextureButton(200, 250, 30, "Save", "icon16/disk.png", Color(100, 200, 100))
drawTextureButton(280, 250, 30, "Load", "icon16/folder.png", Color(200, 150, 100))
drawTextureButton(360, 250, 30, "Delete", "icon16/cross.png", Color(200, 100, 100))

-- Draw circle with texture and blur effect
lia.derma.drawCircleTexture(400, 200, 35, Color(255, 255, 150), "effects/sparkle", lia.derma.BLUR)

-- Animated textured circle
local time = RealTime()
local pulseAlpha = math.sin(time * 2) * 64 + 192
lia.derma.drawCircleTexture(300, 150, 30, Color(100, 150, 255, pulseAlpha), "gui/gradient")

-- Interactive textured circle that changes texture on hover
local hoverX, hoverY = 350, 300
local distance = math.Distance(input.GetCursorPos(), hoverX, hoverY)
local isHovering = distance < 35
local hoverTexture = isHovering and "effects/sparkle" or "gui/gradient"
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.drawCircleTexture(hoverX, hoverY, 35, hoverColor, hoverTexture)

-- Draw textured circle grid pattern
for x = 1, 4 do
    for y = 1, 3 do
        local circleX = 50 + x * 70
        local circleY = 350 + y * 70
        local texture = (x + y) % 2 == 0 and "vgui/white" or "gui/center_gradient"
        local color = HSVToColor((x + y) * 45, 0.8, 1)
        lia.derma.drawCircleTexture(circleX, circleY, 25, color, texture)
    end
end

-- Create pattern overlay with textured circles
local overlayTexture = "effects/noise"
for i = 1, 20 do
    local randomX = math.random(50, ScrW() - 50)
    local randomY = math.random(50, ScrH() - 50)
    local randomSize = math.random(10, 30)
    lia.derma.drawCircleTexture(randomX, randomY, randomSize, Color(255, 255, 255, 50), overlayTexture)
end
```

---

### drawMaterial

**Purpose**

Draws a rounded rectangle using a material for advanced texture mapping and visual effects, automatically extracting the base texture from the material.

**Parameters**

* `radius` (*number*): The corner radius for all four corners.
* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color tint to apply to the material.
* `mat` (*IMaterial*): The material to use for drawing.
* `flags` (*number*, optional): Drawing flags to modify the appearance.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw with a basic material
local testMaterial = Material("vgui/white")
lia.derma.drawMaterial(10, 100, 100, 200, 100, Color(100, 150, 255), testMaterial)

-- Draw with a gradient material
local gradientMat = Material("gui/gradient")
lia.derma.drawMaterial(8, 50, 200, 150, 80, Color(255, 100, 100), gradientMat)

-- Draw with animated material properties
local animatedMat = Material("effects/noise")
local time = RealTime()
local pulseColor = Color(100, 150, 255, math.sin(time * 3) * 128 + 128)
lia.derma.drawMaterial(12, 300, 50, 120, 120, pulseColor, animatedMat)

-- Draw buttons with different materials
local materials = {
    Material("vgui/white"),
    Material("gui/center_gradient"),
    Material("effects/bubble"),
    Material("particle/particle_glow_05")
}

for i, mat in ipairs(materials) do
    local x = 100 + i * 80
    local color = HSVToColor(i * 60, 1, 1)
    lia.derma.drawMaterial(6, x, 100, 60, 40, color, mat)
end

-- Create material-based UI elements
local function drawMaterialButton(x, y, w, h, text, material, color)
    lia.derma.drawMaterial(8, x, y, w, h, color, material)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawMaterialButton(200, 250, 120, 40, "Save", Material("icon16/disk.png"), Color(100, 200, 100))
drawMaterialButton(350, 250, 120, 40, "Load", Material("icon16/folder.png"), Color(200, 150, 100))

-- Draw with material and blur effect
local sparkleMat = Material("effects/sparkle")
lia.derma.drawMaterial(15, 400, 100, 100, 100, Color(255, 255, 150), sparkleMat, lia.derma.BLUR)

-- Interactive material element that changes on hover
local hoverX, hoverY, hoverW, hoverH = 300, 350, 80, 60
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 50
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.drawMaterial(10, hoverX, hoverY, hoverW, hoverH, hoverColor, Material("gui/gradient"))
```

---

### drawOutlined

**Purpose**

Draws an outlined rounded rectangle with customizable corner radius and outline thickness for creating bordered UI elements.

**Parameters**

* `radius` (*number*): The corner radius for all four corners.
* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color of the outline.
* `thickness` (*number*, optional): The thickness of the outline (default: 1).
* `flags` (*number*, optional): Drawing flags to modify the appearance.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic outlined rectangle
lia.derma.drawOutlined(10, 100, 100, 200, 100, Color(255, 100, 100), 2)

-- Draw outlined rectangles with different thicknesses
for i = 1, 5 do
    local thickness = i
    local color = HSVToColor(i * 60, 1, 1)
    lia.derma.drawOutlined(8, 50 + i * 70, 50, 60, 40, color, thickness)
end

-- Draw outlined rectangle with blur effect
lia.derma.drawOutlined(12, 300, 100, 120, 80, Color(100, 200, 255), 3, lia.derma.BLUR)

-- Create outlined buttons
local function drawOutlinedButton(x, y, w, h, text, color, thickness)
    lia.derma.drawOutlined(8, x, y, w, h, color, thickness)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawOutlinedButton(200, 200, 120, 40, "OK", Color(100, 200, 100), 2)
drawOutlinedButton(350, 200, 120, 40, "Cancel", Color(200, 100, 100), 2)

-- Draw interactive outlined element that changes on hover
local hoverX, hoverY, hoverW, hoverH = 250, 300, 100, 60
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 60
local hoverThickness = isHovering and 4 or 2
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.drawOutlined(10, hoverX, hoverY, hoverW, hoverH, hoverColor, hoverThickness)

-- Draw progress bar with outline
lia.derma.drawOutlined(6, 50, 350, 300, 20, Color(100, 100, 100), 2)
local progress = 0.7 -- 70%
lia.derma.draw(6, 50, 350, 300 * progress, 20, Color(100, 200, 100))

-- Draw outlined shapes with different corner styles
lia.derma.drawOutlined(15, 100, 250, 80, 80, Color(255, 150, 100), 3, lia.derma.SHAPE_CIRCLE)
lia.derma.drawOutlined(15, 200, 250, 80, 80, Color(100, 255, 150), 3, lia.derma.SHAPE_FIGMA)
lia.derma.drawOutlined(15, 300, 250, 80, 80, Color(150, 100, 255), 3, lia.derma.SHAPE_IOS)
```

---

### drawShadows

**Purpose**

Draws drop shadows for rounded rectangles with customizable spread, intensity, and shape flags for creating depth effects.

**Parameters**

* `radius` (*number*): The corner radius for all four corners.
* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color of the shadow.
* `spread` (*number*, optional): The spread distance of the shadow (default: 30).
* `intensity` (*number*, optional): The intensity/opacity of the shadow (default: spread * 1.2).
* `flags` (*number*, optional): Drawing flags to modify the appearance.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic shadowed rectangle
lia.derma.drawShadows(10, 100, 100, 200, 100, Color(0, 0, 0, 100), 20, 15)

-- Draw rectangle with shadow and main content
lia.derma.drawShadows(8, 50, 50, 150, 80, Color(0, 0, 0, 150), 25, 20)
lia.derma.draw(8, 50, 50, 150, 80, Color(100, 150, 255))

-- Draw multiple shadowed elements
local shadowColors = {Color(255, 0, 0, 100), Color(0, 255, 0, 100), Color(0, 0, 255, 100)}
for i = 1, 3 do
    local y = 100 + i * 100
    lia.derma.drawShadows(12, 200 + i * 80, y, 100, 60, shadowColors[i], 30, 25)
    lia.derma.draw(12, 200 + i * 80, y, 100, 60, Color(255, 255, 255))
end

-- Create shadowed buttons
local function drawShadowedButton(x, y, w, h, text, shadowColor, mainColor)
    lia.derma.drawShadows(8, x, y, w, h, shadowColor, 20, 15)
    lia.derma.draw(8, x, y, w, h, mainColor)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawShadowedButton(100, 300, 120, 40, "Save", Color(0, 0, 0, 150), Color(100, 200, 100))
drawShadowedButton(250, 300, 120, 40, "Cancel", Color(0, 0, 0, 150), Color(200, 100, 100))

-- Draw shadowed elements with different shapes
lia.derma.drawShadows(15, 100, 200, 80, 80, Color(0, 0, 0, 100), 25, 20, lia.derma.SHAPE_CIRCLE)
lia.derma.draw(15, 100, 200, 80, 80, Color(150, 100, 255))

lia.derma.drawShadows(15, 100, 300, 80, 80, Color(0, 0, 0, 100), 25, 20, lia.derma.SHAPE_FIGMA)
lia.derma.draw(15, 100, 300, 80, 80, Color(255, 150, 100))

-- Interactive shadowed element that changes on hover
local hoverX, hoverY, hoverW, hoverH = 300, 200, 100, 60
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 60
local shadowIntensity = isHovering and 30 or 15
lia.derma.drawShadows(10, hoverX, hoverY, hoverW, hoverH, Color(0, 0, 0, 150), 25, shadowIntensity)
lia.derma.draw(10, hoverX, hoverY, hoverW, hoverH, isHovering and Color(255, 255, 100) or Color(150, 150, 255))
```

---

### drawShadowsOutlined

**Purpose**

Draws an outlined rectangle with drop shadows, combining the effects of `drawShadows` and `drawOutlined` for creating bordered UI elements with depth.

**Parameters**

* `radius` (*number*): The corner radius for all four corners.
* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color of the shadow and outline.
* `thickness` (*number*, optional): The thickness of the outline (default: 1).
* `spread` (*number*, optional): The spread distance of the shadow (default: 30).
* `intensity` (*number*, optional): The intensity/opacity of the shadow (default: spread * 1.2).
* `flags` (*number*, optional): Drawing flags to modify the appearance (shape, blur, corners, etc.).

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw a basic outlined rectangle with shadow
lia.derma.drawShadowsOutlined(10, 100, 100, 200, 100, Color(0, 0, 0, 150), 2, 20, 15)

-- Draw shadowed outlined rectangle with blur effect
lia.derma.drawShadowsOutlined(12, 50, 50, 150, 80, Color(0, 0, 0, 100), 3, 25, 20, lia.derma.BLUR)

-- Create shadowed outlined buttons
local function drawShadowedOutlinedButton(x, y, w, h, text, shadowColor, mainColor, thickness)
    lia.derma.drawShadowsOutlined(8, x, y, w, h, shadowColor, thickness, 20, 15)
    lia.derma.draw(8, x, y, w, h, mainColor)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawShadowedOutlinedButton(100, 300, 120, 40, "Save", Color(0, 0, 0, 150), Color(100, 200, 100), 2)
drawShadowedOutlinedButton(250, 300, 120, 40, "Cancel", Color(0, 0, 0, 150), Color(200, 100, 100), 2)

-- Draw shadowed outlined elements with different shapes
lia.derma.drawShadowsOutlined(15, 100, 200, 80, 80, Color(0, 0, 0, 100), 3, 25, 20, lia.derma.SHAPE_CIRCLE)
lia.derma.draw(15, 100, 200, 80, 80, Color(150, 100, 255))

lia.derma.drawShadowsOutlined(15, 100, 300, 80, 80, Color(0, 0, 0, 100), 3, 25, 20, lia.derma.SHAPE_FIGMA)
lia.derma.draw(15, 100, 300, 80, 80, Color(255, 150, 100))

-- Interactive shadowed outlined element that changes on hover
local hoverX, hoverY, hoverW, hoverH = 300, 200, 100, 60
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 60
local shadowIntensity = isHovering and 30 or 15
local hoverThickness = isHovering and 4 or 2
lia.derma.drawShadowsOutlined(10, hoverX, hoverY, hoverW, hoverH, Color(0, 0, 0, 150), hoverThickness, 25, shadowIntensity)
lia.derma.draw(10, hoverX, hoverY, hoverW, hoverH, isHovering and Color(255, 255, 100) or Color(150, 150, 255))
```

**Available Flags**

* `lia.derma.BLUR` - Applies blur effect to the shadow
* `lia.derma.SHAPE_CIRCLE` - Perfect circle corners
* `lia.derma.SHAPE_FIGMA` - Figma-style rounded corners (default)
* `lia.derma.SHAPE_IOS` - iOS-style rounded corners
* `lia.derma.NO_TL` - Removes top-left corner radius
* `lia.derma.NO_TR` - Removes top-right corner radius
* `lia.derma.NO_BL` - Removes bottom-left corner radius
* `lia.derma.NO_BR` - Removes bottom-right corner radius

---

### drawTexture

**Purpose**

Draws a rounded rectangle using a texture for detailed visual effects and pattern mapping, allowing for complex rectangular rendering with texture support.

**Parameters**

* `radius` (*number*): The corner radius for all four corners.
* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color tint to apply to the texture.
* `texture` (*string*): The texture path to use for drawing.
* `flags` (*number*, optional): Drawing flags to modify the appearance.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw rectangle with a texture
lia.derma.drawTexture(10, 100, 100, 200, 100, Color(255, 255, 255), "vgui/white")

-- Draw rectangle with tinted texture
lia.derma.drawTexture(8, 50, 200, 150, 80, Color(255, 100, 100), "gui/gradient")

-- Draw rectangles with different textures
local textures = {
    "vgui/white",
    "gui/center_gradient",
    "effects/bubble",
    "particle/particle_glow_05"
}

for i, texture in ipairs(textures) do
    local x = 100 + i * 80
    local color = HSVToColor(i * 60, 1, 1)
    lia.derma.drawTexture(6, x, 50, 60, 40, color, texture)
end

-- Create textured buttons
local function drawTextureButton(x, y, w, h, text, texture, color)
    lia.derma.drawTexture(8, x, y, w, h, color, texture)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawTextureButton(200, 150, 120, 40, "Save", "icon16/disk.png", Color(100, 200, 100))
drawTextureButton(350, 150, 120, 40, "Load", "icon16/folder.png", Color(200, 150, 100))

-- Draw rectangle with texture and blur effect
lia.derma.drawTexture(15, 400, 50, 100, 100, Color(255, 255, 150), "effects/sparkle", lia.derma.BLUR)

-- Animated textured rectangle
local time = RealTime()
local pulseAlpha = math.sin(time * 2) * 64 + 192
lia.derma.drawTexture(12, 250, 100, 120, 80, Color(100, 150, 255, pulseAlpha), "gui/gradient")

-- Interactive textured element that changes texture on hover
local hoverX, hoverY, hoverW, hoverH = 300, 250, 100, 60
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 60
local hoverTexture = isHovering and "effects/sparkle" or "gui/gradient"
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.drawTexture(10, hoverX, hoverY, hoverW, hoverH, hoverColor, hoverTexture)

-- Draw textured background pattern
local overlayTexture = "effects/noise"
for i = 1, 20 do
    local randomX = math.random(50, ScrW() - 150)
    local randomY = math.random(50, ScrH() - 100)
    lia.derma.drawTexture(5, randomX, randomY, 100, 60, Color(255, 255, 255, 50), overlayTexture)
end

-- Create progress bar with textured background
lia.derma.drawTexture(6, 50, 300, 300, 20, Color(255, 255, 255), "gui/gradient")
local progress = 0.7 -- 70%
lia.derma.draw(6, 50, 300, 300 * progress, 20, Color(100, 200, 100))
```

---

### drawShadowsEx

**Purpose**

Draws advanced drop shadows for rounded rectangles with full customization of corner radii, shadow properties, and outline thickness for creating sophisticated depth effects.

**Parameters**

* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.
* `col` (*Color*): The color of the shadow.
* `flags` (*number*, optional): Drawing flags to modify the appearance (shape, corners, blur, etc.).
* `tl` (*number*, optional): Top-left corner radius.
* `tr` (*number*, optional): Top-right corner radius.
* `bl` (*number*, optional): Bottom-left corner radius.
* `br` (*number*, optional): Bottom-right corner radius.
* `spread` (*number*, optional): The spread distance of the shadow (default: 30).
* `intensity` (*number*, optional): The intensity/opacity of the shadow (default: spread * 1.2).
* `thickness` (*number*, optional): Outline thickness if using outline flags.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Draw shadow with custom corner radii
lia.derma.drawShadowsEx(100, 100, 200, 100, Color(0, 0, 0, 100), nil, 5, 15, 20, 10, 25, 20)

-- Draw shadowed rectangle with different corner styles
lia.derma.drawShadowsEx(50, 200, 150, 80, Color(0, 0, 0, 150), lia.derma.SHAPE_CIRCLE, 50, 50, 50, 50, 30, 25)
lia.derma.draw(8, 50, 200, 150, 80, Color(100, 150, 255))

-- Draw shadow with blur effect
lia.derma.drawShadowsEx(300, 100, 120, 80, Color(0, 0, 0, 100), lia.derma.BLUR, 8, 8, 8, 8, 25, 20)

-- Create advanced shadowed buttons with individual corner control
local function drawAdvancedShadowedButton(x, y, w, h, text, shadowColor, mainColor, tl, tr, bl, br)
    lia.derma.drawShadowsEx(x, y, w, h, shadowColor, nil, tl, tr, bl, br, 20, 15)
    lia.derma.draw(tl, x, y, w, h, mainColor)
    draw.SimpleText(text, "liaMediumFont", x + w/2, y + h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

drawAdvancedShadowedButton(100, 300, 120, 40, "Rounded", Color(0, 0, 0, 150), Color(100, 200, 100), 8, 8, 8, 8)
drawAdvancedShadowedButton(250, 300, 120, 40, "Mixed", Color(0, 0, 0, 150), Color(200, 100, 100), 5, 15, 20, 10)

-- Draw shadow with outline
lia.derma.drawShadowsEx(200, 200, 100, 60, Color(0, 0, 0, 150), nil, 10, 10, 10, 10, 25, 20, 2)

-- Interactive shadowed element with dynamic properties
local hoverX, hoverY, hoverW, hoverH = 300, 250, 100, 60
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 60
local shadowSpread = isHovering and 35 or 25
local shadowIntensity = isHovering and 30 or 15
lia.derma.drawShadowsEx(hoverX, hoverY, hoverW, hoverH, Color(0, 0, 0, 150), nil, 10, 10, 10, 10, shadowSpread, shadowIntensity)
lia.derma.draw(10, hoverX, hoverY, hoverW, hoverH, isHovering and Color(255, 255, 100) or Color(150, 150, 255))
```

---

### player_selector

**Purpose**

Creates a comprehensive player selection dialog with search and filtering capabilities, displaying all players with their avatars, names, user groups, and ping information.

**Parameters**

* `callback` (*function*): The function to call when a player is selected. Receives the selected Player object as parameter.
* `validationFunc` (*function*, optional): A function to validate player selection. Should return true if the player can be selected.

**Returns**

* `frame` (*liaFrame*): The player selector frame dialog.

**Realm**

Client.

**Example Usage**

```lua
-- Basic player selector
lia.derma.player_selector(function(player)
    print("Selected player:", player:Name(), player:SteamID())
end)

-- Player selector with validation (only alive players)
lia.derma.player_selector(function(player)
    if IsValid(player) and player:Alive() then
        tradeWithPlayer(player)
    end
end, function(player)
    return player ~= LocalPlayer() and player:Alive()
end)

-- Use in admin functions
lia.derma.player_selector(function(player)
    local menu = lia.derma.derma_menu()
    menu:AddOption("Kick Player", function() kickPlayer(player) end)
    menu:AddOption("Ban Player", function() banPlayer(player) end)
    menu:AddOption("Teleport to Player", function() teleportToPlayer(player) end)
end)

-- Player selector for team assignment
lia.derma.player_selector(function(player)
    local teams = team.GetAllTeams()
    local menu = lia.derma.derma_menu()

    for _, teamInfo in pairs(teams) do
        menu:AddOption("Move to " .. teamInfo.Name, function()
            player:SetTeam(teamInfo.ID)
            print("Moved " .. player:Name() .. " to " .. teamInfo.Name)
        end)
    end
end, function(player)
    return player ~= LocalPlayer()
end)

-- Multiple player selection for group actions
local selectedPlayers = {}
lia.derma.player_selector(function(player)
    if table.HasValue(selectedPlayers, player) then
        table.RemoveByValue(selectedPlayers, player)
        print("Deselected:", player:Name())
    else
        table.insert(selectedPlayers, player)
        print("Selected:", player:Name())
    end
    print("Total selected players:", #selectedPlayers)
end)

-- Player selector with custom validation for specific roles
lia.derma.player_selector(function(player)
    if player:GetUserGroup() == "admin" then
        promotePlayer(player)
    else
        print("Only admins can be promoted")
    end
end, function(player)
    return player:GetUserGroup() == "moderator"
end)

-- Player selector for messaging
lia.derma.player_selector(function(player)
    lia.derma.textBox("Send Message", "Enter your message to " .. player:Name(), function(text)
        net.Start("SendPrivateMessage")
        net.WriteEntity(player)
        net.WriteString(text)
        net.SendToServer()
    end)
end)
```

---

### radial_menu

**Purpose**

Creates a radial/circular menu for quick action selection, displaying options in a circular layout that users can select by clicking on sectors.

**Parameters**

* `options` (*table*): A table of options with the following properties:
  - `title` (*string*, optional): The title displayed in the center of the menu.
  - `desc` (*string*, optional): The description displayed below the title.
  - `radius` (*number*, optional): The radius of the radial menu (default: 280).
  - `inner_radius` (*number*, optional): The inner radius for the center area (default: 96).
  - `disable_background` (*boolean*, optional): Whether to disable the background overlay.
  - `hover_sound` (*string*, optional): Sound to play on option hover.
  - `scale_animation` (*boolean*, optional): Whether to enable scale animation (default: true).
  - Additional options can be added using the returned panel's methods.

**Returns**

* `menu` (*liaRadialPanel*): The created radial menu panel.

**Realm**

Client.

**Example Usage**

```lua
-- Basic radial menu
local options = {
    title = "Actions",
    desc = "Select an option"
}

local menu = lia.derma.radial_menu(options)

-- Add options to the menu
menu:AddOption("Attack", function() print("Attack selected") end, "icon16/gun.png", "Launch an attack")
menu:AddOption("Defend", function() print("Defend selected") end, "icon16/shield.png", "Defend position")
menu:AddOption("Heal", function() print("Heal selected") end, "icon16/heart.png", "Use healing item")
menu:AddOption("Retreat", function() print("Retreat selected") end, "icon16/arrow_left.png", "Retreat from combat")

-- Radial menu with submenus
local mainMenu = lia.derma.radial_menu({
    title = "Main Menu",
    desc = "Choose a category"
})

local combatSubmenu = mainMenu:CreateSubMenu("Combat", "Combat actions")
combatSubmenu:AddOption("Melee Attack", function() print("Melee attack") end, "icon16/sword.png")
combatSubmenu:AddOption("Ranged Attack", function() print("Ranged attack") end, "icon16/gun.png")
combatSubmenu:AddOption("Magic", function() print("Magic attack") end, "icon16/lightning.png")

local utilitySubmenu = mainMenu:CreateSubMenu("Utilities", "Utility actions")
utilitySubmenu:AddOption("Heal", function() print("Heal") end, "icon16/heart.png")
utilitySubmenu:AddOption("Buff", function() print("Buff") end, "icon16/star.png")

mainMenu:AddOption("Combat", nil, "icon16/bomb.png", "Combat submenu", combatSubmenu)
mainMenu:AddOption("Utilities", nil, "icon16/wrench.png", "Utility submenu", utilitySubmenu)

-- Radial menu for spell casting
local spellMenu = lia.derma.radial_menu({
    title = "Spells",
    desc = "Choose a spell to cast",
    radius = 320
})

local spells = {
    {name = "Fireball", icon = "icon16/fire.png", desc = "Deals fire damage"},
    {name = "Ice Bolt", icon = "icon16/weather_snow.png", desc = "Freezes enemies"},
    {name = "Lightning", icon = "icon16/lightning.png", desc = "Chain lightning"},
    {name = "Heal", icon = "icon16/heart.png", desc = "Restores health"},
    {name = "Shield", icon = "icon16/shield.png", desc = "Creates barrier"},
    {name = "Teleport", icon = "icon16/arrow_right.png", desc = "Instant movement"}
}

for _, spell in ipairs(spells) do
    spellMenu:AddOption(spell.name, function() print("Cast " .. spell.name) end, spell.icon, spell.desc)
end

-- Radial menu for emotes
local emoteMenu = lia.derma.radial_menu({
    title = "Emotes",
    desc = "Choose an emote",
    radius = 250
})

local emotes = {
    {name = "Wave", icon = "icon16/user.png"},
    {name = "Dance", icon = "icon16/user_go.png"},
    {name = "Cry", icon = "icon16/user_delete.png"},
    {name = "Laugh", icon = "icon16/user_comment.png"},
    {name = "Bow", icon = "icon16/user_suit.png"},
    {name = "Point", icon = "icon16/user_gray.png"}
}

for _, emote in ipairs(emotes) do
    emoteMenu:AddOption(emote.name, function() RunConsoleCommand("say", "/" .. string.lower(emote.name)) end, emote.icon, emote.name .. " emote")
end

-- Dynamic radial menu creation
local function createRadialMenuForItems(items)
    local menu = lia.derma.radial_menu({
        title = "Items",
        desc = "Select an item to use"
    })

    for _, item in ipairs(items) do
        menu:AddOption(item.name, function() useItem(item) end, item.icon, item.description)
    end

    return menu
end

-- Custom radial menu with different settings
local customMenu = lia.derma.radial_menu({
    title = "Custom Menu",
    desc = "Custom radial menu",
    radius = 300,
    inner_radius = 120,
    disable_background = false,
    hover_sound = "ui/buttonrollover.wav",
    scale_animation = true
})

customMenu:AddOption("Option 1", function() print("Option 1") end, "icon16/accept.png")
customMenu:AddOption("Option 2", function() print("Option 2") end, "icon16/cancel.png")
customMenu:AddOption("Option 3", function() print("Option 3") end, "icon16/help.png")
```

---

### rect

**Purpose**

Creates a rectangle drawing object that can be customized with colors, textures, materials, corner radii, and effects before being rendered.

**Parameters**

* `x` (*number*): The x position of the rectangle.
* `y` (*number*): The y position of the rectangle.
* `w` (*number*): The width of the rectangle.
* `h` (*number*): The height of the rectangle.

**Returns**

* `rect` (*liaRect*): The rectangle drawing object with chainable methods for customization.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic rectangle
lia.derma.rect(100, 100, 200, 100):Color(Color(100, 150, 255)):Draw()

-- Create a rectangle with rounded corners
lia.derma.rect(50, 200, 150, 80)
    :Color(Color(255, 100, 100))
    :Rad(10)
    :Draw()

-- Create a rectangle with texture
lia.derma.rect(250, 50, 120, 120)
    :Texture("vgui/white")
    :Color(Color(150, 150, 255))
    :Draw()

-- Create a rectangle with material
local gradientMat = Material("gui/gradient")
lia.derma.rect(400, 100, 100, 100)
    :Material(gradientMat)
    :Color(Color(255, 200, 100))
    :Draw()

-- Create a rectangle with blur effect
lia.derma.rect(100, 300, 150, 60)
    :Color(Color(100, 255, 100))
    :Blur(2.0)
    :Draw()

-- Create a shadowed rectangle
lia.derma.rect(300, 250, 120, 80)
    :Color(Color(255, 150, 100))
    :Shadow(20, 15)
    :Draw()

-- Create a rectangle with outline
lia.derma.rect(450, 200, 100, 100)
    :Color(Color(150, 100, 255))
    :Outline(3)
    :Draw()

-- Create rectangles with different corner radii
lia.derma.rect(50, 400, 100, 60):Radii(5, 10, 15, 20):Color(Color(255, 100, 255)):Draw()
lia.derma.rect(200, 400, 100, 60):Radii(20, 5, 10, 15):Color(Color(100, 255, 255)):Draw()
lia.derma.rect(350, 400, 100, 60):Radii(10, 20, 5, 15):Color(Color(255, 255, 100)):Draw()

-- Interactive rectangle that changes color on hover
local hoverX, hoverY, hoverW, hoverH = 500, 350, 80, 50
local distance = math.Distance(input.GetCursorPos(), hoverX + hoverW/2, hoverY + hoverH/2)
local isHovering = distance < 50
local hoverColor = isHovering and Color(255, 255, 100) or Color(150, 150, 255)
lia.derma.rect(hoverX, hoverY, hoverW, hoverH)
    :Color(hoverColor)
    :Rad(8)
    :Draw()

-- Create a progress bar with rectangle
lia.derma.rect(50, 500, 300, 20):Color(Color(50, 50, 50)):Rad(4):Draw()
local progress = 0.7 -- 70%
lia.derma.rect(50, 500, 300 * progress, 20):Color(Color(100, 200, 100)):Rad(4):Draw()
```

**Available Chainable Methods**

* `:Color(color)` - Sets the rectangle color
* `:Texture(texture)` - Sets a texture for the rectangle
* `:Material(material)` - Sets a material for the rectangle
* `:Rad(radius)` - Sets the same radius for all corners
* `:Radii(tl, tr, bl, br)` - Sets individual corner radii
* `:Outline(thickness)` - Adds an outline with specified thickness
* `:Blur(intensity)` - Applies blur effect
* `:Shadow(spread, intensity)` - Adds shadow effect
* `:Rotation(angle)` - Rotates the rectangle
* `:Shape(shape)` - Sets the shape type (circle, figma, ios)
* `:Clip(panel)` - Clips drawing to specified panel
* `:Flags(flags)` - Applies drawing flags
* `:Draw()` - Renders the rectangle

---

### setDefaultShape

**Purpose**

Sets the default shape type for all subsequent drawing operations, affecting the appearance of corners in drawn elements.

**Parameters**

* `shape` (*number*): The shape type to set as default. Available options:
  - `lia.derma.SHAPE_CIRCLE` - Perfect circles
  - `lia.derma.SHAPE_FIGMA` - Figma-style rounded corners (default)
  - `lia.derma.SHAPE_IOS` - iOS-style rounded corners

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Set default shape to circle
lia.derma.setDefaultShape(lia.derma.SHAPE_CIRCLE)

-- All subsequent drawing operations will use circle shape
lia.derma.draw(10, 100, 100, 100, 100, Color(255, 100, 100))
lia.derma.rect(200, 100, 100, 100):Color(Color(100, 255, 100)):Draw()

-- Set default shape to iOS style
lia.derma.setDefaultShape(lia.derma.SHAPE_IOS)

-- All subsequent drawing operations will use iOS-style corners
lia.derma.draw(15, 100, 200, 80, 80, Color(100, 100, 255))
lia.derma.rect(300, 200, 120, 60):Color(Color(255, 150, 100)):Draw()

-- Reset to default Figma style
lia.derma.setDefaultShape(lia.derma.SHAPE_FIGMA)

-- All subsequent drawing operations will use Figma-style corners
lia.derma.draw(12, 50, 300, 150, 80, Color(150, 255, 150))

-- Use in theme or style management
local function applyRoundedTheme()
    lia.derma.setDefaultShape(lia.derma.SHAPE_FIGMA)
    print("Applied rounded theme")
end

local function applySharpTheme()
    lia.derma.setDefaultShape(lia.derma.SHAPE_IOS)
    print("Applied sharp theme")
end

local function applyCircularTheme()
    lia.derma.setDefaultShape(lia.derma.SHAPE_CIRCLE)
    print("Applied circular theme")
end

-- Apply theme based on user preference
local userTheme = "rounded" -- Could come from config or user setting
if userTheme == "rounded" then
    applyRoundedTheme()
elseif userTheme == "sharp" then
    applySharpTheme()
elseif userTheme == "circular" then
    applyCircularTheme()
end
```

---

### setFlag

**Purpose**

Utility function for setting or unsetting specific flags in a flags value, commonly used for modifying drawing behavior in derma operations.

**Parameters**

* `flags` (*number*): The current flags value to modify.
* `flag` (*number* or *string*): The flag to set or unset. Can be a flag constant or a string key from lia.derma.
* `bool` (*boolean*): Whether to set (true) or unset (false) the flag.

**Returns**

* `newFlags` (*number*): The modified flags value.

**Realm**

Client.

**Example Usage**

```lua
-- Set a specific flag
local flags = 0
flags = lia.derma.setFlag(flags, lia.derma.BLUR, true)
flags = lia.derma.setFlag(flags, lia.derma.SHAPE_CIRCLE, true)

-- Use the flags in drawing
lia.derma.draw(10, 100, 100, 200, 100, Color(255, 100, 100), flags)

-- Unset a flag
flags = lia.derma.setFlag(flags, lia.derma.BLUR, false)

-- Set multiple flags at once
local function createFlags(...)
    local flags = 0
    for _, flag in ipairs({...}) do
        flags = lia.derma.setFlag(flags, flag, true)
    end
    return flags
end

local myFlags = createFlags(lia.derma.SHAPE_IOS, lia.derma.BLUR)
lia.derma.draw(12, 200, 100, 150, 80, Color(100, 200, 255), myFlags)

-- Toggle flags
local currentFlags = 0
local function toggleBlur()
    currentFlags = lia.derma.setFlag(currentFlags, lia.derma.BLUR, not lia.derma.setFlag(currentFlags, lia.derma.BLUR, false) == currentFlags)
end

-- Use string keys for flags
flags = lia.derma.setFlag(flags, "BLUR", true)
flags = lia.derma.setFlag(flags, "SHAPE_CIRCLE", true)

-- Combine with drawing operations
local function drawElement(x, y, w, h, color, useBlur, useCircle)
    local flags = 0
    flags = lia.derma.setFlag(flags, lia.derma.BLUR, useBlur)
    flags = lia.derma.setFlag(flags, lia.derma.SHAPE_CIRCLE, useCircle)

    lia.derma.draw(10, x, y, w, h, color, flags)
end

drawElement(50, 50, 100, 100, Color(255, 100, 100), true, false)
drawElement(200, 50, 100, 100, Color(100, 255, 100), false, true)
drawElement(350, 50, 100, 100, Color(100, 100, 255), true, true)

-- Advanced flag management
local flagPresets = {
    normal = 0,
    blurred = lia.derma.BLUR,
    outlined = lia.derma.setFlag(0, lia.derma.BLUR, false), -- This doesn't make sense, need to fix
    shadowed = lia.derma.BLUR, -- Placeholder
    glowing = lia.derma.BLUR
}

local function applyPreset(presetName)
    return flagPresets[presetName] or 0
end

local elementFlags = applyPreset("blurred")
lia.derma.draw(8, 100, 150, 120, 80, Color(255, 200, 100), elementFlags)
```

---

### characterAttribRow

**Purpose**

Creates a row component for displaying character attributes in a structured format.

**Parameters**

* `parent` (*Panel*): The parent panel to add the row to.
* `attributeKey` (*string*, optional): The attribute key/name.
* `attributeData` (*table*, optional): The attribute data containing display information.

**Returns**

* `row` (*liaCharacterAttribsRow*): The created attribute row panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic attribute row
local strengthRow = lia.derma.characterAttribRow(parentPanel, "strength", {
    name = "Strength",
    desc = "Physical power and carrying capacity",
    max = 20,
    value = 15
})

-- Create multiple attribute rows
local attributes = {
    strength = {name = "Strength", desc = "Physical power", max = 20, value = 16},
    dexterity = {name = "Dexterity", desc = "Agility and precision", max = 20, value = 14},
    intelligence = {name = "Intelligence", desc = "Mental capacity", max = 20, value = 18}
}

for key, data in pairs(attributes) do
    local row = lia.derma.characterAttribRow(parentPanel, key, data)
end

-- Use with character attribute system
local function createCharacterSheet(character)
    local attribsPanel = lia.derma.characterAttribs(parentPanel)

    for attributeKey, attributeData in pairs(lia.attributes.list) do
        local currentValue = character:getAttrib(attributeKey, 0)
        local row = lia.derma.characterAttribRow(attribsPanel, attributeKey, attributeData)
        row:setValue(currentValue)
    end
end

-- Dynamic attribute row updates
local function updateAttributeDisplay(row, newValue, maxValue)
    row:setValue(newValue)
    row:setMax(maxValue)
    row:setText(string.format("%s: %d/%d", row.attributeData.name, newValue, maxValue))
end
```

---

### characterAttribs

**Purpose**

Creates a container panel for displaying multiple character attribute rows.

**Parameters**

* `parent` (*Panel*): The parent panel to add the container to.

**Returns**

* `attribsPanel` (*liaCharacterAttribs*): The created attributes container panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a character attributes panel
local attribsPanel = lia.derma.characterAttribs(parentPanel)
attribsPanel:Dock(FILL)

-- Populate with character data
local character = LocalPlayer():getChar()
if character then
    for attributeKey, attributeData in pairs(lia.attributes.list) do
        local currentValue = character:getAttrib(attributeKey, 0)
        local row = lia.derma.characterAttribRow(attribsPanel, attributeKey, attributeData)
        row:setValue(currentValue)
    end
end

-- Create a reusable character sheet
local function createCharacterSheet(parent)
    local sheet = vgui.Create("DPanel", parent)
    sheet:Dock(FILL)

    local title = vgui.Create("DLabel", sheet)
    title:Dock(TOP)
    title:SetText("Character Attributes")
    title:SetFont("liaMediumFont")

    local attribsContainer = lia.derma.characterAttribs(sheet)

    -- Add attribute rows dynamically
    local character = LocalPlayer():getChar()
    if character then
        for key, data in pairs(lia.attributes.list) do
            local value = character:getAttrib(key, 0)
            local row = lia.derma.characterAttribRow(attribsContainer, key, data)
            row:setValue(value)
        end
    end

    return sheet
end

-- Use in character creation
local creationPanel = lia.derma.frame(nil, "Character Creation", 400, 600)
local attribsSection = lia.derma.characterAttribs(creationPanel)
-- Populate with default values for character creation...
```

---

### checkbox

**Purpose**

Creates a themed checkbox with label for boolean input.

**Parameters**

* `parent` (*Panel*): The parent panel to add the checkbox to.
* `text` (*string*): The label text for the checkbox.
* `convar` (*string*, optional): The console variable to bind the checkbox to.

**Returns**

* `panel` (*Panel*): The container panel.
* `checkbox` (*liaCheckBox*): The actual checkbox element.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic checkbox
local panel, checkbox = lia.derma.checkbox(parentPanel, "Enable Feature")
checkbox:SetChecked(true)

-- Create a checkbox bound to a convar
local _, soundCheckbox = lia.derma.checkbox(parentPanel, "Enable Sound", "lia_enable_sound")

-- Multiple related checkboxes
local options = {
    {"Show Health Bar", "lia_show_health"},
    {"Show Mana Bar", "lia_show_mana"},
    {"Show Minimap", "lia_show_minimap"},
    {"Enable Tooltips", "lia_enable_tooltips"}
}

for _, option in ipairs(options) do
    local _, checkbox = lia.derma.checkbox(parentPanel, option[1], option[2])
end

-- Group checkboxes in a category
local settingsCategory = lia.derma.category(parentPanel, "Display Settings", true)

local showFPS = lia.derma.checkbox(settingsCategory, "Show FPS Counter", "lia_show_fps")
local showPing = lia.derma.checkbox(settingsCategory, "Show Ping", "lia_show_ping")
local showCoords = lia.derma.checkbox(settingsCategory, "Show Coordinates", "lia_show_coords")

-- Use checkbox value in logic
local enableMusic = lia.derma.checkbox(parentPanel, "Enable Background Music")
enableMusic[2].OnChange = function(self, value)
    if value then
        startBackgroundMusic()
    else
        stopBackgroundMusic()
    end
end

-- Create checkbox with custom behavior
local _, debugCheckbox = lia.derma.checkbox(parentPanel, "Debug Mode", "lia_debug_mode")
debugCheckbox.OnChange = function(self, value)
    if value then
        print("Debug mode enabled")
        showDebugInfo()
    else
        print("Debug mode disabled")
        hideDebugInfo()
    end
end
```

---

### colorPicker

**Purpose**

Creates a color picker dialog for selecting colors with hue, saturation, and value controls.

**Parameters**

* `callback` (*function*): The function to call when a color is selected.
* `defaultColor` (*Color*, optional): The initial color to display.

**Returns**

* `frame` (*liaFrame*): The color picker frame.

**Realm**

Client.

**Example Usage**

```lua
-- Basic color picker
lia.derma.colorPicker(function(color)
    print("Selected color:", color)
    selectedColor = color
end)

-- Color picker with default color
local defaultColor = Color(255, 100, 100)
lia.derma.colorPicker(function(color)
    myPanel:SetBackgroundColor(color)
end, defaultColor)

-- Use in theme customization
lia.derma.colorPicker(function(color)
    local customTheme = table.Copy(lia.color.getTheme())
    customTheme.accent = color
    lia.color.registerTheme("custom", customTheme)
    lia.color.setTheme("custom")
end)

-- Color picker for item customization
local function createItemColorPicker(item, callback)
    lia.derma.colorPicker(function(color)
        item.customColor = color
        callback(color)
    end, item.customColor)
end

-- Multiple color pickers for different elements
local colorButtons = {}
local function createColorPalette()
    local colors = {"Red", "Green", "Blue", "Yellow", "Purple", "Orange"}

    for _, colorName in ipairs(colors) do
        local button = lia.derma.button(parentPanel, nil, nil, Color(100, 100, 100))
        button:SetText(colorName)
        button.DoClick = function()
            lia.derma.colorPicker(function(color)
                button:SetColor(color)
                print("Changed " .. colorName .. " to:", color)
            end)
        end
        table.insert(colorButtons, button)
    end
end
```

---

### dermaMenu

**Purpose**

Creates a context menu at the current mouse position with automatic positioning.

**Parameters**

*None*

**Returns**

* `menu` (*liaDermaMenu*): The created context menu.

**Realm**

Client.

**Example Usage**

```lua
-- Create a basic context menu
local menu = lia.derma.dermaMenu()
menu:AddOption("Option 1", function() print("Selected option 1") end)
menu:AddOption("Option 2", function() print("Selected option 2") end)
menu:AddOption("Option 3", function() print("Selected option 3") end)

-- Context menu with submenus
local menu = lia.derma.dermaMenu()
local submenu = menu:AddSubMenu("More Options")

submenu:AddOption("Sub Option 1", function() print("Sub option 1") end)
submenu:AddOption("Sub Option 2", function() print("Sub option 2") end)

menu:AddOption("Regular Option", function() print("Regular option") end)

-- Context menu for player interactions
local menu = lia.derma.dermaMenu()
local targetPlayer = LocalPlayer()

menu:AddOption("Send Message", function()
    lia.derma.textBox("Send Message", "Enter your message", function(text)
        targetPlayer:ChatPrint(text)
    end)
end)

menu:AddOption("Trade Items", function()
    openTradeWindow(targetPlayer)
end)

menu:AddOption("View Profile", function()
    showPlayerProfile(targetPlayer)
end)

-- Dynamic context menu based on object
local function createContextMenuForObject(object)
    local menu = lia.derma.dermaMenu()

    if object.isContainer then
        menu:AddOption("Open", function() object:Open() end)
        menu:AddOption("Lock", function() object:Lock() end)
    end

    if object.isNPC then
        menu:AddOption("Talk", function() object:Talk() end)
        menu:AddOption("Trade", function() object:Trade() end)
    end

    return menu
end

-- Context menu with icons
local menu = lia.derma.dermaMenu()
menu:AddOption("Copy", function() clipboard.Copy() end):SetIcon("icon16/page_copy.png")
menu:AddOption("Paste", function() clipboard.Paste() end):SetIcon("icon16/paste.png")
menu:AddOption("Cut", function() clipboard.Cut() end):SetIcon("icon16/cut.png")
```

---

### descEntry

**Purpose**

Creates a labeled text entry field with placeholder text and optional title.

**Parameters**

* `parent` (*Panel*): The parent panel to add the entry to.
* `title` (*string*, optional): The title label for the entry field.
* `placeholder` (*string*): The placeholder text to display when empty.
* `offTitle` (*boolean*, optional): Whether to disable the title label.

**Returns**

* `entry` (*liaEntry*): The text entry field.
* `entry_bg` (*liaBasePanel*): The background panel (only if title is provided).

**Realm**

Client.

**Example Usage**

```lua
-- Basic text entry with title
local entry = lia.derma.descEntry(parentPanel, "Username", "Enter your username")

-- Text entry without title
local passwordEntry = lia.derma.descEntry(parentPanel, nil, "Enter password", true)

-- Multiple form fields
local formFields = {}
local fields = {
    {"Name", "Enter your full name"},
    {"Email", "Enter your email address"},
    {"Age", "Enter your age"},
    {"Bio", "Tell us about yourself"}
}

for _, field in ipairs(fields) do
    local entry = lia.derma.descEntry(parentPanel, field[1], field[2])
    table.insert(formFields, entry)
end

-- Validate form input
local function validateForm()
    local isValid = true
    for i, entry in ipairs(formFields) do
        local value = entry:GetValue()
        if value == "" then
            entry:SetError("This field is required")
            isValid = false
        else
            entry:ClearError()
        end
    end
    return isValid
end

-- Use in settings panel
local settingsCategory = lia.derma.category(parentPanel, "Account Settings", true)

local usernameEntry = lia.derma.descEntry(settingsCategory, "Username", "Current username")
local emailEntry = lia.derma.descEntry(settingsCategory, "Email", "your@email.com")
local passwordEntry = lia.derma.descEntry(settingsCategory, "New Password", "Enter new password")

-- Auto-save functionality
local function setupAutoSave(entry, convar)
    entry.OnChange = function()
        LocalPlayer():ConCommand(convar .. " " .. entry:GetValue())
    end
end

setupAutoSave(usernameEntry, "lia_username")
setupAutoSave(emailEntry, "lia_email")
```

---

### frame

**Purpose**

Creates a themed frame window with optional close button and animation support.

**Parameters**

* `parent` (*Panel*): The parent panel to add the frame to.
* `title` (*string*, optional): The title text for the frame.
* `width` (*number*, optional): The width of the frame (default: 300).
* `height` (*number*, optional): The height of the frame (default: 200).
* `closeButton` (*boolean*, optional): Whether to show the close button.
* `animate` (*boolean*, optional): Whether to show entrance animation.

**Returns**

* `frame` (*liaFrame*): The created frame.

**Realm**

Client.

**Example Usage**

```lua
-- Basic frame
local frame = lia.derma.frame(nil, "My Window", 400, 300)

-- Frame with close button
local frameWithClose = lia.derma.frame(parentPanel, "Settings", 500, 400, true)

-- Frame without close button (modal)
local modalFrame = lia.derma.frame(nil, "Important Notice", 300, 150, false)

-- Animated frame
local animatedFrame = lia.derma.frame(nil, "Loading...", 200, 100, true, true)

-- Custom frame content
local infoFrame = lia.derma.frame(nil, "Player Information", 350, 250, true)
local content = vgui.Create("DPanel", infoFrame)
content:Dock(FILL)
content:DockMargin(10, 10, 10, 10)

local nameLabel = vgui.Create("DLabel", content)
nameLabel:Dock(TOP)
nameLabel:SetText("Player: " .. LocalPlayer():Name())

local steamLabel = vgui.Create("DLabel", content)
steamLabel:Dock(TOP)
steamLabel:DockMargin(0, 5, 0, 0)
steamLabel:SetText("Steam ID: " .. LocalPlayer():SteamID())

-- Frame with custom close behavior
local confirmFrame = lia.derma.frame(nil, "Confirm Action", 300, 120, true)
confirmFrame.OnClose = function()
    print("User cancelled the action")
end

-- Multiple frames management
local frames = {}
local function createTabFrame(title, content)
    local frame = lia.derma.frame(nil, title, 400, 300, true, true)
    local panel = vgui.Create("DPanel", frame)
    panel:Dock(FILL)
    if content then content(panel) end
    table.insert(frames, frame)
    return frame
end
```

---

### panelTabs

**Purpose**

Creates a tabbed panel interface for organizing content into multiple sections.

**Parameters**

* `parent` (*Panel*): The parent panel to add the tabs to.

**Returns**

* `tabs` (*liaTabs*): The created tabbed panel.

**Realm**

Client.

**Example Usage**

```lua
-- Basic tabbed panel
local tabs = lia.derma.panelTabs(parentPanel)

local tab1 = tabs:AddTab("General", createGeneralPanel())
local tab2 = tabs:AddTab("Advanced", createAdvancedPanel())
local tab3 = tabs:AddTab("About", createAboutPanel())

-- Programmatically switch tabs
tabs:ActiveTab("Advanced")

-- Tabs with icons
local tabs = lia.derma.panelTabs(parentPanel)
tabs:AddTab("Home", homePanel, "icon16/house.png")
tabs:AddTab("Settings", settingsPanel, "icon16/cog.png")
tabs:AddTab("Help", helpPanel, "icon16/help.png")

-- Dynamic tab creation
local function createTabbedInterface(data)
    local tabs = lia.derma.panelTabs(parentPanel)

    for title, contentFunc in pairs(data) do
        local panel = contentFunc()
        tabs:AddTab(title, panel)
    end

    return tabs
end

-- Settings tabs
local settingsTabs = lia.derma.panelTabs(settingsPanel)
settingsTabs:AddTab("Graphics", createGraphicsSettings())
settingsTabs:AddTab("Audio", createAudioSettings())
settingsTabs:AddTab("Controls", createControlSettings())
settingsTabs:AddTab("Network", createNetworkSettings())

-- Tab change callback
local tabs = lia.derma.panelTabs(parentPanel)
tabs.OnTabChanged = function(oldTab, newTab)
    print("Switched from", oldTab, "to", newTab)
end
```

---

### playerSelector

**Purpose**

Creates a player selection dialog with search and filtering capabilities.

**Parameters**

* `callback` (*function*): The function to call when a player is selected.
* `validationFunc` (*function*, optional): A function to validate player selection.

**Returns**

* `frame` (*liaFrame*): The player selector frame.

**Realm**

Client.

**Example Usage**

```lua
-- Basic player selector
lia.derma.playerSelector(function(player)
    print("Selected player:", player:Name())
end)

-- Player selector with validation
lia.derma.playerSelector(function(player)
    if IsValid(player) and player:Alive() then
        tradeWithPlayer(player)
    end
end, function(player)
    return player ~= LocalPlayer() and player:Alive()
end)

-- Use in admin functions
lia.derma.playerSelector(function(player)
    local menu = lia.derma.dermaMenu()
    menu:AddOption("Kick", function() kickPlayer(player) end)
    menu:AddOption("Ban", function() banPlayer(player) end)
    menu:AddOption("Teleport", function() teleportToPlayer(player) end)
end)

-- Player selector for team assignment
lia.derma.playerSelector(function(player)
    local teams = team.GetAllTeams()
    local menu = lia.derma.dermaMenu()

    for _, teamInfo in pairs(teams) do
        menu:AddOption("Move to " .. teamInfo.Name, function()
            player:SetTeam(teamInfo.ID)
        end)
    end
end, function(player)
    return player ~= LocalPlayer()
end)

-- Multiple player selection
local selectedPlayers = {}
lia.derma.playerSelector(function(player)
    if table.HasValue(selectedPlayers, player) then
        table.RemoveByValue(selectedPlayers, player)
        print("Deselected:", player:Name())
    else
        table.insert(selectedPlayers, player)
        print("Selected:", player:Name())
    end
    print("Selected players:", #selectedPlayers)
end)
```

---

### radialMenu

**Purpose**

Creates a radial/circular menu for quick action selection.

**Parameters**

* `options` (*table*): A table of options with name, icon, and callback properties.

**Returns**

* `menu` (*liaRadialPanel*): The created radial menu.

**Realm**

Client.

**Example Usage**

```lua
-- Basic radial menu
local options = {
    {name = "Attack", icon = "icon16/gun.png", callback = function() attack() end},
    {name = "Defend", icon = "icon16/shield.png", callback = function() defend() end},
    {name = "Heal", icon = "icon16/heart.png", callback = function() heal() end},
    {name = "Retreat", icon = "icon16/arrow_left.png", callback = function() retreat() end}
}

local menu = lia.derma.radialMenu(options)

-- Radial menu with more options
local spellOptions = {
    {name = "Fireball", icon = "icon16/fire.png", callback = function() castFireball() end},
    {name = "Ice Bolt", icon = "icon16/weather_snow.png", callback = function() castIceBolt() end},
    {name = "Lightning", icon = "icon16/lightning.png", callback = function() castLightning() end},
    {name = "Heal", icon = "icon16/heart.png", callback = function() castHeal() end},
    {name = "Shield", icon = "icon16/shield.png", callback = function() castShield() end},
    {name = "Teleport", icon = "icon16/arrow_right.png", callback = function() castTeleport() end}
}

local spellMenu = lia.derma.radialMenu(spellOptions)

-- Dynamic radial menu creation
local function createRadialMenuForItems(items)
    local options = {}

    for _, item in ipairs(items) do
        table.insert(options, {
            name = item.name,
            icon = item.icon,
            callback = function() useItem(item) end
        })
    end

    return lia.derma.radialMenu(options)
end

-- Radial menu for emotes
local emoteOptions = {
    {name = "Wave", icon = "icon16/user.png", callback = function() doEmote("wave") end},
    {name = "Dance", icon = "icon16/user_go.png", callback = function() doEmote("dance") end},
    {name = "Cry", icon = "icon16/user_delete.png", callback = function() doEmote("cry") end},
    {name = "Laugh", icon = "icon16/user_comment.png", callback = function() doEmote("laugh") end}
}

local emoteMenu = lia.derma.radialMenu(emoteOptions)
```

---

### scrollPanel

**Purpose**

Creates a scrollable panel with themed scrollbars.

**Parameters**

* `scrollPanel` (*Panel*): The scroll panel to apply theming to.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Theme an existing scroll panel
local scrollPanel = vgui.Create("DScrollPanel", parent)
lia.derma.scrollPanel(scrollPanel)

-- Create a new themed scroll panel
local scrollPanel = lia.derma.scrollpanel(parentPanel)

-- Use in content creation
local function createScrollableContent()
    local scroll = lia.derma.scrollpanel(parentPanel)
    scroll:Dock(FILL)

    -- Add many items to demonstrate scrolling
    for i = 1, 50 do
        local item = vgui.Create("DButton", scroll)
        item:Dock(TOP)
        item:SetTall(30)
        item:SetText("Item " .. i)
    end

    return scroll
end

-- Scroll panel with custom content
local contentScroll = lia.derma.scrollpanel(parentPanel)
contentScroll:Dock(FILL)

for i = 1, 20 do
    local panel = vgui.Create("DPanel", contentScroll)
    panel:Dock(TOP)
    panel:DockMargin(5, 5, 5, 0)
    panel:SetTall(60)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(50, 50, 50, 150))
    end

    local label = vgui.Create("DLabel", panel)
    label:Dock(FILL)
    label:DockMargin(10, 0, 10, 0)
    label:SetText("Scrollable content item " .. i)
end

-- Nested scroll panels
local outerScroll = lia.derma.scrollpanel(parentPanel)
outerScroll:Dock(FILL)

local innerScroll = lia.derma.scrollpanel(outerScroll)
innerScroll:Dock(TOP)
innerScroll:SetTall(200)
```

---

### scrollpanel

**Purpose**

Creates a new themed scroll panel with automatic scrollbar theming.

**Parameters**

* `parent` (*Panel*): The parent panel to add the scroll panel to.

**Returns**

* `scrollpanel` (*liaScrollPanel*): The created themed scroll panel.

**Realm**

Client.

**Example Usage**

```lua
-- Create a themed scroll panel
local scrollPanel = lia.derma.scrollpanel(parentPanel)
scrollPanel:Dock(FILL)

-- Add content to the scroll panel
for i = 1, 100 do
    local button = vgui.Create("DButton", scrollPanel)
    button:Dock(TOP)
    button:DockMargin(0, 0, 0, 5)
    button:SetTall(40)
    button:SetText("Button " .. i)
end

-- Scroll panel in a frame
local frame = lia.derma.frame(nil, "Scrollable Content", 300, 400)
local scroll = lia.derma.scrollpanel(frame)

for i = 1, 30 do
    local item = vgui.Create("DPanel", scroll)
    item:Dock(TOP)
    item:DockMargin(5, 5, 5, 0)
    item:SetTall(50)
    item.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, lia.color.theme.panel_alpha[1])
    end
end

-- Dynamic content loading
local function loadMoreContent(scrollPanel, startIndex, count)
    for i = startIndex, startIndex + count - 1 do
        local item = vgui.Create("DLabel", scrollPanel)
        item:Dock(TOP)
        item:DockMargin(5, 5, 5, 0)
        item:SetTall(30)
        item:SetText("Item " .. i)
    end
end

local scrollPanel = lia.derma.scrollpanel(parentPanel)
loadMoreContent(scrollPanel, 1, 50)
```

---

### slideBox

**Purpose**

Creates a slider control with label and value display for numeric input.

**Parameters**

* `parent` (*Panel*): The parent panel to add the slider to.
* `label` (*string*): The label text for the slider.
* `minValue` (*number*): The minimum value of the slider.
* `maxValue` (*number*): The maximum value of the slider.
* `convar` (*string*, optional): The console variable to bind the slider to.
* `decimals` (*number*, optional): The number of decimal places to display.

**Returns**

* `slider` (*DButton*): The created slider control.

**Realm**

Client.

**Example Usage**

```lua
-- Basic slider
local volumeSlider = lia.derma.slideBox(parentPanel, "Volume", 0, 100, "lia_volume")

-- Slider with decimals
local opacitySlider = lia.derma.slideBox(parentPanel, "Opacity", 0, 1, "lia_opacity", 2)

-- Multiple sliders for settings
local sliders = {
    {label = "Master Volume", min = 0, max = 100, convar = "lia_master_volume"},
    {label = "Music Volume", min = 0, max = 100, convar = "lia_music_volume"},
    {label = "SFX Volume", min = 0, max = 100, convar = "lia_sfx_volume"},
    {label = "Mouse Sensitivity", min = 0.1, max = 5.0, convar = "lia_mouse_sensitivity", decimals = 1}
}

for _, sliderInfo in ipairs(sliders) do
    lia.derma.slideBox(parentPanel, sliderInfo.label, sliderInfo.min,
                       sliderInfo.max, sliderInfo.convar, sliderInfo.decimals)
end

-- Custom slider behavior
local customSlider = lia.derma.slideBox(parentPanel, "Custom Value", 0, 100)
customSlider.OnValueChanged = function(value)
    print("Slider value changed to:", value)
    updateBasedOnSlider(value)
end

-- Slider with live preview
local brightnessSlider = lia.derma.slideBox(parentPanel, "Brightness", 0, 2, nil, 1)
brightnessSlider.OnValueChanged = function(value)
    render.SetLightingMode(value)
end

-- Group sliders in categories
local graphicsCategory = lia.derma.category(parentPanel, "Graphics", true)
local resolutionSlider = lia.derma.slideBox(graphicsCategory, "Resolution Scale", 0.5, 2.0, "lia_resolution", 1)
local fpsSlider = lia.derma.slideBox(graphicsCategory, "Max FPS", 30, 300, "lia_max_fps")
```

---

### textBox

**Purpose**

Creates a text input dialog for getting user input with a title and description.

**Parameters**

* `title` (*string*): The title of the dialog.
* `description` (*string*): The placeholder/description text.
* `callback` (*function*): The function to call with the entered text.

**Returns**

*None*

**Realm**

Client.

**Example Usage**

```lua
-- Basic text input
lia.derma.textBox("Enter Name", "Type your name here", function(text)
    print("User entered:", text)
    playerName = text
end)

-- Text input for commands
lia.derma.textBox("Execute Command", "Enter console command", function(command)
    LocalPlayer():ConCommand(command)
end)

-- Text input with validation
lia.derma.textBox("Set Password", "Enter new password", function(password)
    if string.len(password) >= 8 then
        setPlayerPassword(password)
        print("Password updated successfully")
    else
        print("Password must be at least 8 characters")
        -- Show the dialog again
        timer.Simple(0.1, function()
            lia.derma.textBox("Set Password", "Enter new password (min 8 chars)", function(newPassword)
                if string.len(newPassword) >= 8 then
                    setPlayerPassword(newPassword)
                else
                    print("Password too short")
                end
            end)
        end)
    end
end)

-- Text input for item naming
lia.derma.textBox("Name Your Item", "Enter a name for this item", function(name)
    if name and name ~= "" then
        currentItem.name = name
        print("Item renamed to:", name)
    else
        print("Invalid name")
    end
end)

-- Multiple text inputs in sequence
local function promptForDetails()
    lia.derma.textBox("Enter Title", "What is the title?", function(title)
        lia.derma.textBox("Enter Description", "Describe it briefly", function(description)
            lia.derma.textBox("Enter Tags", "Comma-separated tags", function(tags)
                saveContent(title, description, tags)
            end)
        end)
    end)
end
```
