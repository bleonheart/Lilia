local PLUGIN = PLUGIN
lia.admin = lia.admin or {}
lia.admin.permissions = lia.admin.permissions or {}

netstream.Hook("nutscript_updateAdminPermissions", function(info)
	lia.admin.permissions = info
end)

function PLUGIN:InitPostEntity()
	netstream.Start("nutscript_requestAdminPermissions")
end