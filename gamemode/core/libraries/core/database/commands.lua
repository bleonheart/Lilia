concommand.Add("lia_snapshot", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    if not args[1] then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_snapshot <table_name>" .. "\n")
        return
    end

    local tableName = args[1]
    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Creating snapshot for table: %s", tableName) .. "\n")
    lia.db.createSnapshot(tableName):next(function(snapshot)
        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Snapshot created successfully!" .. "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Records: %s", snapshot.records) .. "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Path: %s", snapshot.path) .. "\n")
    end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Snapshot failed: %s", tostring(err)) .. "\n") end)
end)

concommand.Add("lia_snapshot_load", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    if not args[1] then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_snapshot_load <filename>" .. "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Available snapshots:" .. "\n")
        local files = file.Find("lilia/snapshots/*", "DATA")
        if #files == 0 then
            MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "No snapshots found" .. "\n")
        else
            for _, fileName in ipairs(files) do
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  - " .. fileName .. "\n")
            end
        end
        return
    end

    local fileName = args[1]
    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Loading snapshot: %s", fileName) .. "\n")
    lia.db.loadSnapshot(fileName):next(function(result)
        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Snapshot loaded successfully!" .. "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Table: %s", result.table) .. "\n")
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Records: %s", result.records) .. "\n")
    end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Snapshot load failed: %s", tostring(err)) .. "\n") end)
end)

concommand.Add("lia_wipetable", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    if not args[1] then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_wipetable <table_name>" .. "\n")
        return
    end

    local tableName = args[1]
    local fullTableName = "lia_" .. tableName
    MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), string.format("Creating backup before wiping table: %s", tableName) .. "\n")
    lia.db.createSnapshot(tableName):next(function(snapshot)
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Backup created: %s", snapshot.file) .. "\n")
        MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), string.format("Wiping table: %s", fullTableName) .. "\n")
        lia.db.query("DELETE FROM " .. fullTableName, function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Table %s has been wiped successfully!", fullTableName) .. "\n") end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Failed to wipe table: %s", tostring(err)) .. "\n") end)
    end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Backup failed, aborting wipe: %s", tostring(err)) .. "\n") end)
end)

local wipeConfirmationExpires = 0
concommand.Add("lia_wipedb", function(client)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    if wipeConfirmationExpires < RealTime() then
        wipeConfirmationExpires = RealTime() + 3
        MsgC(Color(255, 0, 0), "[Lilia] THIS WILL PERMANENTLY DELETE EVERY lia_ DATABASE TABLE.\n")
        MsgC(Color(255, 0, 0), "[Lilia] Run lia_wipedb again within 3 seconds to confirm.\n")
        return
    end

    wipeConfirmationExpires = 0
    lia.db.wipeTables(function()
        lia.information("Database Wiped")
        lia.db.loadTables()
        hook.Add("PostLoadData", "lia_wipedb_changemap", function()
            hook.Remove("PostLoadData", "lia_wipedb_changemap")
            timer.Simple(2.5, function()
                lia.information("Database wipe complete. Changing map...")
                RunConsoleCommand("changelevel", game.GetMap())
            end)
        end)
    end)
end)

concommand.Add("lia_wipelogs", function(client)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    lia.db.wipeLogs()
    lia.information("All logs have been wiped!")
end)

concommand.Add("lia_wipebans", function(client)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    lia.db.wipeBans()
    lia.information("All bans have been wiped!")
end)

concommand.Add("lia_wipepersistence", function(client)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    lia.data.deleteAll()
    lia.information("All persistence data has been wiped!")
end)