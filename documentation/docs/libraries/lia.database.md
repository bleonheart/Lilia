# Database Library

This page documents the functions for working with database operations and SQLite queries.

---

## Overview

The database library (`lia.db`) provides a comprehensive system for database operations in the Lilia framework. It handles SQLite database connections, query execution, table management, data operations, caching, and provides extensive testing and maintenance utilities. The library supports both synchronous and asynchronous operations with promise-based callbacks.

---

### lia.db.query

**Purpose**

Executes a SQL query against the database with optional callback functions.

**Parameters**

* `query` (*string*): The SQL query to execute.
* `callback` (*function*, optional): Success callback function.
* `errorCallback` (*function*, optional): Error callback function.

**Returns**

* `promise` (*Deferred*): A promise object for the query operation.

**Realm**

Server.

**Example Usage**

```lua
-- Execute a simple query
lia.db.query("SELECT * FROM lia_characters", function(results)
    print("Found " .. #results .. " characters")
end)

-- Execute with error handling
lia.db.query("SELECT * FROM lia_characters", function(results)
    print("Query successful")
end, function(err)
    print("Query failed: " .. err)
end)
```

### lia.db.select

**Purpose**

Selects data from a database table with optional conditions and limits.

**Parameters**

* `fields` (*string|table*): Fields to select (string or table of field names).
* `dbTable` (*string*): The database table name (without lia_ prefix).
* `condition` (*string*, optional): WHERE condition for the query.
* `limit` (*number*, optional): Maximum number of results to return.

**Returns**

* `promise` (*Deferred*): A promise that resolves with query results.

**Realm**

Server.

**Example Usage**

```lua
-- Select all characters
lia.db.select("*", "characters"):next(function(result)
    print("Found " .. #result.results .. " characters")
end)

-- Select with condition
lia.db.select("name, money", "characters", "money > 1000"):next(function(result)
    for _, char in ipairs(result.results) do
        print(char.name .. " has " .. char.money .. " money")
    end
end)

-- Select with limit
lia.db.select("*", "characters", nil, 10):next(function(result)
    print("Top 10 characters loaded")
end)
```

### lia.db.selectOne

**Purpose**

Selects a single row from a database table with optional conditions.

**Parameters**

* `fields` (*string|table*): Fields to select (string or table of field names).
* `dbTable` (*string*): The database table name (without lia_ prefix).
* `condition` (*string*, optional): WHERE condition for the query.

**Returns**

* `promise` (*Deferred*): A promise that resolves with a single row or nil.

**Realm**

Server.

**Example Usage**

```lua
-- Get a specific character
lia.db.selectOne("*", "characters", "id = 1"):next(function(char)
    if char then
        print("Character found: " .. char.name)
    else
        print("Character not found")
    end
end)

-- Get character by name
lia.db.selectOne("id, name", "characters", "name = 'John'"):next(function(char)
    if char then
        print("Character ID: " .. char.id)
    end
end)
```

### lia.db.insertTable

**Purpose**

Inserts data into a database table.

**Parameters**

* `value` (*table*): The data to insert (key-value pairs).
* `callback` (*function*, optional): Success callback function.
* `dbTable` (*string*): The database table name (without lia_ prefix).

**Returns**

* `promise` (*Deferred*): A promise that resolves with insert results.

**Realm**

Server.

**Example Usage**

```lua
-- Insert a new character
lia.db.insertTable({
    name = "John Doe",
    money = 1000,
    level = 1
}, "characters"):next(function(result)
    print("Character inserted with ID: " .. result.lastID)
end)

-- Insert with callback
lia.db.insertTable({
    name = "Jane Doe",
    money = 500
}, function(result)
    print("Insert successful")
end, "characters")
```

### lia.db.updateTable

**Purpose**

Updates data in a database table based on conditions.

**Parameters**

* `value` (*table*): The data to update (key-value pairs).
* `callback` (*function*, optional): Success callback function.
* `dbTable` (*string*): The database table name (without lia_ prefix).
* `condition` (*string*): WHERE condition for the update.

