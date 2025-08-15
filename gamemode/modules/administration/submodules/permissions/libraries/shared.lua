local defaultUserTools = {
    remover = true,
}

local function registerDynamicPrivileges()
    if properties and properties.List then
        for name, prop in pairs(properties.List) do
            if name ~= "persist" and name ~= "drive" and name ~= "bonemanipulate" then
                local id = "property_" .. tostring(name)
                lia.administrator.registerPrivilege({
                    Name = L("accessPropertyPrivilege", prop.MenuLabel or name),
                    ID = id,
                    MinAccess = "admin",
                    Category = "properties"
                })
            end
        end
    end

    for _, wep in ipairs(weapons.GetList()) do
        if wep.ClassName == "gmod_tool" and wep.Tool then
            for tool in pairs(wep.Tool) do
                local id = "tool_" .. tostring(tool)
                lia.administrator.registerPrivilege({
                    Name = L("accessToolPrivilege", tool:gsub("^%l", string.upper)),
                    ID = id,
                    MinAccess = defaultUserTools[string.lower(tool)] and "user" or "admin",
                    Category = "tools"
                })
            end
        end
    end
end

function MODULE:InitializedModules()
    -- Initial pass right after modules load
    registerDynamicPrivileges()
    -- Schedule a delayed pass to catch late-registered properties/tools
    timer.Simple(1, registerDynamicPrivileges)
end

function MODULE:OnAdminSystemLoaded()
    -- Ensure privileges exist after admin system fully loads from DB/CAMI
    registerDynamicPrivileges()
end

function MODULE:OnReloaded()
    -- Hot-reload safety
    registerDynamicPrivileges()
end

lia.flag.add("p", "flagPhysgun", function(client, isGiven)
    if isGiven then
        client:Give("weapon_physgun")
        client:SelectWeapon("weapon_physgun")
    else
        client:StripWeapon("weapon_physgun")
    end
end)

lia.flag.add("t", "flagToolgun", function(client, isGiven)
    if isGiven then
        client:Give("gmod_tool")
        client:SelectWeapon("gmod_tool")
    else
        client:StripWeapon("gmod_tool")
    end
end)

lia.flag.add("C", "flagSpawnVehicles")
lia.flag.add("z", "flagSpawnSweps")
lia.flag.add("E", "flagSpawnSents")
lia.flag.add("L", "flagSpawnEffects")
lia.flag.add("r", "flagSpawnRagdolls")
lia.flag.add("e", "flagSpawnProps")
lia.flag.add("n", "flagSpawnNpcs")
lia.flag.add("V", "flagFactionRoster")
lia.flag.add("K", "flagFactionKick")