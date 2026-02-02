lia.bootstrap("ArcCW", "Loading ArcCW compatibility...")
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
hook.Add("ArcCW_OnAttLoad", "Lilia_ArcCW_OnAttLoad", function(attTable)
    local id = attTable.ShortName
    print("[ArcCW] Processing attachment: " .. id)
    if not id then return end
    local uniqueID = "arccw_att_" .. id:lower()
    print("[ArcCW] Registering attachment item: " .. uniqueID)
    local item = lia.item.register(uniqueID, "base_arccw_att", false, nil, true)
    item.name = attTable.PrintName or id
    item.desc = attTable.Description or "An attachment for ArcCW weapons."
    item.model = attTable.DroppedModel or attTable.Model or "models/Items/BoxSRounds.mdl"
    item.category = "attachments"
    item.width = 1
    item.height = 1
    item.att = id
    for k, v in pairs(attTable) do
        if isstring(k) and not isfunction(v) and (k:find("^Mult_") or k:find("^Add_") or k:find("^Override_") or k:find("^HP_") or k == "Health" or k == "Slot" or k == "AbbrevName" or k == "Desc_Pros" or k == "Desc_Cons" or k == "Desc_Neutrals" or k == "SortOrder" or k == "AutoStats" or k == "ToggleStats" or k == "GivesFlags" or k == "RequiredFlags" or k == "ExcludeFlags" or k == "ActivateElements") then item[k] = v end
    end

    if attTable.Icon then
        if isstring(attTable.Icon) then
            item.icon = attTable.Icon
        elseif type(attTable.Icon) == "IMaterial" then
            item.icon = attTable.Icon:GetName()
        end
    end
end)