# Administrator Library

Comprehensive user group and privilege management system for the Lilia framework.

---

Overview

The administrator library provides comprehensive functionality for managing user groups, privileges, and administrative permissions in the Lilia framework. It handles the creation, modification, and deletion of user groups with inheritance-based privilege systems. The library operates on both server and client sides, with the server managing privilege storage and validation while the client provides user interface elements for administrative management. It includes integration with CAMI (Comprehensive Administration Management Interface) for compatibility with other administrative systems. The library ensures proper privilege inheritance, automatic privilege registration for tools and properties, and comprehensive logging of administrative actions. It supports both console-based and GUI-based administrative command execution with proper permission checking and validation.

Setting Superadmin:
To set yourself as superadmin in the console, use: plysetgroup "STEAMID" superadmin
The system has three default user groups with inheritance levels: user (level 1), admin (level 2), and superadmin (level 3).
Superadmin automatically has all privileges and cannot be restricted by any permission checks.

---

<details class="realm-shared">
<summary><a id=lia.admin.applyPunishment></a>lia.admin.applyPunishment(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminapplypunishment"></a>
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
<summary><a id=lia.admin.hasAccess></a>lia.admin.hasAccess(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminhasaccess"></a>
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
<summary><a id=lia.admin.save></a>lia.admin.save(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminsave"></a>
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
<summary><a id=lia.admin.registerPrivilege></a>lia.admin.registerPrivilege(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminregisterprivilege"></a>
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
<summary><a id=lia.admin.unregisterPrivilege></a>lia.admin.unregisterPrivilege(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminunregisterprivilege"></a>
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
<summary><a id=lia.admin.applyInheritance></a>lia.admin.applyInheritance(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminapplyinheritance"></a>
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
<summary><a id=lia.admin.load></a>lia.admin.load(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminload"></a>
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
<summary><a id=lia.admin.createGroup></a>lia.admin.createGroup(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadmincreategroup"></a>
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
<summary><a id=lia.admin.removeGroup></a>lia.admin.removeGroup(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminremovegroup"></a>
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
<summary><a id=lia.admin.renameGroup></a>lia.admin.renameGroup(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminrenamegroup"></a>
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
<summary><a id=lia.admin.notifyAdmin></a>lia.admin.notifyAdmin(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminnotifyadmin"></a>
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
<summary><a id=lia.admin.addPermission></a>lia.admin.addPermission(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminaddpermission"></a>
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
<summary><a id=lia.admin.removePermission></a>lia.admin.removePermission(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminremovepermission"></a>
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
<summary><a id=lia.admin.sync></a>lia.admin.sync(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminsync"></a>
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
<summary><a id=lia.admin.hasChanges></a>lia.admin.hasChanges(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminhaschanges"></a>
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
<summary><a id=lia.admin.setPlayerUsergroup></a>lia.admin.setPlayerUsergroup(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminsetplayerusergroup"></a>
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
<summary><a id=lia.admin.setSteamIDUsergroup></a>lia.admin.setSteamIDUsergroup(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminsetsteamidusergroup"></a>
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
<summary><a id=lia.admin.serverExecCommand></a>lia.admin.serverExecCommand(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminserverexeccommand"></a>
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
<summary><a id=lia.admin.execCommand></a>lia.admin.execCommand(client, infraction, kick, ban, time, kickKey, banKey)</summary>
<a id="liaadminexeccommand"></a>
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

