MODULE.name = "Administration Utilities"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Provides a suite of administrative commands, configuration menus, and moderation utilities so staff can effectively manage the server."
MODULE.Privileges = {
    {
        Name = "Manage Prop Blacklist",
        MinAccess = "superadmin",
        Category = "Blacklisting",
    },
    {
        Name = "Manage Vehicle Blacklist",
        MinAccess = "superadmin",
        Category = "Blacklisting",
    },
    {
        Name = "Manage Entity Blacklist",
        MinAccess = "superadmin",
        Category = "Blacklisting",
    },
    {
        Name = "Access Configuration Menu",
        MinAccess = "superadmin",
        Category = "Staff Permissions",
    },
    {
        Name = "Access Edit Configuration Menu",
        MinAccess = "superadmin",
        Category = "Staff Permissions",
    },
}

function MODULE:PopulateAdminTabs(pages)
    if not IsValid(LocalPlayer()) then return end
    table.insert(pages, {
        name = L("userGroups"),
        drawFunc = function(parent)
            lia.gui.usergroups = parent
            parent:Clear()
            parent:DockPadding(10, 10, 10, 10)
            parent.Paint = function(p, w, h) derma.SkinHook("Paint", "Frame", p, w, h) end
            net.Start("liaGroupsRequest")
            net.SendToServer()
        end
    })
end