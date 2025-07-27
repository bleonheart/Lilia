net.Receive("SpawnMenuSpawnItem", function(_, client)
    if not IsValid(client) then return end
    local id = net.ReadString()
    if not id or not client:hasPrivilege("Can Use Item Spawner") then return end
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
        ent:SetCreator(client)
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
    if not IsValid(client) then return end
    local id, targetID = net.ReadString(), net.ReadString()
    if not id or not client:hasPrivilege("Can Use Item Spawner") then return end
    local targetChar = lia.char.getBySteamID(targetID)
    if not targetChar then return end
    local target = targetChar:getPlayer()
    targetChar:getInv():add(id)
    lia.log.add(client, "chargiveItem", id, target, "SpawnMenuGiveItem")
end)


