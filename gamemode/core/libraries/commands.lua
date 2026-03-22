--[[
    Folder: Libraries
    File: command.md
]]
--[[
    Commands

    Comprehensive command registration, parsing, and execution system for the Lilia framework.
]]
--[[
    Overview:
        The commands library provides comprehensive functionality for managing and executing commands in the Lilia framework. It handles command registration, argument parsing, access control, privilege management, and command execution across both server and client sides. The library supports complex argument types including players, booleans, strings, and tables, with automatic syntax generation and validation. It integrates with the administrator system for privilege-based access control and provides user interface elements for command discovery and argument prompting. The library ensures secure command execution with proper permission checks and logging capabilities.
]]
lia.command = lia.command or {}
lia.command.list = lia.command.list or {}
--[[
    Purpose:
        Generate a human-readable syntax string from a list of argument definitions.

    When Called:
        During command registration to populate data.syntax for menus and help text.

    Parameters:
        args (table)
            Array of argument tables {name=, type=, optional=}.

    Returns:
        string
            Concatenated syntax tokens describing the command arguments.

    Realm:
        Shared

    Example Usage:
        ```lua
        local syntax = lia.command.buildSyntaxFromArguments({
            {name = "target", type = "player"},
            {name = "amount", type = "number", optional = true}
        })
        -- "[player target] [string amount optional]"
        ```
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

        local name = arg.name or typ
        local optional = arg.optional and " optional" or ""
        tokens[#tokens + 1] = string.format("[%s %s%s]", typ, name, optional)
    end
    return table.concat(tokens, " ")
end

--[[
    Purpose:
        Register a command and normalize its metadata, syntax, privileges, aliases, and callbacks.

    When Called:
        During schema or module initialization to expose new chat/console commands.

    Parameters:
        command (string)
            Unique command key.
        data (table)
            Command definition (arguments, desc, privilege, superAdminOnly, adminOnly, alias, onRun, onCheckAccess, etc.).
    Realm:
        Shared

    Example Usage:
        ```lua
        lia.command.add("bring", {
            desc = "Bring a player to you.",
            adminOnly = true,
            arguments = {
                {name = "target", type = "player"}
            },
            onRun = function(client, args)
                local target = lia.command.findPlayer(args[1])
                if IsValid(target) then target:SetPos(client:GetPos() + client:GetForward() * 50) end
            end
        })
        ```
]]
function lia.command.add(command, data)
    data.arguments = data.arguments or {}
    data.syntax = lia.command.buildSyntaxFromArguments(data.arguments)
    data.syntax = L(data.syntax or "")
    data.desc = data.desc or ""
    data.privilege = data.privilege or nil
    local superAdminOnly = data.superAdminOnly
    local adminOnly = data.adminOnly
    if not data.onRun then
        lia.error(string.format("Command '%s' does not have a callback, not adding!", command))
        return
    end

    if superAdminOnly or adminOnly then
        local privilegeName = data.privilege and L(data.privilege) or string.format("Access to %s", command)
        local privilegeID = data.privilege or string.lower("command_" .. command)
        lia.admin.registerPrivilege({
            Name = privilegeName,
            ID = privilegeID,
            MinAccess = superAdminOnly and "superadmin" or "admin",
            Category = "staffPermissions"
        })
    end

    for _, arg in ipairs(data.arguments) do
        if arg.type == "boolean" then
            arg.type = "bool"
        elseif arg.type ~= "player" and arg.type ~= "table" and arg.type ~= "bool" then
            arg.type = "string"
        end

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
                        Name = data.privilege and L(data.privilege) or string.format("Access to %s", v),
                        ID = aliasPrivilegeID,
                        MinAccess = superAdminOnly and "superadmin" or "admin",
                        Category = "commands"
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
                    Name = data.privilege and L(data.privilege) or string.format("Access to %s", alias),
                    ID = aliasPrivilegeID,
                    MinAccess = superAdminOnly and "superadmin" or "admin",
                    Category = "commands"
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
        Determine whether a client may run a command based on privileges, hooks, faction/class access, and custom checks.

    When Called:
        Before executing a command or showing it in help menus.

    Parameters:
        client (Player)
            Player requesting access.
        command (string)
            Command name to check.
        data (table|nil)
            Command definition; looked up from lia.command.list when nil.

    Returns:
        boolean, string
            allowed result and privilege name for UI/feedback.

    Realm:
        Shared

    Example Usage:
        ```lua
        local canUse, priv = lia.command.hasAccess(ply, "bring")
        if not canUse then ply:notifyErrorLocalized("noPerm") end
        ```
]]
function lia.command.hasAccess(client, command, data)
    if not data then data = lia.command.list[command] end
    if not data then return false, "unknown" end
    local privilegeID = data.privilege or string.lower("command_" .. command)
    local superAdminOnly = data.superAdminOnly
    local adminOnly = data.adminOnly
    local accessLevels = superAdminOnly and "superadmin" or adminOnly and "admin" or "user"
    local privilegeName = data.privilege and L(data.privilege) or accessLevels == "user" and "Global" or string.format("Access to %s", command)
    if data.onCheckAccess then
        local accessResult, customPrivilegeName = data.onCheckAccess(client, command, data)
        if accessResult ~= nil then return accessResult, customPrivilegeName or privilegeName end
    end

    local hasAccess = true
    if accessLevels ~= "user" then
        if not isstring(privilegeID) then
            lia.error("' has invalid privilege ID type: ")
            return false, privilegeName
        end

        hasAccess = client:hasPrivilege(privilegeID)
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
    return hasAccess, privilegeName
end

--[[
    Purpose:
        Split a raw command string into arguments while preserving quoted segments.

    When Called:
        When parsing chat-entered commands before validation or prompting.

    Parameters:
        text (string)
            Raw command text excluding the leading slash.

    Returns:
        table
            Array of parsed arguments.

    Realm:
        Shared

    Example Usage:
        ```lua
        local args = lia.command.extractArgs("'John Doe' 250")
        -- {"John Doe", "250"}
        ```
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
        Execute a registered command for a given client with arguments and emit post-run hooks.

    When Called:
        After parsing chat input or console invocation server-side.

    Parameters:
        client (Player|nil)
            Player that issued the command (nil when run from server console).
        command (string)
            Command key to execute.
        arguments (table|nil)
            Parsed command arguments.
    Realm:
        Server

    Example Usage:
        ```lua
        lia.command.run(ply, "bring", {targetSteamID})
        ```
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
        Parse chat text into a command invocation, prompt for missing args, and dispatch authorized commands.

    When Called:
        On the server when a player sends chat starting with '/' or when manually dispatching a command.

    Parameters:
        client (Player)
            Player whose chat is being parsed.
        text (string)
            Full chat text.
        realCommand (string|nil)
            Command key when bypassing parsing (used by net/message dispatch).
        arguments (table|nil)
            Pre-parsed arguments; when nil they are derived from text.

    Returns:
        boolean
            true if the text was handled as a command.

    Realm:
        Server

    Example Usage:
        ```lua
        hook.Add("PlayerSay", "liaChatCommands", function(ply, text)
            if lia.command.parse(ply, text) then return "" end
        end)
        ```
    ]]
    function lia.command.parse(client, text, realCommand, arguments)
        if realCommand or utf8.sub(text, 1, 1) == "/" then
            local match = realCommand or text:lower():match("/([_%w]+)")
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
                    if IsValid(client) then client:notifyError("No Access") end
                    return true
                end

                if not arguments then arguments = lia.command.extractArgs(text:sub(#match + 3)) end
                local fields = command.arguments or {}
                if IsValid(client) and client:IsPlayer() and #fields > 0 then
                    local tokens = combineBracketArgs(arguments)
                    local missing = {}
                    local prefix = {}
                    local firstMissingIndex
                    for i, field in ipairs(fields) do
                        local arg = tokens[i]
                        local isMissing = not arg or isPlaceholder(arg)
                        if isMissing then
                            if not firstMissingIndex then firstMissingIndex = i end
                            if (not field.optional) or (i >= firstMissingIndex) then missing[#missing + 1] = field.name end
                        else
                            prefix[#prefix + 1] = arg
                        end
                    end

                    if #missing > 0 then
                        net.Start("liaCmdArgPrompt")
                        net.WriteString(match)
                        net.WriteTable(missing)
                        net.WriteTable(prefix)
                        net.Send(client)
                        return true
                    end
                end

                lia.command.run(client, match, arguments)
                if not realCommand then lia.log.add(client, "command", text) end
            else
                if IsValid(client) then
                    client:notifyError("Sorry, that command does not exist.")
                else
                    lia.information("Sorry, that command does not exist.")
                end
            end
            return true
        end
        return false
    end
else
    --[[
    Purpose:
        Display a clientside UI prompt for missing command arguments and send the completed command back through chat.

    When Called:
        After the server requests argument completion via the liaCmdArgPrompt net message.

    Parameters:
        cmdKey (string)
            Command key being completed.
        missing (table)
            Names of missing arguments.
        prefix (table|nil)
            Prefilled argument values.
    Realm:
        Client

    Example Usage:
        ```lua
        lia.command.openArgumentPrompt("pm", {"target", "message"}, {"steamid"})
        ```
    ]]
    function lia.command.openArgumentPrompt(cmdKey, missing, prefix)
        local command = lia.command.list[cmdKey]
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
                    ctrl:SetValue("Select Player")
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
                    ctrl:SetValue("Select " .. L(name))
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
        submit:SetTxt("Submit")
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
        cancel:SetTxt("Cancel")
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
        Send a command invocation to the server via net as a clientside helper.

    When Called:
        From UI elements or client logic instead of issuing chat/console commands directly.

    Parameters:
        command (string)
            Command key to invoke.
        ... (vararg)
            Arguments to pass to the command.
    Realm:
        Client

    Example Usage:
        ```lua
        lia.command.send("respawn", LocalPlayer():SteamID())
        ```
]]
    function lia.command.send(command, ...)
        net.Start("liaCommandData")
        net.WriteString(command)
        net.WriteTable({...})
        net.SendToServer()
    end
end

hook.Add("CreateInformationButtons", "liaInformationCommandsUnified", function(pages)
    local client = LocalPlayer()
    table.insert(pages, {
        name = "commands",
        drawFunc = function(parent)
            parent:Clear()
            local sheet = vgui.Create("liaSheet", parent)
            sheet:Dock(FILL)
            sheet:SetPlaceholderText("Search Commands")
            local useList = false
            if useList then
                local data = {}
                for cmdName, cmdData in SortedPairs(lia.command.list) do
                    if not isnumber(cmdName) then
                        local hasAccess = lia.command.hasAccess(client, cmdName, cmdData)
                        if hasAccess then
                            local text = "/" .. cmdName
                            if cmdData.syntax and cmdData.syntax ~= "" then text = text .. " " .. L(cmdData.syntax) end
                            local desc = cmdData.desc ~= "" and L(cmdData.desc) or ""
                            local priv = cmdData.privilege and L(cmdData.privilege) or ""
                            data[#data + 1] = {text, desc, priv}
                        end
                    end
                end

                sheet:AddListViewRow({
                    columns = {"Command", "Description", "Privilege"},
                    data = data,
                    height = 300
                })
            else
                for cmdName, cmdData in SortedPairs(lia.command.list) do
                    if not isnumber(cmdName) then
                        local hasAccess, privilege = lia.command.hasAccess(client, cmdName, cmdData)
                        if hasAccess then
                            local text = "/" .. cmdName
                            if cmdData.syntax and cmdData.syntax ~= "" then text = text .. " " .. L(cmdData.syntax) end
                            local desc = cmdData.desc ~= "" and L(cmdData.desc) or ""
                            local right = privilege and privilege ~= "Global" and privilege or ""
                            local row = sheet:AddTextRow({
                                title = text,
                                desc = desc,
                                right = right
                            })

                            row.filterText = (cmdName .. " " .. L(cmdData.syntax or "") .. " " .. desc .. " " .. right):lower()
                        end
                    end
                end
            end

            sheet:Refresh()
            parent.refreshSheet = function() if IsValid(sheet) then sheet:Refresh() end end
        end,
        onSelect = function(pnl) if pnl.refreshSheet then pnl.refreshSheet() end end
    })
end)

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
        if IsValid(client) and not client:IsSuperAdmin() then return end
        appendPermanentFlags(args[1], args[2])
    end)

    concommand.Add("kickbots", function()
        if timer.Exists("Bots_Add_Timer") then timer.Remove("Bots_Add_Timer") end
        for _, bot in player.Iterator() do
            if bot:IsBot() then lia.admin.execCommand("kick", bot, nil, "All bots kicked") end
        end
    end)

    concommand.Add("lia_check_updates", function(client)
        if IsValid(client) and not client:IsSuperAdmin() then
            client:notifyError("You do not have permission to use this command.")
            return
        end

        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Checking for updates...\n")
        lia.loader.checkForUpdates()
    end)

    local function handleSetUserGroup(ply, _, args)
        local steamID = string.Trim(args[1] or "")
        local usergroup = string.Trim(args[2] or "")
        local canUse = not IsValid(ply) or not game.IsDedicated() or ply:hasPrivilege("setUserGroup")
        if not canUse then
            ply:notifyError("You are not allowed to do this.")
            return
        end

        if steamID == "" or not string.match(steamID, "^STEAM_%d+:%d+:%d+$") then
            if IsValid(ply) then
                ply:notifyError(string.format("Invalid player: %s", steamID))
            else
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Invalid player: %s", steamID) .. "\n")
            end
            return
        end

        if usergroup == "" or not lia.admin.groups[usergroup] then
            if IsValid(ply) then
                ply:notifyError(string.format("Invalid usergroup: %s", usergroup))
            else
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Invalid usergroup: %s", usergroup) .. "\n")
            end
            return
        end

        local target = lia.util.getBySteamID(steamID)
        lia.db.selectOne({"steamName", "userGroup"}, "players", "steamID = " .. lia.db.convertDataType(steamID)):next(function(data)
            if not data then
                if IsValid(ply) then
                    ply:notifyError("Player does not exist.")
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Invalid player: %s", steamID) .. "\n")
                end
                return
            end

            lia.db.updateTable({
                userGroup = usergroup
            }, nil, "players", "steamID = " .. lia.db.convertDataType(steamID)):next(function()
                lia.admin.setSteamIDUsergroup(steamID, usergroup, IsValid(ply) and ply:Name() or "Console")
                if IsValid(target) and isfunction(target.getName) then target:notifyInfo(string.format("Usergroup set to %s.", usergroup)) end
                if IsValid(ply) then
                    local targetName = isfunction(target and target.getName) and target:getName() or data.steamName or steamID
                    ply:notifyInfo(string.format("%s's usergroup has been set to %s by an admin.", targetName, usergroup))
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
        if client:hasPrivilege("stopSoundForEveryone") then
            for _, v in player.Iterator() do
                v:ConCommand("stopsound")
            end
        else
            client:notifyError("You are not allowed to do this.")
        end
    end)

    concommand.Add("bots", function()
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
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.db.wipeTables(function()
            lia.information("Database Wiped")
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

    concommand.Add("lia_resetconfig", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.config.load(true)
        lia.information("Config Reloaded")
    end)

    concommand.Add("lia_wipecharacters", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.db.wipeCharacters()
        lia.information("All characters have been wiped!")
    end)

    concommand.Add("lia_wipelogs", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.db.wipeLogs()
        lia.information("All logs have been wiped!")
    end)

    concommand.Add("lia_wipebans", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.db.wipeBans()
        lia.information("All bans have been wiped!")
    end)

    concommand.Add("lia_wipepersistence", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.data.deleteAll()
        lia.information("All persistence data has been wiped!")
    end)

    concommand.Add("lia_wipeconfig", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.config.reset()
        lia.information("All configuration has been wiped!")
    end)

    concommand.Add("list_entities", function(client)
        local entityCount = {}
        local totalEntities = 0
        if not IsValid(client) then
            lia.information("Entities on the server:")
            for _, entity in ents.Iterator() do
                local class = entity:GetClass()
                entityCount[class] = (entityCount[class] or 0) + 1
                totalEntities = totalEntities + 1
            end

            for class, count in SortedPairs(entityCount) do
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), class .. ": " .. count .. "\n")
            end

            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Total entities on the server: %s", totalEntities) .. "\n")
        else
            client:notifyError("This command can only be run from the server console.")
        end
    end)

    concommand.Add("lia_database_list", function(ply)
        if IsValid(ply) then return end
        lia.db.getCharacterTable(function(columns)
            if #columns == 0 then
                lia.error("No columns found in lia_characters.")
            else
                lia.information(string.format("Columns in lia_characters: %s", #columns))
                for _, column in ipairs(columns) do
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), column .. "\n")
                end
            end
        end)
    end)

    concommand.Add("lia_fix_characters", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.db.fixCharacters()
        lia.information("Characters Fixed")
    end)

    concommand.Add("lia_redownload_assets", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.loader.downloadAssets()
        lia.information("Assets Redownloaded")
    end)

    concommand.Add("test_existing_notifications", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.notices.notify(nil, "Test Notification", "default" or "default")
        lia.notices.notify(nil, "Test Notification Info", "info")
        lia.notices.notify(nil, "Test Notification Warning", "warning")
        lia.notices.notify(nil, "Test Notification Error", "error")
        lia.notices.notify(nil, "Test Notification Success", "success")
    end)

    concommand.Add("print_vector", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] Error PrefixThis command can only be used by players.\n")
            return
        end

        local pos = client:GetPos()
        local vec = Vector(pos.x, pos.y, pos.z)
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Vector: " .. tostring(vec) .. "\n")
    end)

    concommand.Add("print_angle", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] Error PrefixThis command can only be used by players.\n")
            return
        end

        local ang = client:GetAngles()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Angle: " .. tostring(ang) .. "\n")
    end)

    concommand.Add("workshop_force_redownload", function()
        table.Empty(queue)
        buildQueue(true)
        start()
    end)

    concommand.Add("lia_snapshot", function(_, _, args)
        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_snapshot <table_name>\n")
            return
        end

        local tableName = args[1]
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Creating snapshot for table: %s", tableName) .. "\n")
        lia.db.createSnapshot(tableName):next(function(snapshot)
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Snapshot created successfully!\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Records: %s", snapshot.records) .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Path: %s", snapshot.path) .. "\n")
        end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Snapshot failed: %s", tostring(err)) .. "\n") end)
    end)

    concommand.Add("lia_snapshot_load", function(_, _, args)
        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_snapshot_load <filename>\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Available snapshots:\n")
            local files = file.Find("lilia/snapshots/*", "DATA")
            if #files == 0 then
                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "No snapshots found\n")
            else
                for _, fileName in ipairs(files) do
                    MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "  - " .. fileName .. "\n")
                end
            end
            return
        end

        local fileName = args[1]
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Loading snapshot: %s", fileName) .. "\n")
        lia.db.loadSnapshot(fileName):next(function(result)
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Snapshot loaded successfully!\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Table: %s", result.table) .. "\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Records: %s", result.records) .. "\n")
        end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Snapshot load failed: %s", tostring(err)) .. "\n") end)
    end)

    concommand.Add("lia_wipetable", function(_, _, args)
        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_wipetable <table_name>\n")
            return
        end

        local tableName = args[1]
        local fullTableName = "lia_" .. tableName
        MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), string.format("Creating backup before wiping table: %s", tableName) .. "\n")
        lia.db.createSnapshot(tableName):next(function(snapshot)
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), string.format("Backup created: %s", snapshot.file) .. "\n")
            MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), string.format("Wiping table: %s", fullTableName) .. "\n")
            lia.db.query("DELETE FROM " .. fullTableName, function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), string.format("Table %s has been wiped successfully!", fullTableName) .. "\n") end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Failed to wipe table: %s", tostring(err)) .. "\n") end)
        end, function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), string.format("Backup failed, aborting wipe: %s", tostring(err)) .. "\n") end)
    end)
