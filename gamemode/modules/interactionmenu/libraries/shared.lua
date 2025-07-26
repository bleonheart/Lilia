local MODULE = MODULE
MODULE.Actions = {}
MODULE.Interactions = {}
function AddInteraction(name, data)
    MODULE.Interactions[name] = data
end

function AddAction(name, data)
    MODULE.Actions[name] = data
end

AddAction(L("changeToWhisper"), {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if CLIENT then return end
        client:setNetVar("VoiceType", "Whispering")
        client:notifyLocalized("voiceModeSet", "Whispering")
    end,
    runServer = true
})

AddAction(L("changeToTalk"), {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if CLIENT then return end
        client:setNetVar("VoiceType", "Talking")
        client:notifyLocalized("voiceModeSet", "Talking")
    end,
    runServer = true
})

AddAction(L("changeToYell"), {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        if CLIENT then return end
        client:setNetVar("VoiceType", "Yelling")
        client:notifyLocalized("voiceModeSet", "Yelling")
    end,
    runServer = true
})

AddInteraction(L("giveMoney"), {
    serverRun = false,
    shouldShow = function(client, target) return IsValid(target) and target:IsPlayer() and client:getChar():getMoney() > 0 end,
    onRun = function(client, target)
        local frame = vgui.Create("DFrame")
        frame:SetSize(600, 250)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle(L("enterAmount"))
        frame:ShowCloseButton(false)
        frame.te = frame:Add("DTextEntry")
        frame.te:SetSize(frame:GetWide() * 0.6, 30)
        frame.te:SetNumeric(true)
        frame.te:Center()
        frame.te:RequestFocus()
        function frame.te:OnEnter()
            local val = tonumber(frame.te:GetText())
            if not val or val <= 0 then
                client:notifyLocalized("moneyValueError")
                return
            end

            val = math.ceil(val)
            if not client:getChar():hasMoney(val) then
                client:notifyLocalized("notEnoughMoney")
                return
            end

            net.Start("TransferMoneyFromP2P")
            net.WriteUInt(val, 32)
            net.WriteEntity(target)
            net.SendToServer()
            frame:Close()
        end

        frame.ok = frame:Add("liaMediumButton")
        frame.ok:SetSize(150, 30)
        frame.ok:CenterHorizontal()
        frame.ok:CenterVertical(0.7)
        frame.ok:SetText(L("giveMoney"))
        frame.ok:SetTextColor(color_white)
        frame.ok:SetFont("liaSmallFont")
        frame.ok.DoClick = frame.te.OnEnter
    end
})

if SERVER then
    net.Receive("RunOption", function(_, ply)
        if lia.config.get("DisableCheaterActions", true) and ply:getNetVar("cheater", false) then
            lia.log.add(ply, "cheaterAction", "use interaction option")
            return
        end

        local name = net.ReadString()
        local opt = MODULE.Interactions[name]
        local tracedEntity = ply:getTracedEntity()
        if opt and opt.runServer and IsValid(tracedEntity) then opt.onRun(ply, tracedEntity) end
    end)

    net.Receive("RunLocalOption", function(_, ply)
        if lia.config.get("DisableCheaterActions", true) and ply:getNetVar("cheater", false) then
            lia.log.add(ply, "cheaterAction", "use local option")
            return
        end

        local name = net.ReadString()
        local opt = MODULE.Actions[name]
        if opt and opt.runServer then opt.onRun(ply) end
    end)
end