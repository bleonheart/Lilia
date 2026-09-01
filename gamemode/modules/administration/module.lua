MODULE.Name = "Administration"
MODULE.author = "Samael"
MODULE.discord = "liliaplayer"
MODULE.desc = "Provides comprehensive administration tools and staff management features."
MODULE.NetworkStrings = {"liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", "liaMapEntityAction", "liaModifyCharacterFlags", "liaNetProfilerLogs", "liaNetProfilerSnapshot", "liaOnlineStaffData", "liaRequestFullCharListPage", "liaRequestMapEntities", "liaRequestNetProfilerLogs", "liaRequestStaffCases", "liaRequestToolPermissionTiers", "liaRequestStaffCharacterConfiguration", "liaSetFeaturePosition", "liaSetStaffCharacterFlag", "liaSetStaffCharacterPermission", "liaSetToolPermissionTier", "liaSetToolPermissionTiersBatch", "liaResetStaffCharacterConfiguration", "liaResetToolPermissionTiers", "liaSpawnMenuGiveItem", "liaSpawnMenuSpawnItem", "liaStaffCasesSnapshot", "liaStaffCharacterConfiguration", "liaToolPermissionTiers", "liaBodygrouperMenu", "liaBodygrouperMenuClose", "liaBodygrouperMenuCloseClientside", "liaSeeModelTable", "liaWardrobeChangeModel",}
MODULE.Privileges = {
    ["ManageWeaponOverrides"] = {
        Name = "Manage Weapon Overrides",
        MinAccess = "superadmin",
        Category = "Staff: Items",
    },
    ["canSeeAltingNotifications"] = {
        Name = "Can See Alting Notifications",
        MinAccess = "admin",
        Category = "Exploiting",
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
    ["canAccessScoreboardAdminOptions"] = {
        Name = "Can Access Scoreboard Admin Options",
        MinAccess = "admin",
        Category = "User Interface",
    },
    ["canAccessScoreboardInfoOutOfStaff"] = {
        Name = "Can Access Scoreboard Info Out Of Staff",
        MinAccess = "admin",
        Category = "User Interface",
    },
    ["listCharacters"] = {
        Name = "List Characters",
        MinAccess = "admin",
        Category = "Character",
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
    ["canUsePAC3"] = {
        Name = "Can Use PAC3",
        MinAccess = "admin",
        Category = "Compatibility",
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
    ["command_blind"] = {
        Name = "Access to Blind Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_mute"] = {
        Name = "Access to Mute Command",
        MinAccess = "admin",
        Category = "Commands",
    },
    ["command_goto"] = {
        Name = "Access to Goto Command",
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