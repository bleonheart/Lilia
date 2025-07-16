### `SendCaptionCommand`

**Purpose**
`Triggered when an administrator uses the sendCaption command.`

**Parameters**

* `client` (`Player`): `The admin running the command.`
* `target` (`Player`): `Player who will receive the caption.`
* `text` (`string`): `Caption text.`
* `duration` (`number`): `How long the caption should display.`

**Realm**
`Server`

**Returns**
`nil`

**Example**

```lua
hook.Add("SendCaptionCommand", "LogCaptionSend", function(client, target, text, duration)
    print(client:Name() .. " captioned " .. target:Name())
end)
```

---

### `BroadcastCaptionCommand`

**Purpose**
`Called when an administrator broadcasts a caption to all players.`

**Parameters**

* `client` (`Player`): `Admin issuing the command.`
* `text` (`string`): `Caption text.`
* `duration` (`number`): `Display time in seconds.`

**Realm**
`Server`

**Returns**
`nil`

**Example**

```lua
hook.Add("BroadcastCaptionCommand", "TrackCaptionBroadcast", function(client, text, duration)
    -- log broadcast here
end)
```

---

### `CaptionStarted`

**Purpose**
`Fires whenever a caption begins displaying.`

**Parameters**

* `clientOrText` (`Player|string`): `On the server this is the target player, on the client this is the caption text.`
* `textOrDuration` (`string|number`): `On the server this is the caption text, on the client this is the duration.`
* `duration` (`number`, optional): `Duration when running server side.`

**Realm**
`Client & Server`

**Returns**
`nil`

**Example**

```lua
hook.Add("CaptionStarted", "HandleCaptionStart", function(a, b, duration)
    -- parameters depend on realm
end)
```

---

### `CaptionFinished`

**Purpose**
`Runs when an active caption ends.`

**Parameters**

* `client` (`Player`, optional): `The player whose caption ended when on the server.`

**Realm**
`Client & Server`

**Returns**
`nil`

**Example**

```lua
hook.Add("CaptionFinished", "HandleCaptionEnd", function(client)
    -- cleanup logic here
end)
```
