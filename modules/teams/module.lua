MODULE.name = "Teams"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.version = "1.0"
MODULE.desc = "Manages factions and character classes."
if SERVER then
    util.AddNetworkString("CharacterInfo")
    util.AddNetworkString("KickCharacter")
    net.Receive("KickCharacter", function(len, client)
        local char = client:getChar()
        if not char or not char:hasFlags("R") then return end
        if client:isStaffOnDuty() then return end
        local isLeader = char:getData("factionOwner") or char:getData("factionAdmin")
        if not isLeader then return end

        local citizen = lia.faction.teams["citizen"]
        local characterID = net.ReadUInt(32)
        local IsOnline = false
        for _, target in pairs(player.GetAll()) do
            local targetChar = target:getChar()
            if targetChar and targetChar:getID() == characterID then
                if targetChar:getFaction() ~= char:getFaction() then return end
                IsOnline = true
                target:notify("You were kicked from your faction!")
                targetChar.vars.faction = citizen.uniqueID
                targetChar:setFaction(citizen.index)
            end
        end

        if not IsOnline then
            lia.char.setCharData(characterID, "kickedFromFaction", true)
        end
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
        if not character or not character:hasFlags("R") then return end
        local factionID = net.ReadString()
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
            if data.id ~= character:getID() then list:AddLine(data.id, data.name) end
        end

        list.OnRowRightClick = function(parent, lineIndex, line)
            local menu = DermaMenu()
            menu:AddOption("Kick", function()
                Derma_Query(L("areYouSure"), L("adminStickKickCharacterName"), L("yes"), function()
                    net.Start("KickCharacter")
                    net.WriteInt(tonumber(line:GetValue(1)), 32)
                    net.SendToServer()
                    characterPanel:Remove()
                end, L("no"))
            end)

            menu:Open()
        end
    end)
end