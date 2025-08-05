﻿lia.command.add("playtime", {
    adminOnly = false,
    privilege = "View Own Playtime",
    desc = "playtimeDesc",
    onRun = function(client)
        local secs = client:getPlayTime()
        if not secs then
            client:notifyLocalized("playtimeError")
            return
        end

        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:notify(L("playtimeYour", h, m, s))
    end
})

lia.command.add("plygetplaytime", {
    adminOnly = true,
    privilege = "View Playtime",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetPlayTimeName",
        Category = "moderationTools",
        SubCategory = "misc",
        Icon = "icon16/time.png"
    },
    desc = "plygetplaytimeDesc",
    onRun = function(client, args)
        if not args[1] then
            client:notifyLocalized("specifyPlayer")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local secs = target:getPlayTime()
        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:ChatPrint(L("playtimeFor", target:Nick(), h, m, s))
    end
})

lia.command.add("adminmode", {
    desc = "adminModeDesc",
    onRun = function(client)
        if not IsValid(client) then return end
        local steamID = client:SteamID()
        if client:isStaffOnDuty() then
            local oldCharID = client:getNetVar("OldCharID", 0)
            if oldCharID > 0 then
                net.Start("AdminModeSwapCharacter")
                net.WriteInt(oldCharID, 32)
                net.Send(client)
                client:setNetVar("OldCharID", nil)
                lia.log.add(client, "adminMode", oldCharID, L("adminModeLogBack"))
            else
                client:notifyLocalized("noPrevChar")
            end
        else
            lia.db.query(string.format("SELECT * FROM lia_characters WHERE steamID = \"%s\"", lia.db.escape(steamID)), function(data)
                for _, row in ipairs(data) do
                    local id = tonumber(row.id)
                    if row.faction == "staff" then
                        client:setNetVar("OldCharID", client:getChar():getID())
                        net.Start("AdminModeSwapCharacter")
                        net.WriteInt(id, 32)
                        net.Send(client)
                        lia.log.add(client, "adminMode", id, L("adminModeLogStaff"))
                        return
                    end
                end

                client:notifyLocalized("noStaffChar")
            end)
        end
    end
})

lia.command.add("managesitrooms", {
    superAdminOnly = true,
    privilege = "Manage SitRooms",
    desc = "manageSitroomsDesc",
    onRun = function(client)
        if not client:hasPrivilege(L("Manage SitRooms")) then return end
        local rooms = lia.data.get("sitrooms", {})
        net.Start("managesitrooms")
        net.WriteTable(rooms)
        net.Send(client)
    end
})

lia.command.add("addsitroom", {
    superAdminOnly = true,
    privilege = "Manage SitRooms",
    desc = "setSitroomDesc",
    onRun = function(client)
        client:requestString(L("enterNamePrompt"), L("enterSitroomPrompt") .. ":", function(name)
            if name == "" then
                client:notifyLocalized("invalidName")
                return
            end

            local rooms = lia.data.get("sitrooms", {})
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", rooms)
            client:notifyLocalized("sitroomSet")
            lia.log.add(client, "sitRoomSet", L("sitroomSetDetail", name, tostring(client:GetPos())), L("logSetSitroom"))
        end)
    end
})

lia.command.add("sendtositroom", {
    adminOnly = true,
    privilege = "Manage SitRooms",
    desc = "sendToSitRoomDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "sendToSitRoom",
        Category = "moderationTools",
        SubCategory = "misc",
        Icon = "icon16/arrow_down.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local rooms = lia.data.get("sitrooms", {})
        local names = {}
        for n in pairs(rooms) do
            names[#names + 1] = n
        end

        if #names == 0 then
            client:notifyLocalized("sitroomNotSet")
            return
        end

        client:requestDropdown(L("chooseSitroomTitle"), L("selectSitroomPrompt") .. ":", names, function(selection)
            local pos = rooms[selection]
            if not pos then
                client:notifyLocalized("sitroomNotSet")
                return
            end

            target:SetPos(pos)
            client:notifyLocalized("sitroomTeleport", target:Nick())
            target:notifyLocalized("sitroomArrive")
            lia.log.add(client, "sendToSitRoom", target:Nick(), selection)
        end)
    end
})

lia.command.add("returnsitroom", {
    adminOnly = true,
    privilege = "Manage SitRooms",
    desc = "returnFromSitroomDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "returnFromSitroom",
        Category = "moderationTools",
        SubCategory = "misc",
        Icon = "icon16/arrow_up.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local prev = target:GetNWVector("previousSitroomPos")
        if not prev then
            client:notifyLocalized("noPreviousSitroomPos")
            return
        end

        target:SetPos(prev)
        client:notifyLocalized("sitroomReturnSuccess", target:Nick())
        if target ~= client then target:notifyLocalized("sitroomReturned") end
        lia.log.add(client, "sitRoomReturn", target:Nick())
    end
})

lia.command.add("charkill", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "charkillDesc",
    onRun = function(client)
        local choices = {}
        for _, ply in player.Iterator() do
            if ply:getChar() then
                choices[#choices + 1] = {
                    ply:Nick(),
                    {
                        name = ply:Nick(),
                        steamID = ply:SteamID(),
                        charID = ply:getChar():getID()
                    }
                }
            end
        end

        local playerKey = L("player", client)
        local reasonKey = L("reason", client)
        local evidenceKey = L("evidence", client)
        client:requestArguments(L("pkActiveMenu", client), {
            [playerKey] = {"table", choices},
            [reasonKey] = "string",
            [evidenceKey] = "string"
        }, function(data)
            local selection = data[playerKey]
            local reason = data[reasonKey]
            local evidence = data[evidenceKey]
            if not (isstring(evidence) and evidence:match("^https?://")) then
                client:notifyLocalized("evidenceInvalidURL")
                return
            end

            lia.db.insertTable({
                player = selection.name,
                reason = reason,
                steamID = selection.steamID,
                charID = selection.charID,
                submitterName = client:Name(),
                submitterSteamID = client:SteamID(),
                timestamp = os.time(),
                evidence = evidence
            }, nil, "permakills")

            for _, ply in player.Iterator() do
                if ply:SteamID() == selection.steamID and ply:getChar() then
                    ply:getChar():ban()
                    break
                end
            end
        end)
    end
})

local function sanitizeForNet(tbl)
    if type(tbl) ~= "table" then return tbl end
    local result = {}
    for k, v in pairs(tbl) do
        local tv = type(v)
        if tv == "table" then
            result[k] = sanitizeForNet(v)
        elseif tv ~= "function" then
            result[k] = v
        end
    end
    return result
end

