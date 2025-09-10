# Data Library

This page documents the functions for working with data serialization, persistence, and storage.

---

## Overview

The data library (`lia.data`) provides a comprehensive system for data serialization, persistence, and storage in the Lilia framework. It handles encoding and decoding of complex data types like vectors, angles, and colors, provides database persistence for entities and configuration data, and manages data storage across different gamemodes and maps.

---

### lia.data.encodetable

**Purpose**

Encodes a table value for serialization, converting special types to serializable formats.

**Parameters**

* `value` (*any*): The value to encode.

**Returns**

* `encodedValue` (*any*): The encoded value ready for serialization.

**Realm**

Shared.

**Example Usage**

```lua
-- Encode a vector
local encoded = lia.data.encodetable(Vector(100, 200, 300))
print(encoded) -- {100, 200, 300}

-- Encode an angle
local encoded = lia.data.encodetable(Angle(0, 90, 0))
print(encoded) -- {0, 90, 0}

-- Encode a color
local encoded = lia.data.encodetable(Color(255, 0, 0, 128))
print(encoded) -- {255, 0, 0, 128}

-- Encode a complex table
local data = {
    position = Vector(100, 200, 300),
    rotation = Angle(0, 90, 0),
    color = Color(255, 0, 0),
    name = "Test"
}
local encoded = lia.data.encodetable(data)
print(encoded.position) -- {100, 200, 300}

-- Encode for database storage
local function encodeForStorage(data)
    return lia.data.encodetable(data)
end

-- Encode multiple values
local function encodeMultiple(values)
    local encoded = {}
    for key, value in pairs(values) do
        encoded[key] = lia.data.encodetable(value)
    end
    return encoded
end
```

---

### lia.data.decode

**Purpose**

Decodes a serialized value back to its original format, handling vectors, angles, and nested tables.

**Parameters**

* `value` (*any*): The value to decode.

**Returns**

* `decodedValue` (*any*): The decoded value in its original format.

**Realm**

Shared.

**Example Usage**

```lua
-- Decode a vector
local decoded = lia.data.decode({100, 200, 300})
print(decoded) -- Vector(100, 200, 300)

-- Decode an angle
local decoded = lia.data.decode({0, 90, 0})
print(decoded) -- Angle(0, 90, 0)

-- Decode a color
local decoded = lia.data.decode({255, 0, 0, 128})
print(decoded) -- Color(255, 0, 0, 128)

-- Decode complex data
local encoded = {
    position = {100, 200, 300},
    rotation = {0, 90, 0},
    color = {255, 0, 0, 128}
}
local decoded = lia.data.decode(encoded)
print(decoded.position) -- Vector(100, 200, 300)

-- Decode from database
local function decodeFromDatabase(data)
    return lia.data.decode(data)
end

-- Decode with error handling
local function decodeSafely(data)
    local success, result = pcall(lia.data.decode, data)
    if success then
        return result
    else
        print("Error decoding data: " .. tostring(result))
        return data
    end
end
```

---

### lia.data.serialize

**Purpose**

Serializes a value to a JSON string for storage or transmission.

**Parameters**

* `value` (*any*): The value to serialize.

**Returns**

* `jsonString` (*string*): The JSON serialized string.

**Realm**

Shared.

**Example Usage**

```lua
-- Serialize a simple value
local serialized = lia.data.serialize("Hello World")
print(serialized) -- "Hello World"

-- Serialize a table
local data = {name = "Test", value = 100}
local serialized = lia.data.serialize(data)
print(serialized) -- {"name":"Test","value":100}

-- Serialize complex data
local data = {
    position = Vector(100, 200, 300),
    rotation = Angle(0, 90, 0),
    color = Color(255, 0, 0)
}
local serialized = lia.data.serialize(data)
print(serialized) -- JSON string

-- Serialize for network transmission
local function serializeForNetwork(data)
    return lia.data.serialize(data)
end

-- Serialize with validation
local function serializeSafely(data)
    if data == nil then
        return "null"
    end
    return lia.data.serialize(data)
end
```

---

### lia.data.deserialize

**Purpose**

Deserializes a JSON string back to its original value.

**Parameters**

* `raw` (*string*): The JSON string to deserialize.

**Returns**

* `value` (*any*): The deserialized value.

**Realm**

Shared.

**Example Usage**

```lua
-- Deserialize a simple value
local deserialized = lia.data.deserialize('"Hello World"')
print(deserialized) -- "Hello World"

-- Deserialize a table
local json = '{"name":"Test","value":100}'
local deserialized = lia.data.deserialize(json)
print(deserialized.name) -- "Test"

-- Deserialize from database
local function deserializeFromDatabase(jsonData)
    return lia.data.deserialize(jsonData)
end

-- Deserialize with error handling
local function deserializeSafely(jsonData)
    if not jsonData or jsonData == "" then
        return nil
    end
    
    local success, result = pcall(lia.data.deserialize, jsonData)
    if success then
        return result
    else
        print("Error deserializing data: " .. tostring(result))
        return nil
    end
end

-- Deserialize multiple values
local function deserializeMultiple(jsonArray)
    local results = {}
    for i, json in ipairs(jsonArray) do
        results[i] = lia.data.deserialize(json)
    end
    return results
end
```

