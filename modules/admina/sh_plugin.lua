local PLUGIN = PLUGIN
PLUGIN.name = "Admin"
PLUGIN.author = "rusty"
PLUGIN.desc = "Stop using paid admin mods, idiots."
PLUGIN.language = "english"

nut.admin = nut.admin or {}
nut.admin.commands = nut.admin.commands or {noclip = true}

nut.util.include("sh_permissions.lua")
nut.util.include("cl_permissions.lua")
nut.util.include("cl_plugin.lua")

nut.util.include("sh_commands.lua")

if SERVER then
	nut.util.include("sv_permissions.lua")
	nut.util.include("sv_bans.lua")
end

local PLUGIN = PLUGIN


function PLUGIN:PlayerNoClip(client, state)
	if (client:hasPermission("noclip")) then
		if SERVER then
			if (state) then
				client.nutObsData = {client:GetPos(), client:EyeAngles()}
				client:SetNoDraw(true)
				client:SetNotSolid(true)
				client:DrawWorldModel(false)
				client:DrawShadow(false)
				client:GodEnable()
				client:SetNoTarget(true)
				hook.Run("OnPlayerObserve", client, state)
			else
				if (client.nutObsData) then
					if (client:GetInfoNum("nut_obstpback", 0) > 0) then
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

function PLUGIN:InitializedPlugins()
	for cmd,info in next, nut.command.list do
		if info.group or info.superAdminOnly or info.adminOnly then
			info.onCheckAccess = function(client)
				return client:hasPermission(cmd)
			end
			info.onRun = function(client, arguments)
				if !info.onCheckAccess(client) then
					return "@noPerm"
				else
					return info._onRun(client, arguments)
				end
			end
			
			nut.admin.commands[cmd] = true
		end
	end
	
	nut.command.findPlayer = function(client, name)
		local calling_func = debug.getinfo(2)
		local command
		local target = type(name) == "string" and nut.util.findPlayer(name) or NULL

		for cmd,info in next, nut.command.list do
			if info._onRun == calling_func.func then
				command = info
			end
		end

		if (IsValid(target)) then
			if command and (command.adminOnly or command.superAdminOnly) then
				local target_group = nut.admin.permissions[target:GetUserGroup()]
				local client_group = nut.admin.permissions[client:GetUserGroup()]
				
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


concommand.Add("plysetgroup", function( ply, cmd, args )
    if !IsValid(ply) then
		local target = nut.util.findPlayer(args[1])
		if IsValid(target) then
			if nut.admin.permissions[args[2]] then
				nut.admin.setPlayerGroup(target, args[2])
			else
				MsgC(Color(200,20,20), "[NutScript Admin] Error: usergroup not found.\n")
			end
		else
			MsgC(Color(200,20,20), "[NutScript Admin] Error: specified player not found.\n")
		end
	end
end)


concommand.Add("nsadmin_createownergroup", function( ply, cmd, args )
    if !IsValid(ply) then
		nut.admin.createGroup("owner", {
			position = 0,
			admin = false,
			superadmin = true,
			permissions = {},
		})
		
		for cmd,_ in next, nut.admin.commands do
			nut.admin.permissions["owner"].permissions[cmd] = true
		end
		
		nut.admin.save(true)
	end
end)

concommand.Add("nsadmin_wipegroups", function( ply, cmd, args )
    if !IsValid(ply) then
		for k,v in next, player.GetAll() do
			v:SetUserGroup("user")
		end
	
		nut.admin.permissions = {}
		nut.admin.save(true)
	end
end)