lia.command.add("charlist", {
    adminOnly = true,
    privilege = "List Characters",
    desc = "charListDesc",
    syntax = "[string Player Or Steam ID]",
    AdminStick = {
        Name = "adminStickOpenCharListName",
        Category = L("player") .. " " .. L("information"),
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local identifier = arguments[1]
        local target
        local steamID
        if identifier then
            target = lia.util.findPlayer(client, identifier)
            if IsValid(target) then
                steamID = target:SteamID()
            elseif identifier:match("^STEAM_%d:%d:%d+$") then
                steamID = identifier
            else
                client:notifyLocalized("targetNotFound")
                return
            end
        else
            steamID = client:SteamID()
        end

        local query = [[SELECT c.*, d.value AS charBanInfo FROM lia_characters AS c LEFT JOIN lia_chardata AS d ON d.charID = c.id AND d.key = 'charBanInfo' WHERE c.steamID = ]] .. lia.db.convertDataType(steamID)
        lia.db.query(query, function(data)
            if not data or #data == 0 then
                client:notifyLocalized("noCharactersForPlayer")
                return
            end

            local sendData = {}
            for _, row in ipairs(data) do
                local charID = tonumber(row.id) or row.id
                local stored = lia.char.loaded[charID]
                local info = stored and stored:getData() or {}
                local allVars = {}
                if stored then
                    for varName in pairs(lia.char.vars) do
                        local value
                        if varName == "data" then
                            value = stored:getData()
                        elseif varName == "var" then
                            value = stored:getVar()
                        else
                            local getter = stored["get" .. varName:sub(1, 1):upper() .. varName:sub(2)]
                            if isfunction(getter) then
                                value = getter(stored)
                            else
                                value = stored.vars and stored.vars[varName]
                            end
                        end

                        allVars[varName] = value
                    end
                end

                local banInfo = info.charBanInfo
                if not banInfo and row.charBanInfo and row.charBanInfo ~= "" then
                    local ok, decoded = pcall(pon.decode, row.charBanInfo)
                    if ok then
                        banInfo = decoded and decoded[1] or {}
                    else
                        banInfo = util.JSONToTable(row.charBanInfo) or {}
                    end
                end

                local bannedVal = stored and stored:getBanned() or tonumber(row.banned) or 0
                local isBanned = bannedVal ~= 0 and (bannedVal == -1 or bannedVal > os.time())

                local entry = {
                    ID = charID,
                    Name = stored and stored:getName() or row.name,
                    Desc = row.desc,
                    Faction = row.faction,
                    Banned = isBanned and L("yes") or L("no"),
                    BanningAdminName = banInfo and banInfo.name or "",
                    BanningAdminSteamID = banInfo and banInfo.steamID or "",
                    BanningAdminRank = banInfo and banInfo.rank or "",
                    Money = row.money,
                    LastUsed = stored and L("onlineNow") or row.lastJoinTime,
                    allVars = allVars
                }

                entry.extraDetails = {}
                hook.Run("CharListExtraDetails", client, entry, stored)
                entry = sanitizeForNet(entry)
                table.insert(sendData, entry)
            end

            sendData = sanitizeForNet(sendData)
            net.Start("DisplayCharList")
            net.WriteTable(sendData)
            net.WriteString(steamID)
            net.Send(client)
        end)
    end
})

lia.command.add("plyban", {
    adminOnly = true,
    privilege = "Ban Player",
    desc = "plyBanDesc",
    syntax = "[player Name] [number Duration optional] [string Reason]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:banPlayer(arguments[3], arguments[2], client)
            client:notifyLocalized("plyBanned")
            lia.log.add(client, "plyBan", target:Name())
        end
    end
})

lia.command.add("plykick", {
    adminOnly = true,
    privilege = "Kick Player",
    desc = "plyKickDesc",
    syntax = "[player Name] [string Reason optional]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Kick(L("kickMessage", arguments[2] or L("genericReason")))
            client:notifyLocalized("plyKicked")
            lia.log.add(client, "plyKick", target:Name())
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plykick",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")
        end
    end
})

lia.command.add("plykill", {
    adminOnly = true,
    privilege = "Kill Player",
    desc = "plyKillDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Kill()
            client:notifyLocalized("plyKilled")
            lia.log.add(client, "plyKill", target:Name())
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plykill",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")
        end
    end
})

lia.command.add("plyunban", {
    adminOnly = true,
    privilege = "Unban Player",
    desc = "plyUnbanDesc",
    syntax = "[string SteamID]",
    onRun = function(client, arguments)
        local steamid = arguments[1]
        if steamid and steamid ~= "" then
            lia.db.query("DELETE FROM lia_bans WHERE playerSteamID = " .. steamid)
            client:notifyLocalized("playerUnbanned")
            lia.log.add(client, "plyUnban", steamid)
        end
    end
})

lia.command.add("plyfreeze", {
    adminOnly = true,
    privilege = "Freeze Player",
    desc = "plyFreezeDesc",
    syntax = "[player Name] [number Duration optional]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Freeze(true)
            local dur = tonumber(arguments[2]) or 0
            if dur > 0 then timer.Simple(dur, function() if IsValid(target) then target:Freeze(false) end end) end
            lia.log.add(client, "plyFreeze", target:Name(), dur)
        end
    end
})

lia.command.add("plyunfreeze", {
    adminOnly = true,
    privilege = "Unfreeze Player",
    desc = "plyUnfreezeDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Freeze(false)
            lia.log.add(client, "plyUnfreeze", target:Name())
        end
    end
})

lia.command.add("plyslay", {
    adminOnly = true,
    privilege = "Slay Player",
    desc = "plySlayDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Kill()
            lia.log.add(client, "plySlay", target:Name())
        end
    end
})

lia.command.add("plyrespawn", {
    adminOnly = true,
    privilege = "Respawn Player",
    desc = "plyRespawnDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Spawn()
            lia.log.add(client, "plyRespawn", target:Name())
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plyrespawn",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")
        end
    end
})

lia.command.add("plyblind", {
    adminOnly = true,
    privilege = "Blind Player",
    desc = "plyBlindDesc",
    syntax = "[player Name] [number Time optional]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            net.Start("blindTarget")
            net.WriteBool(true)
            net.Send(target)
            local dur = tonumber(arguments[2])
            if dur and dur > 0 then
                timer.Create("liaBlind" .. target:SteamID(), dur, 1, function()
                    if IsValid(target) then
                        net.Start("blindTarget")
                        net.WriteBool(false)
                        net.Send(target)
                    end
                end)
            end

            lia.log.add(client, "plyBlind", target:Name(), dur or 0)
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plyblind",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")
        end
    end
})

lia.command.add("plyunblind", {
    adminOnly = true,
    privilege = "Unblind Player",
    desc = "plyUnblindDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            net.Start("blindTarget")
            net.WriteBool(false)
            net.Send(target)
            lia.log.add(client, "plyUnblind", target:Name())
        end
    end
})

