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
    lst:AddColumn(L("name"))
    lst:AddColumn(L("steamID"))
    lst:AddColumn(L("class"))
    lst:AddColumn(L("hoursPlayed"))
    lst:AddColumn(L("lastOnline"))
    lst.OnRowRightClick = function(_, _, line)
        if not IsValid(line) or not line.rowData then return end
        local row = line.rowData
        local me = LocalPlayer():getChar()
        if not me then return end
        local m = DermaMenu()
        if row.id ~= me:getID() then
            m:AddOption(L("kick"), function()
                Derma_Query(L("kickPlayerConfirm"), L("confirm"), L("yes"), function()
                    net.Start("KickCharacter")
                    net.WriteInt(tonumber(row.id), 32)
                    net.SendToServer()
                end, L("no"))
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

hook.Add("liaAdminRegisterTab", "AdminTabFactions", function(tabs)
    local function canAccess()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        local char = ply:getChar()
        if not char then return false end
        return (ply:IsSuperAdmin() or char:hasFlags("V")) and ply:hasPrivilege("Access Factions Tab")
    end

    tabs["Factions"] = {
        icon = "icon16/group.png",
        onShouldShow = canAccess,
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
