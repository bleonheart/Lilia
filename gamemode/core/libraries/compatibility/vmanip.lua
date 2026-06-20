util.AddNetworkString("PlayPickupAnimation")
hook.Add("OnPlayerInteractItem", "PlayPickupAnimationOnTake", function(client, action, item)
    if action ~= "take" or not item or item.VManipDisabled then return end
    net.Start("PlayPickupAnimation")
    net.WriteString(item.uniqueID)
    net.Send(client)
end)

net.Receive("PlayPickupAnimation", function()
    if not VManip then return end
    local itemID = net.ReadString()
    local item = lia.item.list[itemID]
    if not item or item.VManipDisabled or not VManip.PlayAnim then return end
    VManip:PlayAnim("interactslower")
end)