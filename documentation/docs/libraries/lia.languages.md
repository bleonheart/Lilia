# Languages Library

This page explains how translations and phrases are loaded.

---

## Overview

The languages library loads localisation files from directories, resolves phrase keys to translated text, and supports runtime language switching. Language files live in `languages/<langname>.lua` inside schemas or modules; each file defines a `LANGUAGE` table of phrases. Loaded phrases are cached in `lia.lang.stored`, while display names defined through a global `NAME` variable are kept in `lia.lang.names`. During start-up the framework automatically loads its bundled translations from `lilia/gamemode/languages` and then fires the `OnLocalizationLoaded` hook.

---

### lia.lang.loadFromDir

**Purpose**

Loads every Lua language file in a directory and merges their `LANGUAGE` tables into the cache. Keys and values are coerced to strings and an optional global `NAME` is stored in `lia.lang.names`.

**Parameters**

* `directory` (*string*): Path to the folder containing language files.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- Load language files bundled with the current schema
lia.lang.loadFromDir(SCHEMA.folder .. "/languages")
```

---

### lia.lang.AddTable

**Purpose**

Adds or merges key-value pairs into an existing language table. Keys and values are converted to strings and existing entries are overwritten.

**Parameters**

* `name` (*string*): Language identifier to update.

* `tbl` (*table*): Key-value pairs to insert or override.

**Realm**

`Shared`

**Returns**

* *nil*: This function does not return a value.

**Example Usage**

```lua
-- Add or override phrases for English
lia.lang.AddTable("english", {
    greeting = "Hello",
    farewell = "Goodbye"
})
```

---

### lia.lang.getLanguages

**Purpose**

Returns a sorted list of the identifiers for all loaded languages with their first letter capitalised.

**Parameters**

*None*

**Realm**

`Shared`

**Returns**

* `table`: Alphabetically sorted language names.

**Example Usage**

```lua
for _, lang in ipairs(lia.lang.getLanguages()) do
    print(lang)
end
```

---

### L

**Purpose**

Returns the translated phrase for a key in the active language, using `string.format` with any additional arguments. Missing translations return the key itself. If fewer arguments are supplied than `%s` placeholders, the extras default to empty strings. The active language defaults to `"english"` when not configured.

**Parameters**

* `key` (*string*): Localisation key.

* …: Values interpolated via `string.format`.

**Realm**

`Shared`

**Returns**

* `string`: Translated phrase, or the key itself if no translation exists.

**Example Usage**

```lua
print(L("vendorShowAll"))
```

---
