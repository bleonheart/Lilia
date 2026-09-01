if SERVER then
    local function sanitizeFlags(flags)
        if not flags then return "" end
        local cleaned = tostring(flags):gsub("%s", "")
        local seen = {}
        local result = ""
        for i = 1, #cleaned do
            local flag = cleaned:sub(i, i)
            if not seen[flag] then
                seen[flag] = true
                result = result .. flag
            end
        end
        return result
    end

    local function mergeFlags(existing, additions)
        existing = sanitizeFlags(existing)
        additions = sanitizeFlags(additions)
        if additions == "" then return existing, "" end
        local seen = {}
        for i = 1, #existing do
            local flag = existing:sub(i, i)
            seen[flag] = true
        end

        local appended = ""
        for i = 1, #additions do
            local flag = additions:sub(i, i)
            if not seen[flag] then
                seen[flag] = true
                appended = appended .. flag
            end
        end

        if appended ~= "" then existing = existing .. appended end
        return existing, appended
    end

    local function normalizeSteamID(value)
        if not value or value == "" then return nil end
        if value:find("^%d+$") then
            local converted = util.SteamIDFrom64(value)
            if converted and converted ~= "STEAM_0:0:0" then return converted end
        end
        return value
    end

    local function findPlayerBySteamID(steamID)
        local steamID64 = util.SteamIDTo64(steamID)
        for _, ply in player.Iterator() do
            if ply:SteamID() == steamID or ply:SteamID64() == steamID64 then return ply end
        end
    end

    local function appendPermanentFlags(steamID, flagsStr)
        local normalized = normalizeSteamID(steamID)
        if not normalized then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Invalid SteamID supplied.\n")
            return
        end

        local cleanedFlags = sanitizeFlags(flagsStr)
        if cleanedFlags == "" then
            MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "No flags provided.\n")
            return
        end

        local target = findPlayerBySteamID(normalized)
        if target then
            local merged, appended = mergeFlags(target:getLiliaData("permanentflags", ""), cleanedFlags)
            if appended == "" then
                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "No new flags to add for " .. normalized .. ".\n")
                return
            end

            target:setLiliaData("permanentflags", merged)
            local char = target:getChar()
            if char then char:giveFlags(appended) end
            MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added flags '" .. appended .. "' to " .. normalized .. ".\n")
            return
        end

        lia.db.selectOne({"data"}, "players", "steamID = " .. lia.db.convertDataType(normalized)):next(function(row)
            local data = {}
            if row and row.data then
                if isstring(row.data) then
                    data = util.JSONToTable(row.data) or {}
                elseif istable(row.data) then
                    data = row.data
                end
            end

            if not istable(data) then data = {} end
            local existingFlags = data.permanentflags or ""
            local merged, appended = mergeFlags(existingFlags, cleanedFlags)
            if appended == "" then
                MsgC(Color(255, 165, 0), "[Lilia] ", Color(255, 255, 255), "No new flags to add for " .. normalized .. ". Existing flags: '" .. existingFlags .. "', Attempted to add: '" .. cleanedFlags .. "'\n")
                return
            end

            data.permanentflags = merged
            if row then
                lia.db.updateTable({
                    data = util.TableToJSON(data)
                }, nil, "players", "steamID = " .. lia.db.convertDataType(normalized)):next(function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Added flags '" .. appended .. "' to " .. normalized .. ". New flags: '" .. merged .. "'\n") end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error updating flags for " .. normalized .. ": " .. tostring(err) .. "\n") end)
            else
                lia.db.insertTable({
                    steamID = normalized,
                    data = util.TableToJSON(data)
                }, nil, "players"):next(function() MsgC(Color(0, 255, 0), "[Lilia] ", Color(255, 255, 255), "Created player entry and added flags '" .. appended .. "' to " .. normalized .. ". New flags: '" .. merged .. "'\n") end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Error creating player entry for " .. normalized .. ": " .. tostring(err) .. "\n") end)
            end
        end):catch(function(err) MsgC(Color(255, 0, 0), "[Lilia] ", Color(255, 255, 255), "Database error while checking player " .. normalized .. ": " .. tostring(err) .. "\n") end)
    end

    concommand.Add("lia_givepermaflags", function(client, _, args)
        lia.debug("[Permissions]", "Permission Check for concommand lia_givepermaflags", "isValidPlayer=", tostring(IsValid(client)), "isSuperAdmin=", tostring(IsValid(client) and client:IsSuperAdmin() or true), "finalResult=", tostring(not IsValid(client) or client:IsSuperAdmin()))
        if IsValid(client) and not client:IsSuperAdmin() then return end
        appendPermanentFlags(args[1], args[2])
    end)


