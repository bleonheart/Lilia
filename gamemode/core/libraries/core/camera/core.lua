lia.camera = lia.camera or {}
local function cameraPreviewAngle(client)
    local eyeAngles = IsValid(client) and client:EyeAngles() or angle_zero
    return Angle(0, eyeAngles.y + 180, 0)
end

local function cameraGroundPosition(pos, filter)
    if not isvector(pos) then return pos end
    local tr = util.TraceLine({
        start = pos + Vector(0, 0, 64),
        endpos = pos + Vector(0, 0, -16384),
        mask = MASK_SOLID,
        filter = filter
    })
    return tr.Hit and tr.HitWorld and not tr.HitSky and tr.HitPos + Vector(0, 0, 2) or pos
end

local function cameraPreviewPosition(client)
    if not IsValid(client) then return Vector() end
    local forward = client:EyeAngles():Forward()
    forward.z = 0
    if forward:LengthSqr() <= 0 then
        forward = Vector(1, 0, 0)
    else
        forward:Normalize()
    end

    local eyePos = client:EyePos()
    local hull = util.TraceHull({
        start = eyePos,
        endpos = eyePos + forward * 96,
        mins = Vector(-16, -16, 0),
        maxs = Vector(16, 16, 72),
        filter = client,
        mask = MASK_SOLID
    })
    return cameraGroundPosition(hull.Hit and hull.HitPos - forward * 28 or client:GetPos() + forward * 85, client)
end

local function cameraApplyIdle(ent)
    if not IsValid(ent) then return end
    local seq = ent:LookupSequence("idle_all_01")
    if seq <= 0 then seq = ent:SelectWeightedSequence(ACT_IDLE) end
    if seq <= 0 then seq = ent:LookupSequence("idle_unarmed") end
    if seq > 0 then
        ent:ResetSequence(seq)
        ent:SetCycle(0)
        return
    end

    for _, name in ipairs(ent:GetSequenceList()) do
        local lowered = name:lower()
        if lowered ~= "idlenoise" and (lowered:find("idle") or lowered:find("fly")) then
            ent:ResetSequence(name)
            ent:SetCycle(0)
            return
        end
    end
end

function lia.camera.shouldHidePlayer(player)
    local owner = lia.camera.activeOwner
    local data = IsValid(owner) and owner._liaViewPreview
    return data and istable(data.hiddenPlayers) and data.hiddenPlayers[player] or false
end

function lia.camera.close(owner)
    if not owner then return end
    local data = owner._liaViewPreview
    if not data then return end
    for _, hookName in ipairs({"CalcView", "PostDrawOpaqueRenderables", "PrePlayerDraw", "ShouldDrawLocalPlayer"}) do
        hook.Remove(hookName, data[hookName == "CalcView" and "calcViewHook" or hookName == "PostDrawOpaqueRenderables" and "renderHook" or hookName == "PrePlayerDraw" and "prePlayerDrawHook" or "shouldDrawLocalPlayerHook"])
    end

    if IsValid(data.entity) then data.entity:Remove() end
    for ent, noDraw in pairs(data.hiddenEntities or {}) do
        if IsValid(ent) then ent:SetNoDraw(noDraw) end
    end

    for player, state in pairs(data.hiddenPlayerState or {}) do
        if IsValid(player) then
            player:SetNoDraw(state.noDraw == true)
            if state.hadEffect then
                player:AddEffects(EF_NODRAW)
            else
                player:RemoveEffects(EF_NODRAW)
            end
        end
    end

    if lia.camera.activeOwner == owner then lia.camera.activeOwner = nil end
    owner._liaViewPreview = nil
end

