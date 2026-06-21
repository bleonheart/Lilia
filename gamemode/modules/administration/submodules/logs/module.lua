--[[
    Hooks:
        OnServerLog(Player client, string logType, string logString, string category)

    Purpose:
        Called whenever a server log entry is created through lia.log.add.

    Parameters:
        client (Player)
            The player associated with the log entry. May be invalid or nil for console/system logs.

        logType (string)
            The internal log type identifier used to generate the log message.

        logString (string)
            The final formatted log message.

        category (string)
            The translated category name assigned to the log entry.

    Returns:
        nil

    Realm:
        Server
]]
--[[
    Hooks:
        CanPlayerSeeLogs(Player client)

    Purpose:
        Determines whether a player is allowed to receive and view server log entries.

    Parameters:
        client (Player)
            The player whose log-viewing permission should be checked.

    Returns:
        boolean
            True if admin console log networking is enabled and the player has the canSeeLogs privilege.

    Realm:
        Server
]]
MODULE.Name = "@logs"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "@categoryLogging"
MODULE.NetworkStrings = {"liaSendLogs", "liaSendLogsCategories", "liaSendLogsCategoriesRequest", "liaSendLogsRequest",}
MODULE.Privileges = {
    ["canSeeLogs"] = {
        Name = "@canSeeLogs",
        MinAccess = "superadmin",
        Category = "@categoryLogging",
    },
}