-- Chat System Diagnostic Tool for Lilia
-- This file helps debug chat system issues

lia.chat = lia.chat or {}

if SERVER then
    -- Server-side diagnostic functions
    function lia.chat.debug_net_messages()
        print("[CHAT DEBUG] Testing net messages...")

        -- Check if network strings are registered
        local netStrings = {
            "msg",
            "cMsg",
            "RegenChat"
        }

        for _, netString in ipairs(netStrings) do
            if util.NetworkStringToID(netString) == 0 then
                print("[CHAT DEBUG] ERROR: Network string '" .. netString .. "' is not registered!")
            else
                print("[CHAT DEBUG] OK: Network string '" .. netString .. "' is registered")
            end
        end
    end

    function lia.chat.debug_chat_types()
        print("[CHAT DEBUG] Checking registered chat types...")

        if not lia.chat.classes then
            print("[CHAT DEBUG] ERROR: lia.chat.classes is nil!")
            return
        end

        local count = 0
        for chatType, data in pairs(lia.chat.classes) do
            count = count + 1
            print("[CHAT DEBUG] Chat type '" .. chatType .. "' registered")

            if data.prefix then
                print("[CHAT DEBUG]   - Prefixes: " .. table.concat(data.prefix, ", "))
            end
        end

        print("[CHAT DEBUG] Total chat types registered: " .. count)
    end

    function lia.chat.debug_commands()
        print("[CHAT DEBUG] Checking registered commands...")

        if not lia.command.list then
            print("[CHAT DEBUG] ERROR: lia.command.list is nil!")
            return
        end

        local count = 0
        for cmdName, cmdData in pairs(lia.command.list) do
            count = count + 1
            print("[CHAT DEBUG] Command '" .. cmdName .. "' registered")
        end

        print("[CHAT DEBUG] Total commands registered: " .. count)
    end

    function lia.chat.debug_playersay_hook()
        print("[CHAT DEBUG] Testing PlayerSay hook...")

        -- Hook a temporary function to monitor PlayerSay calls
        local originalPlayerSay = hook.GetTable()["PlayerSay"]
        local monitorActive = false

        if not monitorActive then
            monitorActive = true
            hook.Add("PlayerSay", "ChatDebugMonitor", function(client, text)
                print("[CHAT DEBUG] PlayerSay hook called:")
                print("[CHAT DEBUG]   - Player: " .. client:Name() .. " (" .. client:SteamID() .. ")")
                print("[CHAT DEBUG]   - Message: '" .. text .. "'")
                print("[CHAT DEBUG]   - Message length: " .. #text)
                print("[CHAT DEBUG]   - Has whitespace: " .. (text:find("%S") and "YES" or "NO"))

                -- Parse the message to see what happens
                local chatType, parsedMessage, anonymous = lia.chat.parse(client, text, true)
                print("[CHAT DEBUG]   - Parsed chat type: " .. tostring(chatType))
                print("[CHAT DEBUG]   - Parsed message: '" .. tostring(parsedMessage) .. "'")
                print("[CHAT DEBUG]   - Anonymous: " .. tostring(anonymous))

                return ""
            end)

            timer.Simple(10, function()
                hook.Remove("PlayerSay", "ChatDebugMonitor")
                monitorActive = false
                print("[CHAT DEBUG] PlayerSay monitoring ended")
            end)

            print("[CHAT DEBUG] PlayerSay monitoring active for 10 seconds...")
        end
    end

    function lia.chat.run_full_diagnostic()
        print("\n" .. string.rep("=", 50))
        print("LILIA CHAT SYSTEM DIAGNOSTIC")
        print(string.rep("=", 50))

        lia.chat.debug_net_messages()
        print("")

        lia.chat.debug_chat_types()
        print("")

        lia.chat.debug_commands()
        print("")

        lia.chat.debug_playersay_hook()

        print(string.rep("=", 50))
        print("Diagnostic complete. Check console output above.")
        print("Tell players to try typing in chat while monitoring is active.")
        print(string.rep("=", 50) .. "\n")
    end

    -- Add console command to run diagnostics
    concommand.Add("lia_chat_debug", function(client)
        if IsValid(client) and not client:IsSuperAdmin() then
            client:PrintMessage(HUD_PRINTCONSOLE, "This command requires superadmin privileges.")
            return
        end

        lia.chat.run_full_diagnostic()
    end, nil, "Run chat system diagnostics")

else
    -- Client-side diagnostic functions
    function lia.chat.debug_client_net_messages()
        print("[CHAT DEBUG CLIENT] Testing client net messages...")

        -- Check if network strings are registered
        local netStrings = {
            "msg",
            "cMsg",
            "RegenChat"
        }

        for _, netString in ipairs(netStrings) do
            if util.NetworkStringToID(netString) == 0 then
                print("[CHAT DEBUG CLIENT] ERROR: Network string '" .. netString .. "' is not registered!")
            else
                print("[CHAT DEBUG CLIENT] OK: Network string '" .. netString .. "' is registered")
            end
        end
    end

    function lia.chat.debug_chatbox_panel()
        print("[CHAT DEBUG CLIENT] Checking chatbox panel...")

        if not lia.gui.chat then
            print("[CHAT DEBUG CLIENT] ERROR: lia.gui.chat is nil!")
            return
        end

        if not IsValid(lia.gui.chat) then
            print("[CHAT DEBUG CLIENT] ERROR: lia.gui.chat panel is not valid!")
            return
        end

        print("[CHAT DEBUG CLIENT] OK: Chatbox panel exists and is valid")
        print("[CHAT DEBUG CLIENT]   - Active: " .. tostring(lia.gui.chat.active))
        print("[CHAT DEBUG CLIENT]   - Visible: " .. tostring(lia.gui.chat:IsVisible()))
        print("[CHAT DEBUG CLIENT]   - Position: " .. tostring(lia.gui.chat:GetPos()))
        print("[CHAT DEBUG CLIENT]   - Size: " .. tostring(lia.gui.chat:GetSize()))
    end

    function lia.chat.debug_chat_functions()
        print("[CHAT DEBUG CLIENT] Checking chat functions...")

        -- Check if chat.AddText is hooked
        local addTextHooked = hook.GetTable()["ChatAddText"]
        if addTextHooked and addTextHooked["liaChatOverride"] then
            print("[CHAT DEBUG CLIENT] OK: chat.AddText is properly hooked")
        else
            print("[CHAT DEBUG CLIENT] WARNING: chat.AddText may not be properly hooked")
        end

        -- Test sending a message
        print("[CHAT DEBUG CLIENT] Testing message send...")
        net.Start("msg")
        net.WriteString("DEBUG: Test message from client")
        net.SendToServer()
        print("[CHAT DEBUG CLIENT] Test message sent to server")
    end

    function lia.chat.run_client_diagnostic()
        print("\n" .. string.rep("=", 50))
        print("LILIA CHAT SYSTEM CLIENT DIAGNOSTIC")
        print(string.rep("=", 50))

        lia.chat.debug_client_net_messages()
        print("")

        lia.chat.debug_chatbox_panel()
        print("")

        lia.chat.debug_chat_functions()

        print(string.rep("=", 50))
        print("Client diagnostic complete. Check console output above.")
        print(string.rep("=", 50) .. "\n")
    end

    -- Add console command to run client diagnostics
    concommand.Add("lia_chat_debug_client", function()
        lia.chat.run_client_diagnostic()
    end, nil, "Run chat system client diagnostics")
end

print("[CHAT DEBUG] Chat diagnostic tool loaded. Use 'lia_chat_debug' (server) or 'lia_chat_debug_client' (client) to run diagnostics.")
