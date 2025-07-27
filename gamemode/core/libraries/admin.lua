lia.administration = lia.administration or {}
lia.administration.groups = lia.administration.groups or {}
lia.administration.privileges = lia.administration.privileges or {}
lia.administration.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
    developer = true,
}

lia.administration.DefaultPrivileges = {
    {
        Name = "Can Remove Warns",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage Prop Blacklist",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access Configuration Menu",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access Edit Configuration Menu",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage UserGroups",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Can Bypass Character Lock",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Grab World Props",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Grab Players",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Physgun Pickup",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Access Item Informations",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Physgun Pickup on Restricted Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Physgun Pickup on Vehicles",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can't be Grabbed with PhysGun",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Physgun Reload",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Clip Outside Staff Character",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Clip ESP Outside Staff Character",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Property World Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Manage Car Blacklist",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Ragdolls",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn SWEPs",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Effects",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Props",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Blacklisted Props",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn NPCs",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Car Spawn Delay",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "No Spawn Delay",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Cars",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn Blacklisted Cars",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Spawn SENTs",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "UserGroups - Staff Group",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "UserGroups - VIP Group",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "List Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Can Remove Blocked Entities",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Can Remove World Entities",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "View Staff Actions",
        MinAccess = "admin",
        Category = "Staff Management"
    },
    {
        Name = "View Player Warnings",
        MinAccess = "admin",
        Category = "Staff Management"
    },
    {
        Name = "View Claims",
        MinAccess = "admin",
        Category = "Staff Management"
    },
    {
        Name = "Can Use Item Spawner",
        MinAccess = "admin",
        Category = "Item Spawner"
    },
    {
        Name = "Use Admin Stick",
        MinAccess = "superadmin",
        Category = "Admin Stick"
    },
    {
        Name = "Can See Logs",
        MinAccess = "superadmin",
        Category = "Logger"
    },
    {
        Name = "Always See Tickets",
        MinAccess = "superadmin",
        Category = "Tickets"
    },
    {
        Name = "No OOC Cooldown",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Admin Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Local Event Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Event Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Always Have Access to Help Chat",
        MinAccess = "superadmin",
        Category = "Chatbox"
    },
    {
        Name = "Can Access Scoreboard Admin Options",
        MinAccess = "admin",
        Category = "Scoreboard"
    },
    {
        Name = "Can Access Scoreboard Info Out Of Staff",
        MinAccess = "admin",
        Category = "Scoreboard"
    },
    {
        Name = "Can Edit Vendors",
        MinAccess = "admin",
        Category = "Vendors"
    },
    {
        Name = "Can Spawn Storage",
        MinAccess = "superadmin",
        Category = "Storage"
    },
    {
        Name = "Can See Alting Notifications",
        MinAccess = "admin",
        Category = "Protection"
    },
    {
        Name = "Access Entity List",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Teleport to Entity",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Teleport to Entity (Entity Tab)",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "View Entity (Entity Tab)",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Access Module List",
        MinAccess = "user",
        Category = "F1 Menu"
    },
}

function lia.administration.savePrivileges(group)
    if not SERVER or not group or not lia.administration.groups[group] then return end
    lia.db.upsert({
        usergroup = group,
        privileges = util.TableToJSON(lia.administration.groups[group])
    }, "privileges")
end

function lia.administration.syncPrivileges()
    for grp in pairs(lia.administration.groups) do
        lia.administration.savePrivileges(grp)
    end
end

