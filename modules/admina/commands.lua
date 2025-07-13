local MODULE = MODULE
lia.command.add("plykick", {
	adminOnly = true,
	syntax = "<string name> [string reason]",
	onRun = function(client, arguments)
		if SERVER then
			local target = lia.command.findPlayer(client, arguments[1])
			if IsValid(target) then
				target:Kick(L("kickMessage", target, arguments[2] or L("genericReason")))
				client:notifyLocalized("plyKicked")
			end
		end
	end
})

lia.command.add("plyban", {
	adminOnly = true,
	syntax = "<string name> [number duration] [string reason]",
	onRun = function(client, arguments)
		if SERVER then
			local target = lia.command.findPlayer(client, arguments[1])
			if IsValid(target) then
				target:banPlayer(arguments[3] or L("genericReason"), arguments[2])
				client:notifyLocalized("plyBanned")
			end
		end
	end
})

lia.command.add("plykill", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		if SERVER then
			local target = lia.command.findPlayer(client, arguments[1])
			if IsValid(target) then
				target:Kill()
				client:notifyLocalized("plyKilled")
			end
		end
	end
})

lia.command.add("plysetgroup", {
	adminOnly = true,
	syntax = "<string name> <string group>",
	onRun = function(client, arguments)
		if SERVER then
			local target = lia.command.findPlayer(client, arguments[1])
			if IsValid(target) and lia.admin.permissions[arguments[2]] then
				lia.admin.setPlayerGroup(target, arguments[2])
				client:notifyLocalized("plyGroupSet")
			elseif IsValid(target) and not lia.admin.permissions[arguments[2]] then
				client:notifyLocalized("groupNotExists")
			end
		end
	end
})

lia.command.add("grpaddgroup", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		if SERVER then
			if not lia.admin.permissions[arguments[1]] then
				lia.admin.createGroup(arguments[1])
				client:notifyLocalized("groupCreated")
			else
				client:notifyLocalized("groupExists")
			end
		end
	end
})

lia.command.add("grprmgroup", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		if SERVER then
			if lia.admin.permissions[arguments[1]] then
				lia.admin.removeGroup(arguments[1])
				client:notifyLocalized("groupRemoved")
			else
				client:notifyLocalized("groupNotExists")
			end
		end
	end
})

lia.command.add("grpaddperm", {
	adminOnly = true,
	syntax = "<string name> <string command>",
	onRun = function(client, arguments)
		if SERVER then
			if lia.admin.permissions[arguments[1]] and lia.admin.commands[arguments[2]] and not lia.admin.permissions[arguments[1]].permissions[arguments[2]] then
				lia.admin.addPermission(arguments[1], arguments[2])
				client:notifyLocalized("permissionAdded")
			elseif not lia.admin.permissions[arguments[1]] then
				client:notifyLocalized("groupNotExists")
			elseif not lia.admin.commands[arguments[2]] then
				client:notifyLocalized("commandNotExists")
			elseif lia.admin.permissions[arguments[1]].permissions[arguments[2]] then
				client:notifyLocalized("groupPermExists")
			end
		end
	end
})

lia.command.add("grprmperm", {
	adminOnly = true,
	syntax = "<string name> <string command>",
	onRun = function(client, arguments)
		if SERVER then
			if lia.admin.permissions[arguments[1]] and lia.admin.commands[arguments[2]] and lia.admin.permissions[arguments[1]].permissions[arguments[2]] then
				lia.admin.removePermission(arguments[1], arguments[2])
				client:notifyLocalized("permissionRemoved")
			elseif not lia.admin.permissions[arguments[1]] then
				client:notifyLocalized("groupNotExists")
			elseif not lia.admin.commands[arguments[2]] then
				client:notifyLocalized("commandNotExists")
			elseif not lia.admin.permissions[arguments[1]].permissions[arguments[2]] then
				client:notifyLocalized("groupNoPermExists")
			end
		end
	end
})

lia.command.add("grpsetposition", {
	adminOnly = true,
	syntax = "<string name> <number position>",
	onRun = function(client, arguments)
		if SERVER then
			local pos = tonumber(arguments[2])
			if lia.admin.permissions[arguments[1]] and isnumber(pos) then
				lia.admin.setGroupPosition(arguments[1], pos)
				client:notifyLocalized("groupPosChanged")
			elseif not lia.admin.permissions[arguments[1]] then
				client:notifyLocalized("groupNotExists")
			elseif not isnumber(pos) then
				client:notifyLocalized("invalidArg")
			end
		end
	end
})