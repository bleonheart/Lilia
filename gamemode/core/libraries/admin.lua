lia.administration = lia.administration or {}
lia.administration.groups = lia.administration.groups or {}
lia.administration.privileges = lia.administration.privileges or {}
lia.administration.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
    developer = true,
}

lia.administration.DefaultPrivileges = {
    {
        Name = "Can Remove Warns",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage Prop Blacklist",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access Configuration Menu",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access Edit Configuration Menu",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage UserGroups",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Can Bypass Character Lock",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Grab World Props",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Grab Players",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Physgun Pickup",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Access Item Informations",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Physgun Pickup on Restricted Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Physgun Pickup on Vehicles",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can't be Grabbed with PhysGun",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Physgun Reload",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Clip Outside Staff Character",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Clip ESP Outside Staff Character",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Property World Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Manage Car Blacklist",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Ragdolls",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn SWEPs",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Effects",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Props",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Blacklisted Props",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn NPCs",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Car Spawn Delay",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Spawn Delay",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Cars",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Blacklisted Cars",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn SENTs",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "UserGroups - Staff Group",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "UserGroups - VIP Group",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "List Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Remove Blocked Entities",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Remove World Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "View Staff Actions",
        MinAccess = "admin",
        Category = "Staff Management"
    },
    {
        Name = "View Player Warnings",
        MinAccess = "admin",
        Category = "Staff Management"
    },
    {
        Name = "View Claims",
        MinAccess = "admin",
        Category = "Staff Management"
    },
    {
        Name = "Can Use Item Spawner",
        MinAccess = "admin",
        Category = "Item Spawner"
    },
    {
        Name = "Use Admin Stick",
        MinAccess = "superadmin",
        Category = "Admin Stick"
    },
    {
        Name = "Can See Logs",
        MinAccess = "superadmin",
        Category = "Logger"
    },
    {
        Name = "Always See Tickets",
        MinAccess = "superadmin",
        Category = "Tickets"
    },
    {
        Name = "No OOC Cooldown",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Admin Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Local Event Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Event Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Always Have Access to Help Chat",
        MinAccess = "superadmin",
        Category = "Chatbox"
    },
    {
        Name = "Can Access Scoreboard Admin Options",
        MinAccess = "admin",
        Category = "Scoreboard"
    },
    {
        Name = "Can Access Scoreboard Info Out Of Staff",
        MinAccess = "admin",
        Category = "Scoreboard"
    },
    {
        Name = "Can Edit Vendors",
        MinAccess = "admin",
        Category = "Vendors"
    },
    {
        Name = "Can Spawn Storage",
        MinAccess = "superadmin",
        Category = "Storage"
    },
    {
        Name = "Can See Alting Notifications",
        MinAccess = "admin",
        Category = "Protection"
    },
    {
        Name = "Access Entity List",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Teleport to Entity",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Teleport to Entity (Entity Tab)",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "View Entity (Entity Tab)",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Access Module List",
        MinAccess = "user",
        Category = "F1 Menu"
    },
}