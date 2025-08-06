MODULE.name = "scoreboard"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "moduleScoreboardDesc"
MODULE.Privileges = {
    {
        Name = L("canAccessScoreboardAdminOptions"),
        MinAccess = "admin",
        Category = L("scoreboard"),
    },
    {
        Name = L("canAccessScoreboardInfoOutOfStaff"),
        MinAccess = "superadmin",
        Category = L("scoreboard"),
    },
}
