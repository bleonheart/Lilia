local defaultUserTools = {
    remover = true,
}

function MODULE:InitializedModules()
    if properties.List then
        for name in pairs(properties.List) do
            if name ~= "persist" and name ~= "drive" and name ~= "bonemanipulate" then
                local privilege = "Access Property " .. name:gsub("^%l", string.upper)
                lia.admin.registerPrivilege({
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
                local privilege = "Access Tool " .. tool:gsub("^%l", string.upper)
                lia.admin.registerPrivilege({
                    Name = privilege,
                    MinAccess = defaultUserTools[string.lower(tool)] and "user" or "admin",
                    Category = "Tools"
                })
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