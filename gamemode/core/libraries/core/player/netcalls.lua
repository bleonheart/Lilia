if CLIENT then
net.Receive("liaActBar", function()
    local hasData = net.ReadBool()
    if not hasData then
        if IsValid(lia.gui.actionCircle) then lia.gui.actionCircle:Remove() end
        return
    end

    local text = net.ReadString()
    local time = net.ReadFloat()
    local displayText = text:sub(1, 1) == "@" and text:sub(2) or text
    if IsValid(lia.gui.actionCircle) then lia.gui.actionCircle:Remove() end
    lia.gui = lia.gui or {}
    local pnl = vgui.Create("liaActionCircle")
    pnl:Start(displayText, time)
    lia.gui.actionCircle = pnl
end)

net.Receive("liaAnimationStatus", function()
    local ply = net.ReadEntity()
    local active = net.ReadBool()
    local boneData = net.ReadTable()
    if IsValid(ply) then ply:networkAnimation(active, boneData) end
end)
net.Receive("liaSyncGesture", function()
    local entity = net.ReadEntity()
    local a = net.ReadUInt(8)
    local b = net.ReadUInt(16)
    local c = net.ReadBool()
    if IsValid(entity) then entity:AnimRestartGesture(a, b, c) end
end)

    net.Receive("liaSetWaypoint", function()
        local name = net.ReadString()
        local pos = net.ReadVector()
        local logo = net.ReadString()
        LocalPlayer():setWaypoint(name, pos, logo ~= "" and logo or nil)
    end)
end

if SERVER then
net.Receive("liaPlayerRespawn", function(_, client)
    if not IsValid(client) or client:Alive() then return end
    if not client:getChar() then return end
    local baseTime = lia.config.get("SpawnTime", 5)
    baseTime = hook.Run("OverrideSpawnTime", client, baseTime) or baseTime
    local lastDeath = client:getLocalVar("lastDeathTime")
    local timePassed = lastDeath and lastDeath ~= 0 and os.time() - lastDeath or nil
    local canRespawn = hook.Run("CanPlayerRespawn", client, timePassed, baseTime, lastDeath)
    if canRespawn == false then
        lia.log.add(client, "respawn", "Respawn blocked by CanPlayerRespawn")
        return
    elseif canRespawn == true then
        client.liaIsRespawning = true
        client:Spawn()
        return
    end

    if not lastDeath or lastDeath == 0 then
        client.liaIsRespawning = true
        client:Spawn()
        lia.log.add(client, "respawn", "Forced respawn due to missing lastDeathTime")
        return
    end

    timePassed = os.time() - lastDeath
    if timePassed >= baseTime then
        client.liaIsRespawning = true
        client:Spawn()
    else
        lia.log.add(client, "respawn", "Respawn denied - timePassed: " .. timePassed .. " < baseTime: " .. baseTime)
    end
end)

    net.Receive("liaWaypointReached", function(_, client)
        if client.waypointOnReach and isfunction(client.waypointOnReach) then
            client.waypointOnReach(client)
            client.waypointOnReach = nil
        end
    end)
end
