MODULE.name = "Scoreboard"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("scoreboardDescription")
MODULE.Privileges = {
    {
        Name = L("canAccessScoreboardAdminOptions"),
        ID = "canAccessScoreboardAdminOptions",
        MinAccess = "admin",
        Category = "scoreboard",
    },
    {
        Name = L("canAccessScoreboardInfoOutOfStaff"),
        ID = "canAccessScoreboardInfoOutOfStaff",
        MinAccess = "superadmin",
        Category = "scoreboard",
    },
}
