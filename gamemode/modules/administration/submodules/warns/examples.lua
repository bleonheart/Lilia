-- Example usage of the updated warning hooks
-- This file demonstrates how to use the WarningIssued and WarningRemoved hooks
-- with the new SteamID parameters

-- Hook for when a warning is issued
hook.Add("WarningIssued", "ExampleWarningIssued", function(admin, target, reason, count, adminSteamID, targetSteamID)
    -- Log the warning with all details including SteamIDs
    print(string.format("[WARNING ISSUED] Admin: %s (%s) | Target: %s (%s) | Reason: %s | Total Warnings: %d", 
        admin:Name(), adminSteamID, target:Name(), targetSteamID, reason, count))
    
    -- You could also send this to Discord, database, or other logging systems
    -- Example: Send to Discord webhook
    -- sendToDiscord(string.format("⚠️ Warning issued by %s (%s) to %s (%s) for: %s", 
    --     admin:Name(), adminSteamID, target:Name(), targetSteamID, reason))
end)

-- Hook for when a warning is removed
hook.Add("WarningRemoved", "ExampleWarningRemoved", function(admin, target, warning, index)
    -- Log the warning removal with all details including SteamIDs
    print(string.format("[WARNING REMOVED] Admin: %s (%s) | Target: %s (%s) | Original Admin: %s (%s) | Reason: %s | Index: %d", 
        admin:Name(), admin:SteamID(), target:Name(), warning.targetSteamID, warning.admin, warning.adminSteamID, warning.reason, index))
    
    -- You could also send this to Discord, database, or other logging systems
    -- Example: Send to Discord webhook
    -- sendToDiscord(string.format("🗑️ Warning #%d removed by %s (%s) from %s (%s). Original warning was issued by %s (%s) for: %s", 
    --     index, admin:Name(), admin:SteamID(), target:Name(), warning.targetSteamID, warning.admin, warning.adminSteamID, warning.reason))
end)

-- Example of a more advanced logging system
hook.Add("WarningIssued", "AdvancedWarningLogger", function(admin, target, reason, count, adminSteamID, targetSteamID)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logEntry = {
        timestamp = timestamp,
        action = "warning_issued",
        admin_name = admin:Name(),
        admin_steamid = adminSteamID,
        target_name = target:Name(),
        target_steamid = targetSteamID,
        reason = reason,
        total_warnings = count,
        map = game.GetMap(),
        server_name = GetHostName()
    }
    
    -- You could save this to a JSON file, database, or send to an external service
    print("Advanced Warning Log:", util.TableToJSON(logEntry, true))
end)

hook.Add("WarningRemoved", "AdvancedWarningRemovalLogger", function(admin, target, warning, index)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logEntry = {
        timestamp = timestamp,
        action = "warning_removed",
        remover_name = admin:Name(),
        remover_steamid = admin:SteamID(),
        target_name = target:Name(),
        target_steamid = warning.targetSteamID,
        original_admin = warning.admin,
        original_admin_steamid = warning.adminSteamID,
        original_reason = warning.reason,
        warning_index = index,
        map = game.GetMap(),
        server_name = GetHostName()
    }
    
    -- You could save this to a JSON file, database, or send to an external service
    print("Advanced Warning Removal Log:", util.TableToJSON(logEntry, true))
end)