function lia.administration.load()
    local camiGroups = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups()
    local function continueLoad(data)
        if camiGroups and not table.IsEmpty(camiGroups) then
            lia.administration.groups = {}
            for name in pairs(camiGroups) do
                lia.administration.groups[name] = {}
            end
        else
            lia.administration.groups = data or {}
        end

        for name, priv in pairs(CAMI and CAMI.GetPrivileges and CAMI.GetPrivileges() or {}) do
            lia.administration.privileges[name] = {
                Name = name,
                MinAccess = priv.MinAccess or "user",
                Category = priv.Category or "Unassigned"
            }
        end

        if camiGroups and not table.IsEmpty(camiGroups) and CAMI then
            for group in pairs(lia.administration.groups) do
                for privName, priv in pairs(lia.administration.privileges) do
                    if CAMI.UsergroupInherits and CAMI.UsergroupInherits(group, priv.MinAccess or "user") then lia.administration.groups[group][privName] = true end
                end
            end
        end

        local defaults = {"user", "admin", "superadmin", "developer"}
        local created = false
        if table.Count(lia.administration.groups) == 0 then
            for _, grp in ipairs(defaults) do
                lia.administration.createGroup(grp)
            end

            created = true
        else
            for _, grp in ipairs(defaults) do
                if not lia.administration.groups[grp] then
                    lia.administration.createGroup(grp)
                    created = true
                end
            end
        end

        if created then lia.administration.save(true) end
        lia.administration.syncPrivileges()
        for _, priv in ipairs(lia.administration.DefaultPrivileges) do
            if not lia.administration.privileges[priv.Name] then lia.administration.registerPrivilege(priv) end
        end

        lia.admin("Bootstrap", L("adminSystemLoaded"))
    end

    lia.db.select({"usergroup", "privileges"}, "privileges"):next(function(res)
        local groups = {}
        for _, row in ipairs(res.results or {}) do
            groups[row.usergroup] = util.JSONToTable(row.privileges or "") or {}
        end

        continueLoad(groups)
    end)
end

function lia.administration.createGroup(groupName, info)
    if lia.administration.groups[groupName] then
        Error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administration.groups[groupName] = info or {}
    for privName, priv in pairs(lia.administration.privileges) do
        local minAccess = priv.MinAccess or "user"
        local allowed = false
        if CAMI and CAMI.UsergroupInherits then
            allowed = CAMI.UsergroupInherits(groupName, minAccess)
        else
            if groupName == "superadmin" or groupName == "developer" then
                allowed = true
            elseif groupName == "admin" then
                allowed = minAccess ~= "superadmin"
            else
                allowed = minAccess == "user"
            end
        end

        if allowed then lia.administration.groups[groupName][privName] = true end
    end

    if SERVER then
        if CAMI and CAMI.GetUsergroup and CAMI.RegisterUsergroup then
            if not CAMI.GetUsergroup(groupName) then
                CAMI.RegisterUsergroup({
                    Name = groupName,
                    Inherits = groupName == "developer" and "superadmin" or "user",
                })
            end
        end

        lia.administration.save(true)
        lia.administration.savePrivileges(groupName)
    end
end

function lia.administration.registerPrivilege(privilege)
    if not privilege or not privilege.Name then return end
    privilege.Category = privilege.Category or "Unassigned"
    lia.administration.privileges[privilege.Name] = privilege
    for groupName in pairs(lia.administration.groups) do
        local minAccess = privilege.MinAccess or "user"
        local allowed = false
        if CAMI and CAMI.UsergroupInherits then
            allowed = CAMI.UsergroupInherits(groupName, minAccess)
        else
            if groupName == "superadmin" or groupName == "developer" then
                allowed = true
            elseif groupName == "admin" then
                allowed = minAccess ~= "superadmin"
            else
                allowed = minAccess == "user"
            end
        end

        if allowed then lia.administration.groups[groupName][privilege.Name] = true end
        lia.administration.savePrivileges(groupName)
    end
end

