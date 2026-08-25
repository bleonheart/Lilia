local MODULE = MODULE
net.Receive("liaRegenChat", function()
    for _, panel in ipairs(vgui.GetAll()) do
        if IsValid(panel) and panel:GetName() == "liaChatBox" then panel:Remove() end
    end

    MODULE.panel = nil
    lia.gui.chat = nil
    lia.chat.persistedMessages = {}
    hook.Run("CreateChatboxPanel")
end)

net.Receive("liaChatboxSyncFilteredWords", function()
    local wordCount = net.ReadUInt(16)
    local words = {}
    for index = 1, wordCount do
        words[index] = net.ReadString()
    end

    MODULE.filteredWords = words
    if IsValid(MODULE.filteredWordAdminPanel) and MODULE.filteredWordAdminPanel.populateFilteredWords then MODULE.filteredWordAdminPanel:populateFilteredWords(words) end
end)
net.Receive("liaChatMsg", function()
    local client = net.ReadEntity()
    local chatType = net.ReadString()
    local text = net.ReadString()
    local anonymous = net.ReadBool()
    if IsValid(client) then
        local class = lia.chat.classes[chatType]
        text = hook.Run("OnChatReceived", client, chatType, text, anonymous) or text
        if class then
            CHAT_CLASS = class
            class.onChatAdd(client, text, anonymous)
            if lia.config.get("CustomChatSound", "") and lia.config.get("CustomChatSound", "") ~= "" then
                surface.PlaySound(lia.config.get("CustomChatSound", ""))
            else
                chat.PlaySound()
            end

            CHAT_CLASS = nil
        end
    end
end)
net.Receive("liaServerChatAddText", function()
    local args = net.ReadTable()
    if #args >= 3 and IsColor(args[1]) and isstring(args[2]) and IsColor(args[3]) then
        local labelColor = args[1]
        local labelText = args[2]
        local textColor = args[3]
        local messageText = ""
        for i = 4, #args do
            if isstring(args[i]) then messageText = messageText .. args[i] end
        end

        if (labelText == "DEATH" and labelColor.r == 255 and labelColor.g == 0 and labelColor.b == 0) or (labelText == "INSERT" and labelColor.r == 255 and labelColor.g == 165 and labelColor.b == 0) or (labelText == "Inventory" and labelColor.r == 255 and labelColor.g == 0 and labelColor.b == 0) then
            local chatPanel = lia.module.get("chatbox") and lia.module.get("chatbox").panel
            if IsValid(chatPanel) and IsValid(chatPanel.scroll) then
                local paintedPanel = vgui.Create("liaPaintedNotification", chatPanel.scroll)
                paintedPanel:SetWide(chatPanel:GetWide() - 16)
                paintedPanel:SetNotification(labelText, labelColor, messageText, textColor)
                paintedPanel.start = CurTime() + 8
                paintedPanel.finish = paintedPanel.start + 12
                paintedPanel.Think = function(p)
                    if chatPanel.active then
                        p:SetAlpha(255)
                    else
                        local fraction = math.TimeFraction(p.start, p.finish, CurTime())
                        local alpha = 255 - (fraction * 255)
                        p:SetAlpha(math.max(alpha, 0))
                    end
                end

                chatPanel.list = chatPanel.list or {}
                chatPanel.list[#chatPanel.list + 1] = paintedPanel
                paintedPanel:SetPos(0, chatPanel.lastY or 0)
                chatPanel.lastY = (chatPanel.lastY or 0) + paintedPanel:GetTall() + 2
                timer.Simple(0.01, function() if IsValid(chatPanel.scroll) and IsValid(paintedPanel) then chatPanel.scroll:ScrollToChild(paintedPanel) end end)
                return
            end
        end
    end

    chat.AddText(unpack(args))
end)

local pendingShadowed = {}
local function deliverShadowed(args)
    local chatModule = lia.module.get("chatbox")
    hook.Run("CreateChatboxPanel")
    local chatPanel = chatModule and chatModule.panel or lia.gui.chat
    if IsValid(chatPanel) and IsValid(chatPanel.scroll) and #args >= 3 and IsColor(args[1]) and isstring(args[2]) and IsColor(args[3]) then
        local labelColor = args[1]
        local labelText = args[2]
        local textColor = args[3]
        local messageText = ""
        for i = 4, #args do
            if isstring(args[i]) then messageText = messageText .. args[i] end
        end

        local paintedPanel = vgui.Create("liaPaintedNotification", chatPanel.scroll)
        paintedPanel:SetWide(chatPanel:GetWide() - 16)
        paintedPanel:SetNotification(labelText, labelColor, messageText, textColor)
        paintedPanel.start = CurTime() + 8
        paintedPanel.finish = paintedPanel.start + 12
        paintedPanel.Think = function(p)
            if chatPanel.active then
                p:SetAlpha(255)
            else
                local fraction = math.TimeFraction(p.start, p.finish, CurTime())
                local alpha = 255 - (fraction * 255)
                p:SetAlpha(math.max(alpha, 0))
            end
        end

        chatPanel.list = chatPanel.list or {}
        chatPanel.list[#chatPanel.list + 1] = paintedPanel
        paintedPanel:SetPos(0, chatPanel.lastY or 0)
        chatPanel.lastY = (chatPanel.lastY or 0) + paintedPanel:GetTall() + 2
        timer.Simple(0.01, function() if IsValid(chatPanel.scroll) and IsValid(paintedPanel) then chatPanel.scroll:ScrollToChild(paintedPanel) end end)
        if not chatPanel.skipPersist then
            lia.chat = lia.chat or {}
            lia.chat.persistedMessages = lia.chat.persistedMessages or {}
            local history = lia.chat.persistedMessages
            history[#history + 1] = {
                arguments = args,
                shadowed = true
            }

            local maxEntries = 200
            if #history > maxEntries then
                local overflow = #history - maxEntries
                for i = 1, overflow do
                    table.remove(history, 1)
                end
            end
        end
        return true
    end
    return false
end

local function flushPendingShadowed()
    if #pendingShadowed == 0 then return end
    local delivered = {}
    for i = 1, #pendingShadowed do
        if deliverShadowed(pendingShadowed[i]) then delivered[#delivered + 1] = i end
    end

    if #delivered > 0 then
        for idx = #delivered, 1, -1 do
            table.remove(pendingShadowed, delivered[idx])
        end
    end
end

hook.Add("ChatboxPanelCreated", "Lilia.FlushShadowedMessages", flushPendingShadowed)
net.Receive("liaServerChatAddTextShadowed", function()
    local args = net.ReadTable()
    if not deliverShadowed(args) then
        pendingShadowed[#pendingShadowed + 1] = args
        if not timer.Exists("liaFlushShadowedMessages") then timer.Create("liaFlushShadowedMessages", 0.1, 20, flushPendingShadowed) end
    end

    if not IsColor(args[1]) or not isstring(args[2]) or not IsColor(args[3]) then chat.AddText(unpack(args)) end
end)