else
    concommand.Add("weighpoint_stop", function() hook.Remove("HUDPaint", "WeighPoint") end)
    concommand.Add("lia_vgui_cleanup", function()
        for _, v in pairs(vgui.GetWorldPanel():GetChildren()) do
            if not (v.Init and debug.getinfo(v.Init, "Sln").short_src:find("chatbox")) then v:Remove() end
        end
    end)

    local function performPanelCheck()
        local function enumeratePanels(panel, depth)
            depth = depth or 0
            local children = panel:GetChildren()
            local count = 0
            for _, child in ipairs(children) do
                if IsValid(child) then
                    count = count + 1
                    count = count + enumeratePanels(child, depth + 1)
                end
            end
            return count
        end

        local function collectPanelData(panel, panelTypes, hiddenPanelTypes, depth)
            depth = depth or 0
            local children = panel:GetChildren()
            for _, child in ipairs(children) do
                if IsValid(child) then
                    local panelType = child:GetName() or "Unknown"
                    if child:IsVisible() then
                        panelTypes[panelType] = (panelTypes[panelType] or 0) + 1
                    else
                        hiddenPanelTypes[panelType] = (hiddenPanelTypes[panelType] or 0) + 1
                    end

                    collectPanelData(child, panelTypes, hiddenPanelTypes, depth + 1)
                end
            end
        end

        local worldPanel = vgui.GetWorldPanel()
        local panelCount = enumeratePanels(worldPanel)
        local visiblePanels = 0
        local panelTypes = {}
        local hiddenPanelTypes = {}
        collectPanelData(worldPanel, panelTypes, hiddenPanelTypes)
        for _, count in pairs(panelTypes) do
            visiblePanels = visiblePanels + count
        end

        LocalPlayer():ChatPrint("Total panels on screen (including subpanels): " .. panelCount)
        LocalPlayer():ChatPrint("Visible panels: " .. visiblePanels)
        if table.Count(panelTypes) > 0 then
            LocalPlayer():ChatPrint("Visible panel types:")
            for panelType, count in pairs(panelTypes) do
                LocalPlayer():ChatPrint("  " .. panelType .. ": " .. count)
            end
        end

        LocalPlayer():ChatPrint("Hidden panels: " .. (panelCount - visiblePanels))
        if table.Count(hiddenPanelTypes) > 0 then
            LocalPlayer():ChatPrint("Hidden panel types:")
            for panelType, count in pairs(hiddenPanelTypes) do
                LocalPlayer():ChatPrint("  " .. panelType .. ": " .. count)
            end
        end
    end

    concommand.Add("lia_test_panels", function(_, _, args)
        local delay = tonumber(args[1]) or 0
        if delay > 0 then
            LocalPlayer():ChatPrint("Checking panels in " .. delay .. " seconds...")
            timer.Simple(delay, function()
                if not IsValid(LocalPlayer()) then return end
                performPanelCheck()
            end)
        else
            performPanelCheck()
        end
    end)

    concommand.Add("lia_panel_browser", function()
        local allPanels = {}
        local liaPanels = {}
        local gmodPanels = {}
        for panelName, _ in pairs(vgui.GetTypes()) do
            table.insert(allPanels, panelName)
            if string.StartWith(panelName, "lia") or string.StartWith(panelName, "Lia") then
                table.insert(liaPanels, panelName)
            else
                table.insert(gmodPanels, panelName)
            end
        end

        table.sort(allPanels)
        table.sort(liaPanels)
        table.sort(gmodPanels)
        local frame = vgui.Create("liaFrame")
        frame:SetTitle("VGUI Panel Browser")
        frame:SetSize(900, 700)
        frame:Center()
        frame:MakePopup()
        frame:SetSizable(true)
        frame:SetMinWidth(600)
        frame:SetMinHeight(400)
        local infoPanel = vgui.Create("DPanel", frame)
        infoPanel:Dock(TOP)
        infoPanel:SetTall(60)
        infoPanel:DockMargin(0, 0, 0, 5)
        infoPanel.Paint = function(_, w, h)
            lia.derma.rect(0, 0, w, h):Rad(4):Color(lia.color.theme.panel[1]):Draw()
            draw.SimpleText("Total Panels: " .. #allPanels, "LiliaFont.18", 10, 10, lia.color.theme.text)
            draw.SimpleText("Lilia Panels: " .. #liaPanels, "LiliaFont.16", 10, 35, lia.color.theme.accent)
            draw.SimpleText("GMod Panels: " .. #gmodPanels, "LiliaFont.16", 200, 35, lia.color.theme.text)
        end

        local searchBox = vgui.Create("liaEntry", frame)
        searchBox:Dock(TOP)
        searchBox:DockMargin(0, 0, 0, 5)
        searchBox:SetPlaceholderText("Search panels...")
        searchBox:SetTall(35)
        local categorySheet = vgui.Create("DPropertySheet", frame)
        categorySheet:Dock(FILL)
        categorySheet:DockMargin(0, 0, 0, 0)
        local function createPanelList(parent, panelList)
            local scroll = vgui.Create("liaScrollPanel", parent)
            scroll:Dock(FILL)
            local panelItems = {}
            local function populateList(filter)
                for _, item in ipairs(panelItems) do
                    if IsValid(item) then item:Remove() end
                end

                panelItems = {}
                for _, panelName in ipairs(panelList) do
                    if not filter or filter == "" or string.find(string.lower(panelName), string.lower(filter)) then
                        local panelItem = vgui.Create("DPanel", scroll)
                        panelItem:Dock(TOP)
                        panelItem:SetTall(50)
                        panelItem:DockMargin(2, 2, 2, 2)
                        panelItem.Paint = function(_, w, h)
                            local col = lia.color.theme.panel[2]
                            if panelItem:IsHovered() then col = ColorAlpha(lia.color.theme.accent, 30) end
                            lia.derma.rect(0, 0, w, h):Rad(4):Color(col):Draw()
                            draw.SimpleText(panelName, "LiliaFont.17", 10, h * 0.5, lia.color.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end

                        local spawnBtn = vgui.Create("liaButton", panelItem)
                        spawnBtn:SetText("Test")
                        spawnBtn:SetWide(80)
                        spawnBtn:Dock(RIGHT)
                        spawnBtn:DockMargin(5, 5, 5, 5)
                        spawnBtn.DoClick = function()
                            local success, err = pcall(function()
                                local testPanel = vgui.Create(panelName)
                                if IsValid(testPanel) then
                                    if testPanel.SetSize then testPanel:SetSize(400, 300) end
                                    if testPanel.Center then
                                        testPanel:Center()
                                    else
                                        testPanel:SetPos(ScrW() * 0.5 - 200, ScrH() * 0.5 - 150)
                                    end

                                    if testPanel.MakePopup then testPanel:MakePopup() end
                                    if testPanel.SetVisible then testPanel:SetVisible(true) end
                                    LocalPlayer():ChatPrint("Created test instance of: " .. panelName)
                                else
                                    LocalPlayer():ChatPrint("Failed to create: " .. panelName)
                                end
                            end)

                            if not success then LocalPlayer():ChatPrint("Error creating " .. panelName .. ": " .. tostring(err)) end
                        end

                        local copyBtn = vgui.Create("liaButton", panelItem)
                        copyBtn:SetText("Copy")
                        copyBtn:SetWide(80)
                        copyBtn:Dock(RIGHT)
                        copyBtn:DockMargin(5, 5, 5, 5)
                        copyBtn.DoClick = function()
                            SetClipboardText(panelName)
                            LocalPlayer():ChatPrint("Copied to clipboard: " .. panelName)
                        end

                        table.insert(panelItems, panelItem)
                    end
                end
            end

            populateList()
            return populateList
        end

        local allTab = vgui.Create("DPanel")
        allTab.Paint = function(_, w, h) lia.derma.rect(0, 0, w, h):Rad(4):Color(Color(25, 28, 35, 250)):Draw() end
        local allPopulate = createPanelList(allTab, allPanels)
        categorySheet:AddSheet("All Panels (" .. #allPanels .. ")", allTab, "icon16/application_view_list.png")
        local liaTab = vgui.Create("DPanel")
        liaTab.Paint = function(_, w, h) lia.derma.rect(0, 0, w, h):Rad(4):Color(Color(25, 28, 35, 250)):Draw() end
        local liaPopulate = createPanelList(liaTab, liaPanels)
        categorySheet:AddSheet("Lilia Panels (" .. #liaPanels .. ")", liaTab, "icon16/star.png")
        local gmodTab = vgui.Create("DPanel")
        gmodTab.Paint = function(_, w, h) lia.derma.rect(0, 0, w, h):Rad(4):Color(Color(25, 28, 35, 250)):Draw() end
        local gmodPopulate = createPanelList(gmodTab, gmodPanels)
        categorySheet:AddSheet("GMod Panels (" .. #gmodPanels .. ")", gmodTab, "icon16/wrench.png")
        searchBox.OnValueChange = function(_, value)
            allPopulate(value)
            liaPopulate(value)
            gmodPopulate(value)
        end

        LocalPlayer():ChatPrint("Panel Browser opened! Found " .. #allPanels .. " registered panels.")
    end)

    concommand.Add("lia_saved_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local soundFiles = {}
        if files then
            for _, fileName in ipairs(files) do
                if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then table.insert(soundFiles, fileName) end
            end
        end

        if #soundFiles == 0 then
            LocalPlayer():ChatPrint("No saved sounds found!")
            return
        end

        local f = vgui.Create("liaFrame")
        f:SetTitle("Saved sounds:")
        f:SetSize(600, 500)
        f:Center()
        f:MakePopup()
        local scroll = vgui.Create("liaScrollPanel", f)
        scroll:Dock(FILL)
        scroll:DockMargin(5, 5, 5, 5)
        for _, fileName in ipairs(soundFiles) do
            local soundName = string.StripExtension(fileName)
            local soundPath = baseDir .. fileName
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(40)
            panel:DockMargin(2, 2, 2, 2)
            panel.Paint = function(_, w, h)
                surface.SetDrawColor(60, 60, 60, 200)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(100, 100, 100, 100)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local nameLabel = vgui.Create("DLabel", panel)
            nameLabel:SetText(soundName)
            nameLabel:SetFont("LiliaFont.17")
            nameLabel:SetTextColor(Color(255, 255, 255))
            nameLabel:Dock(LEFT)
            nameLabel:DockMargin(10, 0, 0, 0)
            nameLabel:SetWide(300)
            local playButton = vgui.Create("liaButton", panel)
            playButton:SetText("? Play")
            playButton:SetWide(80)
            playButton:Dock(RIGHT)
            playButton:DockMargin(5, 5, 5, 5)
            playButton.DoClick = function()
                if file.Exists(soundPath, "DATA") then
                    local fullPath = "data/" .. soundPath
                    timer.Simple(0.1, function()
                        sound.PlayFile(fullPath, "", function(channel, _, errorString)
                            if IsValid(channel) then
                                LocalPlayer():ChatPrint("Playing: " .. soundName)
                            else
                                LocalPlayer():ChatPrint("Failed to play: " .. soundName .. " (" .. (errorString or "unknown error") .. ")")
                            end
                        end)
                    end)
                else
                    LocalPlayer():ChatPrint("Sound file not found: " .. soundName)
                end
            end

            local stopButton = vgui.Create("liaButton", panel)
            stopButton:SetText("■ Stop")
            stopButton:SetWide(80)
            stopButton:Dock(RIGHT)
            stopButton:DockMargin(5, 5, 5, 5)
            stopButton.DoClick = function()
                timer.Simple(0.1, function()
                    sound.PlayFile("", "", function() end)
                    LocalPlayer():ChatPrint("Stopped all sounds")
                end)
            end
        end
    end)

    concommand.Add("lia_wipe_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local deletedCount = 0
        for _, fn in ipairs(files) do
            if string.EndsWith(fn, ".mp3") or string.EndsWith(fn, ".wav") or string.EndsWith(fn, ".ogg") or string.EndsWith(fn, ".dat") then
                file.Delete(baseDir .. fn)
                deletedCount = deletedCount + 1
            end
        end

        LocalPlayer():ChatPrint("Sounds Wiped (" .. deletedCount .. " files)")
    end)

    concommand.Add("lia_validate_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local validCount = 0
        local invalidCount = 0
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if data and #data > 0 then
                    validCount = validCount + 1
                else
                    invalidCount = invalidCount + 1
                end
            elseif string.EndsWith(fileName, ".dat") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if data then
                    local success, soundData = pcall(pon.decode, data)
                    if success and soundData then
                        validCount = validCount + 1
                    else
                        invalidCount = invalidCount + 1
                    end
                end
            end
        end

        LocalPlayer():ChatPrint(string.format("Sound validation complete: %d valid, %d invalid", validCount, invalidCount))
    end)

    concommand.Add("lia_cleanup_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local removedCount = 0
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if not data or #data == 0 then
                    file.Delete(baseDir .. fileName)
                    removedCount = removedCount + 1
                end
            elseif string.EndsWith(fileName, ".dat") then
                local data = file.Read(baseDir .. fileName, "DATA")
                if not data then
                    file.Delete(baseDir .. fileName)
                    removedCount = removedCount + 1
                else
                    local success, soundData = pcall(pon.decode, data)
                    if not success or not soundData then
                        file.Delete(baseDir .. fileName)
                        removedCount = removedCount + 1
                    end
                end
            end
        end

        LocalPlayer():ChatPrint(string.format("Cleaned up %d invalid sound files", removedCount))
    end)

    concommand.Add("lia_list_sounds", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        if #files == 0 then return end
        LocalPlayer():ChatPrint("Saved sounds:")
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") or string.EndsWith(fileName, ".dat") then LocalPlayer():ChatPrint(string.format("  %s", string.StripExtension(fileName))) end
        end
    end)

    local function findImagesRecursive(dir, result)
        result = result or {}
        local files, dirs = file.Find(dir .. "*", "DATA")
        if files then
            for _, fn in ipairs(files) do
                table.insert(result, dir .. fn)
            end
        end

        if dirs then
            for _, subdir in ipairs(dirs) do
                findImagesRecursive(dir .. subdir .. "/", result)
            end
        end
        return result
    end

    local function deleteDirectoryRecursive(dir)
        local files, dirs = file.Find(dir .. "*", "DATA")
        if files then
            for _, fn in ipairs(files) do
                file.Delete(dir .. fn)
            end
        end

        if dirs then
            for _, subdir in ipairs(dirs) do
                deleteDirectoryRecursive(dir .. subdir .. "/")
                file.Delete(dir .. subdir)
            end
        end
    end

    concommand.Add("lia_saved_images", function()
        local baseDir = "lilia/webimages/"
        local files = findImagesRecursive(baseDir)
        local imageFiles = {}
        if files then
            for _, fileName in ipairs(files) do
                if string.EndsWith(fileName, ".png") or string.EndsWith(fileName, ".jpg") or string.EndsWith(fileName, ".jpeg") then table.insert(imageFiles, fileName) end
            end
        end

        if #imageFiles == 0 then
            LocalPlayer():ChatPrint("No saved images found!")
            return
        end

        local f = vgui.Create("liaFrame")
        f:SetTitle("Saved Images")
        f:SetSize(700, 600)
        f:Center()
        f:MakePopup()
        local scroll = vgui.Create("liaScrollPanel", f)
        scroll:Dock(FILL)
        scroll:DockMargin(5, 5, 5, 5)
        for _, fileName in ipairs(imageFiles) do
            local imageName = string.StripExtension(fileName)
            local imagePath = baseDir .. fileName
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(120)
            panel:DockMargin(2, 2, 2, 2)
            panel.Paint = function(_, w, h)
                surface.SetDrawColor(60, 60, 60, 200)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(100, 100, 100, 100)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local imagePreview = vgui.Create("DImage", panel)
            imagePreview:SetPos(10, 10)
            imagePreview:SetSize(100, 100)
            imagePreview:SetImage("data/" .. imagePath)
            local nameLabel = vgui.Create("DLabel", panel)
            nameLabel:SetText(imageName)
            nameLabel:SetFont("LiliaFont.17")
            nameLabel:SetTextColor(Color(255, 255, 255))
            nameLabel:SetPos(120, 10)
            nameLabel:SetWide(300)
            local viewButton = vgui.Create("liaButton", panel)
            viewButton:SetText("?? View")
            viewButton:SetWide(80)
            viewButton:SetPos(120, 40)
            viewButton.DoClick = function()
                local viewFrame = vgui.Create("liaFrame")
                viewFrame:SetTitle("Image Viewer - " .. imageName)
                viewFrame:SetSize(800, 600)
                viewFrame:Center()
                viewFrame:MakePopup()
                local fullImage = vgui.Create("DImage", viewFrame)
                fullImage:Dock(FILL)
                fullImage:DockMargin(10, 10, 10, 10)
                fullImage:SetImage("data/" .. imagePath)
            end

            local copyButton = vgui.Create("liaButton", panel)
            copyButton:SetText("?? Copy Path")
            copyButton:SetWide(100)
            copyButton:SetPos(210, 40)
            copyButton.DoClick = function()
                SetClipboardText("data/" .. imagePath)
                LocalPlayer():ChatPrint("Image path copied to clipboard: data/" .. imagePath)
            end
        end
    end)

    concommand.Add("lia_cleanup_images", function()
        local baseDir = "lilia/webimages/"
        local files = findImagesRecursive(baseDir)
        local removedCount = 0
        for _, filePath in ipairs(files) do
            if not file.Exists(filePath, "DATA") then removedCount = removedCount + 1 end
        end

        LocalPlayer():ChatPrint(string.format("Found %d image files", #files))
    end)

    concommand.Add("lia_wipewebimages", function()
        local baseDir = "lilia/webimages/"
        deleteDirectoryRecursive(baseDir)
        cache = {}
        urlMap = {}
        LocalPlayer():ChatPrint("Web Images Wiped")
    end)

    concommand.Add("test_webimage_menu", function()
        local frame = vgui.Create("liaFrame")
        frame:SetTitle("WebImage Tester")
        frame:SetSize(500, 400)
        frame:Center()
        frame:MakePopup()
        local textEntry = vgui.Create("liaEntry", frame)
        textEntry:Dock(TOP)
        textEntry:DockMargin(5, 5, 5, 5)
        textEntry:SetPlaceholderText("Web Image Tester URL")
        local button = vgui.Create("liaButton", frame)
        button:Dock(TOP)
        button:DockMargin(5, 0, 5, 5)
        button:SetText("Web Image Tester Load")
        local imagePanel = vgui.Create("DPanel", frame)
        imagePanel:Dock(FILL)
        imagePanel:DockMargin(5, 5, 5, 5)
        button.DoClick = function()
            local url = textEntry:GetValue()
            if url and url ~= "" then
                local img = vgui.Create("DImage", imagePanel)
                img:Dock(FILL)
                img:SetImage(url)
            end
        end
    end)

    concommand.Add("test_sound_playback", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local soundFiles = {}
        if files then
            for _, fileName in ipairs(files) do
                if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") then table.insert(soundFiles, fileName) end
            end
        end

        if #soundFiles > 0 then
            local testFile = soundFiles[1]
            local fullPath = "data/" .. baseDir .. testFile
            sound.PlayFile(fullPath, "", function(channel, _, errorString)
                if IsValid(channel) then
                    LocalPlayer():ChatPrint("Direct test successful: " .. testFile)
                else
                    LocalPlayer():ChatPrint("Direct test failed: " .. testFile .. " (" .. (errorString or "unknown error") .. ")")
                end
            end)
        else
            LocalPlayer():ChatPrint("No sound files found for testing")
        end
    end)

    concommand.Add("test_saved_commands", function()
        local baseDir = "lilia/websounds/"
        local files = file.Find(baseDir .. "**", "DATA")
        local soundFiles = {}
        if files then
            for _, fileName in ipairs(files) do
                if string.EndsWith(fileName, ".mp3") or string.EndsWith(fileName, ".wav") or string.EndsWith(fileName, ".ogg") or string.EndsWith(fileName, ".dat") then table.insert(soundFiles, fileName) end
            end
        end

        for i, fileName in ipairs(soundFiles) do
            LocalPlayer():ChatPrint("  " .. i .. ": " .. fileName)
        end

        local baseDir2 = "lilia/webimages/"
        local files2 = file.Find(baseDir2 .. "**", "DATA")
        local imageFiles = {}
        if files2 then
            for _, fileName in ipairs(files2) do
                if string.EndsWith(fileName, ".png") or string.EndsWith(fileName, ".jpg") or string.EndsWith(fileName, ".jpeg") then table.insert(imageFiles, fileName) end
            end
        end

        for i, fileName in ipairs(imageFiles) do
            LocalPlayer():ChatPrint("  " .. i .. ": " .. fileName)
        end
    end)

    concommand.Add("printpos", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] Error PrefixThis command can only be used by players.\n")
            return
        end

        local pos = client:GetPos()
        local ang = client:GetAngles()
        MsgC(Color(255, 255, 255), "Vector = (" .. math.Round(pos.x, 2) .. ", " .. math.Round(pos.y, 2) .. ", " .. math.Round(pos.z, 2) .. "), \nAngle = (" .. math.Round(ang.x, 2) .. ", " .. math.Round(ang.y, 2) .. ", " .. math.Round(ang.z, 2) .. ")\n")
    end)

    concommand.Add("debugFactionMaps", function(client, _, args)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] Error PrefixThis command can only be used by players.\n")
            return
        end

        local factionName = args[1]
        if not factionName then
            MsgC(Color(255, 193, 7), "[Lilia] Usage: debugFactionMaps <faction_name>\n")
            return
        end

        local faction = nil
        for _, f in pairs(lia.faction.teams) do
            if string.lower(f.name) == string.lower(factionName) then
                faction = f
                break
            end
        end

        if not faction then
            MsgC(Color(255, 0, 0), "[Lilia] Faction not found.\n")
            return
        end

        MsgC(Color(0, 255, 0), "[Lilia] " .. string.format("Debug info for faction '%s':", faction.name) .. "\n")
        MsgC(Color(255, 255, 0), "Current map: " .. game.GetMap() .. "\n")
        if not faction.mainMenuPosition then
            MsgC(Color(255, 0, 0), "No mainMenuPosition defined for this faction.\n")
            return
        end

        if isvector(faction.mainMenuPosition) then
            MsgC(Color(0, 255, 0), "Simple vector position: " .. tostring(faction.mainMenuPosition) .. "\n")
        elseif istable(faction.mainMenuPosition) then
            MsgC(Color(0, 255, 0), "Map-specific positions:\n")
            for mapName, posData in pairs(faction.mainMenuPosition) do
                local isCurrentMap = mapName == lia.data.getEquivalencyMap(game.GetMap())
                local mapColor = isCurrentMap and Color(0, 255, 0) or Color(255, 255, 255)
                MsgC(mapColor, "  " .. (isCurrentMap and ">>> " or "    ") .. mapName .. ":\n")
                if istable(posData) then
                    MsgC(mapColor, "    Position: " .. tostring(posData.position or posData) .. "\n")
                    if posData.angles then MsgC(mapColor, "    angles: " .. tostring(posData.angles) .. "\n") end
                elseif isvector(posData) then
                    MsgC(mapColor, "    Position: " .. tostring(posData) .. "\n")
                end
            end
        end
    end)
end

lia.command.add("demorequests", {
    desc = "Demonstrates all available request UI functions",
    privilege = "Staff",
    onRun = function(client)
        if SERVER then
            client:notifyInfo("Opening request UI demo...")
            client:requestBinaryQuestion("UI Demo", "Would you like to see all the request UI demos?", "Yes, show me!", "No, thanks", function(confirmed)
                if confirmed then
                    client:requestDropdown("Demo: Dropdown Selection", "Choose your favorite color:", {{"Red", "red"}, {"Blue", "blue"}, {"Green", "green"}, {"Yellow", "yellow"}}, function(selected)
                        if selected ~= nil then
                            client:requestOptions("Demo: Multi-Select Options", "Select your favorite activities (max 3):", {{"Gaming", "gaming"}, {"Reading", "reading"}, {"Sports", "sports"}, {"Music", "music"}, {"Cooking", "cooking"}, {"Travel", "travel"}}, 3, function(selectedOptions)
                                if selectedOptions and #selectedOptions > 0 then
                                    client:requestString("Demo: Text Input", "Enter a fun message (max 50 characters):", function(message)
                                        if message then
                                            client:requestArguments("Demo: Structured Input", {
                                                {"Name", "string"},
                                                {
                                                    "Age",
                                                    {
                                                        "number",
                                                        {
                                                            min = 1,
                                                            max = 150
                                                        }
                                                    }
                                                },
                                                {"Favorite Color", {"table", {{"Red", "red"}, {"Blue", "blue"}, {"Green", "green"}}}},
                                                {"Agree to Terms", "boolean"}
                                            }, function(success, argumentsData)
                                                if success and argumentsData then
                                                    client:requestButtons("Demo: Button Selection", {
                                                        {
                                                            text = "Save Progress",
                                                            icon = "icon16/disk.png"
                                                        },
                                                        {
                                                            text = "Load Previous",
                                                            icon = "icon16/folder.png"
                                                        },
                                                        {
                                                            text = "Start Over",
                                                            icon = "icon16/arrow_refresh.png"
                                                        },
                                                        {
                                                            text = "Exit Demo",
                                                            icon = "icon16/door.png"
                                                        }
                                                    }, function(_, buttonText) client:notify("Demo completed! You selected: " .. buttonText, "success") end, "Choose what to do next:")
                                                else
                                                    client:notifyWarning("Arguments demo cancelled")
                                                end
                                            end, {
                                                Name = "Demo User",
                                                Age = 25,
                                                ["Favorite Color"] = {"Blue", "blue"},
                                                ["Agree to Terms"] = true
                                            })
                                        else
                                            client:notifyWarning("String input demo cancelled")
                                        end
                                    end, "", 50)
                                else
                                    client:notifyWarning("Options demo cancelled")
                                end
                            end)
                        else
                            client:notifyWarning("Dropdown demo cancelled")
                        end
                    end)
                else
                    client:notifyInfo("Demo cancelled - no problem!")
                end
            end)
        end
    end
})

lia.command.add("playtime", {
    adminOnly = false,
    desc = "Displays your total playtime on the server.",
    onRun = function(client)
        local secs = client:getPlayTime()
        if not secs then
            client:notifyError("Could not retrieve your playtime.")
            return
        end

        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:notifyInfo(string.format("Your playtime is %s hours, %s minutes, and %s seconds.", h, m, s))
    end
})

lia.command.add("charid", {
    adminOnly = false,
    desc = "Displays your current character's ID.",
    onRun = function(client)
        local char = client:getChar()
        if not char then
            client:notifyError("You have no character selected")
            return
        end

        local charID = char:getID()
        client:notifyInfo(string.format("Your character ID is: %s", charID))
    end
})

lia.command.add("plygetplaytime", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Player Playtime",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/time.png"
    },
    desc = "Shows the total playtime of the specified character.",
    onRun = function(client, args)
        if not args[1] then
            client:notifyError("Please specify a player.")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local secs = target:getPlayTime()
        local h = math.floor(secs / 3600)
        local m = math.floor((secs % 3600) / 60)
        local s = secs % 60
        client:ChatPrint(string.format("%s's playtime is %s hours, %s minutes, and %s seconds.", target:Nick(), h, m, s))
    end
})

lia.command.add("plycheckid", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Character ID",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/vcard.png"
    },
    desc = "Shows the character ID of the specified player.",
    onRun = function(client, args)
        if not args[1] then
            client:notifyError("Please specify a player.")
            return
        end

        local target = lia.util.findPlayer(client, args[1])
        if not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyError("Player has no character loaded")
            return
        end

        local charID = char:getID()
        client:ChatPrint(string.format("%s's character ID is: %s", target:Nick(), charID))
    end
})

lia.command.add("checkid", {
    desc = "Displays your current character's ID.",
    onRun = function(client)
        local char = client:getChar()
        if not char then
            client:notifyError("You have no character selected")
            return
        end

        local charID = char:getID()
        client:ChatPrint(string.format("Your character ID is: %s", charID))
    end
})

lia.command.add("managesitrooms", {
    superAdminOnly = true,
    desc = "Manage administration rooms on the current map: view existing administration rooms, teleport to them, rename them, or reposition them.",
    onRun = function(client)
        if not client:hasPrivilege("manageSitRooms") then return end
        local rooms = lia.data.get("sitrooms", {})
        net.Start("liaManagesitrooms")
        net.WriteTable(rooms)
        net.Send(client)
    end
})

lia.command.add("addsitroom", {
    superAdminOnly = true,
    desc = "Set Administration Room",
    onRun = function(client)
        client:requestString("Enter Name", "Enter the name of the Administration Room:", function(name)
            if name == "" then
                client:notifyError("Invalid name!")
                return
            end

            local rooms = lia.data.get("sitrooms", {})
            rooms[name] = client:GetPos()
            lia.data.set("sitrooms", rooms)
            client:notifySuccess("Administration Room has been set!")
            lia.log.add(client, "sitRoomSet", string.format("Name: %s | Position: %s", name, tostring(client:GetPos())), "Set the administration room location")
        end)
    end
})

lia.command.add("sendtositroom", {
    adminOnly = true,
    desc = "Send a player to an Administration Room",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Send To Administration Room",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/arrow_down.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local rooms = lia.data.get("sitrooms", {})
        local names = {}
        for n in pairs(rooms) do
            names[#names + 1] = n
        end

        if #names == 0 then
            client:notifyError("No Administration Room has been set!")
            return
        end

        client:requestDropdown("Choose an Administration Room", "Select an Administration Room to send the player to:", names, function(selection)
            local pos = rooms[selection]
            if not pos then
                client:notifyError("No Administration Room has been set!")
                return
            end

            target:SetPos(pos)
            client:notifySuccess(string.format("You have been teleported to Administration Room: %s.", target:Nick()))
            target:notifyInfo("You have arrived at an Administration Room.")
            lia.log.add(client, "sendToSitRoom", target:Nick(), selection)
        end)
    end
})

lia.command.add("returnsitroom", {
    adminOnly = true,
    desc = "Returns you or the specified player to their previous position before teleporting to an administration room.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Return From Administration Room",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/arrow_up.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local prev = target.previousSitroomPos
        if not prev then
            client:notifyError("No previous sitroom position")
            return
        end

        target:SetPos(prev)
        client:notifySuccess("Successfully returned to sitroom")
        if target ~= client then target:notifyInfo("Returned to your previous position.") end
        lia.log.add(client, "sitRoomReturn", target:Nick())
    end
})

lia.command.add("charkill", {
    superAdminOnly = true,
    alias = "permakill",
    desc = "Opens the PK case menu to permanently kill a character.",
    arguments = {
        {
            name = "name",
            type = "player"
        }
    },
    AdminStick = {
        Name = "Character Kill (Permakill)",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_delete.png"
    },
    onRun = function(client, args)
        if not args[1] then
            client:notifyError("Please specify a player.")
            return
        end

        local ply = lia.util.findPlayer(client, args[1])
        if not IsValid(ply) then
            client:notifyError("Target not found")
            return
        end

        local char = ply:getChar()
        if not char then
            client:notifyError("Player has no character loaded")
            return
        end

        local isPermakilled = char:getData("permakilled", false)
        if isPermakilled then
            char:setData("permakilled", nil)
            lia.db.delete("permakills", "charID = " .. lia.db.convertDataType(char:getID()))
            client:notifySuccess(string.format("%s removed permakill marking from character %s.", client:Name(), ply:Nick()))
            lia.log.add(client, "charUnkill", ply:Nick(), char:getID())
        else
            local reasonKey = "Reason"
            local evidenceKey = "Evidence"
            client:requestArguments("PK Reason & Evidence", {
                [reasonKey] = "string",
                [evidenceKey] = "string"
            }, function(success, data)
                if not success then return end
                local reason = data[reasonKey]
                local evidence = data[evidenceKey]
                lia.db.insertTable({
                    player = ply:Nick(),
                    reason = reason,
                    steamID = ply:SteamID(),
                    charID = char:getID(),
                    submitterName = client:Name(),
                    submitterSteamID = client:SteamID(),
                    timestamp = os.time(),
                    evidence = evidence
                }, nil, "permakills")

                char:setData("permakilled", true)
                local instantDeathKey = "Kill instantly (auto-ban)"
                client:requestArguments("PK Death Option", {
                    [instantDeathKey] = "boolean"
                }, function(success2, data2)
                    if not success2 then return end
                    local instantDeath = data2[instantDeathKey]
                    if instantDeath then
                        ply:Kill()
                        client:notifySuccess(string.format("%s marked character %s for permakill and killed them instantly.", client:Name(), ply:Nick()))
                        lia.log.add(client, "charKillInstant", ply:Nick(), char:getID(), reason)
                    else
                        client:notifySuccess(string.format("%s marked character %s for permakill.", client:Name(), ply:Nick()))
                        lia.log.add(client, "charKill", ply:Nick(), char:getID(), reason)
                    end
                end)
            end)
        end
    end
})

local function sanitizeForNet(tbl)
    if istable(tbl) then return tbl end
    local result = {}
    for k, v in pairs(tbl) do
        if istable(c) then
            result[k] = sanitizeForNet(v)
        elseif not isfunction(v) then
            result[k] = v
        end
    end
    return result
end

lia.command.add("charlist", {
    adminOnly = true,
    desc = "List all characters for a player by name or Steam ID, or yourself if none is provided.",
    arguments = {
        {
            name = "playerOrSteamId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local identifier = arguments[1]
        local target
        local steamID
        if identifier then
            target = lia.util.findPlayer(client, identifier)
            if IsValid(target) then
                steamID = target:SteamID()
            elseif identifier:match("^STEAM_%d:%d:%d+$") then
                steamID = identifier
            else
                client:notifyError("Target not found")
                return
            end
        else
            steamID = client:SteamID()
        end

        local query = [[SELECT c.*, d.value AS charBanInfo FROM lia_characters AS c LEFT JOIN lia_chardata AS d ON d.charID = c.id AND d.key = 'charBanInfo' WHERE c.steamID = ]] .. lia.db.convertDataType(steamID)
        lia.db.query(query, function(data)
            if not data or #data == 0 then
                client:notifyInfo("No characters found for this player.")
                return
            end

            local sendData = {}
            for _, row in ipairs(data) do
                local charID = tonumber(row.id) or row.id
                local stored = lia.char.getCharacter(charID)
                local info = stored and stored:getData() or {}
                local allVars = {}
                if stored then
                    for varName in pairs(lia.char.vars) do
                        local value
                        if varName == "data" then
                            value = stored:getData()
                        elseif varName == "var" then
                            value = stored:getVar()
                        else
                            local getter = stored["get" .. varName:sub(1, 1):upper() .. varName:sub(2)]
                            if isfunction(getter) then
                                value = getter(stored)
                            else
                                value = stored.vars and stored.vars[varName]
                            end
                        end

                        allVars[varName] = value
                    end
                end

                local banInfo = info.charBanInfo
                if not banInfo and row.charBanInfo and row.charBanInfo ~= "" then
                    local ok, decoded = pcall(pon.decode, row.charBanInfo)
                    if ok then
                        banInfo = decoded and decoded[1] or {}
                    else
                        banInfo = util.JSONToTable(row.charBanInfo) or {}
                    end
                end

                local bannedVal = stored and stored:getBanned() or tonumber(row.banned) or 0
                local isBanned = bannedVal ~= 0 and (bannedVal == -1 or bannedVal > os.time())
                local entry = {
                    ID = charID,
                    Name = stored and stored:getName() or row.name,
                    Desc = row.desc,
                    Faction = row.faction,
                    Banned = isBanned and "Yes" or "No",
                    BanningAdminName = banInfo and banInfo.name or "",
                    BanningAdminSteamID = banInfo and banInfo.steamID or "",
                    BanningAdminRank = banInfo and banInfo.rank or "",
                    Money = row.money,
                    LastUsed = stored and "Online now" or row.lastJoinTime,
                    allVars = allVars
                }

                entry.extraDetails = {}
                hook.Run("CharListExtraDetails", client, entry, stored)
                entry = sanitizeForNet(entry)
                table.insert(sendData, entry)
            end

            sendData = sanitizeForNet(sendData)
            net.Start("liaDisplayCharList")
            net.WriteTable(sendData)
            net.WriteString(steamID)
            net.Send(client)
        end)
    end
})

lia.command.add("plyban", {
    adminOnly = true,
    desc = "Ban a player from the server for a duration.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "duration",
            type = "string",
            optional = true
        },
        {
            name = "reason",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Ban Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/lock.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ban", arguments[1], arguments[2], arguments[3], client) end
})

lia.command.add("plykick", {
    adminOnly = true,
    desc = "Kick a player from the server.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "reason",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Kick Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_delete.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("kick", arguments[1], nil, arguments[2], client) end
})

lia.command.add("plykill", {
    adminOnly = true,
    desc = "Kill the specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Kill Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_red.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("kill", arguments[1], nil, nil, client) end
})

lia.command.add("plyunban", {
    adminOnly = true,
    desc = "Remove a player's ban by SteamID.",
    arguments = {
        {
            name = "steamid",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local steamid = arguments[1]
        if steamid and steamid ~= "" then
            lia.db.query("DELETE FROM lia_bans WHERE playerSteamID = " .. lia.db.convertDataType(steamid))
            client:notifySuccess("Player unbanned")
            lia.log.add(client, "plyUnban", steamid)
        end
    end
})

lia.command.add("plyfreeze", {
    adminOnly = true,
    desc = "Freeze a player for an optional duration.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "duration",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("freeze", arguments[1], arguments[2], nil, client) end
})

lia.command.add("plyunfreeze", {
    adminOnly = true,
    desc = "Unfreeze a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unfreeze", arguments[1], nil, nil, client) end
})

lia.command.add("plyslay", {
    adminOnly = true,
    desc = "Slay a player instantly.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("slay", arguments[1], nil, nil, client) end
})

lia.command.add("plyrespawn", {
    adminOnly = true,
    desc = "Force another player to respawn.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Respawn Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/arrow_refresh.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("respawn", arguments[1], nil, nil, client) end
})

lia.command.add("plyblind", {
    adminOnly = true,
    desc = "Blind a player with a black screen.",
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
    onRun = function(client, arguments) lia.admin.serverExecCommand("blind", arguments[1], arguments[2], nil, client) end
})

lia.command.add("plyunblind", {
    adminOnly = true,
    desc = "Remove blindness from a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unblind", arguments[1], nil, nil, client) end
})

lia.command.add("plyblindfade", {
    adminOnly = true,
    desc = "Fade a player's screen to a color.",
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
        {
            name = "color",
            type = "string",
            optional = true
        },
        {
            name = "fadein",
            type = "string",
            optional = true
        },
        {
            name = "fadeout",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Blind Player (Fade)",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/eye.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if IsValid(target) then
            local duration = tonumber(arguments[2]) or 0
            local colorName = (arguments[3] or "black"):lower()
            local fadeIn = tonumber(arguments[4])
            local fadeOut = tonumber(arguments[5])
            fadeIn = fadeIn or duration * 0.05
            fadeOut = fadeOut or duration * 0.05
            net.Start("liaBlindFade")
            net.WriteBool(colorName == "white")
            net.WriteFloat(duration)
            net.WriteFloat(fadeIn)
            net.WriteFloat(fadeOut)
            net.Send(target)
            lia.log.add(client, "plyBlindFade", target:Name(), duration, colorName)
        end
    end
})

lia.command.add("blindfadeall", {
    adminOnly = true,
    desc = "Fade all non-staff players' screens.",
    arguments = {
        {
            name = "time",
            type = "string",
            optional = true
        },
        {
            name = "color",
            type = "string",
            optional = true
        },
        {
            name = "fadein",
            type = "string",
            optional = true
        },
        {
            name = "fadeout",
            type = "string",
            optional = true
        },
    },
    onRun = function(_, arguments)
        local duration = tonumber(arguments[1]) or 0
        local colorName = (arguments[2] or "black"):lower()
        local fadeIn = tonumber(arguments[3]) or duration * 0.05
        local fadeOut = tonumber(arguments[4]) or duration * 0.05
        local isWhite = colorName == "white"
        for _, ply in player.Iterator() do
            if not ply:isStaffOnDuty() then
                net.Start("liaBlindFade")
                net.WriteBool(isWhite)
                net.WriteFloat(duration)
                net.WriteFloat(fadeIn)
                net.WriteFloat(fadeOut)
                net.Send(ply)
            end
        end
    end
})

lia.command.add("plygag", {
    adminOnly = true,
    desc = "Gag a player, blocking voice chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("gag", arguments[1], nil, nil, client) end
})

lia.command.add("plyungag", {
    adminOnly = true,
    desc = "Ungag a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ungag", arguments[1], nil, nil, client) end
})

lia.command.add("plymute", {
    adminOnly = true,
    desc = "Mute a player's voice chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("mute", arguments[1], nil, nil, client) end
})

lia.command.add("plyunmute", {
    adminOnly = true,
    desc = "Unmute a player's voice chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unmute", arguments[1], nil, nil, client) end
})

lia.command.add("plybring", {
    adminOnly = true,
    desc = "Teleport a player to you.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("bring", arguments[1], nil, nil, client) end
})

lia.command.add("plygoto", {
    adminOnly = true,
    desc = "Teleport yourself to a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("goto", arguments[1], nil, nil, client) end
})

lia.command.add("plyreturn", {
    adminOnly = true,
    desc = "Return a player to their previous position.",
    arguments = {
        {
            name = "name",
            type = "player",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("return", arguments[1] or client:Name(), nil, nil, client) end
})

lia.command.add("plyjail", {
    adminOnly = true,
    desc = "Jail a player by locking and freezing them.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("jail", arguments[1], nil, nil, client) end
})

lia.command.add("plyunjail", {
    adminOnly = true,
    desc = "Release a jailed player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("unjail", arguments[1], nil, nil, client) end
})

lia.command.add("plycloak", {
    adminOnly = true,
    desc = "Make a player invisible.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Cloak Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/status_offline.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("cloak", arguments[1], nil, nil, client) end
})

lia.command.add("plyuncloak", {
    adminOnly = true,
    desc = "Remove invisibility from a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Uncloak Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/status_online.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("uncloak", arguments[1], nil, nil, client) end
})

lia.command.add("plygod", {
    adminOnly = true,
    desc = "Enable god mode on a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Give God Mode",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/shield.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("god", arguments[1], nil, nil, client) end
})

lia.command.add("plyungod", {
    adminOnly = true,
    desc = "Disable a player's god mode.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Remove God Mode",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/shield_delete.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ungod", arguments[1], nil, nil, client) end
})

lia.command.add("plyignite", {
    adminOnly = true,
    desc = "Set a player on fire.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "duration",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("ignite", arguments[1], arguments[2], nil, client) end
})

lia.command.add("plyextinguish", {
    adminOnly = true,
    desc = "Extinguish the specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("extinguish", arguments[1], nil, nil, client) end
})

lia.command.add("plystrip", {
    adminOnly = true,
    desc = "Strip all weapons from a player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Strip Weapons",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/gun.png"
    },
    onRun = function(client, arguments) lia.admin.serverExecCommand("strip", arguments[1], nil, nil, client) end
})

lia.command.add("charunbanoffline", {
    superAdminOnly = true,
    desc = "Unban an offline character using their Char ID.",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyError("Invalid character ID.") end
        local result = sql.Query("SELECT id FROM lia_characters WHERE id = " .. charID .. " LIMIT 1")
        if not istable(result) or not result[1] then return client:notifyError("Character not found.") end
        lia.char.setCharDatabase(charID, "banned", 0)
        lia.char.setCharDatabase(charID, "charBanInfo", nil)
        client:notifySuccess(string.format("Offline character ID %s has been unbanned.", charID))
        lia.log.add(client, "charUnbanOffline", charID)
    end
})

lia.command.add("charbanoffline", {
    superAdminOnly = true,
    desc = "Ban an offline character using their Char ID.",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyError("Invalid character ID.") end
        local result = sql.Query("SELECT id FROM lia_characters WHERE id = " .. charID .. " LIMIT 1")
        if not istable(result) or not result[1] then return client:notifyError("Character not found.") end
        lia.char.setCharDatabase(charID, "banned", -1)
        lia.char.setCharDatabase(charID, "charBanInfo", {
            name = client:Nick(),
            steamID = client:SteamID(),
            rank = client:GetUserGroup()
        })

        for _, ply in player.Iterator() do
            if ply:getChar() and ply:getChar():getID() == charID then
                ply:Kick("You have been banned.")
                break
            end
        end

        client:notifySuccess(string.format("Offline character ID %s has been banned.", charID))
        lia.log.add(client, "charBanOffline", charID)
    end
})

lia.command.add("playglobalsound", {
    superAdminOnly = true,
    desc = "Play a global sound for all players.",
    arguments = {
        {
            name = "sound",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local sound = arguments[1]
        if not sound or sound == "" then
            client:notifyError("You must specify a sound to play.")
            return
        end

        for _, target in player.Iterator() do
            target:PlaySound(sound)
        end
    end
})

lia.command.add("plyspectate", {
    adminOnly = true,
    desc = "Spectate a player in third person.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Spectate Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/zoom.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target == client then
            client:notifyError("You cannot spectate yourself")
            return
        end

        if target.liaSpectating then
            client:notifyError("That player is already being spectated")
            return
        end

        client.returnPos = client:GetPos()
        client.returnAng = client:EyeAngles()
        client:Spectate(OBS_MODE_CHASE)
        client:SpectateEntity(target)
        client:GodEnable()
        client.liaSpectating = true
        client:notifySuccess(string.format("You are now spectating %s.", target:Nick()))
        target:notifyInfo(string.format("%s is now spectating you.", client:Nick()))
        lia.log.add(client, "plySpectate", target:Nick())
    end
})

lia.command.add("stopspectate", {
    adminOnly = true,
    desc = "Stop spectating and return to normal view.",
    onRun = function(client)
        if not client.liaSpectating then
            client:notifyError("You are not currently spectating anyone")
            return
        end

        client:UnSpectate()
        client:GodDisable()
        client.liaSpectating = false
        local returnPos = client.returnPos
        local returnAng = client.returnAng
        if returnPos then
            client:SetPos(returnPos)
            client.returnPos = nil
        end

        if returnAng then
            client:SetEyeAngles(returnAng)
            client.returnAng = nil
        end

        client:Give("weapon_physgun")
        client:Give("weapon_physcannon")
        client:Give("gmod_tool")
        client:notifySuccess("You have stopped spectating.")
        lia.log.add(client, "stopSpectate")
    end
})

lia.command.add("playsound", {
    superAdminOnly = true,
    desc = "Play the specified sound on a specific player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "sound",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local sound = arguments[2]
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not sound or sound == "" then
            client:notifyError("You must specify a sound path or name.")
            return
        end

        target:PlaySound(sound)
    end
})

lia.command.add("returntodeathpos", {
    adminOnly = true,
    desc = "Return to your last recorded death position.",
    onRun = function(client)
        if IsValid(client) and client:Alive() then
            local character = client:getChar()
            local oldPos = character and character:getData("deathPos")
            if oldPos then
                client:SetPos(oldPos)
                character:setData("deathPos", nil)
            else
                client:notifyError("No death position saved.")
            end
        else
            client:notifyWarning("Wait until you respawn.")
        end
    end
})

lia.command.add("roll", {
    adminOnly = false,
    desc = "Rolls a dice and displays the result.",
    onRun = function(client)
        local rollValue = math.random(0, 100)
        lia.chat.send(client, "roll", rollValue)
    end
})

lia.command.add("forcefallover", {
    adminOnly = true,
    desc = "Force another player to fall over (go into ragdoll).",
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
            client:notifyError("Target not found")
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
    desc = "Force another player to get up from ragdoll.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not IsValid(target:GetRagdollEntity()) then
            target:notifyError("You don't have a ragdoll to get up from!")
            return
        end

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
    desc = "Change your character's description.",
    arguments = {
        {
            name = "desc",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local desc = table.concat(arguments, " ")
        if not desc:find("%S") then return client:requestString("Change Name", "Enter the character's new name below.", function(text) lia.command.run(client, "chardesc", {text}) end, client:getChar() and client:getChar():getDesc() or "") end
        local trimmedDesc = string.Trim(desc)
        local descWithoutSpaces = string.gsub(trimmedDesc, "%s", "")
        local minLength = lia.config.get("MinDescLen", 16)
        if #descWithoutSpaces < minLength then
            client:notifyError(string.format("Description must be at least %s characters long.", minLength))
            return
        end

        local character = client:getChar()
        if character then character:setDesc(desc) end
        return "@descChanged"
    end
})

lia.command.add("chargetup", {
    adminOnly = false,
    desc = "Force yourself to get up from ragdoll (if possible).",
    onRun = function(client)
        if not IsValid(client:GetRagdollEntity()) then
            client:notifyError("You don't have a ragdoll to get up from!")
            return
        end

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
    desc = "Fall over (ragdoll) for a certain duration.",
    arguments = {
        {
            name = "time",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        if client.FallOverCooldown then
            client:notifyWarning("This Command Is In Cooldown!")
            return
        elseif client:IsFrozen() then
            client:notifyWarning("You cannot use this while frozen!")
            return
        elseif not client:Alive() then
            client:notifyError("You cannot use this while dead!")
            return
        elseif IsValid(client:GetVehicle()) then
            client:notifyWarning("You cannot use this as you are in a vehicle!")
            return
        elseif client:GetMoveType() == MOVETYPE_NOCLIP then
            client:notifyWarning("You cannot use this while in noclip!")
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

lia.command.add("togglelockcharacters", {
    superAdminOnly = true,
    desc = "Toggle whether players can swap characters.",
    onRun = function()
        local newVal = not GetGlobalBool("characterSwapLock", false)
        SetGlobalBool("characterSwapLock", newVal)
        if not newVal then
            return "Now the players will be able to change character"
        else
            return "Now the players won't be able to change character until the server is restarted or until you re-enable it"
        end
    end
})

lia.command.add("checkinventory", {
    adminOnly = true,
    desc = "Check another player's inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Inventory",
        Category = "Character Management",
        SubCategory = "Items",
        Icon = "icon16/box.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target == client then
            client:notifyError("This isn't meant for checking your own inventory.")
            return
        end

        local inventory = target:getChar():getInv()
        inventory:addAccessRule(function(_, action) return action == "transfer" end, 1)
        inventory:addAccessRule(function(_, action) return action == "repl" end, 1)
        inventory:sync(client)
        net.Start("liaOpenInvMenu")
        net.WriteEntity(target)
        net.WriteType(inventory:getID())
        net.Send(client)
    end
})

lia.command.add("flaggive", {
    adminOnly = true,
    desc = "Give the following flags to the player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "flags",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local flags = arguments[2]
        if not flags then
            local available = ""
            for k in SortedPairs(lia.flag.list) do
                if not target:hasFlags(k) then available = available .. k .. " " end
            end

            available = available:Trim()
            if available == "" then
                client:notifyInfo("No available flags to give.")
                return
            end
            return client:requestString("Give Flags", "Give the following flags to the player.", function(text) lia.command.run(client, "flaggive", {target:Name(), text}) end, available)
        end

        target:giveFlags(flags)
        client:notifySuccess(string.format("%s has given %s '%s' flags.", client:Name(), flags, target:Name()))
        lia.log.add(client, "flagGive", target:Name(), flags)
    end,
    alias = {"giveflag", "chargiveflag"}
})

lia.command.add("flaggiveall", {
    adminOnly = true,
    desc = "Give all possible flags to a character.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if not target:hasFlags(k) then target:giveFlags(k) end
        end

        client:notifySuccess("You gave this player all flags!")
        lia.log.add(client, "flagGiveAll", target:Name())
    end
})

lia.command.add("flagtakeall", {
    adminOnly = true,
    desc = "Remove all flags from a character.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not target:getChar() then
            client:notifyError("Invalid Target!")
            return
        end

        for k, _ in SortedPairs(lia.flag.list) do
            if target:hasFlags(k) then target:takeFlags(k) end
        end

        client:notifySuccess("You took this player's flags!")
        lia.log.add(client, "flagTakeAll", target:Name())
    end
})

lia.command.add("flagtake", {
    adminOnly = true,
    desc = "Remove the following flags from the player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "flags",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local flags = arguments[2]
        if not flags then
            local currentFlags = target:getFlags()
            return client:requestString("Take Flags", "Remove the following flags from the player.", function(text) lia.command.run(client, "flagtake", {target:Name(), text}) end, table.concat(currentFlags, ", "))
        end

        target:takeFlags(flags)
        client:notifySuccess(string.format("%s has taken '%s' flags from %s.", client:Name(), flags, target:Name()))
        lia.log.add(client, "flagTake", target:Name(), flags)
    end,
    alias = {"takeflag"}
})

lia.command.add("bringlostitems", {
    superAdminOnly = true,
    desc = "Bring lost items in a 500 radius to your position.",
    onRun = function(client)
        for _, v in ipairs(ents.FindInSphere(client:GetPos(), 500)) do
            if v:isItem() then v:SetPos(client:GetPos()) end
        end
    end
})

lia.command.add("charvoicetoggle", {
    adminOnly = true,
    desc = "Toggles voice chat ban for the specified character.",
    arguments = {
        {
            name = "name",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Toggle Voice",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/sound_mute.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target == client then
            client:notifyError("You cannot toggle mute on yourself.")
            return false
        end

        if target:getChar() then
            local isMuted = target:getLiliaData("liaMuted", false)
            target:setLiliaData("liaMuted", not isMuted)
            if isMuted then
                client:notifySuccess(string.format("%s has been unmuted for text chat.", target:Name()))
                target:notifyInfo("You have been unmuted for text chat by an admin.")
            else
                client:notifySuccess(string.format("%s has been muted for text chat.", target:Name()))
                target:notifyWarning("You have been muted for text chat by an admin.")
            end

            lia.log.add(client, "textToggle", target:Name(), isMuted and "Unmuted" or "Muted")
        else
            client:notifyError("The target does not have a valid character.")
        end
    end
})

lia.command.add("cleanitems", {
    superAdminOnly = true,
    desc = "Remove all item entities from the map.",
    onRun = function(client)
        local count = 0
        for _, v in ipairs(ents.FindByClass("lia_item")) do
            count = count + 1
            SafeRemoveEntity(v)
        end

        client:notifySuccess(string.format("You cleaned up %s: %s entities removed.", "Items", count))
    end
})

lia.command.add("cleanprops", {
    superAdminOnly = true,
    desc = "Remove all prop entities from the map.",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:isProp() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccess(string.format("You cleaned up %s: %s entities removed.", "Props", count))
    end
})

lia.command.add("resetmapprops", {
    superAdminOnly = true,
    desc = "Restore all map-created props by performing a map cleanup.",
    onRun = function(client)
        local started = SysTime()
        client:notifyInfo("Map cleanup started; map props will be restored shortly.")
        game.CleanUpMap(false, nil, function()
            if not IsValid(client) then return end
            local elapsed = math.Round((SysTime() - started) * 1000)
            client:notifySuccess(string.format("Map cleanup finished in %d ms; map props restored.", elapsed))
        end)
    end
})

lia.command.add("cleannpcs", {
    superAdminOnly = true,
    desc = "Remove all NPC entities from the map.",
    onRun = function(client)
        local count = 0
        for _, entity in ents.Iterator() do
            if IsValid(entity) and entity:IsNPC() then
                count = count + 1
                SafeRemoveEntity(entity)
            end
        end

        client:notifySuccess(string.format("You cleaned up %s: %s entities removed.", "NPCs", count))
    end
})

lia.command.add("charunban", {
    superAdminOnly = true,
    desc = "Unban a character by name or ID.",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if (client.liaNextSearch or 0) >= CurTime() then return "Searching for character..." end
        local queryArg = table.concat(arguments, " ")
        local charFound
        local id = tonumber(queryArg)
        if id then
            for _, v in pairs(lia.char.getAll()) do
                if v:getID() == id then
                    charFound = v
                    break
                end
            end
        else
            for _, v in pairs(lia.char.getAll()) do
                if lia.util.stringMatches(v:getName(), queryArg) then
                    charFound = v
                    break
                end
            end
        end

        if charFound then
            if charFound:isBanned() then
                charFound:setBanned(0)
                charFound:setData("permakilled", nil)
                charFound:setData("charBanInfo", nil)
                charFound:save()
                client:notifySuccess(string.format("%s has unbanned the character %s.", client:Name(), charFound:getName()))
                lia.log.add(client, "charUnban", charFound:getName(), charFound:getID())
            else
                return "This character isn't banned!"
            end
        end

        client.liaNextSearch = CurTime() + 15
        local sqlCondition = id and "id = " .. id or "name LIKE \"%" .. lia.db.escape(queryArg) .. "%\""
        lia.db.query("SELECT id, name FROM lia_characters WHERE " .. sqlCondition .. " LIMIT 1", function(data)
            if data and data[1] then
                local charID = tonumber(data[1].id)
                local banned = lia.char.getCharBanned(charID)
                client.liaNextSearch = 0
                if not banned or banned == 0 then
                    client:notifyInfo("This character isn't banned!")
                    return
                end

                lia.char.setCharDatabase(charID, "banned", 0)
                lia.char.setCharDatabase(charID, "charBanInfo", nil)
                client:notifySuccess(string.format("%s has unbanned the character %s.", client:Name(), data[1].name))
                lia.log.add(client, "charUnban", data[1].name, charID)
            end
        end)
    end
})

lia.command.add("clearinv", {
    superAdminOnly = true,
    desc = "Clear a player's entire inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Clear Inventory",
        Category = "Character Management",
        SubCategory = "Items",
        Icon = "icon16/bin.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:getChar():getInv():wipeItems()
        client:notifySuccess(string.format("You have cleared %s's inventory!", target:getChar():getName()))
    end
})

lia.command.add("charkick", {
    adminOnly = true,
    desc = "Kick the target's active character to the character menu.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Kick Character",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_delete.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            for _, targets in player.Iterator() do
                targets:notifyInfo(string.format("%s kicked character %s.", client:Name(), target:Name()))
            end

            character:kick()
            lia.log.add(client, "charKick", target:Name(), character:getID())
        else
            client:notifyError("No character found!")
        end
    end
})

lia.command.add("freezeallprops", {
    superAdminOnly = true,
    desc = "Freeze all props owned by a specific player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local count = 0
        local tbl = cleanup.GetList(target)[target:UniqueID()] or {}
        for _, propTable in pairs(tbl) do
            for _, ent in pairs(propTable) do
                if IsValid(ent) and IsValid(ent:GetPhysicsObject()) then
                    ent:GetPhysicsObject():EnableMotion(false)
                    count = count + 1
                end
            end
        end

        client:notifySuccess(string.format("You have frozen all of %s's Entities.", target:Name()))
        client:notifySuccess(string.format("Frozen %s Entities belonging to %s.", count, target:Name()))
    end
})

lia.command.add("charban", {
    superAdminOnly = true,
    desc = "Ban a character by name or ID.",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Ban Character",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_red.png"
    },
    onRun = function(client, arguments)
        local queryArg = table.concat(arguments, " ")
        local target
        local id = tonumber(queryArg)
        if id then
            for _, ply in player.Iterator() do
                if IsValid(ply) and ply:getChar() and ply:getChar():getID() == id then
                    target = ply
                    break
                end
            end
        else
            target = lia.util.findPlayer(client, arguments[1])
        end

        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            character:setBanned(-1)
            character:setData("charBanInfo", {
                name = client.steamName and client:steamName() or client:Name(),
                steamID = client:SteamID(),
                rank = client:GetUserGroup()
            })

            character:save()
            character:kick()
            client:notifySuccess(string.format("%s banned the character %s.", client:Name(), target:Name()))
            lia.log.add(client, "charBan", target:Name(), character:getID())
        else
            client:notifyError("No character found!")
        end
    end
})

lia.command.add("charwipe", {
    superAdminOnly = true,
    desc = "Completely wipe a character from the database by name or ID.",
    arguments = {
        {
            name = "nameOrNumberId",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Wipe Character",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_delete.png"
    },
    onRun = function(client, arguments)
        local queryArg = table.concat(arguments, " ")
        local target
        local id = tonumber(queryArg)
        if id then
            for _, ply in player.Iterator() do
                if IsValid(ply) and ply:getChar() and ply:getChar():getID() == id then
                    target = ply
                    break
                end
            end
        else
            target = lia.util.findPlayer(client, arguments[1])
        end

        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            local charID = character:getID()
            local charName = character:getName()
            character:kick()
            lia.char.delete(charID, target)
            if IsValid(target) and target.liaCharList then
                for i, charId in ipairs(target.liaCharList) do
                    if charId == charID then
                        table.remove(target.liaCharList, i)
                        break
                    end
                end

                hook.Run("SyncCharList", target)
            end

            client:notifySuccess(string.format("%s wiped the character %s from the database.", client:Name(), charName))
            lia.log.add(client, "charWipe", charName, charID)
        else
            client:notifyError("No character found!")
        end
    end
})

lia.command.add("charwipeoffline", {
    superAdminOnly = true,
    desc = "Completely wipe an offline character from the database using their Char ID.",
    arguments = {
        {
            name = "charId",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local charID = tonumber(arguments[1])
        if not charID then return client:notifyError("Invalid character ID.") end
        lia.db.query("SELECT name FROM lia_characters WHERE id = " .. charID, function(data)
            if not data or #data == 0 then
                client:notifyError("Character not found.")
                return
            end

            local charName = data[1].name
            for _, ply in player.Iterator() do
                if ply:getChar() and ply:getChar():getID() == charID then
                    ply:Kick("Your character has been wiped from the database.")
                    break
                end
            end

            lia.char.delete(charID)
            client:notifySuccess(string.format("Offline character ID %s has been wiped from the database.", charID))
            lia.log.add(client, "charWipeOffline", charName, charID)
        end)
    end
})

lia.command.add("checkmoney", {
    adminOnly = true,
    desc = "Check how much money the target player has.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Money",
        Category = "Character Management",
        SubCategory = "Items",
        Icon = "icon16/money.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local money = target:getChar():getMoney()
        client:notifyMoney(string.format("%s has %s", target:GetName(), lia.currency.get(money)))
    end
})

lia.command.add("listbodygroups", {
    adminOnly = true,
    desc = "List the available bodygroups for a target player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local bodygroups = {}
        for i = 0, target:GetNumBodyGroups() - 1 do
            if target:GetBodygroupCount(i) > 1 then
                table.insert(bodygroups, {
                    group = i,
                    name = target:GetBodygroupName(i),
                    range = "0-" .. target:GetBodygroupCount(i) - 1
                })
            end
        end

        if #bodygroups > 0 then
            lia.util.sendTableUI(client, string.format("Bodygroups for %s", target:Nick()), {
                {
                    name = "groupID",
                    field = "group"
                },
                {
                    name = "name",
                    field = "name"
                },
                {
                    name = "range",
                    field = "range"
                }
            }, bodygroups)
        else
            client:notifyInfo("No bodygroups available for this model.")
        end
    end
})

lia.command.add("charsetspeed", {
    adminOnly = true,
    desc = "Set a player's run speed.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "speed",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Speed",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/lightning.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local speed = tonumber(arguments[2]) or lia.config.get("WalkSpeed")
        target:SetRunSpeed(speed)
    end
})

lia.command.add("charsetmodel", {
    adminOnly = true,
    desc = "Set a player's model.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "model",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local oldModel = target:getChar():getModel()
        target:getChar():setModel(arguments[2] or oldModel)
        target:SetupHands()
        client:notifySuccess(string.format("%s changed %s's model to %s.", client:Name(), target:Name(), arguments[2] or oldModel))
        lia.log.add(client, "charsetmodel", target:Name(), arguments[2], oldModel)
    end
})

lia.command.add("chargiveitem", {
    superAdminOnly = true,
    desc = "Give an item to a player's inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "itemName",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Give Item",
        Category = "Character Management",
        SubCategory = "Items",
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local itemName = arguments[2]
        if not itemName or itemName == "" then
            client:notifyError("You must specify an item to give.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local uniqueID
        for _, v in SortedPairs(lia.item.list) do
            if lia.util.stringMatches(v.name, itemName) or lia.util.stringMatches(v.uniqueID, itemName) then
                uniqueID = v.uniqueID
                break
            end
        end

        if not uniqueID then
            client:notifyError("Sorry, the item that you requested does not exist.")
            return
        end

        local inv = target:getChar():getInv()
        local succ, err = inv:add(uniqueID)
        if succ then
            target:notifySuccess("Item created successfully.")
            if target ~= client then client:notifySuccess("Item created successfully.") end
            lia.log.add(client, "chargiveItem", lia.item.list[uniqueID] and lia.item.list[uniqueID].name or uniqueID, target, "Command")
        else
            target:notifyErrorLocalized(err or "unknownError")
        end
    end
})

lia.command.add("charsetdesc", {
    adminOnly = true,
    desc = "Set a player's character description.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "description",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Description",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/user_comment.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not target:getChar() then
            client:notifyError("No character found!")
            return
        end

        local desc = table.concat(arguments, " ", 2)
        if not desc:find("%S") then return client:requestString(string.format("Change %s's Description", target:Name()), "Enter new description", function(text) lia.command.run(client, "charsetdesc", {arguments[1], text}) end, target:getChar():getDesc()) end
        target:getChar():setDesc(desc)
        return string.format("%s has changed %s's character description.", client:Name(), target:Name())
    end
})

lia.command.add("charsetname", {
    adminOnly = true,
    desc = "Set a player's character name.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "newName",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Name",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/user_edit.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local newName = table.concat(arguments, " ", 2)
        if newName == "" then return client:requestString("Change Name", "Enter the character's new name below.", function(text) lia.command.run(client, "charsetname", {target:Name(), text}) end, target:Name()) end
        local oldName = target:getChar():getName()
        target:getChar():setName(newName:gsub("#", "#?"))
        client:notifySuccess(string.format("%s changed %s's name to %s.", client:Name(), oldName, newName))
    end
})

lia.command.add("charsetscale", {
    adminOnly = true,
    desc = "Set a player's model scale.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "scale",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Scale",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/arrow_out.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local scale = tonumber(arguments[2]) or 1
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:SetModelScale(scale, 0)
        client:notifySuccess(string.format("You changed %s's model scale to %s.", target:Name(), scale))
    end
})

lia.command.add("charsetjump", {
    adminOnly = true,
    desc = "Set a player's jump power.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "power",
            type = "string",
            optional = true
        },
    },
    AdminStick = {
        Name = "Set Character Jump Height",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/arrow_up.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local power = tonumber(arguments[2]) or 200
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:SetJumpPower(power)
        client:notifySuccess(string.format("You changed %s's jump power to %s.", target:Name(), power))
    end
})

lia.command.add("charsetbodygroup", {
    adminOnly = true,
    desc = "Set a specific bodygroup on a player's model.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "bodygroupName",
            type = "string"
        },
        {
            name = "value",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local name = arguments[1]
        local bodyGroup = arguments[2]
        local value = tonumber(arguments[3])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local index = target:FindBodygroupByName(bodyGroup)
        if index > -1 then
            if value and value < 1 then value = nil end
            local groups = target:getChar():getBodygroups()
            groups[index] = value
            target:getChar():setBodygroups(groups)
            target:SetBodygroup(index, value or 0)
            client:notifySuccess(string.format("%s changed %s's bodygroup \\", client:Name(), target:Name(), bodyGroup, value or 0))
        else
            client:notifyError("Invalid argument.")
        end
    end
})

lia.command.add("charsetskin", {
    adminOnly = true,
    desc = "Set a player's skin.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "skin",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Set Character Skin",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local name = arguments[1]
        local skin = tonumber(arguments[2])
        local target = lia.util.findPlayer(client, name)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not skin then
            client:notifyError("Invalid argument.")
            return
        end

        target:getChar():setSkin(skin)
        target:SetSkin(skin)
        client:notifySuccess(string.format("%s changed %s's skin to %s.", client:Name(), target:Name(), skin))
    end
})

lia.command.add("charsetmoney", {
    superAdminOnly = true,
    desc = "Set a player's money to a specific amount.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "amount",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local amount = tonumber(arguments[2])
        if not amount or amount < 0 then
            client:notifyError("Invalid argument.")
            return
        end

        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:getChar():setMoney(math.floor(amount))
        client:notifyMoney(string.format("You set %s's money to %s.", target:Name(), lia.currency.get(math.floor(amount))))
        lia.log.add(client, "charSetMoney", target:Name(), math.floor(amount))
        StaffAddTextShadowed(Color(34, 139, 34), "MONEY", Color(255, 255, 255), client:Name() .. " set money of " .. target:Name() .. " (Steam64ID: " .. target:SteamID64() .. ") to " .. lia.currency.get(math.floor(amount)))
    end
})

lia.command.add("charaddmoney", {
    superAdminOnly = true,
    desc = "Add a certain amount of money to a player's balance.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "amount",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local amount = tonumber(arguments[2])
        if not amount then
            client:notifyError("Invalid argument.")
            return
        end

        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        amount = math.Round(amount)
        local currentMoney = target:getChar():getMoney()
        target:getChar():setMoney(currentMoney + amount)
        client:notifyMoney(string.format("You gave %s an additional %s. Total: %s", target:Name(), lia.currency.get(amount), lia.currency.get(currentMoney + amount)))
        lia.log.add(client, "charAddMoney", target:Name(), amount, currentMoney + amount)
        StaffAddTextShadowed(Color(34, 139, 34), "MONEY", Color(255, 255, 255), client:Name() .. " gave " .. lia.currency.get(amount) .. " to " .. target:Name() .. " (Steam64ID: " .. target:SteamID64() .. "). New balance: " .. lia.currency.get(currentMoney + amount))
    end,
    alias = {"chargivemoney"}
})

lia.command.add("globalbotsay", {
    superAdminOnly = true,
    desc = "Force all bots on the server to say something.",
    arguments = {
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local message = table.concat(arguments, " ")
        if message == "" then
            client:notifyError("You must specify a message.")
            return
        end

        for _, bot in player.Iterator() do
            if bot:IsBot() then bot:Say(message) end
        end
    end
})

lia.command.add("botsay", {
    superAdminOnly = true,
    desc = "Force a specific bot to say something.",
    arguments = {
        {
            name = "botName",
            type = "string"
        },
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if #arguments < 2 then
            client:notifyError("You must specify a bot and a message.")
            return
        end

        local botName = arguments[1]
        local message = table.concat(arguments, " ", 2)
        local targetBot
        for _, bot in player.Iterator() do
            if bot:IsBot() and string.find(string.lower(bot:Nick()), string.lower(botName)) then
                targetBot = bot
                break
            end
        end

        if not targetBot then
            client:notifyError(string.format("No bot found with the name: %s", botName))
            return
        end

        targetBot:Say(message)
    end
})

lia.command.add("forcesay", {
    superAdminOnly = true,
    desc = "Force a player to say something in chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "message",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Force Say",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/comments.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local message = table.concat(arguments, " ", 2)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if message == "" then
            client:notifyError("You must specify a message.")
            return
        end

        target:Say(message)
        lia.log.add(client, "forceSay", target:Name(), message)
    end
})

lia.command.add("getmodel", {
    desc = "Get the model of the entity you are looking at.",
    onRun = function(client)
        local entity = client:getTracedEntity()
        if not IsValid(entity) then
            client:notifyError("No valid entity found in front of you.")
            return
        end

        local model = entity:GetModel()
        client:ChatPrint(model and string.format("The model is: %s", model) or "No model found.")
    end
})

lia.command.add("pm", {
    desc = "Sends a private message to a specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "message",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if not lia.config.get("AllowPMs") then
            client:notifyError("Private Messages are Disabled")
            return
        end

        local targetName = arguments[1]
        local message = table.concat(arguments, " ", 2)
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not message:find("%S") then
            client:notifyError("You must specify a message.")
            return
        end

        lia.chat.send(client, "pm", message, false, {client, target})
    end
})

lia.command.add("chargetmodel", {
    adminOnly = true,
    desc = "Get the model of a player's character.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Model",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/user_gray.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        client:ChatPrint(string.format("Character Model: %s", target:GetModel()))
    end
})

lia.command.add("checkallmoney", {
    superAdminOnly = true,
    desc = "Check every player's money balance.",
    onRun = function(client)
        for _, target in player.Iterator() do
            local char = target:getChar()
            if char then client:ChatPrint(string.format("%s has %s", target:GetName(), lia.currency.get(char:getMoney()))) end
        end
    end
})

lia.command.add("checkflags", {
    adminOnly = true,
    desc = "Check which flags a player has.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Flags",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/flag_yellow.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local flags = target:getFlags()
        if flags and #flags > 0 then
            client:ChatPrint(string.format("Character flags for %s: %s", target:Name(), table.concat(flags, ", ")))
        else
            client:notifyInfo(string.format("%s has no flags.", target:Name()))
        end
    end
})

lia.command.add("chargetname", {
    adminOnly = true,
    desc = "Get a player's character name.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Name",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/user.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        client:ChatPrint(string.format("Character Name: %s", target:getChar():getName()))
    end
})

lia.command.add("chargethealth", {
    adminOnly = true,
    desc = "Get a player's current health.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Health",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/heart.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        client:ChatPrint(string.format("Character Health: %s/%s", target:Health(), target:GetMaxHealth()))
    end
})

lia.command.add("chargetmoney", {
    adminOnly = true,
    desc = "Get how much money a player has.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Money",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/money.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local money = target:getChar():getMoney()
        client:ChatPrint(string.format("Character Money: %s", lia.currency.get(money)))
    end
})

lia.command.add("chargetinventory", {
    adminOnly = true,
    desc = "Get the contents of a player's inventory.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get Character Inventory",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/box.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local inventory = target:getChar():getInv()
        local items = inventory:getItems()
        if not items or table.Count(items) < 1 then
            client:notifyInfo("Character Inventory is empty.")
            return
        end

        local result = {}
        for _, item in pairs(items) do
            table.insert(result, item.name)
        end

        client:ChatPrint(string.format("Character Inventory: %s", table.concat(result, ", ")))
    end
})

lia.command.add("getallinfos", {
    adminOnly = true,
    desc = "Print all character data columns to the console.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Get All Informations",
        Category = "Character Management",
        SubCategory = "Information",
        Icon = "icon16/table.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local char = target:getChar()
        if not char then
            client:notifyError("No character found!")
            return
        end

        local data = lia.char.getCharData(char:getID())
        if not data then
            client:notifyError("No character found!")
            return
        end

        lia.admin(string.format("=== All information for %s ===", char:getName()))
        for column, value in pairs(data) do
            if istable(value) then
                lia.admin(column .. ":")
                PrintTable(value)
            else
                lia.admin(column .. " = " .. tostring(value))
            end
        end

        client:notifyInfo("Character information printed to console.")
    end
})

lia.command.add("dropmoney", {
    desc = "Drop money from your character's balance as a physical entity.",
    arguments = {
        {
            name = "amount",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local originalAmount = tonumber(arguments[1]) or 0
        local amount = math.floor(originalAmount)
        if originalAmount ~= amount and originalAmount > 0 then
            lia.log.add(client, "moneyDupeAttempt", "Attempted to drop " .. tostring(originalAmount) .. " money (floored to " .. amount .. ")")
            for _, admin in player.Iterator() do
                if admin:IsAdmin() then admin:notify(string.format("%s attempted to %s with decimal amount %s (floored to %s) - potential money duping!", "dropmoney", tostring(originalAmount), tostring(amount)), client:Name() or "default") end
            end
        end

        if not amount or amount <= 0 then
            client:notifyError("Invalid argument.")
            return
        end

        local character = client:getChar()
        if not character or not character:hasMoney(amount) then
            client:notifyError("You don't have enough money")
            return
        end

        local maxEntities = lia.config.get("MaxMoneyEntities", 3)
        local existingMoneyEntities = 0
        for _, entity in pairs(ents.FindByClass("lia_money")) do
            if entity.client == client then existingMoneyEntities = existingMoneyEntities + 1 end
        end

        if existingMoneyEntities >= maxEntities then
            client:notifyError(string.format("You have reached the maximum number of money entities (%d). Please wait for them to be picked up or removed.", maxEntities))
            return
        end

        character:takeMoney(amount)
        local money = lia.currency.spawn(client:getItemDropPos(), amount)
        if IsValid(money) then
            money.client = client
            money.charID = character:getID()
            client:notifyMoney(string.format("You dropped %s on the ground.", lia.currency.get(amount)))
            lia.log.add(client, "moneyDropped", amount)
        end

        client:doGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
    end
})

lia.command.add("exportprivileges", {
    adminOnly = true,
    desc = "Export all current privileges to a data file",
    onRun = function(client)
        local filename = "lilia_registered_privileges.json"
        if not SERVER then return end
        local seen = {}
        local list = {}
        local function add(id, name)
            if isstring(id) or isnumber(id) then return end
            id = tostring(id)
            if id == "" then return end
            if seen[id] then return end
            seen[id] = true
            table.insert(list, {
                id = id,
                name = name and tostring(name) or ""
            })
        end

        local function walk(v)
            if istable(v) then return end
            for k, val in pairs(v) do
                if isstring(k) and (isboolean(val) or istable(val)) then if k ~= "" and k ~= "None" then add(k) end end
                if istable(val) then
                    local id = val.id or val.ID or val.Id or val.uniqueID or val.UniqueID
                    local name = val.name or val.Name or val.title or val.Title
                    if id then add(id, name) end
                    if val.privilege or val.Privilege then add(val.privilege or val.Privilege, name) end
                    if val.privileges or val.Privileges then
                        for _, p in pairs(val.privileges or val.Privileges) do
                            if istable(p) then
                                add(p.id or p.ID or p, p.name or p.Name)
                            elseif isstring(p) or isnumber(p) then
                                add(p)
                            end
                        end
                    end

                    walk(val)
                elseif isstring(val) or isnumber(val) then
                    if isstring(k) and k:lower() == "id" then add(val) end
                end
            end
        end

        local function collect(t)
            if istable(t) == "table" then walk(t) end
        end

        local srcs = {}
        if lia then
            if lia.admin then
                table.insert(srcs, lia.admin.privileges)
                if isfunction(lia.admin.getPrivileges) == "function" then
                    local ok, r = pcall(lia.admin.getPrivileges, lia.admin)
                    if ok then table.insert(srcs, r) end
                end
            end

            if lia.admin then
                table.insert(srcs, lia.admin.privileges)
                if isfunction(lia.admin.getPrivileges) then
                    local ok, r = pcall(lia.admin.getPrivileges, lia.admin)
                    if ok then table.insert(srcs, r) end
                end
            end

            if lia.permission then
                table.insert(srcs, lia.permission.list)
                if isfunction(lia.permission.getAll) then
                    local ok, r = pcall(lia.permission.getAll, lia.permission)
                    if ok then table.insert(srcs, r) end
                end
            end

            if lia.permissions then table.insert(srcs, lia.permissions) end
            if lia.privileges then table.insert(srcs, lia.privileges) end
            if lia.command then table.insert(srcs, lia.command.stored or lia.command.list) end
            for _, p in pairs(lia.module.list) do
                if istable(p) == "table" then
                    table.insert(srcs, p.Privileges or p.privileges)
                    collect(p)
                end
            end
        end

        for _, s in pairs(srcs) do
            collect(s)
        end

        table.sort(list, function(a, b) return a.id < b.id end)
        local payload = {
            privileges = list
        }

        local jsonData = util.TableToJSON(payload, true)
        local wrote = false
        do
            local f = file.Open("gamemodes/Lilia/data/" .. filename, "wb", "GAME")
            if f then
                f:Write(jsonData)
                f:Close()
                wrote = true
            end
        end

        if not wrote then
            if not file.Exists("data", "DATA") then file.CreateDir("data") end
            wrote = file.Write("data/" .. filename, jsonData) and true or false
        end

        if wrote then
            client:notifySuccess(string.format("Privileges exported successfully to: %s", filename))
            MsgC(Color(83, 143, 239), "[Lilia] ", "[Admin] ")
            MsgC(Color(255, 153, 0), string.format("Privileges exported by %s to: %s", client:Nick(), filename), "\n")
            lia.log.add(client, "privilegesExported", filename)
        else
            client:notifyError("Failed to export privileges to expected locations")
            lia.error("Failed to export privileges to expected locations")
        end
    end
})

lia.command.add("fillwithbots", {
    superAdminOnly = true,
    desc = "Manage server bots - list, kick, or spawn bots.",
    alias = {"bots"},
    arguments = {
        {
            name = "amount",
            type = "number",
            optional = true
        }
    },
    onRun = function(client, arguments)
        if not SERVER then return end
        if timer.Exists("Bots_Add_Timer") then
            client:notifyError("Bots are already being added to the server.")
            return
        end

        local requestedAmount = arguments.amount
        if requestedAmount then
            requestedAmount = math.max(1, math.floor(requestedAmount))
            local maxPlayers = game.MaxPlayers()
            local availableSlots = maxPlayers - player.GetCount()
            if requestedAmount > availableSlots then
                client:notifyError(string.format("Cannot spawn %d bots. Only %d slots available (server limit: %d).", requestedAmount, availableSlots, maxPlayers))
                return
            end

            if requestedAmount <= 0 then
                client:notifyError("Invalid amount. Please specify a positive number of bots to spawn.")
                return
            end

            local botsSpawned = 0
            timer.Create("Bots_Add_Timer", 2, 0, function()
                if botsSpawned < requestedAmount and player.GetCount() < game.MaxPlayers() then
                    game.ConsoleCommand("bot\n")
                    botsSpawned = botsSpawned + 1
                else
                    timer.Remove("Bots_Add_Timer")
                end
            end)

            client:notifyInfo(string.format("Spawning %d bots...", requestedAmount))
        else
            timer.Create("Bots_Add_Timer", 2, 0, function()
                if player.GetCount() < game.MaxPlayers() then
                    game.ConsoleCommand("bot\n")
                else
                    timer.Remove("Bots_Add_Timer")
                end
            end)

            client:notifyInfo("Filling server with bots...")
        end
    end
})

lia.command.add("spawnbots", {
    superAdminOnly = true,
    desc = "Spawn a specific number of bots around your position.",
    arguments = {
        {
            name = "amount",
            type = "number"
        }
    },
    onRun = function(client, arguments)
        if not SERVER then return end
        local requestedAmount = math.max(1, math.floor(arguments.amount or 1))
        local maxPlayers = game.MaxPlayers()
        local availableSlots = maxPlayers - player.GetCount()
        if requestedAmount > availableSlots then
            client:notifyError(string.format("Cannot spawn %d bots. Only %d slots available (server limit: %d).", requestedAmount, availableSlots, maxPlayers))
            return
        end

        if requestedAmount <= 0 then
            client:notifyError("Invalid amount. Please specify a positive number of bots to spawn.")
            return
        end

        local botsSpawned = 0
        client:notifyInfo(string.format("Spawning %d bots...", requestedAmount))
        for i = 1, requestedAmount do
            timer.Simple((i - 1) * 0.5, function()
                if not IsValid(client) then return end
                game.ConsoleCommand("bot\n")
                botsSpawned = botsSpawned + 1
            end)
        end

        timer.Simple(requestedAmount * 0.5 + 2, function() if IsValid(client) then client:notifySuccess(string.format("Successfully spawned %d bots!", botsSpawned)) end end)
    end
})

lia.command.add("bot", {
    superAdminOnly = true,
    desc = "Spawn a bot and bring it to your location",
    onRun = function(client)
        if not SERVER then return end
        local maxPlayers = game.MaxPlayers()
        if player.GetCount() >= maxPlayers then
            client:notifyError(string.format("Cannot spawn %d bots. Only %d slots available (server limit: %d).", 1, 0, maxPlayers))
            return
        end

        client:notifyInfo(string.format("Spawning %d bots...", 1))
        game.ConsoleCommand("bot\n")
        timer.Simple(0.5, function()
            if not IsValid(client) then return end
            local bots = {}
            for _, ply in player.Iterator() do
                if ply:IsBot() then table.insert(bots, ply) end
            end

            table.sort(bots, function(a, b) return a:UserID() > b:UserID() end)
            local bot = bots[1]
            if IsValid(bot) then
                bot:SetPos(client:GetPos() + client:GetForward() * 50)
                local botName = bot:Name()
                if botName == "" then botName = "Bot" .. bot:UserID() end
                client:notifySuccess(string.format("Bot '%s' spawned and brought to your location!", botName))
            else
                client:notifyError("Failed to spawn bot.")
            end
        end)
    end
})

lia.command.add("botspeak", {
    superAdminOnly = true,
    desc = "Make all bots say a specified number of random phrases.",
    arguments = {
        {
            name = "phrases",
            type = "number",
            optional = true,
            default = 50
        }
    },
    onRun = function(client, arguments)
        if not SERVER then return end
        local phrasesPerBot = math.Clamp(arguments.phrases or 50, 1, 200)
        local cooldown = 1
        local bots = {}
        for _, ent in ents.Iterator() do
            if ent:IsNPC() or ent:IsNextBot() or (ent:IsPlayer() and ent:IsBot()) then table.insert(bots, ent) end
        end

        if #bots == 0 then
            client:notifyError("No bots found on the server.")
            return
        end

        client:notifyInfo(string.format("Found %d bots. Starting phrase sequence with %d phrases per bot...", #bots, phrasesPerBot))
        local randomPhrases = {"Hello there!", "What's going on?", "I need help!", "Over here!", "Watch out!", "Come on!", "Let's go!", "This way!", "Behind you!", "Enemy spotted!", "Clear!", "Move up!", "Hold position!", "Cover me!", "Reloading!", "Taking fire!", "Need backup!", "All clear!", "Contact!", "Engaging!", "Fall back!", "Push forward!", "Hold the line!", "Secure the area!", "Enemy down!", "Got one!", "Nice shot!", "Good work!", "Keep moving!", "Stay alert!"}
        local phraseCount = {}
        for _, bot in ipairs(bots) do
            phraseCount[bot] = 0
        end

        local function makeBotSpeak(bot)
            if not IsValid(bot) then return end
            if phraseCount[bot] < phrasesPerBot then
                local randomPhrase = randomPhrases[math.random(#randomPhrases)]
                bot:Say(randomPhrase)
                phraseCount[bot] = phraseCount[bot] + 1
                if phraseCount[bot] < phrasesPerBot then
                    timer.Simple(cooldown, function() if IsValid(bot) then makeBotSpeak(bot) end end)
                else
                    client:notifySuccess(string.format("Bot %s finished all %d phrases", bot:GetName() or tostring(bot), phrasesPerBot))
                end
            end
        end

        for _, bot in ipairs(bots) do
            makeBotSpeak(bot)
        end

        timer.Simple((phrasesPerBot * cooldown) + 5, function()
            local totalPhrases = 0
            for _, count in pairs(phraseCount) do
                totalPhrases = totalPhrases + count
            end

            client:notifySuccess(string.format("All bots finished! Total phrases said: %d", totalPhrases))
        end)
    end
})

lia.command.add("charsetattrib", {
    superAdminOnly = true,
    desc = "Set Attributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "attribute",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.attribs.list) do
                    options[L(v.name)] = k
                end
                return options
            end
        },
        {
            name = "level",
            type = "number"
        }
    },
    AdminStick = {
        Name = "Set Attributes",
        Category = "Character Management",
        SubCategory = "Properties",
        Icon = "icon16/wrench.png"
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyError("No attributes are currently registered in the system.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        local attribName = arguments[2]
        local attribNumber = tonumber(arguments[3])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        lia.log.add(client, "attribCheck", target:Name())
        local character = target:getChar()
        if character then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(L(v.name), attribName) or lia.util.stringMatches(k, attribName) then
                    character:setAttrib(k, math.abs(attribNumber))
                    client:notifySuccess(string.format("You set %s's %s to %s.", target:Name(), L(v.name), math.abs(attribNumber)))
                    lia.log.add(client, "attribSet", target:Name(), k, math.abs(attribNumber))
                    return
                end
            end
        end
    end
})

lia.command.add("checkattributes", {
    adminOnly = true,
    desc = "Check Attributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Check Attributes",
        Category = "Character Management",
        SubCategory = "Properties",
        Icon = "icon16/zoom.png"
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyError("No attributes are currently registered in the system.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local attributesData = {}
        for attrKey, attrData in SortedPairsByMemberValue(lia.attribs.list, "name") do
            local currentValue = target:getChar():getAttrib(attrKey, 0) or 0
            local maxValue = hook.Run("GetAttributeMax", target, attrKey) or 100
            local progress = math.Round(currentValue / maxValue * 100, 1)
            table.insert(attributesData, {
                charID = attrData.name,
                name = L(attrData.name),
                current = currentValue,
                max = maxValue,
                progress = progress .. "%"
            })
        end

        lia.util.sendTableUI(client, "characterAttributes", {
            {
                name = "attributeName",
                field = "name"
            },
            {
                name = "currentValue",
                field = "current"
            },
            {
                name = "maxValue",
                field = "max"
            },
            {
                name = "progress",
                field = "progress"
            }
        }, attributesData, {
            {
                name = "changeAttribute",
                ExtraFields = {
                    ["Amount"] = "text",
                    ["Mode"] = {"Add", "set"}
                },
                net = "ChangeAttribute"
            }
        }, client:getChar():getID())
    end
})

lia.command.add("staffdiscord", {
    desc = "Sets your staff Discord username.",
    arguments = {
        {
            name = "discord",
            type = "string"
        }
    },
    onRun = function(client, arguments)
        local discord = arguments[1]
        local character = client:getChar()
        if not character or character:getFaction() ~= FACTION_STAFF then
            client:notifyError("No staff character found. Create one in the staff faction.")
            return
        end

        client:setLiliaData("staffDiscord", discord)
        local description = string.format("Staff Character - Discord: %s, SteamID: %s", discord, client:SteamID())
        character:setDesc(description)
        client:notifySuccess("Staff character description updated!")
    end
})

lia.command.add("trunk", {
    adminOnly = false,
    desc = "Open the vehicle trunk you're looking at to access its storage inventory.",
    onRun = function(client)
        local entity = client:getTracedEntity()
        local maxDistance = 128
        local openTime = 0.7
        if not IsValid(entity) then
            client:notifyError("You're not looking at any vehicle!")
            return
        end

        if hook.Run("IsSuitableForTrunk", entity) == false then
            client:notifyError("You're not looking at any vehicle!")
            return
        end

        if client:GetPos():Distance(entity:GetPos()) > maxDistance then
            client:notifyError("You're too far to open the trunk!")
            return
        end

        client.liaStorageEntity = entity
        client:setAction("Opening...", openTime, function()
            if not IsValid(entity) then
                client.liaStorageEntity = nil
                return
            end

            if client:GetPos():Distance(entity:GetPos()) > maxDistance then
                client.liaStorageEntity = nil
                return
            end

            entity.receivers = entity.receivers or {}
            entity.receivers[client] = true
            local invID = entity:getNetVar("inv")
            local inv = invID and lia.inventory.instances[invID]
            local function openStorage(storageInv)
                if not storageInv then
                    client:notifyError("Player has no inventory")
                    client.liaStorageEntity = nil
                    return
                end

                storageInv:sync(client)
                net.Start("liaStorageOpen")
                net.WriteBool(true)
                net.WriteEntity(entity)
                net.Send(client)
                entity:EmitSound("items/ammocrate_open.wav")
            end

            if inv then
                openStorage(inv)
            else
                lia.module.get("storage"):InitializeStorage(entity):next(openStorage, function(err)
                    client:notifyError(string.format("Unable to create storage entity for %s\\n%s", entity:GetClass(), err))
                    client.liaStorageEntity = nil
                end)
            end
        end)
    end
})

lia.command.add("restockvendor", {
    superAdminOnly = true,
    desc = "Restocks all items for the vendor you are looking at to their default quantities.",
    AdminStick = {
        Name = "restockVendorStickName",
        TargetClass = "lia_vendor",
        Icon = "icon16/box.png"
    },
    onRun = function(client)
        local target = client:getTracedEntity()
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if target:GetClass() == "lia_vendor" then
            for id, itemData in pairs(target.items) do
                if itemData[2] and itemData[4] then target.items[id][2] = itemData[4] end
            end

            client:notifySuccess("The vendor has been restocked.")
            lia.log.add(client, "restockvendor", target)
        else
            client:notifyError("You are not looking at a valid vendor.")
        end
    end
})

lia.command.add("restockallvendors", {
    superAdminOnly = true,
    desc = "Restocks all items on every vendor on the map to their default quantities.",
    onRun = function(client)
        local count = 0
        for _, vendor in ipairs(ents.FindByClass("lia_vendor")) do
            for id, itemData in pairs(vendor.items) do
                if itemData[2] and itemData[4] then vendor.items[id][2] = itemData[4] end
            end

            count = count + 1
            lia.log.add(client, "restockvendor", vendor)
        end

        client:notifySuccess(string.format("All vendors have been restocked. Total vendors restocked: %s.", count))
        lia.log.add(client, "restockallvendors", count)
    end
})

lia.command.add("deletevendorpreset", {
    adminOnly = true,
    desc = "deleteVendorPresetDesc",
    arguments = {
        {
            name = "presetName",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        if not client:hasPrivilege("canCreateVendorPresets") then
            client:notifyError("No Permission")
            return
        end

        local presetName = arguments[1]
        if not presetName or presetName:Trim() == "" then
            client:notifyError("Preset name is required")
            return
        end

        presetName = presetName:Trim():lower()
        if not lia.vendor.presets[presetName] then
            client:notifyError(string.format("Vendor preset '%s' not found.", presetName))
            return
        end

        lia.vendor.presets[presetName] = nil
        if SERVER then
            lia.db.delete("vendor_presets", "name = " .. lia.db.convertDataType(presetName))
            net.Start("liaVendorSyncPresets")
            net.WriteTable(lia.vendor.presets)
            net.Broadcast()
        end

        client:notifySuccess(string.format("Vendor preset '%s' has been deleted.", presetName))
        lia.log.add(client, "deletevendorpreset", presetName)
    end
})

lia.command.add("listvendorpresets", {
    adminOnly = true,
    desc = "listVendorPresetsDesc",
    onRun = function(client)
        if not client:hasPrivilege("canCreateVendorPresets") then
            client:notifyError("No Permission")
            return
        end

        local presets = {}
        for name in pairs(lia.vendor.presets or {}) do
            presets[#presets + 1] = name
        end

        if #presets == 0 then
            client:notifyInfo("No vendor presets found.")
        else
            table.sort(presets)
            client:notifyInfo(string.format("Available presets: %s", table.concat(presets, ", ")))
        end
    end
})

lia.command.add("charaddattrib", {
    superAdminOnly = true,
    desc = "Add Attributes",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "attribute",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.attribs.list) do
                    options[L(v.name)] = k
                end
                return options
            end
        },
        {
            name = "level",
            type = "number"
        }
    },
    AdminStick = {
        Name = "Add Attributes",
        Category = "Character Management",
        SubCategory = "Properties",
        Icon = "icon16/add.png"
    },
    onRun = function(client, arguments)
        if table.IsEmpty(lia.attribs.list) then
            client:notifyError("No attributes are currently registered in the system.")
            return
        end

        local target = lia.util.findPlayer(client, arguments[1])
        local attribName = arguments[2]
        local attribNumber = tonumber(arguments[3])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local character = target:getChar()
        if character then
            for k, v in pairs(lia.attribs.list) do
                if lia.util.stringMatches(L(v.name), attribName) or lia.util.stringMatches(k, attribName) then
                    character:updateAttrib(k, math.abs(attribNumber))
                    client:notifySuccess(string.format("You added %s's %s by %s.", target:Name(), L(v.name), math.abs(attribNumber)))
                    lia.log.add(client, "attribAdd", target:Name(), k, math.abs(attribNumber))
                    return
                end
            end
        end
    end
})

lia.command.add("banooc", {
    adminOnly = true,
    desc = "Bans the specified player from using out-of-character chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Ban OOC",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/sound_mute.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:setLiliaData("oocBanned", true)
        client:notifySuccess(string.format("%s has been banned from OOC.", target:Name()))
        lia.log.add(client, "banOOC", target:Name(), target:SteamID())
    end
})

lia.command.add("unbanooc", {
    adminOnly = true,
    desc = "Unbans the specified player from out-of-character chat.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Unban OOC",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/sound.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        target:setLiliaData("oocBanned", nil)
        client:notifySuccess(string.format("%s has been unbanned from OOC.", target:Name()))
        lia.log.add(client, "unbanOOC", target:Name(), target:SteamID())
    end
})

lia.command.add("clearchat", {
    adminOnly = true,
    desc = "Clears chat for all players.",
    onRun = function(client)
        net.Start("liaRegenChat")
        net.Broadcast()
        lia.log.add(client, "clearChat")
    end
})

lia.command.add("doorsell", {
    desc = "Sell a door you own and receive a refund based on the door's price.",
    adminOnly = false,
    AdminStick = {
        Name = "Sell Door",
        Category = "Door Management",
        SubCategory = "Actions",
        TargetClass = "door",
        Icon = "icon16/money.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                if client == door:GetDTEntity(0) then
                    local price = math.Round((doorData.price or 0) * lia.config.get("DoorSellRatio", 0.5))
                    door:removeDoorAccessData()
                    client:getChar():giveMoney(price)
                    client:notifyMoney(string.format("You have sold this door for %s.", lia.currency.get(price)))
                    hook.Run("OnPlayerPurchaseDoor", client, door, false)
                    lia.log.add(client, "doorsell", price)
                else
                    client:notifyError("You do not own this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("admindoorsell", {
    desc = "Admin command to sell a door on behalf of its owner and refund the owner.",
    adminOnly = true,
    AdminStick = {
        Name = "Admin Sell Door",
        Category = "Door Management",
        SubCategory = "Actions",
        TargetClass = "door",
        Icon = "icon16/money_delete.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local owner = door:GetDTEntity(0)
                if IsValid(owner) and owner:IsPlayer() then
                    local price = math.Round((doorData.price or 0) * lia.config.get("DoorSellRatio", 0.5))
                    door:removeDoorAccessData()
                    owner:getChar():giveMoney(price)
                    owner:notifyMoney(string.format("You have sold this door for %s.", lia.currency.get(price)))
                    client:notifyMoney(string.format("You have sold this door for %s.", lia.currency.get(price)))
                    hook.Run("OnPlayerPurchaseDoor", owner, door, false)
                    lia.log.add(client, "admindoorsell", owner:Name(), price)
                else
                    client:notifyError("You do not own this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortogglelock", {
    desc = "Toggle a door's lock state between locked and unlocked.",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Lock",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/lock.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local currentLockState = door:GetInternalVariable("m_bLocked")
                local toggleState = not currentLockState
                if toggleState then
                    door:Fire("lock")
                    door:EmitSound("doors/door_latch3.wav")
                    doorData.locked = true
                    lia.doors.setCachedData(door, doorData)
                    client:notifyInfo(string.format("The door has been %s.", ("Locked"):lower()))
                    lia.log.add(client, "toggleLock", door, "Locked")
                else
                    door:Fire("unlock")
                    door:EmitSound("doors/door_latch1.wav")
                    doorData.locked = false
                    lia.doors.setCachedData(door, doorData)
                    client:notifyInfo(string.format("The door has been %s.", "unlocked"))
                    lia.log.add(client, "toggleLock", door, "unlocked")
                end

                local partner = door:getDoorPartner()
                if IsValid(partner) then
                    local partnerData = lia.doors.getData(partner)
                    if toggleState then
                        partner:Fire("lock")
                        partnerData.locked = true
                        lia.doors.setCachedData(partner, partnerData)
                    else
                        partner:Fire("unlock")
                        partnerData.locked = false
                        lia.doors.setCachedData(partner, partnerData)
                    end
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorbuy", {
    desc = "Purchase a door if it is available and you can afford it.",
    adminOnly = false,
    AdminStick = {
        Name = "Buy Door",
        Category = "Door Management",
        SubCategory = "Actions",
        TargetClass = "door",
        Icon = "icon16/money_add.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local factions = doorData.factions
                local classes = doorData.classes
                if doorData.noSell or (factions and #factions > 0) or (classes and #classes > 0) then return client:notifyError("You are not allowed to own this door.") end
                if IsValid(door:GetDTEntity(0)) then
                    client:notifyInfo(string.format("This door is owned by %s.", door:GetDTEntity(0):Name()))
                    return false
                end

                local price = doorData.price or 0
                if client:getChar():hasMoney(price) then
                    door:SetDTEntity(0, client)
                    door.liaAccess = {
                        [client] = DOOR_OWNER
                    }

                    client:getChar():takeMoney(price)
                    client:notifySuccess(string.format("You have purchased this door for %s.", lia.currency.get(price)))
                    hook.Run("OnPlayerPurchaseDoor", client, door, true)
                    lia.log.add(client, "buydoor", price)
                else
                    client:notifyError("You cannot afford this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortoggleownable", {
    desc = "Toggle whether a door can be owned by players.",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Ownable",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/pencil.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            lia.log.add(client, "doorToggleOwnable", door)
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local factions = doorData.factions or {}
                local classes = doorData.classes or {}
                local hasFactions = factions and #factions > 0
                local hasClasses = classes and #classes > 0
                local isUnownable = doorData.noSell or false
                local newState = not isUnownable
                if newState and (hasFactions or hasClasses) then
                    client:notifyError("This door cannot be owned.")
                    return false
                end

                doorData.noSell = newState and true or nil
                lia.doors.setData(door, doorData)
                lia.log.add(client, "doorToggleOwnable", door, newState)
                hook.Run("DoorOwnableToggled", client, door, newState)
                client:notifySuccessLocalized(newState and "doorMadeUnownable" or "doorMadeOwnable")
                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorresetdata", {
    desc = "Reset door data to default settings.",
    adminOnly = true,
    AdminStick = {
        Name = "Reset Door Data",
        Category = "Door Management",
        SubCategory = "Actions",
        TargetClass = "door",
        Icon = "icon16/arrow_refresh.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            lia.log.add(client, "doorResetData", door)
            local doorData = {
                disabled = nil,
                noSell = nil,
                hidden = nil,
                classes = nil,
                factions = {},
                name = nil,
                price = 0,
                locked = false
            }

            lia.doors.setData(door, doorData)
            client:notifySuccess("The door data has been reset.")
            lia.module.get("doors"):SaveData()
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortoggleenabled", {
    desc = "Toggle door enabled state (active/inactive).",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Enabled",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/stop.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            local isDisabled = doorData.disabled or false
            local newState = not isDisabled
            doorData.disabled = newState and true or nil
            lia.doors.setData(door, doorData)
            lia.log.add(client, newState and "doorDisable" or "doorEnable", door)
            hook.Run("DoorEnabledToggled", client, door, newState)
            client:notifySuccessLocalized(newState and "doorSetDisabled" or "doorSetNotDisabled")
            lia.module.get("doors").list["doors"]:SaveData()
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doortogglehidden", {
    desc = "Toggle the hidden state of a door.",
    adminOnly = true,
    AdminStick = {
        Name = "Toggle Door Hidden",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/eye.png"
    },
    onRun = function(client)
        local entity = client:GetEyeTrace().Entity
        if IsValid(entity) and entity:isDoor() then
            local doorData = lia.doors.getData(entity)
            local currentState = doorData.hidden or false
            local newState = not currentState
            doorData.hidden = newState
            lia.doors.setData(entity, doorData)
            lia.log.add(client, "doorSetHidden", entity, newState)
            hook.Run("DoorHiddenToggled", client, entity, newState)
            client:notifySuccessLocalized(newState and "doorSetHidden" or "doorSetNotHidden")
            lia.module.get("doors"):SaveData()
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsetprice", {
    desc = "Set the price for a door.",
    arguments = {
        {
            name = "price",
            type = "string"
        },
    },
    adminOnly = true,
    AdminStick = {
        Name = "Set Door Price",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/money.png"
    },
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                if not arguments[1] or not tonumber(arguments[1]) then return client:notifyError("The specified class is not valid.") end
                local price = math.Clamp(math.floor(tonumber(arguments[1])), 0, 1000000)
                doorData.price = price
                lia.doors.setData(door, doorData)
                lia.log.add(client, "doorSetPrice", door, price)
                hook.Run("DoorPriceSet", client, door, price)
                client:notifySuccess(string.format("You have set this door's price to %s.", lia.currency.get(price)))
                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsettitle", {
    desc = "Set the title for a door.",
    arguments = {
        {
            name = "title",
            type = "string"
        },
    },
    adminOnly = true,
    AdminStick = {
        Name = "Set Door Title",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/textfield.png"
    },
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local name = table.concat(arguments, " ")
                if not name:find("%S") then return client:notifyError("The specified class is not valid.") end
                if door:checkDoorAccess(client, DOOR_TENANT) or client:isStaff() then
                    doorData.name = name
                    lia.doors.setData(door, doorData)
                    hook.Run("DoorTitleSet", client, door, name)
                    lia.log.add(client, "doorSetTitle", door, name)
                    client:notifySuccess(string.format("Door title set to '%s'.", name))
                else
                    client:notifyError("You do not own this door.")
                end
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("savedoors", {
    desc = "Save door data persistently.",
    adminOnly = true,
    AdminStick = {
        Name = "Save Doors",
        Category = "Door Management",
        SubCategory = "Actions",
        TargetClass = "door",
        Icon = "icon16/disk.png"
    },
    onRun = function(client)
        lia.module.get("doors"):SaveData()
        lia.log.add(client, "doorSaveData")
        client:notifySuccess("Saved Doors!")
    end
})

lia.command.add("doorinfo", {
    desc = "Display information about the targeted door.",
    adminOnly = true,
    AdminStick = {
        Name = "Get Door Information",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/information.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            local disabled = doorData.disabled or false
            local price = doorData.price or 0
            local noSell = doorData.noSell or false
            local factions = doorData.factions or {}
            local factionNames = {}
            for _, id in ipairs(factions) do
                local info = lia.faction.get(id)
                if info then table.insert(factionNames, info.name) end
            end

            local classes = doorData.classes or {}
            local classNames = {}
            for _, uid in ipairs(classes) do
                local idx = lia.class.retrieveClass(uid)
                local info = lia.class.list[idx]
                if info then table.insert(classNames, info.name) end
            end

            local hidden = doorData.hidden or false
            local locked = doorData.locked or false
            local infoData = {
                {
                    property = "Disabled",
                    value = tostring(disabled)
                },
                {
                    property = "Name",
                    value = tostring(doorData.name or "Unowned Door")
                },
                {
                    property = "Price",
                    value = lia.currency.get(price)
                },
                {
                    property = "No Sell",
                    value = tostring(noSell)
                },
                {
                    property = "Factions",
                    value = tostring(not table.IsEmpty(factionNames) and table.concat(factionNames, ", ") or "None")
                },
                {
                    property = "Classes",
                    value = tostring(not table.IsEmpty(classNames) and table.concat(classNames, ", ") or "None")
                },
                {
                    property = "Hidden",
                    value = tostring(hidden)
                },
                {
                    property = "Locked",
                    value = tostring(locked)
                }
            }

            lia.util.sendTableUI(client, "Door Information", {
                {
                    name = "doorInfoProperty",
                    field = "property"
                },
                {
                    name = "doorInfoValue",
                    field = "value"
                }
            }, infoData)
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsampledata", {
    desc = "Add sample information to a door using common door variables.",
    adminOnly = true,
    AdminStick = {
        Name = "Add Sample Data",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/add.png"
    },
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            local sampleData = {
                name = "Sample Door " .. (door:MapCreationID() or "Unknown"),
                price = 1000,
                locked = false,
                disabled = false,
                hidden = false,
                noSell = false,
                factions = {"citizen"},
                classes = {"citizen"}
            }

            for key, value in pairs(sampleData) do
                doorData[key] = value
            end

            lia.doors.setData(door, doorData)
            client:notify("Door sample data applied successfully!", "default" or "default")
            lia.log.add(client, "doorSampleData", door)
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("dooraddfaction", {
    desc = "Add a faction restriction to a door, allowing only specific factions to access it.",
    arguments = {
        {
            name = "faction",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[1]
                local faction
                if input then
                    local factionIndex = tonumber(input)
                    if factionIndex then
                        faction = lia.faction.indices[factionIndex]
                        if not faction then
                            client:notifyError("The specified faction is not valid.")
                            return
                        end
                    else
                        for k, v in pairs(lia.faction.teams) do
                            if lia.util.stringMatches(k, input) or lia.util.stringMatches(v.name, input) then
                                faction = v
                                break
                            end
                        end
                    end
                end

                if faction then
                    local facs = doorData.factions or {}
                    if not table.HasValue(facs, faction.uniqueID) then facs[#facs + 1] = faction.uniqueID end
                    doorData.factions = facs
                    door.liaFactions = facs
                    doorData.noSell = true
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorSetFaction", door, faction.name)
                    client:notifySuccess(string.format("This door now belongs to the '%s' faction.", faction.name))
                elseif arguments[1] then
                    client:notifyError("The specified faction is not valid.")
                else
                    doorData.factions = {}
                    door.liaFactions = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, "all")
                    client:notifySuccess("This door no longer belongs to any faction.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorremovefaction", {
    desc = "Remove a faction restriction from a door, or clear all restrictions.",
    arguments = {
        {
            name = "faction",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[1]
                local faction
                if input then
                    local factionIndex = tonumber(input)
                    if factionIndex then
                        faction = lia.faction.indices[factionIndex]
                        if not faction then
                            client:notifyError("The specified faction is not valid.")
                            return
                        end
                    else
                        for k, v in pairs(lia.faction.teams) do
                            if lia.util.stringMatches(k, input) or lia.util.stringMatches(v.name, input) then
                                faction = v
                                break
                            end
                        end
                    end
                end

                if faction then
                    local facs = doorData.factions or {}
                    table.RemoveByValue(facs, faction.uniqueID)
                    doorData.factions = facs
                    door.liaFactions = facs
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, faction.name)
                    client:notifySuccess(string.format("This door no longer belongs to the '%s' faction.", faction.name))
                elseif arguments[1] then
                    client:notifyError("The specified faction is not valid.")
                else
                    doorData.factions = {}
                    door.liaFactions = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveFaction", door, "all")
                    client:notifySuccess("This door no longer belongs to any faction.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("doorsetclass", {
    desc = "Set a class (job) restriction for a door.",
    arguments = {
        {
            name = "class",
            type = "string"
        }
    },
    adminOnly = true,
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[1]
                local class, classData
                if input then
                    local classIndex = tonumber(input)
                    if classIndex then
                        classData = lia.class.list[classIndex]
                        if classData then
                            class = classIndex
                        else
                            client:notifyError("The specified class is not valid.")
                            return
                        end
                    else
                        local id = lia.class.retrieveClass(input)
                        if id then
                            class, classData = id, lia.class.list[id]
                        else
                            for k, v in pairs(lia.class.list) do
                                if lia.util.stringMatches(v.name, input) or lia.util.stringMatches(v.uniqueID, input) then
                                    class, classData = k, v
                                    break
                                end
                            end
                        end
                    end
                end

                if class then
                    local classes = doorData.classes or {}
                    if not table.HasValue(classes, classData.uniqueID) then classes[#classes + 1] = classData.uniqueID end
                    doorData.classes = classes
                    door.liaClasses = classes
                    doorData.noSell = true
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorSetClass", door, classData.name)
                    client:notifySuccess(string.format("This door now belongs to the '%s' class.", classData.name))
                elseif arguments[1] then
                    client:notifyError("The specified class is not valid.")
                else
                    doorData.classes = {}
                    door.liaClasses = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveClass", door)
                    client:notifySuccess("This door no longer belongs to any class.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end,
    alias = {"jobdoor"}
})

lia.command.add("doorremoveclass", {
    desc = "Remove a class (job) restriction from a door.",
    arguments = {
        {
            name = "class",
            type = "string"
        }
    },
    adminOnly = true,
    AdminStick = {
        Name = "Remove Door Class",
        Category = "Door Management",
        SubCategory = "Settings",
        TargetClass = "door",
        Icon = "icon16/delete.png"
    },
    onRun = function(client, arguments)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local doorData = lia.doors.getData(door)
            if not doorData.disabled then
                local input = arguments[1]
                local class, classData
                if input then
                    local classIndex = tonumber(input)
                    if classIndex then
                        classData = lia.class.list[classIndex]
                        if classData then
                            class = classIndex
                        else
                            client:notifyError("The specified class is not valid.")
                            return
                        end
                    else
                        local id = lia.class.retrieveClass(input)
                        if id then
                            class, classData = id, lia.class.list[id]
                        else
                            for k, v in pairs(lia.class.list) do
                                if lia.util.stringMatches(v.name, input) or lia.util.stringMatches(v.uniqueID, input) then
                                    class, classData = k, v
                                    break
                                end
                            end
                        end
                    end
                end

                if class then
                    local classes = doorData.classes or {}
                    if table.HasValue(classes, classData.uniqueID) then
                        table.RemoveByValue(classes, classData.uniqueID)
                        doorData.classes = classes
                        door.liaClasses = classes
                        lia.doors.setData(door, doorData)
                        lia.log.add(client, "doorRemoveClassSpecific", door, classData.name)
                        client:notifySuccess(string.format("The '%s' class has been removed from this door.", classData.name))
                    else
                        client:notifyError(string.format("The '%s' class is not assigned to this door.", classData.name))
                    end
                elseif arguments[1] then
                    client:notifyError("The specified class is not valid.")
                else
                    doorData.classes = {}
                    door.liaClasses = nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, "doorRemoveClass", door)
                    client:notifySuccess("This door no longer belongs to any class.")
                end

                lia.module.get("doors"):SaveData()
            else
                client:notifyError("You are not looking at a valid door.")
            end
        else
            client:notifyError("You are not looking at a valid door.")
        end
    end
})

lia.command.add("togglealldoors", {
    desc = "Toggle the enabled state for all doors in the map.",
    adminOnly = true,
    onRun = function(client)
        local toggleToDisable = false
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local doorData = lia.doors.getData(door)
                toggleToDisable = not (doorData.disabled or false)
                break
            end
        end

        local count = 0
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local doorData = lia.doors.getData(door)
                if (doorData.disabled or false) ~= toggleToDisable then
                    doorData.disabled = toggleToDisable and true or nil
                    lia.doors.setData(door, doorData)
                    lia.log.add(client, toggleToDisable and "doorDisable" or "doorEnable", door)
                    count = count + 1
                end
            end
        end

        client:notifySuccessLocalized(toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.log.add(client, toggleToDisable and "doorDisableAll" or "doorEnableAll", count)
        lia.module.get("doors"):SaveData()
    end
})

lia.command.add("doorid", {
    desc = "Set the door ID for identification purposes.",
    adminOnly = true,
    onRun = function(client)
        local door = client:getTracedEntity()
        if IsValid(door) and door:isDoor() then
            local mapID = door:MapCreationID()
            if mapID and mapID > 0 then
                local pos = door:GetPos()
                client:notifyInfoLocalized("doorID " .. mapID .. " | Position: " .. string.format("%.0f, %.0f, %.0f", pos.x, pos.y, pos.z))
                lia.log.add(client, "doorID", door, mapID)
            else
                client:notifyError("No valid map ID found for this door.")
            end
        else
            client:notifyError("You must be looking at a door.")
        end
    end
})

lia.command.add("listdoorids", {
    desc = "listDoorIDsDesc",
    adminOnly = true,
    onRun = function(client)
        local doorData = {}
        for _, door in ents.Iterator() do
            if IsValid(door) and door:isDoor() then
                local mapID = door:MapCreationID()
                if mapID and mapID > 0 then
                    local pos = door:GetPos()
                    table.insert(doorData, {
                        id = mapID,
                        position = string.format("%.0f, %.0f, %.0f", pos.x, pos.y, pos.z),
                        model = door:GetModel() or "Unknown"
                    })
                end
            end
        end

        if #doorData == 0 then
            client:notifyInfo("No doors found.")
            return
        end

        table.sort(doorData, function(a, b) return a.id < b.id end)
        local doorList = {}
        for _, data in ipairs(doorData) do
            table.insert(doorList, {
                property = "Door ID" .. data.id,
                value = "Position: " .. data.position .. "Model Label" .. data.model
            })
        end

        lia.util.sendTableUI(client, string.format("Door IDs on map %s", game.GetMap()), {
            {
                name = "Door ID",
                field = "property"
            },
            {
                name = "Details Column",
                field = "value"
            }
        }, doorList)
    end
})

lia.command.add("plytransfer", {
    adminOnly = true,
    desc = "Transfers the specified player to a new faction.",
    alias = {"charsetfaction"},
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    if k ~= "staff" then options[L(v.name)] = k end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local targetPlayer
        local factionArgIndex = 2
        if istable(arguments) and #arguments >= 2 then
            local lastArg = arguments[#arguments]
            local assumedFaction = lia.faction.teams[lastArg]
            if not assumedFaction then
                local factionIndex = tonumber(lastArg)
                if factionIndex then assumedFaction = lia.faction.indices[factionIndex] end
            end

            if assumedFaction then
                local assumedName = table.concat(arguments, " ", 1, #arguments - 1)
                local assumedTarget = lia.util.findPlayer(client, assumedName)
                if assumedTarget and IsValid(assumedTarget) then
                    targetPlayer = assumedTarget
                    factionArgIndex = #arguments
                end
            end
        end

        targetPlayer = targetPlayer or lia.util.findPlayer(client, arguments[1])
        if (not targetPlayer or not IsValid(targetPlayer)) and arguments[2] then
            local combined = tostring(arguments[1]) .. " " .. tostring(arguments[2])
            local combinedTarget = lia.util.findPlayer(client, combined)
            if combinedTarget and IsValid(combinedTarget) then
                targetPlayer = combinedTarget
                factionArgIndex = 3
            end
        end

        if (not targetPlayer or not IsValid(targetPlayer)) and arguments[3] then
            local combined = tostring(arguments[1]) .. " " .. tostring(arguments[2]) .. " " .. tostring(arguments[3])
            local combinedTarget = lia.util.findPlayer(client, combined)
            if combinedTarget and IsValid(combinedTarget) then
                targetPlayer = combinedTarget
                factionArgIndex = 4
            end
        end

        if not targetPlayer or not IsValid(targetPlayer) then
            client:notifyError("Target not found")
            return
        end

        local factionName = arguments[factionArgIndex]
        local faction = lia.faction.teams[factionName]
        if not faction then
            local factionIndex = tonumber(factionName)
            if factionIndex then faction = lia.faction.indices[factionIndex] end
        end

        if not faction then
            faction = lia.util.findFaction(client, tostring(factionName))
            if not faction then return end
        end

        if faction.uniqueID == "staff" then
            client:notifyError("You cannot transfer a player to the staff faction through commands. Staff characters must be created through the menu system.")
            return
        end

        local targetChar = targetPlayer:getChar()
        if hook.Run("CanCharBeTransfered", targetChar, faction, targetPlayer:Team()) == false then return end
        local oldFaction = targetChar:getFaction()
        local oldFactionName = lia.faction.indices[oldFaction] and lia.faction.indices[oldFaction].name or oldFaction
        targetChar.vars.faction = faction.uniqueID
        targetChar:setFaction(faction.index)
        hook.Run("OnTransferred", targetPlayer)
        if faction.OnTransferred then faction:OnTransferred(targetPlayer, oldFaction) end
        client:notifySuccess(string.format("%s has been transferred to %s.", targetPlayer:Name(), L(faction.name, client)))
        if client ~= targetPlayer then targetPlayer:notifyInfo(string.format("You have been transferred to %s by %s.", L(faction.name, targetPlayer), client:Name())) end
        lia.log.add(client, "plyTransfer", targetPlayer:Name(), oldFactionName, faction.name)
    end
})

lia.command.add("plywhitelist", {
    adminOnly = true,
    desc = "Adds the specified player to a faction whitelist.",
    alias = {"factionwhitelist"},
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    if k ~= "staff" then options[L(v.name)] = k end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local faction = lia.util.findFaction(client, arguments[2])
        if not faction then
            client:notifyError("The specified faction is not valid.")
            return
        end

        if faction.uniqueID == "staff" then
            client:notifyError("You cannot whitelist a player to the staff faction through commands. Staff characters must be created through the menu system.")
            return
        end

        local data = lia.faction.indices[faction.index]
        if data then
            if data.uniqueID == "staff" then return end
            local whitelists = target:getLiliaData("whitelists", {})
            whitelists[SCHEMA.folder] = whitelists[SCHEMA.folder] or {}
            whitelists[SCHEMA.folder][data.uniqueID] = true
            target:setLiliaData("whitelists", whitelists)
            for _, v in player.Iterator() do
                v:notifyInfo(string.format("%s has whitelisted %s for the %s faction.", client:Name(), target:Name(), L(faction.name, v)))
            end

            lia.log.add(client, "plyWhitelist", target:Name(), faction.name)
        end
    end
})

lia.command.add("plyunwhitelist", {
    adminOnly = true,
    desc = "Removes the specified player from a faction whitelist.",
    alias = {"factionunwhitelist"},
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    if k ~= "staff" then options[L(v.name)] = k end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local faction = lia.util.findFaction(client, arguments[2])
        if not faction then
            client:notifyError("The specified faction is not valid.")
            return
        end

        if faction.uniqueID == "staff" then
            client:notifyError("You cannot unwhitelist a player from the staff faction through commands. Staff character management must be done through the menu system.")
            return
        end

        if faction and not faction.isDefault then
            local data = lia.faction.indices[faction.index]
            if data then
                if data.uniqueID == "staff" then return end
                local whitelists = target:getLiliaData("whitelists", {})
                whitelists[SCHEMA.folder] = whitelists[SCHEMA.folder] or {}
                whitelists[SCHEMA.folder][data.uniqueID] = nil
                target:setLiliaData("whitelists", whitelists)
                for _, v in player.Iterator() do
                    v:notifyInfo(string.format("%s has unwhitelisted %s from the %s faction.", client:Name(), target:Name(), L(faction.name, v)))
                end

                lia.log.add(client, "plyUnwhitelist", target:Name(), faction.name)
            end
        else
            client:notifyError("The specified faction is not valid.")
        end
    end
})

lia.command.add("beclass", {
    adminOnly = false,
    desc = "Changes your current class to the specified class.",
    arguments = {
        {
            name = "class",
            type = "table",
            options = function()
                local options = {}
                for _, v in pairs(lia.class.list) do
                    options[L(v.name)] = v.uniqueID
                end
                return options
            end
        },
        {
            name = "model",
            type = "string",
            optional = true
        }
    },
    onRun = function(client, arguments)
        local className = arguments[1]
        local requestedModel = arguments[2]
        local character = client:getChar()
        if not IsValid(client) or not character then
            client:notifyError("You are not whitelisted for this faction.")
            return
        end

        local classID = tonumber(className) or lia.class.retrieveClass(className)
        local classData = lia.class.get(classID)
        if not classData then
            client:notifyError("The specified class is not valid.")
            return
        end

        local currentClass = character:getClass()
        local isSameClass = currentClass == classID
        local function applyRequestedClassModel()
            if not istable(classData.model) then
                character:setData("classModel", nil)
                return false
            end

            if not isstring(requestedModel) or requestedModel == "" then return false end
            local function gatherModels(mdl, out)
                if isstring(mdl) and mdl ~= "" then
                    out[#out + 1] = mdl
                elseif istable(mdl) then
                    for _, v in pairs(mdl) do
                        gatherModels(v, out)
                    end
                end
            end

            local validModels = {}
            gatherModels(classData.model, validModels)
            local ok = false
            for _, v in ipairs(validModels) do
                if v == requestedModel then
                    ok = true
                    break
                end
            end

            if not ok then return false end
            if util and util.IsValidModel and not util.IsValidModel(requestedModel) then return false end
            character:setData("classModel", requestedModel)
            return true
        end

        if isSameClass then
            if applyRequestedClassModel() then client:notify("Model updated. Will apply on respawn.") end
            return
        end

        if lia.class.canBe(client, classID) then
            if character:joinClass(classID) then
                if not istable(classData.model) then character:setData("classModel", nil) end
                applyRequestedClassModel()
                client:notifySuccess(string.format("You have become %s.", L(classData.name)))
                lia.log.add(client, "beClass", classData.name)
            else
                client:notifyError(string.format("Failed to become %s.", L(classData.name)))
            end
        else
            client:notifyError("The specified class is not valid.")
        end
    end
})

lia.command.add("setclass", {
    adminOnly = true,
    desc = "Sets the specified player's class.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "class",
            type = "table",
            options = function(client, prefix)
                local options = {}
                local targetName = prefix and prefix[1]
                local target = targetName and lia.util.findPlayer(client, targetName)
                if not target or not target:getChar() then return options end
                local targetFaction = target:Team()
                local factionClasses = lia.faction.getClasses(targetFaction)
                if not factionClasses or #factionClasses == 0 then return options end
                for _, v in pairs(factionClasses) do
                    local canAccess = true
                    if lia.class.hasWhitelist(v.index) then canAccess = target:getChar():getClasswhitelists()[v.index] end
                    if canAccess and target:getChar():getClass() ~= v.uniqueID then options[L(v.name)] = v.uniqueID end
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if not target:getChar() then
            client:notifyError("Invalid Target!")
            return
        end

        if not lia.class.list or table.IsEmpty(lia.class.list) then
            client:notifyError("No classes are currently available.")
            return
        end

        local targetFaction = target:Team()
        local factionClasses = lia.faction.getClasses(targetFaction)
        if not factionClasses or #factionClasses == 0 then
            client:notifyError("The target player's faction does not have any classes.")
            return
        end

        local className = arguments[2]
        local classID = lia.class.retrieveClass(className)
        local classData = lia.class.list[classID]
        if classData then
            if target:Team() == classData.faction then
                target:getChar():joinClass(classID, true)
                lia.log.add(client, "setClass", target:Name(), classData.name)
                target:notifyInfo(string.format("Your class was set to %s%s.", L(classData.name), client:GetName()))
                if client ~= target then client:notifySuccess(string.format("You set %s class to %s.", target:GetName(), L(classData.name))) end
                hook.Run("PlayerLoadout", target)
            else
                client:notifyError("The class does not match the target's faction!")
            end
        else
            client:notifyError("The specified class is not valid.")
        end
    end
})

lia.command.add("classwhitelist", {
    adminOnly = true,
    desc = "Grants the specified player whitelist access to a class.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "class",
            type = "table",
            options = function()
                local options = {}
                for _, v in pairs(lia.class.list) do
                    options[L(v.name)] = v.uniqueID
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local classID = lia.class.retrieveClass(arguments[2])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        elseif not classID then
            client:notifyError("The specified class is not valid.")
            return
        end

        local classData = lia.class.list[classID]
        if target:Team() ~= classData.faction then
            client:notifyError("You cannot whitelist a class outside the faction.")
        elseif target:getChar():getClasswhitelists()[classID] then
            client:notifyInfo("This player is already whitelisted.")
        else
            local wl = target:getChar():getClasswhitelists()
            wl[classID] = true
            target:getChar():setClasswhitelists(wl)
            client:notifySuccess("Successfully whitelisted the player.")
            target:notifyInfo(string.format("Class '%s' has been assigned to your current character.", L(classData.name)))
            lia.log.add(client, "classWhitelist", target:Name(), classData.name)
        end
    end
})

lia.command.add("classunwhitelist", {
    adminOnly = true,
    desc = "Revokes the specified player's whitelist access to a class.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
        {
            name = "class",
            type = "table",
            options = function()
                local options = {}
                for _, v in pairs(lia.class.list) do
                    options[L(v.name)] = v.uniqueID
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        local classID = lia.class.retrieveClass(arguments[2])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        elseif not classID then
            client:notifyError("The specified class is not valid.")
            return
        end

        local classData = lia.class.list[classID]
        if target:Team() ~= classData.faction then
            client:notifyError("You cannot whitelist a class outside the faction.")
        elseif not target:getChar():getClasswhitelists()[classID] then
            client:notifyInfo("This player is not whitelisted.")
        else
            local wl = target:getChar():getClasswhitelists()
            wl[classID] = nil
            target:getChar():setClasswhitelists(wl)
            client:notifySuccess("Successfully removed the player's whitelist.")
            target:notifyInfo(string.format("Class '%s' has been removed from your character.", L(classData.name)))
            lia.log.add(client, "classUnwhitelist", target:Name(), classData.name)
        end
    end
})

lia.command.add("spawnadd", {
    adminOnly = true,
    desc = "Adds a spawn point at your current position for the specified faction.",
    arguments = {
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    options[k] = L(v.name)
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local factionName = arguments[1]
        if not factionName then
            client:notifyError("Invalid argument.")
            return
        end

        local factionInfo = lia.faction.teams[factionName] or lia.util.findFaction(client, factionName)
        if factionInfo then
            lia.module.get("spawns"):FetchSpawns():next(function(spawns)
                spawns[factionInfo.uniqueID] = spawns[factionInfo.uniqueID] or {}
                local newSpawn = {
                    pos = client:GetPos(),
                    ang = client:EyeAngles(),
                    map = lia.data.getEquivalencyMap(game.GetMap())
                }

                table.insert(spawns[factionInfo.uniqueID], newSpawn)
                lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                    lia.log.add(client, "spawnAdd", factionInfo.name)
                    client:notifySuccess(string.format("You added spawn for %s.", L(factionInfo.name)))
                end)
            end)
        else
            client:notifyError("The specified faction is not valid.")
        end
    end
})

lia.command.add("spawnremoveinradius", {
    adminOnly = true,
    desc = "Removes all spawn points within the given radius of your position (default 120).",
    arguments = {
        {
            name = "radius",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local position = client:GetPos()
        local radius = tonumber(arguments[1]) or 120
        lia.module.get("spawns"):FetchSpawns():next(function(spawns)
            local removedCount = 0
            local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
            for faction, list in pairs(spawns) do
                for i = #list, 1, -1 do
                    local data = list[i]
                    if not (data.map and data.map:lower() ~= curMap) then
                        local spawn = data.pos or data
                        if not isvector(spawn) then spawn = lia.data.decodeVector(spawn) end
                        if isvector(spawn) and spawn:Distance(position) <= radius then
                            table.remove(list, i)
                            removedCount = removedCount + 1
                        end
                    end
                end

                if #list == 0 then spawns[faction] = nil end
            end

            if removedCount > 0 then
                lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                    lia.log.add(client, "spawnRemoveRadius", radius, removedCount)
                    client:notifySuccess(string.format("You have removed %s spawn point(s).", removedCount))
                end)
            else
                lia.log.add(client, "spawnRemoveRadius", radius, removedCount)
                client:notifySuccess(string.format("You have removed %s spawn point(s).", removedCount))
            end
        end)
    end
})

lia.command.add("spawnremovebyname", {
    adminOnly = true,
    desc = "Removes all spawn points for the specified faction.",
    arguments = {
        {
            name = "faction",
            type = "table",
            options = function()
                local options = {}
                for k, v in pairs(lia.faction.teams) do
                    options[k] = L(v.name)
                end
                return options
            end
        }
    },
    onRun = function(client, arguments)
        local factionName = arguments[1]
        local factionInfo = factionName and (lia.faction.teams[factionName] or lia.util.findFaction(client, factionName))
        if factionInfo then
            lia.module.get("spawns"):FetchSpawns():next(function(spawns)
                local list = spawns[factionInfo.uniqueID]
                if list then
                    local curMap = lia.data.getEquivalencyMap(game.GetMap()):lower()
                    local removedCount = 0
                    for i = #list, 1, -1 do
                        local data = list[i]
                        if not (data.map and data.map:lower() ~= curMap) then
                            table.remove(list, i)
                            removedCount = removedCount + 1
                        end
                    end

                    if removedCount > 0 then
                        if #list == 0 then spawns[factionInfo.uniqueID] = nil end
                        lia.module.get("spawns"):StoreSpawns(spawns):next(function()
                            lia.log.add(client, "spawnRemoveByName", factionInfo.name, removedCount)
                            client:notifySuccess(string.format("Deleted %s spawn point(s) for faction: %s.", L(factionInfo.name), removedCount))
                        end)
                    else
                        client:notifyInfo("No spawn points exist for this faction.")
                    end
                else
                    client:notifyInfo("No spawn points exist for this faction.")
                end
            end)
        else
            client:notifyError("The specified faction is not valid.")
        end
    end
})

lia.command.add("returnitems", {
    superAdminOnly = true,
    desc = "Returns items lost on death to the specified player, if any.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "Return Items",
        Category = "Character Management",
        SubCategory = "Items",
        Icon = "icon16/arrow_refresh.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        if lia.config.get("LoseItemsonDeathHuman", false) or lia.config.get("LoseItemsonDeathNPC", false) then
            if not target.LostItems or table.IsEmpty(target.LostItems) then
                client:notifyInfo("The target hasn't lost any items or they've already been returned.")
                return
            end

            local character = target:getChar()
            if not character then return end
            local inv = character:getInv()
            if not inv then return end
            for _, item in pairs(target.LostItems) do
                inv:add(lia.item.new(item.name, item.id))
            end

            target.LostItems = nil
            target:notifySuccess("Your items have been returned.")
            client:notifySuccess("Returned the items.")
            lia.log.add(client, "returnItems", target:Name())
        else
            client:notifyInfo("Item loss on death is not enabled!")
        end
    end
})

lia.command.add("returnallitems", {
    superAdminOnly = true,
    desc = "Returns items lost on death to all players who have lost items.",
    AdminStick = {
        Name = "Return All Items",
        Category = "Character Management",
        SubCategory = "Items",
        Icon = "icon16/arrow_refresh.png"
    },
    onRun = function(client)
        if not lia.config.get("LoseItemsonDeathHuman", false) and not lia.config.get("LoseItemsonDeathNPC", false) then
            client:notifyInfo("Item loss on death is not enabled!")
            return
        end

        local returnedCount = 0
        local totalItems = 0
        for _, target in player.Iterator() do
            if not target.LostItems or table.IsEmpty(target.LostItems) then continue end
            local character = target:getChar()
            if not character then continue end
            local inv = character:getInv()
            if not inv then continue end
            local playerItemCount = 0
            for _, item in pairs(target.LostItems) do
                inv:add(lia.item.new(item.name, item.id))
                playerItemCount = playerItemCount + 1
            end

            target.LostItems = nil
            target:notifySuccess("Your items have been returned.")
            returnedCount = returnedCount + 1
            totalItems = totalItems + playerItemCount
            lia.log.add(client, "returnItems", target:Name())
        end

        if returnedCount > 0 then
            client:notifySuccess(string.format("Returned items to %d players (%d total items).", returnedCount, totalItems))
        else
            client:notifyInfo("No players have lost items to return.")
        end
    end
})

local function GetTicketsByRequester(steamID)
    local condition = "requesterSteamID = " .. lia.db.convertDataType(steamID)
    return lia.db.select({"timestamp", "requester", "requesterSteamID", "admin", "adminSteamID", "message"}, "ticketclaims", condition):next(function(res)
        local tickets = {}
        for _, row in ipairs(res.results or {}) do
            tickets[#tickets + 1] = {
                timestamp = isnumber(row.timestamp) and row.timestamp or os.time(lia.time.toNumber(row.timestamp)),
                requester = row.requester,
                requesterSteamID = row.requesterSteamID,
                admin = row.admin,
                adminSteamID = row.adminSteamID,
                message = row.message
            }
        end
        return tickets
    end)
end

lia.command.add("viewtickets", {
    adminOnly = true,
    desc = "Displays all tickets requested by the specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyError("You must specify a player name.")
            return
        end

        local target = lia.util.findPlayer(client, targetName)
        local steamID, displayName
        if IsValid(target) then
            steamID = target:SteamID()
            displayName = target:Nick()
        else
            steamID = targetName
            displayName = targetName
        end

        GetTicketsByRequester(steamID):next(function(tickets)
            if #tickets == 0 then
                client:notifyInfo("No tickets found for the specified player.")
                return
            end

            local ticketsData = {}
            for _, ticket in ipairs(tickets) do
                ticketsData[#ticketsData + 1] = {
                    timestamp = os.date("%Y-%m-%d %H:%M:%S", ticket.timestamp),
                    admin = string.format("%s (%s)", ticket.admin or "N/A", ticket.adminSteamID or "N/A"),
                    message = ticket.message or ""
                }
            end

            lia.util.sendTableUI(client, string.format("Tickets for %s", displayName), {
                {
                    name = "timestamp",
                    field = "timestamp"
                },
                {
                    name = "admin",
                    field = "admin"
                },
                {
                    name = "message",
                    field = "message"
                }
            }, ticketsData)

            lia.log.add(client, "viewPlayerTickets", displayName)
        end)
    end
})

lia.command.add("plyviewclaims", {
    adminOnly = true,
    desc = "Displays detailed claim information for the specified player.",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "View Ticket Claims",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/page_white_text.png"
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyError("You must specify a player name.")
            return
        end

        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local steamID = target:SteamID()
        lia.module.get("administration"):GetAllCaseClaims():next(function(caseclaims)
            local claim = caseclaims[steamID]
            if not claim then
                client:notifyInfo("No claims found for the specified player.")
                return
            end

            local claimsData = {
                {
                    steamID = steamID,
                    name = claim.name,
                    claims = claim.claims,
                    lastclaim = os.date("%Y-%m-%d %H:%M:%S", claim.lastclaim),
                    timeSinceLastClaim = lia.time.timeSince(claim.lastclaim),
                    claimedFor = table.IsEmpty(claim.claimedFor) and "None" or table.concat((function()
                        local t = {}
                        for sid, name in pairs(claim.claimedFor) do
                            table.insert(t, string.format("%s (%s)", name, sid))
                        end
                        return t
                    end)(), "\n")
                }
            }

            lia.util.sendTableUI(client, string.format("Claims for %s", target:Nick()), {
                {
                    name = "steamID",
                    field = "steamID"
                },
                {
                    name = "adminName",
                    field = "name"
                },
                {
                    name = "totalClaims",
                    field = "claims"
                },
                {
                    name = "lastClaimDate",
                    field = "lastclaim"
                },
                {
                    name = "timeSinceLastClaim",
                    field = "timeSinceLastClaim"
                },
                {
                    name = "claimedFor",
                    field = "claimedFor"
                }
            }, claimsData)

            lia.log.add(client, "viewPlayerClaims", target:Name())
        end)
    end
})

lia.command.add("viewallclaims", {
    adminOnly = true,
    desc = "Displays a summary table of claim data for all admins.",
    onRun = function(client)
        lia.module.get("administration"):GetAllCaseClaims():next(function(caseclaims)
            if table.IsEmpty(caseclaims) then
                client:notifyInfo("No claims have been recorded yet.")
                return
            end

            local claimsData = {}
            for steamID, claim in pairs(caseclaims) do
                table.insert(claimsData, {
                    steamID = steamID,
                    name = claim.name,
                    claims = claim.claims,
                    lastclaim = os.date("%Y-%m-%d %H:%M:%S", claim.lastclaim),
                    timeSinceLastClaim = lia.time.timeSince(claim.lastclaim),
                    claimedFor = table.IsEmpty(claim.claimedFor) and "None" or table.concat((function()
                        local t = {}
                        for sid, name in pairs(claim.claimedFor) do
                            table.insert(t, string.format("%s (%s)", name, sid))
                        end
                        return t
                    end)(), ", ")
                })
            end

            lia.util.sendTableUI(client, "adminClaimsTitle", {
                {
                    name = "steamID",
                    field = "steamID"
                },
                {
                    name = "adminName",
                    field = "name"
                },
                {
                    name = "totalClaims",
                    field = "claims"
                },
                {
                    name = "lastClaimDate",
                    field = "lastclaim"
                },
                {
                    name = "timeSinceLastClaim",
                    field = "timeSinceLastClaim"
                },
                {
                    name = "claimedFor",
                    field = "claimedFor"
                }
            }, claimsData)

            lia.log.add(client, "viewAllClaims")
        end)
    end
})

lia.command.add("viewclaims", {
    adminOnly = true,
    desc = "Prints detailed claim information for every admin to chat.",
    onRun = function(client)
        lia.module.get("administration"):GetAllCaseClaims():next(function(caseclaims)
            if table.IsEmpty(caseclaims) then
                client:notifyInfo("No claims data available.")
                return
            end

            lia.log.add(client, "viewAllClaims")
            local claimsData = {}
            for steamID, claim in pairs(caseclaims) do
                table.insert(claimsData, {
                    steamID = steamID,
                    name = claim.name,
                    claims = claim.claims,
                    lastclaim = os.date("%Y-%m-%d %H:%M:%S", claim.lastclaim),
                    timeSinceLastClaim = lia.time.timeSince(claim.lastclaim),
                    claimedFor = table.IsEmpty(claim.claimedFor) and "None" or table.concat((function()
                        local t = {}
                        for sid, name in pairs(claim.claimedFor) do
                            table.insert(t, string.format("%s (%s)", name, sid))
                        end
                        return t
                    end)(), "\n")
                })
            end

            lia.util.sendTableUI(client, "adminClaimsTitle", {
                {
                    name = "steamID",
                    field = "steamID"
                },
                {
                    name = "adminName",
                    field = "name"
                },
                {
                    name = "totalClaims",
                    field = "claims"
                },
                {
                    name = "lastClaimDate",
                    field = "lastclaim"
                },
                {
                    name = "timeSinceLastClaim",
                    field = "timeSinceLastClaim"
                },
                {
                    name = "claimedFor",
                    field = "claimedFor"
                }
            }, claimsData)
        end)
    end
})

lia.command.add("warn", {
    adminOnly = true,
    desc = "Issues a warning to the specified player with a given reason.",
    arguments = {
        {
            name = "target",
            type = "player"
        },
        {
            name = "severity",
            type = "string",
            optional = true
        },
        {
            name = "reason",
            type = "string"
        },
    },
    AdminStick = {
        Name = "Warn Player",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/error.png"
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        local rawSeverity = arguments[2]
        local reasonStartIndex = 3
        local severity = "Medium"
        local function normalizeSeverity(value)
            if not isstring(value) then return nil end
            local lowered = string.lower(string.Trim(value))
            if lowered == "low" or lowered == "minor" then return "Low" end
            if lowered == "medium" or lowered == "med" then return "Medium" end
            if lowered == "high" or lowered == "major" then return "High" end
            return nil
        end

        local normalized = normalizeSeverity(rawSeverity)
        if normalized then
            severity = normalized
        elseif rawSeverity and rawSeverity ~= "" then
            client:notifyError("Invalid argument.")
            return
        else
            reasonStartIndex = 2
        end

        local reason = table.concat(arguments, " ", reasonStartIndex)
        if not targetName or reason == "" then return "Usage: warn [player] [severity] [reason]" end
        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local warnerName = client:Nick()
        local warnerSteamID = client:SteamID()
        hook.Run("AddWarning", target:getChar():getID(), target:Nick(), target:SteamID(), timestamp, reason, warnerName, warnerSteamID, severity)
        lia.db.count("warnings", "charID = " .. lia.db.convertDataType(target:getChar():getID())):next(function(count)
            target:notifyWarning(string.format("You have been warned by %s (%s) for: %s", warnerName .. " (" .. warnerSteamID .. ")", severity, reason))
            client:notifySuccess(string.format("Warning issued to %s", target:Nick()))
            local message = warnerName .. " warned " .. target:Name() .. " (Character " .. target:getChar():getID() .. " | Steam64ID: " .. target:SteamID64() .. ") for \"" .. reason .. "\" [Severity: " .. severity .. "]."
            StaffAddTextShadowed(Color(255, 140, 0), "WARNING", Color(255, 255, 255), message)
            hook.Run("WarningIssued", client, target, reason, severity, count, warnerSteamID, target:SteamID())
        end)
    end
})

lia.command.add("previewchatmessages", {
    superAdminOnly = true,
    desc = "Preview chat outputs",
    onRun = function(client)
        if not IsValid(client) then return end
        local ts = os.date("%Y-%m-%d %H:%M:%S")
        ClientAddTextShadowed(client, Color(255, 165, 0), "PREVIEW", Color(255, 255, 255), " | " .. ts .. " | Shadowed sample message (general).")
        ClientAddTextShadowed(client, Color(255, 140, 0), "WARNING", Color(255, 255, 255), " | " .. ts .. " | Low severity warning preview.")
        ClientAddTextShadowed(client, Color(255, 215, 0), "WARNING", Color(255, 255, 255), " | " .. ts .. " | Medium severity warning preview.")
        ClientAddTextShadowed(client, Color(255, 0, 0), "WARNING", Color(255, 255, 255), " | " .. ts .. " | High severity warning preview.")
        ClientAddTextShadowed(client, Color(255, 0, 0), "DEATH", Color(255, 255, 255), " | " .. ts .. " | John Doe (Character 12 | Steam64ID: 76561198000000000) was killed by Character 13 | Steam64ID: 76561198000000001.")
        ClientAddTextShadowed(client, Color(255, 165, 0), "INSERT", Color(255, 255, 255), " | " .. ts .. " | Player 12 (Steam64ID: 76561198000000002) pressed the Insert key.")
        ClientAddTextShadowed(client, Color(199, 21, 133), "INVENTORY", Color(255, 255, 255), " | " .. ts .. " | Inventory size changed to 10x10.")
        ClientAddTextShadowed(client, Color(34, 139, 34), "MONEY", Color(255, 255, 255), " | " .. ts .. " | $5,000 granted to player preview.")
        ClientAddTextShadowed(client, Color(123, 104, 238), "SIT", Color(255, 255, 255), " | " .. ts .. " | Teleport preview to sit room.")
        ClientAddText(client, Color(200, 200, 200), "[Preview] ", Color(255, 255, 255), "Non-shadowed chat line for comparison.")
        client:notifySuccess("Preview messages sent to your chat.")
    end
})

lia.command.add("viewwarns", {
    adminOnly = true,
    desc = "Displays all warnings issued to the specified player.",
    arguments = {
        {
            name = "target",
            type = "player"
        },
    },
    AdminStick = {
        Name = "View Player Warnings",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/eye.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Target not found")
            return
        end

        lia.module.get("administration"):GetWarnings(target:getChar():getID()):next(function(warns)
            if #warns == 0 then
                client:notifyInfo(string.format("%s has no warnings.", target:Nick()))
                return
            end

            local warningList = {}
            for index, warn in ipairs(warns) do
                table.insert(warningList, {
                    index = index,
                    timestamp = warn.timestamp or "N/A",
                    admin = string.format("%s (%s)", warn.warner or "N/A", warn.warnerSteamID or "N/A"),
                    warningMessage = warn.message or "N/A",
                    severity = warn.severity or "Medium"
                })
            end

            lia.util.sendTableUI(client, string.format("%s's Warnings", target:Nick()), {
                {
                    name = "id",
                    field = "index"
                },
                {
                    name = "timestamp",
                    field = "timestamp"
                },
                {
                    name = "admin",
                    field = "admin"
                },
                {
                    name = "warningMessage",
                    field = "warningMessage"
                },
                {
                    name = "Severity",
                    field = "severity"
                }
            }, warningList, {
                {
                    name = "removeWarning",
                    net = "liaRequestRemoveWarning"
                }
            }, target:getChar():getID())

            lia.log.add(client, "viewWarns", target)
        end)
    end
})

local function GetWarningsByIssuer(steamID)
    local condition = "warnerSteamID = " .. lia.db.convertDataType(steamID)
    return lia.db.select({"id", "timestamp", "message", "warned", "warnedSteamID", "warner", "warnerSteamID", "severity"}, "warnings", condition):next(function(res) return res.results or {} end)
end

lia.command.add("viewwarnsissued", {
    adminOnly = true,
    desc = "Displays all warnings issued by the specified staff member.",
    arguments = {
        {
            name = "staff",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyError("Target not found")
            return
        end

        local target = lia.util.findPlayer(client, targetName)
        local steamID, displayName = targetName, targetName
        if IsValid(target) then
            steamID = target:SteamID()
            displayName = target:Nick()
        end

        GetWarningsByIssuer(steamID):next(function(warns)
            if #warns == 0 then
                client:notifyInfo(string.format("%s has no warnings.", displayName))
                return
            end

            local warningList = {}
            for index, warn in ipairs(warns) do
                warningList[#warningList + 1] = {
                    index = index,
                    timestamp = warn.timestamp or "N/A",
                    player = string.format("%s (%s)", warn.warned or "N/A", warn.warnedSteamID or "N/A"),
                    warningMessage = warn.message or "N/A",
                    severity = warn.severity or "Medium"
                }
            end

            lia.util.sendTableUI(client, string.format("Warnings Issued by %s", displayName), {
                {
                    name = "id",
                    field = "index"
                },
                {
                    name = "timestamp",
                    field = "timestamp"
                },
                {
                    name = "player",
                    field = "player"
                },
                {
                    name = "warningMessage",
                    field = "warningMessage"
                },
                {
                    name = "Severity",
                    field = "severity"
                }
            }, warningList)

            lia.log.add(client, "viewWarnsIssued", target or steamID)
        end)
    end
})

lia.command.add("recogwhisper", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    desc = "Force player recognition in whisper range.",
    AdminStick = {
        Name = "Force Recognition (Whisper)",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_comment.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) or not target:getChar() then return end
        hook.Run("ForceRecognizeRange", target, "whisper")
    end
})

lia.command.add("recognormal", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    desc = "Force player recognition in normal range.",
    AdminStick = {
        Name = "Force Recognition (Normal)",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_green.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) or not target:getChar() then return end
        hook.Run("ForceRecognizeRange", target, "normal")
    end
})

lia.command.add("recogyell", {
    adminOnly = true,
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    desc = "Force player recognition in yell range.",
    AdminStick = {
        Name = "Force Recognition (Yell)",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        Icon = "icon16/user_red.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1]) or client
        if not IsValid(target) or not target:getChar() then return end
        hook.Run("ForceRecognizeRange", target, "yell")
    end
})

lia.command.add("recogbots", {
    superAdminOnly = true,
    arguments = {
        {
            name = "range",
            type = "string",
            optional = true
        },
        {
            name = "name",
            type = "string",
            optional = true
        },
    },
    desc = "Force all bots to recognize people around them. Optionally specify a fake name.",
    onRun = function(_, arguments)
        local range = arguments[1] or "normal"
        local fakeName = arguments[2]
        for _, ply in player.Iterator() do
            if ply:IsBot() then hook.Run("ForceRecognizeRange", ply, range, fakeName) end
        end
    end
})

lia.command.add("kickbots", {
    privilege = "manageBots",
    desc = "Kick all bots from the server.",
    onRun = function(client)
        if timer.Exists("Bots_Add_Timer") then timer.Remove("Bots_Add_Timer") end
        local kickedCount = 0
        for _, bot in player.Iterator() do
            if bot:IsBot() then
                bot:Kick("All bots kicked")
                client:notifySuccess("Player kicked.")
                lia.log.add(client, "plyKick", bot:Name())
                lia.db.insertTable({
                    player = bot:Name(),
                    playerSteamID = bot:SteamID(),
                    steamID = bot:SteamID(),
                    action = "plykick",
                    staffName = client:Name(),
                    staffSteamID = client:SteamID(),
                    timestamp = os.time()
                }, nil, "staffactions")

                kickedCount = kickedCount + 1
            end
        end

        if kickedCount == 0 then
            client:notifyError("No bots to kick.")
        else
            client:notifyInfo(string.format("Kicked %d bots from the server.", kickedCount))
        end
    end
})

lia.command.add("npcchangetype", {
    adminOnly = true,
    desc = "Change the type of a dialog NPC you are looking at.",
    AdminStick = {
        Name = "Change NPC Type",
        Category = "Moderation",
        SubCategory = "Moderation Tools",
        TargetClass = "lia_npc",
        Icon = "icon16/user_edit.png"
    },
    onRun = function(client)
        if not client:hasPrivilege("Can Manage NPCs") then return client:notifyError("You lack permission to manage NPCs.") end
        local ent = client:getTracedEntity()
        if not ent or not IsValid(ent) then return client:notifyError("You must be looking at a valid entity.") end
        if ent:GetClass() ~= "lia_npc" then return client:notifyError("You must be looking at a dialog NPC.") end
        lia.dialog.syncToClients(client)
        timer.Simple(0.1, function()
            if not IsValid(client) or not IsValid(ent) then return end
            local npcOptions = {}
            local displayToUniqueID = {}
            for uniqueID, data in pairs(lia.dialog.stored) do
                local displayName = data.PrintName or uniqueID
                table.insert(npcOptions, {displayName, uniqueID})
                displayToUniqueID[displayName] = uniqueID
            end

            if not table.IsEmpty(npcOptions) then
                client.npcDisplayToUniqueID = displayToUniqueID
                client.npcEntity = ent
                client:requestDropdown("Change NPC Type", "Choose what type of NPC this should be:", npcOptions, function(selectedDisplayName, selectedUniqueID)
                    if selectedDisplayName and selectedDisplayName ~= "" then
                        local uniqueID = selectedUniqueID or (client.npcDisplayToUniqueID and client.npcDisplayToUniqueID[selectedDisplayName])
                        if uniqueID and IsValid(client.npcEntity) then
                            local npc = client.npcEntity
                            local npcType = uniqueID
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
                                client:notifyInfo("NPC type changed to: " .. (npcData.PrintName or npcType))
                            end
                        end
                    end
                end)
            else
                client:notifyError("No NPC types available! The server may still be loading modules. Please try again in a moment.")
            end
        end)
    end
})

lia.command.add("plyrespawn", {
    adminOnly = true,
    arguments = {
        {
            name = "target",
            type = "player"
        }
    },
    desc = "Force another player to respawn.",
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyError("Invalid Target!")
            return
        end

        target:Spawn()
        client:notifySuccess(string.format("Successfully force respawned %s.", target:Name()))
        target:notify("You were force respawned by an admin.", "default" or "default")
        lia.log.add(client, "plyrespawn", target:Name())
    end
})

lia.command.add("forcerespawn", {
    desc = "Force yourself to respawn after death.",
    onRun = function(client)
        if client:Alive() then
            client:notifyError("Player is already alive.")
            return
        end

        local baseTime = lia.config.get("SpawnTime", 5)
        baseTime = hook.Run("OverrideSpawnTime", client, baseTime) or baseTime
        local lastDeath = client:getLocalVar("lastDeathTime", os.time())
        local timePassed = os.time() - lastDeath
        if timePassed < baseTime then
            client:notifyError(string.format("You cannot respawn yet. Please wait %s seconds.", baseTime - timePassed))
            return
        end

        client:Spawn()
        client:setLocalVar("lastDeathTime", 0)
        client:notifySuccess(string.format("Successfully force respawned %s.", client:Name()))
        client:notify("You were force respawned by an admin.", "default" or "default")
        lia.log.add(client, "forcerespawn", client:Name())
    end
})

lia.command.add("resetvendorcooldowns", {
    desc = "Reset vendor cooldowns for a player",
    privilege = "canEditVendors",
    adminOnly = true,
    arguments = {
        {
            name = "target",
            type = "player",
            description = "The player to reset cooldowns for"
        }
    },
    AdminStick = {
        Name = "Reset Vendor Cooldowns",
        Category = "Character Management",
        SubCategory = "Properties",
        Icon = "icon16/time_delete.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not IsValid(target) then
            client:notifyError("Invalid Target!")
            return
        end

        local character = target:getChar()
        if not character then
            client:notifyError("Invalid Target!")
            return
        end

        character:setData("vendorCooldowns", {})
        client:notify("Vendor cooldowns have been reset for %s.", target:Name() or "default")
        target:notify("Your vendor cooldowns have been reset by an administrator.", "default" or "default")
    end
})

lia.command.add("storagepasswordremove", {
    adminOnly = true,
    desc = "Remove the password from the storage container you're looking at.",
    arguments = {},
    onRun = function(client)
        local trace = client:GetEyeTrace()
        local entity = trace.Entity
        if not IsValid(entity) or trace.HitPos:Distance(client:GetPos()) > 128 then
            client:notifyError("Invalid Target!")
            return
        end

        if not entity.password then
            client:notifyError("This storage is not locked.")
            return
        end

        entity.password = nil
        entity:setNetVar("locked", false)
        client:notifySuccess("Storage password has been removed.")
        lia.log.add(client, "storagePasswordRemoved", entity:GetClass())
        hook.Run("UpdateEntityPersistence", entity)
    end
})

lia.command.add("storagepasswordchange", {
    adminOnly = true,
    desc = "Change the password on the storage container you're looking at.",
    arguments = {
        {
            name = "password",
            type = "string"
        },
    },
    onRun = function(client, arguments)
        local trace = client:GetEyeTrace()
        local entity = trace.Entity
        local newPassword = arguments[1]
        if not IsValid(entity) or trace.HitPos:Distance(client:GetPos()) > 128 then
            client:notifyError("Invalid Target!")
            return
        end

        if not newPassword or newPassword == "" then
            client:notifyError("Password cannot be empty.")
            return
        end

        entity.password = newPassword
        entity:setNetVar("locked", true)
        client:notifySuccess("Storage password has been changed.")
        lia.log.add(client, "storagePasswordChanged", entity:GetClass())
        hook.Run("UpdateEntityPersistence", entity)
    end
})

lia.command.add("listnearbyentities", {
    adminOnly = true,
    desc = "Lists all entities within a specified radius around the player.",
    arguments = {
        {
            name = "radius",
            type = "string",
            optional = true
        },
    },
    onRun = function(client, arguments)
        local radius = tonumber(arguments[1]) or 500
        if radius <= 0 then radius = 500 end
        if radius > 10000 then radius = 10000 end
        local pos = client:GetPos()
        local entities = ents.FindInSphere(pos, radius)
        local entityCategories = {
            players = {},
            npcs = {},
            props = {},
            vehicles = {},
            weapons = {},
            other = {}
        }

        for _, ent in ipairs(entities) do
            if not IsValid(ent) then continue end
            local class = ent:GetClass()
            local category = "other"
            if ent:IsPlayer() then
                category = "players"
            elseif ent:IsNPC() then
                category = "npcs"
            elseif ent:IsVehicle() then
                category = "vehicles"
            elseif ent:IsWeapon() then
                category = "weapons"
            elseif class:find("prop_") or class == "lia_item" then
                category = "props"
            end

            table.insert(entityCategories[category], {
                class = class,
                model = ent:GetModel() or "N/A",
                pos = ent:GetPos(),
                distance = pos:Distance(ent:GetPos()),
                health = ent.Health and ent:Health() or "N/A",
                name = ent.GetName and ent:GetName() or "N/A"
            })
        end

        client:ChatPrint("=== Entities within " .. radius .. " units ===")
        for categoryName, entitiesInCategory in pairs(entityCategories) do
            if #entitiesInCategory > 0 then
                client:ChatPrint("--- " .. categoryName:upper() .. " (" .. #entitiesInCategory .. ") ---")
                table.sort(entitiesInCategory, function(a, b) return a.distance < b.distance end)
                for _, entData in ipairs(entitiesInCategory) do
                    local info = string.format("%.1f units: %s", entData.distance, entData.class)
                    if entData.name ~= "N/A" and entData.name ~= "" then info = info .. " (" .. entData.name .. ")" end
                    if entData.health ~= "N/A" then info = info .. " [HP: " .. entData.health .. "]" end
                    client:ChatPrint(info)
                end

                client:ChatPrint("")
            end
        end

        local totalEntities = 0
        for _, entitiesInCategory in pairs(entityCategories) do
            totalEntities = totalEntities + #entitiesInCategory
        end

        client:ChatPrint("Total entities found: " .. totalEntities)
        client:notify("Listed " .. totalEntities .. " entities within " .. radius .. " units")
    end
})

concommand.Add("lia_setextrachars", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    local steamid = args[1]
    local amount = tonumber(args[2])
    if not steamid or steamid == "" then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid SteamID provided.\n")
        return
    end

    if not amount or amount < 0 then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid amount provided. Must be a non-negative number.\n")
        return
    end

    lia.db.query("SELECT steamID, data FROM lia_players WHERE steamID = " .. lia.db.convertDataType(steamid) .. " LIMIT 1", function(data)
        local playerData = {}
        if data and data[1] then
            playerData = data[1].data
            if isstring(playerData) then
                playerData = util.JSONToTable(playerData) or {}
            elseif not playerData then
                playerData = {}
            end
        else
            lia.db.insertTable({
                steamID = steamid,
                steamName = "Unknown",
                data = "{}",
                lastJoin = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                lastIP = "",
                lastOnline = os.time(),
                totalOnlineTime = 0
            }, nil, "players")
        end

        local currentExtra = tonumber(playerData.extraCharacters) or 0
        local newExtra = currentExtra + amount
        playerData.extraCharacters = newExtra
        lia.db.updateTable({
            data = util.TableToJSON(playerData)
        }, nil, "players", "steamID = " .. lia.db.convertDataType(steamid))

        for _, ply in player.Iterator() do
            if ply:SteamID() == steamid then
                ply:setLiliaData("extraCharacters", newExtra)
                break
            end
        end

        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added " .. amount .. " extra character slot" .. (amount == 1 and "" or "s") .. " to player " .. steamid .. ". New total: " .. newExtra .. " (was " .. currentExtra .. ").\n")
        lia.log.add(nil, "addExtraChars", steamid, amount, newExtra)
    end)
end)

concommand.Add("lia_set_inventory_size_all_chars", function(client, _, args)
    if IsValid(client) then return end
    local steamID = args[1]
    local width = tonumber(args[2])
    local height = tonumber(args[3])
    if not steamID or not width or not height then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_set_inventory_size_all_chars <steamID> <width> <height>\n")
        return
    end

    if width < 1 or height < 1 then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Width and height must be positive numbers.\n")
        return
    end

    lia.db.select({"id", "name"}, "characters", "steamID = " .. lia.db.convertDataType(steamID)):next(function(res)
        local characters = res.results or {}
        if not characters or #characters == 0 then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "No characters found for SteamID: " .. steamID .. "\n")
            return
        end

        MsgC(Color(255, 255, 255), "[Lilia] ", "Processing " .. #characters .. " characters...\n")
        local ply = player.GetBySteamID(steamID)
        local isPlayerOnline = IsValid(ply) and ply:IsPlayer()
        local updatePromises = {}
        local sizeOverride = {width, height}
        local hasNotifiedPlayer = false
        local hasNotifiedStaff = false
        for _, charData in ipairs(characters) do
            local charID = charData.id
            local charName = charData.name
            local promise
            if isPlayerOnline then
                local character = lia.char.getCharacter(charID)
                if character then
                    character:setData("invSizeOverride", sizeOverride)
                    if not hasNotifiedPlayer then
                        ClientAddTextShadowed(ply, Color(255, 0, 0), "INVENTORY", Color(255, 255, 255), " Your inventory size has been changed to " .. width .. "x" .. height .. ". Please swap characters for the change to take effect.")
                        hasNotifiedPlayer = true
                    end

                    if not hasNotifiedStaff then
                        local staffMessage = "Inventory size set to " .. width .. "x" .. height .. " for " .. ply:Name() .. " (Steam64ID: " .. ply:SteamID64() .. ")."
                        StaffAddTextShadowed(Color(199, 21, 133), "INVENTORY", Color(255, 255, 255), staffMessage)
                        hasNotifiedStaff = true
                    end

                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set inventory size override for character '" .. charName .. "' (ID: " .. charID .. ") to " .. width .. "x" .. height .. " (player online)\n")
                    promise = deferred.resolve(true)
                else
                    promise = deferred.new()
                    local encoded = pon.encode({sizeOverride})
                    lia.db.upsert({
                        charID = charID,
                        key = "invSizeOverride",
                        value = encoded
                    }, "chardata", function(success, err)
                        if success then
                            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set inventory size override for character '" .. charName .. "' (ID: " .. charID .. ") to " .. width .. "x" .. height .. " (player online, char not loaded)\n")
                            promise:resolve(true)
                        else
                            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error setting inventory size override for character '" .. charName .. "' (ID: " .. charID .. "): " .. tostring(err) .. "\n")
                            promise:resolve(false)
                        end
                    end)
                end
            else
                promise = deferred.new()
                local encoded = pon.encode({sizeOverride})
                lia.db.upsert({
                    charID = charID,
                    key = "invSizeOverride",
                    value = encoded
                }, "chardata", function(success, err)
                    if success then
                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Set inventory size override for character '" .. charName .. "' (ID: " .. charID .. ") to " .. width .. "x" .. height .. " (player offline)\n")
                        promise:resolve(true)
                    else
                        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error setting inventory size override for character '" .. charName .. "' (ID: " .. charID .. "): " .. tostring(err) .. "\n")
                        promise:resolve(false)
                    end
                end)
            end

            table.insert(updatePromises, promise)
        end

        deferred.map(updatePromises, function(result) return result end):next(function(results)
            local successCount = 0
            for _, success in ipairs(results) do
                if success then successCount = successCount + 1 end
            end

            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully set inventory size override for " .. successCount .. " of " .. #characters .. " characters.\n")
            MsgC(Color(255, 255, 0), "[Lilia] ", Color(255, 255, 255), "Note: Inventory sizes will be applied when characters load.\n")
            lia.log.add(nil, "setInventorySizeAllChars", steamID, width, height, successCount)
        end)
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database error: " .. tostring(err) .. "\n") end)
end)

concommand.Add("lia_give_money_steamid", function(client, _, args)
    if IsValid(client) then
        client:notifyError("This command can only be run from the server console.")
        return
    end

    local steamID = args[1]
    local amount = tonumber(args[2])
    if not steamID or not amount then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_give_money_steamid <steamID> <amount>\n")
        return
    end

    if amount < 0 then
        MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Amount must be a positive number.\n")
        return
    end

    lia.db.select({"id", "name", "money"}, "characters", "steamID = " .. lia.db.convertDataType(steamID)):next(function(res)
        local characters = res.results or {}
        if not characters or #characters == 0 then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "No characters found for SteamID: " .. steamID .. "\n")
            return
        end

        local ply = player.GetBySteamID(steamID)
        local isPlayerOnline = IsValid(ply) and ply:IsPlayer()
        local updatedCount = 0
        for _, charData in ipairs(characters) do
            local charID = charData.id
            local charName = charData.name
            local currentMoney = tonumber(charData.money) or 0
            local newMoney = currentMoney + amount
            if isPlayerOnline and ply:getChar() and ply:getChar():getID() == charID then
                local char = ply:getChar()
                char:giveMoney(amount)
                local actualNewMoney = char:getMoney()
                updatedCount = updatedCount + 1
                MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Gave " .. lia.currency.get(amount) .. " to character '" .. charName .. "' (ID: " .. charID .. "). New balance: " .. lia.currency.get(actualNewMoney) .. " (player online)\n")
                if updatedCount == #characters then
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully gave " .. lia.currency.get(amount) .. " to " .. #characters .. " characters owned by SteamID: " .. steamID .. "\n")
                    lia.log.add(nil, "giveMoneySteamID", steamID, amount, #characters)
                end
            else
                if lia.char.setCharDatabase(charID, "money", newMoney) then
                    updatedCount = updatedCount + 1
                    MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Gave " .. lia.currency.get(amount) .. " to character '" .. charName .. "' (ID: " .. charID .. "). New balance: " .. lia.currency.get(newMoney) .. " (player offline)\n")
                    if updatedCount == #characters then
                        MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Successfully gave " .. lia.currency.get(amount) .. " to " .. #characters .. " characters owned by SteamID: " .. steamID .. "\n")
                        lia.log.add(nil, "giveMoneySteamID", steamID, amount, #characters)
                    end
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error updating money for character '" .. charName .. "' (ID: " .. charID .. ")\n")
                end
            end
        end
    end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database error: " .. tostring(err) .. "\n") end)
end)