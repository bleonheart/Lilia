FACTION.name = ""
FACTION.desc = ""
FACTION.color = Color(255, 255, 255)
FACTION.models = {}
FACTION.weapons = {}
FACTION.isDefault = true
FACTION.uniqueID = ""
FACTION.index = 0
FACTION.health = 0
FACTION.armor = 0
FACTION.scale = 1
FACTION.runSpeed = 0
FACTION.walkSpeed = 0
FACTION.jumpPower = 0
FACTION.NPCRelations = {}
FACTION.bloodcolor = BLOOD_COLOR_RED
FACTION.runSpeedMultiplier = false
FACTION.walkSpeedMultiplier = false
FACTION.jumpPowerMultiplier = false
FACTION.items = {}
FACTION.oneCharOnly = false
FACTION.limit = 0
FACTION.pay = 0
FACTION.payTimer = nil
FACTION.scoreboardHidden = false
FACTION.mainMenuPosition = nil
FACTION.commands = {}
FACTION.RecognizesGlobally = false
FACTION.isGloballyRecognized = false
FACTION.MemberToMemberAutoRecognition = false
function FACTION:NameTemplate(info, client)
    return "Citizen-" .. math.random(1000, 9999)
end

function FACTION:GetDefaultName(client)
    return "Citizen " .. math.random(1000, 9999)
end

function FACTION:GetDefaultDesc(client)
    return "A citizen of the city"
end

function FACTION:OnCheckLimitReached(character, client)
    return false
end

function FACTION:OnTransferred(client)
end

function FACTION:OnSpawn(client)
end
