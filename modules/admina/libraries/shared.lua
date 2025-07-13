local meta = FindMetaTable("Player")
function meta:hasPermission(cmd)
	return lia.admin.permissions[self:GetUserGroup()] and lia.admin.permissions[self:GetUserGroup()]["permissions"][cmd] or false
end