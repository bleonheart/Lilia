# Player Interaction

Player-to-player and entity interaction management system for the Lilia framework.

---

<strong>Overview</strong>

The player interaction library provides comprehensive functionality for managing player interactions and actions within the Lilia framework. It handles the creation, registration, and execution of various interaction types including player-to-player interactions, entity interactions, and personal actions. The library operates on both server and client sides, with the server managing interaction registration and validation, while the client handles UI display and user input. It includes range checking, timed actions, and network synchronization to ensure consistent interaction behavior across all clients. The library supports both immediate and delayed actions with progress indicators, making it suitable for complex interaction systems like money transfers, voice changes, and other gameplay mechanics.

---

<details class="realm-shared">
<summary><a id=lia.playerinteract.isWithinRange></a>lia.playerinteract.isWithinRange(client, entity, customRange)</summary>
<div class="details-content">
<a id="liaplayerinteractiswithinrange"></a>
<strong>Purpose</strong>
<p>Check if a client is within a usable range of an entity.</p>

<strong>When Called</strong>
<p>Before running interaction logic or building interaction menus.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> The player attempting the interaction.</p>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> Target entity to test.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">customRange</span> <span class="optional">optional</span> Optional override distance in Hammer units (default 100).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> true if both are valid and distance is within range.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Validate a timed hack action before starting the progress bar.
  local function tryHackDoor(client, door)
      if not lia.playerinteract.isWithinRange(client, door, 96) then
          client:notifyLocalized("tooFarAway")
          return
      end
      client:setAction("@hackingDoor", 5, function()
          if IsValid(door) then door:Fire("Unlock") end
      end)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.playerinteract.getInteractions></a>lia.playerinteract.getInteractions(client)</summary>
<div class="details-content">
<a id="liaplayerinteractgetinteractions"></a>
<strong>Purpose</strong>
<p>Collect interaction options for the entity the player is aiming at.</p>

<strong>When Called</strong>
<p>When opening the interaction menu (TAB keybind) to populate entries.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Player to use for trace; defaults to LocalPlayer on client.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Map of interaction name → data filtered for the target.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Server: send only valid interactions for the traced entity.
  net.Receive("liaRequestInteractOptions", function(_, ply)
      local interactions = lia.playerinteract.getInteractions(ply)
      local categorized = lia.playerinteract.getCategorizedOptions(interactions)
      lia.net.writeBigTable(ply, "liaInteractionOptions", categorized)
  end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.playerinteract.getActions></a>lia.playerinteract.getActions(client)</summary>
<div class="details-content">
<a id="liaplayerinteractgetactions"></a>
<strong>Purpose</strong>
<p>Gather personal actions that do not require a target entity.</p>

<strong>When Called</strong>
<p>When opening the personal actions menu (G keybind).</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Player to evaluate; defaults to LocalPlayer on client.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Map of action name → data available for this player.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Filter actions for a character sheet panel.
  local actions = lia.playerinteract.getActions(ply)
  for name, data in pairs(actions) do
      if name:find("changeTo") then
          -- add a voice toggle button
      end
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.playerinteract.getCategorizedOptions></a>lia.playerinteract.getCategorizedOptions(options)</summary>
<div class="details-content">
<a id="liaplayerinteractgetcategorizedoptions"></a>
<strong>Purpose</strong>
<p>Transform option map into a categorized, ordered list for UI display.</p>

<strong>When Called</strong>
<p>Before rendering interaction/action menus that use category headers.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Map of name → option entry (expects `opt.category`).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array containing category rows followed by option entries.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Build an options array with headers for a custom menu.
  local options = lia.playerinteract.getCategorizedOptions(interactions)
  local panel = vgui.Create("liaOptionsPanel")
  panel:Populate(options)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.playerinteract.addInteraction></a>lia.playerinteract.addInteraction(name, data)</summary>
<div class="details-content">
<a id="liaplayerinteractaddinteraction"></a>
<strong>Purpose</strong>
<p>Register a targeted interaction and ensure timed actions wrap onRun.</p>

<strong>When Called</strong>
<p>Server startup or dynamically when new context interactions are added.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Unique interaction key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Fields: `onRun`, `shouldShow`, `range`, `target`, `category`,</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.playerinteract.addInteraction("zipTie", {
      target = "player",
      range = 96,
      category = "categoryRestraint",
      timeToComplete = 4,
      actionText = "@tying",
      targetActionText = "@beingTied",
      shouldShow = function(client, target)
          return target:IsPlayer() and not target:getNetVar("ziptied")
      end,
      onRun = function(client, target)
          target:setNetVar("ziptied", true)
      end
  })
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.playerinteract.addAction></a>lia.playerinteract.addAction(name, data)</summary>
<div class="details-content">
<a id="liaplayerinteractaddaction"></a>
<strong>Purpose</strong>
<p>Register a self-action (no target) and auto-wrap timed executions.</p>

<strong>When Called</strong>
<p>Server startup or dynamically to add personal actions/emotes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Unique action key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Fields similar to interactions but no target differentiation.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.playerinteract.addAction("wave", {
      category = "categoryEmotes",
      timeToComplete = 1,
      actionText = "@gesturing",
      onRun = function(client)
          client:DoAnimation(ACT_GMOD_GESTURE_WAVE)
      end
  })
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.playerinteract.sync></a>lia.playerinteract.sync(client)</summary>
<div class="details-content">
<a id="liaplayerinteractsync"></a>
<strong>Purpose</strong>
<p>Push registered interactions/actions and categories to clients.</p>

<strong>When Called</strong>
<p>After definitions change or when a player joins to keep menus current.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Send to one player if provided; otherwise broadcast in batches.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.playerinteract.hasChanges() then
      lia.playerinteract.sync() -- broadcast updates
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.playerinteract.hasChanges></a>lia.playerinteract.hasChanges()</summary>
<div class="details-content">
<a id="liaplayerinteracthaschanges"></a>
<strong>Purpose</strong>
<p>Determine if interaction/action definitions changed since last sync.</p>

<strong>When Called</strong>
<p>Prior to syncing to avoid unnecessary network traffic.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> true when counts differ from the last broadcast.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.playerinteract.hasChanges() then
      lia.playerinteract.sync()
  end
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.playerinteract.openMenu></a>lia.playerinteract.openMenu(options, isInteraction, titleText, closeKey, netMsg, preFiltered)</summary>
<div class="details-content">
<a id="liaplayerinteractopenmenu"></a>
<strong>Purpose</strong>
<p>Open the interaction or personal action menu on the client.</p>

<strong>When Called</strong>
<p>After receiving options from the server or when keybind handlers fire.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">options</span> Array of option entries plus category rows.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">isInteraction</span> true for interaction mode; false for personal actions.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">titleText</span> <span class="optional">optional</span> Optional menu title override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">closeKey</span> <span class="optional">optional</span> Optional key code to close the menu.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">netMsg</span> <span class="optional">optional</span> Net message name to send selections with.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">preFiltered</span> <span class="optional">optional</span> If true, options are already filtered for target/range visibility.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel|nil</a></span> The created menu panel.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  net.Receive("liaSendInteractOptions", function()
      local data = lia.net.readBigTable()
      local categorized = lia.playerinteract.getCategorizedOptions(data)
      lia.playerinteract.openMenu(categorized, true, L("interactionMenu"))
  end)
</code></pre>
</div>
</details>

---

