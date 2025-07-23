function MODULE:CheckFactionLimitReached(faction, character, client)
    if faction.OnCheckLimitReached then return faction:OnCheckLimitReached(character, client) end
    if not isnumber(faction.limit) then return false end
    local maxPlayers = faction.limit
    if faction.limit < 1 then maxPlayers = math.Round(player.GetCount() * faction.limit) end
    return team.NumPlayers(faction.index) >= maxPlayers
end

function MODULE:GetDefaultCharName(client, faction, data)
    local info = lia.faction.indices[faction]
    local nameFunc = info and info.NameTemplate
    if isfunction(nameFunc) then
        local name, override = nameFunc(info, client)
        if name then return name, override ~= false end
    end

    local baseName = data and data.name or nil
    if info and info.GetDefaultName then baseName = info:GetDefaultName(client) or baseName end
    baseName = baseName or client:SteamName()
    return baseName, false
end

function MODULE:GetDefaultCharDesc(client, faction)
    local info = lia.faction.indices[faction]
    if info and info.GetDefaultDesc then info:GetDefaultDesc(client) end
end

if SERVER then
    util.AddNetworkString("RosterRequest")
    util.AddNetworkString("RosterData")
    util.AddNetworkString("KickCharacter")
    local function d(...)
        print("[RosterDebug]", ...)
    end

    net.Receive("RosterRequest", function(_, client)
        local char = client:getChar()
        if not char then
            d("No char", client)
            return
        end

        if not (client:IsSuperAdmin() or char:hasFlags("V")) then
            d("No perm", client)
            return
        end

        local faction = lia.faction.indices[char:getFaction()]
        if not faction then
            d("No faction", char:getID())
            return
        end

        local fields = "lia_characters._name, lia_characters._faction, lia_characters._class, lia_characters._id, lia_characters._steamID, lia_characters._lastJoinTime, lia_players._totalOnlineTime, lia_players._lastOnline"
        local condition = "lia_characters._schema = '" .. lia.db.escape(SCHEMA.folder) .. "' AND lia_characters._faction = " .. lia.db.convertDataType(faction.uniqueID)
        local query = "SELECT " .. fields .. " FROM lia_characters LEFT JOIN lia_players ON lia_characters._steamID = lia_players._steamID WHERE " .. condition
        d("Running query:", query)
        lia.db.query(query, function(data)
            if not data or #data == 0 then
                d("Empty result")
            else
                d("Query rows:", #data)
                PrintTable(data)
            end

            local characters = {}
            if data then
                for _, v in ipairs(data) do
                    local id = tonumber(v._id)
                    local online = lia.char.loaded[id] ~= nil
                    local lastOnline
                    if online then
                        lastOnline = L("onlineNow")
                    else
                        local last = tonumber(v._lastOnline)
                        if not isnumber(last) then last = os.time(lia.time.toNumber(v._lastJoinTime)) end
                        local diff = os.time() - last
                        local since = lia.time.TimeSince(last)
                        local stripped = since:match("^(.-)%sago$") or since
                        lastOnline = string.format("%s (%s) ago", stripped, lia.time.SecondsToDHM(diff))
                    end

                    characters[#characters + 1] = {
                        id = id,
                        name = v._name,
                        faction = v._faction,
                        class = v._class,
                        steamID = v._steamID,
                        lastOnline = lastOnline,
                        hoursPlayed = lia.time.SecondsToDHM(tonumber(v._totalOnlineTime) or 0)
                    }
                end
            end

            d("Built characters table size:", #characters)
            PrintTable(characters)
            net.Start("RosterData")
            net.WriteString(faction.uniqueID)
            net.WriteTable(characters)
            net.Send(client)
            d("Sent RosterData to", client, "for faction", faction.uniqueID)
        end)
    end)

    net.Receive("KickCharacter", function(_, client)
        local senderChar = client:getChar()
        if not senderChar then return end
        if not (client:IsSuperAdmin() or senderChar:hasFlags("V")) then return end
        local targetID = net.ReadInt(32)
        if not isnumber(targetID) then return end
        if senderChar:getID() == targetID then return end
        local target = lia.char.loaded[targetID]
        if not target then return end
        local ply = target:getPlayer()
        if IsValid(ply) then ply:Kick("Kicked by roster panel") end
    end)
else
    local rosterFaction, rosterRows = nil, {}
    local listFaction, listClass
    local function populate(list, filterKey)
        if not IsValid(list) then return end
        list:Clear()
        for _, r in ipairs(rosterRows) do
            if r[filterKey] then
                local line = list:AddLine(r.id, r.name, r.lastOnline, r.hoursPlayed, r.faction, r.class or "N/A")
                line.rowData = r
            end
        end
    end

    local function openMenu(row)
        local myChar = LocalPlayer():getChar()
        if not myChar then return end
        local m = DermaMenu()
        if row.id ~= myChar:getID() then
            m:AddOption("Kick", function()
                Derma_Query("Are you sure you want to kick this player?", "Confirm", "Yes", function()
                    net.Start("KickCharacter")
                    net.WriteInt(tonumber(row.id), 32)
                    net.SendToServer()
                end, "No")
            end)
        end

        m:AddOption(L("copyRow"), function()
            local s = ""
            for k, v in pairs(row) do
                v = tostring(v or L("na"))
                s = s .. k:gsub("^%l", string.upper) .. ": " .. v .. " | "
            end

            SetClipboardText(s:sub(1, -4))
        end)

        m:Open()
    end

    net.Receive("RosterData", function()
        rosterFaction = net.ReadString()
        local data = net.ReadTable()
        local char = LocalPlayer():getChar()
        if not char then return end
        if not (LocalPlayer():IsSuperAdmin() or char:hasFlags("V")) then return end
        rosterRows = {}
        for _, d in ipairs(data or {}) do
            if d.faction == rosterFaction then rosterRows[#rosterRows + 1] = d end
        end

        populate(listFaction, "faction")
        populate(listClass, "class")
    end)

    local function makeList(parent)
        local list = parent:Add("DListView")
        list:Dock(FILL)
        list:SetMultiSelect(false)
        list:AddColumn("ID")
        list:AddColumn("Name")
        list:AddColumn("Last Online")
        list:AddColumn("Hours Played")
        list:AddColumn("Faction")
        list:AddColumn("Class")
        list.OnRowRightClick = function(_, _, line)
            if not IsValid(line) or not line.rowData then return end
            openMenu(line.rowData)
        end
        return list
    end

    local function buildRoster(panel)
        if not IsValid(panel) then return end
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        local pnlFaction = vgui.Create("DPanel", sheet)
        pnlFaction:Dock(FILL)
        listFaction = makeList(pnlFaction)
        sheet:AddSheet("Faction", pnlFaction, "icon16/group.png")
        local pnlClass = vgui.Create("DPanel", sheet)
        pnlClass:Dock(FILL)
        listClass = makeList(pnlClass)
        sheet:AddSheet("Class", pnlClass, "icon16/user.png")
        populate(listFaction, "faction")
        populate(listClass, "class")
    end

    function MODULE:CreateMenuButtons(tabs)
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        local char = ply:getChar()
        if not char then return end
        if not (ply:IsSuperAdmin() or char:hasFlags("V")) then return end
        tabs[L("roster")] = function(panel)
            listFaction, listClass = nil, nil
            rosterRows = {}
            net.Start("RosterRequest")
            net.SendToServer()
            buildRoster(panel)
        end
    end
end