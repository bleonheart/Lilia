# Logger Library

This page documents the functions for working with Lilia's logging and audit system.

---

## Overview

The logger library records structured log entries to the console and to the `logs` SQL table (timestamp, gamemode, category, message, character ID, SteamID). Built‑in log types are defined in `lia.log.types` within `gamemode/core/libraries/logger.lua`; custom types can be registered with `lia.log.addType`.

Each database row stores the timestamp, SteamID and, when applicable, the character ID so that every entry can be associated with a specific player.

---

### lia.log.addType

**Purpose**

Registers a log type by supplying a generator function and a category. Existing types with the same identifier are overwritten.

**Parameters**

* `logType` (*string*): Unique identifier.

* `func` (*function*): Builds the log string (`func(client, ...) → string`).

* `category` (*string*): Category name used to organise logs.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.log.addType(
    "mytype",
    function(client, action)
        return string.format("%s performed %s", client:Name(), action)
    end,
    "Actions"
)

lia.log.add(client, "mytype", "a backflip")
```

---

### lia.log.getString

**Purpose**

Returns the formatted log string (and its category) for a given type without writing anything. If the type is unknown or the generator function errors, `nil` is returned.

**Parameters**

* `client` (*Player* or *nil*): Player tied to the entry (optional for server events).

* `logType` (*string*): Log-type identifier.

* …: Additional arguments forwarded to the generator.

**Realm**

`Server`

**Returns**

* *string*, *string*: Log text and its category, or `nil` if the log type is invalid.

**Example Usage**

```lua
local text, cat = lia.log.getString(client, "mytype", "test")
print(cat .. ": " .. text)
```

---

### lia.log.add

**Purpose**

Creates a log entry, fires `OnServerLog`, prints to console, and inserts into the `logs` table together with the player's SteamID and character ID (when available). If the log type is unknown or the generator fails, nothing is written. Missing or non-string categories fall back to the localized string for "uncategorized".

**Parameters**

* `client` (*Player* or *nil*): Player associated with the event (optional).

* `logType` (*string*): Log-type identifier.

* …: Extra values for the generator.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
hook.Add("PlayerDeath", "ExampleDeathLog", function(victim, attacker)
    lia.log.add(victim, "playerDeath", attacker)
end)
```

---
