## Communication & Social

---

### PlayerEndVoice

**Purpose**

Fired when the voice panel for a player is removed from the HUD.

**Parameters**

* `client` (*Player*): Player whose panel ended.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Announces in chat and plays a sound when someone stops using voice chat.
hook.Add("PlayerEndVoice", "NotifyVoiceStop", function(ply)
    chat.AddText(Color(200, 200, 255), ply:Nick() .. " stopped talking")
    surface.PlaySound("buttons/button19.wav")
end)
```

---

### ShouldShowPlayerOnScoreboard

**Purpose**

Return false to omit players from the scoreboard. Determines if a player should appear on the scoreboard.

**Parameters**

* `player` (*Player*): Player to test.

**Returns**

- boolean: False to hide the player

**Realm**

**Client**

**Example Usage**

```lua
-- Stops bots from showing up on the scoreboard.
hook.Add("ShouldShowPlayerOnScoreboard", "HideBots", function(ply)
    if ply:IsBot() then
        return false
    end
end)
```

---

### CanPlayerOpenScoreboard

**Purpose**

Checks if the local player may open the scoreboard. Return false to prevent it from showing.

**Parameters**

* `player` (*Player*): Local player.

**Returns**

- boolean: False to disallow opening.

**Realm**

**Client**

**Example Usage**

```lua
-- Only allow the scoreboard while alive.
hook.Add("CanPlayerOpenScoreboard", "AliveOnly", function(ply)
    if not ply:Alive() then
        return false
    end
end)
```

---

### ShowPlayerOptions

**Purpose**

Populate the scoreboard context menu with extra options. Allows modules to add scoreboard options for a player.

**Parameters**

* `player` (*Player*): Target player.

* `options` (*table*): Options table to populate.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Adds a friendly "Wave" choice in the scoreboard menu.
hook.Add("ShowPlayerOptions", "WaveOption", function(ply, options)
    options[#options + 1] = {
        name = "Wave",
        func = function()
            RunConsoleCommand("say", "/me waves to " .. ply:Nick())
            LocalPlayer():ConCommand("act wave")
        end,
    }
end)
```

---

### GetDisplayedName

**Purpose**

Returns the name text to display for a player in UI panels.

**Parameters**

* `client` (*Player*): Player to query.

**Returns**

- string or nil: Name text to display

**Realm**

**Client**

**Example Usage**

```lua
-- Displays player names with an admin prefix.
hook.Add("GetDisplayedName", "AdminPrefix", function(ply)
    if ply:IsAdmin() then
        return "[ADMIN] " .. ply:Nick()
    end
end)
```

---

### GetDisplayedDescription

**Purpose**

Supplies the description text shown on the scoreboard. Returns the description text to display for a player.

**Parameters**

* `player` (*Player*): Target player.

* `isHUD` (*boolean*): True when drawing overhead text rather than in menus.

**Returns**

- string: Description text

**Realm**

**Client**

**Example Usage**

```lua
-- Provide an out-of-character description for scoreboard panels.
hook.Add("GetDisplayedDescription", "OOCDesc", function(ply, isHUD)
    if not isHUD then
        return ply:GetNWString("oocDesc", "")
    end
end)
```

---

### ScoreboardOpened

**Purpose**

Triggered when the scoreboard becomes visible on the client.

**Parameters**

* `panel` (*Panel*): Scoreboard panel instance.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ScoreboardOpened", "PlaySound", function(pnl)
    surface.PlaySound("buttons/button15.wav")
end)
```

---

### ScoreboardClosed

**Purpose**

Called after the scoreboard is hidden or removed.

**Parameters**

* `panel` (*Panel*): Scoreboard panel instance.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ScoreboardClosed", "LogClose", function(pnl)
    print("Closed scoreboard")
end)
```

---

### ScoreboardRowCreated

**Purpose**

Runs after a player's row panel is added to the scoreboard. Use this to customize the panel or add additional elements.

**Parameters**

* `panel` (*Panel*): Row panel created for the player.

* `player` (*Player*): Player associated with the row.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ScoreboardRowCreated", "AddGlow", function(pnl, ply)
    pnl:SetAlpha(200)
end)
```

---

### ScoreboardRowRemoved

**Purpose**

Runs after a player's row panel is removed from the scoreboard.

**Parameters**

* `panel` (*Panel*): Row panel being removed.

* `player` (*Player*): Player associated with the row.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ScoreboardRowRemoved", "CleanupEffects", function(pnl, ply)
    -- Clean up any effects or timers associated with this row
end)
```

---

### SpawnlistContentChanged

**Purpose**

