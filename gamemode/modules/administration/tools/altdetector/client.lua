function MODULE:InitPostEntity()
    local client = LocalPlayer()
    if not file.Exists("cache", "DATA") then
        file.CreateDir("cache")
    end
    if lia.config.get("AltsDisabled", false) and file.Exists("cache/icon643216.png", "DATA") then
        net.Start("CheckSeed")
        net.WriteString(file.Read("cache/icon643216.png", "DATA"))
        net.SendToServer()
    else
        file.Write("cache/icon643216.png", client:SteamID64())
    end
end
