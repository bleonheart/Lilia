lia.administrator = lia.administrator or {}
lia.administrator.groups = lia.administrator.groups or {}
lia.administrator.privileges = lia.administrator.privileges or {}
lia.administrator.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
}

function lia.administrator.load()
    local function continueLoad(groups, privileges)
        lia.administrator.groups = groups or {}
        lia.administrator.privileges = privileges or lia.administrator.privileges or {}
        lia.administrator.syncPrivileges()
        local defaults = {"user", "admin", "superadmin"}
        local created = false
        if table.Count(lia.administrator.groups) == 0 then
            for _, grp in ipairs(defaults) do
                lia.administrator.createGroup(grp)
            end

            created = true
        else
            for _, grp in ipairs(defaults) do
                if not lia.administrator.groups[grp] then
                    lia.administrator.createGroup(grp)
                    created = true
                end
            end
        end

        if created then lia.administrator.save() end
        lia.bootstrap("Administration", L("adminSystemLoaded"))
    end

    lia.db.selectOne({"usergroups", "privileges"}, "admin"):next(function(res)
        local groups = res and util.JSONToTable(res.usergroups or "") or {}
        local privs = res and util.JSONToTable(res.privileges or "") or {}
        continueLoad(groups, privs)
    end)
end

function lia.administrator.createGroup(groupName, info)
    if lia.administrator.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administrator.groups[groupName] = info or {}
    lia.administrator.syncPrivileges()
    if SERVER then lia.administrator.save() end
end

local function shouldGrant(g, min)
    return g == "superadmin" or g == "admin" and min ~= "superadmin" or min == "user"
end

local function grantPrivilegeToGroups(priv)
    if not SERVER then return end
    local min = priv.MinAccess or "user"
    for groupName, permissions in pairs(lia.administrator.groups or {}) do
        permissions = permissions or {}
        lia.administrator.groups[groupName] = permissions
        if shouldGrant(groupName, min) and not permissions[priv.Name] then
            permissions[priv.Name] = true
        end
    end
end

function lia.administrator.syncPrivileges()
    for _, priv in pairs(lia.administrator.privileges or {}) do
        grantPrivilegeToGroups(priv)
    end
end

function lia.administrator.registerPrivilege(privilege)
    if not privilege or not privilege.Name then return end
    lia.administrator.privileges[privilege.Name] = privilege
    grantPrivilegeToGroups(privilege)
end

function lia.administrator.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
        lia.error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.administrator.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.administrator.groups[groupName] = nil
    if SERVER then lia.administrator.save() end
end

function lia.administrator.renameGroup(oldName, newName)
    oldName = string.Trim(oldName or "")
    newName = string.Trim(newName or "")
    if oldName == "" or newName == "" or oldName == newName then return end

    if lia.administrator.DefaultGroups[oldName] then
        lia.error("[Lilia Administration] The base usergroups cannot be renamed!\n")
        return
    end

    if not lia.administrator.groups[oldName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    if lia.administrator.groups[newName] or lia.administrator.DefaultGroups[newName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administrator.groups[newName] = lia.administrator.groups[oldName]
    lia.administrator.groups[oldName] = nil
    if SERVER then lia.administrator.save() end
end

if SERVER then
    function lia.administrator.addPermission(groupName, permission)
        if not lia.administrator.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administrator.DefaultGroups[groupName] then return end
        lia.administrator.groups[groupName][permission] = true
        if SERVER then
            lia.administrator.save()
            hook.Run("OnUsergroupPermissionsChanged", groupName, lia.administrator.groups[groupName])
        end
    end

    function lia.administrator.removePermission(groupName, permission)
        if not lia.administrator.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administrator.DefaultGroups[groupName] then return end
        lia.administrator.groups[groupName][permission] = nil
        if SERVER then
            lia.administrator.save()
            hook.Run("OnUsergroupPermissionsChanged", groupName, lia.administrator.groups[groupName])
        end
    end

    function lia.administrator.sync(client)
        if client and IsValid(client) then
            lia.net.writeBigTable(client, "updateAdminGroups", lia.administrator.groups)
        else
            local players = player.GetHumans()
            if #players > 0 then
                for _, ply in ipairs(players) do
                    lia.net.writeBigTable(ply, "updateAdminGroups", lia.administrator.groups)
                end
            end
        end
    end

    function lia.administrator.save(noNetwork)
        lia.db.upsert({
            usergroups = util.TableToJSON(lia.administrator.groups),
            privileges = util.TableToJSON(lia.administrator.privileges)
        }, "admin")

        if noNetwork then return end
        lia.administrator.sync()
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