net.Receive("liaRemoveF1", function() if IsValid(lia.gui.menu) then lia.gui.menu:remove() end end)
net.Receive("liaForceUpdateF1", function()
    if IsValid(lia.gui.menu) then
        lia.gui.menu:Remove()
        vgui.Create("liaMenu")
    end
end)
