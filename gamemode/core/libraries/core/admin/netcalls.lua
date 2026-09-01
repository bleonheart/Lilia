if CLIENT then
net.Receive("liaGroupPermChanged", function()
    local group = net.ReadString()
    local privilege = net.ReadString()
    local value = net.ReadBool()
    lia.admin.groups = lia.admin.groups or {}
    lia.admin.groups[group] = lia.admin.groups[group] or {}
    if value then
        lia.admin.groups[group][privilege] = true
    else
        lia.admin.groups[group][privilege] = nil
    end

    local effectiveValue = lia.admin.hasAccess(group, privilege)
    lia.debug("[Permissions UI]", "Received live permission change", "group=", tostring(group), "privilege=", tostring(privilege), "explicitValue=", tostring(value), "effectiveValue=", tostring(effectiveValue), "localPlayerUserGroup=", tostring(IsValid(LocalPlayer()) and LocalPlayer():GetUserGroup() or "unknown"))
    if IsValid(lia.gui.usergroups) then
        local checks = lia.gui.usergroups.checks
        local row = checks and checks[group] and checks[group][privilege] or nil
        if IsValid(row) then row:InvalidateLayout(true) end
    end
end)
end

if SERVER then
local function broadcastGroups()
    lia.net.ready = lia.net.ready or setmetatable({}, {
        __mode = "k"
    })

    local players = player.GetHumans()
    for _, ply in ipairs(players) do
        if lia.net.ready[ply] then lia.net.writeBigTable(ply, "liaUpdateAdminGroups", lia.admin.groups or {}) end
    end
end

net.Receive("liaGroupsRequest", function(_, p)
    if not IsValid(p) or not p:hasPrivilege("manageUsergroups") then return end
    lia.net.ready = lia.net.ready or setmetatable({}, {
        __mode = "k"
    })

    lia.net.ready[p] = true
    lia.admin.sync(p)
end)

net.Receive("liaGroupsAdd", function(_, p)
    if not p:hasPrivilege("manageUsergroups") then return end
    local data = net.ReadTable()
    local n = string.Trim(tostring(data.name or ""))
    local icon = string.Trim(tostring(data.icon or ""))
    if n == "" then return end
    lia.admin.groups = lia.admin.groups or {}
    if lia.admin.DefaultGroups and lia.admin.DefaultGroups[n] then
        p:notifyError("Base usergroups cannot be edited")
        return
    end

    if lia.admin.groups[n] then return end
    lia.admin.createGroup(n, {
        _info = {
            inheritance = data.inherit or "user",
            types = data.types or {}
        },
        icon = icon ~= "" and icon or nil
    })

    lia.admin.save()
    broadcastGroups()
    p:notifySuccess(string.format("Group '%s' created.", n))
end)

net.Receive("liaGroupsRemove", function(_, p)
    if not p:hasPrivilege("manageUsergroups") then return end
    local n = net.ReadString()
    if n == "" then return end
    if lia.admin.DefaultGroups and lia.admin.DefaultGroups[n] then
        p:notifyError("[Lilia Administration] The base usergroups cannot be removed!")
        return
    end

    lia.admin.removeGroup(n)
    if lia.admin.groups then lia.admin.groups[n] = nil end
    lia.admin.save()
    broadcastGroups()
    p:notifySuccess(string.format("Group '%s' removed.", n))
end)

net.Receive("liaGroupsRename", function(_, p)
    if not p:hasPrivilege("manageUsergroups") then return end
    local old = string.Trim(net.ReadString() or "")
    local new = string.Trim(net.ReadString() or "")
    if old == "" or new == "" then return end
    if old == new then return end
    if not lia.admin.groups or not lia.admin.groups[old] then return end
    if lia.admin.groups[new] or lia.admin.DefaultGroups and lia.admin.DefaultGroups[new] then
        p:notifyError("[Lilia Administration] The base usergroups cannot be renamed!")
        return
    end

    if lia.admin.DefaultGroups and lia.admin.DefaultGroups[old] then
        p:notifyError("[Lilia Administration] The base usergroups cannot be renamed!")
        return
    end

    lia.admin.renameGroup(old, new)
    broadcastGroups()
    p:notifySuccess(string.format("Group '%s' renamed to '%s'.", old, new))
end)

