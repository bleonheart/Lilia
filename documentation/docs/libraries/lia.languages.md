# Languages Library

This page documents the functions for working with localization and language management.

---

## Overview

The languages library (`lia.lang`) provides a comprehensive localization system for the Lilia framework. It handles loading language files, managing translations, and providing localized strings throughout the gamemode. The library supports multiple languages, fallback handling, and dynamic language switching.

---

### lia.lang.loadFromDir

**Purpose**

Loads all language files from a specified directory.

**Parameters**

* `directory` (*string*): The directory path containing language files.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Load languages from default directory
lia.lang.loadFromDir("lilia/gamemode/languages")

-- Load languages from custom directory
lia.lang.loadFromDir("gamemode/languages")

-- Load additional languages
lia.lang.loadFromDir("addons/myaddon/languages")

-- Load languages during initialization
hook.Add("Initialize", "LoadLanguages", function()
    lia.lang.loadFromDir("gamemode/languages")
end)
```

---

### lia.lang.AddTable

**Purpose**

Adds a table of localized strings to a specific language.

**Parameters**

* `name` (*string*): The language name (e.g., "english", "spanish").
* `tbl` (*table*): A table of key-value pairs for localized strings.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Add English translations
lia.lang.AddTable("english", {
    welcome = "Welcome to the server!",
    goodbye = "Goodbye!",
    itemReceived = "You received %s!"
})

-- Add Spanish translations
lia.lang.AddTable("spanish", {
    welcome = "¡Bienvenido al servidor!",
    goodbye = "¡Adiós!",
    itemReceived = "¡Recibiste %s!"
})

-- Add custom language
lia.lang.AddTable("french", {
    welcome = "Bienvenue sur le serveur!",
    goodbye = "Au revoir!",
    itemReceived = "Vous avez reçu %s!"
})

-- Update existing translations
lia.lang.AddTable("english", {
    newMessage = "This is a new message!"
})
```

---

### lia.lang.getLanguages

**Purpose**

Gets a list of all available languages.

**Returns**

* `languages` (*table*): An array of available language names.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all available languages
local languages = lia.lang.getLanguages()
print("Available languages:")
for _, lang in ipairs(languages) do
    print("  - " .. lang)
end

-- Create language selection UI
local function createLanguageSelector()
    local languages = lia.lang.getLanguages()
    local comboBox = vgui.Create("DComboBox")

    for _, lang in ipairs(languages) do
        comboBox:AddChoice(lang)
    end

    return comboBox
end

-- Check if language exists
local function languageExists(languageName)
    local languages = lia.lang.getLanguages()
    for _, lang in ipairs(languages) do
        if lang:lower() == languageName:lower() then
            return true
        end
    end
    return false
end
```

---

### L (Global Function)

**Purpose**

Retrieves a localized string and formats it with provided arguments.

**Parameters**

* `key` (*string*): The localization key to look up.
* `...` (*any*): Optional arguments for string formatting.

**Returns**

* `localizedString` (*string*): The localized and formatted string.

**Realm**

Shared.

**Example Usage**

```lua
-- Simple localization
local welcomeMessage = L("welcome")
print(welcomeMessage) -- "Welcome to the server!" (in English)

-- Localization with formatting
local itemMessage = L("itemReceived", "Health Kit")
print(itemMessage) -- "You received Health Kit!"

-- Multiple arguments
local complexMessage = L("playerAction", player:Name(), "picked up", itemName)
print(complexMessage) -- "PlayerName picked up Health Kit"

-- Fallback handling
local missingKey = L("nonexistentKey")
print(missingKey) -- "nonexistentKey" (fallback to key name)

-- Table arguments
local items = {"apple", "banana", "orange"}
local listMessage = L("itemList", items)
print(listMessage) -- "Items: apple, banana, orange"
```

## Language File Format

Language files should follow this structure:

### File Structure
```
lilia/gamemode/languages/
├── english.lua
├── spanish.lua
├── french.lua
└── german.lua
```

### File Content Example (english.lua)
```lua
NAME = "English"

LANGUAGE = {
    -- Basic messages
    welcome = "Welcome to the server!",
    goodbye = "Goodbye!",

    -- Formatted messages
    itemReceived = "You received %s!",
    playerJoined = "Player %s has joined the server!",
    moneySpent = "You spent %s on %s.",

    -- Complex messages
    questComplete = "Congratulations! You completed '%s' and earned %s XP!",
    tradeOffer = "%s wants to trade %s for %s.",

    -- UI elements
    buttonAccept = "Accept",
    buttonDecline = "Decline",
    buttonCancel = "Cancel",

    -- Error messages
    insufficientFunds = "You don't have enough money!",
    itemNotFound = "Item not found!",
    permissionDenied = "You don't have permission to do that!",

    -- Categories
    categoryWeapons = "Weapons",
    categoryArmor = "Armor",
    categoryConsumables = "Consumables"
}
```

### File Content Example (spanish.lua)
```lua
NAME = "Español"

LANGUAGE = {
    welcome = "¡Bienvenido al servidor!",
    goodbye = "¡Adiós!",
    itemReceived = "¡Recibiste %s!",
    playerJoined = "El jugador %s se ha unido al servidor!",
    moneySpent = "Gastaste %s en %s.",
    questComplete = "¡Felicidades! Completaste '%s' y ganaste %s XP!",
    tradeOffer = "%s quiere intercambiar %s por %s.",
    buttonAccept = "Aceptar",
    buttonDecline = "Rechazar",
    buttonCancel = "Cancelar",
    insufficientFunds = "¡No tienes suficiente dinero!",
    itemNotFound = "¡Objeto no encontrado!",
    permissionDenied = "¡No tienes permiso para hacer eso!",
    categoryWeapons = "Armas",
    categoryArmor = "Armadura",
    categoryConsumables = "Consumibles"
}
```

## Language Configuration

The current language is controlled by the configuration system:

### Setting the Language
```lua
-- Set server language to Spanish
lia.config.set("Language", "spanish")

