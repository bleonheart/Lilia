# lia.net

## Overview
The `lia.net` library provides networking functionality for Lilia, including custom network message handling, big table transmission, and global variable synchronization.

## Functions

### lia.net.register
**Purpose**: Registers a custom network message handler (Shared).

**Parameters**:
- `name` (string): Network message name
- `callback` (function): Callback function to handle the message

**Returns**: Boolean indicating success

**Realm**: Shared

**Example Usage**:
```lua
-- Register a network message
lia.net.register("myMessage", function(data)
    print("Received data:", data)
end)

-- Register with error handling
local success = lia.net.register("playerData", function(data)
    if data and data.name then
        print("Player name:", data.name)
    end
end)

if not success then
    print("Failed to register network message")
end
```

### lia.net.send
**Purpose**: Sends a custom network message (Shared).

**Parameters**:
- `name` (string): Network message name
- `target` (Player|table|nil): Target player(s) or nil for broadcast
- `...` (any): Arguments to send

**Returns**: Boolean indicating success

**Realm**: Shared

**Example Usage**:
```lua
-- Send to specific player
lia.net.send("myMessage", player, "Hello", 123)

-- Send to multiple players
local players = {player1, player2, player3}
lia.net.send("myMessage", players, "Group message")

-- Broadcast to all players
lia.net.send("myMessage", nil, "Broadcast message")

-- Send with error handling
local success = lia.net.send("playerData", player, {name = "John", level = 50})
if not success then
    print("Failed to send network message")
end
```

### lia.net.readBigTable
**Purpose**: Sets up a handler for receiving large tables over the network (Shared).

**Parameters**:
- `netStr` (string): Network string name
- `callback` (function): Callback function for when table is received

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Set up big table receiver
lia.net.readBigTable("liaPlayerData", function(data)
    if data then
        print("Received big table with", table.Count(data), "entries")
        -- Process the data
    end
end)

-- Use in module initialization
lia.net.readBigTable("liaModuleData", function(data)
    if data and data.modules then
        for name, moduleData in pairs(data.modules) do
            print("Module:", name, "Version:", moduleData.version)
        end
    end
end)
```

### lia.net.writeBigTable
**Purpose**: Sends a large table over the network in chunks (Server only).

**Parameters**:
- `targets` (Player|table|nil): Target player(s) or nil for all players
- `netStr` (string): Network string name
- `tbl` (table): Table to send
- `chunkSize` (number): Size of each chunk (optional)

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Send big table to specific player
local bigData = {
    players = {},
    items = {},
    -- ... lots of data
}
lia.net.writeBigTable(player, "liaPlayerData", bigData)

-- Send to multiple players
local players = {player1, player2, player3}
lia.net.writeBigTable(players, "liaModuleData", moduleData)

-- Send to all players
lia.net.writeBigTable(nil, "liaGlobalData", globalData)

-- Send with custom chunk size
lia.net.writeBigTable(player, "liaLargeData", largeTable, 4096)
```
