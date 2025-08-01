MODULE.name = L("moduleAdministrationName")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("moduleAdministrationDesc")
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
        Category = L("categoryStaffPermissions"),
    },
    {
        Name = L("accessEditConfigurationMenu"),
        MinAccess = "superadmin",
        Category = L("categoryStaffPermissions"),
    },
}