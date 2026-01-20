# Player Meta

Player management system for the Lilia framework.

---

Overview

The player meta table provides comprehensive functionality for managing player data, interactions, and operations in the Lilia framework. It handles player character access, notification systems, permission checking, data management, interaction systems, and player-specific operations. The meta table operates on both server and client sides, with the server managing player data and validation while the client provides player interaction and display. It includes integration with the character system for character access, notification system for player messages, permission system for access control, data system for player persistence, and interaction system for player actions. The meta table ensures proper player data synchronization, permission validation, notification delivery, and comprehensive player management from connection to disconnection.

---

## Index

- [getChar](#getchar)
- [tostring](#tostring)
- [Name](#name)
- [doGesture](#dogesture)
- [setAction](#setaction)
- [doStaredAction](#dostaredaction)
- [stopAction](#stopaction)
- [hasPrivilege](#hasprivilege)
- [removeRagdoll](#removeragdoll)
- [getItemWeapon](#getitemweapon)
- [isFamilySharedAccount](#isfamilysharedaccount)
- [getItemDropPos](#getitemdroppos)
- [getItems](#getitems)
- [getTracedEntity](#gettracedentity)
- [notify](#notify)
- [notifyLocalized](#notifylocalized)
- [notifyError](#notifyerror)
- [notifyWarning](#notifywarning)
- [notifyInfo](#notifyinfo)
- [notifySuccess](#notifysuccess)
- [notifyMoney](#notifymoney)
- [notifyAdmin](#notifyadmin)
- [notifyErrorLocalized](#notifyerrorlocalized)
- [notifyWarningLocalized](#notifywarninglocalized)
- [notifyInfoLocalized](#notifyinfolocalized)
- [notifySuccessLocalized](#notifysuccesslocalized)
- [notifyMoneyLocalized](#notifymoneylocalized)
- [notifyAdminLocalized](#notifyadminlocalized)
- [canEditVendor](#caneditvendor)
- [isStaff](#isstaff)
- [isStaffOnDuty](#isstaffonduty)
- [hasWhitelist](#haswhitelist)
- [getClassData](#getclassdata)
- [getDarkRPVar](#getdarkrpvar)
- [getMoney](#getmoney)
- [canAfford](#canafford)
- [hasSkillLevel](#hasskilllevel)
- [meetsRequiredSkills](#meetsrequiredskills)
- [forceSequence](#forcesequence)
- [leaveSequence](#leavesequence)
- [getFlags](#getflags)
- [giveFlags](#giveflags)
- [takeFlags](#takeflags)
- [networkAnimation](#networkanimation)
- [getAllLiliaData](#getallliliadata)
- [setWaypoint](#setwaypoint)
- [getLiliaData](#getliliadata)
- [getMainCharacter](#getmaincharacter)
- [setMainCharacter](#setmaincharacter)
- [hasFlags](#hasflags)
- [playTimeGreaterThan](#playtimegreaterthan)
- [requestOptions](#requestoptions)
- [requestString](#requeststring)
- [requestArguments](#requestarguments)
- [requestBinaryQuestion](#requestbinaryquestion)
- [requestPopupQuestion](#requestpopupquestion)
- [requestButtons](#requestbuttons)
- [requestDropdown](#requestdropdown)
- [restoreStamina](#restorestamina)
- [consumeStamina](#consumestamina)
- [addMoney](#addmoney)
- [takeMoney](#takemoney)
- [loadLiliaData](#loadliliadata)
- [saveLiliaData](#saveliliadata)
- [setLiliaData](#setliliadata)
- [banPlayer](#banplayer)
- [getPlayTime](#getplaytime)
- [setRagdolled](#setragdolled)
- [syncVars](#syncvars)
- [setNetVar](#setnetvar)
- [setLocalVar](#setlocalvar)
- [getLocalVar](#getlocalvar)
- [getLocalVar](#getlocalvar)
- [getPlayTime](#getplaytime)

---

<a id="getchar"></a>
### getChar

#### 📋 Purpose
Returns the active character object associated with this player.

#### ⏰ When Called
Use whenever you need the player's character state.

#### ↩️ Returns
* table|nil
Character instance or nil if none is selected.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local char = ply:getChar()

```

---

<a id="tostring"></a>
### tostring

#### 📋 Purpose
Builds a readable name for the player preferring character name.

#### ⏰ When Called
Use for logging or UI when displaying player identity.

#### ↩️ Returns
* string
Character name if available, otherwise Steam name.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    print(ply:tostring())

```

---

<a id="name"></a>
### Name

#### 📋 Purpose
Returns the display name, falling back to Steam name if no character.

#### ⏰ When Called
Use wherever Garry's Mod expects Name/Nick/GetName.

#### ↩️ Returns
* string
Character or Steam name.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local name = ply:Name()

```

---

<a id="dogesture"></a>
### doGesture

#### 📋 Purpose
Restarts a gesture animation and replicates it.

#### ⏰ When Called
Use to play a gesture on the player and sync to others.

#### ⚙️ Parameters

- `a` (number) - Gesture activity.
- `b` (number) - Layer or slot.
- `c` (number) - Playback rate or weight.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:doGesture(ACT_GMOD_GESTURE_WAVE, 0, 1)

```

---

<a id="setaction"></a>
### setAction

#### 📋 Purpose
Shows an action bar for the player and runs a callback when done.

#### ⏰ When Called
Use to gate actions behind a timed progress bar.

#### ⚙️ Parameters

- `text` (string|nil) - Message to display; nil cancels the bar.
- `time` (number) - Duration in seconds.
- `callback` (function|nil) - Invoked when the timer completes.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:setAction("Lockpicking", 5, onFinish)

```

---

<a id="dostaredaction"></a>
### doStaredAction

#### 📋 Purpose
Runs a callback after the player stares at an entity for a duration.

#### ⏰ When Called
Use for interactions requiring sustained aim on a target.

#### ⚙️ Parameters

- `entity` (Entity) - Target entity to watch.
- `callback` (function) - Function called after staring completes.
- `time` (number) - Duration in seconds required.
- `onCancel` (function|nil) - Called if the stare is interrupted.
- `distance` (number|nil) - Max distance trace length.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:doStaredAction(door, onComplete, 3)

```

---

<a id="stopaction"></a>
### stopAction

#### 📋 Purpose
Cancels any active action or stare timers and hides the bar.

#### ⏰ When Called
Use when an action is interrupted or completed early.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:stopAction()

```

---

<a id="hasprivilege"></a>
### hasPrivilege

#### 📋 Purpose
Checks if the player has a specific admin privilege.

#### ⏰ When Called
Use before allowing privileged actions.

#### ⚙️ Parameters

- `privilegeName` (string) - Permission to query.

#### ↩️ Returns
* boolean
True if the player has access.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:hasPrivilege("canBan") then ...

```

---

<a id="removeragdoll"></a>
### removeRagdoll

#### 📋 Purpose
Deletes the player's ragdoll entity and clears the net var.

#### ⏰ When Called
Use when respawning or cleaning up ragdolls.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:removeRagdoll()

```

---

<a id="getitemweapon"></a>
### getItemWeapon

#### 📋 Purpose
Returns the active weapon and matching inventory item if equipped.

#### ⏰ When Called
Use when syncing weapon state with inventory data.

#### ↩️ Returns
* Weapon|nil, Item|nil
Active weapon entity and corresponding item, if found.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local wep, itm = ply:getItemWeapon()

```

---

<a id="isfamilysharedaccount"></a>
### isFamilySharedAccount

#### 📋 Purpose
Detects whether the account is being used via Steam Family Sharing.

#### ⏰ When Called
Use for restrictions or messaging on shared accounts.

#### ↩️ Returns
* boolean
True if OwnerSteamID64 differs from SteamID.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:isFamilySharedAccount() then warn() end

```

---

<a id="getitemdroppos"></a>
### getItemDropPos

#### 📋 Purpose
Calculates a suitable position in front of the player to drop items.

#### ⏰ When Called
Use before spawning a world item.

#### ↩️ Returns
* Vector
Drop position.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local pos = ply:getItemDropPos()

```

---

<a id="getitems"></a>
### getItems

#### 📋 Purpose
Retrieves the player's inventory items if a character exists.

#### ⏰ When Called
Use when accessing a player's item list directly.

#### ↩️ Returns
* table|nil
Items table or nil if no inventory.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local items = ply:getItems()

```

---

<a id="gettracedentity"></a>
### getTracedEntity

#### 📋 Purpose
Returns the entity the player is aiming at within a distance.

#### ⏰ When Called
Use for interaction traces.

#### ⚙️ Parameters

- `distance` (number) - Max trace length; default 96.

#### ↩️ Returns
* Entity|nil
Hit entity or nil.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local ent = ply:getTracedEntity(128)

```

---

<a id="notify"></a>
### notify

#### 📋 Purpose
Sends a notification to this player (or locally on client).

#### ⏰ When Called
Use to display a generic notice.

#### ⚙️ Parameters

- `message` (string) - Text to show.
- `notifType` (string) - Optional type key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notify("Hello")

```

---

<a id="notifylocalized"></a>
### notifyLocalized

#### 📋 Purpose
Sends a localized notification to this player or locally.

#### ⏰ When Called
Use when the message is a localization token.

#### ⚙️ Parameters

- `message` (string) - Localization key.
- `notifType` (string) - Optional type key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyLocalized("itemTaken", "apple")

```

---

<a id="notifyerror"></a>
### notifyError

#### 📋 Purpose
Sends an error notification to this player or locally.

#### ⏰ When Called
Use to display error messages in a consistent style.

#### ⚙️ Parameters

- `message` (string) - Error text.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyError("Invalid action")

```

---

<a id="notifywarning"></a>
### notifyWarning

#### 📋 Purpose
Sends a warning notification to this player or locally.

#### ⏰ When Called
Use for cautionary messages.

#### ⚙️ Parameters

- `message` (string) - Text to display.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyWarning("Low health")

```

---

<a id="notifyinfo"></a>
### notifyInfo

#### 📋 Purpose
Sends an info notification to this player or locally.

#### ⏰ When Called
Use for neutral informational messages.

#### ⚙️ Parameters

- `message` (string) - Text to display.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyInfo("Quest updated")

```

---

<a id="notifysuccess"></a>
### notifySuccess

#### 📋 Purpose
Sends a success notification to this player or locally.

#### ⏰ When Called
Use to indicate successful actions.

#### ⚙️ Parameters

- `message` (string) - Text to display.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifySuccess("Saved")

```

---

<a id="notifymoney"></a>
### notifyMoney

#### 📋 Purpose
Sends a money-themed notification to this player or locally.

#### ⏰ When Called
Use for currency gain/spend messages.

#### ⚙️ Parameters

- `message` (string) - Text to display.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyMoney("+$50")

```

---

<a id="notifyadmin"></a>
### notifyAdmin

#### 📋 Purpose
Sends an admin-level notification to this player or locally.

#### ⏰ When Called
Use for staff-oriented alerts.

#### ⚙️ Parameters

- `message` (string) - Text to display.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyAdmin("Ticket opened")

```

---

<a id="notifyerrorlocalized"></a>
### notifyErrorLocalized

#### 📋 Purpose
Sends a localized error notification to the player or locally.

#### ⏰ When Called
Use for localized error tokens.

#### ⚙️ Parameters

- `key` (string) - Localization key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyErrorLocalized("invalidArg")

```

---

<a id="notifywarninglocalized"></a>
### notifyWarningLocalized

#### 📋 Purpose
Sends a localized warning notification to the player or locally.

#### ⏰ When Called
Use for localized warnings.

#### ⚙️ Parameters

- `key` (string) - Localization key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyWarningLocalized("lowHealth")

```

---

<a id="notifyinfolocalized"></a>
### notifyInfoLocalized

#### 📋 Purpose
Sends a localized info notification to the player or locally.

#### ⏰ When Called
Use for localized informational messages.

#### ⚙️ Parameters

- `key` (string) - Localization key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyInfoLocalized("questUpdate")

```

---

<a id="notifysuccesslocalized"></a>
### notifySuccessLocalized

#### 📋 Purpose
Sends a localized success notification to the player or locally.

#### ⏰ When Called
Use for localized success confirmations.

#### ⚙️ Parameters

- `key` (string) - Localization key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifySuccessLocalized("saved")

```

---

<a id="notifymoneylocalized"></a>
### notifyMoneyLocalized

#### 📋 Purpose
Sends a localized money notification to the player or locally.

#### ⏰ When Called
Use for localized currency messages.

#### ⚙️ Parameters

- `key` (string) - Localization key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyMoneyLocalized("moneyGained", 50)

```

---

<a id="notifyadminlocalized"></a>
### notifyAdminLocalized

#### 📋 Purpose
Sends a localized admin notification to the player or locally.

#### ⏰ When Called
Use for staff messages with localization.

#### ⚙️ Parameters

- `key` (string) - Localization key.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:notifyAdminLocalized("ticketOpened")

```

---

<a id="caneditvendor"></a>
### canEditVendor

#### 📋 Purpose
Checks if the player can edit a vendor.

#### ⏰ When Called
Use before opening vendor edit interfaces.

#### ⚙️ Parameters

- `vendor` (Entity) - Vendor entity to check.

#### ↩️ Returns
* boolean
True if editing is permitted.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:canEditVendor(vendor) then ...

```

---

<a id="isstaff"></a>
### isStaff

#### 📋 Purpose
Determines if the player's user group is marked as Staff.

#### ⏰ When Called
Use for gating staff-only features.

#### ↩️ Returns
* boolean
True if their usergroup includes the Staff type.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:isStaff() then ...

```

---

<a id="isstaffonduty"></a>
### isStaffOnDuty

#### 📋 Purpose
Checks if the player is currently on the staff faction.

#### ⏰ When Called
Use when features apply only to on-duty staff.

#### ↩️ Returns
* boolean
True if the player is in FACTION_STAFF.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:isStaffOnDuty() then ...

```

---

<a id="haswhitelist"></a>
### hasWhitelist

#### 📋 Purpose
Checks if the player has whitelist access to a faction.

#### ⏰ When Called
Use before allowing faction selection.

#### ⚙️ Parameters

- `faction` (number) - Faction ID.

#### ↩️ Returns
* boolean
True if default or whitelisted.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:hasWhitelist(factionID) then ...

```

---

<a id="getclassdata"></a>
### getClassData

#### 📋 Purpose
Retrieves the class table for the player's current character.

#### ⏰ When Called
Use when needing class metadata like limits or permissions.

#### ↩️ Returns
* table|nil
Class definition or nil if unavailable.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local classData = ply:getClassData()

```

---

<a id="getdarkrpvar"></a>
### getDarkRPVar

#### 📋 Purpose
Provides DarkRP compatibility for money queries.

#### ⏰ When Called
Use when DarkRP expects getDarkRPVar("money").

#### ⚙️ Parameters

- `var` (string) - Variable name, only "money" supported.

#### ↩️ Returns
* number|nil
Character money or nil if unsupported var.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local cash = ply:getDarkRPVar("money")

```

---

<a id="getmoney"></a>
### getMoney

#### 📋 Purpose
Returns the character's money or zero if unavailable.

#### ⏰ When Called
Use whenever reading player currency.

#### ↩️ Returns
* number
Current money amount.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local cash = ply:getMoney()

```

---

<a id="canafford"></a>
### canAfford

#### 📋 Purpose
Returns whether the player can afford a cost.

#### ⏰ When Called
Use before charging the player.

#### ⚙️ Parameters

- `amount` (number) - Cost to check.

#### ↩️ Returns
* boolean
True if the player has enough money.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:canAfford(100) then ...

```

---

<a id="hasskilllevel"></a>
### hasSkillLevel

#### 📋 Purpose
Checks if the player meets a specific skill level requirement.

#### ⏰ When Called
Use for gating actions behind skills.

#### ⚙️ Parameters

- `skill` (string) - Attribute key.
- `level` (number) - Required level.

#### ↩️ Returns
* boolean
True if the player meets or exceeds the level.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:hasSkillLevel("lockpick", 3) then ...

```

---

<a id="meetsrequiredskills"></a>
### meetsRequiredSkills

#### 📋 Purpose
Verifies all required skills meet their target levels.

#### ⏰ When Called
Use when checking multiple skill prerequisites.

#### ⚙️ Parameters

- `requiredSkillLevels` (table) - Map of skill keys to required levels.

#### ↩️ Returns
* boolean
True if all requirements pass.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:meetsRequiredSkills(reqs) then ...

```

---

<a id="forcesequence"></a>
### forceSequence

#### 📋 Purpose
Forces the player to play a sequence and freezes movement if needed.

#### ⏰ When Called
Use for scripted animations like sit or interact sequences.

#### ⚙️ Parameters

- `sequenceName` (string|nil) - Sequence to play; nil clears the current sequence.
- `callback` (function|nil) - Called when the sequence ends.
- `time` (number|nil) - Override duration.
- `noFreeze` (boolean) - Prevent movement freeze when true.

#### ↩️ Returns
* number|boolean|nil
Duration when started, false on failure, or nil when clearing.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:forceSequence("sit", nil, 5)

```

---

<a id="leavesequence"></a>
### leaveSequence

#### 📋 Purpose
Stops the forced sequence, unfreezes movement, and runs callbacks.

#### ⏰ When Called
Use when a sequence finishes or must be cancelled.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:leaveSequence()

```

---

<a id="getflags"></a>
### getFlags

#### 📋 Purpose
Returns the flag string from the player's character.

#### ⏰ When Called
Use when checking player permissions.

#### ↩️ Returns
* string
Concatenated flags or empty string.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local flags = ply:getFlags()

```

---

<a id="giveflags"></a>
### giveFlags

#### 📋 Purpose
Grants one or more flags to the player's character.

#### ⏰ When Called
Use when adding privileges.

#### ⚙️ Parameters

- `flags` (string) - Flags to give.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:giveFlags("z")

```

---

<a id="takeflags"></a>
### takeFlags

#### 📋 Purpose
Removes flags from the player's character.

#### ⏰ When Called
Use when revoking privileges.

#### ⚙️ Parameters

- `flags` (string) - Flags to remove.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:takeFlags("z")

```

---

<a id="networkanimation"></a>
### networkAnimation

#### 📋 Purpose
Synchronizes or applies a bone animation state across server/client.

#### ⏰ When Called
Use when enabling or disabling custom bone angles.

#### ⚙️ Parameters

- `active` (boolean) - Whether the animation is active.
- `boneData` (table) - Map of bone names to Angle values.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:networkAnimation(true, bones)

```

---

<a id="getallliliadata"></a>
### getAllLiliaData

#### 📋 Purpose
Returns the table storing Lilia-specific player data.

#### ⏰ When Called
Use when reading or writing persistent player data.

#### ↩️ Returns
* table
Data table per realm.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local data = ply:getAllLiliaData()

```

---

<a id="setwaypoint"></a>
### setWaypoint

#### 📋 Purpose
Sets a waypoint for the player and draws HUD guidance clientside.

#### ⏰ When Called
Use when directing a player to a position or objective.

#### ⚙️ Parameters

- `name` (string) - Label shown on the HUD.
- `vector` (Vector) - Target world position.
- `logo` (string|nil) - Optional material path for the icon.
- `onReach` (function|nil) - Callback fired when the waypoint is reached.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:setWaypoint("Stash", pos)

```

---

<a id="getliliadata"></a>
### getLiliaData

#### 📋 Purpose
Reads stored Lilia player data, returning a default when missing.

#### ⏰ When Called
Use for persistent per-player data such as settings or cooldowns.

#### ⚙️ Parameters

- `key` (string) - Data key to fetch.
- `default` (any) - Value to return when unset.

#### ↩️ Returns
* any
Stored value or default.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local last = ply:getLiliaData("lastIP", "")

```

---

<a id="getmaincharacter"></a>
### getMainCharacter

#### 📋 Purpose
Returns the player's recorded main character ID, if set.

#### ⏰ When Called
Use to highlight or auto-select the main character.

#### ↩️ Returns
* number|nil
Character ID or nil when unset.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    local main = ply:getMainCharacter()

```

---

<a id="setmaincharacter"></a>
### setMainCharacter

#### 📋 Purpose
Sets the player's main character, applying cooldown rules server-side.

#### ⏰ When Called
Use when a player picks or clears their main character.

#### ⚙️ Parameters

- `charID` (number|nil) - Character ID to set, or nil/0 to clear.

#### ↩️ Returns
* boolean, string|nil
True on success, or false with a reason.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:setMainCharacter(charID)

```

---

<a id="hasflags"></a>
### hasFlags

#### 📋 Purpose
Checks if the player (via their character) has any of the given flags.

#### ⏰ When Called
Use when gating actions behind flag permissions.

#### ⚙️ Parameters

- `flags` (string) - One or more flag characters to test.

#### ↩️ Returns
* boolean
True if at least one flag is present.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:hasFlags("z") then ...

```

---

<a id="playtimegreaterthan"></a>
### playTimeGreaterThan

#### 📋 Purpose
Returns true if the player's recorded playtime exceeds a value.

#### ⏰ When Called
Use for requirements based on time played.

#### ⚙️ Parameters

- `time` (number) - Threshold in seconds.

#### ↩️ Returns
* boolean
True if playtime is greater than the threshold.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    if ply:playTimeGreaterThan(3600) then ...

```

---

<a id="requestoptions"></a>
### requestOptions

#### 📋 Purpose
Presents a list of options to the player and returns selected values.

#### ⏰ When Called
Use for multi-choice prompts that may return multiple selections.

#### ⚙️ Parameters

- `title` (string) - Dialog title.
- `subTitle` (string) - Subtitle/description.
- `options` (table) - Array of option labels.
- `limit` (number) - Max selections allowed.
- `callback` (function) - Called with selections when chosen.

#### ↩️ Returns
* deferred|nil
Promise when callback omitted, otherwise nil.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestOptions("Pick", "Choose one", {"A","B"}, 1, cb)

```

---

<a id="requeststring"></a>
### requestString

#### 📋 Purpose
Prompts the player for a string value and returns it.

#### ⏰ When Called
Use when collecting free-form text input.

#### ⚙️ Parameters

- `title` (string) - 
- `subTitle` (string) - 
- `callback` (function|nil) - Receives the string result; optional if using deferred.
- `default` (string|nil) - Prefilled value.

#### ↩️ Returns
* deferred|nil
Promise when callback omitted, otherwise nil.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestString("Name", "Enter name", onDone)

```

---

<a id="requestarguments"></a>
### requestArguments

#### 📋 Purpose
Requests typed arguments from the player based on a specification.

#### ⏰ When Called
Use for admin commands requiring typed input.

#### ⚙️ Parameters

- `title` (string) - Dialog title.
- `argTypes` (table) - Schema describing required arguments.
- `callback` (function|nil) - Receives parsed values; optional if using deferred.

#### ↩️ Returns
* deferred|nil
Promise when callback omitted.

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestArguments("Teleport", spec, cb)

```

---

<a id="requestbinaryquestion"></a>
### requestBinaryQuestion

#### 📋 Purpose
Shows a binary (two-button) question to the player and returns choice.

#### ⏰ When Called
Use for yes/no confirmations.

#### ⚙️ Parameters

- `question` (string) - Prompt text.
- `option1` (string) - Label for first option.
- `option2` (string) - Label for second option.
- `manualDismiss` (boolean) - Require manual close; optional.
- `callback` (function) - Receives 0/1 result.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestBinaryQuestion("Proceed?", "Yes", "No", false, cb)

```

---

<a id="requestpopupquestion"></a>
### requestPopupQuestion

#### 📋 Purpose
Displays a popup question with arbitrary buttons and handles responses.

#### ⏰ When Called
Use for multi-button confirmations or admin prompts.

#### ⚙️ Parameters

- `question` (string) - Prompt text.
- `buttons` (table) - Array of strings or {label, callback} pairs.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestPopupQuestion("Choose", {{"A", cbA}, {"B", cbB}})

```

---

<a id="requestbuttons"></a>
### requestButtons

#### 📋 Purpose
Sends a button list prompt to the player and routes callbacks.

#### ⏰ When Called
Use when a simple list of actions is needed.

#### ⚙️ Parameters

- `title` (string) - Dialog title.
- `buttons` (table) - Array of {text=, callback=} entries.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestButtons("Actions", {{text="A", callback=cb}})

```

---

<a id="requestdropdown"></a>
### requestDropdown

#### 📋 Purpose
Presents a dropdown selection dialog to the player.

#### ⏰ When Called
Use for single-choice option selection.

#### ⚙️ Parameters

- `title` (string) - 
- `subTitle` (string) - 
- `options` (table) - Available options.
- `callback` (function) - Invoked with chosen option.

#### ↩️ Returns
* nil

#### 🌐 Realm
Shared

#### 💡 Example Usage

```lua
    ply:requestDropdown("Pick class", "Choose", opts, cb)

```

---

<a id="restorestamina"></a>
### restoreStamina

#### 📋 Purpose
Restores stamina by an amount, clamping to the character's maximum.

#### ⏰ When Called
Use when giving the player stamina back (e.g., resting or items).

#### ⚙️ Parameters

- `amount` (number) - Stamina to add.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:restoreStamina(10)

```

---

<a id="consumestamina"></a>
### consumeStamina

#### 📋 Purpose
Reduces stamina by an amount and handles exhaustion state.

#### ⏰ When Called
Use when sprinting or performing actions that consume stamina.

#### ⚙️ Parameters

- `amount` (number) - Stamina to subtract.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:consumeStamina(5)

```

---

<a id="addmoney"></a>
### addMoney

#### 📋 Purpose
Adds money to the player's character and logs the change.

#### ⏰ When Called
Use when rewarding currency server-side.

#### ⚙️ Parameters

- `amount` (number) - Amount to add (can be negative via takeMoney).

#### ↩️ Returns
* boolean
False if no character exists.

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:addMoney(50)

```

---

<a id="takemoney"></a>
### takeMoney

#### 📋 Purpose
Removes money from the player's character by delegating to giveMoney.

#### ⏰ When Called
Use when charging the player server-side.

#### ⚙️ Parameters

- `amount` (number) - Amount to deduct.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:takeMoney(20)

```

---

<a id="loadliliadata"></a>
### loadLiliaData

#### 📋 Purpose
Loads persistent Lilia player data from the database.

#### ⏰ When Called
Use during player initial spawn to hydrate data.

#### ⚙️ Parameters

- `callback` (function|nil) - Invoked with loaded data table.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:loadLiliaData()

```

---

<a id="saveliliadata"></a>
### saveLiliaData

#### 📋 Purpose
Persists the player's Lilia data back to the database.

#### ⏰ When Called
Use on disconnect or after updating persistent data.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:saveLiliaData()

```

---

<a id="setliliadata"></a>
### setLiliaData

#### 📋 Purpose
Sets a key in the player's Lilia data, optionally syncing and saving.

#### ⏰ When Called
Use when updating persistent player-specific values.

#### ⚙️ Parameters

- `key` (string) - Data key.
- `value` (any) - Value to store.
- `noNetworking` (boolean) - Skip net sync when true.
- `noSave` (boolean) - Skip immediate DB save when true.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:setLiliaData("lastIP", ip)

```

---

<a id="banplayer"></a>
### banPlayer

#### 📋 Purpose
Records a ban entry and kicks the player with a ban message.

#### ⏰ When Called
Use when banning a player via scripts.

#### ⚙️ Parameters

- `reason` (string) - Ban reason.
- `duration` (number) - Duration in minutes; 0 or nil for perm.
- `banner` (Player|nil) - Staff issuing the ban.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:banPlayer("RDM", 60, admin)

```

---

<a id="getplaytime"></a>
### getPlayTime

#### 📋 Purpose
Returns the player's total playtime in seconds (server calculation).

#### ⏰ When Called
Use for server-side playtime checks.

#### ↩️ Returns
* number
Playtime in seconds.

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    local t = ply:getPlayTime()

```

---

<a id="setragdolled"></a>
### setRagdolled

#### 📋 Purpose
Toggles ragdoll state for the player, handling weapons, timers, and get-up.

#### ⏰ When Called
Use when knocking out or reviving a player.

#### ⚙️ Parameters

- `state` (boolean) - True to ragdoll, false to restore.
- `baseTime` (number|nil) - Duration to stay ragdolled.
- `getUpGrace` (number|nil) - Additional grace time before getting up.
- `getUpMessage` (string|nil) - Action bar text while ragdolled.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:setRagdolled(true, 10)

```

---

<a id="syncvars"></a>
### syncVars

#### 📋 Purpose
Sends all known net variables to this player.

#### ⏰ When Called
Use when a player joins or needs a full resync.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:syncVars()

```

---

<a id="setnetvar"></a>
### setNetVar

#### 📋 Purpose
Sets a networked variable for this player and broadcasts it.

#### ⏰ When Called
Use when updating shared player state.

#### ⚙️ Parameters

- `key` (string) - Variable name.
- `value` (any) - Value to store.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:setNetVar("hasKey", true)

```

---

<a id="setlocalvar"></a>
### setLocalVar

#### 📋 Purpose
Sets a server-local variable for this player and sends it only to them.

#### ⏰ When Called
Use for per-player state that should not broadcast.

#### ⚙️ Parameters

- `key` (string) - Variable name.
- `value` (any) - Value to store.

#### ↩️ Returns
* nil

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    ply:setLocalVar("stamina", 80)

```

---

<a id="getlocalvar"></a>
### getLocalVar

#### 📋 Purpose
Reads a server-local variable for this player.

#### ⏰ When Called
Use when accessing non-networked state.

#### ⚙️ Parameters

- `key` (string) - Variable name.
- `default` (any) - Fallback when unset.

#### ↩️ Returns
* any
Stored value or default.

#### 🌐 Realm
Server

#### 💡 Example Usage

```lua
    local stamina = ply:getLocalVar("stamina", 100)

```

---

<a id="getlocalvar"></a>
### getLocalVar

#### 📋 Purpose
Reads a networked variable for this player on the client.

#### ⏰ When Called
Use clientside when accessing shared netvars.

#### ⚙️ Parameters

- `key` (string) - Variable name.
- `default` (any) - Fallback when unset.

#### ↩️ Returns
* any
Stored value or default.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    local val = ply:getLocalVar("stamina", 0)

```

---

<a id="getplaytime"></a>
### getPlayTime

#### 📋 Purpose
Returns the player's playtime (client-calculated fallback).

#### ⏰ When Called
Use on the client when server data is unavailable.

#### ↩️ Returns
* number
Playtime in seconds.

#### 🌐 Realm
Client

#### 💡 Example Usage

```lua
    local t = ply:getPlayTime()

```

---

