net.Receive("liaSetMainCharacter", function(_, client)
    local charID = net.ReadUInt(32)
    if not charID or charID == 0 then return end
    local success, errorMsg = client:setMainCharacter(charID)
    if success then
        net.Start("liaMainCharacterSet")
        net.WriteUInt(charID, 32)
        net.Send(client)
    else
        if errorMsg then client:notifyError(errorMsg) end
    end
end)
net.Receive("liaStaffDiscordResponse", function(_, client)
    local discord = net.ReadString()
    local character = client:getChar()
    if not character or character:getFaction() ~= FACTION_STAFF then return end
    client:setLiliaData("staffDiscord", discord)
    local steamID = client:SteamID()
    local description = string.format("Staff Character - Discord: %s, SteamID: %s", discord, steamID)
    character:setDesc(description)
    client:notifySuccess("Staff character description updated!")
end)
