# Chatbox Library

This page documents the functions for working with chat systems and message handling.

---

## Overview

The chatbox library (`lia.chat`) provides a comprehensive system for managing in-game chat functionalities, including message parsing, type registration, and sending messages to players. It handles different chat types (IC, OOC, etc.), message formatting, and provides hooks for custom chat behavior. The library supports various chat features like radius-based chat, anonymous messaging, and custom chat commands.

---

### lia.chat.timestamp

**Purpose**

Generates a timestamp string for chat messages based on the current time.

**Parameters**

* `ooc` (*boolean*, *optional*): Whether this is an OOC (Out of Character) message.

**Returns**

* `timestamp` (*string*): The formatted timestamp string, or empty string if timestamps are disabled.

**Realm**

Shared.

**Example Usage**

```lua
-- Get timestamp for IC message
local icTimestamp = lia.chat.timestamp(false)
print("IC timestamp: " .. icTimestamp) -- Example: " (14:30) "

-- Get timestamp for OOC message
local oocTimestamp = lia.chat.timestamp(true)
print("OOC timestamp: " .. oocTimestamp) -- Example: " (14:30)"

-- Use in custom chat formatting
local function formatMessage(speaker, text, chatType)
    local timestamp = lia.chat.timestamp(chatType == "ooc")
    return timestamp .. speaker:Name() .. ": " .. text
end
```

---

### lia.chat.register

**Purpose**

Registers a new chat type with the system.

**Parameters**

* `chatType` (*string*): The unique identifier for the chat type.
* `data` (*table*): A table containing chat type configuration with fields:
  * `prefix` (*string|table*, *optional*): The prefix(es) for this chat type.
  * `arguments` (*table*, *optional*): Command arguments for this chat type.
  * `desc` (*string*, *optional*): Description of the chat type.
  * `radius` (*number|function*, *optional*): The radius for hearing this chat type.
  * `onCanHear` (*function*, *optional*): Function to determine if a listener can hear the speaker.
  * `onCanSay` (*function*, *optional*): Function to determine if a speaker can use this chat type.
  * `color` (*Color*, *optional*): The color for this chat type.
  * `format` (*string*, *optional*): The format string for this chat type.
  * `onChatAdd` (*function*, *optional*): Function to handle adding the message to chat.
  * `deadCanChat` (*boolean*, *optional*): Whether dead players can use this chat type.
  * `noSpaceAfter` (*boolean*, *optional*): Whether to require a space after the prefix.
  * `filter` (*string*, *optional*): The filter for this chat type.

**Returns**

* `nil`

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic IC chat type
lia.chat.register("ic", {
    prefix = "/",
    radius = 256,
    color = Color(242, 230, 160),
    format = "chatFormat",
    onCanSay = function(speaker)
        if not speaker:Alive() then
            speaker:notifyLocalized("noPerm")
            return false
        end
        return true
    end
})

-- Register a whisper chat type
lia.chat.register("whisper", {
    prefix = "//",
    radius = 64,
    color = Color(200, 200, 200),
    format = "whisperFormat",
    onCanSay = function(speaker)
        if not speaker:Alive() then
            speaker:notifyLocalized("noPerm")
            return false
        end
        return true
    end
})

-- Register a global OOC chat type
lia.chat.register("ooc", {
    prefix = "//",
    color = Color(100, 100, 255),
    format = "oocFormat",
    onCanHear = function() return true end,
    onCanSay = function(speaker)
        if not speaker:Alive() then
            speaker:notifyLocalized("noPerm")
            return false
        end
        return true
    end
})

-- Register a staff chat type
lia.chat.register("staff", {
    prefix = "@",
    color = Color(255, 100, 100),
    format = "staffFormat",
    onCanHear = function(speaker, listener)
        return listener:hasPrivilege("seeStaffChat")
    end,
    onCanSay = function(speaker)
        return speaker:hasPrivilege("useStaffChat")
    end
})
```

---

### lia.chat.parse

**Purpose**

Parses a chat message to determine its type and extract the message content.

**Parameters**

* `client` (*Player*): The client who sent the message.
* `message` (*string*): The message to parse.
* `noSend` (*boolean*, *optional*): If true, prevents sending the message.

**Returns**

* `chatType` (*string*): The determined chat type.
* `message` (*string*): The parsed message content.
* `anonymous` (*boolean*): Whether the message is anonymous.

**Realm**

Shared.

**Example Usage**

```lua
-- Parse a chat message
local chatType, message, anonymous = lia.chat.parse(client, "/Hello world!")
print("Chat type: " .. chatType) -- "ic"
print("Message: " .. message) -- "Hello world!"

-- Parse without sending
local chatType, message, anonymous = lia.chat.parse(client, "//This is OOC", true)
print("Parsed OOC message: " .. message)

-- Use in custom chat handling
hook.Add("PlayerSay", "CustomChatHandler", function(ply, text)
    local chatType, message, anonymous = lia.chat.parse(ply, text)
    if chatType == "custom" then
        -- Handle custom chat type
        return ""
    end
end)
```

---

### lia.chat.send

**Purpose**

Sends a chat message to appropriate receivers based on the chat type.

**Parameters**

* `speaker` (*Player*): The player who sent the message.
* `chatType` (*string*): The type of chat message.
* `text` (*string*): The message text to send.
* `anonymous` (*boolean*, *optional*): Whether the message is anonymous.
* `receivers` (*table*, *optional*): Specific receivers for the message. If nil, uses chat type rules.

**Returns**

* `nil`

**Realm**

Server.

**Example Usage**

```lua
if SERVER then
    -- Send a regular chat message
    lia.chat.send(speaker, "ic", "Hello everyone!")

    -- Send an anonymous message
    lia.chat.send(speaker, "ic", "Someone whispers...", true)

    -- Send to specific receivers
    local receivers = {player1, player2, player3}
    lia.chat.send(speaker, "ic", "Private message", false, receivers)

    -- Send OOC message
    lia.chat.send(speaker, "ooc", "This is OOC chat")

    -- Use in custom commands
    hook.Add("PlayerSay", "CustomCommand", function(ply, text)
        if text:sub(1, 6) == "!shout" then
            local message = text:sub(8)
            lia.chat.send(ply, "ic", message:upper())
            return ""
        end
    end)
end
```