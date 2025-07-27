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

net.Receive("doorPerm", function(_, client)
    local door = net.ReadEntity()
    local target = net.ReadEntity()
    local access = net.ReadUInt(2)
    if IsValid(target) and target:getChar() and door.liaAccess and door:GetDTEntity(0) == client and target ~= client then
        access = math.Clamp(access or 0, DoorNone, DoorTenant)
        if access == door.liaAccess[target] then return end
        door.liaAccess[target] = access
        local recipient = {}
        for k, v in pairs(door.liaAccess) do
            if v > DoorGuest then recipient[#recipient + 1] = k end
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

net.Receive("WorkshopDownloader_Request", function(_, client)
    if not lia.config.get("AutoDownloadWorkshop", true) then return end
    lia.workshop.send(client)
end)


net.Receive("liaTeleportToEntity", function(_, ply)
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    if not ply:hasPrivilege("Teleport to Entity (Entity Tab)") then return end
    local pos = ent:GetPos() + Vector(0, 0, 50)
    ply:SetPos(pos)
    ply:notifyLocalized("teleportedToEntity", ent:GetClass())
    lia.log.add(ply, "teleportToEntity", ent:GetClass())
end)

local function fixupProp(client, ent, mins, maxs)
    local pos = ent:GetPos()
    local down, up = ent:LocalToWorld(mins), ent:LocalToWorld(maxs)
    local trD = util.TraceLine({
        start = pos,
        endpos = down,
        filter = {ent, client}
    })

    local trU = util.TraceLine({
        start = pos,
        endpos = up,
        filter = {ent, client}
    })

    if trD.Hit and trU.Hit then return end
    if trD.Hit then ent:SetPos(pos + trD.HitPos - down) end
    if trU.Hit then ent:SetPos(pos + trU.HitPos - up) end
end

local function tryFixPropPosition(client, ent)
    local m, M = ent:OBBMins(), ent:OBBMaxs()
    fixupProp(client, ent, Vector(m.x, 0, 0), Vector(M.x, 0, 0))
    fixupProp(client, ent, Vector(0, m.y, 0), Vector(0, M.y, 0))
    fixupProp(client, ent, Vector(0, 0, m.z), Vector(0, 0, M.z))
end

net.Receive("SpawnMenuSpawnItem", function(_, client)
    if not IsValid(client) then return end
    local id = net.ReadString()
    if not id or not client:hasPrivilege("Can Use Item Spawner") then return end
    local startPos, dir = client:EyePos(), client:GetAimVector()
    local tr = util.TraceLine({
        start = startPos,
        endpos = startPos + dir * 4096,
        filter = client
    })

    if not tr.Hit then return end
    lia.item.spawn(id, tr.HitPos, function(item)
        local ent = item:getEntity()
        if not IsValid(ent) then return end
        ent:SetCreator(client)
        tryFixPropPosition(client, ent)
        undo.Create("item")
        undo.SetPlayer(client)
        undo.AddEntity(ent)
        local name = lia.item.list[id] and lia.item.list[id].name or id
        undo.SetCustomUndoText("Undone " .. name)
        undo.Finish("Item (" .. name .. ")")
        lia.log.add(client, "spawnItem", name, "SpawnMenuSpawnItem")
    end, angle_zero, {})
end)

net.Receive("SpawnMenuGiveItem", function(_, client)
    if not IsValid(client) then return end
    local id, targetID = net.ReadString(), net.ReadString()
    if not id or not client:hasPrivilege("Can Use Item Spawner") then return end
    local targetChar = lia.char.getBySteamID(targetID)
    if not targetChar then return end
    local target = targetChar:getPlayer()
    targetChar:getInv():add(id)
    lia.log.add(client, "chargiveItem", id, target, "SpawnMenuGiveItem")
end)


net.Receive("liaBigTableChunk", function(_, client)
    local id = net.ReadString()
    local idx = net.ReadUInt(16)
    local total = net.ReadUInt(16)
    local len = net.ReadUInt(16)
    local data = net.ReadData(len)
    lia.net.bigTables[id] = lia.net.bigTables[id] or {}
    lia.net.bigTables[id][idx] = data
end)

net.Receive("liaBigTableDone", function(_, client)
    local id = net.ReadString()
    local tbl = lia.net.ReadBigTable(id)
    if tbl then hook.Run("LiaBigTableReceived", client, id, tbl) end
end)
