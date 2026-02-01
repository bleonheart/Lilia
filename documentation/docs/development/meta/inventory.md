# Inventory

Inventory management system for the Lilia framework.

---

<strong>Overview</strong>

The inventory meta table provides comprehensive functionality for managing inventory data, item storage, and inventory operations in the Lilia framework. It handles inventory creation, item management, data persistence, capacity management, and inventory-specific operations. The meta table operates on both server and client sides, with the server managing inventory storage and validation while the client provides inventory data access and display. It includes integration with the item system for item storage, database system for inventory persistence, character system for character inventories, and network system for inventory synchronization. The meta table ensures proper inventory data synchronization, item capacity management, item validation, and comprehensive inventory lifecycle management from creation to deletion.

---

<details class="realm-shared">
<summary><a id=getData></a>getData(key, default)</summary>
<div class="details-content">
<a id="getdata"></a>
<strong>Purpose</strong>
<p>Retrieves a stored data value on the inventory.</p>

<strong>When Called</strong>
<p>Use whenever reading custom inventory metadata.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to read.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Value returned when the key is missing.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value or the provided default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local owner = inv:getData("char")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=extend></a>extend(className)</summary>
<div class="details-content">
<a id="extend"></a>
<strong>Purpose</strong>
<p>Creates a subclass of Inventory with its own metatable.</p>

<strong>When Called</strong>
<p>Use when defining a new inventory type.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">className</span> Registry name for the new subclass.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Newly created subclass table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local Backpack = Inventory:extend("liaBackpack")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=configure></a>configure()</summary>
<div class="details-content">
<a id="configure"></a>
<strong>Purpose</strong>
<p>Sets up inventory defaults; meant to be overridden.</p>

<strong>When Called</strong>
<p>Invoked during type registration to configure behavior.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:configure() self.config.size = {4,4} end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=configure></a>configure()</summary>
<div class="details-content">
<a id="configure"></a>
<strong>Purpose</strong>
<p>Sets up inventory defaults; meant to be overridden.</p>

<strong>When Called</strong>
<p>Invoked during type registration to configure behavior.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:configure() self.config.size = {4,4} end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=addDataProxy></a>addDataProxy(key, onChange)</summary>
<div class="details-content">
<a id="adddataproxy"></a>
<strong>Purpose</strong>
<p>Registers a proxy callback for a specific data key.</p>

<strong>When Called</strong>
<p>Use when you need to react to data changes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to watch.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">onChange</span> Callback receiving old and new values.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:addDataProxy("locked", function(o,n) end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItemsByUniqueID></a>getItemsByUniqueID(uniqueID, onlyMain)</summary>
<div class="details-content">
<a id="getitemsbyuniqueid"></a>
<strong>Purpose</strong>
<p>Returns all items in the inventory matching a uniqueID.</p>

<strong>When Called</strong>
<p>Use when finding all copies of a specific item type.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">uniqueID</span> Item unique identifier.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">onlyMain</span> Restrict search to main inventory when true.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array of matching item instances.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local meds = inv:getItemsByUniqueID("medkit")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=register></a>register(typeID)</summary>
<div class="details-content">
<a id="register"></a>
<strong>Purpose</strong>
<p>Registers this inventory type with the system.</p>

<strong>When Called</strong>
<p>Invoke once per subclass to set type ID and defaults.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">typeID</span> Unique identifier for this inventory type.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  Inventory:register("bag")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=new></a>new()</summary>
<div class="details-content">
<a id="new"></a>
<strong>Purpose</strong>
<p>Creates a new instance of this inventory type.</p>

<strong>When Called</strong>
<p>Use when a character or container needs a fresh inventory.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Deferred inventory instance creation.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local inv = Inventory:new()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=tostring></a>tostring()</summary>
<div class="details-content">
<a id="tostring"></a>
<strong>Purpose</strong>
<p>Formats the inventory as a readable string with its ID.</p>

<strong>When Called</strong>
<p>Use for logging or debugging output.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Localized class name and ID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  print(inv:tostring())
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getType></a>getType()</summary>
<div class="details-content">
<a id="gettype"></a>
<strong>Purpose</strong>
<p>Returns the inventory type definition table.</p>

