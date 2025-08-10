# Entity Meta

Entities in Garry's Mod may represent props, items, and interactive objects.

This reference describes utility functions added to entity metatables for easier classification and management.

---

## Overview

The entity-meta library extends Garry's Mod entities with helpers for detection, door access, persistence, and networked variables.
Using these functions ensures consistent behavior when handling game objects across Lilia.

---

### isProp

**Purpose**

Checks if the entity is a physics prop.

**Parameters**

* None

**Returns**

* `boolean`: `true` when the entity's class is `prop_physics`.

**Realm**

`Shared`

**Example Usage**

```lua
if ent:isProp() then
    ent:TakeDamage(50)
end
```

---

### isItem

**Purpose**

Checks if the entity is an item entity (`lia_item`).

**Parameters**

* None

**Returns**

* `boolean`: `true` if the entity represents an item.

**Realm**

`Shared`

**Example Usage**

```lua
if ent:isItem() then
    lia.item.pickup(client, ent)
end
```

---

### isMoney

**Purpose**

Checks if the entity is a money entity (`lia_money`).

**Parameters**

* None

**Returns**

* `boolean`: `true` if the entity represents money.

**Realm**

`Shared`

**Example Usage**

```lua
if ent:isMoney() then
    char:addMoney(ent:getAmount())
end
```

---

### isSimfphysCar

**Purpose**

Determines whether this entity is a simfphys or LVS vehicle.

**Parameters**

* None

**Returns**

* `boolean`: `true` if the entity's class or base matches known simfphys classes or it contains the `IsSimfphyscar`/`LVS` flag.

**Realm**

`Shared`

**Example Usage**

```lua
if ent:isSimfphysCar() then
    print("Simfphys vehicle detected")
end
```

---

### isLiliaPersistent

**Purpose**

Checks if the entity should persist across sessions in Lilia.

**Parameters**

* None

**Returns**

* `boolean`: `true` if the entity has persistence flags or `GetPersistent()` returns `true`.

**Realm**

`Shared`

**Example Usage**

```lua
if ent:isLiliaPersistent() then
    -- Entity will be saved between map resets
end
```

---

### checkDoorAccess

**Purpose**

Checks if a player has a given access level on a door.

**Parameters**

* `client` (`Player`): Player to check.
* `access` (`number`, optional): Access level to test, defaults to `DOOR_GUEST`.

**Returns**

* `boolean`: `true` if the player may access the door.

**Realm**

`Shared`

**Example Usage**

```lua
if not door:checkDoorAccess(client, DOOR_GUEST) then
    client:notifyLocalized("doorLocked")
end
```

---

### keysOwn

**Purpose**

Assigns ownership of a vehicle entity to the provided player using CPPI and network variables.

**Parameters**

* `client` (`Player`): New owner.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Shared`

**Example Usage**

```lua
car:keysOwn(client)
```

---

### keysLock

**Purpose**

Locks the entity if it is a vehicle by firing the `lock` input. Does nothing for non-vehicles.

**Parameters**

* None

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Shared`

**Example Usage**

```lua
car:keysLock()
```

---

### keysUnLock

**Purpose**

Unlocks the entity if it is a vehicle by firing the `unlock` input. Does nothing for non-vehicles.

**Parameters**

* None

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Shared`

**Example Usage**

```lua
car:keysUnLock()
```

---

### getDoorOwner

**Purpose**

Retrieves the CPPI owner of a vehicle, if available. Returns `nil` for non-vehicles or when no CPPI owner exists.

**Parameters**

* None

**Returns**

* `Player|nil`: The owner of the vehicle. Returns `nil` if the entity is not a vehicle or owner information is unavailable.

**Realm**

`Shared`

**Example Usage**

```lua
local owner = car:getDoorOwner()
if owner then
    print("Owned by", owner:Name())
end
```

---

### isLocked

**Purpose**

Checks the networked `locked` state of the entity.

**Parameters**

* None

**Returns**

* `boolean`: `true` if the entity is locked.

**Realm**

`Shared`

**Example Usage**

```lua
if door:isLocked() then
    DrawLockedIcon(door)
end
```

---

### isDoorLocked

**Purpose**

Checks the internal `m_bLocked` flag for door entities, falling back to the `locked` field if necessary.

**Parameters**

* None

**Returns**

* `boolean`: `true` if the door reports itself as locked; otherwise `false`.

**Realm**

`Shared`

**Example Usage**

```lua
if door:isDoorLocked() then
    door:EmitSound("doors/door_locked2.wav")
