# Character

Character management system for the Lilia framework.

---

<strong>Overview</strong>

The character meta table provides comprehensive functionality for managing character data, attributes, and operations in the Lilia framework. It handles character creation, data persistence, attribute management, recognition systems, and character-specific operations. The meta table operates on both server and client sides, with the server managing character storage and validation while the client provides character data access and display. It includes integration with the database system for character persistence, inventory management for character items, and faction/class systems for character roles. The meta table ensures proper character data synchronization, attribute calculations with boosts, recognition between characters, and comprehensive character lifecycle management from creation to deletion.

---

<details class="realm-shared">
<summary><a id=getID></a>getID()</summary>
<div class="details-content">
<a id="getid"></a>
<strong>Purpose</strong>
<p>Returns this character's unique numeric identifier.</p>

<strong>When Called</strong>
<p>Use when persisting, comparing, or networking character state.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Character ID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local id = char:getID()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getPlayer></a>getPlayer()</summary>
<div class="details-content">
<a id="getplayer"></a>
<strong>Purpose</strong>
<p>Retrieves the player entity associated with this character.</p>

<strong>When Called</strong>
<p>Use whenever you need the live player controlling this character.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|nil</a></span> Player that owns the character, or nil if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ply = char:getPlayer()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getDisplayedName></a>getDisplayedName(client)</summary>
<div class="details-content">
<a id="getdisplayedname"></a>
<strong>Purpose</strong>
<p>Returns the name to show to a viewing client, honoring recognition rules.</p>

<strong>When Called</strong>
<p>Use when rendering a character's name to another player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> The viewer whose recognition determines the name.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Display name or a localized "unknown" placeholder.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local name = targetChar:getDisplayedName(viewer)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasMoney></a>hasMoney(amount)</summary>
<div class="details-content">
<a id="hasmoney"></a>
<strong>Purpose</strong>
<p>Checks if the character has at least the given amount of money.</p>

<strong>When Called</strong>
<p>Use before charging a character to ensure they can afford a cost.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> The amount to verify.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the character's balance is equal or higher.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if char:hasMoney(100) then purchase() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasFlags></a>hasFlags(flagStr)</summary>
<div class="details-content">
<a id="hasflags"></a>
<strong>Purpose</strong>
<p>Determines whether the character possesses any flag in the string.</p>

<strong>When Called</strong>
<p>Use when gating actions behind one or more privilege flags.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flagStr</span> One or more flag characters to test.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if at least one provided flag is present.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if char:hasFlags("ab") then grantAccess() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getAttrib></a>getAttrib(key, default)</summary>
<div class="details-content">
<a id="getattrib"></a>
<strong>Purpose</strong>
<p>Gets the character's attribute value including any active boosts.</p>

<strong>When Called</strong>
<p>Use when calculating rolls or stats that depend on attributes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Attribute identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">default</span> Fallback value if the attribute is missing.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Attribute level plus stacked boosts.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local strength = char:getAttrib("str", 0)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=doesRecognize></a>doesRecognize(id)</summary>
<div class="details-content">
<a id="doesrecognize"></a>
<strong>Purpose</strong>
<p>Determines whether this character recognizes another character.</p>

<strong>When Called</strong>
<p>Use when deciding if a viewer should see a real name or remain unknown.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|table</a></span> <span class="parameter">id</span> Character ID or object implementing getID.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if recognition is allowed by hooks.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if viewerChar:doesRecognize(targetChar) then showName() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=doesFakeRecognize></a>doesFakeRecognize(id)</summary>
<div class="details-content">
<a id="doesfakerecognize"></a>
<strong>Purpose</strong>
<p>Checks if the character recognizes another under a fake name.</p>

<strong>When Called</strong>
<p>Use when evaluating disguise or alias recognition logic.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|table</a></span> <span class="parameter">id</span> Character ID or object implementing getID.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if fake recognition passes custom hooks.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local canFake = char:doesFakeRecognize(otherChar)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=setData></a>setData(k, v, noReplication, receiver)</summary>
<div class="details-content">
<a id="setdata"></a>
<strong>Purpose</strong>
<p>Stores custom data on the character and optionally replicates it.</p>

