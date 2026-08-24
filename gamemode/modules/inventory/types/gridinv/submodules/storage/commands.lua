
-- Storage command registrations.
lia.command.add("storagepasswordremove", {
    adminOnly = true,
    desc = "@storagePasswordRemoveDesc",
    arguments = {},
    onRun = function(client)
        local trace = client:GetEyeTrace()
        local entity = trace.Entity
        if not IsValid(entity) or trace.HitPos:Distance(client:GetPos()) > 128 then
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        if not entity.password then
            client:notifyErrorLocalized("storageNotLocked")
            return
        end

        entity.password = nil
        entity:setNetVar("locked", false)
        client:notifySuccessLocalized("storageUnlocked")
        lia.log.add(client, "storagePasswordRemoved", entity:GetClass())
        hook.Run("UpdateEntityPersistence", entity)
    end
})

lia.command.add("storagepasswordchange", {
    adminOnly = true,
    desc = "@storagePasswordChangeDesc",
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
            client:notifyErrorLocalized("invalidTarget")
            return
        end

        if not newPassword or newPassword == "" then
            client:notifyErrorLocalized("invalidPassword")
            return
        end

        entity.password = newPassword
        entity:setNetVar("locked", true)
        client:notifySuccessLocalized("storagePasswordChanged")
        lia.log.add(client, "storagePasswordChanged", entity:GetClass())
        hook.Run("UpdateEntityPersistence", entity)
    end
})

