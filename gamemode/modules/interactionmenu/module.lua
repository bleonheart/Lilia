MODULE.name = "Interaction Menu"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides a contextual interaction menu with shortcuts for dropping money, toggling voice, and recognizing other players."
lia.command.add("datatest", {
    adminOnly = true,
    desc = "datatestDesc",
    syntax = "[string set|get] [string key] [string value]",
    onRun = function(client, arguments)
        local action = arguments[1] and arguments[1]:lower()
        local key = arguments[2]
        if not action or not key then
            client:notify("Usage: datatest <set|get> <key> [value]")
            return
        end

        if action == "set" then
            local value = table.concat(arguments, " ", 3)
            if value == "" then
                client:notify("No value provided.")
                return
            end

            lia.data.set(key, value)
            client:notify("Saved '" .. key .. "' = '" .. value .. "'.")
        elseif action == "get" then
            local stored = lia.data.get(key)
            client:notify("Value for '" .. key .. "' is '" .. tostring(stored) .. "'.")
        else
            client:notify("Invalid action. Use set or get.")
        end
    end
})