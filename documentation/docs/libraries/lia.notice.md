# lia.notice

## Overview
The `lia.notice` library provides a notification system for Lilia, allowing the gamemode to display messages to players. It supports both server-side and client-side notifications with automatic positioning and timing.

## Functions

### lia.notices.notify
**Purpose**: Displays a notification message to players.

**Parameters**:
- `message` (string): Message to display
- `recipient` (Player): Target player (optional, broadcasts if nil)

**Returns**: None

**Realm**: Server/Client

**Example Usage**:
```lua
-- Server-side: Notify all players
lia.notices.notify("Server restarting in 5 minutes!")

-- Server-side: Notify specific player
lia.notices.notify("Welcome to the server!", player)

-- Client-side: Display notification
lia.notices.notify("Item picked up!")

-- Server-side: Notify with formatted message
lia.notices.notify("Player " .. player:Name() .. " joined the server!")
```

### lia.notices.notifyLocalized
**Purpose**: Displays a localized notification message to players.

**Parameters**:
- `key` (string): Localization key
- `recipient` (Player): Target player (optional, broadcasts if nil)
- `...` (any): Format arguments for the localized string

**Returns**: None

**Realm**: Server/Client

**Example Usage**:
```lua
-- Server-side: Notify with localization
lia.notices.notifyLocalized("welcomeMessage", player)

-- Server-side: Notify with format arguments
lia.notices.notifyLocalized("playerJoined", nil, player:Name())

-- Server-side: Notify specific player with arguments
lia.notices.notifyLocalized("itemPickedUp", player, "Pistol", 1)

-- Client-side: Display localized notification
lia.notices.notifyLocalized("inventoryFull")

-- Client-side: Display with format arguments
lia.notices.notifyLocalized("moneyReceived", 1000)
```