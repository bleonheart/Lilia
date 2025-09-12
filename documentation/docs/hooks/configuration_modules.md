## Configuration & Modules

---

### CanPlayerModifyConfig

**Purpose**

Determines if a player can modify configuration.

**Parameters**

* `client` (*Player*): Player attempting to modify config.

**Returns**

- boolean: False to prevent modification

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanPlayerModifyConfig", "ConfigRestrict", function(client)
    return client:IsAdmin()
end)
```

---

### ConfigChanged

**Purpose**

Fires when configuration is changed.

**Parameters**

* `key` (*string*): Configuration key that changed.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("ConfigChanged", "ConfigLog", function(key, oldValue, newValue)
    print("Config updated:", key, "from", oldValue, "to", newValue)
end)
```

---

### InitializedConfig

**Purpose**

Fires when configuration is initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedConfig", "PostConfigInit", function()
    print("Configuration initialized")
end)
```

---

### InitializedItems

**Purpose**

Called when items are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedItems", "PostItemInit", function()
    print("Items initialized")
end)
```

---

### InitializedModules

**Purpose**

Fires when modules are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedModules", "PostModuleInit", function()
    print("Modules initialized")
end)
```

---

### InitializedOptions

**Purpose**

Called when options are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedOptions", "PostOptionInit", function()
    print("Options initialized")
end)
```

---

### InitializedSchema

**Purpose**

Fires when schema is initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedSchema", "PostSchemaInit", function()
    print("Schema initialized")
end)
```

---

### InitializedKeybinds

**Purpose**

Fires when keybinds are initialized.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("InitializedKeybinds", "PostKeybindInit", function()
    print("Keybinds initialized")
end)
```

---

### DoModuleIncludes

**Purpose**

Called during module inclusion process.

**Parameters**

* `moduleName` (*string*): Name of the module being included.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("DoModuleIncludes", "LogIncludes", function(moduleName)
    print("Including module:", moduleName)
end)
```

---

### PreLiliaLoaded

**Purpose**

Runs before the Lilia framework finishes loading.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("PreLiliaLoaded", "PreInit", function()
    print("Lilia is loading...")
end)
```

---

### LiliaLoaded

**Purpose**

Runs after the Lilia framework has finished loading.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("LiliaLoaded", "PostInit", function()
    print("Lilia has finished loading")
end)
```

---

### liaOptionChanged

**Purpose**

Triggered whenever `lia.option.set` modifies an option value.

**Parameters**

* `key` (*string*): Option identifier.
* `oldValue` (*any*): Previous value before the change.
* `newValue` (*any*): New assigned value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("liaOptionChanged", "LogOptionChange", function(k, oldV, newV)
    print(k .. " changed from " .. tostring(oldV) .. " to " .. tostring(newV))
end)
```

---

### liaOptionReceived

**Purpose**

Called when an option is received from the server.

**Parameters**

* `key` (*string*): Option key.
* `value` (*any*): Option value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("liaOptionReceived", "OptionLog", function(key, value)
    print("Option received:", key, "=", value)
end)
```

---

### WebImageDownloaded

**Purpose**

Triggered after a remote image finishes downloading to the data folder.

**Parameters**

* `name` (*string*): Saved file name including extension.
* `path` (*string*): Local `data/` path to the image.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("WebImageDownloaded", "ImageLog", function(name, path)
    print("Image downloaded:", name, path)
end)
```

---

### WebSoundDownloaded

**Purpose**

Triggered after a remote sound file finishes downloading to the data folder.

**Parameters**

* `name` (*string*): Saved file name including extension.
* `path` (*string*): Local `data/` path to the sound file.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("WebSoundDownloaded", "SoundLog", function(name, path)
    print("Sound downloaded:", name, path)
end)
```

---

### DiscordRelaySend

**Purpose**

Called just before an embed is posted to the configured Discord webhook. Return values are ignored; the embed cannot be modified from this hook.

**Parameters**

* `embed` (*table*): The embed object that will be sent to Discord.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("DiscordRelaySend", "PrintLog", function(embed)
    print("Sending to Discord:", embed.title or "Untitled")
end)
```

---

### DiscordRelayed

**Purpose**

Runs after an embed has been successfully sent through the webhook.

**Parameters**

