# Notice

Player notification and messaging system for the Lilia framework.

---

<strong>Overview</strong>

The notice library provides comprehensive functionality for displaying notifications and messages to players in the Lilia framework. It handles both server-side and client-side notification systems, supporting both direct text messages and localized messages with parameter substitution. The library operates across server and client realms, with the server sending notification data to clients via network messages, while the client handles the visual display of notifications using VGUI panels. It includes automatic organization of multiple notifications, sound effects, and console output for debugging purposes. The library also provides compatibility with Garry's Mod's legacy notification system.

---

<details class="realm-client">
<summary><a id=lia.notices.receiveNotify></a>lia.notices.receiveNotify()</summary>
<div class="details-content">
<a id="lianoticesreceivenotify"></a>
<strong>Purpose</strong>
<p>Receives notification data from the server via network message and displays it to the client.</p>

<strong>When Called</strong>
<p>Automatically called when the client receives a "liaNotificationData" network message from the server.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- This function is called automatically when receiving server notifications
  -- No manual calling needed
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.receiveNotifyL></a>lia.notices.receiveNotifyL()</summary>
<div class="details-content">
<a id="lianoticesreceivenotifyl"></a>
<strong>Purpose</strong>
<p>Receives localized notification data from the server and displays the localized message to the client.</p>

<strong>When Called</strong>
<p>Automatically called when the client receives a "liaNotifyLocal" network message from the server containing localized notification data.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- This function is called automatically when receiving localized server notifications
  -- No manual calling needed
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.notifyInfoLocalized></a>lia.notices.notifyInfoLocalized(client, key)</summary>
<div class="details-content">
<a id="lianoticesnotifyinfolocalized"></a>
<strong>Purpose</strong>
<p>Sends an informational notification to a client using a localized message key with optional parameters.</p>

<strong>When Called</strong>
<p>Called when you want to send an info-type notification with localized text to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Send localized info notification to a specific player
  lia.notices.notifyInfoLocalized(player, "item.purchased", itemName, price)
  -- Send to all players
  lia.notices.notifyInfoLocalized(nil, "server.restart", "5")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.notifyWarningLocalized></a>lia.notices.notifyWarningLocalized(client, key)</summary>
<div class="details-content">
<a id="lianoticesnotifywarninglocalized"></a>
<strong>Purpose</strong>
<p>Sends a warning notification to a client using a localized message key with optional parameters.</p>

<strong>When Called</strong>
<p>Called when you want to send a warning-type notification with localized text to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Send localized warning notification to a specific player
  lia.notices.notifyWarningLocalized(player, "inventory.full")
  -- Send to all players
  lia.notices.notifyWarningLocalized(nil, "server.maintenance", "30")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.notifyErrorLocalized></a>lia.notices.notifyErrorLocalized(client, key)</summary>
<div class="details-content">
<a id="lianoticesnotifyerrorlocalized"></a>
<strong>Purpose</strong>
<p>Sends an error notification to a client using a localized message key with optional parameters.</p>

<strong>When Called</strong>
<p>Called when you want to send an error-type notification with localized text to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Send localized error notification to a specific player
  lia.notices.notifyErrorLocalized(player, "command.noPermission")
  -- Send to all players
  lia.notices.notifyErrorLocalized(nil, "server.error", errorCode)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.notifySuccessLocalized></a>lia.notices.notifySuccessLocalized(client, key)</summary>
<div class="details-content">
<a id="lianoticesnotifysuccesslocalized"></a>
<strong>Purpose</strong>
<p>Sends a success notification to a client using a localized message key with optional parameters.</p>

<strong>When Called</strong>
<p>Called when you want to send a success-type notification with localized text to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Send localized success notification to a specific player
  lia.notices.notifySuccessLocalized(player, "quest.completed", questName)
  -- Send to all players
  lia.notices.notifySuccessLocalized(nil, "server.update.complete")
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.notifyMoneyLocalized></a>lia.notices.notifyMoneyLocalized(client, key)</summary>
<div class="details-content">
<a id="lianoticesnotifymoneylocalized"></a>
<strong>Purpose</strong>
<p>Sends a money-related notification to a client using a localized message key with optional parameters.</p>

<strong>When Called</strong>
<p>Called when you want to send a money-type notification with localized text to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Send localized money notification to a specific player
  lia.notices.notifyMoneyLocalized(player, "money.earned", amount, reason)
  -- Send to all players
  lia.notices.notifyMoneyLocalized(nil, "lottery.winner", winnerName, prize)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.notices.notifyAdminLocalized></a>lia.notices.notifyAdminLocalized(client, key)</summary>
<div class="details-content">
<a id="lianoticesnotifyadminlocalized"></a>
<strong>Purpose</strong>
<p>Sends an admin-related notification to a client using a localized message key with optional parameters.</p>

<strong>When Called</strong>
<p>Called when you want to send an admin-type notification with localized text to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Send localized admin notification to a specific player
  lia.notices.notifyAdminLocalized(player, "admin.kicked", reason)
  -- Send to all players
  lia.notices.notifyAdminLocalized(nil, "admin.announcement", message)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.notices.notifyLocalized></a>lia.notices.notifyLocalized(client, key, notifType)</summary>
<div class="details-content">
<a id="lianoticesnotifylocalized"></a>
<strong>Purpose</strong>
<p>Sends a localized notification to a client or all clients, handling both server-side networking and client-side display.</p>

<strong>When Called</strong>
<p>Called when you want to send a notification using a localization key with variable arguments to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|string</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to, or the first argument if not a player. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The localization key for the message.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">notifType</span> The type of notification (e.g., "info", "warning", "error", "success").</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Server-side: Send to specific player
  lia.notices.notifyLocalized(player, "item.purchased", "success", itemName, price)
  -- Server-side: Send to all players
  lia.notices.notifyLocalized(nil, "server.restart", "warning", "5")
  -- Client-side: Display localized notification
  lia.notices.notifyLocalized(nil, "ui.button.clicked", "info")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.notices.notify></a>lia.notices.notify(client, message, notifType)</summary>
<div class="details-content">
<a id="lianoticesnotify"></a>
<strong>Purpose</strong>
<p>Sends a text notification to a client or all clients, handling both server-side networking and client-side display with sound and visual effects.</p>

<strong>When Called</strong>
<p>Called when you want to send a notification with plain text (not localized) to a specific client or all clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> The player to send the notification to. If nil, sends to all players.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">message</span> The notification message text to display.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">notifType</span> The type of notification (e.g., "default", "info", "warning", "error", "success", "money", "admin").</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Server-side: Send to specific player
  lia.notices.notify(player, "You have received 100 credits!", "money")
  -- Server-side: Send to all players
  lia.notices.notify(nil, "Server restarting in 5 minutes", "warning")
  -- Client-side: Display notification
  lia.notices.notify(nil, "Welcome to the server!", "info")
</code></pre>
</div>
</details>

---

