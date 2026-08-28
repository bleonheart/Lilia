--[[
    Hooks:
        CharListColumns(columns)

    Purpose:
        Allows code to add extra columns to the administration character list.

    Category:
        Administration

    Parameters:
        columns (table)
            The mutable list of character list column definitions.

    Example Usage:
        ```lua
        hook.Add("CharListColumns", "liaExampleCharListColumns", function(columns)
            columns[#columns + 1] = {
                name = "SteamID",
                field = "steamID"
            }
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        CharListEntry(entry, row)

    Purpose:
        Allows code to append extra values to a generated character list row before it is sent to clients.

    Category:
        Administration

    Parameters:
        entry (table)
            The character entry data being serialized.

        row (table)
            The mutable row data that will be sent to the client.

    Example Usage:
        ```lua
        hook.Add("CharListEntry", "liaExampleCharListEntry", function(entry, row)
            if not istable(entry) then return end
            entry.exampleHandled = true
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        GetAdminESPTarget(ent, client)

    Purpose:
        Allows clientside code to override which entity should be treated as the admin ESP target.

    Category:
        Administration

    Parameters:
        ent (Entity)
            The entity currently under consideration.

        client (Player)
            The local player drawing admin ESP.

    Example Usage:
        ```lua
        hook.Add("GetAdminESPTarget", "liaExampleGetAdminESPTarget", function(ent, client)
            if not IsValid(client) then return end
            print(string.format("[MyModule] handled GetAdminESPTarget for %s", client:Name()))
        end)
        ```

    Returns:
        Entity|false|nil
            Return a replacement target entity, or false to suppress the current target.

    Realm:
        Client
]]
--[[
    Hooks:
        OnAdminSystemLoaded(groups, privileges)

    Purpose:
        Called after the administration system finishes loading usergroups and privileges.

    Category:
        Administration

    Parameters:
        groups (table)
            The registered administration groups.

        privileges (table)
            The registered privilege definitions.

    Example Usage:
        ```lua
        hook.Add("OnAdminSystemLoaded", "liaExampleOnAdminSystemLoaded", function(groups, privileges)
            print("[MyModule] handled OnAdminSystemLoaded")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnPrivilegeRegistered(privilege)

    Purpose:
        Called after a new administration privilege is registered.

    Category:
        Administration

    Parameters:
        privilege (table)
            The registered privilege definition.

    Example Usage:
        ```lua
        hook.Add("OnPrivilegeRegistered", "liaExampleOnPrivilegeRegistered", function(privilege)
            print("[MyModule] handled OnPrivilegeRegistered")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnPrivilegeUnregistered(privilege)

    Purpose:
        Called after an administration privilege is removed.

    Category:
        Administration

    Parameters:
        privilege (table)
            The privilege definition that was removed.

    Example Usage:
        ```lua
        hook.Add("OnPrivilegeUnregistered", "liaExampleOnPrivilegeUnregistered", function(privilege)
            print("[MyModule] handled OnPrivilegeUnregistered")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnSetUsergroup(sid, newGroup, source, player)

    Purpose:
        Called after the administration system changes a player's usergroup.

    Category:
        Administration

    Parameters:
        sid (string)
            The SteamID being updated.

        newGroup (string)
            The new usergroup name.

        source (string|nil)
            The source or provider that triggered the change.

        player (Player|nil)
            The online player object, if available.

    Example Usage:
        ```lua
        hook.Add("OnSetUsergroup", "liaExampleOnSetUsergroup", function(sid, newGroup, source, player)
            print("[MyModule] handled OnSetUsergroup")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnUsergroupCreated(groupName, groupData)

    Purpose:
        Called after a new administration usergroup is created.

    Category:
        Administration

    Parameters:
        groupName (string)
            The created usergroup name.

        groupData (table)
            The stored usergroup definition.

    Example Usage:
        ```lua
        hook.Add("OnUsergroupCreated", "liaExampleOnUsergroupCreated", function(groupName, groupData)
            if not istable(groupData) then return end
            groupData.exampleHandled = true
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnUsergroupPermissionsChanged(groupName, groupData)

    Purpose:
        Called after a usergroup's permissions are changed.

    Category:
        Administration

    Parameters:
        groupName (string)
            The updated usergroup name.

        groupData (table)
            The updated usergroup definition.

    Example Usage:
        ```lua
        hook.Add("OnUsergroupPermissionsChanged", "liaExampleOnUsergroupPermissionsChanged", function(groupName, groupData)
            if not istable(groupData) then return end
            groupData.exampleHandled = true
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnUsergroupRemoved(groupName)

    Purpose:
        Called after an administration usergroup is removed.

    Category:
        Administration

    Parameters:
        groupName (string)
            The removed usergroup name.

    Example Usage:
        ```lua
        hook.Add("OnUsergroupRemoved", "liaExampleOnUsergroupRemoved", function(groupName)
            print("[MyModule] handled OnUsergroupRemoved")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        OnUsergroupRenamed(oldName, newName)

    Purpose:
        Called after an administration usergroup is renamed.

    Category:
        Administration

    Parameters:
        oldName (string)
            The previous usergroup name.

        newName (string)
            The new usergroup name.

    Example Usage:
        ```lua
        hook.Add("OnUsergroupRenamed", "liaExampleOnUsergroupRenamed", function(oldName, newName)
            print("[MyModule] handled OnUsergroupRenamed")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        PlayerGagged(target, admin)

    Purpose:
        Called after a player is gagged.

    Category:
        Administration

    Parameters:
        target (Player)
            The player who was gagged.

        admin (Player)
            The admin who applied the gag.

    Example Usage:
        ```lua
        hook.Add("PlayerGagged", "liaExamplePlayerGagged", function(target, admin)
            if not IsValid(target) then return end
            print(string.format("[MyModule] handled PlayerGagged for %s", target:Name()))
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        PlayerMuted(target, admin)

    Purpose:
        Called after a player is muted.

    Category:
        Administration

    Parameters:
        target (Player)
            The player who was muted.

        admin (Player)
            The admin who applied the mute.

    Example Usage:
        ```lua
        hook.Add("PlayerMuted", "liaExamplePlayerMuted", function(target, admin)
            if not IsValid(target) then return end
            print(string.format("[MyModule] handled PlayerMuted for %s", target:Name()))
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        PlayerUngagged(target, admin)

    Purpose:
        Called after a player is ungagged.

    Category:
        Administration

    Parameters:
        target (Player)
            The player who was ungagged.

        admin (Player)
            The admin who removed the gag.

    Example Usage:
        ```lua
        hook.Add("PlayerUngagged", "liaExamplePlayerUngagged", function(target, admin)
            if not IsValid(target) then return end
            print(string.format("[MyModule] handled PlayerUngagged for %s", target:Name()))
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        PlayerUnmuted(target, admin)

    Purpose:
        Called after a player is unmuted.

    Category:
        Administration

    Parameters:
        target (Player)
            The player who was unmuted.

        admin (Player)
            The admin who removed the mute.

    Example Usage:
        ```lua
        hook.Add("PlayerUnmuted", "liaExamplePlayerUnmuted", function(target, admin)
            if not IsValid(target) then return end
            print(string.format("[MyModule] handled PlayerUnmuted for %s", target:Name()))
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        RunAdminSystemCommand(cmd, victim, dur, reason)

    Purpose:
        Allows clientside code to handle an admin command before the chat-command fallback runs.

    Category:
        Administration

    Parameters:
        cmd (string)
            The admin command being executed.

        victim (Player|string)
            The target player or identifier.

        dur (number|nil)
            The optional duration for timed commands.

        reason (string|nil)
            The optional reason text supplied with the command.

    Example Usage:
        ```lua
        hook.Add("RunAdminSystemCommand", "liaExampleRunAdminSystemCommand", function(cmd, victim, dur, reason)
            if cmd == "goto" and victim then
                return true, function()
                    chat.AddText(Color(255, 200, 0), "Opening a custom goto confirmation for ", tostring(victim))
                end
            end
        end)
        ```

    Returns:
        boolean|nil, function|nil
            Return true and a callback to handle the command through the hook.

    Realm:
        Client
]]
MODULE.Name = "Administration"
MODULE.author = "Samael"
MODULE.discord = "liliaplayer"
MODULE.desc = "Provides comprehensive administration tools and staff management features."
MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", "liaMapEntityAction", "liaModifyCharacterFlags", "liaNetProfilerLogs", "liaNetProfilerSnapshot", "liaOnlineStaffData", "liaPksCount", "liaRequestAllFlags", "liaRequestFullCharList", "liaRequestFullCharListPage", "liaRequestMapEntities", "liaRequestNetProfilerLogs", "liaRequestNetProfilerSnapshot", "liaRequestPksCount", "liaRequestPlayers", "liaRequestStaffCases", "liaRequestStaffSummary", "liaRequestToolPermissionTiers", "liaRequestStaffCharacterConfiguration", "liaSetFeaturePosition", "liaSetStaffCharacterFlag", "liaSetStaffCharacterPermission", "liaSetToolPermissionTier", "liaSetToolPermissionTiersBatch", "liaResetStaffCharacterConfiguration", "liaResetToolPermissionTiers", "liaSpawnMenuGiveItem", "liaSpawnMenuSpawnItem", "liaStaffCasesSnapshot", "liaStaffCharacterConfiguration", "liaStaffSummary", "liaToolPermissionTiers",}
MODULE.Privileges = {
    ["ManageWeaponOverrides"] = {
        Name = "Manage Weapon Overrides",
        MinAccess = "superadmin",
        Category = "Staff: Items",
    },
    ["canUseItemSpawner"] = {
        Name = "Can Use Item Spawner",
        MinAccess = "admin",
        Category = "Staff: Items",
    },
    ["managePropBlacklist"] = {
        Name = "Manage Prop Blacklist",
        MinAccess = "superadmin",
        Category = "Blacklisting",
    },
    ["staffHUD"] = {
        Name = "Staff HUD",
        MinAccess = "superadmin",
        Category = "developmentHUD",
    },
    ["developmentHUD"] = {
        Name = "Development HUD",
        MinAccess = "superadmin",
        Category = "developmentHUD",
    },
    ["manageBodygroups"] = {
        Name = "Manage Bodygroups",
        MinAccess = "admin",
        Category = "bodygroups",
    },
    ["changeBodygroups"] = {
        Name = "Change Bodygroups",
        Description = "Allows access to changing another player's bodygroups.",
        MinAccess = "admin",
        Category = "bodygroups",
    },
    ["manageVehicleBlacklist"] = {
        Name = "Manage Vehicle Blacklist",
        MinAccess = "superadmin",
        Category = "Blacklisting",
    },
    ["accessEditConfigurationMenu"] = {
        Name = "Access Edit Configuration Menu",
        MinAccess = "superadmin",
        Category = "User Interface",
    },
    ["manageUsergroups"] = {
        Name = "Manage Permissions",
        MinAccess = "superadmin",
        Category = "Usergroups",
    },
    ["viewStaffManagement"] = {
        Name = "View Staff Management",
        MinAccess = "superadmin",
        Category = "Staff: Management",
    },
    ["viewNetProfiler"] = {
        Name = "View Net Logs",
        Description = "Allows viewing, filtering, sorting, and paging through network message usage from the admin menu.",
        MinAccess = "superadmin",
        Category = "Server",
    },
    ["canAccessPlayerList"] = {
        Name = "Can Access Player List",
        MinAccess = "admin",
        Category = "Players",
    },
    ["listCharacters"] = {
        Name = "List Characters",
        MinAccess = "admin",
        Category = "Character",
    },
    ["canAccessFlagManagement"] = {
        Name = "Can Access Flag Management",
        MinAccess = "superadmin",
        Category = "Flags",
    },
    ["createStaffCharacter"] = {
        Name = "Create Staff Character",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["canBypassSAMFactionWhitelist"] = {
        Name = "Can Bypass Staff Faction SAM Command whitelist",
        MinAccess = "superadmin",
        Category = "SAM | Admin Mod",
    },
    ["canEditSimfphysCars"] = {
        Name = "Can Edit Simfphys Cars",
        MinAccess = "superadmin",
        Category = "Simfphys Vehicles",
    },
    ["canSeeSAMNotificationsOutsideStaff"] = {
        Name = "Can See SAM Notifications Outside Staff Character",
        MinAccess = "superadmin",
        Category = "SAM | Admin Mod",
    },
    ["checkInventories"] = {
        Name = "Check Inventories",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageAttributes"] = {
        Name = "Manage Attributes",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageCharacterInformation"] = {
        Name = "Manage Character Information",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageCharacters"] = {
        Name = "Manage Characters",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageClasses"] = {
        Name = "Manage Classes",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageDoors"] = {
        Name = "Manage Doors",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageFlags"] = {
        Name = "Manage Flags",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageSitRooms"] = {
        Name = "Manage Administration Rooms",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["manageTransfers"] = {
        Name = "Manage Transfers",
        MinAccess = "admin",
        Category = "Staff: Management",
    },
    ["receiveCheaterNotifications"] = {
        Name = "Receive Cheater Notifications",
        MinAccess = "admin",
        Category = "Exploiting",
    },
    ["viewEntityTab"] = {
        Name = "View Entity Tab",
        MinAccess = "admin",
        Category = "Exploiting",
    },
    ["stopSoundForEveryone"] = {
        Name = "Stop Sound For Everyone",
        MinAccess = "superadmin",
        Category = "Server",
    },
    ["useDisallowedTools"] = {
        Name = "Use Disallowed Tools",
        MinAccess = "superadmin",
        Category = "Staff: Tools",
    },
    ["canBypassCharacterLock"] = {
        Name = "Can Bypass Character Lock",
        MinAccess = "superadmin",
        Category = "Staff: Management",
    },
    ["canGrabWorldProps"] = {
        Name = "Can Grab World Props",
        MinAccess = "superadmin",
        Category = "Staff: Physgun",
    },
    ["canGrabPlayers"] = {
        Name = "Can Grab Players",
        MinAccess = "superadmin",
        Category = "Staff: Physgun",
    },
    ["physgunPickup"] = {
        Name = "Physgun Pickup",
        MinAccess = "admin",
        Category = "Staff: Physgun",
    },
    ["canAccessItemInformations"] = {
        Name = "Can Access Item Informations",
        MinAccess = "superadmin",
        Category = "Staff: Items",
    },
    ["physgunPickupRestrictedEntities"] = {
        Name = "Physgun Pickup on Restricted Entities",
        MinAccess = "superadmin",
        Category = "Staff: Physgun",
    },
    ["physgunPickupVehicles"] = {
        Name = "Physgun Pickup on Vehicles",
        MinAccess = "admin",
        Category = "Staff: Physgun",
    },
    ["cantBeGrabbedPhysgun"] = {
        Name = "Can't be Grabbed with PhysGun",
        MinAccess = "superadmin",
        Category = "Staff: Protection",
    },
    ["canPhysgunReload"] = {
        Name = "Can Physgun Reload",
        MinAccess = "superadmin",
        Category = "Staff: Physgun",
    },
    ["noClipOutsideStaff"] = {
        Name = "Noclip Outside Staff Character",
        MinAccess = "superadmin",
        Category = "Staff: Movement",
    },
    ["noClipESPOffsetStaff"] = {
        Name = "Noclip ESP Outside Staff Character",
        MinAccess = "superadmin",
        Category = "User Interface",
    },
    ["canPropertyWorldEntities"] = {
        Name = "Can Property World Entities",
        MinAccess = "superadmin",
        Category = "Staff: Management",
    },
    ["canSpawnRagdolls"] = {
        Name = "Can Spawn Ragdolls",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnSWEPs"] = {
        Name = "Can Spawn SWEPs",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canEditWeapons"] = {
        Name = "Can Edit Weapons",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnEffects"] = {
        Name = "Can Spawn Effects",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnProps"] = {
        Name = "Can Spawn Props",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnBlacklistedProps"] = {
        Name = "Can Spawn Blacklisted Props",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnNPCs"] = {
        Name = "Can Spawn NPCs",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["noCarSpawnDelay"] = {
        Name = "No Car Spawn Delay",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnCars"] = {
        Name = "Can Spawn Cars",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnBlacklistedCars"] = {
        Name = "Can Spawn Blacklisted Cars",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnSENTs"] = {
        Name = "Can Spawn SENTs",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canRemoveBlockedEntities"] = {
        Name = "Can Remove Blocked Entities",
        MinAccess = "admin",
        Category = "Staff: Blacklisting",
    },
    ["canRemoveWorldEntities"] = {
        Name = "Can Remove World Entities",
        MinAccess = "superadmin",
        Category = "Staff: Management",
    },
    ["usePositionTool"] = {
        Name = "Use Position Tool",
        MinAccess = "superadmin",
        Category = "Staff: Tools",
    },
    ["command_ban"] = {
        Name = "Access to Ban Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_kick"] = {
        Name = "Access to Kick Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_kill"] = {
        Name = "Access to Kill Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_freeze"] = {
        Name = "Access to Freeze Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unfreeze"] = {
        Name = "Access to Unfreeze Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_slay"] = {
        Name = "Access to Slay Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_respawn"] = {
        Name = "Access to Respawn Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_blind"] = {
        Name = "Access to Blind Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unblind"] = {
        Name = "Access to Unblind Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_gag"] = {
        Name = "Access to Gag Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_ungag"] = {
        Name = "Access to Ungag Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_mute"] = {
        Name = "Access to Mute Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unmute"] = {
        Name = "Access to Unmute Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_bring"] = {
        Name = "Access to Bring Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_goto"] = {
        Name = "Access to Goto Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_return"] = {
        Name = "Access to Return Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_jail"] = {
        Name = "Access to Jail Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unjail"] = {
        Name = "Access to Unjail Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_cloak"] = {
        Name = "Access to Cloak Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_uncloak"] = {
        Name = "Access to Uncloak Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_god"] = {
        Name = "Access to God Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_ungod"] = {
        Name = "Access to Ungod Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_ignite"] = {
        Name = "Access to Ignite Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_extinguish"] = {
        Name = "Access to Extinguish Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_strip"] = {
        Name = "Access to Strip Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["canManageNPCs"] = {
        Name = "Can Manage Dialog NPCs",
        MinAccess = "admin",
        Category = "NPCs",
    },
    ["canManageProperties"] = {
        Name = "Can Manage Properties",
        MinAccess = "superadmin",
        Category = "Staff: Management",
    },
    ["seeInsertNotifications"] = {
        Name = "See Insert Notifications",
        MinAccess = "superadmin",
        Category = "Staff: Management",
    },
}
