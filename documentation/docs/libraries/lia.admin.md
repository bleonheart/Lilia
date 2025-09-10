# Administrator Library

This page documents the functions for working with administrator privileges and user groups.

---

## Overview

The administrator library (`lia.administrator`) provides a comprehensive, hierarchical permission and user group management system for the Lilia framework. It serves as the core authorization system, handling everything from basic tool usage permissions to complex administrative operations. The library manages user groups, privileges, inheritance, and provides functions for checking access, managing groups, and executing administrative commands.

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

### lia.administrator.save

**Purpose**

Saves the current administrator groups and privileges to the database and optionally syncs with clients.

**Parameters**

* `noNetwork` (*boolean*, *optional*): If true, prevents network synchronization with clients.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Save administrator data to database
    lia.administrator.save()
    print("Administrator data saved.")

    -- Save without network sync (useful during loading)
    lia.administrator.save(true)
    print("Administrator data saved without network sync.")
end
```

---

### lia.administrator.registerPrivilege

**Purpose**

Registers a new privilege with the administrator system.

**Parameters**

* `priv` (*table*): A table containing privilege information with fields:
  * `ID` (*string*): The unique identifier for the privilege.
  * `Name` (*string*, *optional*): The display name for the privilege.
  * `MinAccess` (*string*, *optional*): The minimum access level required (defaults to "user").
  * `Category` (*string*, *optional*): The category for organizing privileges.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Register a custom privilege
lia.administrator.registerPrivilege({
    ID = "customModuleAccess",
    Name = "Custom Module Access",
    MinAccess = "admin",
    Category = "Custom Modules"
})

-- Register a privilege for a specific tool
lia.administrator.registerPrivilege({
    ID = "tool_mycustomtool",
    Name = "Use My Custom Tool",
    MinAccess = "user",
    Category = "Tools"
})

-- Register a privilege with inheritance
lia.administrator.registerPrivilege({
    ID = "manageCustomData",
    Name = "Manage Custom Data",
    MinAccess = "superadmin",
    Category = "Data Management"
})
```

---

### lia.administrator.unregisterPrivilege

**Purpose**

Removes a privilege from the administrator system.

**Parameters**

* `id` (*string*): The unique identifier of the privilege to remove.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Remove a custom privilege
lia.administrator.unregisterPrivilege("customModuleAccess")

-- Remove a tool privilege
lia.administrator.unregisterPrivilege("tool_mycustomtool")
```

---

### lia.administrator.applyInheritance

**Purpose**

Applies privilege inheritance to a specific group based on its parent group.

**Parameters**

* `groupName` (*string*): The name of the group to apply inheritance to.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Apply inheritance to a custom group
lia.administrator.applyInheritance("moderator")

-- Apply inheritance after changing group structure
lia.administrator.groups["customGroup"]._info.inheritance = "admin"
lia.administrator.applyInheritance("customGroup")
```

---

### lia.administrator.load

**Purpose**

Loads administrator groups and privileges from the database.

**Parameters**

* `nil`

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Load administrator data from database
    lia.administrator.load()
    print("Administrator data loaded from database.")
end
```

---

### lia.administrator.createGroup

**Purpose**

Creates a new user group with specified information.

**Parameters**

* `groupName` (*string*): The name of the group to create.
* `info` (*table*, *optional*): A table containing group information with fields:
  * `_info` (*table*): Group metadata including inheritance and types.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Create a basic group
lia.administrator.createGroup("moderator")

-- Create a group with custom inheritance
lia.administrator.createGroup("vip", {
    _info = {
        inheritance = "user",
        types = {"VIP"}
    }
})

-- Create a staff group
lia.administrator.createGroup("staff", {
    _info = {
        inheritance = "admin",
        types = {"Staff", "User"}
    }
})
```

---

### lia.administrator.removeGroup

**Purpose**

Removes a user group from the system.

**Parameters**

* `groupName` (*string*): The name of the group to remove.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Remove a custom group
lia.administrator.removeGroup("moderator")

-- Remove a VIP group
lia.administrator.removeGroup("vip")
```

---

### lia.administrator.renameGroup

**Purpose**

Renames an existing user group.

**Parameters**

* `oldName` (*string*): The current name of the group.
* `newName` (*string*): The new name for the group.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Rename a group
lia.administrator.renameGroup("moderator", "mod")

-- Rename a VIP group
lia.administrator.renameGroup("vip", "premium")
```

---

### lia.administrator.addPermission

**Purpose**

Adds a permission to a specific user group.

**Parameters**

