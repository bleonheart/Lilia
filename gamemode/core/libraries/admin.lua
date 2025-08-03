lia.administrator = lia.administrator or {}
lia.administrator.groups = lia.administrator.groups or {}
lia.administrator.privileges = lia.administrator.privileges or {}
lia.administrator.privMeta = lia.administrator.privMeta or {}
lia.administrator.DefaultGroups = {
    user = 1,
    admin = 2,
    superadmin = 3
}

local function getGroupLevel(group)
    local levels = lia.administrator.DefaultGroups or {}
    if levels[group] then return levels[group] end
    local visited, current = {}, group
    for _ = 1, 16 do
        if visited[current] then break end
        visited[current] = true
        local g = lia.administrator.groups and lia.administrator.groups[current]
        local inh = g and g._info and g._info.inheritance or "user"
        if levels[inh] then return levels[inh] end
        current = inh
    end
    return levels.user or 1
end

local function shouldGrant(group, min)
    local levels = lia.administrator.DefaultGroups or {}
    local m = tostring(min or "user"):lower()
    return getGroupLevel(group) >= (levels[m] or 1)
end

local function rebuildPrivileges()
    lia.administrator.privileges = lia.administrator.privileges or {}
    for groupName, perms in pairs(lia.administrator.groups or {}) do
        for priv, allowed in pairs(perms) do
            if priv ~= "_info" and allowed == true then
                local current = lia.administrator.privileges[priv]
                local groupLevel = getGroupLevel(groupName)
                local currentLevel = current and getGroupLevel(current) or math.huge
                if not current or groupLevel < currentLevel then
                    local base
                    for name, lvl in pairs(lia.administrator.DefaultGroups or {}) do
                        if lvl == groupLevel then
                            base = name
                            break
                        end
                    end

                    lia.administrator.privileges[priv] = base or "user"
                end
            end
        end
    end
end

local function camiRegisterUsergroup(name, inherits)
    if CAMI and name ~= "user" and name ~= "admin" and name ~= "superadmin" then
        CAMI.RegisterUsergroup({
            Name = name,
            Inherits = inherits or "user"
        }, "Lilia")
    end
end

local function camiUnregisterUsergroup(name)
    if CAMI and name ~= "user" and name ~= "admin" and name ~= "superadmin" then CAMI.UnregisterUsergroup(name, "Lilia") end
end

local function camiRegisterPrivilege(name, min)
    if CAMI then
        if not CAMI.GetPrivilege(name) then
            CAMI.RegisterPrivilege({
                Name = name,
                MinAccess = tostring(min or "user"):lower()
            })
        end
    end
end

local function camiBootstrapFromExisting()
    if not CAMI then return end
    for _, ug in ipairs(CAMI.GetUsergroups() or {}) do
        local n = ug.Name
        local inh = ug.Inherits or "user"
        lia.administrator.groups[n] = lia.administrator.groups[n] or {
            _info = {
                inheritance = inh,
                types = {}
            }
        }

        lia.administrator.applyInheritance(n)
    end

    for _, pr in ipairs(CAMI.GetPrivileges() or {}) do
        local n = pr.Name
        local m = tostring(pr.MinAccess or "user"):lower()
        if lia.administrator.privileges[n] == nil then
            lia.administrator.privileges[n] = m
            lia.administrator.privMeta[n] = tostring(pr.Category or "Unassigned")
            for g in pairs(lia.administrator.groups or {}) do
                if shouldGrant(g, m) then lia.administrator.groups[g][n] = true end
            end
        else
            lia.administrator.privMeta[n] = lia.administrator.privMeta[n] or tostring(pr.Category or "Unassigned")
        end
    end

    rebuildPrivileges()
end

function lia.administrator.hasAccess(ply, privilege)
    local grp = "user"
    if isstring(ply) then
        grp = ply
    elseif IsValid(ply) then
        if ply.getUserGroup then
            grp = tostring(ply:getUserGroup() or "user")
        elseif ply.GetUserGroup then
            grp = tostring(ply:GetUserGroup() or "user")
        end
    end

    if tostring(grp):lower() == "superadmin" then return true end
    local g = lia.administrator.groups and lia.administrator.groups[grp] or nil
    if g and g[privilege] == true then return true end
    local min = lia.administrator.privileges and lia.administrator.privileges[privilege] or "user"
    return shouldGrant(grp, min)
end

function lia.administrator.registerPrivilege(priv)
    if not priv or not priv.Name then return end
    local name = tostring(priv.Name)
    if name == "" then return end
    if lia.administrator.privileges[name] ~= nil then return end
    local min = tostring(priv.MinAccess or "user"):lower()
    lia.administrator.privileges[name] = min
    lia.administrator.privMeta[name] = tostring(priv.Category or "Unassigned")
    for groupName, perms in pairs(lia.administrator.groups) do
        perms = perms or {}
        lia.administrator.groups[groupName] = perms
        if shouldGrant(groupName, min) then perms[name] = true end
    end

    if CAMI then camiRegisterPrivilege(name, min) end
    hook.Run("OnPrivilegeRegistered", {
        Name = name,
        MinAccess = min,
        Category = lia.administrator.privMeta[name]
    })

    if SERVER then lia.administrator.save() end
