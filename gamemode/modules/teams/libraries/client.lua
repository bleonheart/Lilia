local MODULE = MODULE
function MODULE:LoadCharInformation()
    local client = LocalPlayer()
    if not IsValid(client) then return end
    local character = client:getChar()
    if not character then return end
    hook.Run("AddTextField", L("generalInfo"), "faction", L("faction"), function() return team.GetName(client:Team()) end)
    local classID = character:getClass()
    local classData = lia.class.list[classID]
    if classID and classData and classData.name then hook.Run("AddTextField", L("generalInfo"), "class", L("class"), function() return classData.name end) end
end

function MODULE:DrawCharInfo(client, _, info)
    if not lia.config.get("ClassDisplay", true) then return end
    local charClass = client:getClassData()
    if charClass then
        local classColor = charClass.color or Color(255, 255, 255)
        local className = L(charClass.name) or L("undefinedClass")
        info[#info + 1] = {className, classColor}
    end
end

rosterRows = rosterRows or {}
lists = lists or {}
built = built or false
function toSteamID(id)
    if not id then return "" end
    id = tostring(id)
    if id:sub(1, 6) == "STEAM_" then return id end
    return util.SteamIDFrom64(id)
end

function addRow(lst, r)
    local line = lst:AddLine(r.name, r.steamID, r.class, r.hoursPlayed, r.lastOnline)
    line.rowData = r
end

function populate(uid)
    if not built then return end
    local lst = lists[uid]
    if not IsValid(lst) then return end
    local query = IsValid(lst.searchEntry) and lst.searchEntry:GetValue() or ""
    lst:Clear()
    for _, r in ipairs(rosterRows[uid] or {}) do
        local info = (r.name .. " " .. r.steamID .. " " .. r.class .. " " .. tostring(r.hoursPlayed) .. " " .. tostring(r.lastOnline)):lower()
        if query == "" or info:find(query:lower(), 1, true) then
            addRow(lst, r)
        end
    end
end

function makeList(parent, uid)
    local search = parent:Add("DTextEntry")
    search:Dock(TOP)
    search:DockMargin(0, 0, 0, 5)
    search:SetPlaceholderText(L("search"))

    local lst = parent:Add("DListView")
    lst:Dock(FILL)
    lst:SetMultiSelect(false)
    lst:AddColumn("Name")
    lst:AddColumn("SteamID")
    lst:AddColumn("Class")
    lst:AddColumn("Hours Played")
    lst:AddColumn("Last Online")
    local function populate(q)
        lst:Clear()
        q = q and string.lower(q) or ""
        for _, r in ipairs(rosterRows[uid] or {}) do
            local info = (r.name .. " " .. r.steamID .. " " .. r.class .. " " .. tostring(r.hoursPlayed) .. " " .. tostring(r.lastOnline)):lower()
            if q == "" or info:find(q, 1, true) then
                addRow(lst, r)
            end
        end
    end

    lst.searchEntry = search
    populate()
    search.OnChange = function() populate(search:GetValue()) end

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

function buildRoster(panel)
    panel.Paint = function(pnl, w, h) derma.SkinHook("Paint", "Panel", pnl, w, h) end
    local char = LocalPlayer():getChar()
    if not char then return end
    local fac = lia.faction.indices[char:getFaction()]
    if not fac then return end
    local uid = fac.uniqueID
    local bg = panel:Add("DPanel")
    bg:Dock(FILL)
    bg:DockPadding(10, 10, 10, 10)
    bg.Paint = function(pnl, w, h) derma.SkinHook("Paint", "Panel", pnl, w, h) end
    lists[uid] = makeList(bg, uid)
    built = true
    net.Start("RosterRequest")
    net.WriteString(uid)
    net.SendToServer()
end

function buildFactions(panel)
    local ps = panel:Add("DPropertySheet")
    ps:Dock(FILL)
    for _, fac in pairs(lia.faction.indices) do
        local pnl = ps:Add("Panel")
        pnl:Dock(FILL)
        local bg = pnl:Add("DPanel")
        bg:Dock(FILL)
        bg:DockPadding(10, 10, 10, 10)
        bg.Paint = function(p, w, h) derma.SkinHook("Paint", "Panel", p, w, h) end
        lists[fac.uniqueID] = makeList(bg, fac.uniqueID)
        ps:AddSheet(fac.name or fac.uniqueID, pnl)
        net.Start("RosterRequest")
        net.WriteString(fac.uniqueID)
        net.SendToServer()
    end

    built = true
end

function MODULE:CreateInformationButtons(pages)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local char = ply:getChar()
    if not char then return end
    if not (ply:IsSuperAdmin() or char:hasFlags("V")) then return end
    table.insert(pages, {
        name = L("roster"),
        drawFunc = function(panel)
            rosterRows = {}
            lists = {}
            built = false
            buildRoster(panel)
        end
    })
end

hook.Add("liaAdminRegisterTab", "AdminTabFactions", function(tabs)
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