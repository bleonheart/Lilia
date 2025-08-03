local MODULE = MODULE
lia.command.add("warn", {
    adminOnly = true,
    privilege = "Issue Warnings",
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

        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local warnerName = client:Nick()
        local warnerSteamID = client:SteamID()
        MODULE:AddWarning(target:Nick(), target:SteamID64(), timestamp, reason, warnerName, warnerSteamID)
        lia.db.count("warnings", "warnedSteamID = " .. lia.db.convertDataType(target:SteamID64())):next(function(count)
            target:notifyLocalized("playerWarned", warnerName .. " (" .. warnerSteamID .. ")", reason)
            client:notifyLocalized("warningIssued", target:Nick())
            hook.Run("WarningIssued", client, target, reason, count)
        end)
    end
})

lia.command.add("viewwarns", {
    adminOnly = true,
    privilege = "View Player Warnings",
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

        MODULE:GetWarnings(target:SteamID64()):next(function(warns)
            if #warns == 0 then
                client:notifyLocalized("noWarnings", target:Nick())
                return
            end

            local warningList = {}
            for index, warn in ipairs(warns) do
                table.insert(warningList, {
                    index = index,
                    timestamp = warn.timestamp or L("na"),
                    warner = warn.warner or L("na"),
                    warnerSteamID = warn.warnerSteamID or L("na"),
                    warningMessage = warn.message or L("na"),
                    warnedSteamID = warn.warnedSteamID
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
                    name = L("Warner", "Warner"),
                    field = "warner"
                },
                {
                    name = L("Warner Steam ID", "Warner Steam ID"),
                    field = "warnerSteamID"
                },
                {
                    name = L("Warning Message", "Warning Message"),
                    field = "warningMessage"
                }
            }, warningList, {
                {
                    name = L("removeWarning"),
                    net = "RequestRemoveWarning"
                }
            }, 0)

            lia.log.add(client, "viewWarns", target)
        end)
    end
})
