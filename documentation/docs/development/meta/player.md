# Player

Player management system for the Lilia framework.

---

<strong>Overview</strong>

The player meta table provides comprehensive functionality for managing player data, interactions, and operations in the Lilia framework. It handles player character access, notification systems, permission checking, data management, interaction systems, and player-specific operations. The meta table operates on both server and client sides, with the server managing player data and validation while the client provides player interaction and display. It includes integration with the character system for character access, notification system for player messages, permission system for access control, data system for player persistence, and interaction system for player actions. The meta table ensures proper player data synchronization, permission validation, notification delivery, and comprehensive player management from connection to disconnection.

---

<details class="realm-shared">
<summary><a id=getChar></a>getChar()</summary>
<div class="details-content">
<a id="getchar"></a>
<strong>Purpose</strong>
<p>Returns the active character object associated with this player.</p>

<strong>When Called</strong>
<p>Use whenever you need the player's character state.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span> Character instance or nil if none is selected.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local char = ply:getChar()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=tostring></a>tostring()</summary>
<div class="details-content">
<a id="tostring"></a>
<strong>Purpose</strong>
<p>Builds a readable name for the player preferring character name.</p>

<strong>When Called</strong>
<p>Use for logging or UI when displaying player identity.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Character name if available, otherwise Steam name.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  print(ply:tostring())
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=Name></a>Name()</summary>
<div class="details-content">
<a id="name"></a>
<strong>Purpose</strong>
<p>Returns the display name, falling back to Steam name if no character.</p>

<strong>When Called</strong>
<p>Use wherever Garry's Mod expects Name/Nick/GetName.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Character or Steam name.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local name = ply:Name()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=doGesture></a>doGesture(a, b, c)</summary>
<div class="details-content">
<a id="dogesture"></a>
<strong>Purpose</strong>
<p>Restarts a gesture animation and replicates it.</p>

<strong>When Called</strong>
<p>Use to play a gesture on the player and sync to others.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">a</span> Gesture activity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">b</span> Layer or slot.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">c</span> Playback rate or weight.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:doGesture(ACT_GMOD_GESTURE_WAVE, 0, 1)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=setAction></a>setAction(text, time, callback)</summary>
<div class="details-content">
<a id="setaction"></a>
<strong>Purpose</strong>
<p>Shows an action bar for the player and runs a callback when done.</p>

<strong>When Called</strong>
<p>Use to gate actions behind a timed progress bar.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> <span class="optional">optional</span> Message to display; nil cancels the bar.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> Duration in seconds.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked when the timer completes.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setAction("Lockpicking", 5, onFinish)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=doStaredAction></a>doStaredAction(entity, callback, time, onCancel, distance)</summary>
<div class="details-content">
<a id="dostaredaction"></a>
<strong>Purpose</strong>
<p>Runs a callback after the player stares at an entity for a duration.</p>

<strong>When Called</strong>
<p>Use for interactions requiring sustained aim on a target.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Target entity to watch.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> Function called after staring completes.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> Duration in seconds required.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">onCancel</span> <span class="optional">optional</span> Called if the stare is interrupted.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">distance</span> <span class="optional">optional</span> Max distance trace length.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:doStaredAction(door, onComplete, 3)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=stopAction></a>stopAction()</summary>
<div class="details-content">
<a id="stopaction"></a>
<strong>Purpose</strong>
<p>Cancels any active action or stare timers and hides the bar.</p>

<strong>When Called</strong>
<p>Use when an action is interrupted or completed early.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:stopAction()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasPrivilege></a>hasPrivilege(privilegeName)</summary>
<div class="details-content">
<a id="hasprivilege"></a>
<strong>Purpose</strong>
<p>Checks if the player has a specific admin privilege.</p>

<strong>When Called</strong>
<p>Use before allowing privileged actions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">privilegeName</span> Permission to query.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the player has access.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:hasPrivilege("canBan") then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=removeRagdoll></a>removeRagdoll()</summary>
<div class="details-content">
<a id="removeragdoll"></a>
<strong>Purpose</strong>
<p>Deletes the player's ragdoll entity and clears the net var.</p>

<strong>When Called</strong>
<p>Use when respawning or cleaning up ragdolls.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removeRagdoll()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItemWeapon></a>getItemWeapon()</summary>
<div class="details-content">
<a id="getitemweapon"></a>
<strong>Purpose</strong>
<p>Returns the active weapon and matching inventory item if equipped.</p>

