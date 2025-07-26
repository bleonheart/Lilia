AddInteraction(L("giveMoney"), {
    serverRun = false,
    shouldShow = function(client, target)
        return IsValid(target) and target:IsPlayer() and client:getChar():getMoney() > 0
    end,
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
