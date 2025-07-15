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
                MODULE:callOnDoorChildren(door, function(child) child:removeDoorAccessData() end)
                client:getChar():giveMoney(price)
                client:notifyLocalized("doorSold", lia.currency.get(price))
                hook.Run("OnPlayerPurchaseDoor", client, door, false, MODULE.callOnDoorChildren)
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
                MODULE:callOnDoorChildren(door, function(child) child:removeDoorAccessData() end)
                owner:getChar():giveMoney(price)
                owner:notifyLocalized("doorSold", lia.currency.get(price))
                client:notifyLocalized("doorSold", lia.currency.get(price))
                hook.Run("OnPlayerPurchaseDoor", owner, door, false, MODULE.callOnDoorChildren)
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
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            if door:getNetVar("noSell") or door:getNetVar("faction") or door:getNetVar("class") then return client:notifyLocalized("doorNotAllowedToOwn") end
            if IsValid(door:GetDTEntity(0)) then
                client:notifyLocalized("doorOwnedBy", door:GetDTEntity(0):Name())
                return false
            end

            local price = door:getNetVar("price", 0)
            if client:getChar():hasMoney(price) then
                door:SetDTEntity(0, client)
                door.liaAccess = {
                    [client] = DOOR_OWNER
                }

                MODULE:callOnDoorChildren(door, function(child) child:SetDTEntity(0, client) end)
                client:getChar():takeMoney(price)
                client:notifyLocalized("doorPurchased", lia.currency.get(price))
                hook.Run("OnPlayerPurchaseDoor", client, door, true, MODULE.callOnDoorChildren)
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
            MODULE:callOnDoorChildren(door, function(child) child:setNetVar("noSell", newState and true or nil) end)
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
            door:setNetVar("class", nil)
            door:setNetVar("factions", "[]")
            door:setNetVar("title", nil)
            door:setNetVar("price", 0)
            door:setNetVar("locked", false)
            MODULE:callOnDoorChildren(door, function(child)
                child:setNetVar("disabled", nil)
                child:setNetVar("noSell", nil)
                child:setNetVar("hidden", nil)
                child:setNetVar("class", nil)
                child:setNetVar("factions", "[]")
                child:setNetVar("title", nil)
                child:setNetVar("price", 0)
                child:setNetVar("locked", false)
            end)

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
            MODULE:callOnDoorChildren(door, function(child) child:setNetVar("disabled", newState and true or nil) end)
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
            MODULE:callOnDoorChildren(entity, function(child)
                child:setNetVar("hidden", newState)
                lia.log.add(client, "doorSetHidden", child, newState)
            end)
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
            MODULE:callOnDoorChildren(door, function(child) child:setNetVar("price", price) end)
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
            if door:checkDoorAccess(client, DOOR_TENANT) then
                door:setNetVar("title", name)
                hook.Run("DoorTitleSet", client, door, name)
                lia.log.add(client, "doorSetTitle", door, name)
            elseif client:isStaff() then
                door:setNetVar("name", name)
                MODULE:callOnDoorChildren(door, function(child) child:setNetVar("name", name) end)
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