**Returns**

* `promise` (*Deferred*): A promise that resolves with update results.

**Realm**

Server.

**Example Usage**

```lua
-- Update character money
lia.db.updateTable({
    money = 2000
}, nil, "characters", "id = 1"):next(function(result)
    print("Character updated")
end)

-- Update multiple fields
lia.db.updateTable({
    money = 1500,
    level = 2
}, nil, "characters", "name = 'John'"):next(function(result)
    print("Character updated successfully")
end)
```

### lia.db.delete

**Purpose**

Deletes data from a database table based on conditions.

**Parameters**

* `dbTable` (*string*): The database table name (without lia_ prefix).
* `condition` (*string*, optional): WHERE condition for the delete operation.

**Returns**

* `promise` (*Deferred*): A promise that resolves with delete results.

**Realm**

Server.

**Example Usage**

```lua
-- Delete a specific character
lia.db.delete("characters", "id = 1"):next(function(result)
    print("Character deleted")
end)

-- Delete all characters with low money
lia.db.delete("characters", "money < 100"):next(function(result)
    print("Low money characters deleted")
end)
```

### lia.db.count

**Purpose**

Counts the number of rows in a database table with optional conditions.

**Parameters**

* `dbTable` (*string*): The database table name (without lia_ prefix).
* `condition` (*string*, optional): WHERE condition for the count.

**Returns**

* `promise` (*Deferred*): A promise that resolves with the count number.

**Realm**

Server.

**Example Usage**

```lua
-- Count all characters
lia.db.count("characters"):next(function(count)
    print("Total characters: " .. count)
end)

-- Count characters with specific condition
lia.db.count("characters", "money > 1000"):next(function(count)
    print("Rich characters: " .. count)
end)
```

### lia.db.exists

**Purpose**

Checks if any rows exist in a database table matching the given condition.

**Parameters**

* `dbTable` (*string*): The database table name (without lia_ prefix).
* `condition` (*string*): WHERE condition to check.

**Returns**

* `promise` (*Deferred*): A promise that resolves with true/false.

**Realm**

Server.

**Example Usage**

```lua
-- Check if character exists
lia.db.exists("characters", "name = 'John'"):next(function(exists)
    if exists then
        print("Character exists")
    else
        print("Character not found")
    end
end)

-- Check if any rich characters exist
lia.db.exists("characters", "money > 10000"):next(function(exists)
    if exists then
        print("Rich characters found")
    end
end)
```

### lia.db.bulkInsert

**Purpose**

Performs bulk insert operations for multiple rows at once.

**Parameters**

* `dbTable` (*string*): The database table name (without lia_ prefix).
* `rows` (*table*): Array of row data to insert.

**Returns**

* `promise` (*Deferred*): A promise that resolves when bulk insert is complete.

**Realm**

Server.

**Example Usage**

```lua
-- Bulk insert multiple characters
local characters = {
    {name = "John", money = 1000},
    {name = "Jane", money = 1500},
    {name = "Bob", money = 800}
}

lia.db.bulkInsert("characters", characters):next(function()
    print("Bulk insert completed")
end)
```

### lia.db.bulkUpsert

**Purpose**

Performs bulk upsert operations (insert or replace) for multiple rows.

**Parameters**

* `dbTable` (*string*): The database table name (without lia_ prefix).
* `rows` (*table*): Array of row data to upsert.

**Returns**

* `promise` (*Deferred*): A promise that resolves when bulk upsert is complete.

**Realm**

Server.

**Example Usage**

```lua
-- Bulk upsert characters
local characters = {
    {id = 1, name = "John", money = 2000},
    {id = 2, name = "Jane", money = 2500}
}

lia.db.bulkUpsert("characters", characters):next(function()
    print("Bulk upsert completed")
end)
```

### lia.db.upsert

**Purpose**

Inserts or updates a row in the database (insert or replace).

