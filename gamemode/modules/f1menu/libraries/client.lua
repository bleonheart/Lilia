local MODULE = MODULE
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

    if client:hasPrivilege("Access Module List") then
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
        table.sort(pages, function(a, b) return tostring(a.name):lower() < tostring(b.name):lower() end)
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
        table.sort(pages, function(a, b) return tostring(a.name) < tostring(b.name) end)
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

net.Receive("removeF1", function() if IsValid(lia.gui.menu) then lia.gui.menu:remove() end end)