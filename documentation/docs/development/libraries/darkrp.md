# DarkRP

The DarkRP compatibility library provides essential functions for maintaining compatibility

---

<details class="realm-server">
<summary><a id=lia.darkrp.isEmpty></a>lia.darkrp.isEmpty(position, entitiesToIgnore)</summary>
<div class="details-content">
<a id="liadarkrpisempty"></a>
<strong>Purpose</strong>
<p>Determine whether a position is free of solid contents, players, NPCs, or props.</p>

<strong>When Called</strong>
<p>Before spawning DarkRP-style shipments or entities to ensure the destination is clear.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> <span class="parameter">position</span> World position to test.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">entitiesToIgnore</span> <span class="optional">optional</span> Optional list of entities that should be excluded from the collision check.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> true when the spot contains no blocking contents or entities; otherwise false.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local spawnPos = ent:GetPos() + Vector(0, 0, 16)
  if lia.darkrp.isEmpty(spawnPos) then
      lia.darkrp.createEntity("Ammo Crate", {ent = "item_ammo_crate", model = "models/Items/ammocrate_smg1.mdl"})
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.darkrp.findEmptyPos></a>lia.darkrp.findEmptyPos(startPos, entitiesToIgnore, maxDistance, searchStep, checkArea)</summary>
<div class="details-content">
<a id="liadarkrpfindemptypos"></a>
<strong>Purpose</strong>
<p>Locate the nearest empty position around a starting point within a search radius.</p>

<strong>When Called</strong>
<p>Selecting safe fallback positions for DarkRP-style shipments or NPC spawns.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> <span class="parameter">startPos</span> Origin position to test first.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">entitiesToIgnore</span> <span class="optional">optional</span> Optional list of entities to ignore while searching.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">maxDistance</span> Maximum distance to search away from the origin.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">searchStep</span> Increment used when expanding the search radius.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> <span class="parameter">checkArea</span> Additional offset tested to ensure enough clearance (for hull height, etc.).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> First empty position discovered; if none found, returns startPos.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local spawnPos = lia.darkrp.findEmptyPos(requestPos, nil, 256, 16, Vector(0, 0, 32))
  npc:SetPos(spawnPos)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.darkrp.notify></a>lia.darkrp.notify(client, notifyType, duration, message)</summary>
<div class="details-content">
<a id="liadarkrpnotify"></a>
<strong>Purpose</strong>
<p>Provide a DarkRP-compatible wrapper for Lilia's localized notify system.</p>

<strong>When Called</strong>
<p>From DarkRP addons or compatibility code that expects DarkRP.notify to exist.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Recipient of the notification.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">notifyType</span> Unused legacy parameter kept for API parity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">duration</span> Unused legacy parameter kept for API parity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> Localization key or message to pass to Lilia's notifier.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.darkrp.notify(ply, NOTIFY_GENERIC, 4, "You received a paycheck.")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.darkrp.textWrap></a>lia.darkrp.textWrap(text, fontName, maxLineWidth)</summary>
<div class="details-content">
<a id="liadarkrptextwrap"></a>
<strong>Purpose</strong>
<p>Wrap long text to a maximum line width based on the active surface font metrics.</p>

<strong>When Called</strong>
<p>Preparing DarkRP-compatible messages for HUD or chat rendering without overflow.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Message to wrap.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">fontName</span> Name of the font to measure.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">maxLineWidth</span> Maximum pixel width allowed per line before inserting a newline.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Wrapped text with newline characters inserted.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local wrapped = lia.darkrp.textWrap("A very long notice message...", "DermaDefault", 240)
  chat.AddText(color_white, wrapped)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.darkrp.formatMoney></a>lia.darkrp.formatMoney(amount)</summary>
<div class="details-content">
<a id="liadarkrpformatmoney"></a>
<strong>Purpose</strong>
<p>Format a currency amount using Lilia's currency system while matching DarkRP's API.</p>

<strong>When Called</strong>
<p>Anywhere DarkRP.formatMoney is expected by compatibility layers or addons.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Currency amount to format.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Localized and formatted currency string.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local paycheck = DarkRP.formatMoney(500)
  chat.AddText(L("paydayReceived", paycheck))
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.darkrp.createEntity></a>lia.darkrp.createEntity(name, data)</summary>
<div class="details-content">
<a id="liadarkrpcreateentity"></a>
<strong>Purpose</strong>
<p>Register a DarkRP entity definition as a Lilia item for compatibility.</p>

<strong>When Called</strong>
<p>While converting DarkRP shipments or entities into Lilia items at load time.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Display name for the item.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Supported fields: cmd, ent, model, desc, price, category.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.darkrp.createEntity("Ammo Crate", {
      ent = "item_ammo_crate",
      model = "models/Items/ammocrate_smg1.mdl",
      price = 750,
      category = "Supplies"
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.darkrp.createCategory></a>lia.darkrp.createCategory()</summary>
<div class="details-content">
<a id="liadarkrpcreatecategory"></a>
<strong>Purpose</strong>
<p>Provide an API stub for DarkRP category creation.</p>

<strong>When Called</strong>
<p>Invoked by DarkRP.createCategory during addon initialization; intentionally no-op.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- API parity only; this function performs no actions.
  lia.darkrp.createCategory()
</code></pre>
</div>
</details>

---

