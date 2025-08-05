GM.Name = "Lilia"
GM.version = 7.732
GM.Author = "Samael"
GM.Website = "https://discord.gg/esCRH5ckbQ"
include("core/libraries/loader.lua")
local originalStart = net.Start
local originalReceive = net.Receive
function net.Start(name, unreliable)
    if SERVER and util.NetworkStringToID(name) == 0 then util.AddNetworkString(name) end
    return originalStart(name, unreliable)
end

function net.Receive(name, callback)
    if SERVER and util.NetworkStringToID(name) == 0 then util.AddNetworkString(name) end
    return originalReceive(name, callback)
end