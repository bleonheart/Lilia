if CLIENT then
    net.Receive("liaAssureClientSideAssets", function()
        lia.webcontent.image.clearCache(true)
        lia.webcontent.sound.clearCache(true)
        local webimages = lia.webcontent.image.stored
        local websounds = lia.webcontent.sound.stored
        local downloadQueue = {}
        local activeDownloads = 0
        local maxConcurrent = 5
        local totalImages = table.Count(webimages)
        local totalSounds = table.Count(websounds)
        local completedImages = 0
        local completedSounds = 0
        local failedImages = 0
        local failedSounds = 0
        for name, data in pairs(webimages) do
            table.insert(downloadQueue, {
                type = "image",
                name = name,
                url = data.url,
                flags = data.flags
            })
        end

        for name, url in pairs(websounds) do
            table.insert(downloadQueue, {
                type = "sound",
                name = name,
                url = url
            })
        end

        lia.information("Download queue size:" .. ": " .. #downloadQueue)
        lia.information("Processing with max concurrent downloads:" .. ": " .. maxConcurrent)
        local function processNextDownload()
            if #downloadQueue == 0 then return end
            local download = table.remove(downloadQueue, 1)
            activeDownloads = activeDownloads + 1
            if download.type == "image" then
                lia.webcontent.image.download(download.name, download.url, function(material, fromCache, errorMsg)
                    activeDownloads = activeDownloads - 1
                    if material then
                        completedImages = completedImages + 1
                        if not fromCache then lia.information("Image downloaded" .. ": " .. download.name) end
                    else
                        failedImages = failedImages + 1
                        local errorMessage = errorMsg or "Unknown error"
                        lia.warning("Image failed" .. ": " .. download.name .. " - " .. errorMessage)
                        chat.AddText(Color(255, 100, 100), "Image Download", Color(255, 255, 255), string.format("Failed to download image %s: %s", download.name, errorMessage))
                    end

                    processNextDownload()
                end, download.flags)
            elseif download.type == "sound" then
                lia.webcontent.sound.download(download.name, download.url, function(path, fromCache, errorMsg)
                    activeDownloads = activeDownloads - 1
                    if path then
                        completedSounds = completedSounds + 1
                    else
                        failedSounds = failedSounds + 1
                        local errorMessage = errorMsg or "Unknown error"
                        chat.AddText(Color(255, 100, 100), "[Sound Download] ", Color(255, 255, 255), string.format("Failed to download: %s (%s)", download.name, errorMessage))
                    end

                    processNextDownload()
                end)
            end
        end

        for _ = 1, math.min(maxConcurrent, #downloadQueue) do
            processNextDownload()
        end

        timer.Create("AssetDownloadProgress", 2, 0, function()
            if activeDownloads == 0 and #downloadQueue == 0 then
                timer.Remove("AssetDownloadProgress")
                lia.option.load()
                lia.keybind.load()
                timer.Simple(1.0, function()
                    local imageStats = lia.webcontent.image.getStats()
                    local soundStats = lia.webcontent.sound.getStats()
                    lia.bootstrap("AssetDownload", "===========================================")
                    lia.bootstrap("AssetDownload", "=== CLIENT-SIDE ASSETS DOWNLOAD COMPLETE ===")
                    lia.bootstrap("AssetDownload", "Download Summary")
                    lia.bootstrap("AssetDownload", string.format("Images: %d/%d completed (%d failed)", completedImages, totalImages, failedImages))
                    lia.bootstrap("AssetDownload", string.format("Sounds: %d/%d completed (%d failed)", completedSounds, totalSounds, failedSounds))
                    lia.bootstrap("AssetDownload", "Current Statistics")
                    lia.bootstrap("AssetDownload", string.format("Images: %d downloaded | %d stored", imageStats.downloaded, imageStats.stored))
                    lia.bootstrap("AssetDownload", string.format("Sounds: %d downloaded | %d stored", soundStats.downloaded, soundStats.stored))
                    lia.bootstrap("AssetDownload", string.format("Combined: %d downloaded | %d stored", imageStats.downloaded + soundStats.downloaded, imageStats.stored + soundStats.stored))
                    lia.bootstrap("AssetDownload", "===========================================")
                    if failedImages > 0 or failedSounds > 0 then
                        lia.warning("WARNING: Some assets failed to download. Check console output above for details.")
                        if failedImages > 0 then chat.AddText(Color(255, 150, 100), "[Asset Download] ", Color(255, 255, 255), string.format("Warning: %s %s failed to download.", failedImages, "image(s)")) end
                        if failedSounds > 0 then chat.AddText(Color(255, 150, 100), "[Asset Download] ", Color(255, 255, 255), string.format("Warning: %s %s failed to download.", failedSounds, "sound(s)")) end
                    else
                        chat.AddText(Color(100, 255, 100), "[Asset Download] ", Color(255, 255, 255), "All assets downloaded successfully.")
                    end
                end)
            end
        end)
    end)
end