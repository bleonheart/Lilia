﻿local MODULE = MODULE
lia.command.add("warn", {
    adminOnly = true,
    privilege = "issueWarnings",
    desc = "warnDesc",
    syntax = "[player Target] [string Reason]",
    AdminStick = {
        Name = "warnPlayer",
        Category = "moderationTools",
        SubCategory = "warnings",
        Icon = "icon16/error.png"
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        local reason = table.concat(arguments, " ", 2)
        if not targetName or reason == "" then return L("warnUsage") end
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        if target == client then
            client:notifyLocalized("cannotWarnSelf")
            return
        end

        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local warnerName = client:Nick()
        local warnerSteamID = client:SteamID()
        MODULE:AddWarning(target:getChar():getID(), target:Nick(), target:SteamID(), timestamp, reason, warnerName, warnerSteamID)
        lia.db.count("warnings", "charID = " .. lia.db.convertDataType(target:getChar():getID())):next(function(count)
            target:notifyLocalized("playerWarned", warnerName .. " (" .. warnerSteamID .. ")", reason)
            client:notifyLocalized("warningIssued", target:Nick())
            hook.Run("WarningIssued", client, target, reason, count)
        end)
    end
})

lia.command.add("viewwarns", {
    adminOnly = true,
    privilege = "viewPlayerWarnings",
    desc = "viewWarnsDesc",
    syntax = "[player Target]",
    AdminStick = {
        Name = "viewPlayerWarnings",
        Category = "moderationTools",
        SubCategory = "warnings",
        Icon = "icon16/eye.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        MODULE:GetWarnings(target:getChar():getID()):next(function(warns)
            if #warns == 0 then
                client:notifyLocalized("noWarnings", target:Nick())
                return
            end

            local warningList = {}
            for index, warn in ipairs(warns) do
                table.insert(warningList, {
                    index = index,
                    timestamp = warn.timestamp or L("na"),
                    admin = string.format("%s (%s)", warn.warner or L("na"), warn.warnerSteamID or L("na")),
                    warningMessage = warn.message or L("na")
                })
            end

            lia.util.CreateTableUI(client, L("playerWarningsTitle", target:Nick()), {
                {
                    name = L("id"),
                    field = "index"
                },
                {
                    name = L("timestamp"),
                    field = "timestamp"
                },
                {
                    name = L("admin"),
                    field = "admin"
                },
                {
                    name = L("Warning Message"),
                    field = "warningMessage"
                }
            }, warningList, {
                {
                    name = L("removeWarning"),
                    net = "RequestRemoveWarning"
                }
            }, target:getChar():getID())

            lia.log.add(client, "viewWarns", target)
        end)
    end
})
