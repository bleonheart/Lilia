lia.config.add("vendorDefaultMoney", "Default Vendor Money", 500, nil, {
    desc = "Sets the default amount of money a vendor starts with",
    category = "Vendors",
    type = "Int",
    min = 0,
    max = 100000
})

lia.vendor.addPreset("utility_vendor", {
    manhack_welder = {
        mode = VENDOR_SELLANDBUY
    },
    item_suit = {
        mode = VENDOR_SELLANDBUY
    },
    universalammo3 = {
        mode = VENDOR_SELLANDBUY
    },
})