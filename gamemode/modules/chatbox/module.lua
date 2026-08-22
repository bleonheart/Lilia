--[[
    Hooks:
        CanManageFilteredWords(client)

    Purpose:
        Determines whether a player is allowed to manage the chat filter word list.

    Category:
        Chatbox

    Parameters:
        client (Player)
            The player whose chat filter management permission should be checked.

    Example Usage:
        ```lua
        hook.Add("CanManageFilteredWords", "liaExampleCanManageFilteredWords", function(client)
            return true
        end)
        ```

    Returns:
        boolean
            True if the player has the manageChatFilter privilege.

    Realm:
        Server
]]
--[[
    Hooks:
        ChatboxTextAdded(...)

    Purpose:
        Called on the client after a new chat line is added to the chatbox.

    Category:
        Chatbox

    Parameters:
        ... (vararg)
            The formatted chatbox text arguments that were added.

    Example Usage:
        ```lua
        hook.Add("ChatboxTextAdded", "liaExampleChatboxTextAdded", function()
            print("[MyModule] handled ChatboxTextAdded")
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        GetOOCDelay(speaker)

    Purpose:
        Allows code to override the out-of-character chat cooldown for a player.

    Category:
        Chatbox

    Parameters:
        speaker (Player)
            The player attempting to send an OOC message.

    Example Usage:
        ```lua
        hook.Add("GetOOCDelay", "liaExampleGetOOCDelay", function(speaker)
            return 15
        end)
        ```

    Returns:
        number|nil
            Return a replacement OOC delay in seconds.

    Realm:
        Shared
]]
--[[
    Hooks:
        AddFilteredWord(word)

    Purpose:
        Adds a normalized word to the chat filter list when it is not already present.

    Category:
        Chatbox

    Parameters:
        word (string)
            The word to normalize and add to the stored filter list.

    Example Usage:
        ```lua
        hook.Add("AddFilteredWord", "liaExampleAddFilteredWord", function(word)
            local normalized = string.Trim(string.lower(word))
            if normalized == "" then return false, "invalidWord" end
            return true, normalized
        end)
        ```

    Returns:
        boolean, string
            Returns whether the add succeeded and either the normalized word or an error tag.

    Realm:
        Server
]]
--[[
    Hooks:
        GetFilteredWords()

    Purpose:
        Returns the normalized chat filter word list currently used by the module.

    Category:
        Chatbox

    Parameters:
        None

    Example Usage:
        ```lua
        hook.Add("GetFilteredWords", "liaExampleGetFilteredWords", function()
            return {
                {name = "Example", value = 1}
            }
        end)
        ```

    Returns:
        table
            The sequential list of filtered words.

    Realm:
        Server
]]
--[[
    Hooks:
        RemoveFilteredWord(word)

    Purpose:
        Removes a normalized word from the chat filter list when it exists.

    Category:
        Chatbox

    Parameters:
        word (string)
            The word to normalize and remove from the stored filter list.

    Example Usage:
        ```lua
        hook.Add("RemoveFilteredWord", "liaExampleRemoveFilteredWord", function(word)
            local normalized = string.Trim(string.lower(word))
            if normalized == "" then return false, "invalidWord" end
            return true, normalized
        end)
        ```

    Returns:
        boolean, string
            Returns whether the removal succeeded and either the normalized word or an error tag.

    Realm:
        Server
]]
--[[
    Hooks:
        SyncFilteredWords(targets)

    Purpose:
        Sends the current filtered-word list to one player, a list of players, or every eligible manager.

    Category:
        Chatbox

    Parameters:
        targets (Player|table|nil)
            An optional recipient player, recipient list, or `nil` to broadcast to all eligible recipients.

    Example Usage:
        ```lua
        hook.Add("SyncFilteredWords", "liaExampleSyncFilteredWords", function(targets)
            print("[MyModule] handled SyncFilteredWords")
        end)
        ```

    Returns:
        nil

    Realm:
        Server
]]
MODULE.name = "@chatboxModuleName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "@chatSystemDescription"
MODULE.NetworkStrings = {"liaChatboxAddFilteredWord", "liaChatboxRemoveFilteredWord", "liaChatboxRequestFilteredWords", "liaChatboxSyncFilteredWords"}
MODULE.Privileges = {
    ["noOOCCooldown"] = {
        Name = "@noOOCCooldown",
        MinAccess = "admin",
        Category = "@categoryChat",
    },
    ["adminChat"] = {
        Name = "@adminChat",
        MinAccess = "superadmin",
        Category = "@categoryChat",
    },
    ["localEventChat"] = {
        Name = "@localEventChat",
        MinAccess = "admin",
        Category = "@categoryChat",
    },
    ["eventChat"] = {
        Name = "@eventChat",
        MinAccess = "admin",
        Category = "@categoryChat",
    },
    ["accessHelpChat"] = {
        Name = "@accessHelpChat",
        MinAccess = "superadmin",
        Category = "@categoryChat",
    },
    ["bypassOOCBlock"] = {
        Name = "@bypassOOCBlockPrivilege",
        MinAccess = "superadmin",
        Category = "@categoryChat",
    },
    ["manageChatFilter"] = {
        Name = "@manageChatFilter",
        MinAccess = "superadmin",
        Category = "@categoryChat",
    },
}
