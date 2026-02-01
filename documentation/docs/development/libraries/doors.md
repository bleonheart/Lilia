# Doors

Door management system for the Lilia framework providing preset configuration,

---

<strong>Overview</strong>

The doors library provides comprehensive door management functionality including
preset configuration, database schema verification, and data cleanup operations.
It handles door data persistence, loading door configurations from presets,
and maintaining database integrity. The library manages door ownership, access
permissions, faction and class restrictions, and provides utilities for door
data validation and corruption cleanup. It operates primarily on the server side
and integrates with the database system to persist door configurations across
server restarts. The library also handles door locking/unlocking mechanics and
provides hooks for custom door behavior integration.

---

<details class="realm-shared">
<summary><a id=lia.doors.getDoorDefaultValues></a>lia.doors.getDoorDefaultValues()</summary>
<div class="details-content">
<a id="liadoorsgetdoordefaultvalues"></a>
<strong>Purpose</strong>
<p>Retrieve door default values merged with any extra fields provided by modules.</p>

<strong>When Called</strong>
<p>Anywhere door defaults are needed (initialization, schema checks, load/save).</p>

<strong>Returns</strong>
<p>table defaults Map of field -> default value including extra fields. table extras Map of extra field definitions collected via the CollectDoorDataFields hook.</p>

</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.setCachedData></a>lia.doors.setCachedData(door, data)</summary>
<div class="details-content">
<a id="liadoorssetcacheddata"></a>
<strong>Purpose</strong>
<p>Store door data overrides in memory and sync to clients, omitting defaults.</p>

<strong>When Called</strong>
<p>After editing door settings (price, access, flags) server-side.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">door</span> Door entity.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Door data overrides.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.doors.setCachedData(door, {
      name = "Police HQ",
      price = 0,
      factions = {FACTION_POLICE}
  })
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.getCachedData></a>lia.doors.getCachedData(door)</summary>
<div class="details-content">
<a id="liadoorsgetcacheddata"></a>
<strong>Purpose</strong>
<p>Retrieve cached door data merged with defaults.</p>

<strong>When Called</strong>
<p>Before saving/loading or when building UI state for a door.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">door</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Complete door data with defaults filled.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local data = lia.doors.getCachedData(door)
  print("Door price:", data.price)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.syncDoorData></a>lia.doors.syncDoorData(door)</summary>
<div class="details-content">
<a id="liadoorssyncdoordata"></a>
<strong>Purpose</strong>
<p>Net-sync a single door's cached data to all clients.</p>

<strong>When Called</strong>
<p>After updating a door's data.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">door</span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.doors.syncDoorData(door)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.syncAllDoorsToClient></a>lia.doors.syncAllDoorsToClient(client)</summary>
<div class="details-content">
<a id="liadoorssyncalldoorstoclient"></a>
<strong>Purpose</strong>
<p>Bulk-sync all cached doors to a single client.</p>

<strong>When Called</strong>
<p>On player spawn/join or after admin refresh.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("PlayerInitialSpawn", "SyncDoorsOnJoin", function(ply)
      lia.doors.syncAllDoorsToClient(ply)
  end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.setData></a>lia.doors.setData(door, data)</summary>
<div class="details-content">
<a id="liadoorssetdata"></a>
<strong>Purpose</strong>
<p>Set data for a door (alias to setCachedData).</p>

<strong>When Called</strong>
<p>Convenience wrapper used by other systems.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">door</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.doors.setData(door, {locked = true})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.addPreset></a>lia.doors.addPreset(mapName, presetData)</summary>
<div class="details-content">
<a id="liadoorsaddpreset"></a>
<strong>Purpose</strong>
<p>Register a preset of door data for a specific map.</p>

<strong>When Called</strong>
<p>During map setup to predefine door ownership/prices.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">mapName</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">presetData</span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.doors.addPreset("rp_downtown", {
      [1234] = {name = "Bank", price = 0, factions = {FACTION_POLICE}},
      [5678] = {locked = true, hidden = true}
  })
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.getPreset></a>lia.doors.getPreset(mapName)</summary>
<div class="details-content">
<a id="liadoorsgetpreset"></a>
<strong>Purpose</strong>
<p>Retrieve a door preset table for a map.</p>

<strong>When Called</strong>
<p>During map load or admin inspection of presets.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">mapName</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local preset = lia.doors.getPreset(game.GetMap())
  if preset then PrintTable(preset) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.verifyDatabaseSchema></a>lia.doors.verifyDatabaseSchema()</summary>
<div class="details-content">
<a id="liadoorsverifydatabaseschema"></a>
<strong>Purpose</strong>
<p>Validate the doors database schema against expected columns.</p>

<strong>When Called</strong>
<p>On startup or after migrations to detect missing/mismatched columns.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("DatabaseConnected", "VerifyDoorSchema", lia.doors.verifyDatabaseSchema)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.doors.cleanupCorruptedData></a>lia.doors.cleanupCorruptedData()</summary>
<div class="details-content">
<a id="liadoorscleanupcorrupteddata"></a>
<strong>Purpose</strong>
<p>Detect and repair corrupted faction/class door data in the database.</p>

<strong>When Called</strong>
<p>Maintenance task to clean malformed data entries.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  concommand.Add("lia_fix_doors", function(admin)
      if not IsValid(admin) or not admin:IsAdmin() then return end
      lia.doors.cleanupCorruptedData()
  end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.doors.getData></a>lia.doors.getData(door)</summary>
<div class="details-content">
<a id="liadoorsgetdata"></a>
<strong>Purpose</strong>
<p>Access cached door data (server/client wrapper).</p>

<strong>When Called</strong>
<p>Anywhere door data is needed without hitting DB.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">door</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local data = lia.doors.getData(ent)
  if data.locked then
      -- show locked icon
  end
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.doors.getCachedData></a>lia.doors.getCachedData(door)</summary>
<div class="details-content">
<a id="liadoorsgetcacheddata"></a>
<strong>Purpose</strong>
<p>Client helper to build full door data from cached entries.</p>

<strong>When Called</strong>
<p>For HUD/tooltips when interacting with doors.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">door</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local info = lia.doors.getCachedData(door)
  draw.SimpleText(info.name or "Door", "LiliaFont.18", x, y, color_white)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.doors.updateCachedData></a>lia.doors.updateCachedData(doorID, data)</summary>
<div class="details-content">
<a id="liadoorsupdatecacheddata"></a>
<strong>Purpose</strong>
<p>Update the client-side cache for a door ID (or clear it).</p>

<strong>When Called</strong>
<p>After receiving sync updates from the server.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">doorID</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> <span class="optional">optional</span> nil clears the cache entry.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.doors.updateCachedData(doorID, net.ReadTable())
</code></pre>
</div>
</details>

---

