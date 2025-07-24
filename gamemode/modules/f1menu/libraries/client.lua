MODULE.CharacterInformation = {}
function MODULE:LoadCharInformation()
    hook.Run("AddSection", L("generalInfo"), Color(0, 0, 0), 1, 1)
    hook.Run("AddTextField", L("generalInfo"), "name", L("name"), function() return LocalPlayer():getChar():getName() end)
    hook.Run("AddTextField", L("generalInfo"), "desc", L("desc"), function() return LocalPlayer():getChar():getDesc() end)
    hook.Run("AddTextField", L("generalInfo"), "money", L("money"), function() return LocalPlayer():getMoney() end)
end

function MODULE:AddSection(sectionName, color, priority, location)
    hook.Run("F1OnAddSection", sectionName, color, priority, location)
    if not self.CharacterInformation[sectionName] then
        self.CharacterInformation[sectionName] = {
            fields = {},
            color = color or Color(255, 255, 255),
            priority = priority or 999,
            location = location or 1
        }
    else
        local info = self.CharacterInformation[sectionName]
        info.color = color or info.color
        info.priority = priority or info.priority
        info.location = location or info.location
    end
end

function MODULE:AddTextField(sectionName, fieldName, labelText, valueFunc)
    hook.Run("F1OnAddTextField", sectionName, fieldName, labelText, valueFunc)
    local section = self.CharacterInformation[sectionName]
    if section then
        for _, field in ipairs(section.fields) do
            if field.name == fieldName then return end
        end

        table.insert(section.fields, {
            type = "text",
            name = fieldName,
            label = labelText,
            value = valueFunc or function() return "" end
        })
    end
end

