DeriveGamemode("sandbox")
include("shared.lua")
-- Panel Visualizer Console Command
concommand.Add("lia_panelvisualizer", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.9, ScrH() * 0.9)
    frame:Center()
    frame:SetTitle("Lilia Panel Visualizer")
    frame:MakePopup()
    -- Create main container
    local mainPanel = vgui.Create("DPanel", frame)
    mainPanel:Dock(FILL)
    mainPanel:DockMargin(5, 5, 5, 5)
    mainPanel.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40)) end
    -- Create left panel (panel list)
    local leftPanel = vgui.Create("DPanel", mainPanel)
    leftPanel:Dock(LEFT)
    leftPanel:SetWide(300)
    leftPanel:DockMargin(0, 0, 5, 0)
    leftPanel.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50)) end
    -- Search box
    local searchBox = vgui.Create("DTextEntry", leftPanel)
    searchBox:Dock(TOP)
    searchBox:DockMargin(5, 5, 5, 5)
    searchBox:SetPlaceholderText("Search panels...")
    searchBox:SetTall(30)
    -- Scroll panel for panel list
    local scrollPanel = vgui.Create("DScrollPanel", leftPanel)
    scrollPanel:Dock(FILL)
    scrollPanel:DockMargin(5, 5, 5, 5)
    -- Right panel (preview area)
    local rightPanel = vgui.Create("DPanel", mainPanel)
    rightPanel:Dock(FILL)
    rightPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30))
        draw.SimpleText("Select a panel to preview", "DermaDefault", w / 2, h / 2, Color(150, 150, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Panel definitions
    local panelCategories = {
        {
            name = "Base GMod / Derma Panels",
            panels = {"Panel", "EditablePanel", "DPanel", "DFrame", "DButton", "DLabel", "DImage", "DImageButton", "DTextEntry", "DListView", "DListLayout", "DIconLayout", "DHTML", "DForm", "DScrollPanel", "DPropertySheet", "DNumSlider", "DColorMixer", "DComboBox", "DModelPanel", "DMenu", "AvatarImage", "ContentContainer", "ContentHeader", "ContentIcon", "SpawnmenuContentPanel"}
        },
        {
            name = "Lilia Custom Panels",
            panels = {"liaFrame", "liaButton", "liaEntry", "liaCheckbox", "liaComboBox", "liaScrollPanel", "liaSheet", "liaTabs", "liaTabButton", "liaMenu", "liaDermaMenu", "liaNotice", "liaNoticePanel", "liaProgressBar", "liaRadialPanel", "liaChatBox", "liaCharacter", "liaCharacterBiography", "liaCharacterModel", "liaCharacterConfirm", "liaCharInfo", "liaWorldMap", "liaOptionsPanel", "liaQuick", "liaScoreboard", "liaLockCircle", "liaPaintedNotification", "liaGridInventory", "liaVendor", "liaVendorEditor", "liaSemiTransparentDPanel", "liaModelPanel", "liaSpawnIcon", "liaDoorMenu", "liaItemIcon", "liaDListView"}
        }
    }

    -- Function to create preview
    local function createPreview(panelName)
        rightPanel:Clear()
        rightPanel.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30)) end
        -- Info panel at top
        local infoPanel = vgui.Create("DPanel", rightPanel)
        infoPanel:Dock(TOP)
        infoPanel:SetTall(60)
        infoPanel:DockMargin(10, 10, 10, 5)
        infoPanel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
            draw.SimpleText("Panel Type: " .. panelName, "DermaDefaultBold", 10, 10, Color(255, 255, 255))
            draw.SimpleText("Click 'Spawn Test Panel' to create an instance", "DermaDefault", 10, 35, Color(200, 200, 200))
        end

        -- Spawn button
        local spawnBtn = vgui.Create("DButton", infoPanel)
        spawnBtn:Dock(RIGHT)
        spawnBtn:DockMargin(5, 15, 10, 15)
        spawnBtn:SetWide(150)
        spawnBtn:SetText("Spawn Test Panel")
        spawnBtn.DoClick = function()
            local testPanel = vgui.Create(panelName)
            if IsValid(testPanel) then
                testPanel:SetSize(400, 300)
                testPanel:Center()
                testPanel:MakePopup()
                -- Set some default properties based on panel type
                if testPanel.SetTitle then testPanel:SetTitle("Test " .. panelName) end
                if testPanel.SetText then testPanel:SetText("Test " .. panelName) end
                -- Add close button for frames
                if panelName:find("Frame") then testPanel:SetDeleteOnClose(true) end
            else
                chat.AddText(Color(255, 100, 100), "Failed to create panel: " .. panelName)
            end
        end

        -- Preview container
        local previewContainer = vgui.Create("DPanel", rightPanel)
        previewContainer:Dock(FILL)
        previewContainer:DockMargin(10, 5, 10, 10)
        previewContainer.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40))
            -- Grid background
            surface.SetDrawColor(50, 50, 50)
            for i = 0, w, 20 do
                surface.DrawLine(i, 0, i, h)
            end

            for i = 0, h, 20 do
                surface.DrawLine(0, i, w, i)
            end
        end

        -- Try to create a preview instance
        local success, preview = pcall(function() return vgui.Create(panelName, previewContainer) end)
        if success and IsValid(preview) then
            preview:SetPos(20, 20)
            preview:SetSize(math.min(previewContainer:GetWide() - 40, 400), math.min(previewContainer:GetTall() - 40, 300))
            -- Configure preview based on type
            if preview.SetText then preview:SetText("Preview of " .. panelName) end
            if preview.SetTitle then preview:SetTitle("Preview " .. panelName) end
            if preview.SetValue then preview:SetValue(50) end
            -- Make it draggable in preview
            preview:SetMouseInputEnabled(true)
            preview:SetKeyboardInputEnabled(false)
        else
            local errorLabel = vgui.Create("DLabel", previewContainer)
            errorLabel:SetPos(20, 20)
            errorLabel:SetText("Cannot create preview for " .. panelName)
            errorLabel:SetTextColor(Color(255, 150, 150))
            errorLabel:SizeToContents()
        end
    end

    -- Populate panel list
    local function populateList(filter)
        scrollPanel:Clear()
        filter = filter and filter:lower() or ""
        for _, category in ipairs(panelCategories) do
            local hasVisiblePanels = false
            -- Check if any panels match filter
            if filter == "" then
                hasVisiblePanels = true
            else
                for _, panelName in ipairs(category.panels) do
                    if panelName:lower():find(filter, 1, true) then
                        hasVisiblePanels = true
                        break
                    end
                end
            end

            if hasVisiblePanels then
                -- Category header
                local categoryHeader = vgui.Create("DPanel", scrollPanel)
                categoryHeader:Dock(TOP)
                categoryHeader:SetTall(30)
                categoryHeader:DockMargin(0, 5, 0, 2)
                categoryHeader.Paint = function(self, w, h)
                    draw.RoundedBox(4, 0, 0, w, h, Color(70, 70, 70))
                    draw.SimpleText(category.name, "DermaDefaultBold", 10, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                -- Panel buttons
                for _, panelName in ipairs(category.panels) do
                    if filter == "" or panelName:lower():find(filter, 1, true) then
                        local btn = vgui.Create("DButton", scrollPanel)
                        btn:Dock(TOP)
                        btn:SetTall(25)
                        btn:DockMargin(5, 1, 5, 1)
                        btn:SetText(panelName)
                        btn.Paint = function(self, w, h)
                            local col = Color(60, 60, 60)
                            if self:IsHovered() then col = Color(80, 80, 80) end
                            draw.RoundedBox(2, 0, 0, w, h, col)
                        end

                        btn.DoClick = function() createPreview(panelName) end
                    end
                end
            end
        end
    end

    -- Search functionality
    searchBox.OnValueChange = function(self, value) populateList(value) end
    -- Initial population
    populateList()
    print("[Lilia] Panel Visualizer opened. Total panels: " .. (#panelCategories[1].panels + #panelCategories[2].panels))
end)