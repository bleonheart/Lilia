lia.dialog = lia.dialog or {}
lia.dialog.stored = lia.dialog.stored or {}
if SERVER then
    local function findOption(options, label, ply)
        if isfunction(options) then options = options(ply) end
        if not istable(options) then return nil end
        for k, v in pairs(options) do
            if k == label then return v end
            if v.options then
                local found = findOption(v.options, label, ply)
                if found then return found end
            end
        end
        return nil
    end

    function lia.dialog.getNPCData(npcID)
        if lia.dialog.stored[npcID] then return lia.dialog.stored[npcID] end
        return nil
    end

    function lia.dialog.getOriginalNPCData(npcID)
        if lia.dialog.originalData and lia.dialog.originalData[npcID] then return lia.dialog.originalData[npcID] end
        return nil
    end

    local function deepCopy(value)
        if istable(value) then
            local copy = {}
            for k, v in pairs(value) do
                copy[k] = deepCopy(v)
            end
            return copy
        elseif isfunction(value) then
            return nil
        end
        return value
    end

    local function sanitizeConversationTable(tbl)
        if not istable(tbl) then return tbl end
        local out = {}
        for label, info in pairs(tbl) do
            local entry = {}
            if istable(info) then
                for k, v in pairs(info) do
                    entry[k] = deepCopy(v)
                end

                if entry.serverOnly then entry.Callback = nil end
                entry.ShouldShow = nil
                if istable(entry.options) then entry.options = sanitizeConversationTable(entry.options) end
                out[label] = entry
            elseif not isfunction(info) then
                entry = info
                out[label] = entry
            end
        end
        return out
    end

    local function flattenGreetings(conversation)
        if not istable(conversation) then return conversation end
        local greetings = conversation["Greetings"]
        if istable(greetings) and istable(greetings.options) then return greetings.options end
        return conversation
    end

    local function filterConversationOptions(conversation, ply, npc)
        if not istable(conversation) then return conversation end
        conversation = flattenGreetings(conversation)
        local filtered = {}
        for label, info in pairs(conversation) do
            local shouldShow = true
            if istable(info) and info.ShouldShow then shouldShow = info.ShouldShow(ply, npc) end
            if shouldShow then
                local entry = {}
                for k, v in pairs(info) do
                    entry[k] = deepCopy(v)
                end

                entry.ShouldShow = nil
                if istable(entry.options) then entry.options = filterConversationOptions(entry.options, ply, npc) end
                filtered[label] = entry
            end
        end
        return filtered
    end

    function lia.dialog.syncToClients(client)
        local targetClients = client and {client} or player.GetAll()
        for _, ply in ipairs(targetClients) do
            net.Start("liaDialogSync")
            local filteredData = {}
            for uniqueID, data in pairs(lia.dialog.stored) do
                local filteredNPCData = table.Copy(data)
                if filteredNPCData.Conversation then filteredNPCData.Conversation = filterConversationOptions(filteredNPCData.Conversation, ply, nil) end
                filteredData[uniqueID] = sanitizeConversationTable(filteredNPCData)
            end

            net.WriteTable(filteredData)
            net.Send(ply)
        end
    end

    function lia.dialog.registerNPC(uniqueID, data)
        if not uniqueID or not data then return false end
        if not data.Conversation then return false end
        lia.dialog.originalData = lia.dialog.originalData or {}
        lia.dialog.originalData[uniqueID] = data
        local sanitizedData = table.Copy(data)
        if sanitizedData.Conversation then sanitizedData.Conversation = sanitizeConversationTable(sanitizedData.Conversation) end
        lia.dialog.stored[uniqueID] = sanitizedData
        lia.dialog.syncToClients()
    end

    lia.dialog.registerNPC("foodie_dealer", {
        PrintName = "Foodie Dealer NPC",
        Conversation = {
            ["I want a snack"] = {
                options = {
                    ["Chips"] = {
                        ShouldShow = function() return true end,
                        Callback = function(clPly) clPly:ChatPrint("Enjoy your chips!") end,
                    },
                    ["Candy"] = {
                        ShouldShow = function() return true end,
                        Callback = function(clPly) clPly:ChatPrint("Enjoy your candy!") end,
                        serverOnly = false,
                    }
                }
            },
            ["I want a meal"] = {
                options = {
                    ["Burger"] = {
                        ShouldShow = function() return true end,
                        Callback = function(clPly) clPly:ChatPrint("Enjoy your burger!") end,
                    },
                    ["Pizza"] = {
                        ShouldShow = function() return true end,
                        Callback = function(clPly) clPly:ChatPrint("Enjoy your pizza!") end,
                        serverOnly = true,
                        options = {
                            ["Extra Cheese"] = {
                                ShouldShow = function() return true end,
                                Callback = function(clPly) clPly:ChatPrint("Extra cheese, coming right up!") end,
                                serverOnly = true
                            }
                        }
                    }
                }
            },
            ["Bye"] = {
                ShouldShow = function() return true end,
                Callback = function(clPly)
                    clPly:ChatPrint("See you later, hungry one!")
                    if CLIENT and IsValid(lia.dialog.vgui) then lia.dialog.vgui:Remove() end
                end,
                serverOnly = false
            }
        }
    })

    net.Receive("liaNpcDialogServerCallback", function(_, ply)
        local npc = net.ReadEntity()
        local label = net.ReadString()
        local npcData = lia.dialog.getOriginalNPCData(npc.uniqueID)
        local conversationTable = npcData and npcData.Conversation
        local option = findOption(conversationTable, label, ply)
        if not IsValid(npc) or not option then return end
        if option.ShouldShow and not option.ShouldShow(ply, npc) then return end
        if option.Callback then option.Callback(ply, npc) end
    end)

    net.Receive("liaNpcCustomize", function(_, ply)
        local npc = net.ReadEntity()
        local customData = net.ReadTable()
        if not IsValid(npc) or not ply:hasPrivilege("canManageProperties") then return end
        if customData.name and customData.name ~= "" then npc.NPCName = customData.name end
        if customData.model and customData.model ~= "" then npc:SetModel(customData.model) end
        if customData.skin then npc:SetSkin(tonumber(customData.skin) or 0) end
        if customData.bodygroups and istable(customData.bodygroups) then
            for bodygroupIndex, value in pairs(customData.bodygroups) do
                npc:SetBodygroup(tonumber(bodygroupIndex) or 0, tonumber(value) or 0)
            end
        end

        if customData.animation and customData.animation ~= "auto" then
            local sequenceIndex = npc:LookupSequence(customData.animation)
            if sequenceIndex >= 0 then
                npc.customAnimation = customData.animation
                npc:ResetSequence(sequenceIndex)
            end
        end

        local currentPos = npc:GetPos()
        local currentAng = npc:GetAngles()
        npc:SetMoveType(MOVETYPE_VPHYSICS)
        npc:SetSolid(SOLID_OBB)
        npc:PhysicsInit(SOLID_OBB)
        npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
        npc:SetPos(currentPos)
        npc:SetAngles(currentAng)
        local physObj = npc:GetPhysicsObject()
        if IsValid(physObj) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        npc:setAnim()
        npc.customData = customData
        npc:setNetVar("NPCName", npc.NPCName)
        hook.Run("UpdateEntityPersistence", npc)
        hook.Run("SaveData")
        ply:notifySuccess("NPC customized successfully!")
    end)

    function lia.dialog.openDialog(client, npc, npcID)
        local npcData = lia.dialog.getOriginalNPCData(npcID)
        if not npcData then return end
        local filteredData = table.Copy(npcData)
        if filteredData.Conversation then filteredData.Conversation = filterConversationOptions(filteredData.Conversation, client, npc) end
        net.Start("liaOpenNpcDialog")
        net.WriteEntity(npc)
        net.WriteBool(client:hasPrivilege("canManageProperties"))
        net.WriteTable(filteredData)
        net.Send(client)
    end

    function MODULE:PlayerInitialSpawn(ply)
        if ply:IsBot() then return end
        lia.dialog.syncToClients(ply)
    end

    function MODULE:GetEntitySaveData(ent)
        if ent:GetClass() == "lia_npc" then
            local saveData = {
                uniqueID = ent.uniqueID or "",
                npcName = ent.NPCName or ""
            }

            if ent.customData then saveData.customData = ent.customData end
            return saveData
        end
    end

    function MODULE:OnEntityLoaded(ent, data)
        if ent:GetClass() == "lia_npc" and data and data.uniqueID and data.uniqueID ~= "" then
            ent.uniqueID = data.uniqueID
            ent.NPCName = data.npcName or "NPC"
            local npcData = lia.dialog.getNPCData(data.uniqueID)
            if npcData then
                ent:SetModel("models/Barney.mdl")
                if npcData.BodyGroups and istable(npcData.BodyGroups) then
                    for bodygroup, value in pairs(npcData.BodyGroups) do
                        local bgIndex = ent:FindBodygroupByName(bodygroup)
                        if bgIndex > -1 then ent:SetBodygroup(bgIndex, value) end
                    end
                end

                if npcData.Skin then ent:SetSkin(npcData.Skin) end
            end

            if data.data and data.data.customData and istable(data.data.customData) then
                ent.customData = data.data.customData
                if data.data.customData.name and data.data.customData.name ~= "" then ent.NPCName = data.data.customData.name end
                if data.data.customData.model and data.data.customData.model ~= "" then ent:SetModel(data.data.customData.model) end
                if data.data.customData.skin then ent:SetSkin(tonumber(data.data.customData.skin) or 0) end
                if data.data.customData.bodygroups and istable(data.data.customData.bodygroups) then
                    for bodygroupIndex, value in pairs(data.data.customData.bodygroups) do
                        ent:SetBodygroup(tonumber(bodygroupIndex) or 0, tonumber(value) or 0)
                    end
                end
            end

            if data.data and data.data.customData and data.data.customData.animation and data.data.customData.animation ~= "auto" then ent.customAnimation = data.data.customData.animation end
            ent:setNetVar("uniqueID", data.uniqueID)
            ent:setNetVar("NPCName", ent.NPCName)
            if not ent.NPCName or ent.NPCName == "" then ent.NPCName = ent:getNetVar("NPCName", "NPC") end
            ent:SetMoveType(MOVETYPE_VPHYSICS)
            ent:SetSolid(SOLID_OBB)
            ent:PhysicsInit(SOLID_OBB)
            ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
            local physObj = ent:GetPhysicsObject()
            if IsValid(physObj) then
                physObj:EnableMotion(false)
                physObj:Sleep()
            end

            ent:setAnim()
        end
    end

    local function setupNPCType(npc, npcType)
        if not IsValid(npc) or not npcType then return end
        local existingCustomData = npc.customData
        npc.uniqueID = npcType
        local npcData = lia.dialog.getNPCData(npcType)
        if npcData then
            local currentPos = npc:GetPos()
            local currentAng = npc:GetAngles()
            npc:SetModel("models/Barney.mdl")
            if npcData.BodyGroups and istable(npcData.BodyGroups) then
                for bodygroup, value in pairs(npcData.BodyGroups) do
                    local bgIndex = npc:FindBodygroupByName(bodygroup)
                    if bgIndex > -1 then npc:SetBodygroup(bgIndex, value) end
                end
            end

            if npcData.Skin then npc:SetSkin(npcData.Skin) end
            npc.NPCName = npcData.PrintName or "NPC"
            npc:setNetVar("uniqueID", npcType)
            npc:setNetVar("NPCName", npc.NPCName)
            npc:SetMoveType(MOVETYPE_VPHYSICS)
            npc:SetSolid(SOLID_OBB)
            npc:PhysicsInit(SOLID_OBB)
            npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
            npc:SetPos(currentPos)
            npc:SetAngles(currentAng)
            local physObj = npc:GetPhysicsObject()
            if IsValid(physObj) then
                physObj:EnableMotion(false)
                physObj:Sleep()
            end

            npc:setAnim()
            if existingCustomData then
                if existingCustomData.name and existingCustomData.name ~= "" then npc.NPCName = existingCustomData.name end
                if existingCustomData.model and existingCustomData.model ~= "" then npc:SetModel(existingCustomData.model) end
                if existingCustomData.skin then npc:SetSkin(tonumber(existingCustomData.skin) or 0) end
                if existingCustomData.bodygroups and istable(existingCustomData.bodygroups) then
                    for bodygroupIndex, value in pairs(existingCustomData.bodygroups) do
                        npc:SetBodygroup(tonumber(bodygroupIndex) or 0, tonumber(value) or 0)
                    end
                end

                if existingCustomData.animation and existingCustomData.animation ~= "auto" then
                    local sequenceIndex = npc:LookupSequence(existingCustomData.animation)
                    if sequenceIndex >= 0 then
                        npc.customAnimation = existingCustomData.animation
                        npc:ResetSequence(sequenceIndex)
                    end
                end

                npc.customData = existingCustomData
            end

            npc:setNetVar("NPCName", npc.NPCName)
            hook.Run("UpdateEntityPersistence", npc)
        end
    end

    net.Receive("liaRequestNPCSelection", function(_, client)
        local npcEntity = net.ReadEntity()
        local uniqueID = net.ReadString()
        if IsValid(npcEntity) and IsValid(client) then
            local character = client:getChar()
            if character then setupNPCType(npcEntity, uniqueID) end
        end
    end)
