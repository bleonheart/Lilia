local function getMenuTabNames()
    local defs = {}
    hook.Run("CreateMenuButtons", defs)
    local tabs = {}
    for k in pairs(defs) do
        tabs[#tabs + 1] = k
    end
    return tabs
end

lia.config.add("DefaultMenuTab", "Default Menu Tab", L("you"), nil, {
    desc = "Specifies which tab is opened by default when the menu is shown.",
    category = "Menu",
    type = "Table",
    options = CLIENT and getMenuTabNames() or {L("you")}
})