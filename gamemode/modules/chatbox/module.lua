MODULE.name = "Chat Box"
MODULE.author = "Samael"
MODULE.NetworkStrings = {"liaChatboxAddFilteredWord", "liaChatboxRemoveFilteredWord", "liaChatboxRequestFilteredWords", "liaChatboxSyncFilteredWords"}
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
        Name = "Always Have Access to Help Chat",
        MinAccess = "superadmin",
        Category = "Chat",
    },
    ["bypassOOCBlock"] = {
        Name = "Bypass OOC Block",
        MinAccess = "superadmin",
        Category = "Chat",
    },
    ["manageChatFilter"] = {
        Name = "Manage Chat Filter",
        MinAccess = "superadmin",
        Category = "Chat",
    },
}
