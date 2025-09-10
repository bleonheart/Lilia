# Attributes Library

This page documents the functions for working with character attributes.

---

## Overview

The attributes library (`lia.attribs`) provides a system for managing character attributes within the Lilia framework. It handles loading attribute definitions from files, managing attribute data, and setting up attributes for characters. Attributes are used to track various character statistics and properties that can affect gameplay.

---

### lia.attribs.loadFromDir

**Purpose**

Loads attribute definitions from Lua files in a specified directory.

**Parameters**

* `directory` (*string*): The path to the directory containing attribute definition files.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Load attributes from the default attributes directory
lia.attribs.loadFromDir("gamemode/attributes")

-- Load attributes from a custom directory
lia.attribs.loadFromDir("gamemode/custom_attributes")

-- Load attributes from a module's attributes folder
lia.attribs.loadFromDir("gamemode/modules/my_module/attributes")
```

---

### lia.attribs.setup

**Purpose**

Sets up attributes for a specific character by calling the OnSetup function for each attribute.

**Parameters**

* `client` (*Player*): The player whose character's attributes should be set up.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Set up attributes for a player when they spawn
    hook.Add("PlayerSpawn", "SetupAttributes", function(ply)
        if ply:getChar() then
            lia.attribs.setup(ply)
        end
    end)

    -- Set up attributes for a character when it's loaded
    hook.Add("OnCharacterLoaded", "SetupAttributes", function(ply, char)
        lia.attribs.setup(ply)
    end)

    -- Manually set up attributes for a specific player
    local player = player.GetHumans()[1]
    if IsValid(player) and player:getChar() then
        lia.attribs.setup(player)
    end
end
```