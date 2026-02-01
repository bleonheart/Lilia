# Network

Network communication and data streaming system for the Lilia framework.

---

<strong>Overview</strong>

The network library provides comprehensive functionality for managing network communication in the Lilia framework. It handles both simple message passing and complex data streaming between server and client. The library includes support for registering network message handlers, sending messages to specific targets or broadcasting to all clients, and managing large data transfers through chunked streaming. It also provides global variable synchronization across the network, allowing server-side variables to be automatically synchronized with clients. The library operates on both server and client sides, with server handling message broadcasting and client handling message reception and acknowledgment.

---

<details class="realm-shared">
<summary><a id=lia.net.isCacheHit></a>lia.net.isCacheHit(name, args)</summary>
<div class="details-content">
<a id="lianetiscachehit"></a>
<strong>Purpose</strong>
<p>Determine if a net payload with given args is still fresh in cache.</p>

<strong>When Called</strong>
<p>Before sending large net payloads to avoid duplicate work.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Cache identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">args</span> Arguments that define cache identity.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> true if cached entry exists within TTL.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if not lia.net.isCacheHit("bigSync", {ply:SteamID64()}) then
      lia.net.writeBigTable(ply, "liaBigSync", payload)
      lia.net.addToCache("bigSync", {ply:SteamID64()})
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.net.addToCache></a>lia.net.addToCache(name, args)</summary>
<div class="details-content">
<a id="lianetaddtocache"></a>
<strong>Purpose</strong>
<p>Insert a cache marker for a named payload/args combination.</p>

<strong>When Called</strong>
<p>Right after sending a large or expensive net payload.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Cache identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">args</span> Arguments that define cache identity.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.net.writeBigTable(targets, "liaDialogSync", data)
  lia.net.addToCache("dialogSync", {table.Count(data)})
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.net.readBigTable></a>lia.net.readBigTable(netStr, callback)</summary>
<div class="details-content">
<a id="lianetreadbigtable"></a>
<strong>Purpose</strong>
<p>Receive chunked JSON-compressed tables and reconstruct them.</p>

<strong>When Called</strong>
<p>To register a receiver for big table streams (both realms).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">netStr</span> Net message name carrying the chunks.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">callback</span> Function called when table is fully received. Client: function(tbl), Server: function(ply, tbl).</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.net.readBigTable("liaDoorDataBulk", function(tbl)
      if not tbl then return end
      for doorID, data in pairs(tbl) do
          lia.doors.updateCachedData(doorID, data)
      end
  end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.net.writeBigTable></a>lia.net.writeBigTable(targets, netStr, tbl, chunkSize)</summary>
<div class="details-content">
<a id="lianetwritebigtable"></a>
<strong>Purpose</strong>
<p>Send a large table by compressing and chunking it across the net.</p>

<strong>When Called</strong>
<p>For big payloads (dialog sync, door data, keybinds) that exceed net limits.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">targets</span> <span class="optional">optional</span> Single player, list of players, or nil to broadcast to humans.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">netStr</span> Net message name to use.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">tbl</span> Data to serialize.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">chunkSize</span> <span class="optional">optional</span> Optional override for chunk size.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local payload = {doors = lia.doors.stored, ts = os.time()}
  lia.net.writeBigTable(player.GetHumans(), "liaDoorDataBulk", payload, 2048)
  lia.net.addToCache("doorBulk", {payload.ts})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.net.checkBadType></a>lia.net.checkBadType(name, object)</summary>
<div class="details-content">
<a id="lianetcheckbadtype"></a>
<strong>Purpose</strong>
<p>Validate netvar payloads to prevent functions being networked.</p>

<strong>When Called</strong>
<p>Internally before setting globals/locals.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Identifier for error reporting.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">object</span> Value to validate for networking safety.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean|nil</a></span> true if bad type detected.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.net.checkBadType("example", someTable) then return end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.net.setNetVar></a>lia.net.setNetVar(key, value, receiver)</summary>
<div class="details-content">
<a id="lianetsetnetvar"></a>
<strong>Purpose</strong>
<p>Set a global netvar and broadcast it (or send to specific receiver).</p>

<strong>When Called</strong>
<p>Whenever shared state changes (config sync, feature flags, etc.).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Netvar identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to set.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">receiver</span> <span class="optional">optional</span> Optional target(s); broadcasts when nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.net.setNetVar("eventActive", true)
  lia.net.setNetVar("roundNumber", round, targetPlayers)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.net.getNetVar></a>lia.net.getNetVar(key, default)</summary>
<div class="details-content">
<a id="lianetgetnetvar"></a>
<strong>Purpose</strong>
<p>Retrieve a global netvar with a fallback default.</p>

<strong>When Called</strong>
<p>Client/server code reading synchronized state.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Netvar identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Fallback value if netvar is not set.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.net.getNetVar("eventActive", false) then
      DrawEventHUD()
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.net.profiler.log></a>lia.net.profiler.log(key, default)</summary>
<div class="details-content">
<a id="lianetprofilerlog"></a>
<strong>Purpose</strong>
<p>Retrieve a global netvar with a fallback default.</p>

<strong>When Called</strong>
<p>Client/server code reading synchronized state.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Netvar identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Fallback value if netvar is not set.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span></p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.net.getNetVar("eventActive", false) then
      DrawEventHUD()
  end
</code></pre>
</div>
</details>

---

