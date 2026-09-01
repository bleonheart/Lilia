if SERVER then
    net.Receive("liaKeybindServer", function(_, ply)
        if not IsValid(ply) then return end
        local action = net.ReadString()
        local player = net.ReadEntity()
        if not IsValid(player) or player ~= ply then return end
        if not lia.keybind.stored[action] then return end
        local data = lia.keybind.stored[action]
        local isRelease = action:find("_release$")
        if isRelease then
            if data.release and data.serverOnly then
                local success, err = pcall(data.release, player)
                if not success then lia.error("Keybind release callback error: " .. tostring(err)) end
            end
        elseif data.callback and data.serverOnly then
            local success, err = pcall(data.callback, player)
            if not success then lia.error("Keybind callback error: " .. tostring(err)) end
        end
    end)
end
