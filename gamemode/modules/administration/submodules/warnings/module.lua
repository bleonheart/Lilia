MODULE.Name = "Warnings"
MODULE.author = "Samael"
MODULE.NetworkStrings = {"liaAllWarnings", "liaPlayerWarnings", "liaRequestAllWarnings", "liaRequestRemoveWarning", "liaRequestWarningsCount", "liaWarningsCount",}
MODULE.Privileges = {
    ["viewPlayerWarnings"] = {
        Name = "View Player Warnings",
        MinAccess = "admin",
        Category = "Warning",
    },
    ["canRemoveWarns"] = {
        Name = "Can Remove Warns",
        MinAccess = "superadmin",
        Category = "Warning",
    },
}
