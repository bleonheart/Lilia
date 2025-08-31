lia.websound = lia.websound or {}
lia.websound.stored = lia.websound.stored or {}
local baseDir = "lilia/websounds/cachedpath/"
local cache = {}
local urlMap = {}
local function normalizeName(name)
    if not isstring(name) then return name end
    name = name:gsub("\\", "/")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if string.StartWith(name, "/") then name = name:sub(2) end
    if string.StartWith(name, "sound/") then name = name:sub(7) end
    return name
end

local function ensureDir(p)
    local parts = string.Explode("/", p)
    local cur = ""
    for _, v in ipairs(parts) do
        cur = cur == "" and v or cur .. "/" .. v
        if not file.Exists(cur, "DATA") then file.CreateDir(cur) end
    end
end

local function buildPath(p)
    return "data/" .. p
end

local function validateSoundFile(filePath, fileData)
    if not fileData or #fileData == 0 then return false, "empty file" end
    local fileSize = #fileData
    if fileSize < 44 then return false, "file too small" end
    if fileSize > 50 * 1024 * 1024 then return false, "file too large" end
    local extMatch = filePath:match("%.([^%.]+)$")
    if not extMatch then return false, "no file extension" end
    local ext = extMatch:lower()
    if ext == "wav" then
        if not fileData:find("^RIFF") or not fileData:find("WAVE") then return false, "invalid wav header" end
    elseif ext == "mp3" then
        if not fileData:find("^ID3") and not fileData:find("\255\251") and not fileData:find("\255\250") then return false, "invalid mp3 format" end
    elseif ext == "ogg" then
        if not fileData:find("^OggS") then return false, "invalid ogg header" end
    end
    return true
end

function lia.websound.download(name, url, cb)
    if not isstring(name) then return end
    name = normalizeName(name)
    local u = url or lia.websound.stored[name]
    if not u or u == "" then
        if cb then cb(nil, false, "no url") end
        return
    end

    if isstring(u) then urlMap[u] = name end
    cache[name] = nil
    local savePath = baseDir .. name
    local function finalize(fromCache)
        local path = buildPath(savePath)
        cache[name] = path
        if cb then cb(path, fromCache) end
        if not fromCache then hook.Run("WebSoundDownloaded", name, path) end
    end

    http.Fetch(u, function(body)
        local isValid, validationError = validateSoundFile(name, body)
        if not isValid then
            if cb then cb(nil, false, "File validation failed: " .. validationError) end
            return
        end

        ensureDir(savePath:match("(.+)/[^/]+$") or baseDir)
        file.Write(savePath, body)
        finalize(false)
    end, function(err)
        if file.Exists(savePath, "DATA") then
            local existingFileData = file.Read(savePath, "DATA")
            if existingFileData then
                local isValid, validationError = validateSoundFile(savePath, existingFileData)
                if isValid then
                    finalize(true)
                else
                    file.Delete(savePath)
                    if cb then cb(nil, false, "Cached file invalid: " .. validationError) end
                end
            else
                if cb then cb(nil, false, "Could not read cached file") end
            end
        elseif cb then
            cb(nil, false, err)
        end
    end)
end

function lia.websound.register(name, url, cb)
    name = normalizeName(name)
    lia.websound.stored[name] = url
    return lia.websound.download(name, url, cb)
end

function lia.websound.get(name)
    name = normalizeName(name)
    local key = urlMap[name] or name
    if cache[key] then return cache[key] end
    local savePath = baseDir .. key
    if file.Exists(savePath, "DATA") then
        local path = buildPath(savePath)
        cache[key] = path
        return path
    end
    return nil
end

local origPlayFile = sound.PlayFile
function sound.PlayFile(path, mode, cb)
    if isstring(path) then
        path = normalizeName(path)
        if path:find("^https?://") then
            local name = urlMap[path]
            if not name then
                local ext = path:match("%.([%w]+)$") or "mp3"
                name = util.CRC(path) .. "." .. ext
                urlMap[path] = name
            end

            local cachedPath = lia.websound.get(name)
            if cachedPath then
                origPlayFile(cachedPath, mode or "", cb)
                return
            end

            lia.websound.register(name, path, function(localPath)
                if localPath then
                    origPlayFile(localPath, mode or "", cb)
                elseif cb then
                    cb(nil, nil, "failed")
                end
            end)
            return
        else
            if path:find("^lilia/websounds/") then
                if path:match("%.wav$") then
                    local reqMode = mode or ""
                    local wants3d = reqMode:find("3d", 1, true) ~= nil
                    local attempts = {}
                    local seen = {}
                    local function add(m)
                        if m and m ~= "" and not seen[m] then
                            seen[m] = true
                            table.insert(attempts, m)
                        end
                    end

                    if wants3d then
                        add(reqMode)
                        add("mono 3d")
                        add("3d")
                    else
                        add(reqMode)
                        table.insert(attempts, "")
                        add("mono")
                    end

                    local function tryNext(i, lastErrCode, lastErrStr)
                        local m = attempts[i]
                        if not m then
                            if cb then cb(nil, lastErrCode, lastErrStr or "failed") end
                            return
                        end

                        origPlayFile(path, m, function(ch, errCode, errStr)
                            if IsValid(ch) then
                                if cb then cb(ch, errCode, errStr) end
                            else
                                tryNext(i + 1, errCode, errStr)
                            end
                        end)
                    end

                    tryNext(1)
                else
                    return origPlayFile(path, mode or "", cb)
                end
                return
            end

            -- Only handle explicit lilia/websounds/ paths
            if path:find("^lilia/websounds/") then
                local webPath = path:gsub("^lilia/websounds/", "")
                local localPath = lia.websound.get(webPath)
                if localPath then
                    return origPlayFile(localPath, mode or "", cb)
                else
                    if cb then cb(nil, nil, "file not found") end
                    return
                end
            end
        end
    end
    return origPlayFile(path, mode, cb)
