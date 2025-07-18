﻿lia.config.add("invW", "Inventory Width", 6, function(_, newW)
    if not SERVER then return end
    for _, client in player.Iterator() do
        if not IsValid(client) then continue end
        local inv = client:getChar():getInv()
        local dw, dh = hook.Run("GetDefaultInventorySize", client)
        dw = dw or newW
        dh = dh or lia.config.get("invH")
        local w, h = inv:getSize()
        if w ~= dw or h ~= dh then
            inv:setSize(dw, dh)
            inv:sync(client)
        end
    end
end, {
    desc = "Defines the width of the default inventory.",
    category = "Character",
    type = "Int",
    min = 1,
    max = 10
})

lia.config.add("invH", "Inventory Height", 4, function(_, newH)
    if not SERVER then return end
    for _, client in player.Iterator() do
        if not IsValid(client) then continue end
        local inv = client:getChar():getInv()
        local dw, dh = hook.Run("GetDefaultInventorySize", client)
        dw = dw or lia.config.get("invW")
        dh = dh or newH
        local w, h = inv:getSize()
        if w ~= dw or h ~= dh then
            inv:setSize(dw, dh)
            inv:sync(client)
        end
    end
end, {
    desc = "Defines the height of the default inventory.",
    category = "Character",
    type = "Int",
    min = 1,
    max = 10
})
