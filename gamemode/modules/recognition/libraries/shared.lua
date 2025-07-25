﻿local function isFakeNameExistant(name, nameList)
    for _, n in pairs(nameList) do
        if n == name then return true end
    end
    return false
end

function MODULE:isCharRecognized(character, id)
    if not lia.config.get("RecognitionEnabled", true) then return true end
    local client = character:getPlayer()
    local other = lia.char.loaded[id]
    local otherClient = other and other:getPlayer()
    if not IsValid(otherClient) then return false end
    if character.id == id then return true end
    local factionID = character:getFaction()
    local faction = factionID and lia.faction.indices[factionID]
    if faction and faction.RecognizesGlobally then return true end
    local otherFactionID = other:getFaction()
    local otherFaction = lia.faction.indices[otherFactionID]
    if otherFaction then
        if otherFaction.isGloballyRecognized then return true end
        if factionID == otherFactionID and otherFaction.MemberToMemberAutoRecognition then return true end
    end

    if client:isStaffOnDuty() or otherClient:isStaffOnDuty() then return true end
    local recognized = character:getRecognition() or ""
    if recognized:find("," .. id .. ",", 1, true) then return true end
    return false
end

function MODULE:isCharFakeRecognized(character, id)
    local other = lia.char.loaded[id]
    local CharNameList = character:getFakeName()
    local clientName = CharNameList[other:getID()]
    return lia.config.get("FakeNamesEnabled", false) and isFakeNameExistant(clientName, CharNameList)
end
