lia.administrator = lia.administrator or {}
lia.administrator.groups = lia.administrator.groups or {}
lia.administrator.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true
}

local level = {
    user = 1,
    admin = 2,
    superadmin = 3
}

local function shouldGrant(g, m)
    return (level[g] or 0) >= (level[m] or 1)
end

local function ensureDefaults(t)
    local d = {"user", "admin", "superadmin"}
    local c = false
    for _, n in ipairs(d) do
        if not t[n] then
            t[n] = {
                _info = {
                    inheritance = "user",
                    types = {}
                }
            }

            c = true
        end
    end
    return c
end

function lia.administrator.registerPrivilege(p)
    if not p or not p.Name then return end
    local n = tostring(p.Name)
    local m = p.MinAccess or "user"
    for g, perms in pairs(lia.administrator.groups) do
        perms[n] = shouldGrant(g, m) or perms[n]
    end

    if SERVER then lia.administrator.save() end
end

function lia.administrator.load()
    local function finish(grp)
        lia.administrator.groups = grp or {}
        lia.bootstrap("Administration", L("adminSystemLoaded"))
    end

    lia.db.selectOne("*", "admin"):next(function(r)
        local g = r and util.JSONToTable(r.usergroups or r.groups or "") or {}
        local inh = r and util.JSONToTable(r.inheritances or "") or {}
        local typ = r and util.JSONToTable(r.types or "") or {}
        for n, d in pairs(g) do
            d._info = d._info or {}
            d._info.inheritance = inh[n] or d._info.inheritance or "user"
            d._info.types = typ[n] or d._info.types or {}
        end

        local created = ensureDefaults(g)
        if created then
            lia.administrator.groups = g
            lia.administrator.save()
        end

        finish(g)
    end)
end

function lia.administrator.createGroup(n, info)
    if lia.administrator.groups[n] then return lia.error("[Lilia Administration] This usergroup already exists!\n") end
    info = info or {}
    info._info = info._info or {
        inheritance = "user",
        types = {}
    }

    lia.administrator.groups[n] = info
    if SERVER then lia.administrator.save() end
end

function lia.administrator.removeGroup(n)
    if lia.administrator.DefaultGroups[n] then return lia.error("[Lilia Administration] The base usergroups cannot be removed!\n") end
    if not lia.administrator.groups[n] then return lia.error("[Lilia Administration] This usergroup doesn't exist!\n") end
    lia.administrator.groups[n] = nil
    if SERVER then lia.administrator.save() end
end

function lia.administrator.renameGroup(o, n)
    if lia.administrator.DefaultGroups[o] then return lia.error("[Lilia Administration] The base usergroups cannot be renamed!\n") end
    if not lia.administrator.groups[o] then return lia.error("[Lilia Administration] This usergroup doesn't exist!\n") end
    if lia.administrator.groups[n] then return lia.error("[Lilia Administration] This usergroup already exists!\n") end
    lia.administrator.groups[n] = lia.administrator.groups[o]
    lia.administrator.groups[o] = nil
    if SERVER then lia.administrator.save() end
end

if SERVER then
    function lia.administrator.addPermission(g, p)
        if not lia.administrator.groups[g] then return lia.error("[Lilia Administration] This usergroup doesn't exist!\n") end
        if lia.administrator.DefaultGroups[g] then return end
        lia.administrator.groups[g][p] = true
        lia.administrator.save()
        hook.Run("OnUsergroupPermissionsChanged", g, lia.administrator.groups[g])
    end

    function lia.administrator.removePermission(g, p)
        if not lia.administrator.groups[g] then return lia.error("[Lilia Administration] This usergroup doesn't exist!\n") end
        if lia.administrator.DefaultGroups[g] then return end
        lia.administrator.groups[g][p] = nil
        lia.administrator.save()
        hook.Run("OnUsergroupPermissionsChanged", g, lia.administrator.groups[g])
    end

    function lia.administrator.sync(c)
        if c and IsValid(c) then
            lia.net.writeBigTable(c, "updateAdminGroups", lia.administrator.groups)
        else
            for _, ply in ipairs(player.GetHumans()) do
                lia.net.writeBigTable(ply, "updateAdminGroups", lia.administrator.groups)
            end
        end
    end

    function lia.administrator.save(noNet)
        local inh, typ = {}, {}
        for n, d in pairs(lia.administrator.groups) do
            local i = istable(d._info) and d._info or {}
            inh[n] = i.inheritance
            typ[n] = i.types
        end

        lia.db.upsert({
            usergroups = util.TableToJSON(lia.administrator.groups),
            inheritances = util.TableToJSON(inh),
            types = util.TableToJSON(typ)
        }, "admin")

        if not noNet then lia.administrator.sync() end
    end
