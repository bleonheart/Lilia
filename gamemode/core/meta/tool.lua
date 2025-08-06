local toolGunMeta = lia.meta.tool or {}
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
function toolGunMeta:Create()
    local object = {}
    setmetatable(object, self)
    self.__index = self
    object.Mode = nil
    object.SWEP = nil
    object.Owner = nil
    object.ClientConVar = {}
    object.ServerConVar = {}
    object.Objects = {}
    object.Stage = 0
    object.Message = L("start")
    object.LastMessage = 0
    object.AllowedCVar = 0
    return object
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
function toolGunMeta:CreateConVars()
    local mode = self:GetMode()
    if CLIENT then
        for cvar, default in pairs(self.ClientConVar) do
            CreateClientConVar(mode .. "_" .. cvar, default, true, true)
        end
        return
    else
        self.AllowedCVar = CreateConVar("toolmode_allow_" .. mode, 1, FCVAR_NOTIFY)
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
function toolGunMeta:UpdateData()
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
function toolGunMeta:FreezeMovement()
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
function toolGunMeta:DrawHUD()
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
function toolGunMeta:GetServerInfo(property)
    local mode = self:GetMode()
    return ConVar(mode .. "_" .. property)
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
function toolGunMeta:BuildConVarList()
    local mode = self:GetMode()
    local convars = {}
    for k, v in pairs(self.ClientConVar) do
        convars[mode .. "_" .. k] = v
    end
    return convars
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
function toolGunMeta:GetClientInfo(property)
    return self:GetOwner():GetInfo(self:GetMode() .. "_" .. property)
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
function toolGunMeta:GetClientNumber(property, default)
    return self:GetOwner():GetInfoNum(self:GetMode() .. "_" .. property, tonumber(default) or 0)
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
function toolGunMeta:Allowed()
    if CLIENT then return true end
    return self.AllowedCVar:GetBool()
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
function toolGunMeta:Init()
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
function toolGunMeta:GetMode()
    return self.Mode
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
function toolGunMeta:GetSWEP()
    return self.SWEP
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
function toolGunMeta:GetOwner()
    return self:GetSWEP().Owner or self:GetOwner()
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
function toolGunMeta:GetWeapon()
    return self:GetSWEP().Weapon or self.Weapon
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
function toolGunMeta:LeftClick()
    return false
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
function toolGunMeta:RightClick()
    return false
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
function toolGunMeta:Reload()
    self:ClearObjects()
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
function toolGunMeta:Deploy()
    self:ReleaseGhostEntity()
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
function toolGunMeta:Holster()
    self:ReleaseGhostEntity()
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
function toolGunMeta:Think()
    self:ReleaseGhostEntity()
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
function toolGunMeta:CheckObjects()
    for _, v in pairs(self.Objects) do
        if not v.Ent:IsWorld() and not IsValid(v.Ent) then self:ClearObjects() end
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
function toolGunMeta:ClearObjects()
    self.Objects = {}
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
function toolGunMeta:ReleaseGhostEntity()
    if IsValid(self.GhostEntity) then
        SafeRemoveEntity(self.GhostEntity)
        self.GhostEntity = nil
    end
end

lia.meta.tool = toolGunMeta