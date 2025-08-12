MODULE.name = "Permissions"

MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides fine-grained permission management for commands and modules across the framework."
MODULE.Privileges = {
    {
        Name = "canBypassCharacterLock",
        ID = "canBypassCharacterLock",
        MinAccess = "superadmin",
        Category = "categoryStaffManagement",
    },
    {
        Name = "canGrabWorldProps",
        ID = "canGrabWorldProps",
        MinAccess = "superadmin",
        Category = "categoryStaffPhysgun",
    },
    {
        Name = "canGrabPlayers",
        ID = "canGrabPlayers",
        MinAccess = "superadmin",
        Category = "categoryStaffPhysgun",
    },
    {
        Name = "physgunPickup",
        ID = "physgunPickup",
        MinAccess = "admin",
        Category = "categoryStaffPhysgun",
    },
    {
        Name = "canAccessItemInformations",
        ID = "canAccessItemInformations",
        MinAccess = "superadmin",
        Category = "categoryStaffItems",
    },
    {
        Name = "physgunPickupRestrictedEntities",
        ID = "physgunPickupRestrictedEntities",
        MinAccess = "superadmin",
        Category = "categoryStaffPhysgun",
    },
    {
        Name = "physgunPickupVehicles",
        ID = "physgunPickupVehicles",
        MinAccess = "admin",
        Category = "categoryStaffPhysgun",
    },
    {
        Name = "cantBeGrabbedPhysgun",
        ID = "cantBeGrabbedPhysgun",
        MinAccess = "superadmin",
        Category = "categoryStaffProtection",
    },
    {
        Name = "canPhysgunReload",
        ID = "canPhysgunReload",
        MinAccess = "superadmin",
        Category = "categoryStaffPhysgun",
    },
    {
        Name = "noClipOutsideStaff",
        ID = "noClipOutsideStaff",
        MinAccess = "superadmin",
        Category = "categoryStaffMovement",
    },
    {
        Name = "noClipESPOffsetStaff",
        ID = "noClipESPOffsetStaff",
        MinAccess = "superadmin",
        Category = "categoryStaffSettings",
    },
    {
        Name = "canPropertyWorldEntities",
        ID = "canPropertyWorldEntities",
        MinAccess = "superadmin",
        Category = "categoryStaffManagement",
    },
    {
        Name = "manageVehicleBlacklist",
        ID = "manageVehicleBlacklist",
        MinAccess = "superadmin",
        Category = "categoryStaffBlacklisting",
    },
    {
        Name = "canSpawnRagdolls",
        ID = "canSpawnRagdolls",
        MinAccess = "admin",
        Category = "categorySpawnRagdolls",
    },
    {
        Name = "canSpawnSWEPs",
        ID = "canSpawnSWEPs",
        MinAccess = "superadmin",
        Category = "categorySpawnSWEPs",
    },
    {
        Name = "canSpawnEffects",
        ID = "canSpawnEffects",
        MinAccess = "admin",
        Category = "categorySpawnEffects",
    },
    {
        Name = "canSpawnProps",
        ID = "canSpawnProps",
        MinAccess = "admin",
        Category = "categorySpawnProps",
    },
    {
        Name = "canSpawnBlacklistedProps",
        ID = "canSpawnBlacklistedProps",
        MinAccess = "superadmin",
        Category = "categorySpawnBlacklisting",
    },
    {
        Name = "canSpawnNPCs",
        ID = "canSpawnNPCs",
        MinAccess = "superadmin",
        Category = "categorySpawnNPCs",
    },
    {
        Name = "noCarSpawnDelay",
        ID = "noCarSpawnDelay",
        MinAccess = "superadmin",
        Category = "categorySpawnVehicles",
    },
    {
        Name = "canSpawnCars",
        ID = "canSpawnCars",
        MinAccess = "admin",
        Category = "categorySpawnVehicles",
    },
    {
        Name = "canSpawnBlacklistedCars",
        ID = "canSpawnBlacklistedCars",
        MinAccess = "superadmin",
        Category = "categorySpawnBlacklisting",
    },
    {
        Name = "canSpawnSENTs",
        ID = "canSpawnSENTs",
        MinAccess = "admin",
        Category = "categorySpawnSENTs",
    },
    {
        Name = "canRemoveBlockedEntities",
        ID = "canRemoveBlockedEntities",
        MinAccess = "admin",
        Category = "categoryStaffBlacklisting",
    },
    {
        Name = "canRemoveWorldEntities",
        ID = "canRemoveWorldEntities",
        MinAccess = "superadmin",
        Category = "categoryStaffManagement",
    },
}

lia.command.add("privileges", {
    desc = L("privilegeViewerDesc"),
    privilege = "privilege_viewer",
    superAdminOnly = true,
    onRun = function(client)
        net.Start("openPrivilegeViewer")
        net.Send(client)
    end
})

if SERVER then
    util.AddNetworkString("openPrivilegeViewer")
else
    local function openPrivilegeViewer()
        local function describe(id)
            if string.find(id, "command_", 1, true) then return "Command access privilege" end
            if string.find(id, "tool_", 1, true) then return "Tool access privilege" end
            if string.find(id, "property_", 1, true) then return "Property access privilege" end
            if string.find(id, "privilege_viewer", 1, true) then return "Access to view all privileges" end
            return "General privilege"
        end

        local function buildRows()
            local t = {}
            local privileges = lia.administrator.privileges or {}
            local names = lia.administrator.privilegeNames or {}
            local cats = lia.administrator.privilegeCategories or {}
            for id, minAccess in pairs(privileges) do
                local name = names[id] or id
                local category = cats[id] or "Unassigned"
                t[#t + 1] = {id, name, category, minAccess, describe(id)}
            end

            table.SortByMember(t, 1, true)
            return t
        end

        local p = vgui.Create("liaDListView")
        p:SetWindowTitle(L("privilegeViewer"))
        p:SetPlaceholderText(L("searchPrivileges"))
        p:SetColumns({"ID", "Name", "Category", "Min Access", "Description"})
        p:SetData(buildRows())
        p:SetSort(1, false)
        p.refreshButton.DoClick = function() p:SetData(buildRows()) end
    end

    net.Receive("openPrivilegeViewer", function() openPrivilegeViewer() end)
end