# lia.database

## Overview
The `lia.database` library provides comprehensive database functionality for the Lilia framework. It includes caching, query management, table operations, and data migration capabilities.

## Functions

### lia.db.setCacheEnabled
**Purpose**  
Enables or disables the database query cache.

**Parameters**  
- `enabled` (boolean): Whether to enable caching

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Enable database caching
lia.db.setCacheEnabled(true)

-- Disable database caching
lia.db.setCacheEnabled(false)
```

### lia.db.setCacheTTL
**Purpose**  
Sets the time-to-live (TTL) for cached database queries in seconds.

**Parameters**  
- `seconds` (number): TTL in seconds (0 to disable expiration)

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Set cache TTL to 30 seconds
lia.db.setCacheTTL(30)

-- Disable cache expiration
lia.db.setCacheTTL(0)
```

### lia.db.cacheClear
**Purpose**  
Clears all cached database queries.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Clear all cached queries
lia.db.cacheClear()
```

### lia.db.cacheGet
**Purpose**  
Retrieves a cached database query result.

**Parameters**  
- `key` (string): The cache key to retrieve

**Returns**  
any: The cached value or nil if not found/expired

**Realm**  
Server

**Example Usage**
```lua
-- Get a cached query result
local result = lia.db.cacheGet("my_query_key")
if result then
    print("Found cached result")
end
```

### lia.db.cacheSet
**Purpose**  
Stores a database query result in the cache.

**Parameters**  
- `tableName` (string): The database table name
- `key` (string): The cache key
- `value` (any): The value to cache

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Cache a query result
lia.db.cacheSet("lia_config", "my_query_key", queryResult)
```

### lia.db.invalidateTable
**Purpose**  
Invalidates all cached queries for a specific table.

**Parameters**  
- `tableName` (string): The table name to invalidate

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Invalidate all cached queries for lia_config table
lia.db.invalidateTable("lia_config")
```

### lia.db.normalizeIdentifier
**Purpose**  
Normalizes a database identifier by removing leading underscores.

**Parameters**  
- `name` (string): The identifier to normalize

**Returns**  
string: The normalized identifier

**Realm**  
Server

**Example Usage**
```lua
-- Normalize a database identifier
local normalized = lia.db.normalizeIdentifier("_my_column")
-- Returns "my_column"
```

### lia.db.normalizeSQLIdentifiers
**Purpose**  
Normalizes SQL identifiers in a query string by removing leading underscores.

**Parameters**  
- `sql` (string): The SQL query string

**Returns**  
string: The normalized SQL query

**Realm**  
Server

**Example Usage**
```lua
-- Normalize SQL identifiers in a query
local normalized = lia.db.normalizeSQLIdentifiers("SELECT `_id` FROM `_table`")
-- Returns "SELECT `id` FROM `table`"
```

### lia.db.connect
**Purpose**  
Establishes a connection to the database.

**Parameters**  
- `connectCallback` (function): Callback function to execute after connection
- `reconnect` (boolean): Whether this is a reconnection attempt

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Connect to database with callback
lia.db.connect(function()
    print("Database connected successfully")
end)
```

### lia.db.wipeTables
**Purpose**  
Wipes all database tables (removes all data).

**Parameters**  
- `callback` (function): Callback function to execute after wiping

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Wipe all database tables
lia.db.wipeTables(function()
    print("All tables wiped")
end)
```

### lia.db.loadTables
**Purpose**  
Loads all database tables and their schemas.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Load all database tables
lia.db.loadTables()
```

### lia.db.waitForTablesToLoad
**Purpose**  
Waits for all database tables to finish loading.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Wait for tables to load
lia.db.waitForTablesToLoad()
```

### lia.db.convertDataType
**Purpose**  
Converts a Lua value to the appropriate database data type.

**Parameters**  
- `value` (any): The value to convert
- `noEscape` (boolean): Whether to skip SQL escaping

**Returns**  
string: The converted value

**Realm**  
Server

**Example Usage**
```lua
-- Convert a value to database format
local dbValue = lia.db.convertDataType("test string")
```

### lia.db.insertTable
**Purpose**  
Inserts a table of data into a database table.

**Parameters**  
- `value` (table): The data to insert
- `callback` (function): Callback function to execute after insertion
- `dbTable` (string): The target database table name

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Insert data into a table
lia.db.insertTable({
    name = "test",
    value = 123
}, function(result)
    print("Insert completed")
end, "my_table")
```

### lia.db.updateTable
**Purpose**  
Updates records in a database table based on a condition.

