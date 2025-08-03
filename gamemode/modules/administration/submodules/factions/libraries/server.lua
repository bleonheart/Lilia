local function SendRoster(client)
    if not IsValid(client) or not client:hasPrivilege("Can Manage Factions") then return end
    local data = {}
    for _, faction in pairs(lia.faction.indices) do
        local members = {}
        for _, ply in ipairs(lia.faction.getPlayers(faction.index)) do
            local char = ply:getChar()
            if char then
                members[#members + 1] = {name = ply:Name(), id = char:getID(), steamID = ply:SteamID()}
            end
        end
        data[faction.name] = members
    end
    lia.net.writeBigTable(client, "liaFactionRosterData", data)
end

net.Receive("liaRequestFactionRoster", function(_, client)
    SendRoster(client)
end)

