# lia.discord

## Overview
The `lia.discord` library provides Discord webhook integration for Lilia, allowing the gamemode to send messages and embeds to Discord channels through webhooks.

## Functions

### lia.discord.relayMessage
**Purpose**: Sends a message embed to a Discord webhook.

**Parameters**:
- `embed` (table): Discord embed object containing message data

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Send a simple message to Discord
lia.discord.relayMessage({
    title = "Player Joined",
    description = "A new player has joined the server!",
    color = 65280, -- Green color
    fields = {
        {
            name = "Player Name",
            value = "John Doe",
            inline = true
        },
        {
            name = "Steam ID",
            value = "76561198000000000",
            inline = true
        }
    }
})

-- Send a warning message
lia.discord.relayMessage({
    title = "Admin Action",
    description = "An administrator has performed an action",
    color = 16776960, -- Yellow color
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    footer = {
        text = "Lilia Admin System"
    }
})

-- Send an error message
lia.discord.relayMessage({
    title = "Server Error",
    description = "A critical error has occurred",
    color = 16711680, -- Red color
    fields = {
        {
            name = "Error",
            value = "Database connection failed",
            inline = false
        }
    }
})
```