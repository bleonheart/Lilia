function MODULE:CanPlayerModifyConfig(client)
    local hasPrivilege = client:hasPrivilege("accessEditConfigurationMenu")
    lia.debug("[Permissions]", "Permission Check for function MODULE:CanPlayerModifyConfig", "hasPrivilege(accessEditConfigurationMenu)=", tostring(hasPrivilege), "finalResult=", tostring(hasPrivilege))
    return hasPrivilege
end

properties.Add("TogglePropBlacklist", {
    MenuLabel = L("togglePropBlacklist"),
    Order = 900,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply)
        if not CLIENT then return false end
        if not IsValid(ply) or not IsValid(ent) then return false end
        local weapon = ply:GetActiveWeapon()
        local canUseDebug = IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
        local isPropPhysics = ent:GetClass() == "prop_physics"
        local hasPrivilege = ply:hasPrivilege("managePropBlacklist")
        local permission = canUseDebug and isPropPhysics and hasPrivilege
        lia.debug("[Permissions]", "Permission Check for property TogglePropBlacklist Filter", "entityValid=", tostring(IsValid(ent)), "entityIsPropPhysics=", tostring(isPropPhysics), "hasPrivilege(managePropBlacklist)=", tostring(hasPrivilege), "finalResult=", tostring(permission))
        return permission
    end,
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
    Filter = function(_, ent, ply)
        if not CLIENT then return false end
        if not IsValid(ply) or not IsValid(ent) then return false end
        local weapon = ply:GetActiveWeapon()
        local canUseDebug = IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
        local isVehicle = ent:IsVehicle() or (ent.isSimfphysCar and ent:isSimfphysCar()) or false
        local hasPrivilege = ply:hasPrivilege("manageVehicleBlacklist")
        local permission = canUseDebug and isVehicle and hasPrivilege
        lia.debug("[Permissions]", "Permission Check for property ToggleCarBlacklist Filter", "entityValid=", tostring(IsValid(ent)), "entityIsVehicle=", tostring(ent:IsVehicle()), "entityIsSimfphysCar=", tostring(ent.isSimfphysCar and ent:isSimfphysCar() or false), "hasPrivilege(manageVehicleBlacklist)=", tostring(hasPrivilege), "finalResult=", tostring(permission))
        return permission
    end,
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

properties.Add("entity_info", {
    MenuLabel = "View / Copy Entity Information",
    Order = 899,
    MenuIcon = "icon16/information.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local function SafeEntityCall(methodName, ...)
            local method = ent[methodName]
            if not isfunction(method) then return nil end
            local success, result = pcall(method, ent, ...)
            if not success then return nil end
            return result
        end

        local function SafePhysicsCall(phys, methodName, ...)
            if not IsValid(phys) then return nil end
            local method = phys[methodName]
            if not isfunction(method) then return nil end
            local success, result = pcall(method, phys, ...)
            if not success then return nil end
            return result
        end

        local function FormatVector(value)
            if not isvector(value) then return "Unavailable" end
            return string.format("Vector(%.6f, %.6f, %.6f)", value.x, value.y, value.z)
        end

        local function FormatAngle(value)
            if not isangle(value) then return "Unavailable" end
            return string.format("Angle(%.6f, %.6f, %.6f)", value.p, value.y, value.r)
        end

        local function FindModelSource(model)
            if not isstring(model) or model == "" then return end
            local candidates = {model}
            if string.StartWith(model, "download/") then
                local path = string.sub(model, 10)
                candidates[#candidates + 1] = path
                if file.Exists(path, "DOWNLOAD") then
                    return {
                        type = "download",
                        path = path
                    }
                end
            end

            for _, addon in ipairs(engine.GetAddons()) do
                if addon.mounted then
                    for _, path in ipairs(candidates) do
                        if file.Exists(path, addon.title) then
                            return {
                                type = "workshop",
                                title = addon.title,
                                wsid = addon.wsid,
                                file = addon.file,
                                path = path
                            }
                        end
                    end
                end
            end

            for _, path in ipairs(candidates) do
                if file.Exists(path, "DOWNLOAD") then
                    return {
                        type = "download",
                        path = path
                    }
                end
            end

            for _, path in ipairs(candidates) do
                if file.Exists(path, "MOD") then
                    return {
                        type = "garrysmod",
                        path = path
                    }
                end
            end

            for _, path in ipairs(candidates) do
                if file.Exists(path, "WORKSHOP") then
                    return {
                        type = "workshop_unknown",
                        path = path
                    }
                end
            end

            for _, path in ipairs(candidates) do
                if file.Exists(path, "GAME") then
                    return {
                        type = "mounted",
                        path = path
                    }
                end
            end
        end

        local rows = {}
        local function AddRow(section, label, value)
            if value == nil then value = "Unavailable" end
            rows[#rows + 1] = {
                section = section,
                label = label,
                value = tostring(value)
            }
        end

        local pos = SafeEntityCall("GetPos")
        local ang = SafeEntityCall("GetAngles")
        local model = SafeEntityCall("GetModel")
        local material = SafeEntityCall("GetMaterial")
        local color = SafeEntityCall("GetColor")
        local owner = SafeEntityCall("GetOwner")
        local parent = SafeEntityCall("GetParent")
        local bodygroups = SafeEntityCall("GetBodyGroups")
        local sequence = SafeEntityCall("GetSequence")
        local name = SafeEntityCall("GetName")
        if not isstring(name) or name == "" then name = SafeEntityCall("GetInternalVariable", "targetname") end
        if not isstring(name) or name == "" then name = "None" end
        if not istable(bodygroups) then bodygroups = {} end
        AddRow("IDENTITY", "Entity", ent)
        AddRow("IDENTITY", "Entity ID", ent:EntIndex())
        AddRow("IDENTITY", "Creation ID", SafeEntityCall("GetCreationID"))
        AddRow("IDENTITY", "Map Creation ID", SafeEntityCall("MapCreationID"))
        AddRow("IDENTITY", "Class", SafeEntityCall("GetClass"))
        AddRow("IDENTITY", "Name", name)
        AddRow("IDENTITY", "Is Player", SafeEntityCall("IsPlayer"))
        AddRow("IDENTITY", "Is NPC", SafeEntityCall("IsNPC"))
        AddRow("IDENTITY", "Is NextBot", SafeEntityCall("IsNextBot"))
        AddRow("IDENTITY", "Is Vehicle", SafeEntityCall("IsVehicle"))
        AddRow("IDENTITY", "Is Weapon", SafeEntityCall("IsWeapon"))
        AddRow("MODEL", "Model", isstring(model) and model ~= "" and model or "None")
        AddRow("MODEL", "Skin", SafeEntityCall("GetSkin"))
        AddRow("MODEL", "Model Scale", SafeEntityCall("GetModelScale"))
        AddRow("MODEL", "Sequence", sequence)
        AddRow("MODEL", "Sequence Name", isnumber(sequence) and SafeEntityCall("GetSequenceName", sequence) or nil)
        local bodygroupsByID = {}
        local bodygroupsByName = {}
        for _, bodygroup in ipairs(bodygroups) do
            local value = SafeEntityCall("GetBodygroup", bodygroup.id)
            bodygroupsByID[#bodygroupsByID + 1] = tostring(bodygroup.id) .. " - " .. tostring(value)
            bodygroupsByName[#bodygroupsByName + 1] = tostring(bodygroup.name) .. " - " .. tostring(value)
            AddRow("BODYGROUPS", "[" .. tostring(bodygroup.id) .. "] " .. tostring(bodygroup.name), value)
        end

        if #bodygroups == 0 then
            AddRow("BODYGROUPS", "Bodygroups", "None")
        else
            AddRow("BODYGROUPS", "Bodygroups By ID", table.concat(bodygroupsByID, " | "))
            AddRow("BODYGROUPS", "Bodygroups By Name", table.concat(bodygroupsByName, " | "))
        end

        AddRow("TRANSFORM", "Position", FormatVector(pos))
        AddRow("TRANSFORM", "Angles", FormatAngle(ang))
        AddRow("TRANSFORM", "Full Position", "{pos = " .. FormatVector(pos) .. ", ang = " .. FormatAngle(ang) .. "}")
        AddRow("TRANSFORM", "Velocity", FormatVector(SafeEntityCall("GetVelocity")))
        AddRow("TRANSFORM", "World Space Center", FormatVector(SafeEntityCall("WorldSpaceCenter")))
        AddRow("TRANSFORM", "OBB Mins", FormatVector(SafeEntityCall("OBBMins")))
        AddRow("TRANSFORM", "OBB Maxs", FormatVector(SafeEntityCall("OBBMaxs")))
        AddRow("APPEARANCE", "Material", isstring(material) and material ~= "" and material or "Default")
        if IsColor(color) then
            AddRow("APPEARANCE", "Color", string.format("Color(%d, %d, %d, %d)", color.r, color.g, color.b, color.a))
        else
            AddRow("APPEARANCE", "Color", "Unavailable")
        end

        AddRow("APPEARANCE", "Render Mode", SafeEntityCall("GetRenderMode"))
        AddRow("APPEARANCE", "Render FX", SafeEntityCall("GetRenderFX"))
        AddRow("APPEARANCE", "No Draw", SafeEntityCall("GetNoDraw"))
        AddRow("STATE", "Health", SafeEntityCall("Health"))
        AddRow("STATE", "Max Health", SafeEntityCall("GetMaxHealth"))
        AddRow("STATE", "Move Type", SafeEntityCall("GetMoveType"))
        AddRow("STATE", "Solid", SafeEntityCall("GetSolid"))
        AddRow("STATE", "Collision Group", SafeEntityCall("GetCollisionGroup"))
        AddRow("STATE", "Dormant", SafeEntityCall("IsDormant"))
        AddRow("STATE", "Spawn Flags", SafeEntityCall("GetSpawnFlags"))
        if IsValid(owner) then
            AddRow("OWNERSHIP", "Owner", owner)
            AddRow("OWNERSHIP", "Owner Entity ID", owner:EntIndex())
            AddRow("OWNERSHIP", "Owner Class", owner:GetClass())
            if owner:IsPlayer() then
                AddRow("OWNERSHIP", "Owner Name", owner:Nick())
                AddRow("OWNERSHIP", "Owner SteamID", owner:SteamID())
                AddRow("OWNERSHIP", "Owner SteamID64", owner:SteamID64())
            end
        else
            AddRow("OWNERSHIP", "Owner", "None")
        end

        if ent.CPPIGetOwner then
            local success, cppiOwner = pcall(ent.CPPIGetOwner, ent)
            if success and IsValid(cppiOwner) then
                AddRow("OWNERSHIP", "CPPI Owner", cppiOwner)
                AddRow("OWNERSHIP", "CPPI Owner Entity ID", cppiOwner:EntIndex())
                if cppiOwner:IsPlayer() then
                    AddRow("OWNERSHIP", "CPPI Owner Name", cppiOwner:Nick())
                    AddRow("OWNERSHIP", "CPPI Owner SteamID", cppiOwner:SteamID())
                    AddRow("OWNERSHIP", "CPPI Owner SteamID64", cppiOwner:SteamID64())
                end
            end
        end

        if IsValid(parent) then
            AddRow("PARENT", "Parent", parent)
            AddRow("PARENT", "Parent Entity ID", parent:EntIndex())
            AddRow("PARENT", "Parent Class", parent:GetClass())
        else
            AddRow("PARENT", "Parent", "None")
        end

        local phys = SafeEntityCall("GetPhysicsObject")
        if IsValid(phys) then
            AddRow("PHYSICS", "Physics Material", SafePhysicsCall(phys, "GetMaterial"))
            AddRow("PHYSICS", "Mass", SafePhysicsCall(phys, "GetMass"))
            AddRow("PHYSICS", "Motion Enabled", SafePhysicsCall(phys, "IsMotionEnabled"))
            AddRow("PHYSICS", "Gravity Enabled", SafePhysicsCall(phys, "IsGravityEnabled"))
            AddRow("PHYSICS", "Drag Enabled", SafePhysicsCall(phys, "IsDragEnabled"))
            AddRow("PHYSICS", "Physics Velocity", FormatVector(SafePhysicsCall(phys, "GetVelocity")))
            AddRow("PHYSICS", "Angular Velocity", FormatVector(SafePhysicsCall(phys, "GetAngleVelocity")))
        else
            AddRow("PHYSICS", "Physics Object", "None")
        end

        local source = FindModelSource(model)
        if not isstring(model) or model == "" then
            AddRow("MODEL SOURCE", "Source", "No model")
        elseif not source then
            AddRow("MODEL SOURCE", "Source", "Unknown")
        elseif source.type == "workshop" then
            AddRow("MODEL SOURCE", "Source", "Workshop")
            AddRow("MODEL SOURCE", "Addon", source.title)
            AddRow("MODEL SOURCE", "Workshop ID", source.wsid)
            AddRow("MODEL SOURCE", "Workshop URL", "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. tostring(source.wsid))
            AddRow("MODEL SOURCE", "GMA", source.file)
            AddRow("MODEL SOURCE", "Internal Path", source.path)
        elseif source.type == "download" then
            AddRow("MODEL SOURCE", "Source", "Downloaded server content / FastDL")
            AddRow("MODEL SOURCE", "Path", "download/" .. source.path)
        elseif source.type == "garrysmod" then
            AddRow("MODEL SOURCE", "Source", "Garry's Mod")
            AddRow("MODEL SOURCE", "Path", source.path)
        elseif source.type == "workshop_unknown" then
            AddRow("MODEL SOURCE", "Source", "Workshop")
            AddRow("MODEL SOURCE", "Addon", "Unknown")
            AddRow("MODEL SOURCE", "Path", source.path)
        else
            AddRow("MODEL SOURCE", "Source", "Mounted game/content")
            AddRow("MODEL SOURCE", "Path", source.path)
        end

        local prefix = "[Entity Information] "
        local currentSection
        local allLines = {}
        for _, row in ipairs(rows) do
            if currentSection ~= row.section then
                currentSection = row.section
                local header = "----- " .. currentSection .. " -----"
                allLines[#allLines + 1] = header
                MsgC(Color(80, 180, 255), prefix, Color(255, 220, 100), header, "\n")
            end

            allLines[#allLines + 1] = row.label .. ": " .. row.value
            MsgC(Color(80, 180, 255), prefix, Color(255, 255, 255), row.label .. ": ", Color(180, 220, 255), row.value, "\n")
        end

        local allText = table.concat(allLines, "\n")
        local frame = vgui.Create("DFrame")
        frame:SetSize(math.min(ScrW() - 80, 1050), math.min(ScrH() - 80, 760))
        frame:Center()
        frame:SetTitle("Entity Information - " .. tostring(ent:GetClass()) .. " [" .. tostring(ent:EntIndex()) .. "]")
        frame:SetSizable(true)
        frame:MakePopup()
        local controls = vgui.Create("DPanel", frame)
        controls:Dock(TOP)
        controls:SetTall(38)
        controls:DockPadding(6, 5, 6, 5)
        local copyAll = vgui.Create("DButton", controls)
        copyAll:Dock(RIGHT)
        copyAll:SetWide(120)
        copyAll:SetText("Copy All")
        copyAll.DoClick = function()
            SetClipboardText(allText)
            MsgC(Color(80, 180, 255), prefix, Color(255, 255, 255), "Copied all entity information.\n")
        end

        local summary = vgui.Create("DLabel", controls)
        summary:Dock(FILL)
        summary:SetText(tostring(ent) .. " | " .. tostring(ent:GetClass()) .. " | " .. tostring(ent:EntIndex()))
        summary:SetContentAlignment(4)
        local scroll = vgui.Create("DScrollPanel", frame)
        scroll:Dock(FILL)
        local lastSection
        for _, rowData in ipairs(rows) do
            if lastSection ~= rowData.section then
                lastSection = rowData.section
                local header = vgui.Create("DLabel")
                header:Dock(TOP)
                header:SetTall(28)
                header:DockMargin(8, 8, 8, 2)
                header:SetFont("DermaDefaultBold")
                header:SetText(rowData.section)
                header:SetContentAlignment(4)
                scroll:AddItem(header)
            end

            local panel = vgui.Create("DPanel")
            panel:Dock(TOP)
            panel:SetTall(30)
            panel:DockMargin(8, 1, 8, 1)
            panel:DockPadding(4, 3, 4, 3)
            scroll:AddItem(panel)
            local copy = vgui.Create("DButton", panel)
            copy:Dock(RIGHT)
            copy:SetWide(64)
            copy:SetText("Copy")
            copy.DoClick = function()
                SetClipboardText(rowData.value)
                MsgC(Color(80, 180, 255), prefix, Color(255, 255, 255), "Copied " .. rowData.label .. ": ", Color(180, 220, 255), rowData.value, "\n")
            end

            local label = vgui.Create("DLabel", panel)
            label:Dock(LEFT)
            label:SetWide(190)
            label:SetText(rowData.label)
            label:SetContentAlignment(4)
            local value = vgui.Create("DTextEntry", panel)
            value:Dock(FILL)
            value:SetText(rowData.value)
            value:SetEditable(false)
        end

        surface.PlaySound("buttons/button15.wav")
    end
})

-- Standalone copy properties are intentionally disabled; their functionality is
-- available from the View / Copy Entity Information window.
if false then
properties.Add("copytoclipboard", {
    MenuLabel = L("copyModelClipboard"),
    Order = 999,
    MenuIcon = "icon16/cup.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local value = ent:GetModel()
        if not isstring(value) or value == "" then return end
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Model: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyBodygroupsByName", {
    MenuLabel = L("copyBodygroupsByName"),
    Order = 998,
    MenuIcon = "icon16/group.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local lines = {}
        for _, bodygroup in ipairs(ent:GetBodyGroups()) do
            lines[#lines + 1] = bodygroup.name .. " - " .. tostring(ent:GetBodygroup(bodygroup.id))
        end

        local value = table.concat(lines, "\n")
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Bodygroups By Name\n")
    end
})

properties.Add("CopyBodygroupsByID", {
    MenuLabel = L("copyBodygroupsByID"),
    Order = 997,
    MenuIcon = "icon16/group.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local lines = {}
        for _, bodygroup in ipairs(ent:GetBodyGroups()) do
            lines[#lines + 1] = tostring(bodygroup.id) .. " - " .. tostring(ent:GetBodygroup(bodygroup.id))
        end

        local value = table.concat(lines, "\n")
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Bodygroups By ID\n")
    end
})

properties.Add("CopySkin", {
    MenuLabel = L("copySkinClipboard"),
    Order = 996,
    MenuIcon = "icon16/palette.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local value = tostring(ent:GetSkin())
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Skin: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityPosition", {
    MenuLabel = "Copy Entity Position",
    Order = 995,
    MenuIcon = "icon16/world.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local pos = ent:GetPos()
        local value = string.format("Vector(%.6f, %.6f, %.6f)", pos.x, pos.y, pos.z)
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Position: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityAngles", {
    MenuLabel = "Copy Entity Angles",
    Order = 994,
    MenuIcon = "icon16/arrow_rotate_clockwise.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local ang = ent:GetAngles()
        local value = string.format("Angle(%.6f, %.6f, %.6f)", ang.p, ang.y, ang.r)
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Angles: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityFullPosition", {
    MenuLabel = "Copy Full Position",
    Order = 993,
    MenuIcon = "icon16/table.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local pos = ent:GetPos()
        local ang = ent:GetAngles()
        local value = string.format("{pos = Vector(%.6f, %.6f, %.6f), ang = Angle(%.6f, %.6f, %.6f)}", pos.x, pos.y, pos.z, ang.p, ang.y, ang.r)
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Full Position: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityID", {
    MenuLabel = "Copy Entity ID",
    Order = 992,
    MenuIcon = "icon16/tag_blue.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local value = tostring(ent:EntIndex())
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Entity ID: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityClass", {
    MenuLabel = "Copy Entity Class",
    Order = 991,
    MenuIcon = "icon16/page_code.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local value = ent:GetClass()
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Entity Class: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityMaterial", {
    MenuLabel = "Copy Entity Material",
    Order = 990,
    MenuIcon = "icon16/picture.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local value = ent:GetMaterial()
        if not isstring(value) or value == "" then value = "Default" end
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Material: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityColor", {
    MenuLabel = "Copy Entity Color",
    Order = 989,
    MenuIcon = "icon16/palette.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local color = ent:GetColor()
        local value = string.format("Color(%d, %d, %d, %d)", color.r, color.g, color.b, color.a)
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Color: ", Color(180, 220, 255), value, "\n")
    end
})

properties.Add("CopyEntityModelScale", {
    MenuLabel = "Copy Entity Model Scale",
    Order = 988,
    MenuIcon = "icon16/arrow_out.png",
    Filter = function(_, ent)
        if not CLIENT then return false end
        if not IsValid(ent) then return false end
        local client = LocalPlayer()
        if not IsValid(client) then return false end
        local weapon = client:GetActiveWeapon()
        return IsValid(weapon) and weapon:GetClass() == "lia_adminstick" and weapon.GetActiveMode and weapon:GetActiveMode() == "debug"
    end,
    Action = function(_, ent)
        if not IsValid(ent) then return end
        local value = tostring(ent:GetModelScale())
        SetClipboardText(value)
        MsgC(Color(80, 180, 255), "[Entity Information] ", Color(255, 255, 255), "Copied Model Scale: ", Color(180, 220, 255), value, "\n")
    end
})
end

lia.util.setPositionCallback(L("factionSpawnAdderTitle"), {
    onRun = function(pos, client, typeId)
        if SERVER then
            local factionID = net.ReadString()
            local radius = math.Clamp(net.ReadFloat(), 0, 2048)
            if not factionID or factionID == "" then return end
            local factionInfo = lia.faction.teams[factionID] or lia.util.findFaction(client, factionID)
            if not factionInfo then return end
            lia.module.get("spawns"):FetchSpawns():next(function(spawns)
                spawns[factionInfo.uniqueID] = spawns[factionInfo.uniqueID] or {}
                table.insert(spawns[factionInfo.uniqueID], {
                    pos = pos,
                    ang = angle_zero,
                    map = lia.data.getEquivalencyMap(game.GetMap()),
                    radius = radius
                })

                lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                    lia.log.add(client, "spawnAdd", factionInfo.name)
                    client:notifySuccessLocalized("spawnAdded")
                end)
            end)
        else
            local names, idByDisplay = {}, {}
            for k, v in pairs(lia.faction.teams or {}) do
                local display = L(v.name) or v.name or k
                names[#names + 1] = display
                idByDisplay[display] = k
            end

            if #names == 0 then
                client:notifyErrorLocalized("invalidFaction")
                return
            end

            lia.derma.requestDropdown("@factionSpawnAdderTitle", names, function(selection)
                if not selection or selection == false then return end
                local factionID = idByDisplay[selection]
                if not factionID then return end
                lia.derma.requestString("Radius", "0 disables the radius.", function(value)
                    if value == false then return end
                    net.Start("liaSetFeaturePosition")
                    net.WriteString("faction_spawn_adder")
                    net.WriteVector(pos)
                    net.WriteString(factionID)
                    net.WriteFloat(math.Clamp(tonumber(value) or 0, 0, 2048))
                    net.SendToServer()
                end, "0")
            end)
        end
    end,
    onSelect = function(client, callback)
        if SERVER then
            lia.module.get("spawns"):FetchSpawns():next(function(spawns)
                local list = {}
                local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
                for factionID, factionSpawns in pairs(spawns or {}) do
                    local factionInfo = lia.faction.get(factionID)
                    local label = factionInfo and (factionInfo.name and L(factionInfo.name) or factionID) or factionID
                    for i = 1, #(factionSpawns or {}) do
                        local data = factionSpawns[i]
                        local pos = data.pos or data.position
                        if isvector(pos) then
                            local map = data.map and (isstring(data.map) and data.map:lower() or tostring(data.map):lower()) or nil
                            if not map or map == curMap then
                                list[#list + 1] = {
                                    pos = pos,
                                    label = label,
                                    radius = data.radius
                                }
                            end
                        end
                    end
                end

                callback(list, #list)
            end)
        else
            net.Start("liaFeaturePositionsRequest")
            net.WriteString("faction_spawn_adder")
            net.SendToServer()
        end
    end,
    onRemove = function(pos, client, typeId)
        lia.module.get("spawns"):FetchSpawns():next(function(spawns)
            local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
            for factionID, factionSpawns in pairs(spawns) do
                for i = #factionSpawns, 1, -1 do
                    local data = factionSpawns[i]
                    local dpos = data.pos or data.position
                    if isvector(dpos) and dpos:DistToSqr(pos) < 1 then
                        local map = data.map and (isstring(data.map) and data.map:lower() or tostring(data.map):lower()) or nil
                        if not map or map == curMap then
                            table.remove(factionSpawns, i)
                            lia.module.get("spawns"):StoreSpawns(spawns)
                            lia.log.add(client, "spawnRemove", factionID)
                            return
                        end
                    end
                end
            end
        end)
    end,
    color = Color(100, 200, 100),
    serverOnly = true
})

lia.util.setPositionCallback(L("classSpawnAdderTitle"), {
    onRun = function(pos, client, typeId)
        if SERVER then
            local classID = net.ReadString()
            local radius = math.Clamp(net.ReadFloat(), 0, 2048)
            if not classID or classID == "" then return end
            local classIDNum = tonumber(classID) or lia.class.retrieveClass(classID)
            local classData = lia.class.get(classIDNum)
            if not classData then return end
            local stored = lia.data.get("spawns", {})
            local data = istable(stored) and stored or {}
            data.classes = data.classes or {}
            data.classes[classIDNum] = data.classes[classIDNum] or {}
            table.insert(data.classes[classIDNum], {
                pos = pos,
                ang = angle_zero,
                map = lia.data.getEquivalencyMap(game.GetMap()),
                radius = radius
            })

            lia.data.set("spawns", data)
            lia.log.add(client, "classSpawnAdd", classData.name)
            client:notifySuccessLocalized("spawnAdded")
        else
            local names, idByDisplay = {}, {}
            for k, v in pairs(lia.class.list or {}) do
                if isnumber(k) and istable(v) and v.name then
                    local display = v.name or tostring(k)
                    names[#names + 1] = display
                    idByDisplay[display] = tostring(k)
                end
            end

            if #names == 0 then
                client:notifyErrorLocalized("invalidClass")
                return
            end

            lia.derma.requestDropdown("@classSpawnAdderTitle", names, function(selection)
                if not selection or selection == false then return end
                local classID = idByDisplay[selection]
                if not classID then return end
                lia.derma.requestString("Radius", "0 disables the radius.", function(value)
                    if value == false then return end
                    net.Start("liaSetFeaturePosition")
                    net.WriteString("class_spawn_adder")
                    net.WriteVector(pos)
                    net.WriteString(classID)
                    net.WriteFloat(math.Clamp(tonumber(value) or 0, 0, 2048))
                    net.SendToServer()
                end, "0")
            end)
        end
    end,
    onSelect = function(client, callback)
        if SERVER then
            local stored = lia.data.get("spawns", {})
            local data = istable(stored) and stored or {}
            local classes = data.classes or {}
            local list = {}
            local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
            for classID, classSpawns in pairs(classes) do
                local classData = lia.class.get(tonumber(classID))
                local label = classData and (classData.name or tostring(classID)) or tostring(classID)
                for i = 1, #(classSpawns or {}) do
                    local spawnData = classSpawns[i]
                    local pos = spawnData.pos or spawnData.position
                    if isvector(pos) then
                        local map = spawnData.map and (isstring(spawnData.map) and spawnData.map:lower() or tostring(spawnData.map):lower()) or nil
                        if not map or map == curMap then
                            list[#list + 1] = {
                                pos = pos,
                                label = label,
                                radius = spawnData.radius
                            }
                        end
                    end
                end
            end

            callback(list, #list)
        else
            net.Start("liaFeaturePositionsRequest")
            net.WriteString("class_spawn_adder")
            net.SendToServer()
        end
    end,
    onRemove = function(pos, client, typeId)
        local stored = lia.data.get("spawns", {})
        local data = istable(stored) and stored or {}
        local classes = data.classes or {}
        local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
        for classID, classSpawns in pairs(classes) do
            for i = #classSpawns, 1, -1 do
                local spawnData = classSpawns[i]
                local dpos = spawnData.pos or spawnData.position
                if isvector(dpos) and dpos:DistToSqr(pos) < 1 then
                    local map = spawnData.map and (isstring(spawnData.map) and spawnData.map:lower() or tostring(spawnData.map):lower()) or nil
                    if not map or map == curMap then
                        table.remove(classSpawns, i)
                        lia.data.set("spawns", data)
                        lia.log.add(client, "classSpawnRemove", classID)
                        return
                    end
                end
            end
        end
    end,
    color = Color(200, 150, 100),
    serverOnly = true
})

lia.util.setPositionCallback(L("sitRoomTitle"), {
    onRun = function(pos, client, typeId)
        if SERVER then
            local name = net.ReadString()
            if not name or name == "" then return end
            local rooms = lia.data.get("sitrooms", {})
            rooms[name] = pos
            lia.data.set("sitrooms", rooms)
            client:notifySuccessLocalized("sitroomSet")
            lia.log.add(client, "sitRoomSet", L("sitroomSetDetail", name, tostring(pos)), L("logSetSitroom"))
        elseif CLIENT then
            client:requestString("@enterNamePrompt", L("enterSitroomPrompt") .. ":", function(name)
                if name == false then return end
                if not name or name == "" then
                    client:notifyErrorLocalized("invalidName")
                    return
                end

                net.Start("liaSetFeaturePosition")
                net.WriteString("sit_room")
                net.WriteVector(pos)
                net.WriteString(name)
                net.SendToServer()
            end)
        end
    end,
    onSelect = function(client, callback)
        if SERVER then
            local rooms = lia.data.get("sitrooms", {})
            local list = {}
            for name, pos in pairs(rooms) do
                if isvector(pos) then
                    list[#list + 1] = {
                        pos = pos,
                        label = name
                    }
                end
            end

            callback(list, #list)
        elseif CLIENT then
            net.Start("liaFeaturePositionsRequest")
            net.WriteString("sit_room")
            net.SendToServer()
        end
    end,
    onRemove = function(pos, client, typeId)
        local rooms = lia.data.get("sitrooms", {})
        for name, roomPos in pairs(rooms) do
            if isvector(roomPos) and roomPos:DistToSqr(pos) < 1 then
                rooms[name] = nil
                lia.data.set("sitrooms", rooms)
                lia.log.add(client, "sitRoomRemove", name)
                return
            end
        end
    end,
    color = Color(123, 104, 238),
    serverOnly = true
})
