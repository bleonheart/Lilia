MODULE.name = "Perfopus Performance Metrics"
MODULE.author = "Rammel, Zippy, bloodycop"
MODULE.desc = "Profiles Lua hooks, timers, and entity methods and displays the results in the Lilia F1 menu."
MODULE.NetworkStrings = {
    "liaPerfopusStart",
    "liaPerfopusMetric",
    "liaPerfopusSettings"
}
MODULE.Privileges = {
    ["viewPerformanceMetrics"] = {
        Name = "View Performance Metrics",
        MinAccess = "superadmin",
        Category = "Development",
        Description = "Allows access to the Perfopus profiler and its F1 performance metrics tab."
    }
}
