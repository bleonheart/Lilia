lia.command.add("addrestarttime", {
    adminOnly = true,
    onRun = function(client, arguments)
        local delay = arguments[1]
        delay = delay or 60
        PLUGIN.NextRestart = PLUGIN.NextRestart + (delay * 60)
        PLUGIN.NextNotificationTime = PLUGIN.NextNotificationTime + (delay * 60)
        lia.util.notify(string.format("Added %d minutes to server restart time!", delay))
    end
})