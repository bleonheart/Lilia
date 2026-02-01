# Commands

Comprehensive command registration, parsing, and execution system for the Lilia framework.

---

<strong>Overview</strong>

The commands library provides comprehensive functionality for managing and executing commands in the Lilia framework. It handles command registration, argument parsing, access control, privilege management, and command execution across both server and client sides. The library supports complex argument types including players, booleans, strings, and tables, with automatic syntax generation and validation. It integrates with the administrator system for privilege-based access control and provides user interface elements for command discovery and argument prompting. The library ensures secure command execution with proper permission checks and logging capabilities.

---

<details class="realm-shared">
<summary><a id=lia.command.buildSyntaxFromArguments></a>lia.command.buildSyntaxFromArguments(args)</summary>
<div class="details-content">
<a id="liacommandbuildsyntaxfromarguments"></a>
<strong>Purpose</strong>
<p>Generate a human-readable syntax string from a list of argument definitions.</p>

<strong>When Called</strong>
<p>During command registration to populate data.syntax for menus and help text.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">args</span> Array of argument tables {name=, type=, optional=}.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Concatenated syntax tokens describing the command arguments.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local syntax = lia.command.buildSyntaxFromArguments({
      {name = "target", type = "player"},
      {name = "amount", type = "number", optional = true}
  })
  -- "[player target] [string amount optional]"
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.command.add></a>lia.command.add(command, data)</summary>
<div class="details-content">
<a id="liacommandadd"></a>
<strong>Purpose</strong>
<p>Register a command and normalize its metadata, syntax, privileges, aliases, and callbacks.</p>

<strong>When Called</strong>
<p>During schema or module initialization to expose new chat/console commands.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">command</span> Unique command key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> Command definition (arguments, desc, privilege, superAdminOnly, adminOnly, alias, onRun, onCheckAccess, etc.).</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.command.add("bring", {
      desc = "Bring a player to you.",
      adminOnly = true,
      arguments = {
          {name = "target", type = "player"}
      },
      onRun = function(client, args)
          local target = lia.command.findPlayer(args[1])
          if IsValid(target) then target:SetPos(client:GetPos() + client:GetForward() * 50) end
      end
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.command.hasAccess></a>lia.command.hasAccess(client, command, data)</summary>
<div class="details-content">
<a id="liacommandhasaccess"></a>
<strong>Purpose</strong>
<p>Determine whether a client may run a command based on privileges, hooks, faction/class access, and custom checks.</p>

<strong>When Called</strong>
<p>Before executing a command or showing it in help menus.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Player requesting access.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">command</span> Command name to check.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> <span class="optional">optional</span> Command definition; looked up from lia.command.list when nil.</p>

<strong>Returns</strong>
<p>boolean, string allowed result and privilege name for UI/feedback.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local canUse, priv = lia.command.hasAccess(ply, "bring")
  if not canUse then ply:notifyErrorLocalized("noPerm") end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.command.extractArgs></a>lia.command.extractArgs(text)</summary>
<div class="details-content">
<a id="liacommandextractargs"></a>
<strong>Purpose</strong>
<p>Split a raw command string into arguments while preserving quoted segments.</p>

<strong>When Called</strong>
<p>When parsing chat-entered commands before validation or prompting.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Raw command text excluding the leading slash.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array of parsed arguments.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local args = lia.command.extractArgs("'John Doe' 250")
  -- {"John Doe", "250"}
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.command.run></a>lia.command.run(client, command, arguments)</summary>
<div class="details-content">
<a id="liacommandrun"></a>
<strong>Purpose</strong>
<p>Execute a registered command for a given client with arguments and emit post-run hooks.</p>

<strong>When Called</strong>
<p>After parsing chat input or console invocation server-side.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Player that issued the command (nil when run from server console).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">command</span> Command key to execute.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">arguments</span> <span class="optional">optional</span> Parsed command arguments.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.command.run(ply, "bring", {targetSteamID})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.command.parse></a>lia.command.parse(client, text, realCommand, arguments, Pre, Pre)</summary>
<div class="details-content">
<a id="liacommandparse"></a>
<strong>Purpose</strong>
<p>Parse chat text into a command invocation, prompt for missing args, and dispatch authorized commands.</p>

<strong>When Called</strong>
<p>On the server when a player sends chat starting with '/' or when manually dispatching a command.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Player whose chat is being parsed.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">text</span> Full chat text.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">realCommand</span> <span class="optional">optional</span> Command key when bypassing parsing (used by net/message dispatch).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">arguments</span> <span class="optional">optional</span> Pre-parsed arguments; when nil they are derived from text.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Pre</span> parsed arguments; when nil they are derived from text.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">unknown</a></span> <span class="parameter">Pre</span> parsed arguments; when nil they are derived from text.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> true if the text was handled as a command.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  hook.Add("PlayerSay", "liaChatCommands", function(ply, text)
      if lia.command.parse(ply, text) then return "" end
  end)
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.command.openArgumentPrompt></a>lia.command.openArgumentPrompt(cmdKey, missing, prefix)</summary>
<div class="details-content">
<a id="liacommandopenargumentprompt"></a>
<strong>Purpose</strong>
<p>Display a clientside UI prompt for missing command arguments and send the completed command back through chat.</p>

<strong>When Called</strong>
<p>After the server requests argument completion via the liaCmdArgPrompt net message.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">cmdKey</span> Command key being completed.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">missing</span> Names of missing arguments.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">prefix</span> <span class="optional">optional</span> Prefilled argument values.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.command.openArgumentPrompt("pm", {"target", "message"}, {"steamid"})
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.command.send></a>lia.command.send(command)</summary>
<div class="details-content">
<a id="liacommandsend"></a>
<strong>Purpose</strong>
<p>Send a command invocation to the server via net as a clientside helper.</p>

<strong>When Called</strong>
<p>From UI elements or client logic instead of issuing chat/console commands directly.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">command</span> Command key to invoke.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.command.send("respawn", LocalPlayer():SteamID())
</code></pre>
</div>
</details>

---

