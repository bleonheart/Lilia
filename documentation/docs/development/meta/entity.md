# Entity

Entity management system for the Lilia framework.

---

<strong>Overview</strong>

The entity meta table provides comprehensive functionality for extending Garry's Mod entities with Lilia-specific features and operations. It handles entity identification, sound management, door access control, vehicle ownership, network variable synchronization, and entity-specific operations. The meta table operates on both server and client sides, with the server managing entity data and validation while the client provides entity interaction and display. It includes integration with the door system for access control, vehicle system for ownership management, network system for data synchronization, and sound system for audio playback. The meta table ensures proper entity identification, access control validation, network data synchronization, and comprehensive entity interaction management for doors, vehicles, and other game objects.

---

<details class="realm-shared">
<summary><a id=EmitSound></a>EmitSound(soundName, soundLevel, pitchPercent, volume, channel, flags, dsp)</summary>
<div class="details-content">
<a id="emitsound"></a>
<strong>Purpose</strong>
<p>Detour of Entity:EmitSound that plays a sound from this entity, handling web sound URLs and fallbacks.
This function overrides the base game's EmitSound method to add support for web-sourced audio streams.</p>

<strong>When Called</strong>
<p>Use whenever an entity needs to emit a sound that may be streamed.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">soundName</span> File path or URL to play.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">soundLevel</span> Sound level for attenuation.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">pitchPercent</span> Pitch modifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">volume</span> Volume from 0-100.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">channel</span> Optional sound channel.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">flags</span> Optional emit flags.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">dsp</span> Optional DSP effect index.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True when handled by websound logic; otherwise base emit result.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ent:EmitSound("lilia/websounds/example.mp3", 75)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isProp></a>isProp()</summary>
<div class="details-content">
<a id="isprop"></a>
<strong>Purpose</strong>
<p>Indicates whether this entity is a physics prop.</p>

<strong>When Called</strong>
<p>Use when filtering interactions to physical props only.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the entity class is prop_physics.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ent:isProp() then handleProp(ent) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isItem></a>isItem()</summary>
<div class="details-content">
<a id="isitem"></a>
<strong>Purpose</strong>
<p>Checks if the entity represents a Lilia item.</p>

<strong>When Called</strong>
<p>Use when distinguishing item entities from other entities.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the entity class is lia_item.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ent:isItem() then pickUpItem(ent) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isMoney></a>isMoney()</summary>
<div class="details-content">
<a id="ismoney"></a>
<strong>Purpose</strong>
<p>Checks if the entity is a Lilia money pile.</p>

<strong>When Called</strong>
<p>Use when processing currency pickups or interactions.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the entity class is lia_money.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ent:isMoney() then ent:Remove() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isSimfphysCar></a>isSimfphysCar()</summary>
<div class="details-content">
<a id="issimfphyscar"></a>
<strong>Purpose</strong>
<p>Determines whether the entity belongs to supported vehicle classes.</p>

<strong>When Called</strong>
<p>Use when applying logic specific to Simfphys/LVS vehicles.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the entity is a recognized vehicle type.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ent:isSimfphysCar() then configureVehicle(ent) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=checkDoorAccess></a>checkDoorAccess(client, access)</summary>
<div class="details-content">
<a id="checkdooraccess"></a>
<strong>Purpose</strong>
<p>Verifies whether a client has a specific level of access to a door.</p>

<strong>When Called</strong>
<p>Use when opening menus or performing actions gated by door access.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Player requesting access.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">access</span> Required access level, defaults to DOOR_GUEST.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the client meets the access requirement.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if door:checkDoorAccess(ply, DOOR_OWNER) then openDoor() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=keysOwn></a>keysOwn(client)</summary>
<div class="details-content">
<a id="keysown"></a>
<strong>Purpose</strong>
<p>Assigns vehicle ownership metadata to a player.</p>

<strong>When Called</strong>
<p>Use when a player purchases or claims a vehicle entity.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Player to set as owner.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  vehicle:keysOwn(ply)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=keysLock></a>keysLock()</summary>
<div class="details-content">
<a id="keyslock"></a>
<strong>Purpose</strong>
<p>Locks a vehicle entity via its Fire interface.</p>

<strong>When Called</strong>
<p>Use when a player locks their owned vehicle.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  vehicle:keysLock()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=keysUnLock></a>keysUnLock()</summary>
<div class="details-content">
<a id="keysunlock"></a>
<strong>Purpose</strong>
<p>Unlocks a vehicle entity via its Fire interface.</p>

<strong>When Called</strong>
<p>Use when giving a player access back to their vehicle.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  vehicle:keysUnLock()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getDoorOwner></a>getDoorOwner()</summary>
<div class="details-content">
<a id="getdoorowner"></a>
<strong>Purpose</strong>
<p>Retrieves the owning player for a door or vehicle, if any.</p>

<strong>When Called</strong>
<p>Use when displaying ownership information.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|nil</a></span> Owner entity or nil if unknown.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local owner = door:getDoorOwner()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isLocked></a>isLocked()</summary>
<div class="details-content">
<a id="islocked"></a>
<strong>Purpose</strong>
<p>Returns whether the entity is flagged as locked through net vars.</p>

<strong>When Called</strong>
<p>Use when deciding if interactions should be blocked.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the entity's locked net var is set.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if door:isLocked() then denyUse() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isDoorLocked></a>isDoorLocked()</summary>
<div class="details-content">
<a id="isdoorlocked"></a>
<strong>Purpose</strong>
<p>Checks the underlying lock state of a door entity.</p>

