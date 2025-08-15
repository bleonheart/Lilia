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