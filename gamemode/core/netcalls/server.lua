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

local DbChunk = 60000
local function sendTableData(client, name, data)
    local payload = {
        tbl = name,
        data = data or {}
    }

    local json = util.TableToJSON(payload)
    local comp = util.Compress(json)
    local len = #comp
    local id = util.CRC(tostring(SysTime()) .. len)
    local parts = math.ceil(len / DbChunk)
    for i = 1, parts do
        local chunk = string.sub(comp, (i - 1) * DbChunk + 1, math.min(i * DbChunk, len))
        net.Start("liaDBTableDataChunk")
        net.WriteString(id)
        net.WriteUInt(i, 16)
        net.WriteUInt(parts, 16)
        net.WriteUInt(#chunk, 16)
        net.WriteData(chunk, #chunk)
        net.Send(client)
    end

    net.Start("liaDBTableDataDone")
    net.WriteString(id)
    net.Send(client)
end

net.Receive("cfgSet", function(_, client)
    local key = net.ReadString()
    local name = net.ReadString()
    local value = net.ReadType()
    if type(lia.config.stored[key].default) == type(value) and hook.Run("CanPlayerModifyConfig", client, key) ~= false then
        local oldValue = lia.config.stored[key].value
        lia.config.set(key, value)
        hook.Run("ConfigChanged", key, value, oldValue, client)
        if istable(value) then
            local value2 = "["
            local count = table.Count(value)
            local i = 1
            for _, v in SortedPairs(value) do
                value2 = value2 .. v .. (i == count and "]" or ", ")
                i = i + 1
            end

            value = value2
        end

        client:notifyLocalized("cfgSet", client:Name(), name, tostring(value))
        lia.log.add(client, "configChange", name, tostring(oldValue), tostring(value))
    end
end)

net.Receive("liaRequestTableData", function(_, client)
    if not client:hasPrivilege("View DB Tables") then return end
    local tbl = net.ReadString()
    if not tbl or tbl == "" then return end
    lia.db.query("SELECT * FROM " .. lia.db.escapeIdentifier(tbl), function(res) sendTableData(client, tbl, res or {}) end)
end)

net.Receive("liaRequestDBTables", function(_, client)
    if not client:hasPrivilege("View DB Tables") then return end
    lia.db.getTables():next(function(tables)
        net.Start("liaDBTables")
        net.WriteTable(tables or {})
        net.Send(client)
    end)
end)

net.Receive("liaRequestCharList", function(_, client)
    if not client:hasPrivilege("List Characters") then return end
    local identifier = net.ReadString()
    local target
    if identifier and identifier ~= "" then
        target = lia.util.findPlayer(client, identifier)
        if not IsValid(target) then return end
    else
        target = client
    end

    local steam64 = target:SteamID64()
    local query = [[SELECT lia_characters.*, lia_players.lastOnline FROM lia_characters
        LEFT JOIN lia_players ON lia_characters.steamID = lia_players.steamID
        WHERE lia_characters.steamID = ]] .. lia.db.convertDataType(steam64)
    lia.db.query(query, function(data)
        if not data or #data == 0 then
            client:notifyLocalized("noCharactersFound")
            return
        end

        local sendData = {}
        for _, row in ipairs(data) do
            local stored = lia.char.loaded[row.id]
            local info = stored and stored:getData() or lia.char.getCharData(row.id) or {}
            local isBanned = stored and stored:getBanned() or row.banned
            if isstring(isBanned) then
                local lower = isBanned:lower()
                if lower == "false" or lower == "nil" or isBanned == "NULL" then isBanned = false end
            end

            isBanned = tobool(isBanned)
            local allVars = {}
            for varName, varInfo in pairs(lia.char.vars) do
                local value
                if stored then
                    if varName == "data" then
                        value = stored:getData()
                    elseif varName == "var" then
                        value = stored:getVar()
                    else
                        local getter = stored["get" .. varName:sub(1, 1):upper() .. varName:sub(2)]
                        if isfunction(getter) then
                            value = getter(stored)
                        else
                            value = stored.vars and stored.vars[varName]
                        end
                    end
                else
                    if varName == "data" then
                        value = info
                    elseif varInfo.field and row[varInfo.field] ~= nil then
                        local raw = row[varInfo.field]
                        if isnumber(varInfo.default) then
                            value = tonumber(raw) or varInfo.default
                        elseif isbool(varInfo.default) then
                            value = tobool(raw)
                        elseif istable(varInfo.default) then
                            value = util.JSONToTable(raw or "{}")
                        else
                            value = raw
                        end
                    else
                        value = varInfo.default
                    end
                end

                allVars[varName] = value
            end

            local lastUsedText = stored and L("onlineNow") or row.lastJoinTime
            local lastOnline
            if stored then
                lastOnline = L("onlineNow")
            else
                local last = tonumber(row.lastOnline)
                if not isnumber(last) then last = os.time(lia.time.toNumber(row.lastJoinTime)) end
                local diff = os.time() - last
                local since = lia.time.TimeSince(last)
                local stripped = since:match("^(.-)%sago$") or since
                lastOnline = string.format("%s (%s) ago", stripped, lia.time.SecondsToDHM(diff))
            end

            local money = row.money
            if money == nil or money == "NULL" then money = 0 end
            local entry = {
                ID = row.id,
                SteamID = util.SteamIDFrom64(row.steamID),
                Name = row.name,
                Desc = row.desc,
                Faction = row.faction,
                Banned = isBanned and "Yes" or "No",
                BanningAdminName = info.charBanInfo and info.charBanInfo.name or "",
                BanningAdminSteamID = info.charBanInfo and info.charBanInfo.steamID or "",
                BanningAdminRank = info.charBanInfo and info.charBanInfo.rank or "",
                Money = money,
                LastUsed = lastUsedText,
                LastOnline = lastOnline,
                allVars = allVars
            }

            entry.extraDetails = {}
            hook.Run("CharListExtraDetails", client, entry, stored)
            table.insert(sendData, entry)
        end

        net.Start("DisplayCharList")
        net.WriteTable(sendData)
        net.WriteString(steam64)
        net.Send(client)
    end)
end)

net.Receive("liaRequestAllCharList", function(_, client)
    if not client:hasPrivilege("List Characters") then return end
    local query = [[SELECT lia_characters.*, lia_players.lastOnline FROM lia_characters
        LEFT JOIN lia_players ON lia_characters.steamID = lia_players.steamID]]
    lia.db.query(query, function(data)
        if not data or #data == 0 then
            client:notifyLocalized("noCharactersFound")
            return
        end

        local sendData = {}
        for _, row in ipairs(data) do
            local stored = lia.char.loaded[row.id]
            local info = stored and stored:getData() or lia.char.getCharData(row.id) or {}
            local isBanned = stored and stored:getBanned() or row.banned
            if isstring(isBanned) then
                local lower = isBanned:lower()
                if lower == "false" or lower == "nil" or isBanned == "NULL" then isBanned = false end
            end

            isBanned = tobool(isBanned)
            local allVars = {}
            for varName, varInfo in pairs(lia.char.vars) do
                local value
                if stored then
                    if varName == "data" then
                        value = stored:getData()
                    elseif varName == "var" then
                        value = stored:getVar()
                    else
                        local getter = stored["get" .. varName:sub(1, 1):upper() .. varName:sub(2)]
                        if isfunction(getter) then
                            value = getter(stored)
                        else
                            value = stored.vars and stored.vars[varName]
                        end
                    end
                else
                    if varName == "data" then
                        value = info
                    elseif varInfo.field and row[varInfo.field] ~= nil then
                        local raw = row[varInfo.field]
                        if isnumber(varInfo.default) then
                            value = tonumber(raw) or varInfo.default
                        elseif isbool(varInfo.default) then
                            value = tobool(raw)
                        elseif istable(varInfo.default) then
                            value = util.JSONToTable(raw or "{}")
                        else
                            value = raw
                        end
                    else
                        value = varInfo.default
                    end
                end

                allVars[varName] = value
            end

            local lastUsedText = stored and L("onlineNow") or row.lastJoinTime
            local lastOnline
            if stored then
                lastOnline = L("onlineNow")
            else
                local last = tonumber(row.lastOnline)
                if not isnumber(last) then last = os.time(lia.time.toNumber(row.lastJoinTime)) end
                local diff = os.time() - last
                local since = lia.time.TimeSince(last)
                local stripped = since:match("^(.-)%sago$") or since
                lastOnline = string.format("%s (%s) ago", stripped, lia.time.SecondsToDHM(diff))
            end

            local money = row.money
            if money == nil or money == "NULL" then money = 0 end
            local entry = {
                ID = row.id,
                SteamID = util.SteamIDFrom64(row.steamID),
                Name = row.name,
                Desc = row.desc,
                Faction = row.faction,
                Banned = isBanned and "Yes" or "No",
                BanningAdminName = info.charBanInfo and info.charBanInfo.name or "",
                BanningAdminSteamID = info.charBanInfo and info.charBanInfo.steamID or "",
                BanningAdminRank = info.charBanInfo and info.charBanInfo.rank or "",
                Money = money,
                LastUsed = lastUsedText,
                LastOnline = lastOnline,
                allVars = allVars
            }

            entry.extraDetails = {}
            hook.Run("CharListExtraDetails", client, entry, stored)
            table.insert(sendData, entry)
        end

        net.Start("DisplayCharList")
        net.WriteTable(sendData)
        net.WriteString("all")
        net.Send(client)
    end)
end)

net.Receive("lia_managesitrooms_action", function(_, client)
    if not client:hasPrivilege("Manage SitRooms") then return end
    local action = net.ReadUInt(2)
    local name = net.ReadString()
    local mapName = game.GetMap()
    local rooms = lia.data.get("sitrooms", {})
    if action == 1 then
        local targetPos = rooms[name] and lia.data.decodeVector(rooms[name])
        if targetPos then
            client:SetNW2Vector("previousSitroomPos", client:GetPos())
            client:SetPos(targetPos)
            client:notifyLocalized("sitroomTeleport", name)
            lia.log.add(client, "sendToSitRoom", client:Name(), name)
        end
    elseif action == 2 then
        local newName = net.ReadString()
        if newName ~= "" and not rooms[newName] and rooms[name] then
            rooms[newName] = rooms[name]
            rooms[name] = nil
            lia.data.set("sitrooms", rooms)
            client:notifyLocalized("sitroomRenamed")
            lia.log.add(client, "sitRoomRenamed", string.format("Map: %s | Old: %s | New: %s", mapName, name, newName), L("logRenamedSitroom"))
        end
    elseif action == 3 then
        if rooms[name] then
            rooms[name] = lia.data.encodetable(client:GetPos())
            lia.data.set("sitrooms", rooms)
            client:notifyLocalized("sitroomRepositioned")
            lia.log.add(client, "sitRoomRepositioned", string.format("Map: %s | Name: %s | New Position: %s", mapName, name, tostring(client:GetPos())), L("logRepositionedSitroom"))
        end
    end
end)

net.Receive("TransferMoneyFromP2P", function(_, sender)
    local amount = net.ReadUInt(32)
    local target = net.ReadEntity()
    if lia.config.get("DisableCheaterActions", true) and sender:getNetVar("cheater", false) then
        lia.log.add(sender, "cheaterAction", "transfer money")
        return
    end

    if not IsValid(sender) or not sender:getChar() then return end
    if sender:IsFamilySharedAccount() and not lia.config.get("AltsDisabled", false) then
        sender:notifyLocalized("familySharedMoneyTransferDisabled")
        return
    end

    if not IsValid(target) or not target:IsPlayer() or not target:getChar() then return end
    if amount <= 0 or not sender:getChar():hasMoney(amount) then return end
    target:getChar():giveMoney(amount)
    sender:getChar():takeMoney(amount)
    local senderName = sender:getChar():getDisplayedName(target)
    local targetName = sender:getChar():getDisplayedName(sender)
    sender:notifyLocalized("moneyTransferSent", lia.currency.get(amount), targetName)
    target:notifyLocalized("moneyTransferReceived", lia.currency.get(amount), senderName)
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
    lia.log.add(client, "charLoad", character:getName(), character:getID())
    net.Start("postPlayerLoadedChar")
    net.WriteUInt(character:getID(), 32)
    net.WriteType(currentChar and currentChar:getID() or nil)
    net.Send(client)
end)

net.Receive("liaTeleportToEntity", function(_, ply)
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    if not ply:hasPrivilege("Staff Permission — Teleport to Entity (Entity Tab)") then return end
    local pos = ent:GetPos() + Vector(0, 0, 50)
    ply:SetPos(pos)
    ply:notifyLocalized("teleportedToEntity", ent:GetClass())
    lia.log.add(ply, "teleportToEntity", ent:GetClass())
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
            lia.log.add(client, "charCreate", lia.char.loaded[id])
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
