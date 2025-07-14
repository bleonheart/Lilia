local MODULE = MODULE
function MODULE:LoadData()
    local data = self:getData() or {}
    if data.factions or data.global then
        self.spawns = data.factions or {}
        self.globalSpawns = data.global or {}
    else
        self.spawns = data
        self.globalSpawns = {}
    end
end

function MODULE:SaveData()
    self:setData({
        factions = self.spawns,
        global = self.globalSpawns
    })
end

local function SpawnPlayer(client)
    local spawnCount = MODULE.spawns and table.Count(MODULE.spawns) or 0
    local globalCount = MODULE.globalSpawns and #MODULE.globalSpawns or 0
    if spawnCount == 0 and globalCount == 0 then
        print("[MODULE] PostPlayerLoadout: no spawns available (spawns=" .. spawnCount .. ", globalSpawns=" .. globalCount .. ")")
        return
    end

    print("[MODULE] PostPlayerLoadout: spawnCount=" .. spawnCount .. ", globalCount=" .. globalCount)
    local factionInfo
    for _, v in ipairs(lia.faction.indices) do
        if v.index == client:Team() then
            factionInfo = v
            break
        end
    end

    print("[MODULE] PostPlayerLoadout: factionInfo=" .. (factionInfo and factionInfo.uniqueID or "nil"))
    local spawnPos
    if factionInfo then
        local factionSpawns = MODULE.spawns[factionInfo.uniqueID] or {}
        print("[MODULE] PostPlayerLoadout: factionSpawns count=" .. #factionSpawns)
        if #factionSpawns > 0 then
            spawnPos = table.Random(factionSpawns)
            print("[MODULE] PostPlayerLoadout: picked faction spawn " .. tostring(spawnPos))
        end
    end

    if not spawnPos and MODULE.globalSpawns and #MODULE.globalSpawns > 0 then
        print("[MODULE] PostPlayerLoadout: picking from globalSpawns count=" .. #MODULE.globalSpawns)
        spawnPos = table.Random(MODULE.globalSpawns)
        print("[MODULE] PostPlayerLoadout: picked global spawn " .. tostring(spawnPos))
    end

    if spawnPos then
        print("[MODULE] PostPlayerLoadout: setting position to " .. tostring(spawnPos))
        client:SetPos(spawnPos)
    end
end

function MODULE:CharPreSave(character)
    local client = character:getPlayer()
    local InVehicle = client:hasValidVehicle()
    if IsValid(client) and not InVehicle and client:Alive() then character:setData("pos", {client:GetPos(), client:EyeAngles(), game.GetMap()}) end
end

function MODULE:PlayerLoadedChar(client, character)
    timer.Simple(0, function()
        if IsValid(client) then
            local position = character:getData("pos")
            if position then
                if position[3] and position[3]:lower() == game.GetMap():lower() then
                    client:SetPos(position[1].x and position[1] or client:GetPos())
                    client:SetEyeAngles(position[2].p and position[2] or angle_zero)
                end

                character:setData("pos", nil)
            end
        end
    end)
end

function MODULE:PlayerDeath(client, _, attacker)
    local char = client:getChar()
    if not char then return end
    if attacker:IsPlayer() then
        if lia.config.get("LoseItemsonDeathHuman", false) then self:RemovedDropOnDeathItems(client) end
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
    char:setData("pos", nil)
    if not attacker:IsPlayer() and lia.config.get("LoseItemsonDeathNPC", false) or attacker:IsWorld() and lia.config.get("LoseItemsonDeathWorld", false) then self:RemovedDropOnDeathItems(client) end
    char:setData("deathPos", client:GetPos())
end

function MODULE:RemovedDropOnDeathItems(client)
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
    local timePassed = os.time() - lastDeathTime
    if timePassed < respawnTime then return end
    if not client:Alive() and not client:getNetVar("IsDeadRestricted", false) then client:Spawn() end
end)

hook.Add("PostPlayerLoadout", "liaSpawns", SpawnPlayer)
hook.Add("PostPlayerLoadedChar", "liaSpawns", SpawnPlayer)