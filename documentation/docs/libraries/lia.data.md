# Data Library

This page documents the functions for working with data serialization, persistence, and storage.

---

## Overview

The data library (`lia.data`) provides comprehensive data management for the Lilia framework. It handles data serialization, deserialization, persistence, and storage with support for various data types including vectors, angles, colors, and complex tables. The library includes automatic encoding/decoding of GLua-specific types and provides persistence functionality for entities and game state.

---

### lia.data.encodetable

**Purpose**

Encodes a table or value for safe serialization, handling GLua-specific types.

**Parameters**

* `value` (*any*): The value to encode.

**Returns**

* `encoded` (*any*): The encoded value safe for serialization.

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
    name = "test"
}
local encoded = lia.data.encodetable(data)
print(encoded.position) -- {100, 200, 300}

-- Encode for database storage
local function savePlayerData(ply)
    local data = {
        pos = ply:GetPos(),
        ang = ply:GetAngles(),
        health = ply:Health()
    }
    local encoded = lia.data.encodetable(data)
    -- Save encoded data to database
end
```

---

### lia.data.decode

**Purpose**

Decodes a serialized value back to its original GLua types.

**Parameters**

* `value` (*any*): The value to decode.

**Returns**

* `decoded` (*any*): The decoded value with proper GLua types.

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
local function loadPlayerData(ply, rawData)
    local decoded = lia.data.decode(rawData)
    if decoded.pos then
        ply:SetPos(decoded.pos)
    end
    if decoded.ang then
        ply:SetAngles(decoded.ang)
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

* `serialized` (*string*): The JSON serialized string.

**Realm**

Shared.

**Example Usage**

```lua
-- Serialize a simple value
local serialized = lia.data.serialize("hello world")
print(serialized) -- "hello world"

-- Serialize a table
local data = {
    name = "test",
    value = 123,
    position = Vector(100, 200, 300)
}
local serialized = lia.data.serialize(data)
print(serialized) -- JSON string

-- Serialize for network transmission
local function sendDataToClient(ply, data)
    local serialized = lia.data.serialize(data)
    net.Start("DataUpdate")
    net.WriteString(serialized)
    net.Send(ply)
end

-- Serialize for database storage
local function saveToDatabase(key, data)
    local serialized = lia.data.serialize(data)
    lia.db.setData(key, serialized)
end
```

---

### lia.data.deserialize

**Purpose**

Deserializes a JSON string back to its original value.

**Parameters**

* `raw` (*string*): The JSON string to deserialize.

**Returns**

* `deserialized` (*any*): The deserialized value.

**Realm**

Shared.

**Example Usage**

```lua
-- Deserialize a JSON string
local deserialized = lia.data.deserialize('{"name":"test","value":123}')
print(deserialized.name) -- "test"

-- Deserialize with validation
local function safeDeserialize(raw)
    if not raw or raw == "" then
        return nil
    end
    
    local deserialized = lia.data.deserialize(raw)
    if deserialized then
        return deserialized
    else
        print("Failed to deserialize data")
        return nil
    end
end

-- Deserialize from network
net.Receive("DataUpdate", function()
    local raw = net.ReadString()
    local data = lia.data.deserialize(raw)
    if data then
        print("Received data: " .. tostring(data))
    end
end)

-- Deserialize from database
local function loadFromDatabase(key)
    local raw = lia.db.getData(key)
    if raw then
        return lia.data.deserialize(raw)
    end
    return nil
end
```

---

### lia.data.decodeVector

**Purpose**

Decodes a raw value specifically to a Vector.

**Parameters**

* `raw` (*any*): The raw value to decode.

**Returns**

* `vector` (*Vector|any*): The decoded Vector or original value if not decodable.

**Realm**

Shared.

**Example Usage**

```lua
-- Decode vector from table
local vector = lia.data.decodeVector({100, 200, 300})
print(vector) -- Vector(100, 200, 300)

-- Decode vector from string
local vector = lia.data.decodeVector("[100 200 300]")
print(vector) -- Vector(100, 200, 300)

-- Decode vector with validation
local function safeDecodeVector(raw)
    local vector = lia.data.decodeVector(raw)
    if isvector(vector) then
        return vector
    else
        print("Failed to decode vector")
        return Vector(0, 0, 0)
    end
