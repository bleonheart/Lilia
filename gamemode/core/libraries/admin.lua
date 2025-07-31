lia.administrator = lia.administrator or {}
lia.administrator.groups = lia.administrator.groups or {}
lia.administrator.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true
}

local function shouldGrant(g, min)
    return g == "superadmin" or g == "admin" and min ~= "superadmin" or min == "user"
end

function lia.administrator.registerPrivilege(priv)
    if not priv or not priv.Name then return end
    local min = priv.MinAccess or "user"
    for groupName, permissions in pairs(lia.administrator.groups) do
        permissions[priv.Name] = shouldGrant(groupName, min) and true or permissions[priv.Name]
    end

    if SERVER then lia.administrator.save() end
end

function lia.administrator.load()
    local function ensureDefaults(groups)
        local defaults = {"user", "admin", "superadmin"}
        local created = false
        if not table.IsEmpty(groups) then
            for _, grp in ipairs(defaults) do
                groups[grp] = groups[grp] or {}
            end

            created = true
        else
            for _, grp in ipairs(defaults) do
                if not groups[grp] then
                    groups[grp] = {}
                    created = true
                end
            end
        end
        return created
    end

    local function migratePrivileges(groups, privs)
        if not istable(privs) or table.Count(privs) == 0 then return false end
        local changed = false
        for k, v in pairs(privs) do
            local name
            local min = "user"
            if istable(v) then
                name = v.Name or isstring(k) and k or nil
                min = v.MinAccess or "user"
            elseif isstring(v) then
                name = v
            end

            if isstring(name) and name ~= "" then
                for groupName, permissions in pairs(groups) do
                    permissions = permissions or {}
                    groups[groupName] = permissions
                    if shouldGrant(groupName, min) and not permissions[name] then
                        permissions[name] = true
                        changed = true
                    end
                end
            end
        end
        return changed
    end

    local function continueLoad(groups)
        lia.administrator.groups = groups or {}
        lia.bootstrap("Administration", L("adminSystemLoaded"))
    end

    lia.db.selectOne({"groups", "usergroups", "privileges"}, "admin"):next(function(res)
        local newGroups = res and util.JSONToTable(res.groups or "") or {}
        local created = ensureDefaults(newGroups)
        if table.Count(newGroups) == 0 then
            local oldGroups = res and util.JSONToTable(res.usergroups or "") or {}
            created = ensureDefaults(oldGroups) or created
            if migratePrivileges(oldGroups, res and util.JSONToTable(res.privileges or "") or {}) then created = true end
            newGroups = oldGroups
        end

        if created then
            lia.administrator.groups = newGroups
            lia.administrator.save()
        end

        continueLoad(newGroups)
    end)
end

function lia.administrator.createGroup(groupName, info)
    if lia.administrator.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administrator.groups[groupName] = info or {}
    if SERVER then lia.administrator.save() end
end