Triggered when a spawn icon is removed from the extended spawn menu. Fired when content is removed from the spawn menu.

**Parameters**

* `icon` (*Panel*): Icon affected.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Plays a sound and prints which model was removed from the spawn menu.
hook.Add("SpawnlistContentChanged", "IconRemovedNotify", function(icon)
    surface.PlaySound("buttons/button9.wav")
    local name = icon:GetSpawnName() or icon:GetModelName() or tostring(icon)
    print("Removed spawn icon", name)
end)
```

---

### ModifyScoreboardModel

**Purpose**

Allows modules to customize the model entity displayed for scoreboard entries. This can be used to attach props or tweak bodygroups.

**Parameters**

* `entity` (*Entity*): Model entity being shown.
* `player` (*Player*): Player this entry represents.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Give everyone a cone hat on the scoreboard.
hook.Add("ModifyScoreboardModel", "ConeHat", function(ent, ply)
    local hat = ClientsideModel("models/props_junk/TrafficCone001a.mdl")
    hat:SetParent(ent)
    hat:AddEffects(EF_BONEMERGE)
end)
```

---

### ShouldAllowScoreboardOverride

**Purpose**

Checks if a scoreboard value may be overridden by other hooks so modules can replace the displayed name, model or description for a player.

**Parameters**

* `client` (*Player*): Player being displayed.

* `var` (*string*): Field identifier such as "name", "model" or "desc".

**Returns**

- boolean: Return true to allow override

**Realm**

**Client**

**Example Usage**

```lua
-- Allows other hooks to replace player names on the scoreboard.
hook.Add("ShouldAllowScoreboardOverride", "OverrideNames", function(ply, var)
    if var == "name" then
        return true
    end
end)
```

---

### F1MenuOpened

**Purpose**

Runs when the F1 main menu panel initializes.

**Parameters**

* `panel` (*Panel*): Menu panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("F1MenuOpened", "Notify", function(menu)
    print("F1 menu opened")
end)
```

---

### F1MenuClosed

**Purpose**

Fires when the F1 main menu panel is removed.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("F1MenuClosed", "MenuGone", function()
    print("F1 menu closed")
end)
```

---

### CharacterMenuOpened

**Purpose**

Called when the character selection menu is created.

**Parameters**

* `panel` (*Panel*): Character menu panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CharacterMenuOpened", "PlayMusic", function(panel)
    surface.PlaySound("music/hl2_song17.mp3")
end)
```

---

### CharacterMenuClosed

**Purpose**

Fired when the character menu panel is removed.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CharacterMenuClosed", "StopMusic", function()
    print("Character menu closed")
end)
```

---

### ItemPanelOpened

**Purpose**

Triggered when an item detail panel is created.

**Parameters**

* `panel` (*Panel*): Item panel instance.

* `entity` (*Entity*): Item entity represented.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ItemPanelOpened", "Inspect", function(pnl, ent)
    print("Viewing item", ent)
end)
```

---

### ItemPanelClosed

**Purpose**

Runs after an item panel is removed.

**Parameters**

* `panel` (*Panel*): Item panel instance.

* `entity` (*Entity*): Item entity represented.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ItemPanelClosed", "LogClose", function(pnl, ent)
    print("Closed item panel for", ent)
end)
```

---

### InventoryOpened

**Purpose**

Called when an inventory panel is created.

**Parameters**

* `panel` (*Panel*): Inventory panel.

* `inventory` (*table*): Inventory shown.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("InventoryOpened", "Flash", function(pnl, inv)
    print("Opened inventory", inv:getID())
end)
```

---

### InventoryClosed

**Purpose**

Fired when an inventory panel is removed.

**Parameters**

* `panel` (*Panel*): Inventory panel.

* `inventory` (*table*): Inventory shown.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("InventoryClosed", "StopFlash", function(pnl, inv)
    print("Closed inventory", inv:getID())
end)
```

---

### InteractionMenuOpened

**Purpose**

Called when the interaction menu pops up.

**Parameters**

* `frame` (*Panel*): Interaction menu frame.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("InteractionMenuOpened", "Notify", function(frame)
    print("Opened interaction menu")
end)
```

---

### InteractionMenuClosed

**Purpose**

Runs when the interaction menu frame is removed.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("InteractionMenuClosed", "Notify", function()
    print("Interaction menu closed")
end)
```

---

### FinishChat

**Purpose**

Fires when the chat box closes. Fired when the chat box is closed.

**Parameters**

