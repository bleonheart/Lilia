if CLIENT then
    concommand.Add("weighpoint_stop", function() hook.Remove("HUDPaint", "WeighPoint") end)
    concommand.Add("lia_scoreboard_reload", function()
        if IsValid(lia.gui.score) then lia.gui.score:Remove() end
        vgui.Create("liaScoreboard")
    end)

    concommand.Add("lia_vgui_cleanup", function()
        for _, v in pairs(vgui.GetWorldPanel():GetChildren()) do
            if not (v.Init and debug.getinfo(v.Init, "Sln").short_src:find("chatbox")) then v:Remove() end
        end
    end)

    concommand.Add("printpos", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] " .. "Error Prefix" .. "This command can only be used by players." .. "\n")
            return
        end

        local pos = client:GetPos()
        local ang = client:GetAngles()
        MsgC(Color(255, 255, 255), "Vector = (" .. math.Round(pos.x, 2) .. ", " .. math.Round(pos.y, 2) .. ", " .. math.Round(pos.z, 2) .. "), \nAngle = (" .. math.Round(ang.x, 2) .. ", " .. math.Round(ang.y, 2) .. ", " .. math.Round(ang.z, 2) .. ")\n")
    end)
end

lia.command.add("plygetplaytime", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Player Playtime",
        ButtonText = "View Play Time",
        Category = "Player Info",
    },
    desc = "Shows the total playtime of the specified character.",
    onRun = function(client, args)
        if not args[1] then
            client:notifyError("Please specify a player.")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local secs = target:getPlayTime()
        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:ChatPrint(string.format("%s's playtime is %s hours, %s minutes, and %s seconds.", target:Nick(), h, m, s))
    end
})

lia.command.add("plycheckid", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Character ID",
        ButtonText = "View Character ID",
        Category = "Player Info",
    },
    desc = "Shows the character ID of the specified player.",
    onRun = function(client, args)
        if not args[1] then
            client:notifyError("Please specify a player.")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyError("Player has no character loaded")
            return
        end

        local charID = char:getID()
        client:ChatPrint(string.format("%s's character ID is: %s", target:Nick(), charID))
    end
})

lia.command.add("checkid", {
    desc = "Displays your current character's ID.",
    onRun = function(client)
        local char = client:getChar()
        if not char then
            client:notifyError("You have no character selected")
            return
        end

        local charID = char:getID()
        client:ChatPrint(string.format("Your character ID is: %s", charID))
    end
})

lia.command.add("managesitrooms", {
    superAdminOnly = true,
    desc = "Manage administration rooms on the current map: view existing administration rooms, teleport to them, rename them, or reposition them.",
    onRun = function(client)
        lia.debug("[Permissions]", "Permission Check for command manageSitRooms", "hasPrivilege(manageSitRooms)=", tostring(client:hasPrivilege("manageSitRooms")), "finalResult=", tostring(client:hasPrivilege("manageSitRooms")))
        if not client:hasPrivilege("manageSitRooms") then return end
        local rooms = lia.data.get("sitrooms", {})
        net.Start("liaManagesitrooms")
        net.WriteTable(rooms)
        net.Send(client)
    end
})

lia.command.add("addsitroom", {
    superAdminOnly = true,
    desc = "Set Administration Room",
    onRun = function(client)
        client:requestString("Enter Name", "Enter the name of the Administration Room" .. ":", function(name)
            if name == "" then
                client:notifyError("Invalid name!")
                return
            end

            local rooms = lia.data.get("sitrooms", {})
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", rooms)
            client:notifySuccess("Administration Room has been set!")
            lia.log.add(client, "sitRoomSet", string.format("Name: %s | Position: %s", name, tostring(client:GetPos())), "Set the administration room location")
        end)
    end
})

lia.command.add("sendtositroom", {
    adminOnly = true,
    desc = "Send a player to an Administration Room",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Send To Administration Room",
        ButtonText = "Send To Sit Room",
        Category = "Teleportation",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local rooms = lia.data.get("sitrooms", {})
        local names = {}
        for n in pairs(rooms) do
            names[#names + 1] = n
        end

        if #names == 0 then
            client:notifyError("No Administration Room has been set!")
            return
        end

        client:requestDropdown("Choose an Administration Room", "Select an Administration Room to send the player to" .. ":", names, function(selection)
            local pos = rooms[selection]
            if not pos then
                client:notifyError("No Administration Room has been set!")
                return
            end

            target:SetPos(pos)
            client:notifySuccess(string.format("You have been teleported to Administration Room: %s.", target:Nick()))
            target:notifyInfo("You have arrived at an Administration Room.")
            lia.log.add(client, "sendToSitRoom", target:Nick(), selection)
        end)
    end
})

lia.command.add("returnsitroom", {
    adminOnly = true,
    desc = "Returns you or the specified player to their previous position before teleporting to an administration room.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Return From Administration Room",
        ButtonText = "Return From Sit Room",
        Category = "Teleportation",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local prev = target.previousSitroomPos
        if not prev then
            client:notifyError("No previous sitroom position")
            return
        end

        target:SetPos(prev)
        client:notifySuccess("Successfully returned to sitroom")
        if target ~= client then target:notifyInfo("Returned to your previous position.") end
        lia.log.add(client, "sitRoomReturn", target:Nick())
    end
})

lia.command.add("charkill", {
    superAdminOnly = true,
    alias = "permakill",
    desc = "Opens the PK case menu to permanently kill a character.",
    arguments = {
        {
            name = "name",
            type = "player"
        }
    },
    AdminStick = {
        Name = "Character Kill (Permakill)",
        ButtonText = "Kill Character",
        Category = "Character Discipline",
    },
    onRun = function(client, args)
        if not args[1] then
            client:notifyError("Please specify a player.")
            return
        end

        local ply = lia.util.findPlayer(client, args[1])
        if not IsValid(ply) then
            client:notifyError("Target not found")
            return
        end

        local char = ply:getChar()
        if not char then
            client:notifyError("Player has no character loaded")
            return
        end

        local isPermakilled = char:getData("permakilled", false)
        if isPermakilled then
            char:setData("permakilled", nil)
            lia.db.delete("permakills", "charID = " .. lia.db.convertDataType(char:getID()))
            client:notifySuccess(string.format("%s removed permakill marking from character %s.", client:Name(), ply:Nick()))
            lia.log.add(client, "charUnkill", ply:Nick(), char:getID())
        else
            local reasonKey = "Reason"
            local evidenceKey = "Evidence"
            client:requestArguments("PK Reason & Evidence", {
                [reasonKey] = "string",
                [evidenceKey] = "string"
            }, function(success, data)
                if not success then return end
                local reason = data[reasonKey]
                local evidence = data[evidenceKey]
                lia.db.insertTable({
                    player = ply:Nick(),
                    reason = reason,
                    steamID = ply:SteamID(),
                    charID = char:getID(),
                    submitterName = client:Name(),
                    submitterSteamID = client:SteamID(),
                    timestamp = os.time(),
                    evidence = evidence
                }, nil, "permakills")

                char:setData("permakilled", true)
                local instantDeathKey = "Kill instantly (auto-ban)"
                client:requestArguments("PK Death Option", {
                    [instantDeathKey] = "boolean"
                }, function(success2, data2)
                    if not success2 then return end
                    local instantDeath = data2[instantDeathKey]
                    if instantDeath then
                        ply:Kill()
                        client:notifySuccess(string.format("%s marked character %s for permakill and killed them instantly.", client:Name(), ply:Nick()))
                        lia.log.add(client, "charKillInstant", ply:Nick(), char:getID(), reason)
                    else
                        client:notifySuccess(string.format("%s marked character %s for permakill.", client:Name(), ply:Nick()))
                        lia.log.add(client, "charKill", ply:Nick(), char:getID(), reason)
                    end
                end)
            end)
        end
    end
})

lia.command.add("plyban", {
    adminOnly = true,
    desc = "Ban a player from the server for a duration.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "duration",
            type = "string",
            optional = true
        },
        {
            name = "reason",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Ban Player",
        ButtonText = "Ban Player",
        Category = "Player Punishment",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ban", arguments[1], arguments[2], arguments[3], client) end
})

lia.command.add("plykick", {
    adminOnly = true,
    desc = "Kick a player from the server.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "reason",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Kick Player",
        ButtonText = "Kick Player",
        Category = "Player Punishment",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("kick", arguments[1], nil, arguments[2], client) end
})

lia.command.add("plykill", {
    adminOnly = true,
    desc = "Kill the specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Kill Player",
        ButtonText = "Kill Player",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("kill", arguments[1], nil, nil, client) end
})

lia.command.add("plyunban", {
    adminOnly = true,
    desc = "Remove a player's ban by SteamID.",
    arguments = {
        {
            name = "steamid",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local steamid = arguments[1]
        if steamid and steamid ~= "" then
            lia.db.query("DELETE FROM lia_bans WHERE playerSteamID = " .. lia.db.convertDataType(steamid))
            client:notifySuccess("Player unbanned")
            lia.log.add(client, "plyUnban", steamid)
        end
    end
})

lia.command.add("plyfreeze", {
    adminOnly = true,
    desc = "Freeze a player for an optional duration.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "duration",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("freeze", arguments[1], arguments[2], nil, client) end
})

lia.command.add("plyunfreeze", {
    adminOnly = true,
    desc = "Unfreeze a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unfreeze", arguments[1], nil, nil, client) end
})

lia.command.add("plyslay", {
    adminOnly = true,
    desc = "Slay a player instantly.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("slay", arguments[1], nil, nil, client) end
})

lia.command.add("plyblind", {
    adminOnly = true,
    desc = "Blind a player with a black screen.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "time",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("blind", arguments[1], arguments[2], nil, client) end
})

lia.command.add("plyunblind", {
    adminOnly = true,
    desc = "Remove blindness from a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unblind", arguments[1], nil, nil, client) end
})

lia.command.add("plyblindfade", {
    adminOnly = true,
    desc = "Fade a player's screen to a color.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "time",
            type = "string",
            optional = true
        },
        {
            name = "color",
            type = "string",
            optional = true
        },
        {
            name = "fadein",
            type = "string",
            optional = true
        },
        {
            name = "fadeout",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Blind Player (Fade)",
        ButtonText = "Blindfade Player",
        Category = "Player State",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if IsValid(target) then
            if lia.admin.isProtectedStaffTarget("blind", target) then
                lia.admin.notifyProtectedStaffTarget(client)
                return
            end

            local duration = tonumber(arguments[2]) or 0
            local colorName = (arguments[3] or "black"):lower()
            local fadeIn = tonumber(arguments[4])
            local fadeOut = tonumber(arguments[5])
            fadeIn = fadeIn or duration * 0.05
            fadeOut = fadeOut or duration * 0.05
            net.Start("liaBlindFade")
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
    desc = "Fade all non-staff players' screens.",
    arguments = {
        {
            name = "time",
            type = "string",
            optional = true
        },
        {
            name = "color",
            type = "string",
            optional = true
        },
        {
            name = "fadein",
            type = "string",
            optional = true
        },
        {
            name = "fadeout",
            type = "string",
            optional = true
        },
    },
    onRun = function(_, arguments)
        local duration = tonumber(arguments[1]) or 0
        local colorName = (arguments[2] or "black"):lower()
        local fadeIn = tonumber(arguments[3]) or duration * 0.05
        local fadeOut = tonumber(arguments[4]) or duration * 0.05
        local isWhite = colorName == "white"
        for _, ply in player.Iterator() do
            local isStaffOnDuty = ply:isStaffOnDuty()
            lia.debug("[Permissions]", "Permission Check for command blindfadeall player recipient", "targetPlayer=", tostring(ply:Name()), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(not isStaffOnDuty))
            if not isStaffOnDuty then
                net.Start("liaBlindFade")
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
    desc = "Gag a player, blocking voice chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("gag", arguments[1], nil, nil, client) end
})

lia.command.add("plyungag", {
    adminOnly = true,
    desc = "Ungag a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ungag", arguments[1], nil, nil, client) end
})