**Parameters**  
- `value` (table): The data to update
- `callback` (function): Callback function to execute after update
- `dbTable` (string): The target database table name
- `condition` (string): The WHERE condition for the update

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Update records in a table
lia.db.updateTable({
    value = 456
}, function(result)
    print("Update completed")
end, "my_table", "name = 'test'")
```

### lia.db.select
**Purpose**  
Performs a SELECT query on a database table.

**Parameters**  
- `fields` (string): The fields to select
- `dbTable` (string): The table to query
- `condition` (string): The WHERE condition
- `limit` (number): Maximum number of results
- `orderBy` (string): ORDER BY clause
- `maybeOrderBy` (string): Alternative ORDER BY clause

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Select records from a table
lia.db.select("*", "my_table", "value > 100", 10, "name ASC", function(result)
    print("Found " .. #result .. " records")
end)
```

### lia.db.selectWithCondition
**Purpose**  
Performs a SELECT query with complex conditions.

**Parameters**  
- `fields` (string): The fields to select
- `dbTable` (string): The table to query
- `conditions` (table): Complex condition table
- `limit` (number): Maximum number of results
- `orderBy` (string): ORDER BY clause

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Select with complex conditions
lia.db.selectWithCondition("*", "my_table", {
    {field = "name", operator = "=", value = "test"},
    {field = "value", operator = ">", value = 100}
}, 10, "name ASC", function(result)
    print("Found " .. #result .. " records")
end)
```

### lia.db.count
**Purpose**  
Counts the number of records in a table matching a condition.

**Parameters**  
- `dbTable` (string): The table to count
- `condition` (string): The WHERE condition

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Count records in a table
lia.db.count("my_table", "value > 100", function(count)
    print("Found " .. count .. " records")
end)
```

### lia.db.exists
**Purpose**  
Checks if a record exists in a table matching a condition.

**Parameters**  
- `dbTable` (string): The table to check
- `condition` (string): The WHERE condition

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Check if a record exists
lia.db.exists("my_table", "name = 'test'", function(exists)
    if exists then
        print("Record exists")
    else
        print("Record does not exist")
    end
end)
```

### lia.db.addExpectedSchema
**Purpose**  
Adds an expected database schema for migration purposes.

**Parameters**  
- `tableName` (string): The table name
- `schema` (table): The expected schema definition

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Add expected schema for a table
lia.db.addExpectedSchema("my_table", {
    {name = "id", type = "INTEGER", primary = true},
    {name = "name", type = "TEXT"},
    {name = "value", type = "INTEGER"}
})
```

### lia.db.migrateDatabaseSchemas
**Purpose**  
Migrates database schemas to match expected schemas.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Migrate database schemas
lia.db.migrateDatabaseSchemas()
```

### lia.db.addDatabaseFields
**Purpose**  
Adds missing database fields based on expected schemas.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Add missing database fields
lia.db.addDatabaseFields()
```

### lia.db.selectOne
**Purpose**  
Selects a single record from a table.

**Parameters**  
- `fields` (string): The fields to select
- `dbTable` (string): The table to query
- `condition` (string): The WHERE condition

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Select a single record
lia.db.selectOne("*", "my_table", "id = 1", function(result)
    if result then
        print("Found record: " .. result.name)
    end
end)
```

### lia.db.selectWithJoin
**Purpose**  
Performs a SELECT query with JOIN operations.

**Parameters**  
- `query` (string): The complete SQL query with JOINs

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Select with JOIN
lia.db.selectWithJoin("SELECT * FROM table1 JOIN table2 ON table1.id = table2.table1_id", function(result)
    print("Found " .. #result .. " joined records")
end)
```

### lia.db.bulkInsert
**Purpose**  
Performs bulk insertion of multiple records.

**Parameters**  
- `dbTable` (string): The target table
- `rows` (table): Array of record tables to insert

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Bulk insert multiple records
lia.db.bulkInsert("my_table", {
    {name = "test1", value = 100},
    {name = "test2", value = 200},
    {name = "test3", value = 300}
}, function(result)
    print("Bulk insert completed")
end)
```

### lia.db.bulkUpsert
**Purpose**  
Performs bulk upsert (insert or update) of multiple records.

**Parameters**  
- `dbTable` (string): The target table
- `rows` (table): Array of record tables to upsert

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Bulk upsert multiple records
lia.db.bulkUpsert("my_table", {
    {id = 1, name = "test1", value = 100},
    {id = 2, name = "test2", value = 200}
}, function(result)
    print("Bulk upsert completed")
end)
```

### lia.db.insertOrIgnore
**Purpose**  
Inserts a record or ignores if it already exists.

**Parameters**  
- `value` (table): The data to insert
- `dbTable` (string): The target table

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Insert or ignore
lia.db.insertOrIgnore({
    id = 1,
    name = "test",
    value = 100
}, "my_table", function(result)
    print("Insert or ignore completed")
end)
```

### lia.db.tableExists
**Purpose**  
Checks if a database table exists.

**Parameters**  
- `tbl` (string): The table name to check

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Check if table exists
lia.db.tableExists("my_table", function(exists)
    if exists then
        print("Table exists")
    else
        print("Table does not exist")
    end
end)
```

### lia.db.fieldExists
**Purpose**  
Checks if a field exists in a database table.

**Parameters**  
- `tbl` (string): The table name
- `field` (string): The field name to check

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Check if field exists
lia.db.fieldExists("my_table", "my_field", function(exists)
    if exists then
        print("Field exists")
    else
        print("Field does not exist")
    end
end)
```

### lia.db.getTables
**Purpose**  
Gets a list of all database tables.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Get all tables
lia.db.getTables(function(tables)
    print("Found " .. #tables .. " tables")
    for _, tableName in ipairs(tables) do
        print("Table: " .. tableName)
    end
end)
```

### lia.db.getTableColumns
**Purpose**  
Gets the columns of a specific database table.

**Parameters**  
- `tbl` (string): The table name

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Get table columns
lia.db.getTableColumns("my_table", function(columns)
    print("Table has " .. #columns .. " columns")
    for _, column in ipairs(columns) do
        print("Column: " .. column.name .. " (" .. column.type .. ")")
    end
end)
```

### lia.db.transaction
**Purpose**  
Executes multiple database queries in a transaction.

**Parameters**  
- `queries` (table): Array of query objects with sql and callback

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Execute transaction
lia.db.transaction({
    {sql = "INSERT INTO table1 (name) VALUES ('test1')"},
    {sql = "INSERT INTO table2 (name) VALUES ('test2')"}
}, function(success)
    if success then
        print("Transaction completed successfully")
    else
        print("Transaction failed")
    end
end)
```

### lia.db.escapeIdentifier
**Purpose**  
Escapes a database identifier for safe use in SQL queries.

**Parameters**  
- `id` (string): The identifier to escape

**Returns**  
string: The escaped identifier

**Realm**  
Server

**Example Usage**
```lua
-- Escape an identifier
local escaped = lia.db.escapeIdentifier("my_table")
-- Returns "`my_table`"
```

### lia.db.upsert
**Purpose**  
Performs an upsert (insert or update) operation on a record.

**Parameters**  
- `value` (table): The data to upsert
- `dbTable` (string): The target table

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Upsert a record
lia.db.upsert({
    id = 1,
    name = "test",
    value = 100
}, "my_table", function(result)
    print("Upsert completed")
end)
```

### lia.db.delete
**Purpose**  
Deletes records from a table based on a condition.

**Parameters**  
- `dbTable` (string): The table to delete from
- `condition` (string): The WHERE condition

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Delete records
lia.db.delete("my_table", "value < 50", function(result)
    print("Delete completed")
end)
```

### lia.db.createTable
**Purpose**  
Creates a new database table with the specified schema.

**Parameters**  
- `dbName` (string): The table name
- `primaryKey` (string): The primary key field name
- `schema` (table): The table schema definition

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Create a new table
lia.db.createTable("my_table", "id", {
    {name = "id", type = "INTEGER", primary = true},
    {name = "name", type = "TEXT"},
    {name = "value", type = "INTEGER"}
}, function(success)
    if success then
        print("Table created successfully")
    end
end)
```

### lia.db.createColumn
**Purpose**  
Adds a new column to an existing database table.

**Parameters**  
- `tableName` (string): The table name
- `columnName` (string): The new column name
- `columnType` (string): The column data type
- `options` (table): Additional column options

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Add a new column
lia.db.createColumn("my_table", "new_field", "TEXT", {
    notNull = true,
    defaultValue = "default"
}, function(success)
    if success then
        print("Column added successfully")
    end
end)
```

### lia.db.removeTable
**Purpose**  
Removes a database table.

**Parameters**  
- `tableName` (string): The table name to remove

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Remove a table
lia.db.removeTable("my_table", function(success)
    if success then
        print("Table removed successfully")
    end
end)
```

### lia.db.removeColumn
**Purpose**  
Removes a column from a database table.

**Parameters**  
- `tableName` (string): The table name
- `columnName` (string): The column name to remove

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Remove a column
lia.db.removeColumn("my_table", "old_field", function(success)
    if success then
        print("Column removed successfully")
    end
end)
```

### lia.db.GetCharacterTable
**Purpose**  
Gets the character table with proper schema for character data.

**Parameters**  
- `callback` (function): Callback function to execute after getting the table

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Get character table
lia.db.GetCharacterTable(function(table)
    print("Character table ready")
end)
```

### lia.db.autoRemoveUnderscoreColumns
**Purpose**  
Automatically removes columns that start with underscores from all tables.

**Parameters**  
None

**Returns**  
None

**Realm**  
Server

**Example Usage**
```lua
-- Remove underscore columns
lia.db.autoRemoveUnderscoreColumns()
```