function MODULE:AddBarField(sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
    hook.Run("F1OnAddBarField", sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
    local section = self.CharacterInformation[sectionName]
    if section then
        for _, field in ipairs(section.fields) do
            if field.name == fieldName then return end
        end

        table.insert(section.fields, {
            type = "bar",
            name = fieldName,
            label = labelText,
            min = minFunc or function() return 0 end,
            max = maxFunc or function() return 100 end,
            value = valueFunc or function() return 0 end
        })
    end
end

function MODULE:PlayerBindPress(client, bind, pressed)
    if bind:lower():find("gm_showhelp") and pressed then
        if IsValid(lia.gui.menu) then
            lia.gui.menu:remove()
        elseif client:getChar() then
            vgui.Create("liaMenu")
        end
        return true
    end
end

function MODULE:CreateInformationButtons(pages)
    local client = LocalPlayer()
    local function startSpectateView(ent, originalThirdPerson)
        local yaw = client:EyeAngles().yaw
        local camZOffset = 50
        hook.Add("CalcView", "EntityViewCalcView", function()
            return {
                origin = ent:GetPos() + Angle(0, yaw, 0):Forward() * 100 + Vector(0, 0, camZOffset),
                angles = Angle(0, yaw, 0),
                fov = 60
            }
        end)

        hook.Add("HUDPaint", "EntityViewHUD", function() draw.SimpleText(L("pressInstructions"), "liaMediumFont", ScrW() / 2, ScrH() - 50, color_white, TEXT_ALIGN_CENTER) end)
        hook.Add("Think", "EntityViewRotate", function()
            if input.IsKeyDown(KEY_A) then yaw = yaw - FrameTime() * 100 end
            if input.IsKeyDown(KEY_D) then yaw = yaw + FrameTime() * 100 end
            if input.IsKeyDown(KEY_W) then camZOffset = camZOffset + FrameTime() * 100 end
            if input.IsKeyDown(KEY_S) then camZOffset = camZOffset - FrameTime() * 100 end
            if input.IsKeyDown(KEY_SPACE) then
                hook.Remove("CalcView", "EntityViewCalcView")
                hook.Remove("HUDPaint", "EntityViewHUD")
                hook.Remove("Think", "EntityViewRotate")
                hook.Remove("CreateMove", "EntitySpectateCreateMove")
                lia.option.set("thirdPersonEnabled", originalThirdPerson)
            end
        end)

        hook.Add("CreateMove", "EntitySpectateCreateMove", function(cmd)
            cmd:SetForwardMove(0)
            cmd:SetSideMove(0)
            cmd:SetUpMove(0)
        end)
    end

    if client:hasPrivilege("Staff Permission — Access Module List") then
        table.insert(pages, {
            name = L("modules"),
            drawFunc = function(modulesPanel)
                local total = 0
                for _ in pairs(lia.module.list) do
                    total = total + 1
                end

                local searchEntry = vgui.Create("DTextEntry", modulesPanel)
                searchEntry:Dock(TOP)
                searchEntry:DockMargin(10, 0, 10, 5)
                searchEntry:SetTall(30)
                searchEntry:SetPlaceholderText(L("searchModules"))
                local infoBox = vgui.Create("DPanel", modulesPanel)
                infoBox:Dock(TOP)
                infoBox:DockMargin(10, 0, 10, 5)
                infoBox:SetTall(30)
                infoBox.Paint = function(_, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 200)) end
                local countLabel = vgui.Create("DLabel", infoBox)
                countLabel:Dock(FILL)
                countLabel:SetFont("liaSmallFont")
                countLabel:SetTextColor(color_white)
                countLabel:SetContentAlignment(5)
                countLabel:SetText(L("modulesCount", total))
                local scroll = vgui.Create("DScrollPanel", modulesPanel)
                scroll:Dock(FILL)
                scroll:DockPadding(0, 0, 0, 10)
                local canvas = scroll:GetCanvas()
                local panels = {}
                for _, moduleData in SortedPairs(lia.module.list) do
                    local hasDesc = moduleData.desc and moduleData.desc ~= ""
                    local height = hasDesc and 80 or 40
                    local modulePanel = vgui.Create("DPanel", canvas)
                    modulePanel:Dock(TOP)
                    modulePanel:DockMargin(10, 5, 10, 0)
                    modulePanel:SetTall(height)
                    modulePanel.infoText = moduleData.name:lower() .. " " .. (moduleData.desc or ""):lower()
                    modulePanel.Paint = function(pnl, w, h)
                        derma.SkinHook("Paint", "Panel", pnl, w, h)
                        draw.SimpleText(moduleData.name, "liaMediumFont", 20, 10, color_white)
                        if moduleData.version then draw.SimpleText(tostring(moduleData.version), "liaSmallFont", w - 20, 45, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP) end
                        if hasDesc then draw.SimpleText(moduleData.desc, "liaSmallFont", 20, 45, color_white) end
                    end

                    panels[#panels + 1] = modulePanel
                end

                searchEntry.OnTextChanged = function(entry)
                    local q = entry:GetValue():lower()
                    for _, p in ipairs(panels) do
                        p:SetVisible(q == "" or p.infoText:find(q, 1, true))
                    end

                    canvas:InvalidateLayout()
                    canvas:SizeToChildren(false, true)
                end
            end
        })
    end
end

hook.Add("liaAdminRegisterTab", "AdminEntitiesTab", function(parent, tabs)
    local function canView()
        return LocalPlayer():hasPrivilege("Staff Permission — Access Entity List")
    end

    tabs[L("entities")] = {
        icon = "icon16/bricks.png",
        onShouldShow = canView,
        build = function(sheet)
            local panel = vgui.Create("DPanel", sheet)
            panel:DockPadding(10, 10, 10, 10)
            local client = LocalPlayer()
            local entitiesByCreator = {}
            for _, ent in ents.Iterator() do
                if IsValid(ent) and ent.GetCreator and IsValid(ent:GetCreator()) then
                    local owner = ent:GetCreator():Nick()
                    entitiesByCreator[owner] = entitiesByCreator[owner] or {}
                    table.insert(entitiesByCreator[owner], ent)
                end
            end

            if table.IsEmpty(entitiesByCreator) then
                local emptyPanel = vgui.Create("DPanel", sheet)
                emptyPanel:Dock(FILL)
                emptyPanel.Paint = function() end
                local label = emptyPanel:Add("DLabel")
                label:Dock(FILL)
                label:SetContentAlignment(5)
                label:SetText(L("noEntitiesFound") or "No entities to display.")
                label:SetFont("liaMediumFont")
                label:SetTextColor(color_white)
                return emptyPanel
            end
            local function startSpectateView(ent, originalThirdPerson)
                local yaw = client:EyeAngles().yaw
                local camZOffset = 50
                hook.Add("CalcView", "EntityViewCalcView", function()
                    return {
                        origin = ent:GetPos() + Angle(0, yaw, 0):Forward() * 100 + Vector(0, 0, camZOffset),
                        angles = Angle(0, yaw, 0),
                        fov = 60
                    }
                end)

                hook.Add("HUDPaint", "EntityViewHUD", function() draw.SimpleText(L("pressInstructions"), "liaMediumFont", ScrW() / 2, ScrH() - 50, color_white, TEXT_ALIGN_CENTER) end)
                hook.Add("Think", "EntityViewRotate", function()
                    if input.IsKeyDown(KEY_A) then yaw = yaw - FrameTime() * 100 end
                    if input.IsKeyDown(KEY_D) then yaw = yaw + FrameTime() * 100 end
                    if input.IsKeyDown(KEY_W) then camZOffset = camZOffset + FrameTime() * 100 end
                    if input.IsKeyDown(KEY_S) then camZOffset = camZOffset - FrameTime() * 100 end
                    if input.IsKeyDown(KEY_SPACE) then
                        hook.Remove("CalcView", "EntityViewCalcView")
                        hook.Remove("HUDPaint", "EntityViewHUD")
                        hook.Remove("Think", "EntityViewRotate")
                        hook.Remove("CreateMove", "EntitySpectateCreateMove")
                        lia.option.set("thirdPersonEnabled", originalThirdPerson)
                    end
                end)

                hook.Add("CreateMove", "EntitySpectateCreateMove", function(cmd)
                    cmd:SetForwardMove(0)
                    cmd:SetSideMove(0)
                    cmd:SetUpMove(0)
                end)
            end

            local count = 0
            for _, list in pairs(entitiesByCreator) do
                count = count + #list
            end

            local searchEntry = vgui.Create("DTextEntry", panel)
            searchEntry:Dock(TOP)
            searchEntry:DockMargin(0, 0, 0, 5)
            searchEntry:SetTall(30)
            searchEntry:SetPlaceholderText(L("searchEntities"))
            local statsPanel = vgui.Create("DPanel", panel)
            statsPanel:Dock(TOP)
            statsPanel:DockMargin(10, 0, 10, 5)
            statsPanel:SetTall(30)
            statsPanel.Paint = function(_, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 200)) end
            local statsLabel = vgui.Create("DLabel", statsPanel)
            statsLabel:Dock(FILL)
            statsLabel:SetFont("liaSmallFont")
            statsLabel:SetTextColor(color_white)
            statsLabel:SetContentAlignment(5)
            statsLabel:SetText(L("totalPlayerEntities", count))
            local scroll = vgui.Create("DScrollPanel", panel)
            scroll:Dock(FILL)
            scroll:DockPadding(0, 0, 0, 10)
            local canvas = scroll:GetCanvas()
            local entries = {}
            for owner, list in SortedPairs(entitiesByCreator) do
                local header = vgui.Create("DCollapsibleCategory", canvas)
                header:Dock(TOP)
                header:SetLabel(owner .. " - " .. #list .. " " .. L("entities"))
                header:SetExpanded(true)
                header.Header:SetFont("liaMediumFont")
                header.Header:SetTextColor(Color(255, 255, 255))
                header.Header:SetContentAlignment(5)
                header.Header:SetTall(30)
                header.Paint = function() end
                header.Header.Paint = function(_, w, h)
                    surface.SetDrawColor(0, 0, 0, 255)
                    surface.DrawOutlinedRect(0, 0, w, h, 2)
                    surface.SetDrawColor(0, 0, 0, 150)
                    surface.DrawRect(1, 1, w - 2, h - 2)
                end

                local listPanel = vgui.Create("DPanel", header)
                listPanel.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200)) end
                header:SetContents(listPanel)
                entries[header] = {}
                for _, ent in ipairs(list) do
                    local className = ent:GetClass()
                    local itemPanel = vgui.Create("DPanel", listPanel)
                    itemPanel:Dock(TOP)
                    itemPanel:DockMargin(10, 15, 10, 10)
                    itemPanel:SetTall(100)
                    itemPanel.infoText = className:lower()
                    itemPanel.Paint = function(pnl, w, h)
                        derma.SkinHook("Paint", "Panel", pnl, w, h)
                        draw.SimpleText(className, "liaMediumFont", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end

                    local icon = vgui.Create("liaSpawnIcon", itemPanel)
                    icon:Dock(LEFT)
                    icon:SetWide(64)
                    icon:SetModel(ent:GetModel() or "models/error.mdl", ent:GetSkin() or 0)
                    icon.DoClick = function()
                        if IsValid(lastModelFrame) then lastModelFrame:Close() end
                        lastModelFrame = vgui.Create("DFrame")
                        lastModelFrame:SetTitle(className)
                        lastModelFrame:SetSize(800, 800)
                        lastModelFrame:Center()
                        lastModelFrame:MakePopup()
                        local infoLabel = vgui.Create("DLabel", lastModelFrame)
                        infoLabel:SetText(L("pressInstructions"))
                        infoLabel:SetFont("liaMediumFont")
                        infoLabel:SizeToContents()
                        infoLabel:Dock(TOP)
                        infoLabel:DockMargin(0, 10, 0, 0)
                        infoLabel:SetContentAlignment(5)
                        local modelPanel = vgui.Create("DModelPanel", lastModelFrame)
                        modelPanel:Dock(FILL)
                        modelPanel:SetModel(ent:GetModel() or "models/error.mdl", ent:GetSkin() or 0)
                        modelPanel:SetFOV(45)
                        local mn, mx = modelPanel.Entity:GetRenderBounds()
                        local size = math.max(math.abs(mn.x) + math.abs(mx.x), math.abs(mn.y) + math.abs(mx.y), math.abs(mn.z) + math.abs(mx.z))
                        modelPanel:SetCamPos(Vector(size, size, size))
                        modelPanel:SetLookAt((mn + mx) * 0.5)
                        local orig = lia.option.get("thirdPersonEnabled", false)
                        lia.option.set("thirdPersonEnabled", false)
                        startSpectateView(ent, orig)
                    end

                    local btnContainer = vgui.Create("DPanel", itemPanel)
                    btnContainer:Dock(RIGHT)
                    btnContainer:SetWide(380)
                    btnContainer.Paint = function() end
                    local btnW, btnH = 120, 40
                    if client:hasPrivilege("Staff Permission — View Entity (Entity Tab)") then
                        local btnView = vgui.Create("liaSmallButton", btnContainer)
                        btnView:Dock(LEFT)
                        btnView:DockMargin(5, 0, 5, 0)
                        btnView:SetWide(btnW)
                        btnView:SetTall(btnH)
                        btnView:SetText(L("view"))
                        btnView.DoClick = function()
                            if IsValid(lia.gui.menu) then lia.gui.menu:remove() end
                            local orig = lia.option.get("thirdPersonEnabled", false)
                            lia.option.set("thirdPersonEnabled", false)
                            startSpectateView(ent, orig)
                        end
                    end

                    if client:hasPrivilege("Staff Permission — Teleport to Entity (Entity Tab)") then
                        local btnTeleport = vgui.Create("liaSmallButton", btnContainer)
                        btnTeleport:Dock(LEFT)
                        btnTeleport:DockMargin(5, 0, 5, 0)
                        btnTeleport:SetWide(btnW)
                        btnTeleport:SetTall(btnH)
                        btnTeleport:SetText(L("teleport"))
                        btnTeleport.DoClick = function()
                            net.Start("liaTeleportToEntity")
                            net.WriteEntity(ent)
                            net.SendToServer()
                        end
                    end

                    local btnWaypoint = vgui.Create("liaSmallButton", btnContainer)
                    btnWaypoint:Dock(RIGHT)
                    btnWaypoint:DockMargin(5, 0, 5, 0)
                    btnWaypoint:SetWide(btnW)
                    btnWaypoint:SetTall(btnH)
                    btnWaypoint:SetText(L("waypointButton"))
                    btnWaypoint.DoClick = function() client:setWaypoint(className, ent:GetPos()) end
                    entries[header][#entries[header] + 1] = itemPanel
                end
            end

            searchEntry.OnTextChanged = function(entry)
                local q = entry:GetValue():lower()
                for header, panels in pairs(entries) do
                    local anyVisible = false
                    for _, pnl in ipairs(panels) do
                        local ok = q == "" or pnl.infoText:find(q, 1, true)
                        pnl:SetVisible(ok)
                        if ok then anyVisible = true end
                    end

                    header:SetVisible(anyVisible)
                end

                canvas:InvalidateLayout()
                canvas:SizeToChildren(false, true)
            end
            return panel
        end
    }
end)

function MODULE:CreateMenuButtons(tabs)
    tabs[L("status")] = function(statusPanel)
        statusPanel.info = vgui.Create("liaCharInfo", statusPanel)
        statusPanel.info:Dock(FILL)
        statusPanel.info:setup()
        statusPanel.info:SetAlpha(0)
        statusPanel.info:AlphaTo(255, 0.5)
    end

    tabs[L("information")] = function(infoTabPanel)
        local sheet = infoTabPanel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        local pages = {}
        hook.Run("CreateInformationButtons", pages)
        if not pages then return end

        for _, page in ipairs(pages) do
            local panel = sheet:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = function() end
            page.drawFunc(panel)
            sheet:AddSheet(page.name, panel)
        end
    end

    tabs[L("settings")] = function(settingsPanel)
        local sheet = settingsPanel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(10, 10, 10, 10)
        local pages = {}
        hook.Run("PopulateConfigurationButtons", pages)
        if not pages then return end

        for _, page in ipairs(pages) do
            local panel = sheet:Add("DPanel")
            panel:Dock(FILL)
            panel.Paint = function() end
            page.drawFunc(panel)
            sheet:AddSheet(page.name, panel)
        end
    end
end

function MODULE:CanDisplayCharInfo(name)
    local client = LocalPlayer()
    local character = client:getChar()
    local class = lia.class.list[character:getClass()]
    if name == "class" and not class then return false end
    return true
end