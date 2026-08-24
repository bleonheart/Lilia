--[[
    Hooks:
        CanDeleteChar(client, character)

    Purpose:
        Determines whether a character can be deleted from the character menu.

    Category:
        Protection

    Parameters:
        client (Player)
            The local player attempting to delete the character.

        character (table|Character)
            The target character data being evaluated for deletion.

    Example Usage:
        ```lua
        hook.Add("CanDeleteChar", "liaExampleCanDeleteChar", function(client, character)
            if IsValid(client) and client:IsAdmin() then
                return true
            end
        end)
        ```

    Returns:
        boolean|nil
            Return false to block deletion.

    Realm:
        Client
]]
--[[
    Hooks:
        CanPlayerSwitchChar(client, character, newCharacter)

    Purpose:
        Determines whether a player may switch away from their current character to another one.

    Category:
        Protection

    Parameters:
        client (Player)
            The player attempting the character switch.

        character (Character)
            The player's current character.

        newCharacter (Character)
            The character the player wants to switch to.

    Example Usage:
        ```lua
        hook.Add("CanPlayerSwitchChar", "liaExampleCanPlayerSwitchChar", function(client, character, newCharacter)
            if character == newCharacter then
                return false, "You are already using that character."
            end
        end)
        ```

    Returns:
        boolean, string|nil
            Return false and an optional denial message to block the switch.

    Realm:
        Shared
]]
MODULE.name = "@protection"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "@anticheatDescription"
MODULE.Privileges = {
    ["canSeeAltingNotifications"] = {
        Name = "@canSeeAltingNotifications",
        MinAccess = "admin",
        Category = "@exploiting",
    },
}