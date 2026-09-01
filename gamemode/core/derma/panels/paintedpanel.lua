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
