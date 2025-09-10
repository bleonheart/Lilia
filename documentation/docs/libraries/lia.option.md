# lia.option

## Overview
The `lia.option` library provides client-side option management for Lilia. It handles storing, loading, and managing user preferences with automatic UI generation and persistence.

## Functions

### lia.option.add
**Purpose**: Adds a new option to the options system (Client only).

**Parameters**:
- `key` (string): Unique key for the option
- `name` (string): Display name for the option
- `desc` (string): Description of the option
- `default` (any): Default value for the option
- `callback` (function): Callback function when option changes (optional)
- `data` (table): Additional option data (category, min, max, etc.)

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Add a boolean option
lia.option.add("showHUD", "Show HUD", "Toggle HUD visibility", true, function(old, new)
    print("HUD visibility changed from", old, "to", new)
end, {
    category = "Display",
    isQuick = true
})

-- Add a numeric option
lia.option.add("volume", "Volume", "Master volume level", 0.5, nil, {
    category = "Audio",
    min = 0,
    max = 1,
    decimals = 2
})

-- Add a color option
lia.option.add("hudColor", "HUD Color", "Color of the HUD elements", Color(255, 255, 255), nil, {
    category = "Display"
})

-- Add a table/choice option
lia.option.add("language", "Language", "Game language", "English", nil, {
    category = "General",
    options = {"English", "Spanish", "French", "German"}
})
```

### lia.option.getOptions
**Purpose**: Gets the options for a table-type option (Client only).

**Parameters**:
- `key` (string): Option key

**Returns**: Table of options

**Realm**: Client

**Example Usage**:
```lua
-- Get options for a choice option
local options = lia.option.getOptions("language")
for _, option in ipairs(options) do
    print("Available language:", option)
end

-- Use in UI
local combo = vgui.Create("DComboBox")
local options = lia.option.getOptions("weaponSelector")
for _, option in ipairs(options) do
    combo:AddChoice(option)
end
```

### lia.option.set
**Purpose**: Sets the value of an option (Client only).

**Parameters**:
- `key` (string): Option key
- `value` (any): New value

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Set option value
lia.option.set("showHUD", false)
lia.option.set("volume", 0.8)
lia.option.set("hudColor", Color(255, 0, 0))

-- Set with callback
lia.option.set("language", "Spanish")
-- Callback will be triggered automatically
```

### lia.option.get
**Purpose**: Gets the value of an option (Client only).

**Parameters**:
- `key` (string): Option key
- `default` (any): Default value if option not found

**Returns**: Option value or default

**Realm**: Client

**Example Usage**:
```lua
-- Get option value
local showHUD = lia.option.get("showHUD", true)
local volume = lia.option.get("volume", 0.5)
local hudColor = lia.option.get("hudColor", Color(255, 255, 255))

-- Use in rendering
local hudColor = lia.option.get("hudColor")
surface.SetDrawColor(hudColor)
surface.DrawRect(0, 0, 100, 100)
```

### lia.option.save
**Purpose**: Saves all options to file (Client only).

**Parameters**: None

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Save options
lia.option.save()

-- Save after setting multiple options
lia.option.set("showHUD", false)
lia.option.set("volume", 0.8)
lia.option.save()
```

### lia.option.load
**Purpose**: Loads options from file (Client only).

**Parameters**: None

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Load options
lia.option.load()

-- This is typically called during initialization
hook.Add("Initialize", "LoadOptions", function()
    lia.option.load()
end)
```
