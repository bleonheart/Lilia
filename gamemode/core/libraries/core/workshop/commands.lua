if SERVER then
    concommand.Add("lia_redownload_assets", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.loader.downloadAssets()
        lia.information("Assets Redownloaded")
    end)
end