function lia.administration.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" or groupName == "developer" then
        Error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.administration.groups[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.administration.groups[groupName] = nil
    if SERVER then
        if CAMI and CAMI.UnregisterUsergroup then CAMI.UnregisterUsergroup(groupName) end
        lia.administration.save(true)
        lia.db.delete("privileges", "usergroup = " .. lia.db.convertDataType(groupName))
    end
end

if SERVER then
    function lia.administration.updateAdminGroups(client)
        net.Start("updateAdminGroups")
        net.WriteTable(lia.administration.groups)
        if IsValid(client) then
            net.Send(client)
        else
            net.Broadcast()
        end
    end

    function lia.administration.addPermission(groupName, permission)
        if not lia.administration.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administration.DefaultGroups[groupName] then return end
        lia.administration.groups[groupName][permission] = true
        if SERVER then
            lia.administration.save(true)
            lia.administration.savePrivileges(groupName)
        end
    end

    function lia.administration.removePermission(groupName, permission)
        if not lia.administration.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administration.DefaultGroups[groupName] then return end
        lia.administration.groups[groupName][permission] = nil
        if SERVER then
            lia.administration.save(true)
            lia.administration.savePrivileges(groupName)
        end
    end

    function lia.administration.save(network)
        lia.administration.syncPrivileges()
        if network then
            net.Start("updateAdminGroups")
            net.WriteTable(lia.administration.groups)
            net.Broadcast()
        end
    end

    function lia.administration.setPlayerGroup(ply, usergroup)
        if ply:IsBot() then return end
        local old = ply:GetUserGroup()
        ply:SetUserGroup(usergroup)
        if CAMI and CAMI.SignalUserGroupChanged then CAMI.SignalUserGroupChanged(ply, old, usergroup, "Lilia") end
        lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
        if old ~= usergroup then ply:notifyLocalized("yourGroupSet", usergroup) end
    end

    function lia.administration.addBan(steamid, reason, duration)
        if not steamid then Error("[Lilia Administration] lia.administration.addBan: no steam id specified!") end
        local banStart = os.time()
        lia.db.query(Format("UPDATE lia_players SET banStart = %d, banDuration = %d, reason = '%s' WHERE steamID = %s", banStart, (duration or 0) * 60, lia.db.escape(reason or L("genericReason")), steamid))
    end

    function lia.administration.removeBan(steamid)
        if not steamid then Error("[Lilia Administration] lia.administration.removeBan: no steam id specified!") end
        lia.db.query(Format("UPDATE lia_players SET banStart = 0, banDuration = 0, reason = '' WHERE steamID = %s", steamid), function() lia.admin("Ban", "Ban removed.") end)
    end

    local function fetchBanRow(steamid)
        local query = string.format("SELECT banStart, banDuration, reason FROM lia_players WHERE steamID = %s", steamid)
        if lia.db.module == "mysqloo" and mysqloo and lia.db.getObject then
            local db = lia.db.getObject()
            if not db then return nil end
            local q = db:query(query)
            q:start()
            q:wait()
            if q:error() then return nil end
            return q:getData() and q:getData()[1] or nil
        else
            local data = lia.db.querySync(query)
            return istable(data) and data[1] or nil
        end
    end

    function lia.administration.isBanned(steamid)
        local row = fetchBanRow(steamid)
        if not row then return false end
        local start = tonumber(row.banStart) or 0
        if start <= 0 then return false end
        local duration = tonumber(row.banDuration) or 0
        return {
            reason = row.reason,
            start = start,
            duration = duration,
        }
    end

    function lia.administration.hasBanExpired(steamid)
        local ban = lia.administration.isBanned(steamid)
        if not ban then return true end
        if ban.duration == 0 then return false end
        return ban.start + ban.duration <= os.time()
    end

    hook.Add("ShutDown", "lia_SaveAdmin", function() lia.administration.save() end)
end

function lia.administration.execCommand(cmd, victim, dur, reason)
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

concommand.Add("plysetgroup", function(ply, _, args)
    if not IsValid(ply) then
        local target = lia.command.findPlayer(client, args[1])
        if IsValid(target) then
            if lia.administration.groups[args[2]] then
                lia.administration.setPlayerGroup(target, args[2])
                lia.admin("PlySetGroup", string.format("%s's usergroup set to '%s'", target:Name(), args[2]))
                target:notifyLocalized("yourGroupSet", args[2])
            else
                lia.admin("Error", "Usergroup not found.")
            end
        else
            lia.admin("Error", "Specified player not found.")
        end
    end
end)