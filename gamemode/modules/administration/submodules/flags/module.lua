-- luacheck: globals MODULE L

MODULE.name = L("flagsManagement")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("moduleFlagsManagementDesc")

MODULE.Privileges = {
    {
        Name = L("canAccessFlagManagement"),
        MinAccess = "superadmin",
        Category = L("categoryFlags"),
    }
}

