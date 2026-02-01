# Configuration

Comprehensive user-configurable settings management system for the Lilia framework.

---

<strong>Overview</strong>

The configuration library provides comprehensive functionality for managing user-configurable settings in the Lilia framework. It handles the creation, storage, retrieval, and persistence of various types of options including boolean toggles, numeric sliders, color pickers, text inputs, and dropdown selections. The library operates on both client and server sides, with automatic persistence to JSON files and optional networking capabilities for server-side options. It includes a complete user interface system for displaying and modifying options through the configuration menu, with support for categories, visibility conditions, and real-time updates. The library ensures that all user preferences are maintained across sessions and provides hooks for modules to react to option changes.

---

<details class="realm-shared">
<summary><a id=lia.config.add></a>lia.config.add(key, name, value, callback, data)</summary>
<div class="details-content">
<a id="liaconfigadd"></a>
<strong>Purpose</strong>
<p>Register a config entry with defaults, UI metadata, and optional callback.</p>

<strong>When Called</strong>
<p>During schema/module initialization to expose server-stored configuration.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Unique identifier for the config entry.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Display text or localization key for UI.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Default value; type inferred when data.type is omitted.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked server-side as callback(oldValue, newValue) after set().</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Fields such as type, desc, category, options/optionsFunc, noNetworking, etc.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.config.add("MaxThirdPersonDistance", "maxThirdPersonDistance", 100, function(old, new)
      lia.option.set("thirdPersonDistance", math.min(lia.option.get("thirdPersonDistance", new), new))
  end, {category = "Lilia", type = "Int", min = 10, max = 200})
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.config.getOptions></a>lia.config.getOptions(key)</summary>
<div class="details-content">
<a id="liaconfiggetoptions"></a>
<strong>Purpose</strong>
<p>Resolve a config entry's selectable options, static list or generated.</p>

<strong>When Called</strong>
<p>Before rendering dropdown-type configs or validating submitted values.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Config key to resolve options for.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Options array or key/value table; empty when unavailable.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local opts = lia.config.getOptions("Theme")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.config.setDefault></a>lia.config.setDefault(key, value)</summary>
<div class="details-content">
<a id="liaconfigsetdefault"></a>
<strong>Purpose</strong>
<p>Override the default value for an already registered config entry.</p>

<strong>When Called</strong>
<p>During migrations, schema overrides, or backward-compatibility fixes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Config key to override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> New default value.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.config.setDefault("StartingMoney", 300)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.config.forceSet></a>lia.config.forceSet(key, value, noSave)</summary>
<div class="details-content">
<a id="liaconfigforceset"></a>
<strong>Purpose</strong>
<p>Force-set a config value and fire update hooks without networking.</p>

<strong>When Called</strong>
<p>Runtime adjustments (admin tools/commands) or hot reload scenarios.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Config key to change.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to assign.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noSave</span> <span class="optional">optional</span> When true, skip persisting to disk.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.config.forceSet("MaxCharacters", 10, false)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.config.set></a>lia.config.set(key, value)</summary>
<div class="details-content">
<a id="liaconfigset"></a>
<strong>Purpose</strong>
<p>Set a config value, fire update hooks, run server callbacks, network to clients, and persist.</p>

<strong>When Called</strong>
<p>Through admin tools/commands or internal code updating configuration.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Config key to change.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to assign and broadcast.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.config.set("RunSpeed", 420)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.config.get></a>lia.config.get(key, default)</summary>
<div class="details-content">
<a id="liaconfigget"></a>
<strong>Purpose</strong>
<p>Retrieve a config value with fallback to its stored default or a provided default.</p>

<strong>When Called</strong>
<p>Anywhere configuration influences gameplay or UI logic.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Config key to read.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Optional fallback when no stored value or default exists.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value, default value, or supplied fallback.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local walkSpeed = lia.config.get("WalkSpeed", 200)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.config.load></a>lia.config.load()</summary>
<div class="details-content">
<a id="liaconfigload"></a>
<strong>Purpose</strong>
<p>Load config values from the database (server) or request them from the server (client).</p>

<strong>When Called</strong>
<p>On initialization to hydrate lia.config.stored after database connectivity.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("DatabaseConnected", "LoadLiliaConfig", lia.config.load)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.config.getChangedValues></a>lia.config.getChangedValues(includeDefaults)</summary>
<div class="details-content">
<a id="liaconfiggetchangedvalues"></a>
<strong>Purpose</strong>
<p>Collect config entries whose values differ from last synced values or their defaults.</p>

<strong>When Called</strong>
<p>Prior to sending incremental config updates to clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">includeDefaults</span> <span class="optional">optional</span> When true, compare against defaults instead of last synced values.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> key → value for configs that changed.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local changed = lia.config.getChangedValues()
  if next(changed) then lia.config.send() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.config.hasChanges></a>lia.config.hasChanges()</summary>
<div class="details-content">
<a id="liaconfighaschanges"></a>
<strong>Purpose</strong>
<p>Check whether any config values differ from the last synced snapshot.</p>

<strong>When Called</strong>
<p>To determine if a resync to clients is required.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True when at least one config value has changed.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.config.hasChanges() then lia.config.send() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.config.send></a>lia.config.send(client)</summary>
<div class="details-content">
<a id="liaconfigsend"></a>
<strong>Purpose</strong>
<p>Send config values to one player (full payload) or broadcast only changed values.</p>

<strong>When Called</strong>
<p>After config changes or when a player joins the server.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Target player for full sync; nil broadcasts only changed values.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("PlayerInitialSpawn", "SyncConfig", function(ply) lia.config.send(ply) end)
  lia.config.send() -- broadcast diffs
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.config.save></a>lia.config.save()</summary>
<div class="details-content">
<a id="liaconfigsave"></a>
<strong>Purpose</strong>
<p>Persist all config values to the database.</p>

<strong>When Called</strong>
<p>After changes, on shutdown, or during scheduled saves.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.config.save()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.config.reset></a>lia.config.reset()</summary>
<div class="details-content">
<a id="liaconfigreset"></a>
<strong>Purpose</strong>
<p>Reset all config values to defaults, then save and sync to clients.</p>

<strong>When Called</strong>
<p>During admin resets or troubleshooting.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.config.reset()
</code></pre>
</div>
</details>

---

