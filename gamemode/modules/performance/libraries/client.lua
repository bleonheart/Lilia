local GM = GM or GAMEMODE
local REALM_SV = 1
local sourceCache = {}
local serverMetrics = {}
local nextRefresh = 0
local serverColor = Color(100, 155, 255)
local clientColor = Color(235, 190, 80)
local nativePaths = {
    ["lua/includes/"] = true,
    ["lua/derma/derma.lua"] = true,
    ["lua/derma/derma_menus.lua"] = true,
    ["lua/vgui/vgui.lua"] = true,
    ["lua/vgui/dnumberscratch.lua"] = true,
    ["lua/vgui/dframe.lua"] = true,
    ["lua/vgui/dtextentry.lua"] = true,
    ["lua/vgui/dbutton.lua"] = true,
    ["lua/vgui/dpanel.lua"] = true,
    ["lua/vgui/dcheckbox.lua"] = true,
    ["lua/vgui/dlabel.lua"] = true,
    ["lua/vgui/dslider.lua"] = true,
    ["lua/vgui/dscrollpanel.lua"] = true,
    ["lua/vgui/dpropertysheet.lua"] = true,
    ["lua/vgui/dcombobox.lua"] = true,
    ["lua/postprocess/"] = true,
    ["lua/menu/menu.lua"] = true,
    ["gamemodes/base/"] = true,
    ["gamemodes/sandbox/"] = true,
    ["gamemodes/darkrp/"] = true,
    ["lua/matproxy/"] = true,
    ["lua/skins/"] = true
}

local addonPatterns = {"^.*/addons/", "^.*workshop/content/4000/"}
local iconPlay = Material("icon16/control_play_blue.png", "smooth")
local iconChart = Material("icon16/chart_bar.png", "smooth")
local iconTime = Material("icon16/time.png", "smooth")
local iconFolder = Material("icon16/folder.png", "smooth")
local iconWarning = Material("icon16/error.png", "smooth")
PERFOPUS.HIDE_NATIVE = GetConVar("cl_perfopus_hide_native") or CreateClientConVar("cl_perfopus_hide_native", "0", true, false)
PERFOPUS.SHOWING_METRICS = GetConVar("cl_perfopus_showing_metrics") or CreateClientConVar("cl_perfopus_showing_metrics", "0", false, true)
PERFOPUS.ZOOM = GetConVar("cl_perfopus_zoom") or CreateClientConVar("cl_perfopus_zoom", "2", true, false)
local function getThemeColors()
    local theme = lia.color and lia.color.theme or {}
    local accent = theme.accent or theme.theme or lia.config.get("Color") or Color(45, 190, 170)
    local text = theme.text or Color(225, 238, 238)
    return accent, text
end

local function drawPanel(x, y, w, h, radius, color, outline)
    lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
    if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
end

local function drawIcon(material, x, y, size, color)
    if not material or material:IsError() then return end
    surface.SetMaterial(material)
    surface.SetDrawColor(color or color_white)
    surface.DrawTexturedRect(x, y, size, size)
end

local function fitText(value, font, maxWidth)
    local text = tostring(value or "")
    surface.SetFont(font)
    if surface.GetTextSize(text) <= maxWidth then return text end
    while #text > 8 and surface.GetTextSize("..." .. text) > maxWidth do
        text = text:sub(2)
    end
    return "..." .. text
end

function PERFOPUS.ClearSourceCache()
    table.Empty(sourceCache)
end

function PERFOPUS.IsAddonSource(source)
    local cached = sourceCache[source]
    if cached ~= nil then return cached end
    local normalized = tostring(source or ""):lower():gsub("\\", "/")
    for _, pattern in ipairs(addonPatterns) do
        if normalized:match(pattern) then
            sourceCache[source] = true
            return true
        end
    end

    for path in pairs(nativePaths) do
        if normalized:find(path, 1, true) then
            sourceCache[source] = false
            return false
        end
    end

    sourceCache[source] = true
    return true
end