<strong>When Called</strong>
<p>Use when syncing weapon state with inventory data.</p>

<strong>Returns</strong>
<p>Weapon|nil, Item|nil Active weapon entity and corresponding item, if found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local wep, itm = ply:getItemWeapon()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isFamilySharedAccount></a>isFamilySharedAccount()</summary>
<div class="details-content">
<a id="isfamilysharedaccount"></a>
<strong>Purpose</strong>
<p>Detects whether the account is being used via Steam Family Sharing.</p>

<strong>When Called</strong>
<p>Use for restrictions or messaging on shared accounts.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if OwnerSteamID64 differs from SteamID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:isFamilySharedAccount() then warn() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItemDropPos></a>getItemDropPos()</summary>
<div class="details-content">
<a id="getitemdroppos"></a>
<strong>Purpose</strong>
<p>Calculates a suitable position in front of the player to drop items.</p>

<strong>When Called</strong>
<p>Use before spawning a world item.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> Drop position.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local pos = ply:getItemDropPos()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItems></a>getItems()</summary>
<div class="details-content">
<a id="getitems"></a>
<strong>Purpose</strong>
<p>Retrieves the player's inventory items if a character exists.</p>

<strong>When Called</strong>
<p>Use when accessing a player's item list directly.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span> Items table or nil if no inventory.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local items = ply:getItems()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getTracedEntity></a>getTracedEntity(distance)</summary>
<div class="details-content">
<a id="gettracedentity"></a>
<strong>Purpose</strong>
<p>Returns the entity the player is aiming at within a distance.</p>

<strong>When Called</strong>
<p>Use for interaction traces.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">distance</span> Max trace length; default 96.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity|nil</a></span> Hit entity or nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ent = ply:getTracedEntity(128)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notify></a>notify(message, notifType)</summary>
<div class="details-content">
<a id="notify"></a>
<strong>Purpose</strong>
<p>Sends a notification to this player (or locally on client).</p>

<strong>When Called</strong>
<p>Use to display a generic notice.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Text to show.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">notifType</span> Optional type key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notify("Hello")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyLocalized></a>notifyLocalized(message, notifType)</summary>
<div class="details-content">
<a id="notifylocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use when the message is a localization token.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Localization key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">notifType</span> Optional type key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyLocalized("itemTaken", "apple")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyError></a>notifyError(message)</summary>
<div class="details-content">
<a id="notifyerror"></a>
<strong>Purpose</strong>
<p>Sends an error notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use to display error messages in a consistent style.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Error text.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyError("Invalid action")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyWarning></a>notifyWarning(message)</summary>
<div class="details-content">
<a id="notifywarning"></a>
<strong>Purpose</strong>
<p>Sends a warning notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use for cautionary messages.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Text to display.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyWarning("Low health")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyInfo></a>notifyInfo(message)</summary>
<div class="details-content">
<a id="notifyinfo"></a>
<strong>Purpose</strong>
<p>Sends an info notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use for neutral informational messages.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Text to display.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyInfo("Quest updated")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifySuccess></a>notifySuccess(message)</summary>
<div class="details-content">
<a id="notifysuccess"></a>
<strong>Purpose</strong>
<p>Sends a success notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use to indicate successful actions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Text to display.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifySuccess("Saved")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyMoney></a>notifyMoney(message)</summary>
<div class="details-content">
<a id="notifymoney"></a>
<strong>Purpose</strong>
<p>Sends a money-themed notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use for currency gain/spend messages.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Text to display.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyMoney("+$50")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyAdmin></a>notifyAdmin(message)</summary>
<div class="details-content">
<a id="notifyadmin"></a>
<strong>Purpose</strong>
<p>Sends an admin-level notification to this player or locally.</p>

<strong>When Called</strong>
<p>Use for staff-oriented alerts.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Text to display.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyAdmin("Ticket opened")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyErrorLocalized></a>notifyErrorLocalized(key)</summary>
<div class="details-content">
<a id="notifyerrorlocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized error notification to the player or locally.</p>

<strong>When Called</strong>
<p>Use for localized error tokens.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Localization key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyErrorLocalized("invalidArg")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyWarningLocalized></a>notifyWarningLocalized(key)</summary>
<div class="details-content">
<a id="notifywarninglocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized warning notification to the player or locally.</p>

