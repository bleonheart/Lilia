--[[
    Hooks:
        CanCharBeTransfered(character, targetValue, previousValue)

    Purpose:
        Determines whether a character may be transferred to a different faction or class.

    Category:
        Teams

    Parameters:
        character (Character)
            The character being transferred.

        targetValue (number|string)
            The destination faction or class identifier.

        previousValue (number|string)
            The character's current faction or class identifier.

    Example Usage:
        ```lua
        hook.Add("CanCharBeTransfered", "liaExampleCanCharBeTransfered", function(character, targetValue, previousValue)
            return true
        end)
        ```

    Returns:
        boolean|nil
            Return false to block the transfer.

    Realm:
        Server
]]
--[[
    Hooks:
        CanInviteToClass(client, target)

    Purpose:
        Determines whether a player may invite another player to a class.

    Category:
        Teams

    Parameters:
        client (Player)
            The player sending the invite.

        target (Player)
            The player being invited.

    Example Usage:
        ```lua
        hook.Add("CanInviteToClass", "liaExampleCanInviteToClass", function(client, target)
            if IsValid(client) and client:IsAdmin() then
                return true
            end
        end)
        ```

    Returns:
        boolean|nil
            Return false to block the class invitation.

    Realm:
        Server
]]
--[[
    Hooks:
        CanInviteToFaction(client, target)

    Purpose:
        Determines whether a player may invite another player to a faction.

    Category:
        Teams

    Parameters:
        client (Player)
            The player sending the invite.

        target (Player)
            The player being invited.

    Example Usage:
        ```lua
        hook.Add("CanInviteToFaction", "liaExampleCanInviteToFaction", function(client, target)
            if IsValid(client) and client:IsAdmin() then
                return true
            end
        end)
        ```

    Returns:
        boolean|nil
            Return false to block the faction invitation.

    Realm:
        Server
]]
--[[
    Hooks:
        CheckFactionLimitReached(faction, character, client)

    Purpose:
        Allows code to override faction population limit checks.

    Category:
        Teams

    Parameters:
        faction (number|string)
            The faction being checked.

        character (Character)
            The character being evaluated for the faction.

        client (Player)
            The player associated with the character.

    Example Usage:
        ```lua
        hook.Add("CheckFactionLimitReached", "liaExampleCheckFactionLimitReached", function(faction, character, client)
            if IsValid(client) and client:IsAdmin() then
                return true
            end
        end)
        ```

    Returns:
        boolean|nil
            Return true when the faction should be treated as full.

    Realm:
        Server
]]
--[[
    Hooks:
        PopulateFactionRosterOptions(list, members)

    Purpose:
        Allows clientside code to add extra options to the faction roster UI.

    Category:
        Teams

    Parameters:
        list (table)
            The mutable list of roster option entries.

        members (table)
            The current roster member data.

    Example Usage:
        ```lua
        hook.Add("PopulateFactionRosterOptions", "liaExamplePopulateFactionRosterOptions", function(list, members)
            if not IsValid(list) then return end
            list:SetTooltip("PopulateFactionRosterOptions handled by MyModule")
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
MODULE.name = "@teamsModuleName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "@teamsSystemDescription"
MODULE.NetworkStrings = {"liaFactionMembers", "liaFactionMemberDetails", "liaKickCharacterToBase", "liaRequestFactionMembers", "liaRequestFactionMemberDetails", "liaSaveFactionNote"}
MODULE.Privileges = {
    ["canManageFactions"] = {
        Name = "@canManageFactions",
        MinAccess = "admin",
        Category = "@factionManagement",
    },
    ["manageWhitelists"] = {
        Name = "@manageWhitelists",
        MinAccess = "admin",
        Category = "@factionManagement",
    },
}
