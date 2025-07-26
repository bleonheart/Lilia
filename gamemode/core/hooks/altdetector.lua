local KnownCheaters = {
    ["76561198095382821"] = true,
    ["76561198211231421"] = true,
    ["76561199121878196"] = true,
    ["76561199548880910"] = true,
    ["76561198218940592"] = true,
    ["76561198095156121"] = true,
    ["76561198281775968"] = true,
    ["76561197960446376"] = true,
    ["76561199029065559"] = true,
    ["76561198234911980"] = true,
}

if SERVER then
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
else
    function MODULE:InitPostEntity()
        local client = LocalPlayer()
        if not file.Exists("cache", "DATA") then file.CreateDir("cache") end
        if lia.config.get("AltsDisabled", false) and file.Exists("cache/icon643216.png", "DATA") then
            net.Start("CheckSeed")
            net.WriteString(file.Read("cache/icon643216.png", "DATA"))
            net.SendToServer()
        else
            file.Write("cache/icon643216.png", client:SteamID64())
        end
    end
end