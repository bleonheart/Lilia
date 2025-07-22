-- Global vendor utilities
lia.vendor = lia.vendor or {}
lia.vendor.editor = lia.vendor.editor or {}
lia.vendor.presets = lia.vendor.presets or {}

function lia.vendor.addPreset(name, items)
    assert(isstring(name), "preset name must be a string")
    assert(istable(items), "preset items must be a table")
    lia.vendor.presets[string.lower(name)] = items
end

function lia.vendor.getPreset(name)
    return lia.vendor.presets[string.lower(name)]
end

-- compatibility wrapper
function AddVendorPreset(name, items)
    lia.vendor.addPreset(name, items)
end
