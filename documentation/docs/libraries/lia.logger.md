# lia.logger

## Overview
The `lia.logger` library provides comprehensive logging functionality for Lilia, allowing the gamemode to track various events and actions. It supports different log types, categories, and provides database storage for log entries.

## Functions

### lia.log.addType
**Purpose**: Adds a new log type to the logging system.

**Parameters**:
- `logType` (string): Log type identifier
- `func` (function): Function that generates the log message
- `category` (string): Category for the log type

**Returns**: None

**Realm**: Shared

**Example Usage**:
```lua
-- Add custom log type
lia.log.addType("customAction", function(client, action, target)
    return L("logCustomAction", client:Name(), action, target)
end, "Custom")

-- Add admin action log
lia.log.addType("adminAction", function(client, action, details)
    return L("logAdminAction", client:Name(), action, details)
end, "Admin")
```

### lia.log.getString
**Purpose**: Gets the formatted log string for a specific log type.

**Parameters**:
- `client` (Player): Client who performed the action
- `logType` (string): Log type identifier
- `...` (any): Additional arguments for the log function

**Returns**: 
- `logString` (string): Formatted log message
- `category` (string): Log category

**Realm**: Shared

**Example Usage**:
```lua
-- Get log string for character creation
local logString, category = lia.log.getString(client, "charCreate", character)
if logString then
    print("Log message:", logString)
    print("Category:", category)
end

-- Get log string for item interaction
local logString, category = lia.log.getString(client, "itemTake", item)
if logString then
    print("Item log:", logString)
end
```

### lia.log.add
**Purpose**: Adds a log entry to the database and prints it to console.

**Parameters**:
- `client` (Player): Client who performed the action
- `logType` (string): Log type identifier
- `...` (any): Additional arguments for the log function

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Log character creation
lia.log.add(client, "charCreate", character)

-- Log item interaction
lia.log.add(client, "itemTake", item)

-- Log admin action
lia.log.add(client, "adminAction", "kick", target)

-- Log with multiple arguments
lia.log.add(client, "itemTransfer", itemName, fromID, toID)
```
