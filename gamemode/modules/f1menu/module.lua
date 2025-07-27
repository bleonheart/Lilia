MODULE.name = "F1 Menu"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Adds a comprehensive F1 menu that gathers character management screens such as inventory, stats, and help into a single place."
MODULE.Privileges = {
    {
        Name = "Access Entity List",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Teleport to Entity",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Teleport to Entity (Entity Tab)",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "View Entity (Entity Tab)",
        MinAccess = "admin",
        Category = MODULE.name
    },
    {
        Name = "Access Module List",
        MinAccess = "user",
        Category = MODULE.name
    }
}

function MODULE:InitializedModules()
    local function getMenuTabNames()
        local defs = {}
        hook.Run("CreateMenuButtons", defs)
        local tabs = {}
        for k in pairs(defs) do
            tabs[#tabs + 1] = k
        end
        return tabs
    end

    lia.config.add("DefaultMenuTab", "Default Menu Tab", L("status"), nil, {
        desc = "Specifies which tab is opened by default when the menu is shown.",
        category = "Menu",
        type = "Table",
        options = CLIENT and getMenuTabNames() or {L("status")}
    })
end
