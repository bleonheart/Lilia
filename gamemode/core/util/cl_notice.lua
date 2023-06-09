function lia.util.notify(message)
    chat.AddText(message)
end

-- Creates a translated notification.
function lia.util.notifyLocalized(message, ...)
    lia.util.notify(L(message, ...))
end

-- Receives a notification from the server.
net.Receive("liaNotify", function()
    lia.util.notify(net.ReadString())
end)

-- Receives a notification from the server.
net.Receive("liaNotifyL", function()
    local message = net.ReadString()
    local length = net.ReadUInt(8)
    if length == 0 then return lia.util.notifyLocalized(message) end
    local args = {}

    for i = 1, length do
        args[i] = net.ReadString()
    end

    lia.util.notifyLocalized(message, unpack(args))
end)