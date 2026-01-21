CLASS.name = ""
CLASS.desc = ""
CLASS.requirements = nil
CLASS.faction = 0
CLASS.team = nil
CLASS.limit = 0
CLASS.commands = {}
CLASS.model = ""
CLASS.logo = ""
CLASS.skin = 0
CLASS.bodyGroups = {}
CLASS.subMaterials = {}
CLASS.isWhitelisted = false
CLASS.isDefault = false
CLASS.canInviteToFaction = false
CLASS.canInviteToClass = false
CLASS.scoreboardHidden = false
CLASS.pay = 0
CLASS.uniqueID = ""
CLASS.index = FACTION_EXAMPLE
CLASS.Color = Color(255, 255, 255)
CLASS.color = Color(255, 255, 255)
CLASS.health = 0
CLASS.armor = 0
CLASS.weapons = {}
CLASS.scale = 1
CLASS.runSpeed = 0
CLASS.walkSpeed = 0
CLASS.jumpPower = 0
CLASS.NPCRelations = {}
CLASS.bloodcolor = BLOOD_COLOR_RED
CLASS.runSpeedMultiplier = false
CLASS.walkSpeedMultiplier = false
CLASS.jumpPowerMultiplier = false
function CLASS:OnCanBe(client)
    return true
end

function CLASS:OnSet(client)
end

function CLASS:OnTransferred(client, oldClass)
end

function CLASS:OnSpawn(client)
end

function CLASS:OnLeave(client)
end
