util.AddNetworkString("ixAreaSync")
util.AddNetworkString("ixAreaAdd")
util.AddNetworkString("ixAreaRemove")
util.AddNetworkString("ixAreaChanged")
util.AddNetworkString("ixAreaEditStart")
util.AddNetworkString("ixAreaEditEnd")
ix.log.AddType("areaAdd", function(client, name) return string.format("%s has added area \"%s\".", client:Name(), tostring(name)) end)
ix.log.AddType("areaRemove", function(client, name) return string.format("%s has removed area \"%s\".", client:Name(), tostring(name)) end)
local function SortVector(first, second)
	return Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)), Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z))
end

function ix.area.Create(name, type, startPosition, endPosition, bNoReplicate, properties)
	local min, max = SortVector(startPosition, endPosition)
	ix.area.stored[name] = {
		type = type or "area",
		startPosition = min,
		endPosition = max,
		bNoReplicate = bNoReplicate,
		properties = properties
	}

	-- network to clients if needed
	if not bNoReplicate then
		net.Start("ixAreaAdd")
		net.WriteString(name)
		net.WriteString(type)
		net.WriteVector(startPosition)
		net.WriteVector(endPosition)
		net.WriteTable(properties)
		net.Broadcast()
	end
end

function ix.area.Remove(name, bNoReplicate)
	ix.area.stored[name] = nil
	-- network to clients if needed
	if not bNoReplicate then
		net.Start("ixAreaRemove")
		net.WriteString(name)
		net.Broadcast()
	end
end

function PLUGIN:LoadData()
	hook.Run("SetupAreaProperties")
	ix.area.stored = self:GetData() or {}
	timer.Create("ixAreaThink", ix.config.Get("areaTickTime"), 0, function() self:AreaThink() end)
end

function PLUGIN:SaveData()
	self:SetData(ix.area.stored)
end

function PLUGIN:PlayerInitialSpawn(client)
	timer.Simple(1, function()
		if IsValid(client) then
			local json = util.TableToJSON(ix.area.stored)
			local compressed = util.Compress(json)
			local length = compressed:len()
			net.Start("ixAreaSync")
			net.WriteUInt(length, 32)
			net.WriteData(compressed, length)
			net.Send(client)
		end
	end)
end

function PLUGIN:PlayerLoadedCharacter(client)
	client.ixArea = ""
	client.ixInArea = nil
end

function PLUGIN:PlayerSpawn(client)
	client.ixArea = ""
	client.ixInArea = nil
end

function PLUGIN:AreaThink()
	for _, client in player.Iterator() do
		local character = client:GetCharacter()
		if not client:Alive() or not character then continue end
		local overlappingBoxes = {}
		local position = client:GetPos() + client:OBBCenter()
		for id, info in pairs(ix.area.stored) do
			if position:WithinAABox(info.startPosition, info.endPosition) then overlappingBoxes[#overlappingBoxes + 1] = id end
		end

		if #overlappingBoxes > 0 then
			local oldID = client:GetArea()
			local id = overlappingBoxes[1]
			if oldID ~= id then
				hook.Run("OnPlayerAreaChanged", client, client.ixArea, id)
				client.ixArea = id
			end

			client.ixInArea = true
		else
			client.ixInArea = false
		end
	end
end

function PLUGIN:OnPlayerAreaChanged(client, oldID, newID)
	net.Start("ixAreaChanged")
	net.WriteString(oldID)
	net.WriteString(newID)
	net.Send(client)
end

net.Receive("ixAreaAdd", function(length, client)
	if not client:Alive() or not CAMI.PlayerHasAccess(client, "Helix - AreaEdit", nil) then return end
	local id = net.ReadString()
	local type = net.ReadString()
	local startPosition, endPosition = net.ReadVector(), net.ReadVector()
	local properties = net.ReadTable()
	if not ix.area.types[type] then
		client:NotifyLocalized("areaInvalidType")
		return
	end

	if ix.area.stored[id] then
		client:NotifyLocalized("areaAlreadyExists")
		return
	end

	for k, v in pairs(properties) do
		if not isstring(k) or not ix.area.properties[k] then continue end
		properties[k] = ix.util.SanitizeType(ix.area.properties[k].type, v)
	end

	ix.area.Create(id, type, startPosition, endPosition, nil, properties)
	ix.log.Add(client, "areaAdd", id)
end)

net.Receive("ixAreaRemove", function(length, client)
	if not client:Alive() or not CAMI.PlayerHasAccess(client, "Helix - AreaEdit", nil) then return end
	local id = net.ReadString()
	if not ix.area.stored[id] then
		client:NotifyLocalized("areaDoesntExist")
		return
	end

	ix.area.Remove(id)
	ix.log.Add(client, "areaRemove", id)
end)