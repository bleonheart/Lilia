--[[
    Classes Library

    Character class management and validation system for the Lilia framework.
]]
--[[
    Overview:
        The classes library provides comprehensive functionality for managing character classes in the Lilia framework. It handles registration, validation, and management of player classes within factions. The library operates on both server and client sides, allowing for dynamic class creation, whitelist management, and player class assignment validation. It includes functionality for loading classes from directories, checking class availability, retrieving class information, and managing class limits. The library ensures proper faction validation and provides hooks for custom class behavior and restrictions.
]]
lia.class = lia.class or {}
lia.class.list = lia.class.list or {}
    --[[
    Purpose:
        Registers a new character class in the class system with custom properties and validation rules.

    When Called:
        During gamemode initialization to define available classes within factions.
        When dynamically adding new classes through plugins or modules.

    Parameters:
        - uniqueID (string): Unique identifier for the class.
        - data (table): Configuration table containing class properties:
            - name (string): Display name of the class.
            - desc (string): Description of the class.
            - faction (number): Team/faction ID this class belongs to.
            - limit (number): Maximum number of players allowed in this class (0 = unlimited).
            - isDefault (boolean): Whether this is the default class for the faction.
            - isWhitelisted (boolean): Whether the class requires whitelist approval.
            - OnCanBe (function): Custom validation function for class availability.

    Returns:
        Class table if registration successful, nil otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Register a basic citizen class
        lia.class.register("citizen", {
            name = "Citizen",
            desc = "A regular citizen",
            faction = FACTION_CITIZEN,
            limit = 0
        })
        ```

        Medium Complexity:

        ```lua
        -- Medium: Register a police officer class with limits
        lia.class.register("police", {
            name = "Police Officer",
            desc = "Law enforcement officer",
            faction = FACTION_POLICE,
            limit = 10,
            isWhitelisted = true,
            OnCanBe = function(client)
                return client:getChar():getAttrib("endurance", 0) > 5
            end
        })
        ```

        High Complexity:

        ```lua
        -- High: Register a complex class with multiple validation rules
        lia.class.register("chief", {
            name = "Police Chief",
            desc = "Head of police department",
            faction = FACTION_POLICE,
            limit = 1,
            isWhitelisted = true,
            OnCanBe = function(client)
                local char = client:getChar()
                -- Must be police officer first
                if char:getClass() ~= "police" then return false end
                -- Must have high enough attributes
                if char:getAttrib("intelligence", 0) < 8 then return false end
                if char:getAttrib("leadership", 0) < 7 then return false end
                -- Must have been in faction for certain time
                return char:getTimeInFaction() > 604800 -- 1 week
            end
        })
        ```
]]
function lia.class.register(uniqueID, data)
    assert(isstring(uniqueID), L("classUniqueIDString"))
    assert(istable(data), L("classDataTable"))
    local index = #lia.class.list + 1
    local existing
    for i, v in ipairs(lia.class.list) do
        if v.uniqueID == uniqueID then
            index = i
            existing = v
            break
        end
    end

    local class = existing or {
        index = index
    }

    for k, v in pairs(data) do
        class[k] = v
    end

    class.uniqueID = uniqueID
    class.name = class.name or L("unknown")
    class.desc = class.desc or L("noDesc")
    class.limit = class.limit or 0
    if not class.faction or not team.Valid(class.faction) then
        lia.error(L("classNoValidFaction", uniqueID))
        return
    end

    if not class.OnCanBe then class.OnCanBe = function() return true end end
    lia.class.list[index] = class
    return class
end

    --[[
    Purpose:
        Loads all class definition files from a specified directory and registers them in the class system.

    When Called:
        During framework initialization to load class definitions from the classes directory.
        When reloading or refreshing class definitions during development.

    Parameters:
        - directory (string): The path to the directory containing class definition files (relative to Lua search paths).

    Returns:
        None.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Load classes from default directory
        lia.class.loadFromDir("classes")
        ```

        Medium Complexity:

        ```lua
        -- Medium: Load classes from custom schema directory
        lia.class.loadFromDir("gamemode/schema/classes")
        print("Loaded " .. #lia.class.list .. " classes")
        ```

        High Complexity:

        ```lua
        -- High: Load classes with validation and error handling
        local function safeLoadClasses(directory)
            local success, err = pcall(function()
                lia.class.loadFromDir(directory)
            end)

            if success then
                print("Successfully loaded classes from: " .. directory)
                -- Validate loaded classes
                for _, class in ipairs(lia.class.list) do
                    if not class.faction or not team.Valid(class.faction) then
                        print("Warning: Class '" .. class.uniqueID .. "' has invalid faction")
                    end
                end
            else
                print("Failed to load classes from " .. directory .. ": " .. err)
            end
        end

        safeLoadClasses("classes")
        ```
]]
function lia.class.loadFromDir(directory)
    for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
        local index = #lia.class.list + 1
        local halt
        local niceName
        if v:sub(1, 3) == "sh_" then
            niceName = v:sub(4, -5):lower()
        else
            niceName = v:sub(1, -5)
        end

        for _, class in ipairs(lia.class.list) do
            if class.uniqueID == niceName then halt = true end
        end

        if halt then continue end
        CLASS = {
            index = index,
            uniqueID = niceName
        }

        CLASS.name = L("unknown")
        CLASS.desc = L("noDesc")
        CLASS.limit = 0
        lia.loader.include(directory .. "/" .. v, "shared")
        if not CLASS.faction or not team.Valid(CLASS.faction) then
            lia.error(L("classNoValidFaction", niceName))
            CLASS = nil
            continue
        end

        if not CLASS.OnCanBe then CLASS.OnCanBe = function() return true end end
        CLASS.name = L(CLASS.name)
        CLASS.desc = L(CLASS.desc)
        lia.class.list[index] = CLASS
        CLASS = nil
    end
