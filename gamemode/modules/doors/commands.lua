-- Relocated command registrations.
local function getDoorByMapID(doorID)
    doorID = math.floor(tonumber(doorID) or 0)
    if doorID <= 0 then return end
    local door = ents.GetMapCreatedEntity(doorID)
    if IsValid(door) and door:isDoor() then return door end
end

local function resolveDoorCommandTarget(client, arguments, minimumArgumentCount)
    minimumArgumentCount = minimumArgumentCount or 0
    arguments = istable(arguments) and arguments or {}
    local door
    local nextArgumentIndex = 1
    if #arguments > minimumArgumentCount then
        door = getDoorByMapID(arguments[1])
        if door then nextArgumentIndex = 2 end
    end

    if not IsValid(door) then
        local tracedDoor = client:getTracedEntity()
        if IsValid(tracedDoor) and tracedDoor:isDoor() then door = tracedDoor end
    end

    if not (IsValid(door) and door:isDoor()) then return end
    return door, nextArgumentIndex
end

lia.command.add("doorsell", {
    desc = "@doorsellDesc",
    adminOnly = false,
    AdminStick = {
        Name = "@adminStickDoorSellName",
        ButtonText = "Sell This Door",
        Category = "doorActions",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                if client == door:GetDTEntity(0) then
                    local price = math.Round((doorData.price or 0) * lia.config.get("DoorSellRatio", 0.5))
                    door:removeDoorAccessData()
                    client:getChar():giveMoney(price)
                    client:notifyMoneyLocalized("doorSold", lia.currency.get(price))
                    hook.Run("OnPlayerPurchaseDoor", client, door, false)
                    lia.log.add(client, "doorsell", price)
                else
                    client:notifyErrorLocalized("doorNotOwner")
                end
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("admindoorsell", {
    desc = "@admindoorsellDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickAdminDoorSellName",
        ButtonText = "Force Sell This Door",
        Category = "doorActions",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local owner = door:GetDTEntity(0)
                if IsValid(owner) and owner:IsPlayer() then
                    local price = math.Round((doorData.price or 0) * lia.config.get("DoorSellRatio", 0.5))
                    door:removeDoorAccessData()
                    owner:getChar():giveMoney(price)
                    owner:notifyMoneyLocalized("doorSold", lia.currency.get(price))
                    client:notifyMoneyLocalized("doorSold", lia.currency.get(price))
                    hook.Run("OnPlayerPurchaseDoor", owner, door, false)
                    lia.log.add(client, "admindoorsell", owner:Name(), price)
                else
                    client:notifyErrorLocalized("doorNotOwner")
                end
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortogglelock", {
    desc = "@doortogglelockDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickToggleDoorLockName",
        ButtonText = "Toggle Door Lock",
        Category = "doorActions",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local currentLockState = door:GetInternalVariable("m_bLocked")
                local toggleState = not currentLockState
                if toggleState then
                    door:Fire("lock")
                    door:EmitSound("doors/door_latch3.wav")
                    doorData.locked = true
                    lia.doors.setCachedData(door, doorData)
                    lia.log.add(client, "toggleLock", door, L("locked"))
                else
                    door:Fire("unlock")
                    door:EmitSound("doors/door_latch1.wav")
                    doorData.locked = false
                    lia.doors.setCachedData(door, doorData)
                    lia.log.add(client, "toggleLock", door, L("unlocked"))
                end

                local partner = door:getDoorPartner()
                if IsValid(partner) then
                    local partnerData = lia.doors.getData(partner)
                    if toggleState then
                        partner:Fire("lock")
                        partnerData.locked = true
                        lia.doors.setCachedData(partner, partnerData)
                    else
                        partner:Fire("unlock")
                        partnerData.locked = false
                        lia.doors.setCachedData(partner, partnerData)
                    end
                end
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorbuy", {
    desc = "@doorbuyDesc",
    adminOnly = false,
    AdminStick = {
        Name = "@buyDoor",
        ButtonText = "Buy This Door",
        Category = "doorActions",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local factions = doorData.factions
                local classes = doorData.classes
                if doorData.noSell or (factions and #factions > 0) or (classes and #classes > 0) then return client:notifyErrorLocalized("doorNotAllowedToOwn") end
                if IsValid(door:GetDTEntity(0)) then
                    client:notifyInfoLocalized("doorOwnedBy", door:GetDTEntity(0):Name())
                    return false
                end

                local price = doorData.price or 0
                if client:getChar():hasMoney(price) then
                    door:SetDTEntity(0, client)
                    door.liaAccess = {
                        [client] = DOOR_OWNER
                    }

                    client:getChar():takeMoney(price)
                    client:notifySuccessLocalized("doorPurchased", lia.currency.get(price))
                    hook.Run("OnPlayerPurchaseDoor", client, door, true)
                    lia.log.add(client, "buydoor", price)
                else
                    client:notifyErrorLocalized("doorCanNotAfford")
                end
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortoggleownable", {
    desc = "@doortoggleownableDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickToggleDoorOwnableName",
        ButtonText = "Toggle Door Ownable",
        Category = "doorSettings",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local factions = doorData.factions or {}
                local classes = doorData.classes or {}
                local hasFactions = factions and #factions > 0
                local hasClasses = classes and #classes > 0
                local isUnownable = doorData.noSell or false
                local newState = not isUnownable
                if newState and (hasFactions or hasClasses) then
                    client:notifyErrorLocalized("doorIsNotOwnable")
                    return false
                end

                doorData.noSell = newState and true or nil
                lia.doors.setData(door, doorData)
                lia.log.add(client, "doorToggleOwnable", door, newState)
                hook.Run("DoorOwnableToggled", client, door, newState)
                client:notifySuccessLocalized(newState and "doorMadeUnownable" or "doorMadeOwnable")
                lia.module.get("doors"):SaveData()
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorresetdata", {
    desc = "@doorresetdataDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickResetDoorDataName",
        ButtonText = "Reset Door Data",
        Category = "doorMaintenance",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            lia.log.add(client, "doorResetData", door)
            local doorData = {
                disabled = nil,
                noSell = nil,
                hidden = nil,
                classes = nil,
                factions = {},
                name = nil,
                price = 0,
                locked = false
            }

            lia.doors.setData(door, doorData)
            client:notifySuccessLocalized("doorResetData")
            lia.module.get("doors"):SaveData()
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortoggleenabled", {
    desc = "@doortoggleenabledDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickToggleDoorEnabledName",
        ButtonText = "Toggle Door Enabled",
        Category = "doorSettings",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            local isDisabled = doorData.disabled or false
            local newState = not isDisabled
            doorData.disabled = newState and true or nil
            lia.doors.setData(door, doorData)
            lia.log.add(client, newState and "doorDisable" or "doorEnable", door)
            hook.Run("DoorEnabledToggled", client, door, newState)
            client:notifySuccessLocalized(newState and "doorSetDisabled" or "doorSetNotDisabled")
            lia.module.get("doors").list["doors"]:SaveData()
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doortogglehidden", {
    desc = "@doortogglehiddenDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickToggleDoorHiddenName",
        ButtonText = "Toggle Door Hidden",
        Category = "doorSettings",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            local currentState = doorData.hidden or false
            local newState = not currentState
            doorData.hidden = newState
            lia.doors.setData(door, doorData)
            lia.log.add(client, "doorSetHidden", door, newState)
            hook.Run("DoorHiddenToggled", client, door, newState)
            client:notifySuccessLocalized(newState and "doorSetHidden" or "doorSetNotHidden")
            lia.module.get("doors"):SaveData()
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsetprice", {
    desc = "@doorsetpriceDesc",
    arguments = {
        {
            name = "price",
            type = "string"
        },
    },
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickSetDoorPriceName",
        ButtonText = "Set Door Price",
        Category = "doorSettings",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                if not arguments[argumentIndex] or not tonumber(arguments[argumentIndex]) then return client:notifyErrorLocalized("invalidClass") end
                local price = math.Clamp(math.floor(tonumber(arguments[argumentIndex])), 0, 1000000)
                doorData.price = price
                lia.doors.setData(door, doorData)
                lia.log.add(client, "doorSetPrice", door, price)
                hook.Run("DoorPriceSet", client, door, price)
                client:notifySuccessLocalized("doorSetPrice", lia.currency.get(price))
                lia.module.get("doors"):SaveData()
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsettitle", {
    desc = "@doorsettitleDesc",
    arguments = {
        {
            name = "title",
            type = "string"
        },
    },
    adminOnly = true,
    AdminStick = {
        Name = "@doorsettitle",
        ButtonText = "Set Door Title",
        Category = "doorSettings",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local name = table.concat(arguments, " ", argumentIndex)
                if not name:find("%S") then return client:notifyErrorLocalized("invalidClass") end
                if door:checkDoorAccess(client, DOOR_TENANT) or client:isStaff() then
                    doorData.name = name
                    lia.doors.setData(door, doorData)
                    hook.Run("DoorTitleSet", client, door, name)
                    lia.log.add(client, "doorSetTitle", door, name)
                    client:notifySuccessLocalized("doorTitleSet", name)
                else
                    client:notifyErrorLocalized("doorNotOwner")
                end
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("savedoors", {
    desc = "@savedoorsDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickSaveDoorsName",
        ButtonText = "Save Door Data",
        Category = "doorMaintenance",
        TargetClass = "door",
    },
    onRun = function(client)
        lia.module.get("doors"):SaveData()
        lia.log.add(client, "doorSaveData")
        client:notifySuccessLocalized("doorsSaved")
    end
})

lia.command.add("doorinfo", {
    desc = "@doorinfoDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickDoorInfoName",
        ButtonText = "View Door Info",
        Category = "doorInformation",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            local disabled = doorData.disabled or false
            local price = doorData.price or 0
            local noSell = doorData.noSell or false
            local factions = doorData.factions or {}
            local factionNames = {}
            for _, id in ipairs(factions) do
                local info = lia.faction.get(id)
                if info then table.insert(factionNames, info.name) end
            end

            local classes = doorData.classes or {}
            local classNames = {}
            for _, uid in ipairs(classes) do
                local idx = lia.class.retrieveClass(uid)
                local info = lia.class.list[idx]
                if info then table.insert(classNames, info.name) end
            end

            local hidden = doorData.hidden or false
            local infoData = {
                {
                    property = L("disabled"),
                    value = tostring(disabled)
                },
                {
                    property = L("name"),
                    value = tostring(doorData.name or L("doorTitle"))
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
                    property = L("factions"),
                    value = tostring(not table.IsEmpty(factionNames) and table.concat(factionNames, ", ") or L("none"))
                },
                {
                    property = L("classes"),
                    value = tostring(not table.IsEmpty(classNames) and table.concat(classNames, ", ") or L("none"))
                },
                {
                    property = L("doorInfoHidden"),
                    value = tostring(hidden)
                }
            }

            lia.util.sendTableUI(client, L("door") .. " " .. L("information"), {
                {
                    name = "doorInfoProperty",
                    field = "property"
                },
                {
                    name = "doorInfoValue",
                    field = "value"
                }
            }, infoData)
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsampledata", {
    desc = "@doorsampledataDesc",
    adminOnly = true,
    AdminStick = {
        Name = "@adminStickDoorSampleName",
        ButtonText = "Copy Door Settings",
        Category = "doorMaintenance",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            local sampleData = {
                name = L("sampleDoorName", door:MapCreationID() or L("unknown")),
                price = 1000,
                locked = false,
                disabled = false,
                hidden = false,
                noSell = false,
                factions = {"citizen"},
                classes = {"citizen"}
            }

            for key, value in pairs(sampleData) do
                doorData[key] = value
            end

            lia.doors.setData(door, doorData)
            client:notifyLocalized("doorSampleDataApplied")
            lia.log.add(client, "doorSampleData", door)
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

local randomDoorPrefixes = {"North", "South", "East", "West", "Upper", "Lower", "Grand", "Old", "Prime", "Quiet"}
local randomDoorPlaces = {"Office", "Suite", "Storage", "Lobby", "Workshop", "Checkpoint", "Garage", "Apartment", "Archive", "Lab"}
local function getRandomDoorRestrictionData()
    local restrictionType = math.random(1, 4)
    local data = {
        factions = {},
        classes = {},
        noSell = false
    }

    if restrictionType == 1 then return data end
    if restrictionType == 4 then
        data.noSell = true
        return data
    end

    if restrictionType == 2 then
        local factions = {}
        for _, faction in pairs(lia.faction.indices or {}) do
            if faction and faction.uniqueID and faction.uniqueID ~= "staff" then factions[#factions + 1] = faction.uniqueID end
        end

        if #factions > 0 then
            data.factions = {factions[math.random(#factions)]}
            data.noSell = true
            return data
        end
    end

    local classes = {}
    for _, classData in pairs(lia.class.list or {}) do
        if classData and classData.uniqueID then classes[#classes + 1] = classData.uniqueID end
    end

    if #classes > 0 then
        data.classes = {classes[math.random(#classes)]}
        data.noSell = true
    end
    return data
end

lia.command.add("doorrandominfo", {
    desc = "Apply randomized information to the door you are looking at.",
    adminOnly = true,
    AdminStick = {
        Name = "Randomize Door Info",
        ButtonText = "Randomize Door Info",
        Category = "doorMaintenance",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        local restrictionData = getRandomDoorRestrictionData()
        doorData.name = string.format("%s %s %d", randomDoorPrefixes[math.random(#randomDoorPrefixes)], randomDoorPlaces[math.random(#randomDoorPlaces)], math.random(1, 99))
        doorData.price = math.random(0, 5000)
        doorData.hidden = math.random() > 0.7
        doorData.disabled = math.random() > 0.85
        doorData.noSell = restrictionData.noSell
        doorData.factions = restrictionData.factions
        doorData.classes = restrictionData.classes
        doorData.useCount = math.random(0, 250)
        doorData.lastUsed = os.time() - math.random(0, 86400)
        door.liaFactions = not table.IsEmpty(restrictionData.factions) and restrictionData.factions or nil
        door.liaClasses = not table.IsEmpty(restrictionData.classes) and restrictionData.classes or nil
        lia.doors.setData(door, doorData)
        lia.module.get("doors"):SaveData()
        lia.log.add(client, "doorSampleData", door, "randomized")
        client:notifySuccess("Random door information applied.")
    end
})

lia.command.add("dooraddfaction", {
    desc = "@dooraddfactionDesc",
    arguments = {
        {
            name = "faction",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[argumentIndex]
                local faction
                if input then
                    local factionIndex = tonumber(input)
                    if factionIndex then
                        faction = lia.faction.indices[factionIndex]
                        if not faction then
                            client:notifyErrorLocalized("invalidFaction")
                            return
                        end
                    else
                        for k, v in pairs(lia.faction.teams) do
                            if lia.util.stringMatches(k, input) or lia.util.stringMatches(v.name, input) then
                                faction = v
                                break
                            end
                        end
                    end
                end

                if faction then
                    local facs = doorData.factions or {}
                    if not table.HasValue(facs, faction.uniqueID) then facs[#facs + 1] = faction.uniqueID end
                    doorData.factions = facs
                    door.liaFactions = facs
                    doorData.noSell = true
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorSetFaction", door, faction.name)
                    client:notifySuccessLocalized("doorSetFaction", faction.name)
                elseif arguments[argumentIndex] then
                    client:notifyErrorLocalized("invalidFaction")
                else
                    doorData.factions = {}
                    door.liaFactions = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, "all")
                    client:notifySuccessLocalized("doorRemoveFaction")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorremovefaction", {
    desc = "@doorremovefactionDesc",
    arguments = {
        {
            name = "faction",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[argumentIndex]
                local faction
                if input then
                    local factionIndex = tonumber(input)
                    if factionIndex then
                        faction = lia.faction.indices[factionIndex]
                        if not faction then
                            client:notifyErrorLocalized("invalidFaction")
                            return
                        end
                    else
                        for k, v in pairs(lia.faction.teams) do
                            if lia.util.stringMatches(k, input) or lia.util.stringMatches(v.name, input) then
                                faction = v
                                break
                            end
                        end
                    end
                end

                if faction then
                    local facs = doorData.factions or {}
                    table.RemoveByValue(facs, faction.uniqueID)
                    doorData.factions = facs
                    door.liaFactions = facs
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, faction.name)
                    client:notifySuccessLocalized("doorRemoveFactionSpecific", faction.name)
                elseif arguments[argumentIndex] then
                    client:notifyErrorLocalized("invalidFaction")
                else
                    doorData.factions = {}
                    door.liaFactions = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, "all")
                    client:notifySuccessLocalized("doorRemoveFaction")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

lia.command.add("doorsetclass", {
    desc = "@doorsetclassDesc",
    arguments = {
        {
            name = "class",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[argumentIndex]
                local class, classData
                if input then
                    local classIndex = tonumber(input)
                    if classIndex then
                        classData = lia.class.list[classIndex]
                        if classData then
                            class = classIndex
                        else
                            client:notifyErrorLocalized("invalidClass")
                            return
                        end
                    else
                        local id = lia.class.retrieveClass(input)
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
                end

                if class then
                    local classes = doorData.classes or {}
                    if not table.HasValue(classes, classData.uniqueID) then classes[#classes + 1] = classData.uniqueID end
                    doorData.classes = classes
                    door.liaClasses = classes
                    doorData.noSell = true
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorSetClass", door, classData.name)
                    client:notifySuccessLocalized("doorSetClass", classData.name)
                elseif arguments[argumentIndex] then
                    client:notifyErrorLocalized("invalidClass")
                else
                    doorData.classes = {}
                    door.liaClasses = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveClass", door)
                    client:notifySuccessLocalized("doorRemoveClass")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end,
    alias = {"jobdoor"}
})

lia.command.add("doorremoveclass", {
    desc = "@doorremoveclassDesc",
    arguments = {
        {
            name = "class",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[argumentIndex]
                local class, classData
                if input then
                    local classIndex = tonumber(input)
                    if classIndex then
                        classData = lia.class.list[classIndex]
                        if classData then
                            class = classIndex
                        else
                            client:notifyErrorLocalized("invalidClass")
                            return
                        end
                    else
                        local id = lia.class.retrieveClass(input)
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
                end

                if class then
                    local classes = doorData.classes or {}
                    if table.HasValue(classes, classData.uniqueID) then
                        table.RemoveByValue(classes, classData.uniqueID)
                        doorData.classes = classes
                        door.liaClasses = classes
                        lia.doors.setData(door, doorData)
                        lia.log.add(client, "doorRemoveClassSpecific", door, classData.name)
                        client:notifySuccessLocalized("doorRemoveClassSpecific", classData.name)
                    else
                        client:notifyErrorLocalized("doorClassNotAssigned", classData.name)
                    end
                elseif arguments[argumentIndex] then
                    client:notifyErrorLocalized("invalidClass")
                else
                    doorData.classes = {}
                    door.liaClasses = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveClass", door)
                    client:notifySuccessLocalized("doorRemoveClass")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyErrorLocalized("doorNotValid")
            end
        else
            client:notifyErrorLocalized("doorNotValid")
        end
    end
})

local function cloneDoorRestrictionList(values)
    local cloned = {}
    for index, value in ipairs(values or {}) do
        cloned[index] = value
    end
    return cloned
end

lia.command.add("doorcopyfactions", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyErrorLocalized("doorNotValid")
            return
        end

        client.liaCopiedDoorFactions = {
            hasData = true,
            values = cloneDoorRestrictionList(doorData.factions)
        }

        client:notifySuccessLocalized("doorFactionsCopied", #(client.liaCopiedDoorFactions.values or {}))
    end
})

lia.command.add("doorpastefactions", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyErrorLocalized("doorNotValid")
            return
        end

        local copiedData = client.liaCopiedDoorFactions
        if not copiedData or not copiedData.hasData then
            client:notifyErrorLocalized("doorNoCopiedFactions")
            return
        end

        local factions = cloneDoorRestrictionList(copiedData.values)
        doorData.factions = factions
        door.liaFactions = #factions > 0 and factions or nil
        if #factions > 0 then doorData.noSell = true end
        lia.doors.setData(door, doorData)
        lia.module.get("doors"):SaveData()
        client:notifySuccessLocalized("doorFactionsPasted", #factions)
    end
})

lia.command.add("doorcopyclasses", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyErrorLocalized("doorNotValid")
            return
        end

        client.liaCopiedDoorClasses = {
            hasData = true,
            values = cloneDoorRestrictionList(doorData.classes)
        }

        client:notifySuccessLocalized("doorClassesCopied", #(client.liaCopiedDoorClasses.values or {}))
    end
})

lia.command.add("doorpasteclasses", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyErrorLocalized("doorNotValid")
            return
        end

        local copiedData = client.liaCopiedDoorClasses
        if not copiedData or not copiedData.hasData then
            client:notifyErrorLocalized("doorNoCopiedClasses")
            return
        end

        local classes = cloneDoorRestrictionList(copiedData.values)
        doorData.classes = classes
        door.liaClasses = #classes > 0 and classes or nil
        if #classes > 0 then doorData.noSell = true end
        lia.doors.setData(door, doorData)
        lia.module.get("doors"):SaveData()
        client:notifySuccessLocalized("doorClassesPasted", #classes)
    end
})

lia.command.add("togglealldoors", {
    desc = "@togglealldoorsDesc",
    adminOnly = true,
    onRun = function(client)
        local toggleToDisable = false
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local doorData = lia.doors.getData(door)
                toggleToDisable = not (doorData.disabled or false)
                break
            end
        end

        local count = 0
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local doorData = lia.doors.getData(door)
                if (doorData.disabled or false) ~= toggleToDisable then
                    doorData.disabled = toggleToDisable and true or nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, toggleToDisable and "doorDisable" or "doorEnable", door)
                    count = count + 1
                end
            end
        end

        client:notifySuccessLocalized(toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.log.add(client, toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.module.get("doors"):SaveData()
    end
})

lia.command.add("doorid", {
    desc = "@doorIDDesc",
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local mapID = door:MapCreationID()
            if mapID and mapID > 0 then
                local pos = door:GetPos()
                client:notifyInfoLocalized("doorID" .. " " .. mapID .. " | " .. L("position") .. ": " .. string.format("%.0f, %.0f, %.0f", pos.x, pos.y, pos.z))
                lia.log.add(client, "doorID", door, mapID)
            else
                client:notifyErrorLocalized("doorNoValidMapID")
            end
        else
            client:notifyErrorLocalized("doorMustBeLookingAt")
        end
    end
})

lia.command.add("listdoorids", {
    desc = "@listDoorIDsDesc",
    adminOnly = true,
    onRun = function(client)
        local doorData = {}
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local mapID = door:MapCreationID()
                if mapID and mapID > 0 then
                    local pos = door:GetPos()
                    table.insert(doorData, {
                        id = mapID,
                        position = string.format("%.0f, %.0f, %.0f", pos.x, pos.y, pos.z),
                        model = door:GetModel() or L("unknown")
                    })
                end
            end
        end

        if #doorData == 0 then
            client:notifyInfoLocalized("doorNoDoorsFound")
            return
        end

        table.sort(doorData, function(a, b) return a.id < b.id end)
        local doorList = {}
        for _, data in ipairs(doorData) do
            table.insert(doorList, {
                property = L("doorID") .. data.id,
                value = L("position") .. ": " .. data.position .. L("modelLabel") .. data.model
            })
        end

        lia.util.sendTableUI(client, L("doorIDsOnMap", game.GetMap()), {
            {
                name = L("doorID"),
                field = "property"
            },
            {
                name = L("detailsColumn"),
                field = "value"
            }
        }, doorList)
    end
})

