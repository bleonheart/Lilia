if CLIENT then
    lia.net.readBigTable("liaDialogSync", function(data)
        if istable(data) then lia.dialog.stored = data end
    end)

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

        lia.dialog.vgui = vgui.Create("liaDialogMenu")
        lia.dialog.vgui:SetDialogTitle(npcName)
        if npcData then
            local enhancedConversation = table.Copy(npcData.Conversation or {})
            local additionalOptions = hook.Run("GetNPCDialogOptions", LocalPlayer(), npc, canCustomize) or {}
            for optionName, optionData in pairs(additionalOptions) do
                enhancedConversation[optionName] = optionData
            end

            local enhancedData = table.Copy(npcData)
            enhancedData.Conversation = enhancedConversation
            lia.dialog.vgui:LoadNPCDialog(enhancedData, npc)
        end
    end)

    net.Receive("liaNpcDialogDeliverResponse", function()
        local npc = net.ReadEntity()
        local responses = net.ReadTable()
        if not IsValid(lia.dialog.vgui) or not responses then return end
        if lia.dialog.vgui.DisplayServerResponse then lia.dialog.vgui:DisplayServerResponse(responses, npc) end
    end)

    net.Receive("liaNpcDialogNodeResult", function()
        local result = net.ReadTable()
        if not IsValid(lia.dialog.vgui) or not result then return end
        if lia.dialog.vgui.HandleGeneratedDialogResult then lia.dialog.vgui:HandleGeneratedDialogResult(result) end
    end)

    lia.derma.requestNPCSelection = function(title, description, options, callback)
        options = istable(options) and options or {}
        local frame = vgui.Create("liaFrame")
        frame:SetSize(580, math.Clamp(176 + #options * 54, 300, math.floor(ScrH() * 0.68)))
        frame:Center()
        frame:MakePopup()
        StyleRequestFrame(frame, "NPC REQUEST", resolveClientRequestText(title, "Select NPC Type"), resolveClientRequestText(description, ""))
        local finished = false
        local function closeRequest()
            if finished then return end
            finished = true
            if IsValid(frame) then frame:Remove() end
        end

        CreateRequestFooter(frame, "Cancel", nil, closeRequest, nil)
        local scroll = CreateRequestScroll(frame)
        for _, option in ipairs(options) do
            local displayName = tostring(option[1] or "Unknown")
            local uniqueID = tostring(option[2] or "")
            local button = CreateRequestButton(scroll, displayName, "secondary")
            button:Dock(TOP)
            button:SetTall(46)
            button:DockMargin(0, 0, 0, 8)
            button.Paint = function(s, w, h)
                local palette = getRequestPalette()
                s._liaRequestHover = Lerp(math.Clamp(FrameTime() * 14, 0, 1), s._liaRequestHover, s:IsHovered() and 1 or 0)
                local background = Color(math.Round(Lerp(s._liaRequestHover, palette.button.r, palette.buttonHovered.r)), math.Round(Lerp(s._liaRequestHover, palette.button.g, palette.buttonHovered.g)), math.Round(Lerp(s._liaRequestHover, palette.button.b, palette.buttonHovered.b)), 246)
                drawRequestPanel(0, 0, w, h, 6, background, Color(palette.accent.r, palette.accent.g, palette.accent.b, math.Round(Lerp(s._liaRequestHover, 44, 125))))
                draw.SimpleText(displayName, "LiliaFont.17", 14, h * 0.5 - 6, palette.textSecondary, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if uniqueID ~= "" then draw.SimpleText(uniqueID, "LiliaFont.14", 14, h * 0.5 + 10, palette.textMuted, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
                draw.SimpleText(">", "LiliaFont.18", w - 17, h * 0.5, s:IsHovered() and palette.accent or palette.textMuted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            button.DoClick = function()
                if finished then return end
                finished = true
                if callback then callback(uniqueID, displayName) end
                if IsValid(frame) then frame:Remove() end
            end
        end
        return frame
    end

    net.Receive("liaRequestNPCSelection", function()
        local npcEntity = net.ReadEntity()
        local npcOptions = net.ReadTable()
        if not IsValid(npcEntity) or not istable(npcOptions) then return end
        lia.derma.requestNPCSelection("Select NPC Type", "Choose the NPC type to use.", npcOptions, function(uniqueID)
            net.Start("liaRequestNPCSelection")
            net.WriteEntity(npcEntity)
            net.WriteString(uniqueID)
            net.SendToServer()
        end)
    end)
end

if SERVER then
    local function findOption(options, label, ply)
        if isfunction(options) then options = options(ply) end
        if not istable(options) then return nil end
        for k, v in pairs(options) do
            if k == label or k == label then return v end
            if v.options then
                local found = findOption(v.options, label, ply)
                if found then return found end
            end
        end
        return nil
    end

    local function buildResponsePayload(response)
        if response == nil then return nil end
        if istable(response) then
            local payload = {}
            local function pushLine(line)
                if isstring(line) then
                    payload[#payload + 1] = line
                elseif line ~= nil then
                    payload[#payload + 1] = tostring(line)
                end
            end

            for _, line in ipairs(response) do pushLine(line) end
            if #payload == 0 then
                for _, line in pairs(response) do pushLine(line) end
            end
            return #payload > 0 and payload or nil
        end
        return {tostring(response)}
    end

    local function dialogFactionMatches(ply, requirement)
        requirement = string.Trim(tostring(requirement or ""))
        if requirement == "" then return true end
        local char = ply:getChar()
        if not char then return false end
        return lia.dialog.factionMatchesRequirement(char:getFaction(), requirement)
    end

    local function isGeneratedCloseNode(node)
        if not istable(node) then return false end
        local nodeID = string.Trim(string.lower(tostring(node.dialogID or "")))
        return nodeID == "goodbye" or nodeID == "bye" or nodeID == "farewell" or nodeID == "close"
    end

    local function buildGeneratedNodeOptions(generatedDialog, nodeID)
        local options = {}
        for _, childNode in ipairs(lia.dialog.getGeneratedChildNodes(generatedDialog, nodeID) or {}) do
            options[#options + 1] = {
                label = childNode.playerText ~= "" and childNode.playerText or childNode.dialogID or childNode.id,
                nodeID = childNode.id,
                closeDialog = isGeneratedCloseNode(childNode)
            }
        end
        return options
    end

    local function applyGeneratedNodeEffects(ply, npc, node)
        if not IsValid(ply) or not istable(node) then return end
        local swepClass = string.Trim(tostring(node.swepClass or ""))
        if swepClass ~= "" and not ply:HasWeapon(swepClass) then ply:Give(swepClass) end
        local waypointValue = string.Trim(tostring(node.waypoint or ""))
        if waypointValue ~= "" then
            local waypointVector = lia.data.decodeVector(waypointValue)
            if isvector(waypointVector) then
                ply:setWaypoint(node.dialogID ~= "" and node.dialogID or "Dialog", waypointVector)
            elseif IsValid(npc) then
                ply:setWaypoint(waypointValue, npc:GetPos())
            end
        end
    end

    local function setupNPCType(client, npc)
        if not IsValid(npc) then return end
        local npcType = npc.uniqueID
        if not npcType then return end
        local existingCustomData = npc.customData
        local npcData = lia.dialog.getNPCData(npcType)
        if npcData and lia.dialog.isDialogCompatibleWithEntity(npc, npcData) then
            local currentPos = npc:GetPos()
            local currentAng = npc:GetAngles()
            npc:SetModel("models/Barney.mdl")
            if npcData.BodyGroups and istable(npcData.BodyGroups) then lia.util.applyBodygroups(npc, npcData.BodyGroups) end
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
                if existingCustomData.bodygroups and istable(existingCustomData.bodygroups) then lia.util.applyBodygroups(npc, existingCustomData.bodygroups) end
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
            hook.Run("OnDialogNPCTypeSet", client, npc)
        end
    end

    net.Receive("liaNpcDialogServerCallback", function(_, ply)
        local npc = net.ReadEntity()
        local label = net.ReadString()
        local npcData = lia.dialog.getOriginalNPCData(npc.uniqueID)
        local conversationTable = npcData and npcData.Conversation
        local option = findOption(conversationTable, label, ply)
        if not option and conversationTable then
            for _, entry in pairs(conversationTable) do
                if istable(entry) and isfunction(entry.GetOptions) then
                    local dynamicOptions = entry.GetOptions(ply, npc)
                    if istable(dynamicOptions) and dynamicOptions[label] then option = dynamicOptions[label] break end
                end
            end
        end

        if not IsValid(npc) or not option then return end
        if option.ShouldShow and not option.ShouldShow(ply, npc) then return end
        if option.Callback then option.Callback(ply, npc) end
    end)

    net.Receive("liaNpcDialogRequestResponse", function(_, ply)
        local npc = net.ReadEntity()
        local label = net.ReadString()
        if not IsValid(ply) or not IsValid(npc) or not npc.uniqueID then return end
        local npcData = lia.dialog.getOriginalNPCData(npc.uniqueID)
        local conversationTable = npcData and npcData.Conversation
        if not conversationTable then return end
        local option = findOption(conversationTable, label, ply)
        if not option or (option.ShouldShow and not option.ShouldShow(ply, npc)) or not option.Response then return end
        local payload
        if isfunction(option.Response) then
            local success, result = pcall(option.Response, ply, npc)
            if not success then ErrorNoHalt(string.format("[Lilia] Dialog response error for '%s': %s\n", label, tostring(result))) return end
            payload = result
        else
            payload = option.Response
        end

        if istable(payload) and #payload > 1 then payload = payload[math.random(1, #payload)] end
        payload = buildResponsePayload(payload)
        if not payload then return end
        net.Start("liaNpcDialogDeliverResponse")
        net.WriteEntity(npc)
        net.WriteTable(payload)
        net.Send(ply)
    end)

    net.Receive("liaNpcDialogNodeSelect", function(_, ply)
        local npc = net.ReadEntity()
        local selectedNodeID = net.ReadString()
        local currentNodeID = net.ReadString()
        if not IsValid(ply) or not IsValid(npc) or not npc.uniqueID then return end
        local npcData = lia.dialog.getOriginalNPCData(npc.uniqueID)
        local generatedDialog = npcData and npcData.GeneratedDialog
        if not istable(generatedDialog) then return end
        local selectedNode = lia.dialog.findGeneratedNode(generatedDialog, selectedNodeID)
        local currentNode = lia.dialog.findGeneratedNode(generatedDialog, currentNodeID)
        if not selectedNode then return end
        local allowed = false
        if currentNode then
            for _, childID in ipairs(currentNode.children or {}) do if childID == selectedNodeID then allowed = true break end end
        else
            local startNode = lia.dialog.getGeneratedStartNode(generatedDialog)
            if startNode and startNode.id == selectedNodeID then allowed = true end
        end

        if not allowed and currentNodeID ~= "" then return end
        local success = dialogFactionMatches(ply, selectedNode.factionRequirement)
        local responseText = success and selectedNode.npcText or (selectedNode.requirementMessage ~= "" and selectedNode.requirementMessage or "You do not meet the requirement for this dialog.")
        if success then applyGeneratedNodeEffects(ply, npc, selectedNode) end
        net.Start("liaNpcDialogNodeResult")
        net.WriteTable({success = success, selectedNodeID = selectedNodeID, currentNodeID = currentNodeID, npcText = responseText, soundPath = success and selectedNode.soundPath or "", closeDialog = success and isGeneratedCloseNode(selectedNode) or false, options = buildGeneratedNodeOptions(generatedDialog, success and selectedNodeID or currentNodeID)})
        net.Send(ply)
    end)

    net.Receive("liaNpcCustomize", function(_, ply)
        local configID = net.ReadString()
        local npc = net.ReadEntity()
        local payload = net.ReadTable() or {}
        if not isstring(configID) or configID == "" or not IsValid(ply) or not IsValid(npc) then return end
        if not ply.hasPrivilege or not ply:hasPrivilege("canManageNPCs") then return end
        local config = lia.dialog.getConfiguration(configID)
        if not config or not isfunction(config.onApply) then return end
        if isfunction(config.shouldShow) then
            local ok, allowed = pcall(config.shouldShow, ply, npc, npc.uniqueID)
            if not ok then ErrorNoHalt(string.format("[Lilia] NPC configuration '%s' visibility check failed: %s\n", configID, tostring(allowed))) return end
            if allowed == false then return end
        end

        local success, err = pcall(config.onApply, ply, npc, payload)
        if not success then ErrorNoHalt(string.format("[Lilia] NPC configuration '%s' errored: %s\n", configID, tostring(err))) end
    end)

    net.Receive("liaRequestNPCSelection", function(_, client)
        local npcEntity = net.ReadEntity()
        local uniqueID = net.ReadString()
        if IsValid(npcEntity) and IsValid(client) then
            local character = client:getChar()
            if character then
                if lia.dialog.isGeneratedDialogSelection and lia.dialog.isGeneratedDialogSelection(uniqueID) then
                    local hasManageNPCs = client:hasPrivilege("canManageNPCs")
                    local hasManageProperties = client:hasPrivilege("canManageProperties")
                    if not hasManageNPCs and not hasManageProperties then return end
                    uniqueID = lia.dialog.ensureGeneratedDialogType and select(1, lia.dialog.ensureGeneratedDialogType(npcEntity, nil, npcEntity.NPCName)) or nil
                    if not uniqueID then return end
                end

                npcEntity.uniqueID = uniqueID
                setupNPCType(client, npcEntity)
            end
        end
    end)
end