lia.command.add("plyblindfade", {
    adminOnly = true,
    privilege = "Blind Fade Player",
    desc = "plyBlindFadeDesc",
    syntax = "[player Name] [number Time optional] [string Color optional] [number FadeIn optional] [number FadeOut optional]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            local duration = tonumber(arguments[2]) or 0
            local colorName = (arguments[3] or "black"):lower()
            local fadeIn = tonumber(arguments[4])
            local fadeOut = tonumber(arguments[5])
            fadeIn = fadeIn or duration * 0.05
            fadeOut = fadeOut or duration * 0.05
            net.Start("blindFade")
            net.WriteBool(colorName == "white")
            net.WriteFloat(duration)
            net.WriteFloat(fadeIn)
            net.WriteFloat(fadeOut)
            net.Send(target)
            lia.log.add(client, "plyBlindFade", target:Name(), duration, colorName)
        end
    end
})

lia.command.add("blindfadeall", {
    adminOnly = true,
    privilege = "Blind Fade All",
    desc = "blindFadeAllDesc",
    syntax = "[number Time optional] [string Color optional] [number FadeIn optional] [number FadeOut optional]",
    onRun = function(_, arguments)
        local duration = tonumber(arguments[1]) or 0
        local colorName = (arguments[2] or "black"):lower()
        local fadeIn = tonumber(arguments[3]) or duration * 0.05
        local fadeOut = tonumber(arguments[4]) or duration * 0.05
        local isWhite = colorName == "white"
        for _, ply in player.Iterator() do
            if not ply:isStaffOnDuty() then
                net.Start("blindFade")
                net.WriteBool(isWhite)
                net.WriteFloat(duration)
                net.WriteFloat(fadeIn)
                net.WriteFloat(fadeOut)
                net.Send(ply)
            end
        end
    end
})

lia.command.add("plygag", {
    adminOnly = true,
    privilege = "Gag Player",
    desc = "plyGagDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:setNetVar("liaGagged", true)
            lia.log.add(client, "plyGag", target:Name())
            hook.Run("PlayerGagged", target, client)
        end
    end
})

lia.command.add("plyungag", {
    adminOnly = true,
    privilege = "Ungag Player",
    desc = "plyUngagDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:setNetVar("liaGagged", false)
            lia.log.add(client, "plyUngag", target:Name())
            hook.Run("PlayerUngagged", target, client)
        end
    end
})

lia.command.add("plymute", {
    adminOnly = true,
    privilege = "Mute Player",
    desc = "plyMuteDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:getChar() then
            target:setLiliaData("VoiceBan", true)
            lia.log.add(client, "plyMute", target:Name())
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plymute",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")

            hook.Run("PlayerMuted", target, client)
        end
    end
})

lia.command.add("plyunmute", {
    adminOnly = true,
    privilege = "Unmute Player",
    desc = "plyUnmuteDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) and target:getChar() then
            target:setLiliaData("VoiceBan", false)
            lia.log.add(client, "plyUnmute", target:Name())
            hook.Run("PlayerUnmuted", target, client)
        end
    end
})

local returnPositions = {}
lia.command.add("plybring", {
    adminOnly = true,
    privilege = "Bring Player",
    desc = "plyBringDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            returnPositions[target] = target:GetPos()
            target:SetPos(client:GetPos() + client:GetForward() * 50)
            lia.log.add(client, "plyBring", target:Name())
        end
    end
})

lia.command.add("plygoto", {
    adminOnly = true,
    privilege = "Goto Player",
    desc = "plyGotoDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            returnPositions[client] = client:GetPos()
            client:SetPos(target:GetPos() + target:GetForward() * 50)
            lia.log.add(client, "plyGoto", target:Name())
        end
    end
})

lia.command.add("plyreturn", {
    adminOnly = true,
    privilege = "Return Player",
    desc = "plyReturnDesc",
    syntax = "[player Name optional]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        target = IsValid(target) and target or client
        local pos = returnPositions[target]
        if pos then
            target:SetPos(pos)
            returnPositions[target] = nil
            lia.log.add(client, "plyReturn", target:Name())
        end
    end
})

lia.command.add("plyjail", {
    adminOnly = true,
    privilege = "Jail Player",
    desc = "plyJailDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Lock()
            target:Freeze(true)
            lia.log.add(client, "plyJail", target:Name())
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plyjail",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")
        end
    end
})

lia.command.add("plyunjail", {
    adminOnly = true,
    privilege = "Unjail Player",
    desc = "plyUnjailDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:UnLock()
            target:Freeze(false)
            lia.log.add(client, "plyUnjail", target:Name())
        end
    end
})

lia.command.add("plycloak", {
    adminOnly = true,
    privilege = "Cloak Player",
    desc = "plyCloakDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:SetNoDraw(true)
            lia.log.add(client, "plyCloak", target:Name())
        end
    end
})

lia.command.add("plyuncloak", {
    adminOnly = true,
    privilege = "Uncloak Player",
    desc = "plyUncloakDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:SetNoDraw(false)
            lia.log.add(client, "plyUncloak", target:Name())
        end
    end
})

lia.command.add("plygod", {
    adminOnly = true,
    privilege = "God Player",
    desc = "plyGodDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:GodEnable()
            lia.log.add(client, "plyGod", target:Name())
        end
    end
})

lia.command.add("plyungod", {
    adminOnly = true,
    privilege = "Ungod Player",
    desc = "plyUngodDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:GodDisable()
            lia.log.add(client, "plyUngod", target:Name())
        end
    end
})

lia.command.add("plyignite", {
    adminOnly = true,
    privilege = "Ignite Player",
    desc = "plyIgniteDesc",
    syntax = "[player Name] [number Duration optional]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            local dur = tonumber(arguments[2]) or 5
            target:Ignite(dur)
            lia.log.add(client, "plyIgnite", target:Name(), dur)
        end
    end
})

lia.command.add("plyextinguish", {
    adminOnly = true,
    privilege = "Extinguish Player",
    desc = "plyExtinguishDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:Extinguish()
            lia.log.add(client, "plyExtinguish", target:Name())
        end
    end
})

lia.command.add("plystrip", {
    adminOnly = true,
    privilege = "Strip Player",
    desc = "plyStripDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.command.findPlayer(client, arguments[1])
        if IsValid(target) then
            target:StripWeapons()
            lia.log.add(client, "plyStrip", target:Name())
            lia.db.insertTable({
                player = target:Name(),
                playerSteamID = target:SteamID(),
                steamID = target:SteamID(),
                action = "plystrip",
                staffName = client:Name(),
                staffSteamID = client:SteamID(),
                timestamp = os.time()
            }, nil, "staffactions")
        end
    end
})

