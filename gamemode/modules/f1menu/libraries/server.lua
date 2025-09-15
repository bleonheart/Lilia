function MODULE:PlayerDeath(client)
    net.Start("liaRemoveF1")
    net.Send(client)
end

function MODULE:ShowHelp()
    return false
end