* `embed` (*table*): The embed object that was sent to Discord.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("DiscordRelayed", "PrintRelayed", function(embed)
    print("Relayed to Discord:", embed.title or "Untitled")
end)
```

---

### DiscordRelayUnavailable

**Purpose**

Fires when the CHTTP binary module is missing and relaying cannot be performed.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("DiscordRelayUnavailable", "NotifyMissing", function()
    print("Discord relay module unavailable.")
end)
```

---

### CreateMenuButtons

**Purpose**

Executed during menu creation allowing you to define custom tabs. Allows modules to insert additional tabs into the F1 menu.

**Parameters**

* `tabs` (*table*): Table to add menu definitions to.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CreateMenuButtons", "AddHelpTab", function(tabs)
    tabs.help = {
        text = "Help",
        panel = function()
            local pnl = vgui.Create("DPanel")
            pnl:Dock(FILL)
            local label = vgui.Create("DLabel", pnl)
            local commands = {}
            for k in pairs(lia.command.list) do
                commands[#commands + 1] = k
            end
            label:SetText(table.concat(commands, "\n"))
            label:Dock(FILL)
            label:SetFont("DermaDefault")
            return pnl
        end,
    }
end)
```

---

### DrawLiliaModelView

**Purpose**

Runs every frame when the character model panel draws. Lets code draw over the model view used in character menus.

**Parameters**

* `panel` (*Panel*): The model panel being drawn.
* `entity` (*Entity*): Model entity displayed.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("DrawLiliaModelView", "ShowName", function(panel, entity)
    local char = LocalPlayer():getChar()
    if not char then
        return
    end
    draw.SimpleTextOutlined(
        char:getName(),
        "Trebuchet24",
        panel:GetWide() / 2,
        8,
        color_white,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_TOP,
        1,
        color_black
    )
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
hook.Add("GetMainMenuPosition", "OffsetCharView", function(character)
    return Vector(30, 10, 60), Angle(0, 30, 0)
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

### SetupQuickMenu

**Purpose**

Fill the Quick Settings panel with options using the provided panel helpers.

**Parameters**

* `panel` (*Panel*): The `liaQuick` panel. Use `addCategory`, `addButton`, `addSlider`, `addCheck`.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("SetupQuickMenu", "QuickToggles", function(panel)
    panel:addCategory(L("categoryGeneral"))
    panel:addCheck(L("thirdPerson"), function(_, v) lia.option.set("thirdPersonEnabled", v) end, lia.option.get("thirdPersonEnabled", false))
end)
```

---

### liaOptionChanged

**Purpose**

Triggered whenever `lia.option.set` modifies an option value.

**Parameters**

* `key` (*string*): Option identifier.
* `oldValue` (*any*): Previous value before the change.
* `newValue` (*any*): New assigned value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("liaOptionChanged", "LogOptionChange", function(k, oldV, newV)
    print(k .. " changed from " .. tostring(oldV) .. " to " .. tostring(newV))
end)
```

---

### liaOptionReceived

**Purpose**

Called when an option is received from the server.

**Parameters**

* `key` (*string*): Option key.
* `value` (*any*): Option value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("liaOptionReceived", "OptionLog", function(key, value)
    print("Option received:", key, "=", value)
end)
```

---

### OnLocalizationLoaded

**Purpose**

Called when localization is loaded.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnLocalizationLoaded", "LocalizationReady", function()
    print("Localization loaded")
end)
```

---

### RefreshFonts

**Purpose**

Fires when fonts need to be refreshed.

**Parameters**

* `nil` (*nil*): This function does not return a value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("RefreshFonts", "FontRefresh", function()
    -- Refresh custom fonts
end)
```

---

### DermaSkinChanged

**Purpose**

Called when the Derma skin changes.

**Parameters**

* `skin` (*string*): New skin name.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("DermaSkinChanged", "SkinLog", function(skin)
    print("Derma skin changed to:", skin)
end)
```

---

### AddTextField

**Purpose**

Allows adding custom text fields to the HUD.

**Parameters**

* `client` (*Player*): Player to add text field for.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("AddTextField", "CustomField", function(client)
    local char = client:getChar()
    if char then
        return {text = "Level: " .. char:getData("level", 1), color = Color(255, 255, 255)}
    end
end)
```

