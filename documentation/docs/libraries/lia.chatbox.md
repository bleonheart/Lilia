# Chatbox Library

This page outlines chatbox related functions and helpers.

---

## Overview

The chatbox library defines chat commands, renders messages, and registers chat classes that control how IC, action, OOC, and other messages appear. It also handles radius-based or global visibility for receivers.

---

### lia.chat.classes

**Purpose**

Table containing all registered chat class definitions indexed by their identifier.

**Realm**

`Shared`

**Example Usage**

```lua
local icClass = lia.chat.classes.ic
print(icClass.format)
```

---

### lia.chat.timestamp

**Purpose**

Returns a `"(hour)"` timestamp when `lia.option.ChatShowTime` is enabled.
For OOC messages a leading space is added and no trailing space is used; IC
messages get a trailing space. When timestamps are disabled an empty string is
returned.

**Parameters**

* `ooc` (*boolean*): True for out-of-character messages.

**Realm**

`Shared`

**Returns**

* *string*: Formatted time string or an empty string.

**Example Usage**

```lua
chat.AddText(lia.chat.timestamp(false), Color(255, 255, 255), "Hello!")
```

---

### lia.chat.register

**Purpose**

Registers a new chat class and sets up its command aliases.

**Parameters**

* `chatType` (*string*): Identifier for the chat class.

* `data` (*table*): Table of chat class properties.

  * `arguments` (table) – Ordered argument definitions for the associated command.

  * `desc` (string) – Description of the command shown in menus.

  * `prefix` (string | table) – Command prefixes that trigger this chat type. Slashless
    variants are automatically added.

  * `radius` (number | function) – Hearing range or custom range logic. Used to
    generate `onCanHear` when that callback is not supplied.

  * `onCanHear` (function | number) – Determines if a listener can see the
    message. Supplying a number is treated as a radius in units.

  * `onCanSay` (function) – Called before sending to verify the speaker may talk.
    The default blocks dead players unless `deadCanChat` is `true`.

  * `onChatAdd` (function) – Client-side handler for displaying the text.

  * `color` (Color) – Default colour for the fallback `onChatAdd`. Defaults to
    `Color(242, 230, 160)`.

  * `format` (string) – Format string used by the fallback `onChatAdd`.

  * `filter` (string) – Chat filter category used by the chat UI. Defaults to
    `"ic"`.

  * `noSpaceAfter` (boolean) – Allows prefixes without a trailing space.

  * `deadCanChat` (boolean) – Permits dead players to use the chat type.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- Register a waving emote command
lia.chat.register("wave", {
    desc = "Wave at those nearby",
    arguments = {{name = "text", type = "string", optional = true}},
    format = "* %s waves",
    prefix = {"/wave", "/greet"},
    filter = "actions",
    radius = lia.config.get("ChatRange", 280)
})
```

---

### lia.chat.parse

**Purpose**

Parses chat text, determines the appropriate chat type, and optionally sends it.
Results are passed through the `ChatParsed` hook, allowing modification of the
chat type, text, or anonymity. When run on the server and `noSend` is `false`,
the message is forwarded to `lia.chat.send` after the `PlayerMessageSend` hook.

**Parameters**

* `client` (*Player*): Player sending the message.

* `message` (*string*): Raw chat text.

* `noSend` (*boolean*): Suppress sending when `true`.

**Realm**

`Shared`

**Returns**

* *string*: Chat type identifier.

* *string*: Parsed text.

* *boolean*: Whether the speaker is anonymous.

Returns `nil` if the message contains only whitespace.

**Example Usage**

```lua
hook.Add("PlayerSay", "ParseChat", function(ply, text)
    local class, parsed = lia.chat.parse(ply, text, true)
    print(ply:Name(), "typed", parsed, "in", class)
    lia.chat.send(ply, class, string.upper(parsed))
    return ""
end)
```

---

### lia.chat.send

**Purpose**

Broadcasts a chat message to all eligible receivers.
It respects the chat class's `onCanSay` and `onCanHear` logic and passes text
through the `PlayerMessageSend` hook before networking.

**Parameters**

* `speaker` (*Player*): Message sender.

* `chatType` (*string*): Chat class identifier.

* `text` (*string*): Message text.

* `anonymous` (*boolean*): Whether the sender is anonymous.

* `receivers` (*table*): Optional list of target players.

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
local target = player.GetByID(1)
if IsValid(target) then
    lia.chat.send(client, "ic", "Hello", false, { target })
end
```

