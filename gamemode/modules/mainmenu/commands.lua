local MODULE = MODULE

lia.command.add("staffdiscord", {
    desc = "staffdiscordDesc",
    arguments = {lia.type.string},
    onRun = function(client, discord)
        local character = client:getChar()
        if not character or character:getFaction() ~= FACTION_STAFF then
            client:notifyLocalized("noStaffChar")
            return
        end

        client:setLiliaData("staffDiscord", discord)
        local description = "A Staff Character, Discord: " .. discord .. ", SteamID: " .. client:SteamID()
        character:setDesc(description)
        client:notifyLocalized("staffDescUpdated")
    end
})

