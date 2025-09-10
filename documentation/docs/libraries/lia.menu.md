# lia.menu

## Overview
The `lia.menu` library provides a 3D context menu system for Lilia, allowing players to interact with entities and world positions through floating menus. It supports entity-based and position-based menus with smooth animations and hover effects.

## Functions

### lia.menu.add
**Purpose**: Adds a new context menu with specified options and position.

**Parameters**:
- `opts` (table): Table of menu options with text keys and callback functions
- `pos` (Vector|Entity): Position or entity for the menu
- `onRemove` (function): Callback function when menu is removed

**Returns**: Menu index in the menu list

**Realm**: Client

**Example Usage**:
```lua
-- Add position-based menu
local menuIndex = lia.menu.add({
    ["Open Door"] = function()
        print("Opening door...")
    end,
    ["Lock Door"] = function()
        print("Locking door...")
    end,
    ["Close"] = function()
        print("Closing menu...")
    end
}, Vector(100, 200, 50))

-- Add entity-based menu
local door = ents.FindByClass("prop_door_rotating")[1]
if IsValid(door) then
    local menuIndex = lia.menu.add({
        ["Inspect"] = function()
            print("Inspecting door...")
        end,
        ["Use"] = function()
            door:Use(LocalPlayer())
        end
    }, door)
end

-- Add menu with removal callback
local menuIndex = lia.menu.add({
    ["Action 1"] = function()
        print("Action 1 executed")
    end,
    ["Action 2"] = function()
        print("Action 2 executed")
    end
}, Vector(0, 0, 0), function()
    print("Menu was removed")
end)
```

### lia.menu.drawAll
**Purpose**: Draws all active context menus on the screen.

**Parameters**: None

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- This is typically called automatically in a hook
-- But you can call it manually if needed
lia.menu.drawAll()

-- Hook example for custom drawing
hook.Add("HUDPaint", "DrawCustomMenus", function()
    lia.menu.drawAll()
end)
```

### lia.menu.getActiveMenu
**Purpose**: Gets the currently active menu and selected item.

**Parameters**: None

**Returns**: 
- `menuIndex` (number): Index of the active menu
- `itemCallback` (function): Callback function for the selected item

**Realm**: Client

**Example Usage**:
```lua
-- Get active menu
local menuIndex, itemCallback = lia.menu.getActiveMenu()
if menuIndex and itemCallback then
    print("Active menu index:", menuIndex)
    print("Selected item callback:", itemCallback)
end

-- Use in input handling
hook.Add("PlayerButtonDown", "HandleMenuClick", function(ply, button)
    if button == MOUSE_LEFT then
        local menuIndex, itemCallback = lia.menu.getActiveMenu()
        if menuIndex and itemCallback then
            lia.menu.onButtonPressed(menuIndex, itemCallback)
        end
    end
end)
```

### lia.menu.onButtonPressed
**Purpose**: Handles button press events for menu items.

**Parameters**:
- `id` (number): Menu index
- `cb` (function): Callback function to execute

**Returns**: Boolean indicating if the callback was executed

**Realm**: Client

**Example Usage**:
```lua
-- Handle menu button press
local menuIndex, itemCallback = lia.menu.getActiveMenu()
if menuIndex and itemCallback then
    local success = lia.menu.onButtonPressed(menuIndex, itemCallback)
    if success then
        print("Menu action executed successfully")
    end
end

-- Use in input handling
hook.Add("PlayerButtonDown", "HandleMenuInput", function(ply, button)
    if button == MOUSE_LEFT then
        local menuIndex, itemCallback = lia.menu.getActiveMenu()
        if menuIndex and itemCallback then
            lia.menu.onButtonPressed(menuIndex, itemCallback)
        end
    end
end)
```
