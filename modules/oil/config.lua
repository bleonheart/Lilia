
lia.config.add("OilPumpCooldown", "Oil Pump Cooldown", 60, nil, {
    desc = "Time in seconds before the pump can be used again.",
    category = "Economy",
    type = "Int",
    min = 1,
    max = 3600
})

lia.config.add("OilPumpYield", "Oil Pump Yield", 1, nil, {
    desc = "Amount of low-quality oil granted per pump.",
    category = "Economy",
    type = "Int",
    min = 1,
    max = 10
})

lia.config.add("OilPumpActionTime", "Oil Pump Action Time", 5, nil, {
    desc = "Time spent pumping oil.",
    category = "Economy",
    type = "Float",
    min = 0,
    max = 60
})
