if CLIENT then
net.Receive("liaWeaponOverrideSync", function()
    local isBulkSync = net.ReadBool()
    if isBulkSync then
        local overrides = net.ReadTable()
        if istable(overrides) then
            lia.item.WeaponOverrides = overrides
            for className, data in pairs(overrides) do
                local itemDef = lia.item.list[className]
                if itemDef and istable(data) then
                    for k, v in pairs(data) do
                        itemDef[k] = v
                    end
                end
            end

            hook.Run("OnWeaponOverridesBulkSynced", overrides)
        end
    else
        local className = net.ReadString()
        local key = net.ReadString()
        local value = net.ReadType()
        lia.item.WeaponOverrides[className] = lia.item.WeaponOverrides[className] or {}
        lia.item.WeaponOverrides[className][key] = value
        local itemDef = lia.item.list[className]
        if itemDef then itemDef[key] = value end
        hook.Run("OnWeaponOverrideUpdated", className, key, value)
    end
end)

net.Receive("liaWeaponRuntimeOverrideSync", function()
    local isBulkSync = net.ReadBool()
    if isBulkSync then
        local overrides = net.ReadTable()
        if istable(overrides) then
            lia.item.WeaponRuntimeOverrides = overrides
            for className, paths in pairs(overrides) do
                local wep = weapons.GetStored(className)
                if wep then
                    for dotPath, value in pairs(paths) do
                        lia.item.applyRuntimeOverridePath(wep, dotPath, value)
                    end
                end
            end

            hook.Run("OnWeaponRuntimeOverridesBulkSynced", overrides)
        end
    else
        local className = net.ReadString()
        local dotPath = net.ReadString()
        local value = net.ReadType()
        if dotPath == "" then
            lia.item.WeaponRuntimeOverrides[className] = nil
            local defaults = lia.item.defaultRuntimeValues and lia.item.defaultRuntimeValues[className] or {}
            local wep = weapons.GetStored(className)
            if wep then
                for path, orig in pairs(defaults) do
                    lia.item.applyRuntimeOverridePath(wep, path, orig)
                end
            end
        else
            lia.item.WeaponRuntimeOverrides[className] = lia.item.WeaponRuntimeOverrides[className] or {}
            lia.item.WeaponRuntimeOverrides[className][dotPath] = value
            local wep = weapons.GetStored(className)
            if wep then lia.item.applyRuntimeOverridePath(wep, dotPath, value) end
            hook.Run("OnWeaponRuntimeOverrideUpdated", className, dotPath, value)
        end
    end
end)
end

if SERVER then
local function getWeaponItemDefaults(className)
    local wep = weapons.Get(className)
    if not wep then return nil end
    local holdType = wep.HoldType or "normal"
    local isGrenade = holdType == "grenade"
    local size = lia.item.holdTypeSizeMapping[holdType] or {
        width = 2,
        height = 1
    }
    return {
        name = hook.Run("GetWeaponName", wep) or className,
        desc = "A Weapon.",
        category = isGrenade and "Grenades" or "Weapons",
        model = wep.WorldModel or wep.WM or "models/props_c17/suitcase_passenger_physics.mdl",
        class = className,
        width = size.width,
        height = size.height,
        price = 500
    }
end

net.Receive("liaWeaponOverrideUpdate", function(len, ply)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaWeaponOverrideUpdate", "hasPrivilege(ManageWeaponOverrides)=", tostring(ply:hasPrivilege("ManageWeaponOverrides")), "finalResult=", tostring(ply:hasPrivilege("ManageWeaponOverrides")))
    if not ply:hasPrivilege("ManageWeaponOverrides") then return end
    local className = net.ReadString()
    local key = net.ReadString()
    local value = net.ReadType()
    lia.item.WeaponOverrides[className] = lia.item.WeaponOverrides[className] or {}
    lia.item.WeaponOverrides[className][key] = value
    for classID, data in pairs(lia.item.WeaponOverrides) do
        if not istable(data) then
            lia.item.WeaponOverrides[classID] = nil
            continue
        end

        local defaults = getWeaponItemDefaults(classID)
        if defaults then
            for k, v in pairs(data) do
                if defaults[k] ~= nil and v == defaults[k] then data[k] = nil end
            end
        end

        if table.IsEmpty(data) then lia.item.WeaponOverrides[classID] = nil end
    end

    lia.data.set("weaponOverrides", lia.item.WeaponOverrides, true, true)
    local itemDef = lia.item.list[className]
    if itemDef then itemDef[key] = value end
    ply:notify(string.format("Successfully updated %s for %s", key, className))
    net.Start("liaWeaponOverrideSync")
    net.WriteBool(false)
    net.WriteString(className)
    net.WriteString(key)
    net.WriteType(value)
    net.Broadcast()
    hook.Run("OnWeaponOverrideUpdated", className, key, value)
end)

