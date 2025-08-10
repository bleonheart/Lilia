# Administrator Library

This page documents the built-in administrator system.

---

## Overview

The administrator library manages user groups, privileges, and access levels with support for CAMI integration and hierarchical inheritance.

The base user groups `user`, `admin`, and `superadmin` exist by default and cannot be removed.

---

### lia.administrator.hasAccess

**Purpose**

Checks if a player or usergroup has access to a specific privilege. Unregistered privileges log a warning and default to superadmin access.

**Parameters**

* `ply` (*Player|string*): Player entity or usergroup name.
* `privilege` (*string*): Privilege identifier.

**Realm**

`Shared`

**Returns**

* `boolean`: `true` when access is granted.

Superadmins always receive access. If the privilege is unregistered, a warning is emitted and only superadmins will pass the check.

**Example Usage**

```lua
if lia.administrator.hasAccess(ply, "manageUsergroups") then
    print(ply:Nick() .. " can manage usergroups")
end
```

---

### lia.administrator.save

**Purpose**

Saves all usergroups and privileges to the database and optionally synchronizes them to clients.

**Parameters**

* `noNetwork` (*boolean*, optional): When `true`, skips the client synchronization step. Defaults to `false`.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.unregisterPrivilege("canFly")
```

Client data is only synchronized if at least one player has completed network initialization (`lia.net.ready`).

**Example Usage**

```lua
lia.administrator.save() -- Save and sync
lia.administrator.save(true) -- Save without syncing
```

---

### lia.administrator.registerPrivilege

**Purpose**

Registers a new privilege and assigns it to all usergroups that meet the minimum access level.

**Parameters**

* `priv` (*table*):
  * `ID` (*string*): Unique identifier used in permission checks.
  * `Name` (*string*, optional): Localized name shown in lists. Defaults to `ID`.
  * `MinAccess` (*string*, optional): Minimum usergroup that should have the privilege. Defaults to `"user"`.
  * `Category` (*string*, optional): Category label.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

If `ID` is missing, empty, or already registered, the function does nothing. Eligible groups automatically receive the privilege and CAMI is notified when available.

**Example Usage**

```lua
lia.administrator.registerPrivilege({
    ID = "canFly",
    MinAccess = "admin",
    Category = "Fun"
})
```

---

### lia.administrator.unregisterPrivilege

**Purpose**

Removes a previously registered privilege from all usergroups.

**Parameters**

* `id` (*string*): Identifier of the privilege to remove.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.unregisterPrivilege("canFly")
```

---

### lia.administrator.applyInheritance

**Purpose**

Applies inheritance for a usergroup, copying privileges from parent groups and granting those that meet minimum requirements.

**Parameters**

* `groupName` (*string*): Target usergroup.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.applyInheritance("moderator")
```

---

### lia.administrator.load

**Purpose**

Loads usergroups and privileges from the database, ensures default groups exist, applies inheritance, and synchronizes with CAMI if available.

**Parameters**

*None*

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.load()
```

---

### lia.administrator.createGroup

**Purpose**

Creates a new usergroup with optional information and registers it with CAMI.

**Parameters**

* `groupName` (*string*): Name of the group. Must not already exist.
* `info` (*table*, optional): Optional configuration table.
  * `_info.inheritance` (*string*, optional): Group to inherit from. Defaults to `"user"`.
  * `_info.types` (*table*, optional): Array of classification strings. Defaults to an empty table.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.createGroup("moderator", {
    _info = {inheritance = "user", types = {"Staff"}}
})
```

---

### lia.administrator.removeGroup

**Purpose**

Deletes a usergroup and unregisters it from CAMI. The groups `user`, `admin`, and `superadmin` cannot be removed.

**Parameters**

* `groupName` (*string*): Group to remove. Must exist and cannot be one of the base groups.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.removeGroup("moderator")
```

---

### lia.administrator.renameGroup

**Purpose**

Renames an existing usergroup and updates CAMI information.

**Parameters**

* `oldName` (*string*): Current name of the group. Base groups cannot be renamed.
* `newName` (*string*): New name for the group. Must not already exist.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.renameGroup("moderator", "helper")
```

---

### lia.administrator.addPermission

**Purpose**

Grants a privilege to a usergroup.

**Parameters**

* `groupName` (*string*): Target usergroup. Base groups cannot be modified.
* `permission` (*string*): Privilege identifier.
* `silent` (*boolean*, optional): When `true`, suppresses network updates. Defaults to `false`.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.addPermission("moderator", "kick")
```

---

### lia.administrator.removePermission

**Purpose**

Revokes a privilege from a usergroup.

**Parameters**

* `groupName` (*string*): Target usergroup. Base groups cannot be modified.
* `permission` (*string*): Privilege to remove.
* `silent` (*boolean*, optional): When `true`, suppresses network updates. Defaults to `false`.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.removePermission("moderator", "ban")
```

---

### lia.administrator.sync

**Purpose**

Synchronizes admin privileges and groups to a specific client or all clients.

**Parameters**

* `c` (*Player*, optional): Player to sync to. When omitted, all players are synced.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

Only players flagged as network-ready are updated.

**Example Usage**

```lua
lia.administrator.sync() -- Sync all players
lia.administrator.sync(somePlayer) -- Sync a single player
```

---

### lia.administrator.setPlayerUsergroup

**Purpose**

Sets a player's usergroup and notifies CAMI of the change.

**Parameters**

* `ply` (*Player*): Player whose usergroup to set.
* `newGroup` (*string*): New usergroup name. Defaults to `"user"`.
* `source` (*string*, optional): Source identifier for CAMI. Defaults to `"Lilia"`.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.setPlayerUsergroup(targetPlayer, "admin", "Console")
```

---

### lia.administrator.setSteamIDUsergroup

**Purpose**

Assigns a usergroup to a player by SteamID and notifies CAMI.

**Parameters**

* `steamId` (*string*): Player's SteamID.
* `newGroup` (*string*): New usergroup name. Defaults to `"user"`.
* `source` (*string*, optional): Source identifier for CAMI. Defaults to `"Lilia"`.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.administrator.setSteamIDUsergroup("STEAM_0:1:123456", "vip", "Admin Panel")
```

---

### lia.administrator.execCommand

**Purpose**

Executes an administrative chat command such as kick or ban. Supported commands include kick, ban, unban, mute, unmute, gag, ungag, freeze, unfreeze, slay, bring, goto, return, jail, unjail, cloak, uncloak, god, ungod, ignite, extinguish, strip, respawn, blind, and unblind.

**Parameters**

* `cmd` (*string*): Command name (e.g., `"kick"`, `"ban"`, `"goto"`).
* `victim` (*Player|string*): Target player entity or SteamID.
* `dur` (*number*, optional): Duration for timed commands. Defaults to `0`.
* `reason` (*string*, optional): Reason text.

**Realm**

`Client`

**Returns**

* `boolean|nil`: `true` if a command was issued, otherwise `nil`.

**Example Usage**

```lua
-- Kick a player for being AFK
lia.administrator.execCommand("kick", targetPlayer, nil, "AFK")

-- Ban a SteamID for 60 minutes
lia.administrator.execCommand("ban", "STEAM_0:1:123456", 60, "Cheating")
```

---