<strong>When Called</strong>
<p>Use for localized warnings.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Localization key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyWarningLocalized("lowHealth")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyInfoLocalized></a>notifyInfoLocalized(key)</summary>
<div class="details-content">
<a id="notifyinfolocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized info notification to the player or locally.</p>

<strong>When Called</strong>
<p>Use for localized informational messages.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Localization key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyInfoLocalized("questUpdate")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifySuccessLocalized></a>notifySuccessLocalized(key)</summary>
<div class="details-content">
<a id="notifysuccesslocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized success notification to the player or locally.</p>

<strong>When Called</strong>
<p>Use for localized success confirmations.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Localization key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifySuccessLocalized("saved")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyMoneyLocalized></a>notifyMoneyLocalized(key)</summary>
<div class="details-content">
<a id="notifymoneylocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized money notification to the player or locally.</p>

<strong>When Called</strong>
<p>Use for localized currency messages.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Localization key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyMoneyLocalized("moneyGained", 50)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=notifyAdminLocalized></a>notifyAdminLocalized(key)</summary>
<div class="details-content">
<a id="notifyadminlocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized admin notification to the player or locally.</p>

<strong>When Called</strong>
<p>Use for staff messages with localization.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Localization key.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:notifyAdminLocalized("ticketOpened")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=canEditVendor></a>canEditVendor(vendor)</summary>
<div class="details-content">
<a id="caneditvendor"></a>
<strong>Purpose</strong>
<p>Checks if the player can edit a vendor.</p>

<strong>When Called</strong>
<p>Use before opening vendor edit interfaces.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">vendor</span> Vendor entity to check.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if editing is permitted.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:canEditVendor(vendor) then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isStaff></a>isStaff()</summary>
<div class="details-content">
<a id="isstaff"></a>
<strong>Purpose</strong>
<p>Determines if the player's user group is marked as Staff.</p>

<strong>When Called</strong>
<p>Use for gating staff-only features.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if their usergroup includes the Staff type.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:isStaff() then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isStaffOnDuty></a>isStaffOnDuty()</summary>
<div class="details-content">
<a id="isstaffonduty"></a>
<strong>Purpose</strong>
<p>Checks if the player is currently on the staff faction.</p>

<strong>When Called</strong>
<p>Use when features apply only to on-duty staff.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the player is in FACTION_STAFF.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:isStaffOnDuty() then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasWhitelist></a>hasWhitelist(faction)</summary>
<div class="details-content">
<a id="haswhitelist"></a>
<strong>Purpose</strong>
<p>Checks if the player has whitelist access to a faction.</p>

<strong>When Called</strong>
<p>Use before allowing faction selection.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">faction</span> Faction ID.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if default or whitelisted.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:hasWhitelist(factionID) then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getClassData></a>getClassData()</summary>
<div class="details-content">
<a id="getclassdata"></a>
<strong>Purpose</strong>
<p>Retrieves the class table for the player's current character.</p>

<strong>When Called</strong>
<p>Use when needing class metadata like limits or permissions.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span> Class definition or nil if unavailable.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local classData = ply:getClassData()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getDarkRPVar></a>getDarkRPVar(var)</summary>
<div class="details-content">
<a id="getdarkrpvar"></a>
<strong>Purpose</strong>
<p>Provides DarkRP compatibility for money queries.</p>

<strong>When Called</strong>
<p>Use when DarkRP expects getDarkRPVar("money").</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">var</span> Variable name, only "money" supported.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|nil</a></span> Character money or nil if unsupported var.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local cash = ply:getDarkRPVar("money")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getMoney></a>getMoney()</summary>
<div class="details-content">
<a id="getmoney"></a>
<strong>Purpose</strong>
<p>Returns the character's money or zero if unavailable.</p>

<strong>When Called</strong>
<p>Use whenever reading player currency.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Current money amount.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local cash = ply:getMoney()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=canAfford></a>canAfford(amount)</summary>
<div class="details-content">
<a id="canafford"></a>
<strong>Purpose</strong>
<p>Returns whether the player can afford a cost.</p>

<strong>When Called</strong>
<p>Use before charging the player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Cost to check.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the player has enough money.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:canAfford(100) then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasSkillLevel></a>hasSkillLevel(skill, level)</summary>
<div class="details-content">
<a id="hasskilllevel"></a>
<strong>Purpose</strong>
<p>Checks if the player meets a specific skill level requirement.</p>

