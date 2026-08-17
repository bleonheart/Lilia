SIMPSit.Config.Debug = false
SIMPSit.Config.MaxDistance = 10000
SIMPSit.Config.MaxPitch = 10
SIMPSit.Config.CircleBuffer = 15
SIMPSit.Config.MaxIdealLeaveDistance = 50000
SIMPSit.Config.ButtonsToSit = {KEY_LALT, KEY_E}
SIMPSit.Core = SIMPSit.Core or {}
SIMPSit.Cooldown = SIMPSit.Cooldown or {}
function SIMPSit.Core.CanUseSystem(ply)
    if not IsValid(ply) then return false end
    if not ply:IsPlayer() then return false end
    return hook.Run("CanUseSIMPSit", ply) ~= false
end

local quickSitKeybindRegistered = false
local function RegisterQuickSitKeybind()
    if quickSitKeybindRegistered then return end
    if not lia then return end
    if not lia.keybind then return end
    if not lia.keybind.add then return end
    quickSitKeybindRegistered = true
    lia.keybind.add("quickSit", {
        keyBind = KEY_NONE,
        desc = "Quick Sit",
        category = "misc",
        shouldRun = function(client)
            if not IsValid(client) then return false end
            if not client:Alive() then return false end
            if IsValid(client:GetVehicle()) then return false end
            if not SIMPSit.Core.CanUseSystem(client) then return false end
            return true
        end,
        onPress = function(client)
            if SERVER then return end
            if not IsValid(client) then return end
            if not SIMPSit.Core.CanUseSystem(client) then return end
            RunConsoleCommand("sit")
        end
    })
end