* `chatType` (*string*): The chat command being checked.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Fade out the chat box when it closes.
hook.Add("FinishChat", "ChatClosed", function()
    if IsValid(lia.gui.chat) then
        lia.gui.chat:AlphaTo(0, 0.2, 0, function()
            lia.gui.chat:Remove()
        end)
    end
end)
```

---

### StartChat

**Purpose**

Fires when the chat box opens. Fired when the chat box is opened.

**Parameters**

* `chatType` (*string*): The chat command being checked.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Plays a sound and focuses the chat window when it opens.
hook.Add("StartChat", "ChatOpened", function()
    surface.PlaySound("buttons/lightswitch2.wav")
    if IsValid(lia.gui.chat) then
        lia.gui.chat:MakePopup()
    end
end)
```

---

### ChatAddText

**Purpose**

Allows modification of the markup before chat messages are printed. Allows modification of markup before chat text is shown.

**Parameters**

* `text` (*string*): Base markup text.

- ...: Additional segments.

**Returns**

- string: Modified markup text.

**Realm**

**Client**

**Example Usage**

```lua
-- Turns chat messages green and prefixes the time before they appear.
hook.Add("ChatAddText", "GreenSystem", function(text, ...)
    local stamp = os.date("[%H:%M] ")
    return Color(0, 255, 0), stamp .. text, ...
end)
```

---

### ChatboxPanelCreated

**Purpose**

Called when the chatbox panel is instantiated.

**Parameters**

* `panel` (*Panel*): Newly created chat panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ChatboxPanelCreated", "StyleChat", function(pnl)
    pnl:SetFontInternal("liaChatFont")
end)
```

---

### ChatboxTextAdded

**Purpose**

Runs whenever chat.AddText successfully outputs text.

**Parameters**

- ...: Arguments passed to `chat.AddText`.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ChatboxTextAdded", "Notify", function(...)
    print("A chat message was added")
end)
```

---

### GetMainMenuPosition

**Purpose**

Returns the camera position and angle for the main menu character preview. Provides the camera position and angle for the main menu model.

**Parameters**

* `character` (*Character*): Character being viewed.

**Returns**

- Vector, Angle: Position and angle values.

**Realm**

**Client**

**Example Usage**

```lua
-- Positions the main menu camera with a slight offset.
hook.Add("GetMainMenuPosition", "OffsetCharView", function(character)
    return Vector(30, 10, 60), Angle(0, 30, 0)
end)
```

---

### CanDeleteChar

**Purpose**

Return false here to prevent character deletion. Determines if a character can be deleted.

**Parameters**

* `characterID` (*number*): Identifier of the character.

**Returns**

- boolean: False to disallow deletion.

**Realm**

**Client**

**Example Usage**

```lua
-- Blocks deletion of the first character slot.
hook.Add("CanDeleteChar", "ProtectSlot1", function(id)
    if id == 1 then
        return false
    end
end)
```

---

### LoadMainMenuInformation

**Purpose**

Lets modules insert additional information on the main menu info panel. Allows modules to populate extra information on the main menu panel.

**Parameters**

* `info` (*table*): Table to receive information.

