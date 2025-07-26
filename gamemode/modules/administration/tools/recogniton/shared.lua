local function isFakeNameExistant(name, nameList)
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

local function canRecog(ply)
    return lia.config.get("RecognitionEnabled", true) and ply:getChar() and ply:Alive()
end

local function promptName(ply, cb)
    if lia.config.get("FakeNamesEnabled", false) then
        ply:requestString(L("recogFakeNamePrompt"), "", function(nm)
            nm = (nm or ""):Trim()
            local finalName = nm == "" and ply:getChar():getName() or nm
            cb(finalName)
        end, ply:getChar():getName())
    else
        cb()
    end
end

local function CharRecognize(ply, lvl, nm)
    local tgt = {}
    if isnumber(lvl) then
        local clsKey = lvl == 3 and "ic" or lvl == 4 and "y" or "w"
        local cls = lia.chat.classes[clsKey]
        for _, v in player.Iterator() do
            if ply ~= v and v:getChar() and cls.onCanHear(ply, v) then tgt[#tgt + 1] = v end
        end
    end

    if #tgt == 0 then return end
    local count = 0
    for _, v in ipairs(tgt) do
        if v:getChar():recognize(ply:getChar(), nm) then count = count + 1 end
    end

    if count == 0 then return end
    ply:notifyLocalized("recognitionGiven", count)
    for _, v in ipairs(tgt) do
        lia.log.add(ply, "charRecognize", v:getChar():getID(), nm)
    end

    net.Start("rgnDone")
    net.Send(ply)
    hook.Run("OnCharRecognized", ply)
end

local function doRange(ply, lvl)
    promptName(ply, function(nm) CharRecognize(ply, lvl, nm) end)
end

AddAction(L("recognizeInWhisperRange"), {
    shouldShow = function(ply) return canRecog(ply) end,
    onRun = function(ply)
        if CLIENT then return end
        doRange(ply, 1)
    end,
    runServer = true
})

AddAction(L("recognizeInTalkRange"), {
    shouldShow = function(ply) return canRecog(ply) end,
    onRun = function(ply)
        if CLIENT then return end
        doRange(ply, 3)
    end,
    runServer = true
})

AddAction(L("recognizeInYellRange"), {
    shouldShow = function(ply) return canRecog(ply) end,
    onRun = function(ply)
        if CLIENT then return end
        doRange(ply, 4)
    end,
    runServer = true
})

AddInteraction(L("recognizeOption"), {
    runServer = true,
    shouldShow = function(ply, tgt)
        if not canRecog(ply) then return false end
        local a, b = ply:getChar(), tgt:getChar()
        if not a or not b then return false end
        return not hook.Run("isCharRecognized", a, b:getID())
    end,
    onRun = function(ply, tgt)
        if CLIENT then return end
        promptName(ply, function(nm)
            if tgt:getChar():recognize(ply:getChar(), nm) then
                ply:notifyLocalized("recognitionGiven", 1)
                lia.log.add(ply, "charRecognize", tgt:getChar():getID(), nm)
                net.Start("rgnDone")
                net.Send(ply)
                hook.Run("OnCharRecognized", ply)
            end
        end)
    end
})
