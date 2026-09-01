local function fetchURL(url, onSuccess, onError)
    local hasChttp = util.IsBinaryModuleInstalled("chttp")
    if hasChttp then
        require("chttp")
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
    local function toParts(version)
        local parts = {}
        if not version then return parts end
        local value = type(version) == "number" and string.format("%.3f", version) or tostring(version)
        for number in value:gmatch("%d+") do
            parts[#parts + 1] = tonumber(number)
        end
        return parts
    end

    local localParts = toParts(localVersion)
    local remoteParts = toParts(remoteVersion)
    local length = math.max(#localParts, #remoteParts)
    for i = 1, length do
        local localPart = localParts[i] or 0
        local remotePart = remoteParts[i] or 0
        if localPart < remotePart then return -1 end
        if localPart > remotePart then return 1 end
    end
    return 0
end

local publicURL = "https://liliaframework.github.io/versioning/modules.json"
local privateURL = "https://bleonheart.github.io/modules.json"
local versionURL = "https://liliaframework.github.io/versioning/lilia.json"
local function readAbout(module)
    if not module.folder or not file.Exists(module.folder .. "/about.json", "LUA") then return nil end
    return util.JSONToTable(file.Read(module.folder .. "/about.json", "LUA") or "")
end

local function getValue(data, ...)
    for i = 1, select("#", ...) do
        local value = data[select(i, ...)]
        if value ~= nil then return value end
    end
end

local function getRemoteAboutURL(source, uniqueID)
    source = tostring(source)
    if source:find("%s", 1, true) then return string.format(source, uniqueID) end
    if source:find("{module}", 1, true) then return source:gsub("{module}", uniqueID) end
    if source:sub(-5):lower() == ".json" then return source end
    return source:gsub("/+$", "") .. "/" .. uniqueID .. "/about.json"
end

local function logError(message)
    MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
    MsgC(Color(0, 255, 255), message, "\n")
end

local function reportUpdate(module, remote, isPrivate)
    local remoteVersion = getValue(remote, "version", "Version")
    local localVersion = getValue(module.about, "version", "Version")
    if not remoteVersion then
        logError(string.format("Module '%s' has no remote version info", module.name))
    elseif localVersion and versionCompare(localVersion, remoteVersion) < 0 then
        MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
        local message = isPrivate and string.format("Module '%s' is outdated, please report back to the author", module.name) or string.format("Module '%s' is outdated. Update to version %s", module.name, remoteVersion)
        MsgC(Color(0, 255, 255), message, "\n")
    end
end

local function processManifest(modules, remoteData, isPrivate)
    for _, module in ipairs(modules) do
        local match
        for _, remote in ipairs(remoteData) do
            if remote.versionID == module.versionID then
                match = remote
                break
            end
        end

        if not match then
            logError(string.format("Module with uniqueID '%s' not found", module.versionID))
        else
            reportUpdate(module, match, isPrivate)
        end
    end
end

function lia.loader.checkForUpdates()
    local publicModules = {}
    local privateModules = {}
    local sourcedModules = {}
    for _, module in pairs(lia.module.list) do
        local about = readAbout(module)
        if about then
            local versionID = getValue(about, "versionID", "VersionID")
            module.about = about
            module.versionID = versionID
            module.name = getValue(about, "name", "Name") or module.name
            if versionID then
                if getValue(about, "source", "Source") then
                    sourcedModules[#sourcedModules + 1] = module
                elseif string.StartsWith(versionID, "public_") then
                    publicModules[#publicModules + 1] = module
                elseif string.StartsWith(versionID, "private_") then
                    privateModules[#privateModules + 1] = module
                end
            end
        end
    end

    local function fetchManifest(url, modules, isPrivate, label)
        if #modules == 0 then return end
        fetchURL(url, function(body, code)
            if code ~= 200 then
                logError(string.format("Error fetching %s module list (HTTP %s)", label, code))
                return
            end

            local remote = util.JSONToTable(body)
            if not istable(remote) then
                logError(string.format("Error parsing %s module data", label))
                return
            end

            processManifest(modules, remote, isPrivate)
        end, function(err) logError(string.format("Error fetching %s module list: %s", label, err)) end)
    end

    fetchManifest(publicURL, publicModules, false, "public")
    fetchManifest(privateURL, privateModules, true, "private")
    for _, module in ipairs(sourcedModules) do
        local source = getValue(module.about, "source", "Source")
        fetchURL(getRemoteAboutURL(source, module.uniqueID), function(body, code)
            if code ~= 200 then
                logError(string.format("Error fetching module '%s' from source (HTTP %s)", module.name, code))
                return
            end

            local remote = util.JSONToTable(body)
            if not istable(remote) then
                logError(string.format("Error parsing module '%s' source data", module.name))
                return
            end

            local isPrivate = string.StartsWith(module.versionID or "", "private_")
            if remote[1] then
                processManifest({module}, remote, isPrivate)
            else
                reportUpdate(module, remote, isPrivate)
            end
        end, function(err) logError(string.format("Error fetching module '%s' source: %s", module.name, err)) end)
    end

    fetchURL(versionURL, function(body, code)
        if code ~= 200 then
            logError(string.format("Error fetching framework version (HTTP %s)", code))
            return
        end

        local remote = util.JSONToTable(body)
        if not remote or not remote.version or not GAMEMODE.version then
            logError("Error reading framework version data")
            return
        end

        if versionCompare(GAMEMODE.version, remote.version) < 0 then
            local localNumber, remoteNumber = tonumber(GAMEMODE.version), tonumber(remote.version)
            if localNumber and remoteNumber and remoteNumber - localNumber > 0 then
                MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
                MsgC(Color(0, 255, 255), string.format("Your Lilia installation is %s versions behind.\n", math.Round(remoteNumber - localNumber, 3)))
            end

            MsgC(Color(83, 143, 239), "[Lilia] ", "[Updater] ")
            MsgC(Color(0, 255, 255), "Framework is outdated. Restart the Server to update it\n")
        end
    end, function(err) logError(string.format("Error fetching framework version: %s", err)) end)
end

concommand.Add("lia_check_updates", function(client)
    lia.debug("[Permissions]", "Permission Check for concommand lia_check_updates", "isValidPlayer=", tostring(IsValid(client)), "isSuperAdmin=", tostring(IsValid(client) and client:IsSuperAdmin() or true), "finalResult=", tostring(not IsValid(client) or client:IsSuperAdmin()))
    if IsValid(client) and not client:IsSuperAdmin() then
        client:notifyError("You do not have permission to use this command.")
        return
    end

    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Checking for updates..." .. "\n")
    lia.loader.checkForUpdates()
end)