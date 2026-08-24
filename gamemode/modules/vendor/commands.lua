
-- Vendor command registrations.
lia.command.add("restockvendor", {
    superAdminOnly = true,
    desc = "@restockVendorDesc",
    onRun = function(client)
        local target = client:getTracedEntity()
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if target:GetClass() == "lia_vendor" then
            for id, itemData in pairs(target.items) do
                if itemData[2] and itemData[4] then target.items[id][2] = itemData[4] end
            end

            client:notifySuccessLocalized("vendorRestocked")
            lia.log.add(client, "restockvendor", target)
        else
            client:notifyErrorLocalized("notLookingAtValidVendor")
        end
    end
})

lia.command.add("restockallvendors", {
    superAdminOnly = true,
    desc = "@restockAllVendorsDesc",
    onRun = function(client)
        local count = 0
        for _, vendor in ipairs(ents.FindByClass("lia_vendor")) do
            for id, itemData in pairs(vendor.items) do
                if itemData[2] and itemData[4] then vendor.items[id][2] = itemData[4] end
            end

            count = count + 1
            lia.log.add(client, "restockvendor", vendor)
        end

        client:notifySuccessLocalized("vendorAllVendorsRestocked", count)
        lia.log.add(client, "restockallvendors", count)
    end
})

lia.command.add("deletevendorpreset", {
    adminOnly = true,
    desc = "@deleteVendorPresetDesc",
    arguments = {
        {
            name = "presetName",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        lia.debug("[Permissions]", "Permission Check for command savevendorpreset", "hasPrivilege(canCreateVendorPresets)=", tostring(client:hasPrivilege("canCreateVendorPresets")), "finalResult=", tostring(client:hasPrivilege("canCreateVendorPresets")))
        if not client:hasPrivilege("canCreateVendorPresets") then
            client:notifyErrorLocalized("noPermission")
            return
        end

        local presetName = arguments[1]
        if not presetName or presetName:Trim() == "" then
            client:notifyErrorLocalized("vendorPresetNameRequired")
            return
        end

        presetName = presetName:Trim():lower()
        if not lia.vendor.presets[presetName] then
            client:notifyErrorLocalized("vendorPresetNotFound", presetName)
            return
        end

        lia.vendor.presets[presetName] = nil
        if SERVER then
            lia.db.delete("vendor_presets", "name = " .. lia.db.convertDataType(presetName))
            net.Start("liaVendorSyncPresets")
            net.WriteTable(lia.vendor.presets)
            net.Broadcast()
        end

        client:notifySuccessLocalized("vendorPresetDeleted", presetName)
        lia.log.add(client, "deletevendorpreset", presetName)
    end
})

lia.command.add("listvendorpresets", {
    adminOnly = true,
    desc = "@listVendorPresetsDesc",
    onRun = function(client)
        lia.debug("[Permissions]", "Permission Check for command listvendorpresets", "hasPrivilege(canCreateVendorPresets)=", tostring(client:hasPrivilege("canCreateVendorPresets")), "finalResult=", tostring(client:hasPrivilege("canCreateVendorPresets")))
        if not client:hasPrivilege("canCreateVendorPresets") then
            client:notifyErrorLocalized("noPermission")
            return
        end

        local presets = {}
        for name in pairs(lia.vendor.presets or {}) do
            presets[#presets + 1] = name
        end

        if #presets == 0 then
            client:notifyInfoLocalized("vendorNoPresets")
        else
            table.sort(presets)
            client:notifyInfoLocalized("vendorPresetList", table.concat(presets, ", "))
        end
    end
})

-- Vendor command registrations.
lia.command.add("resetvendorcooldowns", {
    desc = "@resetvendorcooldownsDesc",
    privilege = "@canEditVendors",
    adminOnly = true,
    arguments = {
        {
            name = "target",
            type = "player",
            description = "@resetVendorCooldownsTargetDesc"
        }
    },
    AdminStick = {
        Name = "@adminStickResetVendorCooldownsName",
        ButtonText = "Reset Vendor Cooldowns",
        Category = "Vendors",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not IsValid(target) then
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        local character = target:getChar()
        if not character then
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        character:setData("vendorCooldowns", {})
        client:notifyLocalized("vendorCooldownsReset", target:Name())
        target:notifyLocalized("vendorCooldownsResetByAdmin")
    end
})