end

function lia.administrator.unregisterPrivilege(name)
    name = tostring(name or "")
    if name == "" or lia.administrator.privileges[name] == nil then return end
    lia.administrator.privileges[name] = nil
    lia.administrator.privMeta[name] = nil
    for _, perms in pairs(lia.administrator.groups or {}) do
        perms[name] = nil
    end

    if CAMI then CAMI.UnregisterPrivilege(name) end
    hook.Run("OnPrivilegeUnregistered", {
        Name = name
    })

    if SERVER then lia.administrator.save() end
end

function lia.administrator.applyInheritance(groupName)
    local groups = lia.administrator.groups or {}
    local g = groups[groupName]
    if not g then return end
    local info = g._info or {}
    local inh = info.inheritance or "user"
    local visited = {}
    local function copyFrom(srcName)
        if visited[srcName] then return end
        visited[srcName] = true
        local src = groups[srcName]
        if src then
            for k, v in pairs(src) do
                if k ~= "_info" and v == true and g[k] == nil then g[k] = true end
            end

            local nxt = src._info and src._info.inheritance
            if nxt and nxt ~= srcName then copyFrom(nxt) end
        end
    end

    copyFrom(inh)
    for priv, min in pairs(lia.administrator.privileges or {}) do
        if shouldGrant(groupName, min) then g[priv] = true end
    end
end

function lia.administrator.load()
    local function ensureDefaults(groups)
        local created = false
        for _, grp in ipairs({"user", "admin", "superadmin"}) do
            if not groups[grp] then
                groups[grp] = {
                    _info = {
                        inheritance = "user",
                        types = {}
                    }
                }

                created = true
            end
        end
        return created
    end

    local function continueLoad(groups)
        lia.administrator.groups = groups or {}
        if CAMI then
            for n, t in pairs(lia.administrator.groups) do
                camiRegisterUsergroup(n, t._info and t._info.inheritance or "user")
            end

            for n, m in pairs(lia.administrator.privileges or {}) do
                camiRegisterPrivilege(n, m)
            end

            camiBootstrapFromExisting()
        end

        lia.admin(L("adminSystemLoaded"))
        hook.Run("OnAdminSystemLoaded", lia.administrator.groups or {}, lia.administrator.privileges or {})
    end

    lia.db.select("*", "admin"):next(function(res)
        local rows = res and res.results or {}
        local groups = {}
        for _, row in ipairs(rows or {}) do
            local name = row.usergroup or row.usergroups or row.group
            if isstring(name) and name ~= "" then
                local privs = util.JSONToTable(row.privileges or "") or {}
                privs._info = {
                    inheritance = row.inheritance or "user",
                    types = util.JSONToTable(row.types or "") or {}
                }

                groups[name] = privs
            end
        end

        local created = ensureDefaults(groups)
        lia.administrator._loading = true
        lia.administrator.groups = groups
        for n in pairs(groups) do
            lia.administrator.applyInheritance(n)
        end

        rebuildPrivileges()
        if created then lia.administrator.save(true) end
        lia.administrator._loading = false
        continueLoad(groups)
    end)
end

function lia.administrator.createGroup(groupName, info)
    if lia.administrator.groups[groupName] then
        lia.error(L("usergroupExists"))
        return
    end

    info = info or {}
    info._info = info._info or {
        inheritance = "user",
        types = {}
    }

    lia.administrator.groups[groupName] = info
    lia.administrator.applyInheritance(groupName)
    camiRegisterUsergroup(groupName, info._info.inheritance or "user")
    if CAMI then lia.admin(string.format("[CAMI] Usergroup created: %s inherits %s", groupName, info._info.inheritance or "user")) end
    hook.Run("OnUsergroupCreated", groupName, lia.administrator.groups[groupName])
    if SERVER then lia.administrator.save() end
end

function lia.administrator.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
        lia.error(L("baseUsergroupCannotBeRemoved"))
        return
    end

    if not lia.administrator.groups[groupName] then
        lia.error(L("usergroupDoesntExist"))
        return
    end

    lia.administrator.groups[groupName] = nil
    camiUnregisterUsergroup(groupName)
    if CAMI then lia.admin(string.format("[CAMI] Usergroup removed: %s", groupName)) end
    hook.Run("OnUsergroupRemoved", groupName)
    if SERVER then lia.administrator.save() end
end