<strong>When Called</strong>
<p>Use when accessing type-level configuration.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Registered inventory type data.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local typeData = inv:getType()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=onDataChanged></a>onDataChanged(key, oldValue, newValue)</summary>
<div class="details-content">
<a id="ondatachanged"></a>
<strong>Purpose</strong>
<p>Fires proxy callbacks when a tracked data value changes.</p>

<strong>When Called</strong>
<p>Internally after setData updates.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key that changed.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">oldValue</span> Previous value.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">newValue</span> New value.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:onDataChanged("locked", false, true)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItems></a>getItems()</summary>
<div class="details-content">
<a id="getitems"></a>
<strong>Purpose</strong>
<p>Returns the table of item instances in this inventory.</p>

<strong>When Called</strong>
<p>Use when iterating all items.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Item instances keyed by item ID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  for id, itm in pairs(inv:getItems()) do end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItemsOfType></a>getItemsOfType(itemType)</summary>
<div class="details-content">
<a id="getitemsoftype"></a>
<strong>Purpose</strong>
<p>Collects items of a given type from the inventory.</p>

<strong>When Called</strong>
<p>Use when filtering for a specific item uniqueID.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">itemType</span> Unique item identifier to match.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Array of matching items.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local foods = inv:getItemsOfType("food")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getFirstItemOfType></a>getFirstItemOfType(itemType)</summary>
<div class="details-content">
<a id="getfirstitemoftype"></a>
<strong>Purpose</strong>
<p>Returns the first item matching a uniqueID.</p>

<strong>When Called</strong>
<p>Use when only one instance of a type is needed.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">itemType</span> Unique item identifier to find.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table|nil</a></span> Item instance or nil if none found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local gun = inv:getFirstItemOfType("pistol")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hasItem></a>hasItem(itemType)</summary>
<div class="details-content">
<a id="hasitem"></a>
<strong>Purpose</strong>
<p>Checks whether the inventory contains an item type.</p>

<strong>When Called</strong>
<p>Use before consuming or requiring an item.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">itemType</span> Unique item identifier to check.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if at least one matching item exists.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if inv:hasItem("keycard") then unlock() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getItemCount></a>getItemCount(itemType)</summary>
<div class="details-content">
<a id="getitemcount"></a>
<strong>Purpose</strong>
<p>Counts items, optionally filtering by uniqueID.</p>

<strong>When Called</strong>
<p>Use for capacity checks or UI badge counts.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">itemType</span> <span class="optional">optional</span> Unique ID to filter by; nil counts all.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Total quantity of matching items.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ammoCount = inv:getItemCount("ammo")
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getID></a>getID()</summary>
<div class="details-content">
<a id="getid"></a>
<strong>Purpose</strong>
<p>Returns the numeric identifier for this inventory.</p>

<strong>When Called</strong>
<p>Use when networking, saving, or comparing inventories.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Inventory ID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local id = inv:getID()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addItem></a>addItem(item, noReplicate)</summary>
<div class="details-content">
<a id="additem"></a>
<strong>Purpose</strong>
<p>Inserts an item into this inventory and persists its invID.</p>

<strong>When Called</strong>
<p>Use when adding an item to the inventory on the server.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.item/">Item</a></span> <span class="parameter">item</span> Item instance to add.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noReplicate</span> Skip replication hooks when true.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.inventory/">Inventory</a></span> The inventory for chaining.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:addItem(item)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=add></a>add(item)</summary>
<div class="details-content">
<a id="add"></a>
<strong>Purpose</strong>
<p>Alias to addItem for convenience.</p>

<strong>When Called</strong>
<p>Use wherever you would call addItem.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.item/">Item</a></span> <span class="parameter">item</span> Item instance to add.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.inventory/">Inventory</a></span> The inventory for chaining.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:add(item)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncItemAdded></a>syncItemAdded(item)</summary>
<div class="details-content">
<a id="syncitemadded"></a>
<strong>Purpose</strong>
<p>Notifies clients about an item newly added to this inventory.</p>

<strong>When Called</strong>
<p>Invoked after addItem to replicate state.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.item/">Item</a></span> <span class="parameter">item</span> Item instance already inserted.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:syncItemAdded(item)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=initializeStorage></a>initializeStorage(initialData)</summary>
<div class="details-content">
<a id="initializestorage"></a>
<strong>Purpose</strong>
<p>Creates a database record for a new inventory and its data.</p>

