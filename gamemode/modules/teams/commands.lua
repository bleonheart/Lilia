
-- Team, faction, and class command registrations.
lia.command.add("plytransfer", {
    adminOnly = true,
    desc = "@plyTransferDesc",
    alias = {"charsetfaction"},
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    if k ~= "staff" then options[v.name] = k end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local targetPlayer
        local factionArgIndex = 2
        if istable(arguments) and #arguments >= 2 then
            local lastArg = arguments[#arguments]
            local assumedFaction = lia.faction.teams[lastArg]
            if not assumedFaction then
                local factionIndex = tonumber(lastArg)
                if factionIndex then assumedFaction = lia.faction.indices[factionIndex] end
            end

            if assumedFaction then
                local assumedName = table.concat(arguments, " ", 1, #arguments - 1)
                local assumedTarget = lia.util.findPlayer(client, assumedName)
                if assumedTarget and IsValid(assumedTarget) then
                    targetPlayer = assumedTarget
                    factionArgIndex = #arguments
                end
            end
        end

        targetPlayer = targetPlayer or lia.util.findPlayer(client, arguments[1])
        if (not targetPlayer or not IsValid(targetPlayer)) and arguments[2] then
            local combined = tostring(arguments[1]) .. " " .. tostring(arguments[2])
            local combinedTarget = lia.util.findPlayer(client, combined)
            if combinedTarget and IsValid(combinedTarget) then
                targetPlayer = combinedTarget
                factionArgIndex = 3
            end
        end

        if (not targetPlayer or not IsValid(targetPlayer)) and arguments[3] then
            local combined = tostring(arguments[1]) .. " " .. tostring(arguments[2]) .. " " .. tostring(arguments[3])
            local combinedTarget = lia.util.findPlayer(client, combined)
            if combinedTarget and IsValid(combinedTarget) then
                targetPlayer = combinedTarget
                factionArgIndex = 4
            end
        end

        if not targetPlayer or not IsValid(targetPlayer) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local factionName = arguments[factionArgIndex]
        local faction = lia.faction.teams[factionName]
        if not faction then
            local factionIndex = tonumber(factionName)
            if factionIndex then faction = lia.faction.indices[factionIndex] end
        end

        if not faction then
            faction = lia.util.findFaction(client, tostring(factionName))
            if not faction then return end
        end

        if faction.uniqueID == "staff" then
            client:notifyErrorLocalized("staffTransferBlocked")
            return
        end

        local targetChar = targetPlayer:getChar()
        if hook.Run("CanCharBeTransfered", targetChar, faction, targetPlayer:Team()) == false then return end
        local oldFaction = targetChar:getFaction()
        local oldFactionName = lia.faction.indices[oldFaction] and lia.faction.indices[oldFaction].name or oldFaction
        hook.Run("TrackFactionTransfer", targetChar, oldFaction, faction, client, "commandTransfer")
        targetChar.vars.faction = faction.uniqueID
        targetChar:setFaction(faction.index)
        hook.Run("OnTransferred", targetPlayer)
        if faction.OnTransferred then faction:OnTransferred(targetPlayer, oldFaction) end
        client:notifySuccessLocalized("transferSuccess", targetPlayer:Name(), faction.name)
        if client ~= targetPlayer then targetPlayer:notifyInfoLocalized("transferNotification", faction.name, client:Name()) end
        lia.log.add(client, "plyTransfer", targetPlayer:Name(), oldFactionName, faction.name)
    end
})

lia.command.add("plywhitelist", {
    adminOnly = true,
    desc = "@plyWhitelistDesc",
    alias = {"factionwhitelist"},
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    if k ~= "staff" then options[v.name] = k end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local faction = lia.util.findFaction(client, arguments[2])
        if not faction then
            client:notifyErrorLocalized("invalidFaction")
            return
        end

        if faction.uniqueID == "staff" then
            client:notifyErrorLocalized("staffWhitelistBlocked")
            return
        end

        local data = lia.faction.indices[faction.index]
        if data then
            if data.uniqueID == "staff" then return end
            local whitelists = target:getLiliaData("whitelists", {})
            whitelists[SCHEMA.folder] = whitelists[SCHEMA.folder] or {}
            whitelists[SCHEMA.folder][data.uniqueID] = true
            target:setLiliaData("whitelists", whitelists)
            for _, v in player.Iterator() do
                v:notifyInfoLocalized("whitelist", client:Name(), target:Name(), faction.name)
            end

            lia.log.add(client, "plyWhitelist", target:Name(), faction.name)
        end
    end
})

lia.command.add("plyunwhitelist", {
    adminOnly = true,
    desc = "@plyUnwhitelistDesc",
    alias = {"factionunwhitelist"},
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    if k ~= "staff" then options[v.name] = k end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local faction = lia.util.findFaction(client, arguments[2])
        if not faction then
            client:notifyErrorLocalized("invalidFaction")
            return
        end

        if faction.uniqueID == "staff" then
            client:notifyErrorLocalized("staffUnwhitelistBlocked")
            return
        end

        if faction and not faction.isDefault then
            local data = lia.faction.indices[faction.index]
            if data then
                if data.uniqueID == "staff" then return end
                local whitelists = target:getLiliaData("whitelists", {})
                whitelists[SCHEMA.folder] = whitelists[SCHEMA.folder] or {}
                whitelists[SCHEMA.folder][data.uniqueID] = nil
                target:setLiliaData("whitelists", whitelists)
                for _, v in player.Iterator() do
                    v:notifyInfoLocalized("unwhitelist", client:Name(), target:Name(), faction.name)
                end

                lia.log.add(client, "plyUnwhitelist", target:Name(), faction.name)
            end
        else
            client:notifyErrorLocalized("invalidFaction")
        end
    end
})

lia.command.add("beclass", {
    adminOnly = false,
    desc = "@beClassDesc",
    arguments = {
        {
            name = "class",
            type = "table",
            options = function()
                local options = {}
                for _, v in pairs(lia.class.list) do
                    options[v.name] = v.uniqueID
                end
                return options
            end
        },
        {
            name = "model",
            type = "string",
            optional = true
        }
    },
    onRun = function(client, arguments)
        local className = arguments[1]
        local requestedModel = arguments[2]
        local character = client:getChar()
        if not IsValid(client) or not character then
            client:notifyErrorLocalized("illegalAccess")
            return
        end

        local classID = tonumber(className) or lia.class.retrieveClass(className)
        local classData = lia.class.get(classID)
        if not classData then
            client:notifyErrorLocalized("invalidClass")
            return
        end

        local classModels = classData.model or classData.models
        local currentClass = character:getClass()
        local isSameClass = currentClass == classID
        local function applyRequestedClassModel()
            if not istable(classModels) then
                character:setData("classModel", nil)
                return false
            end

            if not isstring(requestedModel) or requestedModel == "" then return false end
            local function gatherModels(mdl, out)
                if isstring(mdl) and mdl ~= "" then
                    out[#out + 1] = mdl
                elseif istable(mdl) then
                    for _, v in pairs(mdl) do
                        gatherModels(v, out)
                    end
                end
            end

            local validModels = {}
            gatherModels(classModels, validModels)
            local ok = false
            for _, v in ipairs(validModels) do
                if v == requestedModel then
                    ok = true
                    break
                end
            end

            if not ok then return false end
            if util and util.IsValidModel and not util.IsValidModel(requestedModel) then return false end
            character:setData("classModel", requestedModel)
            return true
        end

        if isSameClass then
            if applyRequestedClassModel() then client:notifyLocalized("modelUpdatedOnRespawn") end
            return
        end

        if lia.class.canBe(client, classID) then
            if character:joinClass(classID) then
                if not istable(classModels) then character:setData("classModel", nil) end
                applyRequestedClassModel()
                client:notifySuccessLocalized("becomeClass", classData.name)
                lia.log.add(client, "beClass", classData.name)
            else
                client:notifyErrorLocalized("becomeClassFail", classData.name)
            end
        else
            client:notifyErrorLocalized("invalidClass")
        end
    end
})

lia.command.add("setclass", {
    adminOnly = true,
    desc = "@setClassDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "class",
            type = "table",
            options = function(client, prefix)
                local options = {}
                local targetName = prefix and prefix[1]
                local target = targetName and lia.util.findPlayer(client, targetName)
                if not target or not target:getChar() then return options end
                local targetFaction = target:Team()
                local factionClasses = lia.faction.getClasses(targetFaction)
                if not factionClasses or #factionClasses == 0 then return options end
                for _, v in pairs(factionClasses) do
                    local canAccess = true
                    if lia.class.hasWhitelist(v.index) then canAccess = target:getChar():getClasswhitelists()[v.index] end
                    if canAccess and target:getChar():getClass() ~= v.uniqueID then options[v.name] = v.uniqueID end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not target:getChar() then
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        if not lia.class.list or table.IsEmpty(lia.class.list) then
            client:notifyErrorLocalized("noClassesAvailable")
            return
        end

        local targetFaction = target:Team()
        local factionClasses = lia.faction.getClasses(targetFaction)
        if not factionClasses or #factionClasses == 0 then
            client:notifyErrorLocalized("factionHasNoClasses")
            return
        end

        local className = arguments[2]
        local classID = lia.class.retrieveClass(className)
        local classData = lia.class.list[classID]
        if classData then
            if target:Team() == classData.faction then
                target:getChar():joinClass(classID, true)
                lia.log.add(client, "setClass", target:Name(), classData.name)
                target:notifyInfoLocalized("classSet", classData.name)
                if client ~= target then client:notifySuccessLocalized("classSetOther", target:GetName(), classData.name) end
                hook.Run("PlayerLoadout", target)
            else
                client:notifyErrorLocalized("classFactionMismatch")
            end
        else
            client:notifyErrorLocalized("invalidClass")
        end
    end
})

lia.command.add("classwhitelist", {
    adminOnly = true,
    desc = "@classWhitelistDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "class",
            type = "table",
            options = function()
                local options = {}
                for _, v in pairs(lia.class.list) do
                    options[v.name] = v.uniqueID
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local classID = lia.class.retrieveClass(arguments[2])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        elseif not classID then
            client:notifyErrorLocalized("invalidClass")
            return
        end

        local classData = lia.class.list[classID]
        if target:Team() ~= classData.faction then
            client:notifyErrorLocalized("whitelistFactionMismatch")
        elseif target:getChar():getClasswhitelists()[classID] then
            client:notifyInfoLocalized("alreadyWhitelisted")
        else
            local wl = target:getChar():getClasswhitelists()
            wl[classID] = true
            target:getChar():setClasswhitelists(wl)
            client:notifySuccessLocalized("whitelistedSuccess")
            target:notifyInfoLocalized("classAssigned", classData.name)
            lia.log.add(client, "classWhitelist", target:Name(), classData.name)
        end
    end
})

lia.command.add("classunwhitelist", {
    adminOnly = true,
    desc = "@classUnwhitelistDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "class",
            type = "table",
            options = function()
                local options = {}
                for _, v in pairs(lia.class.list) do
                    options[v.name] = v.uniqueID
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local classID = lia.class.retrieveClass(arguments[2])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        elseif not classID then
            client:notifyErrorLocalized("invalidClass")
            return
        end

        local classData = lia.class.list[classID]
        if target:Team() ~= classData.faction then
            client:notifyErrorLocalized("whitelistFactionMismatch")
        elseif not target:getChar():getClasswhitelists()[classID] then
            client:notifyInfoLocalized("notWhitelisted")
        else
            local wl = target:getChar():getClasswhitelists()
            wl[classID] = nil
            target:getChar():setClasswhitelists(wl)
            client:notifySuccessLocalized("unwhitelistedSuccess")
            target:notifyInfoLocalized("classUnassigned", classData.name)
            lia.log.add(client, "classUnwhitelist", target:Name(), classData.name)
        end
    end
})

