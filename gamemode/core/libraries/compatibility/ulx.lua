hook.Add("ULibGroupAccessChanged", "liaULXCAMI", function(group_name, access, revoke)
    if revoke then
        print(group_name .. " lost permission: " .. access)
    else
        print(group_name .. " gained permission: " .. access)
    end
end)

hook.Add("RunAdminSystemCommand", "liaULX", function(cmd, _, target, dur, reason)
    local id = isstring(target) and target or IsValid(target) and target:SteamID()
    if not id then return end
    if cmd == "kick" then
        RunConsoleCommand("ulx", "kick", id, reason or "")
        return true
    elseif cmd == "ban" then
        RunConsoleCommand("ulx", "banid", id, tostring(dur or 0), reason or "")
        return true
    elseif cmd == "unban" then
        RunConsoleCommand("ulx", "unban", id)
        return true
    elseif cmd == "mute" then
        RunConsoleCommand("ulx", "mute", id)
        return true
    elseif cmd == "unmute" then
        RunConsoleCommand("ulx", "unmute", id)
        return true
    elseif cmd == "gag" then
        RunConsoleCommand("ulx", "gag", id)
        return true
    elseif cmd == "ungag" then
        RunConsoleCommand("ulx", "ungag", id)
        return true
    elseif cmd == "freeze" then
        RunConsoleCommand("ulx", "freeze", id)
        return true
    elseif cmd == "unfreeze" then
        RunConsoleCommand("ulx", "unfreeze", id)
        return true
    elseif cmd == "slay" then
        RunConsoleCommand("ulx", "slay", id)
        return true
    elseif cmd == "bring" then
        RunConsoleCommand("ulx", "bring", id)
        return true
    elseif cmd == "goto" then
        RunConsoleCommand("ulx", "goto", id)
        return true
    elseif cmd == "return" then
        RunConsoleCommand("ulx", "return", id)
        return true
    elseif cmd == "jail" then
        RunConsoleCommand("ulx", "jail", id, tostring(dur or 0))
        return true
    elseif cmd == "unjail" then
        RunConsoleCommand("ulx", "unjail", id)
        return true
    elseif cmd == "cloak" then
        RunConsoleCommand("ulx", "cloak", id)
        return true
    elseif cmd == "uncloak" then
        RunConsoleCommand("ulx", "uncloak", id)
        return true
    elseif cmd == "god" then
        RunConsoleCommand("ulx", "god", id)
        return true
    elseif cmd == "ungod" then
        RunConsoleCommand("ulx", "ungod", id)
        return true
    elseif cmd == "ignite" then
        RunConsoleCommand("ulx", "ignite", id)
        return true
    elseif cmd == "extinguish" or cmd == "unignite" then
        RunConsoleCommand("ulx", "unignite", id)
        return true
    elseif cmd == "strip" then
        RunConsoleCommand("ulx", "strip", id)
        return true
    end
end)