end

    --[[
    Purpose:
        Checks if a player can join or be assigned to a specific class, validating all requirements and restrictions.

    When Called:
        When a player attempts to join a class through commands or menus.
        When validating class assignments during character creation or changes.
        When checking class availability for UI display.

    Parameters:
        - client (Player): The player to check class availability for.
        - class (string|number): The class identifier (uniqueID or index) to check.

    Returns:
        boolean, string: True if player can join the class, false and error message if not.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Check if player can join police class
        local canJoin, reason = lia.class.canBe(player, "police")
        if canJoin then
            print("Player can join police class")
        else
            print("Cannot join: " .. reason)
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Check multiple classes for a player
        local availableClasses = {}
        local classIDs = {"citizen", "police", "medic"}

        for _, classID in ipairs(classIDs) do
            local canJoin = lia.class.canBe(player, classID)
            if canJoin then
                table.insert(availableClasses, classID)
            end
        end

        print("Player can join: " .. table.concat(availableClasses, ", "))
        ```

        High Complexity:

        ```lua
        -- High: Create a class selection UI with availability checking
        local function buildClassMenu(player)
            local menu = vgui.Create("DFrame")
            menu:SetSize(400, 300)
            menu:SetTitle("Select Class")

            local scroll = vgui.Create("DScrollPanel", menu)
            scroll:Dock(FILL)

            for _, class in ipairs(lia.class.list) do
                local canJoin, reason = lia.class.canBe(player, class.uniqueID)
                local button = scroll:Add("DButton")
                button:SetText(class.name)
                button:Dock(TOP)
                button:DockMargin(5, 5, 5, 0)

                if canJoin then
                    button:SetTextColor(Color(0, 255, 0))
                    button.DoClick = function()
                        RunConsoleCommand("say", "/class " .. class.uniqueID)
                        menu:Close()
                    end
                else
                    button:SetTextColor(Color(255, 0, 0))
                    button:SetTooltip(reason or "Cannot join this class")
                    button:SetEnabled(false)
                end
            end

            menu:Center()
            menu:MakePopup()
        end

        buildClassMenu(LocalPlayer())
        ```
]]
function lia.class.canBe(client, class)
    if not lia.class.list then return false, L("classNoInfo") end
    local info = lia.class.list[class]
    if not info then return false, L("classNoInfo") end
    if client:Team() ~= info.faction then return false, L("classWrongTeam") end
    local character = client:getChar()
    if character and character:getClass() == class then return false, L("alreadyInClass") end
    if info.limit > 0 and #lia.class.getPlayers(info.index) >= info.limit then return false, L("classFull") end
    if hook.Run("CanPlayerJoinClass", client, class, info) == false then return false end
    if info.OnCanBe and not info:OnCanBe(client) then return false end
    return info.isDefault
end

    --[[
    Purpose:
        Retrieves class information by its unique identifier or index.

    When Called:
        When accessing class data for display, validation, or processing.
        When checking class properties or configurations.

    Parameters:
        - identifier (string|number): The class uniqueID (string) or index (number) to retrieve.

    Returns:
        Class table containing class information, or nil if not found.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get class information
        local policeClass = lia.class.get("police")
        if policeClass then
            print("Police class name: " .. policeClass.name)
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get class by index
        local classByIndex = lia.class.get(2)
        if classByIndex then
            print("Class at index 2: " .. classByIndex.uniqueID)
        end
        ```

        High Complexity:

        ```lua
        -- High: Iterate through all classes and find specific ones
        local function findClassesByFaction(factionID)
            local factionClasses = {}
            local classCount = #lia.class.list

            for i = 1, classCount do
                local class = lia.class.get(i)
                if class and class.faction == factionID then
                    table.insert(factionClasses, class)
                end
            end

            return factionClasses
        end

        local policeClasses = findClassesByFaction(FACTION_POLICE)
        print("Found " .. #policeClasses .. " police classes")
        ```
]]
function lia.class.get(identifier)
    if not lia.class.list then return nil end
    return lia.class.list[identifier]
