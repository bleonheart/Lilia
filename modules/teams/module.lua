MODULE.name = "Teams"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "Manages factions and character classes."
if SERVER then
    util.AddNetworkString("CharacterInfo")
    util.AddNetworkString("KickCharacter")
    net.Receive("KickCharacter", function(len, client)
        local char = client:getChar()
        if not char then return end
        local isLeader = client:IsSuperAdmin() or char:getData("factionOwner") or char:getData("factionAdmin") or char:hasFlags("V")
        if not isLeader then return end

        local citizen = lia.faction.teams["citizen"]
        local characterID = net.ReadUInt(32)
        local IsOnline = false
        for _, target in pairs(player.GetAll()) do
            local targetChar = target:getChar()
            if targetChar and targetChar:getID() == characterID and targetChar:getFaction() == char:getFaction() then
                IsOnline = true
                target:notify("You were kicked from your faction!")
                targetChar.vars.faction = citizen.uniqueID
                targetChar:setFaction(citizen.index)
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
        local factionID = net.ReadString()
        local characterData = net.ReadTable()
        local character = LocalPlayer():getChar()
        local isLeader = LocalPlayer():IsSuperAdmin() or character:getData("factionOwner") or character:getData("factionAdmin") or character:hasFlags("V")
        local isValidViewer = isLeader
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
        list:AddColumn("Last Online")
        list:AddColumn("Hours Played")
        for _, data in ipairs(characterData) do
            if data.faction == factionID and data.id ~= character:getID() then
                local line = list:AddLine(data.id, data.name, data.lastOnline, data.hoursPlayed)
                line.steamID = data.steamID
            end
        end

        list.OnRowRightClick = function(parent, lineIndex, line)
            local menu = DermaMenu()
            if isLeader then
                menu:AddOption("Kick", function()
                    Derma_Query("Are you sure you want to kick this player?", "Confirm", "Yes", function()
                        net.Start("KickCharacter")
                        net.WriteInt(tonumber(line:GetValue(1)), 32)
                        net.SendToServer()
                        characterPanel:Remove()
                    end, "No")
                end)
            end

            menu:AddOption("View Character List", function()
                LocalPlayer():ConCommand("say /charlist " .. line.steamID)
            end)

            menu:Open()
        end
    end)
end
