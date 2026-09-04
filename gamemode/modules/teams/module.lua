MODULE.name = "@teamsModuleName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "@teamsSystemDescription"
MODULE.NetworkStrings = {"liaFactionMembers", "liaFactionMemberDetails", "liaKickCharacterToBase", "liaRequestFactionMembers", "liaRequestFactionMemberDetails", "liaSaveFactionNote"}
MODULE.Privileges = {
    ["canManageFactions"] = {
        Name = "@canManageFactions",
        MinAccess = "admin",
        Category = "@factionManagement",
    },
    ["manageWhitelists"] = {
        Name = "@manageWhitelists",
        MinAccess = "admin",
        Category = "@factionManagement",
    },
}
