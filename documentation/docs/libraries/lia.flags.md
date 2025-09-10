# lia.flags

## Overview
The `lia.flags` library provides a flag system for Lilia that allows players to have special permissions and abilities. Flags are single-character identifiers that grant specific privileges to players.

## Functions

### lia.flag.add
**Purpose**: Adds a new flag to the flag system with an optional callback function.

**Parameters**:
- `flag` (string): Single character flag identifier
- `desc` (string): Description of what the flag does
- `callback` (function): Optional callback function called when flag is given/removed

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Add a basic flag without callback
lia.flag.add("A", "flagAdminAccess")

-- Add a flag with callback for weapon giving
lia.flag.add("W", "flagWeaponAccess", function(client, isGiven)
    if isGiven then
        client:Give("weapon_pistol")
        client:SelectWeapon("weapon_pistol")
    else
        client:StripWeapon("weapon_pistol")
    end
end)

-- Add a flag with callback for vehicle spawning
lia.flag.add("V", "flagVehicleAccess", function(client, isGiven)
    if isGiven then
        client:SetNWBool("CanSpawnVehicles", true)
    else
        client:SetNWBool("CanSpawnVehicles", false)
    end
end)
```

### lia.flag.onSpawn
**Purpose**: Processes all flags for a client when they spawn (Server only).

**Parameters**:
- `client` (Player): The client to process flags for

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- This is typically called automatically when a player spawns
-- But you can call it manually if needed
local client = Player(1)
if client then
    lia.flag.onSpawn(client)
end

-- Hook example for custom spawn handling
hook.Add("PlayerSpawn", "CustomFlagHandling", function(client)
    -- Do custom spawn logic
    lia.flag.onSpawn(client)
end)
```