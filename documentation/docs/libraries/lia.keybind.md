# Keybind Library

This page describes functions to register custom keybinds.

---

## Overview

The keybind library stores user-defined keyboard bindings. It is loaded **client-side** and automatically loads any saved bindings from `data/lilia/keybinds/`. Press- and release-callbacks are dispatched through the `PlayerButtonDown` and `PlayerButtonUp` hooks. The library also adds a “Keybinds” page to the config menu via the `PopulateConfigurationButtons` hook so players can change their binds in-game.

---

### lia.keybind.add

**Purpose**

Registers a new keybind for an action, ensuring a default value is set and mapping the key code back to the action for reverse lookup.

**Parameters**

* `k` (*string | number*): Key identifier (string name or key code).

* `d` (*string*): Unique identifier for the keybind action.

* `cb` (*function*): Callback executed when the key is pressed.

* `rcb` (*function*): Callback executed when the key is released. *Optional*.

**Realm**

`Client`

**Returns**

* *nil*: This function does not return a value.

**Example**

```lua
-- Bind F1 to open the inventory while held
local inv
lia.keybind.add(
    KEY_F1,
    "Open Inventory",
    function()
        inv = vgui.Create("liaMenu")
        inv:setActiveTab("Inventory")
    end,
    function()
        if IsValid(inv) then
            inv:Close()
        end
    end
)
```

---

### lia.keybind.get

**Purpose**

Returns the key code assigned to a keybind action, falling back to the registered default or a caller-supplied default.

**Parameters**

* `a` (*string*): Action identifier.

* `df` (*number*): Fallback key code. *Optional*.

**Realm**

`Client`

**Returns**

* *number*: Key code associated with the action (or fallback).

**Example**

```lua
local invKey = lia.keybind.get("Open Inventory", KEY_I)
print("Inventory key:", input.GetKeyName(invKey))
```

---

### lia.keybind.save

**Purpose**

Writes all current keybinds to `data/lilia/keybinds/<gamemode>/<server-ip>.json` (stored as JSON).

**Parameters**

* *None*

**Realm**

`Client`

**Returns**

* *nil*: This function does not return a value.

**Example**

```lua
-- Manually save current keybinds
lia.keybind.save()
```

---

### lia.keybind.load

**Purpose**

Loads keybinds from disk. If none exist, defaults registered via `lia.keybind.add` are applied and then saved. After loading, a reverse lookup table is rebuilt and the `InitializedKeybinds` hook fires.

**Parameters**

* *None*

**Realm**

`Client`

**Returns**

* *nil*: This function does not return a value.

**Example**

```lua
hook.Add("InitializedKeybinds", "NotifyKeybinds", function()
    chat.AddText("Keybinds loaded")
end)

-- Reload keybinds
lia.keybind.load()
```

---