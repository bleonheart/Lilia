lia.adminstrator = lia.adminstrator or {}
lia.adminstrator.groups = lia.adminstrator.groups or {}
lia.adminstrator.privileges = lia.adminstrator.privileges or {}
lia.adminstrator.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
}

function lia.adminstrator.load()
    local function continueLoad(groups, privileges)
        lia.adminstrator.groups = groups or {}
        lia.adminstrator.privileges = privileges or lia.adminstrator.privileges or {}
        local defaults = {"user", "admin", "superadmin"}
        local created = false
        if table.Count(lia.adminstrator.groups) == 0 then
            for _, grp in ipairs(defaults) do
                lia.adminstrator.createGroup(grp)
            end

            created = true
        else
            for _, grp in ipairs(defaults) do
                if not lia.adminstrator.groups[grp] then
                    lia.adminstrator.createGroup(grp)
                    created = true
                end
            end
        end

        if created then lia.adminstrator.save() end
        lia.bootstrap("Administration", L("adminSystemLoaded"))
    end

    lia.db.selectOne({"usergroups", "privileges"}, "admin"):next(function(res)
        local groups = res and util.JSONToTable(res.usergroups or "") or {}
        local privs = res and util.JSONToTable(res.privileges or "") or {}
        continueLoad(groups, privs)
    end)
end

function lia.adminstrator.createGroup(groupName, info)
    if lia.adminstrator.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.adminstrator.groups[groupName] = info or {}
    if SERVER then lia.adminstrator.save() end
end

function lia.adminstrator.registerPrivilege(privilege)
    if not privilege or not privilege.Name then return end
    lia.adminstrator.privileges[privilege.Name] = privilege
end

function lia.adminstrator.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
        lia.error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.adminstrator.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.adminstrator.groups[groupName] = nil
    if SERVER then lia.adminstrator.save() end
end

function lia.adminstrator.renameGroup(oldName, newName)
    if lia.adminstrator.DefaultGroups[oldName] then
        lia.error("[Lilia Administration] The base usergroups cannot be renamed!\n")
        return
    end

    if not lia.adminstrator.groups[oldName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    if lia.adminstrator.groups[newName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.adminstrator.groups[newName] = lia.adminstrator.groups[oldName]
    lia.adminstrator.groups[oldName] = nil
    if SERVER then lia.adminstrator.save() end
end

if SERVER then
    function lia.adminstrator.addPermission(groupName, permission)
        if not lia.adminstrator.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.adminstrator.DefaultGroups[groupName] then return end
        lia.adminstrator.groups[groupName][permission] = true
        if SERVER then
            lia.adminstrator.save()
            hook.Run("OnUsergroupPermissionsChanged", groupName, lia.adminstrator.groups[groupName])
        end
    end

    function lia.adminstrator.removePermission(groupName, permission)
        if not lia.adminstrator.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.adminstrator.DefaultGroups[groupName] then return end
        lia.adminstrator.groups[groupName][permission] = nil
        if SERVER then
            lia.adminstrator.save()
            hook.Run("OnUsergroupPermissionsChanged", groupName, lia.adminstrator.groups[groupName])
        end
    end

    function lia.adminstrator.sync(client)
        net.Start("updateAdminGroups")
        net.WriteTable(lia.adminstrator.groups)
        if client and IsValid(client) then
            net.Start(client)
        else
            net.Broadcast()
        end
    end

    function lia.adminstrator.save(noNetwork)
        lia.db.upsert({
            usergroups = util.TableToJSON(lia.adminstrator.groups),
            privileges = util.TableToJSON(lia.adminstrator.privileges)
        }, "admin")

        if noNetwork then return end
        lia.adminstrator.sync()
    end
else
    function lia.adminstrator.execCommand(cmd, victim, dur, reason)
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