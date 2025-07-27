local MODULE = MODULE
MODULE.name = "Grid Inventory"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Implements a modular grid-based inventory with item stacking, weight limits, and support for hot-loading additional modules."
MODULE.Dependencies = {
    {
        File = "gridinv.lua",
        Realm = "shared"
    },
}

lia.vendor.addPreset("utility_vendor", {
    manhack_welder = {
        mode = VendorSellAndBuy
    },
    item_suit = {
        mode = VendorSellAndBuy
    },
    universalammo3 = {
        mode = VendorSellAndBuy
    },
})
