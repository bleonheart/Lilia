--[[
    Hooks:
        OnWeaponOverridesBulkSynced(overrides)

    Purpose:
        Runs after the full static weapon override table has been synchronized to the client.

    Category:
        Items

    Parameters:
        overrides (table)
            The full weapon override table keyed by weapon class name.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("OnWeaponOverridesBulkSynced", "liaExampleOnWeaponOverridesBulkSynced", function(overrides)
            print("[Weapons] Synced static overrides:", table.Count(overrides))
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        OnWeaponOverrideUpdated(className, key, value)

    Purpose:
        Runs after a single static weapon override field has been updated on the client.

    Category:
        Items

    Parameters:
        className (string)
            The weapon class whose override changed.

        key (string)
            The item definition field that was updated.

        value (any)
            The new override value.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("OnWeaponOverrideUpdated", "liaExampleOnWeaponOverrideUpdated", function(className, key, value)
            print("[Weapons] Updated", className, key)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        OnWeaponRuntimeOverridesBulkSynced(overrides)

    Purpose:
        Runs after the full runtime weapon override table has been synchronized to the client.

    Category:
        Items

    Parameters:
        overrides (table)
            The full runtime override table keyed by weapon class name and dot path.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("OnWeaponRuntimeOverridesBulkSynced", "liaExampleOnWeaponRuntimeOverridesBulkSynced", function(overrides)
            print("[Weapons] Synced runtime overrides:", table.Count(overrides))
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        OnWeaponRuntimeOverrideUpdated(className, dotPath, value)

    Purpose:
        Runs after a single runtime weapon override path has been updated on the client.

    Category:
        Items

    Parameters:
        className (string)
            The weapon class whose runtime override changed.

        dotPath (string)
            The nested runtime path that was updated.

        value (any)
            The new runtime override value.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("OnWeaponRuntimeOverrideUpdated", "liaExampleOnWeaponRuntimeOverrideUpdated", function(className, dotPath, value)
            print("[Weapons] Runtime update", className, dotPath)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        CharListUpdated(oldCharList, newCharList)

    Purpose:
        Runs after the client receives a replacement character ID list for an already initialized character menu session.

    Category:
        Character

    Parameters:
        oldCharList (table)
            The previous array of character IDs stored clientside.

        newCharList (table)
            The newly received array of character IDs.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("CharListUpdated", "liaExampleCharListUpdated", function(oldCharList, newCharList)
            print("[Characters] Updated list size:", #newCharList)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        InventoryDataChanged(instance, key, oldValue, value)

    Purpose:
        Runs after an inventory data field has been updated from a network message.

    Category:
        Inventory

    Parameters:
        instance (Inventory)
            The inventory instance whose data changed.

        key (string)
            The inventory data key that was updated.

        oldValue (any)
            The previous stored value.

        value (any)
            The new value assigned to the inventory.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("InventoryDataChanged", "liaExampleInventoryDataChanged", function(instance, key, oldValue, value)
            print("[Inventory] Data changed:", key)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        ItemInitialized(item)

    Purpose:
        Runs after a clientside item instance has been created or refreshed from networked item data.

    Category:
        Inventory

    Parameters:
        item (Item)
            The item instance that was initialized.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("ItemInitialized", "liaExampleItemInitialized", function(item)
            print("[Inventory] Initialized item:", item.uniqueID)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        InventoryInitialized(instance)

    Purpose:
        Runs after a clientside inventory instance and all of its current items have been initialized.

    Category:
        Inventory

    Parameters:
        instance (Inventory)
            The inventory instance that was initialized.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("InventoryInitialized", "liaExampleInventoryInitialized", function(instance)
            print("[Inventory] Ready:", instance:getID())
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        InventoryDeleted(instance)

    Purpose:
        Runs immediately before a clientside inventory instance is removed from the inventory cache.

    Category:
        Inventory

    Parameters:
        instance (Inventory)
            The inventory instance that is being deleted.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("InventoryDeleted", "liaExampleInventoryDeleted", function(instance)
            print("[Inventory] Deleted:", instance:getID())
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        ItemDeleted(instance)

    Purpose:
        Runs after a clientside item instance has been removed from its inventory and instance cache.

    Category:
        Inventory

    Parameters:
        instance (Item)
            The item instance that was deleted.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("ItemDeleted", "liaExampleItemDeleted", function(instance)
            if instance then
                print("[Inventory] Deleted item:", instance.uniqueID)
            end
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        OnCharNetVarChanged(character, key, oldVar, value)

    Purpose:
        Runs after a networked character variable has been updated on the client.

    Category:
        Character

    Parameters:
        character (Character)
            The character whose networked variable changed.

        key (string)
            The networked variable key that changed.

        oldVar (any)
            The previous stored value.

        value (any)
            The new networked value.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("OnCharNetVarChanged", "liaExampleOnCharNetVarChanged", function(character, key, oldVar, value)
            print("[Character] Net var changed:", key)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        ItemQuantityChanged(item, oldValue, quantity)

    Purpose:
        Runs after a stackable item quantity has been updated from the server.

    Category:
        Inventory

    Parameters:
        item (Item)
            The item whose quantity changed.

        oldValue (number)
            The previous quantity.

        quantity (number)
            The new quantity.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("ItemQuantityChanged", "liaExampleItemQuantityChanged", function(item, oldValue, quantity)
            print("[Inventory] Quantity changed:", oldValue, quantity)
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        GetNPCDialogOptions(client, npc, canCustomize)

    Purpose:
        Allows plugins or modules to add extra dialog options before an NPC conversation menu is displayed.

    Category:
        Dialog

    Parameters:
        client (Player)
            The local player opening the dialog.

        npc (Entity)
            The NPC entity that opened the dialog, if valid.

        canCustomize (boolean)
            Whether the dialog session allows customization options.

    Returns:
        table|nil
            Return a table of extra conversation options to merge into the NPC dialog. Returning nil allows the default behavior to continue.

    Example Usage:
        ```lua
        hook.Add("GetNPCDialogOptions", "liaExampleGetNPCDialogOptions", function(client, npc, canCustomize)
            return {
                AskForWork = {
                    statement = "Any work available?"
                }
            }
        end)
        ```

    Realm:
        Client
]]
--[[
    Hooks:
        CharListLoaded(table newCharList)

    Purpose:
        Runs the first time the client receives its available character ID list during a menu session.

    Category:
        Character

    Parameters:
        newCharList (table)
            The newly received sequential array of character IDs available to the client.

    Example Usage:
        ```lua
        hook.Add("CharListLoaded", "liaExampleCharListLoaded", function(newCharList)
            print("[Characters] Loaded list size:", #newCharList)
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        InventoryItemAdded(Inventory inventory, Item item)

    Purpose:
        Runs after an initialized item instance is inserted into a clientside inventory cache.

    Category:
        Inventory

    Parameters:
        inventory (Inventory)
            The inventory instance that received the item.

        item (Item)
            The item instance that was added to the inventory.

    Example Usage:
        ```lua
        hook.Add("InventoryItemAdded", "liaExampleInventoryItemAdded", function(inventory, item)
            print("[Inventory] Added", item.uniqueID, "to", inventory:getID())
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        InventoryItemRemoved(Inventory inventory, Item item)

    Purpose:
        Runs after an item instance is removed from a clientside inventory cache through inventory sync or item deletion.

    Category:
        Inventory

    Parameters:
        inventory (Inventory)
            The inventory instance the item was removed from.

        item (Item)
            The item instance that was removed.

    Example Usage:
        ```lua
        hook.Add("InventoryItemRemoved", "liaExampleInventoryItemRemoved", function(inventory, item)
            print("[Inventory] Removed", item.uniqueID, "from", inventory:getID())
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
--[[
    Hooks:
        ItemDataChanged(Item item, string key, any oldValue, any newValue)

    Purpose:
        Runs after a clientside item data field has been updated from a networked item data sync.

    Category:
        Inventory

    Parameters:
        item (Item)
            The item instance whose data changed.

        key (string)
            The item data key that was updated.

        oldValue (any)
            The previous stored value for the item data key.

        newValue (any)
            The new value assigned to the item data key.

    Example Usage:
        ```lua
        hook.Add("ItemDataChanged", "liaExampleItemDataChanged", function(item, key, oldValue, newValue)
            print("[Item] Data changed:", item.uniqueID, key)
        end)
        ```

    Returns:
        nil

    Realm:
        Client
]]
net.Receive("liaSetWaypoint", function()
    local name = net.ReadString()
    local pos = net.ReadVector()
    local logo = net.ReadString()
    LocalPlayer():setWaypoint(name, pos, logo ~= "" and logo or nil)
end)

net.Receive("liaWeaponOverrideSync", function()
    local isBulkSync = net.ReadBool()
    if isBulkSync then
        local overrides = net.ReadTable()
        if istable(overrides) then
            lia.item.WeaponOverrides = overrides
            for className, data in pairs(overrides) do
                local itemDef = lia.item.list[className]
                if itemDef and istable(data) then
                    for k, v in pairs(data) do
                        itemDef[k] = v
                    end
                end
            end

            hook.Run("OnWeaponOverridesBulkSynced", overrides)
        end
    else
        local className = net.ReadString()
        local key = net.ReadString()
        local value = net.ReadType()
        lia.item.WeaponOverrides[className] = lia.item.WeaponOverrides[className] or {}
        lia.item.WeaponOverrides[className][key] = value
        local itemDef = lia.item.list[className]
        if itemDef then itemDef[key] = value end
        hook.Run("OnWeaponOverrideUpdated", className, key, value)
    end
end)

net.Receive("liaWeaponRuntimeOverrideSync", function()
    local isBulkSync = net.ReadBool()
    if isBulkSync then
        local overrides = net.ReadTable()
        if istable(overrides) then
            lia.item.WeaponRuntimeOverrides = overrides
            for className, paths in pairs(overrides) do
                local wep = weapons.GetStored(className)
                if wep then
                    for dotPath, value in pairs(paths) do
                        lia.item.applyRuntimeOverridePath(wep, dotPath, value)
                    end
                end
            end

            hook.Run("OnWeaponRuntimeOverridesBulkSynced", overrides)
        end
    else
        local className = net.ReadString()
        local dotPath = net.ReadString()
        local value = net.ReadType()
        if dotPath == "" then
            lia.item.WeaponRuntimeOverrides[className] = nil
            local defaults = lia.item.defaultRuntimeValues and lia.item.defaultRuntimeValues[className] or {}
            local wep = weapons.GetStored(className)
            if wep then
                for path, orig in pairs(defaults) do
                    lia.item.applyRuntimeOverridePath(wep, path, orig)
                end
            end
        else
            lia.item.WeaponRuntimeOverrides[className] = lia.item.WeaponRuntimeOverrides[className] or {}
            lia.item.WeaponRuntimeOverrides[className][dotPath] = value
            local wep = weapons.GetStored(className)
            if wep then lia.item.applyRuntimeOverridePath(wep, dotPath, value) end
            hook.Run("OnWeaponRuntimeOverrideUpdated", className, dotPath, value)
        end
    end
end)

net.Receive("liaClassUpdate", function()
    local joinedClient = net.ReadEntity()
    if lia.gui.classes and lia.gui.classes:IsVisible() then
        if joinedClient == LocalPlayer() then
            lia.gui.classes:loadClasses()
        else
            for _, v in ipairs(lia.gui.classes.classPanels) do
                local data = v.data
                v:setNumber(#lia.class.getPlayers(data.index))
            end
        end
    end
end)

net.Receive("liaCharList", function()
    local newCharList = {}
    local length = net.ReadUInt(32)
    for i = 1, length do
        newCharList[i] = net.ReadUInt(32)
    end

    local oldCharList = lia.characters
    lia.characters = newCharList
    if oldCharList then
        hook.Run("CharListUpdated", oldCharList, newCharList)
    else
        hook.Run("CharListLoaded", newCharList)
    end

    hook.Run("ResetCharacterPanel")
end)

local function wrapText(text, font, maxWidth)
    surface.SetFont(font)
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end

    local lines = {}
    local currentLine = ""
    for _, word in ipairs(words) do
        local testLine = currentLine == "" and word or currentLine .. " " .. word
        local testW, _ = surface.GetTextSize(testLine)
        if testW <= maxWidth then
            currentLine = testLine
        else
            if currentLine ~= "" then
                table.insert(lines, currentLine)
                currentLine = word
            else
                local wordW, _ = surface.GetTextSize(word)
                if wordW > maxWidth then
                    local chars = {}
                    for char in word:gmatch(".") do
                        table.insert(chars, char)
                    end

                    local splitLine = ""
                    for _, char in ipairs(chars) do
                        local testChar = splitLine .. char
                        local charW = surface.GetTextSize(testChar)
                        if charW <= maxWidth then
                            splitLine = testChar
                        else
                            if splitLine ~= "" then
                                table.insert(lines, splitLine)
                                splitLine = char
                            else
                                table.insert(lines, char)
                                splitLine = ""
                            end
                        end
                    end

                    if splitLine ~= "" then
                        currentLine = splitLine
                    else
                        currentLine = ""
                    end
                else
                    table.insert(lines, word)
                    currentLine = ""
                end
            end
        end
    end

    if currentLine ~= "" then table.insert(lines, currentLine) end
    return lines
end

local PaintedNotificationPanel = {}
function PaintedNotificationPanel:Init()
    self.labelText = ""
    self.labelColor = Color(255, 255, 255)
    self.messageText = ""
    self.textColor = Color(255, 255, 255)
    self.messageLines = {}
end

function PaintedNotificationPanel:Paint(w, h)
    local labelPadding = 6
    local labelSpacing = 4
    surface.SetFont("LiliaFont.18b")
    local labelW, labelH = surface.GetTextSize(self.labelText)
    local labelBoxW = labelW + labelPadding * 2
    local labelBoxH = labelH + labelPadding * 2
    draw.RoundedBox(4, 0, 0, labelBoxW, labelBoxH, self.labelColor)
    local shadowOffset = 1
    draw.SimpleText(self.labelText, "LiliaFont.18b", labelPadding + shadowOffset, labelPadding + shadowOffset, Color(0, 0, 0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.labelText, "LiliaFont.18b", labelPadding, labelPadding, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    surface.SetFont("LiliaFont.20")
    local msgX = labelBoxW + labelSpacing
    local msgY = labelPadding
    local _, lineHeight = surface.GetTextSize("A")
    for i, line in ipairs(self.messageLines) do
        local yPos = msgY + (i - 1) * (lineHeight + 2)
        surface.SetTextColor(Color(0, 0, 0, 100))
        surface.SetTextPos(msgX + shadowOffset, yPos + shadowOffset)
        surface.DrawText(line)
        surface.SetTextColor(self.textColor)
        surface.SetTextPos(msgX, yPos)
        surface.DrawText(line)
    end
end

function PaintedNotificationPanel:SetNotification(labelText, labelColor, messageText, textColor)
    self.labelText = labelText
    self.labelColor = labelColor
    self.messageText = messageText
    self.textColor = textColor
    self:RecalculateLayout()
end

function PaintedNotificationPanel:RecalculateLayout()
    if not self.messageText then return end
    surface.SetFont("LiliaFont.18b")
    local labelW, labelH = surface.GetTextSize(self.labelText)
    local labelBoxW = labelW + 12
    local labelBoxH = labelH + 12
    local panelWidth = self:GetWide() > 0 and self:GetWide() or (ScrW() * 0.3)
    local maxWidth = panelWidth - labelBoxW - 20
    surface.SetFont("LiliaFont.20")
    self.messageLines = wrapText(self.messageText, "LiliaFont.20", math.max(maxWidth, 100))
    local _, lineHeight = surface.GetTextSize("A")
    local totalMsgH = #self.messageLines * (lineHeight + 2)
    self:SetSize(panelWidth, math.max(labelBoxH, totalMsgH + 12))
end

function PaintedNotificationPanel:OnSizeChanged()
    self:RecalculateLayout()
end

vgui.Register("liaPaintedNotification", PaintedNotificationPanel, "DPanel")
net.Receive("liaServerChatAddText", function()
    local args = net.ReadTable()
    if #args >= 3 and IsColor(args[1]) and isstring(args[2]) and IsColor(args[3]) then
        local labelColor = args[1]
        local labelText = args[2]
        local textColor = args[3]
        local messageText = ""
        for i = 4, #args do
            if isstring(args[i]) then messageText = messageText .. args[i] end
        end

        if (labelText == "DEATH" and labelColor.r == 255 and labelColor.g == 0 and labelColor.b == 0) or (labelText == "INSERT" and labelColor.r == 255 and labelColor.g == 165 and labelColor.b == 0) or (labelText == "Inventory" and labelColor.r == 255 and labelColor.g == 0 and labelColor.b == 0) then
            local chatPanel = lia.module.get("chatbox") and lia.module.get("chatbox").panel
            if IsValid(chatPanel) and IsValid(chatPanel.scroll) then
                local paintedPanel = vgui.Create("liaPaintedNotification", chatPanel.scroll)
                paintedPanel:SetWide(chatPanel:GetWide() - 16)
                paintedPanel:SetNotification(labelText, labelColor, messageText, textColor)
                paintedPanel.start = CurTime() + 8
                paintedPanel.finish = paintedPanel.start + 12
                paintedPanel.Think = function(p)
                    if chatPanel.active then
                        p:SetAlpha(255)
                    else
                        local fraction = math.TimeFraction(p.start, p.finish, CurTime())
                        local alpha = 255 - (fraction * 255)
                        p:SetAlpha(math.max(alpha, 0))
                    end
                end

                chatPanel.list = chatPanel.list or {}
                chatPanel.list[#chatPanel.list + 1] = paintedPanel
                paintedPanel:SetPos(0, chatPanel.lastY or 0)
                chatPanel.lastY = (chatPanel.lastY or 0) + paintedPanel:GetTall() + 2
                timer.Simple(0.01, function() if IsValid(chatPanel.scroll) and IsValid(paintedPanel) then chatPanel.scroll:ScrollToChild(paintedPanel) end end)
                return
            end
        end
    end

    chat.AddText(unpack(args))
end)

local pendingShadowed = {}
local function deliverShadowed(args)
    local chatModule = lia.module.get("chatbox")
    hook.Run("CreateChatboxPanel")
    local chatPanel = chatModule and chatModule.panel or lia.gui.chat
    if IsValid(chatPanel) and IsValid(chatPanel.scroll) and #args >= 3 and IsColor(args[1]) and isstring(args[2]) and IsColor(args[3]) then
        local labelColor = args[1]
        local labelText = args[2]
        local textColor = args[3]
        local messageText = ""
        for i = 4, #args do
            if isstring(args[i]) then messageText = messageText .. args[i] end
        end

        local paintedPanel = vgui.Create("liaPaintedNotification", chatPanel.scroll)
        paintedPanel:SetWide(chatPanel:GetWide() - 16)
        paintedPanel:SetNotification(labelText, labelColor, messageText, textColor)
        paintedPanel.start = CurTime() + 8
        paintedPanel.finish = paintedPanel.start + 12
        paintedPanel.Think = function(p)
            if chatPanel.active then
                p:SetAlpha(255)
            else
                local fraction = math.TimeFraction(p.start, p.finish, CurTime())
                local alpha = 255 - (fraction * 255)
                p:SetAlpha(math.max(alpha, 0))
            end
        end

        chatPanel.list = chatPanel.list or {}
        chatPanel.list[#chatPanel.list + 1] = paintedPanel
        paintedPanel:SetPos(0, chatPanel.lastY or 0)
        chatPanel.lastY = (chatPanel.lastY or 0) + paintedPanel:GetTall() + 2
        timer.Simple(0.01, function() if IsValid(chatPanel.scroll) and IsValid(paintedPanel) then chatPanel.scroll:ScrollToChild(paintedPanel) end end)
        if not chatPanel.skipPersist then
            lia.chat = lia.chat or {}
            lia.chat.persistedMessages = lia.chat.persistedMessages or {}
            local history = lia.chat.persistedMessages
            history[#history + 1] = {
                arguments = args,
                shadowed = true
            }

            local maxEntries = 200
            if #history > maxEntries then
                local overflow = #history - maxEntries
                for i = 1, overflow do
                    table.remove(history, 1)
                end
            end
        end
        return true
    end
    return false
end

local function flushPendingShadowed()
    if #pendingShadowed == 0 then return end
    local delivered = {}
    for i = 1, #pendingShadowed do
        if deliverShadowed(pendingShadowed[i]) then delivered[#delivered + 1] = i end
    end

    if #delivered > 0 then
        for idx = #delivered, 1, -1 do
            table.remove(pendingShadowed, delivered[idx])
        end
    end
end

hook.Add("ChatboxPanelCreated", "Lilia.FlushShadowedMessages", flushPendingShadowed)
net.Receive("liaServerChatAddTextShadowed", function()
    local args = net.ReadTable()
    if not deliverShadowed(args) then
        pendingShadowed[#pendingShadowed + 1] = args
        if not timer.Exists("liaFlushShadowedMessages") then timer.Create("liaFlushShadowedMessages", 0.1, 20, flushPendingShadowed) end
    end

    if not IsColor(args[1]) or not isstring(args[2]) or not IsColor(args[3]) then chat.AddText(unpack(args)) end
end)

net.Receive("liaBlindTarget", function()
    local enabled = net.ReadBool()
    if enabled then
        hook.Add("HUDPaint", "blindTarget", function() draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255)) end)
    else
        hook.Remove("HUDPaint", "blindTarget")
    end
end)

net.Receive("liaInventoryData", function()
    local id = net.ReadType()
    local key = net.ReadString()
    local value = net.ReadType()
    local instance = lia.inventory.instances[id]
    if not instance then
        lia.error(L("invDataNoInstance", key, id))
        return
    end

    local oldValue = instance.data[key]
    instance.data[key] = value
    instance:onDataChanged(key, oldValue, value)
    hook.Run("InventoryDataChanged", instance, key, oldValue, value)
end)

net.Receive("liaInventoryInit", function()
    local id = net.ReadType()
    local typeID = net.ReadString()
    local invData = net.ReadTable()
    local instance = lia.inventory.new(typeID)
    instance.id = id
    instance.data = invData
    instance.items = {}
    local length = net.ReadUInt(32)
    local compressedData = net.ReadData(length)
    local uncompressedData = util.Decompress(compressedData)
    local itemsTable = util.JSONToTable(uncompressedData)
    local function readItem(index)
        local entry = itemsTable[index]
        return entry.i, entry.u, entry.d, entry.q
    end

    for i = 1, #itemsTable do
        local itemID, itemType, itemData, quantity = readItem(i)
        local item = lia.item.new(itemType, itemID)
        item.data = table.Merge(item.data, itemData)
        item.invID = id
        item.quantity = quantity
        instance.items[itemID] = item
        hook.Run("ItemInitialized", item)
    end

    lia.inventory.instances[id] = instance
    hook.Run("InventoryInitialized", instance)
    for _, character in pairs(lia.char.getAll()) do
        for idx, inventory in pairs(character.vars.inv) do
            if inventory:getID() == id then character.vars.inv[idx] = instance end
        end
    end
end)

net.Receive("liaInventoryAdd", function()
    local itemID = net.ReadUInt(32)
    local invID = net.ReadType()
    local item = lia.item.instances[itemID]
    local inventory = lia.inventory.instances[invID]
    if item and inventory then
        inventory.items[itemID] = item
        hook.Run("InventoryItemAdded", inventory, item)
    end
end)

net.Receive("liaInventoryRemove", function()
    local itemID = net.ReadUInt(32)
    local invID = net.ReadType()
    local item = lia.item.instances[itemID]
    local inventory = lia.inventory.instances[invID]
    if item and inventory and inventory.items[itemID] then
        inventory.items[itemID] = nil
        item.invID = 0
        hook.Run("InventoryItemRemoved", inventory, item)
    end
end)

net.Receive("liaInventoryDelete", function()
    local invID = net.ReadType()
    local instance = lia.inventory.instances[invID]
    if instance then hook.Run("InventoryDeleted", instance) end
    if invID then lia.inventory.instances[invID] = nil end
end)

net.Receive("liaItemInstance", function()
    local itemID = net.ReadUInt(32)
    local itemType = net.ReadString()
    local data = net.ReadTable()
    local item = lia.item.new(itemType, itemID)
    local invID = net.ReadType()
    local quantity = net.ReadUInt(32)
    item.data = table.Merge(item.data or {}, data)
    item.invID = invID
    item.quantity = quantity
    lia.item.instances[itemID] = item
    hook.Run("ItemInitialized", item)
end)

net.Receive("liaCharacterInvList", function()
    local charID = net.ReadUInt(32)
    local length = net.ReadUInt(32)
    local inventories = {}
    for i = 1, length do
        inventories[i] = lia.inventory.instances[net.ReadType()]
    end

    lia.char.getCharacter(charID, nil, function(character) if character then character.vars.inv = inventories end end)
end)

net.Receive("liaItemDelete", function()
    local id = net.ReadUInt(32)
    local instance = lia.item.instances[id]
    if instance and instance.invID then
        local inventory = lia.inventory.instances[instance.invID]
        if not inventory or not inventory.items[id] then return end
        inventory.items[id] = nil
        instance.invID = 0
        hook.Run("InventoryItemRemoved", inventory, instance)
    end

    lia.item.instances[id] = nil
    hook.Run("ItemDeleted", instance)
end)

net.Receive("liaCharSet", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local id = net.ReadType()
    id = id or LocalPlayer():getChar() and LocalPlayer():getChar().id
    lia.char.getCharacter(id, nil, function(character)
        if character then
            local oldValue = character.vars[key]
            character.vars[key] = value
            hook.Run("OnCharVarChanged", character, key, oldValue, value)
        end
    end)
end)

net.Receive("liaCharVar", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local id = net.ReadType()
    id = id or LocalPlayer():getChar() and LocalPlayer():getChar().id
    lia.char.getCharacter(id, nil, function(character)
        if character then
            local oldVar = character:getVar()[key]
            character:getVar()[key] = value
            hook.Run("OnCharNetVarChanged", character, key, oldVar, value)
        end
    end)
end)

net.Receive("liaInvData", function()
    local id = net.ReadUInt(32)
    local key = net.ReadString()
    local value = net.ReadType()
    local item = lia.item.instances[id]
    if item then
        item.data = item.data or {}
        local oldValue = item.data[key]
        item.data[key] = value
        hook.Run("ItemDataChanged", item, key, oldValue, value)
    end
end)

net.Receive("liaInvQuantity", function()
    local id = net.ReadUInt(32)
    local quantity = net.ReadUInt(32)
    local item = lia.item.instances[id]
    if item then
        local oldValue = item:getQuantity()
        item.quantity = quantity
        hook.Run("ItemQuantityChanged", item, oldValue, quantity)
    end
end)

net.Receive("liaDataSync", function()
    local bytesRemaining = net.BytesLeft()
    if bytesRemaining > 100 then
        local tableSuccess, data = pcall(net.ReadTable)
        if tableSuccess and istable(data) then
            local firstSuccess, first = pcall(net.ReadType)
            local lastSuccess, last = pcall(net.ReadType)
            lia.localData = data
            if firstSuccess then lia.firstJoin = first end
            if lastSuccess then lia.lastJoin = last end
            return
        end
    end

    local key = net.ReadString()
    local value = net.ReadType()
    lia.localData = lia.localData or {}
    lia.localData[key] = value
end)

net.Receive("liaStorageSync", function() lia.inventory.storage = net.ReadTable() end)
net.Receive("liaAttributeData", function()
    local id = net.ReadUInt(32)
    local key = net.ReadString()
    local value = net.ReadType()
    lia.char.getCharacter(id, nil, function(character) if character then character:getAttribs()[key] = value end end)
end)

net.Receive("liaNetVar", function()
    local index = net.ReadUInt(16)
    local key = net.ReadString()
    local value = net.ReadType()
    lia.net[index] = lia.net[index] or {}
    local oldValue = lia.net[index][key]
    lia.net[index][key] = value
    local entity = Entity(index)
    if IsValid(entity) then hook.Run("NetVarChanged", entity, key, oldValue, value) end
end)

net.Receive("liaNetLocal", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local idx = LocalPlayer():EntIndex()
    lia.net[idx] = lia.net[idx] or {}
    lia.net[idx][key] = value
    hook.Run("OnLocalVarSet", key, value)
end)

net.Receive("liaActBar", function()
    local hasData = net.ReadBool()
    if not hasData then
        if IsValid(lia.gui.actionCircle) then lia.gui.actionCircle:Remove() end
        return
    end

    local text = net.ReadString()
    local time = net.ReadFloat()
    local displayText = text:sub(1, 1) == "@" and L(text:sub(2)) or text
    if IsValid(lia.gui.actionCircle) then lia.gui.actionCircle:Remove() end
    lia.gui = lia.gui or {}
    local pnl = vgui.Create("liaActionCircle")
    pnl:Start(displayText, time)
    lia.gui.actionCircle = pnl
end)

net.Receive("liaOpenInvMenu", function()
    local client = LocalPlayer()
    local permission = IsValid(client) and client:hasPrivilege("checkInventories") or false
    if not permission then return end
    local target = net.ReadEntity()
    local index = net.ReadType()
    local targetInv = lia.inventory.instances[index]
    local myInv = client:getChar():getInv()
    local panels = lia.inventory.showDual(myInv, targetInv)
    if panels and panels[1] and panels[2] then panels[2]:SetTitle(L("inventoryTitle", target:getChar():getName())) end
end)

lia.net.readBigTable("liaSendTableUI", function(data) lia.util.createTableUI(data.title, data.columns, data.data, data.options, data.characterID) end)
local function requestThemeColor(value, fallback)
    if IsColor(value) then return value end
    return fallback
end

local function blendRequestColor(base, tint, fraction, alpha)
    fraction = math.Clamp(fraction or 0, 0, 1)
    return Color(math.Round(Lerp(fraction, base.r, tint.r)), math.Round(Lerp(fraction, base.g, tint.g)), math.Round(Lerp(fraction, base.b, tint.b)), alpha or 255)
end

local function getRequestPalette()
    local theme = lia.color and lia.color.theme or {}
    local accent = requestThemeColor(theme.accent or theme.maincolor or theme.theme, Color(60, 140, 140))
    local textColor = requestThemeColor(theme.text, Color(210, 235, 235))
    local background = requestThemeColor(theme.background, Color(24, 32, 32))
    local popup = requestThemeColor(theme.backgroundPanelPopup or theme.background_panelpopup, Color(20, 28, 28))
    local button = requestThemeColor(theme.button, Color(38, 66, 66))
    local buttonHovered = requestThemeColor(theme.buttonHovered or theme.button_hovered, Color(70, 140, 140))
    return {
        accent = accent,
        text = textColor,
        textSecondary = blendRequestColor(textColor, background, 0.18, 255),
        textMuted = blendRequestColor(textColor, background, 0.46, 255),
        surface = blendRequestColor(popup, accent, 0.08, 248),
        surfaceRaised = blendRequestColor(popup, accent, 0.14, 245),
        inset = blendRequestColor(background, accent, 0.09, 235),
        button = blendRequestColor(button, accent, 0.08, 238),
        buttonHovered = blendRequestColor(buttonHovered, accent, 0.14, 248),
        keycap = blendRequestColor(background, accent, 0.16, 245),
        border = Color(accent.r, accent.g, accent.b, 68),
        borderStrong = Color(accent.r, accent.g, accent.b, 126),
        separator = Color(accent.r, accent.g, accent.b, 32)
    }
end

local function drawRequestPanel(x, y, w, h, radius, color, outline)
    if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
        lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
        return
    end

    draw.RoundedBox(radius, x, y, w, h, color)
    if outline then
        surface.SetDrawColor(outline)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end
end

local function drawRequestOutline(x, y, w, h, radius, color)
    if lia.derma and lia.derma.rect and lia.derma.SHAPE_IOS then
        lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw()
        return
    end

    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(x, y, w, h, 1)
end

local function fitRequestText(text, font, maxWidth)
    text = tostring(text or "")
    surface.SetFont(font)
    if surface.GetTextSize(text) <= maxWidth then return text end
    local suffix = "..."
    local suffixWidth = surface.GetTextSize(suffix)
    local length = #text
    while length > 0 do
        local candidate = text:sub(1, length)
        if surface.GetTextSize(candidate) + suffixWidth <= maxWidth then return candidate .. suffix end
        length = length - 1
    end
    return suffix
end

local function resolveClientRequestText(value, fallback)
    if value == nil then return fallback end
    if istable(value) then
        local token = value[1]
        if isstring(token) and token:sub(1, 1) == "@" then return lia.lang.resolveToken(token, unpack(value, 2)) end
        if token ~= nil then return tostring(token) end
        return fallback
    end

    if isstring(value) and value:sub(1, 1) == "@" then return L(value:sub(2)) end
    return tostring(value)
end

local function resolveClientRequestOption(value)
    if not istable(value) then return resolveClientRequestText(value, value) end
    local result = table.Copy(value)
    if result.text ~= nil then result.text = resolveClientRequestText(result.text, result.text) end
    if result[1] ~= nil then result[1] = resolveClientRequestText(result[1], result[1]) end
    return result
end

local function StyleRequestFrame(frame, kind, title, description)
    if not IsValid(frame) then return frame end
    frame._liaRequestKind = string.upper(tostring(kind or "REQUEST"))
    frame._liaRequestTitle = resolveClientRequestText(title, frame.GetTitle and frame:GetTitle() or "Request")
    frame._liaRequestDescription = resolveClientRequestText(description, "")
    frame._liaRequestHeaderHeight = frame._liaRequestDescription ~= "" and 82 or 66
    if frame.SetTitle then frame:SetTitle("") end
    if frame.SetCenterTitle then frame:SetCenterTitle("") end
    if frame.SetDraggable then frame:SetDraggable(true) end
    frame:DockPadding(18, frame._liaRequestHeaderHeight, 18, 18)
    frame:SetDrawOnTop(true)
    frame:SetZPos(30000)
    frame.Paint = function(s, w, h)
        local palette = getRequestPalette()
        draw.RoundedBox(10, 5, 6, math.max(w - 10, 0), math.max(h - 3, 0), Color(0, 0, 0, 115))
        drawRequestPanel(0, 0, w, h, 9, palette.surface, palette.borderStrong)
        draw.RoundedBoxEx(8, 0, 0, 4, h, palette.accent, true, false, true, false)
        draw.SimpleText(s._liaRequestKind, "LiliaFont.15", 18, 12, palette.accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(fitRequestText(s._liaRequestTitle, "LiliaFont.20", math.max(w - 86, 60)), "LiliaFont.20", 18, 30, palette.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        if s._liaRequestDescription ~= "" then draw.SimpleText(fitRequestText(s._liaRequestDescription, "LiliaFont.15", math.max(w - 86, 60)), "LiliaFont.15", 18, 54, palette.textMuted, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end
        surface.SetDrawColor(palette.separator)
        surface.DrawRect(18, s._liaRequestHeaderHeight - 8, math.max(w - 36, 0), 1)
    end

    if IsValid(frame.cls) then
        frame.cls.Paint = function(s, w, h)
            local palette = getRequestPalette()
            if s:IsHovered() then drawRequestPanel(0, 0, w, h, 5, Color(palette.accent.r, palette.accent.g, palette.accent.b, 24), Color(palette.accent.r, palette.accent.g, palette.accent.b, 70)) end
            draw.SimpleText("X", "LiliaFont.18", w * 0.5, h * 0.5, s:IsHovered() and palette.accent or palette.textMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    return frame
end

local function CreateRequestButton(parent, text, mode, icon)
    local button = parent:Add("DButton")
    button:SetText("")
    button:SetCursor("hand")
    button._liaRequestText = tostring(text or "")
    button._liaRequestMode = mode or "secondary"
    button._liaRequestHover = 0
    button._liaRequestIcon = isstring(icon) and icon ~= "" and Material(icon, "smooth") or type(icon) == "IMaterial" and icon or nil
    button.Paint = function(s, w, h)
        local palette = getRequestPalette()
        s._liaRequestHover = Lerp(math.Clamp(FrameTime() * 14, 0, 1), s._liaRequestHover, s:IsHovered() and 1 or 0)
        local primary = s._liaRequestMode == "primary"
        local base = primary and blendRequestColor(palette.button, palette.accent, 0.16, 248) or palette.button
        local hovered = primary and blendRequestColor(palette.buttonHovered, palette.accent, 0.18, 252) or palette.buttonHovered
        local background = Color(math.Round(Lerp(s._liaRequestHover, base.r, hovered.r)), math.Round(Lerp(s._liaRequestHover, base.g, hovered.g)), math.Round(Lerp(s._liaRequestHover, base.b, hovered.b)), math.Round(Lerp(s._liaRequestHover, base.a or 245, hovered.a or 250)))
        local outlineAlpha = math.Round(Lerp(s._liaRequestHover, primary and 88 or 42, primary and 165 or 125))
        drawRequestPanel(0, 0, w, h, 6, background, Color(palette.accent.r, palette.accent.g, palette.accent.b, outlineAlpha))
        if primary or s._liaRequestHover > 0.01 then
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(primary and Lerp(s._liaRequestHover, 110, 225) or 200 * s._liaRequestHover))
            surface.DrawRect(6, h - 2, math.max(w - 12, 0), 2)
        end

        local textX = w * 0.5
        local align = TEXT_ALIGN_CENTER
        if s._liaRequestIcon and not s._liaRequestIcon:IsError() then
            surface.SetMaterial(s._liaRequestIcon)
            surface.SetDrawColor(palette.textSecondary)
            surface.DrawTexturedRect(13, math.floor((h - 16) * 0.5), 16, 16)
            textX = 38
            align = TEXT_ALIGN_LEFT
        end

        draw.SimpleText(s._liaRequestText, "LiliaFont.17", textX, h * 0.5, palette.textSecondary, align, TEXT_ALIGN_CENTER)
    end
    return button
end

local function CreateRequestCard(parent, height)
    local card = parent:Add("DPanel")
    card:Dock(TOP)
    card:SetTall(height or 62)
    card:DockMargin(0, 0, 0, 8)
    card.Paint = function(_, w, h)
        local palette = getRequestPalette()
        drawRequestPanel(0, 0, w, h, 7, palette.inset, Color(palette.accent.r, palette.accent.g, palette.accent.b, 34))
    end
    return card
end

local function CreateRequestFooter(frame, cancelText, submitText, onCancel, onSubmit)
    local footer = frame:Add("DPanel")
    footer:Dock(BOTTOM)
    footer:SetTall(54)
    footer:DockMargin(0, 10, 0, 0)
    footer.Paint = function(_, w)
        local palette = getRequestPalette()
        surface.SetDrawColor(palette.separator)
        surface.DrawRect(0, 0, w, 1)
    end

    local cancel
    if cancelText then
        cancel = CreateRequestButton(footer, cancelText, "secondary")
        cancel:SetSize(126, 40)
        cancel.DoClick = onCancel
    end

    local submit
    if submitText then
        submit = CreateRequestButton(footer, submitText, "primary")
        submit:SetSize(126, 40)
        submit.DoClick = onSubmit
    end

    footer.PerformLayout = function(_, w)
        if IsValid(cancel) then cancel:SetPos(0, 10) end
        if IsValid(submit) then submit:SetPos(w - submit:GetWide(), 10) end
    end
    return footer, submit, cancel
end

local function CreateRequestScroll(frame)
    local scroll = frame:Add("liaScrollPanel")
    scroll:Dock(FILL)
    scroll:DockMargin(0, 6, 0, 0)
    scroll.Paint = function() end
    return scroll
end

local function AddComboChoices(combo, options, defaultValue)
    local defaultChoice
    for index, option in ipairs(options or {}) do
        local display = resolveClientRequestOption(option)
        if istable(display) then
            combo:AddChoice(tostring(display[1]), display[2])
            if defaultValue ~= nil and (display[2] == defaultValue or display[1] == defaultValue) then defaultChoice = index end
        else
            combo:AddChoice(tostring(display))
            if defaultValue ~= nil and tostring(display) == tostring(defaultValue) then defaultChoice = index end
        end
    end

    if combo.FinishAddingOptions then combo:FinishAddingOptions() end
    if combo.PostInit then combo:PostInit() end
    if defaultChoice and combo.ChooseOptionID then
        combo:ChooseOptionID(defaultChoice)
    elseif #options > 0 and combo.ChooseOptionID then
        combo:ChooseOptionID(1)
    end
end

lia.derma.requestOptions = function(title, subTitle, options, callback, onCancel)
    if IsValid(lia.gui.menuRequestOptions) then lia.gui.menuRequestOptions:Remove() end
    options = istable(options) and options or {}
    local count = #options
    local width = 620
    local height = math.Clamp(154 + count * 70, 270, math.floor(ScrH() * 0.68))
    local frame = vgui.Create("liaFrame")
    frame:SetSize(width, height)
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "OPTION REQUEST", resolveClientRequestText(title, L("options")), resolveClientRequestText(subTitle, ""))
    local finished = false
    local controls = {}
    local function cancelRequest()
        if finished then return end
        finished = true
        if onCancel then onCancel() end
        if IsValid(frame) then frame:Remove() end
    end

    local function submitRequest()
        if finished then return end
        finished = true
        local selected = {}
        for _, info in ipairs(controls) do
            if info.kind == "checkbox" then
                if info.control:GetChecked() then selected[#selected + 1] = info.data end
            else
                local selectedText, selectedData = info.control:GetSelected()
                selected[info.name] = selectedData ~= nil and selectedData or selectedText
            end
        end

        if callback then callback(selected) end
        if IsValid(frame) then frame:Remove() end
    end

    CreateRequestFooter(frame, L("cancel"), L("submit"), cancelRequest, submitRequest)
    local scroll = CreateRequestScroll(frame)
    for _, option in ipairs(options) do
        local optionName
        local optionData
        if istable(option) then
            optionName = option[1] or tostring(option[2] or "")
            optionData = option[2]
        else
            optionName = tostring(option)
            optionData = option
        end

        optionName = resolveClientRequestText(optionName, optionName)
        local card = CreateRequestCard(scroll, istable(optionData) and 70 or 60)
        local label = card:Add("DLabel")
        label:SetFont("LiliaFont.17")
        label:SetText(optionName)
        label:SetTextColor(getRequestPalette().textSecondary)
        label:SetContentAlignment(4)
        label:SetMouseInputEnabled(false)
        local control
        local kind
        if istable(optionData) then
            kind = "combo"
            control = card:Add("liaComboBox")
            control:SetTall(36)
            AddComboChoices(control, optionData)
        else
            kind = "checkbox"
            control = card:Add("liaCheckbox")
            control:SetChecked(false)
        end

        card.PerformLayout = function(_, w, h)
            local rightWidth = kind == "checkbox" and 60 or math.min(250, math.floor(w * 0.43))
            label:SetPos(14, 0)
            label:SetSize(math.max(w - rightWidth - 42, 80), h)
            if kind == "checkbox" then
                control:SetSize(60, 22)
                control:SetPos(w - 74, math.floor((h - 22) * 0.5))
            else
                control:SetSize(rightWidth, 36)
                control:SetPos(w - rightWidth - 12, math.floor((h - 36) * 0.5))
            end
        end

        controls[#controls + 1] = {
            name = optionName,
            data = optionData,
            control = control,
            kind = kind
        }
    end

    frame.OnRemove = function()
        if finished then return end
        finished = true
        if onCancel then onCancel() end
    end

    lia.gui.menuRequestOptions = frame
    return frame
end

lia.derma.requestDropdown = function(title, options, callback, defaultValue)
    if IsValid(lia.gui.menuRequestDropdown) then lia.gui.menuRequestDropdown:Remove() end
    options = istable(options) and options or {}
    local frame = vgui.Create("liaFrame")
    frame:SetSize(500, 280)
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "SELECTION REQUEST", resolveClientRequestText(title, L("selectOption")), "Choose one option from the list.")
    local finished = false
    local selectedText
    local selectedData
    local function cancelRequest()
        if finished then return end
        finished = true
        if callback then callback(false) end
        if IsValid(frame) then frame:Remove() end
    end

    local function submitRequest()
        if finished then return end
        local text = selectedText
        local data = selectedData
        if not text then
            local first = resolveClientRequestOption(options[1])
            if istable(first) then
                text, data = tostring(first[1]), first[2]
            elseif first ~= nil then
                text = tostring(first)
            end
        end

        if not text then return end
        finished = true
        if callback then
            if data ~= nil then
                callback(text, data)
            else
                callback(text)
            end
        end

        if IsValid(frame) then frame:Remove() end
    end

    CreateRequestFooter(frame, L("cancel"), L("select"), cancelRequest, submitRequest)
    local body = frame:Add("DPanel")
    body:Dock(FILL)
    body:DockMargin(0, 12, 0, 0)
    body.Paint = function() end
    local card = CreateRequestCard(body, 92)
    card:Dock(TOP)
    local label = card:Add("DLabel")
    label:SetFont("LiliaFont.15")
    label:SetText(L("select") or "Selection")
    label:SetTextColor(getRequestPalette().textMuted)
    local dropdown = card:Add("liaComboBox")
    AddComboChoices(dropdown, options, istable(defaultValue) and defaultValue[2] or defaultValue)
    local first = resolveClientRequestOption(options[1])
    if istable(first) then
        selectedText, selectedData = tostring(first[1]), first[2]
    elseif first ~= nil then
        selectedText = tostring(first)
    end

    if defaultValue ~= nil then
        if istable(defaultValue) then
            selectedText, selectedData = tostring(defaultValue[1]), defaultValue[2]
        else
            selectedText = tostring(defaultValue)
        end
    end

    dropdown.OnSelect = function(_, _, value, data)
        selectedText = value
        selectedData = data
    end

    card.PerformLayout = function(_, w)
        label:SetPos(14, 12)
        label:SetSize(w - 28, 18)
        dropdown:SetPos(14, 38)
        dropdown:SetSize(w - 28, 40)
    end

    frame.OnRemove = function()
        if finished then return end
        finished = true
        if callback then callback(false) end
    end

    lia.gui.menuRequestDropdown = frame
    return frame
end

lia.derma.requestString = function(title, description, callback, defaultValue, maxLength)
    if IsValid(lia.gui.menuRequestString) then lia.gui.menuRequestString:Remove() end
    local vendorPanel = lia.gui.vendor
    local vendorEditor = lia.gui.vendorEditor
    if IsValid(vendorPanel) then vendorPanel:SetVisible(false) end
    if IsValid(vendorEditor) then vendorEditor:SetVisible(false) end
    local frame = vgui.Create("liaFrame")
    frame:SetSize(560, 250)
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "INPUT REQUEST", resolveClientRequestText(title, L("enterText")), resolveClientRequestText(description, L("enterValue")))
    local finished = false
    local entry
    local function restoreVendor()
        if IsValid(vendorPanel) then vendorPanel:SetVisible(true) end
        if IsValid(vendorEditor) then vendorEditor:SetVisible(true) end
    end

    local function cancelRequest()
        if finished then return end
        finished = true
        if callback then callback(false) end
        if IsValid(frame) then frame:Remove() end
    end

    local function submitRequest()
        if finished or not IsValid(entry) then return end
        finished = true
        if callback then callback(entry:GetValue()) end
        if IsValid(frame) then frame:Remove() end
    end

    CreateRequestFooter(frame, L("cancel"), L("submit"), cancelRequest, submitRequest)
    local body = frame:Add("DPanel")
    body:Dock(FILL)
    body:DockMargin(0, 8, 0, 0)
    body.Paint = function() end
    local card = CreateRequestCard(body, 72)
    local label = card:Add("DLabel")
    label:SetFont("LiliaFont.15")
    label:SetText(L("value") or "Value")
    label:SetTextColor(getRequestPalette().textMuted)
    entry = card:Add("liaEntry")
    entry:SetFont("LiliaFont.17")
    if defaultValue ~= nil then entry:SetValue(tostring(defaultValue)) end
    if maxLength then entry:SetMaxLength(maxLength) end
    entry.OnEnter = submitRequest
    card.PerformLayout = function(_, w)
        label:SetPos(14, 8)
        label:SetSize(w - 28, 18)
        entry:SetPos(14, 29)
        entry:SetSize(w - 28, 36)
    end

    frame.OnRemove = function()
        restoreVendor()
        if finished then return end
        finished = true
        if callback then callback(false) end
    end

    lia.gui.menuRequestString = frame
    return frame
end

lia.derma.requestArguments = function(title, argTypes, onSubmit, defaults)
    defaults = defaults or {}
    argTypes = istable(argTypes) and argTypes or {}
    local count = table.Count(argTypes)
    local frame = vgui.Create("liaFrame")
    frame:SetSize(640, math.Clamp(168 + count * 72, 300, math.floor(ScrH() * 0.72)))
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "ARGUMENT REQUEST", resolveClientRequestText(title, L("enterArguments")), "Complete the required fields below.")
    local finished = false
    local controls = {}
    local ordered = {}
    if #argTypes > 0 and istable(argTypes[1]) then
        for _, info in ipairs(argTypes) do
            ordered[#ordered + 1] = {
                name = info[1],
                typeInfo = info[2]
            }
        end
    else
        for name, typeInfo in pairs(argTypes) do
            ordered[#ordered + 1] = {
                name = name,
                typeInfo = typeInfo
            }
        end

        table.sort(ordered, function(a, b) return tostring(a.name) < tostring(b.name) end)
    end

    local submitButton
    local function validate()
        if not IsValid(submitButton) then return end
        local valid = true
        for _, info in ipairs(controls) do
            if info.kind == "boolean" then continue end
            if info.kind == "combo" then
                local text = select(1, info.control:GetSelected())
                if not text or text == "" or text == L("select") or text == L("choose") then
                    valid = false
                    break
                end
            else
                local value = info.control:GetValue()
                if value == nil or value == "" then
                    valid = false
                    break
                end

                if info.kind == "number" and tonumber(value) == nil then
                    valid = false
                    break
                end
            end
        end

        submitButton:SetEnabled(valid)
        submitButton:SetMouseInputEnabled(valid)
        submitButton:SetAlpha(valid and 255 or 110)
    end

    local function cancelRequest()
        if finished then return end
        finished = true
        if isfunction(onSubmit) then onSubmit(false) end
        if IsValid(frame) then frame:Remove() end
    end

    local function submitRequest()
        if finished then return end
        local result = {}
        for _, info in ipairs(controls) do
            if info.kind == "boolean" then
                result[info.name] = info.control:GetChecked()
            elseif info.kind == "combo" then
                local text, data = info.control:GetSelected()
                result[info.name] = data ~= nil and data or text
            else
                local value = info.control:GetValue()
                result[info.name] = info.kind == "number" and tonumber(value) or value
            end
        end

        finished = true
        if isfunction(onSubmit) then onSubmit(true, result) end
        if IsValid(frame) then frame:Remove() end
    end

    local _, submit = CreateRequestFooter(frame, L("cancel"), L("submit"), cancelRequest, submitRequest)
    submitButton = submit
    local scroll = CreateRequestScroll(frame)
    for _, item in ipairs(ordered) do
        local name = tostring(item.name or "")
        if name == "" then continue end
        local typeInfo = item.typeInfo
        local fieldType = typeInfo
        local dataTable
        local defaultValue
        if istable(typeInfo) then
            fieldType = typeInfo[1]
            dataTable = typeInfo[2]
            defaultValue = typeInfo[3]
        end

        fieldType = string.lower(tostring(fieldType or "string"))
        if defaultValue == nil and defaults[name] ~= nil then defaultValue = defaults[name] end
        local card = CreateRequestCard(scroll, 66)
        local label = card:Add("DLabel")
        label:SetFont("LiliaFont.17")
        label:SetText(name)
        label:SetTextColor(getRequestPalette().textSecondary)
        label:SetContentAlignment(4)
        local control
        local kind
        if fieldType == "boolean" then
            kind = "boolean"
            control = card:Add("liaCheckbox")
            control:SetChecked(defaultValue ~= nil and tobool(defaultValue) or false)
        elseif fieldType == "table" then
            kind = "combo"
            control = card:Add("liaComboBox")
            AddComboChoices(control, dataTable or {}, defaultValue)
        elseif fieldType == "player" then
            kind = "combo"
            control = card:Add("liaComboBox")
            local playerOptions = {}
            for _, client in player.Iterator() do
                if IsValid(client) then playerOptions[#playerOptions + 1] = {client:Name(), client:SteamID()} end
            end

            AddComboChoices(control, playerOptions, defaultValue)
        else
            if fieldType == "int" or fieldType == "number" then
                kind = "number"
            else
                kind = "string"
            end

            control = card:Add("liaEntry")
            control:SetFont("LiliaFont.17")
            if kind == "number" and control.SetNumeric then control:SetNumeric(true) end
            if defaultValue ~= nil then control:SetValue(tostring(defaultValue)) end
        end

        card.PerformLayout = function(_, w, h)
            local controlWidth = kind == "boolean" and 60 or math.min(290, math.floor(w * 0.48))
            label:SetPos(14, 0)
            label:SetSize(math.max(w - controlWidth - 42, 80), h)
            if kind == "boolean" then
                control:SetSize(60, 22)
                control:SetPos(w - 74, math.floor((h - 22) * 0.5))
            else
                control:SetSize(controlWidth, 36)
                control:SetPos(w - controlWidth - 12, math.floor((h - 36) * 0.5))
            end
        end

        local info = {
            name = name,
            kind = kind,
            control = control
        }

        controls[#controls + 1] = info
        local oldChange = control.OnValueChange
        control.OnValueChange = function(...)
            if oldChange then oldChange(...) end
            validate()
        end

        local oldText = control.OnTextChanged
        control.OnTextChanged = function(...)
            if oldText then oldText(...) end
            validate()
        end

        local oldSelect = control.OnSelect
        control.OnSelect = function(...)
            if oldSelect then oldSelect(...) end
            validate()
        end

        local oldChangeGeneric = control.OnChange
        control.OnChange = function(...)
            if oldChangeGeneric then oldChangeGeneric(...) end
            validate()
        end
    end

    validate()
    frame.OnRemove = function()
        if finished then return end
        finished = true
        if isfunction(onSubmit) then onSubmit(false) end
    end
    return frame
end

lia.derma.requestBinaryQuestion = function(title, question, callback, yesText, noText)
    if IsValid(lia.gui.menuRequestBinary) then lia.gui.menuRequestBinary:Remove() end
    local frame = vgui.Create("liaFrame")
    frame:SetSize(500, 190)
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "CONFIRMATION", resolveClientRequestText(title, L("question")), resolveClientRequestText(question, L("areYouSure")))
    local finished = false
    local function finish(value)
        if finished then return end
        finished = true
        if callback then callback(value) end
        if IsValid(frame) then frame:Remove() end
    end

    CreateRequestFooter(frame, resolveClientRequestText(noText, L("no")), resolveClientRequestText(yesText, L("yes")), function() finish(false) end, function() finish(true) end)
    frame.OnRemove = function()
        if finished then return end
        finished = true
        if callback then callback(false) end
    end

    lia.gui.menuRequestBinary = frame
    return frame
end

lia.derma.requestButtons = function(title, buttons, callback, description)
    if IsValid(lia.gui.menuRequestButtons) then lia.gui.menuRequestButtons:Remove() end
    buttons = istable(buttons) and buttons or {}
    local frame = vgui.Create("liaFrame")
    frame:SetSize(520, math.Clamp(158 + #buttons * 52, 260, math.floor(ScrH() * 0.68)))
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "ACTION REQUEST", resolveClientRequestText(title, L("selectOption")), resolveClientRequestText(description, "Choose an action."))
    local finished = false
    local buttonPanels = {}
    local function closeRequest()
        if finished then return end
        finished = true
        if callback then callback(false) end
        if IsValid(frame) then frame:Remove() end
    end

    CreateRequestFooter(frame, L("close"), nil, closeRequest, nil)
    local scroll = CreateRequestScroll(frame)
    for index, buttonInfo in ipairs(buttons) do
        local textValue
        local clickCallback
        local icon
        if istable(buttonInfo) then
            textValue = buttonInfo.text or buttonInfo[1] or tostring(buttonInfo)
            clickCallback = buttonInfo.callback or buttonInfo[2]
            icon = buttonInfo.icon or buttonInfo[3]
        else
            textValue = tostring(buttonInfo)
        end

        local buttonText = resolveClientRequestText(textValue, textValue)
        local button = CreateRequestButton(scroll, buttonText, "secondary", icon)
        button:Dock(TOP)
        button:SetTall(44)
        button:DockMargin(0, 0, 0, 8)
        button.DoClick = function()
            if finished then return end
            local shouldClose = true
            if isfunction(clickCallback) then
                shouldClose = clickCallback() ~= false
            elseif callback then
                shouldClose = callback(index, buttonText) ~= false
            end

            if shouldClose then
                finished = true
                if IsValid(frame) then frame:Remove() end
            end
        end

        buttonPanels[index] = button
    end

    frame.OnRemove = function()
        if finished then return end
        finished = true
        if callback then callback(false) end
    end

    lia.gui.menuRequestButtons = frame
    return frame, buttonPanels
end

lia.derma.requestPopupQuestion = function(question, buttons)
    if IsValid(lia.gui.menuRequestPopup) then lia.gui.menuRequestPopup:Remove() end
    buttons = istable(buttons) and buttons or {}
    local frame = vgui.Create("liaFrame")
    frame:SetSize(500, math.Clamp(120 + #buttons * 52, 210, math.floor(ScrH() * 0.62)))
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "QUESTION", resolveClientRequestText(question, L("areYouSure")), "Select one of the available responses.")
    local scroll = CreateRequestScroll(frame)
    for _, buttonInfo in ipairs(buttons) do
        local textValue
        local clickCallback
        if istable(buttonInfo) then
            textValue = buttonInfo[1] or buttonInfo.text or tostring(buttonInfo)
            clickCallback = buttonInfo[2] or buttonInfo.callback
        else
            textValue = tostring(buttonInfo)
        end

        local buttonText = resolveClientRequestText(textValue, textValue)
        local button = CreateRequestButton(scroll, buttonText, "secondary")
        button:Dock(TOP)
        button:SetTall(44)
        button:DockMargin(0, 0, 0, 8)
        button.DoClick = function()
            if isfunction(clickCallback) then clickCallback() end
            if IsValid(frame) then frame:Remove() end
        end
    end

    lia.gui.menuRequestPopup = frame
    return frame
end

net.Receive("liaOptionsRequest", function()
    local id = net.ReadUInt(32)
    local title = net.ReadString()
    local subTitle = net.ReadString()
    local options = net.ReadTable()
    local limit = net.ReadUInt(32)
    lia.derma.requestOptions(title, subTitle, options, function(selectedOptions)
        if limit > 0 and #selectedOptions > limit then
            local limited = {}
            for i = 1, limit do
                if selectedOptions[i] then table.insert(limited, selectedOptions[i]) end
            end

            selectedOptions = limited
        end

        net.Start("liaOptionsRequest")
        net.WriteUInt(id, 32)
        net.WriteTable(selectedOptions)
        net.SendToServer()
    end, function()
        net.Start("liaOptionsRequestCancel")
        net.WriteUInt(id, 32)
        net.SendToServer()
    end)
end)

net.Receive("liaProvideInteractOptions", function()
    local kind = net.ReadString()
    local count = net.ReadUInt(16)
    local temp = {}
    for _ = 1, count do
        local name = net.ReadString()
        local typ = net.ReadString()
        local serverOnly = net.ReadBool()
        local range = net.ReadUInt(16)
        local category = net.ReadString()
        local hasTarget = net.ReadBool()
        local target = hasTarget and net.ReadString() or nil
        local hasTime = net.ReadBool()
        local timeToComplete = hasTime and net.ReadFloat() or nil
        local hasActionText = net.ReadBool()
        local actionText = hasActionText and net.ReadString() or nil
        local hasTargetActionText = net.ReadBool()
        local targetActionText = hasTargetActionText and net.ReadString() or nil
        temp[name] = {
            type = typ,
            serverOnly = serverOnly,
            range = range,
            category = category,
            target = target,
            timeToComplete = timeToComplete,
            actionText = actionText,
            targetActionText = targetActionText
        }
    end

    local optionsMap = {}
    local optionCount = 0
    for name, opt in pairs(temp) do
        optionsMap[name] = opt
        optionCount = optionCount + 1
    end

    local isInteraction = kind == "interaction"
    if optionCount == 0 then return end
    lia.playerinteract.openMenu(optionsMap, isInteraction, isInteraction and L("playerInteractions") or L("actionsMenu"), isInteraction and lia.keybind.get(L("interactionMenu"), KEY_TAB) or lia.keybind.get(L("personalActions"), KEY_G), "liaRunInteraction", true)
end)

net.Receive("liaRequestDropdown", function()
    local id = net.ReadUInt(32)
    local title = net.ReadString()
    net.ReadString()
    local options = net.ReadTable()
    lia.derma.requestDropdown(title, options, function(selectedText, selectedData)
        if selectedText == false then
            net.Start("liaRequestDropdownCancel")
            net.WriteUInt(id, 32)
            net.SendToServer()
        else
            net.Start("liaRequestDropdown")
            net.WriteUInt(id, 32)
            net.WriteString(selectedText)
            if selectedData ~= nil then
                net.WriteString(tostring(selectedData))
            else
                net.WriteString("")
            end

            net.SendToServer()
        end
    end)
end)

net.Receive("liaArgumentsRequest", function()
    local id = net.ReadUInt(32)
    local title = net.ReadString()
    local fields = net.ReadTable()
    lia.derma.requestArguments(title, fields, function(success, data)
        if success then
            net.Start("liaArgumentsRequest")
            net.WriteUInt(id, 32)
            net.WriteTable(data)
            net.SendToServer()
        else
            net.Start("liaArgumentsRequestCancel")
            net.WriteUInt(id, 32)
            net.SendToServer()
        end
    end)
end)

net.Receive("liaStringRequest", function()
    local id = net.ReadUInt(32)
    local title = net.ReadString()
    local subTitle = net.ReadString()
    local default = net.ReadString()
    lia.derma.requestString(title, subTitle, function(value)
        if value == false then
            net.Start("liaStringRequestCancel")
            net.WriteUInt(id, 32)
            net.SendToServer()
        else
            net.Start("liaStringRequest")
            net.WriteUInt(id, 32)
            net.WriteString(value)
            net.SendToServer()
        end
    end, default)
end)

local cachedScrW = ScrW()
local lastScrWCheck = 0
local function OrganizeNotices()
    local now = CurTime()
    if now - lastScrWCheck > 1 then
        lastScrWCheck = now
        cachedScrW = ScrW()
    end

    local baseY = 10
    local list = {}
    for _, n in ipairs(lia.notices) do
        if IsValid(n) then list[#list + 1] = n end
    end

    while #list > 6 do
        local old = table.remove(list, 1)
        if IsValid(old) then old:Remove() end
    end

    local leftCount = #list > 3 and #list - 3 or 0
    for i, n in ipairs(list) do
        if IsValid(n) then
            local h = n:GetTall()
            local x, y
            if i <= leftCount then
                x = 10
                y = baseY + (i - 1) * (h + 5)
            else
                local idx = i - leftCount
                x = cachedScrW - n:GetWide() - 10
                y = baseY + (idx - 1) * (h + 5)
            end

            local currentX, currentY = n:GetPos()
            if math.abs(currentX - x) > 2 or math.abs(currentY - y) > 2 then
                n:MoveTo(x, y, 0.15)
            else
                n.targetY = y
            end
        end
    end
end

local function RemoveNotices(notice)
    if not IsValid(notice) then return end
    for i, v in ipairs(lia.notices) do
        if v == notice then
            notice:SizeTo(notice:GetWide(), 0, 0.2, 0, -1, function() if IsValid(notice) then notice:Remove() end end)
            table.remove(lia.notices, i)
            timer.Simple(0.25, OrganizeNotices)
            break
        end
    end
end

local function CreateRequestNotice(length, notimer)
    local notice = vgui.Create("DPanel")
    notice:SetSize(0, 0)
    notice.start = CurTime() + 0.25
    notice.endTime = CurTime() + length
    notice.notimer = notimer or false
    notice.oh = notice:GetTall()
    function notice:Paint(w, h)
        local palette = getRequestPalette()
        draw.RoundedBox(9, 4, 5, math.max(w - 8, 0), math.max(h - 3, 0), Color(0, 0, 0, 110))
        drawRequestPanel(0, 0, w, h, 8, palette.surface, palette.borderStrong)
        draw.RoundedBoxEx(8, 0, 0, 4, h, palette.accent, true, false, true, false)
        if self.start then
            local fraction = math.Clamp(math.TimeFraction(self.start, self.endTime, CurTime()), 0, 1)
            local remaining = 1 - fraction
            local barX = 12
            local barY = h - 4
            local barWidth = math.max(w - 24, 0)
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, 28)
            surface.DrawRect(barX, barY, barWidth, 2)
            surface.SetDrawColor(palette.accent)
            surface.DrawRect(barX, barY, math.floor(barWidth * remaining), 2)
        end
    end

    if not notice.notimer then timer.Simple(length, function() if IsValid(notice) then RemoveNotices(notice) end end) end
    return notice
end

local function CreateRequestNoticeButton(parent, label, key)
    local button = parent:Add("DButton")
    button:SetText("")
    button:SetCursor("hand")
    button.hoverFraction = 0
    button.flashColor = nil
    function button:Paint(w, h)
        local palette = getRequestPalette()
        self.hoverFraction = Lerp(math.Clamp(FrameTime() * 14, 0, 1), self.hoverFraction, self:IsHovered() and 1 or 0)
        local background
        if self.flashColor then
            background = self.flashColor
        else
            background = Color(math.Round(Lerp(self.hoverFraction, palette.button.r, palette.buttonHovered.r)), math.Round(Lerp(self.hoverFraction, palette.button.g, palette.buttonHovered.g)), math.Round(Lerp(self.hoverFraction, palette.button.b, palette.buttonHovered.b)), math.Round(Lerp(self.hoverFraction, palette.button.a, palette.buttonHovered.a)))
        end

        drawRequestPanel(0, 0, w, h, 5, background, Color(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(Lerp(self.hoverFraction, 45, 125))))
        if self.hoverFraction > 0.01 then
            surface.SetDrawColor(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(210 * self.hoverFraction))
            surface.DrawRect(5, h - 2, math.max(w - 10, 0), 2)
        end

        draw.SimpleText(label, "LiliaFont.17", 12, h * 0.5, palette.textSecondary, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        surface.SetFont("LiliaFont.15")
        local keyWidth = math.max(surface.GetTextSize(key) + 14, 30)
        local keyHeight = 22
        local keyX = w - keyWidth - 8
        local keyY = math.floor((h - keyHeight) * 0.5)
        drawRequestPanel(keyX, keyY, keyWidth, keyHeight, 4, palette.keycap, Color(palette.accent.r, palette.accent.g, palette.accent.b, 34))
        draw.SimpleText(key, "LiliaFont.15", keyX + keyWidth * 0.5, h * 0.5, palette.textMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    return button
end

lia.derma.requestBinaryNotice = function(question, option1, option2, manualDismiss, callback)
    question = resolveClientRequestText(question, L("areYouSure"))
    option1 = resolveClientRequestText(option1, L("yes"))
    option2 = resolveClientRequestText(option2, L("no"))
    surface.SetFont("LiliaFont.19")
    local questionWidth = surface.GetTextSize(question)
    local width = math.Clamp(math.max(520, questionWidth + 76), 520, 700)
    local height = 126
    local notice = CreateRequestNotice(10, manualDismiss)
    table.insert(lia.notices, notice)
    notice.isQuery = true
    notice:SetWide(width)
    notice:SetTall(height)
    notice.oh = height
    if manualDismiss then notice.start = nil end
    notice.header = notice:Add("DPanel")
    notice.header:SetPos(18, 14)
    notice.header:SetSize(width - 36, 52)
    notice.header.Paint = function(_, w)
        local palette = getRequestPalette()
        draw.SimpleText("BINARY REQUEST", "LiliaFont.15", 0, 0, palette.accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(fitRequestText(question, "LiliaFont.19", w), "LiliaFont.19", 0, 24, palette.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    notice.actions = notice:Add("DPanel")
    notice.actions:SetPos(12, 71)
    notice.actions:SetSize(width - 24, 44)
    notice.actions.Paint = function(_, w, h)
        local palette = getRequestPalette()
        drawRequestPanel(0, 0, w, h, 7, palette.inset, Color(palette.accent.r, palette.accent.g, palette.accent.b, 26))
    end

    notice.opt1 = CreateRequestNoticeButton(notice.actions, option1, "F7")
    notice.opt2 = CreateRequestNoticeButton(notice.actions, option2, "F8")
    notice.cancelBtn = CreateRequestNoticeButton(notice.actions, L("cancel"), "F9")
    local gap = 6
    local padding = 6
    local availableWidth = notice.actions:GetWide() - padding * 2 - gap * 2
    local buttonWidth = math.floor(availableWidth / 3)
    local buttonHeight = notice.actions:GetTall() - padding * 2
    notice.opt1:SetPos(padding, padding)
    notice.opt1:SetSize(buttonWidth, buttonHeight)
    notice.opt2:SetPos(padding + buttonWidth + gap, padding)
    notice.opt2:SetSize(buttonWidth, buttonHeight)
    local thirdX = padding + (buttonWidth + gap) * 2
    notice.cancelBtn:SetPos(thirdX, padding)
    notice.cancelBtn:SetSize(notice.actions:GetWide() - thirdX - padding, buttonHeight)
    local function finish(button, success, result)
        if not notice.respondToKeys then return end
        notice.respondToKeys = false
        notice.lastKey = CurTime()
        button.flashColor = success and Color(43, 112, 81, 255) or Color(117, 48, 57, 255)
        if callback then callback(result) end
        timer.Simple(0.28, function()
            if not IsValid(notice) then return end
            notice:AlphaTo(0, 0.15, 0, function() if IsValid(notice) then RemoveNotices(notice) end end)
        end)
    end

    local function chooseFirst()
        finish(notice.opt1, true, 0)
    end

    local function chooseSecond()
        finish(notice.opt2, true, 1)
    end

    local function cancel()
        finish(notice.cancelBtn, false, false)
    end

    notice.opt1.DoClick = chooseFirst
    notice.opt2.DoClick = chooseSecond
    notice.cancelBtn.DoClick = cancel
    notice.lastKey = CurTime()
    notice.respondToKeys = true
    notice:SetTall(0)
    notice:SetPos(ScrW() * 0.5 - width * 0.5, 10)
    notice:SizeTo(width, height, 0.2, 0, -1)
    function notice:Think()
        self:SetPos(ScrW() * 0.5 - self:GetWide() * 0.5, 10)
        if not self.respondToKeys or CurTime() - self.lastKey < 0.45 then return end
        if input.IsKeyDown(KEY_F7) then
            chooseFirst()
        elseif input.IsKeyDown(KEY_F8) then
            chooseSecond()
        elseif input.IsKeyDown(KEY_F9) then
            cancel()
        end
    end
    return notice
end

net.Receive("liaBinaryQuestionRequest", function()
    local id = net.ReadUInt(32)
    local questionKey = net.ReadString()
    local option1Key = net.ReadString()
    local option2Key = net.ReadString()
    local manualDismiss = net.ReadBool()
    lia.derma.requestBinaryNotice(L(questionKey), L(option1Key, L("yes")), L(option2Key, L("no")), manualDismiss, function(result)
        if result == false then
            net.Start("liaBinaryQuestionRequestCancel")
            net.WriteUInt(id, 32)
            net.SendToServer()
            return
        end

        net.Start("liaBinaryQuestionRequest")
        net.WriteUInt(id, 32)
        net.WriteUInt(result, 1)
        net.SendToServer()
    end)
end)

net.Receive("liaPopupQuestionRequest", function()
    local id = net.ReadUInt(32)
    local question = net.ReadString()
    local buttonCount = net.ReadUInt(8)
    local buttons = {}
    for i = 1, buttonCount do
        local buttonText = net.ReadString()
        buttons[i] = {
            buttonText,
            function()
                net.Start("liaPopupQuestionRequest")
                net.WriteUInt(id, 32)
                net.WriteUInt(i, 8)
                net.SendToServer()
            end
        }
    end

    lia.derma.requestPopupQuestion(question, buttons)
end)

net.Receive("liaButtonRequest", function()
    local id = net.ReadUInt(32)
    local title = net.ReadString()
    local count = net.ReadUInt(8)
    local options = {}
    for i = 1, count do
        options[i] = net.ReadString()
    end

    local buttons = {}
    for i, buttonText in ipairs(options) do
        table.insert(buttons, {
            text = buttonText,
            callback = function()
                net.Start("liaButtonRequest")
                net.WriteUInt(id, 32)
                net.WriteUInt(i, 8)
                net.SendToServer()
            end
        })
    end

    lia.derma.requestButtons(title, buttons, function(selectedIndex) if selectedIndex and selectedIndex > 0 and selectedIndex <= #buttons then buttons[selectedIndex].callback() end end)
end)

net.Receive("liaAnimationStatus", function()
    local ply = net.ReadEntity()
    local active = net.ReadBool()
    local boneData = net.ReadTable()
    if IsValid(ply) then ply:networkAnimation(active, boneData) end
end)

net.Receive("liaCmdArgPrompt", function()
    local cmd = net.ReadString()
    local fields = net.ReadTable()
    local prefix = net.ReadTable()
    local definitions = net.ReadTable()
    lia.command.openArgumentPrompt(cmd, fields, prefix, definitions)
end)

net.Receive("liaCharInfo", function()
    local data = net.ReadTable()
    local id = net.ReadUInt(32)
    local client = net.BytesLeft() > 0 and net.ReadEntity() or nil
    lia.char.addCharacter(id, lia.char.new(data, id, client == nil and LocalPlayer() or client))
end)

net.Receive("liaCharKick", function()
    local id = net.ReadUInt(32)
    local isCurrentChar = net.ReadBool()
    hook.Run("KickedFromChar", id, isCurrentChar)
end)

net.Receive("liaGlobalVar", function()
    local key = net.ReadString()
    local value = net.ReadType()
    local oldValue = lia.net.globals[key]
    lia.net.globals[key] = value
    hook.Run("NetVarChanged", nil, key, oldValue, value)
end)

net.Receive("liaNetDel", function()
    local index = net.ReadUInt(16)
    lia.net[index] = nil
end)

net.Receive("liaCharacterData", function()
    local charID = net.ReadUInt(32)
    local character = lia.char.getCharacter(charID)
    if not character then return end
    if not character.dataVars then character.dataVars = {} end
    local keyCount = net.ReadUInt(32)
    for _ = 1, keyCount do
        local key = net.ReadString()
        local value = net.ReadType()
        character.dataVars[key] = value
    end
end)

lia.net.readBigTable("liaDialogSync", function(data) if istable(data) then lia.dialog.stored = data end end)
net.Receive("liaOpenNpcDialog", function()
    local npc = net.ReadEntity()
    local canCustomize = net.ReadBool()
    local npcData = net.ReadTable()
    local npcName = "Dialog"
    if IsValid(npc) then
        npcName = npc:getNetVar("NPCName", npc.NPCName or "Dialog")
    elseif npcData and npcData.PrintName then
        npcName = npcData.PrintName
    end

    lia.dialog.vgui = vgui.Create("liaDialogMenu")
    lia.dialog.vgui:SetDialogTitle(npcName)
    if npcData then
        local enhancedConversation = table.Copy(npcData.Conversation or {})
        local additionalOptions = hook.Run("GetNPCDialogOptions", LocalPlayer(), npc, canCustomize) or {}
        for optionName, optionData in pairs(additionalOptions) do
            enhancedConversation[optionName] = optionData
        end

        local enhancedData = table.Copy(npcData)
        enhancedData.Conversation = enhancedConversation
        lia.dialog.vgui:LoadNPCDialog(enhancedData, npc)
    end
end)

net.Receive("liaNpcDialogDeliverResponse", function()
    local npc = net.ReadEntity()
    local responses = net.ReadTable()
    if not IsValid(lia.dialog.vgui) or not responses then return end
    if lia.dialog.vgui.DisplayServerResponse then lia.dialog.vgui:DisplayServerResponse(responses, npc) end
end)

net.Receive("liaNpcDialogNodeResult", function()
    local result = net.ReadTable()
    if not IsValid(lia.dialog.vgui) or not result then return end
    if lia.dialog.vgui.HandleGeneratedDialogResult then lia.dialog.vgui:HandleGeneratedDialogResult(result) end
end)

lia.derma.requestNPCSelection = function(title, description, options, callback)
    options = istable(options) and options or {}
    local frame = vgui.Create("liaFrame")
    frame:SetSize(580, math.Clamp(176 + #options * 54, 300, math.floor(ScrH() * 0.68)))
    frame:Center()
    frame:MakePopup()
    StyleRequestFrame(frame, "NPC REQUEST", resolveClientRequestText(title, L("selectNPCType")), resolveClientRequestText(description, ""))
    local finished = false
    local function closeRequest()
        if finished then return end
        finished = true
        if IsValid(frame) then frame:Remove() end
    end

    CreateRequestFooter(frame, L("cancel"), nil, closeRequest, nil)
    local scroll = CreateRequestScroll(frame)
    for _, option in ipairs(options) do
        local displayName = tostring(option[1] or "Unknown")
        local uniqueID = tostring(option[2] or "")
        local button = CreateRequestButton(scroll, displayName, "secondary")
        button:Dock(TOP)
        button:SetTall(46)
        button:DockMargin(0, 0, 0, 8)
        button.Paint = function(s, w, h)
            local palette = getRequestPalette()
            s._liaRequestHover = Lerp(math.Clamp(FrameTime() * 14, 0, 1), s._liaRequestHover, s:IsHovered() and 1 or 0)
            local background = Color(math.Round(Lerp(s._liaRequestHover, palette.button.r, palette.buttonHovered.r)), math.Round(Lerp(s._liaRequestHover, palette.button.g, palette.buttonHovered.g)), math.Round(Lerp(s._liaRequestHover, palette.button.b, palette.buttonHovered.b)), 246)
            drawRequestPanel(0, 0, w, h, 6, background, Color(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(Lerp(s._liaRequestHover, 44, 125))))
            draw.SimpleText(displayName, "LiliaFont.17", 14, h * 0.5 - 6, palette.textSecondary, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if uniqueID ~= "" then draw.SimpleText(uniqueID, "LiliaFont.14", 14, h * 0.5 + 10, palette.textMuted, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            draw.SimpleText(">", "LiliaFont.18", w - 17, h * 0.5, s:IsHovered() and palette.accent or palette.textMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function()
            if finished then return end
            finished = true
            if callback then callback(uniqueID, displayName) end
            if IsValid(frame) then frame:Remove() end
        end
    end
    return frame
end

net.Receive("liaRequestNPCSelection", function()
    local npcEntity = net.ReadEntity()
    local npcOptions = net.ReadTable()
    if not IsValid(npcEntity) or not istable(npcOptions) then return end
    lia.derma.requestNPCSelection(L("selectNPCType"), "Choose the NPC type to use.", npcOptions, function(uniqueID)
        net.Start("liaRequestNPCSelection")
        net.WriteEntity(npcEntity)
        net.WriteString(uniqueID)
        net.SendToServer()
    end)
end)

net.Receive("liaPacSync", function()
    for _, client in player.Iterator() do
        for id in pairs(client:getParts()) do
            hook.Run("AttachPart", client, id)
        end
    end
end)

net.Receive("liaPacPartAdd", function()
    local client = net.ReadEntity()
    local id = net.ReadString()
    if not IsValid(client) then return end
    hook.Run("AttachPart", client, id)
end)

net.Receive("liaPacPartRemove", function()
    local client = net.ReadEntity()
    local id = net.ReadString()
    if not IsValid(client) then return end
    hook.Run("RemovePart", client, id)
end)

net.Receive("liaPacPartReset", function()
    local client = net.ReadEntity()
    if not IsValid(client) or not client.RemovePACPart then return end
    if client.liaPACParts then
        for _, part in pairs(client.liaPACParts) do
            client:RemovePACPart(part)
        end

        client.liaPACParts = nil
    end
end)

net.Receive("liaEmitUrlSound", function()
    local ent = net.ReadEntity()
    local soundPath = net.ReadString()
    local volume = net.ReadFloat()
    local soundLevel = net.ReadFloat()
    local hasDelay = net.ReadBool()
    local startDelay = hasDelay and net.ReadFloat() or nil
    if not IsValid(ent) then return end
    if soundPath:find("^https?://") then
        local maxDistance = soundLevel * 13.33
        local ext = soundPath:match("%.([%w]+)$") or "mp3"
        local name = util.CRC(soundPath) .. "." .. ext
        local cachedPath = lia.websound.get(name)
        if cachedPath then
            ent:playFollowingSound(cachedPath, volume, true, maxDistance, startDelay)
        else
            lia.websound.register(name, soundPath, function(localPath) if localPath then ent:playFollowingSound(localPath, volume, true, maxDistance, startDelay) end end)
        end
    elseif soundPath:find("^lilia/websounds/") or soundPath:find("^websounds/") then
        local maxDistance = soundLevel * 13.33
        ent:playFollowingSound(soundPath, volume, true, maxDistance, startDelay)
    else
        ent:EmitSound(soundPath, soundLevel, nil, volume, nil, nil, nil)
    end
end)

net.Receive("liaAssureClientSideAssets", function()
    lia.webimage.clearCache(true)
    lia.websound.clearCache(true)
    local webimages = lia.webimage.stored
    local websounds = lia.websound.stored
    local downloadQueue = {}
    local activeDownloads = 0
    local maxConcurrent = 5
    local totalImages = table.Count(webimages)
    local totalSounds = table.Count(websounds)
    local completedImages = 0
    local completedSounds = 0
    local failedImages = 0
    local failedSounds = 0
    for name, data in pairs(webimages) do
        table.insert(downloadQueue, {
            type = "image",
            name = name,
            url = data.url,
            flags = data.flags
        })
    end

    for name, url in pairs(websounds) do
        table.insert(downloadQueue, {
            type = "sound",
            name = name,
            url = url
        })
    end

    lia.information(L("downloadQueueSize") .. ": " .. #downloadQueue)
    lia.information(L("processingWithMaxConcurrentDownloads") .. ": " .. maxConcurrent)
    local function processNextDownload()
        if #downloadQueue == 0 then return end
        local download = table.remove(downloadQueue, 1)
        activeDownloads = activeDownloads + 1
        if download.type == "image" then
            lia.webimage.download(download.name, download.url, function(material, fromCache, errorMsg)
                activeDownloads = activeDownloads - 1
                if material then
                    completedImages = completedImages + 1
                    if not fromCache then lia.information(L("imageDownloaded") .. ": " .. download.name) end
                else
                    failedImages = failedImages + 1
                    local errorMessage = errorMsg or L("unknownError")
                    lia.warning(L("imageFailed") .. ": " .. download.name .. " - " .. errorMessage)
                    chat.AddText(Color(255, 100, 100), L("imageDownload"), Color(255, 255, 255), L("failedToDownloadImage", download.name, errorMessage))
                end

                processNextDownload()
            end, download.flags)
        elseif download.type == "sound" then
            lia.websound.download(download.name, download.url, function(path, fromCache, errorMsg)
                activeDownloads = activeDownloads - 1
                if path then
                    completedSounds = completedSounds + 1
                else
                    failedSounds = failedSounds + 1
                    local errorMessage = errorMsg or L("unknownError")
                    chat.AddText(Color(255, 100, 100), L("soundDownload"), Color(255, 255, 255), L("failedToDownloadSound", download.name, errorMessage))
                end

                processNextDownload()
            end)
        end
    end

    for _ = 1, math.min(maxConcurrent, #downloadQueue) do
        processNextDownload()
    end

    timer.Create("AssetDownloadProgress", 2, 0, function()
        if activeDownloads == 0 and #downloadQueue == 0 then
            timer.Remove("AssetDownloadProgress")
            lia.option.load()
            lia.keybind.load()
            timer.Simple(1.0, function()
                local imageStats = lia.webimage.getStats()
                local soundStats = lia.websound.getStats()
                lia.bootstrap("AssetDownload", "===========================================")
                lia.bootstrap("AssetDownload", L("assetDownloadComplete"))
                lia.bootstrap("AssetDownload", L("downloadSummary"))
                lia.bootstrap("AssetDownload", L("assetSummaryImagesCompleted", completedImages, totalImages, failedImages))
                lia.bootstrap("AssetDownload", L("assetSummarySoundsCompleted", completedSounds, totalSounds, failedSounds))
                lia.bootstrap("AssetDownload", L("currentStatistics"))
                lia.bootstrap("AssetDownload", L("imagesDownloaded", imageStats.downloaded, imageStats.stored))
                lia.bootstrap("AssetDownload", L("soundsDownloaded", soundStats.downloaded, soundStats.stored))
                lia.bootstrap("AssetDownload", L("combinedDownloaded", imageStats.downloaded + soundStats.downloaded, imageStats.stored + soundStats.stored))
                lia.bootstrap("AssetDownload", "===========================================")
                if failedImages > 0 or failedSounds > 0 then
                    lia.warning(L("warningAssetsFailedToDownload"))
                    if failedImages > 0 then chat.AddText(Color(255, 150, 100), L("assetDownloadLabel"), Color(255, 255, 255), L("assetsDownloadWarning", failedImages, L("assetTypeImages"))) end
                    if failedSounds > 0 then chat.AddText(Color(255, 150, 100), L("assetDownloadLabel"), Color(255, 255, 255), L("assetsDownloadWarning", failedSounds, L("assetTypeSounds"))) end
                else
                    chat.AddText(Color(100, 255, 100), L("assetDownloadLabel"), Color(255, 255, 255), L("allAssetsDownloadedSuccessfully"))
                end
            end)
        end
    end)
end)

net.Receive("liaChatMsg", function()
    local client = net.ReadEntity()
    local chatType = net.ReadString()
    local text = net.ReadString()
    local anonymous = net.ReadBool()
    if IsValid(client) then
        local class = lia.chat.classes[chatType]
        text = hook.Run("OnChatReceived", client, chatType, text, anonymous) or text
        if class then
            CHAT_CLASS = class
            class.onChatAdd(client, text, anonymous)
            if lia.config.get("CustomChatSound", "") and lia.config.get("CustomChatSound", "") ~= "" then
                surface.PlaySound(lia.config.get("CustomChatSound", ""))
            else
                chat.PlaySound()
            end

            CHAT_CLASS = nil
        end
    end
end)

net.Receive("liaDoorMenu", function()
    if net.BytesLeft() > 0 then
        local entity = net.ReadEntity()
        local count = net.ReadUInt(8)
        local access = {}
        for _ = 1, count do
            local ply = net.ReadEntity()
            local perm = net.ReadUInt(2)
            access[ply] = perm
        end

        local door2 = net.ReadEntity()
        if IsValid(lia.gui.door) then return lia.gui.door:Remove() end
        if IsValid(entity) then
            lia.gui.door = vgui.Create("liaDoorMenu")
            lia.gui.door:setDoor(entity, access, door2)
        end
    elseif IsValid(lia.gui.door) then
        lia.gui.door:Remove()
    end
end)

net.Receive("liaDoorDataUpdate", function()
    local doorID = net.ReadUInt(16)
    local hasData = net.ReadBool()
    local data = hasData and net.ReadTable() or nil
    lia.doors.updateCachedData(doorID, data)
end)

lia.net.readBigTable("liaDoorDataBulk", function(data)
    if not istable(data) then return end
    for doorID, doorData in pairs(data) do
        lia.doors.updateCachedData(tonumber(doorID) or doorID, doorData)
    end
end)

net.Receive("liaDoorPerm", function()
    local door = net.ReadEntity()
    local client = net.ReadEntity()
    local access = net.ReadUInt(2)
    local panel = door.liaPanel
    if IsValid(panel) and IsValid(client) then
        panel.access[client] = access
        for _, v in ipairs(panel.access:GetLines()) do
            if v.player == client then
                v:SetColumnText(2, L(lia.doors.AccessLabels[access or 0]))
                return
            end
        end
    end
end)

net.Receive("liaRemoveFOne", function() if IsValid(lia.gui.menu) then lia.gui.menu:remove() end end)
local function uiCreate()
    if panel and panel:IsValid() then return end
    local pad, bh = 10, 40
    local w, h = 400 + pad * 2, 80
    panel = vgui.Create("liaFrame")
    panel:SetSize(w, h)
    panel:SetPos((ScrW() - w) / 2, ScrH() * 0.1)
    panel:SetZPos(999999)
    panel:MoveToFront()
    panel:SetTitle("")
    panel:SetCenterTitle(L("downloadingWorkshopAddonsTitle"))
    panel:ShowAnimation()
    panel.bar = vgui.Create("liaProgressBar", panel)
    panel.bar:SetPos(pad, h * 0.65 - bh / 2)
    panel.bar:SetSize(w - pad * 2, bh)
    panel.bar:SetFraction(0)
end

local queue = {}
local MOUNT_DELAY = 3
local function gmaPath(id)
    return "lilia/workshop/" .. id .. ".gma"
end

local function mounted(id)
    for _, addon in pairs(engine.GetAddons() or {}) do
        if tostring(addon.wsid or addon.workshopid) == tostring(id) and addon.mounted then return true end
    end
    return false
end

local function mountLocal(id)
    local rel = gmaPath(id)
    if file.Exists(rel, "DATA") then
        game.MountGMA("data/" .. rel)
        return true
    end
    return false
end

local function uiUpdate()
    if not (panel and panel:IsValid()) then return end
    panel.bar:SetFraction(totalDownloads > 0 and (totalDownloads - remainingDownloads) / totalDownloads or 0)
    panel.bar:SetText((totalDownloads - remainingDownloads) .. "/" .. totalDownloads)
end

local function start()
    for id in pairs(queue) do
        if mounted(id) or mountLocal(id) then queue[id] = nil end
    end

    local seq, idx = {}, 1
    for id in pairs(queue) do
        seq[#seq + 1] = id
    end

    totalDownloads = #seq
    remainingDownloads = totalDownloads
    if totalDownloads == 0 then
        lia.bootstrap(L("workshopDownloader"), L("workshopAllInstalled"))
        return
    end

    uiCreate()
    uiUpdate()
    local function nextItem()
        if idx > #seq then
            if panel and panel:IsValid() then
                panel:Remove()
                panel = nil
            end
            return
        end

        local id = seq[idx]
        lia.bootstrap(L("workshopDownloader"), L("workshopDownloading", id))
        steamworks.DownloadUGC(id, function(path)
            remainingDownloads = remainingDownloads - 1
            lia.bootstrap(L("workshopDownloader"), L("workshopDownloadComplete", id))
            if path then
                local rel = gmaPath(id)
                local data = file.Read(path, "GAME")
                if data then
                    file.Write(rel, data)
                    path = "data/" .. rel
                end

                game.MountGMA(path)
            end

            uiUpdate()
            idx = idx + 1
            timer.Simple(MOUNT_DELAY, nextItem)
        end)
    end

    nextItem()
end

local function buildQueue(all)
    table.Empty(queue)
    for id in pairs(lia.workshop.serverIds or {}) do
        if id == FORCE_ID or all then queue[id] = true end
    end
end

local function refresh(tbl)
    if tbl then lia.workshop.serverIds = tbl end
    local ids = {}
    for id in pairs(lia.workshop.serverIds or {}) do
        if id ~= FORCE_ID then ids[#ids + 1] = id end
    end

    if #ids == 0 then return end
    local idx = 1
    local function mountNext()
        if idx > #ids then return end
        local id = ids[idx]
        mountLocal(id)
        idx = idx + 1
        if idx <= #ids then timer.Simple(MOUNT_DELAY, mountNext) end
    end

    mountNext()
end

net.Receive("liaWorkshopDownloaderStart", function()
    refresh(net.ReadTable())
    buildQueue(true)
    start()
end)

concommand.Add("workshop_force_redownload", function()
    table.Empty(queue)
    buildQueue(true)
    start()
end)

net.Receive("liaNotificationData", lia.notices.receiveNotify)
net.Receive("liaNotifyLocal", lia.notices.receiveNotifyL)
net.Receive("liaWorkshopDownloaderInfo", function() refresh(net.ReadTable()) end)
net.Receive("liaGroupPermChanged", function()
    local group = net.ReadString()
    local privilege = net.ReadString()
    local value = net.ReadBool()
    lia.admin.groups = lia.admin.groups or {}
    lia.admin.groups[group] = lia.admin.groups[group] or {}
    if value then
        lia.admin.groups[group][privilege] = true
    else
        lia.admin.groups[group][privilege] = nil
    end

    local effectiveValue = lia.admin.hasAccess(group, privilege)
    lia.debug("[Permissions UI]", "Received live permission change", "group=", tostring(group), "privilege=", tostring(privilege), "explicitValue=", tostring(value), "effectiveValue=", tostring(effectiveValue), "localPlayerUserGroup=", tostring(IsValid(LocalPlayer()) and LocalPlayer():GetUserGroup() or "unknown"))
    if IsValid(lia.gui.usergroups) then
        local checks = lia.gui.usergroups.checks
        local row = checks and checks[group] and checks[group][privilege] or nil
        if IsValid(row) then row:InvalidateLayout(true) end
    end
end)

net.Receive("liaBodygrouperMenu", function()
    local client = LocalPlayer()
    if IsValid(lia.gui.bodygroupMenu) then lia.gui.bodygroupMenu:Remove() end
    local entity = net.ReadEntity()
    lia.gui.bodygroupMenu = vgui.Create("BodygrouperMenu")
    local target = IsValid(entity) and entity or client
    lia.gui.bodygroupMenu:SetTarget(target)
end)

net.Receive("liaBodygrouperMenuCloseClientside", function() if IsValid(lia.gui.bodygroupMenu) then lia.gui.bodygroupMenu:Remove() end end)
net.Receive("liaSeeModelTable", function()
    local models = net.ReadTable()
    if not istable(models) or #models == 0 then return end
    local selectedModel = models[1]
    local frame = vgui.Create("liaFrame")
    frame:setScaledSize(520, math.min(ScrH() * 0.82, 820))
    frame:SetPos(ScrW() - frame:GetWide() - 48, math.max(48, (ScrH() - frame:GetTall()) * 0.5))
    frame:SetTitle(L("wardrobeSelectTitle"))
    frame:MakePopup()
    frame:DockPadding(12, 34, 12, 12)
    local function positionWardrobeCloseButton(this)
        if IsValid(this.cls) then
            this.cls:SetParent(this)
            this.cls:SetSize(20, 20)
            this.cls:SetPos(this:GetWide() - 22, 2)
            this.cls:SetZPos(1000)
        end
    end

    frame.OnSizeChanged = function(this) positionWardrobeCloseButton(this) end
    positionWardrobeCloseButton(frame)
    local title = frame:Add("DPanel")
    title:Dock(TOP)
    title:DockMargin(0, 0, 0, 12)
    title:SetTall(32)
    title.Paint = function(_, w, h)
        local lineColor = lia.color.theme.theme
        surface.SetDrawColor(lineColor)
        surface.DrawRect(4, h - 2, math.max(w - 8, 0), 2)
    end

    local titleLabel = title:Add("DLabel")
    titleLabel:Dock(FILL)
    titleLabel:DockMargin(8, 0, 8, 0)
    titleLabel:SetFont("LiliaFont.18")
    titleLabel:SetText(L("selectModel"):upper())
    titleLabel:SetTextColor(lia.color.theme and lia.color.theme.text or color_white)
    titleLabel:SetContentAlignment(5)
    local hint = frame:Add("DLabel")
    hint:Dock(TOP)
    hint:DockMargin(0, 0, 0, 10)
    hint:SetTall(20)
    hint:SetFont("LiliaFont.16")
    hint:SetTextColor(Color(220, 220, 220))
    hint:SetContentAlignment(5)
    hint:SetText(L("rotateInstruction", "A", "D"))
    local confirmButton = vgui.Create("DButton", frame)
    confirmButton:SetText(L("wardrobeConfirmButton"))
    confirmButton:Dock(BOTTOM)
    confirmButton:SetTall(40)
    confirmButton:SetColor(Color(255, 255, 255))
    confirmButton:SetFont("DermaDefaultBold")
    confirmButton:SetContentAlignment(5)
    confirmButton:DockMargin(0, 10, 0, 0)
    local modelsScroll = vgui.Create("liaScrollPanel", frame)
    modelsScroll:Dock(FILL)
    modelsScroll:DockMargin(0, 0, 0, 0)
    local iconLayoutParent = modelsScroll.GetCanvas and modelsScroll:GetCanvas() or modelsScroll
    local iconLayout = iconLayoutParent:Add("DIconLayout")
    iconLayout:Dock(LEFT)
    iconLayout:SetSpaceX(8)
    iconLayout:SetSpaceY(8)
    iconLayout:SetPaintBackground(false)
    frame._iconColumns = 5
    frame._iconSpace = 8
    local function requestIconResize()
        if not IsValid(iconLayout) then return false end
        local w = iconLayout:GetWide() or 0
        if w <= 0 then return false end
        frame._needsIconResize = true
        frame:InvalidateLayout(true)
        return true
    end

    local oldLayoutPerformLayout = iconLayout.PerformLayout
    iconLayout.PerformLayout = function(layout, w, h)
        if oldLayoutPerformLayout then oldLayoutPerformLayout(layout, w, h) end
        local offsetX = layout._centerOffsetX or 0
        local prevOffsetX = layout._appliedCenterOffsetX or 0
        local delta = offsetX - prevOffsetX
        if delta == 0 then return end
        for _, child in ipairs(layout:GetChildren()) do
            if IsValid(child) then
                local x, y = child:GetPos()
                child:SetPos(x + delta, y)
            end
        end

        layout._appliedCenterOffsetX = offsetX
    end

    frame.PerformLayout = function(this, w, h)
        local columns = this._iconColumns or 5
        local space = this._iconSpace or 8
        local layoutW = IsValid(modelsScroll) and modelsScroll:GetWide() or 0
        if layoutW <= 0 then return end
        iconLayout:SetWide(layoutW)
        local iconW = math.floor((layoutW - (columns - 1) * space) / columns)
        if iconW < 64 then iconW = 64 end
        if iconW > 80 then iconW = 80 end
        local iconH = math.floor(iconW * 2)
        for _, child in ipairs(iconLayout:GetChildren()) do
            if IsValid(child) and child.SetSize then child:SetSize(iconW, iconH) end
        end

        iconLayout:SizeToChildren(false, true)
        local childCount = #iconLayout:GetChildren()
        local usedWidth = math.min(childCount, columns) * iconW + math.max(0, math.min(childCount, columns) - 1) * space
        iconLayout._centerOffsetX = math.max(0, math.floor((layoutW - usedWidth) * 0.5))
        iconLayout:InvalidateLayout(true)
        this._needsIconResize = nil
    end

    local function previewModel(modelPath)
        lia.camera.begin(frame, {
            hideEntities = {LocalPlayer()}
        })

        lia.camera.setModel(frame, modelPath)
    end

    local function setSelectedModel(modelPath)
        selectedModel = modelPath
        previewModel(modelPath)
        if IsValid(iconLayout) then
            for _, child in ipairs(iconLayout:GetChildren()) do
                if IsValid(child) then child._liaSelected = child.modelPath == modelPath end
            end
        end
    end

    local function paintIcon(icon, w, h)
        if not icon._liaSelected then return end
        local col = lia.config.get("Color", color_white)
        surface.SetDrawColor(col.r, col.g, col.b, 200)
        for i = 1, 3 do
            local o = i * 2
            surface.DrawOutlinedRect(i, i, w - o, h - o)
        end
    end

    local function buildModelIcons()
        if not IsValid(iconLayout) then return end
        iconLayout:Clear()
        for _, modelPath in ipairs(models) do
            local icon = iconLayout:Add("SpawnIcon")
            icon:SetModel(modelPath)
            icon.modelPath = modelPath
            icon.PaintOver = paintIcon
            icon.DoClick = function() setSelectedModel(modelPath) end
        end

        requestIconResize()
    end

    buildModelIcons()
    setSelectedModel(models[1])
    frame.Think = function()
        if input.IsKeyDown(KEY_A) then
            lia.camera.rotate(frame, -50 * FrameTime())
        elseif input.IsKeyDown(KEY_D) then
            lia.camera.rotate(frame, 50 * FrameTime())
        end
    end

    frame.OnRemove = function() lia.camera.close(frame) end
    confirmButton.DoClick = function()
        if isstring(selectedModel) and selectedModel ~= "" then
            net.Start("liaWardrobeChangeModel")
            net.WriteString(selectedModel)
            net.SendToServer()
            frame:Close()
        else
            chat.AddText(Color(255, 0, 0), L("wardrobeSelectError"))
        end
    end

    timer.Simple(0, function()
        if not IsValid(frame) then return end
        requestIconResize()
        timer.Simple(0.05, function() if IsValid(frame) then requestIconResize() end end)
    end)
end)

net.Receive("liaSyncGesture", function()
    local entity = net.ReadEntity()
    local a = net.ReadUInt(8)
    local b = net.ReadUInt(16)
    local c = net.ReadBool()
    if IsValid(entity) then entity:AnimRestartGesture(a, b, c) end
end)
