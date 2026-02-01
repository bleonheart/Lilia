# Item

Comprehensive item registration, instantiation, and management system for the Lilia framework.

---

<strong>Overview</strong>

The item library provides comprehensive functionality for managing items in the Lilia framework. It handles item registration, instantiation, inventory management, and item operations such as dropping, taking, rotating, and transferring items between players. The library operates on both server and client sides, with server-side functions handling database operations, item spawning, and data persistence, while client-side functions manage item interactions and UI operations. It includes automatic weapon and ammunition generation from Garry's Mod weapon lists, inventory type registration, and item entity management. The library ensures proper item lifecycle management from creation to deletion, with support for custom item functions, hooks, and data persistence.

---

<details class="realm-shared">
<summary><a id=lia.item.get></a>lia.item.get(identifier)</summary>
<div class="details-content">
<a id="liaitemget"></a>
<strong>Purpose</strong>
<p>Retrieves an item definition (base or regular item) by its unique identifier.</p>

<strong>When Called</strong>
<p>Called when needing to access item definitions for registration, validation, or manipulation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">identifier</span> The unique identifier of the item to retrieve.</p>

<strong>Returns</strong>
<p>table or nil The item definition table if found, nil if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local weaponItem = lia.item.get("weapon_pistol")
  if weaponItem then
      print("Found weapon:", weaponItem.name)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.getItemByID></a>lia.item.getItemByID(itemID)</summary>
<div class="details-content">
<a id="liaitemgetitembyid"></a>
<strong>Purpose</strong>
<p>Retrieves an instanced item by its ID and determines its current location.</p>

<strong>When Called</strong>
<p>Called when needing to access specific item instances, typically for manipulation or inspection.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">itemID</span> The unique ID of the instanced item to retrieve.</p>

<strong>Returns</strong>
<p>table or nil, string A table containing the item and its location ("inventory", "world", or "unknown"), or nil and an error message if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local itemData, errorMsg = lia.item.getItemByID(123)
  if itemData then
      print("Item found at:", itemData.location)
      -- Use itemData.item for item operations
  else
      print("Error:", errorMsg)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.getInstancedItemByID></a>lia.item.getInstancedItemByID(itemID)</summary>
<div class="details-content">
<a id="liaitemgetinstanceditembyid"></a>
<strong>Purpose</strong>
<p>Retrieves an instanced item directly by its ID without location information.</p>

<strong>When Called</strong>
<p>Called when needing to access item instances for direct manipulation without location context.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">itemID</span> The unique ID of the instanced item to retrieve.</p>

<strong>Returns</strong>
<p>table or nil, string The item instance if found, or nil and an error message if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local item, errorMsg = lia.item.getInstancedItemByID(123)
  if item then
      item:setData("customValue", "example")
  else
      print("Error:", errorMsg)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.getItemDataByID></a>lia.item.getItemDataByID(itemID)</summary>
<div class="details-content">
<a id="liaitemgetitemdatabyid"></a>
<strong>Purpose</strong>
<p>Retrieves the data table of an instanced item by its ID.</p>

<strong>When Called</strong>
<p>Called when needing to access or inspect the custom data stored on an item instance.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">itemID</span> The unique ID of the instanced item to retrieve data from.</p>

<strong>Returns</strong>
<p>table or nil, string The item's data table if found, or nil and an error message if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local data, errorMsg = lia.item.getItemDataByID(123)
  if data then
      print("Item durability:", data.durability or "N/A")
  else
      print("Error:", errorMsg)
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.load></a>lia.item.load(path, baseID, isBaseItem)</summary>
<div class="details-content">
<a id="liaitemload"></a>
<strong>Purpose</strong>
<p>Loads and registers an item from a file path by extracting the unique ID and registering it.</p>

<strong>When Called</strong>
<p>Called during item loading process to register items from files in the items directory.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">path</span> The file path of the item to load.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">string, optional</a></span> <span class="parameter">baseID</span> The base item ID to inherit from.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">boolean, optional</a></span> <span class="parameter">isBaseItem</span> Whether this is a base item definition.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Load a regular item
  lia.item.load("lilia/gamemode/items/food_apple.lua")
  -- Load a base item
  lia.item.load("lilia/gamemode/items/base/sh_food.lua", nil, true)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.isItem></a>lia.item.isItem(object)</summary>
<div class="details-content">
<a id="liaitemisitem"></a>
<strong>Purpose</strong>
<p>Checks if an object is a valid Lilia item instance.</p>

