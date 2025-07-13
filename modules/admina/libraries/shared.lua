local meta = FindMetaTable("Player")
function meta:hasPermission(cmd)
	return lia.admin.permissions[self:GetUserGroup()] and lia.admin.permissions[self:GetUserGroup()]["permissions"][cmd] or false
end

function meta:IsAdmin()
	if not lia.admin.permissions[self:GetUserGroup()] then return false end
	return lia.admin.permissions[self:GetUserGroup()].admin or lia.admin.permissions[self:GetUserGroup()].superadmin or false
end

function meta:IsSuperAdmin()
	if not lia.admin.permissions[self:GetUserGroup()] then return false end
	return lia.admin.permissions[self:GetUserGroup()].superadmin or false
end