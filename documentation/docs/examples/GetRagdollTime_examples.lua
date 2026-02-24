-- Example usage of GetRagdollTime hook
-- This file demonstrates how to use the GetRagdollTime hook that was added to setRagdolled

-- Example 1: Reduce ragdoll time for administrators
hook.Add("GetRagdollTime", "AdminRagdollReduction", function(client, time)
    if client:IsAdmin() then
        return math.min(time, 5) -- Admins get up in max 5 seconds
    end
end)

-- Example 2: Extend ragdoll time for players with certain traits
hook.Add("GetRagdollTime", "TraitBasedRagdollTime", function(client, time)
    -- If player has a "fragile" trait, increase ragdoll time
    if client:getChar() and client:getChar():getData("fragile") then
        return time * 1.5 -- 50% longer ragdoll time
    end
end)

-- Example 3: Class-based ragdoll time modifications
hook.Add("GetRagdollTime", "ClassRagdollTime", function(client, time)
    local class = client:getChar() and client:getChar():getClass()
    if class then
        local classData = lia.class.get(class)
        if classData and classData.ragdollTimeModifier then
            return time * classData.ragdollTimeModifier
        end
    end
end)

-- Example 4: Environmental factors affecting ragdoll time
hook.Add("GetRagdollTime", "EnvironmentalRagdollTime", function(client, time)
    -- Check if player is in water
    if client:WaterLevel() > 0 then
        return time * 0.7 -- 30% shorter ragdoll time in water
    end

    -- Check if player is in a certain area
    local pos = client:GetPos()
    for _, ent in ipairs(ents.FindInSphere(pos, 200)) do
        if ent:GetClass() == "lia_medical_bay" then
            return time * 0.5 -- 50% shorter ragdoll time near medical equipment
        end
    end
end)
