-- Chat System Fixes for Lilia
-- This file contains fixes for common chat system issues

lia.chat = lia.chat or {}

if SERVER then
    -- Server-side fixes

    -- Fix 1: Ensure network strings are properly registered
    hook.Add("Initialize", "liaChatFixNetStrings", function()
        -- Ensure all required network strings are registered
        local requiredNetStrings = {
            "msg",      -- Client to server chat messages
            "cMsg",     -- Server to client chat messages
            "RegenChat" -- Chat regeneration
        }

        for _, netString in ipairs(requiredNetStrings) do
            if util.NetworkStringToID(netString) == 0 then
                util.AddNetworkString(netString)
                print("[CHAT FIX] Registered missing network string: " .. netString)
            end
        end
    end)

    -- Fix 2: Ensure chat commands are properly registered
    hook.Add("InitializedModules", "liaChatFixCommands", function()
        -- Force re-registration of chat commands if needed
        if not lia.chat.classes or table.Count(lia.chat.classes) == 0 then
            print("[CHAT FIX] Re-registering chat commands...")

            -- Include the chatbox shared library to ensure commands are registered
            if file.Exists("lilia/gamemode/modules/chatbox/libraries/shared.lua", "LUA") then
                include("lilia/gamemode/modules/chatbox/libraries/shared.lua")
                print("[CHAT FIX] Chat commands re-registered")
            end
        end
    end)

    -- Fix 3: Monitor and fix PlayerSay hook issues
    hook.Add("PlayerSay", "liaChatFixPlayerSay", function(client, text)
        -- Ensure the hook returns empty string to prevent default chat
        if lia.chat.classes and table.Count(lia.chat.classes) > 0 then
            local chatType, parsedMessage, anonymous = lia.chat.parse(client, text, true)
            message = parsedMessage

            if chatType == "ic" and lia.command.parse(client, message) then
                return ""
            end

            lia.chat.send(client, chatType, message, anonymous)
            return ""
        end

        -- If chat system is broken, at least show the message
        print("[CHAT FIX] Chat system fallback - Player " .. client:Name() .. " said: " .. text)
        return ""
    end, -1) -- High priority to override other hooks

    -- Fix 4: Ensure chatbox module is loaded
    hook.Add("InitializedModules", "liaChatEnsureModuleLoaded", function()
        if not lia.module.get("chatbox") then
            print("[CHAT FIX] Chatbox module not found, attempting to load...")
            lia.module.loadFromDir("lilia/gamemode/modules", "module")
        end
    end)

else
    -- Client-side fixes

    -- Fix 1: Ensure chatbox panel is created
    hook.Add("InitPostEntity", "liaChatFixPanelCreation", function()
        if not IsValid(lia.gui.chat) then
            print("[CHAT FIX CLIENT] Creating chatbox panel...")
            if MODULE and MODULE.createChat then
                MODULE:createChat()
            else
                -- Fallback panel creation
                lia.gui.chat = vgui.Create("liaChatBox")
                hook.Run("ChatboxPanelCreated", lia.gui.chat)
            end
        end
    end)

    -- Fix 2: Fix chat.AddText override
    hook.Add("Initialize", "liaChatFixAddText", function()
        if not chat.liaAddText then
            chat.liaAddText = chat.AddText
        end

        -- Ensure chat.AddText is properly overridden
        function chat.AddText(...)
            local show = true
            if IsValid(lia.gui.chat) then
                show = lia.gui.chat:addText(...)
            end
            if show then
                chat.liaAddText(...)
                hook.Run("ChatboxTextAdded", ...)
            end
        end
    end)

    -- Fix 3: Fix bind handling for chat opening
    hook.Add("PlayerBindPress", "liaChatFixBindPress", function(client, bind, pressed)
        bind = bind:lower()
        if bind:find("messagemode") and pressed then
            if not IsValid(lia.gui.chat) then
                if MODULE and MODULE.createChat then
                    MODULE:createChat()
                end
            end

            if IsValid(lia.gui.chat) and not lia.gui.chat.active then
                lia.gui.chat:setActive(true)
                return true
            end
        end
    end)

    -- Fix 4: Monitor network message reception
    net.Receive("cMsg", function()
        local client = net.ReadEntity()
        local chatType = net.ReadString()
        local text = net.ReadString()
        local anonymous = net.ReadBool()

        if IsValid(client) then
            local class = lia.chat.classes[chatType]
            text = hook.Run("OnChatReceived", client, chatType, text, anonymous) or text

            if class then
                CHAT_CLASS = class
                class.onChatAdd(client, text, anonymous)
                chat.PlaySound()
                CHAT_CLASS = nil
            else
                print("[CHAT FIX CLIENT] Unknown chat type received: " .. chatType)
            end
        end
    end)
end

-- Shared fixes

-- Fix 1: Ensure chat classes are available
hook.Add("InitializedModules", "liaChatFixClasses", function()
    if not lia.chat.classes then
        lia.chat.classes = {}
        print("[CHAT FIX SHARED] Created lia.chat.classes table")
    end

    if not lia.chat.register then
        print("[CHAT FIX SHARED] lia.chat.register function missing!")
    end
end)

-- Fix 2: Add fallback chat functionality
function lia.chat.fallbackMessage(message)
    if SERVER then
        -- Server fallback: send message to all players
        net.Start("cMsg")
        net.WriteEntity(NULL) -- No specific client
        net.WriteString("ic") -- IC chat type
        net.WriteString(message)
        net.WriteBool(false) -- Not anonymous
        net.Broadcast()
    else
        -- Client fallback: display message
        chat.AddText(Color(255, 255, 255), message)
    end
end

print("[CHAT FIX] Chat system fixes loaded successfully!")