function lia.camera.begin(owner, config)
    if not IsValid(owner) then return end
    if IsValid(lia.camera.activeOwner) and lia.camera.activeOwner ~= owner then lia.camera.close(lia.camera.activeOwner) end
    lia.camera.close(owner)
    local data = {
        config = config or {},
        calcViewHook = "liaCameraPreviewCalcView" .. tostring(owner),
        renderHook = "liaCameraPreviewRender" .. tostring(owner),
        prePlayerDrawHook = "liaCameraPreviewPrePlayerDraw" .. tostring(owner),
        shouldDrawLocalPlayerHook = "liaCameraPreviewShouldDrawLocalPlayer" .. tostring(owner)
    }

    owner._liaViewPreview = data
    lia.camera.activeOwner = owner
    data.hiddenEntities, data.hiddenPlayers, data.hiddenPlayerState = {}, {}, {}
    local processed = {}
    for _, ent in ipairs(istable(data.config.hideEntities) and data.config.hideEntities or {}) do
        if not processed[ent] then
            processed[ent] = true
            if IsValid(ent) then
                if ent:IsPlayer() then
                    data.hiddenPlayers[ent] = true
                    data.hiddenPlayerState[ent] = {
                        noDraw = ent:GetNoDraw(),
                        hadEffect = ent:IsEffectActive(EF_NODRAW)
                    }

                    ent:SetNoDraw(true)
                    ent:AddEffects(EF_NODRAW)
                else
                    data.hiddenEntities[ent] = ent:GetNoDraw()
                    ent:SetNoDraw(true)
                end
            end
        end
    end

    hook.Add("PrePlayerDraw", data.prePlayerDrawHook, function(player)
        local d = IsValid(owner) and owner._liaViewPreview
        if d and (d.hiddenPlayers[player] or d.hiddenEntities[player] ~= nil) then return true end
    end)

    hook.Add("ShouldDrawLocalPlayer", data.shouldDrawLocalPlayerHook, function(player)
        local d = IsValid(owner) and owner._liaViewPreview
        if d and d.hiddenPlayers[IsValid(player) and player or LocalPlayer()] then return false end
    end)

    hook.Add("CalcView", data.calcViewHook, function(_, _, _, fov)
        if not IsValid(owner) then
            lia.camera.close(owner)
            return
        end

        local d, ent = owner._liaViewPreview, owner._liaViewPreview.entity
        if not IsValid(ent) then return end
        local center = ent:GetPos() + Vector(0, 0, d.config.heightOffset or 60)
        local desired = center + ent:GetAngles():Forward() * (d.config.distance or 70)
        d.currentCamPos = d.currentCamPos and LerpVector(FrameTime() * 5, d.currentCamPos, desired) or desired
        local target = center - ent:GetAngles():Right() * (d.config.sideOffset or 40)
        return {
            origin = d.currentCamPos,
            angles = (target - d.currentCamPos):Angle(),
            fov = fov,
            drawviewer = true
        }
    end)

    hook.Add("PostDrawOpaqueRenderables", data.renderHook, function()
        if not IsValid(owner) then
            lia.camera.close(owner)
            return
        end

        local ent = owner._liaViewPreview.entity
        if not IsValid(ent) then return end
        ent:FrameAdvance()
        render.SuppressEngineLighting(true)
        render.ResetModelLighting(1, 1, 1)
        for i = 0, 6 do
            render.SetModelLighting(i, 1, 1, 1)
        end

        ent:DrawModel()
        render.SuppressEngineLighting(false)
        render.ResetModelLighting(1, 1, 1)
        for i = 0, 6 do
            render.SetModelLighting(i, 0, 0, 0)
        end
    end)
end

function lia.camera.setModel(owner, modelPath, options)
    if not IsValid(owner) then return end
    local data = owner._liaViewPreview
    if not data then
        lia.camera.begin(owner, options)
        data = owner._liaViewPreview
    elseif options then
        data.config = options
    end

    if IsValid(data.entity) then data.entity:Remove() end
    data.entity = ClientsideModel(modelPath or "models/error.mdl", RENDERGROUP_OPAQUE)
    if not IsValid(data.entity) then return end
    local config = data.config or {}
    data.entity:SetPos(config.position or cameraPreviewPosition(LocalPlayer()))
    data.entity:SetAngles(config.angle or cameraPreviewAngle(LocalPlayer()))
    data.entity:SetSkin(config.skin or 0)
    if istable(config.bodygroups) then lia.util.applyBodygroups(data.entity, config.bodygroups) end
    hook.Run("SetupPlayerModel", data.entity)
    hook.Run("ModifyCharacterModel", data.entity, config.context)
    cameraApplyIdle(data.entity)
    data.currentCamPos = nil