---

### lia.data.decodeVector

**Purpose**

Decodes a raw value specifically as a Vector.

**Parameters**

* `raw` (*any*): The raw value to decode as a vector.

**Returns**

* `vector` (*Vector|any*): The decoded vector or original value if not decodable.

**Realm**

Shared.

**Example Usage**

```lua
-- Decode vector from array
local vector = lia.data.decodeVector({100, 200, 300})
print(vector) -- Vector(100, 200, 300)

-- Decode vector from string
local vector = lia.data.decodeVector("[100 200 300]")
print(vector) -- Vector(100, 200, 300)

-- Decode vector from JSON
local vector = lia.data.decodeVector('{"x":100,"y":200,"z":300}')
print(vector) -- Vector(100, 200, 300)

-- Decode vector with validation
local function decodeVectorSafely(raw)
    local vector = lia.data.decodeVector(raw)
    if isvector(vector) then
        return vector
    else
        print("Failed to decode vector from: " .. tostring(raw))
        return Vector(0, 0, 0)
    end
end

-- Decode multiple vectors
local function decodeMultipleVectors(rawArray)
    local vectors = {}
    for i, raw in ipairs(rawArray) do
        vectors[i] = lia.data.decodeVector(raw)
    end
    return vectors
end
```

---

### lia.data.decodeAngle

**Purpose**

Decodes a raw value specifically as an Angle.

**Parameters**

* `raw` (*any*): The raw value to decode as an angle.

**Returns**

* `angle` (*Angle|any*): The decoded angle or original value if not decodable.

**Realm**

Shared.

**Example Usage**

```lua
-- Decode angle from array
local angle = lia.data.decodeAngle({0, 90, 0})
print(angle) -- Angle(0, 90, 0)

-- Decode angle from string
local angle = lia.data.decodeAngle("{0 90 0}")
print(angle) -- Angle(0, 90, 0)

-- Decode angle from JSON
local angle = lia.data.decodeAngle('{"p":0,"y":90,"r":0}')
print(angle) -- Angle(0, 90, 0)

-- Decode angle with validation
local function decodeAngleSafely(raw)
    local angle = lia.data.decodeAngle(raw)
    if isangle(angle) then
        return angle
    else
        print("Failed to decode angle from: " .. tostring(raw))
        return Angle(0, 0, 0)
    end
end

-- Decode angle for entity
local function decodeEntityAngle(raw)
    local angle = lia.data.decodeAngle(raw)
    if isangle(angle) then
        return angle
    end
    return Angle(0, 0, 0)
end
```

---

### lia.data.set

**Purpose**

Sets a data value and saves it to the database with gamemode and map context.

**Parameters**

* `key` (*string*): The data key to set.
* `value` (*any*): The value to store.
* `global` (*boolean*): Whether to store globally (not gamemode/map specific).
* `ignoreMap` (*boolean*): Whether to ignore map context.

**Returns**

* `path` (*string*): The storage path for the data.

**Realm**

Shared.

**Example Usage**

```lua
-- Set a simple data value
lia.data.set("serverName", "My Server")

-- Set a complex data value
local data = {
    position = Vector(100, 200, 300),
    rotation = Angle(0, 90, 0),
    name = "Test Entity"
}
lia.data.set("entityData", data)

-- Set global data (not gamemode/map specific)
lia.data.set("globalSetting", "value", true)

-- Set data for current map only
lia.data.set("mapSpecificData", "value", false, true)

-- Set data with callback
lia.data.set("importantData", "value")
hook.Add("OnDataSet", "HandleDataChange", function(key, value, gamemode, map)
    print("Data changed: " .. key .. " = " .. tostring(value))
end)

-- Set multiple data values
local function setMultipleData(dataTable)
    for key, value in pairs(dataTable) do
        lia.data.set(key, value)
    end
end

-- Set data with validation
local function setDataSafely(key, value)
    if key and key ~= "" then
        lia.data.set(key, value)
        return true
    end
    return false
end
```

---

### lia.data.delete

**Purpose**

Deletes a data value from storage.

**Parameters**

* `key` (*string*): The data key to delete.
* `global` (*boolean*): Whether to delete from global storage.
* `ignoreMap` (*boolean*): Whether to ignore map context.

**Returns**

* `success` (*boolean*): True if deletion was successful.

**Realm**

Shared.

**Example Usage**

```lua
-- Delete a data value
lia.data.delete("serverName")

-- Delete global data
lia.data.delete("globalSetting", true)

-- Delete map-specific data
lia.data.delete("mapData", false, true)

-- Delete data with confirmation
local function deleteDataWithConfirmation(key)
    if lia.data.get(key) then
        lia.data.delete(key)
        print("Deleted data: " .. key)
        return true
    else
        print("Data not found: " .. key)
        return false
    end
end

-- Delete multiple data values
local function deleteMultipleData(keys)
    for _, key in ipairs(keys) do
        lia.data.delete(key)
    end
end

-- Delete data by pattern
local function deleteDataByPattern(pattern)
    for key, _ in pairs(lia.data.stored) do
        if string.match(key, pattern) then
            lia.data.delete(key)
        end
    end
end
```

