# Discord Library

This page documents the functions for Discord integration and webhook messaging.

---

## Overview

The Discord library (`lia.discord`) provides integration with Discord webhooks for sending rich embed messages from the server to Discord channels. It supports automatic fallbacks between different HTTP methods and provides hooks for customization and monitoring.

---

### lia.discord.relayMessage

**Purpose**

Sends a rich embed message to a Discord webhook for server notifications and logging.

**Parameters**

* `embed` (*table*): The embed data to send to Discord with the following optional fields:
  * `title` (*string*): The embed title (defaults to localized "Lilia" text).
  * `description` (*string*): The embed description.
  * `color` (*number*): The embed color as a decimal number (defaults to 7506394).
  * `timestamp` (*string*): ISO 8601 timestamp (defaults to current time).
  * `footer` (*table*): Footer object with `text` and optional `icon_url`.
  * `author` (*table*): Author object with `name` and optional `icon_url`.
  * `fields` (*table*): Array of field objects with `name`, `value`, and optional `inline`.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Send a simple notification
    lia.discord.relayMessage({
        title = "Player Joined",
        description = player:Name() .. " has joined the server!",
        color = 65280 -- Green color
    })

    -- Send a detailed embed with fields
    lia.discord.relayMessage({
        title = "Admin Action",
        description = "An administrative action was performed",
        color = 16711680, -- Red color
        fields = {
            {
                name = "Admin",
                value = admin:Name(),
                inline = true
            },
            {
                name = "Action",
                value = "Banned player",
                inline = true
            },
            {
                name = "Target",
                value = target:Name(),
                inline = true
            }
        },
        footer = {
            text = "Server Administration"
        }
    })

    -- Send error notification
    lia.discord.relayMessage({
        title = "Server Error",
        description = "An error occurred: " .. errorMessage,
        color = 16776960, -- Yellow color
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    })
end
```

---

## Configuration

The Discord library requires configuration of the webhook URL:

```lua
-- Set the Discord webhook URL
lia.discord.webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"
```

---

## Hooks

The Discord library provides several hooks for customization:

### DiscordRelaySend
Called before sending a message to Discord. Allows modification of the embed data.

**Parameters:**
- `embed` (*table*): The embed data being sent

### DiscordRelayUnavailable
Called when the chttp binary module is not available and HTTP fallback is disabled.

### DiscordRelayed
Called after successfully sending a message to Discord.

**Parameters:**
- `embed` (*table*): The embed data that was sent

---

## HTTP Methods

The library automatically chooses the best available HTTP method:

1. **CHTTP (Preferred)**: Uses the chttp binary module for better performance and reliability
2. **HTTP Fallback**: Uses Garry's Mod's built-in HTTP library when chttp is unavailable

The library will automatically detect which method to use and fall back gracefully.

---

## Error Handling

The library includes built-in error handling:

- Validates webhook URL before sending
- Handles HTTP request failures gracefully
- Prints error messages to server console for debugging

---

## Example Integration

```lua
if SERVER then
    -- Player join notification
    hook.Add("PlayerInitialSpawn", "DiscordPlayerJoin", function(ply)
        lia.discord.relayMessage({
            title = "Player Joined",
            description = ply:Name() .. " (" .. ply:SteamID() .. ") has joined the server",
            color = 65280,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })
    end)

    -- Admin command logging
    hook.Add("liaCommandRan", "DiscordCommandLog", function(client, command, args)
        lia.discord.relayMessage({
            title = "Admin Command",
            description = "Command executed by " .. client:Name(),
            color = 16776960,
            fields = {
                {
                    name = "Command",
                    value = command,
                    inline = true
                },
                {
                    name = "Arguments",
                    value = table.concat(args, " "),
                    inline = true
                }
            }
        })
    end)
end
```