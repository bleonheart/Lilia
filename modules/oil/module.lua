MODULE.name = "Oil System"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Adds oil pumping and items."
MODULE.version = "1.0"

MODULE.Dependencies = {
    {
        File = "entities/entities/lia_oilpump/shared.lua",
        Realm = "shared"
    },
    {
        File = "entities/entities/lia_oilpump/cl_init.lua",
        Realm = "client"
    },
    {
        File = "entities/entities/lia_oilpump/init.lua",
        Realm = "server"
    },
    {
        File = "config.lua",
        Realm = "shared"
    }
}
