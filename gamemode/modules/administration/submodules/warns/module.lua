MODULE.name = "Warns"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("warningSystemDescription")
MODULE.Privileges = {
    {
        Name = L("canRemoveWarns"),
        ID = "canRemoveWarns",
        MinAccess = "superadmin",
        Category = "warning",
    },
    {
        Name = L("viewPlayerWarnings"),
        ID = "viewPlayerWarnings",
        MinAccess = "admin",
        Category = "warning",
    },
}
