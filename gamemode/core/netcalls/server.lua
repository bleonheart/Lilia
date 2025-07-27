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

-- from libraries/workshop.lua
net.Receive("WorkshopDownloader_Request", function(_, client)
    if not lia.config.get("AutoDownloadWorkshop", true) then return end
    lia.workshop.send(client)
end)

-- from modules/interactionmenu/libraries/server.lua
net.Receive("TransferMoneyFromP2P", function(_, sender)
    local MODULE = lia.module.get("interactionmenu")
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

net.Receive("RunOption", function(_, ply)
    local MODULE = lia.module.get("interactionmenu")
    if lia.config.get("DisableCheaterActions", true) and ply:getNetVar("cheater", false) then
        lia.log.add(ply, "cheaterAction", "use interaction menu")
        return
    end

    local name = net.ReadString()
    local opt = MODULE.Interactions[name]
    local tracedEntity = ply:getTracedEntity()
    if opt and opt.runServer and IsValid(tracedEntity) then opt.onRun(ply, tracedEntity) end
end)

net.Receive("RunLocalOption", function(_, ply)
    local MODULE = lia.module.get("interactionmenu")
    if lia.config.get("DisableCheaterActions", true) and ply:getNetVar("cheater", false) then
        lia.log.add(ply, "cheaterAction", "use interaction menu")
        return
    end

    local name = net.ReadString()
    local opt = MODULE.Actions[name]
    if opt and opt.runServer then opt.onRun(ply) end
end)

-- from modules/f1menu/libraries/server.lua
net.Receive("liaTeleportToEntity", function(_, ply)
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    if not ply:hasPrivilege("Teleport to Entity (Entity Tab)") then return end
    local pos = ent:GetPos() + Vector(0, 0, 50)
    ply:SetPos(pos)
    ply:notifyLocalized("teleportedToEntity", ent:GetClass())
    lia.log.add(ply, "teleportToEntity", ent:GetClass())
end)

-- from modules/administration/commands.lua
net.Receive("RequestStaffActions", function(_, client)
    local MODULE = lia.module.get("administration")
    if not client:hasPrivilege("View Staff Actions") then return end
    local function queryStaffActions(callback)
        lia.db.query([[
            SELECT a.admin, a.adminSteamID, lp.userGroup,
                   COALESCE(tc.ticketCount, 0) AS ticketCount,
                   COALESCE(w.warningCount, 0) AS warningCount,
                   COALESCE(b.banCount, 0) AS banCount
            FROM (
                SELECT DISTINCT adminSteamID, admin FROM lia_staffactions
                UNION
                SELECT DISTINCT adminSteamID, admin FROM lia_ticketclaims
                UNION
                SELECT DISTINCT adminSteamID, admin FROM lia_warnings
            ) AS a
            LEFT JOIN lia_players AS lp ON lp.steamID = a.adminSteamID
            LEFT JOIN (
                SELECT adminSteamID, COUNT(*) AS ticketCount
                FROM lia_ticketclaims
                GROUP BY adminSteamID
            ) AS tc ON tc.adminSteamID = a.adminSteamID
            LEFT JOIN (
                SELECT adminSteamID, COUNT(*) AS warningCount
                FROM lia_warnings
                GROUP BY adminSteamID
            ) AS w ON w.adminSteamID = a.adminSteamID
            LEFT JOIN (
                SELECT adminSteamID, COUNT(*) AS banCount
                FROM lia_staffactions
                WHERE action = 'plyban'
                GROUP BY adminSteamID
            ) AS b ON b.adminSteamID = a.adminSteamID
        ]], callback)
    end

    queryStaffActions(function(data)
        net.Start("StaffActions")
        net.WriteTable(data or {})
        net.Send(client)
    end)
end)

net.Receive("RequestPlayerWarnings", function(_, client)
    local MODULE = lia.module.get("warns")
    if not client:hasPrivilege("View Player Warnings") then return end
    local steamID = net.ReadString()
    MODULE:GetWarnings(steamID):next(function(rows)
        net.Start("PlayerWarnings")
        net.WriteTable(rows)
        net.Send(client)
    end)
end)

net.Receive("RequestTicketClaims", function(_, client)
    local MODULE = lia.module.get("tickets")
    if not client:hasPrivilege("View Claims") then return end
    lia.db.select({"timestamp", "requester", "requesterSteamID", "admin", "adminSteamID", "message"}, "ticketclaims"):next(function(res)
        net.Start("TicketClaims")
        net.WriteTable(res.results or {})
        net.Send(client)
    end)
end)

-- from modules/administration/submodules/warns/libraries/server.lua
net.Receive("RequestRemoveWarning", function(_, client)
    local MODULE = lia.module.get("warns")
    if not client:hasPrivilege("Can Remove Warns") then return end
    local charID = net.ReadInt(32)
    local rowData = net.ReadTable()
    local warnIndex = tonumber(rowData.ID or rowData.index)
    if not warnIndex then
        client:notifyLocalized("invalidWarningIndex")
        return
    end

    local targetChar = lia.char.loaded[charID]
    if not targetChar then
        client:notifyLocalized("characterNotFound")
        return
    end

    local targetClient = targetChar:getPlayer()
    if not IsValid(targetClient) then
        client:notifyLocalized("playerNotFound")
        return
    end

    MODULE:RemoveWarning(targetClient:SteamID64(), warnIndex):next(function(warn)
        if not warn then
            client:notifyLocalized("invalidWarningIndex")
            return
        end

        targetClient:notifyLocalized("warningRemovedNotify", client:Nick())
        client:notifyLocalized("warningRemoved", warnIndex, targetClient:Nick())
        hook.Run("WarningRemoved", client, targetClient, {
            reason = warn.warning,
            admin = warn.admin
        }, warnIndex)
    end)
end)

-- from modules/administration/submodules/itemspawner/libraries/server.lua
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

-- from modules/administration/submodules/logging/libraries/server.lua
net.Receive("send_logs_request", function(_, client)
    local MODULE = lia.module.get("logging")
    if not MODULE:CanPlayerSeeLog(client) then return end
    local categories = {}
    for _, logType in pairs(lia.log.types) do
        categories[logType.category or "Uncategorized"] = true
    end

    local catList = {}
    for cat in pairs(categories) do
        if hook.Run("CanPlayerSeeLogCategory", client, cat) ~= false then catList[#catList + 1] = cat end
    end

    local logsByCategory = {}
    local function fetch(idx)
        if idx > #catList then return MODULE:SendLogsInChunks(client, logsByCategory) end
        local cat = catList[idx]
        MODULE:ReadLogEntries(cat):next(function(entries)
            logsByCategory[cat] = entries
            fetch(idx + 1)
        end)
    end

    fetch(1)
end)

-- from modules/administration/module.lua (server)
net.Receive("liaGroupsRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local function syncPrivileges()
        local payload = {}
        for group, perms in pairs(lia.administration.groups) do
            payload[group] = table.Copy(perms)
        end

        lia.administration.syncAdminGroups(payload)
    end

    syncPrivileges()
    lia.administration.sendBigTable(p, lia.administration.payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
end)

net.Receive("liaPlayersRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    lia.administration.sendBigTable(p, lia.administration.payloadPlayers(), "liaPlayersDataChunk", "liaPlayersDataDone")
end)

net.Receive("liaCharBrowserRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local mode = net.ReadString()
    if mode == "all" then
        lia.administration.queryAllCharacters(p, function(data)
            lia.administration.sendBigTable(p, {
                mode = "all",
                list = data
            }, "liaCharBrowserChunk", "liaCharBrowserDone")
        end)
    else
        lia.administration.collectOnlineCharacters(p, function(data)
            lia.administration.sendBigTable(p, {
                mode = "online",
                list = data
            }, "liaCharBrowserChunk", "liaCharBrowserDone")
        end)
    end
end)

net.Receive("liaDBTablesRequest", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    lia.db.getTables():next(function(tables)
        net.Start("liaDBTables")
        net.WriteTable(tables or {})
        net.Send(p)
    end)
end)

net.Receive("liaGroupsAdd", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local n = net.ReadString()
    if n == "" then return end
    lia.administration.createGroup(n)
    lia.administration.groups[n] = lia.administration.buildDefaultTable(n)
    lia.administration.ensureCAMIGroup(n, "user")
    lia.administration.save(true)
    lia.administration.applyToCAMI(n, lia.administration.groups[n])
    lia.administration.sendBigTable(nil, lia.administration.payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    p:notify("Group '" .. n .. "' created.")
end)

net.Receive("liaGroupsRemove", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local n = net.ReadString()
    if n == "" or lia.administration.lia.administration.DefaultGroups[n] then return end
    lia.administration.removeGroup(n)
    lia.administration.groups[n] = nil
    lia.administration.dropCAMIGroup(n)
    lia.administration.save(true)
    lia.administration.sendBigTable(nil, lia.administration.payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    p:notify("Group '" .. n .. "' removed.")
end)

net.Receive("liaGroupsRename", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local old = net.ReadString()
    local new = net.ReadString()
    if old == "" or new == "" or lia.administration.lia.administration.DefaultGroups[old] or lia.administration.lia.administration.DefaultGroups[new] then return end
    if lia.administration.groups[new] or not lia.administration.groups[old] then return end
    lia.administration.groups[new] = lia.administration.groups[old]
    lia.administration.groups[old] = nil
    lia.administration.dropCAMIGroup(old)
    lia.administration.ensureCAMIGroup(new, "user")
    lia.administration.save(true)
    lia.administration.applyToCAMI(new, lia.administration.groups[new])
    for _, ply in player.Iterator() do
        if ply:GetUserGroup() == old then lia.administration.setPlayerGroup(ply, new) end
    end

    lia.administration.sendBigTable(nil, lia.administration.payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    p:notify("Group '" .. old .. "' renamed to '" .. new .. "'.")
end)

net.Receive("liaGroupsApply", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local g = net.ReadString()
    local t = net.ReadTable()
    if g == "" or lia.administration.lia.administration.DefaultGroups[g] then return end
    lia.administration.groups[g] = {}
    for k, v in pairs(t) do
        if v then lia.administration.groups[g][k] = true end
    end

    lia.administration.save(true)
    lia.administration.applyToCAMI(g, lia.administration.groups[g])
    lia.administration.sendBigTable(nil, lia.administration.payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    p:notify("Permissions saved for '" .. g .. "'.")
end)

net.Receive("liaGroupsDefaults", function(_, p)
    local function allowed(client)
        return IsValid(client) and client:IsSuperAdmin() and client:hasPrivilege("Manage UserGroups")
    end

    if not allowed(p) then return end
    local g = net.ReadString()
    if g == "" or lia.administration.lia.administration.DefaultGroups[g] then return end
    lia.administration.groups[g] = lia.administration.buildDefaultTable(g)
    lia.administration.save(true)
    lia.administration.applyToCAMI(g, lia.administration.groups[g])
    lia.administration.sendBigTable(nil, lia.administration.payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    p:notify("Defaults restored for '" .. g .. "'.")
end)

-- from modules/spawns/libraries/server.lua
net.Receive("request_respawn", function(_, client)
    if not IsValid(client) or not client:getChar() then return end
    local respawnTime = lia.config.get("SpawnTime", 5)
    local spawnTimeOverride = hook.Run("OverrideSpawnTime", client, respawnTime)
    if spawnTimeOverride then respawnTime = spawnTimeOverride end
    local lastDeathTime = client:getNetVar("lastDeathTime", os.time())
    if os.time() - lastDeathTime < respawnTime then return end
    if not client:Alive() and not client:getNetVar("IsDeadRestricted", false) then client:Spawn() end
end)

-- from modules/attributes/libraries/server.lua
net.Receive("ChangeAttribute", function(_, client)
    if not client:hasPrivilege("Commands - Manage Attributes") then return end
    local charID = net.ReadInt(32)
    net.ReadTable()
    local attribKey = net.ReadString()
    local amountStr = net.ReadString()
    local mode = net.ReadString()
    if not attribKey or not lia.attribs.list[attribKey] then
        for k, v in pairs(lia.attribs.list) do
            if lia.util.stringMatches(L(v.name), attribKey) or lia.util.stringMatches(k, attribKey) then
                attribKey = k
                break
            end
        end
    end

    if not attribKey or not lia.attribs.list[attribKey] then
        client:notifyLocalized("invalidAttributeKey")
        return
    end

    local attribValue = tonumber(amountStr)
    if not attribValue then
        client:notifyLocalized("invalidAmount")
        return
    end

    local targetClient = lia.char.getBySteamID(charID)
    if not IsValid(targetClient) then
        client:notifyLocalized("characterNotFound")
        return
    end

    local targetChar = targetClient:getChar()
    if not targetChar then
        client:notifyLocalized("characterNotFound")
        return
    end

    if mode == "Set" then
        if attribValue < 0 then
            client:notifyLocalized("attribNonNegative")
            return
        end

        targetChar:setAttrib(attribKey, attribValue)
        client:notifyLocalized("attribSet", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
        targetChar:getPlayer():notifyLocalized("yourAttributeSet", lia.attribs.list[attribKey].name, attribValue, client:Nick())
    elseif mode == "Add" then
        if attribValue <= 0 then
            client:notifyLocalized("attribPositive")
            return
        end

        local current = targetChar:getAttrib(attribKey, 0) or 0
        local newValue = current + attribValue
        if not isnumber(newValue) or newValue < 0 then
            client:notifyLocalized("attribCalculationError")
            return
        end

        targetChar:updateAttrib(attribKey, newValue)
        client:notifyLocalized("attribUpdate", targetChar:getPlayer():Name(), L(lia.attribs.list[attribKey].name), attribValue)
        targetChar:getPlayer():notifyLocalized("yourAttributeIncreased", lia.attribs.list[attribKey].name, attribValue, client:Nick())
    else
        client:notifyLocalized("invalidMode")
    end
end)

-- from modules/inventory/submodules/vendor/libraries/server.lua
net.Receive("VendorExit", function(_, client)
    local vendor = client.liaVendor
    if IsValid(vendor) then vendor:removeReceiver(client, true) end
end)

net.Receive("VendorEdit", function(_, client)
    local key = net.ReadString()
    if not client:CanEditVendor() then return end
    local vendor = client.liaVendor
    if not IsValid(vendor) or not lia.vendor.editor[key] then return end
    lia.log.add(client, "vendorEdit", vendor, key)
    lia.vendor.editor[key](vendor, client, key)
    hook.Run("UpdateEntityPersistence", vendor)
end)

net.Receive("VendorTrade", function(_, client)
    local uniqueID = net.ReadString()
    local isSellingToVendor = net.ReadBool()
    if not client:getChar() or not client:getChar():getInv() then return end
    if (client.liaVendorTry or 0) < CurTime() then
        client.liaVendorTry = CurTime() + 0.1
    else
        return
    end

    local entity = client.liaVendor
    if not IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 192 then return end
    if not hook.Run("CanPlayerAccessVendor", client, entity) then return end
    hook.Run("VendorTradeEvent", client, entity, uniqueID, isSellingToVendor)
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
    if tbl then
        hook.Run("LiaBigTableReceived", client, id, tbl)
    end
end)