lia.command.add("plymute", {
    adminOnly = true,
    desc = "Mute a player's voice chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("mute", arguments[1], nil, nil, client) end
})

lia.command.add("plyunmute", {
    adminOnly = true,
    desc = "Unmute a player's voice chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unmute", arguments[1], nil, nil, client) end
})

lia.command.add("plybring", {
    adminOnly = true,
    desc = "Teleport a player to you.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("bring", arguments[1], nil, nil, client) end
})

lia.command.add("plygoto", {
    adminOnly = true,
    desc = "Teleport yourself to a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("goto", arguments[1], nil, nil, client) end
})

lia.command.add("plyreturn", {
    adminOnly = true,
    desc = "Return a player to their previous position.",
    arguments = {
        {
            name = "name",
            type = "player",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("return", arguments[1] or client:Name(), nil, nil, client) end
})

lia.command.add("plyjail", {
    adminOnly = true,
    desc = "Jail a player by locking and freezing them.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("jail", arguments[1], nil, nil, client) end
})

lia.command.add("plyunjail", {
    adminOnly = true,
    desc = "Release a jailed player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unjail", arguments[1], nil, nil, client) end
})

lia.command.add("plycloak", {
    adminOnly = true,
    desc = "Make a player invisible.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Cloak Player",
        ButtonText = "Cloak Player",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("cloak", arguments[1], nil, nil, client) end
})

lia.command.add("plyuncloak", {
    adminOnly = true,
    desc = "Remove invisibility from a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Uncloak Player",
        ButtonText = "Uncloak Player",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("uncloak", arguments[1], nil, nil, client) end
})

lia.command.add("plygod", {
    adminOnly = true,
    desc = "Enable god mode on a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Give God Mode",
        ButtonText = "Enable Godmode",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("god", arguments[1], nil, nil, client) end
})

lia.command.add("plyungod", {
    adminOnly = true,
    desc = "Disable a player's god mode.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Remove God Mode",
        ButtonText = "Disable Godmode",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ungod", arguments[1], nil, nil, client) end
})

lia.command.add("plyignite", {
    adminOnly = true,
    desc = "Set a player on fire.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "duration",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ignite", arguments[1], arguments[2], nil, client) end
})

lia.command.add("plyextinguish", {
    adminOnly = true,
    desc = "Extinguish the specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("extinguish", arguments[1], nil, nil, client) end
})

lia.command.add("plystrip", {
    adminOnly = true,
    desc = "Strip all weapons from a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Strip Weapons",
        ButtonText = "Strip Weapons",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("strip", arguments[1], nil, nil, client) end
})

if SERVER then
    local function registerAdminConsoleCommand(name, callback)
        concommand.Add("lia_" .. name, function(client, _, arguments) callback(client, arguments or {}) end)
    end

    local function hasConsoleCommandAccess(client, privilegeID)
        if not IsValid(client) then return true end
        if lia.admin.hasAccess(client, privilegeID) then return true end
        client:notifyError("You are not allowed to do this.")
        lia.log.add(client, "unauthorizedCommand", privilegeID)
        return false
    end

    local function runTargetedAdminCommand(commandID, client, arguments, durationIndex, reasonStartIndex)
        if not hasConsoleCommandAccess(client, lia.admin.getCommandPrivilegeID(commandID)) then return end
        local target = arguments[1]
        if not target or target == "" then
            if IsValid(client) then
                client:notifyError("Target not found")
            else
                print("[Lilia] Missing target.")
            end
            return
        end

        local duration = durationIndex and arguments[durationIndex] or nil
        local reason = reasonStartIndex and table.concat(arguments, " ", reasonStartIndex) or nil
        if reason == "" then reason = nil end
        lia.admin.serverExecCommand(commandID, target, duration, reason, client)
    end

    registerAdminConsoleCommand("plyban", function(client, arguments) runTargetedAdminCommand("ban", client, arguments, 2, 3) end)
    registerAdminConsoleCommand("plykick", function(client, arguments) runTargetedAdminCommand("kick", client, arguments, nil, 2) end)
    registerAdminConsoleCommand("plykill", function(client, arguments) runTargetedAdminCommand("kill", client, arguments) end)
    registerAdminConsoleCommand("plyunban", function(client, arguments)
        if not hasConsoleCommandAccess(client, lia.admin.getCommandPrivilegeID("unban")) then return end
        local steamid = arguments[1]
        if not steamid or steamid == "" then
            if IsValid(client) then
                client:notifyError("Target not found")
            else
                print("[Lilia] Missing SteamID.")
            end
            return
        end

        lia.db.query("DELETE FROM lia_bans WHERE playerSteamID = " .. lia.db.convertDataType(steamid))
        if IsValid(client) then
            client:notifySuccess("Player unbanned")
            lia.log.add(client, "plyUnban", steamid)
        else
            print("[Lilia] Unbanned " .. steamid .. ".")
            lia.log.add(nil, "command", "Console unbanned " .. steamid)
        end
    end)

    registerAdminConsoleCommand("plyfreeze", function(client, arguments) runTargetedAdminCommand("freeze", client, arguments, 2) end)
    registerAdminConsoleCommand("plyunfreeze", function(client, arguments) runTargetedAdminCommand("unfreeze", client, arguments) end)
    registerAdminConsoleCommand("plyslay", function(client, arguments) runTargetedAdminCommand("slay", client, arguments) end)
    registerAdminConsoleCommand("plyrespawn", function(client, arguments) runTargetedAdminCommand("respawn", client, arguments) end)
    registerAdminConsoleCommand("plyblind", function(client, arguments) runTargetedAdminCommand("blind", client, arguments, 2) end)
    registerAdminConsoleCommand("plyunblind", function(client, arguments) runTargetedAdminCommand("unblind", client, arguments) end)
    registerAdminConsoleCommand("plygag", function(client, arguments) runTargetedAdminCommand("gag", client, arguments) end)
    registerAdminConsoleCommand("plyungag", function(client, arguments) runTargetedAdminCommand("ungag", client, arguments) end)
    registerAdminConsoleCommand("plymute", function(client, arguments) runTargetedAdminCommand("mute", client, arguments) end)
    registerAdminConsoleCommand("plyunmute", function(client, arguments) runTargetedAdminCommand("unmute", client, arguments) end)
    registerAdminConsoleCommand("plybring", function(client, arguments) runTargetedAdminCommand("bring", client, arguments) end)
    registerAdminConsoleCommand("plygoto", function(client, arguments) runTargetedAdminCommand("goto", client, arguments) end)
    registerAdminConsoleCommand("plyreturn", function(client, arguments)
        if not arguments[1] and IsValid(client) then arguments[1] = client:Name() end
        runTargetedAdminCommand("return", client, arguments)
    end)

    registerAdminConsoleCommand("plyjail", function(client, arguments) runTargetedAdminCommand("jail", client, arguments) end)
    registerAdminConsoleCommand("plyunjail", function(client, arguments) runTargetedAdminCommand("unjail", client, arguments) end)
    registerAdminConsoleCommand("plycloak", function(client, arguments) runTargetedAdminCommand("cloak", client, arguments) end)
    registerAdminConsoleCommand("plyuncloak", function(client, arguments) runTargetedAdminCommand("uncloak", client, arguments) end)
    registerAdminConsoleCommand("plygod", function(client, arguments) runTargetedAdminCommand("god", client, arguments) end)
    registerAdminConsoleCommand("plyungod", function(client, arguments) runTargetedAdminCommand("ungod", client, arguments) end)
    registerAdminConsoleCommand("plyignite", function(client, arguments) runTargetedAdminCommand("ignite", client, arguments, 2) end)
    registerAdminConsoleCommand("plyextinguish", function(client, arguments) runTargetedAdminCommand("extinguish", client, arguments) end)
    registerAdminConsoleCommand("plystrip", function(client, arguments) runTargetedAdminCommand("strip", client, arguments) end)
    registerAdminConsoleCommand("plyblindfade", function(client, arguments)
        if not hasConsoleCommandAccess(client, "command_blind") then return end
        local target = lia.util.findPlayer(client, arguments[1])
        if not IsValid(target) then
            if not IsValid(client) then print("[Lilia] Target not found.") end
            return
        end

        if lia.admin.isProtectedStaffTarget("blind", target) then
            if IsValid(client) then
                lia.admin.notifyProtectedStaffTarget(client)
            else
                print("[Lilia] You cannot use targeted admin commands on players in the staff faction.")
            end
            return
        end

        local duration = tonumber(arguments[2]) or 0
        local colorName = (arguments[3] or "black"):lower()
        local fadeIn = tonumber(arguments[4]) or duration * 0.05
        local fadeOut = tonumber(arguments[5]) or duration * 0.05
        net.Start("liaBlindFade")
        net.WriteBool(colorName == "white")
        net.WriteFloat(duration)
        net.WriteFloat(fadeIn)
        net.WriteFloat(fadeOut)
        net.Send(target)
        if IsValid(client) then
            lia.log.add(client, "plyBlindFade", target:Name(), duration, colorName)
        else
            print(string.format("[Lilia] Applied blind fade to %s.", target:Name()))
            lia.log.add(nil, "command", string.format("Console applied blind fade to %s for %s seconds (%s).", target:Name(), tostring(duration), colorName))
        end
    end)

    registerAdminConsoleCommand("blindfadeall", function(client, arguments)
        if not hasConsoleCommandAccess(client, "command_blind") then return end
        local duration = tonumber(arguments[1]) or 0
        local colorName = (arguments[2] or "black"):lower()
        local fadeIn = tonumber(arguments[3]) or duration * 0.05
        local fadeOut = tonumber(arguments[4]) or duration * 0.05
        local isWhite = colorName == "white"
        for _, ply in player.Iterator() do
            local isStaffOnDuty = ply:isStaffOnDuty()
            lia.debug("[Permissions]", "Permission Check for admin console blindfadeall recipient", "targetPlayer=", tostring(ply:Name()), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(not isStaffOnDuty))
            if not isStaffOnDuty then
                net.Start("liaBlindFade")
                net.WriteBool(isWhite)
                net.WriteFloat(duration)
                net.WriteFloat(fadeIn)
                net.WriteFloat(fadeOut)
                net.Send(ply)
            end
        end

        if IsValid(client) then
            lia.log.add(client, "blindFadeAll", duration, colorName)
        else
            print("[Lilia] Applied blind fade to all non-staff-faction players.")
            lia.log.add(nil, "command", string.format("Console applied blind fade to all non-staff-faction players for %s seconds (%s).", tostring(duration), colorName))
        end
    end)

    registerAdminConsoleCommand("charvoicetoggle", function(client, arguments)
        if not hasConsoleCommandAccess(client, "command_mute") then return end
        local target = lia.util.findPlayer(client, arguments[1])
        if not IsValid(target) then
            if not IsValid(client) then print("[Lilia] Target not found.") end
            return
        end

        if lia.admin.isProtectedStaffTarget("mute", target) then
            if IsValid(client) then
                lia.admin.notifyProtectedStaffTarget(client)
            else
                print("[Lilia] You cannot use targeted admin commands on players in the staff faction.")
            end
            return
        end

        if IsValid(client) and target == client then
            client:notifyError("You cannot toggle mute on yourself.")
            return
        end

        if not target:getChar() then
            if IsValid(client) then
                client:notifyError("The target does not have a valid character.")
            else
                print("[Lilia] That player does not have a valid character.")
            end
            return
        end

        local isMuted = target:getLiliaData("liaMuted", false)
        target:setLiliaData("liaMuted", not isMuted)
        if IsValid(client) then
            if isMuted then
                client:notifySuccess(string.format("%s has been unmuted for text chat.", target:Name()))
                target:notifyInfo("You have been unmuted for text chat by an admin.")
            else
                client:notifySuccess(string.format("%s has been muted for text chat.", target:Name()))
                target:notifyWarning("You have been muted for text chat by an admin.")
            end

            lia.log.add(client, "textToggle", target:Name(), isMuted and "Unmuted" or "Muted")
        else
            if isMuted then
                print(string.format("[Lilia] Unmuted %s for text chat.", target:Name()))
            else
                print(string.format("[Lilia] Muted %s for text chat.", target:Name()))
            end

            lia.log.add(nil, "command", string.format("Console toggled text mute for %s to %s.", target:Name(), isMuted and "unmuted" or "muted"))
        end
    end)

    lia.command.add("charunbanoffline", {
        superAdminOnly = true,
        desc = "Unban an offline character using their Char ID.",
        arguments = {
            {
                name = "charId",
                type = "string"
            },
        },
        onRun = function(client, arguments)
            local charID = tonumber(arguments[1])
            if not charID then return client:notifyError("Invalid character ID.") end
            lia.db.selectOne("id", "characters", {
                id = charID
            }):next(function(result)
                if not result then
                    client:notifyError("Character not found.")
                    return
                end

                lia.char.setCharDatabase(charID, "banned", 0)
                lia.char.setCharDatabase(charID, "charBanInfo", nil)
                client:notifySuccess(string.format("Offline character ID %s has been unbanned.", charID))
                lia.log.add(client, "charUnbanOffline", charID)
            end):catch(function(message) client:notifyError("Database error: " .. tostring(message)) end)
        end
    })

    lia.command.add("charbanoffline", {
        superAdminOnly = true,
        desc = "Ban an offline character using their Char ID.",
        arguments = {
            {
                name = "charId",
                type = "string"
            },
        },
        onRun = function(client, arguments)
            local charID = tonumber(arguments[1])
            if not charID then return client:notifyError("Invalid character ID.") end
            lia.db.selectOne("id", "characters", {
                id = charID
            }):next(function(result)
                if not result then
                    client:notifyError("Character not found.")
                    return
                end

                lia.char.setCharDatabase(charID, "banned", -1)
                lia.char.setCharDatabase(charID, "charBanInfo", {
                    name = client:Nick(),
                    steamID = client:SteamID(),
                    rank = client:GetUserGroup()
                })

                for _, ply in player.Iterator() do
                    if ply:getChar() and ply:getChar():getID() == charID then
                        ply:Kick("You have been banned.")
                        break
                    end
                end

                client:notifySuccess(string.format("Offline character ID %s has been banned.", charID))
                lia.log.add(client, "charBanOffline", charID)
            end):catch(function(message) client:notifyError("Database error: " .. tostring(message)) end)
        end
    })
