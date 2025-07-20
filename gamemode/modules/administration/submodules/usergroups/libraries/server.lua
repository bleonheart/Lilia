net.Receive("liaGroupsRequest", function(_, client)
    if not client:hasPrivilege("Staff Permissions - Manage UserGroups") then return end
    net.Start("liaGroupsData")
    net.WriteTable(CAMI.GetUsergroups() or {})
    net.Send(client)
end)

util.AddNetworkString("liaGroupsAdd")
util.AddNetworkString("liaGroupsRemove")

local function broadcastGroups()
    net.Start("liaGroupsData")
    net.WriteTable(CAMI.GetUsergroups() or {})
    net.Broadcast()
end

net.Receive("liaGroupsAdd", function(_, client)
    if not client:hasPrivilege("Staff Permissions - Manage UserGroups") then return end
    local name = net.ReadString()
    if name and name ~= "" then
        lia.admin.createGroup(name)
        broadcastGroups()
    end
end)

net.Receive("liaGroupsRemove", function(_, client)
    if not client:hasPrivilege("Staff Permissions - Manage UserGroups") then return end
    local name = net.ReadString()
    if name and name ~= "" then
        lia.admin.removeGroup(name)
        broadcastGroups()
    end
end)