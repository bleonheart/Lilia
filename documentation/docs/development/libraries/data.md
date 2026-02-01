# Data

Data persistence, serialization, and management system for the Lilia framework.

---

<strong>Overview</strong>

The data library provides comprehensive functionality for data persistence, serialization, and management within the Lilia framework. It handles encoding and decoding of complex data types including vectors, angles, colors, and nested tables for database storage. The library manages both general data storage with gamemode and map-specific scoping, as well as entity persistence for maintaining spawned entities across server restarts. It includes automatic serialization/deserialization, database integration, and caching mechanisms to ensure efficient data access and storage operations.

---

<details class="realm-server">
<summary><a id=lia.data.encodetable></a>lia.data.encodetable(value)</summary>
<div class="details-content">
<a id="liadataencodetable"></a>
<strong>Purpose</strong>
<p>Encode vectors/angles/colors/tables into JSON-safe structures.</p>

<strong>When Called</strong>
<p>Before persisting data to DB or file storage.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Encoded representation.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local payload = lia.data.encodetable({
      pos = Vector(0, 0, 64),
      ang = Angle(0, 90, 0),
      tint = Color(255, 0, 0)
  })
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.decode></a>lia.data.decode(value)</summary>
<div class="details-content">
<a id="liadatadecode"></a>
<strong>Purpose</strong>
<p>Decode nested structures into native types (Vector/Angle/Color).</p>

<strong>When Called</strong>
<p>After reading serialized data from DB/file.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Decoded value with deep conversion.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local decoded = lia.data.decode(storedJsonTable)
  local pos = decoded.spawnPos
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.serialize></a>lia.data.serialize(value)</summary>
<div class="details-content">
<a id="liadataserialize"></a>
<strong>Purpose</strong>
<p>Serialize a value into JSON, pre-encoding special types.</p>

<strong>When Called</strong>
<p>Before writing data blobs into DB columns.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> JSON string.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local json = lia.data.serialize({pos = Vector(1,2,3)})
  lia.db.updateSomewhere(json)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.deserialize></a>lia.data.deserialize(raw)</summary>
<div class="details-content">
<a id="liadatadeserialize"></a>
<strong>Purpose</strong>
<p>Deserialize JSON/pon or raw tables back into native types.</p>

<strong>When Called</strong>
<p>After fetching data rows from DB.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|table|any</a></span> <span class="parameter">raw</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local row = lia.db.select(...):get()
  local data = lia.data.deserialize(row.data)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.decodeVector></a>lia.data.decodeVector(raw)</summary>
<div class="details-content">
<a id="liadatadecodevector"></a>
<strong>Purpose</strong>
<p>Decode a vector from various string/table encodings.</p>

<strong>When Called</strong>
<p>While rebuilding persistent entities or map data.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">raw</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector|any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local pos = lia.data.decodeVector(row.pos)
  if isvector(pos) then ent:SetPos(pos) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.decodeAngle></a>lia.data.decodeAngle(raw)</summary>
<div class="details-content">
<a id="liadatadecodeangle"></a>
<strong>Purpose</strong>
<p>Decode an angle from string/table encodings.</p>

<strong>When Called</strong>
<p>During persistence loading or data deserialization.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">raw</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Angle">Angle|any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ang = lia.data.decodeAngle(row.angles)
  if isangle(ang) then ent:SetAngles(ang) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.set></a>lia.data.set(key, value, global, ignoreMap)</summary>
<div class="details-content">
<a id="liadataset"></a>
<strong>Purpose</strong>
<p>Persist a key/value pair scoped to gamemode/map (or global).</p>

<strong>When Called</strong>
<p>To save configuration/state data into the DB.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">global</span> <span class="optional">optional</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">ignoreMap</span> <span class="optional">optional</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Path prefix used for file save fallback.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.data.set("event.active", true, false, false)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.delete></a>lia.data.delete(key, global, ignoreMap)</summary>
<div class="details-content">
<a id="liadatadelete"></a>
<strong>Purpose</strong>
<p>Delete a stored key (and row if empty) from DB cache.</p>

<strong>When Called</strong>
<p>To remove saved state/config entries.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">global</span> <span class="optional">optional</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">ignoreMap</span> <span class="optional">optional</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.data.delete("event.active")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.loadTables></a>lia.data.loadTables()</summary>
<div class="details-content">
<a id="liadataloadtables"></a>
<strong>Purpose</strong>
<p>Load stored data rows for global, gamemode, and map scopes.</p>

<strong>When Called</strong>
<p>On database ready to hydrate lia.data.stored cache.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("DatabaseConnected", "LoadLiliaData", lia.data.loadTables)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.loadPersistence></a>lia.data.loadPersistence()</summary>
<div class="details-content">
<a id="liadataloadpersistence"></a>
<strong>Purpose</strong>
<p>Ensure persistence table has required columns; add if missing.</p>

<strong>When Called</strong>
<p>Before saving/loading persistent entities.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">promise</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.data.loadPersistence():next(function() print("Persistence columns ready") end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.savePersistence></a>lia.data.savePersistence(entities)</summary>
<div class="details-content">
<a id="liadatasavepersistence"></a>
<strong>Purpose</strong>
<p>Save persistent entities to the database (with dynamic columns).</p>

<strong>When Called</strong>
<p>On PersistenceSave hook/timer with collected entities.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">entities</span> Array of entity data tables.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">promise|nil</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Run("PersistenceSave", collectedEntities)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.loadPersistenceData></a>lia.data.loadPersistenceData(callback)</summary>
<div class="details-content">
<a id="liadataloadpersistencedata"></a>
<strong>Purpose</strong>
<p>Load persistent entities from DB, decode fields, and cache them.</p>

<strong>When Called</strong>
<p>On server start or when manually reloading persistence.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> <span class="optional">optional</span> Invoked with entities table once loaded.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">promise</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.data.loadPersistenceData(function(entities)
      for _, entData in ipairs(entities) do
          -- spawn logic here
      end
  end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.get></a>lia.data.get(key, default)</summary>
<div class="details-content">
<a id="liadataget"></a>
<strong>Purpose</strong>
<p>Fetch a stored key from cache, deserializing strings on demand.</p>

<strong>When Called</strong>
<p>Anywhere stored data is read after loadTables.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local eventData = lia.data.get("event.settings", {})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.data.getPersistence></a>lia.data.getPersistence()</summary>
<div class="details-content">
<a id="liadatagetpersistence"></a>
<strong>Purpose</strong>
<p>Return the cached list of persistent entities (last loaded/saved).</p>

<strong>When Called</strong>
<p>For admin tools or debug displays.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  PrintTable(lia.data.getPersistence())
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.data.addEquivalencyMap></a>lia.data.addEquivalencyMap(map1, map2)</summary>
<div class="details-content">
<a id="liadataaddequivalencymap"></a>
<strong>Purpose</strong>
<p>Register an equivalency between two map names (bidirectional).</p>

<strong>When Called</strong>
<p>To share data/persistence across multiple map aliases.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">map1</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">map2</span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.data.addEquivalencyMap("rp_downtown_v1", "rp_downtown_v2")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.data.getEquivalencyMap></a>lia.data.getEquivalencyMap(map)</summary>
<div class="details-content">
<a id="liadatagetequivalencymap"></a>
<strong>Purpose</strong>
<p>Resolve a map name to its equivalency (if registered).</p>

<strong>When Called</strong>
<p>Before saving/loading data keyed by map name.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">map</span></p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local canonical = lia.data.getEquivalencyMap(game.GetMap())
</code></pre>
</div>
</details>

---

