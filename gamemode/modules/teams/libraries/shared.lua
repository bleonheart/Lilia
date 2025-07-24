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
    local function toSteamID(id)
        if not id then return "" end
        id = tostring(id)
        if id:sub(1, 6) == "STEAM_" then return id end
        return util.SteamIDFrom64(id)
    end

    net.Receive("RosterRequest", function(_, client)
        local facUniqueID = net.ReadString()
        local char = client:getChar()
        if not char then return end
        if not (client:IsSuperAdmin() or char:hasFlags("V")) then return end
        local facTbl
        if facUniqueID ~= "" then
            for _, v in pairs(lia.faction.indices) do
                if tostring(v.uniqueID) == facUniqueID then
                    facTbl = v
                    break
                end
            end
        else
            facTbl = lia.faction.indices[char:getFaction()]
        end

        if not facTbl then return end
        local fields = [[lia_characters._name, lia_characters._faction, lia_characters._class, lia_characters._id, lia_characters._steamID, lia_characters._lastJoinTime, lia_players._totalOnlineTime, lia_players._lastOnline]]
        local condition = "lia_characters._schema = '" .. lia.db.escape(SCHEMA.folder) .. "' AND lia_characters._faction = " .. lia.db.convertDataType(facTbl.uniqueID)
        local query = "SELECT " .. fields .. " FROM lia_characters LEFT JOIN lia_players ON lia_characters._steamID = lia_players._steamID WHERE " .. condition
        lia.db.query(query, function(data)
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

                local classID = tonumber(v._class) or v._class
                local className
                if classID == nil or classID == 0 then
                    className = "None"
                else
                    className = lia.class.list and lia.class.list[classID] and lia.class.list[classID].name or tostring(classID or "")
                end
                out[#out + 1] = {
                    id = id,
                    name = v._name,
                    class = className,
                    classID = classID,
                    steamID = toSteamID(v._steamID),
                    lastOnline = lastOnline,
                    hoursPlayed = lia.time.SecondsToDHM(tonumber(v._totalOnlineTime) or 0)
                }
            end

            net.Start("RosterData")
            net.WriteString(facTbl.uniqueID)
            net.WriteTable(out)
            net.Send(client)
        end)
    end)
else
    local rosterRows = {}
    local lists = {}
    local built = false
    local function toSteamID(id)
        if not id then return "" end
        id = tostring(id)
        if id:sub(1, 6) == "STEAM_" then return id end
        return util.SteamIDFrom64(id)
    end

    local function addRow(lst, r)
        local line = lst:AddLine(r.name, r.steamID, r.class, r.hoursPlayed, r.lastOnline)
        line.rowData = r
    end

    local function populate(uid)
        if not built then return end
        local lst = lists[uid]
        if not IsValid(lst) then return end
        lst:Clear()
        for _, r in ipairs(rosterRows[uid] or {}) do
            addRow(lst, r)
        end
    end

    net.Receive("RosterData", function()
        local uid = net.ReadString()
        local data = net.ReadTable()
        local char = LocalPlayer():getChar()
        if not char then return end
        if not (LocalPlayer():IsSuperAdmin() or char:hasFlags("V")) then return end
        for _, row in ipairs(data or {}) do
            row.steamID = toSteamID(row.steamID)
        end

        rosterRows[uid] = data or {}
        populate(uid)
    end)

    local function makeList(parent)
        local lst = parent:Add("DListView")
        lst:Dock(FILL)
        lst:SetMultiSelect(false)
        lst:AddColumn("Name")
        lst:AddColumn("SteamID")
        lst:AddColumn("Class")
        lst:AddColumn("Hours Played")
        lst:AddColumn("Last Online")
        lst.OnRowRightClick = function(_, _, line)
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

            m:AddOption("View Character List", function() LocalPlayer():ConCommand("say /charlist " .. row.steamID) end)
            m:AddOption(L("copyRow"), function()
                local s = ""
                for k, v in pairs(row) do
                    s = s .. k:gsub("^%l", string.upper) .. ": " .. tostring(v or L("na")) .. " | "
                end

                SetClipboardText(s:sub(1, -4))
            end)

            m:Open()
        end
        return lst
    end

    local function buildRoster(panel)
        local char = LocalPlayer():getChar()
        if not char then return end
        local fac = lia.faction.indices[char:getFaction()]
        if not fac then return end
        local uid = fac.uniqueID

        local background = panel:Add("DPanel")
        background:Dock(FILL)
        background.Paint = function(p, w, h) derma.SkinHook("Paint", "Panel", p, w, h) end

        lists[uid] = makeList(background)
        built = true
        net.Start("RosterRequest")
        net.WriteString(uid)
        net.SendToServer()
    end

    local function buildFactions(panel)
        local ps = panel:Add("DPropertySheet")
        ps:Dock(FILL)
        for _, fac in pairs(lia.faction.indices) do
            local pnl = ps:Add("Panel")
            pnl:Dock(FILL)

            local bg = pnl:Add("DPanel")
            bg:Dock(FILL)
            bg.Paint = function(p, w, h) derma.SkinHook("Paint", "Panel", p, w, h) end

            lists[fac.uniqueID] = makeList(bg)
            ps:AddSheet(fac.name or fac.uniqueID, pnl)
            net.Start("RosterRequest")
            net.WriteString(fac.uniqueID)
            net.SendToServer()
        end

        built = true
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
            buildRoster(panel)
        end
    end

    hook.Add("liaAdminRegisterTab", "AdminTabFactions", function(parent, tabs)
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        local char = ply:getChar()
        if not char then return end
        if not (ply:IsSuperAdmin() or char:hasFlags("V")) then return end
        tabs["Factions"] = {
            icon = "icon16/group.png",
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                rosterRows = {}
                lists = {}
                built = false
                buildFactions(pnl)
                return pnl
            end
        }
    end)
end
