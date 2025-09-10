# lia.keybind

## Overview
The `lia.keybind` library provides comprehensive keybind management for Lilia, allowing players to bind custom actions to keys. It supports both client and server-side keybinds, with automatic saving and loading of keybind preferences.

## Functions

### lia.keybind.add
**Purpose**: Adds a new keybind with specified key and callback functions.

**Parameters**:
- `k` (string|number): Key identifier (string name or key code)
- `d` (string): Description of the keybind
- `cb` (table): Callback table containing onPress, onRelease, shouldRun, and serverOnly functions

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Add a simple client-side keybind
lia.keybind.add("f1", "openMenu", {
    onPress = function(client)
        local f1Menu = vgui.Create("liaMenu")
        f1Menu:setActiveTab("Main")
    end
})

-- Add a server-side keybind
lia.keybind.add("f2", "adminMode", {
    serverOnly = true,
    onPress = function(client)
        if client:isStaffOnDuty() then
            client:ChatPrint("Admin mode toggled")
        end
    end
})

-- Add keybind with conditions
lia.keybind.add("e", "interact", {
    onPress = function(client)
        local entity = client:getTracedEntity()
        if IsValid(entity) and entity:GetPos():Distance(client:GetPos()) < 100 then
            entity:Use(client, client)
        end
    end,
    shouldRun = function(client)
        return client:getChar() ~= nil
    end
})

-- Add keybind with release callback
lia.keybind.add("mouse1", "aim", {
    onPress = function(client)
        client:SetNWBool("Aiming", true)
    end,
    onRelease = function(client)
        client:SetNWBool("Aiming", false)
    end
})
```

### lia.keybind.get
**Purpose**: Gets the current key binding for a specific action.

**Parameters**:
- `a` (string): Action name
- `df` (number): Default key code (optional)

**Returns**: Key code for the action

**Realm**: Client

**Example Usage**:
```lua
-- Get current keybind for action
local currentKey = lia.keybind.get("openMenu", KEY_F1)
print("Open menu key:", input.GetKeyName(currentKey))

-- Check if action is bound
local interactKey = lia.keybind.get("interact")
if interactKey ~= KEY_NONE then
    print("Interact is bound to:", input.GetKeyName(interactKey))
else
    print("Interact is not bound")
end
```

### lia.keybind.save
**Purpose**: Saves all keybind settings to a file.

**Parameters**: None

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Save keybinds
lia.keybind.save()
print("Keybinds saved")

-- Save after changing keybinds
lia.keybind.stored["openMenu"].value = KEY_F2
lia.keybind.save()
```

### lia.keybind.load
**Purpose**: Loads keybind settings from a file.

**Parameters**: None

**Returns**: None

**Realm**: Client

**Example Usage**:
```lua
-- Load keybinds
lia.keybind.load()
print("Keybinds loaded")

-- Load keybinds on client init
hook.Add("Initialize", "LoadKeybinds", function()
    lia.keybind.load()
end)
```