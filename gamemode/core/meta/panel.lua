--[[
    Panel Meta

    Panel management system for the Lilia framework.
]]
--[[
    Overview:
        The panel meta table provides comprehensive functionality for managing VGUI panels, UI interactions, and panel operations in the Lilia framework. It handles panel event listening, inventory synchronization, UI updates, and panel-specific operations. The meta table operates primarily on the client side, with the server providing data that panels can listen to and display. It includes integration with the inventory system for inventory change notifications, character system for character data display, network system for data synchronization, and UI system for panel management. The meta table ensures proper panel event handling, inventory synchronization, UI updates, and comprehensive panel lifecycle management from creation to destruction.
]]
local panelMeta = FindMetaTable("Panel")

-- Store original functions before detouring for use in setScaledPos/setScaledSize
local originalSetSize = panelMeta.SetSize
local originalSetPos = panelMeta.SetPos
--[[
    Purpose:
        Sets up event listeners for inventory changes on a panel

    When Called:
        When a UI panel needs to respond to inventory modifications, typically during panel initialization

    Parameters:
        inventory (Inventory)
            The inventory object to listen for changes on

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

    Low Complexity:
        ```lua
        -- Simple: Set up inventory listening for a basic panel
        panel:liaListenForInventoryChanges(playerInventory)
        ```

    Medium Complexity:
        ```lua
        -- Medium: Set up inventory listening with conditional setup
        if playerInventory then
            characterPanel:liaListenForInventoryChanges(playerInventory)
        end
        ```

    High Complexity:
        ```lua
        -- High: Set up inventory listening for multiple panels with error handling
        local panels = {inventoryPanel, characterPanel, equipmentPanel}
        for _, pnl in ipairs(panels) do
            if IsValid(pnl) and playerInventory then
                pnl:liaListenForInventoryChanges(playerInventory)
            end
        end
        ```
]]
function panelMeta:liaListenForInventoryChanges(inventory)
    assert(inventory, L("noInventorySet"))
    local id = inventory:getID()
    self:liaDeleteInventoryHooks(id)
    _LIA_INV_PANEL_ID = (_LIA_INV_PANEL_ID or 0) + 1
    local hookID = "liaInventoryListener" .. _LIA_INV_PANEL_ID
    self.liaHookID = self.liaHookID or {}
    self.liaHookID[id] = hookID
    self.liaToRemoveHooks = self.liaToRemoveHooks or {}
    self.liaToRemoveHooks[id] = {}
    local function listenForInventoryChange(eventName, panelHookName)
        panelHookName = panelHookName or eventName
        hook.Add(eventName, hookID, function(inv, ...)
            if not IsValid(self) then return end
            if not isfunction(self[panelHookName]) then return end
            local args = {...}
            args[#args + 1] = inv
            self[panelHookName](self, unpack(args))
            if eventName == "InventoryDeleted" then self:liaDeleteInventoryHooks(id) end
        end)

        table.insert(self.liaToRemoveHooks[id], eventName)
    end

    listenForInventoryChange("InventoryInitialized")
    listenForInventoryChange("InventoryDeleted")
    listenForInventoryChange("InventoryDataChanged")
    listenForInventoryChange("InventoryItemAdded")
    listenForInventoryChange("InventoryItemRemoved")
    hook.Add("ItemDataChanged", hookID, function(item, key, oldValue, newValue)
        if not IsValid(self) or not inventory.items[item:getID()] then return end
        if not isfunction(self.InventoryItemDataChanged) then return end
        self:InventoryItemDataChanged(item, key, oldValue, newValue, inventory)
    end)

    table.insert(self.liaToRemoveHooks[id], "ItemDataChanged")
end

--[[
    Purpose:
        Removes inventory change event listeners from a panel

    When Called:
        When a panel no longer needs to listen to inventory changes, during cleanup, or when switching inventories

    Parameters:
        id (number)
            The specific inventory ID to remove hooks for, or nil to remove all hooks

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

    Low Complexity:
        ```lua
        -- Simple: Remove hooks for a specific inventory
        panel:liaDeleteInventoryHooks(inventoryID)
        ```

    Medium Complexity:
        ```lua
        -- Medium: Clean up hooks when closing a panel
        if IsValid(panel) then
            panel:liaDeleteInventoryHooks()
        end
        ```

    High Complexity:
        ```lua
        -- High: Clean up multiple panels with different inventory IDs
        local panels = {inventoryPanel, equipmentPanel, storagePanel}
        local inventoryIDs = {playerInvID, equipmentInvID, storageInvID}

        for i, pnl in ipairs(panels) do
            if IsValid(pnl) then
                pnl:liaDeleteInventoryHooks(inventoryIDs[i])
            end
        end
        ```
]]
function panelMeta:liaDeleteInventoryHooks(id)
    if not self.liaHookID then return end
    if id == nil then
        for invID, hookIDs in pairs(self.liaToRemoveHooks) do
            for i = 1, #hookIDs do
                if IsValid(self.liaHookID) then hook.Remove(hookIDs[i], self.liaHookID) end
            end

            self.liaToRemoveHooks[invID] = nil
        end
        return
    end

    if not self.liaHookID[id] then return end
    for i = 1, #self.liaToRemoveHooks[id] do
        hook.Remove(self.liaToRemoveHooks[id][i], self.liaHookID[id])
    end

    self.liaToRemoveHooks[id] = nil
end

--[[
    Purpose:
        Sets the position of a panel with automatic screen scaling

    When Called:
        When positioning UI elements that need to adapt to different screen resolutions

    Parameters:
        x (number)
            The horizontal position value to be scaled
        y (number)
            The vertical position value to be scaled

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

    Low Complexity:
        ```lua
        -- Simple: Position a button at scaled coordinates
        button:setScaledPos(100, 50)
        ```

    Medium Complexity:
        ```lua
        -- Medium: Position panel based on screen dimensions
        local x = ScrW() * 0.5 - 200
        local y = ScrH() * 0.3
        panel:setScaledPos(x, y)
        ```

    High Complexity:
        ```lua
        -- High: Position multiple panels with responsive layout
        local panels = {mainPanel, sidePanel, footerPanel}
        local positions = {
            {ScrW() * 0.1, ScrH() * 0.1},
            {ScrW() * 0.7, ScrH() * 0.1},
            {ScrW() * 0.1, ScrH() * 0.8}
        }

        for i, pnl in ipairs(panels) do
            if IsValid(pnl) then
                pnl:setScaledPos(positions[i][1], positions[i][2])
            end
        end
        ```
]]
function panelMeta:setScaledPos(x, y)
    if not IsValid(self) then return end
    if not originalSetPos then
        ErrorNoHalt("[Lilia] setScaledPos: Panel does not have SetPos method. Panel type: " .. tostring(self.ClassName or "Unknown") .. "\n")
        return
    end

    -- Use original function directly to avoid double-scaling
    originalSetPos(self, ScreenScale(x), ScreenScaleH(y))
end

--[[
    Purpose:
        Sets the size of a panel with automatic screen scaling

    When Called:
        When sizing UI elements that need to adapt to different screen resolutions

    Parameters:
        w (number)
            The width value to be scaled
        h (number)
            The height value to be scaled

    Returns:
        Nothing

    Realm:
        Client

    Example Usage:

    Low Complexity:
        ```lua
        -- Simple: Set panel size with scaled dimensions
        panel:setScaledSize(400, 300)
        ```

    Medium Complexity:
        ```lua
        -- Medium: Set size based on screen proportions
        local w = ScrW() * 0.8
        local h = ScrH() * 0.6
        panel:setScaledSize(w, h)
        ```

    High Complexity:
        ```lua
        -- High: Set sizes for multiple panels with responsive layout
        local panels = {mainPanel, sidePanel, footerPanel}
        local sizes = {
            {ScrW() * 0.7, ScrH() * 0.6},
            {ScrW() * 0.25, ScrH() * 0.6},
            {ScrW() * 0.95, ScrH() * 0.1}
        }

        for i, pnl in ipairs(panels) do
            if IsValid(pnl) then
                pnl:setScaledSize(sizes[i][1], sizes[i][2])
            end
        end
        ```
]]
function panelMeta:setScaledSize(w, h)
    if not IsValid(self) then return end
    if not originalSetSize then
        lia.error("[Lilia] setScaledSize: Panel does not have SetSize method. Panel type: " .. tostring(self.ClassName or "Unknown") .. "\n")
        return
    end

    -- Use original function directly to avoid double-scaling
    originalSetSize(self, ScreenScale(w), ScreenScaleH(h))
end

-- Auto-scaling meta: Detours all derma functions that resize panels
do
    -- Store original functions (SetSize and SetPos already stored above)
    local originalSetWide = panelMeta.SetWide
    local originalSetTall = panelMeta.SetTall
    local originalDockPadding = panelMeta.DockPadding
    local originalDockMargin = panelMeta.DockMargin
    local originalSetMinWidth = panelMeta.SetMinWidth
    local originalSetMinHeight = panelMeta.SetMinHeight
    local originalSetMaxWidth = panelMeta.SetMaxWidth
    local originalSetMaxHeight = panelMeta.SetMaxHeight

    -- Detour SetSize
    function panelMeta:SetSize(w, h)
        if IsValid(self) and w and h then
            return originalSetSize(self, ScreenScale(w), ScreenScaleH(h))
        end
        return originalSetSize(self, w, h)
    end

    -- Detour SetPos
    function panelMeta:SetPos(x, y)
        if IsValid(self) and x and y then
            return originalSetPos(self, ScreenScale(x), ScreenScaleH(y))
        end
        return originalSetPos(self, x, y)
    end

    -- Detour SetWide
    function panelMeta:SetWide(w)
        if IsValid(self) and w then
            return originalSetWide(self, ScreenScale(w))
        end
        return originalSetWide(self, w)
    end

    -- Detour SetTall
    function panelMeta:SetTall(h)
        if IsValid(self) and h then
            return originalSetTall(self, ScreenScaleH(h))
        end
        return originalSetTall(self, h)
    end

    -- Detour DockPadding
    function panelMeta:DockPadding(left, top, right, bottom)
        if IsValid(self) and left and top and right and bottom then
            return originalDockPadding(self, ScreenScale(left), ScreenScaleH(top), ScreenScale(right), ScreenScaleH(bottom))
        end
        return originalDockPadding(self, left, top, right, bottom)
    end

    -- Detour DockMargin
    function panelMeta:DockMargin(left, top, right, bottom)
        if IsValid(self) and left and top and right and bottom then
            return originalDockMargin(self, ScreenScale(left), ScreenScaleH(top), ScreenScale(right), ScreenScaleH(bottom))
        end
        return originalDockMargin(self, left, top, right, bottom)
    end

    -- Detour SetMinWidth
    function panelMeta:SetMinWidth(w)
        if IsValid(self) and w then
            return originalSetMinWidth(self, ScreenScale(w))
        end
        return originalSetMinWidth(self, w)
    end

    -- Detour SetMinHeight
    function panelMeta:SetMinHeight(h)
        if IsValid(self) and h then
            return originalSetMinHeight(self, ScreenScaleH(h))
        end
        return originalSetMinHeight(self, h)
    end

    -- Detour SetMaxWidth
    function panelMeta:SetMaxWidth(w)
        if IsValid(self) and w then
            return originalSetMaxWidth(self, ScreenScale(w))
        end
        return originalSetMaxWidth(self, w)
    end

    -- Detour SetMaxHeight
    function panelMeta:SetMaxHeight(h)
        if IsValid(self) and h then
            return originalSetMaxHeight(self, ScreenScaleH(h))
        end
        return originalSetMaxHeight(self, h)
    end
end