lia.administrator = lia.administrator or {}
lia.administrator.groups = lia.administrator.groups or {}
lia.administrator.DefaultGroups = {
    user = true,
    admin = true,
    superadmin = true
}

local function shouldGrant(group, minAccess)
    if group == "superadmin" then return true end
    if group == "admin" and minAccess ~= "superadmin" then return true end
    return minAccess == "user"
end

function lia.administrator.save(noNetwork)
    lia.db.upsert({
        usergroups = util.TableToJSON(lia.administrator.groups)
    }, "admin")

    if not noNetwork and SERVER then lia.administrator.sync() end
end

function lia.administrator.ensureDefaultGroups()
    local defaults = {"user", "admin", "superadmin"}
    local created = false
    if table.Count(lia.administrator.groups) == 0 then
        for _, name in ipairs(defaults) do
            lia.administrator.createGroup(name)
        end

        created = true
    else
        for _, name in ipairs(defaults) do
            if not lia.administrator.groups[name] then
                lia.administrator.createGroup(name)
                created = true
            end
        end
    end

    if created then lia.administrator.save() end
end

function lia.administrator.load()
    lia.db.selectOne({"usergroups"}, "admin"):next(function(res)
        local groups = res and util.JSONToTable(res.usergroups or "") or {}
        lia.administrator.groups = groups
        lia.administrator.ensureDefaultGroups()
        lia.bootstrap("Administration", L("adminSystemLoaded"))
    end)
end

function lia.administrator.createGroup(name)
    if lia.administrator.groups[name] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administrator.groups[name] = {}
    if SERVER then lia.administrator.save() end
end

function lia.administrator.removeGroup(name)
    if lia.administrator.DefaultGroups[name] then
        lia.error("[Lilia Administration] The base usergroups cannot be removed!\n")
        return
    end

    if not lia.administrator.groups[name] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    lia.administrator.groups[name] = nil
    if SERVER then lia.administrator.save() end
end

function lia.administrator.renameGroup(oldName, newName)
    if lia.administrator.DefaultGroups[oldName] then
        lia.error("[Lilia Administration] The base usergroups cannot be renamed!\n")
        return
    end

    if not lia.administrator.groups[oldName] then
        lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
        return
    end

    if lia.administrator.groups[newName] then
        lia.error("[Lilia Administration] This usergroup already exists!\n")
        return
    end

    lia.administrator.groups[newName] = lia.administrator.groups[oldName]
    lia.administrator.groups[oldName] = nil
    if SERVER then lia.administrator.save() end
end

if SERVER then
    function lia.administrator.addPermission(group, permission)
        if not lia.administrator.groups[group] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administrator.DefaultGroups[group] then return end
        lia.administrator.groups[group][permission] = true
        lia.administrator.save()
    end

    function lia.administrator.removePermission(group, permission)
        if not lia.administrator.groups[group] then
            lia.error("[Lilia Administration] This usergroup doesn't exist!\n")
            return
        end

        if lia.administrator.DefaultGroups[group] then return end
        lia.administrator.groups[group][permission] = nil
        lia.administrator.save()
    end

    function lia.administrator.registerPrivilege(priv)
        if not priv or not priv.Name then return end
        local minAccess = priv.MinAccess or "user"
        for groupName in pairs(lia.administrator.groups) do
            if shouldGrant(groupName, minAccess) then lia.administrator.groups[groupName][priv.Name] = true end
        end

        lia.administrator.save()
    end

    function lia.administrator.sync(client)
        if client and IsValid(client) then
            lia.net.writeBigTable(client, "updateAdminGroups", lia.administrator.groups)
        else
            for _, ply in ipairs(player.GetHumans()) do
                lia.net.writeBigTable(ply, "updateAdminGroups", lia.administrator.groups)
            end
        end
    end

    net.Receive("liaGroupsRequest", function(_, ply) lia.administrator.sync(ply) end)
else
    function lia.administrator.execCommand(cmd, victim, dur, reason)
        if hook.Run("RunAdminSystemCommand") == true then return end
        local id = IsValid(victim) and victim:SteamID() or tostring(victim)
        local args = {"'" .. id .. "'"}
        if dur then table.insert(args, tostring(dur)) end
        if reason then table.insert(args, "'" .. tostring(reason) .. "'") end
        RunConsoleCommand("say", "/ply" .. cmd, unpack(args))
        return true
    end
end

hook.Add("PopulateAdminTabs", "liaAdmin", function(pages)
    if not IsValid(LocalPlayer()) then return end
    pages[#pages + 1] = {
        name = L("userGroups"),
        drawFunc = function(parent)
            lia.gui.usergroups = parent
            parent:Clear()
            parent:DockPadding(10, 10, 10, 10)
            parent.Paint = function(p, w, h) derma.SkinHook("Paint", "Frame", p, w, h) end
            net.Start("liaGroupsRequest")
            net.SendToServer()
        end
    }
end)