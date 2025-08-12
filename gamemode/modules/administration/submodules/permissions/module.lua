MODULE.name = "modulePermissionsName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "modulePermissionsDesc"
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

-- Register the command to open the privilege viewer
lia.command.add("privileges", {
    desc = L("privilegeViewerDesc"),
    privilege = "privilege_viewer",
    superAdminOnly = true,
    onRun = function(client, arguments)
        net.Start("openPrivilegeViewer")
        net.Send(client)
    end
})

-- Privilege Viewer UI
-- Displays all registered privileges with their IDs and names
if SERVER then
    util.AddNetworkString("openPrivilegeViewer")
else
    local function openPrivilegeViewer()
        local frame = vgui.Create("DFrame")
        frame:SetTitle(L("privilegeViewer"))
        frame:SetSize(800, 600)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(true)
        -- Set the frame's paint function for better appearance
        frame.Paint = function(self, w, h)
            surface.SetDrawColor(45, 45, 45, 250)
            surface.DrawRect(0, 0, w, h)
            -- Draw title
            draw.SimpleText(L("privilegeViewer"), "liaMediumFont", w / 2, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        end

        -- Create a search box
        local searchBox = vgui.Create("DTextEntry", frame)
        searchBox:SetPos(10, 50)
        searchBox:SetSize(780, 25)
        searchBox:SetPlaceholderText(L("searchPrivileges"))
        searchBox:SetText("")
        -- Create the DList
        local privilegeList = vgui.Create("DListView", frame)
        privilegeList:SetPos(10, 85)
        privilegeList:SetSize(780, 505)
        privilegeList:SetMultiSelect(false)
        -- Add columns
        privilegeList:AddColumn("ID")
        privilegeList:AddColumn("Name")
        privilegeList:AddColumn("Category")
        privilegeList:AddColumn("Min Access")
        privilegeList:AddColumn("Description")
        -- Function to populate the list
        local function populatePrivilegeList(searchTerm)
            privilegeList:Clear()
            local privileges = lia.administrator.privileges or {}
            local privilegeNames = lia.administrator.privilegeNames or {}
            local privilegeCategories = lia.administrator.privilegeCategories or {}
            for id, minAccess in pairs(privileges) do
                local name = privilegeNames[id] or id
                local category = privilegeCategories[id] or "Unassigned"
                -- Generate a description based on the privilege ID
                local description = ""
                if string.find(id, "command_") then
                    description = "Command access privilege"
                elseif string.find(id, "tool_") then
                    description = "Tool access privilege"
                elseif string.find(id, "property_") then
                    description = "Property access privilege"
                elseif string.find(id, "privilege_viewer") then
                    description = "Access to view all privileges"
                else
                    description = "General privilege"
                end

                -- Apply search filter if search term exists
                if not searchTerm or searchTerm == "" or string.find(string.lower(id), string.lower(searchTerm)) or string.find(string.lower(name), string.lower(searchTerm)) or string.find(string.lower(category), string.lower(searchTerm)) or string.find(string.lower(description), string.lower(searchTerm)) then local line = privilegeList:AddLine(id, name, category, minAccess, description) end
            end

            -- Sort by ID for better organization
            privilegeList:SortByColumn(1, false)
        end

        -- Populate the list initially
        populatePrivilegeList("")
        -- Add search functionality
        searchBox.OnTextChanged = function()
            local searchTerm = searchBox:GetValue()
            populatePrivilegeList(searchTerm)
        end

        -- Add right-click context menu
        privilegeList.OnRowRightClick = function(self, lineID, line)
            local menu = DermaMenu()
            menu:AddOption("Copy ID", function()
                SetClipboardText(line:GetColumnText(1))
                notification.AddLegacy(L("privilegeIdCopied"), NOTIFY_GENERIC, 2)
            end)

            menu:AddOption("Copy Name", function()
                SetClipboardText(line:GetColumnText(2))
                notification.AddLegacy(L("privilegeNameCopied"), NOTIFY_GENERIC, 2)
            end)

            menu:AddOption("Copy Category", function()
                SetClipboardText(line:GetColumnText(3))
                notification.AddLegacy(L("privilegeCategoryCopied"), NOTIFY_GENERIC, 2)
            end)

            menu:AddOption("Copy Min Access", function()
                SetClipboardText(line:GetColumnText(4))
                notification.AddLegacy(L("privilegeAccessCopied"), NOTIFY_GENERIC, 2)
            end)

            menu:AddOption("Copy Description", function()
                SetClipboardText(line:GetColumnText(5))
                notification.AddLegacy(L("privilegeDescCopied"), NOTIFY_GENERIC, 2)
            end)

            menu:AddSpacer()
            menu:AddOption("Copy All Info", function()
                local info = string.format("ID: %s\nName: %s\nCategory: %s\nMin Access: %s\nDescription: %s", line:GetColumnText(1), line:GetColumnText(2), line:GetColumnText(3), line:GetColumnText(4), line:GetColumnText(5))
                SetClipboardText(info)
                notification.AddLegacy(L("allPrivilegeInfo"), NOTIFY_GENERIC, 2)
            end)

            menu:Open()
        end

        -- Add double-click to copy ID
        privilegeList.OnRowDoubleClick = function(self, lineID, line)
            SetClipboardText(line:GetColumnText(1))
            notification.AddLegacy("Privilege ID copied to clipboard!", NOTIFY_GENERIC, 2)
        end

        -- Add refresh button
        local refreshButton = vgui.Create("DButton", frame)
        refreshButton:SetPos(700, 50)
        refreshButton:SetSize(90, 25)
        refreshButton:SetText(L("refresh"))
        refreshButton.DoClick = function()
            populatePrivilegeList(searchBox:GetValue())
            notification.AddLegacy(L("privilegeListRefreshed"), NOTIFY_GENERIC, 2)
        end

        -- Add status bar
        local statusBar = vgui.Create("DPanel", frame)
        statusBar:SetPos(10, 590)
        statusBar:SetSize(780, 20)
        statusBar.Paint = function(self, w, h)
            local privileges = lia.administrator.privileges or {}
            local count = table.Count(privileges)
            draw.SimpleText(L("totalPrivileges", count), "liaSmallFont", 5, 2, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT)
        end
    end

    net.Receive("openPrivilegeViewer", function(len, client) openPrivilegeViewer() end)
end