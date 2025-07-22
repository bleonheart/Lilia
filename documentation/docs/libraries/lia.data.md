# Data Library

This page describes persistent data storage helpers.

---

## Overview

The data library keeps persistent values inside a single `lia_data` database table. Each row is keyed by the current gamemode folder and map using the `_folder` and `_map` columns. All saved key/value pairs are stored together inside the `_data` column as JSON. Values are cached in memory inside `lia.data.stored` for quick access.

---

### lia.data.set

**Purpose**

Saves the provided value under the specified key in the single `lia_data` table and caches it in `lia.data.stored`.

**Parameters**

* `key` (*string*): Key under which the data is stored.

* `value` (*any*): Value to store.

* `global` (*boolean*): Store without gamemode or map restrictions.

* `ignoreMap` (*boolean*): Omit the map name from the stored entry.

**Realm**

`Server`

**Returns**

* *string*: The path where the data was saved.

**Example Usage**

```lua
concommand.Add("save_spawn", function(ply)
    if ply:IsAdmin() then
        lia.data.set("spawn_pos", ply:GetPos(), true)
    end
end)
```

---

### lia.data.delete

**Purpose**

Removes the stored value corresponding to the key from the `lia_data` table and clears the cached entry in `lia.data.stored`.

**Parameters**

* `key` (*string*): Key corresponding to the data to delete.

* `global` (*boolean*): Store without gamemode or map restrictions.

* `ignoreMap` (*boolean*): Omit the map name from the stored entry.

**Realm**

`Server`

**Returns**

* *boolean*: Always `true`; the deletion query is queued.

**Example Usage**

```lua
lia.data.delete("spawn_pos")
```

---

### lia.data.get

**Purpose**

Retrieves the stored value for the specified key from the cache.

**Parameters**

* `key` (*string*): Key corresponding to the data.

* `default` (*any*): Default value to return if no data is found.

**Realm**

`Shared`

**Returns**

* *any*: The stored value or the default if not found.

**Example Usage**

```lua
hook.Add("PlayerSpawn", "UseSavedSpawn", function(ply)
    local pos = lia.data.get("spawn_pos", vector_origin)
    if pos then
        ply:SetPos(pos)
    end
end)
```

---

### lia.data.loadTables

**Purpose**

Loads the appropriate entry from the `lia_data` table into `lia.data.stored`.

**Parameters**

*None*

**Realm**

`Server`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
lia.data.loadTables()

```

---
