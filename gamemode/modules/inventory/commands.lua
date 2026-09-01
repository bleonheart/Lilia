-- Inventory command registrations.
lia.command.add("returnitems", {
    superAdminOnly = true,
    desc = "Returns items lost on death to the specified player, if any.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Return Items",
        ButtonText = "Return Lost Items",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if lia.config.get("LoseItemsonDeathHuman", false) or lia.config.get("LoseItemsonDeathNPC", false) then
            if not target.LostItems or table.IsEmpty(target.LostItems) then
                client:notifyInfo("The target hasn't lost any items or they've already been returned.")
                return
            end

            local character = target:getChar()
            if not character then return end
            local inv = character:getInv()
            if not inv then return end
            for _, item in pairs(target.LostItems) do
                inv:add(lia.item.new(item.name, item.id))
            end

            target.LostItems = nil
            target:notifySuccess("Your items have been returned.")
            client:notifySuccess("Returned the items.")
            lia.log.add(client, "returnItems", target:Name())
        else
            client:notifyInfo("Item loss on death is not enabled!")
        end
    end
})

lia.command.add("returnallitems", {
    superAdminOnly = true,
    desc = "Returns items lost on death to all players who have lost items.",
    AdminStick = {
        Name = "Return All Items",
        ButtonText = "Return All Lost Items",
        Category = "Inventory",
    },
    onRun = function(client)
        if not lia.config.get("LoseItemsonDeathHuman", false) and not lia.config.get("LoseItemsonDeathNPC", false) then
            client:notifyInfo("Item loss on death is not enabled!")
            return
        end

        local returnedCount = 0
        local totalItems = 0
        for _, target in player.Iterator() do
            if not target.LostItems or table.IsEmpty(target.LostItems) then continue end
            local character = target:getChar()
            if not character then continue end
            local inv = character:getInv()
            if not inv then continue end
            local playerItemCount = 0
            for _, item in pairs(target.LostItems) do
                inv:add(lia.item.new(item.name, item.id))
                playerItemCount = playerItemCount + 1
            end

            target.LostItems = nil
            target:notifySuccess("Your items have been returned.")
            returnedCount = returnedCount + 1
            totalItems = totalItems + playerItemCount
            lia.log.add(client, "returnItems", target:Name())
        end

        if returnedCount > 0 then
            client:notifySuccess(string.format("Returned items to %d players (%d total items).", returnedCount, totalItems))
        else
            client:notifyInfo("No players have lost items to return.")
        end
    end
})

local function GetTicketsByRequester(steamID)
    local condition = "requesterSteamID = " .. lia.db.convertDataType(steamID)
    return lia.db.select({"timestamp", "requester", "requesterSteamID", "admin", "adminSteamID", "message"}, "ticketclaims", condition):next(function(res)
        local tickets = {}
        for _, row in ipairs(res.results or {}) do
            tickets[#tickets + 1] = {
                timestamp = isnumber(row.timestamp) and row.timestamp or os.time(lia.time.toNumber(row.timestamp)),
                requester = row.requester,
                requesterSteamID = row.requesterSteamID,
                admin = row.admin,
                adminSteamID = row.adminSteamID,
                message = row.message
            }
        end
        return tickets
    end)
end

-- Server console inventory commands.
concommand.Add("lia_set_inventory_size_all_chars", function(client, _, args)
    if IsValid(client) then return end
    local steamID = args[1]
    local width = tonumber(args[2])
    local height = tonumber(args[3])
    if not steamID or not width or not height then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_set_inventory_size_all_chars <steamID> <width> <height>\n")
        return
    end

    if width < 1 or height < 1 then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Width and height must be positive numbers.\n")
        return
    end

    lia.db.select({"id", "name"}, "characters", "steamID = " .. lia.db.convertDataType(steamID)):next(function(res)
        local characters = res.results or {}
        if not characters or #characters == 0 then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("No characters found for SteamID: %s", steamID) .. "\n")
            return
        end

        MsgC(Color(255, 255, 255), "[Lilia] ", "Processing " .. #characters .. " characters...\n")
        local ply = player.GetBySteamID(steamID)
        local isPlayerOnline = IsValid(ply) and ply:IsPlayer()
        local updatePromises = {}
        local sizeOverride = {width, height}
        local hasNotifiedPlayer = false
        local hasNotifiedStaff = false
        for _, charData in ipairs(characters) do
            local charID = charData.id
            local charName = charData.name
            local promise
            if isPlayerOnline then
                local character = lia.char.getCharacter(charID)
                if character then
                    character:setData("invSizeOverride", sizeOverride)
                    if not hasNotifiedPlayer then
                        ClientAddTextShadowed(ply, Color(255, 0, 0), "INVENTORY", Color(255, 255, 255), " " .. string.format("Your inventory size has been changed to %sx%s. Please swap characters for the change to take effect.", width, height))
                        hasNotifiedPlayer = true
                    end

                    if not hasNotifiedStaff then
                        local staffMessage = string.format("Inventory size set to %sx%s for %s (Steam64ID: %s).", width, height, ply:Name(), ply:SteamID64())
                        StaffAddTextShadowed(Color(199, 21, 133), "INVENTORY", Color(255, 255, 255), staffMessage)
                        hasNotifiedStaff = true
                    end

                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set inventory size override for character '" .. charName .. "' (ID: " .. charID .. ") to " .. width .. "x" .. height .. " (player online)\n")
                    promise = deferred.resolve(true)
                else
                    promise = deferred.new()
                    local encoded = pon.encode({sizeOverride})
                    lia.db.upsert({
                        charID = charID,
                        key = "invSizeOverride",
                        value = encoded
                    }, "chardata", function(success, err)
                        if success then
                            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set inventory size override for character '" .. charName .. "' (ID: " .. charID .. ") to " .. width .. "x" .. height .. " (player online, char not loaded)\n")
                            promise:resolve(true)
                        else
                            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error setting inventory size override for character '" .. charName .. "' (ID: " .. charID .. "): " .. tostring(err) .. "\n")
                            promise:resolve(false)
                        end
                    end)
                end
            else
                promise = deferred.new()
                local encoded = pon.encode({sizeOverride})
                lia.db.upsert({
                    charID = charID,
                    key = "invSizeOverride",
                    value = encoded
                }, "chardata", function(success, err)
                    if success then
                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set inventory size override for character '" .. charName .. "' (ID: " .. charID .. ") to " .. width .. "x" .. height .. " (player offline)\n")
                        promise:resolve(true)
                    else
                        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error setting inventory size override for character '" .. charName .. "' (ID: " .. charID .. "): " .. tostring(err) .. "\n")
                        promise:resolve(false)
                    end
                end)
            end

            table.insert(updatePromises, promise)
        end

        deferred.map(updatePromises, function(result) return result end):next(function(results)
            local successCount = 0
            for _, success in ipairs(results) do
                if success then successCount = successCount + 1 end
            end

            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully set inventory size override for " .. successCount .. " of " .. #characters .. " characters.\n")
            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Note: Inventory sizes will be applied when characters load.\n")
            lia.log.add(nil, "setInventorySizeAllChars", steamID, width, height, successCount)
        end)
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database error: " .. tostring(err) .. "\n") end)
end)
