lia.db.query([[
    CREATE TABLE IF NOT EXISTS lia_chardata (
        _charID INTEGER NOT NULL,
        _key VARCHAR(255) NOT NULL,
        _value TEXT(1024),
        PRIMARY KEY (_charID, _key)
    );
]])
--local CHARACTER = lia.meta.character
--hook.Add("PlayerLoadedChar", "givePlayerData", function(ply, character)
--  local characterData = character:getData()
--  local keysToNetwork = table.GetKeys(characterData)
-- net.Start("liaCharacterData")
--   net.WriteUInt(character:getID(), 32)
--  net.WriteUInt(#keysToNetwork, 32)
--  for _, key in ipairs(keysToNetwork) do
--       local value = characterData[key]
--       net.WriteString(key)
--       net.WriteType(value)
--    end
-- net.Send(ply)
--end)
-- THIS BIT ONLY REALLY NEEDS HE db query at the top the rest is in lilia/mainmenu/sv_hooks.lua
-- THIS HAS TO BE KEPT IN as for some reason lilia likes giving two types of data (before, and after) -- so the after is stuff like pet
-- but this gives the other flags and ehh... i don't know what else
hook.Add("PlayerLoadedChar", "loadCharacterDataCharDataUsage", function(ply, character)
    local charID = character:getID()
    lia.db.query("SELECT _key, _value FROM lia_chardata WHERE _charID = " .. charID, function(data)
        if data then
            if not character.dataVars then character.dataVars = {} end
            for _, row in ipairs(data) do
                local decodedValue = pon.decode(row._value)
                character.dataVars[row._key] = decodedValue[1]
                character:setData(row._key, decodedValue[1])
            end

            local characterData = character:getData()
            local keysToNetwork = table.GetKeys(characterData)
            net.Start("liaCharacterData")
            net.WriteUInt(charID, 32)
            net.WriteUInt(#keysToNetwork, 32)
            for _, key in ipairs(keysToNetwork) do
                local value = characterData[key]
                net.WriteString(key)
                net.WriteType(value)
            end

            net.Send(ply)
            -- ply:ChatPrint("Your character data has been loaded. You are now ready to play.")
        else
            print("No data found for character ID:", charID)
        end
    end)
end)