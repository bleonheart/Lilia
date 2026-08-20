lia.sit = lia.sit or {}
lia.sit.config = lia.sit.config or {}
lia.sit.cooldown = lia.sit.cooldown or {}
lia.sit.config.MaxDistance = 10000
lia.sit.config.MaxPitch = 10
lia.sit.config.CircleBuffer = 15
lia.sit.config.MaxIdealLeaveDistance = 50000
lia.sit.config.ButtonsToSit = {KEY_LALT, KEY_E}
function lia.sit.checkValidRotation(pos, surfaceAng, rotation)
    if not isnumber(rotation) then return false end
    local rad = math.rad(rotation)
    local dir = Vector(math.cos(rad), math.sin(rad), 0)
    local players = player.GetAll()
    local verticalTrace = util.TraceLine({
        start = pos - dir * 19.5 + surfaceAng:Forward() * 5,
        endpos = pos - dir * 19.5 + surfaceAng:Forward() * -160,
        filter = players
    })

    local horizontalTrace = util.TraceLine({
        start = pos + Vector(0, 0, 5),
        endpos = pos + Vector(0, 0, 5) - dir * 1600,
        filter = players
    })
    return horizontalTrace.StartPos:Distance(horizontalTrace.HitPos) > 20 and verticalTrace.StartPos:Distance(verticalTrace.HitPos) > 14
end