end

-- Decode vector from database
local function loadPlayerPosition(ply)
    local raw = lia.db.getData("player_" .. ply:SteamID() .. "_pos")
    if raw then
        local pos = lia.data.decodeVector(raw)
        if isvector(pos) then
            ply:SetPos(pos)
        end
    end
end
```

---

### lia.data.decodeAngle

**Purpose**

Decodes a raw value specifically to an Angle.

**Parameters**

* `raw` (*any*): The raw value to decode.

**Returns**

* `angle` (*Angle|any*): The decoded Angle or original value if not decodable.

**Realm**

Shared.

**Example Usage**

```lua
-- Decode angle from table
local angle = lia.data.decodeAngle({0, 90, 0})
print(angle) -- Angle(0, 90, 0)

-- Decode angle from string
local angle = lia.data.decodeAngle("{0 90 0}")
print(angle) -- Angle(0, 90, 0)

-- Decode angle with validation
local function safeDecodeAngle(raw)
    local angle = lia.data.decodeAngle(raw)
    if isangle(angle) then
        return angle
    else
        print("Failed to decode angle")
        return Angle(0, 0, 0)
    end
end

-- Decode angle from database
local function loadPlayerAngles(ply)
    local raw = lia.db.getData("player_" .. ply:SteamID() .. "_ang")
    if raw then
        local ang = lia.data.decodeAngle(raw)
        if isangle(ang) then
            ply:SetAngles(ang)
        end
    end
end
```

---

### lia.data.set

**Purpose**

Sets a data value with automatic serialization and database storage.

**Parameters**

* `key` (*string*): The key to store the data under.
* `value` (*any*): The value to store.
* `global` (*boolean*): Whether to store globally (not gamemode/map specific).
* `ignoreMap` (*boolean*): Whether to ignore map-specific storage.

**Returns**

* `path` (*string*): The storage path used.

**Realm**

Shared.

**Example Usage**

```lua
-- Set a simple value
lia.data.set("serverName", "My Server")

-- Set a complex value
local playerData = {
    pos = Vector(100, 200, 300),
    ang = Angle(0, 90, 0),
    health = 100
}
lia.data.set("playerData", playerData)

-- Set global data
lia.data.set("globalSetting", "value", true)

-- Set with callback
lia.data.set("importantData", "value"):next(function()
    print("Data saved successfully")
end)

-- Set in command
lia.command.add("setdata", {
    arguments = {
        {name = "key", type = "string"},
        {name = "value", type = "string"}
    },
    onRun = function(client, arguments)
        local key = arguments[1]
        local value = arguments[2]
        lia.data.set(key, value)
        client:ChatPrint("Data set: " .. key .. " = " .. value)
    end
})
```

---

### lia.data.delete

**Purpose**

Deletes a data value from storage.

**Parameters**

* `key` (*string*): The key to delete.
* `global` (*boolean*): Whether to delete from global storage.
* `ignoreMap` (*boolean*): Whether to ignore map-specific deletion.

**Returns**

* `success` (*boolean*): True if deletion was successful.

**Realm**

Shared.

**Example Usage**

```lua
-- Delete a value
lia.data.delete("oldData")

-- Delete global data
lia.data.delete("globalData", true)

-- Delete with validation
local function safeDelete(key)
    if key and key ~= "" then
        return lia.data.delete(key)
    else
        print("Invalid key for deletion")
        return false
    end
end

-- Delete in command
lia.command.add("deletedata", {
    arguments = {
        {name = "key", type = "string"}
    },
    onRun = function(client, arguments)
        local key = arguments[1]
        local success = lia.data.delete(key)
        if success then
            client:ChatPrint("Data deleted: " .. key)
        else
            client:ChatPrint("Failed to delete: " .. key)
        end
    end
})
```

---

### lia.data.loadTables

**Purpose**

Loads data tables from the database in order of specificity.

**Parameters**

*None*

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Load data tables
lia.data.loadTables()

-- Load with callback
lia.data.loadTables():next(function()
    print("Data tables loaded successfully")
end)

-- Load in initialization
hook.Add("Initialize", "LoadData", function()
    lia.data.loadTables()
end)
```

---

