MODULE.name = "Fix Character Data"
MODULE.author = "Historia"
MODULE.desc = "Convert character data to use its own DB table"
local CHARACTER = lia.meta.character
function CHARACTER:setData(key, value, noReplication, receiver)
	if not self.dataVars then self.dataVars = {} end
	local keysToNetwork = {}
	if istable(key) then
		self.dataVars = pon.encode(key)
		keysToNetwork = table.GetKeys(self.dataVars)
	else
		self.dataVars[key] = value
		table.insert(keysToNetwork, key)
	end

	if SERVER then
		if not noReplication then
			net.Start("liaCharacterData")
			net.WriteUInt(self:getID(), 32)
			net.WriteUInt(#keysToNetwork, 32)
			for _, key in next, keysToNetwork do
				local data = self.dataVars[key]
				if istable(data) then data = pon.encode(data) end
				net.WriteString(key)
				net.WriteType(data)
			end

			net.Send(receiver or self:getPlayer())
		end

		if value == nil then
			lia.db.delete("chardata", "_charID = " .. self:getID() .. " AND _key = '" .. lia.db.escape(key) .. "'")
		else
			local encodedValue = pon.encode({value})
			lia.db.upsert({
				_charID = self:getID(),
				_key = key,
				_value = encodedValue
			}, "chardata", function(success, error) if not success then print("Failed to insert character data: " .. error) end end)
		end
	end
end

function CHARACTER:getData(key, default)
	if not key then
		--print("Returning all data:", self.dataVars)
		return self.dataVars
	end

	local value = self.dataVars and self.dataVars[key] or default
	--print("Getting data for key:", key, "Value:", value)
	return value
end

if SERVER then
	util.AddNetworkString("liaCharacterData")
else
	local function liaCharacterData(len)
		local charID = net.ReadUInt(32)
		--	print("Received character ID:", charID)
		local character = lia.char.loaded[charID]
		if not character then
			--	print("Character not found with ID:", charID)
			return
		end

		if not character.dataVars then
			--	print("Initializing dataVars for character:", charID)
			character.dataVars = {}
		end

		local keyCount = net.ReadUInt(32)
		--	print("Number of keys to receive:", keyCount)
		for i = 1, keyCount do
			local key = net.ReadString()
			local value = net.ReadType()
			--	print("Received key-value pair:", key, value)
			character.dataVars[key] = value
		end
		--print("Character data updated:", character.dataVars)
	end

	net.Receive("liaCharacterData", liaCharacterData)
end