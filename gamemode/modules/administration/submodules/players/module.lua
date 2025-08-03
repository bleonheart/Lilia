MODULE.name = L("modulePlayerListName", "Player List")
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = L("modulePlayerListDesc", "View player accounts and characters.")

if CLIENT then
    local panelRef
    local charMenuPos

    lia.net.readBigTable("liaAllPlayers", function(players)
        if not IsValid(panelRef) then return end
        panelRef:Clear()
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

        addSizedColumn(L("steamName", "Steam Name"))
        addSizedColumn(L("steamID", "SteamID"))
        addSizedColumn(L("usergroup", "Usergroup"))
        for _, v in ipairs(players or {}) do
            local line = list:AddLine(v.steamName or "", v.steamID or "", v.userGroup or "")
            line.steamID = v.steamID
        end

        function list:OnRowRightClick(_, line)
            if not IsValid(line) or not line.steamID then return end
            charMenuPos = {gui.MousePos()}
            net.Start("liaRequestPlayerCharacters")
            net.WriteString(line.steamID)
            net.SendToServer()
        end
    end)

    lia.net.readBigTable("liaPlayerCharacters", function(data)
        if not data then return end
        local menu = DermaMenu()
        local chars = data.characters or {}
        if #chars == 0 then
            menu:AddOption(L("none", "None"))
        else
            for _, name in ipairs(chars) do
                menu:AddOption(name)
            end
        end

        if charMenuPos then
            menu:Open(charMenuPos[1], charMenuPos[2])
        else
            menu:Open()
        end
    end)

    function MODULE:PopulateAdminTabs(pages)
        if not IsValid(LocalPlayer()) or not LocalPlayer():IsAdmin() then return end
        table.insert(pages, {
            name = L("players", "Players"),
            drawFunc = function(panel)
                panelRef = panel
                net.Start("liaRequestPlayers")
                net.SendToServer()
            end
        })
    end
else
    util.AddNetworkString("liaRequestPlayers")
    util.AddNetworkString("liaAllPlayers")
    util.AddNetworkString("liaRequestPlayerCharacters")
    util.AddNetworkString("liaPlayerCharacters")

    net.Receive("liaRequestPlayers", function(_, client)
        if not client:IsAdmin() then return end
        lia.db.query("SELECT steamName, steamID, userGroup FROM lia_players", function(data)
            lia.net.writeBigTable(client, "liaAllPlayers", data or {})
        end)
    end)

    net.Receive("liaRequestPlayerCharacters", function(_, client)
        if not client:IsAdmin() then return end
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

            lia.net.writeBigTable(client, "liaPlayerCharacters", {steamID = steamID, characters = chars})
        end)
    end)
end
