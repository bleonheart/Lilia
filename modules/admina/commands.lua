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

lia.command.add("plyunban", {
        adminOnly = true,
        syntax = "<string steamid>",
        onRun = function(client, arguments)
                if SERVER then
                        local steamid = arguments[1]
                        if steamid and steamid ~= "" then
                                lia.admin.bans.remove(steamid)
                                client:notify("Player unbanned")
                        end
                end
        end
})

lia.command.add("plyfreeze", {
        adminOnly = true,
        syntax = "<string name> [number duration]",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                target:Freeze(true)
                                local dur = tonumber(arguments[2]) or 0
                                if dur > 0 then
                                        timer.Simple(dur, function() if IsValid(target) then target:Freeze(false) end end)
                                end
                        end
                end
        end
})

lia.command.add("plyunfreeze", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:Freeze(false) end
                end
        end
})

lia.command.add("plyslay", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:Kill() end
                end
        end
})

lia.command.add("plyrespawn", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:Spawn() end
                end
        end
})

lia.command.add("plyblind", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                net.Start("blindTarget")
                                net.WriteBool(true)
                                net.Send(target)
                        end
                end
        end
})

lia.command.add("plyunblind", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                net.Start("blindTarget")
                                net.WriteBool(false)
                                net.Send(target)
                        end
                end
        end
})

lia.command.add("plygag", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:setNetVar("liaGagged", true) end
                end
        end
})

lia.command.add("plyungag", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:setNetVar("liaGagged", false) end
                end
        end
})

lia.command.add("plymute", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) and target:getChar() then
                                target:getChar():setData("VoiceBan", true)
                        end
                end
        end
})

lia.command.add("plyunmute", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) and target:getChar() then
                                target:getChar():setData("VoiceBan", false)
                        end
                end
        end
})

lia.command.add("plybring", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                lia.admin.returnPositions[target] = target:GetPos()
                                target:SetPos(client:GetPos() + client:GetForward() * 50)
                        end
                end
        end
})

lia.command.add("plygoto", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                lia.admin.returnPositions[client] = client:GetPos()
                                client:SetPos(target:GetPos() + target:GetForward() * 50)
                        end
                end
        end
})

lia.command.add("plyreturn", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        target = IsValid(target) and target or client
                        local pos = lia.admin.returnPositions[target]
                        if pos then target:SetPos(pos) lia.admin.returnPositions[target] = nil end
                end
        end
})

lia.command.add("plyjail", {
        adminOnly = true,
        syntax = "<string name> [number duration]",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                target:Lock()
                                target:Freeze(true)
                        end
                end
        end
})

lia.command.add("plyunjail", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                target:UnLock()
                                target:Freeze(false)
                        end
                end
        end
})

lia.command.add("plycloak", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:SetNoDraw(true) end
                end
        end
})

lia.command.add("plyuncloak", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:SetNoDraw(false) end
                end
        end
})

lia.command.add("plygod", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:GodEnable() end
                end
        end
})

lia.command.add("plyungod", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:GodDisable() end
                end
        end
})

lia.command.add("plyignite", {
        adminOnly = true,
        syntax = "<string name> [number duration]",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then
                                target:Ignite(tonumber(arguments[2]) or 5)
                        end
                end
        end
})

lia.command.add("plyextinguish", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:Extinguish() end
                end
        end
})

lia.command.add("plystrip", {
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments)
                if SERVER then
                        local target = lia.command.findPlayer(client, arguments[1])
                        if IsValid(target) then target:StripWeapons() end
                end
        end
})
