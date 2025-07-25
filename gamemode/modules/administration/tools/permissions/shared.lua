local defaultUserTools = {
    remover = true,
}

function MODULE:InitializedModules()
    if properties.List then
        for name in pairs(properties.List) do
            if name ~= "persist" and name ~= "drive" and name ~= "bonemanipulate" then
                local privilege = "Access Property " .. name:gsub("^%l", string.upper)
                if not lia.admin.privileges[privilege] then
                    lia.admin.registerPrivilege({
                        Name = privilege,
                        MinAccess = "admin",
                        Category = "Properties"
                    })
                end
            end
        end
    end

    for _, wep in ipairs(weapons.GetList()) do
        if wep.ClassName == "gmod_tool" and wep.Tool then
            for tool in pairs(wep.Tool) do
                local privilege = "Access Tool " .. tool:gsub("^%l", string.upper)
                if not lia.admin.privileges[privilege] then
                    lia.admin.registerPrivilege({
                        Name = privilege,
                        MinAccess = defaultUserTools[string.lower(tool)] and "user" or "admin",
                        Category = "Tools"
                    })
                end
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
properties.Add("ToggleCarBlacklist", {
    MenuLabel = L("ToggleCarBlacklist"),
    Order = 901,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply) return IsValid(ent) and (ent:IsVehicle() or ent:isSimfphysCar()) and ply:hasPrivilege("Manage Car Blacklist") end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetModel())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("Manage Car Blacklist") then return end
        local model = net.ReadString()
        local list = lia.data.get("carBlacklist", {})
        if table.HasValue(list, model) then
            table.RemoveByValue(list, model)
            lia.data.set("carBlacklist", list, true, true)
            ply:notifyLocalized("removedFromBlacklist", model)
        else
            table.insert(list, model)
            lia.data.set("carBlacklist", list, true, true)
            ply:notifyLocalized("addedToBlacklist", model)
        end
    end
})

properties.Add("ToggleEntityBlacklist", {
    MenuLabel = L("ToggleEntityBlacklist"),
    Order = 902,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply)
        return IsValid(ent) and not ent:IsVehicle() and ent:GetClass() ~= "prop_physics" and ply:hasPrivilege("Manage Entity Blacklist")
    end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetClass())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("Manage Entity Blacklist") then return end
        local class = net.ReadString()
        local list = lia.data.get("entityBlacklist", {})
        if table.HasValue(list, class) then
            table.RemoveByValue(list, class)
            lia.data.set("entityBlacklist", list, true, true)
            ply:notifyLocalized("removedFromBlacklist", class)
        else
            table.insert(list, class)
            lia.data.set("entityBlacklist", list, true, true)
            ply:notifyLocalized("addedToBlacklist", class)
        end
    end
})