RegisterQuickSitKeybind()
hook.Add("OnGamemodeLoaded", "SIMPSit:RegisterQuickSitKeybind", function() RegisterQuickSitKeybind() end)
if SERVER then
    util.AddNetworkString("SIMPSit:PreviewRequest")
    util.AddNetworkString("SIMPSit:PreviewData")
    local pitchOffset = Angle(270, 0, 0)
    local optimalOffset = Vector(0, 0, 5)
    local optimalOffsetHeight = Vector(0, 0, -20)
    local function SendInvalidPreview(ply)
        net.Start("SIMPSit:PreviewData")
        net.WriteBool(false)
        net.WriteVector(vector_origin)
        net.WriteFloat(0)
        net.Send(ply)
    end

    local function TrySit(ply)
        if not IsValid(ply) then return end
        if not ply:Alive() then return end
        if IsValid(ply:GetVehicle()) then return end
        if not SIMPSit.Core.CanUseSystem(ply) then return end
        local curTime = CurTime()
        local steamID = ply:SteamID64()
        SIMPSit.Cooldown[steamID] = SIMPSit.Cooldown[steamID] or 0
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
    end

    concommand.Add("sit", function(ply) TrySit(ply) end)
    net.Receive("SIMPSit:PreviewRequest", function(_, ply)
        if not IsValid(ply) then return end
        if not SIMPSit.Core.CanUseSystem(ply) then
            SendInvalidPreview(ply)
            return
        end

        if not ply:Alive() then
            SendInvalidPreview(ply)
            return
        end

        if IsValid(ply:GetVehicle()) then
            SendInvalidPreview(ply)
            return
        end

        local curTime = CurTime()
        if (ply.SIMPSitNextPreviewRequest or 0) > curTime then return end
        ply.SIMPSitNextPreviewRequest = curTime + 0.08
        local eyeTrace = ply:GetEyeTrace()
        local pos = eyeTrace.HitPos
        local ent = eyeTrace.Entity
        local pitch = (eyeTrace.HitNormal:Angle() - pitchOffset).pitch
        local canSit, optimalRotation = SIMPSit.Core.CanSitHere(ply, pos, pitch, ent)
        net.Start("SIMPSit:PreviewData")
        net.WriteBool(canSit == true)
        net.WriteVector(pos)
        net.WriteFloat(isnumber(optimalRotation) and optimalRotation or 0)
        net.Send(ply)
    end)

    function SIMPSit.Core.OptimalRotation(pos)
        local allPly = player.GetAll()
        local furthest
        for i = 0, 360, 45 do
            local rad = math.rad(i)
            local dir = Vector(math.cos(rad), math.sin(rad), 0)
            local startPos = pos + dir * SIMPSit.Config.CircleBuffer + optimalOffset
            local trace = util.QuickTrace(startPos, optimalOffsetHeight, allPly)
            if SIMPSit.Config.Debug then debugoverlay.Line(startPos, startPos + optimalOffsetHeight, 5, trace.Hit and Color(255, 0, 0) or Color(0, 255, 0), true) end
            if trace.Hit then continue end
            local traceStart = startPos + (-optimalOffset * 1.2)
            local traceToStart = util.QuickTrace(traceStart, dir * -SIMPSit.Config.CircleBuffer, allPly)
            traceToStart.rotation = i
            if SIMPSit.Config.Debug then debugoverlay.Line(traceStart, traceStart + dir * -SIMPSit.Config.CircleBuffer, 5, Color(0, 0, 255), true) end
            if not furthest then
                furthest = traceToStart
                continue
            end

            local furthestDistance = furthest.HitPos:Distance(furthest.StartPos)
            local currentDistance = traceToStart.HitPos:Distance(traceToStart.StartPos)
            if furthestDistance < currentDistance then furthest = traceToStart end
        end

        if not furthest then return false end
        return furthest.rotation
    end

    function SIMPSit.Core.CanSitHere(ply, pos, pitch, ent)
        if not SIMPSit.Core.CanUseSystem(ply) then return false end
        if ply:GetPos():DistToSqr(pos) > SIMPSit.Config.MaxDistance then return false end
        if IsValid(ent) and ent:IsPlayer() then return false end
        if pitch > SIMPSit.Config.MaxPitch then return false end
        if pitch < -SIMPSit.Config.MaxPitch then return false end
        local canSit, sitRotation = hook.Run("ShouldAllowSit", ply, pos, pitch, ent)
        if canSit ~= nil then
            if not canSit then return false end
            return true, sitRotation or SIMPSit.Core.OptimalRotation(pos) or 0
        end

        local rotation = SIMPSit.Core.OptimalRotation(pos)
        if rotation == false then return false end
        return true, rotation
    end

    function SIMPSit.Core.Sit(ply, pos, ent, rotation, pitch)
        if not SIMPSit.Core.CanUseSystem(ply) then return end
        if not IsValid(ply) then return end
        if IsValid(ply:GetVehicle()) then return end
        local chair = ents.Create("prop_vehicle_prisoner_pod")
        if not IsValid(chair) then return end
        chair.SIMPSit = true
        if IsValid(ent) and not ent:IsWorld() then
            chair:SetParent(ent)
            ply:DropObject()
        end

        chair:SetModel("models/nova/airboat_seat.mdl")
        chair:SetPos(pos - optimalOffset)
        local ang = Angle(0, rotation - 90, 0)
        ang:RotateAroundAxis(ang:Forward(), pitch)
        chair:SetAngles(ang)
        chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
        chair:Spawn()
        chair:Activate()
        chair:SetVehicleClass("Seat_Airboat")
        if not SIMPSit.Config.Debug then chair:SetNotSolid(true) end
        if IsValid(ent) then ent.SIMPSitChair = chair end
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
        ply:SetEyeAngles(Angle(0, 90, 0))
    end

    hook.Add("PlayerLeaveVehicle", "SIMPSit:Remove", function(ply, chair)
        if not IsValid(chair) then return end
        if not chair.SIMPSit then return end
        local idealLeaveSpace = chair.SIMPIdealLeaveSpace
        local chairPos = chair:GetPos()
        chair:Remove()
        if not idealLeaveSpace then return end
        if idealLeaveSpace:DistToSqr(chairPos) < SIMPSit.Config.MaxIdealLeaveDistance then ply:SetPos(idealLeaveSpace) end
    end)

    hook.Add("PlayerDisconnected", "SIMPSit:Remove", function(ply)
        local chair = ply:GetVehicle()
        if not IsValid(chair) then return end
        if not chair.SIMPSit then return end
        chair:Remove()
    end)

    hook.Add("CanUndo", "SIMPSit:AntiAbuse", function(_, tUndo)
        if not isstring(tUndo.Name) then return end
        if not string.lower(tUndo.Name):find("precision", 1, true) then return end
        local fn = tUndo.Functions[1]
        local data = fn and fn[2]
        local ent = data and data[1]
        if IsValid(ent) and IsValid(ent.SIMPSitChair) then return false end
    end)

    hook.Add("CanTool", "SIMPSit:AntiAbuse", function(_, tr)
        local ent = tr.Entity
        if IsValid(ent) and IsValid(ent.SIMPSitChair) then return false end
    end)

    hook.Add("PhysgunPickup", "SIMPSit:AntiAbuse", function(_, ent) if IsValid(ent) and IsValid(ent.SIMPSitChair) then return false end end)
