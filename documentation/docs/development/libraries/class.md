# Classes

Character class management and validation system for the Lilia framework.

---

<strong>Overview</strong>

The classes library provides comprehensive functionality for managing character classes in the Lilia framework. It handles registration, validation, and management of player classes within factions. The library operates on both server and client sides, allowing for dynamic class creation, whitelist management, and player class assignment validation. It includes functionality for loading classes from directories, checking class availability, retrieving class information, and managing class limits. The library ensures proper faction validation and provides hooks for custom class behavior and restrictions.

---

<details class="realm-shared">
<summary><a id=lia.class.register></a>lia.class.register(uniqueID, data)</summary>
<div class="details-content">
<a id="liaclassregister"></a>
<strong>Purpose</strong>
<p>Registers or updates a class definition within the global class list.</p>

<strong>When Called</strong>
<p>Invoked during schema initialization or dynamic class creation to
ensure a class entry exists before use.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> Unique identifier for the class; must be consistent across loads.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Class metadata such as name, desc, faction, limit, OnCanBe, etc.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The registered class table with applied defaults.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.class.register("soldier", {
      name = "Soldier",
      faction = FACTION_MILITARY,
      limit = 4
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.loadFromDir></a>lia.class.loadFromDir(directory)</summary>
<div class="details-content">
<a id="liaclassloadfromdir"></a>
<strong>Purpose</strong>
<p>Loads and registers all class definitions from a directory.</p>

<strong>When Called</strong>
<p>Used during schema loading to automatically include class files in a
folder following the naming convention.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">directory</span> Path to the directory containing class Lua files.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.class.loadFromDir("lilia/gamemode/classes")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.canBe></a>lia.class.canBe(client, class)</summary>
<div class="details-content">
<a id="liaclasscanbe"></a>
<strong>Purpose</strong>
<p>Determines whether a client can join a specific class.</p>

<strong>When Called</strong>
<p>Checked before class selection to enforce faction, limits, whitelist,
and custom restrictions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Player attempting to join the class.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">class</span> Class index or unique identifier.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean|string</a></span> False and a reason string on failure; otherwise returns the class's isDefault value.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ok, reason = lia.class.canBe(ply, CLASS_CITIZEN)
  if ok then
      -- proceed with class change
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.get></a>lia.class.get(identifier)</summary>
<div class="details-content">
<a id="liaclassget"></a>
<strong>Purpose</strong>
<p>Retrieves a class table by index or unique identifier.</p>

<strong>When Called</strong>
<p>Used whenever class metadata is needed given a known identifier.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">identifier</span> Class list index or unique identifier.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span> The class table if found; otherwise nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local classData = lia.class.get("soldier")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.getPlayers></a>lia.class.getPlayers(class)</summary>
<div class="details-content">
<a id="liaclassgetplayers"></a>
<strong>Purpose</strong>
<p>Collects all players currently assigned to the given class.</p>

<strong>When Called</strong>
<p>Used when enforcing limits or displaying membership lists.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">class</span> Class list index or unique identifier.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array of player entities in the class.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  for _, ply in ipairs(lia.class.getPlayers("soldier")) do
      -- notify class members
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.getPlayerCount></a>lia.class.getPlayerCount(class)</summary>
<div class="details-content">
<a id="liaclassgetplayercount"></a>
<strong>Purpose</strong>
<p>Counts how many players are in the specified class.</p>

<strong>When Called</strong>
<p>Used to check class limits or display class population.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">class</span> Class list index or unique identifier.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Current number of players in the class.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local count = lia.class.getPlayerCount(CLASS_ENGINEER)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.retrieveClass></a>lia.class.retrieveClass(class)</summary>
<div class="details-content">
<a id="liaclassretrieveclass"></a>
<strong>Purpose</strong>
<p>Finds the class index by matching uniqueID or display name.</p>

<strong>When Called</strong>
<p>Used to resolve user input to a class entry before further lookups.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">class</span> Text to match against class uniqueID or name.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|nil</a></span> The class index if a match is found; otherwise nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local idx = lia.class.retrieveClass("Engineer")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.hasWhitelist></a>lia.class.hasWhitelist(class)</summary>
<div class="details-content">
<a id="liaclasshaswhitelist"></a>
<strong>Purpose</strong>
<p>Checks whether a class uses whitelist access.</p>

<strong>When Called</strong>
<p>Queried before allowing class selection or displaying class info.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">class</span> Class list index or unique identifier.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the class is whitelisted and not default; otherwise false.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.class.hasWhitelist(CLASS_PILOT) then
      -- restrict to whitelisted players
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.class.retrieveJoinable></a>lia.class.retrieveJoinable(client)</summary>
<div class="details-content">
<a id="liaclassretrievejoinable"></a>
<strong>Purpose</strong>
<p>Returns a list of classes the provided client is allowed to join.</p>

<strong>When Called</strong>
<p>Used to build class selection menus and enforce availability.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Target player; defaults to LocalPlayer on the client.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array of class tables the client can currently join.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local options = lia.class.retrieveJoinable(ply)
</code></pre>
</div>
</details>

---