<strong>When Called</strong>
<p>Use for gating actions behind skills.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">skill</span> Attribute key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">level</span> Required level.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the player meets or exceeds the level.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:hasSkillLevel("lockpick", 3) then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=meetsRequiredSkills></a>meetsRequiredSkills(requiredSkillLevels)</summary>
<div class="details-content">
<a id="meetsrequiredskills"></a>
<strong>Purpose</strong>
<p>Verifies all required skills meet their target levels.</p>

<strong>When Called</strong>
<p>Use when checking multiple skill prerequisites.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">requiredSkillLevels</span> Map of skill keys to required levels.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if all requirements pass.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:meetsRequiredSkills(reqs) then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=forceSequence></a>forceSequence(sequenceName, callback, time, noFreeze)</summary>
<div class="details-content">
<a id="forcesequence"></a>
<strong>Purpose</strong>
<p>Forces the player to play a sequence and freezes movement if needed.</p>

<strong>When Called</strong>
<p>Use for scripted animations like sit or interact sequences.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">sequenceName</span> <span class="optional">optional</span> Sequence to play; nil clears the current sequence.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Called when the sequence ends.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> <span class="optional">optional</span> Override duration.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noFreeze</span> Prevent movement freeze when true.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|boolean|nil</a></span> Duration when started, false on failure, or nil when clearing.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:forceSequence("sit", nil, 5)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=leaveSequence></a>leaveSequence()</summary>
<div class="details-content">
<a id="leavesequence"></a>
<strong>Purpose</strong>
<p>Stops the forced sequence, unfreezes movement, and runs callbacks.</p>

<strong>When Called</strong>
<p>Use when a sequence finishes or must be cancelled.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:leaveSequence()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getFlags></a>getFlags()</summary>
<div class="details-content">
<a id="getflags"></a>
<strong>Purpose</strong>
<p>Returns the flag string from the player's character.</p>

<strong>When Called</strong>
<p>Use when checking player permissions.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Concatenated flags or empty string.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local flags = ply:getFlags()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=giveFlags></a>giveFlags(flags)</summary>
<div class="details-content">
<a id="giveflags"></a>
<strong>Purpose</strong>
<p>Grants one or more flags to the player's character.</p>

<strong>When Called</strong>
<p>Use when adding privileges.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flags</span> Flags to give.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:giveFlags("z")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=takeFlags></a>takeFlags(flags)</summary>
<div class="details-content">
<a id="takeflags"></a>
<strong>Purpose</strong>
<p>Removes flags from the player's character.</p>

<strong>When Called</strong>
<p>Use when revoking privileges.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flags</span> Flags to remove.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:takeFlags("z")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=networkAnimation></a>networkAnimation(active, boneData)</summary>
<div class="details-content">
<a id="networkanimation"></a>
<strong>Purpose</strong>
<p>Synchronizes or applies a bone animation state across server/client.</p>

<strong>When Called</strong>
<p>Use when enabling or disabling custom bone angles.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">active</span> Whether the animation is active.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">boneData</span> Map of bone names to Angle values.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:networkAnimation(true, bones)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getAllLiliaData></a>getAllLiliaData()</summary>
<div class="details-content">
<a id="getallliliadata"></a>
<strong>Purpose</strong>
<p>Returns the table storing Lilia-specific player data.</p>

<strong>When Called</strong>
<p>Use when reading or writing persistent player data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Data table per realm.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local data = ply:getAllLiliaData()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=setWaypoint></a>setWaypoint(name, vector, logo, onReach)</summary>
<div class="details-content">
<a id="setwaypoint"></a>
<strong>Purpose</strong>
<p>Sets a waypoint for the player and draws HUD guidance clientside.</p>

<strong>When Called</strong>
<p>Use when directing a player to a position or objective.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Label shown on the HUD.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> <span class="parameter">vector</span> Target world position.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">logo</span> <span class="optional">optional</span> Optional material path for the icon.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">onReach</span> <span class="optional">optional</span> Callback fired when the waypoint is reached.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setWaypoint("Stash", pos)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getLiliaData></a>getLiliaData(key, default)</summary>
<div class="details-content">
<a id="getliliadata"></a>
<strong>Purpose</strong>
<p>Reads stored Lilia player data, returning a default when missing.</p>

<strong>When Called</strong>
<p>Use for persistent per-player data such as settings or cooldowns.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to fetch.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Value to return when unset.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local last = ply:getLiliaData("lastIP", "")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getMainCharacter></a>getMainCharacter()</summary>
<div class="details-content">
<a id="getmaincharacter"></a>
<strong>Purpose</strong>
<p>Returns the player's recorded main character ID, if set.</p>

