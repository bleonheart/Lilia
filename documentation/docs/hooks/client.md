# Client Hooks

This page documents the hook functions available in the Lilia framework.

---

## Client Hooks

### PostDrawOpaqueRenderables

**Description:** Called after opaque renderables are drawn.

**Realm:** Client

**Parameters:** None

---

### ShouldDrawEntityInfo

**Description:** Called to determine if entity info should be drawn.

**Realm:** Client

**Parameters:**

* `e` (*any*): Parameter: e

---

### GetInjuredText

**Description:** Called to get injured text for a character.

**Realm:** Client

**Parameters:**

* `c` (*any*): Parameter: c

---

### DrawCharInfo

**Description:** Called to draw character information.

**Realm:** Client

**Parameters:**

* `c` (*any*): Parameter: c
* `_` (*any*): Unused parameter
* `info` (*any*): Parameter: info

---

### DrawEntityInfo

**Description:** Called to draw entity information.

**Realm:** Client

**Parameters:**

* `e` (*any*): Parameter: e
* `a` (*any*): Parameter: a
* `pos` (*any*): Parameter: pos

---

### HUDPaint

**Description:** Called every frame to draw HUD elements.

**Realm:** Client

**Parameters:** None

---

### TooltipInitialize

**Description:** Called when a tooltip is initialized.

**Realm:** Client

**Parameters:**

* `var` (*Panel*): Parameter: var
* `panel` (*Panel*): Parameter: panel

---

### TooltipPaint

**Description:** Called when a tooltip is painted.

**Realm:** Client

**Parameters:**

* `var` (*Panel*): Parameter: var
* `w` (*number*): Parameter: w
* `h` (*number*): Parameter: h

---

### TooltipLayout

**Description:** Called to determine tooltip layout.

**Realm:** Client

**Parameters:**

* `var` (*Panel*): Parameter: var

---

### DrawLiliaModelView

**Description:** Called to draw Lilia model view.

**Realm:** Client

**Parameters:**

* `_` (*any*): Unused parameter
* `entity` (*Entity*): Parameter: entity

---

### OnChatReceived

**Description:** Called when chat is received.

**Realm:** Client

**Parameters:** None

---

### CreateMove

**Description:** Called when creating player movement.

**Realm:** Client

**Parameters:**

* `cmd` (*CUserCmd*): Parameter: cmd

---

### CalcView

**Description:** Called to calculate player view.

**Realm:** Client

**Parameters:**

* `client` (*Player*): Parameter: client
* `origin` (*Vector/Angle/number*): Parameter: origin
* `angles` (*Vector/Angle/number*): Parameter: angles
* `fov` (*Vector/Angle/number*): Parameter: fov

---

### PlayerBindPress

**Description:** Called when a player presses a bind.

**Realm:** Client

**Parameters:**

* `client` (*Player*): Parameter: client
* `bind` (*number*): Parameter: bind
* `pressed` (*any*): Parameter: pressed

---

### ItemShowEntityMenu

**Description:** Called when showing entity menu for an item.

**Realm:** Client

**Parameters:**

* `entity` (*Entity*): Parameter: entity

---

### HUDPaintBackground

**Description:** Called every frame to draw HUD background elements.

**Realm:** Client

**Parameters:** None

---

### OnContextMenuOpen

**Description:** Called when context menu is opened.

**Realm:** Client

**Parameters:** None

---

### OnContextMenuClose

**Description:** Called when context menu is closed.

**Realm:** Client

**Parameters:** None

---

### CharListLoaded

**Description:** Called when character list is loaded.

**Realm:** Client

**Parameters:** None

---

### ForceDermaSkin

**Description:** Called to force derma skin.

**Realm:** Client

**Parameters:** None

---

### DermaSkinChanged

**Description:** Called when derma skin changes.

**Realm:** Client

**Parameters:** None

---

### HUDShouldDraw

**Description:** Called to determine if a HUD element should be drawn.

**Realm:** Client

**Parameters:**

* `element` (*string*): Parameter: element

---

### PrePlayerDraw

**Description:** Called before a player is drawn.

**Realm:** Client

**Parameters:**

* `client` (*Player*): Parameter: client

---

### PlayerStartVoice

**Description:** Called when a player starts talking.

**Realm:** Client

**Parameters:**

* `client` (*Player*): Parameter: client

---

### PlayerEndVoice

**Description:** Called when a player stops talking.

**Realm:** Client

**Parameters:**

* `client` (*Player*): Parameter: client

---

### VoiceToggled

**Description:** Called when voice is toggled.

**Realm:** Client

**Parameters:**

* `enabled` (*boolean*): Parameter: enabled

---

### SpawnMenuOpen

**Description:** Called when spawn menu is opened.

**Realm:** Client

**Parameters:** None

---

### InitPostEntity

**Description:** Called after entities are initialized.

**Realm:** Client

**Parameters:** None

---

### HUDDrawTargetID

**Description:** Called to draw target ID.

**Realm:** Client

**Parameters:** None

---

### HUDDrawPickupHistory

**Description:** Called to draw pickup history.

**Realm:** Client

**Parameters:** None

---

### HUDAmmoPickedUp

**Description:** Called when ammo is picked up.

**Realm:** Client

**Parameters:** None

---

### DrawDeathNotice

**Description:** Called to draw death notice.

**Realm:** Client

**Parameters:** None

---

### RefreshFonts

**Description:** Called to refresh fonts.

**Realm:** Client

**Parameters:** None

---

### GetMainMenuPosition

**Description:** Called to get main menu position.

**Realm:** Client

**Parameters:**

* `character` (*Character*): Parameter: character

---

### ShouldShowPlayerOnScoreboard

**Description:** Called to determine if a player should be shown on the scoreboard.

**Realm:** Client

**Parameters:**

* `ply` (*Player*): The player to check visibility for

**Returns:** `false` to hide the player, any other value (including `nil`) to show the player

**Example Usage:**
```lua
hook.Add("ShouldShowPlayerOnScoreboard", "HideAdmins", function(ply)
    -- Hide staff members from regular players
    if ply:isStaffOnDuty() and not LocalPlayer():isStaffOnDuty() then
        return false
    end
end)
```

---

### ShouldShowFactionOnScoreboard

**Description:** Called to determine if a faction should be shown on the scoreboard for a specific player.

**Realm:** Client

**Parameters:**

* `ply` (*Player*): The player to check faction visibility for

**Returns:** `false` to hide the player's faction, any other value (including `nil`) to show the faction

**Example Usage:**
```lua
hook.Add("ShouldShowFactionOnScoreboard", "HidePoliceFaction", function(ply)
    -- Hide police faction from non-police players
    local char = ply:getChar()
    if char and char:getFaction() == FACTION_POLICE and not LocalPlayer():getChar():getFaction() == FACTION_POLICE then
        return false
    end
end)
```

---

### ShouldShowClassOnScoreboard

**Description:** Called to determine if a class should be shown on the scoreboard.

**Realm:** Client

**Parameters:**

* `classData` (*table*): The class data table to check visibility for

**Returns:** `false` to hide the class, any other value (including `nil`) to show the class

**Example Usage:**
```lua
hook.Add("ShouldShowClassOnScoreboard", "HideEliteClasses", function(classData)
    -- Hide elite classes from regular players
    if classData.isWhitelisted and not LocalPlayer():hasPrivilege("seeEliteClasses") then
        return false
    end
end)
```

---