---

### F1OnAddTextField

**Purpose**

Called when adding text fields to the F1 menu.

**Parameters**

* `client` (*Player*): Player to add text field for.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("F1OnAddTextField", "F1Field", function(client)
    -- Add text field to F1 menu
end)
```

---

### F1OnAddBarField

**Purpose**

Called when adding bar fields to the F1 menu.

**Parameters**

* `client` (*Player*): Player to add bar field for.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("F1OnAddBarField", "F1Bar", function(client)
    -- Add bar field to F1 menu
end)
```

---

### AddBarField

**Purpose**

Allows adding custom fields to the HUD bars.

**Parameters**

* `client` (*Player*): Player whose bars are being set up.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("AddBarField", "HungerBar", function(ply)
    local char = ply:getChar()
    if char then
        local hunger = char:getData("hunger", 0)
        return {name = "Hunger", value = hunger, max = 100, color = Color(255, 100, 100)}
    end
end)
```

---

### AddSection

**Purpose**

Allows adding custom sections to the F1 menu.

**Parameters**

* `panel` (*Panel*): F1 menu panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("AddSection", "CustomSection", function(panel)
    local section = panel:addSection("Custom")
    section:addButton("Custom Button", function()
        -- Custom button logic
    end)
end)
```

---

### F1OnAddSection

**Purpose**

Called when adding sections to the F1 menu.

**Parameters**

* `panel` (*Panel*): F1 menu panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("F1OnAddSection", "F1Section", function(panel)
    -- Add custom section to F1 menu
end)
```

---

### CreateInformationButtons

**Purpose**

Allows adding custom information buttons to the main menu.

**Parameters**

* `panel` (*Panel*): Main menu panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("CreateInformationButtons", "CustomButton", function(panel)
    panel:addButton("Custom Info", function()
        -- Custom button logic
    end)
end)
```

---

### PopulateConfigurationButtons

**Purpose**

Called to populate configuration buttons.

**Parameters**

* `panel` (*Panel*): Configuration panel.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("PopulateConfigurationButtons", "ConfigButtons", function(panel)
    -- Add configuration buttons
end)
```

---

### PopulateAdminTabs

**Purpose**

Populate the Admin tab in the F1 menu. Mutate the provided `pages` array and insert page descriptors.

**Parameters**

* `pages` (*table*): Insert items like `{ name = string, icon = string, drawFunc = function(panel) end }`.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("PopulateAdminTabs", "AddOnlineList", function(pages)
    pages[#pages + 1] = {
        name = "onlinePlayers",
        icon = "icon16/user.png",
        drawFunc = function(panel)
            -- build UI here
        end
    }
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

### getAdjustedPartData

**Purpose**

Allows adjustment of PAC part data.

**Parameters**

* `client` (*Player*): Player whose PAC data is being adjusted.
* `partData` (*table*): Current part data.

**Returns**

* `adjustedData` (*table*): Adjusted part data.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("getAdjustedPartData", "AdjustPAC", function(client, partData)
    -- Adjust PAC part data
    return partData
end)
```

---

### AdjustPACPartData

**Purpose**

Called to adjust PAC part data.

**Parameters**

* `client` (*Player*): Player whose PAC data is being adjusted.
* `partData` (*table*): Current part data.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("AdjustPACPartData", "PACAdjust", function(client, partData)
    -- Adjust PAC part data
end)
```

---

### attachPart

**Purpose**

Fires when a PAC part is attached.

**Parameters**

* `client` (*Player*): Player attaching the part.
* `part` (*table*): Part being attached.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("attachPart", "PartAttach", function(client, part)
    print("Part attached:", part.name)
end)
```

---

### removePart

**Purpose**

Called when a PAC part is removed.

**Parameters**

* `client` (*Player*): Player removing the part.
* `part` (*table*): Part being removed.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("removePart", "PartRemove", function(client, part)
    print("Part removed:", part.name)
end)
```

---

### OnPAC3PartTransfered

**Purpose**

Fires when a PAC3 part is transferred.

**Parameters**

* `client` (*Player*): Player whose part is being transferred.
* `part` (*table*): Part being transferred.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("OnPAC3PartTransfered", "PartTransfer", function(client, part)
    print("PAC3 part transferred:", part.name)
end)
```