<strong>When Called</strong>
<p>Use to highlight or auto-select the main character.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|nil</a></span> Character ID or nil when unset.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local main = ply:getMainCharacter()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=setMainCharacter></a>setMainCharacter(charID)</summary>
<div class="details-content">
<a id="setmaincharacter"></a>
<strong>Purpose</strong>
<p>Sets the player's main character, applying cooldown rules server-side.</p>

<strong>When Called</strong>
<p>Use when a player picks or clears their main character.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">charID</span> <span class="optional">optional</span> Character ID to set, or nil/0 to clear.</p>

<strong>Returns</strong>
<p>boolean, string|nil True on success, or false with a reason.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setMainCharacter(charID)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasFlags></a>hasFlags(flags)</summary>
<div class="details-content">
<a id="hasflags"></a>
<strong>Purpose</strong>
<p>Checks if the player (via their character) has any of the given flags.</p>

<strong>When Called</strong>
<p>Use when gating actions behind flag permissions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flags</span> One or more flag characters to test.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if at least one flag is present.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:hasFlags("z") then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=playTimeGreaterThan></a>playTimeGreaterThan(time)</summary>
<div class="details-content">
<a id="playtimegreaterthan"></a>
<strong>Purpose</strong>
<p>Returns true if the player's recorded playtime exceeds a value.</p>

<strong>When Called</strong>
<p>Use for requirements based on time played.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> Threshold in seconds.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if playtime is greater than the threshold.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ply:playTimeGreaterThan(3600) then ...
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestOptions></a>requestOptions(title, subTitle, options, limit, callback)</summary>
<div class="details-content">
<a id="requestoptions"></a>
<strong>Purpose</strong>
<p>Presents a list of options to the player and returns selected values.</p>

<strong>When Called</strong>
<p>Use for multi-choice prompts that may return multiple selections.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> Dialog title.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">subTitle</span> Subtitle/description.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Array of option labels.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">limit</span> Max selections allowed.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> Called with selections when chosen.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">deferred|nil</a></span> Promise when callback omitted, otherwise nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestOptions("Pick", "Choose one", {"A","B"}, 1, cb)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestString></a>requestString(title, subTitle, callback, default)</summary>
<div class="details-content">
<a id="requeststring"></a>
<strong>Purpose</strong>
<p>Prompts the player for a string value and returns it.</p>

<strong>When Called</strong>
<p>Use when collecting free-form text input.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">subTitle</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Receives the string result; optional if using deferred.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">default</span> <span class="optional">optional</span> Prefilled value.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">deferred|nil</a></span> Promise when callback omitted, otherwise nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestString("Name", "Enter name", onDone)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestArguments></a>requestArguments(title, argTypes, callback)</summary>
<div class="details-content">
<a id="requestarguments"></a>
<strong>Purpose</strong>
<p>Requests typed arguments from the player based on a specification.</p>

<strong>When Called</strong>
<p>Use for admin commands requiring typed input.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> Dialog title.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">argTypes</span> Schema describing required arguments.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Receives parsed values; optional if using deferred.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">deferred|nil</a></span> Promise when callback omitted.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestArguments("Teleport", spec, cb)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestBinaryQuestion></a>requestBinaryQuestion(question, option1, option2, manualDismiss, callback)</summary>
<div class="details-content">
<a id="requestbinaryquestion"></a>
<strong>Purpose</strong>
<p>Shows a binary (two-button) question to the player and returns choice.</p>

<strong>When Called</strong>
<p>Use for yes/no confirmations.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">question</span> Prompt text.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">option1</span> Label for first option.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">option2</span> Label for second option.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">manualDismiss</span> Require manual close; optional.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> Receives 0/1 result.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestBinaryQuestion("Proceed?", "Yes", "No", false, cb)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestPopupQuestion></a>requestPopupQuestion(question, buttons)</summary>
<div class="details-content">
<a id="requestpopupquestion"></a>
<strong>Purpose</strong>
<p>Displays a popup question with arbitrary buttons and handles responses.</p>

