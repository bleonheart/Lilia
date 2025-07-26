if SERVER then
    function GM:CanPlayerUseChar(client, character)
        if GetGlobalBool("characterSwapLock", false) and not client:hasPrivilege("Can Bypass Character Lock") then return false, L("serverEventCharLock") end
        local factionData = lia.faction.indices[character:getFaction()]
        if factionData and hook.Run("CheckFactionLimitReached", factionData, character, client) then return false, L("limitFaction") end
        local bannedUntil = character:getBanned()
        if isnumber(bannedUntil) and bannedUntil > os.time() then return false, L("bannedCharacter") end
        return true
    end

    function GM:CanPlayerSwitchChar(client, character, newCharacter)
        if character:getID() == newCharacter:getID() then return false, L("alreadyUsingCharacter") end
        local banned = character:getBanned()
        if banned and isnumber(banned) and banned > os.time() then return false, L("bannedCharacter") end
        if not client:Alive() then return false, L("youAreDead") end
        if client:hasRagdoll() then return false, L("youAreRagdolled") end
        if client:hasValidVehicle() then return false, L("cannotSwitchInVehicle") end
        if not client:isStaffOnDuty() then
            local damageCooldown = lia.config.get("OnDamageCharacterSwitchCooldownTimer", 15)
            if damageCooldown > 0 and client.LastDamaged and client.LastDamaged > CurTime() - damageCooldown then
                lia.log.add(client, "permissionDenied", "switch character (recent damage)")
                return false, L("tookDamageSwitchCooldown")
            end

            local switchCooldown = lia.config.get("CharacterSwitchCooldownTimer", 5)
            local loginTime = character:getData("loginTime", 0)
            if switchCooldown > 0 and loginTime + switchCooldown > os.time() then
                lia.log.add(client, "permissionDenied", "switch character (cooldown)")
                return false, L("switchCooldown")
            end
        end

        local fac = lia.faction.indices[newCharacter:getFaction()]
        if fac.OnCheckLimitReached then
            if fac:OnCheckLimitReached(newCharacter, client) then return false, L("limitFaction") end
        else
            local lim = fac.limit
            if isnumber(lim) then
                local maxPlayers = lim < 1 and math.Round(player.GetCount() * lim) or lim
                if team.NumPlayers(fac.index) >= maxPlayers then return false, L("limitFaction") end
            end
        end
        return true
    end

    function GM:CharPreSave(character)
        local client = character:getPlayer()
        if not character:getInv() then return end
        for _, v in pairs(character:getInv():getItems()) do
            if v.OnSave then v:call("OnSave", client) end
        end

        if IsValid(client) then
            local ammoTable = {}
            for _, ammoType in pairs(game.GetAmmoTypes()) do
                if ammoType then
                    local ammoCount = client:GetAmmoCount(ammoType)
                    if isnumber(ammoCount) and ammoCount > 0 then ammoTable[ammoType] = ammoCount end
                end
            end

            character:setData("ammo", ammoTable)
        end
    end

    function GM:PlayerLoadedChar(client, character)
        local timeStamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
        lia.db.updateTable({
            lastJoinTime = timeStamp
        }, nil, "characters", "id = " .. character:getID())

        client:removeRagdoll()
        character:setData("loginTime", os.time())
        hook.Run("PlayerLoadout", client)
        local ammoTable = character:getData("ammo", {})
        if table.IsEmpty(ammoTable) then return end
        timer.Simple(0.25, function()
            if not IsValid(ammoTable) then return end
            for ammoType, ammoCount in pairs(ammoTable) do
                if IsValid(ammoCount) or IsValid(ammoCount) then client:GiveAmmo(ammoCount, ammoType, true) end
            end

            character:setData("ammo", nil)
        end)
    end

    function GM:PlayerShouldPermaKill(client)
        return client:getNetVar("markedForDeath", false)
    end

    function GM:CharLoaded(id)
        local character = lia.char.loaded[id]
        if character then
            local client = character:getPlayer()
            if IsValid(client) then
                local uniqueID = "liaSaveChar" .. client:SteamID64()
                timer.Create(uniqueID, lia.config.get("CharacterDataSaveInterval"), 0, function()
                    if IsValid(client) and client:getChar() then
                        client:getChar():save()
                    else
                        timer.Remove(uniqueID)
                    end
                end)
            end
        end
    end

    function GM:PrePlayerLoadedChar(client)
        client:SetBodyGroups("000000000")
        client:SetSkin(0)
        client:ExitVehicle()
        client:Freeze(false)
    end

    function GM:CanDeleteChar(_, character)
        if IsValid(character) and character:getMoney() < lia.config.get("DefaultMoney") then return false end
    end
end

function GM:CanPlayerCreateChar(client)
    if SERVER then
        local count = #client.liaCharList or 0
        local maxChars = hook.Run("GetMaxPlayerChar", client) or lia.config.get("MaxCharacters")
        if (count or 0) >= maxChars then return false end
        return true
    else
        local count = #lia.characters or 0
        local maxChars = hook.Run("GetMaxPlayerChar", client) or lia.config.get("MaxCharacters")
        if (count or 0) >= maxChars then return false end
    end
end

function GM:OnCharVarChanged(character, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for _, v in pairs(lia.char.varHooks[varName]) do
            v(character, oldVar, newVar)
        end
    end
end