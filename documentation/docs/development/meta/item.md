# Item

Item management system for the Lilia framework.

---

<strong>Overview</strong>

The item meta table provides comprehensive functionality for managing item data, properties, and operations in the Lilia framework. It handles item creation, data persistence, inventory management, stacking, rotation, and item-specific operations. The meta table operates on both server and client sides, with the server managing item storage and validation while the client provides item data access and display. It includes integration with the inventory system for item storage, database system for item persistence, and rendering system for item display. The meta table ensures proper item data synchronization, quantity management, rotation handling, and comprehensive item lifecycle management from creation to destruction.

---

<details class="realm-shared">
<summary><a id=isRotated></a>isRotated()</summary>
<div class="details-content">
<a id="isrotated"></a>
<strong>Purpose</strong>
<p>Reports whether the item is stored in a rotated state.</p>

<strong>When Called</strong>
<p>Use when calculating grid dimensions or rendering the item icon.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the item is rotated.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  if item:isRotated() then swapDims() end
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getWidth></a>getWidth()</summary>
<div class="details-content">
<a id="getwidth"></a>
<strong>Purpose</strong>
<p>Returns the item's width considering rotation and defaults.</p>

<strong>When Called</strong>
<p>Use when placing the item into a grid inventory.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Width in grid cells.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local w = item:getWidth()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getHeight></a>getHeight()</summary>
<div class="details-content">
<a id="getheight"></a>
<strong>Purpose</strong>
<p>Returns the item's height considering rotation and defaults.</p>

<strong>When Called</strong>
<p>Use when calculating how much vertical space an item needs.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Height in grid cells.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local h = item:getHeight()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getQuantity></a>getQuantity()</summary>
<div class="details-content">
<a id="getquantity"></a>
<strong>Purpose</strong>
<p>Returns the current stack quantity for this item.</p>

<strong>When Called</strong>
<p>Use when showing stack counts or validating transfers.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Quantity within the stack.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local count = item:getQuantity()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=tostring></a>tostring()</summary>
<div class="details-content">
<a id="tostring"></a>
<strong>Purpose</strong>
<p>Builds a readable string identifier for the item.</p>

<strong>When Called</strong>
<p>Use for logging, debugging, or console output.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Formatted identifier including uniqueID and item id.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  print(item:tostring())
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getID></a>getID()</summary>
<div class="details-content">
<a id="getid"></a>
<strong>Purpose</strong>
<p>Retrieves the numeric identifier for this item instance.</p>

<strong>When Called</strong>
<p>Use when persisting, networking, or comparing items.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Unique item ID.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local id = item:getID()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getModel></a>getModel()</summary>
<div class="details-content">
<a id="getmodel"></a>
<strong>Purpose</strong>
<p>Returns the model path assigned to this item.</p>

<strong>When Called</strong>
<p>Use when spawning an entity or rendering the item icon.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Model file path.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local mdl = item:getModel()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getSkin></a>getSkin()</summary>
<div class="details-content">
<a id="getskin"></a>
<strong>Purpose</strong>
<p>Returns the skin index assigned to this item.</p>

<strong>When Called</strong>
<p>Use when spawning the entity or applying cosmetics.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number|nil</a></span> Skin index or nil when not set.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local skin = item:getSkin()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getBodygroups></a>getBodygroups()</summary>
<div class="details-content">
<a id="getbodygroups"></a>
<strong>Purpose</strong>
<p>Provides the bodygroup configuration for the item model.</p>

<strong>When Called</strong>
<p>Use when spawning or rendering to ensure correct bodygroups.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Key-value pairs of bodygroup indexes to values.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local groups = item:getBodygroups()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getPrice></a>getPrice()</summary>
<div class="details-content">
<a id="getprice"></a>
<strong>Purpose</strong>
<p>Calculates the current sale price for the item.</p>

<strong>When Called</strong>
<p>Use when selling, buying, or displaying item cost.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> Price value, possibly adjusted by calcPrice.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local cost = item:getPrice()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=call></a>call(method, client, entity)</summary>
<div class="details-content">
<a id="call"></a>
<strong>Purpose</strong>
<p>Invokes an item method while temporarily setting context.</p>

<strong>When Called</strong>
<p>Use when you need to call an item function with player/entity context.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">method</span> Name of the item method to invoke.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> <span class="optional">optional</span> Player to treat as the caller.</p>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> <span class="optional">optional</span> Entity representing the item.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Return values from the invoked method.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:call("onUse", ply, ent)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getOwner></a>getOwner()</summary>
<div class="details-content">
<a id="getowner"></a>
<strong>Purpose</strong>
<p>Attempts to find the player that currently owns this item.</p>

