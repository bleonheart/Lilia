local MODULE = MODULE
lia.admin = lia.admin or {}
lia.admin.menu = lia.admin.menu or {}
lia.admin.menu.tabs = lia.admin.menu.tabs or {}

function lia.admin.menu.addTab(info)
	lia.admin.menu.tabs[info.title] = info
end

lia.admin.menu.addTab({
	icon = "icon16/world.png",
	panelClass = "DAdminWorldMenu",
	title = "adminWorldMenuTitle",
})  