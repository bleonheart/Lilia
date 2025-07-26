lia.admin = lia.admin or {}
lia.admin.groups = lia.admin.groups or {}
lia.admin.banList = lia.admin.banList or {}
lia.admin.privileges = lia.admin.privileges or {}
lia.admin.steamAdmins = lia.admin.steamAdmins or {}
if SERVER then
    function lia.admin.addStaffAction(admin, action, victim, message, charID)
        local targetName
        local targetSteam
        if IsValid(victim) and victim:IsPlayer() then
            targetName = victim:Name()
            targetSteam = victim:SteamID()
        elseif isstring(victim) then
            targetSteam = victim
            local ply = player.GetBySteamID(victim) or player.GetBySteamID64(victim)
            if IsValid(ply) then
                targetName = ply:Name()
            else
                targetName = victim
            end
        else
            targetName = tostring(victim)
            targetSteam = tostring(victim)
        end

        lia.db.insertTable({
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
            targetName = targetName,
            targetSteam = targetSteam,
            adminSteam = IsValid(admin) and admin:SteamID() or "Console",
            adminName = IsValid(admin) and admin:Name() or "Console",
            adminGroup = IsValid(admin) and admin:GetUserGroup() or "Console",
            action = action,
            message = message,
            charID = charID
        }, nil, "staffactions")
    end

end

local DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true,
    developer = true,
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
        Name = "Spawn Permissions - Can Spawn Blacklisted Entities",
        MinAccess = "superadmin",
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
        Name = "Manage Entity Blacklist",
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
        Name = "Access Staff Actions Tab",
        MinAccess = "superadmin",
        Category = "Administration Utilities"
    },
    {
        Name = "See Decoded Tables",
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
        Name = "View IP Chat Attempts",
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

local function buildDefaultPermissions(group, inherit)
    local perms = {
        _inherit = inherit or group
    }

    for name, priv in pairs(lia.admin.privileges) do
        local minAccess = priv.MinAccess or "user"
        local allowed
        if CAMI and CAMI.UsergroupInherits then
            allowed = CAMI.UsergroupInherits(inherit or group, minAccess)
        else
            local check = inherit or group
            if check == "superadmin" then
                allowed = true
            elseif check == "admin" then
                allowed = minAccess ~= "superadmin"
            else
                allowed = minAccess == "user"
            end
        end

        if allowed then perms[name] = true end
    end
    return perms
end

function lia.admin.load()
    local camiGroups = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups()
    local function continueLoad(groups, privs)
        if camiGroups and not table.IsEmpty(camiGroups) then
            lia.admin.groups = {}
            for name, data in pairs(camiGroups) do
                lia.admin.groups[name] = {
                    _inherit = data.Inherits or "user"
                }
            end
        else
            lia.admin.groups = groups or {}
            for gName, info in pairs(lia.admin.groups) do
                info._inherit = info._inherit or gName
            end
        end

        lia.admin.privileges = privs or {}
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

        local defaults = {
            user = "user",
            admin = "admin",
            superadmin = "superadmin",
            developer = "superadmin"
        }

        for name, inherit in pairs(defaults) do
            lia.admin.groups[name] = buildDefaultPermissions(name, inherit)
            lia.admin.groups[name]._inherit = inherit
            if CAMI and CAMI.GetUsergroup and CAMI.RegisterUsergroup and CAMI.UnregisterUsergroup then
                if CAMI.GetUsergroup(name) then CAMI.UnregisterUsergroup(name) end
                CAMI.RegisterUsergroup({
                    Name = name,
                    Inherits = inherit
                })
            end
        end

        lia.admin.save(true)
        lia.administration("Bootstrap", L("adminSystemLoaded"))
    end

    lia.db.tableExists("usergroups"):next(function(exists)
        if exists then
            lia.db.select({"name", "data"}, "usergroups"):next(function(res)
                local groups = {}
                res = res.results or res
                for _, row in ipairs(res or {}) do
                    groups[row.name] = util.JSONToTable(row.data or "") or {}
                end

                lia.db.tableExists("privileges"):next(function(prExists)
                    if prExists then
                        lia.db.select({"name", "minAccess", "category"}, "privileges"):next(function(resP)
                            local privs = {}
                            resP = resP.results or resP
                            for _, row in ipairs(resP or {}) do
                                privs[row.name] = {
                                    Name = row.name,
                                    MinAccess = row.minAccess,
                                    Category = row.category
                                }
                            end

                            continueLoad(groups, privs)
                        end)
                    else
                        continueLoad(groups)
                    end
                end)
            end)
        else
            lia.db.tableExists("admingroups"):next(function(admExists)
                if admExists then
                    lia.db.selectOne({"data"}, "admingroups"):next(function(res)
                        local groups = res and util.JSONToTable(res.data or "") or {}
                        local rows = {}
                        for name, dat in pairs(groups) do
                            rows[#rows + 1] = {
                                name = name,
                                data = util.TableToJSON(dat)
                            }
                        end

                        if #rows > 0 then lia.db.bulkUpsert("usergroups", rows) end
                        continueLoad(groups)
                    end)
                else
                    continueLoad({})
                end
            end)
        end
    end)
end

function lia.admin.updateAdminGroups()
    net.Start("updateAdminGroups")
    net.WriteTable(lia.admin.groups)
    net.Broadcast()
end

function lia.admin.createGroup(groupName, info, inherit)
    if lia.admin.groups[groupName] then
        Error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.admin.groups[groupName] = info or {}
    lia.admin.groups[groupName]._inherit = inherit or "user"
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
            local check = lia.admin.groups[groupName]._inherit or inherit or groupName
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

function lia.admin.registerRank(name, inherit)
    if not isstring(name) then return end
    local inheritGroup = inherit or "user"
    if inherit and not lia.admin.groups[inherit] then
        lia.error("Invalid inheritance '" .. tostring(inherit) .. "' for rank '" .. name .. "'. Defaulting to 'user'.")
        inheritGroup = "user"
    end

    lia.admin.createGroup(name, nil, inheritGroup)
end

function lia.admin.registerPrivilege(privilege)
    if not privilege or not privilege.Name then return end
    privilege.Category = privilege.Category or "Unassigned"
    lia.admin.privileges[privilege.Name] = privilege
    for groupName, info in pairs(lia.admin.groups) do
        local minAccess = privilege.MinAccess or "user"
        local allowed
        if CAMI and CAMI.UsergroupInherits then
            allowed = CAMI.UsergroupInherits(groupName, minAccess)
        else
            local check = info._inherit or groupName
            if check == "superadmin" then
                allowed = true
            elseif check == "admin" then
                allowed = minAccess ~= "superadmin"
            else
                allowed = minAccess == "user"
            end
        end

        if allowed then lia.admin.groups[groupName][privilege.Name] = true end
    end

    if SERVER then lia.admin.save(true) end
end

function lia.admin.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" or groupName == "developer" then
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
        local groupRows = {}
        for name, data in pairs(lia.admin.groups) do
            groupRows[#groupRows + 1] = {
                name = name,
                data = util.TableToJSON(data)
            }
        end

        lia.db.bulkUpsert("usergroups", groupRows)
        local privRows = {}
        for name, priv in pairs(lia.admin.privileges) do
            privRows[#privRows + 1] = {
                name = name,
                minAccess = priv.MinAccess or "user",
                category = priv.Category or "Unassigned"
            }
        end

        lia.db.bulkUpsert("privileges", privRows)
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
        lia.db.query(Format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
    end

    function lia.admin.registerAdminSteamID(steamid, group)
        local steam64 = util.SteamIDTo64(steamid) ~= "0" and util.SteamIDTo64(steamid) or tostring(steamid)
        local usergroup = group or "superadmin"
        if not lia.admin.groups[usergroup] then
            lia.error("Invalid admin group '" .. tostring(group) .. "' for SteamID " .. tostring(steamid) .. ". Defaulting to 'superadmin'.")
            usergroup = "superadmin"
        end

        lia.db.insertOrIgnore({
            steamID = steam64,
            userGroup = usergroup
        }, "admins"):next(function()
            lia.db.updateTable({userGroup = usergroup}, nil, "admins", "steamID = " .. lia.db.convertDataType(steam64))
        end)
    end

    function lia.admin.addBan(steamid, reason, duration)
        if not steamid then Error("[Lilia Administration] lia.admin.addBan: no steam id specified!") end
        local banStart = os.time()
        lia.admin.banList[steamid] = {
            reason = reason or L("genericReason"),
            start = banStart,
            duration = (duration or 0) * 60
        }

        lia.db.updateTable({
            banStart = banStart,
            banDuration = (duration or 0) * 60,
            banReason = reason or L("genericReason")
        }, nil, "players", "steamID = " .. steamid)
    end

    function lia.admin.removeBan(steamid)
        if not steamid then Error("[Lilia Administration] lia.admin.removeBan: no steam id specified!") end
        lia.admin.banList[steamid] = nil
        lia.db.updateTable({
            banStart = nil,
            banDuration = 0,
            banReason = nil
        }, function() lia.administration("Ban", L("banRemoved")) end, "players", "steamID = " .. steamid)
    end

    function lia.admin.isBanned(steamid)
        if not steamid then return false end
        local result = sql.Query("SELECT banReason, banStart, banDuration FROM lia_players WHERE steamID = " .. steamid .. " AND banStart IS NOT NULL LIMIT 1")
        if istable(result) and result[1] then
            local row = result[1]
            return {
                reason = row.banReason,
                start = tonumber(row.banStart),
                duration = tonumber(row.banDuration)
            }
        end
        return false
    end

    function lia.admin.hasBanExpired(steamid)
        local ban = lia.admin.isBanned(steamid)
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
    local id = IsValid(victim) and victim:SteamID() or tostring(victim)
    -- Command logging is now handled within each command's callback

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

local function dropCAMIGroup(n)
    if not (CAMI and CAMI.GetUsergroups and CAMI.UnregisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if g[n] then CAMI.UnregisterUsergroup(n) end
end

hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
    lia.admin.groups[g.Name] = nil
    if SERVER then
        dropCAMIGroup(g.Name)
        lia.admin.save(true)
    end
end)

hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
    if not pv or not pv.Name then return end
    local name, minAccess, category = pv.Name, pv.MinAccess or "user", pv.Category or "Misc"
    lia.admin.privileges[name] = {
        Name = name,
        MinAccess = minAccess,
        Category = category
    }

    for groupName, groupData in pairs(lia.admin.groups) do
        if CAMI.UsergroupInherits(groupName, minAccess) then groupData[name] = true end
    end

    if SERVER then lia.admin.save(true) end
end)

hook.Add("CAMI.OnPrivilegeUnregistered", "liaSyncAdminPrivilegeRemove", function(pv)
    if not pv or not pv.Name then return end
    lia.admin.privileges[pv.Name] = nil
    for _, groupData in pairs(lia.admin.groups) do
        groupData[pv.Name] = nil
    end

    if SERVER then lia.admin.save(true) end
end)

hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, _, newGroup) if SERVER and IsValid(ply) then lia.db.query(string.format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(newGroup), ply:SteamID64())) end end)