net.Receive("liaConfigUpdate", function(_, client)
    local key = net.ReadString()
    local value = net.ReadType()
    if key == "Theme" then
        local forceTheme = lia.config.get("forceTheme", true)
        if forceTheme then
            client:notify(L("themesDisabledByServer"))
            return
        end
        lia.config.set(key, value, client)
        client:notify(L("themeUpdatedTo", tostring(value)))
    end
end)