<strong>When Called</strong>
<p>Use during initial inventory creation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">initialData</span> Key/value pairs to seed invdata rows; may include char.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves with new inventory ID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:initializeStorage({char = charID})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=restoreFromStorage></a>restoreFromStorage()</summary>
<div class="details-content">
<a id="restorefromstorage"></a>
<strong>Purpose</strong>
<p>Hook for restoring inventory data from storage.</p>

<strong>When Called</strong>
<p>Override to load custom data during restoration.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:restoreFromStorage() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=restoreFromStorage></a>restoreFromStorage()</summary>
<div class="details-content">
<a id="restorefromstorage"></a>
<strong>Purpose</strong>
<p>Hook for restoring inventory data from storage.</p>

<strong>When Called</strong>
<p>Override to load custom data during restoration.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:restoreFromStorage() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removeItem></a>removeItem(itemID, preserveItem)</summary>
<div class="details-content">
<a id="removeitem"></a>
<strong>Purpose</strong>
<p>Removes an item from this inventory and updates clients/DB.</p>

<strong>When Called</strong>
<p>Use when deleting or moving items out of the inventory.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">itemID</span> ID of the item to remove.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">preserveItem</span> Keep the instance and DB row when true.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves after removal finishes.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:removeItem(itemID)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=remove></a>remove(itemID)</summary>
<div class="details-content">
<a id="remove"></a>
<strong>Purpose</strong>
<p>Alias for removeItem.</p>

<strong>When Called</strong>
<p>Use interchangeably with removeItem.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">itemID</span> ID of the item to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves after removal.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:remove(id)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setData></a>setData(key, value)</summary>
<div class="details-content">
<a id="setdata"></a>
<strong>Purpose</strong>
<p>Updates inventory data, persists it, and notifies listeners.</p>

<strong>When Called</strong>
<p>Use to change stored metadata such as character assignment.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to set.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> New value or nil to delete.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.inventory/">Inventory</a></span> The inventory for chaining.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:setData("locked", true)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=canAccess></a>canAccess(action, context)</summary>
<div class="details-content">
<a id="canaccess"></a>
<strong>Purpose</strong>
<p>Evaluates access rules for a given action context.</p>

<strong>When Called</strong>
<p>Use before allowing inventory interactions.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">action</span> Action name (e.g., "repl", "transfer").</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">context</span> Additional data such as client.</p>

<strong>Returns</strong>
<p>boolean|nil, string|nil Decision and optional reason if a rule handled it.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ok = inv:canAccess("repl", {client = ply})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addAccessRule></a>addAccessRule(rule, priority)</summary>
<div class="details-content">
<a id="addaccessrule"></a>
<strong>Purpose</strong>
<p>Inserts an access rule into the rule list.</p>

<strong>When Called</strong>
<p>Use when configuring permissions for this inventory type.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">rule</span> Function returning decision and reason.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">priority</span> <span class="optional">optional</span> Optional insert position.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.inventory/">Inventory</a></span> The inventory for chaining.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:addAccessRule(myRule, 1)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removeAccessRule></a>removeAccessRule(rule)</summary>
<div class="details-content">
<a id="removeaccessrule"></a>
<strong>Purpose</strong>
<p>Removes a previously added access rule.</p>

<strong>When Called</strong>
<p>Use when unregistering dynamic permission logic.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">rule</span> The rule function to remove.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.inventory/">Inventory</a></span> The inventory for chaining.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:removeAccessRule(myRule)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=getRecipients></a>getRecipients()</summary>
<div class="details-content">
<a id="getrecipients"></a>
<strong>Purpose</strong>
<p>Determines which players should receive inventory replication.</p>

<strong>When Called</strong>
<p>Use before sending inventory data to clients.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> List of player recipients allowed by access rules.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local recips = inv:getRecipients()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onInstanced></a>onInstanced()</summary>
<div class="details-content">
<a id="oninstanced"></a>
<strong>Purpose</strong>
<p>Hook called when an inventory instance is created.</p>