lia.command.add("doorsetparent", {
    desc = "doorsetparentDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickSetDoorParentName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            client.liaDoorParent = door
            lia.log.add(client, "doorSetParent", door)
            hook.Run("DoorParentSet", client, door)
            client:notifyLocalized("doorSetParentDoor")
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsetchild", {
    desc = "doorsetchildDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickSetDoorChildName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            if client.liaDoorParent == door then return client:notifyLocalized("doorCanNotSetAsChild") end
            if IsValid(client.liaDoorParent) then
                client.liaDoorParent.liaChildren = client.liaDoorParent.liaChildren or {}
                client.liaDoorParent.liaChildren[door:MapCreationID()] = true
                door.liaParent = client.liaDoorParent
                lia.log.add(client, "doorAddChild", client.liaDoorParent, door)
                hook.Run("DoorChildAdded", client, door, client.liaDoorParent)
                client:notifyLocalized("doorAddChildDoor")
                MODULE:SaveData()
                MODULE:copyParentDoor(door)
            else
                client:notifyLocalized("doorNoParentDoor")
            end
        else
            client:notifyLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorremovechild", {
    desc = "doorremovechildDesc",
    adminOnly = true,
    privilege = "Manage Doors",
    AdminStick = {
        Name = "adminStickRemoveDoorChildName",
        TargetClass = "Door"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() and not door:getNetVar("disabled", false) then
            if client.liaDoorParent == door then
                MODULE:callOnDoorChildren(door, function(child)
                    lia.log.add(client, "doorRemoveChild", door, child)
                    child.liaParent = nil
                    hook.Run("DoorChildRemoved", client, child, door)
                end)

                door.liaChildren = nil
                client:notifyLocalized("doorRemoveChildren")
                return
            end

            if IsValid(door.liaParent) and door.liaParent.liaChildren then
                local parentDoor = door.liaParent
                parentDoor.liaChildren[door:MapCreationID()] = nil
                lia.log.add(client, "doorRemoveChild", parentDoor, door)
                door.liaParent = nil
                hook.Run("DoorChildRemoved", client, door, parentDoor)
                client:notifyLocalized("doorRemoveChildDoor")
                MODULE:SaveData()
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
            local faction = door:getNetVar("faction", L("none"))
            local factions = door:getNetVar("factions", "[]")
            local class = door:getNetVar("class", L("none"))
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
                    property = L("faction"),
                    value = tostring(faction)
                },
                {
                    property = L("doorInfoFactions"),
                    value = tostring(factions)
                },
                {
                    property = L("class"),
                    value = tostring(class)
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
                door.liaFactionID = faction.uniqueID
                local facs = door:getNetVar("factions", "[]")
                facs = util.JSONToTable(facs)
                facs[faction.index] = true
                local json = util.TableToJSON(facs)
                door:setNetVar("factions", json)
                MODULE:callOnDoorChildren(door, function()
                    local childFacs = door:getNetVar("factions", "[]")
                    childFacs = util.JSONToTable(childFacs)
                    childFacs[faction.index] = true
                    local childJson = util.TableToJSON(childFacs)
                    door:setNetVar("factions", childJson)
                end)

                lia.log.add(client, "doorSetFaction", door, faction.name)
                client:notifyLocalized("doorSetFaction", faction.name)
            elseif arguments[1] then
                client:notifyLocalized("invalidFaction")
            else
                door:setNetVar("factions", "[]")
                MODULE:callOnDoorChildren(door, function() door:setNetVar("factions", "[]") end)
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
                door.liaFactionID = nil
                local facs = door:getNetVar("factions", "[]")
                facs = util.JSONToTable(facs)
                facs[faction.index] = nil
                local json = util.TableToJSON(facs)
                door:setNetVar("factions", json)
                MODULE:callOnDoorChildren(door, function()
                    local childFacs = door:getNetVar("factions", "[]")
                    childFacs = util.JSONToTable(childFacs)
                    childFacs[faction.index] = nil
                    local childJson = util.TableToJSON(childFacs)
                    door:setNetVar("factions", childJson)
                end)

                lia.log.add(client, "doorRemoveFaction", door, faction.name)
                client:notifyLocalized("doorRemoveFaction", faction.name)
            elseif arguments[1] then
                client:notifyLocalized("invalidFaction")
            else
                door:setNetVar("factions", "[]")
                MODULE:callOnDoorChildren(door, function() door:setNetVar("factions", "[]") end)
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
                local name = table.concat(arguments, " ")
                for k, v in pairs(lia.class.list) do
                    if lia.util.stringMatches(v.name, name) then
                        class, classData = k, v
                        break
                    end
                end
            end

            if class then
                door.liaClassID = class
                door:setNetVar("class", class)
                MODULE:callOnDoorChildren(door, function()
                    door.liaClassID = class
                    door:setNetVar("class", class)
                end)

                lia.log.add(client, "doorSetClass", door, classData.name)
                client:notifyLocalized("doorSetClass", classData.name)
            elseif arguments[1] then
                client:notifyLocalized("invalidClass")
            else
                door:setNetVar("class", nil)
                MODULE:callOnDoorChildren(door, function() door:setNetVar("class", nil) end)
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
                MODULE:callOnDoorChildren(door, function(child)
                    child:setNetVar("disabled", toggleToDisable and true or nil)
                    lia.log.add(client, toggleToDisable and "doorDisable" or "doorEnable", child)
                end)

                count = count + 1
            end
        end

        client:notifyLocalized(toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.log.add(client, toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        MODULE:SaveData()
    end
})