-- Storage command registrations.
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
