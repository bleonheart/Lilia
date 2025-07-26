function MODULE:CalcStaminaChange(client)
    local char = client:getChar()
    if not char or client:isNoClipping() then return 1 end
    local walkSpeed = lia.config.get("WalkSpeed", client:GetWalkSpeed())
    local offset
    local draining = client:KeyDown(IN_SPEED) and (client:GetVelocity():LengthSqr() >= walkSpeed * walkSpeed or client:InVehicle() and not client:OnGround())
    if draining then
        offset = -lia.config.get("StaminaDrain", 1)
    else
        offset = client:Crouching() and lia.config.get("StaminaCrouchRegeneration", 2) or lia.config.get("StaminaRegeneration", 1.75)
    end

    offset = hook.Run("AdjustStaminaOffset", client, offset) or offset
    if CLIENT then return offset end
    local max = char:getMaxStamina()
    local current = client:getLocalVar("stamina", char:getMaxStamina())
    local value = math.Clamp(current + offset, 0, max)
    if current ~= value then
        client:setLocalVar("stamina", value)
        if value == 0 and not client:getNetVar("brth", false) then
            client:setNetVar("brth", true)
            hook.Run("PlayerStaminaLost", client)
        elseif value >= max * 0.5 and client:getNetVar("brth", false) then
            client:setNetVar("brth", nil)
            hook.Run("PlayerStaminaGained", client)
        end
    end
end

function MODULE:SetupMove(client, cMoveData)
    if not lia.config.get("StaminaSlowdown", true) then return end
    if client:getNetVar("brth", false) then cMoveData:SetMaxClientSpeed(client:GetWalkSpeed()) end
end

function MODULE:GetAttributeMax(_, attribute)
    local attribTable = lia.attribs.list[attribute]
    if not attribTable then return lia.config.get("MaxAttributePoints") end
    if istable(attribTable) and isnumber(attribTable.maxValue) then return attribTable.maxValue end
    return lia.config.get("MaxAttributePoints")
end

function MODULE:GetAttributeStartingMax(_, attribute)
    local attribTable = lia.attribs.list[attribute]
    if not attribTable then return lia.config.get("MaxStartingAttributes") end
    if istable(attribTable) and isnumber(attribTable.startingMax) then return attribTable.startingMax end
    return lia.config.get("MaxStartingAttributes")
end

function MODULE:GetMaxStartingAttributePoints()
    return lia.config.get("StartingAttributePoints")
end

