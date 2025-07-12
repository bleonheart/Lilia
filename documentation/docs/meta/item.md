# Item Meta

Item objects represent things found in inventories or spawned in the world.

This guide describes methods for reading and manipulating item data.

---

## Overview

Item-meta functions cover stack counts, categories, weight calculations, and network variables.

Items can exist in inventories or the world, and item instances clone the base properties defined by the item table.

These helpers enable consistent interaction across trading, crafting, and interface components.

---

### getQuantity

**Purpose**

Retrieves how many of this item the stack represents.

If the item has not yet been instanced (`id` equals `0`), this returns the `maxQuantity` defined on the base item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `number`: Quantity contained in this item instance.

**Example**

```lua
-- Give the player ammo equal to the stack quantity
player:GiveAmmo(item:getQuantity(), "pistol")
```

---

### eq

**Purpose**

Compares this item instance to another by ID.

**Parameters**

* `other` (Item): The other item to compare with.

**Realm**

`Shared`

**Returns**

* `boolean`: True if both items share the same ID.

**Example**

```lua
-- Check if the held item matches the inventory slot
if item:eq(slotItem) then
    print("Same item instance")
end
```

---

### tostring

**Purpose**

Returns a printable representation of this item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `string`: Identifier in the form `"item[uniqueID][id]"`.

**Example**

```lua
-- Log the item identifier during saving
print("Saving " .. item:tostring())
```

---

### getID

**Purpose**

Retrieves the unique identifier of this item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `number`: Item database ID.

**Example**

```lua
-- Use the ID when updating the database
lia.db.updateItem(item:getID(), {price = 50})
```

---

### getModel

**Purpose**

Returns the model path associated with this item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `string`: Model path.

**Example**

```lua
-- Spawn the item's model as a world prop
local prop = ents.Create("prop_physics")
prop:SetModel(item:getModel())
prop:Spawn()
```

---

### getSkin

**Purpose**

Retrieves the skin index this item uses.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `number`: Skin ID applied to the model.

**Example**

```lua
-- Apply the correct skin when displaying the item
model:SetSkin(item:getSkin())
```

---

### getPrice

**Purpose**

Returns the calculated purchase price for the item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `number`: The price value.

**Example**

```lua
-- Charge the player the item's price before giving it
if char:hasMoney(item:getPrice()) then
    char:takeMoney(item:getPrice())
end
```

---

### call

**Purpose**

Invokes an item method with the given player and entity context.

**Parameters**

* `method` (string): Method name to run.

* `client` (Player): The player performing the action.

* `entity` (Entity|nil): Entity representing this item or `nil` when none.

* `...`: Additional arguments passed to the method.

**Realm**

`Shared`

**Returns**

* `any`: Results returned by the called function.

**Example**

```lua
-- Invoke a custom repair function and check the result
local success = item:call("repair", client, entity, targetItem)
if success then
    client:notify("Repaired!")
end
```

---

### getOwner

**Purpose**

Attempts to find the player currently owning this item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `Player|nil`: The owner if available.

**Example**

```lua
-- Notify whoever currently owns the item
local owner = item:getOwner()
if IsValid(owner) then
    owner:notifyLocalized("itemGlows")
end
```

---

### getData

**Purpose**

Retrieves a piece of persistent data stored on the item.

**Parameters**

* `key` (string): Data key to read.

* `default` (any): Value to return when the key is absent.

**Realm**

`Shared`

**Returns**

* `any`: Stored value or default.

**Example**

```lua
-- Retrieve a custom paint color stored on the item
local color = item:getData("paintColor", Color(255, 255, 255))
```

---

### getAllData

**Purpose**

Returns a merged table of this item's stored data and any networked values on its entity.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `table`: Key/value table of all data fields.

**Example**

```lua
-- Print all stored data for debugging
PrintTable(item:getAllData())
```

---

### hook

**Purpose**

Registers a hook callback for this item instance.

**Parameters**

* `name` (string): Hook identifier.

