lia.admin = lia.admin or {}
lia.admin.bans = lia.admin.bans or {}
lia.admin.groups = lia.admin.groups or {}
lia.admin.banList = lia.admin.banList or {}
lia.admin.privileges = lia.admin.privileges or {}
local DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
}

local DefaultPrivileges = {
    {
        Name = "Access Logs Tab",
        MinAccess = "superadmin",
        Category = "Logger"
    },
    {
        Name = "Can See Logs",
        MinAccess = "superadmin",
        Category = "Logger"
    },
    {
        Name = "Access Character List Tab",
        MinAccess = "admin",
        Category = "Permissions"
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
        Name = "Spawn Permissions - Can Spawn Ragdolls",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn SWEPs",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn Effects",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn Props",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn Blacklisted Props",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn NPCs",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - No Car Spawn Delay",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - No Spawn Delay",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn Cars",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn Blacklisted Cars",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Spawn Permissions - Can Spawn SENTs",
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
        Name = "Toggle Permakill",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Unban Offline",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Ban Offline",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Play Sounds",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Return Players",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Force Fallover",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Force GetUp",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Toggle Character Lock",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Manage Flags",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Check Inventories",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Manage Items",
        MinAccess = "superadmin",
        Category = "Permissions"
    },
    {
        Name = "Toggle Voice Ban Character",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Clean Entities",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Manage Characters",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Kick Characters",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Get Character Info",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Manage Character Stats",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Manage Character Information",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Manage Bodygroups",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Bot Say",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Force Say",
        MinAccess = "admin",
        Category = "Permissions"
    },
    {
        Name = "Access Warnings Tab",
        MinAccess = "superadmin",
        Category = "Configuration Menu"
    },
    {
        Name = "Issue Warnings",
        MinAccess = "admin",
        Category = "Configuration Menu"
    },
    {
        Name = "View Player Warnings",
        MinAccess = "admin",
        Category = "Configuration Menu"
    },
    {
        Name = "Use Admin Stick",
        MinAccess = "superadmin",
        Category = "Admin Stick"
    },
    {
        Name = "Access Tickets Tab",
        MinAccess = "superadmin",
        Category = "Tickets"
    },
    {
        Name = "Always See Tickets",
        MinAccess = "superadmin",
        Category = "Tickets"
    },
    {
        Name = "View Claims",
        MinAccess = "admin",
        Category = "Tickets"
    },
    {
        Name = "Can Use Item Spawner",
        MinAccess = "admin",
        Category = "Item Spawner"
    },
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
        Name = "Admin Tab - Config",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage UserGroups",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access Usergroups Tab",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access Players Tab",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Access DB Browser Tab",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "View DB Tables",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage SitRooms",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "List Characters",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Kick Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Ban Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Kill Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Set Player Group",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Unban Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Freeze Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Unfreeze Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Slay Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Respawn Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Blind Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Unblind Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Blind Fade Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Blind Fade All",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Gag Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Ungag Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Mute Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Unmute Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Bring Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Goto Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Return Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Jail Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Unjail Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Cloak Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Uncloak Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "God Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Ungod Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Ignite Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Extinguish Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Strip Player",
        MinAccess = "admin",
        Category = "Administration Utilities"
    },
    {
        Name = "Manage Attributes",
        MinAccess = "admin",
        Category = "Attributes"
    },
    {
        Name = "Access Factions Tab",
        MinAccess = "superadmin",
        Category = "Teams"
    },
    {
        Name = "Manage Transfers",
        MinAccess = "admin",
        Category = "Teams"
    },
    {
        Name = "Manage Whitelists",
        MinAccess = "admin",
        Category = "Teams"
    },
    {
        Name = "Manage Classes",
        MinAccess = "admin",
        Category = "Teams"
    },
    {
        Name = "Can See Alting Notifications",
        MinAccess = "admin",
        Category = "Protection"
    },
    {
        Name = "Toggle Cheater Status",
        MinAccess = "admin",
        Category = "Protection"
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
        Name = "Ban OOC",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Unban OOC",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Block OOC",
        MinAccess = "superadmin",
        Category = "Chatbox"
    },
    {
        Name = "Clear Chat",
        MinAccess = "admin",
        Category = "Chatbox"
    },
    {
        Name = "Can Edit Vendors",
        MinAccess = "admin",
        Category = "Vendors"
    },
    {
        Name = "Manage Vendors",
        MinAccess = "superadmin",
        Category = "Vendors"
    },
    {
        Name = "Can Spawn Storage",
        MinAccess = "superadmin",
        Category = "Storage"
    },
    {
        Name = "Lock Storage",
        MinAccess = "admin",
        Category = "Storage"
    },
    {
        Name = "Manage Recognition",
        MinAccess = "admin",
        Category = "Recognition"
    },
    {
        Name = "Staff Permission — Access Entity List",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Staff Permission — Teleport to Entity",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Staff Permission — Teleport to Entity (Entity Tab)",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Staff Permission — View Entity (Entity Tab)",
        MinAccess = "admin",
        Category = "F1 Menu"
    },
    {
        Name = "Staff Permission — Access Module List",
        MinAccess = "user",
        Category = "F1 Menu"
    },
    {
        Name = "Manage Doors",
        MinAccess = "admin",
        Category = "Doors"
    },
    {
        Name = "Manage Spawns",
        MinAccess = "admin",
        Category = "Spawns"
    },
    {
        Name = "Return Items",
        MinAccess = "superadmin",
        Category = "Spawns"
    },
}

