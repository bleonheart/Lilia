lia.workshop = lia.workshop or {}
if SERVER then
    lia.workshop.ids = lia.workshop.ids or {}
    lia.workshop.known = lia.workshop.known or {}
    lia.workshop.cache = lia.workshop.cache or {}
    function lia.workshop.AddWorkshop(id)
        id = tostring(id)
        if not lia.workshop.ids[id] then lia.bootstrap("Workshop Downloader", L("workshopAdded", id)) end
        lia.bootstrap("Workshop Downloader", L("workshopDownloading", id))
        lia.workshop.ids[id] = true
    end

    local function addKnown(id)
        id = tostring(id)
        if not lia.workshop.known[id] then
            lia.workshop.known[id] = true
            lia.bootstrap("Workshop Downloader", L("workshopAdded", id))
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
        net.Start("WorkshopDownloader_Start")
        net.WriteTable(lia.workshop.cache)
        net.Send(ply)
    end

    hook.Add("PlayerInitialSpawn", "liaWorkshopInit", function(ply)
        if not lia.config.get("AutoDownloadWorkshop", true) then return end
        timer.Simple(2, function()
            if IsValid(ply) then
                net.Start("WorkshopDownloader_Info")
                net.WriteTable(lia.workshop.cache or {})
                net.Send(ply)
            end
        end)
    end)

    net.Receive("WorkshopDownloader_Request", function(_, client)
        if not lia.config.get("AutoDownloadWorkshop", true) then return end
        lia.workshop.send(client)
    end)

    lia.workshop.AddWorkshop("3527535922")
    resource.AddWorkshop = lia.workshop.AddWorkshop
