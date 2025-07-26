lia.interactionmenu = lia.interactionmenu or {}
lia.interactionmenu.Actions = lia.interactionmenu.Actions or {}
lia.interactionmenu.Interactions = lia.interactionmenu.Interactions or {}
function AddInteraction(name, data)
    lia.interactionmenu.Interactions[name] = data
end

function AddAction(name, data)
    lia.interactionmenu.Actions[name] = data
end

if SERVER then
    net.Receive("RunOption", function(_, ply)
        if lia.config.get("DisableCheaterActions", true) and ply:getNetVar("cheater", false) then
            lia.log.add(ply, "cheaterAction", "use interaction option")
            return
        end

        local name = net.ReadString()
        local opt = lia.interactionmenu.Interactions[name]
        local tracedEntity = ply:getTracedEntity()
        if opt and opt.runServer and IsValid(tracedEntity) then opt.onRun(ply, tracedEntity) end
    end)

    net.Receive("RunLocalOption", function(_, ply)
        if lia.config.get("DisableCheaterActions", true) and ply:getNetVar("cheater", false) then
            lia.log.add(ply, "cheaterAction", "use local option")
            return
        end

        local name = net.ReadString()
        local opt = lia.interactionmenu.Actions[name]
        if opt and opt.runServer then opt.onRun(ply) end
    end)
else
    local function isWithinRange(client, entity)
        if not IsValid(client) or not IsValid(entity) then return false end
        return entity:GetPos():DistToSqr(client:GetPos()) < 250 * 250
    end

    function lia.interactionmenu:checkInteractionPossibilities()
        local client = LocalPlayer()
        local ent = client:getTracedEntity()
        if not IsValid(ent) or not ent:IsPlayer() then return false end
        for _, opt in pairs(self.Interactions) do
            if opt.shouldShow(client, ent) then return true end
        end
        return false
    end

    function lia.interactionmenu.openMenu(options, isInteraction, titleText, closeKey, netMsg)
        local client, ent = LocalPlayer(), LocalPlayer():getTracedEntity()
        local visible = {}
        for name, opt in pairs(options) do
            if isInteraction then
                if IsValid(ent) and ent:IsPlayer() and opt.shouldShow(client, ent) and isWithinRange(client, ent) then
                    visible[#visible + 1] = {
                        name = name,
                        opt = opt
                    }
                end
            else
                if opt.shouldShow(client) then
                    visible[#visible + 1] = {
                        name = name,
                        opt = opt
                    }
                end
            end
        end

        if #visible == 0 then return end
        local fadeSpeed, frameW, entryH, gap = 0.05, 400, 30, 24
        local baseH = entryH * #visible + 140
        local frameH = isInteraction and baseH or math.min(baseH, ScrH() * 0.6)
        local titleH, titleY = isInteraction and 36 or 16, 12
        local padding, xPos, yPos = ScrW() * 0.15, ScrW() - frameW - ScrW() * 0.15, (ScrH() - frameH) / 2
        local frame = vgui.Create("DFrame")
        frame:SetSize(frameW, frameH)
        frame:SetPos(xPos, yPos)
        frame:MakePopup()
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        hook.Run("InteractionMenuOpened", frame)
        local oldOnRemove = frame.OnRemove
        function frame:OnRemove()
            if oldOnRemove then oldOnRemove(self) end
            lia.interactionmenu.Menu = nil
            hook.Run("InteractionMenuClosed")
        end

        frame:SetAlpha(0)
        frame:AlphaTo(255, fadeSpeed)
        function frame:Paint(w, h)
            lia.util.drawBlur(self, 4)
            draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 120))
        end

        function frame:Think()
            if not input.IsKeyDown(closeKey) then self:Close() end
        end

        timer.Remove("InteractionMenu_Frame_Timer")
        timer.Create("InteractionMenu_Frame_Timer", 30, 1, function() if IsValid(frame) then frame:Close() end end)
        local title = frame:Add("DLabel")
        title:SetPos(0, titleY)
        title:SetSize(frameW, titleH)
        title:SetText(titleText)
        title:SetFont("liaSmallFont")
        title:SetColor(color_white)
        title:SetContentAlignment(5)
        function title:PaintOver()
            surface.SetDrawColor(Color(60, 60, 60))
        end

        local scroll = frame:Add("DScrollPanel")
        scroll:SetPos(0, titleH + titleY + gap)
        scroll:SetSize(frameW, frameH - titleH - titleY - gap)
        local layout = scroll:Add("DIconLayout")
        layout:Dock(FILL)
        layout:SetSpaceY(14)
        for i, entry in ipairs(visible) do
            local btn = layout:Add("DButton")
            btn:Dock(TOP)
            btn:SetTall(entryH)
            btn:DockMargin(15, 0, 15, i == #visible and 25 or 14)
            btn:SetText(entry.name)
            btn:SetFont("liaSmallFont")
            btn:SetTextColor(color_white)
            function btn:Paint(w, h)
                if self:IsHovered() then
                    draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 160))
                else
                    draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 100))
                end
            end

            btn.DoClick = function()
                frame:AlphaTo(0, fadeSpeed, 0, function() if IsValid(frame) then frame:Close() end end)
                if isInteraction then
                    entry.opt.onRun(client, ent)
                else
                    entry.opt.onRun(client)
                end

                if entry.opt.runServer then
                    net.Start(netMsg)
                    net.WriteString(entry.name)
                    net.SendToServer()
                end
            end
        end

        lia.interactionmenu.Menu = frame
    end
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
