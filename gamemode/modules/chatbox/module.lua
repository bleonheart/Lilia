MODULE.name = "Chatbox"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Replaces the default chat with a configurable box that supports colored text, command parsing, and dedicated staff channels."
MODULE.Privileges = {
    ["noOOCCooldown"] = {
        Name = "No OOC Cooldown",
        MinAccess = "admin",
        Category = "Chat",
    },
    ["adminChat"] = {
        Name = "Admin Chat",
        MinAccess = "superadmin",
        Category = "Chat",
    },
    ["localEventChat"] = {
        Name = "Local Event Chat",
        MinAccess = "admin",
        Category = "Chat",
    },
    ["eventChat"] = {
        Name = "Event Chat",
        MinAccess = "admin",
        Category = "Chat",
    },
    ["accessHelpChat"] = {
        Name = "Access Help Chat",
        MinAccess = "superadmin",
        Category = "Chat",
    },
    ["bypassOOCBlock"] = {
        Name = "Bypass OOC Block",
        MinAccess = "superadmin",
        Category = "Chat",
    },
}