else
    local LAST_GROUP
    local function listPrivileges(groups)
        local s = {}
        for _, perms in pairs(groups) do
            for k in pairs(perms) do
                if k ~= "_info" then s[k] = true end
            end
        end

        local l = {}
        for k in pairs(s) do
            l[#l + 1] = k
        end

        table.sort(l, function(a, b) return a:lower() < b:lower() end)
        return l
    end

    local function buildPrivilegeList(parent, g, groups, editable)
        local wrap = parent:Add("DPanel")
        wrap:Dock(FILL)
        wrap:DockMargin(20, 0, 20, 4)
        wrap.Paint = function() end
        local catList = wrap:Add("DCategoryList")
        catList:Dock(FILL)
        local current = table.Copy(groups[g] or {})
        current._info = nil
        surface.SetFont("liaMediumFont")
        local _, fh = surface.GetTextSize("W")
        local cb = math.max(20, fh + 6)
        local rowH = math.max(fh + 14, cb + 8)
        local off = math.floor((rowH - fh) * 0.5)
        local function addRow(container, name)
            local row = container:Add("DPanel")
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 8)
            row:SetTall(rowH)
            row.Paint = function() end
            local lbl = row:Add("DLabel")
            lbl:Dock(FILL)
            lbl:DockMargin(0, off, 8, 0)
            lbl:SetText(name)
            lbl:SetFont("liaMediumFont")
            lbl:SizeToContents()
            local chk = row:Add("liaCheckBox")
            chk:SetSize(cb, cb)
            chk:Dock(RIGHT)
            chk:SetChecked(current[name] and true or false)
            if editable then
                chk.OnChange = function(_, v)
                    current[name] = v or nil
                    net.Start("liaGroupsSetPerm")
                    net.WriteString(g)
                    net.WriteString(name)
                    net.WriteBool(v)
                    net.SendToServer()
                end
            else
                chk:SetMouseInputEnabled(false)
                chk:SetCursor("arrow")
            end
        end

        local cat = catList:Add("All")
        local list = vgui.Create("DListLayout", cat)
        list:Dock(FILL)
        for _, priv in ipairs(listPrivileges(groups)) do
            addRow(list, priv)
        end

        cat:SetContents(list)
        cat:SetExpanded(true)
        cat.OnToggle = function() timer.Simple(0, function() if IsValid(wrap) then wrap:InvalidateLayout(true) end end) end
        return wrap, catList, current
    end

    local function renderGroupInfo(parent, g, groups)
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
        nameLbl:SetText(L("name") .. ":")
        nameLbl:SetFont("liaBigFont")
        nameLbl:SizeToContents()
        local nameVal = scroll:Add("DLabel")
        nameVal:Dock(TOP)
        nameVal:DockMargin(20, 2, 0, 10)
        nameVal:SetText(g)
        nameVal:SetFont("liaMediumFont")
        nameVal:SizeToContents()
        local inhLbl = scroll:Add("DLabel")
        inhLbl:Dock(TOP)
        inhLbl:DockMargin(20, 10, 0, 0)
        inhLbl:SetText(L("inheritsFrom"))
        inhLbl:SetFont("liaBigFont")
        inhLbl:SizeToContents()
        local inhVal = scroll:Add("DLabel")
        inhVal:Dock(TOP)
        inhVal:DockMargin(20, 2, 0, 0)
        local info = groups[g] and groups[g]._info or {}
        inhVal:SetText(info.inheritance or "user")
        inhVal:SetFont("liaMediumFont")
        inhVal:SizeToContents()
        local function hasType(t)
            for _, typ in ipairs(info.types or {}) do
                if tostring(typ):lower() == t:lower() then return true end
            end
            return false
        end

        local staffLbl = scroll:Add("DLabel")
        staffLbl:Dock(TOP)
        staffLbl:DockMargin(20, 10, 0, 0)
        staffLbl:SetText(L("isStaffLabel"))
        staffLbl:SetFont("liaBigFont")
        staffLbl:SizeToContents()
        local staffVal = scroll:Add("DLabel")
        staffVal:Dock(TOP)
        staffVal:DockMargin(20, 2, 0, 0)
        staffVal:SetText(hasType("Staff") and L("yes") or L("no"))
        staffVal:SetFont("liaMediumFont")
        staffVal:SizeToContents()
        local vipLbl = scroll:Add("DLabel")
        vipLbl:Dock(TOP)
        vipLbl:DockMargin(20, 10, 0, 0)
        vipLbl:SetText(L("isVIPLabel"))
        vipLbl:SetFont("liaBigFont")
        vipLbl:SizeToContents()
        local vipVal = scroll:Add("DLabel")
        vipVal:Dock(TOP)
        vipVal:DockMargin(20, 2, 0, 0)
        vipVal:SetText(hasType("VIP") and L("yes") or L("no"))
        vipVal:SetFont("liaMediumFont")
        vipVal:SizeToContents()
        local privLbl = scroll:Add("DLabel")
        privLbl:Dock(TOP)
        privLbl:DockMargin(20, 10, 0, 6)
        privLbl:SetText(L("privilegesLabel"))
        privLbl:SetFont("liaBigFont")
        privLbl:SizeToContents()
        buildPrivilegeList(scroll, g, groups, editable)
        if editable then
            local createBtn = bottom:Add("liaMediumButton")
            local renameBtn = bottom:Add("liaMediumButton")
            local delBtn = bottom:Add("liaMediumButton")
            createBtn:SetText(L("createGroup"))
            renameBtn:SetText(L("renameGroup"))
            delBtn:SetText(L("deleteGroup"))
            createBtn.DoClick = function()
                lia.util.requestArguments(L("createGroup"), {
                    Name = "string",
                    Inheritance = {"table", {"user", "admin", "superadmin"}},
                    Staff = "boolean",
                    User = "boolean",
                    VIP = "boolean"
                }, function(data)
                    local name = string.Trim(tostring(data.Name or ""))
                    if name == "" then return end
                    local types = {}
                    if data.Staff then types[#types + 1] = "Staff" end
                    if data.User then types[#types + 1] = "User" end
                    if data.VIP then types[#types + 1] = "VIP" end
                    LAST_GROUP = name
                    net.Start("liaGroupsAdd")
                    net.WriteTable({
                        name = name,
                        inherit = data.Inheritance or "user",
                        types = types
                    })

                    net.SendToServer()
                end)
            end

            renameBtn.DoClick = function()
                Derma_StringRequest(L("renameGroup"), string.format(L("renameGroupPrompt"), g), g, function(txt)
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
                Derma_Query(string.format(L("deleteGroupPrompt"), g), L("confirm"), L("yes"), function()
                    net.Start("liaGroupsRemove")
                    net.WriteString(g)
                    net.SendToServer()
                end, L("no"))
            end

            bottom.PerformLayout = function(_, w, h)
                local bw = math.floor(w / 3)
                createBtn:SetPos(0, 0)
                createBtn:SetSize(bw, h)
                renameBtn:SetPos(bw, 0)
                renameBtn:SetSize(bw, h)
                delBtn:SetPos(bw * 2, 0)
                delBtn:SetSize(w - bw * 2, h)
            end
        else
            local addBtn = bottom:Add("liaMediumButton")
            addBtn:SetText(L("createGroup"))
            addBtn.DoClick = function()
                lia.util.requestArguments(L("createGroup"), {
                    Name = "string",
                    Inheritance = {"table", {"user", "admin", "superadmin"}},
                    Staff = "boolean",
                    User = "boolean",
                    VIP = "boolean"
                }, function(data)
                    local name = string.Trim(tostring(data.Name or ""))
                    if name == "" then return end
                    local types = {}
                    if data.Staff then types[#types + 1] = "Staff" end
                    if data.User then types[#types + 1] = "User" end
                    if data.VIP then types[#types + 1] = "VIP" end
                    LAST_GROUP = name
                    net.Start("liaGroupsAdd")
                    net.WriteTable({
                        name = name,
                        inherit = data.Inheritance or "user",
                        types = types
                    })

                    net.SendToServer()
                end)
            end

            bottom.PerformLayout = function(_, w, h)
                addBtn:SetPos(0, 0)
                addBtn:SetSize(w, h)
            end
        end
    end

    local function buildGroupsUI(panel, groups)
        panel:Clear()
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        local keys = {}
        for n in pairs(groups or {}) do
            keys[#keys + 1] = n
        end

        table.sort(keys, function(a, b) return a:lower() < b:lower() end)
        for _, g in ipairs(keys) do
            local page = sheet:Add("DPanel")
            renderGroupInfo(page, g, groups)
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

    lia.net.readBigTable("updateAdminGroups", function(tbl)
        lia.administrator.groups = tbl or {}
        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, lia.administrator.groups) end
    end)

    hook.Add("PopulateAdminTabs", "liaAdmin", function(pages)
        pages[#pages + 1] = {
            name = L("userGroups"),
            drawFunc = function(parent)
                lia.gui.usergroups = parent
                parent:Clear()
                parent:DockPadding(10, 10, 10, 10)
                parent.Paint = function(p, w, h) derma.SkinHook("Paint", "Frame", p, w, h) end
                buildGroupsUI(parent, lia.administrator.groups)
                net.Start("liaGroupsRequest")
                net.SendToServer()
            end
        }
    end)
end