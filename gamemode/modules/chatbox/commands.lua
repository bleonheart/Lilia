﻿local MODULE = MODULE
lia.command.add("banooc", {
    adminOnly = true,
    privilege = "Ban OOC",
    desc = "banOOCCommandDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "banOOCCommandName",
        Category = "moderationTools",
        SubCategory = "oocCategory",
        Icon = "icon16/sound_mute.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:setLiliaData("oocBan", true)
        client:notifyLocalized("playerBannedFromOOC", target:Name())
        lia.log.add(client, "banOOC", target:Name(), target:SteamID64())
    end
})

lia.command.add("unbanooc", {
    adminOnly = true,
    privilege = "Unban OOC",
    desc = "unbanOOCCommandDesc",
    syntax = "[player Name]",
    AdminStick = {
        Name = "unbanOOCCommandName",
        Category = "moderationTools",
        SubCategory = "oocCategory",
        Icon = "icon16/sound.png"
    },
    onRun = function(client, arguments)
        local target = lia.util.findPlayer(client, arguments[1])
        if not target or not IsValid(target) then
            client:notifyLocalized("targetNotFound")
            return
        end

        target:setLiliaData("oocBan", false)
        client:notifyLocalized("playerUnbannedFromOOC", target:Name())
        lia.log.add(client, "unbanOOC", target:Name(), target:SteamID64())
    end
})

lia.command.add("blockooc", {
    superAdminOnly = true,
    privilege = "Block OOC",
    desc = "blockOOCCommandDesc",
    onRun = function(client)
        local blocked = GetGlobalBool("oocblocked", false)
        SetGlobalBool("oocblocked", not blocked)
        client:notify(blocked and L("unlockedOOC") or L("blockedOOC"))
        lia.log.add(client, "blockOOC", not blocked)
    end
})

lia.command.add("clearchat", {
    adminOnly = true,
    privilege = "Clear Chat",
    desc = "clearChatCommandDesc",
    onRun = function(client)
        net.Start("RegenChat")
        net.Broadcast()
        lia.log.add(client, "clearChat")
    end
})
