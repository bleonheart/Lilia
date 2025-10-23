--[[
    Class Properties and Methods

    Character class definition system for the Lilia framework.
]]
--[[
    Overview:
    The class system provides comprehensive functionality for defining character classes
    within the Lilia framework. Classes represent specific roles or professions that
    characters can assume within factions, each with unique properties, behaviors, and
    restrictions. The system supports both server-side logic for gameplay mechanics
    and client-side properties for user interface and experience.

    Classes are defined using the CLASS table structure, which includes properties for
    identification, visual representation, gameplay mechanics, and access control. The
    system includes callback methods that are automatically invoked during key character
    lifecycle events, enabling dynamic behavior and customization. Classes can have
    player limits, whitelist requirements, attribute bonuses, and specialized loadouts,
    providing a flexible foundation for role-based gameplay systems.
]]
--[[
    CLASS.name
    Purpose: Sets the display name of the character class
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.name = "Police Officer"
        ```
]]
CLASS.name = ""
--[[
    CLASS.desc
    Purpose: Sets the description of the character class
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.desc = "A law enforcement officer responsible for maintaining order"
        ```
]]
CLASS.desc = ""
--[[
    CLASS.faction
    Purpose: Sets the faction ID this class belongs to
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.faction = FACTION_POLICE
        ```
]]
CLASS.faction = 0
--[[
    CLASS.limit
    Purpose: Sets the maximum number of players allowed in this class
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.limit = 5  -- Maximum 5 players
        CLASS.limit = 0  -- Unlimited players
        ```
]]
CLASS.limit = 0
--[[
    CLASS.model
    Purpose: Sets the player model for this class
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.model = "models/player/barney.mdl"
        ```
]]
CLASS.model = ""
--[[
    CLASS.isWhitelisted
    Purpose: Sets whether this class requires whitelist access
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.isWhitelisted = true
        ```
]]
CLASS.isWhitelisted = false
--[[
    CLASS.isDefault
    Purpose: Sets whether this is the default class for the faction
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.isDefault = true
        ```
]]
CLASS.isDefault = false
--[[
    CLASS.pay
    Purpose: Sets the salary amount for this class
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.pay = 100  -- $100 salary
        ```
]]
CLASS.pay = 0
--[[
    CLASS.attributes
    Purpose: Sets attribute bonuses for this class
    When Called: During class definition
    Parameters: None (set as property)
    Returns: None
    Realm: Shared
    Example Usage:
        ```lua
        CLASS.attributes = {
            ["str"] = 5,
            ["end"] = 3
        }
        ```
]]
CLASS.attributes = {}
--[[
    CLASS.OnCanBe
    Purpose: Check if a player can join this class
    When Called: When a player attempts to join this class
    Parameters:
        - client (Player): The player trying to join
    Returns: true to allow, false to deny
    Realm: Shared
    Example Usage:
        ```lua
        function CLASS:OnCanBe(client)
            local char = client:getChar()
            if char:getAttrib("str", 0) < 10 then
                return false
            end
            return true
        end
        ```
]]
function CLASS:OnCanBe(client)
    return true
end

--[[
    CLASS.OnSpawn
    Purpose: Called when a player spawns with this class
    When Called: When a player spawns with this class
    Parameters:
        - client (Player): The player spawning
    Returns: None
    Realm: Server
    Example Usage:
        ```lua
        function CLASS:OnSpawn(client)
            client:Give("weapon_stunstick")
            client:SetHealth(150)
            client:SetArmor(50)
        end
        ```
]]
function CLASS:OnSpawn(client)
end

--[[
    CLASS.OnLoadout
    Purpose: Called when applying class loadout
    When Called: During class loadout application
    Parameters:
        - client (Player): The player receiving loadout
    Returns: None
    Realm: Server
    Example Usage:
        ```lua
        function CLASS:OnLoadout(client)
            client:Give("weapon_pistol")
            client:GiveAmmo(100, "Pistol")
        end
        ```
]]
function CLASS:OnLoadout(client)
end

--[[
    CLASS.OnDeath
    Purpose: Called when a player dies with this class
    When Called: When a player dies while using this class
    Parameters:
        - client (Player): The player who died
    Returns: None
    Realm: Server
    Example Usage:
        ```lua
        function CLASS:OnDeath(client)
            client:notify("You died as a " .. self.name)
        end
        ```
]]
function CLASS:OnDeath(client)
end

--[[
    CLASS.OnSwitch
    Purpose: Called when switching to this class
    When Called: When a player switches to this class
    Parameters:
        - client (Player): The player switching
        - oldClass (table): The previous class data
    Returns: None
    Realm: Server
    Example Usage:
        ```lua
        function CLASS:OnSwitch(client, oldClass)
            if oldClass and oldClass.uniqueID == "citizen" then
                client:notify("Welcome to the police force!")
            end
        end
        ```
]]
function CLASS:OnSwitch(client, oldClass)
end

--[[
    CLASS.OnLeave
    Purpose: Called when leaving this class
    When Called: When a player leaves this class
    Parameters:
        - client (Player): The player leaving
    Returns: None
    Realm: Server
    Example Usage:
        ```lua
        function CLASS:OnLeave(client)
            client:StripWeapon("weapon_stunstick")
        end
        ```
]]
function CLASS:OnLeave(client)
end