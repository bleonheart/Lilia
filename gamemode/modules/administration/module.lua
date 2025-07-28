local MODULE = MODULE
MODULE.name = "Administration Utilities"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides a suite of administrative commands, configuration menus, and moderation utilities so staff can effectively manage the server."
-- Utility to determine how many columns a DListView line has. ``DListViewLine``
-- does not always implement a ``ColumnCount`` method, so this helper falls back
-- to counting the ``Columns`` table if needed.
local function getColumnCount(line)
    if isfunction(line.ColumnCount) then return line:ColumnCount() end
    return istable(line.Columns) and #line.Columns or 0
end

hook.Add("liaAdminRegisterTab", "liaStaffManagementTab", function(tabs)
    local ply = LocalPlayer()
    if not ply:hasPrivilege("View Staff Actions") then return end
    tabs[L("staffManagement")] = {
        icon = "icon16/chart_bar.png",
        build = function(sheet)
            local panel = vgui.Create("DPanel", sheet)
            panel:Dock(FILL)
            panel:DockPadding(10, 10, 10, 10)
            local search = panel:Add("DTextEntry")
            search:Dock(TOP)
            search:DockMargin(0, 0, 0, 5)
            search:SetPlaceholderText(L("search"))
            local list = vgui.Create("DListView", panel)
            list:Dock(FILL)
            list:AddColumn(L("adminName"))
            list:AddColumn(L("steamID"))
            list:AddColumn(L("userGroup"))
            list:AddColumn(L("staffAction"))
            list:AddColumn(L("staffActionCount"))
            MODULE.actionList = list
            local function filter()
                local q = search:GetValue():lower()
                for _, line in ipairs(list:GetLines()) do
                    local s = ""
                    for i = 1, getColumnCount(line) do
                        s = s .. line:GetColumnText(i):lower() .. " "
                    end

                    line:SetVisible(q == "" or s:find(q, 1, true))
                end

                list:InvalidateLayout()
            end

            search.OnChange = filter
            local oldAdd = list.AddLine
            function list:AddLine(...)
                local line = oldAdd(self, ...)
                filter()
                return line
            end

            list.OnRowRightClick = function(_, _, line)
                if not IsValid(line) then return end
                local m = DermaMenu()
                m:AddOption(L("copyRow"), function()
                    local s = ""
                    for i = 1, getColumnCount(line) do
                        s = s .. line:GetColumnText(i) .. " | "
                    end

                    SetClipboardText(s:sub(1, -4))
                end):SetIcon("icon16/page_copy.png")

                m:Open()
            end

            net.Start("RequestStaffActions")
            net.SendToServer()
            return panel
        end
    }

    tabs[L("warnings")] = {
        icon = "icon16/error.png",
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:Dock(FILL)
            pnl:DockPadding(10, 10, 10, 10)
            local search = pnl:Add("DTextEntry")
            search:Dock(TOP)
            search:DockMargin(0, 0, 0, 5)
            search:SetPlaceholderText(L("search"))
            local list = vgui.Create("DListView", pnl)
            list:Dock(FILL)
            list:AddColumn(L("player"))
            list:AddColumn(L("steamID"))
            list:AddColumn(L("admin"))
            list:AddColumn(L("steamID"))
            list:AddColumn(L("reason"))
            list:AddColumn(L("timestamp"))
            MODULE.warnList = list
            local function filter()
                local q = search:GetValue():lower()
                for _, line in ipairs(list:GetLines()) do
                    local s = ""
                    for i = 1, getColumnCount(line) do
                        s = s .. line:GetColumnText(i):lower() .. " "
                    end

                    line:SetVisible(q == "" or s:find(q, 1, true))
                end

                list:InvalidateLayout()
            end

            search.OnChange = filter
            local oldAdd = list.AddLine
            function list:AddLine(...)
                local line = oldAdd(self, ...)
                filter()
                return line
            end

            list.OnRowRightClick = function(_, _, line)
                if not IsValid(line) then return end
                local m = DermaMenu()
                m:AddOption(L("copyRow"), function()
                    local s = ""
                    for i = 1, getColumnCount(line) do
                        s = s .. line:GetColumnText(i) .. " | "
                    end

                    SetClipboardText(s:sub(1, -4))
                end):SetIcon("icon16/page_copy.png")

                m:Open()
            end

            net.Start("RequestPlayerWarnings")
            net.WriteString(LocalPlayer():SteamID())
            net.SendToServer()
            return pnl
        end
    }

    tabs[L("ticketsTab")] = {
        icon = "icon16/briefcase.png",
        build = function(sheet)
            local pnl = vgui.Create("DPanel", sheet)
            pnl:Dock(FILL)
            pnl:DockPadding(10, 10, 10, 10)
            local search = pnl:Add("DTextEntry")
            search:Dock(TOP)
            search:DockMargin(0, 0, 0, 5)
            search:SetPlaceholderText(L("search"))
            local list = vgui.Create("DListView", pnl)
            list:Dock(FILL)
            list:AddColumn(L("timestamp"))
            list:AddColumn(L("requester"))
            list:AddColumn(L("steamID"))
            list:AddColumn(L("admin"))
            list:AddColumn(L("steamID"))
            list:AddColumn(L("message"))
            MODULE.ticketList = list
            local function filter()
                local q = search:GetValue():lower()
                for _, line in ipairs(list:GetLines()) do
                    local s = ""
                    for i = 1, getColumnCount(line) do
                        s = s .. line:GetColumnText(i):lower() .. " "
                    end

                    line:SetVisible(q == "" or s:find(q, 1, true))
                end

                list:InvalidateLayout()
            end

            search.OnChange = filter
            local oldAdd = list.AddLine
            function list:AddLine(...)
                local line = oldAdd(self, ...)
                filter()
                return line
            end

            list.OnRowRightClick = function(_, _, line)
                if not IsValid(line) then return end
                local m = DermaMenu()
                m:AddOption(L("copyRow"), function()
                    local s = ""
                    for i = 1, getColumnCount(line) do
                        s = s .. line:GetColumnText(i) .. " | "
                    end

                    SetClipboardText(s:sub(1, -4))
                end):SetIcon("icon16/page_copy.png")

                m:Open()
            end

            net.Start("RequestTicketClaims")
            net.SendToServer()
            return pnl
        end
    }
end)