local function getGroupLevelForPermissionSummary(groupName, visited)
    visited = visited or {}
    if visited[groupName] then return 1 end
    visited[groupName] = true
    local defaultGroups = lia.admin.DefaultGroups or {}
    if defaultGroups[groupName] then return defaultGroups[groupName] end
    local groupData = lia.admin.groups and lia.admin.groups[groupName]
    if not groupData then return 1 end
    local inheritance = groupData._info and groupData._info.inheritance or "user"
    if inheritance == groupName then return 1 end
    return getGroupLevelForPermissionSummary(inheritance, visited)
end

local function getDefaultPermissionValueForSummary(groupName, privilege, visited)
    visited = visited or {}
    local visitKey = tostring(groupName) .. ":" .. tostring(privilege)
    if visited[visitKey] then return false end
    visited[visitKey] = true
    local privilegeMinAccess = lia.admin.privileges and lia.admin.privileges[privilege]
    local defaultGroups = lia.admin.DefaultGroups or {}
    if privilegeMinAccess and getGroupLevelForPermissionSummary(groupName) >= (defaultGroups[tostring(privilegeMinAccess):lower()] or 1) then return true end
    local groupData = lia.admin.groups and lia.admin.groups[groupName]
    if not groupData then return false end
    local inheritance = groupData._info and groupData._info.inheritance or "user"
    if inheritance and inheritance ~= "" and inheritance ~= groupName then
        local inheritedGroup = lia.admin.groups and lia.admin.groups[inheritance]
        if inheritedGroup and inheritedGroup[privilege] == true then return true end
        return getDefaultPermissionValueForSummary(inheritance, privilege, visited)
    end
    return false
end

local function getGroupPermissionOverrides(groupName)
    local groupData = lia.admin.groups and lia.admin.groups[groupName]
    if not groupData then return {} end
    local overrides = {}
    for permission in pairs(lia.admin.privileges or {}) do
        if permission ~= "_info" and groupData[permission] ~= nil then
            local currentValue = groupData[permission] == true
            local defaultValue = getDefaultPermissionValueForSummary(groupName, permission)
            if currentValue ~= defaultValue then overrides[#overrides + 1] = (currentValue and "+" or "-") .. permission end
        end
    end

    table.sort(overrides)
    return overrides
end

net.Receive("liaGroupsSetPerm", function(_, p)
    if not p:hasPrivilege("manageUsergroups") then return end
    local group = net.ReadString()
    local privilege = net.ReadString()
    local value = net.ReadBool()
    if group == "" or privilege == "" then return end
    if lia.admin.DefaultGroups and lia.admin.DefaultGroups[group] then
        p:notifyError("Base usergroups cannot be edited")
        return
    end

    if not lia.admin.groups or not lia.admin.groups[group] then return end
    lia.debug("[Permissions UI]", "Received permission edit request", "editor=", tostring(IsValid(p) and p:Nick() .. " (" .. p:SteamID() .. ")" or "unknown"), "group=", tostring(group), "privilege=", tostring(privilege), "requestedValue=", tostring(value), "previousExplicitValue=", tostring(lia.admin.groups[group][privilege]), "previousEffectiveValue=", tostring(lia.admin.hasAccess(group, privilege)))
    if SERVER then
        if value then
            lia.admin.addPermission(group, privilege, true)
        else
            lia.admin.removePermission(group, privilege, true)
        end
    end

    lia.debug("[Permissions UI]", "Applied permission edit request", "group=", tostring(group), "privilege=", tostring(privilege), "newExplicitValue=", tostring(lia.admin.groups[group] and lia.admin.groups[group][privilege]), "newEffectiveValue=", tostring(lia.admin.hasAccess(group, privilege)))
    local overrides = getGroupPermissionOverrides(group)
    local lines = {"Usergroup " .. string.upper(tostring(group))}
    local changedPrefix = value and "[+] " or "[-] "
    local changedPermissionName = lia.admin.privilegeNames and lia.admin.privilegeNames[privilege] or privilege
    lines[#lines + 1] = changedPrefix .. tostring(changedPermissionName) .. " - " .. privilege
    for _, override in ipairs(overrides) do
        local permissionID = override:sub(2)
        if permissionID ~= privilege then
            local prefix = override:sub(1, 1) == "+" and "[+] " or "[-] "
            local permissionName = lia.admin.privilegeNames and lia.admin.privilegeNames[permissionID] or permissionID
            lines[#lines + 1] = prefix .. tostring(permissionName) .. " - " .. permissionID
        end
    end

    lia.information(table.concat(lines, "\n"))
    net.Start("liaGroupPermChanged")
    net.WriteString(group)
    net.WriteString(privilege)
    net.WriteBool(value)
    net.Broadcast()
    p:notifySuccess("Group permissions updated.")
end)
end

