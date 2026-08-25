local MODULE = MODULE
local playerInfoLabel = "Player" .. " " .. "Information"
local subMenuIcons = {
    moderationTools = "icon16/wrench.png",
    warnings = "icon16/error.png",
    misc = "icon16/application_view_tile.png",
    [playerInfoLabel] = "icon16/information.png",
    characterManagement = "icon16/user_gray.png",
    flagManagement = "icon16/flag_blue.png",
    attributes = "icon16/chart_line.png",
    charFlagsTitle = "icon16/flag_green.png",
    giveFlagsLabel = "icon16/flag_blue.png",
    takeFlagsLabel = "icon16/flag_red.png",
    doorManagement = "icon16/door.png",
    doorActions = "icon16/arrow_switch.png",
    doorSettings = "icon16/cog.png",
    doorMaintenance = "icon16/wrench.png",
    doorInformation = "icon16/information.png",
    administration = "icon16/lock.png",
    items = "icon16/box.png",
    ooc = "icon16/comment.png",
    adminStickSubCategoryBans = "icon16/lock.png",
    adminStickSubCategoryGetInfos = "icon16/magnifier.png",
    adminStickSubCategorySetInfos = "icon16/pencil.png",
    setFactionTitle = "icon16/group.png",
    adminStickSetClassName = "icon16/user.png",
    adminStickFactionWhitelistName = "icon16/group_add.png",
    adminStickUnwhitelistName = "icon16/group_delete.png",
    adminStickClassWhitelistName = "icon16/user_add.png",
    adminStickClassUnwhitelistName = "icon16/user_delete.png",
    adminStickSubCategoryRanking = "icon16/user_green.png",
    Ranks = "icon16/user_green.png",
    server = "icon16/cog.png",
    permissions = "icon16/key.png",
}

local function hasAdminStickGeneratedLists(target)
    local lists = {}
    hook.Run("GetAdminStickLists", target, lists)
    for _, listData in ipairs(lists) do
        if listData and listData.name and listData.category and listData.subcategory and istable(listData.items) and next(listData.items) ~= nil then return true end
    end
    return false
end

local function appendDeferredMenuBuild(menu, builder)
    if not IsValid(menu) or not isfunction(builder) then return end
    if menu.AppendDeferredBuild then
        menu:AppendDeferredBuild(builder)
    else
        builder(menu)
    end
end

local function GetIdentifier(ent)
    if not IsValid(ent) or not ent:IsPlayer() then return "" end
    if ent:IsBot() then return ent:Name() end
    return ent:SteamID64()
end

local function requestAdminStickPlayerState(target)
    if not (IsValid(target) and target:IsPlayer()) then return end
    net.Start("liaAdminStickRequestPlayerState")
    net.WriteEntity(target)
    net.SendToServer()
end

