# Core Library

This page documents general utilities used throughout Lilia.

---

## Overview

The core library exposes shared helper functions used across multiple modules. Its main jobs include realm-aware file inclusion and small convenience utilities for coloured console output, deprecation warnings, and standardised punishments.

---

### lia.include

**Purpose**

Includes a Lua file in the correct realm and, on the server, sends client files to players.

**Parameters**

* `path` (*string*): Path to the Lua file. Required.
* `realm` (*string*): Realm override (`"server"`, `"client"`, or `"shared"`). *Optional.* Inferred from the filename when omitted.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.include("lilia/gamemode/core/libraries/util.lua")
```

---

### lia.includeDir

**Purpose**

Includes all Lua files in a directory, optionally traversing subfolders and forcing a realm.

**Parameters**

* `dir` (*string*): Directory path.
* `raw` (*boolean*): Treat `dir` as a raw path. *Optional.* Defaults to `false`.
* `deep` (*boolean*): Include subfolders when `true`. *Optional.* Defaults to `false`.
* `realm` (*string*): Realm override. *Optional.*

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.includeDir("lilia/gamemode/modules/administration", true, true, "server")
```

---

### lia.includeGroupedDir

**Purpose**

Includes Lua files grouped by folder, optionally recursing into subdirectories and forcing a realm for all files.

**Parameters**

* `dir` (*string*): Directory path.
* `raw` (*boolean*): Treat `dir` as a raw filesystem path. *Optional.* Defaults to `false`.
* `recursive` (*boolean*): Traverse subdirectories when `true`. *Optional.* Defaults to `false`.
* `forceRealm` (*string*): Realm override for all files. *Optional.*

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.includeGroupedDir("modules", false, true)
```

---

### lia.error

**Purpose**

Prints a coloured error message prefixed with “$Lilia$”.

**Parameters**

* `msg` (*string*): Error text.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.error("Something went wrong")
```

---

### lia.deprecated

**Purpose**

Displays a deprecation warning and optionally runs a fallback callback.

**Parameters**

* `methodName` (*string*): Name of the deprecated method.

* `callback` (*function*): Fallback function. *Optional*.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.deprecated("OldFunction", function()
    print("Called fallback")
end)
```

---

### lia.updater

**Purpose**

Prints an updater message in cyan with the Lilia prefix.

**Parameters**

* `msg` (*string*): Message text.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.updater("Loading additional content…")
```

---

### lia.information

**Purpose**

Prints an informational message with the Lilia prefix.

**Parameters**

* `msg` (*string*): Console text.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.information("Server started successfully")
```

---

### lia.admin

**Purpose**

Prints an admin-level message with the Lilia prefix.

**Parameters**

* `msg` (*string*): Text to display.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.admin("Player JohnDoe has been promoted to admin.")
```

---

### lia.bootstrap

**Purpose**

Logs a bootstrap message with a coloured section tag.

**Parameters**

* `section` (*string*): Bootstrap stage.

* `msg` (*string*): Descriptive message.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.bootstrap("Database", "Connection established")
```

---

### lia.notifyAdmin

**Purpose**

Broadcasts a chat message to all players with the `canSeeAltingNotifications` privilege.

**Parameters**

* `notification` (*string*): Text to broadcast.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.notifyAdmin("Possible alt account detected")
```

---

### lia.printLog

**Purpose**

Prints a colour-coded log entry to the console.

**Parameters**

* `category` (*string*): Log category name.

* `logString` (*string*): Text to log.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.printLog("Gameplay", "Third round started")
```

---

### lia.applyPunishment

**Purpose**

Applies standardised kick/ban commands for a player infraction.

**Parameters**

* `client` (*Player*): Player to punish.

* `infraction` (*string*): Reason.

* `kick` (*boolean*): Kick the player.

* `ban` (*boolean*): Ban the player.

* `time` (*number*): Ban duration in minutes. *Optional.* Defaults to `0` (permanent).

* `kickKey` (*string*): Localisation key for the kick reason. *Optional.* Defaults to `"kickedForInfraction"`.

* `banKey` (*string*): Localisation key for the ban reason. *Optional.* Defaults to `"bannedForInfraction"`.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.applyPunishment(ply, "Cheating", true, true, 0)
```

---

### lia.includeEntities

**Purpose**

Loads and registers entities, weapons, tools, and effects from a directory.

**Parameters**

* `path` (*string*): Base directory containing `entities`, `weapons`, `tools`, or `effects` subfolders.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.includeEntities("lilia/gamemode/entities")
```

---
