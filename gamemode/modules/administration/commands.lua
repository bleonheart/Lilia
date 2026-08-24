-- Relocated command registrations.
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

    concommand.Add("lia_saved_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local soundFiles = {}
        if files then
            for _, fileName in ipairs(files) do
                if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then table.insert(soundFiles, fileName) end
            end
        end

        if #soundFiles == 0 then
            LocalPlayer():ChatPrint(L("noSavedSoundsFound"))
            return
        end

        local f = vgui.Create("liaFrame")
        f:SetTitle(L("savedSounds"))
        f:SetSize(600, 500)
        f:Center()
        f:MakePopup()
        local scroll = vgui.Create("liaScrollPanel", f)
        scroll:Dock(FILL)
        scroll:DockMargin(5, 5, 5, 5)
        for _, fileName in ipairs(soundFiles) do
            local soundName = string.StripExtension(fileName)
            local soundPath = baseDir .. fileName
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(40)
            panel:DockMargin(2, 2, 2, 2)
            panel.Paint = function(_, w, h)
                surface.SetDrawColor(60, 60, 60, 200)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(100, 100, 100, 100)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local nameLabel = vgui.Create("DLabel", panel)
            nameLabel:SetText(soundName)
            nameLabel:SetFont("LiliaFont.17")
            nameLabel:SetTextColor(Color(255, 255, 255))
            nameLabel:Dock(LEFT)
            nameLabel:DockMargin(10, 0, 0, 0)
            nameLabel:SetWide(300)
            local playButton = vgui.Create("liaButton", panel)
            playButton:SetText("? " .. L("play"))
            playButton:SetWide(80)
            playButton:Dock(RIGHT)
            playButton:DockMargin(5, 5, 5, 5)
            playButton.DoClick = function()
                if file.Exists(soundPath, "DATA") then
                    local fullPath = "data/" .. soundPath
                    timer.Simple(0.1, function()
                        sound.PlayFile(fullPath, "", function(channel, _, errorString)
                            if IsValid(channel) then
                                LocalPlayer():ChatPrint(L("playingSound", soundName))
                            else
                                LocalPlayer():ChatPrint(L("failedToPlaySound", soundName, errorString or L("unknown")))
                            end
                        end)
                    end)
                else
                    LocalPlayer():ChatPrint(L("soundFileNotFound", soundName))
                end
            end

            local stopButton = vgui.Create("liaButton", panel)
            stopButton:SetText("? " .. L("stop"))
            stopButton:SetWide(80)
            stopButton:Dock(RIGHT)
            stopButton:DockMargin(5, 5, 5, 5)
            stopButton.DoClick = function()
                timer.Simple(0.1, function()
                    sound.PlayFile("", "", function() end)
                    LocalPlayer():ChatPrint(L("stoppedAllSounds"))
                end)
            end
        end
    end)

    concommand.Add("lia_wipe_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local deletedCount = 0
        for _, fn in ipairs(files) do
            if string.EndsWith(fn, ".mp3") or string.EndsWith(fn, ".wav") or string.EndsWith(fn, ".ogg") or string.EndsWith(fn, ".dat") then
                file.Delete(baseDir .. fn)
                deletedCount = deletedCount + 1
            end
        end

        LocalPlayer():ChatPrint(L("soundsWiped") .. " (" .. deletedCount .. " files)")
    end)

    concommand.Add("lia_validate_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local validCount = 0
        local invalidCount = 0
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if data and #data > 0 then
                    validCount = validCount + 1
                else
                    invalidCount = invalidCount + 1
                end
            elseif string.EndsWith(fileName, ".dat") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if data then
                    local success, soundData = pcall(pon.decode, data)
                    if success and soundData then
                        validCount = validCount + 1
                    else
                        invalidCount = invalidCount + 1
                    end
                end
            end
        end

        LocalPlayer():ChatPrint(L("soundValidationComplete", validCount, invalidCount))
    end)

    concommand.Add("lia_cleanup_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local removedCount = 0
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if not data or #data == 0 then
                    file.Delete(baseDir .. fileName)
                    removedCount = removedCount + 1
                end
            elseif string.EndsWith(fileName, ".dat") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if not data then
                    file.Delete(baseDir .. fileName)
                    removedCount = removedCount + 1
                else
                    local success, soundData = pcall(pon.decode, data)
                    if not success or not soundData then
                        file.Delete(baseDir .. fileName)
                        removedCount = removedCount + 1
                    end
                end
            end
        end

        LocalPlayer():ChatPrint(L("cleanedUpInvalidSounds", removedCount))
    end)

    concommand.Add("lia_list_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        if #files == 0 then return end
        LocalPlayer():ChatPrint(L("savedSounds"))
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") or string.EndsWith(fileName, ".dat") then LocalPlayer():ChatPrint(L("soundFileList", string.StripExtension(fileName))) end
        end
    end)

    local function findImagesRecursive(dir, result)
        result = result or {}
        local files, dirs = file.Find(dir .. "*", "DATA")
        if files then
            for _, fn in ipairs(files) do
                table.insert(result, dir .. fn)
            end
        end

        if dirs then
            for _, subdir in ipairs(dirs) do
                findImagesRecursive(dir .. subdir .. "/", result)
            end
        end
        return result
    end

    local function deleteDirectoryRecursive(dir)
        local files, dirs = file.Find(dir .. "*", "DATA")
        if files then
            for _, fn in ipairs(files) do
                file.Delete(dir .. fn)
            end
        end

        if dirs then
            for _, subdir in ipairs(dirs) do
                deleteDirectoryRecursive(dir .. subdir .. "/")
                file.Delete(dir .. subdir)
            end
        end
    end

    concommand.Add("lia_saved_images", function()
        local baseDir = "lilia/webimages/"
        local files = findImagesRecursive(baseDir)
        local imageFiles = {}
        if files then
            for _, fileName in ipairs(files) do
                if string.EndsWith(fileName, ".png") or string.EndsWith(fileName, ".jpg") or string.EndsWith(fileName, ".jpeg") then table.insert(imageFiles, fileName) end
            end
        end

        if #imageFiles == 0 then
            LocalPlayer():ChatPrint(L("noSavedImagesFound"))
            return
        end

        local f = vgui.Create("liaFrame")
        f:SetTitle(L("savedImages"))
        f:SetSize(700, 600)
        f:Center()
        f:MakePopup()
        local scroll = vgui.Create("liaScrollPanel", f)
        scroll:Dock(FILL)
        scroll:DockMargin(5, 5, 5, 5)
        for _, fileName in ipairs(imageFiles) do
            local imageName = string.StripExtension(fileName)
            local imagePath = baseDir .. fileName
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(120)
            panel:DockMargin(2, 2, 2, 2)
            panel.Paint = function(_, w, h)
                surface.SetDrawColor(60, 60, 60, 200)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(100, 100, 100, 100)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local imagePreview = vgui.Create("DImage", panel)
            imagePreview:SetPos(10, 10)
            imagePreview:SetSize(100, 100)
            imagePreview:SetImage("data/" .. imagePath)
            local nameLabel = vgui.Create("DLabel", panel)
            nameLabel:SetText(imageName)
            nameLabel:SetFont("LiliaFont.17")
            nameLabel:SetTextColor(Color(255, 255, 255))
            nameLabel:SetPos(120, 10)
            nameLabel:SetWide(300)
            local viewButton = vgui.Create("liaButton", panel)
            viewButton:SetText("?? " .. L("view"))
            viewButton:SetWide(80)
            viewButton:SetPos(120, 40)
            viewButton.DoClick = function()
                local viewFrame = vgui.Create("liaFrame")
                viewFrame:SetTitle(L("imageViewerTitle", imageName))
                viewFrame:SetSize(800, 600)
                viewFrame:Center()
                viewFrame:MakePopup()
                local fullImage = vgui.Create("DImage", viewFrame)
                fullImage:Dock(FILL)
                fullImage:DockMargin(10, 10, 10, 10)
                fullImage:SetImage("data/" .. imagePath)
            end

            local copyButton = vgui.Create("liaButton", panel)
            copyButton:SetText("?? " .. L("copyPath"))
            copyButton:SetWide(100)
            copyButton:SetPos(210, 40)
            copyButton.DoClick = function()
                SetClipboardText("data/" .. imagePath)
                LocalPlayer():ChatPrint(L("imagePathCopied", "data/" .. imagePath))
            end
        end
    end)

    concommand.Add("lia_cleanup_images", function()
        local baseDir = "lilia/webimages/"
        local files = findImagesRecursive(baseDir)
        local removedCount = 0
        for _, filePath in ipairs(files) do
            if not file.Exists(filePath, "DATA") then removedCount = removedCount + 1 end
        end

        LocalPlayer():ChatPrint(L("foundImageFiles", #files))
    end)

    concommand.Add("lia_wipewebimages", function()
        local baseDir = "lilia/webimages/"
        deleteDirectoryRecursive(baseDir)
        cache = {}
        urlMap = {}
        LocalPlayer():ChatPrint(L("webImagesWiped"))
    end)

    concommand.Add("printpos", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] " .. L("errorPrefix") .. L("commandCanOnlyBeUsedByPlayers") .. "\n")
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
        Name = "@adminStickGetPlayTimeName",
        ButtonText = "View Play Time",
        Category = "Player Info",
    },
    desc = "@plygetplaytimeDesc",
    onRun = function(client, args)
        if not args[1] then
            client:notifyErrorLocalized("specifyPlayer")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local secs = target:getPlayTime()
        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:ChatPrint(L("playtimeFor", target:Nick(), h, m, s))
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
        Name = "@adminStickCheckCharIDName",
        ButtonText = "View Character ID",
        Category = "Player Info",
    },
    desc = "@plycheckidDesc",
    onRun = function(client, args)
        if not args[1] then
            client:notifyErrorLocalized("specifyPlayer")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyErrorLocalized("noCharacterLoaded")
            return
        end

        local charID = char:getID()
        client:ChatPrint(L("charidFor", target:Nick(), charID))
    end
})

