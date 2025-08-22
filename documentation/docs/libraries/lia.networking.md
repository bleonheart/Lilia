# Networking Library

This page documents the networking library functions that handle communication between server and clients, including network variables, message passing, and large data transfers.

---

## Overview

The networking library provides a comprehensive system for synchronizing data between the server and clients. It includes:

- **Network Variables**: Global variables stored in `lia.net.globals` that are automatically synchronized across all clients
- **Message System**: Custom network message registration and sending with automatic serialization
- **Big Table Transfer**: Chunked transfer of large tables with compression and flow control
- **Type Safety**: Automatic validation to prevent sending invalid data types (functions, etc.)

All networked data is automatically re-sent to players when they spawn via `PlayerInitialSpawn`. Values **must not** contain functions or tables that contain functions, as they cannot be serialized.

---

## Core Functions

### lia.net.register

**Purpose**

Registers a network message handler that will be called when a message with the specified name is received.

**Parameters**

* `name` (*string*): Network message identifier to register.

* `callback` (*function*): Function to call when the message is received. Server signature: `callback(client, ...)`, Client signature: `callback(...)`.

**Realm**

`Shared`

**Returns**

* `boolean`: `true` if registration was successful, `false` if the arguments were invalid.

**Example Usage**

```lua
-- Register a simple message handler
lia.net.register("MyCustomMessage", function(client, data)
    if SERVER then
        print("Server received message from", client:Name(), "with data:", data)
    else
        print("Client received message with data:", data)
    end
end)
```

---

### lia.net.send

**Purpose**

Sends a network message to specified targets with automatic serialization of arguments.

**Parameters**

* `name` (*string*): Network message identifier to send.

* `target` (*Player | Player[] | nil*): Recipient(s). `nil` broadcasts to all players (server only), sends to server (client only).

* `...` (*any*): Variable number of arguments to send. Must be serializable.

**Realm**

`Shared`

**Returns**

* `boolean`: `true` if the message was sent successfully, `false` if there was an error.

**Example Usage**

```lua
-- Server: Send to specific player
lia.net.send("MyCustomMessage", player, "Hello", {key = "value"})

-- Server: Broadcast to all players
lia.net.send("MyCustomMessage", nil, "Broadcast message")

-- Client: Send to server
lia.net.send("MyCustomMessage", nil, "Message from client")
```

---

## Big Table Functions

### lia.net.readBigTable

**Purpose**

Registers a handler that rebuilds large tables sent over the network in multiple compressed chunks. Clients acknowledge each chunk so the sender can throttle transmission.

**Parameters**

* `netStr` (*string*): Network message identifier to listen for.

* `callback` (*function*): Function invoked when the table is fully received. Server signature: `callback(ply, tbl)`, Client signature: `callback(tbl)`.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- Both server and client: install receiver
lia.net.readBigTable("MyData", function(a, b)
    if SERVER then
        local ply, data = a, b
        print("Server received table from", ply, data)
    else
        local data = a
        PrintTable(data)
    end
end)
```

---

### lia.net.writeBigTable

**Purpose**

Splits a table into compressed chunks and streams it to one or more players. Used in conjunction with `lia.net.readBigTable`. Aborts if the table is not serializable or cannot be compressed.

**Parameters**

* `targets` (*Player | Player[] | nil*): Recipient(s); `nil` streams to all human players.

* `netStr` (*string*): Network message identifier.

* `tbl` (*table*): Data to send. Must be JSON-serializable (no functions, userdata, etc.).

* `chunkSize` (*number | nil*): Optional bytes per chunk (default `2048`, clamped to the range `256`–`4096`).

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
local data = {foo = "bar", numbers = {1, 2, 3}}

-- Broadcast to everyone
lia.net.writeBigTable(nil, "MyData", data)

-- Send to one player with smaller chunks
lia.net.writeBigTable(player, "MyData", data, 1024)

-- Send to multiple players
lia.net.writeBigTable({player1, player2}, "MyData", data)
```

---

## Network Variables

### setNetVar

**Purpose**

Stores a value in `lia.net.globals` and broadcasts the change, optionally restricting it to specific receivers. Disallowed types are rejected, and no network message is sent if the value has not changed. The `NetVarChanged` hook is fired after successful updates.

**Parameters**

* `key` (*string*): Name of the variable.

* `value` (*any*): Value to store. Must be serializable (no functions).

* `receiver` (*Player | Player[] | nil*): Target player(s). `nil` broadcasts to everyone.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- Start a new round and store the winner
local nextRound = getNetVar("round", 0) + 1
setNetVar("round", nextRound)

local champion = DetermineWinner()

-- Only the winner receives this variable
setNetVar("last_winner", champion, champion)

-- Send to multiple players
setNetVar("team_score", 100, {player1, player2})

hook.Run("RoundStarted", nextRound)
```

---

### getNetVar

**Purpose**

Retrieves a value from `lia.net.globals`, returning a default if the key is unset.

**Parameters**

* `key` (*string*): Variable name.

* `default` (*any*): Fallback value if unset.

**Realm**

`Shared`

**Returns**

* *any*: Stored value or the supplied default.

**Example Usage**

```lua
-- Inform new players of the current round and previous champion
hook.Add("PlayerInitialSpawn", "ShowRound", function(ply)
    local round = getNetVar("round", 0)
    ply:ChatPrint(("Current round: %s"):format(round))

    local lastWinner = getNetVar("last_winner")
    if IsValid(lastWinner) then
        ply:ChatPrint(("Last round won by %s"):format(lastWinner:Name()))
    end
end)

-- Use in calculations
local score = getNetVar("team_score", 0) + 10
```

---

## Hooks

### NetVarChanged

**Purpose**

Called when a network variable is changed via `setNetVar`.

**Parameters**

* `entity` (*Entity | nil*): The entity whose netvar was changed (always `nil` for global netvars).

* `key` (*string*): The name of the changed variable.

* `oldValue` (*any*): The previous value.

* `newValue` (*any*): The new value.

**Realm**

`Shared`

**Example Usage**

```lua
hook.Add("NetVarChanged", "OnNetVarChanged", function(entity, key, oldValue, newValue)
    if not entity then
        print("Global netvar '" .. key .. "' changed from", oldValue, "to", newValue)
    end
end)
```

---
