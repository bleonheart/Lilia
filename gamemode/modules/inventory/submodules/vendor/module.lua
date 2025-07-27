MODULE.name = "Vendors"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides NPC vendors who can buy and sell items with stock management and dialogue-driven transactions."
MODULE.Privileges = {
    {
        Name = "Can Edit Vendors",
        MinAccess = "admin",
        Category = MODULE.name
    },
}

lia.config.add("vendorDefaultMoney", "Default Vendor Money", 500, nil, {
    desc = "Sets the default amount of money a vendor starts with",
    category = "Vendors",
    type = "Int",
    min = 0,
    max = 100000
})

VendorWelcome = 1
VendorLeave = 2
VendorNoTrade = 3
VendorPrice = 1
VendorStock = 2
VendorMode = 3
VendorMaxStock = 4
VendorSellAndBuy = 1
VendorSellOnly = 2
VendorBuyOnly = 3
VendorText = {
    [VendorSellAndBuy] = "buyOnlynSell",
    [VendorBuyOnly] = "buyOnly",
    [VendorSellOnly] = "sellOnly",
}
