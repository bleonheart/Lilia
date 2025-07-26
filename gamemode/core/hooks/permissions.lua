local defaultUserTools = {
    remover = true,
}

function MODULE:InitializedModules()
    if properties.List then
        for name in pairs(properties.List) do
            if name ~= "persist" and name ~= "drive" and name ~= "bonemanipulate" then
                local privilege = "Access Property " .. name:gsub("^%l", string.upper)
                if not lia.admin.privileges[privilege] then
                    lia.admin.registerPrivilege({
                        Name = privilege,
                        MinAccess = "admin",
                        Category = "Properties"
                    })
                end
            end
        end
    end

    for _, wep in ipairs(weapons.GetList()) do
        if wep.ClassName == "gmod_tool" and wep.Tool then
            for tool in pairs(wep.Tool) do
                local privilege = "Access Tool " .. tool:gsub("^%l", string.upper)
                if not lia.admin.privileges[privilege] then
                    lia.admin.registerPrivilege({
                        Name = privilege,
                        MinAccess = defaultUserTools[string.lower(tool)] and "user" or "admin",
                        Category = "Tools"
                    })
                end
            end
        end
    end
end

lia.flag.add("p", "Access to the physgun.", function(client, isGiven)
    if isGiven then
        client:Give("weapon_physgun")
        client:SelectWeapon("weapon_physgun")
    else
        client:StripWeapon("weapon_physgun")
    end
end)

lia.flag.add("t", "Access to the toolgun", function(client, isGiven)
    if isGiven then
        client:Give("gmod_tool")
        client:SelectWeapon("gmod_tool")
    else
        client:StripWeapon("gmod_tool")
    end
end)

lia.flag.add("C", "Access to spawn vehicles.")
lia.flag.add("z", "Access to spawn SWEPS.")
lia.flag.add("E", "Access to spawn SENTs.")
lia.flag.add("L", "Access to spawn Effects.")
lia.flag.add("r", "Access to spawn ragdolls.")
lia.flag.add("e", "Access to spawn props.")
lia.flag.add("n", "Access to spawn NPCs.")
lia.flag.add("V", "Access to manage your faction roster.")
properties.Add("ToggleCarBlacklist", {
    MenuLabel = L("ToggleCarBlacklist"),
    Order = 901,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply) return IsValid(ent) and (ent:IsVehicle() or ent:isSimfphysCar()) and ply:hasPrivilege("Manage Car Blacklist") end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetModel())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("Manage Car Blacklist") then return end
        local model = net.ReadString()
        local list = lia.data.get("carBlacklist", {})
        if table.HasValue(list, model) then
            table.RemoveByValue(list, model)
            lia.data.set("carBlacklist", list, true, true)
            ply:notifyLocalized("removedFromBlacklist", model)
        else
            table.insert(list, model)
            lia.data.set("carBlacklist", list, true, true)
            ply:notifyLocalized("addedToBlacklist", model)
        end
    end
})

properties.Add("ToggleEntityBlacklist", {
    MenuLabel = L("ToggleEntityBlacklist"),
    Order = 902,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply) return IsValid(ent) and not ent:IsVehicle() and ent:GetClass() ~= "prop_physics" and ply:hasPrivilege("Manage Entity Blacklist") end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetClass())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("Manage Entity Blacklist") then return end
        local class = net.ReadString()
        local list = lia.data.get("entityBlacklist", {})
        if table.HasValue(list, class) then
            table.RemoveByValue(list, class)
            lia.data.set("entityBlacklist", list, true, true)
            ply:notifyLocalized("removedFromBlacklist", class)
        else
            table.insert(list, class)
            lia.data.set("entityBlacklist", list, true, true)
            ply:notifyLocalized("addedToBlacklist", class)
        end
    end
})