if SERVER then
    function MODULE:PostPlayerLoadout(client)
        local char = client:getChar()
        if not char then return end
        lia.attribs.setup(client)
        local inv = char:getInv()
        if inv then
            for _, v in pairs(inv:getItems()) do
                v:call("onLoadout", client)
                if v:getData("equip") and istable(v.attribBoosts) then
                    for k, b in pairs(v.attribBoosts) do
                        char:addBoost(v.uniqueID, k, b)
                    end
                end
            end
        end

        client:setLocalVar("stamina", char:getMaxStamina())
        local uniqueID = "liaStam" .. client:SteamID()
        timer.Remove(uniqueID)
        timer.Create(uniqueID, 0.25, 0, function()
            if not IsValid(client) then
                timer.Remove(uniqueID)
                return
            end

            self:CalcStaminaChange(client)
        end)
    end

    function MODULE:PlayerDisconnected(client)
        timer.Remove("liaStam" .. client:SteamID())
    end

    function MODULE:KeyPress(client, key)
        local char = client:getChar()
        if not char then return end
        if key == IN_ATTACK2 then
            local wep = client:GetActiveWeapon()
            if IsValid(wep) and wep.IsHands and wep.ReadyToPickup then
                wep:Pickup()
            elseif IsValid(client.Grabbed) then
                client:DropObject(client.Grabbed)
                client.Grabbed = NULL
            end
        end

        if key == IN_JUMP and not client:isNoClipping() and not client:InVehicle() and client:Alive() then
            if (client.liaNextJump or 0) <= CurTime() then
                client.liaNextJump = CurTime() + 0.1
                local cost = lia.config.get("JumpStaminaCost", 25)
                local maxStamina = char:getMaxStamina() or lia.config.get("DefaultStamina", 100)
                client:consumeStamina(cost)
                local newStamina = client:getLocalVar("stamina", maxStamina)
                if newStamina <= 0 then
                    client:setNetVar("brth", true)
                    client:ConCommand("-speed")
                end
            end
        end
    end

    function MODULE:PlayerLoadedChar(client, character)
        timer.Simple(0.25, function() if IsValid(client) then client:setLocalVar("stamina", character:getMaxStamina()) end end)
    end

    function MODULE:PlayerStaminaLost(client)
        if client:getNetVar("brth", false) then return end
        client:setNetVar("brth", true)
        client:EmitSound("player/breathe1.wav", 35, 100)
        local character = client:getChar()
        local maxStamina = character and character:getMaxStamina() or lia.config.get("DefaultStamina", 100)
        local breathThreshold = maxStamina * 0.25
        timer.Create("liaStamBreathCheck" .. client:SteamID64(), 1, 0, function()
            if not IsValid(client) then
                timer.Remove("liaStamBreathCheck" .. client:SteamID64())
                return
            end

            local char = client:getChar()
            local currentStamina = client:getLocalVar("stamina", char and char:getMaxStamina() or lia.config.get("DefaultStamina", 100))
            if currentStamina <= breathThreshold then
                client:EmitSound("player/breathe1.wav", 35, 100)
                return
            end

            client:StopSound("player/breathe1.wav")
            client:setNetVar("brth", nil)
            timer.Remove("liaStamBreathCheck" .. client:SteamID64())
        end)
    end

    net.Receive("ChangeAttribute", function(_, client)
        if not client:hasPrivilege("Manage Attributes") then return end
        local charID = net.ReadInt(32)
        local _ = net.ReadTable()
        local attribKey = net.ReadString()
        local amountStr = net.ReadString()
        local mode = net.ReadString()
        if not attribKey or not lia.attribs.list[attribKey] then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(L(v.name), attribKey) or lia.util.stringMatches(k, attribKey) then
                    attribKey = k
                    break
                end
            end
        end

        if not attribKey or not lia.attribs.list[attribKey] then
            client:notifyLocalized("invalidAttributeKey")
            return
        end

        local attribValue = tonumber(amountStr)
        if not attribValue then
            client:notifyLocalized("invalidAmount")
            return
        end

        local targetClient = lia.char.getBySteamID(charID)
        if not IsValid(targetClient) then
            client:notifyLocalized("characterNotFound")
            return
        end

        local targetChar = targetClient:getChar()
        if not targetChar then
            client:notifyLocalized("characterNotFound")
            return
        end

        if mode == "Set" then
            if attribValue < 0 then
                client:notifyLocalized("attribNonNegative")
                return
            end

            targetChar:setAttrib(attribKey, attribValue)
            client:notifyLocalized("attribSet", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
            targetChar:getPlayer():notifyLocalized("yourAttributeSet", lia.attribs.list[attribKey].name, attribValue, client:Nick())
        elseif mode == "Add" then
            if attribValue <= 0 then
                client:notifyLocalized("attribPositive")
                return
            end

            local current = targetChar:getAttrib(attribKey, 0) or 0
            local newValue = current + attribValue
            if not isnumber(newValue) or newValue < 0 then
                client:notifyLocalized("attribCalculationError")
                return
            end

            targetChar:updateAttrib(attribKey, newValue)
            client:notifyLocalized("attribUpdate", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
            targetChar:getPlayer():notifyLocalized("yourAttributeIncreased", lia.attribs.list[attribKey].name, attribValue, client:Nick())
        else
            client:notifyLocalized("invalidMode")
        end
    end)
else
    local predictedStamina = 100
    local stmBlurAmount = 0
    local stmBlurAlpha = 0
    function MODULE:ConfigureCharacterCreationSteps(panel)
        if table.Count(lia.attribs.list) > 0 then panel:addStep(vgui.Create("liaCharacterAttribs"), 98) end
    end

    function MODULE:PlayerBindPress(client, bind, pressed)
        if not pressed then return end
        local char = client:getChar()
        if not char then return end
        local predicted = predictedStamina or 0
        local actual = client:getLocalVar("stamina", char:getMaxStamina())
        local jumpReq = lia.config.get("JumpStaminaCost", 25)
        if bind == "+jump" and predicted < jumpReq and actual < jumpReq then return true end
        local stamina = math.min(predicted, actual)
        if bind == "+speed" and stamina <= 5 then
            client:ConCommand("-speed")
            return true
        end
    end

    function MODULE:Think()
        local client = LocalPlayer()
        if not client:getChar() then return end
        local character = client:getChar()
        local maxStamina = character:getMaxStamina()
        local offset = self:CalcStaminaChange(client)
        offset = math.Remap(FrameTime(), 0, 0.25, 0, offset)
        if offset ~= 0 then predictedStamina = math.Clamp(predictedStamina + offset, 0, maxStamina) end
    end

    function MODULE:LocalVarChanged(client, key, _, newVar)
        if client ~= LocalPlayer() or key ~= "stamina" then return end
        predictedStamina = newVar
    end

    function MODULE:HUDPaintBackground()
        local client = LocalPlayer()
        if not lia.config.get("StaminaBlur", false) or not client:getChar() then return end
        local character = client:getChar()
        local maxStamina = character:getMaxStamina()
        local stamina = client:getLocalVar("stamina", maxStamina)
        if stamina < maxStamina * 0.25 then
            local ratio = (maxStamina * 0.25 - stamina) / (maxStamina * 0.25)
            local targetAlpha = ratio * 255
            local targetAmount = ratio * 5
            stmBlurAlpha = Lerp(RealFrameTime() / 2, stmBlurAlpha, targetAlpha)
            stmBlurAmount = Lerp(RealFrameTime() / 2, stmBlurAmount, targetAmount)
            lia.util.drawBlurAt(0, 0, ScrW(), ScrH(), stmBlurAmount, 0.2, stmBlurAlpha)
        else
            stmBlurAlpha = Lerp(RealFrameTime() / 2, stmBlurAlpha, 0)
            stmBlurAmount = Lerp(RealFrameTime() / 2, stmBlurAmount, 0)
        end
    end

    function MODULE:LoadCharInformation()
        local client = LocalPlayer()
        if not IsValid(client) then return end
        local char = client:getChar()
        if not char then return end
        if table.IsEmpty(lia.attribs.list) then return end
        hook.Run("AddSection", L("attributes"), Color(0, 0, 0), 2, 1)
        local attrs = {}
        for id, attr in pairs(lia.attribs.list) do
            attrs[#attrs + 1] = {
                id = id,
                attr = attr
            }
        end

        table.sort(attrs, function(a, b) return a.attr.name < b.attr.name end)
        for _, entry in ipairs(attrs) do
            local id, attr = entry.id, entry.attr
            local minVal = attr.min or 0
            local maxVal = attr.max or 100
            hook.Run("AddBarField", L("attributes"), id, attr.name, function() return minVal end, function() return maxVal end, function() return char:getAttrib(id) end)
        end
    end

    lia.bar.add(function()
        local client = LocalPlayer()
        local char = client:getChar()
        if not char then return 0 end
        local max = char:getMaxStamina()
        return predictedStamina / max
    end, Color(200, 200, 40), nil, "stamina")

    function MODULE:OnReloaded()
        local client = LocalPlayer()
        if not IsValid(client) then return end
        local char = client:getChar()
        if not char then return end
        predictedStamina = client:getLocalVar("stamina", char:getMaxStamina())
    end
end