-- Set server language to English
lia.config.set("Language", "english")

-- Get current language
local currentLang = lia.config.get("Language", "english")
print("Current language: " .. currentLang)
```

### Client-side Language Selection
```lua
-- Client can set their preferred language
if CLIENT then
    -- This would typically be done through a UI setting
    local function setClientLanguage(language)
        net.Start("liaSetLanguage")
        net.WriteString(language)
        net.SendToServer()
    end
end
```

## Best Practices

### 1. Consistent Key Naming
```lua
-- Good: Descriptive and consistent
LANGUAGE = {
    playerJoined = "Player %s joined!",
    playerLeft = "Player %s left!",
    playerKicked = "Player %s was kicked!"
}

-- Avoid: Inconsistent naming
LANGUAGE = {
    joinMsg = "Player %s joined!",
    left_message = "Player %s left!",
    kickPlayer = "Player %s was kicked!"
}
```

### 2. Proper Formatting
```lua
-- Good: Proper format specifiers
LANGUAGE = {
    moneyReceived = "You received %s dollars!",
    itemsPurchased = "You bought %d items for %s dollars!"
}

-- Avoid: Mixed format specifiers
LANGUAGE = {
    badExample = "You have %d items and %s money" -- Inconsistent
}
```

### 3. Fallback Support
```lua
-- Always provide fallback for missing keys
local message = L("optionalFeature", "Default Message")
```

### 4. Table Handling
```lua
-- Handle table arguments properly
LANGUAGE = {
    itemList = "Items: %s",
    playerList = "Players: %s"
}

-- Usage
local items = {"sword", "shield", "potion"}
local message = L("itemList", items) -- "Items: sword, shield, potion"
```

### 5. Categorization
```lua
-- Organize keys by category
LANGUAGE = {
    -- UI Messages
    ui_confirm = "Confirm",
    ui_cancel = "Cancel",

    -- Game Messages
    game_welcome = "Welcome!",
    game_goodbye = "Goodbye!",

    -- Error Messages
    error_noPermission = "No permission!",
    error_invalidItem = "Invalid item!"
}
```

### 6. Special Characters
```lua
-- Handle special characters properly
LANGUAGE = {
    price = "Price: %s€", -- Euro symbol
    percent = "Health: %s%%", -- Percent symbol (escaped)
    newline = "Line 1\nLine 2", -- Newline character
    quote = 'He said "Hello"', -- Quotes
    apostrophe = "It's working!" -- Apostrophe
}
```

## Common Issues and Solutions

### Format Specifier Errors
```lua
-- Problem: Wrong format specifier
LANGUAGE = {
    badFormat = "You have %d dollars" -- Wrong for string
}

-- Solution: Use correct specifier
LANGUAGE = {
    goodFormat = "You have %s dollars" -- Correct for string
}
```

### Missing Arguments
```lua
-- Problem: Not enough arguments provided
L("requiresTwoArgs", "only one") -- Error!

-- Solution: Provide all required arguments
L("requiresTwoArgs", "first", "second")
```

### Language File Loading
```lua
-- Problem: Language file not loading
-- Check file naming convention
-- Must be: sh_english.lua or english.lua

-- Problem: LANGUAGE table not defined
-- Solution: Always define LANGUAGE table
LANGUAGE = {
    -- Your translations here
}
```

### Configuration Issues
```lua
-- Problem: Language not changing
-- Check configuration value
lia.config.get("Language") -- Should return valid language name

-- Problem: Invalid language name
lia.config.set("Language", "invalid") -- Won't work
lia.config.set("Language", "english") -- Correct
```

## Advanced Usage

### Dynamic Language Loading
```lua
-- Load language files dynamically
local function loadCustomLanguage(languageName, translations)
    lia.lang.AddTable(languageName, translations)
    print("Loaded custom language: " .. languageName)
end

-- Load from external source
local function loadLanguageFromWeb(languageName, url)
    http.Fetch(url, function(body)
        local translations = util.JSONToTable(body)
        if translations then
            lia.lang.AddTable(languageName, translations)
        end
    end)
end
```

### Language Validation
```lua
-- Validate language table
local function validateLanguageTable(languageTable)
    local requiredKeys = {"welcome", "goodbye", "error_noPermission"}

    for _, key in ipairs(requiredKeys) do
        if not languageTable[key] then
            print("Missing required key: " .. key)
            return false
        end
    end

    return true
end

-- Validate all languages
local function validateAllLanguages()
    for langName, langTable in pairs(lia.lang.stored) do
        if not validateLanguageTable(langTable) then
            print("Invalid language: " .. langName)
        end
    end
end
```

### Language Statistics
```lua
-- Get language statistics
local function getLanguageStats()
    local stats = {}

    for langName, langTable in pairs(lia.lang.stored) do
        stats[langName] = {
            name = lia.lang.names[langName] or langName,
            keyCount = table.Count(langTable),
            keys = table.GetKeys(langTable)
        }
    end

    return stats
end

-- Display language coverage
local function displayLanguageCoverage()
    local stats = getLanguageStats()
    local baseLang = stats["english"]

    if not baseLang then return end

    for langName, langStats in pairs(stats) do
        if langName ~= "english" then
            local coverage = (langStats.keyCount / baseLang.keyCount) * 100
            print(string.format("%s: %.1f%% complete (%d/%d keys)",
                langStats.name, coverage, langStats.keyCount, baseLang.keyCount))
        end
    end
end
```