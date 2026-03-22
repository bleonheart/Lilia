--[[
    Folder: Definitions
    File:  arccw_att.md
]]
--[[
    ArcCW Attachment Item Definition

    Weapon attachment system for the Lilia framework with ArcCW integration.
]]
--[[
    ArcCW attachment items allow players to equip and manage weapon attachments.
    They integrate with the ArcCW weapon system for enhanced functionality.

    PLACEMENT:
    - Place in: ModuleFolder/items/attachments/ItemHere.lua (for module-specific items)
    - Place in: SchemaFolder/items/attachments/ItemHere.lua (for schema-specific items)

    USAGE:
    - Attachment items are equipped through the inventory menu
    - They are applied to compatible weapons in the ArcCW system
    - Attachments can be unequipped and returned to inventory
    - Supports automatic attachment management on loadout changes
]]
--[[
    Purpose:
        Sets the display name shown to players

    Example Usage:
        ```lua
        -- Set the attachment name
        ITEM.name = "Red Dot Sight"
        ```
]]
if not ArcCWInstalled then return end
ITEM.name = "arccwAttachment"
--[[
    Purpose:
        Sets the description text shown to players

    Example Usage:
        ```lua
        -- Set the attachment description
        ITEM.desc = "A tactical red dot sight for improved accuracy"
        ```
]]
ITEM.desc = "arccwAttachmentDesc"
--[[
    Purpose:
        Sets the category for inventory sorting

    Example Usage:
        ```lua
        -- Set inventory category
        ITEM.category = "attachments"
        ```
]]
ITEM.category = "attachments"
--[[
    Purpose:
        Sets the 3D model used for the item

    Example Usage:
        ```lua
        -- Set the item model
        ITEM.model = "models/Items/BoxSRounds.mdl"
        ```
]]
ITEM.model = "models/Items/BoxSRounds.mdl"
--[[
    Purpose:
        Sets the width of the item in inventory grid slots

    Example Usage:
        ```lua
        -- Set item width
        ITEM.width = 1
        ```
]]
ITEM.width = 1
--[[
    Purpose:
        Sets the height of the item in inventory grid slots

    Example Usage:
        ```lua
        -- Set item height
        ITEM.height = 1
        ```
]]
ITEM.height = 1
--[[
    Purpose:
        Sets the ArcCW attachment ID to be used by this item

    Example Usage:
        ```lua
        -- Set the attachment ID
        ITEM.att = "kry_acog"
        ```
]]
ITEM.att = ""
if CLIENT then
    function ITEM:paintOver(item, w, h)
        if item:getData("equip") then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
        end
    end
end

function ITEM:removeAttachment(client)
    if ArcCW:PlayerTakeAtt(client, self.att, 1) then
        self:setData("equip", nil)
        ArcCW:PlayerSendAttInv(client)
        return true
    end
    return false
end

function ITEM:addAttachment(client)
    ArcCW:PlayerGiveAtt(client, self.att, 1)
    ArcCW:PlayerSendAttInv(client)
end

local function unEquip(item)
    if not item:getData("equip") then return end
    if not item:removeAttachment(item.player) then item:setData("equip", nil) end
end

ITEM:hook("transfer", unEquip)
ITEM:hook("drop", unEquip)
ITEM.functions.Unequip = {
    name = "unequip",
    tip = "Unequip this item",
    icon = "icon16/cross.png",
    onRun = function(item)
        if item:removeAttachment(item.player) then
            item.player:notifySuccess("Attachment unequipped.")
        else
            item.player:notifyError("Failed to unequip attachment.")
        end
        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) and item:getData("equip") == true end
}

ITEM.functions.Equip = {
    name = "equip",
    tip = "Equip this item",
    icon = "icon16/tick.png",
    onRun = function(item)
        item:setData("equip", true)
        item:addAttachment(item.player)
        item.player:notifySuccess("Attachment equipped.")
        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) and item:getData("equip") ~= true end
}

function ITEM:OnCanBeTransfered(_, newInventory)
    if newInventory and self:getData("equip") then return false end
    return true
end

function ITEM:onLoadout()
    if self:getData("equip") then self:addAttachment(self.player) end
end

function ITEM:onRemoved()
    if IsValid(receiver) and receiver:IsPlayer() and self:getData("equip") and not self:removeAttachment(receiver) then self:setData("equip", nil) end
end