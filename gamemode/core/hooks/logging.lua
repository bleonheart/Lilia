if SERVER then
    local MODULE = MODULE
    function MODULE:SendLogsInChunks(client, categorizedLogs)
        local json = util.TableToJSON(categorizedLogs)
        local data = util.Compress(json)
        local chunks = {}
        for i = 1, #data, 32768 do
            chunks[#chunks + 1] = string.sub(data, i, i + 32768 - 1)
        end

        for i, chunk in ipairs(chunks) do
            net.Start("send_logs")
            net.WriteUInt(i, 16)
            net.WriteUInt(#chunks, 16)
            net.WriteUInt(#chunk, 16)
            net.WriteData(chunk, #chunk)
            net.Send(client)
        end
    end

    function MODULE:ReadLogEntries(category)
        local d = deferred.new()
        local maxDays = lia.config.get("LogRetentionDays", 7)
        local maxLines = lia.config.get("MaxLogLines", 1000)
        local cutoff = os.time() - maxDays * 86400
        local cutoffStr = os.date("%Y-%m-%d %H:%M:%S", cutoff)
        local condition = table.concat({"gamemode = " .. lia.db.convertDataType(engine.ActiveGamemode()), "category = " .. lia.db.convertDataType(category), "timestamp >= " .. lia.db.convertDataType(cutoffStr)}, " AND ") .. " ORDER BY id DESC LIMIT " .. maxLines
        lia.db.select({"timestamp", "message", "steamID"}, "logs", condition):next(function(res)
            local rows = res.results or {}
            local logs = {}
            for _, row in ipairs(rows) do
                logs[#logs + 1] = {
                    timestamp = row.timestamp,
                    message = row.message,
                    steamID = row.steamID
                }
            end

            d:resolve(logs)
        end)
        return d
    end

    net.Receive("send_logs_request", function(_, client)
        if not MODULE:CanPlayerSeeLog(client) then return end
        local categories = {}
        for _, logType in pairs(lia.log.types) do
            categories[logType.category or "Uncategorized"] = true
        end

        local catList = {}
        for cat in pairs(categories) do
            if hook.Run("CanPlayerSeeLogCategory", client, cat) ~= false then catList[#catList + 1] = cat end
        end

        local logsByCategory = {}
        local function fetch(idx)
            if idx > #catList then return MODULE:SendLogsInChunks(client, logsByCategory) end
            local cat = catList[idx]
            MODULE:ReadLogEntries(cat):next(function(entries)
                logsByCategory[cat] = entries
                fetch(idx + 1)
            end)
        end

        fetch(1)
    end)

    function MODULE:CanPlayerSeeLog(client)
        return lia.config.get("AdminConsoleNetworkLogs", true) and client:hasPrivilege("Can See Logs")
    end

    function MODULE:PlayerConnect(name, ip)
        lia.log.add(nil, "playerConnect", name, ip)
    end
else
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
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) then return end
            local text = "[" .. line:GetColumnText(1) .. "] " .. line:GetColumnText(2)
            local id = line:GetColumnText(3)
            if id and id ~= "" then text = text .. " [" .. id .. "]" end
            SetClipboardText(text)
        end

        search.OnChange = function()
            local query = string.lower(search:GetValue())
            local filtered = {}
            for _, log in ipairs(logs) do
                local msgMatch = string.find(string.lower(log.message), query, 1, true)
                local idMatch = log.steamID and string.find(string.lower(log.steamID), query, 1, true)
                if query == "" or msgMatch or idMatch then filtered[#filtered + 1] = log end
            end

            populate(filtered)
        end

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
        local ps = panel:Add("DPropertySheet")
        ps:Dock(FILL)
        ps.Paint = function(p, w, h) derma.SkinHook("Paint", "PropertySheet", p, w, h) end
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
end