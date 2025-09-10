# Chatbox Library

This page documents the functions for working with chat system and message handling.

---

## Overview

The chatbox library (`lia.chat`) provides a comprehensive chat system for the Lilia framework. It handles different chat types, message parsing, privilege checking, and custom chat formatting. The library supports various chat modes including in-character (IC), out-of-character (OOC), and custom chat types with configurable prefixes, ranges, and permissions.

---

### lia.chat.timestamp

**Purpose**

Generates a timestamp string for chat messages based on configuration.

**Parameters**

* `ooc` (*boolean*): Whether this is for OOC chat (affects spacing).

**Returns**

* `timestamp` (*string*): Formatted timestamp string or empty string if disabled.

**Realm**

Client.

**Example Usage**

```lua
-- Get timestamp for regular chat
local timestamp = lia.chat.timestamp(false)
print("Timestamp: " .. timestamp)

-- Get timestamp for OOC chat
local oocTimestamp = lia.chat.timestamp(true)
print("OOC Timestamp: " .. oocTimestamp)

-- Use in custom chat formatting
local function formatMessage(speaker, text, chatType)
    local timestamp = lia.chat.timestamp(chatType == "ooc")
    return timestamp .. speaker:Name() .. ": " .. text
end

-- Use in hook
hook.Add("OnChatMessage", "AddTimestamp", function(speaker, text, chatType)
    local timestamp = lia.chat.timestamp(chatType == "ooc")
    -- Process message with timestamp
end)
```

---

### lia.chat.register

**Purpose**

Registers a new chat type with specified properties and behaviors.

**Parameters**

* `chatType` (*string*): The unique identifier for the chat type.
* `data` (*table*): Chat type configuration table containing:
  * `prefix` (*string|table*): Chat prefix(es) for this type.
  * `arguments` (*table*): Command arguments for this chat type.
  * `desc` (*string*): Description of the chat type.
  * `radius` (*number|function*): Range for hearing messages.
  * `onCanHear` (*function*): Function to determine if listener can hear speaker.
  * `onCanSay` (*function*): Function to determine if speaker can use this chat.
  * `color` (*Color*): Color for this chat type.
  * `format` (*string*): Format string for message display.
  * `onChatAdd` (*function*): Function to handle message display.
  * `deadCanChat` (*boolean*): Whether dead players can use this chat.
  * `noSpaceAfter` (*boolean*): Whether to skip space after prefix.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Register a basic chat type
lia.chat.register("yell", {
    prefix = "/y",
    desc = "Yell to nearby players",
    radius = 200,
    color = Color(255, 100, 100),
    format = "yellFormat"
})

-- Register a whisper chat type
lia.chat.register("whisper", {
    prefix = "/w",
    desc = "Whisper to very close players",
    radius = 50,
    color = Color(150, 150, 150),
    format = "whisperFormat",
    deadCanChat = false
})

-- Register a radio chat type
lia.chat.register("radio", {
    prefix = "/r",
    desc = "Radio communication",
    radius = 1000,
    color = Color(0, 255, 0),
    format = "radioFormat",
    onCanSay = function(speaker)
        local char = speaker:getChar()
        return char and char:hasItem("radio")
    end
})

-- Register a faction chat type
lia.chat.register("faction", {
    prefix = "/f",
    desc = "Faction communication",
    color = Color(255, 255, 0),
    format = "factionFormat",
    onCanHear = function(speaker, listener)
        local speakerChar = speaker:getChar()
        local listenerChar = listener:getChar()
        return speakerChar and listenerChar and 
               speakerChar:getFaction() == listenerChar:getFaction()
    end
})

-- Register a staff chat type
lia.chat.register("staff", {
    prefix = "/s",
    desc = "Staff communication",
    color = Color(255, 0, 255),
    format = "staffFormat",
    onCanSay = function(speaker)
        return speaker:hasPrivilege("staffChat")
    end,
    onCanHear = function(speaker, listener)
        return listener:hasPrivilege("staffChat")
    end
})

-- Register a global chat type
lia.chat.register("global", {
    prefix = "/g",
    desc = "Global communication",
    color = Color(100, 200, 255),
    format = "globalFormat",
    onCanHear = function() return true end
})

-- Register a custom chat with multiple prefixes
lia.chat.register("custom", {
    prefix = {"/custom", "/c"},
    desc = "Custom chat type",
    radius = 300,
    color = Color(200, 200, 200),
    format = "customFormat",
    noSpaceAfter = true
})
```

---

### lia.chat.parse

**Purpose**

Parses a chat message to determine the chat type and extract the message content.

**Parameters**

* `client` (*Player*): The client who sent the message.
* `message` (*string*): The message text to parse.
* `noSend` (*boolean*): Whether to skip sending the message.

**Returns**

* `chatType` (*string*): The determined chat type.
* `message` (*string*): The parsed message content.
* `anonymous` (*boolean*): Whether the message is anonymous.

**Realm**

Shared.

**Example Usage**

```lua
-- Parse a chat message
local chatType, message, anonymous = lia.chat.parse(client, "/y Hello everyone!")

-- Parse with validation
if message and message:find("%S") then
    local chatType, message, anonymous = lia.chat.parse(client, message)
    print("Chat type: " .. chatType)
    print("Message: " .. message)
end

-- Parse in PlayerSay hook
hook.Add("PlayerSay", "ParseChat", function(ply, text)
    local chatType, message, anonymous = lia.chat.parse(ply, text)
    if chatType ~= "ic" then
        print(ply:Name() .. " used " .. chatType .. " chat")
    end
    return false -- Prevent default chat
end)

-- Parse without sending
local chatType, message, anonymous = lia.chat.parse(client, "/w secret message", true)
if chatType == "whisper" then
    -- Process whisper without sending
end
```

---

### lia.chat.send

**Purpose**

Sends a chat message to appropriate recipients based on chat type rules.

**Parameters**

* `speaker` (*Player*): The player who sent the message.
* `chatType` (*string*): The type of chat message.
* `text` (*string*): The message text to send.
* `anonymous` (*boolean*): Whether the message should be anonymous.
* `receivers` (*table*): Optional specific list of receivers.

**Returns**

*None*

**Realm**

Server.

**Example Usage**

```lua
-- Send a regular chat message
lia.chat.send(speaker, "ic", "Hello everyone!")

-- Send an OOC message
lia.chat.send(speaker, "ooc", "This is OOC chat", false)

-- Send a whisper to specific players
local receivers = {player1, player2, player3}
lia.chat.send(speaker, "whisper", "Secret message", false, receivers)

-- Send anonymous message
lia.chat.send(speaker, "yell", "Someone yells!", true)

-- Send with custom formatting
lia.chat.send(speaker, "radio", "Radio message", false)

-- Send to all players in range
lia.chat.send(speaker, "yell", "YELLING!", false)

-- Send staff message
if speaker:hasPrivilege("staffChat") then
    lia.chat.send(speaker, "staff", "Staff communication", false)
end
```