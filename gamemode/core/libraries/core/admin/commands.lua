local function handleSetUserGroup(ply, _, args)
    local steamID = string.Trim(args[1] or "")
    local usergroup = string.Trim(args[2] or "")
    local canUse = not IsValid(ply)
    lia.debug("[Permissions]", "Permission Check for function handleSetUserGroup", "isValidPlayer=", tostring(IsValid(ply)), "finalResult=", tostring(canUse))
    if not canUse then
        ply:notifyError("You are not allowed to do this.")
        return
    end

    if steamID == "" or not string.match(steamID, "^STEAM_%d+:%d+:%d+$") then
        if IsValid(ply) then
            ply:notifyError(string.format("Invalid player: %s", steamID))
        else
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Invalid player: %s", steamID) .. "\n")
        end
        return
    end

    if usergroup == "" or not lia.admin.groups[usergroup] then
        if IsValid(ply) then
            ply:notifyError(string.format("Invalid usergroup: %s", usergroup))
        else
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Invalid usergroup: %s", usergroup) .. "\n")
        end
        return
    end

    local target = lia.util.getBySteamID(steamID)
    lia.db.selectOne({"steamName", "userGroup"}, "players", "steamID = " .. lia.db.convertDataType(steamID)):next(function(data)
        if not data then
            if IsValid(ply) then
                ply:notifyError("Player does not exist.")
            else
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Invalid player: %s", steamID) .. "\n")
            end
            return
        end

        lia.db.updateTable({
            userGroup = usergroup
        }, nil, "players", "steamID = " .. lia.db.convertDataType(steamID)):next(function()
            lia.admin.setSteamIDUsergroup(steamID, usergroup, IsValid(ply) and ply:Name() or "Console")
            if IsValid(target) and isfunction(target.getName) then target:notifyInfo(string.format("Usergroup set to %s.", usergroup)) end
            if IsValid(ply) then
                local targetName = isfunction(target and target.getName) and target:getName() or data.steamName or steamID
                ply:notifyInfo(string.format("%s's usergroup has been set to %s by an admin.", targetName, usergroup))
            end

            lia.log.add(IsValid(ply) and ply or nil, "usergroup", IsValid(target) and target or steamID, usergroup)
            local playerName = isfunction(target and target.getName) and target:getName() or data.steamName or steamID
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set " .. playerName .. " (" .. steamID .. ") to usergroup: " .. usergroup .. "\n")
        end)
    end)
end

concommand.Add("plysetgroup", handleSetUserGroup)
concommand.Add("plysetusergroup", handleSetUserGroup)