<strong>When Called</strong>
<p>Use for multi-button confirmations or admin prompts.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">question</span> Prompt text.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">buttons</span> Array of strings or {label, callback} pairs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestPopupQuestion("Choose", {{"A", cbA}, {"B", cbB}})
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestButtons></a>requestButtons(title, buttons)</summary>
<div class="details-content">
<a id="requestbuttons"></a>
<strong>Purpose</strong>
<p>Sends a button list prompt to the player and routes callbacks.</p>

<strong>When Called</strong>
<p>Use when a simple list of actions is needed.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span> Dialog title.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">buttons</span> Array of {text=, callback=} entries.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestButtons("Actions", {{text="A", callback=cb}})
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=requestDropdown></a>requestDropdown(title, subTitle, options, callback)</summary>
<div class="details-content">
<a id="requestdropdown"></a>
<strong>Purpose</strong>
<p>Presents a dropdown selection dialog to the player.</p>

<strong>When Called</strong>
<p>Use for single-choice option selection.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">title</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">subTitle</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Available options.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> Invoked with chosen option.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:requestDropdown("Pick class", "Choose", opts, cb)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=restoreStamina></a>restoreStamina(amount)</summary>
<div class="details-content">
<a id="restorestamina"></a>
<strong>Purpose</strong>
<p>Restores stamina by an amount, clamping to the character's maximum.</p>

<strong>When Called</strong>
<p>Use when giving the player stamina back (e.g., resting or items).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Stamina to add.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:restoreStamina(10)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=consumeStamina></a>consumeStamina(amount)</summary>
<div class="details-content">
<a id="consumestamina"></a>
<strong>Purpose</strong>
<p>Reduces stamina by an amount and handles exhaustion state.</p>

<strong>When Called</strong>
<p>Use when sprinting or performing actions that consume stamina.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Stamina to subtract.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:consumeStamina(5)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addMoney></a>addMoney(amount)</summary>
<div class="details-content">
<a id="addmoney"></a>
<strong>Purpose</strong>
<p>Adds money to the player's character and logs the change.</p>

<strong>When Called</strong>
<p>Use when rewarding currency server-side.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Amount to add (can be negative via takeMoney).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> False if no character exists.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addMoney(50)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=takeMoney></a>takeMoney(amount)</summary>
<div class="details-content">
<a id="takemoney"></a>
<strong>Purpose</strong>
<p>Removes money from the player's character by delegating to giveMoney.</p>

<strong>When Called</strong>
<p>Use when charging the player server-side.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Amount to deduct.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:takeMoney(20)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=loadLiliaData></a>loadLiliaData(callback)</summary>
<div class="details-content">
<a id="loadliliadata"></a>
<strong>Purpose</strong>
<p>Loads persistent Lilia player data from the database.</p>

<strong>When Called</strong>
<p>Use during player initial spawn to hydrate data.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked with loaded data table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:loadLiliaData()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=saveLiliaData></a>saveLiliaData()</summary>
<div class="details-content">
<a id="saveliliadata"></a>
<strong>Purpose</strong>
<p>Persists the player's Lilia data back to the database.</p>

<strong>When Called</strong>
<p>Use on disconnect or after updating persistent data.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:saveLiliaData()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setLiliaData></a>setLiliaData(key, value, noNetworking, noSave)</summary>
<div class="details-content">
<a id="setliliadata"></a>
<strong>Purpose</strong>
<p>Sets a key in the player's Lilia data, optionally syncing and saving.</p>

<strong>When Called</strong>
<p>Use when updating persistent player-specific values.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to store.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noNetworking</span> Skip net sync when true.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noSave</span> Skip immediate DB save when true.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setLiliaData("lastIP", ip)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=banPlayer></a>banPlayer(reason, duration, banner)</summary>
<div class="details-content">
<a id="banplayer"></a>
<strong>Purpose</strong>
<p>Records a ban entry and kicks the player with a ban message.</p>

<strong>When Called</strong>
<p>Use when banning a player via scripts.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">reason</span> Ban reason.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">duration</span> Duration in minutes; 0 or nil for perm.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">banner</span> <span class="optional">optional</span> Staff issuing the ban.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:banPlayer("RDM", 60, admin)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=getPlayTime></a>getPlayTime()</summary>
<div class="details-content">
<a id="getplaytime"></a>
<strong>Purpose</strong>
<p>Returns the player's total playtime in seconds (server calculation).</p>

<strong>When Called</strong>
<p>Use for server-side playtime checks.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Playtime in seconds.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local t = ply:getPlayTime()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setRagdolled></a>setRagdolled(state, baseTime, getUpGrace, getUpMessage)</summary>
<div class="details-content">
<a id="setragdolled"></a>
<strong>Purpose</strong>
<p>Toggles ragdoll state for the player, handling weapons, timers, and get-up.</p>