end

lia.command.add("playglobalsound", {
    superAdminOnly = true,
    desc = "Play a global sound for all players.",
    arguments = {
        {
            name = "sound",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local sound = arguments[1]
        if not sound or sound == "" then
            client:notifyError("You must specify a sound path or name.")
            return
        end

        for _, target in player.Iterator() do
            target:PlaySound(sound)
        end
    end
})

lia.command.add("plyspectate", {
    adminOnly = true,
    desc = "Spectate a player in third person.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Spectate Player",
        ButtonText = "Spectate Player",
        Category = "Observation",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target == client then
            client:notifyError("You cannot spectate yourself")
            return
        end

        if target.liaSpectating then
            client:notifyError("That player is already being spectated")
            return
        end

        client.returnPos = client:GetPos()
        client.returnAng = client:EyeAngles()
        client:Spectate(OBS_MODE_CHASE)
        client:SpectateEntity(target)
        client:GodEnable()
        client.liaSpectating = true
        client:notifySuccess(string.format("You are now spectating %s.", target:Nick()))
        target:notifyInfo(string.format("%s is now spectating you.", client:Nick()))
        lia.log.add(client, "plySpectate", target:Nick())
    end
})

lia.command.add("stopspectate", {
    adminOnly = true,
    desc = "Stop spectating and return to normal view.",
    onRun = function(client)
        if not client.liaSpectating then
            client:notifyError("You are not currently spectating anyone")
            return
        end

        client:UnSpectate()
        client:GodDisable()
        client.liaSpectating = false
        local returnPos = client.returnPos
        local returnAng = client.returnAng
        if returnPos then
            client:SetPos(returnPos)
            client.returnPos = nil
        end

        if returnAng then
            client:SetEyeAngles(returnAng)
            client.returnAng = nil
        end

        client:Give("weapon_physgun")
        client:Give("weapon_physcannon")
        client:Give("gmod_tool")
        client:notifySuccess("You have stopped spectating.")
        lia.log.add(client, "stopSpectate")
    end
})

lia.command.add("playsound", {
    superAdminOnly = true,
    desc = "Play the specified sound on a specific player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "sound",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local sound = arguments[2]
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not sound or sound == "" then
            client:notifyError("You must specify a sound path or name.")
            return
        end

        target:PlaySound(sound)
    end
})

lia.command.add("togglelockcharacters", {
    superAdminOnly = true,
    desc = "Toggle whether players can swap characters.",
    onRun = function()
        local newVal = not GetGlobalBool("characterSwapLock", false)
        SetGlobalBool("characterSwapLock", newVal)
        if not newVal then
            return "Now the players will be able to change character"
        else
            return "Now the players won't be able to change character until the server is restarted or until you re-enable it"
        end
    end
})

lia.command.add("checkinventory", {
    adminOnly = true,
    desc = "Check another player's inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Inventory",
        ButtonText = "View Inventory",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target == client then
            client:notifyError("This isn't meant for checking your own inventory.")
            return
        end

        local inventory = target:getChar():getInv()
        inventory:addAccessRule(function(_, action) return action == "transfer" end, 1)
        inventory:addAccessRule(function(_, action) return action == "repl" end, 1)
        inventory:sync(client)
        net.Start("liaOpenInvMenu")
        net.WriteEntity(target)
        net.WriteType(inventory:getID())
        net.Send(client)
    end
})

lia.command.add("flaggive", {
    adminOnly = true,
    desc = "Give the following flags to the player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "flags",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
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
                client:notifyInfo("No available flags to give.")
                return
            end
            return client:requestString("Give" .. " " .. "Flags", "Give the following flags to the player.", function(text) lia.command.run(client, "flaggive", {target:Name(), text}) end, available)
        end

        target:giveFlags(flags)
        client:notifySuccess(string.format("%s has given %s '%s' flags.", client:Name(), flags, target:Name()))
        lia.log.add(client, "flagGive", target:Name(), flags)
    end,
    alias = {"giveflag", "chargiveflag"}
})

lia.command.add("flaggiveall", {
    adminOnly = true,
    desc = "Give all possible flags to a character.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if not target:hasFlags(k) then target:giveFlags(k) end
        end

        client:notifySuccess("You gave this player all flags!")
        lia.log.add(client, "flagGiveAll", target:Name())
    end
})

lia.command.add("flagtakeall", {
    adminOnly = true,
    desc = "Remove all flags from a character.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not target:getChar() then
            client:notifyError("Invalid Target!")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if target:hasFlags(k) then target:takeFlags(k) end
        end

        client:notifySuccess("You took this player's flags!")
        lia.log.add(client, "flagTakeAll", target:Name())
    end
})

lia.command.add("flagtake", {
    adminOnly = true,
    desc = "Remove the following flags from the player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "flags",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local flags = arguments[2]
        if not flags then
            local currentFlags = target:getFlags()
            return client:requestString("Take" .. " " .. "Flags", "Remove the following flags from the player.", function(text) lia.command.run(client, "flagtake", {target:Name(), text}) end, table.concat(currentFlags, ", "))
        end

        target:takeFlags(flags)
        client:notifySuccess(string.format("%s has taken '%s' flags from %s.", client:Name(), flags, target:Name()))
        lia.log.add(client, "flagTake", target:Name(), flags)
    end,
    alias = {"takeflag"}
})

lia.command.add("bringlostitems", {
    superAdminOnly = true,
    desc = "Bring lost items in a 500 radius to your position.",
    onRun = function(client)
        for _, v in ipairs(ents.FindInSphere(client:GetPos(), 500)) do
            if v:isItem() then v:SetPos(client:GetPos()) end
        end
    end
})

lia.command.add("charvoicetoggle", {
    adminOnly = true,
    desc = "Toggles voice chat ban for the specified character.",
    arguments = {
        {
            name = "name",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Toggle Voice",
        ButtonText = "Toggle Voice",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if lia.admin.isProtectedStaffTarget("mute", target) then
            lia.admin.notifyProtectedStaffTarget(client)
            return false
        end

        if target == client then
            client:notifyError("You cannot toggle mute on yourself.")
            return false
        end

        if target:getChar() then
            local isMuted = target:getLiliaData("liaMuted", false)
            target:setLiliaData("liaMuted", not isMuted)
            if isMuted then
                client:notifySuccess(string.format("%s has been unmuted for text chat.", target:Name()))
                target:notifyInfo("You have been unmuted for text chat by an admin.")
            else
                client:notifySuccess(string.format("%s has been muted for text chat.", target:Name()))
                target:notifyWarning("You have been muted for text chat by an admin.")
            end

            lia.log.add(client, "textToggle", target:Name(), isMuted and "Unmuted" or "Muted")
        else
            client:notifyError("The target does not have a valid character.")
        end
    end
})

lia.command.add("cleanitems", {
    superAdminOnly = true,
    desc = "Remove all item entities from the map.",
    onRun = function(client)
        local count = 0
        for _, v in ipairs(ents.FindByClass("lia_item")) do
            count = count + 1
            SafeRemoveEntity(v)
        end

        client:notifySuccess(string.format("You cleaned up %s: %s entities removed.", "Items", count))
    end
})

lia.command.add("cleanprops", {
    superAdminOnly = true,
    desc = "Remove all prop entities from the map.",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:isProp() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccess(string.format("You cleaned up %s: %s entities removed.", "Props", count))
    end
})

lia.command.add("cleanragdolls", {
    superAdminOnly = true,
    desc = "Remove all ragdoll entities from the map except active player ragdolls.",
    onRun = function(client)
        local count = 0
        local protectedRagdolls = {}
        for _, ply in player.Iterator() do
            local ragdoll = ply:getRagdoll()
            if IsValid(ragdoll) then protectedRagdolls[ragdoll] = true end
        end

        for _, entity in ipairs(ents.FindByClass("prop_ragdoll")) do
            if IsValid(entity) and not protectedRagdolls[entity] then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccess("You cleaned up ragdolls: " .. count .. " entities removed.")
    end
})

lia.command.add("resetmapprops", {
    superAdminOnly = true,
    desc = "Restore all map-created props by performing a map cleanup.",
    onRun = function(client)
        local started = SysTime()
        client:notifyInfo("Map cleanup started; map props will be restored shortly.")
        game.CleanUpMap(false, nil, function()
            if not IsValid(client) then return end
            local elapsed = math.Round((SysTime() - started) * 1000)
            client:notifySuccess(string.format("Map cleanup finished in %d ms; map props restored.", elapsed))
        end)
    end
})

lia.command.add("cleannpcs", {
    superAdminOnly = true,
    desc = "Remove all NPC entities from the map.",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:IsNPC() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccess(string.format("You cleaned up %s: %s entities removed.", "NPCs", count))
    end
})

lia.command.add("charunban", {
    superAdminOnly = true,
    desc = "Unban a character by name or ID.",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if (client.liaNextSearch or 0) >= CurTime() then return "Searching for character..." end
        local queryArg = table.concat(arguments, " ")
        local charFound
        local id = tonumber(queryArg)
        if id then
            for _, v in pairs(lia.char.getAll()) do
                if v:getID() == id then
                    charFound = v
                    break
                end
            end
        else
            for _, v in pairs(lia.char.getAll()) do
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
                client:notifySuccess(string.format("%s has unbanned the character %s.", client:Name(), charFound:getName()))
                lia.log.add(client, "charUnban", charFound:getName(), charFound:getID())
            else
                return "This character isn't banned!"
            end
        end

        client.liaNextSearch = CurTime() + 15
        local sqlCondition = id and "id = " .. id or "name LIKE " .. lia.db.convertDataType("%" .. queryArg .. "%")
        lia.db.query("SELECT id, name FROM lia_characters WHERE " .. sqlCondition .. " LIMIT 1", function(data)
            if data and data[1] then
                local charID = tonumber(data[1].id)
                lia.char.getCharBanned(charID):next(function(banned)
                    client.liaNextSearch = 0
                    if banned == 0 then
                        client:notifyInfo("This character isn't banned!")
                        return
                    end

                    lia.char.setCharDatabase(charID, "banned", 0)
                    lia.char.setCharDatabase(charID, "charBanInfo", nil)
                    client:notifySuccess(string.format("%s has unbanned the character %s.", client:Name(), data[1].name))
                    lia.log.add(client, "charUnban", data[1].name, charID)
                end):catch(function(message)
                    client.liaNextSearch = 0
                    client:notifyError("Database error: " .. tostring(message))
                end)
            end
        end)
    end
})

lia.command.add("clearinv", {
    superAdminOnly = true,
    desc = "Clear a player's entire inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Clear Inventory",
        ButtonText = "Clear Inventory",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:getChar():getInv():wipeItems()
        client:notifySuccess(string.format("You have cleared %s's inventory!", target:getChar():getName()))
    end
})

lia.command.add("charkick", {
    adminOnly = true,
    desc = "Kick the target's active character to the character menu.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Kick Character",
        ButtonText = "Kick Character",
        Category = "Character Discipline",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            for _, targets in player.Iterator() do
                targets:notifyInfo(string.format("%s kicked character %s.", client:Name(), target:Name()))
            end

            character:kick()
            lia.log.add(client, "charKick", target:Name(), character:getID())
        else
            client:notifyError("No character found!")
        end
    end
})

lia.command.add("freezeallprops", {
    superAdminOnly = true,
    desc = "Freeze all props owned by a specific player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
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

        client:notifySuccess(string.format("You have frozen all of %s's Entities.", target:Name()))
        client:notifySuccess(string.format("Frozen %s Entities belonging to %s.", count, target:Name()))
    end
})

lia.command.add("charban", {
    superAdminOnly = true,
    desc = "Ban a character by name or ID.",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Ban Character",
        ButtonText = "Ban Character",
        Category = "Character Discipline",
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
            client:notifyError("Target not found")
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
            client:notifySuccess(string.format("%s banned the character %s.", client:Name(), target:Name()))
            lia.log.add(client, "charBan", target:Name(), character:getID())
        else
            client:notifyError("No character found!")
        end
    end
})

lia.command.add("charwipe", {
    superAdminOnly = true,
    desc = "Completely wipe a character from the database by name or ID.",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Wipe Character",
        ButtonText = "Wipe Character",
        Category = "Character Discipline",
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
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            local charID = character:getID()
            local charName = character:getName()
            character:kick()
            lia.char.delete(charID, target)
            if IsValid(target) and target.liaCharList then
                for i, charId in ipairs(target.liaCharList) do
                    if charId == charID then
                        table.remove(target.liaCharList, i)
                        break
                    end
                end

                hook.Run("SyncCharList", target)
            end

            client:notifySuccess(string.format("%s wiped the character %s from the database.", client:Name(), charName))
            lia.log.add(client, "charWipe", charName, charID)
        else
            client:notifyError("No character found!")
        end
    end
})

lia.command.add("charwipeoffline", {
    superAdminOnly = true,
    desc = "Completely wipe an offline character from the database using their Char ID.",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyError("Invalid character ID.") end
        lia.db.query("SELECT name FROM lia_characters WHERE id = " .. charID, function(data)
            if not data or #data == 0 then
                client:notifyError("Character not found.")
                return
            end

            local charName = data[1].name
            for _, ply in player.Iterator() do
                if ply:getChar() and ply:getChar():getID() == charID then
                    ply:Kick("Your character has been wiped from the database.")
                    break
                end
            end

            lia.char.delete(charID)
            client:notifySuccess(string.format("Offline character ID %s has been wiped from the database.", charID))
            lia.log.add(client, "charWipeOffline", charName, charID)
        end)
    end
})

lia.command.add("checkmoney", {
    adminOnly = true,
    desc = "Check how much money the target player has.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Money",
        ButtonText = "View Money",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local money = target:getChar():getMoney()
        client:notifyMoney(string.format("%s has %s", target:GetName(), lia.currency.get(money)))
    end
})

lia.command.add("listbodygroups", {
    adminOnly = true,
    desc = "List the available bodygroups for a target player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
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
            lia.util.sendTableUI(client, string.format("Bodygroups for %s", target:Nick()), {
                {
                    name = "groupID",
                    field = "group"
                },
                {
                    name = "name",
                    field = "name"
                },
                {
                    name = "range",
                    field = "range"
                }
            }, bodygroups)
        else
            client:notifyInfo("No bodygroups available for this model.")
        end
    end
})

lia.command.add("charsetspeed", {
    adminOnly = true,
    desc = "Set a player's run speed.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "speed",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Speed",
        ButtonText = "Set Character Speed",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local speed = tonumber(arguments[2]) or lia.config.get("WalkSpeed")
        target:SetRunSpeed(speed)
    end
})

lia.command.add("charsetmodel", {
    adminOnly = true,
    privilege = "manageCharacterInformation",
    desc = "Set a player's model.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "model",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local oldModel = target:getChar():getModel()
        target:getChar():setModel(arguments[2] or oldModel)
        target:SetupHands()
        client:notifySuccess(string.format("%s changed %s's model to %s.", client:Name(), target:Name(), arguments[2] or oldModel))
        lia.log.add(client, "charsetmodel", target:Name(), arguments[2], oldModel)
    end
})

lia.command.add("chareditbodygroups", {
    adminOnly = true,
    privilege = "changeBodygroups",
    desc = "Open the bodygroup editor for a player's character.",
    arguments = {
        {
            name = "name",
            type = "player"
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1] or "")
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not target:getChar() then
            client:notifyError("Player has no character loaded")
            return
        end

        net.Start("liaBodygrouperMenu")
        net.WriteEntity(target)
        net.Send(client)
    end
})

lia.command.add("chargiveitem", {
    superAdminOnly = true,
    desc = "Give an item to a player's inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "itemName",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Give Item",
        ButtonText = "Give Item",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local itemName = arguments[2]
        if not itemName or itemName == "" then
            client:notifyError("You must specify an item to give.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
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
            client:notifyError("Sorry, the item that you requested does not exist.")
            return
        end

        local inv = target:getChar():getInv()
        local succ, err = inv:add(uniqueID)
        if succ then
            target:notifySuccess("Item created successfully.")
            if target ~= client then client:notifySuccess("Item created successfully.") end
            lia.log.add(client, "chargiveItem", lia.item.list[uniqueID] and lia.item.list[uniqueID].name or uniqueID, target, "Command")
        else
            target:notifyError(err or "Unknown error")
        end
    end
})

lia.command.add("charsetdesc", {
    adminOnly = true,
    desc = "Set a player's character description.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "description",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Description",
        ButtonText = "Set Description",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not target:getChar() then
            client:notifyError("No character found!")
            return
        end

        local desc = table.concat(arguments, " ", 2)
        if not desc:find("%S") then return client:requestString(string.format("Change %s's Description", target:Name()), "Enter new description", function(text) lia.command.run(client, "charsetdesc", {arguments[1], text}) end, target:getChar():getDesc()) end
        target:getChar():setDesc(desc)
        return string.format("%s has changed %s's character description.", client:Name(), target:Name())
    end
})

lia.command.add("charsetname", {
    adminOnly = true,
    desc = "Set a player's character name.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "newName",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Name",
        ButtonText = "Set Character Name",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local newName = table.concat(arguments, " ", 2)
        if newName == "" then return client:requestString("Change Name", "Enter the character's new name below.", function(text) lia.command.run(client, "charsetname", {target:Name(), text}) end, target:Name()) end
        local oldName = target:getChar():getName()
        target:getChar():setName(newName:gsub("#", "#?"))
        client:notifySuccess(string.format("%s changed %s's name to %s.", client:Name(), oldName, newName))
    end
})

lia.command.add("charsetscale", {
    adminOnly = true,
    desc = "Set a player's model scale.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "scale",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Scale",
        ButtonText = "Set Character Scale",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local scale = tonumber(arguments[2]) or 1
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:SetModelScale(scale, 0)
        client:notifySuccess(string.format("You changed %s's model scale to %s.", target:Name(), scale))
    end
})

lia.command.add("charsetjump", {
    adminOnly = true,
    desc = "Set a player's jump power.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "power",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Jump Height",
        ButtonText = "Set Jump Power",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local power = tonumber(arguments[2]) or 200
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:SetJumpPower(power)
        client:notifySuccess(string.format("You changed %s's jump power to %s.", target:Name(), power))
    end
})

lia.command.add("charsetbodygroup", {
    adminOnly = true,
    desc = "Set a specific bodygroup on a player's model.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "bodygroupName",
            type = "string"
        },
        {
            name = "value",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local name = arguments[1]
        local bodyGroup = arguments[2]
        local value = tonumber(arguments[3])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local index = lia.util.resolveBodygroupIndex(target, bodyGroup)
        if index ~= nil then
            if value and value < 1 then value = nil end
            local groups = lia.util.normalizeBodygroups(target:getChar().vars.bodygroups)
            groups[index] = value
            target:getChar():setBodygroups(groups)
            target:SetBodygroup(index, value or 0)
            client:notifySuccess(string.format("%s changed %s's bodygroup \\\"%s\\\" to %s.", client:Name(), target:Name(), bodyGroup, value or 0))
        else
            client:notifyError("Invalid argument.")
        end
    end
})

lia.command.add("charsetskin", {
    adminOnly = true,
    desc = "Set a player's skin.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "skin",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Set Character Skin",
        ButtonText = "Set Character Skin",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local name = arguments[1]
        local skin = tonumber(arguments[2])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not skin then
            client:notifyError("Invalid argument.")
            return
        end

        target:getChar():setSkin(skin)
        target:SetSkin(skin)
        client:notifySuccess(string.format("%s changed %s's skin to %s.", client:Name(), target:Name(), skin))
    end
})

lia.command.add("charsetmoney", {
    superAdminOnly = true,
    desc = "Set a player's money to a specific amount.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "amount",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local amount = tonumber(arguments[2])
        if not amount or amount < 0 then
            client:notifyError("Invalid argument.")
            return
        end

        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:getChar():setMoney(math.floor(amount))
        client:notifyMoney(string.format("You set %s's money to %s.", target:Name(), lia.currency.get(math.floor(amount))))
        lia.log.add(client, "charSetMoney", target:Name(), math.floor(amount))
        StaffAddTextShadowed(Color(34, 139, 34), "MONEY", Color(255, 255, 255), string.format("%s set money of %s (Steam64ID: %s) to %s", client:Name(), target:Name(), target:SteamID64(), lia.currency.get(math.floor(amount))))
    end
})

lia.command.add("charaddmoney", {
    superAdminOnly = true,
    desc = "Add a certain amount of money to a player's balance.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "amount",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local amount = tonumber(arguments[2])
        if not amount then
            client:notifyError("Invalid argument.")
            return
        end

        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        amount = math.Round(amount)
        local currentMoney = target:getChar():getMoney()
        target:getChar():setMoney(currentMoney + amount)
        client:notifyMoney(string.format("You gave %s an additional %s. Total: %s", target:Name(), lia.currency.get(amount), lia.currency.get(currentMoney + amount)))
        lia.log.add(client, "charAddMoney", target:Name(), amount, currentMoney + amount)
        StaffAddTextShadowed(Color(34, 139, 34), "MONEY", Color(255, 255, 255), string.format("%s gave %s to %s (Steam64ID: %s). New balance: %s", client:Name(), lia.currency.get(amount), target:Name(), target:SteamID64(), lia.currency.get(currentMoney + amount)))
    end,
    alias = {"chargivemoney"}
})

lia.command.add("globalbotsay", {
    superAdminOnly = true,
    desc = "Force all bots on the server to say something.",
    arguments = {
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local message = table.concat(arguments, " ")
        if message == "" then
            client:notifyError("You must specify a message.")
            return
        end

        for _, bot in player.Iterator() do
            if bot:IsBot() then bot:Say(message) end
        end
    end
})

lia.command.add("botsay", {
    superAdminOnly = true,
    desc = "Force a specific bot to say something.",
    arguments = {
        {
            name = "botName",
            type = "string"
        },
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if #arguments < 2 then
            client:notifyError("You must specify a bot and a message.")
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
            client:notifyError(string.format("No bot found with the name: %s", botName))
            return
        end

        targetBot:Say(message)
    end
})

lia.command.add("forcesay", {
    superAdminOnly = true,
    desc = "Force a player to say something in chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "message",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Force Say",
        ButtonText = "Force Say",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local message = table.concat(arguments, " ", 2)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if message == "" then
            client:notifyError("You must specify a message.")
            return
        end

        target:Say(message)
        lia.log.add(client, "forceSay", target:Name(), message)
    end
})

lia.command.add("getmodel", {
    desc = "Get the model of the entity you are looking at.",
    onRun = function(client)
        local entity = client:getTracedEntity()
        if not IsValid(entity) then
            client:notifyError("No valid entity found in front of you.")
            return
        end

        local model = entity:GetModel()
        client:ChatPrint(model and string.format("The model is: %s", model) or "No model found.")
    end
})

lia.command.add("pm", {
    desc = "Sends a private message to a specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if not lia.config.get("AllowPMs") then
            client:notifyError("Private Messages are Disabled")
            return
        end

        local targetName = arguments[1]
        local message = table.concat(arguments, " ", 2)
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not message:find("%S") then
            client:notifyError("You must specify a message.")
            return
        end

        lia.chat.send(client, "pm", message, false, {client, target})
    end
})

lia.command.add("chargetmodel", {
    adminOnly = true,
    desc = "Get the model of a player's character.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Model",
        ButtonText = "View Model",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        client:ChatPrint(string.format("Character Model: %s", target:GetModel()))
    end
})

lia.command.add("checkallmoney", {
    superAdminOnly = true,
    desc = "Check every player's money balance.",
    onRun = function(client)
        for _, target in player.Iterator() do
            local char = target:getChar()
            if char then client:ChatPrint(string.format("%s has %s", target:GetName(), lia.currency.get(char:getMoney()))) end
        end
    end
})

lia.command.add("checkflags", {
    adminOnly = true,
    desc = "Check which flags a player has.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Flags",
        ButtonText = "View Flags",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local flags = target:getFlags()
        if flags and #flags > 0 then
            client:ChatPrint(string.format("Character flags for %s: %s", target:Name(), table.concat(flags, ", ")))
        else
            client:notifyInfo(string.format("%s has no flags.", target:Name()))
        end
    end
})

lia.command.add("chargetname", {
    adminOnly = true,
    desc = "Get a player's character name.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Name",
        ButtonText = "View Character Name",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        client:ChatPrint(string.format("Character Name: %s", target:getChar():getName()))
    end
})

lia.command.add("chargethealth", {
    adminOnly = true,
    desc = "Get a player's current health.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Health",
        ButtonText = "View Health",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        client:ChatPrint(string.format("Character Health: %s/%s", target:Health(), target:GetMaxHealth()))
    end
})

lia.command.add("chargetmoney", {
    adminOnly = true,
    desc = "Get how much money a player has.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Money",
        ButtonText = "View Money",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local money = target:getChar():getMoney()
        client:ChatPrint(string.format("Character Money: %s", lia.currency.get(money)))
    end
})

lia.command.add("chargetinventory", {
    adminOnly = true,
    desc = "Get the contents of a player's inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Inventory",
        ButtonText = "View Inventory",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local inventory = target:getChar():getInv()
        local items = inventory:getItems()
        if not items or table.Count(items) < 1 then
            client:notifyInfo("Character Inventory is empty.")
            return
        end

        local result = {}
        for _, item in pairs(items) do
            table.insert(result, item.name)
        end

        client:ChatPrint(string.format("Character Inventory: %s", table.concat(result, ", ")))
    end
})

lia.command.add("getallinfos", {
    adminOnly = true,
    desc = "Print all character data columns to the console.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get All Informations",
        ButtonText = "View All Info",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyError("No character found!")
            return
        end

        lia.char.getCharData(char:getID()):next(function(data)
            lia.admin(string.format("=== All information for %s ===", char:getName()))
            for column, value in pairs(data) do
                if istable(value) then
                    lia.admin(column .. ":")
                    PrintTable(value)
                else
                    lia.admin(column .. " = " .. tostring(value))
                end
            end

            client:notifyInfo("Character information printed to console.")
        end):catch(function(message) client:notifyError("Database error: " .. tostring(message)) end)
    end
})

lia.command.add("dropmoney", {
    desc = "Drop money from your character's balance as a physical entity.",
    arguments = {
        {
            name = "amount",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local originalAmount = tonumber(arguments[1]) or 0
        local amount = math.floor(originalAmount)
        if originalAmount ~= amount and originalAmount > 0 then
            lia.log.add(client, "moneyDupeAttempt", "Attempted to drop " .. tostring(originalAmount) .. " money (floored to " .. amount .. ")")
            for _, admin in player.Iterator() do
                if admin:IsAdmin() then admin:notify(string.format("%s attempted to %s with decimal amount %s (floored to %s) - potential money duping!", client:Name(), "dropmoney", tostring(originalAmount), tostring(amount))) end
            end
        end

        if not amount or amount <= 0 then
            client:notifyError("Invalid argument.")
            return
        end

        local character = client:getChar()
        if not character or not character:hasMoney(amount) then
            client:notifyError("You don't have enough money")
            return
        end

        local maxEntities = lia.config.get("MaxMoneyEntities", 3)
        local existingMoneyEntities = 0
        for _, entity in pairs(ents.FindByClass("lia_money")) do
            if entity.client == client then existingMoneyEntities = existingMoneyEntities + 1 end
        end

        if existingMoneyEntities >= maxEntities then
            client:notifyError(string.format("You have reached the maximum number of money entities (%d). Please wait for them to be picked up or removed.", maxEntities))
            return
        end

        character:takeMoney(amount)
        local money = lia.currency.spawn(client:getItemDropPos(), amount)
        if IsValid(money) then
            money.client = client
            money.charID = character:getID()
            client:notifyMoney(string.format("You dropped %s on the ground.", lia.currency.get(amount)))
            lia.log.add(client, "moneyDropped", amount)
        end

        client:doGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
    end
})

lia.command.add("exportprivileges", {
    adminOnly = true,
    desc = "Export all current privileges to a data file",
    onRun = function(client)
        local filename = "lilia_registered_privileges.json"
        if not SERVER then return end
        local seen = {}
        local list = {}
        local function add(id, name)
            if isstring(id) or isnumber(id) then return end
            id = tostring(id)
            if id == "" then return end
            if seen[id] then return end
            seen[id] = true
            table.insert(list, {
                id = id,
                name = name and tostring(name) or ""
            })
        end

        local function walk(v)
            if istable(v) then return end
            for k, val in pairs(v) do
                if isstring(k) and (isboolean(val) or istable(val)) then if k ~= "" and k ~= "None" then add(k) end end
                if istable(val) then
                    local id = val.id or val.ID or val.Id or val.uniqueID or val.UniqueID
                    local name = val.name or val.Name or val.title or val.Title
                    if id then add(id, name) end
                    if val.privilege or val.Privilege then add(val.privilege or val.Privilege, name) end
                    if val.privileges or val.Privileges then
                        for _, p in pairs(val.privileges or val.Privileges) do
                            if istable(p) then
                                add(p.id or p.ID or p, p.name or p.Name)
                            elseif isstring(p) or isnumber(p) then
                                add(p)
                            end
                        end
                    end

                    walk(val)
                elseif isstring(val) or isnumber(val) then
                    if isstring(k) and k:lower() == "id" then add(val) end
                end
            end
        end

        local function collect(t)
            if istable(t) == "table" then walk(t) end
        end

        local srcs = {}
        if lia then
            if lia.admin then
                table.insert(srcs, lia.admin.privileges)
                if isfunction(lia.admin.getPrivileges) == "function" then
                    local ok, r = pcall(lia.admin.getPrivileges, lia.admin)
                    if ok then table.insert(srcs, r) end
                end
            end

            if lia.admin then
                table.insert(srcs, lia.admin.privileges)
                if isfunction(lia.admin.getPrivileges) then
                    local ok, r = pcall(lia.admin.getPrivileges, lia.admin)
                    if ok then table.insert(srcs, r) end
                end
            end

            if lia.permission then
                table.insert(srcs, lia.permission.list)
                if isfunction(lia.permission.getAll) then
                    local ok, r = pcall(lia.permission.getAll, lia.permission)
                    if ok then table.insert(srcs, r) end
                end
            end

            if lia.permissions then table.insert(srcs, lia.permissions) end
            if lia.privileges then table.insert(srcs, lia.privileges) end
            if lia.command then table.insert(srcs, lia.command.stored or lia.command.list) end
            for _, p in pairs(lia.module.list) do
                if istable(p) == "table" then
                    table.insert(srcs, p.Privileges or p.privileges)
                    collect(p)
                end
            end
        end

        for _, s in pairs(srcs) do
            collect(s)
        end

        table.sort(list, function(a, b) return a.id < b.id end)
        local payload = {
            privileges = list
        }

        local jsonData = util.TableToJSON(payload, true)
        local wrote = false
        do
            local f = file.Open("gamemodes/Lilia/data/" .. filename, "wb", "GAME")
            if f then
                f:Write(jsonData)
                f:Close()
                wrote = true
            end
        end

        if not wrote then
            if not file.Exists("data", "DATA") then file.CreateDir("data") end
            wrote = file.Write("data/" .. filename, jsonData) and true or false
        end

        if wrote then
            client:notifySuccess(string.format("Privileges exported successfully to: %s", filename))
            MsgC(Color(83, 143, 239), "[Lilia] ", "[" .. "Admin" .. "] ")
            MsgC(Color(255, 153, 0), string.format("Privileges exported by %s to: %s", client:Nick(), filename), "\n")
            lia.log.add(client, "privilegesExported", filename)
        else
            client:notifyError("Failed to export privileges to expected locations")
            lia.error("Failed to export privileges to expected locations")
        end
    end
})

lia.command.add("fillwithbots", {
    superAdminOnly = true,
    desc = "Manage server bots - list, kick, or spawn bots.",
    alias = {"bots"},
    arguments = {
        {
            name = "amount",
            type = "number",
            optional = true
        }
    },
    onRun = function(client, arguments)
        if not SERVER then return end
        if timer.Exists("Bots_Add_Timer") then
            client:notifyError("Bots are already being added to the server.")
            return
        end

        local requestedAmount = arguments.amount
        if requestedAmount then
            requestedAmount = math.max(1, math.floor(requestedAmount))
            local maxPlayers = game.MaxPlayers()
            local availableSlots = maxPlayers - player.GetCount()
            if requestedAmount > availableSlots then
                client:notifyError(string.format("Cannot spawn %d bots. Only %d slots available (server limit: %d).", requestedAmount, availableSlots, maxPlayers))
                return
            end

            if requestedAmount <= 0 then
                client:notifyError("Invalid amount. Please specify a positive number of bots to spawn.")
                return
            end

            local botsSpawned = 0
            timer.Create("Bots_Add_Timer", 2, 0, function()
                if botsSpawned < requestedAmount and player.GetCount() < game.MaxPlayers() then
                    game.ConsoleCommand("bot\n")
                    botsSpawned = botsSpawned + 1
                else
                    timer.Remove("Bots_Add_Timer")
                end
            end)

            client:notifyInfo(string.format("Spawning %d bots...", requestedAmount))
        else
            timer.Create("Bots_Add_Timer", 2, 0, function()
                if player.GetCount() < game.MaxPlayers() then
                    game.ConsoleCommand("bot\n")
                else
                    timer.Remove("Bots_Add_Timer")
                end
            end)

            client:notifyInfo("Filling server with bots...")
        end
    end
})

lia.command.add("spawnbots", {
    superAdminOnly = true,
    desc = "Spawn a specific number of bots around your position.",
    arguments = {
        {
            name = "amount",
            type = "number"
        }
    },
    onRun = function(client, arguments)
        if not SERVER then return end
        local requestedAmount = math.max(1, math.floor(arguments.amount or 1))
        local maxPlayers = game.MaxPlayers()
        local availableSlots = maxPlayers - player.GetCount()
        if requestedAmount > availableSlots then
            client:notifyError(string.format("Cannot spawn %d bots. Only %d slots available (server limit: %d).", requestedAmount, availableSlots, maxPlayers))
            return
        end

        if requestedAmount <= 0 then
            client:notifyError("Invalid amount. Please specify a positive number of bots to spawn.")
            return
        end

        local botsSpawned = 0
        client:notifyInfo(string.format("Spawning %d bots...", requestedAmount))
        for i = 1, requestedAmount do
            timer.Simple((i - 1) * 0.5, function()
                if not IsValid(client) then return end
                game.ConsoleCommand("bot\n")
                botsSpawned = botsSpawned + 1
            end)
        end

        timer.Simple(requestedAmount * 0.5 + 2, function() if IsValid(client) then client:notifySuccess(string.format("Successfully spawned %d bots!", botsSpawned)) end end)
    end
})

lia.command.add("bot", {
    superAdminOnly = true,
    desc = "Spawn a bot and bring it to your location",
    onRun = function(client)
        if not SERVER then return end
        local maxPlayers = game.MaxPlayers()
        if player.GetCount() >= maxPlayers then
            client:notifyError(string.format("Cannot spawn %d bots. Only %d slots available (server limit: %d).", 1, 0, maxPlayers))
            return
        end

        client:notifyInfo(string.format("Spawning %d bots...", 1))
        game.ConsoleCommand("bot\n")
        timer.Simple(0.5, function()
            if not IsValid(client) then return end
            local bots = {}
            for _, ply in player.Iterator() do
                if ply:IsBot() then table.insert(bots, ply) end
            end

            table.sort(bots, function(a, b) return a:UserID() > b:UserID() end)
            local bot = bots[1]
            if IsValid(bot) then
                bot:SetPos(client:GetPos() + client:GetForward() * 50)
                local botName = bot:Name()
                if botName == "" then botName = "Bot" .. bot:UserID() end
                client:notifySuccess(string.format("Bot '%s' spawned and brought to your location!", botName))
            else
                client:notifyError("Failed to spawn bot.")
            end
        end)
    end
})

lia.command.add("botspeak", {
    superAdminOnly = true,
    desc = "Make all bots say a specified number of random phrases.",
    arguments = {
        {
            name = "phrases",
            type = "number",
            optional = true,
            default = 50
        }
    },
    onRun = function(client, arguments)
        if not SERVER then return end
        local phrasesPerBot = math.Clamp(arguments.phrases or 50, 1, 200)
        local cooldown = 1
        local bots = {}
        for _, ent in ents.Iterator() do
            if ent:IsNPC() or ent:IsNextBot() or (ent:IsPlayer() and ent:IsBot()) then table.insert(bots, ent) end
        end

        if #bots == 0 then
            client:notifyError("No bots found on the server.")
            return
        end

        client:notifyInfo(string.format("Found %d bots. Starting phrase sequence with %d phrases per bot...", #bots, phrasesPerBot))
        local randomPhrases = {"Hello there!", "What's going on?", "I need help!", "Over here!", "Watch out!", "Come on!", "Let's go!", "This way!", "Behind you!", "Enemy spotted!", "Clear!", "Move up!", "Hold position!", "Cover me!", "Reloading!", "Taking fire!", "Need backup!", "All clear!", "Contact!", "Engaging!", "Fall back!", "Push forward!", "Hold the line!", "Secure the area!", "Enemy down!", "Got one!", "Nice shot!", "Good work!", "Keep moving!", "Stay alert!"}
        local phraseCount = {}
        for _, bot in ipairs(bots) do
            phraseCount[bot] = 0
        end

        local function makeBotSpeak(bot)
            if not IsValid(bot) then return end
            if phraseCount[bot] < phrasesPerBot then
                local randomPhrase = randomPhrases[math.random(#randomPhrases)]
                bot:Say(randomPhrase)
                phraseCount[bot] = phraseCount[bot] + 1
                if phraseCount[bot] < phrasesPerBot then
                    timer.Simple(cooldown, function() if IsValid(bot) then makeBotSpeak(bot) end end)
                else
                    client:notifySuccess(string.format("Bot %s finished all %d phrases", bot:GetName() or tostring(bot), phrasesPerBot))
                end
            end
        end

        for _, bot in ipairs(bots) do
            makeBotSpeak(bot)
        end

        timer.Simple((phrasesPerBot * cooldown) + 5, function()
            local totalPhrases = 0
            for _, count in pairs(phraseCount) do
                totalPhrases = totalPhrases + count
            end

            client:notifySuccess(string.format("All bots finished! Total phrases said: %d", totalPhrases))
        end)
    end
})

lia.command.add("charsetattrib", {
    superAdminOnly = true,
    desc = "Set Attributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "attribute",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.attribs.list) do
                    options[v.name] = k
                end
                return options
            end
        },
        {
            name = "level",
            type = "number"
        }
    },
    AdminStick = {
        Name = "Set Attributes",
        ButtonText = "Set Attributes",
        Category = "Attributes",
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyError("No attributes are currently registered in the system.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        local attribName = arguments[2]
        local attribNumber = tonumber(arguments[3])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        lia.log.add(client, "attribCheck", target:Name())
        local character = target:getChar()
        if character then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(v.name, attribName) or lia.util.stringMatches(k, attribName) then
                    character:setAttrib(k, math.abs(attribNumber))
                    client:notifySuccess(string.format("You set %s's %s to %s.", target:Name(), v.name, math.abs(attribNumber)))
                    lia.log.add(client, "attribSet", target:Name(), k, math.abs(attribNumber))
                    return
                end
            end
        end
    end
})

lia.command.add("checkattributes", {
    adminOnly = true,
    desc = "Check Attributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Attributes",
        ButtonText = "View Attributes",
        Category = "Attributes",
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyError("No attributes are currently registered in the system.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local attributesData = {}
        for attrKey, attrData in SortedPairsByMemberValue(lia.attribs.list, "name") do
            local currentValue = target:getChar():getAttrib(attrKey, 0) or 0
            local maxValue = hook.Run("GetAttributeMax", target, attrKey) or 100
            local progress = math.Round(currentValue / maxValue * 100, 1)
            table.insert(attributesData, {
                charID = attrData.name,
                name = attrData.name,
                current = currentValue,
                max = maxValue,
                progress = progress .. "%"
            })
        end

        lia.util.sendTableUI(client, "characterAttributes", {
            {
                name = "attributeName",
                field = "name"
            },
            {
                name = "currentValue",
                field = "current"
            },
            {
                name = "maxValue",
                field = "max"
            },
            {
                name = "progress",
                field = "progress"
            }
        }, attributesData, {
            {
                name = "changeAttribute",
                ExtraFields = {
                    ["Amount"] = "text",
                    ["Mode"] = {"Add", "set"}
                },
                net = "ChangeAttribute"
            }
        }, client:getChar():getID())
    end
})

lia.command.add("staffdiscord", {
    desc = "Sets your staff Discord username.",
    arguments = {
        {
            name = "discord",
            type = "string"
        }
    },
    onRun = function(client, arguments)
        local discord = arguments[1]
        local character = client:getChar()
        if not character or character:getFaction() ~= FACTION_STAFF then
            client:notifyError("No staff character found. Create one in the staff faction.")
            return
        end

        client:setLiliaData("staffDiscord", discord)
        local description = string.format("Staff Character - Discord: %s, SteamID: %s", discord, client:SteamID())
        character:setDesc(description)
        client:notifySuccess("Staff character description updated!")
    end
})

lia.command.add("trunk", {
    adminOnly = false,
    desc = "Open the vehicle trunk you're looking at to access its storage inventory.",
    onRun = function(client)
        local entity = client:getTracedEntity()
        local maxDistance = 128
        local openTime = 0.7
        if not IsValid(entity) then
            client:notifyError("You're not looking at any vehicle!")
            return
        end

        if hook.Run("IsSuitableForTrunk", entity) == false then
            client:notifyError("You're not looking at any vehicle!")
            return
        end

        if client:GetPos():Distance(entity:GetPos()) > maxDistance then
            client:notifyError("You're too far to open the trunk!")
            return
        end

        client.liaStorageEntity = entity
        client:setAction("Opening...", openTime, function()
            if not IsValid(entity) then
                client.liaStorageEntity = nil
                return
            end

            if client:GetPos():Distance(entity:GetPos()) > maxDistance then
                client.liaStorageEntity = nil
                return
            end

            entity.receivers = entity.receivers or {}
            entity.receivers[client] = true
            local invID = entity:getNetVar("inv")
            local inv = invID and lia.inventory.instances[invID]
            local function openStorage(storageInv)
                if not storageInv then
                    client:notifyError("Player has no inventory")
                    client.liaStorageEntity = nil
                    return
                end

                storageInv:sync(client)
                net.Start("liaStorageOpen")
                net.WriteBool(true)
                net.WriteEntity(entity)
                net.Send(client)
                entity:EmitSound("items/ammocrate_open.wav")
            end

            if inv then
                openStorage(inv)
            else
                lia.module.get("storage"):InitializeStorage(entity):next(openStorage, function(err)
                    client:notifyError(string.format("Unable to create storage entity for %s\\n%s", entity:GetClass(), err))
                    client.liaStorageEntity = nil
                end)
            end
        end)
    end
})

lia.command.add("charaddattrib", {
    superAdminOnly = true,
    desc = "Add Attributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "attribute",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.attribs.list) do
                    options[v.name] = k
                end
                return options
            end
        },
        {
            name = "level",
            type = "number"
        }
    },
    AdminStick = {
        Name = "Add Attributes",
        ButtonText = "Add Attributes",
        Category = "Attributes",
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyError("No attributes are currently registered in the system.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        local attribName = arguments[2]
        local attribNumber = tonumber(arguments[3])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(v.name, attribName) or lia.util.stringMatches(k, attribName) then
                    character:updateAttrib(k, math.abs(attribNumber))
                    client:notifySuccess(string.format("You added %s's %s by %s.", target:Name(), v.name, math.abs(attribNumber)))
                    lia.log.add(client, "attribAdd", target:Name(), k, math.abs(attribNumber))
                    return
                end
            end
        end
    end
})

lia.command.add("banooc", {
    adminOnly = true,
    desc = "Bans the specified player from using out-of-character chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Ban OOC",
        ButtonText = "Ban From OOC",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:setLiliaData("oocBanned", true)
        client:notifySuccess(string.format("%s has been banned from OOC.", target:Name()))
        lia.log.add(client, "banOOC", target:Name(), target:SteamID())
    end
})

lia.command.add("unbanooc", {
    adminOnly = true,
    desc = "Unbans the specified player from out-of-character chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Unban OOC",
        ButtonText = "Unban From OOC",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:setLiliaData("oocBanned", nil)
        client:notifySuccess(string.format("%s has been unbanned from OOC.", target:Name()))
        lia.log.add(client, "unbanOOC", target:Name(), target:SteamID())
    end
})

-- Relocated late administration command registrations.
lia.command.add("plyrespawn", {
    adminOnly = true,
    arguments = {
        {
            name = "target",
            type = "player"
        }
    },
    desc = "Force another player to respawn.",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Invalid Target!")
            return
        end

        target:Spawn()
        client:notifySuccess(string.format("Successfully force respawned %s.", target:Name()))
        target:notify("You were force respawned by an admin.")
        lia.log.add(client, "plyrespawn", target:Name())
    end
})

lia.command.add("forcerespawn", {
    desc = "Force yourself to respawn after death.",
    onRun = function(client)
        if client:Alive() then
            client:notifyError("Player is already alive.")
            return
        end

        local baseTime = lia.config.get("SpawnTime", 5)
        baseTime = hook.Run("OverrideSpawnTime", client, baseTime) or baseTime
        local lastDeath = client:getLocalVar("lastDeathTime", os.time())
        local timePassed = os.time() - lastDeath
        if timePassed < baseTime then
            client:notifyError(string.format("You cannot respawn yet. Please wait %s seconds.", baseTime - timePassed))
            return
        end

        client:Spawn()
        client:setLocalVar("lastDeathTime", 0)
        client:notifySuccess(string.format("Successfully force respawned %s.", client:Name()))
        client:notify("You were force respawned by an admin.")
        lia.log.add(client, "forcerespawn", client:Name())
    end
})

-- Remaining administration command registrations.
lia.command.add("clearchat", {
    adminOnly = true,
    desc = "Clears chat for all players.",
    onRun = function(client)
        net.Start("liaRegenChat")
        net.Broadcast()
        lia.log.add(client, "clearChat")
    end
})

lia.command.add("kickbots", {
    privilege = "Manage Bots",
    desc = "Kick all bots from the server.",
    onRun = function(client)
        if timer.Exists("Bots_Add_Timer") then timer.Remove("Bots_Add_Timer") end
        local kickedCount = 0
        for _, bot in player.Iterator() do
            if bot:IsBot() then
                bot:Kick("All bots kicked")
                client:notifySuccess("Player kicked.")
                lia.log.add(client, "plyKick", bot:Name())
                lia.db.insertTable({
                    player = bot:Name(),
                    playerSteamID = bot:SteamID(),
                    steamID = bot:SteamID(),
                    action = "plykick",
                    staffName = client:Name(),
                    staffSteamID = client:SteamID(),
                    timestamp = os.time()
                }, nil, "staffactions")

                kickedCount = kickedCount + 1
            end
        end

        if kickedCount == 0 then
            client:notifyError("No bots to kick.")
        else
            client:notifyInfo(string.format("Kicked %d bots from the server.", kickedCount))
        end
    end
})

lia.command.add("npcchangetype", {
    adminOnly = true,
    desc = "Change the type of a dialog NPC you are looking at.",
    AdminStick = {
        Name = "Change NPC Type",
        ButtonText = "Change NPC Type",
        Category = "NPCs",
        TargetClass = "lia_npc",
    },
    onRun = function(client)
        local permission = client:hasPrivilege("Can Manage NPCs")
        lia.debug("[Permissions]", "Permission Check for command npcchangetype", "hasPrivilege(Can Manage NPCs)=", tostring(permission), "finalResult=", tostring(permission))
        if not permission then return client:notifyError("You lack permission to manage NPCs.") end
        local ent = client:getTracedEntity()
        if not ent or not IsValid(ent) then return client:notifyError("You must be looking at a valid entity.") end
        if not lia.dialog.isDialogNPCEntity(ent) then return client:notifyError("You must be looking at a dialog NPC.") end
        lia.dialog.syncToClients(client)
        timer.Simple(0.1, function()
            if not IsValid(client) or not IsValid(ent) then return end
            local npcOptions = lia.dialog.getCompatibleDialogOptions(ent)
            local displayToUniqueID = {}
            for _, option in ipairs(npcOptions) do
                displayToUniqueID[option[1]] = option[2]
            end

            if not table.IsEmpty(npcOptions) then
                client.npcDisplayToUniqueID = displayToUniqueID
                client.npcEntity = ent
                client:requestDropdown("Change NPC Type", "Choose what type of NPC this should be:", npcOptions, function(selectedDisplayName, selectedUniqueID)
                    if selectedDisplayName and selectedDisplayName ~= "" then
                        local uniqueID = selectedUniqueID or (client.npcDisplayToUniqueID and client.npcDisplayToUniqueID[selectedDisplayName])
                        if uniqueID and IsValid(client.npcEntity) then
                            local npc = client.npcEntity
                            local npcType = uniqueID
                            if lia.dialog.isGeneratedDialogSelection and lia.dialog.isGeneratedDialogSelection(npcType) then npcType = lia.dialog.ensureGeneratedDialogType and select(1, lia.dialog.ensureGeneratedDialogType(npc, nil, npc.NPCName)) or nil end
                            if not IsValid(npc) or not npcType then return end
                            local existingCustomData = npc.customData
                            local npcData = lia.dialog.getNPCData(npcType)
                            if not npcData or not lia.dialog.isDialogCompatibleWithEntity(npc, npcData) then
                                client:notifyError("That dialog type is not compatible with this entity.")
                                return
                            end

                            npc.uniqueID = npcType
                            if npcData then
                                local currentPos = npc:GetPos()
                                local currentAng = npc:GetAngles()
                                npc:SetModel("models/Barney.mdl")
                                if npcData.BodyGroups and istable(npcData.BodyGroups) then lia.util.applyBodygroups(npc, npcData.BodyGroups) end
                                if npcData.Skin then npc:SetSkin(npcData.Skin) end
                                npc.NPCName = npcData.PrintName or "NPC"
                                npc:setNetVar("uniqueID", npcType)
                                npc:setNetVar("NPCName", npc.NPCName)
                                npc:SetMoveType(MOVETYPE_VPHYSICS)
                                npc:SetSolid(SOLID_OBB)
                                npc:PhysicsInit(SOLID_OBB)
                                npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
                                npc:SetPos(currentPos)
                                npc:SetAngles(currentAng)
                                local physObj = npc:GetPhysicsObject()
                                if IsValid(physObj) then
                                    physObj:EnableMotion(false)
                                    physObj:Sleep()
                                end

                                npc:setAnim()
                                if existingCustomData then
                                    if existingCustomData.name and existingCustomData.name ~= "" then npc.NPCName = existingCustomData.name end
                                    if existingCustomData.model and existingCustomData.model ~= "" then npc:SetModel(existingCustomData.model) end
                                    if existingCustomData.skin then npc:SetSkin(tonumber(existingCustomData.skin) or 0) end
                                    if existingCustomData.bodygroups and istable(existingCustomData.bodygroups) then lia.util.applyBodygroups(npc, existingCustomData.bodygroups) end
                                    if existingCustomData.animation and existingCustomData.animation ~= "auto" then
                                        local sequenceIndex = npc:LookupSequence(existingCustomData.animation)
                                        if sequenceIndex >= 0 then
                                            npc.customAnimation = existingCustomData.animation
                                            npc:ResetSequence(sequenceIndex)
                                        end
                                    end

                                    npc.customData = existingCustomData
                                end

                                npc:setNetVar("NPCName", npc.NPCName)
                                hook.Run("UpdateEntityPersistence", npc)
                                client:notifyInfo(string.format("NPC type changed to: %s", npcData.PrintName or npcType))
                            end
                        end
                    end
                end)
            else
                client:notifyError("No NPC types available! The server may still be loading modules. Please try again in a moment.")
            end
        end)
    end
})

lia.command.add("viewBodygroups", {
    adminOnly = true,
    arguments = {
        {
            name = "target",
            type = "player"
        }
    },
    desc = "View and edit a player's bodygroups.",
    AdminStick = {
        Name = "View and edit a player's bodygroups.",
        ButtonText = "View Bodygroups",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1] or "")
        if not target or not IsValid(target) then
            client:notify("Target not found")
            return
        end

        net.Start("liaBodygrouperMenu")
        net.WriteEntity(target)
        net.Send(client)
    end
})

-- Server console administration commands.
concommand.Add("lia_setextrachars", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    local steamid = args[1]
    local amount = tonumber(args[2])
    if not steamid or steamid == "" then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid SteamID provided.\n")
        return
    end

    if not amount or amount < 0 then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid amount provided. Must be a non-negative number.\n")
        return
    end

    lia.db.query("SELECT steamID, data FROM lia_players WHERE steamID = " .. lia.db.convertDataType(steamid) .. " LIMIT 1", function(data)
        local playerData = {}
        if data and data[1] then
            playerData = data[1].data
            if isstring(playerData) then
                playerData = util.JSONToTable(playerData) or {}
            elseif not playerData then
                playerData = {}
            end
        else
            lia.db.insertTable({
                steamID = steamid,
                steamName = "Unknown",
                data = "{}",
                lastJoin = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                lastIP = "",
                lastOnline = os.time(),
                totalOnlineTime = 0
            }, nil, "players")
        end

        local currentExtra = tonumber(playerData.extraCharacters) or 0
        local newExtra = currentExtra + amount
        playerData.extraCharacters = newExtra
        lia.db.updateTable({
            data = util.TableToJSON(playerData)
        }, nil, "players", "steamID = " .. lia.db.convertDataType(steamid))

        for _, ply in player.Iterator() do
            if ply:SteamID() == steamid then
                ply:setLiliaData("extraCharacters", newExtra)
                break
            end
        end

        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added " .. amount .. " extra character slot" .. (amount == 1 and "" or "s") .. " to player " .. steamid .. ". New total: " .. newExtra .. " (was " .. currentExtra .. ").\n")
        lia.log.add(nil, "addExtraChars", steamid, amount, newExtra)
    end)
end)

concommand.Add("lia_give_money_steamid", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    local steamID = args[1]
    local amount = tonumber(args[2])
    if not steamID or not amount then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_give_money_steamid <steamID> <amount>\n")
        return
    end

    if amount < 0 then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Amount must be a positive number.\n")
        return
    end

    lia.db.select({"id", "name", "money"}, "characters", "steamID = " .. lia.db.convertDataType(steamID)):next(function(res)
        local characters = res.results or {}
        if not characters or #characters == 0 then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "No characters found for SteamID: " .. steamID .. "\n")
            return
        end

        local ply = player.GetBySteamID(steamID)
        local isPlayerOnline = IsValid(ply) and ply:IsPlayer()
        local updatedCount = 0
        for _, charData in ipairs(characters) do
            local charID = charData.id
            local charName = charData.name
            local currentMoney = tonumber(charData.money) or 0
            local newMoney = currentMoney + amount
            if isPlayerOnline and ply:getChar() and ply:getChar():getID() == charID then
                local char = ply:getChar()
                char:giveMoney(amount)
                local actualNewMoney = char:getMoney()
                updatedCount = updatedCount + 1
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Gave %s to character '%s' (ID: %s). New balance: %s (player online)", lia.currency.get(amount), charName, charID, lia.currency.get(actualNewMoney)) .. "\n")
                if updatedCount == #characters then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Successfully gave %s to %s characters owned by SteamID: %s", lia.currency.get(amount), #characters, steamID) .. "\n")
                    lia.log.add(nil, "giveMoneySteamID", steamID, amount, #characters)
                end
            else
                if lia.char.setCharDatabase(charID, "money", newMoney) then
                    updatedCount = updatedCount + 1
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Gave %s to character '%s' (ID: %s). New balance: %s (player offline)", lia.currency.get(amount), charName, charID, lia.currency.get(newMoney)) .. "\n")
                    if updatedCount == #characters then
                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Successfully gave %s to %s characters owned by SteamID: %s", lia.currency.get(amount), #characters, steamID) .. "\n")
                        lia.log.add(nil, "giveMoneySteamID", steamID, amount, #characters)
                    end
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Error updating money for character '%s' (ID: %s)", charName, charID) .. "\n")
                end
            end
        end
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Database error: %s", tostring(err)) .. "\n") end)
end)