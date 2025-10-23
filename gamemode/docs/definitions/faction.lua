--[[
    Faction Methods

    Faction-specific callback methods for the Lilia framework.
]]
--[[
    Overview:
    The faction methods library provides callback functions and properties that are automatically
    called by the Lilia framework during specific faction-related events. These methods allow
    faction definitions to respond to faction transfers, limit checking operations, character
    creation processes, NPC interactions, and recognition systems. Each method receives relevant
    context about the event and can modify gameplay behavior, apply faction-specific logic,
    or control access to faction features.

    These methods are defined within FACTION table definitions and are called automatically
    by the framework at appropriate times. They enable dynamic faction behavior and
    customization without requiring direct modification of core framework systems.

    Note: Only the methods documented below are actually implemented in the Lilia framework.
    A total of 8 faction methods and properties are available. Other OnX methods may exist
    for classes or other systems but not for factions.
]]
--[[
    OnTransferred
    Purpose: Called when a player is transferred to this faction
    When Called: When a player is moved to this faction from another faction
    Parameters:
        - self (table): The faction data table
        - client (Player): The player being transferred
        - oldFaction (number): The player's previous faction index
    Returns: None
    Realm: Server
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),
            
            OnTransferred = function(self, client, oldFaction)
                local oldFactionData = lia.faction.indices[oldFaction]
                client:notify("Transferred from " .. (oldFactionData and oldFactionData.name or "Unknown") .. " to Police")
                client:Give("weapon_pistol")
            end
        }
        ```
]]
function OnTransferred(self, client, oldFaction)
end

--[[
    OnCheckLimitReached
    Purpose: Called to check if this faction has reached its player limit
    When Called: When a player tries to join this faction or use a character from this faction
    Parameters:
        - self (table): The faction data table
        - character (table): The character attempting to join
        - client (Player): The player requesting to join
    Returns: true if limit reached (should block), false if can join
    Realm: Server
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),
            limit = 5,
            
            OnCheckLimitReached = function(self, character, client)
                -- Custom limit logic
                local currentCount = team.NumPlayers(self.index)
                if currentCount >= self.limit then
                    client:notify("Police faction is full!")
                    return true -- Block joining
                end
                return false -- Allow joining
            end
        }
        ```
]]
function OnCheckLimitReached(self, character, client)
end

--[[
    NameTemplate
    Purpose: Provides a template function for generating default character names
    When Called: During character creation when no name is provided
    Parameters:
        - info (table): The faction data table
        - client (Player): The player creating the character
    Returns: string (name), boolean (override default validation)
    Realm: Shared
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),

            NameTemplate = function(info, client)
                return "Officer " .. math.random(100, 999), true
            end
        }
        ```
]]
function NameTemplate(info, client)
end

--[[
    GetDefaultName
    Purpose: Provides a default character name for this faction
    When Called: During character creation when no name is provided
    Parameters:
        - client (Player): The player creating the character
    Returns: string (default name) or nil
    Realm: Shared
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),

            GetDefaultName = function(client)
                return "Officer " .. math.random(100, 999)
            end
        }
        ```
]]
function GetDefaultName(client)
end

--[[
    GetDefaultDesc
    Purpose: Provides a default character description for this faction
    When Called: During character creation when no description is provided
    Parameters:
        - client (Player): The player creating the character
    Returns: string (default description) or nil
    Realm: Shared
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),

            GetDefaultDesc = function(client)
                return "A dedicated police officer serving the community."
            end
        }
        ```
]]
function GetDefaultDesc(client)
end

--[[
    prefix
    Purpose: Provides a prefix for character names in this faction
    When Called: During character name generation and validation
    Parameters:
        - client (Player): The player creating the character (if function)
    Returns: string (prefix) or function that returns string
    Realm: Shared
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),

            prefix = "Officer"  -- Simple string prefix

            -- Or as a function:
            prefix = function(client)
                return "Sgt."  -- Dynamic prefix based on client
            end
        }
        ```
]]
function prefix(client)
end

--[[
    NPCRelations
    Purpose: Defines how NPCs should behave towards players in this faction
    When Called: During NPC entity creation and player spawn
    Parameters: None (set as table property)
    Returns: table with NPC class relationships (e.g., {["npc_zombie"] = D_HT, ["npc_antlion"] = D_FR})
    Realm: Server
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),

            NPCRelations = {
                ["npc_zombie"] = D_HT,      -- Hostile to zombies
                ["npc_antlion"] = D_HT,     -- Hostile to antlions
                ["npc_citizen"] = D_LI      -- Like citizens (allies)
            }
        }
        ```
]]
function NPCRelations()
end

--[[
    RecognizesGlobally
    Purpose: Determines if this faction can recognize players globally (without needing to learn names)
    When Called: During recognition system checks
    Parameters: None (set as boolean property)
    Returns: boolean (true for global recognition)
    Realm: Shared
    Example Usage:
        ```lua
        FACTION["police"] = {
            name = "Police Officer",
            desc = "Law enforcement officer",
            color = Color(0, 0, 255),

            RecognizesGlobally = true  -- Police can recognize everyone
        }
        ```
]]
function RecognizesGlobally()
end