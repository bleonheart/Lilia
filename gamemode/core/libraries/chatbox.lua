--[[
    Chatbox Library

    Comprehensive chat system management with message routing and formatting for the Lilia framework.
]]
--[[
    Overview:
        The chatbox library provides comprehensive functionality for managing chat systems in the Lilia framework. It handles registration of different chat types (IC, OOC, whisper, etc.), message parsing and routing, distance-based hearing mechanics, and chat formatting. The library operates on both server and client sides, with the server managing message distribution and validation, while the client handles parsing and display formatting. It includes support for anonymous messaging, custom prefixes, radius-based communication, and integration with the command system for chat-based commands.
]]
lia.chat = lia.chat or {}
lia.chat.classes = lia.chat.classes or {}
--[[
    Purpose:
        Generates a timestamp string for chat messages based on current time settings.

    When Called:
        When formatting chat messages to include timestamps if the option is enabled.

    Parameters:
        - ooc (boolean): Whether this is an out-of-character message (affects formatting).

    Returns:
        Formatted timestamp string or empty string if timestamps are disabled.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Get timestamp for IC message
        local timeStamp = lia.chat.timestamp(false)
        -- Returns something like: " (14) " if time is enabled
        ```

        Medium Complexity:

        ```lua
        -- Medium: Get timestamp for OOC message
        local oocTimeStamp = lia.chat.timestamp(true)
        -- Returns something like: " (14)" if time is enabled
        ```

        High Complexity:

        ```lua
        -- High: Use in custom chat formatting
        local function customChatFormat(speaker, text, isOOC)
            local timeStr = lia.chat.timestamp(isOOC)
            local prefix = isOOC and "[OOC]" or "[IC]"
            return timeStr .. prefix .. " " .. speaker:Name() .. ": " .. text
        end

        -- Override default chat formatting
        hook.Add("OnPlayerChat", "CustomChatFormat", function(ply, text, team, dead)
            if team then
                chat.AddText(Color(100, 200, 100), customChatFormat(ply, text, false))
                return true
            end
        end)
        ```
]]
function lia.chat.timestamp(ooc)
    return lia.option.ChatShowTime and (ooc and " " or "") .. "(" .. lia.time.getHour() .. ")" .. (ooc and "" or " ") or ""
end

--[[
    Purpose:
        Registers a new chat type with custom behavior, formatting, and restrictions.

    When Called:
        During gamemode initialization to set up different chat channels like IC, OOC, whisper, etc.

    Parameters:
        - chatType (string): Unique identifier for the chat type.
        - data (table): Configuration table with chat behavior settings:
            - prefix (string/table): Command prefix(es) to trigger this chat type.
            - color (Color): Color for chat messages.
            - format (string): Localization key for message formatting.
            - radius (number/function): Hearing radius for distance-based chat.
            - onCanSay (function): Function to check if player can send messages.
            - onCanHear (function): Function to check if player can hear messages.
            - onChatAdd (function): Custom function for adding messages to chat.
            - deadCanChat (boolean): Whether dead players can use this chat.
            - noSpaceAfter (boolean): Whether prefix requires no space after.
            - arguments (table): Command-style arguments for complex chat commands.
            - filter (string): Chat filter category.

    Returns:
        Nothing

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Register a basic OOC chat
        lia.chat.register("ooc", {
            prefix = "//",
            color = Color(255, 100, 100),
            format = "oocFormat"
        })
        ```

        Medium Complexity:

        ```lua
        -- Medium: Register a whisper chat with distance limits
        lia.chat.register("whisper", {
            prefix = "/w",
            color = Color(150, 150, 255),
            radius = 200, -- 200 units hearing range
            format = "whisperFormat"
        })
        ```

        High Complexity:

        ```lua
        -- High: Register a complex radio chat with custom logic
        lia.chat.register("radio", {
            prefix = "/r",
            color = Color(100, 255, 100),
            onCanSay = function(speaker, text)
                -- Check if player has radio
                local char = speaker:getChar()
                if not char or not char:getInv():hasItem("radio") then
                    speaker:notify("You need a radio to use radio chat!")
                    return false
                end
                return true
            end,
            onCanHear = function(speaker, listener)
                -- Only players with radios can hear
                local char = listener:getChar()
                return char and char:getInv():hasItem("radio")
            end,
            onChatAdd = function(speaker, text, anonymous)
                -- Custom radio message formatting
                chat.AddText(Color(100, 255, 100), "[RADIO] ", speaker:Name(), ": ", text)
            end,
            filter = "ic"
        })
        ```
]]
function lia.chat.register(chatType, data)
    data.arguments = data.arguments or {}
    data.syntax = L(lia.command.buildSyntaxFromArguments(data.arguments))
    data.desc = data.desc or ""
    if data.prefix then
        local prefixes = istable(data.prefix) and data.prefix or {data.prefix}
        local processed, lookup = {}, {}
        for _, prefix in ipairs(prefixes) do
            if prefix ~= "" and not lookup[prefix] then
                processed[#processed + 1] = prefix
                lookup[prefix] = true
            end

            local noSlash = prefix:gsub("^/", "")
            if noSlash ~= "" and not lookup[noSlash] and noSlash:sub(1, 1) ~= "/" then
                processed[#processed + 1] = noSlash
                lookup[noSlash] = true
            end
        end

        data.prefix = processed
    end

    if not data.onCanHear then
        if isfunction(data.radius) then
            data.onCanHear = function(speaker, listener) return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= data.radius() ^ 2 end
        elseif isnumber(data.radius) then
            local range = data.radius ^ 2
            data.onCanHear = function(speaker, listener) return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range end
        else
            data.onCanHear = function() return true end
        end
    elseif isnumber(data.onCanHear) then
        local range = data.onCanHear ^ 2
        data.onCanHear = function(speaker, listener) return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range end
    end

    data.onCanSay = data.onCanSay or function(speaker)
        if not data.deadCanChat and not speaker:Alive() then
            speaker:notifyErrorLocalized("noPerm")
            return false
        end
        return true
    end

    data.color = data.color or (lia.color.theme and lia.color.theme.chat) or Color(255, 239, 150)
    data.format = data.format or "chatFormat"
    data.onChatAdd = data.onChatAdd or function(speaker, text, anonymous) chat.AddText(lia.chat.timestamp(false), (lia.color.theme and lia.color.theme.chat) or Color(255, 239, 150), L(data.format, anonymous and L("someone") or hook.Run("GetDisplayedName", speaker, chatType) or IsValid(speaker) and speaker:Name() or L("console"), text)) end
    if CLIENT and data.prefix then
        local rawPrefixes = istable(data.prefix) and data.prefix or {data.prefix}
        local aliases, lookup = {}, {}
        for _, prefix in ipairs(rawPrefixes) do
            if prefix:sub(1, 1) == "/" then
                local cmd = prefix:gsub("^/", ""):lower()
                local isCommonWord = cmd == "it" or cmd == "me" or cmd == "w" or cmd == "y" or cmd == "a"
                if cmd ~= "" and not lookup[cmd] and not isCommonWord then
                    table.insert(aliases, cmd)
                    lookup[cmd] = true
                end
            end
        end

        if #aliases > 0 then
            lia.command.add(chatType, {
                arguments = data.arguments,
                desc = data.desc,
                alias = aliases,
                onRun = function(_, args) lia.chat.parse(LocalPlayer(), table.concat(args, " ")) end
            })
        end
    end

    data.filter = data.filter or "ic"
    lia.chat.classes[chatType] = data
end

--[[
    Purpose:
        Parses a chat message to determine its type and content, handling prefixes and routing.

    When Called:
        When a player sends a chat message, to determine how it should be processed and routed.

    Parameters:
        - client (Player): The player sending the message.
        - message (string): The raw chat message text.
        - noSend (boolean): If true, prevents automatic sending (for parsing only).

    Returns:
        chatType (string): The determined chat type.
        message (string): The processed message text.
        anonymous (boolean): Whether the message should be anonymous.

    Realm:
        Shared (works on both server and client).

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Parse a basic IC message
        local chatType, text, anon = lia.chat.parse(client, "Hello everyone!")
        -- Returns: "ic", "Hello everyone!", false
        ```

        Medium Complexity:

        ```lua
        -- Medium: Parse an OOC message with prefix
        local chatType, text, anon = lia.chat.parse(client, "//This is OOC text")
        -- Returns: "ooc", "This is OOC text", false
        ```

        High Complexity:

        ```lua
        -- High: Custom chat parsing with command integration
        local function customChatHandler(client, text)
            -- First try to parse as command
            local isCommand = lia.command.parse(client, text)
            if isCommand then return end -- Command was handled

            -- Otherwise parse as chat
            local chatType, message, anonymous = lia.chat.parse(client, text)

            -- Custom processing based on chat type
            if chatType == "ooc" then
                -- Log OOC messages
                lia.log.add(client, "ooc_chat", message)
            elseif chatType == "ic" then
                -- Check for profanity in IC chat
                if containsProfanity(message) then
                    client:notify("Please keep IC chat appropriate!")
                    return
                end
            end

            -- Allow the message to be sent normally
            return chatType, message, anonymous
        end

        -- Hook into chat processing
        hook.Add("PlayerSay", "CustomChatHandler", function(ply, text, teamChat)
            local chatType, message, anonymous = customChatHandler(ply, text)
            if chatType then
                -- Send the processed message
                lia.chat.send(ply, chatType, message, anonymous)
                return "" -- Suppress default chat
            end
        end)
        ```
]]
function lia.chat.parse(client, message, noSend)
    local anonymous = false
    local chatType = "ic"
    for k, v in pairs(lia.chat.classes) do
        local isChosen = false
        local chosenPrefix = ""
        local noSpaceAfter = v.noSpaceAfter
        if istable(v.prefix) then
            for _, prefix in ipairs(v.prefix) do
                if message:sub(1, #prefix + (noSpaceAfter and 0 or 1)):lower() == (prefix .. (noSpaceAfter and "" or " ")):lower() then
                    isChosen = true
                    chosenPrefix = prefix .. (v.noSpaceAfter and "" or " ")
                    break
                end
            end
        elseif isstring(v.prefix) then
            isChosen = message:sub(1, #v.prefix + (noSpaceAfter and 0 or 1)):lower() == (v.prefix .. (v.noSpaceAfter and "" or " ")):lower()
            chosenPrefix = v.prefix .. (v.noSpaceAfter and "" or " ")
        end

        if isChosen then
            chatType = k
            message = message:sub(#chosenPrefix + 1)
            if lia.chat.classes[k].noSpaceAfter and message:sub(1, 1):match("%s") then message = message:sub(2) end
            break
        end
    end

    if not message:find("%S") then return end
    local newType, newMsg, newAnon = hook.Run("ChatParsed", client, chatType, message, anonymous)
    chatType = newType or chatType
    message = newMsg or message
    anonymous = newAnon ~= nil and newAnon or anonymous
    if SERVER and not noSend then
        if chatType == "ooc" then hook.Run("OnOOCMessageSent", client, message) end
        lia.chat.send(client, chatType, hook.Run("PlayerMessageSend", client, chatType, message, anonymous) or message, anonymous)
    end
    return chatType, message, anonymous
end

if SERVER then
    --[[
    Purpose:
        Sends a chat message to appropriate recipients based on chat type rules and permissions.

    When Called:
        After parsing and validating a chat message, to distribute it to players who can hear it.

    Parameters:
        - speaker (Player): The player sending the message.
        - chatType (string): The type of chat message.
        - text (string): The message content.
        - anonymous (boolean): Whether the message should be anonymous.
        - receivers (table): Optional array of specific players to receive the message.

    Returns:
        Nothing

    Realm:
        Server

    Example Usage:

        Low Complexity:

        ```lua
        -- Simple: Send an IC message
        lia.chat.send(client, "ic", "Hello everyone!", false)
        ```

        Medium Complexity:

        ```lua
        -- Medium: Send a message to specific players
        local nearbyPlayers = {}
        for _, ply in ipairs(player.GetAll()) do
            if ply:GetPos():Distance(client:GetPos()) < 500 then
                table.insert(nearbyPlayers, ply)
            end
        end
        lia.chat.send(client, "whisper", "Psst...", false, nearbyPlayers)
        ```

        High Complexity:

        ```lua
        -- High: Custom broadcasting system with advanced filtering
        local function broadcastToFaction(speaker, message, factionName)
            local receivers = {}
            local speakerChar = speaker:getChar()
            if not speakerChar or speakerChar:getFaction() ~= factionName then
                speaker:notify("You are not in the " .. factionName .. " faction!")
                return
            end

            -- Find all players in the same faction
            for _, ply in ipairs(player.GetAll()) do
                local char = ply:getChar()
                if char and char:getFaction() == factionName then
                    table.insert(receivers, ply)
                end
            end

            if #receivers == 0 then
                speaker:notify("No other faction members online.")
                return
            end

            -- Send the faction message
            lia.chat.send(speaker, "radio", "[FACTION] " .. message, false, receivers)

            -- Log faction communication
            lia.log.add(speaker, "faction_chat", factionName .. ": " .. message)
        end

        -- Register a command to use this system
        lia.command.add("faction", {
            arguments = {
                {name = "message", type = "string"}
            },
            onRun = function(client, arguments)
                local message = arguments[1]
                broadcastToFaction(client, message, "police") -- Example for police faction
            end
        })
        ```
]]
function lia.chat.send(speaker, chatType, text, anonymous, receivers)
        local class = lia.chat.classes[chatType]
        if class and class.onCanSay(speaker, text) ~= false then
            if class.onCanHear and not receivers then
                receivers = {}
                for _, v in player.Iterator() do
                    if v:getChar() and class.onCanHear(speaker, v) ~= false then receivers[#receivers + 1] = v end
                end

                if #receivers == 0 then return end
            end

            net.Start("liaChatMsg")
            net.WriteEntity(speaker)
            net.WriteString(chatType)
            net.WriteString(hook.Run("PlayerMessageSend", speaker, chatType, text, anonymous, receivers) or text)
            net.WriteBool(anonymous)
            if istable(receivers) then
                net.Send(receivers)
            else
                net.Broadcast()
            end
        end
    end
end
