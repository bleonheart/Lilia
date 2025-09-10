# Attributes Library

This page documents the functions for working with character attributes and attribute management.

---

## Overview

The attributes library (`lia.attribs`) provides a system for managing character attributes in the Lilia framework. It handles loading attribute definitions from files, setting up attributes for characters, and managing attribute data. The library supports dynamic attribute loading and provides hooks for attribute setup and management.

---

### lia.attribs.loadFromDir

**Purpose**

Loads attribute definitions from a directory containing attribute files.

**Parameters**

* `directory` (*string*): The directory path to load attributes from.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Load attributes from a specific directory
lia.attribs.loadFromDir("gamemode/attributes")

-- Load attributes from schema directory
lia.attribs.loadFromDir("schema/attributes")

-- Load attributes from addon directory
lia.attribs.loadFromDir("addons/myaddon/lua/attributes")

-- Load attributes with error handling
local success, err = pcall(function()
    lia.attribs.loadFromDir("gamemode/attributes")
end)

if not success then
    print("Failed to load attributes: " .. tostring(err))
end
```

---

### lia.attribs.setup

**Purpose**

Sets up attributes for a client's character, calling OnSetup hooks for each attribute.

**Parameters**

* `client` (*Player*): The client to set up attributes for.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Setup attributes for a player when they spawn
hook.Add("PlayerSpawn", "SetupAttributes", function(ply)
    if ply:getChar() then
        lia.attribs.setup(ply)
    end
end)

-- Setup attributes for a character when loaded
hook.Add("CharacterLoaded", "SetupAttributes", function(char)
    local client = char:getPlayer()
    if IsValid(client) then
        lia.attribs.setup(client)
    end
end)

-- Setup attributes manually
lia.attribs.setup(ply)

-- Setup attributes with validation
if IsValid(ply) and ply:getChar() then
    lia.attribs.setup(ply)
    print("Attributes setup for " .. ply:Name())
end
```