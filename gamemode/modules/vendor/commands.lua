-- Vendor command registrations.
lia.command.add("restockvendor", {
    superAdminOnly = true,
    desc = "Restocks all items for the vendor you are looking at to their default quantities.",
    onRun = function(client)
        local target = client:getTracedEntity()
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target:GetClass() == "lia_vendor" then
            for id, itemData in pairs(target.items) do
                if itemData[2] and itemData[4] then target.items[id][2] = itemData[4] end
            end

            client:notifySuccess("The vendor has been restocked.")
            lia.log.add(client, "restockvendor", target)
        else
            client:notifyError("You are not looking at a valid vendor.")
        end
    end
})

lia.command.add("restockallvendors", {
    superAdminOnly = true,
    desc = "Restocks all items on every vendor on the map to their default quantities.",
    onRun = function(client)
        local count = 0
        for _, vendor in ipairs(ents.FindByClass("lia_vendor")) do
            for id, itemData in pairs(vendor.items) do
                if itemData[2] and itemData[4] then vendor.items[id][2] = itemData[4] end
            end

            count = count + 1
            lia.log.add(client, "restockvendor", vendor)
        end

        client:notifySuccess(string.format("All vendors have been restocked. Total vendors restocked: %s.", count))
        lia.log.add(client, "restockallvendors", count)
    end
})

lia.command.add("deletevendorpreset", {
    adminOnly = true,
    desc = "Delete a saved vendor preset by name.",
    arguments = {
        {
            name = "presetName",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        lia.debug("[Permissions]", "Permission Check for command savevendorpreset", "hasPrivilege(canCreateVendorPresets)=", tostring(client:hasPrivilege("canCreateVendorPresets")), "finalResult=", tostring(client:hasPrivilege("canCreateVendorPresets")))
        if not client:hasPrivilege("canCreateVendorPresets") then
            client:notifyError("No Permission")
            return
        end

        local presetName = arguments[1]
        if not presetName or presetName:Trim() == "" then
            client:notifyError("Preset name is required")
            return
        end

        presetName = presetName:Trim():lower()
        if not lia.vendor.presets[presetName] then
            client:notifyError(string.format("Vendor preset '%s' not found.", presetName))
            return
        end

        lia.vendor.presets[presetName] = nil
        if SERVER then
            lia.db.delete("vendor_presets", "name = " .. lia.db.convertDataType(presetName))
            net.Start("liaVendorSyncPresets")
            net.WriteTable(lia.vendor.presets)
            net.Broadcast()
        end

        client:notifySuccess(string.format("Vendor preset '%s' has been deleted.", presetName))
        lia.log.add(client, "deletevendorpreset", presetName)
    end
})

lia.command.add("listvendorpresets", {
    adminOnly = true,
    desc = "List all saved vendor preset names.",
    onRun = function(client)
        lia.debug("[Permissions]", "Permission Check for command listvendorpresets", "hasPrivilege(canCreateVendorPresets)=", tostring(client:hasPrivilege("canCreateVendorPresets")), "finalResult=", tostring(client:hasPrivilege("canCreateVendorPresets")))
        if not client:hasPrivilege("canCreateVendorPresets") then
            client:notifyError("No Permission")
            return
        end

        local presets = {}
        for name in pairs(lia.vendor.presets or {}) do
            presets[#presets + 1] = name
        end

        if #presets == 0 then
            client:notifyInfo("No vendor presets found.")
        else
            table.sort(presets)
            client:notifyInfo(string.format("Available presets: %s", table.concat(presets, ", ")))
        end
    end
})

-- Vendor command registrations.
lia.command.add("resetvendorcooldowns", {
    desc = "Reset vendor cooldowns for a player",
    privilege = "Can Edit Vendors",
    adminOnly = true,
    arguments = {
        {
            name = "target",
            type = "player",
            description = "The player to reset cooldowns for"
        }
    },
    AdminStick = {
        Name = "Reset Vendor Cooldowns",
        ButtonText = "Reset Vendor Cooldowns",
        Category = "Vendors",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not IsValid(target) then
            client:notifyError("Invalid Target!")
            return
        end

        local character = target:getChar()
        if not character then
            client:notifyError("Invalid Target!")
            return
        end

        character:setData("vendorCooldowns", {})
        client:notify(string.format("Vendor cooldowns have been reset for %s.", target:Name()))
        target:notify("Your vendor cooldowns have been reset by an administrator.")
    end
})
