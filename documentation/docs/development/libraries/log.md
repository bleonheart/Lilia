# Logger

Comprehensive logging and audit trail system for the Lilia framework.

---

<strong>Overview</strong>

The logger library provides comprehensive logging functionality for the Lilia framework, enabling detailed tracking and recording of player actions, administrative activities, and system events. It operates on the server side and automatically categorizes log entries into predefined categories such as character management, combat, world interactions, chat communications, item transactions, administrative actions, and security events. The library stores all log entries in a database table with timestamps, player information, and categorized messages. It supports dynamic log type registration and provides hooks for external systems to process log events. The logger ensures accountability and provides administrators with detailed audit trails for server management and moderation.

---

<details class="realm-shared">
<summary><a id=lia.log.addType></a>lia.log.addType(logType, func, category)</summary>
<div class="details-content">
<a id="lialogaddtype"></a>
<strong>Purpose</strong>
<p>Register a new log type with formatter and category.</p>

<strong>When Called</strong>
<p>During init to add custom audit events (e.g., quests, crafting).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">logType</span> Unique log key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">func</span> Formatter function (client, ... ) -> string.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">category</span> Category label used in console output and DB.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.log.addType("questComplete", function(client, questID, reward)
      return L("logQuestComplete", client:Name(), questID, reward)
  end, L("quests"))
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.log.getString></a>lia.log.getString(client, logType)</summary>
<div class="details-content">
<a id="lialoggetstring"></a>
<strong>Purpose</strong>
<p>Build a formatted log string and return its category.</p>

<strong>When Called</strong>
<p>Internally by lia.log.add before printing/persisting logs.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">logType</span> ... (vararg)</p>

<strong>Returns</strong>
<p>string|nil, string|nil logString, category</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local text, category = lia.log.getString(ply, "playerDeath", attackerName)
  if text then print(category, text) end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.log.add></a>lia.log.add(client, logType)</summary>
<div class="details-content">
<a id="lialogadd"></a>
<strong>Purpose</strong>
<p>Create and store a log entry (console + database) using a logType.</p>

<strong>When Called</strong>
<p>Anywhere you need to audit player/admin/system actions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span></p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">logType</span> ... (vararg)</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.log.add(client, "itemTake", itemName)
  lia.log.add(nil, "frameworkOutdated") -- system log without player
</code></pre>
</div>
</details>

---

