lia.playerinteract = lia.playerinteract or {}
lia.playerinteract.stored = lia.playerinteract.stored or {}
function lia.playerinteract.addInteraction(name, data)
    data.type = "interaction"
    data.range = data.range or 250
    lia.playerinteract.stored[name] = data
    if SERVER then lia.playerinteract.syncToClients() end
end

function lia.playerinteract.addAction(name, data)
    data.type = "action"
    data.range = data.range or 250
    lia.playerinteract.stored[name] = data
    if SERVER then lia.playerinteract.syncToClients() end
end

function lia.playerinteract.isWithinRange(client, entity, customRange)
    if not IsValid(client) or not IsValid(entity) then return false end
    local range = customRange or 250
    return entity:GetPos():DistToSqr(client:GetPos()) < range * range
end

if SERVER then
    function lia.playerinteract.syncToClients(target)
        local filteredData = {}
        for name, data in pairs(lia.playerinteract.stored) do
            if data.serverOnly then
                local filtered = {
                    type = data.type,
                    serverOnly = true,
                    name = name
                }

                if data.shouldShow then filtered.shouldShow = data.shouldShow end
                if data.range then filtered.range = data.range end
                filteredData[name] = filtered
            else
                filteredData[name] = table.Copy(data)
                filteredData[name].onRun = nil
            end
        end

        lia.net.writeBigTable(target, "liaPlayerInteractSync", filteredData)
    end
else
    function lia.playerinteract.getInteractions()
        local client = LocalPlayer()
        local ent = client:getTracedEntity()
        if not IsValid(ent) then return {} end
        local interactions = {}
        if ent:IsPlayer() then
            for name, opt in pairs(lia.playerinteract.stored) do
                if opt.type == "interaction" and opt.shouldShow and opt.shouldShow(client, ent) then interactions[name] = opt end
            end
        else
            for name, opt in pairs(lia.playerinteract.stored) do
                if opt.type == "interaction" and opt.shouldShow and opt.shouldShow(client, ent) then interactions[name] = opt end
            end
        end
        return interactions
    end

    function lia.playerinteract.getActions()
        local client = LocalPlayer()
        if not IsValid(client) or not client:getChar() then return {} end
        local actions = {}
        for name, opt in pairs(lia.playerinteract.stored) do
            if opt.type == "action" and opt.shouldShow and opt.shouldShow(client) then actions[name] = opt end
        end
        return actions
    end

    function lia.playerinteract.openMenu(options, isInteraction, titleText, closeKey, netMsg)
        local client, ent = LocalPlayer(), LocalPlayer():getTracedEntity()
        local visible = {}
        for name, opt in pairs(options) do
            if isInteraction then
                if opt.type == "interaction" and IsValid(ent) and lia.playerinteract.isWithinRange(client, ent, opt.range) then
                    local shouldShow = false
                    if opt.shouldShow then shouldShow = opt.shouldShow(client, ent) end
                    if shouldShow then
                        visible[#visible + 1] = {
                            name = name,
                            opt = opt
                        }
                    end
                end
            else
                if opt.type == "action" and opt.shouldShow and opt.shouldShow(client) then
                    visible[#visible + 1] = {
                        name = name,
                        opt = opt
                    }
                end
            end
        end

        if #visible == 0 then return end
        local fadeSpeed = 0.05
        local frameW = 400
        local entryH = 30
        local baseH = entryH * #visible + 140
        local frameH = isInteraction and baseH or math.min(baseH, ScrH() * 0.6)
        local titleH = isInteraction and 36 or 16
        local titleY = 12
        local gap = 24
        local padding = ScrW() * 0.15
        local xPos = ScrW() - frameW - padding
        local yPos = (ScrH() - frameH) / 2
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
            lia.gui.InteractionMenu = nil
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
            btn:SetText(L(entry.name))
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
                    if ent:IsPlayer() then
                        local target = ent:IsBot() and client or ent
                        entry.opt.onRun(client, target)
                    else
                        entry.opt.onRun(client, ent)
                    end
                else
                    entry.opt.onRun(client)
                end

                if entry.opt.serverOnly then
                    net.Start(netMsg)
                    net.WriteString(entry.name)
                    net.WriteBool(isInteraction)
                    if isInteraction then net.WriteEntity(ent) end
                    net.SendToServer()
                end
            end
        end

        lia.gui.InteractionMenu = frame
    end

    lia.net.readBigTable("liaPlayerInteractSync", function(data) lia.playerinteract.stored = data or {} end)
end

lia.playerinteract.addInteraction("giveMoney", {
    serverOnly = false,
    range = 200,
    shouldShow = function(client, target) return IsValid(target) and target:IsPlayer() and client:getChar():getMoney() > 0 end,
    onRun = function(client, target)
        client:requestString("@giveMoney", "@enterAmount", function(amount)
            amount = tonumber(amount)
            if not amount or amount <= 0 then
                client:notifyLocalized("invalidAmount")
                return
            end

            if lia.config.get("DisableCheaterActions", true) and client:getNetVar("cheater", false) then
                lia.log.add(client, "cheaterAction", L("cheaterActionTransferMoney"))
                client:notifyLocalized("maybeYouShouldntHaveCheated")
                return
            end

            if not IsValid(client) or not client:getChar() then return end
            if client:IsFamilySharedAccount() and not lia.config.get("AltsDisabled", false) then
                client:notifyLocalized("familySharedMoneyTransferDisabled")
                return
            end

            if not IsValid(target) or not target:IsPlayer() or not target:getChar() then return end
            if not client:getChar():hasMoney(amount) then
                client:notifyLocalized("notEnoughMoney")
                return
            end

            target:getChar():giveMoney(amount)
            client:getChar():takeMoney(amount)
            local senderName = client:getChar():getDisplayedName(target)
            local targetName = client:getChar():getDisplayedName(client)
            client:notifyLocalized("moneyTransferSent", lia.currency.get(amount), targetName)
            target:notifyLocalized("moneyTransferReceived", lia.currency.get(amount), senderName)
        end, "")
    end
})

lia.playerinteract.addAction("changeToWhisper", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        client:setNetVar("VoiceType", L("whispering"))
        client:notifyLocalized("voiceModeSet", L("whispering"))
    end,
    serverOnly = true
})

lia.playerinteract.addAction("changeToTalk", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        client:setNetVar("VoiceType", "talking")
        client:notifyLocalized("voiceModeSet", "talking")
    end,
    serverOnly = true
})

lia.playerinteract.addAction("changeToYell", {
    shouldShow = function(client) return client:getChar() and client:Alive() end,
    onRun = function(client)
        client:setNetVar("VoiceType", L("yelling"))
        client:notifyLocalized("voiceModeSet", L("yelling"))
    end,
    serverOnly = true
})