end

--[[
    Purpose:
        Retrieves all players currently assigned to a specific class.

    When Called:
        When counting players in a class for limit checking.
        When managing class-specific player lists or operations.
        When displaying class population information.

    Parameters:
        - class (string|number): The class identifier (uniqueID or index) to get players for.

    Returns:
        Array of player entities currently in the specified class.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get all police officers
        local policePlayers = lia.class.getPlayers("police")
        print("Police officers online: " .. #policePlayers)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Check if class has available slots
        local maxPolice = 10
        local currentPolice = #lia.class.getPlayers("police")
        if currentPolice < maxPolice then
            print("Police class has " .. (maxPolice - currentPolice) .. " slots available")
        else
            print("Police class is full")
        end
        ```

        High Complexity:

        ```lua
        -- High: Create a class management interface
        local function showClassManagementUI()
            local frame = vgui.Create("DFrame")
            frame:SetSize(600, 400)
            frame:SetTitle("Class Management")
            frame:Center()

            local scroll = vgui.Create("DScrollPanel", frame)
            scroll:Dock(FILL)

            for _, class in ipairs(lia.class.list) do
                local classPanel = scroll:Add("DPanel")
                classPanel:Dock(TOP)
                classPanel:DockMargin(5, 5, 5, 0)
                classPanel:SetTall(60)

                local className = vgui.Create("DLabel", classPanel)
                className:SetText(class.name)
                className:SetFont("liaMediumFont")
                className:Dock(LEFT)
                className:DockMargin(10, 10, 10, 10)

                local playerCount = #lia.class.getPlayers(class.uniqueID)
                local maxPlayers = class.limit > 0 and class.limit or "∞"

                local countLabel = vgui.Create("DLabel", classPanel)
                countLabel:SetText(playerCount .. "/" .. maxPlayers)
                countLabel:Dock(RIGHT)
                countLabel:DockMargin(10, 10, 10, 10)

                if class.limit > 0 and playerCount >= class.limit then
                    countLabel:SetTextColor(Color(255, 100, 100))
                else
                    countLabel:SetTextColor(Color(100, 255, 100))
                end
            end

            frame:MakePopup()
        end

        showClassManagementUI()
        ```
]]
function lia.class.getPlayers(class)
    if not lia.class.list then return {} end
    local players = {}
    for _, v in player.Iterator() do
        local character = v:getChar()
        if character and character:getClass() == class then table.insert(players, v) end
    end
    return players
end

    --[[
    Purpose:
        Returns the number of players currently assigned to a specific class.

    When Called:
        When checking class population for limit enforcement.
        When displaying class statistics or availability information.

    Parameters:
        - class (string|number): The class identifier (uniqueID or index) to count players for.

    Returns:
        number - The number of players currently in the specified class.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get police officer count
        local policeCount = lia.class.getPlayerCount("police")
        print("Police officers online: " .. policeCount)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Check class capacity
        local classInfo = lia.class.get("medic")
        if classInfo then
            local current = lia.class.getPlayerCount(classInfo.uniqueID)
            local max = classInfo.limit
            if max > 0 and current >= max then
                print("Medic class is full (" .. current .. "/" .. max .. ")")
            else
                print("Medic class: " .. current .. "/" .. (max > 0 and max or "∞"))
            end
        end
        ```

        High Complexity:

        ```lua
        -- High: Generate faction population report
        local function generateFactionReport(factionID)
            local report = {
                totalPlayers = 0,
                classBreakdown = {}
            }

            for _, class in ipairs(lia.class.list) do
                if class.faction == factionID then
                    local count = lia.class.getPlayerCount(class.uniqueID)
                    report.classBreakdown[class.name] = count
                    report.totalPlayers = report.totalPlayers + count
                end
            end

            return report
        end

        local policeReport = generateFactionReport(FACTION_POLICE)
        print("Police Department Report:")
        print("Total Officers: " .. policeReport.totalPlayers)
        for className, count in pairs(policeReport.classBreakdown) do
            print("  " .. className .. ": " .. count)
        end
        ```
]]
function lia.class.getPlayerCount(class)
    if not lia.class.list then return 0 end
    local count = 0
    for _, v in player.Iterator() do
        local character = v:getChar()
        if character and character:getClass() == class then count = count + 1 end
    end
    return count
end

    --[[
    Purpose:
        Finds a class by matching its uniqueID or name against a search string.

    When Called:
        When searching for classes by partial name or ID.
        When implementing class selection or autocomplete features.

    Parameters:
        - class (string): The search string to match against class uniqueIDs or names.

    Returns:
        number - The index of the matching class, or nil if not found.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Find police class
        local policeIndex = lia.class.retrieveClass("police")
        if policeIndex then
            print("Police class found at index: " .. policeIndex)
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Find class by partial name
        local medicIndex = lia.class.retrieveClass("medic")
        local classInfo = medicIndex and lia.class.get(medicIndex)
        if classInfo then
            print("Found medic class: " .. classInfo.name)
        end
        ```

        High Complexity:

        ```lua
        -- High: Implement class autocomplete
        local function findClasses(searchTerm)
            local matches = {}
            for i, class in ipairs(lia.class.list) do
                if string.find(string.lower(class.uniqueID), string.lower(searchTerm), 1, true) or
                   string.find(string.lower(class.name), string.lower(searchTerm), 1, true) then
                    table.insert(matches, {index = i, class = class})
                end
            end
            return matches
        end

        local searchResults = findClasses("pol")
        for _, result in ipairs(searchResults) do
            print("Match: " .. result.class.name .. " (ID: " .. result.class.uniqueID .. ")")
        end
        ```
]]
function lia.class.retrieveClass(class)
    if not lia.class.list then return nil end
    for key, classTable in pairs(lia.class.list) do
        if lia.util.stringMatches(classTable.uniqueID, class) or lia.util.stringMatches(classTable.name, class) then return key end
    end
    return nil
end

    --[[
    Purpose:
        Checks if a class requires whitelist approval before players can join.

    When Called:
        When determining if a class requires special permissions.
        When displaying class availability information to players.
        During class assignment validation.

    Parameters:
        - class (string|number): The class identifier (uniqueID or index) to check.

    Returns:
        boolean - True if the class requires whitelist approval, false otherwise.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Check if police class needs whitelist
        if lia.class.hasWhitelist("police") then
            print("Police class requires whitelist approval")
        else
            print("Police class is open to all")
        end
        ```

        Medium Complexity:

        ```lua
        -- Medium: Filter available classes by whitelist status
        local availableClasses = {}
        local requiresWhitelist = {}

        for _, class in ipairs(lia.class.list) do
            if lia.class.hasWhitelist(class.uniqueID) then
                table.insert(requiresWhitelist, class)
            else
                table.insert(availableClasses, class)
            end
        end

        print("Available classes: " .. #availableClasses)
        print("Whitelist-required classes: " .. #requiresWhitelist)
        ```

        High Complexity:

        ```lua
        -- High: Create whitelist management interface
        local function showWhitelistUI()
            local frame = vgui.Create("DFrame")
            frame:SetSize(500, 400)
            frame:SetTitle("Class Whitelist Management")
            frame:Center()

            local list = vgui.Create("DListView", frame)
            list:Dock(FILL)
            list:AddColumn("Class Name")
            list:AddColumn("Requires Whitelist")
            list:AddColumn("Player Count")

            for _, class in ipairs(lia.class.list) do
                local whitelistRequired = lia.class.hasWhitelist(class.uniqueID) and "Yes" or "No"
                local playerCount = lia.class.getPlayerCount(class.uniqueID)
                list:AddLine(class.name, whitelistRequired, playerCount)
            end

            frame:MakePopup()
        end

        showWhitelistUI()
        ```
]]
function lia.class.hasWhitelist(class)
    if not lia.class.list then return false end
    local info = lia.class.list[class]
    if not info then return false end
    if info.isDefault then return false end
    return info.isWhitelisted
end

    --[[
    Purpose:
        Returns a list of classes that a specific player can join based on their current character and permissions.

    When Called:
        When building class selection menus or interfaces.
        When checking available class options for a player.
        During character creation or class change operations.

    Parameters:
        - client (Player): The player to get joinable classes for (optional, uses LocalPlayer() if not provided on client).

    Returns:
        table - Array of class tables that the player can join.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get available classes for current player
        local availableClasses = lia.class.retrieveJoinable()
        print("You can join " .. #availableClasses .. " classes")
        ```

        Medium Complexity:

        ```lua
        -- Medium: Display available classes in a menu
        local joinableClasses = lia.class.retrieveJoinable(player)

        for _, class in ipairs(joinableClasses) do
            print("Available: " .. class.name .. " (" .. class.uniqueID .. ")")
        end
        ```

        High Complexity:

        ```lua
        -- High: Create a comprehensive class selection interface
        local function createClassSelectionMenu(player)
            local joinableClasses = lia.class.retrieveJoinable(player)
            local frame = vgui.Create("DFrame")
            frame:SetSize(400, 500)
            frame:SetTitle("Select Class")
            frame:Center()

            local scroll = vgui.Create("DScrollPanel", frame)
            scroll:Dock(FILL)

            for _, class in ipairs(joinableClasses) do
                local classButton = scroll:Add("DButton")
                classButton:SetText(class.name)
                classButton:Dock(TOP)
                classButton:DockMargin(5, 5, 5, 0)
                classButton:SetTall(40)

                -- Add description as tooltip
                if class.desc then
                    classButton:SetTooltip(class.desc)
                end

                -- Color based on whitelist status
                if lia.class.hasWhitelist(class.uniqueID) then
                    classButton:SetTextColor(Color(255, 215, 0)) -- Gold for whitelisted
                else
                    classButton:SetTextColor(Color(255, 255, 255)) -- White for regular
                end

                classButton.DoClick = function()
                    RunConsoleCommand("say", "/class " .. class.uniqueID)
                    frame:Close()
                end
            end

            if #joinableClasses == 0 then
                local noClassesLabel = scroll:Add("DLabel")
                noClassesLabel:SetText("No classes available for your current character.")
                noClassesLabel:SetContentAlignment(5)
                noClassesLabel:Dock(TOP)
                noClassesLabel:DockMargin(10, 20, 10, 10)
            end

            frame:MakePopup()
        end

        createClassSelectionMenu(LocalPlayer())
        ```
]]
function lia.class.retrieveJoinable(client)
    client = client or CLIENT and LocalPlayer() or nil
    if not IsValid(client) then return {} end
    if not lia.class.list then return {} end
    local classes = {}
    for _, class in pairs(lia.class.list) do
        if lia.class.canBe(client, class.index) then classes[#classes + 1] = class end
    end
    return classes
end
