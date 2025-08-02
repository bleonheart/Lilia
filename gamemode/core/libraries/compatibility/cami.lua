hook.Add("CAMI.OnPrivilegeRegistered", "liaAdminOnPrivilegeRegistered", function(priv)
    if not priv or not priv.Name then return end
    local name = tostring(priv.Name)
    if name == "" then return end
    if lia.administrator.privileges[name] ~= nil then return end
    local min = tostring(priv.MinAccess or "user"):lower()
    lia.administrator.privileges[name] = min
    for groupName, perms in pairs(lia.administrator.groups or {}) do
        perms = perms or {}
        lia.administrator.groups[groupName] = perms
        if shouldGrant(groupName, min) then perms[name] = true end
    end

    if SERVER then
        lia.administrator.save()
        lia.administrator.sync()
    end
end)

hook.Add("CAMI.OnPrivilegeUnregistered", "liaAdminOnPrivilegeUnregistered", function(priv)
    if not priv or not priv.Name then return end
    local name = tostring(priv.Name)
    lia.administrator.privileges[name] = nil
    for g, perms in pairs(lia.administrator.groups or {}) do
        perms[name] = nil
    end

    if SERVER then
        lia.administrator.save()
        lia.administrator.sync()
    end
end)

hook.Add("CAMI.OnUsergroupRegistered", "liaAdminOnUsergroupRegistered", function(ug)
    if not ug or not ug.Name then return end
    local n = tostring(ug.Name)
    if n == "" or lia.administrator.DefaultGroups[n] then return end
    if lia.administrator.groups[n] then return end
    lia.administrator.groups[n] = {
        _info = {
            inheritance = tostring(ug.Inherits or "user"),
            types = {}
        }
    }

    lia.administrator.applyInheritance(n)
    if SERVER then
        lia.administrator.save()
        lia.administrator.sync()
    end
end)

hook.Add("CAMI.OnUsergroupUnregistered", "liaAdminOnUsergroupUnregistered", function(ug)
    if not ug or not ug.Name then return end
    local n = tostring(ug.Name)
    if lia.administrator.DefaultGroups[n] then return end
    if not lia.administrator.groups[n] then return end
    lia.administrator.groups[n] = nil
    if SERVER then
        lia.administrator.save()
        lia.administrator.sync()
    end
end)

hook.Add("CAMI.PlayerHasAccess", "liaAdminPlayerHasAccess", function(actor, privilege, callback, target, extra)
    local ok = lia.administrator.hasAccess(actor, privilege, target)
    callback(ok and true or false, "")
    return true
end)