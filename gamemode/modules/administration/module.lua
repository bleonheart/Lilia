MODULE.name = "Administration Utilities"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides a suite of administrative commands, configuration menus, and moderation utilities so staff can effectively manage the server."

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
    util.AddNetworkString("liaRequestPlayerGroup")
    util.AddNetworkString("liaRequestDBTables")
    util.AddNetworkString("liaRequestCharList")
    lia.admin.privileges = lia.admin.privileges or {}
    lia.admin.groups = lia.admin.groups or {}
    lia.admin.lastJoin = lia.admin.lastJoin or {}
    local function syncPrivileges()
        if not (CAMI and CAMI.GetPrivileges and CAMI.GetUsergroups) then return end
        for _, v in ipairs(CAMI.GetPrivileges() or {}) do
            lia.admin.privileges[v.Name] = {
                Name = v.Name,
                MinAccess = v.MinAccess or "user"
            }
        end

        for n, d in pairs(CAMI.GetUsergroups() or {}) do
            lia.admin.groups[n] = lia.admin.groups[n] or buildDefaultTable(n)
            ensureCAMIGroup(n, d.Inherits or "user")
        end
    end

    local function allowed(p)
        return IsValid(p) and p:IsSuperAdmin() or p:hasPrivilege("Manage UserGroups")
    end

    local function getPrivList()
        local t = {}
        for n in pairs(lia.admin.privileges) do
            t[#t + 1] = n
        end

        table.sort(t)
        return t
    end

    local function payloadGroups()
        return {
            cami = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups() or {},
            perms = lia.admin.groups or {},
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
                lastJoin = lia.admin.lastJoin[v:SteamID()] or os.time(),
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

    local function applyToCAMI(g)
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
        lia.admin.lastJoin[p:SteamID()] = os.time()
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

    net.Receive("liaRequestPlayerGroup", function(_, p)
        if not allowed(p) then return end
        local target = net.ReadEntity()
        if not IsValid(target) or not target:IsPlayer() then return end
        local groups = {}
        for name in pairs(lia.admin.groups or {}) do
            groups[#groups + 1] = name
        end

        table.sort(groups)
        p:requestDropdown(L("setUsergroup"), L("chooseGroup"), groups, function(sel)
            if not IsValid(p) or not IsValid(target) then return end
            if lia.admin.groups[sel] then
                lia.admin.setPlayerGroup(target, sel)
                p:notifyLocalized("plyGroupSet")
                lia.log.add(p, "plySetGroup", target:Name(), sel)
            else
                p:notifyLocalized("groupNotExists")
            end
        end)
    end)

    net.Receive("liaGroupsAdd", function(_, p)
        if not allowed(p) then return end
        local n = net.ReadString()
        if n == "" then return end
        local groups = {}
        for name in pairs(lia.admin.groups or {}) do
            groups[#groups + 1] = name
        end

        table.sort(groups)
        p:requestDropdown(L("inheritGroupTitle"), L("selectInheritancePrompt"), groups, function(sel)
            if n == "" or not IsValid(p) then return end
            local inherit = lia.admin.groups[sel] and sel or "user"
            lia.admin.createGroup(n, nil, inherit)
            lia.admin.groups[n] = buildDefaultTable(n)
            applyToCAMI(n, lia.admin.groups[n])
            lia.admin.save(true)
            sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
            notify(p, L("groupCreatedNamed", n))
        end)
    end)

    net.Receive("liaGroupsRemove", function(_, p)
        if not allowed(p) then return end
        local n = net.ReadString()
        if n == "" or DEFAULT_GROUPS[n] then return end
        lia.admin.removeGroup(n)
        lia.admin.groups[n] = nil
        dropCAMIGroup(n)
        lia.admin.save(true)
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, L("groupRemovedNamed", n))
    end)

    net.Receive("liaGroupsRename", function(_, p)
        if not allowed(p) then return end
        local old = net.ReadString()
        local new = net.ReadString()
        if old == "" or new == "" or DEFAULT_GROUPS[old] or DEFAULT_GROUPS[new] then return end
        if lia.admin.groups[new] or not lia.admin.groups[old] then return end
        lia.admin.groups[new] = lia.admin.groups[old]
        lia.admin.groups[old] = nil
        dropCAMIGroup(old)
        ensureCAMIGroup(new, "user")
        lia.admin.save(true)
        applyToCAMI(new, lia.admin.groups[new])
        for _, ply in player.Iterator() do
            if ply:GetUserGroup() == old then lia.admin.setPlayerGroup(ply, new) end
        end

        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, L("groupRenamedNamed", old, new))
    end)

    net.Receive("liaGroupsApply", function(_, p)
        if not allowed(p) then return end
        local g = net.ReadString()
        local t = net.ReadTable()
        if g == "" or DEFAULT_GROUPS[g] then return end
        lia.admin.groups[g] = {}
        for k, v in pairs(t) do
            if v then lia.admin.groups[g][k] = true end
        end

        lia.admin.save(true)
        applyToCAMI(g, lia.admin.groups[g])
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, L("permissionsSavedNamed", g))
    end)

    net.Receive("liaGroupsDefaults", function(_, p)
        if not allowed(p) then return end
        local g = net.ReadString()
        if g == "" or DEFAULT_GROUPS[g] then return end
        lia.admin.groups[g] = buildDefaultTable(g)
        lia.admin.save(true)
        applyToCAMI(g, lia.admin.groups[g])
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, L("groupDefaultsRestored", g))
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
        list:AddColumn(L("name"))
        list:AddColumn(L("steamID"))
        list:AddColumn(L("group"))
        list:AddColumn(L("lastJoin"))
        list:AddColumn(L("banned"))
        for _, v in ipairs(PLAYER_LIST) do
            local bannedText = v.banned == nil and "no" or v.banned and "Yes" or "No"
            local row = list:AddLine(v.name, v.id, v.group, v.lastJoin > 0 and os.date("%Y-%m-%d %H:%M:%S", v.lastJoin) or "", bannedText)
            row.steamID = v.id
            row.steamID64 = v.id64
            if v.banned then row:SetBGColor(Color(255, 120, 120)) end
        end

        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.steamID then return end
            local m = DermaMenu()
            local opt = m:AddOption(L("viewCharacterList"), function() LocalPlayer():ConCommand("say /charlist " .. line.steamID) end)
            opt:SetIcon("icon16/user.png")
            local ply = player.GetBySteamID(line.steamID) or player.GetBySteamID64(line.steamID64)
            if IsValid(ply) and (LocalPlayer():IsSuperAdmin() or LocalPlayer():hasPrivilege("Manage UserGroups")) then
                local grp = m:AddOption(L("setUsergroup"), function()
                    net.Start("liaRequestPlayerGroup")
                    net.WriteEntity(ply)
                    net.SendToServer()
                end)

                grp:SetIcon("icon16/group_edit.png")
            end

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
        tickAll:SetText(L("tickAll"))
        local untickAll = btnBar:Add("liaSmallButton")
        untickAll:Dock(LEFT)
        untickAll:DockMargin(6, 0, 0, 0)
        untickAll:SetWide(90)
        untickAll:SetText(L("untickAll"))
        local defaultsBtn = btnBar:Add("liaSmallButton")
        defaultsBtn:Dock(LEFT)
        defaultsBtn:DockMargin(6, 0, 0, 0)
        defaultsBtn:SetWide(90)
        defaultsBtn:SetText(L("defaults"))
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
            renameBtn:SetText(L("rename"))
            delBtn = btnBar:Add("liaSmallButton")
            delBtn:Dock(RIGHT)
            delBtn:DockMargin(0, 0, 6, 0)
            delBtn:SetWide(90)
            delBtn:SetText(L("delete"))
        end

        local nameLbl = scroll:Add("DLabel")
        nameLbl:Dock(TOP)
        nameLbl:DockMargin(20, 0, 0, 0)
        nameLbl:SetText(L("nameLabel"))
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
        inhLbl:SetText(L("inheritsFrom"))
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
        memLbl:SetText(string.format(L("members"), #memberNames))
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
        privLbl:SetText(L("privileges"))
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
            row.PerformLayout = function(_, _, h) chk:DockMargin(0, math.floor((h - chk:GetTall()) * 0.5), 0, 0) end
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
                Derma_StringRequest(L("renameGroupTitle"), L("newGroupName"), g, function(txt)
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
                Derma_Query(string.format(L("deleteGroupQuery"), g), L("confirm"), L("yes"), function()
                    net.Start("liaGroupsRemove")
                    net.WriteString(g)
                    net.SendToServer()
                end, L("no"))
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
        addBtn:SetText(L("createGroup"))
        addBtn.DoClick = function()
            Derma_StringRequest(L("createGroup"), L("newGroupName"), "", function(txt)
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
        lia.admin.groups = tbl.perms or {}
        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, tbl.cami or {}, lia.admin.groups) end
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
        return IsValid(LocalPlayer()) and LocalPlayer():IsSuperAdmin() and LocalPlayer():hasPrivilege("Manage UserGroups")
    end

    local function canAccessUsergroups()
        return canAccess() and LocalPlayer():hasPrivilege("Access Usergroups Tab")
    end

    local function canAccessPlayers()
        return canAccess() and LocalPlayer():hasPrivilege("Access Players Tab")
    end

    hook.Add("liaAdminRegisterTab", "AdminTabUsergroups", function(tabs)
        tabs["Usergroups"] = {
            icon = "icon16/group.png",
            onShouldShow = canAccessUsergroups,
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

    hook.Add("liaAdminRegisterTab", "AdminTabPlayers", function(tabs)
        tabs["Players"] = {
            icon = "icon16/user.png",
            onShouldShow = canAccessPlayers,
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
        if not (lp:IsSuperAdmin() or lp:hasPrivilege("Manage UserGroups")) then return end
        tabs[L("shortAdmin")] = function(parent)
            parent:Clear()
            local sheet = vgui.Create("DPropertySheet", parent)
            sheet:Dock(FILL)
            sheet.Paint = function() end
            local reg = {}
            hook.Run("liaAdminRegisterTab", reg)
            for name, data in pairs(reg) do
                local should = true
                if isfunction(data.onShouldShow) then should = data.onShouldShow() ~= false end
                if should then
                    local pnl = data.build(sheet)
                    sheet:AddSheet(name, pnl, data.icon or "icon16/application.png")
                end
            end
        end
    end
end

if CAMI.ULX_TOKEN and CAMI.ULX_TOKEN == "ULX" then
    hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
        lia.admin.groups[g.Name] = nil
        if SERVER then
            dropCAMIGroup(g.Name)
            lia.admin.save(true)
        end
    end)

    hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = {
            Name = pv.Name,
            MinAccess = pv.MinAccess or "user",
            Category = pv.Category or "Misc"
        }

        for g in pairs(lia.admin.groups) do
            if CAMI.UsergroupInherits(g, pv.MinAccess or "user") then lia.admin.groups[g][pv.Name] = true end
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.OnPrivilegeUnregistered", "liaSyncAdminPrivilegeRemove", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = nil
        for _, p in pairs(lia.admin.groups) do
            p[pv.Name] = nil
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, _, newGroup)
        if not IsValid(ply) or not SERVER then return end
        lia.db.query(string.format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(newGroup), ply:SteamID64()))
    end)
else
    hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
        lia.admin.groups[g.Name] = nil
        if SERVER then
            dropCAMIGroup(g.Name)
            lia.admin.save(true)
        end
    end)

    hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = {
            Name = pv.Name,
            MinAccess = pv.MinAccess or "user",
            Category = pv.Category or "Misc"
        }

        for g in pairs(lia.admin.groups) do
            if CAMI.UsergroupInherits(g, pv.MinAccess or "user") then lia.admin.groups[g][pv.Name] = true end
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.OnPrivilegeUnregistered", "liaSyncAdminPrivilegeRemove", function(pv)
        if not pv or not pv.Name then return end
        lia.admin.privileges[pv.Name] = nil
        for _, p in pairs(lia.admin.groups) do
            p[pv.Name] = nil
        end

        if SERVER then lia.admin.save(true) end
    end)

    hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, _, newGroup)
        if not IsValid(ply) or not SERVER then return end
        lia.db.query(string.format("UPDATE lia_players SET _userGroup = '%s' WHERE _steamID = %s", lia.db.escape(newGroup), ply:SteamID64()))
    end)
end