<strong>When Called</strong>
<p>Use when routing notifications or networking to the item owner.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|nil</a></span> Owning player if found.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local owner = item:getOwner()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getData></a>getData(key, default)</summary>
<div class="details-content">
<a id="getdata"></a>
<strong>Purpose</strong>
<p>Reads a stored data value from the item or its entity.</p>

<strong>When Called</strong>
<p>Use for custom item metadata such as durability or rotation.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to read.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">default</span> Value to return when the key is missing.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> Stored value or default.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local durability = item:getData("durability", 100)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getAllData></a>getAllData()</summary>
<div class="details-content">
<a id="getalldata"></a>
<strong>Purpose</strong>
<p>Returns a merged table of all item data, including entity netvars.</p>

<strong>When Called</strong>
<p>Use when syncing the entire data payload to clients.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.5">table</a></span> Combined data table.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local data = item:getAllData()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=hook></a>hook(name, func)</summary>
<div class="details-content">
<a id="hook"></a>
<strong>Purpose</strong>
<p>Registers a pre-run hook for an item interaction.</p>

<strong>When Called</strong>
<p>Use when adding custom behavior before an action executes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Hook name to bind.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">func</span> Callback to execute.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:hook("use", function(itm) end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=postHook></a>postHook(name, func)</summary>
<div class="details-content">
<a id="posthook"></a>
<strong>Purpose</strong>
<p>Registers a post-run hook for an item interaction.</p>

<strong>When Called</strong>
<p>Use when you need to react after an action completes.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">name</span> Hook name to bind.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.6">function</a></span> <span class="parameter">func</span> Callback to execute with results.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:postHook("use", function(itm, result) end)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=onRegistered></a>onRegistered()</summary>
<div class="details-content">
<a id="onregistered"></a>
<strong>Purpose</strong>
<p>Performs setup tasks after an item definition is registered.</p>

<strong>When Called</strong>
<p>Automatically invoked once the item type is loaded.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:onRegistered()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=print></a>print(detail)</summary>
<div class="details-content">
<a id="print"></a>
<strong>Purpose</strong>
<p>Prints a concise or detailed identifier for the item.</p>

<strong>When Called</strong>
<p>Use during debugging or admin commands.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">detail</span> Include owner and grid info when true.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:print(true)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=printData></a>printData()</summary>
<div class="details-content">
<a id="printdata"></a>
<strong>Purpose</strong>
<p>Outputs item metadata and all stored data fields.</p>

<strong>When Called</strong>
<p>Use for diagnostics to inspect an item's state.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:printData()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getName></a>getName()</summary>
<div class="details-content">
<a id="getname"></a>
<strong>Purpose</strong>
<p>Returns the display name of the item.</p>

<strong>When Called</strong>
<p>Use for UI labels, tooltips, and logs.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Item name.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local name = item:getName()
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getDesc></a>getDesc()</summary>
<div class="details-content">
<a id="getdesc"></a>
<strong>Purpose</strong>
<p>Returns the description text for the item.</p>

<strong>When Called</strong>
<p>Use in tooltips or inventory details.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Item description.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local desc = item:getDesc()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=removeFromInventory></a>removeFromInventory(preserveItem)</summary>
<div class="details-content">
<a id="removefrominventory"></a>
<strong>Purpose</strong>
<p>Removes the item from its current inventory instance.</p>

<strong>When Called</strong>
<p>Use when dropping, deleting, or transferring the item out.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">preserveItem</span> When true, keeps the instance for later use.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Deferred resolution for removal completion.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:removeFromInventory():next(function() end)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=delete></a>delete()</summary>
<div class="details-content">
<a id="delete"></a>
<strong>Purpose</strong>
<p>Deletes the item record from storage after destroying it in-game.</p>

<strong>When Called</strong>
<p>Use when an item should be permanently removed.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves after the database delete and callbacks run.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:delete()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=remove></a>remove()</summary>
<div class="details-content">
<a id="remove"></a>
<strong>Purpose</strong>
<p>Removes the world entity, inventory reference, and database entry.</p>

<strong>When Called</strong>
<p>Use when the item is consumed or otherwise removed entirely.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">Promise</a></span> Resolves once removal and deletion complete.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:remove()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=destroy></a>destroy()</summary>
<div class="details-content">
<a id="destroy"></a>
<strong>Purpose</strong>
<p>Broadcasts item deletion to clients and frees the instance.</p>