else
    local arrowMaterial = Material("widgets/arrow.png", "smooth")
    local previewPos
    local previewRotation = 0
    local previewValid = false
    local previewReceivedAt = 0
    local nextPreviewRequest = 0
    local function IsPreviewKeyDown()
        local buttons = SIMPSit.Config.ButtonsToSit
        if #buttons < 2 then return false end
        for i = 1, #buttons - 1 do
            if not input.IsButtonDown(buttons[i]) then return false end
        end
        return true
    end

    local function CanShowPreview()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        if not ply:Alive() then return false end
        if IsValid(ply:GetVehicle()) then return false end
        if not SIMPSit.Core.CanUseSystem(ply) then return false end
        if not IsPreviewKeyDown() then return false end
        return true
    end

    net.Receive("SIMPSit:PreviewData", function()
        previewValid = net.ReadBool()
        previewPos = net.ReadVector()
        previewRotation = net.ReadFloat()
        previewReceivedAt = RealTime()
    end)

    hook.Add("Think", "SIMPSit:PreviewThink", function()
        if not CanShowPreview() then
            previewValid = false
            previewPos = nil
            return
        end

        local curTime = RealTime()
        if nextPreviewRequest > curTime then return end
        nextPreviewRequest = curTime + 0.08
        net.Start("SIMPSit:PreviewRequest")
        net.SendToServer()
    end)

    hook.Add("PostDrawOpaqueRenderables", "SIMPSit:PreviewArrow", function(_, skybox)
        if skybox then return end
        if not previewValid then return end
        if not previewPos then return end
        if not CanShowPreview() then return end
        if RealTime() - previewReceivedAt > 0.25 then return end
        local direction = Angle(0, previewRotation, 0):Forward()
        local arrowPos = previewPos + direction * 8 + Vector(0, 0, 1)
        cam.Start3D2D(arrowPos, Angle(0, 0, 0), 0.1)
        surface.SetMaterial(arrowMaterial)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(0, 0, 72, 72, previewRotation + 90)
        cam.End3D2D()
    end)

    hook.Add("PlayerButtonDown", "SIMPSit:KeyPress", function(_, button)
        if not game.SinglePlayer() and not IsFirstTimePredicted() then return end
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        if not SIMPSit.Core.CanUseSystem(ply) then return end
        if IsValid(ply:GetVehicle()) then return end
        if not table.HasValue(SIMPSit.Config.ButtonsToSit, button) then return end
        for _, key in ipairs(SIMPSit.Config.ButtonsToSit) do
            if not input.IsButtonDown(key) then return end
            if SIMPSit.Config.Debug then print("[SIMPSIT]", key, "is currently pressed") end
        end

        RunConsoleCommand("sit")
    end)
end