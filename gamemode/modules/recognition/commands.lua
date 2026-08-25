-- Recognition command registrations.
lia.command.add("recogwhisper", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    desc = "Force player recognition in whisper range.",
    AdminStick = {
        Name = "Force Recognition (Whisper)",
        ButtonText = "Force Recognize Whisper",
        Category = "Recognition",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) or not target:getChar() then return end
        hook.Run("ForceRecognizeRange", target, "whisper")
    end
})

lia.command.add("recognormal", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    desc = "Force player recognition in normal range.",
    AdminStick = {
        Name = "Force Recognition (Normal)",
        ButtonText = "Force Recognize Nearby",
        Category = "Recognition",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) or not target:getChar() then return end
        hook.Run("ForceRecognizeRange", target, "normal")
    end
})

lia.command.add("recogyell", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    desc = "Force player recognition in yell range.",
    AdminStick = {
        Name = "Force Recognition (Yell)",
        ButtonText = "Force Recognize Yell",
        Category = "Recognition",
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) or not target:getChar() then return end
        hook.Run("ForceRecognizeRange", target, "yell")
    end
})

lia.command.add("recogbots", {
    superAdminOnly = true,
    arguments = {
        {
            name = "range",
            type = "string",
            optional = true
        },
        {
            name = "name",
            type = "string",
            optional = true
        },
    },
    desc = "Force all bots to recognize people around them. Optionally specify a fake name.",
    onRun = function(_, arguments)
        local range = arguments[1] or "normal"
        local fakeName = arguments[2]
        for _, ply in player.Iterator() do
            if ply:IsBot() then hook.Run("ForceRecognizeRange", ply, range, fakeName) end
        end
    end
})