<strong>When Called</strong>
<p>Use internally before removing an item from memory.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:destroy()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onDisposed></a>onDisposed()</summary>
<div class="details-content">
<a id="ondisposed"></a>
<strong>Purpose</strong>
<p>Hook called after an item is destroyed; intended for overrides.</p>

<strong>When Called</strong>
<p>Automatically triggered when the item instance is disposed.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onDisposed() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onDisposed></a>onDisposed()</summary>
<div class="details-content">
<a id="ondisposed"></a>
<strong>Purpose</strong>
<p>Hook called after an item is destroyed; intended for overrides.</p>

<strong>When Called</strong>
<p>Automatically triggered when the item instance is disposed.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onDisposed() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=getEntity></a>getEntity()</summary>
<div class="details-content">
<a id="getentity"></a>
<strong>Purpose</strong>
<p>Finds the world entity representing this item instance.</p>

<strong>When Called</strong>
<p>Use when needing the spawned entity from the item data.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity|nil</a></span> Spawned item entity if present.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ent = item:getEntity()
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=spawn></a>spawn(position, angles)</summary>
<div class="details-content">
<a id="spawn"></a>
<strong>Purpose</strong>
<p>Spawns a world entity for this item at the given position and angle.</p>

<strong>When Called</strong>
<p>Use when dropping an item into the world.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Vector">Vector|table|Entity</a></span> <span class="parameter">position</span> Where to spawn, or the player dropping the item.</p>
<p><span class="types"><a class="type" href="https://wiki.facepunch.com/gmod/Angle">Angle|Vector|table</a></span> <span class="parameter">angles</span> <span class="optional">optional</span> Orientation for the spawned entity.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity|nil</a></span> Spawned entity on success.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local ent = item:spawn(ply, Angle(0, 0, 0))
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=transfer></a>transfer(newInventory, bBypass)</summary>
<div class="details-content">
<a id="transfer"></a>
<strong>Purpose</strong>
<p>Moves the item into another inventory if access rules allow.</p>

<strong>When Called</strong>
<p>Use when transferring items between containers or players.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/libraries/lia.inventory/">Inventory</a></span> <span class="parameter">newInventory</span> Destination inventory.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">bBypass</span> Skip access checks when true.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the transfer was initiated.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:transfer(otherInv)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onInstanced></a>onInstanced()</summary>
<div class="details-content">
<a id="oninstanced"></a>
<strong>Purpose</strong>
<p>Hook called when a new item instance is created.</p>

<strong>When Called</strong>
<p>Automatically invoked after instancing; override to customize.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onInstanced() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onInstanced></a>onInstanced()</summary>
<div class="details-content">
<a id="oninstanced"></a>
<strong>Purpose</strong>
<p>Hook called when a new item instance is created.</p>

<strong>When Called</strong>
<p>Automatically invoked after instancing; override to customize.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onInstanced() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onSync></a>onSync(recipient)</summary>
<div class="details-content">
<a id="onsync"></a>
<strong>Purpose</strong>
<p>Hook called after the item data is synchronized to clients.</p>

<strong>When Called</strong>
<p>Triggered by sync calls; override for custom behavior.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">recipient</span> <span class="optional">optional</span> The player who received the sync, or nil for broadcast.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onSync(ply) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onSync></a>onSync(recipient)</summary>
<div class="details-content">
<a id="onsync"></a>
<strong>Purpose</strong>
<p>Hook called after the item data is synchronized to clients.</p>

<strong>When Called</strong>
<p>Triggered by sync calls; override for custom behavior.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">recipient</span> <span class="optional">optional</span> The player who received the sync, or nil for broadcast.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onSync(ply) end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onRemoved></a>onRemoved()</summary>
<div class="details-content">
<a id="onremoved"></a>
<strong>Purpose</strong>
<p>Hook called after the item has been removed from the world/inventory.</p>

<strong>When Called</strong>
<p>Automatically invoked once deletion finishes.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onRemoved() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onRemoved></a>onRemoved()</summary>
<div class="details-content">
<a id="onremoved"></a>
<strong>Purpose</strong>
<p>Hook called after the item has been removed from the world/inventory.</p>

