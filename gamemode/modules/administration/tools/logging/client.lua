local receivedChunks = {}
local receivedPanel

local function createLogPage(parent, logs)
    local contentPanel = parent:Add("DPanel")
    contentPanel:Dock(FILL)
    contentPanel:DockPadding(10, 10, 10, 10)

    local search = contentPanel:Add("DTextEntry")
    search:Dock(TOP)
    search:SetPlaceholderText(L("searchLogs"))
    search:SetTextColor(Color(255, 255, 255))

    local list = contentPanel:Add("DListView")
    list:Dock(FILL)
    list:SetMultiSelect(false)
    do
        local col = list:AddColumn(L("timestamp"))
        surface.SetFont(col.Header:GetFont() or "DermaDefault")
        local textWidth = select(1, surface.GetTextSize(L("timestamp"))) + 20
        local width = math.max(150, textWidth)
        col:SetWide(width)
        col:SetMinWidth(textWidth)
    end
    list:AddColumn(L("logMessage"))
    do
        local col = list:AddColumn(L("steamID"))
        surface.SetFont(col.Header:GetFont() or "DermaDefault")
        local textWidth = select(1, surface.GetTextSize(L("steamID"))) + 20
        local width = math.max(110, textWidth)
        col:SetWide(width)
        col:SetMinWidth(textWidth)
    end

    local copyButton = contentPanel:Add("liaMediumButton")
    copyButton:Dock(BOTTOM)
    copyButton:SetText(L("copySelectedRow"))
    copyButton:SetTall(40)

    local function populate(data)
        list:Clear()
        for _, log in ipairs(data) do
            list:AddLine(log.timestamp, log.message, log.steamID or "")
        end
    end

    populate(logs)

    search.OnChange = function()
        local query = string.lower(search:GetValue())
        local filtered = {}
        for _, log in ipairs(logs) do
            local msgMatch = string.find(string.lower(log.message), query, 1, true)
            local idMatch = log.steamID and string.find(string.lower(log.steamID), query, 1, true)
            if query == "" or msgMatch or idMatch then
                filtered[#filtered + 1] = log
            end
        end
        populate(filtered)
    end

    copyButton.DoClick = function()
        local sel = list:GetSelectedLine()
        if sel then
            local line = list:GetLine(sel)
            local text = "[" .. line:GetColumnText(1) .. "] " .. line:GetColumnText(2)
            local id = line:GetColumnText(3)
            if id and id ~= "" then
                text = text .. " [" .. id .. "]"
            end
            SetClipboardText(text)
        end
    end

    return contentPanel
end

local function OpenLogsUI(panel, categorizedLogs)
    panel:Clear()
    local ps = panel:Add("DPropertySheet")
    ps:Dock(FILL)
    ps.Paint = function(p, w, h)
        derma.SkinHook("Paint", "PropertySheet", p, w, h)
    end

    for category, logs in pairs(categorizedLogs) do
        local page = createLogPage(ps, logs)
        ps:AddSheet(category, page)
    end
end

net.Receive("send_logs", function()
    local chunkIndex = net.ReadUInt(16)
    local numChunks = net.ReadUInt(16)
    local chunkLen = net.ReadUInt(16)
    local chunkData = net.ReadData(chunkLen)
    receivedChunks[chunkIndex] = chunkData
    for i = 1, numChunks do
        if not receivedChunks[i] then return end
    end

    local fullData = table.concat(receivedChunks)
    receivedChunks = {}
    local jsonData = util.Decompress(fullData)
    local categorizedLogs = util.JSONToTable(jsonData)
    if not categorizedLogs then
        chat.AddText(Color(255, 0, 0), L("failedRetrieveLogs"))
        return
    end

    if IsValid(receivedPanel) then OpenLogsUI(receivedPanel, categorizedLogs) end
end)

hook.Add("liaAdminRegisterTab", "AdminTabLogs", function(tabs)
    local function canView()
        local ply = LocalPlayer()
        return IsValid(ply) and ply:hasPrivilege("Access Logs Tab") and ply:hasPrivilege("Can See Logs")
    end

    tabs[L("logs")] = {
        icon = "icon16/application_view_detail.png",
        onShouldShow = canView,
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:DockPadding(10, 10, 10, 10)
            receivedPanel = pnl
            net.Start("send_logs_request")
            net.SendToServer()
            return pnl
        end
    }
end)
