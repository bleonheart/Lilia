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
        lia.db.query("SELECT id, name, `desc`, faction, steamID, lastJoinTime, banned FROM lia_characters", function(data)
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
                    Banned = tonumber(row.banned) == 1
                }
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
                    self.sheet:Clear()
                    local columns = {
                        {name = L("id"), field = "ID"},
                        {name = L("name"), field = "Name"},
                        {name = L("desc"), field = "Desc"},
                        {name = L("faction"), field = "Faction"},
                        {name = L("steamID"), field = "SteamID"},
                        {name = L("lastUsed"), field = "LastUsed"},
                        {name = L("banned"), field = "Banned"}
                    }

                    local function createList(parent, rows)
                        local list = parent:Add("DListView")
                        list:Dock(FILL)
                        for _, col in ipairs(columns) do list:AddColumn(col.name) end
                        for _, row in ipairs(rows) do
                            list:AddLine(row.ID, row.Name, row.Desc, row.Faction, row.SteamID, row.LastUsed, row.Banned and L("yes") or L("no"))
                        end
                    end

                    local allPanel = self.sheet:Add("DPanel")
                    allPanel:Dock(FILL)
                    allPanel.Paint = function() end
                    createList(allPanel, data.all or {})
                    self.sheet:AddSheet(L("allCharacters"), allPanel)

                    for steamID, chars in pairs(data.players or {}) do
                        local pnl = self.sheet:Add("DPanel")
                        pnl:Dock(FILL)
                        pnl.Paint = function() end
                        createList(pnl, chars)
                        local ply = player.GetBySteamID64(steamID)
                        local title = IsValid(ply) and ply:Nick() or steamID
                        self.sheet:AddSheet(title, pnl)
                    end
                end

                net.Start("liaRequestFullCharList")
                net.SendToServer()
            end
        })
    end
end