<strong>When Called</strong>
<p>Automatically invoked once deletion finishes.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onRemoved() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onRestored></a>onRestored()</summary>
<div class="details-content">
<a id="onrestored"></a>
<strong>Purpose</strong>
<p>Hook called after an item is restored from persistence.</p>

<strong>When Called</strong>
<p>Automatically invoked after loading an item from the database.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onRestored() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=onRestored></a>onRestored()</summary>
<div class="details-content">
<a id="onrestored"></a>
<strong>Purpose</strong>
<p>Hook called after an item is restored from persistence.</p>

<strong>When Called</strong>
<p>Automatically invoked after loading an item from the database.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  function ITEM:onRestored() end
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=sync></a>sync(recipient)</summary>
<div class="details-content">
<a id="sync"></a>
<strong>Purpose</strong>
<p>Sends this item instance to a recipient or all clients for syncing.</p>

<strong>When Called</strong>
<p>Use after creating or updating an item instance.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">recipient</span> <span class="optional">optional</span> Specific player to sync; broadcasts when nil.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:sync(ply)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setData></a>setData(key, value, receivers, noSave, noCheckEntity)</summary>
<div class="details-content">
<a id="setdata"></a>
<strong>Purpose</strong>
<p>Sets a custom data value on the item, networking and saving as needed.</p>

<strong>When Called</strong>
<p>Use when updating item metadata that clients or persistence require.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">key</span> Data key to set.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">value</span> Value to store.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">receivers</span> <span class="optional">optional</span> Targets to send the update to; defaults to owner.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noSave</span> Skip database write when true.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noCheckEntity</span> Skip updating the world entity netvar when true.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:setData("durability", 80, item:getOwner())
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=addQuantity></a>addQuantity(quantity, receivers, noCheckEntity)</summary>
<div class="details-content">
<a id="addquantity"></a>
<strong>Purpose</strong>
<p>Increases the item quantity by the given amount.</p>

<strong>When Called</strong>
<p>Use for stacking items or consuming partial quantities.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">quantity</span> Amount to add (can be negative).</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">receivers</span> <span class="optional">optional</span> Targets to notify; defaults to owner.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noCheckEntity</span> Skip updating the entity netvar when true.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:addQuantity(-1, ply)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=setQuantity></a>setQuantity(quantity, receivers, noCheckEntity)</summary>
<div class="details-content">
<a id="setquantity"></a>
<strong>Purpose</strong>
<p>Sets the item quantity, updating entities, clients, and storage.</p>

<strong>When Called</strong>
<p>Use after splitting stacks or consuming items.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.3">number</a></span> <span class="parameter">quantity</span> New stack amount.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player|table</a></span> <span class="parameter">receivers</span> <span class="optional">optional</span> Targets to notify; defaults to owner.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> <span class="parameter">noCheckEntity</span> Skip updating the world entity netvar when true.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:setQuantity(5, ply)
</code></pre>
</div>
</details>

---

<details class="realm-server">
<summary><a id=interact></a>interact(action, client, entity, data)</summary>
<div class="details-content">
<a id="interact"></a>
<strong>Purpose</strong>
<p>Handles an item interaction action, running hooks and callbacks.</p>

<strong>When Called</strong>
<p>Use when a player selects an action from an item's context menu.</p>

 <strong>Parameters</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> <span class="parameter">action</span> Action identifier from the item's functions table.</p>
<p><span class="types"><a class="type" href="/development/meta/player/">Player</a></span> <span class="parameter">client</span> Player performing the action.</p>
<p><span class="types"><a class="type" href="/development/meta/entity/">Entity</a></span> <span class="parameter">entity</span> <span class="optional">optional</span> World entity representing the item, if any.</p>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#2.2">any</a></span> <span class="parameter">data</span> Additional data for multi-option actions.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.2">boolean</a></span> True if the action was processed; false otherwise.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  item:interact("use", ply, ent)
</code></pre>
</div>
</details>

---

<details class="realm-shared">
<summary><a id=getCategory></a>getCategory()</summary>
<div class="details-content">
<a id="getcategory"></a>
<strong>Purpose</strong>
<p>Returns the item's localized category label.</p>

<strong>When Called</strong>
<p>Use when grouping or displaying items by category.</p>

<strong>Returns</strong>
<p><span class="types"><a class="type" href="https://www.lua.org/manual/5.1/manual.html#5.4">string</a></span> Localized category name, or "misc" if undefined.</p>

<strong>Example Usage</strong>
<pre><code class="language-lua">  local category = item:getCategory()
</code></pre>
</div>
</details>

---

