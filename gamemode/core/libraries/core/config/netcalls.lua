if CLIENT then
    net.Receive("liaCfgList", function()
        local data = net.ReadTable() or {}
        for k, v in pairs(data) do
            local stored = lia.config.stored[k]
            if stored then
                stored.value = lia.config.coerceValue(k, v)
            else
                lia.config.stored[k] = lia.config.stored[k] or {}
                lia.config.stored[k].value = lia.config.coerceValue(k, v)
            end
        end

        hook.Run("InitializedConfig")
    end)

    net.Receive("liaCfgSet", function()
        local key = net.ReadString()
        local _ = net.ReadString()
        local value = net.ReadType()
        local stored = lia.config.stored[key]
        local oldValue = stored and stored.value
        local coerced = lia.config.coerceValue(key, value)
        lia.config.stored[key] = lia.config.stored[key] or {}
        lia.config.stored[key].value = coerced
        hook.Run("OnConfigUpdated", key, oldValue, lia.config.stored[key].value)
    end)
end


if SERVER then
    net.Receive("liaCfgList", function(_, client)
        if not IsValid(client) then return end
        lia.config.send(client)
    end)

    net.Receive("liaCfgSet", function(_, client)
        if not IsValid(client) then return end
        local key = net.ReadString()
        local name = net.ReadString()
        local value = net.ReadType()
        local config = lia.config.stored[key]
        if not config then return end
        value = lia.config.coerceValue(key, value)
        if type(config.default) == type(value) and hook.Run("CanPlayerModifyConfig", client, key) ~= false then
            local oldValue = config.value
            lia.config.set(key, value)
            lia.log.add(client, "configChange", name or config.name or key, oldValue, value)
            hook.Run("ConfigChanged", key, value, oldValue, client)
            client:notifySuccess(string.format("%s has set \\\"%s\\\" to %s.", client:Name(), name or config.name or key, tostring(value)))
        end
    end)
end
