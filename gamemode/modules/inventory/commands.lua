﻿lia.command.add("updateinvsize", {
    adminOnly = true,
    privilege = "Set Inventory Size",
    desc = "updateInventorySizeDesc",
    syntax = "[player Player Name]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyLocalized("noCharacterLoaded")
            return
        end

        local inv = char:getInv()
        if not inv then
            client:notifyLocalized("noInventory")
            return
        end

        local dw, dh = hook.Run("GetDefaultInventorySize", target)
        dw = dw or lia.config.get("invW")
        dh = dh or lia.config.get("invH")
        local w, h = inv:getSize()
        if w == dw and h == dh then
            client:notifyLocalized("inventoryAlreadySize", target:Name(), dw, dh)
            return
        end

        inv:setSize(dw, dh)
        inv:sync(target)
        client:notifyLocalized("updatedInventorySize", target:Name(), dw, dh)
        lia.log.add(client, "invUpdateSize", target:Name(), dw, dh)
    end
})

lia.command.add("setinventorysize", {
    adminOnly = true,
    privilege = "Set Inventory Size",
    desc = "setInventorySizeDesc",
    syntax = "[player Player Name] [number Width] [number Height]",
    onRun = function(client, args)
        local target = lia.util.findPlayer(client, args[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local w, h = tonumber(args[2]), tonumber(args[3])
        if not w or not h then
            client:notifyLocalized("invalidWidthHeight")
            return
        end

        local minW, maxW, minH, maxH = 1, 10, 1, 10
        if w < minW or w > maxW or h < minH or h > maxH then
            client:notifyLocalized("widthHeightOutOfRange", minW, maxW, minH, maxH)
            return
        end

        local char = target:getChar()
        local inv = char and char:getInv()
        if inv then
            inv:setSize(w, h)
            inv:sync(target)
        end

        lia.log.add(client, "invSetSize", target:Name(), w, h)
        client:notifyLocalized("setInventorySizeNotify", target:Name(), w, h)
    end
})