<strong>When Called</strong>
<p>Use when syncing lock visuals or handling use attempts.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the door reports itself as locked.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local locked = door:isDoorLocked()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isFemale></a>isFemale()</summary>
<div class="details-content">
<a id="isfemale"></a>
<strong>Purpose</strong>
<p>Infers whether the entity's model is tagged as female.</p>

<strong>When Called</strong>
<p>Use for gender-specific animations or sounds.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if GetModelGender returns "female".</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ent:isFemale() then setFemaleVoice(ent) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getDoorPartner></a>getDoorPartner()</summary>
<div class="details-content">
<a id="getdoorpartner"></a>
<strong>Purpose</strong>
<p>Finds the paired door entity associated with this door.</p>

<strong>When Called</strong>
<p>Use when syncing double-door behavior or ownership.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity|nil</a></span> Partner door entity when found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local partner = door:getDoorPartner()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=sendNetVar></a>sendNetVar(key, receiver)</summary>
<div class="details-content">
<a id="sendnetvar"></a>
<strong>Purpose</strong>
<p>Sends a networked variable for this entity to one or more clients.</p>

<strong>When Called</strong>
<p>Use immediately after changing lia.net values to sync them.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Net variable name to send.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">receiver</span> <span class="optional">optional</span> Optional player to send to; broadcasts when nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ent:sendNetVar("locked", ply)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=clearNetVars></a>clearNetVars(receiver)</summary>
<div class="details-content">
<a id="clearnetvars"></a>
<strong>Purpose</strong>
<p>Clears all stored net vars for this entity and notifies clients.</p>

<strong>When Called</strong>
<p>Use when an entity is being removed or reset.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">receiver</span> <span class="optional">optional</span> Optional target to notify; broadcasts when nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ent:clearNetVars()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removeDoorAccessData></a>removeDoorAccessData()</summary>
<div class="details-content">
<a id="removedooraccessdata"></a>
<strong>Purpose</strong>
<p>Resets stored door access data and closes any open menus.</p>

<strong>When Called</strong>
<p>Use when clearing door permissions or transferring ownership.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  door:removeDoorAccessData()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setLocked></a>setLocked(state)</summary>
<div class="details-content">
<a id="setlocked"></a>
<strong>Purpose</strong>
<p>Sets the locked net var state for this entity.</p>

<strong>When Called</strong>
<p>Use when toggling lock status server-side.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">state</span> Whether the entity should be considered locked.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  door:setLocked(true)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setKeysNonOwnable></a>setKeysNonOwnable(state)</summary>
<div class="details-content">
<a id="setkeysnonownable"></a>
<strong>Purpose</strong>
<p>Marks an entity as non-ownable for keys/door systems.</p>

<strong>When Called</strong>
<p>Use when preventing selling or owning of a door/vehicle.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">state</span> True to make the entity non-ownable.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  door:setKeysNonOwnable(true)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setNetVar></a>setNetVar(key, value, receiver)</summary>
<div class="details-content">
<a id="setnetvar"></a>
<strong>Purpose</strong>
<p>Stores a networked variable for this entity and notifies listeners.</p>

<strong>When Called</strong>
<p>Use when updating shared entity state that clients need.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Net variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to store and broadcast.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">receiver</span> <span class="optional">optional</span> Optional player to send to; broadcasts when nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ent:setNetVar("color", Color(255, 0, 0))
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setLocalVar></a>setLocalVar(key, value)</summary>
<div class="details-content">
<a id="setlocalvar"></a>
<strong>Purpose</strong>
<p>Saves a local (server-only) variable on the entity.</p>

<strong>When Called</strong>
<p>Use for transient server state that should not be networked.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Local variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to store.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ent:setLocalVar("cooldown", CurTime())
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=getLocalVar></a>getLocalVar(key, default)</summary>
<div class="details-content">
<a id="getlocalvar"></a>
<strong>Purpose</strong>
<p>Reads a server-side local variable stored on the entity.</p>

<strong>When Called</strong>
<p>Use when retrieving transient server-only state.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Local variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Value to return if unset.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored local value or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local cooldown = ent:getLocalVar("cooldown", 0)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=playFollowingSound></a>playFollowingSound(soundPath, volume, shouldFollow, maxDistance, startDelay, minDistance, pitch, soundLevel, dsp)</summary>
<div class="details-content">
<a id="playfollowingsound"></a>
<strong>Purpose</strong>
<p>Plays a web sound locally on the client, optionally following the entity.</p>

<strong>When Called</strong>
<p>Use when the client must play a streamed sound attached to an entity.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">soundPath</span> URL or path to the sound.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">volume</span> Volume from 0-1.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">shouldFollow</span> Whether the sound follows the entity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">maxDistance</span> Maximum audible distance.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">startDelay</span> Delay before playback starts.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">minDistance</span> Minimum distance for attenuation.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">pitch</span> Playback rate multiplier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">soundLevel</span> Optional sound level for attenuation.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">dsp</span> Optional DSP effect index.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  ent:playFollowingSound(url, 1, true, 1200)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isDoor></a>isDoor()</summary>
<div class="details-content">
<a id="isdoor"></a>
<strong>Purpose</strong>
<p>Determines whether this entity should be treated as a door.</p>

<strong>When Called</strong>
<p>Use when applying door-specific logic on an entity.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the entity class matches common door types.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if ent:isDoor() then handleDoor(ent) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getNetVar></a>getNetVar(key, default)</summary>
<div class="details-content">
<a id="getnetvar"></a>
<strong>Purpose</strong>
<p>Retrieves a networked variable stored on this entity.</p>

<strong>When Called</strong>
<p>Use when reading shared entity state on either server or client.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Net variable name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Fallback value if none is set.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored net var or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local locked = ent:getNetVar("locked", false)
</code></pre>
</div>
</details>

---