<strong>When Called</strong>
<p>Called to validate that an object is an item before performing item-specific operations.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">object</span> The object to check if it's an item.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the object is a valid item, false otherwise.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local someObject = getSomeObject()
  if lia.item.isItem(someObject) then
      someObject:setData("used", true)
  else
      print("Object is not an item")
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.getInv></a>lia.item.getInv(invID)</summary>
<div class="details-content">
<a id="liaitemgetinv"></a>
<strong>Purpose</strong>
<p>Retrieves an inventory instance by its ID.</p>

<strong>When Called</strong>
<p>Called when needing to access inventory objects for item operations or inspection.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">invID</span> The unique ID of the inventory to retrieve.</p>

<strong>Returns</strong>
<p>table or nil The inventory instance if found, nil if not found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local inventory = lia.item.getInv(5)
  if inventory then
      print("Inventory size:", inventory:getWidth(), "x", inventory:getHeight())
  end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.addRarities></a>lia.item.addRarities(name, color)</summary>
<div class="details-content">
<a id="liaitemaddrarities"></a>
<strong>Purpose</strong>
<p>Adds a new item rarity tier with an associated color for visual identification.</p>

<strong>When Called</strong>
<p>Called during item system initialization to define available rarity levels for items.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> The name of the rarity tier (e.g., "Common", "Rare", "Legendary").</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Color">Color</a></span> <span class="parameter">color</span> The color associated with this rarity tier.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.item.addRarities("Mythical", Color(255, 0, 255))
  lia.item.addRarities("Divine", Color(255, 215, 0))
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.register></a>lia.item.register(uniqueID, baseID, isBaseItem, path, luaGenerated)</summary>
<div class="details-content">
<a id="liaitemregister"></a>
<strong>Purpose</strong>
<p>Registers an item definition with the Lilia item system, setting up inheritance and default functions.</p>

<strong>When Called</strong>
<p>Called during item loading to register item definitions, either from files or programmatically generated.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique identifier for the item.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">string, optional</a></span> <span class="parameter">baseID</span> The base item ID to inherit from (defaults to lia.meta.item).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">boolean, optional</a></span> <span class="parameter">isBaseItem</span> Whether this is a base item definition.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">string, optional</a></span> <span class="parameter">path</span> The file path for loading the item (used for shared loading).</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">boolean, optional</a></span> <span class="parameter">luaGenerated</span> Whether the item is generated programmatically rather than loaded from a file.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The registered item definition table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Register a base item
  lia.item.register("base_weapon", nil, true, "path/to/base_weapon.lua")
  -- Register a regular item
  lia.item.register("weapon_pistol", "base_weapon", false, "path/to/weapon_pistol.lua")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.registerItem></a>lia.item.registerItem(id, base, properties)</summary>
<div class="details-content">
<a id="liaitemregisteritem"></a>
<strong>Purpose</strong>
<p>Queues an item for deferred registration and returns a placeholder that can access the item once registered.</p>

<strong>When Called</strong>
<p>Called during item system initialization to register items that will be created later, such as auto-generated weapons or ammunition items.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">id</span> The unique identifier for the item to register.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">string, optional</a></span> <span class="parameter">base</span> The base item ID to inherit from.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">table, optional</a></span> <span class="parameter">properties</span> A table of properties to apply to the item when it is registered.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> A placeholder object that can access the actual item properties once registration is complete.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Queue a weapon item for registration
  local weaponPlaceholder = lia.item.registerItem("weapon_pistol", "base_weapons", {
      name = "Custom Pistol",
      width = 2,
      height = 1
  })
  -- The actual item will be registered when InitializedModules hook runs
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.overrideItem></a>lia.item.overrideItem(uniqueID, overrides)</summary>
<div class="details-content">
<a id="liaitemoverrideitem"></a>
<strong>Purpose</strong>
<p>Queues property overrides for an item that will be applied when the item is initialized.</p>

<strong>When Called</strong>
<p>Called during item system setup to modify item properties before they are finalized.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique ID of the item to override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">overrides</span> A table of properties to override on the item.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.item.overrideItem("weapon_pistol", {
      name = "Custom Pistol",
      width = 2,
      height = 1,
      price = 500
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.loadFromDir></a>lia.item.loadFromDir(directory)</summary>
<div class="details-content">
<a id="liaitemloadfromdir"></a>
<strong>Purpose</strong>
<p>Loads all items from a directory structure, organizing base items and regular items.</p>

