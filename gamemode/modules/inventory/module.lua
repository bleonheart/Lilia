MODULE.name = "Inventory"
MODULE.author = "Samael"
MODULE.Privileges = {
    ["noItemCooldown"] = {
        Name = "No item cooldown",
        MinAccess = "admin",
        Category = "Staff: Management"
    }
}

local invType = string.lower(hook.Run("GetDefaultInventoryType") or "gridinv")
lia.module.load(invType, MODULE.folder .. "/types/" .. invType)
