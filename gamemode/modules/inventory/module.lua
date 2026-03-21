MODULE.name = "inventoryModuleName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "inventorySystemDescription"
MODULE.Privileges = {
    ["noItemCooldown"] = {
        Name = "No Item Cooldown",
        MinAccess = "admin",
        Category = "Staff Management"
    }
}

MODULE.Dependencies = {
    {
        File = "gridinv.lua",
        Realm = "shared"
    },
}