---

### DrawPlayerRagdoll

**Purpose**

Allows custom drawing of player ragdolls.

**Parameters**

* `client` (*Player*): Player whose ragdoll is being drawn.
* `entity` (*Entity*): Ragdoll entity.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("DrawPlayerRagdoll", "CustomRagdoll", function(client, entity)
    -- Custom ragdoll drawing
end)
```

---

### setupPACDataFromItems

**Purpose**

Called to set up PAC data from items.

**Parameters**

* `client` (*Player*): Player to set up PAC data for.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("setupPACDataFromItems", "PACFromItems", function(client)
    -- Set up PAC data from items
end)
```

---

### TryViewModel

**Purpose**

Allows modification of viewmodel handling.

**Parameters**

* `client` (*Player*): Player whose viewmodel is being handled.
* `weapon` (*Weapon*): Weapon whose viewmodel is being handled.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("TryViewModel", "CustomViewModel", function(client, weapon)
    -- Custom viewmodel handling
end)
```

---

### WeaponCycleSound

**Purpose**

Called when weapon cycling sound should play.

**Parameters**

* `client` (*Player*): Player cycling weapons.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("WeaponCycleSound", "CycleSound", function(client)
    -- Play custom cycle sound
end)
```

---

### WeaponSelectSound

**Purpose**

Fires when weapon selection sound should play.

**Parameters**

* `client` (*Player*): Player selecting weapon.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("WeaponSelectSound", "SelectSound", function(client)
    -- Play custom select sound
end)
```

---

### ShouldDrawWepSelect

**Purpose**

Determines if weapon selection should be drawn.

**Parameters**

* `client` (*Player*): Player to check.

**Returns**

- boolean: False to hide weapon selection

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ShouldDrawWepSelect", "HideWepSelect", function(client)
    return not client:getNetVar("hideWepSelect", false)
end)
```

---

### CanPlayerChooseWeapon

**Purpose**

Checks if a player can choose a weapon.

**Parameters**

* `client` (*Player*): Player attempting to choose weapon.
* `weapon` (*string*): Weapon class.

**Returns**

- boolean: False to prevent weapon choice

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanPlayerChooseWeapon", "RestrictWeapons", function(client, weapon)
    if weapon == "weapon_rpg" and not client:IsAdmin() then
        return false
    end
end)
```

---

### OverrideSpawnTime

**Purpose**

Allows overriding the spawn time for entities.

**Parameters**

* `entity` (*Entity*): Entity being spawned.

**Returns**

* `spawnTime` (*number*): Custom spawn time.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OverrideSpawnTime", "CustomSpawnTime", function(entity)
    if entity:GetClass() == "npc_headcrab" then
        return 60 -- Custom spawn time
    end
end)
```

---

### ShouldRespawnScreenAppear

**Purpose**

Determines if the respawn screen should appear.

**Parameters**

* `client` (*Player*): Player who died.

**Returns**

- boolean: False to hide respawn screen

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("ShouldRespawnScreenAppear", "CustomRespawn", function(client)
    return client:getNetVar("customRespawn", true)
end)
```

---

### PlayerSpawnPointSelected

**Purpose**

Called when a player selects a spawn point.

**Parameters**

* `client` (*Player*): Player selecting spawn point.
* `spawnPoint` (*Entity*): Selected spawn point.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerSpawnPointSelected", "SpawnLog", function(client, spawnPoint)
    print(client:Nick(), "selected spawn point", spawnPoint)
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

### thirdPersonToggled

**Purpose**

Fires when third-person view is toggled.

**Parameters**

* `client` (*Player*): Player who toggled third-person.
* `state` (*boolean*): New third-person state.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("thirdPersonToggled", "ToggleLog", function(client, state)
    print("Third-person", state and "enabled" or "disabled")
end)
```

---

### AdjustCreationData

**Purpose**

Allows adjustment of character creation data.

**Parameters**

