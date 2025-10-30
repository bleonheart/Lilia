--[[
    Player Interaction Library

    Player-to-player and entity interaction management system for the Lilia framework.
]]
--[[
    Overview:
        The player interaction library provides comprehensive functionality for managing player interactions and actions within the Lilia framework. It handles the creation, registration, and execution of various interaction types including player-to-player interactions, entity interactions, and personal actions. The library operates on both server and client sides, with the server managing interaction registration and validation, while the client handles UI display and user input. It includes range checking, timed actions, and network synchronization to ensure consistent interaction behavior across all clients. The library supports both immediate and delayed actions with progress indicators, making it suitable for complex interaction systems like money transfers, voice changes, and other gameplay mechanics.
]]
lia.playerinteract = lia.playerinteract or {}
lia.playerinteract.stored = lia.playerinteract.stored or {}
lia.playerinteract.categories = lia.playerinteract.categories or {}
function lia.playerinteract.isWithinRange(client, entity, customRange)
    if not IsValid(client) or not IsValid(entity) then return false end
    local range = customRange or 250
    return entity:GetPos():DistToSqr(client:GetPos()) < range * range
end

function lia.playerinteract.getInteractions(client)
    client = client or LocalPlayer()
    local ent = client:getTracedEntity()
    if not IsValid(ent) then return {} end
    local interactions = {}
    local isPlayerTarget = ent:IsPlayer()
    for name, opt in pairs(lia.playerinteract.stored) do
        if opt.type == "interaction" then
            local targetType = opt.target or "player"
            local targetMatches = targetType == "any" or targetType == "player" and isPlayerTarget or targetType == "entity" and not isPlayerTarget
            if targetMatches and (not opt.shouldShow or opt.shouldShow(client, ent)) then interactions[name] = opt end
        end
    end
    return interactions
end

function lia.playerinteract.getActions(client)
    client = client or LocalPlayer()
    if not IsValid(client) or not client:getChar() then return {} end
    local actions = {}
    for name, opt in pairs(lia.playerinteract.stored) do
        if opt.type == "action" and (not opt.shouldShow or opt.shouldShow(client)) then actions[name] = opt end
    end
    return actions
end

