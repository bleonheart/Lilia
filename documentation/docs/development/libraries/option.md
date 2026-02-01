# Option

User-configurable settings management system for the Lilia framework.

---

<strong>Overview</strong>

The option library provides comprehensive functionality for managing user-configurable settings in the Lilia framework. It handles the creation, storage, retrieval, and persistence of various types of options including boolean toggles, numeric sliders, color pickers, text inputs, and dropdown selections. The library operates on both client and server sides, with automatic persistence to JSON files and optional networking capabilities for server-side options. It includes a complete user interface system for displaying and modifying options through the configuration menu, with support for categories, visibility conditions, and real-time updates. The library ensures that all user preferences are maintained across sessions and provides hooks for modules to react to option changes.

---

<details class="realm-shared">
<summary><a id=lia.option.add></a>lia.option.add(key, name, desc, default, callback, data)</summary>
<div class="details-content">
<a id="liaoptionadd"></a>
<strong>Purpose</strong>
<p>Register a configurable option with defaults, callbacks, and metadata.</p>

<strong>When Called</strong>
<p>During initialization to expose settings to the config UI/system.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Option identifier to resolve choices for.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Display name or localization key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">desc</span> Description or localization key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Default value; determines inferred type.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> function(old, new) invoked on change.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Extra fields: category, min/max, options, visible, shouldNetwork, isQuick, type, etc.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.option.add("hudScale", "HUD Scale", "Scale HUD elements", 1.0, function(old, new)
      hook.Run("HUDScaleChanged", old, new)
  end, {
      category = "Core",
      min = 0.5,
      max = 1.5,
      decimals = 2,
      isQuick = true
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.option.getOptions></a>lia.option.getOptions(key)</summary>
<div class="details-content">
<a id="liaoptiongetoptions"></a>
<strong>Purpose</strong>
<p>Resolve option choices (static or generated) for dropdowns.</p>

<strong>When Called</strong>
<p>By the config UI before rendering a Table option.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array/map of options.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local list = lia.option.getOptions("weaponSelectorPosition")
  for _, opt in pairs(list) do print("Choice:", opt) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.option.set></a>lia.option.set(key, value)</summary>
<div class="details-content">
<a id="liaoptionset"></a>
<strong>Purpose</strong>
<p>Set an option value, run callbacks/hooks, persist and optionally network it.</p>

<strong>When Called</strong>
<p>From UI interactions or programmatic changes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.option.set("BarsAlwaysVisible", true)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.option.get></a>lia.option.get(key, default)</summary>
<div class="details-content">
<a id="liaoptionget"></a>
<strong>Purpose</strong>
<p>Retrieve an option value with fallback to default or provided default.</p>

<strong>When Called</strong>
<p>Anywhere an option influences behavior or UI.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local showTime = lia.option.get("ChatShowTime", false)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.option.save></a>lia.option.save()</summary>
<div class="details-content">
<a id="liaoptionsave"></a>
<strong>Purpose</strong>
<p>Persist option values to disk (data/lilia/options.json).</p>

<strong>When Called</strong>
<p>After option changes; auto-called by lia.option.set.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.option.save()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.option.load></a>lia.option.load()</summary>
<div class="details-content">
<a id="liaoptionload"></a>
<strong>Purpose</strong>
<p>Load option values from disk or initialize defaults when missing.</p>

<strong>When Called</strong>
<p>On client init or config menu load.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("Initialize", "LoadLiliaOptions", lia.option.load)
</code></pre>
</div>
</details>

---

