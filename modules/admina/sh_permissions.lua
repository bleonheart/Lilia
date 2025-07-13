local PLUGIN = PLUGIN
local meta = FindMetaTable("Player")
lia.admin = lia.admin or {}
lia.admin.permissions = lia.admin.permissions or {}

function meta:hasPermission(cmd)
	return lia.admin.permissions[self:GetUserGroup()] and lia.admin.permissions[self:GetUserGroup()]["permissions"][cmd] or false
end


function meta:IsAdmin()
	if !lia.admin.permissions[self:GetUserGroup()] then return false end

	return (lia.admin.permissions[self:GetUserGroup()].admin or lia.admin.permissions[self:GetUserGroup()].superadmin) or false
end

function meta:IsSuperAdmin()
	if !lia.admin.permissions[self:GetUserGroup()] then return false end

	return lia.admin.permissions[self:GetUserGroup()].superadmin or false
end