if SERVER then
    util.AddNetworkString("lia.sit.sitFacing")
    local pitchOffset = Angle(270, 0, 0)
    local optimalOffset = Vector(0, 0, 5)
    local optimalOffsetHeight = Vector(0, 0, -20)
    concommand.Add("sit", function(ply)
        local curTime = CurTime()
        local steamID = ply:SteamID64()
        if not lia.sit.cooldown[steamID] then lia.sit.cooldown[steamID] = 0 end
        if lia.sit.cooldown[steamID] > curTime then return end
        lia.sit.cooldown[steamID] = curTime + 0.5
        local eyeTrace = ply:GetEyeTrace()
        local pos = eyeTrace.HitPos
        local ent = eyeTrace.Entity
        local pitch = (eyeTrace.HitNormal:Angle() - pitchOffset).pitch
        local canSit, optimalRotation = lia.sit.canSitHere(ply, pos, pitch, ent)
        if not canSit then return end
        lia.sit.sit(ply, pos, ent:IsWorld() and NULL or ent, optimalRotation, pitch)
    end)

    function lia.sit.optimalRotation(pos)
        local allPly = player.GetAll()
        local furthest
        for i = 0, 360, 45 do
            local rad = math.rad(i)
            local dir = Vector(math.cos(rad), math.sin(rad), 0)
            local startPos = pos + dir * lia.sit.config.CircleBuffer + optimalOffset
            local trace = util.QuickTrace(startPos, optimalOffsetHeight, allPly)
            if trace.Hit then continue end
            local traceToStart = util.QuickTrace(startPos + (-optimalOffset * 1.2), dir * -lia.sit.config.CircleBuffer, allPly)
            traceToStart.rotation = i
            if not furthest then
                furthest = traceToStart
                continue
            end

            if furthest.HitPos:Distance(furthest.StartPos) < traceToStart.HitPos:Distance(traceToStart.StartPos) then furthest = traceToStart end
        end

        if not furthest then return false end
        return furthest.rotation
    end

    function lia.sit.canSitHere(ply, pos, pitch, ent)
        if ply:GetPos():DistToSqr(pos) > lia.sit.config.MaxDistance then return false end
        if ent:IsPlayer() then return false end
        if pitch > lia.sit.config.MaxPitch then return false end
        if pitch < -lia.sit.config.MaxPitch then return false end
        local canSit, sitRotation = hook.Run("ShouldAllowSit", ply, pos, pitch, ent)
        if not (canSit == nil) then return canSit, sitRotation or lia.sit.optimalRotation(pos) or 0 end
        local rotation = lia.sit.optimalRotation(pos)
        if not rotation then return false end
        return true, rotation
    end

    function lia.sit.sit(ply, pos, ent, rotation, pitch, manualFacing)
        local chair = ents.Create("prop_vehicle_prisoner_pod")
        chair.liaSit = true
        if IsValid(ent) and not ent:IsWorld() then
            chair:SetParent(ent)
            ply:DropObject()
        end

        chair:SetModel("models/nova/airboat_seat.mdl")
        chair:SetPos(pos - optimalOffset)
        local chairYaw = manualFacing and rotation + 90 or rotation - 90
        local ang = Angle(0, chairYaw, 0)
        ang:RotateAroundAxis(ang:Forward(), pitch)
        chair:SetAngles(ang)
        chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
        chair:Spawn()
        chair:Activate()
        chair:SetVehicleClass("Seat_Airboat")
        chair:SetNotSolid(true)
        ent.liaSitChair = chair
        chair:CallOnRemove("UnTie", function(entChair)
            local parent = entChair:GetParent()
            if IsValid(parent) then parent.liaSitChair = nil end
        end)

        local phys = chair:GetPhysicsObject()
        if IsValid(phys) then
            phys:Sleep()
            phys:EnableGravity(false)
            phys:EnableMotion(false)
            phys:EnableCollisions(false)
            phys:SetMass(1)
        end

        chair:SetColor(Color(0, 0, 0, 0))
        chair:SetRenderMode(RENDERMODE_TRANSALPHA)
        chair:DrawShadow(false)
        chair.PhysgunDisabled = true
        chair.m_tblToolsAllowed = {}
        chair.customCheck = function() return false end
        chair:SetCollisionGroup(COLLISION_GROUP_WORLD)
        ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        chair.SIMPIdealLeaveSpace = ply:GetPos()
        ply:EnterVehicle(chair)
        if manualFacing then
            ply:SetEyeAngles(Angle(0, rotation, 0))
        else
            ply:SetEyeAngles(Angle(0, 90, 0))
        end
    end

    net.Receive("lia.sit.sitFacing", function(_, ply)
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
        if ply:GetPos():DistToSqr(pos) > lia.sit.config.MaxDistance then return end
        if IsValid(ent) and ent:IsPlayer() then return end
        if pitch > lia.sit.config.MaxPitch then return end
        if pitch < -lia.sit.config.MaxPitch then return end
        local canSit, sitRotation = hook.Run("ShouldAllowSit", ply, pos, pitch, ent)
        if canSit == false then return end
        local rotation = math.NormalizeAngle(wantedRotation)
        local manualFacing = true
        if isnumber(sitRotation) then
            rotation = sitRotation
            manualFacing = false
        elseif not lia.sit.checkValidRotation(pos, eyeTrace.HitNormal:Angle(), rotation) then
            return
        end

        lia.sit.sit(ply, pos, IsValid(ent) and not ent:IsWorld() and ent or NULL, rotation, pitch, manualFacing)
    end)

    hook.Add("PlayerLeaveVehicle", "lia.sit.remove", function(ply, chair)
        if not IsValid(chair) then return end
        if not chair.liaSit then return end
        local idealLeaveSpace = chair.SIMPIdealLeaveSpace
        chair:Remove()
        if idealLeaveSpace:DistToSqr(chair:GetPos()) < lia.sit.config.MaxIdealLeaveDistance then ply:SetPos(idealLeaveSpace) end
    end)

    hook.Add("PlayerDisconnected", "lia.sit.remove", function(ply)
        local chair = ply:GetVehicle()
        if not IsValid(chair) then return end
        if not chair.liaSit then return end
        chair:Remove()
    end)

    hook.Add("CanUndo", "lia.sit.antiAbuse", function(ply, tUndo)
        if isstring(tUndo.Name) and string.lower(tUndo.Name):find("precision") then
            local fn = tUndo.Functions[1]
            local data = fn and fn[2]
            local ent = data and data[1]
            if IsValid(ent) and IsValid(ent.liaSitChair) then return false end
        end
    end)

    hook.Add("CanTool", "lia.sit.antiAbuse", function(ply, tr, toolname, tool, button)
        local trEnt = tr.Entity
        if IsValid(trEnt) and IsValid(trEnt.liaSitChair) then return false end
    end)

    hook.Add("PhysgunPickup", "lia.sit.antiAbuse", function(ply, trEnt) if IsValid(trEnt) and IsValid(trEnt.liaSitChair) then return false end end)
