# Vendor Library

This page documents vendor-related helpers.

---

## Overview

The vendor library stores item presets and rarity colours for use with in-game vendor NPCs. Presets allow vendors to be configured quickly with predefined items while rarities customise item name colours in the vendor menu. The library also exposes a client-side `lia.vendor.editor` table containing functions that send edits to the server.

---

### lia.vendor.addRarities

**Purpose**

Registers a new rarity colour that can be referenced by name.

**Parameters**

* `name` (*string*): Identifier for the rarity.
* `color` (*Color*): Colour to display in menus.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.vendor.addRarities("epic", Color(165, 105, 189))
```

---

### lia.vendor.addPreset

**Purpose**

Defines a reusable vendor preset of items.

**Parameters**

* `name` (*string*): Preset name.
* `items` (*table*): Map of item unique IDs to price/stock tables.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.vendor.addPreset("medical", {
    medkit = {price = 100, stock = 5},
    bandage = {price = 20, stock = 20}
})
```

---

### lia.vendor.getPreset

**Purpose**

Fetches a preset by name.

**Parameters**

* `name` (*string*): Name of the preset.

**Realm**

`Shared`

**Returns**

* *table | nil*: The preset table or `nil` if not found.

**Example Usage**

```lua
local preset = lia.vendor.getPreset("medical")
if preset then
    PrintTable(preset)
end
```

---
