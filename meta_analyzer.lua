-- Meta Method Analyzer for Garry's Mod Lilia Framework
-- This script analyzes meta methods in the specified directories and checks for their usage

-- Since we can't run Lua directly, this script will be used as a template
-- We'll use the available search tools to extract and analyze meta methods

-- The approach will be:
-- 1. Use grep to find meta method definitions
-- 2. Extract method names from the results
-- 3. Search for usage of each method across the codebase
-- 4. Generate a report of unused methods

print("Meta Method Analyzer Template")
print("This script should be run in a Lua environment with file system access")
print("Alternatively, use the search tools available in the current environment")

-- For demonstration, here are the key patterns we would search for:
print("\n1. Meta method definition patterns:")
print("   - function metaTable:methodName(")
print("   - metaTable.methodName = function")
print("\n2. Method usage patterns:")
print("   - :methodName(")
print("   - .methodName(")
print("   - .methodName =")
