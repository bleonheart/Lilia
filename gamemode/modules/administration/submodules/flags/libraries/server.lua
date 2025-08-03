-- luacheck: globals L net player lia

net.Receive("liaRequestAllFlags", function(_, client)
    if not client:hasPrivilege(L("canAccessFlagManagement")) then return end

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

net.Receive("liaModifyFlags", function(_, client)
    if not client:hasPrivilege(L("canAccessFlagManagement")) then return end
    local steamID = net.ReadString()
    local flags = net.ReadString()
    local target = lia.util.findPlayerBySteamID(steamID)
    if not IsValid(target) then return end
    local char = target:getChar()
    if not char then return end
    flags = string.gsub(flags or "", "%s", "")
    char:setFlags(flags)
    client:notifyLocalized("flagSet", client:Name(), target:Name(), flags)
end)

