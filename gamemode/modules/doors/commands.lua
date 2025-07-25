﻿local MODULE = MODULE
lia.command.add("doorsell", {
    desc = "doorsellDesc",
    adminOnly = false,
    AdminStick = {
        Name = "adminStickDoorSellName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            if client == door:GetDTEntity(0) then
                local price = math.Round(door:getNetVar("price", 0) * lia.config.get("DoorSellRatio", 0.5))
                door:removeDoorAccessData()
                client:getChar():giveMoney(price)
                client:notifyLocalized("doorSold", lia.currency.get(price))
                hook.Run("OnPlayerPurchaseDoor", client, door, false)
                lia.log.add(client, "doorsell", price)
            else
                client:notifyLocalized("doorNotOwner")
            end
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("admindoorsell", {
    desc = "admindoorsellDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickAdminDoorSellName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local owner = door:GetDTEntity(0)
            if IsValid(owner) and owner:IsPlayer() then
                local price = math.Round(door:getNetVar("price", 0) * lia.config.get("DoorSellRatio", 0.5))
                door:removeDoorAccessData()
                owner:getChar():giveMoney(price)
                owner:notifyLocalized("doorSold", lia.currency.get(price))
                client:notifyLocalized("doorSold", lia.currency.get(price))
                hook.Run("OnPlayerPurchaseDoor", owner, door, false)
                lia.log.add(client, "admindoorsell", owner:Name(), price)
            else
                client:notifyLocalized("doorNotOwner")
            end
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortogglelock", {
    desc = "doortogglelockDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickToggleDoorLockName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local currentLockState = door:GetInternalVariable("m_bLocked")
            local toggleState = not currentLockState
            if toggleState then
                door:Fire("lock")
                door:EmitSound("doors/door_latch3.wav")
                client:notifyLocalized("doorToggleLocked", "locked")
                lia.log.add(client, "toggleLock", door, "locked")
            else
                door:Fire("unlock")
                door:EmitSound("doors/door_latch1.wav")
                client:notifyLocalized("doorToggleLocked", "unlocked")
                lia.log.add(client, "toggleLock", door, "unlocked")
            end

            local partner = door:getDoorPartner()
            if IsValid(partner) then
                if toggleState then
                    partner:Fire("lock")
                else
                    partner:Fire("unlock")
                end
            end
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorbuy", {
    desc = "doorbuyDesc",
    adminOnly = false,
    AdminStick = {
        Name = "adminStickDoorBuyName",
        TargetClass = "Door"
    },
    onRun = function(client)
        if lia.config.get("DisableCheaterActions", true) and client:getNetVar("cheater", false) then
            lia.log.add(client, "cheaterAction", "buy door")
            return
        end

        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local factions = door:getNetVar("factions")
            local classes = door:getNetVar("classes")
            if door:getNetVar("noSell") or factions and factions ~= "[]" or classes and classes ~= "[]" then return client:notifyLocalized("doorNotAllowedToOwn") end
            if IsValid(door:GetDTEntity(0)) then
                client:notifyLocalized("doorOwnedBy", door:GetDTEntity(0):Name())
                return false
            end

            local price = door:getNetVar("price", 0)
            if client:getChar():hasMoney(price) then
                door:SetDTEntity(0, client)
                door.liaAccess = {
                    [client] = DoorOwner
                }

                client:getChar():takeMoney(price)
                client:notifyLocalized("doorPurchased", lia.currency.get(price))
                hook.Run("OnPlayerPurchaseDoor", client, door, true)
                lia.log.add(client, "buydoor", price)
            else
                client:notifyLocalized("doorCanNotAfford")
            end
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortoggleownable", {
    desc = "doortoggleownableDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickToggleDoorOwnableName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local isUnownable = door:getNetVar("noSell", false)
            local newState = not isUnownable
            door:setNetVar("noSell", newState and true or nil)
            lia.log.add(client, "doorToggleOwnable", door, newState)
            hook.Run("DoorOwnableToggled", client, door, newState)
            client:notify(newState and L("doorMadeUnownable") or L("doorMadeOwnable"))
            MODULE:SaveData()
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorresetdata", {
    desc = "doorresetdataDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickResetDoorDataName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            lia.log.add(client, "doorResetData", door)
            door:setNetVar("disabled", nil)
            door:setNetVar("noSell", nil)
            door:setNetVar("hidden", nil)
            door:setNetVar("classes", nil)
            door:setNetVar("factions", "[]")
            door:setNetVar("title", nil)
            door:setNetVar("price", 0)
            door:setNetVar("locked", false)
            client:notifyLocalized("doorResetData")
            MODULE:SaveData()
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortoggleenabled", {
    desc = "doortoggleenabledDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickToggleDoorEnabledName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local isDisabled = door:getNetVar("disabled", false)
            local newState = not isDisabled
            door:setNetVar("disabled", newState and true or nil)
            lia.log.add(client, newState and "doorDisable" or "doorEnable", door)
            hook.Run("DoorEnabledToggled", client, door, newState)
            client:notify(newState and L("doorSetDisabled") or L("doorSetNotDisabled"))
            MODULE:SaveData()
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortogglehidden", {
    desc = "doortogglehiddenDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickToggleDoorHiddenName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local entity = client:GetEyeTrace().Entity
        if IsValid(entity) and entity:isDoor() then
            local currentState = entity:getNetVar("hidden", false)
            local newState = not currentState
            entity:setNetVar("hidden", newState)
            lia.log.add(client, "doorSetHidden", entity, newState)
            hook.Run("DoorHiddenToggled", client, entity, newState)
            client:notify(newState and L("doorSetHidden") or L("doorSetNotHidden"))
            MODULE:SaveData()
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsetprice", {
    desc = "doorsetpriceDesc",
    syntax = "[number Price]",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickSetDoorPriceName",
        TargetClass = "Door"
    },
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            if not arguments[1] or not tonumber(arguments[1]) then return client:notifyLocalized("invalidClass") end
            local price = math.Clamp(math.floor(tonumber(arguments[1])), 0, 1000000)
            door:setNetVar("price", price)
            lia.log.add(client, "doorSetPrice", door, price)
            hook.Run("DoorPriceSet", client, door, price)
            client:notifyLocalized("priceLabel", lia.currency.get(price))
            MODULE:SaveData()
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsettitle", {
    desc = "doorsettitleDesc",
    syntax = "[string Title]",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickSetDoorTitleName",
        TargetClass = "Door"
    },
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local name = table.concat(arguments, " ")
            if not name:find("%S") then return client:notifyLocalized("invalidClass") end
            if door:checkDoorAccess(client, DoorTenant) then
                door:setNetVar("title", name)
                hook.Run("DoorTitleSet", client, door, name)
                lia.log.add(client, "doorSetTitle", door, name)
            elseif client:isStaff() then
                door:setNetVar("name", name)
                hook.Run("DoorTitleSet", client, door, name)
                lia.log.add(client, "doorSetTitle", door, name)
            else
                client:notifyLocalized("doorNotOwner")
            end
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("savedoors", {
    desc = "savedoorsDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickSaveDoorsName",
        TargetClass = "Door"
    },
    onRun = function(client)
        MODULE:SaveData()
        lia.log.add(client, "doorSaveData")
        client:notifyLocalized("doorsSaved")
    end
})

lia.command.add("doorinfo", {
    desc = "doorinfoDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickDoorInfoName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local disabled = door:getNetVar("disabled", false)
            local name = door:getNetVar("title", door:getNetVar("name", L("doorTitle")))
            local price = door:getNetVar("price", 0)
            local noSell = door:getNetVar("noSell", false)
            local factionsRaw = door:getNetVar("factions", "[]")
            local factionNames = {}
            local factionTable = util.JSONToTable(factionsRaw) or {}
            for _, id in ipairs(factionTable) do
                local info = lia.faction.get(id)
                if info then table.insert(factionNames, info.name) end
            end

            local factionsString = not table.IsEmpty(factionNames) and table.concat(factionNames, ", ") or L("none")
            local classesDataRaw = door:getNetVar("classes", "[]")
            local classesTable = util.JSONToTable(classesDataRaw) or {}
            local classNames = {}
            for _, uid in ipairs(classesTable) do
                local idx = lia.class.retrieveClass(uid)
                local info = lia.class.list[idx]
                if info then table.insert(classNames, info.name) end
            end

            local classesString = not table.IsEmpty(classNames) and table.concat(classNames, ", ") or L("none")
            local hidden = door:getNetVar("hidden", false)
            local locked = door:getNetVar("locked", false)
            local doorData = {
                {
                    property = L("doorInfoDisabled"),
                    value = tostring(disabled)
                },
                {
                    property = L("name"),
                    value = tostring(name)
                },
                {
                    property = L("price"),
                    value = lia.currency.get(price)
                },
                {
                    property = L("doorInfoNoSell"),
                    value = tostring(noSell)
                },
                {
                    property = L("doorInfoFactions"),
                    value = tostring(factionsString)
                },
                {
                    property = L("classes"),
                    value = tostring(classesString)
                },
                {
                    property = L("doorInfoHidden"),
                    value = tostring(hidden)
                },
                {
                    property = L("doorInfoLocked"),
                    value = tostring(locked)
                }
            }

            lia.util.CreateTableUI(client, L("doorInfoTitle"), {
                {
                    name = L("doorInfoProperty"),
                    field = "property"
                },
                {
                    name = L("doorInfoValue"),
                    field = "value"
                }
            }, doorData)
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("dooraddfaction", {
    desc = "dooraddfactionDesc",
    syntax = "[faction Faction]",
    adminOnly = true,
    privilege = "Manage Doors",
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local faction
            if arguments[1] then
                local name = table.concat(arguments, " ")
                for k, v in pairs(lia.faction.teams) do
                    if lia.util.stringMatches(k, name) or lia.util.stringMatches(v.name, name) then
                        faction = v
                        break
                    end
                end
            end

            if faction then
                local facs = util.JSONToTable(door:getNetVar("factions", "[]")) or {}
                if not table.HasValue(facs, faction.uniqueID) then facs[#facs + 1] = faction.uniqueID end
                door.liaFactions = facs
                door:setNetVar("factions", util.TableToJSON(facs))
                lia.log.add(client, "doorSetFaction", door, faction.name)
                client:notifyLocalized("doorSetFaction", faction.name)
            elseif arguments[1] then
                client:notifyLocalized("invalidFaction")
            else
                door.liaFactions = nil
                door:setNetVar("factions", "[]")
                lia.log.add(client, "doorRemoveFaction", door, "all")
                client:notifyLocalized("doorRemoveFaction")
            end

            MODULE:SaveData()
        end
    end
})

lia.command.add("doorremovefaction", {
    desc = "doorremovefactionDesc",
    syntax = "[faction Faction]",
    adminOnly = true,
    privilege = "Manage Doors",
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local faction
            if arguments[1] then
                local name = table.concat(arguments, " ")
                for k, v in pairs(lia.faction.teams) do
                    if lia.util.stringMatches(k, name) or lia.util.stringMatches(v.name, name) then
                        faction = v
                        break
                    end
                end
            end

            if faction then
                local facs = util.JSONToTable(door:getNetVar("factions", "[]")) or {}
                table.RemoveByValue(facs, faction.uniqueID)
                door.liaFactions = facs
                door:setNetVar("factions", util.TableToJSON(facs))
                lia.log.add(client, "doorRemoveFaction", door, faction.name)
                client:notifyLocalized("doorRemoveFaction", faction.name)
            elseif arguments[1] then
                client:notifyLocalized("invalidFaction")
            else
                door.liaFactions = nil
                door:setNetVar("factions", "[]")
                lia.log.add(client, "doorRemoveFaction", door, "all")
                client:notifyLocalized("doorRemoveFaction")
            end

            MODULE:SaveData()
        end
    end
})

lia.command.add("doorsetclass", {
    desc = "doorsetclassDesc",
    syntax = "[class Class]",
    adminOnly = true,
    privilege = "Manage Doors",
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            local class, classData
            if arguments[1] then
                local input = table.concat(arguments, " ")
                local id = tonumber(input) or lia.class.retrieveClass(input)
                if id then
                    class, classData = id, lia.class.list[id]
                else
                    for k, v in pairs(lia.class.list) do
                        if lia.util.stringMatches(v.name, input) or lia.util.stringMatches(v.uniqueID, input) then
                            class, classData = k, v
                            break
                        end
                    end
                end
            end

            if class then
                local classes = util.JSONToTable(door:getNetVar("classes", "[]")) or {}
                if not table.HasValue(classes, classData.uniqueID) then classes[#classes + 1] = classData.uniqueID end
                door.liaClasses = classes
                door:setNetVar("classes", util.TableToJSON(classes))
                lia.log.add(client, "doorSetClass", door, classData.name)
                client:notifyLocalized("doorSetClass", classData.name)
            elseif arguments[1] then
                client:notifyLocalized("invalidClass")
            else
                door.liaClasses = nil
                door:setNetVar("classes", nil)
                lia.log.add(client, "doorRemoveClass", door)
                client:notifyLocalized("doorRemoveClass")
            end

            MODULE:SaveData()
        end
    end,
    alias = {"jobdoor"}
})

lia.command.add("togglealldoors", {
    desc = "togglealldoorsDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    onRun = function(client)
        local toggleToDisable = false
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                toggleToDisable = not door:getNetVar("disabled", false)
                break
            end
        end

        local count = 0
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() and door:getNetVar("disabled", false) ~= toggleToDisable then
                door:setNetVar("disabled", toggleToDisable and true or nil)
                lia.log.add(client, toggleToDisable and "doorDisable" or "doorEnable", door)
                count = count + 1
            end
        end

        client:notifyLocalized(toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.log.add(client, toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        MODULE:SaveData()
    end
})
