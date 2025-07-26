AddAction(L("changeToWhisper"), {
    shouldShow = function(client)
        return client:getChar() and client:Alive()
    end,
    onRun = function(client)
        if CLIENT then return end
        client:setNetVar("VoiceType", "Whispering")
        client:notifyLocalized("voiceModeSet", "Whispering")
    end,
    runServer = true
})

AddAction(L("changeToTalk"), {
    shouldShow = function(client)
        return client:getChar() and client:Alive()
    end,
    onRun = function(client)
        if CLIENT then return end
        client:setNetVar("VoiceType", "Talking")
        client:notifyLocalized("voiceModeSet", "Talking")
    end,
    runServer = true
})

AddAction(L("changeToYell"), {
    shouldShow = function(client)
        return client:getChar() and client:Alive()
    end,
    onRun = function(client)
        if CLIENT then return end
        client:setNetVar("VoiceType", "Yelling")
        client:notifyLocalized("voiceModeSet", "Yelling")
    end,
    runServer = true
})
