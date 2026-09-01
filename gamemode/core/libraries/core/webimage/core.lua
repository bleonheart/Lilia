lia.webcontent = lia.webcontent or {}
local baseDir = "lilia/webimages/"
local pending = {}
local registered = {}
local resolved = {}
local originalMaterial = Material
local dimage = vgui.GetControlTable("DImage")
local originalSetImage = dimage.SetImage
local function normalizeName(name)
    if not isstring(name) or name == "" then return nil end
    name = name:gsub("\\", "/")
    name = name:gsub("^data/", "")
    name = name:gsub("^lilia/webimages/", "")
    name = name:gsub("^/+", "")
    name = name:gsub("/+", "/")
    if name == "" or name:find(":", 1, true) or name:find("%z") then return nil end
    for _, part in ipairs(string.Explode("/", name)) do
        if part == ".." then return nil end
    end
    return name
end

local function ensureDir(path)
    local current = ""
    for _, part in ipairs(string.Explode("/", path)) do
        if part ~= "" then
            current = current == "" and part or current .. "/" .. part
            if not file.Exists(current, "DATA") then file.CreateDir(current) end
        end
    end
end

local function findImage(name)
    name = normalizeName(name)
    if not name then return nil end
    if resolved[name] then
        local path = resolved[name]:gsub("^data/", "")
        if file.Exists(path, "DATA") then return resolved[name] end
        resolved[name] = nil
    end

    local baseName = name:gsub("%.[^/%.]+$", "")
    for _, extension in ipairs({"png", "jpg", "jpeg"}) do
        local path = baseDir .. baseName .. "." .. extension
        if file.Exists(path, "DATA") then
            resolved[name] = "data/" .. path
            return resolved[name]
        end
    end
end

