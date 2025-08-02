local defaultUserTools = {
    remover = true,
}

function MODULE:InitializedModules()
    if properties.List then
        for name, prop in pairs(properties.List) do
            if name ~= "persist" and name ~= "drive" and name ~= "bonemanipulate" then
                local privilege = L("accessPropertyPrivilege", prop.MenuLabel)
                lia.administrator.registerPrivilege({
                    Name = privilege,
                    MinAccess = "admin",
                    Category = "Properties"
                })
            end
        end
    end

    for _, wep in ipairs(weapons.GetList()) do
        if wep.ClassName == "gmod_tool" and wep.Tool then
            for tool in pairs(wep.Tool) do
                local privilege = L("accessToolPrivilege", tool:gsub("^%l", string.upper))
                lia.administrator.registerPrivilege({
                    Name = privilege,
                    MinAccess = defaultUserTools[string.lower(tool)] and "user" or "admin",
                    Category = "Tools"
                })
            end
        end
    end
end

lia.flag.add("p", L("flagPhysgun"), function(client, isGiven)
    if isGiven then
        client:Give("weapon_physgun")
        client:SelectWeapon("weapon_physgun")
    else
        client:StripWeapon("weapon_physgun")
    end
end)

lia.flag.add("t", L("flagToolgun"), function(client, isGiven)
    if isGiven then
        client:Give("gmod_tool")
        client:SelectWeapon("gmod_tool")
    else
        client:StripWeapon("gmod_tool")
    end
end)

lia.flag.add("C", L("flagSpawnVehicles"))
lia.flag.add("z", L("flagSpawnSweps"))
lia.flag.add("E", L("flagSpawnSents"))
lia.flag.add("L", L("flagSpawnEffects"))
lia.flag.add("r", L("flagSpawnRagdolls"))
lia.flag.add("e", L("flagSpawnProps"))
lia.flag.add("n", L("flagSpawnNpcs"))
lia.flag.add("V", L("flagFactionRoster"))
lia.flag.add("K", L("flagFactionKick"))