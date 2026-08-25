local MODULE = MODULE
net.Receive("liaAdminStickPlayerState", function()
    local target = net.ReadEntity()
    local state = net.ReadTable() or {}
    if not (IsValid(target) and target:IsPlayer()) then return end
    MODULE.adminStickPlayerStates[target] = state
    if IsValid(AdminStickMenu) and AdminStickMenu.target == target and AdminStickMenu.OnPlayerStateUpdated then AdminStickMenu:OnPlayerStateUpdated(state) end
end)
