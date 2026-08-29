MODULE.Name = "Logs"
MODULE.author = "Samael"
MODULE.NetworkStrings = {"liaSendLogs", "liaSendLogsCategories", "liaSendLogsCategoriesRequest", "liaSendLogsRequest",}
MODULE.Privileges = {
    ["canSeeLogs"] = {
        Name = "Can See Logs",
        MinAccess = "superadmin",
        Category = "Logging",
    },
}
