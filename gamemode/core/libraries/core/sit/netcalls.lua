if SERVER then
    local pitchOffset = Angle(270, 0, 0)
    net.Receive("liaSitSitFacing", function(_, ply)
        local curTime = CurTime()
        local steamID = ply:SteamID64()
        if not lia.sit.cooldown[steamID] then lia.sit.cooldown[steamID] = 0 end
        if lia.sit.cooldown[steamID] > curTime then return end
        lia.sit.cooldown[steamID] = curTime + 0.5
        local wantedRotation = net.ReadFloat()
        local traceDirection = net.ReadVector()
        if wantedRotation ~= wantedRotation then return end
        if math.abs(wantedRotation) > 100000 then return end
        if traceDirection:LengthSqr() <= 0 then return end
        traceDirection:Normalize()
        local traceStart = ply:EyePos()
        local eyeTrace = util.TraceLine({
            start = traceStart,
            endpos = traceStart + traceDirection * 12000,
            filter = player.GetAll()
        })

        if not eyeTrace.Hit then return end
        local pos = eyeTrace.HitPos
        local ent = eyeTrace.Entity
        local pitch = (eyeTrace.HitNormal:Angle() - pitchOffset).pitch
        if ply:GetPos():DistToSqr(pos) > 10000 then return end
        if IsValid(ent) and ent:IsPlayer() then return end
        if pitch > 10 then return end
        if pitch < -10 then return end
        local canSit, sitRotation = hook.Run("ShouldAllowSit", ply, pos, pitch, ent)
        if canSit == false then return end
        local rotation = math.NormalizeAngle(wantedRotation)
        local manualFacing = true
        if isnumber(sitRotation) then
            rotation = sitRotation
            manualFacing = false
        elseif not lia.sit.isValidSittingRotation(pos, eyeTrace.HitNormal:Angle(), rotation) then
            return
        end

        lia.sit.placePlayerInSeat(ply, pos, IsValid(ent) and not ent:IsWorld() and ent or NULL, rotation, pitch, manualFacing)
    end)
end