local function registerDefaultPrivileges()
    for _, priv in ipairs(DefaultPrivileges) do
        lia.admin.registerPrivilege(priv)
    end
end

function lia.administration(section, msg)
    MsgC(Color(83, 143, 239), "[Lilia] ", "[Administration] ")
    MsgC(Color(0, 255, 0), "[" .. section .. "] ")
    MsgC(Color(255, 255, 255), tostring(msg), "\n")
end

function lia.admin.load()
    local camiGroups = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups()
    local function continueLoad(data)
        if camiGroups and not table.IsEmpty(camiGroups) then
            lia.admin.groups = {}
            for name in pairs(camiGroups) do
                lia.admin.groups[name] = {}
            end
        else
            lia.admin.groups = data or {}
        end

        for name, priv in pairs(CAMI and CAMI.GetPrivileges and CAMI.GetPrivileges() or {}) do
            priv.Category = priv.Category or "Unassigned"
            lia.admin.privileges[name] = priv
        end

        registerDefaultPrivileges()
        if camiGroups and not table.IsEmpty(camiGroups) and CAMI then
            for group in pairs(lia.admin.groups) do
                for privName, priv in pairs(lia.admin.privileges) do
                    if CAMI.UsergroupInherits and CAMI.UsergroupInherits(group, priv.MinAccess or "user") then lia.admin.groups[group][privName] = true end
                end
            end
        end

        local defaults = {"user", "admin", "superadmin"}
        local created = false
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

        if created then lia.admin.save(true) end
        lia.administration("Bootstrap", L("adminSystemLoaded"))
    end

    lia.db.selectOne({"_data"}, "admingroups"):next(function(res)
        local data = res and util.JSONToTable(res._data or "") or {}
        continueLoad(data)
    end)
end

function lia.admin.createGroup(groupName, info, inherit)
    if lia.admin.groups[groupName] then
        Error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.admin.groups[groupName] = info or {}
    if SERVER and CAMI and CAMI.GetUsergroup and CAMI.RegisterUsergroup then
        if not CAMI.GetUsergroup(groupName) then
            CAMI.RegisterUsergroup({
                Name = groupName,
                Inherits = inherit or "user",
            })
        end
    end

    for privName, priv in pairs(lia.admin.privileges) do
        local minAccess = priv.MinAccess or "user"
        local allowed
        if CAMI and CAMI.UsergroupInherits then
            allowed = CAMI.UsergroupInherits(groupName, minAccess)
        else
            local check = inherit or groupName
            if check == "superadmin" then
                allowed = true
            elseif check == "admin" then
                allowed = minAccess ~= "superadmin"
            else
                allowed = minAccess == "user"
            end
        end

        if allowed then lia.admin.groups[groupName][privName] = true end
    end

    if SERVER then lia.admin.save(true) end
end

function lia.admin.registerPrivilege(privilege)
    if not privilege or not privilege.Name then return end
    privilege.Category = privilege.Category or "Unassigned"
    lia.admin.privileges[privilege.Name] = privilege
    for groupName in pairs(lia.admin.groups) do
        local minAccess = privilege.MinAccess or "user"
        local allowed
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

        if allowed then lia.admin.groups[groupName][privilege.Name] = true end
    end
end

