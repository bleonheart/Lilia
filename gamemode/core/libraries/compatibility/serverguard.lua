local function run(cmd, ...)
    RunConsoleCommand("serverguard", cmd, ...)
    RunConsoleCommand("sg", cmd, ...)
end

hook.Add("RunAdminSystemCommand", "liaServerGuard", function(cmd, _, target, dur, reason)
    local id = isstring(target) and target or IsValid(target) and target:SteamID()
    if not id then return end

    if cmd == "kick" then
        run("kick", id, reason or "")
        return true
    elseif cmd == "ban" then
        run("ban", id, tostring(dur or 0), reason or "")
        return true
    elseif cmd == "unban" then
        run("unban", id)
        return true
    elseif cmd == "mute" then
        run("mute", id, tostring(dur or 0))
        return true
    elseif cmd == "unmute" then
        run("unmute", id)
        return true
    elseif cmd == "gag" then
        run("gag", id, tostring(dur or 0))
        return true
    elseif cmd == "ungag" then
        run("ungag", id)
        return true
    elseif cmd == "freeze" then
        run("freeze", id, tostring(dur or 0))
        return true
    elseif cmd == "unfreeze" then
        run("unfreeze", id)
        return true
    elseif cmd == "slay" then
        run("slay", id)
        return true
    elseif cmd == "bring" then
        run("bring", id)
        return true
    elseif cmd == "goto" then
        run("goto", id)
        return true
    elseif cmd == "return" then
        run("return", id)
        return true
    elseif cmd == "jail" then
        run("jail", id, tostring(dur or 0))
        return true
    elseif cmd == "unjail" then
        run("unjail", id)
        return true
    elseif cmd == "cloak" then
        run("cloak", id)
        return true
    elseif cmd == "uncloak" then
        run("uncloak", id)
        return true
    elseif cmd == "god" then
        run("god", id)
        return true
    elseif cmd == "ungod" then
        run("ungod", id)
        return true
    elseif cmd == "ignite" then
        run("ignite", id, tostring(dur or 0))
        return true
    elseif cmd == "extinguish" or cmd == "unignite" then
        run("extinguish", id)
        return true
    elseif cmd == "strip" then
        run("strip", id)
        return true
    end
end)

hook.Add("ShouldLiliaAdminCommandsLoad", "liaServerGuard", function() return false end)

