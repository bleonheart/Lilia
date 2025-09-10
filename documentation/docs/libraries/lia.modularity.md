# lia.modularity

## Overview
The `lia.modularity` library provides module loading and management functionality for Lilia. It handles loading modules from directories, managing dependencies, and providing module lifecycle management.

## Functions

### lia.module.load
**Purpose**: Loads a module from a specified path (Server only).

**Parameters**:
- `uniqueID` (string): Unique identifier for the module
- `path` (string): Path to the module directory
- `isSingleFile` (boolean): Whether the module is a single file
- `variable` (string): Variable name to use for the module (default: "MODULE")
- `skipSubmodules` (boolean): Whether to skip loading submodules

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Load a module from directory
lia.module.load("myModule", "gamemode/modules/myModule", false, "MODULE")

-- Load a single file module
lia.module.load("singleFile", "gamemode/modules/single.lua", true, "MODULE")

-- Load module with custom variable name
lia.module.load("customModule", "gamemode/modules/custom", false, "CUSTOM_MODULE")

-- Load module skipping submodules
lia.module.load("mainModule", "gamemode/modules/main", false, "MODULE", true)
```

### lia.module.initialize
**Purpose**: Initializes all modules in the correct order (Server only).

**Parameters**: None

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Initialize all modules
lia.module.initialize()

-- This is typically called during gamemode initialization
hook.Add("Initialize", "InitializeModules", function()
    lia.module.initialize()
end)
```

### lia.module.loadFromDir
**Purpose**: Loads all modules from a directory (Server only).

**Parameters**:
- `directory` (string): Directory path to load modules from
- `group` (string): Group type ("module" or "schema")
- `skip` (table): Table of module IDs to skip

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Load all modules from directory
lia.module.loadFromDir("gamemode/modules", "module")

-- Load modules skipping specific ones
local skipModules = {["disabledModule"] = true}
lia.module.loadFromDir("gamemode/modules", "module", skipModules)

-- Load schema modules
lia.module.loadFromDir("gamemode/schema", "schema")
```

### lia.module.get
**Purpose**: Gets a loaded module by its identifier (Server only).

**Parameters**:
- `identifier` (string): Module identifier

**Returns**: Module table or nil

**Realm**: Server

**Example Usage**:
```lua
-- Get a module
local module = lia.module.get("myModule")
if module then
    print("Module found:", module.name)
else
    print("Module not found")
end

-- Use module functions
local module = lia.module.get("inventory")
if module and module.ModuleLoaded then
    module:ModuleLoaded()
end
```

### lia.module.printDisabledModules
**Purpose**: Prints a list of disabled modules (Server only).

**Parameters**: None

**Returns**: None

**Realm**: Server

**Example Usage**:
```lua
-- Print disabled modules
lia.module.printDisabledModules()

-- This is typically called after module initialization
lia.module.initialize()
lia.module.printDisabledModules()
```
