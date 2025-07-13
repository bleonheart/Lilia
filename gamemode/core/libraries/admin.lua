lia.admin = lia.admin or {}
lia.admin.bans = lia.admin.bans or {}
lia.admin.bans.list = lia.admin.bans.list or {}
lia.admin.permissions = lia.admin.permissions or {}
function lia.admin.save(network)
    lia.data.set("admin_permissions", lia.admin.permissions, true, true)
    if network then
        net.Start("lilia_updateAdminPermissions")
        net.WriteTable(lia.admin.permissions)
        net.Broadcast()
    end
end

function lia.admin.load()
    lia.admin.permissions = lia.data.get("admin_permissions", {}, true, true)
end

function lia.admin.setPlayerGroup(ply, usergroup)
    ply:SetUserGroup(usergroup)
    lia.db.query(Format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
end

function lia.admin.createGroup(groupName, info)
    if lia.admin.permissions[groupName] then
        Error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.admin.permissions[groupName] = info or {
        position = table.Count(lia.admin.permissions),
        admin = false,
        superadmin = false,
        permissions = {},
    }

    if SERVER then lia.admin.save(true) end
end

function lia.admin.removeGroup(groupName)
    if not lia.admin.permissions[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.admin.permissions[groupName] = nil
    if SERVER then lia.admin.save(true) end
end

function lia.admin.addPermission(groupName, permission)
    if not lia.admin.permissions[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.admin.permissions[groupName]["permissions"][permission] = true
    if SERVER then lia.admin.save(true) end
end

function lia.admin.removePermission(groupName, permission)
    if not lia.admin.permissions[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.admin.permissions[groupName]["permissions"][permission] = nil
    if SERVER then lia.admin.save(true) end
end

function lia.admin.setGroupPosition(groupName, position)
    if not lia.admin.permissions[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    local group = lia.admin.permissions[groupName]
    local oldPos = group.position
    for name, group in next, lia.admin.permissions do
        if name == groupName then continue end
        if position - oldPos > 0 then
            if group.position > oldPos and group.position <= position then group.position = group.position - 1 end
        elseif position - oldPos < 0 then
            if group.position < oldPos and group.position >= position then group.position = group.position + 1 end
        end
    end

    group.position = position
    if SERVER then lia.admin.save(true) end
end

if SERVER then
    function lia.admin.bans.add(steamid, reason, duration)
        local genericReason = L("genericReason")
        if not steamid then Error("[Lilia Administration] lia.admin.bans.add: no steam id specified!") end
        local banStart = os.time()
        lia.admin.bans.list[steamid] = {
            reason = reason or genericReason,
            start = banStart,
            duration = duration * 60 or 0,
        }

        lia.db.insertTable({
            _steamID = "\"" .. steamid .. "\"",
            _banStart = banStart,
            _banDuration = duration * 60 or 0,
            _reason = reason or genericReason,
        }, nil, "bans")
    end

    function lia.admin.bans.remove(steamid)
        if not steamid then Error("[Lilia Administration] lia.admin.bans.remove: no steam id specified!") end
        lia.admin.bans.list[steamid] = nil
        lia.db.query(Format("DELETE FROM lia_bans WHERE _steamID = '%s'", lia.db.escape(steamid)), function(data) MsgC(Color(0, 200, 0), "[Lilia Administration] Ban removed.\n") end)
    end

    function lia.admin.bans.isBanned(steamid)
        return lia.admin.bans.list[steamid] or false
    end

    function lia.admin.bans.hasExpired(steamid)
        local ban = lia.admin.bans.list[steamid]
        if not ban then return true end
        if ban.duration == 0 then return false end
        return ban.start + ban.duration <= os.time()
    end
end

hook.Add("InitPostEntity", "lia_LoadAdmin", function() lia.admin.load() end)
hook.Add("ShutDown", "lia_SaveAdmin", function() lia.admin.save() end)
hook.Add("PlayerAuthed", "lia_SetUserGroup", function(ply, steamID, uid)
    local steam64 = util.SteamIDTo64(steamID)
    lia.db.query(string.format("SELECT _userGroup FROM lia_players WHERE _steamID = %s", steam64), function(data) if istable(data) and data[1] then ply:SetUserGroup(data[1]._userGroup) end end)
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

            lia.admin.bans.list = bans
        end
    end)
end)

concommand.Add("plysetgroup", function(ply, cmd, args)
    if not IsValid(ply) then
        local target = lia.util.findPlayer(args[1])
        if IsValid(target) then
            if lia.admin.permissions[args[2]] then
                lia.admin.setPlayerGroup(target, args[2])
            else
                MsgC(Color(200, 20, 20), "[Lilia Administration] Error: usergroup not found.\n")
            end
        else
            MsgC(Color(200, 20, 20), "[Lilia Administration] Error: specified player not found.\n")
        end
    end
end)