if SERVER then
    local GM = GM or GAMEMODE
    local resetCalled = 0
    local restrictedProperties = {
        persist = true,
        drive = true,
        bonemanipulate = true
    }

    function GM:PlayerSpawnProp(client, model)
        local list = lia.data.get("prop_blacklist") or {}
        local lowerModel = string.lower(model)
        for _, black in ipairs(list) do
            if string.lower(black) == lowerModel then
                if not client:hasPrivilege("Can Spawn Blacklisted Props") then
                    lia.log.add(client, "spawnDenied", "prop", model)
                    client:notifyLocalized("blacklistedProp")
                    return false
                end

                break
            end
        end

        local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn Props") or client:getChar():hasFlags("e")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "prop", model)
            client:notifyLocalized("noSpawnPropsPerm")
        end
        return canSpawn
    end

    function GM:CanProperty(client, property, entity)
        if restrictedProperties[property] then
            lia.log.add(client, "permissionDenied", "use property " .. property)
            client:notifyLocalized("disabledFeature")
            return false
        end

        if entity:IsWorld() and IsValid(entity) then
            if client:hasPrivilege("Can Property World Entities") then return true end
            lia.log.add(client, "permissionDenied", "modify world property " .. property)
            client:notifyLocalized("noModifyWorldEntities")
            return false
        end

        if entity:GetCreator() == client and (property == "remover" or property == "collision") then return true end
        if client:IsSuperAdmin() or client:hasPrivilege("Access Property " .. property:gsub("^%l", string.upper)) and client:isStaffOnDuty() then return true end
        lia.log.add(client, "permissionDenied", "modify property " .. property)
        client:notifyLocalized("noModifyProperty")
        return false
    end

    function GM:DrawPhysgunBeam(client)
        if client:isNoClipping() then return false end
    end

    function GM:PhysgunPickup(client, entity)
        if (client:hasPrivilege("Physgun Pickup") or client:isStaffOnDuty()) and entity.NoPhysgun then
            if not client:hasPrivilege("Physgun Pickup on Restricted Entities") then
                lia.log.add(client, "permissionDenied", "physgun restricted entity")
                client:notifyLocalized("noPickupRestricted")
                return false
            end
            return true
        end

        if client:IsSuperAdmin() then return true end
        if entity:GetCreator() == client and (entity:isProp() or entity:isItem()) then return true end
        if client:hasPrivilege("Physgun Pickup") then
            if entity:IsVehicle() then
                if not client:hasPrivilege("Physgun Pickup on Vehicles") then
                    lia.log.add(client, "permissionDenied", "physgun vehicle")
                    client:notifyLocalized("noPickupVehicles")
                    return false
                end
                return true
            elseif entity:IsPlayer() then
                if entity:hasPrivilege("Can't be Grabbed with PhysGun") or not client:hasPrivilege("Can Grab Players") then
                    lia.log.add(client, "permissionDenied", "physgun player")
                    client:notifyLocalized("noPickupPlayer")
                    return false
                end
                return true
            elseif entity:IsWorld() or entity:CreatedByMap() then
                if not client:hasPrivilege("Can Grab World Props") then
                    lia.log.add(client, "permissionDenied", "physgun world prop")
                    client:notifyLocalized("noPickupWorld")
                    return false
                end
                return true
            end
            return true
        end

        lia.log.add(client, "permissionDenied", "physgun entity")
        client:notifyLocalized("noPickupEntity")
        return false
    end

    function GM:PlayerSpawnVehicle(client, model)
        if not client:hasPrivilege("No Car Spawn Delay") then client.NextVehicleSpawn = SysTime() + lia.config.get("PlayerSpawnVehicleDelay", 30) end
        local list = lia.data.get("carBlacklist")
        if model and table.HasValue(list, model) and not client:hasPrivilege("Can Spawn Blacklisted Cars") then
            lia.log.add(client, "spawnDenied", "vehicle", model)
            client:notifyLocalized("blacklistedVehicle")
            return false
        end

        local canSpawn = client:isStaffOnDuty() or client:hasPrivilege("Can Spawn Cars") or client:getChar():hasFlags("C")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "vehicle", model)
            client:notifyLocalized("noSpawnVehicles")
        end
        return canSpawn
    end

    function GM:PlayerNoClip(ply, enabled)
        if not (ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")) then
            lia.log.add(ply, "permissionDenied", "noclip")
            ply:notifyLocalized("noNoclip")
            return false
        end

        ply:DrawShadow(not enabled)
        ply:SetNoTarget(enabled)
        ply:AddFlags(FL_NOTARGET)
        hook.Run("OnPlayerObserve", ply, enabled)
        lia.log.add(ply, "observeToggle", enabled and "enabled" or "disabled")
        return true
    end

    function GM:PlayerSpawnEffect(client)
        local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn Effects") or client:getChar():hasFlags("L")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "effect")
            client:notifyLocalized("noSpawnEffects")
        end
        return canSpawn
    end

    function GM:PlayerSpawnNPC(client)
        local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn NPCs") or client:getChar():hasFlags("n")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "npc")
            client:notifyLocalized("noSpawnNPCs")
        end
        return canSpawn
    end

    function GM:PlayerSpawnRagdoll(client)
        local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn Ragdolls") or client:getChar():hasFlags("r")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "ragdoll")
            client:notifyLocalized("noSpawnRagdolls")
        end
        return canSpawn
    end

    function GM:PlayerSpawnSENT(client, class)
        local list = lia.data.get("entityBlacklist", {})
        if class and table.HasValue(list, class) and not client:hasPrivilege("Can Spawn Blacklisted Entities") then
            lia.log.add(client, "spawnDenied", "sent", class)
            client:notifyLocalized("blacklistedEntity")
            return false
        end

        local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn SENTs") or client:getChar():hasFlags("E")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "sent")
            client:notifyLocalized("noSpawnSents")
        end
        return canSpawn
    end

    function GM:PlayerSpawnSWEP(client, swep)
        local canSpawn = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn SWEPs") or client:getChar():hasFlags("z")
        if not canSpawn then
            lia.log.add(client, "spawnDenied", "swep", tostring(swep))
            client:notifyLocalized("noSpawnSweps")
        end

        if canSpawn then lia.log.add(client, "swep_spawning", swep) end
        return canSpawn
    end

    function GM:PlayerGiveSWEP(client, swep)
        local canGive = client:IsSuperAdmin() or client:isStaffOnDuty() or client:hasPrivilege("Can Spawn SWEPs") or client:getChar():hasFlags("W")
        if not canGive then
            lia.log.add(client, "permissionDenied", "give swep")
            client:notifyLocalized("noGiveSweps")
        end

        if canGive then lia.log.add(client, "swep_spawning", swep) end
        return canGive
    end

    function GM:OnPhysgunReload(_, client)
        local canReload = client:hasPrivilege("Can Physgun Reload")
        if not canReload then
            lia.log.add(client, "permissionDenied", "physgun reload")
            client:notifyLocalized("noPhysgunReload")
        end
        return canReload
    end

    local DisallowedTools = {
        rope = true,
        light = true,
        lamp = true,
        dynamite = true,
        physprop = true,
        faceposer = true,
        stacker = true
    }

    function GM:CanTool(client, _, tool)
        local function CheckDuplicationScale(ply, entities)
            entities = entities or {}
            for _, v in pairs(entities) do
                if v.ModelScale and v.ModelScale > 10 then
                    ply:notifyLocalized("duplicationSizeLimit")
                    lia.log.add(ply, "dupeCrashAttempt")
                    return false
                end

                v.ModelScale = 1
            end
            return true
        end

        if DisallowedTools[tool] and not client:IsSuperAdmin() then
            lia.log.add(client, "toolDenied", tool)
            client:notifyLocalized("toolNotAllowed", tool)
            return false
        end

        local privilege = "Access Tool " .. tool:gsub("^%l", string.upper)
        local isSuperAdmin = client:IsSuperAdmin()
        local isStaffOrFlagged = client:isStaffOnDuty() or client:getChar():hasFlags("t")
        local hasPriv = client:hasPrivilege(privilege)
        if not isSuperAdmin and not (isStaffOrFlagged and hasPriv) then
            local reasons = {}
            if not isSuperAdmin then table.insert(reasons, "SuperAdmin") end
            if not isStaffOrFlagged then table.insert(reasons, "On-duty staff or flag 't'") end
            if not hasPriv then table.insert(reasons, "Privilege '" .. privilege .. "'") end
            lia.log.add(client, "toolDenied", tool)
            client:notifyLocalized("toolNoPermission", tool, table.concat(reasons, ", "))
            return false
        end

        local entity = client:getTracedEntity()
        if IsValid(entity) then
            local entClass = entity:GetClass()
            if tool == "remover" then
                if entity.NoRemover then
                    if not client:hasPrivilege("Can Remove Blocked Entities") then
                        lia.log.add(client, "permissionDenied", "remove blocked entity")
                        client:notifyLocalized("noRemoveBlockedEntities")
                        return false
                    end
                    return true
                elseif entity:IsWorld() then
                    if not client:hasPrivilege("Can Remove World Entities") then
                        lia.log.add(client, "permissionDenied", "remove world entity")
                        client:notifyLocalized("noRemoveWorldEntities")
                        return false
                    end
                    return true
                end
                return true
            end

            if (tool == "permaall" or tool == "blacklistandremove") and hook.Run("CanPersistEntity", entity) ~= false and (string.StartWith(entClass, "lia_") or entity:isLiliaPersistent() or entity:CreatedByMap()) then
                lia.log.add(client, "toolDenied", tool)
                client:notifyLocalized("toolCantUseEntity", tool)
                return false
            end

            if (tool == "duplicator" or tool == "blacklistandremove") and entity.NoDuplicate then
                lia.log.add(client, "toolDenied", tool)
                client:notifyLocalized("cannotDuplicateEntity", tool)
                return false
            end

            if tool == "weld" and entClass == "sent_ball" then
                lia.log.add(client, "toolDenied", tool)
                client:notifyLocalized("cannotWeldBall")
                return false
            end
        end

        if tool == "duplicator" and client.CurrentDupe and not CheckDuplicationScale(client, client.CurrentDupe.Entities) then return false end
        lia.log.add(client, "toolgunUse", tool)
        return true
    end

    function GM:PlayerSpawnedNPC(client, entity)
        entity:SetCreator(client)
        lia.log.add(client, "spawned_npc", entity:GetClass(), entity:GetModel())
    end

    function GM:PlayerSpawnedEffect(client, _, entity)
        entity:SetCreator(client)
        lia.log.add(client, "spawned_effect", entity:GetModel())
    end

    function GM:PlayerSpawnedProp(client, _, entity)
        entity:SetCreator(client)
        lia.log.add(client, "spawned_prop", entity:GetModel())
    end

    function GM:PlayerSpawnedRagdoll(client, _, entity)
        entity:SetCreator(client)
        lia.log.add(client, "spawned_ragdoll", entity:GetModel())
    end

    function GM:PlayerSpawnedSENT(client, entity)
        entity:SetCreator(client)
        lia.log.add(client, "spawned_sent", entity:GetClass(), entity:GetModel())
    end

    function GM:PlayerSpawnedSWEP(client, entity)
        entity:SetCreator(client)
        lia.log.add(client, "swep_spawning", entity:GetClass())
    end

    function GM:PlayerSpawnedVehicle(client, entity)
        entity:SetCreator(client)
        lia.log.add(client, "spawned_vehicle", entity:GetClass(), entity:GetModel())
    end
else
    local ESP_DrawnEntities = {
        lia_bodygrouper = true,
        lia_vendor = true,
    }

    function MODULE:PrePlayerDraw(client)
        if not IsValid(client) then return end
        if client:isNoClipping() then return true end
    end

    function MODULE:HUDPaint()
        local client = LocalPlayer()
        if not client:getChar() or not client:IsValid() or not client:IsPlayer() then return end
        if not client:isNoClipping() then return end
        if not (client:hasPrivilege("No Clip ESP Outside Staff Character") or client:isStaffOnDuty()) then return end
        local marginx, marginy = ScrW() * 0.1, ScrH() * 0.1
        local maxDistanceSq = 4096
        for _, ent in ents.Iterator() do
            if not IsValid(ent) or ent == client then continue end
            local entityType, label, nameLabel
            if ent:IsPlayer() then
                entityType = "Players"
                if ent:getNetVar("cheater") then
                    label = "CHEATER"
                    nameLabel = ent:Name():gsub("#", "\226\128\139#")
                else
                    label = ent:Name():gsub("#", "\226\128\139#")
                end
            elseif ent.isItem and ent:isItem() and lia.option.get("espItems") then
                entityType = "Items"
                local itemTable = ent.getItemTable and ent:getItemTable()
                label = L("itemESPLabel", itemTable and itemTable.name or L("unknown"))
            elseif ent.isProp and ent:isProp() and lia.option.get("espProps") then
                entityType = "Props"
                label = L("propModelESPLabel", ent:GetModel() or L("unknown"))
            elseif ESP_DrawnEntities[ent:GetClass()] and lia.option.get("espEntities") then
                entityType = "Entities"
                label = L("entityClassESPLabel", ent:GetClass() or L("unknown"))
            end

            if not entityType then continue end
            local vPos, clientPos = ent:GetPos(), client:GetPos()
            if not vPos or not clientPos then continue end
            local scrPos = vPos:ToScreen()
            if not scrPos.visible then continue end
            local distanceSq = clientPos:DistToSqr(vPos)
            local factor = 1 - math.Clamp(distanceSq / maxDistanceSq, 0, 1)
            local size = math.max(20, 48 * factor)
            local alpha = math.Clamp(255 * factor, 120, 255)
            local cheater = ent:getNetVar("cheater", false)
            local colorToUse = ColorAlpha(lia.config.get("esp" .. entityType .. "Color") or Color(255, 255, 255), alpha)
            if cheater then colorToUse = ColorAlpha(Color(255, 0, 0), alpha) end
            local x, y = math.Clamp(scrPos.x, marginx, ScrW() - marginx), math.Clamp(scrPos.y, marginy, ScrH() - marginy)
            surface.SetDrawColor(colorToUse.r, colorToUse.g, colorToUse.b, colorToUse.a)
            surface.DrawRect(x - size / 2, y - size / 2, size, size)
            surface.SetFont("liaMediumFont")
            local _, lineH = surface.GetTextSize("W")
            if nameLabel then
                draw.SimpleTextOutlined(label, "liaMediumFont", x, y - size - lineH / 2, ColorAlpha(colorToUse, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
                draw.SimpleTextOutlined(nameLabel, "liaMediumFont", x, y - size + lineH / 2, ColorAlpha(colorToUse, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
            else
                draw.SimpleTextOutlined(label, "liaMediumFont", x, y - size, ColorAlpha(colorToUse, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
            end
        end
    end

    local function populateCharTable(panel, columns, rows)
        if not IsValid(panel) then return nil end
        panel:Clear()
        local listView = vgui.Create("DListView", panel)
        listView:Dock(FILL)
        local totalFixedWidth, dynamicColumns = 0, 0
        for _, colInfo in ipairs(columns) do
            if colInfo.width then
                totalFixedWidth = totalFixedWidth + colInfo.width
            else
                dynamicColumns = dynamicColumns + 1
            end
        end

        local availableWidth = panel:GetWide() - totalFixedWidth
        local dynamicWidth = dynamicColumns > 0 and math.max(availableWidth / dynamicColumns, 50) or 0
        for _, colInfo in ipairs(columns) do
            local columnName = colInfo.name or L("na")
            local column = listView:AddColumn(columnName)
            local columnWidth = colInfo.width or dynamicWidth
            surface.SetFont(column.Header:GetFont() or "DermaDefault")
            local textWidth = select(1, surface.GetTextSize(columnName)) + 20
            local finalWidth = math.max(columnWidth, textWidth)
            column:SetWide(finalWidth)
            column:SetMinWidth(textWidth)
        end

        for _, row in ipairs(rows) do
            local lineData = {}
            for _, colInfo in ipairs(columns) do
                local fieldName = colInfo.field or colInfo.name
                table.insert(lineData, row[fieldName] or L("na"))
            end

            local line = listView:AddLine(unpack(lineData))
            line.rowData = row
        end
        return listView
    end

    net.Receive("DisplayCharList", function()
        local sendData = net.ReadTable()
        local targetSteamIDsafe = net.ReadString()
        local extraColumns, extraOrder = {}, {}
        for _, v in pairs(sendData or {}) do
            if istable(v.extraDetails) then
                for k in pairs(v.extraDetails) do
                    if not extraColumns[k] then
                        extraColumns[k] = true
                        table.insert(extraOrder, k)
                    end
                end
            end
        end

        local columns = {
            {
                name = "ID",
                field = "ID"
            },
            {
                name = "SteamID",
                field = "SteamID"
            },
            {
                name = "Name",
                field = "Name"
            },
            {
                name = "Desc",
                field = "Desc"
            },
            {
                name = "Faction",
                field = "Faction"
            },
            {
                name = "Banned",
                field = "Banned"
            },
            {
                name = "BanningAdminName",
                field = "BanningAdminName"
            },
            {
                name = "BanningAdminSteamID",
                field = "BanningAdminSteamID"
            },
            {
                name = "BanningAdminRank",
                field = "BanningAdminRank"
            },
            {
                name = "CharMoney",
                field = "Money"
            },
            {
                name = "LastUsed",
                field = "LastUsed"
            },
            {
                name = "LastOnline",
                field = "LastOnline"
            }
        }

        for _, name in ipairs(extraOrder) do
            table.insert(columns, {
                name = name,
                field = name
            })
        end

        if lia.gui.charList and lia.gui.charList.panels and IsValid(lia.gui.charList.panels[targetSteamIDsafe]) then
            local listView = populateCharTable(lia.gui.charList.panels[targetSteamIDsafe], columns, sendData)
            if IsValid(listView) then
                for _, line in ipairs(listView:GetLines()) do
                    local dataIndex = line:GetID()
                    local rowData = sendData[dataIndex]
                    if rowData and rowData.Banned == "Yes" then
                        line.DoPaint = line.Paint
                        line.Paint = function(pnl, w, h)
                            surface.SetDrawColor(200, 100, 100)
                            surface.DrawRect(0, 0, w, h)
                            pnl:DoPaint(w, h)
                        end
                    end

                    line.CharID = rowData and rowData.ID
                    if rowData and rowData.extraDetails then
                        local colIndex = 13
                        for _, name in ipairs(extraOrder) do
                            line:SetColumnText(colIndex, tostring(rowData.extraDetails[name] or ""))
                            colIndex = colIndex + 1
                        end
                    end
                end

                listView.OnRowRightClick = function(_, _, ln)
                    if not IsValid(ln) then return end
                    local menu = DermaMenu()
                    if ln.rowData then
                        menu:AddOption(L("copyRow"), function()
                            local rowString = ""
                            for key, value in pairs(ln.rowData) do
                                rowString = rowString .. tostring(key) .. ": " .. tostring(value) .. " | "
                            end

                            rowString = rowString:sub(1, -4)
                            SetClipboardText(rowString)
                        end):SetIcon("icon16/page_copy.png")
                    end

                    if ln.CharID then
                        local online = ln.rowData and (ln.rowData.LastUsed == L("onlineNow") or ln.rowData.LastOnline == L("onlineNow"))
                        if online then
                            if LocalPlayer():hasPrivilege("Manage Characters") then
                                menu:AddOption(L("banCharacter"), function() LocalPlayer():ConCommand([[say "/charban ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/cancel.png")
                                menu:AddOption(L("unbanCharacter"), function() LocalPlayer():ConCommand([[say "/charunban ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/accept.png")
                            end
                        else
                            if LocalPlayer():hasPrivilege("Unban Offline") then menu:AddOption(L("banCharacter"), function() LocalPlayer():ConCommand([[say "/charbanoffline ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/cancel.png") end
                            if LocalPlayer():hasPrivilege("Ban Offline") then menu:AddOption(L("unbanCharacter"), function() LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/accept.png") end
                        end
                    end

                    menu:Open()
                end
            end
        else
            local _, listView = lia.util.CreateTableUI("Charlist for SteamID64: " .. targetSteamIDsafe, columns, sendData)
            if IsValid(listView) then
                for _, line in ipairs(listView:GetLines()) do
                    local dataIndex = line:GetID()
                    local rowData = sendData[dataIndex]
                    if rowData and rowData.Banned == "Yes" then
                        line.DoPaint = line.Paint
                        line.Paint = function(pnl, w, h)
                            surface.SetDrawColor(200, 100, 100)
                            surface.DrawRect(0, 0, w, h)
                            pnl:DoPaint(w, h)
                        end
                    end

                    line.CharID = rowData and rowData.ID
                    if rowData and rowData.extraDetails then
                        local colIndex = 13
                        for _, name in ipairs(extraOrder) do
                            line:SetColumnText(colIndex, tostring(rowData.extraDetails[name] or ""))
                            colIndex = colIndex + 1
                        end
                    end
                end

                listView.OnRowRightClick = function(_, _, ln)
                    if not IsValid(ln) then return end
                    local menu = DermaMenu()
                    if ln.rowData then
                        menu:AddOption(L("copyRow"), function()
                            local rowString = ""
                            for key, value in pairs(ln.rowData) do
                                rowString = rowString .. tostring(key) .. ": " .. tostring(value) .. " | "
                            end

                            rowString = rowString:sub(1, -4)
                            SetClipboardText(rowString)
                        end):SetIcon("icon16/page_copy.png")
                    end

                    if ln.CharID then
                        local online = ln.rowData and (ln.rowData.LastUsed == L("onlineNow") or ln.rowData.LastOnline == L("onlineNow"))
                        if online then
                            if LocalPlayer():hasPrivilege("Manage Characters") then
                                menu:AddOption(L("banCharacter"), function() LocalPlayer():ConCommand([[say "/charban ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/cancel.png")
                                menu:AddOption(L("unbanCharacter"), function() LocalPlayer():ConCommand([[say "/charunban ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/accept.png")
                            end
                        else
                            if LocalPlayer():hasPrivilege("Unban Offline") then menu:AddOption(L("banCharacter"), function() LocalPlayer():ConCommand([[say "/charbanoffline ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/cancel.png") end
                            if LocalPlayer():hasPrivilege("Ban Offline") then menu:AddOption(L("unbanCharacter"), function() LocalPlayer():ConCommand([[say "/charunbanoffline ]] .. ln.CharID .. [["]]) end):SetIcon("icon16/accept.png") end
                        end
                    end

                    menu:Open()
                end
            end
        end
    end)

    hook.Add("liaAdminRegisterTab", "AdminTabCharList", function(tabs)
        local function canShow()
            local ply = LocalPlayer()
            return IsValid(ply) and ply:hasPrivilege("Access Character List Tab") and ply:hasPrivilege("List Characters")
        end

        tabs[L("characterList")] = {
            icon = "icon16/user_gray.png",
            onShouldShow = canShow,
            build = function(sheet)
                local pnl = vgui.Create("DPanel", sheet)
                pnl:DockPadding(10, 10, 10, 10)
                lia.gui.charList = pnl
                local psheet = vgui.Create("DPropertySheet", pnl)
                psheet:Dock(FILL)
                lia.gui.charList.sheet = psheet
                lia.gui.charList.panels = {}
                for _, ply in ipairs(player.GetAll()) do
                    local sub = vgui.Create("DPanel", psheet)
                    sub:Dock(FILL)
                    sub.Paint = function() end
                    psheet:AddSheet(ply:SteamName(), sub, "icon16/user.png")
                    lia.gui.charList.panels[ply:SteamID64()] = sub
                    net.Start("liaRequestCharList")
                    net.WriteString(ply:SteamID64())
                    net.SendToServer()
                end

                local allPanel = vgui.Create("DPanel", psheet)
                allPanel:Dock(FILL)
                allPanel.Paint = function() end
                psheet:AddSheet("Database", allPanel, "icon16/database.png")
                lia.gui.charList.panels["all"] = allPanel
                net.Start("liaRequestAllCharList")
                net.SendToServer()
                return pnl
            end
        }
    end)
end