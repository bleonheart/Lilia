function lia.util.normalizeBodygroupKey(key)
    local numericKey = tonumber(key)
    if numericKey ~= nil then return numericKey end
    if isstring(key) and key ~= "" then return string.Trim(key) end
end

function lia.util.resolveBodygroupIndex(target, identifier)
    local numericIdentifier = tonumber(identifier)
    if numericIdentifier ~= nil then return numericIdentifier end
    if not IsValid(target) or not isstring(identifier) then return nil end
    local trimmedIdentifier = string.Trim(identifier)
    if trimmedIdentifier == "" then return nil end
    local directMatch = target:FindBodygroupByName(trimmedIdentifier)
    if isnumber(directMatch) and directMatch > -1 then return directMatch end
    local loweredIdentifier = string.lower(trimmedIdentifier)
    for _, groupData in ipairs(target:GetBodyGroups() or {}) do
        if isstring(groupData.name) and string.lower(groupData.name) == loweredIdentifier then return groupData.id end
    end
end

function lia.util.normalizeBodygroups(bodygroups)
    local normalized = {}
    if not istable(bodygroups) then return normalized end
    for _, entry in ipairs(bodygroups) do
        if istable(entry) then
            local index = lia.util.normalizeBodygroupKey(entry.id or entry.index or entry.bodygroup or entry.bodygroupID or entry.name or entry[1])
            local value = tonumber(entry.value or entry.val or entry[2] or 0) or 0
            if index ~= nil then normalized[index] = value end
        end
    end

    for key, value in pairs(bodygroups) do
        local index = lia.util.normalizeBodygroupKey(key)
        if index ~= nil and not istable(value) then normalized[index] = tonumber(value) or 0 end
    end
    return normalized
end

function lia.util.resolveBodygroups(target, bodygroups)
    local resolved = {}
    for identifier, value in pairs(lia.util.normalizeBodygroups(bodygroups)) do
        local index = lia.util.resolveBodygroupIndex(target, identifier)
        if index ~= nil then resolved[index] = tonumber(value) or 0 end
    end
    return resolved
end

function lia.util.applyBodygroups(target, bodygroups)
    if not IsValid(target) then return {} end
    local resolved = lia.util.resolveBodygroups(target, bodygroups)
    for index, value in pairs(resolved) do
        target:SetBodygroup(index, value)
    end
    return resolved
end

function lia.util.requestEntityInformation(client, entity, argTypes, callback)
    if not IsValid(entity) then
        ErrorNoHalt("[lia.util.requestEntityInformation] Invalid entity provided\n")
        return
    end

    client:requestArguments("Entity Information", argTypes, function(success, information)
        if not success then
            if IsValid(entity) then entity:Remove() end
        else
            if isfunction(callback) then callback(information) end
        end
    end)
end

function lia.util.getBySteamID(steamID)
    if not isstring(steamID) or steamID == "" then return end
    local sid = steamID
    if steamID:match("^%d+$") and #steamID >= 17 then sid = util.SteamIDFrom64(steamID) end
    for _, client in player.Iterator() do
        if client:SteamID() == sid and client:getChar() then return client end
    end
end

function lia.util.findPlayer(client, identifier)
    local isValidClient = IsValid(client)
    if not isstring(identifier) or identifier == "" then
        if isValidClient then client:notifyError("Must Provide a String") end
        return nil
    end

    if string.match(identifier, "^STEAM_%d+:%d+:%d+$") then
        local ply = lia.util.getBySteamID(identifier)
        if IsValid(ply) then return ply end
        if isValidClient then client:notifyError("Player does not exist.") end
        return nil
    end

    if string.match(identifier, "^%d+$") and #identifier >= 17 then
        local sid = util.SteamIDFrom64(identifier)
        if sid then
            local ply = lia.util.getBySteamID(sid)
            if IsValid(ply) then return ply end
        end

        if isValidClient then client:notifyError("Player does not exist.") end
        return nil
    end

    if isValidClient and identifier == "^" then return client end
    if isValidClient and identifier == "@" then
        local trace = client:getTracedEntity()
        if IsValid(trace) and trace:IsPlayer() then return trace end
        client:notifyError("You need to be looking at someone to use '@'")
        return nil
    end

    local safe = string.PatternSafe(identifier)
    for _, ply in player.Iterator() do
        if lia.util.stringMatches(ply:Name(), safe) then return ply end
    end

    if isValidClient then client:notifyError("Player does not exist.") end
    return nil
end

function lia.util.findPlayerItems(client)
    local items = {}
    for _, item in ents.Iterator() do
        if IsValid(item) and item:isItem() and item:GetCreator() == client then table.insert(items, item) end
    end
    return items
end

function lia.util.findPlayerItemsByClass(client, class)
    local items = {}
    for _, item in ents.Iterator() do
        if IsValid(item) and item:isItem() and item:GetCreator() == client and item:getNetVar("id") == class then table.insert(items, item) end
    end
    return items