<strong>When Called</strong>
<p>Override to perform custom initialization.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:onInstanced() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onInstanced></a>onInstanced()</summary>
<div class="details-content">
<a id="oninstanced"></a>
<strong>Purpose</strong>
<p>Hook called when an inventory instance is created.</p>

<strong>When Called</strong>
<p>Override to perform custom initialization.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:onInstanced() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onLoaded></a>onLoaded()</summary>
<div class="details-content">
<a id="onloaded"></a>
<strong>Purpose</strong>
<p>Hook called after inventory data is loaded.</p>

<strong>When Called</strong>
<p>Override to react once storage data is retrieved.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:onLoaded() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onLoaded></a>onLoaded()</summary>
<div class="details-content">
<a id="onloaded"></a>
<strong>Purpose</strong>
<p>Hook called after inventory data is loaded.</p>

<strong>When Called</strong>
<p>Override to react once storage data is retrieved.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:onLoaded() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=loadItems></a>loadItems()</summary>
<div class="details-content">
<a id="loaditems"></a>
<strong>Purpose</strong>
<p>Loads item instances from the database into this inventory.</p>

<strong>When Called</strong>
<p>Use during inventory initialization to restore contents.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves with the loaded items table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:loadItems():next(function(items) end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onItemsLoaded></a>onItemsLoaded(items)</summary>
<div class="details-content">
<a id="onitemsloaded"></a>
<strong>Purpose</strong>
<p>Hook called after items are loaded into the inventory.</p>

<strong>When Called</strong>
<p>Override to run logic after contents are ready.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">items</span> Loaded items table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:onItemsLoaded(items) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onItemsLoaded></a>onItemsLoaded(items)</summary>
<div class="details-content">
<a id="onitemsloaded"></a>
<strong>Purpose</strong>
<p>Hook called after items are loaded into the inventory.</p>

<strong>When Called</strong>
<p>Override to run logic after contents are ready.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">items</span> Loaded items table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function Inventory:onItemsLoaded(items) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=instance></a>instance(initialData)</summary>
<div class="details-content">
<a id="instance"></a>
<strong>Purpose</strong>
<p>Creates and registers an inventory instance with initial data.</p>

<strong>When Called</strong>
<p>Use to instantiate a server-side inventory of this type.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> <span class="parameter">initialData</span> Data used during creation (e.g., char assignment).</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves with the new inventory instance.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  Inventory:instance({char = charID})
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=syncData></a>syncData(key, recipients)</summary>
<div class="details-content">
<a id="syncdata"></a>
<strong>Purpose</strong>
<p>Sends a single inventory data key to recipients.</p>

<strong>When Called</strong>
<p>Use after setData to replicate a specific field.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to send.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">recipients</span> <span class="optional">optional</span> Targets to notify; defaults to recipients with access.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:syncData("locked")
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=sync></a>sync(recipients)</summary>
<div class="details-content">
<a id="sync"></a>
<strong>Purpose</strong>
<p>Sends full inventory state and contained items to recipients.</p>

<strong>When Called</strong>
<p>Use when initializing or resyncing an inventory for clients.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">recipients</span> <span class="optional">optional</span> Targets to receive the update; defaults to access list.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:sync(ply)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=delete></a>delete()</summary>
<div class="details-content">
<a id="delete"></a>
<strong>Purpose</strong>
<p>Deletes this inventory via the inventory manager.</p>

<strong>When Called</strong>
<p>Use when permanently removing an inventory record.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:delete()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=destroy></a>destroy()</summary>
<div class="details-content">
<a id="destroy"></a>
<strong>Purpose</strong>
<p>Clears inventory items, removes it from cache, and notifies clients.</p>

<strong>When Called</strong>
<p>Use when unloading or destroying an inventory instance.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:destroy()
</code></pre>
</div>
</details>

---

<details class="realm-client">
<summary><a id=show></a>show(parent)</summary>
<div class="details-content">
<a id="show"></a>
<strong>Purpose</strong>
<p>Opens the inventory UI on the client.</p>

<strong>When Called</strong>
<p>Use to display this inventory to the player.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> <span class="parameter">parent</span> Optional parent panel.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/panel/">Panel</a></span> The created inventory panel.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  inv:show()
</code></pre>
</div>
</details>

---

