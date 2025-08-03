lia.config.add("SpawnMenuLimit", L("spawnMenuLimit"), false, nil, {
    desc = L("spawnMenuLimitDesc"),
    category = L("categorySpawnGeneral"),
    type = "Boolean"
})

lia.option.add("espEnabled", "ESP Enabled", "Toggle ESP features", false, nil, {
    category = "ESP",
    isQuick = true,
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espPlayers", "ESP Players", "Enable ESP for players", false, nil, {
    category = "ESP",
    isQuick = true,
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espItems", "ESP Items", "Enable ESP for items", false, nil, {
    category = "ESP",
    isQuick = true,
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espProps", "ESP Props", "Enable ESP for props", false, nil, {
    category = "ESP",
    isQuick = true,
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espEntities", "ESP Entities", "Enable ESP for entities", false, nil, {
    category = "ESP",
    isQuick = true,
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espUnconfiguredDoors", "ESP Unconfigured Doors", "Enable ESP for doors without configuration", false, nil, {
    category = "ESP",
    isQuick = true,
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espItemsColor", "ESP Items Color", "Sets the ESP color for items", {
    r = 0,
    g = 255,
    b = 0,
    a = 255
}, nil, {
    category = "ESP",
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espEntitiesColor", "ESP Entities Color", "Sets the ESP color for entities", {
    r = 255,
    g = 255,
    b = 0,
    a = 255
}, nil, {
    category = "ESP",
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espPropsColor", "ESP Props Color", "Sets the ESP color for props", {
    r = 255,
    g = 0,
    b = 0,
    a = 255
}, nil, {
    category = "ESP",
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espUnconfiguredDoorsColor", "ESP Unconfigured Doors Color", "Sets the ESP color for unconfigured doors", {
    r = 255,
    g = 0,
    b = 255,
    a = 255
}, nil, {
    category = "ESP",
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("espPlayersColor", "ESP Players Color", "Sets the ESP color for players", {
    r = 0,
    g = 0,
    b = 255,
    a = 255
}, nil, {
    category = "ESP",
    visible = function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end
        return ply:isStaffOnDuty() or ply:hasPrivilege("No Clip Outside Staff Character")
    end
})

lia.option.add("BarsAlwaysVisible", L("barsAlwaysVisible"), L("barsAlwaysVisibleDesc"), false, nil, {
    category = L("categoryGeneral"),
    isQuick = true,
})

lia.option.add("descriptionWidth", L("descriptionWidth"), L("descriptionWidthDesc"), 0.5, nil, {
    category = L("categoryHUD"),
    min = 0.1,
    max = 1,
    decimals = 2
})

lia.option.add("thirdPersonEnabled", "Enabled", "Toggle third-person view.", false, function(_, newValue) hook.Run("thirdPersonToggled", newValue) end, {
    category = "Third Person",
    isQuick = true,
})

lia.option.add("thirdPersonClassicMode", "Classic Mode", "Enable classic third-person view mode.", false, nil, {
    category = "Third Person",
    isQuick = true,
})

lia.option.add("thirdPersonHeight", "Height", "Adjust the vertical height of the third-person camera.", 10, nil, {
    category = "Third Person",
    min = 0,
    isQuick = true,
    max = lia.config.get("MaxThirdPersonHeight", 30),
})

lia.option.add("thirdPersonHorizontal", "Horizontal", "Adjust the horizontal offset of the third-person camera.", 10, nil, {
    category = "Third Person",
    min = 0,
    isQuick = true,
    max = lia.config.get("MaxThirdPersonHorizontal", 30),
})

lia.option.add("thirdPersonDistance", "Distance", "Adjust the camera distance in third-person view.", 50, nil, {
    category = "Third Person",
    min = 0,
    isQuick = true,
    max = lia.config.get("MaxThirdPersonDistance", 100),
})

lia.option.add("ChatShowTime", L("chatShowTime"), L("chatShowTimeDesc"), false, nil, {
    category = L("categoryChat"),
    type = "Boolean"
})

lia.option.add("voiceRange", L("voiceRange"), L("voiceRangeDesc"), false, nil, {
    category = L("categoryHUD"),
    isQuick = true,
    type = "Boolean"
})
