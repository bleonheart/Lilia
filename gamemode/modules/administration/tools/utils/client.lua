function MODULE:ShowPlayerOptions(target, options)
    local client = LocalPlayer()
    if (client:hasPrivilege("Can Access Scoreboard Info Out Of Staff") or client:hasPrivilege("Can Access Scoreboard Admin Options") and client:isStaffOnDuty()) and IsValid(target) then
        local orderedOptions = {
            {
                name = L("nameCopyFormat", target:Name()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "Name"))
                    SetClipboardText(target:Name())
                end
            },
            {
                name = L("charIDCopyFormat", target:getChar() and target:getChar():getID() or L("na")),
                image = "icon16/page_copy.png",
                func = function()
                    if target:getChar() then
                        client:ChatPrint(L("copiedCharID", target:getChar():getID()))
                        SetClipboardText(target:getChar():getID())
                    end
                end
            },
            {
                name = L("steamIDCopyFormat", target:SteamID()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "SteamID"))
                    SetClipboardText(target:SteamID())
                end
            },
            {
                name = L("steamID64CopyFormat", target:SteamID64()),
                image = "icon16/page_copy.png",
                func = function()
                    client:ChatPrint(L("copiedToClipboard", target:Name(), "SteamID64"))
                    SetClipboardText(target:SteamID64())
                end
            },
            {
                name = "Blind",
                image = "icon16/eye.png",
                func = function() lia.admin.execCommand("blind", target) end
            },
            {
                name = "Freeze",
                image = "icon16/lock.png",
                func = function() lia.admin.execCommand("freeze", target) end
            },
            {
                name = "Gag",
                image = "icon16/sound_mute.png",
                func = function() lia.admin.execCommand("gag", target) end
            },
            {
                name = "Ignite",
                image = "icon16/fire.png",
                func = function() lia.admin.execCommand("ignite", target) end
            },
            {
                name = "Jail",
                image = "icon16/lock.png",
                func = function() lia.admin.execCommand("jail", target) end
            },
            {
                name = "Mute",
                image = "icon16/sound_delete.png",
                func = function() lia.admin.execCommand("mute", target) end
            },
            {
                name = "Slay",
                image = "icon16/bomb.png",
                func = function() lia.admin.execCommand("slay", target) end
            },
            {
                name = "Unblind",
                image = "icon16/eye.png",
                func = function() lia.admin.execCommand("unblind", target) end
            },
            {
                name = "Ungag",
                image = "icon16/sound_low.png",
                func = function() lia.admin.execCommand("ungag", target) end
            },
            {
                name = "Unfreeze",
                image = "icon16/accept.png",
                func = function() lia.admin.execCommand("unfreeze", target) end
            },
            {
                name = "Unmute",
                image = "icon16/sound_add.png",
                func = function() lia.admin.execCommand("unmute", target) end
            },
            {
                name = "Bring",
                image = "icon16/arrow_down.png",
                func = function() lia.admin.execCommand("bring", target) end
            },
            {
                name = "Goto",
                image = "icon16/arrow_right.png",
                func = function() lia.admin.execCommand("goto", target) end
            },
            {
                name = "Respawn",
                image = "icon16/arrow_refresh.png",
                func = function() lia.admin.execCommand("respawn", target) end
            },
            {
                name = L("return"),
                image = "icon16/arrow_redo.png",
                func = function() lia.admin.execCommand("return", target) end
            },
            {
                name = L("characterList"),
                image = "icon16/user.png",
                func = function() RunConsoleCommand("say", "/charlist " .. target:SteamID()) end
            }
        }

        if client:IsSuperAdmin() or client:hasPrivilege("Manage UserGroups") then
            table.insert(orderedOptions, {
                name = L("setUsergroup"),
                image = "icon16/group_edit.png",
                func = function()
                    net.Start("liaRequestPlayerGroup")
                    net.WriteEntity(target)
                    net.SendToServer()
                end
            })
        end

        for _, option in ipairs(orderedOptions) do
            table.insert(options, option)
        end
    end
end
