net.Receive("cfgList", function()
    local changed = net.ReadTable()
    for key, value in pairs(changed) do
        if lia.config.stored[key] then lia.config.stored[key].value = value end
    end

    hook.Run("InitializedConfig")
end)

local function deserializeFallback(raw)
    if lia.data and lia.data.deserialize then return lia.data.deserialize(raw) end
    if istable(raw) then return raw end
    local decoded = util.JSONToTable(raw)
    if decoded == nil then
        local ok, result = pcall(pon.decode, raw)
        if ok then decoded = result end
    end
    return decoded or raw
end

local function tableToString(tbl, braces)
    local out = {}
    for _, value in pairs(tbl) do
        out[#out + 1] = tostring(value)
    end

    local str = table.concat(out, ", ")
    if braces then str = "{" .. str .. "}" end
    return str
end

local function openRowInfo(row)
    local columns = {
        {
            name = "Field",
            field = "field"
        },
        {
            name = "Type",
            field = "type"
        },
        {
            name = "Coded",
            field = "coded"
        },
        {
            name = "Decoded",
            field = "decoded"
        }
    }

    local rows = {}
    for k, v in pairs(row or {}) do
        local decoded = v
        if isstring(v) then decoded = deserializeFallback(v) end
        local codedStr = istable(v) and tableToString(v) or tostring(v)
        local decodedStr = istable(decoded) and tableToString(decoded, true) or tostring(decoded)
        rows[#rows + 1] = {
            field = k,
            type = type(decoded),
            coded = codedStr,
            decoded = decodedStr
        }
    end

    lia.util.CreateTableUI("Row Details", columns, rows)
end

local dbChunks = {}
local function handleTableData(id)
    local data = table.concat(dbChunks[id])
    dbChunks[id] = nil
    local payload = util.JSONToTable(util.Decompress(data) or "") or {}
    local tbl = payload.tbl
    local rows = payload.data or {}
    if not tbl or #rows == 0 then return end
    local columns = {}
    for k in pairs(rows[1]) do
        columns[#columns + 1] = {
            name = k,
            field = k
        }
    end

    local ps = lia.gui.dbBrowserPS
    if not IsValid(ps) then
        lia.util.CreateTableUI(tbl, columns, rows)
        return
    end

    ps.tableTabs = ps.tableTabs or {}
    if ps.tableTabs[tbl] and IsValid(ps.tableTabs[tbl].tab) then
        ps:CloseTab(ps.tableTabs[tbl].tab, true)
    end

    local panel = vgui.Create("DPanel", ps)
    panel:Dock(FILL)
    panel.Paint = function() end

    local list = vgui.Create("DListView", panel)
    list:Dock(FILL)
    for _, col in ipairs(columns) do
        list:AddColumn(col.name or col.field or L("na"))
    end
    for _, row in ipairs(rows) do
        local lineData = {}
        for _, col in ipairs(columns) do
            local field = col.field or col.name
            table.insert(lineData, row[field] or L("na"))
        end
        local line = list:AddLine(unpack(lineData))
        line.rowData = row
    end

    function list:OnRowSelected(_, line)
        openRowInfo(line.rowData)
    end

    function list:OnRowRightClick(_, line)
        if not IsValid(line) or not line.rowData then return end
        openRowInfo(line.rowData)
    end

    local info = ps:AddSheet(tbl, panel, "icon16/table.png")
    ps.tableTabs[tbl] = {
        tab = info.Tab,
        panel = panel
    }
    ps:SetActiveTab(info.Tab)
end

net.Receive("liaDBTables", function()
    local tables = net.ReadTable()
    for _, tbl in ipairs(tables or {}) do
        net.Start("liaRequestTableData")
        net.WriteString(tbl)
        net.SendToServer()
    end
end)

net.Receive("liaDBTableDataChunk", function()
    local id = net.ReadString()
    local idx = net.ReadUInt(16)
    local total = net.ReadUInt(16)
    local len = net.ReadUInt(16)
    local dat = net.ReadData(len)
    dbChunks[id] = dbChunks[id] or {}
    dbChunks[id][idx] = dat
    if idx == total then handleTableData(id) end
end)

net.Receive("liaDBTableDataDone", function()
    local id = net.ReadString()
    if dbChunks[id] then handleTableData(id) end
end)

net.Receive("cfgSet", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local config = lia.config.stored[key]
    if config then
        if config.callback then config.callback(config.value, value) end
        config.value = value
        local properties = lia.gui.properties
        if IsValid(properties) then
            local row = properties:GetCategory(L(config.data and config.data.category or "misc")):GetRow(key)
            if IsValid(row) then
                if istable(value) and value.r and value.g and value.b then value = Vector(value.r / 255, value.g / 255, value.b / 255) end
                row:SetValue(value)
            end
        end
    end
end)

net.Receive("blindTarget", function()
    local enabled = net.ReadBool()
    if enabled then
        hook.Add("HUDPaint", "blindTarget", function() draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255)) end)
    else
        hook.Remove("HUDPaint", "blindTarget")
    end