**Parameters**

* `value` (*table*): The data to upsert (key-value pairs).
* `dbTable` (*string*): The database table name (without lia_ prefix).

**Returns**

* `promise` (*Deferred*): A promise that resolves with upsert results.

**Realm**

Server.

**Example Usage**

```lua
-- Upsert character data
lia.db.upsert({
    id = 1,
    name = "John",
    money = 3000
}, "characters"):next(function(result)
    print("Character upserted")
end)
```

### lia.db.insertOrIgnore

**Purpose**

Inserts a row into the database, ignoring if it already exists.

**Parameters**

* `value` (*table*): The data to insert (key-value pairs).
* `dbTable` (*string*): The database table name (without lia_ prefix).

**Returns**

* `promise` (*Deferred*): A promise that resolves with insert results.

**Realm**

Server.

**Example Usage**

```lua
-- Insert character if not exists
lia.db.insertOrIgnore({
    name = "John",
    money = 1000
}, "characters"):next(function(result)
    print("Character inserted or ignored")
end)
```

### lia.db.transaction

**Purpose**

Executes multiple queries within a database transaction.

**Parameters**

* `queries` (*table*): Array of SQL queries to execute in the transaction.

**Returns**

* `promise` (*Deferred*): A promise that resolves when transaction is complete.

**Realm**

Server.

**Example Usage**

```lua
-- Execute multiple queries in transaction
local queries = {
    "INSERT INTO lia_characters (name, money) VALUES ('John', 1000)",
    "INSERT INTO lia_characters (name, money) VALUES ('Jane', 1500)",
    "UPDATE lia_characters SET money = money + 100 WHERE name = 'John'"
}

lia.db.transaction(queries):next(function()
    print("Transaction completed successfully")
end)
```

### lia.db.createTable

**Purpose**

Creates a new database table with specified schema.

**Parameters**

* `dbName` (*string*): The table name (without lia_ prefix).
* `primaryKey` (*string|table*): Primary key column name or array of primary key columns.
* `schema` (*table*): Array of column definitions.

**Returns**

* `promise` (*Deferred*): A promise that resolves with table creation results.

**Realm**

Server.

**Example Usage**

```lua
-- Create a new table
local schema = {
    {name = "id", type = "integer", auto_increment = true},
    {name = "name", type = "string", not_null = true},
    {name = "value", type = "integer", default = 0}
}

lia.db.createTable("mytable", "id", schema):next(function(result)
    print("Table created successfully")
end)
```

### lia.db.createColumn

**Purpose**

Adds a new column to an existing database table.

**Parameters**

* `tableName` (*string*): The table name (without lia_ prefix).
* `columnName` (*string*): The name of the new column.
* `columnType` (*string*): The data type of the new column.
* `options` (*table*, optional): Additional column options.

**Returns**

* `promise` (*Deferred*): A promise that resolves with column creation results.

**Realm**

Server.

**Example Usage**

```lua
-- Add a new column
lia.db.createColumn("characters", "level", "integer", {
    default = 1,
    not_null = true
}):next(function(result)
    print("Column added successfully")
end)
```

### lia.db.removeTable

**Purpose**

Removes a database table.

**Parameters**

* `tableName` (*string*): The table name (without lia_ prefix).

**Returns**

* `promise` (*Deferred*): A promise that resolves with removal results.

**Realm**

Server.

**Example Usage**

```lua
-- Remove a table
lia.db.removeTable("mytable"):next(function(success)
    if success then
        print("Table removed successfully")
    end
end)
```

### lia.db.removeColumn

**Purpose**

Removes a column from a database table.

**Parameters**

* `tableName` (*string*): The table name (without lia_ prefix).
* `columnName` (*string*): The name of the column to remove.

**Returns**

* `promise` (*Deferred*): A promise that resolves with column removal results.

**Realm**

Server.

**Example Usage**

```lua
-- Remove a column
lia.db.removeColumn("characters", "old_field"):next(function(success)
    if success then
        print("Column removed successfully")
    end
end)
```

