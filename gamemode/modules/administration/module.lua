MODULE.name = "Administration Utilities"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides a suite of administrative commands, configuration menus, and moderation utilities so staff can effectively manage the server."
MODULE.Privileges = {
    {
        Name = "Can Remove Warns",
        MinAccess = "superadmin"
    },
    {
        Name = "Manage Prop Blacklist",
        MinAccess = "superadmin"
    },
    {
        Name = "Access Configuration Menu",
        MinAccess = "superadmin"
    },
    {
        Name = "Access Edit Configuration Menu",
        MinAccess = "superadmin"
    },
    {
        Name = "Manage UserGroups",
        MinAccess = "superadmin"
    }
}

hook.Add("liaAdminRegisterTab", "liaEntitiesAdminTab", function(parent, tabs)
    local client = LocalPlayer()
    if not client:hasPrivilege("Staff Permission — Access Entity List") then return end
    tabs[L("entities")] = {
        icon = "icon16/bricks.png",
        build = function(sheet)
            local panel = vgui.Create("DPanel", sheet)
            panel:Dock(FILL)
            panel.Paint = function() end
            local entitiesByCreator = {}
            for _, ent in ents.Iterator() do
                if IsValid(ent) and ent.GetCreator and IsValid(ent:GetCreator()) then
                    local owner = ent:GetCreator():Nick()
                    entitiesByCreator[owner] = entitiesByCreator[owner] or {}
                    table.insert(entitiesByCreator[owner], ent)
                end
            end

            local lastModelFrame
            local function startSpectateView(ent, originalThirdPerson)
                local yaw = client:EyeAngles().yaw
                local camZOffset = 50
                hook.Add("CalcView", "EntityViewCalcView", function()
                    return {
                        origin = ent:GetPos() + Angle(0, yaw, 0):Forward() * 100 + Vector(0, 0, camZOffset),
                        angles = Angle(0, yaw, 0),
                        fov = 60
                    }
                end)

                hook.Add("HUDPaint", "EntityViewHUD", function() draw.SimpleText(L("pressInstructions"), "liaMediumFont", ScrW() / 2, ScrH() - 50, color_white, TEXT_ALIGN_CENTER) end)
                hook.Add("Think", "EntityViewRotate", function()
                    if input.IsKeyDown(KEY_A) then yaw = yaw - FrameTime() * 100 end
                    if input.IsKeyDown(KEY_D) then yaw = yaw + FrameTime() * 100 end
                    if input.IsKeyDown(KEY_W) then camZOffset = camZOffset + FrameTime() * 100 end
                    if input.IsKeyDown(KEY_S) then camZOffset = camZOffset - FrameTime() * 100 end
                    if input.IsKeyDown(KEY_SPACE) then
                        hook.Remove("CalcView", "EntityViewCalcView")
                        hook.Remove("HUDPaint", "EntityViewHUD")
                        hook.Remove("Think", "EntityViewRotate")
                        hook.Remove("CreateMove", "EntitySpectateCreateMove")
                        lia.option.set("thirdPersonEnabled", originalThirdPerson)
                    end
                end)

                hook.Add("CreateMove", "EntitySpectateCreateMove", function(cmd)
                    cmd:SetForwardMove(0)
                    cmd:SetSideMove(0)
                    cmd:SetUpMove(0)
                end)
            end

            if not table.IsEmpty(entitiesByCreator) then
                local sheetPanel = vgui.Create("DPropertySheet", panel)
                sheetPanel:Dock(FILL)
                sheetPanel:DockMargin(0, 0, 0, 10)
                for owner, list in SortedPairs(entitiesByCreator) do
                    local page = vgui.Create("DPanel", sheetPanel)
                    page:Dock(FILL)
                    page.Paint = function() end
                    local searchEntry = vgui.Create("DTextEntry", page)
                    searchEntry:Dock(TOP)
                    searchEntry:DockMargin(0, 0, 0, 5)
                    searchEntry:SetTall(30)
                    searchEntry:SetPlaceholderText(L("searchEntities"))
                    local infoPanel = vgui.Create("DPanel", page)
                    infoPanel:Dock(TOP)
                    infoPanel:DockMargin(10, 0, 10, 5)
                    infoPanel:SetTall(30)
                    infoPanel.Paint = function(_, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 200)) end
                    local infoLabel = vgui.Create("DLabel", infoPanel)
                    infoLabel:Dock(FILL)
                    infoLabel:SetFont("liaSmallFont")
                    infoLabel:SetTextColor(color_white)
                    infoLabel:SetContentAlignment(5)
                    infoLabel:SetText(L("totalPlayerEntities", #list))
                    local scroll = vgui.Create("DScrollPanel", page)
                    scroll:Dock(FILL)
                    scroll:DockPadding(0, 0, 0, 10)
                    local canvas = scroll:GetCanvas()
                    local entries = {}
                    for _, ent in ipairs(list) do
                        local className = ent:GetClass()
                        local itemPanel = vgui.Create("DPanel", canvas)
                        itemPanel:Dock(TOP)
                        itemPanel:DockMargin(10, 15, 10, 10)
                        itemPanel:SetTall(100)
                        itemPanel.infoText = className:lower()
                        itemPanel.Paint = function(pnl, w, h)
                            derma.SkinHook("Paint", "Panel", pnl, w, h)
                            draw.SimpleText(className, "liaMediumFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end

                        local icon = vgui.Create("liaSpawnIcon", itemPanel)
                        icon:Dock(LEFT)
                        icon:SetWide(64)
                        icon:SetModel(ent:GetModel() or "models/error.mdl", ent:GetSkin() or 0)
                        icon.DoClick = function()
                            if IsValid(lastModelFrame) then lastModelFrame:Close() end
                            lastModelFrame = vgui.Create("DFrame")
                            lastModelFrame:SetTitle(className)
                            lastModelFrame:SetSize(800, 800)
                            lastModelFrame:Center()
                            lastModelFrame:MakePopup()
                            local infoLabel2 = vgui.Create("DLabel", lastModelFrame)
                            infoLabel2:SetText(L("pressInstructions"))
                            infoLabel2:SetFont("liaMediumFont")
                            infoLabel2:SizeToContents()
                            infoLabel2:Dock(TOP)
                            infoLabel2:DockMargin(0, 10, 0, 0)
                            infoLabel2:SetContentAlignment(5)
                            local modelPanel = vgui.Create("DModelPanel", lastModelFrame)
                            modelPanel:Dock(FILL)
                            modelPanel:SetModel(ent:GetModel() or "models/error.mdl", ent:GetSkin() or 0)
                            modelPanel:SetFOV(45)
                            local mn, mx = modelPanel.Entity:GetRenderBounds()
                            local size = math.max(math.abs(mn.x) + math.abs(mx.x), math.abs(mn.y) + math.abs(mx.y), math.abs(mn.z) + math.abs(mx.z))
                            modelPanel:SetCamPos(Vector(size, size, size))
                            modelPanel:SetLookAt((mn + mx) * 0.5)
                            local orig = lia.option.get("thirdPersonEnabled", false)
                            lia.option.set("thirdPersonEnabled", false)
                            startSpectateView(ent, orig)
                        end

                        local btnContainer = vgui.Create("DPanel", itemPanel)
                        btnContainer:Dock(RIGHT)
                        btnContainer:SetWide(380)
                        btnContainer.Paint = function() end
                        local btnW, btnH = 120, 40
                        if client:hasPrivilege("Staff Permission — View Entity (Entity Tab)") then
                            local btnView = vgui.Create("liaSmallButton", btnContainer)
                            btnView:Dock(LEFT)
                            btnView:DockMargin(5, 0, 5, 0)
                            btnView:SetWide(btnW)
                            btnView:SetTall(btnH)
                            btnView:SetText(L("view"))
                            btnView.DoClick = function()
                                if IsValid(lia.gui.menu) then lia.gui.menu:remove() end
                                local orig = lia.option.get("thirdPersonEnabled", false)
                                lia.option.set("thirdPersonEnabled", false)
                                startSpectateView(ent, orig)
                            end
                        end

                        if client:hasPrivilege("Staff Permission — Teleport to Entity (Entity Tab)") then
                            local btnTeleport = vgui.Create("liaSmallButton", btnContainer)
                            btnTeleport:Dock(LEFT)
                            btnTeleport:DockMargin(5, 0, 5, 0)
                            btnTeleport:SetWide(btnW)
                            btnTeleport:SetTall(btnH)
                            btnTeleport:SetText(L("teleport"))
                            btnTeleport.DoClick = function()
                                net.Start("liaTeleportToEntity")
                                net.WriteEntity(ent)
                                net.SendToServer()
                            end
                        end

                        local btnWaypoint = vgui.Create("liaSmallButton", btnContainer)
                        btnWaypoint:Dock(RIGHT)
                        btnWaypoint:DockMargin(5, 0, 5, 0)
                        btnWaypoint:SetWide(btnW)
                        btnWaypoint:SetTall(btnH)
                        btnWaypoint:SetText(L("waypointButton"))
                        btnWaypoint.DoClick = function() client:setWaypoint(className, ent:GetPos()) end
                        entries[#entries + 1] = itemPanel
                    end

                    searchEntry.OnTextChanged = function(entry)
                        local q = entry:GetValue():lower()
                        for _, pnl in ipairs(entries) do
                            pnl:SetVisible(q == "" or pnl.infoText:find(q, 1, true))
                        end

                        canvas:InvalidateLayout()
                        canvas:SizeToChildren(false, true)
                    end

                    sheetPanel:AddSheet(owner .. " - " .. #list .. " " .. L("entities"), page)
                end
            end
            return panel
        end
    }
end)

local DEFAULT_GROUPS = {
    user = true,
    admin = true,
    superadmin = true
}

local CHUNK = 60000
local function buildDefaultTable(g)
    local t = {}
    if not (CAMI and CAMI.GetPrivileges and CAMI.UsergroupInherits) then return t end
    for _, v in pairs(CAMI.GetPrivileges() or {}) do
        if CAMI.UsergroupInherits(g, v.MinAccess or "user") then
            t[v.Name] = true
        end
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
    util.AddNetworkString("liaCharBrowserRequest")
    util.AddNetworkString("liaCharBrowserChunk")
    util.AddNetworkString("liaCharBrowserDone")
    lia.administration.privileges = lia.administration.privileges or {}
    lia.administration.groups = lia.administration.groups or {}
    lia.administration.lastJoin = lia.administration.lastJoin or {}
    local function syncPrivileges()
        if not (CAMI and CAMI.GetPrivileges and CAMI.GetUsergroups) then return end
        for _, v in pairs(CAMI.GetPrivileges() or {}) do
            lia.administration.privileges[v.Name] = {
                Name = v.Name,
                MinAccess = v.MinAccess or "user",
                Category = v.Category or "Unassigned"
            }
        end

        for n, d in pairs(CAMI.GetUsergroups() or {}) do
            lia.administration.groups[n] = lia.administration.groups[n] or buildDefaultTable(n)
            ensureCAMIGroup(n, d.Inherits or "user")
        end
    end

    local function allowed(p)
        return IsValid(p) and p:IsSuperAdmin() or p:hasPrivilege("Manage UserGroups")
    end

    local function getPrivList()
        local cats = {}
        for n, v in pairs(lia.administration.privileges) do
            local cat = v.Category or "Unassigned"
            cats[cat] = cats[cat] or {}
            table.insert(cats[cat], n)
        end

        for _, list in pairs(cats) do
            table.sort(list)
        end

        return cats
    end

    local function payloadGroups()
        return {
            cami = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups() or {},
            perms = lia.administration.groups or {},
            privCategories = getPrivList()
        }
    end

    local function getBanList()
        local t = {}
        local query = "SELECT steamID FROM lia_players WHERE banStart > 0"
        if lia.db.module == "mysqloo" and mysqloo and lia.db.getObject then
            local db = lia.db.getObject()
            if not db then return t end
            local q = db:query(query)
            q:start()
            q:wait()
            if not q:error() then
                for _, row in ipairs(q:getData() or {}) do
                    t[row.steamID] = true
                end
            end
        else
            local data = lia.db.querySync(query)
            if istable(data) then
                for _, row in ipairs(data) do
                    t[row.steamID] = true
                end
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

    local function buildCharEntry(client, row)
        local stored = lia.char.loaded[row.id]
        local info = stored and stored:getData() or lia.char.getCharData(row.id) or {}
        local isBanned = stored and stored:getBanned() or row.banned
        local allVars = {}
        for varName, varInfo in pairs(lia.char.vars) do
            local value
            if stored then
                if varName == "data" then
                    value = stored:getData()
                elseif varName == "var" then
                    value = stored:getVar()
                else
                    local getter = stored["get" .. varName:sub(1, 1):upper() .. varName:sub(2)]
                    if isfunction(getter) then
                        value = getter(stored)
                    else
                        value = stored.vars and stored.vars[varName]
                    end
                end
            else
                if varName == "data" then
                    value = info
                elseif varInfo.field and row[varInfo.field] ~= nil then
                    local raw = row[varInfo.field]
                    if isnumber(varInfo.default) then
                        value = tonumber(raw) or varInfo.default
                    elseif isbool(varInfo.default) then
                        value = tobool(raw)
                    elseif istable(varInfo.default) then
                        value = util.JSONToTable(raw or "{}")
                    else
                        value = raw
                    end
                else
                    value = varInfo.default
                end
            end

            allVars[varName] = value
        end

        local lastUsedText
        if stored then
            lastUsedText = L("onlineNow")
        else
            lastUsedText = row.lastJoinTime
        end

        local bannedState = false
        if isBanned then
            local num = tonumber(isBanned)
            if num then
                bannedState = num == 1 or num > os.time()
            else
                bannedState = tobool(isBanned)
            end
        end

        local entry = {
            ID = row.id,
            Name = row.name,
            Desc = row.desc,
            Faction = row.faction,
            SteamID = row.steamID,
            Banned = bannedState and "Yes" or "No",
            BanningAdminName = info.charBanInfo and info.charBanInfo.name or "",
            BanningAdminSteamID = info.charBanInfo and info.charBanInfo.steamID or "",
            BanningAdminRank = info.charBanInfo and info.charBanInfo.rank or "",
            Money = row.money,
            LastUsed = lastUsedText,
            allVars = allVars
        }

        entry.extraDetails = {}
        hook.Run("CharListExtraDetails", client, entry, stored)
        return entry
    end

    local function collectOnlineCharacters(client, callback)
        local rows = {}
        for _, ply in player.Iterator() do
            local char = ply:getChar()
            if char then
                rows[#rows + 1] = {
                    id = char:getID(),
                    name = char:getName(),
                    desc = char:getDesc(),
                    faction = char:getFaction(),
                    money = char:getMoney(),
                    banned = char:getBanned(),
                    lastJoinTime = lia.administration.lastJoin[ply:SteamID()] or os.time(),
                    steamID = ply:SteamID64()
                }
            end
        end

        local sendData = {}
        for _, row in ipairs(rows) do
            sendData[#sendData + 1] = buildCharEntry(client, row)
        end

        callback(sendData)
    end

    local function queryAllCharacters(client, callback)
        lia.db.query("SELECT * FROM lia_characters", function(data)
            local sendData = {}
            for _, row in ipairs(data or {}) do
                sendData[#sendData + 1] = buildCharEntry(client, row)
            end
            callback(sendData)
        end)
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

    net.Receive("liaCharBrowserRequest", function(_, p)
        if not allowed(p) then return end
        local mode = net.ReadString()
        if mode == "all" then
            queryAllCharacters(p, function(data)
                sendBigTable(p, {mode = "all", list = data}, "liaCharBrowserChunk", "liaCharBrowserDone")
            end)
        else
            collectOnlineCharacters(p, function(data)
                sendBigTable(p, {mode = "online", list = data}, "liaCharBrowserChunk", "liaCharBrowserDone")
            end)
        end
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
    local groupChunks, playerChunks, charChunks = {}, {}, {}
    local PRIV_LIST, PLAYER_LIST, LAST_GROUP = {}, {}, nil
    local CHAR_LISTS = {online = {}, all = {}}
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

    local function buildCharListUI(parent, mode)
        parent:Clear()
        local list = parent:Add("DListView")
        list:Dock(FILL)
        list:AddColumn("ID")
        list:AddColumn("Name")
        list:AddColumn("SteamID")
        list:AddColumn("Faction")
        list:AddColumn("Banned")
        list:AddColumn("Money")
        list:AddColumn("Last Used")
        for _, v in ipairs(CHAR_LISTS[mode] or {}) do
            local sid = v.SteamID or v.steamID or ""
            list:AddLine(v.ID, v.Name, util.SteamIDFrom64(tostring(sid)), v.Faction, v.Banned, v.Money, v.LastUsed)
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
        local catNames = {}
        for cat in pairs(PRIV_LIST) do
            catNames[#catNames + 1] = cat
        end
        table.sort(catNames)
        for _, catName in ipairs(catNames) do
            local displayName = catName
            if catName == "Unassigned" then displayName = L("unassignedLabel") end
            local cat = list:Add("DCollapsibleCategory")
            cat:SetLabel(displayName)
            cat:SetExpanded(true)
            cat.Header:SetTall(rowH)
            cat.Header:SetFont("liaMediumFont")
            local catList = vgui.Create("DListLayout", cat)
            cat:SetContents(catList)
            for _, priv in ipairs(PRIV_LIST[catName]) do
                local row = vgui.Create("DPanel", catList)
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
        end

        list:InvalidateLayout(true)
        listHolder:SetTall(list:GetTall())

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
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(0, 0, 0, 40)

        local keys, tabs = {}, {}
        for g in pairs(cami) do
            keys[#keys + 1] = g
        end

        table.sort(keys)
        for _, g in ipairs(keys) do
            local page = vgui.Create("DPanel", sheet)
            page:Dock(FILL)
            page.Paint = function() end
            renderGroupInfo(page, g, cami, perms)
            local info = sheet:AddSheet(g, page)
            tabs[g] = info.Tab
        end

        local addBtn = panel:Add("liaMediumButton")
        addBtn:Dock(BOTTOM)
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

        if LAST_GROUP and tabs[LAST_GROUP] then
            sheet:SetActiveTab(tabs[LAST_GROUP])
        elseif keys[1] and tabs[keys[1]] then
            sheet:SetActiveTab(tabs[keys[1]])
        end
    end

    local function handleGroupDone(id)
        local data = table.concat(groupChunks[id])
        groupChunks[id] = nil
        local tbl = util.JSONToTable(util.Decompress(data) or "") or {}
        PRIV_LIST = tbl.privCategories or {}
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

    local function handleCharBrowserDone(id)
        local data = table.concat(charChunks[id])
        charChunks[id] = nil
        local tbl = util.JSONToTable(util.Decompress(data) or "") or {}
        CHAR_LISTS[tbl.mode or "online"] = tbl.list or {}
        if tbl.mode == "all" and IsValid(lia.gui.charBrowserAll) then
            buildCharListUI(lia.gui.charBrowserAll, "all")
        elseif tbl.mode ~= "all" and IsValid(lia.gui.charBrowserOnline) then
            buildCharListUI(lia.gui.charBrowserOnline, "online")
        end
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

    net.Receive("liaCharBrowserChunk", function()
        local id = net.ReadString()
        local idx = net.ReadUInt(16)
        local total = net.ReadUInt(16)
        local len = net.ReadUInt(16)
        local dat = net.ReadData(len)
        charChunks[id] = charChunks[id] or {}
        charChunks[id][idx] = dat
        if idx == total then handleCharBrowserDone(id) end
    end)

    net.Receive("liaCharBrowserDone", function()
        local id = net.ReadString()
        if charChunks[id] then handleCharBrowserDone(id) end
    end)

    net.Receive("liaGroupsNotice", function()
        local msg = net.ReadString()
        if IsValid(LocalPlayer()) and LocalPlayer().notify then LocalPlayer():notify(msg) end
    end)

    local function canAccess()
        return IsValid(LocalPlayer()) and LocalPlayer():IsSuperAdmin() and LocalPlayer():hasPrivilege("Manage UserGroups")
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

    hook.Add("liaAdminRegisterTab", "AdminTabCharBrowser", function(parent, tabs)
        if not canAccess() then return end
        tabs["Char Browser"] = {
            icon = "icon16/table.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                local ps = pnl:Add("DPropertySheet")
                ps:Dock(FILL)
                local online = vgui.Create("DPanel", ps)
                online:Dock(FILL)
                online.Paint = function() end
                lia.gui.charBrowserOnline = online
                ps:AddSheet("By Player Online", online, "icon16/user.png")
                buildCharListUI(online, "online")
                local all = vgui.Create("DPanel", ps)
                all:Dock(FILL)
                all.Paint = function() end
                lia.gui.charBrowserAll = all
                ps:AddSheet("All Characters", all, "icon16/database.png")
                buildCharListUI(all, "all")
                net.Start("liaCharBrowserRequest")
                net.WriteString("online")
                net.SendToServer()
                net.Start("liaCharBrowserRequest")
                net.WriteString("all")
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
            local reg = {}
            hook.Run("liaAdminRegisterTab", parent, reg)
            for name, data in SortedPairs(reg) do
                local pnl = data.build(sheet)
                sheet:AddSheet(name, pnl, data.icon or "icon16/application.png")
            end
        end
    end
end

hook.Add("CAMI.OnUsergroupRegistered", "liaSyncAdminGroupAdd", function(g)
    lia.administration.groups[g.Name] = buildDefaultTable(g.Name)
    if SERVER then
        ensureCAMIGroup(g.Name, g.Inherits or "user")
        lia.administration.save(true)
    end
end)

hook.Add("CAMI.OnUsergroupUnregistered", "liaSyncAdminGroupRemove", function(g)
    lia.administration.groups[g.Name] = nil
    if SERVER then
        dropCAMIGroup(g.Name)
        lia.administration.save(true)
    end
end)

hook.Add("CAMI.OnPrivilegeRegistered", "liaSyncAdminPrivilegeAdd", function(pv)
    if not pv or not pv.Name then return end
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
    if not pv or not pv.Name then return end
    lia.administration.privileges[pv.Name] = nil
    for _, p in pairs(lia.administration.groups) do
        p[pv.Name] = nil
    end

    if SERVER then lia.administration.save(true) end
end)

hook.Add("CAMI.PlayerUsergroupChanged", "liaSyncAdminPlayerGroup", function(ply, old, new)
    if not IsValid(ply) then return end
    if not SERVER then return end
    lia.db.query(string.format("UPDATE lia_players SET userGroup = '%s' WHERE steamID = %s", lia.db.escape(new), ply:SteamID64()))
end)