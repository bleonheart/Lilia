local GM = GM or GAMEMODE
local nextRefresh = 0
local function setServerSetting(name, value)
    if name == "freeze" then
        RunConsoleCommand("sh_perfopus_freeze", value and "1" or "0")
        return
    end

    if name == "refresh" then
        local refresh = math.Clamp(tonumber(value) or 2, 0.1, 5)
        RunConsoleCommand("sh_perfopus_refresh_rate", tostring(refresh))
    end
end

local function sendMetrics()
    local readable = PERFOPUS.GetReadableMetrics()
    for _, client in player.Iterator() do
        if PERFOPUS.CanViewMetrics(client) and client:GetInfoNum("cl_perfopus_showing_metrics", 0) > 0 then
            for source, data in pairs(readable) do
                net.Start("liaPerfopusMetric")
                net.WriteString(source)
                net.WriteString(PERFOPUS.MakeToolTipString(data.funcs, 10))
                net.WriteUInt(data.realm, 1)
                net.WriteFloat(data.time)
                net.Send(client)
            end
        end
    end
end

function MODULE:Think()
    if not PERFOPUS.Started or PERFOPUS.FREEZE:GetBool() then return end
    if nextRefresh > CurTime() then return end
    sendMetrics()
    table.Empty(PERFOPUS.Metrics)
    nextRefresh = CurTime() + math.Clamp(PERFOPUS.REFRESH_RATE:GetFloat(), 0.1, 5)
end

net.Receive("liaPerfopusStart", function(_, client)
    if not PERFOPUS.CanViewMetrics(client) then return end
    PERFOPUS.StartProfiling()
end)

net.Receive("liaPerfopusSettings", function(_, client)
    if not PERFOPUS.CanViewMetrics(client) then return end
    local setting = net.ReadString()
    if setting == "freeze" then
        setServerSetting(setting, net.ReadBool())
    elseif setting == "refresh" then
        setServerSetting(setting, net.ReadFloat())
    end
end)