end

function lia.camera.getEntity(owner)
    local data = IsValid(owner) and owner._liaViewPreview
    return data and data.entity or nil
end

function lia.camera.rotate(owner, deltaYaw)
    local ent = lia.camera.getEntity(owner)
    if not IsValid(ent) then return end
    local ang = ent:GetAngles()
    ang.y = ang.y + deltaYaw
    ent:SetAngles(ang)
end

local view, traceData, traceData2, aimOrigin, crouchFactor, ft, curAng
local clmp = math.Clamp
crouchFactor = 0
local diff, fm, sm
local freelooking = false
local freelookX = 0
local freelookY = 0
local freelookInitialAngles = Angle()
local freelookCurrentAngles = Angle()
local freelookWasHolding = false
local zeroAngle = Angle()
local movementKeys = bit.bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT)
local automaticFreelookSpeedSqr = 25
local freelookMouseThreshold = 0.001
local hiddenBoneScale = Vector(0.001, 0.001, 0.001)
local visibleBoneScale = Vector(1, 1, 1)
local hiddenBoneOffset = Vector(0, 0, 16384)
local visibleBoneOffset = Vector(0, 0, 0)
local maxValues = {
    height = 30,
    horizontal = 30,
    distance = 100
}

function lia.camera.isCharacterMenuOpen()
    return IsValid(lia.gui.loading) or IsValid(lia.gui.char) or IsValid(lia.gui.charCreate) or IsValid(lia.gui.character)
end

function lia.camera.isUsingThirdPersonCamera(client)
    if not IsValid(client) then return false end
    return client:GetViewEntity() == client and lia.camera.canOverrideView(client)
end

function lia.camera.shouldSuppressRealisticView(client)
    if not IsValid(client) then return false end
    return client:KeyDown(IN_ATTACK2)
end

function lia.camera.canOverrideView(client)
    if not IsValid(client) then return false end
    if lia.camera.isCharacterMenuOpen() then return false end
    if IsValid(client:GetVehicle()) then return false end
    if hook.Run("ShouldDisableThirdperson", client) == true then return false end
    local ragdoll = client:GetRagdollEntity()
    return lia.option.get("thirdPersonEnabled", false) and lia.config.get("ThirdPersonEnabled", true) and client:getChar() and not IsValid(ragdoll)
end

function lia.camera.canUseRealisticView(client)
    if not IsValid(client) or client ~= LocalPlayer() then return false end
    if client.IsInAdminEntityView then return false end
    if lia.camera.isCharacterMenuOpen() then return false end
    if not client:getChar() then return false end
    if client:InVehicle() then return false end
    if client:GetViewEntity() ~= client then return false end
    if lia.camera.isUsingThirdPersonCamera(client) then return false end
    if lia.camera.shouldSuppressRealisticView(client) then return false end
    return lia.option.get("realisticViewEnabled", false)
end

function lia.camera.canUseFreelook(client)
    return IsValid(client) and client == LocalPlayer() and lia.option.get("freelookEnabled", false)
end

function lia.camera.isInSights(client)
    local weapon = client:GetActiveWeapon()
    if not IsValid(weapon) then return client:KeyDown(IN_ATTACK2) end
    local inArcCWSights = weapon.ArcCW and ArcCW and weapon.GetState and weapon:GetState() == ArcCW.STATE_SIGHTS
    return lia.option.get("freelookBlockADS", true) and (client:KeyDown(IN_ATTACK2) or weapon.GetInSights and weapon:GetInSights() or inArcCWSights or weapon.GetIronSights and weapon:GetIronSights())
end

function lia.camera.isHoldingFreelookBind(client)
    return IsValid(client) and freelooking