function lia.administrator.removeGroup(groupName)
    if groupName == "user" or groupName == "admin" or groupName == "superadmin" then
        lia.error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.administrator.groups[groupName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.administrator.groups[groupName] = nil
    if SERVER then lia.administrator.save() end
end

function lia.administrator.renameGroup(oldName, newName)
    if lia.administrator.DefaultGroups[oldName] then
        lia.error("[Lilia Administration] The base usergroups cannot be renamed!\n")
        return
    end

    if not lia.administrator.groups[oldName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    if lia.administrator.groups[newName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administrator.groups[newName] = lia.administrator.groups[oldName]
    lia.administrator.groups[oldName] = nil
    if SERVER then lia.administrator.save() end
end

if SERVER then
    function lia.administrator.addPermission(groupName, permission)
        if not lia.administrator.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administrator.DefaultGroups[groupName] then return end
        lia.administrator.groups[groupName][permission] = true
        lia.administrator.save()
        hook.Run("OnUsergroupPermissionsChanged", groupName, lia.administrator.groups[groupName])
    end

    function lia.administrator.removePermission(groupName, permission)
        if not lia.administrator.groups[groupName] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administrator.DefaultGroups[groupName] then return end
        lia.administrator.groups[groupName][permission] = nil
        lia.administrator.save()
        hook.Run("OnUsergroupPermissionsChanged", groupName, lia.administrator.groups[groupName])
    end

    function lia.administrator.sync(client)
        if client and IsValid(client) then
            lia.net.writeBigTable(client, "updateAdminGroups", lia.administrator.groups)
        else
            local players = player.GetHumans()
            if #players > 0 then
                for _, ply in ipairs(players) do
                    lia.net.writeBigTable(ply, "updateAdminGroups", lia.administrator.groups)
                end
            end
        end
    end

    local function extractPrivileges()
        local seen = {}
        local privs = {}
        for groupName, perms in pairs(lia.administrator.groups) do
            for name, allowed in pairs(perms or {}) do
                if allowed and not seen[name] then seen[name] = true end
            end
        end

        for name in pairs(seen) do
            local min = "superadmin"
            if lia.administrator.groups.user and lia.administrator.groups.user[name] then
                min = "user"
            elseif lia.administrator.groups.admin and lia.administrator.groups.admin[name] then
                min = "admin"
            end

            privs[#privs + 1] = {
                Name = name,
                MinAccess = min
            }
        end
        return privs
    end

    function lia.administrator.save(noNetwork)
        lia.db.upsert({
            groups = util.TableToJSON(lia.administrator.groups),
            usergroups = util.TableToJSON(lia.administrator.groups),
            privileges = util.TableToJSON(extractPrivileges())
        }, "admin")

        if noNetwork then return end
        lia.administrator.sync()
    end
else
    function lia.administrator.execCommand(cmd, victim, dur, reason)
        if hook.Run("RunAdminSystemCommand") == true then return end
        local id = IsValid(victim) and victim:SteamID() or tostring(victim)
        if cmd == "kick" then
            RunConsoleCommand("say", "/plykick " .. string.format("'%s'", tostring(id)) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "ban" then
            RunConsoleCommand("say", "/plyban " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "unban" then
            RunConsoleCommand("say", "/plyunban " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "mute" then
            RunConsoleCommand("say", "/plymute " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "unmute" then
            RunConsoleCommand("say", "/plyunmute " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "gag" then
            RunConsoleCommand("say", "/plygag " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0) .. (reason and " " .. string.format("'%s'", tostring(reason)) or ""))
            return true
        elseif cmd == "ungag" then
            RunConsoleCommand("say", "/plyungag " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "freeze" then
            RunConsoleCommand("say", "/plyfreeze " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0))
            return true
        elseif cmd == "unfreeze" then
            RunConsoleCommand("say", "/plyunfreeze " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "slay" then
            RunConsoleCommand("say", "/plyslay " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "bring" then
            RunConsoleCommand("say", "/plybring " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "goto" then
            RunConsoleCommand("say", "/plygoto " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "return" then
            RunConsoleCommand("say", "/plyreturn " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "jail" then
            RunConsoleCommand("say", "/plyjail " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0))
            return true
        elseif cmd == "unjail" then
            RunConsoleCommand("say", "/plyunjail " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "cloak" then
            RunConsoleCommand("say", "/plycloak " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "uncloak" then
            RunConsoleCommand("say", "/plyuncloak " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "god" then
            RunConsoleCommand("say", "/plygod " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "ungod" then
            RunConsoleCommand("say", "/plyungod " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "ignite" then
            RunConsoleCommand("say", "/plyignite " .. string.format("'%s'", tostring(id)) .. " " .. tostring(dur or 0))
            return true
        elseif cmd == "extinguish" or cmd == "unignite" then
            RunConsoleCommand("say", "/plyextinguish " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "strip" then
            RunConsoleCommand("say", "/plystrip " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "respawn" then
            RunConsoleCommand("say", "/plyrespawn " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "blind" then
            RunConsoleCommand("say", "/plyblind " .. string.format("'%s'", tostring(id)))
            return true
        elseif cmd == "unblind" then
            RunConsoleCommand("say", "/plyunblind " .. string.format("'%s'", tostring(id)))
            return true
        end
    end
end

if SERVER then
    local function ensureStructures()
        lia.administrator.groups = lia.administrator.groups or {}
        for n in pairs(lia.administrator.groups) do
            lia.administrator.groups[n] = lia.administrator.groups[n] or {}
        end
    end

    local function broadcastGroups()
        local players = player.GetHumans()
        for _, ply in ipairs(players) do
            lia.net.writeBigTable(ply, "liaGroupsData", lia.administrator.groups or {})
        end
    end

    ensureStructures()
    net.Receive("liaGroupsRequest", function(_, p)
        ensureStructures()
        lia.net.writeBigTable(p, "liaGroupsData", lia.administrator.groups or {})
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
    local PRIV_LIST = {}
    local LAST_GROUP
    local function setFont(o, f)
        if IsValid(o) then o:SetFont(f) end
    end

    local function computePrivilegeList(groups)
        local seen = {}
        local list = {}
        for _, perms in pairs(groups or {}) do
            for name, val in pairs(perms or {}) do
                if val and not seen[name] then
                    seen[name] = true
                    list[#list + 1] = name
                end
            end
        end

        table.sort(list, function(a, b) return a:lower() < b:lower() end)
        return list
    end

    local function buildPrivilegeList(parent, g, perms, editable)
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

        local cat = catList:Add("All")
        local list = vgui.Create("DListLayout", cat)
        list:Dock(FILL)
        for _, privName in ipairs(PRIV_LIST or {}) do
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
        local wrap, catList, current = buildPrivilegeList(scroll, g, perms, editable)
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

    lia.net.readBigTable("liaGroupsData", function(tbl)
        tbl = tbl or {}
        lia.administrator.groups = tbl
        PRIV_LIST = computePrivilegeList(lia.administrator.groups)
        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, lia.administrator.groups, lia.administrator.groups) end
    end)
end

hook.Add("PopulateAdminTabs", "liaAdmin", function(pages)
    if not IsValid(LocalPlayer()) then return end
    pages[#pages + 1] = {
        name = L("userGroups"),
        drawFunc = function(parent)
            lia.gui.usergroups = parent
            parent:Clear()
            parent:DockPadding(10, 10, 10, 10)
            parent.Paint = function(p, w, h) derma.SkinHook("Paint", "Frame", p, w, h) end
            net.Start("liaGroupsRequest")
            net.SendToServer()
        end
    }
end)