function lia.administrator.renameGroup(oldName, newName)
    if lia.administrator.DefaultGroups[oldName] then
        lia.error(L("baseUsergroupCannotBeRenamed"))
        return
    end

    if not lia.administrator.groups[oldName] then
        lia.error(L("usergroupDoesntExist"))
        return
    end

    if lia.administrator.groups[newName] then
        lia.error(L("usergroupExists"))
        return
    end

    lia.administrator.groups[newName] = lia.administrator.groups[oldName]
    lia.administrator.groups[oldName] = nil
    lia.administrator.applyInheritance(newName)
    camiUnregisterUsergroup(oldName)
    local inh = lia.administrator.groups[newName]._info and lia.administrator.groups[newName]._info.inheritance or "user"
    camiRegisterUsergroup(newName, inh)
    if CAMI then lia.admin(string.format("[CAMI] Usergroup renamed: %s -> %s", oldName, newName)) end
    hook.Run("OnUsergroupRenamed", oldName, newName)
    if SERVER then lia.administrator.save() end
end

if SERVER then
    util.AddNetworkString("updateAdminPrivileges")
    util.AddNetworkString("updateAdminPrivilegeMeta")
    util.AddNetworkString("updateAdminGroups")
    util.AddNetworkString("liaGroupsRequest")
    util.AddNetworkString("liaGroupsAdd")
    util.AddNetworkString("liaGroupsRemove")
    util.AddNetworkString("liaGroupsRename")
    util.AddNetworkString("liaGroupsSetPerm")
    util.AddNetworkString("liaGroupPermChanged")
    function lia.administrator.addPermission(groupName, permission, silent)
        if not lia.administrator.groups[groupName] then
            lia.error(L("usergroupDoesntExist"))
            return
        end

        if lia.administrator.DefaultGroups[groupName] then return end
        lia.administrator.groups[groupName][permission] = true
        lia.administrator.save(silent and true or false)
        hook.Run("OnUsergroupPermissionsChanged", groupName, lia.administrator.groups[groupName])
    end

    function lia.administrator.removePermission(groupName, permission, silent)
        if not lia.administrator.groups[groupName] then
            lia.error(L("usergroupDoesntExist"))
            return
        end

        if lia.administrator.DefaultGroups[groupName] then return end
        lia.administrator.groups[groupName][permission] = nil
        lia.administrator.save(silent and true or false)
        hook.Run("OnUsergroupPermissionsChanged", groupName, lia.administrator.groups[groupName])
    end

    function lia.administrator.sync(c)
        lia.net.ready = lia.net.ready or setmetatable({}, {
            __mode = "k"
        })

        local function push(ply)
            if not IsValid(ply) then return end
            if not lia.net.ready[ply] then return end
            lia.net.writeBigTable(ply, "updateAdminPrivileges", lia.administrator.privileges or {})
            timer.Simple(0.05, function() if IsValid(ply) and lia.net.ready[ply] then lia.net.writeBigTable(ply, "updateAdminPrivilegeMeta", lia.administrator.privMeta or {}) end end)
            timer.Simple(0.15, function() if IsValid(ply) and lia.net.ready[ply] then lia.net.writeBigTable(ply, "updateAdminGroups", lia.administrator.groups or {}) end end)
        end

        if c and IsValid(c) then
            push(c)
            return
        end

        local t = player.GetHumans()
        for _, p in ipairs(t) do
            push(p)
        end
    end

    function lia.administrator.save(noNetwork)
        rebuildPrivileges()
        local rows = {}
        for name, data in pairs(lia.administrator.groups) do
            local info = istable(data._info) and data._info or {}
            local privs = table.Copy(data)
            privs._info = nil
            rows[#rows + 1] = {
                usergroup = name,
                privileges = util.TableToJSON(privs),
                inheritance = info.inheritance or "user",
                types = util.TableToJSON(info.types or {})
            }
        end

        lia.db.query("DELETE FROM lia_admin")
        lia.db.bulkInsert("admin", rows)
        if noNetwork or lia.administrator._loading then return end
        lia.net.ready = lia.net.ready or setmetatable({}, {
            __mode = "k"
        })

        local hasReady = false
        for ply in pairs(lia.net.ready) do
            if IsValid(ply) and lia.net.ready[ply] then
                hasReady = true
                break
            end
        end

        if not hasReady then return end
        lia.administrator.sync()
    end

    function lia.administrator.setPlayerUsergroup(ply, newGroup, source)
        if not IsValid(ply) then return end
        local old = tostring(ply:GetUserGroup() or "user")
        local new = tostring(newGroup or "user")
        if old == new then return end
        ply:SetUserGroup(new)
        if CAMI then
            CAMI.SignalUserGroupChanged(ply, old, new, source or "Lilia")
            lia.admin(string.format("[CAMI] Player usergroup changed: %s (%s) %s -> %s", ply:Nick(), ply:SteamID(), old, new))
        end
    end

    function lia.administrator.setSteamIDUsergroup(steamId, newGroup, source)
        local sid = tostring(steamId or "")
        if sid == "" then return end
        local ply = player.GetBySteamID and player.GetBySteamID(sid)
        local old = IsValid(ply) and tostring(ply:GetUserGroup() or "user") or "user"
        local new = tostring(newGroup or "user")
        if IsValid(ply) then ply:SetUserGroup(new) end
        if CAMI then
            CAMI.SignalSteamIDUserGroupChanged(sid, old, new, source or "Lilia")
            lia.admin(string.format("[CAMI] SteamID usergroup changed: %s %s -> %s", sid, old, new))
        end
    end
