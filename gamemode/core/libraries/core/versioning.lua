local hasChttp = util.IsBinaryModuleInstalled("chttp")
if hasChttp then require("chttp") end
local function fetchURL(url, onSuccess, onError)
    if hasChttp then
        CHTTP({
            url = url,
            method = "GET",
            success = function(code, body) onSuccess(body, code) end,
            failed = function(err) onError(err) end
        })
    else
        http.Fetch(url, function(body, _, _, code) onSuccess(body, code) end, function(err) onError(err) end)
    end
end

local function versionCompare(localVersion, remoteVersion)
    local function toParts(v)
        local parts = {}
        if not v then return parts end
        local str = type(v) == "number" and string.format("%.3f", v) or tostring(v)
        for num in str:gmatch("%d+") do
            table.insert(parts, tonumber(num))
        end
        return parts
    end

    local lParts = toParts(localVersion)
    local rParts = toParts(remoteVersion)
    local len = math.max(#lParts, #rParts)
    for i = 1, len do
        local l = lParts[i] or 0
        local r = rParts[i] or 0
        if l < r then return -1 end
        if l > r then return 1 end
    end
    return 0
end

local publicURL = "https://liliaframework.github.io/versioning/modules.json"
local privateURL = "https://bleonheart.github.io/modules.json"
local versionURL = "https://liliaframework.github.io/versioning/lilia.json"
function lia.loader.checkForUpdates()
    local publicModules = {}
    local privateModules = {}
    for _, mod in pairs(lia.module.list) do
        if mod.versionID then
            if string.StartsWith(mod.versionID, "public_") then
                publicModules[#publicModules + 1] = mod
            elseif string.StartsWith(mod.versionID, "private_") then
                privateModules[#privateModules + 1] = mod
            end
        end
    end

    local function processModuleUpdates(modules, remoteData, isPrivate)
        for _, mod in ipairs(modules) do
            local match
            for _, m in ipairs(remoteData) do
                if m.versionID == mod.versionID then
                    match = m
                    break
                end
            end

            if not match then
                MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
                MsgC(Color(0, 255, 255), string.format("Module with uniqueID '%s' not found", mod.versionID), "\n")
            elseif not match.version then
                MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
                MsgC(Color(0, 255, 255), string.format("Module '%s' has no remote version info", mod.name), "\n")
            elseif mod.version and versionCompare(mod.version, match.version) < 0 then
                MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
                local message = isPrivate and string.format("Module '%s' is outdated, please report back to the author", mod.name) or string.format("Module '%s' is outdated. Update to version %s", mod.name, match.version)
                MsgC(Color(0, 255, 255), message, "\n")
            end
        end
    end

    local function logError(message)
        MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
        MsgC(Color(0, 255, 255), message, "\n")
    end

    local function processResponse(body, code, modules, isPrivate, label)
        if code ~= 200 then
            logError(string.format("Error fetching %s (HTTP %s)", label, code))
            return
        end

        local remote = util.JSONToTable(body)
        if not remote then
            logError(string.format("Error parsing %s", label))
            return
        end

        processModuleUpdates(modules, remote, isPrivate)
    end

    if #publicModules > 0 then fetchURL(publicURL, function(body, code) processResponse(body, code, publicModules, false, "module data") end, function(err) logError(string.format("Error fetching module list: %s", err)) end) end
    if #privateModules > 0 then fetchURL(privateURL, function(body, code) processResponse(body, code, privateModules, true, "private module data") end, function(err) logError(string.format("Error fetching private module list: %s", err)) end) end
    fetchURL(versionURL, function(body, code)
        if code ~= 200 then
            logError(string.format("Error fetching framework version (HTTP %s)", code))
            return
        end

        local remote = util.JSONToTable(body)
        if not remote or not remote.version then
            logError("Error parsing framework version data")
            return
        end

        local localVersion = GAMEMODE.version
        if not localVersion then
            logError("Error reading local framework version")
            return
        end

        if versionCompare(localVersion, remote.version) < 0 then
            local localNum, remoteNum = tonumber(localVersion), tonumber(remote.version)
            if localNum and remoteNum then
                local diff = math.Round(remoteNum - localNum, 3)
                if diff > 0 then
                    MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
                    MsgC(Color(0, 255, 255), string.format("Your Lilia installation is %s versions behind.", diff), "\n")
                end
            end

            MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
            MsgC(Color(0, 255, 255), "Framework is outdated. Restart the Server to update it", "\n")
        end
    end, function(err) logError(string.format("Error fetching framework version: %s", err)) end)
end