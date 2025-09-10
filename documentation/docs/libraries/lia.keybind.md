# Keybind Library

This page documents the functions for working with keybindings and input management.

---

## Overview

The keybind library (`lia.keybind`) provides a comprehensive system for managing custom keybindings within the Lilia framework. It handles key registration, callback management, and provides a user-friendly interface for players to customize their keybindings. The library supports both client-side and server-side keybind execution with proper validation and permission checks.

---

### lia.keybind.add

**Purpose**

Registers a new keybinding with the system.

**Parameters**

* `k` (*string|number*): The key identifier (string name or KEY_* constant).
* `d` (*string*): The display name/description for the keybinding.
* `cb` (*table*): A table containing callback functions with the following optional fields:
  * `onPress` (*function*): Function called when the key is pressed.
  * `onRelease` (*function*, *optional*): Function called when the key is released.
  * `shouldRun` (*function*, *optional*): Function to determine if the keybind should execute.
  * `serverOnly` (*boolean*, *optional*): Whether this keybind should only run on the server.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Add a simple keybind to open inventory
lia.keybind.add("i", "openInventory", {
    onPress = function()
        local inventory = vgui.Create("liaInventory")
        inventory:Center()
        inventory:MakePopup()
    end
})

-- Add a keybind with press and release callbacks
lia.keybind.add("leftalt", "sprint", {
    onPress = function(client)
        if IsValid(client) then
            client:SetRunSpeed(400) -- Sprint speed
        end
    end,
    onRelease = function(client)
        if IsValid(client) then
            client:SetRunSpeed(200) -- Normal speed
        end
    end
})

-- Add a server-only keybind for admins
lia.keybind.add("f3", "adminPanel", {
    serverOnly = true,
    onPress = function(client)
        if IsValid(client) and client:IsAdmin() then
            client:SendLua("vgui.Create('liaAdminPanel')")
        end
    end
})

-- Add a keybind with validation
lia.keybind.add("g", "dropWeapon", {
    shouldRun = function(client)
        return IsValid(client) and client:Alive() and IsValid(client:GetActiveWeapon())
    end,
    onPress = function(client)
        local weapon = client:GetActiveWeapon()
        if IsValid(weapon) then
            client:DropWeapon(weapon)
        end
    end
})

-- Add a keybind for voice chat
lia.keybind.add("v", "voiceChat", {
    onPress = function(client)
        if IsValid(client) then
            client:ConCommand("+voicerecord")
        end
    end,
    onRelease = function(client)
        if IsValid(client) then
            client:ConCommand("-voicerecord")
        end
    end
})
```

## Built-in Keybinds

The Lilia framework automatically registers several keybinds:

### Inventory Keybind
- **Default Key**: None (KEY_NONE)
- **Name**: "openInventory"
- **Function**: Opens the F1 menu with the inventory tab active

### Admin Mode Keybind
- **Default Key**: None (KEY_NONE)
- **Name**: "adminMode"
- **Function**: Toggles admin mode for staff members
- **Server Only**: Yes

## Key Names

The keybind system supports all standard Garry's Mod key constants:

### Letter Keys
- `a` through `z`

### Number Keys
- `0` through `9`

### Function Keys
- `f1` through `f12`

### Numpad Keys
- `kp_0` through `kp_9`
- `kp_divide`, `kp_multiply`, `kp_minus`, `kp_plus`, `kp_enter`, `kp_decimal`

### Modifier Keys
- `lshift`, `rshift`
- `lctrl`, `rctrl`
- `lalt`, `ralt`
- `lwin`, `rwin`

### Special Keys
- `enter`, `space`, `backspace`, `tab`
- `escape`, `capslock`, `numlock`, `scrolllock`
- `insert`, `delete`, `home`, `end`
- `pageup`, `pagedown`
- `up`, `down`, `left`, `right`

### Symbol Keys
- `minus`, `equal`, `lbracket`, `rbracket`
- `semicolon`, `apostrophe`, `backquote`
- `comma`, `period`, `slash`, `backslash`

## Keybind Storage

Keybinds are stored in `lia.keybind.stored` with the following structure:

```lua
lia.keybind.stored = {
    ["openInventory"] = {
        value = KEY_NONE,        -- Current key assignment
        default = KEY_NONE,      -- Default key assignment
        callback = function()... -- Press callback
        release = nil,           -- Release callback (optional)
        shouldRun = nil,         -- Validation function (optional)
        serverOnly = false       -- Server-only flag
    }
}
```

## Usage Examples

### Custom Inventory Keybind
```lua
lia.keybind.add("tab", "customInventory", {
    onPress = function()
        if IsValid(lia.gui.inv1) then
            lia.gui.inv1:Remove()
            return
        end

        lia.gui.inv1 = vgui.Create("liaInventory")
        lia.gui.inv1:Center()
        lia.gui.inv1:MakePopup()
    end
})
```

### Admin Teleport Keybind
```lua
lia.keybind.add("t", "teleportToTrace", {
    serverOnly = true,
    shouldRun = function(client)
        return IsValid(client) and client:IsAdmin()
    end,
    onPress = function(client)
        local trace = client:GetEyeTrace()
        if trace.HitPos then
            client:SetPos(trace.HitPos)
        end
    end
})
```

### Toggle Sprint Keybind
```lua
lia.keybind.add("lshift", "toggleSprint", {
    onPress = function(client)
        if IsValid(client) then
            local currentSpeed = client:GetRunSpeed()
            if currentSpeed == 200 then
                client:SetRunSpeed(400) -- Enable sprint
            else
                client:SetRunSpeed(200) -- Disable sprint
            end
        end
    end
})
```

## Best Practices

1. **Use Descriptive Names**: Use clear, descriptive names for keybinds that indicate their function.

2. **Validate Input**: Always validate that required objects (players, entities) exist before executing actions.

3. **Check Permissions**: For admin or special function keybinds, always check appropriate permissions.

4. **Handle Edge Cases**: Consider what should happen if a keybind is pressed in invalid states (dead player, invalid entity, etc.).

5. **Use shouldRun**: Implement `shouldRun` functions to prevent keybinds from executing in inappropriate contexts.

6. **Server-Only for Security**: Use `serverOnly = true` for keybinds that require server-side validation or admin privileges.

7. **Cleanup Resources**: If your keybind creates UI elements or other resources, ensure they are properly cleaned up.