### lia.db.tableExists

**Purpose**

Checks if a database table exists.

**Parameters**

* `tbl` (*string*): The table name (with or without lia_ prefix).

**Returns**

* `promise` (*Deferred*): A promise that resolves with true/false.

**Realm**

Server.

**Example Usage**

```lua
-- Check if table exists
lia.db.tableExists("lia_characters"):next(function(exists)
    if exists then
        print("Table exists")
    else
        print("Table not found")
    end
end)
```

### lia.db.fieldExists

**Purpose**

Checks if a column exists in a database table.

**Parameters**

* `tbl` (*string*): The table name (with or without lia_ prefix).
* `field` (*string*): The column name to check.

**Returns**

* `promise` (*Deferred*): A promise that resolves with true/false.

**Realm**

Server.

**Example Usage**

```lua
-- Check if column exists
lia.db.fieldExists("lia_characters", "name"):next(function(exists)
    if exists then
        print("Column exists")
    else
        print("Column not found")
    end
end)
```

### lia.db.getTables

**Purpose**

Gets a list of all lia_* tables in the database.

**Returns**

* `promise` (*Deferred*): A promise that resolves with an array of table names.

**Realm**

Server.

**Example Usage**

```lua
-- Get all tables
lia.db.getTables():next(function(tables)
    print("Found " .. #tables .. " tables:")
    for _, tableName in ipairs(tables) do
        print("  - " .. tableName)
    end
end)
```

### lia.db.getTableColumns

**Purpose**

Gets information about columns in a database table.

**Parameters**

* `tbl` (*string*): The table name (with or without lia_ prefix).

**Returns**

* `promise` (*Deferred*): A promise that resolves with column information.

**Realm**

Server.

**Example Usage**

```lua
-- Get table columns
lia.db.getTableColumns("lia_characters"):next(function(columns)
    print("Table columns:")
    for columnName, columnType in pairs(columns) do
        print("  - " .. columnName .. " (" .. columnType .. ")")
    end
end)
```

### lia.db.escape

**Purpose**

Escapes a string value for safe use in SQL queries.

**Parameters**

* `value` (*string*): The string value to escape.

**Returns**

* `escapedValue` (*string*): The escaped string value.

**Realm**

Server.

**Example Usage**

```lua
-- Escape a string for SQL
local escaped = lia.db.escape("test'value")
print(escaped) -- Output: test''value
```

### lia.db.escapeIdentifier

**Purpose**

Escapes an identifier (column/table name) for safe use in SQL queries.

**Parameters**

* `id` (*string*): The identifier to escape.

**Returns**

* `escapedIdentifier` (*string*): The escaped identifier.

**Realm**

Server.

**Example Usage**

```lua
-- Escape an identifier
local escaped = lia.db.escapeIdentifier("user_name")
print(escaped) -- Output: `user_name`
```

### lia.db.convertDataType

**Purpose**

Converts a Lua value to its SQL representation.

**Parameters**

* `value` (*any*): The value to convert.

**Returns**

* `sqlValue` (*string*): The SQL representation of the value.

**Realm**

Server.

**Example Usage**

```lua
-- Convert different data types
local str = lia.db.convertDataType("hello") -- "'hello'"
local num = lia.db.convertDataType(123) -- "123"
local nilVal = lia.db.convertDataType(nil) -- "NULL"
```

### lia.db.cacheSet

**Purpose**

Sets a value in the database cache.

**Parameters**

* `table` (*string*): The table name for cache key.
* `key` (*string*): The cache key.
* `value` (*any*): The value to cache.

**Realm**

Server.

**Example Usage**

```lua
-- Cache a value
lia.db.cacheSet("characters", "char_1", {
    name = "John",
    money = 1000
})
```

### lia.db.cacheGet

**Purpose**

Gets a value from the database cache.

**Parameters**

* `key` (*string*): The cache key to retrieve.

**Returns**

