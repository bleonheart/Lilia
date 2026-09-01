local PaintedNotificationPanel = {}
function PaintedNotificationPanel:Init()
    self.labelText = ""
    self.labelColor = Color(255, 255, 255)
    self.messageText = ""
    self.textColor = Color(255, 255, 255)
    self.messageLines = {}
end

function PaintedNotificationPanel:Paint(w, h)
    local labelPadding = 6
    local labelSpacing = 4
    surface.SetFont("LiliaFont.18b")
    local labelW, labelH = surface.GetTextSize(self.labelText)
    local labelBoxW = labelW + labelPadding * 2
    local labelBoxH = labelH + labelPadding * 2
    draw.RoundedBox(4, 0, 0, labelBoxW, labelBoxH, self.labelColor)
    local shadowOffset = 1
    draw.SimpleText(self.labelText, "LiliaFont.18b", labelPadding + shadowOffset, labelPadding + shadowOffset, Color(0, 0, 0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.labelText, "LiliaFont.18b", labelPadding, labelPadding, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    surface.SetFont("LiliaFont.20")
    local msgX = labelBoxW + labelSpacing
    local msgY = labelPadding
    local _, lineHeight = surface.GetTextSize("A")
    for i, line in ipairs(self.messageLines) do
        local yPos = msgY + (i - 1) * (lineHeight + 2)
        surface.SetTextColor(Color(0, 0, 0, 100))
        surface.SetTextPos(msgX + shadowOffset, yPos + shadowOffset)
        surface.DrawText(line)
        surface.SetTextColor(self.textColor)
        surface.SetTextPos(msgX, yPos)
        surface.DrawText(line)
    end
end

function PaintedNotificationPanel:SetNotification(labelText, labelColor, messageText, textColor)
    self.labelText = labelText
    self.labelColor = labelColor
    self.messageText = messageText
    self.textColor = textColor
    self:RecalculateLayout()
end

function PaintedNotificationPanel:RecalculateLayout()
    if not self.messageText then return end
    surface.SetFont("LiliaFont.18b")
    local labelW, labelH = surface.GetTextSize(self.labelText)
    local labelBoxW = labelW + 12
    local labelBoxH = labelH + 12
    local panelWidth = self:GetWide() > 0 and self:GetWide() or (ScrW() * 0.3)
    local maxWidth = panelWidth - labelBoxW - 20
    surface.SetFont("LiliaFont.20")
    self.messageLines = lia.util.wrapText(self.messageText, math.max(maxWidth, 100), "LiliaFont.20")
    local _, lineHeight = surface.GetTextSize("A")
    local totalMsgH = #self.messageLines * (lineHeight + 2)
    self:SetSize(panelWidth, math.max(labelBoxH, totalMsgH + 12))
end

function PaintedNotificationPanel:OnSizeChanged()
    self:RecalculateLayout()
end

vgui.Register("liaPaintedNotification", PaintedNotificationPanel, "DPanel")
local cachedScrW = ScrW()
local lastScrWCheck = 0
local function OrganizeNotices()
    local now = CurTime()
    if now - lastScrWCheck > 1 then
        lastScrWCheck = now
        cachedScrW = ScrW()
    end

    local baseY = 10
    local list = {}
    for _, n in ipairs(lia.notices) do
        if IsValid(n) then list[#list + 1] = n end
    end

    while #list > 6 do
        local old = table.remove(list, 1)
        if IsValid(old) then old:Remove() end
    end

    local leftCount = #list > 3 and #list - 3 or 0
    for i, n in ipairs(list) do
        if IsValid(n) then
            local h = n:GetTall()
            local x, y
            if i <= leftCount then
                x = 10
                y = baseY + (i - 1) * (h + 5)
            else
                local idx = i - leftCount
                x = cachedScrW - n:GetWide() - 10
                y = baseY + (idx - 1) * (h + 5)
            end

            local currentX, currentY = n:GetPos()
            if math.abs(currentX - x) > 2 or math.abs(currentY - y) > 2 then
                n:MoveTo(x, y, 0.15)
            else
                n.targetY = y
            end
        end
    end
end

local function RemoveNotices(notice)
    if not IsValid(notice) then return end
    for i, v in ipairs(lia.notices) do
        if v == notice then
            notice:SizeTo(notice:GetWide(), 0, 0.2, 0, -1, function() if IsValid(notice) then notice:Remove() end end)
            table.remove(lia.notices, i)
            timer.Simple(0.25, OrganizeNotices)
            break
        end
    end
end

local function CreateRequestNotice(length, notimer)
    local notice = vgui.Create("DPanel")
    notice:SetSize(0, 0)
    notice.start = CurTime() + 0.25
    notice.endTime = CurTime() + length
    notice.notimer = notimer or false
    notice.oh = notice:GetTall()
    function notice:Paint(w, h)
        local palette = getRequestPalette()
        draw.RoundedBox(9, 4, 5, math.max(w - 8, 0), math.max(h - 3, 0), Color(0, 0, 0, 110))
        drawRequestPanel(0, 0, w, h, 8, palette.surface, palette.borderStrong)
        draw.RoundedBoxEx(8, 0, 0, 4, h, palette.accent, true, false, true, false)
        if self.start then
            local fraction = math.Clamp(math.TimeFraction(self.start, self.endTime, CurTime()), 0, 1)
            local remaining = 1 - fraction
            local barX = 12
            local barY = h - 4
            local barWidth = math.max(w - 24, 0)
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, 28)
            surface.DrawRect(barX, barY, barWidth, 2)
            surface.SetDrawColor(palette.accent)
            surface.DrawRect(barX, barY, math.floor(barWidth * remaining), 2)
        end
    end

    if not notice.notimer then timer.Simple(length, function() if IsValid(notice) then RemoveNotices(notice) end end) end
    return notice
end

local function CreateRequestNoticeButton(parent, label, key)
    local button = parent:Add("DButton")
    button:SetText("")
    button:SetCursor("hand")
    button.hoverFraction = 0
    button.flashColor = nil
    function button:Paint(w, h)
        local palette = getRequestPalette()
        self.hoverFraction = Lerp(math.Clamp(FrameTime() * 14, 0, 1), self.hoverFraction, self:IsHovered() and 1 or 0)
        local background
        if self.flashColor then
            background = self.flashColor
        else
            background = Color(math.Round(Lerp(self.hoverFraction, palette.button.r, palette.buttonHovered.r)), math.Round(Lerp(self.hoverFraction, palette.button.g, palette.buttonHovered.g)), math.Round(Lerp(self.hoverFraction, palette.button.b, palette.buttonHovered.b)), math.Round(Lerp(self.hoverFraction, palette.button.a, palette.buttonHovered.a)))
        end

        drawRequestPanel(0, 0, w, h, 5, background, Color(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(Lerp(self.hoverFraction, 45, 125))))
        if self.hoverFraction > 0.01 then
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(210 * self.hoverFraction))
            surface.DrawRect(5, h - 2, math.max(w - 10, 0), 2)
        end

        draw.SimpleText(label, "LiliaFont.17", 12, h * 0.5, palette.textSecondary, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        surface.SetFont("LiliaFont.15")
        local keyWidth = math.max(surface.GetTextSize(key) + 14, 30)
        local keyHeight = 22
        local keyX = w - keyWidth - 8
        local keyY = math.floor((h - keyHeight) * 0.5)
        drawRequestPanel(keyX, keyY, keyWidth, keyHeight, 4, palette.keycap, Color(palette.accent.r, palette.accent.g, palette.accent.b, 34))
        draw.SimpleText(key, "LiliaFont.15", keyX + keyWidth * 0.5, h * 0.5, palette.textMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    return button
end

lia.derma.requestBinaryNotice = function(question, option1, option2, manualDismiss, callback)
    question = resolveClientRequestText(question, "Are you sure?")
    option1 = resolveClientRequestText(option1, "Yes")
    option2 = resolveClientRequestText(option2, "No")
    surface.SetFont("LiliaFont.19")
    local questionWidth = surface.GetTextSize(question)
    local width = math.Clamp(math.max(520, questionWidth + 76), 520, 700)
    local height = 126
    local notice = CreateRequestNotice(10, manualDismiss)
    table.insert(lia.notices, notice)
    notice.isQuery = true
    notice:SetWide(width)
    notice:SetTall(height)
    notice.oh = height
    if manualDismiss then notice.start = nil end
    notice.header = notice:Add("DPanel")
    notice.header:SetPos(18, 14)
    notice.header:SetSize(width - 36, 52)
    notice.header.Paint = function(_, w)
        local palette = getRequestPalette()
        draw.SimpleText("BINARY REQUEST", "LiliaFont.15", 0, 0, palette.accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(lia.util.wrapText(question, w, "LiliaFont.19", 1, "...")[1] or "", "LiliaFont.19", 0, 24, palette.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    notice.actions = notice:Add("DPanel")
    notice.actions:SetPos(12, 71)
    notice.actions:SetSize(width - 24, 44)
    notice.actions.Paint = function(_, w, h)
        local palette = getRequestPalette()
        drawRequestPanel(0, 0, w, h, 7, palette.inset, Color(palette.accent.r, palette.accent.g, palette.accent.b, 26))
    end

    notice.opt1 = CreateRequestNoticeButton(notice.actions, option1, "F7")
    notice.opt2 = CreateRequestNoticeButton(notice.actions, option2, "F8")
    notice.cancelBtn = CreateRequestNoticeButton(notice.actions, "Cancel", "F9")
    local gap = 6
    local padding = 6
    local availableWidth = notice.actions:GetWide() - padding * 2 - gap * 2
    local buttonWidth = math.floor(availableWidth / 3)
    local buttonHeight = notice.actions:GetTall() - padding * 2
    notice.opt1:SetPos(padding, padding)
    notice.opt1:SetSize(buttonWidth, buttonHeight)
    notice.opt2:SetPos(padding + buttonWidth + gap, padding)
    notice.opt2:SetSize(buttonWidth, buttonHeight)
    local thirdX = padding + (buttonWidth + gap) * 2
    notice.cancelBtn:SetPos(thirdX, padding)
    notice.cancelBtn:SetSize(notice.actions:GetWide() - thirdX - padding, buttonHeight)
    local function finish(button, success, result)
        if not notice.respondToKeys then return end
        notice.respondToKeys = false
        notice.lastKey = CurTime()
        button.flashColor = success and Color(43, 112, 81, 255) or Color(117, 48, 57, 255)
        if callback then callback(result) end
        timer.Simple(0.28, function()
            if not IsValid(notice) then return end
            notice:AlphaTo(0, 0.15, 0, function() if IsValid(notice) then RemoveNotices(notice) end end)
        end)
    end

    local function chooseFirst()
        finish(notice.opt1, true, 0)
    end

    local function chooseSecond()
        finish(notice.opt2, true, 1)
    end

    local function cancel()
        finish(notice.cancelBtn, false, false)
    end

    notice.opt1.DoClick = chooseFirst
    notice.opt2.DoClick = chooseSecond
    notice.cancelBtn.DoClick = cancel
    notice.lastKey = CurTime()
    notice.respondToKeys = true
    notice:SetTall(0)
    notice:SetPos(ScrW() * 0.5 - width * 0.5, 10)
    notice:SizeTo(width, height, 0.2, 0, -1)
    function notice:Think()
        self:SetPos(ScrW() * 0.5 - self:GetWide() * 0.5, 10)
        if not self.respondToKeys or CurTime() - self.lastKey < 0.45 then return end
        if input.IsKeyDown(KEY_F7) then
            chooseFirst()
        elseif input.IsKeyDown(KEY_F8) then
            chooseSecond()
        elseif input.IsKeyDown(KEY_F9) then
            cancel()
        end
    end
    return notice
end

net.Receive("liaAssureClientSideAssets", function()
    lia.webimage.clearCache(true)
    lia.websound.clearCache(true)
    local webimages = lia.webimage.stored
    local websounds = lia.websound.stored
    local downloadQueue = {}
    local activeDownloads = 0
    local maxConcurrent = 5
    local totalImages = table.Count(webimages)
    local totalSounds = table.Count(websounds)
    local completedImages = 0
    local completedSounds = 0
    local failedImages = 0
    local failedSounds = 0
    for name, data in pairs(webimages) do
        table.insert(downloadQueue, {
            type = "image",
            name = name,
            url = data.url,
            flags = data.flags
        })
    end

    for name, url in pairs(websounds) do
        table.insert(downloadQueue, {
            type = "sound",
            name = name,
            url = url
        })
    end

    lia.information("Download queue size:" .. ": " .. #downloadQueue)
    lia.information("Processing with max concurrent downloads:" .. ": " .. maxConcurrent)
    local function processNextDownload()
        if #downloadQueue == 0 then return end
        local download = table.remove(downloadQueue, 1)
        activeDownloads = activeDownloads + 1
        if download.type == "image" then
            lia.webimage.download(download.name, download.url, function(material, fromCache, errorMsg)
                activeDownloads = activeDownloads - 1
                if material then
                    completedImages = completedImages + 1
                    if not fromCache then lia.information("Image downloaded" .. ": " .. download.name) end
                else
                    failedImages = failedImages + 1
                    local errorMessage = errorMsg or "Unknown error"
                    lia.warning("Image failed" .. ": " .. download.name .. " - " .. errorMessage)
                    chat.AddText(Color(255, 100, 100), "Image Download", Color(255, 255, 255), string.format("Failed to download image %s: %s", download.name, errorMessage))
                end

                processNextDownload()
            end, download.flags)
        elseif download.type == "sound" then
            lia.websound.download(download.name, download.url, function(path, fromCache, errorMsg)
                activeDownloads = activeDownloads - 1
                if path then
                    completedSounds = completedSounds + 1
                else
                    failedSounds = failedSounds + 1
                    local errorMessage = errorMsg or "Unknown error"
                    chat.AddText(Color(255, 100, 100), "[Sound Download] ", Color(255, 255, 255), string.format("Failed to download: %s (%s)", download.name, errorMessage))
                end

                processNextDownload()
            end)
        end
    end

    for _ = 1, math.min(maxConcurrent, #downloadQueue) do
        processNextDownload()
    end

    timer.Create("AssetDownloadProgress", 2, 0, function()
        if activeDownloads == 0 and #downloadQueue == 0 then
            timer.Remove("AssetDownloadProgress")
            lia.option.load()
            lia.keybind.load()
            timer.Simple(1.0, function()
                local imageStats = lia.webimage.getStats()
                local soundStats = lia.websound.getStats()
                lia.bootstrap("AssetDownload", "===========================================")
                lia.bootstrap("AssetDownload", "=== CLIENT-SIDE ASSETS DOWNLOAD COMPLETE ===")
                lia.bootstrap("AssetDownload", "Download Summary")
                lia.bootstrap("AssetDownload", string.format("Images: %d/%d completed (%d failed)", completedImages, totalImages, failedImages))
                lia.bootstrap("AssetDownload", string.format("Sounds: %d/%d completed (%d failed)", completedSounds, totalSounds, failedSounds))
                lia.bootstrap("AssetDownload", "Current Statistics")
                lia.bootstrap("AssetDownload", string.format("Images: %d downloaded | %d stored", imageStats.downloaded, imageStats.stored))
                lia.bootstrap("AssetDownload", string.format("Sounds: %d downloaded | %d stored", soundStats.downloaded, soundStats.stored))
                lia.bootstrap("AssetDownload", string.format("Combined: %d downloaded | %d stored", imageStats.downloaded + soundStats.downloaded, imageStats.stored + soundStats.stored))
                lia.bootstrap("AssetDownload", "===========================================")
                if failedImages > 0 or failedSounds > 0 then
                    lia.warning("WARNING: Some assets failed to download. Check console output above for details.")
                    if failedImages > 0 then chat.AddText(Color(255, 150, 100), "[Asset Download] ", Color(255, 255, 255), string.format("Warning: %s %s failed to download.", failedImages, "image(s)")) end
                    if failedSounds > 0 then chat.AddText(Color(255, 150, 100), "[Asset Download] ", Color(255, 255, 255), string.format("Warning: %s %s failed to download.", failedSounds, "sound(s)")) end
                else
                    chat.AddText(Color(100, 255, 100), "[Asset Download] ", Color(255, 255, 255), "All assets downloaded successfully.")
                end
            end)
        end
    end)
end)
