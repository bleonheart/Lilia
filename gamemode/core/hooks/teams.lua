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

AddInteraction(L("inviteToClass"), {
    runServer = true,
    shouldShow = function(client, target)
        local cChar = client:getChar()
        local tChar = target:getChar()
        if not cChar or not tChar then return false end
        if cChar:hasFlags("X") then return true end
        local classData = lia.class.list[cChar:getClass()]
        if classData and classData.canInviteToClass then return true end
        if cChar:getFaction() ~= tChar:getFaction() then return false end
        return hook.Run("CanInviteToClass", client, target) ~= false
    end,
    onRun = function(client, target)
        if not SERVER then return end
        local cChar = client:getChar()
        local tChar = target:getChar()
        if not cChar or not tChar then return end
        local class = lia.class.list[cChar:getClass()]
        if not class then
            client:notifyLocalized("invalidClass")
            return
        end

        target:binaryQuestion(L("joinClassPrompt"), L("yes"), L("no"), false, function(choice)
            if choice ~= 0 then
                client:notifyLocalized("inviteDeclined")
                return
            end

            if hook.Run("CanCharBeTransfered", tChar, class, tChar:getClass()) == false then return end
            local oldClass = tChar:getClass()
            tChar:setClass(class.index)
            hook.Run("OnPlayerJoinClass", target, class.index, oldClass)
            client:notifyLocalized("transferSuccess", target:Name(), class.name)
            if client ~= target then target:notifyLocalized("transferNotification", class.name, client:Name()) end
        end)
    end
})

AddInteraction(L("inviteToFaction"), {
    runServer = true,
    shouldShow = function(client, target)
        local cChar = client:getChar()
        local tChar = target:getChar()
        if not cChar or not tChar then return false end
        if cChar:hasFlags("Z") then return true end
        local classData = lia.class.list[cChar:getClass()]
        if classData and classData.canInviteToFaction then return true end
        return hook.Run("CanInviteToFaction", client, target) ~= false and cChar:getFaction() ~= tChar:getFaction()
    end,
    onRun = function(client, target)
        if not SERVER then return end
        local iChar = client:getChar()
        local tChar = target:getChar()
        if not iChar or not tChar then return end
        local faction
        for _, fac in pairs(lia.faction.teams) do
            if fac.index == client:Team() then faction = fac end
        end

        if not faction then
            client:notifyLocalized("invalidFaction")
            return
        end

        target:binaryQuestion(L("joinFactionPrompt"), L("yes"), L("no"), false, function(choice)
            if choice ~= 0 then
                client:notifyLocalized("inviteDeclined")
                return
            end

            if hook.Run("CanCharBeTransfered", tChar, faction, tChar:getFaction()) == false then return end
            local oldFaction = tChar:getFaction()
            tChar.vars.faction = faction.uniqueID
            tChar:setFaction(faction.index)
            tChar:kickClass()
            local defClass = lia.faction.getDefaultClass(faction.index)
            if defClass then tChar:joinClass(defClass.index) end
            hook.Run("OnTransferred", target)
            if faction.OnTransferred then faction:OnTransferred(target, oldFaction) end
            hook.Run("PlayerLoadout", target)
            client:notifyLocalized("transferSuccess", target:Name(), faction.name)
            if client ~= target then target:notifyLocalized("transferNotification", faction.name, client:Name()) end
            tChar:takeFlags("Z")
        end)
    end
})

