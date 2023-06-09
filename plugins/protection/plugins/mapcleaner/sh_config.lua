lia.config.add("MapCleanerEnabled", true, "Whether or not the Map Cleaner is Enabled.", nil, {
    category = "Server Settings"
})

lia.config.add("ItemCleanupTime", 7200, "Time Between Item, Cleanups (In Seconds)", nil, {
    data = {
        min = 1,
        max = 5000
    },
    category = "Server Settings"
})

lia.config.add("MapCleanupTime", 21600, "Time Between Map Cleanups (In Seconds)", nil, {
    data = {
        min = 1,
        max = 5000
    },
    category = "Server Settings"
})