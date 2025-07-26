lia.administration = lia.administration or {}
lia.administration.groups = lia.administration.groups or {}
lia.administration.banList = lia.administration.banList or {}
lia.administration.privileges = lia.administration.privileges or {}
local DEFAULT_GROUPS = {
    user = true,
    admin = true,
    superadmin = true,
}

function lia.administration.isDisabled()
    local sysDisabled = hook.Run("ShouldLiliaAdminLoad") == false
    local cmdDisabled = hook.Run("ShouldLiliaAdminCommandsLoad") == false
    return sysDisabled, cmdDisabled
end

function lia.administration.load()
    if lia.administration.isDisabled() then return end
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
            lia.administration.privileges[name] = priv
        end

        if camiGroups and not table.IsEmpty(camiGroups) and CAMI then
            for group in pairs(lia.administration.groups) do
                for privName, priv in pairs(lia.administration.privileges) do
                    if CAMI.UsergroupInherits and CAMI.UsergroupInherits(group, priv.MinAccess or "user") then lia.administration.groups[group][privName] = true end
                end
            end
        end

        local defaults = {"user", "admin", "superadmin"}
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
        lia.admin("Bootstrap", L("adminSystemLoaded"))
    end

    lia.db.selectOne({"data"}, "admingroups"):next(function(res)
        local data = res and util.JSONToTable(res.data or "") or {}
        continueLoad(data)
    end)
end

function lia.administration.createGroup(groupName, info)
    if lia.administration.isDisabled() then return end
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
            if groupName == "superadmin" then
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
                    Inherits = "user",
                })
            end
        end

        lia.administration.save(true)
    end
end

function lia.administration.registerPrivilege(privilege)
    if lia.administration.isDisabled() then return end
    if not privilege or not privilege.Name then return end
    lia.administration.privileges[privilege.Name] = privilege
    for groupName in pairs(lia.administration.groups) do
        local minAccess = privilege.MinAccess or "user"
        local allowed = false
        if CAMI and CAMI.UsergroupInherits then
            allowed = CAMI.UsergroupInherits(groupName, minAccess)
        else
            if groupName == "superadmin" then
                allowed = true
            elseif groupName == "admin" then
                allowed = minAccess ~= "superadmin"
            else
                allowed = minAccess == "user"
            end
        end

        if allowed then lia.administration.groups[groupName][privilege.Name] = true end
    end
end

function lia.administration.removeGroup(groupName)
    if lia.administration.isDisabled() then return end
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
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
    end
end

