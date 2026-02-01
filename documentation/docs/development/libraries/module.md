# Modularity

Module loading, initialization, and lifecycle management system for the Lilia framework.

---

<strong>Overview</strong>

The modularity library provides comprehensive functionality for managing modules in the Lilia framework. It handles loading, initialization, and management of modules including schemas, preload modules, and regular modules. The library operates on both server and client sides, managing module dependencies, permissions, and lifecycle events. It includes functionality for loading modules from directories, handling module-specific data storage, and ensuring proper initialization order. The library also manages submodules, handles module validation, and provides hooks for module lifecycle events. It ensures that all modules are properly loaded and initialized before gameplay begins.

---

<details class="realm-shared">
<summary><a id=lia.module.load></a>lia.module.load(uniqueID, path, variable, skipSubmodules)</summary>
<div class="details-content">
<a id="liamoduleload"></a>
<strong>Purpose</strong>
<p>Loads and initializes a module from a specified directory path with the given unique ID.</p>

<strong>When Called</strong>
<p>Called during module initialization to load individual modules, their dependencies, and register them in the system.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique identifier for the module.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">path</span> The file system path to the module directory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">string, optional</a></span> <span class="parameter">variable</span> The global variable name to assign the module to (defaults to "MODULE").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">boolean, optional</a></span> <span class="parameter">skipSubmodules</span> Whether to skip loading submodules for this module.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Load a custom module
  lia.module.load("mymodule", "gamemodes/my_schema/modules/mymodule")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.module.initialize></a>lia.module.initialize()</summary>
<div class="details-content">
<a id="liamoduleinitialize"></a>
<strong>Purpose</strong>
<p>Initializes the entire module system by loading the schema, preload modules, and all available modules in the correct order.</p>

<strong>When Called</strong>
<p>Called once during gamemode initialization to set up the module loading system and load all modules.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Initialize the module system (called automatically by the framework)
  lia.module.initialize()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.module.loadFromDir></a>lia.module.loadFromDir(directory, group, skip)</summary>
<div class="details-content">
<a id="liamoduleloadfromdir"></a>
<strong>Purpose</strong>
<p>Loads all modules found in the specified directory, optionally skipping certain modules.</p>

<strong>When Called</strong>
<p>Called during module initialization to load groups of modules from directories like preload, modules, and overrides.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">directory</span> The directory path to search for modules.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">group</span> The type of modules being loaded ("schema" or "module").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">table, optional</a></span> <span class="parameter">skip</span> A table of module IDs to skip loading.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Load all modules from the gamemode's modules directory
  lia.module.loadFromDir("gamemodes/my_schema/modules", "module")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.module.get></a>lia.module.get(identifier)</summary>
<div class="details-content">
<a id="liamoduleget"></a>
<strong>Purpose</strong>
<p>Retrieves a loaded module by its unique identifier.</p>

<strong>When Called</strong>
<p>Called whenever code needs to access a specific module's data or functions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">identifier</span> The unique identifier of the module to retrieve.</p>

<strong>Returns</strong>
<p>table or nil The module table if found, nil if the module doesn't exist.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Get a reference to the inventory module
  local inventoryModule = lia.module.get("inventory")
  if inventoryModule then
      -- Use the module
  end
</code></pre>
</div>
</details>

---

