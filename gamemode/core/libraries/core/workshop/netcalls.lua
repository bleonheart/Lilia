if CLIENT then
local function uiCreate()
    if panel and panel:IsValid() then return end
    local pad, bh = 10, 40
    local w, h = 400 + pad * 2, 80
    panel = vgui.Create("liaFrame")
    panel:SetSize(w, h)
    panel:SetPos((ScrW() - w) / 2, ScrH() * 0.1)
    panel:SetZPos(999999)
    panel:MoveToFront()
    panel:SetTitle("")
    panel:SetCenterTitle("Downloading Workshop Addons")
    panel:ShowAnimation()
    panel.bar = vgui.Create("liaProgressBar", panel)
    panel.bar:SetPos(pad, h * 0.65 - bh / 2)
    panel.bar:SetSize(w - pad * 2, bh)
    panel.bar:SetFraction(0)
end

local queue = {}
local MOUNT_DELAY = 3
local function gmaPath(id)
    return "lilia/workshop/" .. id .. ".gma"
end

local function mounted(id)
    for _, addon in pairs(engine.GetAddons() or {}) do
        if tostring(addon.wsid or addon.workshopid) == tostring(id) and addon.mounted then return true end
    end
    return false
end

local function mountLocal(id)
    local rel = gmaPath(id)
    if file.Exists(rel, "DATA") then
        game.MountGMA("data/" .. rel)
        return true
    end
    return false
end

local function uiUpdate()
    if not (panel and panel:IsValid()) then return end
    panel.bar:SetFraction(totalDownloads > 0 and (totalDownloads - remainingDownloads) / totalDownloads or 0)
    panel.bar:SetText((totalDownloads - remainingDownloads) .. "/" .. totalDownloads)
end

local function start()
    for id in pairs(queue) do
        if mounted(id) or mountLocal(id) then queue[id] = nil end
    end

    local seq, idx = {}, 1
    for id in pairs(queue) do
        seq[#seq + 1] = id
    end

    totalDownloads = #seq
    remainingDownloads = totalDownloads
    if totalDownloads == 0 then
        lia.bootstrap("Workshop Downloader", "All workshop addons already installed. Skipping download.")
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
        lia.bootstrap("Workshop Downloader", string.format("Downloading workshop %s", id))
        steamworks.DownloadUGC(id, function(path)
            remainingDownloads = remainingDownloads - 1
            lia.bootstrap("Workshop Downloader", string.format("Completed workshop %s", id))
            if path then
                local rel = gmaPath(id)
                local data = file.Read(path, "GAME")
                if data then
                    file.Write(rel, data)
                    path = "data/" .. rel
                end

                game.MountGMA(path)
            end

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
    local ids = {}
    for id in pairs(lia.workshop.serverIds or {}) do
        if id ~= FORCE_ID then ids[#ids + 1] = id end
    end

    if #ids == 0 then return end
    local idx = 1
    local function mountNext()
        if idx > #ids then return end
        local id = ids[idx]
        mountLocal(id)
        idx = idx + 1
        if idx <= #ids then timer.Simple(MOUNT_DELAY, mountNext) end
    end

    mountNext()
end

net.Receive("liaWorkshopDownloaderStart", function()
    refresh(net.ReadTable())
    buildQueue(true)
    start()
end)

concommand.Add("workshop_force_redownload", function()
    table.Empty(queue)
    buildQueue(true)
    start()
end)

net.Receive("liaWorkshopDownloaderInfo", function() refresh(net.ReadTable()) end)
end

if SERVER then
net.Receive("liaWorkshopDownloaderRequest", function(_, client) lia.workshop.send(client) end)
end
