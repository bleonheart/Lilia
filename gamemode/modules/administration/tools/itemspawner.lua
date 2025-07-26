if SERVER then
    local function fixupProp(client, ent, mins, maxs)
        local pos = ent:GetPos()
        local down, up = ent:LocalToWorld(mins), ent:LocalToWorld(maxs)
        local trD = util.TraceLine({
            start = pos,
            endpos = down,
            filter = {ent, client}
        })

        local trU = util.TraceLine({
            start = pos,
            endpos = up,
            filter = {ent, client}
        })

        if trD.Hit and trU.Hit then return end
        if trD.Hit then ent:SetPos(pos + trD.HitPos - down) end
        if trU.Hit then ent:SetPos(pos + trU.HitPos - up) end
    end

    local function tryFixPropPosition(client, ent)
        local m, M = ent:OBBMins(), ent:OBBMaxs()
        fixupProp(client, ent, Vector(m.x, 0, 0), Vector(M.x, 0, 0))
        fixupProp(client, ent, Vector(0, m.y, 0), Vector(0, M.y, 0))
        fixupProp(client, ent, Vector(0, 0, m.z), Vector(0, 0, M.z))
    end

    net.Receive("SpawnMenuSpawnItem", function(_, client)
        local id = net.ReadString()
        if not IsValid(client) or not id or not client:hasPrivilege("Can Use Item Spawner") then return end
        local startPos, dir = client:EyePos(), client:GetAimVector()
        local tr = util.TraceLine({
            start = startPos,
            endpos = startPos + dir * 4096,
            filter = client
        })

        if not tr.Hit then return end
        lia.item.spawn(id, tr.HitPos, function(item)
            local ent = item:getEntity()
            if not IsValid(ent) then return end
            tryFixPropPosition(client, ent)
            undo.Create("item")
            undo.SetPlayer(client)
            undo.AddEntity(ent)
            local name = lia.item.list[id] and lia.item.list[id].name or id
            undo.SetCustomUndoText("Undone " .. name)
            undo.Finish("Item (" .. name .. ")")
            lia.log.add(client, "spawnItem", name, "SpawnMenuSpawnItem")
        end, angle_zero, {})
    end)

    net.Receive("SpawnMenuGiveItem", function(_, client)
        local id, targetID = net.ReadString(), net.ReadString()
        if not IsValid(client) then return end
        if not id then return end
        if not client:hasPrivilege("Can Use Item Spawner") then return end
        local targetChar = lia.char.getBySteamID(targetID)
        local target = targetChar:getPlayer()
        if not targetChar then return end
        targetChar:getInv():add(id)
        lia.log.add(client, "chargiveItem", id, target, "SpawnMenuGiveItem")
    end)
else
    spawnmenu.AddContentType("inventoryitem", function(container, data)
        local client = LocalPlayer()
        if not client:hasPrivilege("Can Use Item Spawner") then return end
        local icon = vgui.Create("ContentIcon", container)
        icon:SetContentType("inventoryitem")
        icon:SetSpawnName(data.id)
        icon:SetName(data.name)
        local itemData = lia.item.list[data.id]
        local model = itemData.model or "default.mdl"
        local matName = string.Replace(model, ".mdl", "")
        icon.Image:SetMaterial(Material("spawnicons/" .. matName .. ".png"))
        icon:SetColor(Color(205, 92, 92, 255))
        icon:SetTooltip(lia.darkrp.textWrap(itemData.desc or "", "DermaDefault", 560))
        icon.DoClick = function()
            net.Start("SpawnMenuSpawnItem")
            net.WriteString(data.id)
            net.SendToServer()
            surface.PlaySound("outlands-rp/ui/ui_return.wav")
        end

        icon.OpenMenu = function()
            local menu = DermaMenu()
            menu:AddOption(L("copy"), function() SetClipboardText(icon:GetSpawnName()) end):SetIcon("icon16/page_copy.png")
            menu:AddOption(L("giveToCharacter"), function()
                local popup = vgui.Create("DFrame")
                popup:SetTitle(L("spawnItemTitle", data.id))
                popup:SetSize(300, 100)
                popup:Center()
                popup:MakePopup()
                local label = vgui.Create("DLabel", popup)
                label:Dock(TOP)
                label:SetText(L("giveTo"))
                local combo = vgui.Create("DComboBox", popup)
                combo:Dock(TOP)
                for _, character in pairs(lia.char.getAll()) do
                    local ply = character:getPlayer()
                    if IsValid(ply) then
                        local steamID = ply:SteamID() or ""
                        local name = character:getName() or L("unknown")
                        combo:AddChoice(string.format("[%s] [%s]", name, steamID), steamID)
                    end
                end

                local button = vgui.Create("liaSmallButton", popup)
                button:Dock(BOTTOM)
                button:SetText(L("spawnItem"))
                button.DoClick = function()
                    local _, target = combo:GetSelected()
                    net.Start("SpawnMenuGiveItem")
                    net.WriteString(data.id)
                    net.WriteString(target or "")
                    net.SendToServer()
                    popup:Remove()
                end
            end)

            menu:Open()
        end

        container:Add(icon)
        return icon
    end)

    function MODULE:PopulateInventoryItems(pnlContent, tree)
        local allItems = lia.item.list
        local categorized = {
            Unsorted = {}
        }

        for uniqueID, itemData in pairs(allItems) do
            if itemData.category then
                categorized[itemData.category] = categorized[itemData.category] or {}
                table.insert(categorized[itemData.category], {
                    id = uniqueID,
                    name = itemData.name
                })
            else
                table.insert(categorized.Unsorted, {
                    id = uniqueID,
                    name = itemData.name
                })
            end
        end

        for category, itemList in SortedPairs(categorized) do
            if category ~= "Unsorted" or #itemList > 0 then
                local node = tree:AddNode(category == "Unsorted" and L("unsorted") or L(category), "icon16/picture.png")
                node.DoPopulate = function(btn)
                    if btn.PropPanel then return end
                    btn.PropPanel = vgui.Create("ContentContainer", pnlContent)
                    btn.PropPanel:SetVisible(false)
                    btn.PropPanel:SetTriggerSpawnlistChange(false)
                    for _, itemListData in SortedPairsByMemberValue(itemList, "name") do
                        spawnmenu.CreateContentIcon("inventoryitem", btn.PropPanel, {
                            name = itemListData.name,
                            id = itemListData.id
                        })
                    end
                end

                node.DoClick = function(btn)
                    btn:DoPopulate()
                    pnlContent:SwitchPanel(btn.PropPanel)
                end
            end
        end
    end

    spawnmenu.AddCreationTab(L("inventoryItems"), function()
        local client = LocalPlayer()
        if not IsValid(client) or not client.hasPrivilege or not client:hasPrivilege("Can Use Item Spawner") then
            local pnl = vgui.Create("DPanel")
            pnl:Dock(FILL)
            pnl.Paint = function(_, w, h) draw.SimpleText(L("noItemSpawnerPermission"), "DermaDefault", w / 2, h / 2, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
            return pnl
        else
            local ctrl = vgui.Create("SpawnmenuContentPanel")
            ctrl:CallPopulateHook("PopulateInventoryItems")
            return ctrl
        end
    end, "icon16/briefcase.png")
end