else
    local tag = "lia.sit."
    local arrow = Material("widgets/arrow.png")
    local white = Color(255, 255, 255, 255)
    local red = Color(255, 0, 0, 255)
    local drawScale = 0.1
    local traceDistance = 20
    local traceScaled = traceDistance / drawScale
    local currentSit
    local function CanUseSit(ply)
        if not IsValid(ply) then return false end
        if IsValid(ply:GetVehicle()) then return false end
        return true
    end

    local function GetTriggerButton()
        local buttons = lia.sit.config.ButtonsToSit
        return buttons[#buttons]
    end

    local function AreModifierButtonsDown()
        local buttons = lia.sit.config.ButtonsToSit
        if #buttons < 2 then return true end
        for i = 1, #buttons - 1 do
            if not input.IsButtonDown(buttons[i]) then return false end
        end
        return true
    end

    local function RemovePreview()
        hook.Remove("PostDrawOpaqueRenderables", tag .. "PostDrawOpaqueRenderables")
    end

    local function StartSit(trace)
        local wantedRotation
        local start = CurTime()
        local ply = LocalPlayer()
        hook.Add("PostDrawOpaqueRenderables", tag .. "PostDrawOpaqueRenderables", function()
            if CurTime() - start <= 0.25 then return end
            if not CanUseSit(ply) then
                wantedRotation = nil
                RemovePreview()
                return
            end

            local vec = util.IntersectRayWithPlane(ply:EyePos(), ply:EyeAngles():Forward(), trace.HitPos, Vector(0, 0, 1))
            if not vec or vec:DistToSqr(trace.HitPos) < 4 then
                local fallbackDirection = Angle(0, ply:EyeAngles().y, 0):Forward()
                vec = trace.HitPos + fallbackDirection * traceDistance
            end

            local posOnPlane = WorldToLocal(vec, Angle(0, 90, 0), trace.HitPos, Angle(0, 0, 0))
            local testVec = posOnPlane:GetNormal() * traceScaled
            local currentAng = (trace.HitPos - vec):Angle()
            local goodSit = lia.sit.checkValidRotation(trace.HitPos, trace.HitNormal:Angle(), currentAng.y)
            if goodSit then
                wantedRotation = currentAng.y
            else
                wantedRotation = nil
            end

            cam.Start3D2D(trace.HitPos + Vector(0, 0, 1), Angle(0, 0, 0), drawScale)
            surface.SetDrawColor(goodSit and white or red)
            surface.SetMaterial(arrow)
            surface.DrawTexturedRectRotated(testVec.x * 0.5, testVec.y * -0.5, 2 / drawScale, traceScaled, currentAng.y + 90)
            cam.End3D2D()
        end)
        return function()
            RemovePreview()
            if not CanUseSit(ply) then return end
            if CurTime() - start < 0.25 then
                RunConsoleCommand("sit")
                return
            end

            if not wantedRotation then return end
            local traceDirection = trace.HitPos - trace.StartPos
            if traceDirection:LengthSqr() <= 0 then return end
            traceDirection:Normalize()
            net.Start("lia.sit.sitFacing")
            net.WriteFloat(wantedRotation)
            net.WriteVector(traceDirection)
            net.SendToServer()
        end
    end

    hook.Add("PlayerButtonDown", "lia.sit.keyPress", function(ply, button)
        if not game.SinglePlayer() and not IsFirstTimePredicted() then return end
        if ply ~= LocalPlayer() then return end
        if button ~= GetTriggerButton() then return end
        if currentSit then return end
        if not CanUseSit(ply) then return end
        if not AreModifierButtonsDown() then return end
        local trace = ply:GetEyeTrace()
        if not trace.Hit then return end
        currentSit = StartSit(table.Copy(trace))
    end)

    hook.Add("PlayerButtonUp", "lia.sit.keyRelease", function(ply, button)
        if not game.SinglePlayer() and not IsFirstTimePredicted() then return end
        if ply ~= LocalPlayer() then return end
        if button ~= GetTriggerButton() then return end
        if not currentSit then return end
        local finishSit = currentSit
        currentSit = nil
        finishSit()
    end)
end