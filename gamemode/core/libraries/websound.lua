lia.websound = lia.websound or {}
local ip = string.Replace(string.Replace(game.GetIPAddress() or "unknown", ":", "_"), "%.", "_")
local gamemode = engine.ActiveGamemode() or "unknown"
local baseDir = "lilia/sounds/" .. ip .. "/" .. gamemode .. "/"
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
        ensureDir(baseDir)
        file.Write(savePath, body)
        finalize(false)
    end, function(err)
        if file.Exists(savePath, "DATA") then
            finalize(true)
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
            local localPath = lia.websound.get(path)
            if localPath then return origPlayFile(localPath, mode or "", cb) end
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

ensureDir(baseDir)
hook.Add("EntityEmitSound", "liaWebSound", function(data)
    local soundName = data.OriginalSoundName or data.SoundName
    if not isstring(soundName) then return end
    local function play(path)
        sound.PlayFile(path, "3d", function(chan)
            if not chan then return end
            local ent = data.Entity
            if IsValid(ent) and chan.FollowEntity then
                chan:FollowEntity(ent)
            elseif data.Pos then
                chan:SetPos(data.Pos)
            end

            if data.Volume then chan:SetVolume(math.Clamp(data.Volume, 0, 1)) end
            if data.Pitch and chan.SetPlaybackRate then chan:SetPlaybackRate(data.Pitch / 100) end
            chan:Play()
        end)
    end

    if soundName:find("^https?://") then
        play(soundName)
        return true
    end

    local localPath = lia.websound.get(soundName)
    if localPath then
        play(localPath)
        return true
    end
end)