* `client` (*Player*): Player creating character.
* `data` (*table*): Creation data.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("AdjustCreationData", "AdjustData", function(client, data)
    -- Adjust character creation data
end)
```

---

### CanCharBeTransfered

**Purpose**

Determines if a character can be transferred.

**Parameters**

* `character` (*Character*): Character to transfer.
* `newPlayer` (*Player*): New player to transfer to.

**Returns**

- boolean: False to prevent transfer

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanCharBeTransfered", "TransferRestrict", function(character, newPlayer)
    return newPlayer:IsAdmin()
end)
```

---

### CanInviteToFaction

**Purpose**

Checks if a player can invite others to a faction.

**Parameters**

* `inviter` (*Player*): Player attempting to invite.
* `target` (*Player*): Target player.
* `faction` (*string*): Faction to invite to.

**Returns**

- boolean: False to prevent invitation

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanInviteToFaction", "InviteRestrict", function(inviter, target, faction)
    return inviter:getChar():getFaction() == faction
end)
```

---

### CanInviteToClass

**Purpose**

Determines if a player can invite others to a class.

**Parameters**

* `inviter` (*Player*): Player attempting to invite.
* `target` (*Player*): Target player.
* `class` (*string*): Class to invite to.

**Returns**

- boolean: False to prevent invitation

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanInviteToClass", "ClassInviteRestrict", function(inviter, target, class)
    return inviter:getChar():getClass() == "leader"
end)
```

---

### CanPlayerUseChar

**Purpose**

Checks if a player can use a character.

**Parameters**

* `client` (*Player*): Player attempting to use character.
* `character` (*Character*): Character to use.

**Returns**

- boolean: False to prevent character use

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanPlayerUseChar", "CharRestrict", function(client, character)
    return character:getData("banned", false) == false
end)
```

---

### CanPlayerSwitchChar

**Purpose**

Determines if a player can switch characters.

**Parameters**

* `client` (*Player*): Player attempting to switch.

**Returns**

- boolean: False to prevent switching

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("CanPlayerSwitchChar", "SwitchRestrict", function(client)
    return not client:getNetVar("switchCooldown", false)
end)
```

---

### GetMaxStartingAttributePoints

**Purpose**

Returns the maximum starting attribute points.

**Parameters**

* `client` (*Player*): Player creating character.

**Returns**

* `points` (*number*): Maximum points.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("GetMaxStartingAttributePoints", "CustomPoints", function(client)
    return 50
end)
```

---

### GetAttributeStartingMax

**Purpose**

Returns the starting maximum for an attribute.

**Parameters**

* `client` (*Player*): Player creating character.
* `attribute` (*string*): Attribute name.

**Returns**

* `max` (*number*): Starting maximum.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("GetAttributeStartingMax", "AttributeMax", function(client, attribute)
    return 20
end)
```

---

### GetAttributeMax

**Purpose**

Returns the maximum value for an attribute.

**Parameters**

* `client` (*Player*): Player to check.
* `attribute` (*string*): Attribute name.

**Returns**

* `max` (*number*): Maximum value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("GetAttributeMax", "AttributeLimit", function(client, attribute)
    return 100
end)
```

---

### OnCharAttribBoosted

**Purpose**

Fires when a character's attribute is boosted.

**Parameters**

* `character` (*Character*): Character whose attribute was boosted.
* `attribute` (*string*): Attribute that was boosted.
* `amount` (*number*): Amount boosted.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharAttribBoosted", "BoostLog", function(character, attribute, amount)
    print("Attribute", attribute, "boosted by", amount)
end)
```

---

### OnCharAttribUpdated

**Purpose**

Called when a character's attribute is updated.

**Parameters**

* `character` (*Character*): Character whose attribute was updated.
* `attribute` (*string*): Attribute that was updated.
* `oldValue` (*number*): Previous value.
* `newValue` (*number*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnCharAttribUpdated", "UpdateLog", function(character, attribute, oldValue, newValue)
    print("Attribute", attribute, "changed from", oldValue, "to", newValue)
end)
```

---

### OnCharFlagsGiven

**Purpose**

Fires when character flags are given.

**Parameters**

* `character` (*Character*): Character receiving flags.
* `flags` (*string*): Flags given.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharFlagsGiven", "FlagLog", function(character, flags)
    print("Flags given:", flags)
end)
```

---

### OnCharFlagsTaken

**Purpose**

Called when character flags are taken.

**Parameters**

