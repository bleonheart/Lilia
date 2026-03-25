MODULE.name = "@inv"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "@inventorySystemDescription"
MODULE.IsWeightBased = true
MODULE.Privileges = {
    ["noItemCooldown"] = {
        Name = "@noItemCooldown",
        MinAccess = "admin",
        Category = "@categoryStaffManagement"
    }
}

--[[
if MODULE.IsWeightBased then
    lia.loader.include(MODULE.folder .. "/gridinv.lua", "shared")
    lia.loader.includeDir(MODULE.folder .. "/gridinv")

else
    lia.loader.include(MODULE.folder .. "/gridinv.lua", "shared")
    lia.loader.includeDir(MODULE.folder .. "/gridinv")
end]]
MODULE.Dependencies = {
    {
        File = "gridinv.lua",
        Realm = "shared"
    },
}
