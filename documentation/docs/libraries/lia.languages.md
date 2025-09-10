# Languages Library

This page documents the functions for working with localization and language management.

---

## Overview

The languages library (`lia.lang`) provides a comprehensive localization system for the Lilia framework. It handles loading language files, storing translations, and providing localized strings with proper formatting and fallback support.

---

### lia.lang.loadFromDir

**Purpose**

Loads language files from a specified directory.

**Parameters**

* `directory` (*string*): The directory path containing language files.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Load languages from default directory
lia.lang.loadFromDir("lilia/gamemode/languages")

-- Load from custom directory
lia.lang.loadFromDir("custom/languages")
```

---

### lia.lang.AddTable

**Purpose**

Adds a table of localized strings to a language.

**Parameters**

* `name` (*string*): The language name.
* `tbl` (*table*): The table of localized strings with keys and values.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Add custom translations
lia.lang.AddTable("english", {
    customMessage = "This is a custom message",
    welcomePlayer = "Welcome, %s!"
})

-- Add translations for multiple languages
lia.lang.AddTable("spanish", {
    customMessage = "Este es un mensaje personalizado",
    welcomePlayer = "¡Bienvenido, %s!"
})
```

---

### lia.lang.getLanguages

**Purpose**

Gets a list of all available languages.

**Returns**

* `languages` (*table*): Array of language names, sorted alphabetically.

**Realm**

Shared.

**Example Usage**

```lua
-- Get all available languages
local languages = lia.lang.getLanguages()
for _, lang in ipairs(languages) do
    print("Available language: " .. lang)
end

-- Use in UI dropdown
local comboBox = vgui.Create("DComboBox")
for _, lang in ipairs(lia.lang.getLanguages()) do
    comboBox:AddChoice(lang)
end
```

---

### L (Localization Function)

**Purpose**

Retrieves a localized string and formats it with provided arguments.

**Parameters**

* `key` (*string*): The localization key.
* `...` (*any*): Optional arguments for string formatting.

**Returns**

* `localizedString` (*string*): The localized and formatted string, or the key if not found.

**Realm**

Shared.

**Example Usage**

```lua
-- Simple localization
local message = L("welcome")
print(message) -- "Welcome" (if defined in current language)

-- Localization with arguments
local greeting = L("welcomePlayer", player:Name())
print(greeting) -- "Welcome, John!" (if defined with %s placeholder)

-- Multiple arguments
local status = L("playerStats", player:Name(), player:Health(), player:Armor())
print(status) -- "John has 100 HP and 50 armor"

-- Fallback for missing keys
local unknown = L("nonexistentKey")
print(unknown) -- "nonexistentKey" (returns key if not found)
```

---

## Language File Structure

Language files should follow this structure:

```lua
-- sh_english.lua
NAME = "English"

LANGUAGE = {
    -- Basic strings
    welcome = "Welcome",
    goodbye = "Goodbye",

    -- Strings with placeholders
    welcomePlayer = "Welcome, %s!",
    playerStats = "%s has %s HP and %s armor",

    -- Complex strings
    itemDescription = "This is a %s that costs %s dollars",

    -- Nested keys
    menu = {
        file = "File",
        edit = "Edit",
        help = "Help"
    }
}
```

---

## Configuration Integration

The languages library integrates with the configuration system:

```lua
-- Get current language setting
local currentLang = lia.config.get("Language", "english")

-- Set language
lia.config.set("Language", "spanish")
```

---

## Hooks

### OnLocalizationLoaded
Called after all language files have been loaded.

**Example Usage:**
```lua
hook.Add("OnLocalizationLoaded", "CustomTranslations", function()
    -- Add custom translations after loading
    lia.lang.AddTable("english", {
        customKey = "Custom translation"
    })
end)
```

---

## Best Practices

1. **Use Descriptive Keys**: Use clear, descriptive keys that indicate their purpose
   ```lua
   -- Good
   itemNotFound = "Item not found"
   playerJoined = "Player joined the server"

   -- Bad
   msg1 = "Item not found"
   p_join = "Player joined the server"
   ```

2. **Handle Plurals**: Use different keys for singular and plural forms
   ```lua
   itemSingular = "You have 1 item"
   itemPlural = "You have %s items"
   ```

3. **Use Placeholders**: Use string formatting for dynamic content
   ```lua
   playerMessage = "%s: %s"
   -- Usage: L("playerMessage", playerName, message)
   ```

4. **Provide Context**: Include context in keys when needed
   ```lua
   buttonAccept = "Accept"
   buttonDecline = "Decline"
   menuAccept = "Accept Terms"
   menuDecline = "Decline Terms"
   ```

---

## Error Handling

The library includes built-in error handling:

- **Invalid Format Specifiers**: Detects and reports invalid format specifiers in translation strings
- **Missing Arguments**: Provides empty strings for missing arguments
- **Fallback**: Returns the key if no translation is found
- **Type Conversion**: Automatically converts tables to comma-separated strings

---

## Example Implementation

```lua
-- In a language file (sh_english.lua)
NAME = "English"

LANGUAGE = {
    -- UI elements
    buttonSave = "Save",
    buttonCancel = "Cancel",
    buttonDelete = "Delete",

    -- Messages
    saveSuccess = "Settings saved successfully",
    deleteConfirm = "Are you sure you want to delete '%s'?",
    playerCount = "There are %s players online",

    -- Item descriptions
    itemHealthPack = "Restores %s health points",
    itemAmmo = "%s rounds of ammunition",

    -- Error messages
    errorNoPermission = "You don't have permission to do this",
    errorInvalidInput = "Invalid input: %s"
}

-- Usage in code
if CLIENT then
    -- UI button
    local saveButton = vgui.Create("DButton")
    saveButton:SetText(L("buttonSave"))

    -- Confirmation dialog
    function confirmDelete(itemName)
        Derma_Query(L("deleteConfirm", itemName), L("confirm"), L("buttonDelete"), function()
            -- Delete logic here
            notification.AddLegacy(L("deleteSuccess", itemName), NOTIFY_GENERIC, 3)
        end, L("buttonCancel"))
    end

    -- Status display
    hook.Add("HUDPaint", "PlayerCountDisplay", function()
        local playerCount = #player.GetAll()
        draw.SimpleText(L("playerCount", playerCount), "DermaDefault", 10, 10)
    end)
end
```