### lia.data.loadPersistence

**Purpose**

Loads persistence data and ensures required database columns exist.

**Parameters**

*None*

**Returns**

* `promise` (*Promise*): Promise that resolves when persistence is loaded.

**Realm**

Shared.

**Example Usage**

```lua
-- Load persistence
lia.data.loadPersistence():next(function()
    print("Persistence loaded")
end)

-- Load with error handling
lia.data.loadPersistence():next(function()
    print("Persistence loaded successfully")
end):catch(function(err)
    print("Failed to load persistence: " .. tostring(err))
end)

-- Load in map initialization
hook.Add("InitPostEntity", "LoadPersistence", function()
    lia.data.loadPersistence()
end)
```

---

### lia.data.savePersistence

**Purpose**

Saves entity persistence data to the database.

**Parameters**

* `entities` (*table*): Table of entity data to save.

**Returns**

*None*

**Realm**

Shared.

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
    for _, ent in pairs(ents.GetAll()) do
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

-- Save in hook
hook.Add("PersistenceSave", "SaveEntities", function()
    local entities = lia.data.getPersistence()
    lia.data.savePersistence(entities)
end)
```

---

### lia.data.loadPersistenceData

**Purpose**

Loads persistence data from the database and executes callback.

**Parameters**

* `callback` (*function*): Callback function to execute with loaded entities.

**Returns**

*None*

**Realm**

Shared.

**Example Usage**

```lua
-- Load persistence data
lia.data.loadPersistenceData(function(entities)
    print("Loaded " .. #entities .. " persistent entities")
    for _, ent in ipairs(entities) do
        print("Entity: " .. ent.class .. " at " .. tostring(ent.pos))
    end
end)

-- Load and spawn entities
lia.data.loadPersistenceData(function(entities)
    for _, entData in ipairs(entities) do
        local ent = ents.Create(entData.class)
        if IsValid(ent) then
            ent:SetPos(entData.pos)
            ent:SetAngles(entData.angles)
            ent:SetModel(entData.model)
            ent:Spawn()
        end
    end
end)

-- Load with error handling
lia.data.loadPersistenceData(function(entities)
    if entities and #entities > 0 then
        print("Successfully loaded " .. #entities .. " entities")
    else
        print("No persistence data found")
    end
end)
```

---

### lia.data.get

**Purpose**

Gets a stored data value with automatic deserialization.

**Parameters**

* `key` (*string*): The key to retrieve.
* `default` (*any*): Default value to return if key not found.

**Returns**

* `value` (*any*): The stored value or default.

**Realm**

Shared.

**Example Usage**

```lua
-- Get a simple value
local value = lia.data.get("serverName", "Default Server")
print(value)

-- Get a complex value
local playerData = lia.data.get("playerData", {})
if playerData.pos then
    print("Player position: " .. tostring(playerData.pos))
end

-- Get with validation
local function safeGet(key, default)
    local value = lia.data.get(key, default)
    if value ~= nil then
        return value
    else
        print("Key not found: " .. key)
        return default
    end
end

-- Get in command
lia.command.add("getdata", {
    arguments = {
        {name = "key", type = "string"}
    },
    onRun = function(client, arguments)
        local key = arguments[1]
        local value = lia.data.get(key, "Not found")
        client:ChatPrint(key .. " = " .. tostring(value))
    end
})
```

---

### lia.data.getPersistence

**Purpose**

Gets the current persistence cache.

**Parameters**

*None*

**Returns**

* `entities` (*table*): Table of persistent entity data.

**Realm**

Shared.

**Example Usage**

```lua
-- Get persistence data
local entities = lia.data.getPersistence()
print("Persistent entities: " .. #entities)

-- Get and process persistence
local entities = lia.data.getPersistence()
for _, ent in ipairs(entities) do
    print("Entity: " .. ent.class .. " at " .. tostring(ent.pos))
end

-- Get persistence for saving
local function saveCurrentPersistence()
    local entities = lia.data.getPersistence()
    lia.data.savePersistence(entities)
end

-- Get persistence in hook
hook.Add("PersistenceSave", "GetPersistence", function()
    local entities = lia.data.getPersistence()
    print("Saving " .. #entities .. " persistent entities")
end)
```