* `character` (*Character*): Selected character.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Adds the character's faction name to the info panel.
hook.Add("LoadMainMenuInformation", "AddFactionInfo", function(info, character)
    local fac = lia.faction.indices[character:getFaction()]
    local facName = fac and fac.name or "Citizen"
    info[#info + 1] = "Faction" .. ": " .. facName
end)
```

---

### CanPlayerCreateChar

**Purpose**

Checks if a player may start creating a character. Determines if the player may create a new character.

**Parameters**

* `player` (*Player*): The player attempting to create a character.
* `data` (*table*|nil): Optional character data being created. Only supplied on the server.

**Returns**

- boolean: False to disallow creation.

**Realm**

**Shared**

**Example Usage**

```lua
-- Restricts character creation to admins only.
hook.Add("CanPlayerCreateChar", "AdminsOnly", function(ply)
    if not ply:IsAdmin() then
        return false
    end
end)
```

---

### ModifyCharacterModel

**Purpose**

Lets you edit the clientside model used in the main menu. Allows adjustments to the character model in menus.

**Parameters**

* `entity` (*Entity*): Model entity.

* `character` (*Character* | *nil*): Character data if available.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Apply appearance tweaks to the menu model.
hook.Add("ModifyCharacterModel", "ApplyBodygroup", function(ent, character)
    -- bodygroup changes work even if 'character' is nil
    ent:SetBodygroup(2, 1)
    if character then
        ent:SetSkin(character:getData("skin", 0))
    end
end)
```

---

### ConfigureCharacterCreationSteps

**Purpose**

Add or reorder steps in the character creation flow. Lets modules alter the character creation step layout.

**Parameters**

* `panel` (*Panel*): Creation panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Adds a custom "background" step to the character creator.
hook.Add("ConfigureCharacterCreationSteps", "InsertBackground", function(panel)
    local step = vgui.Create("liaCharacterBackground")
    panel:addStep(step, 99)
end)
```

---

### GetMaxPlayerChar

**Purpose**

Override to change how many characters a player can have. Returns the maximum number of characters a player can have.

**Parameters**

* `player` (*Player*): The player attempting to create a character.
* `data` (*table*|nil): Optional character data being created. Only supplied on the server.

**Returns**

- number: Maximum character count.

**Realm**

**Client**

**Example Usage**

```lua
-- Gives admins extra character slots.
hook.Add("GetMaxPlayerChar", "AdminSlots", function(ply)
    return ply:IsAdmin() and 10 or 5
end)
```

---

### ShouldMenuButtonShow

**Purpose**

Return false and a reason to hide buttons on the main menu. Determines if a button should be visible on the main menu.

**Parameters**

* `name` (*string*): Button identifier.

**Returns**

- boolean, string: False and reason to hide.

**Realm**

**Client**

**Example Usage**

```lua
-- Hides the delete button when the feature is locked.
hook.Add("ShouldMenuButtonShow", "HideDelete", function(name)
    if name == "delete" then
        return false, "Locked"
    end
end)
```

---

### ResetCharacterPanel

**Purpose**

Called when the character creation panel should reset. Called to reset the character creation panel.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Notifies whenever the creation panel resets.
hook.Add("ResetCharacterPanel", "ClearFields", function()
    print("Character creator reset")
end)
```

---

### TooltipLayout

**Purpose**

Customize tooltip sizing and layout before it appears.

**Parameters**

* `panel` (*Panel*): Tooltip panel being laid out.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Sets a fixed width for tooltips before layout.
hook.Add("TooltipLayout", "FixedWidth", function(panel)
    panel:SetWide(200)
end)
```

---

### TooltipPaint

**Purpose**

Draw custom visuals on the tooltip, returning true skips default painting.

**Parameters**

* `panel` (*Panel*): Tooltip panel.

* `width` (*number*): Panel width.

* `height` (*number*): Panel height.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Adds a dark background and skips default paint.
hook.Add("TooltipPaint", "BlurBackground", function(panel, w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, w, h)
    return true
end)
```

---

### TooltipInitialize

**Purpose**

Runs when a tooltip is opened for a panel.

**Parameters**

* `panel` (*Panel*): Tooltip panel.

* `target` (*Panel*): Target panel that opened the tooltip.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
-- Fades tooltips in when they are created.
hook.Add("TooltipInitialize", "SetupFade", function(panel, target)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.2, 0)
end)
```

---

### PostPlayerSay

**Purpose**

Runs after chat messages are processed. Allows reacting to player chat.

**Parameters**

* `client` (*Player*): Speaking player.

* `message` (*string*): Chat text.

* `chatType` (*string*): Chat channel.

* `anonymous` (*boolean*): Whether the message was anonymous.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
-- Log all OOC chat.
hook.Add("PostPlayerSay", "LogOOC", function(ply, msg, chatType)
    if chatType == "ooc" then
        print("[OOC]", ply:Nick(), msg)
    end
end)
```

---

### ChatParsed

**Purpose**

Fires when a chat message is parsed.

**Parameters**

* `speaker` (*Player*): Player who sent the message.
* `text` (*string*): Original message text.
* `chatType` (*string*): Type of chat.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("ChatParsed", "ProcessChat", function(speaker, text, chatType)
    -- Process parsed chat message
end)
```

---

### PlayerMessageSend

**Purpose**

Called when a player sends a message.

**Parameters**

* `client` (*Player*): Player who sent the message.
* `chatType` (*string*): Type of chat message.
* `message` (*string*): Message content.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerMessageSend", "LogMessages", function(client, chatType, message)
    print(client:Nick(), "sent", chatType, ":", message)
end)
```

---

### OnChatReceived

**Purpose**

Called when a chat message is received.

**Parameters**

* `speaker` (*Player*): Player who sent the message.
* `text` (*string*): Message text.
* `chatType` (*string*): Type of chat.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("OnChatReceived", "ProcessReceived", function(speaker, text, chatType)
    -- Process received chat message
end)
```

---

### getOOCDelay

**Purpose**

Returns the delay between OOC messages.

**Parameters**

* `client` (*Player*): Player to get delay for.

**Returns**

* `delay` (*number*): Delay in seconds.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("getOOCDelay", "CustomDelay", function(client)
    return client:IsAdmin() and 0 or 30
end)
```

