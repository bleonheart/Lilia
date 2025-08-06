local ITEM = lia.meta.item or {}
debug.getregistry().Item = lia.meta.item
ITEM.__index = ITEM
ITEM.name = "invalidName"
ITEM.desc = ITEM.desc or "invalidDescription"
ITEM.id = ITEM.id or 0
ITEM.uniqueID = "undefined"
ITEM.isItem = true
ITEM.isStackable = false
ITEM.quantity = 1
ITEM.maxQuantity = 1
ITEM.canSplit = true
--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:isRotated()
    return self:getData("rotated", false)
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getWidth()
    return self:isRotated() and (self.height or 1) or self.width or 1
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getHeight()
    return self:isRotated() and (self.width or 1) or self.height or 1
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getQuantity()
    if self.id == 0 then return self.maxQuantity end
    return self.quantity
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:eq(other)
    return self:getID() == other:getID()
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:tostring()
    return L("item") .. "[" .. self.uniqueID .. "][" .. self.id .. "]"
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getID()
    return self.id
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getModel()
    return self.model
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getSkin()
    return self.skin
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getPrice()
    local price = self.price
    if self.calcPrice then price = self:calcPrice(self.price) end
    return price or 0
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:call(method, client, entity, ...)
    local oldPlayer, oldEntity = self.player, self.entity
    self.player = client or self.player
    self.entity = entity or self.entity
    if isfunction(self[method]) then
        local results = {self[method](self, ...)}
        self.player = oldPlayer
        self.entity = oldEntity
        hook.Run("ItemFunctionCalled", self, method, client, entity, results)
        return unpack(results)
    end

    self.player = oldPlayer
    self.entity = oldEntity
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getOwner()
    local inventory = lia.inventory.instances[self.invID]
    if inventory and SERVER then return inventory:getRecipients()[1] end
    local id = self:getID()
    for _, v in player.Iterator() do
        local character = v:getChar()
        if character and character:getInv() and character:getInv().items[id] then return v end
    end
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getData(key, default)
    self.data = self.data or {}
    local value = self.data[key]
    if value ~= nil then return value end
    if IsValid(self.entity) then
        local data = self.entity:getNetVar("data", {})
        value = data[key]
        if value ~= nil then return value end
    end
    return default
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getAllData()
    self.data = self.data or {}
    local fullData = table.Copy(self.data)
    if IsValid(self.entity) then
        local entityData = self.entity:getNetVar("data", {})
        for key, value in pairs(entityData) do
            fullData[key] = value
        end
    end
    return fullData
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:hook(name, func)
    if name then self.hooks[name] = func end
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:postHook(name, func)
    if name then self.postHooks[name] = func end
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:onRegistered()
    if self.model and isstring(self.model) then util.PrecacheModel(self.model) end
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:print(detail)
    if detail then
        print(Format("%s[%s]: >> [%s](%s,%s)", self.uniqueID, self.id, self.owner, self.gridX, self.gridY))
    else
        print(Format("%s[%s]", self.uniqueID, self.id))
    end
end