end
```

---

### getEntItemDropPos

**Purpose**

Calculates a safe drop position in front of the entity's eyes.

**Parameters**

* `offset` (`number`, optional): Distance to trace forward. Defaults to `64` units.

**Returns**

* `Vector`, `Angle`: The drop position and surface normal angle. Returns `Vector(0, 0, 0)` and `Angle(0, 0, 0)` if the entity is invalid.

**Realm**

`Shared`

**Example Usage**

```lua
local pos, ang = ent:getEntItemDropPos(16)
lia.item.spawn("item_water", pos, ang)
```

---

### isNearEntity

**Purpose**

Checks for nearby entities within a radius. If `otherEntity` is supplied, the function returns `true` when that entity **or any entity of the same class** is within range. Without `otherEntity`, any entity of the same class satisfies the check.

**Parameters**

* `radius` (`number`, optional): Search radius in units. Defaults to `96`.
* `otherEntity` (`Entity`, optional): Specific entity to look for.

**Returns**

* `boolean`: `true` if a matching entity is nearby.

**Realm**

`Shared`

**Example Usage**

```lua
if ent:isNearEntity(128, otherChest) then
    client:notifyLocalized("chestTooClose")
end
```

---

### GetCreator

**Purpose**

Returns the stored creator of the entity.

**Parameters**

* None

**Returns**

* `Player|nil`: Creator player if stored.

**Realm**

`Shared`

**Example Usage**

```lua
local creator = ent:GetCreator()
if IsValid(creator) then
    creator:notifyLocalized("propRemoved")
end
```

---

### SetCreator

**Purpose**

Stores the creator player on the entity for later retrieval.

**Parameters**

* `client` (`Player`): Creator of the entity.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
ent:SetCreator(client)
```

---

### sendNetVar

**Purpose**

Sends a networked variable to a specific player or broadcasts it to all clients.

**Parameters**

* `key` (`string`): Identifier of the variable.
* `receiver` (`Player|nil`, optional): Player to send to. Broadcasts if omitted.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
ent:sendNetVar("doorState")
```

---

### clearNetVars

**Purpose**

Clears all network variables on this entity and notifies clients to remove them.

**Parameters**

* `receiver` (`Player|nil`, optional): Receiver to notify. Broadcasts if omitted.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
ent:clearNetVars(client)
```

---

### removeDoorAccessData

**Purpose**

Removes all stored door access information and informs connected players.

**Parameters**

* None

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
ent:removeDoorAccessData()
```

---

### setLocked

**Purpose**

Sets the networked `locked` state of the entity.

**Parameters**

* `state` (`boolean`): New locked state.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
door:setLocked(true)
```

---

### setKeysNonOwnable

**Purpose**

Marks the entity as non-ownable, preventing players from purchasing it.

**Parameters**

* `state` (`boolean`): Whether the entity should be non-ownable.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
ent:setKeysNonOwnable(true)
```

---

### isDoor *(Server)*

**Purpose**

Checks if the entity's class name begins with a known door prefix such as `prop_door`, `func_door`, `func_door_rotating`, or `door_` (case-insensitive).

**Parameters**

* None

**Returns**

* `boolean`: `true` if the entity is recognized as a door.

**Realm**

`Server`

**Example Usage**

```lua
if ent:isDoor() then
    print("This is a door!")
end
```

---

### getDoorPartner *(Server)*

**Purpose**

Returns the door entity linked as this one's partner via `liaPartner`.

**Parameters**

* None

**Returns**

* `Entity|nil`: Partner door entity.

**Realm**

`Server`

**Example Usage**

```lua
local partner = ent:getDoorPartner()
if IsValid(partner) then
    partner:setLocked(false)
end
```

---

### setNetVar

**Purpose**

Updates a networked variable and notifies recipients. Triggers the `NetVarChanged` hook when the value changes.

**Parameters**

* `key` (`string`): Variable name.
* `value` (`any`): Value to store.
* `receiver` (`Player|nil`, optional): Player to send the update to. Broadcasts if omitted.

**Returns**

* `nil`: This function does not return a value.

**Realm**

`Server`

**Example Usage**

```lua
ent:setNetVar("locked", true)
```

---

### getNetVar *(Server)*

**Purpose**

Retrieves a stored networked variable or a default value.

**Parameters**

* `key` (`string`): Variable name.
* `default` (`any`): Value returned if the variable is not set.

**Returns**

* `any`: Stored value or the provided default.

**Realm**

`Server`

**Example Usage**

```lua
local locked = ent:getNetVar("locked", false)
```

---

### isDoor *(Client)*

**Purpose**

Client-side check if the entity's class name contains the substring `"door"` (case-sensitive).

**Parameters**

* None

**Returns**

* `boolean`: `true` if the class name contains "door".

**Realm**

`Client`

**Example Usage**

```lua
if ent:isDoor() then
    print("Door detected on client")
end
```

---

### getDoorPartner *(Client)*

**Purpose**

Attempts to find and cache the partner door for this entity.

**Parameters**

* None

**Returns**

* `Entity|nil`: The partner door entity, if found.

**Realm**

`Client`

**Example Usage**

```lua
local partner = ent:getDoorPartner()
if IsValid(partner) then
    partner:SetColor(Color(0, 255, 0))
end
```

---

### getNetVar *(Client)*

**Purpose**

Retrieves a networked variable for this entity on the client.

**Parameters**

* `key` (`string`): Variable name.
* `default` (`any`): Value returned if the variable is not set.

**Returns**

* `any`: Stored value or the provided default.

**Realm**

`Client`

**Example Usage**

```lua
local locked = ent:getNetVar("locked", false)
```

---