---

### OnOOCMessageSent

**Purpose**

Fires when an out-of-character message is sent.

**Parameters**

* `client` (*Player*): Player who sent the message.
* `text` (*string*): Message content.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnOOCMessageSent", "OOCMsgLog", function(client, text)
    print("OOC message from", client:Nick(), ":", text)
end)
```

---

### VoiceToggled

**Purpose**

Fires when voice chat is toggled.

**Parameters**

* `client` (*Player*): Player who toggled voice.
* `state` (*boolean*): New voice state.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("VoiceToggled", "VoiceLog", function(client, state)
    print(client:Nick(), state and "enabled" or "disabled", "voice chat")
end)
```

---

### WarningIssued

**Purpose**

Fires when a warning is issued to a player.

**Parameters**

* `target` (*Player*): Player receiving the warning.
* `issuer` (*Player*): Player issuing the warning.
* `reason` (*string*): Warning reason.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("WarningIssued", "WarningLog", function(target, issuer, reason)
    print("Warning issued to", target:Nick(), "by", issuer:Nick(), ":", reason)
end)
```

---

### WarningRemoved

**Purpose**

Called when a warning is removed from a player.

**Parameters**

* `target` (*Player*): Player whose warning was removed.
* `remover` (*Player*): Player removing the warning.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("WarningRemoved", "RemoveLog", function(target, remover)
    print("Warning removed from", target:Nick(), "by", remover:Nick())
end)
```

---

### PlayerGagged

**Purpose**

Fires when a player is gagged.

**Parameters**

* `target` (*Player*): Player who was gagged.
* `gagger` (*Player*): Player who gagged them.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerGagged", "GagLog", function(target, gagger)
    print(target:Nick(), "was gagged by", gagger:Nick())
end)
```

---

### PlayerUngagged

**Purpose**

Called when a player is ungagged.

**Parameters**

* `target` (*Player*): Player who was ungagged.
* `ungagger` (*Player*): Player who ungagged them.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerUngagged", "UngagLog", function(target, ungagger)
    print(target:Nick(), "was ungagged by", ungagger:Nick())
end)
```

---

### PlayerMuted

**Purpose**

Fires when a player is muted.

**Parameters**

* `target` (*Player*): Player who was muted.
* `muter` (*Player*): Player who muted them.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerMuted", "MuteLog", function(target, muter)
    print(target:Nick(), "was muted by", muter:Nick())
end)
```

---

### PlayerUnmuted

**Purpose**

Called when a player is unmuted.

**Parameters**

* `target` (*Player*): Player who was unmuted.
* `unmuter` (*Player*): Player who unmuted them.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerUnmuted", "UnmuteLog", function(target, unmuter)
    print(target:Nick(), "was unmuted by", unmuter:Nick())
end)
```

---

### TicketSystemCreated

**Purpose**

Fires when a ticket is created in the ticket system.

**Parameters**

* `ticket` (*table*): Ticket that was created.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("TicketSystemCreated", "TicketLog", function(ticket)
    print("Ticket created:", ticket.id)
end)
```

---

### TicketSystemClaim

**Purpose**

Called when a ticket is claimed.

**Parameters**

* `ticket` (*table*): Ticket that was claimed.
* `claimer` (*Player*): Player who claimed the ticket.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("TicketSystemClaim", "ClaimLog", function(ticket, claimer)
    print("Ticket", ticket.id, "claimed by", claimer:Nick())
end)
```

---

### TicketSystemClose

**Purpose**

Fires when a ticket is closed.

**Parameters**

* `ticket` (*table*): Ticket that was closed.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("TicketSystemClose", "CloseLog", function(ticket)
    print("Ticket", ticket.id, "closed")
end)
```

---

### liaCommandAdded

**Purpose**

Fires when a new command is registered.

**Parameters**

* `command` (*table*): The command that was added.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("liaCommandAdded", "CommandLog", function(command)
    print("Command added:", command.name)
end)
```

---

### liaCommandRan

**Purpose**

Called when a command is executed.

**Parameters**

* `client` (*Player*): Player who ran the command.
* `command` (*table*): Command that was run.
* `arguments` (*table*): Arguments passed to the command.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("liaCommandRan", "CommandUsageLog", function(client, command, arguments)
    print(client:Nick(), "ran command:", command.name)
end)
```

---

### OnServerLog

**Purpose**

Fires when a server log entry is created.

**Parameters**

* `message` (*string*): Log message.
* `category` (*string*): Log category.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnServerLog", "CustomLogging", function(message, category)
    -- Custom log processing
end)
```
