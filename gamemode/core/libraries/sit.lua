SIMPSit.Config.Debug = false
SIMPSit.Config.MaxDistance = 10000
SIMPSit.Config.MaxPitch = 10
SIMPSit.Config.CircleBuffer = 15
SIMPSit.Config.MaxIdealLeaveDistance = 50000
SIMPSit.Config.ButtonsToSit = {KEY_LALT, KEY_E}
function SIMPSit.Core.CheckValidRotation(pos, surfaceAng, rotation)
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
    util.AddNetworkString("SIMPSit:SitFacing")
    local pitchOffset = Angle(270, 0, 0)
    local optimalOffset = Vector(0, 0, 5)
    local optimalOffsetHeight = Vector(0, 0, -20)
    concommand.Add("sit", function(ply)
        local curTime = CurTime()
        local steamID = ply:SteamID64()
        if not SIMPSit.Cooldown[steamID] then SIMPSit.Cooldown[steamID] = 0 end
        if SIMPSit.Cooldown[steamID] > curTime then return end
        SIMPSit.Cooldown[steamID] = curTime + 0.5
        local eyeTrace = ply:GetEyeTrace()
        local pos = eyeTrace.HitPos
        local ent = eyeTrace.Entity
        local pitch = (eyeTrace.HitNormal:Angle() - pitchOffset).pitch
        local canSit, optimalRotation = SIMPSit.Core.CanSitHere(ply, pos, pitch, ent)
        if not canSit then
            if SIMPSit.Config.Debug then print("[SIMPSIT]", ply, "attempted to sit but could not find a suitable location.") end
            return
        end

        SIMPSit.Core.Sit(ply, pos, ent:IsWorld() and NULL or ent, optimalRotation, pitch)
    end)

    function SIMPSit.Core.OptimalRotation(pos)
        local allPly = player.GetAll()
        local furthest
        for i = 0, 360, 45 do
            local rad = math.rad(i)
            local dir = Vector(math.cos(rad), math.sin(rad), 0)
            local startPos = pos + dir * SIMPSit.Config.CircleBuffer + optimalOffset
            local trace = util.QuickTrace(startPos, optimalOffsetHeight, allPly)
            if SIMPSit.Config.Debug then
                if not trace.Hit then
                    debugoverlay.Line(startPos, startPos + optimalOffsetHeight, 5, Color(0, 255, 0), true)
                else
                    debugoverlay.Line(startPos, startPos + optimalOffsetHeight, 5, Color(255, 0, 0), true)
                end
            end

            if trace.Hit then continue end
            local traceToStart = util.QuickTrace(startPos + (-optimalOffset * 1.2), dir * -SIMPSit.Config.CircleBuffer, allPly)
            traceToStart.rotation = i
            if SIMPSit.Config.Debug then debugoverlay.Line(startPos + (-optimalOffset * 1.2), startPos + (-optimalOffset * 1.2) + (dir * -SIMPSit.Config.CircleBuffer), 5, Color(0, 0, 255), true) end
            if not furthest then
                furthest = traceToStart
                continue
            end

            if furthest.HitPos:Distance(furthest.StartPos) < traceToStart.HitPos:Distance(traceToStart.StartPos) then furthest = traceToStart end
        end

        if not furthest then return false end
        return furthest.rotation
    end

    function SIMPSit.Core.CanSitHere(ply, pos, pitch, ent)
        if ply:GetPos():DistToSqr(pos) > SIMPSit.Config.MaxDistance then return false end
        if ent:IsPlayer() then return false end
        if pitch > SIMPSit.Config.MaxPitch then return false end
        if pitch < -SIMPSit.Config.MaxPitch then return false end
        local canSit, sitRotation = hook.Run("ShouldAllowSit", ply, pos, pitch, ent)
        if not (canSit == nil) then return canSit, sitRotation or SIMPSit.Core.OptimalRotation(pos) or 0 end
        local rotation = SIMPSit.Core.OptimalRotation(pos)
        if not rotation then return false end
        return true, rotation
    end

    function SIMPSit.Core.Sit(ply, pos, ent, rotation, pitch, manualFacing)
        local chair = ents.Create("prop_vehicle_prisoner_pod")
        chair.SIMPSit = true
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
        if not SIMPSit.Config.Debug then chair:SetNotSolid(true) end
        ent.SIMPSitChair = chair
        chair:CallOnRemove("UnTie", function(entChair)
            local parent = entChair:GetParent()
            if IsValid(parent) then parent.SIMPSitChair = nil end
        end)

        local phys = chair:GetPhysicsObject()
        if IsValid(phys) then
            phys:Sleep()
            phys:EnableGravity(false)
            phys:EnableMotion(false)
            phys:EnableCollisions(false)
            phys:SetMass(1)
        end

        if not SIMPSit.Config.Debug then
            chair:SetColor(Color(0, 0, 0, 0))
            chair:SetRenderMode(RENDERMODE_TRANSALPHA)
            chair:DrawShadow(false)
        end

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

    net.Receive("SIMPSit:SitFacing", function(_, ply)
        local curTime = CurTime()
        local steamID = ply:SteamID64()
        if not SIMPSit.Cooldown[steamID] then SIMPSit.Cooldown[steamID] = 0 end
        if SIMPSit.Cooldown[steamID] > curTime then return end
        SIMPSit.Cooldown[steamID] = curTime + 0.5
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
        if ply:GetPos():DistToSqr(pos) > SIMPSit.Config.MaxDistance then return end
        if IsValid(ent) and ent:IsPlayer() then return end
        if pitch > SIMPSit.Config.MaxPitch then return end
        if pitch < -SIMPSit.Config.MaxPitch then return end
        local canSit, sitRotation = hook.Run("ShouldAllowSit", ply, pos, pitch, ent)
        if canSit == false then return end
        local rotation = math.NormalizeAngle(wantedRotation)
        local manualFacing = true
        if isnumber(sitRotation) then
            rotation = sitRotation
            manualFacing = false
        elseif not SIMPSit.Core.CheckValidRotation(pos, eyeTrace.HitNormal:Angle(), rotation) then
            return
        end

        SIMPSit.Core.Sit(ply, pos, IsValid(ent) and not ent:IsWorld() and ent or NULL, rotation, pitch, manualFacing)
    end)

    hook.Add("PlayerLeaveVehicle", "SIMPSit:Remove", function(ply, chair)
        if not IsValid(chair) then return end
        if not chair.SIMPSit then return end
        local idealLeaveSpace = chair.SIMPIdealLeaveSpace
        chair:Remove()
        if idealLeaveSpace:DistToSqr(chair:GetPos()) < SIMPSit.Config.MaxIdealLeaveDistance then ply:SetPos(idealLeaveSpace) end
    end)

    hook.Add("PlayerDisconnected", "SIMPSit:Remove", function(ply)
        local chair = ply:GetVehicle()
        if not IsValid(chair) then return end
        if not chair.SIMPSit then return end
        chair:Remove()
    end)

    hook.Add("CanUndo", "SIMPSit:AntiAbuse", function(ply, tUndo)
        if isstring(tUndo.Name) and string.lower(tUndo.Name):find("precision") then
            local fn = tUndo.Functions[1]
            local data = fn and fn[2]
            local ent = data and data[1]
            if IsValid(ent) and IsValid(ent.SIMPSitChair) then return false end
        end
    end)

    hook.Add("CanTool", "SIMPSit:AntiAbuse", function(ply, tr, toolname, tool, button)
        local trEnt = tr.Entity
        if IsValid(trEnt) and IsValid(trEnt.SIMPSitChair) then return false end
    end)

    hook.Add("PhysgunPickup", "SIMPSit:AntiAbuse", function(ply, trEnt) if IsValid(trEnt) and IsValid(trEnt.SIMPSitChair) then return false end end)
else
    local tag = "SIMPSit:"
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
        local buttons = SIMPSit.Config.ButtonsToSit
        return buttons[#buttons]
    end

    local function AreModifierButtonsDown()
        local buttons = SIMPSit.Config.ButtonsToSit
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
            local goodSit = SIMPSit.Core.CheckValidRotation(trace.HitPos, trace.HitNormal:Angle(), currentAng.y)
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
            net.Start("SIMPSit:SitFacing")
            net.WriteFloat(wantedRotation)
            net.WriteVector(traceDirection)
            net.SendToServer()
        end
    end

    hook.Add("PlayerButtonDown", "SIMPSit:KeyPress", function(ply, button)
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

    hook.Add("PlayerButtonUp", "SIMPSit:KeyRelease", function(ply, button)
        if not game.SinglePlayer() and not IsFirstTimePredicted() then return end
        if ply ~= LocalPlayer() then return end
        if button ~= GetTriggerButton() then return end
        if not currentSit then return end
        local finishSit = currentSit
        currentSit = nil
        finishSit()
    end)
end