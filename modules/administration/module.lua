lia.admin = lia.admin or {}
lia.admin.bans = lia.admin.bans or {}
lia.admin.bans.list = lia.admin.bans.list or {}
lia.admin.permissions = lia.admin.permissions or {}
MODULE.name = "Administration Utilities"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides utility commands and tools for server administration."
MODULE.CAMIPrivileges = {
    {
        Name = "Staff Permissions - Can Remove Warns",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Manage Prop Blacklist",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Access Configuration Menu",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Access Edit Configuration Menu",
        MinAccess = "superadmin"
    },
}