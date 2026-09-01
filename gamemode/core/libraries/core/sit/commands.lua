if SERVER then
    concommand.Add("sit", function(ply)
        local curTime = CurTime()
        local steamID = ply:SteamID64()
        if not lia.sit.cooldown[steamID] then lia.sit.cooldown[steamID] = 0 end
        if lia.sit.cooldown[steamID] > curTime then return end
        lia.sit.cooldown[steamID] = curTime + 0.5
        local eyeTrace = ply:GetEyeTrace()
        local pos = eyeTrace.HitPos
        local ent = eyeTrace.Entity
        local pitch = (eyeTrace.HitNormal:Angle() - Angle(270, 0, 0)).pitch
        local canSit, optimalRotation = lia.sit.canPlayerSitAt(ply, pos, pitch, ent)
        if not canSit then return end
        lia.sit.placePlayerInSeat(ply, pos, ent:IsWorld() and NULL or ent, optimalRotation, pitch)
    end)
end
