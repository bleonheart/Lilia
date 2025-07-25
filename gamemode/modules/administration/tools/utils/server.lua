function MODULE:OnReloaded()
    for _, client in player.Iterator() do
        if IsValid(client) and client:IsPlayer() then client:ConCommand("spawnmenu_reload") end
    end
end

function MODULE:PlayerSpawn(client)
    if IsValid(client) and client:IsPlayer() then client:ConCommand("spawnmenu_reload") end
    lia.log.add(client, "playerSpawn")
end

local DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true
}

local ChunkSize = 60000
local function buildDefaultTable(g)
    local t = {}
    if not (CAMI and CAMI.GetPrivileges and CAMI.UsergroupInherits) then return t end
    for _, v in ipairs(CAMI.GetPrivileges() or {}) do
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
            Inherits = inh or "user"
        })
    end
end

local function dropCAMIGroup(n)
    if not (CAMI and CAMI.GetUsergroups and CAMI.UnregisterUsergroup) then return end
    local g = CAMI.GetUsergroups() or {}
    if g[n] then CAMI.UnregisterUsergroup(n) end
end

local function sendBigTable(ply, tbl, strChunk, strDone)
    local raw = util.TableToJSON(tbl)
    local comp = util.Compress(raw)
    local len = #comp
    local id = util.CRC(tostring(SysTime()) .. len)
    local parts = math.ceil(len / ChunkSize)
    for i = 1, parts do
        local chunk = string.sub(comp, (i - 1) * ChunkSize + 1, math.min(i * ChunkSize, len))
        net.Start(strChunk)
        net.WriteString(id)
        net.WriteUInt(i, 16)
        net.WriteUInt(parts, 16)
        net.WriteUInt(#chunk, 16)
        net.WriteData(chunk, #chunk)
        if IsEntity(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    net.Start(strDone)
    net.WriteString(id)
    if IsEntity(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

local function syncPrivileges()
    if not (CAMI and CAMI.GetPrivileges and CAMI.GetUsergroups) then return end
    for _, v in ipairs(CAMI.GetPrivileges() or {}) do
        lia.admin.privileges[v.Name] = {
            Name = v.Name,
            MinAccess = v.MinAccess or "user"
        }
    end

    for n, d in pairs(CAMI.GetUsergroups() or {}) do
        lia.admin.groups[n] = lia.admin.groups[n] or buildDefaultTable(n)
        ensureCAMIGroup(n, d.Inherits or "user")
    end
end

local function allowed(p)
    return IsValid(p) and p:IsSuperAdmin() or p:hasPrivilege("Manage UserGroups")
end

local function getPrivCategories()
    local categories = {}
    for name, priv in pairs(lia.admin.privileges) do
        local cat = priv.Category or "Unassigned"
        categories[cat] = categories[cat] or {}
        table.insert(categories[cat], name)
    end

    for _, list in pairs(categories) do
        table.sort(list)
    end
    return categories
end

local function payloadGroups()
    return {
        cami = CAMI and CAMI.GetUsergroups and CAMI.GetUsergroups() or {},
        perms = lia.admin.groups or {},
        privCategories = getPrivCategories()
    }
end

local function getBanList()
    local data = file.Read("cfg/banned_user.cfg", "GAME")
    local t = {}
    if data then
        for sid in string.gmatch(data, "banid%s+%d+%s+(STEAM_%d:%d:%d+)") do
            t[sid] = true
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
            firstJoin = v.firstJoin or os.time(),
            lastJoin = v.lastJoin or os.time(),
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
            firstJoin = 0,
            lastJoin = 0,
            banned = true
        }
    end
    return {
        players = plys
    }
end

local function applyToCAMI(g)
    if not (CAMI and CAMI.GetUsergroups and CAMI.RegisterUsergroup) then return end
    ensureCAMIGroup(g, CAMI.GetUsergroups()[g] and CAMI.GetUsergroups()[g].Inherits or "user")
end

local function notify(p, msg)
    if IsValid(p) and p.notify then p:notify(msg) end
    net.Start("liaGroupsNotice")
    net.WriteString(msg)
    if IsEntity(p) then
        net.Send(p)
    else
        net.Broadcast()
    end
end

syncPrivileges()
hook.Add("PlayerInitialSpawn", "liaAdminTrackJoin", function(p)
    if p:IsBot() then return end
    lia.admin.lastJoin[p:SteamID()] = os.time()
end)

net.Receive("liaGroupsRequest", function(_, p)
    if not allowed(p) then return end
    syncPrivileges()
    sendBigTable(p, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
end)

net.Receive("liaPlayersRequest", function(_, p)
    if not allowed(p) then return end
    sendBigTable(p, payloadPlayers(), "liaPlayersDataChunk", "liaPlayersDataDone")
end)

net.Receive("liaRequestPlayerGroup", function(_, p)
    if not allowed(p) then return end
    local target = net.ReadEntity()
    if not IsValid(target) or not target:IsPlayer() then return end
    local groups = {}
    for name in pairs(lia.admin.groups or {}) do
        groups[#groups + 1] = name
    end

    table.sort(groups)
    p:requestDropdown(L("setUsergroup"), L("chooseGroup"), groups, function(sel)
        if not IsValid(p) or not IsValid(target) then return end
        if lia.admin.groups[sel] then
            lia.admin.setPlayerGroup(target, sel)
            p:notifyLocalized("plyGroupSet")
            lia.log.add(p, "plySetGroup", target:Name(), sel)
        else
            p:notifyLocalized("groupNotExists")
        end
    end)
end)

net.Receive("liaGroupsAdd", function(_, p)
    if not allowed(p) then return end
    local n = net.ReadString()
    if n == "" then return end
    local groups = {}
    for name in pairs(lia.admin.groups or {}) do
        groups[#groups + 1] = name
    end

    table.sort(groups)
    p:requestDropdown(L("inheritGroupTitle"), L("selectInheritancePrompt"), groups, function(sel)
        if n == "" or not IsValid(p) then return end
        local inherit = lia.admin.groups[sel] and sel or "user"
        lia.admin.createGroup(n, nil, inherit)
        lia.admin.groups[n] = buildDefaultTable(n)
        applyToCAMI(n, lia.admin.groups[n])
        lia.admin.save(true)
        sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
        notify(p, L("groupCreatedNamed", n))
    end)
end)

net.Receive("liaGroupsRemove", function(_, p)
    if not allowed(p) then return end
    local n = net.ReadString()
    if n == "" or DefaultGroups[n] then return end
    lia.admin.removeGroup(n)
    lia.admin.groups[n] = nil
    dropCAMIGroup(n)
    lia.admin.save(true)
    sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    notify(p, L("groupRemovedNamed", n))
end)

net.Receive("liaGroupsRename", function(_, p)
    if not allowed(p) then return end
    local old = net.ReadString()
    local new = net.ReadString()
    if old == "" or new == "" or DefaultGroups[old] or DefaultGroups[new] then return end
    if lia.admin.groups[new] or not lia.admin.groups[old] then return end
    lia.admin.groups[new] = lia.admin.groups[old]
    lia.admin.groups[old] = nil
    dropCAMIGroup(old)
    ensureCAMIGroup(new, "user")
    lia.admin.save(true)
    applyToCAMI(new, lia.admin.groups[new])
    for _, ply in player.Iterator() do
        if ply:GetUserGroup() == old then lia.admin.setPlayerGroup(ply, new) end
    end

    sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    notify(p, L("groupRenamedNamed", old, new))
end)

net.Receive("liaGroupsApply", function(_, p)
    if not allowed(p) then return end
    local g = net.ReadString()
    local t = net.ReadTable()
    if g == "" or DefaultGroups[g] then return end
    lia.admin.groups[g] = {}
    for k, v in pairs(t) do
        if v then lia.admin.groups[g][k] = true end
    end

    lia.admin.save(true)
    applyToCAMI(g, lia.admin.groups[g])
    sendBigTable(nil, payloadGroups(), "liaGroupsDataChunk", "liaGroupsDataDone")
    notify(p, L("permissionsSavedNamed", g))
end)
