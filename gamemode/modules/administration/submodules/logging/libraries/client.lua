local receivedChunks = {}
local receivedPanel

local function buildCategoryPanel(parent, logs)
    local contentPanel = vgui.Create("DPanel", parent)
    contentPanel:Dock(FILL)
    contentPanel:DockPadding(10, 10, 10, 10)

    local search = contentPanel:Add("DTextEntry")
    search:Dock(TOP)
    search:SetPlaceholderText(L("searchLogs"))
    search:SetTextColor(Color(255, 255, 255))

    local list = contentPanel:Add("DListView")
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn(L("timestamp")):SetFixedWidth(150)
    list:AddColumn(L("logMessage"))
    list:AddColumn(L("steamID")):SetFixedWidth(110)

    local copyButton = contentPanel:Add("liaMediumButton")
    copyButton:Dock(BOTTOM)
    copyButton:SetText(L("copySelectedRow"))
    copyButton:SetTall(40)

    local function populate(query)
        list:Clear()
        query = query and string.lower(query) or ""
        for _, log in ipairs(logs) do
            local msgMatch = string.find(string.lower(log.message), query, 1, true)
            local idMatch = log.steamID and string.find(string.lower(log.steamID), query, 1, true)
            if query == "" or msgMatch or idMatch then
                list:AddLine(log.timestamp, log.message, log.steamID or "")
            end
        end
    end

    populate()

    search.OnChange = function() populate(search:GetValue()) end

    copyButton.DoClick = function()
        local sel = list:GetSelectedLine()
        if sel then
            local line = list:GetLine(sel)
            local text = "[" .. line:GetColumnText(1) .. "] " .. line:GetColumnText(2)
            local id = line:GetColumnText(3)
            if id and id ~= "" then text = text .. " [" .. id .. "]" end
            SetClipboardText(text)
        end
    end

    return contentPanel
end

local function OpenLogsUI(panel, categorizedLogs)
    panel:Clear()
    local sheet = panel:Add("DPropertySheet")
    sheet:Dock(FILL)
    sheet:DockMargin(10, 10, 10, 10)

    for category, logs in pairs(categorizedLogs) do
        local pnl = buildCategoryPanel(sheet, logs)
        sheet:AddSheet(category, pnl)
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

hook.Add("liaAdminRegisterTab", "liaLogsTab", function(parent, tabs)
    if not (IsValid(LocalPlayer()) and LocalPlayer():hasPrivilege("Can See Logs")) then return end
    tabs[L("logs")] = {
        icon = "icon16/page_white_text.png",
        build = function(sheet)
            receivedPanel = vgui.Create("DPanel", sheet)
            receivedPanel:Dock(FILL)
            net.Start("send_logs_request")
            net.SendToServer()
            return receivedPanel
        end
    }
end)
