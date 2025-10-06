-- Documentation Verification Helper Script
-- This script helps verify documentation against code implementation
local function readFile(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

local function findFiles(dir, pattern)
    local files = {}
    local command = 'dir "' .. dir .. '" /b /s'
    if pattern then command = command .. ' | findstr "' .. pattern .. '"' end
    local pipe = io.popen(command)
    for line in pipe:lines() do
        table.insert(files, line)
    end

    pipe:close()
    return files
end

local function extractFunctions(content)
    local functions = {}
    -- Look for function definitions in Lua code
    for func in content:gmatch("function%s+([%w_.:]+)%s*%(") do
        table.insert(functions, func)
    end

    -- Look for local function definitions
    for func in content:gmatch("local%s+function%s+([%w_.:]+)%s*%(") do
        table.insert(functions, func)
    end
    return functions
end

local function extractHooks(content)
    local hooks = {}
    -- Look for hook.Add calls
    for hook in content:gmatch('hook%.Add%s*%(%s*"([^"]+)"') do
        table.insert(hooks, hook)
    end
    return hooks
end

local function verifyDocumentation(docPath, codePaths)
    print("=== Verifying Documentation ===")
    print("Documentation: " .. docPath)
    -- Read documentation
    local docContent = readFile(docPath)
    if not docContent then
        print("ERROR: Could not read documentation file")
        return false
    end

    print("\n--- Documentation Analysis ---")
    -- Extract mentioned functions from documentation
    local documentedFunctions = {}
    for func in docContent:gmatch("`([%w_.:]+)%s*%(") do
        table.insert(documentedFunctions, func)
    end

    print("Documented functions: " .. #documentedFunctions)
    -- Extract mentioned hooks from documentation
    local documentedHooks = {}
    for hook in docContent:gmatch('"([%w_]+)"%s+hook') do
        table.insert(documentedHooks, hook)
    end

    print("Documented hooks: " .. #documentedHooks)
    -- Check code files
    local implementedFunctions = {}
    local implementedHooks = {}
    for _, codePath in ipairs(codePaths) do
        print("\nChecking code: " .. codePath)
        local codeContent = readFile(codePath)
        if codeContent then
            local funcs = extractFunctions(codeContent)
            local hooks = extractHooks(codeContent)
            for _, func in ipairs(funcs) do
                table.insert(implementedFunctions, func)
            end

            for _, hook in ipairs(hooks) do
                table.insert(implementedHooks, hook)
            end

            print("  Functions found: " .. #funcs)
            print("  Hooks found: " .. #hooks)
        else
            print("  WARNING: Could not read code file")
        end
    end

    print("\n--- Verification Results ---")
    print("Total implemented functions: " .. #implementedFunctions)
    print("Total implemented hooks: " .. #implementedHooks)
    -- Check for undocumented functions
    local undocumentedFunctions = {}
    for _, func in ipairs(implementedFunctions) do
        local found = false
        for _, docFunc in ipairs(documentedFunctions) do
            if func == docFunc then
                found = true
                break
            end
        end

        if not found then table.insert(undocumentedFunctions, func) end
    end

    if #undocumentedFunctions > 0 then
        print("\nUNDOCUMENTED FUNCTIONS:")
        for _, func in ipairs(undocumentedFunctions) do
            print("  - " .. func)
        end
    else
        print("\nAll implemented functions are documented!")
    end

    -- Check for undocumented hooks
    local undocumentedHooks = {}
    for _, hook in ipairs(implementedHooks) do
        local found = false
        for _, docHook in ipairs(documentedHooks) do
            if hook == docHook then
                found = true
                break
            end
        end

        if not found then table.insert(undocumentedHooks, hook) end
    end

    if #undocumentedHooks > 0 then
        print("\nUNDOCUMENTED HOOKS:")
        for _, hook in ipairs(undocumentedHooks) do
            print("  - " .. hook)
        end
    else
        print("All implemented hooks are documented!")
    end
    return true
end

-- Example usage
local function main()
    print("Lilia Documentation Verifier")
    print("Usage: lua documentation_verifier.lua <doc_file> <code_file1> [code_file2] ...")
    local args = {...}
    if #args < 2 then
        print("Error: Need at least documentation file and one code file")
        return
    end

    local docFile = args[1]
    local codeFiles = {}
    for i = 2, #args do
        table.insert(codeFiles, args[i])
    end

    verifyDocumentation(docFile, codeFiles)
end

-- If run directly, show usage
if #arg > 0 then main() end
return {
    verifyDocumentation = verifyDocumentation,
    extractFunctions = extractFunctions,
    extractHooks = extractHooks,
    readFile = readFile,
    findFiles = findFiles
}
