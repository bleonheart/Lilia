--[[
    Folder: Developer - Libraries
    File: lia.workshop.md
]]
--[[
    Workshop

    Workshop downloader helpers for Lilia server content discovery, synchronization, download prompts, and clientside addon mounting.
]]
--[[
    Overview:
        The workshop library centralizes Workshop collection under `lia.workshop`. It registers server-required Workshop IDs, gathers IDs from mounted addons and module WorkshopContent entries, caches the resulting list for clients, sends workshop metadata to joining players, detects missing client content, requests missing downloads, and displays available server Workshop addons in the information menu.
]]
lia.workshop = lia.workshop or {}
lia.workshop.ids = lia.workshop.ids or {}
lia.workshop.known = lia.workshop.known or {}
local ALWAYS_ACTIVE_ID = "3527535922"
if SERVER then
    lia.workshop.ids[ALWAYS_ACTIVE_ID] = true
    --[[
    Purpose:
        Registers a Steam Workshop addon ID as required server content.

    Parameters:
        id (string|number)
            The Steam Workshop file ID to register.

    Example Usage:
        ```lua
        lia.workshop.addWorkshop("3527535922")
        lia.workshop.addWorkshop("3527535923")
        ```

    Realm:
        Server
]]
    function lia.workshop.addWorkshop(id)
        id = tostring(id)
        if not lia.workshop.ids[id] then
            lia.bootstrap(L("workshopDownloader"), L("workshopDownloading", id))
            lia.workshop.ids[id] = true
        end
    end

    local function addKnown(id)
        id = tostring(id)
        if not lia.workshop.known[id] then
            lia.workshop.known[id] = true
            lia.bootstrap(L("workshopDownloader"), L("workshopAdded", id))
        end
    end

    --[[
    Purpose:
        Collects all known server Workshop IDs from registered resources, mounted addons, and loaded module WorkshopContent definitions.

    Example Usage:
        ```lua
        local workshopIDs = lia.workshop.gather()
        for id in pairs(workshopIDs) do
            print("Server workshop content includes:", id)
        end
        ```

    Returns:
        table
            A table keyed by Workshop ID strings with true values for each required addon.

    Realm:
        Server
]]
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
    --[[
    Purpose:
        Sends the cached Workshop ID table to a player through the Workshop downloader start network message.

    Parameters:
        ply (Player)
            The player receiving the cached Workshop content list.

    Example Usage:
        ```lua
        local client = player.GetHumans()[1]
        if IsValid(client) then
            lia.workshop.cache = lia.workshop.cache or lia.workshop.gather()
            lia.workshop.send(client)
        end
        ```

    Realm:
        Server
]]
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
    lia.workshop.serverIds[ALWAYS_ACTIVE_ID] = true
    lia.workshop.runtimeMounted = lia.workshop.runtimeMounted or {}
    lia.workshop.runtimeDownloaded = lia.workshop.runtimeDownloaded or {}
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

    local function getAddonMap()
        local addons = {}
        for _, addon in pairs(engine.GetAddons() or {}) do
            local id = tostring(addon.wsid or addon.workshopid or "")
            if id ~= "" then addons[id] = addon end
        end
        return addons
    end

    local function getAddonEntry(id, addons)
        return (addons or getAddonMap())[tostring(id)]
    end

    local function isSubscribed(id)
        if not steamworks.IsSubscribed then return false end
        local success, subscribed = pcall(steamworks.IsSubscribed, tostring(id))
        return success and subscribed == true
    end

    local function shouldMount(id)
        if not steamworks.ShouldMountAddon then return false end
        local success, enabled = pcall(steamworks.ShouldMountAddon, tostring(id))
        return success and enabled == true
    end

    local function debugAddonState(id, stage)
        id = tostring(id)
        local addon = getAddonEntry(id)
        local runtimeMounted = lia.workshop.runtimeMounted[id] ~= nil
        local runtimeDownloaded = lia.workshop.runtimeDownloaded[id] ~= nil
        workshopDebug(id, stage, "subscribed=" .. tostring(isSubscribed(id)), "enabled=" .. tostring(shouldMount(id)), "runtimeMounted=" .. tostring(runtimeMounted), "runtimeDownloaded=" .. tostring(runtimeDownloaded))
        if addon then
            workshopDebug(id, stage, "engine.GetAddons match", "title=" .. tostring(addon.title), "mounted=" .. tostring(addon.mounted), "downloaded=" .. tostring(addon.downloaded), "file=" .. tostring(addon.file), "wsid=" .. tostring(addon.wsid))
        else
            workshopDebug(id, stage, "No engine.GetAddons entry found")
        end
    end

    local function mounted(id)
        id = tostring(id)
        if lia.workshop.runtimeMounted[id] ~= nil then return true end
        local addon = getAddonEntry(id)
        return addon ~= nil and addon.mounted == true
    end

    local function gmaDir()
        local dir = "lilia/workshop"
        if not file.IsDir(dir, "DATA") then file.CreateDir(dir) end
        return dir
    end

    local function gmaPath(id)
        return gmaDir() .. "/" .. id .. ".gma"
    end

    local function workshopState(id, addons)
        id = tostring(id)
        local addon = getAddonEntry(id, addons)
        local runtimeMount = lia.workshop.runtimeMounted[id]
        local runtimeDownload = lia.workshop.runtimeDownloaded[id]
        local subscribed = isSubscribed(id)
        local enabled = subscribed and shouldMount(id)
        local engineMounted = addon ~= nil and addon.mounted == true
        local runtimeMounted = runtimeMount ~= nil
        local cachedDownloaded = file.Exists(gmaPath(id), "DATA")
        local engineDownloaded = addon ~= nil and (addon.downloaded == true or addon.mounted == true)
        local isMounted = engineMounted or runtimeMounted
        local isDownloaded = isMounted or runtimeDownload ~= nil or cachedDownloaded or engineDownloaded
        local source = runtimeMounted and "Runtime GMA" or engineMounted and "Steam Workshop" or "Not Mounted"
        return {
            subscribed = subscribed,
            enabled = enabled,
            mounted = isMounted,
            downloaded = isDownloaded,
            engineMounted = engineMounted,
            runtimeMounted = runtimeMounted,
            runtimeDownloaded = runtimeDownload ~= nil,
            cachedDownloaded = cachedDownloaded,
            engineDownloaded = engineDownloaded,
            source = source
        }
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
        if success then
            lia.workshop.runtimeDownloaded[tostring(id)] = "data/" .. rel
            lia.workshop.runtimeMounted[tostring(id)] = {
                path = "data/" .. rel,
                files = files
            }
        end

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

    --[[
    Purpose:
        Checks whether the client is missing any server-required Workshop content that is not already mounted locally.

    Example Usage:
        ```lua
        if lia.workshop.hasContentToDownload() then
            chat.AddText(Color(255, 200, 0), "This server has workshop content ready to mount.")
        end
        ```

    Returns:
        boolean
            True when at least one required Workshop addon still needs to be downloaded or mounted, otherwise false.

    Realm:
        Client
]]
    function lia.workshop.hasContentToDownload()
        for id in pairs(lia.workshop.serverIds or {}) do
            if not mounted(id) and not mountLocal(id) then return true end
        end
        return false
    end

    --[[
    Purpose:
        Prompts the client to download and mount missing server-required Workshop content after calculating the total download size.

    Example Usage:
        ```lua
        if lia.workshop.hasContentToDownload() then
            lia.workshop.mountContent()
        end
        ```

    Realm:
        Client
]]
    function lia.workshop.mountContent()
        local ids = lia.workshop.serverIds or {}
        local needed = {}
        for id in pairs(ids) do
            if not mounted(id) and not mountLocal(id) then needed[#needed + 1] = id end
        end

        if #needed == 0 then
            lia.bootstrap(L("workshopDownloader"), L("workshopAllInstalled"))
            return
        end

        local pending, totalSize = #needed, 0
        for _, id in ipairs(needed) do
            steamworks.FileInfo(id, function(fi)
                if fi and fi.size then totalSize = totalSize + fi.size end
                pending = pending - 1
                if pending <= 0 then
                    lia.derma.requestPopupQuestion(L("workshopConfirmMount", formatSize(totalSize)), {
                        {
                            L("yes"),
                            function()
                                net.Start("liaWorkshopDownloaderRequest")
                                net.SendToServer()
                            end
                        },
                        {L("no")}
                    })
                end
            end)
        end
    end

    --[[
    Purpose:
        Attempts to remount already-downloaded server Workshop addons from the local data cache, falling back to the normal download flow if anything is missing.

    Example Usage:
        ```lua
        lia.workshop.remountContent()
        ```

    Realm:
        Client
]]
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

        if remountedAny or not lia.workshop.hasContentToDownload() then lia.bootstrap(L("workshopDownloader"), L("workshopAllInstalled")) end
    end

    local workshopSearchIcon = Material("icon16/magnifier.png", "smooth")
    local workshopLinkIcon = Material("icon16/world_go.png", "smooth")
    local workshopMountIcon = Material("icon16/drive_disk.png", "smooth")
    local workshopFallbackIcon = Material("icon16/package.png", "smooth")
    local workshopPreviewCache = {}
    local workshopPreviewCallbacks = {}
    local function drawWorkshopPanel(x, y, w, h, radius, color, outline)
        draw.RoundedBox(radius, x, y, w, h, color)
        if not outline then return end
        surface.SetDrawColor(outline)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end

    local function drawWorkshopIcon(material, x, y, size, color)
        if not material or material:IsError() then return end
        surface.SetMaterial(material)
        surface.SetDrawColor(color or color_white)
        surface.DrawTexturedRect(x, y, size, size)
    end

    local function formatWorkshopTime(value)
        local timestamp = tonumber(value)
        if not timestamp or timestamp <= 0 then return L("unknown") end
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

    local function createWorkshopButton(parent, label, icon, accented, callback)
        local button = parent:Add("DButton")
        button:SetText("")
        button.workshopLabel = label
        button.Paint = function(self, w, h)
            local accent, textColor = lia.color.theme.accent, lia.color.theme.text
            local hovered = self:IsHovered() and self:IsEnabled()
            local background
            local outline
            if accented then
                background = hovered and Color(accent.r, accent.g, accent.b, 32) or Color(accent.r, accent.g, accent.b, 16)
                outline = Color(accent.r, accent.g, accent.b, hovered and 185 or 120)
            else
                background = hovered and Color(255, 255, 255, 10) or Color(4, 17, 22, 210)
                outline = Color(160, 190, 192, hovered and 90 or 48)
            end

            if not self:IsEnabled() then
                background = Color(255, 255, 255, 5)
                outline = Color(255, 255, 255, 22)
            end

            drawWorkshopPanel(0, 0, w, h, 5, background, outline)
            local color = self:IsEnabled() and (accented and accent or textColor) or Color(115, 135, 136)
            local textX = 18
            if icon and not icon:IsError() then
                drawWorkshopIcon(icon, 16, math.floor((h - 16) * 0.5), 16, color)
                textX = 42
            end

            draw.SimpleText(tostring(self.workshopLabel or ""), "LiliaFont.17", textX, h * 0.5, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function(self)
            if not self:IsEnabled() then return end
            lia.websound.playButtonSound()
            callback()
        end
        return button
    end

    local function createWorkshopSection(parent, title)
        local section = parent:Add("DPanel")
        section:Dock(TOP)
        section:DockMargin(0, 0, 0, 12)
        section.Paint = function(_, w, h)
            local accent = lia.color.theme.accent
            drawWorkshopPanel(0, 0, w, h, 6, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
            draw.SimpleText(string.upper(title), "LiliaFont.17", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
            surface.DrawRect(16, 42, w - 32, 1)
        end
        return section
    end

    local function createWorkshopRows(section, rows)
        local rowHeight = 46
        section:SetTall(58 + #rows * rowHeight)
        section.Paint = function(_, w, h)
            local accent = lia.color.theme.accent
            drawWorkshopPanel(0, 0, w, h, 6, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
            draw.SimpleText(string.upper(section.sectionTitle or ""), "LiliaFont.17", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
            surface.DrawRect(16, 42, w - 32, 1)
            for i, row in ipairs(rows) do
                local y = 43 + (i - 1) * rowHeight
                if i > 1 then
                    surface.SetDrawColor(255, 255, 255, 17)
                    surface.DrawRect(16, y, w - 32, 1)
                end

                draw.SimpleText(row[1], "LiliaFont.17", 16, y + rowHeight * 0.5, Color(175, 197, 198), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(row[2], "LiliaFont.17", w - 16, y + rowHeight * 0.5, row[3] or Color(220, 232, 232), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
        end
    end

    hook.Add("CreateInformationButtons", "liaWorkshopInfo", function(pages)
        table.insert(pages, {
            name = "workshopAddons",
            shouldShow = function() return true end,
            drawFunc = function(parent)
                parent:Clear()
                local ids = lia.workshop.serverIds or {}
                local addonCount = table.Count(ids)
                local root = parent:Add("DPanel")
                root:Dock(FILL)
                root.Paint = function() end
                local listPanel = root:Add("DPanel")
                listPanel:Dock(LEFT)
                listPanel:SetWide(math.Clamp(ScrW() * 0.245, 340, 430))
                listPanel:DockMargin(0, 0, 12, 0)
                listPanel:DockPadding(12, 12, 12, 12)
                listPanel.Paint = function(_, w, h)
                    local accent = lia.color.theme.accent
                    drawWorkshopPanel(0, 0, w, h, 7, Color(5, 18, 23, 215), Color(accent.r, accent.g, accent.b, 58))
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
                    local accent = lia.color.theme.accent
                    drawWorkshopPanel(0, 0, w, h, 5, Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60))
                    draw.SimpleText(filter:GetValue(), "LiliaFont.16", 12, h * 0.5, Color(215, 229, 229), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText("▼", "LiliaFont.15", w - 14, h * 0.5, Color(175, 197, 198), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local searchPanel = controls:Add("DPanel")
                searchPanel:Dock(FILL)
                searchPanel:DockPadding(42, 0, 8, 0)
                searchPanel.Paint = function(_, w, h)
                    local accent = lia.color.theme.accent
                    drawWorkshopPanel(0, 0, w, h, 5, Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60))
                    drawWorkshopIcon(workshopSearchIcon, 14, math.floor((h - 16) * 0.5), 16, Color(165, 190, 192))
                end

                local searchEntry = searchPanel:Add("DTextEntry")
                searchEntry:Dock(FILL)
                searchEntry:SetFont("LiliaFont.16")
                searchEntry:SetTextColor(Color(225, 236, 236))
                searchEntry:SetCursorColor(lia.color.theme.accent)
                searchEntry:SetPlaceholderText(L("searchAddons"))
                searchEntry:SetPaintBackground(false)
                searchEntry:SetPaintBorderEnabled(false)
                local contentStats = {
                    total = addonCount,
                    subscribed = 0,
                    enabled = 0,
                    extracted = 0,
                    unextracted = addonCount,
                    downloaded = 0,
                    ready = 0,
                    missing = addonCount,
                    totalSize = 0,
                    extractedSize = 0
                }

                local downloadAllAddons
                local downloadAllButton = createWorkshopButton(listPanel, "DOWNLOAD ALL ADDONS", workshopMountIcon, true, function() if downloadAllAddons then downloadAllAddons() end end)
                downloadAllButton:Dock(TOP)
                downloadAllButton:SetTall(42)
                downloadAllButton:DockMargin(0, 0, 0, 12)
                local statsPanel = listPanel:Add("DPanel")
                statsPanel:Dock(TOP)
                statsPanel:SetTall(228)
                statsPanel:DockMargin(0, 0, 0, 12)
                statsPanel.Paint = function(_, w, h)
                    local accent, textColor = lia.color.theme.accent, lia.color.theme.text
                    drawWorkshopPanel(0, 0, w, h, 6, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
                    draw.SimpleText("CONTENT STATS", "LiliaFont.17", 14, 13, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
                    surface.DrawRect(14, 39, w - 28, 1)
                    local leftX = 14
                    local rightX = math.floor(w * 0.54)
                    draw.SimpleText("Total", "LiliaFont.15", leftX, 52, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.total), "LiliaFont.17", leftX + 62, 51, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Subscribed", "LiliaFont.15", rightX, 52, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.subscribed), "LiliaFont.17", w - 14, 51, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Mounted", "LiliaFont.15", leftX, 77, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.extracted), "LiliaFont.17", leftX + 76, 76, Color(60, 225, 160), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Unmounted", "LiliaFont.15", rightX, 77, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.unextracted), "LiliaFont.17", w - 14, 76, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Downloaded", "LiliaFont.15", leftX, 102, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.downloaded), "LiliaFont.17", leftX + 92, 101, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Ready to mount", "LiliaFont.15", rightX, 102, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.ready), "LiliaFont.17", w - 14, 101, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Missing", "LiliaFont.15", leftX, 127, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.missing), "LiliaFont.17", leftX + 62, 126, Color(225, 170, 90), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Enabled subs", "LiliaFont.15", rightX, 127, Color(160, 184, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(tostring(contentStats.enabled), "LiliaFont.17", w - 14, 126, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    local fraction = contentStats.totalSize > 0 and math.Clamp(contentStats.extractedSize / contentStats.totalSize, 0, 1) or 0
                    surface.SetDrawColor(255, 255, 255, 18)
                    surface.DrawRect(14, 157, w - 28, 5)
                    surface.SetDrawColor(60, 225, 160)
                    surface.DrawRect(14, 157, math.floor((w - 28) * fraction), 5)
                    draw.SimpleText(string.format("Mounted %s / %s", formatSize(contentStats.extractedSize), formatSize(contentStats.totalSize)), "LiliaFont.15", 14, 172, Color(175, 197, 198), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%.0f%%", fraction * 100), "LiliaFont.15", w - 14, 172, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Unmounted " .. formatSize(math.max(contentStats.totalSize - contentStats.extractedSize, 0)), "LiliaFont.15", 14, 196, Color(175, 197, 198), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end

                local sectionLabel = listPanel:Add("DLabel")
                sectionLabel:Dock(TOP)
                sectionLabel:SetTall(34)
                sectionLabel:SetText("INSTALLED ADDONS")
                sectionLabel:SetFont("LiliaFont.17")
                sectionLabel:SetTextColor(lia.color.theme.text)
                sectionLabel:SetContentAlignment(4)
                local countLabel = listPanel:Add("DLabel")
                countLabel:Dock(BOTTOM)
                countLabel:SetTall(28)
                countLabel:SetFont("LiliaFont.15")
                countLabel:SetTextColor(Color(145, 169, 170))
                countLabel:SetContentAlignment(4)
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
                    countLabel:SetText("0 addons")
                    local empty = listCanvas:Add("DLabel")
                    empty:Dock(TOP)
                    empty:SetTall(80)
                    empty:SetText(L("noWorkshopAddonsFound"))
                    empty:SetContentAlignment(5)
                    empty:SetTextColor(Color(150, 170, 170))
                    empty:SetFont("LiliaFont.18")
                    detailPanel.Paint = function(_, w, h)
                        local accent = lia.color.theme.accent
                        drawWorkshopPanel(0, 0, w, h, 7, Color(5, 18, 23, 190), Color(accent.r, accent.g, accent.b, 45))
                        draw.SimpleText(L("noWorkshopAddonsFound"), "LiliaFont.20", w * 0.5, h * 0.5, Color(150, 170, 170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    return
                end

                local records = {}
                local selectedCard
                local selectedRecord
                local selectedFilter = "all"
                local rebuildDetail
                local downloadingAll = false
                local function updateStats()
                    local subscribed = 0
                    local enabled = 0
                    local extracted = 0
                    local downloaded = 0
                    local ready = 0
                    local missing = 0
                    local extractedSize = 0
                    local calculatedTotalSize = 0
                    local selectedChanged = false
                    local addons = getAddonMap()
                    for _, record in ipairs(records) do
                        local state = workshopState(record.id, addons)
                        local changed = record.subscribed ~= state.subscribed or record.enabled ~= state.enabled or record.mounted ~= state.mounted or record.downloaded ~= state.downloaded or record.mountSource ~= state.source
                        record.subscribed = state.subscribed
                        record.enabled = state.enabled
                        record.mounted = state.mounted
                        record.downloaded = state.downloaded
                        record.mountSource = state.source
                        record.searchText = string.format("%s %s %s %s", record.title, record.id, record.mounted and "mounted" or record.downloaded and "downloaded" or "missing", record.subscribed and "subscribed" or "not subscribed"):lower()
                        if record.subscribed then subscribed = subscribed + 1 end
                        if record.enabled then enabled = enabled + 1 end
                        local size = tonumber(record.info and record.info.size) or 0
                        calculatedTotalSize = calculatedTotalSize + size
                        if record.mounted then
                            extracted = extracted + 1
                            downloaded = downloaded + 1
                            extractedSize = extractedSize + size
                        elseif record.downloaded then
                            downloaded = downloaded + 1
                            ready = ready + 1
                        else
                            missing = missing + 1
                        end

                        if changed and IsValid(record.card) then record.card:InvalidateLayout(true) end
                        if changed and record == selectedRecord then selectedChanged = true end
                    end

                    contentStats.total = #records > 0 and #records or addonCount
                    contentStats.subscribed = subscribed
                    contentStats.enabled = enabled
                    contentStats.extracted = extracted
                    contentStats.unextracted = math.max(contentStats.total - extracted, 0)
                    contentStats.downloaded = downloaded
                    contentStats.ready = ready
                    contentStats.missing = missing
                    contentStats.totalSize = calculatedTotalSize
                    contentStats.extractedSize = extractedSize
                    if IsValid(statsPanel) then statsPanel:InvalidateLayout(true) end
                    if IsValid(downloadAllButton) and not downloadingAll then
                        downloadAllButton.workshopLabel = contentStats.unextracted > 0 and "DOWNLOAD ALL ADDONS" or "ALL ADDONS MOUNTED"
                        downloadAllButton:SetEnabled(contentStats.unextracted > 0)
                    end

                    if selectedChanged and selectedRecord and rebuildDetail then rebuildDetail(selectedRecord) end
                end

                local function updateCount()
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

                local function mountRecord(record, notifyPlayer, callback)
                    local currentState = workshopState(record.id)
                    if currentState.mounted then
                        updateStats()
                        if callback then callback(true) end
                        return
                    end

                    local function mountedSuccessfully(path, files, stage)
                        local id = tostring(record.id)
                        lia.workshop.runtimeDownloaded[id] = path
                        lia.workshop.runtimeMounted[id] = {
                            path = path,
                            files = files
                        }

                        workshopDebug(id, stage, "Mounted successfully", "path=" .. tostring(path), "files=" .. tostring(istable(files) and #files or 0))
                        debugMountedFiles(id, files)
                        debugAddonState(id, stage .. " state")
                        timer.Simple(1, function()
                            workshopDebug(id, stage .. " +1s", "mounted()=" .. tostring(mounted(id)))
                            debugAddonState(id, stage .. " +1s")
                        end)

                        timer.Simple(5, function()
                            workshopDebug(id, stage .. " +5s", "mounted()=" .. tostring(mounted(id)))
                            debugAddonState(id, stage .. " +5s")
                        end)

                        updateStats()
                        if notifyPlayer then LocalPlayer():notifyLocalized("workshopAddonDownloaded", record.title or record.id) end
                        if IsValid(record.card) then record.card:InvalidateLayout(true) end
                        if selectedCard == record.card and rebuildDetail then rebuildDetail(record) end
                        applyFilters()
                        if callback then callback(true) end
                    end

                    local function tryMount(path, stage)
                        if not isstring(path) or path == "" then return false end
                        workshopDebug(record.id, stage, "Attempting MountGMA", path)
                        debugAddonState(record.id, stage .. " before")
                        local success, files = game.MountGMA(path)
                        workshopDebug(record.id, stage, "MountGMA success=" .. tostring(success), "returnedFiles=" .. tostring(istable(files) and #files or 0))
                        if not success then return false end
                        mountedSuccessfully(path, files, stage)
                        return true
                    end

                    local addon = getAddonEntry(record.id)
                    if addon and addon.downloaded == true and isstring(addon.file) and addon.file ~= "" then
                        if tryMount(addon.file, "Installed addon mount") then return end
                        workshopDebug(record.id, "Installed addon mount", "Existing GMA mount failed, falling back to DownloadUGC")
                    end

                    workshopDebug(record.id, "DownloadUGC", "Starting download", "title=" .. tostring(record.title))
                    debugAddonState(record.id, "Before DownloadUGC")
                    steamworks.DownloadUGC(record.id, function(path)
                        workshopDebug(record.id, "DownloadUGC callback", "path=" .. tostring(path), "type=" .. type(path))
                        if not isstring(path) or path == "" then
                            workshopDebug(record.id, "DownloadUGC", "FAILED: empty or invalid path")
                            if notifyPlayer then LocalPlayer():notifyErrorLocalized("workshopAddonDownloadFailed", record.title or record.id) end
                            if callback then callback(false) end
                            return
                        end

                        lia.workshop.runtimeDownloaded[tostring(record.id)] = path
                        updateStats()
                        if tryMount(path, "Downloaded addon mount") then return end
                        workshopDebug(record.id, "Downloaded addon mount", "FAILED")
                        updateStats()
                        if notifyPlayer then LocalPlayer():notifyErrorLocalized("workshopAddonDownloadFailed", record.title or record.id) end
                        if callback then callback(false) end
                    end)
                end

                downloadAllAddons = function()
                    if downloadingAll then return end
                    updateStats()
                    local queue = {}
                    for _, record in ipairs(records) do
                        if not record.mounted then queue[#queue + 1] = record end
                    end

                    if #queue == 0 then
                        updateStats()
                        return
                    end

                    downloadingAll = true
                    downloadAllButton:SetEnabled(false)
                    local index = 0
                    local succeeded = 0
                    local failed = 0
                    local function nextAddon()
                        index = index + 1
                        if index > #queue then
                            downloadingAll = false
                            downloadAllButton.workshopLabel = failed > 0 and string.format("DONE - %d FAILED", failed) or "ALL ADDONS MOUNTED"
                            updateStats()
                            workshopDebug("all", "Download All complete", "succeeded=" .. succeeded, "failed=" .. failed, "total=" .. #queue)
                            return
                        end

                        downloadAllButton.workshopLabel = string.format("DOWNLOADING %d / %d", index, #queue)
                        workshopDebug(queue[index].id, "Download All", "index=" .. index, "total=" .. #queue)
                        mountRecord(queue[index], false, function(success)
                            if success then
                                succeeded = succeeded + 1
                            else
                                failed = failed + 1
                            end

                            timer.Simple(0, nextAddon)
                        end)
                    end

                    nextAddon()
                end

                rebuildDetail = function(record)
                    detailPanel:Clear()
                    local accent, textColor = lia.color.theme.accent, lia.color.theme.text
                    local header = detailPanel:Add("DPanel")
                    header:Dock(TOP)
                    header:SetTall(140)
                    header:DockMargin(0, 0, 0, 12)
                    header.Paint = function(_, w, h)
                        drawWorkshopPanel(0, 0, w, h, 7, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
                        drawWorkshopIcon(record.previewMaterial or workshopFallbackIcon, 28, 22, 86, color_white)
                        draw.SimpleText(record.title, "LiliaFont.26", 136, 24, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        local statusColor = record.mounted and Color(60, 225, 160) or Color(145, 165, 166)
                        surface.SetDrawColor(statusColor)
                        surface.DrawRect(136, 66, 8, 8)
                        draw.SimpleText(record.mounted and "MOUNTED" or "NOT MOUNTED", "LiliaFont.16", 154, 70, statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Workshop content addon", "LiliaFont.17", 136, 92, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end

                    local mountButton
                    local workshopButton = createWorkshopButton(header, "WORKSHOP", workshopLinkIcon, false, function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. record.id) end)
                    workshopButton:SetSize(142, 42)
                    local function buildMountButton()
                        if IsValid(mountButton) then mountButton:Remove() end
                        local label = record.mounted and "MOUNTED" or string.upper(tostring(L("mount")))
                        mountButton = createWorkshopButton(header, label, workshopMountIcon, true, function() mountRecord(record, true) end)
                        mountButton:SetSize(142, 42)
                        mountButton:SetEnabled(not record.mounted)
                    end

                    buildMountButton()
                    header.PerformLayout = function(_, w)
                        mountButton:SetPos(w - 158, 49)
                        workshopButton:SetPos(w - 310, 49)
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

                    local infoSection = createWorkshopSection(canvas, "Addon Information")
                    infoSection.sectionTitle = "Addon Information"
                    local updatedValue = record.info.timeupdated or record.info.updated or record.info.time_updated
                    local statusColor = record.mounted and Color(60, 225, 160) or Color(170, 188, 189)
                    local rows = {{"Workshop ID", record.id}, {"Size", record.sizeText}, {"Subscription", record.subscribed and "Subscribed" or "Not Subscribed"}, {"Steam Enabled", record.enabled and "Enabled" or "Disabled"}, {"Downloaded", record.downloaded and "Yes" or "No"}, {"Status", record.mounted and "Mounted" or "Not Mounted", statusColor}, {"Mount Source", record.mountSource or "Not Mounted"}, {"Last Updated", formatWorkshopTime(updatedValue)}}
                    createWorkshopRows(infoSection, rows)
                    local progressSection = createWorkshopSection(canvas, "Mounted Content")
                    progressSection:SetTall(112)
                    progressSection.Paint = function(_, w, h)
                        drawWorkshopPanel(0, 0, w, h, 6, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
                        draw.SimpleText("MOUNTED CONTENT", "LiliaFont.17", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
                        surface.DrawRect(16, 42, w - 32, 1)
                        local fraction = record.mounted and 1 or 0
                        local barX = 16
                        local barY = 68
                        local barW = w - 96
                        surface.SetDrawColor(255, 255, 255, 18)
                        surface.DrawRect(barX, barY, barW, 4)
                        surface.SetDrawColor(record.mounted and Color(60, 225, 160) or Color(120, 140, 142))
                        surface.DrawRect(barX, barY, math.floor(barW * fraction), 4)
                        draw.SimpleText(record.mounted and "100%" or "0%", "LiliaFont.16", w - 16, barY + 2, record.mounted and Color(60, 225, 160) or Color(150, 170, 170), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(record.percent .. " of total server addon content", "LiliaFont.15", 16, 88, Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end

                    local descriptionSection = createWorkshopSection(canvas, "Description")
                    descriptionSection:SetTall(132)
                    descriptionSection.Paint = function(_, w, h)
                        drawWorkshopPanel(0, 0, w, h, 6, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
                        draw.SimpleText("DESCRIPTION", "LiliaFont.17", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 54)
                        surface.DrawRect(16, 42, w - 32, 1)
                        local description = tostring(record.info.description or "Workshop content addon")
                        draw.DrawText(description, "LiliaFont.16", 16, 60, Color(175, 197, 198), TEXT_ALIGN_LEFT)
                    end
                end

                local function selectRecord(record)
                    if selectedCard and IsValid(selectedCard) then selectedCard.selected = false end
                    selectedCard = record.card
                    selectedRecord = record
                    if IsValid(selectedCard) then selectedCard.selected = true end
                    rebuildDetail(record)
                end

                local function addRecord(record)
                    record.previewMaterial = workshopFallbackIcon
                    record.card = listCanvas:Add("DButton")
                    record.card:Dock(TOP)
                    record.card:SetTall(106)
                    record.card:DockMargin(0, 0, 0, 10)
                    record.card:SetText("")
                    record.card.selected = false
                    record.card.Paint = function(s, w, h)
                        local cardAccent, cardText = lia.color.theme.accent, lia.color.theme.text
                        local active = s.selected
                        local hovered = s:IsHovered()
                        local background = active and Color(cardAccent.r, cardAccent.g, cardAccent.b, 20) or hovered and Color(255, 255, 255, 6) or Color(5, 19, 24, 215)
                        drawWorkshopPanel(0, 0, w, h, 6, background, Color(cardAccent.r, cardAccent.g, cardAccent.b, active and 125 or 52))
                        if active then
                            surface.SetDrawColor(cardAccent.r, cardAccent.g, cardAccent.b, 235)
                            surface.DrawRect(0, 8, 3, h - 16)
                        end

                        drawWorkshopIcon(record.previewMaterial or workshopFallbackIcon, 18, 21, 62, color_white)
                        draw.SimpleText(record.title, "LiliaFont.20", 96, 18, cardText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        local statusColor = record.mounted and Color(60, 225, 160) or record.downloaded and Color(225, 190, 90) or Color(145, 165, 166)
                        local statusText = record.mounted and "Mounted" or record.downloaded and "Downloaded" or "Missing"
                        surface.SetDrawColor(statusColor)
                        surface.DrawRect(96, 51, 7, 7)
                        draw.SimpleText(statusText, "LiliaFont.15", 111, 55, statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(record.sizeText, "LiliaFont.15", w - 14, 55, Color(185, 205, 206), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(record.subscribed and (record.enabled and "Subscribed / Enabled" or "Subscribed / Disabled") or "Not subscribed", "LiliaFont.15", 96, 73, Color(155, 178, 179), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end

                    record.card.DoClick = function()
                        lia.websound.playButtonSound()
                        selectRecord(record)
                    end

                    loadWorkshopPreview(record.id, record.info.previewurl or "", function(material) record.previewMaterial = material or workshopFallbackIcon end)
                    records[#records + 1] = record
                end

                local info = {}
                local totalSize = 0
                local pending = addonCount
                local function populate()
                    local rows = {}
                    for id in pairs(ids) do
                        rows[#rows + 1] = {
                            id = id,
                            info = info[id] or {}
                        }
                    end

                    table.sort(rows, function(a, b) return tostring(a.info.title or a.id):lower() < tostring(b.info.title or b.id):lower() end)
                    for _, row in ipairs(rows) do
                        local fi = row.info
                        local share = totalSize > 0 and (fi.size or 0) / totalSize * 100 or 0
                        local state = workshopState(row.id)
                        local record = {
                            id = tostring(row.id),
                            info = fi,
                            title = tostring(fi.title or L("idPrefix", row.id)),
                            sizeText = fi.size and formatSize(fi.size) or "0 B",
                            subscribed = state.subscribed,
                            enabled = state.enabled,
                            mounted = state.mounted,
                            downloaded = state.downloaded,
                            mountSource = state.source,
                            percent = string.format("%.2f%%", share)
                        }

                        record.searchText = string.format("%s %s %s %s", record.title, record.id, record.mounted and "mounted" or record.downloaded and "downloaded" or "missing", record.subscribed and "subscribed" or "not subscribed"):lower()
                        addRecord(record)
                    end

                    updateStats()
                    applyFilters()
                    if records[1] then selectRecord(records[1]) end
                    root.nextWorkshopStateRefresh = 0
                    root.Think = function(self)
                        if RealTime() < (self.nextWorkshopStateRefresh or 0) then return end
                        self.nextWorkshopStateRefresh = RealTime() + 1
                        updateStats()
                        applyFilters()
                    end
                end

                for id in pairs(ids) do
                    steamworks.FileInfo(id, function(fi)
                        info[id] = fi
                        if fi and fi.size then totalSize = totalSize + fi.size end
                        pending = pending - 1
                        if pending <= 0 and IsValid(root) then populate() end
                    end)
                end
            end
        })
    end)
end