lia.command.add("pktoggle", {
    adminOnly = true,
    privilege = "Toggle Permakill",
    desc = "togglePermakillDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickTogglePermakillName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryBans",
        Icon = "icon16/user_delete.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local character = target:getChar()
        if not character then
            client:notifyLocalized("invalid", L("character"))
            return
        end

        local currentState = character:getMarkedForDeath()
        local newState = not currentState
        character:setMarkedForDeath(newState)
        if newState then
            client:notifyLocalized("pktoggle_true")
        else
            client:notifyLocalized("pktoggle_false")
        end
    end
})

lia.command.add("charunbanoffline", {
    superAdminOnly = true,
    privilege = "Unban Offline",
    desc = "charUnbanOfflineDesc",
    syntax = "[number Char ID]",
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyLocalized("invalidCharID") end
        local banned = lia.char.getCharBanned(charID)
        if banned == nil then return client:notifyLocalized("characterNotFound") end
        lia.char.setCharBanned(charID, 0)
        lia.char.setCharData(charID, "charBanInfo", nil)
        client:notifyLocalized("offlineCharUnbanned", charID)
        lia.log.add(client, "charUnbanOffline", charID)
    end
})

lia.command.add("charbanoffline", {
    superAdminOnly = true,
    privilege = "Ban Offline",
    desc = "charBanOfflineDesc",
    syntax = "[number Char ID]",
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyLocalized("invalidCharID") end
        local banned = lia.char.getCharBanned(charID)
        if banned == nil then return client:notifyLocalized("characterNotFound") end
        lia.char.setCharBanned(charID, -1)
        lia.char.setCharData(charID, "charBanInfo", {
            name = client:Nick(),
            steamID = client:SteamID(),
            rank = client:GetUserGroup()
        })

        for _, ply in player.Iterator() do
            if ply:getChar() and ply:getChar():getID() == charID then
                ply:Kick(L("youHaveBeenBanned"))
                break
            end
        end

        client:notifyLocalized("offlineCharBanned", charID)
        lia.log.add(client, "charBanOffline", charID)
    end
})

lia.command.add("playglobalsound", {
    superAdminOnly = true,
    privilege = "Play Sounds",
    desc = "playGlobalSoundDesc",
    syntax = "[string Sound]",
    onRun = function(client, arguments)
        local sound = arguments[1]
        if not sound or sound == "" then
            client:notifyLocalized("mustSpecifySound")
            return
        end

        for _, target in player.Iterator() do
            target:PlaySound(sound)
        end
    end
})

lia.command.add("playsound", {
    superAdminOnly = true,
    privilege = "Play Sounds",
    desc = "playSoundDesc",
    syntax = "[player Name] [string Sound]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local sound = arguments[2]
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if not sound or sound == "" then
            client:notifyLocalized("noSound")
            return
        end

        target:PlaySound(sound)
    end
})

lia.command.add("returntodeathpos", {
    adminOnly = true,
    privilege = "Return Players",
    desc = "returnToDeathPosDesc",
    onRun = function(client)
        if IsValid(client) and client:Alive() then
            local character = client:getChar()
            local oldPos = character and character:getData("deathPos")
            if oldPos then
                client:SetPos(oldPos)
                character:setData("deathPos", nil)
            else
                client:notifyLocalized("noDeathPosition")
            end
        else
            client:notifyLocalized("waitRespawn")
        end
    end
})

lia.command.add("roll", {
    adminOnly = false,
    desc = "rollDesc",
    onRun = function(client)
        local rollValue = math.random(0, 100)
        lia.chat.send(client, "roll", rollValue)
    end
})

lia.command.add("forcefallover", {
    adminOnly = true,
    privilege = "Force Fallover",
    desc = "forceFalloverDesc",
    syntax = "[player Name] [number Time optional]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if target:getNetVar("FallOverCooldown", false) then
            target:notifyLocalized("cmdCooldown")
            return
        elseif target:IsFrozen() then
            target:notifyLocalized("cmdFrozen")
            return
        elseif not target:Alive() then
            target:notifyLocalized("cmdDead")
            return
        elseif target:hasValidVehicle() then
            target:notifyLocalized("cmdVehicle")
            return
        elseif target:isNoClipping() then
            target:notifyLocalized("cmdNoclip")
            return
        end

        local time = tonumber(arguments[2])
        if not time or time < 1 then
            time = 5
        else
            time = math.Clamp(time, 1, 60)
        end

        target:setNetVar("FallOverCooldown", true)
        if not target:hasRagdoll() then
            target:setRagdolled(true, time)
            timer.Simple(10, function() if IsValid(target) then target:setNetVar("FallOverCooldown", false) end end)
        end
    end
})

lia.command.add("forcegetup", {
    adminOnly = true,
    privilege = "Force GetUp",
    desc = "forceGetUpDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if not target:hasRagdoll() then
            target:notifyLocalized("noRagdoll")
            return
        end

        local entity = target:getRagdoll()
        if IsValid(entity) and entity.liaGrace and entity.liaGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and not entity.liaWakingUp then
            entity.liaWakingUp = true
            target:setAction("gettingUp", 5, function()
                if IsValid(entity) then
                    hook.Run("OnCharGetup", target, entity)
                    SafeRemoveEntity(entity)
                end
            end)
        end
    end
})

lia.command.add("chardesc", {
    adminOnly = false,
    desc = "changeCharDesc",
    syntax = "[string Desc optional]",
    onRun = function(client, arguments)
        local desc = table.concat(arguments, " ")
        if not desc:find("%S") then return client:requestString(L("chgName"), L("chgNameDesc"), function(text) lia.command.run(client, "chardesc", {text}) end, client:getChar() and client:getChar():getDesc() or "") end
        local character = client:getChar()
        if character then character:setDesc(desc) end
        return "@descChanged"
    end
})

lia.command.add("chargetup", {
    adminOnly = false,
    desc = "forceSelfGetUpDesc",
    onRun = function(client)
        if not client:hasRagdoll() then
            client:notifyLocalized("noRagdoll")
            return
        end

        local entity = client:getRagdoll()
        if IsValid(entity) and entity.liaGrace and entity.liaGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and not entity.liaWakingUp then
            entity.liaWakingUp = true
            client:setAction("gettingUp", 5, function()
                if IsValid(entity) then
                    hook.Run("OnCharGetup", client, entity)
                    SafeRemoveEntity(entity)
                end
            end)
        end
    end,
    alias = {"getup"}
})

