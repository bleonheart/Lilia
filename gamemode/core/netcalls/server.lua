net.Receive("StringRequest", function(_, client)
    local id = net.ReadUInt(32)
    local value = net.ReadString()
    if client.liaStrReqs and client.liaStrReqs[id] then
        client.liaStrReqs[id](value)
        client.liaStrReqs[id] = nil
    end
end)

net.Receive("ArgumentsRequest", function(_, client)
    local id = net.ReadUInt(32)
    local data = net.ReadTable()
    if client.liaArgReqs and client.liaArgReqs[id] then
        client.liaArgReqs[id](data)
        client.liaArgReqs[id] = nil
    end
end)

net.Receive("RequestDropdown", function(_, client)
    local selectedOption = net.ReadString()
    if client.dropdownCallback then
        client.dropdownCallback(selectedOption)
        client.dropdownCallback = nil
    end
end)

net.Receive("OptionsRequest", function(_, client)
    local selectedOptions = net.ReadTable()
    if client.optionsCallback then
        client.optionsCallback(selectedOptions)
        client.optionsCallback = nil
    end
end)

net.Receive("BinaryQuestionRequest", function(_, client)
    local choice = net.ReadUInt(1)
    if client.binaryQuestionCallback then
        local callback = client.binaryQuestionCallback
        callback(choice)
        client.binaryQuestionCallback = nil
    end
end)

net.Receive("ButtonRequest", function(_, client)
    local id = net.ReadUInt(32)
    local choice = net.ReadUInt(8)
    local data = client.buttonRequests and client.buttonRequests[id]
    if data and data[choice] then
        data[choice](client)
        client.buttonRequests[id] = nil
    end
end)

net.Receive("liaTransferItem", function(_, client)
    local itemID = net.ReadUInt(32)
    local x = net.ReadUInt(32)
    local y = net.ReadUInt(32)
    local invID = net.ReadType()
    hook.Run("HandleItemTransferRequest", client, itemID, x, y, invID)
end)

net.Receive("invAct", function(_, client)
    local action = net.ReadString()
    local rawItem = net.ReadType()
    local data = net.ReadType()
    local character = client:getChar()
    if not character then return end
    local entity
    local item
    if isentity(rawItem) then
        if not IsValid(rawItem) then return end
        if rawItem:GetPos():Distance(client:GetPos()) > 96 then return end
        if not rawItem.liaItemID then return end
        entity = rawItem
        item = lia.item.instances[rawItem.liaItemID]
    else
        item = lia.item.instances[rawItem]
    end

    if not item then return end
    local inventory = lia.inventory.instances[item.invID]
    if inventory then
        local ok = inventory:canAccess("item", {
            client = client,
            item = item,
            entity = entity,
            action = action
        })

        if not ok then return end
    end

    item:interact(action, client, entity, data)
end)

