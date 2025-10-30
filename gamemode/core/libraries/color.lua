--[[
    Color Library

    Comprehensive color and theme management system for the Lilia framework.
]]
--[[
    Overview:
        The color library provides comprehensive functionality for managing colors and themes in the Lilia framework. It handles color registration, theme management, color manipulation, and smooth theme transitions. The library operates primarily on the client side, with theme registration available on both server and client. It includes predefined color names, theme switching capabilities, color adjustment functions, and smooth animated transitions between themes. The library ensures consistent color usage across the entire gamemode interface and provides tools for creating custom themes and color schemes.
]]
lia.color = lia.color or {}
lia.color.stored = lia.color.stored or {}
lia.color.themes = lia.color.themes or {}
if CLIENT then
    --[[
    Purpose:
        Registers a color name in the color system for easy reference throughout the framework.

    When Called:
        During framework initialization or when defining custom color palettes.
        When adding new color names for consistent theming.

    Parameters:
        - name (string): The name identifier for the color (case-insensitive).
        - color (Color): The Color object to associate with the name.

    Returns:
        None.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Register a basic color
        lia.color.register("myRed", Color(255, 0, 0))
        ```

        Medium Complexity:

        ```lua
        -- Medium: Register multiple colors for a theme
        local themeColors = {
            primary = Color(100, 150, 200),
            secondary = Color(200, 100, 150),
            accent = Color(150, 200, 100)
        }

        for name, color in pairs(themeColors) do
            lia.color.register("theme_" .. name, color)
        end
        ```

        High Complexity:

        ```lua
        -- High: Register colors with validation and fallbacks
        local function registerSafeColor(name, color)
            if not lia.color.stored[name:lower()] then
                lia.color.register(name, color)
                print("Registered color:", name)
            else
                print("Color already exists:", name)
            end
        end

        registerSafeColor("brandPrimary", Color(60, 140, 140))
        registerSafeColor("brandSecondary", Color(140, 60, 140))
        ```
]]
function lia.color.register(name, color)
        lia.color.stored[name:lower()] = color
    end

    --[[
    Purpose:
        Adjusts a color by adding offset values to its RGBA components, clamping the results to valid ranges.

    When Called:
        When creating color variations for UI elements, hover states, or theme adjustments.
        When programmatically modifying colors for visual effects.

    Parameters:
        - color (Color): The base color to adjust.
        - rOffset (number): Red component offset (optional, default: 0).
        - gOffset (number): Green component offset (optional, default: 0).
        - bOffset (number): Blue component offset (optional, default: 0).
        - aOffset (number): Alpha component offset (optional, default: 0).

    Returns:
        Color - A new Color object with adjusted values.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Darken a color
        local baseColor = Color(200, 150, 100)
        local darkerColor = lia.color.adjust(baseColor, -50, -30, -20)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Create hover effect colors
        local buttonColor = Color(100, 150, 200)
        local hoverColor = lia.color.adjust(buttonColor, 20, 20, 20) -- Lighter
        local pressedColor = lia.color.adjust(buttonColor, -30, -30, -30) -- Darker
        ```

        High Complexity:

        ```lua
        -- High: Generate a color palette with variations
        local function generateColorPalette(baseColor)
            return {
                original = baseColor,
                light = lia.color.adjust(baseColor, 40, 40, 40),
                dark = lia.color.adjust(baseColor, -60, -60, -60),
                accent = lia.color.adjust(baseColor, 0, 50, -30),
                muted = lia.color.adjust(baseColor, -20, -20, -20, -50)
            }
        end

        local palette = generateColorPalette(Color(120, 180, 140))
        ```
]]
function lia.color.adjust(color, rOffset, gOffset, bOffset, aOffset)
        return Color(math.Clamp(color.r + rOffset, 0, 255), math.Clamp(color.g + gOffset, 0, 255), math.Clamp(color.b + bOffset, 0, 255), math.Clamp((color.a or 255) + (aOffset or 0), 0, 255))
    end

    --[[
    Purpose:
        Creates a darker version of a color by reducing its RGB components by a specified factor.

    When Called:
        When creating shadow colors, pressed button states, or darker color variations.
        When building color schemes that need darker accents.

    Parameters:
        - color (Color): The base color to darken.
        - factor (number): The darkening factor (0.0 to 1.0, default: 0.1). Higher values create darker colors.

    Returns:
        Color - A new Color object with reduced brightness.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Create a darker shade
        local baseColor = Color(200, 180, 160)
        local darkColor = lia.color.darken(baseColor, 0.3)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Create button states
        local buttonColor = Color(120, 160, 200)
        local normalColor = buttonColor
        local pressedColor = lia.color.darken(buttonColor, 0.2)
        ```

        High Complexity:

        ```lua
        -- High: Generate shadow color based on brightness
        local function createShadowColor(baseColor)
            local brightness = (baseColor.r * 0.299 + baseColor.g * 0.587 + baseColor.b * 0.114) / 255
            local shadowFactor = brightness > 0.5 and 0.4 or 0.2 -- Darker shadows for light colors
            return lia.color.darken(baseColor, shadowFactor)
        end

        local panelColor = Color(240, 240, 240)
        local shadowColor = createShadowColor(panelColor)
        ```
]]
function lia.color.darken(color, factor)
        factor = factor or 0.1
        local darkenFactor = 1 - math.Clamp(factor, 0, 1)
        return Color(math.floor(color.r * darkenFactor), math.floor(color.g * darkenFactor), math.floor(color.b * darkenFactor), color.a or 255)
    end

    --[[
    Purpose:
        Retrieves the name of the currently active theme.

    When Called:
        When checking which theme is currently applied.
        When making theme-dependent UI decisions.

    Parameters:
        None.

    Returns:
        string - The lowercase name of the current theme.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get current theme name
        local theme = lia.color.getCurrentTheme()
        print("Current theme:", theme)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Check theme for conditional styling
        local currentTheme = lia.color.getCurrentTheme()
        local isDarkTheme = currentTheme == "dark" or currentTheme == "dark mono"

        if isDarkTheme then
            -- Apply dark theme adjustments
            adjustForDarkTheme()
        end
        ```

        High Complexity:

        ```lua
        -- High: Theme-aware color selection
        local function getThemeAwareColor(colorName)
            local theme = lia.color.getCurrentTheme()
            local themeColors = {
                teal = {primary = Color(60, 140, 140), secondary = Color(140, 60, 140)},
                dark = {primary = Color(106, 108, 197), secondary = Color(197, 106, 108)},
                light = {primary = Color(106, 108, 197), secondary = Color(197, 108, 106)}
            }

            return themeColors[theme] and themeColors[theme][colorName] or Color(128, 128, 128)
        end

        local primaryColor = getThemeAwareColor("primary")
        ```
]]
function lia.color.getCurrentTheme()
        return lia.config.get("Theme", "Teal"):lower()
    end

    --[[
    Purpose:
        Retrieves the display name of the currently active theme.

    When Called:
        When displaying the current theme name to users.
        When logging theme changes or user preferences.

    Parameters:
        None.

    Returns:
        string - The display name of the current theme.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get current theme display name
        local themeName = lia.color.getCurrentThemeName()
        print("Current theme:", themeName)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Display theme in UI
        local currentThemeDisplay = lia.color.getCurrentThemeName()
        draw.SimpleText("Theme: " .. currentThemeDisplay, "liaMediumFont", x, y, Color(255, 255, 255))
        ```

        High Complexity:

        ```lua
        -- High: Theme change notification
        local oldTheme = lia.color.getCurrentThemeName()
        -- ... theme change logic ...
        local newTheme = lia.color.getCurrentThemeName()

        if oldTheme ~= newTheme then
            showNotification("Theme changed from " .. oldTheme .. " to " .. newTheme)
        end
        ```
]]
function lia.color.getCurrentThemeName()
        return lia.config.get("Theme", "Teal")
    end

    --[[
    Purpose:
        Retrieves the main accent color of the currently active theme.

    When Called:
        When accessing the primary theme color for UI elements.
        When creating theme-consistent color schemes.

    Parameters:
        None.

    Returns:
        Color - The main color of the current theme, or a default teal color if not found.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get main theme color
        local mainColor = lia.color.getMainColor()
        draw.SimpleText("Welcome", "liaLargeFont", x, y, mainColor)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Create theme-consistent button
        local accentColor = lia.color.getMainColor()
        local buttonColor = accentColor
        local hoverColor = lia.color.adjust(accentColor, 20, 20, 20)

        surface.SetDrawColor(buttonColor.r, buttonColor.g, buttonColor.b, buttonColor.a)
        surface.DrawRect(x, y, width, height)
        ```

        High Complexity:

        ```lua
        -- High: Generate complete color palette from theme
        local function createThemePalette()
            local mainColor = lia.color.getMainColor()
            return {
                primary = mainColor,
                secondary = lia.color.adjust(mainColor, -20, -10, 30),
                tertiary = lia.color.adjust(mainColor, 30, -20, 10),
                background = lia.color.darken(mainColor, 0.7),
                text = Color(240, 240, 240) -- Usually white/near-white for contrast
            }
        end

        local palette = createThemePalette()
        ```
]]
function lia.color.getMainColor()
        local currentTheme = lia.color.getCurrentTheme()
        local themeData = lia.color.themes[currentTheme]
        if themeData and themeData.maincolor then return themeData.maincolor end
        local defaultTheme = lia.color.themes["teal"]
        return defaultTheme and defaultTheme.maincolor or Color(80, 180, 180)
    end

    --[[
    Purpose:
        Applies a theme to the color system, optionally with smooth transitions.

    When Called:
        When changing the active theme.
        During initialization to set the default theme.
        When responding to user theme selection.

    Parameters:
        - themeName (string): The name of the theme to apply (optional, uses current if not provided).
        - useTransition (boolean): Whether to use smooth color transitions (optional, default: false).

    Returns:
        None.

    Realm:
        Client.

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Apply a theme immediately
        lia.color.applyTheme("Dark")
        ```

        Medium Complexity:

        ```lua
        -- Medium: Apply theme with smooth transition
        lia.color.applyTheme("Teal", true)
        ```

        High Complexity:

        ```lua
        -- High: Theme switching with validation and fallback
        local function safeApplyTheme(themeName, useTransition)
            local availableThemes = lia.color.getAllThemes()
            local themeExists = false

            for _, theme in ipairs(availableThemes) do
                if theme == themeName:lower() then
                    themeExists = true
                    break
                end
            end

            if themeExists then
                lia.color.applyTheme(themeName, useTransition)
                print("Applied theme:", themeName)
            else
                lia.color.applyTheme("Teal", useTransition) -- Fallback to default
                print("Theme not found, using default")
            end
        end

        safeApplyTheme("Purple", true)
        ```
]]
function lia.color.applyTheme(themeName, useTransition)
        themeName = themeName or lia.color.getCurrentTheme()
        local themeData = lia.color.themes[themeName]
        if not themeData then
            themeName = "Teal"
            themeData = lia.color.themes[themeName]
            if not themeData then
                lia.color.theme = {
                    maincolor = Color(80, 180, 180),
                    background = Color(24, 32, 32),
                    text = Color(210, 235, 235)
                }

                hook.Run("OnThemeChanged", themeName, useTransition)
                return
            else
                lia.config.set("Theme", themeName)
            end
        end

        if themeData then
            if useTransition and CLIENT then
                lia.color.startThemeTransition(themeName)
            else
                lia.color.theme = table.Copy(themeData)
            end

            hook.Run("OnThemeChanged", themeName, useTransition)
        end
    end

    --[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.isTransitionActive()
        return lia.color.transition and lia.color.transition.active or false
    end

    --[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.testThemeTransition(themeName)
        lia.color.applyTheme(themeName, true)
    end

    lia.color.transition = {
        active = false,
        to = nil,
        progress = 0,
        speed = 3,
        colorBlend = 8
    }

    --[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.startThemeTransition(name)
        local targetTheme = lia.color.themes[name:lower()]
        if not targetTheme then
            name = "Teal"
            targetTheme = lia.color.themes[name:lower()]
            if not targetTheme then return end
        end

        lia.color.transition.to = table.Copy(targetTheme)
        lia.color.transition.active = true
        lia.color.transition.progress = 0
        if not hook.GetTable().LiliaThemeTransition then
            hook.Add("Think", "LiliaThemeTransition", function()
                if not lia.color.transition.active then return end
                local dt = FrameTime()
                lia.color.transition.progress = math.min(lia.color.transition.progress + (lia.color.transition.speed * dt), 1)
                local to = lia.color.transition.to
                if not to then
                    lia.color.transition.active = false
                    hook.Remove("Think", "LiliaThemeTransition")
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
                    elseif istable(v) and #v > 0 then
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
                    hook.Remove("Think", "LiliaThemeTransition")
                    hook.Run("OnThemeChanged", name, false)
                end
            end)
        end
    end

    --[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.isColor(v)
        return istable(v) and isnumber(v.r) and isnumber(v.g) and isnumber(v.b) and isnumber(v.a)
    end

    --[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.returnMainAdjustedColors()
        local base = lia.color.getMainColor()
        local background = lia.color.adjust(base, -20, -10, -50, 0)
        local brightness = background.r * 0.299 + background.g * 0.587 + background.b * 0.114
        local textColor = brightness > 128 and Color(30, 30, 30, 255) or Color(245, 245, 220, 255)
        return {
            background = background,
            sidebar = lia.color.adjust(base, -30, -15, -60, -55),
            accent = base,
            text = textColor,
            hover = lia.color.adjust(base, -40, -25, -70, -35),
            border = Color(255, 255, 255, 255),
            highlight = Color(255, 255, 255, 30)
        }
    end

    --[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
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
            if c and istable(c) and c.r and c.g and c.b and c.a then return oldColor(c.r, c.g, c.b, c.a) end
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
end

--[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.registerTheme(name, themeData)
    local id = name:lower()
    lia.color.themes[id] = themeData
end

--[[
    Purpose:
        Retrieves a character by its ID, loading it if necessary.

    When Called:
        When a character needs to be accessed by ID, either from the server or the client.

    Parameters:
        - charID (number): The unique identifier of the character.
        - client (Player): The player requesting the character (optional).
        - callback (function): Function to call when the character is loaded (optional).

    Returns:
        Character object if found or loaded, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get a character by ID
        local character = lia.char.getCharacter(123)
        if character then
            print("Character name:", character:getName())
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get character with callback for async loading
        lia.char.getCharacter(123, client, function(character)
            if character then
                character:setMoney(1000)
                print("Character loaded:", character:getName())
            end
        end)
        ```

        High Complexity:

        ```lua
        -- High: Get multiple characters with validation and error handling
        local charIDs = {123, 456, 789}
        local loadedChars = {}

        for _, charID in ipairs(charIDs) do
            lia.char.getCharacter(charID, client, function(character)
                if character then
                    loadedChars[charID] = character
                    if table.Count(loadedChars) == #charIDs then
                        print("All characters loaded successfully")
                    end
                else
                    print("Failed to load character:", charID)
                end
            end)
        end
        ```
]]
function lia.color.getAllThemes()
    local themes = {}
    for id, _ in pairs(lia.color.themes) do
        themes[#themes + 1] = id
    end

    table.sort(themes)
    return themes
end

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
    theme = Color(60, 140, 140),
    maincolor = Color(60, 140, 140),
    panel = {Color(34, 62, 62), Color(38, 66, 66), Color(50, 110, 110)},
    panel_alpha = {ColorAlpha(Color(34, 62, 62), 110), ColorAlpha(Color(38, 66, 66), 110), ColorAlpha(Color(50, 110, 110), 110)},
    focus_panel = Color(48, 72, 72),
    hover = Color(60, 140, 140, 90),
    window_shadow = Color(18, 32, 32, 90),
    gray = Color(150, 180, 180, 200),
    text = Color(210, 235, 235),
    text_entry = Color(210, 235, 235),
    accent = Color(60, 140, 140),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Dark", {
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
    maincolor = Color(106, 108, 197),
    panel = {Color(60, 60, 60), Color(50, 50, 50), Color(80, 80, 80)},
    panel_alpha = {ColorAlpha(Color(60, 60, 60), 150), ColorAlpha(Color(50, 50, 50), 150), ColorAlpha(Color(80, 80, 80), 150)},
    toggle = Color(56, 56, 56),
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(150, 150, 150, 220),
    text = Color(255, 255, 255),
    text_entry = Color(255, 255, 255),
    accent = Color(106, 108, 197),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Dark Mono", {
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
    theme = Color(121, 121, 121),
    maincolor = Color(121, 121, 121),
    panel = {Color(60, 60, 60), Color(50, 50, 50), Color(80, 80, 80)},
    panel_alpha = {ColorAlpha(Color(60, 60, 60), 150), ColorAlpha(Color(50, 50, 50), 150), ColorAlpha(Color(80, 80, 80), 150)},
    toggle = Color(56, 56, 56),
    focus_panel = Color(46, 46, 46),
    hover = Color(60, 65, 80),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(150, 150, 150, 220),
    text = Color(255, 255, 255),
    text_entry = Color(255, 255, 255),
    accent = Color(121, 121, 121),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Blue", {
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
    maincolor = Color(80, 160, 220),
    panel = {Color(34, 48, 72), Color(38, 54, 82), Color(70, 120, 180)},
    panel_alpha = {ColorAlpha(Color(34, 48, 72), 110), ColorAlpha(Color(38, 54, 82), 110), ColorAlpha(Color(70, 120, 180), 110)},
    toggle = Color(34, 44, 66),
    focus_panel = Color(48, 72, 90),
    hover = Color(80, 160, 220, 90),
    window_shadow = Color(18, 22, 32, 100),
    gray = Color(150, 170, 190, 200),
    text = Color(210, 220, 235),
    text_entry = Color(210, 220, 235),
    accent = Color(80, 160, 220),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Red", {
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
    maincolor = Color(180, 80, 80),
    panel = {Color(62, 34, 34), Color(66, 38, 38), Color(140, 70, 70)},
    panel_alpha = {ColorAlpha(Color(62, 34, 34), 110), ColorAlpha(Color(66, 38, 38), 110), ColorAlpha(Color(140, 70, 70), 110)},
    toggle = Color(60, 34, 34),
    focus_panel = Color(72, 48, 48),
    hover = Color(180, 80, 80, 90),
    window_shadow = Color(32, 18, 18, 100),
    gray = Color(180, 150, 150, 200),
    text = Color(235, 210, 210),
    text_entry = Color(235, 210, 210),
    accent = Color(180, 80, 80),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Light", {
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
    maincolor = Color(106, 108, 197),
    panel = {Color(250, 250, 255), Color(240, 240, 245), Color(230, 230, 235)},
    panel_alpha = {ColorAlpha(Color(250, 250, 255), 120), ColorAlpha(Color(240, 240, 245), 120), ColorAlpha(Color(230, 230, 235), 120)},
    toggle = Color(220, 220, 230),
    focus_panel = Color(245, 245, 255),
    hover = Color(235, 240, 255),
    window_shadow = Color(0, 0, 0, 50),
    gray = Color(130, 130, 130, 220),
    text = Color(20, 20, 20),
    text_entry = Color(20, 20, 20),
    accent = Color(106, 108, 197),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Green", {
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
    maincolor = Color(80, 180, 120),
    panel = {Color(34, 62, 44), Color(38, 66, 48), Color(70, 140, 90)},
    panel_alpha = {ColorAlpha(Color(34, 62, 44), 110), ColorAlpha(Color(38, 66, 48), 110), ColorAlpha(Color(70, 140, 90), 110)},
    toggle = Color(34, 60, 44),
    focus_panel = Color(48, 72, 58),
    hover = Color(80, 180, 120, 90),
    window_shadow = Color(18, 32, 22, 100),
    gray = Color(150, 180, 150, 200),
    text = Color(210, 235, 210),
    text_entry = Color(210, 235, 210),
    accent = Color(80, 180, 120),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Orange", {
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
    maincolor = Color(245, 130, 50),
    panel = {Color(255, 250, 240), Color(250, 220, 180), Color(235, 150, 90)},
    panel_alpha = {ColorAlpha(Color(255, 250, 240), 120), ColorAlpha(Color(250, 220, 180), 120), ColorAlpha(Color(235, 150, 90), 120)},
    toggle = Color(143, 121, 104),
    focus_panel = Color(255, 240, 225),
    hover = Color(255, 165, 80, 90),
    window_shadow = Color(20, 8, 0, 100),
    gray = Color(180, 161, 150, 200),
    text = Color(45, 20, 10),
    text_entry = Color(45, 20, 10),
    accent = Color(245, 130, 50),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Purple", {
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
    maincolor = Color(138, 114, 219),
    panel = {Color(56, 48, 76), Color(44, 36, 64), Color(120, 90, 200)},
    panel_alpha = {ColorAlpha(Color(56, 48, 76), 150), ColorAlpha(Color(44, 36, 64), 150), ColorAlpha(Color(120, 90, 200), 150)},
    toggle = Color(43, 39, 53),
    focus_panel = Color(48, 42, 62),
    hover = Color(138, 114, 219, 90),
    window_shadow = Color(8, 6, 20, 100),
    gray = Color(140, 128, 148, 220),
    text = Color(245, 240, 255),
    text_entry = Color(245, 240, 255),
    accent = Color(138, 114, 219),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Coffee", {
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
    maincolor = Color(150, 110, 75),
    panel = {Color(68, 50, 40), Color(90, 65, 50), Color(150, 110, 75)},
    panel_alpha = {ColorAlpha(Color(68, 50, 40), 110), ColorAlpha(Color(90, 65, 50), 110), ColorAlpha(Color(150, 110, 75), 110)},
    toggle = Color(53, 40, 31),
    focus_panel = Color(70, 55, 40),
    hover = Color(150, 110, 75, 90),
    window_shadow = Color(15, 10, 5, 100),
    gray = Color(180, 150, 130, 200),
    text = Color(235, 225, 210),
    text_entry = Color(235, 225, 210),
    accent = Color(150, 110, 75),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Ice", {
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
    maincolor = Color(100, 170, 230),
    panel = {Color(146, 186, 211), Color(107, 157, 190), Color(74, 132, 184)},
    panel_alpha = {ColorAlpha(Color(146, 186, 211), 120), ColorAlpha(Color(107, 157, 190), 120), ColorAlpha(Color(74, 132, 184), 120)},
    toggle = Color(168, 194, 219),
    focus_panel = Color(205, 230, 245),
    hover = Color(100, 170, 230, 80),
    window_shadow = Color(60, 100, 140, 100),
    gray = Color(92, 112, 133, 200),
    text = Color(20, 35, 50),
    text_entry = Color(20, 35, 50),
    accent = Color(100, 170, 230),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Wine", {
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
    maincolor = Color(148, 61, 91),
    panel = {Color(79, 50, 60), Color(63, 44, 48), Color(160, 85, 143)},
    panel_alpha = {ColorAlpha(Color(79, 50, 60), 150), ColorAlpha(Color(63, 44, 48), 150), ColorAlpha(Color(160, 85, 143), 150)},
    toggle = Color(63, 40, 47),
    focus_panel = Color(70, 48, 58),
    hover = Color(192, 122, 217, 90),
    window_shadow = Color(10, 6, 20, 100),
    gray = Color(170, 150, 160, 200),
    text = Color(246, 242, 246),
    text_entry = Color(246, 242, 246),
    accent = Color(148, 61, 91),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Violet", {
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
    maincolor = Color(159, 180, 255),
    panel = {Color(58, 64, 84), Color(48, 52, 72), Color(109, 136, 255)},
    panel_alpha = {ColorAlpha(Color(58, 64, 84), 150), ColorAlpha(Color(48, 52, 72), 150), ColorAlpha(Color(109, 136, 255), 150)},
    toggle = Color(46, 51, 66),
    focus_panel = Color(56, 62, 86),
    hover = Color(159, 180, 255, 90),
    window_shadow = Color(8, 6, 20, 100),
    gray = Color(147, 147, 184, 200),
    text = Color(238, 244, 255),
    text_entry = Color(238, 244, 255),
    accent = Color(159, 180, 255),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Moss", {
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
    maincolor = Color(110, 160, 90),
    panel = {Color(40, 56, 40), Color(66, 86, 66), Color(110, 160, 90)},
    panel_alpha = {ColorAlpha(Color(40, 56, 40), 150), ColorAlpha(Color(66, 86, 66), 150), ColorAlpha(Color(110, 160, 90), 150)},
    toggle = Color(35, 44, 34),
    focus_panel = Color(46, 58, 44),
    hover = Color(110, 160, 90, 90),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(148, 165, 140, 220),
    text = Color(232, 244, 235),
    text_entry = Color(232, 244, 235),
    accent = Color(110, 160, 90),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.color.registerTheme("Coral", {
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
    maincolor = Color(255, 120, 90),
    panel = {Color(66, 38, 40), Color(120, 60, 56), Color(240, 120, 90)},
    panel_alpha = {ColorAlpha(Color(66, 38, 40), 150), ColorAlpha(Color(120, 60, 56), 150), ColorAlpha(Color(240, 120, 90), 150)},
    toggle = Color(58, 39, 37),
    focus_panel = Color(72, 42, 44),
    hover = Color(255, 120, 90, 90),
    window_shadow = Color(0, 0, 0, 100),
    gray = Color(167, 136, 136, 220),
    text = Color(255, 243, 242),
    text_entry = Color(255, 243, 242),
    accent = Color(255, 120, 90),
    chat = Color(255, 239, 150),
    chatListen = Color(168, 240, 170)
})

lia.config.add("Theme", "theme", "Teal", function(_, newValue)
    if CLIENT then
        if not lia.color.themes[newValue] then
            newValue = "Teal"
            if not lia.color.themes[newValue] then return end
        end

        lia.color.applyTheme(newValue, true)
    end
end, {
    desc = "themeDesc",
    category = "categoryVisuals",
    type = "Table",
    options = function()
        local themes = {}
        local themeIDs = lia.color.getAllThemes()
        for _, themeID in ipairs(themeIDs) do
            local displayName = themeID:gsub("_", " "):gsub("(%a)([%w]*)", function(first, rest) return first:upper() .. rest:lower() end)
            themes[displayName] = themeID
        end
        return themes
    end
})