---

### lia.data.get

**Purpose**

Gets a data value from storage.

**Parameters**

* `key` (*string*): The data key to retrieve.
* `default` (*any*): Optional default value if key not found.

**Returns**

* `value` (*any*): The stored value or default.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a data value
local serverName = lia.data.get("serverName")
print("Server name: " .. tostring(serverName))

-- Get data with default
local value = lia.data.get("nonexistent", "defaultValue")

-- Get complex data
local entityData = lia.data.get("entityData")
if entityData then
    print("Position: " .. tostring(entityData.position))
end

-- Get all data
local function getAllData()
    return lia.data.stored
end

-- Get data with validation
local function getDataSafely(key, default)
    local value = lia.data.get(key, default)
    if value == nil then
        print("Data not found: " .. key)
        return default
    end
    return value
end

-- Get data by type
local function getDataByType(typeFilter)
    local filtered = {}
    for key, value in pairs(lia.data.stored) do
        if type(value) == typeFilter then
            filtered[key] = value
        end
    end
    return filtered
end
```

---

### lia.data.loadTables

**Purpose**

Loads data from the database for the current gamemode and map.

**Returns**

* None.

**Realm**

Shared.

**Example Usage**

```lua
-- Load data on server start
hook.Add("Initialize", "LoadData", function()
    lia.data.loadTables()
end)

-- Load data with callback
lia.data.loadTables()
hook.Add("OnDataLoaded", "HandleDataLoaded", function()
    print("Data loaded successfully")
end)

-- Load data in module
local function loadModuleData()
    lia.data.loadTables()
    print("Module data loaded")
end

-- Load data with error handling
local function loadDataSafely()
    local success, err = pcall(lia.data.loadTables)
    if not success then
        print("Error loading data: " .. tostring(err))
    end
end
```

---

### lia.data.savePersistence

**Purpose**

Saves entity persistence data to the database (server-side only).

**Parameters**

* `entities` (*table*): Table of entities to save.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Save persistence data
local entities = {
    {
        class = "prop_physics",
        pos = Vector(100, 200, 300),
        angles = Angle(0, 90, 0),
        model = "models/props_c17/chair01a.mdl"
    }
}
lia.data.savePersistence(entities)

-- Save all persistent entities
local function saveAllPersistentEntities()
    local entities = {}
    for _, ent in ipairs(ents.GetAll()) do
        if ent:GetPersistent() then
            table.insert(entities, {
                class = ent:GetClass(),
                pos = ent:GetPos(),
                angles = ent:GetAngles(),
                model = ent:GetModel()
            })
        end
    end
    lia.data.savePersistence(entities)
end

-- Save persistence with validation
local function savePersistenceSafely(entities)
    if not entities or #entities == 0 then
        print("No entities to save")
        return
    end
    
    lia.data.savePersistence(entities)
    print("Saved " .. #entities .. " entities")
end
```

---

### lia.data.loadPersistenceData

**Purpose**

Loads entity persistence data from the database (server-side only).

**Parameters**

* `callback` (*function*): Optional callback function when data is loaded.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Load persistence data
lia.data.loadPersistenceData(function(entities)
    print("Loaded " .. #entities .. " persistent entities")
end)

-- Load persistence data with entity recreation
lia.data.loadPersistenceData(function(entities)
    for _, data in ipairs(entities) do
        local ent = ents.Create(data.class)
        if IsValid(ent) then
            ent:SetPos(data.pos)
            ent:SetAngles(data.angles)
            ent:SetModel(data.model)
            ent:Spawn()
            ent:Activate()
        end
    end
end)

-- Load persistence data with error handling
local function loadPersistenceSafely()
    lia.data.loadPersistenceData(function(entities)
        if entities then
            print("Successfully loaded " .. #entities .. " entities")
        else
            print("Failed to load persistence data")
        end
    end)
end
```

---

### lia.data.getPersistence

**Purpose**

Gets the current persistence cache data.

**Returns**

* `entities` (*table*): Table of cached persistence entities.

**Realm**

Shared.

**Example Usage**

```lua
-- Get persistence cache
local entities = lia.data.getPersistence()
print("Cached entities: " .. #entities)

-- Check if entity exists in cache
local function isEntityCached(class, pos)
    local entities = lia.data.getPersistence()
    for _, ent in ipairs(entities) do
        if ent.class == class and ent.pos == pos then
            return true
        end
    end
    return false
end

-- Get entities by class
local function getEntitiesByClass(class)
    local entities = lia.data.getPersistence()
    local filtered = {}
    for _, ent in ipairs(entities) do
        if ent.class == class then
            table.insert(filtered, ent)
        end
    end
    return filtered
end

-- Get persistence cache info
local function getPersistenceInfo()
    local entities = lia.data.getPersistence()
    local info = {
        count = #entities,
        classes = {}
    }
    
    for _, ent in ipairs(entities) do
        info.classes[ent.class] = (info.classes[ent.class] or 0) + 1
    end
    
    return info
end
```