* `groupName` (*string*): The name of the group to add the permission to.
* `permission` (*string*): The permission to add.
* `silent` (*boolean*, *optional*): If true, prevents saving to database immediately.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Add a permission to a group
    lia.administrator.addPermission("moderator", "kick")

    -- Add multiple permissions silently
    lia.administrator.addPermission("moderator", "ban", true)
    lia.administrator.addPermission("moderator", "mute", true)
    lia.administrator.save() -- Save all changes at once
end
```

---

### lia.administrator.removePermission

**Purpose**

Removes a permission from a specific user group.

**Parameters**

* `groupName` (*string*): The name of the group to remove the permission from.
* `permission` (*string*): The permission to remove.
* `silent` (*boolean*, *optional*): If true, prevents saving to database immediately.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Remove a permission from a group
    lia.administrator.removePermission("moderator", "kick")

    -- Remove multiple permissions silently
    lia.administrator.removePermission("moderator", "ban", true)
    lia.administrator.removePermission("moderator", "mute", true)
    lia.administrator.save() -- Save all changes at once
end
```

---

### lia.administrator.sync

**Purpose**

Synchronizes administrator data with clients.

**Parameters**

* `c` (*Player*, *optional*): The specific client to sync with. If nil, syncs with all clients.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Sync with all clients
    lia.administrator.sync()

    -- Sync with a specific client
    local targetPlayer = player.GetHumans()[1]
    if IsValid(targetPlayer) then
        lia.administrator.sync(targetPlayer)
    end
end
```

---

### lia.administrator.setPlayerUsergroup

**Purpose**

Sets a player's usergroup and triggers appropriate hooks.

**Parameters**

* `ply` (*Player*): The player to change the usergroup for.
* `newGroup` (*string*): The new usergroup name.
* `source` (*string*, *optional*): The source of the change (defaults to "Lilia").

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Set a player's usergroup
    local player = player.GetHumans()[1]
    if IsValid(player) then
        lia.administrator.setPlayerUsergroup(player, "moderator")
        print(player:Name() .. " is now a moderator.")
    end

    -- Set usergroup with custom source
    lia.administrator.setPlayerUsergroup(player, "admin", "Custom Module")
end
```

---

### lia.administrator.setSteamIDUsergroup

**Purpose**

Sets a usergroup for a player by their SteamID, even if they're not currently online.

**Parameters**

* `steamId` (*string*): The SteamID of the player.
* `newGroup` (*string*): The new usergroup name.
* `source` (*string*, *optional*): The source of the change (defaults to "Lilia").

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Set usergroup by SteamID
    lia.administrator.setSteamIDUsergroup("STEAM_0:1:123456", "moderator")
    print("SteamID usergroup set to moderator.")

    -- Set usergroup with custom source
    lia.administrator.setSteamIDUsergroup("STEAM_0:1:123456", "admin", "Admin Panel")
end
```

---

### lia.administrator.execCommand

**Purpose**

Executes an administrative command on the client side by sending console commands to the server.

**Parameters**

* `cmd` (*string*): The command to execute.
* `victim` (*Player|string*): The target player or SteamID.
* `dur` (*number*, *optional*): Duration for timed commands.
* `reason` (*string*, *optional*): Reason for the command.

**Returns**

* `success` (*boolean*): True if the command was executed successfully, false otherwise.

**Realm**

Client.

**Example Usage**

```lua
if CLIENT then
    -- Kick a player
    local target = player.GetHumans()[1]
    if IsValid(target) then
        lia.administrator.execCommand("kick", target, nil, "Rule violation")
    end

    -- Ban a player for 24 hours
    lia.administrator.execCommand("ban", target, 1440, "Cheating")

    -- Mute a player for 10 minutes
    lia.administrator.execCommand("mute", target, 600, "Spam")
end
```

---

### lia.administrator.serverExecCommand

**Purpose**

Executes an administrative command on the server side.

**Parameters**

* `cmd` (*string*): The command to execute.
* `victim` (*Player|string*): The target player or SteamID.
* `dur` (*number*, *optional*): Duration for timed commands.
* `reason` (*string*, *optional*): Reason for the command.
* `admin` (*Player*): The administrator executing the command.

**Returns**

* `success` (*boolean*): True if the command was executed successfully, false otherwise.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Kick a player
    local target = player.GetHumans()[1]
    local admin = player.GetHumans()[2]
    if IsValid(target) and IsValid(admin) then
        lia.administrator.serverExecCommand("kick", target, nil, "Rule violation", admin)
    end

    -- Ban a player for 24 hours
    lia.administrator.serverExecCommand("ban", target, 1440, "Cheating", admin)

    -- Mute a player for 10 minutes
    lia.administrator.serverExecCommand("mute", target, 600, "Spam", admin)

    -- Freeze a player for 30 seconds
    lia.administrator.serverExecCommand("freeze", target, 30, "Investigation", admin)
end
```