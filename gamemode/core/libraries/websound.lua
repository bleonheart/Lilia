lia.websound = lia.websound or {}
local baseDir = "lilia/websounds/"
local cache = {}
local urlMap = {}
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
    if not fileData or #fileData == 0 then
        print("[ERROR] WebSound: File data is empty")
        return false, "empty file"
    end

    local fileSize = #fileData
    if fileSize < 44 then
        print("[ERROR] WebSound: File too small to be a valid sound file:", fileSize, "bytes")
        return false, "file too small"
    end

    if fileSize > 50 * 1024 * 1024 then
        print("[ERROR] WebSound: File too large:", fileSize, "bytes")
        return false, "file too large"
    end

    local ext = filePath:match("%.([^%.]+)$"):lower()
    if ext == "wav" then
        if not fileData:find("^RIFF") or not fileData:find("WAVE") then
            print("[ERROR] WebSound: Invalid WAV file header")
            return false, "invalid wav header"
        end
    elseif ext == "mp3" then
        if not fileData:find("^ID3") and not fileData:find("\255\251") and not fileData:find("\255\250") then
            print("[ERROR] WebSound: File doesn't appear to be a valid MP3")
            return false, "invalid mp3 format"
        end
    elseif ext == "ogg" then
        if not fileData:find("^OggS") then
            print("[ERROR] WebSound: Invalid OGG file header")
            return false, "invalid ogg header"
        end
    end
    return true
end

function lia.websound.register(name, url, cb)
    if isstring(url) then urlMap[url] = name end
    cache[name] = nil
    local savePath = baseDir .. name
    local function finalize(fromCache)
        local path = buildPath(savePath)
        cache[name] = path
        if cb then cb(path, fromCache) end
        if not fromCache then hook.Run("WebSoundDownloaded", name, path) end
    end

    http.Fetch(url, function(body)
        local isValid, validationError = validateSoundFile(name, body)
        if not isValid then
            print("[ERROR] WebSound: Downloaded file failed validation:", validationError)
            if cb then cb(nil, false, "File validation failed: " .. validationError) end
            return
        end

        ensureDir(savePath:match("(.+)/[^/]+$") or baseDir)
        file.Write(savePath, body)
        finalize(false)
    end, function(err)
        print("[ERROR] WebSound: Failed to download", url, "- error:", err)
        if file.Exists(savePath, "DATA") then
            local existingFileData = file.Read(savePath, "DATA")
            if existingFileData then
                local isValid, validationError = validateSoundFile(savePath, existingFileData)
                if isValid then
                    finalize(true)
                else
                    print("[ERROR] WebSound: Cached file is also invalid:", validationError)
                    file.Delete(savePath)
                    if cb then cb(nil, false, "Cached file invalid: " .. validationError) end
                end
            else
                print("[ERROR] WebSound: Could not read cached file")
                if cb then cb(nil, false, "Could not read cached file") end
            end
        elseif cb then
            cb(nil, false, err)
        end
    end)
end

function lia.websound.get(name)
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
        if path:find("^https?://") then
            local name = urlMap[path]
            if not name then
                local ext = path:match("%.([%w]+)$") or "mp3"
                name = util.CRC(path) .. "." .. ext
                urlMap[path] = name
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
            if path:find("^data/lilia/websounds/") then
                if path:match("%.wav$") then
                    origPlayFile(path, mode or "", function(channel, errorCode, errorString)
                        if IsValid(channel) then
                            if cb then cb(channel, errorCode, errorString) end
                            return
                        end

                        origPlayFile(path, "", function(channel2, errorCode2, errorString2)
                            if IsValid(channel2) then
                                if cb then cb(channel2, errorCode2, errorString2) end
                                return
                            end

                            origPlayFile(path, "mono", function(channel3, errorCode3, errorString3)
                                if IsValid(channel3) then
                                    if cb then cb(channel3, errorCode3, errorString3) end
                                else
                                    print("[ERROR] WebSound: All WAV playback methods failed")
                                    print("[ERROR] WebSound: Error codes:", errorCode, errorCode2, errorCode3)
                                    print("[ERROR] WebSound: Error strings:", errorString, errorString2, errorString3)
                                    if cb then cb(channel3, errorCode3, errorString3) end
                                end
                            end)
                        end)
                    end)
                else
                    return origPlayFile(path, mode or "", cb)
                end
                return
            end

            local localPath = lia.websound.get(path)
            if localPath then
                return origPlayFile(localPath, mode or "", cb)
            else
                local searchName = path:match("([^/]+)$") or path
                local files = file.Find(baseDir .. "**", "DATA")
                for _, fileName in ipairs(files) do
                    if fileName:find(searchName) or fileName:find("dogeatdog") then
                        local fullPath = buildPath(baseDir .. fileName)
                        return origPlayFile(fullPath, mode or "", cb)
                    end
                end

                if cb then cb(nil, nil, "file not found") end
                return
            end
        end
    end
    return origPlayFile(path, mode, cb)
end

local origPlayURL = sound.PlayURL
function sound.PlayURL(url, mode, cb)
    if isstring(url) and url:find("^https?://") then
        local name = urlMap[url]
        if not name then
            local ext = url:match("%.([%w]+)$") or "mp3"
            name = util.CRC(url) .. "." .. ext
            urlMap[url] = name
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