local function startSpectateView(ent, originalThirdPerson)
    local yaw = LocalPlayer():EyeAngles().yaw
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

hook.Add("liaAdminRegisterTab", "liaEntitiesAdminTab", function(tabs)
    local client = LocalPlayer()
    if not client:hasPrivilege("Access Entity List") then return end
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

            local hasEntities = false
            for _, list in pairs(entitiesByCreator) do
                if istable(list) and #list > 0 then
                    hasEntities = true
                    break
                end
            end

            if hasEntities then
                local sheetPanel = vgui.Create("DPropertySheet", panel)
                sheetPanel:Dock(FILL)
                sheetPanel:DockMargin(0, 0, 0, 10)
                for owner, list in SortedPairs(entitiesByCreator) do
                    local page = vgui.Create("DPanel", sheetPanel)
                    page:Dock(FILL)
                    page.Paint = function() end
                    local searchEntry = vgui.Create("DTextEntry", page)
                    searchEntry:Dock(TOP)
                    searchEntry:DockMargin(10, 0, 10, 5)
                    searchEntry:SetTall(30)
                    searchEntry:SetPlaceholderText(L("searchEntities"))
                    local scroll = vgui.Create("DScrollPanel", page)
                    scroll:Dock(FILL)
                    scroll:DockPadding(0, 0, 0, 10)
                    local canvas = scroll:GetCanvas()
                    local entries = {}
                    for _, ent in ipairs(list) do
                        local className = ent:GetClass()
                        local displayName = className
                        if className == "lia_item" or ent.isItem and ent:isItem() then
                            local itemTable = ent.getItemTable and ent:getItemTable()
                            if itemTable then displayName = itemTable.getName and itemTable:getName() or L(itemTable.name or className) end
                        end

                        local itemPanel = vgui.Create("DPanel", canvas)
                        itemPanel:Dock(TOP)
                        itemPanel:DockMargin(10, 15, 10, 10)
                        itemPanel:SetTall(100)
                        itemPanel.infoText = (displayName .. " " .. className):lower()
                        itemPanel.Paint = function(pnl, w, h)
                            derma.SkinHook("Paint", "Panel", pnl, w, h)
                            draw.SimpleText(displayName, "liaMediumFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end

                        local icon = vgui.Create("liaSpawnIcon", itemPanel)
                        icon:Dock(LEFT)
                        icon:SetWide(64)
                        icon:SetModel(ent:GetModel() or "models/error.mdl", ent:GetSkin() or 0)
                        local btnContainer = vgui.Create("DPanel", itemPanel)
                        btnContainer:Dock(RIGHT)
                        btnContainer.Paint = function() end
                        local btnW, btnH, margin, btnCount = 90, 30, 4, 0
                        if client:hasPrivilege("View Entity (Entity Tab)") then
                            local btnView = vgui.Create("liaSmallButton", btnContainer)
                            btnView:Dock(LEFT)
                            btnView:DockMargin(margin, 0, margin, 0)
                            btnView:SetWide(btnW)
                            btnView:SetTall(btnH)
                            btnView:SetText(L("view"))
                            btnView.DoClick = function()
                                if IsValid(lia.gui.menu) then lia.gui.menu:remove() end
                                local orig = lia.option.get("thirdPersonEnabled", false)
                                lia.option.set("thirdPersonEnabled", false)
                                startSpectateView(ent, orig)
                            end

                            btnCount = btnCount + 1
                        end

                        if client:hasPrivilege("Teleport to Entity (Entity Tab)") then
                            local btnTeleport = vgui.Create("liaSmallButton", btnContainer)
                            btnTeleport:Dock(LEFT)
                            btnTeleport:DockMargin(margin, 0, margin, 0)
                            btnTeleport:SetWide(btnW)
                            btnTeleport:SetTall(btnH)
                            btnTeleport:SetText(L("teleport"))
                            btnTeleport.DoClick = function()
                                net.Start("liaTeleportToEntity")
                                net.WriteEntity(ent)
                                net.SendToServer()
                            end

                            btnCount = btnCount + 1
                        end

                        local btnWaypoint = vgui.Create("liaSmallButton", btnContainer)
                        btnWaypoint:Dock(LEFT)
                        btnWaypoint:DockMargin(margin, 0, margin, 0)
                        btnWaypoint:SetWide(btnW)
                        btnWaypoint:SetTall(btnH)
                        btnWaypoint:SetText(L("waypointButton"))
                        btnWaypoint.DoClick = function() client:setWaypoint(displayName, ent:GetPos()) end
                        btnCount = btnCount + 1
                        btnContainer:SetWide(btnCount * (btnW + margin * 2))
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
            else
                local msg = vgui.Create("DLabel", panel)
                msg:Dock(FILL)
                msg:SetFont("liaMediumFont")
                msg:SetText("No player entities available")
                msg:SetContentAlignment(5)
            end
            return panel
        end
    }
end)

