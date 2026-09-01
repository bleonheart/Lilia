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
    desc = "Sell a door you own and receive a refund based on the door's price.",
    adminOnly = false,
    AdminStick = {
        Name = "Sell Door",
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
                    client:notifyMoney(string.format("You have sold this door for %s.", lia.currency.get(price)))
                    hook.Run("OnPlayerPurchaseDoor", client, door, false)
                    lia.log.add(client, "doorsell", price)
                else
                    client:notifyError("You do not own this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("admindoorsell", {
    desc = "Admin command to sell a door on behalf of its owner and refund the owner.",
    adminOnly = true,
    AdminStick = {
        Name = "Admin Sell Door",
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
                    owner:notifyMoney(string.format("You have sold this door for %s.", lia.currency.get(price)))
                    client:notifyMoney(string.format("You have sold this door for %s.", lia.currency.get(price)))
                    hook.Run("OnPlayerPurchaseDoor", owner, door, false)
                    lia.log.add(client, "admindoorsell", owner:Name(), price)
                else
                    client:notifyError("You do not own this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("admindoorsetowner", {
    desc = "Permanently assign a door to a player's SteamID.",
    arguments = {
        {
            name = "steamID",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        local steamID = arguments[argumentIndex]
        if not door then return client:notifyError("You are not looking at a valid door.") end
        if not steamID or not steamID:match("^STEAM_%d:%d:%d+$") then return client:notifyError("Enter a valid SteamID (STEAM_0:0:123).") end
        local data = lia.doors.getData(door)
        data.ownerSteamID = steamID
        data.noSell = true
        lia.doors.setData(door, data)
        local target = lia.util.getBySteamID(steamID)
        if IsValid(target) then
            door:SetDTEntity(0, target)
            door.liaAccess = door.liaAccess or {}
            door.liaAccess[target] = DOOR_OWNER
        end

        lia.module.get("doors"):SaveData()
        lia.log.add(client, "doorPermanentOwner", door, steamID)
        client:notifySuccess("Permanent door ownership assigned to " .. steamID .. ".")
    end
})

lia.command.add("admindoorsremoveowner", {
    desc = "Remove a door's permanent owner.",
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return client:notifyError("You are not looking at a valid door.") end
        local data = lia.doors.getData(door)
        data.ownerSteamID = ""
        if IsValid(door:GetDTEntity(0)) then door:removeDoorAccessData() end
        lia.doors.setData(door, data)
        lia.module.get("doors"):SaveData()
        client:notifySuccess("Permanent door ownership removed.")
    end
})

lia.command.add("doortogglelock", {
    desc = "Toggle a door's lock state between locked and unlocked.",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door State",
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
                    lia.log.add(client, "toggleLock", door, "Locked")
                else
                    door:Fire("unlock")
                    door:EmitSound("doors/door_latch1.wav")
                    doorData.locked = false
                    lia.doors.setCachedData(door, doorData)
                    lia.log.add(client, "toggleLock", door, "unlocked")
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
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorbuy", {
    desc = "Purchase a door if it is available and you can afford it.",
    adminOnly = false,
    AdminStick = {
        Name = "Buy Door",
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
                if doorData.noSell or (factions and #factions > 0) or (classes and #classes > 0) then return client:notifyError("You are not allowed to own this door.") end
                if IsValid(door:GetDTEntity(0)) then
                    client:notifyInfo(string.format("This door is owned by %s.", door:GetDTEntity(0):Name()))
                    return false
                end

                local price = doorData.price or 0
                if client:getChar():hasMoney(price) then
                    door:SetDTEntity(0, client)
                    door.liaAccess = {
                        [client] = DOOR_OWNER
                    }

                    client:getChar():takeMoney(price)
                    client:notifySuccess(string.format("You have purchased this door for %s.", lia.currency.get(price)))
                    hook.Run("OnPlayerPurchaseDoor", client, door, true)
                    lia.log.add(client, "buydoor", price)
                else
                    client:notifyError("You cannot afford this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortoggleownable", {
    desc = "Toggle whether a door can be owned by players.",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Ownable",
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
                    client:notifyError("This door cannot be owned.")
                    return false
                end

                doorData.noSell = newState and true or nil
                lia.doors.setData(door, doorData)
                lia.log.add(client, "doorToggleOwnable", door, newState)
                hook.Run("DoorOwnableToggled", client, door, newState)
                client:notifySuccess(newState and "This door is now unownable." or "This door is now ownable.")
                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorresetdata", {
    desc = "Reset door data to default settings.",
    adminOnly = true,
    AdminStick = {
        Name = "Reset Door Data",
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
            client:notifySuccess("The door data has been reset.")
            lia.module.get("doors"):SaveData()
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortoggleenabled", {
    desc = "Toggle door enabled state (active/inactive).",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Enabled",
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
            client:notifySuccess(newState and "This door is now disabled." or "This door is no longer disabled.")
            lia.module.get("doors"):SaveData()
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortogglehidden", {
    desc = "Toggle the hidden state of a door.",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Hidden",
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
            client:notifySuccess(newState and "This door is now hidden." or "This door is no longer hidden.")
            lia.module.get("doors"):SaveData()
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsetprice", {
    desc = "Set the price for a door.",
    arguments = {
        {
            name = "price",
            type = "string"
        },
    },
    adminOnly = true,
    AdminStick = {
        Name = "Set Door Price",
        ButtonText = "Set Door Price",
        Category = "doorSettings",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door, argumentIndex = resolveDoorCommandTarget(client, arguments, 1)
        if door then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                if not arguments[argumentIndex] or not tonumber(arguments[argumentIndex]) then return client:notifyError("The specified class is not valid.") end
                local price = math.Clamp(math.floor(tonumber(arguments[argumentIndex])), 0, 1000000)
                doorData.price = price
                lia.doors.setData(door, doorData)
                lia.log.add(client, "doorSetPrice", door, price)
                hook.Run("DoorPriceSet", client, door, price)
                client:notifySuccess(string.format("You have set this door's price to %s.", lia.currency.get(price)))
                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsettitle", {
    desc = "Set the title for a door.",
    arguments = {
        {
            name = "title",
            type = "string"
        },
    },
    adminOnly = true,
    AdminStick = {
        Name = "Set Door Title",
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
                if not name:find("%S") then return client:notifyError("The specified class is not valid.") end
                if door:checkDoorAccess(client, DOOR_TENANT) or client:isStaff() then
                    doorData.name = name
                    lia.doors.setData(door, doorData)
                    hook.Run("DoorTitleSet", client, door, name)
                    lia.log.add(client, "doorSetTitle", door, name)
                    client:notifySuccess(string.format("Door title set to '%s'.", name))
                else
                    client:notifyError("You do not own this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("savedoors", {
    desc = "Save door data persistently.",
    adminOnly = true,
    AdminStick = {
        Name = "Save Doors",
        ButtonText = "Save Door Data",
        Category = "doorMaintenance",
        TargetClass = "door",
    },
    onRun = function(client)
        lia.module.get("doors"):SaveData()
        lia.log.add(client, "doorSaveData")
        client:notifySuccess("Saved Doors!")
    end
})

lia.command.add("doorinfo", {
    desc = "Display information about the targeted door.",
    adminOnly = true,
    AdminStick = {
        Name = "Get Door Information",
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
                    property = "Disabled",
                    value = tostring(disabled)
                },
                {
                    property = "Name",
                    value = tostring(doorData.name or "Unowned Door")
                },
                {
                    property = "Price",
                    value = lia.currency.get(price)
                },
                {
                    property = "No Sell",
                    value = tostring(noSell)
                },
                {
                    property = "Factions",
                    value = tostring(not table.IsEmpty(factionNames) and table.concat(factionNames, ", ") or "None")
                },
                {
                    property = "Classes",
                    value = tostring(not table.IsEmpty(classNames) and table.concat(classNames, ", ") or "None")
                },
                {
                    property = "Hidden",
                    value = tostring(hidden)
                }
            }

            lia.util.sendTableUI(client, "Door" .. " " .. "Information", {
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
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsampledata", {
    desc = "Add sample information to a door using common door variables.",
    adminOnly = true,
    AdminStick = {
        Name = "Add Sample Data",
        ButtonText = "Copy Door Settings",
        Category = "doorMaintenance",
        TargetClass = "door",
    },
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local doorData = lia.doors.getData(door)
            local sampleData = {
                name = string.format("Sample Door %s", door:MapCreationID() or "Unknown"),
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
            client:notify("Door sample data applied successfully!")
            lia.log.add(client, "doorSampleData", door)
        else
            client:notifyError("You are not looking at a valid door.")
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
    desc = "Add a faction restriction to a door, allowing only specific factions to access it.",
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
                            client:notifyError("The specified faction is not valid.")
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
                    client:notifySuccess(string.format("This door now belongs to the '%s' faction.", faction.name))
                elseif arguments[argumentIndex] then
                    client:notifyError("The specified faction is not valid.")
                else
                    doorData.factions = {}
                    door.liaFactions = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, "all")
                    client:notifySuccess("This door no longer belongs to any faction.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorremovefaction", {
    desc = "Remove a faction restriction from a door, or clear all restrictions.",
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
                            client:notifyError("The specified faction is not valid.")
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
                    client:notifySuccess(string.format("This door no longer belongs to the '%s' faction.", faction.name))
                elseif arguments[argumentIndex] then
                    client:notifyError("The specified faction is not valid.")
                else
                    doorData.factions = {}
                    door.liaFactions = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, "all")
                    client:notifySuccess("This door no longer belongs to any faction.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsetclass", {
    desc = "Set a class (job) restriction for a door.",
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
                            client:notifyError("The specified class is not valid.")
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
                    client:notifySuccess(string.format("This door now belongs to the '%s' class.", classData.name))
                elseif arguments[argumentIndex] then
                    client:notifyError("The specified class is not valid.")
                else
                    doorData.classes = {}
                    door.liaClasses = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveClass", door)
                    client:notifySuccess("This door no longer belongs to any class.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end,
    alias = {"jobdoor"}
})

lia.command.add("doorremoveclass", {
    desc = "Remove a class (job) restriction from a door.",
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
                            client:notifyError("The specified class is not valid.")
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
                        client:notifySuccess(string.format("The '%s' class has been removed from this door.", classData.name))
                    else
                        client:notifyError(string.format("The '%s' class is not assigned to this door.", classData.name))
                    end
                elseif arguments[argumentIndex] then
                    client:notifyError("The specified class is not valid.")
                else
                    doorData.classes = {}
                    door.liaClasses = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveClass", door)
                    client:notifySuccess("This door no longer belongs to any class.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
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
            client:notifyError("You are not looking at a valid door.")
            return
        end

        client.liaCopiedDoorFactions = {
            hasData = true,
            values = cloneDoorRestrictionList(doorData.factions)
        }

        client:notifySuccess(string.format("Copied %s faction restriction(s) from this door.", #(client.liaCopiedDoorFactions.values or {})))
    end
})

lia.command.add("doorpastefactions", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyError("You are not looking at a valid door.")
            return
        end

        local copiedData = client.liaCopiedDoorFactions
        if not copiedData or not copiedData.hasData then
            client:notifyError("You have no copied door faction restrictions to paste.")
            return
        end

        local factions = cloneDoorRestrictionList(copiedData.values)
        doorData.factions = factions
        door.liaFactions = #factions > 0 and factions or nil
        if #factions > 0 then doorData.noSell = true end
        lia.doors.setData(door, doorData)
        lia.module.get("doors"):SaveData()
        client:notifySuccess(string.format("Pasted %s faction restriction(s) onto this door.", #factions))
    end
})

lia.command.add("doorcopyclasses", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyError("You are not looking at a valid door.")
            return
        end

        client.liaCopiedDoorClasses = {
            hasData = true,
            values = cloneDoorRestrictionList(doorData.classes)
        }

        client:notifySuccess(string.format("Copied %s class restriction(s) from this door.", #(client.liaCopiedDoorClasses.values or {})))
    end
})

lia.command.add("doorpasteclasses", {
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if not door then return end
        local doorData = lia.doors.getData(door)
        if doorData.disabled then
            client:notifyError("You are not looking at a valid door.")
            return
        end

        local copiedData = client.liaCopiedDoorClasses
        if not copiedData or not copiedData.hasData then
            client:notifyError("You have no copied door class restrictions to paste.")
            return
        end

        local classes = cloneDoorRestrictionList(copiedData.values)
        doorData.classes = classes
        door.liaClasses = #classes > 0 and classes or nil
        if #classes > 0 then doorData.noSell = true end
        lia.doors.setData(door, doorData)
        lia.module.get("doors"):SaveData()
        client:notifySuccess(string.format("Pasted %s class restriction(s) onto this door.", #classes))
    end
})

lia.command.add("togglealldoors", {
    desc = "Toggle the enabled state for all doors in the map.",
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

        client:notifySuccess(toggleToDisable and "All doors have been disabled." or "Enable All Doors")
        lia.log.add(client, toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.module.get("doors"):SaveData()
    end
})

lia.command.add("doorid", {
    desc = "Set the door ID for identification purposes.",
    adminOnly = true,
    onRun = function(client, arguments)
        local door = resolveDoorCommandTarget(client, arguments, 0)
        if door then
            local mapID = door:MapCreationID()
            if mapID and mapID > 0 then
                local pos = door:GetPos()
                client:notifyInfo("Door ID" .. " " .. mapID .. " | " .. "Position" .. ": " .. string.format("%.0f, %.0f, %.0f", pos.x, pos.y, pos.z))
                lia.log.add(client, "doorID", door, mapID)
            else
                client:notifyError("No valid map ID found for this door.")
            end
        else
            client:notifyError("You must be looking at a door.")
        end
    end
})

lia.command.add("listdoorids", {
    desc = "List every door on the current map with its map ID, position, and model.",
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
                        model = door:GetModel() or "Unknown"
                    })
                end
            end
        end

        if #doorData == 0 then
            client:notifyInfo("No doors found.")
            return
        end

        table.sort(doorData, function(a, b) return a.id < b.id end)
        local doorList = {}
        for _, data in ipairs(doorData) do
            table.insert(doorList, {
                property = "Door ID" .. data.id,
                value = "Position" .. ": " .. data.position .. "Model Label" .. data.model
            })
        end

        lia.util.sendTableUI(client, string.format("Door IDs on map %s", game.GetMap()), {
            {
                name = "Door ID",
                field = "property"
            },
            {
                name = "Details Column",
                field = "value"
            }
        }, doorList)
    end
})
