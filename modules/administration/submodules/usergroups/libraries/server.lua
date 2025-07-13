util.AddNetworkString("liaRequestUsergroups")
util.AddNetworkString("liaSendUsergroups")
util.AddNetworkString("liaCreateUsergroup")
util.AddNetworkString("liaRemoveUsergroup")

net.Receive("liaRequestUsergroups", function(_, client)
    if not client:IsAdmin() then return end
    net.Start("liaSendUsergroups")
    net.WriteTable(lia.admin.groups or {})
    net.Send(client)
end)

net.Receive("liaCreateUsergroup", function(_, client)
    if not client:IsSuperAdmin() then return end
    local name = net.ReadString():Trim()
    if name == "" or lia.admin.groups[name] then return end
    lia.admin.createGroup(name)
    lia.admin.save(true)
end)

net.Receive("liaRemoveUsergroup", function(_, client)
    if not client:IsSuperAdmin() then return end
    local name = net.ReadString()
    if not lia.admin.groups[name] then return end
    lia.admin.removeGroup(name)
    lia.admin.save(true)
end)