end)

net.Receive("blindFade", function()
    local isWhite = net.ReadBool()
    local duration = net.ReadFloat()
    local fadeIn = net.ReadFloat()
    local fadeOut = net.ReadFloat()
    local startTime = CurTime()
    local endTime = startTime + duration
    local color = isWhite and Color(255, 255, 255) or Color(0, 0, 0)
    local hookName = "blindFade" .. startTime
    hook.Add("HUDPaint", hookName, function()
        local ct = CurTime()
        if ct >= endTime then
            hook.Remove("HUDPaint", hookName)
            return
        end

        local alpha
        if ct < startTime + fadeIn then
            alpha = (ct - startTime) / fadeIn
        elseif ct > endTime - fadeOut then
            alpha = (endTime - ct) / fadeOut
        else
            alpha = 1
        end

        surface.SetDrawColor(color.r, color.g, color.b, math.Clamp(alpha * 255, 0, 255))
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end)
end)

net.Receive("AdminModeSwapCharacter", function()
    local id = net.ReadInt(32)
    assert(isnumber(id), "id must be a number")
    local d = deferred.new()
    net.Receive("liaCharChoose", function()
        local message = net.ReadString()
        if message == "" then
            d:resolve()
            hook.Run("CharLoaded", lia.char.loaded[id])
        else
            d:reject(message)
        end
    end)

    d:catch(function(err) if err and err ~= "" then LocalPlayer():notifyLocalized(err) end end)
    net.Start("liaCharChoose")
    net.WriteUInt(id, 32)
    net.SendToServer()
end)

net.Receive("managesitrooms", function()
    local rooms = net.ReadTable()
    local frame = vgui.Create("DFrame")
    frame:SetTitle(L("manageSitroomsTitle"))
    frame:SetSize(600, 400)
    frame:Center()
    frame:MakePopup()
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 30, 10, 10)
    for name in pairs(rooms) do
        local entry = vgui.Create("DPanel", scroll)
        entry:SetTall(40)
        entry:Dock(TOP)
        entry:DockMargin(0, 0, 0, 5)
        local lbl = vgui.Create("DLabel", entry)
        lbl:Dock(LEFT)
        lbl:DockMargin(5, 0, 0, 0)
        lbl:SetText(name)
        lbl:SetTall(40)
        lbl:SetContentAlignment(4)
        local function makeButton(key, action)
            local btn = vgui.Create("DButton", entry)
            btn:Dock(RIGHT)
            btn:SetWide(80)
            btn:SetText(L(key))
            btn.DoClick = function()
                net.Start("lia_managesitrooms_action")
                net.WriteUInt(action, 2)
                net.WriteString(name)
                if action == 2 then
                    local prompt = vgui.Create("DFrame")
                    prompt:SetTitle(L("renameSitroomTitle"))
                    prompt:SetSize(300, 100)
                    prompt:Center()
                    prompt:MakePopup()
                    local txt = vgui.Create("DTextEntry", prompt)
                    txt:Dock(FILL)
                    local ok = vgui.Create("DButton", prompt)
                    ok:Dock(BOTTOM)
                    ok:SetText(string.upper(L("ok")))
                    ok.DoClick = function()
                        net.WriteString(txt:GetValue())
                        net.SendToServer()
                        prompt:Close()
                        frame:Close()
                    end
                    return
                end

                net.SendToServer()
                frame:Close()
            end
        end

        makeButton("teleport", 1)
        makeButton("reposition", 3)
        makeButton("rename", 2)
    end
end)
