function MODULE:ShowPlayerOptions(target, options)
    local client = LocalPlayer()
    if (client:hasPrivilege("Can Access Scoreboard Info Out Of Staff") or client:hasPrivilege("Can Access Scoreboard Admin Options") and client:isStaffOnDuty()) and IsValid(target) then
        local orderedOptions = {
            {
                name = L("nameCopyFormat", target:Name()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "Name"))
                    SetClipboardText(target:Name())
                end
            },
            {
                name = L("charIDCopyFormat", target:getChar() and target:getChar():getID() or L("na")),
                image = "icon16/page_copy.png",
                func = function()
                    if target:getChar() then
                        client:ChatPrint(L("copiedCharID", target:getChar():getID()))
                        SetClipboardText(target:getChar():getID())
                    end
                end
            },
            {
                name = L("steamIDCopyFormat", target:SteamID()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "SteamID"))
                    SetClipboardText(target:SteamID())
                end
            },
            {
                name = L("steamID64CopyFormat", target:SteamID64()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "SteamID64"))
                    SetClipboardText(target:SteamID64())
                end
            },
            {
                name = "Blind",
                image = "icon16/eye.png",
                func = function() lia.admin.execCommand("blind", target) end
            },
            {
                name = "Freeze",
                image = "icon16/lock.png",
                func = function() lia.admin.execCommand("freeze", target) end
            },
            {
                name = "Gag",
                image = "icon16/sound_mute.png",
                func = function() lia.admin.execCommand("gag", target) end
            },
            {
                name = "Ignite",
                image = "icon16/fire.png",
                func = function() lia.admin.execCommand("ignite", target) end
            },
            {
                name = "Jail",
                image = "icon16/lock.png",
                func = function() lia.admin.execCommand("jail", target) end
            },
            {
                name = "Mute",
                image = "icon16/sound_delete.png",
                func = function() lia.admin.execCommand("mute", target) end
            },
            {
                name = "Slay",
                image = "icon16/bomb.png",
                func = function() lia.admin.execCommand("slay", target) end
            },
            {
                name = "Unblind",
                image = "icon16/eye.png",
                func = function() lia.admin.execCommand("unblind", target) end
            },
            {
                name = "Ungag",
                image = "icon16/sound_low.png",
                func = function() lia.admin.execCommand("ungag", target) end
            },
            {
                name = "Unfreeze",
                image = "icon16/accept.png",
                func = function() lia.admin.execCommand("unfreeze", target) end
            },
            {
                name = "Unmute",
                image = "icon16/sound_add.png",
                func = function() lia.admin.execCommand("unmute", target) end
            },
            {
                name = "Bring",
                image = "icon16/arrow_down.png",
                func = function() lia.admin.execCommand("bring", target) end
            },
            {
                name = "Goto",
                image = "icon16/arrow_right.png",
                func = function() lia.admin.execCommand("goto", target) end
            },
            {
                name = "Respawn",
                image = "icon16/arrow_refresh.png",
                func = function() lia.admin.execCommand("respawn", target) end
            },
            {
                name = L("return"),
                image = "icon16/arrow_redo.png",
                func = function() lia.admin.execCommand("return", target) end
            },
            {
                name = L("characterList"),
                image = "icon16/user.png",
                func = function() RunConsoleCommand("say", "/charlist " .. target:SteamID()) end
            }
        }

        if client:IsSuperAdmin() or client:hasPrivilege("Manage UserGroups") then
            table.insert(orderedOptions, {
                name = L("setUsergroup"),
                image = "icon16/group_edit.png",
                func = function()
                    net.Start("liaRequestPlayerGroup")
                    net.WriteEntity(target)
                    net.SendToServer()
                end
            })
        end

        for _, option in ipairs(orderedOptions) do
            table.insert(options, option)
        end
    end
end

local DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true
}

local groupChunks, playerChunks = {}, {}
local PrivilegeCategories, PlayerList, LastGroup = {}, {}, nil
local function setFont(o, f)
    if IsValid(o) then o:SetFont(f) end
end

