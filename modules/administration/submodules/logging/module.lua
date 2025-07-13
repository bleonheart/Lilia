MODULE.name = "Logger"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Implements an action logger for administrative oversight."
MODULE.version = "1.08"
MODULE.CAMIPrivileges = {
    {
        Name = "Staff Permissions - Can See Logs",
        MinAccess = "superadmin"
    }
}

MODULE.Dependencies = {
    {
        File = "logs.lua",
        Realm = "server",
    },
}