else
    function lia.administrator.execCommand(cmd, victim, dur, reason)
        if hook.Run("RunAdminSystemCommand") == true then return end
        local id = IsValid(victim) and victim:SteamID() or tostring(victim)
        if cmd == "kick" then
            RunConsoleCommand("say", "/plykick " .. string.format("'%s'", tostring(id)) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "ban" then
            RunConsoleCommand("say", "/plyban " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "unban" then
            RunConsoleCommand("say", "/plyunban " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "mute" then
            RunConsoleCommand("say", "/plymute " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "unmute" then
            RunConsoleCommand("say", "/plyunmute " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "gag" then
            RunConsoleCommand("say", "/plygag " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "ungag" then
            RunConsoleCommand("say", "/plyungag " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "freeze" then
            RunConsoleCommand("say", "/plyfreeze " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0))
            return true
        elseif cmd == "unfreeze" then
            RunConsoleCommand("say", "/plyunfreeze " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "slay" then
            RunConsoleCommand("say", "/plyslay " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "bring" then
            RunConsoleCommand("say", "/plybring " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "goto" then
            RunConsoleCommand("say", "/plygoto " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "return" then
            RunConsoleCommand("say", "/plyreturn " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "jail" then
            RunConsoleCommand("say", "/plyjail " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0))
            return true
        elseif cmd == "unjail" then
            RunConsoleCommand("say", "/plyunjail " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "cloak" then
            RunConsoleCommand("say", "/plycloak " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "uncloak" then
            RunConsoleCommand("say", "/plyuncloak " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "god" then
            RunConsoleCommand("say", "/plygod " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "ungod" then
            RunConsoleCommand("say", "/plyungod " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "ignite" then
            RunConsoleCommand("say", "/plyignite " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0))
            return true
        elseif cmd == "extinguish" or cmd == "unignite" then
            RunConsoleCommand("say", "/plyextinguish " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "strip" then
            RunConsoleCommand("say", "/plystrip " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "respawn" then
            RunConsoleCommand("say", "/plyrespawn " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "blind" then
            RunConsoleCommand("say", "/plyblind " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "unblind" then
            RunConsoleCommand("say", "/plyunblind " .. string.format("'%s'", tostring(id)))
            return true
        end
    end
end

if SERVER then
    local function ensureStructures()
        lia.administrator.groups = lia.administrator.groups or {}
        for n in pairs(lia.administrator.groups) do
            lia.administrator.groups[n] = lia.administrator.groups[n] or {}
        end
    end

    local function broadcastGroups()
        lia.net.ready = lia.net.ready or setmetatable({}, {
            __mode = "k"
        })

        local players = player.GetHumans()
        for _, ply in ipairs(players) do
            if lia.net.ready[ply] then lia.net.writeBigTable(ply, "updateAdminGroups", lia.administrator.groups or {}) end
        end
    end

    ensureStructures()
    net.Receive("liaGroupsRequest", function(_, p)
        if not IsValid(p) or not p:hasPrivilege("Manage Usergroups") then return end
        lia.net.ready = lia.net.ready or setmetatable({}, {
            __mode = "k"
        })

        lia.net.ready[p] = true
        lia.administrator.sync(p)
    end)

    net.Receive("liaGroupsAdd", function(_, p)
        if not p:hasPrivilege("Manage Usergroups") then return end
        local data = net.ReadTable()
        local n = string.Trim(tostring(data.name or ""))
        if n == "" then return end
        lia.administrator.groups = lia.administrator.groups or {}
        if lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[n] then return end
        if lia.administrator.groups[n] then return end
        lia.administrator.createGroup(n, {
            _info = {
                inheritance = data.inherit or "user",
                types = data.types or {}
            }
        })

        lia.administrator.save()
        broadcastGroups()
        p:notifyLocalized("groupCreated", n)
    end)

    net.Receive("liaGroupsRemove", function(_, p)
        if not p:hasPrivilege("Manage Usergroups") then return end
        local n = net.ReadString()
        if n == "" or lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[n] then return end
        lia.administrator.removeGroup(n)
        if lia.administrator.groups then lia.administrator.groups[n] = nil end
        lia.administrator.save()
        broadcastGroups()
        p:notifyLocalized("groupRemoved", n)
    end)

    net.Receive("liaGroupsRename", function(_, p)
        if not p:hasPrivilege("Manage Usergroups") then return end
        local old = string.Trim(net.ReadString() or "")
        local new = string.Trim(net.ReadString() or "")
        if old == "" or new == "" then return end
        if old == new then return end
        if not lia.administrator.groups or not lia.administrator.groups[old] then return end
        if lia.administrator.groups[new] or lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[new] then return end
        if lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[old] then return end
        lia.administrator.renameGroup(old, new)
        broadcastGroups()
        p:notifyLocalized("groupRenamed", old, new)
    end)

    net.Receive("liaGroupsSetPerm", function(_, p)
        if not p:hasPrivilege("Manage Usergroups") then return end
        local group = net.ReadString()
        local privilege = net.ReadString()
        local value = net.ReadBool()
        if group == "" or privilege == "" then return end
        if lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[group] then return end
        if not lia.administrator.groups or not lia.administrator.groups[group] then return end
        if SERVER then
            if value then
                lia.administrator.addPermission(group, privilege, true)
            else
                lia.administrator.removePermission(group, privilege, true)
            end
        end

        net.Start("liaGroupPermChanged")
        net.WriteString(group)
        net.WriteString(privilege)
        net.WriteBool(value)
        net.Broadcast()
        p:notifyLocalized("groupPermissionsUpdated")
    end)
else
    local LAST_GROUP
    local function computeCategoryMap(groups)
        local cats, seen = {}, {}
        for name in pairs(lia.administrator.privileges or {}) do
            local c = lia.administrator.privMeta and lia.administrator.privMeta[name] or "Unassigned"
            cats[c] = cats[c] or {}
            cats[c][#cats[c] + 1], seen[name] = name, true
        end

        for _, data in pairs(groups or {}) do
            for name in pairs(data or {}) do
                if name ~= "_info" and not seen[name] then
                    local c = lia.administrator.privMeta and lia.administrator.privMeta[name] or "Unassigned"
                    cats[c] = cats[c] or {}
                    cats[c][#cats[c] + 1], seen[name] = name, true
                end
            end
        end

        local keys = {}
        for k in pairs(cats) do
            keys[#keys + 1] = k
        end

        table.sort(keys, function(a, b) return a:lower() < b:lower() end)
        for _, k in ipairs(keys) do
            table.sort(cats[k], function(a, b) return a:lower() < b:lower() end)
        end
        return cats, keys
    end

    local function promptCreateGroup()
        lia.util.requestArguments(L("createGroup"), {
            Name = "string",
            Inheritance = {"table", {"user", "admin", "superadmin"}},
            Staff = "boolean",
            User = "boolean",
            VIP = "boolean"
        }, function(data)
            local name = string.Trim(tostring(data.Name or ""))
            if name == "" then return end
            local types = {}
            if data.Staff then types[#types + 1] = "Staff" end
            if data.User then types[#types + 1] = "User" end
            if data.VIP then types[#types + 1] = "VIP" end
            LAST_GROUP = name
            net.Start("liaGroupsAdd")
            net.WriteTable({
                name = name,
                inherit = data.Inheritance or "user",
                types = types
            })

            net.SendToServer()
        end)
    end

    local function buildPrivilegeList(parent, g, groups, editable)
        local current = table.Copy(groups[g] or {})
        current._info = nil
        surface.SetFont("liaMediumFont")
        local _, fh = surface.GetTextSize("W")
        local cb = math.max(20, fh + 6)
        local rowH = math.max(fh + 14, cb + 8)
        local off = math.floor((rowH - fh) * 0.5)
        local categoryList = parent:Add("DCategoryList")
        categoryList:Dock(TOP)
        categoryList:DockMargin(20, 0, 20, 4)
        lia.gui.usergroups.checks = lia.gui.usergroups.checks or {}
        lia.gui.usergroups.checks[g] = lia.gui.usergroups.checks[g] or {}
        local function addRow(container, name)
            local row = container:Add("DPanel")
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 8)
            row:SetTall(rowH)
            row.Paint = function() end
            local lbl = row:Add("DLabel")
            lbl:Dock(FILL)
            lbl:DockMargin(0, off, 8, 0)
            lbl:SetText(name)
            lbl:SetFont("liaMediumFont")
            lbl:SizeToContents()
            local chk = row:Add("liaCheckBox")
            chk:SetSize(cb + 12, cb)
            chk:Dock(RIGHT)
            chk:SetChecked(current[name] and true or false)
            chk._suppress = false
            if editable then
                chk.OnChange = function(_, v)
                    if chk._suppress then
                        chk._suppress = false
                        return
                    end

                    if v then
                        current[name] = true
                    else
                        current[name] = nil
                    end

                    net.Start("liaGroupsSetPerm")
                    net.WriteString(g)
                    net.WriteString(name)
                    net.WriteBool(v)
                    net.SendToServer()
                end
            else
                chk:SetMouseInputEnabled(false)
                chk:SetCursor("arrow")
            end

            lia.gui.usergroups.checks[g][name] = chk
        end

        local cats, order = computeCategoryMap(groups)
        for _, catName in ipairs(order) do
            local pnl = vgui.Create("DPanel", categoryList)
            pnl:Dock(TOP)
            pnl.Paint = function() end
            local layout = vgui.Create("DListLayout", pnl)
            layout:Dock(FILL)
            for _, priv in ipairs(cats[catName]) do
                addRow(layout, priv)
            end

            pnl:InvalidateLayout(true)
            pnl:SizeToChildren(true, true)
            local cat = categoryList:Add(catName)
            cat:SetContents(pnl)
            cat:SetExpanded(true)
        end
        return categoryList, current
    end

    function renderGroupInfo(parent, g, groups)
        parent:Clear()
        LAST_GROUP = g
        local editable = not lia.administrator.DefaultGroups[g]
        local bottomTall = 36
        local bottomMargin = 10
        local bottom = parent:Add("DPanel")
        bottom:Dock(BOTTOM)
        bottom:SetTall(bottomTall)
        bottom:DockMargin(10, 0, 10, bottomMargin)
        bottom.Paint = function() end
        local scroll = parent:Add("DScrollPanel")
        scroll:Dock(FILL)
        scroll:DockMargin(0, 0, 0, bottomTall + bottomMargin)
        local nameLbl = scroll:Add("DLabel")
        nameLbl:Dock(TOP)
        nameLbl:DockMargin(20, 20, 0, 0)
        nameLbl:SetText(L("name") .. ":")
        nameLbl:SetFont("liaBigFont")
        nameLbl:SizeToContents()
        local nameVal = scroll:Add("DLabel")
        nameVal:Dock(TOP)
        nameVal:DockMargin(20, 2, 0, 10)
        nameVal:SetText(g)
        nameVal:SetFont("liaMediumFont")
        nameVal:SizeToContents()
        local inhLbl = scroll:Add("DLabel")
        inhLbl:Dock(TOP)
        inhLbl:DockMargin(20, 10, 0, 0)
        inhLbl:SetText(L("inheritsFrom"))
        inhLbl:SetFont("liaBigFont")
        inhLbl:SizeToContents()
        local inhVal = scroll:Add("DLabel")
        inhVal:Dock(TOP)
        inhVal:DockMargin(20, 2, 0, 0)
        local info = groups[g] and groups[g]._info or {}
        inhVal:SetText(info.inheritance or "user")
        inhVal:SetFont("liaMediumFont")
        inhVal:SizeToContents()
        local function hasType(t)
            for _, v in ipairs(info.types or {}) do
                if tostring(v):lower() == t:lower() then return true end
            end
            return false
        end

        local staffLbl = scroll:Add("DLabel")
        staffLbl:Dock(TOP)
        staffLbl:DockMargin(20, 10, 0, 0)
        staffLbl:SetText(L("isStaffLabel"))
        staffLbl:SetFont("liaBigFont")
        staffLbl:SizeToContents()
        local staffVal = scroll:Add("DLabel")
        staffVal:Dock(TOP)
        staffVal:DockMargin(20, 2, 0, 0)
        staffVal:SetText(hasType("Staff") and L("yes") or L("no"))
        staffVal:SetFont("liaMediumFont")
        staffVal:SizeToContents()
        local vipLbl = scroll:Add("DLabel")
        vipLbl:Dock(TOP)
        vipLbl:DockMargin(20, 10, 0, 0)
        vipLbl:SetText(L("isVIPLabel"))
        vipLbl:SetFont("liaBigFont")
        vipLbl:SizeToContents()
        local vipVal = scroll:Add("DLabel")
        vipVal:Dock(TOP)
        vipVal:DockMargin(20, 2, 0, 0)
        vipVal:SetText(hasType("VIP") and L("yes") or L("no"))
        vipVal:SetFont("liaMediumFont")
        vipVal:SizeToContents()
        local privLbl = scroll:Add("DLabel")
        privLbl:Dock(TOP)
        privLbl:DockMargin(20, 10, 0, 6)
        privLbl:SetText(L("privilegesLabel"))
        privLbl:SetFont("liaBigFont")
        privLbl:SizeToContents()
        buildPrivilegeList(scroll, g, groups, editable)
        if editable then
            local createBtn = bottom:Add("liaMediumButton")
            local renameBtn = bottom:Add("liaMediumButton")
            local delBtn = bottom:Add("liaMediumButton")
            createBtn:SetText(L("createGroup"))
            renameBtn:SetText(L("renameGroup"))
            delBtn:SetText(L("deleteGroup"))
            createBtn.DoClick = function() promptCreateGroup() end
            renameBtn.DoClick = function()
                Derma_StringRequest(L("renameGroup"), string.format(L("renameGroupPrompt"), g), g, function(txt)
                    txt = string.Trim(txt or "")
                    if txt == "" or txt == g then return end
                    LAST_GROUP = txt
                    net.Start("liaGroupsRename")
                    net.WriteString(g)
                    net.WriteString(txt)
                    net.SendToServer()
                end)
            end

            delBtn.DoClick = function()
                Derma_Query(string.format(L("deleteGroupPrompt"), g), L("confirm"), L("yes"), function()
                    net.Start("liaGroupsRemove")
                    net.WriteString(g)
                    net.SendToServer()
                end, L("no"))
            end

            bottom.PerformLayout = function(_, w, bh)
                local bw = math.floor(w / 3)
                createBtn:SetPos(0, 0)
                createBtn:SetSize(bw, bh)
                renameBtn:SetPos(bw, 0)
                renameBtn:SetSize(bw, bh)
                delBtn:SetPos(bw * 2, 0)
                delBtn:SetSize(w - bw * 2, bh)
            end
        else
            local addBtn = bottom:Add("liaMediumButton")
            addBtn:SetText(L("createGroup"))
            addBtn.DoClick = function() promptCreateGroup() end
            bottom.PerformLayout = function(_, w, bh)
                addBtn:SetPos(0, 0)
                addBtn:SetSize(w, bh)
            end
        end
    end

    local function buildGroupsUI(panel, groups)
        panel:Clear()
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        panel.pages = {}
        panel.checks = {}
        lia.gui.usergroups.checks = {}
        local keys = {}
        for g in pairs(groups or {}) do
            keys[#keys + 1] = g
        end

        table.sort(keys, function(a, b) return a:lower() < b:lower() end)
        for _, g in ipairs(keys) do
            local page = sheet:Add("DPanel")
            page:Dock(FILL)
            renderGroupInfo(page, g, groups)
            sheet:AddSheet(g, page)
            panel.pages[g] = page
        end

        if LAST_GROUP and groups[LAST_GROUP] then
            for _, tab in ipairs(sheet.Items) do
                if tab.Name == LAST_GROUP then
                    sheet:SetActiveTab(tab.Tab)
                    break
                end
            end
        elseif sheet.Items[1] then
            sheet:SetActiveTab(sheet.Items[1].Tab)
        end
    end

    lia.net.readBigTable("updateAdminGroups", function(tbl)
        lia.administrator.groups = tbl
        if CAMI then
            for n, t in pairs(tbl or {}) do
                camiRegisterUsergroup(n, t._info and t._info.inheritance or "user")
            end
        end

        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, tbl) end
    end)

    lia.net.readBigTable("updateAdminPrivileges", function(tbl)
        lia.administrator.privileges = tbl
        if CAMI then
            for n, m in pairs(tbl or {}) do
                camiRegisterPrivilege(n, m)
            end
        end
    end)

    lia.net.readBigTable("updateAdminPrivilegeMeta", function(tbl)
        lia.administrator.privMeta = tbl or {}
        if IsValid(lia.gui.usergroups) and lia.administrator.groups then
            local pnl = lia.gui.usergroups
            pnl:Clear()
            local sheet = pnl:Add("DPropertySheet")
            sheet:Dock(FILL)
            sheet:DockMargin(10, 10, 10, 10)
            local keys = {}
            for g in pairs(lia.administrator.groups or {}) do
                keys[#keys + 1] = g
            end

            table.sort(keys, function(a, b) return a:lower() < b:lower() end)
            for _, g in ipairs(keys) do
                local page = sheet:Add("DPanel")
                page:Dock(FILL)
                renderGroupInfo(page, g, lia.administrator.groups)
                sheet:AddSheet(g, page)
            end
        end
    end)

    net.Receive("liaGroupPermChanged", function()
        local group = net.ReadString()
        local privilege = net.ReadString()
        local value = net.ReadBool()
        lia.administrator.groups = lia.administrator.groups or {}
        lia.administrator.groups[group] = lia.administrator.groups[group] or {}
        if value then
            lia.administrator.groups[group][privilege] = true
        else
            lia.administrator.groups[group][privilege] = nil
        end

        if IsValid(lia.gui.usergroups) and lia.gui.usergroups.checks and lia.gui.usergroups.checks[group] then
            local chk = lia.gui.usergroups.checks[group][privilege]
            if IsValid(chk) and chk:GetChecked() ~= value then
                chk._suppress = true
                chk:SetChecked(value)
            end
        end
    end)

    hook.Add("PopulateAdminTabs", "liaAdmin", function(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("Manage Usergroups") then return end
        pages[#pages + 1] = {
            name = L("userGroups"),
            drawFunc = function(parent)
                lia.gui.usergroups = parent
                parent:Clear()
                parent:DockPadding(10, 10, 10, 10)
                parent.Paint = function(p, w, h) derma.SkinHook("Paint", "Frame", p, w, h) end
                buildGroupsUI(parent, lia.administrator.groups)
                net.Start("liaGroupsRequest")
                net.SendToServer()
            end
        }
    end)
end

if CAMI then
    local function defaultAccessHandler(actor, privilege, callback, target, extra)
        local grp = "user"
        if IsValid(actor) then
            if actor.getUserGroup then
                grp = tostring(actor:getUserGroup() or "user")
            elseif actor.GetUserGroup then
                grp = tostring(actor:GetUserGroup() or "user")
            end
        end

        local allow = false
        if tostring(grp):lower() == "superadmin" then
            allow = true
        else
            local g = lia.administrator.groups and lia.administrator.groups[grp] or nil
            if g and g[privilege] == true then
                allow = true
            else
                local min = lia.administrator.privileges and lia.administrator.privileges[privilege] or "user"
                allow = shouldGrant(grp, min)
            end
        end

        if istable(extra) and (extra.isUse or extra.IsUse or extra.use) then if IsValid(actor) and actor:IsFrozen() then allow = false end end
        if isfunction(callback) then callback(allow, "lia") end
        if IsValid(actor) then
            local who = string.format("%s (%s)", actor:Nick(), actor:SteamID())
            lia.admin(string.format("[CAMI] Access check: %s privilege=\"%s\" allow=%s", who, tostring(privilege), tostring(allow)))
        else
            lia.admin(string.format("[CAMI] Access check: non-player privilege=\"%s\" allow=%s", tostring(privilege), tostring(allow)))
        end
        return true
    end

    hook.Add("CAMI.PlayerHasAccess", "liaAdminAccess", defaultAccessHandler)
    hook.Add("CAMI.OnUsergroupRegistered", "liaAdminUGAdded", function(usergroup, source)
        local ug = usergroup or {}
        local n = ug.Name
        if not isstring(n) or n == "" then return end
        if not lia.administrator.groups[n] then
            lia.administrator.groups[n] = {
                _info = {
                    inheritance = ug.Inherits or "user",
                    types = {}
                }
            }

            lia.administrator.applyInheritance(n)
            if SERVER then
                lia.administrator.save()
                lia.administrator.sync()
            end
        end

        lia.admin(string.format("[CAMI] OnUsergroupRegistered: %s inherits %s (source=%s)", n, ug.Inherits or "user", tostring(source)))
    end)

    hook.Add("CAMI.OnUsergroupUnregistered", "liaAdminUGRemoved", function(usergroup, source)
        local ug = usergroup or {}
        local n = ug.Name
        if not isstring(n) or n == "" then return end
        if lia.administrator.groups[n] and not lia.administrator.DefaultGroups[n] then
            lia.administrator.groups[n] = nil
            if SERVER then
                lia.administrator.save()
                lia.administrator.sync()
            end
        end

        lia.admin(string.format("[CAMI] OnUsergroupUnregistered: %s (source=%s)", n, tostring(source)))
    end)

    hook.Add("CAMI.OnPrivilegeRegistered", "liaAdminPrivAdded", function(priv)
        local name = priv and priv.Name
        if not isstring(name) or name == "" then return end
        if lia.administrator.privileges[name] ~= nil then return end
        local min = tostring(priv.MinAccess or "user"):lower()
        lia.administrator.privileges[name] = min
        lia.administrator.privMeta[name] = tostring(priv.Category or "Unassigned")
        for groupName in pairs(lia.administrator.groups or {}) do
            if shouldGrant(groupName, min) then lia.administrator.groups[groupName][name] = true end
        end

        if SERVER then
            lia.administrator.save()
            lia.administrator.sync()
        end

        lia.admin(string.format("[CAMI] OnPrivilegeRegistered: %s min=%s", name, min))
    end)

    hook.Add("CAMI.OnPrivilegeUnregistered", "liaAdminPrivRemoved", function(priv)
        local name = priv and priv.Name
        if not isstring(name) or name == "" then return end
        if lia.administrator.privileges[name] == nil then return end
        lia.administrator.privileges[name] = nil
        lia.administrator.privMeta[name] = nil
        for _, g in pairs(lia.administrator.groups or {}) do
            g[name] = nil
        end

        if SERVER then
            lia.administrator.save()
            lia.administrator.sync()
        end

        lia.admin(string.format("[CAMI] OnPrivilegeUnregistered: %s", name))
    end)

    hook.Add("CAMI.PlayerUsergroupChanged", "liaAdminPlyUGChanged", function(ply, old, new, source)
        if not IsValid(ply) then return end
        local newGroup = tostring(new or "user")
        if tostring(ply:GetUserGroup() or "user") ~= newGroup then ply:SetUserGroup(newGroup) end
        lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(newGroup), ply:SteamID64()))
        lia.admin(string.format("[CAMI] PlayerUsergroupChanged: %s (%s) %s -> %s (source=%s)", ply:Nick(), ply:SteamID(), tostring(old or "user"), newGroup, tostring(source)))
    end)

    hook.Add("CAMI.SteamIDUsergroupChanged", "liaAdminSIDUGChanged", function(steamId, old, new, source)
        local sid = tostring(steamId or "")
        if sid == "" then return end
        local newGroup = tostring(new or "user")
        local ply = player.GetBySteamID and player.GetBySteamID(sid)
        if IsValid(ply) and tostring(ply:GetUserGroup() or "user") ~= newGroup then ply:SetUserGroup(newGroup) end
        local steam64 = util.SteamIDTo64(sid)
        lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(newGroup), steam64))
        lia.admin(string.format("[CAMI] SteamIDUsergroupChanged: %s %s -> %s (source=%s)", sid, tostring(old or "user"), newGroup, tostring(source)))
    end)
end