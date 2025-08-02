local function getMenuTabNames()
    local defs = {}
    hook.Run("CreateMenuButtons", defs)
    local tabs = {}
    for k in pairs(defs) do
        tabs[#tabs + 1] = k
    end
    return tabs
end

lia.config.add("DefaultMenuTab", L("defaultMenuTab"), L("you"), nil, {
    desc = L("defaultMenuTabDesc"),
    category = L("categoryMenu"),
    type = "Table",
    options = CLIENT and getMenuTabNames() or {L("you")}
})
