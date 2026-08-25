local VOICE_WHISPERING = "whispering"
local VOICE_TALKING = "talking"
local VOICE_YELLING = "yelling"
lia.playerinteract = lia.playerinteract or {}
lia.playerinteract.stored = lia.playerinteract.stored or {}
lia.playerinteract.categories = lia.playerinteract.categories or {}
lia.playerinteract._lastSyncInteractionCount = lia.playerinteract._lastSyncInteractionCount or 0
lia.playerinteract._lastSyncCategoryCount = lia.playerinteract._lastSyncCategoryCount or 0
function lia.playerinteract.isWithinRange(client, entity, customRange)
    if not IsValid(client) or not IsValid(entity) then return false end
    local range = customRange or 100
    return entity:GetPos():DistToSqr(client:GetPos()) < range * range
end

function lia.playerinteract.getCategorizedOptions(options)
    local categorized = {}
    local categories = {}
    for _, entry in pairs(options) do
        local category = entry.opt and entry.opt.category or "Unsorted"
        if not categories[category] then categories[category] = {} end
        table.insert(categories[category], entry)
    end

    local sortedCategories = {}
    for categoryName, _ in pairs(categories) do
        table.insert(sortedCategories, categoryName)
    end

    table.sort(sortedCategories, function(a, b)
        if a == "Unsorted" then return false end
        if b == "Unsorted" then return true end
        return a < b
    end)

    for _, categoryName in ipairs(sortedCategories) do
        local categoryData = lia.playerinteract.categories[categoryName]
        local categoryColor = categoryData and categoryData.color or (lia.color.theme and lia.color.theme.category_accent or Color(100, 150, 200, 255))
        table.insert(categorized, {
            isCategory = true,
            name = categoryName,
            color = categoryColor,
            count = #categories[categoryName]
        })

        for _, entry in ipairs(categories[categoryName]) do
            table.insert(categorized, entry)
        end
    end
    return categorized
end

if SERVER then
    function lia.playerinteract.addInteraction(name, data)
        data.type = "interaction"
        data.range = data.range or 100
        data.category = isstring(data.category) and data.category or data.category or "Unsorted"
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
                color = data.categoryColor or (lia.color.theme and lia.color.theme.category_accent or Color(100, 150, 200, 255))
            }
        end
    end

    function lia.playerinteract.addAction(name, data)
        data.type = "action"
        data.range = data.range or 100
        data.category = isstring(data.category) and data.category or data.category or "Unsorted"
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
                color = data.categoryColor or (lia.color.theme and lia.color.theme.category_accent or Color(100, 150, 200, 255))
            }
        end
    end

    function lia.playerinteract.sync(client)
        local filteredData = {}
        for name, data in pairs(lia.playerinteract.stored) do
            filteredData[name] = {
                type = data.type,
                serverOnly = data.serverOnly and true or false,
                name = name,
                range = data.range,
                category = data.category or "Unsorted",
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
            lia.playerinteract._lastSyncInteractionCount = table.Count(lia.playerinteract.stored)
            lia.playerinteract._lastSyncCategoryCount = table.Count(lia.playerinteract.categories)
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
                        if IsValid(ply) then
                            lia.net.writeBigTable(ply, "liaPlayerInteractSync", filteredData)
                            lia.net.writeBigTable(ply, "liaPlayerInteractCategories", lia.playerinteract.categories)
                        end
                    end
                end)

                delay = delay + 0.15
            end
        end
    end

    function lia.playerinteract.hasChanges()
        local currentInteractionCount = table.Count(lia.playerinteract.stored)
        local currentCategoryCount = table.Count(lia.playerinteract.categories)
        return currentInteractionCount ~= lia.playerinteract._lastSyncInteractionCount or currentCategoryCount ~= lia.playerinteract._lastSyncCategoryCount
    end

    lia.playerinteract.addInteraction("giveMoney", {
        serverOnly = true,
        shouldShow = function(client, target) return IsValid(target) and target:IsPlayer() and client:getChar():getMoney() > 0 end,
        onRun = function(client, target)
            client:requestString("Give Money", "Enter amount...", function(amount)
                local originalAmount = tonumber(amount) or 0
                amount = math.floor(originalAmount)
                if originalAmount ~= amount and originalAmount > 0 then
                    lia.log.add(client, "moneyDupeAttempt", "Attempted to give " .. tostring(originalAmount) .. " money (floored to " .. amount .. ")")
                    for _, admin in player.Iterator() do
                        if admin:IsAdmin() then admin:notify(string.format("%s attempted to %s with decimal amount %s (floored to %s) - potential money duping!", client:Name(), "givemoney", tostring(originalAmount), tostring(amount))) end
                    end
                end

                if not amount or amount <= 0 then
                    client:notifyError("Invalid amount.")
                    return
                end

                if not IsValid(client) or not client:getChar() then return end
                if client:isFamilySharedAccount() and not lia.config.get("AltsDisabled", false) then
                    client:notifyError("You cannot transfer or drop money with a family-shared account")
                    return
                end

                if not IsValid(target) or not target:IsPlayer() or not target:getChar() then return end
                if not client:getChar():hasMoney(amount) then
                    client:notifyError("You don't have enough money")
                    return
                end

                target:getChar():giveMoney(amount)
                client:getChar():takeMoney(amount)
                local senderName = client:getChar():getDisplayedName(target)
                local targetName = client:getChar():getDisplayedName(client)
                client:notifyMoney(string.format("You transferred %s to %s", lia.currency.get(amount), targetName))
                target:notifyMoney(string.format("You received %s from %s", lia.currency.get(amount), senderName))
                client:doGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
            end, "")
        end
    })

    lia.playerinteract.addAction("changeToWhisper", {
        category = "Voice",
        shouldShow = function(client) return client:getChar() and client:Alive() and client:getLocalVar("VoiceType") ~= "Whispering" end,
        onRun = function(client)
            client:setLocalVar("VoiceType", VOICE_WHISPERING)
            client:notifyInfo(string.format("Voice range set to %s.", "Whispering"))
            hook.Run("OnVoiceTypeChanged", client)
        end,
        serverOnly = true
    })

    lia.playerinteract.addAction("changeToTalk", {
        category = "Voice",
        shouldShow = function(client) return client:getChar() and client:Alive() and client:getLocalVar("VoiceType") ~= VOICE_TALKING end,
        onRun = function(client)
            client:setLocalVar("VoiceType", VOICE_TALKING)
            client:notifyInfo(string.format("Voice range set to %s.", "Talking"))
            hook.Run("OnVoiceTypeChanged", client)
        end,
        serverOnly = true
    })

    lia.playerinteract.addAction("changeToYell", {
        category = "Voice",
        shouldShow = function(client) return client:getChar() and client:Alive() and client:getLocalVar("VoiceType") ~= VOICE_YELLING end,
        onRun = function(client)
            client:setLocalVar("VoiceType", VOICE_YELLING)
            client:notifyInfo(string.format("Voice range set to %s.", "Yelling"))
            hook.Run("OnVoiceTypeChanged", client)
        end,
        serverOnly = true
    })
