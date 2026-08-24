if SERVER then
    MODULE.ActiveTickets = MODULE.ActiveTickets or {}

    function MODULE:SendPopup(client, message)
        for _, v in player.Iterator() do
            local hasAlwaysSeeTickets = v:hasPrivilege("alwaysSeeTickets")
            local isStaffOnDuty = v:isStaffOnDuty()
            local permission = hasAlwaysSeeTickets or isStaffOnDuty
            lia.debug("[Permissions]", "Permission Check for function SendPopup ticket recipient", "targetPlayer=", tostring(v:Name()), "hasPrivilege(alwaysSeeTickets)=", tostring(hasAlwaysSeeTickets), "isStaffOnDuty=", tostring(isStaffOnDuty), "finalResult=", tostring(permission))
            if permission then
                net.Start("liaTicketSystem")
                net.WriteEntity(client)
                net.WriteString(message)
                net.WriteEntity(client.CaseClaimed)
                net.Send(v)
            end
        end

        if IsValid(client) and client:IsPlayer() then
            local requesterSteamID = client:SteamID()
            self.ActiveTickets[requesterSteamID] = {
                timestamp = os.time(),
                requester = requesterSteamID,
                admin = client.CaseClaimed and IsValid(client.CaseClaimed) and client.CaseClaimed:SteamID() or nil,
                message = message
            }

            hook.Run("OnTicketCreated", client, message)
        end
    end

    lia.command.add("ticket", {
        arguments = {
            {
                name = "text",
                type = "string"
            },
        },
        desc = "@ticketDesc",
        onRun = function(client, arguments)
            local message = table.concat(arguments, " ")
            if not message or message == "" then
                client:notifyErrorLocalized("mustProvideString")
                return
            end

            ClientAddText(client, Color(70, 0, 130), L("you"), Color(151, 211, 255), " " .. L("ticketMessageToAdmins") .. ": ", Color(0, 255, 0), message)
            MODULE:SendPopup(client, message)
        end
    })
end

-- Ticket and claim command registrations.
lia.command.add("viewtickets", {
    adminOnly = true,
    desc = "@viewTicketsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyErrorLocalized("specifyPlayer")
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
                client:notifyInfoLocalized("noTicketsFound")
                return
            end

            local ticketsData = {}
            for _, ticket in ipairs(tickets) do
                ticketsData[#ticketsData + 1] = {
                    timestamp = os.date("%Y-%m-%d %H:%M:%S", ticket.timestamp),
                    admin = string.format("%s (%s)", ticket.admin or L("na"), ticket.adminSteamID or L("na")),
                    message = ticket.message or ""
                }
            end

            lia.util.sendTableUI(client, L("ticketsForTitle", displayName), {
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
    desc = "@plyViewClaimsDesc",
    arguments = {
        {
            name = "name",
            type = "player"
        },
    },
    AdminStick = {
        Name = "@viewTicketClaims",
        ButtonText = "View Ticket Claims",
        Category = "Tickets",
    },
    onRun = function(client, arguments)
        local targetName = arguments[1]
        if not targetName then
            client:notifyErrorLocalized("specifyPlayer")
            return
        end

        local target = lia.util.findPlayer(client, targetName)
        if not target or not IsValid(target) then
            client:notifyErrorLocalized("targetNotFound")
            return
        end

        local steamID = target:SteamID()
        lia.module.get("administration"):GetAllCaseClaims():next(function(caseclaims)
            local claim = caseclaims[steamID]
            if not claim then
                client:notifyInfoLocalized("noClaimsFound")
                return
            end

            local claimsData = {
                {
                    steamID = steamID,
                    name = claim.name,
                    claims = claim.claims,
                    lastclaim = os.date("%Y-%m-%d %H:%M:%S", claim.lastclaim),
                    timeSinceLastClaim = lia.time.timeSince(claim.lastclaim),
                    claimedFor = table.IsEmpty(claim.claimedFor) and L("none") or table.concat((function()
                        local t = {}
                        for sid, name in pairs(claim.claimedFor) do
                            table.insert(t, string.format("%s (%s)", name, sid))
                        end
                        return t
                    end)(), "\n")
                }
            }

            lia.util.sendTableUI(client, L("claimsForTitle", target:Nick()), {
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
    desc = "@viewAllClaimsDesc",
    onRun = function(client)
        lia.module.get("administration"):GetAllCaseClaims():next(function(caseclaims)
            if table.IsEmpty(caseclaims) then
                client:notifyInfoLocalized("noClaimsRecorded")
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
                    claimedFor = table.IsEmpty(claim.claimedFor) and L("none") or table.concat((function()
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
    desc = "@viewClaimsDesc",
    onRun = function(client)
        lia.module.get("administration"):GetAllCaseClaims():next(function(caseclaims)
            if table.IsEmpty(caseclaims) then
                client:notifyInfoLocalized("noClaimsData")
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
                    claimedFor = table.IsEmpty(claim.claimedFor) and L("none") or table.concat((function()
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

