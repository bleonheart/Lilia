if not SERVER or not prone then return end
print("[Lilia] Loaded Prone compatibility.")
hook.Add("DoPlayerDeath", "liaProne", function(client) if client:IsProne() then prone.Exit(client) end end)
hook.Add("PlayerLoadedChar", "liaProne", function(client) if client:IsProne() then prone.Exit(client) end end)