* `character` (*Character*): Character losing flags.
* `flags` (*string*): Flags taken.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCharFlagsTaken", "FlagRemoveLog", function(character, flags)
    print("Flags taken:", flags)
end)
```

---

### OnCheaterStatusChanged

**Purpose**

Fires when a player's cheater status changes.

**Parameters**

* `client` (*Player*): Player whose status changed.
* `isCheater` (*boolean*): New cheater status.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCheaterStatusChanged", "StatusLog", function(client, isCheater)
    print(client:Nick(), "cheater status:", isCheater)
end)
```

---

### OnConfigUpdated

**Purpose**

Called when configuration is updated.

**Parameters**

* `key` (*string*): Configuration key that was updated.
* `oldValue` (*any*): Previous value.
* `newValue` (*any*): New value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Shared**

**Example Usage**

```lua
hook.Add("OnConfigUpdated", "ConfigUpdateLog", function(key, oldValue, newValue)
    print("Config updated:", key, "from", oldValue, "to", newValue)
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

### OnSalaryGive

**Purpose**

Called when salary is given to a player.

**Parameters**

* `client` (*Player*): Player receiving salary.
* `amount` (*number*): Salary amount.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnSalaryGive", "SalaryLog", function(client, amount)
    print(client:Nick(), "received salary:", amount)
end)
```

---

### OnTicketClaimed

**Purpose**

Fires when a ticket is claimed.

**Parameters**

* `ticket` (*table*): Ticket that was claimed.
* `claimer` (*Player*): Player who claimed the ticket.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnTicketClaimed", "TicketClaimLog", function(ticket, claimer)
    print("Ticket", ticket.id, "claimed by", claimer:Nick())
end)
```

---

### OnTicketClosed

**Purpose**

Called when a ticket is closed.

**Parameters**

* `ticket` (*table*): Ticket that was closed.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnTicketClosed", "TicketCloseLog", function(ticket)
    print("Ticket", ticket.id, "closed")
end)
```

---

### OnTicketCreated

**Purpose**

Fires when a ticket is created.

**Parameters**

* `ticket` (*table*): Ticket that was created.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnTicketCreated", "TicketCreateLog", function(ticket)
    print("Ticket", ticket.id, "created")
end)
```

---

### OnVendorEdited

**Purpose**

Called when a vendor is edited.

**Parameters**

* `vendor` (*Entity*): Vendor that was edited.
* `client` (*Player*): Player who edited the vendor.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnVendorEdited", "VendorEditLog", function(vendor, client)
    print("Vendor edited by", client:Nick())
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

### WebImageDownloaded

**Purpose**

Triggered after a remote image finishes downloading to the data folder.

**Parameters**

* `name` (*string*): Saved file name including extension.
* `path` (*string*): Local `data/` path to the image.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("WebImageDownloaded", "ImageLog", function(name, path)
    print("Image downloaded:", name, path)
end)
```

---

### WebSoundDownloaded

**Purpose**

Triggered after a remote sound file finishes downloading to the data folder.

**Parameters**

* `name` (*string*): Saved file name including extension.
* `path` (*string*): Local `data/` path to the sound file.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("WebSoundDownloaded", "SoundLog", function(name, path)
    print("Sound downloaded:", name, path)
end)
```

---

### PlayerCheatDetected

**Purpose**

Fires when cheat detection is triggered.

**Parameters**

* `client` (*Player*): Player detected cheating.
* `cheatType` (*string*): Type of cheat detected.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("PlayerCheatDetected", "CheatLog", function(client, cheatType)
    print("Cheat detected:", client:Nick(), cheatType)
end)
```

---

### OnCheaterCaught

**Purpose**

Called when a cheater is caught.

**Parameters**

* `client` (*Player*): Player caught cheating.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Server**

**Example Usage**

```lua
hook.Add("OnCheaterCaught", "CheaterLog", function(client)
    print("Cheater caught:", client:Nick())
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

### liaOptionReceived

**Purpose**

Called when an option is received from the server.

**Parameters**

* `key` (*string*): Option key.
* `value` (*any*): Option value.

**Returns**

* `nil` (*nil*): This function does not return a value.

**Realm**

**Client**

**Example Usage**

```lua
hook.Add("liaOptionReceived", "OptionLog", function(key, value)
    print("Option received:", key, "=", value)
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