<strong>When Called</strong>
<p>Use when adding persistent or networked character metadata.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|table</a></span> <span class="parameter">k</span> Key to set or table of key/value pairs.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">v</span> Value to store when k is a string.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noReplication</span> Skip networking when true.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">receiver</span> <span class="optional">optional</span> Specific client to receive the update instead of owner.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:setData("lastLogin", os.time())
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getData></a>getData(key, default)</summary>
<div class="details-content">
<a id="getdata"></a>
<strong>Purpose</strong>
<p>Retrieves previously stored custom character data.</p>

<strong>When Called</strong>
<p>Use when you need saved custom fields or default fallbacks.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> <span class="optional">optional</span> Specific key to fetch or nil for the whole table.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Value to return if the key is unset.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value, default, or entire data table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local note = char:getData("note", "")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=isBanned></a>isBanned()</summary>
<div class="details-content">
<a id="isbanned"></a>
<strong>Purpose</strong>
<p>Reports whether the character is currently banned.</p>

<strong>When Called</strong>
<p>Use when validating character selection or spawning.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if banned permanently or until a future time.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if char:isBanned() then denyJoin() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=recognize></a>recognize(character, name)</summary>
<div class="details-content">
<a id="recognize"></a>
<strong>Purpose</strong>
<p>Marks another character as recognized, optionally storing a fake name.</p>

<strong>When Called</strong>
<p>Invoke when a player learns or is assigned recognition of someone.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|table</a></span> <span class="parameter">character</span> Target character ID or object implementing getID.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> <span class="optional">optional</span> Optional alias to remember instead of real recognition.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True after recognition is recorded.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:recognize(otherChar)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=joinClass></a>joinClass(class, isForced)</summary>
<div class="details-content">
<a id="joinclass"></a>
<strong>Purpose</strong>
<p>Attempts to place the character into the specified class.</p>

<strong>When Called</strong>
<p>Use during class selection or forced reassignment.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">class</span> Class ID to join.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">isForced</span> Skip eligibility checks when true.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the class change succeeded.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ok = char:joinClass(newClassID)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=kickClass></a>kickClass()</summary>
<div class="details-content">
<a id="kickclass"></a>
<strong>Purpose</strong>
<p>Removes the character from its current class, falling back to default.</p>

<strong>When Called</strong>
<p>Use when a class is invalid, revoked, or explicitly left.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:kickClass()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=updateAttrib></a>updateAttrib(key, value)</summary>
<div class="details-content">
<a id="updateattrib"></a>
<strong>Purpose</strong>
<p>Increases an attribute by the given amount, respecting maximums.</p>

<strong>When Called</strong>
<p>Use when awarding experience toward an attribute.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Attribute identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">value</span> Amount to add.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:updateAttrib("stm", 5)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setAttrib></a>setAttrib(key, value)</summary>
<div class="details-content">
<a id="setattrib"></a>
<strong>Purpose</strong>
<p>Directly sets an attribute to a specific value and syncs it.</p>

<strong>When Called</strong>
<p>Use when loading characters or forcing an attribute level.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Attribute identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">value</span> New attribute level.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:setAttrib("str", 15)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addBoost></a>addBoost(boostID, attribID, boostAmount)</summary>
<div class="details-content">
<a id="addboost"></a>
<strong>Purpose</strong>
<p>Adds a temporary boost to an attribute and propagates it.</p>

<strong>When Called</strong>
<p>Use when buffs or debuffs modify an attribute value.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">boostID</span> Unique identifier for the boost source.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">attribID</span> Attribute being boosted.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">boostAmount</span> Amount to add (can be negative).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> Result from setVar update.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:addBoost("stimpack", "end", 2)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removeBoost></a>removeBoost(boostID, attribID)</summary>
<div class="details-content">
<a id="removeboost"></a>
<strong>Purpose</strong>
<p>Removes a previously applied attribute boost.</p>

<strong>When Called</strong>
<p>Use when a buff expires or is cancelled.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">boostID</span> Identifier of the boost source.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">attribID</span> Attribute to adjust.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> Result from setVar update.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:removeBoost("stimpack", "end")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=clearAllBoosts></a>clearAllBoosts()</summary>
<div class="details-content">
<a id="clearallboosts"></a>
<strong>Purpose</strong>
<p>Clears all attribute boosts and notifies listeners.</p>

<strong>When Called</strong>
<p>Use when resetting a character's temporary modifiers.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> Result from resetting the boost table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:clearAllBoosts()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setFlags></a>setFlags(flags)</summary>
<div class="details-content">
<a id="setflags"></a>
<strong>Purpose</strong>
<p>Replaces the character's flag string and synchronizes it.</p>

