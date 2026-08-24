net.Receive("liaMainCharacterSet", function()
    local charID = net.ReadUInt(32)
    charID = tonumber(charID)
    local client = LocalPlayer()
    if IsValid(client) then
        lia.localData = lia.localData or {}
        lia.localData["mainCharacter"] = charID
        client:notifyLocalized("mainCharacterSet")
        if IsValid(lia.gui.character) and lia.gui.character.isLoadMode then lia.gui.character:updateSelectedCharacter() end
    end
end)

net.Receive("liaCharChoose", function()
    local mainMenu = lia.module.get("mainmenu")
    local requests = mainMenu and mainMenu.CharacterChoiceRequests
    local request = requests and table.remove(requests, 1)
    if not request then return end
    local message = net.ReadString()
    if message == "" then
        request.deferred:resolve()
        lia.char.getCharacter(request.id, nil, function(character)
            local client = LocalPlayer()
            if IsValid(client) then client:SetNoDraw(false) end
            hook.Run("CharLoaded", character)
        end)
    else
        request.deferred:reject(message)
    end
end)

net.Receive("liaCharCreate", function()
    local mainMenu = lia.module.get("mainmenu")
    local requests = mainMenu and mainMenu.CharacterCreationRequests
    local deferredRequest = requests and table.remove(requests, 1)
    if not deferredRequest then return end
    local id = net.ReadUInt(32)
    local reason = net.ReadString()
    if id > 0 then
        deferredRequest:resolve(id)
    else
        deferredRequest:reject(reason)
    end
end)

net.Receive("liaStaffDiscordPrompt", function()
    lia.derma.requestString(L("staffCharacterSetup"), L("discordUsernamePrompt"), function(discord)
        if discord and discord:Trim() ~= "" then
            net.Start("liaStaffDiscordResponse")
            net.WriteString(discord:Trim())
            net.SendToServer()
        elseif discord == false then
            net.Start("liaStaffDiscordResponse")
            net.WriteString("not provided")
            net.SendToServer()
        else
            LocalPlayer():notifyErrorLocalized("discordUsernameEmpty")
        end
    end, "", nil)
end)