end

local origPlayURL = sound.PlayURL
function sound.PlayURL(url, mode, cb)
    if isstring(url) and url:find("^https?://") then
        local reqMode = mode or ""
        if reqMode:find("3d", 1, true) ~= nil then
            origPlayURL(url, reqMode, cb)
            local name = urlMap[url]
            if not name then
                local ext = url:match("%.([%w]+)$") or "mp3"
                name = util.CRC(url) .. "." .. ext
                urlMap[url] = name
            end

            lia.websound.register(name, url)
            return
        end

        local name = urlMap[url]
        if not name then
            local ext = url:match("%.([%w]+)$") or "mp3"
            name = util.CRC(url) .. "." .. ext
            urlMap[url] = name
        end

        local cachedPath = lia.websound.get(name)
        if cachedPath then
            origPlayFile(cachedPath, mode or "", cb)
            return
        end

        lia.websound.register(name, url, function(localPath)
            if localPath then
                origPlayFile(localPath, mode or "", cb)
            elseif cb then
                cb(nil, nil, "failed")
            end
        end)
        return
    end
    return origPlayURL(url, mode, cb)
end

concommand.Add("lia_saved_sounds", function()
    local files = file.Find(baseDir .. "*", "DATA")
    if not files or #files == 0 then return end
    local f = vgui.Create("DFrame")
    f:SetTitle(L("webSoundsTitle"))
    f:SetSize(ScrW() * 0.6, ScrH() * 0.6)
    f:Center()
    f:MakePopup()
    local scroll = vgui.Create("DScrollPanel", f)
    scroll:Dock(FILL)
    local layout = vgui.Create("DIconLayout", scroll)
    layout:Dock(FILL)
    layout:SetSpaceX(4)
    layout:SetSpaceY(4)
    for _, fn in ipairs(files) do
        local btn = layout:Add("DButton")
        btn:SetText(fn)
        btn:SetSize(200, 20)
        btn.DoClick = function() sound.PlayFile(buildPath(baseDir .. fn), "", function(chan) if chan then chan:Play() end end) end
    end
end)

concommand.Add("lia_wipe_sounds", function()
    local files = file.Find(baseDir .. "*", "DATA")
    for _, fn in ipairs(files) do
        file.Delete(baseDir .. fn)
    end

    cache = {}
    urlMap = {}
    MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[WebSound]", Color(255, 255, 255), " " .. L("webSoundCacheCleared") .. "\n")
end)

concommand.Add("lia_validate_sounds", function()
    print("[WebSound] Validating all cached sound files...")
    local files = file.Find(baseDir .. "**", "DATA")
    local validCount = 0
    local invalidCount = 0
    local corruptedFiles = {}
    for _, fileName in ipairs(files) do
        local filePath = baseDir .. fileName
        local fileData = file.Read(filePath, "DATA")
        if fileData then
            local isValid, errorMsg = validateSoundFile(fileName, fileData)
            if isValid then
                validCount = validCount + 1
            else
                invalidCount = invalidCount + 1
                table.insert(corruptedFiles, fileName)
                print(string.format("[WebSound] ✗ Invalid: %s - %s", fileName, errorMsg))
            end
        else
            invalidCount = invalidCount + 1
            table.insert(corruptedFiles, fileName)
            print(string.format("[WebSound] ✗ Could not read: %s", fileName))
        end
    end

    print(string.format("[WebSound] Validation complete: %d valid, %d invalid", validCount, invalidCount))
    if #corruptedFiles > 0 then
        print("[WebSound] Corrupted files found:")
        for _, fileName in ipairs(corruptedFiles) do
            print(string.format("[WebSound]  - %s", fileName))
        end

        print("[WebSound] Use 'lia_cleanup_sounds' to remove corrupted files")
    end
end)

concommand.Add("lia_cleanup_sounds", function()
    print("[WebSound] Cleaning up corrupted sound files...")
    local files = file.Find(baseDir .. "**", "DATA")
    local removedCount = 0
    for _, fileName in ipairs(files) do
        local filePath = baseDir .. fileName
        local fileData = file.Read(filePath, "DATA")
        if fileData then
            local isValid, errorMsg = validateSoundFile(fileName, fileData)
            if not isValid then
                file.Delete(filePath)
                removedCount = removedCount + 1
                print(string.format("[WebSound] Removed corrupted file: %s (%s)", fileName, errorMsg))
            end
        else
            file.Delete(filePath)
            removedCount = removedCount + 1
            print(string.format("[WebSound] Removed unreadable file: %s", fileName))
        end
    end

    for fileName, _ in pairs(cache) do
        local savePath = baseDir .. fileName
        if not file.Exists(savePath, "DATA") then
            cache[fileName] = nil
            print(string.format("[WebSound] Removed from cache: %s", fileName))
        end
    end

    print(string.format("[WebSound] Cleanup complete: %d files removed", removedCount))
end)

concommand.Add("lia_list_sounds", function()
    print("[WebSound] Listing all files in websounds directory:")
    local files = file.Find(baseDir .. "**", "DATA")
    if #files == 0 then
        print("[WebSound] No files found in websounds directory")
        return
    end

    for _, fileName in ipairs(files) do
        local fileSize = file.Size(baseDir .. fileName, "DATA")
        print(string.format("[WebSound] %s (%d bytes)", fileName, fileSize))
    end
end)

ensureDir(baseDir)