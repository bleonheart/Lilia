# Database

Lilia uses the bundled `mysql` library as its only database executor. `lia.db` is a compatibility and schema layer over that library; it is not a second database implementation. Existing Lilia code can keep using deferred values while new code may use the `mysql` query builders directly.

## Configuration

Create `schema/database.lua` in the active schema. SQLite is built into Garry's Mod and needs no external module:

```lua
return {
    adapter = "sqlite",
    hostname = "127.0.0.1",
    username = "",
    password = "",
    database = "",
    port = 3306
}
```

For MySQL, install a binary-compatible Mysqloo module on the server and configure:

```lua
return {
    adapter = "mysqloo",
    hostname = "127.0.0.1",
    username = "lilia",
    password = "change-me",
    database = "lilia",
    port = 3306
}
```

The legacy `module` key is accepted as an alias for `adapter`. `sqlite` and `mysqloo` are the supported adapters.

Startup loads this file, calls `mysql:SetModule`, connects, creates/migrates the schema, and only then runs `OnDatabaseLoaded` followed by `DatabaseConnected`. A failed connection or schema migration never marks the database ready. Reloads share the existing connection and schema initialization is guarded against duplication.

## Canonical API

The bundled library exposes:

```lua
mysql:SetModule("sqlite")
mysql:Connect(host, username, password, database, port)
mysql:IsConnected()
mysql:RawQuery(statement, onSuccess, onError)

mysql:Select("lia_players")
mysql:Insert("lia_players")
mysql:InsertIgnore("lia_players")
mysql:Update("lia_players")
mysql:Delete("lia_players")
mysql:Create("lia_example")
mysql:Alter("lia_example")
mysql:Drop("lia_example")
mysql:Truncate("lia_example")
```

A raw-query success callback receives `(rows, lastInsertID, affectedRows)`. Empty and non-SELECT results are always represented by an empty table. An error callback receives `(message, statement)`. Errors are also logged with the adapter and SQL statement. SQLite and Mysqloo use the same callback shape.

Query builders quote table and column identifiers and escape values through the active adapter:

```lua
local query = mysql:Select("lia_characters")
query:Select("id")
query:Select("name")
query:Where("steamID", client:SteamID())
query:Limit(1)
query:Callback(function(rows)
    local character = rows[1]
end)
query:ErrorCallback(function(message, statement)
    ErrorNoHalt(message .. "\n")
end)
query:Execute()
```

Do not concatenate user input into raw conditions. Prefer builder `Where*` methods or `lia.db.convertDataType` when maintaining an older call site.

## Lilia compatibility API

The following functions are backed entirely by `mysql`:

- `lia.db.query(statement, callback, errorCallback)`
- `lia.db.connect(callback, reconnect, failureCallback)`
- `lia.db.loadTables(callback)` and `lia.db.waitForTablesToLoad()`
- `lia.db.convertDataType(value)` and `lia.db.escapeIdentifier(identifier)`
- `lia.db.insertTable`, `updateTable`, `select`, `selectWithCondition`, and `selectOne`
- `lia.db.count` and `exists`
- `lia.db.bulkInsert`, `bulkUpsert`, `insertOrIgnore`, and `upsert`
- `lia.db.delete`
- `lia.db.tableExists`, `fieldExists`, `getColumns`, `getTables`, and `indexExists`
- `lia.db.transaction`
- `lia.db.createTable`, `createColumn`, `removeTable`, and `removeColumn`
- `lia.db.getCharacterTable`
- `lia.db.createSnapshot` and `loadSnapshot`
- `lia.db.wipeTables`, `wipeCharacters`, `wipeLogs`, and `wipeBans`

Except for callback-based inspection helpers documented by their signature, compatibility operations return a deferred object. Query-shaped operations resolve to:

```lua
{
    results = {},
    lastID = 123,       -- nil when the operation did not insert a row
    affectedRows = 1    -- may be nil for SQLite
}
```

Use `:next()` for success and `:catch()` for failures:

```lua
lia.db.insertTable({
    steamID = client:SteamID(),
    steamName = client:Name()
}, nil, "players"):next(function(result)
    print(result.lastID)
end):catch(function(message)
    ErrorNoHalt(message .. "\n")
end)
```

`selectOne` resolves directly to a row or `nil`; `count` resolves to a number; `exists`, `tableExists`, `fieldExists`, and `indexExists` resolve to booleans; `getTables` and `getColumns` resolve to arrays.

## Transactions

`lia.db.transaction` executes statements sequentially on one connection. It issues `BEGIN TRANSACTION` for SQLite or `START TRANSACTION` for MySQL, commits only after every statement succeeds, and rolls back on the first failure.

```lua
lia.db.transaction({
    "UPDATE `lia_players` SET `userGroup` = 'admin' WHERE `steamID` = 'STEAM_0:1:1'",
    "INSERT INTO `lia_logs` (`message`) VALUES ('promoted')"
}):next(function()
    print("committed")
end):catch(function(message)
    print("rolled back", message)
end)
```

## Schema creation and migration

Core `lia_` tables are created with `mysql:Create`. On an existing database Lilia does not rename, truncate, or recreate tables. It inspects each table through SQLite metadata or MySQL `information_schema`, adds missing columns as nullable storage columns, adds missing indexes, and then adds registered dynamic character fields. Existing rows and IDs are retained.

To add a module table, use `lia.db.createTable` and `lia.db.createColumn`, or the canonical builders:

```lua
local query = mysql:Create("lia_example")
query:Create("id", "INT UNSIGNED NOT NULL AUTO_INCREMENT")
query:Create("name", "VARCHAR(255) NOT NULL")
query:PrimaryKey("id")
query:Execute()
```

Use portable definitions such as `INT`, `VARCHAR(n)`, `LONGTEXT`, `FLOAT`, and `DATETIME`. The SQLite adapter normalizes integer widths, unsigned modifiers, long text, and auto-increment definitions.

## Wiping and snapshots

`lia_wipedb` keeps the existing console confirmation flow. `lia.db.wipeTables` lists only tables beginning with `lia_` through the active adapter, drops them through `mysql:Drop`, and invokes its callback after all drops complete. It does not touch unrelated addon tables.

Snapshots are JSON files under `data/lilia/snapshots`. Loading a snapshot clears and restores the selected table inside a transaction. Snapshot restoration is destructive for that table and should be used only with a trusted snapshot.

## Backend differences and limitations

- Mysqloo requires the correct binary module for the server platform and Garry's Mod branch.
- SQLite has no reliable portable `DROP COLUMN` path in the supported compatibility layer. `lia.db.removeColumn` rejects on SQLite; MySQL uses `ALTER TABLE ... DROP COLUMN`.
- SQLite truncation is implemented as `DELETE FROM`; it does not reset the SQLite sequence. MySQL uses `TRUNCATE TABLE`.
- MySQL uses `INSERT IGNORE` and `ON DUPLICATE KEY UPDATE`; SQLite uses `INSERT OR IGNORE` and `INSERT OR REPLACE`.
- Upserts depend on a primary or unique key. Without one, both adapters insert a new row.
- Schema migration intentionally avoids destructive type changes and key rewrites. Administrators must implement those as explicit, backed-up migrations.
- Application code must treat database access as asynchronous. Synchronous `sql.Query` reads are unsupported outside the SQLite adapter.
