local hasChttp = util.IsBinaryModuleInstalled("chttp")
local publicURL = "https://raw.githubusercontent.com/LiliaFramework/Modules/refs/heads/gh-pages/modules.json"
local privateURL = "https://raw.githubusercontent.com/bleonheart/bleonheart.github.io/main/modules.json"
local versionURL = "https://raw.githubusercontent.com/LiliaFramework/LiliaFramework.github.io/main/version.json"
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
        for num in tostring(v):gmatch("%d+") do
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

local function checkPublicModules()
    fetchURL(publicURL, function(body, code)
        if code ~= 200 then
            lia.updater(L("moduleListHTTPError", code))
            return
        end

        local remote = util.JSONToTable(body)
        if not remote then
            lia.updater(L("moduleDataParseError"))
            return
        end

        for _, info in ipairs(lia.module.versionChecks) do
            local match
            for _, m in ipairs(remote) do
                if m.public_uniqueID == info.uniqueID then
                    match = m
                    break
                end
            end

            if not match then
                lia.updater(L("moduleUniqueIDNotFound", info.uniqueID))
            elseif not match.version then
                lia.updater(L("moduleNoRemoteVersion", info.name))
            elseif info.version and versionCompare(info.version, match.version) < 0 then
                lia.updater(L("moduleOutdated", info.name, match.version))
            end
        end
    end, function(err) lia.updater(L("moduleListError", err)) end)
end

local function checkPrivateModules()
    fetchURL(privateURL, function(body, code)
        if code ~= 200 then
            lia.updater(L("privateModuleListHTTPError", code))
            return
        end

        local remote = util.JSONToTable(body)
        if not remote then
            lia.updater(L("privateModuleDataParseError"))
            return
        end

        for _, info in ipairs(lia.module.privateVersionChecks) do
            for _, m in ipairs(remote) do
                if m.private_uniqueID == info.uniqueID and m.version and info.version and versionCompare(info.version, m.version) < 0 then
                    lia.updater(L("privateModuleOutdated", info.name))
                    break
                end
            end
        end
    end, function(err) lia.updater(L("privateModuleListError", err)) end)
end

local function checkFrameworkVersion()
    fetchURL(versionURL, function(body, code)
        if code ~= 200 then
            lia.updater(L("frameworkVersionHTTPError", code))
            return
        end

        local remote = util.JSONToTable(body)
        if not remote or not remote.version then
            lia.updater(L("frameworkVersionDataParseError"))
            return
        end

        local localVersion = GM.version
        if not localVersion then
            lia.updater(L("localFrameworkVersionError"))
            return
        end

        if versionCompare(localVersion, remote.version) < 0 then
            local localNum, remoteNum = tonumber(localVersion), tonumber(remote.version)
            if localNum and remoteNum then
                local diff = remoteNum - localNum
                diff = math.Round(diff, 3)
                if diff > 0 then lia.updater(L("frameworkBehindCount", diff)) end
            end

            lia.updater(L("frameworkOutdated"))
        end
    end, function(err) lia.updater(L("frameworkVersionError", err)) end)
end

if hasChttp then require("chttp") end