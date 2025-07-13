lia.admin = lia.admin or {}
lia.admin.bans = lia.admin.bans or {}
lia.admin.bans.list = lia.admin.bans.list or {}
lia.admin.permissions = lia.admin.permissions or {}
lia.admin.commands = lia.admin.commands or {
	noclip = true
}

MODULE.name = "Attributes"
MODULE.author = "76561198312513285"
MODULE.discord = "@liliaplayer"
MODULE.version = "1.0"
MODULE.desc = "Introduces character-bound attributes that affect gameplay."
function MODULE:PlayerNoClip(client, state)
	if client:hasPermission("noclip") then
		if SERVER then
			if state then
				client.nutObsData = {client:GetPos(), client:EyeAngles()}
				client:SetNoDraw(true)
				client:SetNotSolid(true)
				client:DrawWorldModel(false)
				client:DrawShadow(false)
				client:GodEnable()
				client:SetNoTarget(true)
				hook.Run("OnPlayerObserve", client, state)
			else
				if client.nutObsData then
					if client:GetInfoNum("lia_obstpback", 0) > 0 then
						local position, angles = client.nutObsData[1], client.nutObsData[2]
						timer.Simple(0, function()
							client:SetPos(position)
							client:SetEyeAngles(angles)
							client:SetVelocity(Vector(0, 0, 0))
						end)
					end

					client.nutObsData = nil
				end

				client:SetNoDraw(false)
				client:SetNotSolid(false)
				client:DrawWorldModel(true)
				client:DrawShadow(true)
				client:GodDisable()
				client:SetNoTarget(false)
				hook.Run("OnPlayerObserve", client, state)
			end
		end
		return true
	end
end

function MODULE:InitializedModules()
	for cmd, info in next, lia.command.list do
		if info.group or info.superAdminOnly or info.adminOnly then
			info.onCheckAccess = function(client) return client:hasPermission(cmd) end
			info.onRun = function(client, arguments)
				if not info.onCheckAccess(client) then
					return "@noPerm"
				else
					return info._onRun(client, arguments)
				end
			end

			lia.admin.commands[cmd] = true
		end
	end

	lia.command.findPlayer = function(client, name)
		local calling_func = debug.getinfo(2)
		local command
		local target = type(name) == "string" and lia.util.findPlayer(name) or NULL
		for cmd, info in next, lia.command.list do
			if info._onRun == calling_func.func then command = info end
		end

		if IsValid(target) then
			if command and (command.adminOnly or command.superAdminOnly) then
				local target_group = lia.admin.permissions[target:GetUserGroup()]
				local client_group = lia.admin.permissions[client:GetUserGroup()]
				if target_group.position < client_group.position then
					client:notifyLocalized("plyCantTarget")
					return
				end
			end
			return target
		else
			client:notifyLocalized("plyNoExist")
		end
	end
end

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

concommand.Add("createownergroup", function(ply, cmd, args)
	if not IsValid(ply) then
		lia.admin.createGroup("owner", {
			position = 0,
			admin = false,
			superadmin = true,
			permissions = {},
		})

		for cmd, _ in next, lia.admin.commands do
			lia.admin.permissions["owner"].permissions[cmd] = true
		end

		lia.admin.save(true)
	end
end)

concommand.Add("wipegroups", function(ply, cmd, args)
	if not IsValid(ply) then
		for k, v in next, player.GetAll() do
			v:SetUserGroup("user")
		end

		lia.admin.permissions = {}
		lia.admin.save(true)
	end
end)