else
    function lia.playerinteract.openMenu(options, isInteraction, titleText, closeKey, netMsg, preFiltered)
        local client = LocalPlayer()
        if not IsValid(client) then return end
        local ent = isfunction(client.getTracedEntity) and client:getTracedEntity(100) or NULL
        lia.gui = lia.gui or {}
        if IsValid(lia.gui.InteractionMenu) then lia.gui.InteractionMenu:Remove() end
        if not istable(options) or table.IsEmpty(options) then return end
        local entries = {}
        if preFiltered then
            for name, option in pairs(options) do
                if istable(option) then
                    entries[#entries + 1] = {
                        id = name,
                        label = name,
                        opt = option
                    }
                end
            end
        else
            for name, option in pairs(options) do
                if istable(option) then
                    entries[#entries + 1] = {
                        id = name,
                        label = option.displayName or option.label or option.name or name,
                        opt = option
                    }
                end
            end
        end

        if #entries == 0 then return end
        local categorized = lia.playerinteract.getCategorizedOptions(entries)
        local radial = vgui.Create("liaRadialPanel")
        local categories = {}
        radial:SetCenterText(titleText or (isInteraction and "Player Interactions" or "Actions Menu"), "Select Option")
        for _, entry in ipairs(categorized) do
            if entry.isCategory then
                local submenu = radial:CreateSubMenu(entry.name, "Select Option")
                categories[entry.name] = submenu
                radial:AddSubMenuOption(entry.name, submenu)
            else
                local submenu = categories[entry.opt.category] or radial
                submenu:AddOption(entry.label, function()
                    if entry.opt.serverOnly and netMsg then
                        if netMsg == "liaRunInteraction" then
                            net.Start("liaRunInteraction")
                        else
                            net.Start(netMsg)
                        end

                        net.WriteString(entry.id)
                        net.WriteBool(isInteraction)
                        net.WriteEntity(IsValid(ent) and ent or Entity(0))
                        net.SendToServer()
                    end
                end, entry.opt.icon, entry.opt.description or entry.opt.desc)
            end
        end

        radial:SetCloseKey(closeKey)
        lia.gui.InteractionMenu = radial
        hook.Run("InteractionMenuOpened", radial)
        local oldOnRemove = radial.OnRemove
        function radial:OnRemove()
            if oldOnRemove then oldOnRemove(self) end
            if lia.gui.InteractionMenu == self then lia.gui.InteractionMenu = nil end
            hook.Run("InteractionMenuClosed")
        end
        return radial
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
            merged.category = incoming.category or localEntry.category or "Unsorted"
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
    local function isValidReloadPanel(panel)
        return ispanel(panel) and IsValid(panel)
    end

    local function shouldPreserveReloadPanel(panel)
        if not isValidReloadPanel(panel) then return true end
        local panelName = panel.GetName and panel:GetName() or ""
        if panelName == "liaChatBox" then return true end
        local initInfo = panel.Init and debug.getinfo(panel.Init, "Sln")
        local src = initInfo and initInfo.short_src or ""
        return src:find("chatbox") or src:find("spawnmenu") or src:find("creationmenu") or src:find("controlpanel")
    end

    local function cleanupReloadPanels()
        if lia.gui then
            for key, panel in pairs(lia.gui) do
                if not isValidReloadPanel(panel) then
                    lia.gui[key] = nil
                elseif not shouldPreserveReloadPanel(panel) then
                    if panel.Remove then panel:Remove() end
                    lia.gui[key] = nil
                end
            end
        end

        local world = vgui.GetWorldPanel()
        if IsValid(world) then
            local children = world:GetChildren()
            for _, panel in ipairs(children) do
                if IsValid(panel) and not shouldPreserveReloadPanel(panel) then panel:Remove() end
            end
        end
    end

    hook.Add("OnReloaded", "liaCleanupReloadPanels", function() timer.Simple(0.05, cleanupReloadPanels) end)
    timer.Simple(0.05, cleanupReloadPanels)
    if lia.playerinteract.stored then table.Empty(lia.playerinteract.stored) end
    if lia.playerinteract.categories then table.Empty(lia.playerinteract.categories) end
end
