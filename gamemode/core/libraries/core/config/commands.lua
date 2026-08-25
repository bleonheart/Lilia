if SERVER then
concommand.Add("lia_wipeconfig", function(client)
        if IsValid(client) then
            client:notifyError("This command can only be run from the server console.")
            return
        end

        lia.config.reset()
        lia.information("All configuration has been wiped!")
    end)
end

