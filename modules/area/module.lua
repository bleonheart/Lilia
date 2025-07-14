local MODULE = MODULE
MODULE.name = "F1 Menu"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Adds an F1 menu offering access to various character submenus."
lia.area = lia.area or {}
lia.area.types = lia.area.types or {}
lia.area.properties = lia.area.properties or {}
lia.area.stored = lia.area.stored or {}
lia.config.add("areaTickTime", "Area Tick Time", 1, nil, {
	desc = "How many seconds between each time a character's current area is calculated.",
	category = "areas",
	min = 0.1,
	max = 4,
	type = "Float"
})

hook.Add("liaConfigChanged", "AreaTickTimeRestart", function(key, oldValue, newValue)
	if key ~= "areaTickTime" then return end
	if SERVER then
		timer.Remove("liaAreaThink")
		timer.Create("liaAreaThink", newValue, 0, function() MODULE:AreaThink() end)
	end
end)

function lia.area.AddProperty(name, type, default, data)
	lia.area.properties[name] = {
		type = type,
		default = default
	}
end

function lia.area.AddType(type, name)
	name = name or type
	-- only store localized strings on the client
	lia.area.types[type] = CLIENT and name or true
end

function MODULE:SetupAreaProperties()
	lia.area.AddType("area")
	lia.area.AddProperty("color", lia.type and lia.type.color or "color", lia.config.get("color"))
	lia.area.AddProperty("display", lia.type and lia.type.bool or "Boolean", true)
end

-- return world center, local min, and local max from world start/end positions
function MODULE:GetLocalAreaPosition(startPosition, endPosition)
	local center = LerpVector(0.5, startPosition, endPosition)
	local min = WorldToLocal(startPosition, angle_zero, center, angle_zero)
	local max = WorldToLocal(endPosition, angle_zero, center, angle_zero)
	return center, min, max
end

do
	local COMMAND = {}
	COMMAND.description = "@cmdAreaEdit"
	COMMAND.adminOnly = true
	function COMMAND:OnRun(client)
		client:SetWepRaised(false)
		net.Start("liaAreaEditStart")
		net.Send(client)
	end

	lia.command.add("AreaEdit", COMMAND)
end

do
	local PLAYER = FindMetaTable("Player")
	-- returns the current area the player is in, or the last valid one if the player is not in an area
	function PLAYER:GetArea()
		return self.liaArea
	end

	-- returns true if the player is in any area, this does not use the last valid area like GetArea does
	function PLAYER:IsInArea()
		return self.liaInArea
	end
end