if SERVER then
    function lia.administration.addPermission(groupName, permission)
        if lia.administration.isDisabled() then return end
        if not lia.administration.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if DEFAULT_GROUPS[groupName] then return end
        lia.administration.groups[groupName][permission] = true
        if SERVER then lia.administration.save(true) end
    end

    function lia.administration.removePermission(groupName, permission)
        if lia.administration.isDisabled() then return end
        if not lia.administration.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if DEFAULT_GROUPS[groupName] then return end
        lia.administration.groups[groupName][permission] = nil
        if SERVER then lia.administration.save(true) end
    end

    function lia.administration.save(network)
        if lia.administration.isDisabled() then return end
        lia.db.upsert({
            data = util.TableToJSON(lia.administration.groups)
        }, "admingroups")

        if network then
            net.Start("updateAdminGroups")
            net.WriteTable(lia.administration.groups)
            net.Broadcast()
        end
    end

    function lia.administration.setPlayerGroup(ply, usergroup)
        if lia.administration.isDisabled() or ply:IsBot() then return end
        local old = ply:GetUserGroup()
        ply:SetUserGroup(usergroup)
        if CAMI and CAMI.SignalUserGroupChanged then CAMI.SignalUserGroupChanged(ply, old, usergroup, "Lilia") end
        lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
    end

    function lia.administration.addBan(steamid, reason, duration)
        if lia.administration.isDisabled() then return end
        if not steamid then Error("[Lilia Administration] lia.administration.addBan: no steam id specified!") end
        local banStart = os.time()
        lia.administration.banList[steamid] = {
            reason = reason or L("genericReason"),
            start = banStart,
            duration = (duration or 0) * 60
        }

        lia.db.query(Format(
            "UPDATE lia_players SET banStart = %d, banDuration = %d, reason = '%s' WHERE steamID = %s",
            banStart,
            (duration or 0) * 60,
            lia.db.escape(reason or L("genericReason")),
            steamid
        ))
    end

    function lia.administration.removeBan(steamid)
        if lia.administration.isDisabled() then return end
        if not steamid then Error("[Lilia Administration] lia.administration.removeBan: no steam id specified!") end
        lia.administration.banList[steamid] = nil
        lia.db.query(Format(
            "UPDATE lia_players SET banStart = 0, banDuration = 0, reason = '' WHERE steamID = %s",
            steamid
        ), function() lia.admin("Ban", "Ban removed.") end)
    end

    function lia.administration.isBanned(steamid)
        if lia.administration.isDisabled() then return false end
        return lia.administration.banList[steamid] or false
    end

    function lia.administration.hasBanExpired(steamid)
        if lia.administration.isDisabled() then return true end
        local ban = lia.administration.banList[steamid]
        if not ban then return true end
        if ban.duration == 0 then return false end
        return ban.start + ban.duration <= os.time()
    end

    hook.Add("ShutDown", "lia_SaveAdmin", function()
        if lia.administration.isDisabled() then return end
        lia.administration.save()
    end)
end

local function quote(str)
    return string.format("'%s'", tostring(str))
end

function lia.administration.execCommand(cmd, victim, dur, reason)
    if hook.Run("RunAdminSystemCommand") == true then return end
    local id = IsValid(victim) and victim:SteamID() or tostring(victim)
    if cmd == "kick" then
        RunConsoleCommand("say", "/plykick " .. quote(id) .. (reason and " " .. quote(reason) or ""))
        return true
    elseif cmd == "ban" then
        RunConsoleCommand("say", "/plyban " .. quote(id) .. " " .. tostring(dur or 0) .. (reason and " " .. quote(reason) or ""))
        return true
    elseif cmd == "unban" then
        RunConsoleCommand("say", "/plyunban " .. quote(id))
        return true
    elseif cmd == "mute" then
        RunConsoleCommand("say", "/plymute " .. quote(id) .. " " .. tostring(dur or 0) .. (reason and " " .. quote(reason) or ""))
        return true
    elseif cmd == "unmute" then
        RunConsoleCommand("say", "/plyunmute " .. quote(id))
        return true
    elseif cmd == "gag" then
        RunConsoleCommand("say", "/plygag " .. quote(id) .. " " .. tostring(dur or 0) .. (reason and " " .. quote(reason) or ""))
        return true
    elseif cmd == "ungag" then
        RunConsoleCommand("say", "/plyungag " .. quote(id))
        return true
    elseif cmd == "freeze" then
        RunConsoleCommand("say", "/plyfreeze " .. quote(id) .. " " .. tostring(dur or 0))
        return true
    elseif cmd == "unfreeze" then
        RunConsoleCommand("say", "/plyunfreeze " .. quote(id))
        return true
    elseif cmd == "slay" then
        RunConsoleCommand("say", "/plyslay " .. quote(id))
        return true
    elseif cmd == "bring" then
        RunConsoleCommand("say", "/plybring " .. quote(id))
        return true
    elseif cmd == "goto" then
        RunConsoleCommand("say", "/plygoto " .. quote(id))
        return true
    elseif cmd == "return" then
        RunConsoleCommand("say", "/plyreturn " .. quote(id))
        return true
    elseif cmd == "jail" then
        RunConsoleCommand("say", "/plyjail " .. quote(id) .. " " .. tostring(dur or 0))
        return true
    elseif cmd == "unjail" then
        RunConsoleCommand("say", "/plyunjail " .. quote(id))
        return true
    elseif cmd == "cloak" then
        RunConsoleCommand("say", "/plycloak " .. quote(id))
        return true
    elseif cmd == "uncloak" then
        RunConsoleCommand("say", "/plyuncloak " .. quote(id))
        return true
    elseif cmd == "god" then
        RunConsoleCommand("say", "/plygod " .. quote(id))
        return true
    elseif cmd == "ungod" then
        RunConsoleCommand("say", "/plyungod " .. quote(id))
        return true
    elseif cmd == "ignite" then
        RunConsoleCommand("say", "/plyignite " .. quote(id) .. " " .. tostring(dur or 0))
        return true
    elseif cmd == "extinguish" or cmd == "unignite" then
        RunConsoleCommand("say", "/plyextinguish " .. quote(id))
        return true
    elseif cmd == "strip" then
        RunConsoleCommand("say", "/plystrip " .. quote(id))
        return true
    elseif cmd == "respawn" then
        RunConsoleCommand("say", "/plyrespawn " .. quote(id))
        return true
    elseif cmd == "blind" then
        RunConsoleCommand("say", "/plyblind " .. quote(id))
        return true
    elseif cmd == "unblind" then
        RunConsoleCommand("say", "/plyunblind " .. quote(id))
        return true
    end
