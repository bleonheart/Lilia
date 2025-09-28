lia.command = lia.command or {}
lia.command.list = lia.command.list or {}
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

function lia.command.add(command, data)
    data.arguments = data.arguments or {}
    data.syntax = lia.command.buildSyntaxFromArguments(data.arguments)
    data.syntax = L(data.syntax or "")
    data.desc = data.desc or ""
    data.privilege = data.privilege or nil
    local superAdminOnly = data.superAdminOnly
    local adminOnly = data.adminOnly
    if not data.onRun then
        lia.error(L("commandNoCallback", command))
        return
    end

    if superAdminOnly or adminOnly then
        local privilegeName = data.privilege and L(data.privilege) or L("accessTo", command)
        local privilegeID = data.privilege or string.lower("command_" .. command)
        lia.administrator.registerPrivilege({
            Name = privilegeName,
            ID = privilegeID,
            MinAccess = superAdminOnly and "superadmin" or "admin",
            Category = "commands"
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
    data._onRun = data.onRun
    data.onRun = function(client, arguments)
        local hasAccess, _ = lia.command.hasAccess(client, command, data)
        if hasAccess then
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
                    lia.administrator.registerPrivilege({
                        Name = data.privilege and L(data.privilege) or L("accessTo", v),
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
                lia.administrator.registerPrivilege({
                    Name = data.privilege and L(data.privilege) or L("accessTo", alias),
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

    hook.Run("liaCommandAdded", command, data)
end

function lia.command.hasAccess(client, command, data)
    if not data then data = lia.command.list[command] end
    if not data then return false, "unknown" end
    local privilegeID = data.privilege or string.lower("command_" .. command)
    local superAdminOnly = data.superAdminOnly
    local adminOnly = data.adminOnly
    local accessLevels = superAdminOnly and "superadmin" or adminOnly and "admin" or "user"
    local privilegeName = data.privilege and L(data.privilege) or accessLevels == "user" and L("globalAccess") or L("accessTo", command)
    local hasAccess = true
    if accessLevels ~= "user" then
        if not isstring(privilegeID) then
            lia.error("Command '" .. tostring(command) .. "' has invalid privilege ID type: " .. tostring(privilegeID))
            return false, privilegeName
        end

        hasAccess = client:hasPrivilege(privilegeID)
    end

    local hookResult = hook.Run("CanPlayerUseCommand", client, command)
    if hookResult ~= nil then return hookResult, privilegeName end
    local char = IsValid(client) and client.getChar and client:getChar()
    if char then
        local faction = lia.faction.indices[char:getFaction()]
        if faction and faction.commands and faction.commands[command] then return true, privilegeName end
        local classData = lia.class.list[char:getClass()]
        if classData and classData.commands and classData.commands[command] then return true, privilegeName end
    end
    return hasAccess, privilegeName
end

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
    function lia.command.run(client, command, arguments)
        local commandTbl = lia.command.list[command:lower()]
        if commandTbl then
            local results = {commandTbl.onRun(client, arguments or {})}
            hook.Run("liaCommandRan", client, command, arguments or {}, results)
            local result = results[1]
            if isstring(result) then
                if IsValid(client) then
                    if result:sub(1, 1) == "@" then
                        client:notifyInfoLocalized(result:sub(2), unpack(results, 2))
                    else
                        client:notifyErrorLocalized(result)
                    end
                else
                    print(result)
                end
            end
        end
    end

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
                if not arguments then arguments = lia.command.extractArgs(text:sub(#match + 3)) end
                local fields = command.arguments or {}
                if IsValid(client) and client:IsPlayer() and #fields > 0 then
                    local tokens = combineBracketArgs(arguments)
                    local missing = {}
                    local prefix = {}
                    for i, field in ipairs(fields) do
                        local arg = tokens[i]
                        if not arg or isPlaceholder(arg) then
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
        local frameW, frameH = 600, 200 + numFields * 75
        local frame = vgui.Create("DFrame")
        frame:SetTitle("")
        frame:SetSize(frameW, frameH)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(false)
        frame.Paint = function(self, w, h)
            derma.SkinHook("Paint", "Frame", self, w, h)
            draw.SimpleText(L(cmdKey), "liaMediumFont", w / 2, 10, color_white, TEXT_ALIGN_CENTER)
        end

        local scroll = vgui.Create("DScrollPanel", frame)
        scroll:Dock(FILL)
        scroll:DockMargin(10, 40, 10, 10)
        surface.SetFont("liaSmallFont")
        local controls = {}
        local watchers = {}
        local validate
        for name, data in pairs(fields) do
            local fieldType = data.type
            local optional = data.optional
            local options = data.options
            local filter = data.filter
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 0, 5)
            panel:SetTall(70)
            panel.Paint = function() end
            local textW = select(1, surface.GetTextSize(L(data.description or name)))
            local ctrl
            if fieldType == "player" then
                ctrl = vgui.Create("DComboBox", panel)
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
                    ctrl:AddChoice(plyObj:Name(), plyObj:SteamID())
                end
            elseif fieldType == "table" then
                ctrl = vgui.Create("DComboBox", panel)
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
            elseif fieldType == "bool" then
                ctrl = vgui.Create("DCheckBox", panel)
            else
                ctrl = vgui.Create("DTextEntry", panel)
                ctrl:SetFont("liaSmallFont")
            end

            local label = vgui.Create("DLabel", panel)
            label:SetFont("liaSmallFont")
            label:SetText(L(data.description or name))
            label:SizeToContents()
            panel.PerformLayout = function(_, w, h)
                local ctrlH = 30
                ctrl:SetTall(ctrlH)
                local ctrlW = w * 0.7
                local totalW = textW + 10 + ctrlW
                local xOff = (w - totalW) / 2
                label:SetPos(xOff, (h - label:GetTall()) / 2)
                ctrl:SetPos(xOff + textW + 10, (h - ctrlH) / 2)
                ctrl:SetWide(ctrlW)
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

        local buttons = vgui.Create("DPanel", frame)
        buttons:Dock(BOTTOM)
        buttons:SetTall(90)
        buttons:DockPadding(15, 15, 15, 15)
        buttons.Paint = function() end
        local submit = vgui.Create("DButton", buttons)
        submit:Dock(LEFT)
        submit:DockMargin(0, 0, 15, 0)
        submit:SetWide(270)
        submit:SetText(L("submit"))
        submit:SetFont("liaSmallFont")
        submit:SetIcon("icon16/tick.png")
        submit:SetEnabled(false)
        validate = function()
            for _, data in pairs(controls) do
                if not data.optional then
                    local ctl = data.ctrl
                    local ftype = data.type
                    local filled
                    if ftype == "player" or ftype == "table" then
                        local txt, _ = ctl:GetSelected()
                        filled = txt ~= nil and txt ~= ""
                    elseif ftype == "bool" then
                        filled = true
                    else
                        filled = ctl:GetValue() ~= nil and ctl:GetValue() ~= ""
                    end

                    if not filled then
                        submit:SetEnabled(false)
                        return
                    end
                end
            end

            submit:SetEnabled(true)
        end

        for _, fn in ipairs(watchers) do
            fn()
        end

        validate()
        local cancel = vgui.Create("DButton", buttons)
        cancel:Dock(RIGHT)
        cancel:SetWide(270)
        cancel:SetText(L("cancel"))
        cancel:SetFont("liaSmallFont")
        cancel:SetIcon("icon16/cross.png")
        cancel.DoClick = function() frame:Remove() end
        submit.DoClick = function()
            local args = {}
            if prefix then table.Add(args, prefix) end
            for _, info in pairs(controls) do
                local ctl = info.ctrl
                local typ = info.type
                local val
                if typ == "player" or typ == "table" then
                    local _, dataVal = ctl:GetSelected()
                    val = dataVal or ctl:GetValue()
                elseif typ == "bool" then
                    val = ctl:GetChecked()
                else
                    val = ctl:GetValue()
                end

                args[#args + 1] = val ~= "" and val or nil
            end

            RunConsoleCommand("say", "/" .. cmdKey .. " " .. table.concat(args, " "))
            frame:Remove()
        end
    end

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
            local sheet = vgui.Create("liaSheet", parent)
            sheet:SetPlaceholderText(L("searchCommands"))
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
                    columns = {L("command"), L("description"), L("privilege")},
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
                            local right = privilege and privilege ~= L("globalAccess") and privilege or ""
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
-- Console Commands
if SERVER then
    concommand.Add("kickbots", function()
        for _, bot in player.Iterator() do
            if bot:IsBot() then lia.administrator.execCommand("kick", bot, nil, L("allBotsKicked")) end
        end
    end)

    concommand.Add("lia_reload", function(client)
        if IsValid(client) and not client:IsSuperAdmin() then
            client:notifyErrorLocalized("staffPermissionDenied")
            return
        end

        lia.loader.load()
        lia.information(L("configReloaded"))
    end)

    concommand.Add("lia_check_updates", function(client)
        if IsValid(client) and not client:IsSuperAdmin() then
            client:notifyErrorLocalized("staffPermissionDenied")
            return
        end

        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Checking for updates...\n")
        lia.loader.checkForUpdates()
    end)

    concommand.Add("plysetgroup", function(ply, _, args)
        local target = lia.util.findPlayer(ply, args[1])
        local usergroup = args[2]
        if not IsValid(ply) then
            if IsValid(target) then
                if lia.administrator.groups[usergroup] then
                    target.liaUserGroup = usergroup
                    target:notifyInfoLocalized("userGroupSet", usergroup)
                    lia.log.add(nil, "usergroup", target, usergroup)
                else
                    MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid usergroup '" .. usergroup .. "'\n")
                end
            else
                MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid player '" .. args[1] .. "'\n")
            end
        elseif ply:hasPrivilege("setUserGroup") then
            if IsValid(target) then
                if lia.administrator.groups[usergroup] then
                    target.liaUserGroup = usergroup
                    target:notifyInfoLocalized("userGroupSet", usergroup)
                    ply:notifyInfoLocalized("userGroupSetBy", target:getName(), usergroup)
                    lia.log.add(ply, "usergroup", target, usergroup)
                else
                    ply:notifyErrorLocalized("invalidUserGroup", usergroup)
                end
            else
                ply:notifyErrorLocalized("plyNoExist")
            end
        else
            ply:notifyErrorLocalized("noPerm")
        end
    end)

    concommand.Add("stopsoundall", function(client)
        if client:hasPrivilege("stopSoundForEveryone") then
            for _, v in player.Iterator() do
                v:ConCommand("stopsound")
            end
        else
            client:notifyErrorLocalized("noPerm")
        end
    end)

    concommand.Add("bots", function()
        timer.Create("Bots_Add_Timer", 2, 0, function()
            if #player.GetAll() < game.MaxPlayers() then
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

        lia.db.wipeTables()
        lia.information(L("dbWiped"))
    end)

    concommand.Add("lia_resetconfig", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.config.load(true)
        lia.information(L("configReloaded"))
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

            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), L("totalEntities") .. ": " .. totalEntities .. "\n")
        else
            client:notifyErrorLocalized("commandConsoleOnly")
        end
    end)

    concommand.Add("database_list", function(ply)
        if IsValid(ply) then return end
        lia.db.GetCharacterTable(function(columns)
            if #columns == 0 then
                lia.error(L("dbColumnsNone"))
            else
                lia.information(L("dbColumnsList"))
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

    concommand.Add("test_all_notifications", function()
        local notificationTypes = {
            {
                type = "default",
                message = "This is a default notification. It is being used to demonstrate the default notification type in the Lilia framework. The message is intentionally made longer to test the notification panel's ability to handle extended text and to ensure that the notification wraps and displays correctly for all users.",
                method = "notify"
            },
            {
                type = "info",
                message = "This is an information notification. It provides helpful information to the user about the current state of the system or game.",
                method = "notifyInfo"
            },
            {
                type = "warning",
                message = "This is a warning notification. It alerts the user to potential issues or important information that requires attention.",
                method = "notifyWarning"
            },
            {
                type = "error",
                message = "This is an error notification. It indicates that something has gone wrong and the user needs to take corrective action.",
                method = "notifyError"
            },
            {
                type = "success",
                message = "This is a success notification. It confirms that an action was completed successfully and provides positive feedback to the user.",
                method = "notifySuccess"
            }
        }

        for _, notification in ipairs(notificationTypes) do
            if notification.method == "notify" then
                lia.notifier.notify(notification.message, notification.type)
            else
                lia.notifier[notification.method](notification.message)
            end
        end
    end)

    concommand.Add("lia_redownload_assets", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.loader.downloadAssets()
        lia.information(L("assetsRedownloaded"))
    end)

    concommand.Add("test_existing_notifications", function(client)
        if IsValid(client) then
            client:notifyErrorLocalized("commandConsoleOnly")
            return
        end

        lia.notifier.notify(L("testNotification"))
        lia.notifier.notifyInfo(L("testNotificationInfo"))
        lia.notifier.notifyWarning(L("testNotificationWarning"))
        lia.notifier.notifyError(L("testNotificationError"))
        lia.notifier.notifySuccess(L("testNotificationSuccess"))
    end)

    concommand.Add("print_vector", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] Error: This command can only be used by players.\n")
            return
        end

        local pos = client:GetPos()
        local vec = Vector(pos.x, pos.y, pos.z)
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Vector: " .. tostring(vec) .. "\n")
    end)

    concommand.Add("print_angle", function(client)
        if not IsValid(client) then
            MsgC(Color(255, 0, 0), "[Lilia] Error: This command can only be used by players.\n")
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
        lia.db.snapshotTable(tableName)
    end)

    concommand.Add("lia_snapshot_load", function(_, _, args)
        if not args[1] then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Usage: lia_snapshot_load <filename>\n")
            MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Available snapshots:\n")
            local files = file.Find("lilia/snapshots/*", "DATA")
            for _, fileName in ipairs(files) do
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), fileName .. "\n")
            end
            return
        end

        local fileName = args[1]
        lia.db.loadSnapshot(fileName)
    end)

    concommand.Add("lia_add_door_group_column", function()
        MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Adding door_group column to lia_doors table...\n")
        lia.db.fieldExists("lia_doors", "door_group"):next(function(exists)
            if not exists then
                lia.db.query("ALTER TABLE lia_doors ADD COLUMN door_group TEXT DEFAULT 'default'"):next(function() MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "Successfully added door_group column.\n") end, function(error) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to add door_group column: " .. error .. "\n") end)
            else
                MsgC(Color(83, 143, 239), "[Lilia] ", Color(255, 255, 255), "door_group column already exists.\n")
            end
        end, function(error) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Failed to check door_group column: " .. error .. "\n") end)
    end)
else
    -- Client-only commands
    concommand.Add("weighpoint_stop", function() hook.Remove("HUDPaint", "WeighPoint") end)
    concommand.Add("lia_vgui_cleanup", function()
        for _, v in pairs(vgui.GetWorldPanel():GetChildren()) do
            if not (v.Init and debug.getinfo(v.Init, "Sln").short_src:find("chatbox")) then v:Remove() end
        end
    end)

    concommand.Add("lia_open_derma_preview", function()
        if IsValid(dermaPreviewFrame) then dermaPreviewFrame:Remove() end
        local frame = vgui.Create("DFrame")
        frame:SetTitle(L("dermaPreviewTitle"))
        frame:SetSize(800, 600)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(true)
        local scroll = vgui.Create("DScrollPanel", frame)
        scroll:Dock(FILL)
        local elements = {"DButton", "DLabel", "DTextEntry", "DCheckBox", "DRadioButton", "DNumSlider", "DComboBox", "DListView", "DPanel", "DFrame", "DPropertySheet", "DTree", "DMenuBar", "DToolBar", "DProgress", "DHorizontalDivider", "DVerticalDivider"}
        for _, element in ipairs(elements) do
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(50)
            panel:DockMargin(5, 5, 5, 5)
            panel.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50, 150)) end
            local label = vgui.Create("DLabel", panel)
            label:SetText(element)
            label:Dock(LEFT)
            label:DockMargin(10, 0, 0, 0)
            label:SizeToContents()
            local button = vgui.Create("DButton", panel)
            button:Dock(RIGHT)
            button:DockMargin(0, 5, 10, 5)
            button:SetWide(100)
            button:SetText(L("test"))
            button.DoClick = function()
                local testElement = vgui.Create(element, panel)
                testElement:Dock(FILL)
                testElement:DockMargin(5, 5, 5, 5)
            end
        end
    end)

    concommand.Add("lia_open_mantle_preview", function()
        if IsValid(mantlePreviewFrame) then mantlePreviewFrame:Remove() end
        local frame = vgui.Create("DFrame")
        frame:SetTitle(L("mantleDermaPreviewTitle", "Mantle Derma Elements Preview"))
        frame:SetSize(800, 600)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(true)
        local scroll = vgui.Create("DScrollPanel", frame)
        scroll:Dock(FILL)
        local elements = {"liaButton", "liaLabel", "liaTextEntry", "liaCheckBox", "liaComboBox", "liaListView", "liaPanel", "liaFrame", "liaSheet", "liaToolbar"}
        for _, element in ipairs(elements) do
            local panel = vgui.Create("DPanel", scroll)
            panel:Dock(TOP)
            panel:SetTall(50)
            panel:DockMargin(5, 5, 5, 5)
            panel.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50, 150)) end
            local label = vgui.Create("DLabel", panel)
            label:SetText(element)
            label:Dock(LEFT)
            label:DockMargin(10, 0, 0, 0)
            label:SizeToContents()
            local button = vgui.Create("DButton", panel)
            button:Dock(RIGHT)
            button:DockMargin(0, 5, 10, 5)
            button:SetWide(100)
            button:SetText(L("test"))
            button.DoClick = function()
                local testElement = vgui.Create(element, panel)
                testElement:Dock(FILL)
                testElement:DockMargin(5, 5, 5, 5)
            end
        end
    end)

    -- Websound commands
    concommand.Add("lia_saved_sounds", function()
        local files = file.Find(baseDir .. "*", "DATA")
        if not files or #files == 0 then return end
        local f = vgui.Create("DFrame")
        f:SetTitle(L("savedSounds"))
        f:SetSize(500, 400)
        f:Center()
        f:MakePopup()
        local list = vgui.Create("DListView", f)
        list:Dock(FILL)
        list:DockMargin(5, 5, 5, 5)
        list:AddColumn(L("soundName"))
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".dat") then list:AddLine(string.StripExtension(fileName)) end
        end
    end)

    concommand.Add("lia_wipe_sounds", function()
        local files = file.Find(baseDir .. "*", "DATA")
        for _, fn in ipairs(files) do
            file.Delete(baseDir .. fn)
        end

        LocalPlayer():ChatPrint(L("soundsWiped"))
    end)

    concommand.Add("lia_validate_sounds", function()
        local files = file.Find(baseDir .. "**", "DATA")
        local validCount = 0
        local invalidCount = 0
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".dat") then
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
        local files = file.Find(baseDir .. "**", "DATA")
        local removedCount = 0
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".dat") then
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
        local files = file.Find(baseDir .. "**", "DATA")
        if #files == 0 then return end
        LocalPlayer():ChatPrint("Saved sounds:")
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".dat") then LocalPlayer():ChatPrint("  " .. string.StripExtension(fileName)) end
        end
    end)

    -- Webimage commands
    concommand.Add("lia_saved_images", function()
        local files = findImagesRecursive(baseDir)
        if not files or #files == 0 then return end
        local f = vgui.Create("DFrame")
        f:SetTitle(L("savedImages"))
        f:SetSize(500, 400)
        f:Center()
        f:MakePopup()
        local list = vgui.Create("DListView", f)
        list:Dock(FILL)
        list:DockMargin(5, 5, 5, 5)
        list:AddColumn(L("imageName"))
        for _, fileName in ipairs(files) do
            if string.EndsWith(fileName, ".png") or string.EndsWith(fileName, ".jpg") or string.EndsWith(fileName, ".jpeg") then list:AddLine(string.StripExtension(fileName)) end
        end
    end)

    concommand.Add("lia_cleanup_images", function()
        local files = findImagesRecursive(baseDir)
        local removedCount = 0
        for _, filePath in ipairs(files) do
            if not file.Exists(filePath, "DATA") then removedCount = removedCount + 1 end
        end

        LocalPlayer():ChatPrint(string.format("Found %d image files", #files))
    end)

    concommand.Add("lia_wipewebimages", function()
        deleteDirectoryRecursive(baseDir)
        cache = {}
        urlMap = {}
        LocalPlayer():ChatPrint(L("webImagesWiped"))
    end)

    concommand.Add("test_webimage_menu", function()
        local frame = vgui.Create("DFrame")
        frame:SetTitle(L("webImageTesterTitle"))
        frame:SetSize(500, 400)
        frame:Center()
        frame:MakePopup()
        local textEntry = vgui.Create("DTextEntry", frame)
        textEntry:Dock(TOP)
        textEntry:DockMargin(5, 5, 5, 5)
        textEntry:SetPlaceholderText(L("webImageTesterURL"))
        local button = vgui.Create("DButton", frame)
        button:Dock(TOP)
        button:DockMargin(5, 0, 5, 5)
        button:SetText(L("webImageTesterLoad"))
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
end