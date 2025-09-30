MODULE.name = "Administration"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("administrationToolsDescription")
MODULE.Privileges = {
    {
        Name = L("managePropBlacklist"),
        ID = "managePropBlacklist",
        MinAccess = "superadmin",
        Category = "categoryBlacklisting",
    },
    {
        Name = L("manageVehicleBlacklist"),
        ID = "manageVehicleBlacklist",
        MinAccess = "superadmin",
        Category = "categoryBlacklisting",
    },
    {
        Name = L("accessEditConfigurationMenu"),
        ID = "accessEditConfigurationMenu",
        MinAccess = "superadmin",
        Category = "categoryConfiguration",
    },
    {
        Name = L("manageUsergroups"),
        ID = "manageUsergroups",
        MinAccess = "superadmin",
        Category = "categoryUsergroups",
    },
    {
        Name = L("viewStaffManagement"),
        ID = "viewStaffManagement",
        MinAccess = "superadmin",
        Category = "categoryStaffManagement",
    },
    {
        Name = L("canAccessPlayerList"),
        ID = "canAccessPlayerList",
        MinAccess = "admin",
        Category = "players",
    },
    {
        Name = L("listCharacters"),
        ID = "listCharacters",
        MinAccess = "admin",
        Category = "character",
    },
    {
        Name = L("viewDBTables"),
        ID = "viewDBTables",
        MinAccess = "superadmin",
        Category = "database",
    },
    {
        Name = L("canAccessFlagManagement"),
        ID = "canAccessFlagManagement",
        MinAccess = "superadmin",
        Category = "flags",
    },
    {
        ID = "createStaffCharacter",
        Name = L("createStaffCharacter"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "canBypassSAMFactionWhitelist",
        Name = L("canBypassSAMFactionWhitelist"),
        MinAccess = "superadmin",
        Category = "categorySAM",
    },
    {
        ID = "canEditSimfphysCars",
        Name = L("canEditSimfphysCars"),
        MinAccess = "superadmin",
        Category = "simfphysVehicles",
    },
    {
        ID = "canSeeSAMNotificationsOutsideStaff",
        Name = L("canSeeSAMNotificationsOutsideStaff"),
        MinAccess = "superadmin",
        Category = "categorySAM",
    },
    {
        ID = "checkInventories",
        Name = L("checkInventories"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageAttributes",
        Name = L("manageAttributes"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageCharacterInformation",
        Name = L("manageCharacterInformation"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageCharacters",
        Name = L("manageCharacters"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageClasses",
        Name = L("manageClasses"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageDoors",
        Name = L("manageDoors"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageFlags",
        Name = L("manageFlags"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageSitRooms",
        Name = L("manageSitRooms"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "manageTransfers",
        Name = L("manageTransfers"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
    {
        ID = "receiveCheaterNotifications",
        Name = L("receiveCheaterNotifications"),
        MinAccess = "admin",
        Category = "protection",
    },
    {
        ID = "stopSoundForEveryone",
        Name = L("stopSoundForEveryone"),
        MinAccess = "superadmin",
        Category = "categoryServer",
    },
    {
        ID = "useDisallowedTools",
        Name = L("useDisallowedTools"),
        MinAccess = "superadmin",
        Category = "categoryStaffTools",
    },
    {
        ID = "viewPlayerWarnings",
        Name = "viewPlayerWarnings",
        MinAccess = "admin",
        Category = "warning",
    },
    {
        ID = "privilegeViewer",
        Name = L("privilegeViewer"),
        MinAccess = "admin",
        Category = "categoryStaffManagement",
    },
}