end

hook.Add("PlayerAuthed", "lia_SetUserGroup", function(ply, steamID)
    if lia.administration.isDisabled() or ply:IsBot() then return end
    local steam64 = util.SteamIDTo64(steamID)
    if CAMI and CAMI.GetUsergroup and CAMI.GetUsergroup(ply:GetUserGroup()) and ply:GetUserGroup() ~= "user" then
        lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(ply:GetUserGroup()), steam64))
        return
    end

    lia.db.query(Format("SELECT userGroup FROM lia_players WHERE steamID = %s", steam64), function(data)
        local group = istable(data) and data[1] and data[1].userGroup
        if not group or group == "" then
            group = "user"
            lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(group), steam64))
        end

        ply:SetUserGroup(group)
    end)
end)

hook.Add("OnDatabaseLoaded", "lia_LoadBans", function()
    if lia.administration.isDisabled() then return end
    lia.db.query("SELECT steamID, banStart, banDuration, reason FROM lia_players WHERE banStart > 0", function(data)
        if istable(data) then
            local bans = {}
            for _, ban in pairs(data) do
                bans[ban.steamID] = {
                    reason = ban.reason,
                    start = ban.banStart,
                    duration = ban.banDuration
                }
            end

            lia.administration.banList = bans
        end
    end)
end)

concommand.Add("plysetgroup", function(ply, _, args)
    if lia.administration.isDisabled() then return end
    if not IsValid(ply) then
        local target = lia.command.findPlayer(client, args[1])
        if IsValid(target) then
            if lia.administration.groups[args[2]] then
                lia.administration.setPlayerGroup(target, args[2])
            else
                lia.admin("Error", "Usergroup not found.")
            end
        else
            lia.admin("Error", "Specified player not found.")
        end
    end
end)

if SERVER then
    hook.Add("PlayerInitialSpawn", "liaAdminSendGroups", function(client)
        if lia.administration.isDisabled() then return end
        net.Start("updateAdminGroups")
        net.WriteTable(lia.administration.groups)
        net.Send(client)
    end)

    hook.Add("OnReloaded", "liaAdminSendGroups", function(client)
        if lia.administration.isDisabled() then return end
        net.Start("updateAdminGroups")
        net.WriteTable(lia.administration.groups)
        net.Send(client)
    end)
else
    net.Receive("updateAdminGroups", function()
        local data = net.ReadTable() or {}
        lia.administration.groups = data
    end)
end