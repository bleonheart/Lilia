lia.player = lia.player or {}

function lia.player.registerWaypointStop(player, waypointID, onReach)
    concommand.Add("waypoint_stop_" .. waypointID, function()
        hook.Remove("HUDPaint", waypointID)
        concommand.Remove("waypoint_stop_" .. waypointID)
        if onReach and isfunction(onReach) then onReach(player) end
        if SERVER then
            if player.waypointOnReach and isfunction(player.waypointOnReach) then
                player.waypointOnReach(player)
                player.waypointOnReach = nil
            end
        else
            net.Start("liaWaypointReached")
            net.SendToServer()
        end
    end)
end
