
-- Warning command registrations.
lia.command.add("warn", {
    adminOnly = true,
    desc = "@warnDesc",
    arguments = {
        {
            name = "target",
            type = "player"
        },
        {
            name = "severity",
            type = "string",
            optional = true
        },
        {
            name = "reason",
            type = "string"
        },
    },
    AdminStick = {
        Name = "@warnPlayer",
        ButtonText = "Warn Player",
        Category = "Warnings",
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        local rawSeverity = arguments[2]
        local reasonStartIndex = 3
        local severity = "Medium"
        local function normalizeSeverity(value)
            if not isstring(value) then return nil end
            local lowered = string.lower(string.Trim(value))
            if lowered == "low" or lowered == "minor" then return "Low" end
            if lowered == "medium" or lowered == "med" then return "Medium" end
            if lowered == "high" or lowered == "major" then return "High" end
            return nil
        end

        local normalized = normalizeSeverity(rawSeverity)
        if normalized then
            severity = normalized
        elseif rawSeverity and rawSeverity ~= "" then
            client:notifyErrorLocalized("invalidArg")
            return
        else
            reasonStartIndex = 2
        end

        local reason = table.concat(arguments, " ", reasonStartIndex)
        if not targetName or reason == "" then return L("warnUsage") end
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local warnerName = client:Nick()
        local warnerSteamID = client:SteamID()
        hook.Run("AddWarning", target:getChar():getID(), target:Nick(), target:SteamID(), timestamp, reason, warnerName, warnerSteamID, severity)
        lia.db.count("warnings", "charID = " .. lia.db.convertDataType(target:getChar():getID())):next(function(count)
            target:notifyWarningLocalized("playerWarned", warnerName .. " (" .. warnerSteamID .. ")", severity, reason)
            client:notifySuccessLocalized("warningIssued", target:Nick())
            local message = L("staffLogWarnedPlayer", warnerName, target:Name(), target:getChar():getID(), target:SteamID64(), reason, severity)
            StaffAddTextShadowed(Color(255, 140, 0), "WARNING", Color(255, 255, 255), message)
            hook.Run("WarningIssued", client, target, reason, severity, count, warnerSteamID, target:SteamID())
        end)
    end
})


lia.command.add("viewwarns", {
    adminOnly = true,
    desc = "@viewWarnsDesc",
    arguments = {
        {
            name = "target",
            type = "string"
        },
    },
    AdminStick = {
        Name = "@viewPlayerWarnings",
        ButtonText = "View Warnings",
        Category = "Warnings",
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local target = lia.util.findPlayer(client, targetName)
        local lookupSteamID, displayName = targetName, targetName
        local warningsPromise
        if IsValid(target) then
            displayName = target:Nick()
            warningsPromise = lia.db.select({"id", "timestamp", "message", "warner", "warnerSteamID", "severity"}, "warnings", "charID = " .. lia.db.convertDataType(target:getChar():getID())):next(function(res) return res.results or {} end)
        else
            warningsPromise = lia.db.select({"id", "timestamp", "message", "warner", "warnerSteamID", "severity", "warned"}, "warnings", "warnedSteamID = " .. lia.db.convertDataType(lookupSteamID)):next(function(res)
                local rows = res.results or {}
                if #rows > 0 then displayName = rows[1].warned or displayName end
                return rows
            end)
        end

        warningsPromise:next(function(warns)
            if #warns == 0 then
                client:notifyInfoLocalized("noWarnings", displayName)
                return
            end

            local warningList = {}
            for index, warn in ipairs(warns) do
                table.insert(warningList, {
                    index = index,
                    timestamp = warn.timestamp or L("na"),
                    admin = string.format("%s (%s)", warn.warner or L("na"), warn.warnerSteamID or L("na")),
                    warningMessage = warn.message or L("na"),
                    severity = warn.severity or "Medium"
                })
            end

            lia.util.sendTableUI(client, L("playerWarningsTitle", displayName), {
                {
                    name = "id",
                    field = "index"
                },
                {
                    name = "timestamp",
                    field = "timestamp"
                },
                {
                    name = "admin",
                    field = "admin"
                },
                {
                    name = "warningMessage",
                    field = "warningMessage"
                },
                {
                    name = L("warningSeverity"),
                    field = "severity"
                }
            }, warningList, {
                {
                    name = L("removeThing", L("warning")),
                    net = "liaRequestRemoveWarning"
                }
            }, target:getChar():getID())

            lia.log.add(client, "viewWarns", target)
        end)
    end
})

local function GetWarningsByIssuer(steamID)
    local condition = "warnerSteamID = " .. lia.db.convertDataType(steamID)
    return lia.db.select({"id", "timestamp", "message", "warned", "warnedSteamID", "warner", "warnerSteamID", "severity"}, "warnings", condition):next(function(res) return res.results or {} end)
end

lia.command.add("viewwarnsissued", {
    adminOnly = true,
    desc = "@viewWarnsIssuedDesc",
    arguments = {
        {
            name = "staff",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local target = lia.util.findPlayer(client, targetName)
        local steamID, displayName = targetName, targetName
        if IsValid(target) then
            steamID = target:SteamID()
            displayName = target:Nick()
        end

        GetWarningsByIssuer(steamID):next(function(warns)
            if #warns == 0 then
                client:notifyInfoLocalized("noWarnings", displayName)
                return
            end

            local warningList = {}
            for index, warn in ipairs(warns) do
                warningList[#warningList + 1] = {
                    index = index,
                    timestamp = warn.timestamp or L("na"),
                    player = string.format("%s (%s)", warn.warned or L("na"), warn.warnedSteamID or L("na")),
                    warningMessage = warn.message or L("na"),
                    severity = warn.severity or "Medium"
                }
            end

            lia.util.sendTableUI(client, L("warningsIssuedTitle", displayName), {
                {
                    name = "id",
                    field = "index"
                },
                {
                    name = "timestamp",
                    field = "timestamp"
                },
                {
                    name = "player",
                    field = "player"
                },
                {
                    name = "warningMessage",
                    field = "warningMessage"
                },
                {
                    name = L("warningSeverity"),
                    field = "severity"
                }
            }, warningList)

            lia.log.add(client, "viewWarnsIssued", target or steamID)
        end)
    end
})

