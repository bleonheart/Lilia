local vectorMeta = FindMetaTable("Vector")
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
function vectorMeta:Center(vec2)
    return (self + vec2) / 2
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
function vectorMeta:Distance(vec2)
    local x, y, z = self.x, self.y, self.z
    local x2, y2, z2 = vec2.x, vec2.y, vec2.z
    return math.sqrt((x - x2) ^ 2 + (y - y2) ^ 2 + (z - z2) ^ 2)
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
function vectorMeta:RotateAroundAxis(axis, degrees)
    local rad = math.rad(degrees)
    local cosTheta = math.cos(rad)
    local sinTheta = math.sin(rad)
    return Vector(cosTheta * self.x + sinTheta * (axis.y * self.z - axis.z * self.y), cosTheta * self.y + sinTheta * (axis.z * self.x - axis.x * self.z), cosTheta * self.z + sinTheta * (axis.x * self.y - axis.y * self.x))
end

local right = Vector(0, -1, 0)
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
function vectorMeta:Right(vUp)
    if self[1] == 0 and self[2] == 0 then return right end
    if not vUp then vUp = vector_up end
    local vRet = self:Cross(self, vUp)
    vRet:Normalize()
    return vRet
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
function vectorMeta:Up(vUp)
    if self[1] == 0 and self[2] == 0 then return Vector(-self[3], 0, 0) end
    if not vUp then vUp = vector_up end
    local vRet = self:Cross(self, vUp)
    vRet = self:Cross(vRet, self)
    vRet:Normalize()
    return vRet
end