function lia.admin.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
        Error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.admin.groups[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.admin.groups[groupName] = nil
    if SERVER then
        if CAMI and CAMI.UnregisterUsergroup then CAMI.UnregisterUsergroup(groupName) end
        lia.admin.save(true)
    end
end

if SERVER then
    function lia.admin.addPermission(groupName, permission)
        if not lia.admin.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if DefaultGroups[groupName] then return end
        lia.admin.groups[groupName][permission] = true
        if SERVER then lia.admin.save(true) end
    end

    function lia.admin.removePermission(groupName, permission)
        if not lia.admin.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if DefaultGroups[groupName] then return end
        lia.admin.groups[groupName][permission] = nil
        if SERVER then lia.admin.save(true) end
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
        if ply:IsBot() then return end
        local old = ply:GetUserGroup()
        ply:SetUserGroup(usergroup)
        if CAMI and CAMI.SignalUserGroupChanged then CAMI.SignalUserGroupChanged(ply, old, usergroup, "Lilia") end
        lia.db.query(Format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
    end

    function lia.admin.addBan(steamid, reason, duration)
        if not steamid then Error("[Lilia Administration] lia.admin.addBan: no steam id specified!") end
        local banStart = os.time()
        lia.admin.banList[steamid] = {
            reason = reason or L("genericReason"),
            start = banStart,
            duration = (duration or 0) * 60
        }

        lia.db.insertTable({
            _steamID = "\"" .. steamid .. "\"",
            _banStart = banStart,
            _banDuration = (duration or 0) * 60,
            _reason = reason or L("genericReason")
        }, nil, "bans")
    end

    function lia.admin.removeBan(steamid)
        if not steamid then Error("[Lilia Administration] lia.admin.removeBan: no steam id specified!") end
        lia.admin.banList[steamid] = nil
        lia.db.query(Format("DELETE FROM lia_bans WHERE _steamID = '%s'", lia.db.escape(steamid)), function() lia.administration("Ban", L("banRemoved")) end)
    end

    function lia.admin.isBanned(steamid)
        return lia.admin.banList[steamid] or false
    end

    function lia.admin.hasBanExpired(steamid)
        local ban = lia.admin.banList[steamid]
        if not ban then return true end
        if ban.duration == 0 then return false end
        return ban.start + ban.duration <= os.time()
    end

    hook.Add("ShutDown", "lia_SaveAdmin", function() lia.admin.save() end)
end

local function quote(str)
    return string.format("'%s'", tostring(str))
end

function lia.admin.execCommand(cmd, victim, dur, reason)
    if hook.Run("RunAdminSystemCommand") == true then return end
    print("xd")
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
    if ply:IsBot() then return end
    local steam64 = util.SteamIDTo64(steamID)
    if CAMI and CAMI.GetUsergroup and CAMI.GetUsergroup(ply:GetUserGroup()) and ply:GetUserGroup() ~= "user" then
        lia.db.query(Format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(ply:GetUserGroup()), steam64))
        return
    end

    lia.db.query(Format("SELECT _userGroup FROM lia_players WHERE _steamID = %s", steam64), function(data)
        local group = istable(data) and data[1] and data[1]._userGroup
        if not group or group == "" then
            group = "user"
            lia.db.query(Format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(group), steam64))
        end

        ply:SetUserGroup(group)
    end)
end)

hook.Add("OnDatabaseLoaded", "lia_LoadBans", function()
    lia.db.query("SELECT * FROM lia_bans", function(data)
        if istable(data) then
            local bans = {}
            for _, ban in pairs(data) do
                bans[ban._steamID] = {
                    reason = ban._reason,
                    start = ban._banStart,
                    duration = ban._banDuration
                }
            end

            lia.admin.banList = bans
        end
    end)
end)

concommand.Add("plysetgroup", function(ply, _, args)
    if not IsValid(ply) then
        local target = lia.command.findPlayer(client, args[1])
        if IsValid(target) then
            if lia.admin.groups[args[2]] then
                lia.admin.setPlayerGroup(target, args[2])
                lia.administration("Information", L("setPlayerGroupTo", args[2]))
            else
                lia.administration("Error", L("usergroupNotFound"))
            end
        else
            lia.administration("Error", L("specifiedPlayerNotFound"))
        end
    end
end)

if CAMI.ULX_TOKEN and CAMI.ULX_TOKEN == "ULX" then
    hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
        lia.admin.groups[g.Name] = nil
        if SERVER then
            dropCAMIGroup(g.Name)
            lia.admin.save(true)
        end
    end)

    hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = {
            Name = pv.Name,
            MinAccess = pv.MinAccess or "user",
            Category = pv.Category or "Misc"
        }

        for g in pairs(lia.admin.groups) do
            if CAMI.UsergroupInherits(g, pv.MinAccess or "user") then lia.admin.groups[g][pv.Name] = true end
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.OnPrivilegeUnregistered", "liaSyncAdminPrivilegeRemove", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = nil
        for _, p in pairs(lia.admin.groups) do
            p[pv.Name] = nil
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, _, newGroup)
        if not IsValid(ply) or not SERVER then return end
        lia.db.query(string.format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(newGroup), ply:SteamID64()))
    end)
else
    hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
        lia.admin.groups[g.Name] = nil
        if SERVER then
            dropCAMIGroup(g.Name)
            lia.admin.save(true)
        end
    end)

    hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = {
            Name = pv.Name,
            MinAccess = pv.MinAccess or "user",
            Category = pv.Category or "Misc"
        }

        for g in pairs(lia.admin.groups) do
            if CAMI.UsergroupInherits(g, pv.MinAccess or "user") then lia.admin.groups[g][pv.Name] = true end
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.OnPrivilegeUnregistered", "liaSyncAdminPrivilegeRemove", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = nil
        for _, p in pairs(lia.admin.groups) do
            p[pv.Name] = nil
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, _, newGroup)
        if not IsValid(ply) or not SERVER then return end
        lia.db.query(string.format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(newGroup), ply:SteamID64()))
    end)
end

if SERVER then
    hook.Add("OnReloaded", "liaAdminSendGroups", function()
        net.Start("updateAdminGroups")
        net.WriteTable(lia.admin.groups)
        net.Broadcast()
    end)
else
    net.Receive("updateAdminGroups", function()
        local data = net.ReadTable() or {}
        lia.admin.groups = data
    end)
end