* `cachedValue` (*any*): The cached value or nil if not found.

**Realm**

Server.

**Example Usage**

```lua
-- Get cached value
local cached = lia.db.cacheGet("char_1")
if cached then
    print("Found cached character: " .. cached.name)
end
```

### lia.db.cacheClear

**Purpose**

Clears all cached values.

**Realm**

Server.

**Example Usage**

```lua
-- Clear all cache
lia.db.cacheClear()
print("Cache cleared")
```

### lia.db.invalidateTable

**Purpose**

Invalidates all cached values for a specific table.

**Parameters**

* `table` (*string*): The table name to invalidate.

**Realm**

Server.

**Example Usage**

```lua
-- Invalidate table cache
lia.db.invalidateTable("lia_characters")
print("Character table cache invalidated")
```

### lia.db.setCacheEnabled

**Purpose**

Enables or disables the database cache.

**Parameters**

* `enabled` (*boolean*): Whether to enable caching.

**Realm**

Server.

**Example Usage**

```lua
-- Enable caching
lia.db.setCacheEnabled(true)

-- Disable caching
lia.db.setCacheEnabled(false)
```

### lia.db.setCacheTTL

**Purpose**

Sets the cache time-to-live in seconds.

**Parameters**

* `ttl` (*number*): The TTL in seconds.

**Realm**

Server.

**Example Usage**

```lua
-- Set cache TTL to 30 seconds
lia.db.setCacheTTL(30)
```

### lia.db.waitForTablesToLoad

**Purpose**

Waits for all database tables to finish loading.

**Returns**

* `promise` (*Deferred*): A promise that resolves when tables are loaded.

**Realm**

Server.

**Example Usage**

```lua
-- Wait for tables to load
lia.db.waitForTablesToLoad():next(function()
    print("All tables loaded successfully")
end)
```

### lia.db.autoRemoveUnderscoreColumns

**Purpose**

Automatically removes columns with leading underscores from all lia_* tables.

**Returns**

* `promise` (*Deferred*): A promise that resolves when cleanup is complete.

**Realm**

Server.

**Example Usage**

```lua
-- Auto-remove underscore columns
lia.db.autoRemoveUnderscoreColumns():next(function()
    print("Underscore columns removed")
end)
```

### lia.db.addExpectedSchema

**Purpose**

Adds an expected schema for database migration purposes.

**Parameters**

* `tableName` (*string*): The table name.
* `schema` (*table*): The expected schema definition.

**Realm**

Server.

**Example Usage**

```lua
-- Add expected schema
lia.db.addExpectedSchema("characters", {
    id = {type = "integer", auto_increment = true},
    name = {type = "string", not_null = true}
})
```

### lia.db.GetCharacterTable

**Purpose**

Gets the character table structure for compatibility purposes.

**Parameters**

* `callback` (*function*): Callback function to receive column information.

**Realm**

Server.

**Example Usage**

```lua
-- Get character table structure
lia.db.GetCharacterTable(function(columns)
    print("Character table columns:")
    for _, column in ipairs(columns) do
        print("  - " .. column)
    end
end)
```

---

### lia.db.normalizeIdentifier

**Purpose**

Normalizes an identifier (column/table name) for safe use in SQL queries.

**Parameters**

* `name` (*string*): The identifier name to normalize.

**Returns**

* `normalized` (*string*): The normalized identifier.

**Realm**

Server.

**Example Usage**

```lua
-- Normalize table name
local tableName = lia.db.normalizeIdentifier("user_data")
print(tableName) -- "user_data"

-- Normalize column name
local columnName = lia.db.normalizeIdentifier("userName")
print(columnName) -- "userName"
```

---

### lia.db.normalizeSQLIdentifiers

**Purpose**

Normalizes all identifiers in an SQL query string.

**Parameters**

* `sql` (*string*): The SQL query string to normalize.

**Returns**

* `normalized` (*string*): The SQL query with normalized identifiers.

**Realm**

Server.

**Example Usage**

