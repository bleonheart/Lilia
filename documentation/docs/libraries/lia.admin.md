# Administrator Library

This page documents the functions for working with administrator privileges and user groups.

---

## Overview

The administrator library (`lia.administrator`) provides a comprehensive, hierarchical permission and user group management system for the Lilia framework. It serves as the core authorization system, handling everything from basic tool usage permissions to complex administrative operations. The library supports privilege inheritance, CAMI integration, and dynamic privilege registration for tools and properties.

---

### lia.administrator.hasAccess

**Purpose**

Checks if a player or usergroup has access to a specific privilege.

**Parameters**

* `ply` (*Player|string*): The player entity or usergroup name to check.
* `privilege` (*string*): The privilege to check access for.

**Returns**

* `hasAccess` (*boolean*): True if the player/usergroup has the privilege, false otherwise.

**Realm**

Shared.

**Example Usage**

```lua
-- Check if a player has the "manageUsergroups" privilege
if lia.administrator.hasAccess(ply, "manageUsergroups") then
    print(ply:Nick() .. " can manage usergroups!")
end

-- Check if the "admin" group has the "ban" privilege
if lia.administrator.hasAccess("admin", "ban") then
    print("Admins can ban players.")
end

-- Check privilege access in a command function
hook.Add("PlayerSay", "CheckAdminCommand", function(ply, text)
    if string.sub(text, 1, 5) == "!kick" then
        if not lia.administrator.hasAccess(ply, "kick") then
            ply:ChatPrint("You don't have permission to kick players!")
            return false
        end
        -- Process kick command
    end
end)

-- Check tool usage permission
hook.Add("CanTool", "CheckToolPermissions", function(ply, trace, tool)
    local privilege = "tool_" .. tool
    if not lia.administrator.hasAccess(ply, privilege) then
        ply:ChatPrint("You don't have permission to use this tool!")
        return false
    end
end)

-- Conditional feature access
if lia.administrator.hasAccess(LocalPlayer(), "seeAdminChat") then
    drawAdminChat()
end
```

---

### lia.administrator.registerPrivilege

**Purpose**

Registers a new privilege in the administrator system with specified access requirements.

**Parameters**

* `priv` (*table*): Privilege data table containing:
  * `ID` (*string*): Unique identifier for the privilege.
  * `Name` (*string*): Display name for the privilege.
  * `MinAccess` (*string*): Minimum access level required (default: "user").
  * `Category` (*string*): Category for organizing privileges.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic privilege
lia.administrator.registerPrivilege({
    Name = "Access Admin Panel",
    ID = "adminPanel",
    MinAccess = "admin",
    Category = "administration"
})

-- Register a tool privilege
lia.administrator.registerPrivilege({
    Name = "Use Spawner Tool",
    ID = "tool_spawner",
    MinAccess = "admin",
    Category = "tools"
})

-- Register a custom module privilege
lia.administrator.registerPrivilege({
    Name = "Manage Economy",
    ID = "economyManage",
    MinAccess = "superadmin",
    Category = "economy"
})

-- Register a property privilege
lia.administrator.registerPrivilege({
    Name = "Access Property Privilege",
    ID = "property_remover",
    MinAccess = "admin",
    Category = "properties"
})
```

---

### lia.administrator.unregisterPrivilege

**Purpose**

Removes a privilege from the administrator system.

**Parameters**

* `id` (*string*): The ID of the privilege to remove.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Remove a privilege
lia.administrator.unregisterPrivilege("oldPrivilege")

-- Remove a tool privilege
lia.administrator.unregisterPrivilege("tool_oldtool")

-- Remove a property privilege
lia.administrator.unregisterPrivilege("property_oldprop")
```

---

### lia.administrator.applyInheritance

**Purpose**

Applies privilege inheritance to a usergroup based on its inheritance settings.

**Parameters**

* `groupName` (*string*): The name of the usergroup to apply inheritance to.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Apply inheritance to a custom group
lia.administrator.applyInheritance("moderator")

-- Apply inheritance after creating a new group
lia.administrator.createGroup("vip", {
    _info = {
        inheritance = "user",
        types = {"VIP"}
    }
})
lia.administrator.applyInheritance("vip")

-- Manually refresh inheritance for all groups
for groupName, _ in pairs(lia.administrator.groups) do
    lia.administrator.applyInheritance(groupName)
