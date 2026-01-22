lia.attribs = lia.attribs or {}
lia.attribs.list = lia.attribs.list or {}
--[[
    Purpose:
        Applies kick or ban punishments to a player based on the provided parameters.

    When Called:
        Called when an automated system or admin action needs to punish a player with a kick or ban.

    Parameters:
        client (Player)
            The player to punish.
        infraction (string)
            Description of the infraction that caused the punishment.
        kick (boolean)
            Whether to kick the player.
        ban (boolean)
            Whether to ban the player.
        time (number)
            Ban duration in minutes (only used if ban is true).
        kickKey (string)
            Localization key for kick message (defaults to "kickedForInfraction").
        banKey (string)
            Localization key for ban message (defaults to "bannedForInfraction").

    Returns:
        nil

    Realm:
        Client

    Example Usage:
        ```lua
        -- Kick a player for spamming
        lia.admin.applyPunishment(player, "Spamming in chat", true, false, nil, nil, nil)

        -- Ban a player for griefing for 24 hours
        lia.admin.applyPunishment(player, "Griefing", false, true, 1440, nil, nil)

        -- Both kick and ban with custom messages
        lia.admin.applyPunishment(player, "Hacking", true, true, 10080, "kickedForHacking", "bannedForHacking")
        ```
]]
function lia.attribs.loadFromDir(directory)
    for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
        local niceName = v:sub(1, 3) == "sh_" and v:sub(4, -5):lower() or v:sub(1, -5)
        ATTRIBUTE = lia.attribs.list[niceName] or {}
        lia.loader.include(directory .. "/" .. v, "shared")
        lia.attribs.register(niceName, ATTRIBUTE)
        ATTRIBUTE = nil
    end
end

--[[
    Purpose:
        Applies kick or ban punishments to a player based on the provided parameters.

    When Called:
        Called when an automated system or admin action needs to punish a player with a kick or ban.

    Parameters:
        client (Player)
            The player to punish.
        infraction (string)
            Description of the infraction that caused the punishment.
        kick (boolean)
            Whether to kick the player.
        ban (boolean)
            Whether to ban the player.
        time (number)
            Ban duration in minutes (only used if ban is true).
        kickKey (string)
            Localization key for kick message (defaults to "kickedForInfraction").
        banKey (string)
            Localization key for ban message (defaults to "bannedForInfraction").

    Returns:
        nil

    Realm:
        Server

    Example Usage:
        ```lua
        -- Kick a player for spamming
        lia.admin.applyPunishment(player, "Spamming in chat", true, false, nil, nil, nil)

        -- Ban a player for griefing for 24 hours
        lia.admin.applyPunishment(player, "Griefing", false, true, 1440, nil, nil)

        -- Both kick and ban with custom messages
        lia.admin.applyPunishment(player, "Hacking", true, true, 10080, "kickedForHacking", "bannedForHacking")
        ```
]]
function lia.attribs.register(uniqueID, data)
    assert(isstring(uniqueID), "uniqueID must be a string")
    assert(istable(data), "data must be a table")
    local attribute = lia.attribs.list[uniqueID] or {}
    for k, v in pairs(data) do
        attribute[k] = v
    end

    attribute.uniqueID = uniqueID
    attribute.name = attribute.name and L(attribute.name) or L("unknown")
    attribute.desc = attribute.desc and L(attribute.desc) or L("noDesc")
    lia.attribs.list[uniqueID] = attribute
    return attribute
end

if SERVER then
    --[[
    Purpose:
        Applies kick or ban punishments to a player based on the provided parameters.

    When Called:
        Called when an automated system or admin action needs to punish a player with a kick or ban.

    Parameters:
        client (Player)
            The player to punish.
        infraction (string)
            Description of the infraction that caused the punishment.
        kick (boolean)
            Whether to kick the player.
        ban (boolean)
            Whether to ban the player.
        time (number)
            Ban duration in minutes (only used if ban is true).
        kickKey (string)
            Localization key for kick message (defaults to "kickedForInfraction").
        banKey (string)
            Localization key for ban message (defaults to "bannedForInfraction").

    Returns:
        nil

    Realm:
        Shared

    Example Usage:
        ```lua
        -- Kick a player for spamming
        lia.admin.applyPunishment(player, "Spamming in chat", true, false, nil, nil, nil)

        -- Ban a player for griefing for 24 hours
        lia.admin.applyPunishment(player, "Griefing", false, true, 1440, nil, nil)

        -- Both kick and ban with custom messages
        lia.admin.applyPunishment(player, "Hacking", true, true, 10080, "kickedForHacking", "bannedForHacking")
        ```
]]
    function lia.attribs.setup(client)
        local character = client:getChar()
        if not character then return end
        for attribID, attribData in pairs(lia.attribs.list) do
            local value = character:getAttrib(attribID, 0)
            if attribData.OnSetup then attribData:OnSetup(client, value) end
        end
    end
end