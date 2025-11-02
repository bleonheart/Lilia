--[[
    Server-Side Hooks

    Server-side hook system for the Lilia framework.
    These hooks run on the server and are used for server-side logic, data management, and game state handling.
]]
--[[
    Overview:
        Server-side hooks in the Lilia framework handle server-side logic, data persistence, permissions, character management, and other server-specific functionality. They follow the Garry's Mod hook system and can be overridden or extended by addons and modules.
]]
--[[
    Purpose:
        Adds a warning entry to the database for administrative tracking

    When Called:
        When an administrator issues a warning to a player through the administration system

    Parameters:
        - charID (number): The character ID of the warned player
        - warned (string): The name of the warned player
        - warnedSteamID (string): The SteamID of the warned player
        - timestamp (number): The Unix timestamp when the warning was issued
        - message (string): The warning message/reason
        - warner (string): The name of the administrator who issued the warning
        - warnerSteamID (string): The SteamID of the administrator who issued the warning

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic warning addition
    hook.Add("AddWarning", "MyAddon", function(charID, warned, warnedSteamID, timestamp, message, warner, warnerSteamID)
        -- Log the warning to a custom system
        print("Warning issued: " .. warned .. " by " .. warner)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Enhanced warning logging with notifications
    hook.Add("AddWarning", "WarningNotification", function(charID, warned, warnedSteamID, timestamp, message, warner, warnerSteamID)
        -- Send notification to all online staff
        for _, ply in ipairs(player.GetAll()) do
            if ply:hasPrivilege("canSeeWarnings") then
                ply:notify("Warning issued to " .. warned .. " by " .. warner .. ": " .. message)
            end
        end

        -- Log to external service
        lia.log.add(nil, "warning_issued", warned, warnedSteamID, warner, warnerSteamID, message)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive warning system with escalation
    hook.Add("AddWarning", "AdvancedWarningSystem", function(charID, warned, warnedSteamID, timestamp, message, warner, warnerSteamID)
        local client = player.GetBySteamID(warnedSteamID)
        local warnerPlayer = player.GetBySteamID(warnerSteamID)

        -- Check for warning escalation
        lia.db.selectOne({"COUNT(*) as warning_count"}, "warnings", "warnedSteamID = " .. lia.db.convertDataType(warnedSteamID)):next(function(result)
            local warningCount = result and result.warning_count or 0

            -- Automatic actions based on warning count
            if warningCount >= 3 then
                -- Third warning - kick player
                if IsValid(client) then
                    client:Kick("Multiple warnings - please review server rules")
                end
            elseif warningCount >= 5 then
                -- Fifth warning - ban player
                if IsValid(warnerPlayer) then
                    lia.command.run(warnerPlayer, "ban", {warnedSteamID, "86400", "Multiple warnings - review server rules"})
                end
            end

            -- Notify staff channel
            local embed = {
                title = "Player Warning Issued",
                description = string.format("**Player:** %s (%s)\n**Warner:** %s (%s)\n**Reason:** %s\n**Total Warnings:** %d",
                    warned, warnedSteamID, warner, warnerSteamID, message, warningCount + 1),
                color = 0xffa500
            }

            hook.Run("DiscordRelaySend", embed)
        end)
    end)
    ```
]]
function AddWarning(charID, warned, warnedSteamID, timestamp, message, warner, warnerSteamID)
end

--[[
    Purpose:
        Allows modification of character creation data before the character is created

    When Called:
        During character creation process, after initial data validation but before character insertion

    Parameters:
        - client (Player): The player creating the character
        - data (table): The character creation data
        - newData (table): Modified character data (can be altered)
        - originalData (table): The original character creation data (read-only)

    Returns:
        table - The modified character data, or nil to use original data

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Add default money to new characters
    hook.Add("AdjustCreationData", "MyAddon", function(client, data, newData, originalData)
    data.money = data.money + 1000 -- Give extra starting money
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Modify character based on faction
    hook.Add("AdjustCreationData", "FactionBonuses", function(client, data, newData, originalData)
    if data.faction == "police" then
        data.money = data.money + 500 -- Police get extra money
        data.desc = data.desc .. "\n\n[Police Officer]"
    elseif data.faction == "citizen" then
        data.money = data.money + 200 -- Citizens get small bonus
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex character creation system with validation
    hook.Add("AdjustCreationData", "AdvancedCreation", function(client, data, newData, originalData)
    -- Validate character name
    if string.len(data.name) < 3 then
        data.name = data.name .. " Jr."
    end
    -- Add faction-specific bonuses
    local factionBonuses = {
    ["police"] = {money = 1000, items = {"weapon_pistol"}},
    ["medic"] = {money = 800, items = {"medkit"}},
    ["citizen"] = {money = 200, items = {}}
    }
    local bonus = factionBonuses[data.faction]
    if bonus then
        data.money = data.money + bonus.money
        data.startingItems = data.startingItems or {}
        for _, item in ipairs(bonus.items) do
            table.insert(data.startingItems, item)
        end
    end
    -- Add creation timestamp
    data.creationTime = os.time()
    data.creationIP = client:IPAddress()
    end)
    ```
]]
function AdjustCreationData(client, data, newData, originalData)
end

--[[
    Purpose:
        Called when a bag's inventory becomes ready for use

    When Called:
        When a bag item is created and its inventory is fully initialized

    Parameters:
        - self (Item): The bag item
        - inventory (Inventory): The bag's inventory instance

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log when bag inventory is ready
    hook.Add("BagInventoryReady", "MyAddon", function(self, inventory)
    print("Bag inventory ready for item: " .. self.uniqueID)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Add special items to bag inventory
    hook.Add("BagInventoryReady", "SpecialBags", function(self, inventory)
    if self.uniqueID == "magic_bag" then
        -- Add a magic item to the bag
        local magicItem = lia.item.instance("magic_crystal")
        if magicItem then
            inventory:add(magicItem)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex bag inventory system with validation
    hook.Add("BagInventoryReady", "AdvancedBags", function(self, inventory)
    local char = self:getOwner()
    if not char then return end
        -- Set up faction-specific bag contents
        local faction = char:getFaction()
        local bagContents = {
        ["police"] = {
        {item = "handcuffs", quantity = 1},
        {item = "police_badge", quantity = 1},
        {item = "radio", quantity = 1}
        },
        ["medic"] = {
        {item = "medkit", quantity = 2},
        {item = "bandage", quantity = 5},
        {item = "stethoscope", quantity = 1}
        },
        ["citizen"] = {
        {item = "wallet", quantity = 1},
        {item = "phone", quantity = 1}
        }
        }
        local contents = bagContents[faction]
        if contents then
            for _, content in ipairs(contents) do
                local item = lia.item.instance(content.item)
                if item then
                    item:setData("quantity", content.quantity)
                    inventory:add(item)
                    end
                end
            end
        end
    end)
    ```
]]
function BagInventoryReady(self, inventory)
end

--[[
    Purpose:
        Called when a bag's inventory is removed

    When Called:
        When a bag item is removed and its inventory needs to be cleaned up

    Parameters:
        - self (Item): The bag item being removed
        - inv (Inventory): The bag's inventory instance

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log bag removal
    hook.Add("BagInventoryRemoved", "BagRemovalLog", function(self, inv)
        print("Bag removed: " .. self.uniqueID)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Save bag contents before removal
    hook.Add("BagInventoryRemoved", "SaveBagContents", function(self, inv)
        local client = self.player
        if not client then return end

        -- Save important items back to player inventory
        for _, item in pairs(inv:getItems()) do
            if item.isImportant then
                client:getChar():getInv():add(item.uniqueID, 1, item.data)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive bag cleanup with notifications
    hook.Add("BagInventoryRemoved", "AdvancedBagCleanup", function(self, inv)
        local client = self.player
        if not client then return end

        local char = client:getChar()
        if not char then return end

        -- Count lost items
        local itemCount = table.Count(inv:getItems())
        local lostItems = {}

        -- Attempt to recover valuable items
        for _, item in pairs(inv:getItems()) do
            if item:getData("valuable", false) then
                -- Try to add to player inventory
                if char:getInv():add(item.uniqueID, 1, item.data) then
                    client:notifyLocalized("itemRecovered", item:getName())
                else
                    table.insert(lostItems, item:getName())
                end
            else
                table.insert(lostItems, item:getName())
            end
        end

        -- Notify player of lost items
        if #lostItems > 0 then
            client:notifyLocalized("itemsLostInBag", table.concat(lostItems, ", "))
        end

        -- Log bag destruction
        lia.log.add(client, "bag_destroyed", self.uniqueID, itemCount, #lostItems)
    end)
    ```
]]
function BagInventoryRemoved(self, inv)
end

--[[
    Purpose:
        Determines whether a character can be transferred to a different faction

    When Called:
        When a player attempts to transfer their character to another faction

    Parameters:
        - targetChar (Character): The character being transferred
        - faction (table): The faction to transfer to
        - client (Player): The player requesting the transfer

    Returns:
        boolean - True if the transfer is allowed, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Use same logic as CanBeTransfered
    hook.Add("CanCharBeTransfered", "MyAddon", function(targetChar, faction, client)
    return hook.Run("CanBeTransfered", targetChar, faction, client)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Add additional character-specific checks
    hook.Add("CanCharBeTransfered", "CharChecks", function(targetChar, faction, client)
    -- Check if character is banned
    if targetChar:isBanned() then
        return false
        end
    -- Check character age
    local charAge = targetChar:getData("age", 18)
    if faction == "police" and charAge < 21 then
        return false -- Must be 21+ to be police
        end
    return hook.Run("CanBeTransfered", targetChar, faction, client)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character transfer system
    hook.Add("CanCharBeTransfered", "AdvancedCharTransfers", function(targetChar, faction, client)
    local charData = targetChar:getData()
    -- Check character reputation
    local reputation = charData.reputation or 0
    if faction == "police" and reputation < 50 then
        client:ChatPrint("You need a good reputation to join the police")
        return false
        end
    -- Check for outstanding warrants
    if charData.warrants and #charData.warrants > 0 then
        client:ChatPrint("You have outstanding warrants and cannot transfer")
        return false
        end
    -- Check faction capacity
    local factionCount = 0
    for _, char in pairs(lia.char.getCharacters()) do
        if char:getFaction() == faction then
            factionCount = factionCount + 1
            end
        end
    local maxFactionMembers = {
    ["police"] = 10,
    ["medic"] = 5,
    ["mayor"] = 1
    }
    local maxMembers = maxFactionMembers[faction]
    if maxMembers and factionCount >= maxMembers then
        client:ChatPrint("That faction is full")
        return false
        end
    return hook.Run("CanBeTransfered", targetChar, faction, client)
    end)
    ```
]]
function CanCharBeTransfered(targetChar, faction, client)
end

--[[
    Purpose:
        Determines whether a player can delete a character

    When Called:
        When a player attempts to delete one of their characters

    Parameters:
        - client (Player): The player attempting to delete the character
        - character (Character): The character being deleted

    Returns:
        boolean - True if the character can be deleted, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all character deletions
    hook.Add("CanDeleteChar", "MyAddon", function(client, character)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Prevent deletion of high-level characters
    hook.Add("CanDeleteChar", "LevelRestrictions", function(client, character)
    local charLevel = character:getData("level", 1)
    if charLevel > 10 then
        client:ChatPrint("You cannot delete characters above level 10")
        return false
        end
    return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex deletion validation system
    hook.Add("CanDeleteChar", "AdvancedDeletion", function(client, character)
    local charMoney = character:getMoney()
    local charLevel = character:getData("level", 1)
    -- Check if character has valuable items
    local hasValuables = false
    local charInv = character:getInv()
    for _, item in pairs(charInv:getItems()) do
        if item.uniqueID == "gold_bar" or item.uniqueID == "diamond" then
            hasValuables = true
            break
            end
        end
    if hasValuables then
        client:ChatPrint("You must remove all valuable items before deleting this character")
        return false
        end
    -- Check if character is in a faction
    local faction = character:getFaction()
    if faction ~= "citizen" then
        client:ChatPrint("You must leave your faction before deleting this character")
        return false
        end
    -- Check cooldown
    local lastDeletion = client:getData("lastCharDeletion", 0)
    if os.time() - lastDeletion < 86400 then -- 24 hour cooldown
        client:ChatPrint("You must wait 24 hours before deleting another character")
        return false
        end
    return true
    ```
]]
function CanDeleteChar(client, character)
end

--[[
    Purpose:
        Determines whether deletechar is allowed

    When Called:
        When deletechar is attempted

    Parameters:
        - client: Description
        - character: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all character deletions
    hook.Add("CanDeleteChar", "MyAddon", function(client, character)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Prevent deletion of high-level characters
    hook.Add("CanDeleteChar", "LevelRestrictions", function(client, character)
    local charLevel = character:getData("level", 1)
    if charLevel > 10 then
        client:ChatPrint("You cannot delete characters above level 10")
        return false
        end
    return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex deletion validation system
    hook.Add("CanDeleteChar", "AdvancedDeletion", function(client, character)
    local charMoney = character:getMoney()
    local charLevel = character:getData("level", 1)
    -- Check if character has valuable items
    local hasValuables = false
    local charInv = character:getInv()
    for _, item in pairs(charInv:getItems()) do
        if item.uniqueID == "gold_bar" or item.uniqueID == "diamond" then
            hasValuables = true
            break
            end
        end
    if hasValuables then
        client:ChatPrint("You must remove all valuable items before deleting this character")
        return false
        end
    -- Check if character is in a faction
    local faction = character:getFaction()
    if faction ~= "citizen" then
        client:ChatPrint("You must leave your faction before deleting this character")
        return false
        end
    -- Check cooldown
    local lastDeletion = client:getData("lastCharDeletion", 0)
    if os.time() - lastDeletion < 86400 then -- 24 hour cooldown
        client:ChatPrint("You must wait 24 hours before deleting another character")
        return false
        end
    return true
    end)
    ```
]]
function CanInviteToClass(client, target)
end

--[[
    Purpose:
        Determines whether invitetoclass is allowed

    When Called:
        When invitetoclass is attempted

    Parameters:
        - client: Description
        - target: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow admins only
    hook.Add("CanInviteToClass", "MyAddon", function(client, target)
    return client:IsAdmin()
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check faction and rank
    hook.Add("CanInviteToClass", "ClassInviteCheck", function(client, target)
    local char = client:getChar()
    if not char then return false end
        local rank = char:getData("rank", 0)
        return rank >= 3
        end)
    ```

    High Complexity:
    ```lua
    -- High: Complex class invitation system
    hook.Add("CanInviteToClass", "AdvancedClassInvite", function(client, target)
    local char = client:getChar()
    local targetChar = target:getChar()
    if not char or not targetChar then return false end
        -- Check if client has permission
        local rank = char:getData("rank", 0)
        if rank < 3 then
            client:ChatPrint("You need rank 3 or higher to invite players")
            return false
            end
        -- Check if target is in same faction
        if char:getFaction() ~= targetChar:getFaction() then
            client:ChatPrint("Target must be in your faction")
            return false
            end
        -- Check cooldown
        local lastInvite = char:getData("lastClassInvite", 0)
        if os.time() - lastInvite < 60 then
            client:ChatPrint("Please wait before inviting again")
            return false
            end
        return true
        end)
]]
function CanInviteToFaction(client, target)
end

--[[
    Purpose:
        Determines whether invitetofaction is allowed

    When Called:
        When invitetofaction is attempted

    Parameters:
        - client: Description
        - target: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow admins only
    hook.Add("CanInviteToFaction", "MyAddon", function(client, target)
    return client:IsAdmin()
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check faction leader status
    hook.Add("CanInviteToFaction", "FactionInviteCheck", function(client, target)
    local char = client:getChar()
    if not char then return false end
        return char:getData("factionLeader", false)
        end)
    ```

    High Complexity:
    ```lua
    -- High: Complex faction invitation system
    hook.Add("CanInviteToFaction", "AdvancedFactionInvite", function(client, target)
    local char = client:getChar()
    local targetChar = target:getChar()
    if not char or not targetChar then return false end
        -- Check if client is faction leader
        if not char:getData("factionLeader", false) then
            client:ChatPrint("Only faction leaders can invite players")
            return false
            end
        -- Check faction member limit
        local faction = char:getFaction()
        local memberCount = 0
        for _, ply in ipairs(player.GetAll()) do
            local plyChar = ply:getChar()
            if plyChar and plyChar:getFaction() == faction then
                memberCount = memberCount + 1
                end
            end
        local maxMembers = 20
        if memberCount >= maxMembers then
            client:ChatPrint("Faction is at maximum capacity")
            return false
            end
        return true
        end)
    ```
]]
function CanItemBeTransfered(item, fromInventory, toInventory, client)
end

--[[
    Purpose:
        Determines whether itembetransfered is allowed

    When Called:
        When itembetransfered is attempted

    Parameters:
        - item: Description
        - fromInventory: Description
        - toInventory: Description
        - client: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all transfers
    hook.Add("CanItemBeTransfered", "MyAddon", function(item, fromInventory, toInventory, client)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check inventory types
    hook.Add("CanItemBeTransfered", "InventoryTypeCheck", function(item, fromInventory, toInventory, client)
    -- Prevent transferring to vendor inventories
    if toInventory.isVendor then
        return false
        end
    -- Check if item is transferable
    if item:getData("noTransfer", false) then
        return false
        end
    return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex transfer validation system
    hook.Add("CanItemBeTransfered", "AdvancedTransferValidation", function(item, fromInventory, toInventory, client)
    local char = client:getChar()
    if not char then return false end
        -- Check if item is transferable
        if item:getData("noTransfer", false) then
            client:ChatPrint("This item cannot be transferred")
            return false
            end
        -- Check inventory types
        if toInventory.isVendor then
            client:ChatPrint("Cannot transfer items to vendor inventories")
            return false
            end
        -- Check weight limits
        local itemWeight = item:getWeight()
        local currentWeight = toInventory:getWeight()
        local maxWeight = toInventory:getMaxWeight()
        if currentWeight + itemWeight > maxWeight then
            client:ChatPrint("Not enough space in destination inventory")
            return false
            end
        return true
        end)
    ```
]]
function CanPerformVendorEdit(self, vendor)
end

--[[
    Purpose:
        Determines whether performvendoredit is allowed

    When Called:
        When performvendoredit is attempted

    Parameters:
        - self: Description
        - vendor: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow admins only
    hook.Add("CanPerformVendorEdit", "MyAddon", function(self, vendor)
    local client = self.activator
    return client and client:IsAdmin()
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check vendor ownership
    hook.Add("CanPerformVendorEdit", "VendorEditCheck", function(self, vendor)
    local client = self.activator
    if not client then return false end
        local char = client:getChar()
        if not char then return false end
            local owner = vendor.owner
            return owner == char:getID() or client:IsAdmin()
            end)
    ```

    High Complexity:
    ```lua
    -- High: Complex vendor editing system
    hook.Add("CanPerformVendorEdit", "AdvancedVendorEdit", function(self, vendor)
    local client = self.activator
    if not client then return false end
        local char = client:getChar()
        if not char then return false end
            -- Admins can always edit
            if client:IsAdmin() then return true end
                -- Check vendor ownership
                local owner = vendor.owner
                if owner ~= char:getID() then
                    client:ChatPrint("You don't own this vendor")
                    return false
                    end
                -- Check edit cooldown
                local lastEdit = char:getData("lastVendorEdit", 0)
                if os.time() - lastEdit < 30 then
                    client:ChatPrint("Please wait before editing again")
                    return false
                    end
                char:setData("lastVendorEdit", os.time())
                return true
                end)
    ```
]]
function CanPersistEntity(entity)
end

--[[
    Purpose:
        Determines whether persistentity is allowed

    When Called:
        When persistentity is attempted

    Parameters:
        - entity: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Persist all props
    hook.Add("CanPersistEntity", "MyAddon", function(entity)
    return entity:GetClass() == "prop_physics"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Persist specific entities
    hook.Add("CanPersistEntity", "EntityPersistCheck", function(entity)
    local persistClasses = {
    ["prop_physics"] = true,
    ["prop_dynamic"] = true,
    ["lia_item"] = true
    }
    return persistClasses[entity:GetClass()] or false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex entity persistence system
    hook.Add("CanPersistEntity", "AdvancedEntityPersist", function(entity)
    if not IsValid(entity) then return false end
        -- Check entity class
        local persistClasses = {
        ["prop_physics"] = true,
        ["prop_dynamic"] = true,
        ["lia_item"] = true,
        ["lia_vendor"] = true
        }
        if not persistClasses[entity:GetClass()] then
            return false
            end
        -- Check if entity is marked as temporary
        if entity:getNetVar("temporary", false) then
            return false
            end
        -- Check entity age
        local spawnTime = entity:getNetVar("spawnTime", 0)
        if os.time() - spawnTime < 60 then
            return false
            end
        return true
        end)
    ```
]]
function CanPickupMoney(activator, self)
end

--[[
    Purpose:
        Determines whether pickupmoney is allowed

    When Called:
        When pickupmoney is attempted

    Parameters:
        - activator: Description
        - self: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all money pickup
    hook.Add("CanPickupMoney", "MyAddon", function(activator, self)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check distance and amount
    hook.Add("CanPickupMoney", "CheckMoneyPickup", function(activator, self)
    local distance = activator:GetPos():Distance(self:GetPos())
    if distance > 100 then
        return false
        end
    local amount = self:getNetVar("amount", 0)
    if amount <= 0 then
        return false
        end
    return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex money pickup system
    hook.Add("CanPickupMoney", "AdvancedMoneyPickup", function(activator, self)
    if not IsValid(activator) or not IsValid(self) then return false end
        local char = activator:getChar()
        if not char then return false end
            -- Check distance
            local distance = activator:GetPos():Distance(self:GetPos())
            if distance > 100 then
                activator:ChatPrint("You are too far away to pick up the money")
                return false
                end
            -- Check amount
            local amount = self:getNetVar("amount", 0)
            if amount <= 0 then
                return false
                end
            -- Check if money is owned
            local owner = self:getNetVar("owner")
            if owner and owner ~= char:getID() then
                activator:ChatPrint("This money belongs to someone else")
                return false
                end
            return true
            end)
    ```
]]
function CanPlayerAccessDoor(client, self, access)
end

--[[
    Purpose:
        Determines whether playeraccessdoor is allowed

    When Called:
        When playeraccessdoor is attempted

    Parameters:
        - client: Description
        - self: Description
        - access: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all players
    hook.Add("CanPlayerAccessDoor", "MyAddon", function(client, self, access)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check door ownership
    hook.Add("CanPlayerAccessDoor", "DoorAccessCheck", function(client, self, access)
    local char = client:getChar()
    if not char then return false end
        local owner = self:getNetVar("owner")
        return owner == char:getID()
        end)
    ```

    High Complexity:
    ```lua
    -- High: Complex door access system
    hook.Add("CanPlayerAccessDoor", "AdvancedDoorAccess", function(client, self, access)
    local char = client:getChar()
    if not char then return false end
        -- Admins can access all doors
        if client:IsAdmin() then return true end
            -- Check door ownership
            local owner = self:getNetVar("owner")
            if owner == char:getID() then return true end
                -- Check faction access
                local allowedFactions = self:getNetVar("allowedFactions", {})
                if table.HasValue(allowedFactions, char:getFaction()) then
                    return true
                    end
                -- Check if player has key
                local doorID = self:getNetVar("doorID")
                if doorID and char:getInv():hasItem("door_key_" .. doorID) then
                    return true
                    end
                return false
                end)
    ```
]]
function CanPlayerAccessVendor(activator, self)
end

--[[
    Purpose:
        Determines whether playeraccessvendor is allowed

    When Called:
        When playeraccessvendor is attempted

    Parameters:
        - activator: Description
        - self: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all players
    hook.Add("CanPlayerAccessVendor", "MyAddon", function(activator, self)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check faction restrictions
    hook.Add("CanPlayerAccessVendor", "VendorAccessCheck", function(activator, self)
    local char = activator:getChar()
    if not char then return false end
        local allowedFactions = self:getNetVar("allowedFactions", {})
        if #allowedFactions > 0 and not table.HasValue(allowedFactions, char:getFaction()) then
            return false
            end
        return true
        end)
    ```

    High Complexity:
    ```lua
    -- High: Complex vendor access system
    hook.Add("CanPlayerAccessVendor", "AdvancedVendorAccess", function(activator, self)
    local char = activator:getChar()
    if not char then return false end
        -- Check faction restrictions
        local allowedFactions = self:getNetVar("allowedFactions", {})
        if #allowedFactions > 0 and not table.HasValue(allowedFactions, char:getFaction()) then
            activator:ChatPrint("Your faction cannot access this vendor")
            return false
            end
        -- Check level requirements
        local requiredLevel = self:getNetVar("requiredLevel", 0)
        local charLevel = char:getData("level", 1)
        if charLevel < requiredLevel then
            activator:ChatPrint("You need to be level " .. requiredLevel .. " to access this vendor")
            return false
            end
        return true
        end)
    ```
]]
function CanPlayerChooseWeapon(weapon)
end

--[[
    Purpose:
        Determines whether playerchooseweapon is allowed

    When Called:
        When playerchooseweapon is attempted

    Parameters:
        - weapon: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all weapons
    hook.Add("CanPlayerChooseWeapon", "MyAddon", function(weapon)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Restrict specific weapons
    hook.Add("CanPlayerChooseWeapon", "RestrictWeapons", function(weapon)
    local restrictedWeapons = {"weapon_crowbar", "weapon_stunstick"}
    return not table.HasValue(restrictedWeapons, weapon:GetClass())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex weapon selection system
    hook.Add("CanPlayerChooseWeapon", "AdvancedWeaponSelection", function(weapon)
    local client = weapon:GetOwner()
    if not IsValid(client) then return false end
        local char = client:getChar()
        if not char then return false end
            -- Check faction restrictions
            local faction = char:getFaction()
            local weaponClass = weapon:GetClass()
            if faction == "police" then
                local policeWeapons = {"weapon_pistol", "weapon_stunstick"}
                return table.HasValue(policeWeapons, weaponClass)
            elseif faction == "medic" then
                local medicWeapons = {"weapon_medkit", "weapon_stunstick"}
                return table.HasValue(medicWeapons, weaponClass)
                end
            -- Check level requirements
            local requiredLevel = weapon:getData("requiredLevel", 1)
            local charLevel = char:getData("level", 1)
            if charLevel < requiredLevel then
                return false
                end
            return true
            end)
    ```
]]
function CanPlayerCreateChar(client, data)
end

--[[
    Purpose:
        Determines whether playercreatechar is allowed

    When Called:
        When playercreatechar is attempted

    Parameters:
        - client: Description
        - data: Description

    Returns:
        boolean - True to allow, false to deny

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all character creation
    hook.Add("CanPlayerCreateChar", "MyAddon", function(client, data)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check character limit
    hook.Add("CanPlayerCreateChar", "CharLimit", function(client, data)
    local charCount = #client.liaCharList or 0
    local maxChars = hook.Run("GetMaxPlayerChar", client) or 5
    if charCount >= maxChars then
        client:ChatPrint("You have reached the maximum number of characters")
        return false
        end
    return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex character creation validation
    hook.Add("CanPlayerCreateChar", "AdvancedCreation", function(client, data)
    -- Check if player is banned
    if client:IsBanned() then
        client:ChatPrint("You are banned and cannot create characters")
        return false
        end
    -- Check character name validity
    local name = data.name or ""
    if string.len(name) < 3 then
        client:ChatPrint("Character name must be at least 3 characters long")
        return false
        end
    if string.len(name) > 32 then
        client:ChatPrint("Character name must be less than 32 characters")
        return false
        end
    -- Check for inappropriate names
    local bannedWords = {"admin", "moderator", "staff", "test"}
    for _, word in ipairs(bannedWords) do
        if string.find(string.lower(name), string.lower(word)) then
            client:ChatPrint("That name is not allowed")
            return false
            end
        end
    return true
    end)
    ```
]]
function CanPlayerDropItem(client, item)
end

--[[
    Purpose:
        Determines whether a player is allowed to drop an item

    When Called:
        When a player attempts to drop an item from their inventory

    Parameters:
        - client (Player): The player attempting to drop the item
        - item (Item): The item being dropped

    Returns:
        boolean - True if the player can drop the item, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent dropping quest items
    hook.Add("CanPlayerDropItem", "NoQuestDrops", function(client, item)
        if item:getData("questItem") then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check faction restrictions
    hook.Add("CanPlayerDropItem", "FactionDropRestrictions", function(client, item)
        local char = client:getChar()
        if not char then return false end

        local faction = char:getFaction()
        if faction == FACTION_POLICE and item.uniqueID == "badge" then
            client:notify("You cannot drop your police badge!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex drop validation with multiple checks
    hook.Add("CanPlayerDropItem", "AdvancedDropValidation", function(client, item)
        local char = client:getChar()
        if not char then return false end

        -- Check if item is bound to character
        if item:getData("bound") then
            client:notify("This item is bound to you and cannot be dropped!")
            return false
        end

        -- Check faction/class restrictions
        local faction = lia.faction.indices[char:getFaction()]
        local class = lia.class.list[char:getClass()]

        if faction and faction.restrictedItems and table.HasValue(faction.restrictedItems, item.uniqueID) then
            client:notify("Your faction prohibits dropping this item!")
            return false
        end

        -- Check for equipped items
        if item:getData("equip") and not lia.config.get("AllowEquippedDrops", false) then
            client:notify("You cannot drop equipped items!")
            return false
        end

        -- Check weight/durability
        if item:getData("durability", 100) < 10 then
            client:notify("This item is too damaged to be dropped safely!")
            return false
        end

        -- Log the drop attempt
        lia.log.add(client, "item_drop_attempt", item.uniqueID, item:getData("durability", 100))

        return true
    end)
    ```
]]
function CanPlayerEarnSalary(client)
end

--[[
    Purpose:
        Determines whether a player is allowed to earn salary

    When Called:
        When the salary system checks if a player should receive their pay

    Parameters:
        - client (Player): The player who might receive salary

    Returns:
        boolean - True if the player can earn salary, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent salary for AFK players
    hook.Add("CanPlayerEarnSalary", "NoAFKSalary", function(client)
        if client:GetNWBool("AFK", false) then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Time-based salary requirements
    hook.Add("CanPlayerEarnSalary", "TimeBasedSalary", function(client)
        local char = client:getChar()
        if not char then return false end

        -- Require minimum playtime since last salary
        local lastSalary = char:getData("lastSalaryTime", 0)
        local minTime = lia.config.get("MinSalaryTime", 3600) -- 1 hour default

        if os.time() - lastSalary < minTime then
            return false
        end

        -- Update last salary time
        char:setData("lastSalaryTime", os.time())
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex salary eligibility with multiple checks
    hook.Add("CanPlayerEarnSalary", "AdvancedSalaryCheck", function(client)
        local char = client:getChar()
        if not char then return false end

        -- Check if player is banned from salary
        if char:getData("salaryBanned", false) then
            return false
        end

        -- Check playtime requirements
        local lastSalary = char:getData("lastSalaryTime", 0)
        local requiredTime = lia.config.get("SalaryTimeRequired", 3600)
        if os.time() - lastSalary < requiredTime then
            return false
        end

        -- Check if player is active (not AFK)
        if client:GetNWBool("AFK", false) then
            return false
        end

        -- Check faction requirements
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.noSalary then
            return false
        end

        -- Check for recent rule violations
        local warnings = hook.Run("GetWarnings", char:getID())
        local recentWarnings = 0
        for _, warn in ipairs(warnings or {}) do
            if os.time() - warn.timestamp < 86400 then -- Last 24 hours
                recentWarnings = recentWarnings + 1
            end
        end

        if recentWarnings >= 3 then
            client:notify("You have too many recent warnings to earn salary!")
            return false
        end

        return true
    end)
    ```
]]
function CanPlayerEquipItem(client, item)
end

--[[
    Purpose:
        Determines whether a player is allowed to equip an item

    When Called:
        When a player attempts to equip an item from their inventory

    Parameters:
        - client (Player): The player attempting to equip the item
        - item (Item): The item being equipped

    Returns:
        boolean - True if the player can equip the item, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent equipping certain items
    hook.Add("CanPlayerEquipItem", "NoHeavyArmor", function(client, item)
        if item.uniqueID == "heavy_armor" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Class-based equipment restrictions
    hook.Add("CanPlayerEquipItem", "ClassEquipment", function(client, item)
        local char = client:getChar()
        if not char then return false end

        local class = lia.class.list[char:getClass()]
        if class and class.restrictedItems and table.HasValue(class.restrictedItems, item.uniqueID) then
            client:notify("Your class cannot equip this item!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced equipment validation with multiple checks
    hook.Add("CanPlayerEquipItem", "AdvancedEquipment", function(client, item)
        local char = client:getChar()
        if not char then return false end

        -- Check if item requires specific attributes
        if item.attribRequired then
            for attrib, required in pairs(item.attribRequired) do
                local current = char:getAttrib(attrib, 0)
                if current < required then
                    client:notify("You need " .. required .. " " .. attrib .. " to equip this item!")
                    return false
                end
            end
        end

        -- Check equipment slots and conflicts
        if item.slot then
            local inventory = char:getInv()
            for _, otherItem in pairs(inventory:getItems()) do
                if otherItem:getData("equip") and otherItem.slot == item.slot and otherItem.id ~= item.id then
                    client:notify("You already have an item equipped in that slot!")
                    return false
                end
            end
        end

        -- Check durability
        if item:getData("durability", 100) < 20 then
            client:notify("This item is too damaged to equip!")
            return false
        end

        -- Log equipment attempt
        lia.log.add(client, "item_equip_attempt", item.uniqueID)

        return true
    end)
    ```
]]
function CanPlayerHoldObject(client, entity)
end

--[[
    Purpose:
        Determines whether a player can hold/pick up a physics object

    When Called:
        When a player attempts to grab or hold a physics entity

    Parameters:
        - client (Player): The player attempting to hold the object
        - entity (Entity): The entity being held

    Returns:
        boolean - True if the player can hold the object, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent holding specific entities
    hook.Add("CanPlayerHoldObject", "NoHeavyItems", function(client, entity)
        if entity:GetClass() == "prop_physics" then
            local mass = entity:GetPhysicsObject():GetMass()
            if mass > 100 then
                return false
            end
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Strength-based holding restrictions
    hook.Add("CanPlayerHoldObject", "StrengthBasedHolding", function(client, entity)
        local char = client:getChar()
        if not char then return false end

        local strength = char:getAttrib("str", 0)
        local mass = entity:GetPhysicsObject():GetMass()

        -- Can hold objects up to strength * 10 kg
        if mass > strength * 10 then
            client:notify("This object is too heavy for you to hold!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced holding validation with multiple checks
    hook.Add("CanPlayerHoldObject", "AdvancedHolding", function(client, entity)
        local char = client:getChar()
        if not char then return false end

        -- Check if player is restrained
        if char:getData("restrained", false) then
            client:notify("You cannot hold objects while restrained!")
            return false
        end

        -- Check entity class restrictions
        local allowedClasses = {
            ["prop_physics"] = true,
            ["prop_physics_override"] = true,
            ["prop_ragdoll"] = true
        }

        if not allowedClasses[entity:GetClass()] and not entity.Holdable then
            return false
        end

        -- Check weight based on strength
        local strength = char:getAttrib("str", 0)
        local mass = entity:GetPhysicsObject():GetMass()
        local maxWeight = strength * 15

        if mass > maxWeight then
            client:notify(string.format("This object (%.1fkg) is too heavy! You can hold up to %.1fkg.", mass, maxWeight))
            return false
        end

        -- Check for entity ownership
        if entity:GetCreator() and entity:GetCreator() ~= client then
            local owner = entity:GetCreator()
            if IsValid(owner) and owner:IsPlayer() then
                client:notify("You cannot hold someone else's object!")
                return false
            end
        end

        -- Prevent holding during combat
        if client:GetNWBool("InCombat", false) then
            client:notify("You cannot hold objects while in combat!")
            return false
        end

        return true
    end)
    ```
]]
function CanPlayerInteractItem(client, action, self, data)
end

--[[
    Purpose:
        Determines whether a player can interact with an item using a specific action

    When Called:
        When a player attempts to perform an action on an item (use, drop, take, equip, etc.)

    Parameters:
        - client (Player): The player attempting the interaction
        - action (string): The action being performed (e.g., "use", "drop", "take", "equip")
        - self (Item): The item being interacted with
        - data (table): Additional data for the interaction

    Returns:
        boolean - True if the interaction is allowed, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent using certain items
    hook.Add("CanPlayerInteractItem", "RestrictedItems", function(client, action, self, data)
        if action == "use" and self.uniqueID == "admin_key" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Action-based restrictions
    hook.Add("CanPlayerInteractItem", "ActionRestrictions", function(client, action, self, data)
        local char = client:getChar()
        if not char then return false end

        -- Prevent dropping quest items
        if action == "drop" and self:getData("questItem") then
            client:notify("You cannot drop quest items!")
            return false
        end

        -- Require specific flags for certain items
        if action == "use" and self.flag and not char:hasFlags(self.flag) then
            client:notify("You don't have permission to use this item!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive interaction validation
    hook.Add("CanPlayerInteractItem", "AdvancedInteraction", function(client, action, self, data)
        local char = client:getChar()
        if not char then return false end

        -- Check if player is restrained
        if char:getData("restrained", false) and action ~= "view" then
            client:notify("You cannot interact with items while restrained!")
            return false
        end

        -- Check item durability for certain actions
        if action == "use" then
            local durability = self:getData("durability", 100)
            if durability <= 0 then
                client:notify("This item is broken and cannot be used!")
                return false
            end
        end

        -- Check for action cooldowns
        local cooldownKey = "item_action_" .. self:getID() .. "_" .. action
        local lastAction = client:getLiliaData(cooldownKey, 0)
        local cooldown = self.actionCooldown or 1

        if CurTime() - lastAction < cooldown then
            client:notify("Please wait before using this item again!")
            return false
        end

        -- Log item interactions for important items
        if self:getData("trackUsage", false) then
            lia.log.add(client, "item_interaction", self.uniqueID, action)
        end

        return true
    end)
    ```
]]
function CanPlayerJoinClass(client, class, info)
end

--[[
    Purpose:
        Determines whether a player can join a specific class

    When Called:
        When a player attempts to join or switch to a class

    Parameters:
        - client (Player): The player attempting to join the class
        - class (table): The class data table
        - info (table): Additional information about the join request

    Returns:
        boolean - True if the player can join the class, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent joining certain classes
    hook.Add("CanPlayerJoinClass", "RestrictedClasses", function(client, class, info)
        if class.uniqueID == "admin_class" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Level-based class restrictions
    hook.Add("CanPlayerJoinClass", "LevelRequirements", function(client, class, info)
        local char = client:getChar()
        if not char then return false end

        local level = char:getAttrib("level", 1)
        local requiredLevel = class.minLevel or 0

        if level < requiredLevel then
            client:notify("You need to be level " .. requiredLevel .. " to join this class!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex class join validation
    hook.Add("CanPlayerJoinClass", "AdvancedClassJoin", function(client, class, info)
        local char = client:getChar()
        if not char then return false end

        -- Check class capacity
        local classCount = lia.db.selectOne({"COUNT(*) as count"}, "characters", "class = " .. lia.db.convertDataType(class.index))
        if classCount and classCount.count >= (class.maxMembers or 999) then
            client:notify("This class is at maximum capacity!")
            return false
        end

        -- Check level requirements
        local level = char:getAttrib("level", 1)
        if class.minLevel and level < class.minLevel then
            client:notify("You need to be level " .. class.minLevel .. " to join this class!")
            return false
        end

        -- Check if player has required flags
        if class.requiredFlags and not client:hasFlags(class.requiredFlags) then
            client:notify("You don't have the required permissions for this class!")
            return false
        end

        -- Check for blacklist
        local steamID = client:SteamID()
        if class.blacklist and table.HasValue(class.blacklist, steamID) then
            client:notify("You are blacklisted from this class!")
            return false
        end

        -- Check cooldown between class changes
        local lastClassChange = char:getData("lastClassChange", 0)
        local cooldown = 86400 -- 24 hours
        if os.time() - lastClassChange < cooldown then
            local remaining = cooldown - (os.time() - lastClassChange)
            client:notify("You must wait " .. math.floor(remaining / 3600) .. " hours before changing classes again!")
            return false
        end

        return true
    end)
    ```
]]
function CanPlayerKnock(client)
end

--[[
    Purpose:
        Determines whether a player can knock on a door or surface

    When Called:
        When a player attempts to knock on a door or surface

    Parameters:
        - client (Player): The player attempting to knock

    Returns:
        boolean - True if the player can knock, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent knocking in certain areas
    hook.Add("CanPlayerKnock", "RestrictedZones", function(client)
        local zone = client:GetNWString("CurrentZone", "")
        if zone == "quiet_zone" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Cooldown-based knocking
    hook.Add("CanPlayerKnock", "KnockCooldown", function(client)
        local lastKnock = client:getLiliaData("lastKnockTime", 0)
        local cooldown = 2 -- 2 seconds between knocks

        if CurTime() - lastKnock < cooldown then
            client:notify("Please wait before knocking again!")
            return false
        end

        client:setLiliaData("lastKnockTime", CurTime())
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced knock validation with restrictions
    hook.Add("CanPlayerKnock", "AdvancedKnock", function(client)
        local char = client:getChar()
        if not char then return false end

        -- Check if player is restrained
        if char:getData("restrained", false) then
            client:notify("You cannot knock while restrained!")
            return false
        end

        -- Check for cooldown
        local lastKnock = client:getLiliaData("lastKnockTime", 0)
        local cooldown = 2
        if CurTime() - lastKnock < cooldown then
            return false
        end

        -- Check if player is near a door
        local trace = client:GetEyeTrace()
        if not IsValid(trace.Entity) or not trace.Entity:GetClass():find("door") then
            client:notify("You must be looking at a door to knock!")
            return false
        end

        -- Check distance to door
        if trace.HitPos:Distance(client:GetPos()) > 150 then
            client:notify("You are too far from the door!")
            return false
        end

        -- Update knock time
        client:setLiliaData("lastKnockTime", CurTime())

        return true
    end)
    ```
]]
function CanPlayerLock(client, door)
end

--[[
    Purpose:
        Determines whether a player can lock a door

    When Called:
        When a player attempts to lock a door with a key

    Parameters:
        - client (Player): The player attempting to lock the door
        - door (Entity): The door entity being locked

    Returns:
        boolean - True if the player can lock the door, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Check door ownership
    hook.Add("CanPlayerLock", "DoorOwnership", function(client, door)
        if door:getNetVar("owner") ~= client:SteamID() then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Key-based locking
    hook.Add("CanPlayerLock", "KeyRequired", function(client, door)
        local char = client:getChar()
        if not char then return false end

        local inventory = char:getInv()
        local doorID = door:getNetVar("doorID", 0)
        
        -- Check if player has a key for this door
        for _, item in pairs(inventory:getItems()) do
            if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                return true
            end
        end

        client:notify("You need a key to lock this door!")
        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door locking with multiple checks
    hook.Add("CanPlayerLock", "AdvancedDoorLock", function(client, door)
        local char = client:getChar()
        if not char then return false end

        -- Check door ownership
        local owner = door:getNetVar("owner")
        if owner and owner ~= client:SteamID() then
            -- Check if player has admin override
            if not client:IsAdmin() then
                client:notify("You don't own this door!")
                return false
            end
        end

        -- Check if door is already locked
        if door:getNetVar("locked", false) then
            client:notify("This door is already locked!")
            return false
        end

        -- Check for required key
        local doorID = door:getNetVar("doorID", 0)
        local inventory = char:getInv()
        local hasKey = false

        for _, item in pairs(inventory:getItems()) do
            if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                hasKey = true
                break
            end
        end

        if not hasKey and not client:IsAdmin() then
            client:notify("You need a key to lock this door!")
            return false
        end

        -- Check if door is in a restricted area
        local doorPos = door:GetPos()
        if doorPos:Distance(Vector(0, 0, 0)) < 100 then -- Example: near spawn
            client:notify("You cannot lock doors in this area!")
            return false
        end

        return true
    end)
    ```
]]
function CanPlayerModifyConfig(client, key)
end

--[[
    Purpose:
        Determines whether a player can modify a server configuration setting

    When Called:
        When a player attempts to change a configuration setting through admin commands or UI

    Parameters:
        - client (Player): The player attempting to modify the config
        - key (string): The configuration key being modified

    Returns:
        boolean - True if the player can modify the config, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Restrict certain config keys
    hook.Add("CanPlayerModifyConfig", "RestrictedKeys", function(client, key)
        local restricted = {"DatabaseHost", "DatabaseUser", "DatabasePassword"}
        if table.HasValue(restricted, key) then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Admin-only config modifications
    hook.Add("CanPlayerModifyConfig", "AdminOnly", function(client, key)
        -- Allow admins to modify any config
        if client:IsAdmin() then
            return true
        end

        -- Allow moderators to modify certain configs
        if client:hasPrivilege("modifyConfig") then
            local allowedKeys = {"WalkSpeed", "RunSpeed", "ChatRange"}
            if table.HasValue(allowedKeys, key) then
                return true
            end
        end

        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced config modification with validation
    hook.Add("CanPlayerModifyConfig", "AdvancedConfig", function(client, key)
        -- Check admin status
        if not client:IsAdmin() and not client:hasPrivilege("modifyConfig") then
            client:notify("You don't have permission to modify configurations!")
            return false
        end

        -- Define config categories and required permissions
        local configCategories = {
            ["database"] = {"DatabaseHost", "DatabaseUser", "DatabasePassword", "DatabaseName"},
            ["server"] = {"ServerName", "ServerDesc", "MaxPlayers"},
            ["gameplay"] = {"WalkSpeed", "RunSpeed", "JumpPower", "ChatRange"},
            ["economy"] = {"StartingMoney", "SalaryInterval", "SalaryAmount"}
        }

        -- Check category-based permissions
        for category, keys in pairs(configCategories) do
            if table.HasValue(keys, key) then
                local requiredPerm = "modifyConfig_" .. category
                if not client:hasPrivilege(requiredPerm) then
                    client:notify("You don't have permission to modify " .. category .. " configurations!")
                    return false
                end
            end
        end

        -- Log config modifications
        lia.log.add(client, "config_modified", key)

        return true
    end)
    ```
]]
function CanPlayerOpenScoreboard(client)
end

--[[
    Purpose:
        Determines whether a player can open the scoreboard

    When Called:
        When a player presses the scoreboard key (typically Tab)

    Parameters:
        - client (Player): The player attempting to open the scoreboard

    Returns:
        boolean - True if the player can open the scoreboard, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Always allow scoreboard
    hook.Add("CanPlayerOpenScoreboard", "AlwaysAllow", function(client)
        return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Disable scoreboard in certain areas
    hook.Add("CanPlayerOpenScoreboard", "RestrictedZones", function(client)
        local zone = client:GetNWString("CurrentZone", "")
        if zone == "combat_zone" then
            client:notify("Scoreboard is disabled in combat zones!")
            return false
        end
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced scoreboard access control
    hook.Add("CanPlayerOpenScoreboard", "AdvancedScoreboard", function(client)
        -- Prevent opening during important events
        if GetGlobalBool("ImportantEvent", false) then
            client:notify("Scoreboard is temporarily disabled during events!")
            return false
        end

        -- Check if player is in spectator mode
        if client:GetObserverMode() ~= OBS_MODE_NONE then
            return true -- Allow spectators to see scoreboard
        end

        -- Rate limiting - prevent spam
        local lastOpen = client:getLiliaData("lastScoreboardOpen", 0)
        if CurTime() - lastOpen < 0.5 then
            return false
        end

        client:setLiliaData("lastScoreboardOpen", CurTime())
        return true
    end)
    ```
]]
function CanPlayerRotateItem(client, item)
end

--[[
    Purpose:
        Determines whether a player can rotate an item in their inventory

    When Called:
        When a player attempts to rotate an item in their inventory grid

    Parameters:
        - client (Player): The player attempting to rotate the item
        - item (Item): The item being rotated

    Returns:
        boolean - True if the player can rotate the item, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Always allow rotation
    hook.Add("CanPlayerRotateItem", "AlwaysAllow", function(client, item)
        return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Prevent rotating certain items
    hook.Add("CanPlayerRotateItem", "NoRotateRestrictions", function(client, item)
        if item:getData("noRotate", false) then
            client:notify("This item cannot be rotated!")
            return false
        end
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced rotation validation
    hook.Add("CanPlayerRotateItem", "AdvancedRotate", function(client, item)
        local char = client:getChar()
        if not char then return false end

        -- Check if item is equipped
        if item:getData("equip", false) then
            client:notify("You cannot rotate equipped items!")
            return false
        end

        -- Check if item is in a bag
        local inventory = lia.inventory.instances[item.invID]
        if inventory and inventory.isBag then
            -- Allow rotation in bags unless restricted
            if item:getData("noRotateInBags", false) then
                return false
            end
        end

        -- Check rotation cooldown
        local lastRotate = client:getLiliaData("lastItemRotate", 0)
        if CurTime() - lastRotate < 0.5 then
            return false
        end

        client:setLiliaData("lastItemRotate", CurTime())
        return true
    end)
    ```
]]
function CanPlayerSeeLogCategory(client, k)
end

--[[
    Purpose:
        Determines whether a player can view a specific log category

    When Called:
        When checking if a player has permission to view a log category in the admin panel

    Parameters:
        - client (Player): The player requesting to see the log category
        - k (string): The log category key/name

    Returns:
        boolean - True if the player can see the log category, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Restrict certain log categories
    hook.Add("CanPlayerSeeLogCategory", "RestrictedCategories", function(client, k)
        local restricted = {"admin_actions", "ban_logs", "warn_logs"}
        if table.HasValue(restricted, k) and not client:IsAdmin() then
            return false
        end
        return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Permission-based log viewing
    hook.Add("CanPlayerSeeLogCategory", "PermissionBased", function(client, k)
        -- Admins can see all logs
        if client:IsAdmin() then
            return true
        end

        -- Check for specific permissions
        local logPermissions = {
            ["chat_logs"] = "canSeeChatLogs",
            ["money_logs"] = "canSeeMoneyLogs",
            ["item_logs"] = "canSeeItemLogs",
            ["admin_actions"] = "canSeeAdminLogs"
        }

        local requiredPerm = logPermissions[k]
        if requiredPerm then
            return client:hasPrivilege(requiredPerm)
        end

        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced log category access control
    hook.Add("CanPlayerSeeLogCategory", "AdvancedLogAccess", function(client, k)
        -- Define log categories and their access levels
        local logCategories = {
            ["public"] = {"public_chat", "player_joins", "player_leaves"},
            ["moderator"] = {"warn_logs", "kick_logs", "money_logs"},
            ["admin"] = {"admin_actions", "ban_logs", "config_changes"},
            ["superadmin"] = {"database_logs", "server_logs", "error_logs"}
        }

        -- Check category access
        for accessLevel, categories in pairs(logCategories) do
            if table.HasValue(categories, k) then
                -- Check if player has required access level
                if accessLevel == "public" then
                    return true
                elseif accessLevel == "moderator" then
                    return client:hasPrivilege("canSeeModLogs") or client:IsAdmin()
                elseif accessLevel == "admin" then
                    return client:IsAdmin()
                elseif accessLevel == "superadmin" then
                    return client:IsSuperAdmin()
                end
            end
        end

        -- Log access attempts for security
        lia.log.add(client, "log_access_attempt", k)

        return false
    end)
    ```
]]
function CanPlayerSpawnStorage(client, entity, info)
end

--[[
    Purpose:
        Determines whether a player can spawn a storage entity

    When Called:
        When a player attempts to spawn a storage container (like a crate or safe)

    Parameters:
        - client (Player): The player attempting to spawn storage
        - entity (Entity): The storage entity being spawned
        - info (table): Additional information about the spawn

    Returns:
        boolean - True if the player can spawn the storage, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Admin-only storage spawning
    hook.Add("CanPlayerSpawnStorage", "AdminOnly", function(client, entity, info)
        if not client:IsAdmin() then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Limit storage per player
    hook.Add("CanPlayerSpawnStorage", "StorageLimit", function(client, entity, info)
        local char = client:getChar()
        if not char then return false end

        -- Count existing storage entities owned by player
        local storageCount = 0
        for _, ent in ipairs(ents.FindByClass("lia_storage")) do
            if ent:GetCreator() == client then
                storageCount = storageCount + 1
            end
        end

        local maxStorage = 3
        if storageCount >= maxStorage then
            client:notify("You can only have " .. maxStorage .. " storage containers!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced storage spawning validation
    hook.Add("CanPlayerSpawnStorage", "AdvancedStorage", function(client, entity, info)
        local char = client:getChar()
        if not char then return false end

        -- Check if player has required privilege
        if not client:hasPrivilege("canSpawnStorage") and not client:IsAdmin() then
            client:notify("You don't have permission to spawn storage!")
            return false
        end

        -- Check storage limits per character
        local storageCount = 0
        for _, ent in ipairs(ents.FindByClass("lia_storage")) do
            if ent:GetCreator() == client and ent.liaCharID == char:getID() then
                storageCount = storageCount + 1
            end
        end

        local maxStorage = char:getData("maxStorage", 5)
        if storageCount >= maxStorage then
            client:notify("You have reached your storage limit!")
            return false
        end

        -- Check spawn location restrictions
        local spawnPos = entity:GetPos()
        if spawnPos:Distance(Vector(0, 0, 0)) < 500 then
            client:notify("You cannot spawn storage near spawn point!")
            return false
        end

        -- Check for nearby storage (prevent spam)
        for _, ent in ipairs(ents.FindByClass("lia_storage")) do
            if ent:GetPos():Distance(spawnPos) < 200 then
                client:notify("There is already a storage container nearby!")
                return false
            end
        end

        return true
    end)
    ```
]]
function CanPlayerSwitchChar(client, currentChar, character)
end

--[[
    Purpose:
        Determines whether a player can switch between characters

    When Called:
        When a player attempts to switch from one character to another

    Parameters:
        - client (Player): The player attempting to switch characters
        - currentChar (Character): The character the player is currently using
        - character (Character): The character the player wants to switch to

    Returns:
        boolean - True if the player can switch to the character, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent switching during combat
    hook.Add("CanPlayerSwitchChar", "NoCombatSwitch", function(client, currentChar, character)
        if client:GetNWBool("InCombat", false) then
            client:notify("You cannot switch characters while in combat!")
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Cooldown between character switches
    hook.Add("CanPlayerSwitchChar", "SwitchCooldown", function(client, currentChar, character)
        local lastSwitch = client:getLiliaData("lastCharSwitch", 0)
        local cooldown = 300 -- 5 minutes

        if os.time() - lastSwitch < cooldown then
            local remaining = cooldown - (os.time() - lastSwitch)
            client:notify("You must wait " .. math.floor(remaining / 60) .. " minutes before switching characters again!")
            return false
        end

        client:setLiliaData("lastCharSwitch", os.time())
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character switching validation
    hook.Add("CanPlayerSwitchChar", "AdvancedCharSwitch", function(client, currentChar, character)
        -- Prevent switching during important events
        if GetGlobalBool("ImportantEvent", false) then
            client:notify("Character switching is disabled during events!")
            return false
        end

        -- Check combat status
        if client:GetNWBool("InCombat", false) then
            client:notify("You cannot switch characters while in combat!")
            return false
        end

        -- Check if player is restrained
        if currentChar and currentChar:getData("restrained", false) then
            client:notify("You cannot switch characters while restrained!")
            return false
        end

        -- Check cooldown
        local lastSwitch = client:getLiliaData("lastCharSwitch", 0)
        local cooldown = 300
        if os.time() - lastSwitch < cooldown then
            return false
        end

        -- Check if target character is available
        if character:getData("inUse", false) then
            client:notify("This character is currently unavailable!")
            return false
        end

        -- Update switch time
        client:setLiliaData("lastCharSwitch", os.time())

        return true
    end)
    ```
]]
function CanPlayerTakeItem(client, item)
end

--[[
    Purpose:
        Determines whether a player is allowed to take an item

    When Called:
        When a player attempts to take an item from a container, ground, or other inventory

    Parameters:
        - client (Player): The player attempting to take the item
        - item (Item): The item being taken

    Returns:
        boolean - True if the player can take the item, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent taking restricted items
    hook.Add("CanPlayerTakeItem", "RestrictedItems", function(client, item)
        if item.uniqueID == "admin_key" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Level requirement checks
    hook.Add("CanPlayerTakeItem", "LevelRequirements", function(client, item)
        local char = client:getChar()
        if not char then return false end

        local requiredLevel = item.level or 0
        local playerLevel = char:getAttrib("level", 1)

        if playerLevel < requiredLevel then
            client:notify("You need to be level " .. requiredLevel .. " to take this item!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex validation with multiple checks
    hook.Add("CanPlayerTakeItem", "AdvancedItemValidation", function(client, item)
        local char = client:getChar()
        if not char then return false end

        -- Check faction restrictions
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.restrictedItems and table.HasValue(faction.restrictedItems, item.uniqueID) then
            client:notify("Your faction prohibits taking this item!")
            return false
        end

        -- Check character flags
        if item.flag and not char:hasFlags(item.flag) then
            client:notify("You don't have the required permission to take this item!")
            return false
        end

        -- Check weight limits
        local currentWeight = char:getInv():getWeight()
        local itemWeight = item.weight or 0
        local maxWeight = char:getMaxWeight()

        if currentWeight + itemWeight > maxWeight then
            client:notify("This item would make your inventory too heavy!")
            return false
        end

        -- Check if item is bound to another character
        if item:getData("boundTo") and item:getData("boundTo") ~= char:getID() then
            client:notify("This item is bound to another character!")
            return false
        end

        -- Log the take attempt
        lia.log.add(client, "item_take_attempt", item.uniqueID, item:getID())

        return true
    end)
    ```
]]
function CanPlayerThrowPunch(client)
end

--[[
    Purpose:
        Determines whether a player can throw a punch

    When Called:
        When a player attempts to punch another player or entity

    Parameters:
        - client (Player): The player attempting to throw a punch

    Returns:
        boolean - True if the player can throw a punch, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent punching in safe zones
    hook.Add("CanPlayerThrowPunch", "NoPunchInSafeZones", function(client)
        local zone = client:GetNWString("CurrentZone", "")
        if zone == "safe_zone" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Cooldown-based punching
    hook.Add("CanPlayerThrowPunch", "PunchCooldown", function(client)
        local lastPunch = client:getLiliaData("lastPunchTime", 0)
        local cooldown = 1 -- 1 second between punches

        if CurTime() - lastPunch < cooldown then
            return false
        end

        client:setLiliaData("lastPunchTime", CurTime())
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced punch validation
    hook.Add("CanPlayerThrowPunch", "AdvancedPunch", function(client)
        local char = client:getChar()
        if not char then return false end

        -- Check if player is restrained
        if char:getData("restrained", false) then
            client:notify("You cannot punch while restrained!")
            return false
        end

        -- Check stamina
        local stamina = char:getAttrib("stamina", 100)
        if stamina < 20 then
            client:notify("You are too tired to punch!")
            return false
        end

        -- Check cooldown
        local lastPunch = client:getLiliaData("lastPunchTime", 0)
        if CurTime() - lastPunch < 1 then
            return false
        end

        -- Check if in safe zone
        local zone = client:GetNWString("CurrentZone", "")
        if zone == "safe_zone" then
            client:notify("Punching is not allowed in safe zones!")
            return false
        end

        -- Drain stamina
        char:setAttrib("stamina", math.max(stamina - 5, 0))

        client:setLiliaData("lastPunchTime", CurTime())
        return true
    end)
    ```
]]
function CanPlayerTradeWithVendor(client, vendor, itemType, isSellingToVendor)
end

--[[
    Purpose:
        Determines whether a player can trade with a vendor (buying or selling items)

    When Called:
        When a player attempts to buy from or sell to a vendor

    Parameters:
        - client (Player): The player attempting to trade
        - vendor (Entity): The vendor entity
        - itemType (table): The item type being traded
        - isSellingToVendor (boolean): True if selling to vendor, false if buying

    Returns:
        boolean - True if the trade is allowed, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Restrict certain items
    hook.Add("CanPlayerTradeWithVendor", "RestrictedItems", function(client, vendor, itemType, isSellingToVendor)
        if itemType.uniqueID == "illegal_item" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based vendor access
    hook.Add("CanPlayerTradeWithVendor", "FactionVendor", function(client, vendor, itemType, isSellingToVendor)
        local char = client:getChar()
        if not char then return false end

        local vendorFaction = vendor:getNetVar("faction", "")
        local playerFaction = char:getFaction()

        if vendorFaction ~= "" and vendorFaction ~= playerFaction then
            client:notify("This vendor only serves " .. vendorFaction .. " members!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced vendor trading validation
    hook.Add("CanPlayerTradeWithVendor", "AdvancedVendorTrade", function(client, vendor, itemType, isSellingToVendor)
        local char = client:getChar()
        if not char then return false end

        -- Check if vendor is active
        if vendor:getNetVar("disabled", false) then
            client:notify("This vendor is currently disabled!")
            return false
        end

        -- Check distance to vendor
        if client:GetPos():Distance(vendor:GetPos()) > 150 then
            client:notify("You are too far from the vendor!")
            return false
        end

        -- Faction restrictions
        local vendorFaction = vendor:getNetVar("faction", "")
        if vendorFaction ~= "" then
            local playerFaction = char:getFaction()
            if vendorFaction ~= playerFaction then
                -- Check for special access
                if not char:hasFlags("V") then
                    client:notify("You don't have access to this faction vendor!")
                    return false
                end
            end
        end

        -- Check if trading is restricted during events
        if GetGlobalBool("TradingDisabled", false) then
            client:notify("Trading is temporarily disabled!")
            return false
        end

        -- Anti-cheat: Check transaction limits
        local dailyTrades = char:getData("dailyVendorTrades", 0)
        local maxTrades = 100
        if dailyTrades >= maxTrades then
            client:notify("You have reached your daily trading limit!")
            return false
        end

        return true
    end)
    ```
]]
function CanPlayerUnequipItem(client, item)
end

--[[
    Purpose:
        Determines whether a player is allowed to unequip an item

    When Called:
        When a player attempts to unequip an item they currently have equipped

    Parameters:
        - client (Player): The player attempting to unequip the item
        - item (Item): The item being unequipped

    Returns:
        boolean - True if the player can unequip the item, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent unequipping certain items
    hook.Add("CanPlayerUnequipItem", "NoUnequipBadge", function(client, item)
        if item.uniqueID == "police_badge" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Combat restrictions on unequipping
    hook.Add("CanPlayerUnequipItem", "CombatUnequip", function(client, item)
        if client:GetNWBool("InCombat", false) and item.isWeapon then
            client:notify("You cannot unequip weapons while in combat!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex unequipping validation with multiple conditions
    hook.Add("CanPlayerUnequipItem", "AdvancedUnequip", function(client, item)
        local char = client:getChar()
        if not char then return false end

        -- Check if item is cursed or bound
        if item:getData("cursed") then
            client:notify("This item is cursed and cannot be unequipped!")
            return false
        end

        -- Check combat status
        if client:GetNWBool("InCombat", false) then
            if item.isWeapon or item.isArmor then
                client:notify("You cannot unequip this item while in combat!")
                return false
            end
        end

        -- Check if unequipping would leave player vulnerable
        if item.isArmor then
            local totalArmor = 0
            local inventory = char:getInv()
            for _, otherItem in pairs(inventory:getItems()) do
                if otherItem:getData("equip") and otherItem.isArmor and otherItem.id ~= item.id then
                    totalArmor = totalArmor + (otherItem.armorValue or 0)
                end
            end

            if totalArmor < 50 then
                client:notify("Unequipping this would leave you too vulnerable!")
                return false
            end
        end

        -- Check cooldown timers
        local unequipTime = item:getData("lastUnequipTime", 0)
        if CurTime() - unequipTime < 5 then
            client:notify("Please wait before unequipping this item again!")
            return false
        end

        -- Update unequip timestamp
        item:setData("lastUnequipTime", CurTime())

        return true
    end)
    ```
]]
function CanPlayerUnlock(client, door)
end

--[[
    Purpose:
        Determines whether a player can unlock a door

    When Called:
        When a player attempts to unlock a door with a key

    Parameters:
        - client (Player): The player attempting to unlock the door
        - door (Entity): The door entity being unlocked

    Returns:
        boolean - True if the player can unlock the door, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Check door ownership
    hook.Add("CanPlayerUnlock", "DoorOwnership", function(client, door)
        if door:getNetVar("owner") ~= client:SteamID() then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Key-based unlocking
    hook.Add("CanPlayerUnlock", "KeyRequired", function(client, door)
        local char = client:getChar()
        if not char then return false end

        local inventory = char:getInv()
        local doorID = door:getNetVar("doorID", 0)
        
        -- Check if player has a key for this door
        for _, item in pairs(inventory:getItems()) do
            if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                return true
            end
        end

        client:notify("You need a key to unlock this door!")
        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door unlocking with multiple checks
    hook.Add("CanPlayerUnlock", "AdvancedDoorUnlock", function(client, door)
        local char = client:getChar()
        if not char then return false end

        -- Check if door is locked
        if not door:getNetVar("locked", false) then
            client:notify("This door is already unlocked!")
            return false
        end

        -- Check door ownership
        local owner = door:getNetVar("owner")
        if owner and owner ~= client:SteamID() then
            -- Check if player has admin override
            if not client:IsAdmin() then
                -- Check for key
                local doorID = door:getNetVar("doorID", 0)
                local inventory = char:getInv()
                local hasKey = false

                for _, item in pairs(inventory:getItems()) do
                    if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                        hasKey = true
                        break
                    end
                end

                if not hasKey then
                    client:notify("You don't have a key for this door!")
                    return false
                end
            end
        end

        -- Check if door has security system
        if door:getNetVar("hasAlarm", false) then
            local alarmCode = door:getNetVar("alarmCode", "")
            local enteredCode = client:getLiliaData("enteredAlarmCode", "")
            
            if alarmCode ~= "" and enteredCode ~= alarmCode then
                client:notify("Incorrect security code!")
                hook.Run("OnAlarmTriggered", door, client)
                return false
            end
        end

        return true
    end)
    ```
]]
function CanPlayerUseChar(client, character)
end

--[[
    Purpose:
        Determines whether a player can use/select a character

    When Called:
        When a player attempts to select or load a character

    Parameters:
        - client (Player): The player attempting to use the character
        - character (Character): The character being used

    Returns:
        boolean - True if the player can use the character, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Check if character exists
    hook.Add("CanPlayerUseChar", "CharacterExists", function(client, character)
        if not character then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check for banned characters
    hook.Add("CanPlayerUseChar", "BannedCheck", function(client, character)
        if character:getData("banned", false) then
            client:notify("This character has been banned!")
            return false
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character usage validation
    hook.Add("CanPlayerUseChar", "AdvancedCharUse", function(client, character)
        -- Check if character exists
        if not character then
            return false
        end

        -- Check if character is banned
        if character:getData("banned", false) then
            client:notify("This character has been banned and cannot be used!")
            return false
        end

        -- Check if character is in use by another player
        if character:getData("inUse", false) then
            local usingPlayer = character:getData("usingPlayer")
            if IsValid(usingPlayer) and usingPlayer ~= client then
                client:notify("This character is currently in use!")
                return false
            end
        end

        -- Check cooldown between character uses
        local lastUse = client:getLiliaData("lastCharUse", {})
        local charID = character:getID()
        local lastUseTime = lastUse[charID] or 0
        local cooldown = 60 -- 1 minute cooldown

        if os.time() - lastUseTime < cooldown then
            local remaining = cooldown - (os.time() - lastUseTime)
            client:notify("Please wait " .. remaining .. " seconds before using this character again!")
            return false
        end

        -- Update use time
        lastUse[charID] = os.time()
        client:setLiliaData("lastCharUse", lastUse)

        return true
    end)
    ```
]]
function CanPlayerUseCommand(client, command)
end

--[[
    Purpose:
        Determines whether a player can use/execute a command

    When Called:
        When a player attempts to execute a chat command or console command

    Parameters:
        - client (Player): The player attempting to use the command
        - command (table): The command data table (contains name, arguments, etc.)

    Returns:
        boolean - True if the player can use the command, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Restrict certain commands
    hook.Add("CanPlayerUseCommand", "RestrictedCommands", function(client, command)
        local restricted = {"spawn", "give", "noclip"}
        if table.HasValue(restricted, command.name) and not client:IsAdmin() then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Command cooldowns
    hook.Add("CanPlayerUseCommand", "CommandCooldown", function(client, command)
        local cooldownKey = "command_" .. command.name
        local lastUse = client:getLiliaData(cooldownKey, 0)
        local cooldown = command.cooldown or 0

        if cooldown > 0 and CurTime() - lastUse < cooldown then
            client:notify("Please wait before using this command again!")
            return false
        end

        client:setLiliaData(cooldownKey, CurTime())
        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced command access control
    hook.Add("CanPlayerUseCommand", "AdvancedCommandAccess", function(client, command)
        -- Check if command exists
        local cmdData = lia.command.list[command.name]
        if not cmdData then
            return false
        end

        -- Check permission requirements
        if cmdData.superAdminOnly then
            if not client:IsSuperAdmin() then
                client:notify("This command requires superadmin privileges!")
                return false
            end
        elseif cmdData.adminOnly then
            if not client:IsAdmin() then
                client:notify("This command requires admin privileges!")
                return false
            end
        end

        -- Check custom privileges
        if cmdData.privilege then
            if not client:hasPrivilege(cmdData.privilege) then
                client:notify("You don't have permission to use this command!")
                return false
            end
        end

        -- Check cooldown
        local cooldownKey = "cmd_" .. command.name
        local lastUse = client:getLiliaData(cooldownKey, 0)
        local cooldown = cmdData.cooldown or 0

        if cooldown > 0 and CurTime() - lastUse < cooldown then
            local remaining = math.ceil(cooldown - (CurTime() - lastUse))
            client:notify("Please wait " .. remaining .. " seconds before using this command again!")
            return false
        end

        -- Log command usage
        lia.log.add(client, "command_used", command.name, command.arguments)

        -- Update cooldown
        if cooldown > 0 then
            client:setLiliaData(cooldownKey, CurTime())
        end

        return true
    end)
    ```
]]
function CanPlayerUseDoor(client, door)
end

--[[
    Purpose:
        Determines whether a player can use/open a door

    When Called:
        When a player attempts to open or use a door entity

    Parameters:
        - client (Player): The player attempting to use the door
        - door (Entity): The door entity being used

    Returns:
        boolean - True if the player can use the door, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Check if door is locked
    hook.Add("CanPlayerUseDoor", "LockedCheck", function(client, door)
        if door:getNetVar("locked", false) then
            client:notify("This door is locked!")
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Key-based door access
    hook.Add("CanPlayerUseDoor", "KeyAccess", function(client, door)
        if not door:getNetVar("locked", false) then
            return true
        end

        local char = client:getChar()
        if not char then return false end

        local doorID = door:getNetVar("doorID", 0)
        local inventory = char:getInv()
        
        for _, item in pairs(inventory:getItems()) do
            if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                return true
            end
        end

        client:notify("You need a key to open this door!")
        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door access validation
    hook.Add("CanPlayerUseDoor", "AdvancedDoorAccess", function(client, door)
        local char = client:getChar()
        if not char then return false end

        -- Check if door is locked
        if door:getNetVar("locked", false) then
            -- Check for key
            local doorID = door:getNetVar("doorID", 0)
            local inventory = char:getInv()
            local hasKey = false

            for _, item in pairs(inventory:getItems()) do
                if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                    hasKey = true
                    break
                end
            end

            if not hasKey then
                -- Check door ownership
                local owner = door:getNetVar("owner")
                if owner ~= client:SteamID() and not client:IsAdmin() then
                    client:notify("This door is locked!")
                    return false
                end
            end
        end

        -- Check faction restrictions
        local doorFaction = door:getNetVar("faction", "")
        if doorFaction ~= "" then
            local playerFaction = char:getFaction()
            if doorFaction ~= playerFaction then
                client:notify("This door is restricted to " .. doorFaction .. " members!")
                return false
            end
        end

        -- Check if door is jammed
        if door:getNetVar("jammed", false) then
            client:notify("This door appears to be jammed!")
            return false
        end

        return true
    end)
    ```
]]
function CanPlayerViewInventory()
end

--[[
    Purpose:
        Determines whether a player can view their inventory

    When Called:
        When a player attempts to open their inventory panel

    Parameters:
        None

    Returns:
        boolean - True if the player can view their inventory, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Always allow inventory viewing
    hook.Add("CanPlayerViewInventory", "AlwaysAllow", function()
        return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Disable inventory in combat
    hook.Add("CanPlayerViewInventory", "NoCombatInventory", function()
        -- This hook doesn't have client parameter, but you can check globally
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetNWBool("InCombat", false) then
                -- Prevent inventory opening during combat
                return false
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced inventory viewing restrictions
    hook.Add("CanPlayerViewInventory", "AdvancedInventory", function()
        -- Check global inventory toggle
        if GetGlobalBool("InventoryDisabled", false) then
            return false
        end

        -- Check server load
        local fps = 1 / RealFrameTime()
        if fps < 20 then
            -- Disable inventory viewing when server is struggling
            return false
        end

        return true
    end)
    ```
]]
function CanRunItemAction(itemTable, k)
end

--[[
    Purpose:
        Determines whether a specific item action can be executed

    When Called:
        When checking if an item's action method can be run

    Parameters:
        - itemTable (table): The item definition table
        - k (string): The action key/name being checked

    Returns:
        boolean - True if the action can be run, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Disable specific actions
    hook.Add("CanRunItemAction", "RestrictedActions", function(itemTable, k)
        local disabledActions = {"drop", "destroy"}
        if table.HasValue(disabledActions, k) and itemTable.uniqueID == "precious_item" then
            return false
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Action-based restrictions
    hook.Add("CanRunItemAction", "ActionRestrictions", function(itemTable, k)
        -- Prevent dropping quest items
        if k == "drop" and itemTable.isQuestItem then
            return false
        end

        -- Require special permission for certain actions
        if k == "use" and itemTable.requiresFlag then
            -- Note: This hook doesn't have client parameter
            -- You'd need to check this in the actual item action
            return true
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced action validation
    hook.Add("CanRunItemAction", "AdvancedAction", function(itemTable, k)
        -- Define action categories
        local dangerousActions = {"destroy", "use"}
        local restrictedActions = {"give", "drop"}

        -- Check if item is marked as restricted
        if itemTable.restricted then
            if table.HasValue(restrictedActions, k) then
                return false
            end
        end

        -- Check item durability for certain actions
        if table.HasValue(dangerousActions, k) then
            -- Actions that might damage the item
            if itemTable.isFragile then
                -- Fragile items might break
                return true -- Allow but log for monitoring
            end
        end

        -- Check cooldown system
        if itemTable.actionCooldowns and itemTable.actionCooldowns[k] then
            -- Cooldown would be checked in the actual action execution
            return true
        end

        return true
    end)
    ```
]]
function CanSaveData(ent, inventory)
end

--[[
    Purpose:
        Determines whether entity and inventory data can be saved to the database

    When Called:
        When the server attempts to save persistent entity and inventory data

    Parameters:
        - ent (Entity): The entity being saved
        - inventory (Inventory): The inventory instance being saved

    Returns:
        boolean - True if the data can be saved, false to prevent saving

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Prevent saving certain entities
    hook.Add("CanSaveData", "RestrictedEntities", function(ent, inventory)
        if IsValid(ent) and ent:GetClass() == "prop_physics" then
            return false -- Don't save physics props
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate data before saving
    hook.Add("CanSaveData", "DataValidation", function(ent, inventory)
        -- Check if entity is valid
        if not IsValid(ent) then
            return false
        end

        -- Check inventory size (prevent corrupted saves)
        if inventory then
            local itemCount = table.Count(inventory:getItems())
            if itemCount > 1000 then
                return false -- Suspicious item count
            end
        end

        return true
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced save validation
    hook.Add("CanSaveData", "AdvancedSave", function(ent, inventory)
        -- Validate entity
        if IsValid(ent) then
            -- Check entity class
            local allowedClasses = {"lia_storage", "lia_vendor", "lia_item"}
            if not table.HasValue(allowedClasses, ent:GetClass()) then
                -- Only save specific entity types
                return false
            end

            -- Check entity position validity
            local pos = ent:GetPos()
            if pos.x == 0 and pos.y == 0 and pos.z == 0 then
                return false -- Invalid position
            end
        end

        -- Validate inventory
        if inventory then
            -- Check for corrupted data
            local items = inventory:getItems()
            local itemCount = table.Count(items)
            
            if itemCount > 1000 then
                lia.log.add(nil, "save_blocked_large_inventory", itemCount)
                return false
            end

            -- Validate item data
            for _, item in pairs(items) do
                if not item.uniqueID or not lia.item.list[item.uniqueID] then
                    lia.log.add(nil, "save_blocked_invalid_item", item.uniqueID)
                    return false
                end
            end
        end

        return true
    end)
    ```
]]
function CharCleanUp(character)
end

--[[
    Purpose:
        Called when a character is being cleaned up and removed from memory

    When Called:
        When a character is unloaded or deleted and needs cleanup operations

    Parameters:
        - character (Character): The character being cleaned up

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character cleanup
    hook.Add("CharCleanUp", "LogCleanup", function(character)
        print("Cleaning up character: " .. character:getName())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clean up custom data
    hook.Add("CharCleanUp", "CustomDataCleanup", function(character)
        -- Remove temporary data
        character:setData("tempData", nil)
        character:setData("sessionData", nil)
        
        -- Save final statistics
        local playtime = character:getPlayTime() or 0
        lia.log.add(nil, "char_cleanup", character:getID(), playtime)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive character cleanup
    hook.Add("CharCleanUp", "AdvancedCleanup", function(character)
        -- Save final statistics
        local stats = {
            playtime = character:getPlayTime() or 0,
            money = character:getMoney() or 0,
            lastSeen = os.time()
        }

        -- Store in database for analytics
        lia.db.updateTable(stats, nil, "characters", "id = " .. character:getID())

        -- Clean up inventory references
        local inventory = character:getInv()
        if inventory then
            -- Remove temporary item data
            for _, item in pairs(inventory:getItems()) do
                item:setData("tempData", nil)
            end
        end

        -- Clean up custom data tables
        character:setData("customEvents", nil)
        character:setData("activeQuests", nil)
        character:setData("tempFlags", nil)

        -- Remove from active character lists
        if character.activeTimers then
            for _, timerID in pairs(character.activeTimers) do
                timer.Remove(timerID)
            end
            character.activeTimers = nil
        end

        -- Log cleanup
        lia.log.add(nil, "char_cleanup_complete", character:getID(), stats)
    end)
    ```
]]
function CharDeleted(client, character)
end

--[[
    Purpose:
        Called after a character has been successfully deleted from the database

    When Called:
        After a character deletion operation completes successfully

    Parameters:
        - client (Player): The player whose character was deleted
        - character (Character): The character that was deleted (may be nil if already removed)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character deletion
    hook.Add("CharDeleted", "LogDeletion", function(client, character)
        print("Character deleted by: " .. client:Nick())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clean up related data
    hook.Add("CharDeleted", "CleanupData", function(client, character)
        if character then
            local charID = character:getID()
            
            -- Delete related warnings
            lia.db.query("DELETE FROM warnings WHERE charID = " .. lia.db.convertDataType(charID))
            
            -- Delete related logs
            lia.db.query("DELETE FROM logs WHERE charID = " .. lia.db.convertDataType(charID))
            
            lia.log.add(client, "char_deleted_cleanup", charID)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive deletion handling
    hook.Add("CharDeleted", "AdvancedDeletion", function(client, character)
        if not character then return end

        local charID = character:getID()
        local charName = character:getName()
        
        -- Archive character data before cleanup
        local archiveData = {
            name = charName,
            deletedBy = client:Nick(),
            deletedSteamID = client:SteamID(),
            deletedAt = os.time(),
            finalMoney = character:getMoney() or 0,
            finalPlaytime = character:getPlayTime() or 0
        }

        -- Save to archive table
        lia.db.insertTable(archiveData, nil, "deleted_characters_archive")

        -- Clean up all related data
        lia.db.query("DELETE FROM warnings WHERE charID = " .. lia.db.convertDataType(charID))
        lia.db.query("DELETE FROM logs WHERE charID = " .. lia.db.convertDataType(charID))
        lia.db.query("DELETE FROM character_data WHERE charID = " .. lia.db.convertDataType(charID))

        -- Notify staff
        for _, staff in ipairs(player.GetAll()) do
            if staff:hasPrivilege("canSeeDeletions") then
                staff:notify(charName .. " has been deleted by " .. client:Nick())
            end
        end

        -- Send to Discord
        local embed = {
            title = "Character Deleted",
            description = string.format("**Character:** %s\n**Deleted By:** %s\n**Money:** %s\n**Playtime:** %d hours",
                charName, client:Nick(), lia.currency.get(archiveData.finalMoney), math.floor(archiveData.finalPlaytime / 3600)),
            color = 0xff0000
        }
        hook.Run("DiscordRelaySend", embed)

        lia.log.add(client, "char_deleted", charID, charName)
    end)
    ```
]]
function CharForceRecognized(ply, range)
end

--[[
    Purpose:
        React when a player forces recognition on all nearby players.

    When Called:
        Called from the recognition module's `ForceRecognizeRange` function after all nearby players have been recognized and the network message is sent.

    Parameters:
        - ply (Player): Player who initiated the forced recognition.
        - range (string): Recognition range used ("whisper", "normal", "talk", or "yell").

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log forced recognition
    hook.Add("CharForceRecognized", "MyAddon", function(ply, range)
    print(ply:Name() .. " was force recognized")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle forced recognition effects
    hook.Add("CharForceRecognized", "ForceRecognitionEffects", function(ply, range)
    local char = ply:getChar()
    if char then
        -- Set recognition data
        char:setData("forceRecognized", true)
        char:setData("recognitionTime", os.time())
        -- Notify player
        ply:ChatPrint("You have been force recognized")
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex force recognition system
    hook.Add("CharForceRecognized", "AdvancedForceRecognition", function(ply, range)
    local char = ply:getChar()
    if not char then return end
        -- Set recognition data
        char:setData("forceRecognized", true)
        char:setData("recognitionTime", os.time())
        char:setData("recognitionRange", range)
        -- Check for faction-specific effects
        local faction = char:getFaction()
        if faction == "police" then
            -- Police force recognition
            for _, target in ipairs(player.GetAll()) do
                if target ~= ply then
                    local targetChar = target:getChar()
                    if targetChar and targetChar:getFaction() == "police" then
                        target:ChatPrint("[POLICE] " .. char:getName() .. " was force recognized")
                        end
                    end
                end
            end
        end)
    ```
]]
function CharHasFlags(self, flags)
end

--[[
    Purpose:
        Override or extend flag checking for a player's character.

    When Called:
        Queried from `player:hasFlags()` when checking if the character has specific flags. This allows custom flag systems or additional flag validation.

    Parameters:
        - self (Player): Player whose character flags are being checked.
        - flags (string): Flag string being validated (e.g., "a" for admin, "c" for citizen).

    Returns:
        boolean|nil - Return true if the character has the flag, false if not, or nil to use default behavior.

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all flag checks
    hook.Add("CharHasFlags", "MyAddon", function(self, flags)
    return true
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check specific flags
    hook.Add("CharHasFlags", "FlagChecker", function(self, flags)
    if type(flags) == "string" then
        return self:getChar():hasFlags(flags)
    elseif type(flags) == "table" then
        for _, flag in ipairs(flags) do
            if not self:getChar():hasFlags(flag) then
                return false
            end
        end
        return true
    end
    return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced flag checking with permissions
    hook.Add("CharHasFlags", "AdvancedFlagCheck", function(self, flags)
    local char = self:getChar()
    if not char then return false end

    -- Admin override
    if self:IsAdmin() then return true end

    -- Check flag requirements
    if type(flags) == "string" then
        return char:hasFlags(flags)
    elseif type(flags) == "table" then
        local hasAllFlags = true
        for _, flag in ipairs(flags) do
            if not char:hasFlags(flag) then
                hasAllFlags = false
                break
            end
        end
        return hasAllFlags
    end

    return false
    end)
    ```
]]
function CharLoaded(id)
end

--[[
    Purpose:
        Called when a character has been loaded from the database

    When Called:
        After a character's data has been successfully loaded from the database into memory

    Parameters:
        - id (number): The character ID that was loaded

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character loading
    hook.Add("CharLoaded", "LogLoading", function(id)
        print("Character loaded: " .. id)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Initialize character data
    hook.Add("CharLoaded", "InitializeData", function(id)
        lia.char.getCharacter(id, nil, function(character)
            if character then
                -- Set default values if missing
                if not character:getData("firstLoadTime") then
                    character:setData("firstLoadTime", os.time())
                end

                -- Initialize custom systems
                character:setData("customStats", {})
            end
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character loading with validation
    hook.Add("CharLoaded", "AdvancedLoading", function(id)
        lia.char.getCharacter(id, nil, function(character)
            if not character then return end

            -- Validate character data integrity
            local inventory = character:getInv()
            if inventory then
                local items = inventory:getItems()
                local validItems = {}

                -- Filter out invalid items
                for _, item in pairs(items) do
                    if item.uniqueID and lia.item.list[item.uniqueID] then
                        table.insert(validItems, item)
                    else
                        lia.log.add(nil, "char_loaded_invalid_item", id, item.uniqueID)
                    end
                end

                -- Log loading statistics
                lia.log.add(nil, "char_loaded", {
                    id = id,
                    name = character:getName(),
                    itemCount = #validItems,
                    money = character:getMoney() or 0,
                    playtime = character:getPlayTime() or 0
                })
            end

            -- Set up auto-save timer
            local client = character:getPlayer()
            if IsValid(client) then
                local timerID = "charSave_" .. id
                timer.Create(timerID, 300, 0, function()
                    if IsValid(client) and client:getChar() == character then
                        character:save()
                    else
                        timer.Remove(timerID)
                    end
                end)
            end

            -- Initialize custom systems
            character:setData("loadCount", (character:getData("loadCount", 0) + 1))
            character:setData("lastLoadTime", os.time())
        end)
    end)
    ```
]]
function CharPostSave(self)
end

--[[
    Purpose:
        Called after a character has been saved to the database

    When Called:
        After character data has been successfully written to the database

    Parameters:
        - self (Character): The character that was saved

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log successful saves
    hook.Add("CharPostSave", "LogSaves", function(self)
        print("Character saved: " .. self:getName())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Update save statistics
    hook.Add("CharPostSave", "SaveStats", function(self)
        local saveCount = self:getData("saveCount", 0) + 1
        self:setData("saveCount", saveCount)
        self:setData("lastSaveTime", os.time())

        -- Log frequent saves for monitoring
        if saveCount % 100 == 0 then
            lia.log.add(nil, "char_save_milestone", self:getID(), saveCount)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced post-save operations
    hook.Add("CharPostSave", "AdvancedPostSave", function(self)
        local client = self:getPlayer()
        local charID = self:getID()

        -- Update save statistics
        local saveCount = self:getData("saveCount", 0) + 1
        self:setData("saveCount", saveCount)
        self:setData("lastSaveTime", os.time())

        -- Sync to external systems
        if lia.config.get("EnableExternalSync", false) then
            -- Send to external API
            http.Post(lia.config.get("ExternalAPIURL", ""), {
                action = "character_saved",
                charID = charID,
                timestamp = os.time(),
                data = {
                    money = self:getMoney(),
                    playtime = self:getPlayTime()
                }
            }, function(result)
                -- Handle response
            end, function(error)
                lia.log.add(nil, "external_sync_failed", error)
            end)
        end

        -- Backup character data
        if saveCount % 10 == 0 then
            local backupData = {
                charID = charID,
                name = self:getName(),
                money = self:getMoney(),
                playtime = self:getPlayTime(),
                timestamp = os.time()
            }
            lia.db.insertTable(backupData, nil, "character_backups")
        end

        -- Notify player if they're online
        if IsValid(client) then
            client:setLiliaData("lastCharSaveTime", os.time())
        end

        lia.log.add(client, "char_post_save", charID, saveCount)
    end)
    ```
]]
function CharPreSave(character)
end

--[[
    Purpose:
        Called before a character is saved to the database

    When Called:
        Before character data is written to the database, allowing last-minute modifications

    Parameters:
        - character (Character): The character being saved

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Update last save time
    hook.Add("CharPreSave", "UpdateTime", function(character)
        character:setData("lastSaveTime", os.time())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and prepare data
    hook.Add("CharPreSave", "PrepareData", function(character)
        local client = character:getPlayer()
        if IsValid(client) then
            -- Update playtime before saving
            local loginTime = character:getLoginTime()
            if loginTime and loginTime > 0 then
                local total = character:getPlayTime() or 0
                character:setPlayTime(total + os.time() - loginTime)
            end

            -- Save ammo data
            local ammoTable = {}
            for _, ammoType in pairs(game.GetAmmoTypes()) do
                local count = client:GetAmmoCount(ammoType)
                if count > 0 then
                    ammoTable[ammoType] = count
                end
            end
            character:setAmmo(ammoTable)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive pre-save processing
    hook.Add("CharPreSave", "AdvancedPreSave", function(character)
        local client = character:getPlayer()

        -- Update playtime
        if IsValid(client) then
            local loginTime = character:getLoginTime()
            if loginTime and loginTime > 0 then
                local total = character:getPlayTime() or 0
                character:setPlayTime(total + os.time() - loginTime)
                character:setLoginTime(os.time())
            end

            -- Save equipment state
            local inventory = character:getInv()
            if inventory then
                for _, item in pairs(inventory:getItems()) do
                    if item:getData("equip", false) then
                        -- Save equipped item positions
                        item:setData("lastEquipTime", os.time())
                    end
                end
            end

            -- Save ammo
            local ammoTable = {}
            for _, ammoType in pairs(game.GetAmmoTypes()) do
                local count = client:GetAmmoCount(ammoType)
                if count > 0 then
                    ammoTable[ammoType] = count
                end
            end
            character:setAmmo(ammoTable)

            -- Call OnSave on all items
            for _, item in pairs(inventory:getItems()) do
                if item.OnSave then
                    item:call("OnSave", client)
                end
            end
        end

        -- Validate data integrity
        if character:getMoney() < 0 then
            character:setMoney(0) -- Prevent negative money
        end

        -- Update statistics
        character:setData("saveCount", (character:getData("saveCount", 0) + 1))
        character:setData("lastPreSaveTime", os.time())
    end)
    ```
]]
function CharRestored(character)
end

--[[
    Purpose:
        Called when a character has been restored from backup or loaded from saved state

    When Called:
        After a character has been restored from a backup or saved state

    Parameters:
        - character (Character): The character that was restored

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character restoration
    hook.Add("CharRestored", "LogRestore", function(character)
        print("Character restored: " .. character:getName())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate restored data
    hook.Add("CharRestored", "ValidateRestore", function(character)
        -- Check if inventory needs repair
        local inventory = character:getInv()
        if inventory then
            local items = inventory:getItems()
            for _, item in pairs(items) do
                if not item.uniqueID or not lia.item.list[item.uniqueID] then
                    -- Remove invalid items
                    inventory:remove(item.id)
                end
            end
        end

        -- Validate money
        if character:getMoney() < 0 then
            character:setMoney(0)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive restoration handling
    hook.Add("CharRestored", "AdvancedRestore", function(character)
        local client = character:getPlayer()

        -- Validate and repair inventory
        local inventory = character:getInv()
        if inventory then
            local validItems = {}
            local removedItems = {}

            for _, item in pairs(inventory:getItems()) do
                if item.uniqueID and lia.item.list[item.uniqueID] then
                    table.insert(validItems, item)
                else
                    table.insert(removedItems, item.uniqueID)
                    inventory:remove(item.id)
                end
            end

            if #removedItems > 0 then
                lia.log.add(client, "char_restore_invalid_items", character:getID(), table.concat(removedItems, ", "))
            end
        end

        -- Restore equipment state
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") then
                    -- Restore equipped items
                    item:setData("restored", true)
                end
            end
        end

        -- Restore ammo
        local ammoTable = character:getAmmo()
        if IsValid(client) and ammoTable then
            timer.Simple(0.25, function()
                if IsValid(client) then
                    for ammoType, ammoCount in pairs(ammoTable) do
                        client:GiveAmmo(ammoCount, ammoType, true)
                    end
                end
            end)
        end

        -- Update restoration statistics
        character:setData("restoreCount", (character:getData("restoreCount", 0) + 1))
        character:setData("lastRestoreTime", os.time())

        lia.log.add(client, "char_restored", character:getID())
    end)
    ```
]]
function ChatParsed(client, chatType, message, anonymous)
end

--[[
    Purpose:
        Called after a chat message has been parsed and before it's sent to players

    When Called:
        After a player's chat message has been parsed by the chat system

    Parameters:
        - client (Player): The player who sent the message
        - chatType (string): The type of chat (e.g., "ic", "ooc", "looc", "me", "it")
        - message (string): The parsed message content
        - anonymous (boolean): Whether the message should be anonymous

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log parsed chat
    hook.Add("ChatParsed", "LogChat", function(client, chatType, message, anonymous)
        print(client:Nick() .. " [" .. chatType .. "]: " .. message)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter and modify messages
    hook.Add("ChatParsed", "ChatFilter", function(client, chatType, message, anonymous)
        local char = client:getChar()
        if not char then return end

        -- Add roleplay tags
        if chatType == "ic" and char:getData("roleplayTag", "") ~= "" then
            message = "[" .. char:getData("roleplayTag") .. "] " .. message
        end

        -- Check for banned words
        local bannedWords = {"badword1", "badword2"}
        for _, word in ipairs(bannedWords) do
            if string.find(message:lower(), word:lower()) then
                client:notify("Your message contains inappropriate content!")
                return -- Cancel message
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced chat processing
    hook.Add("ChatParsed", "AdvancedChat", function(client, chatType, message, anonymous)
        local char = client:getChar()
        if not char then return end

        -- Anti-spam check
        local lastMessage = client:getLiliaData("lastChatMessage", "")
        local lastMessageTime = client:getLiliaData("lastChatTime", 0)
        
        if message == lastMessage and CurTime() - lastMessageTime < 5 then
            client:notify("Please don't spam messages!")
            return
        end

        client:setLiliaData("lastChatMessage", message)
        client:setLiliaData("lastChatTime", CurTime())

        -- Profanity filter
        local filteredWords = {"bad", "word", "list"}
        for _, word in ipairs(filteredWords) do
            message = message:gsub(word, string.rep("*", #word))
        end

        -- Add faction/clan tags
        if chatType == "ic" then
            local faction = lia.faction.indices[char:getFaction()]
            if faction and faction.tag then
                message = "[" .. faction.tag .. "] " .. message
            end
        end

        -- Log chat messages
        lia.log.add(client, "chat_" .. chatType, message)

        -- Check for admin commands in chat
        if chatType == "ic" and string.StartWith(message, "/") then
            local command = string.sub(message, 2):match("^%w+")
            if command and lia.command.list[command] then
                -- Command detected, will be handled by command system
            end
        end
    end)
    ```
]]
function CheckFactionLimitReached(faction, character, client)
end

--[[
    Purpose:
        Checks whether a faction has reached its maximum member limit

    When Called:
        When checking if a character can join a faction due to member limits

    Parameters:
        - faction (table): The faction data table
        - character (Character): The character attempting to join
        - client (Player): The player whose character is joining

    Returns:
        boolean - True if the faction limit has been reached, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Check basic faction limit
    hook.Add("CheckFactionLimitReached", "BasicLimit", function(faction, character, client)
        local currentMembers = faction.members or 0
        local maxMembers = faction.maxMembers or 50
        
        return currentMembers >= maxMembers
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Dynamic faction limits
    hook.Add("CheckFactionLimitReached", "DynamicLimit", function(faction, character, client)
        local currentMembers = 0
        lia.db.select({"COUNT(*) as count"}, "characters", "faction = " .. lia.db.convertDataType(faction.index)):next(function(result)
            currentMembers = result.count or 0
        end)

        local maxMembers = faction.maxMembers or 50
        
        -- Increase limit for VIP players
        if client:hasPrivilege("vip") then
            maxMembers = maxMembers + 10
        end

        return currentMembers >= maxMembers
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced faction limit checking
    hook.Add("CheckFactionLimitReached", "AdvancedLimit", function(faction, character, client)
        -- Count active members (online characters)
        local activeMembers = 0
        for _, ply in ipairs(player.GetAll()) do
            local char = ply:getChar()
            if char and char:getFaction() == faction.index then
                activeMembers = activeMembers + 1
            end
        end

        -- Get total members from database
        local totalMembers = 0
        lia.db.select({"COUNT(*) as count"}, "characters", "faction = " .. lia.db.convertDataType(faction.index)):next(function(result)
            totalMembers = result.count or 0
        end)

        local maxMembers = faction.maxMembers or 50

        -- Dynamic limits based on server population
        local serverPop = #player.GetAll()
        if serverPop > 50 then
            maxMembers = maxMembers + math.floor(serverPop / 10) -- Increase by 1 per 10 players
        end

        -- VIP bonus
        if client:hasPrivilege("vip") then
            maxMembers = maxMembers + 5
        end

        -- Check if limit reached
        local limitReached = totalMembers >= maxMembers

        if limitReached and IsValid(client) then
            client:notify("This faction has reached its maximum member limit of " .. maxMembers .. " members!")
        end

        return limitReached
    end)
    ```
]]
function CommandRan(client, command, arguments, results)
end

--[[
    Purpose:
        Called after a command has been executed

    When Called:
        After a command has finished executing and results are available

    Parameters:
        - client (Player): The player who ran the command
        - command (table): The command data table
        - arguments (table): The arguments passed to the command
        - results (table): The results returned from the command execution

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log command execution
    hook.Add("CommandRan", "LogCommands", function(client, command, arguments, results)
        print(client:Nick() .. " ran command: " .. command.name)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track command usage statistics
    hook.Add("CommandRan", "CommandStats", function(client, command, arguments, results)
        local char = client:getChar()
        if not char then return end

        -- Increment command usage counter
        local usageCount = char:getData("commandUsage", {})
        usageCount[command.name] = (usageCount[command.name] or 0) + 1
        char:setData("commandUsage", usageCount)

        -- Log to database
        lia.log.add(client, "command_executed", command.name, table.concat(arguments, " "))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced command tracking and analytics
    hook.Add("CommandRan", "AdvancedTracking", function(client, command, arguments, results)
        local char = client:getChar()
        if not char then return end

        -- Update command statistics
        local usageStats = char:getData("commandStats", {})
        if not usageStats[command.name] then
            usageStats[command.name] = {
                count = 0,
                firstUsed = os.time(),
                lastUsed = os.time()
            }
        end
        usageStats[command.name].count = usageStats[command.name].count + 1
        usageStats[command.name].lastUsed = os.time()
        char:setData("commandStats", usageStats)

        -- Log to database with full context
        lia.db.insertTable({
            steamID = client:SteamID(),
            charID = char:getID(),
            command = command.name,
            arguments = util.TableToJSON(arguments),
            results = util.TableToJSON(results),
            timestamp = os.time()
        }, nil, "command_logs")

        -- Send analytics to external system
        if lia.config.get("EnableAnalytics", false) then
            http.Post(lia.config.get("AnalyticsURL", ""), {
                event = "command_executed",
                player = client:Nick(),
                command = command.name,
                arguments = table.concat(arguments, " "),
                timestamp = os.time()
            }, function() end, function() end)
        end

        -- Check for suspicious command patterns
        if usageStats[command.name].count > 100 and CurTime() - usageStats[command.name].firstUsed < 3600 then
            lia.log.add(client, "suspicious_command_spam", command.name, usageStats[command.name].count)
        end
    end)
    ```
]]
function ConfigChanged(key, value, oldValue, client)
end

--[[
    Purpose:
        Called when a configuration value has been changed

    When Called:
        After a configuration setting has been modified

    Parameters:
        - key (string): The configuration key that was changed
        - value (any): The new configuration value
        - oldValue (any): The previous configuration value
        - client (Player): The player who changed the config (may be nil for server changes)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log configuration changes
    hook.Add("ConfigChanged", "LogChanges", function(key, value, oldValue, client)
        local changer = IsValid(client) and client:Nick() or "Server"
        print(changer .. " changed " .. key .. " from " .. tostring(oldValue) .. " to " .. tostring(value))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and notify changes
    hook.Add("ConfigChanged", "ValidateChanges", function(key, value, oldValue, client)
        -- Validate critical configs
        if key == "maxCharacters" and value > 10 then
            if IsValid(client) then
                client:notify("Maximum characters cannot exceed 10!")
                lia.config.set("maxCharacters", oldValue) -- Revert
                return
            end
        end

        -- Notify admins of important changes
        if IsValid(client) then
            for _, admin in ipairs(player.GetAll()) do
                if admin:IsAdmin() and admin ~= client then
                    admin:notify(client:Nick() .. " changed " .. key .. " to " .. tostring(value))
                end
            end
        end

        -- Log to database
        lia.log.add(client, "config_changed", key, oldValue, value)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced configuration change handling
    hook.Add("ConfigChanged", "AdvancedConfig", function(key, value, oldValue, client)
        -- Validate configuration value
        local configData = lia.config.list[key]
        if configData then
            -- Type checking
            if configData.type and type(value) ~= configData.type then
                if IsValid(client) then
                    client:notify("Invalid type for " .. key .. "!")
                    lia.config.set(key, oldValue) -- Revert
                end
                return
            end

            -- Range checking for numbers
            if type(value) == "number" and configData.min and value < configData.min then
                if IsValid(client) then
                    client:notify(key .. " cannot be less than " .. configData.min .. "!")
                    lia.config.set(key, oldValue)
                end
                return
            end

            if type(value) == "number" and configData.max and value > configData.max then
                if IsValid(client) then
                    client:notify(key .. " cannot be more than " .. configData.max .. "!")
                    lia.config.set(key, oldValue)
                end
                return
            end
        end

        -- Critical config changes require confirmation
        local criticalConfigs = {"maxCharacters", "startingMoney", "maxInventoryWeight"}
        if table.HasValue(criticalConfigs, key) and IsValid(client) then
            -- Send notification to all staff
            for _, staff in ipairs(player.GetAll()) do
                if staff:hasPrivilege("canSeeConfigChanges") then
                    staff:notify("[CRITICAL] " .. client:Nick() .. " changed " .. key .. 
                        " from " .. tostring(oldValue) .. " to " .. tostring(value))
                end
            end
        end

        -- Save to database
        lia.db.query("UPDATE config SET value = " .. lia.db.convertDataType(value) .. 
            " WHERE key = " .. lia.db.convertDataType(key))

        -- Log change
        lia.log.add(client, "config_changed", {
            key = key,
            oldValue = oldValue,
            newValue = value,
            changer = IsValid(client) and client:SteamID() or "SERVER",
            timestamp = os.time()
        })

        -- Sync to external systems
        if lia.config.get("SyncConfigChanges", false) then
            http.Post(lia.config.get("SyncURL", ""), {
                action = "config_changed",
                key = key,
                value = util.TableToJSON({value}),
                oldValue = util.TableToJSON({oldValue})
            }, function() end, function() end)
        end
    end)
    ```
]]
function CreateCharacter(data)
end

--[[
    Purpose:
        Called when a new character is being created

    When Called:
        When a player initiates character creation with character data

    Parameters:
        - data (table): The character creation data (name, model, description, etc.)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character creation
    hook.Add("CreateCharacter", "LogCreation", function(data)
        print("Creating character: " .. (data.name or "Unknown"))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and modify character data
    hook.Add("CreateCharacter", "ValidateData", function(data)
        -- Ensure name is not empty
        if not data.name or data.name == "" then
            data.name = "Unknown"
        end

        -- Set default model if not provided
        if not data.model then
            data.model = "models/player/group01/male_01.mdl"
        end

        -- Set default starting money
        if not data.money then
            data.money = lia.config.get("startingMoney", 0)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character creation processing
    hook.Add("CreateCharacter", "AdvancedCreation", function(data)
        local client = data.client
        if not IsValid(client) then return end

        -- Validate character limit
        local charCount = client:getCharCount()
        local maxChars = lia.config.get("maxCharacters", 5)
        
        if charCount >= maxChars then
            client:notify("You have reached the maximum character limit!")
            return
        end

        -- Validate name
        if not data.name or string.len(data.name) < 3 then
            client:notify("Character name must be at least 3 characters!")
            return
        end

        if string.len(data.name) > 24 then
            client:notify("Character name cannot exceed 24 characters!")
            return
        end

        -- Check for duplicate names
        lia.db.selectOne({"COUNT(*) as count"}, "characters", 
            "name = " .. lia.db.convertDataType(data.name)):next(function(result)
            if result and result.count > 0 then
                client:notify("This name is already taken!")
                return
            end
        end)

        -- Set defaults
        data.money = data.money or lia.config.get("startingMoney", 0)
        data.model = data.model or "models/player/group01/male_01.mdl"
        data.faction = data.faction or FACTION_CITIZEN

        -- Add creation timestamp
        data.createdAt = os.time()

        -- Set VIP bonuses
        if client:hasPrivilege("vip") then
            data.money = data.money + 500 -- Extra starting money
            data.attributes = data.attributes or {}
            data.attributes.strength = (data.attributes.strength or 0) + 5
        end

        -- Log creation
        lia.log.add(client, "character_created", data.name, data.model)
    end)
    ```
]]
function CreateDefaultInventory(character)
end

--[[
    Purpose:
        Called when creating the default starting inventory for a new character

    When Called:
        When a new character is created and needs initial items in their inventory

    Parameters:
        - character (Character): The character receiving the default inventory

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Add basic starting items
    hook.Add("CreateDefaultInventory", "BasicItems", function(character)
        local inventory = character:getInv()
        if inventory then
            inventory:add("flashlight") -- Add a flashlight
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based starting items
    hook.Add("CreateDefaultInventory", "FactionItems", function(character)
        local inventory = character:getInv()
        if not inventory then return end

        local faction = character:getFaction()
        
        -- Common items for all
        inventory:add("flashlight")
        inventory:add("radio")

        -- Faction-specific items
        if faction == FACTION_POLICE then
            inventory:add("police_badge")
            inventory:add("handcuffs")
        elseif faction == FACTION_MEDIC then
            inventory:add("medkit")
            inventory:add("bandage")
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced default inventory system
    hook.Add("CreateDefaultInventory", "AdvancedInventory", function(character)
        local inventory = character:getInv()
        if not inventory then return end

        local client = character:getPlayer()
        local faction = character:getFaction()

        -- Universal starting items
        local defaultItems = {
            "flashlight",
            "radio"
        }

        -- Add universal items
        for _, itemID in ipairs(defaultItems) do
            inventory:add(itemID)
        end

        -- Faction-specific starting equipment
        local factionItems = {
            [FACTION_POLICE] = {"police_badge", "handcuffs", "police_uniform"},
            [FACTION_MEDIC] = {"medkit", "bandage", "medic_uniform"},
            [FACTION_CITIZEN] = {"citizen_id"}
        }

        if factionItems[faction] then
            for _, itemID in ipairs(factionItems[faction]) do
                inventory:add(itemID)
            end
        end

        -- VIP starting bonuses
        if IsValid(client) and client:hasPrivilege("vip") then
            inventory:add("vip_supply_kit")
            inventory:add("premium_radio")
        end

        -- Check for welcome package event
        if GetGlobalBool("WelcomePackageEvent", false) then
            inventory:add("welcome_package")
        end

        -- Log default inventory creation
        lia.log.add(client, "default_inventory_created", character:getID(), faction)
    end)
    ```
]]
function CreateSalaryTimers()
end

--[[
    Purpose:
        Called when salary payment timers should be created

    When Called:
        When the server initializes or when salary timers need to be recreated

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log timer creation
    hook.Add("CreateSalaryTimers", "LogCreation", function()
        print("Creating salary payment timers...")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Custom salary timer system
    hook.Add("CreateSalaryTimers", "CustomSalary", function()
        local salaryInterval = lia.config.get("salaryInterval", 600) -- 10 minutes default

        timer.Create("liaSalaryTimer", salaryInterval, 0, function()
            for _, ply in ipairs(player.GetAll()) do
                local char = ply:getChar()
                if char then
                    hook.Run("PlayerEarnSalary", ply, char)
                end
            end
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced salary timer system with faction support
    hook.Add("CreateSalaryTimers", "AdvancedSalary", function()
        -- Remove existing timers
        if timer.Exists("liaSalaryTimer") then
            timer.Remove("liaSalaryTimer")
        end

        local salaryInterval = lia.config.get("salaryInterval", 600)
        
        -- Create main salary timer
        timer.Create("liaSalaryTimer", salaryInterval, 0, function()
            for _, ply in ipairs(player.GetAll()) do
                local char = ply:getChar()
                if not char then continue end

                -- Check if player can earn salary
                if hook.Run("CanPlayerEarnSalary", ply, char) then
                    local faction = lia.faction.indices[char:getFaction()]
                    
                    if faction and faction.pay then
                        -- Calculate salary
                        local salary = faction.pay
                        
                        -- Apply bonuses
                        if ply:hasPrivilege("vip") then
                            salary = salary * 1.5 -- 50% bonus for VIP
                        end

                        -- Pay salary
                        char:giveMoney(salary)
                        ply:notify("You received your salary: " .. lia.currency.get(salary))

                        -- Log payment
                        lia.log.add(ply, "salary_paid", salary, faction.name)
                    end
                end
            end
        end)

        -- Create bonus timer for VIP players
        timer.Create("liaVIPSalaryBonus", salaryInterval * 2, 0, function()
            for _, ply in ipairs(player.GetAll()) do
                if ply:hasPrivilege("vip") then
                    local char = ply:getChar()
                    if char then
                        local bonus = 100
                        char:giveMoney(bonus)
                        ply:notify("VIP Bonus: " .. lia.currency.get(bonus))
                    end
                end
            end
        end)
    end)
    ```
]]
function DatabaseConnected()
end

--[[
    Purpose:
        Called when the database connection is established

    When Called:
        After successfully connecting to the database on server startup

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log database connection
    hook.Add("DatabaseConnected", "LogConnection", function()
        print("Database connected successfully!")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Initialize database tables
    hook.Add("DatabaseConnected", "InitializeTables", function()
        -- Create custom tables if they don't exist
        lia.db.query([[
            CREATE TABLE IF NOT EXISTS custom_data (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                key TEXT UNIQUE,
                value TEXT,
                timestamp INTEGER
            )
        ]])

        print("Custom database tables initialized!")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced database initialization
    hook.Add("DatabaseConnected", "AdvancedInit", function()
        -- Verify database integrity
        lia.db.query("PRAGMA integrity_check"):next(function(result)
            if result and result.integrity_check == "ok" then
                print("Database integrity check passed!")
            else
                print("WARNING: Database integrity check failed!")
                lia.log.add(nil, "database_integrity_failed", result)
            end
        end)

        -- Create or update database schema
        local schemaVersion = lia.config.get("databaseSchemaVersion", 1)
        
        lia.db.query([[
            CREATE TABLE IF NOT EXISTS schema_version (
                version INTEGER PRIMARY KEY,
                updated_at INTEGER
            )
        ]])

        -- Check current schema version
        lia.db.selectOne({"version"}, "schema_version", "version = " .. schemaVersion):next(function(result)
            if not result then
                -- Run migrations
                print("Running database migrations...")
                
                -- Migration 1: Add new columns
                lia.db.query("ALTER TABLE characters ADD COLUMN lastLogin INTEGER DEFAULT 0")
                
                -- Update schema version
                lia.db.insertTable({
                    version = schemaVersion,
                    updated_at = os.time()
                }, nil, "schema_version")

                print("Database schema updated to version " .. schemaVersion)
            end
        end)

        -- Initialize statistics
        lia.db.select({"COUNT(*) as count"}, "characters"):next(function(result)
            if result then
                print("Total characters in database: " .. result.count)
            end
        end)

        -- Start background tasks
        timer.Create("liaDatabaseMaintenance", 3600, 0, function()
            hook.Run("DatabaseMaintenance")
        end)

        lia.log.add(nil, "database_connected", os.time())
    end)
    ```
]]
function DeleteCharacter(id)
end

--[[
    Purpose:
        Called when a character is being deleted

    When Called:
        When a character deletion process is initiated

    Parameters:
        - id (number): The character ID being deleted

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character deletion
    hook.Add("DeleteCharacter", "LogDeletion", function(id)
        print("Deleting character ID: " .. id)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clean up character-related data
    hook.Add("DeleteCharacter", "CleanupData", function(id)
        -- Delete related warnings
        lia.db.query("DELETE FROM warnings WHERE charID = " .. lia.db.convertDataType(id))
        
        -- Delete related logs
        lia.db.query("DELETE FROM logs WHERE charID = " .. lia.db.convertDataType(id))
        
        lia.log.add(nil, "character_deletion_cleanup", id)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive character deletion handling
    hook.Add("DeleteCharacter", "AdvancedDeletion", function(id)
        -- Get character data before deletion
        lia.db.selectOne({"*"}, "characters", "id = " .. lia.db.convertDataType(id)):next(function(charData)
            if not charData then return end

            -- Archive character data
            local archiveData = {
                charID = id,
                name = charData.name,
                money = charData.money,
                deletedAt = os.time(),
                finalPlaytime = charData.playtime or 0
            }
            lia.db.insertTable(archiveData, nil, "deleted_characters_archive")

            -- Clean up all related data
            lia.db.query("DELETE FROM warnings WHERE charID = " .. lia.db.convertDataType(id))
            lia.db.query("DELETE FROM logs WHERE charID = " .. lia.db.convertDataType(id))
            lia.db.query("DELETE FROM character_data WHERE charID = " .. lia.db.convertDataType(id))
            
            -- Delete inventory items
            lia.db.query("DELETE FROM items WHERE charID = " .. lia.db.convertDataType(id))

            -- Notify staff
            for _, staff in ipairs(player.GetAll()) do
                if staff:hasPrivilege("canSeeDeletions") then
                    staff:notify("Character " .. charData.name .. " (ID: " .. id .. ") has been deleted")
                end
            end

            -- Log deletion
            lia.log.add(nil, "character_deleted", id, charData.name, charData.money)
        end)
    end)
    ```
]]
function DiscordRelaySend(embed)
end

--[[
    Purpose:
        Called when sending a message/embed to Discord through the relay system

    When Called:
        When a message needs to be sent to Discord via the relay

    Parameters:
        - embed (table): The Discord embed/message data table

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log Discord messages
    hook.Add("DiscordRelaySend", "LogMessages", function(embed)
        print("Sending to Discord: " .. (embed.title or "No title"))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Format and validate embeds
    hook.Add("DiscordRelaySend", "FormatEmbeds", function(embed)
        -- Ensure required fields
        if not embed.title then
            embed.title = "Lilia Notification"
        end

        if not embed.color then
            embed.color = 0x3498db -- Default blue
        end

        -- Add timestamp
        embed.timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced Discord relay processing
    hook.Add("DiscordRelaySend", "AdvancedRelay", function(embed)
        -- Validate embed structure
        if type(embed) ~= "table" then
            lia.log.add(nil, "discord_invalid_embed", "embed is not a table")
            return
        end

        -- Set defaults
        embed.title = embed.title or "Lilia Notification"
        embed.color = embed.color or 0x3498db
        embed.timestamp = embed.timestamp or os.date("!%Y-%m-%dT%H:%M:%SZ")

        -- Add server information
        if not embed.footer then
            embed.footer = {
                text = GetHostName() .. " | " .. #player.GetAll() .. " players",
                icon_url = embed.footerIcon or ""
            }
        end

        -- Rate limiting check
        local lastSend = GetGlobalInt("LastDiscordSend", 0)
        if CurTime() - lastSend < 1 then
            -- Queue message if too frequent
            local queue = GetGlobalTable("DiscordQueue", {})
            table.insert(queue, embed)
            SetGlobalTable("DiscordQueue", queue)
            return
        end

        SetGlobalInt("LastDiscordSend", CurTime())

        -- Filter sensitive information
        if embed.description then
            embed.description = embed.description:gsub("STEAM_0:%d:%d+", "[REDACTED]")
            embed.description = embed.description:gsub("steamid64:%d+", "[REDACTED]")
        end

        -- Log important messages
        if embed.color == 0xff0000 then -- Red = important
            lia.log.add(nil, "discord_critical_message", embed.title, embed.description)
        end
    end)
    ```
]]
function DiscordRelayUnavailable()
end

--[[
    Purpose:
        Called when the Discord relay becomes unavailable or disconnected

    When Called:
        When the Discord webhook/relay connection fails or becomes unavailable

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log unavailability
    hook.Add("DiscordRelayUnavailable", "LogUnavailable", function()
        print("Discord relay is unavailable!")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Queue messages and notify admins
    hook.Add("DiscordRelayUnavailable", "QueueMessages", function()
        -- Notify admins
        for _, admin in ipairs(player.GetAll()) do
            if admin:IsAdmin() then
                admin:notify("Discord relay is unavailable! Messages will be queued.")
            end
        end

        -- Enable message queuing
        SetGlobalBool("DiscordQueueEnabled", true)
        
        lia.log.add(nil, "discord_relay_unavailable", os.time())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced Discord relay failure handling
    hook.Add("DiscordRelayUnavailable", "AdvancedFailure", function()
        -- Log failure
        local failureCount = GetGlobalInt("DiscordFailureCount", 0) + 1
        SetGlobalInt("DiscordFailureCount", failureCount)
        SetGlobalInt("LastDiscordFailure", os.time())

        -- Notify all staff
        for _, staff in ipairs(player.GetAll()) do
            if staff:hasPrivilege("canSeeDiscordStatus") then
                staff:notify("[WARNING] Discord relay unavailable! Failure count: " .. failureCount)
            end
        end

        -- Enable message queuing
        SetGlobalBool("DiscordQueueEnabled", true)
        SetGlobalTable("DiscordMessageQueue", GetGlobalTable("DiscordMessageQueue", {}))

        -- Attempt reconnection after delay
        timer.Create("DiscordReconnect", 60, 1, function()
            hook.Run("DiscordRelayReconnect")
        end)

        -- Log to file
        lia.log.add(nil, "discord_relay_unavailable", {
            failureCount = failureCount,
            timestamp = os.time(),
            serverTime = os.date("%Y-%m-%d %H:%M:%S")
        })

        -- Send email/notification to server owner if critical
        if failureCount > 5 then
            -- Critical failure - notify owner
            hook.Run("CriticalSystemFailure", "Discord Relay", failureCount)
        end
    end)
    ```
]]
function DiscordRelayed(embed)
end

--[[
    Purpose:
        Called after a message/embed has been successfully sent to Discord

    When Called:
        After a Discord message has been successfully relayed to Discord

    Parameters:
        - embed (table): The Discord embed/message that was sent

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log successful sends
    hook.Add("DiscordRelayed", "LogSuccess", function(embed)
        print("Successfully sent to Discord: " .. (embed.title or "No title"))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track relay statistics
    hook.Add("DiscordRelayed", "TrackStats", function(embed)
        local messageCount = GetGlobalInt("DiscordMessagesSent", 0) + 1
        SetGlobalInt("DiscordMessagesSent", messageCount)
        SetGlobalInt("LastDiscordSendTime", os.time())

        -- Reset failure count on successful send
        SetGlobalInt("DiscordFailureCount", 0)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced relay tracking and analytics
    hook.Add("DiscordRelayed", "AdvancedTracking", function(embed)
        -- Update statistics
        local messageCount = GetGlobalInt("DiscordMessagesSent", 0) + 1
        SetGlobalInt("DiscordMessagesSent", messageCount)
        SetGlobalInt("LastDiscordSendTime", os.time())

        -- Reset failure count
        SetGlobalInt("DiscordFailureCount", 0)

        -- Track message types
        local messageType = embed.title or "Unknown"
        local typeStats = GetGlobalTable("DiscordMessageTypes", {})
        typeStats[messageType] = (typeStats[messageType] or 0) + 1
        SetGlobalTable("DiscordMessageTypes", typeStats)

        -- Log to database
        lia.db.insertTable({
            title = embed.title or "",
            description = embed.description or "",
            timestamp = os.time(),
            messageCount = messageCount
        }, nil, "discord_relay_logs")

        -- Process queued messages
        local queue = GetGlobalTable("DiscordMessageQueue", {})
        if #queue > 0 then
            timer.Simple(1, function()
                local nextMessage = table.remove(queue, 1)
                if nextMessage then
                    hook.Run("DiscordRelaySend", nextMessage)
                end
                SetGlobalTable("DiscordMessageQueue", queue)
            end)
        end

        -- Analytics
        if lia.config.get("EnableDiscordAnalytics", false) then
            http.Post(lia.config.get("AnalyticsURL", ""), {
                event = "discord_message_sent",
                title = embed.title,
                timestamp = os.time()
            }, function() end, function() end)
        end
    end)
    ```
]]
function DoorEnabledToggled(client, door, newState)
end

--[[
    Purpose:
        Called when a door's enabled/disabled state is toggled

    When Called:
        When a door entity is enabled or disabled (becomes usable/unusable)

    Parameters:
        - client (Player): The player who toggled the door state
        - door (Entity): The door entity being toggled
        - newState (boolean): The new enabled state (true = enabled, false = disabled)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log door state changes
    hook.Add("DoorEnabledToggled", "LogToggle", function(client, door, newState)
        local state = newState and "enabled" or "disabled"
        print(client:Nick() .. " " .. state .. " door")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify and log state changes
    hook.Add("DoorEnabledToggled", "NotifyToggle", function(client, door, newState)
        local state = newState and "enabled" or "disabled"
        
        -- Notify the player
        client:notify("Door has been " .. state)
        
        -- Log to database
        lia.log.add(client, "door_toggled", door:EntIndex(), newState)
        
        -- Notify nearby players
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetPos():Distance(door:GetPos()) < 500 then
                ply:notify("A door has been " .. state)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door state management
    hook.Add("DoorEnabledToggled", "AdvancedToggle", function(client, door, newState)
        if not IsValid(door) then return end

        -- Check permissions
        local doorOwner = door:getNetVar("owner")
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            client:notify("You don't have permission to toggle this door!")
            door:SetEnabled(not newState) -- Revert
            return
        end

        -- Update door state
        door:setNetVar("enabled", newState)
        door:SetEnabled(newState)

        -- Notify owner if different from toggler
        if doorOwner and doorOwner ~= client:SteamID() then
            local owner = player.GetBySteamID(doorOwner)
            if IsValid(owner) then
                owner:notify(client:Nick() .. " " .. (newState and "enabled" or "disabled") .. " your door")
            end
        end

        -- Log state change
        lia.db.insertTable({
            doorID = door:getNetVar("doorID", 0),
            toggledBy = client:SteamID(),
            newState = newState and 1 or 0,
            timestamp = os.time()
        }, nil, "door_toggle_logs")

        -- Notify nearby players
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetPos():Distance(door:GetPos()) < 300 then
                ply:notify("Door " .. (newState and "enabled" or "disabled") .. " by " .. client:Nick())
            end
        end

        lia.log.add(client, "door_enabled_toggled", door:EntIndex(), newState)
    end)
    ```
]]
function DoorHiddenToggled(client, entity, newState)
end

--[[
    Purpose:
        Called when a door's hidden/visible state is toggled

    When Called:
        When a door entity is made hidden or visible to players

    Parameters:
        - client (Player): The player who toggled the door visibility
        - entity (Entity): The door entity being toggled
        - newState (boolean): The new hidden state (true = hidden, false = visible)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log visibility changes
    hook.Add("DoorHiddenToggled", "LogToggle", function(client, entity, newState)
        local state = newState and "hidden" or "visible"
        print(client:Nick() .. " made door " .. state)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify and log visibility changes
    hook.Add("DoorHiddenToggled", "NotifyToggle", function(client, entity, newState)
        local state = newState and "hidden" or "visible"
        
        client:notify("Door has been made " .. state)
        
        -- Update door data
        entity:setNetVar("hidden", newState)
        
        -- Log change
        lia.log.add(client, "door_hidden_toggled", entity:EntIndex(), newState)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door visibility management
    hook.Add("DoorHiddenToggled", "AdvancedToggle", function(client, entity, newState)
        if not IsValid(entity) then return end

        -- Check permissions
        local doorOwner = entity:getNetVar("owner")
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            client:notify("You don't have permission to toggle door visibility!")
            return
        end

        -- Update visibility
        entity:setNetVar("hidden", newState)
        entity:SetNoDraw(newState)

        -- Notify owner if different from toggler
        if doorOwner and doorOwner ~= client:SteamID() then
            local owner = player.GetBySteamID(doorOwner)
            if IsValid(owner) then
                owner:notify(client:Nick() .. " made your door " .. (newState and "hidden" or "visible"))
            end
        end

        -- Log to database
        lia.db.insertTable({
            doorID = entity:getNetVar("doorID", 0),
            toggledBy = client:SteamID(),
            hidden = newState and 1 or 0,
            timestamp = os.time()
        }, nil, "door_visibility_logs")

        lia.log.add(client, "door_hidden_toggled", entity:EntIndex(), newState)
    end)
    ```
]]
function DoorLockToggled(client, door, state)
end

--[[
    Purpose:
        Called when a door's lock state is toggled

    When Called:
        When a door is locked or unlocked by a player

    Parameters:
        - client (Player): The player who toggled the lock
        - door (Entity): The door entity being locked/unlocked
        - state (boolean): The new locked state (true = locked, false = unlocked)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log lock state changes
    hook.Add("DoorLockToggled", "LogToggle", function(client, door, state)
        local lockState = state and "locked" or "unlocked"
        print(client:Nick() .. " " .. lockState .. " door")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify and update door lock state
    hook.Add("DoorLockToggled", "NotifyToggle", function(client, door, state)
        local lockState = state and "locked" or "unlocked"
        
        client:notify("Door has been " .. lockState)
        
        -- Update door lock state
        door:setNetVar("locked", state)
        
        -- Play sound effect
        door:EmitSound(state and "doors/door_latch3.wav" or "doors/door_unlock1.wav")
        
        lia.log.add(client, "door_lock_toggled", door:EntIndex(), state)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door locking system
    hook.Add("DoorLockToggled", "AdvancedLock", function(client, door, state)
        if not IsValid(door) then return end

        -- Check permissions
        local doorOwner = door:getNetVar("owner")
        local char = client:getChar()
        
        -- Owner or admin can lock/unlock
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            -- Check if player has key
            local doorID = door:getNetVar("doorID", 0)
            local inventory = char and char:getInv()
            local hasKey = false

            if inventory then
                for _, item in pairs(inventory:getItems()) do
                    if item.uniqueID == "door_key" and item:getData("doorID") == doorID then
                        hasKey = true
                        break
                    end
                end
            end

            if not hasKey then
                client:notify("You need a key to " .. (state and "lock" or "unlock") .. " this door!")
                return
            end
        end

        -- Update lock state
        door:setNetVar("locked", state)

        -- Play appropriate sound
        if state then
            door:EmitSound("doors/door_latch3.wav")
        else
            door:EmitSound("doors/door_unlock1.wav")
        end

        -- Notify nearby players
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetPos():Distance(door:GetPos()) < 300 then
                ply:notify("Door " .. (state and "locked" or "unlocked") .. " by " .. client:Nick())
            end
        end

        -- Log to database
        lia.db.insertTable({
            doorID = door:getNetVar("doorID", 0),
            toggledBy = client:SteamID(),
            locked = state and 1 or 0,
            timestamp = os.time()
        }, nil, "door_lock_logs")

        lia.log.add(client, "door_lock_toggled", door:EntIndex(), state)
    end)
    ```
]]
function DoorOwnableToggled(client, door, newState)
end

--[[
    Purpose:
        Called when a door's ownable state is toggled (whether it can be owned)

    When Called:
        When a door is made ownable or unownable by a player or admin

    Parameters:
        - client (Player): The player who toggled the ownable state
        - door (Entity): The door entity being toggled
        - newState (boolean): The new ownable state (true = ownable, false = not ownable)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log ownable state changes
    hook.Add("DoorOwnableToggled", "LogToggle", function(client, door, newState)
        local state = newState and "ownable" or "not ownable"
        print(client:Nick() .. " made door " .. state)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Update and notify ownable state
    hook.Add("DoorOwnableToggled", "NotifyToggle", function(client, door, newState)
        -- Only admins can toggle this
        if not client:IsAdmin() then
            client:notify("Only administrators can toggle door ownable state!")
            return
        end

        door:setNetVar("ownable", newState)
        client:notify("Door is now " .. (newState and "ownable" or "not ownable"))

        -- If unowning, remove current owner
        if not newState then
            door:setNetVar("owner", nil)
        end

        lia.log.add(client, "door_ownable_toggled", door:EntIndex(), newState)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door ownable management
    hook.Add("DoorOwnableToggled", "AdvancedOwnable", function(client, door, newState)
        if not IsValid(door) then return end

        -- Require admin privileges
        if not client:IsAdmin() then
            client:notify("Only administrators can toggle door ownable state!")
            return
        end

        -- Update ownable state
        door:setNetVar("ownable", newState)

        -- If making door unownable, handle existing owner
        if not newState then
            local currentOwner = door:getNetVar("owner")
            if currentOwner then
                -- Refund purchase if applicable
                local purchasePrice = door:getNetVar("purchasePrice", 0)
                if purchasePrice > 0 then
                    local owner = player.GetBySteamID(currentOwner)
                    if IsValid(owner) then
                        local char = owner:getChar()
                        if char then
                            char:giveMoney(purchasePrice)
                            owner:notify("You received a refund of " .. lia.currency.get(purchasePrice) .. 
                                " for door that is no longer ownable")
                        end
                    end
                end

                -- Clear ownership
                door:setNetVar("owner", nil)
                door:setNetVar("purchasePrice", nil)

                -- Notify previous owner
                local owner = player.GetBySteamID(currentOwner)
                if IsValid(owner) then
                    owner:notify("Your door ownership has been removed as it is no longer ownable")
                end
            end
        end

        -- Log to database
        lia.db.insertTable({
            doorID = door:getNetVar("doorID", 0),
            toggledBy = client:SteamID(),
            ownable = newState and 1 or 0,
            timestamp = os.time()
        }, nil, "door_ownable_logs")

        -- Notify staff
        for _, staff in ipairs(player.GetAll()) do
            if staff:IsAdmin() and staff ~= client then
                staff:notify(client:Nick() .. " made a door " .. (newState and "ownable" or "not ownable"))
            end
        end

        lia.log.add(client, "door_ownable_toggled", door:EntIndex(), newState)
    end)
    ```
]]
function DoorPriceSet(client, door, price)
end

--[[
    Purpose:
        Called when a door's purchase price is set

    When Called:
        When a player or admin sets the price for purchasing a door

    Parameters:
        - client (Player): The player setting the door price
        - door (Entity): The door entity
        - price (number): The new purchase price for the door

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log price changes
    hook.Add("DoorPriceSet", "LogPrice", function(client, door, price)
        print(client:Nick() .. " set door price to " .. lia.currency.get(price))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and set door price
    hook.Add("DoorPriceSet", "ValidatePrice", function(client, door, price)
        -- Only admins or door owners can set price
        local doorOwner = door:getNetVar("owner")
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            client:notify("You don't have permission to set this door's price!")
            return
        end

        -- Validate price range
        if price < 0 then
            price = 0
        elseif price > 1000000 then
            price = 1000000
            client:notify("Maximum door price is " .. lia.currency.get(1000000))
        end

        door:setNetVar("price", price)
        client:notify("Door price set to " .. lia.currency.get(price))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door price management
    hook.Add("DoorPriceSet", "AdvancedPrice", function(client, door, price)
        if not IsValid(door) then return end

        -- Check permissions
        local doorOwner = door:getNetVar("owner")
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            client:notify("You don't have permission to set this door's price!")
            return
        end

        -- Validate price
        local minPrice = lia.config.get("minDoorPrice", 0)
        local maxPrice = lia.config.get("maxDoorPrice", 1000000)

        if price < minPrice then
            price = minPrice
            client:notify("Minimum door price is " .. lia.currency.get(minPrice))
        elseif price > maxPrice then
            price = maxPrice
            client:notify("Maximum door price is " .. lia.currency.get(maxPrice))
        end

        -- Store old price
        local oldPrice = door:getNetVar("price", 0)

        -- Update door price
        door:setNetVar("price", price)

        -- Log to database
        lia.db.insertTable({
            doorID = door:getNetVar("doorID", 0),
            setBy = client:SteamID(),
            oldPrice = oldPrice,
            newPrice = price,
            timestamp = os.time()
        }, nil, "door_price_logs")

        -- Notify nearby players if significant change
        if math.abs(price - oldPrice) > 1000 then
            for _, ply in ipairs(player.GetAll()) do
                if ply:GetPos():Distance(door:GetPos()) < 300 then
                    ply:notify("Door price changed from " .. lia.currency.get(oldPrice) .. 
                        " to " .. lia.currency.get(price))
                end
            end
        end

        lia.log.add(client, "door_price_set", door:EntIndex(), price, oldPrice)
    end)
    ```
]]
function DoorTitleSet(client, door, name)
end

--[[
    Purpose:
        Called when a door's title/name is set

    When Called:
        When a player or admin sets a custom title/name for a door

    Parameters:
        - client (Player): The player setting the door title
        - door (Entity): The door entity
        - name (string): The new title/name for the door

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log title changes
    hook.Add("DoorTitleSet", "LogTitle", function(client, door, name)
        print(client:Nick() .. " set door title to: " .. name)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and set door title
    hook.Add("DoorTitleSet", "ValidateTitle", function(client, door, name)
        -- Check permissions
        local doorOwner = door:getNetVar("owner")
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            client:notify("You don't have permission to set this door's title!")
            return
        end

        -- Validate name length
        if string.len(name) > 50 then
            name = string.sub(name, 1, 50)
            client:notify("Door title truncated to 50 characters")
        end

        door:setNetVar("title", name)
        client:notify("Door title set to: " .. name)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door title management
    hook.Add("DoorTitleSet", "AdvancedTitle", function(client, door, name)
        if not IsValid(door) then return end

        -- Check permissions
        local doorOwner = door:getNetVar("owner")
        if doorOwner and doorOwner ~= client:SteamID() and not client:IsAdmin() then
            client:notify("You don't have permission to set this door's title!")
            return
        end

        -- Validate and sanitize name
        name = string.Trim(name or "")
        
        -- Check length
        local maxLength = lia.config.get("maxDoorTitleLength", 50)
        if string.len(name) > maxLength then
            name = string.sub(name, 1, maxLength)
            client:notify("Door title truncated to " .. maxLength .. " characters")
        end

        -- Filter profanity
        local filteredWords = {"bad", "word", "list"}
        for _, word in ipairs(filteredWords) do
            if string.find(name:lower(), word:lower()) then
                client:notify("Door title contains inappropriate content!")
                return
            end
        end

        -- Store old title
        local oldTitle = door:getNetVar("title", "")

        -- Update door title
        door:setNetVar("title", name)

        -- Log to database
        lia.db.insertTable({
            doorID = door:getNetVar("doorID", 0),
            setBy = client:SteamID(),
            oldTitle = oldTitle,
            newTitle = name,
            timestamp = os.time()
        }, nil, "door_title_logs")

        -- Notify owner if different from setter
        if doorOwner and doorOwner ~= client:SteamID() then
            local owner = player.GetBySteamID(doorOwner)
            if IsValid(owner) then
                owner:notify(client:Nick() .. " changed your door title to: " .. name)
            end
        end

        lia.log.add(client, "door_title_set", door:EntIndex(), name, oldTitle)
    end)
    ```
]]
function FetchSpawns()
end

--[[
    Purpose:
        Called when spawn points need to be fetched/loaded

    When Called:
        When the server needs to retrieve spawn point data from the database or configuration

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log spawn fetching
    hook.Add("FetchSpawns", "LogFetch", function()
        print("Fetching spawn points...")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Load custom spawn points
    hook.Add("FetchSpawns", "CustomSpawns", function()
        -- Load spawns from database
        lia.db.select({"*"}, "spawns"):next(function(results)
            if results then
                for _, spawn in ipairs(results) do
                    -- Process spawn data
                    lia.spawn.add(spawn.position, spawn.angle, spawn.name)
                end
            end
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced spawn management
    hook.Add("FetchSpawns", "AdvancedSpawns", function()
        -- Fetch spawns from database
        lia.db.select({"*"}, "spawns", "active = 1"):next(function(results)
            if not results then return end

            local spawnCount = 0
            local factionSpawns = {}

            for _, spawn in ipairs(results) do
                -- Validate spawn data
                if spawn.position and spawn.angle then
                    local pos = util.StringToType(spawn.position, "Vector")
                    local ang = util.StringToType(spawn.angle, "Angle")

                    if pos and ang then
                        -- Add spawn
                        lia.spawn.add(pos, ang, spawn.name)

                        -- Organize by faction
                        if spawn.faction then
                            if not factionSpawns[spawn.faction] then
                                factionSpawns[spawn.faction] = {}
                            end
                            table.insert(factionSpawns[spawn.faction], spawn)
                        end

                        spawnCount = spawnCount + 1
                    end
                end
            end

            -- Store faction spawns
            SetGlobalTable("FactionSpawns", factionSpawns)

            -- Log spawn loading
            print("Loaded " .. spawnCount .. " spawn points from database")
            lia.log.add(nil, "spawns_loaded", spawnCount)
        end)

        -- Load map-specific spawns
        local mapName = game.GetMap()
        if file.Exists("maps/" .. mapName .. "_spawns.txt", "DATA") then
            local spawnData = file.Read("maps/" .. mapName .. "_spawns.txt", "DATA")
            if spawnData then
                -- Parse and add map spawns
                local spawns = util.JSONToTable(spawnData)
                if spawns then
                    for _, spawn in ipairs(spawns) do
                        lia.spawn.add(spawn.pos, spawn.ang, "Map Spawn")
                    end
                end
            end
        end
    end)
    ```
]]
function ForceRecognizeRange(ply, range, fakeName)
end

--[[
    Purpose:
        Called to force recognition of a player within a specific range with an optional fake name

    When Called:
        When a player needs to be recognized/identified by others within a certain distance

    Parameters:
        - ply (Player): The player being recognized
        - range (number): The maximum range at which the player can be recognized
        - fakeName (string): Optional fake name to display instead of the real name

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Set recognition range
    hook.Add("ForceRecognizeRange", "BasicRecognition", function(ply, range, fakeName)
        ply:SetNWFloat("RecognizeRange", range)
        if fakeName then
            ply:SetNWString("FakeName", fakeName)
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Recognition with faction checks
    hook.Add("ForceRecognizeRange", "FactionRecognition", function(ply, range, fakeName)
        local char = ply:getChar()
        if not char then return end

        -- Set recognition range
        ply:SetNWFloat("RecognizeRange", range)

        -- Apply fake name if provided
        if fakeName then
            ply:SetNWString("FakeName", fakeName)
            ply:SetNWBool("UsingFakeName", true)
        else
            ply:SetNWString("FakeName", "")
            ply:SetNWBool("UsingFakeName", false)
        end

        -- Notify nearby players
        for _, other in ipairs(player.GetAll()) do
            if other ~= ply and other:GetPos():Distance(ply:GetPos()) <= range then
                other:notify("You recognize " .. (fakeName or char:getName()))
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced recognition system
    hook.Add("ForceRecognizeRange", "AdvancedRecognition", function(ply, range, fakeName)
        if not IsValid(ply) then return end

        local char = ply:getChar()
        if not char then return end

        -- Validate range
        range = math.max(0, math.min(range, 1000)) -- Clamp between 0 and 1000

        -- Set recognition data
        ply:SetNWFloat("RecognizeRange", range)
        ply:SetNWInt("RecognitionTime", CurTime())

        -- Handle fake name
        if fakeName and fakeName ~= "" then
            -- Validate fake name length
            if string.len(fakeName) > 50 then
                fakeName = string.sub(fakeName, 1, 50)
            end

            ply:SetNWString("FakeName", fakeName)
            ply:SetNWBool("UsingFakeName", true)
            
            -- Log fake name usage for admin tracking
            lia.log.add(ply, "fake_name_used", fakeName, char:getName())
        else
            ply:SetNWString("FakeName", "")
            ply:SetNWBool("UsingFakeName", false)
        end

        -- Notify players within range
        local plyPos = ply:GetPos()
        local recognitionTable = {}

        for _, other in ipairs(player.GetAll()) do
            if other ~= ply and IsValid(other) then
                local distance = other:GetPos():Distance(plyPos)
                if distance <= range then
                    local otherChar = other:getChar()
                    if otherChar then
                        -- Check if other player can recognize (line of sight, etc.)
                        local trace = util.TraceLine({
                            start = other:GetShootPos(),
                            endpos = ply:GetShootPos(),
                            filter = {other, ply}
                        })

                        if not trace.Hit then
                            -- Line of sight clear
                            table.insert(recognitionTable, {
                                player = other,
                                distance = distance,
                                recognized = true
                            })

                            -- Notify player
                            local displayName = fakeName or char:getName()
                            other:notify("You recognize " .. displayName .. " (" .. 
                                math.floor(distance) .. " units away)")
                        end
                    end
                end
            end
        end

        -- Store recognition data
        ply:SetNWTable("RecognitionData", recognitionTable)
    end)
    ```
]]
function GetAllCaseClaims()
end

--[[
    Purpose:
        Retrieves all active case claims from the database or system

    When Called:
        When the system needs to get a list of all case claims

    Parameters:
        None

    Returns:
        table - A table containing all case claims

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Get all claims from database
    hook.Add("GetAllCaseClaims", "GetClaims", function()
        local claims = {}
        lia.db.select({"*"}, "case_claims"):next(function(results)
            if results then
                claims = results
            end
        end)
        return claims
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Get active claims with filtering
    hook.Add("GetAllCaseClaims", "ActiveClaims", function()
        local claims = {}
        lia.db.select({"*"}, "case_claims", "active = 1"):next(function(results)
            if results then
                for _, claim in ipairs(results) do
                    -- Only include claims not expired
                    if claim.expiryTime and claim.expiryTime > os.time() then
                        table.insert(claims, claim)
                    end
                end
            end
        end)
        return claims
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced case claims retrieval
    hook.Add("GetAllCaseClaims", "AdvancedClaims", function()
        local allClaims = {}
        
        -- Get all claims from database
        lia.db.select({"*"}, "case_claims"):next(function(results)
            if not results then return end

            for _, claim in ipairs(results) do
                -- Validate claim data
                if claim.caseID and claim.claimedBy then
                    -- Check if claim is still valid
                    local isValid = true

                    if claim.expiryTime and claim.expiryTime < os.time() then
                        isValid = false
                    end

                    -- Check if claiming player is still online
                    if isValid then
                        local claimer = player.GetBySteamID(claim.claimedBy)
                        if not IsValid(claimer) then
                            -- Offline player, check if claim is still valid
                            local offlineTime = os.time() - (claim.lastSeen or 0)
                            if offlineTime > 86400 then -- 24 hours
                                isValid = false
                            end
                        end
                    end

                    if isValid then
                        -- Add metadata
                        claim.isOnline = IsValid(player.GetBySteamID(claim.claimedBy))
                        claim.timeRemaining = claim.expiryTime and (claim.expiryTime - os.time()) or nil
                        
                        table.insert(allClaims, claim)
                    else
                        -- Mark as expired
                        lia.db.query("UPDATE case_claims SET active = 0 WHERE id = " .. 
                            lia.db.convertDataType(claim.id))
                    end
                end
            end

            -- Sort by priority and time
            table.sort(allClaims, function(a, b)
                if a.priority ~= b.priority then
                    return (a.priority or 0) > (b.priority or 0)
                end
                return (a.claimedAt or 0) < (b.claimedAt or 0)
            end)
        end)

        return allClaims
    end)
    ```
]]
function GetAttributeMax(target, attrKey)
end

--[[
    Purpose:
        Retrieves or calculates the maximum value for a specific attribute

    When Called:
        When the system needs to determine the maximum possible value for an attribute

    Parameters:
        - target (Player/Character): The player or character whose attribute max is being checked
        - attrKey (string): The attribute key/name (e.g., "strength", "endurance")

    Returns:
        number - The maximum value for the attribute

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default max
    hook.Add("GetAttributeMax", "DefaultMax", function(target, attrKey)
        return 100 -- Default max for all attributes
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Attribute-specific maximums
    hook.Add("GetAttributeMax", "AttributeMax", function(target, attrKey)
        local maxValues = {
            strength = 100,
            endurance = 100,
            agility = 80,
            intelligence = 120
        }
        
        return maxValues[attrKey] or 100
    end)
    ```

    High Complexity:
    ```lua
    -- High: Dynamic attribute maximums based on character
    hook.Add("GetAttributeMax", "AdvancedMax", function(target, attrKey)
        local char = target
        if IsValid(target) and target.getChar then
            char = target:getChar()
        end

        if not char then return 100 end

        -- Base maximums
        local baseMax = {
            strength = 100,
            endurance = 100,
            agility = 80,
            intelligence = 120,
            perception = 90
        }

        local maxValue = baseMax[attrKey] or 100

        -- Apply faction bonuses
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.attributeBonuses then
            local bonus = faction.attributeBonuses[attrKey] or 0
            maxValue = maxValue + bonus
        end

        -- Apply class bonuses
        local class = lia.class.list[char:getClass()]
        if class and class.attributeBonuses then
            local bonus = class.attributeBonuses[attrKey] or 0
            maxValue = maxValue + bonus
        end

        -- VIP bonuses
        if IsValid(target) and target.hasPrivilege and target:hasPrivilege("vip") then
            maxValue = maxValue + 10
        end

        -- Equipment bonuses
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") and item.attribBonuses then
                    local bonus = item.attribBonuses[attrKey] or 0
                    maxValue = maxValue + bonus
                end
            end
        end

        -- Hard cap
        local hardCap = lia.config.get("maxAttributeValue", 200)
        maxValue = math.min(maxValue, hardCap)

        return maxValue
    end)
    ```
]]
function GetAttributeStartingMax(client, k)
end

--[[
    Purpose:
        Retrieves or calculates the starting maximum value for a character's attribute

    When Called:
        When a new character is created and the starting attribute maximum needs to be determined

    Parameters:
        - client (Player): The player creating the character
        - k (string): The attribute key/name (e.g., "strength", "endurance")

    Returns:
        number - The starting maximum value for the attribute

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default starting max
    hook.Add("GetAttributeStartingMax", "Default", function(client, k)
        return 50 -- Default starting max for all attributes
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Attribute-specific starting maximums
    hook.Add("GetAttributeStartingMax", "AttributeSpecific", function(client, k)
        local startingMax = {
            strength = 50,
            endurance = 50,
            agility = 45,
            intelligence = 55
        }
        
        return startingMax[k] or 50
    end)
    ```

    High Complexity:
    ```lua
    -- High: Dynamic starting maximums based on faction and VIP status
    hook.Add("GetAttributeStartingMax", "AdvancedStarting", function(client, k)
        local baseMax = {
            strength = 50,
            endurance = 50,
            agility = 45,
            intelligence = 55,
            perception = 48
        }

        local startingMax = baseMax[k] or 50

        -- Apply faction bonuses to starting max
        local char = client:getChar()
        if char then
            local faction = lia.faction.indices[char:getFaction()]
            if faction and faction.startingAttributeBonuses then
                local bonus = faction.startingAttributeBonuses[k] or 0
                startingMax = startingMax + bonus
            end
        end

        -- VIP starting bonus
        if client:hasPrivilege("vip") then
            startingMax = startingMax + 5
        end

        -- Clamp to reasonable values
        startingMax = math.min(startingMax, 80) -- Max starting value
        
        return startingMax
    end)
    ```
]]
function GetCharMaxStamina(char)
end

--[[
    Purpose:
        Retrieves or calculates the maximum stamina value for a character

    When Called:
        When the system needs to determine a character's maximum stamina capacity

    Parameters:
        - char (Character): The character whose max stamina is being checked

    Returns:
        number - The maximum stamina value for the character

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default max stamina
    hook.Add("GetCharMaxStamina", "Default", function(char)
        return 100 -- Default max stamina
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Base stamina on endurance attribute
    hook.Add("GetCharMaxStamina", "EnduranceBased", function(char)
        local endurance = char:getAttrib("endurance", 50)
        return 50 + (endurance * 2) -- Base 50 + endurance * 2
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced stamina calculation with multiple factors
    hook.Add("GetCharMaxStamina", "AdvancedStamina", function(char)
        -- Base stamina
        local maxStamina = 100

        -- Endurance attribute bonus
        local endurance = char:getAttrib("endurance", 50)
        maxStamina = maxStamina + (endurance * 1.5)

        -- Faction bonuses
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.staminaBonus then
            maxStamina = maxStamina + faction.staminaBonus
        end

        -- Class bonuses
        local class = lia.class.list[char:getClass()]
        if class and class.staminaBonus then
            maxStamina = maxStamina + class.staminaBonus
        end

        -- Equipment bonuses
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") and item.staminaBonus then
                    maxStamina = maxStamina + item.staminaBonus
                end
            end
        end

        -- VIP bonus
        local client = char:getPlayer()
        if IsValid(client) and client:hasPrivilege("vip") then
            maxStamina = maxStamina + 20
        end

        -- Hard cap
        local hardCap = lia.config.get("maxStaminaValue", 300)
        maxStamina = math.min(maxStamina, hardCap)

        return math.floor(maxStamina)
    end)
    ```
]]
function GetDamageScale(hitgroup, dmgInfo, damageScale)
end

--[[
    Purpose:
        Modifies the damage scale multiplier for a specific hit group

    When Called:
        When calculating damage based on hit group (head, chest, limbs, etc.)

    Parameters:
        - hitgroup (number): The hit group ID (HITGROUP_HEAD, HITGROUP_CHEST, etc.)
        - dmgInfo (CTakeDamageInfo): The damage information object
        - damageScale (number): The current damage scale multiplier

    Returns:
        number - The modified damage scale multiplier

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Modify headshot damage
    hook.Add("GetDamageScale", "HeadshotDamage", function(hitgroup, dmgInfo, damageScale)
        if hitgroup == HITGROUP_HEAD then
            return 2.0 -- Double damage for headshots
        end
        return damageScale
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Hit group-based damage scaling
    hook.Add("GetDamageScale", "HitGroupScaling", function(hitgroup, dmgInfo, damageScale)
        local hitGroupMultipliers = {
            [HITGROUP_HEAD] = 2.0,      -- Headshots do double damage
            [HITGROUP_CHEST] = 1.0,      -- Chest normal damage
            [HITGROUP_STOMACH] = 1.2,    -- Stomach slight bonus
            [HITGROUP_LEFTARM] = 0.7,    -- Arms reduced damage
            [HITGROUP_RIGHTARM] = 0.7,
            [HITGROUP_LEFTLEG] = 0.8,    -- Legs reduced damage
            [HITGROUP_RIGHTLEG] = 0.8
        }

        local multiplier = hitGroupMultipliers[hitgroup] or 1.0
        return damageScale * multiplier
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced damage scaling with armor and equipment
    hook.Add("GetDamageScale", "AdvancedScaling", function(hitgroup, dmgInfo, damageScale)
        local target = dmgInfo:GetAttacker()
        if not IsValid(target) then return damageScale end

        local char = target:getChar()
        if not char then return damageScale end

        local baseMultiplier = damageScale

        -- Hit group multipliers
        local hitGroupMultipliers = {
            [HITGROUP_HEAD] = 2.0,
            [HITGROUP_CHEST] = 1.0,
            [HITGROUP_STOMACH] = 1.2,
            [HITGROUP_LEFTARM] = 0.7,
            [HITGROUP_RIGHTARM] = 0.7,
            [HITGROUP_LEFTLEG] = 0.8,
            [HITGROUP_RIGHTLEG] = 0.8
        }

        baseMultiplier = baseMultiplier * (hitGroupMultipliers[hitgroup] or 1.0)

        -- Armor protection
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") and item.armor then
                    local armorData = item.armor
                    local protection = armorData[hitgroup] or armorData.overall or 0
                    
                    -- Reduce damage based on armor protection
                    local protectionPercent = protection / 100
                    baseMultiplier = baseMultiplier * (1 - protectionPercent)
                end
            end
        end

        -- Check for critical hit (random chance)
        if math.random() < 0.05 and hitgroup == HITGROUP_HEAD then -- 5% critical chance on head
            baseMultiplier = baseMultiplier * 1.5 -- Extra critical multiplier
        end

        -- Ensure minimum damage
        baseMultiplier = math.max(baseMultiplier, 0.1) -- At least 10% damage

        return baseMultiplier
    end)
    ```
]]
function GetDefaultCharDesc(client, factionIndex, context)
end

--[[
    Purpose:
        Generates or retrieves a default character description for new characters

    When Called:
        When a new character is being created and needs a default description

    Parameters:
        - client (Player): The player creating the character
        - factionIndex (number): The faction index the character belongs to
        - context (table): Additional context about character creation

    Returns:
        string - The default character description

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return basic default description
    hook.Add("GetDefaultCharDesc", "BasicDesc", function(client, factionIndex, context)
        return "A citizen of the city."
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based descriptions
    hook.Add("GetDefaultCharDesc", "FactionDesc", function(client, factionIndex, context)
        local faction = lia.faction.indices[factionIndex]
        if faction then
            return "A " .. faction.name .. " member."
        end
        return "A citizen of the city."
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced description generation
    hook.Add("GetDefaultCharDesc", "AdvancedDesc", function(client, factionIndex, context)
        local faction = lia.faction.indices[factionIndex]
        local descriptions = {}

        -- Faction-specific descriptions
        if factionIndex == FACTION_POLICE then
            descriptions = {
                "A dedicated police officer serving the city.",
                "A member of the law enforcement community.",
                "A sworn officer of the peace."
            }
        elseif factionIndex == FACTION_MEDIC then
            descriptions = {
                "A medical professional committed to saving lives.",
                "A trained medic providing healthcare services.",
                "A member of the medical community."
            }
        elseif factionIndex == FACTION_CITIZEN then
            descriptions = {
                "An ordinary citizen trying to make a living.",
                "A resident of the city going about daily life.",
                "A member of the civilian population."
            }
        else
            descriptions = {
                "A resident of the city.",
                "Someone trying to survive in an urban environment."
            }
        end

        -- Add VIP bonus descriptions
        if client:hasPrivilege("vip") then
            table.insert(descriptions, 1, "[VIP] " .. descriptions[1] or "A distinguished member of society.")
        end

        -- Randomly select a description
        local selected = descriptions[math.random(#descriptions)]

        -- Add timestamp context if available
        if context and context.createdAt then
            -- Could add generation date, etc.
        end

        return selected
    end)
    ```
]]
function GetDefaultCharName(client, factionIndex, context)
end

--[[
    Purpose:
        Generates or retrieves a default character name for new characters

    When Called:
        When a new character is being created and needs a default name

    Parameters:
        - client (Player): The player creating the character
        - factionIndex (number): The faction index the character belongs to
        - context (table): Additional context about character creation

    Returns:
        string - The default character name

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return basic default name
    hook.Add("GetDefaultCharName", "BasicName", function(client, factionIndex, context)
        return "John Doe"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based name generation
    hook.Add("GetDefaultCharName", "FactionName", function(client, factionIndex, context)
        local firstNames = {"John", "Jane", "Bob", "Alice", "Mike", "Sarah"}
        local lastNames = {"Doe", "Smith", "Johnson", "Williams", "Brown"}

        local firstName = firstNames[math.random(#firstNames)]
        local lastName = lastNames[math.random(#lastNames)]
        
        return firstName .. " " .. lastName
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced name generation with uniqueness checks
    hook.Add("GetDefaultCharName", "AdvancedName", function(client, factionIndex, context)
        local faction = lia.faction.indices[factionIndex]
        
        -- Faction-specific name pools
        local namePools = {
            [FACTION_POLICE] = {
                first = {"Officer", "Sergeant", "Detective"},
                last = {"Johnson", "Smith", "Brown", "Davis"}
            },
            [FACTION_MEDIC] = {
                first = {"Dr.", "Nurse", "Medic"},
                last = {"Williams", "Miller", "Wilson", "Moore"}
            },
            [FACTION_CITIZEN] = {
                first = {"John", "Jane", "Bob", "Alice", "Mike", "Sarah", "Tom", "Emma"},
                last = {"Doe", "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Martinez"}
            }
        }

        local pool = namePools[factionIndex] or namePools[FACTION_CITIZEN]
        local firstName = pool.first[math.random(#pool.first)]
        local lastName = pool.last[math.random(#pool.last)]
        
        local generatedName = firstName .. " " .. lastName

        -- Check for uniqueness
        local attemptCount = 0
        while attemptCount < 10 do
            lia.db.selectOne({"COUNT(*) as count"}, "characters", 
                "name = " .. lia.db.convertDataType(generatedName)):next(function(result)
                if result and result.count > 0 then
                    -- Name exists, regenerate
                    firstName = pool.first[math.random(#pool.first)]
                    lastName = pool.last[math.random(#pool.last)]
                    generatedName = firstName .. " " .. lastName
                    attemptCount = attemptCount + 1
                else
                    attemptCount = 10 -- Exit loop
                end
            end)
        end

        -- Add VIP prefix if applicable
        if client:hasPrivilege("vip") then
            generatedName = "[VIP] " .. generatedName
        end

        return generatedName
    end)
    ```
]]
function GetDefaultInventorySize(client, char)
end

--[[
    Purpose:
        Retrieves or calculates the default inventory size (width x height) for a character

    When Called:
        When a new character is created and needs default inventory dimensions

    Parameters:
        - client (Player): The player creating the character
        - char (Character): The character being created

    Returns:
        number, number - Width and height of the inventory grid (default: 4, 4)

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default size
    hook.Add("GetDefaultInventorySize", "DefaultSize", function(client, char)
        return 4, 4 -- 4x4 grid
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based inventory sizes
    hook.Add("GetDefaultInventorySize", "FactionSize", function(client, char)
        local faction = lia.faction.indices[char:getFaction()]
        
        if factionIndex == FACTION_POLICE then
            return 5, 5 -- Police get larger inventory
        elseif factionIndex == FACTION_MEDIC then
            return 6, 4 -- Medics get wider inventory
        end
        
        return 4, 4 -- Default size
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced inventory size calculation
    hook.Add("GetDefaultInventorySize", "AdvancedSize", function(client, char)
        local baseWidth = 4
        local baseHeight = 4

        -- Faction-based sizes
        local faction = lia.faction.indices[char:getFaction()]
        if faction then
            if faction.inventorySize then
                baseWidth = faction.inventorySize.width or baseWidth
                baseHeight = faction.inventorySize.height or baseHeight
            end
        end

        -- VIP bonus
        if client:hasPrivilege("vip") then
            baseWidth = baseWidth + 2
            baseHeight = baseHeight + 2
        end

        -- Class bonuses
        local class = lia.class.list[char:getClass()]
        if class and class.inventoryBonus then
            baseWidth = baseWidth + (class.inventoryBonus.width or 0)
            baseHeight = baseHeight + (class.inventoryBonus.height or 0)
        end

        -- Hard limits
        local maxWidth = lia.config.get("maxInventoryWidth", 10)
        local maxHeight = lia.config.get("maxInventoryHeight", 10)
        
        baseWidth = math.min(baseWidth, maxWidth)
        baseHeight = math.min(baseHeight, maxHeight)

        -- Minimum sizes
        baseWidth = math.max(baseWidth, 2)
        baseHeight = math.max(baseHeight, 2)

        return baseWidth, baseHeight
    end)
    ```
]]
function GetDefaultInventoryType(character)
end

--[[
    Purpose:
        Retrieves the default inventory type/class for a character

    When Called:
        When a new character is created and needs a default inventory type

    Parameters:
        - character (Character): The character being created

    Returns:
        string - The inventory type identifier (e.g., "default", "bag", "stash")

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default type
    hook.Add("GetDefaultInventoryType", "DefaultType", function(character)
        return "default"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based inventory types
    hook.Add("GetDefaultInventoryType", "FactionType", function(character)
        local faction = lia.faction.indices[character:getFaction()]
        
        if factionIndex == FACTION_POLICE then
            return "police_inventory"
        elseif factionIndex == FACTION_MEDIC then
            return "medic_inventory"
        end
        
        return "default"
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced inventory type selection
    hook.Add("GetDefaultInventoryType", "AdvancedType", function(character)
        local client = character:getPlayer()
        local faction = lia.faction.indices[character:getFaction()]
        
        -- Default type
        local invType = "default"

        -- Faction-specific types
        if faction then
            if faction.inventoryType then
                invType = faction.inventoryType
            elseif faction.name == "Police" then
                invType = "police_inventory"
            elseif faction.name == "Medic" then
                invType = "medic_inventory"
            elseif faction.name == "Criminal" then
                invType = "stash"
            end
        end

        -- VIP special inventory
        if IsValid(client) and client:hasPrivilege("vip") then
            invType = "vip_inventory"
        end

        -- Class-specific overrides
        local class = lia.class.list[character:getClass()]
        if class and class.inventoryType then
            invType = class.inventoryType
        end

        return invType
    end)
    ```
]]
function GetEntitySaveData(ent)
end

--[[
    Purpose:
        Retrieves the save data for an entity that should be persisted

    When Called:
        When the server needs to save entity data to the database

    Parameters:
        - ent (Entity): The entity being saved

    Returns:
        table - A table containing the entity's save data

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic save data
    hook.Add("GetEntitySaveData", "BasicData", function(ent)
        return {
            class = ent:GetClass(),
            position = ent:GetPos(),
            angles = ent:GetAngles()
        }
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Entity-specific save data
    hook.Add("GetEntitySaveData", "EntityData", function(ent)
        local data = {
            class = ent:GetClass(),
            position = ent:GetPos(),
            angles = ent:GetAngles(),
            model = ent:GetModel()
        }

        -- Save custom net vars
        if ent.GetNetVar then
            data.customData = {
                owner = ent:getNetVar("owner"),
                name = ent:getNetVar("name"),
                locked = ent:getNetVar("locked", false)
            }
        end

        return data
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive entity save data
    hook.Add("GetEntitySaveData", "AdvancedData", function(ent)
        if not IsValid(ent) then return nil end

        local data = {
            class = ent:GetClass(),
            position = ent:GetPos(),
            angles = ent:GetAngles(),
            model = ent:GetModel(),
            skin = ent:GetSkin(),
            bodygroups = {}
        }

        -- Save bodygroups
        for i = 0, ent:GetNumBodyGroups() - 1 do
            data.bodygroups[i] = ent:GetBodygroup(i)
        end

        -- Save custom net vars
        if ent.GetNetVar then
            data.netVars = {}
            local netVars = {"owner", "name", "locked", "enabled", "price", "title"}
            for _, var in ipairs(netVars) do
                local value = ent:getNetVar(var)
                if value ~= nil then
                    data.netVars[var] = value
                end
            end
        end

        -- Save entity-specific data
        if ent.SaveData then
            local customData = ent:SaveData()
            if customData then
                data.custom = customData
            end
        end

        -- Validate data
        if not data.position or data.position == Vector(0, 0, 0) then
            return nil -- Invalid position, don't save
        end

        -- Add metadata
        data.timestamp = os.time()
        data.map = game.GetMap()

        return data
    end)
    ```
]]
function GetHandsAttackSpeed(client)
end

--[[
    Purpose:
        Retrieves or calculates the attack speed for a player's unarmed/hand attacks

    When Called:
        When calculating how fast a player can punch or perform hand attacks

    Parameters:
        - client (Player): The player whose attack speed is being calculated

    Returns:
        number - The attack speed multiplier (higher = faster attacks)

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default attack speed
    hook.Add("GetHandsAttackSpeed", "DefaultSpeed", function(client)
        return 1.0 -- Default speed multiplier
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Attribute-based attack speed
    hook.Add("GetHandsAttackSpeed", "AttributeSpeed", function(client)
        local char = client:getChar()
        if not char then return 1.0 end

        local agility = char:getAttrib("agility", 50)
        local speedMultiplier = 0.8 + (agility / 250) -- 0.8 to 1.2 based on agility

        return speedMultiplier
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced attack speed calculation
    hook.Add("GetHandsAttackSpeed", "AdvancedSpeed", function(client)
        local char = client:getChar()
        if not char then return 1.0 end

        local baseSpeed = 1.0

        -- Agility attribute bonus
        local agility = char:getAttrib("agility", 50)
        baseSpeed = baseSpeed + ((agility - 50) / 250)

        -- Strength attribute (affects damage, not speed, but can reduce penalty)
        local strength = char:getAttrib("strength", 50)
        if strength < 30 then
            baseSpeed = baseSpeed * 0.9 -- Weak characters attack slower
        end

        -- Equipment bonuses
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") and item.attackSpeedBonus then
                    baseSpeed = baseSpeed + item.attackSpeedBonus
                end
            end
        end

        -- Faction bonuses
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.attackSpeedBonus then
            baseSpeed = baseSpeed + faction.attackSpeedBonus
        end

        -- VIP bonus
        if client:hasPrivilege("vip") then
            baseSpeed = baseSpeed * 1.1 -- 10% faster
        end

        -- Stamina penalty
        local stamina = char:getAttrib("stamina", 100)
        if stamina < 20 then
            baseSpeed = baseSpeed * 0.7 -- Very tired, much slower
        elseif stamina < 50 then
            baseSpeed = baseSpeed * 0.85 -- Tired, slower
        end

        -- Clamp values
        baseSpeed = math.max(0.3, math.min(baseSpeed, 2.0)) -- Between 30% and 200%

        return baseSpeed
    end)
    ```
]]
function GetItemDropModel(itemTable, self)
end

--[[
    Purpose:
        Retrieves the model path for an item when it's dropped as a world entity

    When Called:
        When an item is dropped and needs a 3D model to display in the world

    Parameters:
        - itemTable (table): The item definition table
        - self (Item): The item instance being dropped

    Returns:
        string - The model path for the dropped item entity

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default model
    hook.Add("GetItemDropModel", "DefaultModel", function(itemTable, self)
        return itemTable.model or "models/props_junk/cardboard_box004a.mdl"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Item-specific models
    hook.Add("GetItemDropModel", "ItemModels", function(itemTable, self)
        -- Use item's model if available
        if itemTable.model then
            return itemTable.model
        end

        -- Item type-based defaults
        if itemTable.category == "weapon" then
            return "models/weapons/w_pistol.mdl"
        elseif itemTable.category == "consumable" then
            return "models/props_junk/popcan01a.mdl"
        end

        return "models/props_junk/cardboard_box004a.mdl"
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced model selection with fallbacks
    hook.Add("GetItemDropModel", "AdvancedModel", function(itemTable, self)
        -- Priority 1: Item-specific model
        if itemTable.model then
            -- Validate model exists
            if util.IsValidModel(itemTable.model) then
                return itemTable.model
            end
        end

        -- Priority 2: Item category models
        local categoryModels = {
            weapon = "models/weapons/w_pistol.mdl",
            consumable = "models/props_junk/popcan01a.mdl",
            tool = "models/props_c17/tools_wrench01a.mdl",
            ammo = "models/items/boxsrounds.mdl",
            medical = "models/healthvial.mdl",
            food = "models/props_junk/garbage_bag001a.mdl",
            clothing = "models/props_junk/cardboard_box004a.mdl"
        }

        if itemTable.category and categoryModels[itemTable.category] then
            return categoryModels[itemTable.category]
        end

        -- Priority 3: Size-based models
        local itemSize = itemTable.width * itemTable.height
        if itemSize > 6 then
            return "models/props_junk/cardboard_box003a.mdl" -- Large box
        elseif itemSize > 3 then
            return "models/props_junk/cardboard_box004a.mdl" -- Medium box
        else
            return "models/props_junk/cardboard_box001a.mdl" -- Small box
        end

        -- Fallback
        return "models/props_junk/cardboard_box004a.mdl"
    end)
    ```
]]
function GetItemStackKey(item)
end

--[[
    Purpose:
        Generates a unique key for item stacking/grouping

    When Called:
        When determining if multiple items can be stacked together in an inventory

    Parameters:
        - item (Item): The item instance

    Returns:
        string - A unique key that identifies the stack group

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic stacking by uniqueID
    hook.Add("GetItemStackKey", "BasicStack", function(item)
        return item.uniqueID -- Stack by item type only
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Stack by uniqueID and quality
    hook.Add("GetItemStackKey", "QualityStack", function(item)
        local quality = item:getData("quality", "normal")
        return item.uniqueID .. "_" .. quality
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced stacking with multiple factors
    hook.Add("GetItemStackKey", "AdvancedStack", function(item)
        local stackKey = item.uniqueID

        -- Check if item allows stacking
        if item.isStackable == false then
            -- Unique items - use full unique key including ID
            return item.uniqueID .. "_" .. item.id
        end

        -- Add quality to stack key
        local quality = item:getData("quality", "normal")
        if quality and quality ~= "normal" then
            stackKey = stackKey .. "_" .. quality
        end

        -- Add durability level (stack high durability separately)
        local durability = item:getData("durability", 100)
        if durability < 50 then
            stackKey = stackKey .. "_damaged"
        end

        -- Add custom stacking flags
        local stackFlags = item:getData("stackFlags", "")
        if stackFlags and stackFlags ~= "" then
            stackKey = stackKey .. "_" .. stackFlags
        end

        -- Don't stack bound items with unbound items
        if item:getData("bound") then
            local boundTo = item:getData("boundTo")
            if boundTo then
                stackKey = stackKey .. "_bound_" .. boundTo
            end
        end

        return stackKey
    end)
    ```
]]
function GetItemStacks(inventory)
end

--[[
    Purpose:
        Retrieves all item stacks from an inventory grouped by their stack keys

    When Called:
        When the system needs to get all stacked items in an inventory

    Parameters:
        - inventory (Inventory): The inventory to get stacks from

    Returns:
        table - A table of item stacks, grouped by stack key

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic stack grouping
    hook.Add("GetItemStacks", "BasicStacks", function(inventory)
        local stacks = {}
        for _, item in pairs(inventory:getItems()) do
            local key = item.uniqueID
            if not stacks[key] then
                stacks[key] = {}
            end
            table.insert(stacks[key], item)
        end
        return stacks
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Stack grouping with quantity
    hook.Add("GetItemStacks", "QuantityStacks", function(inventory)
        local stacks = {}
        for _, item in pairs(inventory:getItems()) do
            local key = hook.Run("GetItemStackKey", item) or item.uniqueID
            if not stacks[key] then
                stacks[key] = {
                    items = {},
                    quantity = 0
                }
            end
            table.insert(stacks[key].items, item)
            stacks[key].quantity = stacks[key].quantity + (item:getData("quantity", 1))
        end
        return stacks
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced stack management
    hook.Add("GetItemStacks", "AdvancedStacks", function(inventory)
        if not inventory then return {} end

        local stacks = {}
        local items = inventory:getItems()

        for _, item in pairs(items) do
            -- Get stack key
            local key = hook.Run("GetItemStackKey", item) or item.uniqueID

            -- Initialize stack if needed
            if not stacks[key] then
                stacks[key] = {
                    items = {},
                    totalQuantity = 0,
                    maxStack = item.maxStack or 1,
                    stackKey = key,
                    itemType = item.uniqueID
                }
            end

            -- Add item to stack
            table.insert(stacks[key].items, item)
            
            -- Calculate total quantity
            local quantity = item:getData("quantity", 1)
            stacks[key].totalQuantity = stacks[key].totalQuantity + quantity

            -- Calculate average durability
            local durability = item:getData("durability", 100)
            if not stacks[key].avgDurability then
                stacks[key].avgDurability = durability
            else
                stacks[key].avgDurability = (stacks[key].avgDurability + durability) / 2
            end

            -- Track stack space remaining
            stacks[key].remainingSpace = (stacks[key].maxStack * #stacks[key].items) - stacks[key].totalQuantity
        end

        -- Remove empty stacks
        for key, stack in pairs(stacks) do
            if #stack.items == 0 then
                stacks[key] = nil
            end
        end

        return stacks
    end)
    ```
]]
function GetMaxPlayerChar(client)
end

--[[
    Purpose:
        Retrieves or calculates the maximum number of characters a player can have

    When Called:
        When checking character limits during character creation or management

    Parameters:
        - client (Player): The player whose character limit is being checked

    Returns:
        number - The maximum number of characters the player can have

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default limit
    hook.Add("GetMaxPlayerChar", "DefaultLimit", function(client)
        return 5 -- Default 5 characters per player
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: VIP-based limits
    hook.Add("GetMaxPlayerChar", "VIPLimit", function(client)
        local baseLimit = lia.config.get("maxCharacters", 5)
        
        if client:hasPrivilege("vip") then
            return baseLimit + 3 -- VIP gets 3 extra slots
        end
        
        return baseLimit
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character limit system
    hook.Add("GetMaxPlayerChar", "AdvancedLimit", function(client)
        local baseLimit = lia.config.get("maxCharacters", 5)

        -- VIP tiers
        if client:hasPrivilege("vip_premium") then
            baseLimit = baseLimit + 5 -- Premium VIP
        elseif client:hasPrivilege("vip") then
            baseLimit = baseLimit + 2 -- Regular VIP
        end

        -- Patron/donator bonuses
        if client:hasPrivilege("patron") then
            baseLimit = baseLimit + 1
        end

        -- Time-based bonus (long-time players)
        local accountAge = os.time() - (client:GetCreationTime() or os.time())
        local daysOld = accountAge / 86400
        if daysOld > 365 then
            baseLimit = baseLimit + 1 -- 1 year = +1 slot
        end

        -- Hard limit cap
        local maxLimit = lia.config.get("hardMaxCharacters", 10)
        baseLimit = math.min(baseLimit, maxLimit)

        -- Minimum limit
        baseLimit = math.max(baseLimit, 1)

        return baseLimit
    end)
    ```
]]
function GetMaxStartingAttributePoints(client, count)
end

--[[
    Purpose:
        Retrieves or calculates the maximum starting attribute points for character creation

    When Called:
        When a player is creating a new character and needs to know how many attribute points they can allocate

    Parameters:
        - client (Player): The player creating the character
        - count (number): The current/default count of starting points

    Returns:
        number - The maximum number of starting attribute points available

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default points
    hook.Add("GetMaxStartingAttributePoints", "DefaultPoints", function(client, count)
        return count or 100 -- Default starting points
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: VIP bonus points
    hook.Add("GetMaxStartingAttributePoints", "VIPPoints", function(client, count)
        local basePoints = count or 100
        
        if client:hasPrivilege("vip") then
            return basePoints + 20 -- VIP gets 20 extra points
        end
        
        return basePoints
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced starting points system
    hook.Add("GetMaxStartingAttributePoints", "AdvancedPoints", function(client, count)
        local basePoints = count or 100

        -- VIP tier bonuses
        if client:hasPrivilege("vip_premium") then
            basePoints = basePoints + 50 -- Premium VIP
        elseif client:hasPrivilege("vip") then
            basePoints = basePoints + 25 -- Regular VIP
        end

        -- Patron bonus
        if client:hasPrivilege("patron") then
            basePoints = basePoints + 10
        end

        -- Time-based bonus (reward long-term players)
        local accountAge = os.time() - (client:GetCreationTime() or os.time())
        local daysOld = accountAge / 86400
        if daysOld > 730 then -- 2 years
            basePoints = basePoints + 15
        elseif daysOld > 365 then -- 1 year
            basePoints = basePoints + 10
        end

        -- Character count bonus (reward players with many characters)
        local charCount = client:getCharCount() or 0
        if charCount >= 5 then
            basePoints = basePoints + 5 -- Loyalty bonus
        end

        -- Hard limit
        local maxPoints = lia.config.get("maxStartingAttributePoints", 200)
        basePoints = math.min(basePoints, maxPoints)

        -- Minimum points
        basePoints = math.max(basePoints, 50)

        return basePoints
    end)
    ```
]]
function GetMoneyModel(amount)
end

--[[
    Purpose:
        Retrieves the model path for a money entity based on the amount

    When Called:
        When money is dropped or spawned and needs a 3D model based on the amount

    Parameters:
        - amount (number): The amount of money being displayed

    Returns:
        string - The model path for the money entity

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Single money model
    hook.Add("GetMoneyModel", "DefaultModel", function(amount)
        return "models/props_c17/BriefCase001a.mdl"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Amount-based models
    hook.Add("GetMoneyModel", "AmountModels", function(amount)
        if amount >= 1000 then
            return "models/props_c17/BriefCase001a.mdl" -- Large amount = briefcase
        elseif amount >= 100 then
            return "models/props_junk/cardboard_box004a.mdl" -- Medium = box
        else
            return "models/props_junk/garbage_bag001a.mdl" -- Small = bag
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced money model selection
    hook.Add("GetMoneyModel", "AdvancedModel", function(amount)
        local currency = lia.config.get("currency", "$")
        
        -- Determine denomination based on amount
        if amount >= 10000 then
            return "models/props_c17/BriefCase001a.mdl" -- Briefcase for large amounts
        elseif amount >= 5000 then
            return "models/props_c17/SuitCase001a.mdl" -- Suitcase for medium-large
        elseif amount >= 1000 then
            return "models/props_junk/cardboard_box004a.mdl" -- Box for medium
        elseif amount >= 500 then
            return "models/props_junk/garbage_bag001a.mdl" -- Bag for small-medium
        elseif amount >= 100 then
            return "models/props_junk/garbage_plasticbag_001a.mdl" -- Plastic bag for small
        else
            return "models/Items/item_item_crate.mdl" -- Crate for very small amounts
        end
    end)
    ```
]]
function GetOOCDelay(speaker)
end

--[[
    Purpose:
        Retrieves or calculates the delay/cooldown for OOC (Out Of Character) chat messages

    When Called:
        When a player attempts to send an OOC message and the system needs to check the cooldown

    Parameters:
        - speaker (Player): The player sending the OOC message

    Returns:
        number - The delay in seconds before the player can send another OOC message

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default delay
    hook.Add("GetOOCDelay", "DefaultDelay", function(speaker)
        return 5 -- 5 second delay between OOC messages
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Rank-based delays
    hook.Add("GetOOCDelay", "RankDelay", function(speaker)
        if speaker:IsAdmin() then
            return 2 -- Admins have shorter delay
        end
        
        return 5 -- Default delay for regular players
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced OOC delay system
    hook.Add("GetOOCDelay", "AdvancedDelay", function(speaker)
        local baseDelay = lia.config.get("oocDelay", 5)

        -- Admin privileges
        if speaker:IsSuperAdmin() then
            baseDelay = 0 -- No delay for superadmins
        elseif speaker:IsAdmin() then
            baseDelay = 1 -- Short delay for admins
        end

        -- VIP bonus
        if speaker:hasPrivilege("vip") then
            baseDelay = baseDelay * 0.5 -- 50% reduction
        end

        -- Check for spam (recent messages)
        local lastOOC = speaker:getLiliaData("lastOOCTime", 0)
        local recentOOC = CurTime() - lastOOC
        
        if recentOOC < 10 then
            -- Sent OOC recently, increase delay
            baseDelay = baseDelay * 2
        end

        -- Account age bonus (older accounts get shorter delays)
        local accountAge = os.time() - (speaker:GetCreationTime() or os.time())
        local daysOld = accountAge / 86400
        if daysOld > 180 then -- 6 months
            baseDelay = baseDelay * 0.8 -- 20% reduction
        end

        -- Minimum delay
        baseDelay = math.max(baseDelay, 1)

        return baseDelay
    end)
    ```
]]
function GetPlayTime(client)
end

--[[
    Purpose:
        Retrieves or calculates the total playtime for a player

    When Called:
        When the system needs to get a player's total time spent playing

    Parameters:
        - client (Player): The player whose playtime is being calculated

    Returns:
        number - The total playtime in seconds

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Get character playtime
    hook.Add("GetPlayTime", "CharPlaytime", function(client)
        local char = client:getChar()
        if char then
            return char:getPlayTime() or 0
        end
        return 0
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Total account playtime
    hook.Add("GetPlayTime", "TotalPlaytime", function(client)
        local totalTime = 0
        
        -- Sum all character playtimes
        lia.db.select({"playtime"}, "characters", 
            "steamID = " .. lia.db.convertDataType(client:SteamID())):next(function(results)
            if results then
                for _, char in ipairs(results) do
                    totalTime = totalTime + (char.playtime or 0)
                end
            end
        end)
        
        return totalTime
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced playtime calculation with session tracking
    hook.Add("GetPlayTime", "AdvancedPlaytime", function(client)
        local char = client:getChar()
        local totalTime = 0

        -- Get stored playtime from character
        if char then
            totalTime = char:getPlayTime() or 0
            
            -- Add current session time
            local loginTime = char:getLoginTime()
            if loginTime and loginTime > 0 then
                totalTime = totalTime + (os.time() - loginTime)
            end
        end

        -- Get total playtime across all characters
        lia.db.select({"SUM(playtime) as total"}, "characters", 
            "steamID = " .. lia.db.convertDataType(client:SteamID())):next(function(result)
            if result and result.total then
                -- Use database total if available (more accurate)
                totalTime = result.total
                
                -- Add current session if character exists
                if char then
                    local loginTime = char:getLoginTime()
                    if loginTime and loginTime > 0 then
                        totalTime = totalTime + (os.time() - loginTime)
                    end
                end
            end
        end)

        -- Return playtime in seconds
        return totalTime
    end)
    ```
]]
function GetPlayerDeathSound(client, isFemale)
end

--[[
    Purpose:
        Retrieves the sound path to play when a player dies

    When Called:
        When a player dies and the death sound needs to be determined

    Parameters:
        - client (Player): The player who died
        - isFemale (boolean): Whether the player character is female

    Returns:
        string - The sound path to play for the death sound

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Default death sound
    hook.Add("GetPlayerDeathSound", "DefaultSound", function(client, isFemale)
        return "vo/npc/male01/pain07.wav"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Gender-based sounds
    hook.Add("GetPlayerDeathSound", "GenderSound", function(client, isFemale)
        if isFemale then
            return "vo/npc/female01/pain07.wav"
        else
            return "vo/npc/male01/pain07.wav"
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced death sound system
    hook.Add("GetPlayerDeathSound", "AdvancedSound", function(client, isFemale)
        local char = client:getChar()
        local deathSounds = {}

        -- Gender-based sound pools
        if isFemale then
            deathSounds = {
                "vo/npc/female01/pain07.wav",
                "vo/npc/female01/pain08.wav",
                "vo/npc/female01/pain09.wav"
            }
        else
            deathSounds = {
                "vo/npc/male01/pain07.wav",
                "vo/npc/male01/pain08.wav",
                "vo/npc/male01/pain09.wav"
            }
        end

        -- Check for custom death sound
        if char then
            local customSound = char:getData("deathSound")
            if customSound and customSound ~= "" then
                return customSound
            end

            -- Faction-specific death sounds
            local faction = lia.faction.indices[char:getFaction()]
            if faction and faction.deathSounds then
                if isFemale and faction.deathSounds.female then
                    return faction.deathSounds.female[math.random(#faction.deathSounds.female)]
                elseif faction.deathSounds.male then
                    return faction.deathSounds.male[math.random(#faction.deathSounds.male)]
                end
            end
        end

        -- Random selection from pool
        return deathSounds[math.random(#deathSounds)]
    end)
    ```
]]
function GetPlayerPainSound(client, paintype, isFemale)
end

--[[
    Purpose:
        Retrieves the sound path to play when a player takes damage/experiences pain

    When Called:
        When a player is damaged and a pain sound needs to be played

    Parameters:
        - client (Player): The player experiencing pain
        - paintype (string): The type of pain (e.g., "small", "medium", "large")
        - isFemale (boolean): Whether the player character is female

    Returns:
        string - The sound path to play for the pain sound

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Default pain sound
    hook.Add("GetPlayerPainSound", "DefaultSound", function(client, paintype, isFemale)
        return "vo/npc/male01/pain01.wav"
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Gender and pain type based sounds
    hook.Add("GetPlayerPainSound", "TypeSound", function(client, paintype, isFemale)
        local sounds = {
            male = {
                small = "vo/npc/male01/pain01.wav",
                medium = "vo/npc/male01/pain05.wav",
                large = "vo/npc/male01/pain09.wav"
            },
            female = {
                small = "vo/npc/female01/pain01.wav",
                medium = "vo/npc/female01/pain05.wav",
                large = "vo/npc/female01/pain09.wav"
            }
        }

        local gender = isFemale and "female" or "male"
        local type = paintype or "medium"
        
        return sounds[gender][type] or sounds[gender].medium
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced pain sound system
    hook.Add("GetPlayerPainSound", "AdvancedSound", function(client, paintype, isFemale)
        local char = client:getChar()
        local sounds = {}

        -- Gender-based sound pools
        if isFemale then
            sounds = {
                small = {"vo/npc/female01/pain01.wav", "vo/npc/female01/pain02.wav"},
                medium = {"vo/npc/female01/pain05.wav", "vo/npc/female01/pain06.wav"},
                large = {"vo/npc/female01/pain09.wav", "vo/npc/female01/pain10.wav"}
            }
        else
            sounds = {
                small = {"vo/npc/male01/pain01.wav", "vo/npc/male01/pain02.wav"},
                medium = {"vo/npc/male01/pain05.wav", "vo/npc/male01/pain06.wav"},
                large = {"vo/npc/male01/pain09.wav", "vo/npc/male01/pain10.wav"}
            }
        end

        -- Check for custom pain sound
        if char then
            local customSound = char:getData("painSound")
            if customSound and customSound ~= "" then
                return customSound
            end

            -- Faction-specific sounds
            local faction = lia.faction.indices[char:getFaction()]
            if faction and faction.painSounds then
                local factionSounds = faction.painSounds[paintype or "medium"]
                if factionSounds then
                    local genderSounds = isFemale and factionSounds.female or factionSounds.male
                    if genderSounds then
                        return genderSounds[math.random(#genderSounds)]
                    end
                end
            end
        end

        -- Default to medium pain if type not specified
        local type = paintype or "medium"
        local soundPool = sounds[type] or sounds.medium

        return soundPool[math.random(#soundPool)]
    end)
    ```
]]
function GetPlayerPunchDamage(client)
end

--[[
    Purpose:
        Retrieves or calculates the damage dealt by a player's unarmed punch

    When Called:
        When a player punches another player or entity and damage needs to be calculated

    Parameters:
        - client (Player): The player performing the punch

    Returns:
        number - The damage amount dealt by the punch

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default damage
    hook.Add("GetPlayerPunchDamage", "DefaultDamage", function(client)
        return 10 -- Default punch damage
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Strength-based damage
    hook.Add("GetPlayerPunchDamage", "StrengthDamage", function(client)
        local char = client:getChar()
        if not char then return 10 end

        local strength = char:getAttrib("strength", 50)
        local damage = 5 + (strength / 5) -- 5 to 25 damage based on strength

        return damage
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced punch damage calculation
    hook.Add("GetPlayerPunchDamage", "AdvancedDamage", function(client)
        local char = client:getChar()
        if not char then return 10 end

        local baseDamage = 10

        -- Strength attribute bonus
        local strength = char:getAttrib("strength", 50)
        baseDamage = baseDamage + ((strength - 50) / 2) -- +0.5 damage per point above 50

        -- Endurance affects consistency
        local endurance = char:getAttrib("endurance", 50)
        if endurance > 70 then
            baseDamage = baseDamage * 1.1 -- 10% bonus for high endurance
        end

        -- Equipment bonuses (gloves, etc.)
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") and item.punchDamageBonus then
                    baseDamage = baseDamage + item.punchDamageBonus
                end
            end
        end

        -- Faction bonuses
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.punchDamageBonus then
            baseDamage = baseDamage + faction.punchDamageBonus
        end

        -- Stamina penalty
        local stamina = char:getAttrib("stamina", 100)
        if stamina < 20 then
            baseDamage = baseDamage * 0.5 -- Very tired, much weaker
        elseif stamina < 50 then
            baseDamage = baseDamage * 0.75 -- Tired, weaker
        end

        -- Damage limits
        baseDamage = math.max(5, math.min(baseDamage, 50)) -- Between 5 and 50

        return math.floor(baseDamage)
    end)
    ```
]]
function GetPlayerPunchRagdollTime(client)
end

--[[
    Purpose:
        Retrieves or calculates how long a player stays ragdolled after being punched

    When Called:
        When a player is punched and the ragdoll duration needs to be determined

    Parameters:
        - client (Player): The player who was punched

    Returns:
        number - The ragdoll duration in seconds

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default ragdoll time
    hook.Add("GetPlayerPunchRagdollTime", "DefaultTime", function(client)
        return 2.0 -- 2 seconds ragdoll
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Strength-based ragdoll time
    hook.Add("GetPlayerPunchRagdollTime", "StrengthTime", function(client)
        local char = client:getChar()
        if not char then return 2.0 end

        local strength = char:getAttrib("strength", 50)
        local ragdollTime = 3.0 - (strength / 50) -- Stronger players ragdoll less

        return math.max(0.5, math.min(ragdollTime, 5.0))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ragdoll time calculation
    hook.Add("GetPlayerPunchRagdollTime", "AdvancedTime", function(client)
        local char = client:getChar()
        if not char then return 2.0 end

        local baseTime = 2.0

        -- Strength reduces ragdoll time
        local strength = char:getAttrib("strength", 50)
        baseTime = baseTime - ((strength - 50) / 50) -- -0.02 seconds per strength point above 50

        -- Endurance reduces ragdoll time
        local endurance = char:getAttrib("endurance", 50)
        baseTime = baseTime - ((endurance - 50) / 100) -- -0.01 seconds per endurance point

        -- Equipment bonuses (armor reduces ragdoll)
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip") and item.ragdollReduction then
                    baseTime = baseTime - item.ragdollReduction
                end
            end
        end

        -- Faction bonuses
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.ragdollReduction then
            baseTime = baseTime - faction.ragdollReduction
        end

        -- Health-based (low health = longer ragdoll)
        local health = client:Health()
        if health < 30 then
            baseTime = baseTime * 1.5 -- 50% longer when low health
        end

        -- Limits
        baseTime = math.max(0.1, math.min(baseTime, 8.0)) -- Between 0.1 and 8 seconds

        return baseTime
    end)
    ```
]]
function GetPriceOverride(self, uniqueID, price, isSellingToVendor)
end

--[[
    Purpose:
        Modifies or overrides the price of an item when trading with a vendor

    When Called:
        When determining the price of an item during a vendor transaction (buying or selling)

    Parameters:
        - self (Entity): The vendor entity
        - uniqueID (string): The item's unique identifier
        - price (number): The current/default price
        - isSellingToVendor (boolean): True if player is selling to vendor, false if buying

    Returns:
        number - The modified price for the transaction

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return original price
    hook.Add("GetPriceOverride", "DefaultPrice", function(self, uniqueID, price, isSellingToVendor)
        return price
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Discount for selling
    hook.Add("GetPriceOverride", "SellDiscount", function(self, uniqueID, price, isSellingToVendor)
        if isSellingToVendor then
            return price * 0.5 -- Vendors pay 50% of item value when buying from player
        end
        return price
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced price modification system
    hook.Add("GetPriceOverride", "AdvancedPrice", function(self, uniqueID, price, isSellingToVendor)
        local itemTable = lia.item.list[uniqueID]
        if not itemTable then return price end

        local modifiedPrice = price

        -- Vendor-specific pricing
        if IsValid(self) then
            local vendorType = self:getNetVar("vendorType", "")
            
            -- Specialized vendors pay more for their specialty
            if vendorType == "weapon_dealer" and itemTable.category == "weapon" then
                if isSellingToVendor then
                    modifiedPrice = modifiedPrice * 1.2 -- 20% bonus for selling weapons to weapon dealer
                else
                    modifiedPrice = modifiedPrice * 0.9 -- 10% discount buying from specialist
                end
            end
        end

        -- Item condition affects selling price
        if isSellingToVendor then
            -- Check if we have item instance data
            local durability = itemTable.durability or 100
            if durability < 50 then
                modifiedPrice = modifiedPrice * 0.5 -- Damaged items worth less
            elseif durability < 80 then
                modifiedPrice = modifiedPrice * 0.75 -- Slightly damaged
            end

            -- Vendor buy price is typically lower
            modifiedPrice = modifiedPrice * 0.6 -- Base 60% when selling to vendor
        end

        -- Market fluctuations
        local marketMultiplier = GetGlobalFloat("MarketMultiplier", 1.0)
        modifiedPrice = modifiedPrice * marketMultiplier

        -- Ensure minimum price
        modifiedPrice = math.max(modifiedPrice, 1)

        return math.floor(modifiedPrice)
    end)
    ```
]]
function GetRagdollTime(self, time)
end

--[[
    Purpose:
        Retrieves or calculates how long an entity stays in ragdoll state

    When Called:
        When an entity is ragdolled and the duration needs to be determined

    Parameters:
        - self (Entity): The entity that is ragdolled (typically a player)
        - time (number): The current/default ragdoll time

    Returns:
        number - The ragdoll duration in seconds

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default time
    hook.Add("GetRagdollTime", "DefaultTime", function(self, time)
        return time or 5.0 -- Default 5 seconds
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Player-based ragdoll time
    hook.Add("GetRagdollTime", "PlayerTime", function(self, time)
        if self:IsPlayer() then
            local char = self:getChar()
            if char then
                local strength = char:getAttrib("strength", 50)
                local ragdollTime = time - (strength / 50) -- Stronger players ragdoll less
                return math.max(1.0, ragdollTime)
            end
        end
        return time or 5.0
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ragdoll time system
    hook.Add("GetRagdollTime", "AdvancedTime", function(self, time)
        local baseTime = time or 5.0

        if self:IsPlayer() then
            local char = self:getChar()
            if char then
                -- Strength reduces ragdoll time
                local strength = char:getAttrib("strength", 50)
                baseTime = baseTime - ((strength - 50) / 25)

                -- Endurance reduces ragdoll time
                local endurance = char:getAttrib("endurance", 50)
                baseTime = baseTime - ((endurance - 50) / 50)

                -- Equipment bonuses
                local inventory = char:getInv()
                if inventory then
                    for _, item in pairs(inventory:getItems()) do
                        if item:getData("equip") and item.ragdollReduction then
                            baseTime = baseTime - item.ragdollReduction
                        end
                    end
                end

                -- Health affects ragdoll time (low health = longer ragdoll)
                local health = self:Health()
                if health < 20 then
                    baseTime = baseTime * 2.0 -- Double time when critically injured
                elseif health < 50 then
                    baseTime = baseTime * 1.5 -- 50% longer when injured
                end
            end
        end

        -- Minimum and maximum limits
        baseTime = math.max(0.5, math.min(baseTime, 15.0))

        return baseTime
    end)
    ```
]]
function GetSalaryAmount(client, faction, class)
end

--[[
    Purpose:
        Calculates or retrieves the salary amount a player should receive based on their faction and class

    When Called:
        When a player's salary is being calculated during the salary payout cycle

    Parameters:
        - client (Player): The player receiving the salary
        - faction (table): The faction table for the player's faction (nil if no faction)
        - class (table): The class table for the player's class (nil if no class)

    Returns:
        number - The salary amount to pay the player (defaults to class.pay or faction.pay if nil)

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return class or faction pay
    hook.Add("GetSalaryAmount", "DefaultPay", function(client, faction, class)
        if class and class.pay then
            return class.pay
        elseif faction and faction.pay then
            return faction.pay
        end
        return 0
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Bonus pay based on playtime
    hook.Add("GetSalaryAmount", "PlaytimeBonus", function(client, faction, class)
        local basePay = (class and class.pay) or (faction and faction.pay) or 0
        
        local char = client:getChar()
        if not char then return basePay end

        local playtime = hook.Run("GetPlayTime", client) or 0
        local hours = playtime / 3600
        
        -- Bonus pay for experienced players
        if hours > 100 then
            basePay = basePay * 1.5 -- 50% bonus for 100+ hours
        elseif hours > 50 then
            basePay = basePay * 1.25 -- 25% bonus for 50+ hours
        end

        return math.floor(basePay)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced salary calculation system
    hook.Add("GetSalaryAmount", "AdvancedPay", function(client, faction, class)
        local basePay = (class and class.pay) or (faction and faction.pay) or 0
        
        local char = client:getChar()
        if not char then return basePay end

        -- Rank-based pay
        local rank = char:getData("rank", 1)
        basePay = basePay * (1 + (rank - 1) * 0.1) -- 10% per rank

        -- Playtime bonus
        local playtime = hook.Run("GetPlayTime", client) or 0
        local hours = playtime / 3600
        if hours > 200 then
            basePay = basePay * 1.2
        elseif hours > 100 then
            basePay = basePay * 1.1
        end

        -- Performance bonus (based on recent activity)
        local recentActivity = char:getData("recentActivity", 0)
        if recentActivity > 80 then
            basePay = basePay * 1.15 -- 15% bonus for high activity
        end

        -- Faction bonuses
        if faction and faction.salaryBonus then
            basePay = basePay + faction.salaryBonus
        end

        -- Class bonuses
        if class and class.salaryBonus then
            basePay = basePay + class.salaryBonus
        end

        -- Minimum wage protection
        local minWage = lia.config.get("minWage", 0)
        basePay = math.max(basePay, minWage)

        return math.floor(basePay)
    end)
    ```
]]
function GetTicketsByRequester(steamID)
end

--[[
    Purpose:
        Retrieves ticket claims that were created by a specific requester based on their Steam ID

    When Called:
        When an admin wants to view all tickets submitted by a specific player

    Parameters:
        - steamID (string): The Steam ID of the player who created the tickets

    Returns:
        table - An array of ticket claim objects containing timestamp, requester, requesterSteamID, admin, adminSteamID, and message

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return tickets from administration module
    hook.Add("GetTicketsByRequester", "DefaultTickets", function(steamID)
        local adminModule = lia.module.get("administration")
        if adminModule then
            return adminModule:GetTicketsByRequester(steamID)
        end
        return deferred.resolve({})
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter recent tickets
    hook.Add("GetTicketsByRequester", "RecentTickets", function(steamID)
        local adminModule = lia.module.get("administration")
        if not adminModule then return deferred.resolve({}) end

        return adminModule:GetTicketsByRequester(steamID):next(function(tickets)
            local recentTickets = {}
            local cutoffTime = os.time() - (30 * 24 * 3600) -- Last 30 days

            for _, ticket in ipairs(tickets) do
                local ticketTime = isnumber(ticket.timestamp) and ticket.timestamp or os.time(lia.time.toNumber(ticket.timestamp))
                if ticketTime >= cutoffTime then
                    table.insert(recentTickets, ticket)
                end
            end

            return recentTickets
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ticket filtering and statistics
    hook.Add("GetTicketsByRequester", "AdvancedTickets", function(steamID)
        local adminModule = lia.module.get("administration")
        if not adminModule then return deferred.resolve({}) end

        return adminModule:GetTicketsByRequester(steamID):next(function(tickets)
            local filteredTickets = {}
            local stats = {
                total = #tickets,
                resolved = 0,
                pending = 0,
                byAdmin = {}
            }

            for _, ticket in ipairs(tickets) do
                -- Count resolved vs pending
                if ticket.admin and ticket.admin ~= "" then
                    stats.resolved = stats.resolved + 1
                    
                    -- Track which admins handled tickets
                    if ticket.adminSteamID then
                        stats.byAdmin[ticket.adminSteamID] = (stats.byAdmin[ticket.adminSteamID] or 0) + 1
                    end
                else
                    stats.pending = stats.pending + 1
                end

                -- Add metadata to ticket
                ticket.stats = stats
                ticket.age = os.time() - (isnumber(ticket.timestamp) and ticket.timestamp or os.time(lia.time.toNumber(ticket.timestamp)))
                ticket.isOld = ticket.age > (90 * 24 * 3600) -- Older than 90 days

                table.insert(filteredTickets, ticket)
            end

            -- Sort by timestamp (newest first)
            table.sort(filteredTickets, function(a, b)
                local timeA = isnumber(a.timestamp) and a.timestamp or os.time(lia.time.toNumber(a.timestamp))
                local timeB = isnumber(b.timestamp) and b.timestamp or os.time(lia.time.toNumber(b.timestamp))
                return timeA > timeB
            end)

            return filteredTickets
        end)
    end)
    ```
]]
function GetVendorSaleScale(self)
end

--[[
    Purpose:
        Retrieves or calculates the sale scale (price multiplier) used when players sell items to a vendor

    When Called:
        When determining how much a vendor should pay for items sold by players

    Parameters:
        - self (Entity): The vendor entity

    Returns:
        number - The sale scale multiplier (0.1 to 2.0, typically 0.5 means vendors pay 50% of item value)

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return default scale from config
    hook.Add("GetVendorSaleScale", "DefaultScale", function(self)
        return lia.config.get("vendorSaleScale", 0.5)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Vendor type-based scales
    hook.Add("GetVendorSaleScale", "TypeScale", function(self)
        if not IsValid(self) then return 0.5 end

        local vendorType = self:getNetVar("vendorType", "")
        local scales = {
            ["weapon_dealer"] = 0.6, -- Better prices for weapons
            ["general_store"] = 0.5, -- Standard
            ["pawn_shop"] = 0.3, -- Lower prices
            ["premium_shop"] = 0.7 -- Higher prices
        }

        return scales[vendorType] or 0.5
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced dynamic pricing system
    hook.Add("GetVendorSaleScale", "AdvancedScale", function(self)
        if not IsValid(self) then return 0.5 end

        local baseScale = lia.config.get("vendorSaleScale", 0.5)

        -- Vendor type modifiers
        local vendorType = self:getNetVar("vendorType", "")
        local typeModifiers = {
            ["weapon_dealer"] = 1.2,
            ["general_store"] = 1.0,
            ["pawn_shop"] = 0.6,
            ["premium_shop"] = 1.4
        }
        baseScale = baseScale * (typeModifiers[vendorType] or 1.0)

        -- Location-based pricing
        local position = self:GetPos()
        local zone = lia.zone.get(position)
        if zone then
            if zone.wealthy then
                baseScale = baseScale * 1.1 -- Wealthy areas pay more
            elseif zone.poor then
                baseScale = baseScale * 0.9 -- Poor areas pay less
            end
        end

        -- Market demand (if implemented)
        local marketMultiplier = GetGlobalFloat("MarketDemandMultiplier", 1.0)
        baseScale = baseScale * marketMultiplier

        -- Vendor inventory space affects pricing
        local vendorInv = self:getInv()
        if vendorInv then
            local usedSlots = vendorInv:getItemCount()
            local maxSlots = vendorInv.w * vendorInv.h
            if usedSlots / maxSlots > 0.8 then
                baseScale = baseScale * 0.8 -- Lower prices when vendor inventory is full
            end
        end

        -- Clamp between 0.1 and 2.0
        return math.Clamp(baseScale, 0.1, 2.0)
    end)
    ```
]]
function GetWarnings(charID)
end

--[[
    Purpose:
        Retrieves all warnings issued to a specific character

    When Called:
        When an admin needs to view a player's warning history or when checking warning count

    Parameters:
        - charID (number): The character ID to retrieve warnings for

    Returns:
        table - An array of warning objects containing id, timestamp, message, warner, and warnerSteamID

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return warnings from administration module
    hook.Add("GetWarnings", "DefaultWarnings", function(charID)
        local adminModule = lia.module.get("administration")
        if adminModule then
            return adminModule:GetWarnings(charID)
        end
        return deferred.resolve({})
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter active warnings (not expired)
    hook.Add("GetWarnings", "ActiveWarnings", function(charID)
        local adminModule = lia.module.get("administration")
        if not adminModule then return deferred.resolve({}) end

        return adminModule:GetWarnings(charID):next(function(warnings)
            local activeWarnings = {}
            local currentTime = os.time()
            local warningExpiry = lia.config.get("warningExpiry", 2592000) -- 30 days default

            for _, warn in ipairs(warnings) do
                local warnTime = isnumber(warn.timestamp) and warn.timestamp or os.time(lia.time.toNumber(warn.timestamp))
                if (currentTime - warnTime) < warningExpiry then
                    table.insert(activeWarnings, warn)
                end
            end

            return activeWarnings
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced warning system with statistics
    hook.Add("GetWarnings", "AdvancedWarnings", function(charID)
        local adminModule = lia.module.get("administration")
        if not adminModule then return deferred.resolve({}) end

        return adminModule:GetWarnings(charID):next(function(warnings)
            local processedWarnings = {}
            local stats = {
                total = #warnings,
                active = 0,
                expired = 0,
                recent = 0, -- Last 7 days
                severe = 0
            }

            local currentTime = os.time()
            local warningExpiry = lia.config.get("warningExpiry", 2592000)
            local recentCutoff = currentTime - (7 * 24 * 3600)

            for _, warn in ipairs(warnings) do
                local warnTime = isnumber(warn.timestamp) and warn.timestamp or os.time(lia.time.toNumber(warn.timestamp))
                local age = currentTime - warnTime
                local isExpired = age > warningExpiry
                local isRecent = age < (7 * 24 * 3600)

                -- Check for severe warnings (keywords or all caps)
                local isSevere = false
                if warn.message then
                    local upperMessage = string.upper(warn.message)
                    if upperMessage == warn.message and string.len(warn.message) > 10 then
                        isSevere = true -- All caps messages
                    elseif string.find(string.lower(warn.message), "ban|kick|serious|severe") then
                        isSevere = true -- Contains severe keywords
                    end
                end

                -- Add metadata
                warn.age = age
                warn.isExpired = isExpired
                warn.isRecent = isRecent
                warn.isSevere = isSevere
                warn.formattedDate = os.date("%Y-%m-%d %H:%M:%S", warnTime)

                -- Update stats
                if isExpired then
                    stats.expired = stats.expired + 1
                else
                    stats.active = stats.active + 1
                end
                if isRecent then stats.recent = stats.recent + 1 end
                if isSevere then stats.severe = stats.severe + 1 end

                table.insert(processedWarnings, warn)
            end

            -- Sort by timestamp (newest first)
            table.sort(processedWarnings, function(a, b)
                local timeA = isnumber(a.timestamp) and a.timestamp or os.time(lia.time.toNumber(a.timestamp))
                local timeB = isnumber(b.timestamp) and b.timestamp or os.time(lia.time.toNumber(b.timestamp))
                return timeA > timeB
            end)

            -- Add stats to first warning for easy access
            if #processedWarnings > 0 then
                processedWarnings[1].stats = stats
            end

            return processedWarnings
        end)
    end)
    ```
]]
function GetWarningsByIssuer(steamID)
end

--[[
    Purpose:
        Retrieves all warnings that were issued by a specific admin based on their Steam ID

    When Called:
        When an admin wants to view all warnings they have issued, or when auditing admin warning activity

    Parameters:
        - steamID (string): The Steam ID of the admin who issued the warnings

    Returns:
        table - An array of warning objects containing id, timestamp, message, warned, warnedSteamID, warner, and warnerSteamID

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Return warnings from administration module
    hook.Add("GetWarningsByIssuer", "DefaultWarnings", function(steamID)
        local adminModule = lia.module.get("administration")
        if adminModule then
            return adminModule:GetWarningsByIssuer(steamID)
        end
        return deferred.resolve({})
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter recent warnings and count by target
    hook.Add("GetWarningsByIssuer", "RecentWarnings", function(steamID)
        local adminModule = lia.module.get("administration")
        if not adminModule then return deferred.resolve({}) end

        return adminModule:GetWarningsByIssuer(steamID):next(function(warnings)
            local recentWarnings = {}
            local byTarget = {}
            local cutoffTime = os.time() - (30 * 24 * 3600) -- Last 30 days

            for _, warn in ipairs(warnings) do
                local warnTime = isnumber(warn.timestamp) and warn.timestamp or os.time(lia.time.toNumber(warn.timestamp))
                if warnTime >= cutoffTime then
                    table.insert(recentWarnings, warn)

                    -- Count warnings per target
                    local targetID = warn.warnedSteamID or warn.warned or "unknown"
                    byTarget[targetID] = (byTarget[targetID] or 0) + 1
                end
            end

            -- Add statistics
            if #recentWarnings > 0 then
                recentWarnings.byTarget = byTarget
                recentWarnings.totalTargets = table.Count(byTarget)
            end

            return recentWarnings
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced warning statistics and analysis
    hook.Add("GetWarningsByIssuer", "AdvancedWarnings", function(steamID)
        local adminModule = lia.module.get("administration")
        if not adminModule then return deferred.resolve({}) end

        return adminModule:GetWarningsByIssuer(steamID):next(function(warnings)
            local processedWarnings = {}
            local stats = {
                total = #warnings,
                byTarget = {},
                byDate = {},
                recent = 0, -- Last 7 days
                thisMonth = 0,
                severity = {
                    low = 0,
                    medium = 0,
                    high = 0
                }
            }

            local currentTime = os.time()
            local recentCutoff = currentTime - (7 * 24 * 3600)
            local monthCutoff = currentTime - (30 * 24 * 3600)

            for _, warn in ipairs(warnings) do
                local warnTime = isnumber(warn.timestamp) and warn.timestamp or os.time(lia.time.toNumber(warn.timestamp))
                local age = currentTime - warnTime
                local dateKey = os.date("%Y-%m-%d", warnTime)

                -- Target statistics
                local targetID = warn.warnedSteamID or warn.warned or "unknown"
                if not stats.byTarget[targetID] then
                    stats.byTarget[targetID] = {
                        count = 0,
                        targets = {}
                    }
                end
                stats.byTarget[targetID].count = stats.byTarget[targetID].count + 1
                table.insert(stats.byTarget[targetID].targets, warn)

                -- Date statistics
                stats.byDate[dateKey] = (stats.byDate[dateKey] or 0) + 1

                -- Time-based counts
                if age < (7 * 24 * 3600) then stats.recent = stats.recent + 1 end
                if age < (30 * 24 * 3600) then stats.thisMonth = stats.thisMonth + 1 end

                -- Severity classification
                local messageLength = warn.message and string.len(warn.message) or 0
                if messageLength > 100 or string.find(string.lower(warn.message or ""), "ban|serious|severe") then
                    stats.severity.high = stats.severity.high + 1
                elseif messageLength > 50 then
                    stats.severity.medium = stats.severity.medium + 1
                else
                    stats.severity.low = stats.severity.low + 1
                end

                -- Add metadata
                warn.age = age
                warn.formattedDate = os.date("%Y-%m-%d %H:%M:%S", warnTime)
                warn.targetID = targetID

                table.insert(processedWarnings, warn)
            end

            -- Sort by timestamp (newest first)
            table.sort(processedWarnings, function(a, b)
                local timeA = isnumber(a.timestamp) and a.timestamp or os.time(lia.time.toNumber(a.timestamp))
                local timeB = isnumber(b.timestamp) and b.timestamp or os.time(lia.time.toNumber(b.timestamp))
                return timeA > timeB
            end)

            -- Add stats to first warning
            if #processedWarnings > 0 then
                processedWarnings.stats = stats
            end

            return processedWarnings
        end)
    end)
    ```
]]
function HandleItemTransferRequest(client, itemID, x, y, invID)
end

--[[
    Purpose:
        Handles a request to transfer an item from one inventory to another

    When Called:
        When a player requests to move an item from their inventory to another inventory (including dragging items, giving items, etc.)

    Parameters:
        - client (Player): The player making the transfer request
        - itemID (number): The ID of the item being transferred
        - x (number): The x position in the target inventory (can be nil)
        - y (number): The y position in the target inventory (can be nil)
        - invID (number): The ID of the target inventory to transfer the item to

    Returns:
        Promise/Deferred - Should return a promise that resolves when the transfer is complete, or rejects with an error

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all transfers
    hook.Add("HandleItemTransferRequest", "DefaultTransfer", function(client, itemID, x, y, invID)
        local inventoryModule = lia.module.get("inventory")
        if inventoryModule then
            return inventoryModule:HandleItemTransferRequest(client, itemID, x, y, invID)
        end
        return deferred.reject("Inventory module not found")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Log transfers
    hook.Add("HandleItemTransferRequest", "LogTransfers", function(client, itemID, x, y, invID)
        local item = lia.item.instances[itemID]
        local targetInv = lia.inventory.instances[invID]
        
        if item and targetInv then
            print(string.format("[Transfer] %s transferring %s to inventory %d", 
                client:Name(), item.name or item.uniqueID, invID))
        end

        local inventoryModule = lia.module.get("inventory")
        if inventoryModule then
            return inventoryModule:HandleItemTransferRequest(client, itemID, x, y, invID)
        end
        return deferred.reject("Inventory module not found")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced transfer validation and handling
    hook.Add("HandleItemTransferRequest", "AdvancedTransfer", function(client, itemID, x, y, invID)
        local item = lia.item.instances[itemID]
        local targetInv = lia.inventory.instances[invID]
        
        if not item then
            return deferred.reject("Item not found")
        end

        if not targetInv then
            return deferred.reject("Target inventory not found")
        end

        -- Check transfer permissions
        local char = client:getChar()
        if not char then
            return deferred.reject("No character")
        end

        -- Prevent transferring restricted items
        if item:getData("restricted") then
            local owner = item:getData("owner")
            if owner and owner ~= char:getID() then
                client:notifyError("This item is restricted!")
                return deferred.reject("Item is restricted")
            end
        end

        -- Rate limiting
        local transferKey = client:SteamID64() .. "_transfer"
        local lastTransfer = client:GetNWFloat(transferKey, 0)
        if CurTime() - lastTransfer < 0.1 then
            return deferred.reject("Transfer too fast")
        end
        client:SetNWFloat(transferKey, CurTime())

        -- Custom position validation
        if x and y then
            local canPlace = hook.Run("CanPlaceItemAtPosition", item, targetInv, x, y)
            if canPlace == false then
                return deferred.reject("Cannot place item at that position")
            end
        end

        -- Process transfer
        local inventoryModule = lia.module.get("inventory")
        if inventoryModule then
            return inventoryModule:HandleItemTransferRequest(client, itemID, x, y, invID):next(function()
                -- Transfer successful
                hook.Run("OnItemTransferred", client, item, targetInv)
            end)
        end

        return deferred.reject("Inventory module not found")
    end)
    ```
]]
function InitializeStorage(entity)
end

--[[
    Purpose:
        Initializes storage inventory for an entity (such as vehicle trunks or storage containers)

    When Called:
        When an entity that supports storage needs its inventory created or retrieved

    Parameters:
        - entity (Entity): The entity to initialize storage for

    Returns:
        Promise/Deferred - A promise that resolves with the inventory instance

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Default storage initialization
    hook.Add("InitializeStorage", "DefaultStorage", function(entity)
        local storageModule = lia.module.get("storage")
        if storageModule then
            return storageModule:InitializeStorage(entity)
        end
        return deferred.reject("Storage module not found")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Custom storage size based on entity type
    hook.Add("InitializeStorage", "CustomSizeStorage", function(entity)
        local storageModule = lia.module.get("storage")
        if not storageModule then
            return deferred.reject("Storage module not found")
        end

        return storageModule:InitializeStorage(entity):next(function(inventory)
            -- Set custom size for vehicles
            if entity:IsVehicle() then
                local vehicleClass = entity:GetVehicleClass()
                local sizes = {
                    [VEHICLE_CLASS_COMPACT] = {w = 3, h = 3},
                    [VEHICLE_CLASS_SEDAN] = {w = 4, h = 4},
                    [VEHICLE_CLASS_SUV] = {w = 5, h = 5},
                    [VEHICLE_CLASS_TRUCK] = {w = 6, h = 6}
                }
                
                local size = sizes[vehicleClass] or {w = 4, h = 4}
                inventory:setSize(size.w, size.h)
            end

            return inventory
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced storage system with access control
    hook.Add("InitializeStorage", "AdvancedStorage", function(entity)
        local storageModule = lia.module.get("storage")
        if not storageModule then
            return deferred.reject("Storage module not found")
        end

        return storageModule:InitializeStorage(entity):next(function(inventory)
            -- Vehicle-specific storage
            if entity:IsVehicle() then
                -- Set size based on vehicle properties
                local trunkCapacity = entity:getNetVar("trunkCapacity", 20)
                local width = math.min(10, math.ceil(math.sqrt(trunkCapacity)))
                local height = math.ceil(trunkCapacity / width)
                inventory:setSize(width, height)

                -- Add access rules for vehicle owner
                local owner = entity:getNetVar("owner")
                if owner then
                    inventory:addAccessRule(function(client, inv)
                        local char = client:getChar()
                        if char and char:getID() == owner then
                            return true
                        end
                        return false
                    end)
                end
            end

            -- Custom storage entity
            if entity:GetClass() == "lia_storage" then
                local storageType = entity:getNetVar("storageType", "general")
                local configs = {
                    small = {w = 3, h = 3},
                    medium = {w = 5, h = 5},
                    large = {w = 7, h = 7},
                    general = {w = 4, h = 4}
                }

                local config = configs[storageType] or configs.general
                inventory:setSize(config.w, config.h)

                -- Access control for restricted storage
                if entity:getNetVar("restricted", false) then
                    inventory:addAccessRule(function(client, inv)
                        return client:hasPrivilege("canAccessRestrictedStorage") or false
                    end)
                end
            end

            -- Initialize storage data
            hook.Run("OnStorageInitialized", entity, inventory)

            return inventory
        end)
    end)
    ```
]]
function InventoryDeleted(instance)
end

--[[
    Purpose:
        Called when an inventory instance is deleted or destroyed

    When Called:
        When an inventory is being deleted (e.g., character deletion, storage removal, bag destruction)

    Parameters:
        - instance (Inventory): The inventory instance that is being deleted

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log inventory deletions
    hook.Add("InventoryDeleted", "LogDeletions", function(instance)
        print(string.format("Inventory %d deleted", instance:getID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clean up related data
    hook.Add("InventoryDeleted", "CleanupData", function(instance)
        local invID = instance:getID()
        
        -- Remove any cached data for this inventory
        if lia.inventoryCache then
            lia.inventoryCache[invID] = nil
        end

        -- Close any open panels for this inventory (client-side would need net message)
        -- This is just server-side cleanup
        print(string.format("Cleaned up data for inventory %d", invID))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced cleanup and item handling
    hook.Add("InventoryDeleted", "AdvancedCleanup", function(instance)
        local invID = instance:getID()
        
        -- Handle items in deleted inventory
        local items = instance:getItems()
        for _, item in pairs(items) do
            -- Check if items should be preserved
            if item:getData("preserveOnDelete", false) then
                -- Transfer to overflow or admin inventory
                local adminInvID = lia.config.get("adminInventoryID")
                if adminInvID then
                    local adminInv = lia.inventory.instances[adminInvID]
                    if adminInv then
                        adminInv:add(adminInv:getEmptySlot(), item)
                        print(string.format("Preserved item %d to admin inventory", item:getID()))
                    end
                end
            else
                -- Mark item for deletion
                item:setData("markedForDeletion", true)
            end
        end

        -- Remove from tracking
        if lia.inventory.instances[invID] then
            lia.inventory.instances[invID] = nil
        end

        -- Clean up access rules
        if instance.accessRules then
            instance.accessRules = nil
        end

        -- Remove entity reference if it's a storage inventory
        for _, ent in pairs(ents.GetAll()) do
            if IsValid(ent) and ent:getNetVar("inv") == invID then
                ent:setNetVar("inv", nil)
            end
        end

        -- Notify clients to close panels
        net.Start("liaInventoryDeleted")
        net.WriteUInt(invID, 32)
        net.Broadcast()

        print(string.format("Advanced cleanup completed for inventory %d", invID))
    end)
    ```
]]
function InventoryItemAdded(inventory, item)
end

--[[
    Purpose:
        Called when an item is added to an inventory

    When Called:
        After an item is successfully added to an inventory (moved, transferred, or created)

    Parameters:
        - inventory (Inventory): The inventory instance the item was added to
        - item (Item): The item instance that was added

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item additions
    hook.Add("InventoryItemAdded", "LogAdditions", function(inventory, item)
        print(string.format("Item %s added to inventory %d", item.name or item.uniqueID, inventory:getID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Auto-stack items
    hook.Add("InventoryItemAdded", "AutoStack", function(inventory, item)
        -- Check if item supports stacking
        if item:getData("quantity", 1) > 1 then
            local stackKey = hook.Run("GetItemStackKey", item)
            if stackKey then
                -- Find existing stack
                for _, existingItem in pairs(inventory:getItems()) do
                    if existingItem:getID() ~= item:getID() then
                        local existingKey = hook.Run("GetItemStackKey", existingItem)
                        if existingKey == stackKey then
                            local maxStack = existingItem:getData("maxStack", 99)
                            local currentQty = existingItem:getData("quantity", 1)
                            local newQty = item:getData("quantity", 1)
                            
                            if currentQty + newQty <= maxStack then
                                existingItem:setData("quantity", currentQty + newQty)
                                item:remove()
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item management system
    hook.Add("InventoryItemAdded", "AdvancedManagement", function(inventory, item)
        local invID = inventory:getID()
        local char = inventory:getOwner()

        -- Weight management
        if char then
            local character = lia.char.loaded[char]
            if character then
                local currentWeight = inventory:getWeight()
                local maxWeight = hook.Run("GetMaxInventoryWeight", character) or 100
                
                if currentWeight > maxWeight then
                    -- Notify player of overweight
                    local client = character:getPlayer()
                    if IsValid(client) then
                        client:notifyWarning("Your inventory is overweight!")
                    end
                end
            end
        end

        -- Auto-equip certain items
        if item.autoEquip then
            local slot = item:getData("equipSlot")
            if slot then
                local char = inventory:getOwner()
                if char then
                    local character = lia.char.loaded[char]
                    if character then
                        item:call("onEquip", character:getPlayer(), character)
                    end
                end
            end
        end

        -- Trigger item-specific hooks
        if item.isBag then
            hook.Run("BagInventoryReady", item)
        end

        -- Update inventory statistics
        local stats = inventory:getData("stats", {})
        stats.totalItems = (stats.totalItems or 0) + 1
        stats.lastItemAdded = os.time()
        inventory:setData("stats", stats)

        -- Notify owner
        local owner = inventory:getOwner()
        if owner then
            local character = lia.char.loaded[owner]
            if character then
                local client = character:getPlayer()
                if IsValid(client) then
                    hook.Run("OnPlayerItemReceived", client, item, inventory)
                end
            end
        end
    end)
    ```
]]
function InventoryItemRemoved(self, instance, preserveItem)
end

--[[
    Purpose:
        Called when an item is removed from an inventory

    When Called:
        Before an item is removed from an inventory (the item may or may not be deleted depending on preserveItem)

    Parameters:
        - self (Inventory): The inventory instance the item is being removed from
        - instance (Item): The item instance being removed
        - preserveItem (boolean): If true, the item is preserved (not deleted) and can be transferred elsewhere

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item removals
    hook.Add("InventoryItemRemoved", "LogRemovals", function(self, instance, preserveItem)
        print(string.format("Item %s removed from inventory %d (preserved: %s)", 
            instance.name or instance.uniqueID, self:getID(), tostring(preserveItem)))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle equipped items
    hook.Add("InventoryItemRemoved", "HandleEquipped", function(self, instance, preserveItem)
        -- If item is equipped, unequip it
        if instance:getData("equip") then
            local char = self:getOwner()
            if char then
                local character = lia.char.loaded[char]
                if character then
                    local client = character:getPlayer()
                    if IsValid(client) then
                        instance:call("onUnequip", client, character)
                        instance:setData("equip", false)
                    end
                end
            end
        end

        -- Handle bag inventories
        if instance.isBag then
            local bagInv = instance:getInv()
            if bagInv then
                -- Close bag inventory panels
                hook.Run("BagInventoryRemoved", instance)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item removal handling
    hook.Add("InventoryItemRemoved", "AdvancedRemoval", function(self, instance, preserveItem)
        local invID = self:getID()
        local itemID = instance:getID()

        -- Update inventory statistics
        local stats = self:getData("stats", {})
        stats.totalItems = math.max(0, (stats.totalItems or 1) - 1)
        stats.lastItemRemoved = os.time()
        self:setData("stats", stats)

        -- Handle equipped items with special cleanup
        if instance:getData("equip") then
            local char = self:getOwner()
            if char then
                local character = lia.char.loaded[char]
                if character then
                    local client = character:getPlayer()
                    if IsValid(client) then
                        -- Call item-specific unequip
                        instance:call("onUnequip", client, character)
                        
                        -- Remove visual effects
                        if instance.removeOnUnequip then
                            hook.Run("RemoveItemVisuals", client, instance)
                        end

                        -- Restore stats
                        if instance.attribBoost then
                            for attr, boost in pairs(instance.attribBoost) do
                                character:updateAttrib(attr, -boost)
                            end
                        end

                        instance:setData("equip", false)
                    end
                end
            end
        end

        -- Handle bag removal
        if instance.isBag then
            local bagInv = instance:getInv()
            if bagInv then
                -- Delete bag's inventory if item is being permanently removed
                if not preserveItem then
                    bagInv:delete()
                    instance:setData("invID", nil)
                else
                    -- Just close panels
                    hook.Run("BagInventoryRemoved", instance)
                end
            end
        end

        -- Notify owner
        local owner = self:getOwner()
        if owner then
            local character = lia.char.loaded[owner]
            if character then
                local client = character:getPlayer()
                if IsValid(client) then
                    hook.Run("OnPlayerItemLost", client, instance, self, preserveItem)
                end
            end
        end

        -- Remove item from tracking if not preserved
        if not preserveItem then
            -- Clean up any references
            hook.Run("OnItemPermanentlyRemoved", instance)
        end
    end)
    ```
]]
function IsSuitableForTrunk(entity)
end

--[[
    Purpose:
        Determines whether an entity is suitable for trunk/storage functionality

    When Called:
        When checking if an entity can have storage initialized (e.g., vehicles, containers)

    Parameters:
        - entity (Entity): The entity to check

    Returns:
        boolean - True if the entity is suitable for storage, false otherwise

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Check for vehicles only
    hook.Add("IsSuitableForTrunk", "VehiclesOnly", function(entity)
        if not IsValid(entity) then return false end
        return entity:IsVehicle()
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Support vehicles and simfphys
    hook.Add("IsSuitableForTrunk", "VehicleSupport", function(entity)
        if not IsValid(entity) then return false end

        -- Regular vehicles
        if entity:IsVehicle() then
            return entity:getNetVar("hasStorage", false) ~= false
        end

        -- Simfphys vehicles
        if entity.isSimfphysCar and entity:isSimfphysCar() then
            return true
        end

        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced entity checking with custom storage types
    hook.Add("IsSuitableForTrunk", "AdvancedStorage", function(entity)
        if not IsValid(entity) then return false end

        -- Regular vehicles with storage netvar
        if entity:IsVehicle() then
            local hasStorage = entity:getNetVar("hasStorage", false)
            if hasStorage then
                -- Check vehicle class for size restrictions
                local vehicleClass = entity:GetVehicleClass()
                local allowedClasses = {
                    [VEHICLE_CLASS_SEDAN] = true,
                    [VEHICLE_CLASS_SUV] = true,
                    [VEHICLE_CLASS_TRUCK] = true,
                    [VEHICLE_CLASS_COUPE] = true,
                    [VEHICLE_CLASS_STATION_WAGON] = true
                }
                
                if allowedClasses[vehicleClass] then
                    return true
                end
            end
        end

        -- Simfphys vehicles
        if entity.isSimfphysCar and entity:isSimfphysCar() then
            return true
        end

        -- Custom storage entities
        if entity:GetClass() == "lia_storage" then
            return true
        end

        -- Props with storage capability
        if entity:GetClass() == "prop_physics" then
            local model = entity:GetModel()
            local storageModels = {
                ["models/props/cs_militia/footlocker01_closed.mdl"] = true,
                ["models/props_junk/wood_crate001a.mdl"] = true
            }
            if storageModels[model] then
                return entity:getNetVar("hasStorage", false) == true
            end
        end

        return false
    end)
    ```
]]
function ItemCombine(client, item, target)
end

--[[
    Purpose:
        Called when attempting to combine an item with another item in an inventory

    When Called:
        When an item transfer fails and the system attempts to combine the item with an existing item in the inventory (e.g., stacking items)

    Parameters:
        - client (Player): The player performing the combine action
        - item (Item): The item being transferred/combined
        - target (Item): The target item to combine with

    Returns:
        boolean - Return true to indicate the combine was handled, false or nil to let default behavior continue

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow all combinations
    hook.Add("ItemCombine", "AllowAll", function(client, item, target)
        return false -- Let default behavior handle
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Custom stacking logic
    hook.Add("ItemCombine", "CustomStacking", function(client, item, target)
        -- Check if items can stack
        if item.uniqueID == target.uniqueID then
            local maxStack = item:getData("maxStack", 99)
            local currentQty = target:getData("quantity", 1)
            local newQty = item:getData("quantity", 1)
            
            if currentQty + newQty <= maxStack then
                target:setData("quantity", currentQty + newQty)
                item:remove()
                client:notify("Items combined!")
                return true -- Handled
            end
        end
        
        return false -- Let default handle
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced combination system
    hook.Add("ItemCombine", "AdvancedCombination", function(client, item, target)
        local char = client:getChar()
        if not char then return false end

        -- Check combination recipes
        local recipeKey = item.uniqueID .. "_" .. target.uniqueID
        local recipes = {
            ["wooden_plank_metal_sheet"] = {
                result = "reinforced_plank",
                consume = true
            },
            ["bandage_medicine"] = {
                result = "advanced_bandage",
                consume = true
            }
        }

        local recipe = recipes[recipeKey]
        if recipe then
            -- Check if player has required skill
            local skill = char:getAttrib("crafting", 0)
            if skill < 50 then
                client:notifyError("You need 50 crafting skill to combine these items!")
                return false
            end

            -- Create result item
            local resultItem = lia.item.instance(recipe.result, 1, nil, char:getInv():getID())
            if resultItem then
                if recipe.consume then
                    item:remove()
                    target:remove()
                end
                client:notify("Items successfully combined!")
                lia.log.add(client, "itemCombine", item:getName(), target:getName())
                return true
            end
        end

        -- Default stacking behavior
        if item.uniqueID == target.uniqueID then
            local maxStack = item:getData("maxStack", 99)
            local targetQty = target:getData("quantity", 1)
            local itemQty = item:getData("quantity", 1)
            
            if targetQty + itemQty <= maxStack then
                target:setData("quantity", targetQty + itemQty)
                item:remove()
                return true
            elseif maxStack > targetQty then
                -- Partial stack
                local addQty = maxStack - targetQty
                target:setData("quantity", maxStack)
                item:setData("quantity", itemQty - addQty)
                return true
            end
        end

        return false
    end)
    ```
]]
function ItemDeleted(instance)
end

--[[
    Purpose:
        Called when an item instance is deleted from the database and removed from memory

    When Called:
        After an item has been permanently deleted from the database and removed from the item instances table

    Parameters:
        - instance (Item): The item instance that was deleted (may be partially valid, access carefully)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item deletions
    hook.Add("ItemDeleted", "LogDeletions", function(instance)
        print(string.format("Item %s (ID: %d) deleted", instance.name or instance.uniqueID, instance:getID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clean up related data
    hook.Add("ItemDeleted", "CleanupData", function(instance)
        local itemID = instance:getID()
        
        -- Remove from any tracking systems
        if lia.itemTracker then
            lia.itemTracker[itemID] = nil
        end

        -- Clean up entity references if item was spawned
        if instance.entity and IsValid(instance.entity) then
            instance.entity:Remove()
        end

        -- Remove from custom caches
        if lia.itemCache then
            lia.itemCache[itemID] = nil
        end

        print(string.format("Cleaned up data for deleted item %d", itemID))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced cleanup and statistics
    hook.Add("ItemDeleted", "AdvancedCleanup", function(instance)
        local itemID = instance:getID()
        local uniqueID = instance.uniqueID
        local char = instance:getChar()

        -- Update statistics
        if lia.itemStats then
            lia.itemStats[uniqueID] = (lia.itemStats[uniqueID] or 0) - 1
        end

        -- Clean up equipped item references
        if instance:getData("equip", false) and char then
            local character = lia.char.loaded[char]
            if character then
                local client = character:getPlayer()
                if IsValid(client) then
                    -- Remove visual effects
                    hook.Run("RemoveItemVisuals", client, instance)
                end
            end
        end

        -- Handle bag inventories
        if instance.isBag then
            local bagInv = instance:getInv()
            if bagInv then
                bagInv:delete()
            end
        end

        -- Clean up entity if spawned
        if instance.entity and IsValid(instance.entity) then
            instance.entity:Remove()
        end

        -- Remove from all tracking
        lia.item.instances[itemID] = nil
        if lia.itemCache then lia.itemCache[itemID] = nil end
        if lia.itemTracker then lia.itemTracker[itemID] = nil end

        -- Log deletion
        if char then
            local character = lia.char.loaded[char]
            if character then
                lia.log.add(nil, "itemDeleted", instance:getName(), character:getName())
            end
        end

        print(string.format("Advanced cleanup completed for item %d (%s)", itemID, uniqueID))
    end)
    ```
]]
function ItemDraggedOutOfInventory(client, item)
end

--[[
    Purpose:
        Called when a player drags an item out of an inventory (typically to drop it on the ground)

    When Called:
        When an item transfer request targets nil (no inventory) or when an item is dragged outside inventory bounds

    Parameters:
        - client (Player): The player dragging the item
        - item (Item): The item being dragged out

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item drags
    hook.Add("ItemDraggedOutOfInventory", "LogDrags", function(client, item)
        print(string.format("%s dragged %s out of inventory", client:Name(), item:getName()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Prevent dropping certain items
    hook.Add("ItemDraggedOutOfInventory", "PreventDrop", function(client, item)
        -- Prevent dropping quest items
        if item:getData("questItem", false) then
            client:notifyError("You cannot drop quest items!")
            return
        end

        -- Prevent dropping equipped items
        if item:getData("equip", false) then
            client:notifyError("You must unequip the item first!")
            return
        end

        -- Allow default behavior
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced drop handling
    hook.Add("ItemDraggedOutOfInventory", "AdvancedDrop", function(client, item)
        local char = client:getChar()
        if not char then return end

        -- Check if item can be dropped
        local canDrop = hook.Run("CanPlayerDropItem", client, item)
        if canDrop == false then
            client:notifyError("You cannot drop this item!")
            return
        end

        -- Get drop position
        local dropPos = client:getItemDropPos()
        if not dropPos then
            client:notifyError("Cannot find a valid drop position!")
            return
        end

        -- Check if item should be spawned
        if item:getData("noDrop", false) then
            client:notifyError("This item cannot be dropped!")
            return
        end

        -- Remove from inventory
        local inventory = item:getInv()
        if inventory then
            inventory:remove(item.id, true):next(function()
                -- Spawn item in world
                local spawnedEntity = item:spawn(dropPos)
                if IsValid(spawnedEntity) then
                    -- Set owner for pickup restrictions
                    spawnedEntity:setNetVar("owner", char:getID())
                    
                    -- Apply custom physics
                    if item:getData("customPhysics", false) then
                        hook.Run("OnItemDropped", client, item, spawnedEntity)
                    end

                    -- Log drop
                    lia.log.add(client, "itemDraggedOut", item:getName())
                else
                    -- Spawn failed, return item
                    inventory:add(item)
                    client:notifyError("Failed to drop item!")
                end
            end)
        end
    end)
    ```
]]
function ItemFunctionCalled(self, method, client, entity, results)
end

--[[
    Purpose:
        Called after an item function/method has been executed via item:call()

    When Called:
        Immediately after an item method is called and executed successfully

    Parameters:
        - self (Item): The item instance that had its function called
        - method (string): The name of the method that was called
        - client (Player): The player who triggered the function call
        - entity (Entity): The entity associated with the item (can be nil)
        - results (table): The return values from the item function call

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item function calls
    hook.Add("ItemFunctionCalled", "LogCalls", function(self, method, client, entity, results)
        print(string.format("%s called %s on item %s", client:Name(), method, self:getName()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track item usage statistics
    hook.Add("ItemFunctionCalled", "TrackUsage", function(self, method, client, entity, results)
        local char = client:getChar()
        if not char then return end

        -- Track usage stats
        local stats = self:getData("usageStats", {})
        stats[method] = (stats[method] or 0) + 1
        stats.totalCalls = (stats.totalCalls or 0) + 1
        stats.lastUsed = os.time()
        self:setData("usageStats", stats)

        -- Log important actions
        if method == "onUse" then
            lia.log.add(client, "itemFunction", method, self:getName())
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced function call tracking and side effects
    hook.Add("ItemFunctionCalled", "AdvancedTracking", function(self, method, client, entity, results)
        local char = client:getChar()
        if not char then return end

        local itemID = self:getID()
        local uniqueID = self.uniqueID

        -- Update usage statistics
        local stats = self:getData("usageStats", {})
        stats[method] = (stats[method] or 0) + 1
        stats.totalCalls = (stats.totalCalls or 0) + 1
        stats.lastUsed = os.time()
        stats.lastUser = client:SteamID64()
        self:setData("usageStats", stats)

        -- Method-specific handling
        if method == "onUse" then
            -- Cooldown management
            local cooldown = self:getData("cooldown", 0)
            if cooldown > CurTime() then
                client:notifyError(string.format("Item on cooldown for %d more seconds", math.ceil(cooldown - CurTime())))
                return
            end
            self:setData("cooldown", CurTime() + (self.cooldownTime or 5))

            -- Durability loss
            local durability = self:getData("durability", 100)
            if durability > 0 then
                local loss = self.durabilityLoss or 1
                self:setData("durability", math.max(0, durability - loss))
                
                if durability - loss <= 0 then
                    client:notifyError("Item broke from use!")
                    hook.Run("OnItemBroke", client, self)
                end
            end

            -- Experience gain
            if self.givesExperience then
                local exp = self.experienceAmount or 10
                char:updateAttrib(self.experienceAttribute or "fitness", exp)
            end
        end

        -- Log important actions
        local importantMethods = {"onUse", "onDrop", "onEquip", "onUnequip"}
        if table.HasValue(importantMethods, method) then
            lia.log.add(client, "itemFunction", method, self:getName())
        end

        -- Track for analytics
        if lia.analytics then
            lia.analytics.track("item_function_called", {
                item = uniqueID,
                method = method,
                player = client:SteamID64(),
                success = results and #results > 0
            })
        end

        -- Trigger follow-up hooks
        hook.Run("OnItemFunctionCompleted", self, method, client, entity, results)
    end)
    ```
]]
function ItemTransfered(context)
end

--[[
    Purpose:
        Called when an item transfer between inventories has been successfully completed

    When Called:
        After an item has been successfully moved from one inventory to another

    Parameters:
        - context (table): A table containing information about the transfer:
            - client (Player): The player who initiated the transfer
            - item (Item): The item that was transferred
            - from (Inventory): The source inventory
            - to (Inventory): The destination inventory

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log successful transfers
    hook.Add("ItemTransfered", "LogTransfers", function(context)
        print(string.format("Item %s transferred from inventory %d to %d", 
            context.item:getName(), context.from:getID(), context.to:getID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track transfer statistics
    hook.Add("ItemTransfered", "TrackStats", function(context)
        local char = context.client:getChar()
        if not char then return end

        -- Update player transfer stats
        local stats = char:getData("transferStats", {})
        stats.total = (stats.total or 0) + 1
        stats.lastTransfer = os.time()
        char:setData("transferStats", stats)

        -- Log transfer
        lia.log.add(context.client, "itemTransfer", 
            context.item:getName(), 
            tostring(context.from:getID()), 
            tostring(context.to:getID()))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced transfer handling and restrictions
    hook.Add("ItemTransfered", "AdvancedTransfer", function(context)
        local client = context.client
        local item = context.item
        local fromInv = context.from
        local toInv = context.to

        -- Update statistics
        local char = client:getChar()
        if char then
            local stats = char:getData("transferStats", {})
            stats.total = (stats.total or 0) + 1
            stats.lastTransfer = os.time()
            char:setData("transferStats", stats)
        end

        -- Check for special transfer types
        local fromOwner = fromInv:getOwner()
        local toOwner = toInv:getOwner()

        -- Player to player transfer
        if fromOwner and toOwner and fromOwner ~= toOwner then
            local fromChar = lia.char.loaded[fromOwner]
            local toChar = lia.char.loaded[toOwner]
            
            if fromChar and toChar then
                local toClient = toChar:getPlayer()
                if IsValid(toClient) then
                    toClient:notifyInfo(string.format("%s gave you %s", client:Name(), item:getName()))
                end

                -- Trade logging
                lia.log.add(client, "itemTrade", item:getName(), toChar:getName())
            end
        end

        -- Storage transfers
        if toInv:getType() == "storage" then
            hook.Run("OnItemStored", client, item, toInv)
        elseif fromInv:getType() == "storage" then
            hook.Run("OnItemRemovedFromStorage", client, item, fromInv)
        end

        -- Vendor transfers
        if toInv:getType() == "vendor" then
            hook.Run("OnItemSoldToVendor", client, item, toInv)
        elseif fromInv:getType() == "vendor" then
            hook.Run("OnItemBoughtFromVendor", client, item, fromInv)
        end

        -- Weight checks
        if toInv:getOwner() then
            local toChar = lia.char.loaded[toInv:getOwner()]
            if toChar then
                local maxWeight = hook.Run("GetMaxInventoryWeight", toChar) or 100
                local currentWeight = toInv:getWeight()
                if currentWeight > maxWeight * 0.9 then
                    local toClient = toChar:getPlayer()
                    if IsValid(toClient) then
                        toClient:notifyWarning("Your inventory is nearly full!")
                    end
                end
            end
        end

        -- Trigger follow-up hooks
        hook.Run("OnItemTransferCompleted", context)
    end)
    ```
]]
function KeyLock(owner, entity, time)
end

--[[
    Purpose:
        Called when a player locks a door or entity using keys

    When Called:
        When a player uses the key tool's primary attack to lock a door, vehicle, or other lockable entity

    Parameters:
        - owner (Player): The player attempting to lock the entity
        - entity (Entity): The door, vehicle, or entity being locked
        - time (number): The lock action time duration

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log door locks
    hook.Add("KeyLock", "LogLocks", function(owner, entity, time)
        print(string.format("%s locked %s", owner:Name(), entity:GetClass()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Enhanced locking with notifications
    hook.Add("KeyLock", "EnhancedLock", function(owner, entity, time)
        if not IsValid(owner) or not IsValid(entity) then return end

        -- Check if entity is a door
        if entity:isDoor() then
            local doorName = entity:getNetVar("title", "Door")
            owner:notifyInfo(string.format("You locked %s", doorName))
            
            -- Log the action
            lia.log.add(owner, "doorLock", doorName)
        end

        -- Set lock state
        entity:setNetVar("locked", true)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced locking system with access control
    hook.Add("KeyLock", "AdvancedLock", function(owner, entity, time)
        if not IsValid(owner) or not IsValid(entity) then return end

        local char = owner:getChar()
        if not char then return end

        -- Check if player can lock this entity
        local canLock = hook.Run("CanPlayerLock", owner, entity)
        if canLock == false then
            owner:notifyError("You cannot lock this!")
            return
        end

        -- Distance check
        local distance = owner:GetPos():Distance(entity:GetPos())
        if distance > 256 then
            owner:notifyError("You are too far away!")
            return
        end

        -- Check entity type and handle accordingly
        if entity:isDoor() then
            local doorName = entity:getNetVar("title", "Door")
            
            -- Check door ownership/access
            if not entity:checkDoorAccess(owner) and entity:GetCreator() ~= owner and not owner:isStaffOnDuty() then
                owner:notifyError("You do not have access to lock this door!")
                return
            end

            -- Already locked check is done by the module, but we can add extras
            if entity:isLocked() then
                owner:notifyError("This door is already locked!")
                return
            end

            -- Lock the door
            entity:setNetVar("locked", true)
            owner:notifyInfo(string.format("You locked %s", doorName))

            -- Notify nearby players
            for _, ply in pairs(player.GetAll()) do
                if ply:GetPos():Distance(entity:GetPos()) <= 512 then
                    if ply ~= owner then
                        ply:notify(string.format("%s locked %s", owner:Name(), doorName))
                    end
                end
            end

            -- Log and update statistics
            lia.log.add(owner, "doorLock", doorName)
            char:setData("doorsLocked", (char:getData("doorsLocked", 0) + 1))
        elseif entity:IsVehicle() or (entity.isSimfphysCar and entity:isSimfphysCar()) then
            -- Vehicle locking
            local vehicleName = entity:GetVehicleClass() or "Vehicle"
            entity:setNetVar("locked", true)
            owner:notifyInfo(string.format("You locked the %s", vehicleName))
            lia.log.add(owner, "vehicleLock", vehicleName)
        end

        -- Play lock sound
        owner:EmitSound("doors/door_latch3.wav", 75, 100, 0.5)
    end)
    ```
]]
function KeyUnlock(owner, entity, time)
end

--[[
    Purpose:
        Called when a player unlocks a door or entity using keys

    When Called:
        When a player uses the key tool's secondary attack to unlock a door, vehicle, or other lockable entity

    Parameters:
        - owner (Player): The player attempting to unlock the entity
        - entity (Entity): The door, vehicle, or entity being unlocked
        - time (number): The unlock action time duration

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log door unlocks
    hook.Add("KeyUnlock", "LogUnlocks", function(owner, entity, time)
        print(string.format("%s unlocked %s", owner:Name(), entity:GetClass()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Enhanced unlocking with notifications
    hook.Add("KeyUnlock", "EnhancedUnlock", function(owner, entity, time)
        if not IsValid(owner) or not IsValid(entity) then return end

        -- Check if entity is a door
        if entity:isDoor() then
            local doorName = entity:getNetVar("title", "Door")
            owner:notifyInfo(string.format("You unlocked %s", doorName))
            
            -- Log the action
            lia.log.add(owner, "doorUnlock", doorName)
        end

        -- Set unlock state
        entity:setNetVar("locked", false)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced unlocking system with access control
    hook.Add("KeyUnlock", "AdvancedUnlock", function(owner, entity, time)
        if not IsValid(owner) or not IsValid(entity) then return end

        local char = owner:getChar()
        if not char then return end

        -- Check if player can unlock this entity
        local canUnlock = hook.Run("CanPlayerUnlock", owner, entity)
        if canUnlock == false then
            owner:notifyError("You cannot unlock this!")
            return
        end

        -- Distance check
        local distance = owner:GetPos():Distance(entity:GetPos())
        if distance > 256 then
            owner:notifyError("You are too far away!")
            return
        end

        -- Check entity type and handle accordingly
        if entity:isDoor() then
            local doorName = entity:getNetVar("title", "Door")
            
            -- Check door ownership/access
            if not entity:checkDoorAccess(owner) and entity:GetCreator() ~= owner and not owner:isStaffOnDuty() then
                owner:notifyError("You do not have access to unlock this door!")
                return
            end

            -- Already unlocked check
            if not entity:isLocked() then
                owner:notifyError("This door is already unlocked!")
                return
            end

            -- Unlock the door
            entity:setNetVar("locked", false)
            owner:notifyInfo(string.format("You unlocked %s", doorName))

            -- Notify nearby players
            for _, ply in pairs(player.GetAll()) do
                if ply:GetPos():Distance(entity:GetPos()) <= 512 then
                    if ply ~= owner then
                        ply:notify(string.format("%s unlocked %s", owner:Name(), doorName))
                    end
                end
            end

            -- Log and update statistics
            lia.log.add(owner, "doorUnlock", doorName)
            char:setData("doorsUnlocked", (char:getData("doorsUnlocked", 0) + 1))
        elseif entity:IsVehicle() or (entity.isSimfphysCar and entity:isSimfphysCar()) then
            -- Vehicle unlocking
            local vehicleName = entity:GetVehicleClass() or "Vehicle"
            entity:setNetVar("locked", false)
            owner:notifyInfo(string.format("You unlocked the %s", vehicleName))
            lia.log.add(owner, "vehicleUnlock", vehicleName)
        end

        -- Play unlock sound
        owner:EmitSound("doors/door_latch1.wav", 75, 100, 0.5)
    end)
    ```
]]
function LiliaTablesLoaded()
end

--[[
    Purpose:
        Signal that all Lilia database tables have finished loading.

    When Called:
        Called from `lia.db.loadTables()` after all database tables are created and `addDatabaseFields` completes.

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log tables loaded
    hook.Add("LiliaTablesLoaded", "MyAddon", function()
    print("Lilia tables loaded")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Create custom tables
    hook.Add("LiliaTablesLoaded", "CreateCustomTables", function()
    lia.db.query("CREATE TABLE IF NOT EXISTS my_table (id INTEGER PRIMARY KEY, data TEXT)")
    print("Custom tables created")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex database initialization
    hook.Add("LiliaTablesLoaded", "AdvancedDatabaseInit", function()
    -- Create custom tables
    local tables = {
    "CREATE TABLE IF NOT EXISTS my_table (id INTEGER PRIMARY KEY, data TEXT)",
    "CREATE TABLE IF NOT EXISTS my_stats (charid INTEGER, stat TEXT, value INTEGER)",
    "CREATE TABLE IF NOT EXISTS my_logs (timestamp INTEGER, message TEXT)"
    }
    for _, query in ipairs(tables) do
        lia.db.query(query)
        end
    -- Create indexes
    lia.db.query("CREATE INDEX IF NOT EXISTS idx_my_stats_charid ON my_stats(charid)")
    print("Custom database tables and indexes created")
    end)
    ```
]]
function LoadData()
end

--[[
    Purpose:
        Allows modification of server data loading operations

    When Called:
        When the server is loading persistent data, entities, and world state from the database

    Parameters:
        None

    Returns:
        boolean - Return false to prevent data loading, nil/true to allow

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Skip loading during development
    hook.Add("LoadData", "DevMode", function()
        if GetGlobalBool("DevMode", false) then
            return false -- Skip loading in dev mode
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Conditional loading based on server state
    hook.Add("LoadData", "ConditionalLoad", function()
        -- Only load if database is healthy
        if not lia.db then
            lia.log.add(nil, "load_cancelled_no_db")
            return false
        end

        -- Load different data based on map
        local map = game.GetMap()
        if string.find(map, "rp_downtown") then
            -- Load city-specific data
            SetGlobalString("MapType", "city")
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced loading with validation and migration
    hook.Add("LoadData", "AdvancedLoadManager", function()
        -- Validate database schema before loading
        lia.db.query("SHOW TABLES LIKE 'lia_%'", function(data)
            if not data or #data == 0 then
                lia.log.add(nil, "load_cancelled_no_tables")
                return false
            end
        end)

        -- Check for data migration needs
        local currentVersion = GetGlobalInt("SchemaVersion", 0)
        local targetVersion = lia.config.SchemaVersion or 1

        if currentVersion < targetVersion then
            lia.log.add(nil, "data_migration_needed", currentVersion, targetVersion)
            -- Trigger migration process
            hook.Run("OnDataMigration", currentVersion, targetVersion)
        end

        -- Setup loading metrics
        local loadStart = SysTime()
        SetGlobalFloat("LoadStartTime", loadStart)

        -- Validate critical configuration
        if not lia.config.get("DBHost") then
            lia.log.add(nil, "load_cancelled_config")
            return false
        end

        lia.log.add(nil, "data_load_started", {
            map = game.GetMap(),
            schema_version = currentVersion,
            timestamp = os.time()
        })
    end)
    ```
]]
function ModifyCharacterModel(client, character)
end

--[[
    Purpose:
        Allows modification of charactermodel

    When Called:
        During charactermodel processing

    Parameters:
        - client: Description
        - character: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Allow default model
    hook.Add("ModifyCharacterModel", "MyAddon", function(client, character)
    -- No modification needed
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Apply faction-specific models
    hook.Add("ModifyCharacterModel", "FactionModels", function(client, character)
    local faction = character:getFaction()
    if faction == "police" then
        character.model = "models/player/police.mdl"
    elseif faction == "medic" then
        character.model = "models/player/kleiner.mdl"
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex model modification system
    hook.Add("ModifyCharacterModel", "AdvancedModelSystem", function(client, character)
    -- Check for custom model data
    local customModel = character:getData("customModel")
    if customModel then
        character.model = customModel
        return
    end

    -- Apply faction and rank-based models
    local faction = character:getFaction()
    local rank = character:getData("rank", 1)

    local modelTable = {
        police = {
            [1] = "models/player/police.mdl",
            [2] = "models/player/police_fem.mdl",
            [3] = "models/player/combine_soldier.mdl"
        },
        medic = {
            [1] = "models/player/kleiner.mdl",
            [2] = "models/player/alyx.mdl",
            [3] = "models/player/mossman.mdl"
        }
    }

    if modelTable[faction] and modelTable[faction][rank] then
        character.model = modelTable[faction][rank]
    end
    end)
    ```
]]
function OnAdminSystemLoaded(groups, privileges)
end

--[[
    Purpose:
        Called when adminsystemloaded occurs

    When Called:
        After adminsystemloaded has happened

    Parameters:
        - groups: Description
        - privileges: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log admin system load
    hook.Add("OnAdminSystemLoaded", "MyAddon", function(groups, privileges)
    print("Admin system loaded with " .. #groups .. " groups and " .. #privileges .. " privileges")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Register custom privileges
    hook.Add("OnAdminSystemLoaded", "CustomPrivileges", function(groups, privileges)
    -- Add custom privilege if it doesn't exist
    if not privileges["canUseAdminTools"] then
        privileges["canUseAdminTools"] = {
            name = "Can Use Admin Tools",
            description = "Allows access to custom admin tools"
        }
    end
    print("Custom privileges registered")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Setup admin permissions and logging
    hook.Add("OnAdminSystemLoaded", "AdminSetup", function(groups, privileges)
    -- Create admin command permissions
    local adminCommands = {
        "kick", "ban", "mute", "teleport", "god", "freeze"
    }

    -- Ensure all commands have corresponding privileges
    for _, cmd in ipairs(adminCommands) do
        local privName = "cmd_" .. cmd
        if not privileges[privName] then
            privileges[privName] = {
                name = "Command: " .. cmd,
                description = "Allows use of /" .. cmd .. " command"
            }
        end
    end

    -- Setup admin group hierarchy
    for groupName, groupData in pairs(groups) do
        if groupData.inheritance then
            -- Ensure inheritance is properly set up
            local parentGroup = groups[groupData.inheritance]
            if parentGroup then
                -- Copy parent permissions if not already present
                for privName, privData in pairs(parentGroup.privileges or {}) do
                    if not groupData.privileges[privName] then
                        groupData.privileges[privName] = privData
                    end
                end
            end
        end
    end

    print("Admin system fully configured with " .. #adminCommands .. " command permissions")
    end)
    ```
]]
function OnCharAttribBoosted(character)
end

--[[
    Purpose:
        Called when charattribboosted occurs

    When Called:
        After charattribboosted has happened

    Parameters:
        - character: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log attribute boost
    hook.Add("OnCharAttribBoosted", "MyAddon", function(character)
    print(character:getName() .. " received an attribute boost")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Update character data after boost
    hook.Add("OnCharAttribBoosted", "BoostTracker", function(character)
    local boostCount = character:getData("boostCount", 0) + 1
    character:setData("boostCount", boostCount)
    character:setData("lastBoostTime", os.time())

    -- Notify player
    local client = character:getPlayer()
    if IsValid(client) then
        client:ChatPrint("Your attributes have been boosted! (Total boosts: " .. boostCount .. ")")
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced boost effects and achievements
    hook.Add("OnCharAttribBoosted", "AdvancedBoostSystem", function(character)
    local client = character:getPlayer()
    if not IsValid(client) then return end

    -- Track boost history
    local boostHistory = character:getData("boostHistory", {})
    table.insert(boostHistory, {
        timestamp = os.time(),
        level = character:getData("level", 1),
        boostCount = #boostHistory + 1
    })

    -- Keep only last 10 boosts
    if #boostHistory > 10 then
        table.remove(boostHistory, 1)
    end

    character:setData("boostHistory", boostHistory)

    -- Check for boost achievements
    local totalBoosts = #boostHistory
    if totalBoosts >= 5 and not character:getData("achievement_boost5") then
        character:setData("achievement_boost5", true)
        client:ChatPrint("Achievement Unlocked: Boosted 5 times!")
    elseif totalBoosts >= 10 and not character:getData("achievement_boost10") then
        character:setData("achievement_boost10", true)
        client:ChatPrint("Achievement Unlocked: Boosted 10 times!")
    end

    -- Apply temporary effects
    character:setData("boostActive", true)
    timer.Create("BoostExpire_" .. character:getID(), 3600, 1, function()
        if character and character:isValid() then
            character:setData("boostActive", false)
            if IsValid(client) then
                client:ChatPrint("Your attribute boost has expired")
            end
        end
    end)
    end)
    ```
]]
function OnCharAttribUpdated(client, character, key, newValue)
end

--[[
    Purpose:
        Called when charattribupdated occurs

    When Called:
        After charattribupdated has happened

    Parameters:
        - client: Description
        - character: Description
        - key: Description
        - newValue: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log attribute updates
    hook.Add("OnCharAttribUpdated", "MyAddon", function(client, character, key, newValue)
    print(character:getName() .. " attribute '" .. key .. "' updated to " .. tostring(newValue))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track important attribute changes
    hook.Add("OnCharAttribUpdated", "AttributeTracker", function(client, character, key, newValue)
    local importantAttrs = {"strength", "agility", "intelligence", "level"}
    if table.HasValue(importantAttrs, key) then
        -- Store change history
        local history = character:getData("attrHistory", {})
        history[key] = history[key] or {}
        table.insert(history[key], {
            value = newValue,
            time = os.time()
        })
        character:setData("attrHistory", history)

        -- Notify client of major changes
        if newValue >= 50 and not character:getData("milestone_" .. key) then
            character:setData("milestone_" .. key, true)
            client:ChatPrint("Milestone reached: " .. key .. " is now " .. newValue .. "!")
        end
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced attribute management system
    hook.Add("OnCharAttribUpdated", "AdvancedAttributeSystem", function(client, character, key, newValue)
    -- Handle special attribute interactions
    if key == "strength" then
        -- Strength affects carrying capacity
        local carryBonus = math.floor(newValue / 10)
        character:setData("carryCapacityBonus", carryBonus)
    elseif key == "agility" then
        -- Agility affects movement speed
        local speedBonus = newValue * 0.01
        character:setData("speedBonus", speedBonus)
        -- Update player speed if online
        if IsValid(client) then
            local baseSpeed = 250
            client:SetRunSpeed(baseSpeed + (baseSpeed * speedBonus))
            client:SetWalkSpeed((baseSpeed * 0.5) + ((baseSpeed * 0.5) * speedBonus))
        end
    elseif key == "intelligence" then
        -- Intelligence affects skill learning
        local skillBonus = newValue * 0.02
        character:setData("skillLearnBonus", skillBonus)
    elseif key == "level" then
        -- Level up effects
        local oldLevel = character:getData("previousLevel", 1)
        if newValue > oldLevel then
            -- Grant level rewards
            local rewardXP = newValue * 100
            local currentXP = character:getData("experience", 0)
            character:setData("experience", currentXP + rewardXP)

            -- Notify player
            client:ChatPrint("Level up! You are now level " .. newValue)
            client:ChatPrint("Bonus XP granted: " .. rewardXP)
        end
        character:setData("previousLevel", newValue)
    end

    -- Update attribute totals for achievements
    local totalAttrs = 0
    for attrKey, attrValue in pairs(character:getAttribs()) do
        totalAttrs = totalAttrs + attrValue
    end
    character:setData("totalAttributePoints", totalAttrs)

    -- Achievement check
    if totalAttrs >= 200 and not character:getData("achievement_attr200") then
        character:setData("achievement_attr200", true)
        client:ChatPrint("Achievement Unlocked: 200 Total Attribute Points!")
    end
    end)
    ```
]]
function OnCharCreated(client, character, originalData)
end

--[[
    Purpose:
        Called after a character has been successfully created and saved to the database

    When Called:
        Immediately after a new character is created and added to the player's character list

    Parameters:
        - client (Player): The player who created the character
        - character (Character): The newly created character instance
        - originalData (table): The original character creation data that was used

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character creation
    hook.Add("OnCharCreated", "LogCreation", function(client, character, originalData)
        print(string.format("%s created character: %s (ID: %d)", 
            client:Name(), character:getName(), character:getID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Give starter items and setup
    hook.Add("OnCharCreated", "StarterSetup", function(client, character, originalData)
        -- Give starting money
        local startMoney = hook.Run("GetPlayerStartMoney", client) or 500
        character:giveMoney(startMoney)

        -- Give starter items
        local starterItems = {"backpack", "pistol", "ammo_pistol", "radio"}
        local inventory = character:getInv()
        if inventory then
            for _, itemID in ipairs(starterItems) do
                inventory:add(itemID, 1)
            end
        end

        -- Set initial data
        character:setData("playtime", 0)
        character:setData("created", os.time())

        client:notifyInfo(string.format("Welcome, %s! You have been given $%d and starter items.", 
            character:getName(), startMoney))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character initialization
    hook.Add("OnCharCreated", "AdvancedSetup", function(client, character, originalData)
        local charID = character:getID()
        local steamID = client:SteamID64()

        -- Starting money
        local startMoney = hook.Run("GetPlayerStartMoney", client) or 500
        character:giveMoney(startMoney)

        -- Starting inventory setup
        local inventory = character:getInv()
        if inventory then
            -- Default starter items
            local starterItems = hook.Run("GetDefaultInventoryItems", client) or {
                "backpack", "radio", "flashlight"
            }
            
            for _, itemID in ipairs(starterItems) do
                inventory:add(itemID, 1)
            end

            -- Faction-specific items
            local faction = lia.faction.indices[character:getFaction()]
            if faction and faction.starterItems then
                for _, itemID in ipairs(faction.starterItems) do
                    inventory:add(itemID, 1)
                end
            end
        end

        -- Set character metadata
        character:setData("created", os.time())
        character:setData("playtime", 0)
        character:setData("lastLogin", os.time())
        character:setData("stats", {
            deaths = 0,
            kills = 0,
            moneyEarned = 0,
            moneySpent = 0
        })

        -- Faction-specific setup
        local faction = lia.faction.indices[character:getFaction()]
        if faction then
            if faction.onCharCreated then
                faction.onCharCreated(character, client)
            end

            -- Set default class if faction has one
            local defaultClass = lia.faction.getDefaultClass(character:getFaction())
            if defaultClass then
                character:setClass(defaultClass.index)
            end
        end

        -- Attribute initialization
        local startingPoints = hook.Run("GetMaxStartingAttributePoints", client) or 0
        if startingPoints > 0 then
            character:setData("unspentAttributePoints", startingPoints)
        end

        -- Welcome message
        client:notifyInfo(string.format("Welcome to the server, %s!", character:getName()))
        client:notifyInfo(string.format("You start with $%d", startMoney))

        -- Log creation
        lia.log.add(client, "charCreate", character:getName(), charID)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("character_created", {
                player = steamID,
                char_id = charID,
                faction = character:getFaction(),
                class = character:getClass()
            })
        end

        -- Trigger follow-up hooks
        hook.Run("OnCharacterFullyInitialized", client, character)
    end)
    ```
]]
function OnCharDelete(client, id)
end

--[[
    Purpose:
        Called when a character is deleted from the database

    When Called:
        After a character deletion request has been processed and the character removed from the database

    Parameters:
        - client (Player): The player who deleted the character (can be nil if deleted by admin/system)
        - id (number): The ID of the deleted character

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character deletion
    hook.Add("OnCharDelete", "LogDeletion", function(client, id)
        local playerName = IsValid(client) and client:Name() or "System"
        print(string.format("Character %d deleted by %s", id, playerName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clean up character-related data
    hook.Add("OnCharDelete", "CleanupData", function(client, id)
        -- Clean up inventory
        lia.char.getCharacter(id, nil, function(character)
            if character then
                local inventory = character:getInv()
                if inventory then
                    inventory:delete()
                end
            end
        end)

        -- Remove from any tracking systems
        if lia.charCache then
            lia.charCache[id] = nil
        end

        -- Log deletion
        local playerName = IsValid(client) and client:Name() or "System"
        lia.log.add(client, "charDelete", id)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character deletion handling
    hook.Add("OnCharDelete", "AdvancedDeletion", function(client, id)
        local steamID = IsValid(client) and client:SteamID64() or "System"

        -- Get character data before deletion (if still available)
        lia.char.getCharacter(id, nil, function(character)
            if character then
                local charName = character:getName()
                local faction = character:getFaction()
                local playtime = character:getData("playtime", 0)

                -- Delete inventory and all items
                local inventory = character:getInv()
                if inventory then
                    -- Save important items to overflow if configured
                    if lia.config.get("SaveItemsOnDelete", false) then
                        local overflowItems = {}
                        for _, item in pairs(inventory:getItems()) do
                            if item:getData("preserveOnDelete", false) then
                                table.insert(overflowItems, {
                                    uniqueID = item.uniqueID,
                                    data = item:getData()
                                })
                            end
                        end
                        if #overflowItems > 0 then
                            -- Store in admin inventory or special storage
                            character:setData("overflowItems", overflowItems)
                        end
                    end
                    inventory:delete()
                end

                -- Clean up storage references
                for _, ent in pairs(ents.GetAll()) do
                    if IsValid(ent) then
                        local owner = ent:getNetVar("owner")
                        if owner == id then
                            -- Transfer ownership or remove
                            hook.Run("OnStorageOwnerDeleted", ent, id)
                        end
                    end
                end

                -- Delete all warnings for this character
                lia.module.get("administration"):GetWarnings(id):next(function(warnings)
                    for _, warn in ipairs(warnings) do
                        lia.module.get("administration"):RemoveWarning(id, warn.id)
                    end
                end)

                -- Update statistics
                if lia.charStats then
                    lia.charStats.deleted = (lia.charStats.deleted or 0) + 1
                    lia.charStats.totalPlaytimeDeleted = (lia.charStats.totalPlaytimeDeleted or 0) + playtime
                end

                -- Log deletion with details
                lia.log.add(client, "charDelete", charName, id, faction, playtime)

                -- Analytics tracking
                if lia.analytics then
                    lia.analytics.track("character_deleted", {
                        player = steamID,
                        char_id = id,
                        char_name = charName,
                        faction = faction,
                        playtime = playtime
                    })
                end

                -- Notify admins if player deletion
                if IsValid(client) then
                    for _, admin in pairs(player.GetAll()) do
                        if admin:isAdmin() and admin ~= client then
                            admin:notifyInfo(string.format("%s deleted character: %s (ID: %d)", 
                                client:Name(), charName, id))
                        end
                    end
                end
            end

            -- Remove from cache
            if lia.charCache then
                lia.charCache[id] = nil
            end
            lia.char.loaded[id] = nil
        end)

        -- If client is online and was using this character, spawn them
        if IsValid(client) and client:getChar() and client:getChar():getID() == id then
            net.Start("liaCharKick")
            net.WriteUInt(id, 32)
            net.WriteBool(true)
            net.Send(client)
            client:setNetVar("char", nil)
            client:Spawn()
        end
    end)
    ```
]]
function OnCharDisconnect(client, character)
end

--[[
    Purpose:
        Called when a player disconnects from the server while having a character loaded

    When Called:
        When a player disconnects and their character needs to be saved and unloaded

    Parameters:
        - client (Player): The player who is disconnecting
        - character (Character): The character instance that was active

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log disconnections
    hook.Add("OnCharDisconnect", "LogDisconnects", function(client, character)
        print(string.format("%s disconnected with character %s (ID: %d)", 
            client:Name(), character:getName(), character:getID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Save character data and cleanup
    hook.Add("OnCharDisconnect", "SaveData", function(client, character)
        -- Update last disconnect time
        character:setData("lastDisconnect", os.time())
        
        -- Save playtime
        local sessionTime = character:getData("sessionStart", 0)
        if sessionTime > 0 then
            local playtime = character:getData("playtime", 0)
            playtime = playtime + (os.time() - sessionTime)
            character:setData("playtime", playtime)
            character:setData("sessionStart", 0)
        end

        -- Save position
        if IsValid(client) then
            character:setData("lastPosition", client:GetPos())
            character:setData("lastAngles", client:GetAngles())
        end

        -- Log disconnect
        lia.log.add(client, "charDisconnect", character:getName())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced disconnect handling
    hook.Add("OnCharDisconnect", "AdvancedDisconnect", function(client, character)
        local charID = character:getID()
        local steamID = client:SteamID64()

        -- Update session data
        local sessionStart = character:getData("sessionStart", 0)
        if sessionStart > 0 then
            local sessionDuration = os.time() - sessionStart
            local totalPlaytime = character:getData("playtime", 0) + sessionDuration
            character:setData("playtime", totalPlaytime)
            character:setData("sessionStart", 0)

            -- Update daily playtime
            local today = os.date("%Y-%m-%d")
            local dailyPlaytime = character:getData("dailyPlaytime", {})
            dailyPlaytime[today] = (dailyPlaytime[today] or 0) + sessionDuration
            character:setData("dailyPlaytime", dailyPlaytime)
        end

        -- Save position and state
        if IsValid(client) then
            character:setData("lastPosition", client:GetPos())
            character:setData("lastAngles", client:GetAngles())
            character:setData("lastModel", client:GetModel())
        end

        -- Save equipped items state
        local inventory = character:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item:getData("equip", false) then
                    item:setData("wasEquipped", true)
                end
            end
        end

        -- Update statistics
        local stats = character:getData("stats", {})
        stats.totalDisconnects = (stats.totalDisconnects or 0) + 1
        stats.lastDisconnectTime = os.time()
        character:setData("stats", stats)

        -- Clean up temporary data
        character:setData("tempData", nil)

        -- Remove ragdoll if exists
        local ragdoll = client:getNetVar("ragdoll")
        if IsValid(ragdoll) then
            SafeRemoveEntity(ragdoll)
        end

        -- Log disconnect
        lia.log.add(client, "charDisconnect", character:getName(), charID)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("character_disconnect", {
                player = steamID,
                char_id = charID,
                session_duration = sessionDuration or 0
            })
        end

        -- Notify faction if applicable
        local faction = lia.faction.indices[character:getFaction()]
        if faction and faction.onCharDisconnect then
            faction.onCharDisconnect(character, client)
        end
    end)
    ```
]]
function OnCharFallover(character, client, ragdoll)
end

--[[
    Purpose:
        Called when a character falls over (becomes ragdolled) or stops being ragdolled

    When Called:
        When a character's ragdoll state changes (falls over or gets up)

    Parameters:
        - character (Character): The character instance
        - client (Player): The player associated with the character
        - ragdoll (boolean): True if becoming ragdolled, false if getting up

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log fallover events
    hook.Add("OnCharFallover", "LogFallover", function(character, client, ragdoll)
        if ragdoll then
            print(string.format("%s fell over", client:Name()))
        else
            print(string.format("%s got up", client:Name()))
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle fallover with stamina/health effects
    hook.Add("OnCharFallover", "StaminaFallover", function(character, client, ragdoll)
        if ragdoll then
            -- Character fell over
            local stamina = character:getAttrib("stamina", 100)
            if stamina < 20 then
                client:notifyWarning("You're too exhausted to stand!")
            end

            -- Update statistics
            character:setData("timesFallen", (character:getData("timesFallen", 0) + 1))
        else
            -- Character got up
            local stamina = character:getAttrib("stamina", 100)
            if stamina < 50 then
                -- Take stamina for getting up
                character:updateAttrib("stamina", -5)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced fallover system
    hook.Add("OnCharFallover", "AdvancedFallover", function(character, client, ragdoll)
        if ragdoll then
            -- Character fell over
            local health = client:Health()
            local stamina = character:getAttrib("stamina", 100)

            -- Determine fall reason
            local fallReason = "unknown"
            if stamina < 10 then
                fallReason = "exhaustion"
                client:notifyWarning("You collapsed from exhaustion!")
            elseif health < 30 then
                fallReason = "injury"
                client:notifyWarning("You're too injured to stand!")
            else
                fallReason = "manual"
            end

            -- Update statistics
            local stats = character:getData("stats", {})
            stats.timesFallen = (stats.timesFallen or 0) + 1
            stats.fallReasons = stats.fallReasons or {}
            stats.fallReasons[fallReason] = (stats.fallReasons[fallReason] or 0) + 1
            character:setData("stats", stats)

            -- Apply fall effects
            if fallReason == "exhaustion" then
                character:updateAttrib("stamina", -10) -- Additional stamina drain
            elseif fallReason == "injury" then
                -- Injured characters take longer to get up
                client:setNetVar("injured", true)
            end

            -- Notify nearby players
            for _, ply in pairs(player.GetAll()) do
                if ply:GetPos():Distance(client:GetPos()) <= 256 then
                    if ply ~= client then
                        ply:notify(string.format("%s fell over", client:Name()))
                    end
                end
            end

            -- Log fallover
            lia.log.add(client, "charFallover", fallReason)
        else
            -- Character got up
            local stamina = character:getAttrib("stamina", 100)
            local health = client:Health()

            -- Check if player can get up
            if stamina < 20 and health > 10 then
                client:notifyError("You're too exhausted to get up!")
                return
            end

            -- Stamina cost for getting up
            if stamina >= 20 then
                character:updateAttrib("stamina", -15)
            end

            -- Remove injury flag
            client:setNetVar("injured", false)

            -- Update statistics
            local stats = character:getData("stats", {})
            stats.timesGotUp = (stats.timesGotUp or 0) + 1
            character:setData("stats", stats)

            -- Recovery time based on health
            local recoveryTime = math.max(1, (100 - health) / 10)
            client:setNetVar("recoveryTime", CurTime() + recoveryTime)
        end
    end)
    ```
]]
function OnCharFlagsGiven(ply, self, addedFlags)
end

--[[
    Purpose:
        Called when flags are given/added to a character

    When Called:
        After flags have been successfully added to a character's flag string

    Parameters:
        - ply (Player): The player who gave the flags (can be nil if done by system/admin)
        - self (Character): The character that received the flags
        - addedFlags (string): The flags that were added to the character

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log flag additions
    hook.Add("OnCharFlagsGiven", "LogFlags", function(ply, self, addedFlags)
        local giverName = IsValid(ply) and ply:Name() or "System"
        print(string.format("%s gave flags '%s' to character %s", 
            giverName, addedFlags, self:getName()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify and validate flags
    hook.Add("OnCharFlagsGiven", "NotifyFlags", function(ply, self, addedFlags)
        local client = self:getPlayer()
        if IsValid(client) then
            client:notifyInfo(string.format("You received flags: %s", addedFlags))
        end

        -- Validate flags
        local validFlags = "abcdefghijklmnopqrstuvwxyz"
        for i = 1, string.len(addedFlags) do
            local flag = string.sub(addedFlags, i, i)
            if not string.find(validFlags, flag) then
                lia.log.add(nil, "invalidFlag", flag, self:getName())
            end
        end

        -- Log addition
        local giverName = IsValid(ply) and ply:Name() or "System"
        lia.log.add(ply, "charFlagsGiven", addedFlags, self:getName())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced flag management
    hook.Add("OnCharFlagsGiven", "AdvancedFlags", function(ply, self, addedFlags)
        local client = self:getPlayer()
        local charID = self:getID()
        local giverName = IsValid(ply) and ply:Name() or "System"
        local giverSteamID = IsValid(ply) and ply:SteamID64() or "System"

        -- Validate each flag
        local validFlags = "abcdefghijklmnopqrstuvwxyz"
        local invalidFlags = {}
        for i = 1, string.len(addedFlags) do
            local flag = string.sub(addedFlags, i, i)
            if not string.find(validFlags, flag, 1, true) then
                table.insert(invalidFlags, flag)
            end
        end

        if #invalidFlags > 0 then
            lia.log.add(nil, "invalidFlagsGiven", table.concat(invalidFlags), charID)
        end

        -- Check for special flags that trigger effects
        local flagEffects = {
            ["a"] = function() -- Admin flag example
                if IsValid(client) then
                    client:notifyInfo("You have been granted administrative access!")
                end
            end,
            ["v"] = function() -- VIP flag example
                if IsValid(client) then
                    self:giveMoney(1000) -- VIP bonus
                    client:notifyInfo("Welcome VIP! You received $1000!")
                end
            end
        }

        for i = 1, string.len(addedFlags) do
            local flag = string.sub(addedFlags, i, i)
            if flagEffects[flag] then
                flagEffects[flag]()
            end
        end

        -- Update flag history
        local flagHistory = self:getData("flagHistory", {})
        table.insert(flagHistory, {
            flags = addedFlags,
            givenBy = giverName,
            givenBySteamID = giverSteamID,
            timestamp = os.time(),
            action = "added"
        })
        self:setData("flagHistory", flagHistory)

        -- Notify character
        if IsValid(client) then
            client:notifyInfo(string.format("You received flags: %s (Given by: %s)", addedFlags, giverName))
        end

        -- Log the action
        lia.log.add(ply, "charFlagsGiven", addedFlags, self:getName(), charID)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("character_flags_given", {
                giver = giverSteamID,
                receiver = charID,
                flags = addedFlags
            })
        end

        -- Check if character now has all required flags for something
        local allFlags = self:getFlags()
        hook.Run("OnCharFlagsUpdated", self, allFlags)
    end)
    ```
]]
function OnCharFlagsTaken(ply, self, removedFlags)
end

--[[
    Purpose:
        Called when flags are removed/taken from a character

    When Called:
        After flags have been successfully removed from a character's flag string

    Parameters:
        - ply (Player): The player who removed the flags (can be nil if done by system/admin)
        - self (Character): The character that lost the flags
        - removedFlags (string): The flags that were removed from the character

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log flag removals
    hook.Add("OnCharFlagsTaken", "LogFlags", function(ply, self, removedFlags)
        local removerName = IsValid(ply) and ply:Name() or "System"
        print(string.format("%s removed flags '%s' from character %s", 
            removerName, removedFlags, self:getName()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify and log flag removal
    hook.Add("OnCharFlagsTaken", "NotifyFlags", function(ply, self, removedFlags)
        local client = self:getPlayer()
        if IsValid(client) then
            client:notifyWarning(string.format("You lost flags: %s", removedFlags))
        end

        -- Log removal
        local removerName = IsValid(ply) and ply:Name() or "System"
        lia.log.add(ply, "charFlagsTaken", removedFlags, self:getName())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced flag removal handling
    hook.Add("OnCharFlagsTaken", "AdvancedFlags", function(ply, self, removedFlags)
        local client = self:getPlayer()
        local charID = self:getID()
        local removerName = IsValid(ply) and ply:Name() or "System"
        local removerSteamID = IsValid(ply) and ply:SteamID64() or "System"

        -- Handle special flag removals
        local flagRemovalEffects = {
            ["a"] = function() -- Admin flag removal
                if IsValid(client) then
                    client:notifyWarning("Your administrative access has been revoked!")
                    -- Remove admin tools/weapons
                    client:StripWeapons()
                end
            end,
            ["v"] = function() -- VIP flag removal
                if IsValid(client) then
                    client:notifyWarning("Your VIP status has been revoked!")
                end
            end
        }

        for i = 1, string.len(removedFlags) do
            local flag = string.sub(removedFlags, i, i)
            if flagRemovalEffects[flag] then
                flagRemovalEffects[flag]()
            end
        end

        -- Update flag history
        local flagHistory = self:getData("flagHistory", {})
        table.insert(flagHistory, {
            flags = removedFlags,
            removedBy = removerName,
            removedBySteamID = removerSteamID,
            timestamp = os.time(),
            action = "removed"
        })
        self:setData("flagHistory", flagHistory)

        -- Notify character
        if IsValid(client) then
            client:notifyWarning(string.format("Your flags were removed: %s (Removed by: %s)", 
                removedFlags, removerName))
        end

        -- Log the action
        lia.log.add(ply, "charFlagsTaken", removedFlags, self:getName(), charID)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("character_flags_taken", {
                remover = removerSteamID,
                target = charID,
                flags = removedFlags
            })
        end

        -- Check remaining flags
        local allFlags = self:getFlags()
        hook.Run("OnCharFlagsUpdated", self, allFlags)
    end)
    ```
]]
function OnCharGetup(target, entity)
end

--[[
    Purpose:
        Called when a character gets up from being ragdolled/fallen over

    When Called:
        After a player completes the getup action and the ragdoll entity is removed

    Parameters:
        - target (Player): The player who is getting up
        - entity (Entity): The ragdoll entity that is being removed

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log getup events
    hook.Add("OnCharGetup", "LogGetup", function(target, entity)
        print(string.format("%s got up", target:Name()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle getup with stamina costs
    hook.Add("OnCharGetup", "StaminaGetup", function(target, entity)
        local char = target:getChar()
        if not char then return end

        local stamina = char:getAttrib("stamina", 100)
        
        -- Cost stamina to get up
        if stamina >= 10 then
            char:updateAttrib("stamina", -10)
        else
            -- Too exhausted, fall back down
            target:notifyError("You're too exhausted to get up!")
            hook.Run("OnCharFallover", char, target, true)
            return
        end

        -- Remove ragdoll
        if IsValid(entity) then
            SafeRemoveEntity(entity)
        end

        target:notifyInfo("You got up")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced getup system
    hook.Add("OnCharGetup", "AdvancedGetup", function(target, entity)
        local char = target:getChar()
        if not char then return end

        local stamina = char:getAttrib("stamina", 100)
        local health = target:Health()
        local endurance = char:getAttrib("endurance", 50)

        -- Calculate getup difficulty based on attributes
        local staminaCost = 15
        if endurance > 70 then
            staminaCost = staminaCost - 5 -- High endurance reduces cost
        elseif endurance < 30 then
            staminaCost = staminaCost + 5 -- Low endurance increases cost
        end

        -- Health affects stamina cost
        if health < 50 then
            staminaCost = staminaCost + (50 - health) / 10 -- More injured = more stamina needed
        end

        -- Check if player can get up
        if stamina < staminaCost then
            target:notifyError(string.format("You need at least %d stamina to get up!", staminaCost))
            hook.Run("OnCharFallover", char, target, true)
            return
        end

        -- Apply stamina cost
        char:updateAttrib("stamina", -staminaCost)

        -- Remove ragdoll entity
        if IsValid(entity) then
            SafeRemoveEntity(entity)
        end

        -- Remove ragdoll network variable
        target:setNetVar("ragdoll", nil)

        -- Calculate recovery time based on health
        local recoveryTime = math.max(0, (100 - health) / 20)
        if recoveryTime > 0 then
            target:setNetVar("recovery", CurTime() + recoveryTime)
            target:setNetVar("recovering", true)
        end

        -- Apply movement penalty if injured
        if health < 50 then
            target:setWalkSpeed(target:GetWalkSpeed() * 0.7)
            target:setRunSpeed(target:GetRunSpeed() * 0.7)
            
            -- Remove penalty after recovery
            timer.Simple(10, function()
                if IsValid(target) then
                    target:setWalkSpeed(nil)
                    target:setRunSpeed(nil)
                end
            end)
        end

        -- Update statistics
        local stats = char:getData("stats", {})
        stats.timesGotUp = (stats.timesGotUp or 0) + 1
        char:setData("stats", stats)

        -- Play getup sound
        target:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 5) .. ".wav", 50, 100, 0.5)

        -- Notify player
        target:notifyInfo("You got back on your feet")

        -- Log getup
        lia.log.add(target, "charGetup", staminaCost, health)
    end)
    ```
]]
function OnCharKick(self, client)
end

--[[
    Purpose:
        Called when a character is kicked from the server

    When Called:
        After a character has been kicked (removed from the server) due to deletion, ban, or other reasons

    Parameters:
        - self (Character): The character instance being kicked
        - client (Player): The player associated with the character (may be nil if offline)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character kicks
    hook.Add("OnCharKick", "LogKicks", function(self, client)
        local playerName = IsValid(client) and client:Name() or "Offline"
        print(string.format("Character %s (ID: %d) kicked. Player: %s", 
            self:getName(), self:getID(), playerName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Save character state before kick
    hook.Add("OnCharKick", "SaveState", function(self, client)
        -- Save last position if player is online
        if IsValid(client) then
            self:setData("lastPosition", client:GetPos())
            self:setData("lastAngles", client:GetAngles())
        end

        -- Update kick statistics
        local stats = self:getData("stats", {})
        stats.totalKicks = (stats.totalKicks or 0) + 1
        stats.lastKickTime = os.time()
        self:setData("stats", stats)

        -- Log kick
        lia.log.add(client, "charKick", self:getName(), self:getID())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced kick handling
    hook.Add("OnCharKick", "AdvancedKick", function(self, client)
        local charID = self:getID()
        local steamID = IsValid(client) and client:SteamID64() or "Offline"

        -- Save character state
        if IsValid(client) then
            self:setData("lastPosition", client:GetPos())
            self:setData("lastAngles", client:GetAngles())
            self:setData("lastModel", client:GetModel())

            -- Save equipped items
            local inventory = self:getInv()
            if inventory then
                for _, item in pairs(inventory:getItems()) do
                    if item:getData("equip", false) then
                        item:setData("wasEquipped", true)
                    end
                end
            end
        end

        -- Check if character is banned
        local isBanned = self:isBanned()
        if isBanned then
            local banTime = self:getData("bannedUntil", 0)
            local banReason = self:getData("banReason", "No reason given")
            
            if IsValid(client) then
                if banTime and banTime > os.time() then
                    local timeRemaining = banTime - os.time()
                    local days = math.floor(timeRemaining / 86400)
                    client:notifyError(string.format("Your character is banned for %d more days. Reason: %s", 
                        days, banReason))
                else
                    client:notifyError(string.format("Your character is permanently banned. Reason: %s", banReason))
                end
            end
        end

        -- Update statistics
        local stats = self:getData("stats", {})
        stats.totalKicks = (stats.totalKicks or 0) + 1
        stats.lastKickTime = os.time()
        self:setData("stats", stats)

        -- Clean up temporary data
        self:setData("tempData", nil)

        -- Log kick with details
        lia.log.add(client, "charKick", self:getName(), charID, isBanned and "banned" or "normal")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("character_kicked", {
                player = steamID,
                char_id = charID,
                is_banned = isBanned
            })
        end

        -- Notify admins
        for _, admin in pairs(player.GetAll()) do
            if admin:isAdmin() and admin ~= client then
                admin:notifyInfo(string.format("Character %s (ID: %d) was kicked", 
                    self:getName(), charID))
            end
        end
    end)
    ```
]]
function OnCharNetVarChanged(character, key, oldVar, value)
end

--[[
    Purpose:
        Called when a character's network variable changes and is synchronized to clients

    When Called:
        After a character's network variable is updated and sent to clients

    Parameters:
        - character (Character): The character whose network variable changed
        - key (string): The name/key of the network variable that changed
        - oldVar: The previous value of the network variable
        - value: The new value of the network variable

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log network variable changes
    hook.Add("OnCharNetVarChanged", "LogChanges", function(character, key, oldVar, value)
        print(string.format("Character %s: %s changed from %s to %s", 
            character:getName(), key, tostring(oldVar), tostring(value)))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and handle specific variables
    hook.Add("OnCharNetVarChanged", "ValidateChanges", function(character, key, oldVar, value)
        -- Handle specific variable changes
        if key == "money" then
            local client = character:getPlayer()
            if IsValid(client) then
                -- Validate money changes (anti-cheat)
                if value < 0 then
                    lia.log.add(client, "suspicious_money_change", oldVar, value)
                    value = 0 -- Clamp to 0
                    character:getVar()[key] = value
                end
            end
        elseif key == "health" then
            -- Clamp health to valid range
            value = math.Clamp(value, 0, 100)
            character:getVar()[key] = value
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced network variable management
    hook.Add("OnCharNetVarChanged", "AdvancedNetVar", function(character, key, oldVar, value)
        local charID = character:getID()
        local client = character:getPlayer()

        -- Track change history for important variables
        local importantVars = {"money", "health", "armor", "model"}
        if table.HasValue(importantVars, key) then
            local changeHistory = character:getData("netVarHistory", {})
            if not changeHistory[key] then
                changeHistory[key] = {}
            end
            table.insert(changeHistory[key], {
                oldValue = oldVar,
                newValue = value,
                timestamp = os.time(),
                changedBy = IsValid(client) and client:SteamID64() or "System"
            })
            -- Keep only last 50 changes
            if #changeHistory[key] > 50 then
                table.remove(changeHistory[key], 1)
            end
            character:setData("netVarHistory", changeHistory)
        end

        -- Validate specific variables
        if key == "money" then
            -- Anti-cheat validation
            if isnumber(oldVar) and isnumber(value) then
                local diff = value - oldVar
                if math.abs(diff) > 10000 then
                    lia.log.add(client, "large_money_change", oldVar, value, diff)
                end
                
                -- Clamp to valid range
                value = math.max(0, math.min(value, 999999999))
                character:getVar()[key] = value
            end
        elseif key == "health" then
            -- Clamp health
            value = math.Clamp(value, 0, 100)
            character:getVar()[key] = value

            -- Health threshold notifications
            if IsValid(client) then
                if value < 25 and oldVar >= 25 then
                    client:notifyWarning("You are critically injured!")
                elseif value < 10 and oldVar >= 10 then
                    client:notifyError("You are near death!")
                end
            end
        elseif key == "model" then
            -- Validate model exists
            if isstring(value) and not util.IsValidModel(value) then
                lia.log.add(client, "invalid_model_change", value)
                -- Revert to old model
                character:getVar()[key] = oldVar
                value = oldVar
            end
        end

        -- Trigger variable-specific hooks
        hook.Run("OnChar" .. string.gsub(string.upper(string.sub(key, 1, 1)) .. string.sub(key, 2), "(%u)", function(c) return c end) .. "Changed", 
            character, oldVar, value)

        -- Log significant changes
        if key ~= "lastUpdate" and key ~= "syncTime" then
            if isnumber(oldVar) and isnumber(value) then
                local diff = math.abs(value - oldVar)
                if diff > 10 then -- Significant change
                    lia.log.add(client, "netVarChange", key, oldVar, value)
                end
            end
        end
    end)
    ```
]]
function OnCharPermakilled(character, client)
end

--[[
    Purpose:
        Called when a character is permanently killed (banned permanently from the server)

    When Called:
        After a character has been permanently banned/killed and kicked from the server

    Parameters:
        - character (Character): The character that was permanently killed
        - client (Player): The player associated with the character (can be nil if offline)
        - time (number, optional): The ban duration in seconds (nil for permanent)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log permanent kills
    hook.Add("OnCharPermakilled", "LogKills", function(character, client)
        local playerName = IsValid(client) and client:Name() or "Offline"
        print(string.format("Character %s (ID: %d) permanently killed. Player: %s", 
            character:getName(), character:getID(), playerName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle permanent kill with notifications
    hook.Add("OnCharPermakilled", "NotifyKill", function(character, client)
        local charID = character:getID()
        local charName = character:getName()
        local banReason = character:getData("banReason", "No reason specified")

        -- Notify the player
        if IsValid(client) then
            client:notifyError(string.format("Your character '%s' has been permanently killed. Reason: %s", 
                charName, banReason))
        end

        -- Notify admins
        for _, admin in pairs(player.GetAll()) do
            if admin:isAdmin() then
                admin:notifyInfo(string.format("Character %s (ID: %d) was permanently killed", 
                    charName, charID))
            end
        end

        -- Log the action
        lia.log.add(client, "charPermakilled", charName, charID, banReason)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced permanent kill handling
    hook.Add("OnCharPermakilled", "AdvancedKill", function(character, client, time)
        local charID = character:getID()
        local charName = character:getName()
        local steamID = IsValid(client) and client:SteamID64() or "Offline"
        local banReason = character:getData("banReason", "No reason specified")
        local bannedBy = character:getData("bannedBy", "System")

        -- Save character data before deletion
        local characterData = {
            name = charName,
            faction = character:getFaction(),
            class = character:getClass(),
            money = character:getMoney(),
            playtime = character:getData("playtime", 0),
            lastPosition = IsValid(client) and client:GetPos() or nil
        }

        -- Archive character data
        character:setData("archivedData", characterData)
        character:setData("archivedTime", os.time())

        -- Notify the player
        if IsValid(client) then
            if time then
                local days = math.floor(time / 86400)
                client:notifyError(string.format("Your character '%s' has been permanently killed for %d days. Reason: %s", 
                    charName, days, banReason))
            else
                client:notifyError(string.format("Your character '%s' has been permanently killed. Reason: %s", 
                    charName, banReason))
            end
        end

        -- Update statistics
        local stats = character:getData("stats", {})
        stats.permanentlyKilled = true
        stats.killedAt = os.time()
        stats.killedBy = bannedBy
        stats.killReason = banReason
        character:setData("stats", stats)

        -- Notify all admins
        for _, admin in pairs(player.GetAll()) do
            if admin:isAdmin() then
                admin:notifyInfo(string.format("Character %s (ID: %d) was permanently killed by %s. Reason: %s", 
                    charName, charID, bannedBy, banReason))
            end
        end

        -- Log with full details
        lia.log.add(client, "charPermakilled", charName, charID, banReason, bannedBy, time or "permanent")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("character_permanently_killed", {
                player = steamID,
                char_id = charID,
                char_name = charName,
                reason = banReason,
                banned_by = bannedBy,
                duration = time or 0
            })
        end

        -- Trigger follow-up hooks
        hook.Run("OnCharacterPermanentKillComplete", character, client)
    end)
    ```
]]
function OnCharRecognized(client, target)
end

--[[
    Purpose:
        Called when a player successfully recognizes another character (learns their name/identity)

    When Called:
        After a recognition action completes and the recognizing player learns the target's character name

    Parameters:
        - client (Player): The player who performed the recognition
        - target (Player, optional): The target player who was recognized (can be nil if client recognized themselves or another context)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log recognition events
    hook.Add("OnCharRecognized", "LogRecognition", function(client, target)
        if IsValid(target) then
            print(string.format("%s recognized %s", client:Name(), target:Name()))
        else
            print(string.format("%s performed recognition", client:Name()))
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track recognition statistics
    hook.Add("OnCharRecognized", "TrackRecognition", function(client, target)
        local char = client:getChar()
        if not char then return end

        if IsValid(target) then
            local targetChar = target:getChar()
            if targetChar then
                -- Update recognition stats
                local stats = char:getData("recognitionStats", {})
                stats.totalRecognized = (stats.totalRecognized or 0) + 1
                stats.lastRecognized = os.time()
                char:setData("recognitionStats", stats)

                -- Log recognition
                lia.log.add(client, "charRecognize", targetChar:getName(), targetChar:getID())
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced recognition system
    hook.Add("OnCharRecognized", "AdvancedRecognition", function(client, target)
        local char = client:getChar()
        if not char then return end

        if IsValid(target) then
            local targetChar = target:getChar()
            if not targetChar then return end

            local charID = char:getID()
            local targetID = targetChar:getID()
            local targetName = targetChar:getName()

            -- Update recognition database
            local recognizedChars = char:getData("recognizedCharacters", {})
            if not recognizedChars[targetID] then
                recognizedChars[targetID] = {
                    name = targetName,
                    firstRecognized = os.time(),
                    timesRecognized = 0,
                    lastRecognized = os.time()
                }
            else
                recognizedChars[targetID].timesRecognized = (recognizedChars[targetID].timesRecognized or 0) + 1
                recognizedChars[targetID].lastRecognized = os.time()
            end
            char:setData("recognizedCharacters", recognizedChars)

            -- Update statistics
            local stats = char:getData("recognitionStats", {})
            stats.totalRecognized = (stats.totalRecognized or 0) + 1
            stats.uniqueRecognized = table.Count(recognizedChars)
            stats.lastRecognized = os.time()
            char:setData("recognitionStats", stats)

            -- Notify client
            client:notifyInfo(string.format("You recognized %s", targetName))

            -- Check for special recognition bonuses
            if recognizedChars[targetID].timesRecognized == 1 then
                -- First time recognition bonus
                char:updateAttrib("intelligence", 1) -- Small intelligence boost
                client:notifyInfo("You gained intelligence from learning a new face!")
            end

            -- Log recognition
            lia.log.add(client, "charRecognize", targetName, targetID)

            -- Analytics tracking
            if lia.analytics then
                lia.analytics.track("character_recognized", {
                    recognizer = client:SteamID64(),
                    recognized = target:SteamID64(),
                    target_char_id = targetID
                })
            end

            -- Check if this completes a recognition quest or achievement
            hook.Run("OnRecognitionComplete", client, target, targetChar)
        else
            -- Self-recognition or other context
            char:setData("lastRecognitionTime", os.time())
        end
    end)
    ```
]]
function OnCharTradeVendor(client, vendor, item, isSellingToVendor, character, itemType, isFailed)
end

--[[
    Purpose:
        Called when a character completes a trade transaction with a vendor

    When Called:
        After a successful or failed vendor transaction (buying or selling items)

    Parameters:
        - client (Player): The player who traded with the vendor
        - vendor (Entity): The vendor entity
        - item (Item): The item involved in the trade (nil if failed)
        - isSellingToVendor (boolean): True if player sold to vendor, false if buying from vendor
        - character (Character): The character making the trade
        - itemType (string): The unique ID of the item type being traded
        - isFailed (boolean): True if the trade failed, false if successful

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log vendor trades
    hook.Add("OnCharTradeVendor", "LogTrades", function(client, vendor, item, isSellingToVendor, character, itemType, isFailed)
        local action = isSellingToVendor and "sold" or "bought"
        local vendorName = vendor:getNetVar("name", "Unknown Vendor")
        local itemName = item and item:getName() or itemType
        print(string.format("%s %s %s from/to %s (Failed: %s)", 
            client:Name(), action, itemName, vendorName, tostring(isFailed)))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track trade statistics
    hook.Add("OnCharTradeVendor", "TrackTrades", function(client, vendor, item, isSellingToVendor, character, itemType, isFailed)
        if isFailed then return end

        local vendorName = vendor:getNetVar("name", "Unknown")
        local itemName = item and item:getName() or itemType

        -- Update trade statistics
        local stats = character:getData("tradeStats", {})
        if isSellingToVendor then
            stats.itemsSold = (stats.itemsSold or 0) + 1
            stats.moneyEarned = (stats.moneyEarned or 0) + (item and item:getData("price", 0) or 0)
        else
            stats.itemsBought = (stats.itemsBought or 0) + 1
            stats.moneySpent = (stats.moneySpent or 0) + (item and item:getData("price", 0) or 0)
        end
        character:setData("tradeStats", stats)

        -- Log trade
        if isSellingToVendor then
            lia.log.add(client, "vendorSell", itemName, vendorName)
        else
            lia.log.add(client, "vendorBuy", itemName, vendorName)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced vendor trade system
    hook.Add("OnCharTradeVendor", "AdvancedTrade", function(client, vendor, item, isSellingToVendor, character, itemType, isFailed)
        local vendorName = vendor:getNetVar("name", "Unknown Vendor")
        local vendorType = vendor:getNetVar("vendorType", "general")

        if isFailed then
            -- Handle failed trades
            local failReason = character:getData("lastTradeFailReason", "Unknown")
            lia.log.add(client, "vendorTradeFailed", itemType, vendorName, failReason)
            return
        end

        local itemName = item and item:getName() or itemType
        local itemPrice = item and item:getData("price", 0) or 0

        -- Update trade statistics
        local stats = character:getData("tradeStats", {})
        if isSellingToVendor then
            stats.itemsSold = (stats.itemsSold or 0) + 1
            stats.moneyEarned = (stats.moneyEarned or 0) + itemPrice
            stats.lastSale = {
                item = itemName,
                vendor = vendorName,
                price = itemPrice,
                timestamp = os.time()
            }
        else
            stats.itemsBought = (stats.itemsBought or 0) + 1
            stats.moneySpent = (stats.moneySpent or 0) + itemPrice
            stats.lastPurchase = {
                item = itemName,
                vendor = vendorName,
                price = itemPrice,
                timestamp = os.time()
            }
        end
        character:setData("tradeStats", stats)

        -- Vendor-specific bonuses
        if vendorType == "black_market" then
            -- Black market trades are riskier but more profitable
            if isSellingToVendor then
                character:setData("blackMarketSales", (character:getData("blackMarketSales", 0) + 1))
            end
        elseif vendorType == "legal_shop" then
            -- Legal shops give reputation
            if not isSellingToVendor then
                character:updateAttrib("reputation", 1)
            end
        end

        -- Track vendor relationship
        local vendorRelations = character:getData("vendorRelations", {})
        if not vendorRelations[vendorName] then
            vendorRelations[vendorName] = {
                trades = 0,
                moneySpent = 0,
                moneyEarned = 0,
                firstTrade = os.time()
            }
        end
        if isSellingToVendor then
            vendorRelations[vendorName].moneyEarned = vendorRelations[vendorName].moneyEarned + itemPrice
        else
            vendorRelations[vendorName].moneySpent = vendorRelations[vendorName].moneySpent + itemPrice
        end
        vendorRelations[vendorName].trades = vendorRelations[vendorName].trades + 1
        vendorRelations[vendorName].lastTrade = os.time()
        character:setData("vendorRelations", vendorRelations)

        -- Check for achievement unlocks
        if vendorRelations[vendorName].trades == 100 then
            client:notifyInfo("You've made 100 trades with " .. vendorName .. "! You get a discount!")
            -- Apply discount for future trades
            vendorRelations[vendorName].discount = 0.1 -- 10% discount
        end

        -- Log trade
        if isSellingToVendor then
            lia.log.add(client, "vendorSell", itemName, vendorName, itemPrice)
        else
            lia.log.add(client, "vendorBuy", itemName, vendorName, itemPrice)
        end

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("vendor_trade", {
                player = client:SteamID64(),
                vendor = vendorName,
                item = itemType,
                is_selling = isSellingToVendor,
                price = itemPrice
            })
        end
    end)
    ```
]]
function OnCharVarChanged(character, varName, oldVar, newVar)
end

--[[
    Purpose:
        Called when a character's custom variable changes

    When Called:
        After a character's custom variable (registered via lia.char.registerVar) is modified

    Parameters:
        - character (Character): The character whose variable changed
        - varName (string): The name/key of the variable that changed
        - oldVar: The previous value of the variable
        - newVar: The new value of the variable

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log variable changes
    hook.Add("OnCharVarChanged", "MyAddon", function(character, varName, oldVar, newVar)
    print(character:getName() .. " var changed: " .. varName .. " = " .. tostring(newVar))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track specific variable changes
    hook.Add("OnCharVarChanged", "VarTracking", function(character, varName, oldVar, newVar)
    if varName == "level" then
        local client = character:getPlayer()
        if client then
            client:ChatPrint("Level changed from " .. oldVar .. " to " .. newVar)
            end
    elseif varName == "money" then
        local client = character:getPlayer()
        if client then
            local difference = newVar - oldVar
            if difference > 0 then
                client:ChatPrint("You gained $" .. difference)
            elseif difference < 0 then
                client:ChatPrint("You lost $" .. math.abs(difference))
                end
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex variable change system
    hook.Add("OnCharVarChanged", "AdvancedVarChange", function(character, varName, oldVar, newVar)
    local client = character:getPlayer()
    if not client then return end
        -- Track variable change history
        local changeHistory = character:getData("varHistory", {})
        changeHistory[varName] = changeHistory[varName] or {}
        table.insert(changeHistory[varName], {
        oldValue = oldVar,
        newValue = newVar,
        timestamp = os.time()
        })
        -- Keep only last 20 changes per variable
        if #changeHistory[varName] > 20 then
            table.remove(changeHistory[varName], 1)
            end
        character:setData("varHistory", changeHistory)
        -- Handle specific variable changes
        if varName == "level" then
            -- Level change effects
            if newVar > oldVar then
                hook.Run("OnPlayerLevelUp", client, oldVar, newVar)
                end
        elseif varName == "money" then
            -- Money change effects
            local difference = newVar - oldVar
            if difference > 0 then
                client:ChatPrint("You gained $" .. difference)
            elseif difference < 0 then
                client:ChatPrint("You lost $" .. math.abs(difference))
                end
            -- Check for money milestones
            if newVar >= 10000 and oldVar < 10000 then
                client:ChatPrint("Congratulations! You've reached $10,000!")
            elseif newVar >= 100000 and oldVar < 100000 then
                client:ChatPrint("Congratulations! You've reached $100,000!")
                end
            end
        end)
    ```
]]
function OnCheaterCaught(client)
end

--[[
    Purpose:
        Called when an anti-cheat system detects a cheater or when a player is marked as a cheater

    When Called:
        When a player is detected or confirmed to be cheating by the anti-cheat system

    Parameters:
        - client (Player): The player who was caught cheating

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log cheater detection
    hook.Add("OnCheaterCaught", "LogCheaters", function(client)
        print(string.format("Cheater detected: %s (%s)", client:Name(), client:SteamID()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle cheater detection with actions
    hook.Add("OnCheaterCaught", "HandleCheaters", function(client)
        -- Mark player as cheater
        client:setLiliaData("cheater", true)
        client:setNetVar("cheater", true)

        -- Kick the player
        client:Kick("Cheating detected. Please contact an administrator.")

        -- Log the action
        lia.log.add(client, "cheaterCaught", "Anti-cheat detection")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced cheater handling system
    hook.Add("OnCheaterCaught", "AdvancedCheater", function(client)
        local steamID = client:SteamID64()
        local char = client:getChar()

        -- Mark player as cheater
        client:setLiliaData("cheater", true)
        client:setNetVar("cheater", true)

        -- Update cheater database
        local cheaterData = {
            steamID = steamID,
            name = client:Name(),
            detectedAt = os.time(),
            charID = char and char:getID() or nil,
            charName = char and char:getName() or nil
        }

        -- Save to cheater list
        local cheaters = lia.config.get("knownCheaters", {})
        cheaters[steamID] = cheaterData
        lia.config.set("knownCheaters", cheaters)

        -- Notify all admins
        for _, admin in pairs(player.GetAll()) do
            if admin:isAdmin() then
                admin:notifyError(string.format("CHEATER DETECTED: %s (%s)", 
                    client:Name(), steamID))
            end
        end

        -- Add warning to character if exists
        if char then
            local adminModule = lia.module.get("administration")
            if adminModule then
                local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
                adminModule:AddWarning(
                    char:getID(),
                    client:Nick(),
                    steamID,
                    timestamp,
                    "Caught by anti-cheat system",
                    "System",
                    "SYSTEM"
                )
            end
        end

        -- Log with full details
        lia.log.add(client, "cheaterCaught", "Anti-cheat detection", steamID)

        -- Ban the player temporarily
        if lia.config.get("autoBanCheaters", false) then
            client:Ban(1440, true) -- 24 hour ban
        else
            -- Just kick
            client:Kick("Cheating detected. Please contact an administrator.")
        end

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("cheater_caught", {
                player = steamID,
                char_id = char and char:getID() or nil
            })
        end
    end)
    ```
]]
function OnCheaterStatusChanged(client, target, status)
end

--[[
    Purpose:
        Called when a player's cheater status is manually changed by an admin

    When Called:
        When an admin marks or unmarks a player as a cheater using admin commands

    Parameters:
        - client (Player): The admin who changed the status
        - target (Player): The player whose cheater status was changed
        - status (boolean): True if marked as cheater, false if unmarked

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log status changes
    hook.Add("OnCheaterStatusChanged", "LogStatus", function(client, target, status)
        local action = status and "marked" or "unmarked"
        print(string.format("%s %s %s as cheater", 
            client:Name(), action, target:Name()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle status changes with notifications
    hook.Add("OnCheaterStatusChanged", "NotifyStatus", function(client, target, status)
        -- Update target's cheater status
        target:setLiliaData("cheater", status)
        target:setNetVar("cheater", status and true or nil)

        if status then
            target:notifyWarning("You have been marked as a cheater by an administrator!")
            client:notifyInfo(string.format("Marked %s as a cheater", target:Name()))
        else
            target:notifyInfo("Your cheater mark has been removed!")
            client:notifyInfo(string.format("Unmarked %s as a cheater", target:Name()))
        end

        -- Log the action
        lia.log.add(client, "cheaterStatusChanged", target:Name(), status)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced cheater status management
    hook.Add("OnCheaterStatusChanged", "AdvancedStatus", function(client, target, status)
        local targetSteamID = target:SteamID64()
        local adminSteamID = client:SteamID64()
        local targetChar = target:getChar()

        -- Update cheater status
        target:setLiliaData("cheater", status)
        target:setNetVar("cheater", status and true or nil)

        -- Update cheater database
        local cheaters = lia.config.get("knownCheaters", {})
        if status then
            cheaters[targetSteamID] = {
                steamID = targetSteamID,
                name = target:Name(),
                markedAt = os.time(),
                markedBy = adminSteamID,
                markedByAdmin = client:Name(),
                charID = targetChar and targetChar:getID() or nil
            }
            
            -- Add warning to character
            if targetChar then
                local adminModule = lia.module.get("administration")
                if adminModule then
                    local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
                    adminModule:AddWarning(
                        targetChar:getID(),
                        target:Nick(),
                        targetSteamID,
                        timestamp,
                        "Marked as cheater by " .. client:Name(),
                        client:Nick(),
                        adminSteamID
                    )
                end
            end

            target:notifyError("You have been marked as a cheater by " .. client:Name() .. "!")
            client:notifyInfo(string.format("Marked %s as a cheater", target:Name()))
        else
            -- Remove from cheater database
            if cheaters[targetSteamID] then
                cheaters[targetSteamID].removedAt = os.time()
                cheaters[targetSteamID].removedBy = adminSteamID
                cheaters[targetSteamID].removedByAdmin = client:Name()
            end

            target:notifyInfo("Your cheater mark has been removed by " .. client:Name() .. "!")
            client:notifyInfo(string.format("Unmarked %s as a cheater", target:Name()))
        end
        lia.config.set("knownCheaters", cheaters)

        -- Restrict cheater actions
        if status and lia.config.get("DisableCheaterActions", true) then
            target:notifyWarning("Your actions are now restricted due to cheater status!")
        end

        -- Notify admins
        for _, admin in pairs(player.GetAll()) do
            if admin:isAdmin() and admin ~= client then
                local action = status and "marked" or "unmarked"
                admin:notifyInfo(string.format("%s %s %s as cheater", 
                    client:Name(), action, target:Name()))
            end
        end

        -- Log the action
        lia.log.add(client, "cheaterStatusChanged", target:Name(), targetSteamID, status)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("cheater_status_changed", {
                admin = adminSteamID,
                target = targetSteamID,
                status = status
            })
        end
    end)
    ```
]]
function OnCreatePlayerRagdoll(self, entity, isDead)
end

--[[
    Purpose:
        Called when a player ragdoll is created (when a player dies or falls over)

    When Called:
        After a ragdoll entity is spawned for a player

    Parameters:
        - self (Player): The player whose ragdoll was created
        - entity (Entity): The ragdoll entity that was created
        - isDead (boolean): True if the player is dead, false if just ragdolled (falling over)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log ragdoll creation
    hook.Add("OnCreatePlayerRagdoll", "LogRagdoll", function(self, entity, isDead)
        local reason = isDead and "death" or "fallover"
        print(string.format("%s ragdolled (%s)", self:Name(), reason))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Customize ragdoll appearance
    hook.Add("OnCreatePlayerRagdoll", "CustomRagdoll", function(self, entity, isDead)
        if IsValid(entity) then
            -- Set ragdoll model to match player
            entity:SetModel(self:GetModel())
            entity:SetSkin(self:GetSkin())
            
            -- Set ragdoll color
            entity:SetColor(self:GetColor())

            -- If dead, add blood effects
            if isDead then
                -- Spawn blood decal
                util.Decal("Blood", entity:GetPos(), entity:GetPos() - Vector(0, 0, 100))
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ragdoll system
    hook.Add("OnCreatePlayerRagdoll", "AdvancedRagdoll", function(self, entity, isDead)
        local char = self:getChar()
        if not char or not IsValid(entity) then return end

        -- Set ragdoll appearance
        entity:SetModel(self:GetModel())
        entity:SetSkin(self:GetSkin())
        entity:SetColor(self:GetColor())

        -- Store ragdoll data
        entity.liaPlayer = self
        entity.liaCharacter = char
        entity.liaIsDead = isDead
        entity.liaCreationTime = CurTime()

        -- Death-specific handling
        if isDead then
            -- Set death time
            char:setData("deathTime", os.time())
            
            -- Create blood effects
            local pos = entity:GetPos()
            local effectdata = EffectData()
            effectdata:SetOrigin(pos)
            effectdata:SetNormal(Vector(0, 0, 1))
            effectdata:SetScale(1)
            util.Effect("bloodimpact", effectdata)

            -- Spawn blood decal
            util.Decal("Blood", pos, pos - Vector(0, 0, 100))

            -- Drop equipped items
            local inventory = char:getInv()
            if inventory then
                for _, item in pairs(inventory:getItems()) do
                    if item:getData("equip", false) and item:getData("dropOnDeath", false) then
                        item:spawn(self:getItemDropPos())
                    end
                end
            end

            -- Store death position
            char:setData("deathPosition", pos)

            -- Notify nearby players
            for _, ply in pairs(player.GetAll()) do
                if ply:GetPos():Distance(pos) <= 512 then
                    if ply ~= self then
                        ply:notify(string.format("%s died", self:Name()))
                    end
                end
            end
        end

        -- Set ragdoll physics properties
        timer.Simple(0.1, function()
            if IsValid(entity) then
                for i = 0, entity:GetPhysicsObjectCount() - 1 do
                    local physObj = entity:GetPhysicsObjectNum(i)
                    if IsValid(physObj) then
                        -- Adjust ragdoll weight based on character
                        local weight = char:getData("weight", 70)
                        physObj:SetMass(weight)

                        -- Apply inertia scaling
                        if isDead then
                            physObj:EnableMotion(false) -- Freeze initially
                            timer.Simple(1, function()
                                if IsValid(entity) and IsValid(physObj) then
                                    physObj:EnableMotion(true)
                                end
                            end)
                        end
                    end
                end
            end
        end)

        -- Auto-remove ragdoll after time
        if isDead then
            timer.Simple(lia.config.get("RagdollRemoveTime", 300), function()
                if IsValid(entity) then
                    SafeRemoveEntity(entity)
                end
            end)
        end

        -- Log ragdoll creation
        lia.log.add(self, "ragdollCreated", isDead and "death" or "fallover")
    end)
    ```
]]
function OnDataSet(key, value, gamemode, map)
end

--[[
    Purpose:
        Called after persistent data has been saved to the database

    When Called:
        After data is successfully saved to the database with optional gamemode/map scoping

    Parameters:
        - key (string): The data key that was saved
        - value: The data value that was saved
        - gamemode (string, optional): The gamemode scope for this data (nil if global)
        - map (string, optional): The map scope for this data (nil if gamemode-only or global)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log data saves
    hook.Add("OnDataSet", "LogSaves", function(key, value, gamemode, map)
        local scope = map and (gamemode .. "/" .. map) or (gamemode or "global")
        print(string.format("Data saved: %s = %s (scope: %s)", key, tostring(value), scope))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Cache data after save
    hook.Add("OnDataSet", "CacheData", function(key, value, gamemode, map)
        -- Update in-memory cache
        local scope = map and (gamemode .. "/" .. map) or (gamemode or "global")
        if not lia.dataCache then
            lia.dataCache = {}
        end
        if not lia.dataCache[scope] then
            lia.dataCache[scope] = {}
        end
        lia.dataCache[scope][key] = value

        -- Log important data saves
        if key:find("config") or key:find("setting") then
            lia.log.add(nil, "dataSaved", key, scope)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced data management
    hook.Add("OnDataSet", "AdvancedData", function(key, value, gamemode, map)
        local scope = map and (gamemode .. "/" .. map) or (gamemode or "global")

        -- Update cache
        if not lia.dataCache then
            lia.dataCache = {}
        end
        if not lia.dataCache[scope] then
            lia.dataCache[scope] = {}
        end
        lia.dataCache[scope][key] = value
        lia.dataCache[scope][key .. "_timestamp"] = os.time()

        -- Validate critical data
        if key == "serverSettings" then
            if istable(value) and value.maxPlayers then
                game.SetMaxPlayers(value.maxPlayers)
            end
        elseif key == "worldState" then
            -- Broadcast world state changes to clients
            net.Start("liaWorldStateUpdate")
            net.WriteString(key)
            net.WriteType(value)
            net.Broadcast()
        end

        -- Track data change history
        local changeHistory = lia.config.get("dataChangeHistory", {})
        if not changeHistory[key] then
            changeHistory[key] = {}
        end
        table.insert(changeHistory[key], {
            value = value,
            scope = scope,
            timestamp = os.time()
        })
        -- Keep only last 50 changes
        if #changeHistory[key] > 50 then
            table.remove(changeHistory[key], 1)
        end
        lia.config.set("dataChangeHistory", changeHistory)

        -- Log important saves
        local importantKeys = {"serverConfig", "worldState", "economySettings"}
        if table.HasValue(importantKeys, key) then
            lia.log.add(nil, "dataSaved", key, scope, type(value))
        end

        -- Trigger data-specific hooks
        hook.Run("OnData" .. string.gsub(string.upper(string.sub(key, 1, 1)) .. string.sub(key, 2), "(%u)", function(c) return c end) .. "Set", 
            value, gamemode, map)
    end)
    ```
]]
function OnDatabaseLoaded()
end

--[[
    Purpose:
        Called when databaseloaded occurs

    When Called:
        After databaseloaded has happened

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log database load
    hook.Add("OnDatabaseLoaded", "MyAddon", function()
    print("Database has been loaded successfully")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Initialize custom data after database load
    hook.Add("OnDatabaseLoaded", "DatabaseInit", function()
    -- Check for required tables
    lia.db.query("CREATE TABLE IF NOT EXISTS custom_logs (id INTEGER PRIMARY KEY, timestamp INTEGER, message TEXT)")
    lia.db.query("CREATE TABLE IF NOT EXISTS player_stats (steamid TEXT PRIMARY KEY, playtime INTEGER, joins INTEGER)")

    -- Load server configuration
    local serverConfig = lia.data.get("serverConfig", nil, false, "global")
    if not serverConfig then
        -- Create default config
        lia.data.set("serverConfig", {
            maxPlayers = 32,
            serverName = "Lilia Server",
            welcomeMessage = "Welcome to our server!"
        }, false, "global")
    end

    print("Database initialization complete")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Comprehensive database setup and validation
    hook.Add("OnDatabaseLoaded", "AdvancedDatabaseSetup", function()
    -- Validate critical tables exist
    local requiredTables = {
        "characters",
        "players",
        "items",
        "inventories"
    }

    for _, tableName in ipairs(requiredTables) do
        lia.db.query("SELECT name FROM sqlite_master WHERE type='table' AND name='" .. tableName .. "'", function(result)
            if not result or #result == 0 then
                print("WARNING: Required table '" .. tableName .. "' is missing!")
                -- Attempt to recreate basic structure
                if tableName == "characters" then
                    lia.db.query([[
                        CREATE TABLE characters (
                            id INTEGER PRIMARY KEY,
                            steamID TEXT,
                            name TEXT,
                            model TEXT,
                            faction TEXT,
                            money INTEGER DEFAULT 0,
                            data TEXT
                        )
                    ]])
                end
            end
        end)
    end

    -- Setup database maintenance
    timer.Create("DatabaseMaintenance", 3600, 0, function()
        -- Clean up old temporary data
        lia.db.query("DELETE FROM items WHERE data LIKE '%\"temp\":true%' AND created < " .. (os.time() - 86400))
        -- Optimize database
        lia.db.query("VACUUM")
        print("Database maintenance completed")
    end)

    -- Initialize server statistics
    local serverStats = lia.data.get("serverStats", nil, false, "global")
    if not serverStats then
        serverStats = {
            totalPlayers = 0,
            totalCharacters = 0,
            serverStartTime = os.time(),
            version = lia.version or "unknown"
        }
        lia.data.set("serverStats", serverStats, false, "global")
    end

    -- Update server uptime
    serverStats.lastLoadTime = os.time()
    lia.data.set("serverStats", serverStats, false, "global")

    print("Advanced database setup and validation complete")
    end)
    ```
]]
function OnEntityLoaded(createdEnt, data)
end

--[[
    Purpose:
        Called when entityloaded occurs

    When Called:
        After entityloaded has happened

    Parameters:
        - createdEnt: Description
        - data: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log entity loading
    hook.Add("OnEntityLoaded", "MyAddon", function(createdEnt, data)
    print("Entity loaded: " .. tostring(createdEnt) .. " with data: " .. tostring(data))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Apply entity modifications after loading
    hook.Add("OnEntityLoaded", "EntitySetup", function(createdEnt, data)
    if IsValid(createdEnt) then
        -- Restore custom properties
        if data.customColor then
            createdEnt:SetColor(data.customColor)
        end

        if data.customMaterial then
            createdEnt:SetMaterial(data.customMaterial)
        end

        -- Apply physics settings
        if data.frozen then
            local phys = createdEnt:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
            end
        end

        -- Mark as loaded
        createdEnt:setNetVar("loaded", true)
        createdEnt:setNetVar("loadTime", os.time())
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced entity restoration and validation
    hook.Add("OnEntityLoaded", "AdvancedEntityLoading", function(createdEnt, data)
    if not IsValid(createdEnt) then return end

    -- Validate entity data integrity
    if not data or not istable(data) then
        print("WARNING: Entity " .. tostring(createdEnt) .. " loaded with invalid data")
        return
    end

    -- Restore complex properties
    if data.customProperties then
        for key, value in pairs(data.customProperties) do
            if key == "color" then
                createdEnt:SetColor(value)
            elseif key == "material" then
                createdEnt:SetMaterial(value)
            elseif key == "model" then
                createdEnt:SetModel(value)
            elseif key == "skin" then
                createdEnt:SetSkin(value)
            elseif key == "bodygroups" and istable(value) then
                for bgID, bgValue in pairs(value) do
                    createdEnt:SetBodygroup(bgID, bgValue)
                end
            end
        end
    end

    -- Restore physics and movement properties
    if data.physics then
        local phys = createdEnt:GetPhysicsObject()
        if IsValid(phys) then
            if data.physics.motion ~= nil then
                phys:EnableMotion(data.physics.motion)
            end
            if data.physics.gravity ~= nil then
                phys:EnableGravity(data.physics.gravity)
            end
            if data.physics.drag ~= nil then
                phys:SetDragCoefficient(data.physics.drag)
            end
        end
    end

    -- Restore entity relationships
    if data.owner then
        createdEnt:setNetVar("owner", data.owner)
    end

    if data.creator then
        createdEnt:setNetVar("creator", data.creator)
        createdEnt:setNetVar("creationTime", data.creationTime or os.time())
    end

    -- Apply security measures
    if data.trustedPlayers and istable(data.trustedPlayers) then
        createdEnt:setNetVar("trustedPlayers", data.trustedPlayers)
    end

    -- Setup entity monitoring
    timer.Simple(1, function()
        if IsValid(createdEnt) then
            -- Log successful loading
            lia.log.add(nil, "entityLoaded", createdEnt:GetClass(), createdEnt:GetPos())

            -- Broadcast entity loaded event
            net.Start("liaEntityLoaded")
            net.WriteEntity(createdEnt)
            net.WriteTable(data)
            net.Broadcast()
        end
    end)

    print("Entity " .. createdEnt:GetClass() .. " fully loaded and configured")
    end)
    ```
]]
function OnEntityPersistUpdated(ent, data)
end

--[[
    Purpose:
        Called when entitypersistupdated occurs

    When Called:
        After entitypersistupdated has happened

    Parameters:
        - ent: Description
        - data: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log persistence updates
    hook.Add("OnEntityPersistUpdated", "MyAddon", function(ent, data)
    print("Entity " .. tostring(ent) .. " persistence updated")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate persistence data
    hook.Add("OnEntityPersistUpdated", "PersistenceValidation", function(ent, data)
    if not IsValid(ent) then return end

    -- Ensure critical data exists
    if not data.position then
        data.position = ent:GetPos()
    end

    if not data.angles then
        data.angles = ent:GetAngles()
    end

    -- Update last modified timestamp
    data.lastModified = os.time()

    -- Log important updates
    if data.owner and data.owner ~= ent:getNetVar("owner") then
        lia.log.add(nil, "entityOwnerChanged", ent:GetClass(), data.owner, ent:getNetVar("owner"))
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced persistence management
    hook.Add("OnEntityPersistUpdated", "AdvancedPersistence", function(ent, data)
    if not IsValid(ent) then return end

    -- Create persistence history
    if not data.persistenceHistory then
        data.persistenceHistory = {}
    end

    table.insert(data.persistenceHistory, {
        timestamp = os.time(),
        position = ent:GetPos(),
        health = ent:Health(),
        owner = ent:getNetVar("owner")
    })

    -- Keep only last 20 entries
    if #data.persistenceHistory > 20 then
        table.remove(data.persistenceHistory, 1)
    end

    -- Validate and sanitize data
    if data.customData then
        for key, value in pairs(data.customData) do
            -- Remove potentially problematic data
            if type(value) == "function" or type(value) == "userdata" then
                data.customData[key] = nil
                print("WARNING: Removed invalid data type from persistence: " .. key)
            end
        end
    end

    -- Update entity statistics
    local persistCount = (data.persistCount or 0) + 1
    data.persistCount = persistCount
    data.lastPersistTime = os.time()

    -- Check for persistence limits
    if persistCount > 100 then
        print("WARNING: Entity " .. ent:GetClass() .. " has been persisted " .. persistCount .. " times")
    end

    -- Broadcast persistence update to relevant clients
    local owner = ent:getNetVar("owner")
    if owner then
        local ownerPlayer = player.GetBySteamID(owner)
        if IsValid(ownerPlayer) then
            net.Start("liaEntityPersistenceUpdated")
            net.WriteEntity(ent)
            net.WriteTable(data)
            net.Send(ownerPlayer)
        end
    end

    -- Trigger persistence events
    hook.Run("OnEntityPersistenceSaved", ent, data)
    end)
    ```
]]
function OnEntityPersisted(ent, entData)
end

--[[
    Purpose:
        Called when entitypersisted occurs

    When Called:
        After entitypersisted has happened

    Parameters:
        - ent: Description
        - entData: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log entity persistence
    hook.Add("OnEntityPersisted", "MyAddon", function(ent, entData)
    print("Entity " .. tostring(ent) .. " has been persisted")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Update persistence statistics
    hook.Add("OnEntityPersisted", "PersistenceStats", function(ent, entData)
    if not IsValid(ent) then return end

    -- Update server persistence stats
    local persistStats = lia.data.get("persistenceStats", {}, false, "global")
    persistStats.totalPersisted = (persistStats.totalPersisted or 0) + 1
    persistStats[ent:GetClass()] = (persistStats[ent:GetClass()] or 0) + 1
    lia.data.set("persistenceStats", persistStats, false, "global")

    -- Mark entity as persisted
    ent:setNetVar("persisted", true)
    ent:setNetVar("persistTime", os.time())

    -- Log persistence
    lia.log.add(nil, "entityPersisted", ent:GetClass(), ent:GetPos())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced persistence tracking and validation
    hook.Add("OnEntityPersisted", "AdvancedPersistenceTracking", function(ent, entData)
    if not IsValid(ent) then return end

    -- Validate persistence data
    if not entData or not istable(entData) then
        print("WARNING: Invalid persistence data for entity " .. tostring(ent))
        return
    end

    -- Update global persistence statistics
    local stats = lia.data.get("advancedPersistenceStats", {
        totalEntities = 0,
        entitiesByType = {},
        entitiesByOwner = {},
        persistenceFrequency = {},
        lastPersistenceTime = 0
    }, false, "global")

    stats.totalEntities = stats.totalEntities + 1
    stats.lastPersistenceTime = os.time()

    -- Track by entity type
    local entType = ent:GetClass()
    stats.entitiesByType[entType] = (stats.entitiesByType[entType] or 0) + 1

    -- Track by owner
    local owner = ent:getNetVar("owner") or "unknown"
    stats.entitiesByOwner[owner] = (stats.entitiesByOwner[owner] or 0) + 1

    -- Track persistence frequency (per hour)
    local currentHour = math.floor(os.time() / 3600)
    stats.persistenceFrequency[tostring(currentHour)] = (stats.persistenceFrequency[tostring(currentHour)] or 0) + 1

    lia.data.set("advancedPersistenceStats", stats, false, "global")

    -- Clean up old frequency data (keep last 24 hours)
    for hourStr, count in pairs(stats.persistenceFrequency) do
        local hour = tonumber(hourStr)
        if hour and (currentHour - hour) > 24 then
            stats.persistenceFrequency[hourStr] = nil
        end
    end

    -- Update entity-specific data
    entData.persistenceCount = (entData.persistenceCount or 0) + 1
    entData.lastPersisted = os.time()

    -- Check for persistence abuse
    if entData.persistenceCount > 50 then
        print("WARNING: Entity " .. ent:GetClass() .. " has been persisted " .. entData.persistenceCount .. " times")
        lia.log.add(nil, "excessivePersistence", ent:GetClass(), entData.persistenceCount, ent:GetPos())
    end

    -- Notify owner if online
    local ownerPlayer = owner ~= "unknown" and player.GetBySteamID(owner)
    if IsValid(ownerPlayer) then
        ownerPlayer:ChatPrint("Your " .. ent:GetClass() .. " has been saved to the database.")
    end

    -- Trigger custom persistence events
    hook.Run("OnEntityPersistenceComplete", ent, entData)

    print("Entity " .. ent:GetClass() .. " successfully persisted (total: " .. stats.totalEntities .. ")")
    end)
    ```
]]
function OnItemAdded(owner, item)
end

--[[
    Purpose:
        Called when itemadded occurs

    When Called:
        After itemadded has happened

    Parameters:
        - owner: Description
        - item: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item addition
    hook.Add("OnItemAdded", "MyAddon", function(owner, item)
    print("Item " .. item.uniqueID .. " added to " .. tostring(owner))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track item statistics
    hook.Add("OnItemAdded", "ItemStats", function(owner, item)
    -- Update item statistics
    local itemStats = lia.data.get("itemStats", {}, false, "global")
    itemStats.totalItems = (itemStats.totalItems or 0) + 1
    itemStats[item.uniqueID] = (itemStats[item.uniqueID] or 0) + 1
    lia.data.set("itemStats", itemStats, false, "global")

    -- Log valuable item additions
    if item:getData("value", 0) > 1000 then
        lia.log.add(owner, "valuableItemAdded", item.uniqueID, item:getData("value"))
    end

    -- Notify owner if they're a player
    if IsValid(owner) and owner:IsPlayer() then
        local char = owner:getChar()
        if char then
            char:setData("itemsReceived", (char:getData("itemsReceived", 0) + 1))
        end
    end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item management and validation
    hook.Add("OnItemAdded", "AdvancedItemManagement", function(owner, item)
    -- Validate item integrity
    if not item or not item.uniqueID then
        print("WARNING: Invalid item added to " .. tostring(owner))
        return
    end

    -- Track item ownership history
    if not item:getData("ownershipHistory") then
        item:setData("ownershipHistory", {})
    end

    table.insert(item:getData("ownershipHistory"), {
        owner = IsValid(owner) and owner:IsPlayer() and owner:SteamID() or tostring(owner),
        timestamp = os.time(),
        action = "added"
    })

    -- Keep only last 10 ownership changes
    local history = item:getData("ownershipHistory")
    if #history > 10 then
        table.remove(history, 1)
        item:setData("ownershipHistory", history)
    end

    -- Update global item tracking
    local globalItems = lia.data.get("globalItemTracking", {}, false, "global")
    globalItems[item.uniqueID] = (globalItems[item.uniqueID] or 0) + 1
    lia.data.set("globalItemTracking", globalItems, false, "global")

    -- Check for item limits
    if IsValid(owner) and owner:IsPlayer() then
        local char = owner:getChar()
        if char then
            local inventory = char:getInv()
            if inventory then
                local itemCount = inventory:getItemCount(item.uniqueID)
                local maxItems = item.maxItems or 10

                if itemCount > maxItems then
                    owner:ChatPrint("Warning: You have " .. itemCount .. " of item '" .. item.name .. "' (max: " .. maxItems .. ")")
                end
            end
        end
    end

    -- Trigger item-specific events
    hook.Run("OnSpecificItemAdded", owner, item)

    -- Log comprehensive item data
    lia.log.add(owner, "itemAdded", {
        itemID = item.uniqueID,
        itemName = item.name,
        value = item:getData("value", 0),
        quantity = item:getData("quantity", 1),
        timestamp = os.time()
    })

    print("Item " .. item.uniqueID .. " added to inventory of " .. tostring(owner))
    end)
    ```
]]
function OnItemCreated(itemTable, self)
end

--[[
    Purpose:
        Called when itemcreated occurs

    When Called:
        After itemcreated has happened

    Parameters:
        - itemTable: Description
        - self: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("OnItemCreated", "MyAddon", function(itemTable, self)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("OnItemCreated", "MyAddon", function(itemTable, self)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("OnItemCreated", "MyAddon", function(itemTable, self)
        -- Add your code here
    end)
    ```
]]
function OnItemSpawned(self)
end

--[[
    Purpose:
        Called when an item entity is spawned in the world

    When Called:
        After an item entity is created and initialized in the world

    Parameters:
        - self (Entity): The item entity that was spawned

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item spawns
    hook.Add("OnItemSpawned", "LogSpawns", function(self)
        local itemTable = self:getItemTable()
        if itemTable then
            print(string.format("Item %s spawned at %s", itemTable.name, tostring(self:GetPos())))
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Set item properties on spawn
    hook.Add("OnItemSpawned", "SetProperties", function(self)
        local itemTable = self:getItemTable()
        if not itemTable then return end

        -- Set physics properties
        local physObj = self:GetPhysicsObject()
        if IsValid(physObj) then
            -- Set weight based on item
            local weight = itemTable.weight or 1
            physObj:SetMass(weight)

            -- Make items easier to pick up
            physObj:EnableMotion(true)
        end

        -- Set item glow if valuable
        if itemTable.value and itemTable.value > 1000 then
            self:SetGlow(true)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item spawn system
    hook.Add("OnItemSpawned", "AdvancedSpawn", function(self)
        local itemID = self.liaItemID
        local item = lia.item.instances[itemID]
        if not item then return end

        local itemTable = itemTable or item
        local pos = self:GetPos()

        -- Set physics properties
        local physObj = self:GetPhysicsObject()
        if IsValid(physObj) then
            local weight = itemTable.weight or 1
            physObj:SetMass(weight)

            -- Adjust physics based on item type
            if itemTable.category == "weapon" then
                physObj:SetMaterial("metal")
            elseif itemTable.category == "consumable" then
                physObj:SetMaterial("flesh")
            end

            -- Enable physics
            physObj:EnableMotion(true)
        end

        -- Set visual properties
        if itemTable.glowOnSpawn then
            self:SetGlow(true)
            self:SetGlowColor(itemTable.glowColor or Color(255, 255, 255))
        end

        -- Set owner for pickup restrictions
        local owner = item:getData("owner")
        if owner then
            self:setNetVar("owner", owner)
        end

        -- Set spawn protection time
        self:setNetVar("spawnTime", CurTime())
        self:setNetVar("protected", true)
        timer.Simple(1, function()
            if IsValid(self) then
                self:setNetVar("protected", false)
            end
        end)

        -- Track spawn location
        item:setData("lastSpawnPosition", pos)
        item:setData("lastSpawnTime", os.time())

        -- Apply item-specific spawn effects
        if itemTable.onSpawn then
            itemTable.onSpawn(self, item)
        end

        -- Log spawn
        lia.log.add(nil, "itemSpawned", itemTable.name or itemTable.uniqueID, pos)

        -- Notify nearby players of valuable items
        if itemTable.value and itemTable.value > 5000 then
            for _, ply in pairs(player.GetAll()) do
                if ply:GetPos():Distance(pos) <= 256 then
                    ply:notifyInfo("A valuable item has appeared nearby!")
                end
            end
        end

        -- Auto-despawn after time if configured
        if itemTable.despawnTime then
            timer.Simple(itemTable.despawnTime, function()
                if IsValid(self) then
                    local item = lia.item.instances[itemID]
                    if item then
                        item:remove()
                    end
                    SafeRemoveEntity(self)
                end
            end)
        end
    end)
    ```
]]
function OnLoadTables()
end

--[[
    Purpose:
        Called when database tables have finished loading and are ready for use

    When Called:
        After all required database tables have been created/loaded and the database is ready

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log table loading
    hook.Add("OnLoadTables", "LogTables", function()
        print("Database tables loaded successfully!")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Create additional tables after base tables load
    hook.Add("OnLoadTables", "CreateExtraTables", function()
        -- Create custom tables
        lia.db.query([[
            CREATE TABLE IF NOT EXISTS custom_data (
                id INT AUTO_INCREMENT PRIMARY KEY,
                key_name VARCHAR(255) NOT NULL,
                value TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ]], function(err)
            if err then
                ErrorNoHalt("Failed to create custom_data table: " .. tostring(err) .. "\n")
            else
                print("Custom tables created successfully!")
            end
        end)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced table management and migration
    hook.Add("OnLoadTables", "AdvancedTables", function()
        -- Verify all required tables exist
        local requiredTables = {
            "lia_players",
            "lia_characters",
            "lia_items",
            "lia_inventories"
        }

        lia.db.query("SHOW TABLES", function(data)
            if not data or not data.results then
                ErrorNoHalt("Failed to verify database tables!\n")
                return
            end

            local existingTables = {}
            for _, row in ipairs(data.results) do
                for _, tableName in pairs(row) do
                    table.insert(existingTables, tableName)
                end
            end

            -- Check for missing tables
            local missingTables = {}
            for _, reqTable in ipairs(requiredTables) do
                if not table.HasValue(existingTables, reqTable) then
                    table.insert(missingTables, reqTable)
                end
            end

            if #missingTables > 0 then
                ErrorNoHalt("Missing required tables: " .. table.concat(missingTables, ", ") .. "\n")
            else
                print("All required tables verified!")
            end

            -- Run table migrations if needed
            local schemaVersion = lia.config.get("SchemaVersion", 0)
            local targetVersion = 2

            if schemaVersion < targetVersion then
                print("Running database migrations...")
                hook.Run("OnDatabaseMigration", schemaVersion, targetVersion)
            end

            -- Initialize custom tables
            lia.db.query([[
                CREATE TABLE IF NOT EXISTS custom_stats (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    char_id INT,
                    stat_name VARCHAR(100),
                    stat_value INT DEFAULT 0,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    INDEX(char_id)
                )
            ]], function(err)
                if err then
                    ErrorNoHalt("Failed to create custom_stats table: " .. tostring(err) .. "\n")
                end
            end)

            -- Set ready flag
            lia.db.isReady = true
            hook.Run("OnDatabaseReady")
        end)
    end)
    ```
]]
function OnOOCMessageSent(client, message)
end

--[[
    Purpose:
        Called when a player sends an Out-of-Character (OOC) chat message

    When Called:
        After a player sends an OOC message and before it's broadcast to other players

    Parameters:
        - client (Player): The player who sent the OOC message
        - message (string): The OOC message content

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log OOC messages
    hook.Add("OnOOCMessageSent", "LogOOC", function(client, message)
        print(string.format("[OOC] %s: %s", client:Name(), message))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter and log OOC messages
    hook.Add("OnOOCMessageSent", "FilterOOC", function(client, message)
        -- Check for spam
        local lastMessage = client:GetNWFloat("lastOOCMessage", 0)
        if CurTime() - lastMessage < 5 then
            client:notifyError("You're sending messages too quickly!")
            return
        end
        client:SetNWFloat("lastOOCMessage", CurTime())

        -- Log message
        lia.log.add(client, "oocMessage", message)

        -- Check for inappropriate content
        local filteredWords = {"spam", "hack", "cheat"}
        for _, word in ipairs(filteredWords) do
            if string.find(string.lower(message), word) then
                lia.log.add(client, "suspiciousOOC", message)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced OOC message handling
    hook.Add("OnOOCMessageSent", "AdvancedOOC", function(client, message)
        local char = client:getChar()
        if not char then return end

        -- Rate limiting
        local lastMessage = client:GetNWFloat("lastOOCMessage", 0)
        local delay = hook.Run("GetOOCDelay", client) or 10
        if CurTime() - lastMessage < delay then
            local remaining = delay - (CurTime() - lastMessage)
            client:notifyError(string.format("Please wait %d more seconds before sending another OOC message!", 
                math.ceil(remaining)))
            return
        end
        client:SetNWFloat("lastOOCMessage", CurTime())

        -- Check for staff bypass
        if client:isStaff() and string.StartWith(message, "@") then
            -- Staff commands in OOC
            local command = string.sub(message, 2)
            -- Handle staff command
            return
        end

        -- Profanity filter
        local filteredMessage = hook.Run("FilterChatMessage", client, message, "ooc")
        if filteredMessage ~= message then
            client:notifyWarning("Your message was filtered!")
            message = filteredMessage
        end

        -- Check message length
        if string.len(message) > 200 then
            client:notifyError("Your OOC message is too long! Maximum 200 characters.")
            return
        end

        -- Update statistics
        local stats = char:getData("chatStats", {})
        stats.oocMessages = (stats.oocMessages or 0) + 1
        stats.lastOOCMessage = os.time()
        char:setData("chatStats", stats)

        -- Check for mentions
        for _, ply in pairs(player.GetAll()) do
            if ply ~= client and string.find(string.lower(message), string.lower(ply:Name())) then
                ply:notifyInfo(string.format("%s mentioned you in OOC chat", client:Name()))
            end
        end

        -- Log message
        lia.log.add(client, "oocMessage", message, char:getName())

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("ooc_message_sent", {
                player = client:SteamID64(),
                char_id = char:getID(),
                message_length = string.len(message)
            })
        end

        -- Check for suspicious patterns (potential spam/advertising)
        local suspiciousPatterns = {
            "www%.", "http://", "https://", "discord%.gg", "steamcommunity%.com"
        }
        for _, pattern in ipairs(suspiciousPatterns) do
            if string.find(message, pattern) then
                lia.log.add(client, "suspiciousOOC", message, "contains_url")
                -- Notify admins
                for _, admin in pairs(player.GetAll()) do
                    if admin:isAdmin() then
                        admin:notifyWarning(string.format("%s sent a suspicious OOC message: %s", 
                            client:Name(), message))
                    end
                end
            end
        end
    end)
    ```
]]
function OnPAC3PartTransfered(part)
end

--[[
    Purpose:
        Called when a PAC3 (Player Appearance Customization 3) part is transferred to a new owner

    When Called:
        After a PAC3 part has been transferred to a new owner (typically when a player spawns or changes characters)

    Parameters:
        - part (Entity): The PAC3 part entity that was transferred

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log PAC3 transfers
    hook.Add("OnPAC3PartTransfered", "LogTransfers", function(part)
        print(string.format("PAC3 part transferred: %s", part:GetModel()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle owner-specific PAC3 parts
    hook.Add("OnPAC3PartTransfered", "OwnerHandling", function(part)
        -- Set custom properties based on owner
        local owner = part:GetOwner()
        if IsValid(owner) then
            -- Add custom glow or effects for specific players
            if owner:SteamID() == "STEAM_0:0:12345678" then
                part:SetGlow(true)
                part:SetGlowColor(Color(255, 0, 0))
            end

            -- Track part ownership
            local char = owner:getChar()
            if char then
                part.liaCharID = char:getID()
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced PAC3 management
    hook.Add("OnPAC3PartTransfered", "AdvancedPAC", function(part)
        local owner = part:GetOwner()

        if IsValid(owner) then
            local char = owner:getChar()
            if char then
                local charID = char:getID()
                part.liaCharID = charID

                -- Load character-specific PAC3 data
                local pacData = char:getData("pac3Data", {})
                if pacData[part:GetClass()] then
                    -- Apply saved PAC3 settings
                    local settings = pacData[part:GetClass()]
                    part:SetColor(settings.color or Color(255, 255, 255))
                    part:SetMaterial(settings.material or "")
                    part:SetScale(settings.scale or 1)
                end

                -- Validate PAC3 part ownership
                if lia.config.get("ValidatePAC3Ownership", false) then
                    if not part.liaValidated then
                        -- Mark as validated to prevent spam
                        part.liaValidated = true

                        -- Log PAC3 part ownership
                        lia.log.add(owner, "pac3PartTransferred", part:GetClass(), charID)
                    end
                end

                -- Handle faction-specific PAC3 restrictions
                local faction = lia.faction.indices[char:getFaction()]
                if faction and faction.restrictedPAC3 then
                    for _, restrictedClass in ipairs(faction.restrictedPAC3) do
                        if part:GetClass() == restrictedClass then
                            SafeRemoveEntity(part)
                            owner:notifyWarning("This PAC3 part is restricted for your faction!")
                            return
                        end
                    end
                end

                -- Track PAC3 usage for analytics
                if lia.analytics then
                    lia.analytics.track("pac3_part_transferred", {
                        player = owner:SteamID64(),
                        char_id = charID,
                        part_class = part:GetClass(),
                        part_model = part:GetModel()
                    })
                end
            end
        end
    end)
    ```
]]
function OnPickupMoney(client, moneyEntity)
end

--[[
    Purpose:
        Called when a player picks up money from the world

    When Called:
        After a player has successfully picked up a money entity from the ground

    Parameters:
        - client (Player): The player who picked up the money
        - moneyEntity (Entity): The money entity that was picked up

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log money pickups
    hook.Add("OnPickupMoney", "LogPickups", function(client, moneyEntity)
        local amount = moneyEntity:getAmount()
        print(string.format("%s picked up $%d", client:Name(), amount))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle money pickup with notifications
    hook.Add("OnPickupMoney", "NotifyPickup", function(client, moneyEntity)
        local amount = moneyEntity:getAmount()
        local char = client:getChar()

        if char then
            -- Add to character money
            char:giveMoney(amount)

            -- Notify player
            client:notifyMoneyLocalized("moneyTaken", lia.currency.get(amount))

            -- Log the pickup
            lia.log.add(client, "moneyPickedUp", amount)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced money pickup system
    hook.Add("OnPickupMoney", "AdvancedPickup", function(client, moneyEntity)
        local amount = moneyEntity:getAmount()
        local char = client:getChar()

        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()

        -- Validate pickup (anti-cheat)
        if amount <= 0 then
            lia.log.add(client, "invalid_money_pickup", amount)
            SafeRemoveEntity(moneyEntity)
            return
        end

        -- Check pickup limits
        local pickupLimit = lia.config.get("MoneyPickupLimit", 10000)
        if amount > pickupLimit then
            lia.log.add(client, "suspicious_money_pickup", amount, pickupLimit)
            client:notifyWarning(string.format("Cannot pick up more than $%s at once!", lia.currency.get(pickupLimit)))
            return
        end

        -- Add money to character
        local oldMoney = char:getMoney()
        char:giveMoney(amount)

        -- Update pickup statistics
        local stats = char:getData("moneyStats", {})
        stats.totalPickedUp = (stats.totalPickedUp or 0) + amount
        stats.lastPickup = os.time()
        stats.pickupCount = (stats.pickupCount or 0) + 1
        char:setData("moneyStats", stats)

        -- Notify player with formatted message
        client:notifyMoneyLocalized("moneyTaken", lia.currency.get(amount))

        -- Check for money achievement
        if stats.totalPickedUp >= 100000 then
            client:notifyInfo("Achievement unlocked: Money Collector!")
            char:setData("achievement_moneyCollector", true)
        end

        -- Log pickup with full details
        lia.log.add(client, "moneyPickedUp", amount, char:getMoney())

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("money_picked_up", {
                player = steamID,
                char_id = charID,
                amount = amount,
                new_total = char:getMoney(),
                pickup_count = stats.pickupCount
            })
        end

        -- Handle special money types (if any)
        local moneyType = moneyEntity:getNetVar("moneyType", "standard")
        if moneyType == "dirty" then
            -- Dirty money has laundering requirements
            char:setData("dirtyMoney", (char:getData("dirtyMoney", 0) + amount))
            client:notifyWarning("You picked up dirty money! You may need to launder it.")
        end

        -- Remove the money entity
        SafeRemoveEntity(moneyEntity)
    end)
    ```
]]
function OnPlayerDropWeapon(client, weapon, entity)
end

--[[
    Purpose:
        Called when a player drops a weapon from their inventory to the world

    When Called:
        After a weapon entity has been created and spawned when a player drops a weapon

    Parameters:
        - client (Player): The player who dropped the weapon
        - weapon (string): The weapon class name that was dropped
        - entity (Entity): The weapon entity that was spawned in the world

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log weapon drops
    hook.Add("OnPlayerDropWeapon", "LogDrops", function(client, weapon, entity)
        print(string.format("%s dropped weapon: %s", client:Name(), weapon))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle dropped weapons with physics
    hook.Add("OnPlayerDropWeapon", "WeaponPhysics", function(client, weapon, entity)
        if IsValid(entity) then
            -- Enable physics
            local physObj = entity:GetPhysicsObject()
            if physObj then
                physObj:EnableMotion(true)
            end

            -- Auto-remove after time
            SafeRemoveEntityDelayed(entity, 15) -- 15 seconds

            -- Log the drop
            lia.log.add(client, "weaponDropped", weapon)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced weapon drop management
    hook.Add("OnPlayerDropWeapon", "AdvancedDrops", function(client, weapon, entity)
        local char = client:getChar()
        if not char then return end

        if IsValid(entity) then
            local steamID = client:SteamID64()
            local charID = char:getID()

            -- Set weapon ownership
            entity:setNetVar("owner", steamID)
            entity:setNetVar("ownerChar", charID)
            entity:setNetVar("dropTime", CurTime())

            -- Enable physics with proper mass
            local physObj = entity:GetPhysicsObject()
            if physObj then
                physObj:EnableMotion(true)
                physObj:SetMass(10) -- Set reasonable mass
            end

            -- Handle weapon-specific drop behavior
            if weapon == "weapon_pistol" then
                -- Pistols have shorter despawn time
                SafeRemoveEntityDelayed(entity, 30)
            elseif weapon == "weapon_smg1" or weapon == "weapon_ar2" then
                -- Assault weapons have longer despawn time but decay ammo
                entity.liaAmmo = entity:Clip1()
                SafeRemoveEntityDelayed(entity, 60)

                -- Decay ammo over time
                timer.Create("liaWeaponDecay_" .. entity:EntIndex(), 10, 6, function()
                    if IsValid(entity) and entity.liaAmmo then
                        entity.liaAmmo = math.max(0, entity.liaAmmo - 5)
                        entity:SetClip1(entity.liaAmmo)
                    end
                end)
            else
                SafeRemoveEntityDelayed(entity, 45)
            end

            -- Update character statistics
            local stats = char:getData("weaponStats", {})
            stats.weaponsDropped = (stats.weaponsDropped or 0) + 1
            stats.lastWeaponDropped = weapon
            stats.lastDropTime = os.time()
            char:setData("weaponStats", stats)

            -- Check for weapon drop limits
            local dropLimit = lia.config.get("WeaponDropLimit", 3)
            if stats.weaponsDropped >= dropLimit then
                client:notifyWarning("You've dropped too many weapons recently!")
            end

            -- Handle equipped weapon drops
            if client:GetActiveWeapon() == entity then
                -- Force switch to hands
                client:SelectWeapon("lia_hands")
            end

            -- Log weapon drop with details
            lia.log.add(client, "weaponDropped", weapon, entity:GetPos())

            -- Analytics tracking
            if lia.analytics then
                lia.analytics.track("weapon_dropped", {
                    player = steamID,
                    char_id = charID,
                    weapon = weapon,
                    position = entity:GetPos()
                })
            end

            -- Notify nearby players
            for _, ply in pairs(player.GetAll()) do
                if ply:GetPos():Distance(entity:GetPos()) <= 256 and ply ~= client then
                    ply:notifyInfo(string.format("%s dropped a weapon nearby", client:Name()))
                end
            end
        end
    end)
    ```
]]
function OnPlayerEnterSequence(self, sequenceName, callback, time, noFreeze)
end

--[[
    Purpose:
        Called when a player starts playing an animation sequence

    When Called:
        When a player begins playing a specific animation sequence (used for scripted events, roleplay actions, etc.)

    Parameters:
        - self (Player): The player entering the sequence
        - sequenceName (string): The name of the animation sequence
        - callback (function, optional): Function to call when the sequence ends
        - time (number, optional): Duration of the sequence in seconds
        - noFreeze (boolean, optional): If true, player won't be frozen during the sequence

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log sequence starts
    hook.Add("OnPlayerEnterSequence", "LogSequences", function(self, sequenceName, callback, time, noFreeze)
        print(string.format("%s started sequence: %s", self:Name(), sequenceName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle sequence completion
    hook.Add("OnPlayerEnterSequence", "SequenceCompletion", function(self, sequenceName, callback, time, noFreeze)
        if callback then
            -- Wrap callback to add logging
            local originalCallback = callback
            callback = function()
                lia.log.add(self, "sequenceCompleted", sequenceName)
                if originalCallback then
                    originalCallback()
                end
            end
        end

        -- Prevent certain sequences for specific players
        if sequenceName == "arrested" and self:isStaff() then
            self:notifyWarning("Staff cannot use arrested sequence!")
            return false
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced sequence management
    hook.Add("OnPlayerEnterSequence", "AdvancedSequences", function(self, sequenceName, callback, time, noFreeze)
        local char = self:getChar()
        if not char then return end

        local steamID = self:SteamID64()
        local charID = char:getID()

        -- Track sequence usage
        local sequenceStats = char:getData("sequenceStats", {})
        sequenceStats.totalSequences = (sequenceStats.totalSequences or 0) + 1
        sequenceStats.lastSequence = sequenceName
        sequenceStats.lastSequenceTime = os.time()
        char:setData("sequenceStats", stats)

        -- Handle specific sequences
        if sequenceName == "fallover" then
            -- Fallover sequence - handle damage immunity
            self:setNetVar("fallover", true)
            self:setNetVar("falloverTime", CurTime())

            -- Remove immunity after sequence
            if callback then
                local originalCallback = callback
                callback = function()
                    self:setNetVar("fallover", nil)
                    if originalCallback then
                        originalCallback()
                    end
                end
            end
        elseif sequenceName == "arrested" then
            -- Arrest sequence - update arrest status
            char:setData("arrested", true)
            char:setData("arrestedTime", os.time())

            -- Restrict player actions
            self:SetWalkSpeed(50)
            self:SetRunSpeed(50)

            -- Auto-unarrest after time if no callback
            if not callback and time then
                timer.Simple(time, function()
                    if IsValid(self) then
                        char:setData("arrested", nil)
                        self:SetWalkSpeed(lia.config.get("WalkSpeed", 100))
                        self:SetRunSpeed(lia.config.get("RunSpeed", 200))
                    end
                end)
            end
        elseif sequenceName == "searching" then
            -- Searching sequence - prevent other actions
            self:setNetVar("searching", true)

            if callback then
                local originalCallback = callback
                callback = function()
                    self:setNetVar("searching", nil)
                    if originalCallback then
                        originalCallback()
                    end
                end
            end
        end

        -- Validate sequence permissions
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.restrictedSequences then
            for _, restricted in ipairs(faction.restrictedSequences) do
                if sequenceName == restricted then
                    self:notifyError("This sequence is restricted for your faction!")
                    return false
                end
            end
        end

        -- Log sequence usage
        lia.log.add(self, "sequenceStarted", sequenceName, time or "unknown")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("sequence_started", {
                player = steamID,
                char_id = charID,
                sequence = sequenceName,
                duration = time
            })
        end

        -- Handle callback wrapping for analytics
        if callback then
            local originalCallback = callback
            callback = function()
                lia.log.add(self, "sequenceCompleted", sequenceName)
                if lia.analytics then
                    lia.analytics.track("sequence_completed", {
                        player = steamID,
                        char_id = charID,
                        sequence = sequenceName
                    })
                end
                if originalCallback then
                    originalCallback()
                end
            end
        end
    end)
    ```
]]
function OnPlayerInteractItem(client, action, self, result, data)
end

--[[
    Purpose:
        Called when a player interacts with an item using an action (use, take, combine, etc.)

    When Called:
        After a player has performed an action on an item (the action has been processed)

    Parameters:
        - client (Player): The player who performed the action
        - action (string): The action that was performed (e.g., "use", "take", "combine")
        - self (Item): The item that was interacted with
        - result: The result of the action (can be boolean, promise, or other data)
        - data (table, optional): Additional data passed with the action

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item interactions
    hook.Add("OnPlayerInteractItem", "LogInteractions", function(client, action, self, result, data)
        print(string.format("%s performed %s on %s", client:Name(), action, self.name))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle specific actions
    hook.Add("OnPlayerInteractItem", "HandleActions", function(client, action, self, result, data)
        if action == "use" and result == true then
            -- Item was successfully used
            lia.log.add(client, "itemUsed", self.name, self:getID())
        elseif action == "combine" and result == false then
            -- Item combination failed
            client:notifyError("Item combination failed!")
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item interaction system
    hook.Add("OnPlayerInteractItem", "AdvancedInteractions", function(client, action, self, result, data)
        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local itemID = self:getID()
        local itemName = self.name or self.uniqueID

        -- Update interaction statistics
        local stats = char:getData("itemStats", {})
        stats.totalInteractions = (stats.totalInteractions or 0) + 1
        stats[action .. "Actions"] = (stats[action .. "Actions"] or 0) + 1
        stats.lastInteraction = {
            action = action,
            item = itemName,
            itemID = itemID,
            time = os.time()
        }
        char:setData("itemStats", stats)

        -- Handle specific actions
        if action == "use" then
            if result == true then
                -- Successful use
                lia.log.add(client, "itemUsed", itemName, itemID)

                -- Check for achievements
                if itemName == "first_aid_kit" then
                    stats.medicalUses = (stats.medicalUses or 0) + 1
                    if stats.medicalUses >= 50 then
                        client:notifyInfo("Achievement: Medical Professional!")
                        char:setData("achievement_medical", true)
                    end
                end
            elseif result == false then
                -- Use failed
                lia.log.add(client, "itemUseFailed", itemName, itemID)
            end
        elseif action == "take" then
            if result == true then
                -- Item taken successfully
                lia.log.add(client, "itemTaken", itemName, itemID, self:getInv():getID())

                -- Check inventory limits
                local inventory = char:getInv()
                if inventory then
                    local itemCount = table.Count(inventory:getItems())
                    local maxItems = inventory:getMaxSlots()

                    if itemCount >= maxItems * 0.9 then
                        client:notifyWarning("Your inventory is getting full!")
                    end
                end
            end
        elseif action == "combine" then
            if result == true then
                -- Items combined successfully
                lia.log.add(client, "itemsCombined", itemName, itemID, data and data.target or "unknown")
            elseif result == false then
                -- Combination failed
                client:notifyError("Cannot combine these items!")
            end
        elseif action == "drop" then
            if result == true then
                -- Item dropped successfully
                lia.log.add(client, "itemDropped", itemName, itemID, self:getPos())
            end
        end

        -- Validate action permissions
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.restrictedItems then
            for _, restricted in ipairs(faction.restrictedItems) do
                if self.uniqueID == restricted then
                    lia.log.add(client, "restrictedItemUse", itemName, faction.name)
                    client:notifyWarning("This item is restricted for your faction!")
                end
            end
        end

        -- Handle promise results (async operations)
        if deferred.isPromise(result) then
            result:next(function(success)
                -- Handle successful async operation
                lia.log.add(client, "asyncItemAction", action, itemName, "success")
            end, function(error)
                -- Handle failed async operation
                lia.log.add(client, "asyncItemAction", action, itemName, "failed", error)
                client:notifyError("Item action failed: " .. tostring(error))
            end)
        end

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("item_interaction", {
                player = steamID,
                char_id = charID,
                action = action,
                item_id = itemID,
                item_name = itemName,
                success = result ~= false
            })
        end

        -- Trigger follow-up hooks based on result
        if result == true then
            hook.Run("OnPlayerItemActionSuccess", client, action, self, data)
        elseif result == false then
            hook.Run("OnPlayerItemActionFailed", client, action, self, data)
        end
    end)
    ```
]]
function OnPlayerJoinClass(client, class, oldClass)
end

--[[
    Purpose:
        Called when a player joins or changes to a new character class

    When Called:
        After a player successfully changes their character class (either initially or switching)

    Parameters:
        - client (Player): The player who changed class
        - class (string/number): The index/ID of the new class
        - oldClass (string/number, optional): The index/ID of the previous class (nil if first class assignment)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log class changes
    hook.Add("OnPlayerJoinClass", "LogClassChanges", function(client, class, oldClass)
        local className = lia.class.list[class] and lia.class.list[class].name or "Unknown"
        if oldClass then
            print(string.format("%s changed from class %s to %s", client:Name(), tostring(oldClass), className))
        else
            print(string.format("%s joined class %s", client:Name(), className))
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle class-specific setup
    hook.Add("OnPlayerJoinClass", "ClassSetup", function(client, class, oldClass)
        local classData = lia.class.list[class]
        if classData then
            -- Apply class-specific attributes
            if classData.health then
                client:SetMaxHealth(classData.health)
                client:SetHealth(classData.health)
            end

            if classData.armor then
                client:SetMaxArmor(classData.armor)
                client:SetArmor(classData.armor)
            end

            -- Notify player
            client:notifyInfo(string.format("You are now a %s", classData.name))
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced class management system
    hook.Add("OnPlayerJoinClass", "AdvancedClassManagement", function(client, class, oldClass)
        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local classData = lia.class.list[class]
        local oldClassData = oldClass and lia.class.list[oldClass] or nil

        -- Update class change statistics
        local stats = char:getData("classStats", {})
        stats.totalClassChanges = (stats.totalClassChanges or 0) + 1
        stats.lastClassChange = os.time()
        stats.lastClass = class
        stats.previousClass = oldClass
        char:setData("classStats", stats)

        -- Handle old class cleanup
        if oldClassData and oldClassData.OnLeave then
            -- Call old class leave function
            local success, err = pcall(oldClassData.OnLeave, client)
            if not success then
                lia.log.add(client, "classLeaveError", tostring(err))
            end
        end

        -- Handle new class setup
        if classData then
            -- Apply class attributes
            if classData.health then
                client:SetMaxHealth(classData.health)
                client:SetHealth(classData.health)
            end

            if classData.armor then
                client:SetMaxArmor(classData.armor)
                client:SetArmor(classData.armor)
            end

            if classData.speed then
                client:SetWalkSpeed(classData.speed.walk or 100)
                client:SetRunSpeed(classData.speed.run or 200)
            end

            -- Call class OnSet function
            if classData.OnSet then
                local success, err = pcall(classData.OnSet, client)
                if not success then
                    lia.log.add(client, "classSetError", tostring(err))
                end
            end

            -- Handle class transfer
            if oldClass and oldClass ~= class and classData.OnTransferred then
                local success, err = pcall(classData.OnTransferred, client, oldClass)
                if not success then
                    lia.log.add(client, "classTransferError", tostring(err))
                end
            end

            -- Update faction-class relationship
            local faction = lia.faction.indices[char:getFaction()]
            if faction and faction.classes then
                -- Validate class belongs to faction
                local validClass = false
                for _, factionClass in ipairs(faction.classes) do
                    if factionClass == class then
                        validClass = true
                        break
                    end
                end

                if not validClass then
                    lia.log.add(client, "invalidClassForFaction", class, faction.name)
                end
            end

            -- Notify player
            if oldClass then
                client:notifyInfo(string.format("You changed from %s to %s", 
                    oldClassData and oldClassData.name or "Unknown", classData.name))
            else
                client:notifyInfo(string.format("You are now a %s", classData.name))
            end

            -- Log class change
            lia.log.add(client, "classChange", classData.name, oldClassData and oldClassData.name or "None")

            -- Analytics tracking
            if lia.analytics then
                lia.analytics.track("class_changed", {
                    player = steamID,
                    char_id = charID,
                    new_class = class,
                    old_class = oldClass,
                    faction = char:getFaction()
                })
            end
        else
            lia.log.add(client, "invalidClass", class)
            client:notifyError("Invalid class selected!")
        end
    end)
    ```
]]
function OnPlayerLeaveSequence(self)
end

--[[
    Purpose:
        Called when a player leaves/stops playing an animation sequence

    When Called:
        When a player finishes or is interrupted from playing an animation sequence

    Parameters:
        - self (Player): The player who left the sequence

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log sequence completion
    hook.Add("OnPlayerLeaveSequence", "LogSequenceEnd", function(self)
        print(string.format("%s finished playing a sequence", self:Name()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Restore player state after sequence
    hook.Add("OnPlayerLeaveSequence", "RestoreState", function(self)
        -- Restore movement
        self:SetMoveType(MOVETYPE_WALK)

        -- Clear sequence flags
        self:setNetVar("fallover", nil)
        self:setNetVar("arrested", nil)
        self:setNetVar("searching", nil)

        -- Restore speed if modified
        self:SetWalkSpeed(lia.config.get("WalkSpeed", 100))
        self:SetRunSpeed(lia.config.get("RunSpeed", 200))
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced sequence cleanup and state management
    hook.Add("OnPlayerLeaveSequence", "AdvancedSequenceCleanup", function(self)
        local char = self:getChar()
        if not char then return end

        local steamID = self:SteamID64()
        local charID = char:getID()

        -- Update sequence statistics
        local stats = char:getData("sequenceStats", {})
        stats.totalSequencesCompleted = (stats.totalSequencesCompleted or 0) + 1
        stats.lastSequenceEnd = os.time()
        char:setData("sequenceStats", stats)

        -- Restore player state based on previous sequence
        local lastSequence = self.liaLastSequence
        if lastSequence then
            if lastSequence == "fallover" then
                -- Remove damage immunity
                self:setNetVar("fallover", nil)
                self:setNetVar("falloverTime", nil)

                -- Reset health if needed
                local maxHealth = self:GetMaxHealth()
                if self:Health() > maxHealth then
                    self:SetHealth(maxHealth)
                end

                -- Check for nearby help
                for _, ply in pairs(player.GetAll()) do
                    if ply:GetPos():Distance(self:GetPos()) <= 128 and ply ~= self then
                        ply:notifyInfo(string.format("%s got back up", self:Name()))
                    end
                end
            elseif lastSequence == "arrested" then
                -- Restore movement and speed
                self:setNetVar("arrested", nil)
                self:SetWalkSpeed(lia.config.get("WalkSpeed", 100))
                self:SetRunSpeed(lia.config.get("RunSpeed", 200))

                -- Update arrest statistics
                local arrestStats = char:getData("arrestStats", {})
                arrestStats.totalArrests = (arrestStats.totalArrests or 0) + 1
                arrestStats.lastArrestEnd = os.time()
                char:setData("arrestStats", arrestStats)

                self:notifyInfo("You are no longer under arrest")
            elseif lastSequence == "searching" then
                -- Clear searching state
                self:setNetVar("searching", nil)

                -- Restore weapon if was holstered
                if self.liaHolsteredWeapon then
                    self:SelectWeapon(self.liaHolsteredWeapon)
                    self.liaHolsteredWeapon = nil
                end
            end

            self.liaLastSequence = nil
        end

        -- Restore movement type
        self:SetMoveType(MOVETYPE_WALK)

        -- Execute stored callback if exists
        if self.liaSeqCallback and isfunction(self.liaSeqCallback) then
            local success, err = pcall(self.liaSeqCallback)
            if not success then
                lia.log.add(self, "sequenceCallbackError", tostring(err))
            end
            self.liaSeqCallback = nil
        end

        -- Clear sequence force flag
        self.liaForceSeq = nil

        -- Network sequence end to clients
        net.Start("liaSeqSet")
        net.WriteEntity(self)
        net.WriteBool(false)
        net.Broadcast()

        -- Log sequence completion
        lia.log.add(self, "sequenceCompleted", lastSequence or "unknown")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("sequence_completed", {
                player = steamID,
                char_id = charID,
                sequence = lastSequence or "unknown",
                duration = CurTime() - (self.liaSeqStartTime or CurTime())
            })
        end

        -- Check for follow-up actions
        hook.Run("OnPlayerSequenceFullyCompleted", self, lastSequence)
    end)
    ```
]]
function OnPlayerLostStackItem(itemTypeOrItem)
end

--[[
    Purpose:
        Called when a player loses a stack item due to inventory overflow or transfer limits

    When Called:
        When attempting to add items to an inventory that cannot hold the full stack, causing excess items to be lost

    Parameters:
        - itemTypeOrItem (string/Item): The item type unique ID or Item instance that was lost

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log lost items
    hook.Add("OnPlayerLostStackItem", "LogLostItems", function(itemTypeOrItem)
        local itemName = isstring(itemTypeOrItem) and itemTypeOrItem or itemTypeOrItem.name
        print(string.format("Item lost due to stack overflow: %s", itemName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify players of lost items
    hook.Add("OnPlayerLostStackItem", "NotifyLoss", function(itemTypeOrItem)
        -- Find the player who lost the item
        local itemName = isstring(itemTypeOrItem) and itemTypeOrItem or itemTypeOrItem.name
        local client = istable(itemTypeOrItem) and itemTypeOrItem:getOwner() or nil

        if IsValid(client) then
            client:notifyWarning(string.format("You lost %s due to inventory overflow!", itemName))
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item loss tracking and compensation
    hook.Add("OnPlayerLostStackItem", "AdvancedItemLoss", function(itemTypeOrItem)
        local itemName = isstring(itemTypeOrItem) and itemTypeOrItem or itemTypeOrItem.name
        local itemType = isstring(itemTypeOrItem) and itemTypeOrItem or itemTypeOrItem.uniqueID
        local client = istable(itemTypeOrItem) and itemTypeOrItem:getOwner() or nil

        -- Log the loss
        if IsValid(client) then
            lia.log.add(client, "itemLostOverflow", itemName, itemType)
        else
            lia.log.add(nil, "itemLostOverflow", itemName, itemType)
        end

        -- Track item loss statistics
        if IsValid(client) then
            local char = client:getChar()
            if char then
                local stats = char:getData("itemLossStats", {})
                stats.totalItemsLost = (stats.totalItemsLost or 0) + 1
                stats.lastItemLost = {
                    name = itemName,
                    type = itemType,
                    timestamp = os.time(),
                    reason = "overflow"
                }
                char:setData("itemLossStats", stats)

                -- Check for excessive losses (possible abuse)
                if stats.totalItemsLost >= 100 then
                    lia.log.add(client, "excessiveItemLoss", stats.totalItemsLost)
                end
            end
        end

        -- Global item loss tracking
        local globalStats = lia.config.get("globalItemLossStats", {})
        globalStats[itemType] = (globalStats[itemType] or 0) + 1
        lia.config.set("globalItemLossStats", globalStats)

        -- Notify player with compensation info
        if IsValid(client) then
            client:notifyWarning(string.format("You lost %s due to inventory overflow! Consider expanding your storage.", itemName))

            -- Offer compensation for valuable items
            local itemTable = lia.item.list[itemType]
            if itemTable and itemTable.value and itemTable.value > 1000 then
                client:notifyInfo("Lost valuable items can sometimes be recovered by contacting an administrator.")
            end
        end

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("item_lost_overflow", {
                item_type = itemType,
                item_name = itemName,
                player = IsValid(client) and client:SteamID64() or nil,
                timestamp = os.time()
            })
        end

        -- Check for server-wide item loss patterns
        local recentLosses = globalStats[itemType] or 0
        if recentLosses >= 10 then
            -- Alert administrators of frequent losses
            for _, admin in pairs(player.GetAll()) do
                if admin:isAdmin() then
                    admin:notifyWarning(string.format("High frequency of %s losses detected", itemName))
                end
            end
        end
    end)
    ```
]]
function OnPlayerObserve(client, state)
end

--[[
    Purpose:
        Called when a player toggles their observer/freecam mode

    When Called:
        When a player enables or disables observer mode (typically used by administrators for server monitoring)

    Parameters:
        - client (Player): The player who toggled observer mode
        - state (boolean): True if observer mode was enabled, false if disabled

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log observer toggles
    hook.Add("OnPlayerObserve", "LogObserve", function(client, state)
        local action = state and "enabled" or "disabled"
        print(string.format("%s %s observer mode", client:Name(), action))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle observer state changes
    hook.Add("OnPlayerObserve", "HandleObserve", function(client, state)
        if state then
            -- Player entered observer mode
            client:notifyInfo("Observer mode enabled - you can now fly around and monitor the server")
            client:setNetVar("observing", true)
        else
            -- Player left observer mode
            client:notifyInfo("Observer mode disabled")
            client:setNetVar("observing", nil)
        end

        -- Log the action
        lia.log.add(client, "observeToggle", state and "enabled" or "disabled")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced observer management system
    hook.Add("OnPlayerObserve", "AdvancedObserver", function(client, state)
        local steamID = client:SteamID64()
        local char = client:getChar()

        -- Update observer statistics
        if char then
            local stats = char:getData("observerStats", {})
            stats.totalObserveToggles = (stats.totalObserveToggles or 0) + 1
            stats.currentlyObserving = state
            if state then
                stats.lastObserveStart = os.time()
                stats.observeSessions = (stats.observeSessions or 0) + 1
            else
                if stats.lastObserveStart then
                    local sessionLength = os.time() - stats.lastObserveStart
                    stats.totalObserveTime = (stats.totalObserveTime or 0) + sessionLength
                    stats.lastSessionLength = sessionLength
                end
                stats.lastObserveEnd = os.time()
            end
            char:setData("observerStats", stats)
        end

        -- Handle observer state changes
        if state then
            -- Entering observer mode
            client:setNetVar("observing", true)
            client:GodEnable() -- Make invincible while observing
            client:SetNoTarget(true) -- Make invisible to NPCs

            -- Save current position for restoration
            client.liaObservePos = client:GetPos()
            client.liaObserveAngles = client:GetAngles()

            -- Set observer properties
            client:SetMoveType(MOVETYPE_NOCLIP)
            client:SetNotSolid(true)

            client:notifyInfo("Observer mode enabled - use WASD to move, mouse to look around")

            -- Notify other admins
            for _, admin in pairs(player.GetAll()) do
                if admin:isAdmin() and admin ~= client then
                    admin:notifyInfo(string.format("%s entered observer mode", client:Name()))
                end
            end
        else
            -- Leaving observer mode
            client:setNetVar("observing", nil)
            client:GodDisable() -- Restore normal damage
            client:SetNoTarget(false) -- Make visible to NPCs again

            -- Restore position if saved
            if client.liaObservePos then
                client:SetPos(client.liaObservePos)
                client:SetAngles(client.liaObserveAngles or Angle(0, 0, 0))
                client.liaObservePos = nil
                client.liaObserveAngles = nil
            end

            -- Restore normal properties
            client:SetMoveType(MOVETYPE_WALK)
            client:SetNotSolid(false)

            client:notifyInfo("Observer mode disabled")

            -- Notify other admins
            for _, admin in pairs(player.GetAll()) do
                if admin:isAdmin() and admin ~= client then
                    admin:notifyInfo(string.format("%s left observer mode", client:Name()))
                end
            end
        end

        -- Log the action with details
        lia.log.add(client, "observeToggle", state and "enabled" or "disabled")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("observer_mode_toggle", {
                player = steamID,
                char_id = char and char:getID() or nil,
                enabled = state,
                timestamp = os.time()
            })
        end

        -- Check for observer abuse
        if char then
            local stats = char:getData("observerStats", {})
            local totalTime = stats.totalObserveTime or 0
            local maxObserveTime = lia.config.get("MaxObserverTime", 3600) -- 1 hour default

            if totalTime > maxObserveTime then
                lia.log.add(client, "excessiveObserverUse", totalTime)
                client:notifyWarning("You've used observer mode extensively. Please use it responsibly.")
            end
        end
    end)
    ```
]]
function OnPlayerPurchaseDoor(client, door, price)
end

--[[
    Purpose:
        Called when a player purchases or sells a door

    When Called:
        After a successful door purchase or sale transaction

    Parameters:
        - client (Player): The player who bought/sold the door
        - door (Entity): The door entity that was bought/sold
        - price (number): The price of the transaction (negative for sales, positive for purchases)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log door transactions
    hook.Add("OnPlayerPurchaseDoor", "LogTransactions", function(client, door, price)
        local action = price > 0 and "bought" or "sold"
        print(string.format("%s %s a door for $%d", client:Name(), action, math.abs(price)))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle door ownership changes
    hook.Add("OnPlayerPurchaseDoor", "HandleOwnership", function(client, door, price)
        if price > 0 then
            -- Bought door
            door:setNetVar("owner", client)
            client:notifyInfo(string.format("You bought this door for $%s", lia.currency.get(price)))
        else
            -- Sold door
            door:setNetVar("owner", nil)
            client:notifyInfo(string.format("You sold this door for $%s", lia.currency.get(math.abs(price))))
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door transaction system
    hook.Add("OnPlayerPurchaseDoor", "AdvancedDoorSystem", function(client, door, price)
        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local doorID = door:EntIndex()
        local doorName = door:getNetVar("name", "Door")

        -- Update door ownership statistics
        local stats = char:getData("doorStats", {})
        if price > 0 then
            -- Purchase
            stats.doorsBought = (stats.doorsBought or 0) + 1
            stats.totalSpentOnDoors = (stats.totalSpentOnDoors or 0) + price
            stats.lastDoorPurchase = {
                doorID = doorID,
                doorName = doorName,
                price = price,
                timestamp = os.time()
            }

            -- Set door ownership
            door:setNetVar("owner", client)
            door:setNetVar("ownerChar", charID)

            -- Add to owned doors list
            local ownedDoors = char:getData("ownedDoors", {})
            ownedDoors[doorID] = {
                name = doorName,
                purchased = os.time(),
                price = price
            }
            char:setData("ownedDoors", ownedDoors)

            client:notifyInfo(string.format("You bought %s for $%s", doorName, lia.currency.get(price)))
            lia.log.add(client, "buydoor", price)
        else
            -- Sale
            local salePrice = math.abs(price)
            stats.doorsSold = (stats.doorsSold or 0) + 1
            stats.totalEarnedFromDoors = (stats.totalEarnedFromDoors or 0) + salePrice
            stats.lastDoorSale = {
                doorID = doorID,
                doorName = doorName,
                price = salePrice,
                timestamp = os.time()
            }

            -- Remove door ownership
            door:setNetVar("owner", nil)
            door:setNetVar("ownerChar", nil)

            -- Remove from owned doors list
            local ownedDoors = char:getData("ownedDoors", {})
            ownedDoors[doorID] = nil
            char:setData("ownedDoors", ownedDoors)

            client:notifyInfo(string.format("You sold %s for $%s", doorName, lia.currency.get(salePrice)))
            lia.log.add(client, "doorsell", salePrice)
        end
        char:setData("doorStats", stats)

        -- Validate transaction
        local currentMoney = char:getMoney()
        if price > 0 and currentMoney < price then
            lia.log.add(client, "invalidDoorPurchase", price, currentMoney)
            return
        end

        -- Handle door properties
        if price > 0 then
            -- New purchase - set up door
            door:setNetVar("owned", true)
            door:setNetVar("sellPrice", math.floor(price * 0.8)) -- 80% resale value

            -- Set door title if not set
            if not door:getNetVar("title") then
                door:setNetVar("title", string.format("%s's Door", char:getName()))
            end
        else
            -- Sale - reset door properties
            door:setNetVar("owned", false)
            door:setNetVar("sellPrice", nil)
            door:setNetVar("title", nil)
        end

        -- Check for property tax system
        if price > 0 and lia.config.get("EnablePropertyTax", false) then
            local taxRate = lia.config.get("PropertyTaxRate", 0.01) -- 1% default
            local taxAmount = math.floor(price * taxRate)
            if taxAmount > 0 then
                char:takeMoney(taxAmount)
                client:notifyInfo(string.format("Property tax: $%s", lia.currency.get(taxAmount)))
            end
        end

        -- Notify nearby players
        for _, ply in pairs(player.GetAll()) do
            if ply:GetPos():Distance(door:GetPos()) <= 512 and ply ~= client then
                local action = price > 0 and "bought" or "sold"
                ply:notifyInfo(string.format("%s %s a door", client:Name(), action))
            end
        end

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("door_transaction", {
                player = steamID,
                char_id = charID,
                door_id = doorID,
                door_name = doorName,
                price = price,
                is_purchase = price > 0
            })
        end

        -- Check for achievement unlocks
        local totalDoors = stats.doorsBought or 0
        if totalDoors >= 10 then
            client:notifyInfo("Achievement: Real Estate Mogul!")
            char:setData("achievement_realEstate", true)
        end
    end)
    ```
]]
function OnPlayerSwitchClass(client, class, oldClass)
end

--[[
    Purpose:
        Called when a player switches their character class (same as OnPlayerJoinClass but specifically for switching)

    When Called:
        After a player successfully switches from one class to another (not for initial class assignment)

    Parameters:
        - client (Player): The player who switched class
        - class (string/number): The index/ID of the new class
        - oldClass (string/number): The index/ID of the previous class

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log class switches
    hook.Add("OnPlayerSwitchClass", "LogSwitches", function(client, class, oldClass)
        local newClassName = lia.class.list[class] and lia.class.list[class].name or "Unknown"
        local oldClassName = lia.class.list[oldClass] and lia.class.list[oldClass].name or "Unknown"
        print(string.format("%s switched from %s to %s", client:Name(), oldClassName, newClassName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle class switch cooldowns
    hook.Add("OnPlayerSwitchClass", "ClassCooldown", function(client, class, oldClass)
        local char = client:getChar()
        if char then
            -- Set cooldown for class switching
            char:setData("lastClassSwitch", os.time())

            -- Prevent switching too frequently
            local cooldownTime = lia.config.get("ClassSwitchCooldown", 300) -- 5 minutes
            char:setData("classSwitchCooldown", os.time() + cooldownTime)

            client:notifyInfo(string.format("Class switched! You cannot switch again for %d minutes.", cooldownTime / 60))
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced class switching with restrictions and costs
    hook.Add("OnPlayerSwitchClass", "AdvancedSwitching", function(client, class, oldClass)
        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local classData = lia.class.list[class]
        local oldClassData = lia.class.list[oldClass]

        -- Check for switch cooldown
        local lastSwitch = char:getData("lastClassSwitch", 0)
        local cooldownTime = lia.config.get("ClassSwitchCooldown", 300)
        local timeSinceLastSwitch = os.time() - lastSwitch

        if timeSinceLastSwitch < cooldownTime then
            local remainingTime = cooldownTime - timeSinceLastSwitch
            client:notifyError(string.format("You must wait %d more minutes before switching classes!", math.ceil(remainingTime / 60)))
            return false -- Cancel the switch
        end

        -- Check for class switch cost
        local switchCost = lia.config.get("ClassSwitchCost", 500)
        if switchCost > 0 and char:getMoney() < switchCost then
            client:notifyError(string.format("Class switching costs $%s!", lia.currency.get(switchCost)))
            return false
        end

        -- Deduct cost if applicable
        if switchCost > 0 then
            char:takeMoney(switchCost)
            client:notifyInfo(string.format("Paid $%s for class switch", lia.currency.get(switchCost)))
        end

        -- Update switch statistics
        local stats = char:getData("classSwitchStats", {})
        stats.totalSwitches = (stats.totalSwitches or 0) + 1
        stats.lastSwitchFrom = oldClass
        stats.lastSwitchTo = class
        stats.lastSwitchTime = os.time()
        stats.totalMoneySpentOnSwitches = (stats.totalMoneySpentOnSwitches or 0) + switchCost
        char:setData("classSwitchStats", stats)

        -- Handle class-specific switch logic
        if oldClassData and oldClassData.OnLeave then
            local success, err = pcall(oldClassData.OnLeave, client)
            if not success then
                lia.log.add(client, "classLeaveError", tostring(err))
            end
        end

        if classData and classData.OnTransferred then
            local success, err = pcall(classData.OnTransferred, client, oldClass)
            if not success then
                lia.log.add(client, "classTransferError", tostring(err))
            end
        end

        -- Update cooldown
        char:setData("lastClassSwitch", os.time())
        char:setData("classSwitchCooldown", os.time() + cooldownTime)

        -- Reset class-specific data if needed
        if oldClassData and oldClassData.classData then
            for key, _ in pairs(oldClassData.classData) do
                char:setData("class_" .. key, nil)
            end
        end

        -- Notify player
        if classData and oldClassData then
            client:notifyInfo(string.format("Successfully switched from %s to %s!", oldClassData.name, classData.name))
        end

        -- Log the switch
        lia.log.add(client, "classSwitch", classData and classData.name or "Unknown", oldClassData and oldClassData.name or "Unknown", switchCost)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("class_switched", {
                player = steamID,
                char_id = charID,
                old_class = oldClass,
                new_class = class,
                cost = switchCost,
                cooldown_remaining = cooldownTime
            })
        end

        -- Check for class switch achievements
        local totalSwitches = stats.totalSwitches or 0
        if totalSwitches >= 10 then
            client:notifyInfo("Achievement: Class Changer!")
            char:setData("achievement_classChanger", true)
        end

        -- Trigger follow-up hooks
        hook.Run("OnPlayerClassSwitchComplete", client, class, oldClass)
    end)
    ```
]]
function OnRequestItemTransfer(item, targetInventory)
end

--[[
    Purpose:
        Called when a player requests to transfer an item to a new inventory position or container

    When Called:
        When a player attempts to move an item within their inventory or to another container

    Parameters:
        - item (Item): The item being transferred
        - targetInventory (Inventory, optional): The target inventory (can be nil for ground drops)

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item transfers
    hook.Add("OnRequestItemTransfer", "LogTransfers", function(item, targetInventory)
        local targetName = targetInventory and "inventory" or "ground"
        print(string.format("Item %s transferred to %s", item.name, targetName))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate transfers
    hook.Add("OnRequestItemTransfer", "ValidateTransfer", function(item, targetInventory)
        -- Prevent transferring certain items
        if item.uniqueID == "special_item" then
            local client = item:getOwner()
            if IsValid(client) then
                client:notifyError("This item cannot be moved!")
                return false -- Cancel transfer
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced transfer tracking and validation
    hook.Add("OnRequestItemTransfer", "AdvancedTransfer", function(item, targetInventory)
        local client = item:getOwner()
        if not IsValid(client) then return end

        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local itemID = item:getID()
        local itemName = item.name or item.uniqueID

        -- Update transfer statistics
        local stats = char:getData("transferStats", {})
        stats.totalTransfers = (stats.totalTransfers or 0) + 1
        stats.lastTransfer = {
            item = itemName,
            itemID = itemID,
            timestamp = os.time(),
            toGround = targetInventory == nil
        }
        char:setData("transferStats", stats)

        -- Validate transfer permissions
        if item:getData("soulbound") then
            client:notifyError("This item is soulbound and cannot be transferred!")
            return false
        end

        -- Check faction restrictions
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.restrictedItems then
            for _, restricted in ipairs(faction.restrictedItems) do
                if item.uniqueID == restricted then
                    client:notifyError("Your faction prohibits transferring this item!")
                    return false
                end
            end
        end

        -- Handle ground drops
        if not targetInventory then
            -- Create world item
            local worldItem = item:spawn(client:GetPos() + Vector(0, 0, 16))
            if IsValid(worldItem) then
                -- Set ownership and timer
                worldItem:setNetVar("owner", steamID)
                worldItem:setNetVar("dropTime", CurTime())

                -- Auto-despawn valuable items after longer time
                local despawnTime = item.value and item.value > 1000 and 300 or 60
                SafeRemoveEntityDelayed(worldItem, despawnTime)

                lia.log.add(client, "itemDropped", itemName, itemID, worldItem:GetPos())
            end
        else
            -- Transfer to another inventory
            lia.log.add(client, "itemTransferred", itemName, itemID, targetInventory:getID())
        end

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("item_transfer_requested", {
                player = steamID,
                char_id = charID,
                item_id = itemID,
                item_name = itemName,
                to_ground = targetInventory == nil
            })
        end

        -- Check for transfer achievements
        local totalTransfers = stats.totalTransfers or 0
        if totalTransfers >= 1000 then
            client:notifyInfo("Achievement: Item Mover!")
            char:setData("achievement_itemMover", true)
        end
    end)
    ```
]]
function OnSalaryAdjust(client)
end

--[[
    Purpose:
        Allows modification of a player's salary amount before it's given

    When Called:
        During salary calculation, before the salary is actually given to the player

    Parameters:
        - client (Player): The player receiving the salary

    Returns:
        number (optional): The adjusted salary amount (return nil to use default)

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Double all salaries
    hook.Add("OnSalaryAdjust", "DoubleSalary", function(client)
        local char = client:getChar()
        if char then
            local defaultPay = hook.Run("GetSalaryAmount", client, char:getFaction(), char:getClass()) or 100
            return defaultPay * 2
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based salary modifiers
    hook.Add("OnSalaryAdjust", "FactionBonuses", function(client)
        local char = client:getChar()
        if not char then return end

        local faction = lia.faction.indices[char:getFaction()]
        local defaultPay = hook.Run("GetSalaryAmount", client, char:getFaction(), char:getClass()) or 100

        if faction then
            -- Government jobs get bonus
            if faction.name == "Civil Protection" then
                return defaultPay * 1.5
            -- Criminal jobs get penalty
            elseif faction.name == "Gangsters" then
                return defaultPay * 0.8
            end
        end

        return defaultPay
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced salary calculation with multiple modifiers
    hook.Add("OnSalaryAdjust", "AdvancedSalary", function(client)
        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local faction = lia.faction.indices[char:getFaction()]
        local class = lia.class.list[char:getClass()]
        local basePay = hook.Run("GetSalaryAmount", client, char:getFaction(), char:getClass()) or 100

        if not basePay or basePay <= 0 then return 0 end

        local finalPay = basePay

        -- Performance-based modifiers
        local performance = char:getData("performanceRating", 1.0)
        finalPay = finalPay * performance

        -- Loyalty modifiers (based on playtime)
        local playtime = char:getData("playtime", 0)
        if playtime > 86400 then -- 24+ hours
            finalPay = finalPay * 1.1 -- 10% loyalty bonus
        end

        -- Faction-specific modifiers
        if faction then
            if faction.salaryMultiplier then
                finalPay = finalPay * faction.salaryMultiplier
            end

            -- Economic status affects salaries
            if faction.economyStatus == "booming" then
                finalPay = finalPay * 1.2
            elseif faction.economyStatus == "recession" then
                finalPay = finalPay * 0.8
            end
        end

        -- Class-specific modifiers
        if class and class.salaryMultiplier then
            finalPay = finalPay * class.salaryMultiplier
        end

        -- Skill-based modifiers
        local skills = char:getData("skills", {})
        if skills.economy then
            finalPay = finalPay * (1 + skills.economy * 0.01) -- 1% per skill point
        end

        -- Tax system
        local taxRate = lia.config.get("SalaryTaxRate", 0.1) -- 10% default tax
        local taxAmount = finalPay * taxRate
        finalPay = finalPay - taxAmount

        -- Store tax information
        char:setData("lastTaxPaid", taxAmount)
        char:setData("totalTaxPaid", (char:getData("totalTaxPaid", 0) + taxAmount))

        -- Minimum salary guarantee
        local minSalary = lia.config.get("MinimumSalary", 10)
        finalPay = math.max(finalPay, minSalary)

        -- Round to nearest dollar
        finalPay = math.Round(finalPay)

        -- Log salary calculation
        lia.log.add(client, "salaryAdjusted", basePay, finalPay, taxAmount)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("salary_adjusted", {
                player = steamID,
                char_id = charID,
                base_pay = basePay,
                final_pay = finalPay,
                tax_amount = taxAmount,
                faction = char:getFaction(),
                class = char:getClass()
            })
        end

        return finalPay
    end)
    ```
]]
function OnSalaryGiven(client, char, pay, faction, class)
end

--[[
    Purpose:
        Called when a player receives their salary payment

    When Called:
        After salary has been calculated and is about to be given to the player

    Parameters:
        - client (Player): The player receiving the salary
        - char (Character): The character receiving the salary
        - pay (number): The salary amount being given
        - faction (string): The faction name of the character
        - class (string): The class name of the character

    Returns:
        number (optional): Modified salary amount (return nil to use original)

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log salary payments
    hook.Add("OnSalaryGiven", "LogSalary", function(client, char, pay, faction, class)
        print(string.format("%s received $%d salary (%s %s)", 
            client:Name(), pay, faction, class))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Give bonus items with salary
    hook.Add("OnSalaryGiven", "SalaryBonus", function(client, char, pay, faction, class)
        -- Give small bonus for government workers
        if faction == "Civil Protection" and pay > 100 then
            local inventory = char:getInv()
            if inventory and math.random() < 0.1 then -- 10% chance
                inventory:add("ammo_pistol", 1)
                client:notifyInfo("You received bonus ammunition with your salary!")
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced salary distribution system
    hook.Add("OnSalaryGiven", "AdvancedSalarySystem", function(client, char, pay, faction, class)
        local steamID = client:SteamID64()
        local charID = char:getID()

        -- Update salary statistics
        local stats = char:getData("salaryStats", {})
        stats.totalEarned = (stats.totalEarned or 0) + pay
        stats.salariesReceived = (stats.salariesReceived or 0) + 1
        stats.lastSalary = {
            amount = pay,
            faction = faction,
            class = class,
            timestamp = os.time()
        }
        char:setData("salaryStats", stats)

        -- Apply faction-specific salary bonuses
        local factionData = lia.faction.indices[char:getFaction()]
        if factionData and factionData.salaryBonus then
            local bonus = math.floor(pay * factionData.salaryBonus)
            if bonus > 0 then
                char:giveMoney(bonus)
                client:notifyInfo(string.format("Faction bonus: +$%s", lia.currency.get(bonus)))
                pay = pay + bonus
            end
        end

        -- Apply class-specific bonuses
        local classData = lia.class.list[char:getClass()]
        if classData and classData.salaryBonus then
            local bonus = math.floor(pay * classData.salaryBonus)
            if bonus > 0 then
                char:giveMoney(bonus)
                client:notifyInfo(string.format("Class bonus: +$%s", lia.currency.get(bonus)))
                pay = pay + bonus
            end
        end

        -- Check for salary achievements
        local totalEarned = stats.totalEarned or 0
        if totalEarned >= 10000 and not char:getData("achievement_wageSlave") then
            client:notifyInfo("Achievement: Wage Slave!")
            char:setData("achievement_wageSlave", true)
        elseif totalEarned >= 100000 and not char:getData("achievement_highEarner") then
            client:notifyInfo("Achievement: High Earner!")
            char:setData("achievement_highEarner", true)
        end

        -- Handle salary caps
        local salaryCap = lia.config.get("SalaryCap", 1000)
        if pay > salaryCap then
            local excess = pay - salaryCap
            pay = salaryCap
            -- Maybe put excess in a savings account
            local savings = char:getData("salarySavings", 0) + excess
            char:setData("salarySavings", savings)
            client:notifyInfo(string.format("Salary capped at $%s. Excess $%s saved.", 
                lia.currency.get(salaryCap), lia.currency.get(excess)))
        end

        -- Log salary payment
        lia.log.add(client, "salaryGiven", pay, faction, class)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("salary_given", {
                player = steamID,
                char_id = charID,
                amount = pay,
                faction = faction,
                class = class,
                total_earned = stats.totalEarned
            })
        end

        -- Notify player with formatted message
        client:notifyMoneyLocalized("salary", lia.currency.get(pay), L("salaryWord"))

        -- Actually give the money
        char:giveMoney(pay)

        -- Check for payday bonuses
        local salariesReceived = stats.salariesReceived or 0
        if salariesReceived % 10 == 0 then -- Every 10 salaries
            char:giveMoney(100)
            client:notifyInfo("Payday bonus: $100!")
        end

        return pay -- Return the final amount
    end)
    ```
]]
function OnSavedItemLoaded(loadedItems)
end

--[[
    Purpose:
        Called when saveditemloaded occurs

    When Called:
        After saveditemloaded has happened

    Parameters:
        - loadedItems: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("OnSavedItemLoaded", "MyAddon", function(loadedItems)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("OnSavedItemLoaded", "MyAddon", function(loadedItems)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("OnSavedItemLoaded", "MyAddon", function(loadedItems)
        -- Add your code here
    end)
    ```
]]
function OnServerLog(client, logType, logString, category)
end

--[[
    Purpose:
        Called when a server log entry is created

    When Called:
        After a log entry is created and before it's displayed/output

    Parameters:
        - client (Player, optional): The player associated with the log (can be nil for system logs)
        - logType (string): The type of log entry
        - logString (string): The log message content
        - category (string): The log category

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Suppress certain logs
    hook.Add("OnServerLog", "SuppressLogs", function(client, logType, logString, category)
        if logType == "debug" then
            return false -- Suppress debug logs
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter and format logs
    hook.Add("OnServerLog", "FilterLogs", function(client, logType, logString, category)
        -- Add player info to logs
        if IsValid(client) then
            local char = client:getChar()
            local charInfo = char and string.format(" (%s)", char:getName()) or ""
            logString = string.format("[%s]%s: %s", client:Name(), charInfo, logString)
        end

        -- Filter sensitive information
        if string.find(logString, "password") then
            logString = "[FILTERED SENSITIVE CONTENT]"
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced logging system with external services
    hook.Add("OnServerLog", "AdvancedLogging", function(client, logType, logString, category)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local steamID = IsValid(client) and client:SteamID64() or "SYSTEM"
        local charID = IsValid(client) and client:getChar() and client:getChar():getID() or nil
        local playerName = IsValid(client) and client:Name() or "SYSTEM"
        local ipAddress = IsValid(client) and client:IPAddress() or "N/A"

        -- Create enhanced log entry
        local logEntry = {
            timestamp = timestamp,
            steamID = steamID,
            charID = charID,
            playerName = playerName,
            ipAddress = ipAddress,
            logType = logType,
            category = category,
            message = logString,
            server = game.GetIPAddress()
        }

        -- Store in memory for recent logs
        if not lia.recentLogs then
            lia.recentLogs = {}
        end
        table.insert(lia.recentLogs, logEntry)
        if #lia.recentLogs > 1000 then
            table.remove(lia.recentLogs, 1)
        end

        -- Update log statistics
        local logStats = lia.config.get("logStats", {})
        logStats.totalLogs = (logStats.totalLogs or 0) + 1
        logStats[category] = (logStats[category] or 0) + 1
        logStats[logType] = (logStats[logType] or 0) + 1
        lia.config.set("logStats", logStats)

        -- Handle specific log types
        if category == "security" then
            -- Security logs get special handling
            if lia.config.get("SecurityLogToDiscord", false) then
                -- Send to Discord webhook
                lia.log.sendToDiscord("security", logString, {
                    player = playerName,
                    steamID = steamID
                })
            end
        elseif category == "admin" then
            -- Admin actions are logged separately
            local adminLogs = lia.config.get("adminActionLogs", {})
            table.insert(adminLogs, logEntry)
            if #adminLogs > 500 then
                table.remove(adminLogs, 1)
            end
            lia.config.set("adminActionLogs", adminLogs)
        end

        -- Filter logs based on level
        local logLevel = lia.config.get("LogLevel", "info")
        local levels = {debug = 1, info = 2, warn = 3, error = 4}
        local currentLevel = levels[logType] or 2
        local configLevel = levels[logLevel] or 2

        if currentLevel < configLevel then
            return false -- Suppress log
        end

        -- Format log for console output
        local coloredMessage = logString
        if logType == "error" then
            coloredMessage = "\27[31m" .. logString .. "\27[0m" -- Red
        elseif logType == "warn" then
            coloredMessage = "\27[33m" .. logString .. "\27[0m" -- Yellow
        elseif logType == "debug" then
            coloredMessage = "\27[36m" .. logString .. "\27[0m" -- Cyan
        end

        -- Enhanced console output
        MsgC(Color(83, 143, 239), "[LOG] ")
        MsgC(Color(0, 255, 0), "[" .. L("logCategory") .. ": " .. tostring(category) .. "] ")
        MsgC(Color(255, 255, 255), coloredMessage .. "\n")

        -- Write to external log file if configured
        if lia.config.get("ExternalLogging", false) then
            local logFile = "lia_logs/" .. os.date("%Y-%m-%d") .. ".log"
            file.Append(logFile, util.TableToJSON(logEntry) .. "\n")
        end

        -- Analytics tracking for important logs
        if lia.analytics and (category == "admin" or category == "security" or logType == "error") then
            lia.analytics.track("server_log", {
                log_type = logType,
                category = category,
                player = steamID,
                char_id = charID,
                message_length = string.len(logString)
            })
        end
    end)
    ```
]]
function OnTicketClaimed(client, requester, ticketMessage)
end

--[[
    Purpose:
        Called when a staff member claims a player's support ticket

    When Called:
        After a ticket has been claimed by an administrator or moderator

    Parameters:
        - client (Player): The staff member who claimed the ticket
        - requester (Player): The player who created the ticket
        - ticketMessage (string): The message content of the ticket

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log ticket claims
    hook.Add("OnTicketClaimed", "LogClaims", function(client, requester, ticketMessage)
        print(string.format("Ticket claimed by %s for %s", client:Name(), requester:Name()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Notify staff of claim
    hook.Add("OnTicketClaimed", "NotifyClaim", function(client, requester, ticketMessage)
        -- Notify other staff
        for _, staff in pairs(player.GetAll()) do
            if staff:isStaff() and staff ~= client then
                staff:notifyInfo(string.format("%s claimed %s's ticket", client:Name(), requester:Name()))
            end
        end

        -- Log the claim
        lia.log.add(client, "ticketClaimed", requester:Name(), ticketMessage)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ticket claim handling
    hook.Add("OnTicketClaimed", "AdvancedClaim", function(client, requester, ticketMessage)
        local clientSteamID = client:SteamID64()
        local requesterSteamID = requester:SteamID64()
        local clientChar = client:getChar()
        local requesterChar = requester:getChar()

        -- Update ticket statistics
        if clientChar then
            local stats = clientChar:getData("staffStats", {})
            stats.ticketsClaimed = (stats.ticketsClaimed or 0) + 1
            stats.lastTicketClaimed = os.time()
            clientChar:setData("staffStats", stats)
        end

        -- Track active tickets per staff member
        local activeTickets = lia.config.get("activeStaffTickets", {})
        if not activeTickets[clientSteamID] then
            activeTickets[clientSteamID] = {}
        end
        table.insert(activeTickets[clientSteamID], {
            requester = requesterSteamID,
            claimedAt = os.time(),
            message = ticketMessage
        })
        lia.config.set("activeStaffTickets", activeTickets)

        -- Notify the ticket creator
        requester:notifyInfo(string.format("Your ticket has been claimed by %s. Please wait for assistance.", client:Name()))

        -- Notify all staff
        for _, staff in pairs(player.GetAll()) do
            if staff:isStaff() and staff ~= client then
                staff:notifyInfo(string.format("%s claimed a ticket from %s", client:Name(), requester:Name()))
            end
        end

        -- Check ticket priority
        local priority = string.match(ticketMessage, "%[PRIORITY: (%w+)%]")
        if priority == "HIGH" or priority == "URGENT" then
            client:notifyWarning("This is a high priority ticket!")
        end

        -- Auto-assign to departments if configured
        local department = lia.config.get("staffDepartments", {})[clientSteamID]
        if department then
            requester:setNetVar("assignedDepartment", department)
        end

        -- Log detailed information
        lia.log.add(client, "ticketClaimed", requester:Name(), ticketMessage, priority or "normal")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("ticket_claimed", {
                staff_member = clientSteamID,
                requester = requesterSteamID,
                priority = priority or "normal",
                response_time = CurTime() - (requester.ticketCreatedTime or CurTime())
            })
        end

        -- Set up auto-close timer
        if lia.config.get("autoCloseTickets", false) then
            local autoCloseTime = lia.config.get("ticketAutoCloseTime", 300) -- 5 minutes
            timer.Create("ticketAutoClose_" .. requesterSteamID, autoCloseTime, 1, function()
                if IsValid(requester) and requester.CaseClaimed == client then
                    hook.Run("OnTicketClosed", client, requester, "Auto-closed due to inactivity")
                end
            end)
        end
    end)
    ```
]]
function OnTicketClosed(client, requester, ticketMessage)
end

--[[
    Purpose:
        Called when a support ticket is closed/resolved

    When Called:
        After a ticket has been closed by a staff member or automatically

    Parameters:
        - client (Player, optional): The staff member who closed the ticket (can be nil for auto-close)
        - requester (Player): The player who created the ticket
        - ticketMessage (string): The resolution message or reason for closing

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log ticket closures
    hook.Add("OnTicketClosed", "LogClosures", function(client, requester, ticketMessage)
        local staffName = IsValid(client) and client:Name() or "System"
        print(string.format("Ticket closed by %s for %s", staffName, requester:Name()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Update ticket statistics
    hook.Add("OnTicketClosed", "UpdateStats", function(client, requester, ticketMessage)
        -- Update staff stats
        if IsValid(client) then
            local char = client:getChar()
            if char then
                local stats = char:getData("staffStats", {})
                stats.ticketsClosed = (stats.ticketsClosed or 0) + 1
                stats.lastTicketClosed = os.time()
                char:setData("staffStats", stats)
            end
        end

        -- Notify the player
        requester:notifyInfo("Your ticket has been closed. Thank you for your patience.")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ticket closure system
    hook.Add("OnTicketClosed", "AdvancedClosure", function(client, requester, ticketMessage)
        local clientSteamID = IsValid(client) and client:SteamID64() or "SYSTEM"
        local requesterSteamID = requester:SteamID64()
        local clientChar = IsValid(client) and client:getChar()
        local requesterChar = requester:getChar()

        -- Remove from active tickets
        if IsValid(client) then
            local activeTickets = lia.config.get("activeStaffTickets", {})
            if activeTickets[clientSteamID] then
                for i, ticket in ipairs(activeTickets[clientSteamID]) do
                    if ticket.requester == requesterSteamID then
                        ticket.closedAt = os.time()
                        ticket.closeReason = ticketMessage
                        table.remove(activeTickets[clientSteamID], i)
                        break
                    end
                end
                lia.config.set("activeStaffTickets", activeTickets)
            end
        end

        -- Update staff statistics
        if clientChar then
            local stats = clientChar:getData("staffStats", {})
            stats.ticketsClosed = (stats.ticketsClosed or 0) + 1
            stats.lastTicketClosed = os.time()

            -- Calculate average resolution time
            local claimedAt = requester.ticketClaimedAt
            if claimedAt then
                local resolutionTime = os.time() - claimedAt
                stats.averageResolutionTime = ((stats.averageResolutionTime or 0) * (stats.ticketsClosed - 1) + resolutionTime) / stats.ticketsClosed
            end

            clientChar:setData("staffStats", stats)
        end

        -- Update player statistics
        if requesterChar then
            local stats = requesterChar:getData("ticketStats", {})
            stats.ticketsClosed = (stats.ticketsClosed or 0) + 1
            stats.lastTicketClosed = os.time()

            -- Calculate satisfaction rating (if provided)
            if string.find(ticketMessage, "satisfied") or string.find(ticketMessage, "resolved") then
                stats.satisfactionRating = (stats.satisfactionRating or 0) + 1
            end

            requesterChar:setData("ticketStats", stats)
        end

        -- Notify the player
        local staffName = IsValid(client) and client:Name() or "System"
        requester:notifyInfo(string.format("Your ticket has been closed by %s.", staffName))
        if ticketMessage and ticketMessage ~= "" then
            requester:notifyInfo("Resolution: " .. ticketMessage)
        end

        -- Clear ticket data from player
        requester.CaseClaimed = nil
        requester.ticketCreatedTime = nil
        requester.ticketClaimedAt = nil

        -- Notify staff of closure
        for _, staff in pairs(player.GetAll()) do
            if staff:isStaff() and staff ~= client then
                staff:notifyInfo(string.format("Ticket closed by %s for %s", staffName, requester:Name()))
            end
        end

        -- Log the closure
        lia.log.add(client, "ticketClosed", requester:Name(), ticketMessage)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("ticket_closed", {
                staff_member = clientSteamID,
                requester = requesterSteamID,
                resolution_message = ticketMessage,
                resolution_time = requester.ticketClaimedAt and (os.time() - requester.ticketClaimedAt) or nil
            })
        end

        -- Clean up any timers
        timer.Remove("ticketAutoClose_" .. requesterSteamID)

        -- Award experience points to staff for closing tickets
        if IsValid(client) and lia.config.get("staffTicketXP", false) then
            local xpReward = lia.config.get("ticketCloseXP", 10)
            if clientChar then
                clientChar:updateAttrib("staffXP", xpReward)
                client:notifyInfo(string.format("Earned %d XP for closing ticket!", xpReward))
            end
        end
    end)
    ```
]]
function OnTicketCreated(noob, message)
end

--[[
    Purpose:
        Called when a player creates a new support ticket

    When Called:
        After a player has submitted a support ticket for assistance

    Parameters:
        - noob (Player): The player who created the ticket
        - message (string): The content/message of the ticket

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log ticket creation
    hook.Add("OnTicketCreated", "LogCreation", function(noob, message)
        print(string.format("New ticket from %s: %s", noob:Name(), message))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Basic ticket handling
    hook.Add("OnTicketCreated", "BasicHandling", function(noob, message)
        -- Store creation time
        noob.ticketCreatedTime = CurTime()

        -- Notify player
        noob:notifyInfo("Your ticket has been submitted. Please wait for assistance.")

        -- Log the ticket
        lia.log.add(noob, "ticketCreated", message)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ticket creation system
    hook.Add("OnTicketCreated", "AdvancedCreation", function(noob, message)
        local steamID = noob:SteamID64()
        local char = noob:getChar()

        -- Store ticket data
        noob.ticketCreatedTime = CurTime()
        noob.ticketMessage = message

        -- Update player statistics
        if char then
            local stats = char:getData("ticketStats", {})
            stats.ticketsCreated = (stats.ticketsCreated or 0) + 1
            stats.lastTicketCreated = os.time()
            char:setData("ticketStats", stats)
        end

        -- Parse ticket priority
        local priority = "normal"
        if string.find(message, "%[URGENT%]") or string.find(message, "%[HIGH%]") then
            priority = "high"
        elseif string.find(message, "%[LOW%]") then
            priority = "low"
        end

        -- Check for spam (recent tickets)
        local recentTickets = lia.config.get("recentTickets", {})
        local playerTickets = recentTickets[steamID] or {}
        local recentCount = 0

        for _, ticketTime in pairs(playerTickets) do
            if os.time() - ticketTime < 300 then -- 5 minutes
                recentCount = recentCount + 1
            end
        end

        if recentCount >= 3 then
            noob:notifyError("You are creating tickets too quickly. Please wait before submitting another.")
            return false -- Cancel ticket creation
        end

        -- Add to recent tickets
        table.insert(playerTickets, os.time())
        recentTickets[steamID] = playerTickets
        lia.config.set("recentTickets", recentTickets)

        -- Auto-assign to available staff
        local availableStaff = {}
        for _, ply in pairs(player.GetAll()) do
            if ply:isStaff() and ply:getNetVar("away", false) == false then
                table.insert(availableStaff, ply)
            end
        end

        if #availableStaff > 0 then
            -- Find staff with least active tickets
            local bestStaff = availableStaff[1]
            local minTickets = math.huge

            for _, staff in ipairs(availableStaff) do
                local activeTickets = lia.config.get("activeStaffTickets", {})[staff:SteamID64()]
                local ticketCount = activeTickets and #activeTickets or 0
                if ticketCount < minTickets then
                    minTickets = ticketCount
                    bestStaff = staff
                end
            end

            -- Auto-assign ticket
            hook.Run("OnTicketClaimed", bestStaff, noob, message)
            noob:notifyInfo(string.format("Your ticket has been assigned to %s.", bestStaff:Name()))
        else
            -- No staff available, add to queue
            local ticketQueue = lia.config.get("ticketQueue", {})
            table.insert(ticketQueue, {
                player = steamID,
                message = message,
                priority = priority,
                createdAt = os.time()
            })
            lia.config.set("ticketQueue", ticketQueue)

            noob:notifyInfo("No staff are currently available. Your ticket has been added to the queue.")
        end

        -- Notify all staff of new ticket
        for _, staff in pairs(player.GetAll()) do
            if staff:isStaff() then
                staff:notifyInfo(string.format("New %s priority ticket from %s", priority, noob:Name()))
            end
        end

        -- Log ticket creation
        lia.log.add(noob, "ticketCreated", message, priority)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("ticket_created", {
                player = steamID,
                message_length = string.len(message),
                priority = priority,
                queue_position = #lia.config.get("ticketQueue", {})
            })
        end

        -- Set up timeout for unclaimed tickets
        timer.Create("ticketTimeout_" .. steamID, 600, 1, function() -- 10 minutes
            if IsValid(noob) and not noob.CaseClaimed then
                noob:notifyInfo("Your ticket has expired. Please try again or contact staff directly.")
                hook.Run("OnTicketExpired", noob, message)
            end
        end)
    end)
    ```
]]
function OnTransferred(targetPlayer)
end

--[[
    Purpose:
        Called when a player is transferred to a different faction

    When Called:
        After a player has been successfully transferred to a new faction by an administrator

    Parameters:
        - targetPlayer (Player): The player who was transferred

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log faction transfers
    hook.Add("OnTransferred", "LogTransfers", function(targetPlayer)
        local faction = lia.faction.indices[targetPlayer:Team()]
        print(string.format("%s transferred to %s", targetPlayer:Name(), faction and faction.name or "Unknown"))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle faction transfer setup
    hook.Add("OnTransferred", "FactionSetup", function(targetPlayer)
        local faction = lia.faction.indices[targetPlayer:Team()]
        if faction then
            -- Remove old faction flags
            local char = targetPlayer:getChar()
            if char then
                char:takeFlags("Z") -- Remove faction kick warning
                char:setData("factionKickWarn", nil)
            end

            -- Call faction transfer function
            if faction.OnTransferred then
                faction:OnTransferred(targetPlayer)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced faction transfer system
    hook.Add("OnTransferred", "AdvancedTransfer", function(targetPlayer)
        local char = targetPlayer:getChar()
        if not char then return end

        local steamID = targetPlayer:SteamID64()
        local newFaction = lia.faction.indices[targetPlayer:Team()]
        local oldFactionID = char:getData("previousFaction")
        local oldFaction = oldFactionID and lia.faction.indices[oldFactionID]

        -- Update transfer statistics
        local stats = char:getData("transferStats", {})
        stats.factionTransfers = (stats.factionTransfers or 0) + 1
        stats.lastFactionTransfer = os.time()
        stats.previousFaction = oldFactionID
        char:setData("transferStats", stats)

        -- Store old faction for rollback
        char:setData("previousFaction", oldFactionID)

        -- Handle faction-specific transfer logic
        if newFaction then
            -- Remove incompatible items
            if oldFaction and newFaction.transferItems then
                local inventory = char:getInv()
                if inventory then
                    for _, item in pairs(inventory:getItems()) do
                        if newFaction.transferItems[item.uniqueID] == false then
                            item:remove()
                            targetPlayer:notifyWarning(string.format("%s removed due to faction transfer", item.name))
                        end
                    end
                end
            end

            -- Reset faction-specific data
            if oldFaction and oldFaction.factionData then
                for key, _ in pairs(oldFaction.factionData) do
                    char:setData("faction_" .. key, nil)
                end
            end

            -- Apply new faction defaults
            if newFaction.defaultClass then
                char:setClass(newFaction.defaultClass)
            end

            -- Set faction-specific variables
            if newFaction.startMoney then
                char:giveMoney(newFaction.startMoney)
                targetPlayer:notifyInfo(string.format("Received $%s faction bonus", lia.currency.get(newFaction.startMoney)))
            end

            -- Call faction transfer function
            if newFaction.OnTransferred then
                local success, err = pcall(newFaction.OnTransferred, targetPlayer)
                if not success then
                    lia.log.add(targetPlayer, "factionTransferError", tostring(err))
                end
            end

            -- Update faction member counts
            if oldFaction then
                oldFaction.memberCount = (oldFaction.memberCount or 0) - 1
            end
            newFaction.memberCount = (newFaction.memberCount or 0) + 1

            -- Handle faction reputation changes
            if oldFaction and oldFaction.enemies then
                for _, enemyFaction in ipairs(oldFaction.enemies) do
                    if enemyFaction == newFaction.index then
                        -- Transferring to enemy faction
                        targetPlayer:notifyWarning("Warning: Transferring to a rival faction!")
                        char:setData("factionTraitor", true)
                    end
                end
            end

            -- Notify player
            targetPlayer:notifyInfo(string.format("Successfully transferred to %s", newFaction.name))
            if oldFaction then
                targetPlayer:notifyInfo(string.format("Previous faction: %s", oldFaction.name))
            end
        end

        -- Clear faction kick warnings
        char:setData("factionKickWarn", nil)
        char:takeFlags("Z")

        -- Update faction history
        local factionHistory = char:getData("factionHistory", {})
        table.insert(factionHistory, {
            faction = newFaction and newFaction.index or targetPlayer:Team(),
            transferredAt = os.time(),
            transferredBy = "admin" -- Assuming admin transfer
        })
        char:setData("factionHistory", factionHistory)

        -- Log the transfer
        lia.log.add(targetPlayer, "factionTransfer", newFaction and newFaction.name or "Unknown", oldFaction and oldFaction.name or "None")

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("faction_transfer", {
                player = steamID,
                old_faction = oldFactionID,
                new_faction = newFaction and newFaction.index or targetPlayer:Team(),
                transfer_count = stats.factionTransfers
            })
        end

        -- Trigger character respawn for faction-specific loadout
        hook.Run("PlayerLoadout", targetPlayer)

        -- Check for faction transfer achievements
        if stats.factionTransfers >= 5 then
            targetPlayer:notifyInfo("Achievement: Faction Hopper!")
            char:setData("achievement_factionHopper", true)
        end
    end)
    ```
]]
function OnUsergroupCreated(groupName, groupData)
end

--[[
    Purpose:
        Called when usergroupcreated occurs

    When Called:
        After usergroupcreated has happened

    Parameters:
        - groupName: Description
        - groupData: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("OnUsergroupCreated", "MyAddon", function(groupName, groupData)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("OnUsergroupCreated", "MyAddon", function(groupName, groupData)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("OnUsergroupCreated", "MyAddon", function(groupName, groupData)
        -- Add your code here
    end)
    ```
]]
function OnUsergroupPermissionsChanged(groupName, permissions)
end

--[[
    Purpose:
        Called when usergrouppermissionschanged occurs

    When Called:
        After usergrouppermissionschanged has happened

    Parameters:
        - groupName: Description
        - permissions: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("OnUsergroupPermissionsChanged", "MyAddon", function(groupName, permissions)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("OnUsergroupPermissionsChanged", "MyAddon", function(groupName, permissions)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("OnUsergroupPermissionsChanged", "MyAddon", function(groupName, permissions)
        -- Add your code here
    end)
    ```
]]
function OnUsergroupRemoved(groupName)
end

--[[
    Purpose:
        Called when usergroupremoved occurs

    When Called:
        After usergroupremoved has happened

    Parameters:
        - groupName: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("OnUsergroupRemoved", "MyAddon", function(groupName)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("OnUsergroupRemoved", "MyAddon", function(groupName)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("OnUsergroupRemoved", "MyAddon", function(groupName)
        -- Add your code here
    end)
    ```
]]
function OnUsergroupRenamed(oldName, newName)
end

--[[
    Purpose:
        Called when usergrouprenamed occurs

    When Called:
        After usergrouprenamed has happened

    Parameters:
        - oldName: Description
        - newName: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("OnUsergroupRenamed", "MyAddon", function(oldName, newName)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("OnUsergroupRenamed", "MyAddon", function(oldName, newName)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("OnUsergroupRenamed", "MyAddon", function(oldName, newName)
        -- Add your code here
    end)
    ```
]]
function OnVendorEdited(client, vendor, key)
end

--[[
    Purpose:
        Called when a vendor is edited by a player

    When Called:
        After a vendor's properties have been successfully modified

    Parameters:
        - client (Player): The player who edited the vendor
        - vendor (Entity): The vendor entity that was edited
        - key (string): The property that was edited

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log vendor edits
    hook.Add("OnVendorEdited", "LogEdits", function(client, vendor, key)
        print(string.format("%s edited vendor %s (%s)", client:Name(), vendor:getNetVar("name", "Unknown"), key))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Handle specific edit types
    hook.Add("OnVendorEdited", "HandleEdits", function(client, vendor, key)
        if key == "price" then
            -- Price was changed
            client:notifyInfo("Vendor price updated")
        elseif key == "stock" then
            -- Stock was modified
            lia.log.add(client, "vendorStockEdit", vendor:getNetVar("name"))
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced vendor editing system
    hook.Add("OnVendorEdited", "AdvancedEditing", function(client, vendor, key)
        local char = client:getChar()
        if not char then return end

        local steamID = client:SteamID64()
        local charID = char:getID()
        local vendorName = vendor:getNetVar("name", "Unknown Vendor")
        local vendorID = vendor:EntIndex()

        -- Update editing statistics
        local stats = char:getData("vendorStats", {})
        stats.editsMade = (stats.editsMade or 0) + 1
        stats.lastEdit = {
            vendor = vendorName,
            key = key,
            timestamp = os.time()
        }
        char:setData("vendorStats", stats)

        -- Handle specific edit types
        if key == "name" then
            local oldName = vendor:getNetVar("oldName", vendorName)
            lia.log.add(client, "vendorRename", oldName, vendorName)
            vendor:setNetVar("oldName", vendorName)
        elseif key == "price" then
            -- Validate price changes
            local newPrice = vendor:getNetVar("price", 0)
            if newPrice < 0 then
                vendor:setNetVar("price", 0)
                client:notifyError("Vendor price cannot be negative!")
                return
            end
            lia.log.add(client, "vendorPriceChange", vendorName, newPrice)
        elseif key == "stock" then
            -- Track stock changes
            local stockData = char:getData("vendorStockChanges", {})
            stockData[vendorID] = (stockData[vendorID] or 0) + 1
            char:setData("vendorStockChanges", stockData)
        elseif key == "model" then
            -- Model changes might need validation
            local newModel = vendor:GetModel()
            if not util.IsValidModel(newModel) then
                lia.log.add(client, "invalidVendorModel", newModel)
                client:notifyWarning("Invalid vendor model set")
            end
        end

        -- Check editing permissions
        if not client:hasPermission("editVendors") then
            lia.log.add(client, "unauthorizedVendorEdit", vendorName, key)
            client:notifyError("You don't have permission to edit vendors!")
            return
        end

        -- Log the edit
        lia.log.add(client, "vendorEdited", vendorName, key)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("vendor_edited", {
                editor = steamID,
                vendor_name = vendorName,
                edit_type = key,
                edit_count = stats.editsMade
            })
        end

        -- Update vendor change history
        local changeHistory = vendor:getNetVar("changeHistory", {})
        table.insert(changeHistory, {
            changedBy = steamID,
            changedByName = client:Name(),
            changeType = key,
            timestamp = os.time()
        })

        -- Keep only last 20 changes
        if #changeHistory > 20 then
            table.remove(changeHistory, 1)
        end
        vendor:setNetVar("changeHistory", changeHistory)

        -- Notify other players with vendor permissions
        for _, ply in pairs(player.GetAll()) do
            if ply ~= client and ply:hasPermission("editVendors") then
                ply:notifyInfo(string.format("%s edited vendor %s (%s)", client:Name(), vendorName, key))
            end
        end

        -- Handle vendor persistence
        hook.Run("UpdateEntityPersistence", vendor)

        -- Check for achievement unlocks
        if stats.editsMade >= 100 then
            client:notifyInfo("Achievement: Master Vendor Manager!")
            char:setData("achievement_vendorManager", true)
        end

        -- Auto-save vendor data
        if lia.config.get("autoSaveVendorEdits", true) then
            timer.Create("vendorAutoSave_" .. vendorID, 5, 1, function()
                if IsValid(vendor) then
                    -- Save vendor data to database
                    local vendorData = {
                        name = vendor:getNetVar("name"),
                        price = vendor:getNetVar("price"),
                        stock = vendor:getNetVar("stock"),
                        lastEdited = os.time(),
                        lastEditedBy = steamID
                    }
                    lia.db.updateTable("vendor_data", vendorData, "entity_id = " .. vendorID)
                end
            end)
        end
    end)
    ```
]]
function OnlineStaffDataReceived(staffData)
end

--[[
    Purpose:
        Called when online staff data is received from an external source

    When Called:
        After staff data has been received and processed from an external service or API

    Parameters:
        - staffData (table): The received staff data containing information about online staff members

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log staff data reception
    hook.Add("OnlineStaffDataReceived", "LogData", function(staffData)
        print(string.format("Received data for %d staff members", #staffData))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Process staff data
    hook.Add("OnlineStaffDataReceived", "ProcessData", function(staffData)
        for _, staff in ipairs(staffData) do
            if staff.online then
                print(string.format("Staff %s is online", staff.name))
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced staff data management
    hook.Add("OnlineStaffDataReceived", "AdvancedManagement", function(staffData)
        if not staffData or #staffData == 0 then
            lia.log.add(nil, "staffDataEmpty")
            return
        end

        local processedCount = 0
        local onlineCount = 0
        local updatedRanks = 0

        -- Process each staff member
        for _, staffInfo in ipairs(staffData) do
            if not staffInfo.steamID then
                lia.log.add(nil, "staffDataInvalid", "missing steamID")
                goto continue
            end

            local steamID = staffInfo.steamID
            local player = player.GetBySteamID(steamID)
            local existingData = lia.config.get("staffData", {})[steamID] or {}

            -- Update staff data
            existingData.name = staffInfo.name or existingData.name
            existingData.rank = staffInfo.rank or existingData.rank
            existingData.department = staffInfo.department or existingData.department
            existingData.lastSeen = staffInfo.online and os.time() or existingData.lastSeen
            existingData.isOnline = staffInfo.online or false

            -- Update permissions if rank changed
            if staffInfo.rank and staffInfo.rank ~= existingData.oldRank then
                existingData.oldRank = existingData.rank
                updatedRanks = updatedRanks + 1

                -- Update player permissions if online
                if IsValid(player) then
                    local newGroup = lia.administrator.rankGroups[staffInfo.rank]
                    if newGroup then
                        player:SetUserGroup(newGroup)
                        player:notifyInfo(string.format("Your staff rank has been updated to %s", staffInfo.rank))
                    end
                end
            end

            -- Update activity statistics
            if staffInfo.online then
                onlineCount = onlineCount + 1
                existingData.totalOnlineTime = (existingData.totalOnlineTime or 0) + 1 -- Assuming called every minute
            end

            -- Store updated data
            local allStaffData = lia.config.get("staffData", {})
            allStaffData[steamID] = existingData
            lia.config.set("staffData", allStaffData)

            processedCount = processedCount + 1

            ::continue::
        end

        -- Update global staff statistics
        local globalStats = lia.config.get("globalStaffStats", {})
        globalStats.lastUpdate = os.time()
        globalStats.totalStaff = processedCount
        globalStats.onlineStaff = onlineCount
        globalStats.recentUpdates = (globalStats.recentUpdates or 0) + 1
        lia.config.set("globalStaffStats", globalStats)

        -- Notify administrators of updates
        if updatedRanks > 0 then
            for _, ply in pairs(player.GetAll()) do
                if ply:hasPermission("manageStaff") then
                    ply:notifyInfo(string.format("%d staff ranks updated", updatedRanks))
                end
            end
        end

        -- Log the data reception
        lia.log.add(nil, "staffDataReceived", processedCount, onlineCount, updatedRanks)

        -- Analytics tracking
        if lia.analytics then
            lia.analytics.track("staff_data_received", {
                total_staff = processedCount,
                online_staff = onlineCount,
                rank_updates = updatedRanks,
                timestamp = os.time()
            })
        end

        -- Trigger staff status updates
        hook.Run("OnStaffDataUpdated", staffData)

        -- Check for low staff coverage
        local requiredStaff = lia.config.get("minimumStaffOnline", 2)
        if onlineCount < requiredStaff then
            -- Alert administrators
            for _, ply in pairs(player.GetAll()) do
                if ply:hasPermission("receiveAlerts") then
                    ply:notifyWarning(string.format("Low staff coverage: %d/%d online", onlineCount, requiredStaff))
                end
            end
        end

        -- Update staff online indicators
        net.Start("liaStaffStatusUpdate")
        net.WriteTable(staffData)
        net.Broadcast()
    end)
    ```
]]
--[[
    Purpose:
        Allows modules to react when a networked option value is applied on the server

    When Called:
        Called inside lia.option.set after the option value is stored and OptionChanged has fired for definitions that set shouldNetwork = true

    Parameters:
        - client (Player|nil): Player who initiated the change when known; nil for server-driven updates
        - key (string): Identifier of the option being updated
        - value (any): New value assigned to the option

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log networked option changes
    hook.Add("OptionReceived", "LogNetworkedOptions", function(client, key, value)
        if client then
            print(client:Name() .. " changed networked option " .. key .. " to " .. tostring(value))
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate and apply server-side restrictions
    hook.Add("OptionReceived", "ValidateNetworkedOptions", function(client, key, value)
        if key == "admin_esp" and client and not client:IsAdmin() then
            return -- Block non-admins from enabling admin ESP
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Track option changes and apply server-side effects
    hook.Add("OptionReceived", "AdvancedOptionHandling", function(client, key, value)
        lia.log.write("option_networked", {
            player = client and client:SteamID() or "server",
            key = key,
            value = tostring(value),
            timestamp = os.time()
        })
        if key == "volume" and client then
            -- Sync volume to client's audio settings
            net.Start("liaSyncVolume")
            net.WriteFloat(value)
            net.Send(client)
        end
    end)
    ```
]]
function OptionReceived(client, key, value)
end

--[[
    Purpose:
        Override or adjust the respawn delay applied to a player

    When Called:
        Queried from GM:PlayerDeathThink before allowing respawn and from the respawn HUD countdown on the client

    Parameters:
        - client (Player): Player waiting to respawn
        - respawnTime (number): Current respawn delay in seconds from configuration

    Returns:
        number or nil - Return a number to replace the respawn delay or nil to use the existing value

    Realm:
        Shared

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Reduce respawn time
    hook.Add("OverrideSpawnTime", "ReduceRespawnTime", function(client, respawnTime)
        return respawnTime * 0.5
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based respawn times
    hook.Add("OverrideSpawnTime", "FactionRespawnTime", function(client, respawnTime)
        local char = client:getChar()
        if not char then return end
        local faction = char:getFaction()
        if faction == FACTION_POLICE then
            return 30
        elseif faction == FACTION_MEDIC then
            return 20
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Dynamic respawn time system
    hook.Add("OverrideSpawnTime", "DynamicRespawnTime", function(client, respawnTime)
        local char = client:getChar()
        if not char then return end
        -- Check for respawn time reduction items
        local inventory = char:getInv()
        if inventory then
            for _, item in pairs(inventory:getItems()) do
                if item.reduceRespawnTime then
                    respawnTime = respawnTime * 0.75
                end
            end
        end
        -- Check for VIP status
        if client:IsUserGroup("vip") then
            respawnTime = respawnTime * 0.5
        end
        -- Check death count
        local deaths = char:getData("deaths", 0)
        if deaths > 5 then
            respawnTime = respawnTime + (deaths * 2)
        end
        return math.max(respawnTime, 5)
    end)
    ```
]]
function OverrideSpawnTime(client, respawnTime)
end

--[[
    Purpose:
        React when a player passes access checks and opens a vendor

    When Called:
        Triggered in the vendor entity after CanPlayerAccessVendor returns true and before the vendor UI is sent

    Parameters:
        - activator (Player): Player who activated the vendor
        - self (Entity): Vendor entity being opened

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log vendor access
    hook.Add("PlayerAccessVendor", "LogVendorAccess", function(activator, self)
        print(activator:Name() .. " accessed vendor: " .. self:getNetVar("name", "Unknown"))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track vendor usage
    hook.Add("PlayerAccessVendor", "TrackVendorUsage", function(activator, self)
        local char = activator:getChar()
        if char then
            local vendorUses = char:getData("vendorUses", 0)
            char:setData("vendorUses", vendorUses + 1)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex vendor access system
    hook.Add("PlayerAccessVendor", "AdvancedVendorAccess", function(activator, self)
        local char = activator:getChar()
        if not char then return end
        -- Log to database
        lia.db.insertTable({
            charID = char:getID(),
            vendorID = self:MapCreationID(),
            timestamp = os.time()
        }, nil, "vendor_access_log")
        -- Check for special vendor bonuses
        if self:getNetVar("specialVendor") and char:getData("vipStatus") then
            activator:notify("VIP discount applied!")
        end
    end)
    ```
]]
function PlayerAccessVendor(activator, self)
end

--[[
    Purpose:
        Hook point for handling cheat detections before automatic punishment is applied

    When Called:
        Called when the anti-cheat routines detect tampering via liaCheckHack or when the cheat verification timer expires

    Parameters:
        - client (Player): Player flagged for potential cheating

    Returns:
        true to suppress the built-in punishment, or any other value to allow default handling

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log cheat detections
    hook.Add("PlayerCheatDetected", "LogCheatDetection", function(client)
        print("Cheat detected for player: " .. client:Name())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Custom punishment system
    hook.Add("PlayerCheatDetected", "CustomPunishment", function(client)
        -- Send to admin channel
        for _, admin in ipairs(player.GetAll()) do
            if admin:IsAdmin() then
                admin:ChatPrint("[CHEAT DETECTED] " .. client:Name() .. " - " .. client:SteamID())
            end
        end
        -- Allow default punishment to continue
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced cheat handling with escalation
    hook.Add("PlayerCheatDetected", "AdvancedCheatDetection", function(client)
        local steamID = client:SteamID()
        local detectionCount = client:getLiliaData("cheatDetections", 0) + 1
        client:setLiliaData("cheatDetections", detectionCount)
        
        -- First offense: warning only
        if detectionCount == 1 then
            client:ChatPrint("Warning: Cheat detection triggered. Further violations will result in a ban.")
            return true -- Suppress default punishment
        end
        
        -- Log to external system
        lia.log.write("cheat_detected", {
            player = steamID,
            count = detectionCount,
            timestamp = os.time()
        })
        
        -- Allow default punishment for repeat offenders
    end)
    ```
]]
function PlayerCheatDetected(client)
end

--[[
    Purpose:
        Cleanup and bookkeeping when a player leaves the server

    When Called:
        Runs during GM:PlayerDisconnected after Lilia saves per-player data and unloads their character

    Parameters:
        - client (Player): Player who disconnected

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log disconnect
    hook.Add("PlayerDisconnected", "LogDisconnect", function(client)
        lia.log.add(client, "playerDisconnected")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Clear pending tickets
    hook.Add("PlayerDisconnected", "ClearPendingTickets", function(client)
        ActiveTickets = ActiveTickets or {}
        ActiveTickets[client:SteamID()] = nil
    end)
    ```

    High Complexity:
    ```lua
    -- High: Persist session metrics
    hook.Add("PlayerDisconnected", "PersistSessionMetrics", function(client)
        local char = client:getChar()
        if not char then return end
        lia.db.insertTable({
            steamID = client:SteamID(),
            charID = char:getID(),
            playTime = char:getPlayTime(),
            leftAt = os.time()
        }, nil, "session_metrics")
    end)
    ```
]]
function PlayerDisconnected(client)
end

--[[
    Purpose:
        Notification point after an administrator gags a player (disables typed chat)

    When Called:
        Called from the admin library when the gag command succeeds

    Parameters:
        - target (Player): Player who was gagged
        - admin (Player): Staff member who issued the gag

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log gag actions
    hook.Add("PlayerGagged", "LogGag", function(target, admin)
        print(admin:Name() .. " gagged " .. target:Name())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track gag history
    hook.Add("PlayerGagged", "TrackGagHistory", function(target, admin)
        local gagHistory = target:getLiliaData("gagHistory", {})
        table.insert(gagHistory, {
            admin = admin:SteamID(),
            timestamp = os.time()
        })
        target:setLiliaData("gagHistory", gagHistory)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced gag management
    hook.Add("PlayerGagged", "AdvancedGagManagement", function(target, admin)
        lia.db.insertTable({
            targetSteamID = target:SteamID(),
            adminSteamID = admin:SteamID(),
            action = "gag",
            timestamp = os.time()
        }, nil, "admin_actions")
        -- Notify staff
        for _, staff in ipairs(player.GetAll()) do
            if staff:IsAdmin() then
                staff:ChatPrint("[GAG] " .. admin:Name() .. " gagged " .. target:Name())
            end
        end
    end)
    ```
]]
function PlayerGagged(target, admin)
end

--[[
    Purpose:
        Signal that a player's persistent Lilia data has finished loading

    When Called:
        Fired in GM:PlayerInitialSpawn after data is sent to the client and before the character selection UI opens

    Parameters:
        - client (Player): Player whose data finished loading

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Welcome message
    hook.Add("PlayerLiliaDataLoaded", "WelcomeMessage", function(client)
        timer.Simple(1, function()
            if IsValid(client) then
                client:ChatPrint("Welcome to the server!")
            end
        end)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Restore player settings
    hook.Add("PlayerLiliaDataLoaded", "RestoreSettings", function(client)
        local settings = client:getLiliaData("settings", {})
        if settings.uiTheme then
            net.Start("liaSetTheme")
            net.WriteString(settings.uiTheme)
            net.Send(client)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Complex initialization
    hook.Add("PlayerLiliaDataLoaded", "AdvancedInit", function(client)
        -- Check for returning player
        local lastSeen = client:getLiliaData("lastSeen", 0)
        local daysSince = math.floor((os.time() - lastSeen) / 86400)
        if daysSince > 30 then
            client:ChatPrint("Welcome back! You've been away for " .. daysSince .. " days.")
        end
        -- Apply saved preferences
        local prefs = client:getLiliaData("preferences", {})
        if prefs.defaultChar then
            timer.Simple(2, function()
                if IsValid(client) then
                    lia.char.loadSingleCharacter(prefs.defaultChar, client)
                end
            end)
        end
    end)
    ```
]]
function PlayerLiliaDataLoaded(client)
end

--[[
    Purpose:
        Handle logic right after a character has been set up for a player

    When Called:
        Triggered in the character selection flow once character:setup() completes, before the success response is sent

    Parameters:
        - client (Player): Player that loaded the character
        - character (Character): Character object that was loaded
        - currentChar (Character|nil): Previously active character if this was a switch, otherwise nil

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Welcome back message
    hook.Add("PlayerLoadedChar", "WelcomeBack", function(client, character, currentChar)
        if not currentChar then
            client:ChatPrint("Welcome, " .. character:getName() .. "!")
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Character switching logic
    hook.Add("PlayerLoadedChar", "CharSwitching", function(client, character, currentChar)
        if currentChar then
            -- Save previous character's position
            if IsValid(client) and client:Alive() then
                currentChar:setLastPos({
                    pos = client:GetPos(),
                    ang = client:EyeAngles(),
                    map = game.GetMap()
                })
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character loading
    hook.Add("PlayerLoadedChar", "AdvancedCharLoading", function(client, character, currentChar)
        -- Restore character-specific settings
        local charSettings = character:getData("settings", {})
        if charSettings.spawnItems then
            for _, itemID in ipairs(charSettings.spawnItems) do
                character:getInv():add(itemID)
            end
        end
        -- Apply faction bonuses
        local faction = lia.faction.indices[character:getFaction()]
        if faction and faction.onLoadChar then
            faction:onLoadChar(client, character)
        end
    end)
    ```
]]
function PlayerMessageSend(speaker, chatType, text, anonymous, receivers)
end

--[[
    Purpose:
        Allows modules to mutate chat text before it is broadcast to recipients

    When Called:
        Invoked from lia.chat.parse and lia.chat.send immediately before messages are distributed

    Parameters:
        - speaker (Player): Player sending the message
        - chatType (string): Chat class being used (ic/ooc/etc)
        - text (string): Message content about to be sent
        - anonymous (boolean): Whether the message hides the speaker by default
        - receivers (table|nil): Optional list of players that will receive the message during final send

    Returns:
        string or nil - Return a replacement message string or nil to keep the original

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Add prefix to IC chat
    hook.Add("PlayerMessageSend", "AddPrefix", function(speaker, chatType, text, anonymous, receivers)
        if chatType == "ic" then
            return "[IC] " .. text
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Filter profanity
    hook.Add("PlayerMessageSend", "FilterMessages", function(speaker, chatType, text, anonymous, receivers)
        local filtered = text:gsub("badword", "****")
        if filtered ~= text then
            speaker:notify("Your message contained inappropriate language")
            return filtered
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced message handling
    hook.Add("PlayerMessageSend", "AdvancedMessageHandling", function(speaker, chatType, text, anonymous, receivers)
        -- Log all messages
        lia.log.write("chat_message", {
            speaker = speaker:SteamID(),
            chatType = chatType,
            message = text,
            timestamp = os.time()
        })
        -- Apply custom formatting based on faction
        if chatType == "ic" and speaker:getChar() then
            local faction = speaker:getChar():getFaction()
            if faction == FACTION_POLICE then
                return "[POLICE] " .. text
            elseif faction == FACTION_MEDIC then
                return "[MEDIC] " .. text
            end
        end
    end)
    ```
]]
function PlayerModelChanged(client, value)
end

--[[
    Purpose:
        React when a character's model variable changes

    When Called:
        Called from the character model setter after the new model is applied and networked

    Parameters:
        - client (Player|nil): Owning player if they are online; nil when the character is unloaded
        - value (string): New model path assigned to the character

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log model changes
    hook.Add("PlayerModelChanged", "LogModelChange", function(client, value)
        if client then
            print(client:Name() .. " changed model to " .. value)
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track model changes
    hook.Add("PlayerModelChanged", "TrackModelChanges", function(client, value)
        if client and client:getChar() then
            local changes = client:getChar():getData("modelChanges", {})
            table.insert(changes, {model = value, time = os.time()})
            client:getChar():setData("modelChanges", changes)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced model tracking
    hook.Add("PlayerModelChanged", "AdvancedModelTracking", function(client, value)
        if not client then return end
        local char = client:getChar()
        if not char then return end
        -- Log to database
        lia.db.insertTable({
            charID = char:getID(),
            oldModel = char:getModel(),
            newModel = value,
            timestamp = os.time()
        }, nil, "model_changes")
        -- Check for restricted models
        local restrictedModels = {"models/restricted.mdl", "models/banned.mdl"}
        if table.HasValue(restrictedModels, value) then
            client:ChatPrint("This model is restricted!")
            char:setModel("models/player/phoenix.mdl")
        end
    end)
    ```
]]
function PlayerMuted(target, admin)
end

--[[
    Purpose:
        Notification after an administrator voice-mutes a player

    When Called:
        Called in the admin library when the mute command succeeds

    Parameters:
        - target (Player): Player who was muted
        - admin (Player): Staff member who issued the mute

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log mute actions
    hook.Add("PlayerMuted", "LogMute", function(target, admin)
        print(admin:Name() .. " muted " .. target:Name())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track mute history
    hook.Add("PlayerMuted", "TrackMuteHistory", function(target, admin)
        local muteHistory = target:getLiliaData("muteHistory", {})
        table.insert(muteHistory, {
            admin = admin:SteamID(),
            timestamp = os.time()
        })
        target:setLiliaData("muteHistory", muteHistory)
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced mute management
    hook.Add("PlayerMuted", "AdvancedMuteManagement", function(target, admin)
        lia.db.insertTable({
            targetSteamID = target:SteamID(),
            adminSteamID = admin:SteamID(),
            action = "mute",
            timestamp = os.time()
        }, nil, "admin_actions")
        -- Notify staff channel
        for _, staff in ipairs(player.GetAll()) do
            if staff:IsAdmin() then
                staff:ChatPrint("[MUTE] " .. admin:Name() .. " muted " .. target:Name())
            end
        end
    end)
    ```
]]
--[[
    Purpose:
        Let modules control whether the acts system is enabled

    When Called:
        Queried by modules implementing the acts system to determine if acts should be active

    Parameters:
        None

    Returns:
        boolean - Return true to enable acts, false or nil to disable

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Enable acts
    hook.Add("PlayerShouldAct", "EnableActs", function()
        return lia.config.get("ActsActive", false)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Conditionally enable acts
    hook.Add("PlayerShouldAct", "CheckPlayerState", function()
        -- Only enable acts during certain times
        local hour = tonumber(os.date("%H"))
        if hour >= 18 or hour < 6 then
            return true -- Night time acts allowed
        end
        return false
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced act validation
    hook.Add("PlayerShouldAct", "AdvancedActionValidation", function()
        -- Check server population
        local playerCount = #player.GetAll()
        if playerCount < 5 then return false end
        -- Check for event mode
        if lia.eventManager and lia.eventManager:isRunning() then
            return lia.eventManager:allowsActs()
        end
        return lia.config.get("ActsActive", false)
    end)
    ```
]]
function PlayerShouldAct()
end

--[[
    Purpose:
        Determine whether a character death should result in a permanent kill

    When Called:
        Called from GM:PlayerDeath when PK-related configuration would allow a permanent ban

    Parameters:
        - client (Player): Player who died
        - inflictor (Entity): Damage inflictor reported by the game
        - attacker (Entity): Entity credited with the kill

    Returns:
        boolean - Return true to permakill the character, false or nil to skip

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Always permakill on player kills
    hook.Add("PlayerShouldPermaKill", "AlwaysPermakill", function(client, inflictor, attacker)
        if IsValid(attacker) and attacker:IsPlayer() then
            return true
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Admin permakill override
    hook.Add("PlayerShouldPermaKill", "AdminPermakill", function(client, inflictor, attacker)
        if IsValid(attacker) and attacker:IsPlayer() and attacker:IsAdmin() then
            return false -- Admins can't permakill
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced permakill logic
    hook.Add("PlayerShouldPermaKill", "AdvancedPermakill", function(client, inflictor, attacker)
        local char = client:getChar()
        if not char then return false end
        -- Check for protected status
        if char:getData("protected", false) then return false end
        -- Check death count
        local deaths = char:getData("deaths", 0)
        if deaths >= 3 and IsValid(attacker) and attacker:IsPlayer() then
            return true
        end
        -- Check for marked for death
        return char:getMarkedForDeath()
    end)
    ```
]]
function PlayerShouldPermaKill(client, inflictor, attacker)
end

--[[
    Purpose:
        Receive the spawn position and angle chosen for a respawning player

    When Called:
        Executed by the spawns module after it resolves faction or saved spawn data for a player

    Parameters:
        - client (Player): Player being positioned
        - pos (Vector): World position that was selected (already offset above the ground)
        - ang (Angle): Eye angles that will be applied to the player

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log spawn locations
    hook.Add("PlayerSpawnPointSelected", "LogSpawns", function(client, pos, ang)
        print(client:Name() .. " spawned at " .. tostring(pos))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track spawn locations
    hook.Add("PlayerSpawnPointSelected", "TrackSpawnLocations", function(client, pos, ang)
        local char = client:getChar()
        if char then
            local spawnHistory = char:getData("spawnHistory", {})
            table.insert(spawnHistory, {
                pos = pos,
                ang = ang,
                timestamp = os.time()
            })
            char:setData("spawnHistory", spawnHistory)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced spawn tracking
    hook.Add("PlayerSpawnPointSelected", "AdvancedSpawnTracking", function(client, pos, ang)
        local char = client:getChar()
        if not char then return end
        -- Log to database
        lia.db.insertTable({
            charID = char:getID(),
            map = game.GetMap(),
            posX = pos.x,
            posY = pos.y,
            posZ = pos.z,
            timestamp = os.time()
        }, nil, "spawn_logs")
        -- Check for spawn restrictions
        if char:getData("spawnRestricted", false) then
            client:SetPos(lia.module.get("spawns"):GetDefaultSpawn())
        end
    end)
    ```
]]
function PlayerSpawnPointSelected(client, pos, ang)
end
--[[
    Purpose:
        Called after the fists weapon performs its contact trace

    When Called:
        Triggered in the hands weapon shortly after a punch trace completes, regardless of whether damage was applied

    Parameters:
        - client (Player): Player who threw the punch
        - trace (TraceResult): Trace data describing what the punch hit

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Punch announcement
    hook.Add("PlayerThrowPunch", "PunchAnnouncement", function(client, trace)
        if trace.Hit then
            client:ChatPrint("You hit something!")
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Apply shock gloves effect
    hook.Add("PlayerThrowPunch", "ApplyShockGloves", function(client, trace)
        if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() and client:getNetVar("shockGloves") then
            trace.Entity:TakeDamage(5, client, client)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Record punch statistics
    hook.Add("PlayerThrowPunch", "RecordPunchStats", function(client, trace)
        if not trace.Hit then return end
        local stats = client:getLiliaData("punchStats", {total = 0, hits = 0})
        stats.total = stats.total + 1
        stats.hits = stats.hits + 1
        if IsValid(trace.Entity) and trace.Entity:IsPlayer() then
            stats.playerHits = (stats.playerHits or 0) + 1
        end
        client:setLiliaData("punchStats", stats)
    end)
    ```
]]
function PlayerThrowPunch(client, trace)
end
--[[
    Purpose:
        Notification after an administrator removes a gag from a player

    When Called:
        Called in the admin library when the ungag command succeeds

    Parameters:
        - target (Player): Player who was ungagged
        - admin (Player): Staff member who lifted the gag

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log ungag actions
    hook.Add("PlayerUngagged", "LogUngag", function(target, admin)
        print(admin:Name() .. " ungagged " .. target:Name())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track ungag actions
    hook.Add("PlayerUngagged", "TrackUngag", function(target, admin)
        lia.db.insertTable({
            targetSteamID = target:SteamID(),
            adminSteamID = admin:SteamID(),
            action = "ungag",
            timestamp = os.time()
        }, nil, "admin_actions")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced ungag handling
    hook.Add("PlayerUngagged", "AdvancedUngag", function(target, admin)
        -- Notify staff
        for _, staff in ipairs(player.GetAll()) do
            if staff:IsAdmin() then
                staff:ChatPrint("[UNGAG] " .. admin:Name() .. " ungagged " .. target:Name())
            end
        end
        -- Update gag history
        local gagHistory = target:getLiliaData("gagHistory", {})
        if #gagHistory > 0 then
            gagHistory[#gagHistory].ungaggedBy = admin:SteamID()
            gagHistory[#gagHistory].ungaggedAt = os.time()
            target:setLiliaData("gagHistory", gagHistory)
        end
    end)
    ```
]]
function PlayerUngagged(target, admin)
end

--[[
    Purpose:
        Notification after an administrator removes a voice mute from a player

    When Called:
        Called in the admin library when the unmute command succeeds

    Parameters:
        - target (Player): Player who was unmuted
        - admin (Player): Staff member who lifted the mute

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log unmute actions
    hook.Add("PlayerUnmuted", "LogUnmute", function(target, admin)
        print(admin:Name() .. " unmuted " .. target:Name())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track unmute actions
    hook.Add("PlayerUnmuted", "TrackUnmute", function(target, admin)
        lia.db.insertTable({
            targetSteamID = target:SteamID(),
            adminSteamID = admin:SteamID(),
            action = "unmute",
            timestamp = os.time()
        }, nil, "admin_actions")
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced unmute handling
    hook.Add("PlayerUnmuted", "AdvancedUnmute", function(target, admin)
        -- Notify staff
        for _, staff in ipairs(player.GetAll()) do
            if staff:IsAdmin() then
                staff:ChatPrint("[UNMUTE] " .. admin:Name() .. " unmuted " .. target:Name())
            end
        end
        -- Clear mute history entry
        local muteHistory = target:getLiliaData("muteHistory", {})
        if #muteHistory > 0 then
            muteHistory[#muteHistory].unmutedBy = admin:SteamID()
            muteHistory[#muteHistory].unmutedAt = os.time()
            target:setLiliaData("muteHistory", muteHistory)
        end
    end)
    ```
]]
function PlayerUnmuted(target, admin)
end

--[[
    Purpose:
        Customize behaviour when a player uses a door entity

    When Called:
        Invoked by the doors module for doors and vehicles after CanPlayerUseDoor passes

    Parameters:
        - client (Player): Player who activated the door
        - door (Entity): Door or vehicle entity being used

    Returns:
        boolean|nil - Return false to block use, true to force allow, or nil to continue default handling

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log door usage
    hook.Add("PlayerUseDoor", "LogDoorUsage", function(client, door)
        print(client:Name() .. " used door at " .. tostring(door:GetPos()))
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track door usage
    hook.Add("PlayerUseDoor", "TrackDoorUsage", function(client, door)
        local char = client:getChar()
        if char then
            local doorUses = char:getData("doorUses", 0)
            char:setData("doorUses", doorUses + 1)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door usage system
    hook.Add("PlayerUseDoor", "AdvancedDoorUsage", function(client, door)
        local char = client:getChar()
        if not char then return false end
        -- Log to database
        lia.db.insertTable({
            charID = char:getID(),
            doorID = door:MapCreationID(),
            timestamp = os.time()
        }, nil, "door_usage_log")
        -- Check for door restrictions
        local doorData = door:getNetVar("doorData", {})
        if doorData.requiresKey then
            local hasKey = char:getInv():hasItem("door_key_" .. door:MapCreationID())
            if not hasKey then
                client:notify("This door requires a key!")
                return false
            end
        end
    end)
    ```
]]
function PlayerUseDoor(client, door)
end
--[[
    Purpose:
        Adjust door metadata after it is read from storage

    When Called:
        Called by the doors module for each door that receives persisted or preset data during load

    Parameters:
        - ent (Entity): Door entity being initialised
        - doorData (table): Table of attributes about to be applied to the entity

    Returns:
        table|nil - Return a modified data table to replace the original values or nil to leave them unchanged

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Add default door name
    hook.Add("PostDoorDataLoad", "AddDefaultName", function(ent, doorData)
        if not doorData.name or doorData.name == "" then
            doorData.name = "Door #" .. ent:MapCreationID()
        end
        return doorData
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Custom door settings
    hook.Add("PostDoorDataLoad", "CustomDoorSettings", function(ent, doorData)
        -- Apply faction-specific settings
        if doorData.factions and table.HasValue(doorData.factions, "police") then
            doorData.price = doorData.price or 1000
            doorData.locked = true
        end
        return doorData
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door data processing
    hook.Add("PostDoorDataLoad", "AdvancedDoorDataProcessing", function(ent, doorData)
        -- Validate door data
        if doorData.price and doorData.price < 0 then
            doorData.price = 0
        end
        -- Apply map-specific presets
        local mapPresets = lia.data.get("doorPresets", {})
        local mapID = ent:MapCreationID()
        if mapPresets[game.GetMap()] and mapPresets[game.GetMap()][mapID] then
            for k, v in pairs(mapPresets[game.GetMap()][mapID]) do
                doorData[k] = v
            end
        end
        return doorData
    end)
    ```
]]
function PostDoorDataLoad(ent, doorData)
end

--[[
    Purpose:
        Hook point after all persistence has been loaded during startup

    When Called:
        Executed at the end of GM:LoadData and GM:LiliaTablesLoaded after map entities, config, and door data are processed

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Initialize systems after load
    hook.Add("PostLoadData", "InitializeSystems", function()
        print("All data loaded successfully!")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Post-load initialization
    hook.Add("PostLoadData", "PostLoadInit", function()
        -- Start background timers
        timer.Create("liaMaintenance", 300, 0, function()
            -- Maintenance tasks
        end)
        -- Sync data to clients
        for _, ply in ipairs(player.GetAll()) do
            lia.module.get("mainmenu"):SyncCharList(ply)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced post-load initialization
    hook.Add("PostLoadData", "AdvancedPostLoadInit", function()
        -- Verify loaded data integrity
        local doorCount = 0
        for _, door in ents.Iterator() do
            if door:isDoor() then doorCount = doorCount + 1 end
        end
        lia.information("Loaded " .. doorCount .. " doors")
        -- Initialize event systems
        if lia.eventManager then
            lia.eventManager:initialize()
        end
        -- Start scheduled tasks
        lia.scheduler.start()
    end)
    ```
]]
function PostLoadData()
end

--[[
    Purpose:
        Run logic after a player completes the initial spawn setup sequence

    When Called:
        Called from GM:PlayerInitialSpawn once persistence is loaded, data is sent, and before the character menu opens

    Parameters:
        - client (Player): Player that just spawned for the first time this session

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Welcome message
    hook.Add("PostPlayerInitialSpawn", "WelcomeMessage", function(client)
        timer.Simple(2, function()
            if IsValid(client) then
                client:ChatPrint("Welcome to the server!")
            end
        end)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Initialize player data
    hook.Add("PostPlayerInitialSpawn", "InitPlayerData", function(client)
        -- Set default preferences
        local prefs = client:getLiliaData("preferences", {})
        if not prefs.uiScale then
            prefs.uiScale = 1.0
            client:setLiliaData("preferences", prefs)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced player initialization
    hook.Add("PostPlayerInitialSpawn", "AdvancedPlayerInit", function(client)
        -- Check for returning player
        local lastSeen = client:getLiliaData("lastSeen", 0)
        if lastSeen > 0 then
            local daysSince = math.floor((os.time() - lastSeen) / 86400)
            if daysSince > 7 then
                client:ChatPrint("Welcome back! You've been away for " .. daysSince .. " days.")
            end
        end
        -- Load player-specific settings
        lia.module.get("customization"):loadPlayerSettings(client)
    end)
    ```
]]
function PostPlayerInitialSpawn(client)
end

--[[
    Purpose:
        React after a character has been fully loaded and acknowledged by the client

    When Called:
        Triggered after PlayerLoadedChar and the choose-character net message completes

    Parameters:
        - client (Player): Player whose character finished loading
        - character (Character): Character that is now active
        - currentChar (Character|nil): Previously active character prior to the switch

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Welcome message
    hook.Add("PostPlayerLoadedChar", "WelcomeMessage", function(client, character, currentChar)
        client:ChatPrint("Welcome, " .. character:getName() .. "!")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Restore character state
    hook.Add("PostPlayerLoadedChar", "RestoreCharState", function(client, character, currentChar)
        -- Restore saved position if switching
        if currentChar then
            local savedPos = character:getData("savedPos")
            if savedPos and savedPos.pos then
                client:SetPos(savedPos.pos)
                if savedPos.ang then
                    client:SetEyeAngles(savedPos.ang)
                end
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character load
    hook.Add("PostPlayerLoadedChar", "AdvancedCharLoad", function(client, character, currentChar)
        -- Apply character-specific modifications
        local charData = character:getData("customData", {})
        if charData.spawnItems then
            for _, itemID in ipairs(charData.spawnItems) do
                character:getInv():add(itemID)
            end
        end
        -- Check for special events
        if lia.eventManager and lia.eventManager:isActive() then
            lia.eventManager:onPlayerJoin(client, character)
        end
        -- Sync with external systems
        lia.module.get("discord"):syncCharacter(character)
    end)
    ```
]]
function PostPlayerLoadedChar(client, character, currentChar)
end

--[[
    Purpose:
        Extend loadout handling after Lilia equips its default gear

    When Called:
        Executed at the end of GM:PlayerLoadout after the character has been set up and default weapons assigned

    Parameters:
        - client (Player): Player who just received their loadout

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Give starter items
    hook.Add("PostPlayerLoadout", "GiveStarterItems", function(client)
        local char = client:getChar()
        if char then
            char:getInv():add("weapon_pistol")
            char:getInv():add("weapon_radio")
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Faction-based loadout
    hook.Add("PostPlayerLoadout", "FactionLoadout", function(client)
        local char = client:getChar()
        if not char then return end
        local faction = lia.faction.indices[char:getFaction()]
        if faction.loadout then
            for _, itemID in ipairs(faction.loadout) do
                char:getInv():add(itemID)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced loadout system
    hook.Add("PostPlayerLoadout", "AdvancedLoadout", function(client)
        local char = client:getChar()
        if not char then return end
        -- Apply class-specific items
        local class = lia.class.list[char:getClass()]
        if class and class.loadout then
            for _, itemData in ipairs(class.loadout) do
                local item = char:getInv():add(itemData.item)
                if item and itemData.data then
                    for k, v in pairs(itemData.data) do
                        item:setData(k, v)
                    end
                end
            end
        end
        -- Set health based on attributes
        if lia.module.get("attributes") then
            local health = lia.module.get("attributes"):getHealth(char)
            client:SetMaxHealth(health)
            client:SetHealth(health)
        end
    end)
    ```
]]
function PostPlayerLoadout(client)
end

--[[
    Purpose:
        Perform actions after a chat message has been processed and sent

    When Called:
        Runs from GM:PlayerSay after the message is logged and broadcast

    Parameters:
        - client (Player): Player who sent the chat message
        - message (string): Text that was actually sent
        - chatType (string): Chat class used for the message
        - anonymous (boolean): Whether anonymity was applied

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log all messages
    hook.Add("PostPlayerSay", "LogMessages", function(client, message, chatType, anonymous)
        print(client:Name() .. " [" .. chatType .. "]: " .. message)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Track chat statistics
    hook.Add("PostPlayerSay", "TrackChatStats", function(client, message, chatType, anonymous)
        local char = client:getChar()
        if char then
            local stats = char:getData("chatStats", {})
            stats[chatType] = (stats[chatType] or 0) + 1
            char:setData("chatStats", stats)
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced chat tracking
    hook.Add("PostPlayerSay", "AdvancedChatTracking", function(client, message, chatType, anonymous)
        -- Log to database
        lia.db.insertTable({
            charID = client:getChar() and client:getChar():getID() or 0,
            steamID = client:SteamID(),
            chatType = chatType,
            message = message,
            timestamp = os.time()
        }, nil, "chat_logs")
        -- Analyze for commands
        if message:StartWith("!") then
            -- Track command usage
        end
    end)
    ```
]]
function PostPlayerSay(client, message, chatType, anonymous)
end

--[[
    Purpose:
        Observe the final damage scale applied by the realistic damage system

    When Called:
        Called by the realistic damage module after ScalePlayerDamage calculates and applies the damage multiplier

    Parameters:
        - hitgroup (number): Hitgroup the player was struck in
        - dmgInfo (CTakeDamageInfo): Damage information object being applied
        - damageScale (number): Multiplier that was used for this hit

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log damage scaling
    hook.Add("PostScaleDamage", "LogDamageScale", function(hitgroup, dmgInfo, damageScale)
        print("Damage scaled: " .. damageScale .. "x for hitgroup " .. hitgroup)
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Apply damage effects
    hook.Add("PostScaleDamage", "ApplyDamageEffects", function(hitgroup, dmgInfo, damageScale)
        local victim = dmgInfo:GetAttacker()
        if IsValid(victim) and victim:IsPlayer() then
            if hitgroup == HITGROUP_HEAD and damageScale > 1.5 then
                victim:setNetVar("concussed", true)
                timer.Simple(5, function()
                    if IsValid(victim) then
                        victim:setNetVar("concussed", nil)
                    end
                end)
            end
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced damage tracking
    hook.Add("PostScaleDamage", "AdvancedDamageTracking", function(hitgroup, dmgInfo, damageScale)
        local victim = dmgInfo:GetAttacker()
        local attacker = dmgInfo:GetAttacker()
        if IsValid(victim) and victim:IsPlayer() and victim:getChar() then
            -- Track damage taken
            local damageStats = victim:getChar():getData("damageStats", {})
            damageStats.total = (damageStats.total or 0) + dmgInfo:GetDamage()
            damageStats[hitgroup] = (damageStats[hitgroup] or 0) + dmgInfo:GetDamage()
            victim:getChar():setData("damageStats", damageStats)
            -- Apply bleeding for limb hits
            if table.HasValue({HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG}, hitgroup) then
                if lia.module.get("injuries") then
                    lia.module.get("injuries"):addBleeding(victim, damageScale * 10)
                end
            end
        end
    end)
    ```
]]
function PostScaleDamage(hitgroup, dmgInfo, damageScale)
end

--[[
    Purpose:
        Chance to react before a character record is removed from the database

    When Called:
        Invoked by lia.char.delete immediately before the character and associated data are deleted

    Parameters:
        - id (number): Identifier of the character that is about to be removed

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character deletion
    hook.Add("PreCharDelete", "LogDeletion", function(id)
        print("Character " .. id .. " is being deleted")
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Backup character data
    hook.Add("PreCharDelete", "BackupCharData", function(id)
        local char = lia.char.getCharacter(id)
        if char then
            -- Save backup to separate table
            lia.db.insertTable({
                charID = id,
                name = char:getName(),
                data = char:getData(),
                deletedAt = os.time()
            }, nil, "deleted_characters_backup")
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character delete prep
    hook.Add("PreCharDelete", "AdvancedCharDeletePrep", function(id)
        local char = lia.char.getCharacter(id)
        if not char then return end
        -- Archive all character data
        lia.db.insertTable({
            charID = id,
            owner = char:getPlayer() and char:getPlayer():SteamID() or "unknown",
            name = char:getName(),
            faction = char:getFaction(),
            inventory = char:getInv():getItems(),
            money = char:getMoney(),
            deletedAt = os.time()
        }, nil, "char_archive")
        -- Notify external systems
        if lia.module.get("discord") then
            lia.module.get("discord"):logCharacterDeletion(char)
        end
    end)
    ```
]]
function PreCharDelete(id)
end

--[[
    Purpose:
        Modify door metadata before it is written back to persistent storage

    When Called:
        Called by the doors module while iterating map doors during SaveData

    Parameters:
        - door (Entity): Door entity whose data is being saved
        - doorData (table): Metadata collected for the door

    Returns:
        table|nil - Return a table to replace the saved data or nil to keep the existing values

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Clean door data
    hook.Add("PreDoorDataSave", "CleanDoorData", function(door, doorData)
        -- Remove empty values
        for k, v in pairs(doorData) do
            if v == "" or v == nil then
                doorData[k] = nil
            end
        end
        return doorData
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Validate door data
    hook.Add("PreDoorDataSave", "ValidateDoorData", function(door, doorData)
        -- Ensure price is valid
        if doorData.price and (doorData.price < 0 or doorData.price > 999999999) then
            doorData.price = 0
        end
        -- Validate name length
        if doorData.name and #doorData.name > 255 then
            doorData.name = doorData.name:sub(1, 255)
        end
        return doorData
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced door data validation
    hook.Add("PreDoorDataSave", "AdvancedDoorDataValidation", function(door, doorData)
        -- Comprehensive validation
        if doorData.factions and not istable(doorData.factions) then
            doorData.factions = {}
        end
        if doorData.classes and not istable(doorData.classes) then
            doorData.classes = {}
        end
        -- Apply server-wide door settings
        local serverSettings = lia.data.get("doorServerSettings", {})
        if serverSettings[door:MapCreationID()] then
            for k, v in pairs(serverSettings[door:MapCreationID()]) do
                doorData[k] = v
            end
        end
        return doorData
    end)
    ```
]]
function PreDoorDataSave(door, doorData)
end
--[[
    Purpose:
        Hook point before an item interaction handler is executed

    When Called:
        Fired inside ITEM:interact after validation passes but before the action callback runs

    Parameters:
        - client (Player): Player performing the action
        - action (string): Name of the interaction being executed
        - self (Item): Item instance being acted upon

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log item interactions
    hook.Add("PrePlayerInteractItem", "LogInteractions", function(client, action, self)
        print(client:Name() .. " used " .. action .. " on " .. self:getName())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Check cooldown
    hook.Add("PrePlayerInteractItem", "CheckCooldown", function(client, action, self)
        local cooldownKey = "item_" .. self:getID() .. "_" .. action
        local lastUse = client:getLiliaData(cooldownKey, 0)
        if CurTime() - lastUse < 5 then
            client:notify("Please wait before using this item again")
            return
        end
        client:setLiliaData(cooldownKey, CurTime())
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced item interaction
    hook.Add("PrePlayerInteractItem", "AdvancedItemInteraction", function(client, action, self)
        local char = client:getChar()
        if not char then return end
        -- Check for required permissions
        if self:getData("requiresPermission") then
            local perm = self:getData("requiresPermission")
            if not client:hasPrivilege(perm) then
                client:notify("You don't have permission to use this item")
                return false
            end
        end
        -- Apply stamina cost
        if self:getData("staminaCost") and lia.module.get("attributes") then
            local cost = self:getData("staminaCost")
            if client:getLocalVar("stamina", 100) < cost then
                client:notify("You're too tired to use this")
                return false
            end
            client:consumeStamina(cost)
        end
        -- Log interaction
        lia.db.insertTable({
            charID = char:getID(),
            itemID = self:getID(),
            action = action,
            timestamp = os.time()
        }, nil, "item_interactions")
    end)
    ```
]]
function PrePlayerInteractItem(client, action, self)
end
--[[
    Purpose:
        React before a character is set up and loaded for a player

    When Called:
        Triggered in the character selection flow immediately before character:setup() is called

    Parameters:
        - client (Player): Player that is loading the character
        - character (Character): Character object that will be loaded
        - currentChar (Character|nil): Previously active character if this is a switch, otherwise nil

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Log character loading
    hook.Add("PrePlayerLoadedChar", "LogCharLoad", function(client, character, currentChar)
        print(client:Name() .. " is loading character: " .. character:getName())
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Save current character state
    hook.Add("PrePlayerLoadedChar", "SaveCurrentChar", function(client, character, currentChar)
        if currentChar and IsValid(client) and client:Alive() then
            -- Save position before switching
            currentChar:setData("lastPos", {
                pos = client:GetPos(),
                ang = client:EyeAngles(),
                map = game.GetMap()
            })
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced character load prep
    hook.Add("PrePlayerLoadedChar", "AdvancedCharLoadPrep", function(client, character, currentChar)
        -- Validate character can be loaded
        if character:getData("banned", false) then
            client:notify("This character is banned")
            return
        end
        -- Save current character inventory snapshot
        if currentChar then
            local snapshot = {}
            for _, item in pairs(currentChar:getInv():getItems()) do
                table.insert(snapshot, {
                    id = item:getID(),
                    uniqueID = item.uniqueID,
                    data = item.data
                })
            end
            currentChar:setData("inventorySnapshot", snapshot)
        end
        -- Preload character-specific data
        lia.module.get("customization"):preloadCharacterData(character)
    end)
    ```
]]
function PrePlayerLoadedChar(client, character, currentChar)
end
function PreSalaryGive(client, char, pay, faction, class)
end

--[[
    Purpose:
        Called before salarygive happens

    When Called:
        Before salarygive is executed

    Parameters:
        - client: Description
        - char: Description
        - pay: Description
        - faction: Description
        - class: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("PreSalaryGive", "MyAddon", function(client, char, pay, faction, class)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("PreSalaryGive", "MyAddon", function(client, char, pay, faction, class)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("PreSalaryGive", "MyAddon", function(client, char, pay, faction, class)
        -- Add your code here
    end)
    ```
]]
function PreScaleDamage(hitgroup, dmgInfo, damageScale)
end

--[[
    Purpose:
        Called before scaledamage happens

    When Called:
        Before scaledamage is executed

    Parameters:
        - hitgroup: Description
        - dmgInfo: Description
        - damageScale: Description

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("PreScaleDamage", "MyAddon", function(hitgroup, dmgInfo, damageScale)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("PreScaleDamage", "MyAddon", function(hitgroup, dmgInfo, damageScale)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("PreScaleDamage", "MyAddon", function(hitgroup, dmgInfo, damageScale)
        -- Add your code here
    end)
    ```
]]
function RegisterPreparedStatements()
end

--[[
    Purpose:
        Allow modules to register custom prepared database statements.

    When Called:
        Called from `GM:RegisterPreparedStatements` during database initialization. Note: This is a GM function override point, not a hook that is run. To hook into this, override `GM:RegisterPreparedStatements`.

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("RegisterPreparedStatements", "MyAddon", function()
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("RegisterPreparedStatements", "MyAddon", function()
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("RegisterPreparedStatements", "MyAddon", function()
        -- Add your code here
    end)
    ```
]]
function RemoveWarning(charID, index)
end

--[[
    Purpose:
        React when a warning is removed from a character's record.

    When Called:
        Called from the administration module's `RemoveWarning` function after a warning is successfully deleted from the database. Note: This appears to be a module function, not a hook. The actual hook that fires is `WarningRemoved`.

    Parameters:
        - charID (number): Character ID whose warning was removed.
        - index (number): Index of the warning that was removed.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("RemoveWarning", "MyAddon", function(charID, index)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("RemoveWarning", "MyAddon", function(charID, index)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("RemoveWarning", "MyAddon", function(charID, index)
        -- Add your code here
    end)
    ```
]]
function RunAdminSystemCommand(cmd, admin, victim, dur, reason)
end

--[[
    Purpose:
        Override or intercept admin system command execution.

    When Called:
        Called from `lia.administrator.execCommand` before the command is executed, allowing custom command handling.

    Parameters:
        - cmd (string): Command being executed (e.g., "ban", "kick", "warn").
        - victim (Player|string): Target player or Steam ID.
        - dur (number|nil): Duration for timed commands, or nil for permanent.
        - reason (string): Reason for the command.

    Returns:
        boolean, function - Return true and a callback function to override the command, or nil to use default handling.

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("RunAdminSystemCommand", "MyAddon", function(cmd, admin, victim, dur, reason)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("RunAdminSystemCommand", "MyAddon", function(cmd, admin, victim, dur, reason)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("RunAdminSystemCommand", "MyAddon", function(cmd, admin, victim, dur, reason)
        -- Add your code here
    end)
    ```
]]
function SaveData()
end

--[[
    Purpose:
        Allows modification or prevention of server data saving operations

    When Called:
        When the server is saving persistent data, entities, and world state

    Parameters:
        None

    Returns:
        boolean - Return false to prevent data saving, nil/true to allow

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Disable data saving during maintenance
    hook.Add("SaveData", "MaintenanceMode", function()
        if GetGlobalBool("MaintenanceMode", false) then
            return false -- Prevent saving during maintenance
        end
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: Conditional saving based on server state
    hook.Add("SaveData", "ConditionalSave", function()
        -- Only save if there are players online
        if player.GetCount() == 0 then
            return false
        end

        -- Only save during certain hours
        local hour = tonumber(os.date("%H"))
        if hour < 6 or hour > 22 then
            return false
        end
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced save management with logging and validation
    hook.Add("SaveData", "AdvancedSaveManager", function()
        -- Check server performance before saving
        local fps = 1 / RealFrameTime()
        if fps < 10 then
            lia.log.add(nil, "save_cancelled_low_fps", fps)
            return false -- Don't save if server is struggling
        end

        -- Validate critical data before saving
        local criticalErrors = {}

        -- Check database connection
        if not lia.db then
            table.insert(criticalErrors, "database_connection")
        end

        -- Check for corrupted inventories
        for _, ply in ipairs(player.GetAll()) do
            local char = ply:getChar()
            if char then
                local inv = char:getInv()
                if inv then
                    local itemCount = table.Count(inv:getItems())
                    if itemCount > 1000 then -- Suspicious item count
                        table.insert(criticalErrors, "inventory_corruption_" .. ply:SteamID())
                    end
                end
            end
        end

        -- Log save attempt
        lia.log.add(nil, "data_save_attempt", {
            players = player.GetCount(),
            fps = math.floor(fps),
            errors = #criticalErrors,
            timestamp = os.time()
        })

        -- Prevent save if critical errors found
        if #criticalErrors > 0 then
            lia.log.add(nil, "save_cancelled_errors", table.concat(criticalErrors, ", "))
            return false
        end

        -- Add custom save timing
        SetGlobalFloat("LastSaveTime", CurTime())
    end)
    ```
]]
function SendPopup(noob, message)
end

--[[
    Purpose:
        React when a ticket system popup is sent to staff members.

    When Called:
        Called from the administration module's `SendPopup` function after the popup network message is sent to all staff members. Note: This appears to be a module function, not a hook. The actual hook that fires is `TicketSystemCreated`.

    Parameters:
        - noob (Player): Player who created the ticket.
        - message (string): Ticket message content.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("SendPopup", "MyAddon", function(noob, message)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("SendPopup", "MyAddon", function(noob, message)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("SendPopup", "MyAddon", function(noob, message)
        -- Add your code here
    end)
    ```
]]
function SetupBagInventoryAccessRules(inventory)
end

--[[
    Purpose:
        Configure access rules for a bag item's inventory.

    When Called:
        Called from bag item initialization when a bag inventory is created or restored, allowing modules to set custom access rules.

    Parameters:
        - inventory (Inventory): Inventory instance for the bag item.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("SetupBagInventoryAccessRules", "MyAddon", function(inventory)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("SetupBagInventoryAccessRules", "MyAddon", function(inventory)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("SetupBagInventoryAccessRules", "MyAddon", function(inventory)
        -- Add your code here
    end)
    ```
]]
function SetupBotPlayer(client)
end

--[[
    Purpose:
        Configure a bot player during initial spawn.

    When Called:
        Called from `GM:PlayerInitialSpawn` when a bot player connects, before normal player setup.

    Parameters:
        - client (Player): Bot player that just spawned.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("SetupBotPlayer", "MyAddon", function(client)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("SetupBotPlayer", "MyAddon", function(client)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("SetupBotPlayer", "MyAddon", function(client)
        -- Add your code here
    end)
    ```
]]
function SetupDatabase()
end

--[[
    Purpose:
        Configure database connection settings before connection is established.

    When Called:
        Called from the loader during server initialization, before the database connection is made.

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("SetupDatabase", "MyAddon", function()
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("SetupDatabase", "MyAddon", function()
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("SetupDatabase", "MyAddon", function()
        -- Add your code here
    end)
    ```
]]
function SetupPlayerModel(client, character)
end

--[[
    Purpose:
        Configure a player's model setup after character model is applied.

    When Called:
        Called from character setup after the player's model and skin are set, allowing additional model configuration.

    Parameters:
        - client (Player): Player whose model is being set up.
        - character (Character): Character object that was loaded.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("SetupPlayerModel", "MyAddon", function(client, character)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("SetupPlayerModel", "MyAddon", function(client, character)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("SetupPlayerModel", "MyAddon", function(client, character)
        -- Add your code here
    end)
    ```
]]
function ShouldDataBeSaved()
end

--[[
    Purpose:
        Control whether server data should be saved during shutdown.

    When Called:
        Queried from `GM:ShutDown` before saving persistent data, config, and player data.

    Parameters:
        None

    Returns:
        boolean|nil - Return false to prevent data saving, nil or any other value to allow saving.

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("ShouldDataBeSaved", "MyAddon", function()
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("ShouldDataBeSaved", "MyAddon", function()
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("ShouldDataBeSaved", "MyAddon", function()
        -- Add your code here
    end)
    ```
]]
function ShouldDeleteSavedItems()
end

--[[
    Purpose:
        Control whether saved items should be deleted when their owner's character data is missing.

    When Called:
        Queried from `GM:LoadData` when processing item persistence and orphaned items are detected.

    Parameters:
        None

    Returns:
        boolean|nil - Return true to delete orphaned items, nil or false to keep them.

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("ShouldDeleteSavedItems", "MyAddon", function()
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("ShouldDeleteSavedItems", "MyAddon", function()
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("ShouldDeleteSavedItems", "MyAddon", function()
        -- Add your code here
    end)
    ```
]]
function StorageCanTransferItem(client, storage, item)
end

--[[
    Purpose:
        Control whether a player can transfer an item from storage.

    When Called:
        Queried from the storage netcall handler when a player attempts to transfer an item from storage inventory.

    Parameters:
        - client (Player): Player attempting the transfer.
        - storage (Entity): Storage entity containing the item.
        - item (Item): Item object being transferred.

    Returns:
        boolean|nil - Return false to block the transfer, nil or true to allow.

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StorageCanTransferItem", "MyAddon", function(client, storage, item)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StorageCanTransferItem", "MyAddon", function(client, storage, item)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StorageCanTransferItem", "MyAddon", function(client, storage, item)
        -- Add your code here
    end)
    ```
]]
function StorageEntityRemoved(self, inventory)
end

--[[
    Purpose:
        React when a storage entity is removed and its inventory is deleted.

    When Called:
        Called from the storage entity's `deleteInventory` method after the inventory is deleted, unless `liaForceDelete` is set.

    Parameters:
        - self (Entity): Storage entity that was removed.
        - inventory (Inventory): Inventory instance that was deleted.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StorageEntityRemoved", "MyAddon", function(self, inventory)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StorageEntityRemoved", "MyAddon", function(self, inventory)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StorageEntityRemoved", "MyAddon", function(self, inventory)
        -- Add your code here
    end)
    ```
]]
function StorageInventorySet(entity, inventory, isCar)
end

--[[
    Purpose:
        React when an inventory is assigned to a storage entity.

    When Called:
        Called from storage initialization functions after an inventory instance is created and assigned to the entity, or from the storage entity's `setInventory` method.

    Parameters:
        - entity (Entity): Storage entity receiving the inventory.
        - inventory (Inventory): Inventory instance being assigned.
        - isCar (boolean): Whether the entity is a vehicle.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StorageInventorySet", "MyAddon", function(entity, inventory, isCar)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StorageInventorySet", "MyAddon", function(entity, inventory, isCar)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StorageInventorySet", "MyAddon", function(entity, inventory, isCar)
        -- Add your code here
    end)
    ```
]]
function StorageItemRemoved()
end

--[[
    Purpose:
        React when an item is removed from storage and the storage data needs to be saved.

    When Called:
        Called from the storage module's `StorageItemRemoved` method after an item is removed. Note: This appears to be a module function, not a hook that is run.

    Parameters:
        None

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StorageItemRemoved", "MyAddon", function()
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StorageItemRemoved", "MyAddon", function()
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StorageItemRemoved", "MyAddon", function()
        -- Add your code here
    end)
    ```
]]
function StorageOpen(storage, isCar)
end

--[[
    Purpose:
        React when a player opens a storage inventory.

    When Called:
        Called from the storage netcall handler on the client when a player opens storage (including vehicle trunks).

    Parameters:
        - storage (Entity|Inventory): Storage entity or inventory instance being opened.
        - isCar (boolean): Whether the storage is a vehicle trunk.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StorageOpen", "MyAddon", function(storage, isCar)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StorageOpen", "MyAddon", function(storage, isCar)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StorageOpen", "MyAddon", function(storage, isCar)
        -- Add your code here
    end)
    ```
]]
function StorageRestored(ent, inventory)
end

--[[
    Purpose:
        React when a storage entity's inventory is restored from persistence.

    When Called:
        Called from the storage module after an inventory is loaded by ID and assigned to a storage entity during map load.

    Parameters:
        - ent (Entity): Storage entity that received the inventory.
        - inventory (Inventory): Inventory instance that was restored.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StorageRestored", "MyAddon", function(ent, inventory)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StorageRestored", "MyAddon", function(ent, inventory)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StorageRestored", "MyAddon", function(ent, inventory)
        -- Add your code here
    end)
    ```
]]
function StoreSpawns(spawns)
end

--[[
    Purpose:
        React when spawn points are stored to persistence.

    When Called:
        Called from the spawns module's `StoreSpawns` method after spawn data is saved. Note: This appears to be a module function, not a hook that is run.

    Parameters:
        - spawns (table): Table containing faction spawn data.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("StoreSpawns", "MyAddon", function(spawns)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("StoreSpawns", "MyAddon", function(spawns)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("StoreSpawns", "MyAddon", function(spawns)
        -- Add your code here
    end)
    ```
]]
function SyncCharList(client)
end

--[[
    Purpose:
        React when a player's character list is synchronized to the client.

    When Called:
        Called from the mainmenu module's `SyncCharList` method after the character list network message is sent. Note: This appears to be a module function, not a hook that is run.

    Parameters:
        - client (Player): Player whose character list was synchronized.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("SyncCharList", "MyAddon", function(client)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("SyncCharList", "MyAddon", function(client)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("SyncCharList", "MyAddon", function(client)
        -- Add your code here
    end)
    ```
]]
function TicketSystemClaim(client, requester, ticketMessage)
end

--[[
    Purpose:
        React when a staff member claims a ticket.

    When Called:
        Called from the ticket system netcall handler after a staff member successfully claims a ticket and before `OnTicketClaimed` fires.

    Parameters:
        - client (Player): Staff member who claimed the ticket.
        - requester (Player): Player who created the ticket.
        - ticketMessage (string): Original ticket message.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("TicketSystemClaim", "MyAddon", function(client, requester, ticketMessage)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("TicketSystemClaim", "MyAddon", function(client, requester, ticketMessage)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("TicketSystemClaim", "MyAddon", function(client, requester, ticketMessage)
        -- Add your code here
    end)
    ```
]]
function TicketSystemClose(client, requester, ticketMessage)
end

--[[
    Purpose:
        React when a ticket is closed by a staff member.

    When Called:
        Called from the ticket system netcall handler after a ticket is closed and before `OnTicketClosed` fires.

    Parameters:
        - client (Player): Staff member who closed the ticket.
        - requester (Player): Player who created the ticket.
        - ticketMessage (string): Original ticket message.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("TicketSystemClose", "MyAddon", function(client, requester, ticketMessage)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("TicketSystemClose", "MyAddon", function(client, requester, ticketMessage)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("TicketSystemClose", "MyAddon", function(client, requester, ticketMessage)
        -- Add your code here
    end)
    ```
]]
function TicketSystemCreated(noob, message)
end

--[[
    Purpose:
        React when a new ticket is created by a player.

    When Called:
        Called from the administration module's `SendPopup` function after the ticket popup is sent to staff and before `OnTicketCreated` fires.

    Parameters:
        - noob (Player): Player who created the ticket.
        - message (string): Ticket message content.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("TicketSystemCreated", "MyAddon", function(noob, message)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("TicketSystemCreated", "MyAddon", function(noob, message)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("TicketSystemCreated", "MyAddon", function(noob, message)
        -- Add your code here
    end)
    ```
]]
function ToggleLock(client, door, state)
end

--[[
    Purpose:
        React when a door or vehicle lock state is toggled.

    When Called:
        Called from the doors module's `ToggleLock` method after the lock state is changed. Note: This appears to be a module function, not a hook that is run. The actual hook that fires is `DoorLockToggled`.

    Parameters:
        - client (Player): Player who toggled the lock.
        - door (Entity): Door or vehicle entity.
        - state (boolean): New lock state (true = locked, false = unlocked).

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("ToggleLock", "MyAddon", function(client, door, state)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("ToggleLock", "MyAddon", function(client, door, state)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("ToggleLock", "MyAddon", function(client, door, state)
        -- Add your code here
    end)
    ```
]]
function TransferItem(itemID)
end

--[[
    Purpose:
        React when an item is transferred between inventories.

    When Called:
        Called from the storage module's `TransferItem` method on the client after an item transfer is initiated. Note: This appears to be a module function, not a hook that is run.

    Parameters:
        - itemID (number): Item ID being transferred.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("TransferItem", "MyAddon", function(itemID)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("TransferItem", "MyAddon", function(itemID)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("TransferItem", "MyAddon", function(itemID)
        -- Add your code here
    end)
    ```
]]
function UpdateEntityPersistence(ent)
end

--[[
    Purpose:
        Signal that an entity's persistence data should be updated.

    When Called:
        Called from vendor and storage modules when entity data changes and needs to be saved to the database.

    Parameters:
        - ent (Entity): Entity whose persistence data should be updated.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("UpdateEntityPersistence", "MyAddon", function(ent)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("UpdateEntityPersistence", "MyAddon", function(ent)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("UpdateEntityPersistence", "MyAddon", function(ent)
        -- Add your code here
    end)
    ```
]]
function VendorClassUpdated(vendor, id, allowed)
end

--[[
    Purpose:
        React when a vendor's class access is updated.

    When Called:
        Called from the vendor netcall handler on the client when a class is allowed or denied access to the vendor.

    Parameters:
        - vendor (Entity): Vendor entity being edited.
        - id (number): Class ID that was updated.
        - allowed (boolean): Whether the class is now allowed access.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorClassUpdated", "MyAddon", function(vendor, id, allowed)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorClassUpdated", "MyAddon", function(vendor, id, allowed)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorClassUpdated", "MyAddon", function(vendor, id, allowed)
        -- Add your code here
    end)
    ```
]]
function VendorEdited(liaVendorEnt, key)
end

--[[
    Purpose:
        React when a vendor property is edited.

    When Called:
        Called from the vendor netcall handler on the client when a vendor property is changed (name, description, etc).

    Parameters:
        - liaVendorEnt (Entity): Vendor entity being edited.
        - key (string): Property key that was modified.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorEdited", "MyAddon", function(liaVendorEnt, key)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorEdited", "MyAddon", function(liaVendorEnt, key)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorEdited", "MyAddon", function(liaVendorEnt, key)
        -- Add your code here
    end)
    ```
]]
function VendorFactionUpdated(vendor, id, allowed)
end

--[[
    Purpose:
        React when a vendor's faction access is updated.

    When Called:
        Called from the vendor netcall handler on the client when a faction is allowed or denied access to the vendor.

    Parameters:
        - vendor (Entity): Vendor entity being edited.
        - id (number): Faction ID that was updated.
        - allowed (boolean): Whether the faction is now allowed access.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorFactionUpdated", "MyAddon", function(vendor, id, allowed)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorFactionUpdated", "MyAddon", function(vendor, id, allowed)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorFactionUpdated", "MyAddon", function(vendor, id, allowed)
        -- Add your code here
    end)
    ```
]]
function VendorItemMaxStockUpdated(vendor, itemType, value)
end

--[[
    Purpose:
        React when a vendor item's maximum stock is updated.

    When Called:
        Called from the vendor netcall handler on the client when an item's maximum stock value is changed.

    Parameters:
        - vendor (Entity): Vendor entity being edited.
        - itemType (string): Item unique ID whose max stock was updated.
        - value (number|nil): New maximum stock value, or nil if unlimited.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorItemMaxStockUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorItemMaxStockUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorItemMaxStockUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```
]]
function VendorItemModeUpdated(vendor, itemType, value)
end

--[[
    Purpose:
        React when a vendor item's mode is updated.

    When Called:
        Called from the vendor netcall handler on the client when an item's vendor mode is changed (buy/sell/both).

    Parameters:
        - vendor (Entity): Vendor entity being edited.
        - itemType (string): Item unique ID whose mode was updated.
        - value (number|nil): New vendor mode value.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorItemModeUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorItemModeUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorItemModeUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```
]]
function VendorItemPriceUpdated(vendor, itemType, value)
end

--[[
    Purpose:
        React when a vendor item's price is updated.

    When Called:
        Called from the vendor netcall handler on the client when an item's price is changed.

    Parameters:
        - vendor (Entity): Vendor entity being edited.
        - itemType (string): Item unique ID whose price was updated.
        - value (number|nil): New price value, or nil for default.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorItemPriceUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorItemPriceUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorItemPriceUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```
]]
function VendorItemStockUpdated(vendor, itemType, value)
end

--[[
    Purpose:
        React when a vendor item's stock is updated.

    When Called:
        Called from the vendor netcall handler on the client when an item's stock count is changed.

    Parameters:
        - vendor (Entity): Vendor entity being edited.
        - itemType (string): Item unique ID whose stock was updated.
        - value (number): New stock value.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorItemStockUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorItemStockUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorItemStockUpdated", "MyAddon", function(vendor, itemType, value)
        -- Add your code here
    end)
    ```
]]
function VendorOpened(vendor)
end

--[[
    Purpose:
        React when a vendor menu is opened.

    When Called:
        Called from the vendor netcall handler on the client when a player opens a vendor's menu.

    Parameters:
        - vendor (Entity): Vendor entity that was opened.

    Returns:
        None

    Realm:
        Client

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorOpened", "MyAddon", function(vendor)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorOpened", "MyAddon", function(vendor)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorOpened", "MyAddon", function(vendor)
        -- Add your code here
    end)
    ```
]]
function VendorTradeEvent(client, vendor, itemType, isSellingToVendor)
end

--[[
    Purpose:
        React when a player initiates a trade with a vendor.

    When Called:
        Called from the vendor netcall handler on the server when a player attempts to buy or sell an item from/to a vendor, after access checks pass.

    Parameters:
        - client (Player): Player attempting the trade.
        - vendor (Entity): Vendor entity being traded with.
        - itemType (string): Item unique ID being traded.
        - isSellingToVendor (boolean): Whether the player is selling to the vendor (true) or buying (false).

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("VendorTradeEvent", "MyAddon", function(client, vendor, itemType, isSellingToVendor)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("VendorTradeEvent", "MyAddon", function(client, vendor, itemType, isSellingToVendor)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("VendorTradeEvent", "MyAddon", function(client, vendor, itemType, isSellingToVendor)
        -- Add your code here
    end)
    ```
]]
function WarningIssued(client, target, reason, count, warnerSteamID, warnerName)
end

--[[
    Purpose:
        React when a warning is issued to a player.

    When Called:
        Called from the warning command handlers after a warning is successfully added to the database.

    Parameters:
        - client (Player): Administrator who issued the warning.
        - target (Player): Player who received the warning.
        - reason (string): Warning reason message.
        - count (number): Total number of warnings the target now has.
        - warnerSteamID (string): Steam ID of the administrator who issued the warning.
        - targetSteamID (string): Steam ID of the player who received the warning.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("WarningIssued", "MyAddon", function(client, target, reason, count, warnerSteamID, warnerName)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("WarningIssued", "MyAddon", function(client, target, reason, count, warnerSteamID, warnerName)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("WarningIssued", "MyAddon", function(client, target, reason, count, warnerSteamID, warnerName)
        -- Add your code here
    end)
    ```
]]
function WarningRemoved(client, targetClient, reason, count, warnerSteamID, warnerName)
end

--[[
    Purpose:
        React when a warning is removed from a player's record.

    When Called:
        Called from the warning removal netcall handler after a warning is successfully deleted from the database.

    Parameters:
        - client (Player): Administrator who removed the warning.
        - targetClient (Player): Player whose warning was removed.
        - warnData (table): Table containing warning information (reason, admin, adminSteamID, targetSteamID).
        - warnIndex (number): Index of the warning that was removed.

    Returns:
        None

    Realm:
        Server

    Example Usage:

    Low Complexity:
    ```lua
    -- Simple: Basic usage
    hook.Add("WarningRemoved", "MyAddon", function(client, targetClient, reason, count, warnerSteamID, warnerName)
        -- Add your code here
    end)
    ```

    Medium Complexity:
    ```lua
    -- Medium: More complex usage
    hook.Add("WarningRemoved", "MyAddon", function(client, targetClient, reason, count, warnerSteamID, warnerName)
        -- Add your code here
    end)
    ```

    High Complexity:
    ```lua
    -- High: Advanced usage
    hook.Add("WarningRemoved", "MyAddon", function(client, targetClient, reason, count, warnerSteamID, warnerName)
        -- Add your code here
    end)
    ```
]]
function setData(value, global, ignoreMap)
end