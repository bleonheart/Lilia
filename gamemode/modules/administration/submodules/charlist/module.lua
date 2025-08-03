MODULE.name = L("characterList")
MODULE.author = "ChatGPT"
MODULE.desc = "Provides an in-game overview of characters"
MODULE.Privileges = {
    {
        Name = L("List Characters"),
        MinAccess = "admin",
        Category = L("categoryCharacter")
    }
}

if SERVER then
    net.Receive("liaRequestFullCharList", function(_, client)
        if not IsValid(client) or not client:hasPrivilege("List Characters") then return end
        lia.db.query("SELECT id, name, `desc`, faction, steamID, lastJoinTime, banned, playtime, money FROM lia_characters", function(data)
            local payload = {all = {}, players = {}}
            for _, row in ipairs(data or {}) do
                local stored = lia.char.loaded[row.id]
                local entry = {
                    ID = row.id,
                    Name = row.name,
                    Desc = row.desc,
                    Faction = row.faction,
                    SteamID = row.steamID,
                    LastUsed = stored and "Online" or row.lastJoinTime,
                    Banned = tonumber(row.banned) == 1,
                    PlayTime = tonumber(row.playtime) or 0,
                    Money = tonumber(row.money) or 0
                }
                hook.Run("CharListEntry", entry, row)
                payload.all[#payload.all + 1] = entry
                payload.players[row.steamID] = payload.players[row.steamID] or {}
                table.insert(payload.players[row.steamID], entry)
            end

            lia.net.writeBigTable(client, "liaFullCharList", payload)
        end)
    end)
else
    local panelRef

    lia.net.readBigTable("liaFullCharList", function(data)
        if not IsValid(panelRef) or not data then return end
        panelRef:buildSheets(data)
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege("List Characters") then return end
        table.insert(pages, {
            name = L("characterList"),
            drawFunc = function(panel)
                panelRef = panel
                panel:Clear()
                panel:DockPadding(10, 10, 10, 10)
                panel.Paint = function() end
                panel.sheet = panel:Add("DPropertySheet")
                panel.sheet:Dock(FILL)
                function panel:buildSheets(data)
                    -- Clear existing tabs without removing the tab scroller
                    for _, v in ipairs(self.sheet.Items or {}) do
                        if IsValid(v.Tab) then
                            self.sheet:CloseTab(v.Tab, true)
                        end
                    end
                    self.sheet.Items = {}

                    local function formatPlayTime(secs)
                        local h = math.floor(secs / 3600)
                        local m = math.floor((secs % 3600) / 60)
                        local s = secs % 60
                        return string.format("%02i:%02i:%02i", h, m, s)
                    end

                    local columns = {
                        {name = L("id"), field = "ID"},
                        {name = L("name"), field = "Name"},
                        {name = L("desc"), field = "Desc"},
                        {name = L("faction"), field = "Faction"},
                        {name = L("steamID"), field = "SteamID"},
                        {name = L("lastUsed"), field = "LastUsed"},
                        {name = L("banned"), field = "Banned", format = function(val) return val and L("yes") or L("no") end},
                        {name = L("playtime"), field = "PlayTime", format = function(val) return formatPlayTime(val or 0) end},
                        {name = L("money"), field = "Money", format = function(val) return lia.currency.get(tonumber(val) or 0) end}
                    }
                    hook.Run("CharListColumns", columns)

                    local function createList(parent, rows)
                        local container = parent:Add("DPanel")
                        container:Dock(FILL)
                        container.Paint = function() end
                        local search = container:Add("DTextEntry")
                        search:Dock(TOP)
                        search:SetPlaceholderText(L("search"))
                        search:SetTextColor(Color(255, 255, 255))
                        local list = container:Add("DListView")
                        list:Dock(FILL)
                        for _, col in ipairs(columns) do list:AddColumn(col.name) end

                        local function populate(filter)
                            list:Clear()
                            filter = string.lower(filter or "")
                            for _, row in ipairs(rows) do
                                local values = {}
                                for _, col in ipairs(columns) do
                                    local value = row[col.field]
                                    if col.format then value = col.format(value, row) end
                                    values[#values + 1] = value
                                end
                                local match = false
                                if filter == "" then
                                    match = true
                                else
                                    for _, value in ipairs(values) do
                                        if tostring(value):lower():find(filter, 1, true) then
                                            match = true
                                            break
                                        end
                                    end
                                end
                                if match then list:AddLine(unpack(values)) end
                            end
                        end

                        search.OnChange = function() populate(search:GetValue()) end
                        populate("")

                        function list:OnRowRightClick(_, line)
                            if not IsValid(line) then return end
                            local menu = DermaMenu()
                            menu:AddOption(L("copyRow"), function()
                                local rowString = ""
                                for i, column in ipairs(self.Columns or {}) do
                                    local header = column.Header and column.Header:GetText() or ("Column " .. i)
                                    local value = line:GetColumnText(i) or ""
                                    rowString = rowString .. header .. " " .. value .. " | "
                                end
                                SetClipboardText(string.sub(rowString, 1, -4))
                            end):SetIcon("icon16/page_copy.png")
                            menu:Open()
                        end
                    end

                    local allPanel = self.sheet:Add("DPanel")
                    allPanel:Dock(FILL)
                    allPanel.Paint = function() end
                    createList(allPanel, data.all or {})
                    self.sheet:AddSheet(L("allCharacters"), allPanel)

                    for steamID, chars in pairs(data.players or {}) do
                        local ply = lia.util.getBySteamID(steamID)
                        if IsValid(ply) then
                            local pnl = self.sheet:Add("DPanel")
                            pnl:Dock(FILL)
                            pnl.Paint = function() end
                            createList(pnl, chars)
                            self.sheet:AddSheet(ply:Nick(), pnl)
                        end
                    end
                end

                net.Start("liaRequestFullCharList")
                net.SendToServer()
            end
        })
    end
end

