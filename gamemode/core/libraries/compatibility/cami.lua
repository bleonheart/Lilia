local function registerGroupsWithCAMI()
    for name, data in pairs(lia.administrator.groups or {}) do
        if not lia.administrator.DefaultGroups[name] then
            local inh = data._info and data._info.inheritance or "user"
            CAMI.RegisterUsergroup({
                Name = name,
                Inherits = inh
            }, lia.administrator._camiSource)
        end
    end
end

local function registerPrivilegesWithCAMI()
    for name, min in pairs(lia.administrator.privileges or {}) do
        CAMI.RegisterPrivilege({
            Name = name,
            MinAccess = min
        })
    end
end

local function liaAdminBootstrapFromCAMI()
    if CAMI and CAMI.GetUsergroups then
        for _, ug in pairs(CAMI.GetUsergroups() or {}) do
            if not lia.administrator.DefaultGroups[ug.Name] and not lia.administrator.groups[ug.Name] then
                lia.administrator.groups[ug.Name] = {
                    _info = {
                        inheritance = tostring(ug.Inherits or "user"),
                        types = {}
                    }
                }

                lia.administrator.applyInheritance(ug.Name)
            end
        end
    end

    if CAMI and CAMI.GetPrivileges then
        for _, pr in pairs(CAMI.GetPrivileges() or {}) do
            if lia.administrator.privileges[pr.Name] == nil then
                local min = tostring(pr.MinAccess or "user"):lower()
                lia.administrator.privileges[pr.Name] = min
                for groupName in pairs(lia.administrator.groups or {}) do
                    if lia.administrator.shouldGrant and lia.administrator.shouldGrant(groupName, min) then
                        lia.administrator.groups[groupName][pr.Name] = true
                    end
                end
            end
        end
    end

    if SERVER then
        lia.administrator.save(true)
        lia.administrator.sync()
    end
end

hook.Add("CAMI.PlayerHasAccess", "liaAdminCAMIPlayerHasAccess", function(ply, privilege, callback, target, extra)
    local ok = lia.administrator.hasAccess(ply, privilege) and true or false
    callback(ok, ok and "" or "denied")
    return true
end)

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
        if lia.administrator.shouldGrant and lia.administrator.shouldGrant(groupName, min) then
            perms[name] = true
        end
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
    for _, perms in pairs(lia.administrator.groups or {}) do
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

hook.Add("OnUsergroupCreated", "liaAdminCAMIRegisterGroup", function(name, data)
    if lia.administrator.DefaultGroups[name] then return end
    local inh = data and data._info and data._info.inheritance or "user"
    CAMI.RegisterUsergroup({
        Name = name,
        Inherits = inh
    }, lia.administrator._camiSource)
end)

hook.Add("OnUsergroupRemoved", "liaAdminCAMIUnregisterGroup", function(name) CAMI.UnregisterUsergroup(name, lia.administrator._camiSource) end)
hook.Add("OnUsergroupRenamed", "liaAdminCAMIRenameGroup", function(oldName, newName)
    CAMI.UnregisterUsergroup(oldName, lia.administrator._camiSource)
    local inh = lia.administrator.groups[newName] and lia.administrator.groups[newName]._info and lia.administrator.groups[newName]._info.inheritance or "user"
    CAMI.RegisterUsergroup({
        Name = newName,
        Inherits = inh
    }, lia.administrator._camiSource)
end)

hook.Add("OnPrivilegeRegistered", "liaAdminCAMIRegisterPrivilege", function(priv)
    CAMI.RegisterPrivilege({
        Name = priv.Name,
        MinAccess = priv.MinAccess
    })
end)

hook.Add("OnAdminSystemLoaded", "liaAdminCAMILoad", function()
    registerGroupsWithCAMI()
    registerPrivilegesWithCAMI()
    liaAdminBootstrapFromCAMI()
end)