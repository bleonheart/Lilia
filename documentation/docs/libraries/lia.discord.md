# Discord Library

This page documents the functions for working with Discord webhook integration.

---

## Overview

The discord library (`lia.discord`) provides a system for sending formatted messages to Discord webhooks. It handles webhook configuration, message formatting, and supports both CHTTP and HTTP fallback methods for reliable message delivery. The library is commonly used for logging server events, player actions, and administrative notifications.

---

### lia.discord.relayMessage

**Purpose**

Sends a formatted embed message to the configured Discord webhook.

**Parameters**

* `embed` (*table*): A table containing embed data with fields:
  * `title` (*string*, *optional*): The embed title (defaults to "Lilia").
  * `color` (*number*, *optional*): The embed color as a decimal number (defaults to 7506394).
  * `timestamp` (*string*, *optional*): ISO 8601 timestamp (defaults to current time).
  * `footer` (*table*, *optional*): Footer object with text field.
  * `description` (*string*, *optional*): The embed description.
  * `fields` (*table*, *optional*): Array of field objects.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
-- Send a simple notification
lia.discord.relayMessage({
    title = "Player Joined",
    description = "A new player has joined the server!",
    color = 65280 -- Green color
})

-- Send a detailed embed with fields
lia.discord.relayMessage({
    title = "Admin Action",
    description = "An administrative action was performed",
    color = 16776960, -- Orange color
    fields = {
        {
            name = "Action",
            value = "Player banned",
            inline = true
        },
        {
            name = "Target",
            value = "PlayerName",
            inline = true
        },
        {
            name = "Reason",
            value = "Rule violation",
            inline = false
        }
    }
})

-- Send a server event notification
hook.Add("PlayerInitialSpawn", "DiscordSpawnNotify", function(ply)
    lia.discord.relayMessage({
        title = "Player Connected",
        description = ply:Name() .. " (" .. ply:SteamID() .. ") has joined the server",
        color = 3447003, -- Blue color
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    })
end)

-- Send error notifications
local function logError(message, stackTrace)
    lia.discord.relayMessage({
        title = "Server Error",
        description = "An error occurred on the server",
        color = 15158332, -- Red color
        fields = {
            {
                name = "Error Message",
                value = message:sub(1, 1024), -- Discord field limit
                inline = false
            },
            {
                name = "Stack Trace",
                value = stackTrace:sub(1, 1024),
                inline = false
            }
        }
    })
end
```