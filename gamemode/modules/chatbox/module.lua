MODULE.name = "Chatbox"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Replaces the default chat with a configurable box that supports colored text, command parsing, and dedicated staff channels."
MODULE.Privileges = {
    {
        Name = "No OOC Cooldown",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Admin Chat",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Local Event Chat",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Event Chat",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Always Have Access to Help Chat",
        MinAccess = "superadmin",
        Category = MODULE.name
    },
}
