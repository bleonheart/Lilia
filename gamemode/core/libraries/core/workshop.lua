lia.workshop = lia.workshop or {}
lia.workshop.ids = lia.workshop.ids or {}
lia.workshop.known = lia.workshop.known or {}
if SERVER then
    lia.workshop.ids["3527535922"] = true
    function lia.workshop.addWorkshop(id)
        id = tostring(id)
        if not lia.workshop.ids[id] then
            lia.bootstrap("Workshop Downloader", string.format("Downloading workshop %s", id))
            lia.workshop.ids[id] = true
        end
    end

    local function addKnown(id)
        id = tostring(id)
        if not lia.workshop.known[id] then
            lia.workshop.known[id] = true
            lia.bootstrap("Workshop Downloader", string.format("Added workshop %s to download list", id))
        end
    end

    function lia.workshop.gather()
        local ids = table.Copy(lia.workshop.ids)
        for _, addon in pairs(engine.GetAddons() or {}) do
            if addon.mounted and addon.wsid then ids[tostring(addon.wsid)] = true end
        end

        for _, module in pairs(lia.module.list) do
            local wc = module.WorkshopContent
            if wc then
                if isstring(wc) then
                    ids[wc] = true
                else
                    for _, v in ipairs(wc) do
                        ids[tostring(v)] = true
                    end
                end
            end
        end

        for id in pairs(ids) do
            addKnown(id)
        end
        return ids
    end

    hook.Add("InitializedModules", "liaWorkshopInitializedModules", function() lia.workshop.cache = lia.workshop.gather() end)
    function lia.workshop.send(ply)
        net.Start("liaWorkshopDownloaderStart")
        net.WriteTable(lia.workshop.cache)
        net.Send(ply)
    end

    hook.Add("PlayerInitialSpawn", "liaWorkshopInit", function(ply)
        timer.Simple(2, function()
            if IsValid(ply) then
                net.Start("liaWorkshopDownloaderInfo")
                net.WriteTable(lia.workshop.cache or {})
                net.Send(ply)
            end
        end)
    end)
