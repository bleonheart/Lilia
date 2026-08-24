--[[
    Hooks:
        DoorEnabledToggled(client, door, newState)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("DoorEnabledToggled", "liaExampleDoorEnabledToggled", function(client, door, newState)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        DoorHiddenToggled(client, entity, newState)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("DoorHiddenToggled", "liaExampleDoorHiddenToggled", function(client, entity, newState)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        DoorOwnableToggled(client, door, newState)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("DoorOwnableToggled", "liaExampleDoorOwnableToggled", function(client, door, newState)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        DoorPriceSet(client, door, price)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("DoorPriceSet", "liaExampleDoorPriceSet", function(client, door, price)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        DoorTitleSet(client, door, name)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("DoorTitleSet", "liaExampleDoorTitleSet", function(client, door, name)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        ForceRecognizeRange(ply, range, fakeName)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("ForceRecognizeRange", "liaExampleForceRecognizeRange", function(ply, range, fakeName)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        OnPlayerPurchaseDoor(client, door, arg3)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("OnPlayerPurchaseDoor", "liaExampleOnPlayerPurchaseDoor", function(client, door, arg3)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        OnTransferred(target)

    Purpose:
        temp

    Category:
        temp

    Parameters:
        temp

    Example Usage:
        ```lua
        hook.Add("OnTransferred", "liaExampleOnTransferred", function(target)
            temp
        end)
        ```

    Realm:
        temp
]]
--[[
    Hooks:
        CommandAdded(string command, table data)

    Purpose:
        Runs after a command has been registered with `lia.command.add`.

    Category:
        Commands

    Parameters:
        command (string)
            The command name that was registered.

        data (table)
            The command definition table stored in `lia.command.list`.

    Example Usage:
        ```lua
        hook.Add("CommandAdded", "liaExampleCommandAdded", function(command, data)
            print("[MyModule] handled CommandAdded")
        end)
        ```

    Realm:
        Shared
]]
--[[
    Hooks:
        CanPlayerUseCommand(Player client, string command)

    Purpose:
        Allows plugins or modules to override whether a player can use a command after normal privilege checks are prepared.

    Category:
        Commands

    Parameters:
        client (Player)
            The player whose command access is being checked.

        command (string)
            The command name being checked.

    Example Usage:
        ```lua
        hook.Add("CanPlayerUseCommand", "liaExampleCanPlayerUseCommand", function(client, command)
            if IsValid(client) and client:IsAdmin() then
                return true
            end
        end)
        ```

    Returns:
        boolean|nil
            Return true to allow the command, false to deny it, or nil to keep the normal access result.

    Realm:
        Shared
]]
--[[
    Hooks:
        CommandRan(Player client, string command, table arguments, table results)

    Purpose:
        Runs after a command callback has executed.

    Category:
        Commands

    Parameters:
        client (Player)
            The player who ran the command.

        command (string)
            The command name that was executed.

        arguments (table)
            The parsed command arguments passed to the command.

        results (table)
            The return values from the command callback.

    Example Usage:
        ```lua
        hook.Add("CommandRan", "liaExampleCommandRan", function(client, command, arguments, results)
            if not IsValid(client) then return end
            print(string.format("[MyModule] handled CommandRan for %s", client:Name()))
        end)
        ```

    Realm:
        Server
]]
--[[
    Hooks:
        OnCharGetup(Player target, Entity entity)

    Purpose:
        Runs just before a ragdolled character gets up and their ragdoll entity is removed.

    Category:
        Character

    Parameters:
        target (Player)
            The player getting up from ragdoll state.

        entity (Entity)
            The ragdoll entity that is about to be removed.

    Returns:
        nil

    Example Usage:
        ```lua
        hook.Add("OnCharGetup", "liaExampleOnCharGetup", function(target, entity)
            if IsValid(target) then
                print(target:Nick(), "got up")
            end
        end)
        ```

    Realm:
        Server
]]
--[[
    Folder: Developer - Libraries
    File: lia.command.md
]]
--[[
    Command

    Command registration, parsing, permissions, argument prompts, and network dispatch helpers for Lilia commands.
]]
--[[
    Overview:
        The command library centralizes shared command registration under `lia.command`, normalizes command argument metadata, manages command aliases and privilege checks, parses chat commands on the server, opens clientside argument prompts for missing required arguments, and sends command payloads from the client to the server.
]]
lia.command = lia.command or {}
lia.command.list = lia.command.list or {}
--[[
    Purpose:
        Builds a display syntax string from a command argument definition list.

    Parameters:
        args (table)
            Sequential command argument definitions. Each entry may define `name`, `type`, and `optional`.

    Returns:
        string
            A space-separated syntax string in bracketed argument format.

    Example Usage:
        ```lua
        local syntax = lia.command.buildSyntaxFromArguments({
            {name = "target", type = "player"},
            {name = "reason", type = "string", optional = true}
        })
        ```

    Realm:
        Shared
]]
function lia.command.buildSyntaxFromArguments(args)
    local tokens = {}
    for _, arg in ipairs(args) do
        local typ = arg.type or "string"
        if typ == "bool" or typ == "boolean" then
            typ = "bool"
        elseif typ == "player" then
            typ = "player"
        elseif typ == "table" then
            typ = "table"
        else
            typ = "string"
        end

        local name = lia.lang.resolveToken(arg.name or typ)
        local optional = arg.optional and " optional" or ""
        tokens[#tokens + 1] = string.format("[%s %s%s]", typ, name, optional)
    end
    return table.concat(tokens, " ")
end

--[[
    Purpose:
        Registers a Lilia command, resolves localized command metadata, normalizes argument definitions, creates aliases, registers admin privileges when required, and wraps the command callback with access checks.

    Parameters:
        command (string)
            The command name to register.

        data (table)
            The command definition. Expected fields include `onRun`, and may include `arguments`, `syntax`, `desc`, `alias`, `adminOnly`, `superAdminOnly`, `privilege`, `privilegeName`, `AdminStick`, and `onCheckAccess`.

    Example Usage:
        ```lua
        lia.command.add("example", {
            desc = "@exampleDesc",
            arguments = {
                {name = "target", type = "player"}
            },
            onRun = function(client, arguments)
                client:notifyInfo("Example command ran.")
            end
        })
        ```

    Realm:
        Shared
]]
function lia.command.add(command, data)
    data.arguments = data.arguments or {}
    data.syntax = data.syntax or lia.command.buildSyntaxFromArguments(data.arguments)
    data.syntax = isstring(data.syntax) and lia.lang.resolveToken(data.syntax) or data.syntax or ""
    data.desc = isstring(data.desc) and lia.lang.resolveToken(data.desc) or data.desc or ""
    if istable(data.AdminStick) then
        data.AdminStick.Name = isstring(data.AdminStick.Name) and lia.lang.resolveToken(data.AdminStick.Name) or data.AdminStick.Name
        data.AdminStick.ButtonText = isstring(data.AdminStick.ButtonText) and lia.lang.resolveToken(data.AdminStick.ButtonText) or data.AdminStick.ButtonText
        data.AdminStick.Category = isstring(data.AdminStick.Category) and lia.lang.resolveToken(data.AdminStick.Category) or data.AdminStick.Category
        data.AdminStick.SubCategory = isstring(data.AdminStick.SubCategory) and lia.lang.resolveToken(data.AdminStick.SubCategory) or data.AdminStick.SubCategory
    end

    if isstring(data.privilege) and data.privilege:sub(1, 1) == "@" then
        data.privilegeName = lia.lang.resolveToken(data.privilege)
        data.privilege = data.privilege:sub(2)
    else
        data.privilegeName = data.privilegeName or data.privilege
    end

    data.privilege = data.privilege or nil
    local superAdminOnly = data.superAdminOnly
    local adminOnly = data.adminOnly
    if not data.onRun then
        lia.error(L("commandNoCallback", command))
        return
    end

    if superAdminOnly or adminOnly then
        local privilegeName = data.privilegeName or L("accessTo", command)
        local privilegeID = data.privilege or string.lower("command_" .. command)
        lia.admin.registerPrivilege({
            Name = privilegeName,
            ID = privilegeID,
            MinAccess = superAdminOnly and "superadmin" or "admin",
            Category = "@staffPermissions"
        })
    end

    for _, arg in ipairs(data.arguments) do
        if arg.type == "boolean" then
            arg.type = "bool"
        elseif arg.type ~= "player" and arg.type ~= "table" and arg.type ~= "bool" then
            arg.type = "string"
        end

        arg.description = isstring(arg.description) and lia.lang.resolveToken(arg.description) or arg.description
        arg.optional = arg.optional or false
    end

    local onRun = data.onRun
    local onCheckAccess = data.onCheckAccess
    data._onRun = data.onRun
    data.onRun = function(client, arguments)
        local accessResult
        if onCheckAccess then
            accessResult, privilegeName = onCheckAccess(client, command, data)
            if accessResult ~= nil then
                if accessResult then
                    return onRun(client, arguments)
                else
                    return "@noPerm"
                end
            end
        end

        if accessResult == nil then accessResult, privilegeName = lia.command.hasAccess(client, command, data) end
        if accessResult then
            return onRun(client, arguments)
        else
            return "@noPerm"
        end
    end

    local alias = data.alias
    if alias then
        if istable(alias) then
            for _, v in ipairs(alias) do
                local aliasData = table.Copy(data)
                aliasData.realCommand = command
                lia.command.list[v:lower()] = aliasData
                if superAdminOnly or adminOnly then
                    local aliasPrivilegeID = data.privilege or string.lower("command_" .. v)
                    lia.admin.registerPrivilege({
                        Name = data.privilegeName or L("accessTo", v),
                        ID = aliasPrivilegeID,
                        MinAccess = superAdminOnly and "superadmin" or "admin",
                        Category = "@commands"
                    })
                end
            end
        elseif isstring(alias) then
            local aliasData = table.Copy(data)
            aliasData.realCommand = command
            lia.command.list[alias:lower()] = aliasData
            if superAdminOnly or adminOnly then
                local aliasPrivilegeID = data.privilege or string.lower("command_" .. alias)
                lia.admin.registerPrivilege({
                    Name = data.privilegeName or L("accessTo", alias),
                    ID = aliasPrivilegeID,
                    MinAccess = superAdminOnly and "superadmin" or "admin",
                    Category = "@commands"
                })
            end
        end
    end

    if command == command:lower() then
        lia.command.list[command] = data
    else
        data.realCommand = command
        lia.command.list[command:lower()] = data
    end

    hook.Run("CommandAdded", command, data)
end

--[[
    Purpose:
        Checks whether a player can use a registered command.

    Parameters:
        client (Player)
            The player whose access is being checked.

        command (string)
            The command name being checked.

        data (table)
            Optional command definition. When omitted, the command is looked up in `lia.command.list`.

    Returns:
        boolean
            True when the player can use the command, otherwise false.

        string
            The display name of the privilege or access level used for the check.

    Example Usage:
        ```lua
        local canUse, privilege = lia.command.hasAccess(client, "plygetplaytime")
        if not canUse then
            client:notifyErrorLocalized("noPerm")
        end
        ```

    Realm:
        Shared
]]
function lia.command.hasAccess(client, command, data)
    if not data then data = lia.command.list[command] end
    if not data then return false, "unknown" end
    local privilegeID = data.privilege or string.lower("command_" .. command)
    local superAdminOnly = data.superAdminOnly
    local adminOnly = data.adminOnly
    local accessLevels = superAdminOnly and "superadmin" or adminOnly and "admin" or "user"
    local privilegeName = data.privilegeName or accessLevels == "user" and L("globalAccess") or L("accessTo", command)
    if data.onCheckAccess then
        local accessResult, customPrivilegeName = data.onCheckAccess(client, command, data)
        if accessResult ~= nil then return accessResult, customPrivilegeName or privilegeName end
    end

    local hasAccess = true
    if accessLevels ~= "user" then
        if not isstring(privilegeID) then
            lia.error(L("invalidPrivilegeIDType"))
            return false, privilegeName
        end

        hasAccess = client:hasPrivilege(privilegeID)
        lia.debug("[Permissions]", "Permission Check for function lia.command.hasAccess", "command=", tostring(command), "privilegeID=", tostring(privilegeID), "accessLevels=", tostring(accessLevels), "hasPrivilege=", tostring(hasAccess))
    end

    local hookResult = hook.Run("CanPlayerUseCommand", client, command)
    if hookResult ~= nil then return hookResult, privilegeName end
    local char = IsValid(client) and client.getChar and client:getChar()
    if char then
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.commands and table.HasValue(faction.commands, command) then return true, privilegeName end
        local classData = lia.class.list[char:getClass()]
        if classData and classData.commands and table.HasValue(classData.commands, command) then return true, privilegeName end
    end

    lia.debug("[Permissions]", "Permission Check for function lia.command.hasAccess final", "command=", tostring(command), "privilegeID=", tostring(privilegeID), "finalResult=", tostring(hasAccess))
    return hasAccess, privilegeName
end

--[[
    Purpose:
        Splits a raw command argument string into arguments while preserving quoted text as a single argument.

    Parameters:
        text (string)
            The raw argument string to parse.

    Returns:
        table
            Sequential command arguments extracted from the input string.

    Example Usage:
        ```lua
        local arguments = lia.command.extractArgs("target \"quoted reason\"")
        ```

    Realm:
        Shared
]]
function lia.command.extractArgs(text)
    local skip = 0
    local arguments = {}
    local curString = ""
    for i = 1, #text do
        if i > skip then
            local c = text:sub(i, i)
            if c == "\"" or c == "'" then
                local match = text:sub(i):match("%b" .. c .. c)
                if match then
                    curString = ""
                    skip = i + #match
                    arguments[#arguments + 1] = match:sub(2, -2)
                else
                    curString = curString .. c
                end
            elseif c == " " and curString ~= "" then
                arguments[#arguments + 1] = curString
                curString = ""
            else
                if not (c == " " and curString == "") then curString = curString .. c end
            end
        end
    end

    if curString ~= "" then arguments[#arguments + 1] = curString end
    return arguments
end

local function combineBracketArgs(args)
    local result = {}
    local buffer
    for _, a in ipairs(args) do
        if buffer then
            buffer = buffer .. " " .. a
            if a:sub(-1) == "]" then
                result[#result + 1] = buffer
                buffer = nil
            end
        elseif a:sub(1, 1) == "[" and a:sub(-1) ~= "]" then
            buffer = a
            if a:sub(-1) == "]" then
                result[#result + 1] = buffer
                buffer = nil
            end
        else
            result[#result + 1] = a
        end
    end

    if buffer then result[#result + 1] = buffer end
    return result
end

local function isPlaceholder(arg)
    return isstring(arg) and arg:sub(1, 1) == "[" and arg:sub(-1) == "]"
end

if SERVER then
    --[[
    Purpose:
        Executes a registered command callback and handles localized string return values as player notifications.

    Parameters:
        client (Player)
            The player running the command.

        command (string)
            The command name to execute.

        arguments (table)
            Optional parsed arguments to pass to the command callback.

    Example Usage:
        ```lua
        lia.command.run(client, "playtime", {})
        ```

    Realm:
        Server
    ]]
    function lia.command.run(client, command, arguments)
        local commandTbl = lia.command.list[command:lower()]
        if commandTbl then
            local results = {commandTbl.onRun(client, arguments or {})}
            hook.Run("CommandRan", client, command, arguments or {}, results)
            local result = results[1]
            if isstring(result) then
                if IsValid(client) then
                    if result:sub(1, 1) == "@" then
                        client:notifyInfoLocalized(result:sub(2), unpack(results, 2))
                    else
                        client:notifyErrorLocalized(result)
                    end
                end
            end
        end
    end

    --[[
    Purpose:
        Parses chat command text, checks command access, prompts the player for missing required arguments when needed, and runs the command.

    Parameters:
        client (Player)
            The player whose input is being parsed.

        text (string)
            The raw chat text or command text.

        realCommand (string)
            Optional command name to run instead of parsing one from `text`.

        arguments (table)
            Optional pre-parsed command arguments.

    Returns:
        boolean
            True when the text was handled as a command, otherwise false.

    Example Usage:
        ```lua
        hook.Add("PlayerSay", "ParseLiliaCommands", function(client, text)
            if lia.command.parse(client, text) then return "" end
        end)
        ```

    Realm:
        Server
    ]]
    function lia.command.parse(client, text, realCommand, arguments)
        if realCommand or utf8.sub(text, 1, 1) == "/" then
            local match = realCommand or text:lower():match("/" .. "([_%w]+)")
            if not match then
                local post = string.Explode(" ", text)
                local len = string.len(post[1])
                match = utf8.sub(post[1], 2, len)
            end

            match = match:lower()
            local command = lia.command.list[match]
            if command then
                local hasAccess = lia.command.hasAccess(client, match, command)
                if not hasAccess then
                    if IsValid(client) then client:notifyErrorLocalized("noAccess") end
                    return true
                end

                if not arguments then arguments = lia.command.extractArgs(text:sub(#match + 3)) end
                local fields = command.arguments or {}
                if IsValid(client) and client:IsPlayer() and #fields > 0 then
                    local tokens = combineBracketArgs(arguments)
                    local missing = {}
                    local prefix = {}
                    for i, field in ipairs(fields) do
                        local arg = tokens[i]
                        local isMissing = not arg or isPlaceholder(arg)
                        if isMissing then
                            if not field.optional then missing[#missing + 1] = field.name end
                        else
                            prefix[#prefix + 1] = arg
                        end
                    end

                    if #missing > 0 then
                        net.Start("liaCmdArgPrompt")
                        net.WriteString(match)
                        net.WriteTable(missing)
                        net.WriteTable(prefix)
                        net.WriteTable(command.arguments or {})
                        net.Send(client)
                        return true
                    end
                end

                lia.command.run(client, match, arguments)
                if not realCommand then lia.log.add(client, "command", text) end
            else
                if IsValid(client) then
                    client:notifyErrorLocalized("cmdNoExist")
                else
                    lia.information(L("cmdNoExist"))
                end
            end
            return true
        end
        return false
    end
else
    --[[
    Purpose:
        Opens the clientside command argument prompt for missing required command arguments.

    Parameters:
        cmdKey (string)
            The command key being completed.

        missing (table)
            Argument names that still need values.

        prefix (table)
            Arguments already supplied before the prompt opened.

        definitions (table)
            Optional argument definitions used when the command is not available locally.

    Example Usage:
        ```lua
        lia.command.openArgumentPrompt("example", {"target"}, {}, definitions)
        ```

    Realm:
        Client
    ]]
    function lia.command.openArgumentPrompt(cmdKey, missing, prefix, definitions)
        local command = lia.command.list[cmdKey] or {
            arguments = definitions or {}
        }

        if not command then return end
        local fields = {}
        local lookup = {}
        for _, name in ipairs(missing or {}) do
            lookup[name] = true
        end

        for _, arg in ipairs(command.arguments or {}) do
            if lookup[arg.name] then fields[arg.name] = arg end
        end

        prefix = prefix or {}
        local numFields = table.Count(fields)
        local frameW, frameH = 600, math.min(450 + numFields * 135, ScrH() * 0.5)
        local frame = vgui.Create("liaFrame")
        frame:SetTitle("")
        frame:SetCenterTitle(L(cmdKey))
        frame:SetSize(frameW, frameH)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(false)
        frame:SetZPos(1000)
        local scroll = vgui.Create("liaScrollPanel", frame)
        scroll:Dock(FILL)
        scroll:DockMargin(10, 40, 10, 10)
        surface.SetFont("LiliaFont.17")
        local controls = {}
        local watchers = {}
        local validate
        for _, arg in ipairs(command.arguments or {}) do
            local name = arg.name
            if fields[name] then
                local data = arg
                local fieldType = data.type
                local optional = data.optional
                local options = data.options
                local filter = data.filter
                local panel = vgui.Create("DPanel", scroll)
                panel:Dock(TOP)
                panel:DockMargin(0, 0, 0, 15)
                panel:SetTall(120)
                panel.Paint = nil
                surface.SetFont("LiliaFont.20")
                local textW = select(1, surface.GetTextSize(L(data.description or name)))
                local ctrl
                if fieldType == "player" then
                    ctrl = vgui.Create("liaComboBox", panel)
                    ctrl:SetValue(L("select") .. " " .. L("player"))
                    local players = {}
                    for _, plyObj in player.Iterator() do
                        if IsValid(plyObj) then players[#players + 1] = plyObj end
                    end

                    if isfunction(filter) then
                        local ok, res = pcall(filter, LocalPlayer(), players)
                        if ok and istable(res) then players = res end
                    end

                    for _, plyObj in ipairs(players) do
                        local identifier = plyObj:SteamID()
                        if identifier == "BOT" then identifier = plyObj:Name() end
                        ctrl:AddChoice(plyObj:Name(), identifier)
                    end

                    ctrl:FinishAddingOptions()
                    ctrl:PostInit()
                elseif fieldType == "table" then
                    ctrl = vgui.Create("liaComboBox", panel)
                    ctrl:SetValue(L("select") .. " " .. L(name))
                    local opts = options
                    if isfunction(opts) then
                        local ok, res = pcall(opts, LocalPlayer(), prefix)
                        if ok then opts = res end
                    end

                    if istable(opts) then
                        for k, v in pairs(opts) do
                            if isnumber(k) then
                                ctrl:AddChoice(tostring(v), v)
                            else
                                ctrl:AddChoice(tostring(k), v)
                            end
                        end
                    end

                    ctrl:FinishAddingOptions()
                    ctrl:PostInit()
                elseif fieldType == "bool" then
                    ctrl = vgui.Create("liaCheckbox", panel)
                else
                    ctrl = vgui.Create("liaEntry", panel)
                    ctrl:SetFont("LiliaFont.17")
                end

                local label = vgui.Create("DLabel", panel)
                label:SetFont("LiliaFont.20")
                label:SetText(L(data.description or name))
                label:SizeToContents()
                local isBool = fieldType == "bool"
                panel.PerformLayout = function(_, w, h)
                    local ctrlH, ctrlW
                    if isBool then
                        ctrlH, ctrlW = 22, 60
                    else
                        ctrlH, ctrlW = 60, w * 0.85
                    end

                    local ctrlX = (w - ctrlW) / 2
                    ctrl:SetPos(ctrlX, (h - ctrlH) / 2 + 6)
                    ctrl:SetSize(ctrlW, ctrlH)
                    label:SetPos((w - textW) / 2, (h - ctrlH) / 2 - 25)
                end

                controls[name] = {
                    ctrl = ctrl,
                    type = fieldType,
                    optional = optional
                }

                watchers[#watchers + 1] = function()
                    local oldValue = ctrl.OnValueChange
                    function ctrl:OnValueChange(...)
                        if oldValue then oldValue(self, ...) end
                        validate()
                    end

                    local oldText = ctrl.OnTextChanged
                    function ctrl:OnTextChanged(...)
                        if oldText then oldText(self, ...) end
                        validate()
                    end

                    local oldChange = ctrl.OnChange
                    function ctrl:OnChange(...)
                        if oldChange then oldChange(self, ...) end
                        validate()
                    end

                    local oldSelect = ctrl.OnSelect
                    function ctrl:OnSelect(...)
                        if oldSelect then oldSelect(self, ...) end
                        validate()
                    end
                end
            end
        end

        local buttons = vgui.Create("DPanel", frame)
        buttons:Dock(BOTTOM)
        buttons:SetTall(90)
        buttons:DockPadding(15, 15, 15, 15)
        buttons.Paint = function() end
        local submit = vgui.Create("liaButton", buttons)
        submit:Dock(LEFT)
        submit:DockMargin(0, 0, 15, 0)
        submit:SetWide(270)
        submit:SetTxt(L("submit"))
        submit:SetEnabled(false)
        validate = function()
            if not IsValid(submit) then return end
            for _, data in pairs(controls) do
                if not data.optional then
                    local ctl = data.ctrl
                    if not IsValid(ctl) then continue end
                    local ftype = data.type
                    local filled
                    if ftype == "player" or ftype == "table" then
                        local txt = ctl:GetValue()
                        filled = txt ~= nil and txt ~= "" and txt ~= "nil"
                    elseif ftype == "bool" then
                        filled = true
                    elseif ftype == "number" then
                        local val = ctl:GetValue()
                        local numVal = tonumber(val)
                        filled = val ~= nil and val ~= "" and val ~= "nil" and numVal ~= nil
                    else
                        local val = ctl:GetValue()
                        filled = val ~= nil and val ~= "" and val ~= "nil"
                    end

                    if not filled then
                        submit:SetEnabled(false)
                        return
                    end
                end
            end

            submit:SetEnabled(true)
        end

        timer.Simple(0.1, function() if IsValid(submit) then validate() end end)
        for _, fn in ipairs(watchers) do
            fn()
        end

        local cancel = vgui.Create("liaButton", buttons)
        cancel:Dock(RIGHT)
        cancel:SetWide(270)
        cancel:SetTxt(L("cancel"))
        cancel.DoClick = function() frame:Remove() end
        submit.DoClick = function()
            local args = {}
            if prefix then table.Add(args, prefix) end
            for _, arg in ipairs(command.arguments or {}) do
                local name = arg.name
                if controls[name] then
                    local info = controls[name]
                    local ctl = info.ctrl
                    local typ = info.type
                    local val
                    if typ == "player" or typ == "table" then
                        local dataVal = ctl:GetSelectedData()
                        val = dataVal or ctl:GetValue()
                    elseif typ == "bool" then
                        val = ctl:GetChecked()
                    elseif typ == "number" then
                        local strVal = ctl:GetValue()
                        val = strVal ~= nil and strVal ~= "" and strVal ~= "nil" and tonumber(strVal) or nil
                    else
                        val = ctl:GetValue()
                    end

                    args[#args + 1] = val ~= nil and val ~= "" and val ~= "nil" and val or nil
                end
            end

            RunConsoleCommand("say", "/" .. cmdKey .. " " .. table.concat(args, " "))
            frame:Remove()
        end
    end

    --[[
    Purpose:
        Sends a command and its arguments from the client to the server over the Lilia command net message.

    Parameters:
        command (string)
            The command name to send.

        ... (any)
            Arguments to send with the command.

    Example Usage:
        ```lua
        lia.command.send("playtime")
        ```

    Realm:
        Client
    ]]
    function lia.command.send(command, ...)
        net.Start("liaCommandData")
        net.WriteString(command)
        net.WriteTable({...})
        net.SendToServer()
    end
end

if CLIENT then
    local function drawCommandPanel(x, y, w, h, radius, color, outline)
        draw.RoundedBox(radius, x, y, w, h, color)
        if outline then
            surface.SetDrawColor(outline)
            surface.DrawOutlinedRect(x, y, w, h, 1)
        end
    end

    local function createCommandButton(parent, label, accented, callback)
        local button = parent:Add("DButton")
        button:SetText("")
        button.Paint = function(self, w, h)
            local accent, textColor = lia.color.theme.accent, lia.color.theme.text
            local hovered = self:IsHovered() and self:IsEnabled()
            local background
            local outline
            if accented then
                background = Color(accent.r, accent.g, accent.b, hovered and 32 or 16)
                outline = Color(accent.r, accent.g, accent.b, hovered and 185 or 120)
            else
                background = hovered and Color(255, 255, 255, 10) or Color(4, 17, 22, 210)
                outline = Color(160, 190, 192, hovered and 90 or 48)
            end

            if not self:IsEnabled() then
                background = Color(255, 255, 255, 5)
                outline = Color(255, 255, 255, 22)
            end

            drawCommandPanel(0, 0, w, h, 5, background, outline)
            local color = self:IsEnabled() and (accented and accent or textColor) or Color(115, 135, 136)
            draw.SimpleText(label, "LiliaFont.17", w * 0.5, h * 0.5, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        button.DoClick = function(self)
            if not self:IsEnabled() then return end
            lia.websound.playButtonSound()
            callback()
        end
        return button
    end

    local function addCommandInfoRow(parent, label, value, valueColor)
        local row = parent:Add("DPanel")
        row:Dock(TOP)
        row:SetTall(46)
        row.Paint = function(_, w, h)
            surface.SetDrawColor(130, 160, 162, 35)
            surface.DrawRect(0, h - 1, w, 1)
            draw.SimpleText(label, "LiliaFont.16", 14, h * 0.5, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(value or "", "LiliaFont.16", w - 14, h * 0.5, valueColor or Color(224, 235, 235), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        return row
    end

    hook.Add("CreateInformationButtons", "liaInformationCommandsUnified", function(pages)
        table.insert(pages, {
            name = "commands",
            shouldShow = function() return true end,
            drawFunc = function(parent)
                parent:Clear()
                local client = LocalPlayer()
                local root = parent:Add("DPanel")
                root:Dock(FILL)
                root.Paint = function() end
                local listPanel = root:Add("DPanel")
                listPanel:Dock(LEFT)
                listPanel:SetWide(math.Clamp(ScrW() * 0.245, 360, 440))
                listPanel:DockMargin(0, 0, 12, 0)
                listPanel:DockPadding(12, 12, 12, 12)
                listPanel.Paint = function(_, w, h)
                    local accent = lia.color.theme.accent
                    drawCommandPanel(0, 0, w, h, 7, Color(5, 18, 23, 215), Color(accent.r, accent.g, accent.b, 58))
                end

                local detailPanel = root:Add("DPanel")
                detailPanel:Dock(FILL)
                detailPanel.Paint = function() end
                local controls = listPanel:Add("DPanel")
                controls:Dock(TOP)
                controls:SetTall(46)
                controls:DockMargin(0, 0, 0, 12)
                controls.Paint = function() end
                local filter = controls:Add("DComboBox")
                filter:Dock(RIGHT)
                filter:SetWide(136)
                filter:DockMargin(8, 0, 0, 0)
                filter:SetValue("All Commands")
                filter:AddChoice("All Commands", "all")
                filter:AddChoice("General", "general")
                filter:AddChoice("Privileged", "privileged")
                filter:SetFont("LiliaFont.16")
                filter:SetTextColor(Color(0, 0, 0, 0))
                filter.Paint = function(self, w, h)
                    local accent = lia.color.theme.accent
                    drawCommandPanel(0, 0, w, h, 5, Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60))
                    draw.SimpleText(self:GetValue(), "LiliaFont.16", 12, h * 0.5, Color(215, 229, 229), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText("▼", "LiliaFont.15", w - 14, h * 0.5, Color(175, 197, 198), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local searchPanel = controls:Add("DPanel")
                searchPanel:Dock(FILL)
                searchPanel:DockPadding(12, 0, 8, 0)
                searchPanel.Paint = function(_, w, h)
                    local accent = lia.color.theme.accent
                    drawCommandPanel(0, 0, w, h, 5, Color(6, 20, 26, 225), Color(accent.r, accent.g, accent.b, 60))
                end

                local searchEntry = searchPanel:Add("DTextEntry")
                searchEntry:Dock(FILL)
                searchEntry:SetFont("LiliaFont.16")
                searchEntry:SetTextColor(Color(225, 236, 236))
                searchEntry:SetCursorColor(lia.color.theme.accent)
                searchEntry:SetPlaceholderText(L("searchCommands"))
                searchEntry:SetPaintBackground(false)
                searchEntry:SetPaintBackground(false)
                searchEntry:SetPaintBorderEnabled(false)
                local sectionLabel = listPanel:Add("DLabel")
                sectionLabel:Dock(TOP)
                sectionLabel:SetTall(34)
                sectionLabel:SetText("AVAILABLE COMMANDS")
                sectionLabel:SetFont("LiliaFont.17")
                sectionLabel:SetTextColor(lia.color.theme.text)
                sectionLabel:SetContentAlignment(4)
                local countLabel = listPanel:Add("DLabel")
                countLabel:Dock(BOTTOM)
                countLabel:SetTall(28)
                countLabel:SetFont("LiliaFont.15")
                countLabel:SetTextColor(Color(145, 169, 170))
                countLabel:SetContentAlignment(4)
                local listScroll = listPanel:Add("liaScrollPanel")
                listScroll:Dock(FILL)
                listScroll.Paint = function() end
                local listCanvas = listScroll:GetCanvas()
                if IsValid(listCanvas) then
                    listCanvas:DockPadding(0, 0, 4, 0)
                    listCanvas.Paint = function() end
                else
                    listCanvas = listScroll
                end

                local records = {}
                local selectedRecord
                local selectedCard
                local selectedFilter = "all"
                local function updateCount()
                    local visible = 0
                    for _, record in ipairs(records) do
                        if IsValid(record.card) and record.card:IsVisible() then visible = visible + 1 end
                    end

                    countLabel:SetText(string.format("%d %s", visible, visible == 1 and "command" or "commands"))
                end

                local function matchesFilter(record)
                    if selectedFilter == "general" then return not record.privileged end
                    if selectedFilter == "privileged" then return record.privileged end
                    return true
                end

                local function applyFilters()
                    local query = string.Trim(searchEntry:GetValue() or ""):lower()
                    for _, record in ipairs(records) do
                        local visible = matchesFilter(record) and (query == "" or record.searchText:find(query, 1, true) ~= nil)
                        if IsValid(record.card) then record.card:SetVisible(visible) end
                    end

                    if IsValid(listCanvas) then listCanvas:InvalidateLayout(true) end
                    updateCount()
                end

                local function formatArguments(arguments)
                    if not arguments or #arguments == 0 then return "None" end
                    local names = {}
                    for _, argument in ipairs(arguments) do
                        local name = tostring(argument.name or argument.type or "argument")
                        if argument.optional then name = name .. " (optional)" end
                        names[#names + 1] = name
                    end
                    return table.concat(names, ", ")
                end

                local function formatAliases(commandData)
                    local alias = commandData.alias
                    if not alias then return "None" end
                    if istable(alias) then return table.concat(alias, ", ") end
                    return tostring(alias)
                end

                local function rebuildDetail(record)
                    selectedRecord = record
                    detailPanel:Clear()
                    local accent, textColor = lia.color.theme.accent, lia.color.theme.text
                    local header = detailPanel:Add("DPanel")
                    header:Dock(TOP)
                    header:SetTall(140)
                    header:DockMargin(0, 0, 0, 12)
                    header.Paint = function(_, w, h)
                        drawCommandPanel(0, 0, w, h, 7, Color(5, 18, 23, 218), Color(accent.r, accent.g, accent.b, 58))
                        draw.SimpleText("/" .. record.name, "LiliaFont.26", 28, 24, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        draw.SimpleText(record.syntax ~= "" and record.syntax or "No arguments required", "LiliaFont.16", 28, 60, Color(165, 187, 188), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        local accessColor = record.privileged and accent or Color(60, 225, 160)
                        draw.SimpleText(record.access, "LiliaFont.16", 28, 102, accessColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end

                    local copyButton = createCommandButton(header, "COPY COMMAND", false, function()
                        local text = "/" .. record.name
                        if record.syntax ~= "" then text = text .. " " .. record.syntax end
                        SetClipboardText(text)
                    end)

                    copyButton:SetSize(160, 42)
                    local runButton = createCommandButton(header, "RUN COMMAND", true, function()
                        local arguments = record.data.arguments or {}
                        if #arguments > 0 then
                            local missing = {}
                            for _, argument in ipairs(arguments) do
                                missing[#missing + 1] = argument.name
                            end

                            lia.command.openArgumentPrompt(record.name, missing, {}, arguments)
                        else
                            lia.command.send(record.name)
                        end
                    end)

                    runButton:SetSize(154, 42)
                    header.PerformLayout = function(_, w)
                        runButton:SetPos(w - 170, 49)
                        copyButton:SetPos(w - 340, 49)
                    end

                    local scroll = detailPanel:Add("liaScrollPanel")
                    scroll:Dock(FILL)
                    scroll.Paint = function() end
                    local canvas = scroll:GetCanvas()
                    if IsValid(canvas) then
                        canvas:DockPadding(0, 0, 4, 0)
                        canvas.Paint = function() end
                    else
                        canvas = scroll
                    end

                    local infoSection = canvas:Add("DPanel")
                    infoSection:Dock(TOP)
                    infoSection:DockMargin(0, 0, 0, 12)
                    infoSection:DockPadding(14, 48, 14, 14)
                    infoSection.Paint = function(_, w, h)
                        drawCommandPanel(0, 0, w, h, 7, Color(5, 18, 23, 205), Color(accent.r, accent.g, accent.b, 52))
                        draw.SimpleText("COMMAND INFORMATION", "LiliaFont.17", 14, 16, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 45)
                        surface.DrawRect(14, 39, w - 28, 1)
                    end

                    addCommandInfoRow(infoSection, "Command", "/" .. record.name)
                    addCommandInfoRow(infoSection, "Syntax", record.syntax ~= "" and record.syntax or "None")
                    addCommandInfoRow(infoSection, "Access", record.access, record.privileged and accent or Color(60, 225, 160))
                    addCommandInfoRow(infoSection, "Arguments", formatArguments(record.data.arguments))
                    addCommandInfoRow(infoSection, "Aliases", formatAliases(record.data))
                    infoSection.PerformLayout = function(self) self:SetTall(48 + 46 * 5 + 14) end
                    local descriptionSection = canvas:Add("DPanel")
                    descriptionSection:Dock(TOP)
                    descriptionSection:SetTall(170)
                    descriptionSection:DockMargin(0, 0, 0, 12)
                    descriptionSection:DockPadding(14, 50, 14, 14)
                    descriptionSection.Paint = function(_, w, h)
                        drawCommandPanel(0, 0, w, h, 7, Color(5, 18, 23, 205), Color(accent.r, accent.g, accent.b, 52))
                        draw.SimpleText("DESCRIPTION", "LiliaFont.17", 14, 16, accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(accent.r, accent.g, accent.b, 45)
                        surface.DrawRect(14, 39, w - 28, 1)
                    end

                    local description = descriptionSection:Add("DLabel")
                    description:Dock(FILL)
                    description:SetWrap(true)
                    description:SetAutoStretchVertical(true)
                    description:SetFont("LiliaFont.17")
                    description:SetTextColor(Color(205, 220, 220))
                    description:SetText(record.description ~= "" and record.description or "No description available.")
                    description:SetContentAlignment(7)
                end

                local function selectRecord(record)
                    if selectedRecord == record then return end
                    if IsValid(selectedCard) then selectedCard.selected = false end
                    selectedRecord = record
                    selectedCard = record.card
                    if IsValid(selectedCard) then selectedCard.selected = true end
                    rebuildDetail(record)
                end

                for cmdName, cmdData in SortedPairs(lia.command.list) do
                    if not isnumber(cmdName) then
                        local hasAccess, privilege = lia.command.hasAccess(client, cmdName, cmdData)
                        if hasAccess then
                            local syntax = cmdData.syntax and tostring(cmdData.syntax) or ""
                            local description = cmdData.desc and tostring(cmdData.desc) or ""
                            local access = privilege and tostring(privilege) or L("globalAccess")
                            local privileged = access ~= L("globalAccess")
                            local record = {
                                name = tostring(cmdName),
                                data = cmdData,
                                syntax = syntax,
                                description = description,
                                access = access,
                                privileged = privileged
                            }

                            record.searchText = table.concat({record.name, record.syntax, record.description, record.access, formatAliases(record.data)}, " "):lower()
                            local card = listCanvas:Add("DButton")
                            card:Dock(TOP)
                            card:SetTall(82)
                            card:DockMargin(0, 0, 0, 8)
                            card:SetText("")
                            card.selected = false
                            card.Paint = function(self, w, h)
                                local cardAccent = lia.color.theme.accent
                                local active = self.selected
                                local hovered = self:IsHovered()
                                local background = active and Color(cardAccent.r, cardAccent.g, cardAccent.b, 18) or hovered and Color(255, 255, 255, 7) or Color(6, 20, 25, 205)
                                local outline = active and Color(cardAccent.r, cardAccent.g, cardAccent.b, 125) or Color(cardAccent.r, cardAccent.g, cardAccent.b, 42)
                                drawCommandPanel(0, 0, w, h, 5, background, outline)
                                if active then
                                    surface.SetDrawColor(cardAccent.r, cardAccent.g, cardAccent.b, 235)
                                    surface.DrawRect(0, 8, 3, h - 16)
                                end

                                draw.SimpleText("/" .. record.name, "LiliaFont.18", 16, 17, active and Color(245, 249, 249) or Color(220, 231, 231), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                                local subtitle = record.syntax ~= "" and record.syntax or "No arguments"
                                draw.SimpleText(subtitle, "LiliaFont.15", 16, 48, Color(145, 169, 170), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                            end

                            card.DoClick = function()
                                lia.websound.playButtonSound()
                                selectRecord(record)
                            end

                            record.card = card
                            records[#records + 1] = record
                        end
                    end
                end

                if #records == 0 then
                    countLabel:SetText("0 commands")
                    local empty = listCanvas:Add("DLabel")
                    empty:Dock(TOP)
                    empty:SetTall(80)
                    empty:SetText("No commands available.")
                    empty:SetContentAlignment(5)
                    empty:SetTextColor(Color(150, 170, 170))
                    empty:SetFont("LiliaFont.18")
                    detailPanel.Paint = function(_, w, h)
                        local accent = lia.color.theme.accent
                        drawCommandPanel(0, 0, w, h, 7, Color(5, 18, 23, 190), Color(accent.r, accent.g, accent.b, 45))
                        draw.SimpleText("No commands available.", "LiliaFont.20", w * 0.5, h * 0.5, Color(150, 170, 170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    return
                end

                searchEntry.OnChange = applyFilters
                filter.OnSelect = function(_, _, _, data)
                    selectedFilter = data or "all"
                    applyFilters()
                end

                selectRecord(records[1])
                applyFilters()
                parent.refreshCommands = function()
                    if not IsValid(parent) then return end
                    applyFilters()
                end
            end,
            onSelect = function(panel) if panel.refreshCommands then panel.refreshCommands() end end
        })
    end)
end

lia.command.findPlayer = lia.util.findPlayer
if SERVER then
    local function sanitizeFlags(flags)
        if not flags then return "" end
        local cleaned = tostring(flags):gsub("%s", "")
        local seen = {}
        local result = ""
        for i = 1, #cleaned do
            local flag = cleaned:sub(i, i)
            if not seen[flag] then
                seen[flag] = true
                result = result .. flag
            end
        end
        return result
    end

    local function mergeFlags(existing, additions)
        existing = sanitizeFlags(existing)
        additions = sanitizeFlags(additions)
        if additions == "" then return existing, "" end
        local seen = {}
        for i = 1, #existing do
            local flag = existing:sub(i, i)
            seen[flag] = true
        end

        local appended = ""
        for i = 1, #additions do
            local flag = additions:sub(i, i)
            if not seen[flag] then
                seen[flag] = true
                appended = appended .. flag
            end
        end

        if appended ~= "" then existing = existing .. appended end
        return existing, appended
    end

    local function normalizeSteamID(value)
        if not value or value == "" then return nil end
        if value:find("^%d+$") then
            local converted = util.SteamIDFrom64(value)
            if converted and converted ~= "STEAM_0:0:0" then return converted end
        end
        return value
    end

    local function findPlayerBySteamID(steamID)
        local steamID64 = util.SteamIDTo64(steamID)
        for _, ply in player.Iterator() do
            if ply:SteamID() == steamID or ply:SteamID64() == steamID64 then return ply end
        end
    end

    local function appendPermanentFlags(steamID, flagsStr)
        local normalized = normalizeSteamID(steamID)
        if not normalized then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid SteamID supplied.\n")
            return
        end

        local cleanedFlags = sanitizeFlags(flagsStr)
        if cleanedFlags == "" then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "No flags provided.\n")
            return
        end

        local target = findPlayerBySteamID(normalized)
        if target then
            local merged, appended = mergeFlags(target:getLiliaData("permanentflags", ""), cleanedFlags)
            if appended == "" then
                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "No new flags to add for " .. normalized .. ".\n")
                return
            end

            target:setLiliaData("permanentflags", merged)
            local char = target:getChar()
            if char then char:giveFlags(appended) end
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added flags '" .. appended .. "' to " .. normalized .. ".\n")
            return
        end

        lia.db.selectOne({"data"}, "players", "steamID = " .. lia.db.convertDataType(normalized)):next(function(row)
            local data = {}
            if row and row.data then
                if isstring(row.data) then
                    data = util.JSONToTable(row.data) or {}
                elseif istable(row.data) then
                    data = row.data
                end
            end

            if not istable(data) then data = {} end
            local existingFlags = data.permanentflags or ""
            local merged, appended = mergeFlags(existingFlags, cleanedFlags)
            if appended == "" then
                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "No new flags to add for " .. normalized .. ". Existing flags: '" .. existingFlags .. "', Attempted to add: '" .. cleanedFlags .. "'\n")
                return
            end

            data.permanentflags = merged
            if row then
                lia.db.updateTable({
                    data = util.TableToJSON(data)
                }, nil, "players", "steamID = " .. lia.db.convertDataType(normalized)):next(function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added flags '" .. appended .. "' to " .. normalized .. ". New flags: '" .. merged .. "'\n") end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error updating flags for " .. normalized .. ": " .. tostring(err) .. "\n") end)
            else
                lia.db.insertTable({
                    steamID = normalized,
                    data = util.TableToJSON(data)
                }, nil, "players"):next(function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Created player entry and added flags '" .. appended .. "' to " .. normalized .. ". New flags: '" .. merged .. "'\n") end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error creating player entry for " .. normalized .. ": " .. tostring(err) .. "\n") end)
            end
        end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database error while checking player " .. normalized .. ": " .. tostring(err) .. "\n") end)
    end

    concommand.Add("lia_givepermaflags", function(client, _, args)
        lia.debug("[Permissions]", "Permission Check for concommand lia_givepermaflags", "isValidPlayer=", tostring(IsValid(client)), "isSuperAdmin=", tostring(IsValid(client) and client:IsSuperAdmin() or true), "finalResult=", tostring(not IsValid(client) or client:IsSuperAdmin()))
        if IsValid(client) and not client:IsSuperAdmin() then return end
        appendPermanentFlags(args[1], args[2])
    end)

    concommand.Add("kickbots", function(client)
        lia.debug("[Permissions]", "Permission Check for concommand kickbots", "isValidPlayer=", tostring(IsValid(client)), "isSuperAdmin=", tostring(IsValid(client) and client:IsSuperAdmin() or true), "finalResult=", tostring(not IsValid(client) or client:IsSuperAdmin()))
        if IsValid(client) and not client:IsSuperAdmin() then
            client:notifyErrorLocalized("staffPermissionDenied")
            return
        end

        if timer.Exists("Bots_Add_Timer") then timer.Remove("Bots_Add_Timer") end
        local kickedCount = 0
        for _, bot in player.Iterator() do
            if bot:IsBot() then
                bot:Kick(L("allBotsKicked"))
                kickedCount = kickedCount + 1
            end
        end

        if IsValid(client) then
            if kickedCount == 0 then
                client:notifyErrorLocalized("noBotsToKick")
            else
                client:notifyInfoLocalized("botsKickedAll", kickedCount)
            end
        else
            local message = kickedCount == 0 and L("noBotsToKick") or L("botsKickedAll", kickedCount)
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), message .. "\n")
        end
    end)

    concommand.Add("lia_check_updates", function(client)
        lia.debug("[Permissions]", "Permission Check for concommand lia_check_updates", "isValidPlayer=", tostring(IsValid(client)), "isSuperAdmin=", tostring(IsValid(client) and client:IsSuperAdmin() or true), "finalResult=", tostring(not IsValid(client) or client:IsSuperAdmin()))
        if IsValid(client) and not client:IsSuperAdmin() then
            client:notifyErrorLocalized("staffPermissionDenied")
            return
        end

        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("checkingForUpdates") .. "\n")
        lia.loader.checkForUpdates()
    end)

    local function handleSetUserGroup(ply, _, args)
        local steamID = string.Trim(args[1] or "")
        local usergroup = string.Trim(args[2] or "")
        local canUse = not IsValid(ply)
        lia.debug("[Permissions]", "Permission Check for function handleSetUserGroup", "isValidPlayer=", tostring(IsValid(ply)), "finalResult=", tostring(canUse))
        if not canUse then
            ply:notifyErrorLocalized("noPerm")
            return
        end

        if steamID == "" or not string.match(steamID, "^STEAM_%d+:%d+:%d+$") then
            if IsValid(ply) then
                ply:notifyErrorLocalized("invalidPlayer", steamID)
            else
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("invalidPlayer", steamID) .. "\n")
            end
            return
        end

        if usergroup == "" or not lia.admin.groups[usergroup] then
            if IsValid(ply) then
                ply:notifyErrorLocalized("invalidUsergroup", usergroup)
            else
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("invalidUsergroup", usergroup) .. "\n")
            end
            return
        end

        local target = lia.util.getBySteamID(steamID)
        lia.db.selectOne({"steamName", "userGroup"}, "players", "steamID = " .. lia.db.convertDataType(steamID)):next(function(data)
            if not data then
                if IsValid(ply) then
                    ply:notifyErrorLocalized("plyNoExist")
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("invalidPlayer", steamID) .. "\n")
                end
                return
            end

            lia.db.updateTable({
                userGroup = usergroup
            }, nil, "players", "steamID = " .. lia.db.convertDataType(steamID)):next(function()
                lia.admin.setSteamIDUsergroup(steamID, usergroup, IsValid(ply) and ply:Name() or "Console")
                if IsValid(target) and isfunction(target.getName) then target:notifyInfoLocalized("userGroupSet", usergroup) end
                if IsValid(ply) then
                    local targetName = isfunction(target and target.getName) and target:getName() or data.steamName or steamID
                    ply:notifyInfoLocalized("userGroupSetBy", targetName, usergroup)
                end

                lia.log.add(IsValid(ply) and ply or nil, "usergroup", IsValid(target) and target or steamID, usergroup)
                local playerName = isfunction(target and target.getName) and target:getName() or data.steamName or steamID
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set " .. playerName .. " (" .. steamID .. ") to usergroup: " .. usergroup .. "\n")
            end)
        end)
    end

    concommand.Add("plysetgroup", handleSetUserGroup)
    concommand.Add("plysetusergroup", handleSetUserGroup)
    concommand.Add("stopsoundall", function(client)
        local permission = client:hasPrivilege("stopSoundForEveryone")
        lia.debug("[Permissions]", "Permission Check for concommand stopsoundall", "hasPrivilege(stopSoundForEveryone)=", tostring(permission), "finalResult=", tostring(permission))
        if permission then
            for _, v in player.Iterator() do
                v:ConCommand("stopsound")
            end
        else
            client:notifyErrorLocalized("noPerm")
        end
    end)

    concommand.Add("bots", function()
        if LocalPlayer():IsSuperAdmin() then return end
        timer.Create("Bots_Add_Timer", 2, 0, function()
            if player.GetCount() < game.MaxPlayers() then
                game.ConsoleCommand("bot\n")
            else
                timer.Remove("Bots_Add_Timer")
            end
        end)
    end)

    concommand.Add("lia_wipedb", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.db.wipeTables(function()
            lia.information(L("dbWiped"))
            lia.db.loadTables()
            hook.Add("PostLoadData", "lia_wipedb_changemap", function()
                hook.Remove("PostLoadData", "lia_wipedb_changemap")
                timer.Simple(2.5, function()
                    lia.information("Database wipe complete. Changing map...")
                    RunConsoleCommand("changelevel", game.GetMap())
                end)
            end)
        end)
    end)

    concommand.Add("lia_wipecharacters", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.db.wipeCharacters()
        lia.information(L("charsWiped"))
    end)

    concommand.Add("lia_wipelogs", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.db.wipeLogs()
        lia.information(L("logsWiped"))
    end)

    concommand.Add("lia_wipebans", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.db.wipeBans()
        lia.information(L("bansWiped"))
    end)

    concommand.Add("lia_wipepersistence", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.data.deleteAll()
        lia.information(L("persistenceWiped"))
    end)

    concommand.Add("lia_wipeconfig", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.config.reset()
        lia.information(L("configWiped"))
    end)

    concommand.Add("lia_randomconfig", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        local randomValues = {
            Boolean = function() return math.random(0, 1) == 1 end,
            Number = function(cfg) return math.Round(math.Rand(cfg.data.min or 0, cfg.data.max or 100), 2) end,
            Int = function(cfg) return math.random(cfg.data.min or 0, cfg.data.max or 100) end,
            Float = function(cfg) return math.Round(math.Rand(cfg.data.min or 0, cfg.data.max or 100), cfg.data.decimals or 2) end,
            Color = function() return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255) end,
            Generic = function() return "random_" .. tostring(math.random(1000, 9999)) end,
            Table = function(cfg)
                local opts = lia.config.getOptions and lia.config.getOptions(cfg.key)
                if opts and next(opts) then
                    local keys = {}
                    for k in pairs(opts) do
                        keys[#keys + 1] = k
                    end

                    local pick = opts[keys[math.random(#keys)]]
                    return pick and pick.value or nil
                end
            end,
        }

        local byType = {}
        for key, cfg in pairs(lia.config.stored) do
            local t = (cfg.data and cfg.data.type) or cfg.type or "Generic"
            if not byType[t] then
                byType[t] = {
                    key = key,
                    cfg = cfg
                }
            end
        end

        local results = {}
        for typeName, info in SortedPairs(byType) do
            local gen = randomValues[typeName]
            if not gen then continue end
            info.cfg.key = info.key
            local newVal = gen(info.cfg)
            if newVal == nil then
                results[#results + 1] = string.format("  [%s] %s -> skipped (no options)", typeName, info.key)
                continue
            end

            lia.config.set(info.key, newVal)
            results[#results + 1] = string.format("  [%s] %s = %s", typeName, info.key, tostring(newVal))
        end

        lia.debug("[lia_randomconfig] Set one random config per type:")
        for _, line in ipairs(results) do
            lia.debug(line)
        end
    end)

    concommand.Add("list_entities", function(client)
        local entityCount = {}
        local totalEntities = 0
        if not IsValid(client) then
            lia.information(L("entitiesOnServer") .. ":")
            for _, entity in ents.Iterator() do
                local class = entity:GetClass()
                entityCount[class] = (entityCount[class] or 0) + 1
                totalEntities = totalEntities + 1
            end

            for class, count in SortedPairs(entityCount) do
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), class .. ": " .. count .. "\n")
            end

            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("totalEntities", totalEntities) .. "\n")
        else
            client:notifyErrorLocalized("commandConsoleOnly")
        end
    end)

    concommand.Add("lia_database_list", function(ply)
        if IsValid(ply) then return end
        lia.db.getCharacterTable(function(columns)
            if #columns == 0 then
                lia.error(L("dbColumnsNone"))
            else
                lia.information(L("dbColumnsList", #columns))
                for _, column in ipairs(columns) do
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), column .. "\n")
                end
            end
        end)
    end)

    concommand.Add("lia_fix_characters", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.db.fixCharacters()
        lia.information(L("charsFixed"))
    end)

    concommand.Add("lia_redownload_assets", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.loader.downloadAssets()
        lia.information(L("assetsRedownloaded"))
    end)

    concommand.Add("print_vector", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] " .. L("errorPrefix") .. L("commandCanOnlyBeUsedByPlayers") .. "\n")
            return
        end

        local pos = client:GetPos()
        local vec = Vector(pos.x, pos.y, pos.z)
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("vector") .. ": " .. tostring(vec) .. "\n")
    end)

    concommand.Add("print_angle", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] " .. L("errorPrefix") .. L("commandCanOnlyBeUsedByPlayers") .. "\n")
            return
        end

        local ang = client:GetAngles()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Angle: " .. tostring(ang) .. "\n")
    end)

    concommand.Add("lia_snapshot", function(client, _, args)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("snapshotTableUsage") .. "\n")
            return
        end

        local tableName = args[1]
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("creatingSnapshot", tableName) .. "\n")
        lia.db.createSnapshot(tableName):next(function(snapshot)
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("snapshotCreated") .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("snapshotRecords", snapshot.records) .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("snapshotPath", snapshot.path) .. "\n")
        end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("snapshotFailed", tostring(err)) .. "\n") end)
    end)

    concommand.Add("lia_snapshot_load", function(client, _, args)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("snapshotUsage") .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("availableSnapshots") .. "\n")
            local files = file.Find("lilia/snapshots/*", "DATA")
            if #files == 0 then
                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), L("noSnapshotsFound") .. "\n")
            else
                for _, fileName in ipairs(files) do
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  - " .. fileName .. "\n")
                end
            end
            return
        end

        local fileName = args[1]
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("loadingSnapshot", fileName) .. "\n")
        lia.db.loadSnapshot(fileName):next(function(result)
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("snapshotLoaded") .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("snapshotTable", result.table) .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("snapshotRecords", result.records) .. "\n")
        end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("snapshotLoadFailed", tostring(err)) .. "\n") end)
    end)

    concommand.Add("lia_wipetable", function(client, _, args)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("wipeTableUsage") .. "\n")
            return
        end

        local tableName = args[1]
        local fullTableName = "lia_" .. tableName
        MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), L("creatingBackupBeforeWipe", tableName) .. "\n")
        lia.db.createSnapshot(tableName):next(function(snapshot)
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("backupCreated", snapshot.file) .. "\n")
            MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), L("wipingTable", fullTableName) .. "\n")
            lia.db.query("DELETE FROM " .. fullTableName, function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), L("tableWiped", fullTableName) .. "\n") end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("tableWipeFailed", tostring(err)) .. "\n") end)
        end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), L("backupFailedAbortingWipe", tostring(err)) .. "\n") end)
    end)
end

lia.command.add("playtime", {
    adminOnly = false,
    desc = "@playtimeDesc",
    onRun = function(client)
        local secs = client:getPlayTime()
        if not secs then
            client:notifyErrorLocalized("playtimeError")
            return
        end

        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:notifyInfoLocalized("playtimeYour", h, m, s)
    end
})

lia.command.add("charid", {
    adminOnly = false,
    desc = "@charidDesc",
    onRun = function(client)
        local char = client:getChar()
        if not char then
            client:notifyErrorLocalized("noCharacterSelected")
            return
        end

        local charID = char:getID()
        client:notifyInfoLocalized("charidYour", charID)
    end
})

lia.command.add("returntodeathpos", {
    adminOnly = true,
    desc = "@returnToDeathPosDesc",
    onRun = function(client)
        if IsValid(client) and client:Alive() then
            local character = client:getChar()
            local oldPos = character and character:getData("deathPos")
            if oldPos then
                client:SetPos(oldPos)
                character:setData("deathPos", nil)
            else
                client:notifyErrorLocalized("noDeathPosition")
            end
        else
            client:notifyWarningLocalized("waitRespawn")
        end
    end
})

lia.command.add("roll", {
    adminOnly = false,
    desc = "@rollDesc",
    onRun = function(client)
        local rollValue = math.random(0, 100)
        lia.chat.send(client, "roll", rollValue)
    end
})

lia.command.add("forcefallover", {
    adminOnly = true,
    desc = "@forceFalloverDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "time",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local time = tonumber(arguments[2])
        if not time or time < 1 then
            time = 5
        else
            time = math.Clamp(time, 1, 60)
        end

        target.FallOverCooldown = true
        target:setRagdolled(true, time)
    end
})

lia.command.add("forcegetup", {
    adminOnly = true,
    desc = "@forceGetUpDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        if not IsValid(target:GetRagdollEntity()) then return end
        local entity = target:GetRagdollEntity()
        if IsValid(entity) and entity.liaGrace and entity.liaGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and not entity.liaWakingUp then
            entity.liaWakingUp = true
            target:setAction("gettingUp", 5, function()
                if IsValid(entity) then
                    hook.Run("OnCharGetup", target, entity)
                    SafeRemoveEntity(entity)
                end
            end)
        end
    end
})

lia.command.add("chardesc", {
    adminOnly = false,
    desc = "@changeCharDesc",
    arguments = {
        {
            name = "desc",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local desc = table.concat(arguments, " ")
        if not desc:find("%S") then return client:requestString("@chgName", "@chgNameDesc", function(text) lia.command.run(client, "chardesc", {text}) end, client:getChar() and client:getChar():getDesc() or "") end
        local trimmedDesc = string.Trim(desc)
        local descWithoutSpaces = string.gsub(trimmedDesc, "%s", "")
        local minLength = lia.config.get("MinDescLen", 16)
        if #descWithoutSpaces < minLength then
            client:notifyErrorLocalized("descMinLen", minLength)
            return
        end

        local character = client:getChar()
        if character then character:setDesc(desc) end
        return "@descChanged"
    end
})

lia.command.add("chargetup", {
    adminOnly = false,
    desc = "@forceSelfGetUpDesc",
    onRun = function(client)
        if not IsValid(client:GetRagdollEntity()) then return end
        local entity = client:GetRagdollEntity()
        if IsValid(entity) and entity.liaGrace and entity.liaGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and not entity.liaWakingUp then
            entity.liaWakingUp = true
            client:setAction("gettingUp", 5, function()
                if IsValid(entity) then
                    hook.Run("OnCharGetup", client, entity)
                    SafeRemoveEntity(entity)
                end
            end)
        end
    end,
    alias = {"getup"}
})

lia.command.add("fallover", {
    adminOnly = false,
    desc = "@fallOverDesc",
    arguments = {
        {
            name = "time",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        if client.FallOverCooldown then
            client:notifyWarningLocalized("cmdCooldown")
            return
        elseif client:IsFrozen() then
            client:notifyWarningLocalized("cmdFrozen")
            return
        elseif not client:Alive() then
            client:notifyErrorLocalized("cmdDead")
            return
        elseif IsValid(client:GetVehicle()) then
            client:notifyWarningLocalized("cmdVehicle")
            return
        elseif client:GetMoveType() == MOVETYPE_NOCLIP then
            client:notifyWarningLocalized("cmdNoclip")
            return
        elseif IsValid(client:GetRagdollEntity()) then
            return
        end

        local time = math.Clamp(tonumber(arguments[1]) or 5, 1, 60)
        client.FallOverCooldown = true
        client:setRagdolled(true, time)
        timer.Simple(time, function() if IsValid(client) then client.FallOverCooldown = false end end)
    end
})