<strong>When Called</strong>
<p>Called during gamemode initialization to load all item definitions from the items directory.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">directory</span> The directory path containing the item files to load.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Load all items from the gamemode's items directory
  lia.item.loadFromDir("lilia/gamemode/items")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.new></a>lia.item.new(uniqueID, id)</summary>
<div class="details-content">
<a id="liaitemnew"></a>
<strong>Purpose</strong>
<p>Creates a new item instance from an item definition with a specific ID.</p>

<strong>When Called</strong>
<p>Called when instantiating items from the database or creating new items programmatically.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique ID of the item definition to instantiate.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">id</span> The unique instance ID for this item.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The newly created item instance.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Create a new pistol item instance
  local pistol = lia.item.new("weapon_pistol", 123)
  pistol:setData("durability", 100)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.registerInv></a>lia.item.registerInv(invType, w, h)</summary>
<div class="details-content">
<a id="liaitemregisterinv"></a>
<strong>Purpose</strong>
<p>Registers a new inventory type with specified dimensions.</p>

<strong>When Called</strong>
<p>Called during inventory system initialization to define different inventory types.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">invType</span> The unique type identifier for this inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> The width of the inventory in grid units.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> The height of the inventory in grid units.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Register a backpack inventory type
  lia.item.registerInv("backpack", 4, 6)
  -- Register a safe inventory type
  lia.item.registerInv("safe", 8, 8)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.newInv></a>lia.item.newInv(owner, invType, callback)</summary>
<div class="details-content">
<a id="liaitemnewinv"></a>
<strong>Purpose</strong>
<p>Creates a new inventory instance for a character and syncs it with the appropriate player.</p>