--[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:printData()
    self:print(true)
    lia.information(L("itemData") .. ":")
    for k, v in pairs(self.data) do
        lia.information(L("itemDataEntry", k, v))
    end
end

if SERVER then
    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getName()
        return self.name
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getDesc()
        return self.desc
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:removeFromInventory(preserveItem)
        local inventory = lia.inventory.instances[self.invID]
        self.invID = 0
        if inventory then return inventory:removeItem(self:getID(), preserveItem) end
        local d = deferred.new()
        d:resolve()
        return d
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:delete()
        self:destroy()
        return lia.db.delete("items", "_itemID = " .. self:getID()):next(function() self:onRemoved() end)
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:remove()
        local d = deferred.new()
        if IsValid(self.entity) then SafeRemoveEntity(self.entity) end
        self:removeFromInventory():next(function()
            d:resolve()
            return self:delete()
        end)
        return d
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:destroy()
        net.Start("liaItemDelete")
        net.WriteUInt(self:getID(), 32)
        net.Broadcast()
        lia.item.instances[self:getID()] = nil
        self:onDisposed()
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:onDisposed()
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getEntity()
        local id = self:getID()
        for _, v in ipairs(ents.FindByClass("lia_item")) do
            if v.liaItemID == id then return v end
        end
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:spawn(position, angles)
        local instance = lia.item.instances[self.id]
        if instance then
            if IsValid(instance.entity) then
                instance.entity.liaIsSafe = true
                SafeRemoveEntity(instance.entity)
            end

            local client
            if isentity(position) and position:IsPlayer() then
                client = position
                position = position:getItemDropPos()
            end

            position = lia.data.decode(position)
            if not isvector(position) and istable(position) then
                local x = tonumber(position.x or position[1])
                local y = tonumber(position.y or position[2])
                local z = tonumber(position.z or position[3])
                if x and y and z then position = Vector(x, y, z) end
            end

            if angles then
                angles = lia.data.decode(angles)
                if not isangle(angles) then
                    if isvector(angles) then
                        angles = Angle(angles.x, angles.y, angles.z)
                    elseif istable(angles) then
                        local p = tonumber(angles.p or angles[1])
                        local yaw = tonumber(angles.y or angles[2])
                        local r = tonumber(angles.r or angles[3])
                        if p and yaw and r then angles = Angle(p, yaw, r) end
                    end
                end
            end

            local entity = ents.Create("lia_item")
            entity:Spawn()
            entity:SetPos(position)
            entity:SetAngles(angles or angle_zero)
            entity:setItem(self.id)
            instance.entity = entity
            if IsValid(client) then
                entity.SteamID = client:SteamID()
                entity.liaCharID = client:getChar():getID()
                entity:SetCreator(client)
            end
            return entity
        end
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:transfer(newInventory, bBypass)
        if not bBypass and not newInventory:canAccess("transfer") then return false end
        local inventory = lia.inventory.instances[self.invID]
        inventory:removeItem(self.id, true):next(function() newInventory:add(self) end)
        return true
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:onInstanced()
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:onSync()
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:onRemoved()
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:onRestored()
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:sync(recipient)
        net.Start("liaItemInstance")
        net.WriteUInt(self:getID(), 32)
        net.WriteString(self.uniqueID)
        net.WriteTable(self.data)
        net.WriteType(self.invID)
        net.WriteUInt(self.quantity, 32)
        if recipient == nil then
            net.Broadcast()
        else
            net.Send(recipient)
        end

        self:onSync(recipient)
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:setData(key, value, receivers, noSave, noCheckEntity)
        self.data = self.data or {}
        self.data[key] = value
        if not noCheckEntity then
            local entity = self:getEntity()
            if IsValid(entity) then entity:setNetVar("data", self.data) end
        end

        if receivers or self:getOwner() then
            net.Start("invData")
            net.WriteUInt(self:getID(), 32)
            net.WriteString(key)
            net.WriteType(value)
            if receivers then
                net.Send(receivers)
            else
                net.Send(self:getOwner())
            end
        end

        if noSave or not lia.db then return end
        if key == "x" or key == "y" then
            value = tonumber(value)
            if MYSQLOO_PREPARED then
                lia.db.preparedCall("item" .. key, nil, value, self:getID())
            else
                lia.db.updateTable({
                    [key] = value
                }, nil, "items", "_itemID = " .. self:getID())
            end
            return
        end

        local x, y = self.data.x, self.data.y
        self.data.x, self.data.y = nil, nil
        if MYSQLOO_PREPARED then
            lia.db.preparedCall("itemData", nil, self.data, self:getID())
        else
            lia.db.updateTable({
                data = self.data
            }, nil, "items", "_itemID = " .. self:getID())
        end

        self.data.x, self.data.y = x, y
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:addQuantity(quantity, receivers, noCheckEntity)
        self:setQuantity(self:getQuantity() + quantity, receivers, noCheckEntity)
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:setQuantity(quantity, receivers, noCheckEntity)
        self.quantity = quantity
        if not noCheckEntity then
            local entity = self:getEntity()
            if IsValid(entity) then entity:setNetVar("quantity", self.quantity) end
        end

        if receivers or self:getOwner() then
            net.Start("invQuantity")
            net.WriteUInt(self:getID(), 32)
            net.WriteUInt(self.quantity, 32)
            if receivers then
                net.Send(receivers)
            else
                net.Send(self:getOwner())
            end
        end

        if noSave or not lia.db then return end
        if MYSQLOO_PREPARED then
            lia.db.preparedCall("itemq", nil, self.quantity, self:getID())
        else
            lia.db.updateTable({
                quantity = self.quantity
            }, nil, "items", "_itemID = " .. self:getID())
        end
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:interact(action, client, entity, data)
        assert(client:IsPlayer() and IsValid(client), L("itemActionNoPlayer"))
        local canInteract, reason = hook.Run("CanPlayerInteractItem", client, action, self, data)
        if canInteract == false then
            if reason then client:notifyLocalized(reason) end
            return false
        end

        local oldPlayer, oldEntity = self.player, self.entity
        self.player = client
        self.entity = entity
        local callback = self.functions[action]
        if not callback then
            self.player = oldPlayer
            self.entity = oldEntity
            return false
        end

        if isfunction(callback.onCanRun) then
            canInteract = callback.onCanRun(self, data)
        else
            canInteract = true
        end

        if not canInteract then
            self.player = oldPlayer
            self.entity = oldEntity
            return false
        end

        hook.Run("PrePlayerInteractItem", client, action, self)
        local result
        if isfunction(self.hooks[action]) then result = self.hooks[action](self, data) end
        if result == nil and isfunction(callback.onRun) then result = callback.onRun(self, data) end
        if self.postHooks[action] then self.postHooks[action](self, result, data) end
        hook.Run("OnPlayerInteractItem", client, action, self, result, data)
        if result ~= false and not deferred.isPromise(result) then
            if IsValid(entity) then
                SafeRemoveEntity(entity)
            else
                self:remove()
            end
        end

        self.player = oldPlayer
        self.entity = oldEntity
        return true
    end
else
    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getName()
        return self.name
    end

    --[[
    getDisplayedName

    Purpose:
        Returns the name to display for this character to the given client, taking into account recognition and fake names.
        If character recognition is enabled, the function checks if the client recognizes this character, and returns the appropriate name.
        If not recognized, it may return a fake name if one is set and recognized, otherwise returns "unknown".
        If recognition is disabled, always returns the character's real name.

    Parameters:
        client (Player) - The player to check recognition against.

    Returns:
        string - The name to display for this character to the given client.

    Realm:
        Shared.

    Example Usage:
        -- Get the display name for a character as seen by a client
        local displayName = character:getDisplayedName(client)
        print("You see this character as: " .. displayName)
]]
function ITEM:getDesc()
        return self.desc
    end
end

lia.meta.item = ITEM
