MODULE.name = "Administration Utilities"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides a suite of administrative commands, configuration menus, and moderation utilities so staff can effectively manage the server."
MODULE.Privileges = {
    {
        Name = "Staff Permissions - Can Remove Warns",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Manage Prop Blacklist",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Access Configuration Menu",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Access Edit Configuration Menu",
        MinAccess = "superadmin"
    },
    {
        Name = "Staff Permissions - Manage UserGroups",
        MinAccess = "superadmin"
    }
}

local DEFAULT_GROUPS = {
    user = true,
    admin = true,
    superadmin = true
}

local CHUNK = 60000
local function buildDefaultTable(g)
    local t = {}
    if not (CAMI and CAMI.GetPrivileges and CAMI.UsergroupInherits) then return t end
    for _, v in ipairs(CAMI.GetPrivileges() or {}) do
        if CAMI.UsergroupInherits(g, v.MinAccess or "user") then t[v.Name] = true end
    end
    return t
end

local function ensureCAMIGroup(n, inh)
    if not (CAMI and CAMI.GetUsergroups and CAMI.RegisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if not g[n] then
        CAMI.RegisterUsergroup({
            Name = n,
            Inherits = inh or "user"
        })
    end
end

local function dropCAMIGroup(n)
    if not (CAMI and CAMI.GetUsergroups and CAMI.UnregisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if g[n] then CAMI.UnregisterUsergroup(n) end
end

local function sendBigTable(ply, tbl, strChunk, strDone)
    local raw = util.TableToJSON(tbl)
    local comp = util.Compress(raw)
    local len = #comp
    local id = util.CRC(tostring(SysTime()) .. len)
    local parts = math.ceil(len / CHUNK)
    for i = 1, parts do
        local chunk = string.sub(comp, (i - 1) * CHUNK + 1, math.min(i * CHUNK, len))
        net.Start(strChunk)
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

    net.Start(strDone)
    net.WriteString(id)
    if IsEntity(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

if SERVER then
    util.AddNetworkString("liaGroupsAdd")
    util.AddNetworkString("liaGroupsRemove")
    util.AddNetworkString("liaGroupsRequest")
    util.AddNetworkString("liaGroupsApply")
    util.AddNetworkString("liaGroupsDefaults")
    util.AddNetworkString("liaGroupsRename")
    util.AddNetworkString("liaGroupsDataChunk")
    util.AddNetworkString("liaGroupsDataDone")
    util.AddNetworkString("liaGroupsNotice")
    util.AddNetworkString("liaPlayersRequest")
    util.AddNetworkString("liaPlayersDataChunk")
    util.AddNetworkString("liaPlayersDataDone")
    lia.administration.privileges = lia.administration.privileges or {}
    lia.administration.groups = lia.administration.groups or {}
    lia.administration.lastJoin = lia.administration.lastJoin or {}
    local function syncPrivileges()
        if not (CAMI and CAMI.GetPrivileges and CAMI.GetUsergroups) then return end
        for _, v in ipairs(CAMI.GetPrivileges() or {}) do
            lia.administration.privileges[v.Name] = {
                Name = v.Name,
                MinAccess = v.MinAccess or "user"
            }
        end

        for n, d in pairs(CAMI.GetUsergroups() or {}) do
            lia.administration.groups[n] = lia.administration.groups[n] or buildDefaultTable(n)
            ensureCAMIGroup(n, d.Inherits or "user")
        end
    end

    local function allowed(p)
        return IsValid(p) and p:IsSuperAdmin() or p:hasPrivilege("Staff Permissions - Manage UserGroups")
    end

    local function getPrivList()
        local t = {}
        for n in pairs(lia.administration.privileges) do
            t[#t + 1] = n
        end

        table.sort(t)
        return t
    end

    local function payloadGroups()
        return {
            cami = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups() or {},
            perms = lia.administration.groups or {},
            privList = getPrivList()
        }
    end

    local function getBanList()
        local data = file.Read("cfg/banned_user.cfg", "GAME")
        local t = {}
        if data then
            for sid in string.gmatch(data, "banid%s+%d+%s+(STEAM_%d:%d:%d+)") do
                t[sid] = true
            end
        end
        return t
    end

    local function payloadPlayers()
        local bans = getBanList()
        local plys = {}
        for _, v in player.Iterator() do
            if v:IsBot() then continue end
            plys[#plys + 1] = {
                name = v:Nick(),
                id = v:SteamID(),
                id64 = v:SteamID64(),
                group = v:GetUserGroup(),
                lastJoin = lia.administration.lastJoin[v:SteamID()] or os.time(),
                banned = bans[v:SteamID()] or false
            }

            bans[v:SteamID()] = nil
        end

        for id in pairs(bans) do
            plys[#plys + 1] = {
                name = "",
                id = id,
                id64 = util.SteamIDTo64(id),
                group = "",
                lastJoin = 0,

                banned = true
            }
        end
        return {
            players = plys
        }
    end

    local function applyToCAMI(g, t)
        if not (CAMI and CAMI.GetUsergroups and CAMI.RegisterUsergroup) then return end
        ensureCAMIGroup(g, CAMI.GetUsergroups()[g] and CAMI.GetUsergroups()[g].Inherits or "user")
    end

    local function notify(p, msg)
        if IsValid(p) and p.notify then p:notify(msg) end
        net.Start("liaGroupsNotice")
        net.WriteString(msg)
        if IsEntity(p) then
            net.Send(p)
        else
            net.Broadcast()
        end
    end

    syncPrivileges()
    hook.Add("PlayerInitialSpawn", "liaAdminTrackJoin", function(p)
        if p:IsBot() then return end
        lia.administration.lastJoin[p:SteamID()] = os.time()
    end)

    net.Receive("liaGroupsRequest", function(_, p)
        if not allowed(p) then return end
        syncPrivileges()
        sendBigTable(p, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    end)

    net.Receive("liaPlayersRequest", function(_, p)
        if not allowed(p) then return end
        sendBigTable(p, payloadPlayers(), "liaPlayersDataChunk", "liaPlayersDataDone")
    end)

    net.Receive("liaGroupsAdd", function(_, p)
        if not allowed(p) then return end
        local n = net.ReadString()
        if n == "" then return end
        lia.administration.createGroup(n)
        lia.administration.groups[n] = buildDefaultTable(n)
        ensureCAMIGroup(n, "user")
        lia.administration.save(true)
        applyToCAMI(n, lia.administration.groups[n])
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, "Group '" .. n .. "' created.")
    end)

    net.Receive("liaGroupsRemove", function(_, p)
        if not allowed(p) then return end
        local n = net.ReadString()
        if n == "" or DEFAULT_GROUPS[n] then return end
        lia.administration.removeGroup(n)
        lia.administration.groups[n] = nil
        dropCAMIGroup(n)
        lia.administration.save(true)
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, "Group '" .. n .. "' removed.")
    end)

    net.Receive("liaGroupsRename", function(_, p)
        if not allowed(p) then return end
        local old = net.ReadString()
        local new = net.ReadString()
        if old == "" or new == "" or DEFAULT_GROUPS[old] or DEFAULT_GROUPS[new] then return end
        if lia.administration.groups[new] or not lia.administration.groups[old] then return end
        lia.administration.groups[new] = lia.administration.groups[old]
        lia.administration.groups[old] = nil
        dropCAMIGroup(old)
        ensureCAMIGroup(new, "user")
        lia.administration.save(true)
        applyToCAMI(new, lia.administration.groups[new])
        for _, ply in player.Iterator() do
            if ply:GetUserGroup() == old then lia.administration.setPlayerGroup(ply, new) end
        end

        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, "Group '" .. old .. "' renamed to '" .. new .. "'.")
    end)

    net.Receive("liaGroupsApply", function(_, p)
        if not allowed(p) then return end
        local g = net.ReadString()
        local t = net.ReadTable()
        if g == "" or DEFAULT_GROUPS[g] then return end
        lia.administration.groups[g] = {}
        for k, v in pairs(t) do
            if v then lia.administration.groups[g][k] = true end
        end

        lia.administration.save(true)
        applyToCAMI(g, lia.administration.groups[g])
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, "Permissions saved for '" .. g .. "'.")
    end)

    net.Receive("liaGroupsDefaults", function(_, p)
        if not allowed(p) then return end
        local g = net.ReadString()
        if g == "" or DEFAULT_GROUPS[g] then return end
        lia.administration.groups[g] = buildDefaultTable(g)
        lia.administration.save(true)
        applyToCAMI(g, lia.administration.groups[g])
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, "Defaults restored for '" .. g .. "'.")
    end)