<strong>When Called</strong>
<p>Use when knocking out or reviving a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">state</span> True to ragdoll, false to restore.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">baseTime</span> <span class="optional">optional</span> Duration to stay ragdolled.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">getUpGrace</span> <span class="optional">optional</span> Additional grace time before getting up.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">getUpMessage</span> <span class="optional">optional</span> Action bar text while ragdolled.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setRagdolled(true, 10)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncVars></a>syncVars()</summary>
<div class="details-content">
<a id="syncvars"></a>
<strong>Purpose</strong>
<p>Sends all known net variables to this player.</p>

<strong>When Called</strong>
<p>Use when a player joins or needs a full resync.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncVars()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setNetVar></a>setNetVar(key, value)</summary>
<div class="details-content">
<a id="setnetvar"></a>
<strong>Purpose</strong>
<p>Sets a networked variable for this player and broadcasts it.</p>

<strong>When Called</strong>
<p>Use when updating shared player state.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to store.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setNetVar("hasKey", true)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setLocalVar></a>setLocalVar(key, value)</summary>
<div class="details-content">
<a id="setlocalvar"></a>
<strong>Purpose</strong>
<p>Sets a server-local variable for this player and sends it only to them.</p>

<strong>When Called</strong>
<p>Use for per-player state that should not broadcast.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to store.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:setLocalVar("stamina", 80)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=getLocalVar></a>getLocalVar(key, default)</summary>
<div class="details-content">
<a id="getlocalvar"></a>
<strong>Purpose</strong>
<p>Reads a server-local variable for this player.</p>

<strong>When Called</strong>
<p>Use when accessing non-networked state.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Fallback when unset.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local stamina = ply:getLocalVar("stamina", 100)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=getLocalVar></a>getLocalVar(key, default)</summary>
<div class="details-content">
<a id="getlocalvar"></a>
<strong>Purpose</strong>
<p>Reads a networked variable for this player on the client.</p>

<strong>When Called</strong>
<p>Use clientside when accessing shared netvars.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Fallback when unset.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local val = ply:getLocalVar("stamina", 0)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=getPlayTime></a>getPlayTime()</summary>
<div class="details-content">
<a id="getplaytime"></a>
<strong>Purpose</strong>
<p>Returns the player's playtime (client-calculated fallback).</p>

<strong>When Called</strong>
<p>Use on the client when server data is unavailable.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Playtime in seconds.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local t = ply:getPlayTime()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getParts></a>getParts()</summary>
<div class="details-content">
<a id="getparts"></a>
<strong>Purpose</strong>
<p>Returns the player's active PAC parts.</p>

<strong>When Called</strong>
<p>Use to check which PAC parts are currently equipped on the player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">table</a></span> Table of active PAC part IDs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local parts = ply:getParts()
  if parts["helmet"] then
      print("Player has helmet equipped")
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncParts></a>syncParts()</summary>
<div class="details-content">
<a id="syncparts"></a>
<strong>Purpose</strong>
<p>Synchronizes the player's PAC parts with the client.</p>

<strong>When Called</strong>
<p>Use to ensure the client has the correct PAC parts data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:syncParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addPart></a>addPart(partID)</summary>
<div class="details-content">
<a id="addpart"></a>
<strong>Purpose</strong>
<p>Adds a PAC part to the player.</p>

<strong>When Called</strong>
<p>Use when equipping PAC parts on a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:addPart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removePart></a>removePart(partID)</summary>
<div class="details-content">
<a id="removepart"></a>
<strong>Purpose</strong>
<p>Removes a PAC part from the player.</p>

<strong>When Called</strong>
<p>Use when unequipping PAC parts from a player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.1">string</a></span> <span class="parameter">partID</span> The unique ID of the PAC part to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:removePart("helmet_model")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=resetParts></a>resetParts()</summary>
<div class="details-content">
<a id="resetparts"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=IsAvailable></a>IsAvailable()</summary>
<div class="details-content">
<a id="isavailable"></a>
<strong>Purpose</strong>
<p>Removes all PAC parts from the player.</p>

<strong>When Called</strong>
<p>Use to clear all equipped PAC parts from a player.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">None.</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ply:resetParts()
</code></pre>
</div>
</details>

---

