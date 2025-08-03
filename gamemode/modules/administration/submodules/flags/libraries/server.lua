-- luacheck: globals L net player lia

local privilege = L("canAccessFlagManagement")

net.Receive("liaRequestAllFlags", function(_, client)
    if not client:hasPrivilege(privilege) then return end

    local data = {}
    for _, ply in ipairs(player.GetAll()) do
        local char = ply:getChar()
        data[#data + 1] = {
            name = ply:Name(),
            steamID = ply:SteamID(),
            flags = char and char:getFlags() or ""
        }
    end

    lia.net.writeBigTable(client, "liaAllFlags", data)
end)