end

function lia.util.stringMatches(a, b)
    if a and b then
        local a2, b2 = a:lower(), b:lower()
        if a == b then return true end
        if a2 == b2 then return true end
        if a:find(b) then return true end
        if a2:find(b2) then return true end
    end
    return false
end

function lia.util.findPlayerBySteamID(SteamID)
    for _, client in player.Iterator() do
        if client:SteamID() == SteamID then return client end
    end
    return nil
end

function lia.util.getMaterial(materialPath, materialParameters)
    lia.util.cachedMaterials = lia.util.cachedMaterials or {}
    lia.util.cachedMaterials[materialPath] = lia.util.cachedMaterials[materialPath] or Material(materialPath, materialParameters)
    return lia.util.cachedMaterials[materialPath]
end

function lia.util.findFaction(client, name)
    if lia.faction.teams[name] then return lia.faction.teams[name] end
    for _, v in ipairs(lia.faction.indices) do
        if lia.util.stringMatches(v.name, name) or lia.util.stringMatches(v.uniqueID, name) then return v end
    end

    client:notifyError("The specified faction is not valid.")
    return nil
end

if system.IsLinux() then
    local cache = {}
    local function GetSoundPath(path, gamedir)
        if not gamedir then
            path = "sound/" .. path
            gamedir = "GAME"
        end
        return path, gamedir
    end

    local function f_IsWAV(f)
        f:Seek(8)
        return f:Read(4) == "WAVE"
    end

    local function f_SampleDepth(f)
        f:Seek(34)
        local bytes = {}
        for i = 1, 2 do
            bytes[i] = f:ReadByte(1)
        end

        local num = bit.lshift(bytes[2], 8) + bit.lshift(bytes[1], 0)
        return num
    end

    local function f_SampleRate(f)
        f:Seek(24)
        local bytes = {}
        for i = 1, 4 do
            bytes[i] = f:ReadByte(1)
        end

        local num = bit.lshift(bytes[4], 24) + bit.lshift(bytes[3], 16) + bit.lshift(bytes[2], 8) + bit.lshift(bytes[1], 0)
        return num
    end

    local function f_Channels(f)
        f:Seek(22)
        local bytes = {}
        for i = 1, 2 do
            bytes[i] = f:ReadByte(1)
        end

        local num = bit.lshift(bytes[2], 8) + bit.lshift(bytes[1], 0)
        return num
    end

    local function f_Duration(f)
        return (f:Size() - 44) / (f_SampleDepth(f) / 8 * f_SampleRate(f) * f_Channels(f))
    end

    liaSoundDuration = liaSoundDuration or SoundDuration
    function SoundDuration(str)
        local path, gamedir = GetSoundPath(str)
        local f = file.Open(path, "rb", gamedir)
        if not f then return 0 end
        local ret
        if cache[str] then
            ret = cache[str]
        elseif f_IsWAV(f) then
            ret = f_Duration(f)
        else
            ret = liaSoundDuration(str)
        end

        f:Close()
        return ret
    end
end

