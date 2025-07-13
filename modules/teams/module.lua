MODULE.name = "Teams"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.version = "1.0"
MODULE.desc = "Manages factions and character classes."
if SERVER then
    util.AddNetworkString("CharacterInfo")
    util.AddNetworkString("KickCharacter")
    net.Receive("KickCharacter", function(len, client)
        local citizen = lia.faction.teams["citizen"]
        local characterID = net.ReadUInt(32)
        local IsOnline = false
        for _, target in pairs(player.GetAll()) do
            if target:getChar():getID() == characterID then
                IsOnline = true
                target:notify("You were kicked from your faction!")
                target:getChar().vars.faction = citizen.uniqueID
                target:getChar():setFaction(citizen.index)
            end
        end

        if not IsOnline then lia.char.setCharData(characterID, "kickedFromFaction", true) end
    end)

    function MODULE:PlayerLoadedChar(client)
        local citizen = lia.faction.teams["citizen"]
        if client:getChar():getData("kickedFromFaction", false) then
            client:notify("You were kicked from a faction while offline!")
            client:getChar().vars.faction = citizen.uniqueID
            client:getChar():setFaction(citizen.index)
            client:getChar():setData("kickedFromFaction", false)
        end
    end
else
    net.Receive("CharacterInfo", function()
        local character = LocalPlayer():getChar()
        local factionIndex = character:getFaction()
        local faction = lia.faction.indices[factionIndex]
        local factionID = faction.uniqueID
        local isValidViewer = character:getData("factionOwner") or character:getData("factionAdmin")
        if not isValidViewer then return end
        if IsValid(characterPanel) then characterPanel:Remove() end
        characterPanel = vgui.Create("DFrame")
        characterPanel:SetSize(400, 300)
        characterPanel:Center()
        characterPanel:SetTitle("Character Information")
        characterPanel:MakePopup()
        local list = vgui.Create("DListView", characterPanel)
        list:Dock(FILL)
        list:SetMultiSelect(false)
        list:AddColumn("ID")
        list:AddColumn("Name")
        local characterData = net.ReadTable()
        for _, data in ipairs(characterData) do
            if data.faction == factionID and data.id ~= character:getID() then list:AddLine(data.id, data.name) end
        end

        list.OnRowRightClick = function(parent, lineIndex, line)
            local menu = DermaMenu()
            menu:AddOption("Kick", function()
                net.Start("KickCharacter")
                net.WriteInt(tonumber(line:GetValue(1)), 32)
                net.SendToServer()
                characterPanel:Remove()
            end)

            menu:Open()
        end
    end)
end