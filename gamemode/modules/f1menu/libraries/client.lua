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
            local joinable = false
            for _, class in pairs(lia.class.list) do
                if class.faction == client:Team() and lia.class.canBe(client, class.index) then
                    joinable = true
                    break
                end
            end

            if joinable then
                lia.gui.openClassesMenu()
            else
                vgui.Create("liaMenu")
            end
        end

        return true
    end
end

function MODULE:CreateInformationButtons(pages)
    local client = LocalPlayer()
    local entitiesByCreator = {}
    for _, ent in ents.Iterator() do
        if IsValid(ent) and ent.GetCreator and IsValid(ent:GetCreator()) then
            local owner = ent:GetCreator():Nick()
            entitiesByCreator[owner] = entitiesByCreator[owner] or {}
            table.insert(entitiesByCreator[owner], ent)
        end
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

    if not table.IsEmpty(entitiesByCreator) then
        table.insert(pages, {
            name = L("entities"),
            drawFunc = function(entitiesPanel)
                local sheet = entitiesPanel:Add("DPropertySheet")
                sheet:Dock(FILL)
                sheet:DockMargin(0, 0, 0, 10)
                for owner, list in SortedPairs(entitiesByCreator) do
                    local page = vgui.Create("DPanel", sheet)
                    page:Dock(FILL)
                    page.Paint = function() end
                    local searchEntry = vgui.Create("DTextEntry", page)
                    searchEntry:Dock(TOP)
                    searchEntry:DockMargin(0, 0, 0, 5)
                    searchEntry:SetTall(30)
                    searchEntry:SetPlaceholderText(L("searchEntities"))
                    local infoPanel = vgui.Create("DPanel", page)
                    infoPanel:Dock(TOP)
                    infoPanel:DockMargin(10, 0, 10, 5)
                    infoPanel:SetTall(30)
                    infoPanel.Paint = function(_, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 200)) end
                    local infoLabel = vgui.Create("DLabel", infoPanel)
                    infoLabel:Dock(FILL)
                    infoLabel:SetFont("liaSmallFont")
                    infoLabel:SetTextColor(color_white)
                    infoLabel:SetContentAlignment(5)
                    infoLabel:SetText(L("totalPlayerEntities", #list))
                    local scroll = vgui.Create("DScrollPanel", page)
                    scroll:Dock(FILL)
                    scroll:DockPadding(0, 0, 0, 10)
                    local canvas = scroll:GetCanvas()
                    local entries = {}
                    for _, ent in ipairs(list) do
                        local className = ent:GetClass()
                        local itemPanel = vgui.Create("DPanel", canvas)
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
                            local infoLabel2 = vgui.Create("DLabel", lastModelFrame)
                            infoLabel2:SetText(L("pressInstructions"))
                            infoLabel2:SetFont("liaMediumFont")
                            infoLabel2:SizeToContents()
                            infoLabel2:Dock(TOP)
                            infoLabel2:DockMargin(0, 10, 0, 0)
                            infoLabel2:SetContentAlignment(5)
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
                        btnContainer:SetWide(390)
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
                        btnWaypoint:Dock(LEFT)
                        btnWaypoint:DockMargin(5, 0, 5, 0)
                        btnWaypoint:SetWide(btnW)
                        btnWaypoint:SetTall(btnH)
                        btnWaypoint:SetText(L("waypointButton"))
                        btnWaypoint.DoClick = function() client:setWaypoint(className, ent:GetPos()) end
                        entries[#entries + 1] = itemPanel
                    end

                    searchEntry.OnTextChanged = function(entry)
                        local q = entry:GetValue():lower()
                        for _, pnl in ipairs(entries) do
                            pnl:SetVisible(q == "" or pnl.infoText:find(q, 1, true))
                        end

                        canvas:InvalidateLayout()
                        canvas:SizeToChildren(false, true)
                    end

                    sheet:AddSheet(owner .. " - " .. #list .. " " .. L("entities"), page)
                end
            end
        })
    end

    if client:hasPrivilege("Staff Permission — Access Module List") then
        table.insert(pages, {
            name = L("modules"),
            drawFunc = function(modulesPanel)
                local searchEntry = vgui.Create("DTextEntry", modulesPanel)
                searchEntry:Dock(TOP)
                searchEntry:DockMargin(10, 0, 10, 5)
                searchEntry:SetTall(30)
                searchEntry:SetPlaceholderText(L("searchModules"))
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
        sheet:DockMargin(20, 20, 20, 20)
        local pages = {}
        hook.Run("CreateInformationButtons", pages)
        if not pages then return end
        for _, page in ipairs(pages) do
            local pnl = vgui.Create("DPanel", sheet)
            pnl:Dock(FILL)
            pnl.Paint = function() end
            page.drawFunc(pnl)
            sheet:AddSheet(page.name, pnl)
        end
    end

    tabs[L("settings")] = function(settingsPanel)
        local sheet = settingsPanel:Add("DPropertySheet")
        sheet:Dock(FILL)
        sheet:DockMargin(20, 20, 20, 20)
        local pages = {}
        hook.Run("PopulateConfigurationButtons", pages)
        if not pages then return end
        for _, page in ipairs(pages) do
            local pnl = vgui.Create("DPanel", sheet)
            pnl:Dock(FILL)
            pnl.Paint = function() end
            page.drawFunc(pnl)
            sheet:AddSheet(page.name, pnl)
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