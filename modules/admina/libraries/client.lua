local MODULE = MODULE
netstream.Hook("lilia_updateAdminPermissions", function(info) lia.admin.permissions = info end)
function MODULE:InitPostEntity()
	netstream.Start("lilia_requestAdminPermissions")
end

function lia.admin.menu.addTab(info)
	lia.admin.menu.tabs[info.title] = info
end

lia.admin.menu.addTab({
	icon = "icon16/world.png",
	panelClass = "DAdminWorldMenu",
	title = "adminWorldMenuTitle",
})