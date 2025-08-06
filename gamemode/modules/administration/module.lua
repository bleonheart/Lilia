MODULE.name = "moduleAdministrationName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "moduleAdministrationDesc"
MODULE.Privileges = {
    {
        Name = L("managePropBlacklist"),
        MinAccess = "superadmin",
        Category = L("categoryBlacklisting"),
    },
    {
        Name = L("manageVehicleBlacklist"),
        MinAccess = "superadmin",
        Category = L("categoryBlacklisting"),
    },
    {
        Name = L("manageEntityBlacklist"),
        MinAccess = "superadmin",
        Category = L("categoryBlacklisting"),
    },
    {
        Name = L("accessConfigurationMenu"),
        MinAccess = "superadmin",
        Category = L("categoryConfiguration"),
    },
    {
        Name = L("accessEditConfigurationMenu"),
        MinAccess = "superadmin",
        Category = L("categoryConfiguration"),
    },
    {
        Name = L("manageUsergroups"),
        MinAccess = "superadmin",
        Category = L("categoryUsergroups"),
    },
    {
        Name = L("view") .. " " .. L("moduleStaffManagementName"),
        MinAccess = "superadmin",
        Category = L("categoryStaffManagement"),
    },
    {
        Name = L("canAccessPlayerList"),
        MinAccess = "admin",
        Category = L("players")
    },
    {
        Name = L("listCharacters"),
        MinAccess = "admin",
        Category = L("character")
    },
    {
        Name = L("viewDBTables"),
        MinAccess = "superadmin",
        Category = L("database")
    },
    {
        Name = L("canAccessFlagManagement"),
        MinAccess = "superadmin",
        Category = L("flags"),
    },
}