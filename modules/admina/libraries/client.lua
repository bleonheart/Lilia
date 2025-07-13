local MODULE = MODULE
function MODULE:InitPostEntity()
        net.Start("lilia_requestAdminPermissions")
        net.SendToServer()
end

function lia.admin.menu.addTab(info)
        lia.admin.menu.tabs[info.title] = info
end

lia.admin.menu.addTab({
        icon = "icon16/world.png",
        panelClass = "DAdminWorldMenu",
        title = "adminWorldMenuTitle",
})

local function quote(str)
        return string.format("'%s'", tostring(str))
end

function MODULE:RunAdminSystemCommand(cmd, _, victim, dur, reason)
        local id = IsValid(victim) and victim:SteamID() or tostring(victim)
        if cmd == "kick" then
                RunConsoleCommand("say", "/plykick " .. quote(id) .. (reason and " " .. quote(reason) or ""))
                return true
        elseif cmd == "ban" then
                RunConsoleCommand("say", "/plyban " .. quote(id) .. " " .. tostring(dur or 0) .. (reason and " " .. quote(reason) or ""))
                return true
        elseif cmd == "unban" then
                RunConsoleCommand("say", "/plyunban " .. quote(id))
                return true
        elseif cmd == "mute" then
                RunConsoleCommand("say", "/plymute " .. quote(id) .. " " .. tostring(dur or 0) .. (reason and " " .. quote(reason) or ""))
                return true
        elseif cmd == "unmute" then
                RunConsoleCommand("say", "/plyunmute " .. quote(id))
                return true
        elseif cmd == "gag" then
                RunConsoleCommand("say", "/plygag " .. quote(id) .. " " .. tostring(dur or 0) .. (reason and " " .. quote(reason) or ""))
                return true
        elseif cmd == "ungag" then
                RunConsoleCommand("say", "/plyungag " .. quote(id))
                return true
        elseif cmd == "freeze" then
                RunConsoleCommand("say", "/plyfreeze " .. quote(id) .. " " .. tostring(dur or 0))
                return true
        elseif cmd == "unfreeze" then
                RunConsoleCommand("say", "/plyunfreeze " .. quote(id))
                return true
        elseif cmd == "slay" then
                RunConsoleCommand("say", "/plyslay " .. quote(id))
                return true
        elseif cmd == "bring" then
                RunConsoleCommand("say", "/plybring " .. quote(id))
                return true
        elseif cmd == "goto" then
                RunConsoleCommand("say", "/plygoto " .. quote(id))
                return true
        elseif cmd == "return" then
                RunConsoleCommand("say", "/plyreturn " .. quote(id))
                return true
        elseif cmd == "jail" then
                RunConsoleCommand("say", "/plyjail " .. quote(id) .. " " .. tostring(dur or 0))
                return true
        elseif cmd == "unjail" then
                RunConsoleCommand("say", "/plyunjail " .. quote(id))
                return true
        elseif cmd == "cloak" then
                RunConsoleCommand("say", "/plycloak " .. quote(id))
                return true
        elseif cmd == "uncloak" then
                RunConsoleCommand("say", "/plyuncloak " .. quote(id))
                return true
        elseif cmd == "god" then
                RunConsoleCommand("say", "/plygod " .. quote(id))
                return true
        elseif cmd == "ungod" then
                RunConsoleCommand("say", "/plyungod " .. quote(id))
                return true
        elseif cmd == "ignite" then
                RunConsoleCommand("say", "/plyignite " .. quote(id) .. " " .. tostring(dur or 0))
                return true
        elseif cmd == "extinguish" or cmd == "unignite" then
                RunConsoleCommand("say", "/plyextinguish " .. quote(id))
                return true
        elseif cmd == "strip" then
                RunConsoleCommand("say", "/plystrip " .. quote(id))
                return true
        elseif cmd == "respawn" then
                RunConsoleCommand("say", "/plyrespawn " .. quote(id))
                return true
        elseif cmd == "blind" then
                RunConsoleCommand("say", "/plyblind " .. quote(id))
                return true
        elseif cmd == "unblind" then
                RunConsoleCommand("say", "/plyunblind " .. quote(id))
                return true
        end
end

net.Receive("lilia_updateAdminPermissions", function() lia.admin.permissions = net.ReadTable() end)
net.Receive("blindTarget", function()
        local enabled = net.ReadBool()
        if enabled then
                hook.Add("HUDPaint", "blindTarget", function() draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255)) end)
        else
                hook.Remove("HUDPaint", "blindTarget")
        end
end)