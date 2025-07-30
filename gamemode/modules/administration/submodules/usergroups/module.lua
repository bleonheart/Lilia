MODULE.name = "Usergroups"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Lists usergroups."
MODULE.Privileges = {
    {
        Name = "Manage UserGroups",
        MinAccess = "superadmin",
        Category = "Staff Permissions"
    }
}

local CHUNK = 60000

if SERVER then
    local function syncPrivileges()
        lia.administrator.groups = lia.administrator.groups or {}
        for n in pairs(lia.administrator.groups) do
            lia.administrator.groups[n] = lia.administrator.groups[n] or {}
        end
        lia.administrator.syncPrivileges()
    end

    local function getPrivMap()
        local byCat = {}
        local seen = {}
        for k, v in pairs(lia.administrator.privileges or {}) do
            local name, cat
            if istable(v) then
                name = v.Name or isstring(k) and k or nil
                cat = v.Category or "General"
            elseif isstring(v) then
                name = v
                cat = "General"
            end

            if isstring(name) and name ~= "" and not seen[name] then
                seen[name] = true
                cat = isstring(cat) and cat or "General"
                byCat[cat] = byCat[cat] or {}
                byCat[cat][#byCat[cat] + 1] = name
            end
        end

        local cats = {}
        for c in pairs(byCat) do
            cats[#cats + 1] = c
        end

        table.sort(cats, function(a, b) return a:lower() < b:lower() end)
        for _, c in ipairs(cats) do
            table.sort(byCat[c], function(a, b) return a:lower() < b:lower() end)
        end
        return {
            categories = cats,
            byCategory = byCat
        }
    end

    local function payload()
        return {
            groups = lia.administrator.groups or {},
            privMap = getPrivMap()
        }
    end

    local function sendBigTable(ply, tbl)
        local raw = util.TableToJSON(tbl) or "{}"
        local comp = util.Compress(raw)
        local len = #comp
        local id = util.CRC(tostring(SysTime()) .. len)
        local parts = math.ceil(len / CHUNK)
        for i = 1, parts do
            local chunk = string.sub(comp, (i - 1) * CHUNK + 1, math.min(i * CHUNK, len))
            net.Start("liaGroupsDataChunk")
            net.WriteString(id)
            net.WriteUInt(i, 16)
            net.WriteUInt(parts, 16)
            net.WriteUInt(#chunk, 16)
            net.WriteData(chunk, #chunk)
            if IsEntity(ply) then
                net.Send(ply)
            else
                net.Broadcast()
            end
        end

        net.Start("liaGroupsDataDone")
        net.WriteString(id)
        if IsEntity(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    local function broadcastGroups()
        sendBigTable(nil, payload())
    end

    syncPrivileges()
    net.Receive("liaGroupsRequest", function(_, p)
        syncPrivileges()
        sendBigTable(p, payload())
    end)

    net.Receive("liaGroupsAdd", function(_, p)
        local n = string.Trim(net.ReadString() or "")
        if n == "" then return end
        lia.administrator.groups = lia.administrator.groups or {}
        if lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[n] then return end
        if lia.administrator.groups[n] then return end
        lia.administrator.createGroup(n)
        lia.administrator.save()
        broadcastGroups()
        p:notify(p, "Group '" .. n .. "' created.")
    end)

    net.Receive("liaGroupsRemove", function(_, p)
        local n = net.ReadString()
        if n == "" or lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[n] then return end
        lia.administrator.removeGroup(n)
        if lia.administrator.groups then lia.administrator.groups[n] = nil end
        lia.administrator.save()
        broadcastGroups()
        p:notify(p, "Group '" .. n .. "' removed.")
    end)

    net.Receive("liaGroupsRename", function(_, p)
        local old = string.Trim(net.ReadString() or "")
        local new = string.Trim(net.ReadString() or "")
        if old == "" or new == "" then return end
        if old == new then return end
        if not lia.administrator.groups or not lia.administrator.groups[old] then return end
        if lia.administrator.groups[new] or lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[new] then return end
        if lia.administrator.DefaultGroups and lia.administrator.DefaultGroups[old] then return end
        local perms = lia.administrator.groups[old]
        lia.administrator.groups[new] = perms
        lia.administrator.groups[old] = nil
        lia.administrator.save()
        broadcastGroups()
        p:notify(p, "Group '" .. old .. "' renamed to '" .. new .. "'.")
    end)
else
    local chunks = {}
    local PRIV_MAP = {
        categories = {},
        byCategory = {}
    }

    local LAST_GROUP
    local function setFont(o, f)
        if IsValid(o) then o:SetFont(f) end
    end

    local function computePrivMapLocal()
        local byCat = {}
        local seen = {}
        for k, v in pairs(lia.administrator.privileges or {}) do
            local name, cat
            if istable(v) then
                name = v.Name or isstring(k) and k or nil
                cat = v.Category or "General"
            elseif isstring(v) then
                name = v
                cat = "General"
            end

            if isstring(name) and name ~= "" and not seen[name] then
                seen[name] = true
                cat = isstring(cat) and cat or "General"
                byCat[cat] = byCat[cat] or {}
                byCat[cat][#byCat[cat] + 1] = name
            end
        end

        local cats = {}
        for c in pairs(byCat) do
            cats[#cats + 1] = c
        end

        table.sort(cats, function(a, b) return a:lower() < b:lower() end)
        for _, c in ipairs(cats) do
            table.sort(byCat[c], function(a, b) return a:lower() < b:lower() end)
        end
        return {
            categories = cats,
            byCategory = byCat
        }
    end

    local function buildCategoryList(parent, g, perms, editable)
        local wrap = parent:Add("DPanel")
        wrap:Dock(FILL)
        wrap:DockMargin(20, 0, 20, 4)
        wrap.Paint = function() end
        local catList = vgui.Create("DCategoryList", wrap)
        catList:Dock(FILL)
        local current = table.Copy(perms[g] or {})
        surface.SetFont("liaMediumFont")
        local _, fh = surface.GetTextSize("W")
        local cbSize = math.max(20, fh + 6)
        local rowH = math.max(fh + 14, cbSize + 8)
        local off = math.floor((rowH - fh) * 0.5)
        local function addRow(container, name)
            local row = vgui.Create("DPanel", container)
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 8)
            row:SetTall(rowH)
            row.Paint = function() end
            local lbl = row:Add("DLabel")
            lbl:Dock(FILL)
            lbl:DockMargin(0, off, 8, 0)
            lbl:SetText(name)
            setFont(lbl, "liaMediumFont")
            lbl:SizeToContents()
            local chk = row:Add("liaCheckBox")
            chk:SetSize(cbSize, cbSize)
            chk:Dock(RIGHT)
            chk:SetChecked(current[name] and true or false)
            chk.OnChange = function(_, v)
                if v then
                    current[name] = true
                else
                    current[name] = nil
                end
            end

            if not editable then chk:SetEnabled(false) end
        end

        for _, catName in ipairs(PRIV_MAP.categories or {}) do
            local cat = catList:Add(catName)
            local list = vgui.Create("DListLayout", cat)
            list:Dock(FILL)
            for _, privName in ipairs(PRIV_MAP.byCategory[catName] or {}) do
                addRow(list, privName)
            end

            cat:SetContents(list)
            cat:SetExpanded(true)
            cat.OnToggle = function()
                timer.Simple(0, function()
                    if not IsValid(wrap) then return end
                    wrap:InvalidateLayout(true)
                end)
            end
        end
        return wrap, catList, current
    end

    local function renderGroupInfo(parent, g, groups, perms)
        parent:Clear()
        LAST_GROUP = g
        local editable = not lia.administrator.DefaultGroups[g]
        local bottom = parent:Add("DPanel")
        bottom:Dock(BOTTOM)
        bottom:SetTall(36)
        bottom:DockMargin(10, 0, 10, 10)
        bottom.Paint = function() end
        local scroll = parent:Add("DScrollPanel")
        scroll:Dock(FILL)
        scroll:DockMargin(0, 0, 0, 6)
        local nameLbl = scroll:Add("DLabel")
        nameLbl:Dock(TOP)
        nameLbl:DockMargin(20, 20, 0, 0)
        nameLbl:SetText("Name:")
        setFont(nameLbl, "liaBigFont")
        nameLbl:SizeToContents()
        local nameVal = scroll:Add("DLabel")
        nameVal:Dock(TOP)
        nameVal:DockMargin(20, 2, 0, 10)
        nameVal:SetText(g)
        setFont(nameVal, "liaMediumFont")
        nameVal:SizeToContents()
        local inhLbl = scroll:Add("DLabel")
        inhLbl:Dock(TOP)
        inhLbl:DockMargin(20, 10, 0, 0)
        inhLbl:SetText("Inherits from:")
        setFont(inhLbl, "liaBigFont")
        inhLbl:SizeToContents()
        local inhVal = scroll:Add("DLabel")
        inhVal:Dock(TOP)
        inhVal:DockMargin(20, 2, 0, 0)
        inhVal:SetText("user")
        setFont(inhVal, "liaMediumFont")
        inhVal:SizeToContents()
        local privLbl = scroll:Add("DLabel")
        privLbl:Dock(TOP)
        privLbl:DockMargin(20, 10, 0, 6)
        privLbl:SetText("Privileges")
        setFont(privLbl, "liaBigFont")
        privLbl:SizeToContents()
        local wrap, catList, current = buildCategoryList(scroll, g, perms, editable)
        if editable then
            local createBtn = bottom:Add("liaMediumButton")
            local renameBtn = bottom:Add("liaMediumButton")
            local delBtn = bottom:Add("liaMediumButton")
            createBtn:SetText("Create Group")
            renameBtn:SetText("Rename Group")
            delBtn:SetText("Delete Group")
            createBtn.DoClick = function()
                Derma_StringRequest("Create Group", "New group name:", "", function(txt)
                    txt = string.Trim(txt or "")
                    if txt == "" then return end
                    LAST_GROUP = txt
                    net.Start("liaGroupsAdd")
                    net.WriteString(txt)
                    net.SendToServer()
                end)
            end

            renameBtn.DoClick = function()
                Derma_StringRequest("Rename Group", "New name for '" .. g .. "':", g, function(txt)
                    txt = string.Trim(txt or "")
                    if txt == "" or txt == g then return end
                    LAST_GROUP = txt
                    net.Start("liaGroupsRename")
                    net.WriteString(g)
                    net.WriteString(txt)
                    net.SendToServer()
                end)
            end

            delBtn.DoClick = function()
                Derma_Query("Delete group '" .. g .. "'?", "Confirm", "Yes", function()
                    net.Start("liaGroupsRemove")
                    net.WriteString(g)
                    net.SendToServer()
                end, "No")
            end

            bottom.PerformLayout = function(pnl, w, bh)
                local bw = math.floor(w / 3)
                createBtn:SetPos(0, 0)
                createBtn:SetSize(bw, bh)
                renameBtn:SetPos(bw, 0)
                renameBtn:SetSize(bw, bh)
                delBtn:SetPos(bw * 2, 0)
                delBtn:SetSize(w - bw * 2, bh)
            end
        else
            local addBtn = bottom:Add("liaMediumButton")
            addBtn:SetText("Create Group")
            addBtn.DoClick = function()
                Derma_StringRequest("Create Group", "New group name:", "", function(txt)
                    txt = string.Trim(txt or "")
                    if txt == "" then return end
                    LAST_GROUP = txt
                    net.Start("liaGroupsAdd")
                    net.WriteString(txt)
                    net.SendToServer()
                end)
            end

            bottom.PerformLayout = function(_, w, bh)
                addBtn:SetPos(0, 0)
                addBtn:SetSize(w, bh)
            end
        end
    end

    local function buildGroupsUI(panel, groups, perms)
        panel:Clear()
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        local keys = {}
        for g in pairs(groups or {}) do
            keys[#keys + 1] = g
        end

        table.sort(keys, function(a, b) return a:lower() < b:lower() end)
        for _, g in ipairs(keys) do
            local page = sheet:Add("DPanel")
            renderGroupInfo(page, g, groups, perms)
            sheet:AddSheet(g, page)
        end

        if LAST_GROUP and groups[LAST_GROUP] then
            for _, tab in ipairs(sheet.Items) do
                if tab.Name == LAST_GROUP then
                    sheet:SetActiveTab(tab.Tab)
                    break
                end
            end
        elseif sheet.Items[1] then
            sheet:SetActiveTab(sheet.Items[1].Tab)
        end
    end

    local function handleDone(id)
        local data = table.concat(chunks[id])
        chunks[id] = nil
        local tbl = util.JSONToTable(util.Decompress(data) or "") or {}
        PRIV_MAP = tbl.privMap or {
            categories = {},
            byCategory = {}
        }

        if not PRIV_MAP.categories or #PRIV_MAP.categories == 0 or not next(PRIV_MAP.byCategory) then PRIV_MAP = computePrivMapLocal() end
        lia.administrator.groups = tbl.groups or {}
        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, lia.administrator.groups, lia.administrator.groups) end
    end

    net.Receive("liaGroupsDataChunk", function()
        local id = net.ReadString()
        local idx = net.ReadUInt(16)
        local total = net.ReadUInt(16)
        local len = net.ReadUInt(16)
        local dat = net.ReadData(len)
        chunks[id] = chunks[id] or {}
        chunks[id][idx] = dat
        if idx == total then handleDone(id) end
    end)

    net.Receive("liaGroupsDataDone", function()
        local id = net.ReadString()
        if chunks[id] then handleDone(id) end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) then return end
        table.insert(pages, {
            name = L("userGroups"),
            drawFunc = function(parent)
                lia.gui.usergroups = parent
                parent:Clear()
                parent:DockPadding(10, 10, 10, 10)
                parent.Paint = function(p, w, h) derma.SkinHook("Paint", "Frame", p, w, h) end
                net.Start("liaGroupsRequest")
                net.SendToServer()
            end
        })
    end
end