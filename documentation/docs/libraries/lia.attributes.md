# Attributes

This page documents the functions and methods in the Lilia library.

---

<details class="realm-client">
<summary><a id=lia.attribs.loadFromDir></a>lia.attribs.loadFromDir(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaattribsloadfromdir"></a>
<p>Applies kick or ban punishments to a player based on the provided parameters.</p>
<p>Called when an automated system or admin action needs to punish a player with a kick or ban.</p>
<p><h3>Parameters:</h3>
<span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Player">Player</a></span> <span class="parameter">client</span> The player to punish.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">infraction</span> Description of the infraction that caused the punishment.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">kick</span> Whether to kick the player.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">ban</span> Whether to ban the player.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> Ban duration in minutes (only used if ban is true).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">kickKey</span> Localization key for kick message (defaults to "kickedForInfraction").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">banKey</span> Localization key for ban message (defaults to "bannedForInfraction").</p>

<p><h3>Returns:</h3>
<span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.1">nil</a></span></p>

<h3>Example Usage:</h3>
<pre><code class="language-lua">    -- Kick a player for spamming
    lia.admin.applyPunishment(player, "Spamming in chat", true, false, nil, nil, nil)
    -- Ban a player for griefing for 24 hours
    lia.admin.applyPunishment(player, "Griefing", false, true, 1440, nil, nil)
    -- Both kick and ban with custom messages
    lia.admin.applyPunishment(player, "Hacking", true, true, 10080, "kickedForHacking", "bannedForHacking")
</code></pre>
</details>

---

<details class="realm-server">
<summary><a id=lia.attribs.register></a>lia.attribs.register(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaattribsregister"></a>
<p>Applies kick or ban punishments to a player based on the provided parameters.</p>
<p>Called when an automated system or admin action needs to punish a player with a kick or ban.</p>
<p><h3>Parameters:</h3>
<span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Player">Player</a></span> <span class="parameter">client</span> The player to punish.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">infraction</span> Description of the infraction that caused the punishment.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">kick</span> Whether to kick the player.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">ban</span> Whether to ban the player.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> Ban duration in minutes (only used if ban is true).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">kickKey</span> Localization key for kick message (defaults to "kickedForInfraction").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">banKey</span> Localization key for ban message (defaults to "bannedForInfraction").</p>

<p><h3>Returns:</h3>
<span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.1">nil</a></span></p>

<h3>Example Usage:</h3>
<pre><code class="language-lua">    -- Kick a player for spamming
    lia.admin.applyPunishment(player, "Spamming in chat", true, false, nil, nil, nil)
    -- Ban a player for griefing for 24 hours
    lia.admin.applyPunishment(player, "Griefing", false, true, 1440, nil, nil)
    -- Both kick and ban with custom messages
    lia.admin.applyPunishment(player, "Hacking", true, true, 10080, "kickedForHacking", "bannedForHacking")
</code></pre>
</details>

---

<details class="realm-shared">
<summary><a id=lia.attribs.setup></a>lia.attribs.setup(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaattribssetup"></a>
<p>Applies kick or ban punishments to a player based on the provided parameters.</p>
<p>Called when an automated system or admin action needs to punish a player with a kick or ban.</p>
<p><h3>Parameters:</h3>
<span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Player">Player</a></span> <span class="parameter">client</span> The player to punish.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">infraction</span> Description of the infraction that caused the punishment.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">kick</span> Whether to kick the player.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">ban</span> Whether to ban the player.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">time</span> Ban duration in minutes (only used if ban is true).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">kickKey</span> Localization key for kick message (defaults to "kickedForInfraction").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">banKey</span> Localization key for ban message (defaults to "bannedForInfraction").</p>

<p><h3>Returns:</h3>
<span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.1">nil</a></span></p>

<h3>Example Usage:</h3>
<pre><code class="language-lua">    -- Kick a player for spamming
    lia.admin.applyPunishment(player, "Spamming in chat", true, false, nil, nil, nil)
    -- Ban a player for griefing for 24 hours
    lia.admin.applyPunishment(player, "Griefing", false, true, 1440, nil, nil)
    -- Both kick and ban with custom messages
    lia.admin.applyPunishment(player, "Hacking", true, true, 10080, "kickedForHacking", "bannedForHacking")
</code></pre>
</details>

---

