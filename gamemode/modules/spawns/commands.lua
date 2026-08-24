
-- Spawn command registrations.
lia.command.add("spawnadd", {
    adminOnly = true,
    desc = "@spawnAddDesc",
    arguments = {
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    options[k] = L(v.name)
                end
                return options
            end
        },
        {
            name = "radius",
            type = "string",
            optional = true
        }
    },
    onRun = function(client, arguments)
        local factionName = arguments[1]
        if not factionName then
            client:notifyErrorLocalized("invalidArg")
            return
        end

        local factionInfo = lia.faction.teams[factionName] or lia.util.findFaction(client, factionName)
        if factionInfo then
            lia.module.get("spawns"):FetchSpawns():next(function(spawns)
                spawns[factionInfo.uniqueID] = spawns[factionInfo.uniqueID] or {}
                local newSpawn = {
                    pos = client:GetPos(),
                    ang = client:EyeAngles(),
                    map = lia.data.getEquivalencyMap(game.GetMap()),
                    radius = math.Clamp(tonumber(arguments[2]) or 0, 0, 2048)
                }

                table.insert(spawns[factionInfo.uniqueID], newSpawn)
                lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                    lia.log.add(client, "spawnAdd", factionInfo.name)
                    client:notifySuccessLocalized("spawnAdded")
                end)
            end)
        else
            client:notifyErrorLocalized("invalidFaction")
        end
    end
})

lia.command.add("spawnremoveinradius", {
    adminOnly = true,
    desc = "@spawnRemoveInRadiusDesc",
    arguments = {
        {
            name = "radius",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local position = client:GetPos()
        local radius = tonumber(arguments[1]) or 120
        lia.module.get("spawns"):FetchSpawns():next(function(spawns)
            local removedCount = 0
            local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
            for faction, list in pairs(spawns) do
                for i = #list, 1, -1 do
                    local data = list[i]
                    if not (data.map and data.map:lower() ~= curMap) then
                        local spawn = data.pos or data
                        if not isvector(spawn) then spawn = lia.data.decodeVector(spawn) end
                        if isvector(spawn) and spawn:Distance(position) <= radius then
                            table.remove(list, i)
                            removedCount = removedCount + 1
                        end
                    end
                end

                if #list == 0 then spawns[faction] = nil end
            end

            if removedCount > 0 then
                lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                    lia.log.add(client, "spawnRemoveRadius", radius, removedCount)
                    client:notifySuccessLocalized("spawnDeleted")
                end)
            else
                lia.log.add(client, "spawnRemoveRadius", radius, removedCount)
                client:notifySuccessLocalized("spawnDeleted")
            end
        end)
    end
})

lia.command.add("spawnremovebyname", {
    adminOnly = true,
    desc = "@spawnRemoveByNameDesc",
    arguments = {
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    options[k] = L(v.name)
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local factionName = arguments[1]
        local factionInfo = factionName and (lia.faction.teams[factionName] or lia.util.findFaction(client, factionName))
        if factionInfo then
            lia.module.get("spawns"):FetchSpawns():next(function(spawns)
                local list = spawns[factionInfo.uniqueID]
                if list then
                    local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
                    local removedCount = 0
                    for i = #list, 1, -1 do
                        local data = list[i]
                        if not (data.map and data.map:lower() ~= curMap) then
                            table.remove(list, i)
                            removedCount = removedCount + 1
                        end
                    end

                    if removedCount > 0 then
                        if #list == 0 then spawns[factionInfo.uniqueID] = nil end
                        lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                            lia.log.add(client, "spawnRemoveByName", factionInfo.name, removedCount)
                            client:notifySuccessLocalized("spawnDeletedByName")
                        end)
                    else
                        client:notifyInfoLocalized("noSpawnsForFaction")
                    end
                else
                    client:notifyInfoLocalized("noSpawnsForFaction")
                end
            end)
        else
            client:notifyErrorLocalized("invalidFaction")
        end
    end
})

