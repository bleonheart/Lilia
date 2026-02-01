# Vendor

NPC vendor management system with editing and rarity support for the Lilia framework.

---

<strong>Overview</strong>

The vendor library provides comprehensive functionality for managing NPC vendors in the Lilia framework. It handles vendor configuration, editing, presets, and rarity systems for items sold by vendors. The library operates on both server and client sides, with the server handling vendor data processing and the client managing the editing interface. It includes support for vendor presets, item rarities, stock management, pricing, faction/class restrictions, and visual customization. The library ensures that vendors can be easily configured and managed through both code and in-game editing tools.

---

<details class="realm-shared">
<summary><a id=lia.vendor.addPreset></a>lia.vendor.addPreset(name, items)</summary>
<div class="details-content">
<a id="liavendoraddpreset"></a>
<strong>Purpose</strong>
<p>Register a reusable vendor item preset with validated entries.</p>

<strong>When Called</strong>
<p>During initialization to define canned loadouts for vendors (e.g., weapon dealer, medic).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Unique preset name.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">items</span> Map of item uniqueIDs to tables with pricing/stock metadata.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Define a preset and apply it dynamically based on map location.
  lia.vendor.addPreset("gunsmith", {
      ar15 = {stock = 3, price = 3500},
      akm = {stock = 2, price = 3200},
      ["9mm"] = {stock = 50, price = 30}
  })
  hook.Add("OnVendorSpawned", "SetupMapVendors", function(vendorEnt)
      if vendorEnt:GetClass() ~= "lia_vendor" then return end
      local zone = lia.zones and lia.zones.getNameAtPos(vendorEnt:GetPos()) or "default"
      if zone == "Armory" then
          vendorEnt:applyPreset("gunsmith")
          vendorEnt:setFactionAllowed(FACTION_POLICE, true)
      end
  end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.vendor.getPreset></a>lia.vendor.getPreset(name)</summary>
<div class="details-content">
<a id="liavendorgetpreset"></a>
<strong>Purpose</strong>
<p>Retrieve a preset definition by name.</p>

<strong>When Called</strong>
<p>While applying presets to vendors or inspecting available vendor templates.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Preset identifier (case-insensitive).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span> Item definition table if present.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Clone and tweak a preset before applying to a specific vendor.
  local preset = table.Copy(lia.vendor.getPreset("gunsmith") or {})
  if preset then
      preset["9mm"].price = 25
      preset["akm"] = nil -- remove AKM for this vendor
      vendor:applyPreset("gunsmith") -- base preset
      for item, data in pairs(preset) do
          vendor:setItemPrice(item, data.price)
          if data.stock then vendor:setMaxStock(item, data.stock) end
      end
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.vendor.getVendorProperty></a>lia.vendor.getVendorProperty(entity, property)</summary>
<div class="details-content">
<a id="liavendorgetvendorproperty"></a>
<strong>Purpose</strong>
<p>Fetch a vendor property from cache with default fallback.</p>

<strong>When Called</strong>
<p>Anywhere vendor state is read (pricing, stock, model, etc.).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Vendor NPC entity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">property</span> Property key from `lia.vendor.defaults`.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Cached property value or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Build a UI row with live vendor state (including defaults).
  local function addVendorRow(list, vendorEnt)
      local name = lia.vendor.getVendorProperty(vendorEnt, "name")
      local cash = lia.vendor.getVendorProperty(vendorEnt, "money") or 0
      local items = lia.vendor.getVendorProperty(vendorEnt, "items")
      list:AddLine(name, cash, table.Count(items or {}))
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.vendor.setVendorProperty></a>lia.vendor.setVendorProperty(entity, property, value)</summary>
<div class="details-content">
<a id="liavendorsetvendorproperty"></a>
<strong>Purpose</strong>
<p>Mutate a vendor property, pruning defaults to keep network/state lean.</p>

<strong>When Called</strong>
<p>During vendor edits (net messages) or when scripting dynamic vendor behavior.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Vendor NPC entity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">property</span> Key to update.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> New value to store; default-equivalent values clear the entry.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Dynamically flip vendor inventory for an event and prune defaults.
  hook.Add("EventStarted", "StockEventVendors", function()
      for _, vendorEnt in ipairs(ents.FindByClass("lia_vendor")) do
          lia.vendor.setVendorProperty(vendorEnt, "items", {
              ["event_ticket"] = {stock = 100, price = 0},
              ["rare_crate"] = {stock = 5, price = 7500}
          })
      end
  end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.vendor.syncVendorProperty></a>lia.vendor.syncVendorProperty(entity, property, value, isDefault)</summary>
<div class="details-content">
<a id="liavendorsyncvendorproperty"></a>
<strong>Purpose</strong>
<p>Broadcast a vendor property update to all clients.</p>

<strong>When Called</strong>
<p>Server-side after mutating vendor properties to keep clients in sync.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Vendor NPC entity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">property</span> Key being synchronized.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> New value for the property.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">isDefault</span> Whether the property should be cleared (uses defaults clientside).</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Force sync after a server-side rebuild of vendor data.
  local function rebuildVendor(vendorEnt)
      lia.vendor.setVendorProperty(vendorEnt, "name", "Quartermaster")
      lia.vendor.setVendorProperty(vendorEnt, "factionSellScales", { [FACTION_POLICE] = 0.8 })
      lia.vendor.syncVendorProperty(vendorEnt, "name", "Quartermaster", false)
      lia.vendor.syncVendorProperty(vendorEnt, "factionSellScales", { [FACTION_POLICE] = 0.8 }, false)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.vendor.getAllVendorData></a>lia.vendor.getAllVendorData(entity)</summary>
<div class="details-content">
<a id="liavendorgetallvendordata"></a>
<strong>Purpose</strong>
<p>Build a full vendor state table with defaults applied.</p>

<strong>When Called</strong>
<p>Before serializing vendor data for saving or sending to clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Vendor NPC entity.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Key-value table covering every defaulted vendor property.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Serialize full vendor state for a persistence layer.
  net.Receive("RequestVendorSnapshot", function(_, ply)
      local ent = net.ReadEntity()
      local data = lia.vendor.getAllVendorData(ent)
      if not data then return end
      lia.data.set("vendor_" .. ent:EntIndex(), data)
      net.Start("SendVendorSnapshot")
      net.WriteTable(data)
      net.Send(ply)
  end)
</code></pre>
</div>
</details>

---

