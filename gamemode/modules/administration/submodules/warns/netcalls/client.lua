local MODULE = MODULE
net.Receive("PlayerWarnings", function()
    local MODULE = lia.module.get("warns")
    local warnings = net.ReadTable()
    if IsValid(MODULE.warnList) then
        MODULE.warnList:Clear()
        for _, w in ipairs(warnings) do
            MODULE.warnList:AddLine(w.warned or "", w.warnedSteamID or "", w.admin or "", w.adminSteamID or "", w.warning or "", w.timestamp or "")
        end
    end
end)
