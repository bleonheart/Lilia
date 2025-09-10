# Flags Library

This page documents the functions for working with player and character flags.

---

## Overview

The flags library (`lia.flag`) provides a system for managing player and character flags in the Lilia framework. Flags are single-character identifiers that grant specific permissions or abilities to players. The library handles flag registration, processing, and provides UI integration for displaying flag information to players.

---

### lia.flag.add

**Purpose**

Registers a new flag with a description and optional callback function.

**Parameters**

* `flag` (*string*): The single-character flag identifier.
* `desc` (*string*): The description of what the flag does.
* `callback` (*function*, optional): Callback function called when flag is given/removed.

**Realm**

Shared.

**Example Usage**

```lua
-- Add a simple flag with description
lia.flag.add("A", "flagAdminAccess")

-- Add a flag with callback function
lia.flag.add("W", "flagWeaponAccess", function(client, isGiven)
    if isGiven then
        client:Give("weapon_pistol")
    else
        client:StripWeapon("weapon_pistol")
    end
end)

-- Add a flag for building access
lia.flag.add("B", "flagBuildAccess", function(client, isGiven)
    if isGiven then
        client:SetNWBool("CanBuild", true)
    else
        client:SetNWBool("CanBuild", false)
    end
end)
```

### lia.flag.onSpawn

**Purpose**

Processes all flags for a client when they spawn, executing callbacks for active flags.

**Parameters**

* `client` (*Player*): The client to process flags for.

**Realm**

Server.

**Example Usage**

```lua
-- This function is automatically called when a player spawns
-- It processes both character flags and player flags
-- Example of how it works internally:
local flags = client:getFlags() .. client:getFlags("player")
-- Processes each flag and calls their callbacks
```

### lia.flag.list

**Purpose**

A table containing all registered flags and their data.

**Returns**

* `flagList` (*table*): Table with flag characters as keys and flag data as values.

**Realm**

Shared.

**Example Usage**

```lua
-- Access the flag list
for flag, data in pairs(lia.flag.list) do
    print("Flag: " .. flag .. " - " .. (data.desc or "No description"))
end

-- Check if a flag exists
if lia.flag.list["A"] then
    print("Admin flag is registered")
end

-- Get flag description
local adminFlag = lia.flag.list["A"]
if adminFlag then
    print("Admin flag description: " .. adminFlag.desc)
end
```

## Built-in Flags

The following flags are automatically registered by the Lilia framework:

### Character Flags

- **C** - `flagSpawnVehicles`: Allows spawning vehicles
- **z** - `flagSpawnSweps`: Allows spawning SWEPs (Single Weapon Entities)
- **E** - `flagSpawnSents`: Allows spawning SENTs (Scripted Entities)
- **L** - `flagSpawnEffects`: Allows spawning effects
- **r** - `flagSpawnRagdolls`: Allows spawning ragdolls
- **e** - `flagSpawnProps`: Allows spawning props
- **n** - `flagSpawnNpcs`: Allows spawning NPCs
- **Z** - `flagInviteToYourFaction`: Allows inviting players to your faction
- **X** - `flagInviteToYourClass`: Allows inviting players to your class

### Player Flags

- **p** - `flagPhysgun`: Gives/removes physgun weapon
- **t** - `flagToolgun`: Gives/removes toolgun weapon

## Example Usage

```lua
-- Register a custom flag for VIP access
lia.flag.add("V", "flagVIPAccess", function(client, isGiven)
    if isGiven then
        -- Give VIP benefits
        client:SetNWBool("IsVIP", true)
        client:ChatPrint("You have VIP access!")
    else
        -- Remove VIP benefits
        client:SetNWBool("IsVIP", false)
        client:ChatPrint("VIP access removed.")
    end
end)

-- Register a flag for special chat access
lia.flag.add("S", "flagSpecialChat", function(client, isGiven)
    if isGiven then
        client:SetNWBool("CanUseSpecialChat", true)
    else
        client:SetNWBool("CanUseSpecialChat", false)
    end
end)

-- Register a flag for admin commands
lia.flag.add("M", "flagModeratorCommands", function(client, isGiven)
    if isGiven then
        client:SetNWBool("CanUseModCommands", true)
    else
        client:SetNWBool("CanUseModCommands", false)
    end
end)
```

## Flag Processing

Flags are processed automatically when players spawn. The system:

1. Combines character flags and player flags
2. Removes duplicates to avoid processing the same flag multiple times
3. Calls the callback function for each unique flag
4. Passes `true` to the callback when the flag is given, `false` when removed

## UI Integration

The flags library automatically integrates with the Lilia information system, providing:

- A "Character Flags" page showing all character flags
- A "Player Flags" page showing all player flags
- Visual indicators (checkboxes) showing which flags are active
- Search functionality to find specific flags
- Localized descriptions for all flags