function lia.util.generateRandomName(firstNames, lastNames)
    local defaultFirstNames = {"John", "Jane", "Michael", "Sarah", "David", "Emily", "Robert", "Amanda", "James", "Jennifer", "William", "Elizabeth", "Richard", "Michelle", "Thomas", "Lisa", "Daniel", "Stephanie", "Matthew", "Nicole", "Anthony", "Samantha", "Charles", "Mary", "Joseph", "Patricia", "Christopher", "Linda", "Andrew", "Barbara", "Joshua", "Susan", "Ryan", "Jessica", "Brandon", "Helen", "Tyler", "Nancy", "Kevin", "Betty", "Jason", "Sandra", "Jacob", "Donna", "Kyle", "Carol", "Nathan", "Ruth", "Jeffrey", "Sharon", "Frank", "Michelle", "Scott", "Laura", "Steven", "Sarah", "Nicholas", "Kimberly", "Gregory", "Deborah", "Eric", "Dorothy", "Stephen", "Amy", "Timothy", "Angela", "Larry", "Melissa", "Jonathan", "Brenda", "Raymond", "Emma", "Patrick", "Anna", "Benjamin", "Rebecca", "Bryan", "Virginia", "Samuel", "Kathleen", "Alexander", "Pamela", "Jack", "Martha", "Dennis", "Debra", "Jerry", "Amanda", "Tyler", "Stephanie", "Aaron", "Christine", "Henry", "Marie", "Douglas", "Janet", "Peter", "Catherine", "Jose", "Frances", "Adam", "Ann", "Zachary", "Joyce", "Walter", "Diane", "Kenneth", "Alice", "Ryan", "Julie", "Gregory", "Heather", "Austin", "Teresa", "Keith", "Doris", "Samuel", "Gloria", "Gary", "Evelyn", "Jesse", "Jean", "Joe", "Cheryl", "Billy", "Mildred", "Bruce", "Katherine", "Gabriel", "Joan", "Roy", "Ashley", "Albert", "Judith", "Willie", "Rose", "Logan", "Janice", "Randy", "Kelly", "Louis", "Nicole", "Russell", "Judy", "Ralph", "Christina", "Sean", "Kathy", "Eugene", "Theresa", "Vincent", "Beverly", "Bobby", "Denise", "Johnny", "Tammy", "Bradley", "Irene", "Philip", "Jane", "Todd", "Lori", "Jesse", "Rachel", "Craig", "Marilyn", "Alan", "Andrea", "Shawn", "Kathryn", "Clarence", "Louise", "Sean", "Sara", "Victor", "Anne", "Jimmy", "Jacqueline", "Chad", "Wanda", "Phillip", "Bonnie", "Travis", "Julia", "Carlos", "Ruby", "Shane", "Lois", "Ronald", "Tina", "Brandon", "Phyllis", "Angel", "Norma", "Russell", "Paula", "Harold", "Diana", "Dustin", "Annie", "Pedro", "Lillian", "Shawn", "Emily", "Colin", "Robin", "Brian", "Rita"}
    local defaultLastNames = {"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green", "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter", "Roberts", "Gomez", "Phillips", "Evans", "Turner", "Diaz", "Parker", "Cruz", "Edwards", "Collins", "Reyes", "Stewart", "Morris", "Morales", "Murphy", "Cook", "Rogers", "Gutierrez", "Ortiz", "Morgan", "Cooper", "Peterson", "Bailey", "Reed", "Kelly", "Howard", "Ramos", "Kim", "Cox", "Ward", "Richardson", "Watson", "Brooks", "Chavez", "Wood", "James", "Bennett", "Gray", "Mendoza", "Ruiz", "Hughes", "Price", "Alvarez", "Castillo", "Sanders", "Patel", "Myers", "Long", "Ross", "Foster", "Jimenez", "Powell", "Jenkins", "Perry", "Russell", "Sullivan", "Bell", "Coleman", "Butler", "Henderson", "Barnes", "Gonzales", "Fisher", "Vasquez", "Simmons", "Romero", "Jordan", "Patterson", "Alexander", "Hamilton", "Graham", "Reynolds", "Griffin", "Wallace", "Moreno", "West", "Cole", "Hayes", "Bryant", "Herrera", "Gibson", "Ellis", "Tran", "Medina", "Aguilar", "Stevens", "Murray", "Ford", "Castro", "Marshall", "Owens", "Harrison", "Fernandez", "McDonald", "Woods", "Washington", "Kennedy", "Wells", "Vargas", "Henry", "Chen", "Freeman", "Webb", "Tucker", "Guzman", "Burns", "Crawford", "Olson", "Simpson", "Porter", "Hunter", "Gordon", "Mendez", "Silva", "Shaw", "Snyder", "Mason", "Dixon", "Munoz", "Hunt", "Hicks", "Holmes", "Palmer", "Wagner", "Black", "Robertson", "Boyd", "Rose", "Stone", "Salazar", "Fox", "Warren", "Mills", "Meyer", "Rice", "Schmidt", "Garza", "Daniels", "Ferguson", "Nichols", "Stephens", "Soto", "Weaver", "Ryan", "Gardner", "Payne", "Grant", "Dunn", "Kelley", "Spencer", "Hawkins", "Arnold", "Pierce", "Vazquez", "Hansen", "Peters", "Santos", "Hart", "Bradley", "Knight", "Elliott", "Cunningham", "Duncan", "Armstrong", "Hudson", "Carroll", "Lane", "Riley", "Andrews", "Alvarado", "Ray", "Delgado", "Berry", "Perkins", "Hoffman", "Johnston", "Matthews", "Pena", "Richards", "Contreras", "Willis", "Carpenter", "Lawrence", "Sandoval"}
    local firstNameList = firstNames or defaultFirstNames
    local lastNameList = lastNames or defaultLastNames
    if not istable(firstNameList) or #firstNameList == 0 then firstNameList = defaultFirstNames end
    if not istable(lastNameList) or #lastNameList == 0 then lastNameList = defaultLastNames end
    local firstIndex = math.random(1, #firstNameList)
    local lastIndex = math.random(1, #lastNameList)
    return firstNameList[firstIndex] .. " " .. lastNameList[lastIndex]
end

lia.util.positionCallbacks = lia.util.positionCallbacks or {}
lia.util.featurePositionTypes = lia.util.featurePositionTypes or {}
function lia.util.setPositionCallback(name, data)
    if not isstring(name) or not istable(data) then return end
    if not isfunction(data.onRun) or not isfunction(data.onSelect) then return end
    local id = string.lower(name):gsub("%s+", "_")
    local serverOnly = data.serverOnly == true
    local color = data.color or Color(255, 255, 255)
    lia.util.positionCallbacks[id] = {
        id = id,
        name = name,
        color = color,
        onRun = data.onRun,
        onRemove = data.onRemove,
        onSelect = data.onSelect,
        HUDPaint = data.HUDPaint,
        serverOnly = serverOnly
    }

    local found = false
    for i = 1, #lia.util.featurePositionTypes do
        if lia.util.featurePositionTypes[i].id == id then
            lia.util.featurePositionTypes[i].name = name
            lia.util.featurePositionTypes[i].color = color
            found = true
            break
        end
    end

    if not found then
        table.insert(lia.util.featurePositionTypes, {
            id = id,
            name = name,
            color = color
        })
    end
end

if SERVER then
    function lia.util.sendTableUI(client, title, columns, data, options, characterID)
        if not IsValid(client) or not client:IsPlayer() then return end
        local localizedColumns = {}
        for i, colInfo in ipairs(columns or {}) do
            local localizedColInfo = table.Copy(colInfo)
            if localizedColInfo.name then localizedColInfo.name = localizedColInfo.name end
            localizedColumns[i] = localizedColInfo
        end

        local tableUIData = {
            title = title and title or "Table List",
            columns = localizedColumns,
            data = data,
            options = options or {},
            characterID = characterID
        }

        lia.net.writeBigTable(client, "liaSendTableUI", tableUIData)
    end

    function lia.util.findEmptySpace(entity, filter, spacing, size, height, tolerance)
        spacing = spacing or 32
        size = size or 3
        height = height or 36
        tolerance = tolerance or 5
        local position = entity:GetPos()
        local mins = Vector(-spacing * 0.5, -spacing * 0.5, 0)
        local maxs = Vector(spacing * 0.5, spacing * 0.5, height)
        local output = {}
        for x = -size, size do
            for y = -size, size do
                local origin = position + Vector(x * spacing, y * spacing, 0)
                local data = {}
                data.start = origin + mins + Vector(0, 0, tolerance)
                data.endpos = origin + maxs
                data.filter = filter or entity
                local trace = util.TraceLine(data)
                data.start = origin + Vector(-maxs.x, -maxs.y, tolerance)
                data.endpos = origin + Vector(mins.x, mins.y, height)
                local trace2 = util.TraceLine(data)
                if trace.StartSolid or trace.Hit or trace2.StartSolid or trace2.Hit or not util.IsInWorld(origin) then continue end
                output[#output + 1] = origin
            end
        end

        table.sort(output, function(a, b) return a:Distance(position) < b:Distance(position) end)
        return output
    end
else
    lia.util.drawText = lia.derma.drawText
    lia.util.approachExp = lia.derma.approachExp
    local easeInOutCubic = lia.derma.easeInOutCubic
    function lia.util.animateAppearance(panel, targetWidth, targetHeight, duration, alphaDuration, callback, scaleFactor)
        scaleFactor = scaleFactor or 0.8
        if not IsValid(panel) then return end
        duration = (duration and duration > 0) and duration or 0.18
        alphaDuration = (alphaDuration and alphaDuration > 0) and alphaDuration or duration
        local targetX, targetY = panel:GetPos()
        local initialW = targetWidth * (scaleFactor and scaleFactor or scaleFactor)
        local initialH = targetHeight * (scaleFactor and scaleFactor or scaleFactor)
        local initialX = targetX + (targetWidth - initialW) / 2
        local initialY = targetY + (targetHeight - initialH) / 2
        panel:SetSize(initialW, initialH)
        panel:SetPos(initialX, initialY)
        panel:SetAlpha(0)
        local curW, curH = initialW, initialH
        local curX, curY = initialX, initialY
        local curA = 0
        local eps = 0.5
        local alpha_eps = 1
        local speedSize = 3 / math.max(0.0001, duration)
        local speedAlpha = 3 / math.max(0.0001, alphaDuration)
        panel.Think = function()
            if not IsValid(panel) then return end
            local dt = FrameTime()
            curW = lia.util.approachExp(curW, targetWidth, speedSize, dt)
            curH = lia.util.approachExp(curH, targetHeight, speedSize, dt)
            curX = lia.util.approachExp(curX, targetX, speedSize, dt)
            curY = lia.util.approachExp(curY, targetY, speedSize, dt)
            curA = lia.util.approachExp(curA, 255, speedAlpha, dt)
            panel:SetSize(curW, curH)
            panel:SetPos(curX, curY)
            panel:SetAlpha(math.floor(curA + 0.5))
            local doneSize = math.abs(curW - targetWidth) <= eps and math.abs(curH - targetHeight) <= eps
            local donePos = math.abs(curX - targetX) <= eps and math.abs(curY - targetY) <= eps
            local doneAlpha = math.abs(curA - 255) <= alpha_eps
            if doneSize and donePos and doneAlpha then
                panel:SetSize(targetWidth, targetHeight)
                panel:SetPos(targetX, targetY)
                panel:SetAlpha(255)
                panel.Think = nil
                if callback then callback(panel) end
            end
        end
    end

    function lia.util.wrapText(text, width, font, maxLines, ellipsis)
        text = tostring(text or "")
        width = tonumber(width) or 0
        font = font or "LiliaFont.16"
        maxLines = maxLines and math.floor(tonumber(maxLines) or 0) or math.huge
        ellipsis = ellipsis and tostring(ellipsis) or nil
        surface.SetFont(font)
        local _, lineHeight = surface.GetTextSize("Ag")
        local lines = {}
        if width <= 0 or maxLines <= 0 then return lines, lineHeight end

        local line = ""
        local truncated = false
        local function addLine(value)
            if #lines >= maxLines then
                truncated = true
                return false
            end

            lines[#lines + 1] = value
            return true
        end

        local function splitWord(word)
            local splitLine = ""
            for char in word:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
                local candidate = splitLine .. char
                if splitLine ~= "" and surface.GetTextSize(candidate) > width then
                    if not addLine(splitLine) then return false end
                    splitLine = char
                elseif surface.GetTextSize(candidate) <= width then
                    splitLine = candidate
                else
                    if not addLine(char) then return false end
                    splitLine = ""
                end
            end

            line = splitLine
            return true
        end

        for textLine in (text .. "\n"):gmatch("(.-)\n") do
            local hadWord = false
            for word in textLine:gmatch("%S+") do
                hadWord = true
                local candidate = line == "" and word or line .. " " .. word
                if surface.GetTextSize(candidate) <= width then
                    line = candidate
                else
                    if line ~= "" then
                        if not addLine(line) then break end
                        line = ""
                    end

                    if surface.GetTextSize(word) <= width then
                        line = word
                    elseif not splitWord(word) then
                        break
                    end
                end
            end

            if truncated then break end
            if line ~= "" then
                if not addLine(line) then break end
                line = ""
            elseif not hadWord then
                if not addLine("") then break end
            end
        end

        if line ~= "" and not truncated then addLine(line) end
        if truncated and ellipsis and #lines > 0 then
            local lastLine = lines[#lines]
            while lastLine ~= "" and surface.GetTextSize(lastLine .. ellipsis) > width do
                lastLine = lastLine:sub(1, -2)
            end

            if surface.GetTextSize(lastLine .. ellipsis) <= width then
                lines[#lines] = lastLine .. ellipsis
            else
                lines[#lines] = ellipsis
            end
        end

        return lines, lineHeight
    end

    function lia.util.drawBlur(panel, amount, passes, alpha)
        amount = amount or 5
        alpha = alpha or 255
        local maxPasses = 3
        surface.SetMaterial(lia.util.getMaterial("pp/blurscreen"))
        surface.SetDrawColor(255, 255, 255, alpha)
        local x, y = panel:LocalToScreen(0, 0)
        local blurMat = lia.util.getMaterial("pp/blurscreen")
        for i = 0, maxPasses do
            local blurValue = (i / maxPasses) * amount
            blurMat:SetFloat("$blur", blurValue)
            blurMat:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end

    function lia.util.drawBlackBlur(panel, amount, passes, alpha, darkAlpha)
        if not IsValid(panel) then return end
        amount = amount or 6
        passes = math.max(1, passes or 5)
        alpha = alpha or 255
        darkAlpha = darkAlpha or 220
        local mat = lia.util.getMaterial("pp/blurscreen")
        local x, y = panel:LocalToScreen(0, 0)
        x = math.floor(x)
        y = math.floor(y)
        local sw, sh = ScrW(), ScrH()
        local expand = 4
        render.UpdateScreenEffectTexture()
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255, alpha)
        for i = 1, passes do
            mat:SetFloat("$blur", i / passes * amount)
            mat:Recompute()
            surface.DrawTexturedRectUV(-x - expand, -y - expand, sw + expand * 2, sh + expand * 2, 0, 0, 1, 1)
        end

        surface.SetDrawColor(0, 0, 0, darkAlpha)
        surface.DrawRect(x, y, panel:GetWide(), panel:GetTall())
    end

    function lia.util.drawBlurAt(x, y, w, h, amount, passes, alpha)
        amount = amount or 5
        alpha = alpha or 255
        surface.SetMaterial(lia.util.getMaterial("pp/blurscreen"))
        surface.SetDrawColor(255, 255, 255, alpha)
        local x2, y2 = x / ScrW(), y / ScrH()
        local w2, h2 = (x + w) / ScrW(), (y + h) / ScrH()
        for i = -(passes or 0.2), 1, 0.2 do
            lia.util.getMaterial("pp/blurscreen"):SetFloat("$blur", i * amount)
            lia.util.getMaterial("pp/blurscreen"):Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRectUV(x, y, w, h, x2, y2, w2, h2)
        end
    end

    lia.util.requestArguments = lia.derma.requestArguments
    function lia.util.createTableUI(title, columns, data, options, charID)
        local frameWidth, frameHeight = ScrW() * 0.8, ScrH() * 0.8
        local frame = vgui.Create("liaFrame")
        frame:SetTitle(title and title or "Table List")
        frame:SetSize(frameWidth, frameHeight)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(true)
        frame.Paint = function(self, w, h)
            lia.util.drawBlur(self, 4)
            draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 120))
        end

        local listView = frame:Add("liaTable")
        listView:Dock(FILL)
        for _, colInfo in ipairs(columns or {}) do
            local localizedName = colInfo.name and colInfo.name or "N/A"
            listView:AddColumn(localizedName, colInfo.width, colInfo.align, colInfo.sortable)
        end

        for _, row in ipairs(data) do
            local lineData = {}
            for _, colInfo in ipairs(columns) do
                table.insert(lineData, row[colInfo.field] or "N/A")
            end

            local line = listView:AddLine(unpack(lineData))
            line.rowData = row
        end

        listView:ForceCommit()
        listView:AddMenuOption("Copy Row", function(rowData)
            local rowString = ""
            for key, value in pairs(rowData) do
                value = tostring(value or "N/A")
                key = tostring(key)
                rowString = rowString .. key:gsub("^%l", string.upper) .. " " .. value .. " | "
            end

            rowString = rowString:sub(1, -4)
            SetClipboardText(rowString)
        end)

        for _, option in ipairs(istable(options) and options or {}) do
            listView:AddMenuOption(option.name and option.name or option.name, function(rowData, rowIndex)
                if not option.net then return end
                if option.ExtraFields then
                    local inputPanel = vgui.Create("liaFrame")
                    inputPanel:SetTitle(string.format("%s Options", option.name))
                    inputPanel:SetSize(300, 300 + #table.GetKeys(option.ExtraFields) * 35)
                    inputPanel:Center()
                    inputPanel:MakePopup()
                    local form = vgui.Create("DForm", inputPanel)
                    form:Dock(FILL)
                    form:SetLabel("")
                    form.Paint = function() end
                    local inputs = {}
                    for fName, fType in pairs(option.ExtraFields) do
                        local label = vgui.Create("DLabel", form)
                        label:SetText(fName)
                        label:Dock(TOP)
                        label:DockMargin(5, 10, 5, 0)
                        form:AddItem(label)
                        if isstring(fType) and fType == "text" then
                            local entry = vgui.Create("DTextEntry", form)
                            entry:Dock(TOP)
                            entry:DockMargin(5, 5, 5, 0)
                            entry:SetPlaceholderText(string.format("Type %s", fName))
                            form:AddItem(entry)
                            inputs[fName] = {
                                panel = entry,
                                ftype = "text"
                            }
                        elseif isstring(fType) and fType == "combo" then
                            local combo = vgui.Create("liaComboBox", form)
                            combo:Dock(TOP)
                            combo:DockMargin(5, 5, 5, 0)
                            combo:PostInit()
                            combo:SetValue(string.format("Select %s", fName))
                            form:AddItem(combo)
                            inputs[fName] = {
                                panel = combo,
                                ftype = "combo"
                            }
                        elseif istable(fType) then
                            local combo = vgui.Create("liaComboBox", form)
                            combo:Dock(TOP)
                            combo:DockMargin(5, 5, 5, 0)
                            combo:PostInit()
                            combo:SetValue(string.format("Select %s", fName))
                            for _, choice in ipairs(fType) do
                                combo:AddChoice(choice)
                            end

                            combo:FinishAddingOptions()
                            form:AddItem(combo)
                            inputs[fName] = {
                                panel = combo,
                                ftype = "combo"
                            }
                        end
                    end

                    local submitButton = vgui.Create("DButton", form)
                    submitButton:SetText("Submit")
                    submitButton:Dock(TOP)
                    submitButton:DockMargin(5, 10, 5, 0)
                    form:AddItem(submitButton)
                    submitButton.DoClick = function()
                        local values = {}
                        for fName, info in pairs(inputs) do
                            if not IsValid(info.panel) then continue end
                            if info.ftype == "text" then
                                values[fName] = info.panel:GetValue() or ""
                            elseif info.ftype == "combo" then
                                values[fName] = info.panel:GetSelected() or ""
                            end
                        end

                        net.Start(option.net)
                        net.WriteInt(charID, 32)
                        net.WriteTable(rowData)
                        for _, fVal in pairs(values) do
                            if isnumber(fVal) then
                                net.WriteInt(fVal, 32)
                            else
                                net.WriteString(fVal)
                            end
                        end

                        net.SendToServer()
                        inputPanel:Close()
                        frame:Remove()
                    end
                else
                    net.Start(option.net)
                    net.WriteInt(charID, 32)
                    net.WriteTable(rowData)
                    net.SendToServer()
                    frame:Remove()
                end
            end)
        end

        timer.Simple(0.1, function()
            if IsValid(frame) and IsValid(listView) then
                frame:InvalidateLayout(true)
                listView:InvalidateLayout(true)
                frame:SizeToChildren(false, true)
            end
        end)
        return frame, listView
    end

    local vectorMeta = FindMetaTable("Vector")
    local toScreen = vectorMeta and vectorMeta.ToScreen or function()
        return {
            x = 0,
            y = 0,
            visible = false
        }
    end

    local defaultTheme = {
        background_alpha = Color(34, 34, 34, 210),
        header = Color(34, 34, 34, 210),
        accent = Color(255, 255, 255, 180),
        text = Color(255, 255, 255)
    }

    local function scaleColorAlpha(col, scale)
        col = col or defaultTheme.background_alpha
        local a = col.a or 255
        return Color(col.r, col.g, col.b, math.Clamp(a * scale, 0, 255))
    end

    local function EntText(text, x, y, fade)
        surface.SetFont("LiliaFont.24")
        local tw, th = surface.GetTextSize(text)
        local bx, by = math.Round(x - tw * 0.5 - 8), math.Round(y - 8)
        local bw, bh = tw + 16, th + 16
        local theme = lia.color.theme or defaultTheme
        local fadeAlpha = math.Clamp(fade, 0, 1)
        local headerColor = scaleColorAlpha(theme.background_panelpopup or theme.header or defaultTheme.header, fadeAlpha)
        local accentColor = scaleColorAlpha(theme.theme or theme.text or defaultTheme.accent, fadeAlpha)
        local textColor = scaleColorAlpha(theme.text or defaultTheme.text, fadeAlpha)
        lia.util.drawBlurAt(bx, by, bw, bh - 6, 6, 0.2, math.floor(fadeAlpha * 255))
        lia.derma.rect(bx, by, bw, bh - 6):Radii(12, 12, 0, 0):Color(headerColor):Shape(lia.derma.SHAPE_IOS):Draw()
        local themeColor = theme.theme or color_white
        surface.SetDrawColor(themeColor.r, themeColor.g, themeColor.b, math.floor(40 * fadeAlpha))
        surface.DrawRect(bx, by + bh - 6 - 1, bw, 1)
        lia.derma.rect(bx, by + bh - 6, bw, 6):Radii(0, 0, 12, 12):Color(accentColor):Draw()
        draw.SimpleText(text, "LiliaFont.24", math.Round(x), math.Round(y - 2), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        return bh
    end

    local function DrawEntityInfoBoxAt(x, y, title, rows, fade, xOffset)
        local theme = lia.color.theme or defaultTheme
        local fadeAlpha = math.Clamp(fade, 0, 1)
        local accent = theme.accent or theme.theme or defaultTheme.accent or color_white
        local titleText = string.Trim(tostring(title or ""))
        local cleanRows = {}
        for i = 1, #(rows or {}) do
            local row = rows[i]
            if istable(row) then
                if row.divider then
                    cleanRows[#cleanRows + 1] = {
                        divider = true
                    }
                else
                    local preparedRow = table.Copy(row)
                    if isstring(preparedRow.text) then preparedRow.text = string.Trim(preparedRow.text) end
                    if isstring(preparedRow.label) then preparedRow.label = string.Trim(preparedRow.label) end
                    if isstring(preparedRow.value) then preparedRow.value = string.Trim(preparedRow.value) end
                    if isstring(preparedRow.section) then preparedRow.section = string.Trim(preparedRow.section) end
                    if preparedRow.section and preparedRow.section ~= "" then
                        cleanRows[#cleanRows + 1] = {
                            section = preparedRow.section
                        }
                    elseif (preparedRow.text and preparedRow.text ~= "") or (preparedRow.label and preparedRow.label ~= "") or (preparedRow.value and preparedRow.value ~= "") then
                        cleanRows[#cleanRows + 1] = preparedRow
                    end
                end
            else
                local textRow = string.Trim(tostring(row or ""))
                if textRow ~= "" then cleanRows[#cleanRows + 1] = textRow end
            end
        end

        if titleText == "" and #cleanRows == 0 then return end
        return lia.derma.drawBoxWithText(nil, math.Round(x + (xOffset or 28)), math.Round(y), {
            title = titleText ~= "" and titleText or nil,
            rows = cleanRows,
            font = "LiliaFont.18",
            textAlignX = TEXT_ALIGN_LEFT,
            textAlignY = TEXT_ALIGN_TOP,
            padding = 12,
            rowHeight = 18,
            autoSize = true,
            richText = false,
            backgroundColor = Color(3, 18, 22, math.floor(232 * fadeAlpha)),
            borderColor = Color(accent.r, accent.g, accent.b, math.floor(110 * fadeAlpha)),
            textColor = scaleColorAlpha(theme.text or defaultTheme.text, fadeAlpha),
            mutedTextColor = scaleColorAlpha(theme.mutedText or theme.text or defaultTheme.text, fadeAlpha),
            accentColor = Color(accent.r, accent.g, accent.b, math.floor(255 * fadeAlpha)),
            accentAlpha = math.floor(210 * fadeAlpha),
            shadow = {
                enabled = true,
                color = Color(0, 0, 0, math.floor(125 * fadeAlpha)),
                offsetX = 8,
                offsetY = 14
            },
            blur = {
                enabled = true,
                amount = 2,
                passes = 2,
                alpha = 0.65 * fadeAlpha
            },
            overlapMargin = 4
        })
    end

    lia.util.entsScales = lia.util.entsScales or {}
    function lia.util.drawEntText(ent, text, posY, alphaOverride)
        if not (IsValid(ent) and text and text ~= "") then return end
        posY = posY or 0
        local distSqr = EyePos():DistToSqr(ent:GetPos())
        local maxDist = 380
        if distSqr > maxDist * maxDist then return end
        local dist = math.sqrt(distSqr)
        local minDist = 20
        local idx = ent:EntIndex()
        local prev = lia.util.entsScales[idx] or 0
        local normalized = math.Clamp((maxDist - dist) / math.max(1, maxDist - minDist), 0, 1)
        local appearThreshold = 0.8
        local disappearThreshold = 0.01
        local target
        if normalized <= disappearThreshold then
            target = 0
        elseif normalized >= appearThreshold then
            target = 1
        else
            target = (normalized - disappearThreshold) / (appearThreshold - disappearThreshold)
        end

        local dt = FrameTime() or 0.016
        local appearSpeed = 18
        local disappearSpeed = 12
        local speed = (target > prev) and appearSpeed or disappearSpeed
        local cur = lia.util.approachExp(prev, target, speed, dt)
        if math.abs(cur - target) < 0.0005 then cur = target end
        if cur == 0 and target == 0 then
            lia.util.entsScales[idx] = nil
            return
        end

        lia.util.entsScales[idx] = cur
        local eased = easeInOutCubic(cur)
        if eased <= 0 then return end
        local fade = eased
        if alphaOverride then
            if alphaOverride > 1 then
                fade = fade * math.Clamp(alphaOverride / 255, 0, 1)
            else
                fade = fade * math.Clamp(alphaOverride, 0, 1)
            end
        end

        if fade <= 0 then return end
        local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
        local _, rotatedMax = ent:GetRotatedAABB(mins, maxs)
        local bob = math.sin(CurTime() + idx) / 3 + 0.5
        local center = ent:LocalToWorld(ent:OBBCenter()) + Vector(0, 0, math.abs(rotatedMax.z / 2) + 12 + bob)
        local screenPos = toScreen(center)
        if screenPos.visible == false then return end
        EntText(text, screenPos.x, screenPos.y + posY, fade)
    end

    function lia.util.setFeaturePosition(pos, typeId)
    end

    function lia.util.setFeaturePosition(pos, typeId)
        if not isvector(pos) or not isstring(typeId) then return end
        local callback = lia.util.positionCallbacks[typeId]
        if not callback or not callback.onRun then return end
        local client = LocalPlayer()
        if not IsValid(client) then return end
        if callback.serverOnly then
            callback.onRun(pos, client, typeId)
        else
            callback.onRun(pos, client, typeId)
        end
    end

    function lia.util.removeFeaturePosition(pos, typeId)
        if not isvector(pos) or not isstring(typeId) then return end
        local callback = lia.util.positionCallbacks[typeId]
        if not callback or not callback.onRemove then return end
        local client = LocalPlayer()
        if not IsValid(client) then return end
        if callback.serverOnly then
            net.Start("liaRemoveFeaturePosition")
            net.WriteString(typeId)
            net.WriteVector(pos)
            net.SendToServer()
        else
            callback.onRemove(pos, client, typeId)
        end
    end

    function lia.util.drawESPStyledText(text, x, y, espColor, font, fadeAlpha)
        fadeAlpha = fadeAlpha or 1
        surface.SetFont(font)
        local tw, th = surface.GetTextSize(text)
        local bx, by = math.Round(x - tw * 0.5 - 8), math.Round(y - 8)
        local bw, bh = tw + 16, th + 16
        local theme = lia.color.theme or defaultTheme
        local headerColor = scaleColorAlpha(theme.background_panelpopup or theme.header or defaultTheme.header, fadeAlpha)
        local accentColor = scaleColorAlpha(espColor or theme.theme or theme.text or defaultTheme.accent, fadeAlpha)
        local textColor = scaleColorAlpha(theme.text or defaultTheme.text, fadeAlpha)
        lia.util.drawBlurAt(bx, by, bw, bh - 6, 6, 0.2, math.floor(fadeAlpha * 255))
        lia.derma.rect(bx, by, bw, bh - 6):Radii(8, 8, 0, 0):Color(headerColor):Shape(lia.derma.SHAPE_IOS):Draw()
        lia.derma.rect(bx, by + bh - 6, bw, 6):Radii(0, 0, 8, 8):Color(accentColor):Draw()
        draw.SimpleText(text, font, math.Round(x), math.Round(y - 2), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        return bh
    end
end
