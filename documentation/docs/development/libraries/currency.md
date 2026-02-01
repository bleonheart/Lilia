# Currency

In-game currency formatting, display, and management system for the Lilia framework.

---

<strong>Overview</strong>

The currency library provides comprehensive functionality for managing in-game currency within the Lilia framework. It handles currency formatting, display, and physical money entity spawning.
The library operates on both server and client sides, with the server handling money entity creation and spawning, while the client handles currency display formatting.
It includes localization support for currency names and symbols, ensuring proper pluralization and formatting based on amount values.
The library integrates with the configuration system to allow customizable currency symbols and names.

---

<details class="realm-shared">
<summary><a id=lia.currency.get></a>lia.currency.get(amount)</summary>
<div class="details-content">
<a id="liacurrencyget"></a>
<strong>Purpose</strong>
<p>Format a numeric amount into a localized currency string with the configured symbol and singular/plural name.</p>

<strong>When Called</strong>
<p>Whenever a currency amount needs to be shown to players or logged (UI, chat, logs, tooltips).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Raw amount to format; must be a number.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Formatted amount with symbol prefix and the singular or plural currency name.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  chat.AddText(L("youReceivedMoney", lia.currency.get(250)))
  lia.log.add(client, "moneyPickedUp", 250)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.currency.spawn></a>lia.currency.spawn(pos, amount, angle)</summary>
<div class="details-content">
<a id="liacurrencyspawn"></a>
<strong>Purpose</strong>
<p>Spawn a physical money entity at a world position and assign it an amount.</p>

<strong>When Called</strong>
<p>Server-side when creating droppable currency (player drops, rewards, refunds, scripted events).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> <span class="parameter">pos</span> World position to spawn the money entity; required.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">amount</span> Currency amount to store on the entity; must be non-negative.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Angle">Angle</a></span> <span class="parameter">angle</span> <span class="optional">optional</span> Optional spawn angles; defaults to `angle_zero` when omitted.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity|nil</a></span> Created `lia_money` entity, or nil if input is invalid or entity creation fails.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("OnNPCKilled", "DropBountyCash", function(npc, attacker)
      if not IsValid(attacker) or not attacker:IsPlayer() then return end
      local money = lia.currency.spawn(npc:GetPos() + Vector(0, 0, 10), math.random(50, 150))
      if IsValid(money) then
          money:SetVelocity(VectorRand() * 80)
      end
  end)
</code></pre>
</div>
</details>

---