else
    lia.workshop.serverIds = lia.workshop.serverIds or {}
    lia.workshop.serverIds["3527535922"] = true
    local function formatSize(bytes)
        if not bytes or bytes <= 0 then return "0 B" end
        local units = {"B", "KB", "MB", "GB", "TB"}
        local unit = 1
        while bytes >= 1024 and unit < #units do
            bytes = bytes / 1024
            unit = unit + 1
        end
        return string.format("%.2f %s", bytes, units[unit])
    end

    local function workshopDebug(id, stage, ...)
        lia.debug("[Workshop]", "ID=", tostring(id), "Stage=", tostring(stage), ...)
    end

    local function debugMountedFiles(id, files)
        if not istable(files) then
            workshopDebug(id, "MountGMA files", "No file table returned", "type=" .. type(files))
            return
        end

        local models = {}
        local materials = 0
        local luaFiles = 0
        local sounds = 0
        local maps = 0
        for _, path in ipairs(files) do
            local lower = tostring(path):lower()
            if lower:StartWith("models/") and lower:EndsWith(".mdl") then
                models[#models + 1] = path
            elseif lower:StartWith("materials/") then
                materials = materials + 1
            elseif lower:StartWith("lua/") then
                luaFiles = luaFiles + 1
            elseif lower:StartWith("sound/") then
                sounds = sounds + 1
            elseif lower:StartWith("maps/") then
                maps = maps + 1
            end
        end

        workshopDebug(id, "Mounted file summary", "total=" .. #files, "models=" .. #models, "materials=" .. materials, "lua=" .. luaFiles, "sounds=" .. sounds, "maps=" .. maps)
        for i = 1, math.min(#models, 15) do
            local model = models[i]
            workshopDebug(id, "Model check", model, "GAME exists=" .. tostring(file.Exists(model, "GAME")), "valid=" .. tostring(util.IsValidModel(model)))
        end

        if #models > 15 then workshopDebug(id, "Model check", "... " .. (#models - 15) .. " additional models omitted") end
    end

    local function debugAddonState(id, stage)
        local found = false
        for _, addon in pairs(engine.GetAddons() or {}) do
            if tostring(addon.wsid or addon.workshopid) == tostring(id) then
                found = true
                workshopDebug(id, stage, "engine.GetAddons match", "title=" .. tostring(addon.title), "mounted=" .. tostring(addon.mounted), "downloaded=" .. tostring(addon.downloaded), "file=" .. tostring(addon.file))
            end
        end

        if not found then workshopDebug(id, stage, "No engine.GetAddons entry found") end
    end

    local function mounted(id)
        for _, addon in pairs(engine.GetAddons() or {}) do
            if tostring(addon.wsid or addon.workshopid) == tostring(id) and addon.mounted then return true end
        end
        return false
    end

    function lia.workshop.downloadAndMount(id, callback)
        workshopDebug(id, "DownloadUGC", "Starting download")
        debugAddonState(id, "Before DownloadUGC")
        steamworks.DownloadUGC(id, function(path)
            workshopDebug(id, "DownloadUGC callback", "path=" .. tostring(path), "type=" .. type(path))
            if not isstring(path) or path == "" then
                workshopDebug(id, "DownloadUGC", "FAILED: empty or invalid path")
                if isfunction(callback) then callback(false) end
                return
            end

            workshopDebug(id, "MountGMA", "Attempting mount", path)
            debugAddonState(id, "Immediately before MountGMA")
            local success, files = game.MountGMA(path)
            workshopDebug(id, "MountGMA result", "success=" .. tostring(success), "returnedFiles=" .. tostring(istable(files) and #files or 0))
            debugMountedFiles(id, files)
            debugAddonState(id, "Immediately after MountGMA")
            timer.Simple(1, function()
                workshopDebug(id, "Mount +1s", "mounted()=" .. tostring(mounted(id)))
                debugAddonState(id, "MountGMA +1s")
                debugMountedFiles(id, files)
            end)

            timer.Simple(5, function()
                workshopDebug(id, "Mount +5s", "mounted()=" .. tostring(mounted(id)))
                debugAddonState(id, "MountGMA +5s")
                debugMountedFiles(id, files)
            end)

            if not success then
                workshopDebug(id, "MountGMA", "FAILED")
                if isfunction(callback) then callback(false) end
                return
            end

            if isfunction(callback) then callback(true) end
        end)
    end

    local function gmaDir()
        local dir = "lilia/workshop"
        if not file.IsDir(dir, "DATA") then file.CreateDir(dir) end
        return dir
    end

    local function gmaPath(id)
        return gmaDir() .. "/" .. id .. ".gma"
    end

    local function mountLocal(id)
        local rel = gmaPath(id)
        if not file.Exists(rel, "DATA") then
            workshopDebug(id, "mountLocal", "Cached GMA does not exist", rel)
            return false
        end

        workshopDebug(id, "mountLocal", "Attempting cached mount", "data/" .. rel)
        debugAddonState(id, "Before cached MountGMA")
        local success, files = game.MountGMA("data/" .. rel)
        workshopDebug(id, "mountLocal", "MountGMA success=" .. tostring(success), "returnedFiles=" .. tostring(istable(files) and #files or 0))
        debugMountedFiles(id, files)
        debugAddonState(id, "Immediately after cached MountGMA")
        timer.Simple(1, function()
            workshopDebug(id, "Cached mount +1s", "mounted()=" .. tostring(mounted(id)))
            debugAddonState(id, "Cached MountGMA +1s")
            debugMountedFiles(id, files)
        end)
        return success == true
    end

    function lia.workshop.hasContentToDownload()
        for id in pairs(lia.workshop.serverIds or {}) do
            if not mounted(id) and not mountLocal(id) then return true end
        end
        return false
    end

    function lia.workshop.mountContent()
        local ids = lia.workshop.serverIds or {}
        local needed = {}
        for id in pairs(ids) do
            if not mounted(id) and not mountLocal(id) then needed[#needed + 1] = id end
        end

        if #needed == 0 then
            lia.bootstrap("Workshop Downloader", "All workshop addons already installed. Skipping download.")
            return
        end

        local pending, totalSize = #needed, 0
        for _, id in ipairs(needed) do
            steamworks.FileInfo(id, function(fi)
                if fi and fi.size then totalSize = totalSize + fi.size end
                pending = pending - 1
                if pending <= 0 then
                    lia.derma.requestPopupQuestion(string.format("Download %s of workshop content?", formatSize(totalSize)), {
                        {
                            "Yes",
                            function()
                                net.Start("liaWorkshopDownloaderRequest")
                                net.SendToServer()
                            end
                        },
                        {"No"}
                    })
                end
            end)
        end
    end

    function lia.workshop.remountContent()
        local ids = lia.workshop.serverIds or {}
        local hasMissingContent = false
        local remountedAny = false
        for id in pairs(ids) do
            if not mounted(id) then
                if mountLocal(id) then
                    remountedAny = true
                else
                    hasMissingContent = true
                end
            end
        end

        if hasMissingContent then
            lia.workshop.mountContent()
            return
        end

        if remountedAny or not lia.workshop.hasContentToDownload() then lia.bootstrap("Workshop Downloader", "All workshop addons already installed. Skipping download.") end
    end

    local workshopSearchIcon = Material("icon16/magnifier.png", "smooth")
    local workshopLinkIcon = Material("icon16/world_go.png", "smooth")
    local workshopMountIcon = Material("icon16/drive_disk.png", "smooth")
    local workshopFallbackIcon = Material("icon16/package.png", "smooth")
    local workshopPreviewCache = {}
    local workshopPreviewCallbacks = {}
    local function getWorkshopThemeColors(palette)
        if palette then return palette.accent, palette.text end
        local theme = lia.color and lia.color.theme or {}
        local accent = theme.accent or theme.theme
        if not IsColor(accent) then accent = lia.config.get("Color") end
        if not IsColor(accent) then accent = Color(45, 190, 170) end
        local text = theme.text
        if not IsColor(text) then text = Color(225, 238, 238) end
        return accent, text
    end

    local function drawWorkshopPanel(x, y, w, h, radius, color, outline)
        draw.RoundedBox(radius, x, y, w, h, color)
        if not outline then return end
        surface.SetDrawColor(outline)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end

    local function drawBrowserPanel(x, y, w, h, radius, color, outline, palette)
        if palette and palette.drawPanel then
            palette.drawPanel(x, y, w, h, radius, color, outline)
        else
            drawWorkshopPanel(x, y, w, h, radius, color, outline)
        end
    end

    local function drawWorkshopIcon(material, x, y, size, color)
        if not material or material:IsError() then return end
        surface.SetMaterial(material)
        surface.SetDrawColor(color or color_white)
        surface.DrawTexturedRect(x, y, size, size)
    end

    local function fitWorkshopText(text, font, maxWidth)
        text = tostring(text or "")
        if maxWidth <= 0 then return "" end
        surface.SetFont(font)
        if surface.GetTextSize(text) <= maxWidth then return text end
        local ellipsis = "..."
        local ellipsisWidth = surface.GetTextSize(ellipsis)
        if ellipsisWidth > maxWidth then return "" end
        local trimmed = text
        while #trimmed > 0 and surface.GetTextSize(trimmed .. ellipsis) > maxWidth do
            trimmed = string.sub(trimmed, 1, -2)
        end
        return trimmed .. ellipsis
    end

    local function formatWorkshopTime(value)
        local timestamp = tonumber(value)
        if not timestamp or timestamp <= 0 then return "Unknown" end
        return os.date("%Y-%m-%d %H:%M:%S", timestamp)
    end

    local function workshopPreviewPath(id)
        file.CreateDir("lilia")
        file.CreateDir("lilia/workshop")
        file.CreateDir("lilia/workshop/previews")
        return "lilia/workshop/previews/" .. tostring(id) .. ".jpg"
    end

    local function loadWorkshopPreview(id, url, callback)
        id = tostring(id)
        if workshopPreviewCache[id] then
            callback(workshopPreviewCache[id])
            return
        end

        workshopPreviewCallbacks[id] = workshopPreviewCallbacks[id] or {}
        workshopPreviewCallbacks[id][#workshopPreviewCallbacks[id] + 1] = callback
        if #workshopPreviewCallbacks[id] > 1 then return end
        local dataPath = workshopPreviewPath(id)
        local function finish(material)
            workshopPreviewCache[id] = material or workshopFallbackIcon
            local callbacks = workshopPreviewCallbacks[id] or {}
            workshopPreviewCallbacks[id] = nil
            for _, cb in ipairs(callbacks) do
                cb(workshopPreviewCache[id])
            end
        end

        if file.Exists(dataPath, "DATA") then
            local material = Material("data/" .. dataPath, "smooth noclamp")
            finish(not material:IsError() and material or nil)
            return
        end

        if not isstring(url) or url == "" then
            finish(nil)
            return
        end

        http.Fetch(url, function(body)
            if not body or body == "" then
                finish(nil)
                return
            end

            file.Write(dataPath, body)
            local material = Material("data/" .. dataPath, "smooth noclamp")
            finish(not material:IsError() and material or nil)
        end, function() finish(nil) end)
    end

    local function createWorkshopButton(parent, label, icon, accented, callback, palette)
        local button = parent:Add("DButton")
        button:SetText("")
        button.Paint = function(self, w, h)
            local accent, textColor = getWorkshopThemeColors(palette)
            local hovered = self:IsHovered() and self:IsEnabled()
            local background
            local outline
            if accented then
                background = hovered and Color(accent.r, accent.g, accent.b, 32) or Color(accent.r, accent.g, accent.b, 16)
                outline = Color(accent.r, accent.g, accent.b, hovered and 185 or 120)
            else
                background = hovered and Color(255, 255, 255, 10) or (palette and palette.surfaceAlt or Color(4, 17, 22, 210))
                outline = palette and Color(palette.muted.r, palette.muted.g, palette.muted.b, hovered and 110 or 60) or Color(160, 190, 192, hovered and 90 or 48)
            end

            if not self:IsEnabled() then
                background = Color(255, 255, 255, 5)
                outline = Color(255, 255, 255, 22)
            end

            drawBrowserPanel(0, 0, w, h, 5, background, outline, palette)
            local color = self:IsEnabled() and (accented and accent or textColor) or (palette and palette.muted or Color(115, 135, 136))
            local textX = 18
            if icon and not icon:IsError() then
                drawWorkshopIcon(icon, 16, math.floor((h - 16) * 0.5), 16, color)
                textX = 42
            end

            draw.SimpleText(fitWorkshopText(label, "LiliaFont.17", w - textX - 12), "LiliaFont.17", textX, h * 0.5, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function(self)
            if not self:IsEnabled() then return end
            lia.webcontent.playButtonSound()
            callback()
        end
        return button
    end

    local function createWorkshopSection(parent, title, palette)
        local section = parent:Add("DPanel")
        section:Dock(TOP)
        section:DockMargin(0, 0, 0, 12)
        section.Paint = function(_, w, h)
            local accent = getWorkshopThemeColors(palette)
            drawBrowserPanel(0, 0, w, h, 6, palette and palette.surface or Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58), palette)
            draw.SimpleText(string.upper(title), "LiliaFont.17", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
            surface.DrawRect(16, 42, w - 32, 1)
        end
        return section
    end

    local function createWorkshopRows(section, rows, palette)
        local rowHeight = 46
        section:SetTall(58 + #rows * rowHeight)
        section.Paint = function(_, w, h)
            local accent = getWorkshopThemeColors(palette)
            drawBrowserPanel(0, 0, w, h, 6, palette and palette.surface or Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58), palette)
            draw.SimpleText(string.upper(section.sectionTitle or ""), "LiliaFont.17", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
            surface.DrawRect(16, 42, w - 32, 1)
            for i, row in ipairs(rows) do
                local y = 43 + (i - 1) * rowHeight
                if i > 1 then
                    surface.SetDrawColor(255, 255, 255, 17)
                    surface.DrawRect(16, y, w - 32, 1)
                end

                draw.SimpleText(row[1], "LiliaFont.17", 16, y + rowHeight * 0.5, palette and palette.muted or Color(175, 197, 198), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(row[2], "LiliaFont.17", w - 16, y + rowHeight * 0.5, row[3] or (palette and palette.text or Color(220, 232, 232)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
        end
    end

    local function escapeWorkshopHTML(value)
        return tostring(value or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&#39;")
    end

    local function safeWorkshopURL(value)
        local url = string.Trim(tostring(value or ""))
        if #url > 2048 or url:find("[%c%s]") or not url:match("^https?://[%w]") then return nil end
        return url
    end

    local workshopHTMLTags = {
        b = "strong",
        i = "em",
        u = "u",
        strike = "s",
        s = "s",
        h1 = "h1",
        h2 = "h2",
        h3 = "h3",
        quote = "blockquote",
        spoiler = "span",
        table = "table",
        tr = "tr",
        td = "td",
        th = "th"
    }

    local function renderWorkshopBBCode(description)
        local output = {}
        local opened = {}
        local cursor = 1
        local lowercase = description:lower()
        local function append(value)
            output[#output + 1] = value
        end

        local function closeTag(entry)
            if entry.list and entry.hasItem then append("</li>") end
            append("</" .. entry.html .. ">")
        end

        while cursor <= #description do
            local startAt, endAt = description:find("%b[]", cursor)
            if not startAt then
                append(escapeWorkshopHTML(description:sub(cursor)))
                break
            end

            append(escapeWorkshopHTML(description:sub(cursor, startAt - 1)))
            local token = description:sub(startAt, endAt)
            local contents = token:sub(2, -2)
            local closing = contents:sub(1, 1) == "/"
            if closing then contents = contents:sub(2) end
            local name, argument = contents:match("^([%a%*]+)%s*=%s*(.-)%s*$")
            if not name then name = contents:match("^([%a%*]+)%s*$") end
            if name then name = name:lower() end
            local consumed = false
            cursor = endAt + 1

            if closing then
                local entry = opened[#opened]
                if entry and entry.name == name then
                    closeTag(entry)
                    opened[#opened] = nil
                    consumed = true
                end
            elseif name == "*" then
                for i = #opened, 1, -1 do
                    local entry = opened[i]
                    if entry.list then
                        if entry.hasItem then append("</li>") end
                        append("<li>")
                        entry.hasItem = true
                        consumed = true
                        break
                    end
                end
            elseif name == "hr" then
                append("<hr>")
                consumed = true
            elseif name == "code" or name == "noparse" or name == "img" then
                local finishAt, finishEnd = lowercase:find("[/" .. name .. "]", cursor, true)
                if finishAt then
                    local content = description:sub(cursor, finishAt - 1)
                    if name == "code" then
                        append("<pre>" .. escapeWorkshopHTML(content) .. "</pre>")
                        consumed = true
                    elseif name == "noparse" then
                        append(escapeWorkshopHTML(content))
                        consumed = true
                    else
                        local url = safeWorkshopURL(content)
                        if url then
                            append('<img src="' .. escapeWorkshopHTML(url) .. '" alt="Workshop image">')
                            consumed = true
                        end
                    end

                    if consumed then cursor = finishEnd + 1 end
                end
            elseif name == "list" or name == "olist" then
                local html = name == "olist" or argument == "1"
                html = html and "ol" or "ul"
                append("<" .. html .. ">")
                opened[#opened + 1] = {name = name, html = html, list = true, hasItem = false}
                consumed = true
            elseif name == "url" then
                local url = safeWorkshopURL(argument)
                if not url then
                    local finishAt = lowercase:find("[/url]", cursor, true)
                    if finishAt then url = safeWorkshopURL(description:sub(cursor, finishAt - 1)) end
                end

                if url then
                    append('<a href="' .. escapeWorkshopHTML(url) .. '">')
                    opened[#opened + 1] = {name = name, html = "a"}
                    consumed = true
                end
            elseif workshopHTMLTags[name] then
                local html = workshopHTMLTags[name]
                append("<" .. html .. ">")
                opened[#opened + 1] = {name = name, html = html}
                consumed = true
            end

            if not consumed then append(escapeWorkshopHTML(token)) end
        end

        for i = #opened, 1, -1 do
            closeTag(opened[i])
        end

        return table.concat(output)
    end

    local function createWorkshopDescriptionHTML(description, palette)
        local accent, textColor = getWorkshopThemeColors(palette)
        local background = palette and palette.surface or Color(26, 28, 39)
        return string.format([[<!doctype html>
<html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<style>
html,body{margin:0;padding:0;background:rgb(%d,%d,%d);color:rgb(%d,%d,%d);font:13px/1.45 Arial,Helvetica,sans-serif;overflow:hidden}
body{white-space:pre-wrap;overflow-wrap:anywhere;word-break:normal}
a{color:rgb(%d,%d,%d);text-decoration:underline;cursor:pointer}
a:hover{filter:brightness(1.25)}
h1,h2,h3{margin:8px 0 5px;font-weight:600;line-height:1.3;white-space:normal}
h1{font-size:20px}h2{font-size:17px}h3{font-size:15px}
ul,ol{margin:3px 0 8px;padding-left:24px;white-space:normal}
li{padding:1px 0;white-space:pre-wrap}
blockquote{margin:6px 0;padding:6px 12px;border-left:2px solid rgb(%d,%d,%d);background:rgba(255,255,255,.035)}
pre{white-space:pre-wrap;overflow-wrap:anywhere;padding:9px;background:rgba(0,0,0,.18);border-radius:3px}
img{display:block;max-width:100%%;height:auto;margin:7px 0}
hr{border:0;border-top:1px solid rgba(255,255,255,.16);margin:12px 0}
table{border-collapse:collapse;max-width:100%%;white-space:normal}td,th{padding:5px 8px;border:1px solid rgba(255,255,255,.15)}
</style></head><body>%s
<script>
function reportWorkshopHeight(){if(window.liaWorkshop&&window.liaWorkshop.height){window.liaWorkshop.height(Math.ceil(document.body.scrollHeight));}}
document.addEventListener('click',function(event){var link=event.target.closest('a[href]');if(!link)return;event.preventDefault();if(window.liaWorkshop&&window.liaWorkshop.open){window.liaWorkshop.open(link.href);}});
document.addEventListener('wheel',function(event){if(window.liaWorkshop&&window.liaWorkshop.wheel){window.liaWorkshop.wheel(event.deltaY);event.preventDefault();}},{passive:false});
document.addEventListener('load',function(event){if(event.target.tagName==='IMG')reportWorkshopHeight();},true);
window.addEventListener('load',reportWorkshopHeight);
window.addEventListener('resize',reportWorkshopHeight);
</script></body></html>]], background.r, background.g, background.b, textColor.r, textColor.g, textColor.b, accent.r, accent.g, accent.b, accent.r, accent.g, accent.b, renderWorkshopBBCode(description))
    end

    function lia.workshop.createBrowser(parent, options)
        options = options or {}
        local mountMode = options.mountMode == true
        local collectionURL = options.collectionURL or ""
        local palette = options.palette
        parent:Clear()
        local ids = lia.workshop.serverIds or {}
                local addonCount = table.Count(ids)
                local root = parent:Add("DPanel")
                root:Dock(FILL)
                root.Paint = function() end
                local listPanel = root:Add("DPanel")
                listPanel:Dock(LEFT)
                listPanel:SetWide(mountMode and math.Clamp(parent:GetWide() * 0.34, 300, 370) or math.Clamp(ScrW() * 0.245, 340, 430))
                listPanel:DockMargin(0, 0, 12, 0)
                listPanel:DockPadding(12, 12, 12, 12)
                listPanel.Paint = function(_, w, h)
                    local accent = getWorkshopThemeColors(palette)
                    drawBrowserPanel(0, 0, w, h, 7, palette and palette.surface or Color(5, 18, 23, 215), Color(accent.r, accent.g, accent.b, 58), palette)
                end

                local detailPanel = root:Add("DPanel")
                detailPanel:Dock(FILL)
                detailPanel.Paint = function() end
                local controls = listPanel:Add("DPanel")
                controls:Dock(TOP)
                controls:SetTall(46)
                controls:DockMargin(0, 0, 0, 12)
                controls.Paint = function() end
                local filter = controls:Add("liaComboBox")
                filter:Dock(RIGHT)
                filter:SetWide(132)
                filter:DockMargin(8, 0, 0, 0)
                filter:SetValue("All Addons")
                filter:AddChoice("All Addons", "all")
                filter:AddChoice("Mounted", "mounted")
                filter:AddChoice("Not Mounted", "unmounted")
                filter:SetFont("LiliaFont.16")
                filter:SetTextColor(Color(215, 229, 229))
                filter.btn.Paint = function(_, w, h)
                    local accent = getWorkshopThemeColors(palette)
                    drawBrowserPanel(0, 0, w, h, 5, palette and palette.surfaceAlt or Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60), palette)
                    draw.SimpleText(filter:GetValue(), "LiliaFont.16", 12, h * 0.5, palette and palette.text or Color(215, 229, 229), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText("▼", "LiliaFont.15", w - 14, h * 0.5, Color(175, 197, 198), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local searchPanel = controls:Add("DPanel")
                searchPanel:Dock(FILL)
                searchPanel:DockPadding(42, 0, 8, 0)
                searchPanel.Paint = function(_, w, h)
                    local accent = getWorkshopThemeColors(palette)
                    drawBrowserPanel(0, 0, w, h, 5, palette and palette.surfaceAlt or Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60), palette)
                    drawWorkshopIcon(workshopSearchIcon, 14, math.floor((h - 16) * 0.5), 16, palette and palette.muted or Color(165, 190, 192))
                end

                local searchEntry = searchPanel:Add("DTextEntry")
                searchEntry:Dock(FILL)
                searchEntry:SetFont("LiliaFont.16")
                searchEntry:SetTextColor(Color(225, 236, 236))
                searchEntry:SetCursorColor(getWorkshopThemeColors(palette))
                searchEntry:SetPlaceholderText("Search addons...")
                searchEntry:SetPaintBackground(false)
                searchEntry:SetPaintBorderEnabled(false)
                local sectionLabel = listPanel:Add("DLabel")
                sectionLabel:Dock(TOP)
                sectionLabel:SetTall(34)
                sectionLabel:SetText("INSTALLED ADDONS")
                sectionLabel:SetFont("LiliaFont.17")
                sectionLabel:SetTextColor(getWorkshopThemeColors(palette))
                sectionLabel:SetContentAlignment(4)
                local countLabel
                if not mountMode then
                    countLabel = listPanel:Add("DLabel")
                    countLabel:Dock(BOTTOM)
                    countLabel:SetTall(28)
                    countLabel:SetFont("LiliaFont.15")
                    countLabel:SetTextColor(palette and palette.muted or Color(145, 169, 170))
                    countLabel:SetContentAlignment(4)
                end

                local listScroll = listPanel:Add("liaScrollPanel")
                listScroll:Dock(FILL)
                listScroll.Paint = function() end
                local listCanvas = listScroll:GetCanvas()
                if IsValid(listCanvas) then
                    listCanvas:DockPadding(0, 0, 4, 0)
                    listCanvas.Paint = function() end
                else
                    listCanvas = listScroll
                end

                if addonCount <= 0 then
                    if countLabel then countLabel:SetText("0 addons") end
                    local empty = listCanvas:Add("DLabel")
                    empty:Dock(TOP)
                    empty:SetTall(80)
                    empty:SetText("No workshop addons found. Make sure the server has configured workshop content.")
                    empty:SetContentAlignment(5)
                    empty:SetTextColor(palette and palette.muted or Color(150, 170, 170))
                    empty:SetFont("LiliaFont.18")
                    detailPanel.Paint = function(_, w, h)
                        local accent = getWorkshopThemeColors(palette)
                        drawBrowserPanel(0, 0, w, h, 7, palette and palette.surface or Color(5, 18, 23, 190), Color(accent.r, accent.g, accent.b, 45), palette)
                        draw.SimpleText("No workshop addons found. Make sure the server has configured workshop content.", "LiliaFont.20", w * 0.5, h * 0.5, palette and palette.muted or Color(150, 170, 170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    return
                end

                local records = {}
                local totalSize = 0
                local selectedSize = 0
                local selectedCount = 0
                local selectedCard
                local selectedFilter = "all"
                local function updateSelectedSize()
                    selectedSize = 0
                    selectedCount = 0
                    for _, record in ipairs(records) do
                        if record.selected and not record.mounted then
                            selectedSize = selectedSize + (tonumber(record.info.size) or 0)
                            selectedCount = selectedCount + 1
                        end
                    end
                end

                local function updateCount()
                    if not countLabel then return end
                    local visible = 0
                    for _, record in ipairs(records) do
                        if IsValid(record.card) and record.card:IsVisible() then visible = visible + 1 end
                    end

                    countLabel:SetText(string.format("%d %s", visible, visible == 1 and "addon" or "addons"))
                end

                local function matchesFilter(record)
                    if selectedFilter == "mounted" then return record.mounted end
                    if selectedFilter == "unmounted" then return not record.mounted end
                    return true
                end

                local function applyFilters()
                    local query = string.Trim(searchEntry:GetValue() or ""):lower()
                    for _, record in ipairs(records) do
                        local visible = matchesFilter(record) and (query == "" or record.searchText:find(query, 1, true) ~= nil)
                        if IsValid(record.card) then record.card:SetVisible(visible) end
                    end

                    if IsValid(listCanvas) then listCanvas:InvalidateLayout(true) end
                    updateCount()
                end

                searchEntry.OnChange = applyFilters
                filter.OnSelect = function(_, _, _, data)
                    selectedFilter = data or "all"
                    applyFilters()
                end

                local function rebuildDetail(record)
                    detailPanel:Clear()
                    local accent, textColor = getWorkshopThemeColors(palette)
                    local header = detailPanel:Add("DPanel")
                    header:Dock(TOP)
                    header:SetTall(128)
                    header:DockMargin(0, 0, 0, 12)
                    header.Paint = function(_, w, h)
                        drawBrowserPanel(0, 0, w, h, 7, palette and palette.surface or Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58), palette)
                        drawWorkshopIcon(record.previewMaterial or workshopFallbackIcon, 28, 22, 86, color_white)
                        local buttonWidth = math.Clamp(math.floor(w * 0.215), 106, 156)
                        local buttonX = w - 16 - buttonWidth * 2 - 10
                        draw.SimpleText(fitWorkshopText(record.title, "LiliaFont.26", math.max(48, buttonX - 152)), "LiliaFont.26", 136, 24, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        local statusColor = record.mounted and Color(60, 225, 160) or Color(145, 165, 166)
                        surface.SetDrawColor(statusColor)
                        surface.DrawRect(136, 66, 8, 8)
                        draw.SimpleText(record.mounted and "MOUNTED" or "NOT MOUNTED", "LiliaFont.16", 154, 70, statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
                        surface.DrawRect(16, 116, w - 32, 1)
                    end

                    local mountButton
                    local workshopButton = createWorkshopButton(header, "WORKSHOP", workshopLinkIcon, false, function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. record.id) end, palette)
                    local function buildMountButton()
                        if IsValid(mountButton) then mountButton:Remove() end
                        local label = record.mounted and "MOUNTED" or string.upper(tostring("Mount"))
                        mountButton = createWorkshopButton(header, label, workshopMountIcon, true, function()
                            lia.workshop.downloadAndMount(record.id, function(success)
                                if not success then
                                    LocalPlayer():notifyError(string.format("Failed to download workshop addon: %s", record.title or record.id))
                                    return
                                end

                                record.mounted = true
                                record.selected = false
                                record.searchText = string.format("%s %s mounted", record.title, record.id):lower()
                                updateSelectedSize()
                                LocalPlayer():notify(string.format("Workshop addon downloaded: %s", record.title or record.id))
                                if IsValid(record.card) then record.card:InvalidateLayout(true) end
                                rebuildDetail(record)
                                applyFilters()
                            end)
                        end, palette)

                        mountButton:SetEnabled(not record.mounted)
                    end

                    buildMountButton()
                    header.PerformLayout = function(_, w)
                        local gap = 10
                        local buttonWidth = math.Clamp(math.floor(w * 0.215), 106, 156)
                        local startX = w - 16 - buttonWidth * 2 - gap
                        workshopButton:SetPos(startX, 30)
                        workshopButton:SetSize(buttonWidth, 40)
                        mountButton:SetPos(startX + buttonWidth + gap, 30)
                        mountButton:SetSize(buttonWidth, 40)
                    end

                    local scroll = detailPanel:Add("liaScrollPanel")
                    scroll:Dock(FILL)
                    scroll.Paint = function() end
                    local canvas = scroll:GetCanvas()
                    if IsValid(canvas) then
                        canvas:DockPadding(0, 0, 4, 0)
                        canvas.Paint = function() end
                    else
                        canvas = scroll
                    end

                    local infoSection = createWorkshopSection(canvas, "Addon Information", palette)
                    infoSection.sectionTitle = "Addon Information"
                    local updatedValue = record.info.timeupdated or record.info.updated or record.info.time_updated
                    local statusColor = record.mounted and Color(60, 225, 160) or Color(170, 188, 189)
                    local rows = {{"Workshop ID", record.id}, {"Size", record.sizeText}, {"Content Type", "Workshop Content"}, {"Status", record.mounted and "Mounted" or "Not Mounted", statusColor}, {"Last Updated", formatWorkshopTime(updatedValue)}, {"Mount Location", record.mounted and "Mounted Content" or "Not Mounted"}}
                    createWorkshopRows(infoSection, rows, palette)

                    local description = string.Trim(tostring(record.info.description or ""):gsub("\r\n", "\n"):gsub("\r", "\n"))
                    if description ~= "" then
                        local descriptionSection = createWorkshopSection(canvas, "Description", palette)
                        descriptionSection:SetTall(160)
                        local descriptionHTML = descriptionSection:Add("DHTML")
                        descriptionHTML:SetPos(16, 56)
                        descriptionHTML:SetSize(math.max(1, descriptionSection:GetWide() - 32), 90)
                        descriptionHTML.OnDocumentReady = function(self)
                            self:AddFunction("liaWorkshop", "height", function(height)
                                if not IsValid(descriptionSection) then return end
                                local sectionHeight = math.Clamp(math.ceil(tonumber(height) or 0) + 74, 100, 6000)
                                if descriptionSection:GetTall() ~= sectionHeight then
                                    descriptionSection:SetTall(sectionHeight)
                                    descriptionSection:InvalidateParent(true)
                                end
                            end)
                            self:AddFunction("liaWorkshop", "open", function(url)
                                if safeWorkshopURL(url) then gui.OpenURL(url) end
                            end)
                            self:AddFunction("liaWorkshop", "wheel", function(delta)
                                if not IsValid(scroll) then return end
                                local bar = scroll:GetVBar()
                                if IsValid(bar) then bar:AddScroll(math.Clamp(tonumber(delta) or 0, -600, 600)) end
                            end)
                            self:QueueJavascript("reportWorkshopHeight();")
                        end

                        descriptionSection.PerformLayout = function(_, w, h)
                            local width = math.max(1, w - 32)
                            local height = math.max(1, h - 68)
                            if descriptionHTML:GetWide() ~= width or descriptionHTML:GetTall() ~= height then
                                descriptionHTML:SetSize(width, height)
                            end
                        end

                        descriptionHTML:SetHTML(createWorkshopDescriptionHTML(description, palette))
                    end
                end

                local selectedRecord
                local function selectRecord(record)
                    if selectedCard and IsValid(selectedCard) then selectedCard.selected = false end
                    selectedCard = record.card
                    selectedRecord = record
                    if IsValid(selectedCard) then selectedCard.selected = true end
                    rebuildDetail(record)
                end

                local function selectedRecords()
                    local list = {}
                    for _, record in ipairs(records) do
                        if record.selected and not record.mounted then list[#list + 1] = record end
                    end

                    return list
                end

                local function unmountedRecords()
                    local list = {}
                    for _, record in ipairs(records) do
                        if not record.mounted then list[#list + 1] = record end
                    end

                    return list
                end

                local function mountRecords(list)
                    if #list == 0 then
                        lia.workshop.remountContent()
                        return
                    end

                    local totalSize = 0
                    for _, record in ipairs(list) do totalSize = totalSize + (record.info and record.info.size or 0) end
                    lia.derma.requestPopupQuestion(string.format("Download %d workshop addon%s (%s)?", #list, #list == 1 and "" or "s", formatSize(totalSize)), {
                        {
                            "Yes",
                            function()
                                local pending = #list
                                for _, record in ipairs(list) do
                                    lia.workshop.downloadAndMount(record.id, function(success)
                                        if success then
                                            record.mounted = true
                                            record.selected = false
                                            record.searchText = string.format("%s %s mounted", record.title, record.id):lower()
                                            updateSelectedSize()
                                            if IsValid(record.card) then record.card:InvalidateLayout(true) end
                                        end

                                        pending = pending - 1
                                        if pending <= 0 and IsValid(root) then
                                            applyFilters()
                                            if selectedRecord then rebuildDetail(selectedRecord) end
                                        end
                                    end)
                                end
                            end
                        },
                        {"No"}
                    })
                end

                if mountMode then
                    local actions = listPanel:Add("DPanel")
                    actions:Dock(BOTTOM)
                    actions:SetTall(collectionURL ~= "" and 122 or 80)
                    actions:DockMargin(0, 8, 0, 0)
                    actions.Paint = function() end
                    local mountSelectedButton = createWorkshopButton(actions, "MOUNT SELECTED", workshopMountIcon, true, function() mountRecords(selectedRecords()) end, palette)
                    local mountAllButton = createWorkshopButton(actions, "MOUNT ALL", workshopMountIcon, true, function() mountRecords(unmountedRecords()) end, palette)
                    local collectionButton
                    if collectionURL ~= "" then
                        collectionButton = createWorkshopButton(actions, "WORKSHOP COLLECTION", workshopLinkIcon, false, function() gui.OpenURL(collectionURL) end, palette)
                    end

                    actions.PerformLayout = function(_, w)
                        mountSelectedButton:SetPos(0, 0)
                        mountSelectedButton:SetSize(w, 36)
                        mountAllButton:SetPos(0, 44)
                        mountAllButton:SetSize(w, 36)
                        if IsValid(collectionButton) then
                            collectionButton:SetPos(0, 88)
                            collectionButton:SetSize(w, 34)
                        end
                    end

                    local sizeSummary = listPanel:Add("DPanel")
                    sizeSummary:Dock(BOTTOM)
                    sizeSummary:SetTall(98)
                    sizeSummary:DockMargin(0, 8, 0, 0)
                    sizeSummary.Paint = function(_, w, h)
                        local accent, textColor = getWorkshopThemeColors(palette)
                        drawBrowserPanel(0, 0, w, h, 5, palette and palette.surfaceAlt or Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60), palette)
                        draw.SimpleText("COLLECTION SIZE", "LiliaFont.15", 12, 19, palette and palette.muted or Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(formatSize(totalSize), "LiliaFont.17", w - 12, 19, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(string.format("%d addons", addonCount), "LiliaFont.14", 12, 37, palette and palette.muted or Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
                        surface.DrawRect(12, 48, w - 24, 1)
                        draw.SimpleText("SELECTED SIZE", "LiliaFont.15", 12, 68, palette and palette.muted or Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(formatSize(selectedSize), "LiliaFont.17", w - 12, 68, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(string.format("%d selected", selectedCount), "LiliaFont.14", 12, 86, palette and palette.muted or Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                end

                local function addRecord(record)
                    record.previewMaterial = workshopFallbackIcon
                    record.card = listCanvas:Add("DButton")
                    record.card:Dock(TOP)
                    record.card:SetTall(mountMode and 88 or 106)
                    record.card:DockMargin(0, 0, 0, mountMode and 8 or 10)
                    record.card:SetText("")
                    record.card.selected = false
                    record.card.Paint = function(s, w, h)
                        local cardAccent, cardText = getWorkshopThemeColors(palette)
                        local active = s.selected
                        local hovered = s:IsHovered()
                        local background = active and Color(cardAccent.r, cardAccent.g, cardAccent.b, 20) or hovered and Color(255, 255, 255, 6) or (palette and palette.surface or Color(5, 19, 24, 215))
                        drawBrowserPanel(0, 0, w, h, 6, background, Color(cardAccent.r, cardAccent.g, cardAccent.b, active and 125 or 52), palette)
                        if active then
                            surface.SetDrawColor(cardAccent.r, cardAccent.g, cardAccent.b, 235)
                            surface.DrawRect(0, 8, 3, h - 16)
                        end

                        local iconSize = mountMode and 52 or 62
                        local contentTop = mountMode and 18 or 21
                        local statusY = mountMode and 47 or 55
                        local textLeft = mountMode and 80 or 96
                        local checkboxVisible = mountMode and not record.mounted
                        local contentRight = checkboxVisible and w - 48 or w - 14
                        drawWorkshopIcon(record.previewMaterial or workshopFallbackIcon, 18, contentTop, iconSize, color_white)
                        draw.SimpleText(fitWorkshopText(record.title, "LiliaFont.20", contentRight - textLeft), "LiliaFont.20", textLeft, mountMode and 9 or 18, cardText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        local statusColor = record.mounted and Color(60, 225, 160) or Color(145, 165, 166)
                        surface.SetDrawColor(statusColor)
                        surface.DrawRect(textLeft, statusY - 4, 7, 7)
                        draw.SimpleText(fitWorkshopText(record.mounted and "Mounted" or "Not mounted", "LiliaFont.15", math.max(48, contentRight - textLeft - 15)), "LiliaFont.15", textLeft + 15, statusY, statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        if not mountMode then draw.SimpleText(record.sizeText, "LiliaFont.15", w - 14, statusY, palette and palette.text or Color(185, 205, 206), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
                        local detailText = string.format("ID %s", record.id)
                        draw.SimpleText(fitWorkshopText(detailText, "LiliaFont.15", contentRight - textLeft), "LiliaFont.15", textLeft, mountMode and 60 or 73, palette and palette.muted or Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        if mountMode then draw.SimpleText(record.sizeText, "LiliaFont.15", contentRight, statusY, palette and palette.text or Color(185, 205, 206), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
                        if checkboxVisible then
                            local boxX, boxY = w - 36, (h - 18) * 0.5
                            drawBrowserPanel(boxX, boxY, 18, 18, 3, record.selected and Color(cardAccent.r, cardAccent.g, cardAccent.b, 190) or (palette and palette.surfaceAlt or Color(6, 20, 26, 225)), Color(cardAccent.r, cardAccent.g, cardAccent.b, record.selected and 235 or 80), palette)
                            if record.selected then
                                surface.SetDrawColor(cardText)
                                surface.DrawLine(boxX + 4, boxY + 9, boxX + 8, boxY + 13)
                                surface.DrawLine(boxX + 8, boxY + 13, boxX + 14, boxY + 5)
                            end
                        end
                    end

                    record.card.DoClick = function()
                        lia.webcontent.playButtonSound()
                        selectRecord(record)
                        if mountMode and not record.mounted then
                            record.selected = not record.selected
                            updateSelectedSize()
                        end
                    end

                    loadWorkshopPreview(record.id, record.info.previewurl or "", function(material) record.previewMaterial = material or workshopFallbackIcon end)
                    records[#records + 1] = record
                end

                local info = {}
                local pending = addonCount
                local function populate()
                    local rows = {}
                    for id, fi in pairs(info) do
                        if fi then
                            rows[#rows + 1] = {
                                id = id,
                                info = fi
                            }
                        end
                    end

                    table.sort(rows, function(a, b) return tostring(a.info.title or a.id):lower() < tostring(b.info.title or b.id):lower() end)
                    for _, row in ipairs(rows) do
                        local fi = row.info
                        local record = {
                            id = tostring(row.id),
                            info = fi,
                            title = tostring(fi.title or string.format("ID: %s", row.id)),
                            sizeText = fi.size and formatSize(fi.size) or "0 B",
                            mounted = mounted(row.id),
                            selected = false
                        }

                        record.searchText = string.format("%s %s %s", record.title, record.id, record.mounted and "mounted" or "not mounted"):lower()
                        addRecord(record)
                    end

                    applyFilters()
                    if records[1] then selectRecord(records[1]) end
                end

                for id in pairs(ids) do
                    steamworks.FileInfo(id, function(fi)
                        info[id] = fi
                        if fi and fi.size then totalSize = totalSize + fi.size end
                        pending = pending - 1
                        if pending <= 0 and IsValid(root) then populate() end
                    end, true)
                end
    end

    hook.Add("CreateInformationButtons", "liaWorkshopInfo", function(pages)
        table.insert(pages, {
            name = "Addons",
            shouldShow = function() return true end,
            drawFunc = function(parent) lia.workshop.createBrowser(parent) end
        })
    end)
end