function lia.playerinteract.getCategorizedOptions(options)
    local flatList = {}
    for _, entry in pairs(options) do
        flatList[#flatList + 1] = entry
    end
    return flatList
end

if SERVER then
    function lia.playerinteract.addInteraction(name, data)
        data.type = "interaction"
        data.range = data.range or 250
        data.category = data.category or L("categoryUnsorted")
        data.target = data.target or "player"
        data.timeToComplete = data.timeToComplete or nil
        data.actionText = data.actionText or nil
        data.targetActionText = data.targetActionText or nil
        if data.shouldShow then data.shouldShowName = name end
        if data.onRun and data.timeToComplete and (data.actionText or data.targetActionText) then
            local originalOnRun = data.onRun
            data.onRun = function(client, target)
                if data.actionText then client:setAction(data.actionText, data.timeToComplete, function() originalOnRun(client, target) end) end
                if data.targetActionText and IsValid(target) and target:IsPlayer() then target:setAction(data.targetActionText, data.timeToComplete) end
                if not data.actionText then originalOnRun(client, target) end
            end
        end

        lia.playerinteract.stored[name] = data
        if not lia.playerinteract.categories[data.category] then
            lia.playerinteract.categories[data.category] = {
                name = data.category,
                color = data.categoryColor or Color(255, 255, 255, 255)
            }
        end
    end

    function lia.playerinteract.addAction(name, data)
        data.type = "action"
        data.range = data.range or 250
        data.category = data.category or L("categoryUnsorted")
        data.timeToComplete = data.timeToComplete or nil
        data.actionText = data.actionText or nil
        data.targetActionText = data.targetActionText or nil
        if data.shouldShow then data.shouldShowName = name end
        if data.onRun and data.timeToComplete and (data.actionText or data.targetActionText) then
            local originalOnRun = data.onRun
            data.onRun = function(client, target)
                if data.actionText then client:setAction(data.actionText, data.timeToComplete, function() originalOnRun(client, target) end) end
                if data.targetActionText and IsValid(target) and target:IsPlayer() then target:setAction(data.targetActionText, data.timeToComplete) end
                if not data.actionText then originalOnRun(client, target) end
            end
        end

        lia.playerinteract.stored[name] = data
        if not lia.playerinteract.categories[data.category] then
            lia.playerinteract.categories[data.category] = {
                name = data.category,
                color = data.categoryColor or Color(255, 255, 255, 255)
            }
        end
    end

    function lia.playerinteract.syncToClients(client)
        local filteredData = {}
        for name, data in pairs(lia.playerinteract.stored) do
            filteredData[name] = {
                type = data.type,
                serverOnly = data.serverOnly and true or false,
                name = name,
                range = data.range,
                category = data.category or L("categoryUnsorted"),
                target = data.target,
                timeToComplete = data.timeToComplete,
                actionText = data.actionText,
                targetActionText = data.targetActionText
            }
        end

        if client then
            lia.net.writeBigTable(client, "liaPlayerInteractSync", filteredData)
            lia.net.writeBigTable(client, "liaPlayerInteractCategories", lia.playerinteract.categories)
        else
            local players = player.GetAll()
            local batchSize = 3
            local delay = 0
            for i = 1, #players, batchSize do
                timer.Simple(delay, function()
                    local batch = {}
                    for j = i, math.min(i + batchSize - 1, #players) do
                        table.insert(batch, players[j])
                    end

                    for _, ply in ipairs(batch) do
                        lia.net.writeBigTable(ply, "liaPlayerInteractSync", filteredData)
                        lia.net.writeBigTable(ply, "liaPlayerInteractCategories", lia.playerinteract.categories)
                    end
                end)

                delay = delay + 0.15
            end
        end
    end

    lia.playerinteract.addInteraction("giveMoney", {
        serverOnly = true,
        shouldShow = function(client, target) return IsValid(target) and target:IsPlayer() and client:getChar():getMoney() > 0 end,
        onRun = function(client, target)
            client:requestString("@giveMoney", "@enterAmount", function(amount)
                amount = tonumber(amount)
                if not amount or amount <= 0 then
                    client:notifyErrorLocalized("invalidAmount")
                    return
                end

                if lia.config.get("DisableCheaterActions", true) and client:getNetVar("cheater", false) then
                    lia.log.add(client, "cheaterAction", L("cheaterActionTransferMoney"))
                    client:notifyWarningLocalized("maybeYouShouldntHaveCheated")
                    return
                end

                if not IsValid(client) or not client:getChar() then return end
                if client:isFamilySharedAccount() and not lia.config.get("AltsDisabled", false) then
                    client:notifyErrorLocalized("familySharedMoneyTransferDisabled")
                    return
                end

                if not IsValid(target) or not target:IsPlayer() or not target:getChar() then return end
                if not client:getChar():hasMoney(amount) then
                    client:notifyErrorLocalized("notEnoughMoney")
                    return
                end

                target:getChar():giveMoney(amount)
                client:getChar():takeMoney(amount)
                local senderName = client:getChar():getDisplayedName(target)
                local targetName = client:getChar():getDisplayedName(client)
                client:notifyMoneyLocalized("moneyTransferSent", lia.currency.get(amount), targetName)
                target:notifyMoneyLocalized("moneyTransferReceived", lia.currency.get(amount), senderName)
            end, "")
        end
    })

    lia.playerinteract.addAction("changeToWhisper", {
        category = L("categoryVoice"),
        shouldShow = function(client) return client:getChar() and client:Alive() and client:getNetVar("VoiceType") ~= L("whispering") end,
        onRun = function(client)
            client:setNetVar("VoiceType", L("whispering"))
            client:notifyInfoLocalized("voiceModeSet", L("whispering"))
        end,
        serverOnly = true
    })

    lia.playerinteract.addAction("changeToTalk", {
        category = L("categoryVoice"),
        shouldShow = function(client) return client:getChar() and client:Alive() and client:getNetVar("VoiceType") ~= L("talking") end,
        onRun = function(client)
            client:setNetVar("VoiceType", L("talking"))
            client:notifyInfoLocalized("voiceModeSet", L("talking"))
        end,
        serverOnly = true
    })

    lia.playerinteract.addAction("changeToYell", {
        category = L("categoryVoice"),
        shouldShow = function(client) return client:getChar() and client:Alive() and client:getNetVar("VoiceType") ~= L("yelling") end,
        onRun = function(client)
            client:setNetVar("VoiceType", L("yelling"))
            client:notifyInfoLocalized("voiceModeSet", L("yelling"))
        end,
        serverOnly = true
    })
else
    function lia.playerinteract.openMenu(options, isInteraction, titleText, closeKey, netMsg, preFiltered)
        local client = LocalPlayer()
        if not IsValid(client) then return end
        local ent = isfunction(client.getTracedEntity) and client:getTracedEntity() or NULL
        return lia.derma.optionsMenu(options, {
            mode = isInteraction and "interaction" or "action",
            title = titleText,
            closeKey = closeKey,
            netMsg = netMsg,
            preFiltered = preFiltered,
            entity = ent
        })
    end

    lia.net.readBigTable("liaPlayerInteractSync", function(data)
        if not istable(data) then return end
        local newStored = {}
        for name, incoming in pairs(data) do
            local localEntry = lia.playerinteract.stored[name] or {}
            local merged = table.Copy(localEntry)
            merged.type = incoming.type or localEntry.type
            merged.serverOnly = incoming.serverOnly and true or false
            merged.name = name
            merged.category = incoming.category or localEntry.category or L("categoryUnsorted")
            if incoming.range ~= nil then merged.range = incoming.range end
            merged.target = incoming.target or localEntry.target or "player"
            if incoming.timeToComplete ~= nil then merged.timeToComplete = incoming.timeToComplete end
            if incoming.actionText ~= nil then merged.actionText = incoming.actionText end
            if incoming.targetActionText ~= nil then merged.targetActionText = incoming.targetActionText end
            merged.onRun = localEntry.onRun
            newStored[name] = merged
        end

        lia.playerinteract.stored = newStored
    end)

    lia.net.readBigTable("liaPlayerInteractCategories", function(data) if istable(data) then lia.playerinteract.categories = data end end)
end

lia.keybind.add("interactionMenu", {
    keyBind = KEY_TAB,
    desc = L("interactionMenuDesc"),
    onPress = function()
        net.Start("liaRequestInteractOptions")
        net.WriteString("interaction")
        net.SendToServer()
    end,
})

lia.keybind.add("personalActions", {
    keyBind = KEY_G,
    desc = L("personalActionsDesc"),
    onPress = function()
        net.Start("liaRequestInteractOptions")
        net.WriteString("action")
        net.SendToServer()
    end,
})
