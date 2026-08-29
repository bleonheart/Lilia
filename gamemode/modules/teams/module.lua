MODULE.name = "Teams"
MODULE.author = "Samael"
MODULE.NetworkStrings = {"liaFactionMembers", "liaFactionMemberDetails", "liaKickCharacterToBase", "liaRequestFactionMembers", "liaRequestFactionMemberDetails", "liaSaveFactionNote"}
MODULE.Privileges = {
    ["canManageFactions"] = {
        Name = "Can Manage Factions",
        MinAccess = "admin",
        Category = "Faction Management",
    },
    ["manageWhitelists"] = {
        Name = "Manage Whitelists",
        MinAccess = "admin",
        Category = "Faction Management",
    },
}
