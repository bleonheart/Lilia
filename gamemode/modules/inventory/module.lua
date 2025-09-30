MODULE.name = "Inventory"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("inventorySystemDescription")
MODULE.Privileges = {
    {
        Name = L("noItemCooldown"),
        ID = "noItemCooldown",
        MinAccess = "admin",
        Category = "categoryStaffManagement"
    }
}

MODULE.Dependencies = {
    {
        File = "gridinv.lua",
        Realm = "shared"
    },
}
