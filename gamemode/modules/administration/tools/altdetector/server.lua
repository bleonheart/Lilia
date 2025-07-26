util.AddNetworkString("CheckSeed")
function MODULE:PlayerAuthed(client, steamid)
    if client:IsBot() then return end
    local steamID64 = util.SteamIDTo64(steamid)
    local ownerSteamID64 = client:OwnerSteamID64()
    local steamName = client:SteamName()
    local playerSteam64 = client:SteamID64()
    if KnownCheaters[steamID64] or KnownCheaters[ownerSteamID64] then
        lia.applyPunishment(client, L("usingThirdPartyCheats"), false, true, 0)
        lia.notifyAdmin(L("bannedCheaterNotify", steamName, playerSteam64))
        lia.log.add(nil, "cheaterBanned", steamName, playerSteam64)
        return
    end

    local banRecord = lia.admin.isBanned(ownerSteamID64)
    if banRecord then
        if lia.admin.hasBanExpired(ownerSteamID64) then
            lia.admin.removeBan(ownerSteamID64)
        else
            local duration = 0
            if banRecord.duration > 0 then duration = math.max(math.ceil((banRecord.start + banRecord.duration - os.time()) / 60), 0) end
            lia.applyPunishment(client, L("familySharedAccountBlacklisted"), false, true, duration)
            lia.notifyAdmin(L("bannedAltNotify", steamName, playerSteam64))
            lia.log.add(nil, "altBanned", steamName, playerSteam64)
            return
        end
    end

    if lia.config.get("AltsDisabled", false) and client:IsFamilySharedAccount() then
        lia.applyPunishment(client, L("familySharingDisabled"), true, false)
        lia.notifyAdmin(L("kickedAltNotify", steamName, playerSteam64))
    else
        local blacklisted = hook.Run("GetBlackListedSteamIDs") or {}
        if blacklisted[ownerSteamID64] then
            lia.applyPunishment(client, L("familySharedAccountBlacklisted"), false, true, 0)
            lia.notifyAdmin(L("bannedAltNotify", steamName, playerSteam64))
            lia.log.add(nil, "altBanned", steamName, playerSteam64)
        end
    end
end

net.Receive("CheckSeed", function(_, client)
    local sentSteamID = net.ReadString()
    local realSteamID = client:SteamID64()
    if not sentSteamID or sentSteamID == "" or not sentSteamID:match("^%d+$") then
        lia.notifyAdmin(L("steamIDMissing", client:Name(), realSteamID))
        lia.log.add(client, "steamIDMissing", client:Name(), realSteamID)
        return
    end

    if sentSteamID ~= realSteamID and sentSteamID ~= client:OwnerSteamID64() then
        lia.notifyAdmin(L("steamIDMismatch", client:Name(), realSteamID, sentSteamID))
        lia.log.add(client, "steamIDMismatch", client:Name(), realSteamID, sentSteamID)
    end
end)