end

function lia.camera.isPlayerStationary(client)
    if not IsValid(client) or client:KeyDown(movementKeys) then return false end
    local velocity = client:GetVelocity()
    return velocity.x * velocity.x + velocity.y * velocity.y <= automaticFreelookSpeedSqr
end

function lia.camera.hasFreelookMouseInput(x, y)
    return math.abs(x or 0) > freelookMouseThreshold or math.abs(y or 0) > freelookMouseThreshold
end

function lia.camera.resetFreelookState()
    freelookX = 0
    freelookY = 0
    freelookCurrentAngles = zeroAngle
end

function lia.camera.beginFreelook(client, automatic)
    freelookInitialAngles = client:EyeAngles()
    freelookInitialAngles.r = 0
    freelookWasHolding = true
end

function lia.camera.endFreelook()
    freelookWasHolding = false
    lia.camera.resetFreelookState()
end

function lia.camera.setManualFreelook(enabled)
    enabled = enabled == true
    if freelooking == enabled then return true end
    if enabled and not lia.camera.canUseFreelook(LocalPlayer()) then return false end
    if hook.Run("PreFreelookToggle", enabled) == false then return false end
    freelooking = enabled
    if not enabled and freelookWasHolding then lia.camera.endFreelook() end
    hook.Run("FreelookToggled", enabled)
    return true
end

function lia.camera.shouldDrawBodyForFreelook(client)
    if not lia.camera.canUseFreelook(client) then return false end
    return freelookWasHolding and (math.abs(freelookCurrentAngles.p) >= 0.05 or math.abs(freelookCurrentAngles.y) >= 0.05)
end