else
    function lia.dialog.getNPCData(npcID)
        if lia.dialog.stored[npcID] then return lia.dialog.stored[npcID] end
        return nil
    end

    net.Receive("liaDialogSync", function() lia.dialog.stored = net.ReadTable() end)
    net.Receive("liaOpenNpcDialog", function()
        local npc = net.ReadEntity()
        local canCustomize = net.ReadBool()
        local npcData = net.ReadTable()
        local npcName = "Dialog"
        if IsValid(npc) then
            npcName = npc:getNetVar("NPCName", npc.NPCName or "Dialog")
        elseif npcData and npcData.PrintName then
            npcName = npcData.PrintName
        end

        lia.dialog.vgui = vgui.Create("DialogMenu")
        lia.dialog.vgui:SetDialogTitle(npcName)
        if npcData then
            if canCustomize then
                local originalConversation = npcData.Conversation or {}
                local enhancedConversation = table.Copy(originalConversation)
                enhancedConversation["Customize this NPC"] = {
                    Callback = function()
                        lia.dialog.openCustomizationUI(npc)
                        if IsValid(lia.dialog.vgui) then lia.dialog.vgui:Remove() end
                    end,
                    serverOnly = false
                }

                local enhancedData = table.Copy(npcData)
                enhancedData.Conversation = enhancedConversation
                lia.dialog.vgui:LoadNPCDialog(enhancedData, npc)
            else
                lia.dialog.vgui:LoadNPCDialog(npcData, npc)
            end
        end
    end)

    function lia.dialog.openCustomizationUI(npc)
        if not IsValid(npc) then return end
        local frame = vgui.Create("liaFrame")
        frame:SetTitle("Customize NPC")
        frame:SetSize(800, 700)
        frame:Center()
        frame:MakePopup()
        frame:SetDraggable(true)
        frame:ShowCloseButton(true)
        local scroll = vgui.Create("liaScrollPanel", frame)
        scroll:Dock(FILL)
        scroll:DockMargin(10, 10, 10, 10)
        local existingData = {}
        if IsValid(npc) then
            existingData = {
                name = npc:getNetVar("NPCName", npc.NPCName or "NPC"),
                model = "models/Barney.mdl",
                skin = npc:GetSkin() or 0,
                bodygroups = {},
                animation = npc.customData and npc.customData.animation or "auto"
            }

            for i = 0, npc:GetNumBodyGroups() - 1 do
                existingData.bodygroups[i] = npc:GetBodygroup(i)
            end
        end

        local hasSkins = false
        if IsValid(npc) then
            local maxSkins = 0
            for i = 0, 31 do
                local oldSkin = npc:GetSkin()
                npc:SetSkin(i)
                if npc:GetSkin() == i then
                    maxSkins = i
                else
                    break
                end

                npc:SetSkin(oldSkin)
            end

            hasSkins = maxSkins > 0
        end

        local hasBodygroups = false
        if IsValid(npc) then
            for i = 0, npc:GetNumBodyGroups() - 1 do
                local bgCount = npc:GetBodygroupCount(i)
                if bgCount > 1 then
                    hasBodygroups = true
                    break
                end
            end
        end

        local bodygroupControls = {}
        local bodygroupScroll = nil
        local function onBodygroupValueChanged(bodygroupIndex, _, val)
            if IsValid(npc) then npc:SetBodygroup(bodygroupIndex, math.Round(val)) end
        end

        local function updateBodygroupControls()
            if not hasBodygroups or not IsValid(bodygroupScroll) then return end
            bodygroupScroll:Clear()
            bodygroupControls = {}
            if IsValid(npc) then
                for i = 0, npc:GetNumBodyGroups() - 1 do
                    local bgName = npc:GetBodygroupName(i)
                    local bgCount = npc:GetBodygroupCount(i)
                    if bgCount <= 1 then continue end
                    local bgPanel = vgui.Create("DPanel", bodygroupScroll)
                    bgPanel:Dock(TOP)
                    bgPanel:SetTall(40)
                    bgPanel.Paint = function() end
                    local bgLabel = vgui.Create("DLabel", bgPanel)
                    bgLabel:Dock(LEFT)
                    bgLabel:SetWide(120)
                    bgLabel:SetText(bgName .. ":")
                    bgLabel:SetContentAlignment(6)
                    local bgSlider = vgui.Create("DNumSlider", bgPanel)
                    bgSlider:Dock(FILL)
                    bgSlider:SetMin(0)
                    bgSlider:SetMax(bgCount - 1)
                    bgSlider:SetDecimals(0)
                    bgSlider:SetValue(existingData.bodygroups[i] or 0)
                    bgSlider.OnValueChanged = function(_, val) onBodygroupValueChanged(i, _, val) end
                    bodygroupControls[i] = bgSlider
                end
            end
        end

        local nameLabel = vgui.Create("DLabel", scroll)
        nameLabel:Dock(TOP)
        nameLabel:SetText("NPC Name:")
        nameLabel:SetTall(20)
        nameLabel:DockMargin(0, 5, 0, 5)
        local nameEntry = vgui.Create("liaEntry", scroll)
        nameEntry:Dock(TOP)
        nameEntry:SetTall(25)
        nameEntry:SetValue(existingData.name or "NPC")
        nameEntry:DockMargin(0, 0, 0, 10)
        nameEntry.action = function(value)
            if IsValid(npc) and value and value ~= "" then
                npc.NPCName = value
                LocalPlayer():notifySuccess("NPC name will be updated: " .. value)
            end
        end

        local modelLabel = vgui.Create("DLabel", scroll)
        modelLabel:Dock(TOP)
        modelLabel:SetText("Model Path:")
        modelLabel:SetTall(20)
        modelLabel:DockMargin(0, 5, 0, 5)
        local modelEntry = vgui.Create("liaEntry", scroll)
        modelEntry:Dock(TOP)
        modelEntry:SetTall(25)
        modelEntry:SetValue(existingData.model or "models/Barney.mdl")
        modelEntry:DockMargin(0, 0, 0, 10)
        modelEntry.action = function(value)
            if IsValid(npc) and value and value ~= "" then
                npc:SetModel(value)
                updateBodygroupControls()
                LocalPlayer():notifySuccess("NPC model updated to: " .. value)
            end
        end

        local skinEntry = nil
        if hasSkins then
            local skinLabel = vgui.Create("DLabel", scroll)
            skinLabel:Dock(TOP)
            skinLabel:SetText("Skin ID:")
            skinLabel:SetTall(20)
            skinLabel:DockMargin(0, 5, 0, 5)
            skinEntry = vgui.Create("DNumSlider", scroll)
            skinEntry:Dock(TOP)
            skinEntry:SetTall(40)
            skinEntry:SetMin(0)
            skinEntry:SetMax(31)
            skinEntry:SetDecimals(0)
            skinEntry:SetValue(existingData.skin or 0)
            skinEntry:DockMargin(0, 0, 0, 10)
            skinEntry:SetText("Skin ID")
            skinEntry.OnValueChanged = function(_, val) if IsValid(npc) then npc:SetSkin(math.Round(val)) end end
        end

        if hasBodygroups then
            local bodygroupLabel = vgui.Create("DLabel", scroll)
            bodygroupLabel:Dock(TOP)
            bodygroupLabel:SetText("Bodygroups:")
            bodygroupLabel:SetTall(20)
            bodygroupLabel:DockMargin(0, 5, 0, 5)
            local bodygroupPanel = vgui.Create("DPanel", scroll)
            bodygroupPanel:Dock(TOP)
            bodygroupPanel:SetTall(150)
            bodygroupPanel.Paint = function() end
            bodygroupScroll = vgui.Create("liaScrollPanel", bodygroupPanel)
            bodygroupScroll:Dock(FILL)
            bodygroupScroll:DockMargin(5, 5, 5, 5)
            updateBodygroupControls()
        end

        local hasAnimations = false
        local availableAnimations = {}
        local selectedAnimation = "auto"
        if IsValid(npc) then
            availableAnimations = {}
            local sequences = npc:GetSequenceList()
            if not sequences or #sequences == 0 then
                local model = npc:GetModel()
                if model then
                    npc:SetModel(model)
                    sequences = npc:GetSequenceList()
                end
            end

            if sequences and #sequences > 0 then
                hasAnimations = true
                for k, v in ipairs(sequences) do
                    availableAnimations[k] = v
                end

                selectedAnimation = existingData.animation or "auto"
            end
        end

        local animationCombo = nil
        if hasAnimations then
            local animationLabel = vgui.Create("DLabel", scroll)
            animationLabel:Dock(TOP)
            animationLabel:SetText("Animation:")
            animationLabel:SetTall(20)
            animationLabel:DockMargin(0, 5, 0, 5)
            animationCombo = vgui.Create("liaComboBox", scroll)
            animationCombo:Dock(TOP)
            animationCombo:SetTall(25)
            animationCombo:DockMargin(0, 0, 0, 10)
            animationCombo:SetValue(selectedAnimation == "auto" and "Auto (idle animation)" or selectedAnimation)
            local selectedIndex = 0
            if selectedAnimation == "auto" then
                selectedIndex = 1
            else
                for i, animName in ipairs(availableAnimations) do
                    if animName == selectedAnimation then
                        selectedIndex = i + 1
                        break
                    end
                end
            end

            animationCombo:ChooseOption(selectedAnimation, selectedIndex)
            animationCombo:AddChoice("Auto (idle animation)", "auto", selectedAnimation == "auto")
            for _, animName in ipairs(availableAnimations) do
                animationCombo:AddChoice(animName, animName, animName == selectedAnimation)
            end

            animationCombo.OnSelect = function(_, _, value)
                selectedAnimation = value
                if IsValid(npc) and value ~= "auto" then
                    local sequenceIndex = npc:LookupSequence(value)
                    if sequenceIndex >= 0 then npc:ResetSequence(sequenceIndex) end
                elseif IsValid(npc) then
                    npc:setAnim()
                end
            end

            local previewBtn = vgui.Create("liaSmallButton", scroll)
            previewBtn:Dock(TOP)
            previewBtn:SetTall(25)
            previewBtn:DockMargin(0, 5, 0, 10)
            previewBtn:SetText("Preview Animation")
            previewBtn.DoClick = function()
                if IsValid(npc) and selectedAnimation ~= "auto" then
                    local sequenceIndex = npc:LookupSequence(selectedAnimation)
                    if sequenceIndex >= 0 then npc:ResetSequence(sequenceIndex) end
                elseif IsValid(npc) then
                    npc:setAnim()
                end
            end

            local refreshBtn = vgui.Create("liaSmallButton", scroll)
            refreshBtn:Dock(TOP)
            refreshBtn:SetTall(25)
            refreshBtn:DockMargin(0, 5, 0, 10)
            refreshBtn:SetText("Refresh Animation List")
            refreshBtn.DoClick = function()
                if IsValid(npc) then
                    local sequences = npc:GetSequenceList()
                    if sequences and #sequences > 0 then
                        animationCombo:Clear()
                        animationCombo:AddChoice("Auto (idle animation)", "auto", selectedAnimation == "auto")
                        for _, animName in ipairs(sequences) do
                            animationCombo:AddChoice(animName, animName, animName == selectedAnimation)
                        end

                        LocalPlayer():notifySuccess("Animation list refreshed! Found " .. #sequences .. " animations.")
                    else
                        LocalPlayer():notifyError("No animations found for this model.")
                    end
                end
            end
        else
            local noAnimLabel = vgui.Create("DLabel", scroll)
            noAnimLabel:Dock(TOP)
            noAnimLabel:SetText("No animations found for this model.")
            noAnimLabel:SetTall(20)
            noAnimLabel:DockMargin(0, 5, 0, 5)
            noAnimLabel:SetTextColor(Color(255, 100, 100))
            local refreshAnimBtn = vgui.Create("liaSmallButton", scroll)
            refreshAnimBtn:Dock(TOP)
            refreshAnimBtn:SetTall(25)
            refreshAnimBtn:DockMargin(0, 5, 0, 10)
            refreshAnimBtn:SetText("Try Refresh Animations")
            refreshAnimBtn.DoClick = function()
                if IsValid(npc) then
                    local sequences = npc:GetSequenceList()
                    if sequences and #sequences > 0 then
                        LocalPlayer():notifySuccess("Found " .. #sequences .. " animations! Please reopen the customization menu.")
                    else
                        LocalPlayer():notifyError("Still no animations found. The model might not have animations.")
                    end
                end
            end
        end

        local applyBtn = vgui.Create("liaSmallButton", scroll)
        applyBtn:Dock(TOP)
        applyBtn:SetTall(35)
        applyBtn:SetText("Apply Customizations")
        applyBtn:DockMargin(0, 5, 0, 10)
        applyBtn.DoClick = function()
            local customData = {
                name = nameEntry:GetValue(),
                model = modelEntry:GetValue(),
                bodygroups = {}
            }

            if skinEntry and hasSkins then customData.skin = skinEntry:GetValue() end
            if hasBodygroups then
                for i, slider in pairs(bodygroupControls) do
                    if IsValid(slider) then customData.bodygroups[i] = slider:GetValue() end
                end
            end

            if hasAnimations and animationCombo then customData.animation = selectedAnimation end
            net.Start("liaNpcCustomize")
            net.WriteEntity(npc)
            net.WriteTable(customData)
            net.SendToServer()
            frame:Close()
        end

        local cancelBtn = vgui.Create("liaSmallButton", scroll)
        cancelBtn:Dock(TOP)
        cancelBtn:SetTall(30)
        cancelBtn:SetText("Cancel")
        cancelBtn:DockMargin(0, 5, 0, 10)
        cancelBtn.DoClick = function() frame:Close() end
    end

    net.Receive("liaRequestNPCSelection", function()
        local npcEntity = net.ReadEntity()
        local npcOptions = net.ReadTable()
        if not IsValid(npcEntity) or not npcOptions then return end
        local frame = vgui.Create("liaFrame")
        frame:SetSize(800, 600)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("Select NPC Type")
        local scroll = vgui.Create("liaScrollPanel", frame)
        scroll:Dock(FILL)
        scroll:DockMargin(20, 20, 20, 20)
        for _, option in ipairs(npcOptions) do
            local displayName = option[1]
            local uniqueID = option[2]
            local button = vgui.Create("liaSmallButton", scroll)
            button:Dock(TOP)
            button:SetTall(50)
            button:DockMargin(0, 0, 0, 10)
            button:SetText(displayName)
            button.DoClick = function()
                net.Start("liaRequestNPCSelection")
                net.WriteEntity(npcEntity)
                net.WriteString(uniqueID)
                net.SendToServer()
                frame:Close()
            end
        end

        local closeBtn = vgui.Create("liaSmallButton", frame)
        closeBtn:Dock(BOTTOM)
        closeBtn:SetTall(60)
        closeBtn:DockMargin(20, 10, 20, 20)
        closeBtn:SetText("Cancel")
        closeBtn.DoClick = function() frame:Close() end
    end)

    lia.font.register("liaDialogFont", {
        font = lia.config.get("Font"),
        extended = false,
        size = 32
    })
end
