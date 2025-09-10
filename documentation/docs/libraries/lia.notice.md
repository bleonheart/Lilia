# Notice Library

This page documents the functions for working with notification systems and player messaging.

---

## Overview

The notice library (`lia.notices`) provides a comprehensive system for displaying notifications and messages to players within the Lilia framework. It handles both server-side broadcasting and client-side display of notifications with smooth animations and proper localization support. The library supports both raw text messages and localized messages with formatting.

---

### lia.notices.notify (Server)

**Purpose**

Sends a notification message to one or all players from the server.

**Parameters**

* `message` (*string*): The message text to send.
* `recipient` (*Player*, *optional*): The specific player to send the message to. If nil, broadcasts to all players.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
-- Send a message to all players
lia.notices.notify("Server is restarting in 5 minutes!")

-- Send a message to a specific player
lia.notices.notify("You have received a new item!", player)

-- Send admin notification
if player:IsAdmin() then
    lia.notices.notify("Admin command executed successfully!", player)
end

-- Send error notification
lia.notices.notify("Failed to save character data!", player)
```

---

### lia.notices.notifyLocalized (Server)

**Purpose**

Sends a localized notification message to one or all players from the server.

**Parameters**

* `key` (*string*): The localization key for the message.
* `recipient` (*Player|string*, *optional*): The specific player to send the message to, or additional argument if no recipient.
* `...` (*any*): Additional arguments for localization formatting.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
-- Send localized message to all players
lia.notices.notifyLocalized("serverRestartWarning", 5)

-- Send localized message to specific player
lia.notices.notifyLocalized("itemReceived", player, "Health Kit")

-- Send error message with player name
lia.notices.notifyLocalized("playerNotFound", admin, targetName)

-- Send success message with item count
lia.notices.notifyLocalized("itemsSold", player, itemCount, totalMoney)
```

---

### lia.notices.notify (Client)

**Purpose**

Displays a notification message to the local player.

**Parameters**

* `message` (*string*): The message text to display.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Display a simple notification
lia.notices.notify("Inventory updated!")

-- Display success notification
lia.notices.notify("Item crafted successfully!")

-- Display warning notification
lia.notices.notify("Warning: Low health!")

-- Display error notification
lia.notices.notify("Error: Invalid item!")
```

---

### lia.notices.notifyLocalized (Client)

**Purpose**

Displays a localized notification message to the local player.

**Parameters**

* `key` (*string*): The localization key for the message.
* `...` (*any*): Additional arguments for localization formatting.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Display localized notification
lia.notices.notifyLocalized("inventoryFull")

-- Display notification with formatted text
lia.notices.notifyLocalized("moneyReceived", 1000)

-- Display notification with multiple arguments
lia.notices.notifyLocalized("questCompleted", questName, rewardAmount)
```

---

### notification.AddLegacy (Client)

**Purpose**

Compatibility function for Garry's Mod's legacy notification system.

**Parameters**

* `text` (*string*): The notification text to display.

**Returns**

* `nil`

**Realm**

Client.

**Example Usage**

```lua
-- Use legacy notification system
notification.AddLegacy("This is a legacy notification")

-- Convert old code to use Lilia notices
-- Old: notification.AddLegacy("Hello World!")
-- New: lia.notices.notify("Hello World!")
```

## Notification Display

The notice system provides the following features:

### Visual Appearance
- **Background**: Semi-transparent dark background
- **Text Color**: White text with good contrast
- **Border**: Subtle border for definition
- **Animation**: Smooth slide-in and slide-out animations

### Positioning
- **Location**: Top-right corner of the screen
- **Stacking**: Multiple notifications stack vertically
- **Spacing**: 4 pixel gap between notifications

### Timing
- **Display Duration**: 7.75 seconds
- **Fade Delay**: 0.25 seconds before starting to fade
- **Animation Duration**: 0.15 seconds for slide animations

### Sound Effects
- **Notification Sound**: Plays "garrysmod/content_downloaded.wav" at 50 volume and 250 pitch
- **Timing**: Sound plays 0.15 seconds after notification appears

## Usage Examples

### Server-side Notifications

```lua
-- Player join notification
hook.Add("PlayerInitialSpawn", "JoinNotification", function(ply)
    lia.notices.notifyLocalized("playerJoined", ply:Name())
end)

-- Admin command feedback
lia.command.add("kick", {
    arguments = {
        {name = "target", type = "player"},
        {name = "reason", type = "string", optional = true}
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local target = arguments[1]
        local reason = arguments[2] or "No reason provided"

        target:Kick(reason)
        lia.notices.notifyLocalized("playerKicked", client, target:Name(), reason)
    end
})

-- Item purchase notification
function purchaseItem(player, itemName, price)
    if player:getMoney() >= price then
        player:addMoney(-price)
        -- Give item logic here
        lia.notices.notifyLocalized("itemPurchased", player, itemName, price)
    else
        lia.notices.notifyLocalized("insufficientFunds", player, price - player:getMoney())
    end
end
```

### Client-side Notifications

```lua
-- Inventory update notification
function updateInventory()
    -- Update inventory logic here
    lia.notices.notifyLocalized("inventoryUpdated")
end

-- Quest completion notification
function completeQuest(questName, reward)
    -- Complete quest logic here
    lia.notices.notifyLocalized("questCompleted", questName, reward)
end

-- Error handling notification
function handleError(errorMessage)
    lia.notices.notifyLocalized("errorOccurred", errorMessage)
end

-- Custom notification with sound
function showCustomNotification(message, soundPath)
    lia.notices.notify(message)
    if soundPath then
        surface.PlaySound(soundPath)
    end
end
```

## Localization Support

The notice system fully supports Lilia's localization system:

### Adding Localization Keys

```lua
-- In your language file (e.g., english.lua)
LANGUAGE = {
    playerJoined = "Player %s has joined the server!",
    playerKicked = "Player %s was kicked: %s",
    itemPurchased = "Purchased %s for %s!",
    insufficientFunds = "You need %s more money!",
    inventoryUpdated = "Inventory updated successfully!",
    questCompleted = "Quest '%s' completed! Reward: %s",
    errorOccurred = "Error: %s"
}
```

### Using Localized Notifications

```lua
-- Server-side localized notification
lia.notices.notifyLocalized("playerJoined", player:Name())

-- Client-side localized notification
lia.notices.notifyLocalized("inventoryUpdated")

-- With multiple arguments
lia.notices.notifyLocalized("playerKicked", player:Name(), reason)
```

## Best Practices

1. **Use Localized Messages**: Always use `notifyLocalized` instead of `notify` for user-facing messages to support multiple languages.

2. **Keep Messages Concise**: Notifications should be brief and to the point since they auto-dismiss after 8 seconds.

3. **Use Appropriate Timing**: Consider when to show notifications - don't spam players with too many messages.

4. **Handle Edge Cases**: Always check if players are valid before sending notifications.

5. **Use Proper Formatting**: When using multiple arguments, ensure they match the localization string placeholders.

6. **Test Localization**: Always test localized messages with different argument types to ensure proper formatting.

7. **Consider Accessibility**: Some players may have visual impairments, so important notifications might need additional audio cues.