function lia.camera.getFirstPersonHeadBones(client)
    if client.liaFirstPersonHeadBones then return client.liaFirstPersonHeadBones end
    local bones = {}
    local addedBones = {}
    local function addBone(index)
        if index == nil or index < 0 or addedBones[index] then return end
        addedBones[index] = true
        bones[#bones + 1] = index
    end

    for bone = 0, (client:GetBoneCount() or 0) - 1 do
        local boneName = client:GetBoneName(bone)
        if boneName then
            local lowered = boneName:lower()
            if lowered:find("head", 1, true) or lowered:find("neck", 1, true) or lowered:find("collar", 1, true) or lowered:find("clavicle", 1, true) or lowered:find("upperchest", 1, true) then
                addBone(bone)
                local parent = client:GetBoneParent(bone)
                local depth = 0
                while parent and parent >= 0 and depth < 2 do
                    addBone(parent)
                    parent = client:GetBoneParent(parent)
                    depth = depth + 1
                end
            end
        end
    end

    client.liaFirstPersonHeadBones = bones
    return bones
end

function lia.camera.getFirstPersonHeadBoneChildren(client, rootBone)
    local children = {}
    local boneCount = (client:GetBoneCount() or 0) - 1
    for bone = 0, boneCount do
        local parent = client:GetBoneParent(bone)
        while parent and parent >= 0 do
            if parent == rootBone then
                children[#children + 1] = bone
                break
            end

            parent = client:GetBoneParent(parent)
        end
    end
    return children
end

function lia.camera.getParentAttachmentNames(client)
    if client.liaFirstPersonAttachmentNames then return client.liaFirstPersonAttachmentNames end
    local attachmentNames = {}
    for _, attachment in ipairs(client:GetAttachments() or {}) do
        if attachment.id and attachment.name then attachmentNames[attachment.id] = attachment.name:lower() end
    end

    client.liaFirstPersonAttachmentNames = attachmentNames
    return attachmentNames
end

function lia.camera.isHeadAttachmentName(name)
    if not name or name == "" then return false end
    return name:find("head", 1, true) or name:find("eye", 1, true) or name:find("face", 1, true) or name:find("mouth", 1, true) or name:find("neck", 1, true)
end

function lia.camera.isHeadwearModel(model)
    if not model or model == "" then return false end
    model = model:lower()
    return model:find("hat", 1, true) or model:find("mask", 1, true) or model:find("helmet", 1, true) or model:find("head", 1, true) or model:find("face", 1, true)
end

function lia.camera.isHeadBodygroupName(name)
    if not name or name == "" then return false end
    name = name:lower()
    return name:find("head", 1, true) or name:find("face", 1, true) or name:find("mask", 1, true) or name:find("helmet", 1, true) or name:find("hat", 1, true) or name:find("gas", 1, true)
end

function lia.camera.setFirstPersonHeadBodygroupsHidden(client, hidden)
    if not IsValid(client) then return end
    client.liaFirstPersonHiddenBodygroups = client.liaFirstPersonHiddenBodygroups or {}
    if hidden then
        for _, bodygroup in ipairs(client:GetBodyGroups() or {}) do
            if bodygroup.id and lia.camera.isHeadBodygroupName(bodygroup.name) and client.liaFirstPersonHiddenBodygroups[bodygroup.id] == nil then
                client.liaFirstPersonHiddenBodygroups[bodygroup.id] = client:GetBodygroup(bodygroup.id)
                client:SetBodygroup(bodygroup.id, 0)
            end
        end
        return
    end

    for bodygroupID, originalValue in pairs(client.liaFirstPersonHiddenBodygroups) do
        client:SetBodygroup(bodygroupID, originalValue)
        client.liaFirstPersonHiddenBodygroups[bodygroupID] = nil
    end
end

function lia.camera.shouldHideFirstPersonChildEntity(client, entity)
    if not IsValid(client) or not IsValid(entity) or entity == client then return false end
    if entity == client:GetActiveWeapon() or entity == client:GetViewModel() then return false end
    local parent = entity:GetParent()
    if not IsValid(parent) and entity.GetMoveParent then parent = entity:GetMoveParent() end
    if parent ~= client then return false end
    local attachmentID = entity.GetParentAttachment and entity:GetParentAttachment() or 0
    local attachmentName = lia.camera.getParentAttachmentNames(client)[attachmentID]
    if lia.camera.isHeadAttachmentName(attachmentName) then return true end
    if lia.camera.isHeadwearModel(entity:GetModel()) then return true end
    if entity:IsEffectActive(EF_BONEMERGE) and entity:GetPos():DistToSqr(client:EyePos()) <= 1600 then return true end
    return false
end

function lia.camera.setFirstPersonHeadwearHidden(client, hidden)
    if not IsValid(client) then return end
    client.liaFirstPersonHiddenChildren = client.liaFirstPersonHiddenChildren or {}
    if hidden then
        for _, entity in ipairs(ents.GetAll()) do
            if lia.camera.shouldHideFirstPersonChildEntity(client, entity) and client.liaFirstPersonHiddenChildren[entity] == nil then
                client.liaFirstPersonHiddenChildren[entity] = entity:GetNoDraw()
                entity:SetNoDraw(true)
            end
        end
        return
    end

    for entity, wasNoDraw in pairs(client.liaFirstPersonHiddenChildren) do
        if IsValid(entity) then entity:SetNoDraw(wasNoDraw == true) end
        client.liaFirstPersonHiddenChildren[entity] = nil
    end
end

function lia.camera.setFirstPersonHeadHidden(client, hidden)
    if not IsValid(client) then return end
    if client.liaFirstPersonHeadHidden == hidden then return end
    client.liaFirstPersonHeadHidden = hidden
    local headBones = lia.camera.getFirstPersonHeadBones(client)
    local scale = hidden and hiddenBoneScale or visibleBoneScale
    local offset = hidden and hiddenBoneOffset or visibleBoneOffset
    for _, bone in ipairs(headBones) do
        client:ManipulateBoneScale(bone, scale)
        client:ManipulateBonePosition(bone, offset)
        for _, childBone in ipairs(lia.camera.getFirstPersonHeadBoneChildren(client, bone)) do
            client:ManipulateBoneScale(childBone, scale)
            client:ManipulateBonePosition(childBone, offset)
        end
    end

    lia.camera.setFirstPersonHeadBodygroupsHidden(client, hidden)
    lia.camera.setFirstPersonHeadwearHidden(client, hidden)
    client:InvalidateBoneCache()
end

function lia.camera.getFreelookHeadPoseParameters(client)
    local model = client:GetModel() or ""
    if client.liaFreelookHeadPoseModel ~= model then
        client.liaFreelookHeadPoseModel = model
        client.liaFreelookHeadPitchParameter = client:LookupPoseParameter("head_pitch")
        client.liaFreelookHeadYawParameter = client:LookupPoseParameter("head_yaw")
    end
    return client.liaFreelookHeadPitchParameter, client.liaFreelookHeadYawParameter
end

function lia.camera.updateFreelookHead(client)
    if not IsValid(client) then return end
    local active = lia.camera.canUseFreelook(client) and freelookWasHolding
    if not active and not client.liaFreelookHeadActive then return end
    local targetYaw = active and freelookCurrentAngles.y or 0
    local fraction = clmp(FrameTime() * 14, 0, 1)
    client.liaFreelookHeadYaw = Lerp(fraction, client.liaFreelookHeadYaw or 0, targetYaw)
    local pitchParameter, yawParameter = lia.camera.getFreelookHeadPoseParameters(client)
    local changed = false
    if pitchParameter and pitchParameter >= 0 then
        client:SetPoseParameter("head_pitch", 0)
        changed = true
    end

    if yawParameter and yawParameter >= 0 then
        local minimum, maximum = client:GetPoseParameterRange(yawParameter)
        client:SetPoseParameter("head_yaw", clmp(client.liaFreelookHeadYaw, minimum, maximum))
        changed = true
    end

    local centered = math.abs(client.liaFreelookHeadYaw) <= 0.05
    client.liaFreelookHeadActive = active or not centered
    if not client.liaFreelookHeadActive then
        client.liaFreelookHeadYaw = 0
        if yawParameter and yawParameter >= 0 then client:SetPoseParameter("head_yaw", 0) end
    end

    if changed then client:InvalidateBoneCache() end
end

function lia.camera.applyFreelookToAngles(client, angles)
    if not lia.camera.canUseFreelook(client) or not freelooking then
        if freelookWasHolding then lia.camera.endFreelook() end
        return angles
    end

    if not freelookWasHolding then lia.camera.beginFreelook(client, false) end
    local smoothness = clmp(lia.option.get("freelookSmoothness", 1), 0.1, 2)
    freelookCurrentAngles = LerpAngle(0.15 * smoothness, freelookCurrentAngles, Angle(freelookY, -freelookX, 0))
    return angles + freelookCurrentAngles
end

function lia.camera.buildRealisticView(client, origin, angles, fov)
    if IsValid(lia.gui.menu) then return end
    if client:GetMoveType() == MOVETYPE_NOCLIP then return end
    local attachmentID = client:LookupAttachment("eyes")
    local attachment = attachmentID and client:GetAttachment(attachmentID)
    local viewOrigin
    local viewAngles = angles
    if attachment and attachment.Pos and attachment.Ang then
        viewOrigin = attachment.Pos + attachment.Ang:Forward() * 2 + attachment.Ang:Up() * 1.5
        viewAngles = attachment.Ang
    else
        viewOrigin = client:EyePos() + angles:Forward() * 2 + angles:Up() * 1.5
    end
    return {
        origin = viewOrigin,
        angles = lia.camera.applyFreelookToAngles(client, viewAngles),
        fov = fov or 90,
        drawviewer = true
    }
end

function lia.camera.buildFreelookBodyView(client, pos, ang, fov)
    if not lia.camera.shouldDrawBodyForFreelook(client) then return end
    local bodyView = lia.camera.buildRealisticView(client, pos, ang, fov)
    if bodyView then
        bodyView.drawviewer = false
        return bodyView
    end
    return {
        origin = pos,
        angles = lia.camera.applyFreelookToAngles(client, ang),
        fov = fov
    }
end

function lia.camera.calcView(client, pos, ang, fov)
    ft = FrameTime()
    local owner = LocalPlayer()
    if lia.camera.isUsingThirdPersonCamera(client) then
        lia.camera.setFirstPersonHeadHidden(client, false)
        if client:OnGround() and client:KeyDown(IN_DUCK) or client:Crouching() then
            crouchFactor = Lerp(ft * 5, crouchFactor, 1)
        else
            crouchFactor = Lerp(ft * 5, crouchFactor, 0)
        end

        curAng = owner.camAng or Angle(0, 0, 0)
        view = {}
        local viewOffset = client:GetViewOffset()
        local heightOffset = curAng:Up() * clmp(lia.option.get("thirdPersonHeight", 0), 0, maxValues.height)
        local horizontalOffset = curAng:Right() * clmp(lia.option.get("thirdPersonHorizontal", 0), -maxValues.horizontal, maxValues.horizontal)
        local crouchOffset = client:GetViewOffsetDucked() * 0.5 * crouchFactor
        traceData = {}
        traceData.start = client:GetPos() + viewOffset + heightOffset + horizontalOffset - crouchOffset
        traceData.endpos = traceData.start - curAng:Forward() * clmp(lia.option.get("thirdPersonDistance", 0), 0, maxValues.distance)
        traceData.filter = {client}
        traceData.mask = MASK_SOLID_BRUSHONLY
        local isNoclip = client:GetMoveType() == MOVETYPE_NOCLIP
        local traceResult
        if isNoclip then
            view.origin = traceData.endpos
        else
            traceResult = util.TraceLine(traceData)
            local hitDistance = traceData.start:Distance(traceResult.HitPos)
            if traceResult.Hit then
                local minDistanceFromWall = 10
                local direction = (traceData.endpos - traceData.start):GetNormalized()
                local safeDistance = math.max(hitDistance - minDistanceFromWall, minDistanceFromWall)
                view.origin = traceData.start + direction * safeDistance
                local verifyTrace = util.TraceLine({
                    start = traceData.start,
                    endpos = view.origin,
                    filter = {client},
                    mask = MASK_SOLID_BRUSHONLY
                })

                if verifyTrace.Hit then view.origin = verifyTrace.HitPos + verifyTrace.HitNormal * minDistanceFromWall end
            else
                view.origin = traceResult.HitPos
            end
        end

        aimOrigin = view.origin
        view.angles = curAng + client:GetViewPunchAngles()
        if isNoclip then
            client:SetEyeAngles(curAng)
        else
            traceData2 = {}
            traceData2.start = aimOrigin
            traceData2.endpos = aimOrigin + curAng:Forward() * 65535
            traceData2.filter = {client}
            traceData2.mask = MASK_SOLID_BRUSHONLY
            if lia.option.get("thirdPersonClassicMode", false) or owner.isWepRaised and owner:isWepRaised() or owner:KeyDown(bit.bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT)) and owner:GetVelocity():Length() >= 10 then
                local aimTrace = util.TraceLine(traceData2)
                client:SetEyeAngles((aimTrace.HitPos - client:GetShootPos()):Angle())
            end
        end
        return view
    end

    if lia.camera.canUseRealisticView(client) then
        local realisticView = lia.camera.buildRealisticView(client, pos, ang, fov)
        if realisticView then
            lia.camera.setFirstPersonHeadHidden(client, true)
            return realisticView
        end
    end

    local freelookBodyView = lia.camera.buildFreelookBodyView(client, pos, ang, fov)
    if freelookBodyView then
        lia.camera.setFirstPersonHeadHidden(client, true)
        return freelookBodyView
    end

    ang = lia.camera.applyFreelookToAngles(client, ang)
    lia.camera.setFirstPersonHeadHidden(client, false)
    return {
        origin = pos,
        angles = ang,
        fov = fov
    }
end

hook.Add("CreateMove", "liaThirdPersonCreateMove", function(cmd)
    local owner = LocalPlayer()
    if lia.camera.isUsingThirdPersonCamera(owner) and owner:GetMoveType() ~= MOVETYPE_NOCLIP then
        fm = cmd:GetForwardMove()
        sm = cmd:GetSideMove()
        local eyeAngles = owner:EyeAngles()
        local camAng = owner.camAng or Angle(0, 0, 0)
        diff = (eyeAngles - camAng)[2] or 0
        diff = diff / 90
        cmd:SetForwardMove(fm + sm * diff)
        cmd:SetSideMove(sm + fm * diff)
        return false
    end
end)

hook.Add("InputMouseApply", "liaThirdPersonInputMouseApply", function(cmd, x, y)
    local owner = LocalPlayer()
    if not owner.camAng then owner.camAng = Angle(0, 0, 0) end
    if lia.camera.isUsingThirdPersonCamera(owner) then
        owner.camAng.p = clmp(math.NormalizeAngle(owner.camAng.p + y / 50), -85, 85)
        owner.camAng.y = math.NormalizeAngle(owner.camAng.y - x / 50)
        return true
    end

    if not lia.camera.canUseFreelook(owner) or not lia.camera.isHoldingFreelookBind(owner) then
        if freelookWasHolding then lia.camera.endFreelook() end
        return
    end

    if not freelookWasHolding then lia.camera.beginFreelook(owner, false) end
    freelookInitialAngles.z = 0
    cmd:SetViewAngles(freelookInitialAngles)
    local horizontalLimit = lia.option.get("freelookLimitHorizontal", 90)
    freelookX = clmp(freelookX + x * 0.02, -horizontalLimit, horizontalLimit)
    freelookY = clmp(freelookY + y * 0.02, -85, 85)
    return true
end)

hook.Add("ShouldDrawLocalPlayer", "liaThirdPersonShouldDrawLocalPlayer", function()
    local client = LocalPlayer()
    if not IsValid(client) or IsValid(client:GetVehicle()) then return end
    if lia.camera.isUsingThirdPersonCamera(client) then return true end
    if lia.camera.canUseRealisticView(client) then return true end
    if lia.camera.shouldDrawBodyForFreelook(client) then return true end
end)

hook.Add("CalcViewModelView", "liaFreelookCalcViewModelView", function(weapon, _, _, _, position, angles)
    local client = LocalPlayer()
    if not lia.camera.canUseFreelook(client) or not freelookWasHolding then return end
    local mwBased = weapon.m_AimModeDeltaVelocity and -1.5 or 1
    angles.y = angles.y + freelookCurrentAngles.y / 2.5 * mwBased
    return position, angles
end)

hook.Add("UpdateAnimation", "liaFreelookUpdateHead", function(client)
    if client ~= LocalPlayer() then return end
    lia.camera.updateFreelookHead(client)
end)

hook.Add("EntityEmitSound", "liaThirdPersonEntityEmitSound", function(data)
    local steps = {".stepleft", ".stepright"}
    if lia.option.get("thirdPersonEnabled", false) then
        if not IsValid(data.Entity) or not data.Entity:IsPlayer() then return end
        local sName = data.OriginalSoundName
        if sName:find(steps[1]) or sName:find(steps[2]) then return false end
    end
end)

hook.Add("PlayerButtonDown", "liaThirdPersonPlayerButtonDown", function(_, button)
    if button == KEY_F4 and IsFirstTimePredicted() then
        local currentState = lia.option.get("thirdPersonEnabled", false)
        lia.option.set("thirdPersonEnabled", not currentState)
        hook.Run("ThirdPersonToggled", not currentState)
    end
end)

hook.Add("SetupQuickMenu", "liaFreelookSetupQuickMenu", function(menu)
    menu:addCheck("Enable freelook", function(_, state)
        lia.option.set("freelookEnabled", state)
        if not state then
            lia.camera.setManualFreelook(false)
            lia.camera.endFreelook()
        end
    end, lia.option.get("freelookEnabled", false))
end)

