# lia.languages

## Overview
The `lia.languages` library provides comprehensive localization support for Lilia, allowing the gamemode to support multiple languages. It handles language loading, storage, and provides the main localization function for translating text.

## Functions

### lia.lang.loadFromDir
**Purpose**: Loads language files from a directory.

**Parameters**:
- `directory` (string): Directory path containing language files

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Load languages from default directory
lia.lang.loadFromDir("gamemode/languages")

-- Load custom languages
lia.lang.loadFromDir("addons/myaddon/languages")

-- Load languages from multiple directories
lia.lang.loadFromDir("gamemode/languages")
lia.lang.loadFromDir("addons/customaddon/languages")
```

### lia.lang.AddTable
**Purpose**: Adds a language table to the stored languages.

**Parameters**:
- `name` (string): Language name
- `tbl` (table): Language table containing key-value pairs

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Add custom language table
lia.lang.AddTable("english", {
    ["welcome"] = "Welcome to the server!",
    ["goodbye"] = "Goodbye!",
    ["playerJoined"] = "%s has joined the server"
})

-- Add language from external source
local customLang = {
    ["customMessage"] = "This is a custom message",
    ["anotherMessage"] = "Another custom message"
}
lia.lang.AddTable("custom", customLang)
```

### lia.lang.getLanguages
**Purpose**: Gets a list of all available languages.

**Parameters**: None

**Returns**: Array of language names

**Realm**: Shared

**Example Usage**:
```lua
-- Get all available languages
local languages = lia.lang.getLanguages()
print("Available languages:")
for _, lang in ipairs(languages) do
    print("- " .. lang)
end

-- Use in language selection menu
local langOptions = lia.lang.getLanguages()
local combo = vgui.Create("DComboBox")
for _, lang in ipairs(langOptions) do
    combo:AddChoice(lang)
end
```

### L
**Purpose**: Main localization function that translates a key to the current language.

**Parameters**:
- `key` (string): Localization key
- `...` (any): Format arguments for the localized string

**Returns**: Localized string

**Realm**: Shared

**Example Usage**:
```lua
-- Simple localization
local welcomeText = L("welcome")
print(welcomeText) -- Outputs: "Welcome to the server!"

-- Localization with arguments
local playerName = "John"
local joinMessage = L("playerJoined", playerName)
print(joinMessage) -- Outputs: "John has joined the server"

-- Multiple arguments
local message = L("playerAction", "John", "killed", "Zombie")
print(message) -- Outputs formatted string

-- Fallback to key if not found
local unknownKey = L("nonexistentKey")
print(unknownKey) -- Outputs: "nonexistentKey"

-- Complex formatting
local complexMessage = L("complexFormat", {
    "Item1", "Item2", "Item3"
})
print(complexMessage) -- Outputs formatted string with table values
```