lia.config.add("salaryInterval", 300, "How often a player gets paid in seconds.", nil, {
    data = {
        min = 1,
        max = 3600
    },
    category = "Player Settings"
})

lia.config.add("SalaryOverride", false, "Whether Salary is Overriden or not.", nil, {
    category = "Player Settings"
})