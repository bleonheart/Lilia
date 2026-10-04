net.Receive("liaSpeciesCreatorOpen", function()
    if IsValid(lia.gui.speciesCreator) then lia.gui.speciesCreator:Remove() end
    vgui.Create("liaSpeciesCreator")
end)