lia.command.add("fallover", {
    adminOnly = false,
    desc = "fallOverDesc",
    syntax = "[number Time optional]",
    onRun = function(client, arguments)
        if client:getNetVar("FallOverCooldown", false) then
            client:notifyLocalized("cmdCooldown")
            return
        end

        if client:IsFrozen() then
            client:notifyLocalized("cmdFrozen")
            return
        end

        if not client:Alive() then
            client:notifyLocalized("cmdDead")
            return
        end

        if client:hasValidVehicle() then
            client:notifyLocalized("cmdVehicle")
            return
        end

        if client:isNoClipping() then
            client:notifyLocalized("cmdNoclip")
            return
        end

        local t = tonumber(arguments[1])
        if not t or t < 1 then
            t = 5
        else
            t = math.Clamp(t, 1, 60)
        end

        client:setNetVar("FallOverCooldown", true)
        if not client:hasRagdoll() then
            client:setRagdolled(true, t)
            timer.Simple(10, function() if IsValid(client) then client:setNetVar("FallOverCooldown", false) end end)
        end
    end
})

lia.command.add("togglelockcharacters", {
    superAdminOnly = true,
    privilege = "Toggle Character Lock",
    desc = "toggleCharLockDesc",
    onRun = function()
        local newVal = not GetGlobalBool("characterSwapLock", false)
        SetGlobalBool("characterSwapLock", newVal)
        if not newVal then
            return L("characterLockDisabled")
        else
            return L("characterLockEnabled")
        end
    end
})

lia.command.add("checkinventory", {
    adminOnly = true,
    privilege = "Check Inventories",
    desc = "checkInventoryDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickCheckInventoryName",
        Category = "characterManagement",
        SubCategory = "items",
        Icon = "icon16/box.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if target == client then
            client:notifyLocalized("invCheckSelf")
            return
        end

        local inventory = target:getChar():getInv()
        inventory:addAccessRule(function(_, action, _) return action == "transfer" end, 1)
        inventory:addAccessRule(function(_, action, _) return action == "repl" end, 1)
        inventory:sync(client)
        net.Start("OpenInvMenu")
        net.WriteEntity(target)
        net.WriteType(inventory:getID())
        net.Send(client)
    end
})

lia.command.add("flaggive", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "flagGiveDesc",
    syntax = "[player Name] [string Flags]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local flags = arguments[2]
        if not flags then
            local available = ""
            for k in SortedPairs(lia.flag.list) do
                if not target:hasFlags(k) then available = available .. k .. " " end
            end

            available = available:Trim()
            if available == "" then
                client:notifyLocalized("noAvailableFlags")
                return
            end
            return client:requestString(L("give") .. " " .. L("flags"), L("flagGiveDesc"), function(text) lia.command.run(client, "flaggive", {target:Name(), text}) end, available)
        end

        target:giveFlags(flags)
        client:notifyLocalized("flagGive", client:Name(), flags, target:Name())
        lia.log.add(client, "flagGive", target:Name(), flags)
    end,
    alias = {"giveflag", "chargiveflag"}
})

lia.command.add("flaggiveall", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "giveAllFlagsDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGiveAllFlagsName",
        Category = "characterManagement",
        SubCategory = "flagsManagement",
        Icon = "icon16/flag_blue.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if not target:hasFlags(k) then target:giveFlags(k) end
        end

        client:notifyLocalized("gaveAllFlags")
        lia.log.add(client, "flagGiveAll", target:Name())
    end
})

lia.command.add("flagtakeall", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "takeAllFlagsDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickTakeAllFlagsName",
        Category = "characterManagement",
        SubCategory = "flagsManagement",
        Icon = "icon16/flag_green.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if not target:getChar() then
            client:notifyLocalized("invalidTarget")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if target:hasFlags(k) then target:takeFlags(k) end
        end

        client:notifyLocalized("tookAllFlags")
        lia.log.add(client, "flagTakeAll", target:Name())
    end
})

lia.command.add("flagtake", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "flagTakeDesc",
    syntax = "[player Name] [string Flags]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local flags = arguments[2]
        if not flags then
            local currentFlags = target:getFlags()
            return client:requestString(L("take") .. " " .. L("flags"), L("flagTakeDesc"), function(text) lia.command.run(client, "flagtake", {target:Name(), text}) end, table.concat(currentFlags, ", "))
        end

        target:takeFlags(flags)
        client:notifyLocalized("flagTake", client:Name(), flags, target:Name())
        lia.log.add(client, "flagTake", target:Name(), flags)
    end,
    alias = {"takeflag"}
})

lia.command.add("pflaggive", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "playerFlagGiveDesc",
    syntax = "[player Name] [string Flags]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local flags = arguments[2]
        if not flags then
            local available = ""
            for k in SortedPairs(lia.flag.list) do
                if not target:hasPlayerFlags(k) then available = available .. k .. " " end
            end

            available = available:Trim()
            if available == "" then
                client:notifyLocalized("noAvailableFlags")
                return
            end
            return client:requestString(L("give") .. " " .. L("flags"), L("playerFlagGiveDesc"), function(text)
                lia.command.run(client, "pflaggive", {target:Name(), text})
            end, available)
        end

        target:givePlayerFlags(flags)
        client:notifyLocalized("playerFlagGive", client:Name(), flags, target:Name())
        lia.log.add(client, "playerFlagGive", target:Name(), flags)
    end,
    alias = {"givepflag", "playerflaggive"}
})

lia.command.add("pflaggiveall", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "giveAllFlagsDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if not target:hasPlayerFlags(k) then target:givePlayerFlags(k) end
        end

        client:notifyLocalized("gaveAllFlags")
        lia.log.add(client, "playerFlagGiveAll", target:Name())
    end
})

lia.command.add("pflagtakeall", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "takeAllFlagsDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if target:hasPlayerFlags(k) then target:takePlayerFlags(k) end
        end

        client:notifyLocalized("tookAllFlags")
        lia.log.add(client, "playerFlagTakeAll", target:Name())
    end
})

lia.command.add("pflagtake", {
    adminOnly = true,
    privilege = "Manage Flags",
    desc = "playerFlagTakeDesc",
    syntax = "[player Name] [string Flags]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local flags = arguments[2]
        if not flags then
            local currentFlags = target:getPlayerFlags()
            return client:requestString(L("take") .. " " .. L("flags"), L("playerFlagTakeDesc"), function(text)
                lia.command.run(client, "pflagtake", {target:Name(), text})
            end, currentFlags)
        end

        target:takePlayerFlags(flags)
        client:notifyLocalized("playerFlagTake", client:Name(), flags, target:Name())
        lia.log.add(client, "playerFlagTake", target:Name(), flags)
    end,
    alias = {"takepflag", "playerflagtake"}
})
lia.command.add("bringlostitems", {
    superAdminOnly = true,
    privilege = "Manage Items",
    desc = "bringLostItemsDesc",
    onRun = function(client)
        for _, v in ipairs(ents.FindInSphere(client:GetPos(), 500)) do
            if v:isItem() then v:SetPos(client:GetPos()) end
        end
    end
})