* `func` (function): Function to call.

**Realm**

`Shared`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Run code when the item is used
item:hook("use", function(ply) ply:ChatPrint("Used!") end)
```

---

### postHook

**Purpose**

Registers a post-hook callback for this item.

**Parameters**

* `name` (string): Hook identifier.

* `func` (function): Function invoked after the main hook.

**Realm**

`Shared`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Give a pistol after the item is picked up
item:postHook("pickup", function(ply) ply:Give("weapon_pistol") end)
```

---

### onRegistered

**Purpose**

Called when the item table is first registered.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
function ITEM:onRegistered()
    print("Registered item " .. self.uniqueID)
end
```

---

### print

**Purpose**

Prints a simple representation of the item to the console.

**Parameters**

* `detail` (boolean): Include position details when true.

**Realm**

`Shared`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Output item info while debugging spawn issues
item:print(true)
```

---

### printData

**Purpose**

Debug helper that prints all stored item data.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Dump all stored data to the console
item:printData()
```

---

### addQuantity

**Purpose**

Increases the stored quantity for this item instance.

**Parameters**

* `quantity` (number): Amount to add.

* `receivers` (Player|nil): Who to network the change to.

* `noCheckEntity` (boolean): Skip entity network update.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Combine stacks from a loot drop and notify the owner
item:addQuantity(5, {player})
player:notifyLocalized("item_added", item.name, 5)
```

---

### setQuantity

**Purpose**

Sets the current stack quantity and replicates the change.

**Parameters**

* `quantity` (number): New amount to store.

* `receivers` (Player|nil): Recipients to send updates to.

* `noCheckEntity` (boolean): Skip entity updates when true.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Set quantity to 1 after splitting the stack
item:setQuantity(1, nil, true)
```

---

### getName

**Purpose**

Returns the display name of this item.

On the client this value is localized.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `string`: Item name.

**Example**

```lua
-- Inform the player which item they found
client:ChatPrint(string.format("Picked up: %s", item:getName()))
```

---

### getDesc

**Purpose**

Retrieves the description text for this item.

**Parameters**

* None

**Realm**

`Shared`

**Returns**

* `string`: Item description.

**Example**

```lua
-- Display a tooltip describing the item
tooltip:AddRowAfter("name", "desc"):SetText(item:getDesc())
```

---

### removeFromInventory

**Purpose**

Removes this item from its inventory without deleting it when `preserveItem` is true.

**Parameters**

* `preserveItem` (boolean): Keep the item saved in the database.

**Realm**

`Server`

**Returns**

* `Deferred`: Resolves when the item has been removed.

**Example**

```lua
-- Unequip and drop the item while keeping it saved
item:removeFromInventory(true):next(function()
    client:ChatPrint("Item unequipped")
end)
```

---

### delete

**Purpose**

Deletes this item from the database after destroying it.

**Parameters**

* None

**Realm**

`Server`

**Returns**

* `Deferred`: Resolves when deletion completes.

**Example**

```lua
-- Permanently remove the item from the database
item:delete():next(function()
    print("Item purged")
end)
```

---

### remove

**Purpose**

Destroys the item's entity then removes and deletes it from its inventory.

**Parameters**

* None

**Realm**

`Server`

**Returns**

* `Deferred`: Resolves when the item has been removed.

**Example**

```lua
-- Remove the item from the world and database
item:remove():next(function()
    print("Removed and deleted")
end)
```

---

### destroy

**Purpose**

Broadcasts deletion of this item and removes it from memory.

**Parameters**

* None

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Instantly delete the item across the network
item:destroy()
```

---

### onDisposed

**Purpose**

Callback executed after the item is destroyed.

**Parameters**

* None

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
function ITEM:onDisposed()
    print(self:getName() .. " was cleaned up")