<strong>When Called</strong>
<p>Called when creating new inventories for characters, such as during character creation or item operations.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">owner</span> The character ID that owns this inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">invType</span> The type of inventory to create.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">function, optional</a></span> <span class="parameter">callback</span> Function called when the inventory is created and ready.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Create a backpack inventory for character ID 5
  lia.item.newInv(5, "backpack", function(inventory)
      print("Backpack created with ID:", inventory:getID())
  end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.createInv></a>lia.item.createInv(w, h, id)</summary>
<div class="details-content">
<a id="liaitemcreateinv"></a>
<strong>Purpose</strong>
<p>Creates a new inventory instance with specified dimensions and registers it.</p>

<strong>When Called</strong>
<p>Called when creating inventories programmatically, such as for containers or special storage.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> The width of the inventory in grid units.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> The height of the inventory in grid units.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">id</span> The unique ID for this inventory instance.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> The created inventory instance.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Create a 4x6 container inventory
  local container = lia.item.createInv(4, 6, 1001)
  print("Container created with ID:", container.id)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.addWeaponOverride></a>lia.item.addWeaponOverride(className, data)</summary>
<div class="details-content">
<a id="liaitemaddweaponoverride"></a>
<strong>Purpose</strong>
<p>Adds custom override data for weapon items during auto-generation.</p>

<strong>When Called</strong>
<p>Called during weapon item generation to customize properties of specific weapons.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">className</span> The weapon class name to override.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">data</span> The override data containing weapon properties.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  lia.item.addWeaponOverride("weapon_pistol", {
      name = "Custom Pistol",
      width = 2,
      height = 1,
      price = 500,
      model = "models/weapons/custom_pistol.mdl"
  })
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=lia.item.addWeaponToBlacklist></a>lia.item.addWeaponToBlacklist(className)</summary>
<div class="details-content">
<a id="liaitemaddweapontoblacklist"></a>
<strong>Purpose</strong>
<p>Adds a weapon class to the blacklist to prevent it from being auto-generated as an item.</p>

<strong>When Called</strong>
<p>Called during weapon generation setup to exclude certain weapons from item creation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">className</span> The weapon class name to blacklist.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Prevent admin tools from being generated as items
  lia.item.addWeaponToBlacklist("weapon_physgun")
  lia.item.addWeaponToBlacklist("gmod_tool")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.item.setItemDataByID></a>lia.item.setItemDataByID(itemID, key, value, receivers, noSave, noCheckEntity)</summary>
<div class="details-content">
<a id="liaitemsetitemdatabyid"></a>
<strong>Purpose</strong>
<p>Sets data on an item instance by its ID and synchronizes the changes.</p>

<strong>When Called</strong>
<p>Called when needing to modify item data server-side and sync to clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">itemID</span> The unique ID of the item instance.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> The data key to set.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> The value to set for the key.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">table, optional</a></span> <span class="parameter">receivers</span> Specific players to sync the data to.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">boolean, optional</a></span> <span class="parameter">noSave</span> Whether to skip saving to database.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">boolean, optional</a></span> <span class="parameter">noCheckEntity</span> Whether to skip entity validation.</p>

<strong>Returns</strong>
<p>boolean, string True if successful, false and error message if failed.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local success, errorMsg = lia.item.setItemDataByID(123, "durability", 75)
  if success then
      print("Item durability updated")
  else
      print("Error:", errorMsg)
  end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.item.instance></a>lia.item.instance(index, uniqueID, itemData, x, y, callback)</summary>
<div class="details-content">
<a id="liaiteminstance"></a>
<strong>Purpose</strong>
<p>Creates a new item instance in the database and returns the created item.</p>

<strong>When Called</strong>
<p>Called when creating new items that need to be persisted to the database.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|string</a></span> <span class="parameter">index</span> The inventory ID or unique ID if first parameter is string.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string|table</a></span> <span class="parameter">uniqueID</span> The item definition unique ID or item data if index is string.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">table, optional</a></span> <span class="parameter">itemData</span> The item data to set on creation.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">number, optional</a></span> <span class="parameter">x</span> The X position in inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">number, optional</a></span> <span class="parameter">y</span> The Y position in inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">function, optional</a></span> <span class="parameter">callback</span> Function called when item is created.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> A deferred promise that resolves with the created item.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Create a pistol in inventory 5 at position 1,1
  lia.item.instance(5, "weapon_pistol", {}, 1, 1):next(function(item)
      print("Created item with ID:", item:getID())
  end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.item.deleteByID></a>lia.item.deleteByID(id)</summary>
<div class="details-content">
<a id="liaitemdeletebyid"></a>
<strong>Purpose</strong>
<p>Deletes an item instance by its ID from memory and/or database.</p>

<strong>When Called</strong>
<p>Called when permanently removing items from the game world.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">id</span> The unique ID of the item to delete.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Delete item with ID 123
  lia.item.deleteByID(123)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.item.loadItemByID></a>lia.item.loadItemByID(itemIndex)</summary>
<div class="details-content">
<a id="liaitemloaditembyid"></a>
<strong>Purpose</strong>
<p>Loads item instances from the database by their IDs and recreates them in memory.</p>

<strong>When Called</strong>
<p>Called during server startup or when needing to restore items from the database.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|table</a></span> <span class="parameter">itemIndex</span> Single item ID or array of item IDs to load.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Load a single item
  lia.item.loadItemByID(123)
  -- Load multiple items
  lia.item.loadItemByID({123, 456, 789})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.item.spawn></a>lia.item.spawn(uniqueID, position, callback, angles, data)</summary>
<div class="details-content">
<a id="liaitemspawn"></a>
<strong>Purpose</strong>
<p>Creates and spawns an item entity in the world at the specified position.</p>

<strong>When Called</strong>
<p>Called when dropping items or creating item entities in the game world.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> The unique ID of the item to spawn.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector</a></span> <span class="parameter">position</span> The position to spawn the item at.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">function, optional</a></span> <span class="parameter">callback</span> Function called when item is spawned.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Angle, optional</a></span> <span class="parameter">angles</span> The angles to set on the spawned item.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">table, optional</a></span> <span class="parameter">data</span> The item data to set on creation.</p>

<strong>Returns</strong>
<p>table or nil A deferred promise that resolves with the spawned item, or nil if synchronous.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Spawn a pistol at a position
  lia.item.spawn("weapon_pistol", Vector(0, 0, 0), function(item)
      print("Spawned item:", item:getName())
  end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=lia.item.restoreInv></a>lia.item.restoreInv(invID, w, h, callback)</summary>
<div class="details-content">
<a id="liaitemrestoreinv"></a>
<strong>Purpose</strong>
<p>Restores an inventory from the database and sets its dimensions.</p>

<strong>When Called</strong>
<p>Called when loading saved inventories from the database.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">invID</span> The unique ID of the inventory to restore.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">w</span> The width of the inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">h</span> The height of the inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">function, optional</a></span> <span class="parameter">callback</span> Function called when inventory is restored.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  -- Restore a 4x6 inventory
  lia.item.restoreInv(5, 4, 6, function(inventory)
      print("Restored inventory with", inventory:getItemCount(), "items")
  end)
</code></pre>
</div>
</details>

---

