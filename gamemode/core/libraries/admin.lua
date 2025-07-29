lia.admin = lia.admin or {}
lia.admin.groups = lia.admin.groups or {}
lia.admin.privileges = lia.admin.privileges or {}
lia.admin.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
}

function lia.admin.load()
    local camiGroups = CAMI.GetUsergroups and CAMI.GetUsergroups()
    local function continueLoad(data)
        if camiGroups and not table.IsEmpty(camiGroups) then
            lia.admin.groups = {}
            for name in pairs(camiGroups) do
                lia.admin.groups[name] = {}
            end
        else
            lia.admin.groups = data or {}
        end

        for name, priv in pairs(CAMI.GetPrivileges() or {}) do
            lia.admin.privileges[name] = priv
        end

        if camiGroups and not table.IsEmpty(camiGroups) then
            for group in pairs(lia.admin.groups) do
                for privName, priv in pairs(lia.admin.privileges) do
                    if CAMI.UsergroupInherits(group, priv.MinAccess or "user") then lia.admin.groups[group][privName] = true end
                end
            end
        end

        local defaults = {"user", "admin", "superadmin"}
        local created = false
        if not (camiGroups and not table.IsEmpty(camiGroups)) then
            if table.Count(lia.admin.groups) == 0 then
                for _, grp in ipairs(defaults) do
                    lia.admin.createGroup(grp)
                end

                created = true
            else
                for _, grp in ipairs(defaults) do
                    if not lia.admin.groups[grp] then
                        lia.admin.createGroup(grp)
                        created = true
                    end
                end
            end
        end

        if created then lia.admin.save(true) end
        lia.bootstrap("Administration", L("adminSystemLoaded"))
    end

    lia.db.selectOne({"_data"}, "admingroups"):next(function(res)
        local data = res and util.JSONToTable(res._data or "") or {}
        continueLoad(data)
    end)
end

function lia.admin.createGroup(groupName, info)
    if lia.admin.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.admin.groups[groupName] = info or {}
    if SERVER then
        if not CAMI.GetUsergroup(groupName) then
            CAMI.RegisterUsergroup({
                Name = groupName,
                Inherits = "user",
            })
        end

        lia.admin.save(true)
    end
end

function lia.admin.registerPrivilege(privilege)
    if not privilege or not privilege.Name then return end
    lia.admin.privileges[privilege.Name] = privilege
end

function lia.admin.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
        lia.error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.admin.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.admin.groups[groupName] = nil
    if SERVER then
        CAMI.UnregisterUsergroup(groupName)
        lia.admin.save(true)
    end
end

if SERVER then
    function lia.admin.addPermission(groupName, permission)
        if not lia.admin.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.admin.DefaultGroups[groupName] then return end
        lia.admin.groups[groupName][permission] = true
        if SERVER then
            lia.admin.save(true)
            hook.Run("CAMI.OnUsergroupPermissionsChanged", groupName, lia.admin.groups[groupName])
        end
    end

    function lia.admin.removePermission(groupName, permission)
        if not lia.admin.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.admin.DefaultGroups[groupName] then return end
        lia.admin.groups[groupName][permission] = nil
        if SERVER then
            lia.admin.save(true)
            hook.Run("CAMI.OnUsergroupPermissionsChanged", groupName, lia.admin.groups[groupName])
        end
    end

    function lia.admin.save(network)
        lia.db.upsert({
            _data = util.TableToJSON(lia.admin.groups)
        }, "admingroups")

        if network then
            net.Start("updateAdminGroups")
            net.WriteTable(lia.admin.groups)
            net.Broadcast()
        end
    end

    function lia.admin.setPlayerGroup(ply, usergroup)
        local old = ply:GetUserGroup()
        ply:SetUserGroup(usergroup)
        CAMI.SignalUserGroupChanged(ply, old, usergroup, "Lilia")
        lia.db.query(Format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
    end
else
    function lia.admin.execCommand(cmd, victim, dur, reason)
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