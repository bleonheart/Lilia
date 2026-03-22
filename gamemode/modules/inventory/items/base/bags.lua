--[[
    Folder: Definitions
    File:  bags.md
]]
--[[
    Bag Item Definition

    Container storage system for the Lilia framework.
]]
--[[
    Bag items provide additional inventory space for players to store items.
    They create separate inventories that can be accessed through the bag interface.

    PLACEMENT:
    - Place in: ModuleFolder/items/bags/ItemHere.lua (for module-specific items)
    - Place in: SchemaFolder/items/bags/ItemHere.lua (for schema-specific items)

    USAGE:
    - Bag items are opened through the inventory menu
    - They provide additional storage space in a separate inventory
    - Items can be transferred between main inventory and bag inventory
    - Bags can be dropped and picked up with their contents preserved
]]
--[[
    Purpose:
        Sets the display name shown to players

    Example Usage:
        ```lua
        -- Set the bag name
        ITEM.name = "Backpack"
        ```
]]
ITEM.name = "bagName"
--[[
    Purpose:
        Sets the description text shown to players

    Example Usage:
        ```lua
        -- Set the bag description
        ITEM.desc = "A spacious backpack for carrying extra items"
        ```
]]
ITEM.desc = "A bag to hold more items."
--[[
    Purpose:
        Sets the 3D model used for the item

    Example Usage:
        ```lua
        -- Set the bag model
        ITEM.model = "models/props_c17/suitcase001a.mdl"
        ```
]]
ITEM.model = "models/props_c17/suitcase001a.mdl"
--[[
    Purpose:
        Sets the category for inventory sorting

    Example Usage:
        ```lua
        -- Set inventory category
        ITEM.category = "storage"
        ```
]]
ITEM.category = "storage"
--[[
    Purpose:
        Marks this item as a bag container

    Example Usage:
        ```lua
        -- Mark as bag item
        ITEM.isBag = true
        ```
]]
ITEM.isBag = true
--[[
    Purpose:
        Sets the width of the bag inventory in grid slots

    Example Usage:
        ```lua
        -- Set bag inventory width
        ITEM.invWidth = 2
        ```
]]
ITEM.invWidth = 2
--[[
    Purpose:
        Sets the height of the bag inventory in grid slots

    Example Usage:
        ```lua
        -- Set bag inventory height
        ITEM.invHeight = 2
        ```
]]
ITEM.invHeight = 2
--[[
    Purpose:
        Sets the sound played when interacting with the bag

    Example Usage:
        ```lua
        -- Set bag interaction sound
        ITEM.BagSound = {"physics/cardboard/cardboard_box_impact_soft2.wav", 50}
        ```
]]
ITEM.BagSound = {"physics/cardboard/cardboard_box_impact_soft2.wav", 50}
--[[
    Purpose:
        Sets PAC3 data for visual customization when equipped

    Example Usage:
        ```lua
        -- Set PAC3 data
        ITEM.pacData = {
            [1] = {
                ["children"] = {},
                ["self"] = {
                    ["Model"] = "models/props_c17/suitcase001a.mdl",
                    ["ClassName"] = "model"
                }
            }
        }
        ```
]]
ITEM.pacData = {}
function ITEM:onInstanced()
    local data = {
        item = self:getID(),
        w = self.invWidth,
        h = self.invHeight
    }

    lia.inventory.instance("GridInv", data):next(function(inventory)
        self:setData("id", inventory:getID())
        hook.Run("SetupBagInventoryAccessRules", inventory)
        inventory:sync()
        self:resolveInvAwaiters(inventory)
        hook.Run("BagInventoryReady", self, inventory)
    end)
end

function ITEM:onRestored()
    local invID = self:getData("id")
    if invID then
        lia.inventory.loadByID(invID):next(function(inventory)
            hook.Run("SetupBagInventoryAccessRules", inventory)
            self:resolveInvAwaiters(inventory)
            hook.Run("BagInventoryReady", self, inventory)
        end)
    end
end

function ITEM:onRegistered()
    if not self.functions.Open then self.functions.Open = ITEM.functions.Open end
end

function ITEM:onRemoved()
    local invID = self:getData("id")
    if invID then
        local inv = lia.inventory.instances[invID]
        if inv then hook.Run("BagInventoryRemoved", self, inv) end
        lia.inventory.deleteByID(invID)
    end
end

function ITEM:getInv()
    return lia.inventory.instances[self:getData("id")]
end

function ITEM:onSync(recipient)
    local inventory = self:getInv()
    if inventory then inventory:sync(recipient) end
end

ITEM.functions.Open = {
    tip = "openTip",
    icon = "icon16/briefcase.png",
    onRun = function(item)
        local client = item.player
        local inventory = item:getInv()
        if not inventory then
            if SERVER then
                lia.log.add(client, "itemInteractionFailed", "open", item:getName())
                client:notifyError("This bag has no inventory.")
            end
            return false
        end

        if SERVER then
            inventory:sync(client)
        else
            local myInv = LocalPlayer():getChar():getInv()
            lia.inventory.showDual(myInv, inventory)
        end
        return false
    end,
    onCanRun = function(item)
        local client = item.player
        local canRun = not IsValid(item.entity) and item:getInv() ~= nil
        if SERVER and not canRun then
            local reason = IsValid(item.entity) and "bagOnGround" or "bagNoInventory"
            client:notifyErrorLocalized(reason)
            lia.log.add(client, "itemInteractionFailed", "open", item:getName())
        end
        return canRun
    end
}

function ITEM.postHooks:drop()
    local invID = self:getData("id")
    if invID then
        net.Start("liaInventoryDelete")
        net.WriteType(invID)
        net.Send(self.player)
    end
end

function ITEM:onCombine(other)
    local client = self.player
    local invID = self:getInv() and self:getInv():getID() or nil
    if not invID then return end
    local res = hook.Run("HandleItemTransferRequest", client, other:getID(), nil, nil, invID)
    if not res then return end
    res:next(function(result)
        if not IsValid(client) then return end
        if istable(result) and isstring(result.error) then return client:notifyErrorLocalized(result.error) end
        client:EmitSound(unpack(self.BagSound))
    end)
end

if SERVER then
    function ITEM:onDisposed()
        local inventory = self:getInv()
        if inventory then
            hook.Run("BagInventoryRemoved", self, inventory)
            inventory:destroy()
        end
    end

    function ITEM:resolveInvAwaiters(inventory)
        if self.awaitingInv then
            for _, d in ipairs(self.awaitingInv) do
                d:resolve(inventory)
            end

            self.awaitingInv = nil
        end
    end

    function ITEM:awaitInv()
        local d = deferred.new()
        local inventory = self:getInv()
        if inventory then
            d:resolve(inventory)
        else
            self.awaitingInv = self.awaitingInv or {}
            self.awaitingInv[#self.awaitingInv + 1] = d
        end
        return d
    end
end
