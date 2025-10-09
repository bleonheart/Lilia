function MODULE:CanPlayerModifyConfig(client)
    return client:hasPrivilege("accessEditConfigurationMenu")
end
properties.Add("TogglePropBlacklist", {
    MenuLabel = L("togglePropBlacklist"),
    Order = 900,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply) return IsValid(ent) and ent:GetClass() == "prop_physics" and ply:hasPrivilege("managePropBlacklist") end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetModel())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("managePropBlacklist") then return end
        local model = net.ReadString()
        local list = lia.data.get("prop_blacklist", {})
        if table.HasValue(list, model) then
            table.RemoveByValue(list, model)
            lia.data.set("prop_blacklist", list, true, true)
            ply:notifySuccessLocalized("removedFromBlacklist", model)
        else
            table.insert(list, model)
            lia.data.set("prop_blacklist", list, true, true)
            ply:notifySuccessLocalized("addedToBlacklist", model)
        end
    end
})
properties.Add("ToggleCarBlacklist", {
    MenuLabel = L("toggleCarBlacklist"),
    Order = 901,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply) return IsValid(ent) and (ent:IsVehicle() or ent:isSimfphysCar()) and ply:hasPrivilege("manageVehicleBlacklist") end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetModel())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("manageVehicleBlacklist") then return end
        local model = net.ReadString()
        local list = lia.data.get("carBlacklist", {})
        if table.HasValue(list, model) then
            table.RemoveByValue(list, model)
            lia.data.set("carBlacklist", list, true, true)
            ply:notifySuccessLocalized("removedFromBlacklist", model)
        else
            table.insert(list, model)
            lia.data.set("carBlacklist", list, true, true)
            ply:notifySuccessLocalized("addedToBlacklist", model)
        end
    end
})
properties.Add("copytoclipboard", {
    MenuLabel = L("copyModelClipboard"),
    Order = 999,
    MenuIcon = "icon16/cup.png",
    Filter = function(_, ent)
        if ent == nil then return false end
        if not IsValid(ent) then return false end
        return true
    end,
    Action = function(self, ent)
        self:MsgStart()
        local s = ent:GetModel()
        SetClipboardText(s)
        print(s)
        self:MsgEnd()
    end,
})
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