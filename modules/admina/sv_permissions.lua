local MODULE = MODULE
local meta = FindMetaTable("Player")
lia.admin = lia.admin or {}
lia.admin.permissions = lia.admin.permissions or {}

function lia.admin.save(network)
	file.Write("nutscript/admin_permissions.txt", util.TableToJSON(lia.admin.permissions))
	
	if network then
		netstream.Start(nil, "nutscript_updateAdminPermissions", lia.admin.permissions)
	end
end

function lia.admin.load()
	lia.admin.permissions = util.JSONToTable(file.Read("nutscript/admin_permissions.txt", "DATA") or "")
end

function lia.admin.setPlayerGroup(ply, usergroup)
	ply:SetUserGroup(usergroup)
	lia.db.query(Format("UPDATE nut_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(usergroup), ply:SteamID64()))
end

function lia.admin.createGroup(groupName, info)
	if lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup already exists!\n")
		return
	end
	
	lia.admin.permissions[groupName] = info or {
		position = table.Count(lia.admin.permissions),
		admin = false,
		superadmin = false,
		permissions = {},
	}
	
	if SERVER then
		lia.admin.save(true)
	end
end

function lia.admin.removeGroup(groupName)
	if !lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup doesn't exist!\n")
		return
	end
	
	lia.admin.permissions[groupName] = nil
		
	if SERVER then
		lia.admin.save(true)
	end
end

function lia.admin.addPermission(groupName, permission)
	if !lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup doesn't exist!\n")
		return
	end
	
	lia.admin.permissions[groupName]["permissions"][permission] = true
		
	if SERVER then
		lia.admin.save(true)
	end
end

function lia.admin.removePermission(groupName, permission)
	if !lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup doesn't exist!\n")
		return
	end
	
	lia.admin.permissions[groupName]["permissions"][permission] = nil
		
	if SERVER then
		lia.admin.save(true)
	end
end

function lia.admin.setIsAdmin(groupName, isAdmin)
	if !lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup doesn't exist!\n")
		return
	end
	
	lia.admin.permissions[groupName].admin = isAdmin
	
	if SERVER then
		lia.admin.save(true)
	end
end

function lia.admin.setIsSuperAdmin(groupName, isAdmin)
	if !lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup doesn't exist!\n")
		return
	end
	
	lia.admin.permissions[groupName].superadmin = isAdmin
	
	if SERVER then
		lia.admin.save(true)
	end
end

function lia.admin.setGroupPosition(groupName, position)
	if !lia.admin.permissions[groupName] then
		Error("[NutScript Administration] This usergroup doesn't exist!\n")
		return
	end
	
	local group = lia.admin.permissions[groupName]
	local oldPos = group.position
	
	for name,group in next, lia.admin.permissions do
		if name == groupName then continue end

		if position - oldPos > 0 then 
			if group.position > oldPos and group.position <= position then
				group.position = group.position - 1
			end
		elseif position - oldPos < 0 then 
			if group.position < oldPos and group.position >= position then
				group.position = group.position + 1
			end
		end
	end
	
	group.position = position
	
	if SERVER then
		lia.admin.save(true)
	end
end

function MODULE:InitPostEntity()
	lia.admin.load()
end

function MODULE:ShutDown()
	lia.admin.save()
end

function MODULE:PlayerAuthed(ply, steamid, uid)
	lia.db.query(Format("SELECT _userGroup FROM nut_players WHERE _steamID = %s", util.SteamIDTo64(steamid)), function(data)
		ply:SetUserGroup(data[1]._userGroup)
	end)
end

netstream.Hook("nutscript_requestAdminPermissions", function(ply)
	netstream.Start(ply, "nutscript_updateAdminPermissions", lia.admin.permissions)
end)

local MYSQL_FINDCOLUMN = [[SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='%s' AND TABLE_NAME='nut_players' and column_name='_userGroup';]]
local MYSQL_CREATECOLUMN = [[ALTER TABLE `nut_players` ADD COLUMN `_userGroup` varchar(255) NOT NULL DEFAULT 'user';]]

local SQLITE_FINDCOLUMN = [[SELECT EXISTS (SELECT * FROM sqlite_master WHERE tbl_name = 'nut_players' AND sql LIKE '_userGroup');]]

hook.Add("OnLoadTables", "lia.admin.permissions.setupUsergroup", function() 
	if lia.db.object then
		lia.db.query(Format(MYSQL_FINDCOLUMN, lia.db.database), function(data)
			if !data then
				lia.db.query(MYSQL_CREATECOLUMN)
			end
		end)
	else
		lia.db.query(SQLITE_FINDCOLUMN, function(data)
			if !data then
				lia.db.query(MYSQL_CREATECOLUMN)
			end
		end)
	end
end)