local function sanitizeRuntimePath(path)
    if not isstring(path) or path == "" then return nil end
    if not path:match("^[%a_][%w_]*%.[%a_][%w_]*$") then return nil end
    return path
end

local function coerceRuntimeValue(raw)
    local n = tonumber(raw)
    if n ~= nil then return n end
    if raw == "true" then return true end
    if raw == "false" then return false end
    return raw
end

local function refreshWeaponHolders(className)
    for _, ply in player.Iterator() do
        if ply:HasWeapon(className) then
            ply:StripWeapon(className)
            ply:Give(className)
            ply:SelectWeapon(className)
        end
    end
end

net.Receive("liaWeaponRuntimeOverrideUpdate", function(_, ply)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaWeaponRuntimeOverrideUpdate", "hasPrivilege(ManageWeaponOverrides)=", tostring(ply:hasPrivilege("ManageWeaponOverrides")), "finalResult=", tostring(ply:hasPrivilege("ManageWeaponOverrides")))
    if not ply:hasPrivilege("ManageWeaponOverrides") then return end
    local className = net.ReadString()
    local dotPath = sanitizeRuntimePath(net.ReadString())
    local rawValue = net.ReadString()
    if not dotPath then return end
    local value = coerceRuntimeValue(rawValue)
    local wep = weapons.GetStored(className)
    if not wep then return end
    if not lia.item.applyRuntimeOverridePath(wep, dotPath, value) then return end
    lia.item.WeaponRuntimeOverrides[className] = lia.item.WeaponRuntimeOverrides[className] or {}
    lia.item.WeaponRuntimeOverrides[className][dotPath] = value
    lia.data.set("weaponRuntimeOverrides", lia.item.WeaponRuntimeOverrides, true, true)
    refreshWeaponHolders(className)
    ply:notify(string.format("Successfully updated %s for %s", dotPath, className))
    net.Start("liaWeaponRuntimeOverrideSync")
    net.WriteBool(false)
    net.WriteString(className)
    net.WriteString(dotPath)
    net.WriteType(value)
    net.Broadcast()
    hook.Run("OnWeaponRuntimeOverrideUpdated", className, dotPath, value)
end)

net.Receive("liaWeaponRuntimeOverrideReset", function(_, ply)
    lia.debug("[Permissions]", "Permission Check for net.Receive liaWeaponRuntimeOverrideReset", "hasPrivilege(ManageWeaponOverrides)=", tostring(ply:hasPrivilege("ManageWeaponOverrides")), "finalResult=", tostring(ply:hasPrivilege("ManageWeaponOverrides")))
    if not ply:hasPrivilege("ManageWeaponOverrides") then return end
    local className = net.ReadString()
    local wep = weapons.GetStored(className)
    if not wep then return end
    local defaults = lia.item.defaultRuntimeValues and lia.item.defaultRuntimeValues[className] or {}
    for dotPath, originalValue in pairs(defaults) do
        lia.item.applyRuntimeOverridePath(wep, dotPath, originalValue)
    end

    lia.item.WeaponRuntimeOverrides[className] = nil
    lia.data.set("weaponRuntimeOverrides", lia.item.WeaponRuntimeOverrides, true, true)
    refreshWeaponHolders(className)
    ply:notify(string.format("Successfully updated %s for %s", "reset", className))
    net.Start("liaWeaponRuntimeOverrideSync")
    net.WriteBool(false)
    net.WriteString(className)
    net.WriteString("")
    net.WriteType(false)
    net.Broadcast()
end)
end