else
    local groupChunks, playerChunks = {}, {}
    local PRIV_LIST, PLAYER_LIST, LAST_GROUP = {}, {}, nil
    local function setFont(o, f)
        if IsValid(o) then o:SetFont(f) end
    end

    local function buildPlayersUI(parent)
        parent:Clear()
        local list = parent:Add("DListView")
        list:Dock(FILL)
        list:AddColumn("Name")
        list:AddColumn("SteamID")
        list:AddColumn("Group")
        list:AddColumn("Last Join")
        list:AddColumn("Last Character")
        list:AddColumn("Banned")
        for _, v in ipairs(PLAYER_LIST) do
            local row = list:AddLine(v.name, v.id, v.group, v.lastJoin > 0 and os.date("%Y-%m-%d %H:%M:%S", v.lastJoin) or "", v.banned and "Yes" or "No")
            row.steamID = v.id
            row.steamID64 = v.id64
            if v.banned then row:SetBGColor(Color(255, 120, 120)) end
        end

        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.steamID then return end
            local m = DermaMenu()
            local opt = m:AddOption("View Character List", function() LocalPlayer():ConCommand("say /charlist " .. line.steamID) end)
            opt:SetIcon("icon16/user.png")
            m:Open()
        end
    end

    local function renderGroupInfo(parent, g, cami, perms)
        parent:Clear()
        LAST_GROUP = g
        local scroll = parent:Add("DScrollPanel")
        scroll:Dock(FILL)
        local btnBar = scroll:Add("DPanel")
        btnBar:Dock(TOP)
        btnBar:SetTall(36)
        btnBar:DockMargin(20, 20, 20, 12)
        btnBar.Paint = function() end
        local editable = not DEFAULT_GROUPS[g]
        local tickAll = btnBar:Add("liaSmallButton")
        tickAll:Dock(LEFT)
        tickAll:SetWide(90)
        tickAll:SetText("Tick All")
        local untickAll = btnBar:Add("liaSmallButton")
        untickAll:Dock(LEFT)
        untickAll:DockMargin(6, 0, 0, 0)
        untickAll:SetWide(90)
        untickAll:SetText("Untick All")
        local defaultsBtn = btnBar:Add("liaSmallButton")
        defaultsBtn:Dock(LEFT)
        defaultsBtn:DockMargin(6, 0, 0, 0)
        defaultsBtn:SetWide(90)
        defaultsBtn:SetText("Defaults")
        if not editable then
            tickAll:SetEnabled(false)
            untickAll:SetEnabled(false)
            defaultsBtn:SetEnabled(false)
        end

        local delBtn, renameBtn
        if not DEFAULT_GROUPS[g] then
            renameBtn = btnBar:Add("liaSmallButton")
            renameBtn:Dock(RIGHT)
            renameBtn:DockMargin(0, 0, 6, 0)
            renameBtn:SetWide(90)
            renameBtn:SetText("Rename")
            delBtn = btnBar:Add("liaSmallButton")
            delBtn:Dock(RIGHT)
            delBtn:DockMargin(0, 0, 6, 0)
            delBtn:SetWide(90)
            delBtn:SetText("Delete")
        end

        local nameLbl = scroll:Add("DLabel")
        nameLbl:Dock(TOP)
        nameLbl:DockMargin(20, 0, 0, 0)
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
        inhVal:DockMargin(20, 2, 0, 20)
        inhVal:SetText(cami[g] and cami[g].Inherits or "user")
        setFont(inhVal, "liaMediumFont")
        inhVal:SizeToContents()
        local memberNames = {}
        for _, m in ipairs(PLAYER_LIST) do
            if m.group == g then memberNames[#memberNames + 1] = m.name ~= "" and m.name or m.id end
        end

        local memLbl = scroll:Add("DLabel")
        memLbl:Dock(TOP)
        memLbl:DockMargin(20, 0, 0, 6)
        memLbl:SetText("Members (" .. #memberNames .. ")")
        setFont(memLbl, "liaBigFont")
        memLbl:SizeToContents()
        local memHolder = scroll:Add("DPanel")
        memHolder:Dock(TOP)
        memHolder:DockMargin(20, 0, 20, 20)
        memHolder.Paint = function() end
        local memLayout = vgui.Create("DListLayout", memHolder)
        memLayout:Dock(FILL)
        surface.SetFont("liaMediumFont")
        local _, fh = surface.GetTextSize("W")
        for _, n in ipairs(memberNames) do
            local lbl = memLayout:Add("DLabel")
            lbl:SetText(n)
            setFont(lbl, "liaMediumFont")
            lbl:SizeToContents()
            lbl:Dock(TOP)
            lbl:DockMargin(0, 0, 0, 4)
            memHolder:SetTall(memHolder:GetTall() + fh + 4)
        end

        local privLbl = scroll:Add("DLabel")
        privLbl:Dock(TOP)
        privLbl:DockMargin(20, 0, 0, 6)
        privLbl:SetText("Privileges")
        setFont(privLbl, "liaBigFont")
        privLbl:SizeToContents()
        local listHolder = scroll:Add("DPanel")
        listHolder:Dock(TOP)
        listHolder:DockMargin(20, 0, 20, 20)
        listHolder.Paint = function() end
        local list = vgui.Create("DListLayout", listHolder)
        list:Dock(FILL)
        local current = table.Copy(perms[g] or {})
        local checkboxes = {}
        surface.SetFont("liaMediumFont")
        local _, fh2 = surface.GetTextSize("W")
        local rowH = fh2 + 24
        local off = math.floor((rowH - fh2) * 0.5)
        for _, priv in ipairs(PRIV_LIST) do
            local row = vgui.Create("DPanel", list)
            row:SetTall(rowH)
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 10)
            row.Paint = function() end
            local lbl = row:Add("DLabel")
            lbl:Dock(LEFT)
            lbl:SetText(priv)
            setFont(lbl, "liaMediumFont")
            lbl:SizeToContents()
            lbl:DockMargin(0, off, 12, 0)
            local chk = row:Add("liaCheckBox")
            chk:Dock(LEFT)
            chk:SetWide(32)
            chk:SetChecked(current[priv] and true or false)
            chk.OnChange = function(_, v)
                if v then
                    current[priv] = true
                else
                    current[priv] = nil
                end
            end

            if not editable then chk:SetEnabled(false) end
            row.PerformLayout = function(_, w, h) chk:DockMargin(0, math.floor((h - chk:GetTall()) * 0.5), 0, 0) end
            checkboxes[#checkboxes + 1] = chk
        end

        list:InvalidateLayout(true)
        local totalH = 0
        for _, c in ipairs(list:GetChildren()) do
            totalH = totalH + c:GetTall() + 10
        end

        listHolder:SetTall(totalH)
        local function setAll(state)
            for _, cb in ipairs(checkboxes) do
                cb:SetChecked(state)
            end
        end

        tickAll.DoClick = function() if editable then setAll(true) end end
        untickAll.DoClick = function() if editable then setAll(false) end end
        defaultsBtn.DoClick = function()
            if not editable then return end
            net.Start("liaGroupsDefaults")
            net.WriteString(g)
            net.SendToServer()
        end

        if renameBtn then
            renameBtn.DoClick = function()
                Derma_StringRequest("Rename Group", "New group name:", g, function(txt)
                    if txt == "" or txt == g then return end
                    net.Start("liaGroupsRename")
                    net.WriteString(g)
                    net.WriteString(txt)
                    net.SendToServer()
                end)
            end
        end

        if delBtn then
            delBtn.DoClick = function()
                Derma_Query("Delete group '" .. g .. "'?", "Confirm", "Yes", function()
                    net.Start("liaGroupsRemove")
                    net.WriteString(g)
                    net.SendToServer()
                end, "No")
            end
        end
    end

    local function buildGroupsUI(panel, cami, perms)
        panel:Clear()
        local sidebar = panel:Add("DScrollPanel")
        sidebar:Dock(RIGHT)
        sidebar:SetWide(200)
        sidebar:DockMargin(0, 20, 20, 20)
        local content = panel:Add("DPanel")
        content:Dock(FILL)
        content:DockMargin(10, 10, 10, 10)
        local selected
        local keys = {}
        for g in pairs(cami) do
            keys[#keys + 1] = g
        end

        table.sort(keys)
        for _, g in ipairs(keys) do
            local b = sidebar:Add("liaMediumButton")
            b:Dock(TOP)
            b:DockMargin(0, 0, 0, 10)
            b:SetTall(40)
            b:SetText(g)
            b.DoClick = function()
                if IsValid(selected) then selected:SetSelected(false) end
                b:SetSelected(true)
                selected = b
                renderGroupInfo(content, g, cami, perms)
            end
        end

        local addBtn = sidebar:Add("liaMediumButton")
        addBtn:Dock(TOP)
        addBtn:DockMargin(0, 20, 0, 0)
        addBtn:SetTall(36)
        addBtn:SetText("Create Group")
        addBtn.DoClick = function()
            Derma_StringRequest("Create Group", "New group name:", "", function(txt)
                if txt == "" then return end
                LAST_GROUP = txt
                net.Start("liaGroupsAdd")
                net.WriteString(txt)
                net.SendToServer()
            end)
        end

        if LAST_GROUP and cami[LAST_GROUP] then
            for _, b in ipairs(sidebar:GetChildren()) do
                if b.GetText and b:GetText() == LAST_GROUP then
                    b:DoClick()
                    break
                end
            end
        elseif keys[1] then
            for _, b in ipairs(sidebar:GetChildren()) do
                if b.GetText and b:GetText() == keys[1] then
                    b:DoClick()
                    break
                end
            end
        end
    end

    local function handleGroupDone(id)
        local data = table.concat(groupChunks[id])
        groupChunks[id] = nil
        local tbl = util.JSONToTable(util.Decompress(data) or "") or {}
        PRIV_LIST = tbl.privList or {}
        lia.administration.groups = tbl.perms or {}
        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, tbl.cami or {}, lia.administration.groups) end
    end

    local function handlePlayerDone(id)
        local data = table.concat(playerChunks[id])
        playerChunks[id] = nil
        local tbl = util.JSONToTable(util.Decompress(data) or "") or {}
        PLAYER_LIST = tbl.players or {}
        if IsValid(lia.gui.players) then buildPlayersUI(lia.gui.players) end
    end

    net.Receive("liaGroupsDataChunk", function()
        local id = net.ReadString()
        local idx = net.ReadUInt(16)
        local total = net.ReadUInt(16)
        local len = net.ReadUInt(16)
        local dat = net.ReadData(len)
        groupChunks[id] = groupChunks[id] or {}
        groupChunks[id][idx] = dat
        if idx == total then handleGroupDone(id) end
    end)

    net.Receive("liaGroupsDataDone", function()
        local id = net.ReadString()
        if groupChunks[id] then handleGroupDone(id) end
    end)

    net.Receive("liaPlayersDataChunk", function()
        local id = net.ReadString()
        local idx = net.ReadUInt(16)
        local total = net.ReadUInt(16)
        local len = net.ReadUInt(16)
        local dat = net.ReadData(len)
        playerChunks[id] = playerChunks[id] or {}
        playerChunks[id][idx] = dat
        if idx == total then handlePlayerDone(id) end
    end)

    net.Receive("liaPlayersDataDone", function()
        local id = net.ReadString()
        if playerChunks[id] then handlePlayerDone(id) end
    end)

    net.Receive("liaGroupsNotice", function()
        local msg = net.ReadString()
        if IsValid(LocalPlayer()) and LocalPlayer().notify then LocalPlayer():notify(msg) end
    end)

    local function canAccess()
        return IsValid(LocalPlayer()) and LocalPlayer():IsSuperAdmin() and LocalPlayer():hasPrivilege("Staff Permissions - Manage UserGroups")
    end

    hook.Add("liaAdminRegisterTab", "AdminTabUsergroups", function(parent, tabs)
        if not canAccess() then return end
        tabs["Usergroups"] = {
            icon = "icon16/group.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.usergroups = pnl
                net.Start("liaGroupsRequest")
                net.SendToServer()
                return pnl
            end
        }
    end)

    hook.Add("liaAdminRegisterTab", "AdminTabPlayers", function(parent, tabs)
        if not canAccess() then return end
        tabs["Players"] = {
            icon = "icon16/user.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.players = pnl
                net.Start("liaPlayersRequest")
                net.SendToServer()
                return pnl
            end
        }
    end)

    function MODULE:CreateMenuButtons(tabs)
        local lp = LocalPlayer()
        if not IsValid(lp) then return end
        if not (lp:IsSuperAdmin() or lp:hasPrivilege("Staff Permissions - Manage UserGroups")) then return end
        tabs[L("shortAdmin")] = function(parent)
            parent:Clear()
            local sheet = vgui.Create("DPropertySheet", parent)
            sheet:Dock(FILL)
            local reg = {}
            hook.Run("liaAdminRegisterTab", parent, reg)
            for name, data in pairs(reg) do
                local pnl = data.build(sheet)
                sheet:AddSheet(name, pnl, data.icon or "icon16/application.png")
            end
        end
    end
end

hook.Add("CAMI.OnUsergroupRegistered", "liaSyncAdminGroupAdd", function(g)
    if lia.administration.isDisabled() then return end
    lia.administration.groups[g.Name] = buildDefaultTable(g.Name)
    if SERVER then
        ensureCAMIGroup(g.Name, g.Inherits or "user")
        lia.administration.save(true)
    end
end)

hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
    if lia.administration.isDisabled() then return end
    lia.administration.groups[g.Name] = nil
    if SERVER then
        dropCAMIGroup(g.Name)
        lia.administration.save(true)
    end
end)

hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
    if lia.administration.isDisabled() or not pv or not pv.Name then return end
    lia.administration.privileges[pv.Name] = {
        Name = pv.Name,
        MinAccess = pv.MinAccess or "user"
    }

    for g in pairs(lia.administration.groups) do
        if CAMI.UsergroupInherits(g, pv.MinAccess or "user") then lia.administration.groups[g][pv.Name] = true end
    end

    if SERVER then lia.administration.save(true) end
end)

hook.Add("CAMI.OnPrivilegeUnregistered", "liaSyncAdminPrivilegeRemove", function(pv)
    if lia.administration.isDisabled() or not pv or not pv.Name then return end
    lia.administration.privileges[pv.Name] = nil
    for _, p in pairs(lia.administration.groups) do
        p[pv.Name] = nil
    end

    if SERVER then lia.administration.save(true) end
end)

hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, old, new)
    if lia.administration.isDisabled() or not IsValid(ply) then return end
    if not SERVER then return end
    lia.db.query(string.format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(new), ply:SteamID64()))
end)