if SERVER then
    function MODULE:OnPlayerJoinClass(client, class, oldClass)
        local info = lia.class.list[class]
        local info2 = lia.class.list[oldClass]
        if info then
            if info.OnSet then info:OnSet(client) end
            if oldClass ~= class and info.OnTransferred then info:OnTransferred(client, oldClass) end
        else
            print(L("invalidClassError", tostring(class)))
        end

        if info2 and info2.OnLeave then info2:OnLeave(client) end
        net.Start("classUpdate")
        net.WriteEntity(client)
        net.Broadcast()
    end

    function MODULE:OnTransferred(client)
        local char = client:getChar()
        if char then
            local currentClass = char:getClass()
            if currentClass then
                local classData = lia.class.list[currentClass]
                if not classData or classData.faction ~= client:Team() then char:kickClass() end
            end
        end
    end

    function MODULE:CanPlayerJoinClass(client, class)
        if lia.class.hasWhitelist(class) and not client:hasClassWhitelist(class) then return false end
        return true
    end

    function MODULE:OnCharCreated(_, character)
        local faction = lia.faction.get(character:getFaction())
        local items = faction.items or {}
        for _, item in pairs(items) do
            character:getInv():add(item, 1)
        end
    end

    function MODULE:PlayerLoadedChar(client, character)
        if character:getData("factionKickWarn") then
            client:notifyLocalized("kickedFromFaction")
            hook.Run("OnTransferred", client)
            local faction = lia.faction.indices[client:Team()]
            if faction and faction.OnTransferred then faction:OnTransferred(client) end
            character:setData("factionKickWarn", nil)
        end

        local classIndex = character:getClass()
        local class = lia.class.list[classIndex]
        if character then
            if class and client:Team() == class.faction then
                local oldClass = classIndex
                timer.Simple(.3, function()
                    character:setClass(classIndex)
                    hook.Run("OnPlayerJoinClass", client, classIndex, oldClass)
                end)
            else
                for _, v in pairs(lia.class.list) do
                    if v.faction == client:Team() and v.isDefault then
                        character:setClass(v.index)
                        break
                    end
                end
            end
        end
    end

    local function applyAttributes(client, attr)
        if not attr then return end
        if attr.scale then
            local offset = Vector(0, 0, 64)
            local offsetDuck = Vector(0, 0, 28)
            client:SetViewOffset(offset * attr.scale)
            client:SetViewOffsetDucked(offsetDuck * attr.scale)
            client:SetModelScale(attr.scale)
        else
            client:SetViewOffset(Vector(0, 0, 64))
            client:SetViewOffsetDucked(Vector(0, 0, 28))
            client:SetModelScale(1)
        end

        if attr.runSpeed then
            if attr.runSpeedMultiplier then
                client:SetRunSpeed(math.Round(lia.config.get("RunSpeed") * attr.runSpeed))
            else
                client:SetRunSpeed(attr.runSpeed)
            end
        end

        if attr.walkSpeed then
            if attr.walkSpeedMultiplier then
                client:SetWalkSpeed(math.Round(lia.config.get("WalkSpeed") * attr.walkSpeed))
            else
                client:SetWalkSpeed(attr.walkSpeed)
            end
        end

        if attr.jumpPower then
            if attr.jumpPowerMultiplier then
                client:SetJumpPower(math.Round(client:GetJumpPower() * attr.jumpPower))
            else
                client:SetJumpPower(attr.jumpPower)
            end
        end

        client:SetBloodColor(attr.bloodcolor or BLOOD_COLOR_RED)
        if attr.health then
            client:SetMaxHealth(attr.health)
            client:SetHealth(attr.health)
        end

        if attr.armor then client:SetArmor(attr.armor) end
        if attr.OnSpawn then attr:OnSpawn(client) end
        if attr.weapons then
            if istable(attr.weapons) then
                for _, weapon in ipairs(attr.weapons) do
                    client:Give(weapon, true)
                end
            else
                client:Give(attr.weapons, true)
            end
        end
    end

    local function applyBodyGroups(client, bodyGroups)
        if not bodyGroups or not istable(bodyGroups) then return end
        for name, value in pairs(bodyGroups) do
            local index = client:FindBodygroupByName(name)
            if index > -1 then client:SetBodygroup(index, value) end
        end
    end

    function MODULE:FactionOnLoadout(client)
        local faction = lia.faction.indices[client:Team()]
        if not faction then return end
        applyAttributes(client, faction)
    end

    function MODULE:FactionPostLoadout(client)
        local faction = lia.faction.indices[client:Team()]
        if faction and faction.bodyGroups then applyBodyGroups(client, faction.bodyGroups) end
    end

    function MODULE:CanCharBeTransfered(character, faction)
        if faction.oneCharOnly then
            for _, otherCharacter in next, lia.char.loaded do
                if otherCharacter.steamID == character.steamID and faction.index == otherCharacter:getFaction() then return false, L("charAlreadyInFaction") end
            end
        end
    end

    function MODULE:OnEntityCreated(entity)
        if entity:IsNPC() then
            for _, client in player.Iterator() do
                local character = client:getChar()
                if not character then return end
                local faction = lia.faction.indices[character:getFaction()]
                if faction and faction.NPCRelations then entity:AddEntityRelationship(client, faction.NPCRelations[entity:GetClass()] or D_HT, 0) end
            end
        end
    end

    function MODULE:PlayerSpawn(client)
        local character = client:getChar()
        if not character then return end
        local faction = lia.faction.indices[character:getFaction()]
        local relations = faction and faction.NPCRelations
        if relations then
            for _, entity in ents.Iterator() do
                if entity:IsNPC() and relations[entity:GetClass()] then entity:AddEntityRelationship(client, relations[entity:GetClass()], 0) end
            end
        else
            for _, entity in ents.Iterator() do
                if entity:IsNPC() then entity:AddEntityRelationship(client, D_HT, 0) end
            end
        end
    end

    function MODULE:ClassOnLoadout(client)
        local character = client:getChar()
        if not character then return end
        local classIndex = character:getClass()
        local class = lia.class.list[classIndex]
        if not class or class.faction ~= client:Team() then
            character:kickClass()
            class = lia.class.list[character:getClass()]
        end

        if not class then return end
        applyAttributes(client, class)
        if class.model then client:SetModel(class.model) end
    end

    function MODULE:ClassPostLoadout(client)
        local character = client:getChar()
        local class = lia.class.list[character:getClass()]
        if class and class.bodyGroups then applyBodyGroups(client, class.bodyGroups) end
    end

    net.Receive("KickCharacter", function(_, client)
        local char = client:getChar()
        if not char then return end
        local isLeader = client:IsSuperAdmin() or char:hasFlags("V")
        if not isLeader then return end
        local defaultFaction
        for _, fac in pairs(lia.faction.teams) do
            if fac.isDefault then
                defaultFaction = fac
                break
            end
        end

        if not defaultFaction then
            local _, fac = next(lia.faction.teams)
            defaultFaction = fac
        end

        local characterID = net.ReadUInt(32)
        local IsOnline = false
        for _, target in player.Iterator() do
            local targetChar = target:getChar()
            if targetChar and targetChar:getID() == characterID and targetChar:getFaction() == char:getFaction() then
                IsOnline = true
                local oldFaction = targetChar:getFaction()
                target:notifyLocalized("kickedFromFaction")
                targetChar.vars.faction = defaultFaction.uniqueID
                targetChar:setFaction(defaultFaction.index)
                hook.Run("OnTransferred", target)
                if defaultFaction.OnTransferred then defaultFaction:OnTransferred(target, oldFaction) end
                hook.Run("PlayerLoadout", target)
                targetChar:save()
            end
        end

        if not IsOnline then
            lia.db.updateTable({
                faction = defaultFaction.uniqueID
            }, nil, "characters", "id = " .. characterID)

            lia.char.setCharData(characterID, "factionKickWarn", true)
        end
    end)

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
        local fields = [[lia_characters.name, lia_characters.faction, lia_characters.class, lia_characters.id, lia_characters.steamID, lia_characters.lastJoinTime, lia_players.totalOnlineTime, lia_players.lastOnline]]
        local condition = "lia_characters.schema = '" .. lia.db.escape(SCHEMA.folder) .. "' AND lia_characters.faction = " .. lia.db.convertDataType(facTbl.uniqueID)
        local query = "SELECT " .. fields .. " FROM lia_characters LEFT JOIN lia_players ON lia_characters.steamID = lia_players.steamID WHERE " .. condition
        lia.db.query(query, function(data)
            local out = {}
            for _, v in ipairs(data or {}) do
                local id = tonumber(v.id)
                local online = lia.char.loaded[id] ~= nil
                local lastOnline
                if online then
                    lastOnline = L("onlineNow")
                else
                    local last = tonumber(v.lastOnline)
                    if not isnumber(last) then last = os.time(lia.time.toNumber(v.lastJoinTime)) end
                    local diff = os.time() - last
                    local since = lia.time.TimeSince(last)
                    local stripped = since:match("^(.-)%sago$") or since
                    lastOnline = string.format("%s (%s) ago", stripped, lia.time.SecondsToDHM(diff))
                end

                local classID = tonumber(v.class)
                local className
                if not classID or classID == 0 or v.class == "NULL" then
                    className = "None"
                else
                    className = lia.class.list and lia.class.list[classID] and lia.class.list[classID].name or tostring(classID)
                end

                out[#out + 1] = {
                    id = id,
                    name = v.name,
                    class = className,
                    classID = classID,
                    steamID = toSteamID(v.steamID),
                    lastOnline = lastOnline,
                    hoursPlayed = lia.time.SecondsToDHM(tonumber(v.totalOnlineTime) or 0)
                }
            end

            net.Start("RosterData")
            net.WriteString(facTbl.uniqueID)
            net.WriteTable(out)
            net.Send(client)
        end)
    end)
else
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
        local cols = {L("name"), L("steamID"), L("class"), L("hoursPlayed"), L("lastOnline")}
        for _, c in ipairs(cols) do
            local col = lst:AddColumn(c)
            surface.SetFont(col.Header:GetFont() or "DermaDefault")
            local w = select(1, surface.GetTextSize(c)) + 20
            col:SetWide(w)
            col:SetMinWidth(w)
        end

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

            m:AddOption(L("viewCharacterList"), function() LocalPlayer():ConCommand("say /charlist " .. row.steamID) end)
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
        local joinable = lia.class.retrieveJoinable(ply)
        local char = ply:getChar()
        if not (ply:IsSuperAdmin() or char:hasFlags("V")) then return end
        tabs[L("roster")] = function(panel)
            rosterRows = {}
            lists = {}
            built = false
            buildRoster(panel)
        end

        if #joinable > 0 then
            tabs[L("classes")] = function(panel)
                local pnl = panel:Add("liaClasses")
                pnl:Dock(FILL)
            end
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
end