local function QuoteArgs(...)
    local args = {}
    for _, v in ipairs({...}) do
        args[#args + 1] = string.format("'%s'", tostring(v))
    end
    return table.concat(args, " ")
end

local function GetAdminStickCommandArgumentDefinitions(data, targetArg)
    local definitions = {}
    local startIndex = 1
    local arguments = data and data.arguments or {}
    if targetArg ~= "" and arguments[1] then
        local firstArg = arguments[1]
        local argName = tostring(firstArg.name or ""):lower()
        if firstArg.type == "player" or firstArg.type == "target" or argName == "target" then startIndex = 2 end
    end

    for i = startIndex, #arguments do
        local argument = arguments[i]
        definitions[#definitions + 1] = {
            index = i,
            name = argument.name,
            type = argument.type or "string",
            optional = argument.optional or false,
            description = argument.description
        }
    end
    return definitions
end

local function BuildAdminStickCommandString(key, targetArg, argumentDefinitions, values)
    local command = "say /" .. key
    if targetArg ~= "" then command = command .. " " .. QuoteArgs(targetArg) end
    local definitions = argumentDefinitions or {}
    for _, argument in ipairs(definitions) do
        local value = values and values[argument.name]
        if argument.type == "bool" then
            if value == true then
                command = command .. " " .. QuoteArgs("true")
            elseif value == false then
                command = command .. " " .. QuoteArgs("false")
            end
        elseif value ~= nil then
            value = string.Trim(tostring(value))
            if value ~= "" then
                command = command .. " " .. QuoteArgs(value)
            elseif argument.optional and targetArg ~= "" then
                command = command .. " " .. QuoteArgs("")
            end
        end
    end
    return command
end

local function RunAdminStickCommand(key, targetArg, argumentDefinitions, values)
    local client = LocalPlayer()
    if not IsValid(client) then return end
    client:ConCommand(BuildAdminStickCommandString(key, targetArg, argumentDefinitions, values))
    timer.Simple(0.1, function()
        client.AdminStickTarget = nil
        AdminStickIsOpen = false
    end)
end

local function GetAdminStickCommandTargetArgument(ent)
    if not IsValid(ent) then return "" end
    if ent:IsPlayer() then return GetIdentifier(ent) end
    if ent.isDoor and ent:isDoor() then
        local doorID = ent:MapCreationID()
        if doorID and doorID > 0 then return tostring(doorID) end
    end
    return ""
end

local function GetIconForCategory(name)
    if subMenuIcons[name] then return subMenuIcons[name] end
    local baseKey = name:match("^([^%(]+)") or name
    baseKey = baseKey:gsub("^%s*(.-)%s*$", "%1")
    if subMenuIcons[baseKey] then return subMenuIcons[baseKey] end
    local nameLower = name:lower()
    local iconMappings = {
        ["moderation"] = "icon16/shield.png",
        ["admin"] = "icon16/shield.png",
        ["security"] = "icon16/shield.png",
        ["character"] = "icon16/user_gray.png",
        ["player"] = "icon16/user_gray.png",
        ["user"] = "icon16/user_gray.png",
        ["person"] = "icon16/user_gray.png",
        ["door"] = "icon16/door.png",
        ["building"] = "icon16/door.png",
        ["property"] = "icon16/door.png",
        ["house"] = "icon16/door.png",
        ["information"] = "icon16/information.png",
        ["info"] = "icon16/information.png",
        ["data"] = "icon16/information.png",
        ["knowledge"] = "icon16/information.png",
        ["details"] = "icon16/information.png",
        ["teleport"] = "icon16/arrow_right.png",
        ["move"] = "icon16/arrow_right.png",
        ["travel"] = "icon16/arrow_right.png",
        ["transport"] = "icon16/arrow_right.png",
        ["utility"] = "icon16/application_view_tile.png",
        ["tool"] = "icon16/application_view_tile.png",
        ["misc"] = "icon16/application_view_tile.png",
        ["miscellaneous"] = "icon16/application_view_tile.png",
        ["other"] = "icon16/application_view_tile.png",
        ["flag"] = "icon16/flag_green.png",
        ["permission"] = "icon16/flag_green.png",
        ["access"] = "icon16/flag_green.png",
        ["privilege"] = "icon16/flag_green.png",
        ["item"] = "icon16/box.png",
        ["inventory"] = "icon16/box.png",
        ["container"] = "icon16/box.png",
        ["storage"] = "icon16/box.png",
        ["ooc"] = "icon16/comment.png",
        ["chat"] = "icon16/comment.png",
        ["message"] = "icon16/comment.png",
        ["talk"] = "icon16/comment.png",
        ["communication"] = "icon16/comment.png",
        ["warning"] = "icon16/error.png",
        ["alert"] = "icon16/error.png",
        ["error"] = "icon16/error.png",
        ["caution"] = "icon16/error.png",
        ["command"] = "icon16/page.png",
        ["control"] = "icon16/page.png",
        ["manage"] = "icon16/page.png",
        ["setting"] = "icon16/page.png",
        ["attribute"] = "icon16/chart_line.png",
        ["stat"] = "icon16/chart_line.png",
        ["skill"] = "icon16/chart_line.png",
        ["level"] = "icon16/chart_line.png",
        ["faction"] = "icon16/group.png",
        ["guild"] = "icon16/group.png",
        ["team"] = "icon16/group.png",
        ["organization"] = "icon16/group.png",
        ["class"] = "icon16/user.png",
        ["role"] = "icon16/user.png",
        ["job"] = "icon16/user.png",
        ["profession"] = "icon16/user.png",
        ["whitelist"] = "icon16/group_add.png",
        ["approve"] = "icon16/group_add.png",
        ["accept"] = "icon16/group_add.png",
        ["allow"] = "icon16/group_add.png",
        ["ban"] = "icon16/lock.png",
        ["block"] = "icon16/lock.png",
        ["restrict"] = "icon16/lock.png",
        ["deny"] = "icon16/lock.png",
    }

    for keyword, icon in pairs(iconMappings) do
        if nameLower:find(keyword) then return icon end
    end

    local localizedExactMatches = {
        [("Moderation"):lower()] = "icon16/shield.png",
        [("Character Management"):lower()] = "icon16/user_gray.png",
        [("Door Management"):lower()] = "icon16/door.png",
        [("Player Information"):lower()] = "icon16/information.png",
        [("Teleportation"):lower()] = "icon16/arrow_right.png",
        [("Utility"):lower()] = "icon16/application_view_tile.png",
        [("Miscellaneous"):lower()] = "icon16/application_view_tile.png",
        [("Items"):lower()] = "icon16/box.png",
        [("out of character"):lower()] = "icon16/comment.png",
        [("Warnings"):lower()] = "icon16/error.png",
    }

    if localizedExactMatches[nameLower] then return localizedExactMatches[nameLower] end
    if nameLower:find("management") or nameLower:find("admin") then return "icon16/cog.png" end
    if nameLower:find("stat") or nameLower:find("number") or nameLower:find("count") then return "icon16/chart_bar.png" end
    if nameLower:find("set") or nameLower:find("config") then return "icon16/cog.png" end
    if nameLower:find("get") or nameLower:find("view") or nameLower:find("show") then return "icon16/information.png" end
    if nameLower:find("list") or nameLower:find("all") then
        return "icon16/table.png"
    elseif nameLower:find("create") or nameLower:find("new") or nameLower:find("add") then
        return "icon16/add.png"
    elseif nameLower:find("delete") or nameLower:find("remove") then
        return "icon16/delete.png"
    elseif nameLower:find("edit") or nameLower:find("modify") then
        return "icon16/pencil.png"
    else
        return "icon16/page.png"
    end
end

local function getAdminStickTheme()
    local theme = lia.color and lia.color.theme or {}
    local accent = theme.accent or theme.header or theme.theme or lia.config and lia.config.get("Color") or Color(45, 190, 170)
    local text = theme.text or Color(225, 238, 238)
    return accent, text
end

local function resolveAdminStickLabel(value)
    if isfunction(value) then value = value() end
    if value == nil then return "" end
    if not isstring(value) then return tostring(value) end
    local resolved = lia.lang and lia.lang.resolveToken and value or value
    if resolved and resolved ~= "" and resolved ~= value and resolved ~= value:sub(2) then return resolved end
    return value
end

local function drawAdminStickPanel(x, y, w, h, radius, color, outline)
    if lia.derma and lia.derma.rect then
        lia.derma.rect(x, y, w, h):Rad(radius):Color(color):Shape(lia.derma.SHAPE_IOS):Draw()
        if outline then lia.derma.rect(x, y, w, h):Rad(radius):Color(outline):Shape(lia.derma.SHAPE_IOS):Outline(1):Draw() end
    else
        draw.RoundedBox(radius, x, y, w, h, color)
        if outline then
            surface.SetDrawColor(outline)
            surface.DrawOutlinedRect(x, y, w, h, 1)
        end
    end
end

local function adminStickCopyText(value, notifyKey)
    if value == nil then return end
    value = tostring(value)
    if value == "" or value == "BOT" then return end
    SetClipboardText(value)
    local client = LocalPlayer()
    if IsValid(client) and client.notifySuccessLocalized then client:notifySuccess(notifyKey or "Copied to clipboard.") end
end

local function adminStickGetTargetName(target)
    if not IsValid(target) then return "Unknown" end
    if target:IsPlayer() then
        local char = target:getChar()
        return char and char:getName() or target:Nick() or target:Name() or "Unknown"
    end

    if target.GetName and target:GetName() ~= "" then return target:GetName() end
    return target:GetClass() or "Unknown"
end

local function adminStickShouldShowTargetHeader(target)
    return IsValid(target) and target:IsPlayer() and not target:IsBot()
end

local function adminStickGetTargetSubtitle(target)
    if not IsValid(target) then return "" end
    if target:IsPlayer() then
        local char = target:getChar()
        local factionName = char and team.GetName(char:getFaction()) or team.GetName(target:Team())
        local className = "None"
        if char and char.getClass then
            local classIndex = char:getClass()
            if classIndex and classIndex ~= -1 and lia.class.list[classIndex] then className = lia.class.list[classIndex].name or "none" end
        end

        local charID = char and char:getID() or "N/A"
        return tostring(factionName or "None") .. "  •  " .. tostring(className or "None") .. "  •  Character #" .. tostring(charID)
    end
    return target:GetClass() or "Unknown"
end

local function adminStickBuildActionText(name, path, category, subcategory)
    local parts = {name or "", category or "", subcategory or ""}
    for _, part in ipairs(path or {}) do
        parts[#parts + 1] = part
    end
    return table.concat(parts, " "):lower()
end

local function adminStickGetActionSeverity(name, path, category, subcategory)
    local value = adminStickBuildActionText(name, path, category, subcategory)
    if value:find("ban", 1, true) or value:find("kick", 1, true) or value:find("slay", 1, true) or value:find("delete", 1, true) or value:find("remove", 1, true) or value:find("unwhitelist", 1, true) or value:find("take all", 1, true) then return "danger" end
    if value:find("freeze", 1, true) or value:find("jail", 1, true) or value:find("ignite", 1, true) or value:find("gag", 1, true) or value:find("mute", 1, true) or value:find("warn", 1, true) then return "warning" end
    return "normal"
end

local function adminStickIsCopyAction(action)
    local name = tostring(action and action.name or ""):lower()
    if name:find("copy", 1, true) then return true end
    for _, part in ipairs(action and action.path or {}) do
        if tostring(part):lower():find("copy", 1, true) then return true end
    end
    return false
end

local function adminStickGetActionRouting(name, path, category, subcategory)
    local text = adminStickBuildActionText(name, path, category, subcategory)
    local hasFaction = text:find("faction", 1, true) or text:find("factions", 1, true)
    local hasClass = text:find("class", 1, true) or text:find("classes", 1, true)
    local hasWhitelist = text:find("whitelist", 1, true)
    local hasUnwhitelist = text:find("unwhitelist", 1, true) or hasWhitelist and (text:find("remove", 1, true) or text:find("delete", 1, true) or text:find("take", 1, true))
    local hasTransfer = text:find("transfer", 1, true) or text:find("set faction", 1, true) or text:find("set class", 1, true)
    if hasClass then
        if hasWhitelist then return "Class", hasUnwhitelist and "unwhitelist" or "whitelist", hasUnwhitelist and "Unwhitelist Class" or "Whitelist Class" end
        if hasTransfer then return "Class", "transfer", "Transfer to Class" end
        return "Class", nil, name
    end

    if hasFaction then
        if hasWhitelist then return "Faction", hasUnwhitelist and "unwhitelist" or "whitelist", hasUnwhitelist and "Unwhitelist Faction" or "Whitelist Faction" end
        if hasTransfer then return "Faction", "transfer", "Transfer to Faction" end
        return "Faction", nil, name
    end
    return category, nil, name
end

local function adminStickSeverityRank(severity)
    if severity == "danger" then return 3 end
    if severity == "warning" then return 2 end
    return 1
end

local function adminStickSortActionButtons(a, b)
    local order = {
        transfer = 1,
        whitelist = 2,
        unwhitelist = 2
    }

    local ao = order[a.actionType or ""] or 10
    local bo = order[b.actionType or ""] or 10
    if ao == bo then return (a.executeLabel or a.name) < (b.executeLabel or b.name) end
    return ao < bo
end

local function normalizeAdminStickActions(actions)
    local normalized = {}
    local grouped = {}
    local groupedOrder = {}
    for _, action in ipairs(actions or {}) do
        local name = resolveAdminStickLabel(action.name)
        if name ~= "" and not adminStickIsCopyAction(action) then
            local path = table.Copy(action.path or {})
            local category = resolveAdminStickLabel(path[1] or "Actions")
            local subcategory = ""
            local displayCategory, actionType, executeLabel = adminStickGetActionRouting(name, path, category, subcategory)
            local severity = adminStickGetActionSeverity(name, path, displayCategory, subcategory)
            local searchable = string.lower(table.concat({name, displayCategory, category, subcategory, table.concat(path, " ")}, " "))
            local actionData = {
                name = name,
                category = displayCategory,
                originalCategory = category,
                subcategory = subcategory,
                path = path,
                icon = action.icon or GetIconForCategory(displayCategory),
                callback = action.callback,
                executeLabel = executeLabel,
                actionType = actionType,
                severity = severity,
                search = searchable,
                commandKey = action.commandKey,
                commandArguments = table.Copy(action.commandArguments or {})
            }

            if (displayCategory == "Faction" or displayCategory == "Class") and actionType then
                local key = displayCategory .. "::" .. name:lower()
                if not grouped[key] then
                    grouped[key] = {
                        name = name,
                        category = displayCategory,
                        originalCategory = category,
                        subcategory = "",
                        path = {},
                        callback = nil,
                        executeLabel = name,
                        severity = "normal",
                        search = searchable,
                        groupedActions = {},
                        groupedLookup = {}
                    }

                    groupedOrder[#groupedOrder + 1] = key
                end

                local group = grouped[key]
                group.search = group.search .. " " .. searchable
                if adminStickSeverityRank(severity) > adminStickSeverityRank(group.severity) then group.severity = severity end
                if not group.groupedLookup[actionType] then
                    group.groupedActions[#group.groupedActions + 1] = actionData
                    group.groupedLookup[actionType] = actionData
                else
                    local existing = group.groupedLookup[actionType]
                    existing.callback = actionData.callback
                    existing.executeLabel = actionData.executeLabel
                    existing.severity = actionData.severity
                    existing.search = existing.search .. " " .. actionData.search
                end
            else
                normalized[#normalized + 1] = actionData
            end
        end
    end

    for _, key in ipairs(groupedOrder) do
        local group = grouped[key]
        table.sort(group.groupedActions, adminStickSortActionButtons)
        group.groupedLookup = nil
        normalized[#normalized + 1] = group
    end

    table.sort(normalized, function(a, b)
        if a.category == b.category then return a.name < b.name end
        return a.category < b.category
    end)
    return normalized
end

local ADMIN_STICK_COLLECTOR = {}
function ADMIN_STICK_COLLECTOR:Init()
    self:SetVisible(false)
    self:SetSize(1, 1)
    self._actions = {}
    self._path = {}
    self._root = self
end

function ADMIN_STICK_COLLECTOR:GetRootCollector()
    return self._root or self
end

function ADMIN_STICK_COLLECTOR:AppendDeferredBuild(builder)
    if isfunction(builder) then builder(self) end
end

function ADMIN_STICK_COLLECTOR:UpdateSize()
end

function ADMIN_STICK_COLLECTOR:Open()
end

function ADMIN_STICK_COLLECTOR:AddSpacer()
end

function ADMIN_STICK_COLLECTOR:AddSubMenu(name, callback)
    local submenu = vgui.Create("liaAdminStickActionCollector", self)
    submenu._root = self:GetRootCollector()
    submenu._path = table.Copy(self._path or {})
    submenu._path[#submenu._path + 1] = resolveAdminStickLabel(name)
    submenu._menuName = resolveAdminStickLabel(name)
    if isfunction(callback) then submenu._callback = callback end
    local option = vgui.Create("DPanel", self)
    option:SetVisible(false)
    option.SetIcon = function(_, icon) submenu._icon = icon end
    option.SetZPos = function() end
    return submenu, option
end

function ADMIN_STICK_COLLECTOR:AddOption(name, callback, metadata)
    local root = self:GetRootCollector()
    local action = {
        name = resolveAdminStickLabel(name),
        callback = callback,
        path = table.Copy(self._path or {}),
        icon = self._icon
    }

    if istable(metadata) then table.Merge(action, metadata) end
    root._actions[#root._actions + 1] = action
    local option = vgui.Create("DPanel", self)
    option:SetVisible(false)
    option.SetIcon = function(_, icon) action.icon = icon end
    option.SetZPos = function() end
    return option
end

vgui.Register("liaAdminStickActionCollector", ADMIN_STICK_COLLECTOR, "DPanel")
local ADMIN_STICK_PANEL = {}
function ADMIN_STICK_PANEL:Init()
    self:SetSize(math.Clamp(math.floor(ScrW() * 0.54), 940, 1120), math.Clamp(math.floor(ScrH() * 0.64), 620, 780))
    self:Center()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.18, 0)
    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)
    self.categories = {}
    self.categoryOrder = {}
    self.filteredActions = {}
    self.quickActions = {}
    self.actionArgumentState = setmetatable({}, {
        __mode = "k"
    })

    self.lastDoorAccessSignature = nil
    self.titleBar = self:Add("DPanel")
    self.titleBar:Dock(TOP)
    self.titleBar:SetTall(56)
    self.titleBar.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        surface.SetDrawColor(255, 255, 255, 12)
        surface.DrawRect(0, h - 1, w, 1)
        draw.SimpleText("ADMIN STICK", "LiliaFont.25", 20, h * 0.5, Color(242, 247, 247), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 190)
        surface.DrawRect(0, h - 2, w, 2)
    end

    self.closeButton = self.titleBar:Add("DButton")
    self.closeButton:Dock(RIGHT)
    self.closeButton:SetWide(58)
    self.closeButton:SetText("")
    self.closeButton.Paint = function(button, w, h) draw.SimpleText("×", "LiliaFont.30", w * 0.5, h * 0.5 - 1, button:IsHovered() and Color(255, 235, 235) or Color(190, 205, 205), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
    self.closeButton.DoClick = function() self:Remove() end
    self.targetHeader = self:Add("DPanel")
    self.targetHeader:Dock(TOP)
    self.targetHeader:SetTall(142)
    self.targetHeader:DockMargin(12, 12, 12, 12)
    self.targetHeader:DockPadding(16, 16, 16, 16)
    self.targetHeader.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 222), Color(accent.r, accent.g, accent.b, 80))
    end

    self.body = self:Add("DPanel")
    self.body:Dock(FILL)
    self.body:DockMargin(12, 0, 12, 12)
    self.body.Paint = function() end
    self.categoryPanel = self.body:Add("DPanel")
    self.categoryPanel:Dock(LEFT)
    self.categoryPanel:SetWide(240)
    self.categoryPanel:DockMargin(0, 0, 12, 0)
    self.categoryPanel:DockPadding(12, 46, 12, 12)
    self.categoryPanel.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 222), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText("CATEGORIES", "LiliaFont.18", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.categoryList = self.categoryPanel:Add("liaScrollPanel")
    self.categoryList:Dock(FILL)
    self.categoryList.Paint = function() end
    self.actionPanel = self.body:Add("DPanel")
    self.actionPanel:Dock(LEFT)
    self.actionPanel:SetWide(390)
    self.actionPanel:DockMargin(0, 0, 12, 0)
    self.actionPanel:DockPadding(12, 12, 12, 12)
    self.actionPanel.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 222), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText("ACTIONS", "LiliaFont.18", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.searchWrap = self.actionPanel:Add("DPanel")
    self.searchWrap:Dock(TOP)
    self.searchWrap:SetTall(42)
    self.searchWrap:DockMargin(92, 0, 0, 10)
    self.searchWrap:DockPadding(12, 0, 12, 0)
    self.searchWrap.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 6, Color(5, 18, 23, 235), Color(accent.r, accent.g, accent.b, 70))
    end

    self.searchEntry = self.searchWrap:Add("DTextEntry")
    self.searchEntry:Dock(FILL)
    self.searchEntry:SetFont("LiliaFont.17")
    self.searchEntry:SetTextColor(Color(225, 236, 236))
    self.searchEntry:SetCursorColor(lia.color.theme.accent)
    self.searchEntry:SetPlaceholderText("Search actions...")
    self.searchEntry:SetPaintBackground(false)
    self.searchEntry:SetPaintBackground(false)
    self.searchEntry:SetPaintBorderEnabled(false)
    self.searchEntry.OnChange = function() self:RebuildActions() end
    self.actionList = self.actionPanel:Add("liaScrollPanel")
    self.actionList:Dock(FILL)
    self.actionList.Paint = function() end
    self.detailPanel = self.body:Add("DPanel")
    self.detailPanel:Dock(FILL)
    self.detailPanel:DockPadding(14, 46, 14, 14)
    self.detailPanel.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 222), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText("ACTION DETAILS", "LiliaFont.18", 16, 15, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.detailScroll = self.detailPanel:Add("liaScrollPanel")
    self.detailScroll:Dock(FILL)
    self.detailScroll.Paint = function() end
    self.accessPanel = self.body:Add("DPanel")
    self.accessPanel:Dock(FILL)
    self.accessPanel:SetVisible(false)
    self.accessPanel:DockPadding(18, 18, 18, 18)
    self.accessPanel.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 222), Color(accent.r, accent.g, accent.b, 80))
    end

    self.accessScroll = self.accessPanel:Add("liaScrollPanel")
    self.accessScroll:Dock(FILL)
    self.accessScroll.Paint = function() end
    self:MakePopup()
end

function ADMIN_STICK_PANEL:Paint(w, h)
    if lia.util and lia.util.drawBlackBlur then lia.util.drawBlackBlur(self, 1, 5, 255, 225) end
    drawAdminStickPanel(0, 0, w, h, 10, Color(3, 13, 17, 244), Color(0, 0, 0, 210))
end

function ADMIN_STICK_PANEL:Think()
    if not IsValid(self.target) then
        self:Remove()
        return
    end

    if self.activeCategory == "doorAccess" and self.target.isDoor and self.target:isDoor() then self:RefreshDoorAccessState() end
    if (self.activeCategory == "playerWhitelists" or self.activeCategory == "playerFactionTransfer") and self.target:IsPlayer() and (self.nextPlayerStateRequest or 0) <= CurTime() then
        self.nextPlayerStateRequest = CurTime() + 1.5
        requestAdminStickPlayerState(self.target)
    end

    local x, y = self:GetPos()
    AdminStickMenuPositionCache = {
        x = x,
        y = y,
        w = self:GetWide(),
        h = self:GetTall(),
        updateTime = CurTime()
    }
end

function ADMIN_STICK_PANEL:OnKeyCodePressed(key)
    if key == KEY_ESCAPE or key == KEY_F1 then self:Remove() end
end

function ADMIN_STICK_PANEL:OnRemove()
    if AdminStickMenu == self then
        local client = LocalPlayer()
        if IsValid(client) then client.AdminStickTarget = nil end
        AdminStickIsOpen = false
        AdminStickMenu = nil
        AdminStickMenuPositionCache = nil
        hook.Run("OnAdminStickMenuClosed")
    end
end

function ADMIN_STICK_PANEL:SetTargetAndActions(target, actions)
    self.target = target
    self.playerState = target and MODULE.adminStickPlayerStates[target] or nil
    self.actions = normalizeAdminStickActions(actions)
    self:BuildQuickActions()
    self:BuildTargetHeader()
    self:BuildCategories()
    if IsValid(target) and target:IsPlayer() then requestAdminStickPlayerState(target) end
end

function ADMIN_STICK_PANEL:QueuePlayerStateRefresh(delay)
    if not (IsValid(self.target) and self.target:IsPlayer()) then return end
    timer.Simple(delay or 0.3, function() if IsValid(self) and IsValid(self.target) then requestAdminStickPlayerState(self.target) end end)
end

function ADMIN_STICK_PANEL:OnPlayerStateUpdated(state)
    self.playerState = state or {}
    if self.activeCategory == "playerWhitelists" then
        self:BuildPlayerWhitelistPanel()
    elseif self.activeCategory == "playerFactionTransfer" then
        self:BuildPlayerFactionTransferPanel()
    end
end

local function collectAdminStickFactions(includeDefault)
    local factions = {}
    for _, factionData in pairs(lia.faction.teams or {}) do
        if factionData.uniqueID ~= "staff" and (includeDefault or not factionData.isDefault) then factions[#factions + 1] = factionData end
    end

    table.sort(factions, function(a, b) return tostring(a.name or a.uniqueID or "") < tostring(b.name or b.uniqueID or "") end)
    return factions
end

function ADMIN_STICK_PANEL:BuildPlayerWhitelistPanel()
    if not IsValid(self.accessScroll) then return end
    self.accessScroll:Clear()
    local header = self.accessScroll:Add("DPanel")
    header:Dock(TOP)
    header:SetTall(98)
    header:DockMargin(0, 0, 0, 14)
    header.Paint = function(_, w, h)
        local accent = lia.color.theme.accent
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText("WHITELISTS", "LiliaFont.30", 16, 12, Color(242, 247, 247), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Toggle faction whitelist access for this player.", "LiliaFont.17", 16, 52, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 42)
        surface.DrawRect(16, h - 2, w - 32, 2)
    end

    if not self.playerState then
        local loading = self.accessScroll:Add("DLabel")
        loading:Dock(TOP)
        loading:SetTall(38)
        loading:SetFont("LiliaFont.18")
        loading:SetTextColor(Color(180, 202, 204))
        loading:SetText("Loading player whitelist data...")
        loading:SetContentAlignment(4)
        return
    end

    local whitelists = self.playerState.whitelists or {}
    local currentFaction = tonumber(self.playerState.faction)
    for _, factionData in ipairs(collectAdminStickFactions(false)) do
        local factionRow = self.accessScroll:Add("DPanel")
        factionRow:Dock(TOP)
        factionRow:DockMargin(0, 0, 0, 12)
        factionRow:DockPadding(14, 14, 14, 14)
        factionRow:SetTall(82)
        factionRow.hoverAlpha = 0
        factionRow.Paint = function(panel, w, h)
            local accent = lia.color.theme.accent
            local hovered = panel:IsHovered()
            panel.hoverAlpha = math.Approach(panel.hoverAlpha, hovered and 1 or 0, FrameTime() * 5)
            drawAdminStickPanel(0, 0, w, h, 8, hovered and Color(12, 28, 34, 235) or Color(9, 24, 29, 228), Color(accent.r, accent.g, accent.b, 68 + panel.hoverAlpha * 24))
            surface.SetDrawColor(255, 255, 255, 8 + panel.hoverAlpha * 8)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        local enabled = whitelists[factionData.uniqueID] == true
        local actionWrap = factionRow:Add("DPanel")
        actionWrap:Dock(RIGHT)
        actionWrap:SetWide(132)
        actionWrap.Paint = function() end
        local action = actionWrap:Add("DButton")
        action:Dock(FILL)
        action:DockMargin(8, 10, 0, 10)
        action:SetText("")
        action.Paint = function(button, w, h)
            local hovered = button:IsHovered()
            local color = enabled and Color(210, 85, 85) or lia.color.theme.accent
            drawAdminStickPanel(0, 0, w, h, 6, hovered and Color(color.r, color.g, color.b, 35) or Color(8, 28, 33, 230), Color(color.r, color.g, color.b, hovered and 170 or 110))
            draw.SimpleText(enabled and "REMOVE" or "WHITELIST", "LiliaFont.17", w * 0.5, h * 0.5, hovered and Color(245, 249, 249) or Color(color.r, color.g, color.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        action.DoClick = function()
            LocalPlayer():ConCommand("say /" .. (enabled and "plyunwhitelist" or "plywhitelist") .. " " .. QuoteArgs(GetIdentifier(self.target), factionData.uniqueID))
            self:QueuePlayerStateRefresh()
        end

        local infoWrap = factionRow:Add("DPanel")
        infoWrap:Dock(FILL)
        infoWrap:DockPadding(0, 0, 0, 0)
        infoWrap.Paint = function() end
        local factionLabel = infoWrap:Add("DLabel")
        factionLabel:Dock(TOP)
        factionLabel:DockMargin(0, 0, 0, 2)
        factionLabel:SetTall(24)
        factionLabel:SetFont("LiliaFont.20")
        factionLabel:SetTextColor(factionData.color or Color(230, 239, 239))
        factionLabel:SetText(tostring(factionData.name or factionData.uniqueID))
        factionLabel:SetContentAlignment(4)
        local factionMeta = infoWrap:Add("DLabel")
        factionMeta:Dock(TOP)
        factionMeta:SetTall(18)
        factionMeta:SetFont("LiliaFont.15")
        factionMeta:SetTextColor(Color(165, 187, 188))
        factionMeta:SetText(currentFaction == factionData.index and "Current faction" or enabled and "Whitelisted" or "Not whitelisted")
        factionMeta:SetContentAlignment(4)
    end
end

function ADMIN_STICK_PANEL:BuildPlayerFactionTransferPanel()
    if not IsValid(self.accessScroll) then return end
    self.accessScroll:Clear()
    local header = self.accessScroll:Add("DPanel")
    header:Dock(TOP)
    header:SetTall(98)
    header:DockMargin(0, 0, 0, 14)
    header.Paint = function(_, w, h)
        local accent = getAdminStickTheme()
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText("FACTION TRANSFER", "LiliaFont.30", 16, 12, Color(242, 247, 247), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Move this character into a new faction.", "LiliaFont.17", 16, 52, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 42)
        surface.DrawRect(16, h - 2, w - 32, 2)
    end

    if not self.playerState then
        local loading = self.accessScroll:Add("DLabel")
        loading:Dock(TOP)
        loading:SetTall(38)
        loading:SetFont("LiliaFont.18")
        loading:SetTextColor(Color(180, 202, 204))
        loading:SetText("Loading faction data...")
        loading:SetContentAlignment(4)
        return
    end

    local currentFaction = tonumber(self.playerState.faction)
    local whitelists = self.playerState.whitelists or {}
    for _, factionData in ipairs(collectAdminStickFactions(true)) do
        local factionRow = self.accessScroll:Add("DPanel")
        factionRow:Dock(TOP)
        factionRow:DockMargin(0, 0, 0, 12)
        factionRow:DockPadding(14, 14, 14, 14)
        factionRow:SetTall(82)
        factionRow.hoverAlpha = 0
        factionRow.Paint = function(panel, w, h)
            local accent = getAdminStickTheme()
            local hovered = panel:IsHovered()
            panel.hoverAlpha = math.Approach(panel.hoverAlpha, hovered and 1 or 0, FrameTime() * 5)
            drawAdminStickPanel(0, 0, w, h, 8, hovered and Color(12, 28, 34, 235) or Color(9, 24, 29, 228), Color(accent.r, accent.g, accent.b, 68 + panel.hoverAlpha * 24))
            surface.SetDrawColor(255, 255, 255, 8 + panel.hoverAlpha * 8)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        local isCurrent = currentFaction == factionData.index
        local actionWrap = factionRow:Add("DPanel")
        actionWrap:Dock(RIGHT)
        actionWrap:SetWide(132)
        actionWrap.Paint = function() end
        local action = actionWrap:Add("DButton")
        action:Dock(FILL)
        action:DockMargin(8, 10, 0, 10)
        action:SetText("")
        action:SetEnabled(not isCurrent)
        action.Paint = function(button, w, h)
            local hovered = button:IsHovered()
            local color = isCurrent and Color(95, 115, 120) or lia.color.theme.accent
            drawAdminStickPanel(0, 0, w, h, 6, hovered and Color(color.r, color.g, color.b, 35) or Color(8, 28, 33, 230), Color(color.r, color.g, color.b, hovered and 170 or 110))
            draw.SimpleText(isCurrent and "CURRENT" or "TRANSFER", "LiliaFont.17", w * 0.5, h * 0.5, hovered and Color(245, 249, 249) or Color(color.r, color.g, color.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        action.DoClick = function()
            if isCurrent then return end
            LocalPlayer():ConCommand("say /plytransfer " .. QuoteArgs(GetIdentifier(self.target), factionData.uniqueID))
            self:QueuePlayerStateRefresh(0.4)
        end

        local infoWrap = factionRow:Add("DPanel")
        infoWrap:Dock(FILL)
        infoWrap:DockPadding(0, 0, 0, 0)
        infoWrap.Paint = function() end
        local title = infoWrap:Add("DLabel")
        title:Dock(TOP)
        title:DockMargin(0, 0, 0, 2)
        title:SetTall(24)
        title:SetFont("LiliaFont.20")
        title:SetTextColor(factionData.color or Color(230, 239, 239))
        title:SetText(tostring(factionData.name or factionData.uniqueID))
        title:SetContentAlignment(4)
        local status = infoWrap:Add("DLabel")
        status:Dock(TOP)
        status:SetTall(18)
        status:SetFont("LiliaFont.15")
        status:SetTextColor(Color(165, 187, 188))
        status:SetText(isCurrent and "Currently assigned" or whitelists[factionData.uniqueID] and "Has whitelist access" or factionData.isDefault and "Default faction" or "No whitelist access")
        status:SetContentAlignment(4)
    end
end

function ADMIN_STICK_PANEL:BuildDoorAccessPanel()
    if not IsValid(self.accessScroll) then return end
    self.accessScroll:Clear()
    self.accessFactions = {}
    self.accessClasses = {}
    self.lastDoorAccessSignature = nil
    local header = self.accessScroll:Add("DPanel")
    header:Dock(TOP)
    header:SetTall(98)
    header:DockMargin(0, 0, 0, 14)
    header.Paint = function(_, w, h)
        local accent = getAdminStickTheme()
        drawAdminStickPanel(0, 0, w, h, 8, Color(5, 18, 23, 220), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText("Door Access", "LiliaFont.30", 16, 12, Color(242, 247, 247), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Choose which factions and classes can use this vendor.", "LiliaFont.17", 16, 52, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 42)
        surface.DrawRect(16, h - 2, w - 32, 2)
    end

    for factionID, factionData in ipairs(lia.faction.indices or {}) do
        local factionRow = self.accessScroll:Add("DPanel")
        factionRow:Dock(TOP)
        factionRow:DockMargin(0, 0, 0, 12)
        factionRow:DockPadding(14, 14, 14, 14)
        factionRow:SetTall(82)
        factionRow.hoverAlpha = 0
        factionRow.Paint = function(panel, w, h)
            local accent = getAdminStickTheme()
            local hovered = panel:IsHovered()
            panel.hoverAlpha = math.Approach(panel.hoverAlpha, hovered and 1 or 0, FrameTime() * 5)
            drawAdminStickPanel(0, 0, w, h, 8, hovered and Color(12, 28, 34, 235) or Color(9, 24, 29, 228), Color(accent.r, accent.g, accent.b, 68 + panel.hoverAlpha * 24))
            surface.SetDrawColor(255, 255, 255, 8 + panel.hoverAlpha * 8)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        local factionActionWrap = factionRow:Add("DPanel")
        factionActionWrap:Dock(RIGHT)
        factionActionWrap:SetWide(132)
        factionActionWrap.Paint = function() end
        local factionAction = factionActionWrap:Add("DButton")
        factionAction:Dock(FILL)
        factionAction:DockMargin(8, 10, 0, 10)
        factionAction:SetText("")
        factionAction._liaDoorAccessState = false
        factionAction._liaSetState = function(button, state) button._liaDoorAccessState = state == true end
        factionAction.Paint = function(button, w, h)
            local hovered = button:IsHovered()
            local allowed = button._liaDoorAccessState == true
            local color = allowed and Color(210, 85, 85) or lia.color.theme.accent
            drawAdminStickPanel(0, 0, w, h, 6, hovered and Color(color.r, color.g, color.b, 35) or Color(8, 28, 33, 230), Color(color.r, color.g, color.b, hovered and 170 or 110))
            draw.SimpleText(allowed and "REMOVE" or "ALLOW", "LiliaFont.17", w * 0.5, h * 0.5, hovered and Color(245, 249, 249) or Color(color.r, color.g, color.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        factionAction.DoClick = function(button)
            local state = button._liaDoorAccessState == true
            local command = "say /" .. (state and "doorremovefaction" or "dooraddfaction")
            local doorID = GetAdminStickCommandTargetArgument(self.target)
            if doorID ~= "" then command = command .. " " .. QuoteArgs(doorID) end
            LocalPlayer():ConCommand(command .. " " .. QuoteArgs(factionData.uniqueID))
        end

        self.accessFactions[factionID] = factionAction
        local factionInfoWrap = factionRow:Add("DPanel")
        factionInfoWrap:Dock(FILL)
        factionInfoWrap.Paint = function() end
        local factionLabel = factionInfoWrap:Add("DLabel")
        factionLabel:Dock(TOP)
        factionLabel:DockMargin(0, 0, 0, 2)
        factionLabel:SetTall(24)
        factionLabel:SetFont("LiliaFont.20")
        factionLabel:SetTextColor(factionData.color or Color(230, 239, 239))
        factionLabel:SetText(factionData.name)
        factionLabel:SetContentAlignment(4)
        local factionMeta = factionInfoWrap:Add("DLabel")
        factionMeta:Dock(TOP)
        factionMeta:SetTall(18)
        factionMeta:SetFont("LiliaFont.15")
        factionMeta:SetTextColor(Color(165, 187, 188))
        factionMeta:SetText("Faction access")
        factionMeta:SetContentAlignment(4)
        local separator = factionRow:Add("DPanel")
        separator:Dock(TOP)
        separator:SetTall(1)
        separator:DockMargin(0, 4, 0, 8)
        separator.Paint = function(_, w, h)
            local accent = getAdminStickTheme()
            surface.SetDrawColor(accent.r, accent.g, accent.b, 28)
            surface.DrawRect(0, 0, w, h)
        end

        local classCount = 0
        for classIndex, classData in ipairs(lia.class.list or {}) do
            if classData.faction ~= factionID then continue end
            classCount = classCount + 1
            local classRow = factionRow:Add("DPanel")
            classRow:Dock(TOP)
            classRow:DockMargin(22, 0, 0, 8)
            classRow:DockPadding(10, 8, 10, 8)
            classRow:SetTall(46)
            classRow.hoverAlpha = 0
            classRow.Paint = function(panel, w, h)
                local accent = getAdminStickTheme()
                local hovered = panel:IsHovered()
                panel.hoverAlpha = math.Approach(panel.hoverAlpha, hovered and 1 or 0, FrameTime() * 7)
                drawAdminStickPanel(0, 0, w, h, 6, hovered and Color(16, 34, 40, 220) or Color(13, 30, 35, 210), Color(accent.r, accent.g, accent.b, 28 + panel.hoverAlpha * 24))
            end

            local classActionWrap = classRow:Add("DPanel")
            classActionWrap:Dock(RIGHT)
            classActionWrap:SetWide(124)
            classActionWrap.Paint = function() end
            local classAction = classActionWrap:Add("DButton")
            classAction:Dock(FILL)
            classAction:DockMargin(8, 0, 0, 0)
            classAction:SetText("")
            classAction._liaDoorAccessState = false
            classAction._liaSetState = function(button, state) button._liaDoorAccessState = state == true end
            classAction.Paint = function(button, w, h)
                local hovered = button:IsHovered()
                local allowed = button._liaDoorAccessState == true
                local color = allowed and Color(210, 85, 85) or lia.color.theme.accent
                drawAdminStickPanel(0, 0, w, h, 6, hovered and Color(color.r, color.g, color.b, 35) or Color(8, 28, 33, 230), Color(color.r, color.g, color.b, hovered and 170 or 110))
                draw.SimpleText(allowed and "REMOVE" or "ALLOW", "LiliaFont.15", w * 0.5, h * 0.5, hovered and Color(245, 249, 249) or Color(color.r, color.g, color.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            classAction.DoClick = function(button)
                local state = button._liaDoorAccessState == true
                local command = "say /" .. (state and "doorremoveclass" or "doorsetclass")
                local doorID = GetAdminStickCommandTargetArgument(self.target)
                if doorID ~= "" then command = command .. " " .. QuoteArgs(doorID) end
                LocalPlayer():ConCommand(command .. " " .. QuoteArgs(classData.uniqueID))
            end

            self.accessClasses[classIndex] = classAction
            local classInfoWrap = classRow:Add("DPanel")
            classInfoWrap:Dock(FILL)
            classInfoWrap.Paint = function() end
            local classLabel = classInfoWrap:Add("DLabel")
            classLabel:Dock(TOP)
            classLabel:SetTall(16)
            classLabel:SetFont("LiliaFont.16")
            classLabel:SetTextColor(Color(210, 223, 223))
            classLabel:SetText(classData.name)
            classLabel:SetContentAlignment(4)
            local classMeta = classInfoWrap:Add("DLabel")
            classMeta:Dock(TOP)
            classMeta:SetTall(14)
            classMeta:SetFont("LiliaFont.14")
            classMeta:SetTextColor(Color(145, 168, 170))
            classMeta:SetText("Class access")
            classMeta:SetContentAlignment(4)
        end

        factionRow:SetTall(82 + classCount * 54)
    end
end

function ADMIN_STICK_PANEL:RefreshDoorAccessState(force)
    if not (IsValid(self.target) and self.target.isDoor and self.target:isDoor()) then return end
    local doorData = lia.doors.getData(self.target) or {}
    local factions = doorData.factions or {}
    local classes = doorData.classes or {}
    local signature = util.TableToJSON({
        factions = factions,
        classes = classes
    }) or ""

    if not force and signature == self.lastDoorAccessSignature then return end
    self.lastDoorAccessSignature = signature
    local factionLookup = {}
    for _, uniqueID in ipairs(factions) do
        local factionIndex = lia.faction.getIndex(uniqueID)
        if factionIndex then factionLookup[factionIndex] = true end
    end

    local classLookup = {}
    for _, uniqueID in ipairs(classes) do
        classLookup[uniqueID] = true
    end

    for factionID, checkbox in pairs(self.accessFactions or {}) do
        if IsValid(checkbox) then
            if checkbox._liaSetState then
                checkbox:_liaSetState(factionLookup[factionID] or false)
            else
                checkbox._suppress = true
                checkbox:SetChecked(factionLookup[factionID] or false)
                checkbox._suppress = nil
            end
        end
    end

    for classIndex, checkbox in pairs(self.accessClasses or {}) do
        local classData = lia.class.list[classIndex]
        if IsValid(checkbox) and classData then
            if checkbox._liaSetState then
                checkbox:_liaSetState(classLookup[classData.uniqueID] or false)
            else
                checkbox._suppress = true
                checkbox:SetChecked(classLookup[classData.uniqueID] or false)
                checkbox._suppress = nil
            end
        end
    end
end

function ADMIN_STICK_PANEL:CreateHeaderLabel(parent, text, font, color, x, y, w, h)
    local label = parent:Add("DLabel")
    label:SetText(text or "")
    label:SetFont(font)
    label:SetTextColor(color)
    label:SetPos(x, y)
    label:SetSize(w, h)
    label:SetContentAlignment(4)
    return label
end

function ADMIN_STICK_PANEL:CreateChip(parent, label, _, callback)
    local button = parent:Add("DButton")
    button:SetText("")
    button._label = label
    button.Paint = function(s, w, h)
        local accent = getAdminStickTheme()
        local hovered = s:IsHovered()
        local bg = hovered and Color(16, 34, 40, 235) or Color(10, 25, 30, 232)
        drawAdminStickPanel(0, 0, w, h, 6, bg, Color(accent.r, accent.g, accent.b, hovered and 115 or 65))
        draw.SimpleText(s._label, "LiliaFont.17", 16, h * 0.5, hovered and Color(245, 249, 249) or Color(225, 236, 236), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    button.DoClick = callback
    return button
end

function ADMIN_STICK_PANEL:BuildQuickActions()
    local target = self.target
    self.quickActions = {}
    if not IsValid(target) then return end
    local pos = target:GetPos()
    local ang = target:GetAngles()
    local posStr = string.format("Vector = (%.2f, %.2f, %.2f), Angle = (%.2f, %.2f, %.2f)", pos.x, pos.y, pos.z, ang.x, ang.y, ang.z)
    self.quickActions[#self.quickActions + 1] = {
        label = "Copy Position",
        icon = "icon16/page_copy.png",
        callback = function() adminStickCopyText(posStr) end
    }

    if target:IsPlayer() then
        local steamID64 = target:IsBot() and "BOT" or target:SteamID64() or ""
        local steamID = target:IsBot() and "BOT" or target:SteamID() or ""
        local char = target:getChar()
        local charID = char and char:getID() or ""
        local model = target:GetModel() or ""
        self.quickActions[#self.quickActions + 1] = {
            label = "Steam Profile",
            icon = "icon16/world_link.png",
            callback = function() if steamID64 ~= "" and steamID64 ~= "BOT" then gui.OpenURL("https://steamcommunity.com/profiles/" .. steamID64) end end
        }

        self.quickActions[#self.quickActions + 1] = {
            label = "Copy SteamID",
            icon = "icon16/page_copy.png",
            callback = function() adminStickCopyText(steamID) end
        }

        self.quickActions[#self.quickActions + 1] = {
            label = "Copy SteamID64",
            icon = "icon16/page_copy.png",
            callback = function() adminStickCopyText(steamID64) end
        }

        self.quickActions[#self.quickActions + 1] = {
            label = "Copy CharID",
            icon = "icon16/page_copy.png",
            callback = function() adminStickCopyText(charID, "adminStickCopiedCharID") end
        }

        self.quickActions[#self.quickActions + 1] = {
            label = "Copy Model",
            icon = "icon16/page_copy.png",
            callback = function() adminStickCopyText(model) end
        }
    else
        self.quickActions[#self.quickActions + 1] = {
            label = "Copy Class",
            icon = "icon16/page_copy.png",
            callback = function() adminStickCopyText(target:GetClass()) end
        }

        self.quickActions[#self.quickActions + 1] = {
            label = "Copy EntIndex",
            icon = "icon16/page_copy.png",
            callback = function() adminStickCopyText(target:EntIndex()) end
        }
    end
end

function ADMIN_STICK_PANEL:BuildTargetHeader()
    self.targetHeader:Clear()
    local target = self.target
    if not IsValid(target) then return end
    local showHeader = adminStickShouldShowTargetHeader(target)
    self.targetHeader:SetVisible(showHeader)
    self.targetHeader:SetTall(showHeader and 142 or 0)
    self.targetHeader:DockMargin(12, showHeader and 12 or 0, 12, showHeader and 12 or 0)
    if not showHeader then return end
    local accent = getAdminStickTheme()
    local avatarSize = 84
    local avatarWrap = self.targetHeader:Add("DPanel")
    avatarWrap:SetSize(avatarSize, avatarSize)
    avatarWrap.Paint = function(_, w, h) drawAdminStickPanel(0, 0, w, h, 8, Color(4, 16, 21, 230), Color(accent.r, accent.g, accent.b, 110)) end
    if target:IsPlayer() then
        avatarWrap.Paint = nil
        local avatar = avatarWrap:Add("CircularAvatar")
        avatar:SetSize(avatarSize, avatarSize)
        avatar:SetPos(0, 0)
        avatar:SetPlayer(target, 96)
    else
        avatarWrap.Paint = function(_, w, h) drawAdminStickPanel(0, 0, w, h, 8, Color(4, 16, 21, 230), Color(accent.r, accent.g, accent.b, 110)) end
    end

    local name = adminStickGetTargetName(target)
    local subtitle = adminStickGetTargetSubtitle(target)
    local textX = 16 + avatarSize + 14
    local nameLabel = self:CreateHeaderLabel(self.targetHeader, name, "LiliaFont.30", Color(242, 247, 247), textX, 24, 300, 30)
    local subtitleLabel = self:CreateHeaderLabel(self.targetHeader, subtitle, "LiliaFont.18", Color(accent.r, accent.g, accent.b, 235), textX, 53, 300, 22)
    local steamLabel
    local userGroupLabel
    if target:IsPlayer() then
        local steamName = target:IsBot() and "BOT" or target:SteamName() or ""
        local userGroup = target:GetUserGroup() or ""
        steamLabel = self:CreateHeaderLabel(self.targetHeader, "Steam Name: " .. steamName, "LiliaFont.17", Color(190, 210, 210), textX, 82, 300, 20)
        userGroupLabel = self:CreateHeaderLabel(self.targetHeader, "Usergroup: " .. userGroup, "LiliaFont.17", Color(190, 210, 210), textX, 104, 300, 20)
    end

    local chipArea = self.targetHeader:Add("DPanel")
    chipArea.Paint = function() end
    chipArea.PerformLayout = function(panel, w, h)
        local children = panel:GetChildren()
        local columns = 2
        local gapX = 12
        local gapY = 7
        local chipH = 32
        local chipW = math.floor((w - gapX) / columns)
        local rows = math.ceil(#children / columns)
        local contentH = rows > 0 and rows * chipH + (rows - 1) * gapY or 0
        local startY = math.max(math.floor((h - contentH) * 0.5), 0)
        for index, chip in ipairs(children) do
            local i = index - 1
            local column = i % columns
            local row = math.floor(i / columns)
            chip:SetPos(column * (chipW + gapX), startY + row * (chipH + gapY))
            chip:SetSize(chipW, chipH)
        end
    end

    self.targetHeader.PerformLayout = function(_, w, h)
        local avatarY = math.floor((h - avatarSize) * 0.5)
        local chipX = math.floor(w * 0.46)
        local chipWidth = math.max(w - chipX - 16, 1)
        local infoWidth = math.max(chipX - textX - 24, 120)
        avatarWrap:SetPos(16, avatarY)
        nameLabel:SetPos(textX, 24)
        nameLabel:SetSize(infoWidth, 30)
        subtitleLabel:SetPos(textX, 53)
        subtitleLabel:SetSize(infoWidth, 22)
        if IsValid(steamLabel) then
            steamLabel:SetPos(textX, 82)
            steamLabel:SetSize(infoWidth, 20)
        end

        if IsValid(userGroupLabel) then
            userGroupLabel:SetPos(textX, 104)
            userGroupLabel:SetSize(infoWidth, 20)
        end

        chipArea:SetPos(chipX, 16)
        chipArea:SetSize(chipWidth, math.max(h - 32, 1))
    end

    for _, data in ipairs(self.quickActions or {}) do
        self:CreateChip(chipArea, data.label, data.icon, data.callback)
    end

    self.targetHeader:InvalidateLayout(true)
end

function ADMIN_STICK_PANEL:BuildCategories()
    self.categoryList:Clear()
    self.categories = {}
    self.categoryOrder = {}
    for _, action in ipairs(self.actions or {}) do
        if not self.categories[action.category] then
            self.categories[action.category] = {
                name = action.category,
                icon = GetIconForCategory(action.category),
                count = 0
            }

            self.categoryOrder[#self.categoryOrder + 1] = action.category
        end

        self.categories[action.category].count = self.categories[action.category].count + 1
    end

    if IsValid(self.target) and self.target.isDoor and self.target:isDoor() then
        self.categories.doorAccess = {
            name = "Door Access",
            icon = GetIconForCategory("doorAccess"),
            count = 0,
            isDoorAccess = true
        }

        self.categoryOrder[#self.categoryOrder + 1] = "doorAccess"
    end

    if IsValid(self.target) and self.target:IsPlayer() then
        local client = LocalPlayer()
        if client:hasPrivilege("manageWhitelists") then
            self.categories.playerWhitelists = {
                name = "Whitelists",
                icon = GetIconForCategory("whitelist"),
                count = 0,
                isPlayerWhitelists = true
            }

            self.categoryOrder[#self.categoryOrder + 1] = "playerWhitelists"
        end

        if client:hasPrivilege("manageTransfers") then
            self.categories.playerFactionTransfer = {
                name = "Faction Transfer",
                icon = GetIconForCategory("faction"),
                count = 0,
                isPlayerFactionTransfer = true
            }

            self.categoryOrder[#self.categoryOrder + 1] = "playerFactionTransfer"
        end
    end

    table.sort(self.categoryOrder, function(a, b) return a < b end)
    for _, category in ipairs(self.categoryOrder) do
        self:CreateCategoryButton(category)
    end

    if not self.activeCategory or not self.categories[self.activeCategory] then self.activeCategory = self.categoryOrder[1] end
    self:RebuildActions()
end

function ADMIN_STICK_PANEL:CreateCategoryButton(category)
    local data = self.categories[category]
    local button = self.categoryList:Add("DButton")
    button:Dock(TOP)
    button:SetTall(48)
    button:DockMargin(0, 0, 0, 7)
    button:SetText("")
    button.Paint = function(s, w, h)
        local accent = getAdminStickTheme()
        local active = self.activeCategory == category
        local hovered = s:IsHovered()
        local bg = active and Color(accent.r, accent.g, accent.b, 30) or hovered and Color(255, 255, 255, 7) or Color(2, 14, 18, 130)
        drawAdminStickPanel(0, 0, w, h, 6, bg, active and Color(accent.r, accent.g, accent.b, 135) or Color(accent.r, accent.g, accent.b, 42))
        if active then
            surface.SetDrawColor(accent.r, accent.g, accent.b, 245)
            surface.DrawRect(0, 7, 3, h - 14)
        end

        draw.SimpleText(data.name, "LiliaFont.17", 16, h * 0.5, active and Color(245, 249, 249) or Color(215, 228, 228), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if not (data.isDoorAccess or data.isPlayerWhitelists or data.isPlayerFactionTransfer) then draw.SimpleText(tostring(data.count), "LiliaFont.15", w - 18, h * 0.5, Color(accent.r, accent.g, accent.b, 220), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
    end

    button.DoClick = function()
        self.activeCategory = category
        self:RebuildActions()
    end
end

function ADMIN_STICK_PANEL:RebuildActions()
    local isDoorAccess = self.activeCategory == "doorAccess"
    local isPlayerWhitelists = self.activeCategory == "playerWhitelists"
    local isPlayerFactionTransfer = self.activeCategory == "playerFactionTransfer"
    local isSpecialCategory = isDoorAccess or isPlayerWhitelists or isPlayerFactionTransfer
    if IsValid(self.actionPanel) then self.actionPanel:SetVisible(not isSpecialCategory) end
    if IsValid(self.detailPanel) then self.detailPanel:SetVisible(not isSpecialCategory) end
    if IsValid(self.accessPanel) then self.accessPanel:SetVisible(isSpecialCategory) end
    if isDoorAccess then
        self:BuildDoorAccessPanel()
        self:RefreshDoorAccessState(true)
        return
    elseif isPlayerWhitelists then
        self:BuildPlayerWhitelistPanel()
        return
    elseif isPlayerFactionTransfer then
        self:BuildPlayerFactionTransferPanel()
        return
    end

    self.actionList:Clear()
    self.filteredActions = {}
    local search = IsValid(self.searchEntry) and string.Trim(self.searchEntry:GetValue() or ""):lower() or ""
    for _, action in ipairs(self.actions or {}) do
        local categoryMatch = action.category == self.activeCategory
        local searchMatch = search == "" or action.search:find(search, 1, true)
        if categoryMatch and searchMatch then self.filteredActions[#self.filteredActions + 1] = action end
    end

    for _, action in ipairs(self.filteredActions) do
        self:CreateActionButton(action)
    end

    if not self.selectedAction or self.selectedAction.category ~= self.activeCategory then self.selectedAction = self.filteredActions[1] end
    self:BuildDetails()
end

function ADMIN_STICK_PANEL:CreateActionButton(action)
    local button = self.actionList:Add("DButton")
    button:Dock(TOP)
    button:SetTall(52)
    button:DockMargin(0, 0, 0, 8)
    button:SetText("")
    button.Paint = function(s, w, h)
        local accent = getAdminStickTheme()
        local active = self.selectedAction == action
        local hovered = s:IsHovered()
        local outline = Color(accent.r, accent.g, accent.b, active and 135 or hovered and 85 or 45)
        if action.severity == "danger" then outline = Color(210, 85, 85, active and 160 or hovered and 110 or 55) end
        if action.severity == "warning" then outline = Color(225, 170, 80, active and 150 or hovered and 105 or 55) end
        local bg = active and Color(accent.r, accent.g, accent.b, 24) or hovered and Color(255, 255, 255, 7) or Color(2, 14, 18, 130)
        drawAdminStickPanel(0, 0, w, h, 6, bg, outline)
        draw.SimpleText(action.name, "LiliaFont.19", 16, h * 0.5, active and Color(245, 249, 249) or Color(230, 239, 239), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("›", "LiliaFont.30", w - 18, h * 0.5 - 1, Color(190, 210, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    button.DoClick = function()
        self.selectedAction = action
        self:BuildDetails()
    end

    button.DoDoubleClick = function()
        if action.groupedActions and #action.groupedActions == 1 then
            self:ExecuteAction(action.groupedActions[1])
        elseif not action.groupedActions then
            self:ExecuteAction(action)
        end
    end
end

function ADMIN_STICK_PANEL:GetActionArgumentState(action)
    self.actionArgumentState = self.actionArgumentState or setmetatable({}, {
        __mode = "k"
    })

    self.actionArgumentState[action] = self.actionArgumentState[action] or {}
    return self.actionArgumentState[action]
end

function ADMIN_STICK_PANEL:CollectActionArguments(action)
    local values = {}
    local state = self:GetActionArgumentState(action)
    for _, argument in ipairs(action.commandArguments or {}) do
        values[argument.name] = state[argument.name] or ""
    end
    return values
end

function ADMIN_STICK_PANEL:BuildActionArgumentFields(parent, action)
    local arguments = action.commandArguments or {}
    if #arguments == 0 then return end
    local accent = getAdminStickTheme()
    local state = self:GetActionArgumentState(action)
    local container = parent:Add("DPanel")
    container:Dock(TOP)
    container:SetTall(34)
    container:DockMargin(0, 0, 0, 14)
    container:DockPadding(0, 34, 0, 0)
    container.Paint = function(_, w)
        draw.SimpleText("ARGUMENTS", "LiliaFont.18", 0, 0, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(accent.r, accent.g, accent.b, 45)
        surface.DrawRect(0, 24, w, 1)
    end

    for _, argument in ipairs(arguments) do
        local row = container:Add("DPanel")
        row:Dock(TOP)
        row:SetTall(74)
        row:DockMargin(0, 8, 0, 0)
        row.Paint = function() end
        local titleText = (argument.description or argument.name or "Argument") .. (argument.optional and " (optional)" or "")
        local label = row:Add("DPanel")
        label:Dock(TOP)
        label:DockMargin(0, 0, 0, 6)
        label.lines = {titleText}
        label.lineHeight = 18
        label.Paint = function(panel, w, h)
            local y = 0
            for _, line in ipairs(panel.lines or {}) do
                draw.SimpleText(line, "LiliaFont.16", 0, y, Color(170, 192, 194), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                y = y + panel.lineHeight
            end
        end

        local entry = row:Add("liaEntry")
        entry:Dock(BOTTOM)
        entry:SetTall(34)
        entry:SetFont("LiliaFont.16")
        entry:SetText(state[argument.name] or "")
        entry:SetUpdateOnType(true)
        entry:SetPlaceholderText(string.format("%s (%s)", tostring(argument.name or "argument"), tostring(argument.type or "string")))
        entry:SetCursorColor(lia.color.theme.accent)
        if argument.type == "number" or argument.type == "int" or argument.type == "float" then entry:SetNumeric(true) end
        entry.OnValueChange = function(_, value) state[argument.name] = value end
        entry.OnTextChanged = function(field) state[argument.name] = field:GetValue() end
        row.PerformLayout = function(panel, w)
            local availableWidth = math.max(w, 1)
            local wrappedLines = lia.util.wrapText(titleText, availableWidth, "LiliaFont.16")
            label.lines = wrappedLines and #wrappedLines > 0 and wrappedLines or {titleText}
            surface.SetFont("LiliaFont.16")
            local _, lineHeight = surface.GetTextSize("Ag")
            label.lineHeight = math.max(lineHeight, 18)
            label:SetTall(#label.lines * label.lineHeight)
            panel:SetTall(label:GetTall() + entry:GetTall() + 10)
        end
    end

    container.PerformLayout = function(panel, _, _)
        local totalHeight = 34
        for _, child in ipairs(panel:GetChildren()) do
            if child ~= nil and IsValid(child) then
                local _, top, _, bottom = child:GetDockMargin()
                totalHeight = totalHeight + child:GetTall() + top + bottom
            end
        end

        panel:SetTall(totalHeight)
    end
end

function ADMIN_STICK_PANEL:BuildDetails()
    self.detailScroll:Clear()
    local action = self.selectedAction
    if not action then
        local empty = self.detailScroll:Add("DLabel")
        empty:Dock(FILL)
        empty:SetFont("LiliaFont.18")
        empty:SetTextColor(Color(150, 174, 176))
        empty:SetContentAlignment(5)
        empty:SetText("No actions available.")
        return
    end

    local accent = getAdminStickTheme()
    local executableActions = action.groupedActions or {action}
    local iconBox = self.detailScroll:Add("DPanel")
    iconBox:Dock(TOP)
    iconBox:SetTall(82)
    iconBox:DockMargin(0, 0, 0, 12)
    iconBox.Paint = function(_, w, h)
        drawAdminStickPanel(0, 0, w, 72, 7, Color(7, 24, 29, 235), Color(accent.r, accent.g, accent.b, 80))
        draw.SimpleText(action.name, "LiliaFont.23", 16, 7, Color(242, 247, 247), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(action.category, "LiliaFont.17", 16, 39, Color(170, 192, 194), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local lines = {{"Category", action.category}, {"Available", tostring(#executableActions)}, {"Target", adminStickGetTargetName(self.target)}}
    local details = self.detailScroll:Add("DPanel")
    details:Dock(TOP)
    details:SetTall(118)
    details:DockMargin(0, 0, 0, 14)
    details.Paint = function(_, w, h)
        draw.SimpleText("INFORMATION", "LiliaFont.18", 0, 0, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        local y = 34
        for _, line in ipairs(lines) do
            surface.SetDrawColor(255, 255, 255, 18)
            surface.DrawRect(0, y + 24, w, 1)
            draw.SimpleText(line[1], "LiliaFont.16", 0, y, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(tostring(line[2]), "LiliaFont.16", w, y, Color(225, 236, 236), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            y = y + 30
        end
    end

    if #executableActions == 1 then self:BuildActionArgumentFields(self.detailScroll, executableActions[1]) end
    local buttonContainer = self.detailScroll:Add("DPanel")
    buttonContainer:Dock(TOP)
    buttonContainer:SetTall(#executableActions * 50 + math.max(#executableActions - 1, 0) * 8)
    buttonContainer.Paint = function() end
    for index, executableAction in ipairs(executableActions) do
        local execute = buttonContainer:Add("DButton")
        execute:Dock(TOP)
        execute:SetTall(50)
        execute:DockMargin(0, 0, 0, index == #executableActions and 0 or 8)
        execute:SetText("")
        execute.Paint = function(button, w, h)
            local hovered = button:IsHovered()
            local color = accent
            if executableAction.severity == "danger" then color = Color(210, 85, 85) end
            if executableAction.severity == "warning" then color = Color(225, 170, 80) end
            drawAdminStickPanel(0, 0, w, h, 6, hovered and Color(color.r, color.g, color.b, 35) or Color(8, 28, 33, 230), Color(color.r, color.g, color.b, hovered and 170 or 110))
            draw.SimpleText(executableAction.executeLabel or executableAction.name, "LiliaFont.18", w * 0.5, h * 0.5, hovered and Color(245, 249, 249) or Color(color.r, color.g, color.b), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        execute.DoClick = function() self:ExecuteAction(executableAction) end
    end
end

function ADMIN_STICK_PANEL:ExecuteAction(action)
    if not action or self._executing or action.groupedActions then return end
    self._executing = true
    local keepOpen = action.category == "Faction" or action.category == "Class"
    if isfunction(action.callback) then action.callback(self:CollectActionArguments(action)) end
    if keepOpen then
        local target = self.target
        AdminStickIsOpen = true
        AdminStickMenu = self
        local client = LocalPlayer()
        if IsValid(client) then client.AdminStickTarget = target end
        timer.Simple(0.15, function()
            if not IsValid(self) then return end
            self._executing = false
            AdminStickIsOpen = true
            AdminStickMenu = self
            local refreshedClient = LocalPlayer()
            if IsValid(refreshedClient) then refreshedClient.AdminStickTarget = target end
        end)
        return
    end

    timer.Simple(0.05, function() if IsValid(self) then self:Remove() end end)
end

vgui.Register("liaAdminStickPanel", ADMIN_STICK_PANEL, "EditablePanel")