lia.command.add("checkid", {
    desc = "@charidDesc",
    onRun = function(client)
        local char = client:getChar()
        if not char then
            client:notifyErrorLocalized("noCharacterSelected")
            return
        end

        local charID = char:getID()
        client:ChatPrint(L("charidYour", charID))
    end
})

lia.command.add("managesitrooms", {
    superAdminOnly = true,
    desc = "@manageSitroomsDesc",
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
    desc = "@setSitroomDesc",
    onRun = function(client)
        client:requestString("@enterNamePrompt", L("enterSitroomPrompt") .. ":", function(name)
            if name == "" then
                client:notifyErrorLocalized("invalidName")
                return
            end

            local rooms = lia.data.get("sitrooms", {})
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", rooms)
            client:notifySuccessLocalized("sitroomSet")
            lia.log.add(client, "sitRoomSet", L("sitroomSetDetail", name, tostring(client:GetPos())), L("logSetSitroom"))
        end)
    end
})

lia.command.add("sendtositroom", {
    adminOnly = true,
    desc = "@sendToSitRoomDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@sendToSitRoom",
        ButtonText = "Send To Sit Room",
        Category = "Teleportation",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local rooms = lia.data.get("sitrooms", {})
        local names = {}
        for n in pairs(rooms) do
            names[#names + 1] = n
        end

        if #names == 0 then
            client:notifyErrorLocalized("sitroomNotSet")
            return
        end

        client:requestDropdown("@chooseSitroomTitle", L("selectSitroomPrompt") .. ":", names, function(selection)
            local pos = rooms[selection]
            if not pos then
                client:notifyErrorLocalized("sitroomNotSet")
                return
            end

            target:SetPos(pos)
            client:notifySuccessLocalized("sitroomTeleport", target:Nick())
            target:notifyInfoLocalized("sitroomArrive")
            lia.log.add(client, "sendToSitRoom", target:Nick(), selection)
        end)
    end
})

lia.command.add("returnsitroom", {
    adminOnly = true,
    desc = "@returnFromSitroomDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@returnFromSitroom",
        ButtonText = "Return From Sit Room",
        Category = "Teleportation",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local prev = target.previousSitroomPos
        if not prev then
            client:notifyErrorLocalized("noPreviousSitroomPos")
            return
        end

        target:SetPos(prev)
        client:notifySuccessLocalized("sitroomReturnSuccess")
        if target ~= client then target:notifyInfoLocalized("sitroomReturned") end
        lia.log.add(client, "sitRoomReturn", target:Nick())
    end
})

lia.command.add("charkill", {
    superAdminOnly = true,
    alias = "permakill",
    desc = "@charkillDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        }
    },
    AdminStick = {
        Name = "@adminStickCharKillName",
        ButtonText = "Kill Character",
        Category = "Character Discipline",
    },
    onRun = function(client, args)
        if not args[1] then
            client:notifyErrorLocalized("specifyPlayer")
            return
        end

        local ply = lia.util.findPlayer(client, args[1])
        if not IsValid(ply) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local char = ply:getChar()
        if not char then
            client:notifyErrorLocalized("noCharacterLoaded")
            return
        end

        local isPermakilled = char:getData("permakilled", false)
        if isPermakilled then
            char:setData("permakilled", nil)
            lia.db.delete("permakills", "charID = " .. lia.db.convertDataType(char:getID()))
            client:notifySuccessLocalized("charUnkill", client:Name(), ply:Nick())
            lia.log.add(client, "charUnkill", ply:Nick(), char:getID())
        else
            local reasonKey = L("reason")
            local evidenceKey = L("evidence")
            client:requestArguments(L("pkReasonMenu"), {
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
                local instantDeathKey = L("instantDeath")
                client:requestArguments(L("pkDeathOptionMenu"), {
                    [instantDeathKey] = "boolean"
                }, function(success2, data2)
                    if not success2 then return end
                    local instantDeath = data2[instantDeathKey]
                    if instantDeath then
                        ply:Kill()
                        client:notifySuccessLocalized("charKillInstant", client:Name(), ply:Nick())
                        lia.log.add(client, "charKillInstant", ply:Nick(), char:getID(), reason)
                    else
                        client:notifySuccessLocalized("charKill", client:Name(), ply:Nick())
                        lia.log.add(client, "charKill", ply:Nick(), char:getID(), reason)
                    end
                end)
            end)
        end
    end
})

lia.command.add("plyban", {
    adminOnly = true,
    desc = "@plyBanDesc",
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
        Name = "@adminStickBanName",
        ButtonText = "Ban Player",
        Category = "Player Punishment",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ban", arguments[1], arguments[2], arguments[3], client) end
})

lia.command.add("plykick", {
    adminOnly = true,
    desc = "@plyKickDesc",
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
        Name = "@adminStickKickName",
        ButtonText = "Kick Player",
        Category = "Player Punishment",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("kick", arguments[1], nil, arguments[2], client) end
})

lia.command.add("plykill", {
    adminOnly = true,
    desc = "@plyKillDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickKillPlayerName",
        ButtonText = "Kill Player",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("kill", arguments[1], nil, nil, client) end
})

lia.command.add("plyunban", {
    adminOnly = true,
    desc = "@plyUnbanDesc",
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
            client:notifySuccessLocalized("playerUnbanned")
            lia.log.add(client, "plyUnban", steamid)
        end
    end
})

lia.command.add("plyfreeze", {
    adminOnly = true,
    desc = "@plyFreezeDesc",
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
    desc = "@plyUnfreezeDesc",
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
    desc = "@plySlayDesc",
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
    desc = "@plyBlindDesc",
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
    desc = "@plyUnblindDesc",
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
    desc = "@plyBlindFadeDesc",
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
        Name = "@adminStickBlindFadeName",
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
    desc = "@blindFadeAllDesc",
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
    desc = "@plyGagDesc",
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
    desc = "@plyUngagDesc",
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
    desc = "@plyMuteDesc",
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
    desc = "@plyUnmuteDesc",
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
    desc = "@plyBringDesc",
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
    desc = "@plyGotoDesc",
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
    desc = "@plyReturnDesc",
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
    desc = "@plyJailDesc",
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
    desc = "@plyUnjailDesc",
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
    desc = "@plyCloakDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickCloakName",
        ButtonText = "Cloak Player",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("cloak", arguments[1], nil, nil, client) end
})

lia.command.add("plyuncloak", {
    adminOnly = true,
    desc = "@plyUncloakDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickUncloakName",
        ButtonText = "Uncloak Player",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("uncloak", arguments[1], nil, nil, client) end
})

lia.command.add("plygod", {
    adminOnly = true,
    desc = "@plyGodDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGodModeName",
        ButtonText = "Enable Godmode",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("god", arguments[1], nil, nil, client) end
})

lia.command.add("plyungod", {
    adminOnly = true,
    desc = "@plyUngodDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickRemoveGodModeName",
        ButtonText = "Disable Godmode",
        Category = "Player State",
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ungod", arguments[1], nil, nil, client) end
})

lia.command.add("plyignite", {
    adminOnly = true,
    desc = "@plyIgniteDesc",
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
    desc = "@plyExtinguishDesc",
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
    desc = "@plyStripDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickStripWeaponsName",
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
        client:notifyErrorLocalized("noPerm")
        lia.log.add(client, "unauthorizedCommand", privilegeID)
        return false
    end

    local function runTargetedAdminCommand(commandID, client, arguments, durationIndex, reasonStartIndex)
        if not hasConsoleCommandAccess(client, lia.admin.getCommandPrivilegeID(commandID)) then return end
        local target = arguments[1]
        if not target or target == "" then
            if IsValid(client) then
                client:notifyErrorLocalized("targetNotFound")
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
                client:notifyErrorLocalized("targetNotFound")
            else
                print("[Lilia] Missing SteamID.")
            end
            return
        end

        lia.db.query("DELETE FROM lia_bans WHERE playerSteamID = " .. lia.db.convertDataType(steamid))
        if IsValid(client) then
            client:notifySuccessLocalized("playerUnbanned")
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
            client:notifyErrorLocalized("cannotMuteSelf")
            return
        end

        if not target:getChar() then
            if IsValid(client) then
                client:notifyErrorLocalized("noValidCharacter")
            else
                print("[Lilia] That player does not have a valid character.")
            end
            return
        end

        local isMuted = target:getLiliaData("liaMuted", false)
        target:setLiliaData("liaMuted", not isMuted)
        if IsValid(client) then
            if isMuted then
                client:notifySuccessLocalized("textUnmuted", target:Name())
                target:notifyInfoLocalized("textUnmutedByAdmin")
            else
                client:notifySuccessLocalized("textMuted", target:Name())
                target:notifyWarningLocalized("textMutedByAdmin")
            end

            lia.log.add(client, "textToggle", target:Name(), isMuted and L("unmuted") or L("muted"))
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
    desc = "@charUnbanOfflineDesc",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyErrorLocalized("invalidCharID") end
        local result = sql.Query("SELECT id FROM lia_characters WHERE id = " .. charID .. " LIMIT 1")
        if not istable(result) or not result[1] then return client:notifyErrorLocalized("characterNotFound") end
        lia.char.setCharDatabase(charID, "banned", 0)
        lia.char.setCharDatabase(charID, "charBanInfo", nil)
        client:notifySuccessLocalized("offlineCharUnbanned", charID)
        lia.log.add(client, "charUnbanOffline", charID)
    end
})

lia.command.add("charbanoffline", {
    superAdminOnly = true,
    desc = "@charBanOfflineDesc",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyErrorLocalized("invalidCharID") end
        local result = sql.Query("SELECT id FROM lia_characters WHERE id = " .. charID .. " LIMIT 1")
        if not istable(result) or not result[1] then return client:notifyErrorLocalized("characterNotFound") end
        lia.char.setCharDatabase(charID, "banned", -1)
        lia.char.setCharDatabase(charID, "charBanInfo", {
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

        client:notifySuccessLocalized("offlineCharBanned", charID)
        lia.log.add(client, "charBanOffline", charID)
    end
})
end
lia.command.add("playglobalsound", {
    superAdminOnly = true,
    desc = "@playGlobalSoundDesc",
    arguments = {
        {
            name = "sound",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local sound = arguments[1]
        if not sound or sound == "" then
            client:notifyErrorLocalized("noSound")
            return
        end

        for _, target in player.Iterator() do
            target:PlaySound(sound)
        end
    end
})

lia.command.add("plyspectate", {
    adminOnly = true,
    desc = "@plySpectateDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickSpectateName",
        ButtonText = "Spectate Player",
        Category = "Observation",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if target == client then
            client:notifyErrorLocalized("cannotSpectateSelf")
            return
        end

        if target.liaSpectating then
            client:notifyErrorLocalized("targetAlreadySpectated")
            return
        end

        client.returnPos = client:GetPos()
        client.returnAng = client:EyeAngles()
        client:Spectate(OBS_MODE_CHASE)
        client:SpectateEntity(target)
        client:GodEnable()
        client.liaSpectating = true
        client:notifySuccessLocalized("spectateStarted", target:Nick())
        target:notifyInfoLocalized("beingSpectated", client:Nick())
        lia.log.add(client, "plySpectate", target:Nick())
    end
})

lia.command.add("stopspectate", {
    adminOnly = true,
    desc = "@stopSpectateDesc",
    onRun = function(client)
        if not client.liaSpectating then
            client:notifyErrorLocalized("notSpectating")
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
        client:notifySuccessLocalized("spectateStopped")
        lia.log.add(client, "stopSpectate")
    end
})

lia.command.add("playsound", {
    superAdminOnly = true,
    desc = "@playSoundDesc",
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
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not sound or sound == "" then
            client:notifyErrorLocalized("noSound")
            return
        end

        target:PlaySound(sound)
    end
})

lia.command.add("togglelockcharacters", {
    superAdminOnly = true,
    desc = "@toggleCharLockDesc",
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
    desc = "@checkInventoryDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickCheckInventoryName",
        ButtonText = "View Inventory",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if target == client then
            client:notifyErrorLocalized("invCheckSelf")
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
    desc = "@flagGiveDesc",
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
            client:notifyErrorLocalized("targetNotFound")
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
                client:notifyInfoLocalized("noAvailableFlags")
                return
            end
            return client:requestString(L("give") .. " " .. L("flags"), "@flagGiveDesc", function(text) lia.command.run(client, "flaggive", {target:Name(), text}) end, available)
        end

        target:giveFlags(flags)
        client:notifySuccessLocalized("flagGive", client:Name(), flags, target:Name())
        lia.log.add(client, "flagGive", target:Name(), flags)
    end,
    alias = {"giveflag", "chargiveflag"}
})

lia.command.add("flaggiveall", {
    adminOnly = true,
    desc = "@giveAllFlagsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if not target:hasFlags(k) then target:giveFlags(k) end
        end

        client:notifySuccessLocalized("gaveAllFlags")
        lia.log.add(client, "flagGiveAll", target:Name())
    end
})

lia.command.add("flagtakeall", {
    adminOnly = true,
    desc = "@takeAllFlagsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not target:getChar() then
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if target:hasFlags(k) then target:takeFlags(k) end
        end

        client:notifySuccessLocalized("tookAllFlags")
        lia.log.add(client, "flagTakeAll", target:Name())
    end
})

lia.command.add("flagtake", {
    adminOnly = true,
    desc = "@flagTakeDesc",
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
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local flags = arguments[2]
        if not flags then
            local currentFlags = target:getFlags()
            return client:requestString(L("take") .. " " .. L("flags"), "@flagTakeDesc", function(text) lia.command.run(client, "flagtake", {target:Name(), text}) end, table.concat(currentFlags, ", "))
        end

        target:takeFlags(flags)
        client:notifySuccessLocalized("flagTake", client:Name(), flags, target:Name())
        lia.log.add(client, "flagTake", target:Name(), flags)
    end,
    alias = {"takeflag"}
})

lia.command.add("bringlostitems", {
    superAdminOnly = true,
    desc = "@bringLostItemsDesc",
    onRun = function(client)
        for _, v in ipairs(ents.FindInSphere(client:GetPos(), 500)) do
            if v:isItem() then v:SetPos(client:GetPos()) end
        end
    end
})

lia.command.add("charvoicetoggle", {
    adminOnly = true,
    desc = "@charVoiceToggleDesc",
    arguments = {
        {
            name = "name",
            type = "string"
        },
    },
    AdminStick = {
        Name = "@toggleVoice",
        ButtonText = "Toggle Voice",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if lia.admin.isProtectedStaffTarget("mute", target) then
            lia.admin.notifyProtectedStaffTarget(client)
            return false
        end

        if target == client then
            client:notifyErrorLocalized("cannotMuteSelf")
            return false
        end

        if target:getChar() then
            local isMuted = target:getLiliaData("liaMuted", false)
            target:setLiliaData("liaMuted", not isMuted)
            if isMuted then
                client:notifySuccessLocalized("textUnmuted", target:Name())
                target:notifyInfoLocalized("textUnmutedByAdmin")
            else
                client:notifySuccessLocalized("textMuted", target:Name())
                target:notifyWarningLocalized("textMutedByAdmin")
            end

            lia.log.add(client, "textToggle", target:Name(), isMuted and L("unmuted") or L("muted"))
        else
            client:notifyErrorLocalized("noValidCharacter")
        end
    end
})

lia.command.add("cleanitems", {
    superAdminOnly = true,
    desc = "@cleanItemsDesc",
    onRun = function(client)
        local count = 0
        for _, v in ipairs(ents.FindByClass("lia_item")) do
            count = count + 1
            SafeRemoveEntity(v)
        end

        client:notifySuccessLocalized("cleaningFinished", L("items"), count)
    end
})

lia.command.add("cleanprops", {
    superAdminOnly = true,
    desc = "@cleanPropsDesc",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:isProp() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccessLocalized("cleaningFinished", L("props"), count)
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
    desc = "@resetMapPropsDesc",
    onRun = function(client)
        local started = SysTime()
        client:notifyInfoLocalized("resetMapPropsRunning")
        game.CleanUpMap(false, nil, function()
            if not IsValid(client) then return end
            local elapsed = math.Round((SysTime() - started) * 1000)
            client:notifySuccessLocalized("resetMapPropsSuccess", elapsed)
        end)
    end
})

lia.command.add("cleannpcs", {
    superAdminOnly = true,
    desc = "@cleanNPCsDesc",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:IsNPC() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccessLocalized("cleaningFinished", L("npcs"), count)
    end
})

lia.command.add("charunban", {
    superAdminOnly = true,
    desc = "@charUnbanDesc",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if (client.liaNextSearch or 0) >= CurTime() then return L("searchingChar") end
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
                client:notifySuccessLocalized("charUnBan", client:Name(), charFound:getName())
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
                    client:notifyInfoLocalized("charNotBanned")
                    return
                end

                lia.char.setCharDatabase(charID, "banned", 0)
                lia.char.setCharDatabase(charID, "charBanInfo", nil)
                client:notifySuccessLocalized("charUnBan", client:Name(), data[1].name)
                lia.log.add(client, "charUnban", data[1].name, charID)
            end
        end)
    end
})

lia.command.add("clearinv", {
    superAdminOnly = true,
    desc = "@clearInvDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickClearInventoryName",
        ButtonText = "Clear Inventory",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        target:getChar():getInv():wipeItems()
        client:notifySuccessLocalized("resetInv", target:getChar():getName())
    end
})

lia.command.add("charkick", {
    adminOnly = true,
    desc = "@kickCharDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickKickCharacterName",
        ButtonText = "Kick Character",
        Category = "Character Discipline",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local character = target:getChar()
        if character then
            for _, targets in player.Iterator() do
                targets:notifyInfoLocalized("charKick", client:Name(), target:Name())
            end

            character:kick()
            lia.log.add(client, "charKick", target:Name(), character:getID())
        else
            client:notifyErrorLocalized("noChar")
        end
    end
})

lia.command.add("freezeallprops", {
    superAdminOnly = true,
    desc = "@freezeAllPropsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
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

        client:notifySuccessLocalized("freezeAllProps", target:Name())
        client:notifySuccessLocalized("freezeAllPropsCount", count, target:Name())
    end
})

lia.command.add("charban", {
    superAdminOnly = true,
    desc = "@banCharDesc",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    AdminStick = {
        Name = "@banCharacter",
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
            client:notifyErrorLocalized("targetNotFound")
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
            client:notifySuccessLocalized("charBan", client:Name(), target:Name())
            lia.log.add(client, "charBan", target:Name(), character:getID())
        else
            client:notifyErrorLocalized("noChar")
        end
    end
})

lia.command.add("charwipe", {
    superAdminOnly = true,
    desc = "@charWipeDesc",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    AdminStick = {
        Name = "@wipeCharacter",
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
            client:notifyErrorLocalized("targetNotFound")
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

            client:notifySuccessLocalized("charWipe", client:Name(), charName)
            lia.log.add(client, "charWipe", charName, charID)
        else
            client:notifyErrorLocalized("noChar")
        end
    end
})

lia.command.add("charwipeoffline", {
    superAdminOnly = true,
    desc = "@charWipeOfflineDesc",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyErrorLocalized("invalidCharID") end
        lia.db.query("SELECT name FROM lia_characters WHERE id = " .. charID, function(data)
            if not data or #data == 0 then
                client:notifyErrorLocalized("characterNotFound")
                return
            end

            local charName = data[1].name
            for _, ply in player.Iterator() do
                if ply:getChar() and ply:getChar():getID() == charID then
                    ply:Kick(L("youHaveBeenWiped"))
                    break
                end
            end

            lia.char.delete(charID)
            client:notifySuccessLocalized("offlineCharWiped", charID)
            lia.log.add(client, "charWipeOffline", charName, charID)
        end)
    end
})

lia.command.add("checkmoney", {
    adminOnly = true,
    desc = "@checkMoneyDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickCheckMoneyName",
        ButtonText = "View Money",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local money = target:getChar():getMoney()
        client:notifyMoneyLocalized("playerMoney", target:GetName(), lia.currency.get(money))
    end
})

lia.command.add("listbodygroups", {
    adminOnly = true,
    desc = "@listBodygroupsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
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
            lia.util.sendTableUI(client, L("uiBodygroupsFor", target:Nick()), {
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
            client:notifyInfoLocalized("noBodygroups")
        end
    end
})

lia.command.add("charsetspeed", {
    adminOnly = true,
    desc = "@setSpeedDesc",
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
        Name = "@adminStickSetCharSpeedName",
        ButtonText = "Set Character Speed",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local speed = tonumber(arguments[2]) or lia.config.get("WalkSpeed")
        target:SetRunSpeed(speed)
    end
})

lia.command.add("charsetmodel", {
    adminOnly = true,
    privilege = "manageCharacterInformation",
    desc = "@setModelDesc",
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
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local oldModel = target:getChar():getModel()
        target:getChar():setModel(arguments[2] or oldModel)
        target:SetupHands()
        client:notifySuccessLocalized("changeModelAdmin", client:Name(), target:Name(), arguments[2] or oldModel)
        lia.log.add(client, "charsetmodel", target:Name(), arguments[2], oldModel)
    end
})

lia.command.add("chareditbodygroups", {
    adminOnly = true,
    privilege = "changeBodygroups",
    desc = "@editBodygroupsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1] or "")
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not target:getChar() then
            client:notifyErrorLocalized("noCharacterLoaded")
            return
        end

        net.Start("liaBodygrouperMenu")
        net.WriteEntity(target)
        net.Send(client)
    end
})

lia.command.add("chargiveitem", {
    superAdminOnly = true,
    desc = "@giveItemDesc",
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
        Name = "@adminStickGiveItemName",
        ButtonText = "Give Item",
        Category = "Inventory",
    },
    onRun = function(client, arguments)
        local itemName = arguments[2]
        if not itemName or itemName == "" then
            client:notifyErrorLocalized("mustSpecifyItem")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
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
            client:notifyErrorLocalized("itemNoExist")
            return
        end

        local inv = target:getChar():getInv()
        local succ, err = inv:add(uniqueID)
        if succ then
            target:notifySuccessLocalized("itemCreated")
            if target ~= client then client:notifySuccessLocalized("itemCreated") end
            lia.log.add(client, "chargiveItem", lia.item.list[uniqueID] and lia.item.list[uniqueID].name or uniqueID, target, L("command"))
        else
            target:notifyErrorLocalized(err or "unknownError")
        end
    end
})

lia.command.add("charsetdesc", {
    adminOnly = true,
    desc = "@setDescDesc",
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
        Name = "@adminStickSetCharDescName",
        ButtonText = "Set Description",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not target:getChar() then
            client:notifyErrorLocalized("noChar")
            return
        end

        local desc = table.concat(arguments, " ", 2)
        if not desc:find("%S") then return client:requestString(L("chgDescTitle", target:Name()), "@enterNewDesc", function(text) lia.command.run(client, "charsetdesc", {arguments[1], text}) end, target:getChar():getDesc()) end
        target:getChar():setDesc(desc)
        return L("descChangedTarget", client:Name(), target:Name())
    end
})

lia.command.add("charsetname", {
    adminOnly = true,
    desc = "@setNameDesc",
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
        Name = "@adminStickSetCharNameName",
        ButtonText = "Set Character Name",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local newName = table.concat(arguments, " ", 2)
        if newName == "" then return client:requestString("@chgName", "@chgNameDesc", function(text) lia.command.run(client, "charsetname", {target:Name(), text}) end, target:Name()) end
        local oldName = target:getChar():getName()
        target:getChar():setName(newName:gsub("#", "#?"))
        client:notifySuccessLocalized("changeName", client:Name(), oldName, newName)
    end
})

lia.command.add("charsetscale", {
    adminOnly = true,
    desc = "@setScaleDesc",
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
        Name = "@adminStickSetCharScaleName",
        ButtonText = "Set Character Scale",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local scale = tonumber(arguments[2]) or 1
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        target:SetModelScale(scale, 0)
        client:notifySuccessLocalized("changedScale", target:Name(), scale)
    end
})

lia.command.add("charsetjump", {
    adminOnly = true,
    desc = "@setJumpDesc",
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
        Name = "@adminStickSetCharJumpName",
        ButtonText = "Set Jump Power",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local power = tonumber(arguments[2]) or 200
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        target:SetJumpPower(power)
        client:notifySuccessLocalized("changedJump", target:Name(), power)
    end
})

lia.command.add("charsetbodygroup", {
    adminOnly = true,
    desc = "@setBodygroupDesc",
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
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local index = lia.util.resolveBodygroupIndex(target, bodyGroup)
        if index ~= nil then
            if value and value < 1 then value = nil end
            local groups = lia.util.normalizeBodygroups(target:getChar().vars.bodygroups)
            groups[index] = value
            target:getChar():setBodygroups(groups)
            target:SetBodygroup(index, value or 0)
            client:notifySuccessLocalized("changeBodygroups", client:Name(), target:Name(), bodyGroup, value or 0)
        else
            client:notifyErrorLocalized("invalidArg")
        end
    end
})

lia.command.add("charsetskin", {
    adminOnly = true,
    desc = "@setSkinDesc",
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
        Name = "@adminStickSetCharSkinName",
        ButtonText = "Set Character Skin",
        Category = "Character Editing",
    },
    onRun = function(client, arguments)
        local name = arguments[1]
        local skin = tonumber(arguments[2])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not skin then
            client:notifyErrorLocalized("invalidArg")
            return
        end

        target:getChar():setSkin(skin)
        target:SetSkin(skin)
        client:notifySuccessLocalized("changeSkin", client:Name(), target:Name(), skin)
    end
})

lia.command.add("charsetmoney", {
    superAdminOnly = true,
    desc = "@setMoneyDesc",
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
            client:notifyErrorLocalized("invalidArg")
            return
        end

        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        target:getChar():setMoney(math.floor(amount))
        client:notifyMoneyLocalized("setMoney", target:Name(), lia.currency.get(math.floor(amount)))
        lia.log.add(client, "charSetMoney", target:Name(), math.floor(amount))
        StaffAddTextShadowed(Color(34, 139, 34), "MONEY", Color(255, 255, 255), L("staffLogSetMoney", client:Name(), target:Name(), target:SteamID64(), lia.currency.get(math.floor(amount))))
    end
})

lia.command.add("charaddmoney", {
    superAdminOnly = true,
    desc = "@addMoneyDesc",
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
            client:notifyErrorLocalized("invalidArg")
            return
        end

        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        amount = math.Round(amount)
        local currentMoney = target:getChar():getMoney()
        target:getChar():setMoney(currentMoney + amount)
        client:notifyMoneyLocalized("addMoney", target:Name(), lia.currency.get(amount), lia.currency.get(currentMoney + amount))
        lia.log.add(client, "charAddMoney", target:Name(), amount, currentMoney + amount)
        StaffAddTextShadowed(Color(34, 139, 34), "MONEY", Color(255, 255, 255), L("staffLogGaveMoney", client:Name(), lia.currency.get(amount), target:Name(), target:SteamID64(), lia.currency.get(currentMoney + amount)))
    end,
    alias = {"chargivemoney"}
})

lia.command.add("globalbotsay", {
    superAdminOnly = true,
    desc = "@globalBotSayDesc",
    arguments = {
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local message = table.concat(arguments, " ")
        if message == "" then
            client:notifyErrorLocalized("noMessage")
            return
        end

        for _, bot in player.Iterator() do
            if bot:IsBot() then bot:Say(message) end
        end
    end
})

lia.command.add("botsay", {
    superAdminOnly = true,
    desc = "@botSayDesc",
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
            client:notifyErrorLocalized("needBotAndMessage")
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
            client:notifyErrorLocalized("botNotFound", botName)
            return
        end

        targetBot:Say(message)
    end
})

lia.command.add("forcesay", {
    superAdminOnly = true,
    desc = "@forceSayDesc",
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
        Name = "@adminStickForceSayName",
        ButtonText = "Force Say",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local message = table.concat(arguments, " ", 2)
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if message == "" then
            client:notifyErrorLocalized("noMessage")
            return
        end

        target:Say(message)
        lia.log.add(client, "forceSay", target:Name(), message)
    end
})

lia.command.add("getmodel", {
    desc = "@getModelDesc",
    onRun = function(client)
        local entity = client:getTracedEntity()
        if not IsValid(entity) then
            client:notifyErrorLocalized("noEntityInFront")
            return
        end

        local model = entity:GetModel()
        client:ChatPrint(model and L("modelIs", model) or L("noModelFound"))
    end
})

lia.command.add("pm", {
    desc = "@pmDesc",
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
            client:notifyErrorLocalized("pmsDisabled")
            return
        end

        local targetName = arguments[1]
        local message = table.concat(arguments, " ", 2)
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not message:find("%S") then
            client:notifyErrorLocalized("noMessage")
            return
        end

        lia.chat.send(client, "pm", message, false, {client, target})
    end
})

lia.command.add("chargetmodel", {
    adminOnly = true,
    desc = "@getCharModelDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetCharModelName",
        ButtonText = "View Model",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        client:ChatPrint(L("charModelIs", target:GetModel()))
    end
})

lia.command.add("checkallmoney", {
    superAdminOnly = true,
    desc = "@checkAllMoneyDesc",
    onRun = function(client)
        for _, target in player.Iterator() do
            local char = target:getChar()
            if char then client:ChatPrint(L("playerMoney", target:GetName(), lia.currency.get(char:getMoney()))) end
        end
    end
})

lia.command.add("checkflags", {
    adminOnly = true,
    desc = "@checkFlagsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetCharFlagsName",
        ButtonText = "View Flags",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local flags = target:getFlags()
        if flags and #flags > 0 then
            client:ChatPrint(L("charFlags", target:Name(), table.concat(flags, ", ")))
        else
            client:notifyInfoLocalized("noFlags", target:Name())
        end
    end
})

lia.command.add("chargetname", {
    adminOnly = true,
    desc = "@getCharNameDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetCharNameName",
        ButtonText = "View Character Name",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        client:ChatPrint(L("charNameIs", target:getChar():getName()))
    end
})

lia.command.add("chargethealth", {
    adminOnly = true,
    desc = "@getHealthDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetCharHealthName",
        ButtonText = "View Health",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        client:ChatPrint(L("charHealthIs", target:Health(), target:GetMaxHealth()))
    end
})

lia.command.add("chargetmoney", {
    adminOnly = true,
    desc = "@getMoneyDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetCharMoneyName",
        ButtonText = "View Money",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local money = target:getChar():getMoney()
        client:ChatPrint(L("charMoneyIs", lia.currency.get(money)))
    end
})

lia.command.add("chargetinventory", {
    adminOnly = true,
    desc = "@getInventoryDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetCharInventoryName",
        ButtonText = "View Inventory",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local inventory = target:getChar():getInv()
        local items = inventory:getItems()
        if not items or table.Count(items) < 1 then
            client:notifyInfoLocalized("charInvEmpty")
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
    desc = "@getAllInfosDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@adminStickGetAllInfosName",
        ButtonText = "View All Info",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyErrorLocalized("noChar")
            return
        end

        local data = lia.char.getCharData(char:getID())
        if not data then
            client:notifyErrorLocalized("noChar")
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

        client:notifyInfoLocalized("infoPrintedConsole")
    end
})

lia.command.add("dropmoney", {
    desc = "@dropMoneyDesc",
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
                if admin:IsAdmin() then admin:notifyLocalized("moneyDupeAttempt", client:Name(), "dropmoney", tostring(originalAmount), tostring(amount)) end
            end
        end

        if not amount or amount <= 0 then
            client:notifyErrorLocalized("invalidArg")
            return
        end

        local character = client:getChar()
        if not character or not character:hasMoney(amount) then
            client:notifyErrorLocalized("notEnoughMoney")
            return
        end

        local maxEntities = lia.config.get("MaxMoneyEntities", 3)
        local existingMoneyEntities = 0
        for _, entity in pairs(ents.FindByClass("lia_money")) do
            if entity.client == client then existingMoneyEntities = existingMoneyEntities + 1 end
        end

        if existingMoneyEntities >= maxEntities then
            client:notifyErrorLocalized("maxMoneyEntitiesReached", maxEntities)
            return
        end

        character:takeMoney(amount)
        local money = lia.currency.spawn(client:getItemDropPos(), amount)
        if IsValid(money) then
            money.client = client
            money.charID = character:getID()
            client:notifyMoneyLocalized("moneyDropped", lia.currency.get(amount))
            lia.log.add(client, "moneyDropped", amount)
        end

        client:doGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
    end
})

lia.command.add("exportprivileges", {
    adminOnly = true,
    desc = "@exportprivilegesDesc",
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
            client:notifySuccessLocalized("privilegesExportedSuccessfully", filename)
            MsgC(Color(83, 143, 239), "[Lilia] ", "[" .. L("admin") .. "] ")
            MsgC(Color(255, 153, 0), L("privilegesExportedBy", client:Nick(), filename), "\n")
            lia.log.add(client, "privilegesExported", filename)
        else
            client:notifyErrorLocalized("privilegesExportFailed")
            lia.error(L("privilegesExportFailed"))
        end
    end
})

lia.command.add("fillwithbots", {
    superAdminOnly = true,
    desc = "@botsManageDesc",
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
            client:notifyErrorLocalized("botsAlreadyAdding")
            return
        end

        local requestedAmount = arguments.amount
        if requestedAmount then
            requestedAmount = math.max(1, math.floor(requestedAmount))
            local maxPlayers = game.MaxPlayers()
            local availableSlots = maxPlayers - player.GetCount()
            if requestedAmount > availableSlots then
                client:notifyErrorLocalized("spawnBotsLimit", requestedAmount, availableSlots, maxPlayers)
                return
            end

            if requestedAmount <= 0 then
                client:notifyErrorLocalized("spawnBotsInvalidAmount")
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

            client:notifyInfoLocalized("spawningBots", requestedAmount)
        else
            timer.Create("Bots_Add_Timer", 2, 0, function()
                if player.GetCount() < game.MaxPlayers() then
                    game.ConsoleCommand("bot\n")
                else
                    timer.Remove("Bots_Add_Timer")
                end
            end)

            client:notifyInfoLocalized("botsFillingServer")
        end
    end
})

lia.command.add("spawnbots", {
    superAdminOnly = true,
    desc = "@spawnBotsDesc",
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
            client:notifyErrorLocalized("spawnBotsLimit", requestedAmount, availableSlots, maxPlayers)
            return
        end

        if requestedAmount <= 0 then
            client:notifyErrorLocalized("spawnBotsInvalidAmount")
            return
        end

        local botsSpawned = 0
        client:notifyInfoLocalized("spawningBots", requestedAmount)
        for i = 1, requestedAmount do
            timer.Simple((i - 1) * 0.5, function()
                if not IsValid(client) then return end
                game.ConsoleCommand("bot\n")
                botsSpawned = botsSpawned + 1
            end)
        end

        timer.Simple(requestedAmount * 0.5 + 2, function() if IsValid(client) then client:notifySuccessLocalized("botsSpawnedSimple", botsSpawned) end end)
    end
})

lia.command.add("bot", {
    superAdminOnly = true,
    desc = "@spawnBotDesc",
    onRun = function(client)
        if not SERVER then return end
        local maxPlayers = game.MaxPlayers()
        if player.GetCount() >= maxPlayers then
            client:notifyErrorLocalized("spawnBotsLimit", 1, 0, maxPlayers)
            return
        end

        client:notifyInfoLocalized("spawningBots", 1)
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
                client:notifySuccessLocalized("botSpawnedAndBrought", botName)
            else
                client:notifyErrorLocalized("botSpawnFailed")
            end
        end)
    end
})

lia.command.add("botspeak", {
    superAdminOnly = true,
    desc = "@botsSpeakDesc",
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
            client:notifyErrorLocalized("noBotsFound")
            return
        end

        client:notifyInfoLocalized("foundBotsStarting", #bots, phrasesPerBot)
        local randomPhrases = {L("chatHelloThere"), L("chatWhatsGoingOn"), L("chatNeedHelp"), L("chatOverHere"), L("chatWatchOut"), L("chatComeOn"), L("chatLetsGo"), L("chatThisWay"), L("chatBehindYou"), L("chatEnemySpotted"), L("chatClear"), L("chatMoveUp"), L("chatHoldPosition"), L("chatCoverMe"), L("chatReloading"), L("chatTakingFire"), L("chatNeedBackup"), L("chatAllClear"), L("chatContact"), L("chatEngaging"), L("chatFallBack"), L("chatPushForward"), L("chatHoldTheLine"), L("chatSecureArea"), L("chatEnemyDown"), L("chatGotOne"), L("chatNiceShot"), L("chatGoodWork"), L("chatKeepMoving"), L("chatStayAlert")}
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
                    client:notifySuccessLocalized("botFinishedPhrases", bot:GetName() or tostring(bot), phrasesPerBot)
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

            client:notifySuccessLocalized("allBotsFinished", totalPhrases)
        end)
    end
})

lia.command.add("charsetattrib", {
    superAdminOnly = true,
    desc = "@setAttributes",
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
        Name = "@setAttributes",
        ButtonText = "Set Attributes",
        Category = "Attributes",
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyErrorLocalized("noAttributesRegistered")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        local attribName = arguments[2]
        local attribNumber = tonumber(arguments[3])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        lia.log.add(client, "attribCheck", target:Name())
        local character = target:getChar()
        if character then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(v.name, attribName) or lia.util.stringMatches(k, attribName) then
                    character:setAttrib(k, math.abs(attribNumber))
                    client:notifySuccessLocalized("attribSet", target:Name(), v.name, math.abs(attribNumber))
                    lia.log.add(client, "attribSet", target:Name(), k, math.abs(attribNumber))
                    return
                end
            end
        end
    end
})

lia.command.add("checkattributes", {
    adminOnly = true,
    desc = "@checkAttributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@checkAttributes",
        ButtonText = "View Attributes",
        Category = "Attributes",
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyErrorLocalized("noAttributesRegistered")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local attributesData = {}
        for attrKey, attrData in SortedPairsByMemberValue(lia.attribs.list, "name") do
            local currentValue = target:getChar():getAttrib(attrKey, 0) or 0
            local maxValue = hook.Run("GetAttributeMax", target, attrKey) or 100
            local progress = math.Round(currentValue / maxValue * 100, 1)
            table.insert(attributesData, {
                charID = attrData.name,
                name = L(attrData.name),
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
                    [L("attribAmount")] = "text",
                    [L("attribMode")] = {L("add"), L("set")}
                },
                net = "ChangeAttribute"
            }
        }, client:getChar():getID())
    end
})

lia.command.add("staffdiscord", {
    desc = "@staffdiscordDesc",
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
            client:notifyErrorLocalized("noStaffChar")
            return
        end

        client:setLiliaData("staffDiscord", discord)
        local description = L("staffCharacterDiscordSteamID", discord, client:SteamID())
        character:setDesc(description)
        client:notifySuccessLocalized("staffDescUpdated")
    end
})

lia.command.add("trunk", {
    adminOnly = false,
    desc = "@trunkOpenDesc",
    onRun = function(client)
        local entity = client:getTracedEntity()
        local maxDistance = 128
        local openTime = 0.7
        if not IsValid(entity) then
            client:notifyErrorLocalized("notLookingAtVehicle")
            return
        end

        if hook.Run("IsSuitableForTrunk", entity) == false then
            client:notifyErrorLocalized("notLookingAtVehicle")
            return
        end

        if client:GetPos():Distance(entity:GetPos()) > maxDistance then
            client:notifyErrorLocalized("tooFarToOpenTrunk")
            return
        end

        client.liaStorageEntity = entity
        client:setAction(L("openingTrunk"), openTime, function()
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
                    client:notifyErrorLocalized("noInventory")
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
                    client:notifyErrorLocalized("unableCreateStorageEntity", entity:GetClass(), err)
                    client.liaStorageEntity = nil
                end)
            end
        end)
    end
})

lia.command.add("charaddattrib", {
    superAdminOnly = true,
    desc = "@addAttributes",
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
        Name = "@addAttributes",
        ButtonText = "Add Attributes",
        Category = "Attributes",
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyErrorLocalized("noAttributesRegistered")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        local attribName = arguments[2]
        local attribNumber = tonumber(arguments[3])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local character = target:getChar()
        if character then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(v.name, attribName) or lia.util.stringMatches(k, attribName) then
                    character:updateAttrib(k, math.abs(attribNumber))
                    client:notifySuccessLocalized("attribUpdate", target:Name(), v.name, math.abs(attribNumber))
                    lia.log.add(client, "attribAdd", target:Name(), k, math.abs(attribNumber))
                    return
                end
            end
        end
    end
})

lia.command.add("banooc", {
    adminOnly = true,
    desc = "@banOOCCommandDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@banOOC",
        ButtonText = "Ban From OOC",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        target:setLiliaData("oocBanned", true)
        client:notifySuccessLocalized("playerBannedFromOOC", target:Name())
        lia.log.add(client, "banOOC", target:Name(), target:SteamID())
    end
})

lia.command.add("unbanooc", {
    adminOnly = true,
    desc = "@unbanOOCCommandDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@unbanOOCStickName",
        ButtonText = "Unban From OOC",
        Category = "Communication",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        target:setLiliaData("oocBanned", nil)
        client:notifySuccessLocalized("playerUnbannedFromOOC", target:Name())
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
    desc = "@plyRespawnDesc",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        target:Spawn()
        client:notifySuccessLocalized("playerForceRespawned", target:Name())
        target:notifyLocalized("youWereForceRespawned")
        lia.log.add(client, "plyrespawn", target:Name())
    end
})

lia.command.add("forcerespawn", {
    desc = "@forceRespawnDesc",
    onRun = function(client)
        if client:Alive() then
            client:notifyErrorLocalized("playerAlreadyAlive")
            return
        end

        local baseTime = lia.config.get("SpawnTime", 5)
        baseTime = hook.Run("OverrideSpawnTime", client, baseTime) or baseTime
        local lastDeath = client:getLocalVar("lastDeathTime", os.time())
        local timePassed = os.time() - lastDeath
        if timePassed < baseTime then
            client:notifyErrorLocalized("cannotRespawnYet", baseTime - timePassed)
            return
        end

        client:Spawn()
        client:setLocalVar("lastDeathTime", 0)
        client:notifySuccessLocalized("playerForceRespawned", client:Name())
        client:notifyLocalized("youWereForceRespawned")
        lia.log.add(client, "forcerespawn", client:Name())
    end
})


-- Remaining administration command registrations.
lia.command.add("clearchat", {
    adminOnly = true,
    desc = "@clearChatCommandDesc",
    onRun = function(client)
        net.Start("liaRegenChat")
        net.Broadcast()
        lia.log.add(client, "clearChat")
    end
})

lia.command.add("kickbots", {
    privilege = "@manageBots",
    desc = "@kickAllBotsDesc",
    onRun = function(client)
        if timer.Exists("Bots_Add_Timer") then timer.Remove("Bots_Add_Timer") end
        local kickedCount = 0
        for _, bot in player.Iterator() do
            if bot:IsBot() then
                bot:Kick(L("allBotsKicked"))
                client:notifySuccessLocalized("plyKicked")
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
            client:notifyErrorLocalized("noBotsToKick")
        else
            client:notifyInfoLocalized("botsKickedAll", kickedCount)
        end
    end
})

lia.command.add("npcchangetype", {
    adminOnly = true,
    desc = "@npcchangetypeDesc",
    AdminStick = {
        Name = "@npcChangeTypeTitle",
        ButtonText = "Change NPC Type",
        Category = "NPCs",
        TargetClass = "lia_npc",
    },
    onRun = function(client)
        local permission = client:hasPrivilege("Can Manage NPCs")
        lia.debug("[Permissions]", "Permission Check for command npcchangetype", "hasPrivilege(Can Manage NPCs)=", tostring(permission), "finalResult=", tostring(permission))
        if not permission then return client:notifyErrorLocalized("noManageNPCPermission") end
        local ent = client:getTracedEntity()
        if not ent or not IsValid(ent) then return client:notifyErrorLocalized("mustLookAtValidEntity") end
        if not lia.dialog.isDialogNPCEntity(ent) then return client:notifyErrorLocalized("mustLookAtDialogNPC") end
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
                client:requestDropdown("@npcChangeTypeTitle", "@npcChangeTypePrompt", npcOptions, function(selectedDisplayName, selectedUniqueID)
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
                                client:notifyInfoLocalized("npcTypeChanged", npcData.PrintName or npcType)
                            end
                        end
                    end
                end)
            else
                client:notifyErrorLocalized("noNPCTypesAvailable")
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
    desc = "@viewBodygroupsDesc",
    AdminStick = {
        Name = "@viewBodygroupsDesc",
        ButtonText = "View Bodygroups",
        Category = "Character Info",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1] or "")
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
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
        client:notifyErrorLocalized("commandConsoleOnly")
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
        client:notifyErrorLocalized("commandConsoleOnly")
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
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("gaveMoneyToCharacterOnline", lia.currency.get(amount), charName, charID, lia.currency.get(actualNewMoney)) .. "\n")
                if updatedCount == #characters then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("successfullyGaveMoneyToCharacters", lia.currency.get(amount), #characters, steamID) .. "\n")
                    lia.log.add(nil, "giveMoneySteamID", steamID, amount, #characters)
                end
            else
                if lia.char.setCharDatabase(charID, "money", newMoney) then
                    updatedCount = updatedCount + 1
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("gaveMoneyToCharacterOffline", lia.currency.get(amount), charName, charID, lia.currency.get(newMoney)) .. "\n")
                    if updatedCount == #characters then
                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("successfullyGaveMoneyToCharacters", lia.currency.get(amount), #characters, steamID) .. "\n")
                        lia.log.add(nil, "giveMoneySteamID", steamID, amount, #characters)
                    end
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("errorUpdatingMoneyForCharacter", charName, charID) .. "\n")
                end
            end
        end
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("databaseErrorValue", tostring(err)) .. "\n") end)
end)