```lua
-- Normalize SQL query
local query = "SELECT userName FROM user_data WHERE userID = ?"
local normalized = lia.db.normalizeSQLIdentifiers(query)
print(normalized) -- "SELECT userName FROM user_data WHERE userID = ?"
```

---

### lia.db.connect

**Purpose**

Establishes a connection to the database.

**Parameters**

* `connectCallback` (*function*, *optional*): Callback function called when connection is established.
* `reconnect` (*boolean*, *optional*): Whether this is a reconnection attempt.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Connect to database
lia.db.connect(function()
    print("Database connection established")
end)

-- Connect with error handling
lia.db.connect(function()
    print("Connected successfully")
end, false)
```

---

### lia.db.wipeTables

**Purpose**

Wipes all database tables (removes all data).

**Parameters**

* `callback` (*function*, *optional*): Callback function called when wipe is complete.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Wipe all tables (dangerous!)
lia.db.wipeTables(function()
    print("All tables wiped")
end)

-- Wipe tables with confirmation
local function wipeDatabase()
    print("WARNING: This will delete all data!")
    lia.db.wipeTables(function()
        print("Database wiped successfully")
    end)
end
```

---

### lia.db.loadTables

**Purpose**

Loads all database tables and their schemas.

**Parameters**

* None.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Load database tables
lia.db.loadTables()
print("Database tables loaded")

-- Load tables on server start
hook.Add("Initialize", "LoadTables", function()
    lia.db.loadTables()
end)
```

---

### lia.db.selectWithCondition

**Purpose**

Performs a select query with complex condition building.

**Parameters**

* `fields` (*string|table*): Fields to select.
* `dbTable` (*string*): The database table name (without lia_ prefix).
* `conditions` (*table*): Complex condition object.
* `limit` (*number*, *optional*): Maximum number of results.
* `orderBy` (*string*, *optional*): ORDER BY clause.

**Returns**

* `promise` (*Deferred*): A promise that resolves with query results.

**Realm**

Server.

**Example Usage**

```lua
-- Select with complex conditions
lia.db.selectWithCondition("*", "characters", {
    name = "John%",
    money = {">", 1000}
}, 10, "name ASC"):next(function(result)
    print("Found " .. #result.results .. " characters")
end)

-- Select with OR conditions
lia.db.selectWithCondition("*", "characters", {
    {"name", "LIKE", "John%"},
    {"OR", "money", ">", 1000}
}):next(function(result)
    print("Complex query results: " .. #result.results)
end)
```

---

### lia.db.selectWithJoin

**Purpose**

Performs a select query with table joins.

**Parameters**

* `query` (*string*): The complete SQL query with joins.

**Returns**

* `promise` (*Deferred*): A promise that resolves with query results.

**Realm**

Server.

**Example Usage**

```lua
-- Select with join
local query = [[
    SELECT c.name, i.itemID
    FROM lia_characters c
    LEFT JOIN lia_inventories i ON c.id = i.charID
    WHERE c.faction = ?
]]

lia.db.selectWithJoin(query):next(function(result)
    print("Joined query results: " .. #result.results)
end)
```

---

### lia.db.migrateDatabaseSchemas

**Purpose**

Migrates database schemas to match expected structures.

**Parameters**

* None.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Migrate database schemas
lia.db.migrateDatabaseSchemas()
print("Database schemas migrated")

-- Migrate on server update
hook.Add("DatabaseConnected", "MigrateSchemas", function()
    lia.db.migrateDatabaseSchemas()
end)
```

---

### lia.db.addDatabaseFields

**Purpose**

Adds missing database fields to existing tables.

**Parameters**

* None.

**Returns**

* None.

**Realm**

Server.

**Example Usage**

```lua
-- Add missing database fields
lia.db.addDatabaseFields()
print("Database fields added")

-- Add fields during initialization
hook.Add("Initialize", "AddDatabaseFields", function()
    lia.db.addDatabaseFields()
end)
```
