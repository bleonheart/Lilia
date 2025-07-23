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

        local facTbl = lia.faction.indices[char:getFaction()]
        if not facTbl then
            d("No faction", char:getID())
            return
        end

        local fields = "lia_characters._name, lia_characters._faction, lia_characters._class, lia_characters._id, lia_characters._steamID, lia_characters._lastJoinTime, lia_players._totalOnlineTime, lia_players._lastOnline"
        local condition = "lia_characters._schema = '" .. lia.db.escape(SCHEMA.folder) .. "' AND lia_characters._faction = " .. lia.db.convertDataType(facTbl.uniqueID)
        local query = "SELECT " .. fields .. " FROM lia_characters LEFT JOIN lia_players ON lia_characters._steamID = lia_players._steamID WHERE " .. condition
        d("Running query:", query)
        lia.db.query(query, function(data)
            d("Rows:", data and #data or 0)
            local out = {}
            for _, v in ipairs(data or {}) do
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

                local fID = tonumber(v._faction) or v._faction
                local fName = lia.faction.indices[fID] and lia.faction.indices[fID].name or tostring(fID or "")
                local cID = tonumber(v._class) or v._class
                local cName = lia.class.list and lia.class.list[cID] and lia.class.list[cID].name or tostring(cID or "")
                out[#out + 1] = {
                    id = id,
                    name = v._name,
                    faction = fName,
                    factionID = fID,
                    class = cName,
                    classID = cID,
                    steamID = v._steamID,
                    lastOnline = lastOnline,
                    hoursPlayed = lia.time.SecondsToDHM(tonumber(v._totalOnlineTime) or 0)
                }
            end

            d("Built:", #out)
            net.Start("RosterData")
            net.WriteString(facTbl.uniqueID)
            net.WriteTable(out)
            net.Send(client)
        end)
    end)

    net.Receive("KickCharacter", function(_, client)
        local c = client:getChar()
        if not c then return end
        if not (client:IsSuperAdmin() or c:hasFlags("V")) then return end
        local id = net.ReadInt(32)
        if c:getID() == id then return end
        local target = lia.char.loaded[id]
        if not target then return end
        local ply = target:getPlayer()
        if IsValid(ply) then ply:Kick("Kicked by roster panel") end
    end)
else
    local rosterRows = {}
    local lists = {}
    local built = false
    local function addRow(list, r)
        local line = list:AddLine(r.id, r.name, r.lastOnline, r.hoursPlayed, r.faction, r.class)
        line.rowData = r
    end

    local function makeClassList(parent)
        local list = parent:Add("DListView")
        list:Dock(FILL)
        list:SetMultiSelect(false)
        list:AddColumn("Class")
        list:AddColumn("Members")
        return list
    end

    local function populate()
        if not built then return end
        if IsValid(lists.faction) then
            lists.faction:Clear()
            for _, r in ipairs(rosterRows) do
                addRow(lists.faction, r)
            end
        end

        if IsValid(lists.class) then
            lists.class:Clear()
            local counts = {}
            for _, r in ipairs(rosterRows) do
                local c = r.class or L("na")
                counts[c] = (counts[c] or 0) + 1
            end
            for className, count in pairs(counts) do
                lists.class:AddLine(className, count)
            end
        end
    end

    net.Receive("RosterData", function()
        local srvFactionUnique = net.ReadString()
        local data = net.ReadTable()
        local char = LocalPlayer():getChar()
        if not char then return end
        if not (LocalPlayer():IsSuperAdmin() or char:hasFlags("V")) then return end
        rosterRows = {}
        for _, d in ipairs(data or {}) do
            rosterRows[#rosterRows + 1] = d
        end

        print("[RosterClientDebug] Got", #rosterRows, "rows. First faction:", rosterRows[1] and rosterRows[1].faction or "nil")
        populate()
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
            local row = line.rowData
            local me = LocalPlayer():getChar()
            if not me then return end
            local m = DermaMenu()
            if row.id ~= me:getID() then
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
                    s = s .. k:gsub("^%l", string.upper) .. ": " .. tostring(v or L("na")) .. " | "
                end

                SetClipboardText(s:sub(1, -4))
            end)

            m:Open()
        end
        return list
    end

    local function build(panel)
        local sheet = panel:Add("DPropertySheet")
        sheet:Dock(FILL)
        local pf = vgui.Create("DPanel", sheet)
        pf:Dock(FILL)
        lists.faction = makeList(pf)
        sheet:AddSheet("Faction", pf, "icon16/group.png")

        local pc = vgui.Create("DPanel", sheet)
        pc:Dock(FILL)
        lists.class = makeClassList(pc)
        sheet:AddSheet("Class", pc, "icon16/user.png")
        built = true
        populate()
    end

    function MODULE:CreateMenuButtons(tabs)
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        local char = ply:getChar()
        if not char then return end
        if not (ply:IsSuperAdmin() or char:hasFlags("V")) then return end
        tabs[L("roster")] = function(panel)
            rosterRows = {}
            lists = {}
            built = false
            build(panel)
            net.Start("RosterRequest")
            net.SendToServer()
        end
    end
end