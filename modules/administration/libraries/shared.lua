local meta = FindMetaTable("Player")
function meta:hasPermission(cmd)
    return lia.admin.permissions[self:GetUserGroup()] and lia.admin.permissions[self:GetUserGroup()]["permissions"][cmd] or false
end

function MODULE:CanPlayerModifyConfig(client)
    return client:hasPrivilege("Staff Permissions - Access Edit Configuration Menu")
end

function MODULE:InitializedModules()
    for cmd, info in next, lia.command.list do
        if info.group or info.superAdminOnly or info.adminOnly then
            info.onCheckAccess = function(client) return client:hasPermission(cmd) end
            info.onRun = function(client, arguments)
                if not info.onCheckAccess(client) then
                    return "@noPerm"
                else
                    return info._onRun(client, arguments)
                end
            end

            lia.admin.commands[cmd] = true
        end
    end

    lia.command.findPlayer = function(client, name)
        local calling_func = debug.getinfo(2)
        local command
        local target = type(name) == "string" and lia.util.findPlayer(name) or NULL
        for cmd, info in next, lia.command.list do
            if info._onRun == calling_func.func then command = info end
        end

        if IsValid(target) then
            if command and (command.adminOnly or command.superAdminOnly) then
                local target_group = lia.admin.permissions[target:GetUserGroup()]
                local client_group = lia.admin.permissions[client:GetUserGroup()]
                if target_group.position < client_group.position then
                    client:notifyLocalized("plyCantTarget")
                    return
                end
            end
            return target
        else
            client:notifyLocalized("plyNoExist")
        end
    end
end

concommand.Add("plysetgroup", function(ply, cmd, args)
    if not IsValid(ply) then
        local target = lia.util.findPlayer(args[1])
        if IsValid(target) then
            if lia.admin.permissions[args[2]] then
                lia.admin.setPlayerGroup(target, args[2])
            else
                MsgC(Color(200, 20, 20), "[Lilia Administration] Error: usergroup not found.\n")
            end
        else
            MsgC(Color(200, 20, 20), "[Lilia Administration] Error: specified player not found.\n")
        end
    end
end)

concommand.Add("createownergroup", function(ply, cmd, args)
    if not IsValid(ply) then
        lia.admin.createGroup("owner", {
            position = 0,
            admin = false,
            superadmin = true,
            permissions = {},
        })

        for cmd, _ in next, lia.admin.commands do
            lia.admin.permissions["owner"].permissions[cmd] = true
        end

        lia.admin.save(true)
    end
end)

concommand.Add("wipegroups", function(ply, cmd, args)
    if not IsValid(ply) then
        for k, v in next, player.GetAll() do
            v:SetUserGroup("user")
        end

        lia.admin.permissions = {}
        lia.admin.save(true)
    end
end)

properties.Add("TogglePropBlacklist", {
    MenuLabel = L("TogglePropBlacklist"),
    Order = 900,
    MenuIcon = "icon16/link.png",
    Filter = function(_, ent, ply) return IsValid(ent) and ent:GetClass() == "prop_physics" and ply:hasPrivilege("Staff Permissions - Manage Prop Blacklist") end,
    Action = function(self, ent)
        self:MsgStart()
        net.WriteString(ent:GetModel())
        self:MsgEnd()
    end,
    Receive = function(_, _, ply)
        if not ply:hasPrivilege("Staff Permissions - Manage Prop Blacklist") then return end
        local model = net.ReadString()
        local list = lia.data.get("blacklist", {}, true, true)
        if table.HasValue(list, model) then
            table.RemoveByValue(list, model)
            lia.data.set("blacklist", list, true, true)
            ply:notifyLocalized("removedFromBlacklist", model)
        else
            table.insert(list, model)
            lia.data.set("blacklist", list, true, true)
            ply:notifyLocalized("addedToBlacklist", model)
        end
    end
})

properties.Add("copytoclipboard", {
    MenuLabel = "Copy Model to Clipboard",
    Order = 999,
    MenuIcon = "icon16/cup.png",
    Filter = function(_, ent)
        if ent == nil then return false end
        if not IsValid(ent) then return false end
        return true
    end,
    Action = function(self, ent)
        self:MsgStart()
        local s = ent:GetModel()
        SetClipboardText(s)
        print(s)
        self:MsgEnd()
    end,
    Receive = function() end
})