local CHUNK = 60000
local function buildDefaultTable(g)
    local t = {}
    if not (CAMI and CAMI.GetPrivileges and CAMI.UsergroupInherits) then return t end
    for _, v in pairs(CAMI.GetPrivileges() or {}) do
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
            Inherits = n == "developer" and "superadmin" or inh or "user"
        })
    end
end

local function dropCAMIGroup(n)
    if not (CAMI and CAMI.GetUsergroups and CAMI.UnregisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if g[n] then CAMI.UnregisterUsergroup(n) end
end

local function sendBigTable(ply, tbl, _strChunk, strDone)
    local id = lia.net.WriteBigTable(ply, tbl)
    if strDone then
        net.Start(strDone)
        net.WriteString(id)
        if IsEntity(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end
end

if SERVER then
    lia.administration.privileges = lia.administration.privileges or {}
    lia.administration.groups = lia.administration.groups or {}
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
                lastJoin = os.time(lia.time.toNumber(v.lastJoin)),
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
                    lastJoinTime = os.time(lia.time.toNumber(ply.lastJoin)),
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

    function lia.administration.syncAdminGroups(payload)
        lia.administration.groups = payload or lia.administration.groups
        lia.administration.updateAdminGroups()
    end

    syncPrivileges()
else
    local PRIV_LIST, PLAYER_LIST, LAST_GROUP = {}, {}, nil
    local CHAR_LISTS = {
        online = {},
        all = {}
    }

    local function setFont(o, f)
        if IsValid(o) then o:SetFont(f) end
    end

    local function buildPlayersUI(parent)
        parent:Clear()
        local search = parent:Add("DTextEntry")
        search:Dock(TOP)
        search:DockMargin(0, 0, 0, 5)
        search:SetPlaceholderText(L("search"))
        local list = parent:Add("DListView")
        list:Dock(FILL)
        list:AddColumn("Name")
        list:AddColumn("SteamID")
        list:AddColumn("Group")
        list:AddColumn("Last Join")
        list:AddColumn("Last Character")
        list:AddColumn("Banned")
        local function populate(q)
            list:Clear()
            q = q and q:lower() or ""
            for _, v in ipairs(PLAYER_LIST) do
                local join = v.lastJoin > 0 and os.date("%Y-%m-%d %H:%M:%S", v.lastJoin) or ""
                local text = (v.name .. " " .. v.id .. " " .. v.group .. " " .. join .. " " .. (v.lastChar or "") .. " " .. (v.banned and "yes" or "no")):lower()
                if q == "" or text:find(q, 1, true) then
                    local row = list:AddLine(v.name, v.id, v.group, join, v.lastChar or "", v.banned and "Yes" or "No")
                    row.steamID = v.id
                    row.steamID64 = v.id64
                    if v.banned then row:SetBGColor(Color(255, 120, 120)) end
                end
            end
        end

        populate()
        search.OnChange = function() populate(search:GetValue()) end
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.steamID then return end
            local m = DermaMenu()
            local opt = m:AddOption("View Character List", function() LocalPlayer():ConCommand("say /charlist " .. line.steamID) end)
            opt:SetIcon("icon16/user.png")
            m:AddOption(L("copyRow"), function()
                local s = ""
                for i = 1, getColumnCount(line) do
                    s = s .. line:GetColumnText(i) .. " | "
                end

                SetClipboardText(s:sub(1, -4))
            end):SetIcon("icon16/page_copy.png")

            m:Open()
        end
    end

    local function buildCharListUI(parent, mode, filterID)
        parent:Clear()
        local search = parent:Add("DTextEntry")
        search:Dock(TOP)
        search:DockMargin(0, 0, 0, 5)
        search:SetPlaceholderText(L("search"))
        local list = parent:Add("DListView")
        list:Dock(FILL)
        list:AddColumn("ID")
        list:AddColumn("Name")
        list:AddColumn("SteamID")
        list:AddColumn("Faction")
        list:AddColumn("Banned")
        list:AddColumn("Money")
        list:AddColumn("Last Used")
        local function populate(q)
            list:Clear()
            q = q and q:lower() or ""
            for _, v in ipairs(CHAR_LISTS[mode] or {}) do
                local sid = v.SteamID or v.steamID or ""
                local text = (tostring(v.ID) .. " " .. v.Name .. " " .. sid .. " " .. v.Faction .. " " .. tostring(v.Banned) .. " " .. tostring(v.Money) .. " " .. tostring(v.LastUsed)):lower()
                if (not filterID or tostring(sid) == tostring(filterID)) and (q == "" or text:find(q, 1, true)) then list:AddLine(v.ID, v.Name, util.SteamIDFrom64(tostring(sid)), v.Faction, v.Banned, v.Money, v.LastUsed) end
            end
        end

        populate()
        search.OnChange = function() populate(search:GetValue()) end
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) then return end
            local m = DermaMenu()
            m:AddOption(L("copyRow"), function()
                local s = ""
                for i = 1, getColumnCount(line) do
                    s = s .. line:GetColumnText(i) .. " | "
                end

                SetClipboardText(s:sub(1, -4))
            end):SetIcon("icon16/page_copy.png")

            m:Open()
        end
    end

    local function buildPlayerTabs(ps)
        if not IsValid(ps) then return end
        ps.playerTabs = ps.playerTabs or {}
        for _, info in pairs(ps.playerTabs) do
            if IsValid(info.tab) then ps:CloseTab(info.tab, true) end
        end

        ps.playerTabs = {}
        local byPlayer = {}
        for _, entry in ipairs(CHAR_LISTS.online or {}) do
            local sid = tostring(entry.SteamID or entry.steamID or "")
            byPlayer[sid] = byPlayer[sid] or {}
            table.insert(byPlayer[sid], entry)
        end

        for sid, _ in SortedPairs(byPlayer) do
            local page = vgui.Create("DPanel", ps)
            page:Dock(FILL)
            page.Paint = function() end
            local ply = player.GetBySteamID64(sid)
            local name = IsValid(ply) and ply:Nick() or util.SteamIDFrom64(sid)
            local sheetInfo = ps:AddSheet(name, page, "icon16/user.png")
            ps.playerTabs[sid] = {
                tab = sheetInfo.Tab,
                panel = page
            }

            buildCharListUI(page, "online", sid)
        end
    end

    local function renderGroupInfo(parent, g, cami, perms)
        parent:Clear()
        local scroll = parent:Add("DScrollPanel")
        scroll:Dock(FILL)
        local editable = not lia.administration.DefaultGroups[g]
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
    end

    local function buildGroupsUI(panel, cami, perms)
        panel:Clear()
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(0, 0, 0, 40)
        local keys, tabs = {}, {}
        local groupSource = next(cami) and cami or perms or {}
        PrintTable(groupSource, 1)
        for g in pairs(groupSource) do
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

        local bottomBar = panel:Add("DPanel")
        bottomBar:Dock(BOTTOM)
        bottomBar:SetTall(36)
        bottomBar.Paint = function() end
        local addBtn = bottomBar:Add("liaMediumButton")
        local renameBtn = bottomBar:Add("liaMediumButton")
        local delBtn = bottomBar:Add("liaMediumButton")
        addBtn:Dock(LEFT)
        renameBtn:Dock(LEFT)
        delBtn:Dock(LEFT)
        bottomBar.PerformLayout = function(_, w, _)
            local buttons = {}
            if addBtn:IsVisible() then buttons[#buttons + 1] = addBtn end
            if renameBtn:IsVisible() then buttons[#buttons + 1] = renameBtn end
            if delBtn:IsVisible() then buttons[#buttons + 1] = delBtn end
            local count = #buttons
            local spacing = 6
            local wide = count > 0 and (w - spacing * (count - 1)) / count or 0
            for i, btn in ipairs(buttons) do
                btn:SetWide(wide)
                if i < count then
                    btn:DockMargin(0, 0, spacing, 0)
                else
                    btn:DockMargin(0, 0, 0, 0)
                end
            end
        end

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

        renameBtn:SetText("Rename")
        delBtn:SetText("Delete")
        local function updateButtons(g)
            local editable = not lia.administration.DefaultGroups[g]
            renameBtn:SetVisible(editable)
            delBtn:SetVisible(editable)
            bottomBar:InvalidateLayout(true)
        end

        renameBtn.DoClick = function()
            local tab = sheet:GetActiveTab()
            if not IsValid(tab) then return end
            local g = tab:GetText()
            Derma_StringRequest("Rename Group", "New group name:", g, function(txt)
                if txt == "" or txt == g then return end
                net.Start("liaGroupsRename")
                net.WriteString(g)
                net.WriteString(txt)
                net.SendToServer()
            end)
        end

        delBtn.DoClick = function()
            local tab = sheet:GetActiveTab()
            if not IsValid(tab) then return end
            local g = tab:GetText()
            Derma_Query("Delete group '" .. g .. "'?", "Confirm", "Yes", function()
                net.Start("liaGroupsRemove")
                net.WriteString(g)
                net.SendToServer()
            end, "No")
        end

        function sheet:OnActiveTabChanged(old, new)
            if not IsValid(new) then return end
            LAST_GROUP = new:GetText()
            updateButtons(LAST_GROUP)
        end

        if LAST_GROUP and tabs[LAST_GROUP] then
            sheet:SetActiveTab(tabs[LAST_GROUP])
        elseif keys[1] and tabs[keys[1]] then
            sheet:SetActiveTab(tabs[keys[1]])
        end

        -- ensure buttons reflect editability of the initially selected group
        local active = sheet:GetActiveTab()
        if IsValid(active) then updateButtons(active:GetText()) end
    end

    local function handleGroupDone(tbl)
        PRIV_LIST = tbl.privCategories or {}
        lia.administration.groups = tbl.perms or {}
        if IsValid(lia.gui.usergroups) then buildGroupsUI(lia.gui.usergroups, tbl.cami or {}, lia.administration.groups) end
    end

    local function handlePlayerDone(tbl)
        PLAYER_LIST = tbl.players or {}
        if IsValid(lia.gui.players) then buildPlayersUI(lia.gui.players) end
    end

    local function handleCharBrowserDone(tbl)
        CHAR_LISTS[tbl.mode or "online"] = tbl.list or {}
        if tbl.mode == "all" and IsValid(lia.gui.charBrowserAll) then
            buildCharListUI(lia.gui.charBrowserAll, "all")
        elseif tbl.mode ~= "all" and IsValid(lia.gui.charBrowserOnline) then
            buildCharListUI(lia.gui.charBrowserOnline, "online")
            buildPlayerTabs(lia.gui.charBrowserPS)
        end
    end

    net.Receive("liaGroupsDataDone", function()
        local id = net.ReadString()
        hook.Add("LiaBigTableReceived", "liaGroups" .. id, function(receivedID, data)
            if receivedID ~= id then return end
            hook.Remove("LiaBigTableReceived", "liaGroups" .. id)
            handleGroupDone(data)
        end)
    end)

    net.Receive("liaPlayersDataDone", function()
        local id = net.ReadString()
        hook.Add("LiaBigTableReceived", "liaPlayers" .. id, function(receivedID, data)
            if receivedID ~= id then return end
            hook.Remove("LiaBigTableReceived", "liaPlayers" .. id)
            handlePlayerDone(data)
        end)
    end)

    net.Receive("liaCharBrowserDone", function()
        local id = net.ReadString()
        hook.Add("LiaBigTableReceived", "liaCharBrowser" .. id, function(receivedID, data)
            if receivedID ~= id then return end
            hook.Remove("LiaBigTableReceived", "liaCharBrowser" .. id)
            handleCharBrowserDone(data)
        end)
    end)

    local function canAccess()
        return IsValid(LocalPlayer()) and LocalPlayer():IsSuperAdmin() and LocalPlayer():hasPrivilege("Manage UserGroups")
    end

    hook.Add("liaAdminRegisterTab", "AdminTabUsergroups", function(tabs)
        if not canAccess() then return end
        tabs["Usergroups"] = {
            icon = "icon16/group.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.usergroups = pnl
                -- draw with any groups we already know about
                if lia and lia.administration and lia.administration.groups then buildGroupsUI(pnl, {}, lia.administration.groups) end
                net.Start("liaGroupsRequest")
                net.SendToServer()
                return pnl
            end
        }
    end)

    hook.Add("liaAdminRegisterTab", "AdminTabPlayers", function(tabs)
        if not canAccess() then return end
        tabs["Players"] = {
            icon = "icon16/user.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.players = pnl
                if istable(PLAYER_LIST) then buildPlayersUI(pnl) end
                net.Start("liaPlayersRequest")
                net.SendToServer()
                return pnl
            end
        }
    end)

    hook.Add("liaAdminRegisterTab", "AdminTabCharBrowser", function(tabs)
        if not canAccess() then return end
        tabs["Character List"] = {
            icon = "icon16/table.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                local ps = pnl:Add("DPropertySheet")
                ps:Dock(FILL)
                lia.gui.charBrowserPS = ps
                local all = vgui.Create("DPanel", ps)
                all:Dock(FILL)
                all.Paint = function() end
                lia.gui.charBrowserAll = all
                ps:AddSheet("All Characters", all, "icon16/database.png")
                buildCharListUI(all, "all")
                local online = vgui.Create("DPanel", ps)
                online:Dock(FILL)
                online.Paint = function() end
                lia.gui.charBrowserOnline = online
                buildCharListUI(online, "online")
                buildPlayerTabs(ps)
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

    hook.Add("liaAdminRegisterTab", "AdminTabDBBrowser", function(tabs)
        if not canAccess() or not LocalPlayer():hasPrivilege("View DB Tables") then return end
        tabs["Database View"] = {
            icon = "icon16/database.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                local ps = vgui.Create("DPropertySheet", pnl)
                ps:Dock(FILL)
                lia.gui.dbBrowserPS = ps
                net.Start("liaDBTablesRequest")
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
            hook.Run("liaAdminRegisterTab", reg)
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
        MinAccess = pv.MinAccess or "user",
        Category = pv.Category or "Unassigned"
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