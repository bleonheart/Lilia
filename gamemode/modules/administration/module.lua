MODULE.name = "Administration"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides comprehensive administration tools and staff management features."
MODULE.Privileges = {
    ["ManageWeaponOverrides"] = {
        Name = "Manage Weapon Overrides",
        MinAccess = "superadmin",
        Category = "Staff Items",
    },
    ["canUseItemSpawner"] = {
        Name = "Use Item Spawner",
        MinAccess = "admin",
        Category = "Staff Items",
    },
    ["managePropBlacklist"] = {
        Name = "Manage Prop Blacklist",
        MinAccess = "superadmin",
        Category = "Blacklisting",
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
        Name = "Manage Usergroups",
        MinAccess = "superadmin",
        Category = "Usergroups",
    },
    ["viewStaffManagement"] = {
        Name = "View Staff Management",
        MinAccess = "superadmin",
        Category = "Staff Management",
    },
    ["canAccessPlayerList"] = {
        Name = "Access Player List",
        MinAccess = "admin",
        Category = "Players",
    },
    ["listCharacters"] = {
        Name = "List Characters",
        MinAccess = "admin",
        Category = "Character",
    },
    ["canAccessFlagManagement"] = {
        Name = "Access Flag Management",
        MinAccess = "superadmin",
        Category = "Flags",
    },
    ["createStaffCharacter"] = {
        Name = "Create Staff Character",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["canBypassSAMFactionWhitelist"] = {
        Name = "Bypass SAM Faction Whitelist",
        MinAccess = "superadmin",
        Category = "SAM",
    },
    ["canEditSimfphysCars"] = {
        Name = "Edit Simfphys Cars",
        MinAccess = "superadmin",
        Category = "Simfphys Vehicles",
    },
    ["canSeeSAMNotificationsOutsideStaff"] = {
        Name = "See SAM Notifications Outside Staff",
        MinAccess = "superadmin",
        Category = "SAM",
    },
    ["checkInventories"] = {
        Name = "Check Inventories",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageAttributes"] = {
        Name = "Manage Attributes",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageCharacterInformation"] = {
        Name = "Manage Character Information",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageCharacters"] = {
        Name = "Manage Characters",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageClasses"] = {
        Name = "Manage Classes",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageDoors"] = {
        Name = "Manage Doors",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageFlags"] = {
        Name = "Manage Flags",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageSitRooms"] = {
        Name = "Manage Sit Rooms",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["manageTransfers"] = {
        Name = "Manage Transfers",
        MinAccess = "admin",
        Category = "Staff Management",
    },
    ["receiveCheaterNotifications"] = {
        Name = "Receive Cheater Notifications",
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
        Category = "Staff Tools",
    },
    ["viewPlayerWarnings"] = {
        Name = "View Player Warnings",
        MinAccess = "admin",
        Category = "Warning",
    },
    ["canRemoveWarns"] = {
        Name = "Remove Warnings",
        MinAccess = "superadmin",
        Category = "Warning",
    },
    ["alwaysSeeTickets"] = {
        Name = "Always See Tickets",
        MinAccess = "superadmin",
        Category = "Tickets",
    },
    ["canBypassCharacterLock"] = {
        Name = "Bypass Character Lock",
        MinAccess = "superadmin",
        Category = "Staff Management",
    },
    ["canGrabWorldProps"] = {
        Name = "Grab World Props",
        MinAccess = "superadmin",
        Category = "Staff Physgun",
    },
    ["canGrabPlayers"] = {
        Name = "Grab Players",
        MinAccess = "superadmin",
        Category = "Staff Physgun",
    },
    ["physgunPickup"] = {
        Name = "Physgun Pickup",
        MinAccess = "admin",
        Category = "Staff Physgun",
    },
    ["canAccessItemInformations"] = {
        Name = "Access Item Informations",
        MinAccess = "superadmin",
        Category = "Staff Items",
    },
    ["physgunPickupRestrictedEntities"] = {
        Name = "Physgun Pickup Restricted Entities",
        MinAccess = "superadmin",
        Category = "Staff Physgun",
    },
    ["physgunPickupVehicles"] = {
        Name = "Physgun Pickup Vehicles",
        MinAccess = "admin",
        Category = "Staff Physgun",
    },
    ["cantBeGrabbedPhysgun"] = {
        Name = "Cannot Be Grabbed by Physgun",
        MinAccess = "superadmin",
        Category = "Staff Protection",
    },
    ["canPhysgunReload"] = {
        Name = "Physgun Reload",
        MinAccess = "superadmin",
        Category = "Staff Physgun",
    },
    ["noClipOutsideStaff"] = {
        Name = "No Clip Outside Staff",
        MinAccess = "superadmin",
        Category = "Staff Movement",
    },
    ["noClipESPOffsetStaff"] = {
        Name = "No Clip ESP Offset Staff",
        MinAccess = "superadmin",
        Category = "User Interface",
    },
    ["canPropertyWorldEntities"] = {
        Name = "Property World Entities",
        MinAccess = "superadmin",
        Category = "Staff Management",
    },
    ["canSpawnRagdolls"] = {
        Name = "Spawn Ragdolls",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnSWEPs"] = {
        Name = "Spawn SWEPs",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canEditWeapons"] = {
        Name = "Edit Weapons",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnEffects"] = {
        Name = "Spawn Effects",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnProps"] = {
        Name = "Spawn Props",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnBlacklistedProps"] = {
        Name = "Spawn Blacklisted Props",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnNPCs"] = {
        Name = "Spawn NPCs",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["noCarSpawnDelay"] = {
        Name = "No Car Spawn Delay",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnCars"] = {
        Name = "Spawn Cars",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canSpawnBlacklistedCars"] = {
        Name = "Spawn Blacklisted Cars",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    },
    ["canSpawnSENTs"] = {
        Name = "Spawn SENTs",
        MinAccess = "admin",
        Category = "Spawn Permissions",
    },
    ["canRemoveBlockedEntities"] = {
        Name = "Remove Blocked Entities",
        MinAccess = "admin",
        Category = "Staff Blacklisting",
    },
    ["canRemoveWorldEntities"] = {
        Name = "Remove World Entities",
        MinAccess = "superadmin",
        Category = "Staff Management",
    },
    ["canSeeLogs"] = {
        Name = "See Logs",
        MinAccess = "superadmin",
        Category = "Logging",
    },
    ["alwaysSpawnAdminStick"] = {
        Name = "Always Spawn Admin Stick",
        MinAccess = "superadmin",
        Category = "Admin Stick",
    },
    ["usePositionTool"] = {
        Name = "Use Position Tool",
        MinAccess = "superadmin",
        Category = "Staff Tools",
    },
    ["command_ban"] = {
        Name = "commandBan",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_kick"] = {
        Name = "commandKick",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_kill"] = {
        Name = "commandKill",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_freeze"] = {
        Name = "commandFreeze",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unfreeze"] = {
        Name = "commandUnfreeze",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_slay"] = {
        Name = "commandSlay",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_respawn"] = {
        Name = "commandRespawn",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_blind"] = {
        Name = "commandBlind",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unblind"] = {
        Name = "commandUnblind",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_gag"] = {
        Name = "commandGag",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_ungag"] = {
        Name = "commandUngag",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_mute"] = {
        Name = "commandMute",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unmute"] = {
        Name = "commandUnmute",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_bring"] = {
        Name = "commandBring",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_goto"] = {
        Name = "commandGoto",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_return"] = {
        Name = "commandReturn",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_jail"] = {
        Name = "commandJail",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_unjail"] = {
        Name = "commandUnjail",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_cloak"] = {
        Name = "commandCloak",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_uncloak"] = {
        Name = "commandUncloak",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_god"] = {
        Name = "commandGod",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_ungod"] = {
        Name = "commandUngod",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_ignite"] = {
        Name = "commandIgnite",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_extinguish"] = {
        Name = "commandExtinguish",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_strip"] = {
        Name = "commandStrip",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["canManageNPCs"] = {
        Name = "Manage NPCs",
        MinAccess = "admin",
        Category = "NPCs",
    },
    ["canManageProperties"] = {
        Name = "Manage Properties",
        MinAccess = "superadmin",
        Category = "Staff Management",
    },
    ["seeInsertNotifications"] = {
        Name = "See Insert Notifications",
        MinAccess = "superadmin",
        Category = "Staff Management",
    },
}
