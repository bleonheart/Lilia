# Attributes Library

This page documents the functions for working with character attributes.

---

## Overview

The attributes library loads attribute definitions from Lua files and provides helpers for initializing them on a character. Each attribute is defined on a global `ATTRIBUTE` table inside its own file. When
`lia.attribs.loadFromDir` is called, each file is included in the shared realm, the attribute's name and description are
localized (defaulting to `L("unknown")` and `L("noDesc")` when absent), and the definition is stored in `lia.attribs.list`
using the file name without extension as the key. Files beginning with `sh_` have the prefix removed and the key
lowercased. The loader is invoked automatically when a module is initialized, so most schemas simply place their
attribute files in `schema/attributes/`.

For details on each `ATTRIBUTE` field, see the [Attribute Fields documentation](../definitions/attribute.md).

### lia.attribs.loadFromDir

**Purpose**

Loads attribute definitions from each Lua file in the given directory, localizes their `name` and `desc` fields, and registers them in `lia.attribs.list`. Filenames supply the list key—if a file begins with `sh_`, the prefix is stripped and the key is lowercased. Missing `name` or `desc` fields default to `L("unknown")` and `L("noDesc")`.

**Parameters**

* `directory` (*string*): Path to the folder containing attribute Lua files.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- schema/attributes/strength.lua
ATTRIBUTE.name = "Strength"
ATTRIBUTE.desc = "Determines melee damage."
ATTRIBUTE.startingMax = 20
ATTRIBUTE.maxValue = 50

function ATTRIBUTE:OnSetup(client, value)
    client:SetMaxHealth(100 + value)
end

-- Load all attribute files once at startup
lia.attribs.loadFromDir("schema/attributes")
```

---

### lia.attribs.setup

**Purpose**

Initializes and refreshes attribute data for a player's character by looping through `lia.attribs.list`. For each attribute it retrieves the character's value (defaulting to 0) and calls the attribute's `OnSetup` callback if present. If the client has no character, the function returns without doing anything.

**Parameters**

* `client` (*Player*): The player whose character attributes should be set up.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- After modifying a character attribute, run setup again so any
-- OnSetup hooks update the player's stats.
local char = client:getChar()
char:updateAttrib("strength", 5)
lia.attribs.setup(client)
```

---