end
```

---

### getEntity

**Purpose**

Finds the entity spawned for this item, if any.

**Parameters**

* None

**Realm**

`Server`

**Returns**

* `Entity|nil`: The world entity representing the item.

**Example**

```lua
-- Grab the world entity to modify it
local ent = item:getEntity()
if IsValid(ent) then
    ent:SetColor(Color(255, 0, 0))
end
```

---

### spawn

**Purpose**

Creates a world entity for this item at the specified position.

If no angle is provided it will spawn upright using `angle_zero`.

**Parameters**

* `position` (Vector|Player): Drop position or player dropping the item.

* `angles` (Angle|nil): Orientation for the entity.

**Realm**

`Server`

**Returns**

* `Entity|nil`: The created entity if successful.

**Example**

```lua
-- Drop the item at the player's feet with a random yaw
local ent = item:spawn(client:getItemDropPos(), Angle(0, math.random(0, 360), 0))
if IsValid(ent) then
    ent:SetOwner(client)
end
```

---

### transfer

**Purpose**

Moves the item to another inventory, optionally bypassing access checks.

**Parameters**

* `newInventory` (Inventory): Destination inventory.

* `bBypass` (boolean): Skip permission checking.

**Realm**

`Server`

**Returns**

* `boolean`: True if the transfer was initiated.

**Example**

```lua
-- Move the item into another container
item:transfer(targetInv):next(function()
    print("Transferred successfully")
end)
```

---

### onInstanced

**Purpose**

Called when a new instance of this item is created.

**Parameters**

* `invID` (number): Inventory ID the item belongs to or `NULL` when not placed in one.

* `x` (number): Grid X coordinate where the item spawned.

* `y` (number): Grid Y coordinate where the item spawned.

* `item` (Item): The newly created item instance.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
function ITEM:onInstanced(invID, x, y, newItem)
    print(string.format(
        "Item %s placed at %d,%d in inv %s",
        newItem.uniqueID,
        x,
        y,
        tostring(invID)
    ))
end
```

---

### onSync

**Purpose**

Runs after this item is networked to `recipient`.

**Parameters**

* `recipient` (Player|nil): Player who received the data, or `nil` when broadcast.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
function ITEM:onSync(ply)
    print("Sent item to", IsValid(ply) and ply:Name() or "all clients")
end
```

---

### onRemoved

**Purpose**

Executed after the item is permanently removed.

**Parameters**

* None

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
function ITEM:onRemoved()
    print(self.uniqueID .. " permanently deleted")
end
```

---

### onRestored

**Purpose**

Called when the item is restored from the database.

**Parameters**

* `inventory` (Inventory|nil): Inventory the item belongs to when loaded, if any.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
function ITEM:onRestored(inv)
    print(self:getName() .. " loaded from the database")
    if inv then
        print("Loaded from inventory", inv.id)
    end
end
```

---

### sync

**Purpose**

Sends this item's data to a player or broadcasts to all.

**Parameters**

* `recipient` (Player|nil): Target player or `nil` for broadcast.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Resend the item data to a specific player
item:sync(player)
```

---

### setData

**Purpose**

Sets a data field on the item and optionally networks and saves it.

**Parameters**

* `key` (string): Data key to modify.

* `value` (any): New value to store.

* `receivers` (Player|nil): Who to send the update to.

* `noSave` (boolean): Avoid saving to the database.

* `noCheckEntity` (boolean): Skip updating the world entity.

**Realm**

`Server`

**Returns**

* `nil`: This function does not return a value.

**Example**

```lua
-- Mark the item as legendary and notify the owner
item:setData("rarity", "legendary", player)
```

---

### interact

**Purpose**

Processes an interaction action performed by `client` on this item.

**Parameters**

* `action` (string): Identifier of the interaction.

* `client` (Player): Player performing the action.

* `entity` (Entity|nil): Entity used for the interaction.

* `data` (table|nil): Extra data passed to the hooks.

**Realm**

`Server`

**Returns**

* `boolean`: True if the interaction succeeded.

**Example**

```lua
-- Trigger the "use" interaction from code
item:interact("use", client, nil)
```

---