end
```

---

### lia.administrator.load

**Purpose**

Loads administrator groups and privileges from the database.

**Parameters**

*None*

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Load admin system on server start
lia.administrator.load()

-- Load with callback
lia.administrator.load()
hook.Add("OnAdminSystemLoaded", "MyMod", function(groups, privileges)
    print("Admin system loaded with " .. table.Count(groups) .. " groups")
    print("Total privileges: " .. table.Count(privileges))
end)
```

---

### lia.administrator.save

**Purpose**

Saves administrator groups and privileges to the database.

**Parameters**

* `noNetwork` (*boolean*): If true, skips network synchronization.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Save admin system
lia.administrator.save()

-- Save without network sync
lia.administrator.save(true)

-- Save after making changes
lia.administrator.addPermission("moderator", "kick", true)
lia.administrator.save()
```

---

### lia.administrator.createGroup

**Purpose**

Creates a new usergroup with specified information.

**Parameters**

* `groupName` (*string*): The name of the group to create.
* `info` (*table*): Group information table containing:
  * `_info` (*table*): Group metadata with inheritance and types.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Create a basic group
lia.administrator.createGroup("moderator", {
    _info = {
        inheritance = "user",
        types = {"Staff"}
    }
})

-- Create a VIP group
lia.administrator.createGroup("vip", {
    _info = {
        inheritance = "user",
        types = {"VIP", "User"}
    }
})

-- Create a custom staff group
lia.administrator.createGroup("helper", {
    _info = {
        inheritance = "user",
        types = {"Staff", "Helper"}
    }
})
```

---

### lia.administrator.removeGroup

**Purpose**

Removes a usergroup from the administrator system.

**Parameters**

* `groupName` (*string*): The name of the group to remove.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Remove a custom group
lia.administrator.removeGroup("oldgroup")

-- Remove a group after checking it exists
if lia.administrator.groups["temporary"] then
    lia.administrator.removeGroup("temporary")
end
```

---

### lia.administrator.renameGroup

**Purpose**

Renames an existing usergroup.

**Parameters**

* `oldName` (*string*): The current name of the group.
* `newName` (*string*): The new name for the group.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Rename a group
lia.administrator.renameGroup("oldmoderator", "newmoderator")

-- Rename with validation
if lia.administrator.groups["tempgroup"] and not lia.administrator.groups["permanentgroup"] then
    lia.administrator.renameGroup("tempgroup", "permanentgroup")
end
```

---

### lia.administrator.addPermission

**Purpose**

Adds a permission to a usergroup.

**Parameters**

* `groupName` (*string*): The name of the group to add permission to.
* `permission` (*string*): The permission to add.
* `silent` (*boolean*): If true, skips logging the change.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Add permission to a group
lia.administrator.addPermission("moderator", "kick")

-- Add multiple permissions
local permissions = {"mute", "gag", "freeze"}
for _, perm in ipairs(permissions) do
    lia.administrator.addPermission("moderator", perm)
end

-- Add permission silently
lia.administrator.addPermission("admin", "secretcommand", true)
```

---

### lia.administrator.removePermission

**Purpose**

Removes a permission from a usergroup.

**Parameters**

* `groupName` (*string*): The name of the group to remove permission from.
* `permission` (*string*): The permission to remove.
* `silent` (*boolean*): If true, skips logging the change.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Remove permission from a group
lia.administrator.removePermission("moderator", "kick")

-- Remove multiple permissions
local permissions = {"mute", "gag", "freeze"}
for _, perm in ipairs(permissions) do
    lia.administrator.removePermission("moderator", perm)
end

-- Remove permission silently
lia.administrator.removePermission("admin", "oldcommand", true)
```

---

### lia.administrator.sync

**Purpose**

Synchronizes administrator data with connected clients.

**Parameters**

* `c` (*Player*): Optional specific client to sync with.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Sync with all clients
lia.administrator.sync()

-- Sync with specific client
lia.administrator.sync(ply)

-- Sync after privilege changes
lia.administrator.registerPrivilege({
    Name = "New Privilege",
    ID = "newpriv",
    MinAccess = "admin"
})
lia.administrator.sync()
```

---

### lia.administrator.setPlayerUsergroup

**Purpose**

Sets a player's usergroup and triggers CAMI events.

**Parameters**

* `ply` (*Player*): The player to set usergroup for.
* `newGroup` (*string*): The new usergroup name.
* `source` (*string*): The source of the change (default: "Lilia").

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Set player usergroup
lia.administrator.setPlayerUsergroup(ply, "admin")

-- Set with custom source
lia.administrator.setPlayerUsergroup(ply, "moderator", "MyMod")

-- Set usergroup with validation
if IsValid(ply) and ply:IsPlayer() then
    lia.administrator.setPlayerUsergroup(ply, "vip")
    ply:ChatPrint("You have been promoted to VIP!")
end
```

