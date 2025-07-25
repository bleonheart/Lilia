﻿lia.workshop = lia.workshop or {}
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

    -- netcall moved to netcalls
    lia.workshop.AddWorkshop("3527535922")
    resource.AddWorkshop = lia.workshop.AddWorkshop
else
    local FORCE_ID = "3527535922"
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

        totalDownloads = table.Count(queue)
        remainingDownloads = totalDownloads
        if totalDownloads == 0 then
            lia.bootstrap("Workshop Downloader", L("workshopAllInstalled"))
            return
        end

        uiCreate()
        uiUpdate()
        for id in pairs(queue) do
            lia.bootstrap("Workshop Downloader", L("workshopDownloading", id))
            steamworks.DownloadUGC(id, function(path)
                remainingDownloads = remainingDownloads - 1
                lia.bootstrap("Workshop Downloader", L("workshopDownloadComplete", id))
                if path then game.MountGMA(path) end
                uiUpdate()
                if remainingDownloads <= 0 and panel and panel:IsValid() then
                    panel:Remove()
                    panel = nil
                end
            end)
        end
    end

    lia.workshop.start = start
    local function buildQueue(all)
        table.Empty(queue)
        for id in pairs(lia.workshop.serverIds or {}) do
            if id == FORCE_ID or all then queue[id] = true end
        end
    end

    lia.workshop.buildQueue = buildQueue
    local function refresh(tbl)
        if tbl then lia.workshop.serverIds = tbl end
    end

    lia.workshop.refresh = refresh
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

    -- netcalls moved to netcalls
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
            drawFunc = function(container)
                local ids = lia.workshop.serverIds or {}
                local searchEntry = vgui.Create("DTextEntry", container)
                searchEntry:Dock(TOP)
                searchEntry:DockMargin(0, 0, 0, 5)
                searchEntry:SetTall(30)
                searchEntry:SetPlaceholderText(L("searchAddons"))
                local scroll = vgui.Create("DScrollPanel", container)
                scroll:Dock(FILL)
                scroll:DockPadding(0, 10, 0, 0)
                local canvas = scroll:GetCanvas()
                local function createItem(id, size)
                    steamworks.FileInfo(id, function(fileInfo)
                        if not fileInfo then return end
                        local panel = vgui.Create("DPanel", canvas)
                        panel:Dock(TOP)
                        panel:DockMargin(0, 0, 0, 10)
                        panel.titleText = (fileInfo.title or ""):lower()
                        local preview = vgui.Create("DHTML", panel)
                        preview:SetSize(size, size)
                        preview:OpenURL(fileInfo.previewurl)
                        local titleLabel = vgui.Create("DLabel", panel)
                        titleLabel:SetFont("liaBigFont")
                        titleLabel:SetText(fileInfo.title or "ID:" .. id)
                        local descLabel = vgui.Create("DLabel", panel)
                        descLabel:SetFont("liaMediumFont")
                        descLabel:SetWrap(true)
                        descLabel:SetText(fileInfo.description or "")
                        function panel:PerformLayout()
                            local pad = 10
                            preview:SetPos(pad, pad)
                            titleLabel:SizeToContents()
                            titleLabel:SetPos(pad + size + pad, pad)
                            descLabel:SetPos(pad + size + pad, pad + titleLabel:GetTall() + 5)
                            descLabel:SetWide(self:GetWide() - pad - size - pad)
                            local _, h = descLabel:GetContentSize()
                            descLabel:SetTall(h)
                            self:SetTall(math.max(size + pad * 2, titleLabel:GetTall() + 5 + h + pad))
                        end
                    end)
                end

                for id in pairs(ids) do
                    createItem(id, 200)
                end

                searchEntry.OnTextChanged = function(entry)
                    local query = entry:GetValue():lower()
                    for _, child in ipairs(canvas:GetChildren()) do
                        if child.titleText then child:SetVisible(query == "" or child.titleText:find(query, 1, true)) end
                    end

                    canvas:InvalidateLayout()
                    canvas:SizeToChildren(false, true)
                end
            end
        })
    end)
end