lia.command.add("charvoicetoggle", {
    adminOnly = true,
    privilege = "Toggle Voice Ban Character",
    desc = "charVoiceToggleDesc",
    syntax = "[string Name]",
    AdminStick = {
        Name = "toggleVoice",
        Category = "moderationTools",
        SubCategory = "misc",
        Icon = "icon16/sound_mute.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if target == client then
            client:notifyLocalized("cannotMuteSelf")
            return false
        end

        if target:getChar() then
            local isBanned = target:getLiliaData("VoiceBan", false)
            target:setLiliaData("VoiceBan", not isBanned)
            if isBanned then
                client:notifyLocalized("voiceUnmuted", target:Name())
                target:notifyLocalized("voiceUnmutedByAdmin")
            else
                client:notifyLocalized("voiceMuted", target:Name())
                target:notifyLocalized("voiceMutedByAdmin")
            end

            lia.log.add(client, "voiceToggle", target:Name(), isBanned and L("unmuted") or L("muted"))
        else
            client:notifyLocalized("noValidCharacter")
        end
    end
})

lia.command.add("cleanitems", {
    superAdminOnly = true,
    privilege = "Clean Entities",
    desc = "cleanItemsDesc",
    onRun = function(client)
        local count = 0
        for _, v in ipairs(ents.FindByClass("lia_item")) do
            count = count + 1
            SafeRemoveEntity(v)
        end

        client:notifyLocalized("cleaningFinished", L("items"), count)
    end
})

lia.command.add("cleanprops", {
    superAdminOnly = true,
    privilege = "Clean Entities",
    desc = "cleanPropsDesc",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:isProp() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifyLocalized("cleaningFinished", L("props"), count)
    end
})

lia.command.add("cleannpcs", {
    superAdminOnly = true,
    privilege = "Clean Entities",
    desc = "cleanNPCsDesc",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:IsNPC() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifyLocalized("cleaningFinished", L("npcs"), count)
    end
})

lia.command.add("charunban", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "charUnbanDesc",
    syntax = "[string Name or Number ID]",
    onRun = function(client, arguments)
        if (client.liaNextSearch or 0) >= CurTime() then return L("searchingChar") end
        local queryArg = table.concat(arguments, " ")
        local charFound
        local id = tonumber(queryArg)
        if id then
            for _, v in pairs(lia.char.loaded) do
                if v:getID() == id then
                    charFound = v
                    break
                end
            end
        else
            for _, v in pairs(lia.char.loaded) do
                if lia.util.stringMatches(v:getName(), queryArg) then
                    charFound = v
                    break
                end
            end
        end

        if charFound then
            if charFound:isBanned() then
                charFound:setBanned(0)
                charFound:setData("permakilled", nil)
                charFound:setData("charBanInfo", nil)
                charFound:save()
                client:notifyLocalized("charUnBan", client:Name(), charFound:getName())
                lia.log.add(client, "charUnban", charFound:getName(), charFound:getID())
            else
                return L("charNotBanned")
            end
        end

        client.liaNextSearch = CurTime() + 15
        local sqlCondition = id and "id = " .. id or "name LIKE \"%" .. lia.db.escape(queryArg) .. "%\""
        lia.db.query("SELECT id, name FROM lia_characters WHERE " .. sqlCondition .. " LIMIT 1", function(data)
            if data and data[1] then
                local charID = tonumber(data[1].id)
                local banned = lia.char.getCharBanned(charID)
                client.liaNextSearch = 0
                if not banned or banned == 0 then
                    client:notifyLocalized("charNotBanned")
                    return
                end

                lia.char.setCharBanned(charID, 0)
                lia.char.setCharData(charID, "charBanInfo", nil)
                client:notifyLocalized("charUnBan", client:Name(), data[1].name)
                lia.log.add(client, "charUnban", data[1].name, charID)
            end
        end)
    end
})

lia.command.add("clearinv", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "clearInvDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickClearInventoryName",
        Category = "characterManagement",
        SubCategory = "items",
        Icon = "icon16/bin.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:getChar():getInv():wipeItems()
        client:notifyLocalized("resetInv", target:getChar():getName())
    end
})

lia.command.add("charkick", {
    adminOnly = true,
    privilege = "Kick Characters",
    desc = "kickCharDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickKickCharacterName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryBans",
        Icon = "icon16/user_delete.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local character = target:getChar()
        if character then
            for _, targets in player.Iterator() do
                targets:notifyLocalized("charKick", client:Name(), target:Name())
            end

            character:kick()
            lia.log.add(client, "charKick", target:Name(), character:getID())
        else
            client:notifyLocalized("noChar")
        end
    end
})

lia.command.add("freezeallprops", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "freezeAllPropsDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local count = 0
        local tbl = cleanup.GetList(target)[target:UniqueID()] or {}
        for _, propTable in pairs(tbl) do
            for _, ent in pairs(propTable) do
                if IsValid(ent) and IsValid(ent:GetPhysicsObject()) then
                    ent:GetPhysicsObject():EnableMotion(false)
                    count = count + 1
                end
            end
        end

        client:notifyLocalized("freezeAllProps", target:Name())
        client:notify(L("freezeAllPropsCount", count, target:Name()))
    end
})

lia.command.add("charban", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "banCharDesc",
    syntax = "[string Name or Number ID]",
    AdminStick = {
        Name = "banCharacter",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryBans",
        Icon = "icon16/user_red.png"
    },
    onRun = function(client, arguments)
        local queryArg = table.concat(arguments, " ")
        local target
        local id = tonumber(queryArg)
        if id then
            for _, ply in player.Iterator() do
                if IsValid(ply) and ply:getChar() and ply:getChar():getID() == id then
                    target = ply
                    break
                end
            end
        else
            target = lia.util.findPlayer(client, arguments[1])
        end

        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local character = target:getChar()
        if character then
            character:setBanned(-1)
            character:setData("charBanInfo", {
                name = client.steamName and client:steamName() or client:Name(),
                steamID = client:SteamID(),
                rank = client:GetUserGroup()
            })

            character:save()
            character:kick()
            client:notifyLocalized("charBan", client:Name(), target:Name())
            lia.log.add(client, "charBan", target:Name(), character:getID())
        else
            client:notifyLocalized("noChar")
        end
    end
})

lia.command.add("checkmoney", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "checkMoneyDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickCheckMoneyName",
        Category = "characterManagement",
        SubCategory = "items",
        Icon = "icon16/money.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local money = target:getChar():getMoney()
        client:notify(L("playerMoney", target:GetName(), lia.currency.get(money)))
    end
})

