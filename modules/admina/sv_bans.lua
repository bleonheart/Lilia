local PLUGIN = PLUGIN
lia.admin = lia.admin or {}
lia.admin.bans = lia.admin.bans or {}
lia.admin.bans.list = lia.admin.bans.list or {}

function lia.admin.bans.add(steamid, reason, duration)
	local genericReason = lia.lang.stored[PLUGIN.language].genericReason
	if !steamid then
		Error("[NutScript Admin] lia.admin.bans.add: no steam id specified!")
	end

	local banStart = os.time()

	lia.admin.bans.list[steamid] = {
		reason = reason or genericReason,
		start = banStart,
		duration = (duration * 60) or 0,
	}
	
	lia.db.insertTable({
		_steamID = "\""..steamid.."\"",
		_banStart = banStart,
		_banDuration = (duration * 60) or 0,
		_reason = reason or genericReason,
	}, nil, "bans")
end

function lia.admin.bans.remove(steamid)
	if !steamid then
		Error("[NutScript Admin] lia.admin.bans.remove: no steam id specified!")
	end
	
	lia.admin.bans.list[steamid] = nil
	
	lia.db.query(Format("DELETE FROM nut_bans WHERE _steamID = '%s'", lia.db.escape(steamid)), function(data)
		MsgC(Color(0, 200, 0), "[NutScript Admin] Ban removed.\n")
	end)
end

function lia.admin.bans.isBanned(steamid)
	return lia.admin.bans.list[steamid] or false
end

function lia.admin.bans.hasExpired(steamid)
	local ban = lia.admin.bans.list[steamid]
	if !ban then return true end
	if ban.duration == 0 then return false end
	
	return ban.start + ban.duration <= os.time()
end

local meta = FindMetaTable("Player")

function meta:banPlayer(reason, duration)
	lia.admin.bans.add(self:SteamID64(), reason, duration)
	self:Kick(L("banMessage", self, duration or 0, reason or L("genericReason", self)))
end

lia.admin.bans.sqlite_createTables = [[
CREATE TABLE IF NOT EXISTS `nut_bans` (
	`_steamID` TEXT,
	`_banStart` INTEGER,
	`_banDuration` INTEGER,
	`_reason` TEXT
);
]]

lia.admin.bans.mysql_createTables = [[
CREATE TABLE IF NOT EXISTS `nut_bans` (
	`_steamID` varchar(64) NOT NULL,
	`_banStart` int(32) NOT NULL,
	`_banDuration` int(32) NOT NULL,
	`_reason` varchar(512) DEFAULT '',
	PRIMARY KEY (`_steamID`)
);
]]

hook.Add("OnLoadTables", "lia.admin.bans.setupDatabase", function()
	lia.db.query(lia.db.object and lia.admin.bans.mysql_createTables or lia.admin.bans.sqlite_createTables)
end)

hook.Add("OnDatabaseLoaded", "lia.admin.bans.loadBanlist", function()
	lia.db.query("SELECT * FROM nut_bans", function(data)
		if data and istable(data) then
			local list = {}
			for _,ban in next, data do
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

function PLUGIN:CheckPassword(steamid64, ipAddress, svPassword, clPassword, name)
	local banned = lia.admin.bans.isBanned(steamid64)
	local hasExpired = lia.admin.bans.hasExpired(steamid64)
	
	if banned and !hasExpired then
		return false, Format(lia.lang.stored[PLUGIN.language].banMessage, banned.duration / 60, banned.reason)
	elseif banned and hasExpired then
		lia.admin.bans.remove(steamid64)
	end
end