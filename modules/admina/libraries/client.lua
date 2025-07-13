local MODULE = MODULE
function MODULE:InitPostEntity()
	netstream.Start("lilia_requestAdminPermissions")
end

function lia.admin.menu.addTab(info)
	lia.admin.menu.tabs[info.title] = info
end

lia.admin.menu.addTab({
	icon = "icon16/world.png",
	panelClass = "DAdminWorldMenu",
	title = "adminWorldMenuTitle",
})

netstream.Hook("lilia_updateAdminPermissions", function(info) lia.admin.permissions = info end)
hook.Add("RunAdminSystemCommand", "liaSam", function(cmd, _, victim, dur, reason)
	if cmd == "kick" then
		RunConsoleCommand("sam", "kick", victim:SteamID(), reason or "")
		return true
	elseif cmd == "ban" then
		RunConsoleCommand("sam", "ban", victim:SteamID(), tostring(dur or 0), reason or "")
		return true
	elseif cmd == "unban" then
		RunConsoleCommand("sam", "unban", victim:SteamID())
		return true
	elseif cmd == "mute" then
		RunConsoleCommand("sam", "mute", victim:SteamID(), tostring(dur or 0), reason or "")
		return true
	elseif cmd == "unmute" then
		RunConsoleCommand("sam", "unmute", victim:SteamID())
		return true
	elseif cmd == "gag" then
		RunConsoleCommand("sam", "gag", victim:SteamID(), tostring(dur or 0), reason or "")
		return true
	elseif cmd == "ungag" then
		RunConsoleCommand("sam", "ungag", victim:SteamID())
		return true
	elseif cmd == "freeze" then
		RunConsoleCommand("sam", "freeze", victim:SteamID(), tostring(dur or 0))
		return true
	elseif cmd == "unfreeze" then
		RunConsoleCommand("sam", "unfreeze", victim:SteamID())
		return true
	elseif cmd == "slay" then
		RunConsoleCommand("sam", "slay", victim:SteamID())
		return true
	elseif cmd == "bring" then
		RunConsoleCommand("sam", "bring", victim:SteamID())
		return true
	elseif cmd == "goto" then
		RunConsoleCommand("sam", "goto", victim:SteamID())
		return true
	elseif cmd == "return" then
		RunConsoleCommand("sam", "return", victim:SteamID())
		return true
	elseif cmd == "jail" then
		RunConsoleCommand("sam", "jail", victim:SteamID(), tostring(dur or 0))
		return true
	elseif cmd == "unjail" then
		RunConsoleCommand("sam", "unjail", victim:SteamID())
		return true
	elseif cmd == "cloak" then
		RunConsoleCommand("sam", "cloak", victim:SteamID())
		return true
	elseif cmd == "uncloak" then
		RunConsoleCommand("sam", "uncloak", victim:SteamID())
		return true
	elseif cmd == "god" then
		RunConsoleCommand("sam", "god", victim:SteamID())
		return true
	elseif cmd == "ungod" then
		RunConsoleCommand("sam", "ungod", victim:SteamID())
		return true
	elseif cmd == "ignite" then
		RunConsoleCommand("sam", "ignite", victim:SteamID(), tostring(dur or 0))
		return true
	elseif cmd == "extinguish" or cmd == "unignite" then
		RunConsoleCommand("sam", "extinguish", victim:SteamID())
		return true
	elseif cmd == "strip" then
		RunConsoleCommand("sam", "strip", victim:SteamID())
		return true
	end
end)