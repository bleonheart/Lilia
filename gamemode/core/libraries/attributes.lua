--[[
    Attributes Library

    Character attribute management system for the Lilia framework.
]]
--[[
    Overview:
        The attributes library provides functionality for managing character attributes in the Lilia framework. It handles loading attribute definitions from files, registering attributes in the system, and setting up attributes for characters during spawn. The library operates on both server and client sides, with the server managing attribute setup during character spawning and the client handling attribute-related UI elements. It includes automatic attribute loading from directories, localization support for attribute names and descriptions, and hooks for custom attribute behavior.
]]
lia.attribs = lia.attribs or {}
lia.attribs.list = lia.attribs.list or {}
--[[
    Purpose:
        Loads all attribute definition files from a specified directory, processes them to extract attribute information, localizes display names and descriptions, and registers them in the global attribute system.

    When Called:
        During framework initialization to load attribute definitions.
        When reloading or refreshing attribute definitions during development or schema changes.

    Parameters:
        - directory (string): The path to the directory containing attribute definition files (relative to the Lua search paths).

    Returns:
        None.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Load attributes from the default directory
        lia.attribs.loadFromDir("attributes")
        ```

        Medium Complexity:

        ```lua
        -- Load attributes from a custom folder in a schema or plugin
        lia.attribs.loadFromDir("schema/customattribs")
        print("Custom attributes loaded:", table.Count(lia.attribs.list))
        ```

        High Complexity:

        ```lua
        -- Dynamically reload attributes for debugging
        concommand.Add("lia_reload_attributes", function()
            lia.attribs.loadFromDir("attributes")
            print("Attributes have been reloaded.")
        end)
        ```
]]
function lia.attribs.loadFromDir(directory)
    for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
        local niceName
        if v:sub(1, 3) == "sh_" then
            niceName = v:sub(4, -5):lower()
        else
            niceName = v:sub(1, -5)
        end

        ATTRIBUTE = lia.attribs.list[niceName] or {}
        lia.loader.include(directory .. "/" .. v, "shared")
        ATTRIBUTE.name = ATTRIBUTE.name and L(ATTRIBUTE.name) or L("unknown")
        ATTRIBUTE.desc = ATTRIBUTE.desc and L(ATTRIBUTE.desc) or L("noDesc")
        lia.attribs.list[niceName] = ATTRIBUTE
        ATTRIBUTE = nil
    end
end

--[[
    Purpose:
        Initializes all registered attributes for a player's character by retrieving their current attribute values and calling any custom OnSetup functions defined in the attribute definitions.

    When Called:
        During character loading and spawning (typically in PostPlayerLoadout hook).
        When attribute data needs to be refreshed or re-initialized.
        During character or class changes that may affect attribute setup.

    Parameters:
        - client (Player): The player entity whose character's attributes should be set up.

    Returns:
        None.

    Realm:
        Server.

    Example Usage:

        Low Complexity:

        ```lua
        -- On player spawn, set up attributes
        hook.Add("PlayerSpawn", "SetupAttributesOnSpawn", function(ply)
            lia.attribs.setup(ply)
        end)
        ```

        Medium Complexity:

        ```lua
        -- Explicitly set up for a player after character loading
        net.Receive("MyCustomAttribSetup", function(len, ply)
            lia.attribs.setup(ply)
        end)
        ```

        High Complexity:

        ```lua
        -- Use as part of a system that batches attribute setup for all players after a schema reload
        for _, ply in ipairs(player.GetAll()) do
            lia.attribs.setup(ply)
        end
        ```
]]
if SERVER then
    function lia.attribs.setup(client)
        local character = client:getChar()
        if not character then return end
        for attribID, attribData in pairs(lia.attribs.list) do
            local value = character:getAttrib(attribID, 0)
            if attribData.OnSetup then attribData:OnSetup(client, value) end
        end
    end
end