if CLIENT then
    lia.net.readBigTable("liaSendTableUI", function(data) lia.util.createTableUI(data.title, data.columns, data.data, data.options, data.characterID) end)
    net.Receive("liaDataSync", function()
        local bytesRemaining = net.BytesLeft()
        if bytesRemaining > 100 then
            local tableSuccess, data = pcall(net.ReadTable)
            if tableSuccess and istable(data) then
                local firstSuccess, first = pcall(net.ReadType)
                local lastSuccess, last = pcall(net.ReadType)
                lia.localData = data
                if firstSuccess then lia.firstJoin = first end
                if lastSuccess then lia.lastJoin = last end
                return
            end
        end

        local key = net.ReadString()
        local value = net.ReadType()
        lia.localData = lia.localData or {}
        lia.localData[key] = value
    end)

    net.Receive("liaNetVar", function()
        local index = net.ReadUInt(16)
        local key = net.ReadString()
        local value = net.ReadType()
        lia.net[index] = lia.net[index] or {}
        local oldValue = lia.net[index][key]
        lia.net[index][key] = value
        local entity = Entity(index)
        if IsValid(entity) then hook.Run("NetVarChanged", entity, key, oldValue, value) end
    end)

    net.Receive("liaNetLocal", function()
        local key = net.ReadString()
        local value = net.ReadType()
        local idx = LocalPlayer():EntIndex()
        lia.net[idx] = lia.net[idx] or {}
        lia.net[idx][key] = value
        hook.Run("OnLocalVarSet", key, value)
    end)

    net.Receive("liaGlobalVar", function()
        local key = net.ReadString()
        local value = net.ReadType()
        local oldValue = lia.net.globals[key]
        lia.net.globals[key] = value
        hook.Run("NetVarChanged", nil, key, oldValue, value)
    end)

    net.Receive("liaNetDel", function()
        local index = net.ReadUInt(16)
        lia.net[index] = nil
    end)
end