else
    local FORCE_ID = "3527535922"
    local MOUNT_DELAY = 3
    local queue, panel, totalDownloads, remainingDownloads = {}, nil, 0, 0
    lia.workshop.serverIds = lia.workshop.serverIds or {}
    local downloadFrame
    local function mounted(id)
        for _, addon in pairs(engine.GetAddons() or {}) do
            if tostring(addon.wsid or addon.workshopid) == tostring(id) and addon.mounted then return true end
        end
        return false
    end

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

    local function showPrompt(total, have, size)
        if IsValid(downloadFrame) then return end
        local text = L("workshopDownloadPrompt", total - have, total, formatSize(size))
        local frame = vgui.Create("DFrame")
        downloadFrame = frame
        frame:SetTitle(L("downloads"))
        frame:SetSize(500, 150)
        frame:Center()
        frame:MakePopup()
        frame:SetZPos(10000)
        frame:MoveToFront()
        local lbl = frame:Add("DLabel")
        lbl:Dock(TOP)
        lbl:SetWrap(true)
        lbl:SetText(text)
        lbl:DockMargin(10, 10, 10, 10)
        lbl:SetTall(60)
        local btnPanel = frame:Add("DPanel")
        btnPanel:Dock(BOTTOM)
        btnPanel:SetTall(40)
        btnPanel.Paint = nil
        local btnWidth = (frame:GetWide() - 5) / 2
        local yes = btnPanel:Add("DButton")
        yes:Dock(LEFT)
        yes:SetText(L("yes"))
        yes:DockMargin(0, 0, 5, 0)
        yes:SetWide(btnWidth)
        yes.DoClick = function()
            lia.option.set("autoDownloadWorkshop", true)
            net.Start("WorkshopDownloader_Request")
            net.SendToServer()
            frame:Close()
        end

        local no = btnPanel:Add("DButton")
        no:Dock(RIGHT)
        no:SetText(L("no"))
        no:SetWide(btnWidth)
        no.DoClick = function()
            lia.option.set("autoDownloadWorkshop", false)
            frame:Close()
        end
    end

    local function uiCreate()
        if panel and panel:IsValid() then return end
        surface.SetFont("DermaLarge")
        local title = L("downloadingWorkshopAddonsTitle")
        local tw, th = surface.GetTextSize(title)
        local pad, bh = 10, 20
        local w, h = math.max(tw, 200) + pad * 2, th + bh + pad * 3
        panel = vgui.Create("DPanel")
        panel:SetSize(w, h)
        panel:SetPos((ScrW() - w) / 2, ScrH() * 0.1)
        panel:SetZPos(10000)
        panel:MoveToFront()
        derma.SkinHook("Paint", "Panel", panel, w, h)
        local lbl = vgui.Create("DLabel", panel)
        lbl:SetFont("DermaLarge")
        lbl:SetText(title)
        lbl:SizeToContents()
        lbl:SetPos(pad, pad)
        panel.bar = vgui.Create("DProgressBar", panel)
        panel.bar:SetPos(pad, pad + th + pad)
        panel.bar:SetSize(w - pad * 2, bh)
        panel.bar:SetFraction(0)
    end

    local function uiUpdate()
        if not (panel and panel:IsValid()) then return end
        panel.bar:SetFraction(totalDownloads > 0 and (totalDownloads - remainingDownloads) / totalDownloads or 0)
        panel.bar:SetText(totalDownloads - remainingDownloads .. "/" .. totalDownloads)
    end

    local function start()
        for id in pairs(queue) do
            if mounted(id) then queue[id] = nil end
        end

        local seq, idx = {}, 1
        for id in pairs(queue) do
            seq[#seq + 1] = id
        end

        totalDownloads = #seq
        remainingDownloads = totalDownloads
        if totalDownloads == 0 then
            lia.bootstrap("Workshop Downloader", L("workshopAllInstalled"))
            return
        end

        uiCreate()
        uiUpdate()
        local function nextItem()
            if idx > #seq then
                if panel and panel:IsValid() then
                    panel:Remove()
                    panel = nil
                end
                return
            end

            local id = seq[idx]
            lia.bootstrap("Workshop Downloader", L("workshopDownloading", id))
            steamworks.DownloadUGC(id, function(path)
                remainingDownloads = remainingDownloads - 1
                lia.bootstrap("Workshop Downloader", L("workshopDownloadComplete", id))
                if path then game.MountGMA(path) end
                uiUpdate()
                idx = idx + 1
                timer.Simple(MOUNT_DELAY, nextItem)
            end)
        end

        nextItem()
    end

    local function buildQueue(all)
        table.Empty(queue)
        for id in pairs(lia.workshop.serverIds or {}) do
            if id == FORCE_ID or all then queue[id] = true end
        end
    end

    local function refresh(tbl)
        if tbl then lia.workshop.serverIds = tbl end
    end

    function lia.workshop.checkPrompt()
        local opt = lia.option.get("autoDownloadWorkshop")
        local ids = lia.workshop.serverIds or {}
        local totalIds = table.Count(ids)
        local have, missing = 0, {}
        for id in pairs(ids) do
            if mounted(id) then
                have = have + 1
            else
                missing[#missing + 1] = id
            end
        end

        local forcedMissing = not mounted(FORCE_ID)
        if forcedMissing then
            buildQueue(false)
            start()
        end

        if opt == nil then
            local size, pending = 0, #missing
            if pending == 0 then
                showPrompt(totalIds, have, 0)
                return
            end

            for _, id in ipairs(missing) do
                steamworks.FileInfo(id, function(fi)
                    if fi and fi.size then size = size + fi.size end
                    pending = pending - 1
                    if pending <= 0 then showPrompt(totalIds, have, size) end
                end)
            end
        elseif opt then
            buildQueue(true)
            start()
        end
    end

    net.Receive("WorkshopDownloader_Start", function()
        refresh(net.ReadTable())
        buildQueue(true)
        start()
    end)

    net.Receive("WorkshopDownloader_Info", function()
        refresh(net.ReadTable())
        lia.workshop.checkPrompt()
    end)

    hook.Add("InitializedOptions", "liaWorkshopPromptCheck", function() timer.Simple(0, lia.workshop.checkPrompt) end)
    concommand.Add("workshop_force_redownload", function()
        table.Empty(queue)
        buildQueue(true)
        start()
        lia.bootstrap("Workshop Downloader", L("workshopForcedRedownload"))
    end)

    hook.Add("CreateInformationButtons", "liaWorkshopInfo", function(pages)
        if not lia.config.get("AutoDownloadWorkshop", true) then return end
        table.insert(pages, {
            name = L("workshopAddons"),
            drawFunc = function(parent)
                local ids = lia.workshop.serverIds or {}
                local sheet = vgui.Create("liaSheet", parent)
                sheet:SetPlaceholderText(L("searchAddons"))

                local info, totalSize = {}, 0
                local pending = table.Count(ids)
                if pending <= 0 then return end

                local function populate()
                    for id, fi in pairs(info) do
                        if not fi then continue end
                        local title = fi.title or string.format(L("idPrefix"), id)
                        local percent = totalSize > 0 and string.format("%.2f%%", (fi.size or 0) / totalSize * 100) or "0%"
                        local desc = fi.size and L("addonSize", formatSize(fi.size), percent) or ""
                        local url = fi.previewurl or ""
                        if sheet.AddPreviewRow then
                            sheet:AddPreviewRow({
                                title = title,
                                desc = desc,
                                url = url,
                                size = 64
                            })
                        elseif sheet.AddTextRow then
                            sheet:AddTextRow({
                                title = title,
                                desc = desc,
                                compact = true
                            })
                        end
                    end

                    if IsValid(sheet) and sheet.Refresh then sheet:Refresh() end
                end

                for id in pairs(ids) do
                    steamworks.FileInfo(id, function(fi)
                        info[id] = fi
                        if fi and fi.size then totalSize = totalSize + fi.size end
                        pending = pending - 1
                        if pending <= 0 then populate() end
                    end)
                end
            end
        })
    end)
end