---

### lia.administrator.setSteamIDUsergroup

**Purpose**

Sets a SteamID's usergroup and triggers CAMI events.

**Parameters**

* `steamId` (*string*): The SteamID to set usergroup for.
* `newGroup` (*string*): The new usergroup name.
* `source` (*string*): The source of the change (default: "Lilia").

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Set SteamID usergroup
lia.administrator.setSteamIDUsergroup("STEAM_0:1:123456", "admin")

-- Set with custom source
lia.administrator.setSteamIDUsergroup("STEAM_0:1:123456", "moderator", "MyMod")

-- Set usergroup for offline player
local steamid = "STEAM_0:1:789012"
lia.administrator.setSteamIDUsergroup(steamid, "vip")
print("Set " .. steamid .. " to VIP group")
```

---

### lia.administrator.serverExecCommand

**Purpose**

Executes server-side administrative commands with privilege checking.

**Parameters**

* `cmd` (*string*): The command to execute.
* `victim` (*Player|string*): The target player or SteamID.
* `dur` (*number*): Duration for timed commands.
* `reason` (*string*): Reason for the command.
* `admin` (*Player*): The admin executing the command.

**Returns**

* `success` (*boolean*): True if command executed successfully.

**Realm**

Server.

**Example Usage**

```lua
-- Execute kick command
lia.administrator.serverExecCommand("kick", target, nil, "Rule violation", admin)

-- Execute ban command with duration
lia.administrator.serverExecCommand("ban", target, 1440, "Cheating", admin)

-- Execute mute command
lia.administrator.serverExecCommand("mute", target, 60, "Spam", admin)

-- Execute freeze command
lia.administrator.serverExecCommand("freeze", target, 30, nil, admin)

-- Execute slay command
lia.administrator.serverExecCommand("slay", target, nil, nil, admin)

-- Execute bring command
lia.administrator.serverExecCommand("bring", target, nil, nil, admin)

-- Execute goto command
lia.administrator.serverExecCommand("goto", target, nil, nil, admin)

-- Execute jail command
lia.administrator.serverExecCommand("jail", target, 300, "Disruptive behavior", admin)

-- Execute cloak command
lia.administrator.serverExecCommand("cloak", target, nil, nil, admin)

-- Execute god command
lia.administrator.serverExecCommand("god", target, nil, nil, admin)

-- Execute strip command
lia.administrator.serverExecCommand("strip", target, nil, "Weapon removal", admin)

-- Execute respawn command
lia.administrator.serverExecCommand("respawn", target, nil, nil, admin)

-- Execute blind command with duration
lia.administrator.serverExecCommand("blind", target, 10, "Punishment", admin)
```

---

### lia.administrator.execCommand

**Purpose**

Executes administrative commands on the client side by sending console commands.

**Parameters**

* `cmd` (*string*): The command to execute.
* `victim` (*Player|string*): The target player or SteamID.
* `dur` (*number*): Duration for timed commands.
* `reason` (*string*): Reason for the command.

**Returns**

* `success` (*boolean*): True if command was sent successfully.

**Realm**

Client.

**Example Usage**

```lua
-- Execute kick command from client
lia.administrator.execCommand("kick", target, nil, "Rule violation")

-- Execute ban command with duration
lia.administrator.execCommand("ban", target, 1440, "Cheating")

-- Execute mute command
lia.administrator.execCommand("mute", target, 60, "Spam")

-- Execute freeze command
lia.administrator.execCommand("freeze", target, 30)

-- Execute slay command
lia.administrator.execCommand("slay", target)

-- Execute bring command
lia.administrator.execCommand("bring", target)

-- Execute goto command
lia.administrator.execCommand("goto", target)

-- Execute jail command
lia.administrator.execCommand("jail", target, 300, "Disruptive behavior")

-- Execute cloak command
lia.administrator.execCommand("cloak", target)

-- Execute god command
lia.administrator.execCommand("god", target)

-- Execute strip command
lia.administrator.execCommand("strip", target)

-- Execute respawn command
lia.administrator.execCommand("respawn", target)

-- Execute blind command
lia.administrator.execCommand("blind", target)
```