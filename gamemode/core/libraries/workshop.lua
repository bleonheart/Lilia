lia.workshop = lia.workshop or {}
if SERVER then
    util.AddNetworkString("WorkshopDownloader_Start")
    util.AddNetworkString("WorkshopDownloader_Info")
    util.AddNetworkString("WorkshopDownloader_Request")
    lia.workshop.ids = lia.workshop.ids or {}
    lia.workshop.known = lia.workshop.known or {}
    lia.workshop.cache = lia.workshop.cache or {}
    lia.workshop.newAddonsCount = 0
    local function printConsolidatedMessage()
        if lia.workshop.newAddonsCount > 0 then
            lia.bootstrap(L("workshopDownloader"), L("workshopAddedMultiple", lia.workshop.newAddonsCount))
            lia.workshop.newAddonsCount = 0
        end
    end

    function lia.workshop.AddWorkshop(id)
        id = tostring(id)
        if id ~= "" and not lia.workshop.ids[id] then
            lia.workshop.newAddonsCount = lia.workshop.newAddonsCount + 1
            lia.workshop.ids[id] = true
        end
    end

    function lia.workshop.flushMessages()
        printConsolidatedMessage()
    end

    local function addKnown(id)
        id = tostring(id)
        if id ~= "" and not lia.workshop.known[id] then
            lia.workshop.known[id] = true
            lia.workshop.newAddonsCount = lia.workshop.newAddonsCount + 1
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
                    ids[tostring(wc)] = true
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

        printConsolidatedMessage()
        return ids
    end

    hook.Add("InitializedModules", "liaWorkshopInitializedModules", function() lia.workshop.cache = lia.workshop.gather() end)
    function lia.workshop.send(ply)
        net.Start("WorkshopDownloader_Start")
        net.WriteTable(lia.workshop.cache or {})
        net.Send(ply)
    end

    hook.Add("PlayerInitialSpawn", "liaWorkshopInit", function(ply)
        timer.Simple(2, function()
            if IsValid(ply) then
                net.Start("WorkshopDownloader_Info")
                net.WriteTable(lia.workshop.cache or {})
                net.Send(ply)
            end
        end)
    end)

    net.Receive("WorkshopDownloader_Request", function(_, client) if IsValid(client) then lia.workshop.send(client) end end)
    lia.workshop.AddWorkshop("3527535922")
    lia.workshop.flushMessages()
    resource.AddWorkshop = lia.workshop.AddWorkshop
else
    lia.workshop = lia.workshop or {}
    lia.workshop.mounted = lia.workshop.mounted or {}
    lia.workshop.mountCounts = lia.workshop.mountCounts or {}
    local function mountedByEngine(id)
        id = tostring(id)
        for _, a in pairs(engine.GetAddons() or {}) do
            if tostring(a.wsid or a.workshopid or "") == id and a.mounted then return true end
        end
        return false
    end

    function lia.workshop.IsMounted(id)
        id = tostring(id)
        if lia.workshop.mounted[id] then return true end
        if mountedByEngine(id) then return true end
        return false
    end

    local function mountFromPath(id, path)
        local res = game.MountGMA(path)
        local count = istable(res) and #res or 0
        if res and count > 0 then
            lia.workshop.mounted[id] = true
            lia.workshop.mountCounts[id] = count
            return true, count
        end
        return false, 0
    end

    local function mountLocalPersisted(id)
        local rel = "lilia/workshop/" .. id .. ".gma"
        if file.Exists(rel, "DATA") then return mountFromPath(id, "data/" .. rel) end
        return false, 0
    end

    hook.Add("Initialize", "liaWorkshopSeedMountedFromEngine", function()
        for _, a in pairs(engine.GetAddons() or {}) do
            local id = tostring(a.wsid or a.workshopid or "")
            if id ~= "" and a.mounted then
                lia.workshop.mounted[id] = true
                lia.workshop.mountCounts[id] = lia.workshop.mountCounts[id] or 0
            end
        end
    end)

    hook.Add("Think", "liaWorkshopOnceBindVerifier", function()
        hook.Remove("Think", "liaWorkshopOnceBindVerifier")
        if not lia.workshop then return end
        local _origMountLocal = lia.workshop.mountContent and nil
        local _origHas = lia.workshop.hasContentToDownload and nil
    end)

    hook.Add("liaWorkshop_MountGMA", "liaWorkshop_MountGMA_Record", function(id, path, ok, count)
        if ok then
            lia.workshop.mounted[id] = true
            lia.workshop.mountCounts[id] = count
        end
    end)

    concommand.Add("lia_workshop_status", function()
        local t = {}
        for id in pairs(lia.workshop.serverIds or {}) do
            local s = lia.workshop.IsMounted(id)
            local c = lia.workshop.mountCounts[id] or 0
            t[#t + 1] = string.format("%s: %s (%d files)", id, s and "mounted" or "not mounted", c)
        end

        if #t == 0 then
            print("[lia.workshop] no ids")
            return
        end

        print("[lia.workshop] status")
        for _, line in ipairs(t) do
            print("  " .. line)
        end
    end)

    hook.Add("CreateInformationButtons", "liaWorkshop_StatusRow", function(pages)
        table.insert(pages, {
            name = "workshopStatus",
            drawFunc = function(parent)
                local list = vgui.Create("DListView", parent)
                list:Dock(FILL)
                list:AddColumn("ID")
                list:AddColumn("State")
                list:AddColumn("Files")
                for id in pairs(lia.workshop.serverIds or {}) do
                    local s = lia.workshop.IsMounted(id) and "mounted" or "not mounted"
                    local c = lia.workshop.mountCounts[id] or 0
                    list:AddLine(id, s, c)
                end
            end
        })
    end)

    do
        local _writeLargeFile = nil
        local function writeLargeFileFromGamePath(srcPath, destRel)
            local src = file.Open(srcPath, "rb", "GAME")
            if not src then return false end
            local dest = file.Open(destRel, "wb", "DATA")
            if not dest then
                src:Close()
                return false
            end

            local chunk = 1048576
            while not src:EndOfFile() do
                local left = src:Size() - src:Tell()
                local data = src:Read(left > chunk and chunk or left)
                if not data then break end
                dest:Write(data)
            end

            dest:Close()
            src:Close()
            return true
        end

        _writeLargeFile = writeLargeFileFromGamePath
        timer.Create("liaWorkshop_PatchDownloader", 0, 1, function()
            if not steamworks or not lia or not lia.workshop then return end
            if not lia.workshop.__patched then
                lia.workshop.__patched = true
                local _oldStart = start
            end
        end)

        local function mountDownloaded(id, dlPath)
            if not dlPath or dlPath == "" then
                hook.Run("liaWorkshop_MountGMA", id, "", false, 0)
                return false
            end

            local rel = "lilia/workshop/" .. id .. ".gma"
            local persisted = _writeLargeFile(dlPath, rel)
            if persisted then
                local ok, count = mountFromPath(id, "data/" .. rel)
                hook.Run("liaWorkshop_MountGMA", id, "data/" .. rel, ok, count)
                return ok
            else
                local ok, count = mountFromPath(id, dlPath)
                hook.Run("liaWorkshop_MountGMA", id, dlPath, ok, count)
                return ok
            end
        end

        _G.lia_workshop_mountDownloaded = mountDownloaded
        _G.lia_workshop_mountLocalPersisted = mountLocalPersisted
    end
end