lia.command.add("listbodygroups", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "listBodygroupsDesc",
    syntax = "[player Name]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local bodygroups = {}
        for i = 0, target:GetNumBodyGroups() - 1 do
            if target:GetBodygroupCount(i) > 1 then
                table.insert(bodygroups, {
                    group = i,
                    name = target:GetBodygroupName(i),
                    range = "0-" .. target:GetBodygroupCount(i) - 1
                })
            end
        end

        if #bodygroups > 0 then
            lia.util.CreateTableUI(client, L("uiBodygroupsFor", target:Nick()), {
                {
                    name = L("groupID"),
                    field = "group"
                },
                {
                    name = L("name"),
                    field = "name"
                },
                {
                    name = L("range"),
                    field = "range"
                }
            }, bodygroups)
        else
            client:notifyLocalized("noBodygroups")
        end
    end
})

lia.command.add("charsetspeed", {
    adminOnly = true,
    privilege = "Manage Character Stats",
    desc = "setSpeedDesc",
    syntax = "[player Name] [number Speed optional]",
    AdminStick = {
        Name = "adminStickSetCharSpeedName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategorySetInfos",
        Icon = "icon16/lightning.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local speed = tonumber(arguments[2]) or lia.config.get("WalkSpeed")
        target:SetRunSpeed(speed)
    end
})

lia.command.add("charsetmodel", {
    adminOnly = true,
    privilege = "Manage Character Information",
    desc = "setModelDesc",
    syntax = "[player Name] [string Model optional]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local oldModel = target:getChar():getModel()
        target:getChar():setModel(arguments[2] or oldModel)
        target:SetupHands()
        client:notifyLocalized("changeModel", client:Name(), target:Name(), arguments[2] or oldModel)
        lia.log.add(client, "charsetmodel", target:Name(), arguments[2], oldModel)
    end
})

lia.command.add("chargiveitem", {
    superAdminOnly = true,
    privilege = "Manage Items",
    desc = "giveItemDesc",
    syntax = "[player Name] [item Item Name]",
    AdminStick = {
        Name = "adminStickGiveItemName",
        Category = "characterManagement",
        SubCategory = "items",
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local itemName = arguments[2]
        if not itemName or itemName == "" then
            client:notifyLocalized("mustSpecifyItem")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local uniqueID
        for _, v in SortedPairs(lia.item.list) do
            if lia.util.stringMatches(v.name, itemName) or lia.util.stringMatches(v.uniqueID, itemName) then
                uniqueID = v.uniqueID
                break
            end
        end

        if not uniqueID then
            client:notifyLocalized("itemNoExist")
            return
        end

        local inv = target:getChar():getInv()
        local succ, err = inv:add(uniqueID)
        if succ then
            target:notifyLocalized("itemCreated")
            if target ~= client then client:notifyLocalized("itemCreated") end
            lia.log.add(client, "chargiveItem", lia.item.list[uniqueID] and lia.item.list[uniqueID].name or uniqueID, target, L("command"))
        else
            target:notifyLocalized(err or "unknownError")
        end
    end
})

lia.command.add("charsetdesc", {
    adminOnly = true,
    privilege = "Manage Character Information",
    desc = "setDescDesc",
    syntax = "[player Name] [string Description optional]",
    AdminStick = {
        Name = "adminStickSetCharDescName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategorySetInfos",
        Icon = "icon16/user_comment.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if not target:getChar() then
            client:notifyLocalized("noChar")
            return
        end

        local desc = table.concat(arguments, " ", 2)
        if not desc:find("%S") then return client:requestString(L("chgDescTitle", target:Name()), L("enterNewDesc"), function(text) lia.command.run(client, "charsetdesc", {arguments[1], text}) end, target:getChar():getDesc()) end
        target:getChar():setDesc(desc)
        return L("descChangedTarget", client:Name(), target:Name())
    end
})

lia.command.add("charsetname", {
    adminOnly = true,
    privilege = "Manage Character Information",
    desc = "setNameDesc",
    syntax = "[player Name] [string New Name optional]",
    AdminStick = {
        Name = "adminStickSetCharNameName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategorySetInfos",
        Icon = "icon16/user_edit.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local newName = table.concat(arguments, " ", 2)
        if newName == "" then return client:requestString(L("chgName"), L("chgNameDesc"), function(text) lia.command.run(client, "charsetname", {target:Name(), text}) end, target:Name()) end
        target:getChar():setName(newName:gsub("#", "#?"))
        client:notifyLocalized("changeName", client:Name(), target:Name(), newName)
    end
})

lia.command.add("charsetscale", {
    adminOnly = true,
    privilege = "Manage Character Stats",
    desc = "setScaleDesc",
    syntax = "[player Name] [number Scale optional]",
    AdminStick = {
        Name = "adminStickSetCharScaleName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategorySetInfos",
        Icon = "icon16/arrow_out.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local scale = tonumber(arguments[2]) or 1
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:SetModelScale(scale, 0)
        client:notifyLocalized("changedScale", client:Name(), target:Name(), scale)
    end
})

lia.command.add("charsetjump", {
    adminOnly = true,
    privilege = "Manage Character Stats",
    desc = "setJumpDesc",
    syntax = "[player Name] [number Power optional]",
    AdminStick = {
        Name = "adminStickSetCharJumpName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategorySetInfos",
        Icon = "icon16/arrow_up.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local power = tonumber(arguments[2]) or 200
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:SetJumpPower(power)
        client:notifyLocalized("changedJump", client:Name(), target:Name(), power)
    end
})

lia.command.add("charsetbodygroup", {
    adminOnly = true,
    privilege = "Manage Bodygroups",
    desc = "setBodygroupDesc",
    syntax = "[player Name] [string BodyGroup Name] [number Value]",
    onRun = function(client, arguments)
        local name = arguments[1]
        local bodyGroup = arguments[2]
        local value = tonumber(arguments[3])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local index = target:FindBodygroupByName(bodyGroup)
        if index > -1 then
            if value and value < 1 then value = nil end
            local groups = target:getChar():getBodygroups()
            groups[index] = value
            target:getChar():setBodygroups(groups)
            target:SetBodygroup(index, value or 0)
            client:notifyLocalized("changeBodygroups", client:Name(), target:Name(), bodyGroup, value or 0)
        else
            client:notifyLocalized("invalidArg")
        end
    end
})

lia.command.add("charsetskin", {
    adminOnly = true,
    privilege = "Manage Character Stats",
    desc = "setSkinDesc",
    syntax = "[player Name] [number Skin]",
    AdminStick = {
        Name = "adminStickSetCharSkinName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategorySetInfos",
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local name = arguments[1]
        local skin = tonumber(arguments[2])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:getChar():setSkin(skin)
        target:SetSkin(skin or 0)
        client:notifyLocalized("changeSkin", client:Name(), target:Name(), skin or 0)
    end
})

lia.command.add("charsetmoney", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "setMoneyDesc",
    syntax = "[player Name] [number Amount]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local amount = tonumber(arguments[2])
        if not amount or amount < 0 then
            client:notifyLocalized("invalidArg")
            return
        end

        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:getChar():setMoney(math.floor(amount))
        client:notifyLocalized("setMoney", target:Name(), lia.currency.get(math.floor(amount)))
        lia.log.add(client, "charSetMoney", target:Name(), math.floor(amount))
    end
})

lia.command.add("charaddmoney", {
    superAdminOnly = true,
    privilege = "Manage Characters",
    desc = "addMoneyDesc",
    syntax = "[player Name] [number Amount]",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local amount = tonumber(arguments[2])
        if not amount then
            client:notifyLocalized("invalidArg")
            return
        end

        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        amount = math.Round(amount)
        local currentMoney = target:getChar():getMoney()
        target:getChar():setMoney(currentMoney + amount)
        client:notifyLocalized("addMoney", target:Name(), lia.currency.get(amount), lia.currency.get(currentMoney + amount))
        lia.log.add(client, "charAddMoney", target:Name(), amount, currentMoney + amount)
    end,
    alias = {"chargivemoney"}
})

lia.command.add("globalbotsay", {
    superAdminOnly = true,
    privilege = "Bot Say",
    desc = "globalBotSayDesc",
    syntax = "[string Message]",
    onRun = function(client, arguments)
        local message = table.concat(arguments, " ")
        if message == "" then
            client:notifyLocalized("noMessage")
            return
        end

        for _, bot in player.Iterator() do
            if bot:IsBot() then bot:Say(message) end
        end
    end
})

lia.command.add("botsay", {
    superAdminOnly = true,
    privilege = "Bot Say",
    desc = "botSayDesc",
    syntax = "[string Bot Name] [string Message]",
    onRun = function(client, arguments)
        if #arguments < 2 then
            client:notifyLocalized("needBotAndMessage")
            return
        end

        local botName = arguments[1]
        local message = table.concat(arguments, " ", 2)
        local targetBot
        for _, bot in player.Iterator() do
            if bot:IsBot() and string.find(string.lower(bot:Nick()), string.lower(botName)) then
                targetBot = bot
                break
            end
        end

        if not targetBot then
            client:notifyLocalized("botNotFound", botName)
            return
        end

        targetBot:Say(message)
    end
})

lia.command.add("forcesay", {
    superAdminOnly = true,
    privilege = "Force Say",
    desc = "forceSayDesc",
    syntax = "[player Name] [string Message]",
    AdminStick = {
        Name = "Force Say",
        Category = "moderationTools",
        SubCategory = "misc",
        Icon = "icon16/comments.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local message = table.concat(arguments, " ", 2)
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if message == "" then
            client:notifyLocalized("noMessage")
            return
        end

        target:Say(message)
        lia.log.add(client, "forceSay", target:Name(), message)
    end
})

lia.command.add("getmodel", {
    desc = "getModelDesc",
    onRun = function(client)
        local entity = client:getTracedEntity()
        if not IsValid(entity) then
            client:notifyLocalized("noEntityInFront")
            return
        end

        local model = entity:GetModel()
        client:ChatPrint(model and L("modelIs", model) or L("noModelFound"))
    end
})

lia.command.add("pm", {
    desc = "pmDesc",
    syntax = "[player Name] [string Message]",
    onRun = function(client, arguments)
        if not lia.config.get("AllowPMs") then
            client:notifyLocalized("pmsDisabled")
            return
        end

        local targetName = arguments[1]
        local message = table.concat(arguments, " ", 2)
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if not message:find("%S") then
            client:notifyLocalized("noMessage")
            return
        end

        lia.chat.send(client, "pm", message, false, {client, target})
    end
})

lia.command.add("chargetmodel", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "getCharModelDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetCharModelName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        client:ChatPrint(L("charModelIs", target:GetModel()))
    end
})

lia.command.add("checkallmoney", {
    superAdminOnly = true,
    privilege = "Get Character Info",
    desc = "checkAllMoneyDesc",
    onRun = function(client)
        for _, target in player.Iterator() do
            local char = target:getChar()
            if char then client:ChatPrint(L("playerMoney", target:GetName(), lia.currency.get(char:getMoney()))) end
        end
    end
})

lia.command.add("checkflags", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "checkFlagsDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetCharFlagsName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/flag_yellow.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local flags = target:getFlags()
        if flags and #flags > 0 then
            client:ChatPrint(L("charFlags", target:Name(), table.concat(flags, ", ")))
        else
            client:notify(L("noFlags", target:Name()))
        end
    end
})

lia.command.add("chargetname", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "getCharNameDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetCharNameName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/user.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        client:ChatPrint(L("charNameIs", target:getChar():getName()))
    end
})

lia.command.add("chargethealth", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "getHealthDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetCharHealthName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/heart.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        client:ChatPrint(L("charHealthIs", target:Health(), target:GetMaxHealth()))
    end
})

lia.command.add("chargetmoney", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "getMoneyDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetCharMoneyName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/money.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local money = target:getChar():getMoney()
        client:ChatPrint(L("charMoneyIs", lia.currency.get(money)))
    end
})

lia.command.add("chargetinventory", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "getInventoryDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetCharInventoryName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/box.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local inventory = target:getChar():getInv()
        local items = inventory:getItems()
        if not items or table.Count(items) < 1 then
            client:notifyLocalized("charInvEmpty")
            return
        end

        local result = {}
        for _, item in pairs(items) do
            table.insert(result, item.name)
        end

        client:ChatPrint(L("charInventoryIs", table.concat(result, ", ")))
    end
})

lia.command.add("getallinfos", {
    adminOnly = true,
    privilege = "Get Character Info",
    desc = "getAllInfosDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "adminStickGetAllInfosName",
        Category = "characterManagement",
        SubCategory = "adminStickSubCategoryGetInfos",
        Icon = "icon16/table.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyLocalized("noChar")
            return
        end

        local data = lia.char.getCharData(char:getID())
        if not data then
            client:notifyLocalized("noChar")
            return
        end

        lia.admin(L("allInfoFor", char:getName()))
        for column, value in pairs(data) do
            if istable(value) then
                lia.admin(column .. ":")
                PrintTable(value)
            else
                lia.admin(column .. " = " .. tostring(value))
            end
        end

        client:ChatPrint(L("infoPrintedConsole"))
    end
})