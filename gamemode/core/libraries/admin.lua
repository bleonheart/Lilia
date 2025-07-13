lia.admin = lia.admin or {}
lia.admin.bans = lia.admin.bans or {}
lia.admin.groups = lia.admin.groups or {}
function lia.admin.load()
    lia.admin.groups = lia.data.get("admin_groups", {}, true, true)
end

function lia.admin.createGroup(groupName, info)
    if lia.admin.groups[groupName] then
        Error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.admin.groups[groupName] = info or {}
    if SERVER then lia.admin.save(true) end
end

function lia.admin.removeGroup(groupName)
    if not lia.admin.groups[groupName] then
        Error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.admin.groups[groupName] = nil
    if SERVER then lia.admin.save(true) end
end

if SERVER then
    function lia.admin.addPermission(groupName, permission)
        if not lia.admin.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        lia.admin.groups[groupName][permission] = true
        if SERVER then lia.admin.save(true) end
    end

    function lia.admin.removePermission(groupName, permission)
        if not lia.admin.groups[groupName] then
            Error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        lia.admin.groups[groupName][permission] = nil
        if SERVER then lia.admin.save(true) end
    end

    function lia.admin.save(network)
        lia.data.set("admin_groups", lia.admin.groups, true, true)
        if network then
            net.Start("lilia_updateAdminGroups")
            net.WriteTable(lia.admin.groups)
            net.Broadcast()
        end
    end

    function lia.admin.setPlayerGroup(ply, usergroup)
        ply:SetUserGroup(usergroup)
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
        lia.db.query(Format("DELETE FROM lia_bans WHERE _steamID = '%s'", lia.db.escape(steamid)), function() MsgC(Color(0, 200, 0), "[Lilia Administration] Ban removed.\n") end)
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
end

hook.Add("PlayerAuthed", "lia_SetUserGroup", function(ply, steamID)
    local steam64 = util.SteamIDTo64(steamID)
    lia.db.query(Format("SELECT _userGroup FROM lia_players WHERE _steamID = %s", steam64), function(data) if istable(data) and data[1] then ply:SetUserGroup(data[1]._userGroup) end end)
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

concommand.Add("plysetgroup", function(ply, cmd, args)
    if not IsValid(ply) then
        local target = lia.util.findPlayer(args[1])
        if IsValid(target) then
            if lia.admin.groups[args[2]] then
                lia.admin.setPlayerGroup(target, args[2])
            else
                MsgC(Color(200, 20, 20), "[Lilia Administration] Error: usergroup not found.\n")
            end
        else
            MsgC(Color(200, 20, 20), "[Lilia Administration] Error: specified player not found.\n")
        end
    end
end)

hook.Add("InitPostEntity", "lia_LoadAdmin", function() lia.admin.load() end)
hook.Add("ShutDown", "lia_SaveAdmin", function() lia.admin.save() end)