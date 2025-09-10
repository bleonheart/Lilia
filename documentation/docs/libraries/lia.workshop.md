# lia.workshop

## Overview
The `lia.workshop` library provides functionality for managing Steam Workshop addons in the Lilia framework. It handles downloading, mounting, and tracking of Workshop content on both server and client sides.

## Functions

### lia.workshop.Add
**Purpose**  
Adds a Workshop addon ID to the server's list of required addons.

**Parameters**  
- `id` (string): The Workshop addon ID to add

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Add a specific Workshop addon to the server
lia.workshop.Add("123456789")
```

### lia.workshop.Gather
**Purpose**  
Gathers all Workshop addon IDs from various sources including mounted addons and module dependencies.

**Parameters**  
None

**Returns**  
table: A table containing all gathered Workshop addon IDs

**Realm**  
Server

**Example Usage**
```lua
-- Gather all Workshop addons and get the list
local addonIds = lia.workshop.Gather()
print("Found " .. table.Count(addonIds) .. " Workshop addons")
```

### lia.workshop.Send
**Purpose**  
Sends the current Workshop addon cache to a specific player.

**Parameters**  
- `ply` (Player): The player to send the addon list to

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Send Workshop addon list to a player
lia.workshop.Send(player.GetByID(1))
```

### lia.workshop.IsMounted
**Purpose**  
Checks if a Workshop addon is currently mounted on the client.

**Parameters**  
- `id` (string): The Workshop addon ID to check

**Returns**  
boolean: True if the addon is mounted, false otherwise

**Realm**  
Client

**Example Usage**
```lua
-- Check if a specific addon is mounted
if lia.workshop.IsMounted("123456789") then
    print("Addon is mounted")
else
    print("Addon is not mounted")
end
```

### lia.workshop.Enqueue
**Purpose**  
Adds a Workshop addon to the download queue for mounting.

**Parameters**  
- `id` (string): The Workshop addon ID to queue for download

**Returns**  
None

**Realm**  
Client

**Example Usage**
```lua
-- Queue an addon for download and mounting
lia.workshop.Enqueue("123456789")
```

### lia.workshop.ProcessQueue
**Purpose**  
Processes the Workshop addon download queue, downloading and mounting addons one by one.

**Parameters**  
None

**Returns**  
None

**Realm**  
Client

**Example Usage**
```lua
-- Process the download queue
lia.workshop.ProcessQueue()
```

### lia.workshop.hasContentToDownload
**Purpose**  
Checks if there are any Workshop addons that need to be downloaded.

**Parameters**  
None

**Returns**  
boolean: True if there are addons to download, false otherwise

**Realm**  
Client

**Example Usage**
```lua
-- Check if there are addons to download
if lia.workshop.hasContentToDownload() then
    print("There are addons that need to be downloaded")
end
```

### lia.workshop.mountContent
**Purpose**  
Opens a UI dialog to allow the player to download and mount missing Workshop content.

**Parameters**  
None

**Returns**  
None

**Realm**  
Client

**Example Usage**
```lua
-- Open the Workshop content downloader
lia.workshop.mountContent()
```