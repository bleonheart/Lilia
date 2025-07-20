net.Receive("liaGroupsRequest", function(_, client)
    if not client:hasPrivilege("Staff Permissions - Manage UserGroups") then return end
    net.Start("liaGroupsData")
    net.WriteTable(CAMI.GetUsergroups() or {})
    net.Send(client)
end)