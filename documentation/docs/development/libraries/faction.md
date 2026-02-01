# Faction

Comprehensive faction (team) management and registration system for the Lilia framework.

---

<strong>Overview</strong>

The faction library provides comprehensive functionality for managing factions (teams) in the Lilia framework. It handles registration, loading, and management of faction data including models, colors, descriptions, and team setup. The library operates on both server and client sides, with server handling faction registration and client handling whitelist checks. It includes functionality for loading factions from directories, managing faction models with bodygroup support, and providing utilities for faction categorization and player management. The library ensures proper team setup and model precaching for all registered factions, supporting both simple string models and complex model data with bodygroup configurations.

---

<details class="realm-shared">
<summary><a id=lia.faction.register></a>lia.faction.register(uniqueID, data)</summary>
<div class="details-content">
<a id="liafactionregister"></a>
<strong>Purpose</strong>
<p>Registers a new faction with the specified unique ID and data table, setting up team configuration and model caching.</p>

<strong>When Called</strong>
<p>Called during gamemode initialization to register factions programmatically, typically in shared files or during faction loading.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique identifier for the faction.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> A table containing faction configuration data including name, description, color, models, etc.</p>

<strong>Returns</strong>
<p>number, table Returns the faction index and the faction data table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local index, faction = lia.faction.register("citizen", {
      name = "Citizen",
      desc = "A regular citizen",
      color = Color(100, 150, 200),
      models = {"models/player/group01/male_01.mdl"}
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.cacheModels></a>lia.faction.cacheModels(models)</summary>
<div class="details-content">
<a id="liafactioncachemodels"></a>
<strong>Purpose</strong>
<p>Precaches model files to ensure they load quickly when needed, handling both string model paths and table-based model data.</p>

<strong>When Called</strong>
<p>Called automatically during faction registration to precache all models associated with a faction.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">models</span> A table of model data, where each entry can be a string path or a table with model information.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local models = {"models/player/group01/male_01.mdl", "models/player/group01/female_01.mdl"}
  lia.faction.cacheModels(models)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.loadFromDir></a>lia.faction.loadFromDir(directory)</summary>
<div class="details-content">
<a id="liafactionloadfromdir"></a>
<strong>Purpose</strong>
<p>Loads faction definitions from Lua files in a specified directory, registering each faction found.</p>

<strong>When Called</strong>
<p>Called during gamemode initialization to load faction definitions from organized directory structures.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">directory</span> The path to the directory containing faction definition files.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.faction.loadFromDir("gamemode/factions")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.get></a>lia.faction.get(identifier)</summary>
<div class="details-content">
<a id="liafactionget"></a>
<strong>Purpose</strong>
<p>Retrieves faction data by either its unique ID or index number.</p>

<strong>When Called</strong>
<p>Called whenever faction information needs to be accessed by other systems or scripts.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">identifier</span> The faction's unique ID string or numeric index.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The faction data table, or nil if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local faction = lia.faction.get("citizen")
  -- or
  local faction = lia.faction.get(1)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getIndex></a>lia.faction.getIndex(uniqueID)</summary>
<div class="details-content">
<a id="liafactiongetindex"></a>
<strong>Purpose</strong>
<p>Retrieves the numeric team index for a faction given its unique ID.</p>

<strong>When Called</strong>
<p>Called when the numeric team index is needed for GMod team functions or comparisons.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique identifier of the faction.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> The faction's team index, or nil if the faction doesn't exist.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local index = lia.faction.getIndex("citizen")
  if index then
      print("Citizen faction index: " .. index)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getClasses></a>lia.faction.getClasses(faction)</summary>
<div class="details-content">
<a id="liafactiongetclasses"></a>
<strong>Purpose</strong>
<p>Retrieves all character classes that belong to a specific faction.</p>

<strong>When Called</strong>
<p>Called when needing to display or work with all classes available to a faction.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">faction</span> The faction identifier (unique ID or index).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> An array of class data tables that belong to the specified faction.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local classes = lia.faction.getClasses("citizen")
  for _, class in ipairs(classes) do
      print("Class: " .. class.name)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getPlayers></a>lia.faction.getPlayers(faction)</summary>
<div class="details-content">
<a id="liafactiongetplayers"></a>
<strong>Purpose</strong>
<p>Retrieves all players who are currently playing characters in the specified faction.</p>

<strong>When Called</strong>
<p>Called when needing to iterate over or work with all players belonging to a specific faction.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">faction</span> The faction identifier (unique ID or index).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> An array of player entities who belong to the specified faction.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local players = lia.faction.getPlayers("citizen")
  for _, player in ipairs(players) do
      player:ChatPrint("Hello citizens!")
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getPlayerCount></a>lia.faction.getPlayerCount(faction)</summary>
<div class="details-content">
<a id="liafactiongetplayercount"></a>
<strong>Purpose</strong>
<p>Counts the number of players currently playing characters in the specified faction.</p>

<strong>When Called</strong>
<p>Called when needing to know how many players are in a faction for UI display, limits, or statistics.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">faction</span> The faction identifier (unique ID or index).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> The number of players in the specified faction.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local count = lia.faction.getPlayerCount("citizen")
  print("There are " .. count .. " citizens online")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.isFactionCategory></a>lia.faction.isFactionCategory(faction, categoryFactions)</summary>
<div class="details-content">
<a id="liafactionisfactioncategory"></a>
<strong>Purpose</strong>
<p>Checks if a faction belongs to a specific category of factions.</p>

<strong>When Called</strong>
<p>Called when determining if a faction is part of a group or category for organizational purposes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">faction</span> The faction identifier to check.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">categoryFactions</span> An array of faction identifiers that define the category.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the faction is in the category, false otherwise.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local lawFactions = {"police", "sheriff"}
  if lia.faction.isFactionCategory("police", lawFactions) then
      print("This is a law enforcement faction")
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.jobGenerate></a>lia.faction.jobGenerate(index, name, color, default, models)</summary>
<div class="details-content">
<a id="liafactionjobgenerate"></a>
<strong>Purpose</strong>
<p>Generates a basic faction configuration programmatically with minimal required parameters.</p>

<strong>When Called</strong>
<p>Called for quick faction creation during development or for compatibility with other systems.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">index</span> The numeric team index for the faction.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> The display name of the faction.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">color</span> The color associated with the faction.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">default</span> Whether this is a default faction that doesn't require whitelisting.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">models</span> Array of model paths for the faction (optional, uses defaults if not provided).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The created faction data table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local faction = lia.faction.jobGenerate(5, "Visitor", Color(200, 200, 200), true)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.formatModelData></a>lia.faction.formatModelData()</summary>
<div class="details-content">
<a id="liafactionformatmodeldata"></a>
<strong>Purpose</strong>
<p>Formats and standardizes model data across all factions, converting bodygroup configurations to proper format.</p>

<strong>When Called</strong>
<p>Called after faction loading to ensure all model data is properly formatted for use.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Called automatically during faction initialization
  lia.faction.formatModelData()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getCategories></a>lia.faction.getCategories(teamName)</summary>
<div class="details-content">
<a id="liafactiongetcategories"></a>
<strong>Purpose</strong>
<p>Retrieves all model categories defined for a faction (string keys in the models table).</p>

<strong>When Called</strong>
<p>Called when needing to display or work with faction model categories in UI or selection systems.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">teamName</span> The unique ID of the faction.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> An array of category names (strings) defined for the faction's models.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local categories = lia.faction.getCategories("citizen")
  for _, category in ipairs(categories) do
      print("Category: " .. category)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getModelsFromCategory></a>lia.faction.getModelsFromCategory(teamName, category)</summary>
<div class="details-content">
<a id="liafactiongetmodelsfromcategory"></a>
<strong>Purpose</strong>
<p>Retrieves all models belonging to a specific category within a faction.</p>

<strong>When Called</strong>
<p>Called when needing to display or select models from a particular category for character creation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">teamName</span> The unique ID of the faction.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">category</span> The name of the model category to retrieve.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> A table of models in the specified category, indexed by their position.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local models = lia.faction.getModelsFromCategory("citizen", "male")
  for index, model in pairs(models) do
      print("Model " .. index .. ": " .. (istable(model) and model[1] or model))
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.faction.getDefaultClass></a>lia.faction.getDefaultClass(id)</summary>
<div class="details-content">
<a id="liafactiongetdefaultclass"></a>
<strong>Purpose</strong>
<p>Retrieves the default character class for a faction (marked with isDefault = true).</p>

<strong>When Called</strong>
<p>Called when automatically assigning a class to new characters or when needing the primary class for a faction.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">id</span> The faction identifier (unique ID or index).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The default class data table for the faction, or nil if no default class exists.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local defaultClass = lia.faction.getDefaultClass("citizen")
  if defaultClass then
      print("Default class: " .. defaultClass.name)
  end
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=lia.faction.hasWhitelist></a>lia.faction.hasWhitelist(faction)</summary>
<div class="details-content">
<a id="liafactionhaswhitelist"></a>
<strong>Purpose</strong>
<p>Checks if the local player has whitelist access to the specified faction on the client side.</p>

<strong>When Called</strong>
<p>Called on the client when determining if a faction should be available for character creation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">faction</span> The faction identifier (unique ID or index).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the player has access to the faction, false otherwise.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if lia.faction.hasWhitelist("citizen") then
      -- Show citizen faction in character creation menu
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.faction.hasWhitelist></a>lia.faction.hasWhitelist(faction)</summary>
<div class="details-content">
<a id="liafactionhaswhitelist"></a>
<strong>Purpose</strong>
<p>Checks whitelist access for a faction on the server side (currently simplified implementation).</p>

<strong>When Called</strong>
<p>Called on the server for faction access validation, though the current implementation is restrictive.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|number</a></span> <span class="parameter">faction</span> The faction identifier (unique ID or index).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True only for default factions, false for all others including staff.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Server-side validation
  if lia.faction.hasWhitelist("citizen") then
      -- Allow character creation
  end
</code></pre>
</div>
</details>

---

