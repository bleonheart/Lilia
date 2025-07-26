if SERVER then
    function MODULE:FetchSpawns()
        local d = deferred.new()
        local data = lia.data.get("spawns", {})
        local factions = data.factions or data
        local result = {}
        for fac, spawns in pairs(factions or {}) do
            local t = {}
            for i = 1, #spawns do
                local spawnData = lia.data.deserialize(spawns[i])
                if isvector(spawnData) then
                    spawnData = {
                        pos = spawnData,
                        ang = angle_zero
                    }
                end

                t[i] = spawnData
            end

            result[fac] = t
        end

        d:resolve(result)
        return d
    end

    function MODULE:StoreSpawns(spawns)
        local factions = {}
        for fac, list in pairs(spawns or {}) do
            factions[fac] = {}
            for _, data in ipairs(list) do
                factions[fac][#factions[fac] + 1] = lia.data.encodetable(data)
            end
        end

        lia.data.set("spawns", {
            factions = factions
        })
    end

    local function SpawnPlayer(client)
        if not IsValid(client) then return end
        local character = client:getChar()
        if not character then return end
        local posData = character:getLastPos()
        if posData and posData.map and posData.map:lower() == game.GetMap():lower() then
            client:SetPos(posData.pos and posData.pos.x and posData.pos or client:GetPos())
            client:SetEyeAngles(posData.ang and posData.ang.p and posData.ang or angle_zero)
            character:setLastPos(nil)
            return
        end

        local factionID
        for _, info in ipairs(lia.faction.indices) do
            if info.index == client:Team() then
                factionID = info.uniqueID
                break
            end
        end

        if factionID then
            MODULE:FetchSpawns():next(function(spawns)
                local factionSpawns = spawns and spawns[factionID]
                if factionSpawns and #factionSpawns > 0 then
                    local data = table.Random(factionSpawns)
                    local basePos = data.pos or data
                    if not isvector(basePos) then basePos = lia.data.decodeVector(basePos) end
                    if not isvector(basePos) then basePos = Vector(0, 0, 0) end
                    local pos = basePos + Vector(0, 0, 16)
                    local ang = data.ang
                    if not isangle(ang) then ang = lia.data.decodeAngle(ang) or angle_zero end
                    client:SetPos(pos)
                    client:SetEyeAngles(ang)
                    hook.Run("PlayerSpawnPointSelected", client, pos, ang)
                end
            end)
        end
    end

    function MODULE:CharPreSave(character)
        local client = character:getPlayer()
        local inVehicle = client:hasValidVehicle()
        if IsValid(client) and not inVehicle and client:Alive() then
            character:setLastPos({
                pos = client:GetPos(),
                ang = client:EyeAngles(),
                map = game.GetMap()
            })
        end
    end

    local function RemovedDropOnDeathItems(client)
        local character = client:getChar()
        if not character then return end
        local inventory = character:getInv()
        if not inventory then return end
        local items = inventory:getItems()
        client.carryWeapons = {}
        client.LostItems = {}
        for _, item in pairs(items) do
            if item.isWeapon and item.DropOnDeath and item:getData("equip", false) or not item.isWeapon and item.DropOnDeath then
                table.insert(client.LostItems, {
                    name = item.name,
                    id = item.id
                })

                item:remove()
            end
        end

        local lostCount = #client.LostItems
        if lostCount > 0 then client:notifyLocalized("itemsLostOnDeath", lostCount) end
    end

    function MODULE:PlayerDeath(client, _, attacker)
        local char = client:getChar()
        if not char then return end
        if attacker:IsPlayer() then
            if lia.config.get("LoseItemsonDeathHuman", false) then RemovedDropOnDeathItems(client) end
            if lia.config.get("DeathPopupEnabled", true) then
                local dateStr = lia.time.GetDate()
                local attackerChar = attacker:getChar()
                local charId = attackerChar and tostring(attackerChar:getID()) or L("na")
                local steamId = tostring(attacker:SteamID64())
                ClientAddText(client, Color(255, 0, 0), "[" .. string.upper(L("death")) .. "]: ", Color(255, 255, 255), dateStr, " - ", L("killedBy"), " ", Color(255, 215, 0), L("characterID"), ": ", Color(255, 255, 255), charId, " (", Color(0, 255, 0), steamId, Color(255, 255, 255), ")")
            end
        end

        client:setNetVar("IsDeadRestricted", true)
        client:setNetVar("lastDeathTime", os.time())
        timer.Simple(lia.config.get("SpawnTime"), function() if IsValid(client) then client:setNetVar("IsDeadRestricted", false) end end)
        client:SetDSP(30, false)
        char:setLastPos(nil)
        if not attacker:IsPlayer() and lia.config.get("LoseItemsonDeathNPC", false) or attacker:IsWorld() and lia.config.get("LoseItemsonDeathWorld", false) then RemovedDropOnDeathItems(client) end
        char:setData("deathPos", client:GetPos())
    end

    function MODULE:PlayerSpawn(client)
        client:setNetVar("IsDeadRestricted", false)
        client:SetDSP(0, false)
    end

    net.Receive("request_respawn", function(_, client)
        if not IsValid(client) or not client:getChar() then return end
        local respawnTime = lia.config.get("SpawnTime", 5)
        local spawnTimeOverride = hook.Run("OverrideSpawnTime", client, respawnTime)
        if spawnTimeOverride then respawnTime = spawnTimeOverride end
        local lastDeathTime = client:getNetVar("lastDeathTime", os.time())
        if os.time() - lastDeathTime < respawnTime then return end
        if not client:Alive() and not client:getNetVar("IsDeadRestricted", false) then client:Spawn() end
    end)

    hook.Add("PostPlayerLoadout", "liaSpawns", SpawnPlayer)
    hook.Add("PostPlayerLoadedChar", "liaSpawns", SpawnPlayer)
else
    local ceil, clamp = math.ceil, math.Clamp
    local fade, shadowFade = 0, 0
    local respawnReq, hideKey = false, false
    function MODULE:HUDPaint()
        local ply, ft = LocalPlayer(), FrameTime()
        if not ply:getChar() then return end
        local baseTime = lia.config.get("SpawnTime", 5)
        baseTime = hook.Run("OverrideSpawnTime", ply, baseTime) or baseTime
        local lastDeath = ply:getNetVar("lastDeathTime", os.time())
        local left = clamp(baseTime - (os.time() - lastDeath), 0, baseTime)
        if hook.Run("ShouldRespawnScreenAppear") == false then return end
        if ply:getChar() and ply:Alive() then
            if fade > 0 then
                shadowFade = clamp(shadowFade - ft * 2 / baseTime, 0, 1)
                if shadowFade == 0 then fade = clamp(fade - ft / baseTime, 0, 1) end
                hideKey = true
            end
        else
            if shadowFade < 1 then
                fade = clamp(fade + ft * 0.8 / baseTime, 0, 1)
                if fade >= 0.6 then shadowFade = clamp(shadowFade + ft * 0.6 / baseTime, 0, 1) end
            end
        end

        if IsValid(lia.char.gui) and lia.gui.char:IsVisible() or not ply:getChar() then return end
        if fade <= 0.01 then return end
        surface.SetDrawColor(0, 0, 0, ceil(fade ^ 0.5 * 255))
        surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
        local txt = L("youHaveDied")
        surface.SetFont("liaHugeFont")
        local w, h = surface.GetTextSize(txt)
        local x, y = (ScrW() - w) / 2, (ScrH() - h) / 2
        lia.util.drawText(txt, x + 2, y + 2, Color(0, 0, 0, ceil(shadowFade * 255)), 0, 0, "liaHugeFont")
        lia.util.drawText(txt, x, y, Color(255, 255, 255, ceil(shadowFade * 255)), 0, 0, "liaHugeFont")
        if not hideKey then
            local dt = left > 0 and L("respawnIn", left) or L("respawnKey", input.GetKeyName(KEY_SPACE))
            surface.SetFont("liaMediumFont")
            local dw = select(1, surface.GetTextSize(dt))
            local dx, dy = (ScrW() - dw) / 2, y + h + 10
            lia.util.drawText(dt, dx + 1, dy + 1, Color(0, 0, 0, 255), 0, 0, "liaMediumFont")
            lia.util.drawText(dt, dx, dy, Color(255, 255, 255, 255), 0, 0, "liaMediumFont")
        end

        if left <= 0 and input.IsKeyDown(KEY_SPACE) then
            if not respawnReq then
                respawnReq = true
                net.Start("request_respawn")
                net.SendToServer()
            end
        else
            respawnReq = false
        end
    end
end