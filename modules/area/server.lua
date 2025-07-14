util.AddNetworkString("liaAreaSync")
util.AddNetworkString("liaAreaAdd")
util.AddNetworkString("liaAreaRemove")
util.AddNetworkString("liaAreaChanged")
util.AddNetworkString("liaAreaEditStart")
util.AddNetworkString("liaAreaEditEnd")
lia.log.addType("areaAdd", function(client, name) return string.format("%s has added area \"%s\".", client:Name(), tostring(name)) end)
lia.log.addType("areaRemove", function(client, name) return string.format("%s has removed area \"%s\".", client:Name(), tostring(name)) end)
local function SortVector(first, second)
	return Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)), Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z))
end

function lia.area.Create(name, type, startPosition, endPosition, bNoReplicate, properties)
	local min, max = SortVector(startPosition, endPosition)
        lia.area.stored[name] = {
		type = type or "area",
		startPosition = min,
		endPosition = max,
		bNoReplicate = bNoReplicate,
		properties = properties
	}

	-- network to clients if needed
        if not bNoReplicate then
                net.Start("liaAreaAdd")
                net.WriteString(name)
                net.WriteString(type)
                net.WriteVector(startPosition)
                net.WriteVector(endPosition)
                net.WriteTable(properties)
                net.Broadcast()
        end
end

function lia.area.Remove(name, bNoReplicate)
        lia.area.stored[name] = nil
	-- network to clients if needed
        if not bNoReplicate then
                net.Start("liaAreaRemove")
                net.WriteString(name)
                net.Broadcast()
        end
end

function MODULE:LoadData()
        hook.Run("SetupAreaProperties")
        lia.area.stored = self:getData() or {}
        timer.Create("liaAreaThink", lia.config.get("areaTickTime"), 0, function() self:AreaThink() end)
end

function MODULE:SaveData()
        self:setData(lia.area.stored)
end

function MODULE:PlayerInitialSpawn(client)
	timer.Simple(1, function()
		if IsValid(client) then
                        local json = util.TableToJSON(lia.area.stored)
			local compressed = util.Compress(json)
			local length = compressed:len()
                        net.Start("liaAreaSync")
			net.WriteUInt(length, 32)
			net.WriteData(compressed, length)
			net.Send(client)
		end
	end)
end

function MODULE:PlayerLoadedCharacter(client)
        client.liaArea = ""
        client.liaInArea = nil
end

function MODULE:PlayerSpawn(client)
        client.liaArea = ""
        client.liaInArea = nil
end

function MODULE:AreaThink()
        for _, client in player.Iterator() do
                local character = client:getChar()
                if not client:Alive() or not character then continue end
                local overlappingBoxes = {}
                local position = client:GetPos() + client:OBBCenter()
                for id, info in pairs(lia.area.stored) do
                        if position:WithinAABox(info.startPosition, info.endPosition) then overlappingBoxes[#overlappingBoxes + 1] = id end
                end

		if #overlappingBoxes > 0 then
                        local oldID = client:GetArea()
                        local id = overlappingBoxes[1]
                        if oldID ~= id then
                                hook.Run("OnPlayerAreaChanged", client, client.liaArea, id)
                                client.liaArea = id
                        end

                        client.liaInArea = true
                else
                        client.liaInArea = false
                end
        end
end

function MODULE:OnPlayerAreaChanged(client, oldID, newID)
        net.Start("liaAreaChanged")
        net.WriteString(oldID)
        net.WriteString(newID)
        net.Send(client)
end

net.Receive("liaAreaAdd", function(length, client)
        if not client:Alive() or not CAMI.PlayerHasAccess(client, "Helix - AreaEdit", nil) then return end
        local id = net.ReadString()
        local type = net.ReadString()
        local startPosition, endPosition = net.ReadVector(), net.ReadVector()
        local properties = net.ReadTable()
        if not lia.area.types[type] then
                client:NotifyLocalized("areaInvalidType")
                return
        end

        if lia.area.stored[id] then
                client:NotifyLocalized("areaAlreadyExists")
                return
        end

        for k, v in pairs(properties) do
                if not isstring(k) or not lia.area.properties[k] then continue end
                properties[k] = lia.util.sanitizeType and lia.util.sanitizeType(lia.area.properties[k].type, v) or v
        end

        lia.area.Create(id, type, startPosition, endPosition, nil, properties)
        lia.log.add(client, "areaAdd", id)
end)

net.Receive("liaAreaRemove", function(length, client)
        if not client:Alive() or not CAMI.PlayerHasAccess(client, "Helix - AreaEdit", nil) then return end
        local id = net.ReadString()
        if not lia.area.stored[id] then
                client:NotifyLocalized("areaDoesntExist")
                return
        end

        lia.area.Remove(id)
        lia.log.add(client, "areaRemove", id)
end)

