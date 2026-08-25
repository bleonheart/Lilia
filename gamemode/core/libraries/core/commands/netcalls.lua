if SERVER then
    net.Receive("liaCommandData", function(_, client)
        local command = net.ReadString()
        local arguments = net.ReadTable()
        if (client.liaNextCmd or 0) < CurTime() then
            local arguments2 = {}
            for _, v in ipairs(arguments) do
                if isstring(v) or isnumber(v) then arguments2[#arguments2 + 1] = tostring(v) end
            end

            lia.command.parse(client, nil, command, arguments2)
            client.liaNextCmd = CurTime() + 0.2
        end
    end)
elseif CLIENT then
    net.Receive("liaCmdArgPrompt", function()
        local cmd = net.ReadString()
        local fields = net.ReadTable()
        local prefix = net.ReadTable()
        local definitions = net.ReadTable()
        lia.command.openArgumentPrompt(cmd, fields, prefix, definitions)
    end)
end