net.Receive("cmd", function(_, client)
    local command = net.ReadString()
    local arguments = net.ReadTable()
    if (client.liaNextCmd or 0) < CurTime() then
        local arguments2 = {}
        for _, v in ipairs(arguments) do
            if isstring(v) or isnumber(v) then arguments2[#arguments2 + 1] = tostring(v) end
        end

        lia.command.parse(client, nil, command, arguments2)
        client.liaNextCmd = CurTime() + 0.2
    end
end)

net.Receive("liaCharFetchNames", function(_, client)
    net.Start("liaCharFetchNames")
    net.WriteTable(lia.char.names)
    net.Send(client)
end)

-- from modules/doors/netcalls/server.lua
net.Receive("doorPerm", function(_, client)
    local door = net.ReadEntity()
    local target = net.ReadEntity()
    local access = net.ReadUInt(2)
    if IsValid(target) and target:getChar() and door.liaAccess and door:GetDTEntity(0) == client and target ~= client then
        access = math.Clamp(access or 0, DOOR_NONE, DOOR_TENANT)
        if access == door.liaAccess[target] then return end
        door.liaAccess[target] = access
        local recipient = {}
        for k, v in pairs(door.liaAccess) do
            if v > DOOR_GUEST then recipient[#recipient + 1] = k end
        end

        if #recipient > 0 then
            net.Start("doorPerm")
            net.WriteEntity(door)
            net.WriteEntity(target)
            net.WriteUInt(access, 2)
            net.Send(recipient)
        end
    end
end)

-- from modules/chatbox/netcalls/server.lua
net.Receive("msg", function(_, client)
    local text = net.ReadString()
    local charlimit = lia.config.get("MaxChatLength")
    if charlimit > 0 then
        if (client.liaNextChat or 0) < CurTime() and text:find("%S") then
            hook.Run("PlayerSay", client, text)
            client.liaNextChat = CurTime() + math.max(#text / 250, 0.4)
        end
    else
        if utf8.len(text) > charlimit then
            client:notifyLocalized("messageTooLong", charlimit)
        else
            if (client.liaNextChat or 0) < CurTime() and text:find("%S") then
                hook.Run("PlayerSay", client, text)
                client.liaNextChat = CurTime() + math.max(#text / 250, 0.4)
            end
        end
    end
end)

-- from modules/mainmenu/netcalls/server.lua
net.Receive("liaCharChoose", function(_, client)
    local function response(message)
        net.Start("liaCharChoose")
        net.WriteString(L(message or "", client))
        net.Send(client)
    end

    local id = net.ReadUInt(32)
    local character = lia.char.loaded[id]
    if not character or character:getPlayer() ~= client then return response(false, "invalidChar") end
    local status, result = hook.Run("CanPlayerUseChar", client, character)
    if status == false then
        if result[1] == "@" then result = result:sub(2) end
        return response(result)
    end

    local currentChar = client:getChar()
    if currentChar then
        status, result = hook.Run("CanPlayerSwitchChar", client, currentChar, character)
        if status == false then
            if result[1] == "@" then result = result:sub(2) end
            return response(result)
        end

        currentChar:save()
    end

    hook.Run("PrePlayerLoadedChar", client, character, currentChar)
    net.Start("prePlayerLoadedChar")
    net.WriteUInt(character:getID(), 32)
    net.WriteType(currentChar and currentChar:getID() or nil)
    net.Send(client)
    character:setup()
    hook.Run("PlayerLoadedChar", client, character, currentChar)
    net.Start("playerLoadedChar")
    net.WriteUInt(character:getID(), 32)
    net.WriteType(currentChar and currentChar:getID() or nil)
    net.Send(client)
    response()
    hook.Run("PostPlayerLoadedChar", client, character, currentChar)
    net.Start("postPlayerLoadedChar")
    net.WriteUInt(character:getID(), 32)
    net.WriteType(currentChar and currentChar:getID() or nil)
    net.Send(client)
end)

net.Receive("liaCharCreate", function(_, client)
    if hook.Run("CanPlayerCreateChar", client) == false then return end
    local function response(id, message, ...)
        net.Start("liaCharCreate")
        net.WriteUInt(id or 0, 32)
        net.WriteString(L(message or "", client, ...))
        net.Send(client)
    end

    local numValues = net.ReadUInt(32)
    local data = {}
    for _ = 1, numValues do
        data[net.ReadString()] = net.ReadType()
    end

    local originalData = table.Copy(data)
    local newData = {}
    for key in pairs(data) do
        if not lia.char.vars[key] then data[key] = nil end
    end

    for key, charVar in pairs(lia.char.vars) do
        local value = data[key]
        if not isfunction(charVar.onValidate) and charVar.noDisplay then
            data[key] = nil
            continue
        end

        if isfunction(charVar.onValidate) then
            local result = {charVar.onValidate(value, data, client)}
            if result[1] == false then
                result[2] = result[2] or "Validation error"
                return response(nil, unpack(result, 2))
            end
        end

        if isfunction(charVar.onAdjust) then charVar.onAdjust(client, data, value, newData) end
    end

    hook.Run("AdjustCreationData", client, data, newData, originalData)
    data = table.Merge(data, newData)
    data.steamID = client:SteamID64()
    lia.char.create(data, function(id)
        if IsValid(client) then
            lia.char.loaded[id]:sync(client)
            table.insert(client.liaCharList, id)
            lia.module.list["mainmenu"]:syncCharList(client)
            hook.Run("OnCharCreated", client, lia.char.loaded[id], originalData)
            response(id)
        end
    end)
end)

net.Receive("liaCharDelete", function(_, client)
    local id = net.ReadUInt(32)
    local character = lia.char.loaded[id]
    local steamID = client:SteamID64()
    if character and character.steamID == steamID then
        hook.Run("CharDeleted", client, character)
        character:delete()
        timer.Simple(.5, function() lia.module.list["mainmenu"]:syncCharList(client) end)
    end
end)

-- from modules/inventory/submodules/storage/netcalls/server.lua
net.Receive("liaStorageExit", function(_, client)
    local storage = client.liaStorageEntity
    if IsValid(storage) then storage.receivers[client] = nil end
    client.liaStorageEntity = nil
end)

net.Receive("liaStorageUnlock", function(_, client)
    local password = net.ReadString()
    local storageFunc = function()
        if not IsValid(client.liaStorageEntity) then return end
        if client:GetPos():Distance(client.liaStorageEntity:GetPos()) > 128 then return end
        return client.liaStorageEntity
    end

    local passwordDelay = 1
    local storage = storageFunc()
    if not storage then return end
    if client.lastPasswordAttempt and CurTime() < client.lastPasswordAttempt + passwordDelay then
        client:notifyLocalized("passwordTooQuick")
    else
        if storage.password == password then
            lia.log.add(client, "storageUnlock", storage:GetClass())
            storage:openInv(client)
        else
            lia.log.add(client, "storageUnlockFailed", storage:GetClass(), password)
            client:notifyLocalized("wrongPassword")
            client.liaStorageEntity = nil
        end

        client.lastPasswordAttempt = CurTime()
    end
end)

net.Receive("liaStorageTransfer", function(_, client)
    local itemID = net.ReadUInt(32)
    if not client:getChar() then return end
    local storageFunc = function()
        if not IsValid(client.liaStorageEntity) then return end
        if client:GetPos():Distance(client.liaStorageEntity:GetPos()) > 128 then return end
        return client.liaStorageEntity
    end

    local storage = storageFunc()
    if not storage or not storage.receivers[client] then return end
    local clientInv = client:getChar():getInv()
    local storageInv = storage:getInv()
    if not clientInv or not storageInv then return end
    local item = clientInv.items[itemID] or storageInv.items[itemID]
    if not item then return end
    local toInv = clientInv:getID() == item.invID and storageInv or clientInv
    local fromInv = toInv == clientInv and storageInv or clientInv
    if hook.Run("StorageCanTransferItem", client, storage, item) == false then return end
    local context = {
        client = client,
        item = item,
        storage = storage,
        from = fromInv,
        to = toInv
    }

    if clientInv:canAccess("transfer", context) == false or storageInv:canAccess("transfer", context) == false then return end
    if client.storageTransaction and client.storageTransactionTimeout > RealTime() then return end
    client.storageTransaction = true
    client.storageTransactionTimeout = RealTime() + 0.1
    local failItemDropPos = client:getItemDropPos()
    fromInv:removeItem(itemID, true):next(function() return toInv:add(item) end):next(function(res)
        client.storageTransaction = nil
        hook.Run("ItemTransfered", context)
        return res
    end):catch(function(err)
        client.storageTransaction = nil
        if IsValid(client) then lia.log.add(client, "itemTransferFailed", item:getName(), fromInv:getID(), toInv:getID()) end
        if IsValid(client) then client:notifyLocalized(err) end
        return fromInv:add(item)
    end):catch(function()
        client.storageTransaction = nil
        if IsValid(client) then lia.log.add(client, "itemTransferFailed", item:getName(), fromInv:getID(), toInv:getID()) end
        item:spawn(failItemDropPos)
        if IsValid(client) then client:notifyLocalized("itemOnGround") end
    end)
end)

-- from modules/inventory/submodules/storage/netcalls/shared.lua
net.Receive("trunkInitStorage", function()
    local MODULE = lia.module.get("storage")
    local isTable = net.ReadBool()
    if isTable then
        local vehicles = net.ReadTable()
        for _, vehicle in pairs(vehicles) do
            MODULE:InitializeStorage(vehicle)
        end
    else
        local entity = net.ReadEntity()
        MODULE:InitializeStorage(entity)
    end
end)

