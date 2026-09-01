net.Receive("liaInsertKeyPressed", function(_, client)
    if not IsValid(client) then return end
    local char = client:getChar()
    if not char then return end
    local message = client:Name() .. " (" .. client:SteamID() .. ") pressed INSERT (common cheat-menu key)."
    StaffAddTextShadowed(Color(255, 0, 0), "ALERT", Color(255, 255, 255), message, function(staff)
        local permission = staff:hasPrivilege("seeInsertNotifications")
        lia.debug("[Permissions]", "Permission Check for net.Receive liaInsertKeyPressed staff recipient", "targetPlayer=", tostring(staff:Name()), "hasPrivilege(seeInsertNotifications)=", tostring(permission), "finalResult=", tostring(permission))
        return permission
    end)
end)

net.Receive("liaCheckSeed", function(_, client)
    local sentSteamID = net.ReadString()
    if not sentSteamID or sentSteamID == "" then
        lia.admin.notifyAdmin(string.format("The SteamID of player %s (%s) wasn't received properly. This can signify tampering with net messages.", client:Name(), client:SteamID()))
        lia.log.add(client, "steamIDMissing", client:Name(), client:SteamID())
        return
    end

    if client:SteamID() ~= sentSteamID then
        lia.admin.notifyAdmin(string.format("The SteamID of player %s (%s) is different than the saved one (%s).", client:Name(), client:SteamID(), sentSteamID))
        lia.log.add(client, "steamIDMismatch", client:Name(), client:SteamID(), sentSteamID)
    end
end)
