MODULE.name = L("modulePlayerListName")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("modulePlayerListDesc")
MODULE.Privileges = {
    {
        Name = L("canAccessPlayerList"),
        MinAccess = "admin",
        Category = L("players")
    }
}
if CLIENT then
    local panelRef
    local charMenuContext
    local function requestPlayerCharacters(steamID, line, buildMenu)
        charMenuContext = {
            pos = {gui.MousePos()},
            line = line,
            steamID = steamID,
            buildMenu = buildMenu
        }

        net.Start("liaRequestPlayerCharacters")
        net.WriteString(steamID)
        net.SendToServer()
    end

    lia.net.readBigTable("liaPlayerCharacters", function(data)
        if not data or not charMenuContext then return end
        local menu = DermaMenu()
        if charMenuContext.buildMenu then charMenuContext.buildMenu(menu, charMenuContext.line, data.steamID, data.characters or {}) end
        if charMenuContext.pos then
            menu:Open(charMenuContext.pos[1], charMenuContext.pos[2])
        else
            menu:Open()
        end

        charMenuContext = nil
    end)

    local function formatDHM(seconds)
        seconds = math.max(seconds or 0, 0)
        local days = math.floor(seconds / 86400)
        seconds = seconds % 86400
        local hours = math.floor(seconds / 3600)
        seconds = seconds % 3600
        local minutes = math.floor(seconds / 60)
        return L("daysHoursMinutes", days, hours, minutes)
    end

    lia.net.readBigTable("liaAllPlayers", function(players)
        if not IsValid(panelRef) then return end
        panelRef:Clear()
        local search = panelRef:Add("DTextEntry")
        search:Dock(TOP)
        search:SetPlaceholderText(L("search"))
        search:SetTextColor(Color(255, 255, 255))
        local list = panelRef:Add("DListView")
        list:Dock(FILL)
        local function addSizedColumn(text)
            local col = list:AddColumn(text)
            surface.SetFont(col.Header:GetFont())
            local w = surface.GetTextSize(col.Header:GetText())
            col:SetMinWidth(w + 16)
            col:SetWidth(w + 16)
            return col
        end

        addSizedColumn(L("steamName"))
        addSizedColumn(L("steamID"))
        addSizedColumn(L("usergroup"))
        addSizedColumn(L("firstJoin"))
        addSizedColumn(L("lastOnline"))
        addSizedColumn(L("playtime"))
        addSizedColumn(L("characters"))
        addSizedColumn(L("warnings"))
        local function populate(filter)
            list:Clear()
            filter = string.lower(filter or "")
            for _, v in ipairs(players or {}) do
                local steamName = v.steamName or ""
                local steamID = v.steamID or ""
                local userGroup = v.userGroup or ""
                local ply = player.GetBySteamID(steamID)
                local lastOnlineText
                if IsValid(ply) then
                    lastOnlineText = L("onlineNow")
                else
                    local last = tonumber(v.lastOnline)
                    if last and last > 0 then
                        local lastDiff = os.time() - last
                        local timeSince = lia.time.TimeSince(last)
                        local timeStripped = timeSince:match("^(.-)%sago$") or timeSince
                        lastOnlineText = L("agoFormat", timeStripped, formatDHM(lastDiff))
                    else
                        lastOnlineText = L("unknown")
                    end
                end

                local playtime
                if IsValid(ply) then
                    playtime = formatDHM(ply:getPlayTime())
                else
                    playtime = formatDHM(tonumber(v.totalOnlineTime) or 0)
                end
                local charCount = tonumber(v.characterCount) or 0
                local warnings = tonumber(v.warnings) or 0
                local ticketRequests = tonumber(v.ticketsRequested) or 0
                local ticketClaims = tonumber(v.ticketsClaimed) or 0
                if filter == "" or steamName:lower():find(filter, 1, true) or steamID:lower():find(filter, 1, true) or userGroup:lower():find(filter, 1, true) then
                    local line = list:AddLine(steamName, steamID, userGroup, v.firstJoin or L("unknown"), lastOnlineText, playtime, charCount, warnings)
                    line.steamID = v.steamID
                    line.ticketRequests = ticketRequests
                    line.ticketClaims = ticketClaims
                end
            end
        end

        search.OnChange = function() populate(search:GetValue()) end
        populate("")
        function list:OnRowRightClick(_, line)
            if not IsValid(line) or not line.steamID then return end
            local parentList = self
            requestPlayerCharacters(line.steamID, line, function(menu, ln, steamID, characters)
                menu:AddOption(L("viewCharacterList"), function() LocalPlayer():ConCommand("say /charlist " .. steamID) end):SetIcon("icon16/page_copy.png")
                menu:AddOption(L("copyRow"), function()
                    local rowString = ""
                    for i, column in ipairs(parentList.Columns or {}) do
                        local header = column.Header and column.Header:GetText() or L("columnWithNumber", i)
                        local value = ln:GetColumnText(i) or ""
                        rowString = rowString .. header .. " " .. value .. " | "
                    end

                    SetClipboardText(string.sub(rowString, 1, -4))
                end):SetIcon("icon16/page_copy.png")

                menu:AddOption(L("copySteamID"), function() SetClipboardText(steamID) end):SetIcon("icon16/page_copy.png")
                menu:AddOption(L("openSteamProfile"), function() gui.OpenURL("https://steamcommunity.com/profiles/" .. util.SteamIDTo64(steamID)) end):SetIcon("icon16/world.png")
                menu:AddOption(L("viewWarnings"), function() LocalPlayer():ConCommand("say /viewwarns " .. steamID) end):SetIcon("icon16/error.png")
                menu:AddOption(L("viewTicketRequests"), function() LocalPlayer():ConCommand("say /viewtickets " .. steamID) end):SetIcon("icon16/help.png")
                if (ln.ticketClaims or 0) > 0 then
                    menu:AddOption(L("viewTicketClaims"), function() LocalPlayer():ConCommand("say /plyviewclaims " .. steamID) end):SetIcon("icon16/page_white_text.png")
                end
            end)
        end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():hasPrivilege(L("canAccessPlayerList")) then return end
        table.insert(pages, {
            name = L("players"),
            drawFunc = function(panel)
                panelRef = panel
                net.Start("liaRequestPlayers")
                net.SendToServer()
            end
        })
    end
else
    net.Receive("liaRequestPlayers", function(_, client)
        if not client:hasPrivilege(L("canAccessPlayerList")) then return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        local query = [[
SELECT steamName, steamID, userGroup, firstJoin, lastOnline, totalOnlineTime,
    (SELECT COUNT(*) FROM lia_characters WHERE steamID = lia_players.steamID AND schema = %s) AS characterCount,
    (SELECT COUNT(*) FROM lia_warnings WHERE warnedSteamID = lia_players.steamID) AS warnings,
    (SELECT COUNT(*) FROM lia_ticketclaims WHERE requesterSteamID = lia_players.steamID) AS ticketsRequested,
    (SELECT COUNT(*) FROM lia_ticketclaims WHERE adminSteamID = lia_players.steamID) AS ticketsClaimed
FROM lia_players
]]
        query = string.format(query, lia.db.convertDataType(gamemode))
        lia.db.query(query, function(data)
            data = data or {}
            for _, row in ipairs(data) do
                local ply = player.GetBySteamID(tostring(row.steamID))
                if IsValid(ply) then
                    row.totalOnlineTime = ply:getPlayTime()
                end
            end

            lia.net.writeBigTable(client, "liaAllPlayers", data)
        end)
    end)

    net.Receive("liaRequestPlayerCharacters", function(_, client)
        if not (client:hasPrivilege(L("canAccessPlayerList")) or client:hasPrivilege("Can Manage Factions")) then return end
        local steamID = net.ReadString()
        if not steamID or steamID == "" then return end
        local gamemode = SCHEMA and SCHEMA.folder or engine.ActiveGamemode()
        local query = string.format("SELECT name FROM lia_characters WHERE steamID = %s AND schema = '%s'", lia.db.convertDataType(steamID), lia.db.escape(gamemode))
        lia.db.query(query, function(data)
            local chars = {}
            if data then
                for _, v in ipairs(data) do
                    chars[#chars + 1] = v.name
                end
            end

            lia.net.writeBigTable(client, "liaPlayerCharacters", {
                steamID = steamID,
                characters = chars
            })
        end)
    end)
end
