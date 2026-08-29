MODULE.name = "Storage"
MODULE.author = "Samael"
MODULE.NetworkStrings = {"liaStorageExit", "liaStorageSetPassword", "liaStorageTransfer", "liaStorageUnlock", "liaTrunkInitStorage",}
MODULE.Privileges = {
    ["canSpawnStorage"] = {
        Name = "Can Spawn Storage",
        MinAccess = "superadmin",
        Category = "Spawn Permissions",
    }
}