function lia.webcontent.download(name, url, callback)
    name = normalizeName(name)
    if not name then
        if callback then callback(nil, false, "invalid image name") end
        return
    end

    if not isstring(url) or not url:find("^https?://") or #url > 2048 or url:find('[<>"\\|]') then
        if callback then callback(nil, false, "invalid url") end
        return
    end

    local host = url:match("^https?://([^/:?#]+)")
    if not host then
        if callback then callback(nil, false, "invalid url") end
        return
    end

    host = host:lower()
    local _, second = host:match("^(172)%.(%d+)%.")
    if host == "localhost" or host:match("%.localhost$") or host:match("^127%.") or host:match("^10%.") or host:match("^192%.168%.") or second and tonumber(second) >= 16 and tonumber(second) <= 31 then
        if callback then callback(nil, false, "invalid url") end
        return
    end

    if pending[name] then
        if callback then pending[name][#pending[name] + 1] = callback end
        return
    end

    pending[name] = {}
    if callback then pending[name][1] = callback end
    http.Fetch(url, function(body, _, _, code)
        local callbacks = pending[name]
        if code and (code < 200 or code >= 300) then
            pending[name] = nil
            for _, fn in ipairs(callbacks or {}) do
                fn(nil, false, "http status " .. tostring(code))
            end
            return
        end

        if not isstring(body) or body == "" then
            pending[name] = nil
            for _, fn in ipairs(callbacks or {}) do
                fn(nil, false, "empty response")
            end
            return
        end

        local extension
        if body:sub(1, 8) == "\137PNG\r\n\26\n" then
            extension = "png"
        elseif #body >= 3 and body:byte(1) == 0xFF and body:byte(2) == 0xD8 and body:byte(3) == 0xFF then
            extension = "jpg"
        end

        if not extension then
            pending[name] = nil
            for _, fn in ipairs(callbacks or {}) do
                fn(nil, false, "invalid image format")
            end
            return
        end

        local baseName = name:gsub("%.[^/%.]+$", "")
        local fullPath = baseDir .. baseName .. "." .. extension
        local directory = fullPath:match("(.+)/[^/]+$")
        ensureDir(directory or baseDir)
        local cached = false
        if file.Exists(fullPath, "DATA") then
            local existing = file.Read(fullPath, "DATA")
            cached = isstring(existing) and util.CRC(existing) == util.CRC(body)
        end

        if not cached then
            file.Write(fullPath, body)
            if not file.Exists(fullPath, "DATA") then
                pending[name] = nil
                for _, fn in ipairs(callbacks or {}) do
                    fn(nil, false, "failed to write image")
                end
                return
            end

            for _, otherExtension in ipairs({"png", "jpg", "jpeg"}) do
                local otherPath = baseDir .. baseName .. "." .. otherExtension
                if otherPath ~= fullPath and file.Exists(otherPath, "DATA") then file.Delete(otherPath) end
            end
        end

        resolved[name] = "data/" .. fullPath
        pending[name] = nil
        for _, fn in ipairs(callbacks or {}) do
            fn(resolved[name], cached)
        end
    end, function(err)
        local callbacks = pending[name]
        pending[name] = nil
        for _, fn in ipairs(callbacks or {}) do
            fn(nil, false, tostring(err or "download failed"))
        end
    end)
end

function lia.webcontent.registerImage(name, url)
    name = normalizeName(name)
    if not name then return false end
    registered[name] = url
    local path = findImage(name)
    if not path then
        lia.webcontent.download(name, url)
    else
        lia.webcontent.download(name, url)
    end
    return true
end

function lia.webcontent.getImage(name, callback)
    name = normalizeName(name)
    if not name then
        if callback then callback(nil, false, "invalid image name") end
        return
    end

    local path = findImage(name)
    if path then
        if callback then callback(path, true) end
        return path
    end

    local url = registered[name]
    if not url then
        if callback then callback(nil, false, "image not registered") end
        return
    end

    lia.webcontent.download(name, url, callback)
end

function dimage:SetImage(source, backup)
    local name = normalizeName(source)
    if not name or not registered[name] then return originalSetImage(self, source, backup) end
    local path = findImage(name)
    if path then return originalSetImage(self, path, backup) end
    if backup then originalSetImage(self, backup) end
    lia.webcontent.download(name, registered[name], function(downloadedPath) if IsValid(self) and downloadedPath then originalSetImage(self, downloadedPath, backup) end end)
end

function Material(path, ...)
    local name = normalizeName(path)
    if name and registered[name] then
        local imagePath = findImage(name)
        if imagePath then return originalMaterial(imagePath, ...) end
    end
    return originalMaterial(path, ...)
end

ensureDir(baseDir)
lia.webcontent.registerImage("lilia.png", "https://bleonheart.github.io/Samael-Assets/lilia.png")
lia.webcontent.registerImage("characters.png", "https://bleonheart.github.io/Samael-Assets/misc/png/characters.png")
lia.webcontent.registerImage("locked.png", "https://bleonheart.github.io/Samael-Assets/misc/png/locked.png")
lia.webcontent.registerImage("unlocked.png", "https://bleonheart.github.io/Samael-Assets/misc/png/unlocked.png")
lia.webcontent.registerImage("inventory.png", "https://bleonheart.github.io/Samael-Assets/misc/png/inventory.png")
lia.webcontent.registerImage("you.png", "https://bleonheart.github.io/Samael-Assets/misc/png/you.png")
lia.webcontent.registerImage("onlinestaff.png", "https://bleonheart.github.io/Samael-Assets/misc/png/onlinestaff.png")
lia.webcontent.registerImage("characterlist.png", "https://bleonheart.github.io/Samael-Assets/misc/png/characterlist.png")
lia.webcontent.registerImage("chatfilter.png", "https://bleonheart.github.io/Samael-Assets/misc/png/chatfilter.png")
lia.webcontent.registerImage("factionmanagement.png", "https://bleonheart.github.io/Samael-Assets/misc/png/factionmanagement.png")
lia.webcontent.registerImage("permissions.png", "https://bleonheart.github.io/Samael-Assets/misc/png/permissions.png")
lia.webcontent.registerImage("playerentities.png", "https://bleonheart.github.io/Samael-Assets/misc/png/playerentities.png")
lia.webcontent.registerImage("staffcases.png", "https://bleonheart.github.io/Samael-Assets/misc/png/staffcases.png")
lia.webcontent.registerImage("staffcharacterpermissions.png", "https://bleonheart.github.io/Samael-Assets/misc/png/staffcharacterpermissions.png")
lia.webcontent.registerImage("toolpermissions.png", "https://bleonheart.github.io/Samael-Assets/misc/png/toolpermissions.png")
lia.webcontent.registerImage("logs.png", "https://bleonheart.github.io/Samael-Assets/misc/png/logs.png")
lia.webcontent.registerImage("information.png", "https://bleonheart.github.io/Samael-Assets/misc/png/information.png")
lia.webcontent.registerImage("settings.png", "https://bleonheart.github.io/Samael-Assets/misc/png/settings.png")
lia.webcontent.registerImage("themes.png", "https://bleonheart.github.io/Samael-Assets/misc/png/themes.png")
lia.webcontent.registerImage("classes.png", "https://bleonheart.github.io/Samael-Assets/misc/png/classes.png")