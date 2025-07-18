﻿local MODULE = MODULE
net.Receive("TransferMoneyFromP2P", function(_, sender)
    local amount = net.ReadUInt(32)
    local target = net.ReadEntity()
    if not IsValid(sender) or not sender:getChar() then return end
    if not IsValid(target) or not target:IsPlayer() or not target:getChar() then return end
    if amount <= 0 or not sender:getChar():hasMoney(amount) then return end
    target:getChar():giveMoney(amount)
    sender:getChar():takeMoney(amount)
    local senderName = sender:getChar():getDisplayedName(target)
    local targetName = sender:getChar():getDisplayedName(sender)
    sender:notifyLocalized("moneyTransferSent", lia.currency.get(amount), targetName)
    target:notifyLocalized("moneyTransferReceived", lia.currency.get(amount), senderName)
end)

net.Receive("RunOption", function(_, ply)
    local name = net.ReadString()
    local opt = MODULE.Interactions[name]
    local tracedEntity = ply:getTracedEntity()
    if opt and opt.runServer and IsValid(tracedEntity) then opt.onRun(ply, tracedEntity) end
end)

net.Receive("RunLocalOption", function(_, ply)
    local name = net.ReadString()
    local opt = MODULE.Actions[name]
    if opt and opt.runServer then opt.onRun(ply) end
end)
