local MODULE = MODULE
net.Receive("liaChatboxRequestFilteredWords", function(_, client)
    if not hook.Run("CanManageFilteredWords", client) then return end
    MODULE:SyncFilteredWords(client)
end)

net.Receive("liaChatboxAddFilteredWord", function(_, client)
    if not hook.Run("CanManageFilteredWords", client) then return end
    local word = net.ReadString()
    local success, result = MODULE:AddFilteredWord(word)
    if not success then
        if result == "exists" then
            client:notifyError("That word is already filtered.")
        else
            client:notifyError("Enter a valid word first.")
        end
        return
    end

    client:notifySuccess(string.format("Added filtered word: %s", result))
    MODULE:SyncFilteredWords()
end)

net.Receive("liaChatboxRemoveFilteredWord", function(_, client)
    if not hook.Run("CanManageFilteredWords", client) then return end
    local word = net.ReadString()
    local success, result = MODULE:RemoveFilteredWord(word)
    if not success then
        if result == "missing" then
            client:notifyError("That word is not in the filter list.")
        else
            client:notifyError("Enter a valid word first.")
        end
        return
    end

    client:notifySuccess(string.format("Removed filtered word: %s", result))
    MODULE:SyncFilteredWords()
end)

net.Receive("liaMessageData", function(_, client)
    local text = net.ReadString()
    if not text then return end
    local charlimit = lia.config.get("MaxChatLength")
    if charlimit > 0 then
        if (client.liaNextChat or 0) < CurTime() and text:find("%S") then
            hook.Run("PlayerSay", client, text)
            client.liaNextChat = CurTime() + math.max(#text / 250, 0.4)
        end
    else
        if utf8.len(text) > charlimit then
            client:notifyError(string.format("Your message has been shortened due to being longer than %s characters!", charlimit))
        else
            if (client.liaNextChat or 0) < CurTime() and text:find("%S") then
                hook.Run("PlayerSay", client, text)
                client.liaNextChat = CurTime() + math.max(#text / 250, 0.4)
            end
        end
    end
end)
