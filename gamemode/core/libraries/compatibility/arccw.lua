hook.Remove("PlayerSpawn", "ArcCW_SpawnAttInv")
RunConsoleCommand("arccw_override_hud_off", "1")
RunConsoleCommand("arccw_override_crosshair_off", 1)
RunConsoleCommand("arccw_mult_defaultammo", 0)
RunConsoleCommand("arccw_enable_dropping", 0)
RunConsoleCommand("arccw_attinv_free", 0)
RunConsoleCommand("arccw_attinv_loseondie", 0)
RunConsoleCommand("arccw_malfunction", 2)
RunConsoleCommand("arccw_npc_atts", 0)
hook.Remove("PlayerCanPickupWeapon", "ArcCW_PlayerCanPickupWeapon")
hook.Add("ArcCW_OnAttLoad", "ArcCW_OnAttLoad", function(attTable)
    local att = attTable.PrintName
    print("ArcCW is " .. (ArcCWInstalled and "loaded" or "not loaded"))
    local uniqueID = "arccw_att_" .. att
    local item = lia.item.register(uniqueID, "base_arccw_att", false, nil, true)
    item.name = attTable.PrintName or "ArcCW Attachment"
    item.desc = attTable.Description or "An attachment for ArcCW weapons."
    item.model = attTable.DroppedModel or attTable.Model or "models/Items/BoxSRounds.mdl"
    item.category = "attachments"
    item.width = 1
    item.height = 1
    item.att = att
end)