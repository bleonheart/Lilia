net.Receive("liaConfigUpdate", function(len, client)
    local key = net.ReadString()
    local value = net.ReadType()
    if key == "Theme" then
        lia.config.set(key, value, client)
        client:notify(L("themeUpdatedTo", tostring(value)))
    end
end)
