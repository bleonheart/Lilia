local MODULE = MODULE
local meta = FindMetaTable("Player")
function lia.admin.save(network)
        file.Write("nutscript/admin_permissions.txt", util.TableToJSON(lia.admin.permissions))
        if network then
                net.Start("lilia_updateAdminPermissions")
                net.WriteTable(lia.admin.permissions)
                net.Broadcast()
        end
end

function lia.admin.load()
	lia.admin.permissions = util.JSONToTable(file.Read("nutscript/admin_permissions.txt", "DATA") or "")
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

function lia.admin.setIsAdmin(groupName, isAdmin)
	if not lia.admin.permissions[groupName] then
		Error("[Lilia Administration] This usergroup doesn't exist!\n")
		return
	end

	lia.admin.permissions[groupName].admin = isAdmin
	if SERVER then lia.admin.save(true) end
end

function lia.admin.setIsSuperAdmin(groupName, isAdmin)
	if not lia.admin.permissions[groupName] then
		Error("[Lilia Administration] This usergroup doesn't exist!\n")
		return
	end

	lia.admin.permissions[groupName].superadmin = isAdmin
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

function MODULE:InitPostEntity()
	lia.admin.load()
end

function MODULE:ShutDown()
	lia.admin.save()
end

function MODULE:PlayerAuthed(ply, steamid, uid)
	lia.db.query(Format("SELECT _userGroup FROM lia_players WHERE _steamID = %s", util.SteamIDTo64(steamid)), function(data) ply:SetUserGroup(data[1]._userGroup) end)
end

net.Receive("lilia_requestAdminPermissions", function(_, ply)
        net.Start("lilia_updateAdminPermissions")
        net.WriteTable(lia.admin.permissions)
        net.Send(ply)
end)
local MYSQL_FINDCOLUMN = [[SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='%s' AND TABLE_NAME='lia_players' and column_name='_userGroup';]]
local MYSQL_CREATECOLUMN = [[ALTER TABLE `lia_players` ADD COLUMN `_userGroup` varchar(255) NOT NULL DEFAULT 'user';]]
local SQLITE_FINDCOLUMN = [[SELECT EXISTS (SELECT * FROM sqlite_master WHERE tbl_name = 'lia_players' AND sql LIKE '_userGroup');]]
hook.Add("OnLoadTables", "lia.admin.permissions.setupUsergroup", function()
	if lia.db.object then
		lia.db.query(Format(MYSQL_FINDCOLUMN, lia.db.database), function(data) if not data then lia.db.query(MYSQL_CREATECOLUMN) end end)
	else
		lia.db.query(SQLITE_FINDCOLUMN, function(data) if not data then lia.db.query(MYSQL_CREATECOLUMN) end end)
	end
end)

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

local meta = FindMetaTable("Player")
function meta:banPlayer(reason, duration)
	lia.admin.bans.add(self:SteamID64(), reason, duration)
	self:Kick(L("banMessage", self, duration or 0, reason or L("genericReason", self)))
end

hook.Add("OnDatabaseLoaded", "lia.admin.bans.loadBanlist", function()
	lia.db.query("SELECT * FROM lia_bans", function(data)
		if data and istable(data) then
			local list = {}
			for _, ban in next, data do
				list[ban._steamID] = {
					reason = ban._reason,
					start = ban._banStart,
					duration = ban._banDuration,
				}
			end

			lia.admin.bans.list = list
		end
	end)
end)

function MODULE:CheckPassword(steamid64, ipAddress, svPassword, clPassword, name)
	local banned = lia.admin.bans.isBanned(steamid64)
	local hasExpired = lia.admin.bans.hasExpired(steamid64)
	if banned and not hasExpired then
               return false, L("banMessage", banned.duration / 60, banned.reason)
	elseif banned and hasExpired then
		lia.admin.bans.remove(steamid64)
	end
end