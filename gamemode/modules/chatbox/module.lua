MODULE.name = "Chatbox"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("chatSystemDescription")
MODULE.Privileges = {
    {
        Name = L("noOOCCooldown"),
        ID = "noOOCCooldown",
        MinAccess = "admin",
        Category = "categoryChat",
    },
    {
        Name = L("adminChat"),
        ID = "adminChat",
        MinAccess = "admin",
        Category = "categoryChat",
    },
    {
        Name = L("localEventChat"),
        ID = "localEventChat",
        MinAccess = "admin",
        Category = "categoryChat",
    },
    {
        Name = L("eventChat"),
        ID = "eventChat",
        MinAccess = "admin",
        Category = "categoryChat",
    },
    {
        Name = L("accessHelpChat"),
        ID = "accessHelpChat",
        MinAccess = "superadmin",
        Category = "categoryChat",
    },
}