function PERFOPUS.FilterMetrics(metrics)
    if not PERFOPUS.HIDE_NATIVE:GetBool() then return metrics end
    local filtered = {}
    for source, data in pairs(metrics) do
        if PERFOPUS.IsAddonSource(source) then filtered[source] = data end
    end
    return filtered
end

local function mergeMetrics()
    local rows = {}
    for source, data in pairs(PERFOPUS.FilterMetrics(PERFOPUS.GetReadableMetrics())) do
        rows[#rows + 1] = {
            source = source,
            funcs = data.funcs or {},
            realm = data.realm,
            time = data.time or 0
        }
    end

    for source, data in pairs(PERFOPUS.FilterMetrics(serverMetrics)) do
        rows[#rows + 1] = {
            source = source,
            funcs = data.funcs or {},
            tooltipstr = data.tooltipstr,
            realm = data.realm,
            time = data.time or 0
        }
    end

    table.sort(rows, function(a, b) return a.time > b.time end)
    return rows
end

local function getMetricSummary(rows)
    local total = 0
    local serverTotal = 0
    local clientTotal = 0
    for _, data in ipairs(rows) do
        total = total + data.time
        if data.realm == REALM_SV then
            serverTotal = serverTotal + data.time
        else
            clientTotal = clientTotal + data.time
        end
    end
    return total, serverTotal, clientTotal
end

