if CLIENT then
    concommand.Add("lia_inventory", function()
        lia.keybind.toggleStandaloneInventory()
    end)
end