<strong>When Called</strong>
<p>Use when setting privileges wholesale (e.g., admin changes).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flags</span> Complete set of flags to apply.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:setFlags("abc")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=giveFlags></a>giveFlags(flags)</summary>
<div class="details-content">
<a id="giveflags"></a>
<strong>Purpose</strong>
<p>Adds one or more flags to the character if they are missing.</p>

<strong>When Called</strong>
<p>Use when granting new permissions or perks.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flags</span> Concatenated flag characters to grant.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:giveFlags("z")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=takeFlags></a>takeFlags(flags)</summary>
<div class="details-content">
<a id="takeflags"></a>
<strong>Purpose</strong>
<p>Removes specific flags from the character and triggers callbacks.</p>

<strong>When Called</strong>
<p>Use when revoking privileges or perks.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">flags</span> Concatenated flag characters to remove.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:takeFlags("z")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=save></a>save(callback)</summary>
<div class="details-content">
<a id="save"></a>
<strong>Purpose</strong>
<p>Persists the character's current variables to the database.</p>

<strong>When Called</strong>
<p>Use during saves, character switches, or shutdown to keep data.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked after the save completes.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:save(function() print("saved") end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=sync></a>sync(receiver)</summary>
<div class="details-content">
<a id="sync"></a>
<strong>Purpose</strong>
<p>Sends character data to a specific player or all players.</p>

<strong>When Called</strong>
<p>Use after character creation, load, or when vars change.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">receiver</span> <span class="optional">optional</span> Target player to sync to; nil broadcasts to everyone.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:sync(client)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setup></a>setup(noNetworking)</summary>
<div class="details-content">
<a id="setup"></a>
<strong>Purpose</strong>
<p>Applies the character state to the owning player and optionally syncs.</p>

<strong>When Called</strong>
<p>Use right after a character is loaded or swapped in.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noNetworking</span> Skip inventory and char networking when true.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:setup()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=kick></a>kick()</summary>
<div class="details-content">
<a id="kick"></a>
<strong>Purpose</strong>
<p>Forces the owning player off this character and cleans up state.</p>

<strong>When Called</strong>
<p>Use when removing access, kicking, or swapping characters.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:kick()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=ban></a>ban(time)</summary>
<div class="details-content">
<a id="ban"></a>
<strong>Purpose</strong>
<p>Bans the character for a duration or permanently and kicks them.</p>

<strong>When Called</strong>
<p>Use for disciplinary actions like permakill or timed bans.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> <span class="optional">optional</span> Ban duration in seconds; nil makes it permanent.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:ban(3600)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=delete></a>delete()</summary>
<div class="details-content">
<a id="delete"></a>
<strong>Purpose</strong>
<p>Deletes the character from persistent storage.</p>

<strong>When Called</strong>
<p>Use when a character is intentionally removed by the player or admin.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:delete()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=destroy></a>destroy()</summary>
<div class="details-content">
<a id="destroy"></a>
<strong>Purpose</strong>
<p>Removes the character from the active cache without DB interaction.</p>

<strong>When Called</strong>
<p>Use when unloading a character instance entirely.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:destroy()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=giveMoney></a>giveMoney(amount)</summary>
<div class="details-content">
<a id="givemoney"></a>
<strong>Purpose</strong>
<p>Adds money to the character through the owning player object.</p>

<strong>When Called</strong>
<p>Use when rewarding or refunding currency.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Amount to add (can be negative to deduct).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> False if no valid player exists; otherwise result of addMoney.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:giveMoney(250)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=takeMoney></a>takeMoney(amount)</summary>
<div class="details-content">
<a id="takemoney"></a>
<strong>Purpose</strong>
<p>Deducts money from the character and logs the transaction.</p>

<strong>When Called</strong>
<p>Use when charging a player for purchases or penalties.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Amount to remove; the absolute value is used.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True after the deduction process runs.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  char:takeMoney(50)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=isMainCharacter></a>isMainCharacter()</summary>
<div class="details-content">
<a id="ismaincharacter"></a>
<strong>Purpose</strong>
<p>Checks whether this character matches the player's main character ID.</p>

<strong>When Called</strong>
<p>Use when showing main character indicators or restrictions.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if this character is the player's main selection.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if char:isMainCharacter() then highlight() end
</code></pre>
</div>
</details>

---

