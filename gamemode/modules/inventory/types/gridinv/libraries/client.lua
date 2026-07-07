local PREVIEW_WIDTH = 260
local PREVIEW_GAP = 12
local PREVIEW_TOP_PADDING = 24
local PREVIEW_BOTTOM_PADDING = 24

local function createInventoryPreview(parentPanel, mainPanel)
    if not IsValid(parentPanel) or not IsValid(mainPanel) then return end
    local client = LocalPlayer()
    local character = IsValid(client) and client:getChar() or nil
    if not character then return end
    local preview = parentPanel:Add("EditablePanel")
    local previewHeight = math.max(parentPanel:GetTall() - PREVIEW_TOP_PADDING - PREVIEW_BOTTOM_PADDING, mainPanel:GetTall())
    preview:SetSize(PREVIEW_WIDTH, previewHeight)

    local modelPanel = preview:Add("liaModelPanel")
    modelPanel:Dock(FILL)
    modelPanel:SetFOV(36)
    local mX, mY = gui.MouseX, gui.MouseY
    modelPanel.LayoutEntity = function(panel, entity)
        local xR, yR = mX() / ScrW(), mY() / ScrH()
        local x = select(1, panel:LocalToScreen(panel:GetWide() / 2))
        local xR2 = x / ScrW()
        entity:SetPoseParameter("head_pitch", yR * 90 - 30)
        entity:SetPoseParameter("head_yaw", (xR - xR2) * 90 - 5)
        entity:SetAngles(Angle(0, 0, 0))
        entity:SetIK(false)
        panel:RunAnimation()
    end

    local model = character.getModel and character:getModel() or client:GetModel()
    modelPanel:SetModel(model)
    local entity = modelPanel:GetEntity()
    if IsValid(entity) then
        entity:SetSkin(character:getSkin())
        lia.util.applyBodygroups(entity, character:getBodygroups())
        hook.Run("SetupPlayerModel", entity, character)
        entity:SetupBones()
        local mins, maxs = entity:GetRenderBounds()
        local center = (mins + maxs) * 0.5
        local width = math.max(maxs.x - mins.x, maxs.y - mins.y)
        local height = math.max(maxs.z - mins.z, 1)
        local distance = math.max(width * 1.45, height * 0.8, 48)
        modelPanel:SetLookAt(Vector(0, 0, center.z))
        modelPanel:SetCamPos(Vector(distance, 0, center.z + height * 0.02))
    end

    preview:SetPos(mainPanel.x + mainPanel:GetWide() + PREVIEW_GAP, PREVIEW_TOP_PADDING)
    preview:MoveToFront()
    return preview
end

function MODULE:CreateInventoryPanel(inventory, parent)
    local panel = vgui.Create("liaGridInventory", parent)
    panel:setInventory(inventory)
    panel:Center()
    hook.Run("InventoryPanelCreated", panel, inventory, parent)
    return panel
end

function MODULE:InventoryItemRemoved(_, item)
    if not item.isBag then return end
    local bagInv = item:getInv()
    if not bagInv then return end
    local bagID = bagInv:getID()
    local panel = lia.gui["inv" .. bagID]
    if IsValid(panel) then
        panel:Remove()
        lia.gui["inv" .. bagID] = nil
    end
end

function MODULE:InventoryItemAdded(inventory, item)
    if not item.isBag then return end
    local bagInv = item:getInv()
    if not bagInv then return end
    local mainPanel = lia.gui["inv" .. inventory:getID()]
    if not IsValid(mainPanel) then return end
    if hook.Run("CanOpenBagPanel", item) == false then return end
    if IsValid(lia.gui["inv" .. bagInv:getID()]) then return end
    local bagPanel = bagInv:show(mainPanel)
    bagPanel:MoveRightOf(mainPanel, 4)
    lia.gui["inv" .. bagInv:getID()] = bagPanel
end

hook.Add("CreateMenuButtons", "liaInventory", function(tabs)
    local margin = 10
    tabs["inv"] = {
        name = "inv",
        icon = "icon16/box.png",
        shouldShow = function() return hook.Run("CanPlayerViewInventory") ~= false end,
        func = function(parentPanel)
            local inventory = LocalPlayer():getChar():getInv()
            if not inventory then return end
            local mainPanel = inventory:show(parentPanel)
            local panels = {}
            local totalWidth = 0
            local maxHeight = 0
            table.insert(panels, mainPanel)
            totalWidth = totalWidth + mainPanel:GetWide() + margin + PREVIEW_WIDTH + PREVIEW_GAP
            maxHeight = math.max(maxHeight, mainPanel:GetTall())
            for _, item in pairs(inventory:getItems()) do
                if item.isBag and hook.Run("CanOpenBagPanel", item) ~= false then
                    local bagInv = item:getInv()
                    if bagInv then
                        local bagPanel = bagInv:show(mainPanel)
                        lia.gui["inv" .. bagInv:getID()] = bagPanel
                        table.insert(panels, bagPanel)
                        totalWidth = totalWidth + bagPanel:GetWide() + margin
                        maxHeight = math.max(maxHeight, bagPanel:GetTall())
                    end
                end
            end

            local px, py, pw, ph = mainPanel:GetBounds()
            local xPos = px + pw / 2 - totalWidth / 2
            local yPos = py + ph / 2
            for _, panel in pairs(panels) do
                panel:ShowCloseButton(false)
                panel:SetPos(xPos, yPos - panel:GetTall() / 2)
                xPos = xPos + panel:GetWide() + margin
            end

            createInventoryPreview(parentPanel, mainPanel)
            hook.Add("PostRenderVGUI", mainPanel, function() hook.Run("PostDrawInventory", mainPanel, parentPanel) end)
        end
    }
end)