local function toUnixTime(val)
    if isnumber(val) then return val end
    if isstring(val) then
        local num = tonumber(val)
        if num then return num end
        return os.time(lia.time.toNumber(val))
    end
    return 0
end

local function buildPlayersUI(parent)
    parent:Clear()
    local list = parent:Add("DListView")
    list:Dock(FILL)
    list:AddColumn(L("name"))
    list:AddColumn(L("steamID"))
    list:AddColumn(L("group"))
    list:AddColumn(L("joinedOn"))
    list:AddColumn(L("lastJoin"))
    list:AddColumn(L("banned"))
    for _, v in ipairs(PlayerList) do
        local firstJoin = toUnixTime(v.firstJoin)
        local lastJoin = toUnixTime(v.lastJoin)
        local bannedText = v.banned == nil and "no" or v.banned and "Yes" or "No"
        local row = list:AddLine(v.name, v.id, v.group, firstJoin > 0 and os.date("%Y-%m-%d %H:%M:%S", firstJoin) or "", lastJoin > 0 and os.date("%Y-%m-%d %H:%M:%S", lastJoin) or "", bannedText)
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
    LastGroup = g
    local scroll = parent:Add("DScrollPanel")
    scroll:Dock(FILL)
    local btnBar = scroll:Add("DPanel")
    btnBar:Dock(TOP)
    btnBar:SetTall(36)
    btnBar:DockMargin(20, 20, 20, 12)
    btnBar.Paint = function() end
    local editable = not DefaultGroups[g]
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
    if not DefaultGroups[g] then
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
    for _, m in ipairs(PlayerList) do
        if m.group == g then memberNames[#memberNames + 1] = m.name ~= "" and m.name or m.id end
    end

    local memLbl = scroll:Add("DLabel")
    memLbl:Dock(TOP)
    memLbl:DockMargin(20, 0, 0, 6)
    memLbl:SetText(L("members", #memberNames))
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
    local catOrder = {}
    for cat in pairs(PrivilegeCategories) do
        catOrder[#catOrder + 1] = cat
    end

    table.sort(catOrder)
    for i, c in ipairs(catOrder) do
        if c == "Unassigned" then
            table.remove(catOrder, i)
            catOrder[#catOrder + 1] = c
            break
        end
    end

    for _, cat in ipairs(catOrder) do
        local collapse = vgui.Create("DCollapsibleCategory", list)
        collapse:SetLabel(L(cat) or cat)
        collapse:SetExpanded(false)
        collapse:Dock(TOP)
        collapse:DockMargin(0, 0, 0, 10)
        local catList = vgui.Create("DListLayout")
        collapse:SetContents(catList)
        for _, priv in ipairs(PrivilegeCategories[cat] or {}) do
            local row = vgui.Create("DPanel", catList)
            row:SetTall(rowH)
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 5)
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
    end

    list:InvalidateLayout(true)
    list:SizeToChildren(false, true)
    listHolder:SetTall(list:GetTall())
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
            Derma_Query(L("deleteGroupQuery", g), L("confirm"), L("yes"), function()
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
            LastGroup = txt
            net.Start("liaGroupsAdd")
            net.WriteString(txt)
            net.SendToServer()
        end)
    end

    if LastGroup and cami[LastGroup] then
        for _, b in ipairs(sidebar:GetChildren()) do
            if b.GetText and b:GetText() == LastGroup then
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
    PrivilegeCategories = tbl.privCategories or {}
    lia.admin.groups = tbl.perms or {}
    if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, tbl.cami or {}, lia.admin.groups) end
end

local function handlePlayerDone(id)
    local data = table.concat(playerChunks[id])
    playerChunks[id] = nil
    local tbl = util.JSONToTable(util.Decompress(data) or "") or {}
    PlayerList = tbl.players or {}
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

hook.Add("liaAdminRegisterTab", "AdminTabUsergroups", function(tabs)
    tabs["Usergroups"] = {
        icon = "icon16/group.png",
        onShouldShow = LocalPlayer():hasPrivilege("Access Usergroups Tab"),
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
        onShouldShow = LocalPlayer():hasPrivilege("Access Players Tab"),
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