local function createMetricRow(parent, data, maxTime)
    local row = parent:Add("DPanel")
    row:Dock(TOP)
    row:SetTall(62)
    row:DockMargin(0, 0, 0, 8)
    row:SetCursor("hand")
    row.Paint = function(self, w, h)
        local accent, textColor = getThemeColors()
        local hovered = self:IsHovered()
        local outlineAlpha = hovered and 125 or 52
        local background = hovered and Color(10, 27, 33, 242) or Color(5, 18, 23, 220)
        drawPanel(0, 0, w, h, 7, background, Color(accent.r, accent.g, accent.b, outlineAlpha))
        local realmColor = data.realm == REALM_SV and serverColor or clientColor
        local badgeText = data.realm == REALM_SV and "SERVER" or "CLIENT"
        drawPanel(14, 12, 76, 22, 5, Color(realmColor.r, realmColor.g, realmColor.b, 16), Color(realmColor.r, realmColor.g, realmColor.b, 72))
        draw.SimpleText(badgeText, "LiliaFont.14", 52, 23, realmColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local sourceX = 104
        local sourceWidth = math.max(80, w - sourceX - 120)
        draw.SimpleText(fitText(data.source, "LiliaFont.17", sourceWidth), "LiliaFont.17", sourceX, 13, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(string.format("%.4f ms", data.time * 1000), "LiliaFont.17", w - 14, 13, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        local zoom = math.max(PERFOPUS.ZOOM:GetFloat(), 0.1)
        local share = maxTime > 0 and math.Clamp((data.time / maxTime) * (zoom / 2), 0, 1) or 0
        drawPanel(sourceX, 41, math.max(w - sourceX - 14, 1), 6, 3, Color(255, 255, 255, 8))
        drawPanel(sourceX, 41, math.max((w - sourceX - 14) * share, 1), 6, 3, Color(accent.r, accent.g, accent.b, hovered and 110 or 72))
    end

    local tooltip = data.tooltipstr
    if not tooltip or tooltip == "" then tooltip = PERFOPUS.MakeToolTipString(data.funcs, 10) end
    if tooltip and tooltip ~= "" then
        row:SetTooltip("Most Time Consuming:\n" .. tooltip)
        row:SetTooltipDelay(0)
    end
end

function PERFOPUS.RefreshMetrics(panel)
    if not IsValid(panel) or not PERFOPUS.SHOWING_METRICS:GetBool() then return end
    local list = panel.MetricList
    if not IsValid(list) then return end
    list:Clear()
    local rows = mergeMetrics()
    local total, serverTotal, clientTotal = getMetricSummary(rows)
    panel.MetricCount = #rows
    panel.TotalMetricTime = total
    panel.ServerMetricTime = serverTotal
    panel.ClientMetricTime = clientTotal
    if #rows == 0 then
        local empty = list:Add("DPanel")
        empty:Dock(TOP)
        empty:SetTall(150)
        empty.Paint = function(_, w, h)
            local accent = getThemeColors()
            drawPanel(0, 0, w, h, 8, Color(5, 18, 23, 185), Color(accent.r, accent.g, accent.b, 45))
            drawIcon(iconChart, w * 0.5 - 16, 29, 32, Color(150, 175, 176))
            draw.SimpleText(PERFOPUS.Started and "Collecting samples..." or "Profiler is not running", "LiliaFont.20", w * 0.5, 78, Color(210, 225, 225), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(PERFOPUS.Started and "Metrics will appear after the next refresh." or "Start Perfopus from the controls panel to begin profiling.", "LiliaFont.15", w * 0.5, 108, Color(145, 166, 167), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        return
    end

    local maxTime = rows[1].time or 0
    for _, data in ipairs(rows) do
        createMetricRow(list, data, maxTime)
    end
end

function PERFOPUS.ReceiveServerMetrics(source, tooltipstr, realm, elapsed)
    serverMetrics[source] = {
        tooltipstr = tooltipstr,
        realm = realm,
        time = elapsed,
        funcs = {},
        expires = CurTime() + math.max(PERFOPUS.REFRESH_RATE:GetFloat(), 0.1) + 1
    }
end

local function sendServerSetting(setting, value)
    net.Start("liaPerfopusSettings")
    net.WriteString(setting)
    if setting == "freeze" then
        net.WriteBool(value == true)
    else
        net.WriteFloat(tonumber(value) or 2)
    end

    net.SendToServer()
end

local function startPerfopus(panel)
    if PERFOPUS.Started then
        RunConsoleCommand("cl_perfopus_showing_metrics", "1")
        if PERFOPUS.CanViewMetrics(LocalPlayer()) then
            net.Start("liaPerfopusStart")
            net.SendToServer()
        end

        PERFOPUS.RefreshMetrics(panel)
        return
    end

    Derma_Query("Start Perfopus? Profiling adds overhead and cannot be fully stopped without changing map.", "Start Perfopus", "Start", function()
        PERFOPUS.StartProfiling()
        PERFOPUS.ClearSourceCache()
        RunConsoleCommand("cl_perfopus_showing_metrics", "1")
        if PERFOPUS.CanViewMetrics(LocalPlayer()) then
            net.Start("liaPerfopusStart")
            net.SendToServer()
        end

        if IsValid(panel) then PERFOPUS.BuildPanel(panel) end
    end, "Cancel")
end

local function createSectionTitle(parent, title, subtitle)
    local panel = parent:Add("DPanel")
    panel:Dock(TOP)
    panel:SetTall(subtitle and 48 or 30)
    panel.Paint = function(_, w, h)
        local accent = getThemeColors()
        draw.SimpleText(string.upper(title), "LiliaFont.16", 0, 2, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        if subtitle then draw.SimpleText(subtitle, "LiliaFont.14", 0, 25, Color(135, 158, 159), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end
    end
    return panel
end

local function createToggleRow(parent, title, description, value, onChange)
    local row = parent:Add("DPanel")
    row:Dock(TOP)
    row:SetTall(64)
    row:DockMargin(0, 0, 0, 8)
    row.Paint = function(self, w, h)
        local accent, textColor = getThemeColors()
        local hovered = self:IsHovered()
        drawPanel(0, 0, w, h, 6, hovered and Color(10, 27, 33, 225) or Color(3, 16, 21, 170), Color(accent.r, accent.g, accent.b, hovered and 76 or 40))
        draw.SimpleText(title, "LiliaFont.17", 14, 12, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(description, "LiliaFont.14", 14, 37, Color(135, 158, 159), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local toggle = row:Add("liaCheckbox")
    toggle:Dock(RIGHT)
    toggle:SetWide(58)
    toggle:DockMargin(0, 17, 10, 17)
    toggle:SetValue(value == true)
    toggle.OnChange = function(_, checked) onChange(checked) end
    return toggle
end

local function createSliderRow(parent, title, description, minValue, maxValue, decimals, value, onChange, formatter)
    local row = parent:Add("DPanel")
    row:Dock(TOP)
    row:SetTall(88)
    row:DockMargin(0, 0, 0, 8)
    row.Paint = function(_, w, h)
        local accent, textColor = getThemeColors()
        drawPanel(0, 0, w, h, 6, Color(3, 16, 21, 170), Color(accent.r, accent.g, accent.b, 40))
        draw.SimpleText(title, "LiliaFont.17", 14, 10, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(description, "LiliaFont.14", 14, 32, Color(135, 158, 159), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local valueLabel = row:Add("DLabel")
    valueLabel:SetFont("LiliaFont.15")
    valueLabel:SetTextColor(Color(190, 207, 207))
    valueLabel:SetContentAlignment(6)
    valueLabel:SetSize(74, 20)
    valueLabel:SetPos(0, 8)
    row.PerformLayout = function(_, w) valueLabel:SetPos(w - 88, 8) end
    local slider = row:Add("liaSlider")
    slider:Dock(BOTTOM)
    slider:SetTall(25)
    slider:DockMargin(0, 0, 0, 8)
    slider:SetRange(minValue, maxValue, decimals)
    local function updateValueLabel(newValue)
        valueLabel:SetText(formatter and formatter(newValue) or tostring(newValue))
    end

    slider:SetValue(value, true)
    slider.OnValueChanged = function(_, newValue)
        updateValueLabel(newValue)
        onChange(newValue)
    end

    updateValueLabel(value)
    return slider
end

local function createSummaryCard(parent, title, icon, valueFunc, subtitleFunc)
    local card = parent:Add("DPanel")
    card.Paint = function(_, w, h)
        local accent, textColor = getThemeColors()
        drawPanel(0, 0, w, h, 8, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 55))
        drawIcon(icon, 16, 18, 20, Color(170, 194, 195))
        draw.SimpleText(string.upper(title), "LiliaFont.14", 46, 17, Color(145, 168, 169), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(valueFunc(), "LiliaFont.22", 16, 46, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        if subtitleFunc then draw.SimpleText(subtitleFunc(), "LiliaFont.13", w - 14, h - 14, Color(125, 149, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM) end
    end
    return card
end

function PERFOPUS.BuildPanel(parent)
    parent:Clear()
    parent:DockPadding(0, 0, 0, 0)
    parent.OnRemove = function(panel)
        if PERFOPUS.CurrentPanel ~= panel then return end
        RunConsoleCommand("cl_perfopus_showing_metrics", "0")
        PERFOPUS.CurrentPanel = nil
    end

    local header = parent:Add("DPanel")
    header:Dock(TOP)
    header:SetTall(104)
    header:DockMargin(0, 0, 0, 12)
    header.Paint = function(_, w, h)
        local accent, textColor = getThemeColors()
        drawPanel(0, 0, w, h, 9, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 70))
        surface.SetDrawColor(accent.r, accent.g, accent.b, 230)
        surface.DrawRect(0, 10, 3, h - 20)
        drawIcon(iconChart, 22, 22, 26, accent)
        draw.SimpleText("Performance Metrics", "LiliaFont.25", 62, 17, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Lua hook, timer and entity method profiler", "LiliaFont.15", 62, 51, Color(145, 168, 169), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        local statusText = PERFOPUS.Started and "RUNNING" or "STOPPED"
        local statusColor = PERFOPUS.Started and accent or Color(150, 165, 166)
        local badgeW = 100
        local badgeX = w - badgeW - 18
        drawPanel(badgeX, 21, badgeW, 30, 6, Color(statusColor.r, statusColor.g, statusColor.b, 15), Color(statusColor.r, statusColor.g, statusColor.b, 78))
        draw.SimpleText(statusText, "LiliaFont.15", badgeX + badgeW * 0.5, 36, statusColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        drawIcon(iconWarning, w - 216, 68, 14, Color(170, 150, 100))
        draw.SimpleText("Map change required to fully unload profiler wrappers", "LiliaFont.13", w - 194, 70, Color(145, 158, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local summary = parent:Add("DPanel")
    summary:Dock(TOP)
    summary:SetTall(88)
    summary:DockMargin(0, 0, 0, 12)
    summary.Paint = function() end
    local totalCard = createSummaryCard(summary, "Sample Cost", iconTime, function() return string.format("%.3f ms", (parent.TotalMetricTime or 0) * 1000) end, function() return string.format("%.2fs window", PERFOPUS.REFRESH_RATE:GetFloat()) end)
    local sourceCard = createSummaryCard(summary, "Sources", iconFolder, function() return tostring(parent.MetricCount or 0) end, function() return PERFOPUS.HIDE_NATIVE:GetBool() and "ADDONS ONLY" or "ALL LUA" end)
    local realmCard = createSummaryCard(summary, "Realm Split", iconChart, function() return string.format("S %.2f / C %.2f", (parent.ServerMetricTime or 0) * 1000, (parent.ClientMetricTime or 0) * 1000) end, function() return "MILLISECONDS" end)
    summary.PerformLayout = function(_, w, h)
        local gap = 10
        local cardW = math.floor((w - gap * 2) / 3)
        totalCard:SetPos(0, 0)
        totalCard:SetSize(cardW, h)
        sourceCard:SetPos(cardW + gap, 0)
        sourceCard:SetSize(cardW, h)
        realmCard:SetPos((cardW + gap) * 2, 0)
        realmCard:SetSize(w - (cardW + gap) * 2, h)
    end

    local body = parent:Add("DPanel")
    body:Dock(FILL)
    body.Paint = function() end
    local controls = body:Add("DPanel")
    controls:Dock(LEFT)
    controls:SetWide(318)
    controls:DockMargin(0, 0, 12, 0)
    controls:DockPadding(14, 14, 14, 14)
    controls.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 8, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 58))
    end

    createSectionTitle(controls, "Profiler", "Runtime sampling controls")
    local startButton = controls:Add("liaButton")
    startButton:Dock(TOP)
    startButton:SetTall(44)
    startButton:DockMargin(0, 0, 0, 12)
    startButton:SetRadius(7)
    startButton:SetIcon(iconPlay, 16)
    startButton:SetText(PERFOPUS.Started and "Profiler Running" or "Start Perfopus")
    startButton.DoClick = function()
        lia.webcontent.playButtonSound()
        startPerfopus(parent)
    end

    createToggleRow(controls, "Freeze Samples", "Keep the current measurements visible", PERFOPUS.FREEZE:GetBool(), function(value) sendServerSetting("freeze", value) end)
    createToggleRow(controls, "Hide Native Activity", "Only show addon and gamemode Lua", PERFOPUS.HIDE_NATIVE:GetBool(), function(value)
        RunConsoleCommand("cl_perfopus_hide_native", value and "1" or "0")
        PERFOPUS.ClearSourceCache()
        PERFOPUS.RefreshMetrics(parent)
    end)

    createSectionTitle(controls, "Display", "Sampling window and graph scale")
    local refreshTimer = "PERFOPUSRefreshSetting"
    createSliderRow(controls, "Refresh Rate", "How often samples are replaced", 0.1, 5, 2, PERFOPUS.REFRESH_RATE:GetFloat(), function(value) timer.Create(refreshTimer, 0.15, 1, function() sendServerSetting("refresh", value) end) end, function(value) return string.format("%.2fs", value) end)
    createSliderRow(controls, "Graph Zoom", "Scales the relative activity display", 0.5, 10, 1, PERFOPUS.ZOOM:GetFloat(), function(value) RunConsoleCommand("cl_perfopus_zoom", tostring(math.Clamp(value, 0.5, 10))) end, function(value) return string.format("%.1fx", value) end)
    local legend = controls:Add("DPanel")
    legend:Dock(TOP)
    legend:SetTall(72)
    legend:DockMargin(0, 4, 0, 0)
    legend.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 6, Color(3, 16, 21, 140), Color(accent.r, accent.g, accent.b, 34))
        drawPanel(14, 16, 10, 10, 5, clientColor)
        draw.SimpleText("Client Lua", "LiliaFont.15", 34, 21, Color(185, 205, 205), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        drawPanel(14, 45, 10, 10, 5, serverColor)
        draw.SimpleText("Server Lua", "LiliaFont.15", 34, 50, Color(185, 205, 205), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local metricsPanel = body:Add("DPanel")
    metricsPanel:Dock(FILL)
    metricsPanel:DockPadding(14, 14, 14, 14)
    metricsPanel.Paint = function(_, w, h)
        local accent = getThemeColors()
        drawPanel(0, 0, w, h, 8, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 58))
    end

    local metricHeader = metricsPanel:Add("DPanel")
    metricHeader:Dock(TOP)
    metricHeader:SetTall(50)
    metricHeader:DockMargin(0, 0, 0, 10)
    metricHeader.Paint = function(_, w, h)
        local accent, textColor = getThemeColors()
        draw.SimpleText("HOT PATHS", "LiliaFont.17", 0, 2, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Sources ordered by accumulated Lua execution time", "LiliaFont.14", 0, 28, Color(135, 158, 159), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(string.format("%d sources", parent.MetricCount or 0), "LiliaFont.15", w, 4, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText("Hover for callback breakdown", "LiliaFont.13", w, 29, Color(125, 149, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local metrics = metricsPanel:Add("liaScrollPanel")
    metrics:Dock(FILL)
    metrics.Paint = function() end
    parent.MetricList = metrics:GetCanvas()
    parent.MetricList:DockPadding(0, 0, 4, 0)
    parent.MetricList.Paint = function() end
    PERFOPUS.CurrentPanel = parent
    RunConsoleCommand("cl_perfopus_showing_metrics", "1")
    PERFOPUS.RefreshMetrics(parent)
end

function MODULE:CreateMenuButtons(tabs)
    tabs["perfopus"] = {
        name = "Performance Metrics",
        icon = "icon16/chart_bar.png",
        shouldShow = function() return PERFOPUS.CanViewMetrics(LocalPlayer()) end,
        func = function(panel) PERFOPUS.BuildPanel(panel) end
    }
end

function MODULE:F1MenuClosed()
    RunConsoleCommand("cl_perfopus_showing_metrics", "0")
    PERFOPUS.CurrentPanel = nil
end

function MODULE:Think()
    if not PERFOPUS.Started or PERFOPUS.FREEZE:GetBool() then return end
    if nextRefresh > CurTime() then return end
    local now = CurTime()
    for source, data in pairs(serverMetrics) do
        if data.expires and data.expires < now then serverMetrics[source] = nil end
    end

    if IsValid(PERFOPUS.CurrentPanel) then PERFOPUS.RefreshMetrics(PERFOPUS.CurrentPanel) end
    table.Empty(PERFOPUS.Metrics)
    nextRefresh = CurTime() + math.Clamp(PERFOPUS.REFRESH_RATE:GetFloat(), 0.1, 5)
end

net.Receive("liaPerfopusMetric", function()
    if not PERFOPUS.CanViewMetrics(LocalPlayer()) then return end
    PERFOPUS.ReceiveServerMetrics(net.ReadString(), net.ReadString(), net.ReadUInt(1), net.ReadFloat())
end)

cvars.AddChangeCallback("cl_perfopus_hide_native", function()
    PERFOPUS.ClearSourceCache()
    if IsValid(PERFOPUS.CurrentPanel) then timer.Simple(0, function() if IsValid(PERFOPUS.CurrentPanel) then PERFOPUS.RefreshMetrics(PERFOPUS.CurrentPanel) end end) end
end, "PERFOPUSHideNative")