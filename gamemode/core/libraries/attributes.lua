--[[
    Folder: Libraries
    File: attribs.md
]]
--[[
    Attributes

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
        Discover and include attribute definitions from a directory.

    When Called:
        During schema/gamemode startup to load all attribute files.

    Parameters:
        directory (string)
            Path containing attribute Lua files.
    Realm:
        Shared

    Example Usage:
        ```lua
            -- Load default and custom attributes.
            lia.attribs.loadFromDir(lia.plugin.getDir() .. "/attribs")
            lia.attribs.loadFromDir("schema/attribs")
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
        Register or update an attribute definition in the global list.

    When Called:
        After loading an attribute file or when hot-reloading attributes.

    Parameters:
        uniqueID (string)
            Attribute key.
        data (table)
            Fields like name, desc, OnSetup, setup, etc.

    Returns:
        table
            The stored attribute table.

    Realm:
        Shared

    Example Usage:
        ```lua
            lia.attribs.register("strength", {
                name = "Strength",
                desc = "Improves melee damage and carry weight.",
                OnSetup = function(client, value)
                    client:SetJumpPower(160 + value * 0.5)
                end
            })
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

lia.attribs.register("str", {
    name = "Strength",
    desc = "Physical power. Improves melee and carry capability.",
    min = 0,
    max = 100
})

lia.attribs.register("end", {
    name = "Endurance",
    desc = "Stamina and resilience.",
    min = 0,
    max = 100
})

lia.attribs.register("stm", {
    name = "Stamina",
    desc = "How long you can sprint before tiring.",
    min = 0,
    max = 100
})

lia.attribs.register("agi", {
    name = "Agility",
    desc = "Movement control and dexterity.",
    min = 0,
    max = 100
})

lia.attribs.register("int", {
    name = "Intelligence",
    desc = "Problem-solving and learning speed.",
    min = 0,
    max = 100
})

lia.attribs.register("per", {
    name = "Perception",
    desc = "Awareness and detection.",
    min = 0,
    max = 100
})

lia.attribs.register("cha", {
    name = "Charisma",
    desc = "Social influence and presence.",
    min = 0,
    max = 100
})

lia.attribs.register("lck", {
    name = "Luck",
    desc = "Good fortune in uncertain outcomes.",
    min = 0,
    max = 100
})

lia.attribs.register("med", {
    name = "Medical",
    desc = "Treating wounds and using medical supplies.",
    min = 0,
    max = 100
})

lia.attribs.register("eng", {
    name = "Engineering",
    desc = "Crafting and technical work.",
    min = 0,
    max = 100
})

lia.attribs.register("gun", {
    name = "Firearms",
    desc = "Weapon handling and accuracy.",
    min = 0,
    max = 100
})

lia.attribs.register("mle", {
    name = "Melee",
    desc = "Close-quarters combat skill.",
    min = 0,
    max = 100
})

if SERVER then
    --[[
    Purpose:
        Run attribute setup logic for a character on the server.

    When Called:
        On player spawn/character load to reapply attribute effects.

    Parameters:
        client (Player)
            Player whose character attributes are being applied.
    Realm:
        Server

    Example Usage:
        ```lua
            hook.Add("PlayerLoadedChar", "ApplyAttributeBonuses", function(ply)
                lia.attribs.setup(ply)
            end)
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
